Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F0810ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA3A6B0092; Fri, 27 Mar 2026 10:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A15E6B0095; Fri, 27 Mar 2026 10:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE406B0096; Fri, 27 Mar 2026 10:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCA26B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:37:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25C7AE114F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:37:23 +0000 (UTC)
X-FDA: 84592095966.16.EBB1A85
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1CA9880014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:37:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DafPfTpn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774622241; a=rsa-sha256;
	cv=pass;
	b=NYz2KJW9byHjhDab4f2idc+0cj1BKEB1rKCXUxkIO0/9ClXww6V0wO6/RKtDo+0GvjMl3+
	TfQm0GNdOPeJKGOAjkbRZ8F9yMVKpcw+mF6adXSwyz0ZDqQLfXt3y9dIY3sz78rmePy2OO
	EuPyQkt4aCvtdAhDSSyBrXe0VIXJytg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774622241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xYgmMXOl9QJbCC4GUNiJU0syuEKGc9KS0/u4LFtR4I=;
	b=q19zIFfGb1d7Kb1z6vGoUn+AMCOuES3tcbmfNJqmhAUJt+rxxJ0KywANLoql8LZ5U3Jmq+
	UIqsj/4hZbnk1cZrWLny8423vH3H4p4Okrxhl7FpP/sNZhqO9ARv015dvElOaR0X6l6BSH
	8bWlvUXvNk5SdI1NWEO5Bc9O2YI3Cvo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DafPfTpn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d7e5e8c907so1377541a34.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:37:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774622240; cv=none;
        d=google.com; s=arc-20240605;
        b=YJt9QzoNXcg+5MeSNCaXOnJXhWnYyNt2AcARna5OPMaY+lgXeemmnodtvPIMI0xv/p
         dEZtI00nbQEG3DKeyLDylmU1V5uiM7iOxIdKaAO4ZZ5PcAHdXSeGyHqXkeOVg/yw7vqQ
         wxuxzm6onXJhuerWWqAUxIiowSGLuFTWQ9H7ypZ8kBKeGQwshOO/PdvhOGZmy8aAe0UY
         e7bYl3LGXxq9KyYMKPEHlRAmC04LJiGzjwCGPwwy/9OCg58nI6C690WSnVpeogSr0A9G
         bUnZpw6rApMn+T4ARKmFSu0Wq4/whOLZ4LuiKKFb7gf5r25k0+TFxJsvZFel/HMtejOa
         3LAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4xYgmMXOl9QJbCC4GUNiJU0syuEKGc9KS0/u4LFtR4I=;
        fh=1atwD4U7QE1aQlnestbDSmCA3Me7HDsVVTorYdkXguA=;
        b=lM2eH+ABDoxV8aGCPjDpoIepQXOcVKG4j8SLvN2CbZ6ILBpL/ZycCd8zLuKpfwG3XV
         35pyYBV+E04fpIITiHpx0U0+vltLOAj6A8Q3nDaj2IG/k5TxeH9BczxPLY42LrTKofVq
         TMHZDAzNWUMkhkOaML8FRNqQd22Xngn0kGpylrUejx8YRAbKaAapqGJuQMbNvbGJpEY0
         dfMy0qYcpxz/j3CiXT+uu+KCd8mPSPepaUDAQc7/qO81xMJYNj3VXK89emaIIbnuE0Vu
         y8VIAJXu0qwQwoTugwVlCelYvXpTTGOQg9If6aaBuibOJzTt+fFvjcQnDF9sLVeMnE0n
         Z2Xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774622240; x=1775227040; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xYgmMXOl9QJbCC4GUNiJU0syuEKGc9KS0/u4LFtR4I=;
        b=DafPfTpnxuIKtA39lWBuTwFUbtgvWMMPQyzibvdGZjtXCvl+BuwfqzVEyTqXeW6CBE
         5uL0z2qqSH8O+Exp1z66HMmo/sroTNzMvkY6/Ykx+k1pLbREEEs+FAgNUOal66a8QwFq
         ehHYO2jPhcpmry+4i37PhNn0Hl6kGh+RVCK/7g9FGoQuVfoDAm3CGMAAFTHXI2DcXaiM
         gpSaKi/MlY+D/xs8m+MX237HtdVmmgv4lKAQ2CeLik4+8SmUA6ZFzWJ1UXjUJJhDI23Z
         p/8YbGRUfOM4mnVP20aPaS57j+wJjD/mNeE9EtO17LWl8qV/iCFfmH1WXOE31D/BgXtm
         BQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774622240; x=1775227040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4xYgmMXOl9QJbCC4GUNiJU0syuEKGc9KS0/u4LFtR4I=;
        b=l8umpUSfigQpHDRay4jm5DjZKbNccnHAs9XElsbFrP40kxfys91uz0JitDrle7iufu
         1rHZGP4I81t23QuE565rvosJxnbkvSpv4eazk9FBNURMuY8Il2PbAPet+eX572+0N38s
         9hb0agO0a5V5h3EuPfZkjwuVwWyRLcdYqpY75JEdCkPWKgxHXRssJFI8BTgucgjL+a2I
         nsXhspZICFeRpE01cGi8OKFBYly4mLq9AC+Ixd7Y4M1UcBBIJMTnsqtUmG37mWOhjApY
         paqthiM73VK2fohvh2czdFHy9hDmgJ6hJxsNYM+EXYFR60BCwyjOWXm6DYFiT0xDbWd6
         Ar8A==
X-Forwarded-Encrypted: i=1; AJvYcCX5NeMTG4mAvcPF8t+ZQGnDXsUWL9PqNV9RwEzolOF2AQQomN6XpxZt053ag5P5m6spMVtnk1Lgtw==@kvack.org
X-Gm-Message-State: AOJu0YyFMpFwxdHePEmpn1FjoRaiZzibO8+FhWRWeuj7V9WD4Y4EEQwS
	M1Qc048NHMdeos5pHkWZBlJBR9TZe1mw91D7FstnwYNpVA2O5k77z0FnUDI0JckbZnW9OHkuQQx
	Gntp9gRVBcT/QlLV+PcE/8Pc4HR/Ir3o=
X-Gm-Gg: ATEYQzw8b0921Zr1qXBOHmzZ4gfdcCtvrHBIa84k2n7LxDFnIE23fNVqCYbRVgOWldl
	ffafMhaX3Crre6pNOo+opcyhxueUsDyO68IbHZLVL7K3ax38hiHBndNHQyK5cposG4NEdTa0rxU
	a9LGLxfRtzkPhU9x2ZkZ4IYbyC1jtFUU5/uzgOIlc1pvTfrnF7BWiktND5INqT+RvR7qL5yw2qS
	oGk1QcMn7/Myt4veCfRxAw47DngWap9tbfLPG1zm1N6UrqUlQNIKg3SrxzOv5iUL2DlFzCqxlS+
	gOdCvwA=
X-Received: by 2002:a05:6830:3895:b0:7d7:d2f5:1d61 with SMTP id
 46e09a7af769-7d9fadcaa65mr1412844a34.4.1774622239937; Fri, 27 Mar 2026
 07:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
 <CGME20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39@eucas1p1.samsung.com>
 <acZ3ZUXhFHpSXzYS@arm.com> <d2ed7315-72ff-43f3-bfaa-995025cb9419@samsung.com> <bfa5ff0a-8ef9-46cb-8881-396f71ed5be0@kernel.org>
In-Reply-To: <bfa5ff0a-8ef9-46cb-8881-396f71ed5be0@kernel.org>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 27 Mar 2026 19:37:08 +0500
X-Gm-Features: AQROBzCwIuxZlwe-ZTEq4hn8TNXRa68NgSRLtpj4ujZXiYxMYZMii3XpyteXFcM
Message-ID: <CABXGCsNDfuLQ64r=sMyJ0UYbzZT_j8xsH5h0gpAGTPwV64Qp2g@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	harry.yoo@oracle.com, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	stern@rowland.harvard.edu, linux@roeck-us.net, andy.shevchenko@gmail.com, 
	hch@lst.de, Jeff.kirsher@gmail.com, Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CA9880014
X-Stat-Signature: n8smn364ezgbtyb6fumdnek5x78upozc
X-HE-Tag: 1774622240-536242
X-HE-Meta: U2FsdGVkX18ItnqB+Zx1T5jYmZXxcLqaYTDm9u0M6IxMAlH1U23E3kmsU+4VyFogDTzRbiXS/lANB+7wJg5A0QJcz2qzrL1PQXZvD/He/UqSNolZGi2WZxH1EycdGwIjHMwaVnGva+ZI2+8mC2aS807vduId8vA+Xi5upn0Jv4Z7UQbe+QZYNJ1vM1KQVapozW8f8T+p4UHrg0q4rk6S8Vi7C2Tex6EuwlMZJzQYzb/8Uutp9lT5BKJnbrpdMzEDW/N+kDNtfXFRlexjbI42WooKB6fFzUXvc/2D0ORrozicq5dMtWz9+2JsbBVQb8M5dUsI9MwGgRhq7Iwp4yTVHZskD7FwYw4qZc12ATdm2MxU4YFDjg1ufZFaFI5i053a/n1uVD5INotK19HgY8w2Jhy9rjvtoGKXYgy0tpPFWlsl4our78VZYUbsALn/kaHddJ7rbdUb8oBnsTF3yfnpp73dAwWBtZAa8cfXymcFmfggWfj3sewPLsLTSqr7U+BFSIrnAznt4gChE/dZ20p13DBDxvUn/RtkPIW4P9BRKbuTbSoC2DSOdGQcoGynhQjxY/tRBChOgcgOCYF0mM4GkpIWnrTxWMuMxKIWqM5CzJSzZioEIvN66VTvxE487OoMtsDnK0xFonXWIozmMr/8VR3UNmr/MIneAuxVC1KfbckNrsCS2IfkaTiNjvkVsSapmFLFnRq7y+iXxW48rCd9nIBdJ7sRuY7TclcWP4tVxrlV+OpT56aRm/A8fKFd6E2YjMcURDADxnha+pKCdLAzlddDFKJicS5DsBz9UeSU/9QQnFRLhQzno58ErWYykUx6Hd2kp01fRQItPb5yGucOkjn4pIDRMAfKVKSF0FlLQQKlg1Z3NWuRzWQSdweInO2dtBww9TD90aoGJ4p6XJJWybI4DSUAG/L3moBFtoUDyBkYKsRTR6DpVAhx4ZyHyWcZhsqlPrcsvfWFV3eBOfn
 cwzLRhB1
 x5ovBrBaPwLvCBECSPSxEzx8H0C/7gI84S4HpMFsM19c7rH6xGUliWnxgPykgyyUgIPf2LiQUoUfMHImoiSDpP/p4Drum8tSEy5Dh5xyD5HFBpKVdNrPREiTxDBiBF+ihTvQZgZtdYXvve+WQZ850LuhtdEig3mvHxQHSQ93Qk1Ll1WFXxZjQgImIb4MMqefMgFWkVlr3E1cWR/S1TEnL/eRa4KjlgsRebzxt7wVjUf3473YUkMDnpdeSdO5ZBwSjf07P91y08+zUq6wkHgpDVv0OBU8bsGHbe/b46TmHFtX4wH483jALoFYEhs5mA3nt94UCAS7yRgyi1MW05O+3Kaf+THFVbNeHtYyTrEtk37kSClh92E+maiQDL/gEP9xZfDH0KgJG4sDM+UeYaW6YRUoHQM8/D1zvrXHjhKcMR9DtZNmlUfbMSyWL/QNJH6gaba8z8E4DH30EN7qWboiQuyI65vxWisnYZER8cN3Ff4CyXiDZSItDKGE9D5y3ogGnnY/H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 7:30=E2=80=AFPM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> So what about Harry's proposal [1]? Mikhail seems to be on board? [2]
>
> It seems it would achieve the goal that enabling DMA_API_DEBUG doesn't
> change the kernel behavior? But I don't know this area too well so
> maybe there's a catch.
>
> [1] https://lore.kernel.org/all/acYlxRBhSMcwBnja@hyeyoo/
> [2] https://lore.kernel.org/all/CABXGCsO_C8%2B%2B4%2BoPfZ%2BbQyrBnEGy5JFp=
XHkGNpfy%2B8%3D5BvVNfg@mail.gmail.com/

Hi Vlastimil,

Yes, I've already sent v2 based on Harry's suggestion:
https://lore.kernel.org/all/20260327124156.24820-1-mikhail.v.gavrilov@gmail=
.com/

It adds a dma_get_cache_alignment() >=3D L1_CACHE_BYTES check in
add_dma_entry() instead of changing ARCH_KMALLOC_MINALIGN, so
enabling DMA_API_DEBUG no longer affects allocator behavior.

--=20
Best Regards,
Mike Gavrilov.

