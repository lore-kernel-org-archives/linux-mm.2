Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23806F8E48C
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 22:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656C56B0088; Thu, 16 Apr 2026 18:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6072D6B0089; Thu, 16 Apr 2026 18:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D696B008A; Thu, 16 Apr 2026 18:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44BC06B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:54:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5CFBBC225
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:54:42 +0000 (UTC)
X-FDA: 84665925204.10.E90800F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5970380004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:54:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=j3KbGLLH;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776380081; a=rsa-sha256;
	cv=none;
	b=lOxselL1xHYnXo0GFZ3WUL/1W15oh7MvdW9JPlN2oKDEwRR5tzrO8xQXdELVd3xYGx/3Tj
	69gkSHQ6LnMb/GgfOn9LQXLtUW2XnEZsAga00xnh7Odr2kyo9e5kPEsRqvguV69BYj0NDy
	JtmdBjq1MUzGgonvtaybQVoHIN/bG5Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=j3KbGLLH;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776380081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70wXQYbhJM7AqOu9XvzWJyY5HOypR2Viawd2GTTE5dg=;
	b=mtrzcHjEGC6Q6rPmvRGZs/CUjW/56Q2nKVJ2eK3Omo4JJY4CjJr+2BlnnuGo5FDSqVoESX
	PAHRqHIkt1K3QkMvHcordafQkSj7UAte93Mg4Ql1BXTOsBCu9AYl2q6iiuJhZMHcz9yfeT
	3gCMCaD9/OdXGUrpfFFRX7mL4KeOfXo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=70wXQYbhJM7AqOu9XvzWJyY5HOypR2Viawd2GTTE5dg=; b=j3KbGLLHk4Ls/BU1QHj7NpvII6
	tsTemh5kad0D9+C7shFGt7goWWuBK88Jw7XDnDR0dgotQaGLKxTj+o4cRh9Rz5uhFkraGLFkQ0L47
	I1wTLyFjmFZr7LdBm3rEizP/RHyZ9eTFWPQF4kLCbukzMd7eqfqezYzh4I8MkwUKgnmcXYEwOTp2f
	b0treebYcg1QiUSOSAw6K/+SkG5IV7N9K9fVFatyzenR0qHQIrBb5tYGP553KxkXC3PjcHHsR7RJu
	lqSgYreiM1PGErBsfBDsPi5wi7em9JyluzWrLi7VG7ya4ASfMiYuIgyqLih+NGQwrl+9gPFF14tT6
	d2cgBFuQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDVbY-00000002Lys-0Xsb;
	Thu, 16 Apr 2026 22:54:36 +0000
Date: Thu, 16 Apr 2026 23:54:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nikolay Amiantov <ab@fmap.me>, fuse-devel@lists.sourceforge.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, fuse-devel@lists.linux.dev,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
Message-ID: <aeFoqxAIaPtqGtmz@casper.infradead.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
X-Rspamd-Queue-Id: 5970380004
X-Stat-Signature: bw8umqiqhjoijbhoisyd4eia7ostd1zm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776380080-162345
X-HE-Meta: U2FsdGVkX18cPRclov5pIDXxw7G2Pki2i9wTPvOgsYTsiLoe3LkwZsPkQaEqnMRYkV7ODoBYGtlnD1UrVfVKjo0eYnGM1/dzUu+4BCqIwh3IleT5/nKfbHTM7t7kDIdLPfsQ448md+FXT4Z9J7TzJ0k3OIyyWt8J28Ae5OyiS2qQVE3aX80lmzgjgez3cAVGrle08Udh7/jjcrddXpRGWjO07qNth3gAdo76hUi/hjE1maSyJGe2LfRTRAh2eC3QBHW3fP8Jo71MD4mO1QFY0W4mITo1o+V31uE3XX+qlPOUf2jczHAP+2RZKsH4+sAJQQTRBo3lAwdS1+fQStD1ZzrGVtchOA6bgYrvN81L3OHaGYLrsQMeEK17Cy6bTPRVNx1eIeqQa5ZIWRKyL0GWHM69FmNeOYNUse9nv1jKvaKbf2D4rV15Sf4tslmTqB1t659qCrc8zk8efVDNqRSHw6FvHzlEcP0/QId9Zgq76dGiL5OkwHjuqRrciixoA2oURrhGF803oPMNXOaLGoWpASYA8E+5tC3XRn8zSF+toFi9W8mGFkwGx5bnzhrY/N7AzRrMxys/tdLEuXq7VnXd2ZWhBwXEEUTu0O9gmVGcv2lBLQ1lC6Wbyj/6ZcrhsqUye0ZA6ifAHMp84M/KEoxODp5XFHiBKisd5JcYj/U3JFvnCG/D4N3Gj8dHOIwMDBDXALesfpe3oLX8MYfI14Rh0tAkkuKxycD1+BLlVLALsXzZN2EL8X4F3+npq6RifJAaduVPPN9IzRTMQFsSCXjoaG+nzH75TRFTfw//agX3l234BOuqmg0J0N+WLpwRxC3ZGXT+lzdl6cxkAd7oBClQjK2EQZ4p8gnWQXKM5Wuv641jv92W/4etigS7K5LTTN60C+9GAbaJiadkyhzs/Jh3dQ/m0ezGEd1xnYz8q3chei2MoVRTQrCELQnrbsJvNCOKWbVq8GN6yyKUjPwMMh1
 7G7xFH2I
 LFrRvOa2/k4qWiJmIgI9c4pv3UeU0s9IZIallAz7uPFYbpIkjlNg3cCF65X9DbUy69grPk2IF8+IA8IkCNTD2oT0LA8mytBXd+FRlX3L65pgMNmV3+I9scNhM8DIik+ma+JI4KvEhJBYWXEQ3axdNfNZJIGSIQnNIz6m2eIgTb44HqHhWlnxqR/rNHf8ZQ7/XGFscagPLsEg1A9/8kAwhxeuwXCY7nAQS0IdBcNvHhZhynDfU7Nsv3gyyePiUNNuvyyXDoPH+l8+yi2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 02:12:37PM +0200, Miklos Szeredi wrote:
> On Thu, 16 Apr 2026 at 09:24, Amir Goldstein <amir73il@gmail.com> wrote:
> 
> > > I've recently encountered a weird issue with JuiceFS [1], a network FS
> > > which uses FUSE. tl;dr: when a file was being slowly appended, a reader
> > > of the same file on another host would periodically read a block of zero
> > > bytes instead of the actual data.
> 
> Thanks for the report.
> 
> I wonder if we could clear PG_uptodate on the page which had its zero
> bytes exposed by the i_size increase?
> 
> Willy?

I think every filesystem which clear PG_uptodate is doing it wrong.
I know we have ~30 places which do it, and I haven't audited them all, 
but clearing the uptodate bit can lead to the VM throwing an absolute
fit if any of the pages in that folio are mapped.

I don't think it'll make much difference whether it's cleared or
invalidated from the page cache.  Either way we're re-reading all
the data in it, which would dominate the time saved by not doing a trip
through the page allocator.

