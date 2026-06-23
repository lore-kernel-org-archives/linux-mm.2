Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A50CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04496B0088; Tue, 23 Jun 2026 12:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E206B008A; Tue, 23 Jun 2026 12:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B886B008C; Tue, 23 Jun 2026 12:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE4E6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:36:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E291A1A04F3
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:36:34 +0000 (UTC)
X-FDA: 84911730708.15.3703C28
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id 54B6A20021
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:36:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782232585;
	b=yZoXrERgH08tmO2ZHI5+cO19MOYYN/FZCP4cMc25RQhMwphGvWz+rBOZJBCP4423K91mM7
	hKMjTaDrP4JbcelZz8gWMrPI1e9kQm88GiwGcGnaqSWl6rd6yNL91EC3aBrKqiRNKC45mA
	mb1oX8p8ybdnMcK/rWaIM2G0yBuf3/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782232585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpQ1AwczYKCoguf7Vbwxx1q5Epc4lMpg8aH6LEWm7xE=;
	b=zAWSXXwNTNTYjxl4+XlJ03A/4TZHl+d7W2hr7XWGxNGYrUNX+NEIjtxdYBfBUTLRHj6Qxw
	meWBNaFHWXjrm6ihFs1GzRZYnyZYD4xNzflVJ1AmfKisfV951CG3MdZcjunvugwRs8pAIY
	v/HINs+Tp1jbqZl42X/XF3W+/femVCU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=luoYW8Y8;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-922e181f199so249631585a.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782232584; x=1782837384; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dpQ1AwczYKCoguf7Vbwxx1q5Epc4lMpg8aH6LEWm7xE=;
        b=luoYW8Y8zifQgb5YjMUVxZiuupl+Q53GY68Y6/a3g0McKC9ogDMgf1cicOeQ/9F7LW
         lS6dkb2yNRRzTKBktxByfFljY9m6zOrf4jyIU2XNrPFajLZYfyY1Y+PZbBUxKgDsRTrV
         2nMsRFWbAcJ6wW3YOivZC8uQLmUjkJ/iuJbWI1xME2MPgiYInkKrOaeFizTzQ4bQI+No
         khrnZCKpgyTEUEdU4PKmQh2kqzqwB0r1S1oNGXItIjloG2npWDxokbNvD44ZvFAiI8Q+
         tRvCb4KkNnpgQ0/V6uOU8+zVAbSLS60yxVsi10zjxu282HglpDUKfyeV2ZDlpem1qUQ/
         Bqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232584; x=1782837384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dpQ1AwczYKCoguf7Vbwxx1q5Epc4lMpg8aH6LEWm7xE=;
        b=eNt7C5NGCIGRLObRS4a9cGu67zTyqiFJxjitYtXEHbk5u3hpeLtXAhgf6UnFw3NMAf
         E9vyZTqJYClj/qZChCEVo/QVV4dAXHrDM3cadmLXMZTDEKkUPUbZw5IClPqm5lHT+sIa
         goM7uEEc9IkIurwONq/DlQhNpVbKp3sREUZdqIpQv3QAsIiOTfa+I12zb6LoYCK8Tvxo
         tM+wGl1iQNOBGrNWHHHbxLJeA79x8UBZRTKhWqu0GcqjnMibklnOsoohO2M+FpWAPVer
         j+yhrDwqBuvg1zfh3MZOnA38os4sr7mGskf88Wvz4MWjeFQzd9dtyewAhF4Jyx5Z3XjR
         00VQ==
X-Gm-Message-State: AOJu0YwEflDJBltIJJxuMJ0smK1mS68dt7sa47cIDj8Ye1LijCkFKops
	2y5L6IPrpy15s4aj+N9NdsrKQVYdjX1OI1Tme233FyD967rHVg6tSNp1yFVAFFFEOEo=
X-Gm-Gg: AfdE7cnp7DcEP2HqHIgxwMQd8TnEmQMKfZtqocpujhbaDWJwkEgfs0O8bU9QN8YPwfm
	CeAG0QOYN8aTlA3hD2K1gPCwBTYMn1E1tP65oUHJz1lHgoX6mXOnL/UYfz5Uo9zXEDeYTobL0xh
	o8AaN+RQ/0h6itbhTii4g/Zx3rwq6Fbwo5KZMtFKUGDVBQh77GdyyIRUg+4RusQopG51cvzXlzZ
	81joICVc99FnxQoIlxxL7Un4EkVGe8dh3e+HtNCiPvlFrtgCSM/HFNMCpJ/6x6e0XJiVhwT56iI
	nKPNyEH1pLkRPkH41iII7xXJwKa7spkEitlYyr7xhFOAW/iJxKHULFq0gLT4R1w0iCyk8bSLEhi
	pda/+Lvdxc+pFExjm0SMx2QEufme7ey3wDpgtZY9TCO9ot+5/A3ufi3FqoQXrLYDJ0zdge+dt/D
	xLK8i3v36MkJwpqMakZ+4c36vqX88lhPd0kUNYZTB3gljnm4cEogF4Jc+GJwcxeMG2Q32TD7BDW
	JEbkGw=
X-Received: by 2002:a05:620a:6892:b0:926:a969:89d9 with SMTP id af79cd13be357-926a9698aaamr393123185a.7.1782232584382;
        Tue, 23 Jun 2026 09:36:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-926000c2a09sm306953585a.31.2026.06.23.09.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:36:23 -0700 (PDT)
Date: Tue, 23 Jun 2026 12:36:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev, kernel-team@meta.com, corbet@lwn.net,
	skhan@linuxfoundation.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com, rafael@kernel.org,
	lenb@kernel.org, gregkh@linuxfoundation.org, dakr@kernel.org,
	akpm@linux-foundation.org, rdunlap@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, kuba@kernel.org, ebiggers@kernel.org,
	lirongqing@baidu.com, paulmck@kernel.org, dave.jiang@intel.com,
	jic23@kernel.org, xueshuai@linux.alibaba.com, kai.huang@intel.com
Subject: Re: [RFC PATCH 1/3] mm/numa: add exclusive node pool and
 numa=standby boot parameter
Message-ID: <ajq2A9GUOBWjzYM6@gourry-fedora-PF4VCD3F>
References: <20260610014517.253609-1-gourry@gourry.net>
 <20260610014517.253609-2-gourry@gourry.net>
 <aip5IWmxg9CWg8hQ@kernel.org>
 <airAUSrNjbSEwuti@gourry-fedora-PF4VCD3F>
 <ai5vj_RjSxl_FLu-@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai5vj_RjSxl_FLu-@kernel.org>
X-HE-Tag: 1782232585-759617
X-HE-Meta: U2FsdGVkX1/YEDNrONz0rqFKgRw0ZnyRlH83rXl7Xgsrvxl3lFZhQ8boDCV63Z8+xNYWPrBHfCtqdmm23N3cAux8My8mEDDpZZC8iePawsblQz74j3hwtsxqbIbLo6+p920VryJVxCBUSKVnDrUZ23F2u5fWfOLoXekr0oFWWelYwPSvDYsc0Ufiw3b4gTmfLpyLzqd+UYhrdcLfx+HRGdnAxpmqb8WCe401gx+dl15811HrHLIoSFeUODIPTLsGnWk63dh9vu7JQQw6ZkhT/HsaANWOtjBzMvvrh4gRi8my9IyXC5CL+dNVuMMX79bhPfOkcxwyvNz0Of1f3uUE6sbcVDTIkCUFtfrMUfIS6MiMf71nL3ob5a17roqAvMh8+jKQu1QEES7z8YBjPc/Qqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 12:08:31PM +0300, Mike Rapoport wrote:
> On Thu, Jun 11, 2026 at 10:04:01AM -0400, Gregory Price wrote:
> > On Thu, Jun 11, 2026 at 12:00:17PM +0300, Mike Rapoport wrote:
>  
> > So really i think you're pointing out that futex_init() here probably
> > shouldn't be using num_possible_nodes?
> 
> I'd rather say that num_possible_nodes() with and without CXL (or other
> differentiated memory) has different semantics.
> Maybe we need to add a new primitive for possible differentiated nodes and
> keep num_possible_nodes() to mean "number of possible nodes with normal
> memory".
>  

We'd have to define "normal" here a little more discretely.

Normal = N_MEMORY at __init?
Normal = N_MEMORY in the future?

We also use the possible_nodes() mask to allocate per-node pgdat, so
the futex example is largely just another "hey look at this thing,
I wonder what other stuff is out there".

~Gregory

