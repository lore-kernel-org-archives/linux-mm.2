Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB67CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304B68E0012; Fri, 12 Sep 2025 05:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5C48E0001; Fri, 12 Sep 2025 05:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBE38E0012; Fri, 12 Sep 2025 05:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0398E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:03:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EB6CC077B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:03:58 +0000 (UTC)
X-FDA: 83880010956.10.3691C7F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D0731C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:03:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F5WEZ/lN";
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757667835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAzJ+mvG4bNBmSnuuuVy1mkcgVkmygo72D3NWf+1s3A=;
	b=gpGKaX7R/Urhl+4C3JN9g2bBAv7rzIqifAGZRMwW4Agyp+J+nUebJHsiU9m263+PFY/acK
	FIdGg0tpF1qLV0GKnrZbk/V+4Bc31YkQXI7NeABgDnHmQ/0opHAB/YcTLBBEDBRTuNORus
	/oytSxi0U52HOEZjbdrFlFsQJNqIvHI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F5WEZ/lN";
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757667835; a=rsa-sha256;
	cv=none;
	b=2we8r5zk3Vu8/tv8wKkLnwThh/rdCVz0htS9nnxTLHNZVve6vl0btBVkxpnxxA0dTNp5oM
	ogdOHH1ppm8mGzHXLPJotuOwXpyb1Z8iRM8hlmb77pJ4HgFwpxxCGtaZ6aSlCd0Ui8zQj/
	x1TVqAtNmy09zbErGPu0cYAUvHK6UM0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757667835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GAzJ+mvG4bNBmSnuuuVy1mkcgVkmygo72D3NWf+1s3A=;
	b=F5WEZ/lNFfML4oU6UBq8cjM2Xo1WneWe21YGH78fX2dscdcgAE+fX0q1zTVgLcawP40klI
	vh5FxwaKBykHlR5Q9qYZRMso6jAX6uurzIOl8x3IoyFPo6ieEC+ocLn88oIfwNwqk3Zky+
	sdJxN5jw9ZWmbDN5lKYrcb50iqgepGM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-dg7iapo7N0-BS4q15CiyYQ-1; Fri, 12 Sep 2025 05:03:49 -0400
X-MC-Unique: dg7iapo7N0-BS4q15CiyYQ-1
X-Mimecast-MFC-AGG-ID: dg7iapo7N0-BS4q15CiyYQ_1757667829
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45dd9a66cfbso14343605e9.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757667828; x=1758272628;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GAzJ+mvG4bNBmSnuuuVy1mkcgVkmygo72D3NWf+1s3A=;
        b=JmkipNQesOC2rmVC0zyEV65ydjcT5yFX6jWRvL2XbAZj/4j+H1WiSKo4bh0+ZbUrQm
         cldQHR4OGdkUQVck7+RX0vxVasiB5zI6xIlfvWULKmRYcex2DKaFrdcKdQD+GWchScbc
         SkOB1EcMTQk52GntMrnE9vjVYeSsW3F+TWfU9JaYtBCrCqoMFbEFVbGPYjYWlv9yD5u7
         Y6fm3YYau85WHG0v2J00MFwtkTQAB0hZAs/OPOINXYZPAcR12wZHQPkKKcvRYO/PMGbw
         Z7QnuVgfZuxZ1HJ58xY0I2KCsSj62JOU6V70Kre9AflxZEXm+w1JhL0XVZi0Mx5Vah/s
         SfAw==
X-Forwarded-Encrypted: i=1; AJvYcCUB+88nTvGyBmOTk+v2uNK+I3qnLJFPX95aUPIdWJAPJYDyHNff6IF7kOzz8Q2L9xDYw2irI7faeA==@kvack.org
X-Gm-Message-State: AOJu0Yw8cNYXDuJzSWxApFKmOP9QO4bxVzLthZLUuQmRcy/SiC1P5/ih
	gidUScCrruDArGMKKAyUY/BpyCsvi2PLsoaXq5WlC4lYp5KCEncZ6f40nq1Mp/taYaclChhYiVd
	D9jPunV3Zc1Tvu9J1JBrQ+1/tWVNbhUH14T2zwQ+ThJT0IqHWTEu1
X-Gm-Gg: ASbGncs4aga4P4mIYfdpal6EDnINoZ6+V8PmhKJvocdiOlOV04xppdsjXJzR/kGDoQL
	QycsfQNeQ+RCgyhYiJygMvno5vwws0u19s28uHjyvfUON3sGGqO+0ZOVh0Ny2ycj3O8SGawjyN6
	e82u8KxDLE//wHdIa1cn6XD0FkT6OR+tGXXo2O/HBsVcCQub+JOcieDmNCRBHksO/9lMOM5tumd
	lWsxxBqpvFdibRDiE/hzbDhHiIpSil1XuDQoZhY7o+VVthUrGRbg53FcW/V9mFvRDKO+aru7ksv
	zlgwMvVmWOSxWWM6sDIjZa/8eF0bL8fUJpYbQLliV+c9pwRuSWEQWVy2Kr8w9EkAzCOtjohzsIM
	KA1Jz/WX5l/nklZEw7dWYS7Y0niGwXjSQyEWvVWwxpaM+Tra3+AfgzaQ28/5Jthd7DzI=
X-Received: by 2002:a7b:c8c3:0:b0:45b:b05a:aeeb with SMTP id 5b1f17b1804b1-45f211ffa3bmr16458495e9.28.1757667828641;
        Fri, 12 Sep 2025 02:03:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfEGRRDjeg7PNVDdXmR/J2FcCp2CnLKql41En/YXYsuRx56L+sBzPTZrVMYX6n5OIsb6zhBA==
X-Received: by 2002:a7b:c8c3:0:b0:45b:b05a:aeeb with SMTP id 5b1f17b1804b1-45f211ffa3bmr16458195e9.28.1757667828200;
        Fri, 12 Sep 2025 02:03:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037d741asm53707575e9.23.2025.09.12.02.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 02:03:47 -0700 (PDT)
Message-ID: <3f37af16-abf2-4ed4-9894-0028a9f02f76@redhat.com>
Date: Fri, 12 Sep 2025 11:03:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
 ngeoffray@google.com, Harry Yoo <harry.yoo@oracle.com>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <d507dc89-e6b0-4360-bc77-1a8bf74b9134@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d507dc89-e6b0-4360-bc77-1a8bf74b9134@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wlSV6fa3I6dzzBtLkUkFg-531x-TrO0GhH1cKx_H2Pk_1757667829
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tx63iw1wuda5dahb7wt7zjm3ojk6dun1
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D0731C0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757667835-289089
X-HE-Meta: U2FsdGVkX1+JOPn7FdVhmFj5wz3rkcRnYJrsRo4DFDzXrxg2Us/8xfTlIrtlx0CnqpMzyJm2YaP+Sf/UbR0cnDswcMlcKHfRc7XYxwuEz2LRAp6CRzuBiv2/5JhRK+f7w5EoUVSEZVU1cUSz7ojnNz58ZJHSDTEWgKNijBEIRH3+YsgDJ+qD7xeGowOB2uq6hJjy8/fRCw7bh2lKqHP8ZLwQwqBPl0JB23tNfhYhCM2QaNFbb8EI5Tc0MpQ5Y8z3O5kgW3/Lhy42g4bxf4IPO3h+j52SA/iJbZyYISsE1lKGvt+Gh32bLLYEmhp+poEYzsL7TtWfuoma3V76fY3c/9s9a/MWxx4tcV6h1VQrQKKCg3AylAvK5cis5ho51P6tENFrEwDRLo+zNoQeFfiy/q+1zI0gqCNH6sPeX8yu3+e2jdZCzwWVGvvgNcGmcDtiVGI1THAYADn81IDvtQSDW8YGIe4Q8gjp8dGr4We9RNsgh7XiK0R1ibwHvZe3Sk2l7d73WFEWGAhyER+z4XP/DIAI2lq2CEgWJjnhJuyr6x7+tycuvx/tlabbRjBQ8XuRXOyf/KB3iX+00b7V2lDg7RvOusVGHRlL3OEXeg0MllQJ5O6UcOcsWSyNUI9IgFWdzivsb2i4Tx/Q9cSCVhb9xq0v6mbTrCAiEYwI2SnCKa5yFtaM8W6AJ7I+QDkIPdb96my3kS7FsPqHt0bbtEvHQcITIUecyuvgbolTuBuyDIai0YQZ8bc45GgYHvL77QK5n0gXpNLoDP7ExicCQWJ3yF0FT+/wx0qhXk+Xkh4VEPg8j9tu+eLTGWLJHjqt6NRzptSdums79j+Ogoz1sg5+LANprAyVMSBsaI6KnO9cnIG3qx0+VLbWhA7hM76VDvLD7HcKsWdjOEr4sevK8PM4nPRWKdd1Bhrf8ZzZ2gGpQAqTAAYvhwo/VPhu4rR44AGSEmPM59ay4uGMJVUjeS8
 QDOR3d/i
 /DtC+d1oxc4d0328BsOURZBfpnJ/9n3kPjBEoWeEs+GG/zH+MKHF1cWnOrKLC1HvukKLO3CPQe5PTzpmLROcTyYSraqLI4g1gacx1bU4P5REF6LjuzNdrVpQtGNV0t8CvvGSkO7jya6p6MWacT55IRwz/DaKibzz5ruWT00RCvLOOdvq3s6WIYIMwkr4+B/qHx1mfVSqrqqTEfqnWCPqwxSx716JdKHWfkoKnVDoMd7Wudvy4b370UWA7rzMADJH0Qq3YnirFTRWJfj2hONQvb1p2vmMSXqqbhiBmgaH7em17FSdnX509rJc3MydqEzJ9AH7NK/7LDC79V4YQAnzAbC7EZSyxH2eSDZyI8O98w0jgxXbS8wxpGngDE+Ma34eIKwjJe99GI9Q6abS0EMYFALLe76ABwfRqEUwMZRCncFFJS/Oz6d08Y62dsWKGgCzNA1L/Ptn3VdxoPlD2xsPfOdLydb0yjG7OvMOL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 21:39, Lorenzo Stoakes wrote:
> Please please please use a cover letter if there's more than 1 patch :)
> 
> I really dislike the 2/2 replying to the 1/2.

+1000

> 
> On Sun, Sep 07, 2025 at 09:49:49PM -0700, Lokesh Gidra wrote:
>> Prior discussion about this can be found at [1].
>>
>> rmap_walk() requires all folios, except non-KSM anon, to be locked. This
>> implies that when threads update folio->mapping to an anon_vma with
>> different root (currently only done by UFFDIO MOVE), they have to
> 
> I said this on the discussion thread, but can we please stop dancing around
> and acting as if this isn't an entirely uffd-specific patch please :)
> 
> Let's very explicitly say that's why we're doing this.
> 
>> serialize against rmap_walk() with write-lock on the anon_vma, hurting
>> scalability. Furthermore, this necessitates rechecking anon_vma when
>> pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> 
> THis is really quite confusing, you're compressing far too much information
> into a single sentence.
> 
> Let's reword this to make it clearer like:
> 
> 	Userfaultfd has a scaling issue with its UFFDIO_MOVE operation, an
> 	operation that is heavily used in android [insert reason why].
> 
> 	The issue arises because UFFDIO_MOVE updates folio->mapping to an
> 	anon_vma with a different root. It acquires the folio lock to do
> 	so, but this is insufficient, because rmap_walk() has a mode in
> 	which a folio lock need not be acquired, exclusive to non-KSM
> 	anonymous folios.
> 
> 	This means that UFFDIO_MOVE has to acquire the anon_vma write lock
> 	of the root anon_vma belonging to the folio it wishes to move.
> 
> 	This has resulted in scalability issues due to contention between
> 	[insert contention information]. We have observed:
> 
> 	[ insert some data to back this up ]
> 
> 	This patch resolves the issue by removing this exception. This is
> 	less problematic than it might seem, as the only caller which
> 	utilises this mode is shrink_active_list().
> 
> Something like this is _a lot_ clearer I think.

Yes, fully agreed.

> 
>>
>> This can be simplified quite a bit by ensuring that rmap_walk() is
>> always called on locked folios. Among the few callers of rmap_walk() on
>> unlocked anon folios, shrink_active_list()->folio_referenced() is the
>> only performance critical one.
> 
> Let's please not call this a simplification, I mean yes we simplify the
> code per se, but we're fundamentally changing the locking logic.
> 
> Let's explicitly say that.
> 
> Also I find it odd that you say shrink_active_list()->folio_referenced() is
> 'performance critical', I mean if so, surely this series is broken then?
> 
> I'd delete that, the entire basis of this being ok is that it's _not_
> performance critical to make this change.

I think we can mention that as a side-effect of this performance 
optimization for uffd, folio_get_anon_vma() gets simpler and we no 
langer handle locking of anon folios different to locking of other 
(pagecache, ksm) folios.


-- 
Cheers

David / dhildenb


