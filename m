Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51248D6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94EAA6B0088; Thu, 18 Dec 2025 08:46:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE666B0089; Thu, 18 Dec 2025 08:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D08B6B008A; Thu, 18 Dec 2025 08:46:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4196B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:46:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37F4BB6690
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:46:57 +0000 (UTC)
X-FDA: 84232717674.23.D982902
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00D13C0017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:46:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766065615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K0Z9hQcHON2dWbNUaNHA6dsiPLww4R+qQhdReV3tm1U=;
	b=C+Kg/13RnJrOL6zDQdNmbA4Maa2ipn7urqwtuIevbM7cGmZFYZSKM1QmDBXv3E4urfDyDO
	dZoIV7o8WjxLZwQoiportCIJ1mdBmQlqZ/pAzYB6GueTxMihaeiBD9PmpZ7Km0Uo2mrPr3
	avkDIhi81kRkFEBeOyKcaI92zPQhhOo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766065615; a=rsa-sha256;
	cv=none;
	b=OWKiycULbEoqe6Z4YoX1pFwGysLFI57+Dr/JAKYHSbOcH26Bp6VRhze7N5jmpWJ+Q4NMf5
	jbqlTEqpn5VTsocPCTGvppUy+LjC1vHSb5QjbK2Ijaq2vUiUleYvwbn58yc81WJfzLysnR
	mklPP8jghSD5TEiwojJEZeBU0SOOau4=
X-UUID: fb8253fcdc1711f0a38c85956e01ac42-20251218
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:91b3d06a-4a3d-4be2-b535-ab4fbedbdf2f,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:91b3d06a-4a3d-4be2-b535-ab4fbedbdf2f,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:688db8609c1d648c2f6fd5a0c4ae6102,BulkI
	D:251216071650TNWFWTE8,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fb8253fcdc1711f0a38c85956e01ac42-20251218
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 143233166; Thu, 18 Dec 2025 21:46:41 +0800
Message-ID: <2c8dd0de-e650-4a74-b1f7-61ed81c03d26@kylinos.cn>
Date: Thu, 18 Dec 2025 21:46:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 enze.li@gmx.com
References: <20251215231639.56448-1-sj@kernel.org>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20251215231639.56448-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00D13C0017
X-Stat-Signature: 4njkictar9qtakq7uxa9ihozu3e8j4zq
X-Rspam-User: 
X-HE-Tag: 1766065612-554243
X-HE-Meta: U2FsdGVkX192KX93F6ztjKOwxVYHWYiHCuUuEzNlAnDi5W0h+ulA50BPmI/1881cdu+YnETskNM13sXq+ps5Ty2i2q1BByrlr1+RCBv8OYAKY6jJPuBYG82MAtVOhp0BIECZ5yqaQF/hqx4E7hEY7wYvluKQAnlLOJwbtN0dyosJ8Zr3b6vVAZ2KIl2HA0hy6WLTUbggZcTmtynKXdrE0icftnaawTy2ZgDCY6WfPeygGsYm6L4luSafuEyZksOX/yv96xkBCVCbBajgl6SDClZYnhLIFRHZ4owROXbMmL/l2f8PtitsBrCCHaRA5v54bJMU3dCFln8Bfn+hyph/S05WBO2YtPELKjUzOp/aWDs3DZ4jOgvgvRiOYrCsmWoKaCtcqUivGjp7rj2XX60HGlVGbZDCv4z//j4MzpeV6xBziTQU59ZXN6hW+FLROWMPro4pQ7jS7ZgbZQLnFy8wJ8pU2H9sjfKR8jU4JzlsIPkMom8O74HGFrT7FApObocGteh/HwF3kF8QNEEZ5V7RoVA+CCMhs0tpNCUWZ/74gcktunc9iE0Ubv8zypDOhOeR/Wh3olwnl8NZmAPwTI4R7XkC0b7+eMTuO0qwTAzQ67ffYUKZ/y49OSGvL1JTi9YUtI6jDLrLZaDXf3IwXa10y1mObogGlH7FP021X8H1w38Tkq0iZerHfKG33cS3QIq7orQpuhaN8aopCZvAcKx7vsUEplraPZwMpabfrLJiy0MimeZ5GqP1ADSQYQB+sX9Pt7m3tfOVBS4KctjIih2y6OW79dGnr3DqVQVMjTusSQBadX9gFhOGwx3HVVvBVBBLEBRT7bYpWcp8pnPTY6lL8cDgiQKoAdJLAz/wtBa6jGFIK3Btmb97BW2QMPL3O6ul2X+JdzsjS3YIaMuJf+Y12AGx8LKYY0c7o28+Y3EMpWHfyh4O1LXYoS4y2iUZ5oMHuyQUHK6ke5CWwHj4pxv
 VjIBQFe5
 HFoW8psQrECze0lL2j0ZwsNgjVtnth1/JRYJ6y/wo+DTv5nPZmcgOvL6Mq1e+kpTX6cd1Rc25dR1oxgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/16 07:16, SeongJae Park wrote:
> Hello Enze,
> 
> On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
> 
>> This patchset makes DAMON's advanced memory management accessible to a
>> broader range of users through two complementary enhancements.  First,
>> it exports the necessary DAMON core symbols to enable building loadable
>> kernel modules.  Building on this foundation, it then introduces the
>> 'prdm' module, which extends the concept from the DAMON sample code
>> (prcl.c) into a production-ready, user-friendly tool.
>>
>> The key strength of this module is its out-of-the-box simplicity: by
>> simply specifying the PIDs of target processes and enabling the module,
>> users can concurrently monitor memory access patterns across multiple
>> processes and trigger proactive reclamation automatically.  This
>> significantly lowers the barrier to using DAMON, allowing system
>> administrators and regular users without deep kernel expertise to easily
>> apply sophisticated memory optimization.
> 
> I agree your points about the problems and the direction for improving the
> situation.

Thank you, SJ!  Glad we are on the same page. :)

> However, we have a module for such use case, namely DAMON_RECLAIM.
> It was designed for a reason that very same to what you described above.  One
> key difference between DAMON_RECLAIM and prdm is, to my understanding,
> DAMON_RECLAIM works for the physical address space, while prdm works for
> virtual address spaces.

Yes, I have studied the implementation and architecture of this module
quite thoroughly.  However, there are certain limitations when
considering it for production use.  To my knowledge, few would perform
indiscriminate page reclamation across the entire system.  In most
practical scenarios, people prefer to protect critical processes from
being swapped out, while applying page migration and reclamation only to
less critical or performance-insensitive processes.

As we all know, frequent page migration inevitably introduces some
latency to process response times.  Therefore, the ability to target
large, inactive memory consumers for reclamation addresses a strong,
genuine demand from real production environments.

> Is the virtual address spaces proactive reclamation is
> what you really need?  If so, could you please further describe your expected
> or planned usage of it?

Consider the following scenario: a host machine runs three virtual
machines -- Machine A, Machine B, and Machine C.  It is known that
Machine A handles massive traffic, while Machines B and C have
relatively light workloads.  When memory pressure arises, besides
releasing caches, the system can utilize prdm to perform precise page
migration targeting Machines B and C, ensuring memory usage remains
within a safe margin.

The data below, collected from a test environment, demonstrates the
effectiveness of prdm.  After enabling prdm to monitor the two
lower-activity VMs (2316, 2284), I observed that the DAMON-based prdm
successfully migrated 5.5 GB of pages to the swap partition.

 PID USER  PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
2253 qemu  20   0 11.251g 3.822g  32.7m S 4.989 12.28   0:48.75
qemu-system-x86
2316 qemu  20   0 12.191g 1.524g  34.3m S 5.322 4.893   0:49.05
qemu-system-x86
2284 qemu  20   0 12.092g 1.184g  32.5m S 5.987 3.803   0:48.10
qemu-system-x86

root@localhost /s/m/p/parameters# free -h
       total        used        free      shared  buff/cache   available
Mem:    31Gi        12Gi        15Gi       5.5Mi       3.2Gi        18Gi
Swap:   31Gi       5.5Gi        25Gi

> 
> If the virtual address spaces proactive reclamation is really what you need, I
> think extending DAMON_RECLAIM for the purpose might be doable and even simpler
> than introducing a new module.  How about doing so?

Before developing prdm, I had considered implementing the same
functionality based on DAMON_RECLAIM.  However, I gradually realized
this would make DAMON_RECLAIM overly complex and less
user-friendly—especially given its existing module-specific exported
interfaces, which could confuse users.  This approach would create
significant barriers to promoting wider DAMON adoption.  Consequently,
building upon the prcl sample became the preferred choice.

> 
> And, even more importantly, why it should be a loadable module rather than a
> static module?  Do you have a specific use case that requires it to be a
> loadable module?

Yes, loadability is crucial for operational flexibility in practical
production environments.  Beyond some obvious advantages, I would like
to highlight a key scenario: system administrators can load the prdm
module upon detecting memory pressure and unload it immediately after
reclamation is complete, thereby eliminating any overhead during normal
operation.  Furthermore, it supports zero-downtime updates, meaning that
improvements targeting prdm can be deployed via a simple module reload,
avoiding costly system reboots.

Finally, I would like to add that designing prdm with an extremely
simple workflow -- load the module, set the target PIDs, and enable the
switch -- will contribute to the promotion of DAMON, allowing a broader
user base to benefit from the DAMON system.

Best Regards,
Enze

<...>


