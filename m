Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F588C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 11:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F1A6B0088; Fri, 25 Jul 2025 07:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9106B008A; Fri, 25 Jul 2025 07:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059806B008C; Fri, 25 Jul 2025 07:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E69496B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:12:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DEF41A06E1
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:12:17 +0000 (UTC)
X-FDA: 83702523114.13.14DEF5D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 129CB4000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:12:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gptuJOu6;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753441934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvAMKNHyDr+p7xUsxnSZ3nM5HAGq789tGrRLQqOtJTA=;
	b=7eHYYjR6bG6a6PUSmvH535mdiZcOTRni1QsHaA+oRXc5AvUNM6x537x89ublo34C3dKRZy
	luxKxY86FJCHKfGhJn2wAw/hqRGchinBVu5druMgV1p03sv2xktVlFh34e3HjWHu1XjXgf
	chVp9UEP7PfwnKkDfzu/Zin9F4huJFM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gptuJOu6;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753441934; a=rsa-sha256;
	cv=none;
	b=Vykm5aPqYU89ggxR3mbR/Jz/JYG0DDe8lUAlSbB/mY02jkB36CBLgBAtKmVr8LCxQq8oCh
	P7cj5yXva4zlrg13BzwnkQ1K6Z483d69LlBhFyKCZcvDZCjAAsbnbuWSNF7/kTOmJFQwp+
	pTbQpVSROGYGC3Y436bWiKBmd6wWHTU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753441933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vvAMKNHyDr+p7xUsxnSZ3nM5HAGq789tGrRLQqOtJTA=;
	b=gptuJOu652YDpQPrpPqGLaTNxkcVFwHNW0qvsgdQDUEUe0RF7MTCwMQKAJoXXLyTEfrTox
	mWf4/83nnibt6SUZo4CFJ5m0x91wrfhntZ4RwFahH/8PizWz+9yxX+cJu+JrFEvIpmcsQv
	rIz8wSVAhAh6VcyJOy9+nTBB+yPI8Fg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-auPDzp-fOBOsQ9EsjqVE5g-1; Fri, 25 Jul 2025 07:12:12 -0400
X-MC-Unique: auPDzp-fOBOsQ9EsjqVE5g-1
X-Mimecast-MFC-AGG-ID: auPDzp-fOBOsQ9EsjqVE5g_1753441931
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4eee2398bso741126f8f.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753441931; x=1754046731;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vvAMKNHyDr+p7xUsxnSZ3nM5HAGq789tGrRLQqOtJTA=;
        b=vsBZ+jLuU8hKRFhDUyzvdOFbbnRweW7nrc+64p0c0FX5Mr3riVxoStE/xuqzxZB2E6
         o19Dcz50IKnVuTvzMegtEEoMRnusPXKjOU7KYhK2c1ojeEvHBInJYz58mgo57R/e0mLC
         o4nSWRXwhGttq1msr8lp6RQda11f4wbRLhWb4Eq+8Bl5xe0yHSJWSJSzvckneEJ6Q+BT
         uzydRstwv9ElFFLsXVtGmuIdIfN7/NaVCccXs7nG/X8+Olh23OlPyndnbKv/incwH54k
         R9xK7ZyEhWfhDSmO2iwtVAEHfp3u7iIspSzKZ/h1V7i8XklSSRBfSdtE8ysOscCsYePE
         oU3g==
X-Forwarded-Encrypted: i=1; AJvYcCWWivGlAeOlSMFCuxD8X6plONVU2jftVA7Uz+PIeDymy+ZIiv2+3bs98lET5bfDaoxqrX38yH8fEQ==@kvack.org
X-Gm-Message-State: AOJu0YwvasiRPy3+sWLhiMaSivPXH8/8c5V4YSBnjxQbHTFwt7KScZxs
	GBgHXnoNWwq2BZxdM5ly2+8Q2/N109jRlED8tO+kOZYSu5GEWN+InfhhWuqeNGRQnXhWSpB6OKJ
	BLfQBeezmZ0dkJMi93xjvKV3Oy/I8yyQP9no5s+5d4NKl0vL9Hup6
X-Gm-Gg: ASbGncuSO4Wh5E2BpEnOAZOGVFEuNZRfVUY5HyVEX97Du2d1VJOR2snweDezAsUb2XZ
	VO8BhLILKnQL5TEwtni7IQ82mdbpC1poNkPPXglk8vKuPTLUpmMaAlVhin07rMg2NCaCDrGQvyt
	bB+L4LEHJ1nKVDl5+8NTCXflmtKhvM84OwLPPS00ASMyETbeA+D+PNO1gXKkVjgy+XO5fEmW938
	VVXZCl10LwXDIo5vzvDHvvIqW0tjibc4zRU+l41j7vQdJBtVqOzWJKe/e6CycN3TXczeI666da5
	ZE7Q/aOaFIoP2log/biG1ENB4qWvzsl2DSD4cUvQP4FajZdeNmbOWDB5NiMslJFQ1c52uJkqb8a
	6dEQZ0Fz4W8WVEr8LL1KtMliUbZzQc+9pV8uQYiwX0mMqzMzKq6dBKFGZC21ypFZCwso=
X-Received: by 2002:a05:6000:250c:b0:3a8:30b8:cb93 with SMTP id ffacd0b85a97d-3b77675bd64mr1398715f8f.32.1753441930859;
        Fri, 25 Jul 2025 04:12:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpbeHKS+nspooiwMzx9I2rs2V3dCEOZZIv81NqfkgXnD8tjiuNdNZyFUr4giMpWLWQvDLecQ==
X-Received: by 2002:a05:6000:250c:b0:3a8:30b8:cb93 with SMTP id ffacd0b85a97d-3b77675bd64mr1398690f8f.32.1753441930369;
        Fri, 25 Jul 2025 04:12:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1? (p200300d82f1af4005a9fb1bf4bb399b1.dip0.t-ipconnect.de. [2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4f40sm50046715e9.27.2025.07.25.04.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:12:09 -0700 (PDT)
Message-ID: <bf29d398-5f7b-449c-b142-cf9873a5b183@redhat.com>
Date: Fri, 25 Jul 2025 13:12:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <85c4a092-14df-4478-811c-f3789610e4b8@redhat.com>
 <CAG48ez1O+7ciCNDVnh9MPh_1_1TLWd-=H9L6p90J_9AEbav27w@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAG48ez1O+7ciCNDVnh9MPh_1_1TLWd-=H9L6p90J_9AEbav27w@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ek0H8sN0rRGrikHgzhPQw46x4rApFbKrUBkwufnQ7Rg_1753441931
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 129CB4000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 855jh8a8qyyw3kkbsuw199qe4u46y1ku
X-HE-Tag: 1753441933-30294
X-HE-Meta: U2FsdGVkX19CW263tv52Zb+tzQXEwjtyqOXXyqM7fpWuECogc9iBF/3N1HjL99i7wYsNIx5KFpwrY9tpMjW3/jrd/3vUtbIHZr1GprJ6PCtPbsFWzEewLbk1VGM0nVWcLIFnQ2E2NORorqkSkp+C8+JPyaWvvAMvhx0TwwcRDN0MYcm012LqQOM76wBPgKRvAQ8jMDBaBcEwPOflskxA//zeF6Q4MKKM4PSvGfeZ+igyo7xMF0viqo/gvf1SY8ZcPFSTMir9bwUOlI2aQQY2qTSFvIfe14JB6jgA/VGltQCPi0BmRY3DyH+v2EOmscg2AyILohAzzF2wiyVmRvFBV0Sz4McgQCFEutZVMvJgVeC5ghTbVREWrhs2ynOnwLn7G2Rq7jZO2odZu+qpQktFag45AR4IKOw0kyoDXq3JidL5L1YsIRaHhx0rzUoZZ3o05Ga0vZAvO/X4yIbuSR3FD/QkMWEtZTdRrEDyZDTqxEtXT3p9GIwST5CVaRlkwvREpwuJl5gOK3FzfCcFIVsJioWTF33/jxG/cmdeq51xak0rxK6gmXEoL8KxH7fTjMSRP9FAQkFabaijiu1ONoKUa4T9ZtDJIkzv8adWWbTe+kCk6GNeizNZB/Qk8aK/iQnOG5bQGqIayUng37aYRhfgVQpoztodSpr7VUV+7joaPFBqiV2RjB3Vb857Vwx7p1VpbpNhN0Z1FfPBuJRr2SuNRfRwEb0/glIntyR/JDYME1OhyrOudxUpR/E49rGOrazp8T/Qun98RNjBUMMlBiyYrrQpP6d/gMpacduxEe0ToG9hty4xvdLJZ/XqKJkCyapdidK2h7+onh3m1H0xXC4c7ESMKXegohr6g8SF8enekRrRC4EMvVsSwObrX5Xr7jk3TMbz5+hNfJDOGAVmHVnMcIOVIpPsbD+YN2RoY2D+rPH9T0V7nFq1AWr/hkhezvteSA9hYAxVKjiY8mAPPsL
 5Euwbcxe
 mllYpcwPjiuCIcRZeqQgrmLV6Y2EZTR2uo7YDzTMEyf3zioVa3PFRE5xoVo01+RuqkJ9ZmDLXHteIG61UUVtrsD14eWVZMFJ+pQKMKjKFepxPlRhBGdvnVDwRweQdmTykBSqEWVLdqNhbBeO4/5IpBmwk0KM/QUV2nghUCtdhxInQDThp+KTWcYVgFllgMt763fsAC0NgWLfub/uDxDnuQatgs5we6gpJCzKCueCOfA0xCMq3N5ZUVSFHt9QbL+OuOfs3IrHPTxu3Wg5fxRtUMEW8DkXuasMX2vXEBr7P3N8XT1djfVnrwG4uoozivm+BGJ6HOuUxpEAAzXDo4Jit2aVs8+UbXLVN8iE0PB2OHnBQmD0NJVw/XIOcjw/6y9BzGtnquHgNdIT/IKnO+3YGkf2PeV7Mp/OQdBGvT6iRamPW8LstRPy7oGsVmeX6TIpdAnmThkYimUyAvnqNZeD31GLZRjN5kWCqoflfzXI3fNkIXciD24D2ctx30c2NDjBvW/44cc5hmWC2LJ++vUMJhz/GstNCtKmV9r2Qpf/NnEKQEGD7wvO+0wIkgw/L46itXVbT7KWPGWktyeMmKsF1nuGDR89zKd0Zq9Ba
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 13:08, Jann Horn wrote:
> On Thu, Jul 24, 2025 at 11:56 PM David Hildenbrand <david@redhat.com> wrote:
>> On 24.07.25 21:13, Jann Horn wrote:
>>> If an anon page is mapped into userspace, its anon_vma must be alive,
>>> otherwise rmap walks can hit UAF.
>>>
>>> There have been syzkaller reports a few months ago[1][2] of UAF in rmap
>>> walks that seems to indicate that there can be pages with elevated mapcount
>>> whose anon_vma has already been freed, but I think we never figured out
>>> what the cause is; and syzkaller only hit these UAFs when memory pressure
>>> randomly caused reclaim to rmap-walk the affected pages, so it of course
>>> didn't manage to create a reproducer.
>>>
>>> Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages to
>>> hopefully catch such issues more reliably.
>>>
>>> Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
>>> unlike the checks above, this one would otherwise be hard to write such
>>> that it completely compiles away in non-debug builds by itself, without
>>> looking extremely ugly.
>>>
>>> [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
>>> [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com
>>>
>>> Signed-off-by: Jann Horn <jannh@google.com>
>>> ---
>>>    include/linux/rmap.h | 13 +++++++++++++
>>>    1 file changed, 13 insertions(+)
>>>
>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>> index c4f4903b1088..ba694c436f59 100644
>>> --- a/include/linux/rmap.h
>>> +++ b/include/linux/rmap.h
>>> @@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
>>>        default:
>>>                VM_WARN_ON_ONCE(true);
>>>        }
>>> +
>>> +     /*
>>> +      * Anon folios must have an associated live anon_vma as long as they're
>>> +      * mapped into userspace.
>>> +      * Part of the purpose of the atomic_read() is to make KASAN check that
>>> +      * the anon_vma is still alive.
>>> +      */
>>> +     if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
>>
>> 1) You probably don't need the CONFIG_DEBUG_VM check: the
>> VM_WARN_ON_FOLIO should make everything get optimized out ... right?
> 
> The PageAnonNotKsm() check is outside the VM_WARN_ON_FOLIO(), and it
> uses page_folio(), which uses _compound_head(), which does
> READ_ONCE(page->compound_head); and READ_ONCE() unfortunately doesn't
> just mean "I want a read without tearing", it also (intentionally)
> prevents the compiler from removing the read when it sees that it's
> not being used for anything.

That makes sense, the volatile read will not get optimized out.

> 
>> 2) We have a folio here, so ... better
>>
>> if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
>>          ...
>> }
> 
> Hrm, okay. It kind of irks me to write it as two checks when really I
> want to ask "is it this one specific type", but yeah, will change it.

Well, ksm is a subtype of anon.

folio_test_anon_not_ksm()

let's rather ... not :)

-- 
Cheers,

David / dhildenb


