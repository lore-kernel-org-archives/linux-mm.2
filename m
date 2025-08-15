Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CC8CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F12900210; Fri, 15 Aug 2025 04:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8EC8E0002; Fri, 15 Aug 2025 04:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02267900210; Fri, 15 Aug 2025 04:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D746E8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:17:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66EEB1A08E4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:17:36 +0000 (UTC)
X-FDA: 83778287712.06.AD95CE2
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id EE1DC160008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:17:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755245854; a=rsa-sha256;
	cv=none;
	b=a+RWTqFXd7pLk2/c/j7/zOLJcr9hfY6uYagJnVcmxT5gP18yII5hy6D1VhbjjODusAPdb0
	f1aCmf5uzAmtSGVlg5CDHbGsu0doEaErs5MpbktFddlgH/H9MaekVmMvBBBepGwnOm20le
	sut6KZiRXDAIzhcrFn+03e/p2/TekyU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755245854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QaOVX3gh9JmN6RMEOihoRC5fPF6cqMFNxpC510Ow7VA=;
	b=NFPjycLi7jA/pPSn9hP6EIkMfS+6O4fV2i7CQZLE3F3kZz+ugrSFsZNdS6dW4AbIermbH4
	dOvU+pCXen1FKRlOY58WBngXXOTPMgSSa6rsOrt5Gd6aQZzgqE+1qIFVfQmzm29rSaIsb2
	vTqXbMoUUZvfSiyRpZy5PolI3DJ6ktk=
X-UUID: 457fcf7c79b011f0b29709d653e92f7d-20250815
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:eceb292f-5fec-4e23-a06d-e14ec3b44b8e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:bc8e9e1cfca9223f5b74cc50e33c6883,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 457fcf7c79b011f0b29709d653e92f7d-20250815
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2042334603; Fri, 15 Aug 2025 16:17:23 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 28758E008FA4;
	Fri, 15 Aug 2025 16:17:23 +0800 (CST)
X-ns-mid: postfix-689EED12-935314297
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 766D5E008FA3;
	Fri, 15 Aug 2025 16:17:15 +0800 (CST)
Message-ID: <6fadd7e2-a404-4514-8b42-8872beea1ac8@kylinos.cn>
Date: Fri, 15 Aug 2025 16:17:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
 David Hildenbrand <david@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
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
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
 <aJWglTo1xpXXEqEM@tiehlicka>
 <ba9c23c4-cd95-4dba-9359-61565195d7be@kylinos.cn>
 <aJW8NLPxGOOkyCfB@tiehlicka>
 <09df0911-9421-40af-8296-de1383be1c58@kylinos.cn>
 <aJnM32xKq0FOWBzw@tiehlicka>
 <d86a9883-9d2e-4bb2-a93d-0d95b4a60e5f@kylinos.cn>
 <20250812172655.GF7938@frogsfrogsfrogs>
 <8c61ab95-9caa-4b57-adfd-31f941f0264d@kylinos.cn>
 <20250814164313.GO7942@frogsfrogsfrogs>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250814164313.GO7942@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EE1DC160008
X-Stat-Signature: 598u5ux5fhom1mfp7t7ykza57tanzbe9
X-HE-Tag: 1755245852-733226
X-HE-Meta: U2FsdGVkX18nqv703PlEmmOl/WGJKcYvj2i00l1d2mQsskn7USfwGBOLhWCcZo7c/q8PkstDf6N6HZT8jAfoCRaCO6D+RjcM+ET20w5qTY7lNxBbGnQTotTKj+3yhlyTbUkAg+S8TkN0q/qG1M5+fpQmBd3i/6HK6qYHFRy5YEryuSEPRL/8IJSbk6ucLMMKvxm6v04N/1OsdHT40ZIRup92YP/heLi6XnNallf65qNAzftcI7COcgfcOfr73rnGzqwMpY1jI5lCI/Bi4WEV8Bxg8ERC/Lb8P+UetnkP1qkRjK4jirkneyRNV763U6rYPx9d/bK/MM/3Yg+x7Yfz7n/LqN0V+PrIy2dvYnGttSP4qJo0WEgEXZXlQPty7dQQcH7cDNa5j0Gpykmfer1hc1ID6GdIoZZPLQQRqcH7DRRtxJKUBiEzO4ZPVv7SjzryOLyDq+GE/omupgAKfA4YCksT1i5Wn5t+vBqL1uujYMsVYU8jCKQpT4RBSbqy+k2TX1QgYzgGCWW48r2y3xIgWNBdk0yxko+L9eRIcUpPVuzYN+kbxcpvEan8h5Vnj7I8IM6+EymgDP0KsVWald5gVfc58E+TaXyYaeD8v/PhuV4DsdPcsuO06WGdO6WbjGLo04WHz5qMxuecFINe7/bcHbfNoSLE4PAEYLN0JMD2JlsBU6FRQRqywoWBCawAyln23hh4ZtcfOIvdqmejZ3g7JHRpgWmCX9dodbvuihTB9pJ+KhljJYSqEizPrY7GBSj5gt4cQGb9TfXHMa/JkjprqlNZP0YHC3wBzulP+aKAyGZICq97pzEZ7rBnGqrIX0vUXNLhwY9llH9nrgIWOMylKg1njbHVDl2JDLaatmX0DShcqNHnUIo792qPq9QDOP0f8zMLDoxDy/0pmq3PbiYPkfMXCfpwoFEHt4MnwIO/CEWbILOUFKm6V4XJZ2pzgw3oGRfkz5BalJn/BfnYh+j
 ekaGCfx3
 sQgdxrL810Pf8p+tcAFatLyuDYkJFQuDOh72ZKPZsWTkssnBp6hhUn+pFr3KmGkQFwqUobS7720I2Ly1kaFeOojcZGZ4jx+JcFrBkpLQP+O1LQlfF14VrRxt1CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/15 00:43, Darrick J. Wong =E5=86=99=E9=81=93:
> On Wed, Aug 13, 2025 at 01:48:37PM +0800, Zihuan Zhang wrote:
>> Hi,
>>
>> =E5=9C=A8 2025/8/13 01:26, Darrick J. Wong =E5=86=99=E9=81=93:
>>> On Tue, Aug 12, 2025 at 01:57:49PM +0800, Zihuan Zhang wrote:
>>>> Hi all,
>>>>
>>>> We encountered an issue where the number of freeze retries increased=
 due to
>>>> processes stuck in D state. The logs point to jbd2-related activity.
>>>>
>>>> log1:
>>>>
>>>> 6616.650482] task:ThreadPoolForeg state:D stack:0=C2=A0 =C2=A0 =C2=A0=
pid:262026
>>>> tgid:4065=C2=A0 ppid:2490=C2=A0 =C2=A0task_flags:0x400040 flags:0x00=
004004
>>>> [ 6616.650485] Call Trace:
>>>> [ 6616.650486]=C2=A0 <TASK>
>>>> [ 6616.650489]=C2=A0 __schedule+0x532/0xea0
>>>> [ 6616.650494]=C2=A0 schedule+0x27/0x80
>>>> [ 6616.650496]=C2=A0 jbd2_log_wait_commit+0xa6/0x120
>>>> [ 6616.650499]=C2=A0 ? __pfx_autoremove_wake_function+0x10/0x10
>>>> [ 6616.650502]=C2=A0 ext4_sync_file+0x1ba/0x380
>>>> [ 6616.650505]=C2=A0 do_fsync+0x3b/0x80
>>>>
>>>> log2:
>>>>
>>>> [=C2=A0 631.206315] jdb2_log_wait_log_commit=C2=A0 completed (elapse=
d 0.002 seconds)
>>>> [=C2=A0 631.215325] jdb2_log_wait_log_commit=C2=A0 completed (elapse=
d 0.001 seconds)
>>>> [=C2=A0 631.240704] jdb2_log_wait_log_commit=C2=A0 completed (elapse=
d 0.386 seconds)
>>>> [=C2=A0 631.262167] Filesystems sync: 0.424 seconds
>>>> [=C2=A0 631.262821] Freezing user space processes
>>>> [=C2=A0 631.263839] freeze round: 1, task to freeze: 852
>>>> [=C2=A0 631.265128] freeze round: 2, task to freeze: 2
>>>> [=C2=A0 631.267039] freeze round: 3, task to freeze: 2
>>>> [=C2=A0 631.271176] freeze round: 4, task to freeze: 2
>>>> [=C2=A0 631.279160] freeze round: 5, task to freeze: 2
>>>> [=C2=A0 631.287152] freeze round: 6, task to freeze: 2
>>>> [=C2=A0 631.295346] freeze round: 7, task to freeze: 2
>>>> [=C2=A0 631.301747] freeze round: 8, task to freeze: 2
>>>> [=C2=A0 631.309346] freeze round: 9, task to freeze: 2
>>>> [=C2=A0 631.317353] freeze round: 10, task to freeze: 2
>>>> [=C2=A0 631.325348] freeze round: 11, task to freeze: 2
>>>> [=C2=A0 631.333353] freeze round: 12, task to freeze: 2
>>>> [=C2=A0 631.341358] freeze round: 13, task to freeze: 2
>>>> [=C2=A0 631.349357] freeze round: 14, task to freeze: 2
>>>> [=C2=A0 631.357363] freeze round: 15, task to freeze: 2
>>>> [=C2=A0 631.365361] freeze round: 16, task to freeze: 2
>>>> [=C2=A0 631.373379] freeze round: 17, task to freeze: 2
>>>> [=C2=A0 631.381366] freeze round: 18, task to freeze: 2
>>>> [=C2=A0 631.389365] freeze round: 19, task to freeze: 2
>>>> [=C2=A0 631.397371] freeze round: 20, task to freeze: 2
>>>> [=C2=A0 631.405373] freeze round: 21, task to freeze: 2
>>>> [=C2=A0 631.413373] freeze round: 22, task to freeze: 2
>>>> [=C2=A0 631.421392] freeze round: 23, task to freeze: 1
>>>> [=C2=A0 631.429948] freeze round: 24, task to freeze: 1
>>>> [=C2=A0 631.438295] freeze round: 25, task to freeze: 1
>>>> [=C2=A0 631.444546] jdb2_log_wait_log_commit=C2=A0 completed (elapse=
d 0.249 seconds)
>>>> [=C2=A0 631.446387] freeze round: 26, task to freeze: 0
>>>> [=C2=A0 631.446390] Freezing user space processes completed (elapsed=
 0.183
>>>> seconds)
>>>> [=C2=A0 631.446392] OOM killer disabled.
>>>> [=C2=A0 631.446393] Freezing remaining freezable tasks
>>>> [=C2=A0 631.446656] freeze round: 1, task to freeze: 4
>>>> [=C2=A0 631.447976] freeze round: 2, task to freeze: 0
>>>> [=C2=A0 631.447978] Freezing remaining freezable tasks completed (el=
apsed 0.001
>>>> seconds)
>>>> [=C2=A0 631.447980] PM: suspend debug: Waiting for 1 second(s).
>>>> [=C2=A0 632.450858] OOM killer enabled.
>>>> [=C2=A0 632.450859] Restarting tasks: Starting
>>>> [=C2=A0 632.453140] Restarting tasks: Done
>>>> [=C2=A0 632.453173] random: crng reseeded on system resumption
>>>> [=C2=A0 632.453370] PM: suspend exit
>>>> [=C2=A0 632.462799] jdb2_log_wait_log_commit=C2=A0 completed (elapse=
d 0.000 seconds)
>>>> [=C2=A0 632.466114] jdb2_log_wait_log_commit=C2=A0 completed (elapse=
d 0.001 seconds)
>>>>
>>>> This is the reason:
>>>>
>>>> [=C2=A0 631.444546] jdb2_log_wait_log_commit=C2=A0 completed (elapse=
d 0.249 seconds)
>>>>
>>>>
>>>> During freezing, user processes executing jbd2_log_wait_commit enter=
 D state
>>>> because this function calls wait_event and can take tens of millisec=
onds to
>>>> complete. This long execution time, coupled with possible competitio=
n with
>>>> the freezer, causes repeated freeze retries.
>>>>
>>>> While we understand that jbd2 is a freezable kernel thread, we would=
 like to
>>>> know if there is a way to freeze it earlier or freeze some critical
>>>> processes proactively to reduce this contention.
>>> Freeze the filesystem before you start freezing kthreads?  That shoul=
d
>>> quiesce the jbd2 workers and pause anyone trying to write to the fs.
>> Indeed, freezing the filesystem can work.
>>
>> However, this approach is quite expensive: it increases the total susp=
end
>> time by about 3 to 4 seconds. Because of this overhead, we are explori=
ng
>> alternative solutions with lower cost.
> Indeed it does, because now XFS and friends will actually shut down
> their background workers and flush all the dirty data and metadata to
> disk.  On the other hand, if the system crashes while suspended, there'=
s
> a lot less recovery work to be done.
>
> Granted the kernel (or userspace) will usually sync() before suspending
> so that's not been a huge problem in production afaict.


Thank you for your explanation!

>> We have tested it:
>>
>> https://lore.kernel.org/all/09df0911-9421-40af-8296-de1383be1c58@kylin=
os.cn/
>>
>>> Maybe the missing piece here is the device model not knowing how to c=
all
>>> bdev_freeze prior to a suspend?
>> Currently, suspend flow seem to does not invoke bdev_freeze(). Do you =
have
>> any plans or insights on improving or integrating this functionality m=
ore
>> smoothly into the device model and suspend sequence?
>>> That said, I think that doesn't 100% work for XFS because it has
>>> kworkers for metadata buffer read completions, and freezes don't affe=
ct
>>> read operations...
>> Does read activity also cause processes to enter D (uninterruptible sl=
eep)
>> state?
> Usually.

I think you are right.

read operations like vfs_read also cause it.

[=C2=A0 =C2=A079.179682] PM: suspend entry (deep)
[=C2=A0 =C2=A079.302703] Filesystems sync: 0.123 seconds
[=C2=A0 =C2=A079.385416] Freezing user space processes
[=C2=A0 =C2=A079.386223] round:0 todo:673
[=C2=A0 =C2=A079.387025] currnet process has not been frozen :Xorg pid:15=
88
[=C2=A0 =C2=A079.387026] task:Xorg=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 state:D stack:0=C2=A0 =C2=A0 =C2=A0pid:1588=20
tgid:1588=C2=A0 ppid:1471=C2=A0 =C2=A0flags:0x00000004
[=C2=A0 =C2=A079.387030] Call Trace:
[=C2=A0 =C2=A079.387031]=C2=A0 <TASK>
[=C2=A0 =C2=A079.387032]=C2=A0 __schedule+0x46c/0xe40
[=C2=A0 =C2=A079.387038]=C2=A0 schedule+0x32/0xb0
[=C2=A0 =C2=A079.387040]=C2=A0 schedule_timeout+0x23d/0x2a0
[=C2=A0 =C2=A079.387043]=C2=A0 ? pollwake+0x78/0xa0
[=C2=A0 =C2=A079.387046]=C2=A0 wait_for_completion+0x8c/0x180
[=C2=A0 =C2=A079.387048]=C2=A0 __flush_work+0x204/0x2d0
[=C2=A0 =C2=A079.387051]=C2=A0 ? __pfx_wq_barrier_func+0x10/0x10
[=C2=A0 =C2=A079.387054]=C2=A0 drm_mode_rmfb+0x1a0/0x200
[=C2=A0 =C2=A079.387057]=C2=A0 ? __pfx_drm_mode_rmfb_work_fn+0x10/0x10
[=C2=A0 =C2=A079.387058]=C2=A0 ? __pfx_drm_mode_rmfb_ioctl+0x10/0x10
[=C2=A0 =C2=A079.387060]=C2=A0 drm_ioctl_kernel+0xbc/0x150
[=C2=A0 =C2=A079.387062]=C2=A0 ? __stack_depot_save+0x38/0x4c0
[=C2=A0 =C2=A079.387066]=C2=A0 drm_ioctl+0x270/0x470
[=C2=A0 =C2=A079.387068]=C2=A0 ? __pfx_drm_mode_rmfb_ioctl+0x10/0x10
[=C2=A0 =C2=A079.387072]=C2=A0 radeon_drm_ioctl+0x4a/0x80 [radeon]
[=C2=A0 =C2=A079.387108]=C2=A0 __x64_sys_ioctl+0x8c/0xc0
[=C2=A0 =C2=A079.387110]=C2=A0 do_syscall_64+0x7e/0x270
[=C2=A0 =C2=A079.387112]=C2=A0 ? __fsnotify_parent+0x113/0x370
[=C2=A0 =C2=A079.387114]=C2=A0 ? drm_read+0x284/0x320
[=C2=A0 =C2=A079.387117]=C2=A0 ? syscall_exit_work+0x110/0x140
[=C2=A0 =C2=A079.387120]=C2=A0 ? vfs_read+0x220/0x2f0
[=C2=A0 =C2=A079.387122]=C2=A0 ? vfs_read+0x220/0x2f0
[=C2=A0 =C2=A079.387123]=C2=A0 ? audit_reset_context.part.0+0x27a/0x2f0
[=C2=A0 =C2=A079.387126]=C2=A0 ? audit_reset_context.part.0+0x27a/0x2f0
[=C2=A0 =C2=A079.387128]=C2=A0 ? syscall_exit_work+0x110/0x140
[=C2=A0 =C2=A079.387130]=C2=A0 ? do_syscall_64+0x10f/0x270
[=C2=A0 =C2=A079.387131]=C2=A0 ? audit_reset_context.part.0+0x27a/0x2f0
[=C2=A0 =C2=A079.387133]=C2=A0 ? syscall_exit_work+0x110/0x140
[=C2=A0 =C2=A079.387135]=C2=A0 ? do_syscall_64+0x10f/0x270
[=C2=A0 =C2=A079.387137]=C2=A0 ? audit_reset_context.part.0+0x27a/0x2f0
[=C2=A0 =C2=A079.387139]=C2=A0 ? syscall_exit_work+0x110/0x140
[=C2=A0 =C2=A079.387141]=C2=A0 ? do_syscall_64+0x10f/0x270
[=C2=A0 =C2=A079.387142]=C2=A0 ? syscall_exit_work+0x110/0x140
[=C2=A0 =C2=A079.387144]=C2=A0 ? do_syscall_64+0x10f/0x270
[=C2=A0 =C2=A079.387145]=C2=A0 ? irqtime_account_irq+0x40/0xc0
[=C2=A0 =C2=A079.387148]=C2=A0 ? irqentry_exit_to_user_mode+0x74/0x1e0
[=C2=A0 =C2=A079.387150]=C2=A0 entry_SYSCALL_64_after_hwframe+0x76/0xe0
[=C2=A0 =C2=A079.387153] RIP: 0033:0x7f91baf2550b
[=C2=A0 =C2=A079.387155] RSP: 002b:00007ffc673d5668 EFLAGS: 00000246 ORIG=
_RAX:=20
0000000000000010
[=C2=A0 =C2=A079.387157] RAX: ffffffffffffffda RBX: 00007ffc673d56ac RCX:=
=20
00007f91baf2550b
[=C2=A0 =C2=A079.387158] RDX: 00007ffc673d56ac RSI: 00000000c00464af RDI:=
=20
000000000000000e
[=C2=A0 =C2=A079.387159] RBP: 00000000c00464af R08: 00007f91ba860220 R09:=
=20
000056429d1d9fa0
[=C2=A0 =C2=A079.387160] R10: 0000000000000103 R11: 0000000000000246 R12:=
=20
000056429ba931e0
[=C2=A0 =C2=A079.387161] R13: 000000000000000e R14: 00000000049f0b22 R15:=
=20
000056429b93bfb0
[=C2=A0 =C2=A079.387164]=C2=A0 </TASK>
[=C2=A0 =C2=A079.387255] round:1 todo:1

>>  From what I understand, it=E2=80=99s usually writes or synchronous op=
erations that
>> do, but I=E2=80=99m curious if reads can also lead to D state under ce=
rtain
>> conditions.
> Anything that sets the task state to uninterruptible.
>
> --D
>
>>> (just my clueless 2c)
>>>
>>> --D
>>>
>>>> Thanks for your input and suggestions.
>>>>
>>>> =E5=9C=A8 2025/8/11 18:58, Michal Hocko =E5=86=99=E9=81=93:
>>>>> On Mon 11-08-25 17:13:43, Zihuan Zhang wrote:
>>>>>> =E5=9C=A8 2025/8/8 16:58, Michal Hocko =E5=86=99=E9=81=93:
>>>>> [...]
>>>>>>> Also the interface seems to be really coarse grained and it can e=
asily
>>>>>>> turn out insufficient for other usecases while it is not entirely=
 clear
>>>>>>> to me how this could be extended for those.
>>>>>>    =C2=A0We recognize that the current interface is relatively coa=
rse-grained and
>>>>>> may not be sufficient for all scenarios. The present implementatio=
n is a
>>>>>> basic version.
>>>>>>
>>>>>> Our plan is to introduce a classification-based mechanism that ass=
igns
>>>>>> different freeze priorities according to process categories. For e=
xample,
>>>>>> filesystem and graphics-related processes will be given higher def=
ault
>>>>>> freeze priority, as they are critical in the freezing workflow. Th=
is
>>>>>> classification approach helps target important processes more prec=
isely.
>>>>>>
>>>>>> However, this requires further testing and refinement before full
>>>>>> deployment. We believe this incremental, category-based design wil=
l make the
>>>>>> mechanism more effective and adaptable over time while keeping it
>>>>>> manageable.
>>>>> Unless there is a clear path for a more extendable interface then
>>>>> introducing this one is a no-go. We do not want to grow different w=
ays
>>>>> to establish freezing policies.
>>>>>
>>>>> But much more fundamentally. So far I haven't really seen any argum=
ent
>>>>> why different priorities help with the underlying problem other tha=
n the
>>>>> timing might be slightly different if you change the order of freez=
ing.
>>>>> This to me sounds like the proposed scheme mostly works around the
>>>>> problem you are seeing and as such is not a really good candidate t=
o be
>>>>> merged as a long term solution. Not to mention with a user API that
>>>>> needs to be maintained for ever.
>>>>>
>>>>> So NAK from me on the interface.
>>>>>
>>>> Thanks for the feedback. I understand your concern that changing the=
 freezer
>>>> priority order looks like working around the symptom rather than sol=
ving the
>>>> root cause.
>>>>
>>>> Since the last discussion, we have analyzed the D-state processes fu=
rther
>>>> and identified that the long wait time is caused by jbd2_log_wait_co=
mmit.
>>>> This wait happens because user tasks call into this function during
>>>> fsync/fdatasync and it can take tens of milliseconds to complete. Wh=
en this
>>>> coincides with the freezer operation, the tasks are stuck in D state=
 and
>>>> retried multiple times, increasing the total freeze time.
>>>>
>>>> Although we know that jbd2 is a freezable kernel thread, we are expl=
oring
>>>> whether freezing it earlier =E2=80=94 or freezing certain key proces=
ses first =E2=80=94
>>>> could reduce this contention and improve freeze completion time.
>>>>
>>>>
>>>>>>> I believe it would be more useful to find sources of those freeze=
r
>>>>>>> blockers and try to address those. Making more blocked tasks
>>>>>>> __set_task_frozen compatible sounds like a general improvement in
>>>>>>> itself.
>>>>>> we have already identified some causes of D-state tasks, many of w=
hich are
>>>>>> related to the filesystem. On some systems, certain processes freq=
uently
>>>>>> execute ext4_sync_file, and under contention this can lead to D-st=
ate tasks.
>>>>> Please work with maintainers of those subsystems to find proper
>>>>> solutions.
>>>> We=E2=80=99ve pulled in the jbd2 maintainer to get feedback on wheth=
er changing the
>>>> freeze ordering for jbd2 is safe or if there=E2=80=99s a better appr=
oach to avoid
>>>> the repeated retries caused by this wait.
>>>>

