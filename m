Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5EA606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WTrfVq08
Received: by kanga.kvack.org (Postfix)
	id A5A316B05B0; Mon, 23 Nov 2026 06:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B44B6B05B1; Mon, 23 Nov 2026 06:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C336B05B2; Mon, 23 Nov 2026 06:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57F0B6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:33:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDD0B16083F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:01 +0000 (UTC)
X-FDA: 85466172162.04.D86F2B4
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70BA8160007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:32:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTrfVq08;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795433580;
	b=Oz/GKG1hbHhfitZ/vS41POpVbdMhAE/Y/sF6t9uHhVhWMtcy2aBmvxSC37KDul4mGFDx7T
	ld/Swgr9SoKXnhoe2hygOIkzmxu88T0xZCCGD64tQdMzOZ3OsmNmVC9VRs1GRzRE9YXp4t
	QrFR8wolDlchu6cCE9HDQjnXdC1Eo3A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795433580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/yjtbcg5So+54TQQrwZaOAyU8C7v2qrotK0MDLGBlk=;
	b=fRN4yFLN/vUsk0A4V80Pv3vgcUiYBqlT7qHC1DJsvnJefCftierGDJH5xMvPau2fDt43xL
	Qot5Kw1x2DtJiQroD0MAyaU+XRvFz0K2llXfR+aSPHx9am6JaYlrhb0ghHmMd07WWvRvPL
	7xRN2pwO74GZZuzg7MaCYzd+sxx+U20=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTrfVq08;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EJgnsJKgFUNVuWQixFdvu+2zJ14nbsStpxGkd+Wpnts=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795433577; v=1; x=1796038377;
 b=WTrfVq08LkZEOI1ZPNilLy/If0IKJhvvY/gDlg1LlJiC047SiyuW7EevjWWerKUAaXJb20BW
 cnQQ5/ESEek/bGeynjCYTAHQulDaSQ+WXJU1qH+7/+981YeFj8iUirRy0V1hvXtHOB3ex+OHPgn
 r96lyXxIb4XkD4p51F62HMNc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6b58d3fb24c8c492;
	Mon, 23 Nov 2026 11:32:57 +0000
X-Mizu-Trace-ID: 6b58d3fb24c8c492
X-Migadu-Flow: FLOW_OUT
Message-ID: <0e30c5c2-b9d0-40ea-b7f9-af9a8854bd58@linux.dev>
Date: Mon, 23 Nov 2026 19:32:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/11] mm/vmalloc: undo what vmap_pages_range_batched()
 mapped on failure
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
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-10-hao.ge@linux.dev>
 <CAJuCfpF_=KV3ArFO5LtMjc4EGMr79tX_tX2K=YCG_JTvC51OfQ@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpF_=KV3ArFO5LtMjc4EGMr79tX_tX2K=YCG_JTvC51OfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70BA8160007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: af8n3pcw1ysqzi6mzomr9cpq17wq4x6j
X-Rspam-User:
X-HE-Tag: 1795433579-79470
X-HE-Meta: U2FsdGVkX18apLGgUeb90ZtGRpn2mG8+mFXdf+8LVYqj8nMpeFypjV38WET/zqLyYpCBhyvx03+ZOpKOa8GdjaEe9o/GBgi/PNRk9M/UoqWOaEJ72aoNJNEvKr6sWpiqjIdQTLTX4uXeUTt2E9BpW6oaD5OOD74V5jKTpM89qqqpH3ghVGuqZN6eoeKpZue2mY7NyT+5XhvjHoJLC6MxhTQC1xwvstDh2TGTejdRru6X2BOrOsobUrzuPAW6R7sdEc1+yEg3cflzqeerhuPqlWMkioo83Rffk1Q6R78/6/f2G61lONBncMjwPvQ0ET6NbMBzsIREDDtypqRkWiAWiTYTgwTtRGtAiqNtXIH+y887CRkqgEC0wZnM8M40qiSPBqhhayULg+uXASAuOI0VQsiaki3aZvxocCxWg8+9rqMcVfd5WoGPjMs2ZuOUD9EBTwnBvyy1DTgcC8sE4pONsi/WDDZRutpB7Rrw6K0KBt2EIJNSdDzT2LrGNVtt/XRRsjp47YsOIIBonkPi8uK/kTCaRtOIPnGR+TjCt+yqM1T828raO6RxnIRmJ59By3EL8b2Uby4hRkv2DJKz42EblwnmDd3wm3QGFXp0Le02MR2eBjmGY7w75QWQuHJc9BWKHZxF5fpRX2XLgC4cQLeZCD/p7LccSIZ3LYVHEuCZPpCpgCmnkJlOugE/Tr7ojJfXWPqNZZCLBIkYgl/CdEQxfiMk8kC69KP7wZ+RqPy7x4r4WPgspa6w8GMTkW1nFRGeqK2wQymHB5Mx4hkliN0A6nSCGgygREe8dg2x0xjrCk4HJrgbViO9DXdUMxh00Cz5lmpQiqmWWm2ZAvnsGO2xn+tUtOQ9Bx7h8441CKc0KqJ+qUeg+l2NVeQsWX7NifBqevkSmwfZyxiF5WE1ITe3SHBVTkrqPoyeFM65+y2JeY6GZVl9Jvph/7sGhrETBxaM3g+BM8ULlx2vzPixBto
 +9H0iP6r
 PDliXhw02HC6bT4sMbLVvGxg10SSYhFcjk7gjudisxgfaNgr1MR4G2h5735BGMfp/uHZGibOWEPBs4bna6nRi32RXEUWfTAH8yh3xbL5T58bLnSv7HWZO2A2kn/zCrvv8VFCPSAdjbEiYJnjwdZztR+bUiCh++2RL+78fwtNAq5A0zM7TERiCJ16y0qNRyohZgzaQbcE/mhk/TUUh54BOn5QM4fonj0L54mp9VeKhsvgo17VOdWCjSskXPdUVJTpKX+XZroLdNtbF5DoHOjV3L6Lpiu40M7WBdHuvSiTlJet880/IGzSrPHGqpEE9/AVCVhHs+vzhemPbhxSe8dL2F4V3laJXmE7UeG6EsOi6sRUez9LTn2aevKWyIIty2l0fYNCiu0NjlSij2/LtFG6ShrX74XDAd0InsMK+ujaRgAxLLKs2lT7vbpr7VIp+SZHewGMc+xCqMxly9dKX6GkDMD4IBwbCAppo733Cm+R83umlecvDnWmNAuhwFW3GLifFP7F9zduM0nahsAM6F0oluQj/4P4iBwHLKqtmc/Opc4ydy5t0gn2kUroDzrbypSM4weE4qiQXfaPL7z2CkTWfenZIErgY9WWdY0N1Lh6/Ut8Dp0JYVzHvZuyYYAR3xxC/1LHT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren


On 2026/11/22 12:13, Suren Baghdasaryan wrote:
> On Sun, Nov 15, 2026 at 11:14 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> vmap_pages_range_batched() maps the range batch by batch. When a
>> batch fails, the batches before it are installed, and the failing
>> one may have installed some of its pages. mapped_end follows the
>> end of the last installed page, and the error path undoes
>> [addr, mapped_end), never past the point where the walk stopped.
>>
>> The KMSAN metadata is set up for the whole range up front, so it is
>> torn down as a whole when the mapping fails, like in
>> vmap_pages_range_noflush(). The only caller, vmap(), also calls
>> vunmap() on its error path; the double teardown only walks over PTEs
>> that are already cleared.
> 
> As I mentioned before I think this patch should be merged with patch 7.

Ack.

> 
>>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/vmalloc.c | 22 ++++++++++++++++------
>>  1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 28e65073624a..aa80bc273ec0 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3748,13 +3748,14 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>         const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
>>         unsigned int prev_shift = 0, batch_idx = 0, nr_mapped;
>>         unsigned long batch_start = addr, batch_end = addr;
>> +       unsigned long mapped_end = addr;
>>         int err;
>>
>>         err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
>>                                              PAGE_SHIFT, GFP_KERNEL);
>>
>>         if (err)
>> -               goto out;
>> +               return err;
>>
>>         for (unsigned int i = 0; i < nr_pages; ) {
>>                 unsigned int shift = PAGE_SHIFT +
>> @@ -3764,9 +3765,10 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>                         prev_shift = shift;
>>
>>                 if (shift != prev_shift) {
>> -                       err = vmap_pages_range_noflush_walk(batch_start, batch_end,
>> -                                       prot, pages + batch_idx, prev_shift,
>> -                                       &nr_mapped);
>> +                       err = vmap_pages_range_noflush_walk(batch_start,
>> +                                       batch_end, prot, pages + batch_idx,
>> +                                       prev_shift, &nr_mapped);
>> +                       mapped_end = batch_start + (nr_mapped * PAGE_SIZE);
>>                         if (err)
>>                                 goto out;
>>                         prev_shift = shift;
>> @@ -3786,13 +3788,21 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>         }
>>
>>         /* Remaining */
>> -       if (batch_start < end)
>> +       if (batch_start < end) {
>>                 err = vmap_pages_range_noflush_walk(batch_start, end, prot,
>>                                 pages + batch_idx, prev_shift, &nr_mapped);
>> +               mapped_end = batch_start + (nr_mapped * PAGE_SIZE);
>> +       }
>>
>>  out:
>> -       if (!err)
>> +       if (err) {
>> +               /* Undo the part the batches installed before they failed. */
>> +               if (mapped_end > addr)
>> +                       __vunmap_range_noflush(addr, mapped_end, true);
>> +               kmsan_vunmap_range_noflush(addr, end, true);
> 
> So, you are unmapping (addr, mapped_end) range but removing KMSAN
> metadata for the entire (addr, end) range. Is that intended?

Yes, that is intended. The metadata for the whole range is set up
before the mapping starts, kmsan_vmap_pages_range_noflush() at the top
of vmap_pages_range_batched() installs the shadow and origin pages for
the entire [addr, end) in one go. So on failure the metadata is fully
installed and has to go as a whole, while the page tables only reached
mapped_end and are undone up to there.

I know this looks somewhat awkward. The asymmetry comes from the metadata
having to be set up before the mapping starts, I don't see a way to avoid it.
Maybe add a comment explaining this?

WDYT?

Thanks
Best Regards
Hao

> 
>> +       } else {
>>                 flush_cache_vmap(addr, end);
>> +       }
>>         return err;
>>  }
>>
>> --
>> 2.25.1
>>

