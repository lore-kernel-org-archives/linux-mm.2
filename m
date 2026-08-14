Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DEDAC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 06:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E4F6B0623; Fri, 14 Aug 2026 02:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DB86B0625; Fri, 14 Aug 2026 02:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D216B0626; Fri, 14 Aug 2026 02:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6F16B0623
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:34:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6AE780361
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:34:54 +0000 (UTC)
X-FDA: 85098912108.18.3C705BE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 78065C000C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:34:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JkHnwos3;
	spf=none (imf22.hostedemail.com: domain of BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786689292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bt47sakA4MA7BnrCOsH2O/sVu5imfuvE7ni9rmvb6RY=;
	b=zueLAhuVYD4FKhq5AhIzLTG9OO7Q2+hOiYZqI2lqLEf6G389cgOOgQzTyBmtbHXpTQvzK4
	8cVHAVQgS+A6+sJTRHh5niaKO2RqrXlyBZsJimikp2nBgh9LHMwFboHZiHGeYKyBYtDdFf
	a3LZF6ytaqg5ZUc/8pc3EgfwUbeYNBY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JkHnwos3;
	spf=none (imf22.hostedemail.com: domain of BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786689292;
	b=hgF8L74ehoJ94FkgFoBqC0Pgbxs7VZArn2JR3gUTbWJDeOfL1u5bKb/ymjMvoTIyuCqo6Q
	U7xRv3XN2wAU9Vk7CZtqPyx6PwDNf0C0cHMo9bfeCSnp3rw4Wi4AF/yHyeS0kM/qQlCd4F
	YSDmTg5scSp+654qsgdCIfwYmu78qUg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bt47sakA4MA7BnrCOsH2O/sVu5imfuvE7ni9rmvb6RY=; b=JkHnwos3lryoDJpMC78oYcTR0w
	caGnLUmWtBj5thAvGwG1uF7ssuzhry6LHNtrk3m8lowhgdTIAeIEie7INyLBZ/7v0qrkxanXIRtqp
	n/LQ88PS4L1GWuf3tU3GXYJ6Y8tccJUCTtzrBR+veuf+1qMn0rTfVI/FjROZm4VVIqihZRRARyl7x
	NxtDYWSa9Yra4VArbUYLHwleBRsstMnWC7eG/TmMV71O1MXZsd0qS6cvzGh2wj2KmksyEFr/xOyeV
	NBNYMLQmD2Cf3PZ1900LsVDsgorTI5U4CWn1hXiKPpx3Wo4Q7lcHvBLi7E15iQLdbpxybks1JlX/V
	/vQCa2WQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wulVB-000000022lH-2KKR;
	Fri, 14 Aug 2026 06:34:49 +0000
Date: Thu, 13 Aug 2026 23:34:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] blk-crypto-fallback: Fix deadlock when encrypting
 large bio in dm layer
Message-ID: <an63CV2_cS3VqPE-@infradead.org>
References: <20260811220318.58331-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811220318.58331-1-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78065C000C
X-Stat-Signature: hyr18o9w7gof4x7x3n6kok74i8wp8krc
X-Rspam-User: 
X-HE-Tag: 1786689291-170043
X-HE-Meta: U2FsdGVkX19gXu/jAzUaF2W9Y6n7So0n/OzrWD1Dq/ZhT4i+5/HcMaWsPOzT0SdvwWNMe6NTj5kNLxDQSs7XzoXz1L34ZAm9r/v5vhtA93dtxpNW9Pa+ksGLssZ/ujUaCnyvobizQ1x8B20Ip/28ioo/5IKf95EXF5bxqvhUMkRg0CFg/qL/x7hnipPx3pmQ7eUB5F5WNbC5vR3UduvCeeOsTU/rldtkCWdijiRGZ0jAxCqrQ1o59seQTRp4UEULZEvW9bi5dnJ4El+uNFU8CdugAs95pvkfJh5/1c1t2yyDdVn3TfgnLqJ06jciM7DktdzXsPiAAqqLmJ3ZUusIWIo/ynVNLzs+lwEyEibkc7JDJ48jTE1k93LhpwMehw4kvSRcw1q5m6ei56xlOnEtsUcmqN1srH68TqlUdOu01ZU3Zl1KO1kH08Gj4jZmgW77eCbnITttFHTWtJDp/U3M6IYtu6S2b/Kgk/h6Cxr5joef5t/dOgha+5h8FH2Pl4ag96GyqKYHp62J5VjKR+gfl0iw7X+QqtiOjSgcof4J5w/v7kerQk0rXd9U8LX9yBHIEA5Ng8TF7xXy5OcfywF1g4tyzVTmc6H0Fu4nNDjI6MFT1ucTVmWMcbe4q6oBkXOcJaW8ZOhfoWTMjarTLE/ejR6/qXo3KyzrKchpEZv6E4crbFY6FZIxqYLsj7hGGnvHA3x2aUsUYNxRO2dtiKFvMLrsNWWSbfEReSXhTFSTcfjet0gwERLRhvn4sEyGIjhbr+ivdbJ86BP3/gPyDFsfCSGNjseVAU9U4ofqOzrLuu/gB22gRPiZrZvwUx7iwb37i88R83y336iXCok/Zn7TPWPrAynC2GQ/RL52gTmT2dJA0kCCjNV7uA6XBSHLkKb/XUiu9Qj7nSBygnza8HMc4zgHdjUedxMD/bgid7X+R9P3l3hn2snwj92dKzbUKCMTD5MYgCx8+213GxhLVre
 ezAAnpJ2
 qqDdVb4MEr1tCsWb2dCdfFKHSGSUWPnuFs8igz5DkkRndaWsqcu44P7e4PHMVbSjMr733sAVjQm5cHEHEUfNdJRUNk31EIiyLIqB2kPr51Bg9ibxPwmX3yjeXeWq9rRutolNKkpMsIalHEKYLzzugYS1jg4ai0e1ueB4ghoVBcCN3FM1idqqk7c7creYOT/IGofcYiDFzF+c3/jyjZcogsNj0Md+Eet/8fGp+/c+80qvPH7qK+Foxn6RGVHfUS7fGe0qtsSmtf2asSa58RTG0t+bqz9c27No4iq2VrVTnLAAYlwQ/4PIPcsTCRC0stAFWYaluxJcEVJen7BuJwkeyx9At0574MfQU6C7FdEfS9xnneP3+iPCRrNZmdpZAQTmRHpzKbkUzfejYpWFu/VS1opWBsUql/5uiU546aN76N9DPYN0/e9P6P6GcnFtnwigunkUeiZInyyT+kSjN8Kxk5+v1YN+DdiVjljvvEijSPW1rSAP48q3rsiupIFEWT9/btRxk8J9HniAPSbqulDJDnyjBOewnHFV3FjsRDeHp/a+zo6iG3Wty4kev+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 03:03:18PM -0700, Eric Biggers wrote:
> Encrypting a large bio with more than BIO_MAX_VECS pages can still
> deadlock, even after it was attempted to be fixed by
> commit b37fbce460ad ("blk-crypto: optimize bio splitting in
> blk_crypto_fallback_encrypt_bio") and commit 3d939695e682 ("blk-crypto:
> use mempool_alloc_bulk for encrypted bio page allocation").
> 
> This is because __blk_crypto_fallback_encrypt_bio() assumes that the
> bounce bios that it submits will eventually complete, unblocking it from
> allocating additional bounce bios and pages.  However, dm-inlinecrypt.c
> calls __blk_crypto_submit_bio() from within submit_bio() itself.  In
> this case, the recursive submit_bio() simply adds the bounce bio to
> current->bio_list without actually submitting it yet.  That breaks the
> guarantee that forward progress is being made.
> 
> To fix this, allocate the bio and bounce pages with GFP_NOWAIT if
> current->bio_list is set.  If it fails, punt the encryption of the
> remaining part of the bio to a kworker.
> 
> Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")

No, it dos not fix that commit.  I "fixes" the misguided attempt to use
this from inside stackable drivers.  Let's drop the dm-inlinecrypt
target instead as this just shows up one more reason why that is a
broken idea.

> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> Changed in v2:
> - Switched to the less efficient approach preferred by Christoph

This is in no way the approach I prefer or even advocated for.


