Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF14BC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6D16B008C; Fri,  8 Aug 2025 03:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777726B0093; Fri,  8 Aug 2025 03:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666786B0096; Fri,  8 Aug 2025 03:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52C3A6B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:52:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A949161621
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:52:52 +0000 (UTC)
X-FDA: 83752823784.17.C8FC82A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id C7B1440009
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:52:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754639570; a=rsa-sha256;
	cv=none;
	b=bj7h32lHGzAUJjIVIj8C7qjSNHafEVaBA88aw93wodZf3VOSeJ2cftQIT4b4d/gLd/vFNJ
	FFYAUYSxxhjivo7Vfhe3Y0VrmCi7a+ykaMpU1wnZg5mLDCm0yyoDYd648Qfigy8aavL9Ok
	gYNe+XFA7CHijjSozLOP9c1AGJB5u78=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754639570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/2dZhq2Qy2sSATJbAU+7gVHKsPZccvnLlqFS5AqLg3s=;
	b=hzTsPruy2Urfl+04m+ACHaHSxHzhb/1sSR7kb6oC8e0DLz5Pk/GEbCO//Xy650h1e3CuJZ
	SijDmZtkrfewrSkipz+33PTi9tVcp8uS+IeFNpnf/5W+6JfpfD5o+No2a2ZrrLPfVN4QBt
	hvIpiKzXI7HgEnoRa6ZB1s2WaQdOBjY=
X-UUID: a8e010ba742c11f0b29709d653e92f7d-20250808
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:906a0f65-2426-4900-802a-89dc3ba00924,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:12be9df259196fe631b2eedfa1e50959,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 1,FCT|NGT
X-CID-BAS: 1,FCT|NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: a8e010ba742c11f0b29709d653e92f7d-20250808
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 931304093; Fri, 08 Aug 2025 15:52:40 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id A013BE0000B0;
	Fri,  8 Aug 2025 15:52:39 +0800 (CST)
X-ns-mid: postfix-6895ACC7-490838455
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 9AF52E01A759;
	Fri,  8 Aug 2025 15:52:31 +0800 (CST)
Message-ID: <ba9c23c4-cd95-4dba-9359-61565195d7be@kylinos.cn>
Date: Fri, 8 Aug 2025 15:52:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
To: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
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
 linux-kernel@vger.kernel.org
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
 <aJWglTo1xpXXEqEM@tiehlicka>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <aJWglTo1xpXXEqEM@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wmmthjus4un8yczhdbyg1463ck9ywukb
X-Rspam-User: 
X-Rspamd-Queue-Id: C7B1440009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754639568-695474
X-HE-Meta: U2FsdGVkX18K7w+Bfg3xKelivk/Km5uvbHf1sx5ENZ8CpX93apWRl78mS0SdI4nRlIxg+UgDrGxQltU2JFkZeHT8IawJfw0xjshUXHxHHiRwdEpZiKYLxDLWGmbTapslDCzVV6eXVy4McHbHW31OBLd8kMbErk+dptE/PgRT4jxQ2MYCI5W9ra8G0oqdaMOZBm5x4ifonrItsZ8oAd3ShUWLSzNBSfdgKMI/WuA5vesS0U9YFfd0itvRomgh0R3Lmz5MZXb45zSITOHDBunnpO/DCQxS1sOaWyoYZvtQhEDPHdLtCSKs6RvzXU8dFesDCquOuWFLuXu9nS8huSJrCTt8s3E3cBpkrQsvkmcBlTkAmfLBd8xfPUcUtW5nLsGDPXM0nQb/DvIoB5dgU/BW2JivRexHZB+nC+d0FJs5ghaedQVaOg3P3uWeMHIytYKicXy1KhLk8x4Y/SP5s3Zd4Lx/VjkEcnAsYkmuFtTA2ldwsx0cw5zHASkD4zRjYOy0U/hGKduLUvBFbZCUZoBSRwfsrvDmedDJ8hZyELRHYcxENtZGVRB2P7saKUzCMUppzzR5YJCADI9sgCThs4tvCbrQFNr2m0VbiPFq7fDfd/U2V3nA1HlyqUZ9kCF/WNkWwpPepOdQDA/940xMV8T+PappiQcJnxiVUUchcb2T55iMbSfnXm8A9GlWdiNAXj0iYr29Xw5I2hpK8JjSb+KVk66d6V1CA7nKOqUnn437s4iYggTPPHDneu/lyz5/Z34DllcogDFk0AkIwblcMfNXdhBUa7ggRlyo8wzhN9C9kOyAWADnEYoU97P4JO/6XhS/61+ZQ3OrjQpbCUzPGVr4MKyTauHK5LUBoSLaD1EWz+O0icS95gDLf5Cyi++Yuen6U8jT9FIwWy/i5tHsfdonD0AB+uNx9WzebH6aElNmD9MM++HSqOl7upEzP6/uvRKEKddb3XSOdklU1/Cxn7d
 gYxFJZ2E
 n2pqgDlTgPiCt4tboljpIEx2Ptda5omAk3D3cobP8MjGUMnSCdg7xNcpgLpHJ0CfHZdV6amZ2VLg6a3323WyoFJKH+N+xAISbAET4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/8 15:00, Michal Hocko =E5=86=99=E9=81=93:
> On Fri 08-08-25 09:13:30, Zihuan Zhang wrote:
> [...]
>> However, in practice, we=E2=80=99ve observed cases where tasks appear =
stuck in
>> uninterruptible sleep (D state) during the freeze phase=C2=A0 =E2=80=94=
 and thus cannot
>> respond to signals or enter the refrigerator. These tasks are technica=
lly
>> TASK_FREEZABLE, but due to the nature of their sleep state, they don=E2=
=80=99t
>> freeze promptly, and may require multiple retry rounds, or cause the e=
ntire
>> suspend to fail.
> Right, but that is an inherent problem of the freezer implemenatation.
> It is not really clear to me how priorities or layers improve on that.
> Could you please elaborate on that?

Thanks for the follow-up.

 From our observations, we=E2=80=99ve seen processes like Xorg that are i=
n a=20
normal state before freezing begins, but enter D state during the freeze=20
window. Upon investigation,

we found that these processes often depend on other user processes=20
(e.g., I/O helpers or system services), and when those dependencies are=20
frozen first, the dependent process (like Xorg) gets stuck and can=E2=80=99=
t be=20
frozen itself.

This led us to treat such processes as =E2=80=9Chard to freeze=E2=80=9D t=
asks =E2=80=94 not=20
because they=E2=80=99re inherently unfreezable, but because they are more=
 likely=20
to become problematic if not frozen early enough.

So our model works as follows:
 =C2=A0 =C2=A0 =E2=80=A2=C2=A0 =C2=A0 By default, freezer tries to freeze=
 all freezable tasks in=20
each round.
 =C2=A0 =C2=A0 =E2=80=A2=C2=A0 =C2=A0 With our approach, we only attempt =
to freeze tasks whose=20
freeze_priority is less than or equal to the current round number.
 =C2=A0 =C2=A0 =E2=80=A2=C2=A0 =C2=A0 This ensures that higher-priority (=
i.e., harder-to-freeze)=20
tasks are attempted earlier, increasing the chance that they freeze=20
before being blocked by others.

Since we cannot know in advance which tasks will be difficult to freeze,=20
we use heuristics:
 =C2=A0 =C2=A0 =E2=80=A2=C2=A0 =C2=A0 Any task that causes freeze failure=
 or is found in D state=20
during the freeze window is treated as hard-to-freeze in the next=20
attempt and its priority is increased.
 =C2=A0 =C2=A0 =E2=80=A2=C2=A0 =C2=A0 Additionally, users can manually ra=
ise/reduce the freeze=20
priority of known problematic tasks via an exposed sysfs interface,=20
giving them fine-grained control.

This doesn=E2=80=99t change the fundamental logic of the freezer =E2=80=94=
 it still=20
retries until all tasks are frozen =E2=80=94 but by adjusting the travers=
al order,

 =C2=A0we=E2=80=99ve observed significantly fewer retries and more reliab=
le success=20
in scenarios where these D state transitions occur.


