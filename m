Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB11D606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n2fkQxLz
Received: by kanga.kvack.org (Postfix)
	id C1A306B05B1; Fri, 30 Oct 2026 05:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB086B05B2; Fri, 30 Oct 2026 05:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93C66B05B3; Fri, 30 Oct 2026 05:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0886B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:52:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8248DA8274
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:52:44 +0000 (UTC)
X-FDA: 85378828248.23.3F85364
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB1E840005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:52:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n2fkQxLz;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793353962;
	b=uet5e6wAAU+15sHie7x5BIaaqq1aQ+QEgi1rgHHYJkPNpgxtO33RNT6wDG22C6B9oejxd0
	gnPP998gQSpDBdFExYCo6jC4SEazAPO0YUROa/L1tJ7nd3r4OSu0SF6hY27hWXCoVZEIhA
	gRC1JvR8DRcY4Kxd3E2Udf61yFb6rYU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n2fkQxLz;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793353962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2B3bjvz5/cRFhwo9ukB7ZLLCsSJwpiNTa01piLcwoAs=;
	b=JW91uyf8J0OjYQSQB+4M/Mwlw7NUP4KoEIBCoaAyuvvU4GosIHeG3r/6BEOqyFNT+k+2ia
	wpzzeOmY7FB6b+ubAQfvFt/92EdOZgaGkEsu58l1eN19hGZHInhjCEeYqd6mH7H0axaJQ1
	yJuDF1OJCzjkagS5Hkr8X4LdrinLTXA=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4caf490606so30864666b.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793353961; x=1793958761; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2B3bjvz5/cRFhwo9ukB7ZLLCsSJwpiNTa01piLcwoAs=;
        b=n2fkQxLzAr4XO1M08O1kEMb1sjPQKpm6vF8ltIYAqZlPwI0/os2gBzqjkzDJiYC7Wx
         Ws4QveT667TTZAI9YdjIgAD6ksJQ42P8itiqHtBQYkFV4Q6Rf5FCdBqQ1Zjk/3bNo3M9
         uiS88uAfQ0LP4NWHnee9FKGTwb6LRTILYmYzhB/V8Uhshx2Hdj0fA9P9wv9T8a4kt9m1
         y1jps8p+g7C4IpxKcrN7T9Vc9bCmaX6IioQkqgZ/+JYtfjeUF30dJchtmbltyAbxhhU7
         lhASEe96dtuheHPrtFri9UYkz/tw8zEw085it0+vFx2cf3Y9t/He7y8t3ZX3Ew9Mb9OM
         cLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793353961; x=1793958761;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2B3bjvz5/cRFhwo9ukB7ZLLCsSJwpiNTa01piLcwoAs=;
        b=AiDQL6FSwZx8GGkou9+honvybpB4UsR0iRgHAfG82FcGI0vr8C/OmMsjo7DoAOnTEo
         R3v1+bobDXyA78wMtsJ3MdafBK1u+wKzT29M2fNFlVJv7TPNAtnnKMN2VCMi8wISwq6Z
         SgDXGEjMzMbHM8FswbUrG9V3osGOJNN2i6Jg9zYzX2hDGvLKT+q+tE0DdDzcH1MHUp89
         +am+u3oaASf5J4DjQxIlXL2wYrmP+/NVZKFK8ywWXbeCdAfBNb82GsXmVL4IClv8HVSP
         77QHxKc9Dle4fLjRMrSc9RsUhjr3bEpjQLmpg7FLUh310HQ7YpnJz6TfIXH5WxcicVqC
         V06A==
X-Forwarded-Encrypted: i=1; AKwUvBzawhCDdJtjqFxEVuomc22nwZoKY/TY43J5O76R8plf15zH7Oq1By1qrTaHmnoGcWwqhYkUuc3XqA==@kvack.org
X-Gm-Message-State: AFq9FYIBAMwBbX7JvDf9O1M99OmBfAz/M4BwMKwhQ+DdcfP/bjxfE52J
	6MHlBO+R5TlmZeaSj/+7BmO7HZM2Hva4fI7YMm/ijSACb1dcC0oCbXjR
X-Gm-Gg: AYBFou1fx6VKLWpgO1HJNwlJDPyHh3t7yOFgmf8vMOuBOESxLXqvJlcJCwNQeXwyk/c
	OWz5KJKUKsBTt8Lw5N1foNmVVq3uXOtxb4JXDEW1y+GZvmYTfnJEu7JxKv83/i9at6zquDwz2+1
	GO6Sh3zkgv6jMgFz9KjtsIAhjP2UIVHjT6xSQbZRVQvaJlKrQ4Q7Ib563weySU+BoOnAxcHAp90
	Hf+ezOFXu+gbRODAJZpR9spAWCwaqAvrwxvwNQHM98v9guVvPC48WYbZoQtJsO30PTl9kaRz6qd
	uDvkUXjtwGgHV1jq0nscO5qd85KpXj4k5w6V6EAEolbmuXec1JqH4tc5U6EVU65DeKoniACaIZ/
	2r2nSVQz25zhAloXBjSnqDUV3t2zYcsHVCt2Z5FXxQJZLyvCmen7lNaOaW0RSghaQQAXWcHuVN9
	961qd2zVyVqJlJLyJnA3sUb+l26t6w1fhMt0ltVVEOtvEW+d3rDBk3vH1fqrJdlm/qYU1V+5Xl9
	5m44OLFfBh41y47UCXRyJQnkIamlWFIw5ns+i+e7Sgp9tkOrYO+ro6wc/b335dSNQPYRw==
X-Received: by 2002:a17:907:d26:b0:c2d:c800:d797 with SMTP id a640c23a62f3a-c4ca79478f8mr163699766b.6.1793353960890;
        Fri, 30 Oct 2026 02:52:40 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4d7b1d556sm432290a12.28.2026.10.30.02.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 02:52:40 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 30 Oct 2026 10:52:37 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auRo5WBj2OlKlWGW@pc636>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <auQhkHG6XlgNTdRr@gondor.apana.org.au>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auQhkHG6XlgNTdRr@gondor.apana.org.au>
X-Stat-Signature: hsbcxodsmjtm534o316gjzhb9oat67n6
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AB1E840005
X-Rspam-User: 
X-HE-Tag: 1793353962-552311
X-HE-Meta: U2FsdGVkX1+3Up53NtUTfUW6NkXyGUIMDuttNFUyuTgZgGtI6WLlEKjK+Qa2BDhSTy1q1mei/g1vFx2cVagOzX0vcQ6vkjFPcV6TUu7mDJe2LVs7kTVrSbC2CKFJkiBm0rwHibWVOo0xp0jAUXan+DgOOeKqWnRZdKW4i496AxjGPDALdR0H2aUVG7RjcDkwz98Fm7fknxchEQ/f2rE7DglvGeY9AUpSU5CVREHhaBZLbCcNWcij17Ebwi/J9KfaNf15IZcGlgNvQH3CSpnP0TwI/2mFyo56W/ksysXcxpPeujPDeYFWC1QT2wc2F8mkCMHi/BmlSNKpk8alBi/dbjCz1C8Toas6cX0x33VfqeyyO9kdQ1rlRUtabwz7DYwjw3Woa8Uep1VXoHgm/54sKt3qaD/WYhu07g7W6+D7/aYQOjAvDaGQaB5nPLZBQ8m3Sh4HhYAvRKuD6UunO2NwGS3DCjh+Xwmp78KV9xk+JOBEcLO1bl6grFqxVj/avIbRnd2INQPMEGOGreLc3pF8+NUN8EuuENxTjOEFxnR219H9kNMDvMOA0dDbdjKVMfrwsCe4Y9FU0+05RBjuDjW96MVGFujBjaKGGEp8baxreQUK4EJQe2yERfKMVNIoq35kORpezMjxVcNi+1Of/yC6HLiHxBDu7CDWjqTtRel4is8d4izfGa59+ZTQQYdbgjsM8lnU8O+E9YbDcOdJJqTScO9saYApu6gLHwik6CEUER+Alwz2F6HTxmx0vz7Hqgi8P2LZeIknifuqb303ESgd4beuPqdP6xJ9zWRL57ds8SU/MUxIEea1in59CBktOfb2ul2LAkvILorjVgDeDhqBKgwmrrMfaPXyp6ter10Evh/kuLELEIB8Fwpmupy3t4BLE338r/UaGId6VHJjfEiqCCnjfnFaUjbyivOaAuaKJuHIpftxjkK/rFwTS/Ro9S0uisk8/N2jqOsglPcUhLh
 WQnkxA7E
 6FKUDqS3JrlmTGeZ6k+QUiNVEm0gUrGVF+tGbjcMIKVcMugYWLej2Mct1n4G03AVH+GTjDC0j6JpoMiYPs7pTk46iEqKlfZevLUsmsdz5g8zNJ10vX1Pp4Q+mgHxaLCDpnDWFiQCMxbrI4vzi594RZal9fXry/WO5ITUU+aRPrBBQ3brBwoHWvQrkTKLpdCN+pgnPyCuy3pPAhck0GUOleCAfN1KQwu7rCDpwldEQWx/BRQURwHBl9gPWOHIDafduaSKB6+XfJZUUu1L97/TcvIz3V7zhb71gigZeeDpOfNEYVSv639INX3JbvUyG+DBfRhtyuiVvIdXyzfZwjFUAGsDbsdZntHbGtxhwDz3AxiUijwpE4TKQoMl+AzC6cB2cypOPvsl48aZDcwoAoB3THLCCSvw4G3MkyMAYPn/KDClNzpU5zYiPrzxuySSA0Cw0blM6GQpL0hcjRIvlNJcJ7WDSGWDdlF6JCmOmmINEWbXWfp0XEgRlPnzTkrFkyl3DEPi2U2w2SjDtVXU+5WgRKVPmLEni58gk1Fqh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On Thu, Oct 29, 2026 at 10:53:56AM -0400, Liam R. Howlett (Google) wrote:
> >
> > Given where we are in the release, this fixes a real issue that can
> > happen so maybe we take this now and settle the general handling later?
> 
> There is no rush at all since the bug that you found has existed
> since 2025:
> 
> commit c6307674ed82c0c57d6e1e3408e84ac449ab8e94
> Author: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Date:   Tue Oct 7 14:20:35 2025 +0200
> 
>     mm: kvmalloc: add non-blocking support for vmalloc
> 
> Let's take the time to fix this properly.
> 
The problem with spin_lock_irqsave() is that vmalloc() path can take
time to alloc and map pages. I am not sure this is worth to switch to
irq-save locking primitive. So this is the "heaviest" allocator in the
kernel. Callers have to be careful how the call vmalloc().

IMO, this caller has to be fixed.

--
Uladzislau Rezki

