Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81E9606D80C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YCRTKIDi
Received: by kanga.kvack.org (Postfix)
	id C1D5B6B05B2; Wed,  4 Nov 2026 17:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3EC6B05B5; Wed,  4 Nov 2026 17:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B319C6B05B7; Wed,  4 Nov 2026 17:42:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 812366B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:42:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AE421C4205
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:42:45 +0000 (UTC)
X-FDA: 85398912690.21.CE51D06
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8F8F420005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:42:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YCRTKIDi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793832163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76+aUQcUn4RSh9/vkGb8GrJJ6hK0vTzaCEd5JGs9ODc=;
	b=13lKId9BOVKexlmqHxQ/nYISaM+rLQQiI2Jt1JM5CIfVJinWHbxNn1OY/a7eeQVb2yobsN
	VphbOtGo2zI8RMxXGCIH9kPqOTpJ1kfMAxw3mN14diSRGYxD+KY7FRNaK8dTmRTU8ZURbI
	fDMRwz7K5CULH7u9+zc6qhquQAJVYPA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YCRTKIDi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793832163;
	b=a96/leEEUyZiMgz9Ghta0csb/2PvivcnnskJGb7B0NCG2IhiOuzAGluUJvyil6fjI98lhI
	KpqHvjZioQx9fvoJP21orjzUB02R4vvWKoqaBAYO3rgZJZYJEoBslEoTbz/YPyswnWl7t+
	v7adm8ZDXmuwMU5uAz+rOpwF0DNfgdg=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a064fac8cbso970406b3a.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793832162; x=1794436962; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=76+aUQcUn4RSh9/vkGb8GrJJ6hK0vTzaCEd5JGs9ODc=;
        b=YCRTKIDipbGq7+G0Z/eXWm+tOkKz4273oW2ZY8V/QyxJoPxpRMfro41P1zjqXca44V
         W/VV7yZlPPDMp4zBt2upMSSSn1fr79CCkUuKGiozTpQPHsTk5ccUvzi9eMowLyDKc5Qg
         Jasa4mjgqbq+Ovf1hyvXJpBP5TS0OOoeoJlLjENRBryHdGUVMCgggIDFHoq8MH7B2FSY
         8HDsYDnWcuIRke2MzAPq+DzAROVJQkYFpGs6uPPfhEeL8DchMiVveWKw1eZLWSJ96l4M
         L5LKPaJrfowokTmHxRXnWj8mWjycgfYFGnnD13hxzj2xeommqBDydinPxe/W7tQ8KnNG
         T/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793832162; x=1794436962;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=76+aUQcUn4RSh9/vkGb8GrJJ6hK0vTzaCEd5JGs9ODc=;
        b=w6VoXHL5wH4qT+Ld7aXSCJN9FLSmAat6S3oionpuYWcLs4E7EMkIqbbA+iBi8AirN2
         Q4FYMHvz/vGrv+6KJhvQQhpSFdQ/x5RXd+aiBIpsK51/LbYVR/7qKA+WnKbZG3jxe/bO
         nbhKUPP+5fPKuxuL42aFcxzWPo63iJL9SXOSTWSYIfZCnXt7RazI5hFevHKb2nulzMk5
         YM0C6Eq992QfPsaDLusFHLY9mjibTueVjmMveW7SP29am9VUBKlXAAPnpD9N8x15RAL/
         SedvYyxKnxt16lbNZo99sK7ibX3sdnrxqT9QpXydek/DjSDcLrAhvdTZq/aWeJKbuVht
         +UQg==
X-Forwarded-Encrypted: i=1; AKwUvBxPjByIOBbb8wju5n1vxIFZH8lmQys3BCacoDHzICzj+PsP8rwQzjzQSigOCDTnFtC6pWCvuYjTGw==@kvack.org
X-Gm-Message-State: APuU4Z8JO3t8TAaX+E/i/suD3c9KgLbZTjPMthWz6q4bwwRIA8HpDnUJ
	LHmwwB1aGjaVRIq0yHTyHs4DlKJbytIaEeej+Rk7B3PjuWYVaED5df55blwxHhg25Q==
X-Gm-Gg: AYBFou2ceHiPMSKw4fzULL3ImB9hMZRMUb7BlyImkFg+Pc+Q6+lDYocuZ6Y6iUbVFuN
	hFtXpVPWwFpDjC0tuidWwjyV08T1BM+yawBGit7BIkOVa5P0UiKlFcNLDPQkiQiZw1hp0BTV6ey
	b2Muer1PhidfwpVDwEKJvbXVzPzrm//RsgCY06fxaCfk6ntwWy/0EkYgPTrTFbj2xGi8eIYFFIg
	LbqNOMzzqi70eKsXKJigkFCsBW58b59IhmxuJ5sG/QoiDRpPKvkw/IGWTAfoF9RIFXwsgrZ2uek
	OOXZKBQPOowX8lqTD8nqXT5e6Cefc/oNy8V11pd4mpCtxFMOwCuA4ougZ41Bgo0fQsDlRlmqvuY
	JJWU5HaFAZl0dkvkQJvSn+KX3ljM0W7Z9vFvfkMDFM01rvWUlcQ+H5ODyDHFaY71gJOtVTHxH8m
	pfFFk4I2b89P1zgcJstkMkdjwxZp5yf7HXCUwxl7PXO0gafgPOaDUZeMJ0Nh51OoOMXjk9RwHAL
	ULz+kU5kCCCyfIwJ66P1TxM4vjIQXToidiPPl6F2UX1zNj/8iHWaCvoLOp5mjLQEnr5VsGlFSqA
	jInyncxXmyZOksR2NwbBub36ifgv0vds85TWy2+mqnpsgRhS0xdFT0lRa+zt8dTx
X-Received: by 2002:a05:6a00:32c5:b0:878:34d7:697c with SMTP id d2e1a72fcca58-8a9bf811624mr14694461b3a.42.1793832161677;
        Wed, 04 Nov 2026 14:42:41 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b1209b473dsm1079338b3a.36.2026.11.04.14.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:42:39 -0800 (PST)
Date: Wed, 4 Nov 2026 22:42:35 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 10/10] selftests/liveupdate: Add a test for preserving
 tmpfs files
Message-ID: <auu02-iDbVaEL-4v@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-11-dmatlack@google.com>
 <2vxz1p90jzx4.fsf@kernel.org>
 <auuJM8c-bE43NP54@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auuJM8c-bE43NP54@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F8F420005
X-Stat-Signature: m751hes798knfbqskuan589pz9eqriy9
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793832164-39969
X-HE-Meta: U2FsdGVkX1+zrEhNZh7c4kHbEpQH65GaFkMVmgZayVBUc0PbP5Fz3OKBlaVIb9VyTXPoxA7CPgiWvHQqSKp+c856eRWbPeHQqnfsxkgc9dimTZz1qh42WpqJVWl7PyI4UqDY71QJPYr5twc69S2Tj8KWezCZwxoVLOxFoYRr5shQ6Tq3Pzqug3L98FxOn08dsV70ICDu6nsDy+ATtNcmyiklKQdhl5jar9ke+hjNCCLfQb1P3kwLUw/O+gcHssFV6/sZqlzVvNHgO7CwSZcoyaeV1AmED69rIrz8uXFSrb0Bw/kTz6CJXbntVJyuGX3q3Ggge1t6FkNGqHO+3jjqgMWPZyI1a1xs0oiuwkqibSXxP6a2VXl89nKamSFX0LudXl5nKC51ZUiNUKomL0u894TC7Qc1XEvUlFyd/Wc4P3FMuXt95uiWqC7zH+sdhWs8DM1TSQDIQOKm5iabXvGRC9pUo+lMBAxzMpwKkM1VU3CVQayfFLRDgskxj7rAa7DozQ30UEimNVb/mtYwdbdNpCpXJuSEEkmcVSVSgcZ0+iPN1zBUhXa6SiivpS0yGfnEmh9UEfuYleW5wd/rCIZr0DDQ7dh1KQ9My6dyRahXHywubgSEfErq87K1PNw+XSuvW1FGYztFPCzDRnM+R7Ycx5QtbOFKi4yXKe3XR0Gj9fkbBhJelJn1cWpkBv0TFRGZiB4PTxH/xakMdiEq9kCP7FWg1zds8RkfBKf3RGhZ/efQD2h3/BSWF4yzmCueuJLYJx/0A9SviYOUMKn9dCY8xCKDNtgrhJrUC9hU+g1HjIKvmh2HE00x94iKSa+vSEDewovEf4mT8mSIMF0z0Bl3cM49zDzRrDtURYigVgpDmnjQbD7Y/x2zb3wJ9JJukjn7DCIDxd0XHYsykF9EN+89BWu7HECbNIXAXPnXYj9EzFJIEoX0CDbX3P9VgNH3x+wZCsBmzmAwgY0zYwdct2f
 inZIGgUa
 60Ppkh/iT8TD+KrX4mGmyY5llTJ1+HofutFSceeGsVB7GRKenIH84a2Z4PGffls9H/zqDalIjIooHJEDOnHLd3gKZlRWSM1K3kM0DyZFdK4WeQe0rcPBp5p5/hVrwLphnaNfOtjJqCZMJhaqwUg8BBJ7s4wEfKgax3kDtNpKxEyuLpHmugrmEyQ0NKlQl/6/HziDBdFg/FJ0qqtRmWNttzGp9P/PpGV3Zek5WRdzajsbDwqUu2ePuf8S9WUWPiNXkYW5aeudrwPa1B1OyY2N3XSozH8jh4QKaGvVtmP6kejzePCp/RW5HPrxrJT2aUMzi/QMtaHe/ox03CAJUer7wXIP3yVXsDfOG2oNalhtWOpp+zUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-04 02:37 PM, Pasha Tatashin wrote:
> On 11-04 17:59, Pratyush Yadav wrote:
> > On Tue, Nov 03 2026, David Matlack wrote:
> > [...]
> > 
> > Umm, no way I am reading all this...
> > 
> > LLMs are great at generating tests, and I'm not saying there is no value
> > in this. It is just that this massive code dump is unreviewable by
> > humans. It is also unfair to the human reviewer because it took many
> > orders of magnitude less effort to _write_ them with an LLM.
> > 
> > What do you all reckon we should do about this? Trust the LLM to get the
> > testing right? Do we give up human maintenance of tests entirely? Do we
> > do fault injection to test the tests themselves?
> > 
> > Or do we make the tests smaller and more human reviewable?
> 
> We need good test coverage, but I believe we can break this patch down 
> into smaller changes where tested features are incrementally added.

Agreed that it needs to be easier to review, but I'd like to keep the
coverage. Here's what I have in mind for v4:

 - Move the preserve-side checks that don't need a kexec into
   liveupdate.c, like Pasha suggested in his earlier reply: which files
   can be preserved (permissions, read-only and append-only files), the
   frozen size while preserved, and unpreserve. Those then run with the
   regular kselftests instead of only in vmtest.sh.

 - Split the rest of luo_tmpfs into several smaller commits that add the
   tested features incrementally, e.g. one for the test infrastructure
   and basic retrieve, one for the open() flags and creation checks, and
   one for block accounting. That makes the series longer, but each
   commit is a few hundred lines and can be reviewed on its own.

It will still be long, but I think having the test coverage is worth it.

Does that sound reasonable?

