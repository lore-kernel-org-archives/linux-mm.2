Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DF1C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2A66B007B; Fri,  8 Aug 2025 08:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AAD6B008A; Fri,  8 Aug 2025 08:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A02C6B008C; Fri,  8 Aug 2025 08:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2986B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:04:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A99EB639D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:04:17 +0000 (UTC)
X-FDA: 83753457354.11.1870645
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F6AD1C0015
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:04:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bekLsMhc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754654654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zwu6G7Ii5QU8d8/PJEe2bFkrnM3wNVgvTkgXDIIA24U=;
	b=l85uuySciYLxRKnQmx5Qx8hAn2hQuJZKHid53cggpS+GovsRvywsd5jtxy1zFjLtm+/XFJ
	CxILeoddHdF1VVjzk1qaTmSiDt2lsAxzCzNc+d2R/063m72BSt+TR99zzU0pWh5IQa6f89
	U88ssAVyLjbBQlpDl0GBIaEwsLEqUi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754654654; a=rsa-sha256;
	cv=none;
	b=BUGoyoYwT5sBT4ARIOqCLnxlJ6AU3gCbqdBU0i4o/E8nJ3oNewEJ3UJ3Gu+X76Q2xQYgrw
	14Lc1+QSf7q4k6+rYJ05i5Y4kv7XaQ4Zb7x/ompRwC1UVYAl028rh8HN9BWqFteP9C4Reo
	nravtvSkGShsqp+vt/wZcvJ+aJfrjI8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bekLsMhc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754654653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zwu6G7Ii5QU8d8/PJEe2bFkrnM3wNVgvTkgXDIIA24U=;
	b=bekLsMhcEvIu4aW7eV93m8uzPjpjX2hwxGN4rk24SZYdfDimiAZtDDn2RlppqLfQtYwNwN
	Zs2un8tiJgiApbsgyh6wZoazrkVVjUtNCvOsxjPU+HL0/pfhbz0ZE71lwkOHDT3MobKoEy
	or1SxoPFrHUSjVrBxkytfMOOeXK8Ock=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-6m9kaiZrN8qPaXxLO2AQaA-1; Fri, 08 Aug 2025 08:04:12 -0400
X-MC-Unique: 6m9kaiZrN8qPaXxLO2AQaA-1
X-Mimecast-MFC-AGG-ID: 6m9kaiZrN8qPaXxLO2AQaA_1754654651
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b78b88ecfeso1114564f8f.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 05:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754654651; x=1755259451;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zwu6G7Ii5QU8d8/PJEe2bFkrnM3wNVgvTkgXDIIA24U=;
        b=s5vYjRAofnBW5jnZkaiSORukIy2llMn65T1HdLiitJ4dsIBwTZPZPJmmLkP2TSAVMT
         s9mF5pW6LwMY6BsUqXAImvy78jPzXlSfL3W83VUviMFNK87qNBE+Gw4BvJocbLamsc9K
         Vo7+a5LX0Idxy8yOyel7kIzSYQA0cis32T6S/Euta+RoeYgUHPIDxSCh2fYsxV8hEa0A
         /9CVvTMGQW/GkgJplrB3fCvndH3nxttkMabJorVEXTyNAoApgUQJhjfKp/C6y88DhIHB
         3Mr4V33+EVD/ZloRMTtEMzjcBNX6B1HOXasws0gb+PDrfeWmiLHg0qewDcBoxGdhtdhq
         UCjg==
X-Gm-Message-State: AOJu0YyHQR5LOpDVJNMoFRVbjeJNuJh7pHR7oD+Whk4Y5WYKPs37QD3x
	DQgLROR0M5/1iCEckq/75bgW6EpN6s+hYaZClO14x5nY0AthPCHbFdqTL3tl1odLnUFbALd4y86
	8GgxXEdTAdSpZL+KwLSnn8H/rfaGYjl9RVNj7Oic3qSGbXOmp4nNc
X-Gm-Gg: ASbGncsQgtWh1EAKjemohMSMxmQhTaSzg5C5JV3igHRwvypH/2rYhLn4JyfjLptRc9X
	QPWfKVFDbjy8xvop0F3wIBv8+wrv9C/g/4qBsr9LeqRo8MHSyqN14Ex6frlWwZmENjcRPNKlpLX
	p/fMs93RsmUKtCsl6yyswovVOFWz3rl2AJmZdKoPM+Qa8y3B827P3sKJVdwvaZNmxXJsdZhc74L
	1wZ95f7HrjWJ9pCBigCpbyOR131Zs+BTvrc6hFblvdjubQLNMsE+lpfe/jem5VzVYPNXUhd13JA
	npxK0KnNFBCK5694BJPBp/UKHDThR8XilID+o8SXbc4QY9MxBJsKC8qMrVf6eANTVJm+7/9nZ60
	mVlDvIh6QNP9c0F+4caNY/T/o46NThZUQyA4JNNJSnTMZQj+uA3KzIFsTu892MPbK
X-Received: by 2002:a5d:584c:0:b0:3ab:27f9:e51 with SMTP id ffacd0b85a97d-3b900b7372dmr2231286f8f.31.1754654651296;
        Fri, 08 Aug 2025 05:04:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqRYrS+0vMhQvwrqWQ1DB5e6E6G0Sh4yj3+7JQX/SujKga6eU3I3HwTB9e6wBtYZ/R8Wh/Ng==
X-Received: by 2002:a5d:584c:0:b0:3ab:27f9:e51 with SMTP id ffacd0b85a97d-3b900b7372dmr2231236f8f.31.1754654650483;
        Fri, 08 Aug 2025 05:04:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f5ca8ab7sm9095974f8f.59.2025.08.08.05.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 05:04:10 -0700 (PDT)
Message-ID: <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
Date: Fri, 8 Aug 2025 14:04:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
From: David Hildenbrand <david@redhat.com>
To: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
 <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4_a3fs_QAAcddZ9HsHa5E36UaDRVfzT4Ow6_A2kVzJQ_1754654651
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6F6AD1C0015
X-Stat-Signature: r9bett8dp38c6941qtjozwp78x6gnbnw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754654654-990837
X-HE-Meta: U2FsdGVkX18QQZ5dSGFvMBNXAlZLZuRWMuraawdlpdcomxxOOte3LB1UIR289J39bbtuTL5haSAXJWwRym37PI8aBPKgEwxZ31W40hO3yHBBVkR0MjWzoQpvyfukUtsBIk0BpojvL25aBI/Fo7U8J0+cH9GmXdaG8hg1b/5vZ5bycom3BmKnSx0eN9gb0x54xDiRYOUTpnwvPTj7i8maoD22knA1hwTTM8o3qKd34DrzYs0QGKMekmK1P623T609Q9V6P9Eu2WH2Bd6mJHvANZ9zJEF1Vz7C+8vVpLSNfMCdPxeB8X2KlUd9cQsJ3KVwtqODYG0I5K+Pyzw0/07qywOWl8ckPoqLswnLCgRjv+70RG1DkEyf9Bz2FcRTDDPEUqKtvnyytVFx7dJpcSDcknxMWqP6ZvVEVHvxNMNyewGo7DDW/kKtK1ib0LGAekKmMtGptRjXA0seQITCarxaPjYI6993brJelALellcM0krRM/iVUPr5pJ+WhazY/J2eShRrrz/Y+bASS9UpQ6S7/2ScaNlZvGrtO4nrg5JaZLom3QKmBScsajbSbTww50r21KBI+fh839NH2pTf2mYx+4kSTorXP7v78my1yT29Er5cqpPm6sB40nehfChGhnEdDk5Crc2dR6hovBoCgB40LgpP3eoNroRgpriarwwd7A1MQaHzySt72DMgWbuGKJrAWbGkgGc5rX+tgGFzMOKdcyYFBSw/HxcMnBM+42q5KDoSAC6hJM8FurAPRGNl6744+EL+rf+uMVSjXFyTRmPozfOToOw8yIViP3qR0Q29rZYEt8I84cgQD3wNnaKI2Mr8Tq6NXG9FXU0Dif7DpJOuSfirHaStC1gAJC7A/sux8xB0GoZz8HK47v2zPqrtGEGCaS6esVpWjn7LgN6CzBG0Sv7obWvbZ0hutcez5e3x/TpyV8ZioGVvvbcn9DIuSTY8uVNRmOoiwgBLJqcs9CQ
 D+FJqSDu
 NzPVVd/Ih/nyUH7WpSqfkmU5QDOHhME2TuNwxtDKcjm75bmfCz4VXDX7DK1rqbAmqkJtmxFKbdtFAZWsoAnXh7mail4q5i9/qopkp8PenKrzqn0yT9TvOpqEG29reNYNvCXxEEmvfqlALK17Aa7O7xE3wj24cO0JngRy0IaI3lamUxOCxv3jDB6Scva4MsQNXhCKFi1ZP7eN/RUs377D+c6F22cPL8RD6cnVMX4jbGHzkWFt04LP0QO2sJCwxBuIcgLiEP1vVLfwMKt3yQ8uwLtSN9pf//d7xaO60B4BxL3LboTf2tloarj4CaF/xhOhsaLLvbZ/+Qd9ujPiBLZuRy4PUgIdkJC8ifYKlvpqFAl/J29LU2Zm54AbPuLIqZi5PeM0he1WPdOKap4sxsA/07SEewCfpdB3c/QRrt3K977haQZAvTQEbSYU1FzRvVFwlcODbTyASIroRTkAbd1N3QVTc3c71886lnC+P0mx09wtim4gX0f3Fc26s7XDSSOAcoXsDoarPVERBnfM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.08.25 14:01, David Hildenbrand wrote:
> On 08.08.25 11:21, Charan Teja Kalla wrote:
>> It is possible to hit a zero entry while traversing the vmas in
>> unuse_mm(), called from the swapoff path. Not checking the zero entry
>> can result into operating on it as vma which leads into oops.
>>
>> The issue is manifested from the below race between the fork() on a
>> process and swapoff:
>> fork(dup_mmap())			swapoff(unuse_mm)
>> ---------------                         -----------------
>> 1) Identical mtree is built using
>>      __mt_dup().
>>
>> 2) copy_pte_range()-->
>> 	copy_nonpresent_pte():
>>          The dst mm is added into the
>>       mmlist to be visible to the
>>       swapoff operation.
>>
>> 3) Fatal signal is sent to the parent
>> process(which is the current during the
>> fork) thus skip the duplication of the
>> vmas and mark the vma range with
>> XA_ZERO_ENTRY as a marker for this process
>> that helps during exit_mmap().
>>
>> 				     4) swapoff is tried on the
>> 					'mm' added to the 'mmlist' as
>> 					part of the 2.
>>
>> 				     5) unuse_mm(), that iterates
>> 					through the vma's of this 'mm'
>> 					will hit the non-NULL zero entry
>> 					and operating on this zero entry
>> 					as a vma is resulting into the
>> 					oops.
>>
> 
> That looks like something Liam or Lorenzo could help with reviewing.
> I suspect a proper fix would be around not exposing this
> partially-valid tree to others when droping the mmap lock ...
> 
> While we dup the mm, the new process MM is write-locked -- see
> dup_mmap() -- and unuse_mm() will read-lock the mmap_lock. So
> in that period everything is fine.
> 
> I guess the culprit is in dup_mmap() when we do on error:
> 
> 	} else {
> 
> 		/*
> 		 * The entire maple tree has already been duplicated. If the
> 		 * mmap duplication fails, mark the failure point with
> 		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
> 		 * stop releasing VMAs that have not been duplicated after this
> 		 * point.
> 		 */
> 		if (mpnt) {
> 			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
> 			mas_store(&vmi.mas, XA_ZERO_ENTRY);
> 			/* Avoid OOM iterating a broken tree */
> 			set_bit(MMF_OOM_SKIP, &mm->flags);
> 		}
> 		/*
> 		 * The mm_struct is going to exit, but the locks will be dropped
> 		 * first.  Set the mm_struct as unstable is advisable as it is
> 		 * not fully initialised.
> 		 */
> 		set_bit(MMF_UNSTABLE, &mm->flags);
> 	}
> 
> Shouldn't we just remove anything from the tree here that was not copied
> immediately?

Another fix would be to just check MMF_UNSTABLE in unuse_mm(). But 
having these MMF_UNSTABLE checks all over the place feels a bit like 
whack-a-mole.

Is there anything preventing us from just leaving a proper tree that 
reflects reality in place before we drop the write lock?

-- 
Cheers,

David / dhildenb


