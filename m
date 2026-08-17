Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA512C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993A96B00AB; Mon, 17 Aug 2026 05:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B2D6B08CE; Mon, 17 Aug 2026 05:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7D96B08CC; Mon, 17 Aug 2026 05:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF9E6B08CE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:13:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85BE5140705
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:13:53 +0000 (UTC)
X-FDA: 85110199146.18.EC73024
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 807791C0002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:13:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y3bMDvrP;
	spf=none (imf18.hostedemail.com: domain of BATV+9d800ca74f52a7ff1a20+8394+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9d800ca74f52a7ff1a20+8394+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786958031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrRtdL7tMjigFfpzcDXOtrbxqbOC7K/d7mLEzjCsxzg=;
	b=CP0jxuyzvNVjFhnt1N+kcU6Y6lvt1oD99yKR/k9YIZLavnRVBR/8raIcRm5oaOpFvP/7GD
	/HUKC8uxvVNZAJLKBvMoxZnH3jDqgCGhHQFE2lpu9wH89t6X3G7X4mG8HNtbp1/BtYdfES
	xpElrnDom96AwfFDL56dSLk/OnXMg5k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y3bMDvrP;
	spf=none (imf18.hostedemail.com: domain of BATV+9d800ca74f52a7ff1a20+8394+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9d800ca74f52a7ff1a20+8394+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786958031;
	b=ucb1yDJo5KNdOp5NKPB88KbyS5ghYyVBIH7FjUU3h53mvZ+QQCWlo86qdOjxV3QQPDLacj
	pJtjZm4gyi+a/dosOeZ+QCubu0RQv9jyzYOwnp50TqxYzkUCpwet5TS58Jx7SAl4M24ox9
	0qn3KAbEb9syM02PmoXykfvBswBMWXk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GrRtdL7tMjigFfpzcDXOtrbxqbOC7K/d7mLEzjCsxzg=; b=y3bMDvrPrcrgnKD9ZWcAqqzKHE
	xnuvb+H6INQaqm+c/TRGhz0NIDpOp/2O2P0C6rneC2l7cmv82pdcjeVU6KTruE6beruaPqDplcaEi
	D3h2NMD028GsZAbNz0a66ktgwJSakWdvdXK7ASUAPZLOMWUAPZAPiGvE19MMmHvX0VO2OR1l3AxTR
	O6Z56O0xo4/OowNkyA5CfVxqxw+CDiOvbq8bTyOS1yURTlHiDiJCjhDNb4WSjMUsy1Bl2FQ0HFvQG
	cOpni7zwciHsbn/IsEj9rpPcGtOdQ/mZDmSg9DkPlJaTOxU4GontWXw03FOL4Xro33i3LG65Zj94b
	tHPwvhgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvtPg-00000005mtK-1Tdz;
	Mon, 17 Aug 2026 09:13:48 +0000
Date: Mon, 17 Aug 2026 02:13:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] blk-crypto-fallback: Fix deadlock when encrypting
 large bio in dm layer
Message-ID: <aoLQzDNH90tdg0Cp@infradead.org>
References: <20260811220318.58331-1-ebiggers@kernel.org>
 <an63CV2_cS3VqPE-@infradead.org>
 <20260814194507.GA2644249@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814194507.GA2644249@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 807791C0002
X-Stat-Signature: t7kezqcz9o9o55qn3kyfrm774cppts8e
X-Rspam-User: 
X-HE-Tag: 1786958030-93880
X-HE-Meta: U2FsdGVkX18eO3JNpnF/EO5prAIiOcsw8g3th+45U6AJz8743mSY0hH/55XEbBiX1P1zI74OCNh4+XJyRNvH5knqb9s1RpfGiOhHpYKXSrKY2AwSc296PfGh5ZSbCL2nPpwJlI8l0EgPJlQWAMvu/i7F3ooek7TnvY2aOohm9iR6FAX+9D5g806vTiBpxgaebMQc8d/cs5MpA4VMBWE0+y9IUlyqnB5UlkojHOVjH98kwGKw/MjpbouDzijFtMaXfJFuSfbP7njCMrd59QL4D8yVLcSBsGNZYtGazciJkZ/XMbqimd4PEjcINuyEX8lARrchZwYk8U0UIVwEQgnThcG7wO0saHxgFe02NlSrOSPDSWKOdSXHghFwuem9ghekJ5nVaABC6yiBVbdNlVDVPwWkoJ7L7M+eJPwabDGt+WeOj1vtngpicLbtYgZb2kdfFkfn3U9OkiolIodidDwsR9UI4MA781iUJMsP16mYKWSY3KId1STPgYXPAKi8RpJA6IK6f9nxZ6nbSScKI/XJO6anweGYWpYOca2ZooFlJMR8LXsSywsOcqkKv+LVPuHncjYbslOq9fQY5UAdSfAJbcHVXNsgqDiG6fz+PpxCg3XczAYKXlsB6mkAKmYXB2rkpAVPs+dxtCmxpfI6HJzAZI1gWFCxO6C38948x7tNu5bIWPH8EMrLO9qZPohdpHyXHOvAWwxe81v3uMHwG0asWUgo+DcWou9enGDrTP9gJ83Jf4S7gsLOJFPv7zFQvudpw0gHJOd6Mw8UfJMcHryCDF1AlbBW3t/1NPhTPuKqKOpYqVazhwxWLokbLHE/YXdz1nOmNilX51G7kz/ss4oCO3mO1xZp8OKlu7rUIMn/dwQOY9m5gOIr58oTYjryW4EOzfLQk4WpcQa0rN69QtNq2KA+WnD1ckZ6ai/H4g1tQffctsyv3IFHLGbLBOgres4+93JXMgolCqXfNuaJp+e
 KxkFUNj0
 iWgCupQQLmwHYDJJ5uEV6NiTT5Y7hRQ95nE0m+g+hGpJ8ksAao9TM0zmqxWy46ojGIG8WtA9uiTRv50jWVyKD+wj5Z00igbpBv0Ylscf1+gJu9tPJpGag4JGMXtTW/Hc7GCEpj618k43gyiuQZzAfs+RnpvJ0kiNssar+HGm8gbnxOXN0bquE5Yf2/Jems3aW0OLPgm468BHjzA2BXUhbxBY2Fkakrq2swDNb/974mo4tOr/yaKfdRrDFyiI2LEWYOXiBhgok8b3tMtghEd9b5s/czxyOTVEqeik4YP6SngNT98HjNl4vzrX0cAtL/Kx+LLhGhDzhT0LTfd9SDoekC8uXpRAbKaFaZzDz9fc1sLL7Vw/sYgfjl2FIyjZYHs1Wfw+PlpMuJg75A7+VlfzvHvBxLihqbFlU2gZXnaLlaq1uw3JcrBk6drfXAJS9P2bkKtCAn6V5Ue0VYk4r6SE547YnwMuNShRepkXPdLYJ0O84BlWXw5nBi72IV0qzrxW+YqCgOgooSCQmvE17FnDLidBfZwbq6U3Bbm02
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 07:45:07PM +0000, Eric Biggers wrote:
> It is what you asked for on v1 and you've now changed your position, as
> far as I can tell. 

No, you completely misinterpreted it.

> I can change the Fixes commit to e7f57d2c47e2.
> dm-inlinecrypt is useful and it does not make sense to drop it.

Well, I disagree, and it obviously missed this problem.


