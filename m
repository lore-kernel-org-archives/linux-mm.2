Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DD4EC111D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0566B0089; Mon, 23 Feb 2026 13:13:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93A46B008A; Mon, 23 Feb 2026 13:13:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99F36B008C; Mon, 23 Feb 2026 13:13:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A44FA6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:13:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 553B01C1D5
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:13:39 +0000 (UTC)
X-FDA: 84476519358.11.A82AF43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7AD8B20016
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:13:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=B3HQ7V1C;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771870417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEfSeQ6hDc1YK0/wiSGwFxZAJb7vn8LhWPtGYkKI3Vk=;
	b=O+untqR2jtC3pQus/+GYbw4NJmkstiPvEv7pJZPN6yjGk7HMqxzI0ij9r1kpRt/wK0HoIy
	mM/V8J85xHzjtO5euzM4u2BiXHS8Q54URofAUZB3rg0YbkpTMqxh4D44PTsbW0NDK7yNKT
	zBqhrHACuk3/oJ29P2AgzT4IMKerydE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771870417; a=rsa-sha256;
	cv=none;
	b=nNxIbg79u647iQ6LdNbOxpiBCKrwBwRrBYJtal2LZXjIxyQdEnK4zrPAvkQugb11hFrnWE
	jd8Yubb+NXbJuRkvP8KNf0UvTz5UahTBZEEu4TCHBMkNwtZI5+4lusLXUGkAs4RNlot9pV
	tZNG2kkfrWl/drM68WSv/xpLBkDmNKc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=B3HQ7V1C;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5A656013A;
	Mon, 23 Feb 2026 18:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378FAC116C6;
	Mon, 23 Feb 2026 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771870416;
	bh=pQshwKNqTCLj/FvhtbZgOYNC+VNMTBvEaSSSD2wSuHE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B3HQ7V1CoKgaBIoteEnZFo//C1eOjQmBzA363dlSZJSPGnKwrPagzWWRWHEyGkx/1
	 6MhwDWWeaCOz0KllZsOTIWSRv2FTaTTuUgO3maOmVNlVD3xKMqbal2bskvscPZ+Bhx
	 31nhkKYtbH0jAtANiQoO7gCBg3ymcBqFZCfessdQ=
Date: Mon, 23 Feb 2026 10:13:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org
Subject: Re: [PATCH 1/4] mm/page_table_check: Pass mm_struct to
 pxx_user_accessible_page()
Message-Id: <20260223101335.aa3696d86341260e03989ac0@linux-foundation.org>
In-Reply-To: <68c2f6df2955033cbf1ccbd2b5c2816e72ac345c.1771845678.git.agordeev@linux.ibm.com>
References: <cover.1771845678.git.agordeev@linux.ibm.com>
	<68c2f6df2955033cbf1ccbd2b5c2816e72ac345c.1771845678.git.agordeev@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4xbxcj1d3spx4a4jd8pb4qo5hfufgzrr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7AD8B20016
X-HE-Tag: 1771870417-788195
X-HE-Meta: U2FsdGVkX1+V7nTyKTrBDenemBZpyZtLzVdMX0RBL6mNCKxX38gnbtLuqmavUr8N6L8QZCGo5gpWKsaizEH6FX9685CI2JrK/qDjcAj/u8ajhAtverXSNP3BkU4AzOsvKEryW+YS2xcfrxtEsLduBkPgcYasJkcbqU7AQqUmdE4rP4GudH/05P3Sns5oe+uDEwMPBiNjtpGSxSCgeZc8umzOwSlZx9vSJUY5Irxf0pxAYYwyHaNAPlILrtFujG77L6wDFDOpHYFxJCTar2B1Kk7SLcJsdlxBZ5f4y+klf6Uyse++oP8XgiKRkwby5S7Lt4hUHOWnEnnXdRgzW0b6+gnHoMAORnyUF8M+Rsjf6vPLst9iNE+RMw3s9xiLrhyLaMucBX0iMAAusximqDAkYLs9pGl5irgShb+zDLw5AmrbTYDULE/NiNNDLpqECDX3sZI+m+TkH8epdYoS4Bo8WUdiD/D+7fkSGVkhLQ/ovhfSBu+mh9HBDCswOCr0+ZuYLn0Qe+fYjHlc3gOxhHERfCSHRqVlqSw5ZawM4D/EeL47lMKPuQ5S8V76XV1HDwt67XAsLXZkOw39sb6S+royUMfuVpSH6XV3ioSFTGthw+IoZiyX7jQLKtZcZPso/CMC9+4jkKRtVJxbD85jxbgH6mPXlHg8AbE0EhTLgomnIKKKHoYhVlreqE0yPNo0NDKrjLp4xq7obDfKdBUyl1R8QxcgNv2u6nRYGGGRhkl0GKFvYnhLl/khfjtjRKdQp+TaYqS7LaAkmZjesdZ1MIuVBhKMKl2GvpFskCtH3eT8EaDvwdxedfT7nh7V01C7eyLdigpK8Qbh8gIzkqTr6plUhbCcmwkXriyymYI/votS05S1FTLPHEem+Fjf+1HqtcSLUyXvcL4Vr8c8FoQ4tI07l9HrNvrMMBT9TRGz0xOnmoMfBCZPDZdV/88qhMWElaPbbrl7AonW6xrlxzNl2Hx
 /ZjjakwH
 QJnbB0aYi19c2hF26ZVh5n1/BRa7zfUF+iiL7MwUNE7P5TXCvM9oc78CtlM1H7P44A48JfN4tScY+745XrkvF2ymrWALFqT3ck/vRqLNNuoQN+3k0SS6JQ6v9TU4R9tqVvNJD7szraVvrNNdRwSSegYlRbZX7u6weADAwAzwZ2aXkLQRtuMb56j1ILhoiGDldlmItjgf7Ml8JlQtl26TXYZt9pa+3xFIra4qRZTzfbbZ2BYI7V9yEJXVA9WGswA/fX8u8U9NcZlHqS8+cXgyv2etLPaxX2G8LSzupnGEWDReBNnbzFhgipA/mp9BoCosI9HqAoo5g70vvgg4Rwm4EjYh2zKaS4IcrQT4a94Ox2br6+/r42f3zkoPJlBKIawZbzGp8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Feb 2026 12:53:13 +0100 Alexander Gordeev <agordeev@linux.ibm.com> wrote:

> From: Tobias Huschle <huschle@linux.ibm.com>
> 
> Unlike other architectures, s390 does not have means to
> distinguish kernel vs user page table entries - neither
> an entry itself, nor the address could be used for that.
> It is only the mm_struct that indicates whether an entry
> in question is mapped to a user space. So pass mm_struct
> to pxx_user_accessible_page() callbacks.
> 
> ...
>
>  arch/arm64/include/asm/pgtable.h |  6 +++---
>  arch/riscv/include/asm/pgtable.h |  6 +++---
>  arch/x86/include/asm/pgtable.h   |  6 +++---
>  mm/page_table_check.c            | 15 ++++++---------
>  4 files changed, 15 insertions(+), 18 deletions(-)

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

I assume this can go into the s390 tree?

