Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C941FCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 19:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC8A8E0013; Wed,  5 Nov 2025 14:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD9F8E0002; Wed,  5 Nov 2025 14:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2EB8E0013; Wed,  5 Nov 2025 14:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFA58E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:56:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4FCA590DD
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:56:43 +0000 (UTC)
X-FDA: 84077611086.24.766EA87
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 32BFC20008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:56:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dF03gt7m;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762372601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfRdq0AOLjAvRpFgewWvnXKqu09Gq6WPLf3shQQBn6o=;
	b=Zboxf6l9BIZWxebgr43df8/WT9TVCupbLnW9ifU+lj93HPyggwDaYIggfaDcJKwsZ/3f6X
	4GRiWZNBIj/fkzykj2C/taIuQjSJ1pm2Y2a8GyqCFAp8dOjyM3hpHN1Avy2JkMJG9ybUA2
	GJPG4tvDtURQfQh8UdwW2Nj9tJ63LAY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dF03gt7m;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762372601; a=rsa-sha256;
	cv=none;
	b=AZIj5mDL1VRyLwtvjnfwUiiSJIpoBncu3P7Utspf3T+IpSaXyD7DLzaTekmZWSecNkyc5p
	EklPPqe/261FM6vXzqgSeGwqTabFE8DSeeyaNJk4rhLzFY8UHyXhvJWJXjcRctmjeNr6xc
	AKzx932vbiPu1TyVgHlaRCxtlX4z0aM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762372600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfRdq0AOLjAvRpFgewWvnXKqu09Gq6WPLf3shQQBn6o=;
	b=dF03gt7m4v2LFDVNmqva+6rkm0YhCFMPsx8wBni/J2D4U1RLdlMbX0NaRrTheAR+bgutxe
	+9nqWqBrNJ1kiXdQgeG6eWuhF91HF23ejjMU92gl0mfZw+WY21fiUgQBElhLBGssEzA6jQ
	D4o130VTH5JSUw32jVW2JPEkUpHiuRo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-fqRPsp2INVm2g78bDX8K9w-1; Wed, 05 Nov 2025 14:56:39 -0500
X-MC-Unique: fqRPsp2INVm2g78bDX8K9w-1
X-Mimecast-MFC-AGG-ID: fqRPsp2INVm2g78bDX8K9w_1762372598
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775e54a70aso1849945e9.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 11:56:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762372598; x=1762977398;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RfRdq0AOLjAvRpFgewWvnXKqu09Gq6WPLf3shQQBn6o=;
        b=YsGtrECG5zxrWS8YsBLS7rQk+4cKjnMWZUnfAb8E/k+rmp/6Gr3hod7ClXndPfhdCa
         2TuhjwH4BP/KcXArB9yyN2ur4JSggfaao/hF1JIolHUoZnHkF8pJPz+n7KvRpK1ytFa2
         DpkPCFQcJrc11Crl6dOGnB9WWhKjNC6RVSEU8xA8x5k2Ck+tJKitgkxpD5gMRk/0Qf5S
         yedHz+GYqYducD2TFzO50OsvxHdNsXqfo6e4GVkLXZaT9e9GTTWt1L2Wgtmq1N0Up6Za
         2p5C2m/l3fVfjGlCxCL/a9jESv1f+w3ncEO62q+olohqR/4S91bYb3U47MUzRBzDkYiG
         Zvjw==
X-Forwarded-Encrypted: i=1; AJvYcCWMk6OmoMDz+qPtwBr4qnT0gjbi27+19W/wQr7UVkcvHSDb+ZA8DFQnN9df+wNIqMcqfQ1IIlyUCQ==@kvack.org
X-Gm-Message-State: AOJu0YxUzwJo7FNvlbY2l7SrKj6Y5r5oBLtywLmePlDKh7N8/d9IvgjK
	1UC+Gfv5szfhfjOGHBoxkkhna2hMlxHr+YGHwIWpe9V+HrA0Npo4OecKMt/TaoqauFzudwiVUE4
	S8Tfhf1eVQyEVI2ZaeIhedezPQCOq1Qb1n+grvUlcNAske4/26ElO
X-Gm-Gg: ASbGncuUy3f6qJDflVKkTz1vNq0DCtnemFlbAYMfqheBohBPxmK25iL5E/o3bSho40y
	NePYnpErqkGRmiT0eVG30ZEeeICCUKqS6AdqTD1AoStTNJtI+Rrx4TSyLr5b2atkiLh5pQ470mz
	mRUimzbc2q0hpembBya22ohUPnsfok34S4F69cvDZ2G+s3H7SiTwZMzAWjEOL0dJ2e0hW2F3oRn
	FZQwmtjTKJJQL59wKRHypYPBnfbRS93ZCFXYBPietbnG2t8IcZSYgde82HoUYTdWVTFr9p7avwU
	FtvQR5fIMBshEytgqlzyOnq8HPcNaCNLR9580b/ppVuT1uXOVQ0lx7FwBheSse7s16TbZSU6XAV
	gfWDnOJGr7sLR6ubaEW9ULR2xOIIMi1mGlZADvmXLnsL0p7UeoKnl68X0XibtOwLlHGlzjAFNeG
	rbiDMxqKuvs8V0+d6Geje6VQ==
X-Received: by 2002:a05:600c:348f:b0:46f:b43a:aee1 with SMTP id 5b1f17b1804b1-4775ce2c7eemr29950565e9.38.1762372598061;
        Wed, 05 Nov 2025 11:56:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHK7yLH47QUN086LZNyuRAD2Zw/GPvRFlywAZeFx22RAaEduz3ojwl4v/Mo8ax5jk1OZayf5g==
X-Received: by 2002:a05:600c:348f:b0:46f:b43a:aee1 with SMTP id 5b1f17b1804b1-4775ce2c7eemr29949845e9.38.1762372597551;
        Wed, 05 Nov 2025 11:56:37 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775cdc33bdsm64219765e9.1.2025.11.05.11.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 11:56:36 -0800 (PST)
Message-ID: <c8f4e753-836d-4ca4-8a94-c54738b7db45@redhat.com>
Date: Wed, 5 Nov 2025 20:56:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQugI-F_Jig41FR9@casper.infradead.org>
 <aQukruJP6CyG7UNx@gourry-fedora-PF4VCD3F>
 <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VBXv3MrqWxoZqIm2J9_9-FkFE7w83Rbdtq-PRnsPkdE_1762372598
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32BFC20008
X-Stat-Signature: tk7hih6wu5su7rntbse9w3n6r4r6cstk
X-Rspam-User: 
X-HE-Tag: 1762372601-223132
X-HE-Meta: U2FsdGVkX1/QJ6rRbj3XgffKF0pI5gLqA5rGN3GNUbvEIJY8W8I4c3Vjbll7BUBdk0vvA8PcuGcsci+yo6bioeb7tU1ZdCSZ43/HvB6fedeyVLvE7D6jxP42k3Nk9fEYmaN58M9DC7D76ia7+AYFVm4MkaDJNI61ryQUaWf5E++R0eYRu+l2NJMF4vfNmIcdU/RQ6pTx+CUy0MGCrS/KSneCbky7ahEBFyKHnZ/9uaE5PGw+O8g3YIG9Wy1qA5JTtPURAQOkZLPxemWc9SZXaWenztbcoFFerj/sXMjH0As4R4hjh+up001N7w529jHs08fMi187qoYho5Ji4oPu3ozmFTvBtpOA+fqV7o1TatD2NtPCAzRxLriEUA439iBKhAjBuvf/qmXh7ALkKvfPLP4PJ0ZnZeHwHvwxdx0OLCghO9fWLqerVXJYcgmbf03lMei5+7L0ghUDuPi0Mepnn0kYS4bmuEmIWejfN5iDO/YXH/M+Ryu7y5+PGn+Fh5UuKTG45scPPR4HadUIw4vBr5VWa2Kld71dZoRhrlWbvh629gNY21RTJYU+WICPoW0bgb9UiZRenSzByKnHjlM3VwB3485O6xOznU7kH+oUEblxShSrgskRSReRmhDO72RGGl9WmVR/Qo8tJMpm7jwe54eHy2HuXHrCmsY1Hp8OSUiaUIP78tBMJHMzA0K80Th5MqbH3B+w+IyCmRZDXBwhE5HxMcvhSBKbQz2O0BAVZ+Bve2cyTzIREC1mDfb+D2hm5ZGHvj7/wDj187y73DQFb0Sy+DLzSN9SqUAV0z2nVHpRQFbHTFoQc0OjBY56UpWxwKD+3QsPXZyVuMmkRKQqtGzxfHz5Mu2NuaXYirkm2y/0C3x/8QuRXGvuTZlHU5x+Hi0O+O4zRCtxmVUV5Co/q/pP6iJMtu+h5DPDN5dq9xzbTYSQo4NmRwz4AQkOPTuI526Fmg6Etqwe3I7OX5X
 qaHa0DlD
 5QuX0QODXk/d8bLUKVhKlyYWsRcLHgEfDV8d3oIMcwH+zVJoOagxR5EnELcphJoM/cOVFtdb3PrlPp6rkqo9LgDLR0uH+SC+/AFN9zOFtuvhd9g0tOCfzyVA+zwI6TU9Z4a75YDdrpz15wVeMvlxXFIgscDqo9oXPoHWh4o7bZ4KZwxp1HRzEMgFGRCVO21YR56uFlbznNYwxFH8OwFtsULP/VUita6XC6IyqF+EwXHk3Ur4FkXqDnXt52JQDjb4s9EJtqirKeJYyNXPvpqciohvVTAy4xiqgow+2HX22jScYIgsqJHYcR5DGXJ87pbfMbGeGpQbxiNr7aWs07tkjfkNCeEKa4/ih09yuvy6RHpY//JCNONPKVQFHcDlHoIOalzFHWhXU46do7PQbg8brcbiNVf6n9Sg5j2OSybMOihuP/ju4Huyo7IffHgGRchpO4kdwpsCfFW+53/yTpUO/JCkEYWWLjKrKGMS6h2pSXfGxAEPXyI206X94TG0nEYLajRrQ2aaGIQ7gMihJxkdbhCZ4ttQZTah1f07sbFDOEWrWJEjfnBadueLpARs+KYlmaGSNGxX0YKczdH2we/SrU3iwXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 20:52, Lorenzo Stoakes wrote:
> On Wed, Nov 05, 2025 at 02:25:34PM -0500, Gregory Price wrote:
>> On Wed, Nov 05, 2025 at 07:06:11PM +0000, Matthew Wilcox wrote:
>>> On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
>>>> The kernel maintains leaf page table entries which contain either:
>>>>
>>>> - Nothing ('none' entries)
>>>> - Present entries (that is stuff the hardware can navigate without fault)
>>>> - Everything else that will cause a fault which the kernel handles
>>>
>>> The problem is that we're already using 'pmd leaf entries' to mean "this
>>> is a pointer to a PMD entry rather than a table of PTEs".
>>
>> Having not looked at the implications of this for leafent_t prototypes
>> ...
>> Can't this be solved by just adding a leafent type "Pointer" which
>> implies there's exactly one leaf-ent type which won't cause faults?
>>
>> is_present() => (table_ptr || leafent_ptr)
>> else():      => !leafent_ptr
>>
>> if is_none()
>> 	do the none-thing
>> if is_present()
>> 	if is_leafent(ent)  (== is_leafent_ptr)
>> 		do the pointer thing
>> 	else
>> 		do the table thing
>> else()
>> 	type = leafent_type(ent)
>> 	switch(type)
>> 		do the software things
>> 		can't be a present entry (see above)
>>
>>
>> A leaf is a leaf :shrug:
>>
>> ~Gregory
> 
> I thought about doing this but it doesn't really work as the type is
> _abstracted_ from the architecture-specific value, _and_ we use what is
> currently the swp_type field to identify what this is.
> 
> So we would lose the architecture-specific information that any 'hardware leaf'
> entry would require and not be able to reliably identify it without losing bits.
> 
> Trying to preserve the value _and_ correctly identify it as a present entry
> would be difficult.
> 
> And I _really_ didn't want to go on a deep dive through all the architectures to
> see if we could encode it differently to allow for this.
> 
> Rather I think it's better to differentiate between s/w + h/w leaf entries.

(Being rather silent because I'm busy with all kinds of other stuff)

I agree :)

As Willy said, something that spells out "sw leaf" would be nice.

-- 
Cheers

David


