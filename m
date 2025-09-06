Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3316CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5058E0005; Sat,  6 Sep 2025 13:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E948E0002; Sat,  6 Sep 2025 13:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0266A8E0005; Sat,  6 Sep 2025 13:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DDF728E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:18:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69FD3140579
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:18:55 +0000 (UTC)
X-FDA: 83859485430.01.200F2A5
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 76B4B180003
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:18:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nKCY5naM;
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvnXgjkKA1Pp2ZMyBbTXIoHx/IW3dCtqfz+u+Yq42DE=;
	b=blZZhnWoGLA8wfenFGORKmP2T6EMjmpBHikjJ6n1yJ5FAj0Cs6YdljMxDqbiiXoyJrEpA+
	lw2iAd4qv0JHd+VeBeaJHTT14AzTbXsxJqIk0LoSew4ISktU1fkjcN0TjPXNlVXjCRB6Zh
	AtRP0hjQlv9uCpinLtZi3cfF6F0P38U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nKCY5naM;
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179133; a=rsa-sha256;
	cv=none;
	b=Wp00wpp0mIRYqabmGLkg9FDtBI+L+FYyGDhbbOeUICOUPjcRbNl50icSR0PPNBovGPqLrl
	qcgo9usnreO06LQRRI0GgbRhVRzPApkohkKbMU+oUXHDGPN7pd1GsjaP7cZStBeNrfDBt1
	tUtVyEfE07iLSC+tzqVgpjZXIABjgYM=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3df2f4aedc7so1756863f8f.2
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179132; x=1757783932; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZvnXgjkKA1Pp2ZMyBbTXIoHx/IW3dCtqfz+u+Yq42DE=;
        b=nKCY5naMhiYm1mf7Afbseh7JP8gc7HyLWRiwgJLMmPVJEnHYKedRSP1aa9woZPpMCV
         JQ/XLnfv+N4U4jStcoO5SA1acmuPLlKs242rH7GFTyExzZHhRmM0AP+RtciHX2yUOBUu
         Y087d3/zGO1lk6EreAwFVbc8kQsglhdBxGCmNNV+cOHxAvRmdu3iz7pjlHxeuuhL7DtY
         kBtf63tQEFqYH1hCLwpXLEyWvTwrGAdBWlAOtazwKLsDzE/XE0DikBWwd6p2XyCTKLct
         aSFl800MTVW7mPawBeknsnZ1+dIl859tYz/vXKtmFNRyh4uto4TP55CZpL0hJgJAq0Uo
         we1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179132; x=1757783932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZvnXgjkKA1Pp2ZMyBbTXIoHx/IW3dCtqfz+u+Yq42DE=;
        b=uMx/62AUmlf+yMWksx7dw6hTmkxw9azfbyoZO/dNWw2UKEC2jkE6ae4b+Ba7z9UMs/
         mkkkecQfipw2ubCE97l6CZF5ZAzzowXRY29JWsQK1SeRodr4sapjTZ7ChvBgvDO0Uw8C
         buEzni7BOK25a1DrfhOjLYHpLuNcUM6zo9fTPWDWKz9I/klRkwOyT4n6eHmq3RMuQQbJ
         c4wIX7yL/+Nmcb7PHXjlcgQMGUl7eNTQYyUiQ+641pNlFk+7Z8y2dqKfgpRDtiJxU/G9
         RDO1WlWxCIhOcsxhL8/igsfzV9OIBeFSxm4x4+f5iTekGu2fhoQ/k/DZU+jevLlyyzkk
         Qd3A==
X-Forwarded-Encrypted: i=1; AJvYcCWbAN2zSfJ+PCH/hrTvzoSJRw7Jjev12SVeDuovAgaYUkMIbJBeYOu9uEnXlprZK2p3n+9xjF0ivA==@kvack.org
X-Gm-Message-State: AOJu0YzDweaEGyae4tRfPXweu0p3jlI13sk9gSflTtxoR+ihbXjxq+gE
	KhDjMo6TNnAN6HcW187c0YkAfuFWPSgyEEuoC413OZdZzj11We9BuWUFknBDY8a1LMOxNkjA2qo
	EjyOsThPaYHoRGwnCNuuqIRYMaOry7Qg=
X-Gm-Gg: ASbGncuWfRVKgYNCn9c2GN0b38a+IY1q3oCgy5ng4y1isipV4wBK7La5cvt9IKd/fFy
	4zgxcEpauWB5CL3YeJMzNUWprTG0VEaK684giBH6kCssaxptFkToBGzz2Ym9zHo3VEUo91WTqpk
	M1hghYYnPNCXNHT/0baImYst6cDQPb/9607Jh8ykb8Mpxj+g8TEWnY365N/H52YrTvawyOT4dm0
	P+ONh/e2im22A7rOBQ=
X-Google-Smtp-Source: AGHT+IFd67uPTqVPfMc7bozbMZ5rB/KKiiv3rdrmWYBThjYpOYSQHAfLhZfyUhJZKRt6LAh3XOHhPqNJnibRne/x5dE=
X-Received: by 2002:a05:6000:2910:b0:3e3:f89:ea31 with SMTP id
 ffacd0b85a97d-3e643c1e706mr1880888f8f.61.1757179131893; Sat, 06 Sep 2025
 10:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <c9dfcee8bd04161394f41a21f78fc3e01a007ddb.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <c9dfcee8bd04161394f41a21f78fc3e01a007ddb.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:18:41 +0200
X-Gm-Features: AS18NWAE44l-F8fxYkxmWh2eLEtrt0fldHS7j-JrDWBIap-lKzv70eyY1F7Ln-M
Message-ID: <CA+fCnZcBGhToB+pOhn+ACahyqVLWJ_7cnqBNZC5ob77wZD5iJw@mail.gmail.com>
Subject: Re: [PATCH v5 12/19] x86: Minimal SLAB alignment
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
X-Stat-Signature: dubf1zaorigxdkrkqjnwzpei4759xm81
X-Rspam-User: 
X-Rspamd-Queue-Id: 76B4B180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1757179133-952141
X-HE-Meta: U2FsdGVkX18p9gggKZRyOqdWtWc72Xv9BA3c8gAsASUnIwDN3PaEsyqlTnRu7jRz91Hp41hIfFMo6i43MTmGkO3uemv2/V6dAzJzNZ5YB1wNv43799G3vMlh9WYO4a6DWjZwFVroWqR5A8pozpHTFEpMUg83UUPiuxtdvR4Dd44n2z/ureEj2bfEm8nE6+TCLg5NGqxqnLnMXOtWycVwn9xg403BOTDC+ivNWpms39Xdjcbgfj2tbvM1eomOlUL+CZDbC7ySx9WYM803F7m4McJlZU+W8hFzUa65wFpeU1hiB6sW3OW8ilze7Dd5fL8EzkGJ7KgxiC4tOGp1GkGJs7YYvGWJenrECWJL+FGYON0+R2q/kqLvMEvtIc15niq0XHLV45ZLiVZSWUXaDDD8ZwK7dLF2A4GKERtLWMVyvcuV2vE/JplXenMQzjKjoop3RMTN7Lzaa2EL9IxHdKE6ML8hcXmDv/zV2y9g+e8PEts95Wfla+UyKb60oKy433wlUd2EZO+JJWPFv2d9PK4IqTNyd/cl2+/Xyq+f4jRe2qBKvKd84XVt03b46sSMS6lrEV3fWSGDLttuUFC4GzNZAlrPp4U5oPh9I7wLus8UAmL2Pazw+gmaYZ40SCFoByzdk07xClyDw6RskxwC83ZWwp9BESwq32wiIwUosln3gAEi9gv5mJ9OCrHkEL3TSlRIyWaOgxN3mbZoeZu89/y6md5RmIIWXBFzzLhSRB4e4QbYNvsTKK+U9d+xp9FnQtCpuAbBeGeHjaFPGUG9dPdEgxi+7FKTSQ397A8zgXKdH5xqTxk2SoLwsH3RIW/JysubItH6MSdBg1Yvd/zWobPq/H7tIMhSea81jpc8vruiegM5j+c8rpqGffjnCDYHdUBw9MRI1DtcxVZNStIiNRFh2AcJYS97CDXVgnc1g5W/Xrt5UfOMVn0ZZvjBevy3Q4rE0cx9dJsFWQDmOw2owCT
 Lp9w2bt3
 PXIsgHJmjSGO/HrKIIOYj5Devc7C3iL5lDTxwMYS4arasB3w0BU6uDp0LPc54PbarFBbK8V+uS7Xrw/b97kW+NvyZ86uHTMVjF7lVhROGGKwQDkiuaeUwADGgbi9eS6vwZV1PppMA0whs1lsUVSY4iPBmaGhOh+1DwgJ3W3NI4gmiDMyiK1hBxSEKdCxYZrLzYtJm8tQTdB68610swGilRpavwQDRP3xrKOuV9pu+9GD6nkkKFYM+ZSBpayvgwaVJ1xBTW476Dh5bJPZHHhccro4LednBmHwhcLhg4pn8f51khU8ki1KfMQ+f3UOEd4qOB0zAQeisgrgmvlrt+ZaoGbT/RfnFjAfPIZsc8Ol1yy2hb0kUYOtb5Fpo0ae5bJLJvJWh3CuskUk3F0P4uIEv3Uj43Xga5+u8rxppNBQxn7KR4t0xBCXFrcVPMOB2Mq2t824d+IFfPaSU5JDw58pp7GB9rMHYjSg+K9+b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:29=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> 8 byte minimal SLAB alignment interferes with KASAN's granularity of 16
> bytes. It causes a lot of out-of-bounds errors for unaligned 8 byte
> allocations.
>
> Compared to a kernel with KASAN disabled, the memory footprint increases
> because all kmalloc-8 allocations now are realized as kmalloc-16, which
> has twice the object size. But more meaningfully, when compared to a
> kernel with generic KASAN enabled, there is no difference. Because of
> redzones in generic KASAN, kmalloc-8' and kmalloc-16' object size is the
> same (48 bytes). So changing the minimal SLAB alignment of the tag-based
> mode doesn't have any negative impact when compared to the other
> software KASAN mode.
>
> Adjust x86 minimal SLAB alignment to match KASAN granularity size.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Extend the patch message with some more context and impact
>   information.
>
> Changelog v3:
> - Fix typo in patch message 4 -> 16.
> - Change define location to arch/x86/include/asm/cache.c.
>
>  arch/x86/include/asm/cache.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
> index 69404eae9983..3232583b5487 100644
> --- a/arch/x86/include/asm/cache.h
> +++ b/arch/x86/include/asm/cache.h
> @@ -21,4 +21,8 @@
>  #endif
>  #endif
>
> +#ifdef CONFIG_KASAN_SW_TAGS
> +#define ARCH_SLAB_MINALIGN (1ULL << KASAN_SHADOW_SCALE_SHIFT)
> +#endif
> +
>  #endif /* _ASM_X86_CACHE_H */
> --
> 2.50.1
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

