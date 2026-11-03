Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635C2606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=HMnnSs23
Received: by kanga.kvack.org (Postfix)
	id 67A586B05B5; Mon,  2 Nov 2026 20:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62ABF6B05B7; Mon,  2 Nov 2026 20:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541406B05B8; Mon,  2 Nov 2026 20:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9ED6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:49:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACCA31602BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:49:36 +0000 (UTC)
X-FDA: 85392125952.12.ED3783E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 98A0A40004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:49:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HMnnSs23;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqD5KjVEUEOf5ZVgC/hbD2wTa3fhBUi4PPSMQExmXq4=;
	b=dHVxagI0mU8uyq66wWFLsHSbk8hLQ5wOqtmRfXc4KsQ3kA51d6Xrs5P8xlRWKP8dq0HPU+
	iGm+a0bBaAivGTgJIqfrdj14SZc64OIzFSNVKW7dp5Hqdla8FlhcnN9Btq2aqyaPRCeEtL
	fdlNXJyI7im4oBHLf31X1oYTHWHZEc0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HMnnSs23;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670575;
	b=2wpCWgn7BZRvp4ymlRLZCj/939OBdcsBcNgJJnyguW5ROsK/x8QsZpSDh+AkUAqI8Id3a3
	Li067jZ0bLsrdvg2qk1eHEgSUk2XDW1Gr6qKIqgc/nnc2tlFiOPQ7Ypemsp6neua/21tAj
	/IhL+RzBhLgMdJ5anG4i5HAAwfuaKxQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oqD5KjVEUEOf5ZVgC/hbD2wTa3fhBUi4PPSMQExmXq4=; b=HMnnSs23htRHeD+t1FXWi56qQU
	kPaJq1I5j/zgCvQGnhWnpQywJkuRkZqvwjGZsMKrWXHfl2qdKOx1DObFxKsDHRH1vFhhs7CgyiJ1z
	h6tspKBuh2NCHFUFtlbdZ1NDITMe8KcbwrD8rBm3MQfa2hC3aRsM2cDf1kDW8HK6HoJaFNBZxLeI8
	FPr8ahYhpC59zyt4ZozA+Z38N+HYlvdIaFUWJGkWVOP9XYNc1xgHtjKQFZ98Zr1lnwu3eEQnSFoPZ
	TJmLSL/MyBwVtYi84PRuIDAxZ4T2ehO+femW09MTceV3Iztu3PxigLwucGnoDjDotL1sTmlr5JJ2g
	Ni7SNwNg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO3eT-00000000p01-3FoP;
	Tue, 03 Nov 2026 01:49:29 +0000
Date: Mon, 2 Nov 2026 20:49:23 -0500
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Davidlohr Bueso <dave@stgolabs.net>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auaFhOa5EBz4gJwK@gondor.apana.org.au>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98A0A40004
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: nfjqs3e51z7434rgwo4bn4tth1wk8a4h
X-HE-Tag: 1793670574-661282
X-HE-Meta: U2FsdGVkX1+XdVxPINOPzdKZAwIvNrsd0mL3gsmd5E5LCQx+hl2mGUyL7OwnsrIfdJ5t07KHkiZ30vBu7DCExOK2ONngVcSzKXKpTg4gmk0LjHu0CuLI8LefBQTVbSyWPIrWPjaGz8qCrTjS3iqPEtA47wkBzlFDrYOg16zusBAAa5AqE2YTkA2gIlszRqntIJ2rnOBsEyVBZiM0bYOl2qav8wQL20SpPVHoB1X2Wgo2fZzhQhDBSU2TEvIh2YIOwOCuHG5+h+rwUFYB3auJKINoZ5tNcPj3TR8puCc/tbGJgiDtchS/xyiD46lm7YqlhaJ97r4HyngXPfDgZCh/mD9l7XSp6k0XdIhNsvWMoa7EmYmvBCczGbKYU5OJf+H46f18EiEyf/KFjqnJ9HTyIKsgy7YlTeGqc6ap5en05WL3Fzjn6kTpqf7gfBkhYgDTV6A4/wy57luGhPET18uO4PyaBsWXkWukqKtVvUKozQ1/cbLKmZi95T8kjAt2x2brLdu4asOmxqvX2V3JtopzJRwNh57vzEmG85QZ44gh9fJPu5Fk8qNc4ARIm8Vypiv12WjW9ItQBUj6R8LIA5f7ux88eBtl1Mx6/lNiOtM2vyDk46GxgqW/pRKA+0AP63t17rzF6/Ye4B2e9rjc0s5QOra4Pn2SK+73ZuMdbkLu2T7xSo6Gf7ucI2dExrtJ3uCXj/Ru3CvejZzyUJZqFeDSN46PG2gM0S8QWB525/Y3PwoQvfA1CvQBBwyGKZyXxmBz5aOcMnC2DoCAYzfCMp6PcLU67EMH63afAmfvr66aoIsIyPkwPeW2qRpNrhbccKDSiwW+pmLBddRa+qGI0qmLo4ir39kgd16548+NGTHqqyHXD3HRUb84hVPzzLne0axqIVlSZ1f0GTfpPj+L3RM1xnaiqZ3PidUgoyWIz0FtLASvPBz95aXWKV4SMxXB+jC9kaZY/U3+8jgylJ6cF8k
 Nnxp/Jha
 1I/sW54R1UxjUL4loGULu2TGXcFrj3spQJ+Vu+QwpG/UowwOBprAClwKSRa2jHDb663w7gzEhzdatwfIiqvrs8UGp6ctxOWcDwRzrGMgwq7fGMzRcl8jGYVHOn7yhxPlOrCKxlbmxoDG7/EQy1InJp7GTgFw5dqHaZlJ75X30U84r5j//eNCcin2D7GxoDzRjbZejk/JrC4krTaBvwvoHIh/rQHKuLHQvzNKohkecVYJD2CjyukWY0PNQzdogO6geAWKCZfc1yEHC37xc0jqGdSXLrJIsTdxxZ5tIAQSIpMYsdKFg+tfJnIYHA6/62vpmjhBl2ogfnRly7+gEHPNdDwWL3HuVV1P8IBdcoKFWVCgwjNBHKkf8RDWbMTzhEC3EGuUPA1Zj0qUs6V/pJmlSI2LivyChp+rf6HUW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/01 08:19AM, Herbert Xu wrote:
> On Fri, Oct 30, 2026 at 08:56:03PM -0400, Liam R. Howlett (Google) wrote:
> >
> > Hubert, I have another version of this patch set to send out, but this
> > particular patch remains the same.
> > 
> > Are you okay with keeping it the way it is for this release?
> > 
> > I don't want to force your hand but I also don't want to keep a valid
> > deadlock scenario in-tree.
> 
> Instead of your patch, please revert the original change that
> added kvmalloc to rhashtable:
> 
> commit 93f976b5190df32793908d49165f78e67fcb66cf
> Author: Davidlohr Bueso <dave@stgolabs.net>
> Date:   Tue Aug 21 22:01:45 2018 -0700
> 
>     lib/rhashtable: simplify bucket_table_alloc()
> 

I don't follow.  Reverting that patch gives the same functional flow as
the patch I already sent; kzalloc() for one branch and kvzalloc() for
the other. 

We will, however, restore the useless __GFP_NORETRY flag to one branch,
and a broken check.

-       if (gfp != GFP_KERNEL)
-               tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);

gfp != GFP_KERNEL is supposed to just send GFP_ATOMIC in here, but
instead you are sending GFP_KERNEL | __GFP_NOFAIL as well.
gfpflags_allow_blocking() should be used here, right?

The patch you are saying to revert was correct when it went in.

> The newly added alloc_hooks_tag call should go after the if statement.

You are saying to add it to both branches of the if statement, right?

> 
> This patch should also be split out of your series and posted to
> linux-crypto.

Sounds good.

The fixes tag should still point to c6307674ed82, since that's when the
issue became visible.

Thanks,
Liam


