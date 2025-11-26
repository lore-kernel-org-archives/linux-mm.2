Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F49AD10372
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 02:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869E86B0006; Tue, 25 Nov 2025 21:29:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B096B0008; Tue, 25 Nov 2025 21:29:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730906B000C; Tue, 25 Nov 2025 21:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD526B0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:29:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2060160A15
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:29:11 +0000 (UTC)
X-FDA: 84151176102.06.456F0D2
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 41B651A000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:29:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764124150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5GPXSvjgkY86vSht42bPWwETJvI5ym4a5Qokwd+4hQ=;
	b=E4q28XaySOsuZgM6BzZTdCBUiRnuAXUTyOXfG5LsLWUDifiX11/Il73NEg8Frxwcj6vh8l
	zsxpUGzABB9srjnj+8AbqnU5y9QUzxZxKNR2xVqVy7csvhNDUlG4u3uIaskAbtquxYJqee
	a6z4DDzqbSnv0I9sIAyfVKB/d4AtLmc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764124150; a=rsa-sha256;
	cv=none;
	b=X8ls/bhzLYvavTpiu6hSoIdUhbthg8CnZm2APyr/5JSHm1wzZ+KuC0EC6CltShO6rHvYwZ
	fKu1DHren19pWo7xVPdq2kn3LzkqRPnzhrEf6MRVbR47yd83A2BT6hdIe3dHpZbGjiX9II
	e2jKKi5CQE4Bo8zqqPGJG4ejrvpcwv8=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dGNlK5tPnzYQtkZ
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:28:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 064261A17BE
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:29:05 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgDnrxHvZSZpoZQCCA--.4828S2;
	Wed, 26 Nov 2025 10:29:04 +0800 (CST)
Message-ID: <def579ea-2886-47f6-94dd-71504705d545@huaweicloud.com>
Date: Wed, 26 Nov 2025 10:29:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC -next] memcg: Optimize creation performance when LRU_GEN is
 enabled
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>
References: <20251119083722.1365680-1-chenridong@huaweicloud.com>
 <e114418f-a71c-4538-af5e-4a39bc42c04c@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <e114418f-a71c-4538-af5e-4a39bc42c04c@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgDnrxHvZSZpoZQCCA--.4828S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYV7kC6x804xWl14x267AKxVW5JVWrJwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kI
	c2xKxwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVW8ZVWrXwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 41B651A000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rj1u9g7iggo8iw45saab6jpxq9a4mj1r
X-HE-Tag: 1764124147-644492
X-HE-Meta: U2FsdGVkX187bJ7XDjDrne3wqRgYXLRHbL3nkSRJdq1NEcF87j+rVdJ3K5gQRiiV6015rDSreoZ9pTo8GedD4cPxYjvC5jU9jigJFpG2G51G1k4jN9QgWY7pOYTH2Mjc3zutRDiLq++p/CX+hY94ViLVk3EMb8+9PiuCFpNaj7Kx98k0Kk1vDgFjBHnKPkshIuhYN8QSnVV3L/cdm0vo3QccE/8FnzqT1nn2cvqLZPjuoUw0eXKMUVM34KeBW4ij3Yf0exvvNNCjOftFAI1Aqt/fzWwZtxC9JU92i5yPNC7CRjstnUqISlniUB3PuPwLLnwaspIA+pMRjdrA/lk+WCeViKQdIqR42y0ZHH+3j763ra2hcwR5hj8+fzQILyIbfsj5Hr3CyR9U6IByh44gNWd4ykMhWkBBt++EWDLvflkyxTAkNLgtZkz/lO9Vf0F7FPoP4hCF7464QuL9gG8t1ETVjf9GypoqGXUPIRHhISVhVYgvKDSM5F1CAvY7TW8n6JrKSOzbOUMm08kywTD8qAcdWwAQsCFR1FeIlChlRYmMDBFIsku4e7h5+84KNJEAb5YAwUzOVCcfAEybPZydLcoTR9zGbjAsZSC/zgJbtMqH3bDkrySwCUyu1Dym42B4cXFNQfyJVWGHZ6W74xUVoF45DAhKq9Du8/nrYHEFW4pAoyM51MR/twsLQJKLlxw1UeqozuLqkMqgUPOfID1UaVfuZC0jUi1lC0yHbD97giztKL+xg0An67qzw0hFJiq24mprQvANB2EZISi25qVB+iNjwwLIkfGeufY6fzPGcGb2d2n23ncOXh6miUE/HCkHnXb5SlEndjlHpa9c6nQ0pxFpCw2czMEjbOUpuFtfdmG+rcDTsyQ0XmJtuviRNRI7lBjSy415rJTA5zuWH+GvCFhEoBB/n9bbLwPjA2cXzW76WnXV9pWwcboJ1ULHIBBQKO3Lyx5P0uLOYAYsulT
 AgqXK1sH
 0Z2+9J8Vi/3y+mtIJ+UFR2JfZ5oLLfgTTPwjmYKFkGfWNqnwoBcBk7ChkxGoVykTPd5jsmfnVLoUmBsmnpxuKLAH9lSNZEktnd1tNGBv7HWgfTduZmPJNACpraUCKkqRtqJA3vX5EqALQVsEHrRO9OyRap8b1zwb3cg5I7+HE1HIJvU27qCMpXIUv81oYyqlPxAVgUi8Ue7EP01uHvPT536F17g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cc cgroup maintainers

-- 
Best regards,
Ridong


