Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786D3CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04968E0008; Wed, 24 Sep 2025 14:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5188E0001; Wed, 24 Sep 2025 14:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB618E0008; Wed, 24 Sep 2025 14:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98AB98E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:48:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FDE9140145
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:48:15 +0000 (UTC)
X-FDA: 83925028950.28.C32CFF9
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4517F2000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:48:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VZmb1rhB;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758739693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkL6ZFw2eyDJxTR6geR0RUKNGEtDseea1wBQWsTFcXM=;
	b=0y8aZVvMcZ5EOBdV/0LoS/5LpyVE9/At2LYk3VypJaiRQXA2j3a5NvPoPBJhADVgdXCRIO
	niv2jHzWkIrEMfUCdiIGhHbSAAni0GLvV53B3h7lEsppgE1UDg+KD5CbMqC7ALeWb/a9X4
	Uqk2ugcDFU8hZP7xhxAvHyMVHXk6hFY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VZmb1rhB;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758739693; a=rsa-sha256;
	cv=none;
	b=iV61+DJ2DXZndq+OHYMs3J0taI3qnybnV2z+/WblsHgte50jNh3sF3kk9uqw1DsAlmdIcf
	uUXGCMnCZaMHCOxJm2miBDoNO2sWyF6J8rgEmpWzCKloiFnfdhJyPxr3LFAou/EcqUTREM
	/msFSPNJtE8MqCfniNKItq2wEAZqPrM=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b557367479eso104008a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758739692; x=1759344492; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkL6ZFw2eyDJxTR6geR0RUKNGEtDseea1wBQWsTFcXM=;
        b=VZmb1rhBEijWXPj1l/39xJSJyTUNDLCBn330USQvIIlmqkEEW8JeS5Q7AKt+wQ26lY
         WGjrKtcXO6O4GclqlaTsTPV6PsIek6wlywZQMeY7w8msZ9bTCSgyX0jh1OdacS8gAsFO
         V0z+nH5b+MPXDnCi//FfYzr705//g7SgRAAs+XNkAum2KQPzqzc8N1d1TiHiwivlfW0a
         OrFzgokaEGij5hHiQvNBnijzw1z5t1U6077TdTsllyrDYNZfgXrmAAibzq6EYmJrBBMq
         61INAouYcJjYx2s1Wk9GmO2lhubh7vTNxLbj0lEBDMQXCQn3YYH1zb5L6UHesZ91IuDA
         IEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739692; x=1759344492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkL6ZFw2eyDJxTR6geR0RUKNGEtDseea1wBQWsTFcXM=;
        b=n6mP9YrObUOSGAouKND5VOCVS5VXDhHj+pO3N0CnTrpmp8nDz3Ws6HDHi7R5P0WxPQ
         +seY5Q5nH9pBahvQKYluqu1V3zw2Nc2kJxKnwCpXyKcBbLyrOLDU61tP2skM1T99w9/y
         jL2/H1GrJiCGPCZg6IVLBr/7HkGO3gCVhe/z3UctUOYl4V1GbhbTLcIIpQ1y5MWfhLBO
         HkKC3gwStpUlTLseJtK9+Z9mko51esfucORQ4J513qMWEesbnBPWDZ95/qlk1Fo+ThkH
         y3DDkB2HZPQIUkA9XQJ1t8Uw2t9yVHLKeAR0nDR1FJTZUbLDBUfPgHShQipJLs6IwaO6
         7uGw==
X-Forwarded-Encrypted: i=1; AJvYcCWKXqXshSCZwEusB0sSYZcLR6340uJ2skw3ev71vT1gV8CIrfCVDdlqyTLXK2sYh4nsyeqbUN1uDg==@kvack.org
X-Gm-Message-State: AOJu0YxmcgR7zyCh3e2TcWYJubrelpyOQLuRX+iTwaTwy5dYLbS9NWUG
	eIoLtMgT9DeegG+g1m334rTS0Hh21UdvnqyWkWknpNEU08vEnhyLpwaR
X-Gm-Gg: ASbGncskSe3CZ+sM4/KP0oQyhXk+KYStLXK5pt4yCVHmwJTaPIoFa9aPMzAhlobsvsm
	NHfBaBJNcQN1hLtWoQwSNiV1wktbgZySgC/1Xgz7uR7dBkOBPGB7ehIVLVjKY/Bl8gVery2Sbxb
	MwLZMhJ//mcLLED+5/b4EhWzVB4zpUcKe5K8an2Tw+iNiGjHXzdMojDYi+Y1P2VwjGobodCGe8p
	mfgGWljpSMATls7w9pFDcPzZutl4wYHxH0PH3ptsgkI0NwhhB6GQNJ0pQKpkKoe1r7Ma5foxnO2
	NCovnp3s5dAUNyK9zuTEYRLlJZMuJszMq93mUlYbz+1aeI0e1vtaiypMLPSPy23cNz6L4qtrz72
	D/KZPBxwanLdOVzPEhNBlKO7APuVNquW0IIb9qoXq48krA3tNJtGPwj7xu1zBty0M
X-Google-Smtp-Source: AGHT+IGTxELwHOVAchfeV+Zua3SucLlubodBPLOiFSjPNAs1H57tvT0lzKr1jBAv6AHjCcpTAs5tCg==
X-Received: by 2002:a17:903:b47:b0:267:bd8d:1b1 with SMTP id d9443c01a7336-27ed4a934b8mr5659715ad.50.1758739691900;
        Wed, 24 Sep 2025 11:48:11 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802df630sm198733655ad.81.2025.09.24.11.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 11:48:11 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:48:08 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v1] mm: convert folio_page() back to a macro
Message-ID: <aNQ86GPdjRc2DoJN@fedora>
References: <20250923140058.2020023-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923140058.2020023-1-david@redhat.com>
X-Rspamd-Queue-Id: 4517F2000C
X-Rspamd-Server: rspam05
X-Stat-Signature: bmcdqgeqwsic8tumomjmxpy4pe7apjby
X-Rspam-User: 
X-HE-Tag: 1758739693-717147
X-HE-Meta: U2FsdGVkX1+wYRZ3CL1yxEY/1FXTcpRKyd6JjZcGro3bVVmAu8qeT73vdP0eRqyubJtYTKO/jlzies9cQhgg0aMthTQ43ThbDP2EhtqWzAygWB3kWAWyHpXwi7LsRbXuHL8GZSUslFidtGJK3qVlQmcEF7n0x653eCA/w2EUjk7VQQnIZZSlSVn3kQnvg7s29SljdJvg0vR9NneAL5iXvIIyYHr9MTgeT5SWnmx8zTTlcyReyefMrOfgc7Zd3WoHtQdXMx+bWE3HAo/ARaWR2E2sg5YMlFuNgLnyoXL8a0yPXZOgWvhnnYZrVsTp/o0l7bCBwVOcdrkYpPyAqf8QPyEJvGuhWauAztCY4Ce2ZvbVSvz92Pz7CDEaZgaApbwdorEFdL4JvfNztRq+HnJz+wtmM5blmPwbJkMXsJuh6YiUYZozVC+fvnP+U5xD9Pp658OxgxAhSNCg4aaeShsMOfIrqnimo65lBfUEUb6AR45MvlNtSu+YfVHP01y69t2g2IOtmJubo7ldqeaN+VdGd71mHuh61R9+Si2EUU5qy+Lw1UMzacpu2bmo9r28dWzU/1hhcrgZRdMHQKCDXjIFM/t1au12UMu83ddVTANWYJmwY3MU0SMUkT3vdogtle+CIz/oAt+PCarJYJyzp0s+1nW0ia3RWcw7AVkJ7ycXXNjbC7inSAn5GX3TxqbJdDRr3Y85thhaLgwDlE+QChKMbic5S9Z1CybmnwQABujMATPl9CF81Tm8hRSoNgva6TyPl7xc6ZHCxEk4jamXjuuAmqcXUnTO37FLcbOikIanshv4nA9h1B0/q8+rpAGrnokAlRcLwm7hjNDB083NZQ2YEREP96V152QH1paqdbRzrC2rgEHheIRDf/GpGe34HdI8uvFFA5kxKJT5cmMOQ9o6fEKnu2RgzbgeBpa8Ft5thqn6elMTJw1Kda4nIhDAvyQN+QIe1mAZu+OJFTcrrwd
 VVHOTh7u
 eLcciVBumpciWVB9xAyjxSCGbKnBLMz4nvS8Ze5Cu8Rc16fD9IOx096aCdsWPVbdB2Yo+JU+L86URtePMtnVurRKBZosaHZRWVeZj3BHjvySpAXrlp6VMKf2yEzfo63CWNUG+fvFHWj97OjOA2ZOK3N/AZG3m/QawtGp7EHJlbJMv3yhhcUUoN5AakYeMMzxOu0LePXZzBxE9vH3xElD2r+UcZbnRILfi7/b7ttaozwGJx4ufPkm3qTQ4kw7slBj/7OJJIXDam0otRr3HEICVNo3fQDbtOmUkC6lt8d7w5pRyDACm+4YdzJy2TMoCNswTnck5ptmDVusCIFXOhaAD54jEZdFv+F1tw+fBWJ2GY1rXDJE8HqInO020YChcglqaLLdyt4CQl6qmWjhVRm/FrCjAqoHXLYgFXmkZL1Po+W6D7A1E8cQeNQ7v6FX7+97qDXr5naDfM6maiQVZLx+X+RoHprqnILXvc/0FYSBGeaJfjqZlcAVg0gjca4R450MDQenD6QHiVJduG6NSWjqELjiUHW0uGalbQq34znBMGv5orrX6bswOWqN06AU4KO7rlRi4I15+gyrdLD2juhLUJBM3R8VFz0m2Z1Mbp+baGF0PEhIIEN5lNjHOIxjT166aBxtL7hMkHbgiUrVen9rkUz3wokcX61jX4dGUOrasA5ngsde1aTDvfYY3AGwPX2TSyLACKhpthhMu7B8DnhzGuKIs4QpwtDXjy3UQA2GfO9+vFw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 04:00:58PM +0200, David Hildenbrand wrote:
> In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
> we converted folio_page() into a static inline function. However
> briefly afterwards in commit a847b17009ec ("mm: constify highmem related
> functions for improved const-correctness") we had to add some nasty
> const-away casting to make the compiler happy when checking const
> correctness.
> 
> So let's just convert it back to a simple macro so the compiler can
> check const correctness properly. There is the alternative of
> using a _Generic() similar to page_folio(), but there is not a lot of
> benefit compared to just using a simple macro.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

