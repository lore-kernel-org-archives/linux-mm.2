Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22AE606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=IAXWPkZR
Received: by kanga.kvack.org (Postfix)
	id 8BA176B00EF; Wed, 11 Nov 2026 21:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891646B05B0; Wed, 11 Nov 2026 21:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F476B05B3; Wed, 11 Nov 2026 21:05:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0EA6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:05:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF3A2803AB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:05:25 +0000 (UTC)
X-FDA: 85424825010.10.B90B602
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id EEA8DA0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:05:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IAXWPkZR;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794449124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKzq1YaHaTK/cMOsuVlloBBGSRBcO+4dM5JD9G9qTYM=;
	b=2wiSo+ULHAKp9fP07wKaR4+Dd40DbAtkqCBTwsazYU0C7KQiDEOXMeZYRddrcYJnOkQPy/
	bhczLo/kkwnKQKkGdIr7WeTypA0R9fzH8CaqQWMaMq7mCKgG+DwhWJp0q8eN8qLLPJ0KAY
	b/46bxvcn0EaCAmjHhJ3AbI5rAELWhI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IAXWPkZR;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794449124;
	b=L5Ma3QSx4HxrS/clcNNZmj1wxs7O9mDN27CMOdy1yVkCCJ9V223M2BCh2gOqm3+roRuwq1
	E6NviDCsqzKhlJTAJrPGLZTIL1Aflt/LVrQTlEwRwOAIhAc6VayJgyQgzAgciZqaBr2dQh
	3VFKlUkItzCa94rO4e4mkRQ7T59b9BU=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3acb11973c3so2982627a91.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794449122; x=1795053922; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qKzq1YaHaTK/cMOsuVlloBBGSRBcO+4dM5JD9G9qTYM=;
        b=IAXWPkZR0bDrzIZ/c46XSkv3nF2wMz7B3h6DDEttph/zSzgjkRwTzRACF7SHfiOw1f
         5t2j1p03xhhFA9ohsu06wW/gCeHnuW/Zzidapm9xwo7VxexQylN11cbSjRBADOn+kFFn
         j/2Wd4JjMc5J7V9Q2xwCLikm4F+PxcTPOKbXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794449122; x=1795053922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qKzq1YaHaTK/cMOsuVlloBBGSRBcO+4dM5JD9G9qTYM=;
        b=lOzSEntv4wYWgOBnclnOnhwaVyEVml1JBVBVXci8VgkvkdlwACQYzM42Xjd+wt7rwH
         Hmq+KsgeiDg7H4z9ShIiFcLkDcHp1TH7r7wMSsarZanDT/W5UczsLuFl1ZgmOe+W3y80
         DUdjdHbr1tsZDs3zYCilllST/p48utAXS6pKAibl1N1Qh/gYvnz8M5TTDmYPFPz1pLDo
         gI3Ytpz9KsZud5UDKrqTzfrNk+u44vhrasEFEplVDtbHYUZpGzgZH8UIJLU+K6UD/swP
         xqzjqyBtbxWlTrdS2+kJxtNSvj3GqM38BhCnlVMjatfV55kqXnIe2oV3rOo1YLWk5Ati
         BOPg==
X-Forwarded-Encrypted: i=1; AL+hErEiKxXZbp75JT09dmTPT05REzAxnnY9UZyDvNLgVqNZotjAYgYD4wrmNvl+BoqYFkQjMWfch8XA5Q==@kvack.org
X-Gm-Message-State: APuU4Z9024Yw3aeNDJvmdhdhGJ6tVBQ0iuaPw22gAd7nbbkNfwLwnXpi
	dfXHD5ylj00m8or18bIdilcqzX/XOlBLOsKK8PTWmNGYYn0rotCeoiKO0wbYwXmhfg==
X-Gm-Gg: AYBFou1eGLWuLzoF/KUQGmcHFQ8mOuMf2c1Lm5xYNTf586EB73EsqK2pVs8ZuCt3up2
	KugQqHV3uvYTt8Sy1VEKGjJ8iAeZJMcsBW/k5t48UrbSps1oUIt/8JcxkhCI/BF9TyrHvEYMoU6
	c4yhMLzD5qrZc0nMZBtmLaYfN7yLqRti5A/gTgePTEPnI1k309X5HqGCBYwgOvDaA4/CZwzzB1Q
	Wzg79jTxLtFUuflMFLMdQmM9ljknXaAuhxpxe8CZi3r66DK6+CW4AP40MKNdM4+AnMB8S3AU3GY
	HSBuUMkqJfwXSsT7xN1QwKHvBOh4QoQZXufzXvDmlyrNz2dc5/2WRZGIG64Dy26E9BCh3HzRRg9
	6GABEoaZgamtRGtB0LUJzfwtDJ4NTdFXioIyBm8fTAAcwP8ZLJyovshy4O4oA/WhuPCl5lxZSVr
	rkXwmSX7f5l2O7dk0dic2B8DuXv+9yrVpql4gP0168bXfsww+GBKZzQJGYw9TdcsEgxlc7V5/Mh
	K5gG6X6o87FEyyrjr9rPelUKFH9EVDirtpIKgquvukaEoYIKE5mZZefyIE/MNVI0vsOhBnjVKZU
	86GbclF3G3mGp3nOcXmGAfyX3ZAB3EiFPCnPaWlRQHuiXT8QK91X29W7IXq6U3GsdrPPHg==
X-Received: by 2002:a17:90b:4ad0:b0:3a7:3474:b1ee with SMTP id 98e67ed59e1d1-3b182f1adcdmr4140105a91.60.1794449122530;
        Wed, 11 Nov 2026 18:05:22 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ace7:ac44:3dca:1bb4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm1832060a91.1.2026.11.11.18.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 18:05:21 -0800 (PST)
Date: Thu, 12 Nov 2026 11:05:13 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Alex Shi <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Helen Koike <helen.fornazier@gmail.com>, Vignesh Raman <vignesh.raman@collabora.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
Message-ID: <avUet_6jVqlWSP00@google.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EEA8DA0003
X-Stat-Signature: m9ehf57xt1pu7swnt6fwxw3bsorhktba
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794449123-922844
X-HE-Meta: U2FsdGVkX19fnwD4mEQeQ79Pdz5iRqDd+WVKW6xxHZjfY3B6Wzn8Ryz/b5Fvfmo8w3fyaB4eCdd0khawfxZKqWBUhw7dfWsBShciHeeSR1PQ7ZhINbsFMTt/pinuqZpr+dkeFpcQNIMUyX7Bq6nwb/CgJ1bjPe9y5a9hxe6V9IvVoQkKWhhMxBHdOsYCeJIaNxc8BCHjAXOTFRDVgLKDmbrYctr4o94gf3bHnOYFHHMZq1WYdkJwibvm4AR5oqb/HH5cxWy7C73u4nxoLY38JJO/li2XPRjf1TahXi2NkI/aMVWoSvsWqj6JfpM4Y6zKB7MmEh+cBZ1OfPk+A30RkBqaGaCJmAJEe/vikZ1TugVOr4TqVJP8pNZ4uGalY2ONu0JSCSe6ajXffgT01JUop7U/VFG/vYzKV27RoT7u+HCygJNxf0KlcWezZTdfeS+fsLiYKI4ug8p9MYsIVH4yZnWB1jI5dLYwxjuOCyGaxOhJcQKlTDq++pY55n5vkfeTsuQD7zAN9VpUwWCiHZP5LSWvVmLI2YbAER2SlSQ5m3wXn/HzCB2An79jmsjAmPCoAqiVTtDTwIzbwyhm/anNmYRskmRuSPHda4Q2g0iT/prv6lRO6QU7FwOlkX3ZIA+7XsP6EfJ3jBNylMdSDtAANH3RC/1GfBNjOjW7M4ZxMauIbM2KLiDSbFjXD813S1U4ad2wMb0zk9/21BqZNzaZQFL+CZhB+Nrv5OC7/hxPkd/LrsiWdsBPcLYojJBrIv2u+W2Oi5CGvyBL7SOoXGsOpcfbGR7bypvQq+qLaDm2cAWxtmg7D7L2nmk3M3xNHiw8B2FwKEHHKASRnNsMmHdlwtszG0Bv3giGXpGq+VYwDVZjx+SZWmlLOHJwEPRnsIuJXvwJMR6A/6enUl2uPtIAAJ4H7Ev5WQBBqQGAHuoIW08JYG+rprGeZtsC0R/uTHVqjIJfT8Y7MJHwjfo1qwh
 hF9dpYUc
 3TqDLLJ2fOHKkklo9oO8N7rB+Pw+NlXiXLg8A+7Y9sK7rWn9HeyTuh/ocVth+lFZR/DQ8LUcf+0VFFaZF51/CqOOecmb9DPMCbd/uU2Nv82UlBoanZzbJKXz64myD/LSduAFj7MzwuOnYjPN8bAz+ghLN24yOJKlSQdjHfsI2X+7K/VT91VmvyrZ/WhPAkCiY5+OiChW3+x1laR1Pp1yO6AIH3ZJ+7Qa+ZG5wx1mLoceJbqaMlUWGyP8mmcXQ0qwGWJqehnUQ5EXeeFf/k1CW/2ulAGORlow/vrWawvDin8ElTDtLun5/n1u5HLKwhjdGdgDO//LFOdV8dtQuPgnNdfYF3xIA4/Hn6WBLr7Kl8yhb6/Sx7CUKQibst3HrsvqMlxAFRNJ8O0HCIxPLzwz5or9WOQZdzqERC9+leX6BjHreJBePo1qZRXmi+b65yUXfN3fzgy3tYoTIo38+tH8vcWGDp3CfkmySdb74U0xUu1ASp1O8CMwvlJb9Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/11 20:41), Xueyuan Chen wrote:
> CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> counters are updated regardless of this option.
> 
> Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> debugfs is unavailable.
> 
> Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> documentation to match, and clarify the pool name in the debugfs path.
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

