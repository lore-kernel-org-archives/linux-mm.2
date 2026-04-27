Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80D2FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6056B008A; Mon, 27 Apr 2026 12:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356E56B008C; Mon, 27 Apr 2026 12:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2946E6B0092; Mon, 27 Apr 2026 12:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 154C36B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:26:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEEA9140B2A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:21:41 +0000 (UTC)
X-FDA: 84704851602.02.EE225BD
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf02.hostedemail.com (Postfix) with ESMTP id B553A80009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:21:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ItpP3WD3;
	spf=pass (imf02.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777306900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qv5T2llCY7Jdq5wbaWSpQr20nZRTC/EVRfNcw1lmEc4=;
	b=p86Kxr5/rhQC/+CKnVacHapwRtV5/LxWayNlgY5ROe+CElNP8S3OIcSzNzMrWA8m6hxAja
	eAr1r4cQUF81v+q4AGrntUAIebcpBUu1MLh09VoBwA4/OmzUx4SPYk3GbY8LEBrqSHtxIx
	VuiZEqDjcf1OqCLymC+/WtK9IAALHQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777306900; a=rsa-sha256;
	cv=none;
	b=cTAn1u66w+JR4e9Eq+hY3rGqvPkOlQp2zhlSEZnQzu6H8yOZuZZ+NmlzWnK5v6h5d/XVMn
	HJvQHLwuBG8BoozqsuTXyL0j4dIBWEN1Mv/sFHAAkOed1Uzt7h9avoBkGhuj8CmGg5N54m
	xjs5pFOwDLaF9/0pkhwTLzFewrFha5U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ItpP3WD3;
	spf=pass (imf02.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777306893; bh=Qv5T2llCY7Jdq5wbaWSpQr20nZRTC/EVRfNcw1lmEc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItpP3WD3eJ3OQwiTc3HEFhYsIdC13pxcD6rXG2qHFIU0xAov1iiE419jzP8YS7yai
	 QvLYHzNvQFgYB02qb0wMS6ZEi5cvwfuf4q4Qm66WAikQ3Hxd0V40Lyb3x29jRVnifq
	 3hjjLLy/H40GsVO9OQwPMDC5gkNKxC/j6p2uaTXs=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 55F09E02; Tue, 28 Apr 2026 00:21:31 +0800
X-QQ-mid: xmsmtpt1777306891t3b887e0q
Message-ID: <tencent_97CF3C9347EA08FBCDA2C507D7DDF3A16206@qq.com>
X-QQ-XMAILINFO: Nx5J06Esz7r7adk3nRgV4JYRK8JQCG1ZDJ9VLEbwqgY3ndga9r06rlFv2r3PkL
	 hlZp/g3QIYCgpRe8vx/+zalxSiJY6ohoLEfteXbLfqysAy48E1pFmAuacGSkhQGDtq/OqpL2xVtL
	 VpVoKhK1UMcuxpYL0gmv1mFTO2HbFvAfJVJgKU9uT+d2DE0zw5jrgBovFyivniJOOaqumV6QSbZG
	 rJflasZ/Mq5PSxBjJafvJDOzdkuCRebR8LwOYI2kxE28zpY7NHtemgIeOrYw8P6Hl8E0GPx7s9ve
	 tEahmOXN+7xVi5zaiSfSezSRSx/6wY+v2nZmPzry99NyyaT+oOznTJn6EdlrYtWHSEDoxKWX4TAh
	 qvgDhJkn83vmGIklZlpF66MH96Oy6djDLvqFoe0OOzb2oCFC41HHGoqCUtAXlLMguWiZ7s/rcRdF
	 Ffd77tsN/JoUK3QM+6DppJSYkdILZ69IbSC1XiBSFnN53nUURsbxmXRwx4mBR8M1KzCX3F5VSTgY
	 H3CDENxL/3qUXSKcXevZtFBQRSm7ITbJ3WmD5rLJKhxQlvh9AE1IB+vC6Qw/TiI/1KkecRoYc3bD
	 WuQFp1+fMLYdW10Yo2NP6C7x+FFF7Oez6H1KS/ESsuT9O5Pcwb5AaBoQA1NStFDEcWGsL2j+hqsJ
	 1iPW6GogVsV/roGdzttXIEcxXemdM8QGi7DeCpAkb9yErY6w1DN4t24rwbq1aJ/00iRJJmmTE7wl
	 X+yIAzPP8jhoA5UarcpD5y3EKhiy82DzUNOQAeyvEq/pPX9rExN3z9sYnJ+vWmLfdcR5WcWsC7gy
	 U1gIe4rKSXdFeg4+akDu1fxUxn/XYdYy1qNCX9AX2CGraelaLGY0A7pZc1QoNe9fHINrTIBd0D6s
	 BeZWYksNp/WpMV4GBBhXUAWpxKIJo2bWEtolMiSM3sDNZ3TvoP+QHFE9wSilREgQIjPeT+Ob9XKZ
	 w9g9sX7nelVacoTfwl3RToR955vX/v7uoqK8GtjMRUvVTLGS7UVWaN7Q1q0U5F
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: fujunjie <fujunjie1@qq.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] mm/filemap: tighten mmap_miss hit accounting
Date: Mon, 27 Apr 2026 16:21:31 +0000
X-OQ-MSGID: <20260427162131.621461-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <qll45txbsmwpkrgzjqpzqh563vwd7dcycfl7beaey5gqh63wfa@y2kqsfvhltca>
References: <qll45txbsmwpkrgzjqpzqh563vwd7dcycfl7beaey5gqh63wfa@y2kqsfvhltca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B553A80009
X-Stat-Signature: dphpef5t6qyeg85qhji7mwp4a4txih6f
X-Rspam-User: 
X-HE-Tag: 1777306898-170164
X-HE-Meta: U2FsdGVkX182U/2OyOgUOoSLLH7qUoZsImz59wJHM123aFNuDOaxpKdZHy1Z/YOQuHEuQ7YpL6aOeiiuXKun0QNCLs0Irovfe4RF5Bj31AfoPqEv/lJmHZFhou7WlJpcBDaBCyOVB1ZsHh075HYwmdWnZdKQU9P5Uh70f7MtFbc+oKInuYzpUnLItODzjsWbMa2ZbuZhbpG1i49yate1BGMjpftracV+F9Nw5EBfdcRBrsF32FPJRNfvbXXSFT+w9MZzbRCUweB6Q+bti/l3HyEBK3qb/V+PJThZCu4mOsIo+lhxHPcs/HI7ITI4f6+H6DTjuFPcmruwI/Zs6ODUbCT1TdDga3nuWgCzNIvdawywH7OMW9nuSdOGrKCn+MGuMb8KN2p3oWHpbORe3SjaGaEiWKGc0YAsG7WMn1rIc29A6TteqdiR3kYKdCdfHJ1eEGIdn+wBWcpLeq3DfSCLVU5bn3lp2Akn9OHZi2fNd6QFysl5O8UdK2UQYobB40sde2b6eWlR5mPDxF7yeYe1+3WBO+rONOecsJO3d+PxcM0+XEfyDimNCeaBAyqziyLfhNlLoYUu7F+opuNRGSIjHZnc2wCRYreFjPKKoJLvFU+aG1SsUxaHYxOly1S2odUyhpp70TDP19aX/rlFD+m2HR1eQoJx9lNEGtjYGYyGHBlZDu8exoxzQoVygaRrvhU7DNoZI2/T0fVUvEOUlmJKqRMNbV9LfIuo04J6djaWb+BvvfTp2kW2v/+yUxTou9bahGiPUsx1/zN4tS63013t8REn4Tm+gnD0WQx5CtiiaKMSIhyT6AAYBgX+Eq4KT291dxzz2L/nw+WCKS0qpWhSldB7icjZgGS3iYEUMBpxrYR5CTH44Ef8qQw4DMHrnCid1IsN1azNjryuSSSqF49Wlc15Ox6ih+G76xbOnGFQsUjJaplgeEYrgLro1ZebiyWymUdchOojxB4GzNAXa9u
 dyDbL8cP
 ypUP3/Oef0oQHYilIZvqJBiw4VdK68unxOgcE7s46bgjPkpaLp9Sjckq7nkhPC1rWBZmJoVlgjshS/y9OoMd9+od7V/6GCyJ8dYCBBzGXGI/UxUxOoLzQd7txsSOM89pU8az5/Yos+xJhQLJQbcjNzEz4hWFe3plJ4VnaK8pOd6WYxCCZ60NfnTo6y9T/F2x10jV2jJNbZt9sELJXxRfHI/UKXmyiPlQjFdSQcRXvR2wIApEAEpIPuKZ/CsnWp2+uFDye0CVOWvP6ZqllWmLRP5BmoZheZivVjRFN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 21:25, Jan Kara wrote:
> 1) These are two separate logical changes - handling of filemap_map_pages()
> and handling of FAULT_FLAG_TRIED. Please create two separate patches for
> them.
>
> 2) After changing the mmap_miss logic in filemap_map_pages() there's no
> need for the odd propagation of mmap_miss variable to
> filemap_map_order0_folio() and filemap_map_folio_range(). Now you are
> guaranteed to need to update mmap_miss at by at most 1. So I think you
> should just drop mmap_miss argument, check return value of
> filemap_map_order0_folio() / filemap_map_folio_range() in
> filemap_map_pages() and based on it just update file->f_ra.mmap_miss if
> appropriate. Much simpler.

Thanks a lot for the review.

Both points make sense to me. I'll send v2 shortly.

Best regards,
fujunjie


