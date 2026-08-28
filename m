Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48B4EC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 15:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF2E6B008C; Fri, 28 Aug 2026 11:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FB56B0092; Fri, 28 Aug 2026 11:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29896B0095; Fri, 28 Aug 2026 11:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85EC6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:10:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2281C1A03D4
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:10:21 +0000 (UTC)
X-FDA: 85151014242.01.F485967
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 77A10100002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:10:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=R1hTVSbR;
	spf=pass (imf14.hostedemail.com: domain of artem.kuzin@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=artem.kuzin@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787929818;
	b=8QzgUFImzCVFT3sX7lBXCuwlAU36xM/qBKHPuHByIIg9Jj0d9yGUn3HFBulAffIDJu3Y1l
	gNV/36/cw5hmumituLmF4FNP2mFkoCpjr1Qn4wFoaMDyduMrucbAra8Xa2PvKuVEKVcPnt
	ttI+trHnXjKMojGhlLbxxZf0b+bYIHM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=R1hTVSbR;
	spf=pass (imf14.hostedemail.com: domain of artem.kuzin@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=artem.kuzin@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787929818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4HXdOnEjO2UWQf+m+lpPrXMXF/LAxWYvhtSnXIOjTE=;
	b=Syt2qWm9+p94KlGhXPp+zj1IHOcfdWwHDtxqaj2wMcx09TTaxN9+yNIYbZIws4bopYzkwj
	uKRKhSLJUOAnN1gOBcx1OubkCqre2j90aHXWtwBiCX6Q6+8RQ/JLTnGjIg9eeeVirPHsKY
	yUMkzaNCb4vudNZ5vEE4FtEOBkQT8P4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/4HXdOnEjO2UWQf+m+lpPrXMXF/LAxWYvhtSnXIOjTE=;
	b=R1hTVSbROxgMjucOhjQ77G4yaqYa014J8x5xfqFvl2dIoIb+mAvQcLkYukrhRy25n57jqSc/w
	uzhDI07JTYJWgTsrxh+FxBZYK03D6HkkR4bKKKj3UcHXLSpPkOSDePNFcmRkmOSnhLYk7Qd7CYk
	yv4xR7jpwTYeCorKcyJGeUY=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hWhd20y5rzJ46Zq;
	Fri, 28 Aug 2026 23:09:42 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 410F440570;
	Fri, 28 Aug 2026 23:10:05 +0800 (CST)
Received: from mscphis00060.huawei.com (10.123.65.147) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 28 Aug 2026 18:10:04 +0300
From: Artem Kuzin <artem.kuzin@huawei.com>
To: <david@kernel.org>
CC: <akpm@linux-foundation.org>, <artem.kuzin@huawei.com>,
	<catalin.marinas@arm.com>, <cl@gentwo.org>, <liam@infradead.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux@armlinux.org.uk>, <ljs@kernel.org>,
	<mark.rutland@arm.com>, <mhocko@suse.com>, <panov.nikita@huawei.com>,
	<rppt@kernel.org>, <surenb@google.com>, <vbabka@kernel.org>,
	<wangkefeng.wang@huawei.com>, <will@kernel.org>,
	<xiongyining1480@phytium.com.cn>, <wangyuquan1236@phytium.com.cn>
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Date: Fri, 28 Aug 2026 23:05:06 +0800
Message-ID: <20260828150506.1016096-1-artem.kuzin@huawei.com>
X-Mailer: git-send-email 2.34.1-openssl
In-Reply-To: <bbd45126-8d43-40eb-8a69-a7fb6d2378f1@kernel.org>
References: <bbd45126-8d43-40eb-8a69-a7fb6d2378f1@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.147]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 77A10100002
X-Stat-Signature: tydg1nesj1nkt67jb5576cswty411u5p
X-Rspam-User: 
X-HE-Tag: 1787929817-92349
X-HE-Meta: U2FsdGVkX1+am8mCRaFDK6ehVNua9FZKdJhCzl5NCMgyfJ16KX+DPjPqzawq0K+LDNnA3Dexj75xayR6sU0RiYy5Ug3Pp0EXssHsA/vaSNeOb0+TSw87TG/3YJmaQreWCmLPqSiaqZpVeu/39DMHhYSKggyAcXs4tvnDRYscmblHRXKNOtbY/XjzEPGPeQ9jEQ2ln/MAVpV8XjdUHy0C79b4KHBoNIqnZhBJl+UzOhYPZzdcXb/2IK0W1SSKgMcYOImjvrOl0jR5lwrmcDV/r9KHvFNU4a3kaXp6qlkPGjGFSMIX+X/HGByN41gX0tUwtLSXuwZrAwSUczWG/tkLrvogCL1mLIIDZFLd83Mu6Ua4yMgKXY4GklgFfesJhn0IMs5x3BmhGMFwWexSsj9rKTJUU4RXeeGoVrPoNbb8qT42zmK6q+2DkXswgis1IoaKJwr9+2wj3g7ikadUcOF1OiBrxPJepvoTeGeWfu6MOMItFkrnqyek5VLm9uMAMjNyY38s9XjbGw8tuEKtLy8vjNRR262Qs7f1mjLtpfFcFm3BiHofWWHokhKk83tgoXO2MttMXAZnxzGSNDdTzBLgYX7+/I89YjV9i2CdGohHaLXbKrrCpwB8VFW4H3y3mqiyz5ViNicf5J4GhyxVCjaTDWI+Fx+UznPlsaeKiM4YT3P7Gdc4pAa8ZQh+KMLR6DDNVq0XQgL0n0wN2Y3Ysb3sbiOA5eK21aK8KhLDlPwsYtAYKgnyXXKmy051xX13KctX2ey1+MDshV0MFpCMd2epwhiMbzPBbffDGuNUWiJ1UzkkfG5Awx5kMncz8jdctqjXhbNotm8k+8gOqnTSoQrT3+XF9M581I8Mz2vSJslks31F8tr05RmPUwgrQIAe2BsjNfonpws9N8UtWApeX6q4zyuKVwig/yYQ5hKrQcNzorBXFr+InXHpCRNfm1Oz8zOCFaetTXCZ+J0uhraT+cD
 bVAeITO+
 nizOvPsWnX4bQXuxAzjPjFoVgjRjPAOHsrooDL6o4rknK+D5GV0OUtxOuIHQgqNsOM0ecilnqEcl32jUkscsJzkAfKkuPcc0nDnhxWKBsS7zoeyDQU2J9k8pJLXNB4vSayDGXLxQK8gd7/psKOQehxU86kY8CFWcnPLovyhRC+kv3oWXeVuuGprv9RVAjWzgO175bV3eSEfozEhm2+P5RgOpW2vfhfwhY1IoseNPZBrMv6Bn3i1dNLT9YcTwXJiz+QjSibRPBatO91KoW1NR+FH/cwKuBgywOXCMsNHgrI/W+n72g9MrMTVuWbn6lH9z9yL2kGYIRig0StuoSs0vPNiAB0wBr82XFz6aS1gDaIBzLLtqjQgSkjWR1wc7BVhnfAVi76sJO3SC5XMkL6yf4LwMsJsE1kbYuWk0/g9dWTyWSMn5xQ6l05IhzeWJcXZ4Cqb6/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On 8/27/2026 10:04 PM, David Hildenbrand (Arm) wrote:
> [...]
> 
> About to go on PTO, some random points :)
> 
>>
>>> [12] - Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)
>>>
>>> As of today, none of it was merged into mainline.
>>
>> I mean :) maybe take that as a hint? If a number of series trying to do X get
>> rejected by upstream, that is maybe suggestive of barking up the wrong tree?
> 
> I'd have expected an explanation at that point why previous approaches were not
> merged and how this patch set is sufficiently different that it is worth
> maintainer's time.
> 
>>
>>> However, after thorough re-evaluation, we were not able to observe
>>> performance improvement for the x86 platform, so we have decided to stop this
>>> direction and switch on arm64.
>>
>> I mean, why? You should provide details here, this is quite hand-wavey. You are
>> also proposing core mm changes for something that seems specific to unique
>> hardware as far as I can tell, which is a big ask.
> 
> What I consider interesting is "after thorough re-evaluation, we were not able
> to observe performance improvement for the x86 platform".
> 
> How confident are we that a thorough re-evaluation on arm64 will not similarly
> have the same outcome? IOW, what was the problematic part when doing the x86
> evaluation, and how was that avoided when evaluating the arm64 implementation?
>
In the x86 kernel replication patchset, performance evaluation was done on a
relatively old platform. Garg Shivank <shivankg-AT-amd.com> evaluated it on
AMD EPYC 7713 64-Core processor (dual socket, 2 NUMA nodes, 64 CPUs on each node),
and the results were completely different - no performance benefits. At that time,
I was unable to reproduce and clarify the issue because I didn't have such machine.

Also, as Nikita mentioned, kernel replication on x86 machines introduces additional
overhead related to PGD management and user space updates propagation.

As for ARM, I remember that the guys from Phytium published relatively good
performance evaluation results. [1]

Yes, both patchsets (x86 and ARM) are far from ready for upstream state,
and there has been very little feedback on them. It was not completely clear if it
is worth continuing with the kernel replication idea.

[1] https://lwn.net/ml/linux-doc/ZbjOZ1YOQUBxftrR@shell.armlinux.org.uk/

Cheers, Artem


