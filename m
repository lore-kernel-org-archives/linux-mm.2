Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBD4C44503
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6146B008C; Wed,  8 Jul 2026 13:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254916B0092; Wed,  8 Jul 2026 13:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145B06B0093; Wed,  8 Jul 2026 13:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3ADB6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:44:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 694731A025E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:44:31 +0000 (UTC)
X-FDA: 84966333942.28.D9BA780
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9FC37140005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:44:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JIkJTb2U;
	spf=pass (imf23.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783532669;
	b=tNMdlmfnZIt1eQxBFmrSiwmsC3q8koZ8kIhO6DBg2XM9YI+6BLd1mSYUPmhuURBnh8LxpN
	pgnv7RWFdogNQ4Y8oVLhudAAZRx5C48rPS7ZQqr5jAv3viYFYtYWybea5K82PUUVO3ArOd
	wTDLUH/BEibsQHXYMkSLHWlnPesGDn4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JIkJTb2U;
	spf=pass (imf23.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783532669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmyFw2R0UQPIDfzvj9wMwsWmgYLjmqNhoTqDamPgvg8=;
	b=d4f/WFO0/zask2dBvvqvQW4++H5bhRG4iOyWKGzZcAphcRIcZSIfIh7s4jQdai0TAqTlOh
	wePab85c8Bb/O3Cc7bXdyBNC2AQjmpjAqpMHfo5W8c7KP/IDgOgqeDnFY8C7lAKFLPDNaU
	6FfrejJBojwa1qDjr7YXWc7MxtPc0Hk=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cb59f6ba26so9565ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783532668; x=1784137468; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xmyFw2R0UQPIDfzvj9wMwsWmgYLjmqNhoTqDamPgvg8=;
        b=JIkJTb2UhhE9fvQaoS6D7LTPIQUOOhNYahpJGaTnfP5aOLCfmrMioXwKSE4aHNm12k
         dpOhPSRew3GqzOWFibbUX/C0+uqNuTTyOZJB2ZnkJMBZFUVBpsRpqYn9Dn3plVcqQKvS
         jxd79xKYmjgkUJTJ3uAsPd7hzS8O8U8NHbPZdiqKIJUtutUwVKGc6u7ZVhogYXn9+lcM
         ln8iE/wrbIwmh88yg8PgWsHMFJSNdElLhO335LyKWxu8HIgAW516M9FL9Qyp2awiMLyF
         4CzjzWbisIWl0CNN05rO4ZLXNoJteapFSHYnKS3Iv0QHSa1n/zGw0bxXgCwOhtipe8K7
         l4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783532668; x=1784137468;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xmyFw2R0UQPIDfzvj9wMwsWmgYLjmqNhoTqDamPgvg8=;
        b=X0VJRX9VpwySXv0We2OETktwJtGG55O9IpBFfc1EDnNm2pwow8OAERrWnhl/iDhH54
         NGRtdx8DJE7QaNXg3iijywhkbJDGFSOB0MIckGodeK4k21fn9u1qwdQGypKQg+jKqrOx
         X34nASv4K8/z6LwYmhy0WXY3ivpoHLkxyFOP7PzQ+1mMZeqHUMc1nSnzZXKbWHpUR0YV
         dopghJKtIYMI3umHaJ2rowJgboAqfw9A60e2D0g0f7qOgbht64Sdo4OvvW8Gr6tS+/Ua
         FsyG9mLvtideaRrWTTgvl2dYNw6UzFkNs1fUZe7Memie+0cPCPrEUhnglVpIr+fzoSvo
         RPXA==
X-Forwarded-Encrypted: i=1; AHgh+RqQyYuo0TMGZZLpNxC/4vO/W8Fl5FsPKb8yPSz6A6rtY1grpkyX2r6g2DObWHhlRvUrk6WeK0jX9A==@kvack.org
X-Gm-Message-State: AOJu0YzcfwU4LgEW84ll9dCO/FITf786i6bo9xrhnQu7kXSWQicbKLBH
	7yXMcjAvMdE6WoRjkP0HSCb3yzm75uKQjnwHN6puX4U3FKu8fQZAP5ftola8AFJ28w==
X-Gm-Gg: AfdE7clGjKna99sy/Ct7JwEAnop65YBhRy74xS6KTYpBASZY7Ah8klnwfQUHK0bpKSt
	aW/4P+XqgMC8UzlFuLD5J21+0ZeqkLc1mlyHdDI59sqiLzj/9jnTFwdwpx64cZYREtkDp3Z61ki
	juvcg2fnN+rM8cB8M90HJ2vA86aTGa3ho8p5qnS/ahO/XcGLeuBwonwKTvUErhzPXGxlLr3Iz+G
	WNQI85v7KOVbc8JBZrayq4aRcIl1goylYhmPgBYUkBJ5CyCYyIK34zOpO0xM7yTWlhf0mdvJpwJ
	I5+uwVUQFwxOcihVoYLvxkHmNRefM0jkFkTKkBxdwAlIljoHXaD7ICyhuTrqcpmq/AqexctxkDF
	1KG61d6iRIQgJ4cXZc4ws6FXxyBu9u29RYxLXrPR7ofQa98aMWLzpfGPORThv3ZYORdzqDRS+8f
	ht2jLtZRPQDazLl+vmyH7b0tldpfAyeZn4ATf73ssf8w6l+JU=
X-Received: by 2002:a17:903:38d0:b0:2cc:7759:ffcf with SMTP id d9443c01a7336-2ccff916ae6mr403275ad.17.1783532668070;
        Wed, 08 Jul 2026 10:44:28 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb746sm30815595ad.7.2026.07.08.10.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:44:27 -0700 (PDT)
Date: Wed, 8 Jul 2026 17:44:22 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak6Mdp45x8TGNOPP@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
 <ak57VeunO8qd4wEh@google.com>
 <ak6DUC7NsIZ20RZD@google.com>
 <ak6FJf8jUGudEw0c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak6FJf8jUGudEw0c@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9FC37140005
X-Stat-Signature: 6xeyra5o4ffniu1s6nh97kdtaj8abyof
X-HE-Tag: 1783532669-158978
X-HE-Meta: U2FsdGVkX1+YbIeR1TBYrDv5h9Ir/tbSFAih18QPYrm/QnHgFhsD8C89GI2Qx5QTTds6Z2B7nnsnpzyseDpKNRsKCk/rD53/aY+cF22f5Q9kZJrfxfN7ptGk8ntVhCoWoEs1GrJi0CPCa/+wm5jY1wwCxGOhhR5I9gEz77PqGn62h/G2J4XCB2cPqgWmz0qbqLiJbGXQAUKITFhHLl/m/2qDrhXBUk17eYlRnvFfynELzAkMYYqhMSAs7Gj0qJHsm0g+UlFrOndNaYDmGCCPAAq1IY7WwnCG/SS2fljGqoR4+g7QYqAIMx2CNHo7AwbCpkYU5z/D4/ox98GPFCWS5RnZw3ssXYEU/8EobS0UnFGGIk/Oy5w7Zl0/5bYFNsLZ5A8Uzq+MOaQJ520/uiqFsszOq7UGEQa/pcC8q67YlaJN1dKPI1v6gaylyKbtxwFNXwDYmBTDw6utpr/1Do/HjEInkMGnIeEy5BuyJVfEk6RtEf0YDaqtSK3v7d+n4eSCq9/Ib45x3zPaPbdT+kcCAPSdycu05LjE1aIHp+ee3IDeE2FYj2rJr4SgpOwydF5K6oHp4ZhVLBTFmybYxdYV7gmNA/TywcaMyWdDvh2SLrgTJVukBkZCS8Km9Zj7AEpp32NJXQwKmWBI4sq+9nqwLBBxI5hIQSNVfGg7FQ5JRDqiCi0wyRG2sDRqenGPUMjsDGY+yUibIeAs9DKizfuzWv2sqzEf+99J+E6/DdZ6r6hQdvVUEi73w8n23JYwmcXJzlJjDo0RQOCnPkiIhgmDCNgAapCq1Ai1k1Gk3plIzMCZK5PR8adw6ZCc7eLLxlgXrWwNN5WHh8mZgZ16+GfvjeLyc9qr18qvp0upn+xi/kis4y1OIieSDbYpFga3LlhTS9q6551N8PC/M3eiyNgzcZBMIeUGqZFRxEwmMo3C64y4F8KTLjfYT1YVcMyCSBby11/eMxPoUFNdtqnT2zD
 ZlybJzbr
 wrgy69fW/we9So6r3JoIMzupthCcFFj7IATVj/49UmEL9Mb8tyFrMDWRUbQo/9L950/qXCVW3s4wt9kwhvKR46zbL4Y8WIEs1K+3gnIBnT5tEIJeyzAQdRBQCGZ4avi6y4ltoq/llpd9v8E0P6QSeDoPdllFIa2YJQiUFcBRzG3bbYPUqUnCVpfZzWYuR4zkBU/JfAjXC7qCNMutGmNL1ZwAU0UEU8ACMQfcd1uxa6ilJs54iBYwSm6GJg8QYwhJNOdgimXRHTKVvBXiOjNdAdwFYU+DxIkW7Qvi4EsBQWHFcGZoS1N+/Z05Omn5DaIkCSch2yhtizUPhcV7NfHRviste23VGb1t737IQHvfjslyIZTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 05:14:40PM +0000, Samiullah Khawaja wrote:
> On Wed, Jul 08, 2026 at 05:05:20PM +0000, Pranjal Shrivastava wrote:
> > On Wed, Jul 08, 2026 at 04:36:46PM +0000, Samiullah Khawaja wrote:
> > > On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
> > > > On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
> > > >
> > > 
> > > [snip]
> > > > >
> > > > > 3. kho_restore_page() applies the correct refcount pattern based on the
> > > > >    preserved metadata.
> > > >
> > > > Why do you need to save the type of pages in KHO metadata? For example,
> > > > for pages or folios, we don't store any type information and leave it to
> > > > the caller choose the right API. So reserve-mem and kho vmalloc need
> > > > pages, they can call kho_{preserve,restore}_pages(), and memfd needs
> > > > folios so it can call kho_{preserve,restore}_folio(). The radix tree
> > > > itself does not hold the information. The caller knows what its memory
> > > > is supposed to be so it calls the right restore API.
> > > >
> > > > So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
> > > > name; we can argue about the naming later)? Then your driver knows it is
> > > > restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
> > > > takes care of initializing the pages with the right refcounts.
> > > >
> > > > You won't have to muck about with the ABI in that case.
> > > 
> > > +1
> > > 
> > > I think this makes sense. The mm already relies on the allocator to
> > > track the type of pages it has and expectes it to use free_pages or
> > > put_page() or free_page(), so it is natural for KHO to rely on the
> > > caller to call the right restore API.
> > > 
> > > Lets add kho_preserve/restore_page_contig|_order|_nonsplit and the dma
> > > preservation can use the appropriate one during restore.
> > 
> > Ack. I like kho_restore_contig, I don't think we'll need a preserve for
> > this though? Preserve doesn't seem to be preserving refcounts, I guess
> > we could rely on kho_preserve_pages and the caller can use
> > kho_restore_pages_contig() to set refcount correctly for unsplit pages?
> 
> I think for consistency we can add both, even if preserve doesn't do
> anything special internally.

Ack, alright.

> > 
> > Thanks
> > Praan
> 
> Sami

Praan

