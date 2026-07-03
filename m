Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE647C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 21:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632BC6B00B9; Fri,  3 Jul 2026 17:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3A16B00BA; Fri,  3 Jul 2026 17:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE986B00BB; Fri,  3 Jul 2026 17:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 178916B00B9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:03:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C4A8402BD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:03:58 +0000 (UTC)
X-FDA: 84948692556.23.EA3CFDA
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53B2620005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:03:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=XsI115ZB;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783112636;
	b=D/s9LtAVz/og9XezXTKp41ucFmIJY5v3QH6oLcLtpOdt4CxKVjwd3H0FGr44vte+p9UV5J
	ykVjQ7dGCKgkrE8RgByDzMY4fQRqCOlDykOo2e0gUVdbj3GkmPb4rzF5ynndR5pucwl/dF
	9ADkidCqFauxKlAhd/THciMaceEUSPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783112636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GmRpAk0oLfd0gWfVh+rqnEOK9BfphxBIPqfUy4WToJg=;
	b=UHgXz8cMk4hKPkRwk7268mwNCNVPOa0h9HrLgTGUI4J+Sj29TX8T4sO26RzbLF9PedBkE1
	ZUyGJn2JFJkc0EA8h1AenaY4hOmk71RtTOcm3sTHV0zZEnogmhkGQalt5XV5njIlkA4XBm
	WDp6tqyHOVxB3wt62P1VRKQBjDWQQxE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=XsI115ZB;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 663L1ZSA3634717
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 3 Jul 2026 14:01:35 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 663L1ZSA3634717
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1783112500;
	bh=GmRpAk0oLfd0gWfVh+rqnEOK9BfphxBIPqfUy4WToJg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=XsI115ZBOQE6RF8kLr3qg2nWr/ZTSr4Cc85qgkCOplrXGEthFkxyO4lr4Oxope3Ei
	 uXNwCi3aZ7FCtu+IMJnAqz2+ucRqWMj1Z7USJtc8sJ3JeZ97gpLik9L3v7EKJiITZs
	 v3dorB7yOn0T5r2CkG54hpyoXlryh4wtyjAKA2DelYGyZEF7zAgS971DjfDngm3ESi
	 xNG5a833nv7cyD8PK/+FW1vBKez1uSFK+Mw4JZVnFQTsSNU/45Xgc7/odbqex1xmxx
	 hXA4rZMcbl0HR+NkDB+kp5lErI+aTQzy/C6IBW2f20LsUByG25W5uHpF7doGhQ6iHG
	 wsGBsVIphvsfg==
Date: Fri, 03 Jul 2026 14:01:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Thomas Gleixner <tglx@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
        =?ISO-8859-1?Q?Michal_Such=E1nek?= <msuchanek@suse.de>,
        Mark Rutland <mark.rutland@arm.com>
CC: Jinjie Ruan <ruanjinjie@huawei.com>, oleg@redhat.com,
        richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com,
        linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
        kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, geert@linux-m68k.org, tsbogend@alpha.franken.de,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
        chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org,
        glaubitz@physik.fu-berlin.de, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        luto@kernel.org, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, chris@zankel.net, jcmvbkbc@gmail.com,
        peterz@infradead.org, wad@chromium.org, thuth@redhat.com,
        ada.coupriediaz@arm.com, linusw@kernel.org, yeoreum.yun@arm.com,
        song@kernel.org, james.morse@arm.com, anshuman.khandual@arm.com,
        broonie@kernel.org, liqiang01@kylinos.cn, pengcan@kylinos.cn,
        ryan.roberts@arm.com, yangtiezhu@loongson.cn, sshegde@linux.ibm.com,
        mchauras@linux.ibm.com, austin.kim@lge.com, jchrist@linux.ibm.com,
        arnd@arndb.de, thomas.weissschuh@linutronix.de, sohil.mehta@intel.com,
        andrew.cooper3@citrix.com, jgross@suse.com, kas@kernel.org,
        x86@kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-csky@vger.kernel.org,
        loongarch@lists.linux.dev, linux-m68k@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-um@lists.infradead.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v16_01/18=5D_seccomp=3A_Convert?=
 =?US-ASCII?Q?_=5F=5Fsecure=5Fcomputing=28=29_to_return_boolean?=
User-Agent: K-9 Mail for Android
In-Reply-To: <87echjlrs4.ffs@fw13>
References: <20260629130616.642022-1-ruanjinjie@huawei.com> <20260629130616.642022-2-ruanjinjie@huawei.com> <akdp6GAu77-ipsXA@kunlun.suse.cz> <87cxx4mmim.ffs@fw13> <akeIK5TRCjlKbzbp@J2N7QTR9R3> <akeOjqMy7HVgRRCr@kunlun.suse.cz> <fa1f5b39-2703-40a1-81d6-3feba87e19b0@arm.com> <87echjlrs4.ffs@fw13>
Message-ID: <F0993CE8-27EB-42D9-80F7-04A7A73C2395@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 53B2620005
X-Stat-Signature: e3tgbipsamg647ajukxy8fxj1uzaurtx
X-Rspam-User: 
X-HE-Tag: 1783112636-984547
X-HE-Meta: U2FsdGVkX199B8d/E6/RpoAb6iX351cotW/XU7SNnOBriUZ+OYapAJCScj/MJqem8OO+lzJ/GXwO+/mUIGvnUQTlF5taRbQt870RlGfYlwtVabovNW0W/FyxfKkoRwPc8RwQ24RcQDPcF1hmKdo7IQbed/Tz9wWyIzTmh2vJz04jNDi5ycjd7i/Cbo8ZtzOsv4NcCj50t4RUScxIv/0EVgbMsVVcXnyZPBkDu/pV+mjV5Z+nxOMsgxvxR622f4AOLiqTKMahhkBMYR0AOwuMJ+bVV4eCv3Go7cDqBEZgCeAOh2zo8VXNEvoLM4Uw6o0QtG0TqNFzld+Gea6ZgTvFXLsKMRtzmb6RH8dbaHb3oIDyiFX29hMQFhS1+YNxS8NfFEpPFzEIDzo4ScAjg5T5U1C9FCemz2fOC00k0Cjf2+XVj0uUP0DrdamEtFmst4xCiHd/4I+RsMXl5YMYJ0sNitW/TxpnDl94DWQ/bs7Kfi9ctaRHbib9YBJy6pWaGIDt6C+Hn2TyOiCj1To7iKducRupJfxEqtn6CPmNPCefMIeM1gs8uHpGOjswK739OzIeCYKlnQfFqnZIA/ghj7qJeh1gMUPSCPeQe1Y5391Sa+wy6X8AbRbB3FXR5Sqbj+i6Km9SlRrTRPnPDrHUEZWK6XGNkT+d7k41E7hZHOo7Ri2hJIBR1AtEwITCxQ/h5pabAKiwFBaRxbdShbrZ5H1PSc77YsdO7j8GlrD1Oy/LcqJQJdlyzmHl9klS82KcOiQTznz2+BMrXoVxcN2Wp6TX2tmIM4x7kreCfJUGRQxDtjps9Hu3WLef4rv33XOXmyWnM5rR29ND4yH8xk1y1L3orbvspoV/5qBmjaS5AfyausU8uKUyud4oIUaoytk5sNo2jZOkR7+20FHN6WPDBjJdNM6e8Cv9SS+aVupi/5/xFNfHM48EKobUyBnfaOpv4kexDCkwJPn/Q5a0eXJ+uw8
 DDtxbpbt
 o1IxGaS17xbPJT+HKZN+um5KzJITOrI0j8AwzSrdAM32I0tpBoF7Bom8p2rdbXAKN9PhS9ShM8j3PFtWZTdh13UXJ86S9tk334JpRecL+6spm13qXFeqO5YivcAs0PTCdgTE0wMn9hRRYt4mqDJw+avqC8v6Ge+gQMeQcqcjx6dmt64QBYGWZ8Mfm8G5OVJ4RB0YOb2QTvKOFVlNg9zXRxxyAksJGYNXzExwU9VTHZQz+J7J8Dv2WX+7J9hPE350TXMxmEKPxhq9gSRyvBzICVXpKx3AVCuTmUrx9/kljpDqK+TSiyKgklluRlMxuBQB2idvBeTES8JkTMjMZC/ouEp++b4glTCNMNPldSAE/kInb8DndaaYA/rPP6EQ3C2GUDhXLI/5bmJiEBwPWKSfW8Y0+8BT1vCPKU09g1NwxdW7kHGI9xlblBAjZfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On July 3, 2026 1:52:43 PM PDT, Thomas Gleixner <tglx@kernel=2Eorg> wrote:
>On Fri, Jul 03 2026 at 13:59, Kevin Brodsky wrote:
>> On 03/07/2026 12:27, Michal Such=C3=A1nek wrote:
>>>> If we're changing the return type, it might be worth renaming the
>>>> function something like:
>>>>
>>>> 	seccomp_permits_syscall()
>>> Then not only it is clear which way the boolean value should be
>>> interpreted, it also pervents the accidental inversion of existing
>>> calls=2E Overall great=2E
>>
>> Totally agreed, if we have the opportunity to rename a completely
>> undescriptive function name like "secure_computing" we should take it=
=2E
>
>Absolutely no objections from my side on that=2E
>

Hell yes=2E=20

