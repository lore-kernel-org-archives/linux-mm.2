Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E52C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73BD6B0093; Mon, 20 Jul 2026 14:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B3B6B0095; Mon, 20 Jul 2026 14:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961626B0096; Mon, 20 Jul 2026 14:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6348D6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:31:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C540AA04FE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:31:07 +0000 (UTC)
X-FDA: 85009996974.24.030839B
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2AEAB4000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:31:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=kKnTBaQx;
	spf=pass (imf11.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784572265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64nKL4t7ZOMJQeMJXoupi8lChMlperoUGSuRJb+kKxs=;
	b=aWSOp20j0w0hQPpaSfiTdtbFe5BDJDrKQzAeKZvNZR8YUJvhesHsusU/03lqLwRWWhNY8p
	kLV+CIYFhTty7FypO38F5/pr/quFJImlKwJaOpM4ooQzTa0hHctUVENpgRzIZddw1PreRi
	lTOu9/Qs8ioEmD9Q8BaEJf/FPt3alUs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784572265;
	b=HXhwj6HjZmOmXlwfUY19ZAtONOAc/8dn93YQ99IEFP75Y3qFic3WeefWw6bOSn4qTgQpAW
	86I84t9ev1LWXGHTOw2IiqrsR/X4AEYQnWXXI7hONFL61/R0vU6SUAskxG2P5RYcz2Zaov
	yy9ZD5+qP/+v5htT2PFoYVM/cQ5NR24=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=kKnTBaQx;
	spf=pass (imf11.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1784572224; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=aQ0WFfaj+RRG5KYT7uo4r4S+tzBtUUAnScyIeeDChof3v/5+jCIBtA0KRtLZZ/bLoJkKj7aIXSoJPnHWLqkbHCjVy4xitSLw88BjLrRlMtCz27hC+K7L3cJY2MVJvbs9aRNM83WVJGzamwYLP3W352CihZ1crlUqLqkE2iWbS3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784572224; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=64nKL4t7ZOMJQeMJXoupi8lChMlperoUGSuRJb+kKxs=; 
	b=gJ2MPLsspdyw//XfJWZkwlydjoflMbpvM7VZZlMX/eRLpYJCcopp9N0XU7g6KWnX88zgf9+vDGp3bvTRU/+HyEJJsz5vCKjAhePMpxTztT1KtatTRR8OpcTy/PkismFR1jAZ1P5PTCDGHCDWEzjhbGZsm0pIgiqTE5/uP2/TRNw=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784572224;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=64nKL4t7ZOMJQeMJXoupi8lChMlperoUGSuRJb+kKxs=;
	b=kKnTBaQx1r72oiZf0DMEoii58d21jADdLQk24tPRe+kQL/zQ9iL+nTcmUlukaarG
	/2cRMOkJLd25O0bv0X/DSBTXyNLpq2YTocjessecMpHpBZrfEtdXtDyPfZPO49aVGbk
	a8kqVtKV7IXXDapjlDIAsxrF6bxalRDQNkbAg0JY=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1784572223203771.9033389679731; Tue, 21 Jul 2026 00:00:23 +0530 (IST)
Received: from  [14.139.128.24] by mail.zoho.in
	with HTTP;Tue, 21 Jul 2026 00:00:23 +0530 (IST)
Date: Tue, 21 Jul 2026 00:00:23 +0530
From: Aditya Sharma <adi.sharma@zohomail.in>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>,
	"David Rientjes" <rientjes@google.com>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>,
	"Steven Rostedt" <rostedt@goodmis.org>,
	"Masami Hiramatsu" <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
	"Kees Cook" <kees@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Juri Lelli" <juri.lelli@redhat.com>,
	"Vincent Guittot" <vincent.guittot@linaro.org>,
	"Dietmar Eggemann" <dietmar.eggemann@arm.com>,
	"Ben Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>,
	"Valentin Schneider" <vschneid@redhat.com>,
	"K Prateek Nayak" <kprateek.nayak@amd.com>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-trace-kernel" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"imbrenda" <imbrenda@linux.ibm.com>
Message-ID: <19f80cb1ed8.13fd666243425.2308143427066829733@zohomail.in>
In-Reply-To: <d1180a70-f4b4-4c22-9ce5-881cb0e2370d@kernel.org>
References: <20260719185409.409685-1-adi.sharma@zohomail.in> <d1180a70-f4b4-4c22-9ce5-881cb0e2370d@kernel.org>
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large
 exiting processes to a kthread
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Queue-Id: 2AEAB4000F
X-Stat-Signature: 63h6odfj5ea67czxhins5e81re7r9mh6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784572264-251962
X-HE-Meta: U2FsdGVkX18kU1UremlsJCu4qAvOEz0L7hg+PCNr9BDzWviRF2jzxS56yUTMFHUiRRETiY1425z4rtBvHtUGFu+JVIqT1M5iHrdOoVH2dErREkn9mkBpq2j7AZ2irMhkxbY0rKNttG3fKf0NIPIzg8vMC7TKwiVrQmmUaGXsYaFeDnSCFD9ROw7lhjAJ1WrjYsmaRVMHosCWsSCdKa2cwHO88IOUKHKNFzjgU6JUigDycZYRDNRX5mYJOK4BuTlKnjUSVLABLfuxkXIae1FjlxkmgZY2K7OLtXl+JlLnf9GqdSA9sTnMw4P82AWDxjF49gOJcGKJl2YLWpyZR7+0ICvz74fCkQ66nyofLtSGauYfmRAfa/EQr8JDsGGoVtjiL5LkeDn3kU8UZ86hM7wj/06NzFk+8KWtRajtf6d5V5knhFze4+v2Q9RbOOPVNT1Cm42NHb2bY5iyETP/WmYOTDDRbqK5AAEwV3GUS8EooEFAm/ozaZnDBc4AIlPLiH5zD1P5SvSUYkjL8IE2EhZbMXOXghV0YlSPmAC345abRTTOaEzDxunu2gcRJq8lGbQ2vfUmdT7ofGs6n1rovkhX+iUc5pvMONVBhQWCAE0/8gknwyiSV2rq5Xt8jxjrFFWqtt1TSV1kDS3K0MeLyV0sCAC4wrq3iLLcGnAfYzkC45iniB+xWhsBdvqN4qXAjG9OlLHeYTSRv6HNhOUcNZWZUHxuG00odt7brxdSrXDmgBQvYcFx46PEnYDyoLuDmbBUPtAsKiEjRQ+TlCziTGWY5l01Blb4j5pwROAChLrGuAuXOdpefjfRcoGh+1CfsOLNrsezjaewd3WaDofPu1VIup9MMw0bjka+ob9hYDtdgtuJ74oHqepdotO61Ak9vMf853kOet4jwJPiW6VeDp0mooShXVDRolbhfD2JTD6iOeRVQq5fpxYt0rQK2ysKohh5SzenZ0CX60ISu8ONX2A
 2Pn8QIRl
 ibW15Dt6MvJR2qbcCPyZoj0HW+gIm790Xlq/0Jf7CDrcpqEZp3qE6O0KcChfmQdaUF0eC1BcLIcblZJBVGc3C5ZyTCg4f0NDqk2DP0kCq9XlziYloVRfjrWtx1MIxY69p+LUJjIdI3keQFCne/dLbQn1nh6kVc2edGT8obk82ZKNM8aJYuN/QOoJ2f4yu2DOUVAOWaOyAe5wQ35A8yAY87zouNaiQ2Ufa540aNModrH4joUnBH+qwUeclKEDkHHDgVla276/EOG3vZztkeFyADPH1ur4Hf2GDXFqpZ3g2dbHERr5ZhOIXwfU0nhRd09BRX/4d6/XYdp4iQIjSPjOn7peh0bjtYmTePCJBoriSPCuwzyDsKClohm+rAcqmTIxlezZ04tTYRI6LcxFDgZZ0/zTkCWMBCGjArmxQC5zsyMEcUXjBsAzyquaB/cQUZS8ZxBglndNCNUCijUV51BGD1ok19Twfo/DlJxpdEsO8A7FC7+03fy56VgvPMx+/2tjXkJXFlav3MyDYE/2YXdlEVLT+TTCtX8+tKRHiqduvAxXqzfA6Wybpr04KQvBg8ZxLphfm8DQ7jxks40KU6fYAFFOHLoRM8Md4xYK3ppDWHpFt+bX8lm0jjoVEvEkKqrLu1j7BNnlL0eb6K1VeuWzybZFBaYFLn7WTyLwe9YfiRUGkop3JsG9rJ+5hPNu+RIt30bzkm8KYWLhC5tNjb4qQf9Dz8o19BwdelxxEusvUZ3xgQLbCtrZoafE/yxio2+QshIv3HH7FDYQmdkEWWgYnimAe76jDf3zOOSvQ3GU5ohE+VaD1IbLTYtoMt6v4/AyTxq7G5V2kJYp59JXw2L6Gri7WADhCHCTad90W7vNI/4kW9skGlAts4gQ/e4GK+2s3HxILYJhB/2HPq3fa7zg0hAx5GZz1vAD1qbRjAGMHnrrXtBJOXUMc4G3WNRsssdwUKjfRzFZ/feT4jf2wuTqCQO4FUZx6
 IA/U+jpN
 3uKAbl/XQNspUsxkMksW1tQtt8XJxjMpDpxaGsMKwNxkN46o8mTkDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Sent using Zoho Mail


From: David Hildenbrand (Arm) <david@kernel.org>
To: "Aditya Sharma"<adi.sharma@zohomail.in>, "Andrew Morton"<akpm@linux-foundation.org>, "Lorenzo Stoakes"<ljs@kernel.org>, "Liam R . Howlett"<liam@infradead.org>, "Vlastimil Babka"<vbabka@kernel.org>, "Mike Rapoport"<rppt@kernel.org>, "Suren Baghdasaryan"<surenb@google.com>, "Michal Hocko"<mhocko@suse.com>
Cc: "David Rientjes"<rientjes@google.com>, "Shakeel Butt"<shakeel.butt@linux.dev>, "Jonathan Corbet"<corbet@lwn.net>, "Shuah Khan"<skhan@linuxfoundation.org>, "Steven Rostedt"<rostedt@goodmis.org>, "Masami Hiramatsu"<mhiramat@kernel.org>, "Mathieu Desnoyers"<mathieu.desnoyers@efficios.com>, "Kees Cook"<kees@kernel.org>, "Ingo Molnar"<mingo@redhat.com>, "Peter Zijlstra"<peterz@infradead.org>, "Juri Lelli"<juri.lelli@redhat.com>, "Vincent Guittot"<vincent.guittot@linaro.org>, "Dietmar Eggemann"<dietmar.eggemann@arm.com>, "Ben Segall"<bsegall@google.com>, "Mel Gorman"<mgorman@suse.de>, "Valentin Schneider"<vschneid@redhat.com>, "K Prateek Nayak"<kprateek.nayak@amd.com>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <imbrenda@linux.ibm.com>
Date: Mon, 20 Jul 2026 13:43:34 +0530
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large exiting processes to a kthread


 > QEMU has an rather short implementation for async teardown using
 > clone(CLONE_VM), which is IIRC essentially the result of Claudios previous
 > kernel work you note below.
 > 
 > So nothing got merged because the problem was solvable in userspace.

Thanks for this. My related works paragraph is wrong on this then. It
says that the s390 case was addressed with KVM specific async destruction,
but what you point to is QEMU's shadow process. I will correct that in v2.

Yeah, that CLONE_VM trick works, so I would measure and compare them
and get back.

I plan to measure:

- Memory return latency
- N concurrent shadow teardowns on N cpus vs the reaper.

One difference between CLONE_VM approach and CONFIG_ASYNC_MM_TEARDOWN
is that the shadow process has to be created by the process that would
be torn down itself. If that same behaviour is wanted on a workload
where we dont own the source, CONFIG_ASYNC_MM_TEARDOWN enables it here
as well. Also, in the QEMU case, it also means that the deferred teardown
decision was made without knowing how large the process might become.
CONFIG_ASYNC_MM_TEARDOWN adds a gate where for the exiting process,
RSS is evaluated againsts the current backlog before queuing it for
async teardown.

I will drop a follow up with numbers

Aditya


