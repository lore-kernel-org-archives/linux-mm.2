Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 958B3CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4DE8E000F; Tue, 23 Sep 2025 13:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94C38E0001; Tue, 23 Sep 2025 13:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CB98E000F; Tue, 23 Sep 2025 13:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1FA28E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:49:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A11EABA3B5
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:18 +0000 (UTC)
X-FDA: 83921251596.09.CDF13E0
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7BB9180012
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HIOMlV5h;
	spf=pass (imf24.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ak83w47Un+0YVkw6h4ejJTiciQnGZqbDFJcToiU+0xQ=;
	b=wiwPl18AEP/s61iwCEqPOfpWtFJxqqdr+nm5nVRedatL4S+FfsdQDXhaFAhHDQOce33m8X
	C/4mbMGs5QzhGPTP/pPrtyAdt2plcO/As6wxOJvSiN1UDeISEjB6WUGR/dV6CXjGpt19ny
	y0734QGTIG0xmJXugNXeYLcIsbNPNbk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HIOMlV5h;
	spf=pass (imf24.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758649756; a=rsa-sha256;
	cv=none;
	b=UFWxO19k6g43ppa83YE3mP0/zmewmzBCN+77zXMu8Up7TEt6vVdClSh2WpEx8b62MaVm/H
	+JFBCG5vhUqr+up3jOiNuBuJKai7A5UZhPQkAzgsX9leurp9iazkF0Cbme4GWhueen7xkc
	lChFnWD7YZ1hhvbSD2y7P7/4YbDzmQc=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee1317b1f7so2920023f8f.2
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758649755; x=1759254555; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ak83w47Un+0YVkw6h4ejJTiciQnGZqbDFJcToiU+0xQ=;
        b=HIOMlV5hFDga4U/3GIYdMM747S4ZXiyP7guLWLLLf4xR30fz+LMBvwLI+HKFgnr/zE
         SsGUJnznAHDqqiI83BKYUPzONyisa4zVhdqQaK+zQpcKmfiEk5y86yyiN//r+Toeqv4A
         IE2OpRWK24C+bu9VUifNzDGUSSuQtJA2Q2fsX/hHA2pPiqVWwNbq0k1viSrcGGIzpwgK
         gAK8SVBpUfyb8yTkk48194RXJXjQGWKXRJpGA4wEyO2wOzzapSrJmeS0FdBzDxAbEaCQ
         ImxQbSg1Eq+s8B8bnD8gRpTUyv2WjD/ZURepvLNTg9UASSRRbbMWbwwwvLSVvJ9/b3+2
         BUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758649755; x=1759254555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ak83w47Un+0YVkw6h4ejJTiciQnGZqbDFJcToiU+0xQ=;
        b=X3MgIwsR44VYdSco2Qs+vBUag75YMd9lcXqrgtaEHd+I/Cj4eF56VuJ8Uh6paFeCnZ
         qc6+E7D3eg3UkHEdm/mf99tqq9ryIaz8PyGwFQEH3It+QYIxqYnFcJrI4HAHM6Apw05g
         Hn0TybymX7jNd+nHDEbppjQPNyG+IpVgUNpfe15GmTJXblhO6oFJX2bxuqz+3MBcH4LD
         1LA9Yd+1q03vm5S5KaLAN6lPlV9uv+Mr+LLbad+g0OtgIFUa5x/yCyTqDQnZWv9dnAnU
         l4yDIAqpXftG70/ZWRZHGmb2nfkmjsOZOZ0ZqkdJHWdgtAyf52fp5DRdEshGMJ9BsbsJ
         g6mw==
X-Forwarded-Encrypted: i=1; AJvYcCUCMxteYg2VwdUcXpDiwM+U2ogYALAiJKBYTaYGr6Vq1KPn8tF8XYs+AcxVNUaNrM+wsdiZbbOGVA==@kvack.org
X-Gm-Message-State: AOJu0Yx4H+zp4ZNb8/moDao+7ZkQpLNVCn41v/+E042vTvt1/Ky3IPAp
	KsJva8HyF357j3eViXj0xDmeqL+ptmTQ4WuQBrS6tms4qxYC3PBCURvbGzKc80ChbepA6mGiva5
	Qkv8K46kqdT8I5HSLz3oRJdPckMkifb8=
X-Gm-Gg: ASbGnctIuLIQjpQlyZm7sRsBNLFt/Sahz5jm2ZS+CU4miyW8wQUyxu0Wi8T+iyl27ov
	HuwmVeVf7THZz0eo14MvAAeSgVYUPXnsOh1UDoabPHMWd/rBBURqpwtCI6EHZPSnqdUw0P5cQlH
	OAvEWxWk6wustPQk8flmcXRWRSvC1zQvk60KKKm7ibuHAGwTM6SNkmZbIn6OYIC2vr5QHNCBQG2
	YUlPBd/uw==
X-Google-Smtp-Source: AGHT+IFSBc+NBD1jZsd0LSs+Pw95eV8L2vwpY4rCb+CqA5TPaGXD6Axn8yxp6z29u7E5i0MPRJJiZRdC/VoVJA9DlfM=
X-Received: by 2002:a05:6000:2585:b0:3ea:c7ea:13da with SMTP id
 ffacd0b85a97d-405c4a9734bmr2645479f8f.9.1758649754815; Tue, 23 Sep 2025
 10:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250810125746.1105476-1-snovitoll@gmail.com> <20250810125746.1105476-2-snovitoll@gmail.com>
 <CA+fCnZdFp69ZHbccLSEKYH3i7g6r2WdQ0qzyf+quLnA0tjfXJg@mail.gmail.com> <CACzwLxh4pJOBbU2fHKCPWkHHCuLtDW-rh52788u2Q6+nG-+bTA@mail.gmail.com>
In-Reply-To: <CACzwLxh4pJOBbU2fHKCPWkHHCuLtDW-rh52788u2Q6+nG-+bTA@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 23 Sep 2025 19:49:03 +0200
X-Gm-Features: AS18NWAo7UnIsKkvCh16EnxIlUsef04XXrIh6VHPmyIq2HZ6eh0cMjqVLlDuPQw
Message-ID: <CA+fCnZce3AR+pUesbDkKMtMJ+iR8eDrcjFTbVpAcwjBoZ=gJnQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: ryabinin.a.a@gmail.com, christophe.leroy@csgroup.eu, bhe@redhat.com, 
	hca@linux.ibm.com, akpm@linux-foundation.org, zhangqing@loongson.cn, 
	chenhuacai@loongson.cn, davidgow@google.com, glider@google.com, 
	dvyukov@google.com, alexghiti@rivosinc.com, alex@ghiti.fr, 
	agordeev@linux.ibm.com, vincenzo.frascino@arm.com, elver@google.com, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B7BB9180012
X-Stat-Signature: djwbuhaurw33crurtn9bq3d1cibfezdi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758649756-103973
X-HE-Meta: U2FsdGVkX1+t9tgQmeK1HNaoABIPkC9cIyPXtoVmX1TdNtJORFnIai0eHl52AiXVyeRBI+2wqJtotT19Woq96cwPWfvEX8PjSEJEJNlZDsqha65Rn9UApgb8f+1sbOC7bTl08GWHO6xBCs/630wb+KkctJxVakXuay4RYznhS+zEB0Md/lSOWgvmBkwOPRXe4+SH3hTebsbH85PgrcRYu8hUajkIu863u5fgiTya1HCGzJtsr8d3vInIHDaq0PQDlDPP2GZ28EgRjItJGvvOWisT1bh7I0/fh2yNnhe3YWHKi0/LnxB2AsJRST8kAWSVOISqIwl+b/sx6FD19ZI1LLWptDG8y1VxYdI2p/REhZjPqEMyVnqKb9lTw3ncJC/yuwzSwgiIeTekM9VDJN1tZFdmXWLUy51zofC9cV8LcPHcW5W3xYQ2LHEdOroT3CQ7wsyFPBAZ81e7QcIIes65X0ZYP3eVUYjT06Hzr6+wul+rvPRz+GN/pitSIqj4OA2MgxbjBSaROC9lRsyEhiQTol7NBOwbZ9Yka1/JOQMnQPMgsmU1cDQxhL8TtFpznk3S2OtYIdNGhnZNBHKbYvndsclOyHrokiBPv7NxjSpiPJJgulm4KlC37qBIHfLyFcMGXSqpdfv3iLLzPsNAnDmmwZE3PEHcvfm0XBIyi6SMF75f1V7kWuCBaIXY4tIUX1m6VYajH8KJ6q1H49rTB7QThXe+2bW9hOKUI/YVZKM1Uu7Q+Zr1Adb6zdnSETaGJptcJGm1Cg34flQB4FCuOdhn0VjX1pdvCfPxZd3S1o59Ol99ev93LpQRmNJJJI6A/q8fejB58qx36R7Li/ffcS5AAD+phl74Ct/b5p04qRi78ppsaVVgonwbYcX0NX/ndOaAjV0W7bbD/7HQoVqqzdeO/fxfnPfvqzI3wdettP4A5C08tYmjgSLF4J7tAnhSTJxTxcD7nhCwTEIub45bJGr
 izFGSdhh
 fA2IYLdG5fQI53sXdRuQ3DL5DAjg2swCr9XG0NF1xccG2fhHTj69HXYfbzj9v49iChNlWx8HaSbRCFHxe8EtkbZgIK53ug17UiNlyzF/QM0TMyW+dqSb10JNI+Ihp6paj+a9P/djmsT/8GycHmdRl9fONanYDIG2NWd/DpVVdmKVyLrmgku/dMs15kl4GvUNV0TBfKGoxQvYpbEF3TOS23yXDKTaM9qgyQv8vSwyJyB4rAmFW5EUd0muwm1lnlDGI9+upHVAiShPR17gPHdd0PGQmCi8vSyqirqROYoe3M/8oWUHXkYuLABoxwAkw/2diNP1PPSKewOfuyHbUYJnxwaSC1cq5qd61+AL+4o3UdW09PhAoih4YZZNWpcLpM3rRDSYefhJenylXr16eBmhmh4QZMRAY99HBzczZlx3M+MuvFQ5fE2bGmDs5l5yOTYx+GK0hK9zC4Oj47gSKbA4dqgoeVoNmvu4UtL9ZVjU/KRPi+QYSJ+e5M3UI2dvW5pQS5nEgXGNXHzgcQTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 6:30=E2=80=AFAM Sabyrzhan Tasbolatov
<snovitoll@gmail.com> wrote:
>
> > Why is the check removed here and in some other places below? This
> > need to be explained in the commit message.
>
> kasan_arch_is_ready which was unified with kasan_enabled, was removed
> here because
> __kasan_slab_pre_free is called from include/linux/kasan.h [1] where
> there's already kasan_enabled() check.
>
> [1] https://elixir.bootlin.com/linux/v6.16.7/source/include/linux/kasan.h=
#L198
>
> Please let me know if v7 is required with the change in the git commit
> message only.

No need, but next time please add such info into the commit message.

> > What I meant with these __wrappers was that we should add them for the
> > KASAN hooks that are called from non-KASAN code (i.e. for the hooks
> > defined in include/linux/kasan.h). And then move all the
> > kasan_enabled() checks from mm/kasan/* to where the wrappers are
> > defined in include/linux/kasan.h (see kasan_unpoison_range() as an
> > example).
> >
> > kasan_save_free_info is a KASAN internal function that should need
> > such a wrapper.
> >
> > For now, to make these patches simpler, you can keep kasan_enabled()
> > checks in mm/kasan/*, where they are now. Later we can move them to
> > include/linux/kasan.h with a separate patch.
>
> Yes, I'd like to revisit this in the next separate patch series.

Great!

But for now, please send a fix-up patch that removes the
__kasan_save_free_info() wrapper (or a v8? But I see that your series
is now in mm-stable, so I guess a separate fix-up patch is preferred).

I don't think you need a kasan_enabled() check in
kasan_save_free_info() at all. Both the higher level paths
(kasan_slab_free and kasan_mempool_poison_object) already contain this
check.

Thanks!

