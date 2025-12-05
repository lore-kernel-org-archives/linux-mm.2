Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C2ADD2CE0C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 02:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4716B00AC; Thu,  4 Dec 2025 21:52:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CFD6B00B3; Thu,  4 Dec 2025 21:52:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615626B00B1; Thu,  4 Dec 2025 21:52:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5026B00EC
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:52:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA85AB8D35
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:52:42 +0000 (UTC)
X-FDA: 84183894564.21.5EC918E
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id ED4241C000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:52:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764903161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kFYPW1iEwNz9FkH/1oNW1eCXTNrv2h+XJVs8kzZiSyg=;
	b=D53Z7L1deO1iqRoVl81iMAIiyxeIRVoriZeedq/84fuoAGj39QJS80osU4QGHJDTaLbOKp
	OIXutY3q23XtB2pJpSKJWC6SmZq+BU720aWpHxQbJrda9ffqtDe5UsOjrYiS6LoCWYQkDK
	Gi8ri6B3M1qJsdMDnmk+mNxOCS4pLLY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764903161; a=rsa-sha256;
	cv=none;
	b=EMxJj4rJULEcN0q1SQZAqXkteCh4DgPqM4GsH9QoRbQ36l6MQ+QvrfcNAOOggOXrkJ/Wm4
	9Z/B4CIjraMNucRHdi6b6aNUOu+izCt7TjWG+HVuI+i/MNVXCfLSf+beGRYFd28AxD7Sk+
	S2+4bs5aqAZZrgA7jd+50lt49TSsoNM=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dMws43KY2zYQtlH
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:52:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 7B00D1A09DF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:52:30 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgAX91DtSDJp5tiPAg--.44550S2;
	Fri, 05 Dec 2025 10:52:30 +0800 (CST)
Message-ID: <57a7d8c3-a911-4729-bc39-ba3a1d810990@huaweicloud.com>
Date: Fri, 5 Dec 2025 10:52:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
To: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
References: <20251205005841.3942668-1-avagin@google.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251205005841.3942668-1-avagin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAX91DtSDJp5tiPAg--.44550S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1DXr4UXrW8Kry3Jry8Grg_yoW5GrWfpa
	ykGr13K3Z5tF1fCa1Sq3y0gr1SgFs5Gr4UCrnrJ340y343Jr1Iqr1Iya15ZFWDGrWfZF90
	y3WY93sxuw1jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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
X-Rspam-User: 
X-Rspamd-Queue-Id: ED4241C000A
X-Rspamd-Server: rspam11
X-Stat-Signature: npqdujfmkw4kj1q4d19zx4gut9qia45p
X-HE-Tag: 1764903155-642735
X-HE-Meta: U2FsdGVkX1+mFp9lcLN25l2i0iNk8iP9oSJ+/JzzqxRAsBYok5Tv+Ccy+VGQVO5C+xx8+eysBZv6G0ZwGA8kYxuGH6hLY7urLCZPZmyAE6Q3llUcGKhLr0/Z4rEHdWm0miKE5Mi5crYEDM0difCcNQatk7NEC8EXvGfeZpznQSEeSdXaYKeSLMmXERESogE1UfOeqzzMm1S5AgnPvp4RBysRBepJ/m1fN/igWCWT9ewdRJ6YPicmN0cVI4ZUyGxcc/r13AW7Iq1drxkh6ZQ2zBy8diIzh0DHo0E9IN6Wo4/os8C3H+UqxJaNgBzR/XS4q6wofWqkmcXRpD9mcyxRHduRuib+W8dzqguwMWwCuzqfn01kwv+OU7etj2iD4wIwVvUFMkJmOgIz/KrYoZbcauUtuNqQgWKc8VO0JQJ8gN2BwzOysutJ0yfdlbba7W6hy18xPLuZGTFxpZnromhWvb4MyFNvpnt/zr/A1q3A2UxwRF7YqvrUzNlpzj5ZSIhw3O+vyAMKXaPiKT0BeF9NmFY31ISHFyphZeeMNjhamddVLbVeLsd2pMKj7hurjpAg6jaJfSaUE0bh7P0d0jDS3JVBqhpU/6NIxWTgBbe0/Hf22XLJ7GF0Eq0D1zQ2yg0SG28TFaQMdY3BR+AGjA5WLiVZkMo2r+JicnHAPkkRG+mpCbHR02to7/Keylf4jyr4aE6zGQPYHFMv0P8XHaqyANr/10V6cktAAZVmTuoEJL5gvRsojomzPJlECk5xKLNZnlSh0nrTnceeQwga0ZA5wVTCp4bpOn8sAAtCgTYl8tUwq5GGUxLNqIv6UeiUkFoqGw4npcnvOdlpdmBt0J0D0YfBDzLkVbCU6j57ZMOZTFM7MGzQmM9J/hlIyWT3+BpWyx6djarpAXXBoIGOfgflcnbsC1bLqtjGFlPJu2AW+igkPjDxZLAhr4aJR0VormeVts0xCS6LT5Np1ktMF2G
 oNAqfjCb
 CbiHgM1m24rb7+PUAn2UjJFZ9qX508s1IIT0PFnTf4VN3RPzffra1wQWlOaJ4KNNgq6jNzf7dmWydQzCTZaGhxMO+fRB29SC7B94F/Mg0EeWXFogOCe9YQrkP9U4DDunLGU98fWpYwBvn4FgS0lZMLSOj4lqLphx+fWKemXtgj6Sar8qYOPsfCR87vwHEfzdW5H73XEBarpz7ZU5d4EQT0MfemgJRVvt+i09Lo79H+RTXiHbaONJ/Asy5J2coM4nJEnwNbS2aepfdwk3LptoS8LHv3sMedPIyYITTbceaS8DPfoRWAzya38/CKaPSNM25qUI2mGMXMK9QHI0Y3a28fTafupKmpKfLuMuxMmxTt+LunRnfDtakBUf9zQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/5 8:58, Andrei Vagin wrote:
> This patch series introduces a mechanism to mask hardware capabilities
> (AT_HWCAP) reported to user-space processes via the misc cgroup
> controller.
> 
> To support C/R operations (snapshots, live migration) in heterogeneous
> clusters, we must ensure that processes utilize CPU features available
> on all potential target nodes. To solve this, we need to advertise a
> common feature set across the cluster. This patchset allows users to
> configure a mask for AT_HWCAP, AT_HWCAP2. This ensures that applications
> within a container only detect and use features guaranteed to be
> available on all potential target hosts.
> 

Could you elaborate on how this mask mechanism would be used in practice?

Based on my understanding of the implementation, the parent’s mask is effectively a subset of the
child’s mask, meaning the parent does not impose any additional restrictions on its children. This
behavior appears to differ from typical cgroup controllers, where children are further constrained
by their parent’s settings. This raises the question: is the cgroup model an appropriate fit for
this functionality?

> The first patch adds the mask interface to the misc cgroup controller,
> allowing users to set masks for AT_HWCAP, AT_HWCAP2...
> 
> The second patch adds a selftest to verify the functionality of the new
> interface, ensuring masks are applied and inherited correctly.
> 
> The third patch updates the documentation.
> 
> Cc: Kees Cook <kees@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "Michal Koutný" <mkoutny@suse.com>
> Cc: Vipin Sharma <vipinsh@google.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> 
> Andrei Vagin (3):
>   cgroup, binfmt_elf: Add hwcap masks to the misc controller
>   selftests/cgroup: Add a test for the misc.mask cgroup interface
>   Documentation: cgroup-v2: Document misc.mask interface
> 
>  Documentation/admin-guide/cgroup-v2.rst    |  25 ++++
>  Documentation/arch/arm64/elf_hwcaps.rst    |  21 ++++
>  fs/binfmt_elf.c                            |  24 +++-
>  include/linux/misc_cgroup.h                |  25 ++++
>  kernel/cgroup/misc.c                       | 126 +++++++++++++++++++++
>  tools/testing/selftests/cgroup/.gitignore  |   1 +
>  tools/testing/selftests/cgroup/Makefile    |   2 +
>  tools/testing/selftests/cgroup/config      |   1 +
>  tools/testing/selftests/cgroup/test_misc.c | 114 +++++++++++++++++++
>  9 files changed, 335 insertions(+), 4 deletions(-)
>  create mode 100644 tools/testing/selftests/cgroup/test_misc.c

-- 
Best regards,
Ridong


