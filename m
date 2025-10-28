Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8D8CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959AB8013F; Tue, 28 Oct 2025 13:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A7B80199; Tue, 28 Oct 2025 13:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800228013F; Tue, 28 Oct 2025 13:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63F6A8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:40:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A3DE49778
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:40:58 +0000 (UTC)
X-FDA: 84048238596.17.4E81C5E
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1025E120005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:40:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=jiRWaWzb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVopLmZTDOEubg3fbqWRZo6mnJncBRlkh5KwLtpkxzw=;
	b=23skXPydIg7l/+qkTYN+CLTjxDu/ZyAGAz4ROo/Wbgy7MWE6vvxl7BwTjpq0PdHdQFe024
	C95L2cdcoNIK76sWBLu2+w6yjg/YKL8532ww5DNigQp6HMFPsyfP8f1BqPDRW4oBSa7h/U
	mu3JGWEOysE4IMn1Dw4AWzac4GVUtoY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=jiRWaWzb;
	dmarc=none;
	spf=none (imf29.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.214.181) smtp.mailfrom=osandov@osandov.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673256; a=rsa-sha256;
	cv=none;
	b=ACO34ZpW2N4hZciQXytPFUTGfgasoy6NZJjvUMZeymF3K6LLAtcgZbdI/nQP49xGHyvs0G
	Prxiha9MPLAUnSykNv5bw+DQyBRVcxR0C/Lkx9Oy8QjGUXFqWYwK7KyN9euxvejdEV0feA
	N3epxPGBcBpV4iZsoNcj3QwLUZM27GQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29245cb814cso13209585ad.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1761673255; x=1762278055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DVopLmZTDOEubg3fbqWRZo6mnJncBRlkh5KwLtpkxzw=;
        b=jiRWaWzbBhDtlLE+7HnuI1MUlEEYf+jtroaBy2QVUrH0/XQu4inVF063Q5R6YoA27T
         lg8vpzRZ3whiYKDgnOsP+OjDuvoO5CHqM78lwE9ZGUvar5Nk5OdihSmGFr3VCdNz5FhM
         MJb/ySJFLHsTyhtdl07riPtaQdmlS08SnMDmo02WtP3GMOFgh+7/ZzfZCmJE5mcpgf7/
         8sm385Px9ocoAEcjCxo1HLLoVmO2QnEBr5CwGc7AB0+mzOes6AOnu+8D71+v0Yxn8ABr
         gpR1cG3Nd4HZRaY9628wUkdf7IVhl1kCMVPKXuhjGIQpPOdpFhOziS+wX9g6/cCKi8M3
         UnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673255; x=1762278055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVopLmZTDOEubg3fbqWRZo6mnJncBRlkh5KwLtpkxzw=;
        b=fHg1quKb3Clz2PqetIt1ujFCClsLMgo8KHIl1r7rTJD439RZvBYuMG5JlyCECB1eLP
         l+DPbndIuPERrAN7+o3CpVzQaOMmMAm237L7jq+UscTU3AGBvbaE+PKEELVma1uQozZC
         g9w5hWQVIos12YWW62rBqvpJftmp++dOrklNyGH2kQxizlkAL9KjjJz6DOSO/j4mmjib
         qR2DdC9vfiUjGS4GOROyJnRXT/+vcqz9wW6FoFPVxVecydQz0Bj3ETELZVQC9/QaSim3
         bfrv00uXZa02Fk/Iq1jqvHewjR2vluCDU7zhOFxXKhioW8ei0cVYpxDKC28CZun016sR
         6uYg==
X-Forwarded-Encrypted: i=1; AJvYcCW5y0JKiXGceJXAJBtqc/66OTiIn8GfIzmocy1KDr9ksn2+O/YFQb2uK5RTTP5oQe09JF7dAbHX2Q==@kvack.org
X-Gm-Message-State: AOJu0Yw+ROcSivKgl1bpIp8fB7BtUGAh4yCl/r+E6AkF1NnJAANFkMUu
	et/pUhxAYFky+l62eJjvaLvFWHNxyRB4to44oEx//waxuokVsTmAAkbb8zE1v06HlEs=
X-Gm-Gg: ASbGncsMxTBLHt4Lxy3LM5rNP2q1TiOUswMuVkI5uCO/HVrM7I4eOwnYqLU7JIJ6dtQ
	rJu7puVSikmsavWL2pyvgHB1jRCTUIW/kxILdtAdlARS76cUUnKPrIZPNuKD1j9ePA0DpPviShF
	8yqmVC0+SV/9/yckp4QnD+CwyUpAhNRGSGfT9URrJ1B9Rj2VVhBgHcG1gLGoTkUWBG2B03EGHvj
	mz8mynsaWvZX/BHvmK32FZnE1zgPxTQ48KkX9DBceutPvTOiCBGsQEElnYOBM/BOzJJNwMN/1G8
	zlsM2uM6bwfqHxrdB2WGtpdwr3O3ogj85QSCn9ju/v7blSJqyB4LiMhL88juM01LTIuCW5gWFv4
	/RPjjIDUtKavJsxWBaz0mo0PW8JqzW6iFXi05RZkRV6J//XD7o1lFUSIkXw==
X-Google-Smtp-Source: AGHT+IGLnKJ6Jj69RQwIIMchu5h5MkeqjXzbXQh6dtkz5j1ePmwYZovsH4iKAXHndPBmmR4iy3RfBA==
X-Received: by 2002:a17:902:d2c1:b0:273:a653:bacf with SMTP id d9443c01a7336-294deb398f3mr295865ad.0.1761673254580;
        Tue, 28 Oct 2025 10:40:54 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:59c6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d274b6sm121931015ad.59.2025.10.28.10.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:40:54 -0700 (PDT)
Date: Tue, 28 Oct 2025 10:40:52 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
	Israel Batista <linux@israelbatista.dev.br>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <aQEAJHvO2bHvaEy1@telecaster>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
 <aQABhaMC8xfO2Vem@telecaster>
 <bdf568ce-0e60-4a63-8d67-8d272e05fab2@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdf568ce-0e60-4a63-8d67-8d272e05fab2@lucifer.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1025E120005
X-Rspamd-Server: rspam03
X-Stat-Signature: c5sa8xd1x5qk65r9sxszfefubqqpcqj9
X-HE-Tag: 1761673255-993458
X-HE-Meta: U2FsdGVkX1/XQjrReW/FwltNNyiGCxrfD7Pt938rXdVgBsjs7KIKsmUqUgOORgQyr/B2KaTQmpGz/VR/C6CjAuoadIDCXerwchXdlTNUyKp9+4Z1IttxT5kEfSvojW3w88DslD0h3x2GKDEhkrDwyMpHetjaKBLzE04m6Vmng0vuNh3UXrEp0ibb1BX1pE6jCzGP+F2CjcfDZC8MBAG0hoL+Jd/X1bBmWIR3ezRPVxSprivLbk3DjrC26EkylrlnQFhER6UXvHjkyRxI9PPZDlfTuJJA0zGQExAE+5t99BPPxxRKH6H0KMXaodmxidHsNoVzRAsoWcla1RSeESldyDTQPP4s2+jr7F2QU3ghW3zpye27FADvX2lQORo6ceXbrqmxvzFkEaopgQrQoFvRJdmG4rpv1s13DVnmHDmWKddf/zkjhxvF+c+L9vbv6/01anKM03x/a4BIJkcQJ2zW6DiNBq8/DUg+pdrFUyMEjVEgLpUOi8FRnl+ob5WorgGkywMXTmYV9SYnjkk3SFQYKV/VH6kB2M2XlBSL6f9b3vJlV5f5MZFKMQ/Q6xxSKfOPOjEATWCxcWAXg3L+oRDTw5najF2o40DJ4ZZ+mPHqOrqmsITo2WK3+3RmT1idW9VIRGcUBId+dGdSx+6H2BsUHQsF6UZtZKpfp2IF7Z/oZpkO8jl6IoRX+h+chJb77vxIUwQie3JJxOoyLl0AeZW0dvxZVMmvRFeCXzIOGxTKQLUX/GNsCRU84csqdM0usIWrrKf0PtxvAHStu11W1l+rk4PGQgwkLQtAgG94/dEu00T5VPJfFLUWGi+c6nlp09teBObW13sz0dMkkkoS9w6VyOZw5yD4gkzToO3KIXxbqsGJmzFK1Z/oN58K+YmfI5bt7H/e/XxHILpzZWkXSao6+fvjY0K7U9KphBgab/mOOVEvzh1WXhnzMzNOMdUvMOAOCsg4q5rLdUdiGc/Wkk8
 Lb//oSqD
 /3t9wwknxGbB0PCXuBhq4okfi0Wswq8YwgwdEEmcMVfzMe0V7M5JK1uzPZnLv7pLfugS41JnsczH+JNQDSeRBZnkUU6sxLzOr4o9uL5EuWVxPoNTcEG0LgEju1GKpkAWMRYgy3fMPhmoLa/ARtf4BpmLVp0soEiuALanRAhwX1yfipLGSGLqVJ/ywVYsao7knug4t1oQfdil4QBSVtdjRp9xD7JKgO4fSUcT+XUhLfJ+cFmDBMNLnTyJle4EYqcmXQt9kPTUj57OgGqe6oBj356dwOVXK0JHtiOBB8m2SQkknKlIIxMo1qg86m2xDkEF8d6rH136IDuRBTjduGxckw0HnUcaghnx0o6MG6pntzaMEfCweN/WbDdA7FXB36Ot5KNpC13bALNuKIsN0gt31j4Wc40y6RUZOLpLwXN30hw9SAqR268jZ/hz7G5lOfz2EHwbk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 04:33:39PM +0000, Lorenzo Stoakes wrote:
> On Mon, Oct 27, 2025 at 04:34:29PM -0700, Omar Sandoval wrote:
> > On Mon, Oct 27, 2025 at 07:46:43PM +0000, Lorenzo Stoakes wrote:
> > > On Mon, Oct 27, 2025 at 11:15:35AM -0700, Omar Sandoval wrote:
> > > > On Mon, Oct 27, 2025 at 10:29:15AM +0100, David Hildenbrand wrote:
> > > > > On 26.10.25 17:22, Israel Batista wrote:
> > > > > > The MEM_* constants indicating the state of the memory block are
> > > > > > currently defined as macros, meaning their definitions will be omitted
> > > > > > from the debuginfo on most kernel builds. This makes it harder for
> > > > > > debuggers to correctly map the block state at runtime, which can be
> > > > > > quite useful when analysing errors related to memory hot plugging and
> > > > > > unplugging with tools such as drgn and eBPF.
> > > > > >
> > > > > > Converting the constants to an enum will ensure the correct information
> > > > > > is emitted by the compiler and available for the debugger, without needing
> > > > > > to hard-code them into the debugger and track their changes.
> > > > > >
> > > > > > Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> > > > > > ---
> > > > > >   include/linux/memory.h | 16 +++++++++-------
> > > > > >   1 file changed, 9 insertions(+), 7 deletions(-)
> > > > > >
> > > > > > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > > > > > index ba1515160894..8feba3bfcd18 100644
> > > > > > --- a/include/linux/memory.h
> > > > > > +++ b/include/linux/memory.h
> > > > > > @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
> > > > > >   unsigned long memory_block_size_bytes(void);
> > > > > >   int set_memory_block_size_order(unsigned int order);
> > > > > > -/* These states are exposed to userspace as text strings in sysfs */
> > > > > > -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> > > > > > -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
> > > > > > -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
> > > > > > -#define	MEM_GOING_ONLINE	(1<<3)
> > > > > > -#define	MEM_CANCEL_ONLINE	(1<<4)
> > > > > > -#define	MEM_CANCEL_OFFLINE	(1<<5)
> > > > > > +enum mem_states {
> > >
> > > Why are we naming a type we never use...
> >
> > As David suggested, naming it means that we can then use it in a way
> > that enables compiler warnings and documents the code better.
> 
> Which compiler warnings?

I was referring to a situation that David suggested where:

1. enum memory_block_state contains distinct values, not flags, and
2. We convert struct memory_block->state to enum memory_block_state.

Then, everywhere that does switch (memory_block->state) would get
warnings for forgotten cases. Maybe desirable, maybe not, but those are
the warnings I was referring to.

> enum foo {
> 	X = 1UL << 40,
> };
> 
> static void blah(enum foo foo)
> {
> }
> 
> ...
> blah(3);
> 
> Doesn't generate any.
> 
> Nor does W=1 or W=2.
> 
> Nor with clang, etiher.
> 
> The better solution is to do something like __bitwise with sparse.
> 
> Also re: type, I'm not sure it is all that safe, or you certainly lose
> control somewhat as the size of the integer you're passing around is
> 'whatever fits the values'. Technically it should be restricted to a signed
> integer (e.g. 32 bit) for C11 but I think gnu c11 is using some compiler
> extension stuff to just make it adapt it to the correct sizing.
> 
> Anyway, this is all probably moot as I believe David suggested these
> _aren't used as flags_.
> 
> In which case I'm fine with it.
> 
> I'm just confused as to why we're still debating the flag stuff?

Right, it's irrelevant in this case. I mainly wanted to know for the
future what MM's preference was for cases that really do need flags. My
bad for not making that clear. It sounds like the answer is a __bitwise
typedef with bit numbers in an anonymous enum, which is fine with me.

[snipping the rest as my question has been answered]

Thanks,
Omar

