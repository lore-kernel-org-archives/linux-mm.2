Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3F7CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 05:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35E38E0002; Tue,  2 Sep 2025 01:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DB28E0001; Tue,  2 Sep 2025 01:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BDF8E0002; Tue,  2 Sep 2025 01:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D29AF8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 01:36:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B33F140AEE
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:36:16 +0000 (UTC)
X-FDA: 83843199552.06.FE934E8
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id B008640009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:36:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756791375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rPsgnf0q4u1cG9WVov2a/T0rgatCQv4Hm7x2TtI+rMk=;
	b=oUVvttIOfCp/H7hbwRAjZZNKiwJdS6uFPbLlGVLN38jcruE3fcJQRQc3mgAqsHJrV9GZQN
	8/1sBgJ7Z/paiNP2L8VWOXLQ/7Q9X7lKpWvCjiNMo8RnuR72yiBoQ4LzGEmma+uWtu/+TD
	HXE/gx0xOecyU8cOODlf016nIxzmjNE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756791375; a=rsa-sha256;
	cv=none;
	b=dODPTGtCQpVfKSPUtay2+XymVzNVMa7oJbPw0QGjYwEKR+N5DJRsjV4htrUHcvZAibOApM
	UqDWwGr4Hk3nwTqQBrdFeAYeUc6uMnQiUuJ2cMpp8LgzXKe1OaDMZpS0gmlG6yM8RT1lYC
	2aeJqOJ3sG1isS0Vjmcp0NH/vGYBe24=
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5E5D68AA6; Tue,  2 Sep 2025 07:36:08 +0200 (CEST)
Date: Tue, 2 Sep 2025 07:36:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>,
	Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk,
	iommu@lists.linux.dev, willy@infradead.org, netdev@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCHv3 1/2] block: accumulate segment page gaps per bio
Message-ID: <20250902053608.GA11396@lst.de>
References: <20250821204420.2267923-1-kbusch@meta.com> <20250821204420.2267923-2-kbusch@meta.com> <aKxpSorluMXgOFEI@infradead.org> <aKxu83upEBhf5gT7@kbusch-mbp> <20250826130344.GA32739@lst.de> <aK27AhpcQOWADLO8@kbusch-mbp> <20250826135734.GA4532@lst.de> <aK42K_-gHrOQsNyv@kbusch-mbp> <20250827073709.GA25032@lst.de> <aLJYPGKE4Y_6QzY2@kbusch-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLJYPGKE4Y_6QzY2@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: s6675u9wpmp917pm83jz33w9m9zywj74
X-Rspam-User: 
X-Rspamd-Queue-Id: B008640009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756791374-303350
X-HE-Meta: U2FsdGVkX1+oRdoaeuBO8VHJQrP6VMDhBYg4zUeaWXmiLSwOD+G7aSR9urLTKVARsrVtAKy2jFzMS9DBE9Ks4ecRInXSamlgYBqyZhH1eZNXl+4gowEpqbXs8d5hax9ToACeDVbsUK7zeJ7qyD7LWeUwpfjq8Is44MFzwW1+hDsEykkvMu00yNB0ruWUVbNUth0Va0N00MXhr6UC/Pu9lHywlJpls61pUV8QEBoeRf8LIx7+9GNbStP7dD6EKa/lSkIFoT3vpWWUxmTsmqpxddadlMGRFCofdm/3KGLpE+viaMOumsA03sF/EMlZfRB0gA6GC6BB2IPLVK2KYbP80jGNR/+cam+7tIMLV6ZPYGgl/EZ/wZBe+lK4Pra+fU+aLVvGovS8DlPg4lKjuVegqei+Nw1bpuH+Ses3CCi1rEkiJmpnT++92A/p2ZcWdccVjB3fmpQtuArQOONecr+oSHqHSoglZabwUfohKy34ckXO01vxplJDCDgU3z2+A8tInWwalJixdTsG8BHALGNNohQu0Lht5dfwdfW7T0LWSh2nNKlkrXTqF2kiPYfhK75OxoAf1eSnOdyz2ndLhKTAjFXgLiJ5eRzkf6Z+iPH1GuGEJ75yhyTP6+Z75iltD91nicsJjxrBU655WENS7tOqhwdsrmrXX8SGw/BeKbykLU/VXpg2Dj1kdKYoRE8CO4M28URpd4mDxFzp6EOA4IV5A/tpH3m1yCcnR+OdCvt0F/83RWIZDvxPMEUeZmEOmWv3MvPPSHRLMHLNMz7XpY4iiKJrXb4mv5RE2Y29sHJ0LCEVSnBfaY7QOxCGOx2CfXUAabUYe2Rsr7PeO0Z6PeqMJvbCM2RF036hrKnPVjgSQUCNaCbpiDxNVLo1I9IwGvm0zL55rX5jisEb+QJMIrQlPv/FBIycXzrbrfwNMVi3bZ9UByQFouXEWEqZNBRRsHt9KVa8Lw6H9BhJs9UsYe/
 8+5PX7ki
 ww2vfMxdkcCtwQCNnu9zNuj3kKjYynhyy/lpOhENfz/mrCA5ih/2ELWx9BqAifq1r8C7znWYBuOi9Ef/coWrfeirfAgHuKF3a2y/f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 07:47:40PM -0600, Keith Busch wrote:
> On Wed, Aug 27, 2025 at 09:37:09AM +0200, Christoph Hellwig wrote:
> > On Tue, Aug 26, 2025 at 04:33:15PM -0600, Keith Busch wrote:
> > > virt boundary check. It's looking like replace bvec's "page + offset"
> > > with phys addrs, yeah?!
> > 
> > Basically everything should be using physical address.  The page + offset
> > is just a weird and inefficient way to represent that and we really
> > need to get rid of it.
> 
> I was plowing ahead with converting to phys addrs only to discover
> skb_frag_t overlays a bvec with tightly coupled expectations on its
> layout. I'm not comfortable right now messing with that type. I think it
> may need to be decoupled to proceed on this path. :(

willy got really angry at this for all the right reasons, and we
still need it fixed.  Can we just revert the unreviewed crap the
network folks did here to move the kernel forward?

