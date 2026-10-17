Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14B0CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 15:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2BD6B0088; Sat, 17 Oct 2026 11:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53A96B008A; Sat, 17 Oct 2026 11:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69D06B008C; Sat, 17 Oct 2026 11:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6456B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:32:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74CB8A032E
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:32:56 +0000 (UTC)
X-FDA: 85332511152.17.EFD007B
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf08.hostedemail.com (Postfix) with ESMTP id 952A916000A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:32:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="i+vP8gz/";
	spf=pass (imf08.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792251174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=awm/5T3OP8nOySmaCCffHZ2HNGXR56c+zXIdHAAIc7o=;
	b=bKvT+kBjCnZb97fiDSZbcB+HBYGWiBY/JbH3a1BIKvvv3aOBKNsb99IaDZNZ/A/gLZbGE9
	gh/mIC6/rVRGcNyzaw/0FDmdqtJrxZCwrxWi42El4YYAlW7/gIfyFqkW7Y9WWeOWoUi1Zg
	5z4nCZuaScBtuVZGEIyKKGaZUSmz/d4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792251174;
	b=hWo95PpEGjRNGQGUxNRfmt14hqYcJokeoyVoLy7wkPe5HE0L218RZkha+gg2ILn2Aih5wS
	hqtm0sEZn4RgQMSh31ij71erKN0fQU2x3xaYv6Mfp2LbZx3QxCr/ZR8zojantMETHCrpdQ
	jWDrGdL1g9v44cJqVhWQZRkmoJuoXlU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="i+vP8gz/";
	spf=pass (imf08.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4j6Qmg4SVdzKmwd;
	Sat, 17 Oct 2026 17:32:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1792251171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=awm/5T3OP8nOySmaCCffHZ2HNGXR56c+zXIdHAAIc7o=;
	b=i+vP8gz/PgzUMFCTE97ScuteN1psg6DccE5r+va7MmD0Nlx01PCH3SHzKQlFjfs9hMkE5k
	EABtAgU22fv3uacWuuyTANWTDzGF2QrNnOiysHqAzlx+njp4+LNwPWs/xyS/Mf0ntZHDQp
	IzXaaw4Tg3QOmfAqOD8ZayjGzzuabgBnnNW5JEXdh8GdlmcTAW3QqSVgcLQsY3dmMUK4GP
	Jv6vFHx2gSJyginlU7cC8azrv5TNZeQn6h9b6jymJH0FVbpCEDOPhLP8w2OFWPVgaN2nj0
	t/8uW6LCaoXbW1n9qyyHLZa1LQZc4nWbTWkiahoFpt84hU5HSS2pQ2Njto+Z1g==
Message-ID: <1061edcf257c9e625efe5f6f000013e9b2d4c650.camel@mailbox.org>
Subject: [Duplicate Text] in mm/damon/ and Doc/admin-guide/mm/damon/
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>, damon@lists.linux.dev
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  Randy Dunlap <rdunlap@infradead.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Aveline Noir <jm5905938@gmail.com>, "Adrian
 Huang (Lenovo)" <adrianhuang0701@gmail.com>
Date: Sat, 17 Oct 2026 17:32:47 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-MBO-RS-ID: f1c05a7b6cbdf6f28a8
X-MBO-RS-META: 5enp6ifq9dbwkjns356ocpn3tbqsbwnj
X-Rspam-User: 
X-Rspamd-Queue-Id: 952A916000A
X-Stat-Signature: fdgqdoicyuxrxygcfk8jxu9srhjccoek
X-Rspamd-Server: rspam05
X-HE-Tag: 1792251174-424746
X-HE-Meta: U2FsdGVkX19cFPXm/E4KCm6E/j/2J6fLYpCc6UCg0KzChtOrON5X/QfCyWjnhzuKqUzXjTtMELOLRxuRw2/WxR6BtjchEEJDjChagn/RW+qYsAepmN9xFK/4W5CdAKi3IqRfjay7WHa+F6iLgow7zsOoXZSlg5JD6mPAu9YvgQtVKuzdnzjO0ESYMOo7nzzcS0iU8Echocui3d7oe28ET0DQgucVIc4dPymIMMF5yiee5B8Sde7b+SqB0Oe3DnfNhbwqZsvEdEzgY8HX9LqfhmipVCN0eG5DSas55Wd2Ld/8fJ7blqv8ekK6Qx9p45PkLdfLVuz9f33t+CI7//ejIftH2W/sNWxP9bSe1Uoq9/85Rpgp2D+AjMlyZqh5HHrdJe+9+2aAJ5OIxZVx6WF9MNe6/884aXZ04fQYlnyeYp0+kXDybnrlUmCk0bJJtskGQdlABzlPj8t0AWo7ixr1s4dMU73PcvZqH1P5qitsDt46qgMu+nVj0MT67gHao+N0ivp7FTk4AUbwcJo1XhGv8QFBCMB+plRMmocrEt4/CET8DXhE4MfMpm237c/dE9Wr7hGQEJwSj85eBCg1OFoMvFHyMtJ81XYtGsyYdxZjTKaDhLg50ypAHCk8ilJXNmE4SBmO4ZYBI0VKsB77FsMVuRXNeEDKijr12xoBMxArBNn9DDMoMnoO6+zeoEYYbnJOYo7iQmcmzOd2SkDrjgcN9aeZoVmG7LenisXT3EMA980RSDXX198j0qoQgi4MwEy0aRlfnJiLx68lM7L9lFbAADCFBl8YlSr0z8mRHwPAQDk6lgHJVVzPEKfuqm0WfiGe34aogM/brjHV+OYsjXoHzQE4xQqjAZciD0b9gOn8JzazJ9UdTgF3c4m4dMQkRS4DAa+eehBRe7Y9/6zkjF3jJ0k4RvWsohBYo6MvwLp/JKTlGVcYQSes4lkiG04Ah2GZTT6cnozZpgh2p/lUGN7
 gxgneNAg
 4bCGpIw1Zdb5vAXDe9qokhqPhfoesIP4xvvCTCJvmWIHJdLBvdIl7aMLD7O6scCpx2dl2qq8I3Lou9FeoDuPjcOqJmJa2Wncw7Fqa3zLYKRaChYod/lsEuckmoXMC/yx1sy3/DSI64ROMpZZZN1dOh5UlvesDYTC/bBu3aSOzMKzs97/JU/waTT3FXmJcCyBpV4atoPPysXvKfxyh4t9UTPq/S7t+7wPqr4f9jvlrfrs+Py6vxWW+LFIh6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

there is a lot of duplicated text in these directories. Diff doesn't show
any because in mm/damon/ the text is a multi-line comment.

~40 Lines in lru_sort.c and lru_sort.rst,
~50 Lines in reclaim.c and reclaim.rst and
a few Lines in stat.c and stat.rst.

I think it's important to decide on how to handle the duplication before
patching.

Delete one set, keep (and fix) both or add a reference in one place to
the other? Could sphinx do the duplication?

Thanks
 Manuel=20

