Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B030FC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9470B6B007B; Mon,  3 Aug 2026 09:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8466B009B; Mon,  3 Aug 2026 09:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FE76B00C0; Mon,  3 Aug 2026 09:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57EC56B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:02:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AF96120680
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:34:46 +0000 (UTC)
X-FDA: 85059599772.29.5C35D1B
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8D0EE14000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:34:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LPS6MjYN;
	spf=pass (imf23.hostedemail.com: domain of 3wm5wagkKCLsbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3wm5wagkKCLsbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785753284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrGZH1Bic7OrH5NVQ3GPF6/SmqVayjDt/OQQQF3cjOM=;
	b=GeruLltCfiiVqqmfbQKWcH6lDct/XRGBExei/28t0o1PRNofDjMGGxjq32Ah0ovYCbgoTE
	zYCBB4FOTPhrbCHfxS3IqrIe4GqXLv1P96dIIEmXCu2oRfOnDMgcwFG+0jy4aLZkoX5BXq
	C7DUQIAAUJ8elfhJXu/I/0U4CgWc6Ko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785753284;
	b=hT6sDk7JBe0af34x9v1y+dj2xH5qs9Yly5dy0Yg9jEjzNcCW0ooiBzZ8sACbXaLcNasmDC
	2jw/S+Zcm9g/WntmfYnr3r18lom9liAd/SOO32Z7Gj6zs64SATOFw7DzQ4+2BfoY2gqlwo
	sac86l9TbiylYSSnZjAiECDub0ufyN8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LPS6MjYN;
	spf=pass (imf23.hostedemail.com: domain of 3wm5wagkKCLsbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3wm5wagkKCLsbmjdfszimhpphmf.dpnmjovy-nnlwbdl.psh@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4957287363bso12599945e9.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 03:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785753283; x=1786358083; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nrGZH1Bic7OrH5NVQ3GPF6/SmqVayjDt/OQQQF3cjOM=;
        b=LPS6MjYNNZVwqfXJE5PIYBGSnllCed1IIYy0GMdtocIjSD8Zd3KD3F3MIirVkqvQWx
         HYL0mpkLT+OluVUN9PNzyu3rp2qzEMYKMl5k/5gQ0D++JR9m1nLffbUECvIjGyvh7yVm
         CAKSRw2sNseYijo405KdvqJcoyloH8hFyAwnlGuMK2qsqpBnRKx8PkI3DLab3iHXxyOv
         GJu9Uw0I6Eoqz0tWFAFiNvtAeNVe2Xdb2GwIcnOYGRfCiyclMznWTt2Hc2IiXmA7NizY
         fOgG+JErsVGBKZe40SFJujyK8U+K/ZIAQW7bKSpmg1kJMct8yz4YDWK8LNHKK87vhrtm
         eAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785753283; x=1786358083;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nrGZH1Bic7OrH5NVQ3GPF6/SmqVayjDt/OQQQF3cjOM=;
        b=mm5CWyNt4iInuVpfSfo07ZPdm6KHiRh2pgYY4LdValQTWINNiLHftyCxNpAKg2TVEf
         U7fYw1tZB5vgdU0bTnog7/LpQ6/puHF4dFgmz+XR+WDpxi7GiJVDOSP2wuDsjO7V2Odx
         BtHoy66OvHBr1kQlc+ktFrlFeW9zdY+N/aw9whoL8THb/f84LRN0rZWHzm4mHtGjD4WS
         bBCsAiF4OeVxY5ovD15Z6j442JudFgPQSrCekXs+HJmkUN2EAJPdDDAKLgT1+lf7NfvU
         ejXp3SairFRsw0Rs7T2DMBbC+To3fcISKDMtKhS5UMZCNbwnrvg5d6wKVtWeBqskqKBq
         lopg==
X-Forwarded-Encrypted: i=1; AHgh+RoB1e+GtVkvfHKO9ZIPG4ooCq+k2hs8DCFKmgj+UDQBS+Je2xpdMIidUMLzx4DgCT25qjKCidejtw==@kvack.org
X-Gm-Message-State: AOJu0Yz0q42uKCU3SkTLc8mzU6Zwb2qmw8hndtp7UCd6nnPwyLgn5kAp
	bC5tlRxhj5zYM3M2W0xY0ZnQtyA5p3Tb6rHaxdnkmBwRFNmLys8mFZ/rWKZw0igl6mdig3QI+wx
	vF6UQRBoSZ4jUF8d0AA==
X-Received: from wmaq1.prod.google.com ([2002:a05:600c:6c81:b0:493:ed72:8dad])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6092:b0:497:ff28:6deb with SMTP id 5b1f17b1804b1-4980c64b8bfmr238017025e9.11.1785753282903;
 Mon, 03 Aug 2026 03:34:42 -0700 (PDT)
Date: Mon, 3 Aug 2026 10:34:42 +0000
In-Reply-To: <20260802215459.2769283-5-surenb@google.com>
Mime-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-5-surenb@google.com>
Message-ID: <anBuwuiOBKXJwnhT@google.com>
Subject: Re: [PATCH v3 4/5] binder: Remove mmap_lock fallback
From: Alice Ryhl <aliceryhl@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D0EE14000E
X-Stat-Signature: d987j7zjjt79hf4d5fbtfk7my9679xe1
X-Rspam-User: 
X-HE-Tag: 1785753284-892911
X-HE-Meta: U2FsdGVkX18fotXN2HJOmBEVJbAhjoQ24jWGFskEflSaovqy10PUFMZlIej5Rt/tnOvfWVn5ZYcX/zbmXtRL0zX1pUVA9A7XijiVuy3GgggS9/RbUOCUt2re99V07ZWqVXYdy7Ws5qyk+8WJpHD6VxTu2hf8x8jMV6vTtyjOvqbVzYSP601koE6a3t/eIfIWdyYPfPZvvV4Eit+AXh4FEbC6xXmrmoOFqd1YLokrcejK3BT2wSJSKkvFCwj6DVLsDluDGjhzWbM0AqXGQSKs8R2JdBnpXMHvm+6loE5WD7xjxWKkltdVaO1rqF0vL9EInjctway5M5QvI3jkh8QHSC8iPo83Ii4dHJTFjFfx11sUd11eT6t/POFaFoOwlBtzhwPenij2y6Exb78du9YIEo/B1j3/MKZ2xuT2VdsS3QsI0FarXKgwd1OQIrpb4G1Fc79pw/IwXdpzQclNgNGRNpbKhBzQjfcPesWHq5wrLFZdondgjl5vAqBaSGC+fgd6f1sDNwS1EQ5uV3NN69bTrP5uxxMi56rlcmg6CaqeV20otWEFNW8q4ajDcKnJVCqtDVTaNrP4Nmn7ghjONGGOa7xqeAgwr92tt1ZViFae74QEMcRxjVZa6e9yjT6BlUiv2QvgNipI+sALVQwrizZAg/l1AvXlp1vzPq/4q2aiVIEP4WSstwnQj82fLJ7/jR9NX/cH7zRydjFWckveTcI7AA+Z7SEa2/mwcTyPEmLck/XfZCIk3pDffDUUJxSTWcLKJUqp0iVIbVlKdeu66YPvwSH5jsJrps81TUwdlerZGLX5BSGsOEdhFHNzL/vadgBQgJKRQDqQf6QDcPnuoz9pghdXxpFb+7UwQ6EUPAPFOZJgFSC2Uj/M9B0KEuxw6MtanCqrcH0xQI3E6zyCNUXZ6YUVZugdHbO0TAUvQcT3Ypkk3qlpI071b0igg9zi/cfQIObyPt5xLoHt90qrHi4
 K2va+sO4
 KFCR+sWFzu/N6s/xfxD1+vgpU43PR4K40x/tuqdVtyqv3XOOxLkxJKcUEdOZxOkpkiblqQtXaLffAIiUYr49k51fyAYNExErVKN5/bY0/gVhQNUu1Y01sqiTcidfATfysyTzn8WIIprtuabLxbnE2VIcoFFCS2owTgi0RKQllIs0Iu3NQRZ9L/KcSaWsdR6FEVpZhlSeKtjOHmeHDtAgr1wwxONPBkluVU0XToBEY1wqrGQ2WxbJtUAJXpD4RB8Brp/pkEHFbfsXs7khjLOdCPwXyzKrd0Usd70aZ7kYbYrtsmLpvJghXO+uth6D3C4Tt0qiGY0rdhFP+raBPcrcBgpBp/1cgh0MBHJBTOxSSha0/Bl7SageY7RXfSjJpOoT2yaMBtzOYyfAobhGmXlOhflCxjxaYuFvWRNtZZg7IzJ0MVB49unF597QSVrlBXXps9rgrHNqRjC8b/r1N4KZl7hYA8IIhBwF8xMRC6WYwk/f+goHdfsB6icqApz82Yqbi8X7o0L67OL8VpwUBo4xbuQafgid0Xf6JSaxFeogEqL/mWG4YTVArSgt4j+CZRNkpOKFXeHRQe4/KkiDB+sZZCF3/9XKhruTMFn4sm2WaoH42zXhhMAbHxjYuJxNp2SFy3I/5ETfBLwhMD8e7OwwoVQ0nGtqrfp1wbl7W3JyELh2Tbq35q/OKLA1iqqmOlHamLClOrduC5VImhJnQ/Kmge0T7KSVn0XVvS87HLx9f7BGb1pCggQdwPu/a0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 02:54:58PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Previously, the per-VMA locking could fail in the face of writers
> which necessitate a fallback to mmap_lock. The new
> vma_start_read_unlocked() will wait for writers instead of failing.
> 
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

