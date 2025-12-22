Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2276E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 07:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B646B0088; Mon, 22 Dec 2025 02:40:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEC86B0089; Mon, 22 Dec 2025 02:40:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30AEB6B008A; Mon, 22 Dec 2025 02:40:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFB76B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:40:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4D00C13E3
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:40:55 +0000 (UTC)
X-FDA: 84246310470.04.E0D6621
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4AE16100002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:40:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766389253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMpY5oOiUlDXQx27BoX5WSh5ZYKfSdYo6BoksTqjwAw=;
	b=wRBP/xT8fjRMvWu1kbiRIwSs043vx0sZ4828gcYdkHBdMi4pIi1SC8sNEriJYKP6lpi+2y
	UUj/ErXSkCY+Mp+eiOv4r6I+WGFRNa4DJ2Gypz6YhrBNMq2N+wa32GMt3BawLY8FrviOeu
	t6NReXrIdythNBhJ7DWXslEitTcdwvE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766389253; a=rsa-sha256;
	cv=none;
	b=Zt7ExeHtt2N4k/HVF8HKrI5kEcRD4I5lor2dfL8Jtlmrc2TA7q1XFlOGhZ44WGMR/A/ypD
	feZYJVPDCHLYMFIuKEx/9s7RdwD1xh2pGC3P2sYbgonRoy3HiFf52havUDlfEJ92xsOLhV
	yDu49hFTmb5xztFDGeIlOypLumG4LW0=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dZVRf2RZlzKHMKr
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:40:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C04A64058A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:40:46 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgC3F_j99UhpLPhCBA--.61919S2;
	Mon, 22 Dec 2025 15:40:46 +0800 (CST)
Message-ID: <f9593c1e-feda-4c03-a1c9-7e84637819f8@huaweicloud.com>
Date: Mon, 22 Dec 2025 15:40:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 4/5] mm/mglru: combine shrink_many into
 shrink_node_memcgs
To: Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, lujialin4@huawei.com, zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-5-chenridong@huaweicloud.com>
 <20251215211754.GG905277@cmpxchg.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251215211754.GG905277@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC3F_j99UhpLPhCBA--.61919S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1DArW8uw43CFy7tw17Awb_yoWDArgE9w
	1FvF1Iyw1UCw4vganrCrsYyFnxGF17CrykJw18XryxW345Zry7uF4kGF93WFn2grWFy345
	Cas8ZrySkry3ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxo
	7KDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam02
X-Stat-Signature: ybwn4pqcbbaxgnncfppejt8yh96eaiar
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AE16100002
X-HE-Tag: 1766389250-148915
X-HE-Meta: U2FsdGVkX1+wwUlchEezPppbySD0Uv8f6/BWZwG3yG66W5+p6gYbDhDqy2w6+WoBhOvmrdpEi+VTScmMTFiEHdrOhx0X0Vyz9NdXEgZD584GdrH5c+Pneb7e+BhGFuL/KZQKFKfZLVdtS/9Co3t6FwvIlziTnFsePy5n0vRPE4VXJHDZU22wEkDf4+r4UjcMRDGrt4XQv2pM+ha9FMnaoO8jFJf3SrHqLclqdqGiwvAqONXsltkSFqA1AKdHmUBuzw9dh+uMIkZc3UASJK3+6MgPL9Jbu5XoLVOsXYapIer1DlriLeqIhpBsAETDcT5EDJWlr7hpyKjVTl/BamMmS4jXaF1twTrVUlDoEdxYxz27dyJKzvqJybNZx5aNa6mK8+Up8vWYL+O8JQEnfCys9i/NXejl8dRIDUH2+q5SdWU1i1iDiAnCVbYdwYJMzUbhAk8IeuayWSj0mVIbpM6z10OrKfCNVzco0TRHRhqJ6tbnp23bS18aJN04pqGLDwxoltHPDMMSptQM84KyOGpwDhEyam1KrnUpuu1C8e+66beDEoz/SP5WRd4LJZzjNUJ5NAh/GD7o9lSxooAIP0Gbxpg1AwUASydzADSE+HzZbtWLuAioJ3K5QoSeHFUH5CdE9mbv9K/QxA/86G7hbh8KtkoExka6BEd252Tfx9RMP6RoPHZLG8R7L6nNbTfyhQq0xh05UusdSu5m7BPjnt4O2EZbfJyOA8BugFllLPPs/GyM8Ss0JmQk6tSrCGoI+y+zFDoYwG+xi2VOwdt3s1rGdL2R6OrOU8GFrhppFoHwuRTL8sbi4Kwhero38VC6Y2PRlBmo8zCgrUMP3IFe0q1dW1wPWjIH/jWGUli8XZQpZZ6snPDnoEOP1l8XRVZi6CayoY9a6BaXqX+wSTRWU5Eg8QsFRHw//QkyRpfx0GKTatqR4uWFmYVu4OXZliMP+sXgQq27erhm9JDxs10bCno
 0Lct4FCq
 risbRu3x8P8uxAXt4cz0Y0WapvKytQcHea2CbXPTvhr9yNlXRPR0QfABHCTCqxEwJLi9fU2IB1Vn8PtFsFDDjQACD3mDe36eHJgcjxoU3evDHuf+GTrwaRKwuCZuQE3SYO96w+7YRH+SMLb0NmNISGrc924reVM/skghLq9GqNoQZZ+lYpSavquLadmYJQMdOHb6vOgDzWOcsAUrbLkJJ/FyipQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 5:17, Johannes Weiner wrote:
> On Tue, Dec 09, 2025 at 01:25:56AM +0000, Chen Ridong wrote:
>> @@ -5822,6 +5779,12 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>>  
>>  		shrink_one(lruvec, sc);
>>  
>> +		if (should_abort_scan(lruvec, sc)) {
> 
> Can you please rename this and add the jump label check?
> 
> 		if (lru_gen_enabled() && lru_gen_should_abort_scan())
> 
> The majority of the checks in there already happen inside
> shrink_node_memcgs() itself. Factoring those out is probably better in
> another patch, but no need to burden classic LRU in the meantime.

Adding should_abort_scan for the classic LRU seems reasonable, as it would allow the scan to stop
earlier when sufficient pages have been reclaimed or watermark is satisfied for global recalim.

Refer to the discussion here:

https://lore.kernel.org/lkml/20251209012557.1949239-1-chenridong@huaweicloud.com/T/#m4eea017f5a222ba676d9222f59ad8c898ac2aefe

-- 
Best regards,
Ridong


