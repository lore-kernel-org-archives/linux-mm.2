Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC672C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539596B0095; Wed, 23 Jul 2025 05:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510CA6B0096; Wed, 23 Jul 2025 05:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44CBE6B0099; Wed, 23 Jul 2025 05:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E25B6B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:11:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D38455A12A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:11:14 +0000 (UTC)
X-FDA: 83694960468.01.2504F5F
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf14.hostedemail.com (Postfix) with ESMTP id 924D010000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:11:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ozY1M+gW;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of liuqiye2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753261873; a=rsa-sha256;
	cv=none;
	b=SfXyuclKohRthBGCmRgjaxxdsOvPPbLPjblroVxzSr7/qDdVT/ikXqpUe4ZJ+icKQIs3pH
	OJEJtiriGfJdgHaUlQ+s6vKGJLBrHZIP8ztMH8W4Qw4LvMCdkJ66a9mdMEEEuwkloenKrN
	WWgRMXs+VKLYz2njIExFZ8WNho2wOKs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ozY1M+gW;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of liuqiye2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753261873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6y3noge4MPktXIThvqTt61WWdx+cI0v3XW84889Wcek=;
	b=FYcEKkqplWsSgGaJvjPeecznhf13EmVgYj1Flv6Fc/KTgD8Acw41lAy+9LyjBNe5c+UUTw
	3jgGLvA59h23L2mahw0aanueXHmpLIoTwydMh7nVjoYvB4GQ8HFNy7z8F6AGrmHP/kbgni
	QVsp5NDUMA9HXQURUL42FqfbwltNJOE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=6y3noge4MPktXIThvqTt61WWdx+cI0v3XW84889Wcek=;
	b=ozY1M+gWZSKJxwvpVf7EFQKX9iJFlyU/BLza4jRksH84zYkkesidqJIcWlCGdZ
	5M3EodbTtmx45ahKPa7hNLimy3eZnc4kX2E7owhUb/IyxjFVhaxPmnHCCOhF8j93
	d/KchzBTfeBg50B55kOugp+elbxE0Bysw0i8vU8e5XgH8=
Received: from [192.168.22.151] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3u98Hp4BoV+L_Gg--.6882S2;
	Wed, 23 Jul 2025 17:10:38 +0800 (CST)
Message-ID: <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
Date: Wed, 23 Jul 2025 17:10:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
To: David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
 <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
 <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
Content-Language: en-US
From: Xuanye Liu <liuqiye2025@163.com>
In-Reply-To: <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3u98Hp4BoV+L_Gg--.6882S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFWxtFWkur13Cr45KF4fAFb_yoW8ZFWfpr
	4xKFsIgr4kJrWftrn2vw40yF15t397Gw15W3s8W347GF90qFy8XF4xtF4UCFyjyr95Ka92
	vr4jqF9rCa909FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jr2-nUUUUU=
X-Originating-IP: [223.70.160.239]
X-CM-SenderInfo: 5olx1xd1hsijqv6rljoofrz/1tbiRwSTUGiAkoh+YwACst
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 924D010000E
X-Stat-Signature: j7mfg4oidxfc5xo8139tgmgyzgrbx5ih
X-HE-Tag: 1753261870-582883
X-HE-Meta: U2FsdGVkX18Vv6HrXH1U0DkEj6G1mgSY/GJ76ahsSQWbthbp5HV7zRo/SBSAYYuBbJTd4Zdsfu7vRaknGbl6GIl+sqlQcwKzTqqDzmnERCzdjWkbg28v0aoh0fN5D/eI1eNUGC8Nm7v2Q6VoV/fgMe/vxuSI3zj3Tm4Q09LO3HrI/KVw8jjdp2TgNstplf2SQTHY8N/W1RuFhvtLDj6QR6HnJageoU4LBMM5kTxwAS547jIQZ/IjoFrW/em80EOufJNpy19m3kqP/GOR7i+XZ5aYm1WpFJzSsUuwVf6VdfvBFReylSTnL6nt+BIo6S7KEbnBVsajICibETKuUPqEhXSchMR2qh6gSZOjipbZ9R1PY9T9bTuHRaiYlrA0+Gg8NsklzmK99+M1+nPYmDgRt91uWXxWUrYqhAFlC0uQlcW+QAM0ECxM1URgTds66QZVEYEfBfFkeemvvS0GFTQSgFy25Mv1PsuKEYkePnYJ7ebM4E/iSeKTen/1xMvXzlnC01daE1u4OD5mHYysffRVi+rUgNs82gSPsuTzK4tVlQHYQoLcRBZgOtuXlGRHLWzx6ycyuDqxIc1M1r6FrXsHujSQinTj7JBnjDvJpKNI7FyEnPTqlfeEUMH2pmYrihdeWTfdBlcP/6tNDmkRhAzPWEO/Q2+4RlZ6gNKqP0WuAFGUNjVGnYJcVnv3iUgjzPk3FYyH54K0fVffvC9j/cDOQyN8WyIxIX0Bw2psq32t6rDJDepI3Rjgc6b2auADMBF70C5FCZGCU6V8+9jklEjMicImEg0uUU3d9P8RF6e5VsEhVDsZE6HxF8zLnALVw0nYwt/1zAuE30UvgUog0y3MlpFcx9Ros4SSMjFe1LSxu7nwifS4e1isbRM013vVwcwn3W76zvgADxyTTKR7PRYZriguVu3q5Fr+IlKFlA/1SOMp/VZLWgs4AfEGc6H4Kt5Nf2Ee48Mw0ZwKz5dKvAj
 YQnpb3cu
 yedo49Wqpk3PriNt1dgi0qJCTzqhtfFBm6n/YxKyzLDDo3qD9BaPn/6HpBSfSONMwdeD2/jlmB7/cKXfgona23bBUklnc8Z5OgvDjbexl38Ra7LQTL+erSeFDOXdGm2FhFRb4qxsDWktgyNulECTwqWDct7El4fXlyDz6nJFD8VxxZzOFNBhYBV8p9fYxEUAmENRkbmC/yFAoLwfwuJPzgrmd3XClRA3g3T2BBXcTApY3Q4vEAKcffEfdbUHgNi51/0nSob02Uen5NTjU7ASpMl+4SGoOsY26e5WRYxhMWgvab9Yu5RH1rRmrKAFTQFlnrfUyjg/1Dz+OSO35CVHEMeTqKmoQ00IquJ1kdlxeOojTS/cfTtXpPcK0tcoBJkwEBMZhdWebVkBTPHfDzDIlv/uLYa6ehjfntI3oI6qzFphVPZWDAaD4LLvVV+pYacbrsxjiS+OKkodLvPMYCVzxGnHfWUtNgVPfr91jVEB3BQ6WM/9pBFGNBmnziA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/23 16:42, David Hildenbrand 写道:
> On 23.07.25 10:05, David Hildenbrand wrote:
>> On 23.07.25 09:45, Xuanye Liu wrote:
>>>
>>> 在 2025/7/23 15:31, Kees Cook 写道:
>>>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>>>>> The check_mm() function verifies the correctness of rss counters in
>>>>> struct mm_struct. Currently, it only prints an alert when a bad
>>>>> rss-counter state is detected, but lacks sufficient context for
>>>>> debugging.
>>>>>
>>>>> This patch adds a dump_stack() call to provide a stack trace when
>>>>> the rss-counter state is invalid. This helps developers identify
>>>>> where the corrupted mm_struct is being checked and trace the
>>>>> underlying cause of the inconsistency.
>>>> Why not just convert the pr_alert to a WARN?
>>> Good idea! I'll gather more feedback from others and then update to v2.
>>
>> Makes sense to me.
>
> After discussion this with Lorenzo off-list, isn't the stack completely misleading/useless in that case?
>
> Whatever caused the RSS counter mismatch (e.g., unmapped the wrong pages, missed to unmap pages) quite possibly happened in different context, way way earlier.
>
> Why would you think the stack trace would be of any value when destroying an MM (__mmdrop)?
>
> Having that said, I really hate these "pr_*("BUG: ...") with passion. Probably we'd want to invoke the panic_on_warn machinery, because something unexpected happened.
>
The stack trace dumped here may indeed not reflect the root cause ——
the actual error could have occurred much earlier, for example during a
failed or missing page map/unmap operation.
The current stack (e.g., in __mmdrop() or exit_mmap()) is merely part
of the cleanup phase.

Given that, how should we go about identifying the root cause when such an issue occurs?

Is there any existing way to trace it more effectively, or could we introduce a new mechanism
to monitor and detect these inconsistencies earlier?                                         

Let’s brainstorm possible solutions together.

-- 
Thanks,
Xuanye


