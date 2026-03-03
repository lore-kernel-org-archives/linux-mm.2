Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4BCEC1458
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15816B00E4; Tue,  3 Mar 2026 09:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8626B00EC; Tue,  3 Mar 2026 09:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA886B00EE; Tue,  3 Mar 2026 09:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD79F6B00E4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:10:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 680A31397E9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:10:27 +0000 (UTC)
X-FDA: 84504936894.21.EC0E075
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id BEE96A000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:10:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Mzf8zM8b;
	spf=none (imf25.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772547025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9u56EZ3PSfIb2btDXq4/JS3z6i9/jf+AUwQRPvsces=;
	b=48cK3XjBTdMlU8O7AsPKNlBp+OwMhML/WEJ7S0conEm5y+FIiPXq6TDs/9yL2nYhv5TWn7
	N5lTBgfZuxCkCq/6diGTSlnqprD7KIhpxSVCCobgOAaAr3jH2kVMVPdlYGHv+0bxzMmlks
	lMDATQNUdYd524R3QPsgM57/uzExU+o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Mzf8zM8b;
	spf=none (imf25.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772547025; a=rsa-sha256;
	cv=none;
	b=QLhIQZ9Y6Ep+cXPkeBsMZfx5Gc94FXfiX0xoNiio9IJR7RlPOgkXcUi85sAhnsEd92skJR
	xzPNzfpJmYMNHKFxDUq+fiGh3dxNpM07E95wCYCVeT3GL1A5f3sosHWkQP1lijSm5LIdUK
	wJRQp5gYVd0X86JBL63/Zbi1AFaSHoE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a9u56EZ3PSfIb2btDXq4/JS3z6i9/jf+AUwQRPvsces=; b=Mzf8zM8b6LFOygmPYqODqdSM9e
	Tp9BXCcIo947iDR4+2TmKKK3BbGix8IyIB277AjxFH1u8jUvwxi2SDp3iEjHXK2/0u2GNXRQrfXmV
	lzkQ/lqP2x7DEcw4eigUo7yL6pyux0Bzy5ibhpKNxLVwtdUFuQk6bKwLAtfTAsLBw96AQ9iQuifl3
	nTFmpV4yMywEPCs+BB4fbsm+1UM0zbdp4vCanMWq+Xx7QL2e9/b/CtdZjXxMqsOaA8Dj/v53MkgYD
	U5dES+gMZeAXhWT7BcpfbVvpAmTOK/925okF+7ySgncqEqszHZbCKcU1GfMrwASKH+ljRvFlu5ffU
	dyaoXHPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQRr-0000000FI4y-0fQd;
	Tue, 03 Mar 2026 14:10:07 +0000
Date: Tue, 3 Mar 2026 06:10:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: Re: [RFC PATCH 1/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <aabrv_xrsKPx9jZf@infradead.org>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
 <20260303115358.1323188-2-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303115358.1323188-2-matt@readmodwrite.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: BEE96A000B
X-Stat-Signature: iorjerw1dxt8qufbpxtobmkw9nyk9gha
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772547025-3135
X-HE-Meta: U2FsdGVkX191sV7G2aKPHwyjAngbOJtyAF+3dE/q+bXJHxR/cmOaAv2R37BzlF7b3huyisGxxwyuI5vnH+zfbdtMGZpvo6vRp0d3RBTaB6GLyQZ0ySHuGKq3cDQyUai+06WASYOtM1ALnQ+CAzhhaM4P/XfK0sITd8QB5RtpuhuedTGsLJES9F4oTzGgQJtO45Uobg049cBUnNM0hcsf4s0sO69UZvpla0vrqLEuuKbU1GD4cH6wyiopc7jYaQ/PEbZabBuWzFC1sy8xIYs57pVa64VkuTlvj4rB4IMYc73BLM7mreMxvSZDo5MSB9fXbxWIBTWxU6bdx7T6I4Y7cIx2Iq1ydIJy8y3mEMz7h7DXVQWv+efRPB6q5nKhmZwx3CR7zLJHuljFO/Viu6XVTr7uBEnBxxCsM/H5Q9ukm5qumPvrHN7fwE8XWfSohLasRc3Eh+rR3OvynNNAJeI3/C3VwiMmD/0hnf+HP8u5vlqV1t9fqb1CS2OI+0v233yoMtx0Ma/mZUNQLtwK8/0m+evCebo/sTzeKQKf06JHRJTUMItK48mEaKzbPpF72JdWHwAvthPIxi/xkX9Iqm/vZxsBKQLfn12MuO9cCGspkJqKmjQBLbd3dVzRyd9IQ8gNrv9RRzfDAxoOxmrKrrgOQQkF8WGLaqwVki+7r2/b/5rXoNWWZNWtm/1dUl4mPqYgcCndaxvVaoM1cGaIdVdXCi5wjFNyOU+CAXx0TGKBukVPAzBocP2dJaIzl//1lB6THyKz1vL6b3W/O1sTvEnBw6qILxxYGwGOwpWPCO104yTXjxYxpANbC8B7zzmotu0ALX7iFkX7kQ8375f2do10FLFzNLYxAbrYeEY99cVncaA8YlB/cQwZF7IED9jIUQkzutA4xy8aAVwWfZ1dsVm8CHlCUXbXgoypzwuUQTrju3oC0h2gECG/AApKFBlkbJ4UxRz2QHPrLkcJ7DHymK4
 6ScWSnaj
 v7uCX1djFWgAljU8pTA4qXuQ8reyxPcqAy3TSUWNw7aq2s/8q2R3g7h7cw+uLaTjrJV1DH6MUocwtRQJSR+Z088yS2693JYLlETZEqScl7nDWe8wgJhJijU0UuF+8uu7L2/7MMb0u4gEH9TcfCI73nRl/NOmVSfnpC3AdC97vKla7TILVlQcomQrFs8hUe7v+14Tg/1g09tcbL7aYMOKj3aMaDCWpsOUb5xvDtVQZUK0jUZGqGMbzChALxB7S25QjtwtLvDRVTRrxkS8zH75g4aXijzuw/rB8NAWvK45I6iZfIiBLALknYRDDLiJ+B4ubpDA1lAhzOfIiwm3GTjhhlRu/huA7+g2phLuIcDoQclgftRCWWXlQ4x6yg0mRy6ek1Dl4JGruHlWA5g1JAGtWHMUsESnVCmS9iEgZOrmfl6G7YfSAdH0NN3lUKv1E3St5LBirq0jjrpVRaggRRmoiT8dOMqeR7bQIN5pxjdT0xpdxr1lyCADv6/fw8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No way.  Stop adding hacks to the block layer just because you're
abusing a block driver for compressed swap.  Please everyone direct
their enegery to pluggable zwap backends and backing store less zswap
now instead of making the zram mess even worse.


