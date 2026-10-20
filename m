Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076E9606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QuiQ4VLd
Received: by kanga.kvack.org (Postfix)
	id 013496B0473; Tue, 20 Oct 2026 06:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06DE6B0474; Tue, 20 Oct 2026 06:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1ACF6B0475; Tue, 20 Oct 2026 06:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B869B6B0473
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:20:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C85112011B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:20:33 +0000 (UTC)
X-FDA: 85342610346.05.30A03EF
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 42BE7A0009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:20:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QuiQ4VLd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792491631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1CD5KUc+O3Tx5grzZrjsKykqx4I2RzLAmwE+DSm2ZA=;
	b=Kwl4eTa3ejgaUuasSSOpk8VC0E9BRThUedry09+Uooxgv0MFfHGgr6V5fDBEawTOka0pzj
	3q1jjeMUmL63Rdzb290ZFTZHaOsAUK9+OyGts0jlVe6kueSBsfzA6UirnPTVDflT72Rgh8
	//+98+AZadjOHmYrqHL8h83qX5cmSPE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QuiQ4VLd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792491631;
	b=5bP1WQQ5ZH7/BazbooW6qA75TEQY7l1s8yQ1is7oOb8ofxns29o3dV7vJJac3vpS9H4Bb7
	vas9E0kxucUpQBqXRJwb4aS5ah6ABTvZ3dV/jrbZJiGoALhM+aXJWoMPc043SeBh9vFc8P
	Nu6d5DFNjusa648GYA3adhneF7e/a04=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-398b3c37877so1748629a91.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792491630; x=1793096430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f1CD5KUc+O3Tx5grzZrjsKykqx4I2RzLAmwE+DSm2ZA=;
        b=QuiQ4VLd7Ph31WDz0h/6P050kziT1OLD6I5OyF1rhvs4apmxr+O6osXp7yy2mBvLDq
         CIfEdqWKtwaymucHDImzmLTsw004ruuBA5avRnwMy5Ngk3NvGs8jNBiChF9B4gglz+ON
         TsM5apbCclFbK4BHqdfjO9rsZPG9zetecn3At8I04JG69sIVailk4VZuU00z/T22uBsw
         iy+PHjaDEvlyc6ZRReboIxyWXcRVYp++3FFuey4Tox99ajtbL+UyrxIUGw7VmXVtOK4L
         fSEsyejEO/F6lQZ7uY2MoDbtJE4KFZImr6SnP5QvtInZ2a1CmDlNFaJihsdoU1bknShO
         Kzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792491630; x=1793096430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f1CD5KUc+O3Tx5grzZrjsKykqx4I2RzLAmwE+DSm2ZA=;
        b=tPe/2KO48uhi64JkvWsvcirJHfv7Ty8E96LaHXDPoUn1G3o/s7gk47KliE8V/uFGkx
         wDKBzvkB+PUVs9rZuzFjzmiUYrBs9bxx7GcoPkq+1Zsa2lzIJAnJRCP6KaIjP6Cle2E7
         xm9EFG9cj19fWnucqWHxlElOwslD92u/Lbl9A6Ux/bcBcrKYht3DpbKf2msFCCSA4wVs
         sroQNtBMaNmKgZ9AUPmYJ3ooVxgfnKPhGD8SPt0P0j+RKVxTmaDqDhu3+ldFeuphMd/z
         8t5LS//XhwbdJbsHQ0rNg2vTNwey8GVvOpW21nTg7YPUnm1p0EgDvfoWFhineRjYtsLN
         EIRA==
X-Forwarded-Encrypted: i=1; AKwUvBxuUhcgT/VxYUyWL7TuA8TflCSZ4MUVZzYPaYktLCNJ2nAj6OLDQtNcrquS9zngGWIKCseL2mrx9g==@kvack.org
X-Gm-Message-State: AFq9FYLvPKocd+uiS5LAKwtveVsmlFmSsTNnDMSO3nVspL5u8BVUlyLY
	eyJ/7kzDe11X84MPzdPDa4Nmdu9o5OMnaqPJVUz4zs3m8G/NPVr2Hygi
X-Gm-Gg: AYBFou26YPF0JL/6fNoNppX0FkdD1V7B3cBKY/KGEttgyPXRjTDX2JP+rS8jfHXGa+/
	5DoGeimIYAN0LLdG40H2dbfqJZ7AJm+T+8eDB6UEqn0FXe1nsDd5iRNWMT2WMtnHHBXkG8k+jBJ
	N+b2TuvpqRwh3Pjml9l4pScHiwuueeDk3DKFAX/uB37jqJuazB5SqOgWNnmuejcbg2cIsKGeYtO
	b1ku2t98xiRU40nHsuZi5MVw/42jCfBY7ABfcUOBS+6XTSvSP1V525HGjR6V801+7xT+cphb7Ch
	4d7cjJ2NMH4CFtbsdkRPRTUCrW4iUORGfYyQ8X7a02u1Bn6u+rQMuEBC0GjoYivFzEpDnHvxuQ9
	E6ekuBfEq0x8wgI3fywmnWymLqvIKI6FeVaoBvsMBDv+Zdi7YmoT4Z/fh3NZTSQlHS/bvZxxVHj
	RWLjCxhO8IvvYa4Qa8orkmeBZ/eM0mVEhmaMe2OEOI76/KAJABSyel0KTWQz+3lYYXJPrtNJSva
	2tgtyQMFfBs
X-Received: by 2002:a17:90b:5111:b0:3aa:f4af:1e0f with SMTP id 98e67ed59e1d1-3acee292795mr9830043a91.8.1792491630077;
        Tue, 20 Oct 2026 03:20:30 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm9872459a91.4.2026.10.20.03.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 03:20:25 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: david@kernel.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: retry private VMA locking when unmapping folios
Date: Tue, 20 Oct 2026 19:20:12 +0900
Message-ID: <20261020102012.1775940-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <23623534-a163-4ffa-8538-b5aff7daecaf@kernel.org>
References: <20261015170551.2656546-1-4ncienth@gmail.com> <23623534-a163-4ffa-8538-b5aff7daecaf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42BE7A0009
X-Rspam-User: 
X-Stat-Signature: rda5jwhdct5m9x4ajpppinye4cb36omy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792491631-294098
X-HE-Meta: U2FsdGVkX18j7fp3eiDyxwGQ5+kP6mJhURq/1e7gP2xEWFLPOhCw7p4Oe61WxvYmA6kB0b/E1NHcny/W1GWxQcNla9olXxs3JeS/hAJYxqJw26QD9BO02n1BC9bonOK76AfUDJN1REAn+jsLtmd03oPap7+XPqgImRArQway/lP4a7qO9bc+LzlFRV3XXWW9uAj0gskgNVG+YOojTXWAuDV+/s0hVOkj4hII8cAbQAJ9Lw4arGWZDHTaGwmUHGPPi9J150CUuE4FLM/bZHmuWvh4KNymJQLeKtM/1IR5KBPlivmWBGTTnWzKHXa/IPbYlFP0labMBMe75P1fbeE3+1FMFm9PEfJrbbQ+3jvktbYR5LJWmYyOgXoudz01ZMyDozbh6jGdT189wuk8+KCPFewNi5yfZn4AtyS+Cdcelo7izypunuYZliepyUxtq5EI2Ut0IOMKAGADrbiGxBtjiPQHuf8vYoYvRAyV7nyjuGZJgDI9zxAyZRFdhI6o3EfyloqoSovQe8XTF/EEuuY58MObaYELJVnXGwwyftEOkGHdK9OECK+53I5Cuu6UcKtXoUV3DSvRnJixXYX1T6qBaxxvodDKQHWZ5/luynaEXNWos2UXnKHUxmkw0zzRu/E1NI+7F4jvcBNYwXcn9sgXaDcSllNQhU2WETO60B4WQihYxenqvIb+AFt6HU/RnTSZf2+CyRcUeSjEFFVf7PYid+5fVGC9OkvwvSBGSKpOCThOb3fbSz+MnCGbIn2MOAxgtiwMh7pf00j1AhOJzKXpFw+VapSRYtJ/kvEbg+tZNn8CHuKhhbNhu9Pu44tPpfNwlbjRDrT6uh30YNZ1Q5Q0YD+FOk6diNpA7miSBvlWY2dVlsQmsjcCdTU/NXJAcLl4VX5RRISYQNIgeuaIkan2I1LibBIOM3QI7n6CAK2QsrkH+kz3lvrWXGhTS3EBNN2ua88I28mY4lwgS9OlBqs
 UDvucfEU
 0W4RaNvCgRZxBqV3vwbIrjBniO5IjAdS5gOk0z1wtJLcivTYuRs5eFGdlGwp9YsFWIHUsD29LDD3TXr23n0PJFDsXXtWOY44XFYw1ZLfm5oJKxnQ3YMgZtm/RNd0szYuuo5OCJDUvOUAo5/Lz+Rx5RcuT+3zFfju9Q4Rjvi32BET+9uKw8/mC+jVdFnTJ6E5myQjsdennfnsi9LyFV6FEjs/G7iR2F31M/GJSY8Orc5BV0aHp4fjy7g1n+ZWnKsv9ag1t0nzykX13s7mjVrPE76F1QKA7I2+0m3hBR5vra5x8MFRzv8V0UO/BON0iDuqPYyc7AW8v1iFaVn/1a5MC8eKaLCtLQq7P5T57B+oyHMk8QyEAaDIKbj8q995amYRtgh2nd6HsNoP+tvTwn2uDB1scFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

Yes, that makes sense.

The per-index fault mutex excludes concurrent faults for the folio being
removed, while i_mmap_rwsem keeps the VMA in the mapping tree and excludes
concurrent page-table teardown.  So the private resv_map lock is not needed
in this path.

I tested the exact diff from your message on v7.3-rc5 with KASAN+LOCKDEP.
My unprivileged mprotect()/hole-punch reproducer completed 1,000 rounds
(64,000 hole punches) with no KASAN, lockdep, unexpected warning, oops, or
panic.

Please consider my patch superseded by Josef's fix.

One small typo in the quoted comment: "i_mmap_rwsem everybody" appears to
be missing "excludes".

The quoted commit also predates the current linux-next policy change:
`Assisted-by` is no longer a recognized trailer.  `generated-content.rst`
asks that tool-assisted discovery be stated in the changelog prose instead.

Tested-by: Daehyeon Ko <4ncienth@gmail.com>

Thanks,
Daehyeon

