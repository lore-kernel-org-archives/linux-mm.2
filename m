Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B02C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 18:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29796B0088; Sat, 29 Aug 2026 14:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB7A6B008A; Sat, 29 Aug 2026 14:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3EC6B008C; Sat, 29 Aug 2026 14:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EEC56B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:15:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3D0E1601B0
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:15:47 +0000 (UTC)
X-FDA: 85155110334.16.F1C2E2F
Received: from 10.mo582.mail-out.ovh.net (10.mo582.mail-out.ovh.net [87.98.157.236])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3FC9114000A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:15:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=cMLHHPZd;
	spf=pass (imf23.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 87.98.157.236 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788027345;
	b=6B8rvJNuJOqioGF3+z67AozLEiV11BJzzlQdOwhmIneK53zZJSgiuLWwA9Q+kxphuckzXg
	KpTFd3xkFsJQ2Q4+K+WwJqdZCmCzRBmXc+2QeNdJdMAs42JUPcmIqJWEoaGm7sp16/guDB
	bOK8ZaF+POIL1FDYRWOCuyeUur7Gnbc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=cMLHHPZd;
	spf=pass (imf23.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 87.98.157.236 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788027345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3Q07Ul84TtwxtMmkTHBsOndh+GS920WQGcYM6z2zxE=;
	b=3LjQ9440SU6NPVcMXUpurfJeL9o4BBj0sgCP5orbb9SGPfO2R9AiikbYOrwHkI+Zs1G5+U
	rN8M+ydjPL56dQzDsfuNzD21IctkmkHCZrRFvIj9/C7UMgmPVFWPrciMmuM+XWMjuNIHHH
	iilCm5KmAkpXMq0b0pYknyb/eN/UVT0=
Received: from director3.ghost.mail-out.ovh.net (unknown [10.109.231.97])
	by mo582.mail-out.ovh.net (Postfix) with ESMTP id 4hXNjC58Yyz5xql
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:15:43 +0000 (UTC)
Received: from ghost-submission-c7b579475-mpc78 (unknown [10.110.168.168])
	by director3.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 2F422C087F;
	Sat, 29 Aug 2026 18:15:40 +0000 (UTC)
Received: from quelquesmots.fr ([37.59.142.97])
	by ghost-submission-c7b579475-mpc78 with ESMTPSA
	id 4Z+HNswhk2r/ghgAMlBLyA
	(envelope-from <l.wandrebeck@quelquesmots.fr>); Sat, 29 Aug 2026 18:15:40 +0000
X-OVh-ClientIp:90.103.222.124
Date: Sat, 29 Aug 2026 20:15:40 +0200
From: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_x86/mm=3A_don=27t_apply_va=5Fa?=
 =?US-ASCII?Q?lign_to_hugetlb_mappings_on_AMD_F15h?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr> <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com> <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
Message-ID: <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----9Z16V9LWZQN1BJCCB8YU1TWLEU9MW0
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 2436165927672151323
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTGjAG2Nw2Sx9I8NTCrOxqYKZl8zj0dWUlJg3yrYp81kQlK9dwVA09BhfQ/sg8Zhxrn2MlTo5bwHjBYnSDsPM/7yd7BwTIP5Dvx5C0og8WHanIIIVczUcB+bl/Dv1XIjqQjer/VWV+fSdewldv6w1OIO99nnAeZYu8aKFDxSzBqJjY1tmAIMmmDxRExBH1eq8tvTgQOsIyTfAcYACOpR/ofQ26ybG58kXwmb6eOL0PWgEFJ6tqjOLS5v4b7tPHkRC8Iz3R08NHEj9I53+2pPAnPyuXlvDF1aDk0Y0tGkW2o8cZE4MRrx36G9OM2earh9ytrR8q9+VqqU1CIDPeTI8PJtPnvtL3c7B3dEdE4EbE3/4NfJOidy6T5RMYDnMsNWQPAJl3g+CmDS08NcKh811jEDmXEf39LNQ3Pcl133TgyxspZod9qTXFqAbQT30xaT5jU+lvM+Dg2XK9nQRmySaIGU3vq6VBvDcBCsHuHfWMbbNwPASqc6K1MsrtWhjLfYJeoDfxWAuIkak88AaV0CXABdJ5OfqHwfRjHCVvXsWD6111Vnv1CNdZn9ytmj4Rp2PewcBQfmeqIb2I97dwe/G7H8XybM6sLwzb/H34pIYwrRQjfltP40FdkCtmaj79TsxqwcssyUwr3TGkkhsYNoDiXTP5EP0NGtjkPAfnqKK+eD8g
DKIM-Signature: a=rsa-sha256; bh=E3Q07Ul84TtwxtMmkTHBsOndh+GS920WQGcYM6z2zxE=;
 c=relaxed/relaxed; d=quelquesmots.fr; h=From; s=ovhmo4049951-selector1;
 t=1788027343; v=1;
 b=cMLHHPZdXInQpM7TuESwfh1XfHkIdHSWyU7Z0FlL4FBYPeIRQeejJUaBSsyGUSKiO/DKW7+A
 /bS2ohhKNqdtzdpymVVOtizcsuqu38Wd4iSvy39Gue7aF/Gpgr01Yea2I5JV9bOf4FE0zVQ3eGI
 mm60h2B5pGgES5xix3TS+KRLJeO7fOSji14Dk9v8KQdMEmC1iJvoPj7rSVkVK4IGw1lwbGQAgRT
 Pk2DUGA56iiCuLdXF1/J8b4AX8jC7KHJ2lGYDI9uhpz0MSMDfay2tgadO5UmjKCYNdHcpQ+EsLb
 TZqwgqe+6FZif+pA5Zgu4jPspeARq3Bk/0XtSCpu5aVMg==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3FC9114000A
X-Stat-Signature: jme3d7frm76hrzyi1gpyxs3mumum7sg5
X-Rspam-User: 
X-HE-Tag: 1788027345-748379
X-HE-Meta: U2FsdGVkX19hA5VRrTOhzYQP0f0nCZntMpdBH31UbkR1IlGT4Ad1UxUwm5mtSWGqutdgKzyac6YF2Dks9yXSh1xuiccmLwdJTvWD2YDOHZtQtAA4IHiBJtC6vrnMwzsnCBaBybByyYesKlm7MEIvkJuTIVBoPEI43WCkoZ40ey9p2J8WQBy20AHDz348KI7u+aqRENbDIci8Pm5Z+rK/hs/b0K6A1poydxRl/hmBUdj8n5bwRnxIXwULO0thg8U4B1a9mkDEcfIWFGWox6UIOuT+euHBW2iqqIGnzgKmT5Bj2yXLOjgS+G24MxkfOHBWpxecrdwvvge+GoBc7gyT43ugMmQH+Jb31/cLPXl4lypFcv9rYZTN8Iwy8ao9cKb0ubiE29DKYUO0MB2sr1OOUAHxoXne8RjV63z6KW+VQHCvyy1P8+drnWI7mZwoqBvaxmhIvF15Rr4fyEQjJMG8CPuvXScEklurlw94a/fnLTTyuQfRawzC9ndFAqs158L+BoY8rQvmTavMTLAM+YefcWa7WZhWxSK6U2dEYjfGXaZhejMPBOZW6U97BuiTKI6I6KUmfPAWjjkoQmtkCJPjgtvCyRifqNCan+wk6S5Xxe+xi5slhjxtQz52IMxfErk3Q+H8Ly0lV0ZifUBUkYtG6yJWNLf/3xpg+Gq2POtB+q9AF1LDyQ3kfbozByUSS2txhfupJOLgEkXIg4OkEA58pGwvP0MqrQM3UDoyLwAY6GANnqvFnOYoHcC6ua943SCpdVWgcBHiFX2Kew0q+uXXOLv4n0UmVWFoVjChYgrhm3WZarMFB5lmIACYdwxUso/q8D6jw6BTmSrm1HfPqIxVOH3QvEQu6tvPrXg32Erd3lDtYW/p/u4IG1Df4J6XmB0Iyr2su/0PPu+WSS9hwIydQK9Db/CKDsZTFKOsA/8D1sMK3hSuVPy+CEuMmV4Whm7B3vHi3zALQ14QlfQOH8i
 YRoErjmT
 oYx0TzyEpuURERjwAeHnBiW1jXAwTgmMaWNBiRFSJDakU3scwEqv66gXQmTLVd6wvhVAqafLRskGPlvm7+wy4+NxfGUL9WAwgH65hq/Uj5FW6dmLqvV4bsUMnrmIMuTUNskWOMBagOzsyJ6HJYtWaU49CgJqFJnVOQxs8HfQd78lqqZdUjDukubAf4Ytb5PF38awZtUGdO0xIOTfH2eEROTM+n/9gDiwtz2Pbkrwj7PIIVDATVgj/TWSoNxkvv/jOxj3NvZrFy/WIYgpemMr6KCKVstU9YQ8pCVMTtAFRt7WX9Q6BtilKQhjpQxDVWy9GGfp+cTvvyi21P4c4a8A1cg+JdvfOJgBJ/by0nVQEEIbkb2H5hhfphT7acf+SZgGp8MvKTnZKpY7L9RJzb7WFXLAAMmZOWx0Ay1Yy2wWtqAN9KRPpI18ZcT7bbDm+iHSaiZ4TL6U72y/3HjwOnz9MTb3OIhdNmdpi5JdfO2uPCso8c9t5Q/TFLPPRYZoSdfPAMyvP3hSQkKf2Gm2Iw45snbIi7zSDIhTAEV7JuH12gKxnG6uiB+x+f7OfvBZF/V6pt+U2SHxByoR61ZzKZdT/BizwxWplDgo+AIAZHCmc0N7qWjep7SKLZsg0SRtXbAgu7/OB8Igw8/mweXyu4JCIwVuEZEzuYuw3AuOmKxX3zUFUKKU2jlm8yM8tjVEZRdWGJWyX6xtSw22amH2NkbJRIINYyj1EqKjgltLNoKrUAZliiX/tHbZOtpYVWoSW+w0NimgmTtUMKR84FRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------9Z16V9LWZQN1BJCCB8YU1TWLEU9MW0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

My homelab is indeed composed of 5 thinkcenter with a10-8770e, and desktop=
 has fx-8370e=2E Actually I hit that bug running 26=2E04/7=2E0 and reproduc=
ed with 7=2E1, 7=2E2 so I dug a bit more and AI (I'm no kernel hacker) prop=
osed this patch=2E I'll happily test and report on whatever you'll propose =
if that one does not fit=2E SSH+sudo access is possible too if you want=2E

Best,

Le 29 ao=C3=BBt 2026 19:47:04 GMT+02:00, Borislav Petkov <bp@alien8=2Ede> =
a =C3=A9crit=C2=A0:
>On Fri, Aug 28, 2026 at 10:07:42AM -0700, Dave Hansen wrote:
>> These AMD F15h CPUs are, what, 15 years old now? How bad of a
>> performance hit *was* this issue? Is this optimization worth keeping ar=
ound?
>
>Oh, look, even back then I did perf measurements:
>
>https://lore=2Ekernel=2Eorg/all/1312550110-24160-2-git-send-email-bp@amd6=
4=2Eorg/T/#m04c05a9a6f59b73d610b556f1efda8cd9e0487d1
>
>8s penalty for kernel build workload on 3=2E0=2E
>
>Do I care about Bulldozer?
>
>Meh, I only have access to a laptop with that uarch and I've been using i=
t
>only to test kernels on it so, not really=2E Besides, we have Zens now wh=
ich
>are soo much better in every aspect so that Bulldozer looks more like a e=
nergy
>waste than anything else=2E
>
>But there are apparently folks which still use those and run new kernels =
on
>them so we probably can't axe it off yet=2E=2E=2E
>
>Looking on the bright side, Laurent can test patches =2E=2E=2E :-P
>
>HTH=2E
>
>--=20
>Regards/Gruss,
>    Boris=2E
>
>https://people=2Ekernel=2Eorg/tglx/notes-about-netiquette

Laurent Wandrebeck 
------9Z16V9LWZQN1BJCCB8YU1TWLEU9MW0
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div dir=3D"auto">Hi all,<br><br>My homelab is ind=
eed composed of 5 thinkcenter with a10-8770e, and desktop has fx-8370e=2E A=
ctually I hit that bug running 26=2E04/7=2E0 and reproduced with 7=2E1, 7=
=2E2 so I dug a bit more and AI (I'm no kernel hacker) proposed this patch=
=2E I'll happily test and report on whatever you'll propose if that one doe=
s not fit=2E SSH+sudo access is possible too if you want=2E<br><br>Best,</d=
iv><br><br><div class=3D"gmail_quote"><div dir=3D"auto">Le 29 ao=C3=BBt 202=
6 19:47:04 GMT+02:00, Borislav Petkov &lt;bp@alien8=2Ede&gt; a =C3=A9crit=
=C2=A0:</div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt=
 0=2E8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre class=3D"net-thunderbird-android__plain-text-message-pre"><div dir=3D=
"auto">On Fri, Aug 28, 2026 at 10:07:42AM -0700, Dave Hansen wrote:<br></di=
v><blockquote class=3D"gmail_quote" style=3D"margin-bottom: 1ex; --net-thun=
derbird-android__blockquote-default-border-color: #729fcf;"><div dir=3D"aut=
o">These AMD F15h CPUs are, what, 15 years old now? How bad of a<br>perform=
ance hit *was* this issue? Is this optimization worth keeping around?<br></=
div></blockquote><div dir=3D"auto"><br>Oh, look, even back then I did perf =
measurements:<br><br><a href=3D"https://lore=2Ekernel=2Eorg/all/1312550110-=
24160-2-git-send-email-bp@amd64=2Eorg/T/#m04c05a9a6f59b73d610b556f1efda8cd9=
e0487d1">https://lore=2Ekernel=2Eorg/all/1312550110-24160-2-git-send-email-=
bp@amd64=2Eorg/T/#m04c05a9a6f59b73d610b556f1efda8cd9e0487d1</a><br><br>8s p=
enalty for kernel build workload on 3=2E0=2E<br><br>Do I care about Bulldoz=
er?<br><br>Meh, I only have access to a laptop with that uarch and I've bee=
n using it<br>only to test kernels on it so, not really=2E Besides, we have=
 Zens now which<br>are soo much better in every aspect so that Bulldozer lo=
oks more like a energy<br>waste than anything else=2E<br><br>But there are =
apparently folks which still use those and run new kernels on<br>them so we=
 probably can't axe it off yet=2E=2E=2E<br><br>Looking on the bright side, =
Laurent can test patches =2E=2E=2E :-P<br><br>HTH=2E<br><br></div></pre></b=
lockquote></div><div dir=3D"auto">Laurent Wandrebeck </div></body></html>
------9Z16V9LWZQN1BJCCB8YU1TWLEU9MW0--

