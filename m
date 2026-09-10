Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFD2C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926326B0092; Thu, 10 Sep 2026 18:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5236B0093; Thu, 10 Sep 2026 18:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8125C6B0095; Thu, 10 Sep 2026 18:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42D396B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:35:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BDCC160680
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:35:28 +0000 (UTC)
X-FDA: 85199310336.26.C1B27B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63530160007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:35:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fjfXeFxv;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789079726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STkBHGrY8NPn9tPJq9ZdQdMGtxmiRBYe6smZsSwC3qI=;
	b=eX7SaV65xcZKRSOleFPMRZaUAosgLlkx4X/5O+ggekw8Dk6wwdJSFvJRLwez8HWnTd36tA
	X89H9Q1EgQRebhOrUwa9XBU12aJ2cQ++yodfR6A/q2vwWAQfc0AhaHjaoKijXDx57hqVTW
	qDkvcwR5vGla+c/IPjSeFRu2h66B9Qo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789079726;
	b=wjDiC7IA2xBHSLSWiq9e1+q4eCV7PL7fmDZi0WpD2/xTQZFm//OkEx+kYr3C3uIeINalr6
	Gt7+z4PG8DH0riva3YrNlgm3GoCSHd2Uhx6lZsNOK4z60ApAqxY/jh/xFsDiFsioxiEy/Q
	8iEPCAbRwKNSocMxTGPOH5xnU6teBwo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fjfXeFxv;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA03B601F0;
	Thu, 10 Sep 2026 22:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654F1F000FF;
	Thu, 10 Sep 2026 22:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079725;
	bh=STkBHGrY8NPn9tPJq9ZdQdMGtxmiRBYe6smZsSwC3qI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fjfXeFxvAmvRp5i10QZQUXJHVhAIlZR2E5BxaUeqTMPZBl0d3wuAExfDvBibSwnDC
	 yr3Bhcxo6q93dW5Yd6zgLhCM36coB5mJgWNID03esCLuLu0gWhkCLFaRmX2mWb5MsA
	 G6L8IrLiVJDrqChJr1OYCIfA5FtTnxxX4N2tXrPiHuKFpOp0a/DQHmpaVS85/JRMa6
	 PLVDcSZxU7GRQul6JODgziZN0vnr3e3ZRLQxuU7xxq6jLaDeahBA/ffOeeSPeovLqq
	 sqQsHclNV/fDSSfL0jSxDleafLFwKzVIiJfEK80fjdeCEsjmMyo9qyc784Hcn02G8W
	 c2H8RPwQ6cmsg==
Date: Thu, 10 Sep 2026 15:35:20 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: lib/base64.c:58:18: warning: implicit conversion from 'int' to
 's8' (aka 'signed char') changes value from 131 to -125
Message-ID: <20260910223520.GA3375179@ax162>
References: <202609110514.S0a0FD6a-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609110514.S0a0FD6a-lkp@intel.com>
X-Stat-Signature: p3hhfhi5u49unqco5hxzdungjuq755ar
X-Rspam-User: 
X-Rspamd-Queue-Id: 63530160007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789079726-481382
X-HE-Meta: U2FsdGVkX18CiEyo4QSRXHrOWqSMETEs4qeWN596zm7+pYSBY13Dy3cH8jImJbY4ajHEU7aqnaOOvAuUty5JF5+ZBmGhb74dlo4UTb/sAEp4T7qebMS37Woq1BizbR/A3ZxygY92rM0OdBNoC461jVtLlpyp7dE6GyT9Ha/8dHrGdPwOwjWJPukVElIkTlYF79X1rfHn4dlq/wh/XHSlNbSjGRP2rDxdnCWkau5yuha0S/hjX3QGWB5qy7mHrAKnj81OVHolGBBMenz0oDL3t/aHo/X3p2LOEx+DOG9BLYOElG39/VybWXOgU2OpXKkFs3W8M+o22PII2ep/6DquFXqpwJpv3G/csg6HN5fQPkqU5vtLzDZWXc1g5mLv1H6OWxPo4ANnISYX6z2iw+pzXjLKBCvbgdt+suW3bNogZFd1UJkWVFRsuk6ax5UbJySwt4xAIqf29copmDpGxtRvZgaBR5OWJPY+CyzSvH4Bkhy/2+N5ddJiyknEGQxuZIiUkPJjsk+A9FwopEgqzRzUxlsafRh0yn8Fb3Cen2/Ina5cZtyKeeNB9SeV1MqHkI8r+uHqIudlBuZmY23ESkA12jkRntPKMCM65iL9fX9J7BlHAqpWAt0OI6UYT8F/v1vfsiKHPocx9r65ORQUSEyLb0ufN0z+evJZDxucT0dd3DzyyHrY+PRu9+j80JVjnnnx8xw+njVYFbPJj5FN4LByjw5qU7+4PEJwSFhiSIVVjzhZLPe5arCGwgYfVuIZ6n5HYV/TKD6oIPSgVRNqHjeAkr9lv4AUC1IbUTUGCY32xEBPk2EcSvj2EKoLWQ+gzPta/Xh3Ld3Bc+yEVTvgRtpN4zCbnWGuTpY3ofGYDEG1fAC4wd3m6vULdH5eeSOPUkmm1TDu5FsMXfgmdPX65mOcdEug3MoWKfAlt7FaH61goAK58Tb6BTu90NV21ckkGxjkxE4z/4t0Jueirb1RaZ5
 PCsf7DM+
 DIy5mdKZqWC1TmsM8+2+McB3Gjh3ziO4frjFdiVdqR2vByrhTwb6eAmLHLEVsj6yhlWKDEy9lP6HKx2MNwoL1PzoQDDRohrQ8a95w4gshJKniVgldjLxrQ70C8oBDm+jgY6SbuJzx1hKrdFsY4fi0mDXgushpA62i8gLRbmNa7RyoHWAeCDi+JqY2iUkD0xZZU9zjUIk1zhTosHNLLV02puwEEwJUXpRljAsb+MQZbNVG4MDwrhKJI+7d589cTahbBx0+eW8V9AQ4MJMwKAHS75hQ0TyMT6AbtunUufr/6WWcK4vVays6iZazktMqLK2TBTv6be161XibZNpp1ukphMbg53hk8vFo3qkUAdm/sDV7jd1Aw5IvGz+zYmrftdut+ATzin4ULCeoMucUN1H71M4Jyj7BKip0ntybjm/K9KBe/ODJadvpghob9LxKuyFBMEW30EFbZ1kSyQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 06:07:30AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   50d05c7c76c96b90462f24debacca971d2e86713
> commit: c4eb7ad32eab13ba64cc452c6f43d518b63f5e03 lib/base64: optimize base64_decode() with reverse lookup tables
> date:   10 months ago
> config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20260911/202609110514.S0a0FD6a-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project d3db069999553568848400c84cbf815c03f5470f)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260911/202609110514.S0a0FD6a-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: c4eb7ad32eab ("lib/base64: optimize base64_decode() with reverse lookup tables")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609110514.S0a0FD6a-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 131 to -125 [-Wconstant-conversion]
>       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
>       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
>          |                                       ~
>       49 |         [0 ... 0x1f] = -1, \
>       50 |         INIT_32(0x20, ch_62, ch_63), \
>       51 |         INIT_32(0x40, ch_62, ch_63), \
>       52 |         INIT_32(0x60, ch_62, ch_63), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
>       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
>          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
>       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
>          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
>    lib/base64.c:43:48: note: expanded from macro 'INIT_4'
>       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
>          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:42:48: note: expanded from macro 'INIT_2'
>       42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
>          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:34:42: note: expanded from macro 'INIT_1'
>       34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
>          |                                              ~~~~~~~~~~^~~~
>    lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 130 to -126 [-Wconstant-conversion]
>       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
>       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
>          |                                       ~
>       49 |         [0 ... 0x1f] = -1, \
>       50 |         INIT_32(0x20, ch_62, ch_63), \
>       51 |         INIT_32(0x40, ch_62, ch_63), \
>       52 |         INIT_32(0x60, ch_62, ch_63), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
>       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
>          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
>       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
>          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
>    lib/base64.c:43:48: note: expanded from macro 'INIT_4'
>       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
>          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:42:24: note: expanded from macro 'INIT_2'
>       42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
>          |                        ^~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:34:42: note: expanded from macro 'INIT_1'
>       34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
>          |                                              ~~~~~~~~~~^~~~
>    lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 129 to -127 [-Wconstant-conversion]
>       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
>       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
>          |                                       ~
>       49 |         [0 ... 0x1f] = -1, \
>       50 |         INIT_32(0x20, ch_62, ch_63), \
>       51 |         INIT_32(0x40, ch_62, ch_63), \
>       52 |         INIT_32(0x60, ch_62, ch_63), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
>       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
>          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
>       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
>          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
>    lib/base64.c:43:24: note: expanded from macro 'INIT_4'
>       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
>          |                        ^~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:42:48: note: expanded from macro 'INIT_2'
>       42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
>          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:34:42: note: expanded from macro 'INIT_1'
>       34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
>          |                                              ~~~~~~~~~~^~~~
>    lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 128 to -128 [-Wconstant-conversion]
>       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
>       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
>          |                                       ~
>       49 |         [0 ... 0x1f] = -1, \
>       50 |         INIT_32(0x20, ch_62, ch_63), \
>       51 |         INIT_32(0x40, ch_62, ch_63), \
>       52 |         INIT_32(0x60, ch_62, ch_63), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
>       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
>          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
>       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
>          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
>    lib/base64.c:43:24: note: expanded from macro 'INIT_4'
>       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)

I have not looked into the legitimacy of this warning yet but it comes
about from a recent change to fix -Wconstant-conversion in clang:

  https://github.com/llvm/llvm-project/commit/a5ef934a8d295dc03be3960f2b3744ec2e53238e

-- 
Cheers,
Nathan

