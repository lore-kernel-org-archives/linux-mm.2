Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07428C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96E56B0096; Fri, 25 Sep 2026 15:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48746B0098; Fri, 25 Sep 2026 15:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37016B0099; Fri, 25 Sep 2026 15:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83BCD6B0096
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:34:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06736A6DFD
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:34:03 +0000 (UTC)
X-FDA: 85253285166.30.F5CAF38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EA5510000F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:34:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJcTgrQy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790364841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhgSzrfp/pMMNZb9pxFnuj0VXMHs0TjA//aVTOauAkw=;
	b=q8CN1eO1ttYpWLEFRg8Hl43mDWROhguk9R9FAJeDwW+9GgPXu0YCoBgkLuIvQPLPzJ/CZQ
	5sy/YAK4g6k2oc2UQe+VDwkSxScOwkcxO13Sehp8QJG5JIjLyrOeQ7+9yIECJ9KupA1Zl/
	xMHnEkr3YIO9IWWDiEF08Nw9bTh+t9E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJcTgrQy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790364841;
	b=jVCBKysHNj6a6Ed+pIJ6fCufx7iaM8oU7dlgd+GPGPUD/d4ctgkP2Y9bXm/N7Pvv4mJBDM
	rgV07qcFxxLyISsCQHkRZ9wfsyobdXBldGhYxTwG8nCOpwJvGLgVbtGloK/amhL1QtOxNH
	QU9hR4NbgfvSrBNyu9oyOuTFIUI54RE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DB6843DDB;
	Fri, 25 Sep 2026 19:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC591F000FF;
	Fri, 25 Sep 2026 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790364840;
	bh=vhgSzrfp/pMMNZb9pxFnuj0VXMHs0TjA//aVTOauAkw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gJcTgrQy4zKteYhB+2eS4JxXxiByQG6+6Ay4P6egHkQiQIBuIBS7gzHlibknm5l97
	 hitC6GxzFuFpPe2DEbiiVpjy+vYvgrlX4yFojtBwMzywJ46zwuTWUs9NkBpvHAuNNG
	 zOBL/sF8klXo7k/0X4MQjKpt4NiOYYxmjcX0/6aaOkqCkEOYsi2IRx+rQo9VK+T7cn
	 fWo0ngx0AcN4K2VWv306HPC7mb0iP2A+4PSBs3HMU3MhUuF0zZMtunnJge1c0SS3wg
	 K85c9Spcycj2xoEI70kiMhp7vQPBVpz2nrxFX8NOXE961jb2Q83OxfxggLQfV6ZUxw
	 FmKd2NlR1y5vw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] kbuild: Mark usr_gen_init_cpio as
 no-dot-config-target
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuah Khan" <skhan@linuxfoundation.org>, "Nathan Chancellor" <nathan@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Maximilian
 Huber" <maximilian.huber@tngtech.com>, "Nicolas Schier" <nsc@kernel.org>, "Luis
 Augenstein" <luis.augenstein@tngtech.com>, "Jonathan Corbet" <corbet@lwn.net>, "Alexander
 Graf" <graf@amazon.com>, "Mike Rapoport" <rppt@kernel.org>,
 =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <linux@weissschuh.net>, "Willy Tarreau" <w@1wt.eu>, "Pratyush
 Yadav" <pratyush@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, "Askar
 Safin" <safinaskar@gmail.com>
In-Reply-To: <20260925-move-gen_init_cpio-to-scripts-v3-1-99c493f76722@kernel.org>
References: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
 <20260925-move-gen_init_cpio-to-scripts-v3-1-99c493f76722@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 19:33:58 +0000
Message-Id: <20260925193359.3EC591F000FF@smtp.kernel.org>
X-Stat-Signature: 9negy58f4sky61m14dbj77jtqwxezkph
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5EA5510000F
X-HE-Tag: 1790364841-872128
X-HE-Meta: U2FsdGVkX19zx140LZRHNgrHA5K/V8o5/W4O6cnqGOtm4/UyS5chiLHrEZ39G4jkh4OUaS14WR71503T3a2kSRn6+9veWDTVXMAkcbHQ27DgH3JRBtxXU3U2VM/gURntPEEohkpFk2YBOwU478ftePbYv7CjmnG1E2nlSuO+rmv+y/ttSofgwCcWSd/MZcc9XUoQvSnD6akOAXaX4xdgFfhuW0yGHA2BrAb8yY+tvWGOuLtno/m1/nXUBPK+n9m2RB7DTBk+e3guAqrOkMOE7JQhM5ig6oNXlqHtcfsblaSjzRTvuibpUNVoEMnAW6vxJVsyBXiulWF39VeoKgx8vI8k4sialXTpv0P3yvSM+e+5qS4mHeIaQn1Ar1lpECt75lTNOzRoYAxw4ennawasCgC7cl66igIsbwo3hj8llNrC8v8ljLmuyLjmMu5SG5i7fKy/tTizb0V9/Nt+ONtnCrmNFTy0d6gBLbyD5zo/BAivleCLtI4AOQY+FbXJC/L6XiyjctSfxamex6gi8QHfGI1Kaz5tEQh4fjkGXcNiwRBX23a27zJNam34PBaXGSXNK2UOEqCGNmrPpPjgumK8plgWi4E96h8STuRKFlrgn1LNjzDlYRN1WXVq3DYg3mOBUNFJiCNtqr7eCnj63LidqmXZ3e7wj3ByRheIhbIzAOY53zHnNbXVXEBLHN06qOhHjRmm/97NbtgzQ73+QJqcC9BPZSOdDobvLIIzopYJVAWqK0s7TGZZ5OBqV3m+ptZLlbOccud3Vd2vWg+Sfhvcly5rAvr6YoEcqwoc5aZlHsgkxAnNve78pg2/88GmomgLZ+UWNK1697Pcwq9IXEuxqQ8ihCjthrdL7Rs56pFb4hNtooOwmPxDc4d7sn9I3ckpIvYl/exyfvdpLQ5wVYeADPNs/xwgdldIwOMQhF+gRV2X+rVd9gJ4IxPmUbcKmEAMq5gg9Whhm7wwf7UhYhm
 Jz1ljUZh
 mjURP6uBkNV/mmB5jmhTlwgSkGHZTOp1kyM4QKIf9jVnCKi0GC0Dg9Rf7fBPD3Q34pugAx/KyYjIOyZ80mJ8Hu/GsBML0g9b09kAoNkg7UtIntWNnz8w20UcL/WPj2mSBMI12LBBV/+cpHRKVFUha1UsJPZlNWTgU9IShYVBX9zAiMZF0x65i9kQlTZHZZdPpGHSRgmVVLeVZnYjblaruChUiE/pDHfNbDySt+TtwQYMAubx8VKS5SyyHejD1aHxDqFHbZ9rMWvFqmPpjCbxQPJKqnUSD4IZlUdmnq4qZTUFKuqGlnvmalJohMvfzJnaZHA6YckLlZlksiyEhhc0Rp19rgobmaKWMPnVCCdOgFbF2C5rt+WG6xXlVgbeFC1nvkOLUgCtX1EAuLK+8NApryxyy0f9kHnrRZ6MvYC3ZUGfh0yOO1DekN+Tfz1bebm0F9080YYeO9f/F+0rIZCVFrIq98Maw+ZO5x3vNhaLoDDonZjm/trTkm+b1lM5+71j0m1cWhAwkltJlvvVSrCGOAfRAgEt5ZLrlOSLvKNWAzP8G75f+QFCF/JfT7RFFd0mYPRC5rMILZKyJF9F2SLzXHZSThW2KNA8DbofxHb6UxKsFVpJPbBNed5cbh/TEAW7xeaySNp3HrAQlrgAyEfS7COSR7EVbIhiLWoIl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Let usr/gen_init_cpio be built also if there is no kernel configuration.
>=20
> Askar Safin reported that gen_init_cpio may be of use before any kernel
> configuration is available.  Add usr_gen_init_cpio to list of targets
> that do not require a .config file.
>=20
> Reported-by: Askar Safin <safinaskar@gmail.com>
> Closes: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gm=
ail.com
> Fixes: f8e05c10631e ("kbuild: Add top-level target for building gen_init_=
cpio")
> Signed-off-by: Nicolas Schier <nsc@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925-move-gen_i=
nit_cpio-to-scripts-v3-1-99c493f76722@kernel.org?part=3D1


