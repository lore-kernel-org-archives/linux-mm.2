Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B597CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587A16B011B; Wed, 27 May 2026 11:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F716B011C; Wed, 27 May 2026 11:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474DC6B011D; Wed, 27 May 2026 11:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 367236B011B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:42:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D167D4063E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:42:11 +0000 (UTC)
X-FDA: 84813616062.21.D356D6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2C61740004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:42:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRr7GJAh;
	spf=pass (imf17.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMuKNG4HxYra3vlaS9CtWig32q9g8dK7SLHIEtEzN2g=;
	b=GzxjfiRUqzwctFid+OqXUxDE/AHfon0fpqnaOE6D+bV9aGw8l9Oj9DomTU9TPtI+LuRB/E
	Zhc2ElRzbsluQHpCOeRFZTAuE+PsEWcVzfg8ZrB28PYxb9f5Oe5Kzvg3C/EetaeNowggRr
	w5Z1es0P0hbt4L446EfuR/sOvG4l7KA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779896530; a=rsa-sha256;
	cv=none;
	b=BtDcj0kwNiyN3KA31RK68cCtcOTcYXS+VJVghkJ93ccXvuYDstT+hy6ExY6Kc7T166XJ1a
	dWTDUWlzXjb0hPdPkt176wsfwbQpmc3k4mUV+J3VBPhycabOUcJ2Y0257/HnBX/MioetU+
	LdZO8ICGf+Zf7hsWMkqIh928CL+6Hkc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRr7GJAh;
	spf=pass (imf17.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 159A441B27;
	Wed, 27 May 2026 15:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959161F000E9;
	Wed, 27 May 2026 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779896529;
	bh=zMuKNG4HxYra3vlaS9CtWig32q9g8dK7SLHIEtEzN2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jRr7GJAhGlahPzN0bmeBXmtT0my8GCvw8BEnvoA0LHYmPZeF2NiGk/GoK4nW4iAI2
	 ah3DD6/iXQ06gmV829oiq4bltVzTjc4l9q/dzZxerNzX0v35Ht2iMEHMJ2Emrqt67I
	 MC9X0Ve2SmiTTeUv8lJORBTKQNvbigYOqlPLtBZtmWYaZSp8lVMgMDzjob8fkxb5hQ
	 FvBEW+y9hVHlppwfRLE2LN/rhcRUt55KCb8XV4FkKz5AVg1tN2pOESYeRx/RNoE2m0
	 aY4/qERt8Yjo9xLdjWHct8cXrh7SN9YUdfxwFBPRCtp+SF81vbpHlwAfuGPCj/WoLj
	 oqBb9fXdQZb2Q==
Date: Wed, 27 May 2026 15:42:07 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahcQz9Z227RoWOFL@google.com>
References: <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
 <ahBii6bk0KbK_NHV@google.com>
 <ahPffhaOi2CBtWof@infradead.org>
 <ahT1nT3xsMGkyJab@google.com>
 <ahUF7HqSKFJ422bU@casper.infradead.org>
 <ahaOpdw7NgsWe8J4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahaOpdw7NgsWe8J4@infradead.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: 5x3de4dm7e7y5t1y5ds9dq7oq8maif79
X-Rspamd-Queue-Id: 2C61740004
X-Rspam-User: 
X-HE-Tag: 1779896530-726678
X-HE-Meta: U2FsdGVkX18rs3dfqcPY+VcFbItved4exTfbgVIeV2D5OJyiCeKCoIWdBRwVbIf5oKZQlThJAp/um8YHkBdCsN16/E6tVugCQOZQTKrlPmxMTUtUc38f/lqkU1Ee3U/bJ64jJKlFLgY72bepjn0QFdaO75ufWXj6CZDnchCLlBL04brMhDKFq9pitf8xlBN10E6BpDz4F0WF/DMGuZHmOWlbemXRBzOUHGJnxENZOApb1fKNi9Ch6vIvEavzQj7y90hyVtEnbu18KhjB+Yd4XW1ly2JPZFhxuCrKOd5JsqnxQOmuYeI1zl0zeB9DX+ZZ1kHNFeO3LRPXK+V1rv7eJahAnxHytSXlN0O80VAt25XpeekcXDunq00x2jbCDFbn1ApzvidkA0Ns5QOcMlmA23b8UUBWfAPPQzlgHg04BvXq7RNYIDHVJM/cjzEYp4NvUXXz0Bx5Y3+QB9PIDNUNevVtaWUCi+NgpeWUY2AGK3JT4efUmkOT2aloHZL4tuz2Qxv+LY79dHX2X2oUTB7ZTVKgGKM2lMvVRu4DJg6Xi5wkFqmC/xUuBBoaTwiW+AMBdKTCTgigugx59i3/p3Bp6/4yz89QMWpoUsvJqexfGgBlu4c1q7QnCqiMLTEbuye66KDoHk0koQTBMWZ0rFpr0/WssbUBiJvt8FO/hkZrylS25AzOX7yixE3KnGYSM4Oz91mDofZAW8JqqFIgE2FXjqavJQ6ZLMqBIR66MjTFjRduwA7bgdLzWH1TsQ/cZFiyhWHtZFe9LeBwJn2JIuOLnOna/qJ5ugCT6fivh9o3FpYaLAjvRnFC5uQ9a5RauDDLXSpzsGNw0zcJmDI0l7NiTls5iwgVIB0U9G89CZfSNd1y4T7lkjj8+d0Ffims1/I21dIehSYd/HrL8ZPM0wO8zZn+uZUjSbyC03lWkOUccPkx+FfCDcuNwaEp9yEoBqXZ9VEtnypTmOzdl9sOEwR
 Ejo8X5UG
 7WCAut3wK2c5gLd08P3NvdHYEJfm7gxqY1TcXHjBolJ+VXpE8g9/KgvAelPhglfIfLxPM3G54pUoiKCQUUF+5wGYBMbT0YJzEadcGX3gIXeaBusVhbNPHwCZqBvMTed999A94eP7iVfJvGGNrRG7xKkPub6rx8PWqz/dkECXzlfgakICaZFGJFv5nF1vaczWxKUF1smlWwTXaYnNAuUN7FwEYMjYfVQOKuLsYHjpJeZDMWlUtVh4+m/fnthwMEANC2gIH0P+oYADPzaiX1S0LkwS8M8eaNyOOACC8H/SfAzteDMH1jvAomT4IgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 03:31:08AM +0100, Matthew Wilcox wrote:
> > > > And what are you trying to say us with that?
> > > 
> > > This means, high-order pages were used up by EROFS which sets large folio by
> > > default. So, I wanted to say the concern was based on actual data which was what
> > > Mattew asked.
> > 
> > This isn't that though.  What you actually need is to show that high order
> > allocations are _failing_.
> 
> Exactly.
> 
> > If what you want is large folios readily available, then what you want
> > is large folios used _everywhere_ because then they're easy to get!
> 
> Yes.
> 
> > If there's small folios in use, you need to reclaim a lot of memory in
> > order to reassemble large folios (it's the birthday paradox, similar to
> > the hash collision problem).
> 
> Yeah.  Although it seems we have an issue with > order costly folios
> at the moment, but we should fix this.
> 
> And f2fs really needs to up the game and support large folios fully
> so that we can run that kind of analysis there as well, without this
> all this is just piling hacks on top of other hacks.

Ok, I'll revisit the large folio support in f2fs, and try to revisit the
problem afterwards.

Thanks,

> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

