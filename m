Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78EE6EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870116B00B1; Tue, 10 Mar 2026 10:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851C76B00B2; Tue, 10 Mar 2026 10:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726B76B00B3; Tue, 10 Mar 2026 10:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 652036B00B1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:52:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2001AB652B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:52:37 +0000 (UTC)
X-FDA: 84530444754.10.35E1818
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3EC091A001A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:52:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gyg37Q+h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ml1c+QBVKH1G4D7WQDxLbH41bxeuoQxcf06ZreXxasU=;
	b=C6P3rzFdTD3RkirrHGOZTnTdplQZ/UicQ89BASQFq2cyKo/DxHX/aOQparYBR6nnenO2CG
	35fksOVQQQLZ/g+VY7o7mHTYeq6fEkjfR1Wjd48ad/GT/pnEvkKwJLOzZfKW+oflfu+OFh
	mylO5QBtSoW/jU0y7Or2+Ds+pf0npSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154355; a=rsa-sha256;
	cv=none;
	b=pefV1HtOBfjMy0axEnVCWxfflRQyrsyab+cVqLfOXxyFQn0Pl/kS6h49z31q28PyRGXote
	FqApboLzvUv3AuH8prFWdeakyt2lPKdJnIwXZytm6nYKBJWihEu9SGIgpb/txNeZZbSJ7p
	ABBnHrqoA3hXIIw4d82VwACH3Lq/VDU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gyg37Q+h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4852f73d0a3so27943635e9.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773154353; x=1773759153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ml1c+QBVKH1G4D7WQDxLbH41bxeuoQxcf06ZreXxasU=;
        b=Gyg37Q+h2aKdstGfueqYQWeOxNBCYQrjWaASWBnR5jMx/NnNmROs7A+Mxx9lUvlPqN
         fuKglZxnNHOXLvHFmA1gsUOMri1HvZKReQUKl5gROJ98xQaLjqpDyvLO72pdopPIuLiv
         WMrj6L0xKSjK50IiWTudWMgGZ6C209OZ1vLQyv8Qa2KOxtM949vvDeGqDK+MuE2YGrwZ
         3Cc9obkIjSFv60rr+lG3vNSY8PBMSLXIPGj95B1/bLaMHmgi+dyQD4Ue2t0ZAiOstJt5
         EX0Bg3J1vAX7GK3TYUoJqLKR/doniLriIr/FFvLKF0mpDVrSbGEci99mNLoRqQCOOCGj
         TYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773154353; x=1773759153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ml1c+QBVKH1G4D7WQDxLbH41bxeuoQxcf06ZreXxasU=;
        b=Q/R9x4jxQis9QElEwfdz2CJnC6SDIjma/wBHh0Mr8PzU5OKwXf4J20N0PFKe+kbEc2
         np/AqPVFE0L4DIxy7T/3JbX5v8iyIVz/QbLCTYTW4ASqshhi1GNxe5SUVXfsYZgzaush
         f1eUDnWAf6AZv99p4msCsm65MZ4yihx/6on8CyJcXgTQfnJGlGCpWONgAShWMLTa6ijS
         H2eUK8gxxQQn/5FtG/0lT8qJNs6zxFrkzaBsZV6+L7fH4LKHRTK9pvXfecZknDNRLyXr
         emEcMTcOARxB7KOCuUsahJ6p9BMZfGagJjbMiQNPphpcxGTgIi/njJ/GjjWVfO9h/1Qz
         A1OQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj9ev6CODrO8rEUYoSXjxfCrfbWysLwtDggK5E2EZxw0dC70Msp6QRalCfcpK+B4Z4+YVQS1AeUw==@kvack.org
X-Gm-Message-State: AOJu0YzKy2Cso6KLau4DygF0wvJXEWsN7cr2U1jC1+klG10kVLxm+DP9
	RvPVjmYLOk6eD7g6CrdqkBLInAByNY4k5+AffvYa2GIlKpvBq3dReg9c
X-Gm-Gg: ATEYQzzHXmaZZUcKz3IXMLzbd+WXKASnzE7FzWTRNQa0kEBv+eyvH9i/Ug7Adlaflwt
	r1QC80U5FjNB0dgn9KFxVyuh/OeT3OcdV+P06gVN8dkcazEFheOpYIuBvOToLSkwwnXVc5HFtM1
	gARZyaGWdwmf9XleTsZ78IKnMMxDN5bxI1OZpF8YRsnY2nqfcbuSNvb25vHdr1ZNPsqRYKGn/Hg
	vCcT09i7tsg44ueIT70tLjOL847hYtYx5qwRpMnR5y3NGTWtBV6KRQgxkDxdnyjNM/vgNEgdsy+
	docqvUVDw3OocAz4FOxkua6iLeO/5yXDFtpeo+1AEQI863Rewq7jTC+r2efdP3kZ1FedXNm/8z1
	VPxA8LJ6vXJK9+bAqxQnbQO0AlFzXDg6WVBl3FnhvBoC3eR4ockp2YKzdE11X/hAuVToDDmGZkX
	PCXXWW6iYe/tQ4oVWr48W71CsNZK71i6DKIyl2ZLUIFB/hhk+dR+fS1td/zw63iRIr
X-Received: by 2002:a05:600c:8b5b:b0:480:4ae2:def1 with SMTP id 5b1f17b1804b1-485269305e5mr250455895e9.13.1773154353218;
        Tue, 10 Mar 2026 07:52:33 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dada3b43sm37635135f8f.13.2026.03.10.07.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 07:52:32 -0700 (PDT)
Date: Tue, 10 Mar 2026 14:52:31 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Xie Yuanbin <qq570070308@gmail.com>, willy@infradead.org,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
 justinstitt@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, llvm@lists.linux.dev, mhocko@suse.com, morbo@google.com,
 nathan@kernel.org, nick.desaulniers+lkml@gmail.com, rppt@kernel.org,
 surenb@google.com
Subject: Re: [PATCH] mm: optimize the implementation of WARN_ON_ONCE_GFP()
Message-ID: <20260310145231.1680db9b@pumpkin>
In-Reply-To: <be647d6b-9bcb-41c8-bfcf-7fa03d2b942f@kernel.org>
References: <aa7p3eQfEuh2wObQ@casper.infradead.org>
	<20260309155933.41179-1-qq570070308@gmail.com>
	<be647d6b-9bcb-41c8-bfcf-7fa03d2b942f@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EC091A001A
X-Stat-Signature: apezxjjcbt87u3i71t1ph18hgbeux6ze
X-Rspam-User: 
X-HE-Tag: 1773154355-627092
X-HE-Meta: U2FsdGVkX18YZsjlzKGPme1dPj09lLdIg5VuGVieNTJNREKzScZzOErcy2kXI7u+8LZpXLGgx2R6429bDuqpTn2TtIuzQXNkt7/C6XpzL5VEjPa4+hLsjYQOfQY/BZ5rm64ogoY7fnFZHV9a3Jv0CdBV/nP0+XY9tscXIStgAwVKOs0GfSj4XP1dnkQyogBHUC2JCjYVGIw2eFAqd5TH15uziK5Wars/C49Vo2soz3mrO9eEmOx1xLhEYVVPyHNNpUwIjo+QWVOXgx8lPPxEgNR/QTNwd9lDtTpfL72hqXlG6PtG1UsXq7ES464oGUZMK/bYuzVrx8I472JyPT32AZZTlPryF4nJSsDzKXZBSKfnEJ22KsH4xsdUSE2l3ne8r3yi/kI+JI9OFywT12TRLaneUdcC0Jo7Y5R+OeSA1wG8pQYZnfpsSGzeP6yOoT5woOGT4JSIgx37xCGsTrSldmBh2z3vS/buoARG888Ny4Fw7ax8WfurH+lOLQbwJN3Ba6MiX1lzNeR84uBkkb+msNUIvX1oEGhLMbWN+/fVxK2fHXwX4MS/iPI6eJY3YQgeMjOjCGr43cLey5HkJYfS1mVPlv35/cp8h5bUFDIXPJ95QjKDjI1xcnA6srLhh8YRtM6fyDztS8cqpkarIjNtOxkrjQnfjPgLk374pHHhcbl4TEa0NLMJFewITbQgh1+BSEainFPmNECa//aAWnWHbCN+gR1O0+aXXbZGHSqriN8fdtpCc4CQseuVqxAEiMyaar/ELw3Mnea5I49DfRCqMfJi33hvDYBjJ73n6piEBzW/XbNJhOGCBtlc+z7qFHQu55hkMz3/afqSr++JOmQDDXcamZK0fAypRSm9yepaLQq6pdOG083z6tk2a46NXb1HIlFr7WLyBmr76Z6ARULGqK0fIN5pY/e2ACvAwSo75O1Kt78V/LC0G5FrqqwAik60NPUewbfLQSPkSUznTp3
 RHIj/t3V
 ChDs1S3KzMc0+RYDoqQD8b3Yjol6Vl0owydiIni9xCjNjIuf10hg2z/jr6STwM04FrrrOUkPRyTl6IpkX0k5yNrIslHtA/4ZY241s9jX9Tdl03NHVYaxMfADOOrUCn+T5+MLy3f1VB37OM3B5xzHejvv/dvMKLx7GEdkw+e8vy6CBmJFsm4aEdrqGoIlDM1LppaMN2AFrjsChNJCIUkQoVLjJe50KFYy/NwtPrBRRMxDSqGhPXgoh0uJt1/hOfBiJExLEgEpUhKWhckmsvunkhcFTMg7eJAVqEVvpBVN2g+Ibzn9rNPfDHQ3BRyj59+j/EkyQovuDusQ0IoOtcgjIBe56kRGrWjJvmueJVisdNSs4pp2QoBtiSiLqwbc/S8sHf8FYpFMZuGOJpwOPU6jYyFif94jyJwYpDJEPQ775Sz6k3YYSV7NsgTg7d/NFFXiVmG+AULyY5/DlVkAetX0YndHkV02J1KMn+rA87++dkhAV2HDAHPynsjWsCvtP0s594ChYpgOT9i2zQLp/8XG7egETGkwLjOiAsR9dJVUFuMLKseLMQQ4vm0ixOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 11:55:55 +0100
"Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 3/9/26 16:59, Xie Yuanbin wrote:
> > On Mon, 9 Mar 2026 15:40:13 +0000, Matthew Wilcox wrote:  
> >>On Mon, Mar 09, 2026 at 11:38:11PM +0800, Xie Yuanbin wrote:  
> >>> As shown in the commit message of commit 242b872239f6a7deacbc
> >>> ("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
> >>> the code "unlikely(a && b)" may generate poor assembly code if it is
> >>> actually "unlikely(a) && unlikely(b)" or "unlikely(a) && b".  
> >>
> >> Why fix this in multiple places in the kernel instead of once in clang?  
> > 
> > If a and b is both unlikely, then "unlikely(a) && unlikely(b)" will
> > generate better code than "unlikely(a && b)". This is also true for gcc.  
> 
> What are the details of how it's better for gcc?

I'm not sure about that specific case, but I've definitely seen gcc
generate sub-optimal code for some un/likely() of compound expressions.
The underlying cause is that the code is (probably) first transformed to:
	bool tmp = expression;
	if (unlikely(tmp)) ...
this means that you lose some of the short-circuiting that happens
early in the code generation of 'if (expression)'.

It is also not at all clear what you want the compiler to generate.
For 'unlikely(a || b)' you want 'if (a) goto x; if (b) goto x' so that
the 'likely' path is the no-branch one.
But for 'unlikely(a && b)' you still want 'if (a) goto x; y:' which means
that the 'b' test is out-of-line and has to be 'x: if (!b) goto y' to
avoid a branch when a is false - but that means you have a 'normally
taken' branch after the test of b.
That pretty much means the compiler has to decide which unlikely()
to ignore.
So it only makes sense to do 'if (unlikely(a) && b)'.
Indeed even 'if (unlikely(a) && likely(b))' may be better!

	David

> 
> > As for the issue of clang judging twice, I have already submitted it to
> > clang:
> > Link: https://github.com/llvm/llvm-project/issues/167117
> > However, even if clang fixes it, this optimization will not be merged
> > back to the old version of clang.  
> 
> That's life and not worth complicating the kernel code for. This is not
> about making it functional, only about perf.
> 


