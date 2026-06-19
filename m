Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF2FCD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 02:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E916B0088; Thu, 18 Jun 2026 22:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFC86B008C; Thu, 18 Jun 2026 22:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE996B0092; Thu, 18 Jun 2026 22:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 976FC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:56:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AC3B1402F3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:56:05 +0000 (UTC)
X-FDA: 84895147890.27.1BDC45E
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 930B640005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:56:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kbpzKunw;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781837763;
	b=xHL2F8m2BFrbzBI7j/lpuZATzcD6q81U6V2EO4HFh8DeSfpAbISBOsUkeksfScAYjfekHE
	SpH7tkBkrJconUGX4KvamsHQYxijHjD05XcExrZyKQ2drCAx/1vsZECooGpF2VU6NaAR4E
	pt8/2Hqsl2H/nwrJjeO9LtmBBFuQ7Wg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kbpzKunw;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781837763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR502eUyUGulNUaHuA3K66FOsgg/TzOZgtCKKl0teww=;
	b=bwNrRjG6oEmHePNCjNuH7ecDBN0WkFjmd60t6OGi1D4Tozq78mN5smRJqC2cotP7e4qQgT
	ztEOETFKoSQU7tntkLMDVz5yBHzf0fXvNZZrtWvjAisefQhbaHB3uOqPYD7WJYq3hUhK8D
	p18XLiEErJN+e4dGuxNkacRkgHu5WHs=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37c5dabff14so326870a91.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 19:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781837762; x=1782442562; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rR502eUyUGulNUaHuA3K66FOsgg/TzOZgtCKKl0teww=;
        b=kbpzKunwl2tegsvCe8SQPR7WzVK5tDW+60x4lxdYnerQJxdEjFv/YEYSdjaetkCRAP
         EvK6lTNPrGdO2GFyCydQUtCxpVp0fVvf3UB4/70IBrbCGH/etk/PuwEQAi7QbgThjaj2
         AZEqtt/Icucy4t8DtMEzpQjEwmet3ytKxP+Hi1CFK0zkA6vZtxtmimBDp8LkibHhVjB/
         e/AuJgbCyEi02YPE8F6Wfpc+1ajyma9HlGp2NHlOm9XLh8sAfKdIm0EgN91tSf7LXjkh
         hspAb5z9F7aXV0IuiSMPJU+8DTIiTpNzJ1Yqab8BpJ/C3LSvYm3DAXmroWwuOgR3ESkk
         QreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781837762; x=1782442562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rR502eUyUGulNUaHuA3K66FOsgg/TzOZgtCKKl0teww=;
        b=GoxVQfB6q+JZE6Q4kzhLZPNPCUdW1f59DAxh7GrlRnaCgZAM/eXEyVnkDiJqPbc+Jn
         NIc/v6WANA0PGFUutVIdX1eFt7aLevN02Eyixq5YLWHF4ATVT8kAW3wuKMSV3J8cepZ7
         H+p41X35bT5f22iKLHnzYWnmf5QYV7oy2jpvuuTdEkcE2pYM+e+aa4O+c+hyHpH5hF43
         Xc9YXHN6ZqVGic3ore6Vr6Sg8+uDnGMru7e1izR77LW2c0CaBflZKGuHwB8vJix+wew2
         b6uP0CwfRXyqMyfE2j7Ffk4gUd8DNIC8mdUwHkm51asc1drd+i0dg0/e6yC1hHiZBcPw
         cmjA==
X-Forwarded-Encrypted: i=1; AFNElJ/mfUzFpOlSPthw7EXAw1ZKd++ATrxDdlMC+i5PCFJJDNGXaX9TtKvcO3V+3ZjXHQb/53KZtGuhtw==@kvack.org
X-Gm-Message-State: AOJu0YyVeO/ynG1aR3CPA1JxL5QzWh9Yqv4HbwT9AY+BjXQeI+5fXBFE
	lmGDaS1TIRAC+iUEym+WYWRQW1d90jYx4sjB73Z8zQEB57flh+zFvQh7
X-Gm-Gg: AfdE7clEBSVw9dmNbi6+nHAPiOeRWKTn6/rVptIKbfflqZAsAs+pO8Ysxf88I0hLJ/1
	5e4BZYshSZcvyYzXpTC6WarQgSkFj7i7fygLmgIdvweGC3cMOWgimUNy0P305cdsQfDT/s8TRHF
	CF1fVFu9AUwaaT/DMkFulOT4gp7XzhR4uX931Oe/UZMTGv2JzaObO1Ngon3neJf+p5m9ZjkO4xI
	1HDrdyb2+mX7nZ/8aXTV/PYoSp8iXJ0kMVCKQUxpyuNaYpDk/xDygd1wUGe7jVUP3xGdwKaQT7n
	xG2+pXr684Tw1resWGdG17o7hs07nHzTOF0+++fADPP4z4NSvZLtTurO6nTqgz3HH2LPxfrMsfu
	/nj4AxdbodPdkYFY/6sAWn1RItYz477gtqtQl+q7sAohQEJwqP/duBGq/FeT088fSTn6PMxqGAY
	H0ZQfWkO+/pJesAKAdwwCabOppS0IGSWw+C0Pn0xqq9JlpMMuZWHej5i2g0Z0NV4xliynrvp01S
	V8=
X-Received: by 2002:a17:90a:d44e:b0:368:65d4:486b with SMTP id 98e67ed59e1d1-37d15e7ce51mr968458a91.3.1781837762400;
        Thu, 18 Jun 2026 19:56:02 -0700 (PDT)
Received: from fedora ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d153601c4sm1081418a91.3.2026.06.18.19.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 19:56:01 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: david@kernel.org
Cc: xueyuan.chen21@gmail.com,
	dave.hansen@intel.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Fri, 19 Jun 2026 10:55:53 +0800
Message-ID: <20260619025553.226940-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org>
References: <0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 930B640005
X-Stat-Signature: 4t5odayimwypm5x9tsrabaudff6fn8zg
X-HE-Tag: 1781837763-508923
X-HE-Meta: U2FsdGVkX1/poCSL5NBG5W98++0FbWzahSVkNKFXkKFWa7wp1k9PMCTpkgTkrSLqdhkyjGLSbK0HlujL/ixbD1N9xKti7KfaGj8mG2Ka5vgthStYmRBjBYmHfLrItVgJ8OYHxDnR1n65SVpVNRwORcew/GakA6RJIcnVGWQ+VX9IC0HNdiN/3+0ke+hLuEwxr9hIzzQwrKkdRgZsNy5CkgeXnMTkxMA35EOlQckOGYPJHi981XiFmtqUioKEWKFY/HHzzDisiT2bNafbf7pJNLUcj2HoOHPeUTr9w6ydWfFYECSxsP20iC0kurbAldDh+IWj1YW9l0ARXGIhG0IWqVAJZaQDts3x2jlhWr1LqXAP7rPNbruEy1EDR55zqFzF08hvl7aAkMnFqSAgWVQtl0UoSji9+JkLlbksIiRkpIDB4B8PwXSK3T0fzDD5O3DBumaHAOjF/5QcoGAsr95Bxmsyl6+eqcSP8r3xQD6tP+3wNYYPQ1JHOJBWYQMA6MmnXYa/07TNiT4XHV4J+f/hcP5JnfruolE8198pDC1UkXOW/jbaVPH7cb8px4TlHzXF4oAuaCdx3Ocj1n7+COxEWNMxgFT0SrNloh5LEu+9ipAYUOYyppeGaIUvaS7bge2XOB4GCYBPAB/IdkpWNJB1eV+NONKjRVpXohVm4Lwjxxa1uRm8n34cO6UAkKgKGvK7Nx443Swn6L2Er56TvaFVifLYmwiKgcIZE39ptJ8ETZFL/RHWESXeXJNZUn75xo7CHccNTzNETiFtUeuJTHpQtoW2eUDNI4fu5lgSgpqIndp6vGcJCtFDcC3pCEvmOmwvbZZRvYTZkIBNVIKIe4APt0HN6LESeBKgqcPZL5+t+fyuoN1vdKRp9MQ3Ne8Q8Y++gjI2vNSvYu+/dwscIk2+dF/gDNf5b30rg1AMCrM7Aa4BcGYENKtPCNbt3th4bRZYjhc23j7SAWjpAAja1Aj
 L4YvnY6L
 BQ+CIQycHqRXPkeqjx0C9n4fZHU6Xo1aAXGE8norozoqzKUkZA2p32rSXYy0q6voUqdUyOZQMX8GyiS1Y9oML1LPXoNr9POIIf14bMO4yitWMZzRaAHCAxj0S2dt3B3Xlfd2d2QbKPXEgTFPyKs8DgcQCQZ+7a6ktbavnWSVw5mC1pXaoPYdWZgIgZcT9jHALAF7usLjNEE1EuHG1u/AD9bf4lvbN4cZTzAMXfjj/2jxO+eMoktjrbZCqiofDsenCzpE01iToaEmMjIxwNcf/V1Qbl36RI584sJmCc1PaRP1PsgSMdinZ6+d82MQ1k+M24vRnIpyYpRnr5KpASuoEGYKkeT0ikudXx9oMGUMXa5O0UD9Enr2IzTYYS0sZyMg1LSSI7EVLT/fl82Zr3BDWIPsi9/8PIcgL9end/AVSTLsyJo7h0gjkIVienmvOUOCN78QTfTQ6fW5D0bYjEIiwnrIW0De56kzTlsYq2PSHX4rMPq6U6xhISG94DuefBV9tt14sCPXzQsEDB2AP1QjfUXATa7uhtFjwXvhnByxk7tRUujvXBaCY3os8eGfUaeomJUFc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 02:36:25PM +0200, David Hildenbrand (Arm) wrote:

Hi, David

[...]

>Best to wait for some feedback.

Sure.

>I do wonder whether we want to pass an address instead of a page.
>
>https://lore.kernel.org/r/20260410151746.61150-2-kalyazin@amazon.com
>
>Wants to convert existing ones as well.
>
>That would imply that the caller must check for highmem.
>
>But then, we could just use existing set_memory_ro(), right?
>

Agreed. Passing an address and reusing the existing set_memory_ro() 
definitely makes things simpler.

However, there is an arm64 specific limitation:
currently, the set_memory_r* api on arm64 only support the vmap
region and do not handle linear map addresses.

If we go this route, should I extend the arm64 set_memory_r*
implementation in the next version? The plan would be to make it check 
for the bblm2 feature and modify the linear map PTEs accordingly.
What do you think?

Thanks,
Xueyuan

