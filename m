Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8311CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78FC6B0088; Fri, 16 Oct 2026 04:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50AE6B008A; Fri, 16 Oct 2026 04:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68986B008C; Fri, 16 Oct 2026 04:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98C906B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:42:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E0C712027C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:42:52 +0000 (UTC)
X-FDA: 85327848984.30.2434D1A
Received: from mta1.migadu.com (out-34.mta1.migadu.com [95.215.58.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id ED40C40003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:42:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N/8jteUS";
	spf=pass (imf11.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792140170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zm/vQhJcensdMKuEIAgiofMk7UmG18KsVxwa8A3YTfI=;
	b=FKeE5TS9+YK+bT3BMs/2bLuRAnxFakiGsM5bWJHDtjqeWiILq5vgNWBsEhTxUvB1zG9Xpm
	iJyT75fENWhISzS2rJZScUmtJpCiO+eYG0MMdXr17rq0sJkVgdKI8Bue2FpeAeymJeESTg
	wzXH7LVCKcrE9EQlPrSOi0ULZr+UHOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792140170;
	b=kxnYLgenk2nYe8emqHN2pv1Q1URU9anyDzkHh0APnHuXf6dJp43D7JWrBFSDxE1HKxXa6a
	qqsg0yILjJWIfSjKZhxW/LgIVas3GL6EN9vWxK/GazzEyqEIWWprkxSOkRFWlR/db1kXPh
	Q/10UUaRDQZLcoEuaaBqTEiehsROSOU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N/8jteUS";
	spf=pass (imf11.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RaqzrXtafggiA6Vtw0Bb+3qEZqwTeX7kkg/munQcgtU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792140166; v=1; x=1792744966;
 b=N/8jteUSYLggGuggM9L9I0nFUtkGtWOZ0WssG0EGV+8tYO1BU7Itoe6op9w47M/uHvvLEPpF
 fpsF6bUevSpYr1pDIKHtPy0Ht8no21J0mYHn3uVloAxXfiEwHwP6mdysw0+vR7AJrZ/f6MPeBHm
 xyb/yUPLfr1MEG7cvBawhn9Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 88eda0bda127cae6;
	Fri, 16 Oct 2026 08:42:46 +0000
X-Mizu-Trace-ID: 88eda0bda127cae6
X-Migadu-Flow: FLOW_OUT
Message-ID: <62d17959-d695-4fec-a87b-8eadaaf995a8@linux.dev>
Date: Fri, 16 Oct 2026 16:42:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ED40C40003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6itmiqxnybmcn8d46rwdegmrktrmyuu5
X-HE-Tag: 1792140169-452300
X-HE-Meta: U2FsdGVkX1+qunSbSIGgmiiaGHLiYte8+YS4OqWEA11+eXPLTxJWS9qFMYMB2UW1oCW+2Os1dMLvPvF3O0bvbcbqr6q6QR64qrClD48l/WQX9Aw2AuZdcapP28mzYY9+7/xHnxyPc+DF78svlUe8qqeNozxpFLPPaJKFeA+Xd3vI87ZeJ5iHNNcraZ8X9K9I5FvPLuOdnsXECKc2yMaXhgXkmARtg+1USFgFhLyJ93bNImg6cBRsJ1mmoShefrSeOO6rguLPsSA8eoz4vtxJMuKuRMdtFQUcgZ1VGPCnqH9QaN3R/8MJO55N6PPTrUd31IdCLAwYj9bhrqMshYidw6IIIbUm+nNjJ78VP58eFxKzdt1cJbHGGC3ZL74MKhUAzYA0C7VNWpZ6hF626j5oPXtxiykec5SlCYgJTHVCturnOKObnYOxBg2jckoV1gjON7+9SLo5FyRmx5S1Ch1gQ8tjAn74Yy9ac8ihkVKZgKiRvXNgjPhsPcTp6A3tXr16ZQ0EcX+hmu9ok/JgL9QuIUchRmVmkbi1+Gc/CyuwqZS0d8aasCgkWNAX8x0Fvl0oNInKfUKhB/tZOO7aznRtNaI8aGaZrp7QA/vTElqO11WjiGpwpnCa7AofGHsQ0clN03ERIq5Zl3GXyjbsZjE1/OiPFsPGfanbkMQQUmasLEmYISBXRMzDEw2ueskIThjAJ/syVyAemTkDm6rD0FW2ngxWP4rfNdzwnbz8+XJwOer5+llkagv6lyc666RFS8CpdyMEAmpk4jHfVDoooVC1Ja18c0fWidkvDFnnV80bG4KS1vdxfdR/C1gLG1A1FH95+8e+R3kb8+6Jsf/rCyt9gIcefzN5jKBlTYT2T/bc1vlZLmqWfUa/aB2P2NBaYIrs1/rAJgOVtgNOgmuBWgkNe5xM3ZVJbsbrgNzMlIuMmRqsr2aay5r6iuUjIxA8Lw4GUw8mxSr/76jhjI35pVI
 nftpjS3d
 B2r+aQK/A9dHTWPGXKamZcrYRp73Xamz8jDc+XooV5Bh3BhMHuWocmBzU8V2ODMkTaug8pCcQttAnf6gq4NAyWwNEr7i/3dA1BlRnpjo8JjgjbQm/TtD0XKa5zxdt69f1OFdiZxnywWoXgcrxzmw263rUpgvWLQ2EIg49Jn3F4jbv16+U/xP3vQMKIqmmqZ54L6rvYdO6NiBmvz6kzcuSK0sfcIXNGKzamcPMZDKllh6cutmGQXU0pHSFmfuGcE4Dehd+ee+8thXnJ4FAc3+NHmzvyCb1rjcyxr7dZnAQnGwrgnBYD8Sjb2mLrwuYgDwjkNn6MG/Z0oDgIPngFUxkV1DBmFu8D4s9pfbrjBw9dlR5DmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/16/26 11:05 AM, Kairui Song wrote:
> On Wed, Oct 14, 2026 at 5:10 PM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>
>> On our production hosts we saw swap cache only pages keep growing for days:
>> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
>> swap slots were held by folios that no process mapped any more, charged
>> to cgroups whose workloads had long exited. The only way to get them
>> back was swapoff, and with other services actively swapping on the
>> same host that is not an option.
> Hi, thanks for the report.
>
>> Such a slot has swap count 0 and an unmapped folio pinned in the swap
>> cache, left there after a process exited or did MADV_DONTNEED. No page
>> table holds its swap entry any more, so nothing comes back for the
>> slot; LRU reclaim drops it eventually, and the allocator only reclaims
>> such slots once swap is half full. The growth stopped exactly there:
>> at 50% of the device, where vm_swap_full() becomes true.
> Hmm, I think this indicates a much cleaner fix is available.
> vm_swap_full is inherited from the old allocator, we can instead just
> let the allocator reclaim the slot if the slot have a count of 0 and
> ignore vm_swap_full at that point.
>
> Will this work? (Just a minimal implementation for reference, will be
> even better if we can avoid the overhead).
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c3288910b3e3..94670fe82f31 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -212,6 +212,9 @@ static int __try_to_reclaim_swap(struct
> swap_info_struct *si,
>          nr_pages = folio_nr_pages(folio);
>          ret = -nr_pages;
>
> +       if (folio_mapped(folio) && !vm_swap_full())
> +               goto out;
> +
>          /*
>           * We hold a folio lock here. We have to use trylock for
>           * avoiding deadlock. This is a special case and you should
> @@ -903,8 +906,6 @@ static bool cluster_scan_range(struct swap_info_struct *si,
>                  if (swp_tb_is_null(swp_tb))
>                          continue;
>                  if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
> -                       if (!vm_swap_full())
> -                               return false;
>                          *need_reclaim = true;
>                          continue;
>                  }
>
Hi Kairui,

I tried it on our box (224 CPUs, 931 GiB swap partition). It doesn't
help there: after 100 rounds of the reproducer the leftover is 291 GB
with it and 309 GB without, and both stop growing at the same place,
488 GB, half of the device:

# cat /proc/swaps
Filename                Type        Size        Used Priority
/dev/nvme1n1p1                          partition    976561148 
489006260    -1

# cat /proc/meminfo | grep Swap
SwapCached:     489006260 kB
SwapTotal:      976561148 kB
SwapFree:       487554888 kB

cluster_alloc_swap_entry() picks clusters from nonfull_clusters first,
then free_clusters; it looks at frag_clusters only when both are empty,
and at full_clusters only when vm_swap_full(). A cluster gets onto
nonfull_clusters in partial_free_cluster(), that is when
__swap_cluster_free_entries() frees a slot in it; after
alloc_swap_scan_cluster() has used it, relocate_cluster() moves it to
frag or full.

A leftover slot has count 0 and a folio, so __swap_cluster_free_entries()
never runs for it. Once the live slots of a cluster are gone, nothing
calls partial_free_cluster() on it again, it stays on frag or full, and
cluster_alloc_swap_entry() doesn't pick it until the device is half
full. That is what the swap table looked like after the run:

list      clusters   leftover slots
FULL        106415       54484480   (all 512 slots leftover)
FRAG         44822       18471614
NONFULL          1              0

Making cluster_alloc_swap_entry() revisit those clusters means changing
the list policy.



> Or, from the LRU's side, put swap readahead folios at the tail. I'm
> actually trying to do that and it's not very easily doable at the
> moment but will soon be easy to do.


That helps the RAM side under pressure but doesn't give the slots
back.


>> Options considered:
>>
>> 1. Fix it on the readahead side: after the read, check the swap count
>>     and free the slot. Covers the lock, not writeback, and the
>>     asynchronous read path unlocks in the bio completion where the slot
>>     cannot be freed. Two places to patch, neither clean.
> In fact, readahead checks the count before starts the read. It should
> prevent some of the problems but seems not enough.


Right, the count is still 1 at that point. The zap drops it to 0 while
the read is in flight, after the folio is already in the swap cache.


> And another idea, what if we just add dropbehind flag or rotate the
> folio, if folio_try_lock failed in __try_to_reclaim_swap?


dropbehind would work for readahead and writeback if the read
completion honoured it too; today only folio_end_writeback() does, for
zswap writeback folios, and swap_writeback_dropbehind_folio() expects
the folio off the LRU. It still misses other lock holders (migration,
split, ...). Rotating only helps under memory pressure.


