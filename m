Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D03A1C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4DA76B0095; Wed, 16 Sep 2026 02:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF556B0096; Wed, 16 Sep 2026 02:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC966B0098; Wed, 16 Sep 2026 02:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1A96B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:00:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80A2414035B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:00:33 +0000 (UTC)
X-FDA: 85218575946.03.BB4F4F5
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2B44C1C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:00:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WWe5tKzi;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789538431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0aoWg+xjgpe3M/y6SHgXpjhXZxQmN/c+nIdH5D3a7E=;
	b=egIaWo6Ix9dsXdznQEownkD+C0GzthocylZ33Sv7nsjP5S45fQ/nWDuP4RO9nv4RtWvtGw
	NzPEUnAzmAgZbJvBteG0HOBNqswsmrpMJoBTwZhdbDEbKPUU9AlEiGD9ww3A/2I9SwDWfr
	CKS4/bhKPcvI3V9vMIXu0bgiqQ3twAU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WWe5tKzi;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789538431;
	b=Nxn4I4hMyYwbWexDTw+mz/3hXCEwCLulLIoEnnaWbApEBCd9jTKrLEG0sy8uT9iIwvIgJI
	ni6icafXiEMLzGkXrPo2sVL1XjbCG0+jq0tcRme8yCteNx1A5bPZgfYi3OOnX9fZYM0z89
	DtosaM/VhVaz1GEjHV7EEG1CIKW5Rn4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lkKO+hhwFT4C9KkIH3ogidkHvWCUt7zPEkugIUZmm7w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789538429; v=1; x=1790143229;
 b=WWe5tKzidE/ANoXtzoNd9naaXhFitJOIdOk3cYeKCHsIIph3vNCIHghDBS8omFgqK1fWPHTe
 QPPPrg/H5kpFXwAzVJ6dFviUcNabBlheCnGGmy54ATNufnHMzvCUHJTy5elNka9e98WO7vTD5vG
 QoHP53zUjN22FtmO9LTPUOk0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 39cd2895c6e16674;
	Wed, 16 Sep 2026 06:00:12 +0000
X-Mizu-Trace-ID: 39cd2895c6e16674
X-Migadu-Flow: FLOW_OUT
Message-ID: <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
Date: Wed, 16 Sep 2026 14:01:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
To: Suren Baghdasaryan <surenb@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B44C1C0005
X-Stat-Signature: js3r7yswyfrwr9o7j9aopj3r8kmzhrf7
X-Rspam-User: 
X-HE-Tag: 1789538430-600001
X-HE-Meta: U2FsdGVkX18Hl0ieYchK6X9WZ/tNMTiXKclQ78sW3ksmqzaxf8WNopYVrrKXuxitKM4i3GbPHTFfOLQDIrxlafVG0f3CLqkVFsUph59ia8593Qe5jVBQkowrVuvb/fOg0f9WwnR53YJBgEXAMVrBajsMvpHUeCIOWE9Kdhgi/w7tJvAw9KS/SHhiKhNWom87TmtXq5jdR8wVxqdNkS/szAMSqii/MHkzLX+UVYELx6kXmecgVLLPbKF63Im3vM8ZdNVZZi9KzYroTrHaBLjsDxM7nHRBhyZawIlyTngSBl3ha9WOyT6q6clnRF/RHRLNbO1EIYlP3KY7BXTqYPUj+xqsiA0MQkb6b4TPHwnz96YPgCz4m9+xXwNlUfXzNgUMNnr1pKByXsww/1naCiv4L0cCpBt8TrYUE1siyXR9l6ZHsycI91OY6VQHQBwJc8tSdWJKHnFpgB2ObpjWNao/8ak+wgpKTZT+CJ2PK9cp+NRIFbhVq11jdL2vd4Y3d9BCEAxwI7w6oVltHRGo8UGAYMQdNMK9qMQQLxGXOmGfJyf1lBr5MjfCHunswPX0799Me3RZMwfeJ0KLOfQiAt/b4beVyh9ylfrj75EXQk/IzFj0Pd4KY579G5vOkFW99tCf6nugE3OA9uglfiSKl3s+fCCb+0XvhAOEW/FrmRvzo0Spef5130ieDOPl+DcceYG5YwPZDpLNVh37OgNoYiTe/pZH5khpfBqsr3+2mO+lpLOqrNYxR73QbzUdUesZ5poEl7IyOHfhZwVnbANhFlEYWozX6RhmGEm47nJ6X/wURhU9Q7O+/wz9/1r7e2jjQ9zEhpvKvIcp4n6ioSTyu3jlgO/J0U9sFP5rx1e5Bs2DGUBKc47mlsP7YN3XkcIvCe67JZMsAuLq/7yiBAUIBu83zE5SvcVuFk/sWU2JXIggUGgiPRjZ6iWtOwyCaS1G7Mr7mDAYYpu8fLbWT9ysI2u
 GLC+Utql
 HP63TDeQqEO5jG9pCadt4NUKkMO6UYZGGUwZLbqM7ASG1HylVZnnCDr8hcizSWuZmlLYG3GxCceaPFEG6f8rh+5i8/ypS1gOB7HWG/Dj1nwN1q3ftmUNvFqqC/ogwYmcVDiNCLZLwi/xUVWpg8Ag6+fDbVh4U+Sq0Y/0GidOSh3jRjMehHuFebqeTT5jh5NLeL0X6FU9WwLlTSnGQwdPHvs/nRogrKyC2vGt7n2vf2gxVNeGzGpNI58gHVj7uQ/ROBkTI2bYixQCWwWkWaHI8FkWFSkrvMUvH+WfWoKpCEsNfj/yaHhdNN/i/6yWTu2tF/dPBEW/rUgmr6+GhlJPXKzt4Zxejlv7iCponQAmxNTqTX4yYwj2QjR+Od5eWaPJrQJlJ1Uj5PSfo+uRRNLmEEM7jfS27WxCkcVEgaFzUHOdTGp0Nb63XDqlghg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

Thanks for you review.

On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> The reservation is already stored in the maple tree when
>> vm_module_tags_populate() fails. A failed load never unloads the
>> module, so nothing releases the entry. Release it and roll
>> module_tags.size back. Without the rollback a concurrent load that
>> already passed needs_section_mem() can reuse the freed gap, skip
>> vm_module_tags_populate() and write to unmapped memory.
>>
>> vmap_pages_range() may have installed some PTEs before failing. A
>> retry to populate the same range would BUG on them, so undo them,
>> but only if vmap actually ran.
>>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> 
> If a patch fixes two other patches, it likely needs to be split so
> that each part fixes one patch only. But read on please. I'm not sure
> if one of the fixes is correct.
>

Kept them in one patch because they only make sense together.

After a failed populate the reservation is released and the
size rolled back, so the next load takes the same gap and calls
vm_module_tags_populate() again, and that retry would trip over
the PTEs the failed vmap left behind.

Without the rollback a load that already passed needs_section_mem()
just reuses the gap, skips populate and writes to unmapped memory.
So splitting them leaves each half broken.                                   

>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/alloc_tag.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 2070e682fe10..95ddf5b743d0 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
>>                                      next_page, PAGE_SHIFT) < 0) {
>>                         release_pages_arg arg = { .pages = next_page };
>>
>> +                       /*
>> +                        * vmap_pages_range() only runs once all pages were
>> +                        * allocated, and it may have installed some mappings
>> +                        * before failing. Undo them.
> 
> If vmap_pages_range() failed to map the range, why should we need to
> undo it? If it indeed leaves some partial mapping when failing then I
> would argue that vmap_pages_range() should be undoing these partial
> mappings itself before returning the error.
>
Yeah it does - none of the paths under vmap_pages_range() undo themselves on error.
pcpu_map_pages does perform cleanup on its own as well. There may be other similar sites.
https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
so I did the same here.

If we really want vmap_pages_range() to handle this cleanup internally, I believe that would
be a relatively large change, and we would need to consider many more cases. So I think we keep
the current behaviour for now.

Thanks
Best Regards
Hao

>> +                        */
>> +                       if (nr == more_pages)
>> +                               vunmap_range(phys_end, phys_end + (nr << PAGE_SHIFT));
>>                         /* Clean up and error out */
>>                         release_pages(arg, nr);
>>                         return -ENOMEM;
>> @@ -947,6 +954,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>>                 return ret;
>>
>>         if (module_tags.size < offset + size) {
>> +               unsigned long prev_size = module_tags.size;
>>                 int grow_res;
>>
>>                 module_tags.size = offset + size;
>> @@ -961,6 +969,8 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>>                         shutdown_mem_profiling(true);
>>                         pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
>>                                mod->name);
>> +                       release_module_tags(mod, false);
>> +                       module_tags.size = prev_size;
> 
> Yes, this one is a valid fix. It fixes 0f9b685626da commit.
> 
>>                         return ERR_PTR(grow_res);
>>                 }
>>         }
>> --
>> 2.25.1
>>

