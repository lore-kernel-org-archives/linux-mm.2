Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C92EEF30A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 06:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560B76B0088; Thu,  5 Mar 2026 01:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50E5F6B0089; Thu,  5 Mar 2026 01:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410C16B008A; Thu,  5 Mar 2026 01:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED956B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:47:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 799241CD0A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:47:02 +0000 (UTC)
X-FDA: 84511077084.05.827B3D1
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC046A000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:46:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772693220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KBzLmxLFISMaPVR53DCctVWiyFz73uVy1acwA5FIjhg=;
	b=KPHOBLwkJqVe06t105dXHpBLJGuQVFnPCrN80na1UL8rWeYleAEOH7gNEGeWSStb66+oTG
	qkd3bo7DyixQkYs8q7ZRXuuqsXqcKFa0/tixIZcSQ5Vi8hbrArQfBXWjpHT66tgMVLVjRp
	6UPQV1QWpkcqQ0bWDXQ1aGCAYSocaOw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772693220; a=rsa-sha256;
	cv=none;
	b=lGC1hD26/TkETaY2RlpNWKFXfYEJRTwKF8k7HqY9xhP3AHcG9KzsCs/JueyzVYzXhf9Zke
	JZ03O+CFAq50NXnc1X8hCtzzfsIhAoXQGqMY5ldRfPN1yfEXfp+b0Ua87z9F3DwXmtUN8x
	eaBDqa1sLoEn8znNuF3rxihX8AXHKiQ=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fRKnv0ZglzKHLyJ
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:46:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 30F6B40590
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:46:50 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgAnlerZJqlpHcL3JQ--.8749S2;
	Thu, 05 Mar 2026 14:46:50 +0800 (CST)
Message-ID: <f8105107-b5e4-48b5-8ac3-8432104f2049@huaweicloud.com>
Date: Thu, 5 Mar 2026 14:46:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Kairui Song <ryncsn@gmail.com>,
 lsf-pc@lists.linux-foundation.org, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aaBsrrmV25FTIkVX@casper.infradead.org> <aaHaSRXNLJNLwvKh@linux.dev>
 <CAJHvVcgU8ZgJAymFfxr1FC_bf6gB0mpr=VTbtSdFqY4iVB-WGg@mail.gmail.com>
 <aaZjADxC7amOH7tB@linux.dev>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aaZjADxC7amOH7tB@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAnlerZJqlpHcL3JQ--.8749S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr17XFykAF48Jw1UKr13XFb_yoW8XFW8pF
	W5tF4UKrWDJ3ySqryvyF12gF4FyryxJrW3Xr1rW34UAF98KryrKr4vkrW5uFWDuw4SyF42
	vayUuF9IqF98AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbiF4tUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: DC046A000E
X-Stat-Signature: yffgnfmyj963xpoio64pziknctceb4xn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772693216-744334
X-HE-Meta: U2FsdGVkX19Kg7vcSzkcQqD9q4KitdHqP0+pddlhOhKdPViKZQIdUj0Vp3yu/gI/3D+jotJkHxzt2XomqwUtgV3Wlv/DaJCoNF8xdTVBkLZBC2iAUNUT5bhbnOBBCtZA/57yTQNx1LgZyXRCZarQx+q8VS4TX3UnVQVlwh5m30mF2H33cum3ZxSwdi3656o7J0aWjupiXhBmMav68bAAVh3dNg1l9aSqjIkxIHvJieNvjje0T2IDgu5MR5qH/xsa+umv3FdgS8mB125ye/Mr5b32sbUNS/UbutxTitACUvlFdDkCO9bX/8xB2h0dmLa9JmUmHXyDy1qCFmMdEODGz5WoZwQc3NowVu1g2wUxtzP6xDaiYqhDKZBa39c8BgzNaHF+p2LnOjer9w6YI+WSmSCPAefB4D6QRKzCRuz+oZ+6y4qlRNysfH/S9Ge87z+XB5JT2PbXt9hp+Hxgfq3FtZVuZxLuNxUQMeHIR3tGrzo5vPVAf7vv9ti1P13fnPZnGgRhW3DuALMFZy3JabV7cRUebqnVOmsk1ZQzm9DwyXuWw+Pk2Efiiuh5XizVywZvTzfucwhsa5PMdwxvYzatkUW2DqVmrxjzDUfgKFS+ikj80FwPtptHqhbfB0A0nh6YSR4MNAYxVU+d9xteGctu7z6bKOIrnsh7cJFeqN+NN3Daeg97h9mUX7kOwYpSGf9yKikmbB0TzvAH0p7yjJdnBThVC86w/2pDiBRsgJhN7/ZzcaY5ZGoL+qfJCITsqeSo4FzXNTaQruBTFUE9C2B0ssGA69qZL+/xfgpjmRbnS2XWv8cPUPaCA1pCPuZm1aql4+aBn+9m3PmK9Ti4rbHCsJhBqUbA2eFLtJM+kqB84XclPD3fveOcarPwRISlSIQujHX8YBHUfChZtN+c3YOFDo/DihKZdPV/UEy1qa3iMRYQgQIvfPsKwRJ/v/rASwlPfNavlCd0kbyxiyhhDTm
 R1jfrDwn
 GVmInWifnndMBbHYRwVVBCqNJysVTdhuVBHI1qrGOeF7aQ5Yz1Ys0CEiAmC/k6kAPkAE8XiA5gNp1Iq0+LOFN+JaJRNVhEmA5HRrdaFyP0vXtpfPyUWozZh2EwXFlxDe9wInahDgNAx1HvK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/3 21:39, Shakeel Butt wrote:
> On Mon, Mar 02, 2026 at 05:31:26PM -0800, Axel Rasmussen wrote:
>> On Fri, Feb 27, 2026 at 9:56 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>
>>> On Thu, Feb 26, 2026 at 03:54:22PM +0000, Matthew Wilcox wrote:
>>>> On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
>>>>> MGLRU has been introduced in the mainline for years, but we still have two LRUs
>>>>> today. There are many reasons MGLRU is still not the only LRU implementation in
>>>>> the kernel.
>>>>
>>>> To my mind, the biggest problem with MGLRU is that Google dumped it on us
>>>> and ran away.  Commit 44958000bada claimed that it was now maintained and
>>>> added three people as maintainers.  In the six months since that commit,
>>>> none of those three people have any commits in mm/!  This is a shameful
>>>> state of affairs.
>>>>
>>>> I say rip it out.
>>>
>>> I have very similar concerns. Though rather than ripping it out, I would like
>>> we put efforts in unifying the two reclaim mechanism (traditional & MGLRU) over
>>> improving MGLRU.
>>
>> Shakeel, I think this is a great idea. If you have any ideas around
>> low hanging fruit here, please share. I'm planning to invest much more
>> time here going forward, so I'd be happy to turn some ideas into
>> patches. :)
> 
> I think we can start with memcg LRU on which Chen (CCed) was working on. Also
> why not propose a lsfmm discussion on the topic, I am sure many folks will be
> interested.

Think you for cc.

I am very interested about this topic.

-- 
Best regards,
Ridong


