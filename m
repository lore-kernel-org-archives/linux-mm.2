Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDEEF531CE
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4856B0092; Mon, 13 Apr 2026 18:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A926B0093; Mon, 13 Apr 2026 18:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790736B0095; Mon, 13 Apr 2026 18:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64B1E6B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:20:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E13DD5835A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:20:27 +0000 (UTC)
X-FDA: 84654952494.15.E381106
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id D4376120011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:20:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qbgIe8U8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776118825; a=rsa-sha256;
	cv=pass;
	b=mnq8NN+j8vfPJCtI1Vl7quJwfR6NxHbj9UXmbefAMBf3Jqqo+LB+vbmBW5Sp5yUBCpIqmd
	D47rtlRLy17rzxxqzflgLkQacgTOeCPCNBL55IePyZefp+8cgvOVRYMZ5qpECk6AV5glcM
	tE/7J7aCwFTP2pInk0Tfzc6Gyllp+J0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qbgIe8U8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776118825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fp+8IeHiDM+bCUp+Ky89VxSnxaC5A7VFTmU45Et8ZaE=;
	b=uP1QZdapzeg8Q7LcYLkdo0lq9z87UXubTR8Fx+fVqNMDgr1zEw2eb7DXaJpn5c9WuveTZR
	P/YsaeWYLwMLpa5nvtrHGoaWcnb//s0zWQRLyekXkXp7HdzWa4WOayP3FoMshKY1yqd31l
	KcMrNz032L8lD036AomvVAag6zCDIDk=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43cfac48bc7so3370329f8f.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:20:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776118824; cv=none;
        d=google.com; s=arc-20240605;
        b=Uku8la/tcTgcybY9UlBNbV98/XAoSgt8yuvIBpBYOG5dp4xmZq5tq9Ohvut4N7jICZ
         +rUs9mEfO+8GUMluKjoWxwXZN5i0y3q4gTIZkeEX7k9QxEgqrhN1bTCrAZf+2QijBVc7
         OYurLHPso5xNWwhvp0iqUgkN7ZAdEiSvJrETemqFlTi591GDXa+N8mEPbMRaWLYM/Xvu
         Nb1jrmGoTP42F5SBcNKuFC6I8SxKgYGc+bk/wucBZt36C4aoakNkCQgXDO3/kWZ/6HF/
         SJMIxqgXIkuZk3i9q7qf9l+9u4LKDhamwGkeb+PCJglfVdLos0OssFq51YGZsEdGLQ6g
         znWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fp+8IeHiDM+bCUp+Ky89VxSnxaC5A7VFTmU45Et8ZaE=;
        fh=4cG3V6QwDTWqNVGfFcziFEE/aPZXz/IpJpsSzR806XU=;
        b=TDBurERm+TaUPzbc8MjEHN+pAi8mNE8/90HnDekEvIwKCZr88h+bc2L8x9/GZS0Q0C
         DnP0qutcf0W5u/3o+sqlhUf4p1ecnt4nMMR+CF8vM6hFkcEYV9omnOScS0ko6T4mFqQs
         omwS5sQfhSDW11fk6h6b82eDalmyOZYg5l8MY5a80OgSXyU0Y/f2ObBWwwucYK9fIbP6
         o82j5eltUK6EPN3suLV368K73tTZB2nCsqBBc8dH74GPVwOHnpj4YVpwMSxJUhOUZ2DK
         wpHmyeEpLidPD7APLmzCTGYW+rxcEO/03m0cpRlndG03eRfBMH9K2mV7tkys6LrhvICT
         xlFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776118824; x=1776723624; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fp+8IeHiDM+bCUp+Ky89VxSnxaC5A7VFTmU45Et8ZaE=;
        b=qbgIe8U8lOhFtCGzQSqtzxL00jH0xCjBW0BEybip4IOV4yb4RhBGGED/ZTeImE3fyI
         4m+i7VhfrKgWtZUuiDzERRz60fnGnCeMyf9H0iwKODWw0aH4kMDoDinksrkjA9jBLwUJ
         RMibSJe4uh49AvAUqrlpf6CplKWoyp/3W6YGsLrJ4toguu2zsFLc8B6JT0R2T5mXcac7
         WTgIojhOfojLGqffvS5JmdMboAn0v5n7fRQQSlVCq10dLmoLT0VZtkNXUF1H5/RX5Ll3
         fujnuH8fTqJCqkrJzy/Tu6Y337N3WWOWqQ++bStGdw6JvqleP0naU9HFhGxnoxUylkem
         5dJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776118824; x=1776723624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fp+8IeHiDM+bCUp+Ky89VxSnxaC5A7VFTmU45Et8ZaE=;
        b=pgKVBKEui1y1WP3CjEeGT9jd3O13IhZrtRLFmrcOLEp7wawoU/Po4QhbUZSIdK+PXc
         7JNLdhx+JIWzvMHu5i043ecq0BPJQbXABm4yLWfdJWs6V1Aq8FYUR0EEHTuV+kGmtZMI
         Ci7VUIbOM2C+ZB9KrqpPwM2DVmErAetipDN/54MM4xWB1AqHspK9PkEHRKnlPYDWRU81
         4QmBboNoYjSYjiReIy0XNtcuZ60NIWCs/gfsTiQhCFXMF3CQ35KOPJYK7R6fnO73+P08
         VXtpCMbBjfBqG8NQd289lURNZNQIa+Tf4GM97gzLvi8rL/J2xoDuaJ2Un9cfXjQEPcV3
         9nsA==
X-Forwarded-Encrypted: i=1; AFNElJ8XfO/jW3sXDIa+G0eWIcNvz6XjVUI9TUGnCyY0vE8QJcxNDopDnA6te2ucmQdOxjDTM/KZpuof/A==@kvack.org
X-Gm-Message-State: AOJu0YzFSyXzdDasLUYCztSWC4Eu0mORb3wkKrc4jS57W1p63XSHXi7u
	ilSMupsXM9wjShn6TTKgQhBoaKpB+ff8Cami6TW/x0rWBgpBwtMiaDyq2YwZfKoQkvQVFdpmJ6V
	3g3JbxWM8wKCTgkGHDy/2GuMrPYYcu/g=
X-Gm-Gg: AeBDievF8vBLcxfhM//AUQZ32FRvJg7FYbcdXwbeNDqrPidvgiif/7nm4pCOTVuNlBJ
	Jso2aX1NNPYhkQDaeCqp5KwYixxJmD9Shn6+BlfWIqmGfoRA8Gf8PHlET+F26QbGnUfqbA6UiLS
	LG+FAgxTzxiQEJykcT30UDG9ga4CwdFQn6DRFX6JrCCnDBU1rpugEUnhltGyvoQzLVCjI9LYpUF
	zpcJlyfkVkRgSTyMH28fMbbWmwayYTm1aKpMq60Cbr2jiQqYGyMDNSZmzXzfCDzTpwiOyn75sTg
	lBelGfZqiCIhsR1rHzC4Ar0veon2UeFw0mjWrdWF
X-Received: by 2002:a05:6000:2303:b0:43d:7af0:3a8a with SMTP id
 ffacd0b85a97d-43d7af03dffmr7155232f8f.46.1776118824134; Mon, 13 Apr 2026
 15:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-3-1a5831230821@bootlin.com>
In-Reply-To: <20260413-kasan-v1-3-1a5831230821@bootlin.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 14 Apr 2026 00:20:13 +0200
X-Gm-Features: AQROBzASLHf5ILBNuw_x5OeLAHJGUfv8fbkKsOkNoaIfzCwURKyPvUbS0Z-ZunI
Message-ID: <CA+fCnZf-o8tiv_tX9YB5eBUGx17OpztKZsEB6Awjw3WAqBAiUw@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
To: =?UTF-8?Q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ebpf@linuxfoundation.org, 
	Bastien Curutchet <bastien.curutchet@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D4376120011
X-Stat-Signature: 1hqhem5w8pwtpgg6jhybk3zjed3mqhts
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776118825-196499
X-HE-Meta: U2FsdGVkX19S4k+WsIaSlxbJgoQ9UyZkWOx8tE/B1w1qNNjSr1Ca9B96L4N3TcYnTl0toIh/GxyWhMWqptms4oW+PpDhPnyBs5gaa9YeMQWqqAPnM2UbiN4/W9OVbwkumvG38wDuSUqKcsOrsQlWk3cZML1WAbmA1ZT36nTAo33P8RPVXbll51atiZ6mdLbMJ2Qp2rkko2T+eRLH27pTYPMOdkOv7bnsUT49g4W//tHqcC86n+AQGcog39PiI2q111JZDDU7wDwG9RvhhFuhqsKrOEUzh1LNp8caM9tjMwiO//i5UIeWqwJwozGRAAE63MCODPOwecti/fQ27cOKwA2k4KWg3OSpC7wRnHi4uuB4aVlCCreSyN85CaXCKz7H8R7PY2ZUSsdwrgOUfl/rAvyM2quDdjQHqr0v4P9OGAwug8m2hOmZ8EGqUUO+1QPTgmqAa7GdPy8pO2OYs6IHz/HPDZmHrlF2jCiQhO7c7UrvIn0mKpp5/OWRp3z/+2zW+F8NNdZ9iXwU4OxOGo7iCnb+xxdSL9pw8tj0I2z7UVe2R6vRdq+k8DmFPv6dQeodC3yahISdh4fggdE9+cYCUE4j8fLdkItXo0hNhMeTI5adaiEiZ838tqoxn+tPqhcgvVuDOYuo5f0WMGH3VmFoMSIpQ8sE9nnUFrZZKjOMqMUBF/C+9Sd1wonDtBiapx6YyEeavLDiymSSXzNN8i20hufu1pOAQRIHc/g3JDke06tCRMlfo7vX3sizZHz/cTYFZImTHHJMAyzLS8deKX9D7ZegoxsiU/1st1Rn/y5MUTm39Xuiy/7aeM00VtamlDbxfhIkkrQwDoSiYbxeZVTr5ZsTlJ9AOOCSrhkITrq/t/pv32NXcEliD71C/FXyRXFJxLUYmjoccXoiuJEYqOGTo1mLwpJJUh3DBQ03FT8x5eLYF0ECF+yp9mAqws/Kkd8Eb3KvR2bSy7vPHR64NwH
 3rN5VARq
 HQE1VbEY5jFwKPuiiQkV7cRPL8g3op45EtPei0AjvIYjUdAgfrGyVQMLuSS31JzjHpBCIDYb8mUu3XeW/hbIybWDhZVTI3jaV7g9zhsPkK9lb5qXHfGElk+GAnyhy0jI7s58719RDwJaUpcJvVvGouf+WjYHW/WzBtYOsTBZOe/H5NdOEN1WVCnwQaFs3sPCLclnJGZWI9ZYlRx/uoPYU7Z1OiHVizuaeFbH9DRsaTjqSLKa7M4o7/o5iBaTBwJZjGNquzb9pV6PVPHC8x+BaImAWr9NIuQU88PGtcCsyFHAoTm7PBQ+MXrjdpmTMF6mITSZE8RHV0+5JPk/xDaQCDs31ca3NlgJWdks2tktFWne5AXeX6E1qL9DQBrG440sjLz1xLbeFsvLsF3SPQgMbHjHaDzJT9qPanj+U8aQnHnyRZxj99c0dbk2nnlGbEMJNDBoTqaFqb5zyOmrunjufbR6DfM1AeKCf25ZekuATotAwIpmxslabIjEb7O/qwCrrisJVD1RyoUZJG/3MoPube3kd1oIcrdP0VpTNgQqSqYmw0gWH0FecfoDmT5WVGv/FrnVnldfvANpMprY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Foundatio=
n)
<alexis.lothore@bootlin.com> wrote:
>
> Add a new Kconfig option CONFIG_BPF_JIT_KASAN that automatically enables
> KASAN (Kernel Address Sanitizer) memory access checks for JIT-compiled
> BPF programs, when both KASAN and JIT compiler are enabled. When
> enabled, the JIT compiler will emit shadow memory checks before memory
> loads and stores to detect use-after-free, out-of-bounds, and other
> memory safety bugs at runtime. The option is gated behind
> HAVE_EBPF_JIT_KASAN, as it needs proper arch-specific implementation.
>
> Signed-off-by: Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@boot=
lin.com>
> ---
>  kernel/bpf/Kconfig | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index eb3de35734f0..28392adb3d7e 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -17,6 +17,10 @@ config HAVE_CBPF_JIT
>  config HAVE_EBPF_JIT
>         bool
>
> +# KASAN support for JIT compiler
> +config HAVE_EBPF_JIT_KASAN
> +       bool
> +
>  # Used by archs to tell that they want the BPF JIT compiler enabled by
>  # default for kernels that were compiled with BPF JIT support.
>  config ARCH_WANT_DEFAULT_BPF_JIT
> @@ -101,4 +105,9 @@ config BPF_LSM
>
>           If you are unsure how to answer this question, answer N.
>
> +config BPF_JIT_KASAN
> +       bool
> +       depends on HAVE_EBPF_JIT_KASAN
> +       default y if BPF_JIT && KASAN_GENERIC

Should this be "depends on KASAN && KASAN_GENERIC"?


> +
>  endmenu # "BPF subsystem"
>
> --
> 2.53.0
>

