Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA020606A336
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NA+Y8Lq+
Received: by kanga.kvack.org (Postfix)
	id CD2D36B00EF; Thu, 12 Nov 2026 02:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83F96B05B0; Thu, 12 Nov 2026 02:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72486B05B1; Thu, 12 Nov 2026 02:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD196B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:31:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33C5A1C3CFB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:31:39 +0000 (UTC)
X-FDA: 85425647118.28.D609FAB
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id 078C7C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:31:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NA+Y8Lq+;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794468697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkSv46yCHtIqoXvtaUlGuoA5bkCcyG3dKOTi+O8s+8o=;
	b=7817ZEtc4H6UDruZraityWcOcLX5c7M6VESGpOIeA0zanPL59x3P5QFK0yoEDtjhCU89Np
	evRpbTnSo64FTjdLe9F4WvQVTSth7RyTcAkuxGKIaolBJmOefq46wBchZtVsqMrHebT64d
	Suj6rdB1zOnsWR9kcerL1guIRtV1Ymk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794468697;
	b=ej2S6Q/Y3VmHDok4w94o7pBA/0OAdQ8GbIC5sWojJQ7oyfurBs19UZXSHy0zlBsaiaxLWK
	fNP/ZPlsZN8MXTsWTR1iirZIUEMbSm+lK1h/U+HR9ZUX8J8UkEeONGE5WVya7oPnOntgRs
	O8QbcoB6I+GdogmrhrFQuGR25a0HVwM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NA+Y8Lq+;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=c6rVmPURZ3DT+JjErkgtV1mxI38IznosT0ADdpGxR3o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794468695; v=1; x=1795073495;
 b=NA+Y8Lq+cDGqZtzw4xGR7Z+rYhlYc5kEZj9Wf2Hmn89XoCjPbSUTy0bPCgWjC3gyr6BdN93c
 dC2ocsMaJpeagEvb78VirV/+2BWUhRbdDe7rev1Y9Mb5hCh5YGA1p4FraGwo6qC7NQCIepltXUr
 MfBgol3hXaLgGn6MND2cWhuQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 13c0695ddd446293;
	Thu, 12 Nov 2026 07:31:35 +0000
X-Mizu-Trace-ID: 13c0695ddd446293
X-Migadu-Flow: FLOW_OUT
Message-ID: <7df44933-e92e-4f1c-9b26-22a1a298ca16@linux.dev>
Date: Thu, 12 Nov 2026 15:32:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm/kmsan: skip vunmap_range_noflush when KMSAN is
 disabled
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-3-hao.ge@linux.dev>
 <CAJuCfpHneeqRFOXyzCPPPa66xfn7Oa1n5m2N67o_pVwJfNgeXg@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHneeqRFOXyzCPPPa66xfn7Oa1n5m2N67o_pVwJfNgeXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tr7byzu8dftsriwb9eq6h8z5rd7gqkoo
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 078C7C0005
X-Rspam-User: 
X-HE-Tag: 1794468696-543472
X-HE-Meta: U2FsdGVkX1/G/sNFGGpaE7TiQaD3WmO/mpbmYA09ICwt+3btXR2psAvuN7rihOIq9VjtS+fu6fhsT+g342U4cbBXCY5mUyCbuNGqo7QxxwGQifjC7YFlYUVfLruf2XJLsWZDYiVZP6VfqpTUR18aWks+xeX0HnbVuNXonpRzWzW1RSDdTjv0iulSqgjsg7hIPSmDrJXD8L0FviJM/VqRk0ZCpMkm4Fx2grqJMB0sA7XCXhbsCClARK4GHHC2GyZNzh8qjaOBGBlp+4pOfttihH0r1z4mJskL33X0gcKiGN2E2tK09OQj62d20C5d4U1zf+hlXLUDix6Yc+nar2kHmCegwTwWFf+Uy2RkU+Ik9c+7XXYfSJgygpm0jfGqMZWG+O3Ri0b/uQBD15WxQddAz3wWwVBndVNJantkUQecPe9QsdiKsH/6xVba9azQLBJrZV5vprMGOjFTL50WeQuWgi5SSpSqyfUlPjBdR0dwh5FLpVyrK2TPb1CikEwzAbHPujoZZ/8vCUA8+zQ6JEsf3OQ6+kG5GV4Y9i0IOevHZ8FNHhKky/JhEk4OqpHgxAU+9q+QgbLjADR+Bz8w+QVbCipIGUyvVwOSe0QzKA0dHnXyo1X2RZaIHpHNrFfxAWK8RMEWEl2/C7kIT2r/3oPbTXXvNWLePIyJqTRptn4U6emBEtxE37BIB371SA4ZxU7Sv6imrXihqUlD96OfD1bMKCEDGrfq9GT7kIJG7R7QkqpjsCsPan+pCgzVRmNg0J8uEiTmAj227Fg40RGVNDeYkddbxPOgUMTLvUSpABW1GIrxme9stFTHhMrhA4SXtYCNDubJQXJsGwPQRWLgFxtI4B4vwYBMs6A/KXD/V7Z4iDUP2nitXQWJoGRnXDCgWFv5TU2q58taqRncKaU2TN29jxTqADff0jClUSAfhuUw14Ukpn8ckQRhAGd0WQat/fftMlrSZPtl131Tgp6FUJY
 kTZAB9jx
 PyQsft9vZi2xxpY72Vag8jgJMKXk/AqOTpjTnABSlhmLtFtz7S2hoHCNfQYQCKIqYlnlsc7f1VQpWzntatqzqFmJ2iovgelpa6Z2D7cgDovgScnjSDL0EEzQPIp/xn/35G4+QAkJ8/iZdGT8RJWqqOs0UZJha8XRWinrd6BB2UmYAlZqkF/aId6SOqEoNPxKGeFDTsyqjbgQLgBOrh9L9j9L9T+PLs/0EAo4vUGuRkW6/2ZKbNLXBiBfSLdnB/0K7VtmgN/Eromoi4GOorHYz/fD+COM+KIwE0GCFfs9Pgjj3pgUGYxPcP+drLoCpecYwsVzGBeU5miNSVd5oP4kfTAD1HGM47TJAQKRbj2sSAk2BYjUrGJ2CaaS9bBtWx89UWwvCdop0y8DO7yCiEmxx2/rRZ1xXvNbJiNJF8eXhaSE6gLYOY0BJGdJkQUsq7yu5INLJH93f6pM5njJbrpgUCm24ec6ZuKSN8SD8U8k5vWB2m3UYv+W4+xtLqB651L9iaUt1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren

On 2026/11/12 06:10, Suren Baghdasaryan wrote:
> On Tue, Nov 10, 2026 at 11:24 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
>> false.  The unmap side does not, so it still walks the shadow and
>> origin page tables even though KMSAN never installed any metadata
>> there.
> 
> Note that KMSAN_WARN_ON() can reset kmsan_enabled flag, so the fact
> that it's false does not mean that metadata was never installed. I
> think a proper bailout should depend on CONFIG_KMSAN, not on
> kmsan_enabled.

Sorry, I did not realize this logic.

I will go through the code again and will probably drop
this patch in the next version.

Thanks
Best Regards
Hao

> 
>>
>> Add the matching early return.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/kmsan/hooks.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
>> index a706666db097..107f66841274 100644
>> --- a/mm/kmsan/hooks.c
>> +++ b/mm/kmsan/hooks.c
>> @@ -138,6 +138,9 @@ static unsigned long vmalloc_origin(unsigned long addr)
>>
>>  void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>>  {
>> +       if (!kmsan_enabled)
>> +               return;
>> +
>>         __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
>>         __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
>>         flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>> --
>> 2.25.1
>>

