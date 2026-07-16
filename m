Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4546AC44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC4E6B0093; Wed, 15 Jul 2026 22:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D756B0095; Wed, 15 Jul 2026 22:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A986B0096; Wed, 15 Jul 2026 22:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D45BF6B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:30:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D574120339
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:30:37 +0000 (UTC)
X-FDA: 84993061314.05.180A70C
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD553A0008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:30:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Rtq47d/B";
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784169035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNqDS6Sst+3PphAHyUf5zrIect6KbXwTAMVNSLXGdEo=;
	b=7o+jg6ywifWmeGkDP/Ihf/TZ55uDjAR4dku9MoFoKbV7PdWa4G/jNcZl4n/cRI2YNLr/rN
	9PcH/JlfwrOpSi5OBa8uH1pQywdFNJIumpokERpn6a1MOmYnn8guBhrw/wOt8k5QrGeCFZ
	Jze5/id87KkRGV/b9TAZbb2pRtHA1Po=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Rtq47d/B";
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784169035;
	b=UY3siYaaWfqknfniZijzyLskopfw0dvVsbCabU/WDEak6DH5SPJ57tXnykEH2ckjL7oDXB
	dmR2bj7JsphjUeRhquVvlUIavp/Vue9y7LobwL4NUf7Vk3OdkvUGkvDKCMFtp2Uu6GJQXc
	+BDyoZf9Y625y/MyQNARempnbPfHng8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784169030; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LNqDS6Sst+3PphAHyUf5zrIect6KbXwTAMVNSLXGdEo=;
	b=Rtq47d/BzreaeFfC2kpUoEnxOTBWAHD1VdsaTbBARA7eSjmhTzSTVY5PtJK9xFuT+DBe+Nciww7RgcOOKw4LuiQKjyRrpJB/nlfmGTpAaTtlOG+O7XPNNBeRvuSYfdIljYjLEXlFP2efJUDWUbht2P9v3fC9XCeeVcwdRz7Iyb4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X7B-Pz1_1784169028;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7B-Pz1_1784169028 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 10:30:28 +0800
Message-ID: <4067606d-2b39-4b17-a3c6-be8f09c6bf96@linux.alibaba.com>
Date: Thu, 16 Jul 2026 10:30:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: promote mapped executable folios after first
 usage
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, mhocko@kernel.org, ljs@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <4b921ed528c483e13c9e22d1ae44ba58b4a15b0b.1784096432.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7C47i-n-e=EGWoBvydp8mT3n-ZFeiLFpY=iTVDayucTRQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7C47i-n-e=EGWoBvydp8mT3n-ZFeiLFpY=iTVDayucTRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD553A0008
X-Stat-Signature: 7gjqdeb5ig9u46hrrf6d8jtjm6t1wfsw
X-HE-Tag: 1784169033-752153
X-HE-Meta: U2FsdGVkX19TZK60kdeC2FciGZ8/jFgpnRmGX4Zy/WeB8XJklNvv54DXbeM102B8iGiCghFO7KwCdRTHqXmRHCFckZzJf/Pc1dHYZPrWdkc7HvkIiQ0xTb5Sv6qIP0P1etbJ4oklfKg0JQaYuFqJDMIiHzgcL9nDkc1xdBfdvPscPVpAiz2E1hybJsXIdzKELpnjlDKyOe4WtBLhFijpJZp4+y7tVVf7wIBCPg0K7XF6yqdZsoxAM/lne9cu0SMqoNDQn+u1phHasAru/w/uT2FuLnRr2GfHNsjBKEOzUYGkTwlvUtbjTlPWLWB39HXLit6G9wVPPgIYOQcilloyVzD4DVsjzRNBaE8w3tg/KDNQCRKD6KhkaRNX1DVusmLfEU9sBMnrAJOndTEzgZwB8LFh6BFs+91LC/jvj5EcO4s+mQOaquzTtfXT/1w9G8qMH+PBy76R45zdhuTApFx7v5uq+3hpo++iWTaFj2CqUih7hTwQnvjxHGidPTPYxgThn+WcawQVlLmVKVM+ZT7n8V0K2yV8Zi82QtwdRSlDJdQRvIMGL4QtqcpIkmWKjAJCn2ugcCHLSyWW83RYfFmcO2cSySz0d86453eGtYrhj+z7RPDhQwyQRV1B1+MPatz8pxLdoSa6Dro0NedV3n5r+JuVuCfqiQqizoZ0ssJ+rZsqEc56vYX4VBFL/e+vExxd2vk8CsjKf1BuBIAtm25OMmlzwAipVKbEBFtjSedHNU3ZeYTSZfnhjydbtS9r2dvIPyIhtsXYQJcP0Q6FQxZ5XHQ4SVxp5AHGY98bjXL6gGnAfX5d+/B7Dj1ZVhvG0vGgeUbXTwOGUBOII02OBAG2RamEaYhMZIc+Gjt7hsP+TpSc9hGV2eJ1mMCRX04gHiJe+E6SRHRDx2Ih1/S/Pcb7Mq9n36rEGZDCNM7Q9ldLH44gfxOwyBJSu6P4+PHP9VIBKkLCegb9yGPIvsZboao
 E6jGXNO2
 TMWvp7cj37MHMAfU7t1aeuYb66k4X1b27asXZyB2ZrZtOxeY90OTVs9CTn9qj1Kzd0KUJnyQEp+oLa1gesTlKi49DVkxx+gn3rKJJotZvGUqVL/GxP3HVICuB2kHPmx7gdzZfKEmSHsXKfJTPGkDDN92YhAiB448aKXSi0CbFvq3J7HAiIFQIRSuNEUDFHtIecNWpJGxN1mnxU61Lb5yy/R+wW9GKW3WKidyGCvirjFomqlB0frXMUwQTlMNzKhXxrbqKKUYxp5hdzEGRM7C3xP35Q70P2dRwRJErP5/kHXUltbVKVdKFb5k9YRvViwo9Oi7HhG3tiLMdDSl7n6NXHZMjSJ1NMbLDK7LA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/26 12:50 AM, Kairui Song wrote:
> On Wed, Jul 15, 2026 at 2:33 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> 
> Hi Baolin,
>>
>> Classical LRU protects mapped executable file folios through commit
>> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
>> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
>> after first usage"), giving executable code a better chance to stay in
>> memory, avoiding IO thrashing and improving workload performance.
> 
> That's really a long history for those two commits :)
>>
>> However, MGLRU's protection of mapped executable file folios is less
>> reliable. Although shrink_folio_list() checks references, the access flag
>> of mapped executable file folios may have already been checked and
>> cleared by lru_gen_look_around() or walk_mm(). Additionally,
>> folio_update_gen() only sets the 'PG_referenced' flag for mapped executable
>> file folios, which causes shrink_folio_list() to ignore the first usage
>> of these mapped executable file folios and reclaim them.
>>
>> Follow the classical LRU's logic, promoting mapped executable file folios
>> after their first usage in folio_update_gen(), giving executable code a
>> better chance to stay in memory.
> 
> Yeah I think that's mostly an ideology issue, recently upstream tends
> to treat all folios fairly if there is no particular reason.
> Personally I also agree that some folios are more special compared to
> other though.

OK.

>> On my 32-core Arm machine, with the memcg limit set to 2G, running
>> 'make -j32' to build kernel showed some improvement in sys time.
>>
>> base                    patched
>> 9248.543s               7861.579s
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/vmscan.c | 25 +++++++++++++++----------
>>   1 file changed, 15 insertions(+), 10 deletions(-)
> 
> MGLRU used to favor and put all map faulted memory at head, so could
> this be related to a recent change in any way?
> https://lore.kernel.org/linux-mm/20260526130938.66253-1-baohua@kernel.org/

I haven't tested Barry's patch yet. Personally, I don't think this is 
closely related to Barry's patch. Though we put the faulted folios into 
the secound youngest gen before, after aging, the mapped exec folios are 
still not protected like in Classical LRU, and can be easily reclaimed.

>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 986dde8e7429..429857852bdb 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3188,7 +3188,7 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
>>    ******************************************************************************/
>>
>>   /* promote pages accessed through page tables */
>> -static int folio_update_gen(struct folio *folio, int gen)
>> +static int folio_update_gen(struct vm_area_struct *vma, struct folio *folio, int gen)
>>   {
>>          unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
>>
>> @@ -3196,10 +3196,15 @@ static int folio_update_gen(struct folio *folio, int gen)
>>
>>          /* see the comment on LRU_REFS_FLAGS */
>>          if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>> +               /* Activate file-backed executable folios after first usage. */
>> +               if (vma_test(vma, VMA_EXEC_BIT) && folio_is_file_lru(folio))
>> +                       goto promote;
>> +
> 
> Do you think it's a good idea to extract this into a helper e.g.
> folio_is_executable_file?

Good point. Will do. Thanks.

