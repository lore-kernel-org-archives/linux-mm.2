Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32832E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 03:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975796B0088; Sun, 28 Dec 2025 22:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C4E6B0089; Sun, 28 Dec 2025 22:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7856B008A; Sun, 28 Dec 2025 22:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5FC6B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:54:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 065FCBBC38
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:54:02 +0000 (UTC)
X-FDA: 84271140324.02.347247B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC031120005
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:53:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bHxGPZK8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766980439; a=rsa-sha256;
	cv=none;
	b=LG/3ThPEkDqlCGkJWQFqRrmdhlF6YyFEL7BSFHJEdFgplUk3Cb+wKVxLMKblZ9bppByPMl
	R2AYOLF2zBxTWG/0LwimbuJlJB+x5bkVlLXQ9Wy6fOSwRzvI3MPY/M9VViWgRNX10Hbpcb
	7wA1pPSuGLop0g9YD2XXdY8LOFlebxw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bHxGPZK8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766980439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CS1U9kbXClTn3ClPyOJkBE6Q0JxlFOFOmyrM4XYp2Bs=;
	b=axcErL9p/fEp6eCg6VYvXsg0NyayBHgF/Xc0QwFesDlLXFeUaJboDyZ1NebeMzz/J9F6nj
	3lEFVJhIty5hkluYQvRoiJBlXahqIawp0ao/jYDpNPhhSTXN53DjTP8SbWwtEvgmw4Sg4z
	bq/I+1y7bQ2fpqUeU0Av3dq6+AY7y5M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766980439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CS1U9kbXClTn3ClPyOJkBE6Q0JxlFOFOmyrM4XYp2Bs=;
	b=bHxGPZK8uY9B+oZzcnIuGnenTpDh7lwb3MLMQHD8B4/4bEBs6gYBcgrMfEZ9jZRnJQLUnZ
	VY+oVuyAUKMkO3SFxeWLt96LcxcSNdS0bGO3kXBOX18nue5NTcPnwsk+CjGB3djHe+tzvR
	FqNmV6Il8roVx9V4rjbqWjQ5YDouUNk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-gtvajlrTONuO3TGFzwRO1A-1; Sun, 28 Dec 2025 22:53:56 -0500
X-MC-Unique: gtvajlrTONuO3TGFzwRO1A-1
X-Mimecast-MFC-AGG-ID: gtvajlrTONuO3TGFzwRO1A_1766980435
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b993eb2701bso9083018a12.0
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766980435; x=1767585235;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CS1U9kbXClTn3ClPyOJkBE6Q0JxlFOFOmyrM4XYp2Bs=;
        b=vosTUW3LWNzV7yeVOY5y3O1vYv/jf3p5X0IyKsapNCvC3Set7uiWPRY2APM7sMSWns
         rYfUN5b6swhh8XSGYbqa1tzCq4Pl0OAJ4/TOte3iPzaq+QAmBHh04ql64SErk+XBglr0
         lqJ8nJQ9sW3Vdt8kntNubpQw3E+mfGM2UbEANXi4cWe63y1ycKOoW/QImMkkqyiLATf7
         z1NWkVRr3NWD9+dummUMi6nbUs0fqr3llgCQkAz2ZH7vznh7T/vQDjznf7pNzczt6su8
         3Ku5joRkh8/No3AiWI9Kr9MKyddjCkXpBc86FLnDQk5O77M7DtrsyuHOoeHSv9jcFa6f
         1pCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF3u6GxkvfkzrtUH5d5W4LCtUeVbEDZjwDCQMXBJqnW1SoAOWipXKoVwFbdxzGbLfurvZa0VZk+w==@kvack.org
X-Gm-Message-State: AOJu0Yy9dSf9DuX7oS+dgysY6V7dR9DPka7i/H5yG7mS2+T/GE9vWqRK
	ipwLjUHUdj1FgHxBYyzXoeM4RptRMZO7OsodpPDsjVq4BGrgbxP2M7Id6/emdelE0hFX5VLJskg
	FeEpVU/UfPQigL/bp9BGFSF80Vf7TLVPuGN+33BqU1VUgqcPKHDIi
X-Gm-Gg: AY/fxX5v/AO6lRyuON/JdRgPVt1/foZlqH15+kG+JM9dVHg82Z8C26C9OnXfj05L58A
	Bz1AxNl3UrETb1xlMn+Zkikc3tY6WwqhGmJN6aEE3L3uClriffq0wRKGrpc6QhyvL0fGajBhqCu
	EuCQMZuQ8lC6sUjgonGcPGx+fCy/OR6tEgC8fWtg5D67VH4KwVdFBiCVfWCUKrfKb10i01gJXrK
	cALKvb2zz3+KBnFj4L04FNvolrFX+lGohV+cFfLesKWITt8Fwiu5bIbYs22G3bu/abmCJuBWl4Q
	JwRY5yoDpCCNAPJi9l2AyU1WCrRcCrasasILwCjQXPtw7zY3YVmT+NjLS2g3V1NnDiJRGE80q0v
	na+pGoiX76X1dnJw/+B7aGlAwSCOYh8+LSHrNaaw/CAXW3UG+OyUQBOW9
X-Received: by 2002:a05:7301:508a:b0:2af:7429:e53d with SMTP id 5a478bee46e88-2b05ebf88e5mr14193619eec.10.1766980435153;
        Sun, 28 Dec 2025 19:53:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwUgAvkgKwyfAg/XY7OmY8/35HtixZhtufU5RpA+DoSNpJWPgIxTe0gLEz02J7RhXsL5qbsA==
X-Received: by 2002:a05:7301:508a:b0:2af:7429:e53d with SMTP id 5a478bee46e88-2b05ebf88e5mr14193600eec.10.1766980434676;
        Sun, 28 Dec 2025 19:53:54 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05ff8634csm69342683eec.3.2025.12.28.19.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Dec 2025 19:53:54 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <81f201cc-395a-48d7-a1b0-db8c62b93c9e@redhat.com>
Date: Sun, 28 Dec 2025 22:53:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent isolated
 cpuset change
To: Zhang Qiao <zhangqiao22@huawei.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-2-frederic@kernel.org>
 <e01189e1-d8ef-2791-632c-90d4d897859b@huawei.com>
In-Reply-To: <e01189e1-d8ef-2791-632c-90d4d897859b@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _b0_F9TcHBQH3ndCsUjGvSnN18-l0Awnnq8Rid3ghPY_1766980435
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AC031120005
X-Rspamd-Server: rspam10
X-Stat-Signature: jnhddn9aucjeukejgj4o3gwjckbszytg
X-HE-Tag: 1766980439-281251
X-HE-Meta: U2FsdGVkX19VcdfFi8GzK8t6pNOcCorqyoh7Jxt6MsdGONYRMH8uLYi+HAI3IDPBlMS1zey4IDUU3iQ2sW1KEuEx/qYcwkWs3CLcwzJ/iqaTudBn1opjCjOqqN1r9Qsgo1dqeu3I93JT1/yV0Ayw4ypEBDIs99xHf53yIBP1Hc4s6+c0i8fuVkBk0iFKMNJV368icHuJIfRkZcp7q2MYjkbpPKPvk7or24hd3x2RFgaJ4kwM7cYG7KcqGe3P1z7Nzu3A0a671ABLDQYBlI2/6qUQqm0eDZr0i4z4WWuB3KDA/zIt89ddoS35t5SFKxg2VdXYk3yimPyKazrlObhYIsAdRTvSbRPYyfQvJ8XBoaC+KM4+WnEtfZVjn1mgs/aVTn+x2EDFZb77JDk9k5Ybz6hbYN0KzOkgPTnR2jA7j44wDgVEnO+vGwFcMbeWMzvkU1ljfHZ2TYMVGgXNPrD/HSdLeW19U2GQaO6SO0cEZUTGt6qnH8Juf+cWZrk01fsAd34clqYMAXjj1jgrUMm2f14t4yLneZ1BIgUhnEe1RiyTSoGhcMKsUbB1Y7PS3Nu9txDUUjyLUh1ngsfWfSNM6a322cATiDG61jNP2Az16q+p4ZNKFqNmUwZw4P7KmJQDEGaWqkLqlx/PCuVHaTdavaxvzfAAFc/IRgFsDjgg8drhpPYnmD0I9cFE8/dAAUAR4prEdJ/Iy4ErnnRRXNacD1LXW3nGvYFmsQmyObqqVJgVGYYoG18Qpda/HpbXeZkxivdt7U8uQpY58cJB4RKO83UzLdWxHA47PEv0WlTqslLjag9GmkWkDZrAde+qacaKcCcZFryE+5rpeltvh0ABaVJQ6OlFU3L7KsyF95QPybhCr2Z7aw3omZE3myeDeEUQXxdJU9a/PtPeubSCaAg4HTpVuaMgGdMnt4Tjl1XE94aa4YMH80jxySHQU7/2vQSNv2yY5v61qBdo2YQy5Dr
 RbhSJFx3
 8A3EvxzWUoogEn3yaFBkK3dpgZxSnaTLtAotsUJj1+qAZAmU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/28/25 10:23 PM, Zhang Qiao wrote:
> Hi, Weisbecker，
>
> 在 2025/12/24 21:44, Frederic Weisbecker 写道:
>> HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
>> therefore be made modifiable at runtime. Synchronize against the cpumask
>> update using RCU.
>>
>> The RCU locked section includes both the housekeeping CPU target
>> election for the PCI probe work and the work enqueue.
>>
>> This way the housekeeping update side will simply need to flush the
>> pending related works after updating the housekeeping mask in order to
>> make sure that no PCI work ever executes on an isolated CPU. This part
>> will be handled in a subsequent patch.
>>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>> ---
>>   drivers/pci/pci-driver.c | 47 ++++++++++++++++++++++++++++++++--------
>>   1 file changed, 38 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> index 7c2d9d596258..786d6ce40999 100644
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -302,9 +302,8 @@ struct drv_dev_and_id {
>>   	const struct pci_device_id *id;
>>   };
>>   
>> -static long local_pci_probe(void *_ddi)
>> +static int local_pci_probe(struct drv_dev_and_id *ddi)
>>   {
>> -	struct drv_dev_and_id *ddi = _ddi;
>>   	struct pci_dev *pci_dev = ddi->dev;
>>   	struct pci_driver *pci_drv = ddi->drv;
>>   	struct device *dev = &pci_dev->dev;
>> @@ -338,6 +337,19 @@ static long local_pci_probe(void *_ddi)
>>   	return 0;
>>   }
>>   
>> +struct pci_probe_arg {
>> +	struct drv_dev_and_id *ddi;
>> +	struct work_struct work;
>> +	int ret;
>> +};
>> +
>> +static void local_pci_probe_callback(struct work_struct *work)
>> +{
>> +	struct pci_probe_arg *arg = container_of(work, struct pci_probe_arg, work);
>> +
>> +	arg->ret = local_pci_probe(arg->ddi);
>> +}
>> +
>>   static bool pci_physfn_is_probed(struct pci_dev *dev)
>>   {
>>   #ifdef CONFIG_PCI_IOV
>> @@ -362,34 +374,51 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>>   	dev->is_probed = 1;
>>   
>>   	cpu_hotplug_disable();
>> -
>>   	/*
>>   	 * Prevent nesting work_on_cpu() for the case where a Virtual Function
>>   	 * device is probed from work_on_cpu() of the Physical device.
>>   	 */
>>   	if (node < 0 || node >= MAX_NUMNODES || !node_online(node) ||
>>   	    pci_physfn_is_probed(dev)) {
>> -		cpu = nr_cpu_ids;
>> +		error = local_pci_probe(&ddi);
>>   	} else {
>>   		cpumask_var_t wq_domain_mask;
>> +		struct pci_probe_arg arg = { .ddi = &ddi };
>> +
>> +		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
>>   
>>   		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
>>   			error = -ENOMEM;
> If we return from here, arg.work will not be destroyed.
>
>
Right. INIT_WORK_ONSTACK() should be called after successful 
cpumask_var_t allocation.

Cheers,
Longman

>>   			goto out;
>>   		}
>> +
>> +		/*
>> +		 * The target election and the enqueue of the work must be within
>> +		 * the same RCU read side section so that when the workqueue pool
>> +		 * is flushed after a housekeeping cpumask update, further readers
>> +		 * are guaranteed to queue the probing work to the appropriate
>> +		 * targets.
>> +		 */
>> +		rcu_read_lock();
>>   		cpumask_and(wq_domain_mask,
>>   			    housekeeping_cpumask(HK_TYPE_WQ),
>>   			    housekeeping_cpumask(HK_TYPE_DOMAIN));
>>   
>>   		cpu = cpumask_any_and(cpumask_of_node(node),
>>   				      wq_domain_mask);
>> +		if (cpu < nr_cpu_ids) {
>> +			schedule_work_on(cpu, &arg.work);
>> +			rcu_read_unlock();
>> +			flush_work(&arg.work);
>> +			error = arg.ret;
>> +		} else {
>> +			rcu_read_unlock();
>> +			error = local_pci_probe(&ddi);
>> +		}
>> +
>>   		free_cpumask_var(wq_domain_mask);
>> +		destroy_work_on_stack(&arg.work);
>>   	}
>> -
>> -	if (cpu < nr_cpu_ids)
>> -		error = work_on_cpu(cpu, local_pci_probe, &ddi);
>> -	else
>> -		error = local_pci_probe(&ddi);
>>   out:
>>   	dev->is_probed = 0;
>>   	cpu_hotplug_enable();
>>


