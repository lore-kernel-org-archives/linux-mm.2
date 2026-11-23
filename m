Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F8F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HzEYkNQa
Received: by kanga.kvack.org (Postfix)
	id 03F786B05B7; Mon, 23 Nov 2026 04:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F323E6B05BA; Mon, 23 Nov 2026 04:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EE16B05BC; Mon, 23 Nov 2026 04:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B38B76B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:47:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4ECC880416
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:47:29 +0000 (UTC)
X-FDA: 85465906218.04.B7C0D93
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 513708000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:47:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HzEYkNQa;
	spf=pass (imf30.hostedemail.com: domain of abarnas@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795427247;
	b=L4ESdzeQz8T+crOcr44ln5E74aBTxzXxLRQZqK/0XiJwoowa1dOAzAS99Z0omMiNZ9Nknu
	h+XDw6me42TWVIs1nbLUgEosR+LsQmwROBfU1TUZ1pTvIsHfUTuyfBvExxiAWKW1Y1RbUa
	9VflFumoqepk1Gym2A7GLK6+3vmytBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795427247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cbec6c+ppo8fwshTZKR1fXrJKjbe5WIyXh3pcA7EKE=;
	b=HYWWyc+1NS3rwSYebSgvtxHgvpe9QEPeMPaDb1+2kAvktrnW2HQ1rFBiwafsfQ+O9bv9/j
	OzwGMdbEwN9qnwdGRfW4WTLAhYJhAg7xj2Hg7gPyRVi3gDDLq2eXmsyyiD6yukE2pNqpPz
	3roJojauBjVsN6Cgk6G6BXBxomwdwBY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HzEYkNQa;
	spf=pass (imf30.hostedemail.com: domain of abarnas@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so38132105e9.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795427246; x=1796032046; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4cbec6c+ppo8fwshTZKR1fXrJKjbe5WIyXh3pcA7EKE=;
        b=HzEYkNQaVI4e+8lgOfZr4WvoCEHLDK08d6Z09V4ccdb6alTwaYiFw16Ro01FcSf8xY
         RACX7XT0/Mr8PmOZDottj4lcTqlyFzfkAuj/KpwtFo53Tzcv4z4GnMgf248mAjHSTudR
         OPE1W7INFoHOvN5rrBtCM5FAbulmN7ve34rZNsTQwIbIO0l+qd/TD18AZ2NdW4o3Ix1u
         /vrwlmO9JSiwrmP5amkDCetvc+f7hok4dP5NHJjaUngH7TLfp8HdKgHf2RMyJloQ0pyz
         zT8bNzKyO8JxIggX/C/fbHnyiOIMVvxTxrTMmbOZ59dr+9JJthUjxC8UGP3CO3eS0AGu
         Vucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795427246; x=1796032046;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4cbec6c+ppo8fwshTZKR1fXrJKjbe5WIyXh3pcA7EKE=;
        b=WYbMScXbCNmzIEvSOON9k6JxUA57W35c6KvO80QmpSRSpEV34o2nyMJhOd1sMsUfd2
         WHxTU2bpm25zA63OlGwfhouHvuB8MXShOCkVh4NtBAV+fE+6kby82dHPTvi7bEGc4lga
         B45A9PLW6NSrUUgZkDoVuX8xxzN4jg3EwGY+ipgeaVhQwXXvAy+OiQWFndCe4fUMw0PG
         xxP4KkXfNVmONaeHIDU6steFtqNNZXLKWY4PzDpQNwNJN+m7fo3xEvErTWkb4MawzHQ/
         Q8fmZ1g6EBiztSFJ70Ezt9oO1PnCktGHX2qTyn2UM85I2Gae95IanXkY8Rd76+H1dKqD
         j2Qw==
X-Forwarded-Encrypted: i=1; AL+hErEr7EzxTakirOsUv7oHo4m1h43Rumduh7vCzEI+qcqmw71XA0cJUHSn+uB/xBN35/5kh0SeebBvEA==@kvack.org
X-Gm-Message-State: APuU4Z/FlLJdVjBRAl0Z4tW3LZgFpcWCFl2k3roI2R85DPOBlezG1MN0
	lFO1kUHVtGZBhnPhvjyQw+wwv4+Goy/Ec/G0oyDRLt2ffQylY3/5CyGxYRlgYlkAUA==
X-Gm-Gg: AZFdTZeeTWFMt8imud/QcOdG5NhZzCMuhpX+VqSD6BYspDM8rzrwl6himZ+2xsVbOKi
	LTzwNyGiP7T35Zv5EBJ0S1cEskAPu7AjML7F7tQMn1j+wUq8IStLD7D+Z+488LKwYKQbuaM3Eni
	wwEKFCHvs6/s9mTkihghsoDsldsL2KO0oe+tGIhKT/bd1N/CcuBEpN/FPKccG+tTigsO4Gzm67w
	44U57v3GcRpikQnJ4tbcgv9x+RN6VoulXIwndSI5R6D9OfVQMr5i0T52XaOVaG9Ol5I9Mqw8Viv
	tqwrymk0aKvTdfAt1n+4IaTkC6nAFIZIrGryTNsoUAS+N6Ou5e3mu3oaoSJhNE+M5HZKuZkMFBj
	8JrWfjYpDja/OWapurkD/7pAj0Ke4z6fcr80IgtRSNUXjJSdP/5gSHllR+nNBZl9YuO2TPsjBLy
	8yGKxlG4GQzJNTqdAjKn9tOPLQPGCzTCwPTedNT1rDgatXPfWQxVTMVfcwxpoJtPqP1e8Mqpn4l
	g1kdaIgPjOiBkDPAkLheBneZIC7H/hB8Gjd1RNPfYu+1kktiZ0u81jOXZXPsfdTnAtEEiUNcIaA
	CVfJBhzMQQAbnJS/9yJwBSVRZ/PH26BayK402wb00s/yKt9CVwyjroezMcA=
X-Received: by 2002:a05:600c:4f81:b0:4bb:5e8c:13bc with SMTP id 5b1f17b1804b1-4bb88805902mr213726495e9.7.1795427245214;
        Mon, 23 Nov 2026 01:47:25 -0800 (PST)
Received: from google.com (30.0.77.34.bc.googleusercontent.com. [34.77.0.30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884ab091sm483566095e9.11.2026.11.23.01.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 01:47:24 -0800 (PST)
Date: Mon, 23 Nov 2026 09:47:21 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [RFC PATCH 6/6] arm64: mm: support PMD page coalescing in the
 linear map
Message-ID: <awQLqYbrrgwUycxP@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-7-abarnas@google.com>
 <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
 <akuieSDlbYdHnkCV@google.com>
 <aku8zidRtXPe_Rle@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aku8zidRtXPe_Rle@kernel.org>
X-Rspam-User:
X-Rspamd-Queue-Id: 513708000B
X-Stat-Signature: opy9u3br8djxa4snognheemdcqwpk79w
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795427247-392762
X-HE-Meta: U2FsdGVkX1/pvwL/MbpAMkO81Kyqqml1yTprpd9r/DRDrSn10Qv7eeJJft+R2gHZ6yK5zWSapPj7/fcheLrFIhDHDJMeKEnRGEZwzOgNpyNR17XkjIYI7nYRKOyNfRYawxLy0zfTrBP3gF1OPy/lSZUgQpGg72YQVVEexRZH0SX/hYkMwP0vUPVWL9UNcARMppfkopQMECCy9y2rDze4CnqJKwnUGCjEc09q06VGKW7UQv6nSU8GWjczYOUPyCI+Ew3gTnNrdt8Ni6zWA6AfmHyagQ4AKMPmqtehqs844fzOeLUupqxSdQoisQI02Oug14tOeNVLeoOHfV3J6rK+Z5V5ax/EStuUQhN7xpT1IUoqXG9dDqAaLu+HZNvsLR9fCvqkPgnfm9xqYEIr7Z8NzEPiW98r8uwU1soVBUgn5vU7fUCT1dfoOM7wUx93azikodOjNiujLOv0BscLC7tqoX1QT/R0dgv02L3l27vMDOQk3h/tW5ErovttXUzkp9YAecNPFy7sKl4qikvgdCq65wAzLQAfiZnKo4P4XvOHznmVRFa3p4WBm96wLUv5aU8cXlZdS1epPnezpN9Ce0589Y1qdCsjOMJI+T7P1mjW+8PpZfUSEgDjjY+OXFo2PfFx7AdJdumCTSh5vURKVWsvVmdO5Hra4K4c4sz88RPgKnS6BwQXqqqZd+YbHJ0ss2irr1kKFE6aCVip/+Sz+RB9W9Je1CqOYwjS919LkxHxp0zTwN2xxBOGx629WsEMM6xGFPe528BKzIJ+z6YOwWJARd7C6z2CcfHnT3dj8Y17CfZfSq52sKKwwxlYqRwv8u8mgLvIyza4KLE6GlbwweJrCI7ubZ56BXidQ+I8m8p9juulACAkjWok2NnwGFM6iZpYcEUmQ4v+Oxpc+7wvno293QREK0jsGplrBNPNkyfw9Me4fpLd3vvttcqX9+sqHJc7h1KzStufmIWXtAzfn2p
 movnDQ/T
 OYcwk2pArpdA1i9KN/28aGPhJl1YcobETgkW1C+7NcabgpiKsa5Q7qHKawcegK/IPq4RKvrUsQubMe4hWU4Llp0rV9/5WhxWOCm836L+2baAIEM4B2I92DdWsGNW3+B5G492VfUvOp5d8QVWMPKJ8njGgO7tzdCaOl5Vd4H1PJAwZgtlLGDYpLE8AxNrskz3gkNRISjMQ6gqtXvxZHmodxu3LCrqttweP6pC3Qz28Tgep3UajFMDugeDSUQUByJUsKWoyrj5+FEfp//yig7Tk55gZiTKNynkRtIceR/ryI89YqO5pItsBykudQQG6rIsDIR2ek7abgrqTwB0ksVrkgBnQaT7xIJXGiU69HrWs3/1WAJ9yd8N1iDF+g5lj5H3HWe26y1NgI5+w8fpNkVdKrLrVBvwoZFrEWE+QwJ/Nsh74pi0M0tZQRwsleMQNNu1yEZBVNbbek6pn/ACVI5Pd2uPOUWy7umvVJSLgSYgdNdhYQK/T1UbsTeSMZPBbDScG0d5awAR1lzQ6iIITG47C8qJwzffDNaSc6/EMxB0GgipR62zrNYcplbUYEllTEf3uqR53+MYEJKmRMmxZ6XQ0kRwqmqU+aaql/6qwdUYTS16iCcFaLKyq/YN2uDsg3UkegqdU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Jul 06, 2026 at 05:33:50PM +0300, Mike Rapoport wrote:
>On Mon, Jul 06, 2026 at 12:41:29PM +0000, Adrian Barnaś wrote:
>> Hi Mike,
>>
>> On Fri, Jun 19, 2026 at 02:40:40PM +0100, Ryan Roberts wrote:
>>
>> > I don't think this is safe in general. Let's say we have a 2M region split into
>> > 512 x 4K PTEs. It's possible that the first 1M is one object and the second 1M
>> > is another object. Different CPUs could set_memory_*() on those 2 objects
>> > concurrently. If one of them then calls this function, we could end up
>> > collapsing the whole 2M while the other is trying to modify the PTEs and they
>> > will race.
>> >
>> > Note that splitting _is_ safe (and protected by this lock) because you'd have 2
>> > objects backed by the same PMD, so they would both have to split before
>> > modifying the PTEs.
>> >
>> > I think you'd need to ensure mutual exclusion at a higher level if doing this;
>> > probably execmem is the place that can ensure that no objects within a 2M region
>> > are racily trying to modify their permissions?
>> >
>> > Thanks,
>> > Ryan
>>
>> I wonder what do you think about enforcing mutual exclusion for permission
>> changes to the ROX_CACHE block as Ryan sugest?
>>
>> Would it be appropriate to add locks (over `&execmem_cache.mutex`) to
>> `execmem_force_rw` and `execmem_restore_rox`?
>>                                                                             I
>> see that x86 has a lock that wraps entire process of updating attributes
>> (including spliting and collapsing pages):
>> ```
>> spin_lock(&cpa_lock);
>> ret = __change_page_attr(cpa, primary);
>> spin_unlock(&cpa_lock);                                            ```
>> As I understand it makes it safe already.
>> However, on ARM64 there is a split lock (which works fine for spliting) but
>> for collapsing at least on my implementation it is not sufficient as
>> Ryan pointed out.
>
>I think the lock should be at set_memory level so that set_memory callers
>shouldn't care about the differences in arch implementations.
>
>I also suspect that the lockless page table walk in update_range_prot()
>isn't safe today.
>
>> Best regards
>> Adrian
>
>-- 
>Sincerely yours,
>Mike.

Hi Mike

I have recently got back to the topic, and I have one thing to clarify.

Currently the collapsing mechanism that is backing execmem cache, 
following execmem_restore_rox() description

```
   * Restores read-only-execute permissions on a range [@ptr, @ptr + @size)
   * after it was temporarily remapped as writable. Relies on architecture
   * implementation of set_memory_rox() to restore mapping using large pages.

```
is driven entirely by the architecture code. It has drawbacks, that could 
be addresed by passing some of the responsibility to memory owner,
execmem rox cache in this case.

Arch code at no point is aware if the piece of memory it makes RW/RO, 
is ment to be collapsed. Every permission change can cause entire block
to be collapsable so we need to try collapse on every run. We can probably
make RCU-like mechanism to batch those events but still there is a lot
of pointless runs just to find out we can't collapse or collapse of memory
block that already have split operation waiting for lock release.

I was wondering if it would be acceptable to create a try_collapse operation
in set_memory api that would tell the arch code "I will probably not touch
this anymore for a while, you can collapse if you want". And call it 
after predifined delay from last execmem_cache_restore_rox call.

 From execmem side it can be based on the same delayed work mechanism that 
execmem_cache_free is using. 

I have a PoC locally but it is mostly vibecoded and I have already 
discovered some bugs in it. But conceptualy it worked. After a batch load
of modules it collapsed all execmem cache blocks in both direct map and 
vmalloc in a single run. 

Before I craft a proper patch set I want to ask if it is in any way
acceptable approach? 

Best regards
Adrian

