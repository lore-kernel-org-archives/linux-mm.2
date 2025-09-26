Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672C2CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 14:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26BD8E0007; Fri, 26 Sep 2025 10:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFDE58E0001; Fri, 26 Sep 2025 10:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC518E0007; Fri, 26 Sep 2025 10:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 871F98E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:01:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 126FD14071E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:01:48 +0000 (UTC)
X-FDA: 83931564696.03.62BFBFF
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 29122100021
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:01:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T0wSIy6E;
	spf=pass (imf05.hostedemail.com: domain of 3yJzWaAgKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3yJzWaAgKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758895306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSgSv5ivUBDbWRK+2F3rymI1CRou1bjS7ledl+wX67k=;
	b=CbQeLOlGUf7fb3gBng7WsubUMTsdbLK5pX1qgsu8lGHFf7UQFBRgPOM3U0fNNeqmkm4826
	L3A4FnRCugtMm9bB6Mraoao2tX4KKU3ID1XD+qP8J2wg44YYkAwxFDpTr++ZS0hZZI3BiP
	sbXfYpTYGG9hfK8F1zDAEBJThJ1KKi8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T0wSIy6E;
	spf=pass (imf05.hostedemail.com: domain of 3yJzWaAgKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3yJzWaAgKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758895306; a=rsa-sha256;
	cv=none;
	b=2a9WZX+Tsy3DmuWefqe9FCmhWq6quF5MEsyx6DHCMdNGrN40ZW2AUl1YdCv1qqcGzm0tUS
	cPO162dewGzPi78H+UfR43qxK5eVxn+1JOKPwRevxkq7UR4N+Gwc6YQ10VN+DGdKcF5dVQ
	Gj4nrRafsM+GDABNlJU6Zez3eXyOwfE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e19f9d18cso13544115e9.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758895304; x=1759500104; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KSgSv5ivUBDbWRK+2F3rymI1CRou1bjS7ledl+wX67k=;
        b=T0wSIy6EIXmAk4XXjPpB6PvFBrw0d9AYoe3P3CQjFMMkGPeKxaALAj/ULf56mA6/QX
         T3CkfNi6psJG35SWHnAEp4RZupmhVapNc8aBoutqhGrSRoc83+pcYHVxy1KWbzxea03O
         KQqlnFYxvvTmUdqK2B1zG9YCyLaLzxCWpUEkvrhL4x73IMRCTv/OgWld9P+cg5YXZJmH
         t1ZtgIvlkahaOMEnXNmpfDSx9u1yCEfFDJgeNDlRo+7bL8DHHCYYtwB5v9udnIZULkvc
         qveJbINjLQx7UGAryePaRDvDQjO0P4AxqMWQMewYSlKLkk6MI1rFsDUazgw8DMnxkuXb
         cChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758895304; x=1759500104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSgSv5ivUBDbWRK+2F3rymI1CRou1bjS7ledl+wX67k=;
        b=TwNjZ679fovfdPxZ7Dr7m7ULC/Gy9pDH4aTszDRPwROP7nt0zk79EmKbaEmWtsFFZg
         D91TbvbWhS7MoaZ3CpQ/W1qJO8T7r+dLPlG0wiTEFmymx5+qIaGH/7uXDXC8EvM0D1s/
         NaLT0cuXoLHDivcx3frT5JlyEqaB2xs7TPsCDz3osyy+QYUKpKzu310jeOvt899fGmK9
         6GVqwL+01gbm6bwj++AQhHhseq5DPuE1a87jIcOStzFDqPNwiPaAZ/ch0xujmUxWavDf
         o7QjfRBX6Sym2XzqgDUX51V0p9fikUAxNwVwwuvySoh3iqi/LMxyjZ/TVlr/7/AnKdep
         PpGw==
X-Forwarded-Encrypted: i=1; AJvYcCXngDxmh/ohyjNti8PjriZ0ib+jypu3NMMGlvOtMKZcvnkzaY0GFhKsC4oex3CqGPXvDzgEmgxuow==@kvack.org
X-Gm-Message-State: AOJu0YzPDDE8sKJp0Wr6NSNuKaG25riTp+Z/u/sDsJpyY10090wbDHqt
	oBE4f2Vcl7SCxyn6cmXIcU2vcqhXnyinWDqHx6NIyvcBf2IJqvM0na7V1qpF1vUMLAsbMpa3yvS
	lbR1S/XoPQWfNyw==
X-Google-Smtp-Source: AGHT+IEvfWDrFOP5KGjT6l+Sxo3xsiKTHK/jbv85LMBQuJJQFm85+HVdoMS8MFmzfToSyWmUwPyLPGVrMe82gA==
X-Received: from wmbdv25.prod.google.com ([2002:a05:600c:6219:b0:45b:7fa6:f2ef])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a08c:b0:46e:37a7:48d1 with SMTP id 5b1f17b1804b1-46e37a74bc9mr51778605e9.34.1758895304152;
 Fri, 26 Sep 2025 07:01:44 -0700 (PDT)
Date: Fri, 26 Sep 2025 14:01:43 +0000
In-Reply-To: <20250924204409.1706524-3-joshua.hahnjy@gmail.com>
Mime-Version: 1.0
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com> <20250924204409.1706524-3-joshua.hahnjy@gmail.com>
X-Mailer: aerc 0.20.1
Message-ID: <DD2SCJF0CLN5.1824PA58HFFZF@google.com>
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
From: Brendan Jackman <jackmanb@google.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>, Kiryl Shutsemau <kirill@shutemov.name>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 29122100021
X-Stat-Signature: 83544o5ybgpijmzw1tm31brig5qgnn9y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758895305-509619
X-HE-Meta: U2FsdGVkX1/RZT/PjVBFNX+6BkPAyq5gKKDXi//k7xK/gJp8ImOwGZgudsvvHUNQFybNpe5PtWCALMchnfev7GgC0zQ1PRAZjM7MHmeaVg7fkjexSkYxbD3XYvxi/Km9ZURiArubMXfOfHtjCYxQDYyB3d05p1A7Ayh2jmbIRazdB3wsghCZ8a0+JylqwdcU2R0dbcuZnYSNWz7Lu9cTm32epEYImkyGGulkaLh4ynaFn6qONRBFPSoyWk6PLfrTk/jnDkHP1ZkDxi768R2O4VX7ExhJUZQmBTo4b9LpjWgFWWaIbOhxto0gWnDmPlO9TIP1KyOup8C7leoICZQJQSf25NY++vQ8sho2CPHta17voYvAH/YqkgDDHkm0fUbY6b+EBlop55uoqi5ovak1l2e0zsMv8I1QqCpAgBqpMzin7+f748zaAbEJV/V9v0GkVbcm+shmuyo9LeXMoRuddCazV/Cs5A4PQrCf9A25Xu/MJpGgED1Sh8e2lowTDXdEgqPt+ExFaE9NsWpYAZLV1EwbtbKaFkMnLKyHCS5T0aPu8HVXFykGzmMgiYkLvTZKhAorQ/7S/ADlkta6tU5mL/wHKgNpHV9h3Sazz+8UFXkoMZkJLF47OMNjgnsL8Fm5x7KaX+0/2s3s+5qmM57jZKBU08Lua4+u5MUrVHVDLMroLIGo+rzQ1HN9xtupx7xi5G8gVBMpjM0nGlUrJB+xOEGqifiOwJo2QykYF5eJoEDMAXNcv4bMJLFjcZmVhDq/iP0MeAMdNTTVF+Jgh+taqnU46Kvs4ZeF80/7xeDEUCpcQNy3DvOU1/Yf8MmkGfTqmuRWODTDLHwJ0R1Eb3SnnSv/D5LMuCnDszr1t/wXjvip1woDQnP1rXoLHsGeFg84/j8iSIzBHF9Y/9fRtKbV958RUzITr7DQX728545vPipbXIAew2wLqJo2XNYo+k2zARE9srasvHgimstBaMc
 dd8lc5E0
 05QKawm5Fp/eVUVPg8wMwifk5H/VdxvQ4Ty+xkIj45i/X2g8PSS71kJc63rm834bD+kkEOepFv5JEuUn9uHIhNQrDDwHzxOeyW7IdLyGvXxl7Tu6IcfkrIVN3lbO665ucPh8Yto8ThoHVwdUSPX1uTdAGl8e8CjHB10QGfdk3YNURDzTTryrzsAgxDZnu2xehgtRfJ9eqaada+h+l4VNJWCYCQhA98CsCeWKLZRKtnaKU478S02rTnRVATL3IG8UUX5Z2Ui2Ub0pdygop8mxFOzNIhMQjeovMZ1Sa17bYBg2CNaNL4TvtupIzsBJZe7FRisZ35gzhvFjXtORvxr3wiiGL1yl/2pTAn0YRkAZW+pUl2+idMHq2SQ48fGE1MjJ4N3sdYcvJgnTk4hVJTLvQCgdkoKulvPmDyaW0HEP5W6BiF/W6Z7xErBDHc4uClTA/bGlziMMDKLiSQoi86CoWc5Z6LxXRmvEHccmrq2RPnIKDTgtm/j7CneL11AO++VZYGxZF9wtmtPdxzUDzIWVJD6az3XXFV/1brUgRvV6giICFdaMsPAyBlY4ZU2tHQ0OeJZXf100QOrNw0cLfkQKdbFuDc/wv+WbBApIX1iKqRXyS0HeaNQbvWKBLyAJVPtpxqAh9sAQe402/MwiCdFh7LknxP1C1FpXH4H10QoQ9BjAPXsCfuktM8T3fK92bWDzR31bnWZk4tpV5J5RKBcHVHNHFPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 24, 2025 at 8:44 PM UTC, Joshua Hahn wrote:
> drain_pages_zone completely drains a zone of its pcp free pages by
> repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
> In this loop, it already performs batched calls to ensure that
> free_pcppages_bulk isn't called to free too many pages at once, and
> relinquishes & reacquires the lock between each call to prevent
> lock starvation from other processes.
>
> However, the current batching does not prevent lock starvation. The
> current implementation creates batches of
> pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX, which has been seen in
> Meta workloads to be up to 64 << 5 == 2048 pages.
>
> While it is true that CONFIG_PCP_BATCH_SCALE_MAX is a config and
> indeed can be adjusted by the system admin to be any number from
> 0 to 6, it's default value of 5 is still too high to be reasonable for
> any system.
>
> Instead, let's create batches of pcp->batch pages, which gives a more
> reasonable 64 pages per call to free_pcppages_bulk. This gives other
> processes a chance to grab the lock and prevents starvation. Each
> individual call to drain_pages_zone may take longer, but we avoid the
> worst case scenario of completely starving out other system-critical
> threads from acquiring the pcp lock while 2048 pages are freed
> one-by-one.

Hey Joshua, do you know why pcp->batch is a factor here at all? Until
now I never really noticed it. I thought that this field was a kinda
dynamic auto-tuning where we try to make the pcplists a more aggressive
cache when they're being used a lot and then shrink them down when the
allocator is under less load. But I don't have a good intuition for why
that's relevant to drain_pages_zone(). Something to do with the amount
of lock contention we expect?

Unless I'm just being stupid here, maybe a chance to add commentary.

>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 77e7d9a5f149..b861b647f184 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2623,8 +2623,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
>  		spin_lock(&pcp->lock);
>  		count = pcp->count;
>  		if (count) {
> -			int to_drain = min(count,
> -				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
> +			int to_drain = min(count, pcp->batch);

We actually don't need the min() here as free_pcppages_bulk() does that
anyway. Not really related to the commit but maybe worth tidying that
up.

Also, it seems if we drop the BATCH_SCALE_MAX logic the inside of the
loop is now very similar to drain_zone_pages(), maybe time to have them
share some code and avoid the confusing name overlap? drain_zone_pages()
reads pcp->count without the lock or READ_ONCE() though, I assume that's
coming from an assumption that pcp is owned by the current CPU and
that's the only one that modifies it? Even if that's accurate it seems
like an unnecessary optimisation to me.

Cheers,
Brendan

