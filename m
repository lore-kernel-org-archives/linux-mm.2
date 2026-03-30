Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4F1FF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CBC6B0095; Mon, 30 Mar 2026 03:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4226B0096; Mon, 30 Mar 2026 03:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120AF6B0098; Mon, 30 Mar 2026 03:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03CB76B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:12:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 661495A877
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:12:55 +0000 (UTC)
X-FDA: 84601862310.30.75DC3E1
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf16.hostedemail.com (Postfix) with ESMTP id 863AC18000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:12:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=p229gL7j;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774854773; a=rsa-sha256;
	cv=none;
	b=OiEeXTK0uOD9tVzDx7bmN3xdpSoxCiHXc0pNvbQSeWOdQgo22fO/wxcIMIQTRRi3pnJws3
	ACbg1zikElumt0CjJn2EtpP4HtnZNSirg0iirqF5jOGmdYXDGRGMNGF9e+6K229xmfo21V
	OKcyaK1EBjTfb72KhN/58ftEBE+HTMw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=p229gL7j;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774854773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxHhFY8CnfVycioBKVd9CORZwlMpeneq2TR+IbnwoHk=;
	b=wm8NHIoxa0tQI6P/iJBa2mwoetMkQICQE/eVS5tolW295LMMFPqE4OsVcDNB1sSW1I6QtI
	L9WztOZOx7499IJzi6vfFrLKf0SgIFr9hhWBBfuiRXz1u81yyGAPaCPqiYasatGgnREIRd
	TU4ida6ZlCnEIdnQYSXxECTgxvaVXF8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vxHhFY8CnfVycioBKVd9CORZwlMpeneq2TR+IbnwoHk=;
	b=p229gL7j0wh9odCIlSr4SdDEvlLtoODBkFb+g8QtwXSNn7qpbpMOkxoprw60uisKi5It8Mleb
	jpAMIeWBTgqRAVwstD5ooinNDY7bnJP2a7ur7uWYyGsDChMLOS/1doh9OYTq31EpQ2oKvksuq+5
	jELvT8R9KL13EDZNkSqg5xQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fkj3J3YzTz1prKT;
	Mon, 30 Mar 2026 15:06:36 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D383440561;
	Mon, 30 Mar 2026 15:12:47 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:12:47 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:12:46 +0800
Subject: Re: [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
To: Lisa Wang <wyihan@google.com>
CC: Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan
	<shuah@kernel.org>, Hugh Dickins <hughd@google.com>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <rientjes@google.com>,
	<seanjc@google.com>, <ackerleytng@google.com>, <vannapurve@google.com>,
	<michael.roth@amd.com>, <jiaqiyan@google.com>, <tabba@google.com>,
	<dave.hansen@linux.intel.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-5-92c596402a7a@google.com>
 <78a855da-8fc2-4e85-90a0-6bf9af030c02@linux.alibaba.com>
 <acHeLL0l948jRchK@google.com>
 <52c26e05-5bbc-4f63-84bf-c4879a6de7d1@linux.alibaba.com>
 <accjlG9lUyDQO_mz@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f822616d-ad09-e408-147a-503381cd3333@huawei.com>
Date: Mon, 30 Mar 2026 15:12:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <accjlG9lUyDQO_mz@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: uabm71trtbtb9gcria67peq3jttonxgt
X-Rspamd-Queue-Id: 863AC18000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774854772-427427
X-HE-Meta: U2FsdGVkX1+zlwFJBRSN+zpibF1twXDik4TSWdDX1iMKOmeXkSQDel2Y3KfqF6OdKtvAZEeh/QT3KFKJ4QmFXCAG5KfLoWVD7df+VL2CaKYP6FCQlpluGLnk8bp/h3aU3WNfdjHhbHyRWscSG0R8mUPeipaMmEcutafaJrEPY4zs46gUnQrtaiY/VGA7a+WyFIUoM1Io9v0FkEqQxzf3b+rcPpy9NwsA7Wadu3Qn0zvOHWE9OdWLNOOVB67Af56DsfuaA8SMBguli9/Wi6EsCGJsNTSNHrxQGmzaGEzmtNJpSxu7Q5GDb5gjxZB7fGa/DwP/LQSVp5aMYPXiMEf2TF2284T36Pfuwrzr5NIqN0zVNkU0FOAtZ3uNUbDSzrQqudQU0N9Xjgs94Z/a9ytsL9aRmGh6ctzPX84GFIviDVtLA6GquM2iu4G+23t+sLi40e4XJl9yiWdgDiJcPxADZUuHU7KDKFITGihW+QWMcxKwr6ACHq++hU7dD1QT8/w47NyONl2nyUJKHtPSS5xCL6XsDEzexnHdczcKWHyh+Ozqn6bRd5XoYwHOWgNovfPEUoPVZxdILSbc3xFB22zw3KV0e4rrTkQ97sypz1eeSVitic6mcN+zgN4hA7NhXVdK/pEvRdJ89gp9ezonEfHIufJK/J+9qWN7PXSMDIo9QlxpdEx8R7yknCLyDTkJVXHbmfuGfcs4zprxAeoHZbmJWz1858cf/GRETPchTCC5gRUQeQMBzq4i0htZ6EswBLd9lyWIVu4RBLJYxlPQS8bE9rxpUtpVWveaDFKDVE+XURbiURF6waTrzUmAQzMYk6B0ZQwDkYJQ2bYmLSttrpNz5/kzB+76O/tY1eLknijjxeGyxEW+js2di+CvQ0ntMKXoRUI1+f542+QmAroZy/tK1uQdwRski6V/JRmqu4Y+dueGXkFad5y4p8CtwitX9WbQF8L0CCcScWfE5ihs6aB
 WV+9kcPV
 TlfqszqVDDWuYzlUgQIHh6QF1wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/28 8:40, Lisa Wang wrote:
> On Tue, Mar 24, 2026 at 08:36:36PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/24/26 8:43 AM, Lisa Wang wrote:
>>> On Sat, Mar 21, 2026 at 02:30:04PM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 3/20/26 7:30 AM, Lisa Wang wrote:
>>>>> Add a shmem memory failure selftest to test the shmem memory failure is
>>>>> correct after modifying shmem return value.
>>>>>
>>>>> Test that
>>>>> + madvise() call returns 0 at the first time
>>>>> + trigger a SIGBUS when the poisoned shmem page is fault-in again.
>>>>>
>>>>> Signed-off-by: Lisa Wang <wyihan@google.com>
>>>>> ---
>>>>
>>>> Why not move the shmem memory failure test into memory-failure.c?
>>>
>>> Do you mean let memory-failure.c kernel code check by itself?
>>> The reason I write the selftest instead of combining in memory-failure.c
>>> is because
>>> + do not need extra checking code in kernel code
>>> + make it easier to trace the entire execution flow, starting from the
>>>    madvise() down through shmem_error_remove_folio() and into the
>>>    truncate_error_folio() logic.
>>>
>>> Pleas let me know if I've missed something. Thanks!
>>
>> That's not quite what I meant. I mean, since there is already a
>> memory-failure.c in mm selftests (see [1]), I think we should move the shmem
>> memory failure test cases into that file.
> 
> Got it. Thank you for pointing out.
> Is anyone currently working on the shmem memory failure test? If not, I
> will merge it into my next version.

I'm working on shmem testcases. But please feel free to add it. I could move to
work on other scenarios.

> 
> I have a question regarding the current implementation:
> ```
> ret = sigsetjmp(signal_jmp_buf, 1);
> if (!self->triggered) {
> 	self->triggered = true;
> 	ASSERT_EQ(variant->inject(self, addr), 0);
> 	FORCE_READ(*addr);
> }
> ```
> Here is difficult to distinguish whether the SIGBUS is triggered by the
> injection or the read operation. I am considering splitting these into
> two separate SIGBUS jump blocks. Is it reasonable for me to split them?

It might be better to add two separate testcases, i.e. one for SIGBUS triggered
by injection, another one for SIGBUS triggered by read operation if possible.

Thanks.
.

