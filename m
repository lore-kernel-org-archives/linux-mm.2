Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F02ECD2F7CF
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 10:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00916B0115; Fri,  5 Dec 2025 05:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7F76B014A; Fri,  5 Dec 2025 05:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15136B014B; Fri,  5 Dec 2025 05:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC806B0115
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 05:04:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CD3B13ADBB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:04:38 +0000 (UTC)
X-FDA: 84184983036.22.6E012F2
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 68AC620007
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:04:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764929076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PGzF8xnT/iNqdvab6ITzTBFiEcR8V8izwzltzTW/dlg=;
	b=w8zHp0b76J+DLiZcNH7IlkMZw1hlvN4ZzQxesZM0KKR7A1KdcQHvshK473HlGkuqmjl/E4
	BMrEgcLFH078QBG1hshKKgBNhvMEHvtKSTQvDZsPowmOJisUBmleFBzsgsjLodcNiMxXMw
	YocEC8EyLC89PY1+IEl8vZxL7UI4+L0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764929076; a=rsa-sha256;
	cv=none;
	b=cYBgwOxiwBbX9Y1zhadWkd1YoF5JjsJnYCWNw92D0Xy64vkQYkwbqJT+z6ScFeJkx9mKtn
	u2gbadGzn2xlhmAt38ycsAgSFkYnTSg8jcb6lYB5HEL172K+fBDvjrsyG8hZY2tuFxULuZ
	iyE7F4NHX6ytnhdIMZ42fKcIkmfl6bY=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dN6Qb1GSTzKHMgp
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:03:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 726A81A1400
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:04:27 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgAH5k8qrjJpxiuzAg--.50456S2;
	Fri, 05 Dec 2025 18:04:27 +0800 (CST)
Message-ID: <bc10cdcb-840f-400e-85b8-3e8ae904f763@huaweicloud.com>
Date: Fri, 5 Dec 2025 18:04:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
To: Andrei Vagin <avagin@gmail.com>
Cc: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
References: <20251205005841.3942668-1-avagin@google.com>
 <57a7d8c3-a911-4729-bc39-ba3a1d810990@huaweicloud.com>
 <CANaxB-x5qVv_yYR7aYYdrd26uFRk=Zsd243+TeBWMn47wi++eA@mail.gmail.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <CANaxB-x5qVv_yYR7aYYdrd26uFRk=Zsd243+TeBWMn47wi++eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAH5k8qrjJpxiuzAg--.50456S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFy8trykXrykCw43ZFy7Wrg_yoW5Cw4rpa
	9rJF15Kan7Ja1Yvan2q3y0qr1FkrZ3Ja15Jrn5K34Sy3s8Gr1SvF1SyFWrAF1DGr4xZ3Wj
	vrWY93y7ur4jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 68AC620007
X-Rspamd-Server: rspam02
X-Stat-Signature: mmtfnetea7amdxd46bgp5jd1yzzi5ago
X-Rspam-User: 
X-HE-Tag: 1764929071-189670
X-HE-Meta: U2FsdGVkX19XVUOimoHNc3rr0aNN92hu7yeg4bPVpO9V3wSIgDa64uk4+vwPMFsNn+nUgXnPvvVt/95I/a1b+0X6CjWcmL6orytpEijvNtLubq5D/3dqGC5d8iiiXz5QSIKIAVuEVYjXxfDwYozn3e8YgoY4IqYQgwKxWUIEsznS0Ee9rbgpmZ4O6OJ7aJ5brEvc6Ej9eOBnuiQLNEIJpGS72KPMVENY9bJleeXi9ImLYZAMkqDpuhpulb+2QQE8IGnGuy5iOHrC7a2DWhRHnAiBNTmxYqkkyCxR+KCLOpBQ3VBaMqFSPrqHyPkH1mbLm+wwFk9Myt5rHF5bcTBD0p2ohtK/qVkDs/W+sYb0xRSljW2uln3t3tWqHmd35SUp/VjRCpC3f4g0awwTX/Q+QWC2LhnwFGcrHFdPzcChFIbwncQFvjVhYrXdApXvooSnoMAUJchaFPQWD2f44m7tjIYQhOHXGoWVeK77HWcxHWjglfj1SUECg+t2x+RLwwoEj+bFLdOdnJwWGoVj+omN0oS/PvWZZBIF7QA9VQR+1em2zlWBpGmk4F7h0El0tgaF5ZNxbtwkRyNtoNNAwaDSeJ6BPjtGyjuHY5g74Im9+fBeOK/2ZQd1ddbPd/upaePgBy+uyBnsrTv3HmuLHiPJPfvwcI/QJmxFuzNF0+lXNtGCBmLG5avQQ/4BOuVx0AfyCVzPA8InZ4rOCpohjOIY9D981p9iCeClN+lcRhL6rUwUAsmxs2dI2WD2m/7IIMd/2PRWB+C6ZHA5P72adaf7jcCVMixao3gnbXD5Mt5TUTq7PYJX9Jyu2WgTWkYz2M0ncLH44wgwVB5lHQ9lVyWPvDhDU+hOo4RM4EMgvEtDaQWKlTYOPM+n9u7dyYVzascWH4RhWrK0gy2koRX/zdhPDdRXv524AccBELV2bQgN+0Qj+/szEynX5uT1T+GbQiDSvq5dVC1T2HMZUm+2Jyl
 QqI5BvcG
 GjEEHCsj3zn3UNxtIywopWkmlU2/ZgqlFhH/RxQUT731HBe1vNqGNI5q7KavCKqvwpTdTCIdJDdUNH7+fPpbW3vdjlRRaZOrN1pxtCCcECkqop5THpq77yKCc4CzkrpnJzr2Fj8+jg7FlW4TfUX8Cg3LutpIbjIflGVaTEYjllvPnZsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/5 14:39, Andrei Vagin wrote:
> On Thu, Dec 4, 2025 at 6:52 PM Chen Ridong <chenridong@huaweicloud.com> wrote:
>>
>>
>>
>> On 2025/12/5 8:58, Andrei Vagin wrote:
>>> This patch series introduces a mechanism to mask hardware capabilities
>>> (AT_HWCAP) reported to user-space processes via the misc cgroup
>>> controller.
>>>
>>> To support C/R operations (snapshots, live migration) in heterogeneous
>>> clusters, we must ensure that processes utilize CPU features available
>>> on all potential target nodes. To solve this, we need to advertise a
>>> common feature set across the cluster. This patchset allows users to
>>> configure a mask for AT_HWCAP, AT_HWCAP2. This ensures that applications
>>> within a container only detect and use features guaranteed to be
>>> available on all potential target hosts.
>>>
>>
>> Could you elaborate on how this mask mechanism would be used in practice?
>>
>> Based on my understanding of the implementation, the parent’s mask is effectively a subset of the
>> child’s mask, meaning the parent does not impose any additional restrictions on its children. This
>> behavior appears to differ from typical cgroup controllers, where children are further constrained
>> by their parent’s settings. This raises the question: is the cgroup model an appropriate fit for
>> this functionality?
> 
> Chen,
> 
> Thank you for the question. I think I was not clear enough in the
> description.
> 
> The misc.mask file works by masking out available features; any feature
> bit set in the mask will not be advertised to processes within that
> cgroup. When a child cgroup is created, its effective mask is  a
> combination of its own mask and its parent's effective mask. This means
> any feature masked by either the parent or the child will be hidden from
> processes in the child cgroup.
> 
> For example:
> - If a parent cgroup masks out feature A (mask=0b001), processes in it
>   won't see feature A.
> - If we create a child cgroup under it and set its mask to hide feature
>   B (mask=0b010), the effective mask for processes in the child cgroup
>   becomes 0b011. They will see neither feature A nor B.
> 

Let me ask some basic questions:

When is the misc.mask typically set? Is it only configured before starting a container (e.g., before
docker run), or can it be adjusted dynamically while processes are already running?

I'm concerned about a potential scenario: If a child process initially has access to a CPU feature,
but then its parent cgroup masks that feature out, could the child process remain unaware of this
change?

Specifically, if a process has already cached or relied on a CPU capability before the mask was
applied, would it continue to assume it has that capability, leading to potential issues if it
attempts to use instructions that are now masked out?

Does such a scenario exist in practice?

> This ensures that a feature hidden by a parent cannot be re-enabled by a
> child. A child can only impose further restrictions by masking out
> additional features. I think this behaviour is well aligned with the cgroup
> model.
> 
> Thanks,
> Andrei

-- 
Best regards,
Ridong


