Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FB6CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 09:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824A48E0014; Sat, 16 Aug 2025 05:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF488E000F; Sat, 16 Aug 2025 05:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F158E0014; Sat, 16 Aug 2025 05:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 515218E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 05:01:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B05AA1403C5
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:01:55 +0000 (UTC)
X-FDA: 83782028190.10.ECBF487
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C18940008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:01:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ItVfvCgr;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755334913; a=rsa-sha256;
	cv=none;
	b=flB44lwwaL8/VDaBkS0xEY/1UuzDMXCfoeaw859RtIHaeOIkFLtaODAASw4dLTifeyuR4q
	WyXEYXEPGiJ/Cm7HG+1qPrYW+OkevepDrnf9esxf8393wN1BAdrakJSyVmZxpt20RcUxUi
	w+KrMIwBYqxmewCCDiybB80ZK6GVZrE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ItVfvCgr;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755334913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLRaqZk+G77LOdhKudPGgxUl7C3uWX/KsdNR5jlxTvw=;
	b=QinJGj7ECc67VkAcbQIDkvs2flO9994BpqXqHbWx56J37B8aVTQpCzOcxbn0XEzkoexoCK
	bp+xD8NmzRaGK04DFG2CX8kzMCPNtG/jJMWoEFMbg+Id5hWZgkCjfJ4sF0JNFVAS041hlD
	SuOufA1rhr7Chg40wk89afXGSu9s0TI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755334912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GLRaqZk+G77LOdhKudPGgxUl7C3uWX/KsdNR5jlxTvw=;
	b=ItVfvCgrIGvG6A3Mse2Ycf9SPLBmCxMEdYbkiy0iSJr4jfmZgBRmgdHZlEpx6VAMc/7k1t
	HMaOSkhhlJAtPuHpRp9ympYFRirLuq5e41dPN37HS6awjtNnJGh/Jy1ze3Bv02Yp0tT2v8
	3pODL5A3yeMrbHiWewXT/SjIqu+iQzI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-ZxviBOlrOPGL51_Uqw-wAg-1; Sat, 16 Aug 2025 05:01:51 -0400
X-MC-Unique: ZxviBOlrOPGL51_Uqw-wAg-1
X-Mimecast-MFC-AGG-ID: ZxviBOlrOPGL51_Uqw-wAg_1755334910
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9e743736dso1291467f8f.3
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755334910; x=1755939710;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GLRaqZk+G77LOdhKudPGgxUl7C3uWX/KsdNR5jlxTvw=;
        b=EHvzAyX4xrc2ntEcHs7vdukNKPtzt66UItDh8Mp78qSuM2FUsVELyWimG1FOavAJgD
         QXJNwhD64klA4FKTvlV0DLIj4v4deO0tPBAZsl9F6eqsOzAcI9MXnU/U54Hh1Y0NcP0W
         hKlV6eKFrIh6b9O37/YgLOG4ef6YPp3z5uXiuijlP93xR5ezgatd2RJoHPSwcFm6gRCC
         p85i4hfLdC9djLfUc7GXrUTByB4HWs2dqhi4jKlDbjKlkeDzbAtJrQs06mzTxKauWHWZ
         MQvV1RDj51ld1Fq6sgsdaeZKJBVmy+PCsaJMstF5V5k0AoBzMEkpzIdHoMc2Rg3YprAG
         n6rA==
X-Forwarded-Encrypted: i=1; AJvYcCUPnbApBb1pZovbCrSD8caL7TLudJ33iu2buAXIdj9sc+9s3SnOjG18bi3Lh4THKTDH9VSl8S5wnw==@kvack.org
X-Gm-Message-State: AOJu0YwmfTGXNdIpW8a9JjRBQte120sEInNr4p7C2N5EUZC9+ZnqjfDn
	oKZfxQSsEmaeUS/3TdhhoAjesBKqZjwbBsvr/f589OIsbSn7L6dZawbR21k+3AfC12xH9nVVAsT
	2zh+r1yHPxWxbcKjIwt8rsk6Ug2wIn6qTeJVxSaUzvX1+kkWPmzAf
X-Gm-Gg: ASbGncuSHRg05yF4OTIcU+Y0Sb3fN4+5v/WVfvnWGI1weZqkuJjvVsNZ10WePTJQnJF
	tmAT+QAJ7zxv4hlJsyS+CSWn0syUvvV2Dna/IFep1pzQ21WwYOssKDPTJc86I1kblJmsTqCAViY
	62YndDVy0+I+N32E55LKN8CHRmED7X4c0MrtQfOg4KOQOlmKNUGLpNIh57kjSpqVZmwo/xRHDKn
	7tDjM7jEkIf4w/aIB1zdERlikvvH0zBywvKVFt+gPE0rUb9Dn4jAQZ7Mo9dBdm6n3Vl2diA5uI/
	2MF4+O8WEP7LKCR4hbgCJ1ubjEtOgTzwzd0wOpzoIrKSJOU2zfsVRI71Z8GBdVJNiykHJKNKdKa
	VL2F74Bi83ElZJ1PT4qymGVMnKF4+E0mQJM9wm1L/GX4HaLJYCd4fUte/k1s5o8EtmIM=
X-Received: by 2002:a05:6000:430b:b0:3a4:eed9:755d with SMTP id ffacd0b85a97d-3bb6665cef3mr3712057f8f.3.1755334909765;
        Sat, 16 Aug 2025 02:01:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEJeEK643AlfLu4zYVeo3CzuO7W32xxSVbF2ZLr/0L6Y10VTYefWkyiIkUj9b2SMeFimaHtg==
X-Received: by 2002:a05:6000:430b:b0:3a4:eed9:755d with SMTP id ffacd0b85a97d-3bb6665cef3mr3712023f8f.3.1755334909345;
        Sat, 16 Aug 2025 02:01:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb5d089e07sm5007536f8f.0.2025.08.16.02.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 02:01:48 -0700 (PDT)
Message-ID: <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com>
Date: Sat, 16 Aug 2025 11:01:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
 <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
 <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dga7r_9fAq7P9ZNAHfZRf0FFunYNFilfmqmP8F3P4n0_1755334910
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C18940008
X-Stat-Signature: 5o39dgw5hx3pppa7hz3uj6zpahcqjq79
X-Rspam-User: 
X-HE-Tag: 1755334913-168280
X-HE-Meta: U2FsdGVkX18WAW+Rmte3qaZLIS5evU5K27bk3YVy2lwVWwVXw4p7awqInB7EpgZtGu/nDme7lUolOBhF2FBV1XzWTjoVRNX4nTS5vknMulduxUTlLAy7SGKI29mzhCp74vrfMAnnN2sZov7UbPn6xuwaxQXmGI3kYdfHsbMR/VpyadbcO5wbQ0AsKMadBqHHXkGLZO774p4LX9nbTpRsu5cIH7fgpqZkpNaTx+yGm/3mq7MyGo/uMz9n18XdfhpUw4Whk80tBC6iISmNMGz22DNMW/LSNJNWUcVndDeGJ8Pr4ZmunTwtU73c25JTnBTgvaYHD98oyBJfpkid6hwDqEvi8hZrccUoLtZ6W7lWXHFV8a3Lo3y8KGbBYgoRcTvp8fcp8eNOSTO0U8BKwptyeDZqiJwOpLzLlPhV/pnmoIFmgu55ERv5n58fiz788wxwcLLNbrAJkQWt2UXlqwMzu6aY0pFe0QTyOSdeRjVcHj0Sn7RzvUFRIulN1Qzml07RODdJ/0CnwhQVQD6/kZnU7QnTrFBbbPJcVYy2RVjSg2JTfSK8M0gZDsKmcPC5/15KwfVwfrYmW9B62WUSFBm17GubX/pPkRn2poPfPd+uYfT8Uz4bBO2lWbUhJgKg1lK1YQJfWNlMFZdX/A4tTf20TpF0M5I/RltV3DubUytMKWGjCKMR2TC8AgGiuYNQOxfv9EFSoEAW/h3EAA3IhQvczTAgbv5fXxaWKOoRZX10V+3eMc401wSGu9lKdfXY3x3A+dpFyfWKW+v9fTEqo03HB4WZcycVYxElKkCyL8REGcv44KCyk5AZW2hbS/ukQekRv4MLX/hiSW1okIvht38erJCJd5SH8BtSSqNAEFFSciNYFTWFBQ2dhThj82gWdJGjzj3bmmq2wMsSeVDso2C16pqbbfEYmkx95wjC5Wgdm9bjGVqIndA+izVplzwbksOhkn6aYpEN+HDsl7jd9Zr
 ZyJgrMt6
 mZ2hCFrBdEPouOXoCLblI2nDRvJY4me59JNUUlbpLJOYnAJsr+2VdWKAQyZijPU/m9LrWrWbwC6CnxgwbSTr7wjYKknLsV/egWdLJnw4bheT1Q1ESwkXOnjXoNIxbGoSoBSG8eD0ZNdtbBnHri3UEn6RTn0wzT4dg+k3koD5aHdffm8d7QwVXfhDNxpYLIjlkGVDdJqUv0uLh3EDMpw/CXaU03f8DwjwzQ0esBtI8jdKeoY4oDuKk0y+xDEaSczpnwBgGzb9MOwetIUg6zMYypkqQ3wM/p6v7ggkvIU87nnpZBnxJQO/WT2FjNShA+kx8oaLOqzKXjQWoMKo2VHGwxVprpo5wHGB3mlZqz03WFdKREq9KjTWcZP/dp1wE6djwPKGfI4slRTfmRTpV45HNSC03U/SUU34Q4F6egkcBTLoCEhhgERxWRS7EGteOKCIbWK4+5/E/TAp6fmddS3jan6Ya2PW+nPZhIMDrghW6HtPVbYNpUyjRa+DdaYPNwm4RGUlasi1FwYlv8F+W20CmvxllZ0XCI21pMOeAapZikoXTft0QbHCk+Z5O5B0Owq971zLZQ6YgPTxFyLeNWvl2anmXn9qnXEVa/N4h/1rIqkvqUmlWjNrLL4W4jcy6zsLO3PYxomSHvFfRLEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 10:57, Huacai Chen wrote:
> Hi, David,
> 
> On Sat, Aug 16, 2025 at 3:22 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 15.08.25 11:05, Huacai Chen wrote:
>>
>> Hi,
>>
>> please CC the appropriate maintainers next time. You missed (some)
>> balloon and zsmalloc maintainers.
> OK, thanks.
> 
>>
>>> After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
>>> page->mapping") we get such an error message if CONFIG_ZSMALLOC=m:
>>>
>>>    WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+0xa8/0x1c0
>>>    CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
>>>    pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 9000000100423a60
>>>    a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 ffffffffffffffff
>>>    a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 9000000100423ae0
>>>    t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 0000000000000001
>>>    t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 90000000023fcc70
>>>    t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff00010eb800
>>>    s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000000219cc40
>>>    s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 90000000025b4000
>>>       ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
>>>      ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
>>>     CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
>>>     PRMD: 00000004 (PPLV0 +PIE -PWE)
>>>     EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
>>>     ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
>>>    ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
>>>     PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
>>>    CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
>>>    Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100420000
>>>            90000001004236a0 90000001004236a8 0000000000000000 90000001004237e8
>>>            90000001004237e0 90000001004237e0 9000000100423550 0000000000000001
>>>            0000000000000001 90000001004236a8 725a84864a19e2d9 90000000023fcc58
>>>            9000000100420000 90000000024c6848 9000000002416848 0000000000000001
>>>            0000000000000000 000000000000000a 0000000007fe0000 ffffff00010eb800
>>>            0000000000000000 90000000021fd000 0000000000000000 900000000205cf30
>>>            000000000000008e 0000000000000009 ffffff00010eb800 0000000000000001
>>>            90000000025b4000 0000000000000000 900000000024773c 00007ffff103d748
>>>            00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
>>>            ...
>>>    Call Trace:
>>>    [<900000000024773c>] show_stack+0x5c/0x190
>>>    [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
>>>    [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
>>>    [<90000000004af408>] compact_zone+0x558/0x1000
>>>    [<90000000004b0068>] compact_node+0xa8/0x1e0
>>>    [<90000000004b0aa4>] kcompactd+0x394/0x410
>>>    [<90000000002b3c98>] kthread+0x128/0x140
>>>    [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
>>>    [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88
>>>
>>> The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
>>> CONFIG_ZSMALLOC=y, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.
>>
>> Ouch, I missed that CONFIG_ZSMALLOC can be configured like that. I
>> thought it would always be builtin.
> Make CONFIG_ZSMALLOC be bool can solve this, if you think it is reasonable.
> 
>>
>>> But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
>>> access zsmalloc_mops because zsmalloc_mops is in a module.
>>>
>>> To solve this problem, we define a movable_ops[] array in mm/migrate.c,
>>> initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
>>> let the page_movable_ops() function return elements from movable_ops[].
>>
>> Before I took that easy route to just get it working quickly, I
>> envisioned a proper registration interface. See below.
> When I found I cannot access zsmalloc_mops in a module I considered
> the registration interface. But in this case I think that is an
> over-design and not straight forward.
> 
> Moreover, a registration interface looks like a redesign and not
> suitable for hot-fix.

I think you misread my message: This is not debatable.

If you don't want to fix it properly, I can send a fix.

-- 
Cheers

David / dhildenb


