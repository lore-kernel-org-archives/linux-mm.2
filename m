Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008B1EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7C36B0089; Mon,  2 Mar 2026 14:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B586B008A; Mon,  2 Mar 2026 14:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561F76B0092; Mon,  2 Mar 2026 14:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4990C6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:44:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F17BE8B289
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:44:06 +0000 (UTC)
X-FDA: 84502148892.03.685C95C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A7C680009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:44:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OV2ah41e;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772480645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vt15uZt8IrKH04Okb5T1ldonx1OgDF1nKmGa7hSBso=;
	b=MtDof3BsYHZB/GO9OX61ittT4TtrTPrZ/SFu0oB9DVodnrwbofPmfRty5VesoyV3w0SS/i
	n1Ikxr83G9hTEjcf+Fmzurmk12aYvZAdJDnhe3Qfe5jFenjTJZDckukiREpVOls9/+Cbxy
	EZElwlXFeoghBncnqAjie2YK19/BsjY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OV2ah41e;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772480645; a=rsa-sha256;
	cv=none;
	b=cS4+LYqe+Q5zScVQlVwEDojn+Vz9l6m5ML1bFqwXT+pDSipa+/4lUto0FyjCfMjrTTBYCN
	LKYCa/+yeULrpyIWggpstfhncOvU7dn9CbSilh3H4Z11w/UNCL0a+cwS4dOPMU0cDSWvbS
	8lhypJQaZ4LMqK01bjsLxTyVZrnU4XA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=6vt15uZt8IrKH04Okb5T1ldonx1OgDF1nKmGa7hSBso=; b=OV2ah41eLKpoVUjaguiN0ARl4w
	Nt1gPxhGSSabVVusnrKSgzX5c30fU6VbTpLStrdYa/mZmmwRWIt/68FQ32IKwhObM+00XmK8/kwb+
	VPRw8kPmP9MhXIUDpuPC3tINAHSlY0+eBNp2QPiwbj+4n2CHzUZSztDGlue3Wx2aRlDp1d7TO80qT
	Z1KpIJO+NqgYcDzn1jD6R8KGZMKkH14yADaY5ITboMdi10IqFoq8nRpp56OEMG+OZPaLZ933VcqvR
	UWn/ScG9EU81bQ5stJMp2BMiYqsXKhpECU0EBBvSqd9RNCVZSiiKFqCTOzFsKVIwx4sLZLZSEtKr9
	bPCYEMbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx9BT-00000009zSS-23Xc;
	Mon, 02 Mar 2026 19:44:03 +0000
Date: Mon, 2 Mar 2026 19:44:03 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Alexey Suchkov <aleks.koyf@gmail.com>
Cc: akpm@linux-foundation.org, dywoq.contact@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [PATCH v2] mm: initialize 'seq' in gup_fast to remove
 -Wmaybe-uninitialized warning
Message-ID: <aaXog_u1MOGJp3hP@casper.infradead.org>
References: <20260302191237.34375-1-dywoq.contact@gmail.com>
 <20260302193405.37961-1-dywoq.contact@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302193405.37961-1-dywoq.contact@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A7C680009
X-Rspamd-Server: rspam08
X-Stat-Signature: 1aa5ho88xcxgr9e3ni1bzuo7bzjs4k63
X-HE-Tag: 1772480644-485009
X-HE-Meta: U2FsdGVkX1/4Qkk/3xRQU3qEG0QQUSPGjjQsJDJChmGL3yrwQ3ShO5gdBzGb+j/+k5/10nhMadEEYdirLvGTfGi2zbIe2Pc7lVabHPe6PNrtlYY8cFLJbm0th8TVpShNsI9a1kJTe/p3rUxulXKEN71QU2Hhcw3PV+jlhNFkShd5uI3wDfam4FVDMOk3TLG5NGyxanrRjxMWrf5DbEz7ytV1cPhVaDK4KJjjrzynFBsVT2GU3xeZ6fAXL9hSFi7iSmNUn+eg0+8zRsSA9mRVRbG8lkhB6xVSnmdEPa/9eyrt9EoHWawLcGfDeN7shnPeoG2QJyybPyG8nrlSc4DmddqCibW5lTXVolLzO7nPoRFTmQ9BFkyzelzVu/yD+9u0DOSMtbsY80HXkf32r8L2gIj/3j4ZPZpYyf0jOiGXgi+2onDwGrBDmik43wchNRE5asmwlFpY76PvLwXDP4ZdCQcr+gd+FXxWrYRX7+u30dNoG6gL5F4hCzRC3XgPFGsbduac/usyeYc8GgnPzyBHr1ES40ufsqreovqNnT9UdtT7JOs4es/wCnfoGL1Jc3z157gaZAOQ6AX5uUbwo3oQlAPQ0U5SNyWALz6qrGeYWKhDIihTtXlY9w0mL8yKHbCQLZSg39JhJhwlB1PGM9SOYrLGvYneitw/dTfRSpdq31oiFGSBDkTMISbCtNlhVSc50DTKNUVdA5Msd3tPA1j6RKruQTL+8une9uyD9PPf7K7Cd3b+VDQaNHZez7lVnjbtRpoKeGijRFmfOmpNT3l893Wei+fg6lMNThkfurp1S2LX7m3wwpj9QZurhh6fdCJtXQlIr1KauHlwS+vPvkMW8GPMkYoEA/kePpgfw5kl22pCq4Xv/RP9eqrp6Carkqn2ze44X8xUksTXkNxPS/AzmIj/Bb/1rcrpxR9yen0PyCNx5vgr9zTfzaeuDlJuKkn1/zhFVGbysZ2Bwwacf36
 A0AGOGjS
 q9cRv5x1U1zfBunoxlRG5NuxLWdND+JosqiCF2SpexNdQsbwd5FLQ5713cS2fHRywGhkmJXGYa7RquRHlzh5NvibyZ4/h7GGWtl2nGYTNYJUtNqPpoxFzEA+a5h/rcpxegKFQzmwRz8yt0TwvDYsUqD2DNK8ovM0L9FF1iFic348li6N8l3ZC0t78i89ZJGd+4gQ+xOOjY9HkZR/uDM2/vYks2QGs2rGxKeVrTLcxU3vnLdH+rmC8YMj473iNkg2sDda3MBNsEw9RwSyaIVhD+XR94qiQckmeAKjwwAuDsrp4h1Mw74ziAK5heY3hq3EpzE/7O3eWaQW4XQcGA29EydYowhrOJk0SFbNts0+wGGCwxPHiLmirV7ZOxDI1lpuXvL3FHUG0xptlrC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:34:05PM +0300, Alexey Suchkov wrote:
> The local variable 'seq' in gup_fast (mm/gup.c) was declared
> without initialization, which can trigger:
> 
> mm/gup.c:3165:20: warning: ‘seq’ may be used uninitialized [-Wmaybe-uninitialized]
> 
> Initialize 'seq' to 0. This does not change behavior, since
> read_seqcount_retry() always writes to it before use.

What compiler?

