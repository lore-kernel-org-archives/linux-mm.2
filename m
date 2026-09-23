Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D25C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0B806B008C; Wed, 23 Sep 2026 02:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96746B0092; Wed, 23 Sep 2026 02:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960CE6B0093; Wed, 23 Sep 2026 02:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 772866B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:50:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03225A06DB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:50:22 +0000 (UTC)
X-FDA: 85244103126.25.961A286
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf18.hostedemail.com (Postfix) with ESMTP id D346F1C0007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:50:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sk4LJfvt;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790146221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BueAFwiasv7ZjHBQeHqUfMN2LS9C/icsSJFoWptiCf8=;
	b=etrgZ0UcRhVjPmUgsQHzWeZAlbcizwavyX1aG9HVworebtHv+4oYOroPN3IeG3afA83tze
	OuZgYfkUhiF7r5UdENINOTqTat6atjFd30jiE6UTHQXFZo00LPuyQyZ5vmrsR+AiA/Fsm3
	dhzKBSYeCS1lahAAP+3+wZFCg/w7CSI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sk4LJfvt;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790146221;
	b=IZJ/szJZZHuJD2EgbC6rbydDHmRESwEmfA2vs5LtFwjlRcTWBfN6wXI9U6ASRLEw22Nh8g
	b65pC2DbVQMzQQWK0c93rlO2GgvqqXHOs64GsKYGbfNnUfhdgOQzxuAIKgr+8KT/mAsvww
	XbsN2TOKadNBcs2x6TB3KuLqF4FP4+0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790146216; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BueAFwiasv7ZjHBQeHqUfMN2LS9C/icsSJFoWptiCf8=;
	b=Sk4LJfvt/DMcrl5rqSzbhgHEXIg4grUm5s+MqMBZZjOVzCNUS2WPmbxko7O/4THPxGI1be/5U/iBClzCXbxrb7o8eqEYuRJ273UtTv8H8XrHTXvGQQ2265kSzAH0NVUfXpGWtMO8U8d9eGiKeRaH/UHlusBTyuK09MBImtw9U4s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XBW5L8u_1790146212;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBW5L8u_1790146212 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 14:50:13 +0800
Message-ID: <68bd860f-ec8c-4d8d-89a8-d7abcfd2f8dd@linux.alibaba.com>
Date: Wed, 23 Sep 2026 14:50:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/19] selftests/mm: add order-parameterized khugepaged
 collapse cases
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Usama Arif
 <usama.arif@linux.dev>, "Nico Pache (Red Hat)" <nico.pache@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-12-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260919002451.496763-12-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D346F1C0007
X-Stat-Signature: tksaj8kycsk8b83o7ymzuc6rd7q3t9hx
X-Rspam-User: 
X-HE-Tag: 1790146218-380495
X-HE-Meta: U2FsdGVkX18reOoGFGWtDIpfavFopsxjJAn8R+2lga4cYxP3P/+ulRygH7Kq9hhFkH5PnuCwnel+GlrEiaTMLsdheUXURtk3MuUBp9PY56lvuIXHHkiiaZnHZzYThaUu1xuf6hVky02mhenSuMMoFJXB5atGirYS8ERyGu/X4A0G2+OWYNS75WY98EZXF2Hwl7PqVt/JJxmZfi0vi1pfe4pkbO2XdfxuIf80gLg1kYDvx6hsSkj0klT2R6HQ/6WAEQcqsnxWgTrMuEQglgCW2udh00gwK2QQJOIXU77TdTjur2ALbbpSPS2mb4eI8Z9s6yHAhVoYVQs/EPiaVIq/k92iFug/0XQ7vHxw8agUdGooSD/aCrQCP55ionB7BopbNFXgEGhSfMz1SSERgmDX6r3zwwkzXnXU60P1c0uO1ZK8fYGzfpNJfwAqR55ThBLyLAevfOnMr4gQSaCKm5wMwApW6RHtv7x7Ww+HkJiTYBKJY8B3fjkVi3lCaJW04aZQ+cznP6uI5PVhFK6Y7jRmQwGwp+mZwikDmzQGS/iDRK8I3PisoiuoCctS/0m7qUo/4CHhEwOAbXHtAqN8zr/AvSjFmSAYR7V6Xolj7HL2SbdvayrFC/YQfrQo3uRLhm6OW4aiaDRSdrEDWcWppFeGEiyNF3U9ZCWB+Pq2R9sdKtjd7Grl7nPAUkF+StxN1nEMbBfpvZNKlveoh6j3tQsaG0mL7z8Yez8vQJODgzh2cGEZu94HS26eYw+Cb0r+t4RZbM6z2dUhe1n5TGLbre08+GSRlu46Qgdhi7jR9xeuELpn+GQ/dqLcLQXNq1auu2RylXaWsD7LW0ToRWeR+z9aRb85mtZ2wQVQMss1X2N0KKdy1BmOh45nFLFNXfNS7YUuZqFq9Inufuj/zvtfoDqUlk4E8YMV5FzBPnk5h+VB8TKaWtTZQKbX8G1G1U4O3RigZaayuZWX7ZbOFPTqPyz
 138G+LMg
 rK6uNes2xONernxqYaAMmw77eaSGXERaWC40bTYBXRzTbJf/HnkmskWTxLAUlNfEL3UTlSkapPtiXrmgaULH83vy9lyPFcK3D1knC8IgnbGuh1ZUlyVsuS6CbMULW2SOkI0edDcrECDUz0l7oCTkHcly9cYt7I08jW3uBRQ2U3ByOFHzOgiULX+TOofrOJdUKtd2mEbkKsDAFXW6tI3uetA3mFrgvZIMnlf0XMCTy8bCCad5gsRF4p3Xv11bCZYf5kAGXlOg93lhL2F3xdBcjaWG6ds2GP0q2hYJqnxvLm05KOuY6Y1WAnFysqAsfCT5OBWzCtIK8t59g9D84cRaMXsCTI6JvsZyb/ndYtWnQfp+wN5NvTdFxGqz4+Cf13sO1wziI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The mthp_khugepaged context runs the generic cases at a sub-PMD order,
> which answers how many folios of that order a range ends up with.  It
> cannot say which order-sized window they landed in, so "the populated
> window collapsed" and "the empty window next to it collapsed instead" look
> alike.
> 
> Add four cases that check each window on its own, with the folio-order
> helpers in vm_util:
> 
> - collapse_order_single_window(): only the populated window collapses;
> - collapse_order_partial_window(): the default max_ptes_none lets a window
>    with one present PTE collapse;
> - collapse_order_max_ptes_none(): with max_ptes_none=0 a full window
>    collapses and one missing a page does not;
> - collapse_order_mixed_sources(): sources that are already large folios of
>    a smaller order collapse to the target.
> 
> Each case faults its region before MADV_HUGEPAGE with only the target
> order enabled, so the sources are order 0 and the result can only come
> from khugepaged.  They wait for a full pass rather than for the result to
> appear: without a completed pass, "not collapsed" and "not scanned yet"
> are the same thing.
> 
> Assisted-by: LLM
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

