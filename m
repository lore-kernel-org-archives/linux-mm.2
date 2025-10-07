Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E59CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 06:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F3F8E000F; Tue,  7 Oct 2025 02:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD00F8E0005; Tue,  7 Oct 2025 02:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE338E000F; Tue,  7 Oct 2025 02:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A60228E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:34:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57C891607D0
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:34:23 +0000 (UTC)
X-FDA: 83970354006.30.DA13945
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB72FC0006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:34:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="wK8UyY/F"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759818861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVfcmzXuLVfDwhNrv1TlHQB+p2roeVM6ucFNuJd12fY=;
	b=oebb+rceRGIdQHTLSa213pDbSNk0ddUK9Fk+N+vyjifTksTnuzyT+o8VHQrQclOGjbBcqM
	8deDUAihHyB8VWcg3qCJhC+9BT1Sr0VBH3FcUaFoyf59JP6uE0wWXxgzhsXvCm5/j32HI2
	M/uZ/t2wl1aRCgn1G8ANxxWEIHgaHug=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="wK8UyY/F";
	spf=none (imf10.hostedemail.com: domain of BATV+9bec3b6c30788c3eacbc+8080+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9bec3b6c30788c3eacbc+8080+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759818861; a=rsa-sha256;
	cv=none;
	b=Gvab6J7PsBKoqYE2HVJHuVdyQC2F4EeG8ddrd/5n6sepAimAdxJtS5tTTEJCMCvavhAwe7
	3uk3JvneKUnwGdKP0vqyEV/mFnZ8KWGvNoM2QIs3RNZcrbQXSNJU0gZ7qXBzhBfyA2w1bx
	O9yEvH8FYlcf9jOe8hU3N8KHxWKEiS8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uVfcmzXuLVfDwhNrv1TlHQB+p2roeVM6ucFNuJd12fY=; b=wK8UyY/FgUQyb31PnejaUKkwpa
	XEmwvUlS6rQgQiXB2qWa7aS7EsrDolYMqYvooT2UVavUZenjq2NxqnmoCKCzOZ2cOBN6yW4DmkuNK
	xFNNlLVvx4/30OiectqlKBAsfZnhsFsZl2k27nF5LiJzB/2hyNh3/+k/YoMOmtSsSwDVBw0ahzG25
	wr3R2NtaaeC9cqtM1QBLm05Ed7NAiZdcBF5Tpx1K9r8mwwd57kxn8/cGC73Xzj+F91L8YbdFBKo18
	A2g4K7iFyWynn3zK3JIZZ6mrkVV01bP6qZU/56mHIZILVfBtdRrtHPCRHWcMLDmGR23vpjwkqpEG/
	yvzyl5yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v61H5-00000001NCF-2XwD;
	Tue, 07 Oct 2025 06:34:15 +0000
Date: Mon, 6 Oct 2025 23:34:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	WangYuli <wangyuli@uniontech.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v8 00/23] SLUB percpu sheaves
Message-ID: <aOS0Z5N4HaBNeb_J@infradead.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: tmj51uttkcaxnrg5ays5fq7wtotem16k
X-Rspamd-Queue-Id: EB72FC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759818860-301137
X-HE-Meta: U2FsdGVkX1/nJRcgsDS1KB34IRNAauHzhzikhQ6YxbVmT1YuiL7CR0U7TrinaIYYOaeUbrYI8Wc+pCRQIDpu5iLFoGAY9i6feKm0jrdGNyhJrPQCRhOwggh8v2zRvyTcy1aS5AdHSMLHrCX3I1t6BpfCgD666apKS+f7R/UUkHTmvV6huqCvQG0LAGW+W/JA6LKNdkmZOs2eWanmkf/ip4DTriMAWgtOkTiFBnQuNmAZov7VD3QCSLe+gu+uPTWyg6R5hftX9y4GIO9BN5v5ox+M6soTItZnD0rrLv0zFGtcDUmG3Y1bZqp2rZyjF3RMbw34VPkbSNNGsjU58Qn6NdjJShLe76hLrTymjpgX2kCNQALZbanDlwvIhJ7h5qTvZsVAPHMcwrf2fXKuYNTwzeYvBHSfyf0sP11C9ONjbUKQc8k3Z2B5yyXXNWFrPUP5WNSe5EJFrVbDw9dfron4MPbKot0SJOv83jQjl6OxmCfpAGMVDls2xHJpWOaWIbpleROtYuB9xLA+4W3096LMFtnUfjCX+M7uYKfVefzSU0rog9AxQ/QhwKf0isQ1Os+LNpL2pPnINGgKszRZK7fBaZPiUrFXHmW3/1MhYA5t0q+cUg/9Eap+UIaO7Ap8my+m+lSdYR0asaQriJIF+CbIbuoKOV4oAE6X1Z4vpEiFUYFi0lB5SNlhJf4G81HVjTU+fkzga9NA88aW7FBWl/OK9afxstd86WjPgwkgO9E1QxkvUsLVVeF+3Tp8Hveajibcsd64wDkrcIiVscQuAhK4ZSkwTVyWOARnHKXK++HTAGNgBpAT9q/9LSzn95mMJIuPK+UMLMa5UDU7K96+PehwTB9c6dPUsSFw3cGoCgMHbJKaoIVlPMM2Z5eKggUjXp6cyXo463iDU7m65qjdNNW8+xlHIb2f1+d2gawRczKiCp5Gyn4Mfu3z7ahS9heOxLnFA1vZDTAaH1cg+Dh7o8v
 y1iHNw1j
 XEDAFtmQclXPfnkqZEvyg5ybMGvUoovIDIxQN69IgDF/9EydgHLYsFKMiep5h1exh+Vx6ng86naSiHxqK3ZEOdLrgb8Y7u35fONogMGZHZvl1F0UtFkzBu9r+gyFlmBIISmMVTZP3oL1Nmhv/LLs6nTeNo3xhp1gj+iNp9PmceGCBWQdn+cURt2PXzeEomYQHMbYVsmOsZrwdE+j6TfCfKFQEHbKGY1EYRhjQRQZ3moZxcg92VbG7gdHH+023QkMDm/w53iXEuacQOHbcVG/pQxzdcxDmBKjW0m0wK6hWipqUr7L0zCEwYcxgeogy8lUcUyyz/rQEyrtVnq3w3rW4LT9Vp4ijjguvMBHy/eD4kwwr6/IfESzLASvAdQXjikK4aVS+O1/BIGboNOZpLzfpT8bjbvPEQSwaxfAjnMZTNvcgTSP7OlKJtYczzj89lrNup93TL6fPcnOPHQHOVDKNhH1/QucxfTe6tqf4+nWKc09wvpkB2c4pOl78Lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:01:02AM +0200, Vlastimil Babka wrote:
> Hi,
> 
> I'm sending full v8 due to more changes in the middle of the series that
> resulted in later patches being fixed up due to conflicts (details in
> the changelog below).
> The v8 will replace+extend the v7 in slab/for-next.

So I've been reading through this and wonder how the preallocation
using shaves is to be used.  Do you have example code for that
somewhere?


