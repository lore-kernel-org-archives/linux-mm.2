Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C37CCD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F386B0005; Fri, 12 Jun 2026 11:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26CA6B0092; Fri, 12 Jun 2026 11:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9637D6B0093; Fri, 12 Jun 2026 11:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4916B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:10:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E19B140179
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:10:43 +0000 (UTC)
X-FDA: 84871597566.05.B6F0DAC
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B77C14000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:10:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RXwhgZpx;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781277041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+wHGQUoTaWREIUgxGSBFddc2d96JHLcrCAUtlqMtQg=;
	b=x3CpGzogO+W3mTYw0BG86u6iLS74gB1XpFUBC7elgPyehV8rHmFYN+TY6gV4XEOk8FPxhk
	KZuqs0u0gvulW+o407v3gK66Lt4HSfxsMB+95LRyLOYPoPUJk0QzQhWrt5uwO8MacQJW9T
	NclAcpZoMfkZeYaKsrhZm1PPmaQok8o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RXwhgZpx;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781277041;
	b=8ML8IUWwBs8wNyUwUrN1EzTlnXYZfmwznlh1c/AJqaQhjVtxv74Uwf46AvQF0sEhR3kHE9
	OEwV3LjB1+h3tXqAPTJdqcM6GNBdho1GP55Ds5GOFVBhT+pFdOdRzLMGTK9rGsgZ3n+Qk4
	6EA7VvWuX+AzmkUxNjhrCewJ9fPTgWI=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ef7720385so122082f8f.3
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781277039; x=1781881839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+wHGQUoTaWREIUgxGSBFddc2d96JHLcrCAUtlqMtQg=;
        b=RXwhgZpxKDgxmeS/RDthcwWexgoY2KxIq0HG/Nc1tkJ5bJyE5VAVz+0K4pkdFLlrAd
         ovmo3s7+5SjBvIBYZg7rG1nzjzi74Mkl9mzPGuEfu/OWw1dTX0VlbOqznDDE6yaPhaDv
         tgsQGs8EumdSjmZu+2052KDEV4jfmCaBTrdaH6SW4MYKbHmAGroc6rN6xinSVmSX+G0q
         5OTaTxX+lHfzhqh26/X/XqrKYou6Yz4sXBXLRXH7r59U/ddP+cySqKKRmN0zMClqiX+l
         nt+WW/4I+d7U6RfyQWO++TF86L6oUSlmf49VqNlSlhNpbK1lOePF7JmDnf9r0F8UhKY/
         Ckpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781277039; x=1781881839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+wHGQUoTaWREIUgxGSBFddc2d96JHLcrCAUtlqMtQg=;
        b=ZeljtsybCiNhgFsBdmO3y5+fVmn4LdEgbee5hmtLPpUBPJHFAnGjxy6u1HSnrgALMb
         KrZIgq6awBhFIrk0Dys+h53XeIb8A7wDjRwxfYSJR9j3AiQhuiYrAFklR5no8f72nUuv
         8EFAIOd8GH/bhNVXaVV0hlh0dsJpkCHOHEZiUgIZZrBi4wS/0FwdsLQSD/dcMbgyMjWt
         /QNbiQum/rj669D+GAVgSu6auupOrGCTbB5TaPSmh4i1hn7a9HgtloQFwJwcFP4soMY7
         0kRi7m/+87rxUp3EqTSy0T9u7HFqsVaBqcyCcE2cSrqZ2t9Oq5okb0PKgrBLSM8HZjAb
         ZU1A==
X-Forwarded-Encrypted: i=1; AFNElJ8WMybFHEvettgYOKxbR07s1jjzNRliV92HCaXfwk4v+IxLC6IFxY9z0+SaFGEtJuv3oIv59AKRXQ==@kvack.org
X-Gm-Message-State: AOJu0YxHsxQPfLf9MOQ3Pwwi0VQTgk1KSIS2m9p+Muiebguca4GHa+ip
	v1sGs6aUmQv9k2DFhFoGcuOygbjWNTzJZPWtAPOogDLTdnvPVC113/TN7qr21BrPr7Q=
X-Gm-Gg: Acq92OFP9nX3v+RZBE4ujazKN6sbdbLwJIAWokoGf26P8hCd9eGnYUYuYHGDmtpR3+9
	WV4O4BcsUu/9kzgGpAmVVSQvDLXs3mBgk7IOSmsavv55quXwP6YzhgV7NfJyRn9iybVoX+m5+fw
	zAtogEZs/x/Fq5n4gIBCS93g6UJSO9dQI/+OTRbYJX9EVP6FZyNYytcVPZafT2PY9z5fMVilyiz
	eIWsDJ0DR3/0RQOj3y2Dk5OVntytQX06u+OpPRYVWAJMlhPhg6Pdnz8FjqRPBV0Y9U65Ns4Lq2h
	he94UAL9wJWAJCBR6Mdnqrh/THfDqobeM1ONb9Il2qAA3+nOqBUxxAAPU4GGN6hg5XA4Z0AeSoQ
	6LAx4UFdU1Ftzib8yzdNpG2tUXUnoYUbo0IpSaf3ICSuuMDWtJdn4qFLLpubgaG9ork0/9I4mli
	6j/9ZuZw/hG9OcQUnmXcwN1b8BED69Dy5SStRT0ki/hLUn9N8wsP2evwUBACxQSbXNV4/lypMBx
	iCTDoLZ2Tnr+Q2OHj7RPf/mPmo=
X-Received: by 2002:a05:6000:188e:b0:450:4980:b4fe with SMTP id ffacd0b85a97d-4606da5d5bemr2432538f8f.2.1781277039385;
        Fri, 12 Jun 2026 08:10:39 -0700 (PDT)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f23fsm6636334f8f.9.2026.06.12.08.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 08:10:38 -0700 (PDT)
Date: Fri, 12 Jun 2026 17:10:36 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
Message-ID: <20260612171036.0bb6a2ed@mordecai>
In-Reply-To: <fb652b0a-9c3e-48bf-a301-16d37f212aca@kernel.org>
References: <20260612085052.59291-1-ptesarik@suse.com>
	<fb652b0a-9c3e-48bf-a301-16d37f212aca@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1B77C14000F
X-Stat-Signature: yhytgh1gugmuuyn5ihdf33kg9kxrs49u
X-Rspam-User: 
X-HE-Tag: 1781277040-552127
X-HE-Meta: U2FsdGVkX1+0xJmehAKT4mDQdeKf0BlSybaNm8iUtndYPDjZWYhsJvXCiIecGkQutFqpFK7cd+JUOQ5SUetnW7ex7BkP0s6W6rNDnailGbZ3s8BjPDK3ToPNISAEpp9W5Hw65ZPvsmCBYV4QTvEiufQk/yWYFyLLmwVFhvtJ32zL4yuY5ZjWHqu+fDKYyO+7BXGhJceoD0Q6BDDCI+vm9b4cYrv9ZmkCcMz53oHMsbe8Xs5/q+mFxwDF2iM3jjHi4DlrscRX2FE8yf1NNWzu16yrOl35yo1sKbMCzBb2PTfg2ZSbP6uIt9CglJmWiwRKx5YXt/mBV0E2/sOP5oewOBOhypxFl0jHVca/1NjCkQua9Ud0kzNJt4nX6Zvl2znHJGfxwCu9I7la3hoEMEZLws8UMPR9Xo+s4BB6Sl4ECrVbACcUhI3RHeJRyT59JKBfX439uHRQR/N1DCKqmXy43lWDJJg+JVC8SkSL8MUn3L/4OEHbfmlwwm/I1AW7f0MU7xWwrIiz1Ey5aZbEV1BPxgkYZd804RGhDK9059NiSPy1M37OLIe4HYLLCZhiv+xZgyNeZXM/crnonXj4hTUY8ITn5xkdWT8Bbh7SnkI8mgZfHG3a7VzE3m3kB1S2ey10corbnQwS+ynb1S/kbNdX8LARdPV/WSSIf/QNprXgpY8hbe2pUyM2sTSGTuM3jK2/Q+vLWEmUokX3hzHYkkGNd6oCUsBKWjvlftp7kcqWFRgbtTlHP1oIEqlR2mULGz6m2mWa0oh4nNh08nbVX1UJ3NczT5ecoEBlj/CcX5lRPE72a9FHdLZcKVixV7KkxFLmVcq9hUN8ry1cNgPl4C7zeH32TIoshgNdMgvBNK5sTX7yTRDXUBYdnZzQcPTlDhzc4GDStuQ8A15HAUaafJlF0f0C1c4a7hHr27qhCwcrmOrhT8ZAFVvPDQGiMv3OT9L4JDGi2tmGFO1VyZeNoCD
 2RdtSF/G
 TwNb2t/MJ/CkBskxv/D0TVKgiO1ScHPOW6ok2Oa+8XtXAJ/+XEl1HRMoSeYZS5gL+/X5qKnZWn1FW/6bDXyFwxOcNAzdYd9Pkmrl4PeRgCNM/Lt2yiCtveYjRHHSd+J8Fw4316nu3OQbQ+FnmEd4aImAVFQj1vtZjWpnyaXrQheVwJtONvRANg8rjPXTwawD+lwECt0cfFjzxUcUYysAphyWmvg3zfp1ev899ccMsPVoIgpjiQtDMBCbFcoDXeXQNToR+wD9M+zJ2P0bO2ZlvOeX+6P5gVlam4YP3x9TR2AJw1Fl9kwPmxuqA15W/n6CRpdCqbYYu+FZ7NhO2OjCsYLooPTgXc/PLTQ5Ucx57/LnlJML+y47VdcIXPccO83GICwPf0CqJ28xGX6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 16:57:08 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 6/12/26 10:50, Petr Tesarik wrote:
> > Change node_reclaim() to return an enum indicating whether any
> > pages have been reclaimed, because that's all the information
> > needed by the only caller, get_page_from_freelist().
> > 
> > This leads to the following translation of the old macro
> > identifiers to the new enum values:
> > 
> > - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
> > - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
> > - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
> > - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS  
> 
> Why not simply return the number of reclaimed pages (0 vs > 0)? I agree that a
> bool is not good.
> 
> Or if that is not good enough (for some reason) return 0 (success) vs. -ENOENT?

I don't have a strong opinion, except I hate the current code. ;-)

If we can agree that get_page_from_freelist() need not recheck with
zone_watermark_ok() after __node_reclaim() returns zero, then I believe
the cleanest option is to return the number of pages (zero if reclaim
was not even attempted).

Petr T

