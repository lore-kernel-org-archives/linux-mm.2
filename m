Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E5A9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D33A6B0088; Wed,  8 Jul 2026 13:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA186B008C; Wed,  8 Jul 2026 13:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0BC6B0092; Wed,  8 Jul 2026 13:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06AE06B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:05:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72297120244
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:05:29 +0000 (UTC)
X-FDA: 84966235578.14.D9BBB39
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9ED7A20003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:05:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bu+wXbpF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783530327;
	b=u+ggYsfj1rQolQB4QEqNYp+FBV06artMAi3rQ8glbHihu30rGRT74GLeba+0cBM5EnHdQM
	eHliSp6TXVaKkTIeUP4wjBj84mZ1k818KFstDIcEzJ+duEvKS7Y/zkfWav6IRxcT8dizRd
	IOU9MKxc0ttbkXD0VbupFK3Dbuz11Jc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bu+wXbpF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783530327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMed8Aal2XzeNAdRp76BDF3jCpjJx/NH7JDMMBYScHA=;
	b=rNwgp4Pf2RvH8GOv9L3mlL0IAMKw9+VTlgT0fcRdhVfrrKs7HOJ+Fzm+rqB7YsKQkgM2bK
	x63VKEXBI+UOT0h/wkZihiYXySCX9Xs6tRAa0Cxao7FJyb82RH5YKVcNxKIfuaZDonPLVA
	emukwUSP8Qogme8fxWgL9rJ09ra3Et4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ccdf36f63dso3365ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783530326; x=1784135126; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HMed8Aal2XzeNAdRp76BDF3jCpjJx/NH7JDMMBYScHA=;
        b=bu+wXbpF1rGNxHeTItk3s1ARZFT6lO7BeE3rIP9bIVnA3ED3aOVWtKj9/sBgGranI/
         dfHV5zbTTdjxS13dHpNpHAwkuy3mv7ccZTr21LcTqht7pY5Yn0jLnX4sDxK2WsrrHPWg
         3uOT9HWq6pD4BsBXNJu5l2fs/Hm6WRwxdh44fSUyVE7j9wTGfqYpPdKWKf9zBtIwqihG
         VgrNd28ucji1RvS76w5PR3yDdIjFE3RiLilwFRqpzH3+R8Qc37wacSZu+KP5B7mm7bgI
         hakAJISWhC69nNhX+/H3cvvBI0cKRz2+eknVgY1AWgfdGMFpgh2IWVZ6NoYtIGDS0Abh
         bINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783530326; x=1784135126;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HMed8Aal2XzeNAdRp76BDF3jCpjJx/NH7JDMMBYScHA=;
        b=m+1jCykIB/iH3Cg1CtUYI9lEQD89JoV4EHenam4yIQV6X0v3H1IAWFN8S9KDyhtOyN
         fbSNaPxVlQl+YX/WHfG7OF1+LBDzpjuebvs5GIQAmR4dBxTUt0Rs2WhGWGgEzoOwG9pm
         ZO5WDGdSBPJK5qNIIyRsPwOeKHwlPCDjof5ZFOHjZdJjGrJ1ojO8tJmhqT4aNX/MvCJd
         mgCxwDEipJDcyEIcQUQanoKUto2GwK7C38gevWFawn2MGWzD1dzg91UFYOI5o/idCoYb
         1IlCVRNAxD2TZ2FsfjLTgoRL9T25GDaBszVOpAsBg1OcIXH7vBpjZNStRX4MpkGI7/GC
         rzIQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro4CFG/Bx+ZJYRiQyQtfcrMtkRfFUghIFUPRImWKNuJLgG+lFWwcRCn1b5jAQyuAzINz1w3i0yffA==@kvack.org
X-Gm-Message-State: AOJu0YwQ7KiSoYyPz2PhjWLifp/0L5iJJz5qLLQnNd54k/adsCwHtfrp
	rFjdlPsmrh1hDgGBleaFyV1qCZfZaPVHNl48n4M/iryQSkJLseDVxJd0ac4hNSaF9Q==
X-Gm-Gg: AfdE7clPxG828AsYBTeNV3t2gu/oGMjdxZJ0fM5cl+i7fkRpl/B0HnFejbFRV0OgHV+
	zhPH25bX45nRKwEPA5f2eVESI2FGHLAGOFiltohmNrAqsAcSRK+ppYHPrHDGKZ1vOae80KDtYsa
	VECeXy6lWHYSdYJrYwZpxJG6rcn540BctUijkN4IJDbKqa/Bd4mlZFTId1zGLJ51llBJBCn+/Cs
	Asw4tnjLvYx6JPyiAJx7V6hZRBZxkR9mlculA4E9FONCm4T2ht+WKhU51dA2KkDrAEddK8aghUD
	amyBq/cZWtgcEIITMfez97p5bQtbjclCiph4kHsTXvf/oJdC2KCGrxGhDSxO6aUHwBfIjYZX41t
	aqf0zCNGsWNshlhWnXruUSnqdR+n5Q1MSy0cLIMmSSY/tikNOVt+tFeN7ydP6HOKhNZsCT6LHq5
	qobIV1ntJdnsWsmaPCtMXdfAmQbcZFLSe67C7vz3opEw3TxR3M3x0Hkvu9CA==
X-Received: by 2002:a17:903:22c5:b0:2ca:be81:b469 with SMTP id d9443c01a7336-2ccff679a46mr339855ad.0.1783530325931;
        Wed, 08 Jul 2026 10:05:25 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d5bdddsm30623695ad.77.2026.07.08.10.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:05:25 -0700 (PDT)
Date: Wed, 8 Jul 2026 17:05:20 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak6DUC7NsIZ20RZD@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
 <ak57VeunO8qd4wEh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak57VeunO8qd4wEh@google.com>
X-Rspamd-Queue-Id: 9ED7A20003
X-Rspam-User: 
X-Stat-Signature: md4477e8ohysnrdba87ioyxehnuwspc9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783530327-990132
X-HE-Meta: U2FsdGVkX19Avf3060pVcCHkdQthrN3KpA91UkLfcFmUXPE20pd1zmXS26hJ4VAMRbkuXBTktjo7J1XQtISMqnpLBZeh4yA2caKYHs1w7nLAzc6MAWGB8I/dMbGHiNN9SD/QXtEsQj30js/T7J246CVW49H4+a3jAi81VSB0lFTNYFkutYJdqNLUZ65eKxE9r3tusAMtV0WSX8MCvcOJxKv5EcgZxj1s8oYOCWrAz9v7ytfR0hJhPbnUE7DE7CFm8haAE23oKTqLBYLAklsGnmJUuBLFTky/tzqiSx73HEbxYEB8qfoUXMovgv3wGl7LmsHAy840S7X4+6ZS5AmArsa6vXt0hxRis23p3ffS1D/7DXE/bD6l6lsc6E3guWuuvsxDVq+ZbjTvrBuqjxYLaRw4ioeoof/o3UmoD3UeTbZplCGJytlmfYzrEY0SehLJ6Qp7JDofdQEDi5VOOedY4pKRXBBH3d5GtEjL8fmkXpz6wwJ08ZkIp1A9MyHSM1Yc6mS+un47pwueOsqLhCm+wuApiu7jagyL2dabQ9GSZWCoYjqdx3P0rS5cpdj+gMmTFWrO9kgPyAp7KWYemOO/swqwrvNzmHe44sCl3F3UStm5cOuES2hPGcSUFIjRWgxjEHuZytWTYpcAmhqdVSbnU6BneaI5nWptGGvnnaFI3nmAFIhUpzcdwNhlyTjB94/nzjVmhEf73o2jpXhzbhEt/PwbglbN7fox7/k4mfNXybs0NrWNj87glDObGVY8QdyG0Vp+BwtYMS2Mk/AVSFebii0ZMF9Hc0wAKEOUz1goMe/8s4DknJLkFLEOIuYSeEhNq2FRhDgrRDV3zgXc48l/1CTzV7+qGzFe9jUKG6D+hhcK+BwzdObrxgbjR58UFwF5XrVB2EehkYPLdpeEej+r9d4f+tDMD7ZxgL4+R5odMNKYkaTcQaqkzrUEUor4a4G/Z7CW5S4QWgDMqfGOeqc
 mcqbYCL+
 LyeAFC4btZm12VNRQRqK1YioRl4QootVnu5Z/r/EwZqCsr9uyLHVXYhlX3lzMXwYbJK0lbfgyFr49h3sOtdumZwhALo5Ff+dgPx7BkJPitP9rPx+berhTQ/1A3wuJgWhyX0drXOhM1NFzuaJh4gMg8feQ+ovz7t2b1O3Ttw7vRE4asMjVtBwuVQWbrH1G+CtEUcB9Oqc2hpxOpBOJJhuv96RQBUKNhKzhdXamg9cBCGh1ptU2w/9BcFu+ZeLKp+BBhz1+LAS0XmA+OObzJa5tetBUdXusSXp9YkTYTpsMWmKN7dAMzkfr/gNOz6ugyIynRo+xpykZz1XH4R7tU7r52yIxdxvHvsREotIWQVPGWzb0Npg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 04:36:46PM +0000, Samiullah Khawaja wrote:
> On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
> > On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
> > 
> 
> [snip]
> > > 
> > > 3. kho_restore_page() applies the correct refcount pattern based on the
> > >    preserved metadata.
> > 
> > Why do you need to save the type of pages in KHO metadata? For example,
> > for pages or folios, we don't store any type information and leave it to
> > the caller choose the right API. So reserve-mem and kho vmalloc need
> > pages, they can call kho_{preserve,restore}_pages(), and memfd needs
> > folios so it can call kho_{preserve,restore}_folio(). The radix tree
> > itself does not hold the information. The caller knows what its memory
> > is supposed to be so it calls the right restore API.
> > 
> > So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
> > name; we can argue about the naming later)? Then your driver knows it is
> > restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
> > takes care of initializing the pages with the right refcounts.
> > 
> > You won't have to muck about with the ABI in that case.
> 
> +1
> 
> I think this makes sense. The mm already relies on the allocator to
> track the type of pages it has and expectes it to use free_pages or
> put_page() or free_page(), so it is natural for KHO to rely on the
> caller to call the right restore API.
> 
> Lets add kho_preserve/restore_page_contig|_order|_nonsplit and the dma
> preservation can use the appropriate one during restore.

Ack. I like kho_restore_contig, I don't think we'll need a preserve for
this though? Preserve doesn't seem to be preserving refcounts, I guess
we could rely on kho_preserve_pages and the caller can use
kho_restore_pages_contig() to set refcount correctly for unsplit pages?

Thanks
Praan

