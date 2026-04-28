Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01032FF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 22:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247476B00A9; Tue, 28 Apr 2026 18:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EC56B00AB; Tue, 28 Apr 2026 18:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15BDE6B00AD; Tue, 28 Apr 2026 18:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0510B6B00A9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:50:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 436FF1B99B9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:50:32 +0000 (UTC)
X-FDA: 84709460304.11.138F0E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C2B51C0008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:50:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKjTBMmS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777416630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCa0KY9mz1aMkBQSjAShMGFCiJmWkS0c9lMLhRYIbgI=;
	b=6Pwumy+vkqWIqe2iyS2DlVg/6yRuiqvcA2Hs+bJIDy9bsi+ENOP1XFO4GmkiN702PecCpN
	n3CIV8gynzQbhDG2n4I17uoIB9Hi52vSqtTw/kK2xqa3ZhXfbyoPZ5LXP5LEh86W+Kde1K
	/tF/VyAIsgzwb/i0LjqCJg+H38B1leY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777416630; a=rsa-sha256;
	cv=none;
	b=joiiYSpN8yjfQ2hr6aHz3wZxHoMK5YL/oZjs3F3ztqtDK408ZblEThJ89tvAXLi+7OZIzP
	qY+x8apbLDoBbBWckAMpmFMAvCbYAp3sUjKSI6okyn6DrcfaBTP2taxIi3s/k58Ow6jOSF
	j/Qz2HrE9JatSfhKxJhlghtPvVHNfwg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKjTBMmS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A91076024D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F390C2BCB7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777416629;
	bh=xK+ws1OXrjRWpmDOBWFbZJY7JqxNRHyTcDHSwOPvhlA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QKjTBMmSNV4YA/xFLzFcbTFl2MAKrVm+RKLtK8/gjCqqIS9PmVRd5OCTbqAKBUogL
	 xnmCdGlCC3pKJCsmPP/OQa1HKJLVJyO/Z22A7AGEDmyKR72kQIYTGxp9563OO9PKbv
	 zJRqwWgFzKfcgo95b54n+b8qXyYGC7fls4o0r/ZqZojoxd/4gvPhDz7W71QjdPVnI4
	 1ftm++1A/N0k05zxyyN0yXRAP80vKRNfnWwEOPOJe398l1gL5aYghQW8MdV46jrZQ5
	 Y7WAM1ZQ5kjyHwOnZbzm5Zlo+3ty0z1vg62Glh14s3o6s/7clnE9WyMRv7E9S5uzj4
	 sRgUwxGLDB37g==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a3970f1a0eso126309536d6.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:50:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9tgfSx2030u0rer3HjwNhVI6WBYs3wsgzkRRdBoKoxcPM5oLl5d+TUZRIig3iuZFpoThQlMidpWQ==@kvack.org
X-Gm-Message-State: AOJu0YwLk2tqKu2yjJrt9m03/IDCVYgxGslrhPvKoTZLDbf721pygR7A
	OHi4lDM0atMdEXWEaoEC9JzHcRNm6uLGvB+3VkE3Ux5/LwGU7OedxqrUtAyv5cLHgt2UI/b2+d3
	1EVAf9OmGA47RFlLT4Df+Qerkdml+WAo=
X-Received: by 2002:a05:6214:5907:b0:89c:cfcc:2f31 with SMTP id
 6a1803df08f44-8b3e31d6f0emr80549666d6.32.1777416628689; Tue, 28 Apr 2026
 15:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <CAMgjq7D5M6ru4bP0EsNmyODnnAoPcpa4GSB79=Gs4EUabzsgXw@mail.gmail.com>
 <CAGsJ_4wsde+xZDBysLFBFHvkoJbM07b5tWS-rvXn9x9+m24s3g@mail.gmail.com>
In-Reply-To: <CAGsJ_4wsde+xZDBysLFBFHvkoJbM07b5tWS-rvXn9x9+m24s3g@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Apr 2026 06:50:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xt4RmuoyuRZGoWd52CFF-HqO7uskG15CJ7BMgL_FH0TA@mail.gmail.com>
X-Gm-Features: AVHnY4LnBF_O00YYO1LlfmLglNLwFp0OIn6Cpo0zOt2O-TX8lBD4_yeuuTRCzqo
Message-ID: <CAGsJ_4xt4RmuoyuRZGoWd52CFF-HqO7uskG15CJ7BMgL_FH0TA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C2B51C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: 6pgf15zih6sr4ghqqk67i3tkspd8yemn
X-HE-Tag: 1777416630-935766
X-HE-Meta: U2FsdGVkX19K/fm1c9Duj+66p37SGAGOVIFDitDugXuVJ6xCa4jPpsoifcgHP3WRF2dVtYjxnNHsLISPpS2cRdvtqM7lvyKqjqE7HuOZAkyi7DTlOQ7O6/GsU1ZKtjJ6bGP0OqcBmGq7rq9kxDVhPHlYvahQmJJSNSNikbEIQ48Pfkkw0wPI5T8HwwXmMdUnPPIug44aMT+PIk2suUIKziINgIA0qcExlxMQ+tIIXpM58hH2O7Zuy0t/3kJgsumZ1+N7vikFjM8kPpY0OYbPsw20wHQamsXPaZIIW4LsN9+VZxf1bBMVRR0JptarduTxleehP/uUODOb8Q2U8bsU5SXA8/wiv7dxFE2P+YJpBLYOrCyTFNLEby9Izeb2XHhBc9QGJ26+0SIy/R8pP9PDCf9/AyfVC5eiljZtFf43gPntsrSW9wTGhvr/QrsOsl3kHovOu6YMBQZzriIUHDn9pLiRKw/tnCCx3IxNCdMqB+zpcDynR6NAP4M4Mt46c6pC4jw0rDbl0PjbLjEXr9TVZvCJ3J7jL/g6hkpVuBh8BuESuYYGlrwCZUsNd3VgvfVB9rwQNzjmvYdS0GbtotbUkdk7+JQD6n4d7K8B5metLKE3sX/MlFGPKHMvfTpOXzvAZgrVH4oT2O1+wAXD3xBHR/aXm9Ani9FBq4sWYwZz/sI7j3HR3w8X/tunTcReQtsnUuQcpb4FtVmau4suJZuzB68GazSI5jsYWkU+yoSDfa3JSujK0YWAz5nAquNmGvqL7/w/9pbSkt8dzw75YnSROZdk6wetRU/vuN/Uxd0RRtNb6upq4lOBY4Rb3FR8B11s1PDqMEvN/U/horyFXf7jw4SfsRjLGszVGer51t1KcWYbkfDn5JMNiItRZ7OCLoADzCVV2CC24A/0lSX/pCq8LYN9hGzG98up+hDH/erzmz5CA/T0B+iGUJHMEssdTafOzvDrJ8/yTzKkB1z9+wn
 gNmBPRke
 YoDErEohvz9PSI9Ri4MBN26YZcm3rb9aw2fW1AoSRDZ3rYMIg8hUvypkYJy9bzfGgl/CYiz2QXN4ru2rDEbwCOG5elv/43YltrKp8UmerC4g0f6uy6wdfSWFdDKdQ60C6C+D9mMyh2ToeYPCqki6S9leyD8BNvmJq8wKN+rht9q6AYa6sdeGj4nBEwb8HlpUn7mzLbX+MvpBRIbTXMqis3lqCtoFN0mV96TipcearCHHEnxOumtCXAPcAVeZwDVEIW+GKmT8G8QqLdLrzPsAdRHOrV724sn3MQNw03hjnwCeG3lqMj01mNmVsdT7xOh3lWKFPiaN7+UoaojvFjFXVYdOgxWY52/gR8ltXUrHbVH0Kteu4LAOLXkWCB8HCwAPy/ObOJ1g3JXVneE8J4vnWen31ZWNIo278jBr+UBDiKISFj6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 6:26=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
[...]
>
> BTW, it seems we can also fix set_pte_range(). The prefault check
> feels quite useless to me=E2=80=94just let folio_referenced do one extra
> scan.
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..bee58a8fee0a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5593,13 +5593,12 @@ void set_pte_range(struct vm_fault *vmf,
> struct folio *folio,
>  {
>         struct vm_area_struct *vma =3D vmf->vma;
>         bool write =3D vmf->flags & FAULT_FLAG_WRITE;
> -       bool prefault =3D !in_range(vmf->address, addr, nr * PAGE_SIZE);
>         pte_t entry;
>
>         flush_icache_pages(vma, page, nr);
>         entry =3D mk_pte(page, vma->vm_page_prot);
>
> -       if (prefault && arch_wants_old_prefaulted_pte())
> +       if (arch_wants_old_prefaulted_pte())
>                 entry =3D pte_mkold(entry);
>         else
>                 entry =3D pte_sw_mkyoung(entry);
>
>

Please ignore this part.
I had a bit of a brain fart there. If it=E2=80=99s not prefault,
it=E2=80=99s a real fault and we are actually accessing it, so it
shouldn=E2=80=99t be considered old.

Thanks
Barry

