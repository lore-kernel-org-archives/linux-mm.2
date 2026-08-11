Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7B0C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD73D6B009F; Tue, 11 Aug 2026 13:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE1B6B00AB; Tue, 11 Aug 2026 13:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D6E6B00AC; Tue, 11 Aug 2026 13:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC696B009F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:26:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 267E3120131
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:26:32 +0000 (UTC)
X-FDA: 85089667824.27.D2148AC
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1D3ABA0017
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:26:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="lE/OZ96Z";
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786469190;
	b=eNqPRo1lVV1T8jtwVl/hmRFAIVYkV4fIimy9zvZ99ae2wWwwzeWRdy+YZZSaqN3F1GbTj7
	icZfq+JQmlawrzAG5gAvBm8u9g+wfMHmizWr/O3M8rnXxhCsNrNpcXdDCxBXp0VoJmq6WU
	C3tPG6eY3nIHQch4nPUpxKP2NUDWbqw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="lE/OZ96Z";
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786469190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9Qh79QFCvjYnoGtVduyp1NZZfqwn8kEM0DsabkDFtg=;
	b=AqsEy6fKa9W/4RaQWg8QrgQHxYMw0xYQZrLEI9C24u69QNiTP2t98vB2ODEBz/RvbHmiKt
	c+ls8uH2T8e0wRGbJ45fF1LgwZKsVW2ib9TbAAAuRHMa4+BaeZ5X+BnVU9Q3G3WCftv3bK
	F/sgLa+M0Wqhck5lx/xUfyBTgMyRsPw=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8edda5d56a5so560706d6.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786469189; x=1787073989; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T9Qh79QFCvjYnoGtVduyp1NZZfqwn8kEM0DsabkDFtg=;
        b=lE/OZ96Z1gFPkiWY4q5rlqrFxvy1xCw20aknFsnBFvApYQ2Ly55rMC/15q8ZOuEKY1
         gDsPOCWBkReh2F3UeUp0gYfCJXH2ioKjUEtlsFaEg3jA/sOj4I7Xu/ywjM38LyvJxdkh
         axitzMQmNyEvSUiq1V3rB9e6iC8a6RvtmMGZegCi/KZPrtdcuD73DFm9fDpUT05yqo/N
         N96Qkt6esKz8R9c+4Diwser0v/VCVKkmJ4ekJq/Z3qK+QNbaUf4/ggzSD/5qCuJW9Qbl
         JcNpq8R1VYDT/VX0w7OMvYPpb/BodODLT6JsYQhdzBSWtTbh7t5anRc/HwV+hD5yp8m7
         A8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786469189; x=1787073989;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9Qh79QFCvjYnoGtVduyp1NZZfqwn8kEM0DsabkDFtg=;
        b=RfsIOs1WhJCjMggZj7Jk4sh1fXhJnAvu9t+2KGPGdDr6IjsXuN4wqPp/6tlx1ajuSI
         xTpGIifww0zlw/lv1eva+PszrJViavAqQ2LEieVuCGcWsuKdahQSdCXFEzO8VHeP39eJ
         FQYomI/9khbp07mrifbloZr7rexstk/Gah9+y6Y6qRxW+0V9RYg/7FONARjX1/3Q9Afq
         6mOBSeZ3IyyoKTvtox/OgEMy4CFbwgezs01rURTi1tJjEEpF6VLNNroOl6r9hz2lAywg
         IySZto18hBqHUUOgwb//LGBfhSJ1jGN/q33P574hfsSaGBYk8pQQWtlI/5xs+0ag8jHz
         CQ5Q==
X-Forwarded-Encrypted: i=1; AHgh+RogDrJj1YbsbL86YOYbh1kuMzmqIDxh6xlEAnooKDn1ifm2ag+odbvXhea5pTT9TKYgX561P8LiPQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+XdMfSPGgS1Q/C5cF7e66FoqnMUvU4YAvhhcnm6J+kIIBeM38
	7Oi/ZxjK7qKx82Sg/fUmTli329GitM06rEO9c736ozhOc71qCdhQ1KgYnNs/0JLkAd8=
X-Gm-Gg: AR+sD13vWfvucaW+//h5pJWlqOT8FBfMnrYUg6mgC7OELNMwoWhwi85reoJQcHKHvty
	OPUtZdn3PNfN1yo0LHplQFEqCXnFCr4OgfF+0/Aid8biExVvVFei1It567e0syPwGLlnH4Mbhbg
	TBT1artvQoBs4SXxxpL4QcKnOaHr75/H7msBIIHV7qilHsSMZD1crIzVSOXSW/bHeQXzt2lcHwU
	f4AX9N51A/ohygePDxSFmczfpmEZcn9S/sQb9dbf5BaymDIcypLMTHEhJ9p7XBUiK6jg0VGXl5a
	jj1JCm1+9XVBJg7JyVo786ujeqgqP+VA6f/IXJOH5x5g/iiqyu9msbuGCszwPTEvFIMm559QRvi
	pTUK1h7w6J4VjZjAzZm2A0r7UMdC+ELeRCLFH07Rb/EXgMssincL/yJw7E7FYFEzBMrj5klrSor
	438qu8j6YKH9vDyqxOP/x78yvBJw0QCFCusmqqwA==
X-Received: by 2002:ad4:576a:0:b0:907:d9bd:2f8f with SMTP id 6a1803df08f44-90a6694b0d3mr50111416d6.6.1786469189079;
        Tue, 11 Aug 2026 10:26:29 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3c8af4sm3611196d6.39.2026.08.11.10.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 10:26:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtqF9-00000002gAk-2Giq;
	Tue, 11 Aug 2026 14:26:27 -0300
Date: Tue, 11 Aug 2026 14:26:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com,
	rostedt@goodmis.org, bigeasy@linutronix.de, simona.vetter@ffwll.ch,
	jglisse@redhat.com, christian.koenig@amd.com, paulmck@kernel.org,
	seanjc@google.com, pbonzini@redhat.com, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811172627.GN544626@ziepe.ca>
References: <20260811162423.GL544626@ziepe.ca>
 <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
X-Rspamd-Queue-Id: 1D3ABA0017
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yq5mc5y3a8zuni68q8czwfpfx1xqaw4p
X-HE-Tag: 1786469189-290914
X-HE-Meta: U2FsdGVkX1/OsUGx428xAwvjj9FSWJ9x36UglVn63Pgn2rNK3niznCKF0LvYQDRoarqmAMGO0CW7TvHD/1n8PjpsrIw6u7VhfmjNk7ABNcgxDUHXyhU7Owdt8lOMA8TygtWO8aL6VqbgmetnTfx3fJ0H4W2qhUvqdj2hJXOyWQrd4EvvRk61hzZ3leuMpuL44/BwXY2gUeba8mBVk816DEjv0Ya6CrQqcevBUmXwbQi5cY2O3hSkWcGYyf1Z8rScipkQNPVzNM+BEedCeIU5smNevXdRtw/VJ30318IsGBpt28t8RCLzbIGVSW+5P7nBa3sVMouuTTf4aRLWQT9IUdbvt50dkedGSpb5xCL01wlDcACOCvP51X9eXfUq7H4cQLvDHiH2uOmROJDn6CyLgQzFq+lyL67hByjxqxmiNmgY88wJftemBuF3eYudHD2b96UC+357v0djbcfGnd1JAECeYKA0pd1YqRZAkmiDdzAcY4w0UQD05ZC8jkxTzyXF6Cx8dLifXuHRJ8jWAXSzt5pNAFr1y+LsGGfuqeWJmW1N++hZHbPJho6RXdSpF7rBbzdKrR3JEOhiuZRTIcpXrVFzrVmdaSZzVs18erIxw/CPM96xSv6mhVc+U8jzPwy+Xwahex062S+Dd17OYH2WXCEYjhGDBCL/FId9LYKlj4p6SJbTyWn1i60AzDc5e2jP7GwpuDrjj8kETme3it0DP/bPML7txJSks9K26fHjHhhS71bAU4MdAte+sVHmTlfDsRXmBReCQViqm4KiBzO+4MjX3d6tHq3Wof4LIPPnrgTDEF3EYn3L98mYlykkFzLjLLbOFXNrqVnlKQBsttLW1cbkfFp3DWyn5mgghpneApeOPb/+S8dQC4D6Xcf/N4qASMqBhDHlWs443qK+Ew2bNNQhGOko6iO0GvccwTGVQjrkFMJqNuZYdAj8N38atlGoOjz7r9AxxBuMUNS7fRG
 8iR6NoJM
 i0m+SZFm4ULvv2bAa5VmT/eHktS5CAwtTW1rIAjHIW59Tbo7gdXFusPKLkL4Jb6x3ndIDaurRIpLyg+XC1FCh45hwravW02T3tcOcgOqAb2r8RW/tMNzELPmGkZUKUviRSvCyTNghzd5HC22v5ynQAbU39WqJVQQq27kktguP62Xvmtp3a+Wvql+l0DfEsaOGCFxdFW+98dTBig/rTw91vJ+CI0gSe5rELMaWiRs0qw3TeaYDjWz9OiBBU0AqPLdvbLMi2R+m0RhQ0AX9W0jovTs64tIY5NRdhIssaia8/h7Et9o9f8ocr7C1lUCfGLVqt4B0UofG2ukuRIg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:22:12PM +0100, David Woodhouse wrote:
> On Tue, 2026-08-11 at 13:24 -0300, Jason Gunthorpe wrote:
> > To be clear you should not be using any synchronize_[s]rcu() primitive
> > inside the invalidation callbacks. These are well known to have
> > multi-second delays on loaded systems which are a completely
> > inappropriate performance characteristic for these mm callbacks.
> > 
> > This statement has nothing to do with deadlock.
> > 
> > RCU is always a trade off, you can make the read side run really fast
> > and the write side is ghastly slow. If you can't handle the slow write
> > you shouldn't use RCU techniques.
> 
> The multi-second horror stories are about the *global* RCU/SRCU
> domains, where the grace period has to wait out arbitrary readers all
> over the kernel.
> 
> This is not that. It is a dedicated srcu_struct, private to one VM,
> and its entire reader population is a handful of KVM fast paths that
> until now were under irqsave rwlocks.

Are you sure? I've never heard that srcu has those kinds of properties.

If its so fast you should just propose a non-sleeping version and
leave the notifiers out of it

Jason

