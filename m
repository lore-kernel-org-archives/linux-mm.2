Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDA6DCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92956B0098; Thu, 15 Oct 2026 18:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69806B0099; Thu, 15 Oct 2026 18:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980706B009B; Thu, 15 Oct 2026 18:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4696B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:00:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9F5E40157
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:00:20 +0000 (UTC)
X-FDA: 85326229800.12.014C97D
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B1EE80006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:00:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TacseBgJ;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792101618;
	b=gEkzJcQLx42Ct5TVfwJlUpCOlkv0BKmGswnlSiMpJAYwOrD4A9vy39Bl/63pjDqLv4keT4
	0dBWYy4t6AIenVZR0mKrUay43gGLkRp5HFy8DsPhDb+p1CzW4djhWpNi7VXvRAmp37oFDl
	3YKWjBx+Z7IbA62VyU/sHCGQa4gEE38=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TacseBgJ;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792101618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXTcogsoKal9GQ4e/20qywfrmylbUPYtqmzlO2SqYCM=;
	b=Cda1h/UdFoh3R+1GSEKgzeZDc19C7b3eQ811jUoNwYaBDY8YxxW5wRdIeWN8pXPw42RN47
	kIm5k3vls9wbBViqofvtiUuOPbuF5/XuHgSN8j+D65rjSqggI8Xfkyo3CN+ZSjou7JyHYt
	0owohTJdglaOwQLCrA4CxUodqLKbt7U=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b8f5e2ce5eso5268978e87.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:00:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792101617; cv=none;
        d=google.com; s=arc-20260327;
        b=mjaBokO4BosEuHDmkmA3iJyN5kGh2t4WwXC7dWzvmilckl8imzZNj4plA5bGE25Mx6
         5b5o7ogS9rm03bXvGVM5AsWT8piUXtO8oiMGDmLQnTnpQz4TzRYCbf8QlLEJU/tkfJRO
         eyNWjDbhfciAmkL0vXf+pQb95D57QKhHSjxBXhoZP4pRAg3WKWfucyJh4motvXqPnvdj
         fUw2Ap6Q/EdxyB+Q3PhJ1LRdC2zruDfWYYFqiiFpeKYlRuXFXjCHgdu4M1kcSqwKVjIS
         3TMvvmfHSYR2NdHFry3m6S01cSBnIk24lj+okypy4BUm5mqohyibhbu5wGDWPUykYgn1
         YwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZXTcogsoKal9GQ4e/20qywfrmylbUPYtqmzlO2SqYCM=;
        fh=pPpctj4TcVw1rheBOQI1uAh7OaIwaIU6pWlXw50nlHw=;
        b=NvZiaFwNZ8KPXtbmeO9IVUVW+U8dakbJlTzaDQvZGipRlaQmOeAXQl3H69XwP0sheP
         DV8RfshGrwq35zg04FFMeWUiTCh3XqzaVLMKubcRISayqKHW28mtVbC/IGCJOZyuqWCM
         jt3UoAsuQIilSEpe/CJLQBqfxKcha8Z1HRcLqVReBtbsvoc5JPKLeXfrBSy/keifIV77
         5f8U6Biq/6w3kwWqV/mXPOa2TCt86WAQknUGL1tPWDq78R2Wi4VwKvBnNYVw5vO+BYLu
         +cbZAfGRFU4/KZ9Fs5duw1TuZ4eVd1VgE0fVx8MC/i8WTibCFj/I53RtcpQGlDNqpVJ5
         7WEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792101617; x=1792706417; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZXTcogsoKal9GQ4e/20qywfrmylbUPYtqmzlO2SqYCM=;
        b=TacseBgJ1ahHQnSFAXbbUYzU8e3DVyy2ktosSS3oPjGCOPumtM/54pQDr7BAgDef4z
         yatLcYOoMw3Iq6q/fwJpIlV7BbCGCtUt+mulRZny6Acg1MLAPl/Y7bamWKF5pC/DgAIg
         iaPy7hwwqZ/iT5ZLn+LuefuqMhwwrpEcPBggFz97URv28yPxiwoI1pDf/qkC/tmwPEwV
         1sgBkm8o0uTNRRmoCej4SU0TZjv4kvhO3vWwKyvf3awxCcdkDap8nhdy7tsqVzuPU91L
         ZB3i6d2Q3/WX+/atsLwvdXX4fYDoYp+DF65Pp9dy4rPrgfzKYwz4uuJgP2D5cph80Gac
         0ZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792101617; x=1792706417;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXTcogsoKal9GQ4e/20qywfrmylbUPYtqmzlO2SqYCM=;
        b=EsFDcbkMKGny0u/giiCeao0dTQKJE8prxQ9565cLhv18XZ5YuuqST+vpoGXeeNIX33
         8o272d79PlYxim0lQp+cc24RZuw9TJ+/mEOTi2s48x5f52spuBzh4OlC6JbEQ0Ju3iNx
         4EDBD0Fr5n01OZm4IvTc2YgDyJv8o2qvNg2/KaEEXTiFeuimd/JUCnkb+9wjTWCiF4zk
         dB9xH2kLLzQlsD1O2JcyY+ahT2n3yWYgKos/v2hGErEqYLBh8zKWwtOfZLtAgyjfcwuF
         BbM8rcme2//j6hJKahoiaRAL17/Q/IqY/WXQ1ZJBR2gl/iq6AkmOWQo47TIjym5EdcHY
         kGcA==
X-Forwarded-Encrypted: i=1; AKwUvBxzK4pP4ryqwJAqURiXwxiv9IU4n6Jpol2R0hajE8VCoOdD23c9BbN1uTTkrsLwljWKgoorSBo4fQ==@kvack.org
X-Gm-Message-State: AFq9FYLUtpwP83ygsFumMry7UwgR94Y+q9UWFu1n8//o+TfwtXmYc23I
	/bXBOWSVcpWguJKsdquHzMSphKdxbLZmbGig3Ft6E5+QXoR4Zb8Z2fC4j9tpmsN92jGVHL5az5C
	T7cdW+9yV5HRiYDU/+bapTIj0O6hWTzs=
X-Gm-Gg: AYBFou2enVuYjmn2WDK8AHgsFye9wEhvOnhsMgdIX4L44vyxxyZNnZ64rCEMA1DCwGm
	tY/dycHiIu4DXEdfeL9mxkz6ziJ5sHC2a8IUT37XRf0pVOqQaC4VXa+QH/7TT+eG0NySQJjAS2Z
	C79EpKFU5l5SKUK1GiIjiA7VfQbQoOg/PODfWkoaVNYTKyUTlf2MQyDk1XRsXxzVcPNF63CnJlL
	n6VJLD4f4aKq7oTwUf7f2xqlChMcSiS4XLvw6BtX50tmIcMqWgEKeo38zd4UdyGsZm9Ix99KomG
	6mIACyIjCrHZK2fy8ztx97JNAr8ZxmU8Eu8vZrWMd2XQxVyq5RjoVwo=
X-Received: by 2002:a05:6512:31d4:b0:5bc:dd57:d0d8 with SMTP id
 2adb3069b0e04-5bcde8d9836mr7918589e87.58.1792101616768; Thu, 15 Oct 2026
 15:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com> <as-jZopKRfuYAiTE@google.com>
In-Reply-To: <as-jZopKRfuYAiTE@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:00:03 -0700
X-Gm-Features: AclHuK98HimEr86Vs09-7RY4Cc9mv6ZAaNh6uyS_4CH-ibjoMM62Yx1375aQNm8
Message-ID: <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B1EE80006
X-Stat-Signature: ofdc7pkz6n6idq8o84rtgqcj56e9b1n7
X-HE-Tag: 1792101618-416134
X-HE-Meta: U2FsdGVkX19VxUrp79wvjxK+n7qnTHi9e+B8aqCNEKHNXiCOZVdfXrRv+oCHzBzOaV66Hy/J9rkAVULIGn//9pgaPgW0sxxlBXphoakqyi91MlwKNXiIOfXoE3ALRWYpdYckqAmsLUPFD0RMYUbKd6LqElKrk4Dqhgeqx5V+CWzPVc+H+J0SgZ9y9BhI9cOzU8eBWLCNd/tHreTIQb0KVtKMjrrzYtneMdIxNiHXPjMuH24nW/PG8DGGrzB68DlxodhclldoeAdv4OrFYLcagGSb+KzupGVHmSHmy6HwkCy6+IhSolxOS75vUMdvaG/C0HqpYlcEeuFUQGBvgCk5P2wmse8qavp0VxnT8Fsrwf/oq25Ow1HrK94F8JStLBrx43o71AIDnCFgskhHc8mJbOi8VlopBU8U7Pn7kmcJWvFnYhTEU7JpHyroMGikzrZfHnJNQS/dWGr6s+ZXv0IlMLKJWK3HlxrMUznCQC/9csPmjYH0ySdm9G60MlTkRxpBjbK5dxcX5j0FBWxVBO85qWU2h2sEoAGBERX+Brc6ujWh4WC0N72XJ8aoQsKAAWnny+9MU33ppOJdRROnVUspjvUtzevPd47b63cJTm8a2nctUvB2a8YdjLhRM/BFc2q99Yiq/iMogyn48+JhSFTyOtJFREzRTG7eiLF++K57UdT1c4yk74IHceM4NG6+PHpC3hoDbzcmetucgr/z+KZFiguDHfAtBSbluMMUYe7Tu0t5CcSi9l7U8U5tsFn23KdMi5ZbH6vmkI8eVvvq7zKSZKwdyVWYEgoYr2eKgowXSN0YLOK066Hkfnogz7s3I9VMybHYttDGWoqLN46z++pu7+TxF6fZgCmKOy2nuN5A4p11ouyONOXVfjuS/ZIv77NpnMC6CSm9D37WFg7jxACd7i780LAL0h3RiIMRETPenw7rQqstLM/+aRE2Zok7koVyZpB4H3+4ekR61dWQ8xN
 TOWt4ew/
 yKUFDyb2rj05YhL+sQLKOatENpV2ep81F7i9HbDZWofnhRiepprDx4oGlG8NIT6lQLlmf/d14RiaE48nyFOYVJFrGgGOkE2BIGi4gEbn2q08NVHCGb5MHKosniCfIyQpWtssuWmzQDQx63rZAWHBamp0z8NBg0a/K/s+mBHJkGVd5cWF6yH9kV48z1rVomvUZ5C7uO7dUTwPmHk/GbMGOSLKotAZh1lITllz0Hdh1C8aHhMuk/UHjny6n36ewCxtxzkm29AEVWuFgsVNFshnGiJ7zuGKImkQu0MYRXJf8Tr16hJMph+GXlOMMgKPd4bxUJYJPMdQvgtWTp4p3/fb4xCUaGksXy7T48hquKo9XQuXG7h7nJ1Z25JPrSGoH2sc3JhUlKa2ZXRkh8FvbTZKLmj1CCKyzod7z17BzK1uuVbBjTGgX6hM6AEwJDQA+hIgym333pxYd5kA8B7ylxsm+qXfEdFliCmgfvHCXWr/XQpXTAJq1I/beNlOEehuVqI/9N8VIAhtBtGTgu8mUyCzybDsGJShGtGilxkbUJapOMBPD6+pYJrHpaxUVTXxMeqwjvU6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote:
> > v1: Batched zswap_store() with compression batching
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >
> > This series is a spin-off of "v14: zswap compression batching with opti=
mized
> > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zsw=
ap
> > compression batching enablers. Resuming work on this series following a=
 gap
> > since v14 (January 2026). Please note that my email address and affilia=
tion have
> > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail=
.com. I
> > have retained the original Intel sign-offs on prior patches for histori=
cal
> > attribution while signing off v1 of this series with my current address=
.
> >
> > To summarize the main contribution of this patch series: Batching is in=
troduced
> > in zswap_store() of large folios: we carve out a large folio into batch=
es of
> > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> > batch. Moving the fundamental operations that need to be happen to stor=
e a page
> > to now work at the granularity of a batch offers opportunities to optim=
ize them
> > from these perspectives:
> >
> > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> >
> > 2) We keep the working set for each of the core store functionalities (=
alloc
> >    entries, compress pages, store pages in zsmalloc) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine o=
btains
> >    the acomp_ctx mutex lock once per batch, and releases it after it ha=
s
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially =
be
> >    parallelized as a next step, to further improve performance.
> >
> > Performance data: usemem with 60% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> How much of the performance benefits come from patch 6 vs patch 8?

This is how the performance changes: Average throughput is averaged
from 10 iterations of usemem.

patch 6: 19,119 KB/s
patch 8: 17,593 KB/s

So the acomp_do_req_chain() path that ZSTD goes through with patch 8
causes a regression, even though it provides a generic batching
framework in acomp.

I was able to retrieve performance with the following change in acompress.c=
:

patch 3 with this change in acompress.c: 19,578 KB/s

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 192ea996e779..dc609bd7d927 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
                return -EAGAIN;

        if (likely(req->unit_size && acomp_request_issg(req))) {
-               if (!crypto_acomp_req_seg(tfm))
-                       return acomp_do_req_chain(req, true);
+               if (!crypto_acomp_req_seg(tfm)) {
+                       int err =3D tfm->compress(req);
+
+                       req->dst->length =3D unlikely(err) ? err : req->dle=
n;
+                       return err;
+               }

                return tfm->compress(req);
        }

Herbert, would you be Ok with this change in patch 3?

Thanks,
Kanchana

>
> > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and wit=
h this
> > patch series.
> >
> > Testing was done on a Chromebook with a QEMU "vng" VM running in Crosti=
ni.
> >
> > Chromebook Diagnostics reports:
> >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> >   RAM: 16GB
> >
> > vng setup:
> >          Memory: 7G
> >            Swap: 3G
> >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> >
> > zswap compressor:
> >   ZSTD
> >
> > mTHP enabled:
> >   64kB
> >
> > vm-scalability/usemem setup:
> >
> >   cgroup memory.high: 3G
> >   4 usemem processes, each allocates 1200M anonymous memory, reads the
> >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
> >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> >   frees the memory and exits.
> >
> >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> >
> >  usemem metrics averaged across 10 iterations*:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ----------------------------------------------------------------------=
----
> >                                           Baseline       Patch     Chan=
ge
> >                                        mm-unstable      series       wi=
th
> >                                          10-3-2026          v1         =
v1
> >  ----------------------------------------------------------------------=
----
> >  Average Throughput (KB/s)                  11,794      17,810    +51.0=
0%
> >  Total Throughput (KB/s)                    47,179      71,242    +51.0=
0%
> >  Average Time to Free Memory (usecs)       490,973     294,920    -39.9=
3%
> >  Total Time to Free Memory (usecs)       1,963,892   1,179,682    -39.9=
3%
> >  ----------------------------------------------------------------------=
----
> >  * vmstats are as reported at the end of the 10th iteration:
> >
> >  64kB-alloc                                834,567     828,199     -0.7=
6%
> >  64kB-zswpout                              700,138     743,697      6.2=
2%
> >  64kB-swpout-fallback                       35,342      17,978    -49.1=
3%
> >  64kB-swpout                                     0           0
> >  ----------------------------------------------------------------------=
----
> >
> >  The speedup with zswap store batching of large folios has a propelling=
 effect
> >  on other parts of mm, especially, by enabling large folios to be swapp=
ed out
> >  without splitting, as the data shows. This enables other mm components=
 that are
> >  optimized for large folios, such as munmap(), folio refcounts/mapcount=
s
> >  updates, PTE invalidation upon freeing memory, zswap_invalidate(); whi=
ch
> >  benefit from xarray offsets/range continuity. As a result, subsequent =
large
> >  folio swapouts are more likely to find contiguous swap slots, there ar=
e fewer
> >  large folio splits during reclaim, more mTHP zswpouts and the cycle
> >  continues. As the data demonstrates, this directly contributes to more=
 memory
> >  over-commit opportunity.
> >
> > Detailed usemem metrics/cgroup memory utilization/vmstats:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  A) MAX zswap pool_total_size vmstats:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  This is a snapshot at the 10th iteration's peak zswap pool usage:
> >
> >  ----------------------------------------------------------------------=
----
> >                                     Baseline             Patch     Chan=
ge
> >                                  mm-unstable            series       wi=
th
> >                                    10-3-2026                v1         =
v1
> >  ----------------------------------------------------------------------=
----
> >  pswpin                                    0                 0
> >  pswpout                                   0                 0
> >  thp_swpout                                0                 0
> >  thp_swpout_fallback                       0                 0
> >  swpin_zero                              594               548
> >  swpout_zero                           1,062               864
> >  zswpin                           10,603,882        11,070,673
> >  zswpout                          16,594,356        16,509,201     -0.5=
1%
> >  zswpwb                                    0                 0
> >  nrswpin                                   0                 0
> >  nrswpout                                  0                 0
> >  pgmajfault                        1,460,360         1,470,092      0.6=
7%
> >  nr_free_pages                       897,249           908,935      1.3=
0%
> >  nr_free_pages_blocks                892,928           903,680      1.2=
0%
> >  64kB-alloc                          831,788           825,556     -0.7=
5%
> >  64kB-zswpout                        690,961           735,863      6.5=
0%
> >  64kB-swpout                               0                 0
> >  64kB-swpout-fallback                 32,982            16,545    -49.8=
4%
> >  64kB-swpin                                0                 0
> >  zswap_pool_total_size         1,420,120,064     1,377,210,368     -3.0=
2%
> >  memory.current                3,390,189,568     3,299,569,664     -2.6=
7%
> >  memory.swap.current           3,221,221,376     3,221,221,376
> >  ----------------------------------------------------------------------=
----
> >
> >   B) STEADY STATE vmstats after usemem finishes:
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >   This is a snapshot after the 10th iteration finishes:
> >
> >  ----------------------------------------------------------------------=
----
> >                                     Baseline             Patch     Chan=
ge
> >                                  mm-unstable            series       wi=
th
> >                                    10-3-2026                v1         =
v1
> >  ----------------------------------------------------------------------=
----
> >  pswpin                                    0                 0
> >  pswpout                                   0                 0
> >  thp_swpout                                0                 0
> >  thp_swpout_fallback                       0                 0
> >  swpin_zero                              594               548
> >  swpout_zero                           1,062               949
> >  zswpin                           11,526,695        11,963,729
> >  zswpout                          17,293,120        17,219,911     -0.4=
2%
> >  zswpwb                                    0                 0
> >  nrswpin                                   0                 0
> >  nrswpout                                  0                 0
> >  pgmajfault                        1,591,298         1,596,095      0.3=
0%
> >  nr_free_pages                     1,752,789         1,753,264      0.0=
3%
> >  nr_free_pages_blocks              1,258,496         1,240,064     -1.4=
6%
> >  64kB-alloc                          834,567           828,199     -0.7=
6%
> >  64kB-zswpout                        700,138           743,697      6.2=
2%
> >  64kB-swpout                               0                 0
> >  64kB-swpout-fallback                 35,342            17,978    -49.1=
3%
> >  64kB-swpin                                0                 0
> >  zswap_pool_total_size                     0                 0
> >  memory.current                      757,760           802,816      5.9=
5%
> >  memory.swap.current                       0                 0
> >  ----------------------------------------------------------------------=
----
> >  zswap debugfs counters:
> >
> >   pool_limit_hit                           0                 0
> >   written_back_pages                       0                 0
> >   reject_alloc_fail                        0                 0
> >   reject_kmemcache_fail                    0                 0
> >   reject_reclaim_fail                      0                 0
> >   reject_compress_fail                     0                 0
> >   reject_compress_poor                     0                 0
> >   decompress_fail                          0                 0
> >   stored_incompressible_pages              0                 0
> >   stored_pages                             0                 0
> >  ----------------------------------------------------------------------=
----
> >
> >
> > [1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537=
.334628-1-kanchana.p.sridhar@intel.com/
> > [2]: https://wanos.co/assets/silesia.tar
> >
> >
> > Changes since [1]:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 1) Better cacheline placement of struct zswap_pool and struct zswap_ent=
ry
> >    members for temporal memory access efficiency in zswap store/load ho=
t paths,
> >    while minimizing holes.
> >
> > 2) Refactored the core compression batching functionality to a separate
> >    __zswap_compress() function, which is called by zswap_compress(), as=
 per
> >    Nhat's and Yosry's comments. Hopefully this helps explain the outer =
"store
> >    batching" zswap_compress() vis-a-vis the inner "compress batching"
> >    __zswap_compress() distinction.
> >
> > 3) The acomp_ctx is locked once and is passed to the routine that compr=
esses a
> >    batch, per the algorithm's batch-size. Similarly, the folio's node i=
d and
> >    writeback_enabled status are computed once and passed to the routine=
s that
> >    implement the different store functionalities, to save latency by av=
oid
> >    localized recomputes of information that doesn't change.
> >
> > 4) Moved the folio node id being stored in zswap_entry to a separate pa=
tch, per
> >    Yosry's comment.
> >
> > 5) Addressed the kunmap_local() issue flagged by Jixin He in the
> >    IS_ERR_VALUE(handle) error path
> >    (https://patchwork.kernel.org/comment/27095925) - thanks!
> >
> > 6) Moved comments inline, per Yosry's suggestions.
> >
> > Thanks,
> > Kanchana
> >
> >
> > Kanchana P. Sridhar (8):
> >   crypto: acomp - Define a unit_size in struct acomp_req to enable
> >     batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
> >   crypto: acomp - Add bit to indicate segmentation support.
> >   crypto: acomp - Add trivial segmentation wrapper.
> >   crypto: acomp - Add API to get a compression algorithm's batch-size.
> >   mm: zswap: Store the folio's node id in the zswap_entry.
> >   mm: zswap: Store large folios in batches.
> >   mm: zswap: Optimally place members of struct zswap_pool, struct
> >     zswap_entry.
> >   mm: zswap: Batched zswap_compress() for storing large folios in
> >     batches.
> >
> >  crypto/acompress.c                  |  47 ++-
> >  include/crypto/acompress.h          |  62 +++
> >  include/crypto/algapi.h             |   5 +
> >  include/crypto/internal/acompress.h |   8 +
> >  include/linux/crypto.h              |   3 +
> >  mm/zswap.c                          | 571 ++++++++++++++++++++--------
> >  6 files changed, 528 insertions(+), 168 deletions(-)
> >
> > --
> > 2.39.5
> >

