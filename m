Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C46D1268C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 01:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661256B0010; Tue,  2 Dec 2025 20:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611E86B0011; Tue,  2 Dec 2025 20:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501576B0012; Tue,  2 Dec 2025 20:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E21F6B0010
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:43:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D48B6C03F5
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:43:15 +0000 (UTC)
X-FDA: 84176461950.16.B27FA2E
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id A05031C0006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:43:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dCpwiOtD;
	spf=pass (imf18.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764726193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETjbU+fLGhGDfzxgTnDMenSPqcjRJRRAX4hkVQevMtY=;
	b=mbu7KlCkzlX9GtPU381y+pOMiPlrmGjEAF/xcd9bdQu23n2eJuFgSA4YyjwESQszujO8dt
	LRbjT1dgYBMFditZzmwr4wGnQ+GYUWOSrtXh1NgCKK/Z2wc74Mxy9BexZuW/yaeLX4LQt6
	z79VdlbQAcqBCgaLDpfSu9wqXGXDhQw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dCpwiOtD;
	spf=pass (imf18.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764726193; a=rsa-sha256;
	cv=none;
	b=1X6kej7Lj5ZUc3TOPhLsztcbbcqiOh5CdSDAgpa0wk7a5WinnU0i3NHjQefUAi5u8cZ9VW
	axwTrXKaU5TfVABYw8Oeuq+Gw8Hgdr3md4vPmtVI9Z/L5fC00ZTbsAnetsRhbMpMhLz1p0
	XbcPejYG1a38+CVX4m6dL2wJ3NdhtKg=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b5ccceb382so75827485a.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 17:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764726193; x=1765330993; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETjbU+fLGhGDfzxgTnDMenSPqcjRJRRAX4hkVQevMtY=;
        b=dCpwiOtDiXXmMcAJAjBdrWb2zAYYiNTXLQWg6PbBWb/BZ9zp7GT1FvEGvSIs2YNJKm
         DK17V+LJazdTp/GkJKTYDSEM+4jGPQQLm982+chig4EDGkJ7wh1dvp6g28ABUmqZtSqf
         DG/B5zrlPzcyjIwrobjh5DZ/WTlMIXeL1kmk00fRS2CZTnFT0r+5CNai2WtJVBHBAXLU
         DvVVseoidqShzzaidBKlEJWMsCu7/srj4KYd3/M4gRrtQg+F1nYqQXi1bAvA3l8cD6SU
         AdSYtKbFW/1vw5PXKlJvITIhqs84bLNknRMFve2V0CLJqmqNcnSWzStcFuJKvvEEyWL/
         cqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764726193; x=1765330993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ETjbU+fLGhGDfzxgTnDMenSPqcjRJRRAX4hkVQevMtY=;
        b=bcxAjaWCL1wDSc5x2pdgZCNvKuyo2eLdMbp+SFmwcXhNnO8EWWP9eFSfwUaeEoO4YA
         nGBvEHWHbCvlAG8NZ/kzlQGr7Jh/fQU18R5YOIEUtgOAFjBx204Z8iAQpWeHF/OYD1c5
         Dy+FQ8Iymkbt1AjYlxwa7y1PzEGdiCk0YVV75xbTNEMSTOYVrMsO/rXRngPgjXgqvikU
         j3Qc+rRSmjrcA8N+QjDTPlDkjJCeltY96hl/v2gBPsU9kx01p9aHzosPYE7n0vIgNCkp
         8U3nNPG59Ugwc6hUiJYeCLeQ+N3E0xHJHmA9CbtBquSQgcz9hALE9bjd1pBT1TegJepZ
         fs1Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0rQi/ruw6PDMEU6NfzpnVm7pmExu8UYMPN34CcaEqCK/VtdVwXfRAZDiMqq4rQTOxBpSJbbEeUw==@kvack.org
X-Gm-Message-State: AOJu0Yy8O6HrD3CdFnLcgO7ZC2zZ1kD+XAx6PDHPW9ZFNL5Yn+IpklxI
	x6MBslirrgLCG6ADxohu9MIPKjK3nSnN2bauUHVGATvp8rfM4FTy3EvQ
X-Gm-Gg: ASbGncsnMUmAWVyJttoyy8QP1xYgmRHF54d0ia5YKH51RswkUorhM1JXhRmyEo6JgTr
	kwx/ptZ8u9zLteSe2FtawWjotg6PUGhTSh1AbpVCj+PI2kn5lCqxTorW48Sm5kBVHN7hWiNItkx
	uRzB7SGMLhMvEe327xTzNUZyOs3q1/U7bkBGIEWkWOD389Cp8c+94kDIiZRepADoLAT4N7GSKcT
	J7QxptiPe10/rxsR5kTZ9OC6DowWwI5kY9lTHhB/L47mkhPJShKf/FppUI/qaKVldmSnJFTS+wb
	Y2g/cGXE1febv0dQpxNkFoXfdnO+vqTrGFFD2B6tpLIgajdxV8dFtNnWj1ZjENpGl9OdFA2AlDl
	8tdAnCTM2gVVhV3KOxeV2DRnmuKHJTUb8NPT1OHv11giMT0U9wLdCg5DCKMGAdr+GH738N+psgs
	8xn9BXA0kPpWGLbJfxcp8aDTH3MdevNYMSv7bfOkeD9ryVj0AxQmYDGzbfVnUX0RpjdONqvUaox
	IFE233TvnLSRS3kNl90URtYcA==
X-Google-Smtp-Source: AGHT+IHEy4Q54AuHhgpVA54+15RACthkHURALKVHD4XscXZnJiegxklSCLv18fakX1t0x2ItohbFLg==
X-Received: by 2002:a05:620a:280d:b0:8b2:f29e:3b00 with SMTP id af79cd13be357-8b5e6a905e1mr82884385a.51.1764726192746;
        Tue, 02 Dec 2025 17:43:12 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b6d32csm116059906d6.43.2025.12.02.17.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 17:43:12 -0800 (PST)
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id AF9EFF40077;
	Tue,  2 Dec 2025 20:43:11 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 02 Dec 2025 20:43:11 -0500
X-ME-Sender: <xms:r5UvaX8kRjw9Za8VOV-mDwKl3o5m_0sOG-_0gY2DzhaXqFs1WB-4NQ>
    <xme:r5UvaWylMKb71xPmCEtNGlalZWQBaRdN0N5DrHUkCyJXg4F7rM_GTZCeQ3zRmj75F
    q60IiluxBUUzsaRkN2rcFKnsAu-L6qyc7p3tvEi7IoSBGLBs02RwA>
X-ME-Received: <xmr:r5UvafpOA_vo5dBFjZMzxKysd5miLLkD5HFhhr77YhSXq1iYQ2Lh1gVB230fzzFQF3wSA3D4LbB5Jaw-or3tKD5fN-t8Ydvi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcuhfgv
    nhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrh
    hnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueevieduffeivden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquh
    hnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudej
    jeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrd
    hnrghmvgdpnhgspghrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehruhhsth
    dqfhhorhdqlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    grkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhho
    rhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirg
    hmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehurhgviihkihes
    ghhmrghilhdrtghomhdprhgtphhtthhopehvihhtrghlhidrfihoohhlsehkohhnshhulh
    hkohdrshgvpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:r5Uvafqz10y4zTuITFREwYLLR4rXPfVo0QZUQTq-dmXsQIoyXt3DEA>
    <xmx:r5UvaXCmws2k4wKYaj8Yk8tuPB9NGZ5yGFiMF7ZfgoVl8LsEBmlI6Q>
    <xmx:r5UvaVuOG89TuwnIhsuUIS07NgQcJIh4b-iTGA29NHJZOeeMtKNVkA>
    <xmx:r5UvaeIgAKCeYGenBcAZ-OjK8X0JFRC6Fx8OUpqH_lgdaLwVpsBaag>
    <xmx:r5UvaUaSaex5G1iDvNoOzsD3PtBz07z-14zzyZ0yCQyAK0Kic_s8cU8g>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 2 Dec 2025 20:43:11 -0500 (EST)
Date: Tue, 2 Dec 2025 17:43:10 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Subject: Re: [PATCH 24/46] rust: mm: add __rust_helper to helpers
Message-ID: <aS-VrkRdQc0H6nSs@tardis.local>
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
 <20251202-define-rust-helper-v1-24-a2e13cbc17a6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202-define-rust-helper-v1-24-a2e13cbc17a6@google.com>
X-Rspamd-Queue-Id: A05031C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: xn55kbten85jiozqfn3b5rpb5xdiz1ep
X-Rspam-User: 
X-HE-Tag: 1764726193-636235
X-HE-Meta: U2FsdGVkX1/FlVUAVdaAT/9Oivw0k+zjU7l6IzZPbRLLJX40bUFU7jtfJCkbqtzcWLp7KiGlc+SwoQtiegpgXbgAyLW3ln5vB+1m8MtE+9G1KoT2o/w6mZM+jOGkz31DMFlnuXNWSOutoWjqLKmMSFR4hG7nlseBFqFKfwQMW6h07xaB4FA8qATY8oafi16uCS9AMIEZclfJBOgf04Uh7z/QIyFOyU7T5WhTcWNz00QuBbSlxA8P0DdTrpsWgXOdrwf8bs19iOMQCxedPLW9bQBhKF0nFO7UVEgyYr00N9YWgHiOPm3RQsXX6QjxWHJhHKykxImo1nplgPGogdMaaOWSIJP8Pi+Vajn9ZCV4CkAcn889vbNPQEyYgCq3sINACALeq8eU3e8WsyVT3y4a5SoD/e1kWgDv6Qm1IdUOXrbcviVSqmuypzWC3Ftw8Rwe8hHX9H8JS+39wXSc24ANyqEkNWbd7W7x88ZIWy6qJV1GIo4OaMyFECXucNlC6ySVQ6KYgiAQP2Z0EZ9534I0qneFtLhQfhdmnR5ESIfuCTpxVsa5CZLgzPTiMz4XAz3gmbk+TYmyJyeu9Mm5YSzp4QwRZ6iUTYS6ON50bKTDkOG0dkLjNqx/nKFFSnFI3/w3V3y0B/Lsr+Vl6admdmuyi3PaVN/H5Hf/FjLid10h+mUwSaqbiwW/MyFzZCfMM8Fnuot4ZUkg7Q87+9Vtr8dWFOe+o0wwSNTca0Mfhk9bBbh+N7s4DZJE4nC+rJeUlp8i/fmYN2gDBUI256XwgYtytV4eQyMXUqTniPzhxcaCL31NadYowHni5gRDLkPnhSyOri8WUSEG1GUySMNcXAKKmzLG0cmItjpJhQg3NiB7zQiZ1+u4QDFZpnU/l3xZJRqLu8vVCeGi4Zh5A2Vzk0knOFBWdCcSIDgvYbcPAYc5qpMzdmmqK1lv00eVm3cFXBWlQrGdgdnYFbr/cuA5U1P
 18E9lNFH
 EKf4m3ewNaGO5A0rCL2inRbKbsokfXtpNadyOONzNObMWQmmbqVVJexA1ybFBlXCJhLva7KBywejx4HesBCwlcBbqqE0WicWWL/nkZt2eHVdX4r+L4oKGWA4XQMR8EcIfhgyPE1NN/JMxWgyQTD8yxMS++3ga6kz+DADdj5FJyb0STkEHBL1V0meCXonoVYwpBPuJbcSkx4UuOanrWjjWm+sUqYPeEbZWgc9ySPxHce8r31JNKewVVSdjMcE48kNaE1GiqdTuxJwdMsZCs8QflD1Zd99tyM3QDUDtM7FubbBB8HJi/3PMO7zlqzjjHUVdsxo6DEiILAUuWglFy3eYfpx8mk8pSrSpktpwD997TFh4ZFSZAFJN45CrmoaiZZgvbCeSiV6CH3DS70XYZUiTk9HVe4K7eorCTzY6ztaieCEq8otNVijg0kqkO2J+SujrtKSMsyEQ6JaLSjNXyxXXdn0WhbGJH++CxQRKdDpRcKT5cdD0rWYe/IPNBz1TAThgrEY5cFtekGCcgCM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 07:37:48PM +0000, Alice Ryhl wrote:
> This is needed to inline these helpers into Rust code.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
[...]
> --- a/rust/helpers/vmalloc.c
> +++ b/rust/helpers/vmalloc.c
> @@ -2,9 +2,10 @@
>  
>  #include <linux/vmalloc.h>
>  
> -void * __must_check __realloc_size(2)
> -rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
> -				gfp_t flags, int node)
> +__rust_helper void *__must_check __realloc_size(2)
> +	rust_helper_vrealloc_node_align(const void *p, size_t size,

The indent here seems to be incorrect?

Regards,
Boqun

> +					unsigned long align, gfp_t flags,
> +					int node)
>  {
>  	return vrealloc_node_align(p, size, align, flags, node);
>  }
> 
> -- 
> 2.52.0.158.g65b55ccf14-goog
> 
> 

