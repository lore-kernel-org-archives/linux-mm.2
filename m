Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF90BC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 16:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4F76B008A; Sun, 12 Jul 2026 12:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985E46B008C; Sun, 12 Jul 2026 12:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873CA6B0092; Sun, 12 Jul 2026 12:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57C386B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:54:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDB0C12099E
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:54:30 +0000 (UTC)
X-FDA: 84980723100.22.FF2A863
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 65F9D180004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:54:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=hZd3B02y;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0mSGKSljGbp3wm1OkPuo0d6XMXK1FIsRCwQHXpgKVI=;
	b=zFKUrYlMt51ZB42+rwN/bpiWKeOcNCluE3/hQyTNkr0/IJE50ubMxwoxmF3p8f02/v61zu
	v1X4lExIOvv5rsG8xmrZQq1T5w6jMCEcOKN6d3RwgKrhTCxL5tjHF5WAP/CIoogjayrqaD
	z9JW7urvkAkxIt003yrIEXSieuoPOGo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=hZd3B02y;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875269;
	b=n1TFBEkvduOtGjJsQSku6xB/2/pk5KR3AdVSgl9SWYIfHJuWlhLEAcMdpxwoJNN15VqdS5
	QZFSjbeCxOklSASs3w+Td8uYSx1lAwfxMpGtIRJxeC3bEpyS0Nt1g1Ozr/rs5wgl/r+vqn
	XUVn7GHL7EMvaiUE0YNJdUv7s66MOqk=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0C99240E029F;
	Sun, 12 Jul 2026 16:54:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id srior6ed563w; Sun, 12 Jul 2026 16:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1783875255; bh=y0mSGKSljGbp3wm1OkPuo0d6XMXK1FIsRCwQHXpgKVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZd3B02yURgxnaN2bOuG5eS5BGaZkYAs2AweWjgF8MPvxxPq1Pt2vhEEqnCqz6wWA
	 8dNkaOdtd19u+IcSBM/HjAx7JcHZLN7A5upeotFOjvVZJuJPXZ2xLlJORfsSwePPkj
	 s2QScnUZnorDzAAJHT7r+lAsUwSUICK0TK1gzPA+4BNove0iPem796CCGh6+vQ2uTF
	 IaaWP96Soy2OIRtZQ4wj3sYYMzUU7eb9vJwS5dkoeTmPjJv/vViw09zNDbqo+F8B9q
	 AyltvY6d3w6OaBCUM9eOqQsnsnrBBcZmFjmra1vn3CEnFOv/wKIU6VNf/oyr4hwPGu
	 7M7+2UxNFU+pg0Lto33EIt9lKX7i+Z29412SELwxHS1ldaxuC8r38fIiiBJ/60gssa
	 pi0hvyvsYutR7Ji2QjYroHz3Tz4NoMG/Ar3Egs6W/tT79qOi1QngXwmUMBYQyqPoUH
	 Ruz1xqCCFqxR3bLPqeiF9m4mB9wan85MmnjIRAYyecU6ELmJSYolJcfG5wxdEz+Bdf
	 GsCumXAiqGmZg2okklasr3ESHBzuoOl7c9q1iHAJ7QaMfNvEci61R9mQ2/96kYvjQ6
	 X2EbOcc7yHrtpWfN6qHdZShRWsJAMFRBQB9QrCT/E+9KlUi/jyYAcpQpaMbn/8DBjw
	 Da+sRgL8/If7qfYW8RZJTeHc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 22D5740E00C3;
	Sun, 12 Jul 2026 16:53:45 +0000 (UTC)
Date: Sun, 12 Jul 2026 09:53:41 -0700
From: Borislav Petkov <bp@alien8.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v2 2/4] x86/mm/pat: acquire mmap lock on page
 table free to avoid ptdump UAF
Message-ID: <20260712165341.GAalPGldsKpBs5treJ@fat_crate.local>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-2-ad134cc3a12a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260712-series-vmap-race-fix-v2-2-ad134cc3a12a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65F9D180004
X-Stat-Signature: rtf4pu99ejbeptbkqxpbs3uw4ixtffy9
X-HE-Tag: 1783875268-727341
X-HE-Meta: U2FsdGVkX186QIiuPKC3M04+LREpXJ/3D48ExWYW6gVwcrSvRIKHDLzy/BnlUyrnh2TuWyui71P++3ffoS2h+ouxTIRcx84PEEbK645k9ZV1UAbbnVwstbv7CKswmBWZX/dMJPoYp4H81FjB6UEwsHM8ain3C6HbliiTSaWunRm36MJPsUAzBpwpnJ7Mjd4mtckttL4vFccdDXdTxftEd7hl7PC678++wc3wOy/SP3Ki3FWFhsCTWj6Dg1KxL/C0coLs1Q0BkkVmMMOWimE7ThH1CC4+baZsCHthQmmdVZWeoixoo4fCCOZobcYwdD8uKtehmfrBetfchH75nfmaXzd/F375pvs+otpjHqIZqnX/Ue+r94IYgLJMMvzp4VNMChCfTATbyiGhYARRcxjF55e++sos2z7hoKib+okL7tacJ5BxSMRMUIaTJ0oRRnpXi32krv7Hl+ts6oVPuce6YUMOVU2uhGXmK868h9+3aoboV7UZDDToA4ThKKSQ/xgsfhJYzRSxy5UZON5ONjLuLgoU5sJ2XsfGg+AE5Po8krgm/mu+CLFxrREQaBUl9wezj6Jk9FQzw0AoY45jkjT0IV+KwKcr7iytHfFT4+71o22xhEb06yAEzBV1p/Ra2A5MsOEs4PGA27tdJjKBbpyIUH9J5LmFJjS42iH0b6G19/xCZ3ls1H3X28oCOwRbqDKpP6n7fvsLJlLf8rreSm+EdvP5JbZG26qmIaEt9alM1U+b4uqWAWlQmy5UIMA7CtNU53p2l0m6VKE/2B50Mzza7628gJ+9WM+oDUFzm7Dg+EGOQcIH0Dcsye5YVQUl0EDp6WRDxt165wdG1jBZqey1rPouCwGJKrA3xzi1Ydz2FgwTCMOXwii8I6VcrUCTPgrQz2FRR7uyrNctFS5L2MMiFHRJO3U4AdfOEJ7fCafg8n8Mr2LKR3Ad4GNGPRLjQ7UnLuIlFBW4QvHIELGsIsh
 ud6qU4ax
 KBEs/E8Ad0jY+p+FnAUVVDXHqZhT6XJ35vInPvbJ5eF7rv18yvOoQcAXA80GaeFx3mMnZ+YE7AAdJ0sqzBuIqO9eY7P0d6Q7GIekr+bOyKsk5Ot3SXacYfpNzVwhVFv9gAB3iH727ipuI8HEN8lVEQQhwxi864MAhKmdbgTbgOi4XCASAeI29YfPyCPcSmmYwHKCX1FhzrCjQCr4dXCuSQIvgKtz3u2wTFIJOJElwjHiPot6c17a+AsuVDcuHGH1oKt84GKN3l20nJZqhVKJ+k/m6ZCJ8HSKUbuAtePT9yDEpW8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 11:42:25AM +0100, Lorenzo Stoakes wrote:
> This patch resolves the issue by acquiring the mmap read lock on init_mm to

s/This patch resolves/Resolve/

> provide mutual exclusion against ptdump, which acquires the init_mm write
> lock.

...

> We also include cleanup.h in order to use a scoped_guard() to implement
> this cleanly.

You don't need to explain that.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

