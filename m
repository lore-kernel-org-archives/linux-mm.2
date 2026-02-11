Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91DB8ECD6EE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B0B6B0005; Wed, 11 Feb 2026 17:18:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B225F6B0089; Wed, 11 Feb 2026 17:18:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24D06B008A; Wed, 11 Feb 2026 17:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC4E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:18:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 357A313B002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:18:27 +0000 (UTC)
X-FDA: 84433590654.25.1B87B99
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57D0820015
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:18:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=beB+Iwte;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770848305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9Z7wrUPu/eDtNPIgAA170h+g7/v16GEGL2FZHaFyG4=;
	b=vit49lAjGmha5S3KYWm4dyQ+mYpORU/5XiJfV/7CWzD+bfsaet/AqE+Yt3RrFWpJpkoAg0
	IjhD2HKsxQH/VEvn7C/dcquWPcdItkHLBwkJSIvoesqe/Wzhmo+ShHCSKyg79RUtDM0bW/
	FRztnSIrPDp4mHisyFI+jn3g+okkQHw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=beB+Iwte;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770848305; a=rsa-sha256;
	cv=none;
	b=XTYdq/+MR763j0AP+VdNOFNyrfB9YcfEiKWiHXzuFKlhHjRM+Z2jBhnUrUxA5ooUHm6SiA
	yrhS9mYoQ6y4Y9VMVwVfW+EJ4iZnAgVwtYavYVPLLXbqpPETbPqqgHuv363HlKSOkNeu2d
	lCBJ8S3MvbvPnZA/tD6AUcNSClXgQ2c=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1233bb90317so1128893c88.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770848304; x=1771453104; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9Z7wrUPu/eDtNPIgAA170h+g7/v16GEGL2FZHaFyG4=;
        b=beB+Iwte2fhC8ffC0zEyIlruTVkuMF++339Hw7Tml7g1brmYkEHArPXUIm7Hm+b6XK
         RRMMXD/+IF++st82tflh8tpSFqGzd5cUqs9YcyPJBpeOLuzJXRPV6Inbjrc7w90tIPLK
         p/5SXkKPu1V4ZUiVSePfMeI2UCjJyKf6fSJNPr+T/Zaim2cVx6oIpw8aIeF/MYOjP4FC
         irFzoXoNK/BGy8x83uU6jVwIw8npl4KGFRdKeD3REVRnEu8bJQUZYiQkESvqfPhx2L+b
         0Vmqq2Nd5rsqTlTrGkQ1vi/91OzVjyFpP8J+9dhpz6bXP/0Z+eJeXPCK5m21I0/94OsX
         UJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770848304; x=1771453104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E9Z7wrUPu/eDtNPIgAA170h+g7/v16GEGL2FZHaFyG4=;
        b=ASqBSevmpATx2Tf+TrOjCIck+i3wKJVT4LzL3lCOy7Qq7Fpv8YbWE3I81V9lKkKQSw
         rs4aBjtfJQSYcQTLfaCghgY5Go+TiH9q5WiohKkT6TZV426bU0dF7b/IUtYOiWM+/sJ1
         oIR+cd5HyDVK0zFA3CUTkGkxQcUr4KzxllgSj9kOE1O815d0PVrhUwXxwLiM09F1RtuD
         ouLkIz8UPT8LlthYoEbh/vwXHLupaLm2gg34jW6BLV0JeMIxkwRMjiemeK50i9t/Th+Z
         +yXpuloGEUIquQ4wo0iQFffBuEhfPBKKhj5sa9AEH4D3xOvRbl7D7rDAWlvsPMPurvSM
         ornA==
X-Forwarded-Encrypted: i=1; AJvYcCXVT+3FMaqtwApYrEh01mMJliJpy6xf11/Ntgi/evlVDvBRn5j/AOVDdRIqViBEOFaDJWkzSnTK7g==@kvack.org
X-Gm-Message-State: AOJu0Yzxm/T+EeMmnXhFWpcKSMDK9ca9J4jzUfvVOrbA/o57TIrYGHfV
	nium2YmdrxhnpHAfNDmHH6P2fppd6UjPwOqr6Qp4VNuXRJRXejbCVJWC
X-Gm-Gg: AZuq6aI6ffImMeFWRNhNSOrbplgBAKn24coaSg2vpO0WkEVv8uDVukCO1YuHh4UgSoV
	NQPYAaiNxDtknGu/dmwhgFX1MHcMB1DHCgQ07fmVQzk5cBAiRbXoM+EV0dxQClzK5hlEvZVZLWL
	eL4uQ9xnhe9FFI8XVS5LXu/BiPIHBzRZiW1tqEejUmao0xoU/501ZodPK2YTRxU5NcBeCqpnJ5g
	vSmZ91Dj7VPb9S8ijEUih70hrfYRx1DA9IfWhGLx8ZYppklqxS92VGpcLf02559w1Ig2aHMcj2f
	03t7g+B18UCpCZ24m4ZbNwkR8JLn//Jm8QeRgdiVVDnOdF8T/Q+Utk1uRN5k1ZWGfMK1ygaSYkc
	FiwOUBAXu0khvnoDHh/BPX0i5naT78Hr1ffzks6O0HGJNSqtyV6lAzNWDjpt5fHf6trQAYuNROJ
	eQN+lZ1FpLRLzsAM3QirkWMrZuTuf4RVjra/pMUkgUhSiGuSdMEL84vb4=
X-Received: by 2002:a05:7022:619a:b0:123:3c65:d724 with SMTP id a92af1059eb24-1272fdc842amr209524c88.25.1770848303872;
        Wed, 11 Feb 2026 14:18:23 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcfe6b7sm2713774eec.29.2026.02.11.14.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 14:18:23 -0800 (PST)
Date: Wed, 11 Feb 2026 14:18:20 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 1/4] mm: Add address apis for ptdescs
Message-ID: <aY0ALB5yKXLY-M-X@fedora>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-2-vishal.moola@gmail.com>
 <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 57D0820015
X-Stat-Signature: im7n7b6i9fzcoug665an15gihsowm88m
X-Rspam-User: 
X-HE-Tag: 1770848305-213240
X-HE-Meta: U2FsdGVkX1/x23V71KqHTM7oM3ge0+TX0xWmwzVGbpQIs71ptMFNbbMPuMTyr/Hxv2q+/qKFhOY7gHJVy6l3n12Orj+Yy4qG5HD4p01B1+iOM8NIJGFswGCMbSh4MMYYCg+B/Yp6AcaR3VbwD9aS7kt7KXP+CLRTVQclivPZGOClNmNtEiIEMtOt2iZ/FZMa69HOGUyES5d9zHW/yeiuX8WyNOzXmTX/nf+hQt8fplXcgSNi1yCE+b8UCe7vreftTAVkgAfoT9irF8djmIT3M/KC2ntdCXHVhfucPq5o4of8U97/mLvV1W/xN40TSZbnH4276tpL3SJ/n/I8mrlHhSp/PcvNbKRrF2BebzKtZ4g3uTk7L4Nyk/KwtfzFk8yn2qFtfZ1OtMr3oWjPrSXzwkWCmnBn7B9pU3HE5eO3E6Aw7Sqh5QrvCYc7EtB8YQwKww+B9TUay1G6CLbrNMmQo9wXBEbSVZQHg2P43uMFXe3TaUlXsV7h0MTU0FEYVo9c8MegyxbsazfDSNEt2Zeo40GAV2ZZBy/yuv4jEa/jlt7TAhdwttJTaOOmzyydB0RjhkQ9P9rwDQeBuLC7k5Z7OJDQNyNXaxZz7i4Zs2BwCEZbcJc5rvKt0QWzTkcsI8TUs/8vEf840yfaAIEDfjtOiaEMaC7PbCl6LYx7eMVdsBRKIZrnL8rJbNiVGkyfxhsqm708b6kv8cKWNVhTcfgXoAY+xXpnZn6eL0/3RLdK5JD+UmqUvHvF6P6deSacqpfs6ieHuJeBFrVope+MUFefky9rtgbv7Ldkfts6L0YOiylwsh5MYdFbXE/z4PJdvZ/YlAe0KNwfBsllOMjUj3MxJacxyvG1VE9FLNMdBSdG/1LOmFXiNL/Hy6qdXKHIn0Jkw38HKvzUQCr3ljguWXl+7xqBLohRAQWx4sWL4zNckgYc+n+XRy/1zDhRPhordvMMQjM4c3lRhj200EX2ehC
 dZ9v2Gvi
 mXBWAQEoxtGXy2gSvbOvS1eflLL2rgB1nBMnPOYhq0ryZJxk3BATryMH7mOUXACpV206EuWphlo1VP7FJhfW7QmEaczBXPSIBb31g9FRyG55L+IFC/H7bFrGyyZtPy/gbPdr++HT0Ly7yPvF+it+5fgWaxVot1YkYmvz9jMQmJRAUqWYXwxPO1ec+xAUqrR7Zo/l3SIqexzpNT+f/xZXCw1N+n9wMp+vojxncWLJVJkp2dtaLSj3h6C5mQzuF2MndahrzaPgpneBQ4WGL5KJ0jOr2AsNFY/xxzOQgO6WGk9KbiyTv3wU7DKuiN4fHwzVZVcgQ+jz+AeAuaw6QN/LPYSpT3gzpXud60FwQPLp5/6RNLzahi9bz8rZeJaJWNaAWsWrpeG1QI+++4uPcqL+AyyCbWXFwzxf8xE4zIenw0pHtB1nFQrIO5JxG1SnQeG6vyWM8vecldfKDvctZ+tAvxL10hKQHJoE7rGx6zOnSo7EGIfueZ8Ixa/Oog6c429ajWwH9WYnFFazGJIl9aDOLMaI7fRctgmicjDa7k4PewKJIDE0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 12:13:10PM -0800, Dave Hansen wrote:
> On 2/11/26 11:52, Vishal Moola (Oracle) wrote:
> > +/**
> > + * pgtable_alloc_addr - Allocate pagetables to get an address
> > + * @gfp:       GFP flags
> > + * @order:     desired pagetable order
> 
> FWIW, I don't like how pgtable_alloc_addr() looks in practice. It reads
> like it is: "allocate a page table address", not "allocate a page
> table". I don't have a better suggestion other than having:

Hmmm. I meant for it to read "allocate a page table and get its address."

> 	pgtable_alloc()
> 
> that returns a page table pointer, a void*, and:

Initially, I intended to name it pgtable_alloc() & pgtable_free(). I saw
arm using pgtable_alloc() and powerpc using pgtable_free(), so I looked
for another name.

> 	ptdesc_alloc()
> 
> which returns a ptdesc*. But I suspect that would get confusing at the
> point that ptdescs _themselves_ start getting allocated.

The ptdesc_alloc() equivalent right now is named pagetable_alloc(), so I
don't think it'd get confusing.

