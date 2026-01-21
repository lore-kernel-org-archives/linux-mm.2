Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2AECC44503
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 11:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE666B0088; Wed, 21 Jan 2026 06:28:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B88A6B0089; Wed, 21 Jan 2026 06:28:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1A76B008A; Wed, 21 Jan 2026 06:28:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1D46B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:28:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECFBF160BC9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:28:22 +0000 (UTC)
X-FDA: 84355747644.06.FB8D960
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 723DE180005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:28:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=i2sYQIa0;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768994901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B352RQOxj5L54Ypl1KCHFVRl/50Losz2zzmn7hFplW0=;
	b=3lUb/7eDVjvjMdURQAntq/CZRvIRE+sK2/JgwSAG+lIUCIDiwSgxiKhqG7T31Znjr8G2HW
	ZyoUyIYHwJzqF0XfR/iWPx8LKpb4ATUk0EV0OdgsaoqgMAqY8ZUhUKG8HjL/xmoqKuLtkT
	2EthOtF3LSMamYIRxKGn4TbBcSgpbM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768994901; a=rsa-sha256;
	cv=none;
	b=u4eCU/e1ItOUhNpULmdOWq+RLgpKQBe7McFL0k6gaI3boPja/sCldaZpzFnlja3HJZ3bKf
	t3FMcROQxqdjoKO1rKRowRkId1zyw1xCZBMuhVJq7J/OiPzJym8n1YLVjefZPkmuZYoSEv
	ytXQ0WH3gQkoOHArp2OxBW9SE+mU8j0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=i2sYQIa0;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8E08440E0140;
	Wed, 21 Jan 2026 11:28:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tg_w-f0CnBCo; Wed, 21 Jan 2026 11:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768994893; bh=B352RQOxj5L54Ypl1KCHFVRl/50Losz2zzmn7hFplW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2sYQIa05ofTGzEbCJh8OzbPczhxkz6YncnnxF5YijSUG46hHIppHTFnwWpfXYVYW
	 sszzINaSPOacykWg9l+uVl0udqIs3LUCKnze3OjuhW0zBO5Nuzs9NU+dJv3BvGHTLe
	 onVgKc/SJvCQW/O092G6IBXjMM6QVRTsGcbLBWlvqdYib5XIhiEarQIRkNvEMAOuI4
	 UztnsDwCti+fwOW2c8fcIpBJw85nCHm0DfWGRiOrQBN+m99Wx+As8in+7SM80MkNk9
	 /8oVil3BwO86sOOj07lqQdpbmme6y4+1MBn/7wijTOLscDS/z8W3N+1ZS1U6ESjvoK
	 r8uLf4ikRfnuNqdOrlgBcdMwcV5Tj88gpCDjL5Cp8R0bR9pcGC3A3mZ0XjL6kSuz0j
	 uN0CpMY+A0jIT+iutpXurb05uG3b3xV9XEvAE/EBy22oGsdEjvgSpeh2A1rJM/L/ol
	 9uUa2orvo5a3z9t+apEyi5uFtHPmuy4RCbxdEsFIrysXkS2ZdiSohp+tiIRzGGmkXA
	 92eGtlUxon0Coxvq1UxM9VbYzQHC7kMljc4TznLgrRZTLpVEPCDCMzJbA9NeNb4YCo
	 mqSlrxBmCzGZQhrM9R43UJR85LgyIGbUfV0esumsmcDi/FEwUkPSzPUBDuZg8KQYPq
	 0z0ZpAN5xil4APG3LRMM1kWc=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id EA3B440E01A3;
	Wed, 21 Jan 2026 11:27:44 +0000 (UTC)
Date: Wed, 21 Jan 2026 12:27:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
Message-ID: <20260121112738.GBaXC4KgFQ2J667ea5@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
 <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
 <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com>
 <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
 <DD80374YZEWM.1L31D2VUKK80C@google.com>
 <20260120163728.GDaW-vSLGY1P_E0DqS@fat_crate.local>
 <DFU660CYC3H5.3L7IVBXG8AIY1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DFU660CYC3H5.3L7IVBXG8AIY1@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 723DE180005
X-Rspamd-Server: rspam12
X-Stat-Signature: 55hrk3wpnp45zqe8swah44sdgsi3y68s
X-HE-Tag: 1768994900-805133
X-HE-Meta: U2FsdGVkX18D1pT+ycyysg5q5uCcVyD0BXMSLfmkFO9CWGfAQyn4XdgIPs7vepgz3/FnR72wl3tbBm1YYWGrOhMhXBrdODI/Wl17CxtaXn6aLclCBTi/EijM5i+V1oIkszbUom4H7o9GWBXP1WqUHv3cuBOU4VN+ANTkyyj+rO6tlNF5x30IGhaM4C3IjUuU+dJ50U8ECHttHHoHohk83Qb0wBASrtiL4h95JYt6bn2nEErLrv3op4mXz9ya7mNFNDB71t+8bToyEPTS5OM8tL7ZItyc959ywBNcOQpWZfOdQ79v6Cq4O4oDbghFogn7BcWRlrfffwSLrKlIBAaCUTRW5UqHEuOtY9XPPdPGZIJgyiqBAYynLkPhWwEm/agQPHp3Lgp36XqvNNeUoFzbey8H4uqUTUrmDY89Vo+VGtgjK4VIy8BnfoifbFiMLASe9Qo9t38RNG3+wrEtWt64aqeSgUNnrwoS5wNiyqA4Mt5xGrh8/54vgADDsq3LerTwx+fumfrLEnErC4HvxYIxUlBsDxKoo/CGuTUZSqT9T3/rM/n82HG/VTlz++Rm+zIXjLANzIS4UavWqqBMEe6yrla+cNI9tPLKJOq4u+oOgHqmV6RtzO3xjCcFdCZh4pIG0Eu8IEEma5y0OaO3nl5B3BS3FUVkjT4Xg2vsGDiL+WVXF4at+bksoqFyGWYy6MKo935Gt/dlipkUF5S2au7ZuGAGb/nJZuAhU3kHbrU69igvPQP2XRECySRd6TLxf4L7SKqYNQDNr4Rmymi/kckmJ33QIOGj16+edBjvR+WD6cUMOkHpyIwhCkbbJvO/S2sO0wNwvZxOGhbJWwG7K2QJjm78Mnxv0iIyxm5NeCBnqcl1BThJykKpJq/wi/QPxP/PsOssPCuG4U7+OwZMPLENEN7mql1zSAxtdjjpbik7OUewuFhpLV3VffDvu28vLIR6phfW5iB73+mTgTiGIm/
 OyOEJazy
 BGynZeNXVX5qxcvMPwfslL6tXi6jxJzaj7L3/0bUUM+AmsnnyQcMMLERBUL9W+IuzSrXox4aAm0Vt2pL7PVNEWxjyBR4CBLWY/OfGEsTsc0hV5W95d+rPESQW85PasHtKOUX88aZlasHyVSfcPMKwe2hbFsWBf616dxeXIKb6lQ5tgzUH04yy0265zi9VOwn1WKUkm7XCfg30Ey6Lo6S4Dh0KYh3fCUP1eTSrKHdLaf6pleKEiDtdd2a0AvTfq6zdJPhL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 09:45:22AM +0000, Brendan Jackman wrote:
> 2. The property of some memory being mapped or unmapped in the
>    "restricted"/"partial"/"sensitive" address space (current patch's
>    terminology: sensitive/nonsensitive).

Why do we care about the sensitivity of memory? To the kernel it doesn't
matter whether memory is sensitive or not. You simply map it in the sensitive
page table or in the nonsensitive or in both.

Having a sensitive and nonsensitive pagetable should be enough. And that'll
make the whole concept a lot simpler.

I'd say.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

