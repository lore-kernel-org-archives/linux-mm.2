Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 330A0ECD6C6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0716B00A2; Wed, 11 Feb 2026 11:16:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D596B00A3; Wed, 11 Feb 2026 11:16:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F936B00A4; Wed, 11 Feb 2026 11:16:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5317D6B00A2
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:16:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F376316048C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:16:10 +0000 (UTC)
X-FDA: 84432677700.08.3492570
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D613180009
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:16:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Al9uI8L9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770826569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgAqT9no1A9t/LdhObPgCM4EjqEnJggY8Ul2fOiZjWM=;
	b=q8PNplk70zwKu0aptpnpYGaG/eRiPw75uXg56cQ+ppCUTaRYOMkW/w3Fw8OyIB23Wysh7m
	Fru4EYNi3sCESr3MjrSDlG8MQ3sW0p1Q/AyGwZzrDwsV6jhxQt3+gh/ZKjVv1YPwNRsHCF
	UZpdHBT6i5YHSS4AVONmURblxv2TbeU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770826569; a=rsa-sha256;
	cv=pass;
	b=gCXdIRVYLJt8IUrn91BUx/B6TUxnORSsFNec0cS+wUzXIOZu3XYkx3WkDnmsZU5AfAiGrV
	stClISOpEfC7x7pDqewb9LME4vnapjdgXaF8QPtPd4pWcUescxYavMfRRkYbS/TaOnuRnS
	gVfMYLMuyzUTWonPS5YbyQRN6jK1rqg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Al9uI8L9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56743b33c67so649734e0c.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:16:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770826568; cv=none;
        d=google.com; s=arc-20240605;
        b=kmpnC1IyR5SdP8RbtU8M/TOj4YoQuI2IufcZufEIF0g73FNZ9V7u9rHh0UwBOCTo3L
         3ZwGIstokVgQS1gEHL9aIw0eygBZLfnwVgIqKEDJlbdmiPrNqLsYJxkn8DysQ+cZMac0
         7+NTewsHk6m3Xa9CmLjuGsqwX07eFfw7ZZz2ndcExtoPSFKXSM/CMZHaxPqE7Tq6zoQn
         2cuScnsv8+pL3n2lBBbkAcf6DfwXmHQISatFEOf9EKWAYKeCnRx60aPfPgqrXg66xlWe
         rI3KY2ZLDcRtXLUbhfL3Vz4hCH+P6CArsmdvKJyte/xG9KMoh9Oe0cWapm1kbhiw+B9h
         +DKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jgAqT9no1A9t/LdhObPgCM4EjqEnJggY8Ul2fOiZjWM=;
        fh=rq90h+vWSpPrqGX+KewoAj6Afri1oDPDvYuVnpE+d4k=;
        b=SaAlAO5Aek8LoX6kHoGJEixdshnPC59kN08dRJiURzfQCnsWL9+XnvGs3PO10KLKeD
         LRegTfpbmeX3zyvq8O48wGOEznXU8+v+KMj5YBmcdZS3ORi4vu5M3Sz10yZA8a0HYYzX
         BvAGxhF+iK/rMRkGLGm3WUwPerVNGeW9QVdy4SDjZsb6BKf9DK9Nx5V/e1q1dM5peWsC
         zhLE9XY/xtwEmjW2JSlLQjRKB5eEYf/bkgNWOghIpbEohBYahICviCUzILhqP2Tolupi
         72fpBqSjft7DcHlh4CoBrn9eGIgm8F4uCRnW6wNPVfZD4SmeCT392wA8Exq3gmx6bY4f
         9VpQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770826568; x=1771431368; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jgAqT9no1A9t/LdhObPgCM4EjqEnJggY8Ul2fOiZjWM=;
        b=Al9uI8L9HCBrnDBARUDkx0hH0ZjhxD0IeeFEn/GBiuffVZsYZT5L06cgnEwU0oomQi
         kZ3mep3QWxaxfusRKiB2PutMs+MPVo2nYv+0nEfqZ1NTNLtixGU7v7+kRvsHIRJpKFy3
         rVBgZXCB1X6SETotTiekQLZE0TFGyWeOh9gOG+sflNmKmxmrYksQqpQvsuW2Cc5a0s87
         hLHwC8BPEJUy1WCp3xUDh8ISLM128gtRhdLvJ83FWmVpdV0O1WQ9kKYNV+CkcVaUFLeU
         PRiZYyIPiNzChouuJq3Cnlq1zGOsunpmrAQN8f2IfkvEEP+zRcFTbKhdvLcVOeoXhCTa
         JTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770826568; x=1771431368;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgAqT9no1A9t/LdhObPgCM4EjqEnJggY8Ul2fOiZjWM=;
        b=Yc9AR9TXBHtFdbx0PwkRNCvH/J+hCARVNbTKUPdhjknM3fSnGX5aiFaF9KCOzRI3eS
         qRA8kt1blrybuUD6uLyugqooTgGovLLLiH9fYZIRTQU6amy3nhoxCFiw8vAjReTYKzNu
         TPhdHDDrGXuBQJur4vKtwE8OE3Oz22pXMYWs4RxqPNp9IBJFwfsNgZZqY8/FV6d7Mn96
         V3qqh4rkfK5vuQyQ5X2epw62vSACL+11gCeyNt1MsCrBnZeZiI2mtQ845HIpZZOd/DuG
         Fybpjk50qId3HMSqK56v2DAOM5Bkv/AatkfXb9XIHnXrr3KU91jGmb6ODkRD97AOrh9o
         il9A==
X-Forwarded-Encrypted: i=1; AJvYcCUEuw1ggXchDfowwG/7a1bnMqf4vDMueD7R50Ztz9G5fDJKIy54IGrPHfmbS5rStgCS5zqpMuBzKQ==@kvack.org
X-Gm-Message-State: AOJu0YwY345VY0XlPnQrfa18HqGoD+hdkbJM3JyWeyObsC/QEpgaNQ/0
	DrvyHO/QPTniCJqQZ+SsolhVXqacdbxjJA/hJBYr1FL8IisXwrbndipelUtB3qgAseoaZ39rK9U
	JucEsdou4fTIBT5fV4A2ClYkY1tI3xJhEz42r+Zwi
X-Gm-Gg: AZuq6aIfWVP507Ec2RFqGimE0cxwvkjCE84idsFQwWp1jGG+Fzs07MGmjeKB2jJH5mf
	pWd2GnC2SqzL6F7JkvgnfoBEYNMzPSFuEoVzbIubLAZRAas7aJu7RyphpCpbvK8u7x2tsjBK/xg
	VRhtlFInlXqQTfceP5PX5Y9dBq7YPDzwTEOhjal9quNp34UVKv6vDucqZMy842VhCgcWz4WRrYm
	WtWj20o2+lt0Qr88uQMq/dnXqccreJPq19BSAJOvnDZG9sHwyxIbYrlj3IUDqYWdxpKuAwVbIOW
	t5mWp/qlpWHHLwcBBsiM3F404L/6AfAs4cnr+Q==
X-Received: by 2002:a05:6122:46a8:b0:559:6e78:a43a with SMTP id
 71dfb90a1353d-56749dca0f5mr914919e0c.9.1770826567640; Wed, 11 Feb 2026
 08:16:07 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Feb 2026 08:16:06 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Feb 2026 08:16:06 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <5759bfba-f235-4b2d-bb30-919dcdfe7b2c@kernel.org>
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com> <5759bfba-f235-4b2d-bb30-919dcdfe7b2c@kernel.org>
MIME-Version: 1.0
Date: Wed, 11 Feb 2026 08:16:06 -0800
X-Gm-Features: AZwV_QgQ7r_3lH9Aj7yhn8j8us0bHR_cQtnixpMPdHLE2O42Gfq5J2j8Tc-MA1I
Message-ID: <CAEvNRgH1rzZopht8HoKh_Z+HsESMnpbgb8n3o5ezf9it_CrLsA@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0D613180009
X-Stat-Signature: 1hb6az8x4if7e9tdxzhdb7y8umq1t7h6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770826568-911902
X-HE-Meta: U2FsdGVkX1/m+lEdrIqNGN/NesPeszd7SwALnjIWqlakiKgoUVJdkM8/YINQ0YD9MPw5MmLC9MAcQ5QobnQJHcfPWeyD16x/CEkHRmInBtYH0wE/sJ+SC6bSUbYnY5sYrg8Pd5z/bGzU2ITHFgOZHgortiGhkw/n06iadanzOom4XrWtxP1J1bqBnub9G0vEC80NmMoBx8+ZUZZF0IGA6qyATP4komWAumBrgR/6kDxGnSd1FM0lgx+P/cCtTIcrswi/j1HQ0YTd3SOoyaZeCAykNxwOGjy4cq4SRiuNF8+KzCNt87S2l8m3nxCnDwhgpK4g1L/uQQhMGw3cb4Kf8VC83emez+sP9MRMEySMjowzF7EvH/WWa0f6fCEn++aBUYWlK80ZfzwaP/G4PtarEaD3RAzbJKFQuZqCTPvl7w0hL/fhz+b4WHsjN0Ns0NcQ1hNIdnCFc0skEgM/4foDZMJwY0Nuh9KyKEl3NMqrfbc+N/8m4piRhmYxCKCTOoQ/zagjiznRN+XiPOHpt6D4SKvHSts3g/YHnCobjdzeyFQzh7czXskc6BJ+UgZ2WfWsXuO18Yl542z3cmvdh21mOk7kXTJVGsEZyhrycf2dv44AiSfBchlfQeLeEA/H5GaM5tBLIc2EW1JgRsbOhV9HgdEJHlX2dthMGaBdEvNtF9Ock0tb9y0iVqMGb1evd1mVDh9sOfd14dzu6vmm3qLOKIDEd6xnPQaIHY25DFPcIVYW+gLpYU7o0UiqDKkQH/+/nmJ69yzqfFMSLcWGWc503uYkLdRIdI5Jqe59gD8YGAg14y4P8dWSmSano0x5zPPRJMiiZla5ioFd79z2yr0EH5TtNTNj1wNHa3PpBzY4XqR6TbEb97RJ91feAYhqt2GE7xLzzMLyJ8J6Qk5/8eeHgTfh6PnxpMfhnwM50L0XeZzUR537FO7fq0V0Gr/LX9gSbepjEOk7vocPLhHAOPN
 7mgT7pms
 Vwb4Z+vf6LtIlIfuiXZjRE4O0jSiEeJJsPOU21Lz39UF4AIGKZSTV5CAFjfvFyD+odAzh8t3Kh1zBeS4Pmier9jT+YuCP+dpPWeG2l21ixrhREo4GoMOJlYwlDX2dLdEVBg4Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/11/26 01:58, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>>
>>>>
>>>> Yes. If there is no guest_memfd we wouldn't need it.
>>>>
>>>
>>> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
>>> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
>>> skipped.
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/khugepaged.c?h=v5.15.199#n469
>>>
>>
>> On 6.1.162, secretmem VMAs are skipped since secretmem VMAs are not
>> anonymous [2].
>>
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.1.162#n135
>>
>> Same for 6.6.123 [3].
>>
>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.6.123#n125
>>
>> It breaks in 6.12.69 [4].
>
>
> Do you have a reproducer? If so, which behavior does it trigger?
>
> I would assume that we would suddenly have secretmem pages (THP) that
> have a directmap. Or some page copy would crash the kernel.
>

Is there a good way to verify from userspace that the directmap hasn't
been restored? Should I use CONFIG_PTDUMP_DEBUGFS?

> --
> Cheers,
>
> David

