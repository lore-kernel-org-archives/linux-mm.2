Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A95F1C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78B66B0088; Fri,  4 Sep 2026 08:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A4B6B008C; Fri,  4 Sep 2026 08:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919316B0092; Fri,  4 Sep 2026 08:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60E9D6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:16:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05C64161344
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:16:37 +0000 (UTC)
X-FDA: 85175978034.03.C104338
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 03A9940007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:16:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AUpYKjNp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788524195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmyMOpfaX4h3t7GBum5n74Kd1I2b9Qp+ODDo5tAvT2c=;
	b=1/l2lpg9klHXZ7LXaflILlP/Llg6ZaCv+Zin4SCkbtJHn5sRe9C1bTOBoG8IrQXZmoXPaw
	FXzZqo4djONlt1wUjeS0s56QSMsH/RpJgxm9EFGSV3O1u1iDMTHYBJQc+oBgdfsKq2lUPd
	u4dNbQW/vLps+8rT0Z59Ln8npZUTIkw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AUpYKjNp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788524195;
	b=YlVP9tLJajVXos+2t3uM2S+aGq+WHXbRZ5heScElVEwrMYmB5kCY51r5/z0Di1mNvywvj6
	i7Pe+0vyNmrwFxY1jBQ1vEtuojgH+AAd8gUvbUnasl302d89/B7xLrohhfVZCucDxJ2Gn1
	aoHNyiCQJ3cnd3+1r2uQ3D8E67kNr4A=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a623987d32so1341283a12.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 05:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524193; x=1789128993; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bmyMOpfaX4h3t7GBum5n74Kd1I2b9Qp+ODDo5tAvT2c=;
        b=AUpYKjNpk9RbIxErHOH9cHGxbnaaWANhTnwzIlLqtgBwKl1aHYc+vr86gxhFhZccIN
         tkhAd5AvxFPGSJG8F47ZsWpCNtuqK44GO49dv5riNUD/ATcYMGAycmNJ+RhMNIWyOZyD
         TnSQE7HnBEzUihskO4ZNNAtfhMGDqwJodB8c+Ow21XpVp3AYCDlHd42tRk+h38DAxG+y
         SZU7U9fMOPaiuWoOkuBCiNkNzT1iQgMzt/CVGsfzKrlbITAVuO11rLA0M31FY/DDTtEt
         Fa8GggMhm/q1Or3SwbiAIZnbB4jX3ePwtOwSXthcUqOOkH76eKbKqtAtbNBWRYnwp0bU
         nUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524193; x=1789128993;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bmyMOpfaX4h3t7GBum5n74Kd1I2b9Qp+ODDo5tAvT2c=;
        b=WBn448mfnaDKx1MBFqov2SaUmeNb6RFbbYeJtPLx0q+WUSqaQXbjRLHcyAiGmyvmZN
         eK7r7KqqIG2+Tpl+RI0wX/ZPpxqQysjan+tBVrOyda43tieevRLRVGeMxjf+LkuLU6sC
         3hwGZTLDAKsSKEUEXHePc1Mbo+MIL4DrgWRvoMAnWeodns3EANTnEK5BqmtF77E7QdCp
         VVYZEXhckOmOtK+hifYYi2wPe1v+QkosBkPln+jkjZe8vnGsywvqBi0c7Xj157AJOG1l
         OxykdPZIfnm7pZ2hj8fzqCaDqqJ4eQoQxE6NTVx5q5TWjhfau/P79WSjJQ9xJAaIPUl8
         fUPA==
X-Forwarded-Encrypted: i=1; AKwUvBytj0+AoEYs0e7TetIJaVPY+UUbq8OdpbMkNKluwDxbzPRcj0p+e48Z/LlQT6ZDi7LoUYfm+vBVfw==@kvack.org
X-Gm-Message-State: AFuF++luQlRnNkw8k1mO2c0ImfcHS8hOD/R2fBdAIRyVVc02T2gmhWEx
	XqIrRN1hlfiAwPsyJwsRjeepFUsK6IApzqyKfeZzyFrFswnto8XBZU2E
X-Gm-Gg: AYBFou0d5w3/U63Z5Yw2R8H0LYmCmUxpNpBukkvQRy5ZVB8eWc5QTFJmVgfY6yUyyhA
	M6rnUhClM0GsfetJu/tU99ukpdNKSmMKqGh1+RD5dpZJWflD2nXn8O9maSeRy2iDFQsTFz8JZXe
	bqBKS3L2IEaRWxFphZ+94/k25C+IAUPkcAeFazvBR21AbVFfD58urfWM+xfC8NjQ+7fMPwLvkIJ
	2YFQKL/2hGOKAc7SVAghncg57TF8pjgfDMYLiO8tz+Bwny1wx3BrPekXqWX8BfgHdZYeJ8kuuYH
	Acpr5oeUsKRjvPf5GiqKL9z2SG2Z5OmZoJfetrByTu9wMbnxWU+GC8qq/T44h4LE30Q4lE/ZnlS
	UV3nuVeSu0sqLefAIhvNmesZ0F5XxeHqZXOx77xRu36SFPaUItwraZowksJXUKHu+/ZNBsMQ8Fz
	kiulaQjXFi2OabYzGW1J/E1jWWuSaoo41vMrrOznORG2RHqYOoQkmmYkXGPCbP9FSdVB0wZQbvg
	FExA6MhxnztkZ4TgUx0QlEcxZzkwm3ZrKbfzNN8hbz05rN1KxsM4hKeoyVa9/Nozp/mx2fa5/xp
	97VQMfytU4mVvG1ScCpqoQ8xlDlatFF4NYHJ6IP6z8aEzOETQIs0c3mtc4AtumR4Z/1oeTIhtIJ
	670hs/402sOKGC+M1ltxLhU2APtT0k2oohorX4uIG6l06mA==
X-Received: by 2002:a05:6402:4592:b0:6a6:35ca:af8f with SMTP id 4fb4d7f45d1cf-6a7e8e92b23mr2244160a12.16.1788524193458;
        Fri, 04 Sep 2026 05:16:33 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6bf337bsm1063392a12.26.2026.09.04.05.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 05:16:32 -0700 (PDT)
Message-ID: <493efefa-308b-4d3d-a6e9-841a3b118283@gmail.com>
Date: Fri, 4 Sep 2026 14:16:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xarray: fix index jumping backwards in xas_find()
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, syzbot <syzbot@kernel.org>,
 syzkaller-bugs@googlegroups.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
 <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>
 <app_o87YogZExbwm@kernel.org>
 <CAGJbn0f+s3U0G=1yUx7a10-buHgA_yu0REG01M8hgFo=t+3Y1g@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAGJbn0f+s3U0G=1yUx7a10-buHgA_yu0REG01M8hgFo=t+3Y1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5i45rejoeqquja8snpghd6yqqbnuyj4w
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03A9940007
X-Rspam-User: 
X-HE-Tag: 1788524194-380435
X-HE-Meta: U2FsdGVkX1+wFutKLmNgmlsjZf85HonBljsmECkxx463kBdWXilLv/vlaFNqpcdi85Hi6abbip6t+9mT7NeWd2JAIVkoYs1HV+hqvk17Fz/IO8z7RE9FRvaD6LvmNGAq6Zkea+B+iZDXwv3YO0FigoaVpAvrRK/B95NcumHcaHctNO7D9TzpUA6jOI0CZ4TIf3djLOi+Ja/oz6AIzGS/ssKlUcjPCDdmaeWO5c7BIuYW8yr7y9vcvSRs3bukkHmQ9fTSrfy7s+tv6Em4uPlwcEN9s8Kxes3h9gWhLL0z+Q7ILQRgKvUjDR3MgSK20Zc4LAGElmcRNoVfyUuKoVBRQhOlOyr2BCoGY00bUoF6OtxUweqdg4GBQuXcKw4mRfsx127F8n6Refepc3SDeBvPgtuDPsJTQRf+mW+I5CyxFupUSgIEiXSGT6L+qQVl8/+/wnMa6tIrOlK7cmsxMfPyOpn7vXUT1D94TdabHeSGXpOKiMUTzqPiSVbLWVNmAEs6KY5A7kVxxB/8S/x838Qxp9QqM4RiUwcFxu8K9UqCCv4bDYwXHrKJm9WFs53UlkqGhDFgEXI+yOVz2r6itsezTBEouueMuwBzyZO7ZiJCQmwDJEtEI/ath/ikOtU6m61Eo3u3wtQOB8G22oVXcGigH3/vSP9sI7yJN9+icg+0r5Ty3r95lZw0tK//qhAlh4BEfZ4miAze0ZMLw1i7qISZFUN7SgmvktQrTfbHsKH0lAhmM8VpLrflBiCc3dU62x3sOlSD6BElmi2zIjBvvjEjCBVN88iQVDlMHi8gWCiJtjbVTNyHVbY+FZy2Z9k7S9R3QDTI1QzoOkpekWbpUEGXrPxUEzZQfkeqWWeAZtO9D0cmYjQifVzMOUIdqxk5SWMTWO7tyXW2eZCp1VY4N01oQc9+IQ94oPUxCR8MWeMFuXSC7a18vvh5JnSVn9EcVmMne68vv9URmOmrxa9h/tG
 4+72W9cH
 hbRhqAdT4ehn8lASKFISqx8SZwaOzZBbyEQ7OeMJQEtehUQqfudXOPJnlSb4Xdt1gY5HGi1boC3xccFbJfQp3HDOjOWghB9nMOpliVsqTrt9LlzZYlRyV+fuFlWPZOQn/NoenuR8c71TVB15EVQOwQJ0xKnogfYLD1d3VHcE9f5mKDME3dbXMugmOrg4za7vCTm6u8BA/TdPexF9s5WqC4AbfHJ3s4fnI4oDO0eOj01CFDtx5sElaBJMkc41prLT5e1E0OCAlHSwr0zh8qum2rNH06gYgZAwvrV9WNNEXr5Uj7AEbIyvIUrPtixJs+Ks0zb+O00ef2/8RU6CaLsePsP9DE5Wbjp/N5Sh/mxGTV6tyivJ+VagXFqr/uZD/RJb18hrIDuO63Ljpjee2UYzZf8trfCTWZVM+wRdLB+PJFmH+0tEj1c6hnHC5irLlSry51FFFlryDOeoL8hbukqOPMOM/PzOKBvK9jRZqfQYUgqZo+QhD0mP9ULlDMeCbcuKeuLiPGhou7FHqJgfZNw6fgSysziWDluZQGSXPCf2hT6tLQlCymQ5VqGOTFLgpc4A3HIP6DwMcmaIpHlNdTEjS8+AoIgyVLB32aERH6IOgxYUD9hel9HeAqS9KTcpzdjgr8hBnipZre/xpOw4sOCx3tvCfSQDExLimx+Is
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have fixed the test issue and submitted patch as v2. I'm sorry about 
issue v1 caused, hopefully v2 is going to be fully correct now.

On 9/4/2026 10:41 AM, Krystian Kaniewski wrote:
> Hello,
>
> Thanks for running tests on my patch. I've quickly looked into the test
> result and the problem seems to be related to check_multi_find_4() test and
> not the fix itself. I'll send a v2 patch once I get the test fixed.
>
> pt., 4 wrz 2026 o 10:22 Mike Rapoport <rppt@kernel.org> napisał(a):
>
>> On Thu, Sep 03, 2026 at 11:22:51AM -0700, Andrew Morton wrote:
>>> On Thu,  3 Sep 2026 13:48:55 +0000 (UTC) "syzbot" <syzbot@kernel.org>
>> wrote:
>>>> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
>>>>
>>>> A bug in the XArray iterator xas_find() causes the iterator's index
>>>> (xas->xa_index) to jump backwards when iterating over a multi-index
>> entry
>>>> (like a THP) that resides in a non-leaf node and is concurrently split.
>>>>
>>>> When iterating over a multi-index entry in a non-leaf node, xas_load()
>> sets
>>>> xas->xa_offset to the base offset of the entry, but leaves
>> xas->xa_index at
>>>> the requested index. When the caller subsequently wants to advance to
>> the
>>>> next entry, xas_find() is called. xas_find() attempts to synchronize
>>>> xas->xa_offset with xas->xa_index before advancing. However, the fixup
>>>> logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
>>>> Because the THP resides in a non-leaf node, the fixup is skipped.
>>>>
>>>> As a result, xas_find() simply increments xas->xa_offset and
>> recalculates
>>>> xas->xa_index based on this new offset. This causes xas->xa_index to
>> jump
>>>> backwards. If the THP was concurrently split, the entry at the new
>> offset
>>>> is a node pointer, so xas_find() descends into it and returns the
>> folio at
>>>> the backwards index. The caller (filemap_map_pages()) then calculates
>> the
>>>> PTE pointer based on this backwards index, resulting in an invalid
>> memory
>>>> access such as an out-of-bounds read or use-after-free on a page-table
>> page
>>>> freed via tlb_remove_table_rcu().
>>>>
>>>> To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
>>>> xas->xa_node). If it does not and the node is a non-leaf node, set
>>>> xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before
>> advancing.
>>>> Also add test cases in test_xarray to verify xas_find() behavior when
>>>> iterating over and splitting multi-index entries.
>>> Thanks.  But the changelog omits vital information: a description of
>>> the userspace-visible runtime effects of the bug.
>>>
>>>> Fixes: b803b42823d0 ("xarray: Add XArray iterators")
>>>> Assisted-by: Gemini:gemini-3.7-flash syzbot
>>>> Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
>>> I see from there that it was a use-after-free, detected by KASAN.  I'll
>>> update the changelog and I'll add cc:stable.
>>>
>>> I'll queue the patch for testing while awaiting review input.
>> The testing shows there are issues with this patch:
>>
>>
>> https://github.com/linux-mm/linux-mm/actions/runs/33815757662/job/100847425973
>>
>> And since it's in mm-unstable now it breaks all CI jobs :(
>>
>>>> Link:
>> https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
>>>
>> --
>> Sincerely yours,
>> Mike.
>>

