Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374A8E81A3B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915106B0005; Mon, 16 Feb 2026 10:33:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3986B0089; Mon, 16 Feb 2026 10:33:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4856B008A; Mon, 16 Feb 2026 10:33:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65D046B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:33:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 316E41A0E47
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:33:21 +0000 (UTC)
X-FDA: 84450713802.18.82FB32E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 27EF880003
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:33:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tiHc5c5U;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771255999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhBp4IB0DC7b+knYSxdPVW3d2+tIm/+0Qq5oq8wnDcI=;
	b=fFG8xXN+01NJR++GqiXDE5/LfeOZAdGJHA2DQtmy6rZyEOK8FQg2PnFY0lZILenmo+2ZXt
	W2T9ay7brgc97+uC3umTDE0D+RiPJjlTbj7n7lwvfzqiScz6rCy3ZhUOmnR9jjhi54Msrd
	4pVy2Gc37VfBv+EbEH3to+dsAz/5NII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771255999; a=rsa-sha256;
	cv=none;
	b=sx3PsgJblZuEoqxZdOskTSCGZxVTA4xa7mQTRXI53lSq/1D7uuorySzR0XwV8THwv6CgFp
	jquFGnii60muRZQPCuELiqUXWptLy02LzJoj8/Mugj0P6tW2YZFdhtvwHLJgVR2QGGcHvh
	scU7V3rm5CEe4l2Q14REaUQO6qnoRro=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tiHc5c5U;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFF4B4444A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA4FC2BC86;
	Mon, 16 Feb 2026 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771255997;
	bh=B/smNXNw4Eq3KyVVAhvZJb6xNJh9+uHMcx2/WDqg4cU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tiHc5c5UzYvP4Afd3mNQvDVeGkRHIRwpNvmVOits7L0jLKOGrN8EBwCK9j4kzpusL
	 G9UDAkoiCs6xQMp09NU6Fks7ZW5w9wSmYYDleIM4H28GQwPCYCQZjs5IYI030NgPRn
	 XMXwg5Kqn5pHMZK613d9xelr7fz1Jbl0vAbrgvt9jysDChCtyVvvloytszftUWdUyg
	 bGtw4eYyeNuhZrV0Zi/yqqs696IF+84SqelEz/Edt4oWIMraMRS4/EmLfr8XI+qeZG
	 MBYWIfv5MxIbQfgpV+zOBuIc30BJ4RgxEoLRu/twqsC+a/95nlqQLblgfzXVmu+sYP
	 m2k8oqDWh27tg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 976E5F4006A;
	Mon, 16 Feb 2026 10:33:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 16 Feb 2026 10:33:16 -0500
X-ME-Sender: <xms:vDiTacDSAOIBjjq_ukEMG__0o6a66lzpJD8v61xqxu17uQq7GCjcZA>
    <xme:vDiTaQJDe9Z26vK3U6F42wm3anYYwUQwZptbMHgJ_7Y8yC2jHfvLuj8La44MPnVts
    1IAG8ghrmpz7OH_rfxJa2cIIhakAIgfJ13bx6C8R71C-jTN1uPdIdr9>
X-ME-Received: <xmr:vDiTaTo5SfnyISE-jaO-yLWPCQJirTd5fPIvp-0jdmQyXdrckrlJaSs5nxdxhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehthhhomhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtoheprg
    hruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtohepsg
    hpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnheslhhinhhu
    gidrihhnthgvlhdrtghomhdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:vDiTaZMgIcEVnBpvG7yVREE8T4oE-WKD7zo-QhzrhSobf_ljajXhvg>
    <xmx:vDiTaQON3U3yuVrmO1ymreGtfhECvGTJvAHk0ICMAN309MZKfB9eWA>
    <xmx:vDiTab2vGs-FRXwAt0FeUFFufILsPjU-s4nzWnS2Pdq5-sVvqcb4bw>
    <xmx:vDiTaU2yqGh7bfH3c79I7qxpvI93z6rHtARiS2qmmno87060RqlDcg>
    <xmx:vDiTaazoo1EY_uuNPJwnKTniiHC3EncdC3ckKtec1TMiCRjmj_VwqL2k>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 10:33:16 -0500 (EST)
Date: Mon, 16 Feb 2026 15:33:15 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 2/2] efi: Align unaccepted memory range to page boundary
Message-ID: <aZM4fYf1bam_mo9V@thinkstation>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-3-kas@kernel.org>
 <86c040be-e91a-4d1d-a365-a3bf3772374f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c040be-e91a-4d1d-a365-a3bf3772374f@amd.com>
X-Rspamd-Queue-Id: 27EF880003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: acsy96y3e6kkc4uytkp8a8upfdygwpjp
X-HE-Tag: 1771255998-265910
X-HE-Meta: U2FsdGVkX1/wi5N7t0g7Bk4KrazGxEzTFvEXPETkc72SqY4nBbDUSfMr9/GtsZfpCMyS+xfQMBpg/EE7a3r38wlAOipJ4jcwhXzWDT2hn/gaNmx3UPFdUAbA6kBX3ECQyiXm1/Sb5jw4K/9Qnw9SMvc9FklHJm/qx3Ovle9ro1zgWCNHnAwxvboidyKqGy6INQrYb6cBRg3Uk63iUtqMKNwPPr6RqyWBMwHAi9ZST6fdEvbpo9T/2mL7Do0LrTM0Gflx0hATq3J/YDGvZizBa5QeDDsytmodxaBpR32/mIfsBvd599g3l14dnFXIgxxXUq9yoySHGdWpBiJXSN6lGrVmzbISHMsgI3d8LmkIxtUB8e7Bub0rO7ivstdQCGQNQUJ+vst7Efgh5z4svNO0jY21FHyzsosF9SDjrZMEqsg4kmKSKyP6SUOfEWMpgYAK1bWjYO+G0gRdw+dJM5t8TsZW7V3j4WhyOSZoIcL2Ic9Riu3FSnyfWY27+stpiKZDEIF+54l5Vt5m7RNRGexVmgnuGD7dILMYT1sankhhdROW0N1RyLLQ83SwP075QFOO1q+d/8hy9AeaU14gyw2jKT5eHwP3aRa0KKXX534lGXopzGAgCFgZvRAS4c5xybTuo0QsY3UnmIFm0RFh0GRgsMzrA7jt0Qb1/Be/e/YggbyJx7UYeiNRSKgMB1bGC2nySHB9W8piN0I+s7wHs5ToHI3ntji1eiRkN5GVPeuK2EJ7gYCfR68vBfmefFYHIPm8ZSGnhUHyHitj9AXq3S2YOxaR210OUDA8TWD09fXUQUDdc69pLLnuApJsi24Hn8WqL/W5Qek7YTtcwwuc5bDYR09A9fiHoeRXjnMvHN1/yMqEdgDipcdfMj21MFoLqD441U1/h681WfnVnVwclOGZKjAenyWERhn2tRw+YUVnzFMV6d9SfT/HZ9zJLDkansrjl1wax3H4tHU4AHWy3xR
 HYJCn8CC
 nb5UACcW+RnCDFW4H8l17TlpFxfGvjoLvvR8jt2R1VtdBRgiWTlRQhP61b9XHtjvB3mIS2TWe50mMEAlsjL1+Cyhqm8RsCXStiEx4+wVBwcojH/sQHCJxr58bxRCzRFi+/WEjjL6RwffqngTU1DwzFpyZpa1FFYCFo3TV8nbveXM8gUTcxxt0B7TE9G3ogEcZXI0e0V/Vg1tR0cVMKhE1JFXb9Y3v8pwyOHgxjCF77rwty3sPkoA0sgE4GetEjq6se3A5WC9JxPVfW9xwHLFr0SFSI5MWQV7EBpdmSB7QVBS3C//vsrK2r9LYZvQjfHV8L8Z7DqMY8Tc0CKxOdi1/QHykXhVeBehDC0NGE6fN1XcL1cjn6GP9uFYfYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 08:51:17AM -0600, Tom Lendacky wrote:
> On 2/13/26 09:48, Kiryl Shutsemau (Meta) wrote:
> > The accept_memory() and range_contains_unaccepted_memory() functions
> > employ a "guard page" logic to prevent crashes with load_unaligned_zeropad().
> > This logic extends the range to be accepted (or checked) by one unit_size
> > if the end of the range is aligned to a unit_size boundary.
> > 
> > However, if the caller passes a range that is not page-aligned, the
> > 'end' of the range might not be numerically aligned to unit_size, even
> > if it covers the last page of a unit. This causes the "if (!(end % unit_size))"
> > check to fail, skipping the necessary extension and leaving the next
> > unit unaccepted, which can lead to a kernel panic when accessed by
> > load_unaligned_zeropad().
> > 
> > Align the start address down and the size up to the nearest page
> > boundary before performing the unit_size alignment check. This ensures
> > that the guard unit is correctly added when the range effectively ends
> > on a unit boundary.
> > 
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  drivers/firmware/efi/unaccepted_memory.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
> > index c2c067eff634..9ddf3dedd514 100644
> > --- a/drivers/firmware/efi/unaccepted_memory.c
> > +++ b/drivers/firmware/efi/unaccepted_memory.c
> > @@ -35,14 +35,18 @@ void accept_memory(phys_addr_t start, unsigned long size)
> >  	struct efi_unaccepted_memory *unaccepted;
> >  	unsigned long range_start, range_end;
> >  	struct accept_range range, *entry;
> > -	phys_addr_t end = start + size;
> >  	unsigned long flags;
> > +	phys_addr_t end;
> >  	u64 unit_size;
> >  
> >  	unaccepted = efi_get_unaccepted_table();
> >  	if (!unaccepted)
> >  		return;
> >  
> > +	start = PAGE_ALIGN_DOWN(start);
> > +	size = PAGE_ALIGN(size);
> > +	end = start + size;
> 
> Should this really be:
> 
> 	end = PAGE_ALIGN(start + size);
> 	start = PAGE_ALIGN_DOWN(start);
> 
> ?

Doh! Yes, you are right.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

