Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E32CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5301D8E000B; Mon,  8 Sep 2025 13:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507F48E0001; Mon,  8 Sep 2025 13:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6D38E000B; Mon,  8 Sep 2025 13:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDDE8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:39:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3334B7132
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:39:08 +0000 (UTC)
X-FDA: 83866793976.27.6ABE307
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9970B40006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:39:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I91mp6bA;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757353146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3P5EwsaOJG0kp/tyGnSgePetI5hCYz4arKjA4KqYxlA=;
	b=39ij7gVqEOVJ5ayBg/xL1BxOLKpU1axHz0mgFzqFgqunq93i4huSDgjJnuQEDR+1XlIB8F
	YElt4Ke6U/j110T91aV+c6XFsuLYq9fWv2DnDV+UZwm/PL5tDPmE1wrKo075FSokfmo8ov
	KqsSghCmf60IybRiS5QpWIQMkeshQI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757353146; a=rsa-sha256;
	cv=none;
	b=ke994A5/3UryfE/EcaoGPBzvt27EQb8/2RActmxIlGtJVSK4lnNnn3e33opfwXnAvxrxCs
	JFQvdjK4uEUU1xcG/gGDSboNWNmfLTHySQo1DxN+JeUfIdo593G9Y2GjeBfeaoCbVicR66
	hoGuDMh8+1N+zvEPtPw4UC3lkARAViM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I91mp6bA;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757353146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3P5EwsaOJG0kp/tyGnSgePetI5hCYz4arKjA4KqYxlA=;
	b=I91mp6bAP9LOpHzuFlMHo42y36JbDueNXzp6q12Y9GqGLu6oaiMK+Xz9nyVjZxmAf+9MTd
	WvqbrnAD+jC7uP6bwNShdJvepez0t5W6BWRBMwLaqHkKdUya8rOMkMU6z0NdK4PFkQtuJu
	MlcMSW4GSnUA/Mrt9lD/o7ScXuoMJQ8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-lWr1GZG_NRmPo9vUzOLdyw-1; Mon, 08 Sep 2025 13:39:03 -0400
X-MC-Unique: lWr1GZG_NRmPo9vUzOLdyw-1
X-Mimecast-MFC-AGG-ID: lWr1GZG_NRmPo9vUzOLdyw_1757353143
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so36682225e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 10:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757353142; x=1757957942;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3P5EwsaOJG0kp/tyGnSgePetI5hCYz4arKjA4KqYxlA=;
        b=uLO4fqW3Saua2qFpbCoHQoH9uVfO03Zs7mCzZOvKb70ZGCz8Gh4WuxihI80a7Pd3ON
         HiHNO80k1tNnKuUfZV2v2i5F0w2+3Z8cyy6PD9TJDbOodidC/sBZv8ZrcM3lMhT2fyRV
         1N3jd0YRm90Cn4x6YlqhMs9jZpTq1rwfo7ZPMW8vnwF9tDerR6pDxMZPzg2S6NRwyxjr
         /sfQaW1Rg8i1zAaMuuw26ivkxlSY52UjFDylFlJnmR1ShJ8sCPq1AlDGMOLMgDrj4sb0
         Qb9Vkqp13MblGdik6VNN3a9GNMUh/x/ca5Yy1zdTP77c6ALK/3CnaZJ08e9mjhEcH3g6
         MpzA==
X-Forwarded-Encrypted: i=1; AJvYcCUplvHJYpRiGayGRsCmGB5FfNIosA01GIn48UMDrwy3UGaRFf9+gzLlFqZ1abFwRpcjVK5Ns3pf2w==@kvack.org
X-Gm-Message-State: AOJu0Yy2vTyhTYxI0DjDE34/WC91GZMGUg8Unpeoi02D6VTZLJ0CbQr1
	AJ/9ziI8QZAh0FD2GsS32aMpu/TLfE+rbmcpYHPMFpDDVisVTnCp8XZfPlpOI8UOfbSDGKcCgOW
	j5wKE7ZxV2zyI9AUT56gQfnvE+fkWRPTS+YKOrAdvno1R+Znrt6WV
X-Gm-Gg: ASbGnct10Pp3PXmgSxmuJnNhh0lvLJep0+1sxc6ed/G4G2V0FYMdB2Dlw0TVFDGMNU2
	3Wav1EbNupwuZiqisGm8EI7lDSyN9xOJUeCzZhbL3+SGg0bkcDibi7FUpZ0JFEEdpcQOiWiK23l
	ffm5YSrRbXQ2wOHbGdonMqpTMEuyz7F0P2zeV+CkXHlNo7zI2tqws9Qk5A5S9d8rCBJIHs3j+l/
	dd2ti96Z35gMkN2vKqSDo6bFl8dNxb2OCQ0giKvWjGDx1dTokgddQXXHkKlTpW+sxDHOa+dTP7R
	tRt1SVnSiRnq8TKRB+Ut0JUe4AArBQffaGnXDM3WVyJRnedINTLIJGRgseARP3w/vaBrZl4r9Pu
	XXHMRnGVlkebq9Lo8NQi9yPuTOb5IizDZ5J+gQmjfpa9YZFFshbNtaec1zMvPHxZL
X-Received: by 2002:a05:600c:1c9f:b0:459:d3d0:650e with SMTP id 5b1f17b1804b1-45de870ac82mr30366095e9.13.1757353142554;
        Mon, 08 Sep 2025 10:39:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHt8ktxg4j7+rHzwwJQeZDohdWogsGJakCqu7C8BDn8f2aNE74iKc5paKrXN3SjMzlRF+4VLA==
X-Received: by 2002:a05:600c:1c9f:b0:459:d3d0:650e with SMTP id 5b1f17b1804b1-45de870ac82mr30365735e9.13.1757353142034;
        Mon, 08 Sep 2025 10:39:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e92a42asm450957385e9.20.2025.09.08.10.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 10:39:01 -0700 (PDT)
Message-ID: <225a3143-93de-4968-bfc5-6794c70f3f82@redhat.com>
Date: Mon, 8 Sep 2025 19:38:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/16] mm/vma: rename mmap internal functions to avoid
 confusion
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
 <626763f17440bd69a70391b2676e5719c4c6e35f.1757329751.git.lorenzo.stoakes@oracle.com>
 <07ea2397-bec1-4420-8ee2-b1ca2d7c30e5@redhat.com>
 <a8fe7ef8-07e5-45af-b930-ce5deda226d9@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <a8fe7ef8-07e5-45af-b930-ce5deda226d9@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mor1nq7hgAC1pKAX02ZrialRAp6DK80Wwj-8QS1hw_Q_1757353143
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9970B40006
X-Stat-Signature: js6tzf3kjieor4oi1nn49njajwo3i5uh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757353146-293542
X-HE-Meta: U2FsdGVkX1/kKz5rnvSAlxMx6M/jOJ2PRSdZudamoKvZ/fHGhLen+fpliElvSBpwdVn8vwrF3amhkUSYfu8DiZXOQvkBudk6CJx0ibFBYc8gHvKKGVuYQKUwBDDC3yiIkdHkqFLB61fGeyS1fcOKvbWwXVlUAvRaIbrbvCBhjnUAGBIttJ8rb7dajGdRLfjn52bWWFx++EgEUttshAu0Cklp2pKBcYevg2Sl9Nvdx7TBt3VMRNYw+MIxqeE9kR3wgDtIgeUGrKqmuvYFSBJgx3KbyVUGgSOZn5U5grGZyWfH3w/DDjNc3Ca1akKIRTTfboCN1M3Td2ilXnkCB28Z90KDAGx38FGHYi4GLVxKRp/mFWG5M0xjQXIBtLil/j9IPGX8ISczt154wG9XiAOSRCDZRJo2hdZ+BWian9gIsuLgI5IBsVrl1F+P6vdty/5ogjiqo+GvIi9DA/2XfENFrE2FCakPyZjYsviLmFnma9qhOEByDRxeLOQkqT4H+CfVNctg9HHww43vPt+IhrAhrnN4Xzv3y/W1g2+OnRnYRT+lEkTMgzBew2Q/1Yxy8O9h3X9YaAB4ERG8oSTmAx25Twtp4mjM1H+DYRnW6NHqHjdF8ln+NL7u3NS4+D7OgW7omk8R0xNQGtGJUH1sAtWBIPN+azLd3YRyx5NHgtZxGBevquhUvdzTaddvmdgdh7v8U2pYP+4bHLM2lxfDHn3/dblPLTnAyjcH43hUjiZ819By33C736x0nT7+UgI866j8R6YuYSZseaiaDCb6Wg8KZHrixoK0fzAw6KxPPRgOZFsit0qRhIp7xviwmKer4z0llpB/WL/MeMv/ajysfaXAr2dePy3lSfPo9wzfvmig3pC4kXer1UanqOjZSlZFP/edUonmjbtnXgDB41/uo8BB5H0ygPHKDjmc/aIsqc4cQRUEJCyM/9ewqEtvCpm/4ihhlIFgm9X4KNN+yGqhpdf
 k9hGcDjq
 QzoptIotVRHojCOFYuQBgkV0aPrLFJgcROrckd08Di0h5dBuz3qyR/1Kp8IhKDuHeQLatsQhgo2UDdvc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 17:31, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 05:19:18PM +0200, David Hildenbrand wrote:
>> On 08.09.25 13:10, Lorenzo Stoakes wrote:
>>> Now we have the f_op->mmap_prepare() hook, having a static function called
>>> __mmap_prepare() that has nothing to do with it is confusing, so rename the
>>> function.
>>>
>>> Additionally rename __mmap_complete() to __mmap_epilogue(), as we intend to
>>> provide a f_op->mmap_complete() callback.
>>
>> Isn't prologue the opposite of epilogue? :)
> 
> :) well indeed, the prologue comes _first_ and epilogue comes _last_. So we
> rename the bit that comes first
> 
>>
>> I guess I would just have done a
>>
>> __mmap_prepare -> __mmap_setup()
> 
> Sure will rename to __mmap_setup().
> 
>>
>> and left the __mmap_complete() as is.
> 
> But we are adding a 'mmap_complete' hook :)'
> 
> I can think of another sensible name here then if I'm being too abstract here...
> 
> __mmap_finish() or something.

LGTM. I guess it would all be clearer if we could just describe less 
abstract what is happening. But that would likely imply a bigger rework. 
So setup/finish sounds good.

-- 
Cheers

David / dhildenb


