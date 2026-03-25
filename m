Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811E4109C034
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAAB86B0093; Wed, 25 Mar 2026 11:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81A66B0098; Wed, 25 Mar 2026 11:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBEF86B0099; Wed, 25 Mar 2026 11:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0E6F6B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:33:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E1E2BBAE2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:33:06 +0000 (UTC)
X-FDA: 84584978772.26.60403CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FEE21C0015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:33:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d5CsmeBf;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvWVTUgf6w1AXSx3Wg4/erfOza/20+14ifQeDfmFXV8=;
	b=U/OKHK1SFVBtkncGWD5wQ1J0HAz8Go+OCSxKprqCQFDlgm6YpYqCQc8ZxdfakL5PRyBs0I
	OLSshWZjq6mCXfJL+yOVWNZtcLNijVVSC7iPpDg9rXR4mCNLt9GW4WB1lKn43gHMCN2/nJ
	+ytM+7en7Ik8zbMiqB04GLVlgbmsyEU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d5CsmeBf;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452785; a=rsa-sha256;
	cv=none;
	b=jMCgDxTNWi/f5FpwoHADQltWxIRjM7cSVdKE4gwP36dJaDEm12eCnAEqyLkaRV96EkrCGz
	MOrtREd3c9TQ7dtNatZ7+OJiZAzquIFeX3jJ+dpRwgKfvrNTt07VSC7Ej864qZzFkB9Po9
	/YN5YoFYHQ0ItnmhHIJSUE7h4BRbO/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B3EF43DB7;
	Wed, 25 Mar 2026 15:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B941C2BCB0;
	Wed, 25 Mar 2026 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452784;
	bh=T7n3kYoF9cKOPNN6IPaYAgeLjjX+mkPzNg+Va4FI/6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d5CsmeBf+fIrWJ2sb2LRnHbwvi5AE3FuqklJLJpfm8jFWPyiX1ZwG8kRlDk9jL20F
	 k5e0CFMD4Fcj7YcuNSrL45WsSVLYXRhq/AyhrDthEC53PcafET2bEKw4+2ypqaS4vf
	 Ah5G+/quEqcjIsKVrAzwgjktFES9elXMY+fB7RQkET6Rhwjrv5mDfrh4Jfp0fN6k29
	 viidAKX20j25BMKkk5YWzgSDJ+mdFV5so4mvS0DxA9kUJ4qYsgWoAic0o3Bk2dX07O
	 JmrRuGYTzxuvvXuVr0bWkPzt0NIlp7ZPyZ2MQwwfR0JinOfhlm8Vmp8bKS8+ClkplQ
	 n7Em841g9Ibpw==
Date: Wed, 25 Mar 2026 17:32:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v2 2/2] selftests: liveupdate: add test for double
 preservation
Message-ID: <acQAKTjkIjcsBpaf@kernel.org>
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
 <20260323203145.148057-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323203145.148057-3-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FEE21C0015
X-Stat-Signature: p3a1ekf6i4o6mko4czztbjgbbp3mqxu4
X-Rspam-User: 
X-HE-Tag: 1774452784-335386
X-HE-Meta: U2FsdGVkX1+HEYEyfmBkaV5ardepQZUrHw/NQao5/mnHO4Q7p6iAIGFiLMHSN8+5qfQ9cTT1qrH8zUj2dBzKQjS31b61gsdfIA7yigP2w/zMWjmquVd8eeSs099R7QATiFT09bPUnG/tmCGAPjU5p2u9QDTUpIZgxWyByBq4NcQJdLWX9+lRA8i3ynTb7qD70QbL11TVzh7BaK7wuA0vd42H2QFdOgHCtSLuvXGm9ix4aTtDsHORE/EDfjjFzPYaUDdVYgdgfKVK+a20wUZinRXKttqSGNpePCJUQn9pSlShjUTJTOXKHlFiTgUutVmPGXjvofnyGDni9lkVcezcz8KdicBBhIgcQRmTpiGRRKAp9d3DKBj7ZrNAJO9LKZ7i3wXsQNRdMKf52pxPstr4CkCoqpG2/AMnb6pqDNHJ/XATc45iaVCi3+KK6otrGeYQV1Zh/zlEgoX/ddOSqkdi4ACWhG/dkwaqYHAtxmvl13aEwjEFeHsB3QtrTX0z/pDZg+D0SAmua2bEereXGN6fPOnf8rOuWIXnZzDZWErBhdgsDgXw1Sv/uMQKxlTeBu2grSAleJuyH5wT01WmHgm4MeqmyzeGSUkNwAoK4mzKULj36o94GQrR+194E/U+VbZVjDBmbQcu0aAdpss6Sc85R+zUXRmfzNDEiMcMNwR63FCBpsxnKZwDghf2ZS/ZNwGeL/IZ+gPmSMZ9hZCc58Kd6dMc9ihL5JDP+VDvQ6XgP7ex3Wij5ywAFY8RidXG07/qDrMjQbKduTo49HMa43EOo2uwR0OSsApX2QFAH9H6+IqC1ZK+/l01ACBGgLGc/KCdsgrJtxawhHDTO+FEo0AnrjiywDILhMMBNxzGoZtAL7C8pr1n1wC9yXWXGcy/0Vb8nHMRU/tNNtC/F00O0IuuItPkSaDjRPT1gsztokyJgqrexDc9P/MeBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 08:31:45PM +0000, Pasha Tatashin wrote:
> Verify that a file can only be preserved once across all active
> sessions. Attempting to preserve it a second time, whether in the same
> or a different session, should fail with EBUSY.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
>  1 file changed, 41 insertions(+)

-- 
Sincerely yours,
Mike.

