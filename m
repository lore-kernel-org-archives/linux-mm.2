Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 109C3CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526128E001F; Tue,  9 Sep 2025 10:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FDFC8E0003; Tue,  9 Sep 2025 10:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC938E001F; Tue,  9 Sep 2025 10:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9588E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:46:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B299611A5B1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:45:59 +0000 (UTC)
X-FDA: 83869986438.23.263AB5E
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id B78F2180011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:45:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oa2UPtDl;
	spf=pass (imf16.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8T/yu3N8TV6o0nCvXPls2b7J7vwcGfC7bXk5KdT0X2s=;
	b=sq95qhJK1cj6Lg1iMJR9gGwh7cBX3yqrPWRhLHBOKP33gQrJs6kwv8J1DQ5KFzL3m0g67F
	mYM+4xwK88+kgR5FpFJZICvVvFE6+LRKJhGJ2ozyJv+9XlJI3d8bIodnuPN8g0OnMRryks
	6aq1taGU3Zn7F5PipHULo9QrRPvPPQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429157; a=rsa-sha256;
	cv=none;
	b=jtkmSHj572/UgRuKCqWPyUMSe1feDusxdgpXZ5C20OulcG/DI0KdxjkSFTnbpTtkf6NyBo
	dffcm5xKbZK2o3h5E7pML7SdtOvYAv+SlEebkYCscL+0KilktmaZHUNfSX4bbOOYdvLsU3
	h0kMiRZvCX9PF5fZUeg/RFC2ToJi1Pk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oa2UPtDl;
	spf=pass (imf16.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3e2055ce973so3110604f8f.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757429156; x=1758033956; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8T/yu3N8TV6o0nCvXPls2b7J7vwcGfC7bXk5KdT0X2s=;
        b=Oa2UPtDlFGryctdvNROK6xGEIOoeyoB0MZ6Nn5Ciazg3OoZFH1D+rEImICx0/LQ4r3
         wQPpxDyxPUGh4McYRcLTyqRDRvFZ0dbQ/s5ZUd3fywkImFc4UN2OwCjhwaR4XcEk1gCc
         UOXLdvAvZyJE4j+DqqjnUVkSWJWqc98tiks9Xee+L8eJ/P9cwqKa5I2kuWUMtN0bB5Pp
         YhCY7kzt37z4djrqKZnNW3u2G+rGbVgdBfRcT6JYyn072ot71ub4mRDakaakkqVxA11x
         VwSeVdTNphc013WniGB9cvR5JPjIbUFNjcKcX4XA4ILriSR9QqZeOBITgI1p0eCX7/Vg
         wBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757429156; x=1758033956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8T/yu3N8TV6o0nCvXPls2b7J7vwcGfC7bXk5KdT0X2s=;
        b=mRrvP1h7fwdGeuUsqhVpR9hv4YOuuDTwcM6bSmsSPTy100BzfEDtgETFjFlTp2h3LQ
         T3kMoyiTgXQvCtYDs+5LHNzqhMe2eyz1IKnDspObNTGmtrZaY/rr3Rui1BXEFAYMr8Jh
         F58GREOSE3G6s/viYHAEQTY1bINci7fQbTQtHt+2PDSGQxcMMxg5748VUgKiTLCvzWaL
         S7QHcpQjktcbxrGHlnsNaY9+zsYh8B/nmh+F1G327d7emMLnw7oDrAIZkjhqCnYnf26L
         mRIdm73fd2BlGE5NwXUt2erpAMBR0/MlEruV8fSyIl24oCIAexPVIA1ed3GCK/2GMz2M
         35GA==
X-Forwarded-Encrypted: i=1; AJvYcCWzw3SnP3+aaar6xk5D8Dx4spGuZ24osgb7oSI8TUmigUf0tZ8CMpDpmtCCdnWbKU0lGss2Z6nxCw==@kvack.org
X-Gm-Message-State: AOJu0YxSyIUiE9obWrq8T1j/Gt3EZuqYT2k/7IIemmIzTfCs9BgpBHSB
	YCOfkLny94XCSypFuPBvF+XX6YAIvVUYdwBjKflMnaH+CNiT6EOyqgarP5N8nE4DD6HdMU6SJ+n
	fZ+z0abT3xUIry86ksGBe0RRonJ2QU5Y=
X-Gm-Gg: ASbGncsHwitnhVZatsfHTTBwg80FQL0bArEcagzaWfZa/O5fvhvNezIhc39+aY6YrL6
	uNBqNHFnsVga5elHR9VEQ2FPYER4hh0nmItAtASHBguM+ork4Q4XF1xWlCz8pWEef9Y4PMnxIot
	G0b1z3jcQYLdy0ttyj9Sb2naaDaNFURVxF1VHRoV7pkNPmImqrxN5d7M8n3mtT+LlfmPFC6fTP5
	Zb3uw+I
X-Google-Smtp-Source: AGHT+IH8mznDXMiTQJweNCJMFeyunuSNo6fJv5XkfHlGkiJSKVNMuvO31tCVhwde5ClSRv4GzI1pVbP/cjzPjFzqa4s=
X-Received: by 2002:a05:6000:2c0d:b0:3e7:441e:c9e1 with SMTP id
 ffacd0b85a97d-3e7441ecde8mr6759404f8f.18.1757429155814; Tue, 09 Sep 2025
 07:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <2f8115faaca5f79062542f930320cbfc6981863d.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZf1YeWzf38XjkXPjTH3dqSCeZ2_XaK0AGUeG05UuXPAbw@mail.gmail.com>
 <cfz7zprwfird7gf5fl36zdpmv3lmht2ibcfwkeulqocw3kokpl@u6snlpuqcc5k>
 <CA+fCnZe52tKCuGUP0LzbAsxqiukOXyLFT4Zc6_c0K1mFCXJ=dQ@mail.gmail.com> <m7sliogcv2ggy2m7inkzy5p6fkpinic7hqtjoo22ewycancs64@dnfcl2khgfur>
In-Reply-To: <m7sliogcv2ggy2m7inkzy5p6fkpinic7hqtjoo22ewycancs64@dnfcl2khgfur>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 9 Sep 2025 16:45:43 +0200
X-Gm-Features: AS18NWCko3Nu4vYg1YjsVoZlO3pFTQTWFNFMYZcWhGCR7k_x37D691H981KEWl4
Message-ID: <CA+fCnZc3ZY43KeQcWSw4kgcCqJpAvNj6gKd+x0AkjhuE2R8Hdw@mail.gmail.com>
Subject: Re: [PATCH v5 15/19] kasan: x86: Apply multishot to the inline report handler
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B78F2180011
X-Stat-Signature: xw8qdn55fxramhs6tq1drn7k9i5rzhrw
X-Rspam-User: 
X-HE-Tag: 1757429157-624798
X-HE-Meta: U2FsdGVkX184lDbTZFl7KEulgHDcwFSn3vhR083IndOpBDQtCibILg65q/PRRmmHLZsHyFg4JWoMNaZXY9WcQSlphMbqj0xWfiecD7EQ4hIFRkmhMMWx/+tUl86m13Q9NzYUKIEZiF+u4vP4jvKvbshieBJa0b3LxuzfpgR+fDgKyvm6UpVQP9GbEFscQl69uLWIBNKyIWwRZr14Ofl4oZx+uwCczMg7VghpXOTISyI2GYnTpcagzZZ8Hnzla1mI5A3j9KgaL1aJSoJa/X+hyvvZPLtc63i+WE76WfVdRQkp/f31IyDB2BmICLbF0t4WVTTZizbzQBD2a8iGXn7ZWlYRlwJlTckUc7ln4SuTRzvutaxB+kRrIYe5hUQfV8tOJ0h8v475mXHoDueSSRo9+zst0FP8eV08Uqy9DHM1m10DroOQOEwLjMPuVf40WOHAVbjrNruzNl+ymY70BLlzQ0zs7T6D7tYYujGhuaqf6YMImoC8brV04lPAv4qAQXii5RfFzJTrR/lzeehfbot/z6lQwcbaH6HyWDJ8gn+aXhEmpDbYMEeQNh+HZ/OFPAxbsM5q0gIP13ZPi/9E5NEFmjkzLnbZO53ZMetesam4vFjuXWnhsn9HZoqvy1dTfPXm8dmq40YZ5kiU2Tt2M98qUkSvA9LibcjURKyJ52rIYlnHP/OTNW77xKN7cntMQVS5xNBqq6T41H+5KFa7XnFKYcimSO0UOuXXTjh6suK3BnGw4IyQYH+e/vkktAgo17YYdz1Ag7SCeN748UBcOW4jV/hwOIdzR0grWmGSxlHdf7/0yUdV4A9CkXiQ40+MGFuCBTb9gu3tBk3T6ZArpIVAynaD06oED+Tluwz6SpNmtNgLDCefd7F6FkAqWjNLTUv2icVJk41X1vuBNK+I3KGQG+Ib4Z8PR7jhXSAWi4cweo+oNjtUnrE4Zc3eCjTTQG5QLRrQy80+YMg/f8+te3J
 Ria1SMZN
 qOmObyXr5r/6s93UJjA733DTqsbQ/8n8SuATgcMkyfusZZbhK61YPnKgc84WuxWmEvr52G9DlHiw3nSGWFqNAusWMHAUkCvu5dgTFe6Y1C7Bni7Gxu3OOOKyOoGZNYrC0/o87fnkQrKFuLRp1HupUFJ42sFcu9Ffszcmb7hIQM/pkZrU9XRCwh5n4lgEUbhkD5eEoKj4TpE8ywDbo7xbMD91MelNm+AOqmV+VL91yOA1GEbayMWJyu3YuZKRs8Tkb8asiGyf55+oe+txUQtEVtWIZpt7gx6KeF9VorxLT29uMHFUq4dYEEg/EUZPQssu043xCihVylGN9y4nazONkhqDOERD1cvuJOmIZMHt+OYypwOor9z0PAgYi5COaALRNux9tw/njpJtQ48xvCpT4COvOW01mw3leW2KqMVz3vNHzbRd+ku+30BADDhO9Q5Dp61hDGh3gdXRgHyhDxO+3K38E9Wg4yyCux4oC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 10:42=E2=80=AFAM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> On 2025-09-08 at 22:19:11 +0200, Andrey Konovalov wrote:
> >On Mon, Sep 8, 2025 at 3:04=E2=80=AFPM Maciej Wieczor-Retman
> ><maciej.wieczor-retman@intel.com> wrote:
> >>
> >> >> +       if (kasan_multi_shot_enabled())
> >> >> +               return true;
> >> >
> >> >It's odd this this is required on x86 but not on arm64, see my commen=
t
> >> >on the patch that adds kasan_inline_handler().
> >> >
> >>
> >> I think this is needed if we want to keep the kasan_inline_recover bel=
ow.
> >> Because without this patch, kasan_report() will report a mismatch, an =
then die()
> >> will be called. So the multishot gets ignored.
> >
> >But die() should be called only when recovery is disabled. And
> >recovery should always be enabled.
>
> Hmm I thought when I was testing inline mode last time, that recovery was=
 always
> disabled. I'll recheck later.
>
> But just looking at llvm code, hwasan-recover has init(false). And the ke=
rnel
> doesn't do anything to this value in Makefile.kasan. Perhaps it just need=
s to be
> corrected in the Makefile.kasan?

Recovery should be disabled as the default when
-fsanitize=3Dkernel-hwaddress is used (unless something was
broken/changed); see this patch:

https://github.com/llvm/llvm-project/commit/1ba9d9c6ca1ffeef7e833261ebca463=
a92adf82f

