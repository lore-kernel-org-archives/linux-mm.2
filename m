Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BBB4CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE25E6B008A; Tue, 12 May 2026 03:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93BB6B0092; Tue, 12 May 2026 03:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C835F6B0096; Tue, 12 May 2026 03:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B71BE6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:33:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59D1F402FA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:33:24 +0000 (UTC)
X-FDA: 84757952328.21.7F703B2
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F30F18000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:33:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nf1s0UCQ+zDHwszse+lC+PDgn4fGQpYo1GQZ10J3EKw=;
	b=m0iC1U1uGEjR86g4ipSH5WARziAKnJaFymkEdXGr3N7AKRqKcpS8IEtKtTCWg7/vdq1dS3
	5BlcYM3hGB+2dM56ABBB5aQGEneiX9r8uXeF+yBCgboWrWcWdM5zudN+B3FTtm85x187Z5
	3+w0Fm8CWKeeV1V+NYKEq9QYVGwjPQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571202; a=rsa-sha256;
	cv=none;
	b=fuLrBC3FVLJE/CdKvCCQHJd7j7h5uJ06ovS4BRsiufPZ0kddpSPCUgYHYoDkGi3j7hKSj0
	HfqQ083APJvPQ8sPfCsL5KnZwhLewLTNX7FEb6JFv5VeJy05NOHBlE8caX+2yXhLhkeJba
	EUpoMdVwAHRvnXF+uDOr0WoaEfSxVHs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gF7bX6DLTzYQvFM
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:32:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3F6994056E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:33:11 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgBnxCyy1wJqTk3lBw--.37849S2;
	Tue, 12 May 2026 15:33:08 +0800 (CST)
Message-ID: <3a4946da-24a1-4e21-86ca-b85358098c3d@huaweicloud.com>
Date: Tue, 12 May 2026 15:33:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
To: wangzicheng <wangzicheng@honor.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>,
 wangtao <tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>,
 zhouxiaolong <zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>,
 "kasong@tencent.com" <kasong@tencent.com>,
 "21cnbao@gmail.com" <21cnbao@gmail.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "axelrasmussen@google.com" <axelrasmussen@google.com>,
 "yuanchu@google.com" <yuanchu@google.com>,
 "weixugc@google.com" <weixugc@google.com>,
 Randy Dunlap <rdunlap@infradead.org>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "T . J . Mercier" <tjmercier@google.com>,
 "kaleshsingh@google.com" <kaleshsingh@google.com>,
 "android-mm@google.com" <android-mm@google.com>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>, "surenb@google.com"
 <surenb@google.com>
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
 <2597ce355792455e94ee41fee6740dc1@honor.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <2597ce355792455e94ee41fee6740dc1@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBnxCyy1wJqTk3lBw--.37849S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JF43uFyrJr1fWw18KFWfZrb_yoWkZrcEv3
	yDGr18Wa109Fs0qan7tF4rtasFvw4Uur9I9r18XrW2q3s3Zwn7ArsIvrnIvF13XrWxCrn3
	t3sYyr4rGasI9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIa
	0PDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F30F18000B
X-Rspamd-Server: rspam04
X-Stat-Signature: iy96n7dy579s95fc5axbadans9sq9wds
X-HE-Tag: 1778571199-190290
X-HE-Meta: U2FsdGVkX18x1C1NyRFF+GtXqPADNUV46Ikq3OJiWfs7/jk0QnV8bUKfkw/wuNHzFu5Gifi6GgA+oCM+kNSDga4QhdBHANvTbG2p146V8BUamAXL4fvNdOhPE0nyXYkIwe2yLfXbgYR694nQNIDR/P2vSMQCkUeKEdG0BshgsA42CLAGo7pkYm+ArSIYvNt/HkJSd9fgW7XHdP2VUp7pC1Qns6G25BGv/gIb2HMh8kfHDcbJxLhpFfZEvFSi7u7zQKQMmdoIDHJM3Ngv2WlrQsgckbcsl5GSk4O5vuSVuJ/xT4HZedAG96aRK39/x71/KFO03N2WGoUeJxNiWTHV5pXfDyoUTeqbUVNMyxqnC9r/SdcY8Xd/9biouD0Ux+ZrXdoa8MbGllU1kftymAVO8yDgSMZlIzpU2ob1PvcD9Crs1s1BoPJLKFZ7mziYZqybc3f6vgOtlDZmELSTUa46YCPLJlKiu87xb5eRB6rOE8bz8TZPzmrXh9yx1D1ul0L4ieyEWJgnFTdboNLngYaBpvNo8LShd2P+m5rpzb7ccZPjHG6oXribYMaCLhuSalYlaO0O5E1grAxU69z7yMt6ijeYkvVM8nSDINCwAd6CXLTRpqBkKKE77aGZVtF1xCz1pMLJjrZ4l9K3xA7+DOViRMnkl4/u/5OC6c3+EHth8nimdJUuQeH/5PTPEyxnSFEELbqyshoUeOoICrI9gdNdwm65QIPtcRY5XD1jA36s3nqHwZoIfzhdXLRKsCHgzb5rD+73I3pUgUs3esxJp4XO9XuPUiNW++B5Nn5FknMT03f5pBLDVm11jpvyHMmS26fQhkKL0LyX9KCETV1N9GkaKiZjyf4rhlwyEQUzNwPT+6v8BxhIpZqid3XDU+q4JfBHcIn3/jK8RAwmDqV6r4lnejS75bFDkPobiTYCCHOwKdo0N4eJXLWF81qOtFLqfSFv2Fkzb9O9+Ea4Cwhn3ba
 HSxGa1/X
 bWuMqkhpI6MrLmHhno3a454z5QLzPG0hMFMayTfh3yHDmAqwgi1Ec0Qf+W+KEADcYkcyyFqfWm23u5H034G4mcaV4/zvM5S0/Ge3udFvrxPguCdAqSf+tNOUaOmKxpxqu5o+uCaROS3QUfCAv+rFDcjfxmvposuqdOn5sudGhqIruA/a1LpgKCdjc0V4rvopnNZpQctngtHKf3b64JpCjAXQltbHmTbM+P757bFLZzmk50C4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/6 20:49, wangzicheng wrote:
> Hi everyone,
> 
> Following up on my previous email and our discussion regarding 
> "MGLRU on Android: Real-World Problems and Challenges", 
> I've uploaded the slides for the talk.
> 
> You can access them here: 
> https://docs.google.com/presentation/d/1hUogz6InyLn13c8CjHuvEIzE4rT7saVRUV6xpWZoNfQ/edit?usp=sharing
> 
> I look forward to further discussions and collaboration on these topics.
> 
> Btw, What I mean power consumption benefits, is MGLRU compared to LRU.
> There are 10% power consumption in MGLRU+ActiveAging compared to origin MGLRU(not LRU).
> 
> Best regards,
> 
> Zicheng Wang

For Q4: cross-memcg priority

I have sent an RFC series [1] that attempts to make memcg aware of hot/cold
status when reclaiming pages. I think it would be a good idea to combine this
with the question at hand. We can treat the foreground memcg as the hot memcg
and the background memcg as the cold memcg. Only when the cold memcgs cannot
provide enough pages will the hot memcgs be reclaimed.

[1]
https://lore.kernel.org/lkml/20260120134256.2271710-2-chenridong@huaweicloud.com/

-- 
Best regards,
Ridong


