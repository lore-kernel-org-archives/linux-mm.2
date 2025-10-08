Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D075CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 06:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D268E8E000B; Wed,  8 Oct 2025 02:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD70C8E0002; Wed,  8 Oct 2025 02:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13F08E000B; Wed,  8 Oct 2025 02:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD46D8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:04:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 561BEC03E7
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:04:42 +0000 (UTC)
X-FDA: 83973908004.18.203B7B4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B07FC0004
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:04:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xIXq2OjG
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759903480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9i/hW2gsNIwvxGPBjR3UaQnJZD5u1DTKjwq3K7Rz45A=;
	b=ffOoLHCxVc9DM+4soRBifYfHWeyZD9N8FynwAWKU00jnyHr70QtLtKq4EnXn5iczxHESv+
	NVyEatSLzZmvB4gq9QgkqXEuvS7I0vqRO+iBe1gzHnGWkPqElCKbeNSqVlzbst6ofAOcJe
	gbl7RYBBLVNjxoUYydCtfPLTXfeBfV0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xIXq2OjG;
	dmarc=none;
	spf=none (imf10.hostedemail.com: domain of BATV+fec44d0e9bb002d05706+8081+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fec44d0e9bb002d05706+8081+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759903480; a=rsa-sha256;
	cv=none;
	b=G6Vq9vCg6+hV4UPZlthkQHYuBO2HtNZipK0Ph+W/KtMXYWc/zQrO018G4QN9apPFqxd0ST
	ZSSNahr4P1oZdbh3WEriGCLMtUm6uSOaFC3RF9J/NygguXb5fJ3MBhk2VBeFSdEpRgmbZ4
	9uXtKtK72Yg2gNG6l+fyUHwGq6es25U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9i/hW2gsNIwvxGPBjR3UaQnJZD5u1DTKjwq3K7Rz45A=; b=xIXq2OjG57P+Qt2gk0FH0OvWkK
	Vd+ovtPhdeofYhBwG6boyowN0XgTdPjAZkmLA2CHdgmhSwYQ1e8LrpkUjOXt63w888HO2idXPbUjv
	gBFqaY7J7u2OP7puYZ3zvwJLi2fvAEj5w49jTK2iCAZGo20X1snDjfrARFJK0uMI1eo8VkAL3U2iu
	5GT1x06quwBEdppdk4fHQGr74EY5fP7bqoICxMgBrISd9jWPTGbQV1105mgcetFA7F0NlekJXo4p1
	r07Mk9iSassaNZu6epxkVWDPk2pukrHx2T3EE4odUIXfTvDZeBbu+sz9zi6Y5UVXXqZ6iDFGvJNuk
	CpBxUrqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v6NHv-00000003GA6-11Tx;
	Wed, 08 Oct 2025 06:04:35 +0000
Date: Tue, 7 Oct 2025 23:04:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
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
Message-ID: <aOX-87tPdtuPb9Uh@infradead.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <aOS0Z5N4HaBNeb_J@infradead.org>
 <c750ab62-a3d4-422e-ac5b-c531dfcc749d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c750ab62-a3d4-422e-ac5b-c531dfcc749d@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B07FC0004
X-Rspamd-Server: rspam03
X-Stat-Signature: dnc843j5xy3m9eoin4n8ppe94b69ojk3
X-HE-Tag: 1759903479-38005
X-HE-Meta: U2FsdGVkX189F1NAsjIXBElKhSRMcqMCCN1G/V+pyACgPJdz6BPmIVX86c37UO8yy6dI3f3f+tBfEp6zUOWkQ8vrbLb/hS0OGMuX+851kvyBa8ah8SmuNWiWmoWKY4mOMv52dyR7SdmW7OgiZNsOkyEn8xVIjjd8V7WXdS/sjy01UgD3I+mlag12Bi94acHC/lRqdL+1UEHbMLdJWAhwmBacRdSpQ4fK1xkV5qmDK/wLWPs00DhglKDxtMereZpWIhxbm7v9dkBCxcopqAdYORUG+HQygFaSxDLNInPFvxOpHK7UzDitKKuthX0jkTJLoYOX3BeVtmFmNqPFJulI2A6aTgM7t2JnW/n4bzsLEKN/AfJMvJxVYlj6VCjZSq4Q9DfZHwz9TxtuqUMEoFdQp98AZhTTBBCGbZ1uzUFYFn4ACJbDh5TqpRVstDkH8dhNpD4+9BFh0fEmSf5sB7uugp8c78sF+pjXMEAFTr3hxiVV/a6VT7vyRRvOFjnxx3YZ0YbijNNOBkCeqGn3IfxEPyAUsCmq7+6bLm3S8NdnARYTt1fSPHuHBEmfHt07bCeiWUYZa4bhaUkmD7N9qWK3ZwWBSJNqtjqAYwO4D1nzamUtWcHR/uHzdWqL9k7g5NCMjkqvkL+4Q5ESvPxwAuvCXwTLjY8iYN/Z2FB2HxOlqpA7vUeDkMj9ZLikIKqh8o3Msh1iVW9PlU3GNftbqYtdGZMQkOI4lP1iP9lHs7mDcq84EMOFdIb2J902z0bpEgLs0xme7YtRfMJXHMPDvfMaGkyD47vfLIOtRIXaCoK0yp2DSM/fTksgwGI/tOqhZn0fd8X6SHvJehpN00JTDYJAhr0w+RroINb//t/F0HLwp52QGYYE9/zAifjjfkF6KKsSCHS1CsIMmLdKPoqcJx0txgBe2TGInAr+eReYn0mcHEQsuwPtCqVsA9e2nCIEGrBgWx3y/08Z7wkSz5daWKZ
 HJWN2jG4
 qH7AdQbgKFdPhmHA0R4Ob585xR3hdy8eWlZWe+8u81QBK26yGk6NM1JdKUQDXyZ4Kdbs9EGuL99jzFU3Uxhv09Gsyb4ZapGGYnWh2oSBVieJNxier/qXOvyrCJPhyAthEP7ATW07zGrJOHVdVrrhmRXAXJXsLnIn/2HBEFOmbzq89qzrkav35TL36aaLZZCgsdd4gsYBzphrSdZ5E52GbaP5mJiT1/xFfFGypXtSGAk9i8IT0Kd92VfVzdyDBuL5E+/O1yLzmIX78kxHTmFKSIrSpU+xzbIptrK8mSXlAJc0W3IiFWhh9wdfPGvYrmCub97+XQcvwpesC5BuK6NfabQZxM/JRjFrB15kgeezK15kRf+yKdsaf3AoN2PHrSURNcTziu/yOgLIYdE/lxEjjYtQVLMdbF3t6wdXEPM14fKYioIRIQgIDjgc/vB9gghNzQWAiUrY5dJnIt2vKTuI7JmFqH/Qy2GKN6Jc1qdaNOucBxfZKBzMI08gLI6LL8fjLminn9rAY7B286eo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 10:03:04AM +0200, Vlastimil Babka wrote:
> Basically it's for situations where you have an upper bound on the objects
> you might need to allocate in some restricted context where you can't fail
> but also can't reclaim etc. The steps are:

Ok, so you still need a step where you reserve, which can fail and
only after that guarantee you can allocate up to the reservation?  I.e.
not a replacement for mempools?  Just asking because I recently had
to implement a mempool_alloc_batch to allow grabbing multiple objects
out of a mempool safely for something I'm working on.


