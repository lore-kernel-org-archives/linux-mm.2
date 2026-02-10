Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7A2EE6B73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017076B0005; Mon,  9 Feb 2026 23:16:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCCA6B0088; Mon,  9 Feb 2026 23:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE81C6B0089; Mon,  9 Feb 2026 23:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C69A96B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:16:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5565E8B452
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:16:36 +0000 (UTC)
X-FDA: 84427235592.06.C096B3B
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45168C0003
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:16:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=bPjZ9Y2g;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770696994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMA+e7t1AQwEppF56ecV3ZH9XLnQSHpFgr1CYZ9e58g=;
	b=DnGf4jUaj+08i7hGr5L1+/QFCeoIx1KWN9HK18HmrQcNsLrBT1+4UFTcqGM1JUxsxjsyP9
	qR3zWgXp4ckPsFwfWbSf2d8wenY3CB5xjBezkOHLiuV6JdesUFPl10DFDplv1Ho0N+fxu/
	6Um+sFtT7JzKSJ+BD1WfyYcPalUAL20=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=bPjZ9Y2g;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770696994; a=rsa-sha256;
	cv=none;
	b=UN/1B1F9fEfsF6v4oEOrNW4KrpP8W7ZrGZ6QyWK6SVfx4VuGjHVnjI+mW4Yp+sFPRa2YWH
	uiFPqiMfN9JJJSddNp7HSHCJXgg/ieNVKzXqNrSscLn8IQutzKtFGPUQCMGWnOfCcTiDSF
	EjNbi0o8X6WZ4rH4uoR5+DSgp6PT/ck=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A4Fqvg3149966
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 20:15:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A4Fqvg3149966
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770696956;
	bh=lMA+e7t1AQwEppF56ecV3ZH9XLnQSHpFgr1CYZ9e58g=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=bPjZ9Y2gc8XthT6zR8auXTW7LY0+PoYLaGLDTGvP5fag/zuiuP5tQ6Cv1wveyTm57
	 ErTx2dN99MNaspd+H16qZxFGNWq4gETPUsrJoDgKj1PTeMhC7npPFbbF4bIVa8hIoO
	 NukcLD2uJLbiJ77RYGLeLH/E/TPTD31/BxU422+TVn8WU5ZP6uSWIObtIO9TNOQPtb
	 WrO0aiPQ/p3gP3xcrmc3gdEICDoxjGG11jNeQb1yAwO2td78+CCqjwFIVAJD9j7qFu
	 w8xSdWmfKueV84Yjuxx6TQ07qAZiYO5eLrXtTlCq8NvgnA8cMYxrSIKl+Ol4AJQrzF
	 13NMFFJ2qFaNg==
Date: Mon, 09 Feb 2026 20:15:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xi Ruoyao <xry111@xry111.site>, Jens Remus <jremus@linux.ibm.com>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Claudiu Zissulescu-Ianculescu <claudiu.zissulescu-ianculescu@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=2E1_06/10=5D_x86/entry/vdso32?=
 =?US-ASCII?Q?=3A_remove_open-coded_DWARF_in_sigreturn=2ES?=
User-Agent: K-9 Mail for Android
In-Reply-To: <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
References: <vdso-cleanup-patch-4.1@zytor.com> <20260106211856.560186-6-hpa@zytor.com> <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com> <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com> <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
Message-ID: <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45168C0003
X-Stat-Signature: dczezruz1hadqhjz69y4iqq5ukdu8bin
X-Rspam-User: 
X-HE-Tag: 1770696994-204028
X-HE-Meta: U2FsdGVkX18dk+Q7+eLKiF1ayf+oNjCg1dEV9YTjD7G/qQFLKUlNnjUYcVgJqxZQ5UvsypN3TRp/kajCCthpC5wesBuwPStiv8ZXskTC4yCH+mMCaAlkYxXXkjNmtLGDCVSby+xP+8d5ZEBnk6tqjY8b9eIs343oUC8YkiKgvwDUOwSz6jI5kNbsD0RCjCDnQxdSVMMNuLtarFbVsI2yQr6CJBOJrylshgM5y9RgniqKoIYcwOHX4HqzzUcgqw5s3NyyN3fZ0XrGJ9JrY/gw+ytTLI5zuAmzwTnufrdr9mkaKBO+Llqm5yWU2gIUejshUhOHZI1cp4qbMMl204sTL7WK3vvs6ffsIT/Lks9BdkLI9FWraC3CRIAl+rlWvDelxgL6KYQwP2b68S9tdYqP6Pf8by9JZt5kbdC39cpIkqZxETnNvQzUkeBNvkiDrh7OVEnHvlHTKveHzOrG+FNDOicYQ8z842omyk7OlgmSRD+2V2FjRUEhV3/M/st7XCnbCsum8OP2ynS+ld56BJ01r0c76JIUnkbWO3KwIxaJDKdNL4k7F8KOyL1CwwZixy1jF8QFHomBBL93+/0uHu+NV4owjsvnXPI8clwmoiQwBmRXwAr+6ZaMJ5EfSnemJXHDz4a1jw2N92Rpff3JZFVMMmKFcWEd+vmfGZTlSibu/L19lNP3NYUF+9Z5OCFReLkzH+UZ1PvhbBAdwkBbGx0uFOXBMSeR/a8wMzexB8q6X/BL+IEBIhZzlbHLbWx5b+jaoIMXZqBPUqwpfa5kvSqP+VinacUcr4aYo8qvToyAvB8L82EQOJetYjdwHTsGEOGeBRyLW4yeeLcbIcv/0A1XV7/fxjFuoYZpIMgh6LHZZQAknMChOYEMmLCUN8aqSh/GTDQfXxuu3UOr9qiQWLCEFDEdoF3PmfBMNwhpMUbL176sJvC30RDmc6fw85FhDCFKZc3ADxl1JnbjrKQFal+
 ocJRuUs2
 VKLyNRZx25Kw2RCMlmBHjiYO38LjfHVr5BlT1MK+mcdsKHEI04XCNtjFeW87UAN5lfCJbhxe++t+uKRB0lRf1gNVb3PH+jgCx0DrVDPZNLEneU/NovYkDO9L+t0ZKM++jtPzOJRBLfaf5cQrUOxWBxSjH5bJeDenwvznFfq/Km9W9/sVMzj++tV1evHyTNZvzSmEbnbe3sHRjiojBWveYygjnVjV8GXWkpO88fF5tBCJNochSevOX/Ijz9gVvHJ8Js7X+DAA3RJeWQhRT1VpAbifEbU5GdpZFAGOfxRpBdcn7ju+EhnrfXDn7gXjkHuC+yy+EpoW8HeZzgYjXbsW6Ym0jm/XUva5ZwhGGWr/o3bMOnWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On February 9, 2026 7:11:25 PM PST, Xi Ruoyao <xry111@xry111=2Esite> wrote:
>On Mon, 2026-02-02 at 19:57 -0800, H=2E Peter Anvin wrote:
>> That hack dates back from before the signal frame extension=2E It is no
>> longer necessary=2E
>
>Unfortunately at least it seems libgcc unwinder does not handle the
>signal frame extension properly=2E  The code reads:
>
>  fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (context)=
 - 1,=20
>                          &context->bases);
>  if (fde =3D=3D NULL)
>    {   =20
>#ifdef MD_FALLBACK_FRAME_STATE_FOR
>      /* Couldn't find frame unwind info for this function=2E  Try a
>         target-specific fallback mechanism=2E  This will necessarily
>         not provide a personality routine or LSDA=2E  */
>      return MD_FALLBACK_FRAME_STATE_FOR (context, fs);=20
>#else
>      return _URC_END_OF_STACK;
>#endif
>    }   =20
>
>  fs->pc =3D context->bases=2Efunc;
>
>  cie =3D get_cie (fde);
>  insn =3D extract_cie_info (cie, context, fs);=20
>
>Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
>=2E=2E=2E _Unwind_IsSignalFrame (context) actually extracts a flag in con=
text
>which will only be raised up by extract_cie_info=2E
>
>Or am I missing something here?
>

Oh, good grief=2E=2E=2E

How does this possibly work on non-x86 platforms?

