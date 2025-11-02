Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D202DCCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 15:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E10C8E000B; Sun,  2 Nov 2025 10:13:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391768E0002; Sun,  2 Nov 2025 10:13:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF218E000B; Sun,  2 Nov 2025 10:13:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3228E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:13:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE47713B4A1
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:13:58 +0000 (UTC)
X-FDA: 84066012156.02.9AB960E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id D5CDB1C000C
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:13:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDXz8OJw;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762096437; a=rsa-sha256;
	cv=none;
	b=yqUHu+AmzvFvM0ttWt0a62Iw3+HxCi2ZqmkWBj6tmVhggW1LnaNjxRrJaIbRzxFWOaFry+
	YrkvB+No7y89aqUk9LQELH6funqP3B3EC13NoxZA7Rnlqm2IP8bJGLXwagPDaxJ0itxoyP
	kOKoSwqAimcVjUJGfyy+PQQT2rcHgQ4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDXz8OJw;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762096437;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQ96rEK2xyiZuk5MptrQuva29zVxFbypQtCJr8WgS04=;
	b=x19cck8/zSYV93L0n6clX/n2uLWCP/gMSqqawE891fNwUep2cgqvPVS4c+c7ZmC+P/cF4D
	brDJjFBQgGyDRFWGaigirKsnayu2lcj76vnE1X2jPF3s4Ae+mi81pXtq38bxsvj8CVSrul
	hN47Svr3VwEIARQ7tv6BQVMLPMcJtwA=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a1603a098eso2236942b3a.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 07:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762096436; x=1762701236; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQ96rEK2xyiZuk5MptrQuva29zVxFbypQtCJr8WgS04=;
        b=CDXz8OJwlPf+ygCskVORuz3P4hUXilMxkdvbdApOXRm4VJ0AZWBxLBD0CFzB5UPCof
         9HFC63kDH+JKwuwymmSJ6gHlU4dt6DDlUU0Qnfpdt6St/TFkBnl3iX9yV2Ga8b8w8jWK
         MEFEY+a3cFoviSFI4nA/YltjojvNOzDBs0fqU4KrTh008cAvMQzZnfKR1gm50CCpwjZX
         oRxL+cbOpfdCFy0J6wWNSoqkXj0MbB3aisi5eHRUyGMKchDwmBLSvlldTBdPtR+XM+RD
         NEFzhByAZWEv3rt76/DNcvNbCz28BGkrxdyBZ+bRXnxA6VGObYwHC5OEMSmeblmXAVo4
         9b3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762096436; x=1762701236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQ96rEK2xyiZuk5MptrQuva29zVxFbypQtCJr8WgS04=;
        b=AMrKZV/8VqsQVyXyKneOsOa+HEkiKKydlDCRNC9BHHa/2ARhrgVQkIe7Zp43a593a7
         zupubxMDU+izb4Br3ewUjqK1fWa55VF307ze1Re5SItimvxgMlAUYMxW6/wQtkCNjBfk
         ix4jnmCMzXQIwcNWQ6NAfVsQfVwtIxT2D5P+1h+cUIkRkG+bdAkbtVPiYq9PQBXjyrfK
         IORojHPCOy16Fs0bghYGoiN5MwtQVq/ZMYe68qT2j9VecbKrOzmB/09+OLMmUUi+ibrk
         +wh8MXxQ8hP4VXvx6t3AXNQLLAh5ew/p9GoXANAAIPlTgv4Vxq607XDZ6XzeW6WE/0nP
         wOAw==
X-Forwarded-Encrypted: i=1; AJvYcCUan8MSh1yotytQo+UJH+/K1l9V3jJlZHD2nyY47EU7eC8a8oZqcDT00qlFNU5m6vy4cF6R42faCQ==@kvack.org
X-Gm-Message-State: AOJu0YxegyqlfcmbyG9DRfb4SPyv5ZtVrSGQAlsJ6mU5hf6fxbCExUwH
	ShL6Bmn5R01hYSi2j7kzfWkJ43xwM66WdmuNUr+/ME63RQ07JdKPPuI8OWTfUw==
X-Gm-Gg: ASbGnctJkW8CAiuhVvOpLuE29qHaSRfytnKcFRONaMZ3B1SNrz9a9AuzO5QIfUbr4Tr
	4BVbff5/T7nFmKpotWpDK3ajVfZPZX4j0uQRbt5El7PfWG9cUERfPfFpnjKtXAObroySKGYqkVQ
	GjbByPkE51Uk1ejiKnFljU9Vq9E2etkMWP9IWmFlAAhgytlX2hGrZ2kfPjS5CYeCe8n4BOETm2w
	SVZl8uI/UDXLxE05KGAGN2Jxug9YHePzyVjcjFAe65jZy+vSK79OQvtwDOOrz+QgtzzPye+LnP6
	OZXI5qk3ROwBBEXHQ15jSTGn9JPCJiVSYxZVpA7n7HDyrJK7zVoV3FuLsaJJyaDFgetTjuiaQvM
	U1DsDZK42/iZgYzk1Nxo1tKUX+22SmGYlGlXQ3BdcGLCmnlI1Eiy6ppS31tCbDreA1jFMDed6mv
	uY/feQ7JBLvSbg1Ck8oqNg5Dg=
X-Google-Smtp-Source: AGHT+IHmHx0E8ppASVsSFwTxa9r2hNMFtx0sc3Lf3WuBxMBGncC27kjjGIjwdZRARbJZUcJWV5aISg==
X-Received: by 2002:a05:6a20:3ca3:b0:342:6c97:3693 with SMTP id adf61e73a8af0-348cd21a90dmr10207159637.47.1762096435632;
        Sun, 02 Nov 2025 07:13:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db87340esm8103609b3a.63.2025.11.02.07.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 07:13:55 -0800 (PST)
Date: Sun, 2 Nov 2025 07:13:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
	scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nd@arm.com
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
Message-ID: <d08c474d-4b4f-4b75-827b-e7da550a6dee@roeck-us.net>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
 <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
X-Stat-Signature: jejparkazn895pmndf4b1r9knke831n8
X-Rspamd-Queue-Id: D5CDB1C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762096436-758593
X-HE-Meta: U2FsdGVkX1/9exq6iahaFSVNzJPmOa46zRLlxMcKYw4ZeWo7gSvLPiYRpSSgfcBNGawiKtiC92HlGLZZczHbTYU65nwMn7nFDQy14vAnX/hTJZeth3r3//2xPju6SWyGfurPG7a62Xe4ctw3VH55jguN7LTlFrOL8Rnd/jshL9itCkKC8uYxjbkcUbYet95OLwDw+wlikgTyqTX+1DE6DRK8c8PErnBB5amYd5r1kbFoZDagbqULPvDfig0mF63NDKZ216s0G9VOI+efsZlmNbSpRVIbX8VjJ9xNfWxE2uTv3JuTHRp4sVJraKS8CjRpWPlnaJL5B6rqPgtonvzxAG6LsVFUhTKj5y28ZQD4cSefZDZW98XDAyYappI+Q5TCgQnXb5Y64YZcitYqRE58WUmLQwdPtDBHY/O5x/o5ega2IMjPQ82syxX8mom3tM8s0AtIOCXxJRYCYDt6hmHcA3jWfiV75I6gzFVwIy67nUddrd8mjuVIwg1aOitpDo2xbXxDQahTE7ZRaxp0MfoPAQvFOfj5Zp+qgBBROnUsgYwNoePaD8Sdm2MtyElWeEskMcOBExQ2IQpdnZRSSY76uGWEj0EM0hZ7BnTmipG3bAMmhvDNt1GlWDhl8QSxojq8sFR/3Suh9Uy0pXMWd8IsJD6JArNmeSykgpVezDPgD7VWJSbHtXb51wTBibFp3kU+EsIvdK+gKOnr3zLPVaJAPzj/rZA1t1HEybYeJy54BVrkoBD8f0MmhhGnvrymAXzbn7SyQfOwZno4dr8WfUopUEMBC9iHR+Ri8h/ZycGphg2YftNCpewO/KXel+pMsesuicZhsTvaDJOoyBcFJcyLot8Fj+NRlY1JlMIo9gA6B94X1UbrR7rsxUX8UkJYoUfzVQWU3i78VjrHgKZd1AzZIZTduXZmSOP9CVWK47x4d3C4hiIkDYOPygySgzy5b0ZeeKoAPo4ok3WR0y/L4wN
 tYCzHgaA
 oz9HQU6cVFvEBTVV7e9mBMnUi8I4VMRaNlU+HemBbvC4D/qY5P0aKnfyjA0vdh29TV7ckbDHtBok3QqSjo9XntML6HRZirlhSLaDDK0n6Rt52OCx4UJbx4IOwXlCrdd7Owtx7fs6q/yFK1jqc9xbc7sSaMzbjslATGB0xM61i08DB//iF9V+fXHHl76ldNDy+VgYsYDdiUdd39IpWluMb7T5mIiAY0GuKwpv/eX9pKvTPUY5m58c81xZkApOZSpGr6IhMkI4XfwYxby4mJ8eMJhzg7bibqqTyQTHCIHvRQjX6zpgfgy/iKBRu4lhR3SI0NNEiEhZyE5O2MWKEVicebycaPeVTY3wYorZVVCTppLgh3Jn/CVl+R8C4iijhoZ1ta4rAfZN94wQTNWwGZp/O0uJzJyGjSsbuk7wDRDDz3ZAetcFx7Ivj2RgTFvJ7V2//kirq82UFMvICMIBWBbqCdqigPW4qnNK+GDF1nH9qp/7gEFFLCdQnXpuHWrdsc+hYf8NqdLPfyaw9l7yUHbeID3pjs/eMhKfe7NxxLPAbOhGCNVqP31ae97pDpG4Y4Yr3S6pv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 02, 2025 at 12:11:11PM +0000, Ryan Roberts wrote:
...
> 
> Here's a proposed fix, although I can't get access to a system with BBML2 until 
> tomorrow at the earliest. Guenter, I wonder if you could check that this 
> resolves your issue?

Testing.

Thanks!

Guenter

