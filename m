Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A7ECCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E476D8E0079; Mon,  3 Nov 2025 07:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7DB8E005E; Mon,  3 Nov 2025 07:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35218E0079; Mon,  3 Nov 2025 07:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1BF38E005E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:40:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9659C1363F6
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:40:02 +0000 (UTC)
X-FDA: 84069253044.06.D07AEDC
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 244564000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:39:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=bTzr4D7Q;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf07.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762173601; a=rsa-sha256;
	cv=none;
	b=Q7apVN8NcvwneacB2rJtr4e8dEymrg/8BVjlW9h8bfowERPxrc+UgkDeyKNeDMUh5AEAkW
	WsTiz/ojXetJnztPtW5BjTTRG5uehiQmhFDVw28aM4WxOjDFF8r5D9d//3fc6hOElg+Ojn
	Skp+8vAjO2ke3kZNTSHTPOW+qviyKJ4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=bTzr4D7Q;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf07.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762173601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFLwKgwx6WFvJkW1SsKMkTkIEWPqVqozlHZeum7DzeM=;
	b=Cq+n8OrxUjLdRwjGWN5AP/o7iJcUhFB7UrQJryhvXhXrASRQT/ebCWtf9/4v5hDVfoSZ//
	6LMxq675EhCBB3CwakxvY6L+WMKQMorDw1eC6rfMBLh5O90ipW9HTBmmiIwZfjljGA0smB
	FuUAmSBy9004WtuXCru7kgCzQa1v4qs=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 604D840E00DA;
	Mon,  3 Nov 2025 12:39:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KtrrO9iIlOm3; Mon,  3 Nov 2025 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762173591; bh=FFLwKgwx6WFvJkW1SsKMkTkIEWPqVqozlHZeum7DzeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTzr4D7Q9+R8M2HmUNps/SjaU1a4dLaSFPp04M573KsTmbE0ij51zExSOukKSk4S0
	 DP94WNtHHPKkSinM4l8W8pf8mQ7AbLqEdnghTE+kTAjGl/QPTDihnlr69s7/3LjOz/
	 ZY92w1g3PJH9Pg/MKQY8wl5LZfI+VqGcSC6Lqp/T4m0mBf6DtpObIeSD1ONlzfQolG
	 RIDo/NMQc9wKm0/OGVAbu1G6ui4DsAWKh89LlScXzVH9/lAOsipQEOuXLYjkCFUG0c
	 Br4iUhT6qLiLZpvbca1ivrqE4Z3yq2RTAsU6sYT3mjZ5W2wilHvFxwK3EEgNVhDp9j
	 /b7xfTr8WLRBwisU9zbd4sJbafD15zbyV+FNUDW+Hc8KS1AxxZtDP2S0htntKOEswf
	 UXAXHompzT7Na3DM6/uzbokyfnJ/B7T6bPk+5HDmZs3R0XgWEsmT/LsIvAAuXhOI4+
	 A6fKJ5ZOZD+Xx86G/jTuyZ6jvVjjZPJwsTXsKlpwfIgWCW45a18KsKc+7KATcsgasc
	 FGaSbQm98KSLWWT3nKQ8ZO2gYtrJAbrwarUAC9DeHJCO5WEH2ueYYQ4i79u6+NZI9T
	 Ho43YZd4DjmHkb7nsGe5S2FaqtOG91C9pVK912aY0UpHX0+byeWKxeNE7v8JKYpwpF
	 f+0t9hMU6aTP6YzxBKVDzOeo=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 4B2AB40E01FA;
	Mon,  3 Nov 2025 12:39:26 +0000 (UTC)
Date: Mon, 3 Nov 2025 13:39:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: David Hildenbrand <david@redhat.com>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, luto@kernel.org, peterz@infradead.org,
	tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-edac@vger.kernel.org, will@kernel.org,
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH 2/2] mm/memory-failure: remove the selection of RAS
Message-ID: <20251103123920.GCaQiieAtEGz1nspWZ@fat_crate.local>
References: <20251103033536.52234-1-xieyuanbin1@huawei.com>
 <20251103033536.52234-2-xieyuanbin1@huawei.com>
 <341ff738-255f-41c7-8b23-48aac4cf51e3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <341ff738-255f-41c7-8b23-48aac4cf51e3@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 244564000A
X-Stat-Signature: 1jcgc37dr78zkhtj7yn9xh4f7qjh87up
X-HE-Tag: 1762173599-556039
X-HE-Meta: U2FsdGVkX18RJzmSs4qDEcJmg8uiRM3zr4S6qMNuNoOKTukzEa5CSh2+Vo04o9COIbvAw9nOx8hkwCaQ7PW6txFU8SbcxqRolgs+m/sMa7QiTZ+P+qvDgyOJ3uCoReNvXFGMC/NMIuTn2M3TXjm8eQft1AKb9Fpm7IEX2Ld7D1JDNydslqNwSi2VAaBk0Fs854WyIcysUzToJkXjwf5Qa54jQ6owQM2CzNx4+88+YhA9rRBfX8xYw0mGHbdS27RfMgoAU7xdn//QLRtlU6G1FYNYPXWygCISSvpBXVDbHx/LzWiufLHNuPtuo8IY9P1xHOhvcoqDXXw7FugPQMZvvdYAEbIrDj/lqMEopSQbkiEGahA8PWydobYmJsmOJoAGUOliBm5EixzGZ3XjdrpRmvPzwDOQx7yS074f9j/H9dmTnVjmmJzOEmAGWgzw/jFDB6a4qO9Fm54MHgUgH6Rjl9lBkARyN2Q76RsM/snIwZ4oNnDJJs/JL8vAncjWZjxo30LLdSa2FMW+/hUTxUDraVjMy3lg4CcUGnbYVr6YNLeO4Z3uvt9n/kKG3Bh841HJQIOaBrZ6u2f2SFBNirXHhk96AOpzWg+f3G3pXsEwbrOq8jBW81ZdYOqsimL/CEp1vzINpAeDjVB5mLEhgGWfBCpn5WQ7CncYRIrksYfVmyVStk9vOgMkObv0lViksin0011XG9wfDRnw6bo4GR8jhHCWaLvdKra0COXkjlUB7L3kighaXYPvR+K2HPPNBfbf3Frzkpd3cRF1KrI3nj4BSUrr6RH8c60PD4dQSK21fkmRd16xq0D0ELp94B4+B/4qavQbtMCt9t2JqMa5nghS4/HT7pw28IX1OBXsZ6/lPYzYUi2LAlIjidHa93EcX53O7udZn3zq3paHn0IWZvIsvgYT4vbwcasaz3el1r2lKm8cRbwqsbqM5VKH/8yBTzJT09NjwQlouZ4F2W4ld4L
 bpbuyDwE
 bDl1b2bxa1w3B1eCm7VumNHkyyuuEFWy203sXWVo+VigUQv7iEPOvCou2PRiQBui/3qf6uLg0CTXd7UMBPjj2gL6gPmZ1wL80fNlYB5FrcUtO03VpZ1pemNDoGj5N0xOMCUqehAZLPKa1s/PIVGTI/U65RrueFH2gKhCHIZo3/s0tYK9ry5DgwkDymz8vie+i/Zug9+hSiG8UGySHN4VmYCyy51PavpSW/z0cjtL/F+O5jWNySA3C3/NknBCOe0luP+2RFDAm657HyxujUgLW6B/e6Qc54bEOYVR/dUxy+B5r2zE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 01:15:58PM +0100, David Hildenbrand wrote:
> I rather wonder whether the memory-tracing code should live in a
> memory-failure.h instead.

Yah, move it pls. It doesn't belong there.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

