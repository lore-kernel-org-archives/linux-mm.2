Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14F2606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cd5H1Oma
Received: by kanga.kvack.org (Postfix)
	id 67B256B05B2; Sat, 14 Nov 2026 13:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BFF6B05B3; Sat, 14 Nov 2026 13:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569C06B05B4; Sat, 14 Nov 2026 13:58:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3607F6B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:58:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8C04A796E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:12 +0000 (UTC)
X-FDA: 85434634824.27.6827F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 292891C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cd5H1Oma;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682691;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxPq2U7O82eKRlrQ74u4bm1nY7deVefkzjnyumG6Oys=;
	b=Td4WxqonQlDlpHGEZ0FfO6FMaHQpURMVfDk18BYFEtzMocp//PfftUgbT8nsgr2o1fX5ge
	5IwIMMILz04LEta0L+NXVNUoEiqNF2FelceH/IjDj4rP7pgAOTgBFIK+GXHmK+aGAZiDav
	gm1EwxiVOz6A0xsxkDHHKMTIAF4f/ds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682691;
	b=zyzq5aJE0MiE08oJjPSe55e+HxFaTI4oie8fcEp4Ue9sS65LkXTmfl8tWfvh5zeMBARiv7
	HfArTOPRKh8n5WhRO0VjFMV8bRaLtbQjhH/1PvE0l+zD4q4PwDYABb3txJgZJVand9xmS9
	pUu5W+vkcrFfN8Lmu7NkGL70G3dgnOA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cd5H1Oma;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C661360E15;
	Sat, 14 Nov 2026 18:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7DC1F000C4;
	Sat, 14 Nov 2026 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794682690;
	bh=TxPq2U7O82eKRlrQ74u4bm1nY7deVefkzjnyumG6Oys=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cd5H1Oma8qt6TtPtH3E38FmMyo40PMtw0P2UXzCRV+StZKwFS3MVDY0Exye4PkwJ6
	 57h3jdgsLOLhBIGNj1Tdp0DYjdXhdzF+mEbfkljp444X0+DRwv9TsZRPnTOIwH1mN+
	 kAd1oxCI9IvDLnTAz3qqcQsc1YS2YuUlPyM1MKMpPDKoQg1jMM4WjDzox7y2I43jbl
	 z2/BJ5cndFLZu3C1s6ggOUQ7qYnjtxCxMrqNdfskuKDrRORP9Le5pEsrXyFGNDl3Cz
	 gHp5XbMXBPo1HGtC00LtDgsfzePX1+f6EiGOugfHEK3TNMLpAbm3fNvYuggD1DxETU
	 A+CAlS7i4JpSA==
Message-ID: <sashiko-outbox-214931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/10] scripts/gdb: Decode compressed stack depot
 frames
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matt Fleming" <matt@readmodwrite.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Marco
 Elver" <elver@google.com>
Cc: "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Oscar Salvador" <osalvador@suse.de>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Caleb Kan" <ckan@cloudflare.com>, "Caleb Kan" <calebkan1106@gmail.com>, linux-mm@kvack.org, kasan-dev@googlegroups.com, kernel-team@cloudflare.com, "Matt
 Fleming" <mfleming@cloudflare.com>
In-Reply-To: <20261113185702.1332171-11-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
 <20261113185702.1332171-11-matt@readmodwrite.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 18:58:09 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1azq4hghf588b8jxaorg8k1wj5bpmq8j
X-Rspamd-Queue-Id: 292891C0004
X-Rspam-User: 
X-HE-Tag: 1794682691-960342
X-HE-Meta: U2FsdGVkX19zf0+MopFHO/kWoDhWbivcKTevocLrjUXHogwZ/Xsjsj8ezPo8mpIPrK9hIWKXaQD+bjq09W/iepqNhMt3yUFkpBQpQV8nGkxtFanv//DouGnaXY7NcHfPlVsYZBezkz191ZMqSI9dNChWY/CVe2+03syo74MOjpsrX2+k0/mNDaQ51wXuMn2vVeClZvfF08SqqYYldu8bTa48moD3CHAk/kg8zesZVm3s1dAb4tJiqiirjfMVUnh3UvxFx4Xyi88pJuujrBgvewaeMH0e8tJHGnbFjxrMnG36eNWhs8Xm5lOgMHBVIHG2IfUHTyA7iHNdNPmafta7eOIqW6bq0aqnh/blnCvOXlitTPIafpm2aLLL+zSr3h55yZ3+ptLc77FvavyCoHNvs0zUDpFqHK9KC5K5IdROQ0Ohs9xX8qR+ZLbm6gckvd72leRtJ5OOjTxjfL9hPpsqnkArHRo9jvmdGqyoNV4QLfR5dVcID35FjBgKw7fALBCXGfNuldQDRcVV8eR4n2duUFNe2udVzlFiaoEJDUJC//YT6U5ZJrKA2Xjq51HqbdiHt2uMEtpQVMjYNAPScWtnCRTdK0wrG6wXBs9wQ6zNbrYJGbfkEoqQMub9PDSi4H5iJ43hggRNIOLAvnrUH9ZYbkT172Slc+BMz8Tv9Z4OrtnB0kxHAJvBRKVqWW9oDAMlelu/70YLBXDDVmDJwg3Hsvl6LDrSW8C282/fmz6rqWM8H8QQ530bOcJpDt9GgIVdgMGU6UlNdkjVwc2XJNGJL0Xii5eVuDJS7F0ceGOQDv7c79zXKBg3uBRvydwKxrGAYhQnURDr9Ydig0vu2NNOqvKS+hmlXi6lD+0kYfTE+uXAbNb7sKCVUpixuVO/xu8w7t707yOzqyUuXiIS2XlA8oWKdkSTwoDRaOfztQSrNmiOxKViE392Obpu0lxf13j1jbwzbLPBoM3y7q+vCuv
 kVR6Vj8I
 6DY7KSlTU8yufoX6S8J58CK4YT/lEVcoCYm1WB/1TgVWw7BIRZyM11aSzSy1wKNeUlx5jRpkXuaQWbI8ifgXIRSJ8DBaKBjIsbi4Dq7eFSjLw40awa77mBGb8p191wcUgGzmwlk8Nil3TY4/3oQdtKJhk7ye1qN1UF+/ZwlZAN2RcAdDLmk3MUbJxq0uBb4zDXqmPq4EjhDvwQqQ5VtmJAFGAqgalHFxfRPKMXNBHQ69UB8d7UPmVlVivJqTElLezaoXaFgPfIGMKNnGYHNvitilrmCRfgRic8W3YAir4P8HAtHsMppelYDkdE7McKDoiSlq2Np/lclU3LwrYlBPph41V9IscqOKSfPrKXCd9oi1pfqnB7w4X25ciMslm478vWGO4TaH/8tfWQ3UB/qA1ZY0lEzPnxVR9ODIoKoHDtt5aHFjoNxlXLgPmYxzrISyl8MFbCFJP6bdwEiCv4zb3p/jzXLh/5tYHJugr7xWLSmQfBW3PGOoLfqF2glWkKEnJCAxlQeZSyOcfppI5Ib9jtIXkRJFFYGto5q0OjK+QLA0Z2sH5hsafrfmymMQmVJJb5jbyEmMUl8MEP6iTESJFnE6NcKivAHBwnjwIM2ua9YZQCiFVGqqatDbW5ZfJaX52dyJGZdmx3xfVW/zhjAIZr/zzZ6y2zSyE34nLLH+nNyYcPnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scripts/gdb: stack_record_entry() reads _text contents instead
  of its address
--

commit 9494b015f36a201275730fea0979762f1a250f80
Author: Matt Fleming <mfleming@cloudflare.com>

scripts/gdb: Decode compressed stack depot frames

This commit exports STACK_RECORD_COMPRESSED to the GDB scripts and decodes
compressed stack depot frames on x86-64 and arm64 in stack_depot_fetch().

> diff --git a/scripts/gdb/linux/stackdepot.py b/scripts/gdb/linux/stackdep=
ot.py
> index aaa18af25cd12..f689cacb3cb70 100644
> --- a/scripts/gdb/linux/stackdepot.py
> +++ b/scripts/gdb/linux/stackdepot.py
> @@ -20,6 +20,21 @@ def help():
>      gdb.write("Unrecognized command\n")
>      raise gdb.GdbError(t)
> =20
> +def stack_record_entry(stack, i):
> +    if not int(stack['flags']) & constants.LX_STACK_RECORD_COMPRESSED:
> +        return int(stack['entries'][i])
> +
> +    # Mirror arch_stack_depot_frame_decompress().
> +    payload =3D int(stack['compressed_entries'][i])
> +    if utils.is_target_arch("x86-64"):
> +        return 0xffffffff00000000 | payload
> +    if utils.is_target_arch("aarch64"):
> +        text =3D int(gdb.parse_and_eval("(unsigned long)_text"))

[Severity: Low]
Does gdb.parse_and_eval("(unsigned long)_text") read the memory contents at
_text instead of taking its address?

Unlike in C where char _text[] decays to a pointer, _text is defined only in
the linker script as an untyped ELF symbol, so casting it without & in GDB
reads the first 8 bytes at .head.text and produces bogus decompressed frame
addresses on arm64.  Using (unsigned long)&_text, as in
scripts/gdb/linux/mm.py, evaluates to the symbol's address.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113185702.1332=
171-1-matt@readmodwrite.com?part=3D10

