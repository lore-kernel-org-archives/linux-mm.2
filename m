Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F4FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EB6C6B012A; Mon, 29 Jun 2026 12:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3196B012E; Mon, 29 Jun 2026 12:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8BC6B0130; Mon, 29 Jun 2026 12:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7146B012A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:48:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B405A013D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:48:18 +0000 (UTC)
X-FDA: 84933533076.18.68BAF3C
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id C136B100006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:48:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uJD3RSCn;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751696;
	b=wwQWkeKWacFAl5ie6bqFIShSdD5MDpbMniSxg4BIJVgYe6/7217s/oGWfRvWWqJdedL95y
	apAKIo0rh69lWBhuB0SZ1mC14Sln0JWesTJG12fCJ0c4bV7x1X3Bsct1Et54zQRcaXbj2K
	u2yDztQ0oMODuKs1166XhVmFbNkYW88=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jP1TxhAMEeb/DtTSlE/UAKxKZK8EDPhR9yCR3yyzL/w=;
	b=z9b6+diwTgNgN1GBxDOAOBhmGbfrfAwWZd1r/n5yX9wD+/NHFYcORFonGVD3w/4bObTN6f
	vEjvIImcS16xdnSHrp07IwKKP+N5gpipJDBY2YPfyW1Ga3zMOm05Hkx8H5veGSuqhLV+97
	kjy3+r+6kWjsqha9z15wALpKYBdesq8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uJD3RSCn;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e50c5d14cso74180785a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782751695; x=1783356495; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jP1TxhAMEeb/DtTSlE/UAKxKZK8EDPhR9yCR3yyzL/w=;
        b=uJD3RSCnGgFiLwDh6EEcoNUYv54fEAcExtreK8v8fjeIpms9Hd2E/SO1gIOFVoJ9/s
         VdG9VT47+RYK+Fv+cSt0UQax4jLm9M5DUW2nMv6y0PERrAL10bxwWmjEfntA2vtbb0/G
         30LuPdjjz1aXOu7L6+mnFvpvKEzXv+S+lskXAgwdFa6E6iandhemZ4aM75AE8jPKf4Rh
         AwOlfjtLI4wqhfTB9O2Cb/BAnq41UIsCz2IjoxYn+R0FkVLcYsHMe8G7SIn3CcMtHRVp
         kgPRg64i6iVu6fCoAlZRdXMp8QNrKJCpdf0zT3GKmXGLyC3p3tCczrx17Tjsuk1EISyR
         NJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751695; x=1783356495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jP1TxhAMEeb/DtTSlE/UAKxKZK8EDPhR9yCR3yyzL/w=;
        b=WQPI9PKgh1Tg2na5lRgRzRn2qoB+WW1iYVBldXUzev4eWjwXxsFtfdR0pHdPP6gSbN
         nYvS39aqtkMIPOYrhqNWnDb+jh/fMdmfrKzxeStSgOZhWf3ab0hLr+0jTtIY+TDSqRmR
         sM/vCmIPHPmHDCzvMi7zZ5BH3EibYCXweULb1CW9ujjVpfmB/LT7jZcnjTjmroOpFexn
         U+UV3o5lPfmjbUzaSUVub/xOaqOZEr6zdFIxqvbfgmXcesL1wg6Uoz420eBmcA+E9sId
         NKiwRlERM6mJNH/xWyCoylQHKX4htujnjg/kSNDIw+QxwuQ89GVWQACr+znZNrG6eqTH
         c3Dw==
X-Forwarded-Encrypted: i=1; AFNElJ/13neOtWrQoJbP6H0KKJXmuC4Zolq5Lg8azxEVVVhByZy0P9e96ckeRShssBwXTUJZT53x7iokow==@kvack.org
X-Gm-Message-State: AOJu0YxIpYe7CfT4fZwG8Bil3ToAzKf3sQcej+LfKqVG+1beUq1nLELG
	sngd1Bmr6ZK6iETJWyqGG/9BNzgKXI5zzkcAmJctuOF4rCuvvR4SD+IggmMd+CCE8Bk=
X-Gm-Gg: AfdE7cmxarP6saz7LStINyAfaXWViZKe8HZWVg18rAYAE2jtD4gx1D/IcxFioAn5r+F
	ETTH1KOcW7lFr0bsSoM1/IW0HAWD23VrYxX2pG+TztmcTwZSpACAbj3Rd/Vttz3DT/KKD4ci+F/
	wF+FfFN38xFrz9QM1McoK018RPVe+w9z687S6bofHeF6PItLzaf8QjCXSMR5nEIeKhXXwU0IjZc
	Wsoxd7VQSzoHhUY/4j93QiVlfCjowrjjkoGBNSyusDz2ceed9mR7DL+vKuIWkCe13F7f4vIaloS
	InbMO/AO/J3KcRgnJ1SszzXl/AXciGCvQGlkdO1UwbHnUu2zKEL5vw7RmZYpOVM2zkz3gfR0Dt4
	tVL4ScRPKkQzeCuxdEXOvpxrAdoPsOWIG3i5h55y/qi/W6gB9XIQlWarUdAlmIXuzkjEqgRk0S/
	VXEHKAD9rjI/w=
X-Received: by 2002:a05:620a:2951:b0:90c:be8b:3676 with SMTP id af79cd13be357-92e62886f7amr48040385a.56.1782751694917;
        Mon, 29 Jun 2026 09:48:14 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6237ea0bsm22642885a.43.2026.06.29.09.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:48:14 -0700 (PDT)
Date: Mon, 29 Jun 2026 12:48:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com,
	shakeel.butt@linux.dev, roman.gushchin@linux.dev,
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
	mhocko@suse.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
Message-ID: <akKhzR8uHh-wzrx2@cmpxchg.org>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629130042.2649505-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 6gugyys7btd3u4oaiyaoqtcygwb7e6e7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C136B100006
X-HE-Tag: 1782751695-638555
X-HE-Meta: U2FsdGVkX18rkglIRNgTuI6iVvJN8TmhISsfH+YtQHVDOZP8TZGlQLSTHovgrxvo4XVQlymHgukkgaXmYaq0N3mzmJ2tjNdOmOhxQGsa4GOTD0sUA6L5Hcc3tQQHxPsQ/RMoOjLumz3M8v7d+F5vMVadP58j8/EHDwQKBsuwLOKq/Gy9CisKim65HLaHnFHhQaWzAKlUit65SfeAAEopRm7w8sPtqjS7Twl7ugRtN9v8b2xZ/nCxsZjwVZndl7wq8Y9N/X3KHYsCM0KpovBa6a6zagAkLNQ32pXO/YzYgzSLfAI6LhRnYuLOT5K/CwqnQgS6reRZ+dwQyahSCpbBquHd9yL+BH7KJek1WeXr04CYyo9pXv+TDvJHpX0vObLz5nnrQ9ajnWMnETN1ag6/w4QaaAzOmh64PYrQSZD0m2repL+qmYpl3WHkX9RC0ScgpS708cz6yHiCa7oIIUB8m7WW72V8WHrQdPlAIcxKoNBamkf7PY4k2jmAux2jA/Qll2VKrdmCy/ldF5w98K/KIH0tDBbPz2W5qCTKja1JFjraeS1WOPFC6RYtPTCXO5ZKxED4Zhc6YaLqs3wZe/5lpqRX8ddEr6M1y9Iz5Ps7a6kWj6ws3C8zLVyRezhcrptVvQ6iGbPdXxLddQcCsXmTtrJOKyOqrQSDak7p7z8DLEpxH8vF99h77Vfr4p3sj7QkNyeKgFu0muiIIWQOGRarLh+yAVJpIdo62cW18kaB7jtMmSx/gZr2iQ+jux0X6sXqqIvTwfwnR1d/CJxfN+sSOlXnfa4cnS3izxZK+VDlunrtWldgRrKpCfouLAzbutZZ8hCWxsc8SHs5Q6BEY9Zo+ZMQU0MPgy6j8VFYxGYRtMFX7Lb8uf3jzReSLwJ0kHzauA+YmPPwn578+ofKKWaL26g8rVJCLWl22BmB5w0lCQO+HSTLObdzGsredqktO5SeTNl5+tH2oLOaDF9OmsE
 gYkpsOuC
 5aUx1XGLTbrH1DBj/hD0E/Y4gSHDDP293f+GBT89dULVeIylY7S9ptWVLun8UUiQXt318B2s2NigpBaMYvZlGogAky4doeJXnQu9JwobneUe+CH3na3yvAi5OYARmqXIZ2zIRLlrW/jh4mXV795Q6knU1hOQPm/j00OWIzBxpLvMnmlXR+p3KVak+VsIN2mPnScHyj3nij8hcwI9mHZmynwIpRUDIhMPrazVC6iqncmzn3fGLIItUyVr5xOntAETn5XMNP82zhcCKfJbsRM9EgDXSz/po8y9eOOLXy6/4DgXtSE71fmNmypJ8CqJ3vdLlAka82gp7ASRoKBUizy9gfrT0E82MHM7KtRmETlmCK2Naf9/HVo2VLNeugxjG9uESsiAlDSmUze0iOHFFJN4bncJX6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif wrote:
> @@ -101,7 +101,7 @@ obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
>  obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
> -obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
> +obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o vmpressure-v1.o

Might as well move the interface part to memcontrol-v1.c instead of
creating a new file.

Otherwise looks good to me.

