Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CADCC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 21:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BA06B0005; Sat, 27 Jun 2026 17:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EECBA6B0088; Sat, 27 Jun 2026 17:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB62C6B008A; Sat, 27 Jun 2026 17:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 968AD6B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:36:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E06AB1673E2
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 21:36:45 +0000 (UTC)
X-FDA: 84927002370.07.B0A99D8
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1610380008
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 21:36:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cuoa0S2P;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782596204;
	b=vTG9Poflu83785FhxnsQBBKBDbhvjqeRljjcSE3qD9NB6aR9KFOqljbILVI0AdcWtL4vyd
	R1RC0gBv2wouxuvo7NvgcKda7W1eM5beGbprcEiTT3RDtuviJgSZc2/0YfwrPgo0YjRsea
	YyqSu0AhlTGTkkqKPU3ExL1CM4pezJ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782596204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXvatVIXGlRA1p89/xy5prsBIMJ3M0pdIs4NFYTkFQQ=;
	b=WtGdcm5nH/whmcPwwoG4cp1wQCxWx++nV1/V9D3zHisM5lTy+BXXTm0sD5Be+nLK9ULfJQ
	gaD2/wMmLxSzgkk8CxLY70KVwBMYPlpXULisvRlDUCIT2B9hvBRE672r81vdNwixTphUAF
	3d4uYdQ+8k27VrRLC0rr2nQQ0wLg8/M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cuoa0S2P;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-845b965c1c4so1068390b3a.3
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 14:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782596203; x=1783201003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXvatVIXGlRA1p89/xy5prsBIMJ3M0pdIs4NFYTkFQQ=;
        b=cuoa0S2PtENOh0Bfz4KuXRSNPamSZfL5XweRQmW/rsgeNJq/rfUHyi57QCFeyuNkN3
         ILcnqJr6ldpyo0rYh6Wg1uASraPRWnJukt63EwETyBYq/DlIzRm2r4KUKVuTdjhHx5Dr
         BDp2DzLsLFyLynoBAvOAVzsXx3FazVXtYDB82STQbBNV/FNdJHNbLTJzp5gOirqCA1/K
         kHCDIy8PsIBstMEdE/6CqV4NIhOgozxtVHvSnTwIX4KviAZ9SnrCIsk/O+OtcIVCV8oS
         uT21atbD5clxnqVUXjvYREFZQ2shwu5Wg3UOhGr3pWs0mCYArn2FFsRUKrx3jODo7r+c
         Rubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782596203; x=1783201003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SXvatVIXGlRA1p89/xy5prsBIMJ3M0pdIs4NFYTkFQQ=;
        b=VfsiOl+caatcGCQl6zK7VJmUpbJx0VrCOVK0gupMReXiJrwbiaYVcWw0aqWY1O3t+6
         c4cKaPxClA7bM+769rjrCHqVF4Pl6kir3KMYn5BXGtWOeBjbXCpVP8KWCsiEshpmFs1V
         18+hubR42nARVnGJ1504uNzu+tmbkXttIHgoW3htsvdtVcuGybw9kJ19fXMhCXROIQcm
         paq1S7Ln32iPOcCo6/nZ6Xriu7lxGOvaeKJzYg7Je5yzPXZ/B6eWlbRh/qt3TCW+Cax6
         obzoEK7/ANe6uXBtZIoQT+P+zAqENZfDuXG2qpXGEkE4knRnn908ImmLXHr+CdtmrvOu
         YQoA==
X-Forwarded-Encrypted: i=1; AFNElJ9J69XJ6ECyDvbDo2QlljSYYc83euEVx1HrR9kvqubprqtae7QFm3vUQGVqoyiSBxiIRm783+wktQ==@kvack.org
X-Gm-Message-State: AOJu0YxUpj0dyjf/jmsAK8HIn96Eq4shbAUYYf9dnRHwrdngHrLDga50
	csAEwrs1+kJGTTGjPf19uwM2hTZPVYB4ysp6DHGabNZVo4wyKSua0f7i
X-Gm-Gg: AfdE7cmbiWWAHLXzqza8MExDdAlmBSFAZ3q4GcLiMG8m/Mzn7G2emO3R1TY3ikYsMsF
	SvISPwGqlXcp38LizcP/5F/0IqLct6IJlHpqnQ1mSQXla8+7Mo9D1tNMeZEMStHJrTcw79c25aH
	q3IPdrkBH+t0l5cZAinNerkDpMZf9barxP7bDP4ZAtARZtSETEZEiX/ln8N3Hc3bX+bMHt9QRPl
	DP/40WJuZN23GDT/LNFyVek+Q529oNHGNOPFW4+Otb7HjxUOuOW1Wv1FpszL3sYLV8oC0wLnDg/
	+9oyF4TgSKExnPT31Hs3tXRybm48lUo7ysLiEI4NqetAPJgUFuS08wyHHd0VyRYlb1+xkurQEH2
	NSDRNOU8XONWe2d8yOQiSOGXPSzhjK77+8EL36I4Adr18cfPJ5GHn15QS9zbR6yaJJgW1JnD/lO
	LJUKVemTC+/Q/+0hatjKVLn+YHJLDp+M9gLOZzV/XNAeecYgvG65o=
X-Received: by 2002:a05:6a00:b53:b0:845:c0db:3926 with SMTP id d2e1a72fcca58-845d2475cfdmr4821976b3a.22.1782596202842;
        Sat, 27 Jun 2026 14:36:42 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9a5:e298:5467:317e:e807:794b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a3feb7d5sm9112206b3a.14.2026.06.27.14.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 14:36:42 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: add 'available' memory as an optional watermarks metric
Date: Sun, 28 Jun 2026 05:36:50 +0800
Message-ID: <20260627213651.19000-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626141819.86269-1-sj@kernel.org>
References: <20260626141819.86269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1610380008
X-Stat-Signature: x5xkgedib9hebj6d3j7pj6h5gwuq9beq
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782596203-530362
X-HE-Meta: U2FsdGVkX1/PxPH23G5+8aFmjn9X1bdIMJic48pwn9GXAHa0qSZ8y8lsokUc1tkKOj79ItSGbZvPQhbOYqP1LbNIiVaTsY17FoOB5KYkeJQ1AAfhNtFt9kwMdQLWUD7X2WxHLcVmCl6HTAd+EQdfGMJAEWSwNCHQi+kQYTK1/sNNyXfZAjW+L0OlTEFjF7ZYas5Q09uCLwk9E6m35tIlRkP90q0Y2wjLWdw0Vl4AW8q84FVsPQaL8mjh7A7PQWNaGl608B2og4QJ9b+vRGMhf2+P3ElS2tIOz6o6ra2TvLNN2oiHQKAtclrU0DA4SCxrVoPDEQ3LM0dWzdUsFX58vd/WhgNm03hXrnVLKUGnKmrb5VB2cuNmlkkmWEaaeElRazjxF6iJaC3oO4+eckkvtlNGoDeWgviQSsqsKm1qxxPH/PP+7JFtsuUxvmp740/aezndG4KH6ISzNJYtPiTFcmo6JiT7ddc/HswAG6kkh3pVXBEIA1j979ly1yhEFouai5mT4XdhWrJh7ZoQ30gfnzzVOKKKHB0xwq9EBcTCNSoq/aljDt8uaG3BH3gvgWOistjLLRv6P6ZLzLjJR4kzT5eY7F3FVMEPGwa5ING49n3Zvr21gNY8LgBvbHpdyMeU2GBV0Zuy8XdXRsP7JGrI+Xq9izHTn0lecbuHgl3zwMMLnDMRQhcP2PuX6BYpCbFnyw5VugCxzJGROQzb8UcBd46x/S4EJ03Fmtagl5iXOL7vw+rbrhvxtD6HoFMuOWC5pDZGddoC8yIgoXxeRYqW5sUB+v39fCCr7OJRUlzpeAOOOvTfESVlH9sn5/Dgu/QF/Qr6kOswFt4pApgR1xjWsaJKYzolnwxK92lkJZoz8HhVJUxGPDXwN574NueqCTiL6XGPQkQQjRexawGo8j2ir5Jy7ZE9PEl5m0zaasQ9qsZJQLjRjWLn7W4BWH2A9L9C0bl1EQ00mtxurICRJZA
 cZ9AmqIF
 RB3ZPRFaIsfYjDbVKQTskGuDm+aRF8pfds2O3h0aZPbHVtzBzW5V7GzKJlfZozzRcvOyOmFbKliIkOSStn7lp6a1Y7d7dvt6lUWz4W6dGxDEn88OWQIDxOtf78WfxFF8MoyMqA77doZxUbsvavbhLTESI+WERuJj0qVd6bS4W9O/xo2SZPM6T+g3XiF7rpKXlZ9XVjy662a2Y+3+FoW/pQIjv7AD4F8TKhLPlHhhmoxG22q/7OOfSL3aPIRDL24zI+ejnZtXMi/8cu4QwWxeYZYkH5530NcwwNNK1zNiCuq1IhwghAdbcoKK0WGhdpFr6yl2HMDDWa95PucwHDB8JHRt8fj1dkapm8hULbU1MWCuXxE32BXoQ25Qz+vmk589fbof8m2vRHY5Y4szd0rKFipxIgeO1ShZYFiMFHGivzkjK8VXu17ZEePELARv+6OCs+dhBCTSqr0USY4gP/gE3gSse96xNab7UXBnjFRdqUW+1+A2xa0saXYiKlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Fri, 26 Jun 2026 07:18:18 -0700 SeongJae Park <sj@kernel.org> wrote:

> How about using DAMOS quota with its aim-based auto-tuning, instead?
> 
> I developed DAMOS watermarks and quota as safe guards of DAMOS.  In more
> detail, DAMOS quota is for restricting only resource usage of DAMOS.
> Meanwhile, watermarks is for restricting resource usage of both DAMON and
> DAMOS.  That is, when the watermarks condition is met, not only DAMOS but also
> DAMON is completely paused.  Also, watermarks feature was considered smarter
> than quota, because it is a kind of auto-tuning.
> 
> However, it turned out completely turning DAMON off is not a very good idea,
> because it drops monitoring results when the watermarks condition is met and
> therefore completely stops DAMON and DAMOS.  It drops the region shapes and
> 'age' information.  Especially, 'age' of some regions commonly cumulated up to
> hours or even days.  Dropping that was a problem in production use cases.

I looked at the code and noticed that kdamond_wait_activation()
doesn't seem to free the regions, the data remains in memory. By "drops",
do you mean the age information becomes stale/unreliable during the
inactive period rather than being literally discarded?

> 
> Meanwhile, we introduced aim-oriented DAMOS quota auto-tuning (a.k.a DAMOS
> quota goal).  It made DAMOS quota smarter and easier to extend than watermarks.
> Nowadays, users can also pause and resume [1] DAMON/DAMOS without losing the
> monitoring information when they want.
> 
> So, I personally don't encourage people to use watermarks.  Of course, I may
> missing some problems in alternatives.  Hence I'm asking the question to you.
> 
> How about using DAMOS quota with its aim-based auto-tuning, instead?  If you
> cannot, could you share more details?
> 
> I'll hold reviewing the code until this high level discussion is resolved.
> 
> [1] https://lore.kernel.org/20260427151231.113429-1-sj@kernel.org

Thank you for the detailed explanation. I now understand that watermarks
pause the entire DAMON monitoring loop rather than just gating DAMOS
actions. I agree this makes watermarks unsuitable for the Android use
case I described.

I will drop this patch. I think controlling DAMOS pause/rusume
separately might be better suited for execution in user space (such as
controlling‘quota_ms’ and ‘quota_sz’).

By the way, I sent you an email about three weeks ago (Fri, 5 Jun 2026
20:28:00 +0800) introducing a userspace auto-tuner program I wrote for
DAMON_RECLAIM's 'min_age', and asking for your thoughts. I am not sure
if it reached you, could you please check? I would really appreciate
your feedback on that as well.

Best regards,
Rui Yan

