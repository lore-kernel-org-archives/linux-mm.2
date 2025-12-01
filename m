Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF521CFD376
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 02:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15EF46B0012; Sun, 30 Nov 2025 21:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136756B0022; Sun, 30 Nov 2025 21:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BDC6B0023; Sun, 30 Nov 2025 21:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E50D06B0012
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:49:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 837A51A0B95
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:49:40 +0000 (UTC)
X-FDA: 84169371720.15.561D651
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26C2D14000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:49:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764557378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p9NL5wUh2dS12g99RQyCxsHZ07ddXfYUXqkWRaHw8Jw=;
	b=VTW6F28AKyAgLWTAqtwRaYrhcMyj+D+6EZ8lr6RZcIZ1q0UW9aZFeHdv3Bw091hGN8bRBH
	obIJBEwqYtVr9GCvfH3V5+5EljeslAhyl+tR//JHUUDNrAt2JtzDv1zXskjHfTWldmR2au
	Tn7begClYM/lPg3CJuDafDE4J3GuboM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764557378; a=rsa-sha256;
	cv=none;
	b=Wke0FOh1eZfAsv+hsd2CFWABEHKwjpDRjZyFDTIIwX0C/v9SICVMQCabpnkNk5/fV+90i7
	pvGecxAMMua4y8ItvpaawDM2T2Aq2jVlLXIRVOJAH0BVxZZC4wu0WLnr1qZOxbAb743UYl
	QvADDmKTjePlbrsD/FSc5tpqLmxly2g=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dKSyj3tjMzKHLxp
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:48:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4D6DA1A0847
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:38:51 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgD311G5_yxpf6i7AA--.50711S3;
	Mon, 01 Dec 2025 10:38:51 +0800 (CST)
Message-ID: <7970e1c4-88d5-42ef-b8cf-ed50d27fedcc@huaweicloud.com>
Date: Mon, 1 Dec 2025 10:38:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Al Viro <viro@zeniv.linux.org.uk>, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: Will Deacon <will@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, jack@suse.com,
 brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
 linux@armlinux.org.uk, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com,
 wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <aShLKpTBr9akSuUG@willie-the-truck>
 <9ff0d134-2c64-4204-bbac-9fdf0867ac46@huaweicloud.com>
 <39d99c56-3c2f-46bd-933f-2aef69d169f3@huaweicloud.com>
 <61757d05-ffce-476d-9b07-88332e5db1b9@huaweicloud.com>
 <aSmUnZZATTn3JD7m@willie-the-truck>
 <b6e23094-f53f-4242-acb5-881bd304d707@huaweicloud.com>
 <20251129035510.GI3538@ZenIV>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <20251129035510.GI3538@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgD311G5_yxpf6i7AA--.50711S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4xJF4DCrWUGry5Ww43GFg_yoW3ZrX_W3
	y8tr4DCa43ta1fAa15GFW7ArZxJw42vr15KFZ5Xws3K3s2yFW8C398Kwn5Zan2qFWYkFsF
	9Fn3Jr17Cry3CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 26C2D14000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zsc161a1preg87s4fbm43zagbgne3rnt
X-HE-Tag: 1764557375-907327
X-HE-Meta: U2FsdGVkX1/T1LITGGqXQuaqtgKAYPDa6c7Hf8m94p3VRsTQGo3bHCB82C+2695Mu6fJsXovu/t+z46405p/3KRLKtxTqTKoS1G9oKz6wna8+wxQq3iFjJs3+FzTugM7LHqVlteX/HwmygXoGBAZIe+Kz5iIISXRFRrOda5/+oKiAPpYAC9UjhGhAPEjXpMoEJUokkd6WNBLgmzSRg3Rs2ZhL7TXS3KIwCcXmVTVLiqa2RsTWYBSqrC/4qlqLi7CCJgt8/0ft4MYDSWkjjdHOQ8TImDkkwwmsSFW8lqtgieOLBtn+7yO6bJPn+iCDLX3rf3cUI7g/aAHc+4j35weoJd8W2lfM438cwfJQMPftw+WxizldyLy7S+2XTc7Pt6Xz3MaZ6fpY4U0kif8lg/cPgjwrYu8KDE3l/qRiS3fvfyEzwPwpQgT3yX+vT02gsRXv9z+2Qst7I7QuqMYO3Fb5gQ6XN9UcevUt8CFovEl/sOP8ZcApGCzke0ujbjrU5pcBY8xmITutjWZZxhmiJKNU0i6Wfhyod3W9AJcOXXAeNE+Ypyzks/9J2MjA2G8cfLDoVSZJDSf6urszcAUA6YoVUZuCYIIa54fbl2CG05hgYNwSxASz0Vd47oSmh5Ev2N0+Teb+mFotnmv+/0U8JVbmP0GoYaiaPL11lud6AZ9u8hc8rT/NXXoZbeQdvfHZPbq3sA53BwWqTh5u9FywofuxrjvvgjOrbLgvITek2ZjdKCCbXjvOOmKqE15SINYokaonAXRK4z6BXktfAa+bLqqq+y+U00n5LzfITP3ALA5kCoZxmq8irm5q5wlXIKkxufN69uGYu+Bgli2tOgBaNlMw3LWyqA/weMvb674Ppw/vBbL3doJWtpAVjSaRBeHaHKwnBvr/s2STr9bNQWIkCQTSOa4ovR2ox5JKgpCZm+VMYn6I9NgaGAj95EcNFJeZCb2ebOR1mX4MKo/AZuV8FL
 8ofP9dh2
 3LJflopHUmKmOvmf+LKkKips3N8veBjaQA71IIZc24aLzl9XrixtnytAyusY1g4/w7Ckr4DE/bWcfUyAlnbb8fEgTL2G8WcBxWVtttmmpgbZTls8sBLbfoeqvOX6BG00sCngIF1VRX6cCSzlsRm3PPrjUa1kg0XCnr0jFeI1rXD/tJij4/B7Cl8ctsuxYT5dSJMqB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/29 11:55, Al Viro 写道:
> On Sat, Nov 29, 2025 at 09:02:27AM +0800, Zizhi Wo wrote:
> 
>> Thank you very much for the answer. For the vmalloc area, I checked the
>> call points on the vfs side, such as dentry_string_cmp() or hash_name().
>> Their "names addr" are all assigned by kmalloc(), so there should be no
>> corresponding issues. But I'm not familiar with the other calling
>> points...
> 
> Pathname might be a symlink body, sitting in page cache or whatever
> ->get_link() has returned...
> 


Thanks for the additional explanation — I indeed hadn't considered
symlinks. But if the data is in the page cache, as I understand it, its
address wouldn't be in the vmalloc area, right? However, for other
.get_link implementations, it's true that there's no guarantee.

Thanks,
Zizhi Wo


