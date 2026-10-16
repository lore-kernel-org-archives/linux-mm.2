Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F735CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8B56B008C; Thu, 15 Oct 2026 23:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFD56B0092; Thu, 15 Oct 2026 23:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFA56B0098; Thu, 15 Oct 2026 23:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A59D6B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:32:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAE66140274
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:32:37 +0000 (UTC)
X-FDA: 85327067154.09.9786BED
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id D2AB31A0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:32:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X2kCDKEq;
	spf=pass (imf19.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792121555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mthJ2xXwzbGlymovK0MC30zhpam2OvKpb9vmh5KmEw0=;
	b=kqoSYe9yi8BALQFY57+/vEA57QlHtpqB/YvvUQtANsz5qUtEEdJrGckwJ0dtfm4cpUjZSr
	H/umL2E5pMUQfZ0qrzFMM0R5cA3ayW1CR0HOTUQiQm7pjKk6+SSopFx4JP9bJAPx447YyH
	vi5IeEmto/HxM2620r2KIrsaxz4z0iw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792121555;
	b=yNst/7mhrJXCL7avLBpJo7sWHSBqMlfYbiBT3WthcCsoFMWB0oKc8506r+bWhWmJ7hMJXC
	zdm5UgDZ1wFWR9Z7TGoegURF9dCyfVkJOjZd2Ifv+0djlQlnpox+34qpXRmsObS3BucgPm
	S6c3YIvv4MTmozSlI75cDxD03/3HiWM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X2kCDKEq;
	spf=pass (imf19.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5be4b61fd3dso203712e87.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:32:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792121554; cv=none;
        d=google.com; s=arc-20260327;
        b=keRkIp14VDHsXmauCsUR9OXRmESdRbKUA/faROWPz/3M0rVSp7Olgnb0v8GMSkrHPZ
         QUG4OVwaOH0d57uQOK+yVKNuC8/QuScCmfGfub59sVtPD6p7fZzZ/hn4dX64ZZp2WzzJ
         157fZZWbodgE7CRkVrK3tNuZBCRI/R8ofmp1xpxUL2kRXGwZlWAoYcxeuVRfFw37mM81
         sCSjxuGRWtDKe3j8viizbpRru1TPoGbSUGVN3fSGhwB7nSj/XZrk6TtcwNyhC0hKxNIP
         s/LYwqf7vMCaKGGe6D8Q/DSlX8PvwbHK/dSYULuOc6cJ+iOf0UYT8x+pwVC3TU4mN5m9
         JO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mthJ2xXwzbGlymovK0MC30zhpam2OvKpb9vmh5KmEw0=;
        fh=J1RhijXGZfM07pt4RoGZM3FQTMoVY3ZkrDYTwTuQugs=;
        b=H1WpgiZ5HXBlAwxd+6K1uC0HeiwaoeMpWHbOROMkgZrlIgbHbzBopl5vh8SukqBiqy
         vrWh8BfiU+oNDECE5P8ZSaHcP/5BhatwZy7HlpmOfnzIvvJyE541wpQVVrMypGc9HeTr
         GwtuS7Kz+Z+Fp/xZdphgIweF5TBJjGUciJmtzNzH0zarQDurllKhW/HND9w+9PxKu8TI
         cM/EVxaMgst7gvdzFLdMQPF7qzT0qVZl4+ashNj8yrX4y/DuYQ8XcB3NArISH6yUtE8J
         G/nLsemlnNPORbj4dyKDExkJ8BqXilT/hHaKwFbwDRoteg4l94RSdAYrljCcC59n1L1A
         xAow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792121554; x=1792726354; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mthJ2xXwzbGlymovK0MC30zhpam2OvKpb9vmh5KmEw0=;
        b=X2kCDKEqIXOYgcONBw/psoGQkZHb1wLL6WaM9kPVXZc8mS+qiuLsTblNtiF6xjBYhW
         GFH3i9GQEzQ1QWUAJaRcfrgV1AgzpSM0HH/TCVyDv8e7zlZzcLewq6LvoTEVTxNbJ/42
         cDyuaHIeYOc/a5iL7VoykFRrBV5OiHDcBL+yQ6RrE7iYtWg3s7waQ8BYxzJ+ucZA0Zjf
         HzuVkrRFp4x8LqTncBteGnJXRmvoxTXiDXEbay/7rC3yz1vLrbJbbMx9XHameBjBGCA3
         Br6KSm3pLTYO/nI4AMWOs4YjbxiyG0g/5U44Vbq4YIaIy277pmIvZdGgGDLwhppF6mxP
         vF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792121554; x=1792726354;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mthJ2xXwzbGlymovK0MC30zhpam2OvKpb9vmh5KmEw0=;
        b=wIq9vVmntWqzTurtxp6XnV+dWxSAM0IwcjrJGHcyH6gP0JogY0ZkobclrHWGDqxYci
         vosqTwt0+CLwnumPJl9Yi8t6Q2EQLjd+6dUnXDTuAgK9Xdl8vcFDfFCrikaXXN5/rc+K
         SfvaiuBjy6T0H5dTo2CYgIrJJmpAFvPIvAwR/Oy3d6bdCE6ekSP2KFOjuWmPUsBycN22
         wmcwgW9YqOLWZdw8zUoQRDUAPdgPAMAWX+K+OwiN/MxmSXcpfTWhTbrHKYBhH1KmQl6f
         pGfJK9gY7+cNDVayh+iXzhP0GTkiiSFjFLETxPHvguluULIagwnX6la3/bFbmIjgdsGy
         XZPw==
X-Forwarded-Encrypted: i=1; AKwUvBxgNwht6cFS6Yd54SAKcdjzhT9FJNS716KJDtxU9lQNQmoV5r/NBACotqXj4+r5nbP4CjHtpdDKWA==@kvack.org
X-Gm-Message-State: AFq9FYLXEVWuNGCCxSVRUsBGaN1nfVSmavqSEOpgM4R2zFDYmxtOCbw4
	CmVC/hdUAbbkFokkPpky3cOf5Pnso+wVjw6Wk4FqO2mzs4MkVzibrLKoZoJrJb2kNCyD63nPzfz
	gowAnOMjYuMDdkVeRTCfEdDW4Sw1C8o0=
X-Gm-Gg: AYBFou0ExlsFCRlhqVrB/wu8flOgBIvjNIXltWzC05Bl8eC/aBPunNXf944JvT66g27
	0S61ZZE9xKujui+dh9Hbe24AsjTxUesMRDFSvNYTxeCiTC5/9h0c1H4rM1YHePMDFs+8bEzXgII
	Tau6KH5vjQS10oPjan5Cq85SZazRQaPMdOHlFTqi8atNUQ0Qrwj86kQEPDHIjTYAi9XN7D6uow+
	QRUOF+n4OU3PKAIeHRni8iGkhmbog2JgteID37lReguRMfU8641GuV0FkJnwy7a8+e4uellm+og
	YvbjEHcSVQV4uUUpJosoiRb3W4FfWG2p7xMaapoCod1Sps2tiGsOAuQ=
X-Received: by 2002:a05:6512:6687:10b0:5bc:e472:11f9 with SMTP id
 2adb3069b0e04-5bce472122dmr4219021e87.20.1792121553829; Thu, 15 Oct 2026
 20:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com> <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
In-Reply-To: <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 20:32:21 -0700
X-Gm-Features: AclHuK8EwiGuB9ddUtL4cQ1Is2_v69m3igeGciRO29KLyhbEMLCUdPXew-h6hcg
Message-ID: <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2AB31A0003
X-Stat-Signature: rkqnxjxppo5uhydohc6okxti431y1rke
X-HE-Tag: 1792121555-356266
X-HE-Meta: U2FsdGVkX1+LqfSKdvo0VkmQcWRWkbtvI8a3ClgxnWTPUaDZB2ZQPCGv/q/0P0r8f1MMZycWC0j6SXa/RcB87G3AG6Ws1DL9bomjUZVTHRjBXonFnOe4fSMX/eLciTMJd53AiuY0+se+Xbzfj7RJOlU+QCEf4WG8aBOxYQ6hk048irkIkii/Rwe/nFK4nWe/sNUOumqLeVu5m8EvAiUhkymlw8TNw+Nkdyf//bkAWhY6UoL1/t9Z0lUSpZ8HDuTthpXRxD9vetFkYbwrSDilawRIGpR0s//CcCICf9oG90uNI9aSgdZwoSAi6Bzb7UZPinNIp+eXXLuhfetisxVuTL50z4SVtMaNJWuMvs7LTxSMhGbRt7vn2ZMyTjEz02Dn5hmxAH39hmcgnVkpeEvWQBLEdgyvIw2UFgkiOfUdU3ywVWARjnjJTUKK+9e4pITip1QuGgn3xRr86x3HlsasoGFk5iuTZZMm35tSjzSSi7I2IO7gLtM6JGu7VuOLshaqD43Z3LSJaYQxD05up+FbijTeea53yySshC5d8OZnjWyeoh9QC9ay+QxEUTY/RE7ffZpO4yAub6SOjKd3kwFWwjSeHzZemAZV5wZMkF13ZTAuNkdMQi8ztrw9lLYCrBFZq0hXn6PlaGJAzCdettQKE/emrWaIzBDIM6H2eY+2MbAqddqsjQH6qlTDAZpEDOjNkQ4dsltlBrh9N9hFO9U512h/E3Z+0jPun+lW6vR1RB/itFuf9AH2DN/6il2FJnrOXgyFU2vt/AgCHj8KJhUNElAa2N5/+LrFGHhQxaIGhaFR5JBhWqgu+gs8mm4oFwN4GYVMpcd+6VB0wdk9v/5Al3XXNkcCa1E1BrrXPLb8mJsnfi6M7/mDkIhxf6gyHgZgJxcinbJlxLHl2nPUtqwEv0eI66bIYru/5/eW72By7buZM19w1Mm/ezC3U6qN9OjhqGMbS3dx7IWuTRAZJYE
 pJ45rglT
 +jGe4GznRFIdvKBZvvRrbxTKWRQTAaqjS0hntPJjRcNIW7rljbbOITzU3zKJIyt+z6q+g34HFIidu6O1lepQo75S1SsW60KA4/dm6uqghuw0OMBhBPnyWNUtDT6B7RXjtkhPu2JUDe0C3WOeHNiUgyYGvGpnrR+elq4qKUV1hmpxvYF6HeTzpTkO5TXtBL5GhY1Lv0jyPBRzUhvXHD1jr0zw7FtaTFaTDcMIqqtub1eF9ufw4t20qJVq4Zxe/ONRrd8v0m1EO4/BN+ucpc9fJZJAQLRkaqQg0Unsvv8qtC4AXb1zhIjOe68kzHMV93cPDW8/qTVIk8QoOpGMh+BXcGXFiau8++g/eb2vqq3sLAe4IYzNRdY77c3L80n/hfi2TWP36nWDekM1vH2CRf7DzHCsltAhKD/tmVLkV0AiBu1vbOZ5t8kBFlzVNBk1dcywpyVMWGSUx0Wg/yV8Lq9oGAqexpucknXyeox1Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 4:45=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > > > > How much of the performance benefits come from patch 6 vs pat=
ch 8?
> > > > > >
> > > > > > This is how the performance changes: Average throughput is aver=
aged
> > > > > > from 10 iterations of usemem.
> > > > > >
> > > > > > patch 6: 19,119 KB/s
> > > > > > patch 8: 17,593 KB/s
> > > > > >
> > > > > > So the acomp_do_req_chain() path that ZSTD goes through with pa=
tch 8
> > > > > > causes a regression, even though it provides a generic batching
> > > > > > framework in acomp.
> > > > > >
> > > > > > I was able to retrieve performance with the following change in=
 acompress.c:
> > > > >
> > > > > Why add it to begin with in this case?
> > > >
> > > > Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> > > > co-developed with Herbert. The request chaining for non-segmentatio=
n
> > > > algorithms was as in Herbert's original implementation. Since this
> > > > causes a regression, I would like to get Herbert's Ok on replacing =
the
> > > > request chaining in this part of crypto_acomp_compress().
> > >
> > > I mean, why add patch 8 if it doesn't improve performance? Seems like
> > > even with your diff, we only recover performance, but we don't improv=
e
> > > it after patch 6?
> >
> > Patch 8 does improve performance over patch 6 (19,578 KB/s vs. 19,119
> > KB/s) by 2.4%. Besides, patch 8 provides a compress batching framework
> > in zswap, which is the purpose of this patch series.
>
> No, the purpose of this patch series is to improve performance, be it
> through the compression batching framework or otherwise. The
> compression batching framework made sense as it provided greater
> performance gains with HW batching/concurrency. Without that, I am
> honestly skeptical. 2.4% can be within the noise.

I seem to have left out patch 8 after making the crypto_acomp change
to not use request chaining.
My apologies! This was an honest mistake..

I have regathered the 10 iterations average throughput of usemem after
applying patch 8:

                                        patch 6: 19,119 KB/s
crypto_acomp change + patch 8: 20,946 KB/s (+9.56%)

The purpose of this patch series is still the same: to set the
framework for batching of zswap compressions, and not just of zswap
stores of large folios which is what stopping at patch 6 would do.

With SW compressors (ZSTD), patch 8, i.e., batching of compressions
and storing the compressed data in a pool, demonstrates significant
performance improvement (sorry again for having missed applying the
patch earlier today). This is because we isolate the working set to
just these ops, which benefits from cache locality and minimizes
evictions: as against the vectorized implementation without the patch.

One of the immediate benefits of this framework is that I am using it
for bulk allocations of compressed data for a batch, for entries that
map to the same slab bin. This proves the forward-looking benefits of
isolating compression and storage from other zswap_store_pages() ops.

The crypto_acomp change I had mentioned earlier does not hinder HW
compressors in any way. As mentioned in the commit logs, patches 1-4
provide the API that can be used by HW compressors as they see fit, as
long as they register the segmentation bit in the algorithm creation.

If you are Ok with all this, we will need Herbert's Ok for this change
in patch 3:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 192ea996e779..db8e4c82b900 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
                return -EAGAIN;

        if (likely(req->unit_size && acomp_request_issg(req))) {
-               if (!crypto_acomp_req_seg(tfm))
-                       return acomp_do_req_chain(req, true);
+               if (likely(!crypto_acomp_req_seg(tfm))) {
+                       int err =3D tfm->compress(req);
+
+                       req->dst->length =3D unlikely(err) ? err : req->dle=
n;
+                       return err;
+               }

                return tfm->compress(req);
        }

>
> > zswap is the
> > first user of the crypto_acomp compress batching API provided earlier
> > in this series, which I think, is a great starting point for us to
> > evolve this further, as mentioned in the cover letter.
>
> Without a non-trivial performance benefit (e.g. with HW batching), I
> don't see enough justification. My advice is to try to push 6 (and its
> dependencies) separately.

This doesn't penalize HW compressors, while representing the status of
what exists today (sequential).

