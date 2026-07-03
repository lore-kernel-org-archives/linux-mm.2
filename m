Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92558C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 21:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23506B00B5; Fri,  3 Jul 2026 17:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4836B00B6; Fri,  3 Jul 2026 17:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3466B00B7; Fri,  3 Jul 2026 17:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B04CB6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:32:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D8191C7982
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:32:38 +0000 (UTC)
X-FDA: 84948764796.17.7307552
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 63A2518000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:32:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+X+Ve5r;
	spf=pass (imf24.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783114356;
	b=d4/OSVjhvRz4SjJstNZSnB+pn1DyRutBIYTb5+QqNPwKY3GQPHBW68ylXJ8njHWKGOc6Kh
	4Ng1+CXYJY52j876h/e1GPNIDQgE1xIIpCqnQFRuxdKQUQuRtSP0FLAmgxCulfHX2gMWYc
	NhCuH3q323xNVknYM1q4ntM72UR4o/0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783114356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKSIV0oOxnrYHCfPO5lAQhnCzHPQePBOMJ0ktW8HRY4=;
	b=8lHtzyA0zYI2+aKFdij1X33Vez+jqeKescCbIcRPor28oGnPXoADG2nkzOwtfhBfyy+S2V
	oJmApm1iUJJkeDhYU93vu5luVbS7Jz1SKC+GEnum2VBge+O8l3IaaXDpFoMy/NlyzjAXm6
	Y0dn92EG1cnvo658UaNzJvAVj8ZihxI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+X+Ve5r;
	spf=pass (imf24.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB20A60154
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9851F0155A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783114355;
	bh=OKSIV0oOxnrYHCfPO5lAQhnCzHPQePBOMJ0ktW8HRY4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=L+X+Ve5rFFmAbHC8BOi+ZIIcP1cQ+6P0y9xuzBuOhkmJ2QjJzMsScrnLbDWzVOq2F
	 CDRw2e90XyAgpu6/TyMFoNgZzEENGTgomFDlUcRuJm9oewwWG9q5ETEjSU6LqIhsGT
	 RknHnNUy5yyQndrBMUliVhBzY0Qn/NmCqHjYaJCADLnWhwzXCHKOuadPuwGNjxwDtA
	 egtpUpasm4nM/6WjRe5gSPw3czVm2DxmoU+KdoEpFKeTbOVDwjgFoFvjj0A5eoNhxe
	 CvE2MRoo/X9U67HLSaLEtE3VRR7CyjJyzx+odq7ir+bVHPCL6tick8FTkJRObVbtD3
	 9rin1/KYJiA0g==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aeae350e0aso860518e87.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 14:32:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro50qe+Lg9A0Gy2+Ws+5DsNldq3EF5NqoXRpbdPnjGTdlsla3/VnUm3NZrKhHAVdY6gMiEb3vTnyg==@kvack.org
X-Gm-Message-State: AOJu0YwpI7DoNxLX50ATOCXbbowTGchqNKa7rOiMKSPStRWBTg+rkPAs
	ZW1TaH2rL6aC8Ujs6/iEpYOnhoS6vDppGWqTB6UOVZ/FxgnupRLICSwnuZn+2eCyDS7x5A/SZsc
	nAn6RTwxf3U+TLxrTBANgcL20vVdJiKw=
X-Received: by 2002:a05:6512:8391:b0:5ae:ba2b:b469 with SMTP id
 2adb3069b0e04-5aed5092745mr72984e87.18.1783114353971; Fri, 03 Jul 2026
 14:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com> <akdp6GAu77-ipsXA@kunlun.suse.cz>
 <87cxx4mmim.ffs@fw13> <akeIK5TRCjlKbzbp@J2N7QTR9R3>
In-Reply-To: <akeIK5TRCjlKbzbp@J2N7QTR9R3>
From: Linus Walleij <linusw@kernel.org>
Date: Fri, 3 Jul 2026 23:32:21 +0200
X-Gmail-Original-Message-ID: <CAD++jLn0Pfhx0bY9XywVkDVU-nyAbvrnf9Wr8TSkuV4hgJL=8w@mail.gmail.com>
X-Gm-Features: AVVi8CegcPVBpxUBhMgaVmjHkjMbMgWpKQVd4voTgZ2p1M7BcZ7lo9TMo7bB8LM
Message-ID: <CAD++jLn0Pfhx0bY9XywVkDVU-nyAbvrnf9Wr8TSkuV4hgJL=8w@mail.gmail.com>
Subject: Re: [PATCH v16 01/18] seccomp: Convert __secure_computing() to return boolean
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>, =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	Jinjie Ruan <ruanjinjie@huawei.com>, oleg@redhat.com, richard.henderson@linaro.org, 
	mattst88@gmail.com, linmag7@gmail.com, linux@armlinux.org.uk, 
	catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, guoren@kernel.org, 
	chenhuacai@kernel.org, kernel@xen0n.name, geert@linux-m68k.org, 
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, ysato@users.sourceforge.jp, 
	dalias@libc.org, glaubitz@physik.fu-berlin.de, richard@nod.at, 
	anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net, luto@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	chris@zankel.net, jcmvbkbc@gmail.com, peterz@infradead.org, wad@chromium.org, 
	thuth@redhat.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com, 
	yeoreum.yun@arm.com, song@kernel.org, james.morse@arm.com, 
	anshuman.khandual@arm.com, broonie@kernel.org, liqiang01@kylinos.cn, 
	pengcan@kylinos.cn, ryan.roberts@arm.com, yangtiezhu@loongson.cn, 
	sshegde@linux.ibm.com, mchauras@linux.ibm.com, austin.kim@lge.com, 
	jchrist@linux.ibm.com, arnd@arndb.de, thomas.weissschuh@linutronix.de, 
	sohil.mehta@intel.com, andrew.cooper3@citrix.com, jgross@suse.com, 
	kas@kernel.org, x86@kernel.org, linux-alpha@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-csky@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-um@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y649rrh71ekpn8bojsxgfksp9fzei6am
X-Rspam-User: 
X-Rspamd-Queue-Id: 63A2518000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1783114356-136132
X-HE-Meta: U2FsdGVkX18XGamwMANm4/36RP6Z37xvQLglDfPXBA42Yj7IUwzxs2w2J0vvUSkASaF5Zhx8BiPvEWCycfD+K29+G3CyS1VEfEz2+ze3TiChPdcw8xIwrlvRACyj3OAfrvSohsQbCUeVeYAUQpWDK9Bxg+OASIop0XMwpWz8ovTJpJK0o5C5hdoLB7UC1K+UFDszU8K+leht030alIAsJJYFP9Za6C257fSG6gVRDSB7V68u8JRVHzP53c82F3P8BHb7PrtwDLZuV6SNFQBWv+tVvg+rXPZkWiUofBA3ov2CzoufdIB/MjOnSu4Ld3sTK/67UDz2nTOCqo6ZsUOp/lq+JKeE/Aevo3t+Fqzw+O95LdoxcZxURPqfIfVZ6e7ZRGv5LEte7ILxJM8BKZnQts2uXW3Ejc7W2zwaj5IMvr1eGCjvWp1vcacUBtepYfUvphtfid9Pd+ND+KYAjwgB/epFM88BNEJpbzYnzXYel7t9KtwOttJWcPZMRrPYd5vAUVW0oFhRxUWJRHQkUPnGpk7wmHi05pOdIup3BOYFPDjChrcP+foOTOD1f3Am4Ot5fMzkF5z4M3fwwq9trK1w9X1pp4mCih9rOqtZhWuIvKLcBocxgp0lXEHUApiHF6otSwUaOtwoFrZnExV2ikWoUlEIey0pYsw1+AZXUBHAPBDZ5OO6sMv0/WT/Tufn7RnX4uQkAj9ptWDo4hrJVXEha6V5BFZqb5TvLmXTCDPwazoWhwBUxTtUxntsw+CZeJPYqZTyomsAYwgc4lbX4m9gAVzVLgASbjisKvYzMRZncGLO37a9Lsl/ir5oh6b3oenCulWItiCl1S44Kgxw7Pq5jubu8/RDUFCP6kHHpd/6PhzqyMM69hgZ22nxW7q5AQHwcs3Wj3yv5Mw7x5ffnlwSk1AMkgqvO1B8yBqH1or9aUHTojMTkfq72jFnr49JNZsIipxeL1JI2XQGBmYFf4b
 paD66mMA
 L3uUgZ2w0un5Yr6aCmfwcWMXsjMn4GA7cdcMK0H/5djF1fxSUYbhgMufF4AOKDEJbh39MxLKHukU7jTUsNub1vLuqUYB/Fsh/pu2AUiGmg9DUIMHbMxnq5ScXAgVoT8v6MX4uWoq+9YvJzNcDB1qJn2XwsLyUN11HLurNZCRV4j1JBIMoEHYrIQBsKO2BNppIQmvDkHfWjC6nrlMZg/QBvu+AjsWyc0v0jtOQDaawS//b6qI7C2ggyM7GKHFVZETcKXY/PGuaqj0k1NeNokQ2ZFevI5CSP19oUnnCbvxwFE37IBmdJ1u0u7q4GI8JOWeyham6gsyv8+CpVQkcaeHLKbmzRbNeOFl8X8gRl5qecPwfG4INXcJW2NBiekNsvCTqKZHJljYh/+nf02HXKjG5d1SSYN2aw0GErx73
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 3, 2026 at 12:00=E2=80=AFPM Mark Rutland <mark.rutland@arm.com>=
 wrote:

> Bikeshedding below; sorry.
>
> I think the bigger problem is just that secure_computing() is a terrible
> name that does not express the intended semantic -- it's not clear
> whether "secure computing" means "seccomp permit the syscall" or
> "seccomp is enabled and some special rules now apply" or something else
> entirely.
>
> If we're changing the return type, it might be worth renaming the
> function something like:
>
>         seccomp_permits_syscall()

Yeah that's way better, let's do this.
(I also had problems with this function!!)

Rusty Russel's API design manifesto tells us to do this:
https://gist.github.com/mjball/9cd028ac793ae8b351df1379f1e721f9

Yours,
Linus Walleij

