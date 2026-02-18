Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56843E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 06:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE3B6B0088; Wed, 18 Feb 2026 01:47:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384A66B0089; Wed, 18 Feb 2026 01:47:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1526B008A; Wed, 18 Feb 2026 01:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 195286B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:47:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B97331C263
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:47:45 +0000 (UTC)
X-FDA: 84456646890.28.C58CA99
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0127A000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:47:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771397264; a=rsa-sha256;
	cv=none;
	b=5cVhwfQvdSiCYib5MVjW4REmMnGnI4eSPpXumaspjgIT3w7dDyxUAcH1hdL3ZRr6WdKvSP
	beZ/BzHJtvSGFaVYVLjSkc0tikfXPcC4NnxwMrjnkiBWZap1h5BFzv6PhNqYckbjwet8qT
	3OpgHm+U8L48ueguNNveBoDDWgPbPcI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771397264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IeUO3hAFBv9RuKSTC7vFCIY9WhPjcg+tq37dXzRft+Y=;
	b=uxlkf8uooIoMNiZHCXWTchY4pRAxpFpdaal43fMKv60y0DIGOEhjzg0ZDcM6eHcGr+SWsU
	Wq5i4Lk9hTfDRV26OuznvQNqsiktjvwfbFTWczrBpuQCGhFlTXtzwZSoQ2R2BUUB75FmaP
	6+KRo2zPFdRJKqjODOiHDN38mJ/TcnE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 664F568B05; Wed, 18 Feb 2026 07:47:39 +0100 (CET)
Date: Wed, 18 Feb 2026 07:47:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Andres Freund <andres@anarazel.de>,
	Pankaj Raghav <pankaj.raghav@linux.dev>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260218064739.GA8881@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev> <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s> <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v> <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev> <ignmsoluhway2yllepl2djcjjaukjijq3ejrlf4uuvh57ru7ur@njkzymuvzfqf> <aZUQKx_C3-qyU4PJ@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZUQKx_C3-qyU4PJ@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 6d8gkufuc5xid7ac1ra75br3opjdog6e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D0127A000D
X-HE-Tag: 1771397263-211983
X-HE-Meta: U2FsdGVkX1+yT5qNkBck3Y9WhHNSZ8MQ/hy2jbg8wy2l6qKV6m4HT6NLQLWHhc6zNaQDWOlOzg9Se49909l69H6fDxvjk1H5WmA/bu96SwK7FgAIbq5gJnayFQSzhgF55ztXT1lm2gOGF7qYLcdLF/cuhJA7RM9Jub84sNBwxI/DfDofADQ+c7n2gonTDaDFX8hffkVPUC/k/O5DYU54QBc+Sjr2TeL/B0kwArSr4H//3VOiThhI0YGAERO83EPeHKP5WoAsJIpd82r+H/goBxBQeXxj+QdPxeIC0k9xDLIkVj2R33P+v30btEXAK93Sue5dQSVpC+Q1f2gaLGuf9KY3YTIOCzRaQEh2YbjzR9k2IyOJsZqtOyFTSBBQkOW0ex5CLaI3B21JoE7T9kWN1F33SqhT1c6C9fEi/KVm3cvZ1AWrO1sIvxDZivMBh1zR65Uhr5jrcOuL0CeFsA1j7Jx+O7cfYOBO9QMu+yiSxe6+adHPEMrCEJjB3D898uZZgp+Sa57Dn7OnXNLEoF3pGUb6iU1Lgz1xBwqYBGueOBIVMbMCg0YjWTmiigyD2AkkEk69iDXggldekfdHoViDuMhME3EGDuw/CgQsvQh+OyaYPhhp1mQLaMhG6CcB2CgvGKC84Z25fgB/er08YV/Q5wRwrCZsmDVCpuCL1S4Elo/00Gq3EQ1lUg0JnLgvedCrNEbn7lryGrXFiE7xrfbdRH0wp5E/sHVNwH51Wh6VmqFnS7f7AitllhHekzAvZkPHZe45mny0AXRAqVB/TqzzHWxzYn/7PfrIzqMjyPINQvNdd2PjdtmaJDhmg9NBQijOTuS90K3KDLYbQmX6GgxOb7EN2bFeqD1mZP2qiwCUJVBx4eky7H58m/3mxcOoQUbtSkrr6wSt5PJKgWMrQi0Cqx7LuyGDgzh2Zy7kr7e9S6AxX0QWQ/ZhTf1XqShyujufmsMaM5qcVipNIAu2yTH
 HecjpqyI
 dXBKRRsgqrf/wWft4VKN/7+TWw+YLrBEt+AqYejQ7xP3c48/97ehbn+p6Fu54t+tdS3ta/hd/dnftciXgtgewIh4mfOIIQgKrBsJu8EwpFGhLRuWg9e0reVLDuKP/GaK3/op8xF1981xtCZAV/SRNBMs6GCCV09LUMqIr+d4YeRERyHs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 12:04:43PM +1100, Dave Chinner wrote:
> > > > I'd call it RWF_WRITETHROUGH but otherwise it makes sense.
> > > > 
> > > 
> > > One naive question: semantically what will be the difference between
> > > RWF_DSYNC and RWF_WRITETHROUGH?
> 
> None, except that RWF_DSYNC provides data integrity guarantees.

Which boils down to RWF_DSYNC still writing out the inode and flushing
the cache.

> > Which
> > wouldn't be needed for RWF_WRITETHROUGH, right?
> 
> Correct, there shouldn't be any data integrity guarantees associated
> with plain RWF_WRITETHROUGH.

Which makes me curious if the plain RWF_WRITETHROUGH would be all
that useful.


