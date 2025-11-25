Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9358D0E6DB
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 12:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AF36B0027; Tue, 25 Nov 2025 07:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0510B6B0028; Tue, 25 Nov 2025 07:55:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7936B002A; Tue, 25 Nov 2025 07:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DAB786B0027
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:55:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95A1C8A235
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:55:30 +0000 (UTC)
X-FDA: 84149125620.30.0AE4602
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 945C710000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:55:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IVXbuc+O;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764075328; a=rsa-sha256;
	cv=none;
	b=w68JRTfxzOzNqeGSsJbu0Y87WAut8CI232V2Y1Xa6UHJM3otXZ060xqUDwscmN4K8C+s8J
	4NsWCQT9K82xvOXlZG+oSJn/hcB9Slh8GUI9KtiP4aaiIb+XjzVCRmuqEpJXyMPA3ZvRwu
	4ouYIyaqwNTsbXgDsH/36UZzM6m3xpM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IVXbuc+O;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764075328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usCzcCtVI6XgCiCu4NS8NEIAX55CiKwZAm0iUXb+TsA=;
	b=Zx+ap+1BfJcLFsCf1047ZlfLHr/hzKAsxp1xIkOnV6Bou8PT/GWXIBc7D6u91KF0xZ2C78
	8rbwJBYkIZF/hkNkTXUH0W/f8BRRdcETmQUCLLklWFOi2BnIGZy+Tuuhpq3N+zfz+iCz3f
	QMzpOgLX6MF73sFIlBP2/OX6QocxdRc=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477b1cc8fb4so31283915e9.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764075327; x=1764680127; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=usCzcCtVI6XgCiCu4NS8NEIAX55CiKwZAm0iUXb+TsA=;
        b=IVXbuc+OS7r7v65iQZ1gEl6iRdBxXUDgleBjip780GLmev/GXxn34gLNpPTvtSIEkD
         HlWhNgGNA/p3jEaDht97JqM+KKGsJXRofztPLM/XUMYkolLXN+6x0mA+LHB/zc2LYHRQ
         heHJt+44f0lEAoLLceiSkeXD7bepmDQ7W598MD5GQaLYGa38S2EpFYAibJmIs/OKO9fD
         34t69V5UDJnjVeGgDFmNc6ntuFZlr/65JO+spIsbCpE6ppekwTwu9F7uBPMotmslPgD/
         MtdoOhiWbk0OsJRY2cr+hMC2r0oUgHnzBQ382AbJ6B+DcqpiLjxH/D8z9qVE3ug8ySwr
         CZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764075327; x=1764680127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usCzcCtVI6XgCiCu4NS8NEIAX55CiKwZAm0iUXb+TsA=;
        b=FGP8Cv9cmqKJIzZ0P1u95uV7KVeH5cWEoRzY/LSadrvkJVOy4jb7s2YXE4/SIEjA6H
         o8/0tOc1Br+kaE/IdQQbbcmqqYvH2RcRYyG/psWF6JsN4+M4wnRz3f/nluLzKt1wZXju
         E9US+ZWrumtJKKlSelw5ekXp5LJ6/Qrsu3b9WLyCjNNCAICFV5UWbYQserW1WCDmUCvQ
         bVV07MOMaiUsTOpzq38Q/IohBwdlXnDkeFgYjCz8NUwk/3TR67/t7P+iD+BeZxBNl3N+
         xv9Whyzk1+JW4ez0mOviFqnHSkd6k5HM0ZLLO2plHPw5utZykvgkifoCKoyss+yMNbdZ
         CifA==
X-Forwarded-Encrypted: i=1; AJvYcCVoYqO2O2hE+YF0O0GgjgraeqJaZXphdm1qA37jxcvJVyEpWuifjzsxbtOR2twUfgGyShiYg2+DpQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5b3UO2sA09yhxMhujsTya8t8Y13uehz/IhiOANrOWF6TWpewH
	wQi9XS7+belNd0Mw4ufY+EKyJBd0bdLNYcXKeDuRE5H6yIzoCLuEl90OpPzp+aee8Xk=
X-Gm-Gg: ASbGncvmu1JqaVlZ7RDq04fT6xi2rATqqKL4niK4Pf6T7xUPP92KddWpm7WQqD2zD/b
	FiGtAuQfuwpTbkKA6TV5BPqXmRTxl++z2jKlvDfx0QZq/EZJB87OCgGwDdOwCEm5aRoMj1XYf2d
	uNMiSjPgUCbthBF2JU40B3jM0VlmhhEqAmbQMmK9SFX1L17ZwCbzH5lajH4Ijefvs6Eqot1/1NE
	4FHuMkydb1t/sxrFNe1bF1e7MvIcT+4azN8T9xR5MpOoDS7pum1rORTJrO10CI/+JQGqH+2VQBA
	+e76TW41TKw+SWghkDIWLW8j9NRz+tFm3nopyVMTSI3niOQOH2i4qXBrcyQFn2XEB7qrejeAZr2
	vA+cfC9yeq3mc0kH2eyIvprhdUR005uJLuZ1dPcfA2a6DelXfv6dvSEh8/V6wGTUoYo+0ed3iQG
	hZEXJY5wSm4bl81LdSM483PB/A
X-Google-Smtp-Source: AGHT+IHeNFHz77PnS9U9y/LXSC6SdqMAwMHknNtAmvznPS8Yog8Q67/4L/1KHix1NRlDrhL8Rpv3qQ==
X-Received: by 2002:a05:600c:3112:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47904b2b2e0mr24822815e9.32.1764075327005;
        Tue, 25 Nov 2025 04:55:27 -0800 (PST)
Received: from localhost (109-81-29-251.rct.o2.cz. [109.81.29.251])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040bd209sm18794505e9.3.2025.11.25.04.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 04:55:26 -0800 (PST)
Date: Tue, 25 Nov 2025 13:55:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: hui.zhu@linux.dev
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] Memory Controller eBPF support
Message-ID: <aSWnPfYXRYxCDXG3@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
 <aR9p8n3VzpNHdPFw@tiehlicka>
 <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
 <aSWdSlhU3acQ9Rq1@tiehlicka>
 <6ff7dad904bcb27323ea21977e1160ebfa5e283d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ff7dad904bcb27323ea21977e1160ebfa5e283d@linux.dev>
X-Rspamd-Queue-Id: 945C710000C
X-Rspamd-Server: rspam07
X-Stat-Signature: xxsiu1jdwb8axy947o7m9o9keze7zzy8
X-Rspam-User: 
X-HE-Tag: 1764075328-441425
X-HE-Meta: U2FsdGVkX18p1zfYb5bVBZkQGmVrrLYa2Un3vYd+mx2DVr8P49h60zAPzYHI+4/H98G1+SgYSYyl0gz3W5/xDhe7x/X0p0Ybg02MgDleRuZD/zZpewXjiMhiNPDbWMTwVWCY7kN0ZvpEU2Qt2BaziiwDXrZInh1JbPlW6VieiQfm9QlgYINLH7CbFpDOIP0smqmulwdltN32VMBksiZetlD2C4Mqklu+Lx1vUb3+RWgciFwkLROPvaciTWlFVbEHGtksJYR4uS/Y8afHZui8ZMr52sz5GH+S5oLrVxk0AfgEambl7PZMqeI5qBcxJftkmHZMvIrzizYBGiCZrH/8OTJDPhrcQNwcaUhROoj9HnYL3qLizeZmgclf8CFE8zEcw2+bsG33kogCuc+rUTX+T2eO7ld8TcvxohVKSXgVBGxgeAKIFr52IEVTFXyZMaETd9ChjUF1uM/nfwN/A9QBT0LCIyZoCk7phY1zTJc3txIJe4kC28MeIeHfCuPl9qaNkte8yDh9ekpi8ieEB9KGjRINtZzCx/Y3TttWjbFetl2kbQ+i/XaoAXXyLrM0d2SCS39I0fu7fXfMHZJ+EwpefCwtObatpp9eiSck44oD+i/KlqHDrTQx8Up0KOxOgozaONRWWEYL+FRqA8fMjKigB0AORowaUCvpgo21CP92i4LqRidT3xr5LVq9eeLpd6vxMlNKcy9OzonLvehUSdV2vqO4Y0VFjmO5pWnqpmH/RFKXFcD4QhdpW3AP0aM9Vz4Y7RA3l+ptAT7LT2aHCKkgi6xuNKGc+dYPA87T2CiOG1nwE3LizyFiNrEfOEfVym/oYbb9fhY+qXLc2FAvda4bsXHcFJLJg8xmW6Tu+VQ1aSDjoMwnPkc2mX9PdZC89uBk2XVsQ1ALKjbf3FTlBP3ltPk+k7K6B0upZqvFs1IPp8xbzwj2gMQ/jIgf2VBnT8py3rA61Y/fMCItUizLMqy
 H1hj3zoM
 eyMv7sdC1AIJNzBMWeVxDbis46K6MvMzphV9HoC7L4kBOnkCHXdge+q3fDSRqkm4d4rpxoCqTI4oGBxN2eOgdTXtju6MRo6pS4CY0qHFimgjyhpYeKQZv6P6kPVDR7rnFc/chnnDW0H5UEY9Q3dSKWGqcyYN0torrQd39jqduln8zRmwcfBmzhpuW9TUSWtdlOz6ZRRip+mtPcy1J3CE9tvGl7FEkdrM4ZoUJR9MFhFZZSg3gXZ8LPM10Zm9A5dFumPLjbAGpc7/+YS1c/YNDD4o9W/Q0YqKIC7ssHgGQiEz9m5gsAbnmkuc/35X6Yp+MNjqlK0bThTMV+9b5KD8ET44mtOg8L/p1xgvaZmlrJqlEk+kgXS8AW9hnrGsB0zMnSnmaVzopzXqF5WHvfGnkAGN4Bv47p1u35yhr9Q+NeYKnohM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 25-11-25 12:39:11, hui.zhu@linux.dev wrote:
> My goal is implement dynamic memory reclamation for memcgs without limits,
> triggered by specific conditions.
> 
> For instance, with memcg A and memcg B both unlimited, when memcg A faces
> high PSI pressure, ebpf control memcg B do some memory reclaim work when
> it try charge.

Understood. Please also think whether this is already possible with
existing interfaces and if not what are roadblocks in that direction.

Thanks!
-- 
Michal Hocko
SUSE Labs

