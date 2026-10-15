Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BE0CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF466B008C; Thu, 15 Oct 2026 00:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896966B0092; Thu, 15 Oct 2026 00:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABF76B0095; Thu, 15 Oct 2026 00:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58F786B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:34:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2E55A81BE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:34:45 +0000 (UTC)
X-FDA: 85323594930.03.9924FD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3575D20008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:34:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ly+xXjT3;
	spf=pass (imf31.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792038884;
	b=Mn3DiOl6QCI8tHTgcKgDsq6bWZlpSgFlGyE4GSHK9xv14BGABEtZOgkSc7HRBdptbVJOpw
	3AHHd6uwYfGRIV/y7V8WTO6+tIyTyxoxRvLjNGN0VP0SmCUKdWT5CR3JXe80Rw2PDvesL4
	Jm6VaEcudqsjoS5ipv5Z4GRN+ze1JXU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ly+xXjT3;
	spf=pass (imf31.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792038884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDCR3zTq4gu5VssH7XXKdr+KOGhe+b5fWjQKW9Pd8mo=;
	b=3ta+4Zo39MA+qUaRSzIC/LB9lvZbnGI8s1zvYXKozfN2V1B0cgms8NnP/oDPMZpHwfz4KO
	OiMOUTvISprqw9KERYRdHnCU7FcPxT/2+Wz8k3n5QMe+BKgpBz2lmWUBFzm/wGGo5JMbFa
	lrtj38u7tMr0OMJXX2u9yAsDaWSKnGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D416415B5;
	Thu, 15 Oct 2026 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F401F000C4;
	Thu, 15 Oct 2026 04:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792038882;
	bh=CDCR3zTq4gu5VssH7XXKdr+KOGhe+b5fWjQKW9Pd8mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ly+xXjT31/uiIN5iO0IJyZQ4l6WbE1kf6GCDYEJ7hESL9rU/0PjG1znObm/Qrv9vN
	 pwodBmsKnx72FjNDNYKmj0FnTw+jvxHSDdOpakFJWTLt9MGNA0DYKVUTBSgqAD8jUm
	 LdVN6h38/kD6/OfC6s6PMwaIgw+yUfn5uYuyoKoJ/R4L+FEYkIjs6Hw787qYI02BDv
	 rSAQZ1wrJqb7IsATBXwx1qpafQkJAKcg8XGfFPUcoC8JoqXk8yxoYla8k35fMSszLR
	 qmO05lc/YZxxF9WhLNZ3aD2x2C5rREmclR4biyPu9Lpc97PbD/wi002ozBjXwAD60U
	 yhtji0mr+Y9BA==
From: Kees Cook <kees@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Farid Zakaria <farid.m.zakaria@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/exec: report the skipped binfmt_misc_bpf test on stderr
Date: Wed, 14 Oct 2026 21:34:38 -0700
Message-ID: <179203887733.2951657.8311886793376077466.b4-ty@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014200135.1364053-1-sashal@kernel.org>
References: <20261014200135.1364053-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3575D20008
X-Rspam-User: 
X-Stat-Signature: xzbdurk533dz5wkxntocursfe9ni6ad9
X-HE-Tag: 1792038884-683911
X-HE-Meta: U2FsdGVkX18GyK/QBHZVrG82WM7PkO2g/qS/doiZ7Yob7v1GLKHeFO93RKaQpbWuEJB374Xnp7xK3ElpC5Y/wyD7fvO2RCaxWlmThZOnEEZ0geCI1T5zHFsIhTGgJMxOKmvM4VWo8EPmQtUv+/nDfjyoHWswt7JwWHG8BtnIP1Pa6jsf8LP93hBW2CMuv9GjcEXBb9UfnwhR2LTwQLdtAGPXgVMqeCqUnDa+o/NxnRaHbotOF4aQiNy6iSicamki0eOfPe8mtBrFHgsDGLz0fXEhYMiEuCiIeI53YKcE5kFhpeZphbnPvcWtZI0SebjlYeLfWDPmJ147uqUSAuBm38Y2n2heVeZ8luO+/w02PNYyj02vunFKoewCqSEwINq+zbtWw+DQVQr23a5pODRnM4tHbm0aXQ7OCjacSDC0OKcmPfM4LwLJf8v5s99Lx+HH415xaPKKSbg4G4zz2LBISrDK2BtXexyj0KfZaIbB+X7Za0IYzXVYs8aETG9xWOcuMET/sguuiY9KmZMb2OBumXyGKnkZbQ9/u4uEnZaEZYKInuU1IfOwAeonzNz2C0PjS8u3gw/bmAMN9sBAncGvZK5fzejTo9zDmyYr3qUbIwK+PAcYbEhI5SRI3EPvFIT2qFCpYxZNTjTSctq/caCwm5TWpqqoLMu0O76gdup1I24H4edDFlweK4PssGjwIkUQ8XYuEch2oCrnbXEOuJ5pEUOuwD5Gx5XiL6pejpBVzei4DBO6QvxMRMSh6gHIMhPXOEO2FKXvaWazKDrB4s2gVnkUWy2SGbvHN39BatwQijvHayHKIcWhle4wat6bw0ywAIOEaLd7fx7+7Shec6vkp/BuN+IrFQ4O3h2ypwYUo8BFXzJayZyKvr2OdJTrK5LqQWIGSyRUPWye0Sow6SUWEUrXl/Qr1ZdApbjatIJAHHSTfRy4ewYpVtvaSRCrDMgBFsNkYPuGaeodduO/jJG
 KKvLnpa7
 HvhQjYss+GodwolIUVnDKZ/L28RUih+lSSy6rb9KVAGIM3HpNbco39FBXP1JPm4OmhvQAjw0/iLXANhkcr/VqigwHl2hGZl7TewNNTf3douLw00gqBT0LL19JS4jbXIQ189AHFs+cH3hhlUD9c0yY7TV2N5vQCo7C+VFmG5A+anzXDw4yKl6YZHSybJTUtAK2OS+4C97FIPpDShlaMqCaoI+IW6eQdwpTAoGF5Y/XbJ+UAEXeE0UH7GLIUXmL973TIM9vPdKEqPKlskRJU5Gb+lbPda3uNwxVIQPs3sqjZL7nB7zzb4N/nOAM5ovB2ZEQJ9MZ1FDVDlMYFPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 16:01:35 -0400, Sasha Levin wrote:
> The exec Makefile announces that binfmt_misc_bpf is skipped with
> $(info), which writes to standard output whenever the Makefile is
> parsed. The selftests install target appends the standard output of
> "make -s emit_tests" to kselftest-list.txt, so on systems without the
> BPF toolchain the runlist gains a line that is not a test entry:
> 
>   exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, ...
> 
> [...]

Applied to for-next/execve, thanks!

[1/1] selftests/exec: report the skipped binfmt_misc_bpf test on stderr
      https://git.kernel.org/kees/c/b36b990c50b1

Take care,

-- 
Kees Cook


