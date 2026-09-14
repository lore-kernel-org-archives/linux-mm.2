Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB2EC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2876B0095; Mon, 14 Sep 2026 04:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83836B0096; Mon, 14 Sep 2026 04:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970D66B0098; Mon, 14 Sep 2026 04:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E11C6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:10:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB2851210A7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:10:17 +0000 (UTC)
X-FDA: 85211645274.07.A13513C
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf12.hostedemail.com (Postfix) with ESMTP id 053B74000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:10:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r4blm5a8;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789373416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbupapCaPX6GqH+Zj6CPFJqNq2nMbywMNp0mnaUzXz4=;
	b=vrvts9xl38+VWXFZvyM6PppoYIYb2j1arT33USvwZlV/ypPF38QACeiIrY6qdsXeTraji8
	RHVkkp2N/xmw6QIEOFrbQTZKb4nCqZFF8fR1fxwL8RlPF+o4wCe5FXGaQJQdBp2ODvY0mV
	scvs12SDfmqG/vcfKN6kknJujtBxeWQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r4blm5a8;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789373416;
	b=DLJD4TextdMn05ktWjCW73ILlsA3+HwOzPXDj8i1clFTBQ1n7oRD/ClQ7KDqd7FHZ9s2Nc
	zPJdfqbRf/xf4GlSKmUjMd1+wlKMvJljpdnvGDeNhy3XMqb7uurBQCOL7FFuKkqXDYtkV4
	fOdUc10P2pFLeoRrURIC+IdMGVbA3Oo=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb796so281323066b.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:10:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789373414; cv=none;
        d=google.com; s=arc-20260327;
        b=RipE2UePOup987BrYfnPvHjWKovae3KGn4kVi/P1gNyuFs4jgPoP/vk8TqJs0erkaB
         YFmwU6UgH1J2jSXCE+rBYDjd2I9MbH8syYSaZnsAACrSZ+wXTq2+2ialzv8gOyuryd8R
         G8+GgaF8Y0xP9sJbU81qHtvpOe97xH/khr5EnBQkwb7qiC6frQH/EJpV5+fdtkpVqlox
         j9NZqG/pd2qNA+bnr5WpMLUF2+Xu8RvvyH9A3ger+kiMpltg2Wv+gxLKQLTk7WjXv6MS
         qDoBsMGQh0GB77b5W1hfhacwTs+5X8LGaXS0G21ZK+uGM4e6CZFNYPmakDhemY7717jY
         SfvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gbupapCaPX6GqH+Zj6CPFJqNq2nMbywMNp0mnaUzXz4=;
        fh=LXVTwXva32XfAgjj/8kYaXEXGOh8vR1QvE1vI0mcBtM=;
        b=Z542HRso6cZEpZtQtzDmUeLOuq6RN13qGR+JXgPqkeHsjB0qQdUfZo9FmQYNK8LTh/
         gY1xpRkzH2f0NvCDR+zb3R+0hfFDFZLERa6btCKh/43f4GTTqy1O3RrwvM+hZ2aIVqc+
         nL6jgGxE6uQuHXPgjPYt+1fuOND2Ygr7g+kUSxxTJvLELXvXCIxtxqzSjVYv8/LI4UID
         ZfKxe/VgT9GK3ZMhMvuQGr/DMYadmr/aw4AqvF4izUvgFGHPw4YyzL8Uw01OKZz2TgzI
         xHeu5bSyrHlcprV2ZTm3rdQcgFAXCv34G0eshDS1ZcfjYkDv9Bi5l3E95oWzyeH1Jk1T
         CYuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789373414; x=1789978214; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gbupapCaPX6GqH+Zj6CPFJqNq2nMbywMNp0mnaUzXz4=;
        b=r4blm5a8uS5qses0h1oDZRXxxnRDATVFsz3ruHXJFwCWiS7zKYFRJb/B1qVFkbEj0l
         xmVLkZfa4eJH+gYmcpM0QWlYWiqmll9pecVAGlrnf1sCZrBG7JukTw04R4pTU4Y9HCJP
         5B5uhOTzmvRpwmYgwPaYmhZNqMmKPGGUWxTps1trQkc92XhRiPbfthmxe+3Q0UvE4533
         DS9JUccfKbLjMklDlUHFrWduLGceA/IBMlS+Z+iam/teumu5hdULOcPKONjSnDGfpPU5
         NzSob4IA+/2cxVfaTaKOpRo/UxZWQ4f6VnuX3PYuD3xmkGtSsHLbSXzrLefPX9uDCdsn
         iQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789373414; x=1789978214;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gbupapCaPX6GqH+Zj6CPFJqNq2nMbywMNp0mnaUzXz4=;
        b=dPgCmHWMwGx4GWSAmBjTmzEkHfpYH1lCVrgJ2XdVaxUUeMKNo60acKJXfznWz21BEA
         OUfCI7ItPfkKPa+JJYfpoqEwNKDwnslGNNSCcfFgQIYT1sYX1tRjuAUFNlZp9wclRXsn
         enJkL5r0z+7IqnsRiPnQcktxd8r6dSzz9blMC29KGmdPkCGANC26rIMl8vnOoUhaDl3y
         8YJ7/J7TUGLErU8EB3Z5YMG7/nvX33rmwzoW6lLCy7U7vtnqkxqNvV9Fscaya1ZrLohV
         Dcj2lNW0zPgtCCxuT2Ta0iQ15MTgE0dQgTP0JBwKzZPqA6t8oWIrokbR9iKRUsYwyxtf
         PLiQ==
X-Forwarded-Encrypted: i=1; AKwUvBxyjw8ssrW2IEWwW4r+Y+PN0SoCKEfNzCg4KkX8Ush5N0F0vO05epCzU0ceUiSdtWtXFFMJBKRu3Q==@kvack.org
X-Gm-Message-State: AFuF++lmUedvDulnLTO0zke4xF8OW9ul02zkv8RV0dW8bNd/BgccPALH
	wz4JK1LMMpHytOkqbyJtKFClvRt25Sh1i7wISQcrSRFszhwZSAUDuk9JZmY8miX9awZoYGuPaG7
	OwdCI391xxZQO9PKMb174pe/518ztU3c=
X-Gm-Gg: AYBFou0f+Kf/iSTbLQxuHcwY7AofFxT3g2aj4eYctscS5Ot1FnJBEmeFDQrGV6g0r+y
	7qHIN3bN4v9MrrQ0Qx/b37r4/aew5U/N2muEntZWpgV/lOJUm4oX4CSZUDKkLJgMupKAQkdUFsT
	b9gaMT2rksHTTjhcxKM1LXpO9+KcW8wrw8w7kV9phuaB8MRmmGGh2pvJ3PfJNahf2kAf1ILkpGl
	0v3GOs2pQlo4lrlLNxF2fa3mjzD29ytATtgIrqCJXtXpyc3iQqw3rkXKQG5N7/L78Ha+EPTNyDz
	I2myEgyUPPVqcuoWAKvhnY2Kz8zUb5mNd9rw3WxDzobef9pHfro25L90WRQpkZrrAh7ehxIuwQw
	4DdCsf67hu5VG1A==
X-Received: by 2002:a17:907:9619:b0:c26:1648:a074 with SMTP id
 a640c23a62f3a-c29b87d8a8fmr90164466b.47.1789373414434; Mon, 14 Sep 2026
 01:10:14 -0700 (PDT)
MIME-Version: 1.0
References: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 14 Sep 2026 16:09:37 +0800
X-Gm-Features: AcwNN1VSUYAraBKk949cUbwQn07C_1-qFVIQEVtt3AUC_LCdeRgMe-Y0Soko7Zo
Message-ID: <CAMgjq7DdF_fi_MserE_P_AbKR23mrqPLZ-VD71eXH6iv1ncdzQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm: mglru: clear the reference counter for
 rejected folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	ljs@kernel.org, ridong.chen@linux.dev, baoquan.he@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 053B74000B
X-Stat-Signature: mb4977rwsubbuaxbmmtxywrk1s51ithf
X-Rspam-User: 
X-HE-Tag: 1789373415-345557
X-HE-Meta: U2FsdGVkX1/wlV2e8ND+tnIVJMiYmv95KUBFqq2hKr9zjtqTJKXwGjpmee08IwCxdibVWziTB+W587wYaSo5Kuwyt27bkgakk2Ml/WvsLh5SFkDNRoNhM2kc82Gd8qdtNEoJFOR1Pyv811vuI6env2Z1m/p7DR0FZ6b+LZsVNh+dtWL2WWZlQQzTN/bgT81IeyqB3zKUrZP9yUbWXxWeDXef2UUM/AjxYyuQjurZBCtUC7ceZT7/Cj01nnSWEXvmzNuAUMe5P9soog1HkGlb89SCbyJoobaqdmBG/RUjDwRUwzTtX2DUwn0VG3hQxVRRq86BULnnLrDaGwPobxvzZKVaVva/bGC3DI9dDNK8DYi/zgUKn03PDEBX62c1hf5K1+ERx6fhUZpk4wxBocTYwUVDtroDDlXmRULQ0O8jaoE2DGX3K4LSXU8DKjllQbzyNDmjkX51BNto1TgeZS+YlhaBxNQNfPGRkmwJgRQvrf7DSzlv/HQU21qQEUyGoCjUmsVVtYLv2jtNTLZzNDNKTt8UV5jlLwq6NXf5ACxb5RycopJ97Yt2MnZ7Wekyiy2Uu9AraOcwE1KvJQlIAmLr5z2h0/urQIFdyFUgKflNZRe1zWTuIfxkOVw+cLGcVGsD1Anp5K1YoCFb1/EgYG1qIFPjbvSf5KK57crN2iBrii0wnRg6+QjYt0xOz0dKfyWQ7DBTLo2IffguZSOe+v7YDg84Vss+npVmNSahwqbWjHNWRg+qkxT/vlDFSBRxFKyDWDIhcOi2VI9i7DL3FARVnCM10o+C3k73TswqUrjYk3rr0KqoMgscP+aYGugnVWm1UJrw4NEd35Un7riyMA4OsfC2rubkYabhFexm5+VC+KjKC/1Q/fr1kQR5YVEhUelMcnCWJFoc/qGFSUgUS6hJFwGHSQPE//UZLijmXr4eEw5lP14z4SxS6WhxgAQPjUu6LF0JNq5oaLDtOtNTFjl
 NILzeHUL
 K4KixqtvYLkot7lRU+L1I3qRhhwppVtOkOGkEJLBHUmGhNI4n3kpA+96kajAguhsjluXdbdFGNVptD7v+glrlcFQR8kIYdl4CFcau7qeEAXHKgRLE+xusvgSl2iAkQSwIS5ZFMTWoWlE7dDJSkHTY9+zfWoo0nNSDmallhumZsnWXyXQrfmMGsCN1Sp+6mbUnGD759pZ3qy4vVfTvGkA9O5NZjgK2HwIy323wfK2Bn4hqNCHb4C3fd9c+xHJxUmiCG4j0VysrDRPFWXMs0ATHXPyJRaONM9JZmTjpnSZUDfbDFrJT6+LnxUYZaP/Kw7dMuWzq3B7flBc1AefMoDp5nAsf8XQTOsERXMpjYJn1vJRmELoYFbrzU2SlI5p0EdN9XKiwqvPCCkLiSmrrZyJV6lZVH3BuCUTsS1RPrCq5y4nG0+L3Lnuvi4iwtLvg6o/NruSt2oruSG8ARqHMK4HBQIPWzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 9:57=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted t=
o
> a new generation, LRU_REFS_FLAGS should be cleared so that the reference
> counter can start over.
>
> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
> set the PG_active flag when lru_gen_folio_seq() would place them in the
> oldest generation. That's fine.
>
> But for rejected folios where lru_gen_folio_seq() returns a generation
> other than the oldest one (which can be treated as a promotion), we do
> not clear LRU_REFS_FLAGS. This can violate the promotion mechanism. And
> this means the rejected folio enters the new generation with stale, infla=
ted
> tier bits, which can inflate reference counts and distort eviction
> statistics for these rejected folios.
>
> Fix this by clearing LRU_REFS_FLAGS for rejected folios. Of course, I nee=
d
> to evaluate the impact of the changes, which mainly falls into 3 cases:
> 1. When lru_gen_folio_seq() returns the oldest generation for rejected fo=
lios,
> there are no logic changes, and they will be put back into the 2nd younge=
st
> generation.
> 2. For rejected folios with PG_active set by shrink_folio_list(), we only
> clear the LRU_REFS_FLAGS and do not change the generation.
> 3. For rejected folios with PG_referenced set, the original code would pu=
t
> them back into the 2nd oldest generation. After this patch, we will put t=
hem
> back into the 2nd youngest generation.
>
> I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru=
:
> use folio_mark_accessed to replace folio_set_active"), a rejected referen=
ced
> folio was also put back to the 2nd youngest gen. Meanwhile, I didn't see
> any noticeable performance impact on my 32-core Arm machine when running
> 'make -j32' to build the kernel inside a 3G-limited memcg with either zra=
m
> or NVMe swap.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v1:
>  - Update the commit message.
>  - Clear LRU_REFS_FLAGS earlier.
> ---
>  mm/vmscan.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 40d3f1b48a74..1557679aadb1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5020,11 +5020,12 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>                         continue;
>                 }
>
> +               /* See the comments on LRU_REFS_FLAGS */
> +               folio_set_lru_refs(folio, 0);
> +

Will it be better to mention that we never add the folio to the oldest
gen (since `folio_set_active` below prevents that) so this is
effectively promotes the folio by at least one generation? Maybe can
be combined with the comment below.

>                 /* don't add rejected folios to the oldest generation */
> -               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type]) {
> -                       folio_set_lru_refs(folio, 0);
> +               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
>                         folio_set_active(folio);
> -               }
>         }
>
>         move_folios_to_lru(&list);
> --
> 2.47.3

I tested this, and also tested with MGLRU-FG on top (the posted
version is on top of this):
https://lore.kernel.org/linux-mm/20260911-mglru-fg-v2-4-f26e5cb26da7@tencen=
t.com/

Both cases looked good with no performance regression observed from
this patch with a few quick tests. It also has no conflict with
further changes. Nothing surprising was observed, so:

Reviewed-by: Kairui Song <kasong@tencent.com>

