Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6617AC79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 05:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C8E6B00AB; Sun,  6 Sep 2026 01:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344AF6B00B2; Sun,  6 Sep 2026 01:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232F46B00B4; Sun,  6 Sep 2026 01:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E83206B00AB
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:50:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F246B4047B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:50:11 +0000 (UTC)
X-FDA: 85182261822.30.4435F2E
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 108D81C0002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:50:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jcl7uqTx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788673810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlSLw0+YBIY2ITDImKVN6Gu2ov4yl998ZNhFCSCffxQ=;
	b=XebdzbVJBEvcwqYtiUyjZhn3MXaVGTF+ig0iRarMRqpJ+gnGQ0QtocRchqYKuGzqYZ3l0E
	/ccxmQDsox94m5tk8nbR6Oi/xT4iSbp68u/S+T1XQwc45Re1/Fr+uHPanFYaU7Y0JrpwlI
	QBZMz2XE31Zov30m481NSTzosgdWgOw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jcl7uqTx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788673810;
	b=pDuakxp4UxZL5jehU9JusBcfZuPf6H0M2XLA0/zapKxztWa5/NEYbFFw+Mbu89yVvdQKki
	aCRnohLLNdNjuFJ8z6M/v6++apKjiT1m7nLJ3hjOSVseMQr+eeDoUfXK53jw7ROFzUmgp6
	NN85eE/4kIM8nMLtHJ52bu5RdIeTSZY=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c25b661d37dso329427766b.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 22:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788673808; cv=none;
        d=google.com; s=arc-20260327;
        b=LIfdbRZ7AVyNL3R3xqK9sebtXmcUMNYTU1OkCEndNqmhjUAQat8iWqjHuu2MSalRo9
         yiKlQLmkfBpqRFSGd6jIYd7VNCnTuCmFUEhdaL3lgBjcTJeShJ3Q1JtMMX2gjDIFL5sL
         EA/WK+nmBmWuTv+V87Ntg95vZgvqH+uWn8k/6RK7UJhz7PU8tPeVtN0fweFIW1cGlv9r
         pU9DyHPrgfj7GhRJvpLxdg+mghEbpFIKTgwbo2VtDbIHP2vHEdDvlumS/Nqsr51N0tMz
         pujACOzDl6scr1eZvZLXQ0+mMI5+ojyhhHlZS9K2lQxJgW0T39KnkDPoScKLO2YH9WC4
         8o1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rlSLw0+YBIY2ITDImKVN6Gu2ov4yl998ZNhFCSCffxQ=;
        fh=f3VI6YXzHho/jJghPIwspqKMUN8+08sjeHqstxvOkhQ=;
        b=YxuLL9EtTwJaRLJJOxfoHQHK3FhVlTKuRjjVCODYAN9iaDj5tNNGE3ExEgCy/20g3c
         Oxz75dTzW+75zUGb90OZpfVWZQr/sySmtfbMWNucEUnYZSktu9UpmAc7hZIE80L4p9W7
         YyBo7kHPbMocf3VcDHhbvUDNevdABmRa1B1I/1Qg9FAD1do79n8gLbnmbLFfd4/B0J1N
         x8a2NIs12+/ivc7OQBlxtIt4X4crvpSen+aUKj3LGGvs0QzmaY80nxefed1gVyhTWG6X
         Djh1KOv8+LO4f8jGryb4o0CsnyikSPXd6ZHNNIIkVYdHwCjckY1eAK2E59dBt/k9rlZJ
         IRuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788673808; x=1789278608; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rlSLw0+YBIY2ITDImKVN6Gu2ov4yl998ZNhFCSCffxQ=;
        b=jcl7uqTx1npd+Tmn+2mPM+xaJrVWea5YWGeu3gfDc0YId4thxtStHRYbGnDgvBGyaY
         6bqaRsh2VhKpxea2yy5LjOizqWHPhnGRUyzlNWxazLCqiANdxCO+UGJA0TochMN0pe9q
         rdciX4vmOYSrXwI+BdwdSWAZl6fhygAsM4UMgnutG2wCDmhSkL2K5Ihp02vqxVhaqZr5
         rj9SFFY6VDkmFfhklSKp/noV4ui2Pmq+UEo8YkvijAvyszLE1bz/ixTPASu95pZPuwZI
         OFXaMCw9cat0wDvUDa/sdy55QuYfzB85qEczndlXAiaxuewnV84F+60kyKmYpegx2o07
         P5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788673808; x=1789278608;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rlSLw0+YBIY2ITDImKVN6Gu2ov4yl998ZNhFCSCffxQ=;
        b=FCOnZNE2HKjAjPyzIvbGc1dKxbrZ4YBTXhi/9U6zcI1Qp+fpWBFR1js+dF+v+V7/Zn
         hYZsFEskMNRinkvP/5Bsow2Gae2p6pB1Zqm27VsYhx6rG9vYBUxu40yGSs1fw/nWWIFv
         d9XECk4Qrsj/+b/KZXZ8aAmutOcYKjJZMkhfa6VDJ0AaPpWVZzuwlkB3imSG8IuXKegk
         pieRymbUX2QIw7sDmK58bSvHAiy/sWRwAIN3eE/jnVzdprbktRjTrTkyRwrnISzAoW+r
         VUgDrLIBairinlPh07yAdaUtkCO0xVhAzLSWnrrZ9CFNjKXI3Wuw13fbik6gtsb2o0be
         Rgtw==
X-Forwarded-Encrypted: i=1; AKwUvBxIy0ZhgbeNf1NZoNHau77QXP1YoR1woFEAhu6cAjxpx4f1htida1yF5fYPKili4ZfDC2T7xmle6A==@kvack.org
X-Gm-Message-State: AFuF++l/jyfKkvfIpQYi/1yku+IcaUDthxPN4rX1vyeVVEfuT+k5kal1
	P1l0SKVS1DUOWozspgcLNqeegWSObuYMczOv6SZPzrMJNoa3HLtknLjmtVKz2oVtZakA1pOXbj4
	MyAUlZxLMikJd6rv8PMXKbDZ6D05tujU=
X-Gm-Gg: AYBFou0KSpDQXJx9M+qxH0/eOpDFIYJCa07ix4aZVZb3YcY/pVjNH0YRGPZwO0evsEW
	2A1MLSmEREu5R8H/YbsDuSYTbMJ3DpMnHhUujrDf4ptvuToZ85WC8ijn1ZLfLhiFgz3uczTD60P
	apYT4QS7wP/2JVdTvdCRSa83UXxIRsSqgd26UOrj2OeLu5OhIZpi6F957DZibwmW7tG29P60wZZ
	IEvp1TUmK18Hl+FRjVCg4+ZkmnUquNppUjtXMOHwFlZQt+6wbvZksDruone8xW8RXZ2jKuMTNhv
	JKShF/ELRn/RPjypQ804bON0DNM6XrND32f4yTa7Zk3dG1FYnswNqMfi/2yULno/Fe07VkjlJS6
	/Fg==
X-Received: by 2002:a17:907:970f:b0:c25:4b3e:ff24 with SMTP id
 a640c23a62f3a-c260c8d8077mr500163166b.10.1788673808156; Sat, 05 Sep 2026
 22:50:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
 <20260906011820.382381-1-zhangbo56@xiaomi.com> <CAGsJ_4wC78QDTrETC0WpnouN=8aF8ae6Yxgb+oKiOP3A76ATLg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wC78QDTrETC0WpnouN=8aF8ae6Yxgb+oKiOP3A76ATLg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 6 Sep 2026 13:49:30 +0800
X-Gm-Features: AcwNN1W3d0Og_zgj_zuXYW_3ipFK3L8APnvEnnR3uGPVN-t0sokfY9kP47fq6Ys
Message-ID: <CAMgjq7B==MqHXa6H=arrQ9a0bUXWpXG_a5EBxZGjLjYUuEf1gQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
To: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kjs4tgz4ch64t59n3dr4yse754i6d8bm
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 108D81C0002
X-Rspam-User: 
X-HE-Tag: 1788673809-16034
X-HE-Meta: U2FsdGVkX1/Yy85FqkJYjeoXqLaD4B4fc2LZXTlVY8JN3d4blnvcTwNNkY3NRtlplk3S2VvPFJVv2ZO+CvWjA6Ym3+/JQasw6cD1u6dzkzkImkguVEO1f47gydgH8Orqt1CeYAnSuJ/ePunaENrkVIgo0GwrTeVNQd5R084kJYDQRTezWtyoRODKHFGYJDfm/ZNJfyy1Zdkm48K+K8shI8LGJ+4kA4CZVtXUMPqwCKi6+cJRgAjNTC0I6zXwUlKFY+PInZ3QnEr/hkwwVeZa5drR0E8hOg7VOwNNudzZGziSs1oicYOIpHT9ON2X86EIA4T4hal1k7JK0CTZUgkOUyOXkEZfgaxhxF8kFnBdyVQ4hIVXNashGaqFtgYXW1mS7DWohcASgxn5frX8HX5gULL6sMPdiyu1JjcyyEmQhOllWoiEUNAwmaeO8wAgxn8rw1G1AMXwGF6IX486Y2R9Vt+kWvMs4NcpQqnOcORxd+TSHycc9TuscbGH2Siy6xBZiexJSGxueAeO6nTE69dVN3YqkYHZLKxfVDfWS7ETwJDxaK3u3Q4U5X2l/WXaZfNOMQ2wiI3YUpYppsmRO54lXPM1ZHTkdzASyDPyyhG1+wKd8qHa/aLp/Mu0xC7g6NPKN5cz3SeDuYJ1xXgwDnD7hyCXYdHn/Uh8NTAQQXNR0FAh7XNjkXDaxWpTF2nwy7JZ8qWQgaft4Uv7q6Bxl8RkI44aJt2Me1KB1PEh9cqO0MoLBoL34whTaVQsot+88ohNCSSR+4Ll1Jn6eX0ubenl0ydh4PxieDIg76tEnbo3q4WsUcQ6SicAQTuxF5HyMqaXQNnk4VijwKh38leVClcVpUBKNqyfv/aOpn4gnOKIYI5QG6u7PuitAHz9eREIuuzfUxz8xOOZRvN3CtQCziSRp2eK7QUMUJvzjcXwvCCoysJ5PxIjhV8Kvz/hmtiN1/sICWW4utLcY7Jq0H2vtCp
 IpELWY+R
 Fly8A6hGT5uutwReerb6Rw7vzBk6EqUWf/0LRJ5feMZ4QBPSy938p/8/Ry2w7AScopbRBIPqpVYZPxJ+hLX3Fys8dEQfMKsxB8VL00PsRptmL9Gby19CdmrujnQ7+1/U1KXGdqgKr/xZkTBQfRdXvp2huCdVIEUcMlPXmUrCmYUm5IjNTt1vcpp+R6AgKJ2mPAcA3HLanD6mOLca17l2d6sChWRHKZCzt8HxtHxwP4xodp+wDsFirJJZtvszB081SW61x9sW/Zhwl3zG7F4t1Dk6KOWXqkYG80gRTFVg114dNQnazuaBnmv9Oj4hTedBvdJkjfW0dKgopejGHIMaFouLyJ1ZNYlpbkJXawAwsdQljHNCCdJ1L0MIAajxIm38v+e8PIlJD2B6gM7VZGfSIoUconW5JjFitxcvrSr+8CJFNTxb7Y7GUdZ9FsJHE4PzXElOAr1NRYagsOEvhxqIrnUkJZ9rWSRJo/RLu1eu7vTiiJ2hO8SncEloO+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 12:56=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Sun, Sep 6, 2026 at 9:18=E2=80=AFAM Bo Zhang <zhangbo0325@gmail.com> w=
rote:
> >
> > We have observed some cases where memory is allocated with GFP_NOIO, so
> > we cannot reclaim any anon folios unless they are in swapcache. We can
> > end up spending more than 150 ms looping in `shrink_folio_list()` scann=
ing
> > non-swapcache folios without reclaiming a single folio. This is pure
> > overhead.
> >
> > This is particularly true on systems using zRAM, where swapcache is
> > relatively rare. So let's check whether anon reclaim is allowed by
> > GFP_IO and whether there is enough swapcache to make it worthwhile. If
> > the swapcache is extremely low, we're essentially searching for a
> > needle in a haystack, so let's avoid scanning anon in the first place.
> >
> > On Android this is triggered by dm-verity hash-block reads through
> > dm-bufio, which use GFP_NOIO:
> >
> >   verity_verify_io -> verity_hash_for_block -> verity_verify_level
> >     -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new
> >       -> alloc_buffer
> >          gfp: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWAR=
N
> >
> > Such a reclaimer can land on a memcg with a large, unswapped anon LRU a=
nd
> > a tiny file LRU (e.g. inactive_anon ~335 MB vs inactive_file ~4 MB, wit=
h
> > negligible swapcache). shrink_lruvec() then keeps feeding that huge ano=
n
> > list into shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,00=
0
> > anon folios scanned - where every folio is kept because it needs IO. Th=
e
> > 150+ ms above is one such single shrink_lruvec() pass (not accumulated
> > across a reclaim cycle), and it reclaims nothing; the actual progress
> > comes entirely from the file side.
> >
> > Aging anon alongside file does have some value for a later __GFP_IO
> > reclaimer, so it is not strictly pure overhead. But that aging is only
> > deferred, not lost: kswapd and other __GFP_IO reclaimers still walk and
> > age anon. Spending ~168 ms aging memory that this context cannot reclai=
m
> > is not a worthwhile trade-off in a latency-sensitive path.
> >
> > To stay conservative, this only skips anon when the swapcache is really
> > tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on th=
e
> > list can be reclaimed without IO. Whenever there is a meaningful amount=
 of
> > swapcached anon, the normal path is used and anon is scanned and aged a=
s
> > before.
>
> I notice this only fixes the active/inactive LRU case. To address the
> MGLRU case, it seems we may need a more fundamental change.

It won't be too hard if we just calculate the type and number to scan
upfront, and I believe this is a similar issue due to the same root
cause of the OOM and swappiness issue of MGLRU, which I mentiones
before (see point 4, "force protection of the youngest two gens"):
https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=3D8=3D75su38w=3DHD7=
82T5E_cxyeCeH_g@mail.gmail.com/

Removing that force protection and calculate the number to scan
upfront, then we can also make use of can_reclaim_anon_pages, shift
all scan budget to file type. Aging won't be triggered at default
priority, resulting in zero overhead. We can then either offload aging
to a worker or defer it if aging isn't helpful for one reclaim cycle.

