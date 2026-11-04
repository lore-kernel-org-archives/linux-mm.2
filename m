Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A725606D811
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F476B05C0; Wed,  4 Nov 2026 04:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400146B05C1; Wed,  4 Nov 2026 04:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CFD6B05C2; Wed,  4 Nov 2026 04:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7E46B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:17:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 831A440697
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:17:48 +0000 (UTC)
X-FDA: 85396884216.15.AD613B6
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf21.hostedemail.com (Postfix) with ESMTP id C86011C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:17:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2j+fNl2kk6EUtKkWbcK+QC3SrWBZ1R/JSeRG1EGPR8o=;
	b=lkcElL989TRCd66mWxwucmqWHM+WfkcLNYO5uZ9g/BQKwwrDC7hOOPEobC+LmBqFrEAFC7
	RgGdzbHw2f9GHp2TVwsD8gEAThoT8RYUIhZeQH/KhzqxfcHfLklF0+Ddsg/zTYoJYS4nW1
	2duSkxWqKWXb52Ozd2N08Ec0zS6xhno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783867;
	b=5PiqSXG98vaw2ygPpJg5CM0aKwu3qRt2soEo0fFYixBe0SNzG/iQ7F6zTOM+T7+gBdw00B
	+f1J51kFNImkSAZL2nGZjkfo0zHyZ3o6Ot5OaoGhKcuzZhNKOlK5oFGuy53ZtmbrdQjnsr
	sTKVROGYemCv7QB7ksz58MmhzbJ5vbg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5149E68BFE; Wed,  4 Nov 2026 10:17:41 +0100 (CET)
Date: Wed, 4 Nov 2026 10:17:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v10 0/7] mm, iomap, NFSD: stop uncached writes reading
 back shared pages
Message-ID: <20261104091740.GB31130@lst.de>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: pj9ww5wqnth6ny9wogioe7qs4kzzp698
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C86011C0004
X-HE-Tag: 1793783866-539369
X-HE-Meta: U2FsdGVkX18WEGhIPvG9cba1/4NDwpRniPhYJO009ddUVPkt2Kw/eivy7CCg/4DIEtVG9HNMbXpTcwtQMKb9kvAlI+aRF9lWGrJA4heQImUxrTBW91KMlE9FzNNYjVCbfQK6YUCjhnvug6N6tIHcDZRAYIk8LxqLj7EYml75wUkz2o4UyaSYrS1Da9hj4tjAwk/tw5dy1WkesnsiNrza9PHWiZ13iSxYykKdrfHVhdxlLMG7rTQFM5LQGHPc5YFy1wDeplYHSJ/af1Wb8v3vuPAmV4G/V14ovkvYvJp59Zv7408cfH0lAEAbOHqJpXKOsSFnNoGrE2poSMhtOOHBWphLCMG57ibJCSdATDUPsqlCOF1Ur5Dn7JXmMpdQRYk1J8bBHSprscv/GBey8SznJqRShVaXcQpF3ijfk9XdCq7cYEJnDHkChRBP/okz4lmkYVY8+/pwumbCK+rpvvoe1thgl3SMZAfPZaTG/XebHECSIG+Jcr2NTgHUelxmIE5W7gmuonRu68VRkqRIjVEL/bgwDfJNrBIn8b56N20rgN69ghHPAApdSiph8BwqEjt6c58AVXoCgr0Lb7FDQc1I5mfGCF+ckexvtBuDj4J/R5fZrGPZ2ZUU3ckMG2RkY8Q15WdPnSvKeuY48OGu1eSmIknjgaJjIztTNCYQJq6FbBPVTWD8MapsEpy0tEJZl7KJAZeV9so8tEo3XhwAWA8arhCgEfmb9K4fVkm4k4LF+v1FhY3KfXgNLK46Ipn+mUtiJlAfDPA1YbCiPq2FCt7R5kUm7k+QwnJs9vWZ9K0BcCZHLjbsC6/BpHTeyEsneoKC6zkTNHMr7EjnhtJcURNeUyeUFtM4HZFnMXjLk0ERAkvXj9ZvnFDAZE+9DUAA4Ehra4xGRaeFJShCo2M+yJjvNVLX+q9YwNm91HNyu5EgSk9vOXl5mLa9imeDP8HmSP4cXJGhgDvPOmfmtXz68Ns
 6mOMlJPU
 xyXlUkEXTqSXaKbKsNXJVcNaoavhapj2eKzv4L/fZSkw48fHslDLO4x+5EHO8wsN7Um4RHaG+vmxmpO3ujWsIW3jKKvKL3LryCvC6PUd89+SLuVWErJRQSxwyVGfNgqFWrLlm4/N1Tu8HWCUbQZriniz6hiir+JPYdbgob4qIswAoO6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 04:17:47PM -0500, Mike Snitzer wrote:
> Hi,
> 
> An uncached (RWF_DONTCACHE) buffered write drops each folio it writes
> once the folio is written back.  A folio that the write covers only
> partly is shared with the neighbouring write.  If it is dropped before
> the neighbour writes its part, the neighbour reads it back from disk
> first.  32 threads writing interleaved records to one XFS file, 4 KiB
> pages, before and after 5/7:

Very colourful terminology here.  Who is "the neighbour".  How do we
know a "neighbour" exists and what it wants to do?

In general if the user gave a very clear indication that the data
should not be cached, it is a bit awkward to second uess that.
Especially if the expectations are not very clearly documented.


