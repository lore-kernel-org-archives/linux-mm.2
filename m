Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58524CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 12:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B53F8E0008; Mon,  6 Oct 2025 08:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78CD98E0002; Mon,  6 Oct 2025 08:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA278E0008; Mon,  6 Oct 2025 08:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE178E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:46:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CA3F13B0F2
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:46:46 +0000 (UTC)
X-FDA: 83967663612.06.5967AA5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB87A20008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:46:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RgglGhGd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759754804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKIfkEuRoM1ksrm9lNdfsOLR0kjGqecAsFuMqeyGJgA=;
	b=pH0j8pKJacG5v6iFRJrORQ8/C1GmeMXeHqpnpqN3wYovu+jYVJSR1WEgf5uFldm8iIJQxz
	NUw4Kmdiwi2Uk95CSzXLNmea/AuGS62MJaZQ1RWkf/vS7/SyhV3jNzdiJZH3QmcJZznAv4
	A/v1V/7QTjj/KRpARZS5ZRMV4Jxu/SA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RgglGhGd;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759754804; a=rsa-sha256;
	cv=none;
	b=S9EMxOnAfmpvraG4NcXp08ZbTDeMIyxGE9zHcqRTUTPpBzKZwx1WSrnLpZSpJa/d2tH8lg
	1m1FgZ/vajN8guXVjqs25ILrrqYMMr0eBjTOraSOMuWl46wJLlELnBVvznCbZ9/BZQy9vd
	qiXwb9Q0xVxFgYRuPns30MGFsnWWQ6I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SKIfkEuRoM1ksrm9lNdfsOLR0kjGqecAsFuMqeyGJgA=; b=RgglGhGd5Bv4QEARFDm+h+rLNv
	Q0sb1Kt+Z3j6EYIwZ9YCiSRFUcGdbwpL+uc2yS/Oto59Y7hemGwPlbZCc5eefemRkVGP7j3efWKim
	zsyspHqZJSjNqvFslUodsbJyIRkwJJyK9/Y7SOtFjr8JIT3MoUXeTkuW5JM5QdXQwdHQc8mGch1Tf
	pG6LoBNPJcX8D7EyYvYTugQydCZqWAPNsqW1gZJu8j8GQRI+A56cvTgRJjs6vtjz9dPE99PLFvGG+
	m05NsNgbWTfYKs2MmRFHeBOz9+141Ccqos+3e+5XnmfDNK29t209VGgU7wuC5cJkOMTyNuwaYTV+R
	nDJKS2ZQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v5kbf-0000000BnwF-0Sd8;
	Mon, 06 Oct 2025 12:46:23 +0000
Date: Mon, 6 Oct 2025 13:46:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Fushuai Wang <wangfushuai@baidu.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: Remove redundant __GFP_NOWARN
Message-ID: <aOO6Hk079NJMTg9c@casper.infradead.org>
References: <20251006014948.44695-1-wangfushuai@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006014948.44695-1-wangfushuai@baidu.com>
X-Stat-Signature: oip4gqyq4wp696acdw9yuodcbgax8a54
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB87A20008
X-HE-Tag: 1759754803-508733
X-HE-Meta: U2FsdGVkX1/p2KKVyhPgk2tcwXcC4vxpgZozKryAsl2PuAjrjCsYb694tuwRsCAbqX2tJpAzyj3dsfkoIrY1gR4mDT78EbltS5m/8sqgDwlAahKjZFSg0OTWBwiVui9Zyheyrw0ZlPRDDQOQ4BPFOdfuKWabZ1pxnG5aY480Din6A1kzafTycQXwikjtWq7rNIA8IX/vrNlpcMC53wZV/s+K5FX8sWl+evC3aSXhEcGzhrpPgf3LptjyrIvusTnDpdwzA7L0GCiwjqMTL6XPHAcjFOgcXcot42rcfWsmA24Wvw4aKGQXZ8F0FqaIZDtNc2a1CzH8vgYClACMcxagjlvMFG5JRFXjo/IBZsinFyd6yQkNXsLd/GSkbmMDF4RWYMk/LbLmSEbHKq0nbOpe0Mxz8pNXOAsBqGbibjpOS+b9tmRHOzeZzp3zwVs1zDN+lYfUdo6trAO2uY0VmGayQDVTLBR9WY3KUIKiqOG8d6dwyGCtMs8NP2BM8sYfVTVie0FSHSmZ4DkFBeDcgqzpN8Y4o04Yp+tGHDD712ekxJpFDPYqsGchniScKXHf0kow4TqPE7tmlmkI0lYYiIxgS7aaK6fHE4h5+cxq75UNCCCE+f83DMxtVauv8TAkdwGOU3Tt7UUJiQ+2H2f/3beP4fLjGyDv/QFOLz3wXYURdIbMfCkc/QTUz2MM5p/chzgsXJ1fIbxLCKW0dP7nYEXYsMjao1KF1FpgOI8s7EAW1vNZLPRkWOYohv0q0ID0ifg1tzaMT8T14ENQUR1N663AG7B/ckejkw6b+CA2VsQ9uhmtk9pf9qxbc3LnJC+3xcPv2Ua61DIvV5SnIEsLyN+phwKRCYq4tEuRHyaylbj2eJd94PlcVuaH5XChyghGeqtikw7G+Y8ocFhQprgqnn82njgDTLnzI7pLTfdSF5/h/fsJSqQwCeQBrCGh24R9SCGPWa4siMIrOE7jwjbcq5a
 IaOwka0p
 FIMfL+CPXGHOouRgCkqzz7/dy2fMjOk+DABQQ+tWTZvITXKvsNCkOq4gsXAiXWS8cEMFyGniAhxhjkzHmHrheCCTbX4yfp2Vse6D1NRVajp8jYKXEfI0taqCXV75ON1i7QBGoLbgQl2JP13uvUxtFo38xpCuNke8WBhzWTEdULuN5if/eLDSKDvjMB6G+5unny550P2QTrhURN3qYPiH1tFMp8usZmGObAoHQjOgFi5enJ816Muw55MLQ9TYLVbMghpcMffwt3mwCC7jvNh1973ZIO5AuMZbgWlCVqEQ83Ys70Lhec50w0anLRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 09:49:48AM +0800, Fushuai Wang wrote:
> The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
> 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
> remove the redundant __GFP_NOWARN flag.
> 
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

