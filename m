Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 887EBC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1836B00A1; Tue, 28 Jul 2026 11:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9B26B00A2; Tue, 28 Jul 2026 11:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC326B009D; Tue, 28 Jul 2026 11:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8AE6B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:52:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC9D61A042C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:52:36 +0000 (UTC)
X-FDA: 85038627912.27.F5A2079
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id C261614000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:52:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e47pL4tm;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785253954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wN2G7lz6Mpypum8G17oa0ZLQ38+GsCLTOJI2elJXgNM=;
	b=XugIkB4vZWXVDqFQQqY5spcKlwBKKB4WWnZJuFosJ1Sp160XC5sywnUzzMjBQefRcjMuAl
	kH7yE7glYjjU+xI06BkbQnQ1kTn8Cca899W5C+vLjA/LNpkt+YohQ+mhzeC66BnvvwqoT9
	6WMYer14OAVS3debUovKvBQeN8PPxA8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785253954;
	b=3tEd65Mxd+AzT8+SyogPM77y5sYqXpV2tw0yNgKyV0NjCR71erj8/cXlr4Lpiz1jvlunZo
	kyP5/ej5K5nMTOUadFeAK9SXLoZ8h64slOfh88jM/rnjaR9JOIstZLIRojFtIln9Dd5DXW
	aBWk4LONkWAsqYnVxryyHZdI5N8DQDY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e47pL4tm;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso20851515e9.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:52:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785253953; cv=none;
        d=google.com; s=arc-20260327;
        b=VN/Vk5/lmDA89tU8x1YlEfhdMkr3M7GLbPaoebQdL/zAleN2LOTfFbT3pCSLDpMkh9
         0z8yBrwU0jaF42+QihW/HSoH7zs9SAEyFAkmaASrlSiBi9zsoNqdaFJ9WqN+f1Wt48q/
         gF9QTzAKiyGDWMxUQygr4obBCyDNeIarVjfl/jpDTzwoHQuvaun8GlPUYPk2KkRKda/v
         ySV0W9axvvLmlIKLW8zCZbH/1sDoOOze525K9LMMwb0C6n3ZDMi71n/uptLtqYekHqtJ
         Zqyv7TtsEbAbs//505p4D3fcPLyOJnzaqlCTgmmIb8tNx0YGQ+WUJu3QC+6Z144EJ7uG
         c6xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wN2G7lz6Mpypum8G17oa0ZLQ38+GsCLTOJI2elJXgNM=;
        fh=LlmSETFKvdGwTLEe2+HhjZXyhQ6Az0TQ3/Vq7kkvDRg=;
        b=cFYrFypqKQAu9fWs0JyBkXnXazjTpFImSqBaQmLsh+qvshxbzZLad3gdIrniA4w5N9
         qMRou00ZflD+SV8mqAXCOG77pKvten87oID4AhuGkz/W+q+z47sdMPs7ZjqGNUAQ8jxu
         0K6ZaEK29KmB7Q9oJ/pUK398v3tw3SeABgVhqnupxYY9u25DKwZ9QGlqz2pnIU+WIcHx
         GaHnlwYeyeZUYRT0ryHo8B9ytad6kvwz5whLq+rkQP9+5uQgcVs/X9ePBUaWr9qglM2K
         Jw4v5n/chFJM2E6uDQshFpkJTbOeTMdzaYLmJsnfA35QnQy85ODPfJTNBdXRbtA+B6Tf
         cuFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785253953; x=1785858753; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wN2G7lz6Mpypum8G17oa0ZLQ38+GsCLTOJI2elJXgNM=;
        b=e47pL4tmXSJ7cldg+T0wK1hWhkAybR99wbpPGOkbqGKI31Fg15/FldeIw3jkH6Xm7U
         XtV58J0XgymdNKZ2CbaZ2mOTkAfMQe6I8k9oxULEVjxgqp/KOlBBtuIMOYLg+3k+Yq/E
         p12XL4r9Y5zC+m1mPa7x+EJvRvVhxD3gBN2/VzPdHU/K1037Cfr53tcXQhI0uu4EGbhw
         Vzbs98n9cRUzcuSD7POsKvgd+u8rmY3XmM17FmWKwpkpKpcIEP/b4H5jJeuEE3R5Wsgc
         HqN/fceQg7PwFQ2iM1io4GhAqrh8BOwMc3ADMLtYNDnXk7gERwvjVXqkQG1ArhtN+IvC
         tgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785253953; x=1785858753;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wN2G7lz6Mpypum8G17oa0ZLQ38+GsCLTOJI2elJXgNM=;
        b=DR0TkXsvXVYBZetbLNhaN/XD20YJsMeu++piEmbWLLsy6iEbeQjNNT280ITpGWkzA6
         gKfNIhhj0TurdYKRNC8NU7EB4ZvbX42e+PzCatUqg/i6TJW8aT0u4LZ/OSaC909+ZafP
         T5xlKC41uFx8fmd+LkFag96JrPloIPoU9tm/S1ePVKu61rxionOaUrYqBq3u6q8Wdsjd
         hFP20vDW/YIvJALdDbGRP+BgCxUOOtPaUgaRJUcgImunfkMKuSova6i8caNbDZ1M7lAl
         6DB7f25hoirEcIGQgQwj9egFZsIY0pQKXsfwQTN2jMfHLcrDoT2XuTDARB6MTq+kMFF/
         OxFg==
X-Forwarded-Encrypted: i=1; AHgh+RoTTfrmNc5Tb+LCniuF6c7hUEtOmlG27qkVaxhh6IVmuHPR8L6lWsGO3mjVV4j/5U8UhG0hRM283Q==@kvack.org
X-Gm-Message-State: AOJu0YyqztO2Ao66RZlk9RCkiQkvtvnslfUuNXXtNpmpQ2R5rFxVho0X
	Ghv3Oiple0PmWm8TxM4cgRUfJJDvhiqwuWBUprEMyaiggQM3TMZXbUkV2JjUlXq5wDDetqML+Eq
	vi4na90WM736YDl+0L4nSgWD6ZPnpXEE=
X-Gm-Gg: AR+sD126qINjlfcoI9e2j8pGuDtnpGpQCpAD8AajJqsDSGYxPK3ceLpNE3xBPJmWVtU
	7/diK68cmi87Jjz62oOnPbnO7aKzkOfLmyXIH4Tgi9V+CS9Yt+M3S+FndIHGAQrL5ytT2pa7DtI
	uEMhjoNS1hUdbbh4IlLe4ruN/mUPtYvlbHQL1iPj5La+3svXfS1WRBOgBeVSQgB7hdvP5e99bXU
	i9SeVWDbsK6e0PAOhKu6gyn+AB5Qzz/fjuTv9DK0yxKcWqe+L1vchhKcgXZBACZyoEHVi3yYMnT
	J/SqsqaLRZKH7xvMfQ==
X-Received: by 2002:a05:600c:5397:b0:495:7505:cf1c with SMTP id
 5b1f17b1804b1-496c6582ac5mr33435375e9.28.1785253953161; Tue, 28 Jul 2026
 08:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org> <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com> <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
 <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
 <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
 <amO-hwo8OGV5Goz0@cmpxchg.org> <CAO9r8zMgVmgQET+PUGexAgNqCZavA2YoTTXKSbWWoUv=A=ytSQ@mail.gmail.com>
 <f60fe501-7605-64dd-0572-77f7f3060f35@gmail.com> <CAO9r8zMBWA7nxM24VXQT00CVEZwFpMFNe73FFdPSZw2y=J-0HA@mail.gmail.com>
 <7bf9384b-2999-f14e-f23c-0df93168c20b@gmail.com>
In-Reply-To: <7bf9384b-2999-f14e-f23c-0df93168c20b@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 28 Jul 2026 08:52:21 -0700
X-Gm-Features: AUfX_mylr_CmpdKtioYg-BSNQdMzZqObAnINeR7fFIGQIDfPAIPOo9aOIcIXh18
Message-ID: <CAKEwX=MObv_nCfRUTwa1HDxZEdoYLWgkp2K1s7+P+REB+v41RQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, 
	tj@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C261614000C
X-Stat-Signature: ijiin4niuaju5c7twbjxchdajpn71equ
X-Rspam-User: 
X-HE-Tag: 1785253954-430483
X-HE-Meta: U2FsdGVkX1/QAcSvbuIsWNE1hyYAmBjlUPnDHmSTmPtwsl5D8a3tMxfKB6bO/0Mb1hMdlOo6Y131JAoRPSeyV3kPrkmAcqfV+aQS5Xpr1r5zs1EqaNPkpoBccAPSGuPQGOcIs7UAFEglQDpt/+qDcuEPexXDy7isrObT8Ps9BJu9LAKrCnKId9X7+yo0BZ3kKIzbIl+wOnbDFyOFQWmoIYkz+6/Zy1eaiervUnnjlXhBVQj/SNrdGO/U4Jx0mEVglPh9/Sc2KVEzt8yFL96klYKMt2tMyd9x4AK/T/2AApM6NmKkMoD5EHOvdExZ2l+iMSUNwwDGAYtnb8FGzly7+TXksVN8qYA7ClkrmPQ6v26Hh9dclfwOcMFfMlPtJNnUJmKY1ShN0nGhIX2XgL0PXGlaTn8cSZzsgM5N7rjW8038AUDZg9z8Owhp93orAJXKEbAoK5Q5FsFi83eMhLJEM/qOdC6oqBJJnnE27LYkiohlEjVmXq0pdvoEUVEw84eBPdIo5uCFWru70vxzAMFnDBfbeDeVtIXgS9PMT96MGm5PPHQcaP5GFJntjQUuqN4oy2MUt7rIkX1a78HPtz46LTPMXfSngwyLBif8VFY5MYbMjoFHMoOil9EcWBIZgpwJ9GWW8IdzGyzN22M+F/FuFNNma5bBgNHNv1AyiTlo2bXh9lj59JR3ckc15k3pHMJyrKirIT8XKHPX0HrQCu7FSvTVPv32BbAlDav++CEhiRrovcgLd4kHUT/nGma9NHrcE7OyEFROSssWXJ9tuy7ac5qcVg0HO0ZrYQujIawA30M1/jtU7+pkw5lpamUt2AxsFtTi0pVe19WyClx42fkuKbI+AT/NUAJttwf+6Pg1IxaRchukrLan0LHtvq2XmsVZXi0hHGrbNP3mEVvFh8I6KiD0Y39j5c6qsu4Aw7BGRMVMM+xbnlJyCL9AhedXCmILayHAIf2C8rA61ZjjWtY
 33IQT+Vk
 K9xY1HyPU5i/KR//LXqgkXD/aQ6Zo5q9rkkFnRHrt2e/BDd604WssScLouYEyL88VDxIXhKCbx5r44sWB6wBLveDGnPOpzlNqZnRPFWjT50OSlUOVAq2z0wDlISraSDfdsU9D1ZrRSJIcu7a7Oydqel/gtvZjeA8njIhi6jlX5n9K9gRlpLDVkijJWiQQD8sV7RsQSVIkQ4C5vbL4HSVTH+LI1xmUNlARfu65PB8wrSB26goQcVewzgypU/k/4KjcIJSlMkKi6J0z8EuJ0qjgoE9EwSRURnOxuKSxQZf0pM6Yds6FRoxpmKtqpz06K+X34/SDm3GUExlbB701yF+kT7DGDRm02BpsbA2aHWYsd5XmLiAh1ZwtrB194wSCp0KQZVTR2ew9OXPA2smwnZ7EpUtHy+BjhzT6+c3vdRYdjXyPqqVeRQebHGLQ3sN/bhwMbVAJ6yfvUIBFCKBbZxa2tbMDXsId9XEqNebu3YA2x+JEIwxhf3j+w5I40jtHmgTUig+m0ewIZCOkyTYESzLBF3nveCJhjwHXcQ3Fc3C6lN6EuFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 4:22=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
> On 2026/7/28 00:18, Yosry Ahmed wrote:
> Apologies=E2=80=94there was a flaw in my previous test setup. I had confi=
gured
> zswap.max=3D320M alongside max_pool_percent=3D1. Since the global zswap p=
ool
> capacity was roughly 314M (< 320M), the global pool limit was actually
> being hit before the cgroup zswap.max limit. Both limits were likely
> interleaving throughout the run, making the results difficult to analyze.
>
> Re-running with **zswap.max=3D280M** yields results that align with
> expectations:
>
> Test Case: zmax280 stress-4 pool1%
>                              baseline        batch-all32      batch-all64
>    shrink_worker wakeups            0                0                0
>    shrink_memcg calls         698,990           57,187           29,649
>    written_back               655,570          865,131          883,508
>    store succeeded          1,054,928        1,124,990        1,190,608
>    store rejected             229,722           22,642           11,659
>    store reject rate             ~17%              ~1%              ~0%
>    reject_reclaim_fail            110           15,454           12,985
>    pswpout                    885,437          888,027          895,478
>    pswpin                   2,035,415        1,305,341        1,384,751
>    zswpout                  1,054,928        1,124,990        1,190,608
>    zswpin                     280,675          162,684          158,556
>
> To isolate the cgroup zswap limit, I also tested with
> max_pool_percent=3D50 (which should behave similarly to the zswap.max=3D2=
80M
> case above, bounded strictly by cgroup zswap.max):
>
> Test Case: zmax320 stress-4 pool50%
>                             baseline        batch-all32      batch-all64
>    shrink_worker wakeups            0                0                0
>    shrink_memcg calls         687,608           54,002           28,116
>    written_back               639,176          846,663          862,347
>    store succeeded            992,816        1,208,123        1,213,286
>    store rejected             231,431           20,425           10,915
>    store reject rate             ~18%              ~1%              ~0%
>    pswpout                    870,745          867,360          873,553
>    pswpin                   1,707,823        1,216,814        1,378,381
>    zswpout                    992,816        1,208,123        1,213,286
>    zswpin                     250,220          210,791          185,716
>
>
> Finally, here is the dataset for zswap.max=3D320M and max_pool_percent=3D=
1
> with a single stress-ng worker (stress-1), which also looks consistent
> with your expectations:
>
> Test Case: zmax320 stress-1 pool1%
>                            baseline        batch-all32      batch-all64
>    shrink_worker wakeups        9,279              980              557
>    shrink_memcg calls      14,247,647        2,638,751        1,465,915
>    written_back                 7,702          439,809          482,809
>    store succeeded            329,603          531,224          566,150
>    store rejected             883,945          517,578          482,644
>    store reject rate             ~73%             ~49%             ~46%
>    pswpout                    891,647          957,388          965,453
>    pswpin                     692,255          628,246          582,781
>    zswpout                    329,603          531,224          566,150
>    zswpin                     248,871                3            7,872

Shall we just go with SWAP_CLUSTER_MAX per Johannes' suggestion then?
32 works the best here FWIW, but seems like it's all relatively good
(as long as it's not 1).

(I wonder if this works well with your proactive reclaimer too but we
shall see).

