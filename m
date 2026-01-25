Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA992E63C9A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 09:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10BC6B0005; Sun, 25 Jan 2026 04:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A947A6B0088; Sun, 25 Jan 2026 04:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0B66B0089; Sun, 25 Jan 2026 04:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2206B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 04:59:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7C8413B0A8
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:59:15 +0000 (UTC)
X-FDA: 84370038270.08.151D9EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 31F9680004
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:59:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lXW3ae0Y;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769335154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzBXbcek7hEhz5sJ4rS9689zK9sEhZN48jjP9wNdoTg=;
	b=E3M3IjNm9a7Oh+MT0/3H0jtBwYArVt6W1qbwAhIPRw0Ao8odKTwVBKg57j26bg3DYbp7i0
	oJJgDP9JIy2itmZzdtgkDNPGCjJuULdhHduC07/CDF4OXANj8z/RqD6oaR+EFiuCQheOPF
	oGFME6kXMKKiAEm/KikB42xViaYgqMw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lXW3ae0Y;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769335154; a=rsa-sha256;
	cv=none;
	b=KNiO3YlNh2bky5NFsgtv5kuKzXurTvB/3+gBFsN5aHAumLHSKtvvmR+NYl0RTPAxTqJ7dZ
	Cxxl7st0n382xxr0qvyLdQeMA0NaqTGNswJ1pksB6AMRMK6tn6nksyzbtuxk1ZSOY59D60
	9CQBwrUmwcEGA3N7YxHKjIn4qzthd5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4C0340795;
	Sun, 25 Jan 2026 09:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4929EC4CEF1;
	Sun, 25 Jan 2026 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769335152;
	bh=t90pzN2k6Whbca/34ndSIUtQ6ODauPo1RiRNlXzDNBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lXW3ae0YU8z55SpbxpHPpo8QS9OjGqTcHsbiii51ODHCMOf6hliMbhrjJWn+728Be
	 TgZj79d5jvu5iItz6H9z2pmlrAqZUWh5ktcnp/oBBLBErOg264g+S0l93REVWuqUc7
	 9f1SvxnhTk/H3zWkQkzLti8BWy0U2XDnGrip1KUUg+j/NWfT1ToyfG8YMEEV0sxDWC
	 KglKM8yIWZ/13LlIhLbEqUClho2mOfcPaccYreX2EQEnOjI+jvuATB8GxADABVYNyK
	 Jh2oups9hDCMfNMF3wtxjcp2b1X8NBJWd29wiq4EXkdQUSJ2jgLnBg87nxA121pjwM
	 f05aOgFlDDr5w==
Date: Sun, 25 Jan 2026 11:58:58 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Lain Fearyncess Yang <fearyncess@aosc.io>,
	WANG Xuerui <kernel@xen0n.name>, Kexy Biscuit <kexybiscuit@aosc.io>,
	Mingcong Bai <jeffbai@aosc.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] loongarch: wire up memfd_secret system call
Message-ID: <aXXpYqDyTeftKV2c@kernel.org>
References: <20260109051054.188030-1-fearyncess@aosc.io>
 <aWC6bIEg6UqvX1DO@kernel.org>
 <CAAhV-H5tHZRHmXSA6m+fyhaN9nNjLFbEiVK7OWjL8EoJn16doQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H5tHZRHmXSA6m+fyhaN9nNjLFbEiVK7OWjL8EoJn16doQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31F9680004
X-Stat-Signature: snj9u1sajc4ermfynhao7pfzdtnusnj4
X-Rspam-User: 
X-HE-Tag: 1769335154-824475
X-HE-Meta: U2FsdGVkX19JeYwe9R1hiiw2FixMlaQ1OJY7aX38+hfk3ARa0RVQwxAyd8oTJsp2LA27VNAV1SlEkcO/4yI+SVp0lZCCATFhRcpjBXgHZv9heHpGL6MXcbpkwes0LybJklaS1fpxTCUMEPzY+DEG3OsbW+oD8TuONAdmrULQCYXIUniyJeXYoZPoF2Mu3BEDBH0sGPOboRTNxsAJI50mUgIXJhe+8pID8U0mZ7ecaOsRr2n8OkyoKKFF7h9NhSIzmGSZ+UDpZE1vHcvAWYSPcoJpwUZqVaxM0KZGa3O1yQXcB1LZeuNQGCFniEoUKyjczygWLFXro2jT3omyZwdiD3qeiu8mPyzWqhyAL8pTHMKCJwu0+ysdXTj0Jv4OAAIzNynXX76apIJVk6OoSBfGQepY1n+5pZttu6jBAUmTTofyST1ZuSnqgKL3tlBYnyNlv4y+b/zfYCTAloUp7STeMBL1RO1ep8UH7pVfkyYJvw9Wpxz4o2wVnnwai1vMBPhDpajA+MrTqERvhwt1fqVCKmglLP/ybBCvbnnLPgl+1BFKZIjqBAynYADjamFx+3MWr+oF2Faj0qLU70lG2dQEHV9Diqn50vqkjIYeYDR5f7f1VKl41N+6Vvbno7k+RYalngMLvTKMuy94N7dVd3SQP9gKsui4tcjc0p6JrXaL2IYiOAXwIB9/VDIdevu9K5st8JorSvp5MW0pR/JVTQrB1/Hh8h1g1bo1BLsVIx5fa+O5TJqiX/mBwsH+sEbH6Ta8aTPA7GDWFiFpj5lslh56fXuUADOAKjAwucGCJc2dRRaW2u2rinZufM/CWmsOtFCNpm19Z7BueT5eatjLcrfQYEO8UbIyXD057zo3mAOav45Y2/hjOhRTa+92J8v5uZwPm1seim4yquevgkByHZ4kaFNIMsoOl+v7mhCezi/Mph9FJF6rphReLXAP85IXFh6nCzYH5fxfi4lFDKS0t8F
 xoUW0asv
 pKsMAzEHJjXGM3IYLttw24b/8qQROCkX77QP+L5713mF34jBZGq2x/yKJ/OYxneJRNN+futZdpYYKPf+f3p4t6ttOwx346T7acH/zh5ogxm8wSAyo2bw8QwnVZAtI16CTM2Jn9wy7WOCogFZzoPXO1x31Hs7EXz2h4QRVsXArS1d7o5nTPziwCtZCghk2PYa+Pc7VbJPaXoWdKioWXg/LjLd7qi82yEj/oVKmnmVu4q50QqaLKQ+S6+Xht6aH0Dlk+P7K5UbI/Mc72ziqyH5VEQpSHFpMS1+1hB244zC2Enpq2Vq5LblvDLfIEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 12:03:25PM +0800, Huacai Chen wrote:
> On Fri, Jan 9, 2026 at 4:21 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Fri, Jan 09, 2026 at 01:10:51PM +0800, Lain Fearyncess Yang wrote:
> > > From: "Lain \"Fearyncess\" Yang" <fearyncess@aosc.io>
> > >
> > > LoongArch supports ARCH_HAS_SET_DIRECT_MAP, therefore wire up the
> > > memfd_secret system call, which depends on it.
> >
> > LoongArch version of set_memory* does not support splitting of leaf PMD
> > entries. Does LoongArch always use PTE-level mappings in the direct map?
> No PMD level mappings now.

Thanks for the clarification. You can add

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

if it's not too late :)

> Huacai

-- 
Sincerely yours,
Mike.

