Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91E5CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A236B011F; Mon, 11 Aug 2025 05:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB168E000A; Mon, 11 Aug 2025 05:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8F26B0123; Mon, 11 Aug 2025 05:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49B9A6B011F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:32:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7ED35B60D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:32:10 +0000 (UTC)
X-FDA: 83763960420.13.B9FA1F9
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB9F8100007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:32:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904728; a=rsa-sha256;
	cv=none;
	b=6dN4Z1uhTI3Q4UMQ1Ue88lt+KxxEKPy4oYP8cvdnNh5PAdiA4UNXLOwINro9weKVzlYdYa
	6azPo0FqSPY4I3X/l9efU1lZHnBSwsg43lYZrPj2mrEXY29/hCi5kDZs5htJVTRL6G+Ic/
	fL+USZjWgiFKOPxkVZ0p6rAGehrWU3Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBLHq633myHRhMcuyw+oBVBl9eWfkDKb+/cDgxxY95U=;
	b=qI+Uo2fyzr8jMHXC1G6MtEmWVacT/MNfvNAC3ac1AYdaO6IIVX3yU1yb8erDzrlfCAf8d3
	zFyPfNfbtoqt85SucMjtrIbJbzH1bBLc38mw8GAFpaP58H2q5NUXxGRZuLLSAEj994p2XD
	IIh6ch1oGRJuzzrTBxcHwVDoHqAA+K8=
X-UUID: 09119de4769611f0b29709d653e92f7d-20250811
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:6894e59b-7da2-4bdd-9d45-8007d9a3ccca,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:116d6fe237f848fad94ae5ca94f49707,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 09119de4769611f0b29709d653e92f7d-20250811
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1613669997; Mon, 11 Aug 2025 17:32:01 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 2F02AE009021;
	Mon, 11 Aug 2025 17:32:01 +0800 (CST)
X-ns-mid: postfix-6899B890-891391949
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id CD093E00901E;
	Mon, 11 Aug 2025 17:31:57 +0800 (CST)
Message-ID: <ee4191ab-ecce-481f-999d-e65bfee799e7@kylinos.cn>
Date: Mon, 11 Aug 2025 17:31:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 7/9] freezer: raise freeze priority of tasks failed
 to freeze last time
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
 <20250807121418.139765-8-zhangzihuan@kylinos.cn>
 <20250808145349.GC21685@redhat.com>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250808145349.GC21685@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB9F8100007
X-Stat-Signature: 7nxx1dt6sooq1a7c9w8r9zkibujzie9a
X-HE-Tag: 1754904727-492012
X-HE-Meta: U2FsdGVkX1+5oxp5JdgYaVY1RE5L5lPmWmlXmTIm77Ne20oXQPs51Xj2Zokt/jew5H53CdzmckRXf8moQ54EMg14toYGbO6+2mBFLYPFHG5qdUb7PbbEQLytIBHWYUq2Vt0gM1QmUv/D9pw/JLFQys5yL8X9AgBsZg7VoiquEgjUdMB5cAjS2ZHHhTdWC1wAcQdH3NCj3Pc4x06d0BkCZ9s5bZbz9AGUz66dFKsAdSJIK3oorGjZvEjLFfFxwqdVtqzxr1EzIUHuUMWeMo1euMVwXEz9IDqq6bI3i3AHVXTzx+f63rv11I2PcO+vbYtSyoI20nMs1065snYZ6MgvpHiDDqKpW2Pkcm4870+gZ0rMoOUh3v7UAJgH+8JzAuT8TmaPkUiC8K/UlcuiR+Sw41BRdgECdb9gi8PKe4nJQtml0pVJX2uVSkq8H+EZit4WzpXCciUM+43ZODSI07Jm4/UWrznfwg3B/k6QOR+FPAjYzASEyK72uCvHuGzRFav8LH/dbkGbYPsKtclg0rnqSPh9PWk7xBotMJckRutVQmOvuZRtm63rMGbsguPQBoVlernsp5fbRI9iAeuNqfZbedPR6vAXBVU7QDrboxK4Mezbj+fnsSBKeQCOAyIOVb0QuC2mnoQfUAv6N3gTBQjRlswDQ6Qvwn7Spj8OarT+oCZIoYGjPN/2TlaFhLH3sQFqZg3wGT+dinBsb7DpBnV3cA8s7QMtcfDN8ely/mKLQF+8cq8bsrriqfXz1L+D0WA13OKvGRQfRSc0oWu9SG3az0y99/teL8Ho91/QXZRdf7zHzcd6zcaU/oZYDxLs1TMj0dGYHd5KPIzTeiesvWClWSFKPcMPbfmK77dzYmp5rsATQbQz2dkBMLDfaT1BSlLQmh5OeZAR+4KIoZKHKHKaf08RIZh4cL8+SN/ZNMkQIXrNE0CiOO3FG/vgGllbBdPB/h9z/hSo9yV9NBIBun5
 5TZD2tdF
 k6SxMIrjsi6S3g23rZ0xqMGcVw+iHOFTBZmClyMppVggBACXXaH3BQcC2zYcpl5qlj/ENK++xOz/j3L54Xfu/Dh3At2bYKfi4Ebhj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/8 22:53, Oleg Nesterov =E5=86=99=E9=81=93:
>> -				if (p !=3D current && freezing(p) && !frozen(p))
>> +				if (p !=3D current && freezing(p) && !frozen(p)) {
>> +					freeze_set_default_priority(p, FREEZE_PRIORITY_HIGH);
>>   					sched_show_task(p);
>> +				}
> IMO, this change should go into 3/9 to make the intent more clear.
Will do. Indeed, D-state tasks are not easy to solve, so our plan is to=20
provide a fallback-like mechanism.
> Other than that, I leave this series to maintainers and other reviewers=
.
> Personally, I am skeptical.

