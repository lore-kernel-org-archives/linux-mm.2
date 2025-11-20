Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A4ACF885A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F446B0026; Thu, 20 Nov 2025 08:45:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1673E6B0030; Thu, 20 Nov 2025 08:45:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4246B008C; Thu, 20 Nov 2025 08:45:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB4946B0026
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:45:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A01B8140126
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:45:32 +0000 (UTC)
X-FDA: 84131107704.13.40F7B16
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC1DDC0014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:45:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KZQyoVQE;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763646331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F1vo22ZFTmKf8sXE42d1ovwkd4h2/GmeH0WirLVGeg=;
	b=hg/Yy3yHL4OzkvmasoYZ0WWfaQ+aIkQ+h+iMoYNsOVhA3snbq6r9tklfI8XKRBtUykFGTI
	uAuA5Hfeq1jGRzdy5rxWeC0fO92902L7t3KcXb4OEQTQbq1JeGylny5VsfRf/R1z5JbefI
	2QXQkrd1uwblYkLMXATl81aXKvkdDho=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KZQyoVQE;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763646331; a=rsa-sha256;
	cv=none;
	b=R08ptcqWD2o1yZAP7QFYfjNO+eaJHbYcSWv0yyQ5oWQ64ypeic2AwXWCwJKprS7apOomRR
	Bu/rXx6n0lDfKj6h24tQ4mQFaKsCqZNsXT+upENMvhdQR42XrrCbloD1XRJZY/yUSaWJpm
	weZDhXO4DLJYhkS6V7m43Eh3e+EV2Rs=
Message-ID: <cf600d82-82f5-414c-b880-71133379d5d4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763646329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0F1vo22ZFTmKf8sXE42d1ovwkd4h2/GmeH0WirLVGeg=;
	b=KZQyoVQEqYe/9XPzLslzGEobTzkXAQWLBhUuaENdHn2JcZkTs3FEHl89i4TBmDv3Q4l6WK
	dJciw1xTfr0yhYuoDDpR3VaSo5HBt+gc9UF2D2kvkmuBMPvmRBDtIW/ul/1iL+G1qsqO34
	F/b9KKIJiTm3UsMXcB4XXtOz6iniLEU=
Date: Thu, 20 Nov 2025 21:45:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
To: Chen Ridong <chenridong@huaweicloud.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <44fd54721dfa74941e65a82e03c23d9c0bff9feb.1761658311.git.zhengqi.arch@bytedance.com>
 <a7e55445-20ee-4133-8455-b6c5f7a45ff3@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <a7e55445-20ee-4133-8455-b6c5f7a45ff3@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC1DDC0014
X-Stat-Signature: wfheqxstqs47x67z4xgabk97tchshzch
X-Rspam-User: 
X-HE-Tag: 1763646330-510086
X-HE-Meta: U2FsdGVkX18VcTGrcxtNovzJ3DiPYqqOXg/e946NFheJBIPVq2/ZW1krv/vsdTid5wgPINag8hAHb7OLAgf58Ucj3Hof3NJrIhgSD+40C0jpRtyjmxFM9aNj4zUPSgdvUxHEZrfxVuUKV/bmjfJvCyYrCf2T0ffTalVwDFUyQtEERdgjcT+IRFT6vlPemZ0hyIEW8KVg7SaEFv/lgq4IB/8LRPPb1grQRprvfafeRMyhNZCTCcN3xei8WfqhbgkeiUEmpXZfzgadHjjvxdbO3eGHKmE6hnf1EXiV4l6QzF0b1w2HmC9bHMrBqysYgm68v8mhWTBYr4NELNLoBdnTyhJQvcbupAjshOw1Eb/Jxw5wFxCMiFBB/HJRNcwxUwcu5n3BqD/U9ycK1qxCQ0GhYXNPibnY50UjqX9cpxvQrRFDPZ5wXP/vgK/4+wTWSjjlpAC6bxvd/w4wumfP/UTBLduika1LnON02iKWzSh1nC48rBD2TxkJPF+YW8i7SGb8jco/ov0mzxXbC1XRoX2XBu1pubeHBklLbhDumKEUBF0uIbxL52ciyRKgqdDt2eE94hojo4PQRbh279bu/qzXM8ZdFgnfXtmv7wDhVn4nZDn1JnmWcq32XeDXVRMujsNa5Tkvok69K/jcoVZi46YmeAAn00VSxa7M/pMPHRPVhEqKPHEqHzsX2rVHIOkwq0X9wZNf+qfB1sVgYi4mSeFpvyRAviA+vgtgyN0s/wc2YGRBsMeCHc1fAzJQVDkpH9hPZktbSSzsG0P/C2nS8gdVmNpjxOw60Hpfr1KU26D4EqDR70apRLF/fMh/q/bb0WglC7Xiy573zStnEnslEGxGfxwo6ljNCEMI2aCK7+ln2uaJ5V2Br6l1KSZtGBTft1MakTHCyJIU4gtG0ElqPPWhBDcF2hozXZvArnt2+CuqK3sMsLKr3SUu5FusOVxM1YNP8M5MeoY5d0IClsZ/bga
 bzg8X8I+
 3OeaMmxQQ8K2xqvA0BhvJ3pQ7c4BUYx4nAHr9wpKbugnFY4p4YUHS4sqiVaK7gQbApLfKUlWHA7LaJzHQ6/KmD7wIYtzuKK1Kavu2c6o1swd44GlxKHiQIL79dVzQM4e9Jxatjk4U5iI7OeuXrgLY7ZFz4Kjgx3Dv4jnBOJ8g4nng4RJLNMcNoROQiklWHuOF7sXb37s/7XvVegngo66pUujiM60b8e+D5sJcGWlm5GsILzo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/25 7:56 PM, Chen Ridong wrote:
> 
> 
> On 2025/10/28 21:58, Qi Zheng wrote:
>>   static void reparent_locks(struct mem_cgroup *src, struct mem_cgroup *dst)
>>   {
>> +	int nid, nest = 0;
>> +
>>   	spin_lock_irq(&objcg_lock);
>> +	for_each_node(nid) {
>> +		spin_lock_nested(&mem_cgroup_lruvec(src,
>> +				 NODE_DATA(nid))->lru_lock, nest++);
>> +		spin_lock_nested(&mem_cgroup_lruvec(dst,
>> +				 NODE_DATA(nid))->lru_lock, nest++);
>> +	}
>>   }
>>   
>>   static void reparent_unlocks(struct mem_cgroup *src, struct mem_cgroup *dst)
>>   {
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		spin_unlock(&mem_cgroup_lruvec(dst, NODE_DATA(nid))->lru_lock);
>> +		spin_unlock(&mem_cgroup_lruvec(src, NODE_DATA(nid))->lru_lock);
>> +	}
>>   	spin_unlock_irq(&objcg_lock);
>>   }
>>   
> 
> The lock order follows S0→D0→S1→D1→…, and the correct unlock sequence should be Dn→Sn→…→D1→S0
> 
> However, the current unlock implementation uses D0→S0→D1→S1→…
> 
> I’m not certain whether this unlock order will cause any issues—could this lead to potential
> problems like deadlocks or lock state inconsistencies?

As long as the order in which the locks are held is consistent, there 
should be no deadlock problem?

> 


