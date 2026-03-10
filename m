Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF085FCC9AD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618CC6B008C; Mon,  9 Mar 2026 23:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2AE6B0092; Mon,  9 Mar 2026 23:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEF16B0093; Mon,  9 Mar 2026 23:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC216B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:13:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04E6D1B7FC6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:59 +0000 (UTC)
X-FDA: 84528681720.30.88EE059
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23766100003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=bVJgYKum;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf05.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CsZ+NRv8KqfccXci+BU1bzMppvKNdmw8azS1lnHVKVA=;
	b=Fs1ufZ3pLaKGwbTOsbtXyOSU7t/vpUhFNS12lrRYD0iKhO8Nz3JM9GW/KwfQ5SkX2sD+Ug
	dagl8leD0XE1/9gLZfub2yNSVqXqKgmTbv1AMFPkryYyytA5kcVuPOGfTHRbm4TEBshDQ3
	qVdECW+/rGstyx/JMB72GIPMcnXp95g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=bVJgYKum;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf05.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112378; a=rsa-sha256;
	cv=none;
	b=CT3QjQUUK0w4xV1BZnum+/FCpkf2JzExejnaTn1xxwHXAM+VuEh6IBWgvp4staHAVz7YPp
	UW2p0RCmt5iX6ffirEBepQfn9tMxxgKsZuosKbYMUYClT9frVX1n26MFL1dEscidfSlA/h
	+BlAX9wcog8G3V7OZ76KC18vhmVi/4Q=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35984cd0335so3712891a91.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773112377; x=1773717177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CsZ+NRv8KqfccXci+BU1bzMppvKNdmw8azS1lnHVKVA=;
        b=bVJgYKumDrDMdIcFdP4xmBuDlABZCe0k0KCrBemPewT/M8tlQmryif3QgaUJYzwfQ1
         CfxwHFxMCZp5LJZJmKlbEQU4EauQ/mC6RVJ2fA4ZjtisEFZeJ+1peZjstLk5BV83ROim
         tzTCtXCceng4YgPBf1x7FiAQLzkckGL732la4vug9lOnKLAu5lmNBsSwfN8KWMYViOY2
         rXBVZN6szZrAJchOr0gJynF/FAvtTkigJoiYpz+/Jr1dtRvjkJOxn32McGNgg/lkp8GU
         4EnDrd0pmXlYQKUxZbXbOrnhpuvVd6HleOvnqRmkG5oawdkFPnTcSTQ9kTqZb9yNnNqJ
         pe6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112377; x=1773717177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CsZ+NRv8KqfccXci+BU1bzMppvKNdmw8azS1lnHVKVA=;
        b=rdk/WoV7GZNxeB+DYnMcPzyT4bAqjiwhhXtUavdf8GAOduZu4TlyZprkLVPtdaXgjg
         70BPZPWnU6S8s5Wn5xkGPB1u1y1J38yVoO3Rn7b0ffYprJ9soWmS+TmhQqKd8+65fZtn
         v24g1Vzv9AhhKkkpMWwfU3wGv0Ijej6Anhg3uUA48E1ym67B6OgcLmkCKnyBTK0Dk9wO
         6dsHzMq7Uz5hkXonKCj6mFaP+O4WBKhNCYiL4LkHYRNq8sVxHmPwQEmuS8oy4zIvLHiY
         3dQTjCtLoujaHzcAd+qgRhqjPNXYotpjUt6bDdUFXqGsrKNQN3InPzb+4cEvyXqyNjpK
         qSRw==
X-Forwarded-Encrypted: i=1; AJvYcCVMkm44ApVoCHbLGwQPLhT37Dy980XF+k3ptwBLUOc48LBMfzGXhoL2Z4X6fqTzNFq2O8LAYZHm2g==@kvack.org
X-Gm-Message-State: AOJu0YygTPYCUINZrdRxSBDTp9a5WsdOug2gMDeq1kmkxigbTSnvTGgQ
	megZ1ZEWIT625y8YCrhU09ZQXpFO/iyifUrr+jqnOtCR7npn531FrdLHaNR8lXbfITI=
X-Gm-Gg: ATEYQzwmifMXBb4xKi5dJdKplMdls+333p+2rHLfPXF0vHb0ZxQy9nZcyPEzxtAubLs
	07EFfiE9xlrUNExyMzmJlrJ56S6KBhW+MqcrfB7+SV2/6g9ZsHOChy8dpDSBPb17Lzm4egXJ+Wx
	DOPLkK8APz9vDbVwneCToEQJd9ZMCpDzWKhHBE7rhDOnER0ZEU+NPH5zOcBkflPoKMd/oAUJhA8
	AytWK2biGvvZYs0ThjW/9EAfI9pwcbeFolMLujCv8PF4NJw4pWs8yL4mFLeWw5jscaUBgBNrb9F
	GgqUVxx4qqbUYfhUmg3j48lK+KrkSCFbyTrPWudBcIHlAGuE8eoY8z/bLhl3riZmRJuTJDd0Jqs
	m1TNEz7jS3QBWVo92VcQ1yflA77+87yDmoOcikk4GWglWbz/PVmBkCe99qbmBlLTBkT8/XvU59Q
	OI6QgPFFuOOuLtXaiqX3SfbBRg8hGke2GeK+tc6A==
X-Received: by 2002:a17:90b:48c8:b0:354:7e46:4ab8 with SMTP id 98e67ed59e1d1-359f08125a7mr1670281a91.18.1773112376956;
        Mon, 09 Mar 2026 20:12:56 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bcc28f0fsm5169284a91.13.2026.03.09.20.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:12:56 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V2 0/4] record non-slab shrinkers for non-root memcgs when kmem is disabled
Date: Tue, 10 Mar 2026 11:12:46 +0800
Message-ID: <20260310031250.289851-1-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23766100003
X-Stat-Signature: 6y4osrjpyr8aegn1jyohm4ajpzc8nc63
X-Rspam-User: 
X-HE-Tag: 1773112377-4539
X-HE-Meta: U2FsdGVkX1+IQeS7hlFdKRv4gLI8f/KVnsysJtCdP/PpnE5TCmjuf5lVoziLOG5n4PycGX1F+rDIHNnc7dD1YweBvFn0Vwt13OJNm7YBv8PNX0rT4FqA2jR9ep7/rkP9YujgSZBcnEjVLw+ZZLbdam21z/MKeQhslaY5TWxwprlwhuB8dm8PzX/swYCSefJGgs5ioRr1BoNYQh9KVD3X1u+0TnSkGGly9/oVpk0GWuFAwMFnp4ftjBrW0V8J/6OyPShTG1G6ybyESJRHiiMMR6M5IMKu+ruookTT5Q6a9YgNP9cFGuW97ZhbWmKCMy4VSqDbjPfnGiqkyNTO9tNUpKsEcfB1O4MMA74lFVBf6R9G7uUP4LozuJ1V+Xbj1MShreD95cYKyFJx2T5ClzzWA+grBHEkyrNXaDIEv3j0Gy6GUCfvLdNPAvoEK6eJKovl5jyd3m8iCzcNc7UREw3qCDW++UNZFw4t7t9GBogWxsAl5EEj/KN8aQzB0q3Yzc1yVQXOKq0ngQLqg9AmJZUmgbP36tnZG+j81RQ1TC0U+tpJZfDt0RvMA2YC5F2IMz3kMAoBJLyEOFoSjO/94+DsBEzowDm5mI3X5uiJqhYo0xBL+saopBZ8BSbC7xSS+uAdt7xqfqaYkf9LK20tJ050Jm1blAnAf5W1/0gJ6EkIFH5x0X9BrfnAfhmSozEMFdLQeaW/otsiA0CDy3uFXZj91aPvfdoj+Ug767zT52a/BLWe9CyJDrL7Pp4EgWcuRbieJhd4NRcYFTccvc4t0Thpv9q5QyEC9Rh7I0/beyynIMftcEkt+Mg7foJ8X9SJRcFBaLcRyyH7Els9pL6KDbaDrSoxPWuT5U+jWgZcuo1pQKFF8bStJnLH86F3gRpN7d0+Wquh5ve1a+7vsw2cxSuPW/BA3OF6jZ3/QI7W7wK5T2BuYlPU2pEDu72gk8XKgdpix5a2sYeB+vUaxF7WwyK
 7exBP9fu
 IwpFIXYqzHcYQWH0oA2WZMljK0u2ZcEzmsJzzmyluUUADuZTWDwf/7nvTqdjvDKLF/SEpiYESNoYAiH73T6f1rBzAy/k4HPqRy+JVFvY56HY/OrVqHxXbNtsvqUCMI6upxxt5nRe+n2xbAs5amkeRH60ERoGs35gyuNsWii2ZAYp7pRDISwyCGRGaCR0TG0jxY5WAU5WDAhrjrSe2N1awy/urK5DhFwpwrgdg2WLmumWvGEsYEe0JldSZDLXyBVK30xxDPuR+pgqdoREc2HfjZMSrgF1PKU4B1T9WDB1mKmkFK7WOwoqrKHo8V4Cb+USzRbel89HBN0fR0w3wFVqUyytwEv9kqxaJTcMv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When registering new shrinkers, all memcgs need to expand shrinker info
if new allocated id exceeds shrinker_nr_max. But if kmem is disabled,
only non-slab shrinkers is useful in memcg slab shrink. So in this case,
it is enough to allocate non-slab shrinker info for non-root memcg. This
can save a bit of memory and reduce the holding time of shrinker lock.

With this optimization, the finish time of pod creation in our internal
test is reduced from 150 seconds to 69 seconds. We test it based on
stable kernel 6.6.102.

Changes since V1:
- reuse shrinker_id() to retrieve the id of shrinker, this also fix the
  build error without CONFIG_MEMCG.

https://lore.kernel.org/all/20260306075757.198887-1-haifeng.xu@shopee.com/

Haifeng Xu (4):
  mm: shrinker: add one more parameter in shrinker_id()
  mm: shrinker: move shrinker_id() code block below memcg_kmem_online()
  mm: shrinker: optimize the allocation of shrinker_info when setting
    cgroup_memory_nokmem
  mm: shrinker: remove unnecessary check in shrink_slab_memcg()

 include/linux/memcontrol.h | 194 +++++++++++++++++++------------------
 include/linux/shrinker.h   |   3 +
 mm/huge_memory.c           |   4 +-
 mm/shrinker.c              | 133 +++++++++++++++++++++----
 4 files changed, 217 insertions(+), 117 deletions(-)

-- 
2.43.0

