Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEC3C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 07:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9DF6B0095; Mon,  4 Aug 2025 03:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1796B0096; Mon,  4 Aug 2025 03:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0A36B0098; Mon,  4 Aug 2025 03:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7296B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:57:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5B06136557
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:57:42 +0000 (UTC)
X-FDA: 83738320764.26.882DB1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74A4DC0011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:57:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EBt9lF+4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754294260; a=rsa-sha256;
	cv=none;
	b=pAxr/3JV7HsmLw08nEm2QKYHmlIl7nOZ3QqqaVfEzmBxfBmGsEmSuwSofnf9fgGMweoNiK
	8MMLJoasExK80AYWUR1UEcqr3SVpvwB4R50I3I7wwaTc4pLicb1MSGFYttMFlP+UaSpex8
	IqWysXr1dY+yKDkr+/jIgjJIecSvZiA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EBt9lF+4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754294260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEnfn65S30ERPs/XGnstuALMnDwrRUYoFQnMMJQxY+M=;
	b=o2lLd6E+KZtAWh2DSKaVVvgh9TMfUX8zZ2aJYZWjWNeOYFbDYD89l/i+BP0y9R7kC6nYek
	TUrko6VQISrcHr6VRIv2TUSy03P9WNK4sU3sRkxCm8l5LU+fMBumDdTebkVEq9E9qmjppj
	JyPtvYFfabRxX3h29DT4T7sw0WXICOk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754294259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zEnfn65S30ERPs/XGnstuALMnDwrRUYoFQnMMJQxY+M=;
	b=EBt9lF+4H2hDTR8rnBSIdjr0PKTr3iHiv3G1oW15ZO0yYK4gEUv73z5JyOlIoDwZDuI1/B
	xiHAyfVhQUJJjUuUAik4DAd2RPbaIfylxmTwuYZLxiqmFW3d+1AfNUfiV13ng4U1ttn0MM
	dmqiK5qQbBM9m74nT/Je/284oFXz6Ks=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-N3Ih38mtP4uH0EAlxgwxQg-1; Mon, 04 Aug 2025 03:57:38 -0400
X-MC-Unique: N3Ih38mtP4uH0EAlxgwxQg-1
X-Mimecast-MFC-AGG-ID: N3Ih38mtP4uH0EAlxgwxQg_1754294257
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b7865dc367so2291359f8f.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 00:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754294257; x=1754899057;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zEnfn65S30ERPs/XGnstuALMnDwrRUYoFQnMMJQxY+M=;
        b=t6nBlyw8WkJiAsYq5p5CmKNeXlSghPpa9FviyExyKr9JFUyQ49+uxrwzw3gztfUD5R
         ATN83g1FDgBMC+GfT5G3FFFxaaLpYfI/bfpL8fTb6jvdloVwPylkfSzNZICv5QkkzbYh
         17K3QrOJ4Vnf+eCXRNd5Kg4lzUEVeNpA6NI/kQYjQYTTqwiSGybpy4As/E0mMCeBmLLO
         T1vjbL8c/yfx5uBzUtAzC9oRas15dkK1aFgZoj64uVvaP4II8zM37O03VLi+YOvfbssz
         B6SpCzg1OMVGfqKO1bE4eD/7w8qIhx1SYvkOgRpKmTfEmYWTlxMtDbD34LJr4uS13YKs
         2WPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9TM779aO0tYwfQUOaUQ0DAiI5yRGrBtj2beScKE5KyzE37YdmIkd9kf6SqjAyTyIvmn7OYe7ezg==@kvack.org
X-Gm-Message-State: AOJu0YzZrcBMM3ETPPzDIMRXERc+chXrKYWQoxzqozl4jB9AqOcC1zet
	QONIq8+ipYRxjN310ucMYqTDjMrgaO6OyEWuZKaSSCV+K5z+emE0GaCI9VqrNsv9JUi7KxzZUvt
	1RC+Ly7ny9kKwQHVw9okIU4QW2xKxni5nEuk5J6M7dpGU0HS/I1Ce
X-Gm-Gg: ASbGncvtbYN6+jwxwGTVSyVn60sMm0xkPJljxPGo1PE6wWSiUE62BtuysckbCpTZgDz
	kZcnHNHWOM7OZTywUQ0bEim1YwFXQLjOcC4XN/ct8ONteCi9F4+5CUSsRHzU8ssnOSyDycSR5ZE
	rkhFV1BokSAjG6a1nC/cJE7HB3jTaisQ3jHK5Ip3dAwGNrVVQRzjYln7OTGO0T6DotbLyilp3vc
	6GJt5OVydb7aGMpJsdxCQ8JUtdWUfrAlgv3vDtB48RvzqYuWV8XY5lm94Kjwqs6GZVE3VJhHENI
	ghx0hIWWRuIE2RnPMZBr+pioKwLkRfori5I+se+0wPXVWyOjG8v+ZFMcJzxD/4vWOdpRc0KdBhY
	ed7VyNDF6aO1tvhcYVaojX43fFuRkS2goNy4Z4EZyzC4dmlM1cFqbTEdeDZp3r0eQlSQ=
X-Received: by 2002:a5d:64c4:0:b0:3b7:9b3f:1e1d with SMTP id ffacd0b85a97d-3b8d94bb165mr6185809f8f.33.1754294256915;
        Mon, 04 Aug 2025 00:57:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsqbc8gnOPT6CLzPVM6D3iHMXlsCPDfMrvXHulzSXMlqTzPaQDQ5jt5SrsJVVI7HeiFswFkg==
X-Received: by 2002:a5d:64c4:0:b0:3b7:9b3f:1e1d with SMTP id ffacd0b85a97d-3b8d94bb165mr6185777f8f.33.1754294256408;
        Mon, 04 Aug 2025 00:57:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48de68sm14584315f8f.67.2025.08.04.00.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 00:57:35 -0700 (PDT)
Message-ID: <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
Date: Mon, 4 Aug 2025 09:57:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: "Lai, Yi" <yi1.lai@linux.intel.com>, Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, yi1.lai@intel.com
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <aJAFrYfyzGpbm+0m@ly-workstation>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aJAFrYfyzGpbm+0m@ly-workstation>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FGN5OEIxzC-QMT_lJQXMRF4qDXlVmd9AVJtRYqvN3GY_1754294257
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qfj3hs7yhkecqe1n4nhbx6g1cpty5x7r
X-Rspam-User: 
X-Rspamd-Queue-Id: 74A4DC0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754294260-831894
X-HE-Meta: U2FsdGVkX1/28DJfpBXouZWL/9diQaj2JEA06K0AElCEQGd+v7h0G+np7jnh6DpGJ192Urkn5fz6t4AMCDOnuSJNf9kt1pytRdjHGI5N3DMq5UaAS1AfOKcz6QVZi24z70E0nKsdxEpI//COcVOK0TwHCnxidR0Get60I2Bba9UQIS+ztNHKuXJtL1d3TYrA52/YpOU8E0VSbu22dBSc1aLlYZbCu5UNHPOxv4pT8fS6Enmg+jPKYi3WSQ6j5BPP3PGfLEbStqE56Ej1KdcYcsjqCwnHulJBamAxAVigojvj4uVuWd9SRlWYK7b2iNCTJXdh54eMEipXuDMcZOGr4dbo8hyJM4I7WJAX8ol85qkJOuKQBGBFQWKdfDygEhXCM7920DYT+tZDgs4Ubc0rb3Kbwrnk1Lbsp3VNOpNxbGYARDaOiYPc+sfROm7LgLribPxoe1s03yT1HaKPOV2XDOlTIF231q5rZUQc42E+lYPC+dqzmhtsM+0IKlkXoPYGVSIrV72pcL8xXEPbfHXQTkvY0IME8hrmXCPJ0tmDkmxdwUNi6+SQ5n8aclZq+Y5Tas98Y/bj6zgC6phVjTxGVt7VH6rfQJ4umdK2fWDM8u7Kt5lo55lFSJsbbCVenG6vwMc6F//8sx3o0Jvp+zKnW/LNDlzCNcl2WcO0/LlAoI+d3pV+sdTBrfKV1Gsa3PROTcIZkeH4RLXZowUigj+f85hk3ANHkZTiTfwDYzIP1nGAD6fX4TtFpB4lscWCnh2Vwig1n1Nq68pVGIMElPT/e376IgTgz3kCJy2SrMtDpJaJNtQquVf5yyc7bV1CbHeLl66IFBEf1Hb8nWC5sB8yhynfDSr0ZoYmCKBiiMddDOm9zAxcoqbJey8xQWb9FIS/dCc9Nl9luqYqEMOpN7Jm7CiqMvbfOZOFq25uiyyHxpALPgolKpVtAJdBvgakxt2TZGEVxjO/YXY3dWSIvpc
 +RcrAzbO
 33QGPt9dh7ftGCx1f2NKToWEMuGfmXiES45i5TrTdUSruU9LBGeZg6K8ihwsU2y6EYfhn+AN6BzG116byRP2wJT3VpfKlBKX9xm/8ToI4zLurfh541tA7mrrNrS0swVTU6iYIbuW1XFs+NddbdOPKMIknbxN/1ZeQJs+kLtNnWU/1v5M4dtnPgxYlxNwk6kQ1etAJoDMq8vi7B+sZNqn4BltmnE2s2LNWtNCqQF0jranj+GbLB8L5cVczKzWgYJbGIHiL06BQqI5pwErs4xshtYxlACwl4UCURVmRHfoHOhBOhZd04Pn3N0bTeoHKm6ZCKdizt6tEs+PcBH2g/Z8QceYaQOwNQU8FQ5f4QsjQcYOrBnycYntSUhigx+0loKHWcHRhShnSfGQg15MaB/1c3lqnhdAqnTIBJSNzbpXzRHpjoooBlhpapOUU5XMd3sEh93Jn6c8UgFYbLufl/c1ooB7O431L17BFcnTxyFgCGthLjICU87qFmnA/yLR2teBUbGyYFcnAJZmK8llwWELLTunkdoLF+EDeCBuI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 02:58, Lai, Yi wrote:
> Hi Barry Song,
> 
> Greetings!
> 
> I used Syzkaller and found that there is general protection fault in __pte_offset_map_lock in linux-next next-20250801.
> 
> After bisection and the first bad commit is:
> "
> a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
> "
> 
> All detailed into can be found at:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock
> Syzkaller repro code:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/repro.c
> Syzkaller repro syscall steps:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/repro.prog
> Syzkaller report:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/repro.report
> Kconfig(make olddefconfig):
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/kconfig_origin
> Bisect info:
> https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/bisect_info.log
> bzImage:
> https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
> Issue dmesg:
> https://github.com/laifryiee/syzkaller_logs/blob/main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log

Skimming over the reproducer, we seem to have racing MADV_DONTNEED and 
MADV_COLLAPSE on the same anon area, but the problem only shows up once 
we tear down that MM.

If I would have to guess, I'd assume it's related to PT_RECLAIM 
reclaiming empty page tables during MADV_DONTNEED -- but the kconfig 
does not indicate that CONFIG_PT_RECLAIM was set.

-- 
Cheers,

David / dhildenb


