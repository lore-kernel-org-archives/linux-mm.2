Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1929CD0406
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D126B008A; Tue,  6 Jan 2026 12:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3706B0092; Tue,  6 Jan 2026 12:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5626B0093; Tue,  6 Jan 2026 12:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEDF6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:01:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0BBB1A05AD
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:01:54 +0000 (UTC)
X-FDA: 84302156148.06.1175BA2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id BD5144000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:01:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G6zbYrDv;
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767718912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znN9u1rx00Ujdtuljg4AicZD3FrU2Gurmfe0IyM3C2s=;
	b=GMYlSz+5hgS5ZXxWHseQyPVhkVmZKQEgU4VrNs1l6zUYOPO5DlSz20ANoZlczysrqORFOL
	egv2df708AajzpKCRDq/7lCmXxxwLgjMfovdC6p77h1gro2XBfKQ6n04LbmL9S0fY+QAxW
	1QT92X4CpQUDMeb+euoKnbiw4qMcmik=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G6zbYrDv;
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767718912; a=rsa-sha256;
	cv=none;
	b=OlXn/24lE8Ghp5pXkYo/JZ91DaDoL3gIfxoGli4U3WjgivRd53d18SOZzXTBKQv2r+6Khx
	L4XwDl0HBe6O3KyqBUPZ4Q9BQMVyYLnJYeE2BHToFWc7tJL8AKzCICpf7FsyAJbWRLrKRZ
	QS8jN2Dr2VjNGTX4V5q9cq/aLVaxW4c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767718912; x=1799254912;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=66nNnh+hYASbFrnrJVblDDAxh8AwBWRBrr0tlRRDAN8=;
  b=G6zbYrDvGjw2447kH1D2rnBVSHcWJDC5/8frJlk1HILsEnNaMho2LbZf
   ZVK9Jitw0cKN5o4YqEvHe7vNrJDtz2IW0+q/wqbJwwdypds9VO5JLTurX
   yGD8F5W2u7YJX/TYeyzSHFrbatnPCK8Y6SSNTNLve9JmH6CKvtPnyGGrL
   fkhjzjZKqbarho4jnSbiFw8QuyiZjGMKBf0fI4RynAisEGH/hHXPX+Xdh
   67r9M1HUJwIQJfZ1DWHSdhiZUC/1FbVRKeO8XsKtdlRCSYVaL1VBm5TAZ
   ZIksSfk+1IH19uVVQSpc917HCzBBZtrjMypqXK7C2ujKNuCwZJXtpV/9r
   Q==;
X-CSE-ConnectionGUID: yoIe07PbSDSD4y7FmtQdcQ==
X-CSE-MsgGUID: 1voAbGHGR3mXTZzMZMV2/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="56648181"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="56648181"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 09:01:50 -0800
X-CSE-ConnectionGUID: /TY0ur20TXq+NMWOME4bGg==
X-CSE-MsgGUID: TLUm/rBeQUa8grtixhw0uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="202318871"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.109.89]) ([10.125.109.89])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 09:01:49 -0800
Message-ID: <edaac01e-82f9-4b33-b417-cc32988aaf4a@intel.com>
Date: Tue, 6 Jan 2026 09:01:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
To: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andreas Larsson <andreas@gaisler.com>, Christophe Leroy
 <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Linus Walleij <linus.walleij@linaro.org>,
 Matthew Wilcox <willy@infradead.org>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Michal Simek <monstr@monstr.eu>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
 <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com>
 <bad18ad8-93e8-4150-a85e-a2852e243363@app.fastmail.com>
 <a2ce2849-e572-404c-9713-9283a43c09fe@intel.com>
 <25642e76-43d6-4b17-94a9-e7dc53512223@app.fastmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <25642e76-43d6-4b17-94a9-e7dc53512223@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: dpzhbme6hjhe1aeww9cj6idx7rocj6po
X-Rspam-User: 
X-Rspamd-Queue-Id: BD5144000B
X-HE-Tag: 1767718911-116462
X-HE-Meta: U2FsdGVkX19soTGwec3/A/Yjur7HkiocRIuBt77hJNyL78EjUW69AyEi8uPtxffhY0CZX+gwXGnjpDGQ3uLQ0ywMCqY5bv41vjqQEQCBN5Oa2gEjp6QPXQpPDq84olLbiglxKLWdBRJzeKDUqb+tjOx9LOGje8OQmCQCJFUGS0IXR4CG/FEH1IAkEVY8c9BEWWMtMoePzZlOY71bXEdw3jwaAhZUzNgxT+7BUxo1X3nWk3eWWcHILZQof3RpIereft4Pa3tcM5Oqp2On3qPltyxBK4L9sql3j06P0cAXDNrc/0zRZTBxFBSU4YRlOv3kED7YZLLXWlCrT+nbqRnC3rqeuueS/cGR7UqgEnnJqlB3v9diXHmNHPbAu4r2m7YvVTze1btFK2PV/Mdt1nkfeVOvdJLCstOHdc0BiCczDE7ycfbM/J+rAdc/Y61t5UecnzEjiCR4hrlYT+I1RX7TkifRBiyXIJHj1l5hgoo5Pgjm+xHOtyw86KOPKpgecirP64+hIbOas5JZF+a9iOxFyS7MUSq929faBMXh7Iycu6TkVCD012NF1cGAmD46ZJghnW1xy8V51shsrAOM4YwRdarND+bgrwPSsDg33W+xcxlMX8c4/LjCjL8UESxUmkwfd7hfK3mjm2qNNP7BM0B/ECyFrfZ5kjBWhN2uISmN2Ns2ADJkY/NVcnV86U7dM6IqGqZfj5POKHvumXmDyjEoWiK8m8fPP8y5CbXd8Ijk3syVlURzAxlUX/ADGZaKfahGX27U+w199GaGWVIBLmincMdFkAhU7wIzeC+DEv/fYfOqD+dKe8pwmGsJmglkwTr75P3ZlrapMbNhHUAmLGQhgeCWvCXApTDdJUg+2WTy3Mm5rlCmXUTf6uMkdFTcyOSNyx7G0/GliZ/eG85/WS45LO37ZGJAxWjQ28B26IDa/ZOdy8CEDmm1bI6GqW2b80YQyqD6ihWKKLhfb/YXzKh
 pD7zjqhs
 q8NwfuXzIsLcYsji3hgJ+SVt7/adLE7Ijwg+Wyiaazr4fli8unkGKdzxTuB3HYyBK5so3GOCGA/lFs+Ovi1kYnv1z5l1J0W5F22JBIM96TTLKeB8fs9dX4MzWh2IwZQLWWwb+rLWWHudw1Yhf5K4JwYH0qo7YN0aM3PrqoOdYOaybEaQCXZ0Ky5DlNtF5l2ZDuWRCz8hM7ptVa5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 04:17, Arnd Bergmann wrote:
...
> I'm fine with 
> 
> 	default VMSPLIT_2G_OPT if !X86_LPAE
> 	default VMSPLIT_2G
> 
> and dropping the VMSPLIT_3G_OPT default for non-highmem x86
> builds if you think that's better.

That's fine with me too.

