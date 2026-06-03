Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11216CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDDF6B0088; Wed,  3 Jun 2026 04:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F0C6B008A; Wed,  3 Jun 2026 04:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4946B008C; Wed,  3 Jun 2026 04:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2F286B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:58:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 479251A02D8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:58:15 +0000 (UTC)
X-FDA: 84837999750.25.1B17D84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 422D140005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:58:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnPkKyEg;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780477093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNO5aQb0rtRKtux/wu+5AcytYSH9RtOlt3U0qrUIzPI=;
	b=cU84oWRcEZBMPb6rz1EDb8XM8K74/VfVcJ3xir3ScI5geyORb+XPlUUd1spe/dC529axeC
	t//rUK2Al6j630L06kAeye2MNW9b9cbZzRJRnHaw+3qo+A4JxSAGAPGu+k3LbKb29opzQU
	57Gs1Ei3768pALQ+0mnyQPpgqyArN6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780477093;
	b=RSonFOrDnSsnfq4gUMmrUMZSNpFPL/5ZQEu5tWGHdkPitOhVZIzSqzHP1anXeRUD9kcEbP
	v1O6nfifgUYc2m3ajaMbrYu5BuzI699iTseNirsYqg/+VReenfcuPHH2dGRarmtpzsLOal
	Q4Ri3jwczn9eVLSXCm+ARaMN3S3SdE4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnPkKyEg;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71350434B2;
	Wed,  3 Jun 2026 08:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924931F00899;
	Wed,  3 Jun 2026 08:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780477092;
	bh=HNO5aQb0rtRKtux/wu+5AcytYSH9RtOlt3U0qrUIzPI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mnPkKyEgBAoJhHyCjKocF+n+JqkHcWSmPH184p/CrskKjSd4JLPoFSBGrYLKU9Mar
	 B1hI8HW9H+53ks3lghDx4U+J6rNa6f8KquouzDq0+DM7/4ZBRzC0AuXQVPvI5bKqkY
	 NglLbcu+ZBDleA+IgNkKfEKOPcXRhxVfSNk8lTpECqvKoBh+iHSyU2ZFRwFPFE4daX
	 kw0WCczgVzTNS8Nry/XjBs//vr21nJLOAmz9iMERtpe8gUl3WYdzTVYvcHDMtqVnlJ
	 wu/GIoZWa0/6+fA9X2Sm0u6y0MnNMo3tVdcswt4ZtD+mHXcn/QmWy2xNCp5hUrCygR
	 dCBoxrKjfQI+w==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9E4CDF40075;
	Wed,  3 Jun 2026 04:58:10 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Wed, 03 Jun 2026 04:58:10 -0400
X-ME-Sender: <xms:ouwfaqCSomCUHn2Pcxt39NzT6QrYDOwoUaHjVutpQNUu0GYFMZl_Ig>
    <xme:ouwfavUBA_wa0-Kl0rwIin5phZ0Xk0GMcV5YCAKgwCXtZX9t6zPJc0f21igxmxdFZ
    el9mEG9Na6KsRXZeOce-ahEOIXmRVtrBYvtLtWGWDsGbs4lRkjjK10>
X-ME-Proxy-Cause: dmFkZTGr2weDGKBa0sUCUcj036iLL5Y1yiuWXtlNLmEI4O4KffGEG7mKCI4rtXP1Kjy/sC
    Vn4JLRDUw3n/LlH/P7ldcJy2f2NLMW7zEwQdl58eFGDw13Gd7uBwZtBFefeubqM57vT7KW
    gxI5DHTPlMa9V7t7GBAVKnyC4disspoUcyOJuYcuXeoXUDa8M5AS9XNNfwK+hXW4k6RRKP
    P+HnepDfV9Ly2SCGeboQtn62xJxY4OofV3op27GBS756vLSUraZsZIubTiRwHvbO7GWFg8
    TN89ZhNEjfm9JCDm1LdV/dDNhv9gsSNYWX/LbCMQhfYJTNEbDdYGKUoqZbehxmbuTXbkFU
    XnaKhsn2lQq7XiJ+YTNPtHlw97iNDWbeNZirflpUY26TpW4YlC0yGx1F2Pdjov4xxyaUZd
    nGZuSrO0ofec6SMf5X9bTikzbc7jU39nUFa8+EDOEs+sLMDgAb7Jfbkdo1r3Pi14q8HECl
    WOyAkHMSoapVwjPlMra4gfnE/Sq1KO70VhXXH61epQ6Rh+aRLmPHQfsv+x4lMOk7iiwpsY
    2Ln1UDislceGN/Gw4GkBXiCXnvOln8phYiq7SJoKkYgBG145jAMq3GJUgudNXhcY+kY+fP
    qpGcyL1cKdvM1YoB3pTqsi5xKVO8SJQEPQQW/+ABFCEXztbk2H+BY/x90g+g
X-ME-Proxy: <xmx:ouwfam3-PZsrAVqqiP-EfVs-0jTgxsPILW5ya_Lkxs4FNvUMV00I3A>
    <xmx:ouwfaqtJQPQRdRGCSDlzv7oyJj2hWevC-qAmYiniqjt8Bubu_25WPg>
    <xmx:ouwfai_l9FuzR3F73C0xJHJLI6BrnbgCXaJCGZTs31csy6qmGWmmEQ>
    <xmx:ouwfauR1k_z1hiMDOUWOdTJsWToATwu--U1XlEgRSm3i3JLjPhl_jg>
    <xmx:ouwfaoCm3jrQTsvC8JSjjw2cVnzpsLJPRFYPY4I2sfuqg_7otMeSlp9g>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 77D33182007A; Wed,  3 Jun 2026 04:58:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 03 Jun 2026 10:57:49 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Will Deacon" <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, kernel-team@android.com,
 linux-kernel@vger.kernel.org, "Mark Rutland" <mark.rutland@arm.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>, "Liz Prucka" <lizprucka@google.com>,
 "Seth Jenkins" <sethjenkins@google.com>, "Kees Cook" <kees@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, maz@kernel.org
Message-Id: <2c7929d4-6622-475d-af1b-bcd0cd997cd3@app.fastmail.com>
In-Reply-To: <178041415770.4024555.11336437584927054639.b4-ty@kernel.org>
References: <20260529150150.1670604-17-ardb+git@google.com>
 <178041415770.4024555.11336437584927054639.b4-ty@kernel.org>
Subject: Re: [PATCH v7 00/15] arm64: Unmap linear alias of kernel data/bss
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 422D140005
X-Rspam-User: 
X-Stat-Signature: 4ebn4cdqbjajeoz6kxtx8sbobcecbwxx
X-Rspamd-Server: rspam08
X-HE-Tag: 1780477093-692785
X-HE-Meta: U2FsdGVkX18Xo4DrN15MIFB7uOgMOrxw3xRBn/esElN1SZANc0FP6VTjJ8RCfUxAW9j6f2pj16Lhk3pyfTS56xz/B3qO2Kw6fLgz95gW/A4OyI4CmaTL0Jq/qcCc7GXqKv09SMf1EYHtnW5AOgUCoRze7PRw70/lWNo8cgLcQxCk5phZIjyQ38IvwLJqJZDpGDf10XBeFtX6fTLqbZhG5l1FBQFFnT4b3GUTi9O9OdASJuUDpz8JWNJoRIpFms2JsnZGm9eqOAcudj4MGcG1lPPHOqmAD/E0sloCl1wjmwnfGSVnaKcpDnn4TtRJ7vbgbNLzl+xg26D81TUJrNsF4y3fOQcsAlKQXK7Gbv3Ks1zHTu4U+0xMEPxjPl5VlNk7DokZOPK0qdQOaknAlIUjpyXKJqLgX9ry9cl1APCVt7RiGuqkp/yz6o9qXZt5j8SkR3uq8bIkgOa/OonpFXYP9Hz+ZyJCSq/7lWFGkxlVA2oN5ObygiXjOJ2xkNhWz6qVbIAQOnJF+DklrJB18Qv0btO/a5wLC2XXEAB2xi1mAlEPp50ChfTeU+Mg7ZOAVR2cG6pxiZVPyDESbBigzIzHwwy0Ej8oxsrAirwerjOJ6adP8elAY1X/byCx2QC6i3Ppjb6oA7SCY9lhBB3e+G0VARkTUheizDGQa/Uyto4OPnBhO6xWsl9+4kPwd/KolzVa8vQeosFrTtRG+UfINl65cTmxzHshGAz7PlmPYLEgh+vQmUf+oRdgZejemRrgP06VYX7RBij8vyX5IFpJj9BkJCzd9dQ9smLD1mYeSsyd+BYTnPpQbW+qQ/+VwrFwijr/wMWchFk0tEN5UDDpdDzk0zmftiSVob11wqASlytmndcT/i2IvfOw27+xeeDhIWw/BR8Jk8rXvnLlD13irw5/dXxN2ef8sBcFqTTdFjUPBqZe3r8boggmZldLTXfzc41AMcrBA/jfrF7cORJr+Kg
 Q1WxupWw
 87fGwoBS5y8Q4DFmINkG3FajSbzbUd9jdbHYJU+n8zp2D6U/gjOLTKS4QuZD4PZosREopnKU9pOhWzboumhmF6xxq5jHtGS5c7l2dTpNUREMGJo16ao0o0JSZ6uNr/UZTErn5X5VwtulglsHwi/jsi5hO4prAXpUMpqZWC3TXgt8i/17uFhSZGRHKiwMviseFAiQh49yhWwxK8/woKbcafyO7p/30R7FJrFNfPsjOM69f9roDvN1xgYjAkYs2g4xZqW75bbTXB5CR09uNGVazyS1B+EmytJnNhP3JLQDEt/H1N0dY7nhd5qC9fLQot/5mUm0Z8HgmlFy7jPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc Marc)

On Tue, 2 Jun 2026, at 22:34, Will Deacon wrote:
> On Fri, 29 May 2026 17:01:51 +0200, Ard Biesheuvel wrote:
>> One of the reasons the lack of randomization of the linear map on arm64
>> is considered problematic is the fact that bootloaders adhering to the
>> original arm64 boot protocol (i.e., a substantial fraction of all
>> Android phones) may place the kernel at the base of DRAM, and therefore
>> at the base of the non-randomized linear map. This puts a writable alias
>> of the kernel's data and bss regions at a predictable location, removing
>> the need for an attacker to guess where KASLR mapped the kernel.
>> 
>> [...]
>
> It would've been nice to hear from the ppc folks on patch 11, but I've
> picked it up on the assumption that they'll love the negative diff stat.
> Worst case, we can drop/revert stuff if they have late objections.
>

Thanks.

There is a de facto ack from Michael Ellerman in the Link:, which is why
I included it.

Note that Sashiko found an issue with KVM+MTE, where a read-only mapping
of the zero page in the linear map may result in issues:

"""
Does moving the zero page to .rodata (or unmapping/read-only mapping its
linear alias) expose a guest-to-host denial of service with KVM and MTE?
When an MTE-enabled KVM guest reads an unmapped memory address, KVM handles
the stage-2 fault by mapping the host's shared zero page. KVM will then
call sanitise_mte_tags() in arch/arm64/kvm/mmu.c.
Since the PG_mte_tagged flag is never set on the zero page, KVM's
try_page_mte_tagging() succeeds, and it calls mte_clear_page_tags().
This executes the STGM instruction using the zero page's linear map alias.
If this alias is read-only or unmapped, won't the STGM instruction trigger
a synchronous permission fault or translation fault in EL1, causing a host
kernel panic?
"""

Marc seems to think it is legit, so I came up with the following (I'll send
it out separately with another pair of tweaks):

-------8<------------
From: Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] arm64: mte: Disregard the zero page explicitly for
 manipulating tags

The zero page is conceptually immutable, and will be moved into .rodata
to prevent inadvertent corruption.

Prepare the MTE code for this, by ensuring that the zero page is never
taken into account for tag manipulation, given that those actions will
no longer be permitted on the read-only alias of .rodata in the linear
map.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 7f7b97e09996..093b34944aee 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -80,6 +80,11 @@ static inline bool page_mte_tagged(struct page *page)
  */
 static inline bool try_page_mte_tagging(struct page *page)
 {
+       extern struct page *__zero_page;
+
+       if (page == __zero_page)
+               return false;
+
        VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
 
        if (!test_and_set_bit(PG_mte_lock, &page->flags.f))

