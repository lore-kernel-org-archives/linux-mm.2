Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC8BC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 10:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD8E6B0096; Sat,  5 Sep 2026 06:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E706B0098; Sat,  5 Sep 2026 06:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660AE6B0099; Sat,  5 Sep 2026 06:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE20E6B0096
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:53:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E112C0302
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:53:26 +0000 (UTC)
X-FDA: 85179397212.17.2CA25E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98674A0003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:53:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebNWGrXf;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788605604;
	b=cKjIZftPXDghskocJd7bHR3YlCBpDvDmSx1aT9u3SHGhmooddUkDNx0g6WK+lmUJ4OfYQY
	jM1QIa+gGyDEyBVQZTnG90fCqRrw9xnO8ffXTL1JLnKtGlp/AJrWJr3uQYCqnvbiWk8J9D
	0H2/wqOs4z0UHGIoZGPl3gpy8wYjAy8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebNWGrXf;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788605604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GwwIxQgkGwVM+G43IIXtraKZ/pHWrEky2k82RnB0hvs=;
	b=1VaXDN095X4ouA4R/mFhSM5mRvPPqGyUIP7SsVhgt5WMR8IJNYU0PgyphjyhtL/qC2Thii
	wytWvQYG2LbqWtyU+jI2YgrkgKBERrpdqW3VhefeuqFK9HYx9J9/4xl4hqSNpCEB6hq73L
	vI9TIXys1PawQt7C5eJNWyr3x7RCVhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 730CA60229
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE991F00A3D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788605603;
	bh=GwwIxQgkGwVM+G43IIXtraKZ/pHWrEky2k82RnB0hvs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ebNWGrXfyqQmS/eccwAEAJIrsyZWkdNp0zYZuqMjHh+xHG1G0q5GsKtx7Rrv4lJd1
	 zZwslPkDkMz/6Azp2Aa1IH7hzy86sFl2z09bnSgVg2g1NX8tvRAceViepomg6TS1ne
	 ihkLO3eQqEEAIR07+EkIpCjqVTp3xVkrhQFZYNZflpHmre4dTeSC0rgrYkS2vnD1KM
	 sxbVSk0Du5Upllolt8QT7ZhvV/c2bPidc1TbDjDxb28zHcSWg+CeY3oALrs6F3fSuS
	 MnxjZpUfZ4sCEWVxzgDLxs47PGuiXbexp/Vm6Hpnw8BbKEFpSvg3PTk/yfcm33D2jH
	 33ZGG7bmTI7XQ==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92ea24a2dbfso242054485a.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 03:53:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxaSB09yhqAA9PeReTD99psZnJMmnEME/iVmLq34RBh+EyQ1JsQFMfSTAgqa9K3jy2Xzi9HBp73+A==@kvack.org
X-Gm-Message-State: AFuF++lzE6xalumzSm3JV2oJwg2T1uFvGx01TS1iBT+1v1binMXh15uU
	WddiTRRFn16M+QokQ/IlyXE+NferV3e+15RmtPwE7Yz8AFTDgqRadYnPQkxo/GA3F2xu7ZsNC1N
	XGtOIWb1e3JqI80qqt2pxg70fladpnIo=
X-Received: by 2002:a05:620a:a412:10b0:939:8116:fcc8 with SMTP id
 af79cd13be357-93981170886mr762226185a.51.1788605597677; Sat, 05 Sep 2026
 03:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-8-dev.jain@arm.com>
In-Reply-To: <20260901054358.4049095-8-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 5 Sep 2026 18:53:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ynguzJkBD5TY_b8qJa8-QG+Y4oJOU+s9eHX9VOhR+TCg@mail.gmail.com>
X-Gm-Features: AcwNN1UeolQ4e3PMULxDOqfsECQTeGbroVuUoAuu7VwKERT-1DPC95ILoXEsb8M
Message-ID: <CAGsJ_4ynguzJkBD5TY_b8qJa8-QG+Y4oJOU+s9eHX9VOhR+TCg@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] mm/memory: use set_softleaf_ptes for uffd-wp markers
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98674A0003
X-Stat-Signature: dhs5hubeupge4i16479ogpd6f7qny6p8
X-HE-Tag: 1788605604-204993
X-HE-Meta: U2FsdGVkX19IzYWlCSrYkHX5NQ4qIuc75rVboYESaKL1jFQB9j9tx+LbhbPUIkn8wb6pIO2lR0E7fM+RfOZ9DeTcyL34DDWnQtE4/dzWE4g9mTEv6IyYsraQN1cdROaQIMuznCKNjILupdvbq0lS3zxOFbwbPZs/IkXea+E93t8/ArLV6iuJqoz1CsR6EjchQ6ZKPY6vHpq4D5kNHa45c56ukDAS1vImpDV6O4uilKDjx/KDc2uhlNP98W/8ioNThzK/LOuN0w6vzFQ4DrOsjiemT994O8NS5T1MhF+R8keVAUip7BBQPKmlSqUJyNHyQdNgpgMrHl+RqFw6x5B2qxvx9BjE/xxKFtJmQ/yV1ezoPQbNov2YzjclxhRdbLdeb2U+E8j/V0K++5qt0Muh8c+qVbKjfroEsH2RUZter0sZbzi46WyvdYLxpPqDZMCpi15LC2p0FT2qRou2V1mjlLIJG9L4iu9INFT2rs5PwZi8Y+2neJUganZNE0N2KPFfgS2dXyzwPeyT/o4eqnq91AmEBhheBUZdPw8HerpCPe1uTszRKnqQPvMgdQeESBGb+2wHkcZZMm71LnLPZpdJ1gT+Vxl70H3UF5djoldeAx4NNLVcQ/+GNapJBeIItOqJ2H7niF8+hsuQpp/fWzLumEezZE3qeinVjBLKxXPMeqV86YcBkLI+gTYX5mRxBunnmA4wYLfAPuTp3LJPwSCKcGi9nKQjxzpI3tF3tgava//R7khRoRQablY06v8QotCedWvqBAdc9kW38XaVoh7uwhwLpHc+f8h0T3R0a+JUojZgJp/psjwN2nfUsKcgITfs007Zu9bqKV6HcrKYR1LlbSukz0+TcA84ci6aune1jMI2yzziwYM7YGWLuV1JUjKq3RumimDT6ftVp1R+z74obsx3jsevNEA18dTFQFu1VBDNQjj72TAyGor2cUDaZG1h9dinnqdOH3926ygAPNF
 p9wiSyMw
 XC575oBnSPenL20b14GR0E0kJK27CoheMXYC5rj1u49OwcjKx72zDm4EmMjTcwAjwY7SkYwsgo6S6MtxXQITwh5IU9KNcMJM2GCLBO0K5OqjOwiYGBNoMZBdzqAEjmURN0qC5AS2Qz6gRhZUCIFT2pv8BF4/CF8R+Y8su5nf5Kcr/1fM/FMG7C3udMdu7HSQ49WJ/uZ+3zCoZaI3De7sPDpnHhL3HR4pib+dLnoEiNyPxF2y8cWCU0u7gKSQX/LiGWq9NlmUK881zFUZ8QIVMnv4pGigqMSlaeCJ4VcPuvi+wgp5T7LiXznBkVNpHcDaN+sawRQ/hzgeB1FhfoIt7KmvRFaRfdpFQcQNc72CcvdegoSIO7VI28874Rg5tg7E0ZrjSLBfe4t0cW8XSNkgp6lqKTnUd9o/qQmzYezmoloWh0Znj6GtJDO5iiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 1:45=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Use set_softleaf_ptes() to store multiple uffd-wp marker entries instead
> of open coding the batched setting.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

