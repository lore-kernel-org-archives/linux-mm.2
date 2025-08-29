Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C29CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C68A8E0002; Fri, 29 Aug 2025 18:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E558E0001; Fri, 29 Aug 2025 18:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF64E8E0002; Fri, 29 Aug 2025 18:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1B0E8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:45:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B18A13A8CD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:45:23 +0000 (UTC)
X-FDA: 83831277726.27.A2A76F5
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8401420007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:45:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c6QiVd65;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756507521; a=rsa-sha256;
	cv=none;
	b=dp71LxA6AUH2a8vzPjs7QFvjo9VkY0kPj6xk3ZVnWsirOZzSLbVHuvXV9bBirn2d/eGjYO
	VF4a97YM+E1XZXO4WGEu8tw2BAkZrXGtBWEid+wHO6hgACRDyhWufOWDgy7VRmMIp/ZQED
	XPHjKK/zgh+BrG3Tk/6cKbJHRkxXrC4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c6QiVd65;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756507521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnmRiKmnO8mRXq2kpOADUt72izimXKC3eq1pY7iLk2I=;
	b=bj8Nop0oT77TLalHxtHyoyenBNDAKOL4gs4Q6MC/QbxIQQ/0BN4giOUQ6au75hF5RqyUyc
	2lJiWeR/p8HVLglv7h8PbL/ZQ0weC7dgOOWeH2nylF3rR/xDTv7ZBdDWESqIArxnHY01DF
	evs4XPaWEiW6khkG/kGf5yOEfIap9pA=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3276f3ee2c5so1871995a91.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756507520; x=1757112320; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hnmRiKmnO8mRXq2kpOADUt72izimXKC3eq1pY7iLk2I=;
        b=c6QiVd6590YPeOJcscDXU3rHOdv+SxSUWpssrlYBtdN3thE9LSAEqJMN67wcKh4/Zv
         6C2GE8HZmS51BcjQtB1dfPyzoMS7wnnnQMz0qw8MOKhGX+2kVjwBqFCUVCCON1cpHuUf
         mbs28810tjp4DI6Wbj4f2+XxJxURJAP1WS080TUErswzZF9gs0in87Svi9SifvGFLrgt
         wWjHtFXH+CtOJIM20cVGwsppbIGg8YXr+U625Fygk3HcM5pU7IBzofzH2usjwt6jHxci
         X1czS1tgPCF4gKBilLkp/4FH3IVVqoqjQ5sRj7QkiZIRtvcTJ3ulyPrXXcRe6aPkoHhi
         qZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756507520; x=1757112320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnmRiKmnO8mRXq2kpOADUt72izimXKC3eq1pY7iLk2I=;
        b=eKFybFNywmOwZxoBUlugRYWT3DxwKsWqvN0JEItAiUSYwezjOURb53NhkMrPqdXTfA
         2zMtc4eRhFQER3rN91Qrxc8sUhEmRsvShrwjXnZ+hkatkkh0SNIwX5BFYY28907Oa9QR
         5hKVuIfssnDeCUvoQDslO8luytas2R3InQwB9LAbizQhFfHetqVScwvgtgj6mkKvgKYT
         nNr/gxt4S5Wz2xcnyMja40CB23OPUNsxUJncaFD5Hh/u5UvCQ44erreFjI0yOo3sgpw9
         mNKcwMKRt6EcSqCqQHor6E8Jd9PWzehZn5yOmLWOb0UD208o7sF3rGXCgASq5iXPMNNX
         wJrA==
X-Forwarded-Encrypted: i=1; AJvYcCUdG3uPfQWrE8NVHnOlYUA6LBCqmw3Fb/Y25rybbgOUKcR8cNJ0SeP/sd4sgJYnI8kR3oMPomExLA==@kvack.org
X-Gm-Message-State: AOJu0YzB7Gt5pGyZXE4M5Q6aeLEtzpAbQfoMUDkCRiSjhhu0QeZXzJhB
	R3rO17BOcH9FmZr179KXiKCJpaOR4X2iqCfRx0SEdNlX7X7/MEeRO0xh
X-Gm-Gg: ASbGncvVJXIsssfN0T2e9Bn713Gjh6q9XL/BCZAqqY8TOWPkppC3/Hv2IcAv3x4Whtm
	wspslMQnT3/lEHFyCYoiqDXKnXeh+/J1I0Jj7sml+1O3ZhKjdIdGgXY6uRIGzml6wJL8zTlL1ic
	c0VXpBEG4kQDRgK1xFC6liR4e3TFJG/GpHYWa204cMrz+Q3WjBBggq+F6aZ388VVckL0tU6E9no
	lGUOUtNWwx3aK+wstnNJUsIPkt82a8npAioT1r32jUTnB1gAY2QsCuGUSy5kPPOVzcJp/ahasRS
	L2QtY00Rzgz7or/UstiEctnNP4JY/I1OG5WApCWXyDH5wcH5HuCexTkvSVfBvT9wqLbj4F2ilky
	Ne1lmHhIZlr3nqXnq/tylpRTFcUD1sxvBjd7Mr6SxLdodlenazrJza+1JVUIES3LF
X-Google-Smtp-Source: AGHT+IH/XyNiqyFvV9G2vg1MeM+kl/ZTomOhVw22QI/u4Pt0TfDvevpMigq7Bp7n6YjaCOuhx3U/hg==
X-Received: by 2002:a17:90b:1848:b0:327:96dd:6293 with SMTP id 98e67ed59e1d1-328156cb806mr430413a91.26.1756507520240;
        Fri, 29 Aug 2025 15:45:20 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327daeee5dcsm3750565a91.29.2025.08.29.15.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 15:45:19 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:45:16 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 01/12] mm/shmem: add `const` to lots of pointer parameters
Message-ID: <aLItfFlYHFouVt31@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-2-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-2-max.kellermann@ionos.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8401420007
X-Stat-Signature: nuur4m6xaazhcji1hhjmjjjmitphd9rk
X-HE-Tag: 1756507521-674318
X-HE-Meta: U2FsdGVkX18P8aH7K/IYXCUSzZKbkLqlrf/rfD/pe8LF/u3SuoGpRVnDyu7/3f8Mk4r/P1iicq7y4+pVepMZFopb7sPfZZRO9AqBvS1Bt49St3Fv/5AXYFv/zWc9tg98FXCcCCcVfeGrimLNGlgOIi5TTmFR5RHrGKPSRjVPzQMFilT7J3X20F3T0hVYPZYMBPeXIEw8BRFjYhssVftLTwSmqcSqH2E4VCGlvWpM2GQUBU2ElrlXaqWDHIzu/h60ictSTyfCHJt02Ql99pXRP26yTAGvZWUK0Fnw6CGHg7ut6DeKG/atQD0FF5yXoc2JPutfcAU6qGnhqOJSERGq4YzvRNTK9xj40v39PFF+oRoiDvCCi1p2/fkyuUz5oFEVonjCG18P+hzd5o77rBgjOD8sFIOxl+EOwcvyVrEmhLN72C1N0/FTHrBjosQ/O1jXcWdQZ9Iqw4c9FnUgw6q2q78NeNCQWouRY5Lz/P1f41DQQwdxX4QWocl/LH0DY452lRzQg71LNMtdXhtFXQWacvG6E+urA/BDWi186DiDXBkuM94LOKRFcnBDqBZAgs9MZz8GXmCDNouFjw1oOWzXnpQUQ+WeP4p4UEB5lAO/Pu2e//gAxHJaBbpQ1ulpxr41GtOPB9lm+p2d1PftHRvrUDhubZqOSI28MfSV7h7P0Zz1jxZS+fHH5p+EJcKpe8OyoI7+G9oNQLZ81dwZE1vFL1BViznqBSzzIm25YS465oWsczKyZBFkhUS8mEG7hRbO3ZbBwIWFl/MoNeraMZVUUlIvqvAtufnSxODRqOcVDaEQNkITWZRUQg+3D6By6IQ1AkU+PKxn1I8NXN0xa/HqAOlXxnjDo2e9vdZcAGur9FO9Zb08eg+EH3hbpkwSlNQwaRDPfJKuKAD+QQuQCpmTKm39cPIFKjkffHpBhdA9KK3PlAYjTYKUce5rla9I7UdKz9Mi0yRhLEjITJPXsJM
 MkWHNEUi
 1Jfag7tnnWGtH8Zf9ueOa049+OlbaY0UY3nMXf0x41YBPPhhdmL+2i0Jlz/gM4PO5L5hMWqYk2uYyndH+m8CwkYps05z8XBdm+VeLpDJ6HbKs0Ag1vd0RP17mFlf5b/8O+wxvViT5OJ6PSvdrTArEZoHDeMMqhR+yylGyPRLQrlPvCnVJQ46KbyofmpDDxIh6vd+Ph7ophv/CHQQsKSNhmBGmgUFchVJjFwMkE4itvNylNgIi4GZdJvJeVJE32+aUU6vjbk3SUb1qS3TSXh+Shuwjvl6b3javQiKJ4SDHIcBh/zglx2aKpTeEdqb6V1+Gzdbc1a7ja5maJz+d8KQDKlpPyEOiyDM8IcIM6mxjdw7xReIMlkBMyvjlo9OBoKRyQsMfwZv0bfR3PxQpwug3Zc2QAR0SM/10j+Ca6eZuybmLBUgNCJuIbS74vfzUZmny631AwSjQZRKCwQPbBFZPTETzxPFtok4FSUnLo9tJ0NMJPccB/PUfjoxUdeFKXRS2TdRVbbi0Vv0qv6UxkMHnVDQPOBrZSfU6BwF09wO3tI8AVOBsIKnU6npEkVk90KJqorJA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:48PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

