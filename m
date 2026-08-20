Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ECB0C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 12:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7A86B008C; Thu, 20 Aug 2026 08:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6788F6B0092; Thu, 20 Aug 2026 08:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569306B0095; Thu, 20 Aug 2026 08:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4466B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:26:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87A20160137
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:26:36 +0000 (UTC)
X-FDA: 85121571192.08.533BA53
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7F6CF140004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:26:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ozF6oqdt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787228794;
	b=Ju8Gt7YJLvZKMq0zduOg4i9yNyZClOASNn5L+z2vCwgOp67vRmwhyYDkEE4tr0sNA5rpz9
	XyB5h5m4XoIb3CPVnm4fLaVVrz+wpZTC5eBwAAbduyYqxbrxQaIZGVg4t36LArgm/cRaAF
	3UwkBtLfzsjXfXCVXAZJxNp0Kt/sL8I=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ozF6oqdt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787228794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xmgl9fug7nRyKGHgKexZEf2hsDIWJMU7TJaw/LGlYs=;
	b=mPmQwBbMDWZiLAejxOWIDteQxtck3yDdFSq+fd8Bbbg6QIw/vtq/3lj4scdykjnKPLK9zh
	lpsVhzTdCQjJRC8v4CFmk7MRLGEEAike+tLOn0/7xeC9FFfM1ptKd3NqNo05wkG3KHnxvq
	5mr4YAHEcRij8JaoqTmcBcT3GN913Rs=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a18840e2abso3558017a12.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787228793; cv=none;
        d=google.com; s=arc-20260327;
        b=CuiCH2poxv73Y0ifvheOihP2HCuEm9oWleyalp/VuFmzr9MC3hCk9ZCdeZKuyNWGaJ
         Wwn0zu4RPKWR73SEe6kaSCP/OBK2sTZJ2bNGAtkfEZp5tnhRi5IEjMMu9jneMSquYuYA
         lsvX2cGSkLN7eV+ZTOwg1jpLzFDUUvAZzkvpVPHYrps8391Bz1BaDB0XuhhzpUw5oTaO
         xBdISeKkIMhF0T0E9zYPM/Siu8miwPvKk6Vv//Alw8arDwzb2/1zz1s+rAeR5zrCRMTj
         eBAvruAs/+lanxMbax6fh+r+ig9iMlihUgEBE4ohFuxLaAzStDIM/K+8zhqDCKUPloVr
         ZL/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:dkim-signature;
        bh=0xmgl9fug7nRyKGHgKexZEf2hsDIWJMU7TJaw/LGlYs=;
        fh=SJHQrXVS/sjpx+sl4xnxky1R7IEPPmbGhmPUlKtxhqs=;
        b=F+MgUTI0s50MLI88PxP/vWGGRpzOp4tf3NcsLTLmvV71H2IEAlwIDLrGSDTGrs8nDe
         sVHRXS0NsTwkWJA83rBqVfz8fXTED1Wr0yHtc2uMOtqJ3YyC5uNcgV4OKKXMTPvTXXEV
         mXTWhGGSSjEqvsPsvT12Lkfek+0pTHAOiWAhbCKs0eYRSgp6zD4tZ+PrXW5V69QdzfAf
         hDeyfYGLaLLJc6mTJ1P1Le9SVamShmHpU4l+Y2Qp9Hgk15hw/OlZF+hcSwpRo6Tzvh52
         FngZr4yUNSdvEtiaw13YSdTv2Pz9OS+DDtf+9LsyPvh8K6FHCBV+CqqG9Ho4e+GeiFJP
         lVbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787228793; x=1787833593; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0xmgl9fug7nRyKGHgKexZEf2hsDIWJMU7TJaw/LGlYs=;
        b=ozF6oqdtGF4MLio2iOWcWeV+wJKRvfEF5SPb329lDFp0MaRJ+UlUdkmJkEeyMDrCkI
         CvoyYiIBRmfMh8MwWvD3VVYRh8ntrozr1fbbV/nCmR/1xmSVhy5MHX+KejEDmD/DlQDe
         xg4t0b5jCA4WmAGy2sP4Qk7ZzewdolIqI36vc7vkTswOKis07kjyP5JBKaF7HWYBWAWi
         eNCOWNkpKSbzpGchYDu8xGwXAm3uL9FBVrFsDEMM+icCFvPQh7E+GVlVs82JNBochI6H
         cQBzuMEtPop0V7GS2C1QqBnb4kcYTefTnoUMp4zbtcyMLqskxjnfOXlXySHPcqe64sb7
         Fh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787228793; x=1787833593;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:references:in-reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0xmgl9fug7nRyKGHgKexZEf2hsDIWJMU7TJaw/LGlYs=;
        b=NmL9PoeNzW5rbbQPenRT8s8cG2zpWH29gjxUZJifqx98GcXfi9fuWzezdx3s1+PzDM
         bUi0aovrWBP04POLoztbb3sMZFHjPbommwDIDOFvTWcPPM2XvlzlMRTSgCFi2ez4oM7a
         a5ZuXfVofYkFSZJSnc/PeE0VVTAAw49YpHFcXN3juntPpAeLaj3k/217x8R4Kq9ktXLq
         KiKTo3hgFijV1tHM9zHj0/agK/xn7CwbhdShgslSf6VtOPiJ5F60Q6f0NtBWDLXxA56g
         t1HkIF0e6SMFdif8hGeEE4z6aFXHGGifq79P2qz7PXcrCG/zWC4fW39q/7j7H4Jss05Z
         S4WQ==
X-Forwarded-Encrypted: i=1; AHgh+RqoTmSnHfrQ0qGE6ZsH6QL47UkSUWtbcUdKFBRnTH3J8vznTMyZRV+M7LdH8SJtpxVWobImGaSgMg==@kvack.org
X-Gm-Message-State: AFuF++l7w4i4xk7zsFhZFNyq2C20uHlAUZWhJWpLz0RmsdR4HYteeQFt
	d80DZpHB0DOH8vv/sYgKqSawAyBiArXpkOR32iMgt+HtVh4l/zGVjQFEzwVrxFZjDIZb2VjopDe
	6XPkeAuPVEUNp30QvC29DjH3/s94So+0=
X-Gm-Gg: AR+sD10HfyV8DBWhhXhzGCsNf2leeRwtEabDLVHaY6NStZPq7wl7rHUFkMX3+rXRY4k
	zXqFjRs51v7Ew0ccVb61rHnlOn3rKxxbA80A15G1vJwOGYDvwCfQ3ZwIdh7AOyFfSiFjwcNXPH3
	Vk/oeC3+0mVi6jprvIwzRk6r8GbXn4TQUt8mUoLoHp2bkjRQu17Mxff4kzDn+e8HUHAvnejrHAx
	xNs3dH1MdEBYhkUrsmky/bLSyYv9q+h+juujF2U/9bWZfW2qMCCkaEWaO+yLXnKqUzSpUIy9QjC
	RDVjchpES4Peoh8uaRe8DAJUwu6DFpsXT+NYw+FhdhAdOmlWn+BjKMZejA==
MIME-Version: 1.0
X-Received: by 2002:a05:6402:1cc7:b0:6a3:849b:aa48 with SMTP id
 4fb4d7f45d1cf-6a4032b8158mr8565457a12.7.1787228792766; Thu, 20 Aug 2026
 05:26:32 -0700 (PDT)
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 08:26:31 -0400
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 08:26:31 -0400
In-Reply-To: <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org> <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com> <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
From: =?UTF-8?B?YXloYW4gYXlkxLFu?= <nsd.project.dev@gmail.com>
Date: Thu, 20 Aug 2026 08:26:31 -0400
X-Gm-Features: AcwNN1XrkA43dSJ3T3GbJGOoBaCnw6PG9YJBewyvsgjvqDFf-fdILOMtvA98jJU
Message-ID: <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
To: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7F6CF140004
X-Rspam-User: 
X-Stat-Signature: 3z5juoqhbi6ff53br657zcw5syjx7pyj
X-Rspamd-Server: rspam06
X-HE-Tag: 1787228794-591733
X-HE-Meta: U2FsdGVkX1/Wc32Tsheloit5vdlAhxCt1gijjPDFANG221MN8NtYyiOV1+6xjx4YTpYRCv3BdwHjCnJWYkGegGhkXLSq/Li3VTWmCrsXeClxK7bfqhA9BsnZQmZKZDkr5YTgpu2eASzxypAfD3Ue87hAVI4T3tj7LBUobbBeIjHJJxuXxkz2+k1SJRJ5boA1ca6rb/XBYHsWgil9oCeuloiyRDWztNtwZGb6CU1RleJ7wks375c3LPifjoFcGLjsKlSTHg959idqnCaYMrc90/nMR+QUf6l1MGV9zUga0MaENdORVek1XMwMjloBx/Dbnl5wmkFk0ExY7MR1qDJD2Ir56nHbwX1FEKqqdSzrTKqxmb76Bscd0yuZYw1hlZzS4OS2Bvjlwzgeq42Lb58t6QfwOVWsN1FBtuRxFmAiY68LLJwjRoZK7WXSSI0TyQMe/1rtWi4z/hf6Jxwl/2mrTnmPVCRA1/kJGulUKjBGVXVE0HJLMu9vl0xz0jfg9rdYuN0RnnawHphWWvTGY1SGLOdDv8hjxwhrVZbXBmGhsLGWD8/mi/suazebSdqAm/10oz9ymqWOWrEV54WnjxmcB/mKW57YxoHuJGPSuGMHMLqsiUR36KDfgB9BShNZLifwd5CzZUPuX2IFQN8/5QgvIQajGB9w0lNrH1yzEJYtBh7BGW6BDqcD/ZnQMTIyXhMedVydNN+zP6MmCUoBsbL0fCD3N7uLdM/beE4f6hGjCDJ6ee73yQwJrjhurfAt65BgK9gwy1GNTKzXJd4IJvs1uAy/aPf+dEf70t/2mG4J32nvzvs+d1Eskrw6lwXhfyxcKSpLH6++ZCsw17+UuhJfpvRPAga8/Uysb80swnLZ9PN/GVrl/FyRhWRRlmINFGDvSp+l2wuaOV5AmIacaShlU9GQRaikXnjJYJuVqofeVF4lHisyZBdRHsWk7D83st7EPbvk1bXs/M0ab6EkiIn
 pU3QaQLD
 ZfrOCj9FOliOSVWJwWZ7z/15Iel2tp0hm8WwQBcrfopJ58fhwmwzH7a7bR7k0AdiS0pkgy8oyTCJZOg7mdBer9XG52CsAov02hXYc9hs8SOg84YMeiwuDIjkrgSGQ7HX9/AWT3hZBF7WyplFgSg0guJ091L9zthnemEFr1MF/8t1ZhSnL0I+zYY3k8b5Q9MKLhpgqnQg2czr1wpJ6cHNCvhF1gX9kSCFQY1rYzqCFLfkwI/gUs9tk0xC2MkJP+QT6zkxUmReA+Zw8AMs6fIGE7c57bxBAwMF93IWpklXAM57CYKzNy8uCmhRaBGopLBv1LH3EbdxTKNfzo+YY2fg+5OJvJEVtXgI4Pklg4CJqbwUh+f5u4MyUnI8K3Atd6N/h7+7ie7shjUSIMgd8D+xGa3o+bOqXmYGzFFKw5l0y31D3Nuux4NCfWT5BMCaXOX6FEMGEsZRg/KBXHYYo72WaVYTjRIehLcQmpK2mjr6sWUjs7hPvuAg9IXCCTMjB1MlGandU2D+y/z3yXC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Honza, Hi Willy,

Thanks for the review and for the questions =E2=80=94 they pushed us to go =
back
and measure this properly. Since the last exchange we ran a full
window-size matrix with complete latency and overhead numbers, and it
answers directly what both of you asked. Let me start with the data.

These results come from our current in-development tree. We wanted to
share them with you before pushing anything, so the tree referenced in
the RFC (upstream-prep-v1, 2026-08-17) is still the earlier snapshot.
Since that snapshot we made three changes that led to these numbers:

  1. Jump handling =E2=80=94 when a prediction lands outside the kernel's
     readahead window we now always issue WILLNEED|NOREUSE explicitly,
     instead of leaving the strategy branch to decide.
  2. Kernel-window awareness =E2=80=94 when the kernel's own readahead wind=
ow
     is already >=3D 1MB the module detects this and completely silences
     itself (confirmed by its own counters), so it never competes with
     or disturbs a kernel window that is already sufficient.
  3. Full instrumentation =E2=80=94 per-run p50/p95/p99/p999 latency, per-p=
ass
     usr/sys CPU overhead, and disk-I/O accounting.

We'll push the updated tree to GitHub once this discussion settles.

Full metrics matrix =E2=80=94 methodology: interleaved ON/OFF on the same
machine, drop_caches before every run, 3 runs per configuration, 6.2 GB
SQLite database and an 8 GB sequential file. Disk I/O is byte-identical
between ON and OFF in all 96 runs =E2=80=94 NSD never issues extra I/O.

seq64 =E2=80=94 8 GB sequential file, 64k requests, n=3D131K/run:

  kb    | OFF avg  ON avg   diff  | p50 OFF->ON  | p99 OFF->ON   |
overhead (usr+sys)
  128   | 22.02s   17.11s   -22%  | 50->23 us     | 812->805 us   | 5.94->4=
.33s
  256   | 17.08s   17.22s   +1%   | 20->15 us     | 824->1129 us  | 4.07->4=
.13s
  512   | 16.81s   16.96s   +1%   | 16->14 us     | 1092->1903 us | 4.24->3=
.60s
  1024  | 17.25s   17.03s   -1%   | 15->16 us     | 1903->1883 us | 3.67->3=
.74s

SQLite Q2 full-table scan =E2=80=94 6.2 GB:

  kb    | OFF avg  ON avg   diff  | overhead (usr+sys)
  128   | 24.51s   20.48s   -16%  | +0.95s
  256   | 20.05s   16.60s   -17%  | +1.26s
  512   | 15.31s   12.18s   -20%  | +1.06s
  1024  | 12.22s   12.09s   -1%   | +0.26s

random4k =E2=80=94 100k random 4k requests:

  kb    | OFF avg  ON avg   diff  | p99
  128   | 25.0s    25.5s    +2%   | ~0.98ms
  256   | 26.9s    26.0s    -3%   | ~0.99ms
  512   | 25.7s    25.5s    -1%   | ~0.98ms
  1024  | 25.4s    24.7s    -3%   | ~0.99ms

random_repeat =E2=80=94 100k offsets x 3 passes, n=3D300K:

  kb    | OFF avg  ON avg   diff  | p99
  128   | 26.8s    25.1s    -6%   | 0.39ms
  256   | 25.1s    24.0s    -4%   | 0.38ms
  512   | 24.5s    24.4s    0%    | 0.37ms
  1024  | 25.0s    24.7s    -1%   | 0.39ms

Honza, you asked whether the difference goes away at 1M =E2=80=94 and yes, =
it
does, for both workloads. The 128k default is the dominant factor; at
1M the kernel alone already reaches this SSD's bandwidth ceiling, and
NSD recognises that and silences itself entirely at >=3D 1M windows.

But the 512k row is the one I'd really like your view on. The kernel
with a 512k window alone (15.31s) trails the kernel with 1M (12.22s)
by about 25%, yet NSD with a 512k window reaches 12.18s =E2=80=94 the same
throughput at half the window. Our block-layer traces show OFF@512k
keeps issuing ~512k requests, so the device is not the limit. It looks
like the kernel's window growth is capped at ra_pages, while the
fadvise-driven expansion NSD triggers is not =E2=80=94 which, incidentally,=
 is
why distros end up hand-tuning this value. Is that cap deliberate, for
latency or cache-pollution control, or is there room for the growth
policy to self-adapt?

Willy, on the architecture: hooking only vfs_read and skipping the
fault path was a deliberate choice to bound the first iteration, but
you're right that it's a gap =E2=80=94 filemap_fault bypasses vfs_read
entirely, so we're currently blind to mmap'd workloads. Hooking it
with the same fprobe is the next step. On replacing the PG_readahead
folio marking: the matrix above convinced us this is the right
direction. The kernel's growth policy, not the device, is the real
bottleneck at default settings, so we're moving toward a design that
manages ra_state directly and measures its own waste =E2=80=94 per-file
tracking of consumed versus expired prefetches with adaptive
aggressiveness, which is really just replacing the implicit
assumptions behind PG_readahead marking with explicit measurement.
Backward access patterns are already handled by the stride predictor
(negative deltas, forward/backward counted separately); a dedicated
backward-pattern benchmark will be added to the suite.

Two things we're still working on, for honesty: at 256-512k the
sequential p99 regresses (~0.8ms -> ~1.1ms and ~1.1ms -> ~1.9ms) as
the prefetch regions push the device queue =E2=80=94 the usage-tracking wor=
k
above targets exactly that. And the random_repeat gains (4-6% at
128-256k) suggest the predictor does help beyond what window size can
fix; p95 there improves from 296 to 243 us.

Questions we'd value your input on:
  1. Is fadvise-driven expansion beyond ra_pages acceptable as a
     mechanism, or should the growth policy itself change?
  2. What would a minimal integrated design look like =E2=80=94 replacing
     PG_readahead marking with direct ra_state control?
  3. If we iterate: fault path first, or usage-tracking first?

Per your suggestion, we'll cc the page cache maintainers from
MAINTAINERS on the next revision.

Best regards,
Ayhan

