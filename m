Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1A7D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 00:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92216B0005; Mon,  8 Dec 2025 19:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D431F6B0007; Mon,  8 Dec 2025 19:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32246B0008; Mon,  8 Dec 2025 19:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0BDA6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 19:58:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DE21133AAD
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 00:58:52 +0000 (UTC)
X-FDA: 84198122904.26.899DA59
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2F6BB180010
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 00:58:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765241930; a=rsa-sha256;
	cv=none;
	b=SuzJDOMZFHP4e4l2osyr6aDkTs9ioBy8R8uaxt5Q39Yx0S4Wh8Olr30wuL6HoHxrFm+M2y
	jy8oiEPuFDe1eP2L/tha3mU0G07i4mVxm1lXDINxa/+539tcR3PKMcfadpeHSlsF7PlaAz
	Cy/pwvYyG6vn096WGbN8iks7NXCuwvc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765241930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tib9TGK/UC+x3df3zki0aTVD10jsG2qaH+by+JtaEIg=;
	b=LKR/+A57itg0iEIMKRbHJqIcZir/EYeVR2CRIdH5ToTDI3W8L/BTvs/xr/AfYWk73XYY5x
	Jh1GJ5Oa8rsTnHHeQKmehWNt7s1VmnNp4q3bHcmqau/FEDJl+b9lhzLekQX7UNu+jovBs/
	zRr81yoxyf0QSnFgJ4Dn8crvE5fvzMc=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dQL6t3DL6zKHMM9
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:57:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 3CE7B1A08DC
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:58:40 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgBHJlA+dDdpiONbBA--.18208S2;
	Tue, 09 Dec 2025 08:58:40 +0800 (CST)
Message-ID: <075ad534-9a76-4067-97a1-a3219fa4c60e@huaweicloud.com>
Date: Tue, 9 Dec 2025 08:58:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrei Vagin <avagin@gmail.com>
Cc: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
References: <20251205005841.3942668-1-avagin@google.com>
 <57a7d8c3-a911-4729-bc39-ba3a1d810990@huaweicloud.com>
 <CANaxB-x5qVv_yYR7aYYdrd26uFRk=Zsd243+TeBWMn47wi++eA@mail.gmail.com>
 <bc10cdcb-840f-400e-85b8-3e8ae904f763@huaweicloud.com>
 <CANaxB-yOfS1KPZaZJ_4WG8XeZnB9M_shtWOOONTXQ2CW4mqsSA@mail.gmail.com>
 <6dmgfe5vbbuqw7ycsm4l2ecpv4eppdsau4t22kitjcjglg2gna@dyjlwhfhviif>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <6dmgfe5vbbuqw7ycsm4l2ecpv4eppdsau4t22kitjcjglg2gna@dyjlwhfhviif>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHJlA+dDdpiONbBA--.18208S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4rAr1fJr4DAr1fGrykZrb_yoW8GF1xpF
	WkC3W7Gw4kJ347ZaykZ392qF4FvFW8AFy7Jr15K3s3AFW7u3W8Ar4ftrW5WFsxXr9xC3W2
	vw1YvrWfuan0vaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F6BB180010
X-Stat-Signature: mxnatoffuwryseyamtsqemtaepdggbm3
X-Rspam-User: 
X-HE-Tag: 1765241924-131076
X-HE-Meta: U2FsdGVkX1+xm/jxRX017hvIkCX/rqI2m6cv2adujtipffaiNY+xt49VGnojGboBIvM7+4aPrp0kYWRsxCa9hJRFsUOADo+bfGc0Y/astcHOOoi8YQQDeZJ5oUnTjSTIH+XGrensktKp5Iu9jhFtJ+olYFG0oNScgYovWuqGQ7HL1SHRj1GtVMElAvr7wO7nSzQ0A84WsIMfNrBX/PBvuPL6wtiNVfrS+fypm0yYJWw0xyvBCOV6kJS1h/cfxWnLyfWqgq2JdbePGEJw3b/fLmTrafgaQSd3TtWD07OERYmcTZNdcBcMMz6rw5VRSx58FqqN6MBiK+ctqXduEK63SxYtlye9mr72rYcFItbAKbeod2XR9V2dmH6JsKp0wbfCPLqZAUhuBAau7jX1mY4kccwNVLAR9rE29NY2ZZCi9MhC3+PyD+6oXNPH2BmkmHP4ShqzjLgl9qoBShiZrE0a8Mo17nlObWC1pJ818I3KdyUrD2gSUbX8qPcz10kJyJTaARs1fKGePCb+jpVrMpD2OSGodo8F8jZa5x0S+m8nWkxFRxKnQRaJ1WrSXPsWe74EgOwSBTw5FF2HLmpONyc2Bodhg2j71LzFQHf7Q/di5LY0fZqUgXqtZUmgap45QO02MIWZpjt2+7kg9EsZii5fsGH7FLyxFo+2xAJU5LDrc9iv+xnWPtwGtwmeliOSxfwkv70oUfgNTcHyYT6wlaWfpHsguxc0dFu7Fvw4lVD5ZVUTg6pj17paDH0IptJk3m959qPew8IY2jtS+JRqxu1cgtW5arw/P3NpvLUTFRUh23/PbSgHMEBw/Nr2uGhUIfjy5sQdzkoX4QGeUv/0U8Jo0i5+yH+JplZuwYOSPlughUAC1i7dWcJNvEo0IYJngcIlaSKSCIq72VNJqkB99zy6co+XZ+VWpunndqb0h1QWou3GOXA21rACFcN6RHenV4HT+E40LDiOjY4ZTspPupk
 juPAN3la
 nAW0P1q3DTW7a3qYO50WYyvnQI7QC+SLmA90tTqDwnGy/B/WQ31PLP8DX0q8oh0vndvaCt9Mjv4nvckq4EKl+60/nXLL/9u942BOlfrK+3DLQBrfc+LkPDrJ0kL6Kkjocw4k8sXu9UlOTOTJyrmQCsIjNTHpkYkSykbjyKowtGisqUHQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/9 0:48, Michal Koutný wrote:
> Hello Andrei.
> 
> On Fri, Dec 05, 2025 at 12:19:04PM -0800, Andrei Vagin <avagin@gmail.com> wrote:
>> If we are talking about C/R use cases, it should be configured when
>> container is started. It can be adjusted dynamically, but all changes
>> will affect only new processes. The auxiliary vectors are set on execve.
> 
> The questions by Ridong are getting at the reasons why cgroup API
> doesn't sound like a good match for these values.

Eh, The statement "it can be adjusted dynamically, but all changes will affect only new processes"
means that processes created within the same cgroup could end up with different capabilities. This
does not sound like how cgroups typically operate;

> I understand it's tempting to implement this by simply copying some
> masks from the enclosing cgroup but since there's little to be done upon
> (dynamic) change or a process migration it's overkill.
> 
> So I'd look at how other [1] adjustments between fork-exec are done and
> fit it with them. I guess prctl would be an option as a substitute for
> non-existent setauxval().
> 
> Thanks,
> Michal
> 
> [1] Yes, I admit cgroup migration is among them too. Another one is
> setns(2) which is IMO a closer concept for this modified view of HW, I'm
> not sure whether hardware namespaces had been brought up (and rejected)
> in the past.
> 

-- 
Best regards,
Ridong


