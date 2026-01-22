Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB567C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 04:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BC516B00D2; Wed, 21 Jan 2026 23:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293766B00D3; Wed, 21 Jan 2026 23:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F586B00D4; Wed, 21 Jan 2026 23:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 071116B00D2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 23:25:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C5DA13862E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:25:37 +0000 (UTC)
X-FDA: 84358311114.26.0324B25
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5ABF40005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:25:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UTOGQQ9o;
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769055935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiJmlg5WsTB2rZ1C0+qojdvr50gKuolKVQyUrO3LUno=;
	b=Kn0RPP9kSFhltTSp539muSR8FSpnxTBAkAMLMIdCpIKoAesOISH8dQIanWT/bvEbOCWsfQ
	q6+EQJmTyJORP4jJh/mQ4vxpdp8NPZg+huqlL7+4n6OSA62b1+XbxtLExHvlryI78kNP3I
	qC0cWFI+FwQMuwbISwmF2r5h/nLi2ck=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UTOGQQ9o;
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769055935; a=rsa-sha256;
	cv=none;
	b=xqQg1ju4iQAODWeWfQjvUg6MnyVYg36T5EnjW2n1U467QDLKvPyY8+xVDuXYElT0Tsjndc
	9WupP2kHIuvyf6y/oftDUazjIwIPCY/QUQLrLiIyNIaw9DRIw3ZCB9uGAmrJ4d7Ny/2sJR
	eFRs+VEc3R9mx8q64eYV11xoamYil0Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=yi
	Jmlg5WsTB2rZ1C0+qojdvr50gKuolKVQyUrO3LUno=; b=UTOGQQ9o1dCcjCh+IN
	R9TGhZrdDk4+UGiHFIVNnSDOyauUnfxnTiwUUy3TeFsmPZWzCTMLdsUB2tK63oda
	VuTD0iU3YTDY2NvYng23H2/XTajEce33uvftPhK3HbaDOgBXXqRhnmG+qA/rnErt
	sjJXDZp9BG5H6OBEiX4SuO6wE=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBHL2uipnFpPMcLHw--.543S2;
	Thu, 22 Jan 2026 12:25:08 +0800 (CST)
From: ranxiaokai627@163.com
To: akpm@linux-foundation.org
Cc: graf@amazon.com,
	kent.overstreet@linux.dev,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	rppt@kernel.org,
	surenb@google.com
Subject: Re: [PATCH v3] kho: init alloc tags when restoring pages from reserved memory
Date: Thu, 22 Jan 2026 04:25:06 +0000
Message-ID: <20260122042506.175897-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260121120804.d1334ea0cc66b4a6de691cbf@linux-foundation.org>
References: <20260121120804.d1334ea0cc66b4a6de691cbf@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHL2uipnFpPMcLHw--.543S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ury3Ar45GF4DuFy8tr17trb_yoW8tr1fpr
	WUXw42yw4DGF1UArW2ga40934FqaykGry5J34j9rWfu3ZxGrn2q3s2ya1j9FyUurs5JF42
	gw4q9340ywn0vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUFjg7UUUUU=
X-Originating-IP: [2409:8a62:11:dad0:5054:ff:fe87:d41]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgSJ1WlxpqTjDgAA3p
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5ABF40005
X-Stat-Signature: 6jjtbpmzxxq8ycmhh5eixeu6zh9rt48r
X-Rspam-User: 
X-HE-Tag: 1769055934-985688
X-HE-Meta: U2FsdGVkX19u1bs7dwsbVH+/yueAx6F+aSPPuJFPeryWe7YH4T/OH87qsw8rEMdeDr0bV/XSmxD5lIsSt4RG2xRpn5joukmqU1MuBE48ajAZnHqOLtkl+RTq1ZgJvpW+M77VRqvSX8d20VSHVN0NNa8MpwgxnL2MbAItFsffcxCLb4icQEIDNi03ZDTm48uyYxXsRhMUcoYN+/u237vqUztoWsk0yqApfIfoceKiEZ/5wXVW4aUQ3WOMO5HRuq+VYQkWG32+5Ad9FqlqE+JRNpx7XHglXLM3h+XmEwLGa0PES8rFSFnaFoU1Cvc9G8ufDrfad8ybTTdWw7q0iH12q//DwTTX1CP7TS/RAWNW56gib5WQQDpdjRTR/bP1YiCvif86Xf/RyG0bNSla//Dzcd2becUBEodMA4hpnagyx4+iRrBwjtnebU1kcM1V6F8DqIfPehDMl1t3PdwPqkPYLFshZ7meGDlgC8ENqwDr0IbTwNzXXf0lNuYTQtYHrmbpnlcyeLFWXjvpo/ibg8icGagoR9bVecsxLZpiYE6xzKibh91odl2iAXyIwAlfrgI19FoZfZJm2smERL/CmSMlW2YwewLd1Ekg5hpbtW5VEad4Mw856ld+YFfihp8p1SX7V0a+3n1iNjFlXXnQAciKbXGCikE+OUHFg4Md8N8g9z1Y3/CzvvHxVBydU8KEKhyr1xVa8evGJ6MSa8rs94Y38OBMTI01siz0oiMVALSirj/ps5VO49dqm4m+mQ37ACBHOuI3bhiZM56xeNLjxwH+qSQoPH/Nb+D15S1BRPHSSA7L81JdZLuNxo405R/MjAVr8vaWu3Vwj1nu31uvsBs2uhmyMF5dlVTnepAxxCYxuwKBayT6Q4RH6AU7YCYBIn3pvSrYcICdnl/Db6R/7SLCqsAEp4yfy4ErbZKI7C3FYdfa4Jbcz+gL8w7NlllWS8khMx6lnqnROkHgZWmZCrF
 cPJZrbCq
 dxo8sGsjMEjSevR8Hl0w+zhy3cuKsz1mfw+WyosalO9CBpXmlKIjVXNdDRkDiPOtXUW0zAt+w2756Z4QWBcKb1OKtPsAF5Blg8Al/S2rkdL6IT/8V9Wh2i//SPYAPaNDvFpdU30lmBcfkoVL55XE/B/0fZVOO+NSiDSFPXjEa0MEw6cKGQeDyLAEw/DRVRh8gwRZDqCRplseUkQIFBk8rnYKB+xt6W/MuBXH4tWDpnTjGno56IqD+WnZW0gyUJ1WZnPZNNoDPPr6g5SoKw6aOdctvFc7oLkA3rfcCIrcAlOXK4tlF65CZFCkiFEXR68P85H5quNbrjx/aLXZs/XHk+u4UDu12Cbr0V4OU5yqDOrs6O/VXIofxjUzwgUv5gRUar312j1c+ChfWOYGq8VeaNrAF2f7PJFo45sYwG2DQ0Nag52H2k6UmfPY3FtfDG2tmCwoCIAjThhsa2D8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> 
>> Memblock pages (including reserved memory) should have their allocation
>> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
>> released to the page allocator. When kho restores pages through
>> kho_restore_page(), missing this call causes mismatched
>> allocation/deallocation tracking and below warning message:
>> 
>> alloc_tag was not set
>> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
>> RIP: 0010:___free_pages+0xb8/0x260
>>  kho_restore_vmalloc+0x187/0x2e0
>>  kho_test_init+0x3c4/0xa30
>>  do_one_initcall+0x62/0x2b0
>>  kernel_init_freeable+0x25b/0x480
>>  kernel_init+0x1a/0x1c0
>>  ret_from_fork+0x2d1/0x360
>> 
>> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
>> fix this.
>> 
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>> It is based on linux-next 20260120. I dont konw whether this base is ok ?
>
>It's awkward.
>
>Your v2 patch was based on Linus mainline.  This is appropriate, as the
>patch should be sent to Linus soon and it has cc:stable, so -stable
>maintainers will try to backport it into earlier kernels.
>
>However your v3 patch is dependent upon other material ("kho: simplify
>page initialization in kho_restore_page()") which is scheduled for
>6.20(?)-rc1.

I think i misunderstood Pratyush's last reply:
"I suggested a re-roll of this patch based on top of my cleanup patches
[1], since I think with those the end result is a bit nicer."

>For a prompt, backportable merge it's best to base the fix on latest
>Linus mainline, please.
>
>You didn't actually describe why v3 is different from v2.  If the
>v2->v3 changes are just nice-to-have then let's redo those and base
>them on linux-next in the usual fashion.

>Unless I'm missing something, your well-reviewed, decently-tested v2
>patch remains suitable for upstreaming during 6.18-rcX

v2 version just fixed the folio case(compound page), but didn't fix the
contiguous order 0 pages case. So i think it is better to send a v3 version
base on lastest Linus tree and drop the v2 version.


