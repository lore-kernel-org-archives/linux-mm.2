Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6364ACD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 03:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B306B00D8; Thu,  7 May 2026 23:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642D06B00DA; Thu,  7 May 2026 23:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57FEA6B00DC; Thu,  7 May 2026 23:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 485056B00D8
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:23:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8D001C059D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 03:23:12 +0000 (UTC)
X-FDA: 84742806624.07.0F699C5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id D352D80008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 03:23:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLNfjoRb;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778210591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wamRUvxjWlqEsV1JMZy9Va3V7zbfvaQwt51lgTFp7hg=;
	b=iHtTxx44l+4p5tB56WQlMH+8zusOxvr4w4b4JuoTSvHuWV+VT2cmJ2w8MlePJKYSxE8sy+
	6bn4o9TNEBRigXY4C4eY1cknplnDsmWM21Gna5g777wwUgrZEB07Ig2sqGyIHL97DSFrfG
	V26YVLgrmue4WtWIioT3v87jqSg3SrM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLNfjoRb;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778210591; a=rsa-sha256;
	cv=none;
	b=m9C52ETvWy90ltXNCK94J/NFTfIeAEMAGFRAnVLx2TpAMvQ4QudXDjLSCQ9lq0v/6PMdP2
	vfwANq7MlJo8CtizQ/L8xeaoo8ldo7n8n+F8hmYAEIeTrh+6D/pXLLzLK0MXUQv5jK5Goa
	hRozLdaBKS+jIkRzixSc4FvDiyzVh0w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778210588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wamRUvxjWlqEsV1JMZy9Va3V7zbfvaQwt51lgTFp7hg=;
	b=aLNfjoRbLy/9OdKerp4shVKvFDT3cB579XDdW6LZGs+NefsYE5jd7oumC3mDsweRauB5lj
	LoQ6mI57hKDtlXBt292fCUa1VEOR8cLHq3qrHr/xXvhszjg8JjvjuX01NI+nF9lUor63dp
	q+5thdb6fjyQQVBoHkEUuV34QCAJKXs=
From: Lance Yang <lance.yang@linux.dev>
To: richard.weiyang@gmail.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Fri,  8 May 2026 11:22:53 +0800
Message-Id: <20260508032253.1659-1-lance.yang@linux.dev>
In-Reply-To: <20260508025239.ooz5kc5a3n372ebb@master>
References: <20260508025239.ooz5kc5a3n372ebb@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: grxr38up7tg97ns6pghxkyfkb465itik
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D352D80008
X-Rspam-User: 
X-HE-Tag: 1778210590-773224
X-HE-Meta: U2FsdGVkX18K5wX9FZq8Q5phPVZw1l119/MlYOY3srWW7I26AfXAAYF63CpIxO/aK9MaKAMvr0IEXkOEh+Z78ZFxTbbGS68zUBR43e7e801cpJiRxiyH7XHkN9MBH6CvG2JTUHuKDr2jMlhN1HWKRuuHFqIxLbAEIzSpkvwG7vjHxDWBQFU/Hv5DpnRKMxCCd3knJC5uYH6E2hqZ1Pvo7zg2qVosDeMac5emcN9texKVB7b3N1lqXF7TlaYnpdiuxo4vk59ug2xZ3oN+XvLXkLGBKRznzvYpBI/nBle7bNTIeb91YZeJTilffe4ZnxJFQHIi09elRAUw9H45khEQK60rQk+1ZIvyzwLgFdrxqOPdv+hiXh8utD+ldRfqIz043rnm+pS4Xmdl1+s69HD97jFWXY+OphA4GJVBpuBhiE3xblBgIz75bMUrUmyGTp4OZDe9ZGnzU9s6xxQJ8WcixzIi6q8BZ2VUkDTgZFC+/H/bLcCNEY2KUh3D01hbvFj7422O2yY2OVI5oY8ohsM3ldp0pL0g5wUEhifqZh4FS1CbdAiDXpNe3efCL3zV8AtNZ1QvJGO+tkLYt6yPTFDPxXaikKe1GC5hZsUXSMSbceh0iUrlWfPehkEKasbchmB/7x8XYpjVqqYJsiiH0N6O16Q2xoVKKFlJVbwogfdrcOF2W5XtMzAaCpNnayPXH5bW/1i1VyDA/4WkujBBRzSSOE8OTjtG40696b9hJE4TIa2Vyt30iamz4OfwjNTV5aPHu4vrHCoZKrSQPmPjKNsNnRp/xsJ7bv+pPPZY1/jytAaZg9NWBSqR8aBEMuh6uEDsZpfO/84nPAAuf0o5Zd0ZANIpTPmr1UPOvwyaGC7BwHWh42xmo2gRM8zk2hnXb0LPiA+qhXxHgBV36u6pxikvinuxn8L3PwMVHRVwFRtnbpyWzaxAx+sTfNL3ugiWHoyz5m85eZ+VTdKtcm1x5Lk
 Tr5R56qZ
 PrlNbAuECstiPFs2Tfui+7HcfN8xQxoipzj7zLg7wfK7tQdwNMp8bRoKMd3Qci614ft0DRchb35y/okH0cQM+667nIfux4DFLvCXVK7ZvJiiVfw2nHugTK6ikT1gV/78a2/4iK1vr388S5Kl1Qtw1lOUJw57fMMJ2MQP4R+De1SWByDr46KHhtMx3FfJEAd+SXEMTazgn1k7//QGT1xpHcmqkKdW5VqIUDt4NJW/zUmQf9GrK9cRonsCTIg25wlAtn8Il5fPLcAVXwggN3mcv4OkLFPlEGnEs9C/fYiCdNpXEWeAkj5qAdpmcrycka6yreFI6yqynMTUBjEYFAq2J/0K99hRxXYGzjl5V+v7Bux09Kto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 08, 2026 at 02:52:39AM +0000, Wei Yang wrote:
>On Wed, Apr 29, 2026 at 11:35:28AM -0400, Zi Yan wrote:
>>After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
>>khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
>>support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
>>so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
>>mapping->nr_thps, which its safe guard mechanism relies on.
>>
>>Signed-off-by: Zi Yan <ziy@nvidia.com>
>>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>---
>> mm/Kconfig | 11 -----------
>> 1 file changed, 11 deletions(-)
>>
>>diff --git a/mm/Kconfig b/mm/Kconfig
>>index e221fa1dc54d0..27dc5b0139ba6 100644
>>--- a/mm/Kconfig
>>+++ b/mm/Kconfig
>>@@ -936,17 +936,6 @@ config THP_SWAP
>> 
>> 	  For selection by architectures with reasonable THP sizes.
>> 
>>-config READ_ONLY_THP_FOR_FS
>>-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
>>-	depends on TRANSPARENT_HUGEPAGE
>>-
>>-	help
>>-	  Allow khugepaged to put read-only file-backed pages in THP.
>>-
>>-	  This is marked experimental because it is a new feature. Write
>>-	  support of file THPs will be developed in the next few release
>>-	  cycles.
>>-
>
>Hi,
>
>I see hugepage_enabled() in khugepaged.c still use READ_ONLY_THP_FOR_FS.
>

Yes, I noticed that[1] as well. Maybe it was dropped by accident :)

[1] https://lore.kernel.org/linux-mm/20260507044938.12529-1-lance.yang@linux.dev/

