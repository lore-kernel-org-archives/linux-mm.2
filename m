Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D005606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XTSu54ZG
Received: by kanga.kvack.org (Postfix)
	id BC7A66B05B3; Mon, 23 Nov 2026 00:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B714B6B05B5; Mon, 23 Nov 2026 00:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86FA6B05C1; Mon, 23 Nov 2026 00:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3FD6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:45:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C517407EC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:45:23 +0000 (UTC)
X-FDA: 85465296126.11.3661F7B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id DAD4040008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:45:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XTSu54ZG;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412721;
	b=8CXe/p5pjcyNT9GD9PTahPGaiMwBvb5EBZJhB/h0DATJC1pzVfPpxYk2V3axplIrURcfQ3
	sVqU8ttyL76DUjqp3c+Zeo/LS0xM8BuVZUGQtlTIchj+DUQin3XGfENBI/o81MDUyQHWu4
	DWG0JtltONnZQDjoLdd9baP/mEmlPP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GX55jPF+fKXW00sTxIqLc+Pma2dEmhfNWqv3JUsMNrI=;
	b=ATPGCsVmokA1+K/CYDI4RsmQugH1stsbQBwHw4jnC6VqUmqp0mIpEZX61FPCSrArBMXvIV
	f1x3Z/q9qos7FfHqIh4GRm5DqGpB1A2phBt1qQ6IhycXndG7Kagm65pMC30rQTbD22Zctr
	BGjIc2cB38eR3qpRxoxQhwNikQ/DH3c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XTSu54ZG;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=GX55jPF+fKXW00sTxIqLc+Pma2dEmhfNWqv3JUsMNrI=;
	b=XTSu54ZGN4TH4OFNy5hothbeMtXpCVmhayR9eyKta/pCJ6iR6bGi2h6tlSvdrA
	5avxJZ5/tcuxaLby1tJ2RdW5N76/ex7HqnpiWIJWZG7VD2PEE3RfP/n1c/T8mjUO
	USdFBMpmjOyrRAxC4JpZivDWdHTxkQ6skItU0MSKphqXU=
Message-ID: <56dc7b93-604c-49bd-9e86-f519c7a90b97@163.com>
Date: Mon, 23 Nov 2026 13:45:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shrinker: stop counting when the seq buffer overflows
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Xuewen Wang <wangxuewen@kylinos.cn>
References: <20261120110538.3256962-1-wangxuewen_ky@163.com>
 <57ef6b0f-e9eb-4484-b07f-63c848ffde4e@linux.dev>
From: Xuewen Wang <wangxuewen_ky@163.com>
In-Reply-To: <57ef6b0f-e9eb-4484-b07f-63c848ffde4e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCnJhLj0gNr3HKiHA--.56468S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGrWrGw17uF1Utw4UWry8Krg_yoW5XFW7pF
	s5Ka1jya1DZr17WwnIyw4xXFyYyayFyrW5GrnYqrW3ArWrXw1Sq348GF1Y9FW8C395Gry0
	qr1j9FyDWF4kZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j49akUUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbCzQSJcmsD0uRIXQAA35
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DAD4040008
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zuep68mgkzm4oue9bzym6exifnyhy6az
X-HE-Tag: 1795412719-741003
X-HE-Meta: U2FsdGVkX182bZfUW+VUeWn7Gw9wPayWq89luY5m+QcD6Z8D+WqtzU724pWjwqCRv2M84tIhjuIS1Rub5gQfSUw7/pmoUOQHoIyKgO0a/D0p8AWKmHwuhUuiJqmkdWh8Qj+lzZfsRu6A7I/SXdlYzPp/3fooah+cCNp9HCvvxtTZy8c/xFNO7s2QNfyR2EfiVwvpMFuQaR9/QlmWhcR5EJp7dOy+hUDLewrV6BVYRnRdbmP0L6K/DKw/+sVG7t6mfo03n4Ku3yH2PEPNaM3AOOYXBQiryuc0N61e7SAOffsQx8uOBytCXalvRIwdv9Z2ujSGEh61wZoiV3+Ndd4VNNfgosB3s3mRAydoLcy3ApZufhEAeoNxjLg9ectbEywaliDCfYnbBEzK3AIq7CSEPvN7JLOmUk8ZS1xhurgT1Q/tsR0ub9F0U9P1xp0+su8Ztg2bkvtEBvAYS6Ud2M9IbTbpbczYOLhDbzDK+9CEFmulpdL4WbNl9VVOlI9tOHVhwjYbWYDXL/FMFZhWwtkk2oPzYC6JxreniKeV1uw/OoQurep3vpv/iQAsN3zNCik1hM0DdDBB645lJreitXv/lieU0tL1GlwlXTJ5Tdu04MD/9g8bWgjEpX9T7wZIdDVlivd0tZAYQsV2X1FDdUW4DDPPuoTTEtxyOwXq+RYaxId+0CMkTpToSU/IPQaXuMr4aYHCZNvrfut7N7hGxmh+lVePMMNZ9Xzs/wIMwYGwWsnvsLRmC+FkvR8uTUx+zzQ13gBUVcxDB9kKHDm2CZiMBUYWcKohyMk7dC1q7w2UGzw3jR4tQimM87a7//SF/+a5yiS3aUOglKPx+wJQ70iYRq5sKqzx+F+Ey0rEe8giyopehwWRCDd+Vl6/ys99TW1F5JAxWb34uJIFssTfNf7l+FWZav0gUVOtWNt9zosESd/Cs49Cazuw1WvG7pKGjkcd5Npxv1FxXgpt/my8Au6
 M/KsAv+r
 NpRQrNvWlnMB9RKrlO2/UPWrqCXJRP943i0s2cjR19rpsgNUaLvgPJQL3J9H1i99Z54LowZ1PW2svBfoblel1ToZmjpdtYRVndJqQwbdGmhq77Trwh7sHCsaOTGmHY92AlpY8lxx+hzcFCF3D+Yf7Hwr0atk9uvwmVdH1ozjYiabvVD1+pY0DU51eWFyujWKMkkIx32Jj8XV3M8ZPSn2Gyu82RU+5QNh39w21RxkYhYZbjGhIK20TUs73MX7NUCtNLOgMbkMEkaz1YP760GnQxhOwfzc1/8ubFM1MyyCsjPY0PFhJ57BEnxByCyaPaODj3zJHsv24oImDdPAVMkASjfsLhC0QbE7rGwGfRkQpWR7MGjuOWzX0HMGbTXvYaGr+FKN/tg1dQNh6GTzZFipz0KKKkD4BLOopwkXJ0eS0eqMApfGPJnr5vWHPdwck4nKE/MUkoZDiR4RJeE4Go5MYiLpoHUxJ7PmCK29S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/21 19:10, Qi Zheng 写道:
> 
> 
> On 11/20/26 7:05 PM, Xuewen Wang wrote:
>> From: Xuewen Wang <wangxuewen@kylinos.cn>
>>
>> The shrinker debugfs count file uses single_open(), so all memcg rows
>> belong to one seq_file record. When the buffer overflows, seq_file grows
>> it and retries the entire record. Queries for subsequent memcgs in
>> an overflowing pass cannot contribute to the final output.
>>
>> Stop the traversal once seq_has_overflowed() is true, using the existing
>> mem_cgroup_iter_break() path to release the current memcg reference.
>> Leave the overflow state intact and return zero so seq_file can retry.
>>
>> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
>> ---
>> In a single-node KVM guest with 1024 cgroups each caching 16 ordinary
>> files on ext4, the 8865-byte output required three show attempts. Count
>> callbacks fell from 3075 to 2472 (19.6%). With probes disabled, six fresh
>> guests per variant each performed 101 full reads. The median of guest
>> medians fell from 128.2 us to 112.2 us (12.4%, about 16 us per read).
>> Small and sparse outputs had unchanged callback counts. Complete output,
>> small reads and seek-to-zero rereads matched; concurrent memcg deletion
>> and signal interruption checks also passed.
>>
>> The successful pass still traverses the full list. Early exit skips
>> count queries for subsequent memcgs in overflowing passes.
>>
>> When overflow coincides with a pending signal, the original code can
>> return -EINTR in the current pass. With early exit, seq_file attempts to
>> grow the buffer first. The retry can return -EINTR, or buffer allocation
>> can fail first with -ENOMEM.
> 
> Would something like the following work instead?
> 
>           if (!memcg_aware) {
>               mem_cgroup_iter_break(NULL, memcg);
>               break;
>           }
> 
>           if (signal_pending(current)) {
>               mem_cgroup_iter_break(NULL, memcg);
>               ret = -EINTR;
>               break;
>           }
> 
> +        if (seq_has_overflowed(m)) {
> +            mem_cgroup_iter_break(NULL, memcg);
> +            break;
> +        }
>       } while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
> 
> Thanks,
> Qi
> 
Hi Qi,
Thanks for your review. I've modified and tested the patch following 
your suggestions, and will send out v2 shortly.

Thanks,
Xuewen
>>
>>   mm/shrinker_debug.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
>> index cafb566301326..3022d103b0b1e 100644
>> --- a/mm/shrinker_debug.c
>> +++ b/mm/shrinker_debug.c
>> @@ -74,7 +74,7 @@ static int shrinker_debugfs_count_show(struct 
>> seq_file *m, void *v)
>>               seq_putc(m, '\n');
>>           }
>> -        if (!memcg_aware) {
>> +        if (!memcg_aware || seq_has_overflowed(m)) {
>>               mem_cgroup_iter_break(NULL, memcg);
>>               break;
>>           }


