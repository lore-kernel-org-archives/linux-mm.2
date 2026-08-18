Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B57C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68626B018D; Tue, 18 Aug 2026 12:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C403E6B0190; Tue, 18 Aug 2026 12:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B436B029A; Tue, 18 Aug 2026 12:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85F006B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:18:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B3E8A280C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:18:27 +0000 (UTC)
X-FDA: 85114897854.24.5E5D8B4
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 644CC160012
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:18:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="omdK+/3T";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787069905;
	b=ItFAkRz1hoCljay4kSz8Zqv/ndd5MTga+T8MB1s+gYYk23YpUMnzW9KNhHDPGkD/ZySRAb
	4zWSI14MtiHkban57IBYf2muMnKeDuFx8ayPKfnkO2e5mg1SZ7b3Fytf888eq4jCpw4/Am
	oRWlkqaFhPVWJ4FA8fZX+d1xVcy4+9E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="omdK+/3T";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TLu1W7yHkhtHwjGoDo5vcDemF4Vg7sJTBG/DucIvwc=;
	b=W1N05lmuAeDS5yr9wgqB/t2KflEMvfHVN2npiwJLcPG3F27J1XRJ4YKkcx2fTDgytJdMY2
	DC9Hg1BMKv4YTQEj0V+3I9OSMR/pfCxvVCVUxS7TUWQn3zLZPtl/BbxQMCv3QkFL6kE2d5
	Hzqlts5erjljZ5YzqVzvGAWzVYycz9M=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4996f1ee4a4so68325e9.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:18:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787069904; cv=none;
        d=google.com; s=arc-20260327;
        b=F/Va5G3K+SSGJIlExUuu/nWEZsiHerp/qU+inx6d9UnQMgk781nXo2QRVyPM0/pyim
         jvJTrRS8Nr/0q5FVUfbUpaLaIjHzPO8yICKYZWkMDFw5BGH6YfmAhf0WkWxtadfuaNYc
         o4b/KON97myzrlAp8vUU2qE4OxlnzHgQ1TujovaeN9R2FoDeBmYqFoc7aLOOa3+cqsy6
         wNILAjVhfUHf3ziHzxhlyhiCunP47RckbvcvlSD6P1RZHFz0aKp61pO1RLsnkCcof/I8
         ViheCUD424p9U3hKF2H3AT+L+QTRwbXkkh3q1GDC233l35GV9x8aF9NTNOfsyjSidEDm
         JsOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9TLu1W7yHkhtHwjGoDo5vcDemF4Vg7sJTBG/DucIvwc=;
        fh=byyQH77w7AT3PESl4Ww8VWUvGRU6xa6/+SBoa8KaG5g=;
        b=OCHy7LB+sANik591fHV5EDp2KcU0qrjmE5cepV2jkx6gQxZo13AxEZIyvIqdXYTVYd
         JOXpTTubttcXt3dwlnqtXuRJeigb7qvrxypZ2pGhTZRjgM6+vIu2cjqE/M152ac3QKFE
         f1/4v++KnmMIynVCz3ZcC3kbD93NIoFFGt5A5uqeHPOY0xFwJJkHRoLHpyMNwiGKmnWr
         Oz4cfBkcQTScEfwcq6/Bly88JubJcdL719ASMOjLovrrhKd4enFbOpUAI60RQTypO5Fp
         nLCpgdRBSrUSy2+IycbB8R95R/9W8eNmAvYI1Z6MLOUvP6+c+1aF64gzUouF30WqoP1C
         aJWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787069904; x=1787674704; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9TLu1W7yHkhtHwjGoDo5vcDemF4Vg7sJTBG/DucIvwc=;
        b=omdK+/3TJ5qfCDlcO9+HZrAFAsVc/cMlQosIjRKhKs0C3OD0i33JOMDW2EVsOYl6ju
         ISjChexaDk5yal23WhHlYj3r1iW0Ik6moPQMEEd0vJGHg2CPMvhjlMVpDXRPj5k/7njQ
         6O9rPunw4y4/JwEzE3XB4gR0SenEsPg6vgfQmviN9PdhNNVHT2ersdptohVKcR6d47yS
         I5QC+JCCT0oV5+dJs1a2URyxu+23rA0IKm7fN+bI2hz8GAwBFVw7Zr2Cx2tXendi83bU
         tOE19I5SxXfxfzxtoZr7xcRU84aWcChHSeL1DRdAJaykX1N/a7rbirSdkQjYPdGOUYpk
         f8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787069904; x=1787674704;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9TLu1W7yHkhtHwjGoDo5vcDemF4Vg7sJTBG/DucIvwc=;
        b=MpazpaNReGkOfKmjZGC33lEMxfy7mynLdQjEwyd/tKbM9VhcuSGWWKmgdz3NQC8aAB
         Rw3auK4eIZyynCM7T4j3oHEw/iBEJDi0fHGv9i5ENCN2zyFyvaOcwuZ1gQ+ei3n7hi08
         OkH3PbKfFYnrvDPBeFKACgPI4EJpXlSYHlyHLqpto92v5fL7Z3XOL5a3Sdyo889pUYZp
         cb+itIpzwPAi5sibjtiUbdJt0vuSYxNYYsEw/PsyxbU7PETEUaMBWCkAZEJsdfP6FRvN
         Zf0GNUW4Q+Huob3hFUilOTBR7B5Bjpjg+HmH15l3rSGHbkPm+i9skFHKaACmUjCRUm/h
         RiIQ==
X-Forwarded-Encrypted: i=1; AHgh+RoqMlNQwzrkGSCj6S3ZF2vZuXMVFVM3m1LB1+tC6m/vXA83UdHBM63PxLOEK+TJ9gQcwIGog906HA==@kvack.org
X-Gm-Message-State: AOJu0YxTjv+6GpyXHr1EGLxCHrgDqhqynWBWtAGBj9xWLBN01VrCqU/G
	cdHTMAJMsbsyyMO5Xs85F4mxDM+NVYEJDCnCKs2oLELy5+ebmf9UnkAVPBwuCuVW8btJOE6McOC
	SyTVvJAf38iZxmi9Ej7o2pheExSR0juw=
X-Gm-Gg: AR+sD13b4NKiZDZiFt3B83jc3l/yvQ7p67aD7/d8Y9nT4yo8ZamUc0IF99uFUr4ovGT
	DZ0dUr2aKvtFScIRDhhwwuievu/DI4KgZrFlfqKLNOluGRbkPOcRTILubXX+5Hxh7i5WPpA368a
	Kk8y+Jc57twTaF90qI+O1amGaGSmNgIGGnDHMIZcbDasfR+fpkujKtsQllBPsUrUVrdM469UMDb
	DI1Dq+VWrEZro2iIJ22ZbcEAlsGc+7VEyQADUEBPXRkO+5w/UZYyNGwS8aAnme2iLqvcHbNVcS6
	Oh56MvoouoIHVug6VZ96IKJ9oYPtcxOCSJ0bK4QSckLvKQWjq0s/Y1LLq+F88eoVf45K4CucNYt
	u
X-Received: by 2002:a05:600c:1908:b0:499:841c:2016 with SMTP id
 5b1f17b1804b1-4999fa6a973mr133241715e9.0.1787069903628; Tue, 18 Aug 2026
 09:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-swap-v3-0-d3fa52598a59@debian.org> <20260818-swap-v3-1-d3fa52598a59@debian.org>
In-Reply-To: <20260818-swap-v3-1-d3fa52598a59@debian.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 18 Aug 2026 09:18:11 -0700
X-Gm-Features: AcwNN1WgPPlurq1mu7aFui2KhJ41Rbtso3zi3UMW6DND_PuAsyRtj7pP--qfT4Y
Message-ID: <CAKEwX=OJGV=f3hBOwE-jfxx8WaQmKRC8B26sjEgvTEShHjzb+A@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm, swap: distinguish a malformed swap entry from
 a dying device
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 644CC160012
X-Rspam-User: 
X-Stat-Signature: gy49ehw5qheqesscic6598bdb3ej175k
X-Rspamd-Server: rspam06
X-HE-Tag: 1787069905-607864
X-HE-Meta: U2FsdGVkX18WhXop9544qt15eOXfmPiTZGgnSwaxQfOCBvEJjaI6Z/XsK87UslVVZ12QWvMbQAheqTRNRqKbtYp6wnqJxcqvk7vXfO89Ir4ZCD+d7C6kcSbKQJFawzXLdhBVWTJ9SI8iwIKMXwjHHmCr9rDMjTC2poPnkxa+KtCq0zFa9Hw9hY32dDP39cOXToWDDVc192RXxFj05x9n4hYnFwNqiyOQ0TuEyNa56YFk8QdKETKEjJFAinU4A5oTXC2pNa4lk2vrmN8xf1z3uHT6XJAe6UdbBua4jtWRZypUclBhXraUPuD7d3+Wgo3C7/Fgys/wMXGMttwMML+DuOiOzvb6CXWhQahkYv8+II0+KlBnp2Is6LU/KtqCwRfOdI3ykJJ9U5TuNnzDKZU+APeNGMQ1yz7+Dubt8CSdfAA8zDPH7LS07iJ6XZ3gpa4HBYky5KjsXnSznYfxe/FizW7kAmBw3Mez6m9gj+kLcqSUcKjILL6J1d9Sl6ASqYOjIP0gF63y8dqyWjwThnpRN/2OI7KKYCqnTxMj5RbfGpnJggb04hJpiYmvWq7Dnc4STzd/ZG9qEuhA3gm2zV8wdjhEy8+wipQJJaN+XKUCpCcp5/DEuH/YVty2FK/fDaJJhjqImUonZ3TyXtDJNWUiqQwo60wWVLk9bD3Czto+hkHy/t7bJ030BxQUTxqEv7LUKgBs5JF2LKA+QIj7Tnq3wIZDKGLbWcKWqUnYoZccC2GEI/iaPL0OW0sraV3r35Q4wTCqEySDmWmZZrII7dUwvB5CZNxu6RkoQnSxy85uBPGsowcejEtS77rhF1IA7la/ce4azzl2Ne3VInFKCuJQUySlKJ2ED5u1FEWTSzPMmdSfTKqU99+ZeFVbVuDAUriO12ia1CB6XTF3Vrff2rmCeeZzTPGFfjf7fZvk1O4xdqlCtmcA8Z60IZoV8II3dpuZDPkzwuKBoUrECNxE+Tb
 VzTuvj47
 cvRyqRhZ7Lw4uTegYzKJoBO+HNp6fq2AY/sbqkUOIzQf2EOfU02UEhaBnD31eof4NtNEsjt9yNgUxWjmhd4PKr5oIB1dwCRZOde7Kt93M61BJ+t0aCYvRpiUS2R/pV8zgESfzAQI7OmCxhrPLAxtClMH97QUbhotQWM9zM/5xis6aU2UQJK1z51iStW9fNIfrrUdGNtng3tvL8CXpaafgfCW2B1PuGM+/nonGj154xuEt4N/G3ictoAKYyVrCs+qJVe1GR6aKSIpSJitKlDp0b6LAxq/D2TFOZ3OGGg7X8nmwIHmYnxrbuDVmEcIhlyk6AWuRVcj0tDi/BlSL8YTfPjcfUcRXtqbhEIF/IPyNHZHCZJ/Kq+wq3u/sFFYSaxOfVGjQ856n3KWsJwrtViQ2JgoFoysOzjm3q8e0u05OOFXMakuruVUoqidUphsWzOPPKmNtdkA54J/955Cvt/SP7W1HdXMU1ttA7J0tyx0gJETMUVFmR8+q4VPBCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 3:08=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> get_swap_device() returns NULL for two different things: an entry whose
> type names no swap device or whose offset is past the end of one, and a
> device that swapoff is taking away. The first never becomes valid, the
> second does, and callers cannot tell them apart.
>
> Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
> swapoff. copy_nonpresent_pte() already reports -EIO for an entry whose
> type names no device.
>
> Callers bail out on failure either way, so switch them to
> IS_ERR_OR_NULL(), and let the two paths that drop the reference skip an
> error pointer. No functional change.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

