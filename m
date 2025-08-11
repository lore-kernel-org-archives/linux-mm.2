Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F69C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADCD6B0111; Mon, 11 Aug 2025 05:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E4A6B0114; Mon, 11 Aug 2025 05:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D796B0115; Mon, 11 Aug 2025 05:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C14C66B0111
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:29:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 679E014065F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:29:38 +0000 (UTC)
X-FDA: 83763954036.07.3B45B26
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F455180006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:29:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904576; a=rsa-sha256;
	cv=none;
	b=3HDkeDJjpWLmsVjc0hF2FWFG17qoDQELR0BCNDsGRMv/9oEyg7HXCAcyB7HezlVwvdIfAZ
	c36NkQLuaYpv6EpxLzm7KmJ4C0db8R31QOleD8unIEk5LeJVJLB64JWSO/804PIrbe7DRK
	nRSNra44yvEFlDkwwtlRa0l5HtsTDwk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4iW3W/cx9SLpvTA6KnqI7K8K4I2aGQbYPmZCrAgO9uE=;
	b=2sPji2KWYCktRmETSfHUnA0VMcG2BEb09arvSCoYIGfdUpk3V5ScBC7uq0TTkaVXI/AaEG
	As2NU6eceIqa2pFRZZuD1HR9F7iqdtoBU6j7gqytoKxhlCpZ/ONtBk8gpMXLs2UaLJz9sr
	11SknZ3h+9v5sIDv5UZJybj4yW78bgQ=
X-UUID: ae29d144769511f0b29709d653e92f7d-20250811
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:9f072084-4e7a-426d-bf9a-ff0089cf6e29,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:c7b9f30b8c3086fe46fc61c8f7f14481,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: ae29d144769511f0b29709d653e92f7d-20250811
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2014897367; Mon, 11 Aug 2025 17:29:29 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 54C52E00901E;
	Mon, 11 Aug 2025 17:29:27 +0800 (CST)
X-ns-mid: postfix-6899B7F7-180263939
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 7F470E008FED;
	Mon, 11 Aug 2025 17:29:23 +0800 (CST)
Message-ID: <393a4509-9b05-45b8-8496-699ace9a5438@kylinos.cn>
Date: Mon, 11 Aug 2025 17:29:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 6/9] freezer: Set default freeze priority for
 zombie tasks
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, David Hildenbrand <david@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Nico Pache <npache@redhat.com>,
 xu xin <xu.xin16@zte.com.cn>, wangfushuai <wangfushuai@baidu.com>,
 Andrii Nakryiko <andrii@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Jeff Layton <jlayton@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Adrian Ratiu
 <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-7-zhangzihuan@kylinos.cn>
 <20250808142948.GA21685@redhat.com>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250808142948.GA21685@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F455180006
X-Stat-Signature: 5x9bfanh7yjgkwyyfxqpmmjcxkt8ara6
X-Rspam-User: 
X-HE-Tag: 1754904575-441172
X-HE-Meta: U2FsdGVkX19sw5BYVNBqlno7UDFQtxThgsp0Obdnxn9POrXo223E0OMN/osXEshmoRcgObOveQcgtlrC7PT5FZyAyFf5NioT8rOdYTcHv9o8lAFghc0P5gHaKd62k9GQXXlM1PuYFvMB5VMg1By7z9oRXUqSWZGdb7gYgE2FEQqTmj98jfpvb4TxQQ39cg0abl3vNZfBZvQZvNxCaDR4Komtz9tcRAZzgnoZdbkWGCDwiWHLzMoL/SamrThkE4+kHT5KR0Fa6phYd1i1JkUlI5N4eQ5cD0HGBYz5d8YdDcYBqesDwOERUUEokeT6P4V9mmnDd9ZFE2r2EpKVhrgFv/9Dp2PHIHOQW53CCfTXK3O4uk4dvJIC/NQ0snrLMkmMc118i7VWJIHIFlmLupA5TGgdrrV6h0dDRCuWHyhHQE0AvcoPP1uilC0xhIn8jztBE7V/0cvGsskqqMQfgc5Q5/qFkr2W6vgRNSDkyI9VSHNuguW610u0Vn+IdsL9aaPUjKSnrE2KXeS57gWtsfRVwVzzdsjHR+Grw0k6+wUwytC1Gb4kAGOsj+R/jOR9MwSYVkYghGvgODmkgQ13epKTtwgRe0A8fmV29t/ih3xzFMOCoTogdRzB45OKhwFzKynpECHa7PNc93B77pi+sTjp9kjJtC0Xyi4jYrL9jGM/nY15rWCq6B4VL4PgDDobg9HJ4/gSTDNA8J+bbPPDqcSrS+JiscBVFP9DxvvF4YpZYYLFTasGR0SX0l1Iev0tGTkNRZfixxmZgZeOqqeT22cNuekzwyUdvCjnNY+ByVBGP4Yj4dANn5Kex8HdyiSETv4VdmGr7n9O/iWswIq+s3KzhW+0E67NPKm+E/2PdvHnNSMTveI+ficNy6GwlMuRTcE2jN27iZqvG+ZdCzHXtGEmcFGKQ10UPQPbfsuOxPQazEOhist66wkmsNvTm+xGz+vvJaKFoVEKCN8nyceZjAl
 lLdpuxL4
 75GNGwV11oprx5LQE1BvB4Yt+E5xdufgyB7rB42JBoUeFcBkGxtE/hZA5BFIZRws6zL5L5iqWTvSKlBjSumQWieY3Q1+pyFOQrkcpztdWwSThidRZI6bu5gBPKjAZ1ZpTOE9taeEDRM/QHTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/8 22:29, Oleg Nesterov =E5=86=99=E9=81=93:
> On 08/07, Zihuan Zhang wrote:
>> @@ -6980,6 +6981,7 @@ void __noreturn do_task_dead(void)
>>   	current->flags |=3D PF_NOFREEZE;
>>
>>   	__schedule(SM_NONE);
>> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
>>   	BUG();
> But this change has no effect?
>
> Firstly, this last __schedule() should not return, note the BUG() we ha=
ve.
>
> Secondly, this zombie is already PF_NOFREEZE, freeze_task() will return
> false anyway.
Sorry, but in our tests with a large number of zombie tasks, returning=20
early reduced the overhead. Even though freeze_task() would return false=20
for PF_NOFREEZE, skipping the extra path still saved time in our=20
suspend/freezer loop.
> Oleg.
>

