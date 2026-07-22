Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCACC44533
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517F76B0092; Wed, 22 Jul 2026 04:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8C66B0093; Wed, 22 Jul 2026 04:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC6C6B0095; Wed, 22 Jul 2026 04:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 137316B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:24:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F1A71A036F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:24:21 +0000 (UTC)
X-FDA: 85015725522.15.920C1AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E94C6C0009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:24:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqqVYnE6;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784708659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvITx8GGq0cQMcVSBy1s36c+WaqkR8FCyLCFiGF+yR0=;
	b=YRjiqpU7SWDCQKGcWsQEUuy6OigXdKantzXbbtve94UttdMRhFsZ5TKeJoriuXaphdbb35
	xhPQtfzZjfX/ez6ECyZ4GCs5tiKUnAvwlReVxl/W3Nx9mzzZArFYtrh/IA+2z3RP7mLPuQ
	aAtNC/FhI105KzSXZRRAqnVGLO7SX0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784708659;
	b=I+mZvgGR+m9Ud0mEzTOlVQQvKzi/joMfa1MTnHpigu8WQbeBXdvLfb8GOXuHoVVDC7XYIU
	e+RgNrQmfAZ+sF30ruaKQKMel/xcU9uZx2picTw+XetGXMtJY4dIleEW3nAgV1nEGciB9H
	A1ZQVRet/NazgRQM2JZEoBr3Nk9BIGY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqqVYnE6;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5838C60A64;
	Wed, 22 Jul 2026 08:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE911F000E9;
	Wed, 22 Jul 2026 08:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784708659;
	bh=SvITx8GGq0cQMcVSBy1s36c+WaqkR8FCyLCFiGF+yR0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MqqVYnE6z/syRKP1I0aC9BNkQl/dTAaYwqhebzAVxp/ZndMyIswDrFqqP75IiZtlS
	 2hd2uQ0aDsW9ShgFeW2LYaRLH45M5v5J4oOf9lxPWndq7kgGHIvhSxnaByUTPZKmrF
	 eMC1fkO4o5x5oPEx5zYZWMpDofesGSaR0n7E/aK9uLgOCMa30oc7DkcB9b4inQsoBB
	 1Lg5RAgM/1ChFvt/GRgy1zHLu2qczTVP/igHN6zuGlsgaPpetFirkbTyBaeUYqlBhy
	 pYrfGx0sF0WVPouPlveYYO28k7xLIkDn2xd9azdiXc3vaxQH5BvfhaFof7v9SoqwBP
	 zIvTIZ2qTqq1g==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260720150915.756749-1-ekffu200098@gmail.com>
References: <20260720150915.756749-1-ekffu200098@gmail.com>
Subject: Re: [PATCH] mm/mm_init: remove redundant memset in
 free_area_init()
Message-Id: <178470865343.968579.3846803460551557593.b4-ty@b4>
Date: Wed, 22 Jul 2026 11:24:13 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E94C6C0009
X-Stat-Signature: 67ooojwhtjnp1cbhwzi66zu84u51cfuu
X-HE-Tag: 1784708659-592834
X-HE-Meta: U2FsdGVkX19VrtVRPhJBPLMRJ/Rn7dSyLQs58CrTAYoHuKIsbq3+78ozpUxXkxzZe2ZJQyd+RX7/zzLi/DSmqwVcYI2NaqePed4n31gO1NYF69USRpBDnFh2nzBAZN4CxrQtofmbVgN5+PFCLJN316n4vEFf84pRxz4Cy3Iw5seaOTJa04aHBViT4lleUuWarFfFDcyhiw6C/pbjJaXeEQmw7cRgg6cJ74DlGbNHgQSsej86Sbq4ujt26aY4ZhajdJaNfYHkKb5vPNsAo/pm29t/guqJNDGceGiokPr1hxgsBrwkbi8WRi1Le1uaaNGC/LI+bDM+FFIG3pAmXwiHdMdesLwBLk/HMCAEfWdH3biIYCxpBLZXxNDmYE8TaUu8pBVGdcdC7VGEwQqtU7dxalOIEG68SN6uVA/z/BVSU9G2IJoSczbvhrDXgECQ5Ehf9UWHQb0ivZ4iB4WcUoggACjDq5Bo2IcoJv/CxnIqh6/fzBJTbrN6zPRSDcfD9ZEJLQpDv+uosaAKxxVDCWDvMv9NfvKSxGROrC2nbUAU4EwUqZO6K82UvlSaakJQ5F7RH/KnFVc4ktshCOcmJLBAi3JARnLAexiFqKOcbqJl4NTub0tGikb/FUJfBOySWyJd3XqQOayNPcp5DA8Z3ZCTlmVO78xCcyrNa5jm1qGFxc9xYNLtipNG7n5OyhlQP9NlVzkRfb94+8Qr5oPNY1HiySJCNyQ8uiFZZRL/7jImbdBzh3ewT3M21SDpfzoRWdGxcBUhGAiVh4Tl4KoENu09DhMwz52GR6vmds1FpfU5JUjVAtrHZ3P6AxotrusQx3x4RdkUsuv675RzCaQc72iH71fbY5/Rwnx1IpPDU37drvuwPjCUEe5QrCexraijNhNikHN9N0PidX/IVhANesmLwjjpqmNtXG9qyAE0nJ7YDMFS4M9L6yyYV4SJb2McoWPorL0QHQvvKCR1Fk31nOi
 MbdhbD0c
 g6FRIcTJ+UlCMkLZHIdACABHFXazGhO1sbp+WE3RGL78h/BV+SZEomF3EZNSzWe1l6nh2EZsEjn7yxvN/nWnWrhNgWxVWoQiAoZqEihLLWvv81yvv8uuIBhLfhJ2rGGmNIvCLBvE1uvA/bvmct6zS2Me/Afyv+voLayXnVKGxp0pqbM7FSSKCaRd0aftnGtT7086/J149zZkcyoBHKMe0a9FMeAJM+zNmWTOiM/GqihKDS0RVj+wOKzIzNOxzDesg3KF+RZo5uOuNiAW3pQigljcfGQ3Uz9nTNp1h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 00:09:13 +0900, Sang-Heon Jeon wrote:
> mm/mm_init: remove redundant memset in free_area_init()

Applied to misc branch of memblock.git tree, thanks!

[1/1] mm/mm_init: remove redundant memset in free_area_init()
      commit: d7bfd98ba01d2af48cc238d5525201c83fdef251

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: misc

--
Sincerely yours,
Mike.



