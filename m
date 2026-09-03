Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0278C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 05:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9626B0088; Thu,  3 Sep 2026 01:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1006B008A; Thu,  3 Sep 2026 01:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7A56B008C; Thu,  3 Sep 2026 01:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0206B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:42:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03D3D80423
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:42:18 +0000 (UTC)
X-FDA: 85171355598.27.DB52E77
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F420180002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:42:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tk1LBzAK;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788414137;
	b=3SubeETfvxK7A5pjr05UlzeCKjf+RoCBiMohdNbYA7FIRdLdz7I5gSw70qmq++/s/VadI4
	v+IHvsRPd3IbcC+/Y/fma2rMEZuZAKgZBgIF/CwLCOS+XAMOeOOlemiaZu3c8n4WUCFupF
	lRaFIeVXXpNTCYGjxg6b1C4qzK9qLLM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tk1LBzAK;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788414137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGHrNuRdGCT3E2jNxaNq/dU0WCvzVt7mq2GAEQXwTJ0=;
	b=d6dG1uzQojx3L2oySELxysc63B3wVBv+2HgsHIHpFpHD1WkWKq2Qhk2hDhIFFmK9WHMQDs
	H4fR47PRoAqzcop6L/UYogxIMElvVyOFcsn0JPwPEcAtSrMxGwafmNW8L98bXLOGnhJGo/
	JUZOP90JTddVVWF63jecag2sZdQWJak=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81f3b227a4aso28956747b3.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 22:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788414136; x=1789018936; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LGHrNuRdGCT3E2jNxaNq/dU0WCvzVt7mq2GAEQXwTJ0=;
        b=tk1LBzAKBLY55tH2SPxdYk1rMaxeaypLneiwWHksGjKQjDvC9y78e0kG9RuEuRogcb
         HX3eTMQoy/4PZ/iZuNqu5gf5kalUUtk6YAzRy/wMEuOPKInY+of6H4CboKh0vLccEhHg
         WAHUIYEW4tEgddnZCkLwM3ZTm6WeS3anTBKbSqHM9c9RMKQX3JNXRLdwXuocDrXsZCHA
         Ur6tb8rLEdKB9yhEhHRatR74CaktiGcU2+DX+tVVDpYaurpiN12eQMHyk1UBbH/+mEkM
         CZo5xfO0PHy+3ryaOc7EsMbzOMGIvKasv/TGyTmKizE6S68B+mGodQVUTrv6dG6fJSNO
         j1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788414136; x=1789018936;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGHrNuRdGCT3E2jNxaNq/dU0WCvzVt7mq2GAEQXwTJ0=;
        b=sKuzy07QStVVDmh2RVfOYdtb+rORv6cDRKh0DfFB3jQK+s9A+cD14PLPmibc8hwbRw
         MxzwQj3wb2J8ejsAnTI7aE/cmTVyPtZ22U+vNs+oeaabO4vX0s2HaI98Z6CkMrG7X5DI
         9fvvR4490nzk9rFxAFRoW2PhYcBNsCTACtPbueylcW/mOoo78CYJMt9P/VN8KQEZCxI3
         ZCTW/baNUBevb3ArvxPlim7BQ9LxciHOdOkfExbvbMiTR0ZmKOOCsuWx/fJjEtB8kdh8
         c+Jon8Uui29hG8jYCyXCxtHlJIFydqyV8hoTzdv4/vzX0PjNYggJLqfbmfocKmlV+jM+
         yy9A==
X-Forwarded-Encrypted: i=1; AKwUvBzV/JxX7atmgqVKhfY/2b28Ih2bY7DA+8VMvylOlx/VaGQA6w7utIF9aFCMVLr2s4+hK1BaulLAxg==@kvack.org
X-Gm-Message-State: AFuF++lAHZnEgtR1UKZH3S3USBEp03jXlt1zgjEIE8GdKxf2Z2cuNFEZ
	1PldLq4HkfkOXcXXXDtGymQKclZnp/ZirDrhzhZQMJTng8nPVmqcoX8yiIvFEpbisQ==
X-Gm-Gg: AYBFou0pas2yzEuN38JZ7KYrtjTYU470QUG03q/x4Nm1YRW4wTvMTtBaFYcwejSko2t
	IkMmz9BGsemNPDgyCtHEgm5vZ8XX8MtVrFNXqgPKPESLKRyKCr9FkcHoF9FvBfZszKOu0A5yVDu
	jxwWAtpO3HF1OnEAOBB61mQEVKqu8HE0JJAasw67v1viOUx4KYgCc3oWqOIJhZl50uaTHpi7X8m
	2+OzjaA1Sc6xEhduNwhqGSL9v5B/lht0cQpGkMZRLvxhN18fHSGMZyn73JXsdDv1AXILGn+TGF2
	XVk2WiQHPZeWyc5qVe38uTJh8+COGH9carCGj1dftVJ9rag2oZB4XH9foAO6IXRrxIyI8iD9SxW
	FaTXTS+sKlLBEIgjs+9OzUFSnkDueu43RcPfKfTDr6xwOOAAVUK/nc2lUwTMy2ndz23STDKEqyO
	ZNto47yBNAGuC277F/QmtffY7ymK4GF8Eh8+yzySQX4NLy5QEFY7pjRMyGAHn9Edw18gq0dpq5U
	Pm6e0GdWc2FyyMYPHssOifjO9cgOvcieKdZcc4H2+htEAJz
X-Received: by 2002:a05:690c:e206:10b0:81f:653d:4992 with SMTP id 00721157ae682-86c4f66936emr40296267b3.13.1788414135682;
        Wed, 02 Sep 2026 22:42:15 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c129b2f95sm33668537b3.18.2026.09.02.22.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 22:42:14 -0700 (PDT)
Date: Wed, 2 Sep 2026 22:41:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kas@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/25] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <apThx6sWOQ-aZcN7@thinkstation>
Message-ID: <821cced3-dcc8-6c80-a92c-c568c2639e5a@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <16b39f43-d91e-7b23-900e-90cec13837ff@google.com> <apAllneItXmyjRPo@thinkstation> <7b30ca86-dca6-83b7-a632-180e35ed2a0c@google.com> <apThx6sWOQ-aZcN7@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3F420180002
X-Stat-Signature: pgawe9muqt14undgj65hzdgyy5txwg1t
X-Rspam-User: 
X-HE-Tag: 1788414137-767744
X-HE-Meta: U2FsdGVkX1/D/nF73/LWZxFXwyUVVf+jRBlUWxLVLkOTklZL9mLiTBqhZC/K7IuQGJ0OQh/TrB21qMsowYMUcvez8XEqYsfpoT4HGLs2QX3QIoB/pmXp9M8kbfCl7jiYMRKgRnI6k/qP1HZKTeIDdZSi/fXnfrrlkrWrQYVH7tmsND88CvTDC2TQJY423rhv7wxMLBhQcJWEsnKxSGtn49XBBeA5R75cEjEYeeEN5VmsO84N/w4oqXfXW1sT3wJwSXyyYdr7mreMAAIh4m4EoYaXymyzNCmOJOBGxK0notiTO0weYPM3TbtpQt0vt6EhnuCzHCmE9q2KQKtDq2HrRYVqrqU+8G318Kbd+cOolS0U9o5d2cxxgvhVdWf32387KDUQy0JoEkYcA4+wqGndx450xVPsoGvZqOkjddtFU6hdVRQPBeOuPWD4M2bLapVk8VrOji+yZPpOKHkobDsGWII7a2Y2NtsD/hk+DO8ySfETmTxy+fd2n/09/oCP1zGrYX7St4txZpeFSLGLKZv8RcPRRwwMWT/tmZIFAytTd5n+XXACNYNZCqKcIKIWvKcTUqqg4AbGKYN2zKrOtWQPIE92YoAvnC/aet1pO6t9LvkYu7rFNVFnrP0AumGOCDSIkOOENBsgGF8XgysXbFe1mjBR+f0s3JKrJIDp6uDYFRPHm1yCRIyIyrk6PY6J23ka2EWkztQceLK8LU3AYmN43mkvV7FLzpW3LK4iJauhuwEq7C+2ldsn7BAla0Vwm4PoJZzKGDQgQOGIXIj9UWE+3tSuXBMnM1fL4cKHC3Q+/3zlW/KyU3t4n3314IOlwgwkuE12VB8i1NwKpprDMMXy85p9cd9ZXhc7tGhuX6rXRqUhrtPPvY2v9Kcmnkoe2q6YLOfcvU6CvmlmEYBRXjn4ZbcYx7RQIQhZwQk4X1aStD39Ms6QQgjYlKD0iFdCRVkke8t3loLd2bDRQKWscEy
 pEwOo2U2
 T8NwaTlSjvLszMbFaPYkQmaa1jf7QqB3ijjJKK39FrxV51HwrSA+BR4nzcnSCZBsc4uU3hQXR3d1twzGheNpfiqlICFX847jd3Qf7nwDc3Ll//0BRw/wWko/DH9U+2pRSFPIreAXrvnYsEYcylDHojB/b1VqSXUeZz8A3ur2VZhql/Lt2Z6JfFbpl+e3N4i9QMFiDW8gOCd7FrhTEKfbeevIN/SmrKSOkuzvPT30UCl3g8Nx9+ibmWbOGyjNbkvI0hLzkQEt5PwV1CQmDvgzh1/82sL8LTt+TFpM9WmPk27la9CmJN0dWTtXwOwRu1atVZWKhxEh0yMn2R0jPYN33LywNF38IvFkt3R7BbFmAUsFznjErnWHcF778dRr/6FUlHo1g01/Bop7sNFZFzhIAzpFASb9PA6/QlfyFFauOtbON0VAQtjnH1qmHrcxHzf2rWa6frBjoOix7dGwPhl5FtmfJ7mUYwUTUodhCHC97jBcE7xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026, Kiryl Shutsemau wrote:
> On Fri, Aug 28, 2026 at 01:40:51AM -0700, Hugh Dickins wrote:
> > Do you have a head for smp_mb__ barriers? I'm more anxious that
> > I might be missing one or two of those.
> 
> I think the release side of PG_lru is missing.
> 
> You effectively turn PG_lru into a lock over folio->lru.next.
> 
> The acquire side works: test_and_clear_bit() has a return value, so it
> is fully ordered.
> 
> But there's a problem with release. set_bit() is unordered. You
> correctly placed a fence in __folio_add_lru(), but every other
> folio_set_lru() is problematic.
> 
> For instance:
> 
> 	CPU0 				CPU1
> folio_batch_move_lru()		folio_batch_move_lru()
>   lru_add_del_folio()
>     lru.next = LIST_POISON1
>   lruvec lock
>     list_add()
>   /* no barrier */
>   set_bit(PG_lru)
> 				  folio_try_get() == true
> 				  folio_test_clear_lru() == true
> 				  lru_next == stale BATCHED ???
>   lruvec unlock
> 
> If CPU1 sees a stale BATCHED, lru_add_del_folio() returns true without
> doing the list_del() or the NR_LRU_BASE accounting, and CPU1 then goes
> on to lruvec_add_folio() a folio that is already on a list.
> 
> I think we need to have a helper that would set PG_lru and enforce
> release semantics.

Thank you very much for this, Kiryl: it helps me considerably.
But I have to cool myself down close to absolute zero to think
about these things, and can only manage that occasionally.

I've nothing useful to say yet. I believe I understand you, and in
particular your last sentence, which I take as an observation that
clear_bit_unlock() is well-established, but what we want is
set_bit_unlock(), perhaps better named set_bit_release().

Of course I'm not competent to add that to N architectures, most of
them unfamiliar to me.  So I'm looking for a reasonable compromise,
to minimize the additional overhead needed for correctness here,
just using what we have already have (test_and_set, smp_mb__).

When I read up further on KCSAN, I saw that it intends to catch
such ordering issues, and I'm hoping it will help. There are KCSAN
reports with "lru" in, even without my changes, but more with my
changes than without: I'll look to cut those down.

Thanks,
Hugh

