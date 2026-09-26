Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9411DC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 08:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3B46B0088; Sat, 26 Sep 2026 04:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484146B008A; Sat, 26 Sep 2026 04:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372816B008C; Sat, 26 Sep 2026 04:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19BC06B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:35:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77EEBA070B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:35:04 +0000 (UTC)
X-FDA: 85255253328.02.6CDE16E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7641100003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:35:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKI4YSoI;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790411702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oS5cGci8QiKs9/+vr+9VzvkfNfCYGybORMZp8o7zYk=;
	b=QV0MCDZtwxYdwMyVIhrtRsg0Wo8v17pu6WDBOqf9wagzXrwUH/u8vsOCye7jUkUNrFfNA0
	sYPlGsclHSCu8one/Pn0Ecw2uSx0TyjVyH5Ysl2wNtptGMV4UYKeWeyXxbR5VT9gHVFhEr
	uXQCfghNTmh06bkRPSG9/gNCssnNpEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790411702;
	b=pU8vWNQUh1Vfxh8sfuyRCyA/cP3lQa+d39NMUZ0IvsiXfilymi7bH4+HlDKOhqbSt0DzEU
	dFPcdxezJijDZW85ecViRsAsfjkutFfIw7K/DSAeOy4rCoE2jsKeXnic9Dhb8DJhHIMc00
	n3iU9yMo5a7bwNhlZL0r/wo42XYfhG8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKI4YSoI;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3119143F86;
	Sat, 26 Sep 2026 08:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1282F1F000FF;
	Sat, 26 Sep 2026 08:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790411701;
	bh=/oS5cGci8QiKs9/+vr+9VzvkfNfCYGybORMZp8o7zYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKI4YSoIet132l4ifkQSXpJ5S/HAo847RXSPWXlIA//sS1T6DGjDQTSrpmN9w+Kk8
	 js4BixlSkmCw0FEiWLxPcvGxE+3BW6mUpaVXp7XnIRL7QdFfavBtgd1//5Iee5neNs
	 RbienQhHQWLrliSen8LuKxiRtjLuTujrUWtILEs7n/v8uXZzy1skEP7wNx/NpddT7Z
	 GKDAu4WaRdM8Gb/v3pq+XXSFKIL8eKYWfrSN8F+Oz6PgY1dZcpz94w2o4EId72TGE1
	 eqRFZeQmkE1AufPSMNNHLAa7nmcdoN/3AKwfCX7m1232ogKRodq5xYHa7hRr5g9vD9
	 B4sDgFN4Tljag==
Date: Sat, 26 Sep 2026 11:34:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Nicolas Schier <nsc@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luis Augenstein <luis.augenstein@tngtech.com>,
	Maximilian Huber <maximilian.huber@tngtech.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Willy Tarreau <w@1wt.eu>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: [PATCH v3 0/2] Move tool for generating initramfs cpio to
 scripts/
Message-ID: <areDq-1iFZUViDgS@kernel.org>
References: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7641100003
X-Stat-Signature: 68fa3ajmhut84fac13jet86xqhfdezad
X-Rspam-User: 
X-HE-Tag: 1790411702-336171
X-HE-Meta: U2FsdGVkX1/EBw15W4O5UXq0obN6SUxgwem8Rlc15JB1YQkpX72X2jE9A3SnnrfvIj6qS5F/MNUll55Oeefia9GLl+0KdkKgG2iTvjI2OmoCO8fWPZhETr7UZ4LFTcqjW1SpTy1oIgrfP97kAyMPBT7N/6m8AohBrqu3JpgIlbiGmF/nvL9SybDFu9yzAwO2DuPTOS/NSn9Ww/ERQ43ozoYADrSGpt6DfAEZZ1ITLMbhYC+NLR6bygoKdC3lPEjTOv4LO4XVAvV2908UkOeza/Tr/pAowpj29yIsLyrKGBXWHNcITughCqBWl1ItJ6baBRfhf97Zs46fYxHnlqaze+ZK5/pFH6lDv9StvvP62s6z+G5Wfk6vY0JtBc5Vk2wCIpa0h71BGBTirN2jMhRhBTtPqt4nlOZcLKKV3700OghKJolwbY/9hNZapUqLsFzUVKor+UfIOEzyl12r1y0Mfu/k05O4hbc/krqVHzQQrCDI4+XoZcbUI0SnLsBQlS4rU1IBtgKFCSbPhQ/Cbbpk3+o9Y4XxFWy5eTYJyagBEr2UvziZwQDH8IJeencBaY0Rj3rjCcCC/nbBOpZ//fzG26rYEBzbPmSywrrXRPVcEbtaVnF49+Bl+41Hsy3OYxF7IhE41UFRQAtUayNZTIgG3Dyz8Sg8FKXJaFkb4SpRmf728tKx4K+asW7secRF5PNTclbDOYNNU49wrTUK6jWXwwUdtLtmpGW4z1lNegyp5tDqj3rq9h6WQHKoIK/PytqYt56n4XMbk/K5/coaKrCC0FV+aWIfLEioBPEYR9vsGtG5gJUYGuaXvJTC4TQ6SnzF6MIWgQyxK0E3MENtH92ZHj/Uv4rgbOsnMwAPpsCG4kDomLfEFLpurvT5YOzoKZ1xejU02eygLM+AwX/9dWcX3ikbR9SXps6r6cxnRyHunE0C0/NMTJMAFKxaxgFb7jYEMjRlTszaA6gYoNXVmUq
 LLBYa4mD
 L2VWGLkU7NN+991uDrduBIxA9V0O3jMRs+FbgpO1NmIhkQpRhxYeHlTjX3Ll4Lz76U/63yXTWqXiH2QzJY1glOpmtwIOgMjdneEyYvMPh3mUcN+rl4loftnXTwPF5fbtm18RfhjCi2lmbMdZtZAMdytg4znltD0/hVeQ5uCGDdjsF83q/ilkhOiUSu+FjpYwFCmOqRxX08wwqv49e6SHMljhpJSubSmn5a43rShvoSMRcRp++dyL1nuJxNTG3BwbgUI4WwaMKNYkB27RIBkD6qxa1nuLPQC6If2m+wy7e9uqu5+u34mGZREp4iELzcI/DDX0y9QGI8rZMgWD7Wq3kHj8aiP8hYsrpNS6JEb+N5YyvX47oVbMhmPz1X8gNUAHEw+GK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nicolas,

On Fri, Sep 25, 2026 at 09:29:29PM +0200, Nicolas Schier wrote:
> initramfs cpio tools had been subject of several recent discussions on
> linux-kbuild.  Let's get two minor steps forward by enabling a
> top-level target for building gen_init_cpio w/o the need of a valid
> kbuild configuration [1] and move the tools for generating the built-in
> initramfs from usr/ to scripts/ [2].
> 
> Link: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gmail.com # [1]
> Link: https://lore.kernel.org/all/aSdrCFkUQup3qb-q@derry.ads.avm.de/ # [2]
> ---
> Changes in v3:
>   * Update various remaining usr/gen_init* references treewide (Nathan)
>   * Link to v2: https://patch.msgid.link/20260720-move-gen_init_cpio-to-scripts-v2-0-26b7e15c7133@kernel.org
> 
> Changes in v2:
>   * Build gen_init_cpio only if CONFIG_BLK_DEV_INITRD (Thomas)
>   * Keep underscore top-level target name (scripts_gen_init_cpio)
>     (Thomas)
>   * Link to v1: https://patch.msgid.link/20260309-move-gen_init_cpio-to-scripts-v1-0-0c5059b1ec5b@kernel.org
> 
> ---
> Nicolas Schier (2):
>       kbuild: Mark usr_gen_init_cpio as no-dot-config-target
>       kbuild: Move gen_init_cpio and gen_initramfs.sh to scripts/
> 
>  .../early-userspace/early_userspace_support.rst          | 16 ++++++++--------
>  Documentation/filesystems/ramfs-rootfs-initramfs.rst     | 10 +++++-----
>  MAINTAINERS                                              |  1 +
>  Makefile                                                 |  9 +++++----
>  scripts/.gitignore                                       |  1 +
>  scripts/Makefile                                         |  3 +++
>  scripts/Makefile.package                                 |  2 +-
>  {usr => scripts}/gen_init_cpio.c                         |  0
>  {usr => scripts}/gen_initramfs.sh                        |  2 +-
>  scripts/remove-stale-files                               |  2 ++
>  scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py     |  2 +-
>  tools/testing/selftests/kho/vmtest.sh                    |  2 +-

There's also tools/testing/selftests/liveupdate/vmtest.sh I know of, didn't
check for other users in tools/testing

>  tools/testing/selftests/nolibc/Makefile.nolibc           |  2 +-
>  usr/.gitignore                                           |  4 +++-
>  usr/Kconfig                                              |  2 +-
>  usr/Makefile                                             |  4 +---
>  16 files changed, 35 insertions(+), 27 deletions(-)
> ---
> base-commit: 93f51579e7df248780214094418f205253383cc5
> change-id: 20260225-move-gen_init_cpio-to-scripts-9e89ef99e51a
> 
> Best regards,
> --  
> Nicolas
> 

-- 
Sincerely yours,
Mike.

