Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7C7CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93398E0009; Mon,  8 Sep 2025 16:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A439B8E0001; Mon,  8 Sep 2025 16:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B4D8E0009; Mon,  8 Sep 2025 16:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0688E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:04:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 386FD1A021D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:04:46 +0000 (UTC)
X-FDA: 83867160972.15.FD0D48D
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 604CFA0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:04:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MfbvCMym;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757361884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S88T8D3xlLZknE8t5igiZlDLZ/Nmh2tAE9nrL4nfIIk=;
	b=Y5nfwlXN3z0CBz4wP3Up91jObmTZ0MFq/F75NJiI9zVGsuBCBRYo/TXhkQd+ZOEKAX3G/2
	iFuSSfPEPicXhkn9H1A/BinSAB+CyDpRBV119zHqwXpG8Unku8ZL+BlXIKrgwYaWSYLvv4
	+Mgza512khpzoaPMPyPhI2I7OBH3Myc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757361884; a=rsa-sha256;
	cv=none;
	b=IW60YSQFFbOUoQNFShJrOmUEiLUfeVvg0m85tcgOZTue8soq2nwkvlZylzlj3K37eNCrNW
	BXqeJxPuW+2fzFDmz46/xY/h2YkuGlgWEvBqFAR2yhGwX9on/+1F0NcCyHd041iN7HTI27
	Zn4a7h07Gg24CJ01Sbhq3TMIw2QstYM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MfbvCMym;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d603acc23so39910727b3.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757361883; x=1757966683; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S88T8D3xlLZknE8t5igiZlDLZ/Nmh2tAE9nrL4nfIIk=;
        b=MfbvCMymVIde4yO+RQ1cPBTKBPoyW/YifRcpiHju6P3sg1JW87HOX7WMqDCA+hi86i
         zhv4Bf7g01NGtAqU3EXTBWLYfY+wKvk7Fn13jqbgT33vgfcJJu4tBWmgkBwR3gHg8IVN
         mfKqVu5xZq3YSx/W33VmhoCU1vs3qjF68PyyWUaOZWVETuAABqwgLRTwb7GRanTeQo2t
         ABJ9zWr4no0Mj3k1PwFrBamIAabO6GrvABQcH1L/hpSc4xBawoTjAzSNNL6xyBWVR2Kr
         9HXO0/BU1qb06oAfOxM9kjqkfvguwgptvFBR8859ESEKXTaE2dUlcsPWwnDEcNzhF58P
         CFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757361883; x=1757966683;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S88T8D3xlLZknE8t5igiZlDLZ/Nmh2tAE9nrL4nfIIk=;
        b=pCw4MPThHQ5J/e7fn1mz7hE9svnhT2xKsCjm6C0FQS+dzdMqCae+XItKPaz7dTSHbP
         bPNEJrWWxbhxJO2B306vNkEkgNamU8XkviOdwSeOLgxw6EJTo06RWf1/XFpFknNh4Sjr
         f8FTDluSxhanyS92iG6SfyTsx2pgNfatJ5nMYjJMB3hzwluiV/cbycl6JaSKnYDlKGKc
         zghloo6EynvZwbnYQX3lnd19N51sx4Y554G1E707onwwDhxxRF/SxhAc7C35JpcXkGsT
         QaSvO13jW48i7KvDsOQCaVW6IW9BA31QR2aN8eWPDG63apwRANRds+qr8ynaH1tFgkga
         pMJw==
X-Forwarded-Encrypted: i=1; AJvYcCWnylY78uRdswdhEqBfX8LlyHvma4lxaPHMlrYe5h0VjRTWH5vPsI3zvVDUqy/qNaKc+2Uchocx9Q==@kvack.org
X-Gm-Message-State: AOJu0Yyi/C4w51k8rQk3JhICEjzDyyypApIF4GNkVbfZxZWs6yHxXWGb
	Vw0vZREcvlos/bUUSZlsvjWlzW+TV4wYSUNrGb0AymULA5BRPlRU7M6OnVm4FmnNjw==
X-Gm-Gg: ASbGnctRKa+Kve3oTZ2+0SPe+Lfw9HIy64R2foHzGZpCPq9kG2Hdzod90IsTzo65rM+
	kOH9w/gsBl+jkIippFotUAIkg5jsdsDmASiOuwZrq3iHOaznk+hFhuEsXYf1v5zt5wPpI1FJkVo
	ee74nrpkOBS7g3wH3WV/qsSc/SJIb0ezTeE3YA+d/jipK0t/FZ9vnx2Jk3ipE/sJ4bDBqF1Oqa1
	+0UFB6tJiqi5kQ1PMM4tkmekV1sClQzKdl7QNxnAJJAlKVB4cDlLWQdLdCcUhbzEQ11m5p7hs/C
	pr0sQn/7TowdDcolB/aPMVLVDtJ3YvpDWnHiOaAGKMnv2vhEYxEDBEFEdZMEGfsADdre85r7n/x
	RZfavXqrAHD/xUZhBLZL3KejQrSrG3YiKAO8C2a1wGWwmLad0dlvz9mZoyqRpqxPFCx9CGTHEr/
	XP2jHRR1c=
X-Google-Smtp-Source: AGHT+IG1vHcxWDhaT0QwHTBPTm1Nq4qv5JXkkuFmNGoZQD89ABIsp1+aVObCMHljyu4a3C0wMv4B1Q==
X-Received: by 2002:a05:690c:4b0e:b0:71f:cf50:c69c with SMTP id 00721157ae682-727f5a347c1mr92682287b3.53.1757361883118;
        Mon, 08 Sep 2025 13:04:43 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a83291aasm55200767b3.18.2025.09.08.13.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 13:04:42 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:04:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 6/7] mm: folio_may_be_cached() unless
 folio_test_large()
In-Reply-To: <3f76748b-8f99-4e63-ba39-adadc2f58838@redhat.com>
Message-ID: <2ba8984b-8818-2a7f-7544-4c5fce3e0878@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <861c061c-51cd-b940-49df-9f55e1fee2c8@google.com> <7fe2380f-a83e-4a9e-8c5e-8459c9af0d5f@redhat.com> <7113d289-fb8e-4589-7eb5-1f7139965ade@google.com>
 <3f76748b-8f99-4e63-ba39-adadc2f58838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 604CFA0008
X-Stat-Signature: 7oz1bege5bq47yhfqiia455sj54x3bpu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757361884-184524
X-HE-Meta: U2FsdGVkX19SVySD/s0AVDArlWtVbry4Ny3z0jaiMi0uPE7jX3dv0FwnfDT0MHESqYfjkKSt8ueK9C9y1EuivX7talBA1EGVXnSxQnJ5e42UERNVxrLhODNs0raRcTtiAnncivvBuEFK2it2E0+BGPwhSf4uZAqvzZLq97G0ldMjiaR8rbHp/DjOtcKGyIT9FZgNXCBS9zGNZHZVUXSO2OKsVrcR3Gu+ptLNizWQIQ9iHlpoztaJRYQ9qew63+sbgoIULSXnwt3wF4/isZyBGOb4ECFha2RNsBcgNFWfPKfijEnh4vrBuTajzWhWtJ9wuhIn6LDZFZPirLFYlDOv9yxHohLGcWsL3e4c4P7AX1lt1aqDRdROQ0Txm2jZSoaDWpKi7HL1q3zgA3sV9Ke9AQjnxYMWf5tEjzqefzPWUIPmcZh+RfZ/E9hBQgOYHNRrCC2gbeLVn3kRnM4EFxaNc3lBNgX1MhEQlNKIYXAjzOnZecSoUji3L8hpugkjtjx2dCJ3wt5dWOyD+i29uvwA4zy9mAIL2Du9E3iVy96WF/f+3FKj+2PpNxEoj01yVULhp9QO+TiZssZDayvzduX1DWThZAoUs84ZbqJCi42u2skdrh3JB8HQAvmvZUmew2k862Z1qstF/3L79jNA+UDPdpBB3VKsgPPDFguVfVRHoJvuD4XlGuqL92czmfZBrvpGID8APYafDeFDT3QmAbdPON2fsV7r4wFnnBAvOod1D4XhaPdv7oQKZpAD3wOWDi0izkti3nTsTM7pjlplOUBKd1zXoqxmQbILfbnF1GAXqDhaMPCbTu3fno/bYDXZeVRZShpnDOqbPLqOm/MNlhFTCe+XDphV1LAyk46kVwBqiekG0o+8wy23cEafpAsSCzrvFpRwmoyFXyvDzbqgSCSJo6nUEFBmrQ+0SnvmPs38SoHn3CN+lmyeymD03xU/9ix27Rc3AssrW0xG02c8w7j
 ss/r/157
 yKDJQqFUZXI8nvqznwCdUHrxiTPQlSuPAzJ2KxlD5jdTLU1flTc3hhWzQN7QWGPae067ADqwxE5NFp/3SVt0Nam0cEdwxwER/DCwedgmyrPJoMIYU5qvMcVl2X+IOYMcfG8WmUATzpXzXQjAGB+1IBLeEmrpLTIe+K5neQKAnrTCev8zxhHaRnugXQJ0ZmSX8Phk2CaDa2FUaF5c2YRHIolKRGR2zZJzEVTiBx3H0SSYbw+tTPCDnP+WxtD/uzcNcazsg6aDQnWMhnWDIIE3l3yrPMADC074TRdfLdaxY4hodfrzi6T92qvrpO7UjGt4jwnf3p/IUpt+SAnvIUNlpLqJarJjzET4LGlnKk9XPFaJzXlv+UwJ8slaum0XCIkySx85ERNQChilScXDbIu9EB9+UNrGYe8tv3jjO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025, David Hildenbrand wrote:
> On 08.09.25 13:19, Hugh Dickins wrote:
...
> > 
> > (Settimg aside that I've never perceived those pagevecs/batches as a
> > "cache"; but lru_cache_disable() gave us that terminology, and we've
> > gone with the flow ever since.  lru_add_drain() would be better named
> > lru_cache_drain() now, I've always got hung up on "adding a drain".)
> 
> Yeah, the terminology is not that intuitive :)
> 
> Not sure if using "batched" instead of "cached" might be clearer long-term?
> 
> > 
> > "may be" rather than "maybe" was intentional: perhaps too subtle,
> > but to a native speaker it neatly expresses both the "we can do this"
> > and "might this have been done" cases.
> 
> I would wish we could find something that also non-native speakers can
> immediately understand ;)
> 
> "may_get_lru_cached" / "may_get_lru_batched"?
> 
> /me could not even phrase it in German properly
> 
> > 
> > kernel-doc?  I don't think so, this is very much an mm-internal
> > matter, and I don't care for the way kernel-doc forces us towards
> > boilerplate ("@folio: The folio.") rather than helpful comment.
> 
> So a comment that this is an internal helper might be nice. Or we just move it
> straight to mm/internal.h ?

mm/internal.h, where we hide things (GFP_RECLAIM_MASK etc!) that belong
elsewhere?  No thanks.

David, I think you're over-thinking this: I'm coming to regret not just
going with your excellent folio_test_large() optimization, and let
someone else mess around with the naming.

I'll post later with my current naming, but if it's the
Suggested-by that's making you uncomfortable, we can delete it.

Hugh

