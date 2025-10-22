Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63945CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD978E0005; Wed, 22 Oct 2025 16:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5AB8E0002; Wed, 22 Oct 2025 16:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEAD38E0005; Wed, 22 Oct 2025 16:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E08E8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:52:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 348DC5BB70
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:52:39 +0000 (UTC)
X-FDA: 84026948838.09.7941821
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id A91CD4000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:52:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IjjUyUKR;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761166356; a=rsa-sha256;
	cv=none;
	b=SBLsNZGZgoFR9agq0Y6mrYH3WVP3U8FbtQUY+nIi8N942/iXMPC107i6a9PZCYvDEjWbVG
	K1XK2iKINZK16qOI0+5oQas5xlnrx1kQTGYLmSGIFOk261jIcNiL736QTmQe6lj1Z1w0JV
	xwRGssXtFadMTQ5uPUtfxDK87nCpHqU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IjjUyUKR;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761166356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lu91KQfbH6o8UIzsj3eeA+iO3dbH+krxr074ui3TqEg=;
	b=aoa5MT47TDaL7qfSPHkJeufBF7x12BCOUrl8+Ywn/s0En+8rUu09hV9s50lWCGNCOUXmjC
	ZnwhrcFgXF9OLVakg6yJpaVUcfJmAtMoyKdBWvQVLGGk6iyWTL9M3Ic+q0ajKkJnuBnjX4
	MOw5ePaDX4h5zwx6SBO9xiu+SNF5qaM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761166356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Lu91KQfbH6o8UIzsj3eeA+iO3dbH+krxr074ui3TqEg=;
	b=IjjUyUKRIrrshL3TarsiDEgxg4SGcJkuSATHU67CqdLAnr+BcIUVVlFuE0yTmyUtY1uzX8
	lNmi6KJMK6dlvVBYyJKhGs3WvL6jpil9XeN69LHCB5S+sBXaqSE1V5f11/CPhO72wuvtaC
	leWskoHvJ5N4kn3aocb1CSPdQoMNyaw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-FZiDCd9-NcegFC0xWp2ZWQ-1; Wed, 22 Oct 2025 16:52:34 -0400
X-MC-Unique: FZiDCd9-NcegFC0xWp2ZWQ-1
X-Mimecast-MFC-AGG-ID: FZiDCd9-NcegFC0xWp2ZWQ_1761166354
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42700099ff5so42146f8f.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761166353; x=1761771153;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lu91KQfbH6o8UIzsj3eeA+iO3dbH+krxr074ui3TqEg=;
        b=mZKOyy87PIBbf3GdGsr7FgvZVzakcolU/qlD9tnMfwLt7S7UrhCUpCnzFSuCHixoBz
         xPJXZUmYXI3TrTWUlH3t2xOPeuORizWxUCW6buamReHj3HW44FczsodPrqsSmR5SMf+w
         /Lx6KNmvHZRrBBAXoIA5JK7O5RXjK4BuT9KDl2SspDp+OL0nS4riPuZjo5gTeQF7Sfx9
         q7TnMHod8yl7ljwUbyFIVgkDaY3S5rJz3mSrwgYjwQq3iQYuTQ1EQ5j0rKutrSw34r+9
         7ok/1KWlGcj69LbvdkwOTVioEB/be9N16eEgqwYznZOY85Q6Oi65Zr/+NFNSMsERV3k5
         ecwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh9xcsLL0iqITysBgLpFfCmuRaSX655COLWhLFnGCkjwYkNqhJglxIyrSDRENsEvpZI6NzCj+yEQ==@kvack.org
X-Gm-Message-State: AOJu0YzsGCqiiOTMOS0UgL9owMUdg4uY6yXFRBpK02pbXW6PSx3kd/FX
	h2Sm95yje3yOs4CwcF/UVO9WCmISt9BZIA5It7l5F1R4kiwWy5tfpos1WhUlHIQz+wcBc0kPBj9
	nJ7Xc5dpsENtL1/dBQ2CjOg7yP0n3XsRQitjmrd/KK85JmjiZrFXK
X-Gm-Gg: ASbGncuHQKdAPY1GSWepLxlkh3Cpg+CenZLjviHZ4BxsM6VNga9yhIjOeZM/AQJrONB
	eE6y8fJ3TR1YXp41438TOVl7+CwLSqd0WmmX8xX+tJJMQHTVrZ5Jjcueh5ljF/43JdMGdvWDjeK
	DJbSSBmkpj3YByAKKod/EYvCarKS5IEnbNSFRNui/W9xQdQVju+swTh3Qf5eL09gedgVxZTmBUz
	9P8qmkZ5qjebK1eYkiEFzVinuWfKPX0C/6TTYkrf348YtbrHhZDcoToXBTurb0p7Gp6WtKacH03
	1hebNzqGutTm18a0mA8f2KbPLvAQwmPmWJgxZntOTPnVbFfhGUhIKRzFVCjH/2khSmII3IMTAVM
	IScoXK+5AvB6hp9yQx0MXHxqC5pUr+syVLwcH49KA+HQakMtm/VTQPRgLETPXoh0JHgMDaDv5Y7
	JfHi3VJVBN+xcuP/tZs0wKoqa8fZY=
X-Received: by 2002:a05:6000:2911:b0:425:8bc2:9c43 with SMTP id ffacd0b85a97d-42704d7e987mr13805937f8f.1.1761166353590;
        Wed, 22 Oct 2025 13:52:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtGlhiwcEmKqFcMmoXcts+Wi3p5k5dA2NAGuq1jPRsOolnrAZjAXKLJ7CZy7vxZBo7eOAr2Q==
X-Received: by 2002:a05:6000:2911:b0:425:8bc2:9c43 with SMTP id ffacd0b85a97d-42704d7e987mr13805929f8f.1.1761166353138;
        Wed, 22 Oct 2025 13:52:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897ff371sm339299f8f.21.2025.10.22.13.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:52:32 -0700 (PDT)
Message-ID: <f42b7b67-7de4-4a7b-8074-25ca87a952a6@redhat.com>
Date: Wed, 22 Oct 2025 22:52:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Andrew Morton <akpm@linux-foundation.org>,
 Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 craftfever <craftfever@airmail.cc>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251022153059.22763-1-pedrodemargomes@gmail.com>
 <20251022133118.f13f924348e8cdc6d49ef268@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251022133118.f13f924348e8cdc6d49ef268@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 67mMxMHTq1ppraG9X8qr_8UX7HuSBy5ILpCc-ihQB4I_1761166354
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 17so5cpzzqdkwe4h4scziixjswzboakb
X-Rspamd-Queue-Id: A91CD4000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1761166356-541843
X-HE-Meta: U2FsdGVkX1/8t242DwtTr653OoIANmJ2HpzNyRO7MxwKmYnA2yl1Oq8cSxi12f6lbbXtdf2ArAu9ye2Bx9KtBzXVt3wTr90YpPYymmvHqZeaRFfCqKrnJPVh91Ss+NHUvNAZ3vCsyvaRsAwnU9PKa/sQBHZuxYiEC6CucTew7uNQYTNwGX+m6d0S+pw6sbV1L5TmW08+e33/Rm4BUvwL6/DQNvs4sexhh7SXnecmCkAkOysKe6gLIrbf9n+Q+AoGlv8UROemX1bpBPROm2XNiwOScmhoKLju5IRZIB9itjoXGiYbEaz1BHVyUMG/8r7BivWl7wzaHgCZ93BY5GSMqQ1lq4M+dayY+JzVMftPcn2WrO4IqLSHzia0vD/3jhL2eNz4CfKi0VcYbb6GvS3ZVSqyDbJiw0+QyArpE8m3eeWdOHEZJ9PPTUOKWA5MYZDo+FcMJqKVtjzmZAlR9JMFUqKI2ZdfeDBDQTghZAD/L/9Vh49MFVIsCLSwPSBdkWylJIHsbAKf8K/oS0uuPvaxp/xKIkg0+gW75+CMMs+fqQzHyxnl1dZiyel9EVFfQ9cHs2dVopw1hXS4RHGfu9PmEK9al2FTxqr24F12h4Dq9assvlXEvz5U6hSb3lF4+5ugQF57coyPxREZyuuS/lWkwsq6jEEdGVP8viDH8Ym5GlV47OmIMoACyuLi5NQ/PWBc7VvuGDdtdKMNeeLT2ps8y43vFuPQqhLm1VWj8IdYCTd//TC+5s7IDGHE/XigoxDeZTebqhZYg2jcz44QsqQHsIjvslq0JKzV8iZyANzliWmZIP36JwtRWNDPDsndTCIN0XWUJJjym+RJ+euUWQJYZYZdyofHqOhuTOIN/U7bl895112j9402bo2sRgDHwYO6Nb1Nv1tAHX8WuVqntr55As6s9s9vwomLp/CKWRSysjKkqIrLpby0Wf4c8mppdl1iHiSDOEk4zECplt5erro
 w1S4OSVa
 mp/ghMA3rARmhe+ru4hEn+STjy1+GanUOhSGdv0WesyG1dv20nMWxp0ATZJYvjjfQN+0sRyZ6mpm3tnuVoJBEp8UxppyJF08LnbqEFWLHMM8RBow6v3ADfxZt8ZFtipKXpUQMG1tzVQC0G7kniWdlRKQti1E4Y6lu2+/NMfZe8721eKp3zhALL6EzZgbYmq9fxm3UVCvi8wiB6XwcTblWDD5k2PaWjiAnuqpYg1tsdG/0Y3VIIhiUqBtRr5biObjUZb4KAyqbPtbfdBg89zkBtZQaz1+JW3p4xLdmWqDJM1fvPz6GeYpS4tXK/yV2ormDimQea3a5WgEsOwq1QHZxnGjfUEHtTIU2Dr/VUhuAwRz7EgttqKYGxCi4hAPyEgB9bL3ayRB/h7F53FEGH40/Wh7uvj+V5P9l+yJ7wtpsNvJtq6ol/H9HzCrbXFaGvYtuKp6RTVs9poR65ncDshfks+tVWSDARN5N67pLYWzN+Ze2tFTJBh8joQvksVbP21OEY0DTllyZa56hbNvxGsPSAzcqRbKqex1kV5IRyTur1QjmDFjHX9a2q84ZfLLnSaBRRlweATAiNThRm2NIjj1tfFgBykjBuyaroBCH6SlenWf0h4jOM1qawFvzX+hJLIfhW7VM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 22:31, Andrew Morton wrote:
> On Wed, 22 Oct 2025 12:30:59 -0300 Pedro Demarchi Gomes <pedrodemargomes@gmail.com> wrote:
> 
>> Currently, scan_get_next_rmap_item() walks every page address in a VMA
>> to locate mergeable pages. This becomes highly inefficient when scanning
>> large virtual memory areas that contain mostly unmapped regions.
>>
>> This patch replaces the per-address lookup with a range walk using
>> walk_page_range(). The range walker allows KSM to skip over entire
>> unmapped holes in a VMA, avoiding unnecessary lookups.
>> This problem was previously discussed in [1].
>>
>> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
>>
> 
> Thanks.  It would be helpful of the changelog were to tell people how
> significant this change is for our users.
> 
>> Reported-by: craftfever <craftfever@airmail.cc>
>> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
> 
> Buried in here is a claim that large amount of CPU are being used, but
> nothing quantitative.
> 
> So is there something we can tell people who are looking at this patch
> in Feb 2026 and wondering "hm, should I add that to our kernel"?
> 
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Fixes: 31dbd01f3143 ("ksm: Kernel SamePage Merging")
> 
> If the observed runtime problem is bad enough then a cc:stable might be
> justified.  But a description of that observed runtime behavior would
> be needed for that, please.

Agreed.

With the following simple program

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

/* 32 TiB */
const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;

int main() {
         char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
                           MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);

         if (area == MAP_FAILED) {
                 perror("mmap() failed\n");
                 return -1;
         }

         /* Populate a single page such that we get an anon_vma. */
         *area = 0;

         /* Enable KSM. */
         madvise(area, size, MADV_MERGEABLE);
         pause();
         return 0;
}

$ ./ksm-sparse  &
$ echo 1 > /sys/kernel/mm/ksm/run

ksmd goes to 100% for quite a long time.

Now imagine if a cloud user spins up a couple of these programs.

KSM in the system is essentially deadlocked not able to deduplicate
anything of value.

@Pedro, can you incorporate all that in the patch description?

-- 
Cheers

David / dhildenb


