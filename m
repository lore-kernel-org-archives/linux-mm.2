Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C41CC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245A96B00DD; Fri, 31 Jul 2026 05:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D126B00DF; Fri, 31 Jul 2026 05:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133FE6B00E0; Fri, 31 Jul 2026 05:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFB516B00DD
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:11:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60474140385
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:11:23 +0000 (UTC)
X-FDA: 85048503246.15.BB704F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 957E9140011
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:11:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xzmx/pVS";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785489081;
	b=mVSqHjGjWqxd114bUsP/Avtc7UGq+oI/aDEvH9izfaL5zHp3z0/WIAvcjTINiudUXuQZ9z
	RaonchGrAvGgeUIIbbgElOkWmpSpSTVB34GwhvA4q1qfIKVVfrnLdx9LE7tBU6ncA+EJdm
	D65g3q8qS5CW/PG2iA0a5DheW5tLrQQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xzmx/pVS";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785489081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+7sQcw4Lp6aF6ffuo506jNjtHX7lPWs3KjiPfetUEY=;
	b=3btHDqTjFEhnWvAqNq6mOVNq4Hx6NFvaEYAVghbP0YOsGLqywxCcKy0Aoib6OwVAyD9TJE
	xYyw1+AQK5MbYLnr/GT0BURGAQH6sN5MTyzhyEyqquVZUyQpnXFsMyiEP5U8OhBev02jD2
	pG3bP5fuRojGMY3HhD/JLixOYf9X15I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6128419AC;
	Fri, 31 Jul 2026 09:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DE91F000E9;
	Fri, 31 Jul 2026 09:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785489079;
	bh=C+7sQcw4Lp6aF6ffuo506jNjtHX7lPWs3KjiPfetUEY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xzmx/pVSE/7R1+T0sqKirdyPQ61hNwa04+ghaJg7lWorkJKg97FfeiftiOgnJEXhO
	 zAV3XxG6MG971N42MC/Vrb5uWJ5FTicQ0JPVjTol9Akw0H9kNMRpt27n3FmYm6Ku05
	 AAEvEaZjCKALRNF8og5uXdwyaNd5TXn9y/HjBYt0rIpRYrDzS1PmLPrDt2HgPkbqJ5
	 2NskUXcSxthaCA62XVzTb+DqWrmVOoQBVY7WuhH+rpMVxO+uwD5fKcSlVLHV4xeHC1
	 ek+Yx3yPYDBZw8SRwZz2mZwtHD6kh2bKPex9C5MayTKPvS2iRK2qYy1oIM7xJevNgB
	 geeSpCpjLJ9rA==
Message-ID: <d9236dc0-3332-4fab-aa26-e74d10ad0cda@kernel.org>
Date: Fri, 31 Jul 2026 11:11:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs: ksm: fix typos in sysfs knob names
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
 <20260731083526.3953421-2-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260731083526.3953421-2-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ius9c8a5xhtsyoxhwxjahcfnthdbfi4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 957E9140011
X-Rspam-User: 
X-HE-Tag: 1785489081-532851
X-HE-Meta: U2FsdGVkX18P4YvsNMGPC2/EMITN6QPQJ6DzGza7BD6QbReZ0+pUA5dCXqE8YlitAHJRC02ajbFByVt8Ph+crMR2diH/0W8ep7SVLW6pTRwUBoukWzjD4LUNgMhPoCQmOO9KWkzVBlUwBVKy248WLKAEu2yIt7T6tgpoRRLs+lnvczB46+ahIo7xqAflGeOjCqeeCzzNM6V41DKAXKit+DSLyU+m+rw/1Kd9u/ChP/KpZZ1LkW6ZCLjkPRXZBgOoURpo64Meo2hN2AIuYW2ZIaf4G+SCaxyFsHITbI1tXVsvxYURnczNRvduyBFt7YtDLFRNLa+0I53F6vB8mDpFJWbDPs62kwMYkqJCvey2Y2CcBwT3VYWHFUvfZo3beP0AkmiLNaP9FfgMz6CM6iFR/eoKnv+a+yApiHCJ9nQ46nWOHCkCDcW1ePz3hU6mKxVInPecBrjiaMCEOFJEZ9eDQPdhRlUzo4Ekv5Ec0Xe5xCndb0SC8UYfscYjS8KBviihLH4EjVaKW62b3mwxlVWtH+e+xtQtpVD0m8JANyVTmkGOfwUaGvZmiMr89KHxZQgyUFfk0A+WWOWUHq40gEnpszTMO395SvWu5Q5HoJ0QmpWXMBkJu3vbjRMd3UmbE6/s18eNM6BdKvJwRUyFLtzFlLm6HWetGotwMWPmKjivbdcmaoh5XmI0hgF3dh31Qzqemcr1Wnn1dMXIjJlxsdcJzY4ePcAu+TijC7wSoVnZCdEG78yQN6gUaEISVOAvibK0UtWXO7y6J7fm15jOz2pDcJ9c5V4TC4OGfzfHDCvZ0rxCof6gLeg6SOLmf9tVYuAAS3GB8KNwSWQyBSa0qv1t9RhfRXeUk9X9vP0SwL8kXGB4yC+J9z6XLNQZ38GITBnu9S7AlI5s8yk9h//bFARwECS2MPM9M/H/nvMoHXqfjDKlX8x0ix0E9WxwJ5idxAGEpeli44XcYs003Fq2ko4
 K6jP8EWE
 GRq8rwM7G9H+bpKfT3gXfBwWJZndNPWZCzF5/3DwkwrivlPdtErDrHlHotgLy001azxUQf3KWUxVrebfJMV/h9F6alM/iCkU7n+Ch+wGEjwqvexBHzNOE89DPVbkUAPESOgW7ZFSsG3Kx9anO0lWcSBymVWUxqCActXu55109jFY8psIBQ3XIBlyQ9WT/EVninPuFiO+f5X25O+lwCvYzMgXy74kr6L0BNf1ckoR0JMf3FtjU2C6ch9K7ask/9hGhRreOwozp3sQv29K+e7EwHc8iUPUhMo+Q9oA+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 10:35, Jinjiang Tu wrote:
> The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
> "advisor_max_pages_to_scan", but the ksm.rst documentation spelled
> both as "adivsor_*", fix the two typos.
> 
> Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")

I'm not sure on fixes tags for documentation stuff.

Change itself LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

