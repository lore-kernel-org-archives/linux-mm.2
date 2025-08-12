Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1CCCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9227900006; Tue, 12 Aug 2025 04:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42CA900003; Tue, 12 Aug 2025 04:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BF2900006; Tue, 12 Aug 2025 04:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7F68900003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:07:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 667C08180B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:07:39 +0000 (UTC)
X-FDA: 83767376238.10.CB7B05F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 23E2B4000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:07:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754986057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hk1TpDCUau58C8if57SKpL9uq1N98Qnw4SmcRQ6xc18=;
	b=eP+WbvW1EUw3dwTB4RF+5Cj0ePTNk29HulOM8SaWKBZSmCYB95ZMsb4KVFBrl64SZjs6zN
	AmzayOSFUCB9M6Hxxajl0gfqiF2l30Uocsl8AljT6B0hIg/TzwRCCLGGzpoK/HtFFNonxH
	QYJejKC9HBp9QIP7yeN0UwLsE4x9mS0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754986057; a=rsa-sha256;
	cv=none;
	b=0Jc1fnFvr/b8l0PfnSPtPkPt/n/1XmszvK5uFWDLqQGekuEt2czt9LC7gauOsozdt5qh/R
	NG3cBIFFuTYF9gzPiiJD23koYFQnq3Q0gvL5tthzCIPuviU9+p0dipPRmX/Zr4EeHc1Q9U
	Y1uG98yXXxXKIjVUE0u7mNDGvFX2bWg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
X-UUID: 64813e56775311f0b29709d653e92f7d-20250812
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:24076325-4bf9-4abf-b7fe-95fc83e76d02,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:4ac8a97a339f6c8d3cea5f3b62b86d7b,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 64813e56775311f0b29709d653e92f7d-20250812
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1538524574; Tue, 12 Aug 2025 16:07:30 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id E888CE008FA3;
	Tue, 12 Aug 2025 16:07:27 +0800 (CST)
X-ns-mid: postfix-689AF63F-547715471
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id D062EE008FA2;
	Tue, 12 Aug 2025 16:07:11 +0800 (CST)
Message-ID: <9dca7c98-84e5-4d16-af76-93f2b0470243@kylinos.cn>
Date: Tue, 12 Aug 2025 16:07:11 +0800
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
X-Stat-Signature: wak8h1nnbgh3s5t1qiu1oh5mx9zn4my3
X-Rspamd-Queue-Id: 23E2B4000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754986055-307140
X-HE-Meta: U2FsdGVkX18a6binhterxIXp2Rc3uHMGKhr9c0iCTiH65bvq5JcxYsutwhMsT7fvlM09oz3Jk1KXV+aKeUL/mL0ZY2DhaGSasn2bJ9xndxgBNw1OzZyu3L7JuToqu+vJKY4XV1des5m8J6H5djgwVNUKcWRrE5FTbQ6QcpSQUhDFZlHOZM5LkawOH+T5a2CLAFXi4F7KDTeIbuCwZunJjuYy77MeVz2UrbkOQj2wU6eZqnvDTBL3rxzEz7wPmohjCma98ZWpr5SWsXT4JwZdUf1pTHt1dqttTl0hkwKd84JrL1DUiTw58opBh9rwWETsey2eMUogAvR6HhO42jUyHaRaiS4vzArp5XfJ9OlDkh9mun0SiOS73yIibLdOrQyFO4PXwYblDiJvJqU81ETNtc3lTObgvfvDzOxC/E5KiZKNkzU2ITmEyk2GcxfmTWBardEVXBIL2HlMTUOHVLgx8uHq6T5tx/ekSJtKGh+zfBgvlIBgr5PnatrFOX2FMi/zOyyb53p68nT7ae3eqpoFoA8iNdWkYQdFQi4K21SeHcabBkuwPUlf7Yfad1KP1a7asY2AhbLpyNYEfSS2MVJxwG660gm7i3SGHhbKz65pbWbXwMS7wQSYHtkW0n3WsvY1nMfejGwhTcNOJwaQ9DOFk+mvRJYhYGonUJmo9vFth+en8oX59mtofGlZB+4yt1Se6Y9D81Qz4rdEuLq04Lmou83lidHKf26ZyHJ8kQpcPHkbYrM0bvuvuPDgLY9mQRsUTAImK5BOshHj/GsXmQdsUtNh3dHYMJ9xG7glxZhfgsNsH2JM2z+QEM0EolJ/Rss9wwNtSE1YSMRZAT5hv3v6i+8TZkRphQMXxWjnMTRoRu3l7CqfZSH34YpMQvSvJMgzTgR11cJ4wV8aOh08IIHD/m7geaT7A2hze8MwMujnDyWHqCPft+BH9z7b1iBW14BShIKr/luNURf07njlt45
 D5YlY5dA
 ZKNCrDWnmSWofq+3UoP/UQvGk36xK5sAxWL3PCveBR5AALtcSoQ8GD65yRIRiZZICbgEj93sloIzbvf0oSO9sBmlOu3kuT7xaOkHuSxglfIRz11PpM18YAM0VWZZamamd/DEn92JXIhIAko4=
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

Thanks for pointing that out.
Indeed, I=E2=80=99ve noticed that in the current position the code has no=
 effect.
If we move this code to a more appropriate place, it should improve both=20
safety and usefulness compared to the previous implementation.

> Oleg.
>

