Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D98CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643496B00F2; Thu, 21 Aug 2025 15:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3D66B00F3; Thu, 21 Aug 2025 15:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509D46B00F4; Thu, 21 Aug 2025 15:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF1C6B00F2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:09:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8D2DB9CE4
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:09:52 +0000 (UTC)
X-FDA: 83801704224.26.3A49640
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB988120006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:09:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TF1QXUq6;
	spf=pass (imf29.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755803391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBKwML399L5lBZbUoL8fRkzIp4IsNuZpwsbwG4R5O98=;
	b=xuZP/4HgMICmzD3VadOWnJ543qgMf6X++1n+58zzU49C2+ETkW9YJVgDmaFJcKRzqQpPvE
	sVsyHlNoMbRAlxVutT6lralQXmBKxyNanNDw8D4RDRd6LcfMdNVYZ8MQ88qCaQu7yN1MKt
	z1HMH+iQTR50BwEDDb55/d+E1MlJSx0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TF1QXUq6;
	spf=pass (imf29.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755803391; a=rsa-sha256;
	cv=none;
	b=c4LZ4yCnxpL6bzbpRgUDAjV1G8whlV8OvioOtHeWyfKJ6Rt15KhvKMNFcI4dJzXoFrou7B
	aeIhCQWFNrHTWvMBCC6FagJQT8/a+ndBTRSHZP+dwjQ8PtSLIHisdJHMsYEdd1BF6pwIXc
	LU+DKE5SWJFv54m5ERPAtCZPZQcfCLo=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so841850f8f.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755803389; x=1756408189; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eBKwML399L5lBZbUoL8fRkzIp4IsNuZpwsbwG4R5O98=;
        b=TF1QXUq6/3yF3gcNRUNNxC7E+pdkptkKk8R4T071FgzO+/B1fNvqVTuDRuLHmlFo0c
         VfEyZcV4M08nQaxn/hV7M56VOEtZuYo/5zh1I5tqMcdmiSNdSLSot6r7LJsOTTABzflq
         C6pZiUKysU2yBkv7onmCMhf/Scf8Lo0Y+vdeYhxGu2pvMjCJwKHg9MyOl+O/Lhb5LnYp
         UzaPRQB+A0nIXyDa8WBCVvpAzvya3WDMQeHA0I6TgqTWlVxD1oRQuDUr7IqRFQ9w7fH7
         fgVunSS4NmR6rdL7IsUarl9zHzpcc0rVzRpnbvr3gYG6GW6baEu0hSjE9x5F2iysXWb3
         ZAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755803389; x=1756408189;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBKwML399L5lBZbUoL8fRkzIp4IsNuZpwsbwG4R5O98=;
        b=tvaJpWwTYBS0o3soNarIQLXtisen9Y2mCxIZsu8wZspOYyYrtJPc2S3C/gKL6hH3kF
         RzztrgFLAkJP3jZsl/RlFyR0mz061pkmLQB6Vlx17/JIvbZHsgkLiX3Y0sADsuPc2KGy
         i9cDT7aBKBvJLDPC2YyRgGWj/mCg8TULI2N8eb1ZysH6aP95Ff7kScVHmpvI9cpNMsL0
         K1zHlmFnLgTLmXwSfzJQHejbcdfZTIG25X2TM9GTFqHpM6BuyxRg7IhujuOrhzUOZ1N1
         bHnnVw6E52gzgDDJjxmKO/gYLsPK/v6OLMDevKe45utN6zM0pbUcqJhkyJ7wJTLIhWST
         XdUg==
X-Forwarded-Encrypted: i=1; AJvYcCXlLazYYESXHd42Wnf5hq4UVy6S92/wYoIhOxXaHiYhWrgdBZ7javBP7EwE9TY1SHnbI0Djtvg1TQ==@kvack.org
X-Gm-Message-State: AOJu0YxPyLZKhy15OZcnyCXotvyOyicwfIcYfrdqcnhReXu13OgxGQIF
	E4wC1R7qwaaVdNWooz1wfj8ZB1Xb1QZ2PASZ+WvSZNUI70AItOsHpDK4fS+V9dOTiLJg5w==
X-Gm-Gg: ASbGnctzuaXOwfU6xmJ98nC+DP1KnoLLv6EKMUmZtZpLqLfIcTAW3b3gViO4wbyBka9
	5smhInLOzH2KFTWHPLLIX4N0nCWV93CmkjOGCVYxl1W8QptYulkZcK87CwTsEeTvVasDI2Ge3ss
	PHVFBDKYeNBTl5cUx4k3q3qxXneymd4GDoI/jEvaibgxoxTrmmACfcYZFZWiOA27L+zY537siI6
	AUOfKdjMDWSBU1zNP4rUxQWhTX034cRBOJDQzZ5sM5+Ov1FwsdAq5wdA+3tPnXcT5KWhZxMzKXl
	c3mjl3/hBb7BqF/b/T4KWZheHmpIldpydTvU+lYiNxPCbmTWeU61aV3URzPyEmnU6ilpDJkpXMa
	bv2F5iPaelBQkipjV7yXtx+YnTZA3g0NbAVqTwgoOKbYjYA==
X-Google-Smtp-Source: AGHT+IHTSGMmQ9ox02sZlz59fzYLCVtspAv1IbbNtcttWrN1lXKi1VnhvttXHw0YcoD/pgDV9DsT3A==
X-Received: by 2002:a05:6000:2f86:b0:3a4:eda1:6c39 with SMTP id ffacd0b85a97d-3c5da931b49mr93942f8f.13.1755803389021;
        Thu, 21 Aug 2025 12:09:49 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0748797a1sm12013437f8f.5.2025.08.21.12.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 12:09:48 -0700 (PDT)
Date: Thu, 21 Aug 2025 12:09:46 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC 1/1] Add memory allocation info for cgroup oom
Message-ID: <aKdu+o4JrxujCwt3@devbig569.cln6.facebook.com>
References: <790da5ffebf18a5a1211ad8dbe4e5b4a19871408.1755190013.git.pyyjason@gmail.com>
 <20250814201114.1921580-1-joshua.hahnjy@gmail.com>
 <aKM3j3geY7JiPGQ8@devbig569.cln6.facebook.com>
 <CAJuCfpF11tbq7eEhzJ-7cneGKXDg5cxQrdWNVo1whyLuFQGzmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpF11tbq7eEhzJ-7cneGKXDg5cxQrdWNVo1whyLuFQGzmg@mail.gmail.com>
X-Rspamd-Queue-Id: DB988120006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8ks5zx8h5zfyh7mdp4ahzs4ctau8a79g
X-HE-Tag: 1755803390-620134
X-HE-Meta: U2FsdGVkX19JdR1Vvsp8fmNeY9ubC1d3wHy8fiHtGx1jRfvP6r92wWKQ8R4mAK+jYlQUJfBGO7ImRj3c5gZ1dvVkpqGojknZI7zfhlSToQJPvcWGA1OHQqgbv3Sk38oVaenDxLck+MgwMFf9IHXdhVYdkLMkdCmCK5mh+eB20c9T2vKfXnhQ14FPyo0FjCgttn/FcJmS6GiQB3eCFalzFVHOWwOjZXVTxKuar5uj/ghlwoM/HL5Q0yBOlKXcPKHZTqq2Dq/dxcZYiOp0gQHiiEY7vPBkqWIQxLkVeqOw/K5OgajxwpB8bgKrpu5/+wylvFXTg9zDkjTIwbdxWLR9ABEp9ozB3pYwcP5MXnl0ocrO30FaSzU9szG09bgAkmuv12OFQAAJJTLrbZAsypm7bSIwXrtHvC9W3qFiTXIWNc5smEnSKp2aHgy7QU0kV27Uwxtwjspp1QASvcZj4COxzNiCp9B21b6H/DQaVtEBWfZzedIMrzy4LwSeBgCUSskh1b4GUSTcld2/ij0epPRNPlN/zFcGcQ/bkG5Y/lkk3tpUPZtoXtLValJyX5xOc+OGN1mJoBfrd8B99CSmo3GTn5b42STEFd5kQXPYg5p24Q/6OhUkFrLOdfHv4T/R1cyD9LkT0HVXlJ+KyIhkogYfkcBxEm13z6dHtw7hEVRu6oiIwmV6vbkBnzT6PxtkAnM7K+voijcTfpEUkuMWEfxq9RVsqqCactV/b9iUKYZjxbdFO8IDObr0hjtcHPtPSGvT7ldveQzcSlZeyxH6XZHPvAlaWMroRXsr50HqkyTrvq323hnnxof7kRSDoQm+RTfsVXLWtK+Cdsxy1+p64T+xfpH48GAPoEYcDJ8/fpqxUI8saAdlMGr8RlGdoovm6CiSytM5Uv4TUkuzkE6bxGp4LP1nFno30rexHTEruy4oUeaUo7LhkMo4v1+wA8eJTFoN4EBlLkZrwYod19hjs/T
 A4av+YzE
 YV9OI/gLDDgcvwLfYwly6MiaHcEkCZwtwBPPiMhdHIIa09n47EQjlWFnymve8XSjWDrbjpgqVgwOoLUOEYXxfr28l3lG5hjzdwS7DWSSwvZi9NM/M0YKENisoACPzguqpK9ugKhpaeLCJglNWMGEsgtllF5+ILebkdYquSWoGn37eDm5F/4sQKz5IKYUtY8NxV6mut9V1CnR629YS+wC6VmvPTnupARWsVFcjEioKxrk5nR5LUBJAFm/9M7b4RgHZ2GT1rVEZx/6bS8DeqDt6ZMfxov98bZ3VNxa8V1EFNgPgpXJgg+3q/4F0fIfzBUEz+C36jgxyYutPSWDYyerLyC3BKILZGUT4AocduebOIdkulkpThlD+1mLyhGaKuUqbc/lUhSuTyi5X3dy/AzwzoQnrnwb5MGknegYiSMyV4U9kGyJavovhHtCcZD9mM5MQiPw7/mXF/OUZrEdlmx8nY5QtrI2o9QEK0dy2hAEm5u9GUhOq8TUwsizsCoWUMKOEIXhDwWRv/Yn9IMsXeJH2EtqCUwHLXmVtuwcK8mUszxv/wQIqA44ycveki+7Y9rR8mbvcEscg+xghWr9Vr0K9oTplP8qaiff/iIUtAgRIl4LR9QQHJrewq6VSxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 06:25:56PM -0700, Suren Baghdasaryan wrote:
> On Mon, Aug 18, 2025 at 7:24 AM Yueyang Pan <pyyjason@gmail.com> wrote:
> >
> > On Thu, Aug 14, 2025 at 01:11:08PM -0700, Joshua Hahn wrote:
> > > On Thu, 14 Aug 2025 10:11:57 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> > >
> > > > Enable show_mem for the cgroup oom case. We will have memory allocation
> > > > information in such case for the machine.
> 
> Memory allocations are only a part of show_mem(), so I would not call
> this change memory allocation profiling specific. The title and the
> changelog should be corrected to reflect exactly what is being done
> here - logging system in addition to cgroup memory state during cgroup
> oom-kill.

Thanks for your feedback Suren! I will change the title to be precise in 
the next version.

> As for whether it makes sense to report system memory during cgroup
> oom-kill... I'm not too sure. Maybe people who use memcgs more
> extensively than what I've seen (in Android) can chime in?
> 

In my opinion, the show_free_areas and memory allocation profiling data 
can provide an entrypoint to understand what happens with cgroup oom. We 
can also compare them with historical data to see if some memory usage 
has a spike.

Feel free to critize me if I am not making sense.

> 
> > >
> > > Hi Pan,
> > >
> > > Thank you for your patch! This makes sense to me. As for your concerns from the
> > > cover letter on whether this is too much information: personally I don't think
> > > so, but perhaps other developers will have different opinions?
> > >
> > > I just have a few comments / nits.
> >
> > Thanks for your comment, Joshua.
> >
> > >
> > > > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > > > ---
> > > >  mm/oom_kill.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > > index 17650f0b516e..3ca224028396 100644
> > > > --- a/mm/oom_kill.c
> > > > +++ b/mm/oom_kill.c
> > > > @@ -465,8 +465,10 @@ static void dump_header(struct oom_control *oc)
> > > >             pr_warn("COMPACTION is disabled!!!\n");
> > > >
> > > >     dump_stack();
> > > > -   if (is_memcg_oom(oc))
> > > > +   if (is_memcg_oom(oc)) {
> > > >             mem_cgroup_print_oom_meminfo(oc->memcg);
> > > > +           show_mem();
> > >
> > > Below, there is a direct call to __show_mem, which limits node and zone
> > > filtering. I am wondering whether it would make sense to also call __show_mem
> > > with the same arguments? show_mem() is just a wrapper around __show_mem with
> > > default parameters (i.e. not filtering out nodes, not filtering out
> > > zones).
> >
> > The reason why I call show_mem here directly is because cgroup is not bound to
> > a specific zone or node (correctly me if I am wrong). Thus I simply invoke
> > show_mem to show system-wide memory info.
> >
> > >
> > > If you think this makes sense, we can even take it out of the if-else statement
> > > and call it unconditionally. But this is just my opinion, please feel free to
> > > keep the unfiltered call if you believe that fits better in here.
> > >
> > > > +   }
> > >
> > > NIT: Should this closing brace be on the same line as the following else
> > > statement, as per the kernel style guide [1]
> >
> > Sorry for this. I will run checkpatch for my formal patch definitely
> >
> > >
> > > >     else {
> > > >             __show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, gfp_zone(oc->gfp_mask));
> > > >             if (should_dump_unreclaim_slab())
> > > > --
> > > > 2.47.3
> > >
> > > Thanks again Pan, I hope you have a great day!
> > > Joshua
> > >
> > > [1] https://docs.kernel.org/process/coding-style.html
> > >
> > > Sent using hkml (https://github.com/sjp38/hackermail)
> >
> > Sorry that I forgot to cc some maintainers so I added them in this reply.
> > Pan

Thanks,
Pan

