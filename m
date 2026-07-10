Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034E7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BC66B00A0; Fri, 10 Jul 2026 16:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BFB6B00A5; Fri, 10 Jul 2026 16:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16636B00B4; Fri, 10 Jul 2026 16:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB1FB6B00A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:26:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F30AC3B41
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:50 +0000 (UTC)
X-FDA: 84974000580.03.41FE7FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 878D7160006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJhYClFf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BJkMOjdL3tYxtw1Cjs8vTxoBiLW1eSUk6BqH+zEY+k=;
	b=sKIi6R4Mt7wp+pmqhxYZgIiCyGGpv9TYdEQ+nGNXdbzEIGU5uZ9Hwa7n9CBafWXSjLI5cB
	hXGYKnkZ/BSPNdCGZmUA1nDnHw9XHM0dJ5R/Onm1QzcmJh7p9SorIiElcslsUfs0mdl6aK
	XPIaniFUo5vgXlyiW2cQybaLUdAIyYA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJhYClFf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715208;
	b=XT6XqXeKN03hELP17YKwQqdXlmaQrPplnhijXZMcnYtOo93TJdGnb65Syrq0hk/bQ6vKzN
	jGGw2+8msExMcMdSh8YiP37JG3VVYgAdq541w8LGnLifTlX01R48BV8riIvXMaM3e3izlF
	8/uvhbCbqPUCrgVOv48DS24z+8dGd2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DBB4601D9;
	Fri, 10 Jul 2026 20:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF241F000E9;
	Fri, 10 Jul 2026 20:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715207;
	bh=8BJkMOjdL3tYxtw1Cjs8vTxoBiLW1eSUk6BqH+zEY+k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KJhYClFfxeYjHFNUJ47V90SMGBiO8cXGZT/ciRY6YGuiovsxmCZXbNG8ahV8lExKU
	 tQcg5juhIffLIZR//R2LnhwNbF2SWsLkmhBmD+P3wCCkI8has8aK417Z9gX5cPgN5N
	 O+WrgR++oi31JXVQTxnmR3S7RoF9o//OqplK+v/9t3m3KtccaKhsOrAOzBemo3Zgek
	 UChBNvQ+b/sZpnFQ0j4P6s+A3MZgRix818w+Bj62VOR3GS2+I0T/V0+ecp5+FlSWF1
	 5JFGPlM8nir+1FX9Y4JpdoDcAbLwkE2MWd4CLEAoi5F5BhiWr7r0SvrxT+zQz/LeXk
	 sNZOexe92wEtg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:05 +0100
Subject: [PATCH v2 24/33] mm/vma: move __install_special_mapping() to vma.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-24-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3781; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RcQMOr7okmwmrMHVS+mP4E/LNV7GZ1eHmNfHonDKIh4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg23TKi///r6kSOvV5xDfzfGOb6oPXXY1TXU/3FG9L
 CtbrPlZRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaiHM/wT5s1/65G5dPAPVxJ
 G8UOCEgpfvhQp5s3ie3DtArRTalMMgz/i5dGzF+52+hHxDG+v5+01R6VF9vrGkwUN0h/sfeoZfN
 PLgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 878D7160006
X-Stat-Signature: fg7r5pe3abnh7z813zdquofgzyqqqp1o
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783715208-313460
X-HE-Meta: U2FsdGVkX1+yM24VVgDuWa2q5h1Dzs064mmL/E/ooMaWpe2r5yBD6yrrL94A1oXCTlqbce7/uw5ZKW3i+BRePBgX6Cs9tzgQbKe1w2tPTE/1BG7mAApL0979frWWk/G4cqL6/LtaLv4fPWgMYuTuk9CluvqtzOSPjHqLMiCvEdQHVPjPpic+DXjqVMaPyge5Zg64TxfncNlheronaV3DVI7YkP8TiDUXUMNuRaXPbOMGLo59Ac9V4Hn9xNL7nMHgupjEM7IiQP+/pwgvB6o112GEct3taiDTK6Gfle/iP3TI2NuKxHKSv7SFIkxRfRpVdxLL0ixvIPFqEQibIHFZru6rykRRZeQwkVwmB704tcPGvcryHWnHCo9rxCS+VP/hUj63GGVQDHoJz6MJhtqZ9e++Qk2+KHZniOov95XW1O6p8hmLM157cEX8ufaAoC5/yOoG8QCn/ER6Omz6m7cWmVMNDRCutZmngELwOLhRqcSmF5BiyCzoYZRWvyRHKE1KZNjbXd+rrnd9+pUKkVfvn5idribx/srhZTSCtQ40Rri2fUjmi+TzGNAOMHWSRnCDRQ2346rx2CbKJ9MuUdwuFpmEJzvbEmCmgVPfpumwXF/0IubY1r2px2NcTVsFgGi+oL+MN1Fm1C9KbXmJTHAhWm7wPUFOVVAW6bixMLwa2ETfHrxe4TGcrLO1QmERRFDewZqqygWKRrQMGl6B68z8R3dUqzaMJYM6OFnxSTTk1gsvUKCT24rykoFVEk44kmQQx7SJl4E2ft6oOu0sIZ4uf28d8cXIdm+3rVLdyR1OxKkKBvDDLfC2osmEuLFh9tD47ZTozF3/yXke/tvp1PwNT61bCS+dxIKPsgp9C19UfzkGP14q/gMKi52RAxErWbR7XJxdrs4Hg6M4iVBqYWq9h9qCtMaZKI3M8AxvMggNgqKXBQR4m//10nMKpKcM/m6TJ6luDI10OF9sZjHEmQL
 5rWaZeV2
 9lDL+iQH7RixJ+Itnyc83y1mCowvsV8BZ1f0GCzvBDkWUtP0FamJQkDU9vjRiADWuVt06yfIgE/lbtMbEr3tuH+vN8VojZpcpSVtLRtvYIZSheyAtq7E9uivdlD/Qwmc7uqNIcWiUoEiZRih+1mqYWzKOcCWXNm9ZUHmy7z0tH1UKjKfSOemDql4IcSfAqSfuEyyR+Q+66jZRF5xc8jcbx1rlRG6h6fJUSw43AuHn5rkW2umWwWg+ljIp86CQoCTZc7Cpe4JvdEAAm9qM8WMkFU3EfBrd2+PUVAojiqPi1/YMi6S36JAel1Z4qGxTIoHOfq7mdgZvZ5TmefT6O0XO8EPg5bgiyYzGS/8JI9512Q+FohqXRI60m5KQzMIUC5w7nVZfjR0dP+cc9gYdQPq4Sfu/Acv0X6jBJHc/5ErJzxUs77yp+hhUHqVujgIWtWZYbe5dUaVprVOrmPgfW05M8HO/5uFYjGGvaY21Z29F6bGVjn+bNWWhNLK+chfS7rXR9aIZ9OAeG1WBa9Gdkt2diGdocY71/VNXUB9ZQPPh/YaLcbKsweZigvsPjn4Yyi0dVW9Qc0WLi0UQYcvJWZK3HGDQ9b+YTPDW99CPahCOzvTAdVDxm2wh7oSClF5MEuVCW6gtfg6ZDTaT/XKAi3OJkscChQJUbg3W4Bu5v7ZwoqYwnXmiDIEkH6hEM3JKGeJwAwPXceHtugy4cwI8Yj647wFHMmXklHk8x53nMIfxbenjj6RrY95vGzo4M2XCfy8omeoble6/xL34RLczYXUY3iY8q+jYNYEZlHEawQIjCEsg4bFk7XAB4m6o2DpYepN7iIsqN1BApprH8/yyVc3OkkpoEvJW6Mv9kmsBMDQH4ZBTiSe3JENnqJE4+ZR0hHqcLceQvSlXaqms91eSL6/PD1ELpurd2jlZ8S01OeSoj7JPphHwTaavMcJ88CWBiBAF4m6lSq/zB+2Akx3fefHEEh3fQVRt
 SeMHg2Xg
 8NsdQs6yG43x2F2CItfRPtkjYUHBX8B77VSSMhssSJ9BrwO+rmg4DigjRNgIq/c7Y2OHUkEcZLWgdyJ18HUXmotIklHmh1M4ow8FOmbjgRKyOb6bIpWfW1AGgceZOKwkBgMych/1bD0JlSSqdZWHDVfvwPQBY120IXK4yZYcpZBtWcydxMVO0r3BvD5oQSoNMqZFzu1myInvCsrJeo++ZT8UoU9HWtfLtsEmvT2jnTz10+M96WyBcq2oyEnGs4EdtRtpVIUr1YzTNLH3H01yuj0sBCByLm4VgmHBE4S9kM6aV1Slm6+k0eTB0JVTYgXkhYavUqwHGCDu5i0zeerCp/xF9cnNoKn9A8zkAoFPSlX3ywvdNxzr/3r5WhzlwqqjMlJvHJDF7uRN87N2zuD7IBeg5/WQzUGXnRP/h96Tu+HmjfgoO1iQHfWFTTMDwmhvJzAKXRHuLrDsYssi3dZ8MZW9OZKjtHHnOdxkZ4lGojR4h7Yk/8rThsQJjv7SyXGkX1Rk5AYY5VUP93ZNbD6FNMIK5/Y9UBmW2FsXE7/1LjqRti8QPeL4TBIPf8R6nEnlfUTpsjgpuuUjMCcfawaoic1Z3rX4yRkfD517tH34uJb3r9FNP0WUo+ymeMeXiBpg6GARKxVXXzJR7Jtlq84rIsg/th/iyOuW3yrUp1Uq/jLSzEMkveVfxgceMKnqg7Olr3RN/uAohLjTKd7ssiVjEkbiXkE0K/2i3wtSvQihL4022oj1jL/dYaO98MH8tm/qyGA6PRhJ/mBq2TqrcPqN1tYTIz17S2i4pPOnHp5vfXvo7OY01Z9XrraiC9CFYDfF7E4aZfAkDCbSkoRIp/4m0x+TQDu3mRT0YUuzic1RC/5KyxUV5Ua2YjhiAqXQ9PiRpplDCoEkebkP5wDeZMmwP4XcqcTer5bnmQ+X9D0iSpfJa2xO4IQFP5SD4gZDlU229Sqx16IMN1G0slsIUON8jPYs07PPm
 rtMeoSsM
 v6duYiptoxOTG0LL+7wJ3LjiOivThMiItwzVYwFUUxQRX81dBepnaByzVG2+P4BnCdspvHdr9awFdS/FqVpqWSHiH+QXqRaN51khJGhUJRy3CfoZy0DEozQM8Vkxlf6WAGR1Pvb1tjZ2DzB4M+d22YT1yoUjpt64LwH/x5bIAGf2duJcDNw0cXZSgLqQCTYKmg5APsVC64NoxIlEM2BZEzK4azqY7IltWiVAyQbmjsIZcRAyUF5L6BXMprJCbPgKwJFxKK9T2dAG7IowWu2hBnije32dtL97Hyg/NliBHMmE0xWNo2pW8SfTblc+xO1szVCljMRp+jBw09KsDoJfq6o8MxNoDukufu1Qs/O1lwOjsVBDArUI2CLCNadNIA0gRlrpjXqGzrrPLQy9CtugxgREoAh0aLIqvXeeIJgdAXpwwwvy1wRcFxQbRFqVKEDJrs05eBtm8SkpgpHgVDYOqMkg2tTkotVxqwBZ/j+bzVUiIUy5auWxB4eKk9c1DDMA65qvbAkFJDm3ayj+iE2/bfFGOjuLXeYi4nkBnQ5dAPlJBD/Nlb0UAMjllL1fRvshhDLcQhZ8TgqKRZBlF21CH4eZM+f446dAS3lSj3ZowVtja2OjFm3OvbQ+jrraVe4aWZMnLu1zrbKVQvx4SnOfk/kpjzBtt2k9EBXlt6+DtvpJlGBW5hCHW3QP1Q44ZsAmBI2rKlKLCDdCztnJb2v7BjBq90cdsrzmQrY14nN1ZHAe8WHbvOziTRlN63pwmTzKRX+GIpkKAp7Sq5nMvLBmDszFWGJBFOwxoaqy5jgOapbZNCqxccTr87ZBp3vvyw3TVktqtO+eA7bLToljJRcqPgEYU2Z0y2CH89rcsTT4kG99l3e6edgkzYv5CAAURfgS4tgfba9fAaE3CBO7UV7sU3+ReOSIKRhsRQawbltfhbK1Q845xZdDxtJk7R2kA521A+biCWl78TmZj8gdsXTGd9GQgkjRg
 U+VLMlw6
 r3JmTiLtiPsgg7+VZx4nq4uPKbtOOk/MDtMxA/XPV1Zn3pPoKnFpc/TZK7TS+4iGm9sqV4V8OajYT2odM2rt+aB2o08kwYIBsHClmmmVYyJJnI7sQvk8YiQGF5XgmPikOkgWC+0dbnMd9aVwQLNaqEuJFJ0gtK4xGKm8qJp65G9h6opE1OY/3MIZ5sVPyGiQJg9MeyMsnOolBh8KqakwxmhoEXISCWRkI51Ed95dZXUpgUIKOTqe4icMwk/TO93hvhSeI/z9VAnG5oBApAOhbc5TN2kuSRVL8vefnE72TAJdCPxUQ19HL51kgk2eVergfTXZLVy1c94o++qSH9PA425fVTsp/uQRde5DwSiPI8z8kNyZuyLyE2fB0F5NiSivpWcDAGbYaxRxBQnKTWp923YVzkCfB/OB+dA7qI8YWngz0AEK59OkjgWVp8tDBSM9Bvvf6yMf/PhrpkVVr4oEpbxqVyvd9O55ssfg4/8d3Lm9QWNIZc2lGLu0XhzxCyCJq1uw8lfdEaVV+guVt9PLFh8fmA0eNDJZXsy8IZREVcLbyzp3atcsoWVInociuBZU0Lj1XQDXOOVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is operating on VMAs and rightly belongs in vma.c, where it
can be subject to VMA userland testing and allows us to isolate it from the
rest of mm.

The _install_special_mapping() function will remain in mmap.c as a wrapper,
since this is used by architecture-specific code.

Doing so allows us to isolate more functions in vma.c for the same reasons.

This forms part of work to allow for tracking MAP_PRIVATE file-backed
mappings by their anonymous virtual page offset, as doing so allows us to
isolate and keep code that interacts with this together.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmap.c | 38 --------------------------------------
 mm/vma.c  | 38 ++++++++++++++++++++++++++++++++++++++
 mm/vma.h  |  5 +++++
 3 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 91eaa0c9e7ee..308a43eabd83 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1447,44 +1447,6 @@ static vm_fault_t special_mapping_fault(struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-static struct vm_area_struct *__install_special_mapping(
-	struct mm_struct *mm,
-	unsigned long addr, unsigned long len,
-	vm_flags_t vm_flags, void *priv,
-	const struct vm_operations_struct *ops)
-{
-	int ret;
-	struct vm_area_struct *vma;
-
-	vma = vm_area_alloc(mm);
-	if (unlikely(vma == NULL))
-		return ERR_PTR(-ENOMEM);
-
-	vma_set_range(vma, addr, addr + len, 0);
-	vm_flags |= mm->def_flags | VM_DONTEXPAND;
-	if (pgtable_supports_soft_dirty())
-		vm_flags |= VM_SOFTDIRTY;
-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-
-	vma->vm_ops = ops;
-	vma->vm_private_data = priv;
-
-	ret = insert_vm_struct(mm, vma);
-	if (ret)
-		goto out;
-
-	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
-
-	perf_event_mmap(vma);
-
-	return vma;
-
-out:
-	vm_area_free(vma);
-	return ERR_PTR(ret);
-}
-
 bool vma_is_special_mapping(const struct vm_area_struct *vma,
 	const struct vm_special_mapping *sm)
 {
diff --git a/mm/vma.c b/mm/vma.c
index bdd99ba56b4d..5308aa5a8c91 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3399,3 +3399,41 @@ __weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return vma_kernel_pagesize(vma);
 }
+
+struct vm_area_struct *__install_special_mapping(
+	struct mm_struct *mm,
+	unsigned long addr, unsigned long len,
+	vm_flags_t vm_flags, void *priv,
+	const struct vm_operations_struct *ops)
+{
+	int ret;
+	struct vm_area_struct *vma;
+
+	vma = vm_area_alloc(mm);
+	if (unlikely(vma == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	vma_set_range(vma, addr, addr + len, 0);
+	vm_flags |= mm->def_flags | VM_DONTEXPAND;
+	if (pgtable_supports_soft_dirty())
+		vm_flags |= VM_SOFTDIRTY;
+	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+
+	vma->vm_ops = ops;
+	vma->vm_private_data = priv;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret)
+		goto out;
+
+	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
+
+	perf_event_mmap(vma);
+
+	return vma;
+
+out:
+	vm_area_free(vma);
+	return ERR_PTR(ret);
+}
diff --git a/mm/vma.h b/mm/vma.h
index 47fe35e5307e..14f026bf3be4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -775,4 +775,9 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 }
 #endif
 
+struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
+		unsigned long addr, unsigned long len,
+		vm_flags_t vm_flags, void *priv,
+		const struct vm_operations_struct *ops);
+
 #endif	/* __MM_VMA_H */

-- 
2.55.0


