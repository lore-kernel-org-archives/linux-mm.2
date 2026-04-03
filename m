Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F4FD7308D
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 03:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3C36B0005; Thu,  2 Apr 2026 23:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455156B0089; Thu,  2 Apr 2026 23:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36ADF6B008A; Thu,  2 Apr 2026 23:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2616A6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:14:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA086C1868
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:14:19 +0000 (UTC)
X-FDA: 84615776238.17.6F39298
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB9ED160003
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:14:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DVqd2ugt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775186057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjuCA5EyuG86gFxLDox8xz+38SgKGb+1fMuVvb5vj0E=;
	b=XWUzVGXfjy+D3TXAp36BY9jsyE3i6LpK/6WNYmDymAz84gbZuVZ3Suy45PTCYVH3V71gdP
	/9Xt8uogufUDZ8WIo+J6CIt+ZuRWbefB05DHAAPyYJxWeleWvU2wX50mRxGQUyJZFOgFRu
	mYgYdgsK5i+Y92Ct/DDtaYBVC90mAgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775186057; a=rsa-sha256;
	cv=none;
	b=5OIk5uyFBQJtE8xJQcznI2+tDrD/6+eQBGIe/RITg9+7q4qtN8lCeRVthyKe3VR82ZRi6f
	VcRsI16hflOWVmgdM/wbFIcRwyCVYVR13DKHnHx8islZFKQFaix/O5Vzr2oufdYotQh2SE
	DjxQ81K57uJ9fT799pP24vHlbnaWnlY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DVqd2ugt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-82ce0a9b3f7so691522b3a.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 20:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775186057; x=1775790857; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjuCA5EyuG86gFxLDox8xz+38SgKGb+1fMuVvb5vj0E=;
        b=DVqd2ugthuMoxxPiw1VpymEnY9ni/84DYKGd2zU+5cxEqGxxROyB/rhcMySml7cFkp
         C50hJ+314nXJvhpH31T012AMGM/2A0SZgiXX+kx0VrPUp9mLvWQ0Eo06P40u3tiIcqFV
         ceutII4BHLJf0TNdmvyLlCpmtGazOUrlAwIp2KYFJXrWqdN1Ra56JBFaYxO1hylwofLp
         7HWjiRltZlBEXtbV8sV7wSoOpzJWtLOPtzftELEsN2K/hhE9MIXqDfCJ7DSRdywrwVPB
         7yvnHgEDSKklk5zd+cgoczz1fsbEL1xTlOJmlSGmy3bxDTBLtmwvzcJLBgfQ2IlMgO1m
         CFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775186057; x=1775790857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kjuCA5EyuG86gFxLDox8xz+38SgKGb+1fMuVvb5vj0E=;
        b=JRtA57XiJxgNeDjsmf5gCj2m+kAD8ClzHm/ssBxwulVy+3/kYKPRVuy8mUp1Nb/FEo
         YFvI9upiXZla0Nh2+nbrW5GTjmBnQCLy1H9zOKV3eV+fM2slQURU8+Vu5U7WGLqELFOG
         sUXbRI/QLpqxsMvK0YJgI0niLqqt3YWXNlUqG6D1d9n0q3vxdXXJJP9FGDdCSEvcZVaF
         Pywqq/KfykLSWUa6gZTLGcznAj4OVvobyMDX7TNYI2UbBk28/ZTaIE8QOLUzQL+1iuzW
         nqrAo4jPKtjogAELYm67EufjNNhS85as5DNZNSgekuhL83Loxf93M7fXP/QcMfBV3w/j
         guWg==
X-Forwarded-Encrypted: i=1; AJvYcCU3JkruRMwfhtm06eIYRiRAOtXXBbO2QfRsqXJrCCVGgiQDOpRL561i+8j8B9AV9gg/jHfRQbpK0g==@kvack.org
X-Gm-Message-State: AOJu0Yx4AcmH62PhkAy7PkkEyZgKZ2LBgtER8OOFOwjdT0vW2TdihTxc
	uyjJvi4VoIuR7Z/IjDfuklu3H92XLO88xdmdtykVMkyNIhNaUw++pu1u
X-Gm-Gg: ATEYQzwIgxB1wlVlwBjEcZfKpgZbvo+XUQjkPPvwWzbDaIlUhRJiysUATC8mfktoQ43
	pEcylBEbwt2Q2qd7hLM9og9iccpXZh+XuJf79MKIvJ3Xc0fvV84cUqBaJ3X0G5PgYvK5jy9yOAX
	+AdaVZXvzIMRKgXo2SCBjrt0Fw7xWiwWovJZgduJEiKogjwV+U/RWjWLmB9rt3/8I8OokMNeY8A
	lg1tAx1Qq4Dw5sCvfyyeMl62hYYdtjwvZPDGoTqPBjMFTGgGb3Q5o5YaeRV5a/CFMjSfpPQmmm8
	mH7HgKR4HLN0jYRd9m8phzDzyh69V06xC0oKdSjHjzW0zQafeF8eZgNIa+hx26NG411V2Hzd75+
	/3ej+FjnKnwpd8b1/q+pJhh6MohbfCnShQp3pLuFkGTUQJU1ifU0pqOyUQDgIfYK3DgdIJFWnUd
	+IHRSOnEHbAJteC32+djpaBnkKTps3HFzcnOa+wTgdbjXfDg+kpg==
X-Received: by 2002:a05:6a00:3902:b0:82c:7876:a027 with SMTP id d2e1a72fcca58-82d0da8edd7mr1326298b3a.18.1775186056528;
        Thu, 02 Apr 2026 20:14:16 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.223])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c41a2asm4857141b3a.37.2026.04.02.20.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 20:14:16 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: urezki@gmail.com
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com,
	wangqing7171@gmail.com
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit-value warning in decay_va_pool_node()
Date: Fri,  3 Apr 2026 11:14:09 +0800
Message-Id: <20260403031409.2038306-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ac6PKPR8vMlIUdwT@milan>
References: <ac6PKPR8vMlIUdwT@milan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DB9ED160003
X-Stat-Signature: ror7nh6q5qzcioxa58ogccpbfdepphck
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775186057-892271
X-HE-Meta: U2FsdGVkX19sflMqmK3rK2FXR9LLKXFsZdsKxhyQK81tH3kJBERtlShzLD+3XbJxqIn++8ZjyfMjgFsmE8KHKsb/cenHg8gjcNgWwZnEiMoRpkRtMDK8yi5Te78peByExzfMJ5eQDQS2gU/YJyXB8jBpmoN3dfAf3xqsCMewiEszrLuXel8P+XuG4VbkslUlHH8ih5b0fjcxSOla8Cs2iIvoSulpAhkNBMEso6p5feeekgJuTncymWt8a6BxpdRndc63q7ejieglIuV1w7waOcpZz8tSEIAW6j+8/Uxw+LgAPTeww1XDYp6BOFB2FJf+Pto39YbiDuShypNTF1w7+s+Fp2YsmkgES3nmDmCGfLyS6TupEe9RPBd+It74RKQkhgrVNsNXS9lJDAQCmvNwNbuZl6/y5o/D7X+Ez44Z3hVX0JABmziRaXuQlo0E+NOQymGo79/rK5LkJSQAkr3bDh8vma4GlY/IiVqjzJeOxzlg654AyXsA8JvfTbgoOFVAbWr4t+Ze3z27eIX5889SNvwbob+W4GtM96Jri2ixw0T7EHb0CtQdRYaKbFUaweZaZ6iVx2WxMMwk6kqRl5IvFRM8Bj7E3wDmaNrP16251L6xJzQC/I6B/Eu9Q5XNlnSqOz5p5ONk1uY+8Is3aXuzy6T4ps5lTTKuI3+ntn4LT8aubkKsrOCzEXLhBMddYaZVUcm4CWlMqTktGp/OMmcBwWrgg/XLUOkiAVockZv5G22tUFe8GEI/0swoLmmPvuhzzA8hy0ndqDKx+c8i8zOIUakRNy+T5srpjizAFj2DFJ//7H9as0sVcYM2MaaRJyyCbUd/VB6b8tITfR1zoqfN+dqEPkLBZ4QeDpcHHAua2Ut0J6Qk+QySkg7TWzeotNvtn8rHWcFjXovfCb6kTfCiF6AD9SbuxdRQhe9nchIxyVHQIz5SfXYalFhl1KBLG48osEUOHwJamsAkdSixdWd
 DHAwIKG7
 rEK/lc/YjLl+JqZelDxcAaiU++tLOMQgk9QOiXMzx5QwFJcgbOT1DnUEzIm7h/yxjoggrZXq5TMOzgdZCWLyw6oBnlKXOMcAuPxOaa4bnrROcLneSk72NSeQInFRREa7Uz9HbWeIc5byL/hKD7nIJHBYi3Llr7tWBnZe8JOgitd25mfCB/mU/W/PXc7zB43TfBNnZ1t0kIWadfyO5FGM9xQu1Bke10ZvrFvCFmlcuhZPT0+nWdxEfJCo8DQNfyqLpHEowRpG64tvFxRJADRbUNMdwToAlAdq/9HMA0Q9BTBcSwGX4a15AGxPOz7LJTYS4T2RT4ftAWwp3exQZKLoDVMazi+AgqSeN5uPP+u9Ixfx2wF4dP3q5/JLi22+jSO4RLXJi5PoZP1zXlDZbmReAqzb1g3xH+u+MK25X12mAr56AKYEk46qzBKDZ3tScA1Y/BGZ38GD84siqyOkEOFJT6a1OnM+ztYRkrusn/k+wNFJ25hUAEcU14hHITKkh3uBab0LNtcKndRAoq1p01bMnttNR76XyPcD2VHijKgtGvFtt19BQtQly0a2ra/MvreTxAucKkhbm1grRkN669WiDIrArvjtV9x3nALlvFfpkFVCG/uYwNuowqlPLuxTdmSsLfInUl6eDHRvD8COjezwQWZZJZ+qVDKOVxT5aE2JmMghFhtn9icjE0b8Euk82WS1FaIVe2hnml1U2+Khjf4BAFTxg4uT6DbzNQk+JwdHXacRHxZxGsBVMtuffOsFGAOVcGekE4E/7568MZ+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Apr 2026 at 23:45, Uladzislau Rezki <urezki@gmail.com> wrote:
> > KMSAN reported an uninit-value warning when accessing vmap_area->list
> > in decay_va_pool_node():
> > 
> >   BUG: KMSAN: uninit-value in __list_del_entry_valid include/linux/list.h:-1 [inline]
> >   BUG: KMSAN: uninit-value in __list_del_entry include/linux/list.h:223 [inline]
> >   BUG: KMSAN: uninit-value in list_del_init include/linux/list.h:295 [inline]
> >   BUG: KMSAN: uninit-value in decay_va_pool_node+0xf78/0x1dd0 mm/vmalloc.c:2255
> > 
> >   Uninit was created at:
> >    kmem_cache_alloc_node_noprof+0x3cd/0x12d0 mm/slub.c:4918
> >    alloc_vmap_area+0x327/0x2e30 mm/vmalloc.c:2065
> > 
> > The root cause is that if node_alloc() fail and the va is allocated via
> > kmem_cache_alloc_node() by alloc_vmap_area(), va->list will be uninitialized.
> > 
> > Fix this by explicitly initializing va->list after allocation.
> > 
> > Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=37b7f6cd519f7fb8d32a
> >
> I can not access two above links. Are they valid? I would like to have
> a look at report.

Try to it?

https://lore.kernel.org/all/69cdff26.050a0220.2dbe29.0001.GAE@google.com/T/

