Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1419ACD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 04:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554D26B008C; Mon,  8 Jun 2026 00:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AD46B0092; Mon,  8 Jun 2026 00:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3E76B0093; Mon,  8 Jun 2026 00:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEF16B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:34:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1D4691411
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:34:47 +0000 (UTC)
X-FDA: 84855479814.15.120731D
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id DDAA920004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:34:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VPOCIBhM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780893286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEGSgRbxhASAeu5c+j0JYp3vSZy8pgb96WObfdHnflg=;
	b=PlB5wmbBmyxDARHHAfyOf4NHrt3y88uD05ziBSFVE2pmT0UIZIIFqKz8FL/GlNXQ3O+gcO
	fyxoKElBvaRjlxTfxdLNDiGeUSsaMByaGca4ZIpuOOm2GZ3Dw/Aq7ZKIbmWK9misAB922E
	MQ1/w5rjq7nkp8jM+6VptPulwN1iEz4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VPOCIBhM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780893286;
	b=G+jHu0PpHIzOg8nfkpvs9cpkCqxQwB+jKpxrFparualv0wXFTkJNxD8wu4GR1WsJmppklH
	qNdZo+IRs9vHME5VUrsFTtTA0Xntn6pxgLxgVrZHqQ2C3nnAUMIevEQGnF7MZZhgpLmORR
	76XCh66YK9Agpc1yZ5pZuQaop6zRCLo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780893281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LEGSgRbxhASAeu5c+j0JYp3vSZy8pgb96WObfdHnflg=;
	b=VPOCIBhMy3bhMys4tjIwpTNUtzP6MGv+Nn6NObx2oWwjAimmM3rk21c2FPdqpv4YaDBpr6
	0+eQK5sDLTwER1nbC9LUzt9Lo5gKkA2lIBYpEHSVZAfPNQXBG+/72ec7a4XSNLj89zDlRT
	6qmoBbe0Ok0yW6VRRc/UfKW3DXnFbbc=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 05/14] mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
Date: Mon,  8 Jun 2026 12:34:24 +0800
Message-Id: <20260608043424.55432-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-6-npache@redhat.com>
References: <20260605161422.213817-6-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DDAA920004
X-Stat-Signature: fh77krurztgjtfs9uztckiqqfhp6w4nu
X-Rspam-User: 
X-HE-Tag: 1780893285-991559
X-HE-Meta: U2FsdGVkX19evZMrWMzjwp9S+JdadVQ6//sSV6mGi7fkAAet1k7U1WEOToXnB5DGZ4dVoyH5yCDH110R9dUSBN0xE4s7XCeXF1Vbl33gBJyhICWkEvN2nXgAF9KlNG612tahtdHZwz2JzQeCYPbaehCVyrepJJvGg8KR15Jqg0Yl5LP+CvBOUK9p5UC8uOtWM003pzvt2vheGkd7fInAVKKRaxoyPNfLwZbtUS81Jzcr4G1xSt+vbDx9C9CAHpvXt2ivVBZgNO3UHKH/4JQ8DcsVkTvUWLBVDYEIb574bnO43EFb5LUkAldk4yCmnQacBvAS45+O20aT92UEOC+iXc8dLiSXsEnLWEnYsbjv9wLU2nvwf00oXj6VoWUWvmXK/KSJzLBeElkQuy8266048LGHr/ZH2t155VSsLcuNHisim1vGfpyj9hGu3AzJBeE2/poO1WQ+zd9L8woimuLAvHPQAhM1/ZGyhNrU5jgllX5dhpqHaho3H3xejhjK77pIlSjx0rOPm5iGQj9oXlvW3dH0J48OSppJhN/m07yRWCItHT9SdAMnisytwG5DqFKlC+OMMh/sUOgVCXROhCI+b8iiqL1lf6/SXSsKPku/RuUbmyVvwgK3WhhFB6s+MZUhIN0aWW/YUcMnD3SZvCr+sg9YPmd8+bntPO4seS+izBxZSEgzeVCX90kr6WYanEV5b/BR6b9/MrS+hMP8rF7sEUacvbjuAmQ13v1l2+qyjcdAgQghqDYvmhoxbj7/pVONnxyvR+iiiiixBR1iYJvfTBmCssjpxcfRDoF8qJ0J6g84FEXq5t2R5HlFTuL7lbcqafulseaGXmskvgKzINo01pAWTcajWNTB7xvAHFXJ53kbwZCE8raD3HJj5c+5ekeZ2AIPtm6DGNECdhvUzVLyPiwvNP0scMwVbV3sorhtozgSav8LJhokwYBvGOUF6zWw3K5EUnTrudTYZFnxP9n
 W5n1T9NK
 Zs/G8Ig5Sf9Ro+zK1GDYbKJIxnC9VkGXsF/KucgMt6eOR99vT+s2RMbxu51sfulpJmYgq/4/9RwyuYtzVGhqeBtxkEJwVPL0ZHueG7LLnUnYUwQXS0vapdoi1coGyBLa3rvUxQwdfgMhLbVksKz1DyA6djdNxT/7O1y/GIszDjEZXrF0QhCVCsIDoI4QUqo7wcWLzjo7mEkbhg3hF6ga1wNpEuMJ2nzVd5yE0c6CRMFtAaN8qYJnBtx2oDdev1roK8MQvb0LbxYRw0FvN3uzUC6C2JKfgRfLAJLVZF8jDFyYxktFFRCRCxpWnx96IGI+XijzvV99gde+dkjvRCQAE0jY58C4l+QL9qUsE1rnZ4eIT+775COc5uJGBfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:12AM -0600, Nico Pache wrote:
>Currently the collapse_huge_page function requires the mmap_read_lock to
>enter with it held, and exit with it dropped. This function moves the
>unlock into its parent caller, and changes this semantic to requiring it
>to enter/exit with it always unlocked.
>
>In future patches, we need this expectation, as for in mTHP collapse, we
>may have already dropped the lock, and do not want to conditionally
>check for this by passing through the lock_dropped variable.
>
>No functional change is expected as one of the first things the
>collapse_huge_page function does is drop this lock before allocating the
>hugepage.
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

