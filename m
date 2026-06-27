Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A27C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 08:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0056B00C1; Sat, 27 Jun 2026 04:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7911E6B00C2; Sat, 27 Jun 2026 04:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8356B00C3; Sat, 27 Jun 2026 04:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40F0C6B00C1
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:19:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2E3D9081F
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:19:10 +0000 (UTC)
X-FDA: 84924992460.21.C227213
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02357140005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:19:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/qtVLwe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782548349;
	b=rUnnblEOgND0wZPSPwKGb4aS7/D6Qt+eGq9wP8/P8SxavoJEsGD09khKnPe6SQ9l23wyfO
	T40IqV5spjqCmApzzfUA0MHfVkYLr5m1caEaFTgX1H/mTgvcmsHFV/50iEXivCCw9C6MDd
	0OkGJubxqNRpjDhYrmwRz67+ijUxoEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782548349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6yvcAh2bJ8NdCdk0A9b3/sGLFVIdQHFN8lm74CeDSQ=;
	b=Nuh7Cw0QItXUc5Pn2q5O/CinhDi37drB0x62YydT6HuUcjm5/TKtBGHRCzI4lwRMnQ2rqS
	38yGLDg1qH5JmFQN2d5xMzE27BuTRUymGCzyYyba+POGeZObhqKX5c/4lvFyRoWsUrnSQx
	3IdETGybQ+6Ys5zbxyDWqRx4sQfxb4M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/qtVLwe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E10C840BE9;
	Sat, 27 Jun 2026 08:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E404F1F000E9;
	Sat, 27 Jun 2026 08:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782548347;
	bh=F6yvcAh2bJ8NdCdk0A9b3/sGLFVIdQHFN8lm74CeDSQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=H/qtVLwewfmNI7pYK88SnnQveWdSSgFpt2KJJZXL8j+Y+vMuDrhJqSrIU1fBlQ5JM
	 uZD3VDPp1H5BB3Iqj8EeplKi1zf9vllak71ObOMuCfbHJ9mHLDZfcCcifX7Xa78xpN
	 rnyD8dezmep1GeSjpt3glCPirRMqNfsL1E9EUCt+5+e/FaFaZm8O2fTJ3r+RyApAHH
	 qGAc/8W5KBDcMgnk4AxqG7AguiPpy9qwubFu39ghFyN/T194BX3nxzn0AgAr06CmjI
	 geSCZE6m55CZyaerkrjYFXr8KGzvn+aotcTtmeWytDfDLPiLJEWQs+yJExWQCSCUx5
	 vXx2FlR28c83w==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 0/6] seccomp: non-cooperative pinned-memfd argument
 redirect
From: Mike Rapoport <rppt@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <kees@kernel.org>, 
 linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>, 
 Christian Brauner <brauner@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
References: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
Date: Sat, 27 Jun 2026 11:19:03 +0300
Message-Id: <178254834314.5812.2094612523351837049.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02357140005
X-Stat-Signature: s86h4oskikjcypwmrjbn4dajymyk36nz
X-HE-Tag: 1782548348-770702
X-HE-Meta: U2FsdGVkX19Sc2CnkQhoa8IAGVAA4RU0jYkKsdbGV5pbK86ruK1D32fFzdLmkt1VenjeNOHQw4B8191KbT8D0uPnmXNNn9o/ZUbu8HaQBbhU+uTeBtcYblFpKrI6/mW703UbqsBA8LiHqHeaSOnwW3/TK0oj6BuQoclpRI9nPaShf/HY6lzOu52abckaL1pssWs1EttKJrSVe4wzJL9K2YL4iqaEkRFbIHkdw7+c7G7WFhf3/mANIYAgOnvrHy1+99oxSbMTKRUdgLBdDR9pHztkeYn7MGQTJVBCcG4oiFryEs8CeU5FQfbJqXIr8g4j0WgBuJPm1iR+lZj/ela1iouTo3NIobtLtPpdmfSrvcPeVnoR0sGQUKqgdVeOFwC3u0uMAua5gIlcrPfx8q43WbXLUn6Z83ogbkfqcyqxupDWBDUoIr6H1WTKIyPGTBTI6rOO7M3oKI1y9Ro5q5TWrM+AMWhZsYC/RZ+ZXf2ymV6TXO0NQMEFZPiBVRtIEnrSMMckUpi5OYU/CNSvuPQymI16ID496acZFyAaq4iUHl7hrrT/IqVhXQNUBoQYjEIBPJjaK/joblZ+7vsi4+GgguDGWsTP84ODJ7hyxiTq7vzn+CDWzrUjcEhkC5OLFhDcCh1TVY+zOyxBSl61ouL3wL1lzEMSZILzl4FQpHocFIaS6RNyxhq2VXdjeesKDBanjXacYYq5kYIde+fSycM7mB1LOqDB39fooxLXzqOPup80KpaWi6blH76tq7o9oSnrCqdLCsOoWgmiVI4arF7IMa4aB7DCKinPk8mHJHdZAecgCaDBSNhQdhx/uOwmdIEn2XOwZbr0wzDW1FODGiMjVthc8AJdJYen3CgSc2QdvQlR1OP8AuwoHUKHW3lATh4NdwCLd+VdJDEj3dvtEhPILLn3eY5eSrWK3xk0IjoW2n6CVsv25SHX5rOv24zejCpN5noLBa/Q3yO4SLJEcRN
 mB9nYw0p
 6UTSU590+z4stKTBfPLr4XUM0QXaKKSpIk5N5lDTRBoSJzN5XoG2tXBV0lpmsp59E05U9ZQrQ4Lr5fU84O4N4eEm4YO21cdwFK2HM6LHXi26IEcdZlWmqR7fLbL0VcoNr4K+7At/Z3QKpQcxpFh2PfV2LFok1jEuUeBabTo4W8slmOc4Vr8/S2ih/SgNwEYc0Bxtd8R6EOdrxj8Uda3y2sR2VTjU393vhpp4WFG5Eehvkj1bBJW438t8z21toY2Ms/CMbag8PPZDiu9L0GMtEvnnfN7FUnFfF42B8QHPWc7ETWyE89VZVEo823q/rAhh+q2qLvegvE4kvtnDhenVFivOgKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-26 18:22 -0700, Cong Wang wrote:
> The seccomp user-notification SECCOMP_USER_NOTIF_FLAG_CONTINUE response
> carries an inherent TOCTOU: once the supervisor decides to let a syscall
> continue, the target (or a CLONE_VM peer) can rewrite the memory behind a
> pointer argument before the kernel reads it. This is documented in the
> UAPI header and is why the notifier "cannot be used to implement a
> security policy" today.
> 
> ---
> Cong Wang (6):
>   mm: add __do_mmap() and vm_mmap_seal_remote()
>   seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
>   seccomp: add kernel-installed pinned-memfd redirect
>   seccomp: re-validate a redirected syscall against outer filters
>   selftests/seccomp: cover non-cooperative pinned-memfd install
>   docs/seccomp: document pinned-memfd redirect ioctls

This breaks VMA tests:
https://github.com/linux-mm/linux-mm/actions/runs/28274564619/job/83778604364


