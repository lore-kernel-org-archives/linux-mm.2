Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE377C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740DD6B0095; Thu, 20 Aug 2026 07:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0916B009B; Thu, 20 Aug 2026 07:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D216B009D; Thu, 20 Aug 2026 07:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFE26B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:46:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C29204011B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:46:15 +0000 (UTC)
X-FDA: 85121469510.02.77F1AB1
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99F36A000B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:46:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787226374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p6boexFWDbKUyemxFpfvIIAoAcpLgttrMyK26yxosEQ=;
	b=VJN5TNlh4zkl/zShGdC1Fcd1sF5kD2plOYBRcv1XJzS3T/9XpvKUmJXH4eb54EP8ilR1h/
	GKGbVHb9eyNtiUnsWN3AZL9RNMp2SxRbbhTsX0No9K7ercLvSdX01Lvfjm2d5iDZQXl+si
	pyCaOxorhYKTnJx2iIWsx41ybmj9lVw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787226374;
	b=nuRdRtOk6Ny+QvORYI4vHUgpWLJNHqVcIMAc94lGoeJaZc2ZsIxRuC7lA44DRirtXxjWcV
	JByOmyNAfjAU2kzf7QrXGii8uvhVU2gWh9zgn9ukPBJAnZd8ttqJb/zZSOIX8hjm2VtqVW
	SYYTYXdbHoKjMU691jT5BUAUa+fmfrM=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hQhTR42S4zYQtxK
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:45:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 313A840596
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:46:06 +0800 (CST)
Received: from [10.166.163.161] (unknown [10.166.163.161])
	by APP4 (Coremail) with UTF8SMTPA id gCh0CgBH2h796IZq_44jDA--.44192S2;
	Thu, 20 Aug 2026 19:46:06 +0800 (CST)
Message-ID: <3d7de544-1607-472e-a922-a4687cf8a133@huaweicloud.com>
Date: Thu, 20 Aug 2026 19:46:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm, swap: Remove unneeded
 swap_extend_table_try_free() in swap_dup_entries_cluster()
To: Youngjun Park <youngjun.park@lge.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-5-shikemeng@huaweicloud.com>
 <al8mqsmCy42X3Ewo@yjaykim-PowerEdge-T330>
From: Kemeng Shi <shikemeng@huaweicloud.com>
In-Reply-To: <al8mqsmCy42X3Ewo@yjaykim-PowerEdge-T330>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBH2h796IZq_44jDA--.44192S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF15Zr1kXry3ur17CF1ftFb_yoW5Gw43pF
	WfKas0kF1rX34DJrsrKwnrury5uw40g34UWF13Ww15Z3ZxJ3sYgFW7tr9Y9Fn7Cws7Aas0
	grs7Ka47u3Z0v3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UZSdgUUUUU=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99F36A000B
X-Stat-Signature: dp5fbuhwczbjoct6fyksbpntwc46tuth
X-Rspam-User: 
X-HE-Tag: 1787226371-149187
X-HE-Meta: U2FsdGVkX18N06sCjMiyy4TD0ZiN4iYbxkTgw9OUjycAVSX731ago/N+Y4hQUHDXQz76tEqDydwJmAThxvBuNOwdZtf7GOgMgvfkxcmb39RfKhJ06A1YbScf17p561FajdaJtyxzFOP//k4sy+4pmhCbhstCYu3kiGa5f33+p6N4OA2orFhNtXMp0o5GKfbwGbvAhwd/Vgzt8QVOkSktIeiwDgKQvbe53vaAf+jDkUUVxnMWJ9vt3MgpJ3uv3RzLISho4KNazLxd7ntbUFOMLfQ6ccHvtaGNjUh143MUeU+Y1Mj7dByzbcd6vtA2K7HNitMRxDbptEMFoQgY2RFo2dydFDw9k9hwnQB2c5g46D4gdbdIjieJCsJ5joyuaf34ndaoECDMiJjRLKVG3mMdlqeGMDEOSEdoigLtFoqRcXRIFGp1pjarmp7qyhYkqH+ExSmjofRgURTwKadsG64qoQK9OGx/smrTte5s92zToyEe0JEQDDkdQb2OBUqbREf5WUP2soyfj9ZQoc7Lt/B76BXkZFCWFADiHjbOZkmagRJv8JVaKkb8j1Y7PbNqZyJey7IGlYkbJCdx4BynJfQ2bQlxDWiZJIGs3kj37yAMPFZBikaWB6wfGryXhtpeJxnf36wpiL7TALlJS2zubzcZbrXspXb9FPu02V11dhFZFM9gtK4RUHxqy/Re+ZDrlTEISduYVRyBrXxGdLXWuWBNSNL5mCg4oNDwBlc1wFssv26if0MnIYjwAy8FLmCVg5C/2lIBS1DEuIBCaKwecmlrz0sfGl5K401Ym7BYoTEWmFjBR3wNAk8oDt5Cp0qW3D5Dq+8rI3bnPJxFmLikYE2Wn+/e4Sx4GRn4Y/wdQgLroYYy2yxJWKqGa6UCJnyifTba5kuJP0JP7rrfSn2nldELLH5O0hpVOHq5q3mB6G2tChRL3sXe9sNTbVxJ6p6XbDmjcze79ELaX71PFHcyZnQ
 nAzUT1zW
 tJ4YuRMnfx/2g2RAEaptnPS685tXTu2TWmd2/BTPUrBnPkknnzrUT7iLxANpv2boEsG0Xyew1EVRLWubtee1qtFCdo5uT+XiipQcSjLePmgL0/+Iq42gdAeLQuqF2bNieBfV5rtAnY0Yke12Y3dXr0asIVqovKVl1XPRSdLC3NMvXykkr4oZo9Tqp85K0D2+kytB+B1lOrdJlfLA0tuRy6wz5PNj1OPSfLz5YHbNQK7jU1AQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/7/21 15:58:34, Youngjun Park 写道:
> On Mon, Jul 20, 2026 at 03:13:42PM +0800, Kemeng Shi wrote:
>> Since commit 0475fde0f68de ("mm, swap: avoid leaving unused extend table
>> after alloc race"), extend table is always allocated when any swap count
> 
> Looks like this? 395085eacdfa
> 
>> reach MAX - 1 and is always freed when swap count decrease to MAX - 1
>> or MAX - 2 with cluster lock held. So the extend table will always be
>> freed properly when decrease swap count in __swap_cluster_put_entry().
>> So swap_extend_table_try_free() outside of __swap_cluster_put_entry()
>> is unneeded and can be removed.
>>
>> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
>> ---
>>  mm/swapfile.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 3fcbd10c6353..fc9f16bc2e4e 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1732,7 +1732,6 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
>>  failed:
>>  	while (ci_off-- > ci_start)
>>  		__swap_cluster_put_entry(ci, ci_off);
> 
> Right, it handles duplicate here.
> 
>> -	swap_extend_table_try_free(ci);
>>  	swap_cluster_unlock(ci);
>>  	return err;
>>  }
>> -- 
>> 2.36.1
> 
> However, looking at this part, since swap_extend_table_alloc() uses
> GFP_ATOMIC, I think it could be further improved by not releasing the ci
> lock.
> 
> This would also clarify the situation where scount becomes MAX - 2.
> But there seem to be some drawbacks. For instance, the original intention
> might have been to make the swap_extend_table_alloc() API work seamlessly
> for both sleepable and unsleepable contexts, and some implementation details
> might not look as clean.
> 
> Here is what I was thinking:
> ...
>         err = __swap_cluster_dup_entry(ci, ci_off);
>         /* <- Could -ENOMEM handling be improved here? */
>         if (unlikely(err)) {
>                 if (err == -ENOMEM) {
>                         spin_unlock(&ci->lock);
>                         /* <- Change to NOT release the lock, and make
>                          * swap_extend_table_alloc aware of it with
>                          * GFP_ATOMIC(aware cluster locked) */
>                         err = swap_extend_table_alloc(si, ci, ci_off,
>                                                       GFP_ATOMIC);
>                         spin_lock(&ci->lock);
>                         if (!err)
>                                 goto restart;
> 
> Just sharing my thoughts! (Wondering if this could be a good direction for
> further improvement?)
Hello Youngjun,
Sorry for the late. I agree we can clarify the situation where scount becomes
MAX - 2 in this way and I also agree some implementation details might not
look as clean. So I would keep this change to make thing simple :).

Thanks
Kemeng> 
> The current modification looks good enough to me.
> 
> Reviewed-by: Youngjun Park <youngjun.park.lge.com>
> 
> Youngjun


