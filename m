Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D81109446A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 11:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963616B00A7; Sat, 21 Mar 2026 07:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914306B00A8; Sat, 21 Mar 2026 07:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829D46B00A9; Sat, 21 Mar 2026 07:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 732C36B00A7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 07:31:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADD5E8B7D0
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:31:51 +0000 (UTC)
X-FDA: 84569855622.15.342983D
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C3DD40002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:31:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UCvyConx;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774092710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=YYdBjs3g/NRwIzC77+RdwYjMCfy82DXerPQVEC+RqG4=;
	b=7ownnxYf3pub6N614/QYsnU1Go6ycab+7EVS0TgStJM17cR/gYWfDVNej0rVLZjlZBPCyy
	fRVAAo+UQXarQOV6r/5deFK7JEQlugzQDY+hV3o5z80FsmKMq/ETvXUcvC+ki11+iULS/m
	Jf+EAJnflz3i4SzCJVO+mDgw8svWEss=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UCvyConx;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774092710; a=rsa-sha256;
	cv=none;
	b=A9gx019keV0iVH8RcD0NGnsSWsckE7XS6Zak51DUKgNBiI9RTQ4PcRohThXDCKvzjH69p2
	Ll1jEUKILB7ZwHoeOcwtFQYE9mEJXSb+3wapgjPDzOHH9+Pmz59RE+D60ZGkufwnWy85A7
	xurPdQ0AxxnGvk3awdXvSeW5BywYgPA=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-824c9da9928so2841386b3a.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774092709; x=1774697509; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YYdBjs3g/NRwIzC77+RdwYjMCfy82DXerPQVEC+RqG4=;
        b=UCvyConxVK7xue4Z96U46VRglkLXNlcmEJ1JaMITgwPTRG4rcAp0sWeCdPGJQrGNCT
         L13xV/H3Fr747IlbHWiNViClDMz6GYOe5c0pgugj3h+3cnXEtIEl+JVxLp8D1lH0QrOm
         vq4aq3xVOzbgMj40j7SlC4bAFexpEju43DEdAbu6BO5dd75w1I+WVO4q3HWiIXLqG70T
         W/mQneKIcxRwnXA69uqJ5NDGy31U5a8YVTHrkmTUL++fUM9o/+d2nRYKjcampz+yd0ZB
         Zd+vjJBE49s9pHPKC7sktNtbSZF9y87nnmEQ5n80QXmxGMIZj/QfeIDZgSw/lCTq6sWm
         Pw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774092709; x=1774697509;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYdBjs3g/NRwIzC77+RdwYjMCfy82DXerPQVEC+RqG4=;
        b=ATHMhksYurfxPnvrDVGfOfPBiT+AlDB2POr7ZrD/1PmTM0Y22trS5BN2mcT/d+sDKE
         N9BA6SOjs/P+xA/DnrRFLNfhvbdjRhVnPFu6ZOZDit5qArUvHgDBVCkFQFolfDcfW/U7
         1TOSGIPuaMbMeXkUNtNUom9VY/Dcpn89Zh32b8XuAjinjCjG5f9/X6e9iJ9Y6ET/FyNf
         cMDVUbXZScYmrPIKDvsDZO6x4fIZd/T7xu5nkyB0K2E8xvCk2KYMpgAOEb7CI7/Krqti
         y/MC4S8PBeb5g0y85jxYaWHCfC4e3D+BuBAHgXEv5k8tYHvdwqKFoDAX3ipYqwlzCxQj
         Vx5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1dB9PjgVi7uG8z3cOkdtYNQrKA8LOH6l3/PBW4Xpkd+Dqx82gGCLUnc1G5wRQbL5gSZTN6kZ81w==@kvack.org
X-Gm-Message-State: AOJu0YwSrWeWayPo5ncJGzUpQcZB9YUx4q8mKVulMarhEQ/arT4EhE7h
	YpiMuPzqcQkWhVnniYSc3e8YxXeq4WEyStMxOWpA4XwvaIeCudoF0V1h
X-Gm-Gg: ATEYQzy7n+ge3nG0zWgWt8nszyU2arXUVgTLiJZad4RJz6aGQ/YrFVjpicxdKAhZmmN
	ZfhDlUPxm60zlTk6UVsEHCammjS1lEmZ7eMQEXT3qWAKZiJCzM8Ayebq3LE5ZteRDFou9mq/yHQ
	zdqFz7P2pXNDEAGW/UN40Y6YfDzTVFfVSVjYvNiWfc7vzEPBldvdeb6VnDFwYBPbn0HkRCpqyB6
	PYe3Sl98nmCdOyz3k5rlF1tQ4l0L/+sM3FCYmJKd2jOkThrLseSMe+ZSZeoMu3y9LSZ4ikTxULL
	3MarzvUvk8i22LNASGpBMHO7VX5T9tuoM6LydJKbXeXtKRlP7u7iaEutfVvU18br6PZy4adx/bj
	uc1xpQlomDl0oWD34ce+4+Z+5FsmXtMjricC3sQEOmDmdtSS/3H2pB9z4f2+1XYjIYWVq5ZfzSe
	CH+SkKCErJPRyTJzEAEVRERw==
X-Received: by 2002:aa7:9e8b:0:b0:82c:21af:a7bf with SMTP id d2e1a72fcca58-82c21afa908mr2465482b3a.13.1774092708761;
        Sat, 21 Mar 2026 04:31:48 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b04220d9asm4159044b3a.60.2026.03.21.04.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 04:31:48 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] change young flag check functions to return bool
In-Reply-To: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
Date: Sat, 21 Mar 2026 11:01:56 +0530
Message-ID: <bjghychf.ritesh.list@gmail.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
X-Stat-Signature: 1jysyafugrssq8wa4zebatj1yy4m5688
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C3DD40002
X-HE-Tag: 1774092709-813068
X-HE-Meta: U2FsdGVkX18fvHZpwrXXPC03DcVQ5vXoYXz48CINb3kr53QjqR1NHh3EaAOlXIfvlKaCJbQYX3ZU4M6mpQC22Vwqt/+y9aM/zMPG0V1MZ9kQZ9xtoGcSn6B2wb4Fd7wQUXmHcIs59LloGGo44wHbrg8M2Gp0zyn4bEX1M65uiKi4/J/3JZztki+QB3wdBnH4BxKHGkzFKaK6VB3sSlq/W4aOpyr6j7HeVNKPcd819733E5NWLixGpuJyhrlM0XLbIy5/zzsZQi7I8nCSN3V3Sjjy79X2jRSYuAbBL5BSthh1G0A+77TFX45QKyrIt4KKgwJHqLq8wP9g0rXLbXigRjOPqsDJhtb+smRrmVxVSfq9ILpimHOULfwIaDECmZiQ1HG7wD/M1o51gfbU2GyGpXdSDClMKvBk5t16gzs8BiTt8qJmZVACCAyCaf//h8pYL60QgwHUtntRSOBcmZj14yzwUUamS2Ft4MANLQ2Rp0KOyfG7mOqqjP63bA6UiEMaBAWQ2wkZ2nj54MCHamlWuuuTg5M6OJ4RCsCKKXGbSzN8ntk2Oys1K6BwHXoUysVqyvuejJ5mxsmgSKjRzQeJRWXG555E4rdDKLqLRs5W6pyrjdhHg0pwYimnF3min4VG2lA2dUNMLfSa0UCoh/HZI0KLV83K2dsrJeoGAFjGRbvqVKLfpYe0ciymRW95fjENy4XdMFerPO9U/xrnt8W4l/ar07sgjTdbsnp8phWJ10XGJCO8P24cZDNNcYXjEL5TWc7SfwrzZaJmxGHfFZA+TsGxmiWGNmmYgOtUYOtIt+9/SOjwt41Qq/EnWRCCcYg08dUdQUfaAJn+bHDxmAT1mRbDwFiQBqsWraphaR8WKbQNiKWiu2/A8f/43hg3oi2SRLUy5b8cJ8K8DwHJwl+X2Z5P6dp6wUQ+Db9bFhAlmcZgnk7Udr5NsFqjXMbi4gXBhyLfkA/5m8selhIS+Yx
 SELyTHML
 msQTXKZGxOUEc/Uf9+P0TdFO/wptK6xNsrRwO481WyLMaSrUYrZY+gsiscX+VMaFY1I+/d6zBRNof0ANtUzsjbtLds0ctyoQUZi+5623oCrm7e2gHWHa+KFrZIa4+v0umkT6EVWuAaDnzVq6xuuEPX1YvjyJxJeOaNYfoiOzTvVuAUdqnkQig9R7oYoDE+z9HftBtoQwTu+HMXzaTTS+Emxabf254V/4yFBqixer7RhOPL/dUX1wiDu3VH+MGAMI0LDe6vrwzWbDOkA9wN6o7KsIzOCpGE2KPzQHsW3IPGexI9IG/uyz3CPHKHHtA27KXIUFcrUXsWG4aS8vyfNk7A6N3vBm6uodovNl06R3TkS4jbP+I8ELYWpYxqddizRvSQES244KBZrXk+X4/Ftaoqtt5K9G1KwzHgW3ZDzwP0fcBKIBg19rIGeAnSsRbYvDmRPmHf0SfAdLemBn+ZIc5rkRvYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baolin Wang <baolin.wang@linux.alibaba.com> writes:

> This is a cleanup patchset to change all young flag check functions to
> return bool, as discussed with David in the previous thread[1]. Since
> callers only care about whether the young flag was set, returning bool
> makes the intention clearer. No functional changes intended.
>
> Ran mm selftests on Arm64 and x86 machines, and no issues were found.
>
> Note that I only CC'd the arch mailing lists to avoid disturbing too
> many people.
>
> [1] https://lore.kernel.org/all/d172d6bf-c60c-4cf5-9da9-f30de38cdfed@kernel.org/
>
> Baolin Wang (6):
>   mm: change to return bool for ptep_test_and_clear_young()
>   mm: change to return bool for
>     ptep_clear_flush_young()/clear_flush_young_ptes()
>   mm: change to return bool for pmdp_test_and_clear_young()
>   mm: change to return bool for pmdp_clear_flush_young()
>   mm: change to return bool for pudp_test_and_clear_young()
>   mm: change to return bool for the MMU notifier's young flag check
>
>  arch/arm64/include/asm/pgtable.h             | 29 ++++----
>  arch/arm64/mm/contpte.c                      |  8 +--
>  arch/microblaze/include/asm/pgtable.h        |  2 +-
>  arch/parisc/include/asm/pgtable.h            |  8 +--
>  arch/parisc/kernel/cache.c                   |  8 +--
>  arch/powerpc/include/asm/book3s/32/pgtable.h |  4 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 26 +++----
>  arch/powerpc/include/asm/nohash/64/pgtable.h |  2 +-
>  arch/powerpc/include/asm/nohash/pgtable.h    |  4 +-
>  arch/powerpc/mm/book3s64/pgtable.c           |  8 +--

I did compile and boot test on powerpc with various configs and overall
it looks good.

-ritesh

