Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CCBCD29FF7
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4BB6B00AD; Wed, 14 Jan 2026 07:30:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79D8B6B00B0; Wed, 14 Jan 2026 07:30:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE8C6B00B2; Wed, 14 Jan 2026 07:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58E786B00AD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:30:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 311CA1A04C5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:30:24 +0000 (UTC)
X-FDA: 84330502368.07.3BA6F10
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3168F40012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:30:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=rU0LOMSt;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf07.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768393822; a=rsa-sha256;
	cv=none;
	b=pYUH8XsJSYNptnW2AlmESah0WC25xJi+XfN3DiADQ39euEeNVw6Bl72S+kcweZ53eMIiGq
	frDO/2Rj7n1yok76Mv2LATHkC2RrcdDMf6EpEzCMJ0KzYFgr6iENbU02geZYqOVAY+YgN6
	1XZXN2jbEuCTY9co6ANIhQkyjNJo8ic=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=rU0LOMSt;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf07.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768393822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xx7hVX5a7BDbwvL9Uo4YtUuy/fcXiraO3yJp5fQH2k=;
	b=JaCq3vC0x72sRpikCizddbxkn4wU51oMxkJA5qhKY3dgdbBrWm0WtZHFnlYE2Y5DoaXiLY
	v72ct8+6PIKOfDW5zqnW7vjpkj/dlWS9yrQnH50QRHks1iqYszPszEU2ZkXA9RdE45QAx4
	fAmiVp+g7PwR0iSeLAnDqBSNiCt9WQ8=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60E0vj3v1639598;
	Wed, 14 Jan 2026 04:30:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=3xx7hVX5a7BDbwvL9Uo4YtUuy/fcXiraO3yJp5fQH2k=; b=rU0LOMSteOlW
	9r7vQKWgxw5heSTb3auWr3qNqJk1h2ypjqE8LWOQO2RLMvwwYDChX/LItDB8Z/wv
	F3d1OiEZ3zvGuRBy2y2yZbrPjxgu99uGutgnQpSMV8Ez6QLGduoSEClZ1vtOFkbO
	Yyjtd31i/YZaYzSNAxLnuYhXG1w79jKl2yt8GhniA9osKWAiav835cY/MgoaefX1
	5JrNFoUnU0RawqV0In39EIsE++gtp1qf1OZAlDuDPYb904Fxd5YgpTiFG1mqJtdu
	xIrC6yPrgVG2dsUuNVoHjpbie/uiARF2HdnU3mFv5rgnCtIFVar8SsoYJx1v9Ck+
	XqZUFfzKuw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4bp12ac1ur-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 14 Jan 2026 04:30:18 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 12:30:17 +0000
From: Chris Mason <clm@meta.com>
To: SeongJae Park <sj@kernel.org>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        <damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 01/12] mm/damon/core: introduce nr_snapshots damos stat
Date: Wed, 14 Jan 2026 04:29:56 -0800
Message-ID: <20260114122959.1164957-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-2-sj@kernel.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::f]
X-Proofpoint-ORIG-GUID: 1v6XLzs9dHS1tuZRU45PQbVeWuBiXluk
X-Proofpoint-GUID: 1v6XLzs9dHS1tuZRU45PQbVeWuBiXluk
X-Authority-Analysis: v=2.4 cv=KcjfcAYD c=1 sm=1 tr=0 ts=69678c5b cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=Od8CE_c8tX5E95hOnl0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEwMiBTYWx0ZWRfX9d+dKIcMmmue
 KZAqq/ogQtdckoPBnAQgakFwp4xMH0Jrz3NtsWqstVgYJA+NyFXzOqVCNirS+M4xR4rIJWjnlqv
 dbuXIJ2RgEw7TrQJ0PNIizF5skvXiGGxuQUmkahww2UZi1qiOGb3a+QHWRk3zIqvnI9h7FNhmjE
 yn6BZP/2JLh1MXjNjr1xjhcMTKv/gzXSOTbiSTreltZcgo0qZ3ajB3aPSFaJr5wAJYnyXWlu8rQ
 zzaqtDDZ/D6lzauzOPb/FS19qnNnQR2204lYsdZ7MbeVbfNoVfNfNeAPP59ebTFS+OQBR2hyzX6
 LyV82SQA0z1QG29EGpd5n5NMWcn8xluKLtsUPOXy4NebXwP/qa4wbBKvSgR4LtNt07fSQ3aeeC9
 qkZltodZ42JMcjNtIXmiL3AVIF+EzcLYgn2xcmKFynotQksrN5Fu+mlmFgI5vgtTt6a5YhEKE3I
 F7VDvpmRClolCnMnDog==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-09_02,2025-10-01_01
X-Rspamd-Queue-Id: 3168F40012
X-Rspamd-Server: rspam06
X-Stat-Signature: 7scfq5utti7rs533wkya561eqg5mbkmo
X-Rspam-User: 
X-HE-Tag: 1768393822-799134
X-HE-Meta: U2FsdGVkX18B0LQi+g/XouB4aX7jwMhLEFOozu3LwtMGxKb1+OUbfyQ0evdhXe+gl/304bdFelETl6T0tuL5+K/ySdf5MQUqtrD6nFxKotXQ446mTXCA8sYp0FvG+4axBOJmgLaalLa6ov1Hk0q56g8FO86VaULOexX/LmsT5KP+ngbum+jGORj98OSLYZeBhLus16XPJENeyQOPSZQZmRZROpC+JLUuOvfbq0XbltFf3MfCpo2SGahg/auXbvgbZKg11kJFeZtlsDfUWlG+f1NfLkxDCfIR3All+TgZe/JSv+7Luqf8uNWGSx0kQg4eNumFtX1xqpiiDKN+BkJVIIsdwTVrTJu8f2A9xFNOkkRk81CI7SgP4GsdK55nGnrd+nFyvetCBbUYPjaNhxpqCQJmZqwDRkBt544n0Tym+JXZnmh5MwdIZUr9iQZD1wjNXguaYZJ3MI0dFSWi1SjNBgQ7avfJTMg+hbOoFkyqgbtOKa/fb+n1T/q/FUJt0SU6Rj3rbu7ETcNle3KnbVhsqxO9qD2Uw+WGdAc+ZnGHlfl9j1pj/YParwBggSQ1odxw96DB7DwL0EWlkZ/Ebfzo4xP98Sg+PRIWPqOVyzDGNrnIS4Vo1PqgjttKjEq3IqFvOnPyALirqfyDQsQf0+T6pQ2/EdMYMNMNe+blRwhSCcPsjXtPq9mOLU4ftKg9fMTjB2IpxULDQfE7YYfSBZWO2ooa1WLBsiROckE+rqXtt0XSLzOzzCk64PwF26ixU3VU75gthEVsRfkhXDBtWHABQf3+ZznmBRFMOFkJWpymqqkMdbcaavMNhF0qiacHZOfwNCJfjXSuRY6T6DTOWPYhyPpwRB8Vc6wxWsQGYjGkiwGuWP+hj+TcXt3l05j5LiyhcLFXU90+0J8HKeVcmFRxox+LxVmkGzVzRs1ofNQgYBm0eFHUAkwEPZE2jPtERQ10cYRU/wYpCXbAc0nfsfc
 qr2MQpdx
 Jy4Le8VBFaHsEX44H9BuTLPY2Q0o1XWosr4eJBe7yEFnU+qw7QkxKL1WVfKUQEbhUFtOCvldLXOKV2wSYbcGGQYLnO3sYXVXiJ1XVxWmbu4tvZUYvP19oO+szh84SntjoCGNGTBov2m/UTHNeJYoeTSsqTvOrPqXcz0qqs1wcggW6bf0B6a89NXjN28NffP2gbzEk1FYXKhCpWbc9OTp9aLbNvAnvmNCGMeieVbeUIkZ9kow59hqHTdvk7HE+J6iwyzJQU7SILBWjJZpz14DzzecMeGsEb2E9pXkv06j90mGX5aNCvJTI1f0IupZ4iCDQjAH9ibX6ZfZd8mzZwuMyavw6QlK92wg4PdrpJ1FmLQ3L+yfSNg7BQyBY8Qgyl+F6R/w3ql2BuZNd8Jbc6byby9q6/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 00:01:14 -0800 SeongJae Park <sj@kernel.org> wrote:

> DAMON generates monitoring results snapshots for every sampling
> interval.  DAMOS applies given schemes on the regions of the snapshots,
> for every apply interval of the scheme.
> 
> DAMOS stat informs a given scheme has tried to how many memory entities
> and applied, in the region and byte level.  In some use cases including
> user-space oriented tuning and investigations, it is useful to know that
> in the DAMON-snapshot level.  Introduce a new stat, namely nr_snapshots
> for DAMON core API callers.

Hi everyone,

I ran mm-new through the AI review prompts and this one was flagged:

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -157,6 +157,12 @@ void damon_destroy_region(struct damon_region *r, struct damon_target *t)
>  	damon_free_region(r);
>  }
>
> +static bool damon_is_last_region(struct damon_region *r,
> +		struct damon_target *t)
> +{
> +	return list_is_last(&t->regions_list, &r->list);
                           ^^^^^^^^^^^^^^^^  ^^^^^^^^

Are the arguments to list_is_last() swapped here? The kernel's
list_is_last() expects (entry, head) but this passes (head, entry).

Looking at include/linux/list.h:

    static inline int list_is_last(const struct list_head *list,
                                   const struct list_head *head)
    {
        return list->next == head;
    }

The current code checks if t->regions_list.next == &r->list, which will
be true when r is the first region in the list, not the last.

Compare with the existing damon_last_region() in include/linux/damon.h
which correctly uses &t->regions_list as the head:

    static inline struct damon_region *damon_last_region(struct damon_target *t)
    {
        return list_last_entry(&t->regions_list, struct damon_region, list);
    }

Should this be:

    return list_is_last(&r->list, &t->regions_list);

> +}
> +

[ ... ]

> @@ -1978,10 +1984,11 @@ static void damon_do_apply_schemes(struct damon_ctx *c,

[ ... ]

> +		if (damon_is_last_region(r, t))
> +			s->stat.nr_snapshots++;

If the list_is_last() arguments are indeed swapped, this will increment
nr_snapshots when processing the first region of each target rather than
the last, causing the stat to be counted once per target instead of once
per complete snapshot.

>  	}
>  }



