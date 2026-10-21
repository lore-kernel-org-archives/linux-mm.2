Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E86606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=X3mqHfzr
Received: by kanga.kvack.org (Postfix)
	id C84066B05E2; Tue, 20 Oct 2026 22:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34C46B05E4; Tue, 20 Oct 2026 22:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24D86B05E5; Tue, 20 Oct 2026 22:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87FCC6B05E2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:54:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E1761A0443
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:54:43 +0000 (UTC)
X-FDA: 85345115646.20.07A2556
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4017880002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:54:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X3mqHfzr;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792551281;
	b=vxCpoNQfSNkRkcF5uW4R123S8KSF8ERXNj7CGe+bdgvEs4XJOjPE/2JlwrHjbM0WRmBL6y
	y+3q4jW0pgd1/LeZS9kGWZzIV/bxreszmcc9OM36X0AI+/zMuapF3JV/o8WEEQQEs6B2Oh
	xTz78e1w5gL/dPrZX5gKFpzOHDr4nZ8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X3mqHfzr;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792551281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSA8sP/l7jXaX7+Oajvaq7NlGy6nqeA0l/fafopK+Hk=;
	b=2sNPeaerdml8uGHNVwdCOMGoXECEElWe7eechaL0fp9KHv2+mCEyGWgbw5Q5vJP5zD3VOA
	Nm89y3Y0/KuN7Pua6t7q/e3sqtHpDpvFoQ8zjnAMp+Qkv4ZIO0sC8l2KAJlLIeTgQrxA7w
	pbcqqHAFSHxQoR/D+rP32o2v5Feq6iU=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53667180af3so2999491cf.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792551280; x=1793156080; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dSA8sP/l7jXaX7+Oajvaq7NlGy6nqeA0l/fafopK+Hk=;
        b=X3mqHfzrVTTzIdiMHNl37KwaNbn9lMFsRweOIdeitjqQCUuETuoWgpnXPEKhAtvMla
         M48IOUCwfzxjjS34kJxB98P0C0aA2gL3bNgfdAIlrVz7xcO6zy1Op+EKVj3ycqyUjw4k
         5XUyY2kHiNG3F9VLt/nPqwbTxdHNuySB5JjSgxhbUOg7RDT7PStFs+EjBV/osrGAMsso
         MfUnWVZm69PFu3n0f/kUAUfv7RDK3s3hAPtsiG8FXapM5x7zqrJ/hg56GnIw1M0aXSkC
         BgaEkXpy8jAxhorNEsejeH/cN2OD2g5+xq1ah4DC5jac2COBYDWBTuLG83i1orF2+Q9s
         65JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792551280; x=1793156080;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dSA8sP/l7jXaX7+Oajvaq7NlGy6nqeA0l/fafopK+Hk=;
        b=tlIJOcmaXpOE8nT9a2ZCmh83bXySdrUoFM1eD1BrJSkIzgK/luLszNxW6fSljfcg2g
         Rz9S/OtCOKxE1PAT3CoFQAq16Ph7gmPlcGxOzbUtTX/8o7AeWNrhmX5ju2mLXHWyq5BI
         xpgfCa2qkjVN8ed3hPAojye7XSQGx6IQTmsqKDdbUQzUa0D5Z3VL6ksvVO3Fd1Kp1O1x
         OTQ6rdvnTKVb4Ckjv9SvYDFyg4xE57hWH99egp17k8cSaEiIB1d7Dn2E7S9ixRXVw3/r
         t6Wn5RprZwD/DlYpnjjntkrYCYsqfzM1fweVK224Nx2IKLn2XIngrtlqg32QWTTP3N3I
         WqTQ==
X-Forwarded-Encrypted: i=1; AKwUvBy90qVOS1SGo8DTHSFNbeKTqDdvd7H6T0STLYBzqIW/ZuUtgzjbqTQ5n0SY1fdfzXG4F1O4nsS5Dg==@kvack.org
X-Gm-Message-State: AFq9FYIzyvxxgXARy+/h1ht+POwDCfkp+HqH/HQ0Nxh4mhCDB5ZuIAOB
	QpA+NrQVwAUznr7GN8xmDMU6SndLfpOuVZ2kzLOQK1CroiOOvKuJ24WukbZyyQtZW3k=
X-Gm-Gg: AYBFou2pfErVwGtkCGxl4EYO7vonxuZ3/b4QHnlp2G4zkHcpXu97t63rbSnE9+r4uAq
	CxswkHUbscRFGzzQGWFVhjGAYVh1r3DxUnyrvuGsp06dCLEO9yPQB3MFgnSm0XY2BLShlpwFy/y
	lO+9bRMj/w91txrgvn+nNmffEN0wqYd4N/3JL69ARFEJga1N6e8fgTWnzXnXB2o4LZcnFz3eTiZ
	Znm5JTm/nr2DHa8j5fyNZSJTCy0HYrGEafA0xoE3wAI5/9A7dVcdae7FcYDCswh9zhQ+jylMzNn
	mczJkI25ZPvvguNd+qFgwT1wP4CfPqtrMDwB64dTA05PMXqQt9tDC35vl3H2TYGpz+z/YC4+xh3
	8jGzgYP2WpVNXEkYw0Nulm9v0PKJIzkKYldsErEWuUdnn+oEiu2Jrb9MeqldfgSrzeLpOg+U1YS
	gUccM0IGBpiss5JxK0UekhEKlQE65wfcHCwOUgdP478yjQ9VDaXw6AwnSeqjcqHuE54aD+o6W/5
	OwoDheBJU2YaSjiQOaEOBE88lnXYy0l8ipYllDYBjZ+OaqEVQiCJbdotguOo2sc3v94rdHINW5p
	pWqhMYKvnk8r/vRBPiJJBBsMF4g=
X-Received: by 2002:a05:622a:a15:b0:535:a5fb:645b with SMTP id d75a77b69052e-5369b8fb767mr11805941cf.70.1792551280390;
        Tue, 20 Oct 2026 19:54:40 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53698b290c4sm9952991cf.12.2026.10.20.19.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:54:40 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] selftests/mm: merge: reserve the far mremap() targets
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Danish Khateeb <danishkhateeb03@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261021011929.89150-1-danishkhateeb03@gmail.com>
References: <20261021011929.89150-1-danishkhateeb03@gmail.com>
Date: Tue, 20 Oct 2026 22:54:36 -0400
Message-Id: <179255127693.1919196.16421147648649712106.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 4017880002
X-Stat-Signature: nid7run7ne5unr6n894ya8gj4mh335bf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792551281-235382
X-HE-Meta: U2FsdGVkX19KurTh4zQNuE0BswFzyUr4BjROCwEmIgGBzicaewfdQAtFKnbpLuv8ugnydubpP9fqnc0lSi2Bb3gdYrcHoiH9vqHDShM10YkNC8GmnnPMxmmvle9JAzOuSQak5LaDWn8NB8Hf+Skji4pA236gnMt4/UOvrjUjZWqCPmsu+tKt0V8zOc450ArzeUUwDbO8emysNaiVYBLdFyBZOjOe0+wc524JklxyAS+3/fAzQV/Zxz0KJKAkRPUZcehqCFgeOYf92IIgxwwIXM6UWur0KJhm1Zg4HJ0vJPnpIs8T+mR279n10tkNCcf81i7/jj9OTJ0igpZu8L0xzs8DGbWuY/773qNSZ8OtToSx/W6Q8rhimJUvKCU2S2o2+T/pVDiKr4zILVi7cSl2LXDGZYKuIMgfEvdMCgV4N5hunFwsUQkhREiWxy43fn8+/ps0BjUJypEE2Gt9kY5G7psQdz546nAZUjeY+Z6JRpAkQCkmcqsWrKiEHjb9kgsCKB/SvEBXV5DJ4HdrnKz6g1QEB8H1zu69gEpnI529CUYPeTg+uFLABDkA7Ruzt9JWDKQEFdhe0FAzSYj7f48oW84Qa3AnnK9Kj7WLO743jB/ZWLjLoQRrQ7YJquKp2z3StoSR+GNjg/S240MIJ9k5k+cwEILhFth7sv+y5YJxysuRh8G0ldHcOl64JU9RZF/xr2kli9aIRZ0Gtav69zqkrdJLcoCp8g1xPlj05AjB2WNxr55Q0oDQQ0//yK1SyUkjT70+33sNEly9wudTRc4YiLWQ/EHRfpXicr6b4WpCPuTfnLEre0A0HTWDDd8989sqas9Yr0MS+yEe3fGKSe6+SOg9JxXsUBDmJKRgQPTd2xt2W9QE/CpsMuPidIhppSppWB0AzVVmCb8yKu08a5FivCdq3C4C5C71gBuuB/dQI4l7EcNCaMBIPd3cE0mj0dQ0euPULiJY1lSviV/r8r+
 Pma2JDYs
 K6CWe6Ut6TPOXcQL0bcK7E5RbOZUYcQUtzxZS47/HY15U8g7pdN24Qm4rjlcK0zYQSJT6MBnYy8J5knvNyvlaepV/eZPdGMyXB8+mpd9wQN1fYW+QdOLVBWSbxu1+Kpc/WcbqNp1hQXboG6j3QX17tRSemdROEUGd97Fdu3c3XKF9G0VfFdXzmyFR8FkmjgcugV+KlBQfSi/NfS54nGInj5snDUU2eXOgtujn1nQeDnO30kOTU6l6vNbK2RSpgj4uO0YCgnWtTXiqkyiPyxQ/YgeRFjxJ2ocifznnZFcr4ExV0Bbkw8pUovAd6nWZe/KmLZ/40Yr81fjtzAnGUF+Aa6Le/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 20:19 -0500, Danish Khateeb wrote:
> The merge tests map their areas at fixed addresses within a 30-page
> PROT_NONE carveout. Several mremap() tests move an area 1000 or 2000
> pages away to separate it from the others, but those targets are outside
> the carveout, and MREMAP_FIXED unmaps whatever is mapped there.
> 
> Under virtme-ng, the shared libraries are packed right above the
> carveout and the dynamic linker starts about 4 MiB above it. The moves
> then replace part of its text with an anonymous mapping, and the test
> crashes in its next lazily bound call:
> 
>   merge[6980]: segfault at 7f7ebb3c1e60 ip 00007f7ebb3c1e60 sp 00007ffd35fbaec8 error 14
> 
> Two to four of the mremap() tests then fail with "Test terminated
> unexpectedly by signal 11", depending on the exact layout. On a host
> where libc is mapped at a 2 MiB aligned address, the targets happen to
> land above the dynamic linker and the tests pass.
> 
> Make the carveout large enough to contain the targets.
> 
> Fixes: 4e25f85b9f85 ("tools/testing/selftests: add mremap() unfaulted/faulted test cases")
> Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>

A better improvement would be to tweak the tests so they don't use
magic numbers like (page_size * 1000) and it matches more statically
to what the mmap'd region size is.  Otherwise it'll get copy/pasted
again later.

(e.g. please don't just update the mmap, please update the tests as
well)

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>

