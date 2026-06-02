Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E41CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA7D6B04C2; Mon,  1 Jun 2026 23:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6845E6B04C5; Mon,  1 Jun 2026 23:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A596B04C6; Mon,  1 Jun 2026 23:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 451126B04C2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:30:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E31FEC0B47
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:30:01 +0000 (UTC)
X-FDA: 84833543802.09.F4281B7
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9829580008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:29:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SnZv1RUr;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coyOUsvaOjNin9zL0dWryXVgwBZsowpVXbprEgp4Mbw=;
	b=00Y/HxgEGVjsNnP+JUlwj9xeY3egqwe1+bk2mwEq+c2P7wS1A+8VNcFhejte3zivzKhYJ+
	QDkUy9Q7JJhRSGcroafaXXmVtI5XAM5TiIySgml5i9NcBfuXIKbEhPioxxFgXqN58HJ3yH
	GpAuaNJY6LuHDlO2LjX7qCa7LVFVK44=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SnZv1RUr;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370999;
	b=ysT+XBKLTcm4LKQ8efiMMyMKpaoaZlI0euPXGSMq4FAao//5q0+OX+BbQQQBYAw+989pw2
	WnyODl5lEZBw4lrMu6qlvgSfjOwXlXf+elDu8y2VRlFC/tskeH+CvQ3CwkUJP+vTapfZNC
	xujkZjrHKcHcF9ffY8tMW4U7DWQD804=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780370995; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=coyOUsvaOjNin9zL0dWryXVgwBZsowpVXbprEgp4Mbw=;
	b=SnZv1RUr+aHlxJTSGO2+uyE2+uI/Uuu2dwZje9h36VeWKMnXBgHEnTqnQR1zbj+wMrIXDR6xOF26jPxdmFTlJ3+aG1Er/BZq6IIrnH5H1wObE5txLh71usp8CdDtjcHTTudVFIjZk6ldljLRx2cbJvKmLngzKvINtF8dt+P0rqg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X42n0-6_1780370993;
Received: from 30.166.17.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X42n0-6_1780370993 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 11:29:54 +0800
Message-ID: <964254f8-2b98-4540-9e00-3d07930bdb24@linux.alibaba.com>
Date: Tue, 2 Jun 2026 11:29:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 SeongJae Park <sj@kernel.org>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260601083044.57132-1-ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9829580008
X-Stat-Signature: hquco4dun9xrrjk55sbmrz97czi16zfy
X-Rspam-User: 
X-HE-Tag: 1780370998-365882
X-HE-Meta: U2FsdGVkX19fh/umubG0CG4ujkPSPoFAp/UoV0gFJ3FLINwgk36FqihH0jbm6ACqaXNb5yy3Km3JaMV4nyW6OYaBQLYyJOTWYV/+3Q4pZFUb5Wfqy+aAGupw7nzc+Q1fQvj8U1XBoNdeCFRe9a4xkJdMwCcSCuUMYQ4dkqkBkpSlJK+zghvr8N80617IJDsEiGrMRQ6e5EnV004bGREMBam4Vc+C5d3c8YOubgT+uQ5xJT9mEQ3cXAOtdsCTdaqK1ZL4WZBosCT3Dcadcv4LSTZRJqCx/MhH+9WI9x50FkPl4PRhUG/nJSI4qgYSMyOR59RdaALl4rivG29adHioIR8VmkyVVLhf1aoD9262vxflEWfO1T0s5oZCk4dbOwiyhch0W16PwSm1MDHSis8tDCRrSS7ZBBnsH1hvk9G2dTMSZH/h0k1xyyVE6Z2TF/FQRqzazh9WquHFbjZxL7rZ4KrQkdS7JZksESahHPsBXLs55owb2wiOd6s8RzPstR4VIayIi/MeGqMMKP0rfmtTQAdtmWDLllkiVxhnsKdiRmWQGZXwFJGyPYUTiEekHD5kI8wmizxWb+Icl6JivCsMpgssaZHsLoBoe9CgNaOMr33w9TjG0TYqsBAZyF1U/RvUHGb2idFtsr8ako/1sF6O4FWbFgdBKZQUoZD2ITDG6PFPUxS5TGrvgM6hzO6nbFsrEnE1uGzwhLv4SuoC0HpqvXBi3VFjJwkFqWH9dA0y0tPbrfOnOLCmmZp1tjJnmr+PQ84CfwfGZkO5gbRdzrfZBgVISoTpoSUguu5Qcr6GKlKVsJ8lxQosCG7XBg2cuNRsVNyfqxcJPcxzH6QNFgxjgppOaeWn2YxvLnF07qAhb58k6Wc7OeaCJ/mvW8v3ugPGr5U6j+0LDQQ68/cj07Qa2UaHo90qtXAIUEOuHoVgw//kDIG3zon4vlIMofkyXdSyEz73m2fnfgcG/EoDrq1
 FMWXNNyN
 znLno8HjHUOOCopITJvhggwoizn5FP78a238lmh57Xxa26l8OPRUueBi1ZLdARMC5msZdev7OGiQ+eCjpGHcYA18UWJlnRoNNvDjwIp/ovlSmkiyqGm/Oxpg7qPywgQBiyPXYEsjB0UOWBQTsUpz02Vbln+5pN9f9RZ7k7i08UHPpp2jk7Oih+q+9fE9tMDyDmm1AvYDwG4hYqy2t1TXi5Vys7vwbrOAgzc7zlFuVPrN7gSkOeRdTVid8H1+ySf6nOWeevyfFZ0ZB/7NIHgUqRt/0kqMeLHwxNVz/ECffve+gLTrPSrnhlkYchw68//upbsgVRtA/AwB1BmDtb8xAY9pQqEwSc8jOSqj4D/4pjFMpHTInJHrSZ2T5Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/1/26 4:30 PM, Lorenzo Stoakes wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") updated set_pmd_migration_entry() to use
> pmdp_huge_get_and_clear() in the softleaf case, but made no further
> adjustments to the function itself.
> 
> Therefore this function continues to incorrectly use pmd_write(),
> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> migration entry should be marked writable, softdirty or uffd-wp
> respectively.
> 
> Whilst all are incorrect, the most problematic of these is pmd_write(), as
> this can lead to corrupted rmap state.
> 
> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> pmd_write() on a softleaf will return the softdirty state encoded in the
> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
> 
> This was observed when running the hmm.hmm_device_private.anon_write_child
> selftest:
> 
> 1. The test faults in a range then migrates it such that a device-private
>     THP range is established.
> 
> 2. The parent then migrates it to a device-private writable PMD entry whose
>     folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
>     (accidentally correct write state).
> 
> 3. The parent forks and the PMD entries are set to device-private read only
>     entries, entire_mapcount=2, softdirty still set.
> 
> 4. [BUG] The child writes to the range then migrates to RAM - intending to
>     install non-writable migration entries - but replacing parent and child
>     PMD mappings with WRITABLE entries due to misinterpreting the softdirty
>     bit.
> 
> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>     set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
>     both parent and child, which are therefore AnonExclusive.
> 
> 6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
>     entire_mapcount=2 and we end up with an AnonExclusive folio with
>     entire_mapcount=2! Assert fires in __folio_add_anon_rmap():
> 
> 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
> 				 folio_entire_mapcount(folio) > 1 &&
> 				 PageAnonExclusive(cur_page), folio)
> 
> This patch fixes the issue by correctly referencing the softleaf entry
> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
> 
> It also only updates A/D flags if the entry is present as these are
> otherwise not meaningful for a softleaf entry.
> 
> This patch also flips the if (!present) { ... } else { ... } logic in
> set_pmd_migration_entry() so it is easier to understand, and adds some
> comments to make things clearer.
> 
> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
> device private THP test infrastructure") which first exposes this bug as it
> was the commit that permitted test_hmm to generate the test.
> 
> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") is the commit that actually enabled this
> behaviour.
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Thanks for your detailed explanation. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

