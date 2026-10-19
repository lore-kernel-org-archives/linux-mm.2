Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 262C0CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7686B0129; Mon, 19 Oct 2026 01:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8466B012A; Mon, 19 Oct 2026 01:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF136B012B; Mon, 19 Oct 2026 01:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DEC956B0129
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:19:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E345120615
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:19:32 +0000 (UTC)
X-FDA: 85338222984.14.2F66783
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id C29D61A0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:19:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D1ArL3e8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792387170;
	b=vQP0kQBlczrx4SdeQCNoOOX5RTK77i5hFuNVFAAPtJPVEu11u3RubK5epdyOkg4Opk/tmq
	ayqNleEcvUlKuD08BNErsQ0lJeKAqLJ/Le9IucAAT5CZV/AWA81yXr5vB7Bm91oRgeG3c6
	0IJ+OFqJXFWiK8fWYyF3qXsBxye0luk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D1ArL3e8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792387170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44a81IZQVqgd8LsAi/A8+pToSVfchqW/w+p/QHTqlZw=;
	b=CLKcHk3aWxPteuTOwjpHOg9UpOIzoa+XEGHh9ChKrzOduE25LrzLucbTMNYot3PY5puFNU
	00flVB3WrJqrUZqm3grm2fUUtpDdhQC0WKRfrmRpF/Oj0IwwsFhksNZUCxyD9u4WqMH1Fz
	SHLXhqcO4at+rY74zlDrQxKqoHz2FeQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A29F81476;
	Sun, 18 Oct 2026 22:19:26 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7458C3F7B4;
	Sun, 18 Oct 2026 22:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792387169; bh=lBGyACrtjq6WZrbHlbL0znG2pYwXe/nMyJBchdfWqDA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D1ArL3e8cxYaem7De2nzQGn1M8hPLh3X9J9ktY1rCv+i2/MIPVjZzr+5X4IIbHYHk
	 EBBlqGho5lsaouLtwK1El19xeUsWuF9WpN18/+UflzZP+AwB3FXipwefb5fk22JOVz
	 kyiAS0Rnjrr1P1bldxMvhWr4Ammrrp3wjum2zLh0=
Message-ID: <d1563456-a812-494a-a473-9f485d51f693@arm.com>
Date: Mon, 19 Oct 2026 10:49:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] selftests/mm: check that unauthorized MADV_PAGEOUT
 skips large file folios
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-9-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261014175756.2035176-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: C29D61A0007
X-Stat-Signature: ifhm1qqo54ayp7uwaiqyansfxsa8kses
X-HE-Tag: 1792387170-272998
X-HE-Meta: U2FsdGVkX18eogthFWr0E6h8X8nNqsm1qYWaRItoPV6y8ZClioUtxSVzw9lC7aTIra+n2Q0lRQq4T0CL+WGkfMJ2LOBDWSadYzFkCyYuzfL8RLg79yA7CRtdcnHIQcBujqoDevI1NCsW1AqQGpPTc4zBeSAed1zo9tHL23av8ZV1ERGBQqRMyYdzWPlYfdR0X2ZzelvuJPAMXEe1NgRk3TNI1nzqYPagrncgf7ruTWXd2MBZVVXaxYoT2HbDoY6/Rnly7uH77FHdeF1etctyUvG/NJtbrT3ITN5fPVnM0QrRbDSrqaw/b3xY0L6KcJRU99i3uJ9LTnBywMP/s7nrQGUp8ZcXlZ6LrKp9Xsq98dt30NCaq+CmP2gzY9ZtImInGY8rkgSQq9wKO9xDqsSWYZD94cXWt0eGqJd6HYXteWWe87jA7YwAwMMM/AddZ2/7JyGqtddC/1l1VR2pknZkRVSGa86KJulA3OwEjMPTz+EB/dEMFbIvYfpqVZbZavg55EXvPUw6MNGpFGDR6fwt0NRqsv3Z+g4Tvi0lqAb1yAemy5TO/OA7gVDlHp9Vcb3wlhGlqrBOqJIsh2kJaWwncSlnVOcb4XYLPr02+Z2CvKmPoEMjar/CBAZqdKIpOGPB+A50bgoloMqcnreEmN6MEwPhwZQHMyQql1zkwIKA4oRBh6cz/Kg7jbKZUWSO9FXEbHKL0jsnws0BuxAJuwhKXmOyIZztokw/tA7qeOPvQnk74S/TbjQjU4o5o/GYPrVNdN9lqWE+2gRUoanaoMHMfTH27W4JJg+B/KWE+9Jyskgz50xaQNxZWAZTZ+ZnfFX0CUFooYXD/GpqSQez2V0UhC2MWjXHFumacPXZHcHA+Ql8Cpbcd3i6IrHkk2DyechgRqN8f+ET/uzhpa2lmEVkSY5ddkxaJWFEIKmuvisEPtEmP6om1+IZbaW8wHRu0XHAr8SdWf+p+fQYGHMnoaf
 LteEKhl5
 L5oyE94NV9pBrUJhlQEXnZMDcKhSa+vYq8H0BeoPtgIRaocghQhxPbvV5Uk1jj4WNu4J5JgomGGuUa1FMreRudDAC0xmdESsxk5FPkSgPuAqQ0KgKg7G577Rvr0I27rswHpCN1jimouzwp9qe/jfhQ291XNLYTrPXNDRyun7cZlmiN3kuN+BP0A/PJ5vi+d0HwoSGgNZ3MxUfN9/aMCfbyC44JrpUsYy/LLLTSeuM7iQghb55x0pTLBprKNIK5hxZAkqltA0rGD7expSttiYr+TsTsTTC7VZuAdqQs2PfLpQ8FM1fWjUKOFkpBOxpX6DtX0DnJvHLtnFjU4ZD/P4QjCt4grmjNMjxcbO2300BctKZ//Hy1ibsZMjjLctI7WkPwxfTzTPORxeTzzUtsU/3hNMX2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> A caller that neither owns nor may write a file may page out the COW pages
> of a private mapping of it, but not its file pages. When the advised range
> only partly covers a large file folio, the folio must be filtered out
> before it is split or reclaimed, on separate paths for PMD- and PTE-mapped
> folios.
> 
> Check that partial MADV_PAGEOUT by such a caller leaves every page of a
> PMD-sized shmem folio resident, both when a PMD maps it and when a mapping
> of half of it maps it with PTEs.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  tools/testing/selftests/mm/madvise.c | 121 +++++++++++++++++++++++++--
>  1 file changed, 115 insertions(+), 6 deletions(-)
LGTM.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

