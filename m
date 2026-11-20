Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A471F606A338
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=raP1nMkN
Received: by kanga.kvack.org (Postfix)
	id C62276B00EF; Fri, 20 Nov 2026 18:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39A26B05B0; Fri, 20 Nov 2026 18:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B676B05B1; Fri, 20 Nov 2026 18:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8952A6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:16:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E0561A022E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:16:48 +0000 (UTC)
X-FDA: 85457059296.07.4944942
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B9F518000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:16:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=raP1nMkN;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795216606;
	b=E4Inefx1yjwvPgP/l8Wk5zdYZl/vCoraOPslW3yUOBCKBLRK+F1afjEsZmqiNy1nXlXUgh
	NBsxlk9iqYkB1aaM0Y1L4ySp1LWWKPOvYaXFh0OMDIyb7TPGZ8X6oxiYYqWYvWTQh7LLOo
	Q7M5Nd9UffXfw3R69p9Q744vCHlq/D0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795216606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
	b=KGLBtzoq9vGOM5wmgnLgJetLHDrwaqK7sssocyXz1MzV7y7TeHRfWf+42vwBXUYEGiT98p
	mUxaq3tTlzW+gRmm0KXawffrlqPRCk6klUXqimH2eUNfmw4DgnOa633U+lDUw1OkwvY4IK
	d+qhIFBf1Du8DlLTWeg5FGtkiH8tNQM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=raP1nMkN;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so13212235e9.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:16:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795216605; cv=none;
        d=google.com; s=arc-20260327;
        b=DjuBEE/S1EW/qjCUmDTY1vV3GMnuI0RlP5lenvfSH1N8oK5N/DJR/VSSoRVP2q0UFz
         wm2Y9Q00z/Fv5Oh0dBJHPaRaYWWkl1MG/sxF21UvG6I4wmnxiWMieRkZvO9IqEOHcexe
         3LHAl/3tG98EuywRMNBxXnJzY8OWhDmz3BV61LhqDA6S63ua3dU/GeQ9DkxsrZUxcUwE
         t4jdpCQ+TFFm1MclELyZvdwM1EPEMBhCv006Movy53+nzayhk0vpb59Pb4qtBNp5ZK8b
         hJP2qEVafdMSUTlcGpYHorC7cAgT1hgP05m1ZWeD/oyb1B+++8NsD/rr5JcGHwbQkvN4
         Crrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
        fh=4m4FLtzntvowZK56Ra+ACQSOr2bbMANxB5fmcuBLQp0=;
        b=g7z7xinP1vfk2O2N7uIsKj7LFX4BWWo+PMQGr/fatmrrcaCFkWvMfc1AQgLchvyxI1
         u8r57XdBGLQDI3JwYYCwGTp6BHD87xwd3sO3haGUiTM9jNADR1Qx8/aIw9Fd1fLUAfk7
         WgfeTaU7HqBa2ao/qEhMwxuko2rtmhc52Ky7eMEOtBgjseCPGp1qpU2DVHDD+kgfQfiP
         qA+OjtK+CLtuke/9EgtLUuvviRIqgbJyx+jwojZ9X5HDWNawfo4Z7y9/zTiK/4yGWgah
         PRlsvfhHszY6JaaqEW1z3JR3O7mchAt3ReBS2ol1X3Qxo3ydifo3RsR4ZPxt3zzsY5KT
         Wq1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795216605; x=1795821405; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
        b=raP1nMkNO5kLZEYGPnDINREwX0jOGBFGVTyWtB6F/8W34SIE3E36VjVdPKkeyFKDRV
         +ZbuqJPKg3nN2VjK2JjFQYwpnUn/J04mPid2+0Dc9s+DmkN1GLFdlXrha9Dylwd7EaXi
         RLnG1SKp62dUyF1VcQT7QPEFeJdewxUpwlcFfLj7Sd+ueso0IJ0rBPzX+a8wuvNdG7ow
         m7L5//d2yKIF+OjGgrW+/O/imdYX8vNBezZIvFbGyaFYJq+4biKeYCc8MjfeMxvUrlOb
         QY6cynWIZW6OaPD0gilZm2aGy+8hzqzYyl+KfkJocNS8AIGFNknoNXY1YcHbRKMu76dY
         nyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795216605; x=1795821405;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
        b=wP77+EgJW72zdwXEYSi9F2KNs409N8ykB82uGp6Tbt0IQtaFVAXQV57/jTYFFtdcx/
         Y5VQKn0DbKmb0muDUHp6Vk2tnac6/SL/hdPvK8UsBqJFRyJ3BNCOuUc+qR9AqtnAIVBb
         VOmsPrwVoLvqjWzT1zzFR9CpzXM2EkNTVk0oGC9/e4U/7Hn3uutoKaf0JffWGDSLk1SZ
         uMh5Hj43eWu9Aq5oyAmWYyPALOVSVahGqz0HF8ORJ2n4B+2Fx6M0X71A6tOXuq5xBsh0
         jExECrmIT/A1Uv6dRjDgexTX6yxpufqbn15Y4h8PF/6jG2dyGrhJ7KbjyQbSofL1UFO+
         hI3g==
X-Forwarded-Encrypted: i=1; AL+hErHZ2Nk8PGWZIvQ48RfUiWROHvQvLOPGTcQHEsFwdY36zDTUmtkRaITXUQe6TaIEZCgMeblAbDvc+w==@kvack.org
X-Gm-Message-State: APuU4Z9+yH1Sz0c8+wKkGVuoazLASJXWHwKpD8n3x4HHfPjaj65G8bDy
	WG6NhiKUpajaj7m0yEd4PLcMsAY7/u0ZbXza7tCABayZXSHLSt3+thxmFt7APv3qN6I42xBtWRr
	EaEGQvnBi1uI7l2kF3z5ENWhM/TrQxII=
X-Gm-Gg: AYBFou2cFxkb9fjv+Azc+R+l+ncYu0dqIOtviqb7V3QKctR4Lsj298T83VS0/oQmOIc
	/ahrUbsTM5hbITIrsqtXMxWSrkyx/MkP9tnbhc5Cp4iG6216D9MNrlhx5dx4G5uZv5tv2hjnx9r
	xsqd7EvkfPV7fudrjBzgd4cRd82h5HW729UBvft6nOOJQS7c7d18cQWJo1Kurt7uCkHKGe45nUN
	uD2Ozod4kxD3gZjTo67UcDGyAp7ZWZdR25iSZW5VTyp73YkXGzJfcjEp+jguClrD6b1PIV9tiu2
	aiUNYJ+c+2ZZ/kVEtUn0+uM0TBValot0fgdBpjZVT4m27NoybWgBGI+bfZ84xpuNowyERzXttjG
	4bGW4v2On0isPAHOK6xl4sqyzUZTsd8fYjwV0gwPoZAoNorgKLl26/yz5fymXUUSzOgnvzg8/qk
	fnpP0qGeDnAujrucZi9Dw5wfOeSc7rG5bhxjbG9zpI8CfohelGr/kSOoA=
X-Received: by 2002:a05:600c:4f0d:b0:4bb:5c97:f4b1 with SMTP id
 5b1f17b1804b1-4bb8881941bmr114007855e9.24.1795216604602; Fri, 20 Nov 2026
 15:16:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 15:16:32 -0800
X-Gm-Features: Aa3M54qb-VRfw4aqDAJTkRsfWHOO2NSgtOCHUwUBMLX8ioDWk9vsNXzApVwB4Q0
Message-ID: <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1B9F518000C
X-Stat-Signature: fa6fox8yawpgudubwaagihejreknnnmf
X-Rspam-User:
X-HE-Tag: 1795216605-340393
X-HE-Meta: U2FsdGVkX1/OrWLjxMSDqo16Sxd2zP7zcLrzjMgsH8vT0FahMuEUYtYn1s/5e1XcGR5u0VENDJkc//xEY4IFv//0BrAjVMLas/d/EWB4aFEv216vPpMsqDbWoQNFVf7cQKG7FvlspHnPC/flCRDNTC1aMUATPPR4mB7hHgIBBEB5XhgaITMLO9DMFrFlWEgI/3j2K+aF2QF/fr//mMLxl/+Yrink9idcXhQtBlVgD4o24/5uzwY47InK+EP11N0qyEGgy8LLN/kAEkc7GsHAydRY4FcWRy92QcrRbNniOXq/psOuNlSV6hpzRmyVssF8zZ8J2XC8cMQwr4vdmTiX9v/Sverjb2K++q4DMeBgmudZCg/RQd0+pi9KT2BsQQ+kohjmzplFMWITzrUjNetfqHt4m7jrI2IoYFFKm+ZWuJEONdW+lYq2Z9Ic8THDpJZ5mumABZGUPEpZ6yvE8zho74WolCcn2/29DdjUDMVg7jeiK0yPAMYDtQc0zjzoT+U9uOKXbYxGlkgHXAQxqnm0fyTsGayC7nYok8lf2UCUZmMbHr3i6zH0DJn7ln4NbGnZ485Hy+j+RQBL7NAkGhiUHYBsTMkeDJdwkGEsv1LnJJzRtQsYliXoWKIjVaPqPfAlzYvr0pWNvE4xcwCDquV17Ky3hq6uGpV/Ga1znlsiQtRynCOCFXoXeGZ/TTjW0wuaE8YNv6h2+lYDzTTb4PF+qksfiK8A3KxXRimpwfDFq9lDBqdYZEXoT5eW2R60deaQclcTN1/Jo15egefHVNZycVdX42R5jLP9MdTrh8sldAfMkcTjEgJYxV9s+84oYRy+DAfFMjerFFvGiHBXgGuFZQcU+bfKDA+e0Z5P0ZPLYHeyCiFFy5LDtE2wZ/LethPcP7Cw0vHgNLkugeCcjC/nnYWchP4OVr7EbvY2w82oYwfQEog8rtv4dATlxDE+vHOXXvrq4MFJZOJ1X19K/dy
 792CjsPN
 7HZ7K1tgh+Jn1/3Asw7Q7zYUy6x7SAMJqWXdPx24Ufvxlpv/p04ZaTkMJtBFd7EcsMdPPEWEQhIiDrr7bXqpLezwwqQBUHWOEkrPis8DneoYPgqZjRVhHf3rTALuQ3bEKEOLLPBJgW8v8EC3znOTLHqCYIKgzOAX72IvJxau29btWBy9fbt2z5SliOV50TSTfglzV6B3yukJLwu8JfBxHeVG+q6660e9iQ83k16Gu3rIBur/nioW9nI9HSIscHNm8MIbgL8HP0/F+jLZWA7TgD0ynnDOV/S2DZQ8SlOIpTn9l/haAUWXmj+sFV4HoTJNy9oont90mhb9RMAeXuzo/Kje00ATgeyCM0SnarMlz4GS2D7yrh8O1Tnff+jvcMHpWJHqQmtl3o3AIRFTr3sXKbaLZXbqYfDIW6toY2YRLv0esZxeTAPVf02PcewuUIj5fpzxkcvHIvhAplHx6cJTaTrTSSRWhh/O56rO5vCKjsWHhgv/0Iv7aLVdfI71X321iJm9eUZTuQHKzPqJ+3Q831EBPFxlBM7Cyea880ahJj9PJVSpsNNJ9+XSk/wdhPfsIs1B49BL8xIavDLwFkXM+ufAcj2/ijAaz11Qleum/pTbGYh/LFOv+Fv5MdqK0ph5ZM9ljDWaBvuUrfCsTLUoNtzBOEPR+5h0y+mf+P3/+8ScU/KdDnc7ww5s51ThyA1fx8LTGL93+p7UIzogAVTIQ01r5iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
>
> v4: Batched zswap_store() framework with compression batching
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This series is a spin-off of "v14: zswap compression batching with optimi=
zed
> iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> compression batching enablers. Resuming work on this series following a g=
ap
> since v14 (January 2026). Please note that my email address and affiliati=
on have
> changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.c=
om. I
> have retained the original Intel sign-offs on prior patches for historica=
l
> attribution while signing off v4 of this series with my current address.
>
> The main focus of v4 was to establish a performance measurement methodolo=
gy to
> quantify the benefits to high level metrics by using zswap compression
> batching. This was done using an Intel Sapphire Rapids bare-metal instanc=
e with
> 48 physical cores and by running "usemem30", i.e., 30 concurrent usemem
> processes, each of which allocates 10G, in a 150G memory.high contrained =
cgroup,
> for 10 iterations. The environment was set up to minimize performance jit=
ter so
> we can understand the system-level/workload-level advantages of zswap
> compression batching when running workloads at scale.
>
> To summarize the main contribution of this patch series: Batching is intr=
oduced
> in zswap_store() of large folios: we carve out a large folio into batches=
 of
> ZSWAP_MAX_BATCH_SIZE (4 pages) for software compressors, and store each
> batch. Moving the fundamental operations that need to be happen to store =
a page
> to now work at the granularity of a batch offers opportunities to optimiz=
e them
> from these perspectives:
>
> 1) Utilize existing kernel API that minimize obtaining locks for bulk
>    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
>
> 2) We keep the working set for each of the core store functionalities
>    (alloc/initialize zswap entries, compress pages, store pages in zsmall=
oc,
>    pool/objcg reference increments, objcg charging) to be focused on a
>    batch, thereby minimizing cache evictions and benefiting from cache
>    locality.
>
> 3) Along the lines of (1), the main zswap_compress() batching routine obt=
ains
>    the comp_ctx mutex lock once per batch, and releases it after it has
>    processed all pages in that batch.
>
> 4) Any zswap store functionality that works on a batch can potentially be
>    optimized via bulk-processing/parallelized as a next step, to further =
improve
>    performance.
>
> Performance testing: usemem30 with 100% over-commit:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
> 866f761fd414) and with this patch series.
>
> v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance wit=
h
> 48 cores.
>
>  Bare-metal instance specs:
>  --------------------------
>  - 48 physical cores
>  - 190G RAM
>  - 200G SWAP disk partition
>
>  Workload: 30 concurrent usemem processes, each allocates 10G:
>  -------------------------------------------------------------
>  The vm-scalability "usemem" test (unmodified version) was run in a
>  cgroup with memory.high fixed at 150G. There is no swap limit set for th=
e
>  cgroup.
>
>  To quantify the performance benefit of zswap compress batching at scale,
>  30 usemem processes were run ("usemem30"), each allocating and writing 1=
0G of
>  memory, and sleeping for 10 sec before exiting.
>
>   usemem -w -O -b 5 -s 10 -n 30 10g
>   echo 0 > /sys/module/zswap/parameters/shrinker_enabled
>
>  Performance validation methodology:
>  -----------------------------------
>  These settings were used to minimize variation:
>
>  - All cores were fixed to run at 2.4GHz with "performance" scaling gover=
nor.
>  - Turbo boost was disabled.
>  - CPU power-saving C-states restricted with:
>
>      GRUB_CMDLINE_LINUX_DEFAULT=3D"intel_idle.max_cstate=3D1 processor.ma=
x_cstate=3D1"
>
>  The usemem30 experiments were run with the baseline mm-unstable as of
>  11-17-2026 (commit 866f761fd414) and with this patch-series.
>
>  After booting into each kernel:
>
>   1) Constrain the cgroup's memory.high to 150G.
>
>   2) Run 2 warm-up iterations of usemem30. Don't use this data for benchm=
arking
>      since sys time typically skews higher for initial runs.
>
>   3) Next, run 10 benchmarking iterations of usemem30:
>      - Log these high-level metrics: Sys time and individual usemem throu=
ghput.
>
>   4) Sys time and Throughput metrics were gathered for three mTHP setting=
s:
>
>      - 2048kB
>      - 1024kB
>      - 64kB
>
>   5) Benchmark summary data includes Sys time and Throughput components f=
rom the
>      10 iterations of usemem30:
>
>      - Total Samples
>      - Mean Value
>      - Std Deviation
>      - CoV (Variance): Coefficient of variation (relative standard deviat=
ion)
>        measures spread relative to the mean rather than statistical varia=
nce.
>
>  An LLM was used to help generate the benchmarking and data processing sc=
ripts.
>
> usemem30 Benchmarking Summary:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>
>  ---------------------------------------------------
>     Improvement with v4 zswap compress batching
>  ---------------------------------------------------
>   mTHP enabled:       2048kB     1024kB       64kB
>  ---------------------------------------------------
>       Sys time:      -13.87%     -2.64%     -1.72%
>     Throughput:       +3.85%     +0.42%     +1.31%
>  ---------------------------------------------------

Have you tried perf-ing the store path to see what was the overhead
source (before and after this optimization)? I'm curious.

Mostly LGTM - still taking a look...

