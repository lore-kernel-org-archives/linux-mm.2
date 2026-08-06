Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8FEC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C136B007B; Thu,  6 Aug 2026 01:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BCF56B0088; Thu,  6 Aug 2026 01:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2C66B008A; Thu,  6 Aug 2026 01:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4BE06B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:22:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4F92C0600
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:22:14 +0000 (UTC)
X-FDA: 85069698588.28.76DF113
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 66AF4120002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:22:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785993733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IVgzbqteJadEHD7yJZhwVzvWPHpwdodLLUhJrxYxiQQ=;
	b=oKf62qKYQcVoyOMPDdVNkOgAm/uwJ5V+8V8YSi5w8d5m4h9xg9XMjjv3Hp0iZ9S+7Vbn1x
	KEFR8x0IFF/iWION8p/KxV73SsAY5Zx34of0j18gM7P89QSivN4//VqNMwa8GoRV7RijVf
	iYhOfh3JDCfrKsFAd/pL4wiMKL1Jgro=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785993733;
	b=fTtIX8DNX/mx/LowKC+fCAN6YlUataTeaUkhwrBIdZ5yONZ9CwYf9LSqJSZ7mbEodko+iA
	eIuCnC9VlFzofFFI3eJTCgk59Kw9H+SUMTauKTukZcYIkg89GsEfn9TjgcgjJLYl/8UMDl
	OlPY7hMR96eBcyIQVCA92MqC+3BopSg=
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.53 with ESMTP; 6 Aug 2026 14:22:07 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 6 Aug 2026 14:22:07 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 6 Aug 2026 14:22:06 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/swap: scan by cluster in find_next_to_unuse()
Message-ID: <anQZ/kWnC13QL3Lu@yjaykim-PowerEdge-T330>
References: <20260805141146.127776-1-youngjun.park@lge.com>
 <20260805141146.127776-3-youngjun.park@lge.com>
 <CAGsJ_4xghMxAcJ212WtBD13gYiSLHJc-NRvNTtW99ZOEmdUnDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4xghMxAcJ212WtBD13gYiSLHJc-NRvNTtW99ZOEmdUnDQ@mail.gmail.com>
X-Stat-Signature: f3h1bzwkynbw8rk71q6oign4zm1soew7
X-Rspamd-Queue-Id: 66AF4120002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785993732-569714
X-HE-Meta: U2FsdGVkX1+JBOk0En/C5plN24FcEKVy8YH9TJpYF+C8jisI0/6mBqL2/qpU50YKjRNLHXlGLFyiAqCLU4SQ4pobhakQgx9ff7aX0i+OAWYplIhIs/CTRiVS4YKNc7cZrYNAw3ObBYBp3hoEWwPv9WNLF8V6+I2WOU2O7UDEU1CXAOztNbVaKDYfNVNUYcgBoI62qyYZwt/XDtOQw2kUopiWzW/uNBgcUERJSnxBiF9H2dJSealqrjWTqO7k5Uk+okuerz+5R1PKZV/bDmoQIrkh5vTt33KVE7NtXoQ9Govkmyi7Mddos4fSfnQBPLGklTJamQFR17Cr807KGjmwK3jCutdSL2VHlvwZrLYE0PlY/4lleuDx0f6t8R6xWGCxtr/6mnwTDSlXiBfEuDlApEHeZc2vy1MrhuyGupeZiBFgRt+DAinRgi5iHqpEmj+QjKiGpYTBIT1oeLD2NzQ0FNyDWFZhheZZPQA18VxUhk+ix7O+Y2fP618oCAWtRHKhtW3CgE/K5z9cR9B9XXSQc/U4RUqR0s/Q+nF0CjN7RjG49EPPWb8CUPchRCNlMYm8Rt3Iqny+n3B4wtuKHbije5Co1wAFvNxca2r/+X8zXJ17O6pxCZU1dWJQ6fhF90ac3xX03ApYGTGkliYM5389OGOv0M0hrHUArYaz4ncUeK0Tp2xgBq1pSejGcfMvq+kKx38H86tbbmgc5SVurjiJNQPvVKfj1rJSd8mRu3g8vCzlqN8jjBZ7++sButvFT0PHn2JaUVepNMLvWm7kAFx4pafqMBjNwK2Ep0QFb1KcWN7MpJjiq6odqYJLDv5UseluqZbFfN9dy+UpSW9j3ZMRD3NrevJpz3VwUe4Nl+ppjv63NTs3xD79QhjL2KvFIwFy0uWf034/90oHxDWBthIA2faLmaimdJ1Im8IwcetaAFdblf7yo9oLZB3O1pQJWt2GqN+eOyCDjUVeyVtwv59
 SCpuJGJg
 kvi1P5O7ybKlNuwwfrJ44VHE0MJso/3mtVLd6D+efBy2CmUuVeBzKpo+c0+So/FXZHx8k5K15wEZKhuI3/3H7J7riUeKL+D7SZvRsN/ws76rfuztASbY5B12rI2rUiIMhFxbrvkbKjZOlmwA60oljiyKoevuDOUcwnuwmN2U6/1putz8nWYwHwSvVJQyCiGsikw46NWD7j1Ew9vDa4oMhS2rer090b2OO8mzQ1qTWec048dBb2iBEr6dPPbYa/69sXtYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 10:33:54AM +0800, Barry Song wrote:
> Reviewed-by: Barry Song <baohua@kernel.org>

Hi Barry,

Thanks for the review :)

> [...]
>
> > +       i = prev + 1;
> > +       while (i < si->max) {
> > +               ci = __swap_offset_to_cluster(si, i);
> > +               ci_off = i % SWAPFILE_CLUSTER;
> > +               end = i - ci_off + SWAPFILE_CLUSTER;
> > +
> > +               /*
> > +                * An empty cluster has no slot in use, so skip it whole.
> > +                * A slot is uncounted only after its folio left the swap
> > +                * cache, so there is nothing here for try_to_unuse() to act on.
> > +                * Count only drops here, so a READ_ONCE() without ci->lock is
> > +                * enough, unlike in every other cluster_is_empty() caller.
> > +                */
> > +               if (!READ_ONCE(ci->count)) {
> > +                       i = end;
> >                         cond_resched();
> > -       }
> > +                       continue;
> > +               }
> >
> > -       if (i == si->max)
> > -               i = 0;
> > +               for (; i < end; ci_off++, i++) {
> > +                       swp_tb = swap_table_get(ci, ci_off);
> > +                       if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
> > +                               return i;
>
> You have the following in the changelog:
>
> " The inner loop runs to the end of the cluster rather than to si->max.
>  The swap table is always SWAPFILE_CLUSTER entries and swapon() masks
>  [si->max, round_up(si->max, SWAPFILE_CLUSTER)) as bad, so the tail of a
>  partial last cluster is rejected by swp_tb_is_bad() and never returned."
> But I wonder whether this explanation should be part of the code
> comment instead.

Yeah right. If I remain the code as it is, I will move this changelog on to the
code itself.

> Otherwise, people may wonder why this is safe and ask for the below:
> end = min_t(unsigned long, i - ci_off + SWAPFILE_CLUSTER, si->max);
> How expensive is the min() operation? If it is cheap enough, maybe
> we should just do the min() unconditionally?

Not expensive.
Kairui suggested keeping the end calculation simple(As I assume his intention?), 
so I dropped the min() in v1.

But after thinking about the retry case, keeping the min_t() seems clearer and
can also avoid walking the masked tail of the last cluster before retrying.

So I think I will keep the min_t() version (inclding move ci_off calculation only
to where it is needed) like below

+		ci = __swap_offset_to_cluster(si, i);
+		end = min_t(unsigned long, i - ci_off + SWAPFILE_CLUSTER, si->max);
+		/*
+		 * An empty cluster has no slot in use, so skip it whole.
+		 * A slot is uncounted only after its folio left the swap
+		 * cache, so there is nothing here for try_to_unuse() to act on.
+		 * Count only drops here, so a READ_ONCE() without ci->lock is
+		 * enough, unlike in every other cluster_is_empty() caller.
+		 */
+		if (!READ_ONCE(ci->count)) {
+			i = end;
 			cond_resched();
-	}
+			continue;
+		}
+
+		ci_off = i % SWAPFILE_CLUSTER;
+		for (; i < end; ci_off++, i++) {
+			swp_tb = swap_table_get(ci, ci_off);
+			if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
+				return i;
+		}
+		cond_resched();
+	}

I think both of good enough.
But, IMHO, remaining min_t calculation is my preference at now.

Kairui and Barry how do you think?

- Follow Barry's suggestion. remain min_t calculation.
- Add comment why we don't need min_t calculation.(also barry's suggestion)

Thanks
Youngjun

