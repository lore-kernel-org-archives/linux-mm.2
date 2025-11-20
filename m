Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0058FCF884C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 12:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32AC66B0024; Thu, 20 Nov 2025 07:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302306B0029; Thu, 20 Nov 2025 07:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23EB26B002A; Thu, 20 Nov 2025 07:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11A076B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:27:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EF975B74C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:27:39 +0000 (UTC)
X-FDA: 84130911438.19.E4204DD
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 024B11C000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:27:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763641657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N6QP3pWtwQIjXYz5EpyhrgpsLVbdYIhbCjFMg9hTc6U=;
	b=NZpamLGcHpzyfxsIxBHTs8/Ay3yGAZTQBXCSkWHl/8K7hhuUzZV9HaZQChDRwE77c5pqM9
	6s7+AabNlgvTtxCl+MhucBn1Qj5kQBATKklNYikEmmIU3+0+XLGdmVSBndoKKWeeKvp9XE
	1q8Cz81k8ncjI7eq3iTN6KplbKymu9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763641657; a=rsa-sha256;
	cv=none;
	b=7b4g00+wd+lLPjN5mHfbQBp97aYk8GYjm7BGZFNl5tU61QEtxKg+Ee7ymVQwpiBRbO/HE8
	aHxFg0wVF7WJ9eMx/uT70NvIHQylwyJ6lzw3RYhE8feGmTvFdo+noC7jTLsMOMDcZhBs1D
	OQ8wKjBe3epMskLx2rHRx5jpCgLX6gQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dByJy63gMzKHMVS
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:26:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7E4041A192F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:27:28 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgDnIkwvCR9pshiPBQ--.57953S2;
	Thu, 20 Nov 2025 20:27:28 +0800 (CST)
Message-ID: <82c22c02-35ab-4dae-b764-c694ef203a68@huaweicloud.com>
Date: Thu, 20 Nov 2025 20:27:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/26] mm: rename unlock_page_lruvec_irq and its
 variants
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <f68f1ae435edbbc6cfe15448c2df5c4112a4a61c.1761658310.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <f68f1ae435edbbc6cfe15448c2df5c4112a4a61c.1761658310.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgDnIkwvCR9pshiPBQ--.57953S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZrWUJry3AFW3XF1fAw1xAFb_yoW3Gwb_Aw
	1fCwn7Zwn5JrZxJw4Fg343ur109ay7CF1DXrn09r15tF9xJw4kXF4vqwnag3y3JFsxZrZF
	9rn3Xa1vqrnxujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: zcjcg3tuh9ecqdj9mywgi4t9c4hbksjm
X-Rspam-User: 
X-Rspamd-Queue-Id: 024B11C000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763641652-848037
X-HE-Meta: U2FsdGVkX19Aj+TI+OyXv9PRmjChiwbePclZe2f15OY9S8QU0t4XPrjIk9aWlhUsSB1Kb0Aw3NJdC54tcwRuOdkK+rInR4VevsX615Ee7FvHBGzzO/JOTtySW2Pht7H0aBBw9FMmgFdpQXR5CUJ3iP87Hlsg5VBlZv1KE8gfk8th9SNEic5SzAMfgs9MsBq1cK/4QcHtkkNg15iH20sPfyodWX+a+7UjWwvJIbzRneIO+oCaUs1+qIQ4Wg+anmqaMgybNE1w1rjqF4cplvKZuHHzDdqoTWR5wU/6IUBMsoWk4erbYBeWDhMlbccFLZIsKLcu7XyDJMUCcuV8ID1E3TS47rX3PR0+mNcTwdp2ZkfGOVsccP937g+Vl8/HkfQiB/mZIU6ODao8WdKEdod+Bl3VaCuP5Ye6a4+usDhDayGVTs4mihR/Ln6gkr95JMbPgcNSLsAKDQizDiuS6PbwKUCAaYR3keIJK//pFTQMQXsCwMI6M96AHvLgQq78W050i8kqLfU7o2SglInGp50yCBAcnV/SL7hzWnUZQx3NE8/DZmjGhIHzKIZuVkiw5sGYs/7GYP8mH7wdJLbtdcOGtxsD/fVDH5tbsop++gxw9EqzrG0F2afb+oD7n+VU71nNkV/41azADH3znyR85dBqNEhLNj/7WdWJYJuID7QWGVKhAyOpmBkyv1muHAbyVNeRBwjTE0GDBL00m1bXUG+XZtzhx41Evg2HgX+Pl7Vys/V+Lit6GUr5C/gqkQWKychiuuIrJLlLdOyPBvNAo1qs5zBcVHrxsmQtwP5SQGuSVumYzmt3gkinV/ZkJpUPdEzyGd0GGxHdUaOVIuCMSxyzCL70SwLEewbljEFexRWhi2SgdnpPlQTIVSqQvwAOiBN7ZK2s8ri5n+LsJCjHTFM0RZoYJGOwre4mpN5aVqa7ZEs1Mm3Dj0IOynW1nJ+BbOhMoGGL9gEsvLTl6sDV2VA
 OMcNHlWv
 c0w3jBwton41T2mQMYuKIDJurKQCxhRfsArX5oAz88U6Qc0DYlYv7XfGxayukR98tcxcXiIlIvANLmBR8UtSmUScwcSklUwcn1idhvLbuiocKN0pU5BPHEPvii3juEXtiShGfA1eJbJnzIoXwbBRguKBuGiJ0DNgGpoKp7K++4cUsu8xg16zlLQrO4esBz+qlBV5j2xBcRMkb1THRdb5GdHyRLf/sA9ZTJHyrzYmnW7c86pG3LbLvd9ou5bSQvqZ0KKfw3c1TYVFbJ7T8Z0EIn92SAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/28 21:58, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> It is inappropriate to use folio_lruvec_lock() variants in conjunction
> with unlock_page_lruvec() variants, as this involves the inconsistent
> operation of locking a folio while unlocking a page. To rectify this, the
> functions unlock_page_lruvec{_irq, _irqrestore} are renamed to
> lruvec_unlock{_irq,_irqrestore}.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

LGTM.

Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


