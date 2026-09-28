Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F55FC98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3801F6B0095; Mon, 28 Sep 2026 01:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356D86B0096; Mon, 28 Sep 2026 01:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246B26B0098; Mon, 28 Sep 2026 01:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F201D6B0095
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:29:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AC2F120B62
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:29:00 +0000 (UTC)
X-FDA: 85262042040.15.B6C4899
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9280140004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:28:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yrlsk9ze;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790573338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbDd44Ecj3LGY4qmWrBA0K5RozmdVMC9pzx6cttne00=;
	b=kCgVArPDg30YUQa69XtefiCFMgJT2vgrjTmOt6CAeoMjTcakFA7xsdU/+yiSqsq6luxBKq
	tqWqSfcrZnTgz8J46LmDzYAkyANtohp1gPZby1lvtYvpOBr8Lo0LpGyDGwgOfSQVSwrwO0
	jduv0UXhHW6u9StJipWXeuNdismzcaA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yrlsk9ze;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790573338;
	b=JOIduKAiIG97vz1KXkryNe49aqzv49/BeAVMe8nLxPW5P0pWxg6TrkLTlVYr+ORCtlhiba
	s9SiVBT2zgEyUfa1ma+Muk/zRCpqKtDW1G5ITTnFQV54R26BZNM47240pBWBN8zeeK+OKj
	olp+7HCrh6M2kb7cm0FBZ+9I6an+eeg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pbDd44Ecj3LGY4qmWrBA0K5RozmdVMC9pzx6cttne00=; b=yrlsk9zetyTGXZXZ7gF9+MTHBn
	9qPV6avqEL3nD6pU6zN/CRh9W400Eh/qDj2yOxHDjzzIXmyL7x1bIMawQEHS79H5+qtHPVAmfxtxF
	uu+fvw9AI1LcTXmWdkpAAZDkhc/hgmivhsgllCS96VdQjIrV1fcH3h2MwodKzDLiM6aG3YPUfiRam
	nJskiPxFR90cJepCOetdaTTeSInVnanplZ4PBJ5H0fv4UN3Ri1XiKV73AIN75Lne4PrniHremK7kS
	C25/zvyoIRhd9YbzL1CP455mqmps7QJJc71eE7yMNAKMIFjuzM0CQrQuF3lhryuad3/z1+zmign4q
	LICFq/8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB3v2-0000000HMUe-3wk1;
	Mon, 28 Sep 2026 05:28:52 +0000
Date: Sun, 27 Sep 2026 22:28:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Ge <hao.ge@linux.dev>, David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christoph Hellwig <hch@infradead.org>, netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Erhard Furtner <erhard_f@mailbox.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] netfs: Fix missing alloc tagging of direct mempool
 allocations
Message-ID: <arn7FHZpYhNDvjIS@infradead.org>
References: <20260923063759.34667-1-hao.ge@linux.dev>
 <0d798541-6486-44ff-ae57-f631d1465688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d798541-6486-44ff-ae57-f631d1465688@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 9280140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qyf8t59gp9gis93zf48ambms8esg8zby
X-HE-Tag: 1790573338-786719
X-HE-Meta: U2FsdGVkX1/NVs4nPOT/zXlrkWOs2Hw3eKftcOHRbd0ILmP7D/EPqSPIjN/ru7e9bZ2MrdT9m2KB8Qeh+0BMGP/FWtPOJmCyiFqPgRrXD79f6ZnN7ZOSke9qEn+7QTSfS8VNbCJ/KBNqNM+FAC5KAPf9LURLeg44BI3iDc+CiYeYW8nZx/p0NaLdgRGxyNRA4Y01ZRZp/e+fQn1VguOeTF3g/4t5/eaptLagQydrelrMn3NYuTopWN2gcoWps91n8LExUMlvNI9g8G5kBDPXpVME7DjSIIwIsyNG7HzqG2oOPPR9dm/ncyBBSGeyc4BsJM4UW8BPpwKFYVSG4SYsMlpHFUe+o8QmWvqxxV0+gHKCswVHd8A2SsklKBeDviA3j69uqTai9KhrDIn821SAZUzZOM073F13n69Yes6RHCGs/ZvcR8jY8Lb93+qpvwHJjaOMgFTHB75y/CWit+5/c1TCVXrzgRBh9A8/4mdVFvr3Y6qx5F7T9ClI6CfYmVAVXZqZw297K9P8g6J1+yo07UqKOEcS55Vb6u0f0POi7EaYpTdkt6e5fNsROJn9P0lDGIIul/aNKRqRr7BF7XKLrD4+UgMkpw+we1YPsgaR9CF5PB5Zn1xvM7BOBsOjyZIDzbhvggJZBLvP8OUyAo3VvzMj4qcGggkM6yaR90QOrFS+rSI0wxOsO6YM3e7y0/H85j0+uF+uU2+7/bJr7FzRYIjPDMTkHKIxU7EeBDf9Umx/ZGG8h8GDcNTeY3A8meODTeAPgD5cm3p4Flczr1wWr3I1wiUwuMGSw3PSmDD+ntfv0dJch5DF2RYebRqdK8midLodUv6Ak3lYpv9b/ETO/3E4WA+ZR1X8ijLoFIMJm20/ayVJ3hxa+yvUf0U7bnh37TlTScT9A7WlrdmxygQBKJq1HrOelKMBwSkrKo1yAEnBV0QGhfKpvlO5PUXNfmtzc2ZyykJxWE2x5EgFnbX
 yzjq4r6O
 gOwkqn4u49c28ykfi4h/XCK4hxjkp0qjX4FDC/DFRFmiNM1G8lGicjeggrPmvebdT5TKBZ3gy3E3nieKGv6YD8dsz8hWS3Hg/5GO4UwP0KDenis2eDwQkuwXmFkFi1/senINGse8LboFL5Di+DR4Jr/Jmjj+cs6+tNU8SwxU2jzJKXCTugHDhSNcuIIru1GyUQ+QpaFbDxTaqNgrhOKwv76DtfX3mKPFf+jmuSiiLlxu+emqsl2Oc5u/1b3lw4OkXVHg9nLWKDrJSCZFqFQYRQkDUJNzk3vO9yD2qM5I1n6XJjAX3EN4yNLL9h0dOPMAsRo3p2ko+kwLQ/AZqeYMYkxgqpJfAEPUv4ufs/mFrM7hv3HRxN+nhsjrhn1hzCLEdloAjgbr4d+pG+7TqMZSsNpkFTSPFJYW5+g0ySW/dDvM8JzestmCrdUoHBue1sufUBZRYK2jp0GPTkzupncGECWzBhN8ptKdK/nrJD4gYHW/i5/n7GNUY7BevHE72lWlXcRiX2ebhHF1yybiZj+raB+O3aqXOo6n3rAmrqLtUfjh71llbNo0gj5YnibIrsT2LIQhcXtgNd/2InU6CWmcuDjMFtxRfKDgj3tiDU6MLi4KPtHWdwQ5VVHJQ3FDAScgyHaX3tfyvdT0KlT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:36:19AM +0200, Vlastimil Babka (SUSE) wrote:
> > Closes: https://lore.kernel.org/all/0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org/
> > Tested-by: Erhard Furtner <erhard_f@mailbox.org>
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Seems ok enough as a hotfix. The naming perhaps isn't ideal, we have
> mempool_alloc_preallocated() already for the opposite case. Maybe
> mempool_alloc_no_preallocated() to complement it? Rather long though.

None of this is ok.  Directly alling into mempool->alloc, using a
wrapper and not is stupid and broken.  Just switch the code to use
mempool_alloc undconditionally or to use a manually
kmalloc/kmem_cache_allow if the subsystem has a really good reason
to not use a mempool for non-writeback requests, but it'd better be
a really good and well-documented reason.


