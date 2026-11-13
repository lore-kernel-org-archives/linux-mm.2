Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF90606B342
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Ngf8iaA4
Received: by kanga.kvack.org (Postfix)
	id 2EA176B0638; Fri, 13 Nov 2026 03:52:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1796B063A; Fri, 13 Nov 2026 03:52:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D87B6B063B; Fri, 13 Nov 2026 03:52:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 021516B0638
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:52:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B84AC0315
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:22 +0000 (UTC)
X-FDA: 85429479324.11.32D2CD5
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2D2D40009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Ngf8iaA4;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559940;
	b=FpkrdhF0qCdpE0b7Zoho+dWLVSTbXBvTgxy8hsAr0y6IUmWDpmW/1Rp75b+93d8sazhBnG
	7VzDv9VyAXQ28bpSwlP6cZUmbxyfPWWQBl1W6Uq0a728o4vBglxyqAcYGn9QtcjYeNJCwc
	EjYPXUN3CLCqRFFDOAjJ46T/TJFlSN0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Ngf8iaA4;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4bPcAILoFa159OMZMpYEpI9iPNGmEeupM4uWcOHC14=;
	b=yIIih2H/+8TwlvYL3RABo5qTZWYHHCmgJflzupt2OPnw+bp77yQnz6b3OnJ+cheo+ospyO
	ePjZwSmkvF6tmo7u1J/aoQGOdBfCqPybASNar7LxM73qYcm4eOtJxARfQlPcnAfxmUiEcJ
	fPYZJsb4vm6qQrCh7Aagws/MmOOEJ7Q=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so1005348a91.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559939; x=1795164739; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e4bPcAILoFa159OMZMpYEpI9iPNGmEeupM4uWcOHC14=;
        b=Ngf8iaA4qXMMX9NqJAZep5+qYLKc/0/Bzvw+BdjB/YFkBoyqkzvJd/1hm0+FIAXU6w
         io8T98gYPM0ojVgpw0i7O/y9hktEHpDrYKhU3buuLv+VSZAaW/3QOxl2YsEuBOLrywoh
         r65ZkrWXFghgb+Ycbe3CgTqxLEH8WwROzcADk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559939; x=1795164739;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e4bPcAILoFa159OMZMpYEpI9iPNGmEeupM4uWcOHC14=;
        b=bIl611aZnpgwoGV7rTgMTXlEKeUm+axU4eguI9/7og7jHcoj2ouMgPuPCiVMeJc7OF
         Pc7K1ZHwCKPGotTcS+fwdocS8XuFt5Kan2rfaxVrEplrySBZr4JGihU43qrYnmHK90CC
         fVpK8F04G+xuoNv9RphG4/qktgdjQ0EM3MrWy7eOhmDB8PDphu14crQ5vfm9DlnF3yIH
         aw/pW/rQlFlYuHtV6owGpGs9LFKLRDaB+gAk6tzD82UePCbWhhX7hroAkK+RDIXwV9cd
         So7CVVNC3iAXq5oCHCADtWg9uCzsjBIbu/t4Wt0+Up9DZ5ksmJLDQXUJ/FKwYRWH0UoH
         m1fw==
X-Forwarded-Encrypted: i=1; AL+hErExZwRzjyPg6Mqpu+eyWXgEIP6ZzBwFXz5wGT724ndHE2YAZyo7iToLOmvjjEnuvYVT9SFuZET1SA==@kvack.org
X-Gm-Message-State: APuU4Z9sOJhm1xT+QobluEDDcP9CHoIxRcJYBv9XIZcdhVr/EgkWv1+e
	ElijvZl4rJKoXE6USp0LUWPa2ysVwBHPK7muDfNqDp8+5Lk4aG1icr9YRtRvl44Lyeo=
X-Gm-Gg: AYBFou0cca/tZbx0+uj3ThBsvEv56ZPCFQoZELkNRe5lAvJn3s19gB5+acCT0KaxZ/S
	AY1sPd2hAQ4WcwdxjB/MX2k4MaA1RWOxBDDwZ+3shCOmPIt6wllAtQ3Lltxvr2aHwuFefEK/mhj
	39l1KkvwuQdfDTmnD4eY+Db4/gwVq8+k85IocwTAnaQURyqDpMuQqPTqS8PwIeDvHOqnTRomDB0
	MtzWk1GItCYl+nnC89ZhUfl4Trawl4LHsfnKw7rB14if9HsufFoDf5UJyG6R8A/yvSwRiCYp4Xc
	eDFGWz8kEdoNaxvzxlspjxidlSNywE0zmuw+O6NPCkZesr819XNU0zlK3UcVYV9/iNShKmXREvJ
	HGLcd/jQFIadDfAKNJZ9/00OGHlUula4iO6jA2u7B0qhDYRdkkpTsVoaAF337M1TPZavkbU1ZgW
	4lqTKL6bF+391p52pXTAESXm7B3vDsrH7EdVMVljbGI8aDdozQv5bTAUQLOBKBdDLg3w6fqrdRF
	m+jumQ3Ik+98FfqjgA9B5PFmKnH8jIA5ntRYyJMko7uMuei7ERK8QT/fOAzhZP+xLRNo8/61yRW
	rZmetPXmeN6ir4w7CSHlotgihT4Ustho1WQhnrJbo+ft95RruB6Zkb3bs/DA9taDh5ZIG3z6pjt
	SvfoGeSG8I7+jc7vO1ubxzcb5FGJXuYzTzqf2gD3tyHzcw5GbD9lGNOLoHsPDuwUNwAWryL9MSs
	Kd/2gXlJo0AdboP6xhBLL1+chmshTW/6MPwp8Cq6unCqt0UVgFUhAttzttiXw=
X-Received: by 2002:a17:90b:58f0:b0:3b1:4eb6:b3a with SMTP id 98e67ed59e1d1-3b1b081887amr1718429a91.8.1794559939633;
        Fri, 13 Nov 2026 00:52:19 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f4ad534sm7140735ad.9.2026.11.13.00.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:52:18 -0800 (PST)
Date: Fri, 13 Nov 2026 00:52:12 -0800
From: Chris Down <chris@chrisdown.name>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 5/6] mm/slab: Support disabling KMALLOC_PARTITION_CACHES at boot
In-Reply-To: <202610302123.687A961@keescook>
References: <cover.1793253633.git.chris@chrisdown.name> <617bbfdce4fb2689c2510f0cd7f9adbb3ab8edfa.1793253633.git.chris@chrisdown.name> <202610302123.687A961@keescook>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113005212.556c6f234712bdfe@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: ban6e1ezirnyb65aagf8prot4zk71aw5
X-Rspamd-Queue-Id: C2D2D40009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794559940-790068
X-HE-Meta: U2FsdGVkX1/kV0jRtCF2hFOFTtRRv6D6zEHvZcDLHWxU3SBD5iigrCYyWREPxDltoJgHNYee19vCnoCZVvC35hICmHyCr9C1Tm2TqrnFp32pyLXw0AR5JnzHgJp05eoM8hb41/aBqndAVBKlsdd7GeHen251MTXU6HC+heAbPFIuYByIh+Y9CCXsbTdbQjl5XgJUAtnXAUE80r7RFLuyg3j8yG1mG52Iz8G+cAgZxK6xP49s/O1gSbiNUF6+o3apzCyvQ7k7Lzqpyksk26HbpcOpvLrKYl4lWzqRFcDLLB+A0o3G0LYYXg65i4Yr/J1heFFD/BZdcXzUrcoyAYKAIHlBZe2pzh5Dj99CmR0XjEq2nxJQmxJ49z+SgcU0nPUL+x9DN36WN519prZ45Ikppu2HXKP0qp4QCt1wjQQIbWQzeViyz8rbV+gX9AFbdnR6l4AgB1W5qtpU+vh+t6vlACB7wMFW6LvG6Q9P/pqQyakme0eTtkv4zp83iMDXDZuY7N5+tUciKmRrNgnuHDQvhlB6XQOhfIFT9GkEq6916lIfrdNYF7MPJH5LTnFbhu0vZBfPPa3CUjH9XmrzPl6g142K3rSST6BzocUmeDIzCVHMsh0kK83RaljUlxC4EiMzBV33u1MAvGXMXX4+6NLyX7N+OQRVMDtGVH6hmcKv0KKW0vxiWG9+cyu0q/qhbKYGI72W6lyOY0SU+2og0tk/UpAUWxxV35QeF+is2V2aGLKKA7qkz07Yf7WeIht9oRpjBAB3R7iuZUAoqI6C90ZUEaAA9Ezkyx1cIdIyLMnZXBGF70hobY3WYYV4xg+Z3HAd0YaKe6IB/5YAeJVXu7q82smIjaOx0630AxUJvhOwvyyUfeGiAm4aLP8RLhojNl5FcIW9GJ2Y58Us9D3ohe0BdV9goHoJc2w4CyLJNUqj+L7mxtmxghAwuxRmN3sDk2cfuWfyRTvyNH/ETVWtEdg
 LhdjNsWG
 PaE1Zp+kwU6RF+9Fv5lY7Fk1xxpzwXgrvFafBBtFDTHgR7PYEtphIr2GUxw8+2/sBBMm2H9yo/1smPQ91pc+LMmB6pFiX2GlQc7zARvtfNQuDVTzFGeXxbSf+r98WqeROi7dRaRMEHMDbA0MsV9qEEfHO/iaIwBF6zkDhpKyAjPWGSjOnDdjXmtL2J2fkL3+/BZYeb3aXVLQ2cJRnYyn03ofN1+JxtaY4OByQFZprJDqvK9W5Gj8ksmQMB7V/eTKhgVdQ20sDSq3/30ytMgBef67ovgj/5KMEYp/7ONqNN3wsBvYkMLEUseraZaqjnh70dIzxoKcxNxrcOzePdS75PewDTkcwu75woNh0DkaRbkkJLAHvyXfQPBAnKctT4/Ds1nprgkPt1OEdyqr8nNe9vYOvmF6lunGs7HN5SIzUsrlfD2kP2a1nZwLAkGX41h+Du0itJOCYZR96b37mCh9hEbljDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kees,

Kees Cook writes:
>Swap the ifdef for a CONFIG-controlled static branch that defaults off
>without CONFIG_KMALLOC_PARTITION_CACHES.

I've dropped the #ifdef in v3. kmalloc_partition_enabled now defaults to
IS_ENABLED(CONFIG_KMALLOC_PARTITION_CACHES), and kmalloc_partition= is
ignored without that option, so new_kmalloc_cache() doesn't need any
#ifdef.

I've kept it as a bool rather than a static key, for the same reason as
on 3/6: the only reader is new_kmalloc_cache(), at boot. When
partitioning is off, kmalloc_type() still picks a partition index, but
every one of them resolves to the normal cache. So the flag is never
read on the allocation path.

The one place a static key would actually help is kmalloc_type(), where
it could skip picking a partition and go straight to KMALLOC_NORMAL.
Since kmalloc_type() is inline, that means exporting the key to modules.
That seemed like more than this series needs, but if you think it's
worth it I'm happy to add it.

Thanks!

Chris

