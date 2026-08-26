Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15DCEC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 18:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5BA6B008A; Wed, 26 Aug 2026 14:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D583C6B008C; Wed, 26 Aug 2026 14:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47686B0095; Wed, 26 Aug 2026 14:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C50D6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:48:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C9ED1C0C66
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:48:36 +0000 (UTC)
X-FDA: 85144306632.17.198A682
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf04.hostedemail.com (Postfix) with ESMTP id EE1B94000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:48:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=IhVrX5yT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h Rmcu/I";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787770114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4zU9c/JNdk5KJC+Sd8nuCSHq/+ymmDGSesrVV8zzl8=;
	b=hGOjbNODUtGZFHBp4UJRYHvLphdHAgqYw1HluHta5fbiMgSsynr8TPjlbqMquMHk4xzf/n
	Gw9P5N28ca3bkU0qAD5qKElGDgdr6uAoQRCSsc2GcdHwdgh0Nn8Dhv4kGV3dvjTgPcSqyB
	wUwvrFcvaxOEv5okv54p/BEsWa4yr7E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=IhVrX5yT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h Rmcu/I";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787770114;
	b=xa9g0xboxgnlNWNaJ9Acvc+wbUmOTZONUMRUN8Qwr4rt45NY2I94gRuUxvX1LmeYPo86X5
	RMzSIF2809iVxIO3RPwfaUWuSmdUgJg9irOVtoCFQ0WUo+XEZN8fm/+17i5UGfb4fmF1ec
	l7VTJa8CA35PhozHuWe17GRAvHbpAHU=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 2D8CCEC0201;
	Wed, 26 Aug 2026 14:48:32 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 26 Aug 2026 14:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1787770111;
	 x=1787856511; bh=f4zU9c/JNdk5KJC+Sd8nuCSHq/+ymmDGSesrVV8zzl8=; b=
	IhVrX5yTPt8Xnhzy/yUIwFjv+jVH4XuIrxY9SfvWNmpw1wW9FEt8cwMlEznP/f1d
	xxOcnqxcTRWu8VQSXNeRDIjJobmvJQG068Lnyn7Qrazy/1ui5/4Qb8obE6lv0/09
	k+AxjIPqhHjpqqZkKOkR93McV3gonWbbmV80D6S1zheqTht+/o3ic9BjkuTZZOPq
	dGBcunqrKVBsbBS5vFicSnOh0Z8knC5u/X5rqvFbnOop7VhDe+v+idG3ns68Dj6W
	RJDSK3YSLJeT1jNyALPDM87VOmuBZRMfihtmmpmOQ/XcaUevF6mo6LmDsFD3XZjs
	P5irH8Ki/PIEoImd5ZKJ2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787770111; x=
	1787856511; bh=f4zU9c/JNdk5KJC+Sd8nuCSHq/+ymmDGSesrVV8zzl8=; b=h
	Rmcu/I7pLUKE/vxGJDdCqzNcwYS5BrWQ3XaYWeuGxJTvo/7ZE9wKNDfmofR5+oRz
	WNBHv7zl4qU0LI+ypEYVRxmZQ7Da7fopLHmEMQ0C8RkDaBnKEGiODxsqB2/gKLQ3
	1mq+8IOYQH/n/FUNZ5litlyjumTCYKtOlsbpz2VWFcArklef20fGp0xCtHK5By+j
	7YDrTvO6gWXgfFV+qNrHyRRvEdGdYI59z9dzXp40WsUvEJEiXVEcVS5/RVQRhlAN
	Dfzk5f2aR74xhlvKig5hPY675SOhW2787Jbf3e3vACy00f2FBQWPXBZlUI0oU8fU
	JdUzRQu7Yz65mwxTsBZow==
X-ME-Sender: <xms:9zSPajgupCG8BY4ZyIMGUe_bkjrCt5qybhm0IqtRiFptc1StepAveQ>
    <xme:9zSPaq3RnNtNDc2dr_2ZCNjAqqjHIhTHJP5Pni7KDB8vRUJFOkHbKf4XdSwCGbDFe
    irtWZ_FO9wsngl6dbmqzDBU-T4yO7LP2RePW6coMqtU1rX3lPKoKT0>
X-ME-Proxy-Cause: dmFkZTEpJFbkILkdbnjJPhhmIqMU7frV80/nt9hFZsQu4PZ9qgJjoHJyPUWOrwrcASJLCi
    abBYNRANM9ymUYLu4eDv6nLUvz3u+yuAbvEC800+m2hdGgGEDc9Q5Kn4vPfteqbrTFlH9u
    IiI2rNBGoS4iM8Up8wSEqKfxSF60yTHji+aKM680VRZkwna5Sd7/qZXalPIoE2NrQDP9g5
    azVWcv5jzsjf0M/3+Mq361J+OOHmuHQB0kx0ps2KHxXXbhAPlPQyZEO+PuqUmWE4P1ZmY3
    9Pl93zfQ5JvJpAxAU73uHu4r7yTAwEMig1jH0pqBZIX9BUGFqPrfJjXgFnk9+yofRnGWJ4
    a7Kp7JQCrM8mNfMODBVDAvhmfX4nMrhdnbRlpL7bKUc3eHzFP6/PWYVzwAKBsRJlL0zeM6
    3dkKSs0EAISwGAqfeV11ajXrj6JxloHFs6bXR9qcpJ5Fk8yxWBFhSZg0KdZ/950y+ZsnlM
    snrhuXa2E7YR4/XqwcZTUXqNXo4ILdyKyj1vccPJvzA6BVQ3k15S/GSgUwQxJEPVnI0yo7
    yEbG5nhte6DRa+U5nufffKmXyP5iEWJuP6dOk2gAxHMZ0eJcd7aJMCRhf928g6k4ut+CXn
    0GCtyN2e8TdoHrVjTsB7TpS02zk4ojw1CbCLQBXhGFqpl+uJOMFFa3fvHt/g
X-ME-Proxy: <xmx:-jSPavw-Z6GFgrl-O215TTEgOmon29324qhtnwq77LVYoVcOXt3y6w>
    <xmx:-jSPahpOEZvHqHBsoM0u1LaUtCrTwLSMUL9sCVsRgX4ytDqKGpBiLg>
    <xmx:-jSPavc8SMvZagtYUGWzdqX3SqRBKgVL3bg3GOLmG5p5kHHLeHEAPw>
    <xmx:-jSPakoDo_Xe_EHu5zD7CYC-Y5PtxRT9GOeN9eDvdYyxsECDUxgePw>
    <xmx:_zSPakqSMyvGK_Wf9cZPt0W3GU45cUc1tUt6hb7oLSuolHLWWxHELk4u>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E2A3E32A007C; Wed, 26 Aug 2026 14:48:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A-UguAUR6dUN
Date: Wed, 26 Aug 2026 20:47:42 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>
Cc: "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Christophe Leroy" <chleroy@kernel.org>, "Kees Cook" <kees@kernel.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jan Kara" <jack@suse.cz>, "Geoff Levand" <geoff@infradead.org>
Message-Id: <8ddf7d95-05b1-4758-9b5b-9360db77f904@app.fastmail.com>
In-Reply-To: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
References: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
Subject: Re: [PATCH 0/2] powerpc: remove spufs coredump support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i7r5a5zc3fzihbe1qpxcwayyofxixmmp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE1B94000A
X-Rspam-User: 
X-HE-Tag: 1787770113-499163
X-HE-Meta: U2FsdGVkX18S19uHa/kf+46BMdveo6TJac4a+mGpaTU3bzkUHtZhlRQ7QIS2xAGe7T4Vl02RU60pv5h7Mv9dZ6RVS++Z4G86ed4xTsUsZguVlFt2np8z9SlYBDqip5FkoT1Urx2Iv3FZD7QblxAXS90WRLfWN8y314u/K4gEXwe6GaR/D9P6i9csFuQw/39sT/Sdlmk9Rfo2bE+ySlAUJoo6pgjwL6rY0oxmsngNCwUHbUESNnzTpjoadD4CiIkBX1mj/suKg+zTXERXYkOLTn9aj+ip+kMDX4mFLehaA1vRHZJ2CnUSPYN9KeKusdP0qjxJPmIrcmJ5Fa05TiQItfF00twf3Bq52Q4kQKjcwtGGI/IZKAHmtooQEmbHwFU+fZFyQqk97jMEZVFKqd026czEs7Uw/BvnSweDxCv64lyOKJA7lmU7JgzH9rhbbTyLfgc7XSIamR6GDsM0JGUVMAfMHmDKsoX2sPwcb76pqzmjR6H/lNx8pGlLXbvpNFaDbr7ps+Dt4pmDkqx6WI5llG+Cv6sSjVLxIY2G/wS4cDNU71nJnN79+HY9uw+Mp+f+iEDexoX2zUatvX3M1sY13P8laHXDeCG1P8zoO45V+g0RoO+W6QyYGlMLBlN1bSL5q70OhUWkP6Cg7H2L993b5n0d9vlegMRPSmuM+Ei8JBBxA5qfH8CKI5yGGbBs+qx54rLEuG0DUlujwW4qNpqN3v18meDso4KUblhjecQney2fFDQHkxYoMDhO5H2i8Or/5qti77CTYmu11vkAVCuJ3fx+YV0j+S2gF4ZPTDqUKN2ZFOYB/baJgboozGwZekBARZtpbG4j/6u+T+BP6IwC4g5mBKclKdIlZEgTuhq+EkFIkQfFk5EXxcv/3vkGthpUcXirISAf1LlVx0YXf+71Iy0WM8hXAhYeL40nskSkvv4dK1Uqh3PpP2arm88ZXYC34XEHlqdYHAaNNotaCsi
 bvhRFY78
 B2z9BOPVkKRMVm6WpBgmObV28k1rZVNJW0M6YKvNN0cMmKEF/9hpOfwCYouiNEoNgrxwPVhZC6s6V3ujftpJr4aEZPs4zT6uRcUIRwN8lcvX0Tv+jFNJ6pqId9bvnFjLXltVr87pvC6q6abp8KwOR02XXVaWby1W7GRCygAPEJLovQ9/pC5+YVSwKEQbhMn/5oEQ0oiqY/r371Iwor+MebCqzMA9cVbKJ/M/2Gg00jnCintMQye2GKnrqqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026, at 18:06, Christian Brauner wrote:
> Note that the IBM Cell blades that shipped the Cell processor were
> removed in commit 05bf59fbeef3 ("powerpc/cell: Remove support for IBM
> Cell Blades"). The PlayStation 3 is the only platform left and nothing
> there produces or reads these notes.

I don't see how you concluded the PS3 does not produce these
notes: as far as I can tell, spufs on PS3 should still be able to do
this if a process using an SPU crashes, and old gdb binaries should
still be able to read them.

Whether anyone is still developing SPU programs on new kernels and
would benefit from the information in the dump I don't know.

> So remove it.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

With clarifications in the changelog:

Acked-by: Arnd Bergmann <arnd@arndb.de>

I have no objection to removing the spufs coredump. If anyone still
cares, Geoff Levand would know, so I've added him to Cc.

       Arnd

