Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F38DA106F2F3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C126B0005; Thu, 26 Mar 2026 04:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D876B0088; Thu, 26 Mar 2026 04:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042756B0089; Thu, 26 Mar 2026 04:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E09586B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:17:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 817C51A0A6C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:17:45 +0000 (UTC)
X-FDA: 84587510490.04.7ED6E8A
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9B76840002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:17:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mZpGm7uf;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mZpGm7uf;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774513063; a=rsa-sha256;
	cv=none;
	b=iMfxiyjjxmMlxDqrdGP6o+eDZXIgA0CoQ7197D05sNXIMuDH2Gh/6SSqbADp80ay8zbT0D
	Y3P/RRQ+Ogr0PWa8rEjO5THfuNCC9sTB80VaqfzBepwMBp79F2hLn9uJ7JjoiFssohwD/L
	W5xQntTC0muVIPJnFKFqwAwLsm5Aw/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774513063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cjXlOnP+xsK5fVXd4CCAeINLx8Rs+T12Wp3tIQpO1U=;
	b=PrKXo+fDgYtOmDBOkacFz1WUgrixiqb7Ir8ch7UBVXaudZ40bC27mE8JOwVhFpVkknUh0q
	JvPcpAdN4PCK+bjP0SCfZQDwU60Duo6c7Isf8mxURYPufiMBSWzjO4Gz/X8skSfmVPCXp9
	xQ/4XLzRk4JjcgSGKouyl9ps8NEaucE=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774513061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+cjXlOnP+xsK5fVXd4CCAeINLx8Rs+T12Wp3tIQpO1U=;
	b=mZpGm7ufgnlHUJfxVJ8pxUf6piil/vXgiBaxibhYcGgKSx8pRzxwv4ceQtAsYCsHYWyzYQ
	+vJd6EV8CXWdLfmN24ZFBblr6oUyse3RDML3abxEnm1D/YxXgri8bQ57Uy5DyfvNfS0+c8
	zTFrkDB6myL75CMMptHGPnu6ncrQLrM=
Date: Thu, 26 Mar 2026 08:17:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "teawater" <hui.zhu@linux.dev>
Message-ID: <2755fdba5839e9f5ea654e2fe7a7853f990f194c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH bpf-next v3 06/17] mm: define mem_cgroup_get_from_ino() 
 outside of CONFIG_SHRINKER_DEBUG
To: "Roman Gushchin" <roman.gushchin@linux.dev>, bpf@vger.kernel.org
Cc: "Michal Hocko" <mhocko@suse.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Matt Bobrowski" <mattbobrowski@google.com>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "JP Kobryn" <inwardvessel@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Suren Baghdasaryan"
 <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew 
 Morton" <akpm@linux-foundation.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-7-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-7-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9B76840002
X-Stat-Signature: 5khhddtb6wrnbuhh1fc7bmzq1wcdjyxb
X-Rspam-User: 
X-HE-Tag: 1774513063-138359
X-HE-Meta: U2FsdGVkX1+ayoJVXhTIW67T6W9p8syGzYulWkYijDR5G8GhvVBUx7ZzXAkrxfis/WoH/n0XLfZgf5IHTobOO3R28bQDMlBRAmCsMSTgQigtzxrBfXBtORmGYkI8extqZqg9axpgZAyVrw9YoevgEpg6KZFZ+T/ICU55zo8Iv/V60st7zeAQLMYaYN/owC9PT7htDqv0V695LZeo5+7ZDPXCvSg5JM7ZrB+VE+eEGOaduWYDyEEhahZsxtw0mi4Rve9mXu8KokCQ5hjI1SAmYARphIv+EXutr39hVqkBk2n6H+ljmBQLEn8xmN13YL5ljX1Az6uIo6DEdMu3LkRR1fWRoL1pbp4kBra/8Et30OVDGu2wIhwvq1vAEV+IWEmRbCo8VKKJix8ofJkIWWxwXxfKftyLIAqB2S8LpIagXNLTgfHxbBde9yvKzGQe17jrdOJ90Ln89iUrOujPF1zEJoTMDN4cXbgpw2pO8VgsWFwHKcmPm3CDQ9JLDeohHDGNbv1cbci1z2mO2+/D8P/w8sc4kL9QIHvA8P0dDah7jEZpABlMVDPQRL2J2mGwqoVgiLmUL5bG26Td6v4SM1/+4HbE+AjsVj5K2OuRA2kyvR3KGSyV5X7ZsCO+WVscqh56fmDQaOjaHzyybrQDrmLX40YPhsTuy9JHACTlrz0s1KNOPm4cfuz1QA6WnsyHoCH88wBeTmllkPlSDn+5efiUdsvYrl1cFNHlEuksFzRaGdrWa181fs9Qzqwd/rfRGv2gNj+A5LM7qyqQY4UrnE/PWPlHooVo7RHjjOMZg1vE9EQ4grNVb/elJNZxoVBeqAWV1N6K+OBuLBlMabV8FMpLEVJP0JLc3FmoMtdv5Zm5F0Plq08bsWeL7t0mS/5L2G3RBIFR+xfA0k1x+YUiisi82J1tAJYYV6IRJRD9mBJeboTclba1niAtzXJmLB738mV8y2oZcc6A9KA8r47vZeG
 5a21PPO+
 TzpcXcJ/XzNeRF6rWCpRWLjnGLiPRQdEINYVXJr3Z/kKY9savZUr7tIOUsBXEmGwP4I1JWY3GaBfT+wmBGlVf7tp+eDCFheob/0DvCObaDV0fHCGm8xtViUPSUtec+CcQoYZbUUsQtknsNzIalR18As4PF36WYxZUygAdru8Pwj6qSxdsu4vjxTaSBfHYhwafdd0XwnPNX21ANwKrNsD6MnkrECbitMAb2U0un6nPeFCS0ra2xHqyxpLr+mTPCdvym7uhKN9Y/0UbtVvNx5l+3iZZ2sK0Xm/upiPmHThDhuUM6b3AUUeTJwH86jrs+L1ssblf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation=
,
> but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.
>=20
>=20Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

After dropping this commit, I applied the remaining patches to the
current bpf-next and ran the selftests.
Everything passed, though the following warning was observed during
the build:
make -j 30 -C tools/testing/selftests/bpf
...
  GEN     /home/teawater/kernel/linux-ebpf/tools/testing/selftests/bpf/to=
ols/build/libbpf/libbpf.pc
Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs fr=
om latest version at 'include/uapi/linux/bpf.h'
  CC      /home/teawater/kernel/linux-ebpf/tools/testing/selftests/bpf/to=
ols/build/libbpf/sharedobjs/libbpf.o

Best,
Hui

> ---
>  include/linux/memcontrol.h | 4 ++--
>  mm/memcontrol.c | 2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
>=20
>=20diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 229ac9835adb..f3b8c71870d8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -833,9 +833,9 @@ static inline unsigned long mem_cgroup_ino(struct m=
em_cgroup *memcg)
>  {
>  return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
>=20=20}

