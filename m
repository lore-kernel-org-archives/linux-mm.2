Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67CF105F78C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462016B0089; Fri, 13 Mar 2026 07:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F186B008C; Fri, 13 Mar 2026 07:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F12A6B0092; Fri, 13 Mar 2026 07:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8FC6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:17:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB8C1139D49
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:17:10 +0000 (UTC)
X-FDA: 84540788220.21.A7579D0
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0CD06C000A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:17:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHdCFO8E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773400629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h6f9y1Azogy+eVSZvA21A37bR2iFuIMAMTEPkCYBI8c=;
	b=O3uAdyGabCWdpmQijcFJuhSYZa1hqtc+IsEj3UjmH+NUpZvuiw0xXEHspHRcl4GaY+gjg3
	Z9lFgnwy1S8cSdacxjX62J9wsFMyv+Ln6Z3+A+KqM1x0z2Ve7emgTfzZCDYOkpr8TKD75G
	kGYHeAnrhzYbBVcD5MeT4z5MjvcmUYI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHdCFO8E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773400629; a=rsa-sha256;
	cv=none;
	b=PmGLNf/cEuDkN5sW6c18z25TM7T02QcGn+uufepNdEwO4xYEeQlpJg98Oqr6p2UCYruO2Z
	kvxIXYdMdXLUvWhAghUJEi27FCZYipTrAbIPS4wvyZTIVCE9AQLoKvVs19YO2/F9ftjSVG
	WKSMyH1E1HlCfrUoT/Hxq20cgR/vCnY=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c73a5473bbdso813081a12.2
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773400628; x=1774005428; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h6f9y1Azogy+eVSZvA21A37bR2iFuIMAMTEPkCYBI8c=;
        b=mHdCFO8EQLLh6Brix1LqliJHC2WBFAdNW4wM36Fq2CffC/nTCpG90/5sVDvG9NZt36
         98DwOElDb50YVY5WOCepCl9rXy55146G3AKlBUd0l8cwyzR8n6/ZxjvcQ+TT4+6Ddpu2
         +expcWwXPk55l+LMaRY9RjCwS+L8TDtp4PNp/kwRX0Q3dISgWHV5vkpBksQJr6DvHQ1l
         ZAhUPJJjyN1YYPDb6/N0pk0KaUNEkyWiRjr3HXuylUuy92AWf9ig8WCEW2VCG2jXCerJ
         oRV5uWd4EKth5eQU6XQmH/IK9qkmVwkzV3OpYyMYvaMRPo55OgfSaDSAjMqGaJG1UCkN
         wmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773400628; x=1774005428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6f9y1Azogy+eVSZvA21A37bR2iFuIMAMTEPkCYBI8c=;
        b=eJ0P+bzOXFpe8Y2Xvoja2P5DjWA5EdZDn2dopIq2bok2YLFM+66o/o04t4n3gzsziX
         eI/OFEPrsEd/mbG5BE8XEM91pJB1fRrSzGDxA07QLAdunRA7XbR9x0oeeopvekXUlkFW
         VtienMvIRcvPcu8iXCnXqrlvFbeYETKwDyL+RX6XpwcNIsQX31JJF+5fhr9wCmgD9NAD
         8PbanpG9RA4dkzzpIxNSaD9Uo5Hux/FRTTKXTgRlEYpR9U4B9Lsu/dqsnsPubXSQvhDB
         gCJYvyZj06Xh0epopALcwFqc8fOJs1tDJ5h5aCeBrvLxvQ2Hp+9TR6KUiBTBPPPj5lJa
         YOGg==
X-Forwarded-Encrypted: i=1; AJvYcCV01eg1QEE8GObHj0LXXontlacbvTrk9HP5d5LqqtXqqeSradQqiCfrglvn1KASNM/lSpi9bgByKg==@kvack.org
X-Gm-Message-State: AOJu0YxcLBLVbB1yO5XdEDsBdVFCf0djC1//plMjFN4lX184/Tg5ZsNh
	Oyq4DznTqfB5OUIlbWwijhkdjdbgjJGa2Qiyf8kG/4dpiWI4ObXfH+J0
X-Gm-Gg: ATEYQzxkyMYuKWNnsypN1alRTiVm5kEAPhHq5AmJYOrJjbXeSccmvHC0VVfRmCgPu4q
	2eiZpUJnQ3f1GgYhN5ipSDK9e/HTSLXdjrc7noW72okKtDcKhtnXLtXQI4ar7fjDfDF8oOm58Pe
	Ulh58LHmMXJHFxtQpXgRVjlqGBHK3lcTuAkz57Db5cy69mbkWHYzDOPtYooVdis8NXhxWjsEgxj
	Xqudn+xr+8mkQsGaJtFS2PNg7XsD+al6KwJL0X/mFNK8zHb0ArkcTPftm8WZ/3TM4Or2oYJ5xmQ
	tCe/Ew/eSnroLXWihWFTXX/ggApWI+YpNwEmP6Hq6NqiALqiOOA16jBfcA+++NBicsLIxTzkDoU
	b+w9HG4Svrpp1fbCX+xVDO2j4CN7tpJnfpSKYZpg0AaWXKLM9/Q7J75L5LjlLD/LV8VIGt+nDIP
	OADSV1ALtrgcAZjEyA4P9yMBdN+4RliQV2BBQZSlRDqsZ4ETl+mIU3
X-Received: by 2002:a05:6a20:1602:b0:398:b748:b566 with SMTP id adf61e73a8af0-398ecb34f28mr2274111637.32.1773400627841;
        Fri, 13 Mar 2026 04:17:07 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:89f2:c7ce:9a60:1bde:300a:8fcf])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eb9966d9sm1678930a12.11.2026.03.13.04.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 04:17:07 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [Question] mm/damon: conflict between DAMON_STAT and DAMON_LRU_SORT?
Date: Fri, 13 Mar 2026 19:17:02 +0800
Message-ID: <20260313111702.38667-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0CD06C000A
X-Stat-Signature: 39ucd3byqh1u6t633gdqzcoqwpuqdhig
X-Rspam-User: 
X-HE-Tag: 1773400628-169870
X-HE-Meta: U2FsdGVkX19PIZUwBV2s2fXg+UyZTiY8LYRyV9qQdejJPyH5XU8c8GYMqCtKjszeolD5xl19+KCxbcpNN7RkHTMtDGP7Jvw5B2+fNi+yZgqrz4uJtAf3jjf2i0rRXfFgduizK49VDgpp96sysUBQrnOKKasC6dCD3o0ZdvcVN1JPmiIAJ3oupr07j4+bAoobMRk55bZ7WP4k7wdo8lACGgIDQRXYh8v+Z/XUI5WBNxqsrwR14TyiB3/RLfc8VyvPFpdaga6BIE9Y2Ye5FfpjjkkrmbFqPPa/Zn2HTFKgkvJQquIXgSMCrpYMs3olaDEmm6QoHf5Ue9Sj9+vO6wckY6fuZWkjKnIweyeHjCixtTCnHDhT3qONXAzKAJjaoC3IwpiReJHkBU647sSQj2eFbghxghkFIaDK+nJgW4jGyPYsQXYmVaf8fopE6IEGIY4V+9GNFAFirY2Jt5pClmBpGDB3wEZeYiYEB5goWBriNlZSO9dPYFIP0RCMGPdAnGUBjpKOjx4WoATNBAhebHmjlNAnrVDymMbpKN27RiTa8aEYOx7wY88hyZx6fsq9Y+G4Ag/SjkHj0mm5SsTKiITyjpP19AAGlWAVoaw7fqC7bX0ojGxcPf5JtkWTK4/Q7Z4T50HjWCIGspYilBnjs4Gbn/JgTaS2OiPdoRz2/cYcIkvpdWa/ggmBowcOl7QOu98hTQ8F0YuNaNyD9hcX2lR7SCpDpf7AoToWYNGY05TN8gl2jJLWdB3QTwFQD5CF4LIBvfaZK5NQH4mMOks6cLa1OLhdIL87nSW7omqq0+QLnr1Imv1KefUdnsgzrj5pMJAGiOc7HJSeN53z962f1vOEyEZDTdZz+3jdiURI5+9ay+XbYjqWgpxCLRjPTWGkpnaaIPRLchdWOHNZOV4I+1YDAa5uk3Nw+xdJ0JGLg1+mUabQoh2O7LDg0CeA00kUuOM9VQixqmRtL8zIjPRqmjT
 2QAz97ZP
 zkFhgyJOLfCNEFoIkqAwdsAIlldEJXzzcoEUYyGD1B4I1lQ6XY3+M71p25ME7UhFfipM0ARNdwqnYhKv4yLhQsZYL5fr1V4KT523yG/1Ff+J/5vZmNIIXva5xOGp3uflsIp/zWSHL0z75e4XvrqDYUiftaJzqqOTLnU0AufUtqWYIvaPnmiAHiH1dqAi0lR+l3YSSZxcKQckczarsLFgZWRzY2IWHtSZTJ++u5RbSnueQsPjjBWltIb14iqZiRc62DBh4ZFcs/eGUYJHIjizxBjMIR7CopBt29FJL1ymL6+iaczpbwBfHkHsCjpIr3X/9gqst8nWKJuW4s3q2upJzSuSr+kIWd8EtGXfhVfSTeAw+kUxHoYWEWIEp6tcf+1NoUByOw5TJYAOF27QWg3kAGHBCv+e+2XK7yjGzLV0J2PrBDOrYanRxRcBo9kpd4GiDvl4XgHXPkluBCh24bUzTgPKVhGeJ/I9riQsXD0iqHO/5rDlLiaAV/mKvods6JgmF4p6jnKlVOWMgy/GHpLV+BYEUMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR
=====
When CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, enabling damon_lru_sort via sysfs
"enabled" parameter returns -EBUSY. Is this expected behavior? If yes, should
this limitation be documented?

Reproduction
============
Environment:
- Kernel: 7.0.0-rc3+ (x86_64)
- VM: Virtme-ng (4G RAM, 2 CPUs)
- Config: CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, CONFIG_DAMON_LRU_SORT=y

Steps:
1. cd /sys/module/damon_lru_sort/parameters
2. (optional) tune parameters: hot_thres_access_freq, cold_min_age, etc.
3. echo Y > enabled

Result:
  bash: echo: write error: Device or resource busy

Workaround:
  Disable CONFIG_DAMON_STAT_ENABLED_DEFAULT, or disable damon_stat at runtime
  before enabling damon_lru_sort.

Questions
=========
1. Is this resource conflict between damon_stat and damon_lru_sort expected?
2. If yes, should this limitation be documented in:
   - Documentation/admin-guide/mm/damon/lru_sort.rst
   - Documentation/admin-guide/mm/damon/stat.rst

Additional Context
==================
- On major distros (Arch/Fedora), CONFIG_DAMON_STAT_ENABLED_DEFAULT is typically
  unset (disabled), so this issue may not affect most users.
- However, for kernel developers or custom builds enabling both modules, clearer
  documentation or error handling would improve debuggability.

Best regards,
Liew Rui Yan

