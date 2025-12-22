Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A73E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 07:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77856B0088; Mon, 22 Dec 2025 02:08:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25B46B0089; Mon, 22 Dec 2025 02:08:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30B76B008A; Mon, 22 Dec 2025 02:08:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF7CD6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:08:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C8068BAB6
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:08:26 +0000 (UTC)
X-FDA: 84246228612.29.E91ADE3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5461D1A0003
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:08:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766387304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NsMkgYNu7c7EvYEyw4cG6okCrTxON9MqU5E0ir0PUaw=;
	b=bPxeLBY9/usfxMEHrIIG0Th7V/HPMWg3LOaVIuE2aMmQDAkLGskBmRZeeKAFJdTvGabEd6
	YSuUB7qYzICXgZJvjQS7HKdB/W62KL9KNeBLlTAno046s8NhM7fpVJyACMKamTZnZRPOp9
	E8nvBPsg2c/7w6h9wvCyu8MXE+9HT9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766387304; a=rsa-sha256;
	cv=none;
	b=B2wHJGJbxwSPKdYkG+LQ/GwC7JtsQ0q+DRaR6aAuO+s9ISkdEwIV1VrGzJndVbhphbVKDD
	NHLPbr2bawbfjTlSe//jafte9Yw9BQ4Sbvz93AdvqB6SVt6uoYVVMXdZZ6o0PpB/1iCs/G
	DxWZwktsK6PzuhXwDWxQezlF9AIwhbM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: f9ebe950df0411f0a38c85956e01ac42-20251222
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e579bbef-59c5-4e26-80db-5953b0f24676,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:0
X-CID-INFO: VERSION:1.3.6,REQID:e579bbef-59c5-4e26-80db-5953b0f24676,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:dbf86791cbbbdf22cc788d8b0758222d,BulkI
	D:251216071650TNWFWTE8,BulkQuantity:13,Recheck:0,SF:17|19|64|66|78|80|81|8
	2|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT
	:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_OBB,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f9ebe950df0411f0a38c85956e01ac42-20251222
X-User: lienze@kylinos.cn
Received: from [192.168.31.182] [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 733422008; Mon, 22 Dec 2025 15:08:11 +0800
Message-ID: <638d4c03-f7c1-4ba9-801f-18c860960eeb@kylinos.cn>
Date: Mon, 22 Dec 2025 15:08:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 enze.li@gmx.com
References: <20251219114633.41156-1-sj@kernel.org>
Content-Language: en-US
In-Reply-To: <20251219114633.41156-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fosroagnkc88ntyskc5tgn3c8h54g9ws
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5461D1A0003
X-Rspam-User: 
X-HE-Tag: 1766387300-139245
X-HE-Meta: U2FsdGVkX19VnxLX7XyVxpO11Iy1fTiw2b7rv47GX7l+JvgD7Ts28fcKKGjFEe8dUF6XxjO+9sF1eG4IVvgzNNfNUcRM64e/HGGdtxIUKdaiQFCW28fP7eBHqJex6ZsH957fQBJLYgpD53MitOhQsYVPWzbgB42AV/9FbvW1tVCHngLe1ij7CZAYzM/j4WIDFVAsIwTdj1qbvuhugoigOFQ3R3dJMnRWsLDrxxHDs34/7/ybdjRkJ9w/4mODHx2wOuSCLhKCfMeTu4FqVxMMQk3hN9OX+9dGra2tRVp1YtczgD266rzFnKtEIZQMs2vIxEnkYJsBcRDrvkX7pVql0E6noSh2EOWJa0geehRRs3Lou5DiCAd3HhfwYE4qTnFzLwVo/sdLSoNiJb7iqks84PwbifzmytTD4oX18/DMqDIwxSuZZHr/XrXvtfmgl+w6nfD8MMXjbs52DpT5yqkNLo8roS0lAU/9H5EHBDErPrkKKzuC6Td4GADWdGqlUxe3DIBJwpeXyz1aM2Z0z8uxKxBKy/IKYqlV7hd6wBBO7KuDjfqrKFcZQPLIHDEfbJtTUilbVXmiwuc973wcNyplFKSXi3seX0IvIt2D8yDVkbXaSl/Uz0LlQhUD16hBks/nK5e8wjuVIHXxzbVqkwzU8Mu0zGSwcrfV2K7aSnfwfeBmnf5kc2r2WGjkPvvhNbyAyO1FoLztQHhBLDnHhp1gj2fnpkVLQxR3NmICRFxL8/mnCUT7Jx4MHf5UhT3tWKRu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

I appreciate you taking the time to provide such a detailed reply.  I
have a few more questions.  Please see below.

On 12/19/25 7:46 PM, SeongJae Park wrote:
> On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
> 
>> On 2025/12/16 07:16, SeongJae Park wrote:
>>> Hello Enze,
>>>
>>> On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
>>>
>>>> This patchset makes DAMON's advanced memory management accessible to a
>>>> broader range of users through two complementary enhancements.  First,
>>>> it exports the necessary DAMON core symbols to enable building loadable
>>>> kernel modules.  Building on this foundation, it then introduces the
>>>> 'prdm' module, which extends the concept from the DAMON sample code
>>>> (prcl.c) into a production-ready, user-friendly tool.
>>>>
>>>> The key strength of this module is its out-of-the-box simplicity: by
>>>> simply specifying the PIDs of target processes and enabling the module,
>>>> users can concurrently monitor memory access patterns across multiple
>>>> processes and trigger proactive reclamation automatically.  This
>>>> significantly lowers the barrier to using DAMON, allowing system
>>>> administrators and regular users without deep kernel expertise to easily
>>>> apply sophisticated memory optimization.
>>>

<...>

>>
>> Before developing prdm, I had considered implementing the same
>> functionality based on DAMON_RECLAIM.  However, I gradually realized
>> this would make DAMON_RECLAIM overly complex and less
>> user-friendly—especially given its existing module-specific exported
>> interfaces, which could confuse users.  This approach would create
>> significant barriers to promoting wider DAMON adoption.  Consequently,
>> building upon the prcl sample became the preferred choice.
> 
> I agree DAMON_RECLAIM already have no small number of parameters, and adding
> more may make it look even more complex.  But, users may use only parameters
> that really need to be set for their real use case.
> 
> For example, if we implement virtual address spaces mode in DAMON_RECLAIM, I
> think we can simply add target_pid parameter that works very same to that of
> prdm.  If it is unset, DAMON_RECLAIM works in the physical address mode.  If it
> is set, it works in the virtual address mode.  Adding just one more parameter
> that doesn't break old usage doesn't seem that complex change to me, at least
> in terms of the user experience.

This should be viable, though it will take a moderate amount of extra
time to develop.

> 
> As I mentioned above, yet another example would be using
> DAMOS_FILTER_TYPE_MEMCG.  For this, we may be able to add a parameter for
> describing the memcg of critical processes.  Again, adding just one more
> parameter that doesn't affect old usages doesn't seem too complex changes to
> me, at least in terms of the user experience.
> 
> Meanwhile, I agree adding a new simpler module could make it easy for new
> users.  But, I concern if having two modules for DAMON-based reclamation will
> make users get difficulty at finding the correct one for their usage, since
> they may now need to compare two modules.

Indeed, you're right.  From an architectural perspective, having two
modules forces users to spend time distinguishing between them, which
can cause confusion.

<...>

>>>
>>> And, even more importantly, why it should be a loadable module rather than a
>>> static module?  Do you have a specific use case that requires it to be a
>>> loadable module?
>>
>> Yes, loadability is crucial for operational flexibility in practical
>> production environments.  Beyond some obvious advantages, I would like
>> to highlight a key scenario: system administrators can load the prdm
>> module upon detecting memory pressure and unload it immediately after
>> reclamation is complete, thereby eliminating any overhead during normal
>> operation.
> 
> I agree always having prdm in kernel is an overhead.  But, I think the
> overhead is not meaningfully big.  Also, as I mentioned above, my intended use
> cases of DAMON modules is for cases that willing to simply always use the
> modules.  If runtime controls are essential, I think using DAMON sysfs
> interface or DAMON user-space tool is a better choice.

The prdm was developed based on samples/damon/prcl.c.  Would it be an
acceptable modification to port the multi-process support feature to
prcl?  Does that make sense to you?

> 
> Someone might argue DAMON sysfs interface is unnecessarily big compared to
> prdm.  But, I have to ask again in the case.  Does the overhead really
> meaningfully big for a real world use case?
> 
>> Furthermore, it supports zero-downtime updates, meaning that
>> improvements targeting prdm can be deployed via a simple module reload,
>> avoiding costly system reboots.
> 
> So I'm not really convinced at needs of prdm module at the moment.  But I agree
> your above point is a good example advantage of loadable modules.  Also there
> were private requests to support loadable DAMON modules.  No one among those
> were for real production use case, and I understand you are also doing this
> work for imaginable use cases, not your real products.  Please correct me if
> I'm wrong.  But as the request is repeated, if you willing to convert existing
> DAMON modules to support loadable modules build and expose required DAMON
> functions for that, at least I wouldn't oppose.

Thank you for your feedback.  I would like to try it out.

Best Regards,
Enze

<...>

