Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB263CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3141D6B0473; Mon,  1 Jun 2026 12:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBB36B0475; Mon,  1 Jun 2026 12:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200D96B0476; Mon,  1 Jun 2026 12:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9C66B0473
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:45:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C49071406AC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:45:14 +0000 (UTC)
X-FDA: 84831918948.21.CFBC237
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id B610020034
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:45:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DIWDkLN6;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780332312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuechEhgIbIp9Ei8g9Ubfks3HTEaKTHpGRK7meqRSP8=;
	b=pDtCQx3BiP1Q9TIguD3gufiPqML0YZyJdvQdNhiiT5tk6wQmzouQaFxYVbh1HH1H6I5MnR
	NDq+xNDijHvBtX736HXTXQvIlwN+OlT2fZw5XelG1F/KQcrKZ7DFNUpUxXYZ5C6edyCeyj
	GkpvF95nj3YAmH6OAilstkEn2AEjq6M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780332312;
	b=UXX5HW0LPjExFUd40M+BKFQlIlwoHY52X7DvCMgngziywDVuAL6Du3YGKphgi4FtYf0Jh1
	9uPHzmqer7TbIN/eNygsnkerX71BC06WMqergO7P93ZNUWcqm33oau0+0LD+qORuNalj31
	G2BC7C3GkDpw6mPNPNTIsZLchrI3YgI=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DIWDkLN6;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45ef1198766so1814198f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780332311; cv=none;
        d=google.com; s=arc-20240605;
        b=i+E0I2Y5dOVK0+XmB6YQBeaONbfqd4vmU4hAC8RCjIib7AFcbOF7aG/OVsyvDaC7Q4
         wYObsj+ZOK4wcN8GLHSfhWbno1o2F3t//PZ8buqRxGzqjp0O5vTk6YQawYKWU4wjagBV
         U4/zzWLMe6JvzMwqmCxAmL/ld6xrIpNhRHQX8zTab1jJwG/MqI9D3n/kFaCeYbG5wzYo
         aVtd4v2jbjWn09Nk6oi2VSkLeweV4/iRBD9hP7Ebd6g93t5vaG/3XQ0hAJlQanOrP+0X
         xxr7kK9I9G+FK34c3amjONnef4hDu75PO2Mbx2NgSll4ptQrMmOydhQiDqrAfMgb4jXW
         QdCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SuechEhgIbIp9Ei8g9Ubfks3HTEaKTHpGRK7meqRSP8=;
        fh=kcSdwdmlHiy94jibuOtJUmW7XE3+EE3SfZPUH+Wc1hk=;
        b=EWJffO/FVyEJuSmbuZBtNwo7zrmem6FgRH8+PyusdJuZB5iAFdgilIPvMDZZ0Sxg63
         50+BMo2yqZRL+oXNZxcIxXjW058M0ct1XFlwKdAew1DYZZjfiaPq1f0amtwDQVrrZL5g
         7mQOScRTviegARuyoKeowngKdTYewkYgtZe8CF+1jKyWMUQUkgPDr9cExEO09IeOpu0m
         KLtmZ+3cOvVklgD7y1UOIuKBFknpQMylCdyEF0P+dRsS2JkoskZyLiZuYbOKBUmmg2te
         wLEayLP7EM8M8Zj1Z/eR5yttRbwmcX2HpV8ZD8rsBuvIT2fdtW3I2Zpqh+btv+5OmwrC
         +aNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780332311; x=1780937111; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuechEhgIbIp9Ei8g9Ubfks3HTEaKTHpGRK7meqRSP8=;
        b=DIWDkLN6JnIUR70O7U5U/4rMHviO8HUVvZ5yngMR9EEB0cbTvEsFwMdUH/tNB31pA6
         CRRHQikqVYNSX9nPLAXAU0SBLLiP2Uih38KZFKso9nVS6pPY5guwM8NAOr4LJ/MWYCci
         PSadJp8rtNJHTY4UKedJBruRHCiiKscVkujVtaqLra94zAVvcIlvneqZcLLp+f0nCgxq
         VOlneNpYFN7q1yviMPP5GnOYeOQhNQ9UgK/Eo87HtNrutxTYqHHVPjBisvorUqj5EN+I
         nQ0fvDb1SvSOr1wT2PwIl0A4zHvwA0mcMR7qEBYT2wIgSGcfa+d46DcZ/tF8M2+jA4Bl
         xrag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780332311; x=1780937111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SuechEhgIbIp9Ei8g9Ubfks3HTEaKTHpGRK7meqRSP8=;
        b=ov7XUyASGosKj/wIyJ9ze1aAMbYtZPKSDD5yzB2GkeR68QYAYy5HyZEagPf+Di2GTM
         pxpAKeiufT5FY83oHj0RgPUw/TW6kc8Zf6Kayp2UliLIAL6QkWP6oXyqWwW9xVNU4cb9
         zQA6xCfNHOxAmFSolQl78ALLf3q+U3bTRPaA/V3/x5MdboZDHEl5jy32aShPJatah3g4
         3TYjpDsM4e0gLYScSVgh5uzM8iAUhKrDtBv+MAJ0Nk0+34KTpOeJ1izMD1KI7wLLNWCG
         jbczISJNaSn8oItFDKRkc4opkJg0ex/NXzuJ6P14vDQtfpYfC0JIUuRO1G2d0vXwYBYx
         3SWw==
X-Forwarded-Encrypted: i=1; AFNElJ8bz+2L2oYQlMB5Hp6Yhr8MHZIjNzZUkHQ+NlhbCVW7d3bSWcNxB/dSNSjeE2rMsTLKn68cCn8Ddw==@kvack.org
X-Gm-Message-State: AOJu0Yyn5lQY7OkBqZ8nIH/KgKKgYxXKqWxyCTzXdWtYugGPqYP+gOBm
	e0aKl2JWoemY7ipuxFCNMORSiGkLQcdzyt3Jyq12nNKNz3E4odvk/EQB2q6qdIQZU8Ot7jpnXBP
	imLwkm2LZ0ABXc3FW1zzqzKORspGfVaM=
X-Gm-Gg: Acq92OGfAbQh15z1YofzXBsYvljWnPS+rYlBc4v2hhtgJ8H03APD4FVbeeTmSjmsQoA
	zZoKXd6BFrnrfU7d0jTL5hdJPKKw/3RTFVlI0tRBSdjwHk0MMX8bzLiLvMJ7a9NTG2OGwu+WBYf
	n8bknSIKHfiml26Zf/VVB1nxtAxdgije+jzNkJ5MRyUirdbW3oD9HsZp8wbqkQQovimu5r0ayKl
	ghVhm55j5lJdEdlkKL1rsDDWso7GsWWorKkXckDnAdn62ewkBUrCvw2xcjW2uejvIX5/z+IQ9s8
	xAXzRSggoHO0YdfJ70QLN5hS7/oOh67e2VEmM56PEn+s1yGQ0w==
X-Received: by 2002:a05:6000:1611:b0:45e:8526:7dcb with SMTP id
 ffacd0b85a97d-46018cde5c3mr378861f8f.7.1780332311119; Mon, 01 Jun 2026
 09:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
In-Reply-To: <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 1 Jun 2026 09:44:58 -0700
X-Gm-Features: AVHnY4LT_5ehEfmIR9cnGphIbcSEKQX4RD4VzS-3orz-D5X1L6ZBlUnrbx8nVYA
Message-ID: <CAKEwX=M5KiWc8ZZTEXCXtxeBrQho3Gs-JnKmBB=YNUkp=WXaKA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B610020034
X-Stat-Signature: mfmzm5m7djcha55tqr7ymbh9u879i84e
X-HE-Tag: 1780332312-477432
X-HE-Meta: U2FsdGVkX1+CXR280jZ3bDHFuCAOM8/sOVW1usYWPTl6fhn4I4aZDLhjNB3E7K6GNZhBOpGCHLQU9ylPMdcVGpXes5PodNUWnpE1dzMa+NNssgye7q6rMpQaZwcrZdDatjZPAX3nggWamU0kTrpN7mZUSWnrb3asL22rplnVtPmSAkZQ/EatjCXauYkgCQ9feyxRHKw8q7M/Dlqkas9+8556xaEqGSq+TQESK1WsvozLzqup48LAEQKuZwgxLpgh5D8knB+LNCU4k7gd8fuxwFlgj+SJ91oDV4ublP12S0esaILlpGUKCzmnEHhdb8oaRzF+wRt8KpDwps6P61+5L8MQFzcH5nR7u2Y5KcfYBZlsmA/w/h/+2ZltUAC43vosjg2pB93M/dgKHie/XvmmDX4ZwDHuVMA+OwVs79GQOCzA0XWKsk9y8RFPhjWe8CneAhUdkA4g1KzcoF+ui1OuTCj1Quh2gDN/y9/Rez479pLwzj5Pr+xRvCgpGR4bwor0awHg1KkM4lFv0mgKIHO5VT9wnkVwKHM6kKJ3/66q1Y1MHXJLJbClRsCDUgAQ8ct80HMYw1JQg1xBoMdcJ952y5Z12urC1I78bNPZIEcBociXaJAepxGIIsbeWuNrY1S2LA5mJ28lzHlxowIYveff9x/v/TQXQyZ4X80BsOoxW6qCY5sSa7ay/c4izXU4HtQCAp+dalo+ECCgND/XixygYcMz2GKOjEWyVgrU+AmB3JvLNQpDjZjTeQcJEHqKCaOTIMFOuR7U06DGxrsEb+bVPvdNfiruTNz2sAK39zV52lcd+WjHK1XpEMSfF6iupkIriHY2J9slvG+bQOm4/+cMMWIpvYKJaQxTeO4djL+eqFrKQH5atbI2ibg10HIKjLZVaf7OsVknt99HGdOpWw/RPD5zk1jTg4uwZDqXSetllBLwQd0fkNoxok2tx+kXFj/h49jPVeYGW2RGZPhgLJP
 x9UWelaU
 ZbtsNYoffXrlKR2B9cTZ4O8zPa9hrtHap7TCh9phSM2fLqCM3Bj02GiowDdUX4g2aH42E/6WIy5Gg5d1anKtN2IeMueDLU8r+qW0ZNrBMXmG7nZll/8efyeL4kTiS7+d3p6e8UiVrRVlW8tf0mQ+btKvjd2EFr75/Etzdw22/wiNPRN8CwVB5wL4uNbB8dcrVUGGS5Hc2ub/AbrKs+bOd/xoeOKbuPP8EebRPBBP6mOLs6hS/wT/pDid7E7ocgUcHrAnJ2f2CFUXyGhX2C42KSSDp7GDxOUTXEiAlYWdjNYSNE5GIyGAMomrPGq4SJxOR76B09+xEMIpaBHQzUlD6tQbBXFvF4rMlrddBBZJQejzrZoMsj+cQgVSmyBLU+xpccZF8sb8rI0MspN7BDYKKupW63f0R+BAxg6lb/AK87osoOBwXbMDqIi55hdCoS95usVoBr5MHNwDl0qst/0Vh+ST88Pa1wMvYsuG5CYppV737GrPrAW8T30uuxQLBTGOBpQfYu0uv0hmFj6JYwbuVNg51lpG/Uh2l6u60zVwJnlXmocHgH4SR2ynvxPBu2KSpen3pMTQJ9c7SiZDAZKV5Mq1Vg9ABEXRurbU3w2ob3EPv0UQK59buROrAViBj41e8Q8gQF4uucf5qJ1veOK6ZXvXLDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:07=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> wr=
ote:
>
>
>
> On 2026/5/30 09:24, Yosry Ahmed wrote:
> > On Tue, May 26, 2026 at 07:45:58PM +0800, Hao Jia wrote:
> >> From: Hao Jia <jiahao1@lixiang.com>
> >>
> >> The zswap background writeback worker shrink_worker() uses a global
> >> cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-rob=
in
> >> across the online memcgs under root_mem_cgroup.
> >>
> >> Proactive writeback also wants a similar per-memcg cursor that is
> >> scoped to the specified memcg, so that repeated invocations against
> >> the same memcg make forward progress across its descendant memcgs
> >> instead of restarting from the first child memcg each time.
> >
> > Is this a problem in practice?
> >
> > Is the concern the overhead of scanning memcgs repeatedly, or lack of
> > fairness? I wonder if we should just do writeback in batches from all
> > memcgs, similar to how reclaim does it, then evaluate at the end if we
> > need to start over?
> >
>
> Not using a per-cgroup cursor will cause issues for "repeated
> small-budget calls" cases. For example, repeatedly triggering a 2MB
> writeback might result in only writing back pages from the first few
> child memcgs every time. In the worst-case scenario (where the writeback
> amount is less than WB_BATCH), it might only ever write back from the
> first child memcg.
>
> Similar to how memory reclaim uses mem_cgroup_iter() (via struct
> mem_cgroup_reclaim_iter) and the old shrink_worker() used
> zswap_next_shrink, we need a shared cursor here.
>
>
> >>
> >> Naturally, group the cursor and its protecting spinlock into a
> >> zswap_wb_iter struct, and make it a member of struct mem_cgroup to
> >> realize per-memcg cursor management. Accordingly, shrink_worker() now
> >> uses the lock and cursor in root_mem_cgroup->zswap_wb_iter.
> >
> > If we really need to have per-memcg cursors (I am not a big fan), I
> > think we can minimize the overhead by making the cursor updates use
> > atomic cmpxchg instead of having a per-memcg lock.
> >
>
> Because mem_cgroup_iter() always calls css_put(&prev->css), we cannot
> simply update zswap_wb_iter.pos via cmpxchg() after calling it. Doing so
> could lead to a double css_put() issue on prev->css.
>
> Therefore, if we switch to the cmpxchg() approach, we wouldn't be able
> to reuse the existing mem_cgroup_iter() logic. We would have to write a
> new function similar to cgroup_iter(), and its implementation might end
> up looking a bit obscure/complex.
>
> Currently, this lock is only used in shrink_memcg(), proactive
> writeback, and mem_cgroup_css_offline(). Note that shrink_memcg() only
> acquires the lock of the root cgroup, and mem_cgroup_css_offline() is
> unlikely to be a hot path.
>
> So, should we keep the spin_lock or go with the cmpxchg() approach?
> Yosry and Nhat, what are your thoughts on this?

TBH, I think the spinlock is simpler at this point if we need to do
all of this explanation to justify correctness of cmpxchg :)

That said, if memcg folks feel like an extra spinlock per cgroup is a
bit much, we can go with the cmpxchg() approach. Please include a FAT
comment explains the compxchg() approach's nuance in the code though.
Speaking from experience, I will forget why it is correct 2 months
after the patch lands :)

