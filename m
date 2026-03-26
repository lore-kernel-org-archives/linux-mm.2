Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2795F10A88E0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469046B0089; Thu, 26 Mar 2026 12:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419CF6B008A; Thu, 26 Mar 2026 12:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308696B008C; Thu, 26 Mar 2026 12:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9856B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:12:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 843F2E1496
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:12:03 +0000 (UTC)
X-FDA: 84588705726.26.0FF4B95
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8425312000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:12:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=AarwvF5D;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774541521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+c71AaqJUIBSx5eGfBcmYtV1fFI/AprTnnSpFjdGoQ=;
	b=oxO4pI7UM8oMj3PUJwlDzZvGvpEKvxTGrS5XFLAhUUEx7idIbbiIYe0xI/MErrdsmZYSsU
	+9Vk8htPJTsP+oXcDQiM3g5gYhA1uaP4RB6Hf6ftHlr+CzqT3guqcMoW9gf0HZW8zz+ZMs
	U1T9ncXAKoHUOxP21yD3WhdYrWdHSmw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774541521; a=rsa-sha256;
	cv=pass;
	b=CBZTjr1xcts6fScvCvzBYreoEj5TbPosk+Ky73Xin5Eki9dvmg77zqExItmEqWlx/NxrzQ
	TdMhYV/Si35Ibg8nokGEk0Gpju8GLiwBlQrCgDdtPDAREfFRJr6XWQeK8vHtkM5RQURuUy
	B9fZtbxgUXkl12ZDtdT0XabTbOqF4RU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=AarwvF5D;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774541507; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=VJo+XP3iAuv6nMCCCqGfNRe0MafRApWeWqvt9E8y90mA/cgSSRcETxv7kZj0OgAOXBqGkk3iMpqi86Qb5HN/JrE4dwd6P15xOKeLnf170vcLnxKsAtouyr8pZw2Zxm2F0T9WvJog9J9j2Mxe5bt/hCU60+b1me5SMyEGReGCsBE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774541507; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=n+c71AaqJUIBSx5eGfBcmYtV1fFI/AprTnnSpFjdGoQ=; 
	b=ALq435qCtDPgKVaMVZkcFCGhaCWF9vlWLZqG46BuMbMCMMEjTdaaU9JSavvTcnPViWrChc1ztQO08I6DSEpWrFVQpevzyRhkFKhX8TuqJZxFtIFp03HTNZE/Yznlik4E8M6REwil10Yv5WcZdvtqFpcEljfviNaDSIzLScixyMg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774541507;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=n+c71AaqJUIBSx5eGfBcmYtV1fFI/AprTnnSpFjdGoQ=;
	b=AarwvF5Dp8DdPytwzxGEX1iMK7etw1DeBPLZ9GY71CN7BKV7vUS0errSd6tKTSrD
	lnIeZgxvXOwiZVfX5GoKdtx3CboJVbwgULJ2DyRSDrqg1lRT+GrZGVUfyJjBSDbtOsE
	zIfx2xEMMO9fWqFxUEIy4wQ85C5NeRAZRpmV8raI=
Received: by mx.zoho.eu with SMTPS id 1774541504146665.8655939990882;
	Thu, 26 Mar 2026 17:11:44 +0100 (CET)
Date: Thu, 26 Mar 2026 16:10:42 +0000
From: Josh Law <objecting@objecting.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
CC: Josh Law <hlcj1234567@gmail.com>, SeongJae Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Christian Brauner <brauner@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon=3A_introduce_DAM?=
 =?US-ASCII?Q?ON-based_NUMA_memory_tiering_module?=
User-Agent: Thunderbird for Android
In-Reply-To: <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org> <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local> <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org> <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local> <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org> <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local> <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org> <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
Message-ID: <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 8425312000A
X-Stat-Signature: 11ixpcij5fy3q4n9f5bxqpzu4i34gyba
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774541521-314197
X-HE-Meta: U2FsdGVkX191M9YIDZcoZ8ALZ6zRochwMCQSkLgF5+utrUOhqCJCVCm52o9ad1p265tzl1U2a7iO3DVxAMTCPwFjxQ/ud5xBw5Uf4e9owgmWsC4AOwqN1qImaj4CR0fYnu1S2NEAagM3LSRkBC1zqUTyYWHGpcKEP3dxZU136iY3wEihH+wDllbn4cULIbHZLRZNxP0ShOiIov6EDJ6soORtXqtMuZ0E7nyDYHJy33KJ0bnpP3vKR+0E1zLL9uhe/h8xlLACkPQh0eZXVZwzX+sd6Aa8TfCot4+6xE71F52e/OALGd0q8gFyLEio7taEEukm07GhQ6SV/AmyulpeE5xPpMu7YxJg4QaKv04j2hC2DAgK2bLQkvZCV8Lvpp2iYv9J1/FvEOKWQUJKiWLbE9kzonPFm6+54BBiVmu/KzvFSq4awdUxJDzq6M7oJJFATj9dHroH4fqQLae6s/3SE0YuP3TRPcm7ATgfEUHz+6/3T8MF2lq0GU/pwiNk6ZVvDyZAocC+Rj+Cp80OHZwMTIbuemRv/3spucMN0J9xYAk9R5qY0v6tgnTYC3iplZRRgmAXno84Fl/fVAPMhIq3dLHuuLIuCBTyCmhf3KzvnwrqMKwbWFASkYscQ8+cTkKUwyKOZ+YdfdUfbCi2LGaC1CmaSGkgGVlxo1D39aUzhsO3P2ZUXsmzrIZTpfcCowB+xOjsb5nA4CHb2rNnSpDVBuXhwBRLasv65mKTwqmFUuxFz4R9uf5V5LBzj2Y0GEz0Yrf9X8ABvINzfEs/0Lc2ebwvF9vqEnhcWSvoN3+6FdAo1oetgoTjj132yph6/AOpkYB8StoBdIxz+RJW4jx6SWgdOe3oUtP3wuJAMrZi+oPq9JmYZICPo2pu5hBKOE5HDA4wZHKCvyVK6F5m7Tmls9Yb5mgdk2miIkFMlS7bkT/WwM1afmTbPdxI/lJz7UtRYA+kuETBZ6KX0OWZzse
 +BOl7T6j
 mCUVf2qQf7sy1yggJ/2nxdnqYLZUD86faQcNzX7IS7sX/0niD3SnQI/adFF/ayR89WJoMrcdDqiyXSaA8fcii5WNfJXr0+ZgeyrgoFjV8aNtAwPdDD+NBUylSqACEETjRbYuv16Pxz9FJoChUc2nBKhQk1VXOwBrYz33pIGNod1OlvzWg+tajHKnnlAH/wp4YVwlW/UFWHqI4TE9Wvh0JHf0stK7Qt7SH4MB/JnUV/OzLaOhzObsPK/3dP6pFjJzgVBF/eERn586NR5EPi4K0b4LjngaMBoaKuRlv/cksI+9jGo+Xt8nVMFsfdSQo9cE1f77TFFn7nP5VCrdN8oike8PzCmTcav5zjSykjQ061YxSgbOx/CvOdVll/mdmvME+TUTY9YSfxPvNTTJKXjO5XEIIn1cO2iCe/Sgc3scIgi7OEIZaG0EY7DPnE/4y2QzFUhmg3f00yjWwoYbFp+rzumzSzXzWKi1Bj+T4ynXEq1Gns6xsVP35iCjhZi4GSvsTshJJpm7RarscDeVS/dq40QlWLAa1twG0j0r9dWrhAdXlnwRbLXwotgCRqlt+b8rS4JuFSgml5nYMz/2Sge36oBspPYdhxuSWqzkK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



>
>If 20 times you were asked for something already on the list - to wrap
>replies - and you still ignore it, then I don't trust you are meaning thi=
s=2E
>
>Anyway, you did not address the actual problems here=2E
>
>Best regards,
>Krzysztof


Yep=2E I was going home when I sent that so I had no time=20


Okay, let's address this one by one


First: The domain=20

My domain (objecting=2Eorg), I brought a while ago, for vanity, I am entir=
ely aware I have put nothing on it, and I know it looks "out of the blue", =
I am finding hosting to correctly mitigate this, Also, I use Zoho, because =
it is one of the only free email hosting services, if you Google it, you wi=
ll see there is a permanently free plan, I am on that right now,

What I will do to fix this, is I will fix how all of my emails are setup, =
and switch clients, because this one isn't the best, (thunderbird mobile), =
that's why I haven't been word wrapping, because it isn't very intelligent,=
 (yes I have a PC, but I am usually away from it for some comments)



Second off: My identity=20

My name is Josh Law, I can promise that, I am not trying to be anonymous, =
like "Jia Tan", I am aware there may be no search results for my name on Go=
ogle, or however you investigated, I am quite young (19), so nothing will p=
op up yet

Also, I understand The social engineering Lorenzo spoke about, and that is=
 utterly unacceptable from My part, if Lorenzo thought that, and I am extre=
mely sorry for being quite "bot Like"



Okay, The third thing: AI usage

I will be absolutely transparent with all of you here, The commit descript=
ions (The long ones), Use AI, to be exact! Claude sonnet 4=2E6,=20

Additionally, I will make a promise here,

All of the bug fixes I made, all of my lib/ bug fixes, are made fully by m=
e, (minus the commit description for some of them) And I can promise you th=
at on the bible, If you have any questions about this, You can always ask m=
e




Forth thing: My patch volume=20


To justify my patch volume, I am a "excited" Developer, I love the Linux k=
ernel, and I have a passion for that, I am very very sorry I filled up your=
 mailbox with my slop descriptions=20



Fifth thing: My latest patch, (adding tier=2Ec)


Again, I'm being transparent, I did use Gemini 3=2E1 pro on that, because =
Ive never actually added a file before, to the Linux kernel, and I am extre=
mely sorry I

1: did not go through the normal Mailing list rules=20
2: Reviewed it first=20

This is probably my only patch I truly vibe coded, and I am extremely sorr=
y for wasting yours, Lorenzo's, and seongs time on this slop=2E=20

I will fix this by:=20

1: Not doing patches I can't do
2: If AI is used, in the code (or the description) again, I will add assis=
ted-by

Sixth thing: Openclaw=20


I am _NOT_ a Openclaw bot, And I will NEVER put you through an Openclaw bo=
t, Because I am a human, and I am aware of openclaws "antics" [1]


Seventh thing: My GitHub=20

My GitHub (github=2Ecom/techyguyperplexable)
Has been going on since *atleast* last year, With real, human commits, Tho=
se commits on June, were pretty old, so they probably weren't the best, I u=
sed to be very invested in the android community! Like, so invested, I made=
 what's called a "custom kernel", A custom kernel is like a modified versio=
n of the kernels OEMS (e=2Eg: google) Give us, mostly optimized for perform=
ance=20


Right, last thing I want to talk about here is What I will do to fix this=
=2E

First off: I will take a couple week long break, to fix all of the issues =
Lorenzo (and you) presented to me, and come back, with a better reputation=
=20

Second off: I will not do another patch in mm again, I already improved DA=
MON enough in my opinion, so I am happy with the state

Third off: I will change my email client which supports word wrapping! (Su=
ggestions gladly accepted)=20

Forth off: For reviews, I won't just add a blank tag, I will actually comm=
ent on whats good, and what needs to be improved/changed, and if I (ever!) =
use AI (unlikely, but not vetoed), I will be transparent with the user what=
 AI I used, and the prompt

Fifth off: After everything is fixed, and I come back to the kernel a bett=
er person, I will also slow down on the amount of patches I did, no matter =
how excited I get=2E

Sixth: starting now: I will read every line of documentation in the kernel=
, on how conduct works, so this never messes up again


Seventh: I will never ever, submit a maintainers patch for atleast a year =
in, When I did that I was incredibly stupid and I thought you didn't have t=
o wait


I sincerely apologise to Lorenzo, and everybody whom is affected by Me, or=
 my unacceptable conduct=2E

I understand this is probably unforgivable, and I understand if you (proba=
bly) need to pban me, if I do end up getting Pbanned, You will all be apart=
 of my memories, all the good ones, and I am very happy to help fix bugs, o=
r review them


Thank you very much for seeing this entire thing, apologies on the non wor=
d wrap, please suggest email clients, that will be used when I am away from=
 the PC


V/R


Josh Law

[1]
 https://medium=2Ecom/activated-thinker/openclaw-conducts-character-assass=
ination-of-real-developers-for-code-rejection-2449f59c3eaf

