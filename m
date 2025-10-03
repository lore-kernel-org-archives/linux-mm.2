Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CB4CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 05:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520ED8E0005; Fri,  3 Oct 2025 01:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1A78E0001; Fri,  3 Oct 2025 01:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0B18E0005; Fri,  3 Oct 2025 01:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24EDD8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 01:36:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCCD1B9166
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 05:36:25 +0000 (UTC)
X-FDA: 83955692730.27.275B0C8
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA788C000D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 05:36:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=DJJvW5PE;
	spf=pass (imf22.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759469784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JviM4x86VTg42/9SFICWditZ8FIZ0/vFiF+DDrtEZ08=;
	b=AjC9K+b4m3N/lSIt98072IfPUSJYcezv2vyCuZ0pHtt8o/RlEcabFgd3/8gQZUFKcP3e8u
	tb0tQaSCphwJzYeiWCwYn1AZNl2P63jwlGuWVhSp1XIRkHv57dTbDQxSqnyA9k2mT8nnfG
	EVNOj0TWPcOSmtE7ubTEkugZl2AFbZ4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=DJJvW5PE;
	spf=pass (imf22.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759469784; a=rsa-sha256;
	cv=none;
	b=NDxmlm7XiSAMZ0F6kcMohwXzpH9DzhZ5yAg8JedBIjEwLIWlFDXPm99iFX88ojImSaEcJf
	c15Pag/Hz9roOKGea3U4Bjqrf4smQJ5ZkFemyKC3oMV1nijjB8Qd8BtNjLfPL+wWtksrTV
	9Ami4f+P4SqhuSBDKdryGP3WM0PUCWk=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 8220940B15
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1759469781; bh=JviM4x86VTg42/9SFICWditZ8FIZ0/vFiF+DDrtEZ08=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DJJvW5PEMB1qs5Mtek/16g/JnmPt9CmJjE7Uu3yDxuMEd8dQGsOFFsNLXsMYe/EdC
	 iqEOpfl74zoy2btKntuyskCwXHqb1QziA6gqsLHxEos6514SBiNUgTVTh6gAssbIFt
	 mX0BfVGqYx99AlSQq50SEso4ByHi4Wl2mDMA1817AOvP7lbGnzuly4lQeWJfoyqsoJ
	 fHAPdXQvq24AdjQRv5e/AHScCdcLFYjnzQVUHebL1fqlqYQpg1LU1Hw/wr1mqYSMiH
	 4CDJUKP9Sf0cYHlz89pRZA5pRuDslmiTfDPZXkFMif3dyV2LD6r3xNxo4MP4lnuwWu
	 2OkTVnFdIVO3g==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 8220940B15;
	Fri,  3 Oct 2025 05:36:19 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org
Cc: kernel_team@skhynix.com, torvalds@linux-foundation.org,
 damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
 ngupta@vflare.org, linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
 dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
 melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com,
 chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
 max.byungchul.park@gmail.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
 petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
 paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
 mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, chuck.lever@oracle.com, neil@brown.name,
 okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com,
 trondmy@kernel.org, anna@kernel.org, kees@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, mark.rutland@arm.com,
 ada.coupriediaz@arm.com, kristina.martsenko@arm.com,
 wangkefeng.wang@huawei.com, broonie@kernel.org, kevin.brodsky@arm.com,
 dwmw@amazon.co.uk, shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
 yuzhao@google.com, baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 28/47] dept: add documentation for dept
In-Reply-To: <20251002081247.51255-29-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-29-byungchul@sk.com>
Date: Thu, 02 Oct 2025 23:36:16 -0600
Message-ID: <87ldlssg1b.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA788C000D
X-Stat-Signature: ab8wd6wiyd1i63319wdgyraez1nhxx76
X-HE-Tag: 1759469783-831347
X-HE-Meta: U2FsdGVkX19gvaI9e8ftlCuO6YmSm/H30RdpGBTSh0pgk92yv0kDlwvbq337MEE4uVMOLBSB+2jmu8CDHLJBiFu0IfRedXcOHbXJUM8h4IF8qSWT8EuQHANq5YuDzezCECXg00L4I8Qst9NA4IhDpH5pQkJQY0iEll9kLp9lfhQkQWvCpGrA2tkfqQJWrDQwPYK3UPqH/Ru/7wNcvLwPc6fEHorZT+62UaPgOlaF9Ojv9IKJjNmhgdKOCdqierkSUcXgM/d1Z3sWbNU1fCXqoUVMf9T1Uhh2ZiNDqceoHZG4C2INqp1EopOG9eJ4zB+z9psTp9wznouY/FINKAeRqeYg6PIhyuNDtPW1NjS+63F7fluaBNjzWYSsp0kR7cdVZHV9DlyusyTux/LnjWqLVwZ0TJtzK3YQSAeCJP1R+xC4wSFmR350CJcrgramCQwM/JedcCugvXH6VGJyY2hs/7dPx6Psg9shb4sM6AJEHVqCFn1sOc34aeauZ06U2NCYmegMve1Fpy/dODdGKHolLAkNwQ/IjIKIhI9rLghz7G7cycCdMlWti36FekbdxiO/+/9wmpi0T1E/UQU/pwk0wDwPppfECFpeeROtQT4F+iwl+VJgAxx/5+OBy4u8MWmpp1mUVEPF0zu4qRRuvwuTKzdLPEg8dIWNJ/hwfK25MAfK8Mqr8kldCW2d3PQlVWCLIi9pG35jdy7KGbWsjC3GdYj+pnx2Gh67Mr6s9+f4J230jdEsERDI2NBqyDrrAl2NDsvLwTnIVnLKh3iDZT5A3qC42GPuvgX4vNAsg4YJV+NHsURKt4RcyTtWFL7qFSmZDEUBqYD7Bme2jlr+ourKfWFIXG5QSngx/mowxtL+vnwdC8UHNFlZcsKK4skYV4+nldO6bei09+7W5mUForTj9sBlfkZ6GO912nDF7oPhqIFYjqXB1dJkl8ZG8+QMoI3o4ZH1vYfgQoSk3QA3s6b
 dEgZ3KqX
 kHv1iStOVn0sc8lCBt6Rqfo0Y/xj6HtvtcjQP7GduLrXpDGbf+3x2cbeJRNb0q6sKC39SA9y8VlzOTlsb3XQdywfyLpHslfqurLr/uXlHrflK/DVMA+nq+hW6ZzW1Cb+gNPhKP/7XTJpuy9hml2MCFKTwB6n7UPRUrRogOygf3hT/azDJEYxR9gGVEDcOJgkO8AhcX7k6uY7iIy6lrbWr2zTGw+GevALLwQ28sYRZcbwL19wW917kNJD+R9y8760NlZaOTFyGRxL0EbXHR2SmQVUS1VEEZ+GcDpgtzZB7vHl+zDyVeIpFiqlz2WAj3PkMnI1hgufD3FP66oO+WgWNnIIH7cVhB2NKNrLkMo7lOkCKPUMYKmvvsYa/czVwC+TfOP+RBO7PAG1nyMNBNkyKuYGxUdUw+8kc3WCIzGRAYBTsj1/ALbTqnT1YAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Byungchul Park <byungchul@sk.com> writes:

> This document describes the concept and APIs of dept.
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  Documentation/dependency/dept.txt     | 735 ++++++++++++++++++++++++++
>  Documentation/dependency/dept_api.txt | 117 ++++
>  2 files changed, 852 insertions(+)
>  create mode 100644 Documentation/dependency/dept.txt
>  create mode 100644 Documentation/dependency/dept_api.txt

As already suggested, this should be in RST; you're already 95% of the
way there.  Also, please put it under Documentation/dev-tools; we don't
need another top-level directory for this.

Thanks,

jon

