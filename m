Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D24FFCAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3892E8E0011; Mon,  8 Sep 2025 16:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360F08E0001; Mon,  8 Sep 2025 16:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276258E0011; Mon,  8 Sep 2025 16:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 164C58E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:19:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2EDEB637C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:19:20 +0000 (UTC)
X-FDA: 83867197680.19.B6479F8
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id DBBA31C0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:19:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iU3RwdRw;
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vT09vTia8SgQBO+FiegSxuy3xNGmzzHUSLwcepL1OEI=;
	b=VJEC6gvdD3rhK5vBaBtKZehf0K0TsndOyf6rWRB9YxSQE5W3PbpqOm+V1FYd8g0aqwUadK
	s+Vvex0R39uTBN9p4vKP5sSa9OEpSbuSjUk8D4vM31tOJ33cvZ6HWCXczi1LmDWAsGWC1w
	qeWZpvH3pXPrs8zym7F5mh7M0HE6lmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362759; a=rsa-sha256;
	cv=none;
	b=3UqeZQUYKA4/xk2sYfHY9g4SVGOCufRLqf0/9AyDskKsK0hEYDvjlDeAdFLbZuQiWkZrur
	RPKpAaz0ycPUCOA3Vrm+xqPknwkagAyUthhhU/ATsJQXu/v97MpTVpub9gKeMOWQuyq7U+
	aYS+KozFaPuVJ93t3B6galpN3vdAsB8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iU3RwdRw;
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3da9ad0c1f4so3377759f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757362757; x=1757967557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vT09vTia8SgQBO+FiegSxuy3xNGmzzHUSLwcepL1OEI=;
        b=iU3RwdRwQTFyppVvl0c19EUYtVxf7GBO3Fe5C2qo+l9uMeKs8j1pdY+bbCScS88EH9
         SSwOylkCnxVjC/mVCUDH/mkHvYAB3XTmHcfFoEEdSNucMcUHzMozcrkD5FrGyzjauMaz
         RHrGaDRuRBu60fUzjkZ1FC7SZMuqwFQADDweJXgsVx3X2cFU0aIGsnDSKniXSgEzTySO
         S/MeXKXC0ynO7CKUzIHxpWrObeDwoSY47OjmJc6HbI0FUz7aFDcrQuJ/L1Qmz4LAYiiT
         p7ZFGz0A8YpKNlCGPB83U2Wrt8eY78bGv04I+4WhQfWb3LFW1p6dTzE0caChkVBxcYE0
         GW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757362757; x=1757967557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vT09vTia8SgQBO+FiegSxuy3xNGmzzHUSLwcepL1OEI=;
        b=O7xwPL5hD02E5BtzjdKxXl/kKlEixqB4/AidM3iQDo0EOZ/kFZkmep1oJutZ/uPOHC
         A+ZJcZIm5ZJ6x3ayfeGjz4yy/FoTmrsWx0WqoQS3udPoMXmEl8G8YmVCNX7Zzrx/tls3
         xQ1wI0/EbmzShMhNtr9xVeLzeEGqR4zhPBigH/X35YnJTESAx3dWckY4IjRMKVSc8mjO
         rSFSRR5UPPINqDH83pFI2fwYtK+obte8xJnL7lysZdGS1UoLj44waB0UH0BbLd63Nxu9
         ik6L4/a5K4GIiUyFZs+rHg+jTxELgR3C0/eyPWHivmYf/O+9THLSflKMMGJda7gu4uPr
         5NmA==
X-Forwarded-Encrypted: i=1; AJvYcCUPQhd+0fHrHScvyY9klcTVtgjhh/mEkvJ7xqY1XI617Vt9NFLXbZGRIAMmqgTEbrWV8HUW8GJ2+w==@kvack.org
X-Gm-Message-State: AOJu0Yz3D52m1mpsVL7eFuNX/tOp4WMV0wquOlVvKumOspWgfKJrB8qj
	1dtLDnRUtsaJuSzOtuItT0vYGilToXLz098A8SBca/28YqSpsiUJVBtKsiziY7UbEaT/noFrTgu
	FKWYHtkO9OPDwgdpLu/0szcXBxDkz1f0=
X-Gm-Gg: ASbGncvmL30a6BEy6BKmfZF/CVIpH+Z8DaZxhK46Qcz5xMOA4jECF22U4Q0G5VhEDjM
	eKaRdOEQVf47O/883w0DTCeVgdBanR0a+xr2ld+ttamhDoIoVyXARjGSAGystJKz5A5G8VIuo8a
	/Rdqw/qkN/YwXrxoJRkJCsEnYBuqmRtxyluzmEvA2E7YZWvliIilFoU2WnY2nMSeH0QKRnvrYBz
	iUPw2yT
X-Google-Smtp-Source: AGHT+IGh6YqUFpx+JIdu/8YkqL5G1rRgnTznoIse4KvphEDHD6OBcCQt7Euav83er+DtfxdiEo+7p+GtKQrhaaETdWA=
X-Received: by 2002:a05:6000:2f86:b0:3d2:6129:5505 with SMTP id
 ffacd0b85a97d-3e64bde66c0mr9404161f8f.36.1757362756927; Mon, 08 Sep 2025
 13:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
 <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
 <hw7xa2ooqeyjo5ypc5jluuyjlgyzimxtylj5sh6igyffsxtyaf@qajqp37h6v2n> <epbqhjyfdt3daudp2wx54jsw6d7jf6ifbr3yknlfuqptz7b4uq@73n5k6b2jrrl>
In-Reply-To: <epbqhjyfdt3daudp2wx54jsw6d7jf6ifbr3yknlfuqptz7b4uq@73n5k6b2jrrl>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 8 Sep 2025 22:19:05 +0200
X-Gm-Features: AS18NWBlgrNec5HQDqXuFdTg0l1auT_Opy5K148gspXva4oeYyeCVxabENuTdwg
Message-ID: <CA+fCnZdJckDC4AKYxLS1MLBXir4wWqNddrD0o+mY4MXt0CYhcQ@mail.gmail.com>
Subject: Re: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 386wdkpxf9bcskfshq48p9y6wscnrq6g
X-Rspam-User: 
X-Rspamd-Queue-Id: DBBA31C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757362758-866551
X-HE-Meta: U2FsdGVkX1/v7CBAGHwD3zqUGHYN/yIsOxRflnojirmkvq1iYkXae39OGSvKkMVogUha9TlDV/6CJHLvbBGIC2iGhaBXtRIlMWeqAG1R2gysUPrYuH3BbeUZOiqbnJ6wB/CFaDV5e+H8Ers9Luj3YBE/0KWxR6ReIVtccE+3PFGyFqVrVfshvsGrb2rpjAr3x6pJmDQmp2BJVK0UWQnCu3O8ggQxkxpQiiYSVSBj3DC3jSL0Hxrnm2v0C3fWTnipQjbYO3jI6Iw5+X2JlKTzAVlIAO41SYM+mFOgGhB17rz9zCEFnd2kinodZatOzU4arLBtmABsO9RBShw7VQxwYwNMpLsAcf+TVTg0BeEFkWe9nCfO6uY7y43RJ0V1d20Uj1sYFmjL9aR/Jh+4902H20QbE6nMmTBNNcTLXKJAs2t+H9DeymLsKPqWaqbCyZzIbaBo4q+s7Y6ReSYBE5xpOtorTJkVKzhqEknyTBa27bkpkK1bTDQ6BGDB1ulFV/lnoQUrArYEUMm69CUICgYe+aZzKEQ0Zpyp3BRkAOX9WM1YEnNbmsQ4Wn6aN1PwnwjcbZMoFlAkkyf1/SNyI57mGz7IG+1BhBwaPe+aByEw7FNQ8sVjW4B201W7w/LGTamCUDy9zl5CbC2riiF/OoRkeKAF86IDi8tU6f4sWLcWNOcydjo1m0px1ydfD7UOEPeTDnmpwKTHVfQAuK09xUAqDSv48999IU9/nCGMRqBI6L7sLGSSG9GsCRwBjm8hLVTF46zzoJ5H8lmdQINMUaSsfUTKp7TAVhOKqRr6CMiaE9ZKOksLRn34gpQk5zl08ADl2jVD3JFI87bCdt3W4sy8eQNciLwUzjlvVBHgWB6VRF/ONr1KWkg1yu6j5iTyQ6TDmibpzfGXg3B5BLoBfc/oMN9T0f3tAb6MPSikhgb1O3uhm4ZnCCNc9VLFwFx4CuQyIvJnoI+px9BuDvRx/8R
 +TxSOYSt
 GQFAsRUISmWcsWx8UFXtGtaV7lr+TKR+yIfF5NO+8KjhPLP8rs14BLkCCxLL3hV6kRJ3LzHk5xp4BpfDmrV8KvwTdQ91j41jCpamSIs/bfGTqHq8wAhdjAoWanRBqxVi26TqtXFHG/CcCIEJ1OtfrjO/Lazlwy99QZBlVsH0XuPOSOPz+/58YY3yfAPTuoL5lXsnUyHQfxxhdvfZIkqg2t0EqZ/e8hyVxH2GUyle0Aqk5GA/2MyDxIDdXzKd853YKo+U0Ui2p+uUvOE0Rwy1M/JDOgV0ncL/dPhmRre10FwvRUGdwRsQIbLBzQUoXnVCMyXLpVdz4mRF+Og1Ba3KnF1YJfoAu7aV6Y5JQ0GFaEY5f4L0qQlfvAuFyqCSC1DeMYtkJJ6A6pFWocAbcN1J7G/3YC4stLOFr++o8MXCYPt/K9RiZSBDkPNBjSoxsGx7ZalsxPZfNU8ZJ6Bk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 3:09=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> >>I recall there were some corner cases where this code path got called i=
n outline
> >>mode, didn't have a mismatch but still died due to the die() below. But=
 I'll
> >>recheck and either apply what you wrote above or get add a better expla=
nation
> >>to the patch message.
> >
> >Okay, so the int3_selftest_ip() is causing a problem in outline mode.
> >
> >I tried disabling kasan with kasan_disable_current() but thinking of it =
now it
> >won't work because int3 handler will still be called and die() will happ=
en.
>
> Sorry, I meant to write that kasan_disable_current() works together with
> if(!kasan_report()). Because without checking kasan_report()' return
> value, if kasan is disabled through kasan_disable_current() it will have =
no
> effect in both inline mode, and if int3 is called in outline mode - the
> kasan_inline_handler will lead to die().

So do I understand correctly, that we have no way to distinguish
whether the int3 was inserted by the KASAN instrumentation or natively
called (like in int3_selftest_ip())?

If so, I think that we need to fix/change the compiler first so that
we can distinguish these cases. And only then introduce
kasan_inline_handler(). (Without kasan_inline_handler(), the outline
instrumentation would then just work, right?)

If we can distinguish them, then we should only call
kasan_inline_handler() for the KASAN-inserted int3's. This is what we
do on arm64 (via brk and KASAN_BRK_IMM). And then int3_selftest_ip()
should not be affected.

> >
> >What did you mean by "return the same value regardless of kasan_report()=
"? Then
> >it will never reach the kasan_inline_recover() which I assume is needed =
for
> >inline mode (once recover will work).

I meant that with the recovery always enabled, it should not matter
whether the report is suppressed (kasan_report() returns false) or
printed (returns true). We should always skip over the int3
instruction and continue the execution.

