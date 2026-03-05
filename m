Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D720F30939
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5097B6B0088; Thu,  5 Mar 2026 06:11:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA1E6B0089; Thu,  5 Mar 2026 06:11:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8D96B008A; Thu,  5 Mar 2026 06:11:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4396B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:11:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8BE68BE87
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:11:36 +0000 (UTC)
X-FDA: 84511743792.02.65779E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7AA3180003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:11:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EvAgJJnr;
	spf=pass (imf16.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772709094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NICvv8J3MIUF9ByAPF1vMZRw9pZ9D4dvv1VCtt3dYU4=;
	b=YA+sNV3kKupgVn/EC1Y0cd3cIj2Tq1ofLCxm2OZo3tHlywp7ChqydLh2PZ+956hMxcK+eW
	lKijA79lVHtFD/QmQ38Fe9ytk5jpr5AR5gDfX+/DbnvRUifE65I9DulJzwFB1O9hjl5qZo
	vOFT+7BFoS974anjTCwU+k896heASII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772709094; a=rsa-sha256;
	cv=none;
	b=4hV2s/BOhhCJI9Zpwj7gEtPzGL9umGXKprhoNPHLlUmOCHBixdnuC68nRqWRJBITX+5AaX
	maGWReyBRAn4Nk5GtCLvB/1d9rssVASBr6/1Xa7g9fCQD/eJpQCs9yRSAG9i5jdYw8OXTh
	8g56JYB1XeVgsAHfTYqk9zJsDPUOeMw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EvAgJJnr;
	spf=pass (imf16.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3666761340
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D890C116C6;
	Thu,  5 Mar 2026 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772709093;
	bh=NICvv8J3MIUF9ByAPF1vMZRw9pZ9D4dvv1VCtt3dYU4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=EvAgJJnryaqujXE2dARD97LtcPKl7wltiLzQZqUQrrRC6hc34BjcLsUhSnKdoya5h
	 z/c2Gd4E3Y1SWD5KR56lb4xkuXWZzyAdxbihaebpLg+ueePuXDl3Y5v3ftVHw/TTyT
	 Dig5xVIU6X/L9x12WJRHV4/JNQkUFdbF3KN9DITZ9mp/HRBAcLGAbEgJzZa4OsFlnZ
	 FGyz/oeLkdD6cvQNTMGXHMIItKPEKBTM1dfnhpsbU2sNj8a5cQGGJ/W8sF4wjsG6Q2
	 EwlA2uiTrykPkZk+o/z4U+AYzXn7jzf0BlEIC4iG4rFCJOcjJTDLpPhQN6dC0WCC07
	 BugRcJ85j8++Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8D7F2F40068;
	Thu,  5 Mar 2026 06:11:32 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 05 Mar 2026 06:11:32 -0500
X-ME-Sender: <xms:5GSpaSk5SyAKmyIflqUXYy9VMs699eQjD-Z-eC2fmpBlMXy7su9T6g>
    <xme:5GSpaUoAvXC_OHFMrlo57ko8vFr2y3wZqm4mIokfdltCnsowdSEmrfFx6ADhbCZEl
    cr3yEFsa_33kV10cqXgSEhfj151Ts978iTg1FPax8Pup8TmRCvk2mk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieeivdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepsggvnhhhsehkvghrnhgvlh
    drtghrrghshhhinhhgrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekie
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdho
    rhhgpdhrtghpthhtohepihhlihgrshdrrghprghlohguihhmrghssehlihhnrghrohdroh
    hrghdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgt
    ohhmpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:5GSpaSfxGytkM113DN7Mwym-LRxF2ufvjMsVoSKkjCAXKaZI4gbUHQ>
    <xmx:5GSpabz2oDU9ZdPs8giRBhgh44XriiI_Yc0fFfDT1ZeIwhpHCuc6VA>
    <xmx:5GSpaX2JAdOBMS_5wFuMYuM5_WtTbstyxDcl6obfNmF3MV6hALwATg>
    <xmx:5GSpaSdYSp__UK0sQAJCt3_zJwpnhZwff_t24xTQZD3fI_aXLyEFcA>
    <xmx:5GSpacUjivZtZ3ABUWxmfwUB-Y0cfnK8BHxZJYQt1ORxQxg_8z9jOSGu>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5F204700065; Thu,  5 Mar 2026 06:11:32 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AusYBuezkfp3
Date: Thu, 05 Mar 2026 12:11:12 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Ingo Molnar" <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 "Thomas Gleixner" <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Message-Id: <7e4f6a4b-fe41-482d-a4cd-5a059e1626e6@app.fastmail.com>
In-Reply-To: <20260225065555.2471844-1-rppt@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h4asf7krzbmo5ng1xo8mxf57sad7kr5i
X-Rspam-User: 
X-Rspamd-Queue-Id: C7AA3180003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772709094-175969
X-HE-Meta: U2FsdGVkX19/egqeH2esked8Am5CUNMcd3Ymu2rKFhRx7XdUzb/aiVNLPPYMxFPVnSjARBeqZBdFsBciqptFXkjwdoFeBSiYTOaO+pYLm58wLuj+WWVhdOZLIE9DHghKUiodbkyIbAmcopu+3jFlPdCealtg/kXmyS44qXm7joyViRdE3SuKEMvd11R6ORbDwc7OFBiY57oJKz7kulAtVM9XdBKw7zUhpwdSiDENSDEdEkeHAfuXQynxv2ChQjoqtWZ3by0zlSArMo3j8xJBhZnWUmtPXxfa8d8X3tq+7Kk4AR6sT84dPV6BtAc9IEhUEYizmy3WsIg4gUj6HRP4/mzu4ZFA8oLcNpLAluron4+T8AMCqC4nDOu1JRn095l3fo+mgKjWL3N3d6N0qrNyxbj7pOX30wT663DHHljTkyqeP/VEGZ4VItdVViO4VTQrjCERNcyp9L1x+bguwr8f1RYWv8RPw9NFZbaABhQAp2BCznV1nrX2YwjLrDn7I+XK/Sqk0eVDe8B12J2ei+RKPFAqUt2R9A3G1CedgIOeWsJ7dLhCDPFqzfquukrXCFrJbYdfpqivq5F2ELQAW90LPAQRPvOx3fmlobrhTugIuenZ6zN1JXHRLroSD4l3qUlBIGtHgkB6sEzaeQZARn+dJ83WdssduyCiu8EhZ8va5xdlgzXP/b2M7mVsPXwjlBn2qh+UlHX9hIDkH6qiUiR0b2HrOJGYqb/vNU5wGGTo1HzsAGSBvkEJcc438+bYLfnB7Rd5Zf4UJf0snpykVU+ALcz9hUIFRfZ6OXbvJHpcNWboP4apKfRpl4MA7EtNg/3VMJi9w8C1EwcRs/Go/1Z4YghwqZSdC79JVJ9+uH+NAJ6cOU5Vjrj3DgFl/Jy2sKG1hhRmXLK7ZNTWuFZtMbiwtyofMRQPp+VIvVBOd36xgwA7HGKTE3cZWwIcV9kfH6yC16qRGraw31nuTJ0tWTD
 CivzZN2t
 +Rb1n500BKjFtVnkUPum3z+zo59bkxHzdDk7pioGhWYiLTUaZYFvk2ScVaZ2KniEBBSoYI19LGlSKqhY2YhuUT6wMh8xHA/FBNtOdkp3LxkK6ZtL+PIdlhwI29PtuOXG19ZKD43fS9PA4LXVQIxv8hzMx9SCiIeI0IJ+wIddIejpqFSr4SfW34OlPtWKyzNZHlvJ7cohi/zlL8XF1Zmf5H1ReYH3UoZRSjBCOZFLGCJPYL6vQu6wuhS3ThRWzN8pbLT0cSpxz6HtEvF4IKs4MqkPpa5EMXuSwEMyG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 25 Feb 2026, at 07:55, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
> and EFI_BOOT_SERVICES_DATA using memblock_free_late().
>
> There are two issue with that: memblock_free_late() should be used for
> memory allocated with memblock_alloc() while the memory reserved with
> memblock_reserve() should be freed with free_reserved_area().
>
> More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> efi_free_boot_services() is called before deferred initialization of the
> memory map is complete.
>
> Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
> RAM on EC2 t3a.nano instances which only have 512MB or RAM.
>

Putting a fixes tag referencing a patch that dates back to 2011 doesn't seem that useful here. Is this really an issue that goes all the way back? Or did a later change trigger the actual leak?

