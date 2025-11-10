Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D58CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB598E000C; Mon, 10 Nov 2025 04:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B9A8E0002; Mon, 10 Nov 2025 04:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781CC8E000C; Mon, 10 Nov 2025 04:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 629748E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:31:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1166ABD486
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:31:32 +0000 (UTC)
X-FDA: 84094179624.10.97E7BEB
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0217E80004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:31:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y3IDfm4H;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762767090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amfX240/D0izGpL77kjzwIZmsTrj0WyJRpbOWOmEfmw=;
	b=UDvzgLl2Bl4PSMFtOGEVcT+EfV6Qke/SM/lOXLQ+GVN+JmF2MCUoxDzSHS1brd2iAmujy7
	ZCcoryKXGRFR7cPTLZEsGWWuYS4EmmoaBhxFf0Wz1vx2TDtiX7TdhauW9gESI0i+b2GXPo
	7p4YysccIr4zMFA38Fa7QjypsvXufh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762767090; a=rsa-sha256;
	cv=none;
	b=e/Apjj/CyoFOsziojA2xbQs/yWL37gVHbNB1V483kBWcSVFJ8SlB80WKo6CyhJGEPZB52j
	0lgov730D0pjhkbfBcMPpM0W6tebxcFOGQ5rb6RZv2uIHuLXWBB2gpzN7APJumU5bOoShZ
	xDQjgTX1mJmQIQ7OUh51Wb2koqKnYeA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y3IDfm4H;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso909806a12.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762767088; x=1763371888; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=amfX240/D0izGpL77kjzwIZmsTrj0WyJRpbOWOmEfmw=;
        b=Y3IDfm4HNzR4rOu1dNka0XwElpU3+/H+6VN5p2wk+cUJqih+8cKFVrfL9WdHhxJY+/
         nxMqha3BJWLefWqIj9FfHLMOpLrhRfMb09yWdaKW2ZTc5JtXygIKID4QUMzWDV7MwaWW
         NTzEZWSxlDFGdfA7IBhSD4ctk/xJt93sIkWzfAtLc0XcSUCKpQpm+X+5qR5K51Hr9PBH
         cncz+3F837Yziwu426T1neV3iJbe8WsAq/POMVR63DAzPeT5S1jNW8oCltL2i3fQrFgN
         DVcyyA6YR5j0efAUpMOS+HFH3xZ0B7zh9B+Ll34zyRK/KfrR9ovmfFZtFo5Ru5dCpIr9
         VT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762767088; x=1763371888;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amfX240/D0izGpL77kjzwIZmsTrj0WyJRpbOWOmEfmw=;
        b=pzE4NwqfTBRGBKRaCUgf9lqc5LWhDb9knLT3ZBWUyvrEjuNDvYePMGWFoQGDRp4oct
         JAyPdcLG8FTIMGPo+tKEaF4bcXrkQzuet8dXZUEoic/MA/cyEgyb80Bc8HDf9IyvxJe6
         YlZxie5jDOWbWugf8Qas6OXdC0hbby/i8ILJjOsNb3wvNy7ZWNVU17B03ArSL2fhSOqK
         IlWZqKgfx4jWoQtYKSIcUf7II109emVQxQP8wnSDb0JekJom0NOonUoRmc2IaJcP4brC
         Cn3SlyF4G7m5VC/0I4ia/V4TidElxo6N7K0VPkg6zaXd2i9t/6lpcQnIGDwgBt59i13N
         dFAA==
X-Forwarded-Encrypted: i=1; AJvYcCUUvbXtZhKH9LkkdYmb5aZ3VgFhvr7Bqa+JZyJYezpN4+pCiKdtahXD4VYA9mFA+hZJALROB6mYHg==@kvack.org
X-Gm-Message-State: AOJu0YzuxPvYSaE6rN3XvuVBQ/C7q68kFbsbrKdJNeGHuoNkGpsrL9wc
	NFDyH7HV/ekP/9j7io+4hxewaACoz91cAveU0q3+Qva/ohEqkxA/AB+t79BIL4QEBMQ=
X-Gm-Gg: ASbGncs1s/sfWjR1slBisnVUYxvUVEGnJYYAH//sS9aLMsMuFViyZlqetWZc2ncF/oC
	v5VlUXuRZYh3Dvdkzf/Tb9Q+NhyTOwq+s6UjRYTHyQ904PvMw4XmnBJYMuMelHmtHGN+oklpoi/
	UxYMzF4xNPYp7l6Dt8MtAL1NSyDz59dtZFCP8WlVQTJhgHLNNfAS1B4LWbD/wrRfHHjf9+0JbiY
	Z17CdJKFhNn5HNXjMW+/d8WVp6jDVe4bIywFWpcZ66sL2oIIFLuWh36YMbszRv1WdAMwYKgIyrF
	Xce3JMZEHzkw48gdhLsSopH39W0dvj/l4kYH2Efao+yHnevhV1X3YU4HJeKhfJV++wCCBlza0I5
	91AUgAgKjjeIk1IlAarqFBfsPuMx8UCIDwmjsYssX+gYOy2Y7b5f6X6iNUCnG57H3OohROfPC+Z
	yxUP640uwRBo/kGw==
X-Google-Smtp-Source: AGHT+IE/txm/8jWMiSkfFFCpyrIegQ7dxW+BtDPga3eQ9vjewsDB6p7h+vXBqAcuv9gNMfcv8ZCOVw==
X-Received: by 2002:a05:6402:278e:b0:640:976f:13b0 with SMTP id 4fb4d7f45d1cf-6415dc11776mr5564134a12.12.1762767084330;
        Mon, 10 Nov 2025 01:31:24 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64184b6c7e4sm3018332a12.24.2025.11.10.01.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 01:31:23 -0800 (PST)
Date: Mon, 10 Nov 2025 10:31:22 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 14/23] mm: allow specifying custom oom constraint for
 BPF triggers
Message-ID: <aRGw6sSyoJiyXb8i@tiehlicka>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-4-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027232206.473085-4-roman.gushchin@linux.dev>
X-Stat-Signature: k7b1jtn6gk8aom5dqtn5b7ffrwg3ghs9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0217E80004
X-Rspamd-Server: rspam01
X-HE-Tag: 1762767089-694965
X-HE-Meta: U2FsdGVkX18j7LiiA5ASwmi3avRoD5aeUrTOrHVQuRgrUwsmaFHYKJf5yQVBisZ63piH3uv2bO9vcMRBR8jvrFFAMQMLCkDVlQSlHzO3dEaXz1c6QUVpB6JO66Kq8DqROzX30nuv/3KodCip/Ie8Oq/vabvQRF69wAanmskfhc/mnlg0lc0UpkM29WQGZUezm4j1vvaPbizFrmwLnLHkXEGSYxiyPBesb2TYEJ9ym2K5Hx9O5A4G31/HGoEEgohshxxsyfbWf2DaAuAti6DYQkO/fbZnYOI37trf9WAgXUA/5TFYpv0XwK7w813X33btnYs9iG8kCjD6d24+7Kp4+MqclAaODYEUlIUWj8o4vs+D/aWwZtSUMrz17kyZg5i85MrEKF66lf+PwtaiuIpMVZ33RJLrHaAkj9j5c01Ox3peVRUabFT8mRXfpmH4WEMKOg5ZQQmUGNwWJdxy1+NLnZ0Hd39BF1I7Mk3wl1sOe8ykUgHBK6f25me5I4x7Qh4ExUGDedg3OZLhuY0P+Gef3Kq6VAVpFPOun8M/nl5cgtr+KOASAeLo8wtIwbQB1k4nZ5e7gH2+/LgpqEhOx6oNFzhjvkdFr+84xsUzJRqmYBoUrD9Ws/i80E6QS2PHbNRczTIMzn2+J7t3gKiornELYne1FuEBeNfapZjOPKgibK4aBVqnYFVzEM2iBjDh4lG5lO+mFgI/RAshBMIjm2rgFTVF5tE8apmmJSahQLToxKBTqqphdi216a699UNQ9/ZBcZYNihFhMh/YmV6uXUZ6neTmWt5/0daU5qWOcRJiLYPCaABKmDfUvmUThqBczdoAX2hWlc3om4rkjo0NFN6FeccG1D8TFKbTLVP76zehF6Dfl8ZQjQBrNerXc4gJ0tH7uJC4ieIH9fN6lepQeG9Pbi7bwITAyQVJzaurNn8T2yiPgt99vFOgxObvGhSukah8cnIXZ8/oufigdn+oK29
 Q78CQDd1
 GWirTgAmpWC1ZBxmQZ8zpYwrukr50JqvUyZXBm5Ow4l2ok5HgcmvoLiaknxiXN+K3W+cPkx+hTLLY68WF0i6vq79wyc00FjK/6lAMcfdzsB9wbG+RzBXWZ9zgi1vdfE9tJ7tHxnJSyJroKYRxn/QtrmrRhd/xSmhj8fsqHAWoACW8jxw3rO5T+1/syEU/Yxp3mdpDwBwPGGs7HNAJWz7nnm/yXOxGVtoukri3O2a7iXhtRRlrVqBpViJ+igcIq8sy+goITvMcFgWEY7CoM6AOQhZ07FyRIzI6GOt67wzj+AGqCfPREIbZrVR89HzC1Xg4d+fY9163QD/3gLSqi3clf8pxQTv/KSe2GzGsWtZKr3fdsTg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:21:57, Roman Gushchin wrote:
> Currently there is a hard-coded list of possible oom constraints:
> NONE, CPUSET, MEMORY_POLICY & MEMCG. Add a new one: CONSTRAINT_BPF.
> Also, add an ability to specify a custom constraint name
> when calling bpf_out_of_memory(). If an empty string is passed
> as an argument, CONSTRAINT_BPF is displayed.

Constrain is meant to define the scope of the oom handler but to me it
seems like you want to specify the oom handler and (ab)using scope for
that. In other words it still makes sense to distinguesh memcg, global,
mempolicy wide OOMs with global vs. bpf handler, right?

-- 
Michal Hocko
SUSE Labs

