Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7FDCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 12:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EBC6B013C; Fri, 26 Jun 2026 08:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF7C6B013E; Fri, 26 Jun 2026 08:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E81F6B013F; Fri, 26 Jun 2026 08:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16AAF6B013C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:03:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F4231A041A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:03:43 +0000 (UTC)
X-FDA: 84921929526.12.7D88868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B0314000F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:03:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrjUtRkm;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782475422;
	b=HSBj6GSAqXG04Szkgqgq95ryFKM7CeXuVgY7Y8nbGbyS/snSOF7jyGMkd/WHfMg7ARD3sq
	WDWBm6TENSG7bvN77OIEFr04Et4vt1ayRnaXk+lRdaZo9UNrsq42xDX2beofAYQfbvLuRD
	UD3hYlydJY2YSnWW4jZ+gMOSLBsE6kk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782475422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+O8tsJQndsfmCOxVs6WQWK/G9XK0qBCLMq98dP4CqY=;
	b=ev1ZfwydzV23G378J2PdfSZSWEEhOxjAvFcq4KsNAIdLbDQvYwgTsLUWHANtXsWGqAQewm
	xeeqP0VOLr9UjcS1f2aEH3AdXh183bIWv3uQT4O5TPU0+gZU/lH9KSNm2UD8cB0WthIyvA
	g+Mex/q/PDghd9fCAhCophXMsihXfNI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrjUtRkm;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2757F43C96;
	Fri, 26 Jun 2026 12:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C7A1F000E9;
	Fri, 26 Jun 2026 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475421;
	bh=M+O8tsJQndsfmCOxVs6WQWK/G9XK0qBCLMq98dP4CqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lrjUtRkmeDylsGTxNEHtOePh1aCK2XrzEsz80+cPPLy//PrX/DOiRdcA9ztD8Md/w
	 NfAcljoHZ3BdbxP/RVqVi7l6WlnDXuA9nZbKjUogzfnNjGBib0WzuEL+0A410/6UVZ
	 7I8GeVMpXxsd8ax4WXlp3mHW4kT8l1REahR0Q/EU2oQaX9MNYdAt/J3DKZWYPRMZ1w
	 cZ1QBH5Z4Kdcs4TBL9IATQLTEwfoCFrByobdGBp1r6MwR7HU0v0qi0r3G2wF+ygXV3
	 yvYSTl77eWn6mjhm3HY5KO8EtxnhGEQKt31LOS8VXaBi7kMwhpHoF21ht+TvHzo39B
	 zFLEFRJu9KeIg==
Date: Fri, 26 Jun 2026 13:03:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix CONFIG_STACK_GROWSUP typo in
 tools/testing/vma/include/dup.h
Message-ID: <aj5qQA1Hj_M8sEb3@lucifer>
References: <20260611012258.432043-1-enelsonmoore@gmail.com>
 <8fc34141-b8a7-43fd-8c84-f843bd34fb9f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fc34141-b8a7-43fd-8c84-f843bd34fb9f@kernel.org>
X-Stat-Signature: djipzq89kz8g6o7dkz7jhdj6xw3sm7nd
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B0314000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782475421-591746
X-HE-Meta: U2FsdGVkX1/bJ0GC4c+Yt5WqEKviiuS3ttewiHbatxIoSOF8FgMLYO/YQPHeSc4gX3B6JFgw3JxJ7zoB4ENOc5b7Kxb1q0esQRHIsq40LGZyLU7nQYpa5oPy4PB29fJjVviP2ckDm4Ab1mQu1V0bM7Eu5MhXhFqUTTV2Ty7mk/hY5JPwfw4cMJwc1Ba/r0WdtaGFzNUq8P5cCfYFXs1JkmpL2MJwye4bVDSGldRjXEo4cIgX8gRekK+W8cVunDee40JRxg5pwtkZgSLg+b5lWRW0nIwQrODrt3VxM7wzlpXU+p12tku6gplVnLsu9IW9TTlDSMWHcmquSikSzB+bCiTQ7+cxSpQhdaWabiTxZmKPd6nLSqHuUJfR6sRSF39Xfn3IZiwKdFurqDwMVAZkwJ9P//4DsKkBkuVVroYKB6tJHwcoAKZMJOnS83NHxxFAjv0RZyvL4JBBaSJaJMJL70KAzS33srfnBbbKc2U8UrARYmQ+ZuRdAXkKwkXGNuZ/SNnt8LW7f/18paY4o4nbBRGvY/hdVbVAM7755b5M5NvfW7zUuvK+fc7k7cjs49V1u6O2J1yDT7KocK5xeWRTFED9Vfy/1BqtkWh6QgskQPYXTK0UHZyWeRxWmHZfrcQ/kNjfRT4R96Zpo5YXz6mjxM5kwBXH+t5ige6Z8dzYMAqRJj+ycXAN6wb/XCtk5MKJZdpkhLZlZPc6jTDEyPzE7KwdK+i9cDW3ow16UiXR/59PfYqwn5QRUu9upOAwf1HirOmoRwxxpCc9aTHwtyZkfTY1TNHrHUuXceDNr4AJqTI/z2xbA46l7qfKBIUe24j8qkftg+GyZOsIPS1GRGTrZKW8gEKl0w9rnyIMJFkQKHW4vvXBsTvcCkKBagXQ8X24DClxONI6Kibcc96pl8Cq5aITbJ4Sa1r7IM8lSE0tuaDDM2rubO/5ekvCH4cRkXCpNuauwEQRAFlTEmISzzL
 yOkYj5aM
 XJyr3/jd8f83PcVmPC64IvDocpTKvCKnnp87COeHbMQop8MhVhksTNeNm3Lz4n9W/ZYqjXEGgaqa3l5in/eIrLDq4plkS5lp33XjCE7nmbr7DT9hcAViGQNCyGCPpE0h+Pcf7CKbZP6Se1EpJxU0pET0bInmvku5iRk3S9IHq5sMOEggdDzn1YGQuqP3XNsT/2xljCyNxY5V4Is32hiLJ59bHIT5xDTAS3oVHuxkrCrZAmjBi96ssPg3hV1zAha36yM6v/HJ7xPKfUVyNx824KNAFvkvDr+QTxX5/hy7XwUcR0mvJYi+vTYHgznwAYkcZ0OoEKwB/HcVtUlknqmHqX5eAXTb7UMG8RAD0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 01:09:26PM +0200, David Hildenbrand (Arm) wrote:
> On 6/11/26 03:22, Ethan Nelson-Moore wrote:
> > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
> > refactored the header file include/linux/mm.h.  In that step, it introduced
> > a typo in an ifdef, referring to a non-existing config option
> > STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.
> > 
> > Commit 40a4af52e047 ("mm: fix CONFIG_STACK_GROWSUP typo in mm.h") fixed
> > this typo in the mm.h header file, but did not update the copy of the
> > code in tools/testing/vma/include/dup.h. Update this copy as well.
> > 
> > Commit message adapted from the above-referenced fix to mm.h.
> > 
> > Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> > Cc: stable@vger.kernel.org # 7.0+
> 
> This is in tools/testing/vma. Why does this require a stable tag?
> 
> What is the resulting problem (in the test!) that we even care about the Fixes: tag?

Yeah I doubt very much that stable users are running VMA userland tests on
parisc :))

> 
> If there is no user visible (test!) problem, then this is merely a cleanup, not
> a bugfix.

Yeah I think moreso this.

> 
> Change itself LGTM.
> 
> > Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> > ---
> >  tools/testing/vma/include/dup.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 9e0dfd3a85b0..adbc3179085d 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -243,7 +243,7 @@ enum {
> >  #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
> >  #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
> >  #define VM_STACK	INIT_VM_FLAG(STACK)
> > -#ifdef CONFIG_STACK_GROWS_UP
> > +#ifdef CONFIG_STACK_GROWSUP
> >  #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
> >  #else
> >  #define VM_STACK_EARLY	VM_NONE
> 
> 
> -- 
> Cheers,
> 
> David

Thanks, Lorenzo

