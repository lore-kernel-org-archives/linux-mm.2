Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26469E95A8E
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFC86B0088; Tue, 30 Dec 2025 15:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A05F6B0089; Tue, 30 Dec 2025 15:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2E26B008A; Tue, 30 Dec 2025 15:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69D7E6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:08:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDC01C06D9
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:08:11 +0000 (UTC)
X-FDA: 84277223982.02.F817294
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0C4E540006
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:08:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767125290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsnyW5xJEvJV/byoiHU0Q5f6uXDU1X5r8liuUdAwjp8=;
	b=Op1npu+x5Szd4bCXPtqAhXhIOG6+2r+4umR3Xs3a7kWYByRY9OLVQECEPfZg5et15gos1Q
	NkGZLu27cv//yleeBzoyZhnF8m1Z7REtwVh5t5MIUO420sUIlQrDvZkgIGwfTRA59Oh06e
	7SFE7tpRTvXNz7ArnaMjN5j52bw1aKc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767125290; a=rsa-sha256;
	cv=pass;
	b=MJEwsPCkEyNICHICKOvnyPt6bNAMSqVf5ZRv3jBEH5FB5wgA18VhcxiWQcMlrntxw0kPb2
	umRFK2muIjuYqKHg8vq4VphJjxbJepHl7TriE/ftFD+96Rzyc2iYQndzNSPXKHO8L8Y8iB
	Y/FyahXy1GrCuKIPt0NI82Zisw7RTXI=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F0511A0314
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:08:09 +0000 (UTC)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 115F2C118A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:08:09 +0000 (UTC)
X-FDA: 84277223898.05.9AC54E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6C8FD4000A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:08:07 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767125287; a=rsa-sha256;
	cv=none;
	b=U5PRgPt1IN4ysiW5l61B/HtWnyFZayXgkTwKFgcek6amFDQOCVee1AZsSvSLI91wQrbvDf
	sIAj64TyHQ3EBf/uTtI/L5i8MZgs+75aVApCPVhJrXDHXIPcPObKRvN4WGcWyDdBmeKl1o
	hjOZL2SpAMAjqAvNfjqxkFKs3TApzxA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iLovLiNP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767125287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsnyW5xJEvJV/byoiHU0Q5f6uXDU1X5r8liuUdAwjp8=;
	b=5e3cJbHGHHeOBU43ux9zYv+FJ1tXpqjMDYCF9WopX9YRwen2bqqc9mS60ZmAf9NZlYQk0e
	OLv3vMtvWXueIL/cNbCGEFobbMJTMlQEuG1EfATDONfn/GdlL+VbnMiDKE/RlShafoanB/
	BdnYWJ0bdNdCwjs6MfILPgNXhC6hVLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3DBC60017;
	Tue, 30 Dec 2025 20:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D1BC4CEFB;
	Tue, 30 Dec 2025 20:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767125286;
	bh=Gb3nl2k2mMYjoNrD9TKrHGBidJzr3Us//djBQS573K0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iLovLiNPCvMP/uLHO4+F2zAyBaxy3X9l2QWJTUcIrKfLMtXjpyWvGSPorjoW56Sut
	 l4rDKX7F/I3Ge3K1t2dL9JDGTOKV2KbIb2xZoniVFD3Ld0qooRcZyIQMrpsjk5lpqD
	 RJedcE3rnD7Qh7ePCegYIpl3/htFc2X+GZaWonz8/Y70D/TOb1uFaOj+hdZD6DP2sT
	 k+OZAs2DghEx5ZVGc6Ihm6bAuUSfH4apRygmlWYbqTWhP2CeNcOzgaw+wdUSO7/cJo
	 LUXks7SWnpweExRT4udKqeJ6tp3phyqmSpfAc8x5sK0OULBKCWx4HneTvypSHGd36F
	 F5QuMcsqDqASg==
Message-ID: <88fdd0ac-45f2-4ec1-8a45-84310789c9c4@kernel.org>
Date: Tue, 30 Dec 2025 21:07:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
 <aUQPB0cUP9PXnrqh@cmpxchg.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUQPB0cUP9PXnrqh@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX1/Be36nWtQ7Qy3mUKmlc/wVgTWoUvs/tHoZTBov3T5rsImHYQt5O/u66+68bR1x9tnO86Q9rRJpWvhEDAxi39ETtr0idTN3KkSU15Dj1BvGFN8Cq2NRW96nZFztJgqO9CqBhSTPbDzVVhx8u0qa4/2c1zmQSgYLF/z6I/J8nUAOxYS1jxSzCDZXcefrl8t+/33IZ4shiSUeHmxzYZOGVD4mMj0IY4mX350PxLF+6FiZfZkz3XWniRlZfyNueuBu3MPe0+4tSNJYlk2rSJyCxe069Fg66MJ1R9O+3rzX8cUYbZw/F0pnCOx6BETo4CmTkgWUf1OZJxqguggYxRAYtOHN68bZmZNvNIrKhVOAj2cNiEl1tg4iFaTlhRklZRlxbD5qJUAq+NkLmTEETtJuCoXdaHLkLPupV2q8vxWoMcBF8ftSebsQL0Ncalhj3EMaomsM6MGTi8D9gi5VrGBD2oU1+HJ/m4I1ug7DuW2BRmIbVt7/g/RkQZUy3ZE8EIYmBFHx6eqMd3IZw/jW5vCzB9bz65d55ORA3wQ5NBQuVG+8pvsl9bDoZOGtNLLAaArj52la9mRLaopnP7C7mLHsBsATNulUDwEtcpshSLZ2KO1tWBt709Flw8zNDoW2M9o9akUH67Xc8qlkrs0khZaYEZahm/xgXcWBHtg4pYxaMhDUnSodZY/yR4PcvtsP28TPEAsSUS4kzs3D4kbyAPPFjv6HAMw55SeH6i23bZ2f6onDJWVWNiOVE0XiDoN5nowlGmOgRod5giTQZ+ZsL7IskAcYilXD1URuJHkM+yB6ivyMJ9rsI1w6/pb6w3bbhSwZQWZuwQtWKxAMwdLdQH40H5Hp3UbG09Ev58VtZ9tgJrsW9c5ma1+7b6vlTNcvA7NHE6j3+Jz3bf4u4Ik6bpEN33QS2JiXoRNxVkUIPwHZTXWESvVZ/ZKXajpLSarUeke+3Mav7UbAQK1
 H2EbINpv
 x5fJvwOVw3UiwwU6d1j6ijCR7A5S6gLipYNFQhqeEJjG6SA9WOtVhThMyz8P+44tWpv/hYI+msGmNsFbpqoxbC5n8TjL6GNpOdunKpAmDmdecs/Nz0Id/vPciomrFfbI6W93AHe2fS+31Lgk2BZHRVXon3EXoNscuUCRX8sSTFHsOmymYHPN3yoxhjuT92lg6XEiC6UdfwW5B+v+Q/IXdmAHlCvqZ/+GSvYOk4on3b5Je4tTHhHMDpixf/ucd2dAtOzqq5vxJYQKrps0QuH+PWGO3AAmhYSnF59jbVebdgxcdHF3O6yghoDUHEL1X8B1h2kKlC5vLuXS+OPWOC1SS1emkKQzz42Wtgcy2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C4E540006
X-Stat-Signature: cnrqchshzozg9qcez63chpfe13izz986
X-HE-Tag-Orig: 1767125287-979364
X-HE-Tag: 1767125289-568252
X-HE-Meta: U2FsdGVkX1/6Q6tY43Jf9OAGfSbpnc4ldnjiDMG3dUiB0Q78ju4/2crEQ2yB8X0fY7/PaKR40ufH7Tyio9YVTDKV9e9GNYHAPYdIM+9fMeAhu2wbTiYYkzjIu/mwgbS/JmKEdXF11S6HDS91CaP3hB8UEV6PYKnRPgyWidBBcU0r0kfK9gndx8sXiDNjx8t4QNoKXDqr9y/ns9gwbxETqU81NUULyp8HmdrpPUcK87R6O1G1QVnxiCFQq/fpIHJOL9x0onlnjoBq907UQaTQ8g3QoARezcvMVf17uIPp2q00aMi5fLIm3Da855volNna4k60Lot4jZu1HgS0N3jL3AOXweozlwIEcSqIfvMgYiKd1jMeMPDVV5GBEdg/iVWbHmUUhCRfCP9m9I5xhmmjnkfeD7yieF7RUBZYU/LUZcg5WgXSXbhm4nLDYTfugckqGHC16qUjb9wefEYqDm9DdtWG9m9JKVZAIdOQcw9YsabJjw1U2i7AbpbLeFOvf8xLsrFO7aZylKUarZuJELtKWzo+Denis1zT74w+bZdWixMoU8AJ0FwCRb8w3EUjKeDyktkhMOI58m5qcWS1VQOEzyteXiU/fHLtHz3AEgnWVakiqOhu6X+0H2TbnbsXIsqg/FYokbgZLH1vG43pySrZ6a7i87bWtOWtjdauyVHumFC4QeajVuLsOhHxtxhgJSyegStf1wWP8791s/VgF6wdX2T2ZP+QfatrZqGVaENtehf8KnwDW28JKQ3+AZFdcv9DwjjA5GyIIHbwHgBUuJCmAchkKPVkg83UUItdVX8Z83pnRmgp4J2tpBG1Cwtn8TK4Ml6TyZz0xJpqETzRd14zDbDrPgVl7uf8xSctoznafyA5VGLvdm/AxHBFpzrpkZSdCQJvYx8qKJB1iHYR1PsjWqJ+uSQ7tiars1PmLiPOzgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 15:26, Johannes Weiner wrote:
> On Thu, Dec 18, 2025 at 10:09:21AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/17/25 08:27, Qi Zheng wrote:
>>> From: Muchun Song <songmuchun@bytedance.com>
>>>
>>> In the near future, a folio will no longer pin its corresponding
>>> memory cgroup. To ensure safety, it will only be appropriate to
>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>> returned by folio_memcg(), thereby preventing it from being released.
>>>
>>> In the current patch, the rcu read lock is employed to safeguard
>>> against the release of the memory cgroup in folio_migrate_mapping().
>>
>> We usually avoid talking about "patches".
>>
>> In __folio_migrate_mapping(), the rcu read lock ...
>>
>>>
>>> This serves as a preparatory measure for the reparenting of the
>>> LRU pages.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>> ---
>>>    mm/migrate.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 5169f9717f606..8bcd588c083ca 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>>>    		struct lruvec *old_lruvec, *new_lruvec;
>>>    		struct mem_cgroup *memcg;
>>>    
>>> +		rcu_read_lock();
>>>    		memcg = folio_memcg(folio);
>>
>> In general, LGTM
>>
>> I wonder, though, whether we should embed that in the ABI.
>>
>> Like "lock RCU and get the memcg" in one operation, to the "return memcg
>> and unock rcu" in another operation.
>>
>> Something like "start / end" semantics.
> 
> The advantage of open-coding this particular one is that 1)
> rcu_read_lock() is something the caller could already be
> holding/using, implicitly or explicitly; and 2) it's immediately
> obvious that this is an atomic section (which was already useful in
> spotting a bug in the workingset patch of this series).
> 
> "start/end" terminology hides this. "lock" we can't use because it
> would suggest binding stability. The only other idea I'd have would be
> to spell it all out:
> 
> memcg = folio_memcg_rcu_read_lock(folio);
> stuff(memcg);
> otherstuff();
> rcu_read_unlock();
> 
> But that might not be worth it. Maybe somebody can think of a better
> name. But I'd be hesitant to trade off the obviousness of what's going
> on given how simple the locking + access scheme is.

I rather disagree that open-coding it is the better approach here, in 
particular when it comes to new users or code changes in the future -- 
just way, way easier to mess up.

Well, unless we have some other way to add safety-checks that the right 
locks are held when the memcg is getting used (e.g., passed into other 
functions). Maybe that is done already to minimize the chance for UAF etc.

I agree that naming is tricky, and that it needs some more thought, so 
I'm fine with keeping it as is.

-- 
Cheers

David


