Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A53C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2086B00B9; Mon, 13 Jul 2026 13:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692AF6B00C2; Mon, 13 Jul 2026 13:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8796B00BF; Mon, 13 Jul 2026 13:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 368C66B00B9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:21:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9B51120138
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:21:52 +0000 (UTC)
X-FDA: 84984420864.08.CAF04B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A720280006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:21:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbA1rChv;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZOphvSkd23b/TrtduYCguYGvr5EK1HZzl/qohcfY7U=;
	b=n+C57jibBQnMQ3dNK2d6uLFOZxjdfEy4vGYfh65I14ka93oaQpJDETOi4do+bLT818AmQn
	XVmhL1Yzi84WSS7dyr3zUCGYpaIPSU6oJD4ziICZiEfY9o8suyixA8044vrRm4EEN85bxn
	ucre0t+cZZbjcp26JGccSNwPZyKa9Ko=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbA1rChv;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963310;
	b=JzuTYxcpmaWtc+++HNCSDNshnCJFvb+14KJ62HARFhGIyTBftButIKzmnQouiPQamWAss8
	3zSrbTkdHJry4etM68kvsp4EATTG2rqY92mXuUNXq7FCC8HRSPPe9Xo0U1uu+K6VS9JBqA
	UxKizIgnUPqFSGiIh9rlH2HBaDeHAFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEDAA40F32;
	Mon, 13 Jul 2026 17:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9451F00A3A;
	Mon, 13 Jul 2026 17:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783963309;
	bh=BZOphvSkd23b/TrtduYCguYGvr5EK1HZzl/qohcfY7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RbA1rChvxuFHpvQpDnMIbOC1D3+A+tbEwrNL6FcFMyHTv2MI7ERRrcjFRMIC41MMV
	 zEL6U0d7MDA65bCG2d3MXuGmAtBm57rcO1TmCOHrnU3cehgaHcdDSc79gsx63By+PK
	 UlSJhNlEFH2DfZ9kWrnUBoQwtzYZHb6ZXfqqNrRNq7qzhKRG/YSt/BfSKLJSBl9AFF
	 r0DF7trd+SNJRGpmtTwlsDn3a33tCGIxvmWxMGLraW+c12l9akDzYp1h4QVH95WRAN
	 YISJI8elk1Sn0+Kk5cubL6WxzT9XcyLW1zHetzzYJZeA1u4BkD5g5bgad9qZauwwQW
	 RS8GWg+1RL2dg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 598A2F40264;
	Mon, 13 Jul 2026 13:21:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 13 Jul 2026 13:21:48 -0400
X-ME-Sender: <xms:rB5VapuBuKvmIc8h0A0ZvoIBDABQaLm8a1-zwkAo_KS2Vst9rHqLkw>
    <xme:rB5ValtpRpThec3oyqDt1PihMsX3d7FvYGfhdfyax0gJncXqGyrzniaXTIbNNodOS
    y4LrnM542IJs8Z425sE0fD6mT7AqVuiL646qs6YryElQ8P6EmWI7ygg>
X-ME-Received: <xmr:rB5VakR6qfI90gNefqHgPJZUDIMGIF5b9qmTxw7rokqcgWzfUByGk8D3DawaSw>
X-ME-Proxy-Cause: dmFkZTE8vFJ9v3UZX0gql0WylFpu+0srIJpxxoXkBc60QmD6KjWRUGese9oi8JR+h7CtdO
    c5j/pE8W9f0Ds7zY0ofw7mKJEkPXT93kMsaRFp1A73bzp3g4oRGNfknkoKqHDrUJpcUDKe
    4S1qNW0VgsVyeO808aKfKoIkUyhtSmuQaEGoQPTZyPI8Ueh+5TQu7172ohN3cwuOIrThbI
    00w/uyeFrYmAMXYbrVagav1Avz5eB+onspWC2LgrR4amVPrKdwPc0R/NG0aeJmzmGACiYs
    gp/aKmPli6E5v6qzU3vrmb/NihRmn+O4LeV8cB1+umyMkp4jsNMhljH+KgvsWWBCjrVNq9
    mbUSM8sQzHH9TOl8eFIHcOozSUAnDSSXN9bgrjX/5U/l1UwIp73uXZdKre2K5WQxgSUL8L
    RIC+leW0C/NHDT678RvEBLQ/dHcGbwIW55LUhvhKfzX+lRH1V+W21jLvAAJjih/0wmho/K
    FoOIbOPf2E1zSRxbVeR/O0cj5otNJWDxiH7Z4Jz+1nFZRBP7l5mpUHDlUd6ejXuxPJ2OQu
    s6hzlmgL2u3nG/hQeXmAKQfMEuq//TVwdJV2NVbK+3IlDFIPmiOpeLmfn6Jl+7jfOwIvV5
    cSiQqtt28gaqgkV2dN5grNPpHxLfTueZELQCBJkzu9mxD3FKd3T7INWTKcCg
X-ME-Proxy: <xmx:rB5Vat05x0a8gVWVxI6YmJys8iMmvwxFhNIuTgjV1Py0XSlAzS0ozg>
    <xmx:rB5VarM3KUwYdO_HA_sYP81gL3qE-4wI9IRw9ypAEsdzSAxG6Wn85w>
    <xmx:rB5VagNgM8xVjeceZnL-PNUJU1zvieklfuMzjnaQQcDNBuSusEZNfg>
    <xmx:rB5Vajk2KNAct6hG-Xe9MnFUrFkQBrNby_FhWp_imlHtgd-0i_CAsw>
    <xmx:rB5VajA6XRsGOWHYpPY90PInCzmigjdjhLhmL_0cF77v4O-W8LriS9tJ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 13:21:47 -0400 (EDT)
Date: Mon, 13 Jul 2026 18:21:46 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v2 4/4] arm64: remove redundant concurrent
 ptdump UAF mitigation
Message-ID: <alUeafMBZtSp8XTd@thinkstation>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-4-ad134cc3a12a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712-series-vmap-race-fix-v2-4-ad134cc3a12a@kernel.org>
X-Stat-Signature: cxka9t4gpj97pq35tkkjsdnpkrbf9ebi
X-Rspamd-Queue-Id: A720280006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783963310-872650
X-HE-Meta: U2FsdGVkX18chBitMhW7YJpRWjFL9A0S8VfzrS4f1DS8QkFf6NfNs+V4vb4/xUjeRxmPgA2qF5gS3MC5xCIMxwK9ZlTHqVTMr6rYn0yRrpWUnXMVYUWQmxESlXJ492SW2D9jvrVBkwhmssA4xIg3ZOWhgGsqrdaQNOsrk4xHO2RslqzvTrjbnbRewba0A2+B86N5TeD/hoMX+1LJfgXmf2HzgeAoVGiLX8NCn41iBNV9eFeqzFIP7FLRFYyjsxmohIdODfLLbRLYAGrXnKWHKrUgCvJFFL5g4Eq3zqdGpQwBYGZ40LGsYHyFj8HHjJ3WF24xkWZKIr12J0YiK6MQfSdxYBjB6gaaM75iosCELgOiHwXef6zA27KdLGbTPOEohm27HlnuMOwWMI1l1/tpOUXANvMopgQZzcFxZ2P2ulCZjkvYbtCdR6GiHRoPJbaQc9gLbCEbEiXqF6CZBIwVOAKuwREqZaCCy0xKMctYkKOGxvjtHCNwbVW9JnKIP4y4arAznCk0f6t93S05MfUETQBkG886hOGIvVmJizoKVNTJ+s1v2Z6ap0IUDNKDF0ANKn7HcLl+Gk/fr5I8L/DMda91/yi8iU1ozhBbMv2A5kYNerf7lM8OLiBGPcvxlU6uXEGYSrpowDvZ+N1HfCVer29Ml01T+VB8d1Oh+tede8joQzE+wTZZcInXiBvwjw6AP+KTRId+nEboivX9/7CpZdGBlaDPGeWbjhRQ+IPmqWbXpr2oRTTkOYs57WkT3AY+QDH7Bjru+OyCNbKK1dnrM3ipTPH1XIu0AcC+VQzN7V6ofGtmSSKqDVrf3zBBMlEM/DihIHLvsDi7i+FnE1nok+NxQRDi93mbRJe9jZDQ6RJiHOWENTg2BxwPcI2l6I3nyshIUgV0hZ5o5yuMrAruZwnVnrgjOq4fjBgJgLAkZK1EfII0PNBV6uXujd6FrJmqhCgjPqDODDdrGY42Lj2
 3Xa/UsRZ
 EwAVD16fPntjmUIC9nLSkexDtqXArwGPRiDKGUwDE5l6NKoQ2RALYVtpciFWZFPIuZPht/JSLEKTFnRSQH+enjhdh3NWtLnWWLSgOvT9bGPH3qOC3/gdamyi7AGyKa5z7IrDVCP1i8gyZhOdtT6ihCMsdbuK8Z3mrGaZ3NKa4/rdFX7BILQkghH1ZaGLkXnB9vkWGx/1r6iiy2aAIMhhk9tBwju+FmPzY/uzfMsMggspO/vwga3CwVQXAXy2nE15Jlg56IpyVRA8Y2JgjG0WbmFqwBRR8sAr3ZkucEyR7a9PQLAU/g1qiiSF9+LUJdPnFBdPs0fuLVmSTH4IZ6rV1Ja5pW1S1OHsOFH2vA2Wzqt2bi0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 11:42:27AM +0100, Lorenzo Stoakes wrote:
> This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
> with ptdump"), retaining vmalloc-huge support but eliminating the now
> redundant mitigation against a race between huge vmap page table freeing
> and ptdump, as this issue has now been fixed at core.
> 
> We also simultaneously remove the arm64 if-deffery when acquiring the mmap
> read lock upon vmap huge page table promotion as it is no longer required.
> 
> Note that this patch relies on the preceding vmalloc patch, and should not
> be backported alone.
> 
> Fixes: fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
> Cc: stable@vger.kernel.org
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

