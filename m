Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF05C44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8FA6B008C; Mon, 20 Jul 2026 22:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA996B0092; Mon, 20 Jul 2026 22:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0996B6B0093; Mon, 20 Jul 2026 22:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D14E96B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:20:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42F20140330
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:20:04 +0000 (UTC)
X-FDA: 85011178728.10.18072E9
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2313920006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:19:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784600402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+I/CNqa8Cnv8Tf+AjE+yhoTesfyICJfX109Q7GVREM8=;
	b=aw9wKlJcXT7+QoVHRNj80XUgfPp8BAvp7JA5nixJGMnW57Ipg2j1usx9PaFzf+ax4al5vE
	w6G7WhfHHep3OI3P8cuRRQyIq/Gr92InNuDdanSiduMc4K7PvTk6jaGTz0sWFxRLDoNW8h
	16G7u39ZUYqkk1w822hDDp23b9e4Kwk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784600402;
	b=L4uSQkFMutFfkVtgenAqHJTSRKSz8Ie1US3aacU+62Akird1dh0aCBe0byMv4ZZcmaJhmH
	gEkH6+IG2/i60YbrHEM0p26DbeJ76EpilM1x3MfC1SUY2TMsJlS0WVWafxtyntzcSFjuaw
	EwkRlhcGm+A4A7UH/qvpCzXvBDuYMAQ=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h41Ks3CcjzYQttr
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:19:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 08B414058F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:19:56 +0800 (CST)
Received: from [10.166.163.161] (unknown [10.166.163.161])
	by APP2 (Coremail) with UTF8SMTPA id Syh0CgAH7CdK115qNyvwBw--.19439S2;
	Tue, 21 Jul 2026 10:19:55 +0800 (CST)
Message-ID: <76dab914-ac17-4e73-80d9-8f5955e146b5@huaweicloud.com>
Date: Tue, 21 Jul 2026 10:19:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm, swap: Move setup_swap_clusters_info() after
 SWP_SOLIDSTATE initialization
To: Luiz Capitulino <luizcap@redhat.com>, chrisl@kernel.org,
 kasong@tencent.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-3-shikemeng@huaweicloud.com>
 <a8637ae5-1796-4dea-902d-1ae1238261e6@redhat.com>
From: Kemeng Shi <shikemeng@huaweicloud.com>
In-Reply-To: <a8637ae5-1796-4dea-902d-1ae1238261e6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAH7CdK115qNyvwBw--.19439S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZryUKFWfXFyxJrWxKr48Zwb_yoW8tr47pF
	n5KF98CrWUGrn7Ww48Aw1UGry5Ww18K3WUJF1SvF47uwsxAr1Igry0qFnY9r1DGr4kJryq
	qw1xX3sruF9Iyr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2313920006
X-Stat-Signature: b473in69y1aqtw7isxcq3c4xu7748c3o
X-HE-Tag: 1784600399-938288
X-HE-Meta: U2FsdGVkX1+eurnQkaFHjuBG0NC1cXeT+QCqRJv8mOv3IARxa/lCL2OtsSuwcb/S1YDr0GIbPMhB6gAfSz06xJQijmNKFPK8rWYpGmtWGoLaB2b25kYhNxSUgSzT+oR2E5+/Z+fHB7C5HwuGoCOq0nQBUFMBbIZrvk0BEaIF2/hNKiX0PndlbCnhGHZWCq4V4eg+jGaAelLN0wC3RyxTH6ixJWjEFhzd8wAqj3o1kOdGxKlk0Tnl1b6QXTPmTQJ3bXcSQXZioc88CQhaRiWge1V9cg1kUafh996UPRKgoYXgGpb9TpFObzaYQnRe/CJnU/OE2/93VEIvGQD9HqyDcRs1pwBCLdaInaeWJe7ZhORQOKV0AA5TbujqOlmXNQKKGbVOqIUQvBiMSTm5Ph1vURCBh2p37Diu708s/9ktarZNRcklA0eLKNHs0Y06BlXKUY+zwE41vEHLNDAC8cODm7MG/eEGjs6EzbHdBB3mvoMwULTDZ+kCsVeQcdDJ03eSaumfUML4/7+v3IDweTZXjFI0yxChSMV23Oif3fwxYFTBRpAVonxI+emLFkRH+tcOBE1smD5e8rT1cOBdTQPkOw0y74vSJnit9RuzHZWiDOQZweKrM+PcWFyeNUpKCrMcpB3/N/ZCUZXhj3ln1CpxNKuHLjclIXWtU2qOtPbzajkQW/5S6WAAogZu9nywkCA9eUyjvsPSJOpAwf2IOaLT44Tz523Ff+Ure5EKmgrusmwG1YFC7VG2R5933RTkTAZ721QJK9QKF4p73e8AK3mIqHHzg62Ie7we/+2WgpPSj/2xP2tsCh/6NtdfvMP6t2XSjNVF9KJjTPxIIYZI3fDMz8P1Fvy3dpiSeYd9OqGyatI4BQBw5eXK3cf6xLayNT7I3UZOTtJl4j3szWCr1eaaax/3xX/ZuQuXOlW+tjtRpjTX3903x3BxxxaqKgf+GVE/46NzzCmXrvShYX3UbXV
 7IR8tqiI
 /7dYMuy1oMmVJX0OEab0wrhcEwDf/b0DHbycEDymX1bcv3h3ACvPmxStOfUHRjp+ctOnmNWsEtD9fAw6+faU7wrFnG57FK27LzM3u8yMONRYAOGKMlIPbIoaDZUTrGT+zR594jN/nYtGTCTc6s5EVGb3HEnW13MYtGoZ117bqN9nHuxJ7D2PoZrhaAkSyGR29KIqMqKZaVfd9Y8KN9z4l4KqSKVU5tG1uK+O78Y0gGbW9e3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/7/20 23:54:07, Luiz Capitulino 写道:
> On 2026-07-20 03:13, Kemeng Shi wrote:
>> In setup_swap_clusters_info(), SWP_SOLIDSTATE is used to decide
>> global_cluster allocation. Move setup_swap_clusters_info() after
>> SWP_SOLIDSTATE initialization to avoid unneeded global_cluster
>> allocation.
>>
>> Fixes: 451c6326105b2 ("mm, swap: clean up swapon process and locking")
>> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> 
> I was about to send the same fix :) (one nit below)
What a coincidence :)> 
>> ---
>>   mm/swapfile.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index d29062d9c3cd..81c4040912be 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -3607,11 +3607,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>>         maxpages = si->max;
>>   -    /* Set up the swap cluster info */
>> -    error = setup_swap_clusters_info(si, swap_header, maxpages);
>> -    if (error)
>> -        goto bad_swap_unlock_inode;
>> -
>>       if (si->bdev && bdev_stable_writes(si->bdev))
>>           si->flags |= SWP_STABLE_WRITES;
>>   @@ -3625,6 +3620,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>>           inced_nr_rotate_swap = true;
>>       }
>>   +    /*
>> +     * Set up the swap cluster info. SWP_SOLIDSTATE is used for
>> +     * global_cluster allocation
>> +     */
> 
> Maybe something like:
> 
> /*
>  * Set up the swap cluster info after SWP_ flags handling as
>  * setup_swap_clusters_info() checks SWP_SOLIDSTATE.
>  */
Thanks for feedback. I will do this in next version.> 
> As it's minor:
> 
> Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
> 
>> +    error = setup_swap_clusters_info(si, swap_header, maxpages);
>> +    if (error)
>> +        goto bad_swap_unlock_inode;
>> +
>>       if ((swap_flags & SWAP_FLAG_DISCARD) &&
>>           si->bdev && bdev_max_discard_sectors(si->bdev)) {
>>           /*
> 


