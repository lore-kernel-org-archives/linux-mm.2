Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CFCCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885238E0012; Wed,  1 Oct 2025 04:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DF48E0002; Wed,  1 Oct 2025 04:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772B88E0012; Wed,  1 Oct 2025 04:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65E3B8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:32:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F05D13BE90
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:32:12 +0000 (UTC)
X-FDA: 83948878104.28.FD47220
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D372016000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:32:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XLn2ujEL;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759307530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3+EPaDu3mTLXOJJXfkxKlMbmHF7t6CqJIFRWvGx0uE=;
	b=oGpshc0zgy+FplRptu0v4FXEiQyZpKmQGikX/NoPj6WVUH61B0YV8exJTBcVMjCLZUFiJX
	P5oyGuD6ybQRA60b6laSqCuScEROfnSgaCy1wfsoob8LKIoFZ4V9Vew9cKBOW7/NpY0ixm
	GlBhaaI0lkadoTDQ0ql7WIbSw3ruvjw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XLn2ujEL;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759307530; a=rsa-sha256;
	cv=none;
	b=E3j43MB5C5RBVaLUM6MxPCxbUEXterL7f9I7Pbe55j1jnTgvBPrJal8FU28b51rVTqt758
	7oDqtokgzJroQOhfqRLpUYJP3bwnlxuLTca9DgCQX0sQLYPT4hKrI8nobntdsRQ267KOFr
	GaB1F8LrRobVYbg1rJ+r42rknoKUMQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759307529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x3+EPaDu3mTLXOJJXfkxKlMbmHF7t6CqJIFRWvGx0uE=;
	b=XLn2ujELf8zSxZ9VGMIGV0SKci7surMijRCZzIgYgcJcuWYeT6Sp1qnDZDf67ff69F3gig
	r7Qm6eOJjqY49yiKN90Rtw+RGvpf9bhKmOU8rcRwB47fbO2slYuLGrBOWYEwj+wytXC5XB
	VH6IsKgXj/rA0fE9XL77jPw+PNV46qg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-9E9jyrtNM0WDdwWvZHntLA-1; Wed, 01 Oct 2025 04:32:06 -0400
X-MC-Unique: 9E9jyrtNM0WDdwWvZHntLA-1
X-Mimecast-MFC-AGG-ID: 9E9jyrtNM0WDdwWvZHntLA_1759307526
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f42b54d159so5904234f8f.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307526; x=1759912326;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x3+EPaDu3mTLXOJJXfkxKlMbmHF7t6CqJIFRWvGx0uE=;
        b=KNUkTG1d9ZW+AmAGU4NdU9kPde/Zd+mZHEdWL+tj7wquAw1J25cwzo1LyWVTH4Aj6J
         eWOL3W0cBfGmScbogmpo7+dT2Pqn37oGup7zRbaV9EsmImd0exLKkbugRUoBtWcd/mrD
         gwQxiEghSieT08NyuhkJJF1dVvHRA682b6HmoPpk/b+NVWr7J3RuXjBrmzKkV7AXmGh3
         jEjC6+rSQqqyUBg3BUd1HXJmsllISWmHR9piJPBPhb6Yp9DRH15YTbdiAXkcMVTt7CIc
         Y4txRQeOheb0B35Hygcg/9W4FoC9csZog2mluW6lYaB7EzHXeEw4A1EUyBAVyhEWu3sq
         PWoQ==
X-Gm-Message-State: AOJu0YwjyWT0J4P2T1ZR/Wp3nGKI0hU4/X9ow3MSGe6L7LbNUOf/z7No
	5SJbaLC4muNBE5lTuHXLHqDIfo2OUzu7FMYMT4rSHArPChXyITz2O76C7tNXILhb5iVWvgvqmUY
	dyqfOURmVckKSPZJOlItKWRRI9Tlr/AjzKNe5mNiKxuPP2tURUyIS
X-Gm-Gg: ASbGncvl3pCQ1aorEhXzy+npN746CWw0vWcYX2+imrmVhFdEYlpcRM8vzdyDiMJs/O/
	EdyZj1SrcVoTN2Y1uePzs/fh2NYNSeS5+WzVLkEzGOMCI4XCMgEuKEalW11zP/eTMGWIDZ7yei4
	y+ZFn/j6GDwy2uj79sQF0RLKp6aX46rHYjy+efgTG3zzgePGs9OmDICVK6HtiDoAbNfjzmOflia
	GAzzoUY8Xjz3c7QALE8BMVGGVfCNuqvXFNtDRIPmkNNP3fN265Rfosaak1/oYzhZDS9kzyTxSTs
	BgISkqQwC61oRC9ZWAotct0GUrMNxj3qTsTgZEyrkVP27roijeRKOqs37A5xeT6qxumnRqjGAub
	AQSnQ/4kS
X-Received: by 2002:a5d:5f53:0:b0:3e8:b4cb:c3dc with SMTP id ffacd0b85a97d-425577ee13dmr2185333f8f.3.1759307525622;
        Wed, 01 Oct 2025 01:32:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEamlFHKk0lW4qrWPYCPK/rhtvhoE8+VAFZFxpeTixsTjPGZGBvNgnUReYlehmrWW+5PQy6XQ==
X-Received: by 2002:a5d:5f53:0:b0:3e8:b4cb:c3dc with SMTP id ffacd0b85a97d-425577ee13dmr2185305f8f.3.1759307525126;
        Wed, 01 Oct 2025 01:32:05 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602dc2sm25902920f8f.32.2025.10.01.01.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 01:32:04 -0700 (PDT)
Message-ID: <819891f6-4e30-470c-b641-350a14b395a2@redhat.com>
Date: Wed, 1 Oct 2025 10:32:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] mm: hugetlb: avoid soft lockup when mprotect to large
 memory area
To: Dev Jain <dev.jain@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, anshuman.khandual@arm.com,
 carl@os.amperecomputing.com, cl@gentwo.org
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250929202402.1663290-1-yang@os.amperecomputing.com>
 <cc40d827-3b98-4e15-ad45-5c2033e4ce20@arm.com>
 <6cde8290-3aa2-411c-bf29-eb91a99e33a5@os.amperecomputing.com>
 <746c4dd3-2285-4353-9e15-a0a2fbd4e6b5@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <746c4dd3-2285-4353-9e15-a0a2fbd4e6b5@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sFEb5b6iVnDin-fh71Kjgh8WA5PvhzVD5YBL0QBA4e4_1759307526
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D372016000A
X-Stat-Signature: egdtn5jeyfx11e7tryp6em4w4teaiukn
X-HE-Tag: 1759307529-130663
X-HE-Meta: U2FsdGVkX18xB4LjfTlWIkRUMe+MRTcM0DDSdwrJO1E37Oj/sUlpvQ7XS7eP0w1OXWVX/HaP8EZH4xjM34wf8TxiZtUt+sQS5VQ6e8jOtEdGnW9wEQRzMoxrMDzJATb98/6CteTgQMK5sFjGIBI2EkmW5xpPahhlZoSgmu0FKOFHgPGitWDOiZeDPe818Nlrb/3iQeUJatrB5Vdb0UPpbQYXxwTStFnNWkDgL2pemjAN1rJVA9aJy7ifhrBpZ+ytw7JNVuTJoEiEoGcL48iRjSLWdT309a0rpA/8YCpiMPYEifLxIMxBuFtT4a6mLU2NWFfxfYJMWLzqslo+KIXAJxAb6CKKWJE4vdFFlLkNhJUlFyADMN1DE2dhB1OMcGC513EjfBEvqyOhGpUcagqUr4r1ttYH+AtQV4LhMioOebn4QDwE3uHzsUFw80fJF3v+OumFk1b1ayUha7+XATPWRRhtP8gFs2apr0fHVAj7oP3ddbLIbqpv8ffikpJ/pfzhHFYWw6qHDoBS2vD1FBGFedsOX1Lnsp4zJaPPqDLhLG/ywRcM46hQHe9N94HqlW36odzSlKXqsXZat2otZ5fAWHbG8zE+wvCZBaogidSOmc4FieQTe1STCiqkVw+up6AARobbuq4pH4iDYjXklZN0uKpMfoKd8+1GIETSrB1lWs+FLFgWRVhixytYXaazePwZox/4+6FORNthz92nN8G5WeAdMJMqhMtJ7nCmSW2nSWwV9ahIctZslaBYieJGlGfXuRDXQ4lhSitEGN/IYnYga84KX8h3DHAEgRIgKhQQozlqxsN5k+SC1tk05D4+jRGcZuv2G7MJ/IdqSpjaN2sCAP/q3Di5vLjZlNOWGTwQn9SATRpvtRjCIB1tRaapVGiBCQ6hWBFq9Oi0lGE/h5h7fBA6H7pfXV80SkUDPeYlI6b835pu8bYR2gtA8dRuYvbcoqpLy0/fE7EihwMqJUz
 ERjpiGpE
 Z1dlMoDp87IJacCpxBodsj9t3AmOuGitZCbM3zKQZlm3A0Jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 06:23, Dev Jain wrote:
> 
> On 30/09/25 11:38 pm, Yang Shi wrote:
>>
>>
>> On 9/29/25 10:26 PM, Dev Jain wrote:
>>>
>>> On 30/09/25 1:54 am, Yang Shi wrote:
>>>> When calling mprotect() to a large hugetlb memory area in our
>>>> customer's
>>>> workload (~300GB hugetlb memory), soft lockup was observed:
>>>>
>>>> watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]
>>>>
>>>> CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted
>>>> 6.17-rc7
>>>> Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS
>>>> 5.4.4.1 07/15/2025
>>>> pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>>> pc : mte_clear_page_tags+0x14/0x24
>>>> lr : mte_sync_tags+0x1c0/0x240
>>>> sp : ffff80003150bb80
>>>> x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
>>>> x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
>>>> x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
>>>> x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
>>>> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>>>> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>>>> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
>>>> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
>>>> x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
>>>> x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000
>>>>
>>>> Call trace:
>>>>     mte_clear_page_tags+0x14/0x24
>>>>     set_huge_pte_at+0x25c/0x280
>>>>     hugetlb_change_protection+0x220/0x430
>>>>     change_protection+0x5c/0x8c
>>>>     mprotect_fixup+0x10c/0x294
>>>>     do_mprotect_pkey.constprop.0+0x2e0/0x3d4
>>>>     __arm64_sys_mprotect+0x24/0x44
>>>>     invoke_syscall+0x50/0x160
>>>>     el0_svc_common+0x48/0x144
>>>>     do_el0_svc+0x30/0xe0
>>>>     el0_svc+0x30/0xf0
>>>>     el0t_64_sync_handler+0xc4/0x148
>>>>     el0t_64_sync+0x1a4/0x1a8
>>>>
>>>> Soft lockup is not triggered with THP or base page because there is
>>>> cond_resched() called for each PMD size.
>>>>
>>>> Although the soft lockup was triggered by MTE, it should be not MTE
>>>> specific. The other processing which takes long time in the loop may
>>>> trigger soft lockup too.
>>>>
>>>> So add cond_resched() for hugetlb to avoid soft lockup.
>>>>
>>>> Fixes: 8f860591ffb2 ("[PATCH] Enable mprotect on huge pages")
>>>> Tested-by: Carl Worth <carl@os.amperecomputing.com>
>>>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>> Acked-by: Oscar Salvador <osalvador@suse.de>
>>>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>>>> ---
>>>> v2: - Made the subject and commit message less MTE specific and fixed
>>>>         the fixes tag.
>>>>       - Collected all R-bs and A-bs.
>>>>
>>>>    mm/hugetlb.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index cb5c4e79e0b8..fe6606d91b31 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -7242,6 +7242,8 @@ long hugetlb_change_protection(struct
>>>> vm_area_struct *vma,
>>>>                            psize);
>>>>            }
>>>>            spin_unlock(ptl);
>>>> +
>>>> +        cond_resched();
>>>>        }
>>>>        /*
>>>>         * Must flush TLB before releasing i_mmap_rwsem: x86's
>>>> huge_pmd_unshare
>>>
>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>
>> Thank you.
>>
>>>
>>> Does it make sense to also do cond_resched() in the
>>> huge_pmd_unshare() branch?
>>> That also amounts to clearing a page. And I can see for example,
>>> zap_huge_pmd()
>>> and change_huge_pmd() consume a cond_resched().
>>
>> Thanks for raising this. I did think about it. But I didn't convince
>> myself because shared pmd should be not that common IMHO (If I'm
>> wrong, please feel free to correct me). At least PMD can't be shared
>> if the memory is tagged IIRC. So I'd like to keep the patch minimal
>> for now and defer adding cond_resched() until it is hit by some real
>> life workload.
> 
> If we have large swathes of hugetlb memory like in your workload, and it
> is MAP_SHARED, then there should be high chances of sharing the PMD.
> Although, I incorrectly
> 
> observed that we are clearing a page there - we are only clearing the
> pud entry which is 8 bytes. So yes a soft lockup should be highly
> unlikely. But since cond_resched()
> 
> is cheap (I assume this is the case since it is liberally sprinkled all
> over the codebase) I think we should be consistent. Probably not an
> immediate concern and not a matter

Right, that's one of the cases where we might just want to wait either 
until is is reported or until hugetlb is finally removed in a couple of 
decades ;)

-- 
Cheers

David / dhildenb


