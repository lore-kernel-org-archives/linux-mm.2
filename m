Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2527606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Eu5CzCZv
Received: by kanga.kvack.org (Postfix)
	id D81FA6B03E7; Mon, 19 Oct 2026 22:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D328A6B03E8; Mon, 19 Oct 2026 22:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48576B03E9; Mon, 19 Oct 2026 22:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7E66B03E7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:25:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EE3314080A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:25:51 +0000 (UTC)
X-FDA: 85341414102.07.9DDC62A
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3F35A0002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:25:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eu5CzCZv;
	spf=pass (imf15.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792463149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkEnDwBugjwZfgs/RO2JOZXA4QXBERjlTcHQBq6IyoM=;
	b=eZpC2atE+3nUUxMlVcsW5wYSs1RC23i893hchiK7eQacvYTCTSaFR+fslMyZ+uMYTBZSbK
	BBi2hrBs33ZOTuzXef6xCcjyelRgY+4mX96yibUcnhvm9mGMb4OIvzHZGFuhAwKal13b8a
	ka37fsOdwn16MvSCvb8Cn/7C5RBl20o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792463149;
	b=ztjvRxhHQPc74RC4mTnJMqUePuIs2fT6dd8O3crUS/uhPnjiG3v3g9ELtgfQhdKWRcBKXo
	+NBErETuEqMhbMPlKterwIcqINLcNroF7rxblY9CD7uygD4hq9XgKVXzBSoHPjdZh/SaWJ
	9AvvtLzKFEOT2nVJIwB9ywQS5q64qxI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eu5CzCZv;
	spf=pass (imf15.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ntRwUSpnw+xfJNy+369eirj2tCJL/FP5kPFnotn1kaE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792463147; v=1; x=1793067947;
 b=Eu5CzCZvzQRuuCA4jfdags9tIDsCpkho05xTr2bk25NTRylCoWFFZqCdb74tCez1dfqXk84q
 tgTmzMKC43zv9NP6sLhL3AIRUHbkLEMLC3urYJ0LR4W7AArVMfTJYhRpYT2Ptn9m09VoCsXi1f9
 3Ya8E92vFRKlQukG0nRQFpiQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5b8ad6c55f67365a;
	Tue, 20 Oct 2026 02:25:47 +0000
X-Mizu-Trace-ID: 5b8ad6c55f67365a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b0d303c5-4ca5-4ccf-9e24-499a9719a50e@linux.dev>
Date: Tue, 20 Oct 2026 10:26:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/kmsan: skip vunmap_range_noflush when KMSAN is
 disabled
To: Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, Uladzislau Rezki <urezki@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-3-hao.ge@linux.dev>
 <3cbb17e3-e201-4138-a070-0c64289a12bb@arm.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <3cbb17e3-e201-4138-a070-0c64289a12bb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3F35A0002
X-Stat-Signature: amuuxxstc3zg8j3mxhnowdggj8ngjijm
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792463148-104123
X-HE-Meta: U2FsdGVkX18SLzYFTxhz2GiiwtEzx961A6iwrszZ8bYX5E+hbj/n0EnaSFHXb1FS7zqxUBo5zW9YY1+KYDQJTvMrpmCvLqUkoFtuL6ZogwrJoLJNrz8HINpQ+7MpmTB3VEvTK0tAzFGiLECYdd39y0iYMGP01gQ9YCJTdou3sHMdjpAE4pg3l+zR/pCaB+ggA4r1pPdL2O/VAk2H7UgAaw4hhdlOt0+ZPlaQyfCDDr0FLdkb+6lVkFzYwBUI/NFT6VfNjGa2rA3tciEpDZyAeKvAepZBoBPPxfv1kAV0kLZlCsQXRMXkyeGdCJ4yseppBLhAMTAcLnkx0+0fydyDMczy3gemq4yfpa7yneEAgP9GP4W2upktKv8EwLybJQzBWmIZwBjC6bd8ZQc8my8c9yNSxc8JKpUqFAa6v5MCWCAPs4WqErEqxRPl5GoOvChxSLxaLp3ylSr3qg7WLahToyjVjgIw59DCtGXOMtb2BVqTgKbS8jG9q6ILCaoRmmW7BmQts7bInw1AWRn/9Qp4deYDNOaGHX+gSV/fnIdoqxgum1S7CitABDJJTaHuLtL4H1WW13QtTPeUECkkDbE9/xN+OoYtY+LBFExPI2DQlyCJWgCetL16kCsrJRP7OHC2gfe4uqPttlDsiv/CsB0k0FlBeyW7uMov7FXooSkRnRHifsugY4bt06TeN9/qNIILfYo+LmGb8nRMMw55ty2Dz7WeL9LOjqus/Us7zFHbTS3O1V2ZEfGv7DWyR0n6t9JUo9vJ0S5CsVG5vG70m/zC/yNrZAwyaCp5IPtgjQNEaMWs+qSOxaf90RS9QOEQltUxAfRjfrrFxQUqN9YY7wXAHv66BBkKsaut+Ihz/XauEWwl7z3hYtGaNSLBxAqpemHacOlY4eZrG4b6IL6gQocns9G0xcU10Jc42CdLWzxDAE7HBH8OjXVMmuHNHROycuTpdJikCwBvlnhrKyXtfvc
 kP+Oe9Q1
 aUmLDquOtE/JOPj0e80v0WrQsn9IVgSgkHN3+oF5/Ak+8FHZ+Ncf27hERvDPfm2UPABVmv1wUIitl8tML3fXJSmtkX+23AXNbeNU5bh8DbBM2bDICkVu12cV3IfL3Y8jTP4Cuunfy7UT0zX9JAtXj3B8bF16964J44YEznizarNyYxyqr/7Y53CHZF3QaOujpuf51G6Us0dL1/c24RK0ekWmwHsUbEdUzX7WF0r0rqr6JxLII+d1QjgC7ifQ3AyGwKGNotCUxW/DqYhTlHTOX3vetzc2vaAeKskuCx0Ca3drAgRzt0rXvU4j2nO7nxXzXIgwQhhsnG8ESdVzWe5Ry2ZnHPXPVrMGHk0m4N5TheXND4qEmY9z/8h70iu9kLy/fO9eyqXper6HKn07PSz78jAD1R/Tb1NLf8/6dbUTmdVhADFg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dev

On 2026/10/19 23:22, Dev Jain wrote:
> 
> 
> On 19/10/26 11:15 am, Hao Ge wrote:
>> kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
>> false.  The unmap side does not, so it still walks the shadow and
>> origin page tables even though KMSAN never installed any metadata
>> there.
>>
>> Add the matching early return.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Cc: stable@vger.kernel.org
> 
> Cc stable without fixes?

Oops, my bad. The Cc stable was added mistakenly.

> 
> I guess without the fix nothing is actually wrong, except doing
> wasteful work?
> 
>
That was true before, but not anymore after Patch 3
(mm/vmalloc: undo partial mappings inside the mapping functions).
vmap_pages_range_noflush() now does:

int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                pgprot_t prot, struct page **pages, unsigned int page_shift,
                gfp_t gfp_mask)
{
        int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
                                                page_shift, gfp_mask);

        if (ret)
                return ret;

        ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
        /*
         * The page tables undo themselves on failure. Tear down the
         * metadata that was fully set up before the mapping failed.
         */
        if (ret)
                kmsan_vunmap_range_noflush(addr, end);

        return ret;
}

Sashiko report: with !kmsan_enabled and a caller passing an empty range
(addr >= end) the flow is:

1. kmsan_vmap_pages_range_noflush() returns 0 at its first check, it
   never looks at the range.

2. __vmap_pages_range_noflush() hits the new WARN_ON_ONCE(addr >= end)
   and returns -EINVAL.   

3. ret is non-zero now, so the rollback calls kmsan_vunmap_range_noflush(addr, end),
   which unconditionally does

	__vunmap_range_noflush(vmalloc_shadow(start),vmalloc_shadow(end));

   vmalloc_shadow() is a fixed offset, so the shadow range is empty too, and
   __vunmap_range_noflush() starts with BUG_ON(addr >= end). Panic. 

So the guard is not about the empty range itself: a caller passing an
empty range is buggy, and on today's kernels it already BUG_ON() in
vmap_small_pages_range_noflush() on the small-page path. Patch 3                                                                     
deliberately turns that into WARN_ON_ONCE() + -EINVAL, and this patch                                                                
makes sure the new metadata rollback does not turn that recoverable                                                                  
error back into a panic when KMSAN is disabled.     

But it's only theoretical. We haven't hit this case in real usage.
We add this guard merely to reduce unnecessary work, and incidentally
harden Patch 3.

Thanks for pointing this out.

Best Regards
Hao

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
>> +	if (!kmsan_enabled)
>> +		return;
>> +
>>  	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
>>  	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
>>  	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
> 

