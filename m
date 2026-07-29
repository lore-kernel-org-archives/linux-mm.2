Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610B5C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3CA6B0127; Wed, 29 Jul 2026 10:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DBA6B0128; Wed, 29 Jul 2026 10:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223196B012A; Wed, 29 Jul 2026 10:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED84F6B0128
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:49:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1444F1606AC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:11:53 +0000 (UTC)
X-FDA: 85041549306.21.3E3D262
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 96DD114000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:11:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=cbMo6xHQ;
	spf=pass (imf09.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=4SMrxZFu5PL7ZJ0IMWWAVx458jkDG5Hh2cXO23LVhnQ=;
	b=Hule30tvqez/AVzkKxkK/gIEkcZorEbMempYXwckRIfcE0yAcNBe03fX648ZHApwfcKu/j
	v4IoAqmqYObWjue3PDHa41Vlbii0av5/lgQcMcUjFf9rCpuoAEJum05f9rP65uKz+Y2nE6
	oI0G8em/FsO8WvIA+rtz902oA0nPdpU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=cbMo6xHQ;
	spf=pass (imf09.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785323511;
	b=3Kpl44d2sJesUCLqgW0YupE1rbnpwMWdEWVKvK8Utht0WwwOAGoGMKNgbVo/yqqTkbkrJa
	XLVNZJTHLIyw1cQnftVhcRblpNbMfsprGCJ0b4ivqaY92UFQbuaF1yI5xVvlyJsNVmdUvt
	CEF0AbXFjNl49TIZmJdUy1NKQuoI6Lg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Subject:Cc:To:From:Date:Message-ID:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4SMrxZFu5PL7ZJ0IMWWAVx458jkDG5Hh2cXO23LVhnQ=; b=cbMo6xHQxDTYeWOvZyxEE9tkru
	57QStZ22zD/EOjiUwUwb4L9di/SEhfQsEwTFX3IjUwYRdxffKjteC8X1j7cuTM0Hq6GwNxMg6pE+7
	IzEirJ42pc5c2qJgY5tn1ChTX1U9dP8OaVqdPf/4JHgDllYwIOvF2cd/lJnE+ezuX0qHi+EAUYEOW
	obUyBy+DEvmzwpMTBQ2OguorvZ9pfsSv+LRmAvGd1KchcQsMbxzMJHgnVAO+l+Vzw4ru0262mB4h6
	oOdDKdBh4cWLD98pMiWjo/HXXigDesnjTQJ4jVYW6VdHP+lHumwL7vaed4v5ciKacsLADZz43K2vG
	e2tZBOvQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wp2CM-00000005hpy-1oc8;
	Wed, 29 Jul 2026 11:11:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id ACF023004C9; Wed, 29 Jul 2026 13:11:40 +0200 (CEST)
Message-ID: <20260729110807.797920433@infradead.org>
User-Agent: quilt/0.68
Date: Wed, 29 Jul 2026 13:08:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Juergen Gross <jgross@suse.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>,
 linux-mm@kvack.org,
 x86@kernel.org
Subject: [PATCH 0/3] x86/mm: DEBUG_PAGEALLOC musings
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96DD114000B
X-Stat-Signature: ptg3qabdkdgfdzyxja6bj3ksmou8mx6d
X-HE-Tag: 1785323510-12703
X-HE-Meta: U2FsdGVkX18jR/RdiqeoNb2ipbI/wBhgB2gzdNK3DTP9wYtFT8V3S9E/SZKQG5vjePddJbDIxD5X8mNce8oDc7G4r8k00D0MFeYAdKBWExg/iKN7jEPwXWGsHarriIr2v1F+3n7qxt8tziWEEuEeJyNpVDMih3pINNeprqxoT1pMzFTm6eNcY2Zw4dx8ry0eQWIUqi3VJW82Ei41RuetZAQiwNLLIqwwCD1WlOZ60l36jFsWTQjRKNSVhdKVieRZaxpYiYyUkwWtRrDcERub4L2z+V3rA/+g6lzxwCUnljMQEGvoSn5pjjWGZAq8nwfZDYQiGdAbJ3fxaPgTAtLfkJT3ILKeNmLDGSWvdSJk6dJVEQP/t7W73VMaB8vtEh9frtEPu3ln9nN9dvP4zaW+TKwIkztwc4kQtHong9qGEU8YD4NZVLlRJdFp62mSeuqsHZbwpBjzibcfe3hPfnwuHfggK+UeqxbFrQiHLot2Dagm+EiqnPC2qfZ955ZUJ1Sq51vslANxwXzBLJqgkMIiyTy5j90DDy/cxplddWDaXLNBlTNocXyF/0btdADW6Qi7/F4QVsI9NTTfv4B1/ii+EGsxFDU4a2S+0g0npMWcEQyiZYx5M5q/EHD6ZXVhBKYL0W1KDgGZ8W1Z3ZaVn9ehlCaO6VymGUOdZkfzsF8XlLfibhCMAZMDZZ0ZdQB4QcSpYs+sNT2cahU+GhohOg/aA3pC5C+zT57V9AllQwSghMCm7iUp5eTruC8yGnz29ulFsa5sLYmt1x/z07Q4WPhDLGXCcB2m4JzGOlhKJQKzeLoH3Wsm8ah3e6wupElISiSW+fjqOd1GaB9ThKZB4Mq7cdtVE32DvqoKFmamdVjPSVbBxHjWQ3EmFSChkrs3KLMHggT7ZtwHDc7Tv8rWhr/rFuPUoawAG5cLeQv9eWbPmMQelus9tpO4Qi3IDedm4tV93rw3c93fxVgN/ZJe43v
 iycnCOca
 fetruMyLNiHuAiq3M2wFU0rUpIXmrzTbfM630W9D1bjQTcSIIl9qRkZMzqBN7wTMoG19Gr3RdZIULta4fSpxxTuDS3jGTOWZqXp2QjGIMqICzrQ5bELIa8fvbFQk9UBhljprg/2t95Nemk0nG2MHCI7Eqd3YQxsp2yelhGM8bX/eR32IJF8zLcevNcu9LL46V9Am8pkiAu3oHSY0fe0S2LtfWivLRAv0b1gChnWKYl12dqdKc0iR0hA+qC5EA6VGGeJvWcrOCo8W5yqCGZnJM4A4pdsSimNqqHt+dOY/gyhpcbo7/qldn6cf+hnV+qwEmNsrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hai,

my take on how we should be 'fixing' this DEBUG_PAGEALLOC thing. It appears to
boot in qemu with debug_pagealloc=on and such things.


