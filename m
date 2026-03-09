Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F34EFCD9A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C42A6B0089; Mon,  9 Mar 2026 07:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B1D6B008A; Mon,  9 Mar 2026 07:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1AD6B008C; Mon,  9 Mar 2026 07:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7436B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:44:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08BEC1A0142
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:44:07 +0000 (UTC)
X-FDA: 84526340934.02.B4FA683
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 46CF31A0016
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:44:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kgv5Xmfz;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773056645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfeLhUszPMJByDj4ltEH4Kppb4DyMf4gLg0eSgVQYTw=;
	b=inqRB4km9u6ZiC5Dep8BWyB6DRLk2TJf3rJwTYY8hASUhoCZ0hddcTS1pEWvL7idOZB0Mz
	qkoZrpe5jlPwPIVW48JFeNgQjrRGTkD7tZXcxG8JG1Bv0KTl6n8BYfvh+Lwtz962TeOdYu
	VauRhEfBqijl1KxUwKSx0St6Snq2iO4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kgv5Xmfz;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773056645; a=rsa-sha256;
	cv=none;
	b=AH5xN5uZcUZFnSj7G2q4M1ebutsY9l5mA3P1q8UcFGirPTLsBzQLYPg2wSsXY+7UUDqRYs
	X5nibSgAVwje6C78a5w+262BlWRp7IPBzGLkM3bdwpHGOBZN4kMf7p9Wg6SznDtCe5Rj40
	6x73038vKwwXPU6putUt4pm+vp2NvGM=
Message-ID: <4861098d-62d9-4722-bf46-c8002e2df1dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773056642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tfeLhUszPMJByDj4ltEH4Kppb4DyMf4gLg0eSgVQYTw=;
	b=kgv5XmfzLxaR6xQcH0UHgdoYuX7w2Ho7rpaECeoSQ45gJv5zLotJuzRzMZitICfTSAeTnI
	E1dG6BQDQXHwhv3IorfYuyMDvMJqGglzdtOofFEbuvhXEKLz793KcyxpqiED37B+MgE7uw
	u7lTUlSlYuZMYaAhyMrLphU/ZjYHmDc=
Date: Mon, 9 Mar 2026 19:43:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] fix: mm: memcontrol: convert objcg to be per-memcg
 per-node type
To: Usama Arif <usama.arif@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com>
 <20260309112939.31937-1-qi.zheng@linux.dev>
 <b26f48f1-c311-463c-be17-7384ca27c7c8@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <b26f48f1-c311-463c-be17-7384ca27c7c8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xg4ig3rk3burkw15zcdfwbktacxiagyz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 46CF31A0016
X-HE-Tag: 1773056645-517548
X-HE-Meta: U2FsdGVkX19k6rUonTJtU8CnRQs0cOZLnngg9mkR/AVtVtbURYkTXUyNd0cPwbQbIYRDTetFW+yqu72/7RgjQkOWcOtMRhM+KglnGJBMF3hChU+78fLHsrSES9yHXT5EugsFi4js5xzgyAiC1xyrZFjWipFmQrx6VAb+NY58/zqe6FG7Eh+3nZHKBMuQZ5BZc7/4fMoxm2lh82Vt5kJtQ6lwVk59NyVZ80nbh/SeLoVizyFV18OI4qmOhpkImv/DSkYhUwdyCXwlWM7p5N/Bs6uRmybOZkCQq3PDFObEC8YzIGmR/+yWTq05XTT3+ZQE1sMC0gmX2sX4Nqe/dH73fRf2PVDYXwJyFLvEJJrIXU9OUlE8e1jL+lvKeRHwvUNwmjSiGdjn+OLODiLEMgGMtteFdLKFaCym67dyiSjuw40mwL9lW6Md/m0rhX5OW/MA4LQuKH33L1dmDt36PZkHpMPbqHXlL68zOsvAXMlYXHE9w14qlCz/DFxYqa9lmFfOEvnmL8RYC1uoiasMLPmXV9OQniLhBZ97DE3UAOG0YSC9fH72E6y06VQztNKOKcnG3LWXklj0AtAGG5g1fxQDUN+c2u8QAfuHIFoNSZ328y3u2tXqzpVN+cvDyhwdExJzk78yu+7mR1f+ufNgjIEoSiu9r4SdFc/VH8b++EbNuQ6truudkfMdHjAZoEhaoAB76UDPIG/8DZq7LsowPLdOZXgSxibZM5K5JZxSZRhPGm7tWo2kqxeR0Cwh32KfvJEu9Qe4nCg/FdAZca4XKg+Z64CerLwcf1gLJJao1eYXybmWhmibNb+2b+SYIrMhW1khsxWrSPxczxdWkyN4ZhWKriJF4ZZACXHSLDfC8WMeSm+c9d5qMg/GNe5AMNpFI7z/cKYvWHbd3hrjf60cBBWUOblByvRqtHXDX7NuSrUnYKouC+Jvh+ul2HiI1hbdb0pIFoHQd3g7syydQX+CETn
 kk1WReHr
 8kEvGaMJ0vDiPdnhephb96O/hJHFjY9WNtwVFN+VlRlCmD1q1GbsK+aQxEhT7ny1R0sANYUmuuV3qcQym1qAztcDEQWwXkM+HSuXXFBEZr997K/ZIG2Q82804qvSMU3kiIMvsUg/HJVi66KXK0GFR0BW0Q5ef9XO5bpBPAe+v4zXAGniIdEnE/dENPJ0Pa9n45zh+HkG/Ob/ZRUEYp5LSd+DTqzhMKA+edmGBaWxfpW3lU1us4n9SjwHl4eh0BwzjXRL1CAQLQoDcXnNsAA9dRr5uaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/9/26 7:33 PM, Usama Arif wrote:
> 
> 
> On 09/03/2026 14:29, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
>> from being called agagin in __mem_cgroup_free().
>>
>> Reported-by: Usama Arif <usama.arif@linux.dev>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/memcontrol.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 992a3f5caa62b..ad32639ea5959 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4140,8 +4140,14 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>   	for_each_node(nid) {
>>   		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>>   
>> -		if (pn && pn->orig_objcg)
>> +		if (pn && pn->orig_objcg) {
>>   			obj_cgroup_put(pn->orig_objcg);
>> +			/*
>> +			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
>> +			 * from being called agagin in __mem_cgroup_free().
> 
> nit: s/agagin/again/

Ouch, my bad.

Hi Andrew, can you help squash the following diff:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ad32639ea5959..5fcbb651846a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4144,7 +4144,7 @@ static int mem_cgroup_css_online(struct 
cgroup_subsys_state *css)
                         obj_cgroup_put(pn->orig_objcg);
                         /*
                          * Reset pn->orig_objcg to NULL to prevent 
obj_cgroup_put()
-                        * from being called agagin in __mem_cgroup_free().
+                        * from being called again in __mem_cgroup_free().
                          */
                         pn->orig_objcg = NULL;
                 }

> 
> Apart from the nit.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thanks!

> 
>> +			 */
>> +			pn->orig_objcg = NULL;
>> +		}
>>   	}
>>   	free_shrinker_info(memcg);
>>   offline_kmem:
> 


