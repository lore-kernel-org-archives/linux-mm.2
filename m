Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFD4606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M4QupC8z
Received: by kanga.kvack.org (Postfix)
	id 611B36B00EF; Fri, 20 Nov 2026 18:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1E86B05B2; Fri, 20 Nov 2026 18:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0BD6B05B3; Fri, 20 Nov 2026 18:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22A0F6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:08:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A5B6401FE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:08:48 +0000 (UTC)
X-FDA: 85457039136.14.C2DF2B3
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4FB71180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:08:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=M4QupC8z;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795216126;
	b=m+OaHbJBBHKg1m3c9PYzMH2US45UuxIV7XUvQgtds+GAmAYzaPr7sp2JeFqEQdR/QGTXKx
	AUOUVUNDOM6EWa+E0Jnl2IvOvqTqtyu2bx3af3j6P+614AR4bafMokNSTLekuMbb2ZewU8
	9L79IeFZlV2OfOB5++Mlooy1p6rMYKY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795216126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
	b=P7948Tb2fZihmb6bnOl7Bl6oQDz0eH3YlFXVIDDmjMZc9pc7QPy/JXsvgjbLgypv+q07Of
	6Y5c0DBvrySEDN3sHfGTlytPbDcMbF/i0hhAHAtUfIE98qXgGbE7lwecKSDv1ipFMOxXsG
	xfjFEDsu4UfOqs3w00PIQpnOffmH8L0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=M4QupC8z;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so8195585e9.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:08:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795216125; cv=none;
        d=google.com; s=arc-20260327;
        b=q9t9UuW9tZz1xv0gsg1RPgItdbh5aoEMUPq3cPrpZuPsvwvN0vTiCHaCkcuAkvsX5I
         HU6pyx58zpugqs1N5dUYSFSubsMKQSIpGgLmCTV8zggLtMrc/mGgZZojOzbjLZdTTpRf
         9fSw6y53EK/MbkAFj5LM4z0mvcPMq9LhKd2/RmEXDRZcqnyT/jkG22WmVHHFaO3iFSkl
         S7SrbT4x+Q5BbMT3gPLT8DZYArOXXcVFZxGe4OmmNsbUUAGI/WZ+M5H85khiPCYaL06k
         3vFbzZ97ElMg/UO3fWc3bwbVxtGYay8qUjyxJfRW5EJPp7FFaD7tkd+JYOezOL/GH2nO
         Bstg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
        fh=UFcoFzuSF+XFMZRKRSArf4WubvGQBbMiZotodB1KdOw=;
        b=OJceXJv6Rk43MByVJpn3BtFtFLe8sgRZnjKoBbPGG4SOrE9VlC9PqScANWUoncLI6O
         QKe1jVdCv48C1ejp78FQT59fSSieJ7chdMqJymXNctwZrjJn5WhMVp20YShlCeSVauWa
         vMQwYF9FF79SFARDT8sl/Dhno40DeUnHbDrDnSWwG1LwihySluGpIOdxoYT24k2yeJ5E
         Gs991/bicQB9FdsaVmp8/DpcuNL5W2S7XHH+M5A4JYviw1+DeVQj5aj3kuq2DE/yXOA1
         fjhXCEj9JYv04GrO8eyW3hmtO+vGt+hiw2DBxo/TDRr2vLjwbHfqFT7JhgUlwwjKrO5k
         YGuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795216125; x=1795820925; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
        b=M4QupC8zYgH8E0z14jp7L8OVpF22unNDZo/KyUg2jf1oH80BW49ELTwlMvx+VFkd08
         JxpKGEgCprGa85bYvBpaWllKkWH8N5OWDOQwURFZ3iCHDoM2fOxXXOgVMHNo0h/zQEBl
         cot+NUI6ihxH6HDmzFc96OKEgsX08CgBZtpfPIUgj6ScARPO8LPgx/WasInJRtHrxkb5
         LU4CXcujuacDGamp4nSGEUynG4MU6UfY27umjE9rZOR4fP9W7f2Yb16kjzmCUXcDZ5/6
         n0AMXELot+iiyTwJ743YhGobGEJGzGJGCFFTUTg+QItfqakB+Th4TnnDZFM+VdIp+ZBa
         J9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795216125; x=1795820925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LNi0DReitfHRwsgEnJHCKqDlOJr9t9ANMesp8Kcr5k=;
        b=1U05spRoNogeQYvlYSf/+C6NWN5HXaor/ZYiyrl1CbGdw/s5ICBYeCYrCkOshX3uV/
         2o0XsVvuEIyK8J6Pp3ET7CfRL3HKu/u61pJiGvx7vGqBMcpBuLiBZ5pCdVUetagFkpxW
         kwEW+qZh+o13nUP8CR/dRJkOPaNEz3ElN7uMD/40EqlD1xVIK50/1EzHuM3Z7Z60i/NQ
         np0kiujikmEyxO7odWg032Mlz/DTIRtfQPcrVJSOB/+rYvXGbXZ17Efe1lov8S7Rs4JG
         K4Cc05SPTkmJ1QI2cf6HCxgPdH51tKJJHgMg3eyyYF0iui6fHWVTtX4MoB2uJWgG65E0
         SpfQ==
X-Forwarded-Encrypted: i=1; AL+hErFLVELK83etbbBOCj2Y7WpQxswylS+ynpniUtFAe+BuXl91I0PinEojslzxNhjnNWs3uPJyY7RslQ==@kvack.org
X-Gm-Message-State: APuU4Z+pklXJaHB9dVZjYrpZLjKg8lK1TuKQfPrxjDQKFwPBYNgTqgOf
	XIrEFQNrkju7SxzbEPBrW1zQTd85jkopK6sBuwQ/RZY1pBRoXDMXUM/lQY4OIPQjngavsJd6UMD
	+5cjk9HBSdD/m6aHtspIAYG32YaXsyto=
X-Gm-Gg: AYBFou0hdPZPiwL46W+C0naOKcl7ZOSID/N+w9i7IO6flM/7e1xLG+gcuv6zkS0OWap
	0bM+zQyNr8QMDwlsK7ZwKBejwFYgNYCHTrM6NqSO7oXMwjoNkR1MJgZQzWRFQoQUVOjWpPFdoj/
	+IMaicQO8XyxTZPEifODOAUMlzlADS9oF5AJBw6zZVwq+7WTnOhXg9WZZeQjPGd5h2voVwcbaTw
	j7D4G8jtTsFvkIHxFVg9+wad6g7JwITY/tlM+h0rSJ01X+Dmm0GJIV2FMiy8mMEAP4BSom3bMuW
	bQafOtKj0zyMW23Vr5HIqxOmIhJBxzsh1xog0BarYixJ0btvXghLXuOcZnKbucL8xIFTJMIRZVK
	WzFBWwkvQM93GIRuzDGq1IsyPSgW8tHuB+M0vvwrjGx2rDR70PA0uFksG5M4+vzE8wyaTBq/ZMU
	vALO9OFRsjKq9gAo9dtwn6GX+hZXmscdwgT9RSLt5hGaNJ4V+JQ0cQUBg=
X-Received: by 2002:a05:600d:82e4:b0:4bb:6847:7927 with SMTP id
 5b1f17b1804b1-4bb8882677cmr106256925e9.7.1795216124609; Fri, 20 Nov 2026
 15:08:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 15:08:33 -0800
X-Gm-Features: Aa3M54oWMWk3u-HStz4cQZgKn2nyeqXit_w2sb7aEXMQD-Dkp35CvqUHYELg-w0
Message-ID: <CAKEwX=Ok9rom97s1GbrdJHNLqQTj-C=iieFHnbtUVY7skO0DGA@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4FB71180003
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 85m7o8qy9xcfb78h31fky5qxtbmes88o
X-HE-Tag: 1795216126-374945
X-HE-Meta: U2FsdGVkX1/T1AIjNMXqPDvvg6tZbNluM132HZypi3+zl8WbSx/DoekqFzFvVtjaeM2lglu1U6v+s0vomY4zCBe76QyN18OQ+48gJHe1O6/suhYN2m1GZEWSfvbeAjswTsUewdCQbQjLI0WHFuiQA3w/t/5gzX+Mu72UusxmIM+Bka7Ev8MC/HhNOXVA8Af31nqNERZE+6YnEvkioZ5aLTebGLIQONm5hklMychGOtNpCDgPeJkY0j0L2q/fpJWiUnYfKfKyMe3zV9STe67UqtRlQJFZH6YxHmQ+MZJsr1JF2i9oWr6ZJGOdx8l5JGJaBJrO+spLoZGmTaB2590MdWtklV+EO/ysFmWh3Qk1VgCZA/yHZQqNpZ7n9CCszEg9SfIcZLiTn081eDK1lhr9VuPJ4lZ6a638CX3OFVM683V9ZYLcLJwSBWpveUTD5XbQokKm+ITmiYDztlaj2d1lUpwRDF6+o81zvDoXvIsBdxqym672vvxjQBxi3b0JrNMDzQs99oWdcR6tlBliQ/KkKE2d1sPhcc14pNxYX+YkIhN33y1g+cvmsfvvuPyk3v3mqAtWXVaKlITatT3VDY/GKHI+HCm6dKiBcL2m+m4E4/S1ZbvQ1GyaJJrY2C2tEbaWwWNR6uyuCSuIsnxlupicsPhmCFryPMQHAVur9vf9a87XXza6LUyY3eBSaTrjNDhfM1ajeAXlRpWLV5qlhVFiZm4YrDbxT/qc/ZrtOIBmrfWMjshQ+sGbLnRbrXBAwtXdejdQ3woLsooUOBp4W+tpYGgJ4Q8MtrGQQCiTbHSMkxOji95o64Cd7i3/oRtKvcjBT9G6Bt/AMwbwE0qnsbXdRBveOcwBmlGhnXQ8JVxk1+ER4l8gpv+fqmtXSWNWrFunCfyYEkfRSIvJBS0h2/sIoX8qWKNQRjIJy7g+l+NgKgItg9O6R1tGk3RjIvsN1xxOT+IIT/SmHPmzCC94cl3
 5sJJ+35C
 XrWvB4+bSVIL6Dq3XybBKcYjdMXowTDp+JmOztGfGpU6qHw+r5t5X7EwNXFVYKFdbE4bjn+R1rDYfvv3uu1GoCGvwRmMrb5XTpyReGee8J7upbRsq2xgOHHwYledwUnsPXuVOjXbD7QRW/Y6kqVPSg7MxBvoPM4RttwS2W/vjQy+xAorT6BB11BmC/HvUS0JMlY1UEbckocLHF+una7XhobkGjwc+UVXjoaQ+0XQkGI2Z+H8bm0L1RHmdeD9mrvjlS82G0QNIdk9oo1rigxU9ZJkMDFQTxenl+/DL4R5RWl49wuEODFQ/9sB3zXYDO67e9OrKZYJXBL3u/pMjFjHLMgsIT0cCGK4wFVzM07QFVhjLjPJ2ABnfNlXPSdCm9VfY4MKgGrSFAhuEHsm9bYYf1LkiUGKxetO+i7aMRjAXm0VQ5B5Lf2/ZoI6fFKyBij8eRwDJQyesdvQd3ud+jtY4yzW6Q1FdLr1AseIVrTzk9O9mOmibZH7afqzr6rO9/bQPmAktb19IBrLgchDsxGyytvO93KBRZofaYUWMs7ZPO+Sxm/lRMTNCv16Ev9FIOOb0uWoeLwh1KQezZ2avk4GbpwwkOu2yP0XDqkhoxJ4w3B2R7oBubTf9kcu1sp+bb1e3vsY3rhF5a8Jkwk0=
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
> Use batching when storing large folios in zswap. A new constant,
> ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
> up to 4 pages at a time while storing large folios. This commit
> modifies the "store single page" approach to "store a batch of pages".
>
> As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
> compression buffers are allocated to eventually be able to compress and
> store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.
>
> For existing software compressors, the extra overhead is the
> the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
> additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
> x86_64. Only the first buffer is currently used.

It's not a lot but do we need multiple buffers here for all software
compressors? Other than the hardware accelerated compressors,
compression happens sequentially, no?


>
> zswap_store_page() is replaced with zswap_store_pages(), which processes
> a batch of pages and allows for batching optimizations. For now, only
> optimize allocating entries by using batch allocations from the slab
> cache.
>
> Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> page and only call it once for the folio, since the entire folio is
> charged to a single memcg. Similarly, obtain the nid once to use during
> each batch store of a folio. To facilitate this, a "struct
> zswap_store_context" is introduced to keep function parameter lists
> concise.

The wb_enabled stuff sounds like sth you can pull into its own patch?

[...]

> -       /*
> -        * We may have had an existing entry that became stale when
> -        * the folio was redirtied and now the new version is being
> -        * swapped out. Get rid of the old.
> -        */
> -       if (old)
> -               zswap_entry_free(old);
> +       for (i =3D 0; i < zc->nr_pages; ++i) {
> +               struct zswap_entry *old, *entry =3D zc->entries[i];
> +
> +               old =3D xa_store(swap_zswap_tree(entry->swpentry),
> +                              swp_offset(entry->swpentry),
> +                              entry, GFP_KERNEL);

This range is guaranteed to be contiguous and always belong to the
same zswap tree right? Why are we not using xas API here?

(Or maybe we can do this as follow-up/in a different patch?)

