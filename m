Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B376ACA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 05:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AAA8E0002; Mon, 15 Sep 2025 01:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61DA8E0001; Mon, 15 Sep 2025 01:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A509D8E0002; Mon, 15 Sep 2025 01:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9B18E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:17:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36D61C03EF
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:17:50 +0000 (UTC)
X-FDA: 83890327500.13.6B2A85D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id EFEED100002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:17:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1iLOl2v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757913468; a=rsa-sha256;
	cv=none;
	b=NNhmcb0kMLlHJjsEEbPTVHG7+kZW4gu6DBG0MOIpF+qk+jXkIOotlFMLNnm/Xye99VNbr1
	Wj9XXXqzvTAOSZ0RvCpaN+VBE6Dayq9PdhSBmMF/L1YaK+HvvweXY880Dtk9SHHG7tgtmI
	2+Gm/FoI60uOm3+SNf4Fi6aUAUPFp5Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1iLOl2v;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757913468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrNeHNSpx7X8OKwgx1C8svPBQbezyOO3HQDCOERh9rk=;
	b=0+BjuFizUKW7PZVxATwh8+NT+RKTsKfNOTUSuQY2ewbL9zgbT4UBdW2ImddNKSta5ofpMQ
	40EawvZkkVIHqIZ+1fC1zSAuiVNLgDgNOQqwJUm/+2IZ3B+uZT4LgE9GUPzT76rllRcKNP
	2Fzqd6FYJOYL+igcBgS/vgCLNlXMZs8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757913467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SrNeHNSpx7X8OKwgx1C8svPBQbezyOO3HQDCOERh9rk=;
	b=A1iLOl2vI5zq2bznEbpPCdDDe9ROqireKbxzYUFaO4H1lD1yuDCfUFmnf7ouUGCOJf+oto
	7GaWmfTL2Bvjwzti9WB0fL1BaWLZ/fOaLr132jIElWePUdZvclwf3HgggX9SfvqACVIG+J
	FRzFU7CnYQ3/HUlJE6IX3vv+eID/Ggk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-JdEJtKXBOmSB71zkM4-gdw-1; Mon, 15 Sep 2025 01:17:45 -0400
X-MC-Unique: JdEJtKXBOmSB71zkM4-gdw-1
X-Mimecast-MFC-AGG-ID: JdEJtKXBOmSB71zkM4-gdw_1757913464
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45dd56f0000so25469545e9.2
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 22:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757913464; x=1758518264;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SrNeHNSpx7X8OKwgx1C8svPBQbezyOO3HQDCOERh9rk=;
        b=N/9LgXHyMhBf2XufqmKfOCfEdUE9S9+NdmCD/ghMAqHKE+iiekPogNQ7u4iQuTFRgG
         acPMvutIcGvqCaCCIOJ4maiPuU8p58QHvnr09GWBr9ZcEjm9WutQUBWL6Y1O4JsA5OVp
         U4x17ZKZ9OjTv2jpw79d8UOEAwCuaHka9Nz3eES3uQSZrVZShIEB6D0EApSvrIUfcGCm
         8k4L6JXykGN1iwvNjivSdPbZTUe2T3HxLU/WMHQBLPwTq3xXcSag8hRYfe0iq4NRozFw
         hVpw9hYlVQ/j+XErbMJ1YVRexpan2xT1ozUW+F6jznoraQs+N5nAXYmncHwwkY4OZ7eV
         Dw5g==
X-Forwarded-Encrypted: i=1; AJvYcCXMWAklVVasPxexDjnPanvzgHBKCpKcRYUWHVAdEHASm7fCRiFjPCWoLo/dciAtZTq3GiGXfz7cJw==@kvack.org
X-Gm-Message-State: AOJu0YyeVvEzAQozYnrtpKnBvWhxjCB86gvFdUIiwQDfuk7xF+zn9sV4
	dl41eaXYlKaDgXNFPyokSP7Vl8JcbPzufkx87tUuBmGkczwrJCKP2unp1i4NbxsGLUho2c51EUV
	9p/hGbayCTibVwXJQib8zM+PGSpREsAVVGmIWdXZQ/N3RxS+dv6Mf
X-Gm-Gg: ASbGncu5ZLUuv4iToDT8RQ1WKN7TD9faDHJrj9HM0pcOLcH4rCYtaKjX0ej+n0/bWFe
	Wt2QFH1JcdyJfbv2ePoob2jsJlBvjXk5ocUcwfpq15TwBxwRn3CnM75KbAdy96JZJGjJKdrSEhk
	pWz0tTzU6MipPwKp4Kpzf+faqezFDJn9Nb8EIDed8uo5Dd8MaYIoECWzwDeudSZ1B2sIILnSsNM
	DKt4bV9jeNGYY+G/X6AhwNve7hVryBJeRSCJxRUODzBr/n1+dDPCdI4RHfDcs6FzSHlNa9layYB
	M6WXUktHSrZp+n/cFAelqUJE2nwCOZKKwrB/wpdo9aYp/rx8EuC9JcmhHxK52YfJAVa/BU8dTW+
	ef1ncygzMaauFk3rqanrACsvzUQpoqgSrjLiqQ3wPlqzqCqIoSyr8UEPrA4mh/9TyfoU=
X-Received: by 2002:a05:600c:6053:b0:45d:e326:96d7 with SMTP id 5b1f17b1804b1-45f21214974mr67743095e9.13.1757913464197;
        Sun, 14 Sep 2025 22:17:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZTH0xhves3e9Thc+HguT8Di4bV9oShApURxHCRsWsGFXi71Bii8xySd1lI9+kcRiFl6ihmg==
X-Received: by 2002:a05:600c:6053:b0:45d:e326:96d7 with SMTP id 5b1f17b1804b1-45f21214974mr67742885e9.13.1757913463760;
        Sun, 14 Sep 2025 22:17:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f2b9b443csm50636635e9.18.2025.09.14.22.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Sep 2025 22:17:43 -0700 (PDT)
Message-ID: <18361483-5089-4414-b974-4c481189b9fa@redhat.com>
Date: Mon, 15 Sep 2025 07:17:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Matthew Wilcox <willy@infradead.org>, Barry Song <21cnbao@gmail.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>,
 Lokesh Gidra <lokeshgidra@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
 SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
 Peter Xu <peterx@redhat.com>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <aMd-2argDQCHww_Q@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aMd-2argDQCHww_Q@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vHPt6tKkczpujYPB1oA03rd1K20UWJEsI_nJkFA3pz0_1757913464
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EFEED100002
X-Stat-Signature: yxnm4fzarqwgjrczm81aqu4axb4b5qef
X-Rspam-User: 
X-HE-Tag: 1757913467-530374
X-HE-Meta: U2FsdGVkX19XVkzxzm0fRZQBK5LZUw7SlDgGtn5hqtg2KKEmpubjQhRbrxSC9lmkdNjz7NL9aJ6TUbGHbRWWQrkYBYdnt0NFDJnuHuK2kZy6O9P16kSmcd1SkleRd37BFFs/GbG3k5adkyzKWwZtaw/nr4V8HbAMErmvtgq+pZjlCiIPy+Ma7E1DW3ysTBso+/v2TWXbA4pQ1FVxcUM/I8kf3QgpbKOVldze2YKHb6z9Jub8m1CxpZkwrQyfHFfxjaJpKNCrgV0QUbDyRwF7nqr/047+mR1x40su3KyNyMAIDFYCb2W1ftfjaA1tGRAFX3Nsf95JRB/4fZGEqguZ9uJT6cKDxF/xwx4lwf7zGTKEPT39+vUnqg9LU18Onnw4bxRU7oXmY7ADNxd4hPdguImYgikCsEUKyVYqjuaQcISummpmJgV9fOB5LXCZVsvMXYWDoEE6mONBfz3vYPZSqE1GXGaI9c534gXbOOqGRPSKAz/RDimGggQR2pxTndrth05E+qQur5FuwXLmtNhyEi6FIRnzh7hB/2xnnE3gRejtN0yHzBv3eXzwJBfjrjfeH0sQ756qJyzg3fhB8pe/Al8ZiDGBRUpIbv5f46Eq8UDtjoqG8YAavTO/zXN6lb9nrTi2YM78IyIaIoJgiBOtW97fS3OnYXBo7jfSe+E+1bkozUAILu6wLKB+ZOH6bf57qD32o7nTP1A7BccSt/+/ScVcfOs35Kd2Hc/6w++sEjM+N5CMwaFTFtCcWTPioc6MyJPUI68i8ZA8MtXZLjOSqQFvN6tJGjLAFAJok9Vma+K/l0yWujWOUSsAzuRyVi0llb7zbBWz6MDEDjdw7JVfHHxlINMp14mSeilp3P6lk6Lszl+PWlJhOUhU2D6J9HFPdQ9XczDQDkPlq8DI/GFN37RK1w9UvptvM/NoVxtvkK90v90zLFfI0PTkL94h67Pe2oKNrbatQu7fPYXQcyK
 2noqD/rv
 gPSVxy2z0RqP1xcVOdeojWOKNKNzG5Jeulhzt4Las+l/sZ0ysLhQ85uZ3p1wyGQxUCMMqb17uw3Nf6g+AvzlhzCtENA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 04:50, Matthew Wilcox wrote:
> On Mon, Sep 15, 2025 at 08:23:38AM +0800, Barry Song wrote:

A couple of notes:

>>> I wonder if we could fix this by adding a new syscall:
>>>
>>>          mremap(addr, size, size, MREMAP_COW_NOW);
>>>
>>> That would create a new VMA that contains the COWed pages from the
>>> old VMA, but crucially no longer attached to the anon_vma root of
>>> the zygote.  You wouldn't want to call this for every VMA, of course.
>>> Just the ones which are likely to be fully COWed.

MADV_POPULATE does that for writable vMAs (excluding the rmap opt, but 
that could likely be implemented).

A student of mine implemented a MADV_UNSHARE that achieves the same by 
triggering unshare-faults even for non-writable VMAs (again, excluding 
the rmap opt).

We used MADV_UNSHARE to break COW asynchronously to the already-running 
workload to keep fork() still short but avoid the overhead of COW faults 
later.

[ insert usualy comment about no weird mremap flags ]

>>>
>>> Maybe this isn't practical, but I thought it worth suggesting.
>>
>> Lorenzo suggested possibly unlinking the child anon_vma from the root once all
>> folios have been CoW-ed:
>>
>> "Right now, even if you entirely CoW everything in a VMA, we are still
>> attached to parents with all the overhead. That's something I can look at.
>> "
>>
>> My concern is that it’s difficult to determine whether a VMA has been completely
>> CoW-ed, and a single shared folio would prevent the unlink.
>> So I’m not sure this approach would work.
> 
> I'm concerned that tracking how many folios remain shared may be
> inefficient.  Also that information needs to be gathered in both parent
> and child.

Yeah, not a fan. Tracking per MM might work, tracking per VMA is 
problematic due to the possibility for VMA splits.

> 
>> You seem to be proposing a forced CoW as a way to safely unlink from the root.
>>
>> A side effect is the potential for sudden, heavy memory allocation,
>> whereas CoW lets asynchronous tasks such as kswap work concurrently.
> 
> Perhaps you could help us out with some stats on that -- how much
> anonymous memory starts out shared between the zygote and a newly
> spawned process?
> 
>> Another issue is the extra memory use from folios that could have been
>> shared but aren’t—likely minor on Android, since only a small portion
>> of memory is actually shared, based on our observations.
>>
>> Calling mremap for each VMA might be difficult. Something applied to the
>> whole process could be more practical—similar to exec, but only
>> performing CoW and unlinking the anon_vma root.
> 
> That seems like it would be worse for memory consumption than doing it
> on the VMAs in question.

MADV_UNSHARE we implemented simply took a range and one could apply it 
to the full process by supplying the full range.

But yeah, the downside in any case is that you lose

> 
> Another possibility would be for the zygote to set a flag on the VMA,
> say EAGER_COW which forces a COW of all pages as soon as the first one
> is COWed.  But then we're paying at fault time rather than in a syscall
> that we can predict.

Right, or just avoid COW altogether (if fork time is irrelevant) and 
just copy during fork(). Either using a clone flag for the whole MM or 
using a new MADV option copy during fork.

> 
> Another point in favour of COW_NOW or EAGER_COW is that we can choose to
> allocate folios of the appropriate size at that time.  Unless something's
> changed, I think we always COW individual pages rather than multiple
> pages at once.

Yes. khugepaged will soon starting fixing that up later asynchronously I 
hope.


But obviously, whenever we copy/unshare, we consume more memory. While 
this might possibly work for Android, I know that some workloads (was it 
websevers or webbrowsers for example?) spin up many instances through 
fork() to actually keep sharing pages and not break COW.

So I would hope we can find a better optimization that doesn't rely on 
the workload to manually break COW and effectively consume more memory.

-- 
Cheers

David / dhildenb


