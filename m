Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90187CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C188E001D; Mon,  6 Oct 2025 16:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBCE98E0002; Mon,  6 Oct 2025 16:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB0B8E001D; Mon,  6 Oct 2025 16:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA6338E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:02:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 551691399B1
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:02:55 +0000 (UTC)
X-FDA: 83968762710.19.05AC4BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC4E120013
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:02:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iFyPw8dq;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ag5HhpTmjFaI6QUuhgYEA6TF7C4ytr3Y0TrdHtcVfrs=;
	b=PT3CRPIxDzryrG71F/vSF0A0Jft2peANhT4opXMmHn60RZIR91SGdAxwMP5ym1JS9rYwRB
	gnIy2M5IP3PNLZr0Dbxq0u9JHbCbAGKAwSvEMnzKzenbYkXcbMtqJ0c5mD0WK+fTJCMGj9
	ZmvhsxAJGViD3qXRUs2PJ0t/55+U1XM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iFyPw8dq;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759780973; a=rsa-sha256;
	cv=none;
	b=FkWRubOgNay4ANS49vFUPmZENVHZtfpNH1aI1Xgdq03J5bXQfCbFA40BMKUVwMF4Kjx10V
	80aHk8y+fPS8XRP1Iy8PTGRnWjGg1WupohvV/j4e+urzfH3OoEy157k2KHKYzBCDGSBuP2
	/pBWKAsPoDCRuJ6me/xNzlDytAcVSuQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759780972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ag5HhpTmjFaI6QUuhgYEA6TF7C4ytr3Y0TrdHtcVfrs=;
	b=iFyPw8dqb/hAM1k6autqjpEQMu7mDzuDZlwK4oQDmEE15VyYB49vtNmQiFty0KdJsIdO1L
	n0FmCiUzl4NPNBoUP+XnbWb+VHHkCqvSRoyP2Wd6ZfatkLySxSqOgS/mdc4s2uEEBQ+/hZ
	UlcuHrLIDriJTCYP2RdAMne69Bjo+U8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-eW7fasQiP6OxEuW0Pwn19Q-1; Mon, 06 Oct 2025 16:02:49 -0400
X-MC-Unique: eW7fasQiP6OxEuW0Pwn19Q-1
X-Mimecast-MFC-AGG-ID: eW7fasQiP6OxEuW0Pwn19Q_1759780969
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e38957979so19961465e9.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759780968; x=1760385768;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ag5HhpTmjFaI6QUuhgYEA6TF7C4ytr3Y0TrdHtcVfrs=;
        b=qtnM+vaj6ul5NtIUPFrba2noU2yBfMYNyhxjZk2RwvZehHMNshMS4J5viaFLoZpbyv
         da9tLhpXnKrVIkc3TqOrFMtZg7IkpCB+3DRgufOJU5rP9FJaRqYprTyGwVXZ/q09SXHP
         Ejm7yVSl32INeda5S86Xa6SBMUqt1gw8TIAN/N8WGIJHmvY8aSQ9wLR2qyMw2FBRxAc+
         vyOIao00duyvfO2tPQsa4ZFyk2lB2PjUF7/NIJZ6rEi6sqa/V/0ZIhyBm/Acqeeas5R5
         nE+lSDLokOaABMkyajdY9QajgFu78kwY+XDzVqdf22GURop989YdlC3SUz1yWGrgquow
         tEzA==
X-Forwarded-Encrypted: i=1; AJvYcCURM6NTZWnExQIlpDCNHoe3B1ZdT6FsSytsMJfHVlInHzlBcHwQEOGlmdkWsto6FxoEGih1Dkc0Mw==@kvack.org
X-Gm-Message-State: AOJu0YySHBRyf6KIqfxTVeY32Ow2IzauGySqDGEQ9uQFoIeAQ53750+4
	WiPYBwN7nDG+HCP7yh09TQh1JiPaZ8kPGHeRUI46Aq/rswjSdkgugagg+S3AQlvSp3Z3jjdOYOY
	A8bNvNkTY3ZkhffwfCoI6OJ2ioT6LiiYolSzLGuHQtA7U0xR6ZjWb
X-Gm-Gg: ASbGncunGoHvW54nG6Wij1vgZqDDnSjCZ6of0OX0VEA83HbY2wwuLoRgOY45rEyaDQx
	rSAjCkhYQ2SYPJbm28/tFdv1ymle2m6NMe2wwjDxT82knFOIXFYmv8ZqpWMFntdppSn833F9Nka
	AeB8KQ4XpkDdm+0eHswlJ4jZ7hHCc48fzRLs5qcKeWEp/6HysF4DMvrBgwWt+nhVk2faVMXl/y2
	NqAZT7H5QsoR248LwP0wWn8BQGq5JHviOxdSCGHWu6pv5c+EkOXGtlMH2FPgTv32hTdCa9s9LQL
	ONRjK7GTebc4GNRlekUdatovJom0YZuWzSJefMcB/L9v02Z706lPYMoucFG++w4lUJEuFxQ/P7H
	D56TzVz3N
X-Received: by 2002:a05:600c:1e20:b0:46e:34f9:993 with SMTP id 5b1f17b1804b1-46e71109f6dmr81290475e9.13.1759780968513;
        Mon, 06 Oct 2025 13:02:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfqVzUsNEtEuxV9G5W32oIUbsGdCmBqBjXejarAXf6wmoMFqzmlXgYh1t5QcWE4BSfSmAWlg==
X-Received: by 2002:a05:600c:1e20:b0:46e:34f9:993 with SMTP id 5b1f17b1804b1-46e71109f6dmr81290225e9.13.1759780968063;
        Mon, 06 Oct 2025 13:02:48 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e78c5d290sm132046845e9.0.2025.10.06.13.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 13:02:47 -0700 (PDT)
Message-ID: <ae42bf24-e516-46b2-9c67-95df5baffa86@redhat.com>
Date: Mon, 6 Oct 2025 22:02:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Peter Xu <peterx@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>,
 Dan Williams <dan.j.williams@intel.com>, Alistair Popple
 <apopple@nvidia.com>, akpm@linux-foundation.org, linux-mm@kvack.org,
 kaleshsingh@google.com, ngeoffray@google.com, jannh@google.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
References: <20250918055135.2881413-2-lokeshgidra@google.com>
 <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
 <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
 <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
 <4909d194-58b7-4e94-b730-f916100238d3@redhat.com> <aOBWF8uLmm9iQ2XG@x1.local>
 <872c98fa-56d8-45cc-a7d2-1b8d44614640@redhat.com> <aOQdVILmD-4Odjs5@x1.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOQdVILmD-4Odjs5@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p7C9FPaxbUfygf9TSFwMotSNViRpnBdpsy8XiHGnG_8_1759780969
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iiszkmi6fqc7xezncaoqou9bdono3ci6
X-Rspamd-Queue-Id: EC4E120013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759780972-326855
X-HE-Meta: U2FsdGVkX1+YiVf3O6d302EJhkmorUlVZOnxqCocbdpa8VOazTWZksU4HjSNWRuoewbEgM/mQdLbdmZLpsOWpgZy65DJGS8t6FCkoNZ01S+gkebWxcy3unjoYSSDEbD07SG84hcA11A9kAFAr+4U7Wz/MjDIFCPCLbUaa+PKInZ8KeLVLQG2JZMWv+GUzQTCmhPYKWKkOVyIBmd+a+ECRTwPyfP5O65+/XwHrpEeFVMumC6gn8d6xImvljiV26erTc1FyrWsAHlBYNOElxppZMJVT7uhhG93+mapOodlqZ+kUWqyx/zwnkQCadoU9hB78oLthuFwPD8E9z3U9JgOaSoa7+CT5/o/2Vv6HHe4tLux1Hm6b+XZa30Su2HiaROo3ZRqnVye9Tqp7tUC5AP10JXXZ7PFUpk/3cpDix+CuYeL/ZSf7R/RcEOozyQNl5Z+JDBuYUxV+0Eyz5dUkrJ4TzeuS83T099lCRJjlxdIX4aUp2zOWA7RCTGRnJOtVug/rCF4hyZd2n2Cb+zVEPmO/LouldEwQvu8eiNF6yEdGcKrbjc+FInAlZuCG1WzZpSAoWZ0D2SdZrduyADfS7EMdLyHM3CR2Y19dQPDM3TYgH9ezvgEm72m1dhQkLRpHLTkJJ2B64/WwTWVt/1xDOxExQ/ly5g9dXU+9nuTS3iov+S/yZCZ7aTECPAmF6YclsdyAFUNqUqIeNUZxXN/6SRxaj0jemrzhej+A7R3UmB71Q5Gj/tSoB1kN+oimCRuw1uxPGdSq4PRs8beQvRR06FQqWfXBDqBFQ+Ye3HpzIamV/GuVZu46ev0RtMyLsJzO78IL67a76xcMJZ/4/FclyyWdw7VD19FFbrnCKLDqKBzWc1DFoDwLY1B2V76/F51ukRHtmEV7o+mkCUT/+H/GawRDik3Zzq4uYsNg0wX3qMZOZLvqS3mgyii2q8jfJWumIaOaHV5r+4nHGNyAas6pk9
 jOipTITZ
 NqZan9pE0dIGbsX4RCwa8snT1NVbqueL4UgEkz681J8Eqt75hME5meByKekg0ozHVM87eqPpEP5i5y9Z3ejwYzk9sDKznS5BkAg7JaQtec84A8zFUa+A84Pkn3RlBmfP1Zw3+rjf/cqwUh0C39MgDUeogyh0nXOvpKEX65DB4nEVcukCcuJH89K5Bn7e9xlJk1zMMnk/7kCRyi+uaOngv8TVTxrvZRaLaKVPew3l7R0dM6bm065di48gC+J/dLszVvrQRzJZCqJ7vPs4FcaFfrIKu8K5l3NnVmpCp03kr0WLjftqtdin+VcMuCp2PwKgerr6cI+hyniKiDOUyV8TQKEbhfg2rubWZl3MC8++ScIkCeV5A8sF+QGEgY/upjKFzAB8SGUj8Ek0ktTE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.10.25 21:49, Peter Xu wrote:
> On Mon, Oct 06, 2025 at 08:43:17AM +0200, David Hildenbrand wrote:
>> On 04.10.25 01:02, Peter Xu wrote:
>>> On Thu, Oct 02, 2025 at 09:22:45AM +0200, David Hildenbrand wrote:
>>>> Staring at mf_generic_kill_procs() once again, we have this
>>>>
>>>> switch (pgmap->type) {
>>>> case MEMORY_DEVICE_PRIVATE:
>>>> case MEMORY_DEVICE_COHERENT:
>>>> 	rc = -ENXIO;
>>>> 	goto unlock;
>>>> ...
>>>> }
>>>>
>>>> IIRC, all anon device folios are MEMORY_DEVICE_PRIVATE, so we should
>>>> actually not succeed in this function and just abort.
>>>
>>> The doc says:
>>>
>>>    * MEMORY_DEVICE_PRIVATE:
>>>    * Device memory that is not directly addressable by the CPU: CPU can neither
>>>    * read nor write private memory. In this case, we do still have struct pages
>>>    * backing the device memory. Doing so simplifies the implementation, but it is
>>>    * important to remember that there are certain points at which the struct page
>>>    * must be treated as an opaque object, rather than a "normal" struct page.
>>>
>>> It does not intepret to anon private memories, but something that the cpu
>>> cannot access..
>>
>> I would not trust the docs that much ;)
>>
>> We establish device-private folios when a driver requests to migrate an
>> ordinary (non-zone-device) anonymous folio to device-private memory (e.g.,
>> due to a device page fault).
>>
>> When the CPU re-accesses that memory, we spot a device-private entry and
>> trigger migration back from device-private memory to ordinary
>> (CPU-accessible) RAM.
>>
>> The latter is triggered in do_swap_page() where we handle
>> is_device_private_entry() to call pgmap->ops->migrate_to_ram(vmf);
>>
>> For migration and everything around that to work, obviously the
>> device-private page also must be anonymous.
>>
>> It'a s bit more obvious in copy_nonpresent_pte() where we call
>> folio_try_dup_anon_rmap_pte() for is_device_private_entry(), because these
>> are just anonymous folios.
> 
> Ah, I actually didn't expect folio_test_anon() will return true for the
> ZONE_DEVICE folios that replaced a previously private anon folios..
> 
> To me, that was only some housekeeping for the ZONE_DEVICE folios
> remembering the mapping/index/... somewhere, so that when they got migrated
> back to private anon we know how to recover these things.  It doesn't mean
> it's a "real" anon private?

Just like other anonymous folios we can walk the rmap to unmap/migrate 
them. And just like anonymous folios, they are not added to a page cache.

COW-sharing etc. works the very same way for them.

So I think they are really just anonymous folios representing a chunk of 
device memory that is not addressable by the CPU. Apart from that, 
nothing should be too special about them (well, except the way they are 
mapped into page tables of course).

> After all, it's a ZONE_DEVICE folio, and the
> memmap does not 1:1 maps to some RAM backends.
> 
> But I confess I'm not familiar with these.  Fortunately, I think either way
> it doesn't seem to affect the design of the series being reviewed.

Yes.

-- 
Cheers

David / dhildenb


