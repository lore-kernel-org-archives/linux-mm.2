Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5711105F7AC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42826B0088; Fri, 13 Mar 2026 09:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5EA6B0089; Fri, 13 Mar 2026 09:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7CD6B008A; Fri, 13 Mar 2026 09:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC4F06B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:34:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66C1B56376
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:34:06 +0000 (UTC)
X-FDA: 84541133292.15.DA2D328
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7765F4000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:34:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773408844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQIoQ+FAkbJQlAcNVU50SEU5gMs+8jbOdMWqpXIWiFE=;
	b=0f3CD1PW0SS2heSFFNf0L2oumagIzWoN9788gNYOo63mYRKGnGfrQxAXpzXMtn2Jkik/l/
	XbjvjwFfl5KHyZk+dVKxgVXs4ZzCUfJBgFsWHfOR93MsvGXQMrzUmN3Vo4cn0XIyu+o/lD
	JoIbdddOw/e7+upDI3RU2/dANDaS6FE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773408844; a=rsa-sha256;
	cv=none;
	b=ZrunvJd75U8b3zBROC4tVouwgkZqU/ErdA8LxCXIRfVFRxMQ3FTa+Tj3ILnc1yQacC26CJ
	fQvgfUdt0wE7uTkWTkXJCoWeqZwB9Jqe/clbWfGXHNQDUqBLUHRdkGV43FJbNeILOzKEcf
	rTs+6DADXOmwccLp54NQXKyxrkCyazE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id E53733E9B4;
	Fri, 13 Mar 2026 13:33:55 +0000 (UTC)
Message-ID: <b6643156-5560-4ddc-8562-5dbf5facdff8@ghiti.fr>
Date: Fri, 13 Mar 2026 14:33:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: Move demotion related functions in memory-tiers.c
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, alexghiti@kernel.org, kernel-team@meta.com,
 akinobu.mita@gmail.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 matthew.brost@intel.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260311145547.2461611-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20260311145547.2461611-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: 0
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeeljeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecunecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnheptdfhleefjeegheevgeeljeellefgvefhkeeiffekueejteefvdevhfelvdeggeeinecukfhppedufeekrdduleelrdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepudefkedrudelledriedrvdefkedphhgvlhhopegluddtrddugedurdeitddrkedtngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhqihgupefgheefjeeffefgleeugedpmhhouggvpehsmhhtphhouhhtpdhnsggprhgtphhtthhopedvjedprhgtphhtthhopehjohhshhhurghhrghhnhhjhiesghhmrghilhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghlvgigghhhihhtiheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdhrtghpthhtoheprghkihhnohgsuhhmihhtrgesghhmrghilhdrtghomhdprhgtphhtt
 hhopegur
 ghvihgusehkvghrnhgvlhdrohhrgh
X-Stat-Signature: ieaszmskarm8hzfhxw4gsmrakgaqkwr4
X-Rspam-User: 
X-Rspamd-Queue-Id: 7765F4000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773408844-253715
X-HE-Meta: U2FsdGVkX1/Bo+SOU3aKj1XTa0e2Xbek0OvuZrmHGUACypdaAdhUsXQu1x+rVcf4H8sfx783W47fTOA0HrBIQ0QV8nC/QT8xI8o0BfuSm8pUpL40PuP2CgNXim4egDgjhV48Ujv3o1YBHtRv2DXaaG4LM0rEc7pzhJqvbPPJWx/Ot9bgQcZ9U89ItyO1LnC6SP1o2jBEcgEWHfq1Z+mucfJ12+j/Vh4sf8/7AlFs7uXzNuBx8TONAbRfjK6RZa7K9zfWbArfgWJAbOcYoOQ4RchGZonVYFMqe2bq2sGDkJLXLn/u/aGKUN7yKTG/jhhZK3v5mwYYYuH4+YnLbkXtr+J+Izc6cSt9PwF9lB2JtxdDOfzjYtS1Cx0PYgCQ1Yhx1mHt+AociRxRD5l3f9G1I621lS+VMClmLgSpAcPHDF7DNJIXfzWP7DOayk3nUPoApadnJY9FJCKvRf933SJqW7ccVAsQ9TxWnGdvib/P+0/YbjX7jO0dYQVEmqqyfGUl0oH8FPw/LN4hfR7JjkiZ55gaFvhOnpTnOxt1LSxnIAFuk6oI4PCcFer0Ns/yZPCwOLODclnt6X3MR9Zm+XB/nCdY1iwpeqqr14LxbrvavIL6kYl5Xr2VzafJKWsKGN0IDILcAfZpIth2WF0hRj1UaC/ubIwlIS3Hnrl+L6ezwiTrV86yrfDDXlye/vJzrl1FsovxOt9H1baH1v78o5yQlUM46fEmOZwYqMkWfxtNpyo8+izxTJbzz2/PS0tgI8C3fbolIMZlns5RAtZEhhmrtTuocQpS63B/GZ05ygyGkTFVr4BcD20sm2+NbGOl8Dlh04EJOP40f7v0dcRgX9Pb3VyzFvUdy3IO0xuVbeLLC8Hqjta9N0X8HS+mPLHEpdaSrdxVO0RMmONyl6ujZQikn72enSyjK7sktk9yGGxupSrwb8b7pkSSUJGPzdUIzbpftK+XLLwxn83jbvDyCF9
 MyaP4dZw
 9nFqGvqHLvgC8CUuUDKU+mjaQ4EtYhyozIr/Bqf83klSLV5EDfzNqDWh0rNlAb2PbXvtXeohB/Skfc2iuHNjuSYCJa+CIbCcNPKVKSfvPFcxBtONOvF+lQm0Zxh2E48PaYzUe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

On 3/11/26 15:55, Joshua Hahn wrote:
> On Wed, 11 Mar 2026 12:02:40 +0100 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
>> Let's have all the demotion functions in this file, no functional
>> change intended.
> Hi Alexandre,
>
> I hope you are doing well! Thank you for the patch.
>
> Makes sense to move the migration functions together. Just one small
> nit, I think the following comment is pretty helpful in understanding
> that folios that aren't demoted still remain in @demote_folios. Should
> we also move this comment to memory-tiers.c?


You're totally right, my bad! I'll add the comment in the next version.


>
> [...snip...]
>
>> -/*
>> - * Take folios on @demote_folios and attempt to demote them to another node.
>> - * Folios which are not demoted are left on @demote_folios.
>> - */
>> -static unsigned int demote_folio_list(struct list_head *demote_folios,
>> -				      struct pglist_data *pgdat,
>> -				      struct mem_cgroup *memcg)
>> -{
>> -	int target_nid;
>> -	unsigned int nr_succeeded;
>> -	nodemask_t allowed_mask;
>> -
> [...snip...]
>
> Anyways, the rest looks good to me. Have a great day!
> Joshua


Thanks!

Alex


