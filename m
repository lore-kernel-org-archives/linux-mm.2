Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C36E9A052
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522296B0005; Thu, 19 Feb 2026 12:13:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBB36B008C; Thu, 19 Feb 2026 12:13:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF016B0092; Thu, 19 Feb 2026 12:13:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECC76B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:13:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB0FC13B6BD
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:13:30 +0000 (UTC)
X-FDA: 84461852580.21.65F1885
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EC7EC0003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:13:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bubQfZFZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771521209; a=rsa-sha256;
	cv=none;
	b=01a5nKthQSyADhA9Nbe6pI42YIVRCUe2o3789dkkcFTAZzlQaDHU3eNaReajqHbqVKzW3y
	D7NPpz/AXjTMZEmfv87Ufa6fIk6O6MIkGtmA26O7lfmhmS3AdhmQ6fVqUxJIoecUlzIDbQ
	1kaGkFyB6KYsq1y+DJqVEvX+1nDI8j8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bubQfZFZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771521209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msPWRo+gFrElWrkBp5gqc0EHMQtZwyVpZrcigBdREQY=;
	b=roLNugv/18qtLYQIx2UdBL0VrUdr5bwjjQXJLLK/1Qg3fvY9OX7qIjRDmXXFKyYsPuHQQq
	aug713Danm+Ox/vOpjQA+KMc639B2CczQbHHP7iIB7j9toiGPaPf0EKsIu9eCgpK+7tYZM
	f9TuwZwkmwzZEINOPxyDhixQB3aKYU4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=msPWRo+gFrElWrkBp5gqc0EHMQtZwyVpZrcigBdREQY=; b=bubQfZFZw8ANEveARVK+bO4D5P
	5SCQTd0CKmfEd/68ha+1aZS/N3kfjflgp4PcVh/Tn5vWlK0xxK9vSkmTPGAjhgHDZbEKDYpgzKzCX
	lj6Nb3tGgRtd9j9JgtKSTzJVdooXgt9v/M9sMizGuu+spmSMfZuxJBG7J7GoV/aJyPSleWtzQ/Wuj
	p6VN4cLQOiQ9CVoD3SeEcIYdm88ZNtfrpxlReMp9gctWvwKYNN/5Z8oCBLWlC3iCPnuLWGooSyFia
	ewyC1ptezB6BYfQ542FbB6q6XrQpHV8JIX+uUbOMOqWcYahgoFRvaqMBK8wbmM6vWmG41ZkdZVnw+
	9O6G6O3w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vt7aZ-00000007vdw-1jEq;
	Thu, 19 Feb 2026 17:13:19 +0000
Date: Thu, 19 Feb 2026 17:13:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>, riel@surriel.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Message-ID: <aZdEr32uMfTGjChl@casper.infradead.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
 <87DAD8A6-85E7-4BC9-B81A-4A842DC546E3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87DAD8A6-85E7-4BC9-B81A-4A842DC546E3@nvidia.com>
X-Stat-Signature: ux7pbgk6aimmrtmwu5seqono7r5w77mh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EC7EC0003
X-HE-Tag: 1771521208-566715
X-HE-Meta: U2FsdGVkX1+sQ9I1ysF4mhsg4PPvEt9j+xw+PUWZJlP9aUBOh+9hK5R0paXjHPGbuP78f7kPnRpfx/o25s/l3cVKb2+9sCOcS4vNiIS1JbAH/peGgq5Ola4tw1Xbh7rwZsV59Pvd0mPr8N9Uc104oNn3LoWssItaNLVZSsCXrq3EQskTCPAk7vp8twrWV8v4AK4rFmsgpL8e2iTXbjY0+airIMFwo2ZEVK6bL31egdrYNNwSoPoEFOuyyUbDzGFvWtraA3Sdjw0lvKrLj/JVCNnlLQGfqfES3z5e/1QWo/cmYkAEWwjq0ZVSF2I7k+HbU+YPuejr7K04qVAs9cir6pkpJEsSq8Qqr5Vd3zOm0vcbb9ZS6VO6sm9PkOBgZxqX2BXAguJ9A2rC+b2Jpt8KI2sFfsf5tFwjf8SREez82gXa3dhn4hcnSBfsYWkxy7+wCYl7ddZATi+ERjZvwbkCiKy/6Cb1OxgrgVEXhV8/BeQQmGVCU4jHXJNk8yMPdmm+FjcpCNBztnpeT1tmFx+nZ6JJcI8UhFta7OTdwXeif6uY3WnjFLQbxvv6p7csO4UY6LrC3Cp/uqnXCwIeTn/Dcr22ttPhjrh1bF9jFOW801n4YhIoiS+rlkFRyEMNNXj8nNPEA7s4D9190k3Je7SgUaTxASdOpgR8LzhQHaqerOMJXluU/ZpeqH3890iJf5LJBRqMyezhx0t4ZiG3RCM+HmA+v1ERV8c0Xd/ZF0eg4wwGlcrZp9RnQxSDrfmH+0tflFcFQKXGAFCDVOqZ5r1Wm9jRxQbILshvdNtgYLd9yThqrV/1bwB60+iWHrGcKxZp8g/Yd79HNxx3gNerRd1lvcUtgz7umyNM4z43JyfSvVhWQd487xQkMk9nwMdqv4wUYvJ7KWokXLL+6EbaW+e2V/RdUHdqOAOnM7l1K/BaYoMxoP/zBxiebXthDo7hO730eIEpxioPf1EHA/VyNUW
 3q3fRkbx
 cRxZtG2SBCg2sYOvXF6yQT2gJa6ZwKvLK8zV63HQ7LFh6LPNIja439FB4Wl3VIlTiPlNhnZ7kolXH8SyK0aViDVvsHr3UP/EGq1LBHvTNGrUcG/G7InV0oyJV6gpyiPx28QUu/gSQnjidJeKTb+UDP4Wc8HfcpS9o5V5tnomUkux0G2Bz85tp2cAbr2tz/JhSRVUdpUnSrutA33NS+GDh0gl/1qTiwojEWuaMQWSTjTpTMdqu6/rnl7hhqwnbjDKVuOoF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 11:49:27AM -0500, Zi Yan wrote:
> If HW can support multiple TLB entries translating to the same physical frame
> and allow translation priority of TLB entries, this remapping would be easy
> and we can still keep the 1GB PUD mapping. Basically, we can have 1GB TLB entry
> pointing to the 1GB folio and another 4KB TLB entry pointing to the remapped
> region and overriding the part in the original 1GB vaddr region.

Uh, do you know any hardware that supports that?  Every CPU I'm familiar
with has notes suggesting that trying to do this will cause you to Have
A Very Bad Day.

