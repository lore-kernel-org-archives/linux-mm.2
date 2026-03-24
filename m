Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8979DF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96F36B00AD; Tue, 24 Mar 2026 01:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BE06B00B2; Tue, 24 Mar 2026 01:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34096B00B1; Tue, 24 Mar 2026 01:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBC66B00A7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:48:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FE7D5F41F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:48:10 +0000 (UTC)
X-FDA: 84579875940.12.7EBAC98
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 335F64000B;
	Tue, 24 Mar 2026 05:48:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RkdnLp8A;
	spf=none (imf27.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=;
	b=FR+2FPaBNweTCg7GIxX6mcqmc6pDHZ9wSj8Xk1xigOisUO5bkp12j5u0bNmWVj63DuJwES
	/0wkjDhAfsp/z5vmbYL6bVh3cWwUotOlaW2NIsVo5zPIwy1s8GzJxgqHj17/w6DtQOWyem
	hnwO+33RBvdjObY6qw33awu4LzkRsi4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RkdnLp8A;
	spf=none (imf27.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331288; a=rsa-sha256;
	cv=none;
	b=wFHk5MwRAiFZzk13jcwHsnnu0Ms0i83afjL0YzjDFcveTFI5MBckOJnU4IRMRY49e1uLm8
	bcm7s3MHN7zP6wt1pbRFPKl+vYyrMMl946yZ1XBMhrma34catH2RZU14s+GJMoZBH/BWYZ
	/rh3CkKVwUVydUlQkPEY+I1GyKH/x2s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dFj4PXIWzhbmUJOFmzQNt1qgtQ8syeC3KliuYY5z/vY=; b=RkdnLp8AeMvGpxqAGV6PPJAZbP
	W4+xDfsdYs89DYje9BNAJz2dFERvYTd7KmdlLCwybcTKZKpzoiCQDCeTLbHw6/QS+PBMRwqDv2iDg
	swRxEYC8pGbTAOFaJ0RVGN8pccl3sm5QPlWUl16bsLoPhd/RQal09MSrAkgMGueKwJ814Gjdy37y9
	tpqoFiLGHxaZAnbZWj4GHT1DM2d8HvRMmFUDSBRr+1PvZs1B6UPboJrpoJs4eBEERE3FxzcM/+jGL
	AnTw/eTM94So7dk4wPuC2JhfBnzTfHJwtpqeUVXYvcDRhiQimWS3gtpjE/IV97Grdy9Jgx5pkxuwr
	mGdS/mMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ucV-00000000cPn-3qfg;
	Tue, 24 Mar 2026 05:48:03 +0000
Date: Mon, 23 Mar 2026 22:48:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 29/41] fs: Make bhs point to mapping_metadata_bhs
Message-ID: <acIlk7uLHqXCUpJB@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-70-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-70-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 335F64000B
X-Stat-Signature: p8by1jrn1u9uaqr1n87w7r45umjdpak6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774331288-999196
X-HE-Meta: U2FsdGVkX182UdfJyGorsykh0qOuYX5Np3qzTh9tNo5QtNkankfQbsHI00DNqI66YKWxRPeA48sh9YH2LUJHTPHQOWN1K0VqOHxnn3C4rK/utXg4M/aJqsYF3RVy3kWGbcYtEQmAGOSfSoPomI6ZoFvOf+k/lFiySqdoqgIFwKCrqS/I0J1Ku5ikeecweXovUC1ZHGuYUMnfe0y2IiuLTNIRmt3X7o4WirIZq24IyG8/UwK78PgjlQEd9Q0iJjjGWroY2dyL5V063egkb/wuddiN+BrrKdj4OnRv19lj5dmvy3jN5vB6fXfVkz64eQBNFcsorhlFs2B8drp4VLljZAJ2XqOg8jUjA3RlKd+wOs35yVEyXkWmDRenTJ3XGeSXUH/86auepI0sMr4v9EkA4/rc27lZrI9gDD2maURsMpNcHRQDpjlNQ/aaB8LUVo4F3luoAhHbmFj+Ds//3FMg16VaiQ+xue4ViTTZZ5I2HsvzsMIoDQfVOb3ToLWwzVxvxYmuVViSSV0z9gNHPL194SXWZON1wMOwvukH6UOsjxic85SlWeaDDeIgVVm66ddmqBcfjyOtSozzQjLdaUGBxK/EFg97sQcTSQa6+AF/OObHLjp8ESP5uEaj8BCSYSHmaAD8skORJwyUMyGtNcPT67HZyeR6SvbacDHK3F4ipztb5yM+IbOOsIPDTaUMK+B29NpStlUCEa2nS4VG5NiAD6uhSXqzJ7NoFyu8FEYQUfZoNGcJkpgxf7RezkYQXlLJ37uX+IttkNl9MQy9+rvDXyTkr7eIMq1FE3ZAEIEkbOrX4yg0O7UAXxWLvyCgNqOMFvWDWvHJOPaOiD2TLBhW11YUViU1jXTfxTusNG7m+eCD/jhLrVVVFOwtRKmnSLOpze/bDxwjsXlXfljxF1p4jxHnJT/X/vNTzEHl7uTMCwhSLDemVcRzDKwXuvS8BLV2fMPWA5Fw5cwgoE5Si5F
 kNF3qXP3
 Xt6ZWMu7KrtjRxFHtjZWnVoZOhDWKvs2eGrI0ml1zKHEaOriHYMFOezDd0jxEWChYZTIgQZy4jkcEDh+9LkmVFQ7cHtgP6KzY/TIuicsWmkB+pEkScdikVtVEajU2GFwtOM9j2NS6jYILIkqpDtO2wxXEqdndSMYql0Q6nxkSaaX5ag5IFREW/BXmZSogdZlRnPK/5tnjDPNl35CaL+rQO6Sjp9xldNVaL7qCx86s2syF7gkKwUKfi/PttTD8oBhB84wUMJaoABpwQtGelpImB1ZelmvXsjKG79FmmkjqZ1u1kAtH3mBSoMujx8Icm6rWk9hFEqZ3K/vt7ivh6J84Hv5xVyXV3ii9tx22mDiXl7NRwaG3lQfFJ+AI6PgmLiaD0EhC9GNMb8mKIxea2OFQ5pvZEdxU00fcihPiVNH1MOZsaam/gxc8GnGn2la1FP7bBgFgvxB3Zn0GTdTOy7+AKjGUo3PO3eO4kSYoIP2qf/z4FBiSgt1aPbon0DdOCL3rsp2aZ36IIR/yqTs1Wxr9ki+ID4QH4XKZg/lNqStuyXTYyaDxzq7DifXaGVGRlmSST+b7Uskt6EL7tqUAFdKdayHGGFHsNz+8Puq0PWZ0TRmWcA4KHb2tKe6XtPZe0TlJedmmDqGSTPb7DMJ5Zan2/NcpIgclGK5/NdO4L0PLtqO8rshx7G+6H5zado6zhPVjBcpQt5DHoxpd+klM/4Y4o9WKJwj7HLxDoYFEAQOhdxIZfw8NLVogHAh2ab6GCs44vDy8hgQP4lMAKZMj5Pu7iRFx6rrJW4YlD3TIqNCZF8MY53RtHc5SILzRFWuqPs78jwBWvJJn0VG7mCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

