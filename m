Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48F3CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 16:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853EB8E0005; Sun,  2 Nov 2025 11:22:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8047E8E0002; Sun,  2 Nov 2025 11:22:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2778E0005; Sun,  2 Nov 2025 11:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0898E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 11:22:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA72A89175
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:22:18 +0000 (UTC)
X-FDA: 84066184356.19.5C0A3C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC8BE1C0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:22:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hyazv7Gy;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762100537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbrG4ZmxeWTi8gs7vSwXBAYrF+YpwtGZmkJmucMkWII=;
	b=fFLeKyVWKe6JKUzeqXFgjIamd9DjzaIImg1+ZhR1SDqisFy1cjHEiXaH4RTK8uS7uJX0cJ
	224syZzC3/CUj4SM/LIwRkbZnNI55etVnr2ShZtCQITcomep/gPtGWPdW7pm+AIxH95BCU
	91XZB2DO6/zftfiMIc7VALKaFJIhf2Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hyazv7Gy;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762100537; a=rsa-sha256;
	cv=none;
	b=g0mz0I50I4M7lK4PK4qtwNJxlmToWOLVLGeplVVTwioMYfgzBOXHuXmcG549rq7arFy/bd
	cgBafgWvIvFOwIK36lM1JmSpzxrXrMGDqAaUOP8YdVk3s4CUqUmGyNHJ6wVS7HFOTJmmVN
	fETj1Uz8GzUReZdWTsktfDsGoRDTMTI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762100536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zbrG4ZmxeWTi8gs7vSwXBAYrF+YpwtGZmkJmucMkWII=;
	b=Hyazv7Gy1QQLQzQRY5WhkfUYreQkqJDUdNIlJgYTyWqCLaUf8A+iRC5/5XK1XCud4WGytX
	eaIGsgnSJXmuSrAMdgOcYW7cPbmaiTSJ38UtusqFctAAP1oB3WOxcmjNrmG7bk/2X7u+VO
	a9pkMQ16U8DDpaSFXU3jt5CS4ENjcOA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-jWQHTZ-9OWOK6wI4YNnlSw-1; Sun,
 02 Nov 2025 11:21:57 -0500
X-MC-Unique: jWQHTZ-9OWOK6wI4YNnlSw-1
X-Mimecast-MFC-AGG-ID: jWQHTZ-9OWOK6wI4YNnlSw_1762100336
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB13719560B3;
	Sun,  2 Nov 2025 16:18:52 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.84])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 7E3DF1800579;
	Sun,  2 Nov 2025 16:18:30 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun,  2 Nov 2025 17:17:35 +0100 (CET)
Date: Sun, 2 Nov 2025 17:17:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Reber <areber@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	tiozhang <tiozhang@didiglobal.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	YueHaibing <yuehaibing@huawei.com>,
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>,
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>,
	xu xin <xu.xin16@zte.com.cn>, Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	David Windsor <dwindsor@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hans Liljestrand <ishkamiel@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <20251102161712.GA4273@redhat.com>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: 71uyy841c15m3mhkpozwrznayez1kgzf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CC8BE1C0002
X-HE-Tag: 1762100536-536745
X-HE-Meta: U2FsdGVkX1+2fvbvJmGWxEH9mmLvdBVDB5Z52sOD/pxr4eCMM3m6whdWOnsbrYl0wrbh4HLYngA6ObPaz2c78UoqdE1kLMti/7/ZLqqnQNYGumZS68nwerg2rK7DGft4TyBpIYbrGCIdbHpRobeOEKjgXUjEVWC2+pUdR8a683+BoYoNpgtHisD9cBKz2fVw0H35f29ByXEEmtq9rqKoRWax7IBBIGiUjR5OoVsdRPODb54BbSJAiwI8p2nrP410Z3l9rD4bGW8BSgB0aLp2qgcVD1B0eorpy9j4FQl6lWs+RvcCd/o4KAwz4RBfJhtFZvsb9fu8Ug3bffIUCnJIzubsGgLzoqA07UzMdpYjWNwFg86BlqGNKjV5LjuXBAJ0TBD3bqAl/GmSkF4BVjd422bKu3hbIP+OdbociWlUdWP8zwcnAxkaLK+2jqjBTR35PLxn3LIKpYa+8QygyWyRg9eKy69yUMtkRBo9cwucl01BB9yqBF/r7iu+IImAnGzR3EzCA+9bv9rDWOmIp3YeconTuhcVS5em9iedj9SjPHqIOrPfSQ+sA9fO+zmjdqO4muVrjZGfPTU2hZplsCoK7c4yGy/7qsOuZCzWDPhZf/3l6HIz4idw4oSroeDUiMtsTDaqJxa+AHG3Jk7VN2nFRjPmPTVcVodaMjU3QT6kLVMZwkDMjQeYBGDgpjr/ZfZJFjdHQk9lzXm7Z66js086pDy+Vv97MUs6IKJL+tqdr1vSokHFYTFAHtu22YMp2mcVwiWpNUJ5c6XJ+fTAoWKsE/pLMCmusdxDkNUMW7V+ufqdq9cFmcr+Ys1UDT+s4qkTnEISslUsdHDLAe7IXDhKhPtDHw8QDosH4WnpUtjZliOfc8p6F453Fwg7LwR9OcoCKeZDLGI5GbjQhGWJfyPxmbv2kDoAE94U8UgDkGAmsmalVaiaewBtuPDXBH2hogbNZJOaY6nZ3CdNOtOw1ht
 mKpwBz4o
 RrfWUDScGAPnclqPPKQxytAC9imNR9gpo1pj2YhBoGVkMQlceQwUZ7KAc0huOqHqgLh31f5e2oPWhourGgB5efOzr+WtGlwqfJePkBKaJG67BMMAvsyfWElTYsZJFVFEbqar7U5oEqHuJgf//R8TOcUKRtlZIHPvFytzahUG4ycmG0MMtPF5rkzFb/Fn4zIVRfeuRxynaew7m5QRhidW5xbAv4Tlmr3fJecKJGzeDtxstxShXH8QiY31rPmdM6ax/RK11QrcMRp4pcXV7FMjSqVYaAfxrMkQDlUv6rVdyMW+7xqLECQXXjHi/xF2LPW3HRcaZoWyj+71gj0zcIEIPHPUIyi1y3zk8E00XX3Lsi0U94mPwC8Noz7KqH+UA8NWYSX/CI8yZbykYc1Om6ElBpYyAaX7aE0HBLwyWBC8ZxLrPn3kwRZcF03Tt3y6/gAAddnWdIEw3iEgvK2Qay8bhia/B9ldp5+P76kGF79G5MnUSyfx3B4qezVQhtYCThaOewFUPjRaN/Yj4hXSt7/9rEQDnU8XhCkiSmztLiJFl1PF/lkt41n7SdWAN5Hj5aCC2ubLwot7IbAGlq2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/21, Bernd Edlinger wrote:
>
> v16: rebased to 6.17-rc2, fixed some minor merge conflicts.
>
> v17: avoid use of task->in_execve in ptrace_attach.

So I guess this version doesn't really differ from v14 I tried to review...
(yes, iirc my review wasn't really good, sorry).

Perhaps I am wrong, but I still think we need another approach. de_thread()
should not wait until all sub-threads are reaped, it should drop cred_guard_mutex
earlier.

I mean, something like

	[PATCH V2 1/2] exec: don't wait for zombie threads with cred_guard_mutex held
	https://lore.kernel.org/lkml/20170213180454.GA2858@redhat.com/

which is hopelessly outdated now.

Again, perhaps I am wrong. I'll try to take another look next week.

Oleg.


