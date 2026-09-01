Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F40EEC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8D46B008A; Tue,  1 Sep 2026 14:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A97C6B0095; Tue,  1 Sep 2026 14:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F299A6B00A4; Tue,  1 Sep 2026 14:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9F816B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:36:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7616480521
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:36:57 +0000 (UTC)
X-FDA: 85166050074.23.53697EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C47D8160010
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:36:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjkpBUwz;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0/XNUfK2EdQcaVvEq77+yvetdfCX9jj6vky9UDpQbI=;
	b=rH6SeDMH4QRcoHg8VOAWm2+5Pt/pMEmkJRpUvCVQuS9Sh7/8nmV2PEC6mUqx7LAZR3KX22
	PVmuK/oO7k1tat9vx72b3mDtdrl211QfOUdgWX5mMZRnaf+HR7cxO//JKlgudUrzG850wS
	Q+gp+XBvYbtFGN+HG5OVXce03uWUDIw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjkpBUwz;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287815;
	b=QdkQe2/+cl5bai+oax1LQ9YmVtf4k0NNkDkVqgONIQAcy1Bagz39s5cIAQ3ULyJWRFVzTc
	E8PV0eOHEEfb/Rfyl5iZNvc5uZpCHWxXQOTEh+CjHOAsykqL9rXZVjkfucJzo+WjFJEopm
	wGtXrHX8vNcYpKqEz281ogm1hfCqEuo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADB0D41A26;
	Tue,  1 Sep 2026 18:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11A61F000E9;
	Tue,  1 Sep 2026 18:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788287814;
	bh=N0/XNUfK2EdQcaVvEq77+yvetdfCX9jj6vky9UDpQbI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mjkpBUwz/wFFQrFDhn4S76HiNHhROnJUAmdFNoBvgeRG8ln1yAzQTaSykLUwFazUo
	 Z0iNFS7daRO3nosJ2g5C/phwl71Bp3MQuZNT6zooZp6zNNcDaCYjnx7qGaAPrvytbB
	 v/dqpZhKpzuBcz6su7NE7igxEK7BpxlhMOx1imgPii4qfVe9B+nSwN8rFHCUzZ/ZIk
	 Zmn8hG762uZwUQ+nNrfF/it5hNGrKvqbkE8yOQSnC8UvRbBpy2KOmNShGK6swtyCOJ
	 Nz7bv08yU6PUSL2RIqtRog4emO7r/kkhrJiIOpF40+BvXEY6GPnngewdnnGq/EVgHy
	 s4vzl2KrVbvgw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20260901165205.1025640-1-ekffu200098@gmail.com>
References: <20260901165205.1025640-1-ekffu200098@gmail.com>
Subject: Re: [PATCH v2] mm/mm_init: remove zone_absent_pages_in_node()
Message-Id: <178828780864.3691663.12857933654545748478.b4-ty@b4>
Date: Tue, 01 Sep 2026 21:36:48 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Stat-Signature: awahdd5nmfw8y1phn8mbigw3wn1ptgp3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C47D8160010
X-Rspam-User: 
X-HE-Tag: 1788287815-943100
X-HE-Meta: U2FsdGVkX1+4vq4+5CV1UEqbcNgkUG6XkZTn+yUo9KS6IKLvWcuBeD7anOuhcoPqo426G76caZCV6c8otfVDyWkF28dO9DwiKYgSqSLNMREja4ULVGlsZi1YooHIgsMltjmimYkxmUpAniGXot3SnaRbh+ce8ADImUhzB1fJOlr81uP8uI+CT/3QrEqpAeXtDclrLHqxGohSr8EIw+Vmzv85CexDTyf8qvYUNdsOVddLjdjQBMONV6S9AvGLaEYKVztz3K1GvLVNfac01nx8QMBf2LARuU8/QDunNbtNjDQyLxv1ryHWV4TXizGvwe0RYFC179X3cu2w/+XWXvIYR0BzCCxeTAmObNc1RWKLoBvIyYyiYxeC52aq3OjH2nISOL932Ye3o6EVoW3gzjbLRk+qwqwOFLzaSHGCHVNojLXoMS65pBOATmP8ttzd+yNPXHuvCnaeczarp9sWcFhm1hMCE0wfHxoPD6QcKgIsZLrsbK4h0M1xIY8oi88Z1octj/wu6en7+8TkQrQk1xDfYKmTCbAC6mgRKBTz3cNXq5jeF8F5xYL8Zwm1tOtNDqrfXEQVStVz0aJFCME2MUKlnNd4WBoR6MtWULji6BTN9RACTAp5Y2cG/rj0/dxZ55u/quFbi0tXourmH6s//0m6YOcrSPUJf0IYVsfrrFgCBp/DpM6ae/G5Hybi+KCAYhYpfd8vtgGAENI3RgZph4EjfBnJ+M8Vu1RrmmTNwr6ynFfc6Chg+ach+QoxU/KGryQG9k6SooFVYtrZh4jegCSf++ATbUQwrDsm48EsQetpzHHE+sRO3CNPcWrtfuSykam/xRha5bvQMF8c2v0Nke3L5YzJ1g2AoAO3pd4a5nMjazK8mDMUbalOsubVbSc6IrGRPF4MPbBN3J6jPf9QYThZ8X7W2fZF7da5ez0BJRCBnu78YN7I0GSxjc7LIy6kMj/X4NiWCWdUR97hXVbWyi+
 6YLlwmss
 ZrLDr4DY7ZG+Fkv5cUCi/m43UE3sle7BtQErqhFfe7jxjnDci3l7WpO55Yx9WXZF80INIDIY4lnsGuTsx0ZT60SPbnxSX6xTEcaWCTX7YmMM+7rLdjCQ7LbwaonZI68M8/l17I5ZzOxlC5NbTPbyU4EX/m74B/8hOLVcb3eL/PlPfw0VaSqFCk+YUMvwraygYEvSelNXAXOwNr89tdOH+Dl3cUYgXEmmTwSazYZ6fUUrhGB53xa0u5ByFKnYq41aZMHAWDoZ/Qlx0VsiWazYV6r1Db7SjF3SHlEC+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 01:51:49 +0900, Sang-Heon Jeon wrote:
> mm/mm_init: remove zone_absent_pages_in_node()

Applied to for-next branch of memblock.git tree, thanks!

[1/1] mm/mm_init: remove zone_absent_pages_in_node()
      commit: dbffc67777cd752ef3f77818109e1d2ef13e2949

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.



