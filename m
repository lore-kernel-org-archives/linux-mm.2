Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50198CA5FA6
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9816E6B00A6; Mon, 28 Sep 2026 13:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1806B009B; Mon, 28 Sep 2026 13:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734946B00A6; Mon, 28 Sep 2026 13:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5368B6B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:34:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2CA6A4D19
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:34:34 +0000 (UTC)
X-FDA: 85263870468.01.6047554
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2299720007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:34:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZsTmcLgE;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616873;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56BxWF8z/reF8ypYDw5KpTL0l2aDGF9pTpnE6xZCNrs=;
	b=NEKekS4wbyMd+IkLeX6Wc+VpUgTzNSnGFD/jWN+p9tvYhSxgU1IYESekrATMuZkEnhJSRr
	z65kDcxTL5Pqw+D1/nvA5w8BBBnf/Bk8Ldjoyql1oXQdsioXuVorw/Bb0f1llXEwf1MxE1
	1uKhOBnwEMsT54bCXngdkZX+2uCaPmY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZsTmcLgE;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616873;
	b=zBAYycSDYy7l47d3iurxqPAEtvWn6aNJsyzT4TqgbRiQ0ni1YFLmNWFmqfW/DBZJ+aLSII
	0s+TGJ5SeBL59oKUimB17NeP9/rirDUxRURzXQdtwfweg2ezN7pyyAHjd5asm9mmXrflVU
	+/e+WXx51NyJi2gRn/SK/20VHftXSIw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F89601FF;
	Mon, 28 Sep 2026 17:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC311F00893;
	Mon, 28 Sep 2026 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616872;
	bh=56BxWF8z/reF8ypYDw5KpTL0l2aDGF9pTpnE6xZCNrs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZsTmcLgE2/ZooJgOsZcL7H3uFx363nXNblOsqsLrv9KBo5qclY8yqU/RGP9ph1cay
	 D4qe/gVrzVxzSGY/rJn76bN1oyx64b32IVcL82LLVALwybXed2fn3B9YrKUfvXCzKn
	 msmVgZOSrFNny3hQzgTgj4AxKsxHvxyhf9QbvW1AnxwbtV6xOan9MNFsoczC7mYUZd
	 b8xqU7WZyVxBhKSrQOSwqAJ3MniYckmJ9LyHVOPnmEHv/tFNcg6jUjqViK7nIjUajt
	 /V1swvrD/XLn6hx3M1ck2lQxR5MTFg31cASPRsnAgK6C4OfELwmgUYzZ6OYovJB300
	 9G7shR8rJAhCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] kbuild: Move gen_init_cpio and gen_initramfs.sh
 to scripts/
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nicolas Schier" <nsc@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Luis Augenstein" <luis.augenstein@tngtech.com>,
 =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <linux@weissschuh.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Alexander Graf" <graf@amazon.com>, "Nathan
 Chancellor" <nathan@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Willy Tarreau" <w@1wt.eu>, "Maximilian
 Huber" <maximilian.huber@tngtech.com>
Cc: linux-kselftest@vger.kernel.org, linux-kbuild@vger.kernel.org, "Askar
 Safin" <safinaskar@gmail.com>, kexec@lists.infradead.org, =?utf-8?b?VGhv?=
 =?utf-8?b?bWFzIFdlacOfc2NodWg=?= <thomas.weissschuh@linutronix.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20260928-move-gen_init_cpio-to-scripts-v4-2-f437a33c40ac@kernel.org>
References: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
 <20260928-move-gen_init_cpio-to-scripts-v4-2-f437a33c40ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:34:31 +0000
Message-Id: <20260928173431.8FC311F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2299720007
X-Stat-Signature: hkogno3bndqpf1ab9x4r16auasy136wa
X-HE-Tag: 1790616872-611101
X-HE-Meta: U2FsdGVkX1/a9WzQKvLZgqIvEOcc1lbu5E4lqelHCZ1fHKervdC0/iBSOG1O9DmQTkEkS8ejzbI0XJcI+XGLbbtaWlfWiM+CU6zWbMwxUlmgzt1fZKcBkyS5Ei9QM8OxhL6Xc+olMsvFHDfLmK1CzwJPrdWBmGCPQYqS8T/TLeVK5Av3OY6sgHp0mQqNBtF+xpESCiGGfrjhtvWzn4PVWEF1g1QoD6CZIh9Y+TPLSrwtfpbSSzh9SokRZAoHgmOIG9K1eik03jzBKdxkrByUpKXTtusOjBHukP2Kigdxtd1hJzmG5VEFCxxuxImIOBXFhU3jqsPFcuiGjom2o/JiUITQsiQ7jwPJxglAa5le1fQbg5iJ2ZEG/rcAQE8TUcRabIw0GKW8+Oe4+wwz/2vqxOB0K+uWmkJ3vurAg0TdcAoFYJE7ZfS312U7jqNUKqyDFy0VWwjtzAZNF8hxIqarOw8EUL+1BfoSE3k7ZFbrvzwnW10Pxidj664yB/tH3jfEmESCSpILX4lhdEQ4I9vXJkhvxS8W6VsguKESGvgD+geUc2bhOAnM2VsuO7cPufXGrx7iYfkIgBUk6F/y9nxOd2vAL2bBIyzLbVtDegTOkmiD9im4/X/W2Q1eDkS97B93F8qntVMuPOINfsgN7DXSNsGRgZ1K1YVzW1oMfV7rWqbas89jdrio9jxGPRScRdCHQv43W3yJzR3MgYMCEpePkCmVqVOs19hgQ3YEotygwyK/agTuyM+P63NcNvLXOcSF3ZrVVVBbXh5e6yKzlXKuI6cnWnZ0BR9bt8s1X1E5qGz9JS0AdsFviEzKV5ayql8qq/h4fqdRToGdLlvoJFbEsm2ni7MUBkiERAnsOGKy0MDYTDaU0gjOpzL/8+DdyIp7+50+TW9kDG57IBnguIjbA2AjEKel0nERmwixF+t5HEaVkv6k1UAUeshvhvIhO3W5geXDz418smpGyOipL4H
 8J+Rqebw
 4t1VGTYbFL7WVaJLpatlObi9R28mATvmsheZeBVZ9qY1tlqmH2m15c44EBcnVJKE/OsdlBnW027aAHifrXg2ADVk93ZMnKgZFgXiJSslkdtNUHuWiDOYR+vMazkcdvtJymEnhlj+YFUCCudvU/Ai1f78OASOliIXO8Lk0DYbeC3/VVH10DB6yKyqVBWDYS6LnckDFZQzLWd8AgNuJEQZx8XSk0Af8dabAEi9Me7xOd+BL/udTjRJZBNTO2v2D2SOt8c4xIVUGWRF2DbytU2tmdRnIQ9C6OeLKKVS3sWRIDw0shsLgRBOYmhYDuWzWWs+Mj+rps8hSKMZBZUHzhG4USZKtV6jSJW2hvBS0te3hYKxNAeOGJRLhIiq8TgjCY0Ib6TWLvksXjsjPpz/hRsB97MWN3O4XjrGtgD3EiudQKOyVs42PPL2Hd2mfozqnBSYd1NInWI6d2b/MFMqYMTaQiRptM1MEANMivbZ/XJBpaPMqvyuASS6cy76373Na6FFEbQwqhwhvJz0jz5J5QxcdDOTHztRroxjEDjwULMNikDZz3y6tVeJ4Oz9C6ZUENwrlbs39Z/Z9R4pJYuCoh1F5NkpKxcfUedyImp5P/TbEAgSOTj6En14suHM4b5q57RZEei6zCJnlu8ymTaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> gen_init_cpio and gen_initramfs.sh are part of kbuild and required for
> all kernel builds w/ CONFIG_BLK_DEV_INITRD.  Move both to scripts/ to be
> more clear about their importance.
>=20
> Link: https://lore.kernel.org/all/aSdrCFkUQup3qb-q@derry.ads.avm.de/
> Reviewed-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Nicolas Schier <nsc@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-move-gen_i=
nit_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org?part=3D2


