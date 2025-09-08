Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1931BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DDE8E0011; Mon,  8 Sep 2025 11:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745878E0001; Mon,  8 Sep 2025 11:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633FA8E0011; Mon,  8 Sep 2025 11:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51A728E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:32:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9A4FB6D44
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:32:00 +0000 (UTC)
X-FDA: 83866473600.16.97E2A6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 931BF40018
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:31:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NFvemDOt;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/AmiyqDL9vHReNzfhyWcNWwH+eng+cyq2XKxF08kzk=;
	b=63YkDUYLsGrgbARX1yJoF9LVoY1Cxisvul6fmONjTxskoYzH4aqpYLGj8dezPNQl0MUgye
	0kaUSWl1JMOhmJi+T76jrqzmYXpxlliqoj+nQ0edJGAB7toS0Dwnh0O/Z2qTn42GbEPNZZ
	Edpxe02TXMW+JSsyqRvC9mwO4ktLkSA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NFvemDOt;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345518; a=rsa-sha256;
	cv=none;
	b=rHwPQNP3RV+nyIo4HwkEj/nQtu/CyUpgIpzEpcX1p/Yps/Rbn1rU9LvEAJxnC/2CGKqTJM
	mUarkWL2nu1u+Z4QmAsnaDktMpxngOSFcr/6qnV36NgBuvOL6yIDY8zDsTEiCShaNgqvWF
	kpap0VIoh+GfqPUOPObbcEbvC5B6aHc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757345517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3/AmiyqDL9vHReNzfhyWcNWwH+eng+cyq2XKxF08kzk=;
	b=NFvemDOtGHgEQ1NDyd7mkvMOVmIKzRhRaJbFQ5pOCQFBFeqRDPPSyrmk/+XYR/FAL2smSR
	92VEIQ3T4Ukkg9LZSSDS0kNUomNqm5VEM++BFuUObuXd8G+0tqdIN0lCHo7SHX+7XwKc7C
	K+6T9XyZiRSTapDEsWvgRDNb2ZRgEEY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-cH8l5zjvO8Gi4M2euLuvVA-1; Mon, 08 Sep 2025 11:31:57 -0400
X-MC-Unique: cH8l5zjvO8Gi4M2euLuvVA-1
X-Mimecast-MFC-AGG-ID: cH8l5zjvO8Gi4M2euLuvVA_1757345514
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b99c18484so19384845e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757345514; x=1757950314;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3/AmiyqDL9vHReNzfhyWcNWwH+eng+cyq2XKxF08kzk=;
        b=Cq9Z2bfFl2/EujVi3xDk+nHDSZ3Cm1XoPtIFPpUfRBYg7UQp0vAENTWykA4uaFjtUX
         Y1NLTcANBl6kBxD/eKsfA48P4HhetYnUaRr/kciBhdH5vmTWpmTSwY+FTASBoaGfBhKF
         XGuUilS3cOmcQtjGH3gwJL8xG/FolZaCaHzxPLb3OP8R+goXH8OY6JVHxZXk2GZ3mh+h
         UWJSyIKu29q9RL8t3h1w04tEFaeiM3/KLgWzMVtX5dWjMgtVbPpnRpLNeHjK3g0DPDeO
         zNF0AYS5tge1xjDSisLxH3W5SCU9of7YQfH0NbYWPAU1MgEqN8zfmO/RjTEPFH2IOLJi
         KT5A==
X-Forwarded-Encrypted: i=1; AJvYcCUU23A3lks6mKzXvptjpUaAuVj5dYN9dXX8DvePlUP/dt3LGoOy7yyBPLnXmdFZs/jRnDm/rJhevw==@kvack.org
X-Gm-Message-State: AOJu0YzNQg/yXKcslF0LE+s9BJsOWMYK+Ulsv5dL/Cv9rWfnnIwss7Eq
	TbH9wolbaMyRjCFsfplPwhPT9u1YRIdRj0mLoe4P3KYSjhYkC6EBHJ4leZIXb2fts18Amsk235q
	jOJmVropQhwwMi40q28lLIQIU2Y2ze6Ylu/A20g+yUkMQXy50+CH3
X-Gm-Gg: ASbGnctQqxukVZPGlFLhy72JuUxe2iGZzvnPkQ0GiHr3nEr1JfQ0edIsEUfVT19/lI/
	u2x+3KSZ5C0pQXju97Ef0qw3sfe1pjacHW92ltDc36xYSlqJud1QgBDmMcv0WAh4w0cXjnz3kkH
	POU3c+Hp4ewPiZDkNK74j3S8uzjHJgCPbAl+ObimuvrFXGUVDD9qbsresAebniOXy/cvCz3pBxv
	WoNTkCpaR8gDih+5MbowVmlkhvS47l7ktbmjHlheYsCyOKc6TE2vYXO6V+05sOEvHogi+/F1BeJ
	R9cVghPyAQqpYPm7DDlqxpXNor8GW5LWw7LuFX2sQH4VlaoAynaEY9trtYV5JwwW0mt51crPo2s
	sWCSYg0no0rFPjLIAPzlsolVITyXVY6kavC4v6dpvZdlD2ASNO/H4b9eD2kfb1ROJ
X-Received: by 2002:a05:600c:468a:b0:45d:d19c:32fc with SMTP id 5b1f17b1804b1-45dddeb7e1cmr77122265e9.10.1757345513974;
        Mon, 08 Sep 2025 08:31:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9rpy3InIS+5sr81R5XgCQln42twosPUaVcPgtYPShPoeqkbUoM5WXvKiqBYV5iWkxlAlPFA==
X-Received: by 2002:a05:600c:468a:b0:45d:d19c:32fc with SMTP id 5b1f17b1804b1-45dddeb7e1cmr77121535e9.10.1757345513379;
        Mon, 08 Sep 2025 08:31:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d7ac825b88sm28792480f8f.7.2025.09.08.08.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:31:52 -0700 (PDT)
Message-ID: <cb2f3d85-928f-4a48-9f14-0628c189f10d@redhat.com>
Date: Mon, 8 Sep 2025 17:31:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] device/dax: update devdax to use mmap_prepare
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <85681b9c085ee723f6ad228543c300b029d49cbc.1757329751.git.lorenzo.stoakes@oracle.com>
 <e9f2a694-29b0-4761-ad7a-88c4b24b90b7@redhat.com>
 <a97321dd-d8a4-4658-8894-14b854661d34@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <a97321dd-d8a4-4658-8894-14b854661d34@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dk3H_zgPnxUPlntB-9cj1ldx93FImx2ENRFmZXsXjJU_1757345514
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 931BF40018
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: eurq7ynoicf1zeedoqw7pbtdfkq7da7g
X-HE-Tag: 1757345518-519068
X-HE-Meta: U2FsdGVkX1+ptf+2KZuNB3TmQTswaacfG/rJWl9UlNbrJIBZHcE0NkxIrP+wZ7IUwPTdNNxrSxNBH0690P0MDEZjSUGMbp5X8ZzhcvXontQdzreMhX9FOa3zBgZYxx8O9g/fdxOGLDV84k8b1k0MC2L6bPeWY1q9UUZ+UoTfjxnDXZfrxZ7Z4KVtE24uIhwVtux2DhuwsmDnSfmKEKBiuQVmXnzOeTGvyysNbDO+Kir0Q86so+ncySOfpWL8CkXTX8gWPAgnYlOdEMCG/JpiRvrKSrAOFH4R/PN4U4V+qmrR4xQwc1soHsY9Hx3cIrnHK+IthKLMuy56DytSq/NgXTCydg0EMErpyDlaQff2M12PoLbqmU8crQo/je+FVzCA8UTeMtrnW3fk7r9O++MJf7EMXdYU607iauI+5csjH9IdceRKpju3VMr238J+x/mQ2Kj09s/3mJ6tooYgzCFZT03g1LV/zhEt0LOtsHHyj19XUbA/tp/VjO8eAkOtz0itfMfDUJdrjHAaOjQS/A+UEImxwfxKKEle2vQoSPVGoI3yRInIiHSJKqz1NY4czdt4SOi2yVwOUZkdjYzs+GGtrikSpO0xCZjpG0IwIhT7Szu+2decnqVYU+MVDZgY1aFiAzBoemUlSTs8rmFEtPp43TuKsC2gpcJogm8SykK6dPZJC8lM3Q6fnjbpNC+F7manq1pC4ss0av8KLpY1t0KKKv0l96YUk4Fa2YpNj4AyoaEpM294RvuOzzOjiMOntCaqsuRh0Vaj3PXLvHZZxiPmmuWNBt3PO3wpGWfncMqz/fsDBlpP9tT9OSE6hEqIHDNerYPOayCw++hoP27xBv8oHWvva2aeSJRTcffKPVrywiL5DVgwCZPe/fuMA8E/IziIg2amo62fukWR9Kkb+hApDlPAv/LI8JY+MEFm2VZL5DGJ+c7dFJfEzfE78x/XtUPk9cowV+fcIuxyaB3jaOv
 PNERwAhx
 c1DxgCdFLV0KPvHTxJ1PDmVxTRYTXWCPzx+yHvO7fM9KxcU8xsrF0Ff/q6TQh57z7O3d6xgbauS/fa+VPcrfKVR+gkxyiis5E6CHKEJLEcwnloN93qh+RWzJ/WvOPNS06yPilygz/iJr4YotDFr9zFKstKd22Cou7FTmeM4XqUAuYlqrBnLwnCxjlJgX5jTqPm3hUhBDvPEewfUJPQB5Z6YB6YeNp/C377R8NQ53wT4dhyjKvPV+DiqUel7pbZhFoZhsG4ksXRTZks7biaRxSf4F3kFIPyciMlbzESZOweWVNh5k/mgA7PLJFNClqiUfT/cyhFLv5+VDrbN7D5zb5p4N8mZSGh0X4S6FO2uOd0QE3mKTaMcHks9lGZ/7AEawcfy4rl9k2UVsXZc/04V9U6HZNdMdct3ZBZVPtn+8E+yiH31hjvES3OFofkXRCqciJMZfiOjuERj9+CZx5FCZe7iFj/5OJC81EkJg3VnshQhy1drLrBY+S0JbCimX61BcKVMlRGNJ3Yd32VUix4bcM/xp1TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 17:28, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 05:03:54PM +0200, David Hildenbrand wrote:
>> On 08.09.25 13:10, Lorenzo Stoakes wrote:
>>> The devdax driver does nothing special in its f_op->mmap hook, so
>>> straightforwardly update it to use the mmap_prepare hook instead.
>>>
>>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> ---
>>>    drivers/dax/device.c | 32 +++++++++++++++++++++-----------
>>>    1 file changed, 21 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>>> index 2bb40a6060af..c2181439f925 100644
>>> --- a/drivers/dax/device.c
>>> +++ b/drivers/dax/device.c
>>> @@ -13,8 +13,9 @@
>>>    #include "dax-private.h"
>>>    #include "bus.h"
>>> -static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>>> -		const char *func)
>>> +static int __check_vma(struct dev_dax *dev_dax, vm_flags_t vm_flags,
>>> +		       unsigned long start, unsigned long end, struct file *file,
>>> +		       const char *func)
>>
>> In general
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
> 
> Thanks!
> 
>>
>> The only thing that bugs me is __check_vma() that does not check a vma.
> 
> Ah yeah, you're right.
> 
>>
>> Maybe something along the lines of
>>
>> "check_vma_properties"
> 
> maybe check_vma_desc()?

Would also work, although it might imply that we are passing in a vma desc.

Well, you could let check_vma() construct a vma_desc and pass that to 
check_vma_desc() ...

-- 
Cheers

David / dhildenb


