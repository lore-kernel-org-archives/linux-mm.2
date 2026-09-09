Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED0AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE066B0093; Wed,  9 Sep 2026 09:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2687E6B0095; Wed,  9 Sep 2026 09:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E3C6B009E; Wed,  9 Sep 2026 09:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E92AB6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:13:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DC581C0E6D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:13:36 +0000 (UTC)
X-FDA: 85194265632.14.AE7DD70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D9BFE1C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:13:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m1/4Stf0";
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959614;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZj7gcoR1BSM5qRU6zyoL1d1abYxfkHpfCAN9EDmS1M=;
	b=NOLUcAyLPZWojDP4vY2+AGwG1h+xbkeGZzpRLWD7VEUS6EcRKSKJGfGnTupIkzrx1mc/gG
	5s5/jJTg7SKRcSJi+4GEtT6GZQ3Oi55aTtQ+tp2AFv/Jdq33lsSysFo7YIto8Yg22OYMSh
	zEaKqWxsYLtZquEO61KphZpUSDkSD/4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m1/4Stf0";
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959614;
	b=aIxmEUqOWV+4YTS6AzPDjoT/RiohuQ7Trfggmiaa3cCCzq4KTEaJRmADyjWKfoKGKfWBjO
	JPZplGyNiYbpPq3vBzpd0eoPIPi+rmMEXHRnTzqAFVqquMbMIjxUMQjuX5LwFcLeMND2HH
	qyBbh/yPSgfnIqi9NmydjEzD7eqhx3M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32ADE42B83;
	Wed,  9 Sep 2026 13:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BECD1F00A3A;
	Wed,  9 Sep 2026 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959613;
	bh=IZj7gcoR1BSM5qRU6zyoL1d1abYxfkHpfCAN9EDmS1M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m1/4Stf0ONAeUDQwpGd2ObDI4Y1eUAi/bIJeo3Kg/A3Q4m++iPAtNGiq119atWnZi
	 /1Qj8UCIt68EW/K8SkdnNb2muOzmu8IfBBZL4/DN4hb53pE4PI0oomqX+wm/Mt8q+M
	 UYBAkF2jGPLZCEGNzHB5LJxRE7hwUQ4jmmtfEqQ8Wt28UK4W6myJBSi6sfNOPWWx6Q
	 /iTvGzpidk91r6b78Ipmjhxg3nx52Y2hBdHDVR3sAA9sFUCqHA8PAM6LOKRQ6JBB8z
	 Pi2OrAlsfgMSBia74jxXsVq2C4ZLCvRj8Vr0VhyJILFcI6NHxdYTmrmeiisqi5Xe0F
	 +LS5tDzC2tsjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/5] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Michal Hocko" <mhocko@suse.com>, "Zi Yan" <ziy@nvidia.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Mike
 Rapoport" <rppt@kernel.org>, kas@kernel.org, "Suren Baghdasaryan" <surenb@google.com>, x86@kernel.org, "Vlastimil
 Babka" <vbabka@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Breno Leitao" <leitao@debian.org>
Cc: rmikey@meta.com, linux-kernel@vger.kernel.org, riel@surriel.com, harry@kernel.org, linux-efi@vger.kernel.org, kernel-team@meta.com, kexec@lists.infradead.org, linux-mm@kvack.org
In-Reply-To: <20260909-hwpoison-kho-v4-1-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-1-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:13:30 +0000
Message-Id: <20260909131331.1BECD1F00A3A@smtp.kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9BFE1C0002
X-Stat-Signature: 3mu41jdtoocswpbnc7bytwb1jidt77ru
X-Rspam-User: 
X-HE-Tag: 1788959614-381089
X-HE-Meta: U2FsdGVkX1//KYB9z0ooxiX0fqJKhQoPDlYXYZBW0DmSQgPxxI+9T2szibaJ19yHBJdbGISZPiQjgmzI+ZwYE8Zjf42sGId8eIJY1I2FKrVhac/w+o2KUpubUOsMpL/i92FnrsEukuDhJZRxEt6bIIPBXWy6/aP/xhogOmqEavVyiT3W2xwXXb+StxUkgohnUkHXhaE0/9UVTGy9XTZWRdT9zszp0s7RvnX22Ix/dbJJpCkZUmUOcns7WW+qbTn0WfWTYwo9OTeFYcNr+ZdgSi821Pr5oicQpQNedLkng074hkEkKaQYxWM8dh8k78RW/iEKc97nNZAH+PJmLU6+UWHztGv1JKWQFcovAJsFbGQGVjoNwZBtv7nRV/WOT0yWWGdL8HKaWxyRqGdOm1AzD7FQ2DDnIZpcXOTFefAdG3U456cOFVNMAMolLCdU4RysyD59o/1CT+cHl/r2d/30H4820yzDWLTZ5McuZ4DWFewddd5PKcCnYe7Liu/Ue6SUSVl7nqiGKmrmC6OF/X/Ei05plBEzW0CfnBrXQvnSIIGM/ym/1/Ztr0TK70oNeqvlc0ukeza/asrx+fjpug/ktcbzdFYgSfeVVCOj8J8RHOa65aslLInrwBbn1u6mnn8OitpzVJhPdLFXbiZ1rgDr6tGUk28nnd3lbJj3gCuH3F1Ub6Q8mk/emnEWO+7soWS25BxR4J3RNQtEEwcrM8orzNfUAuGhM72NIixhvY3OL+O0adXWLXxa7ocCR6grWlPxznjgkHf/3tBbpF9qtliBR2fYiRVFgcUgmTrhefms57jswBrQW/1puxuc4Cl7u7P5a9045LgAUSBo8WAOEipJHHmcr2LUUCR14/agWTj0guqrsbA0CodgjB22VzHWisb4vtISIkYhJo5Kp+2SCiwvi/T0m0ipV29S/9gkFHzRsoUUF4nUonB2wfr6N+d20cGcXDqRmYmroST8lkgsIUl
 WkpZpOzX
 RHt93Pd+rj7AyEvEyF8q27E096Nf2eD/FnFmUeKKHFHhZDOcElJPF2aOXD/aYCy4l6d17iioI8W/n5WcAjv9Hn7HIenW22cSwMe2shYo8+0ydIZNFSepte62zUfKUdO9h7klfTQ7dlVjp1aEffKpNAA0671uSZKeOape9n/LWwk8Kg5kcVEzQTsxSuit4ocAeDdRwCIghX5+rTNaJqgcBph/eIMs+/1daiGj6G9RLQW0i99tfG7neQ3s7ZvcG2fbA5LzFOw6KNkGiGfEwRRwxQlSvysgIZlg8Vdb11dYpXIOUvR5HeVbyVyrkmygzjA3ts49DzyCFiVqZkZx9uYRLxqtbnYiyzBCfZ4eOs+obPy+W2BXt96/po/i2/zqWYsQID60sZUFEsKMnZFTCz9Qxqp62hw4QwgoT8VUGBbb8VK6nG8ghiS2FrmebhQZCFzUHnhtKwz6T29nwzOEtVo7xnbtRY3a27cgqhkeoxuqluRyvxaxEExjr26CmBz0WGIGrRXlQZRZd9nutyhpHc9A5kLonD+amqdoMExruSrDouejYh/SfxZxmGqQzIEw+UxkKLiAxPGpwE19mYANWvTQCv0gb+MkY3TUv/10sgwDvu2WOuCuTZet+JzdqW2QewZbFr3zYcktpA05P62IlQoe7I65GWQK+Twn4vxehJfzP95VehF0JkXt9gDgiTkG083fmvrgezEIONwkrgv1gdVaaFUuIpvyva1Fa9fyJXZTWmvC/weM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hardware-poisoned page frames are tracked only in the running kernel's
> data structures, so a kexec loses them and the next kernel doesn't have
> this information, thus, tripping into them again.
>=20
> Add an EFI configuration table to carry that information across kexec.
>=20
> It is a bitmap with one bit per EFI_POISON_UNIT_SIZE (2MiB) of physical
> memory starting at phys_base, modeled on the LINUX_EFI_UNACCEPTED_MEMORY
> table, and it rides the EFI system table to every kernel in the chain.
> Basing the bitmap keeps a machine whose RAM starts high from paying for
> the hole below it.
>=20
> List the table in the x86 efi_tables[] too, so an SME host maps it
> unencrypted like every other EFI table.
>=20
> The Kconfig symbol has no prompt. There is nothing for a user to decide,
> so it is on wherever it can be, and it only costs 64K per TiB of RAM on
> a kernel that already has the EFI stub and MEMORY_FAILURE. It is
> restricted to 64BIT because the unit arithmetic would need div_u64() on
> 32-bit, and there is no 32-bit EFI configuration with MEMORY_FAILURE to
> test that on.
>=20
> This is a similar approach as used as unaccepted memory.
>=20
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D1


