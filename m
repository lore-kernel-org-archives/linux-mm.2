Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD074CDB471
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 11:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A979F6B0088; Wed, 24 Jun 2026 07:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47936B008A; Wed, 24 Jun 2026 07:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937146B008C; Wed, 24 Jun 2026 07:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 619436B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:51:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE3CBC183F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:51:01 +0000 (UTC)
X-FDA: 84914639922.10.7ADC00E
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0724314000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:50:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="r7/Cg2Tj";
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782301860;
	b=wXyOk//IeYgdn7IRP9v26MjiiGSSf6p6vmZAOAycKS1K5LY2bYUEUeoNKuAc6uBbELBMqW
	+stMMZe9pMbqw8Sk2lvQc+jrmAadYzsbgIGlTaLQzubBV7rW+ygC+ip8FOxlj6+qryetSQ
	Fj/K/J+uJZk9G4G6OOoCm1m+FxtVM3E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782301860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLYGI+jGGD5SSrEhLKeuITqC8EDy62Dm21Ns6LCR8Mk=;
	b=4axA6IodaiwVM9XtUF3MFajmWLH38JKzeTjbIJKpTz+npTCPJFYVHrI/0+Upe/KZsZhgb+
	vUIQytkRGQWAKkFo3Uds2V++pwuY13YV85hJc4h4K1XNRVyaMguVcL5gdA3OVHupK9nz8Q
	eQbUAhn5xztuHMbw5LJcR/A3ofkAVMA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="r7/Cg2Tj";
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84592b55832so594054b3a.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782301859; x=1782906659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLYGI+jGGD5SSrEhLKeuITqC8EDy62Dm21Ns6LCR8Mk=;
        b=r7/Cg2TjvmcHm5TuwZXkQKk3gXeEe5m5dchE56kM45sOeAMm3qOJEYvCsqOGv9SvHj
         ffMgw0ByAzHZRtOchO/w9jW3oJKcNlB4O+IZzJZJ3b0huCsoW0zwMz8xOWi+34/IiSzr
         9+Nixx0KE86cUcet6RwFBFpJPXWwq4gdNeiBgdqlzWQ0WNyXqoZROEi8lR2TW/GYH5Em
         z83YczbXMEoii1E9iuBjX9W/gjUjzTRN4oSp94X5jp2ay5mfKBzUETN60avKH2I1E+b+
         3wFaIU7ucqt8AzVMhW5JvTrgsBzPXQnGat0YhvlzWTSs7RJZ2OIjIcllXbvWgogbIycq
         ydgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782301859; x=1782906659;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XLYGI+jGGD5SSrEhLKeuITqC8EDy62Dm21Ns6LCR8Mk=;
        b=KQEIHPKUuQhfQSMDFQ16B1Fj/1Poa74gIP/1rRBR2HAbRcVPki2rH+YSdX2noZaw4M
         8yZ3wbRr9s5te6QiiHt8Up9CskXqTAl7q1O4g+PXdYbB32X2kcOxs6SZ0gYB862YabBl
         zTKC7RgQcuPrqItJvxACGXdNPnH3iIVsxcc11Nh2W+9j7k3TJLi8SATmVVm5ErxsC4g5
         L0mbwEOVJSYhlYhZuVR18BN4OaxLjxuc7HDpeaZaZmE+Iben2gppVdbP6OVjXC1t/nXH
         ASuEFosDkDGqFiCXQ8mU0f77QQABKswFVtb7V8ZLf4u4dT/18eqBgfTUFQcnMeU+i8Vi
         PTpA==
X-Gm-Message-State: AOJu0Ywxa/oUBFkccKnKya2msqGrsD//Twp/ChkXnbZLkHxkLmpBySSH
	DhUs4K4iLn0p29PCwS3bDXzk0HptzfpmkqgI051AoZs4iZIX0MdqOWcE
X-Gm-Gg: AfdE7cnbz+P0DxEky41PPyVW3e1UK06y4CC7UMhutzAlTmIPN5oVBWxZkJ+7WV4masi
	pKisZpIl3l7nXo/0aVdGCSFDKos5VzLv0VYwcRMXl9P+obKdDPqEJIghzEoaVh6tGZYq9zIRtgn
	GstIiNJh1i8eOaExrLEgR0MB68Na7GmTPcXF4OhGQPDEd5TWnSvVHXcynLQLd4geBZH9iWkif1u
	jj6X762QQvjo86MtmmnUooviG/QbbkLF3EOx6+VM33I47G2aymNofkqQw+1kQ2ZO9DQhCT2vwRu
	hYF1/GIKB9UXsOvuC9NSg68BPs9FT3IkxgCFlIOCP2QqHbdOkIhL1P/1O18xDdNQ25Xr+3G2a8+
	eTCRqnMoIGZbYXoQHpUX+TVdJAxpjCmi3arb4zB+iXGlP8+CJAlTO9ezg07H7RJp9RP3DZoG5jk
	izKEWZqk6PlLyt/YYXjTHkKQQezw==
X-Received: by 2002:a05:6a00:2305:b0:842:7f81:8079 with SMTP id d2e1a72fcca58-84595326988mr8140571b3a.37.1782301858737;
        Wed, 24 Jun 2026 04:50:58 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a413d2aasm2435598b3a.59.2026.06.24.04.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 04:50:56 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v4 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS via ARCH_MAX_PMD_ORDER
In-Reply-To: <CAMgjq7BNMYCBKDYH_O-mHsBdAeSq4Z_ve5oDB6rQTGioHo26GQ@mail.gmail.com>
Date: Wed, 24 Jun 2026 16:45:21 +0530
Message-ID: <pl1gw5o6.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com> <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com> <CAMgjq7BNMYCBKDYH_O-mHsBdAeSq4Z_ve5oDB6rQTGioHo26GQ@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mjdyus4icdg93xxd1t194jf5zoywzzkp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0724314000B
X-HE-Tag: 1782301859-767371
X-HE-Meta: U2FsdGVkX1/EFl09r5uuhbn1iIVkZzKo3CbdNDakD2o4AQY/+9a4k9QtS8+RoKrrUQMO7VSCiIoNoPjDjQFZEl0epWxuKCSSBn2Zi545j2xm2gkI2qDHYB3eGWE+hKYHolcsKb9rRQt5GYao5235xUDaY8mMBeRK5b+MwraK6NeaJOfh3icq1+QAz8QA9fCb5cNw/wK8tNkFPNeubdNtDC17j5lEOhOPKG6/C+1rVX/0REJ30CcotmvGrqxUFp9VuPkAETAt8KFmcNoMjQ/tets6Q7Pzq5uwrg5j4atWAcluVKadX4fE6zaT2b2BJgw7J8Ds7lIc2R0tHHwtXZMOoQi9ufw7fo70ic8sFvWJuW54FuZg7OI3I9NrLxiFnrVQoyiqsPw7VNVYMcu+ItbNe3UO6mSj6eAN4R19c95iXLpwHC7qnCVTszmskW+Z6XVl6mW4o0lSA1Sz7vlDkIoHQA24Yu5Ci0I97Y1ikDXqrs2OCAH/G2njW2HYAurWWotCMSbJamcHbpGYXr155RTitSqNvjHTEsJmBikeDXK50iyerWAeHkUvwt0TQGjvrXzlU4Vn9YBk5PJy6tMkk4Lei7BWnsvv/9uwooo17Vz8mL+dC17coaqV6GuV0y/qrQ/ywEHeJFfhF4SYhxHGxl5s6TNdJyJXarw/eFBhCffj2aZc3FGuQPgIRJBKITBZPjxBGZkR7LoEs4PTg+pocIIQk4707ZXZP6umhOoE+xVc1YJGipJnvUK+gFs52rQRRfT7p8GlM8ZPbfHDyDsfqb/L1HFV07cZvPm9gtlwbNpXOKES++N8uCIa4WGdQBcJtEmb9Ll9G5X22IEciAuZNjWjMV+KOVqzW+Q4xc6cmSXGxIOSyScs0AMmtGVNJuYibre47NLYZBpeCilngZBMiD6VeFeuxdsa3Pm0+vWKolO9WnKmagjQrh+pe8YS+lOuHDOK8P2MpHtA+tdEAZ1Z4Xf
 0URmnuFS
 AKiGJS8F4DuyiKPgYXqY8gvf6Yw2lcl5Qvpt3y1rcsMyXIdURXo4OApjteB6EOMCr0u+2asCGuJae2Fn4Jk+7qyvcO46KP0+f7NoSbF1hAv31tE4us4gdUANB1sJdVgQcao3WACdIe0CZZkXOG0H4ScjTAZLlyYugiel8sIvPAuhDtnJZDjHHQ942IbOVD+5VLKX/n3b1dgmeNkHpY/Ov8kaunlgTooGZtpGPvtMcScsvsUJUrrUaSihPsTyk/hU2Y0Vr4F9V+QbHe8r7r+5a/p7Q62Ng4Q4zEaH0clYPPQ3a1kLXGpa4j6OF/Na7TpYti3qzv+YnLnOOUO7s2rpVsrhwiBjlCzwkCG5n/H3OtG982fVmiZURzgrMSzjdTtDDuHF+KLdcF3O84v5cap5ZsDuJAgSx5TsFhcYFDZH92eHeJtE/lUm+CPzj451jx4ZMDc+yGJWDlVAROBJTtTrEVLGWPT55ZpkJeglA9O+RAX0L1ag+/h8zJ6zuwD3Z63tFNhty+UH233YOs/gTLJYRZM6nCBZQ5dZhtT3tfIGmFSaV2tr1zcYb9VhV3LG2y90x8gYN2BXgZee3Vxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> writes:

> On Fri, Jun 19, 2026 at 12:42 PM Ritesh Harjani (IBM)
> <ritesh.list@gmail.com> wrote:
>>
>> SWAP_NR_ORDERS sizes a few small bounded arrays inside THP swap
>> allocator code (nofull/frag cluster lists, percpu_swap_cluster's
>> si/offset arrays, next array for rotational device). This currently
>> expands to PMD_ORDER+1, which only works when PMD_ORDER is a compile
>> time constant.
>>
>> However on architecture like PowerPC Book3S64, PMD_ORDER is a runtime
>> variable which depends upon which MMU is selected (Radix / Hash), so in
>> that case, PMD_ORDER cannot be used to size the static arrays.
>>
>> This patch provides an optional ARCH_MAX_PMD_ORDER (upper-bound)
>> override for such architectures. The memory overhead on enabling this
>> override is negligible. Even if we make SWAP_NR_ORDERS runtime alloc,
>> default slab padding could cause some memory waste. Also we lose the
>> per-cpu cacheline benefits (for percpu_swap_cluster) because it might
>> cost an extra cacheline indirection overhead in swap_alloc_fast() for
>> fetching si[order]/offset[order]. Note that a fully runtime
>> SWAP_NR_ORDERS was considered in previous version but was dropped for
>> this reason [1]
>>
>> [1]: https://lore.kernel.org/linuxppc-dev/pl1zdksc.ritesh.list@gmail.com/
>>
>> Suggested-by: YoungJun Park <youngjun.park@lge.com>
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>>  arch/powerpc/include/asm/book3s/64/pgtable.h |  7 +++++++
>>  include/linux/swap.h                         | 12 +++++++++++-
>>  2 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> index e67e64ac6e8c..7f22d5d5fbdf 100644
>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> @@ -204,6 +204,13 @@ extern unsigned long __pmd_frag_size_shift;
>>  #define MAX_PTRS_PER_PGD       (1 << (H_PGD_INDEX_SIZE > RADIX_PGD_INDEX_SIZE ? \
>>                                        H_PGD_INDEX_SIZE : RADIX_PGD_INDEX_SIZE))
>>
>> +/*
>> + * Compile-time upper bound on PMD_ORDER across hash and radix MMUs.
>> + * Used by THP SWAP code. Check include/linux/swap.h
>> + */
>> +#define ARCH_MAX_PMD_ORDER ((H_PTE_INDEX_SIZE > RADIX_PTE_INDEX_SIZE) ? \
>> +                               H_PTE_INDEX_SIZE : RADIX_PTE_INDEX_SIZE)
>
> Hi Ritesh
>
> So swap is the only user of this macro? Will there by any other users?
>

No other users so far other than swap.

> I see that due to the percpu cluster design, it's hard to use a
> flexible array here. We will probabaly get rid of the fixed percpu
> cluster design in the future. By then should we be able to get rid of
> this macro?
>

Earlier in RFC version [1] it was runtime though, but as stated in the
commit msg, it adds unncessary complexity and yes, the per-cpu usage
there, made me re-think this whole thing (as Youngjun also suggested).
Since the allocation of si/offset of percpu_swap_cluster in fastpath
means, we also loose on the cacheline benefits that it otherwise had.

[1]: https://lore.kernel.org/linux-mm/19688ab5ab8017467749e003cf630c76a4b2b198.1781000840.git.ritesh.list@gmail.com/

Sure - I am not well aware of the plans on how to avoid the fixed
per-cpu cluster design here. Maybe if you can share some details, that
will be helpful.

But essentially yes, per-cpu swap cluster was the major reason why we
looked at adding ARCH_MAX_PMD_ORDER for PowerPC. Also note that this
does not cost any additional memory overhead compared to the runtime
solution, since kmalloc allocations of these structures were anyway
adding some bit of padding.


> I'm OK with this approach though. This current design has no negative
> effect on other archs so no reason to block it,

Sure. Thanks!

> just wondering if this can be made simpler in the future :)

Well it's relative. I felt this is a simpler design compared to the RFC
version we had earlier [1]. But still - can you share some additional
details of your concerns please.

Having said that - sure if in future we get rid of the fixed percpu
design, then I am happy to revisit this to see if this macro can be
killed - by maybe adopting to runtime allocations.

Thanks for looking into this!

-ritesh


