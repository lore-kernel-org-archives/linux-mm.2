Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57E6CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42ED68E015E; Tue, 12 Aug 2025 11:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391BE8E00B0; Tue, 12 Aug 2025 11:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280558E015E; Tue, 12 Aug 2025 11:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 121388E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:55:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4744B8F84
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:55:25 +0000 (UTC)
X-FDA: 83768555010.13.0DA0FF8
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id E2BAA160015
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:55:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jOFPUk0l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755014124; a=rsa-sha256;
	cv=none;
	b=oW6Yinku3/zp9L9Fxq3o1d0/B3fgGxPDBHoWBm699Hg2Ton+LlDdzt4cT+sJ0AsWIJVe0t
	DlHUba08WgWOYm2tqEiNjyEaVv6a3niRTe47wNX/AVfSwOFx7uPsNgwKNf8iFykiiFqa48
	ukTI4x0Al3vKRTilPJ0RsG1/igWL2f8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jOFPUk0l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755014123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mcv2bxyNpRc50Ynpw4pPqHAkM7Jzrp/2IvvGq7EcEI=;
	b=W/RmLtv5QkHj8YK4Vh4YK8CYWrKUJQw42nAoSomn3TNE8cHR6pEHjP0267v5DX2kdoev97
	gych8MNqEIGy2oPwj1Kg7tVXKzdqAH9v3xtwj2mFIFZLpMgtainCqBrSSABZaOTuRBYfpI
	Ql32ChnRY+4zcDNQJuTHFT07ct5GyS4=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b42254ea4d5so3727697a12.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755014123; x=1755618923; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mcv2bxyNpRc50Ynpw4pPqHAkM7Jzrp/2IvvGq7EcEI=;
        b=jOFPUk0lmod/phYwSdKVAwBGKZ7wuAUaYn0VWX6iOhaG5g69PAnM3aCt2RaaaMG2fV
         8DuS04tclz5eYVOomuyp35lGRdPoqOxFbC2/1Eab2m6fq71UjCQgGovVmlrFzGbNLAsx
         VJaNJGwRbz+pOuZ7nc3lhdLn8paxhUCvjv4hZ+IfD1TnybiH9Ov8Pd4DEPI7zAR6YJEO
         x365Uv8Qm4r0mZlxbmcALXcfQ4o8Tmfnb/zeZ094TCZX+EsYx9FktqXBlwcSu/gFQlop
         KpBFoYM4qR4cmKyubabl0ho7B1HGcB3HYCLSgDSAhSjRDMEhWzzRoAYEHlpDMAUw8yLQ
         uOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755014123; x=1755618923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mcv2bxyNpRc50Ynpw4pPqHAkM7Jzrp/2IvvGq7EcEI=;
        b=RuFm1K64IpTNVw0oCed5tH+EdP7KS1eGWuApNOFEBSg60l9AkidvEfZO23vp7QXXHJ
         UMwCc9npu6gDbHpiatbzlwPpNwK7XtQf6ejU3VwcDHltCPCXUAsVl1Uap++9Uq4gYC0U
         KnMSbfc1T/8wvxpt4kTBMd1kTjBK13VU4T/hTHbx/OYode+6XIs1ce3rSquva5OnKuNn
         BGGE4iIcu+eXXqjCNX1MqVpJ2eX2w/DuVxbcaoC9jZPF1awXvZFISav66at5f9zb+o/i
         Auds2z9fGq0BE4EWh1jCwm5TaeF43x/H/nwF6RZ7L1JJKrhtGT9yQ+8myvcfwOtK7pBS
         F+JA==
X-Forwarded-Encrypted: i=1; AJvYcCXED2Wr+kgdA5pAwlhrxZSkh6B70o/oTkj4WwW3ozkcnSUrbPnaOc09JmqG5anhG+NxezUl6C/dGA==@kvack.org
X-Gm-Message-State: AOJu0Yw6QqkPIvanc4IxfeK1Xd8ownrQmoE0X5gjlnnKQ7s8XOkH61hM
	DZ9Kl/TrbKldduzghv/+zKIqhJ0MWh4DkcPmW64n7XSCdb92CjFAld8Dc2i4LyG+r+D46rrw/32
	l74EHj2ilmPRCVu7mz36hhb5HKaQKQ6REV1TnaYAG
X-Gm-Gg: ASbGncvJCn3gZsihPcgU+Xoko8O6frFx2LyjdgYZEynVX80VQCdSQviPpJuhIqBfp0M
	yedsmaLLM7wStaBe/heTqjHZXfKcogB9AtMzZfQgOISuIglTFdsMQavz0bThu/1wUT8Bxx4zOCw
	Ym5Meucg4ulvoJ+zBsRK+aNbUjbqyW8QGbAFXIqVWsrJMBGJ5rGtbwhffPLkmSWgU1TLf82nNHU
	vHx3kI=
X-Google-Smtp-Source: AGHT+IFChq5GEq9GGfaAl4dOo1Sl+YOfAmncpR386ybj+7kBczFF1Z2UKtKOTxU5KLS0Amm9EkxnQU0RhLAZT1wXcRA=
X-Received: by 2002:a17:903:1968:b0:240:11cd:8502 with SMTP id
 d9443c01a7336-2430c008265mr2760005ad.13.1755014122559; Tue, 12 Aug 2025
 08:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250811173116.2829786-13-kuniyu@google.com> <202508122213.H31XXZsm-lkp@intel.com>
In-Reply-To: <202508122213.H31XXZsm-lkp@intel.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 12 Aug 2025 08:55:11 -0700
X-Gm-Features: Ac12FXze_DG1t-NtmVQ64sQY1bC4hkt6geufHULb5hsjS94rK_uLgU0R6YoMjYE
Message-ID: <CAAVpQUDguV+qG9Aer=o2HS74OP2EdsWHbFx3J654hU3sBnHtRQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
To: kernel test robot <lkp@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, 
	oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>, Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oy87j7gzpyarrquxhkkq1468xw1d1f8q
X-Rspam-User: 
X-Rspamd-Queue-Id: E2BAA160015
X-Rspamd-Server: rspam02
X-HE-Tag: 1755014123-310264
X-HE-Meta: U2FsdGVkX1/VrMQlldFbmjbbZzgXFZ4NR7nA9uNMxIDq6BSbsubIwjmhhZNK4Pe5v727TW5plp4zsc9NQmqjG4qSzxQdadqEhJWB2MN6ELildr1irMzdb7owXXOxFczoywJ004P50KbhKqOvyTaue8BLZXYeVAYgrliAZZ+y+gZtBoDkIEYv55kztpOVrCKBs2SIhico1GYyXsj+6Qvcd2JEo8NAfynLTDq9VpOknHJlDJmnbepGw0j8tKi4gqUHwG5EtnahPjTFUXM+PqZpY8oNo6YvDaLkAlLamqgiRV1KnjEkmT4t/kEeLSV28QOeyeungvJkgqwAPccUOW/vzOqmRQQ55M03PpIwVkcLGzijmvk1/7ykrXksobXqMorYs9P69QIHixFufqRF96KJEbne7BLSJetxW1tJezKmUB0jmLZnpbv4xJdoBOUxk8kDacWT9oVgJYKb5Xi6FOc+AYBo0n96CuhAqtK1KYok4vVVOlnyJgt0+8ynUtzoYmbphTN69xAz8W26e8woZNWzJ/Sr6g97q+NCHh5JOrYYQ7ungnJOph8seCeTehZeG3JjEzUoePz+UxOWd7d+QqdFWUCv3Te5QheLooc67tgUtUeeKUGWswChT2gfIFzezgmtKBukyru9Ja1N9CMU15Z2ly4juZSKWE/BaPqTCfBKDq63q5lKWtvAffdd9A4bMlzZiPReIaSulwivDbKnkMvm/d997j27pwA2gIWemYmzQoU0uKH0jv17NF6951VdiukkkLXgYz7g8SKJny6M5ISR0zhffXoJoVOQGm0VZK5pJBk+Pecs5+4BYC9n6d+c7N/I1ZO/P9xyS3SS0UaPA2M6TI4YI5Po3Exs3cPXNaV6OAflInYYY9dzyGtOZGxS2d4ZUuc+oNsekQ7PNBkRt7lzMf6bnQgw0TcS1XXYgNLU+u1HitWMyjqnD8ISPkn8sA/rAUIlY8JaSpoO27G/UIE
 nj3zv4lO
 Wuhvnvo+HR0Yftbr8+R2WFPXU8bpIlXJyXZrgeR6qVRNRA6voxRdre2eaX78wQiZ/In6QgbA5pHRA6zumUG0jdE+ku1bqKcBoqdAPTnEK2hZb7fHE15cGsbBKjpoPituro90U//2hKOhrfM9eBe/89VBJWxprotyCZXVusOZ59Kcc/+mUuMjTNnTwpWlP5D3O5YZfbdFHdLP4XE/oAebR2Ve8PsLOGWd1X6XnMq5Xk+mh2j3qFKwvQMlRZHxbqCgOOqRTwGDLhHd7z5xyUje5JQS1gEqJU+Rtrr8MeAfRhKnjQCtlcOY+gxXtA/STvNA6A2kxCcOS/4OZ2r3qPv2IJ6rKdLscaPmraYYM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 8:09=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Kuniyuki,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on net-next/main]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Kuniyuki-Iwashima/=
mptcp-Fix-up-subflow-s-memcg-when-CONFIG_SOCK_CGROUP_DATA-n/20250812-013522
> base:   net-next/main
> patch link:    https://lore.kernel.org/r/20250811173116.2829786-13-kuniyu=
%40google.com
> patch subject: [PATCH v2 net-next 12/12] net-memcg: Decouple controlled m=
emcg from global protocol memory accounting.
> config: csky-randconfig-002-20250812 (https://download.01.org/0day-ci/arc=
hive/20250812/202508122213.H31XXZsm-lkp@intel.com/config)
> compiler: csky-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20250812/202508122213.H31XXZsm-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508122213.H31XXZsm-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/cleanup.h:5,
>                     from include/linux/irqflags.h:17,
>                     from include/asm-generic/cmpxchg.h:15,
>                     from arch/csky/include/asm/cmpxchg.h:162,
>                     from include/asm-generic/atomic.h:12,
>                     from arch/csky/include/asm/atomic.h:199,
>                     from include/linux/atomic.h:7,
>                     from include/crypto/aead.h:11,
>                     from net/tls/tls_device.c:32:
>    net/tls/tls_device.c: In function 'tls_do_allocation':
> >> net/tls/tls_device.c:374:8: error: implicit declaration of function 's=
k_should_enter_memory_pressure'; did you mean 'tcp_enter_memory_pressure'? =
[-Werror=3Dimplicit-function-declaration]
>      374 |    if (sk_should_enter_memory_pressure(sk))
>          |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Oops, forgot to enable kTLS and allmodconfig.
Will add #include <net/proto_memory.h> there in v3.

