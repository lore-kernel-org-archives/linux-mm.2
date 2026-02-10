Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29570EA8123
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BC16B0005; Tue, 10 Feb 2026 09:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639B76B0088; Tue, 10 Feb 2026 09:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BCF6B0089; Tue, 10 Feb 2026 09:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 400B36B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:50:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3C3945A6E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:50:20 +0000 (UTC)
X-FDA: 84428832600.04.CDE7792
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D7C51C0010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:50:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3ex2H+6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770735019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNWP9iqlvwh83wB1j0uD2/DZwiUKhBK19x4095q7W6o=;
	b=goeAiRW9gzBSn/GsBdTVOjlxtLYsNUaBByE4mYUkTcWfi0FnhOCyYReMjRgeIEkA1YssSA
	ZjZrPnnb4rOwTV7kRMD/+8lWm1G5bGPOT9KY8Hvv4+rqH7QF5JefU9lRaRq8k4+Q8cJ6Yc
	TIrGW3IV1jzvxOl66xv0hsHwNsiYDYc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3ex2H+6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770735019; a=rsa-sha256;
	cv=none;
	b=K8nbtmdbIPD6vu4Mfby2Xo2uNiPhTSwzKNUlXHNG5iXtogBBdhT+gP+EBQWCU6gZcV3SoD
	j7nKq/yTWJYp10M1kKWgEx0Aeq2XanL2lJLCokovGtfsfXW16yHGwkg/VYoob2nZ13/Ybe
	0s171+aFGDL/00zzV2jTVpZFotORtyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BDB860137;
	Tue, 10 Feb 2026 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E02CC116C6;
	Tue, 10 Feb 2026 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770735018;
	bh=YqNhqDan6ig5Eg8FfWiJBfgfNLXjdOvNf1vIcFRh5H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W3ex2H+6njMxfdkQtt4hfXP8xNYoYvUybMgCjkdXkRHCgKGQQudxPVj6r6Yq4X87J
	 qKQk4SPbkNxJjifgbRHYB0LIbaEKgNT1q7EAGZDodtYWpYtXt+PLTjreRRyYh0ZuB+
	 0XRCg3HQoTLA4LhyIdFuLZzdVr/SSw9/Ndr1QL+8Jlw7RzN+PIW/LRCopkpQH6Rwal
	 J24gsB2JhUZnmKMnS2yaIoTinVPtyDQgj4UHrG750qhTNlhIvb22kewZVjFgo8FCOz
	 fm9CerA5/tgkSQquoEeuWIQfz2qcaZ22uCaDVSNGjTWlgBnoS+i6Uy7a10vU89BO1/
	 TkxTBVLkg+EFQ==
Date: Tue, 10 Feb 2026 16:50:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v2 2/4] mm: rename my_zero_pfn() to zero_pfn()
Message-ID: <aYtFmCQQMYkZh7Wh@kernel.org>
References: <20260209144058.2092871-1-rppt@kernel.org>
 <20260209144058.2092871-3-rppt@kernel.org>
 <0f15b363-a5e5-4a58-89b0-13b5112772b0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f15b363-a5e5-4a58-89b0-13b5112772b0@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D7C51C0010
X-Stat-Signature: uk7j476i3go7pxq88jcby4a57ddz3yoq
X-Rspam-User: 
X-HE-Tag: 1770735019-935886
X-HE-Meta: U2FsdGVkX1/Ov8jqpp4Nd3TrQP+Q9UqWxxhseuUjeLd+SM/wZE/ZBUbt9zJr/S+gsxSGRLIm8uZr03rhZpxh6B7rY1l17yHWjdNqMj6PKBE4vb6DY9dNZsa9AmqEGjs36/56rkwV7bXuvtpLV40msMiKeODzMQtuZVntXC3QFTQvOsD+vgGQIQmLblPaQt8BE3A5W8LBftr1Ij8BiBdTgQ9O0ZB4I65p15PowBXTX4/qbtM47D4hvYlWXdGRzYtggzzQs2THCBut2SUg30O8cyTGnkxypDleCwfHl5Q+nNUMyptoJmeom5/Er/wff8z1sVVft0spHJEwzyzcJHGd8MA61zqvHP5x39DBXyqi9Ae6hgHGooYbdD4v0eSFhHopd3Suz3LbZXcom2Ozhogv79OCOElLpnMd/cfqC/xbgXdUgfPbykdo7pG+8LrDfAHO+1BRqreoNq2MTiDc1ocIprviey5m0nIsVx0AR/DD/PXhYOpiJfx9TnN6CEnL1N5JK1TB8Mcm5rlJp9Lbfehv3RhRTdCvB2wzq/GagjzhiyPS2GQHxgZpNmDTsJ4Sk5VB0SQgPUnAIlWB19d4HW3cCzg92RFs1AilOf5mt1tjQQ1eA6sD+kaBB11uvBVotPKhZC5zwHnIzZPMRE0LAisx+NFrxCT92N7vNwV1FTqRkaqBsvqH76dO/rBuntaX6cLlVdrHccbVcj9TXMsjpQnmPXqOe0S91D3YwOq9QV1fQ8KNRaQNgiLiD02CfVaTNvMmMzzfwpfWsMN1N5TQ8/SPCxttmWyqdkhmnrfJNKBkTGLXLdSG7WpzoLDHdaUaLTANQ6NjZf51C81Ifq7UManEyyLMrjKYex4DLSXEPDiHRlStsjX0vU1e4T0F2X/7PD8SqObMIga7txjYtpXXrAHwNJSr2fZUp3SEfxGkKfVXHSmxe6WYb/HilBdM845thDyQwlJPmLtX7AUnTfmMAsH
 IrW9lh1K
 QMHjY0IO5gKZ6mqzLs+QknHuHIsyvrYVZYFg+mUxvIKheSHf8MJv5eNrmGEVPqJRGKv3ssa0nlQGNIqF6eTAqLgJm8oepKKSPOG3Eh5jUfuYCptk+rjcYJ+xwOgT19tw3b55/UuTKDedjlxgHhUsf7WGMBD9ZnnL6WNFqxWxxvO+7dofBa0lNyIJpiNJkZeX71Hh3y+UJA0p6UTcZdtJtqLXDEefSkozB/mHlMt1Q8IS18V7h8dryORvd0k9sQLhR0bieow75UpOj6+frFzwH34fPuPFoQD6yu0kTvtWevXVtQm77/7g7JjXoyicXMZcV8pHXaYfyN/TI3+twDar5TBRdHIlBJYxFs1fI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 04:08:32PM +0100, Christophe Leroy (CS GROUP) wrote:
> 
> 
> Le 09/02/2026 à 15:40, Mike Rapoport a écrit :
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > my_zero_pfn() is a silly name.
> > 
> > Rename zero_pfn variable to zero_page_pfn and my_zero_pfn() function to
> > zero_pfn().
> > 
> > While on it, move extern declarations of zero_page_pfn outside the
> > functions that use it and add a comment about what ZERO_PAGE is.
> 
> I guess the idea of the extern declaration being inside its only external
> users was to ensure nobody would start using it directly, hence bypassing
> the overloadable helpers.
> 
> Should we at least call the variable __zero_page_pfn instead in order to
> warn people that using it directly requires care ?

I'd better move it back inside the helpers.
 
> Christophe
> 

-- 
Sincerely yours,
Mike.

