Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C60D7CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 20:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4518E0007; Tue,  7 Oct 2025 16:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C568E0002; Tue,  7 Oct 2025 16:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AA58E0007; Tue,  7 Oct 2025 16:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 058348E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:23:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15A29584EF
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:23:13 +0000 (UTC)
X-FDA: 83972442666.04.77786ED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A4C8A100009
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:23:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F87Rr/5N";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759868590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20wu+vOF0Ha2x/6Ix9nDsL9M9GUsTdlC0SzAhqgKi3U=;
	b=Kz8rfGhmOdKHrD4MXMqVLlKZIb5C0b8kKd6h6JzCvqlvuD09Vo98pRPxZQwhM+BHdVy0Bk
	7Xj1scXffMrcwtTJV4wPijU+wTx9owFRZtHvRnku3LP3fJ2EfRsTUYKV9Rr7z/C7ZjvuX+
	a+XtQ+8eQxSmDsAvErj2MsziS6uQaLk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F87Rr/5N";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759868590; a=rsa-sha256;
	cv=none;
	b=zq7w6tgSUrmAVcJ2somrd/nseLDFnZaPj6NpBr/zwxrVr9oW8NnpA83iutfu7DfqmxhpIY
	/XeskVVCU1I1TCfnvlz3PsPO5l98Cb6tkkN8sTavOwoOL//6G6CXdkO2HKaJoSmwtRHVSb
	dFgNGxKksqQFTjWfslZrUV+soe3kJPw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759868590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=20wu+vOF0Ha2x/6Ix9nDsL9M9GUsTdlC0SzAhqgKi3U=;
	b=F87Rr/5N9G+oCTSR1nQ3q5rygbwjta+wt56cDQfjjGx8RECXgczQNhBVCEqCDt6LiaugpG
	EjMwJjbgXJbP+1OS18xJF3u4ROsOyDFSRMiHHJJilmI6GTd9nv9vJlQg16MeAETy7BW2ab
	anFh35jK9faimobZ5lmvPpiglO02xu8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-XNips3FRPOiK8QYBJwxSZA-1; Tue, 07 Oct 2025 16:23:06 -0400
X-MC-Unique: XNips3FRPOiK8QYBJwxSZA-1
X-Mimecast-MFC-AGG-ID: XNips3FRPOiK8QYBJwxSZA_1759868585
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e473e577eso34739245e9.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 13:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759868585; x=1760473385;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20wu+vOF0Ha2x/6Ix9nDsL9M9GUsTdlC0SzAhqgKi3U=;
        b=s7M5B3E9add6hI898J8XPh6X4jytd6pvEgkvuo/cKLWIYXGjISdhj64UwmuyYaRSWN
         BXwODvBYy2nn6xmRNVulImTnu8Zzq8lBPt2mp9LruHaGT2JT5gefU+rMgNKY+6vc9k5o
         DtloPYfDcr1BcTeo54TLRgquGNbEYadV6SA+vqI+Nk8vSGizJvZTpOXp/tez6CU49b1Q
         Ec6QrNfl9j9HmQ9zpj0wjzQj4tWxgJzYznFOaWnO5qkcJy50VXO7vTpkpv/4ADTNmAWd
         bRN8fWTPqb322Syninz4O0JCIOX4jqr7yppElYbBTZle8hWCBTsVpIwyop64o8+L4lJM
         SPGg==
X-Forwarded-Encrypted: i=1; AJvYcCUKHPSAW0xbL4D8jj6mJXx1JzDmvgoIEO6uReMWHo/AtExQAalKwtrxoK17xuBtISsoUuTmuPV2Zw==@kvack.org
X-Gm-Message-State: AOJu0Yyp9jgbaaO0D4x/QfXeK204/MG4QD1u6M880IziGb4xhNKjADyP
	n74YbLraZg7nIWC6ITLvSzxbnAGVPRnqKIKLHECc4zLK1ClXmF1X4b6y0x3IvAGeSQNvEDswimw
	bPgzDJvLbYG9bFFd+h71PmXRTyGQLUvd7WxRtZkWdofkAhuYu0yvt
X-Gm-Gg: ASbGncu/mPBnHov2byjUF9a1BCJsHu2na9aW6d66uf++hRDUR0WUpxtbpYPQbU7D/jC
	J6q7MIDWjRGLROMvXDyn+dxYazutkuX3bpze4sb4h5yVf7tbtf1htAGMlhZ6Ywge5ev8aG2Yx/d
	oiV3jZMemWGjhUh7sL3jVtj5zuh7sOfAGwqpD2vs+Id6shWbKgF4WZGskF0R9pFm4qJk5m0tcB2
	cREHpdqYeR9DTTi/LCfPxDRtqwEwBWe0VqqsUacpg69pnvnOw1ZXfa/OznA+8SfOQGmbDIW7T1H
	IvDG7aKE3f1TPTUXqHT9I8c8wjGw66+GjL7dJ/YuNrdELCOos4BwIjKnS/w62qMrqjUVxaJA1Yi
	8t//qg0Hi
X-Received: by 2002:a05:600c:608b:b0:46d:b665:1d95 with SMTP id 5b1f17b1804b1-46fa9b03b22mr5837655e9.32.1759868585455;
        Tue, 07 Oct 2025 13:23:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFa7rpKtsIuQGWFbfyF0r34E38kHA4/Elu/xXsROCpMKx9ujbgeBUDaHZlo63QkN9imCqyeaw==
X-Received: by 2002:a05:600c:608b:b0:46d:b665:1d95 with SMTP id 5b1f17b1804b1-46fa9b03b22mr5837385e9.32.1759868585025;
        Tue, 07 Oct 2025 13:23:05 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9c2a380sm7411365e9.19.2025.10.07.13.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 13:23:04 -0700 (PDT)
Message-ID: <7d25bdf0-f225-4bcf-a0cc-d0364bbfc7c7@redhat.com>
Date: Tue, 7 Oct 2025 22:23:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Axel Rasmussen <axelrasmussen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 James Houghton <jthoughton@google.com>, Nikita Kalyazin
 <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Hugh Dickins <hughd@google.com>, Suren Baghdasaryan <surenb@google.com>
References: <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
 <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
 <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com> <aOVEDii4HPB6outm@x1.local>
 <6csw4pmymno4kdtlbzd74posr3dekamq4zkje2mfkmbg5q7xbx@y3o323tbm7h3>
 <aOVtAMm8PqEbGANh@x1.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOVtAMm8PqEbGANh@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h07bTrpehgvTXGKnzBsJ0pxxabzlpeVGXgQjsXBRqoc_1759868585
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4C8A100009
X-Stat-Signature: x6atbusaui6uiazbdgs8cj8o7s46puus
X-Rspam-User: 
X-HE-Tag: 1759868590-62055
X-HE-Meta: U2FsdGVkX19dL3yjd9Wja2FDhp+7KhgxZBa0cB7ywNucofCWd621NXb+18BdFzTmAGFMb/aw65BiloU1zyONFj/cX7logDYYH7rkEx2Qb5cBXccQgNPXhz93OtCXLzWBbCeAAmGhWbHwe9n2zbsJ4q6JfurwnVxydJNzF2IYoIwjl16GRV6H1qi8Fc+ZAdpDFtz1nJFo/BHNTJhkIuU+k16NA8qRNxhkbG0dxeFCziv3dYXE51ZrQtXYWRej4IyJGSWUXyCsBTNFhYD2u+gCEtWQyPm61xeYKih4nRA8V3x1E/5/G7dYzbDVepjsMtxxbTlLHE2FMoIOjRf3skS1aPupWBx2HdUttS4RZCSPhyEU4AiGm70/HzfZmTelr2WOcOo5uINl0scYo1t3v76ctBESL2WM18ILG5XiwSG5Etw2nd4gXjJqxmeXI688dlEFS9ZniBg04oGB/hLZJMju7jKzUlfrN2ew+e4VsPISqrK5XT+JiNcbzIbHnUJ53DKJOPTpEGUhmaOMta3WqjZOs2m0i4WZ0UG9xjRdvngm53Lwidc2bsmtbt/R8po8P5HgU2S9ptZq2CiI8rdvoKZbC6j4nzMOMrh7V8aQoT8vFnyzFVqyD/Z9uFYApKbMRl9nMB04Ssnl8LG+w/B8AnDSpw3aidLclVE44JQnk7GOafU0KoquWNdGtgsOmJoSFQRi7UmBbS3HuWh9f2b7dMG401iY3kJqc04TmL/zv4d90Wo67D4kWIS5mShfqbxNq/41CwKFJDJIJCQEQ8RMiG226Ho/Kn/s+YiiH5/eMKEIy7wXuJhC77kyEFtyhj+UBrsgEVE4DgMygUpdHY/jhRb1+b0X0bjwnwv7w0mbUwgHblpEWozvh06y4Gof59lO30L4i52puBrhra3UUFnLqQLMbn0OkhQ0M992FFzU1B8X6XZACGFMFcV4z2LiVKNBdbd8Ulj3Z08fmHOiUl0BJ5f
 BNJNrBUg
 QR8E7Lxp4u/LviLxAqYT22hj8P9JgSa+6k+d5eDsfrq98zckXeTmo2Jnsnc9lLmBEQjSG46jjkut782nkH91TgQY6WIBNuvi0x/cRG7PVFyBWC673cGLxtIUelHhqxfHUjYtkRzcvOAb4RraLbq9OOOOir1sV7OhvQOODAYeZqtDUU90/BMD9wxvJSExeOnfHMMFbBtGnzKnCcCqJvyU6BSld7fgQsns6gJQuOYWDDBWLesLJkno5tcYUq6tvbZyzFu5yG8e743J5+ocuegvisU6yV2zgYGN0jqbV7B4Vz1kln3wlfs8fTuSPvcnmgSM7nSOySl56fbVNYiUyuXuALZylt/xUBFbmdvxhsJIHmGcZFnfJfXDMFo/EWp++mWVgUO2jP8YjSnT4jKGXe4whzvr274PtAVnQFsn/+XA/ytsoz8e9izK11bM0eqAK3HZLNnXcTFcY8SWYoOvbWijV/GDb8fotswITBVqPjHqvJz2fTdZfHH/YM9iiVgm0P6M69uxF0hm3kHg3MBFVYMSz8esmJh+WS5lo92VD1ZpeAUOJjgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> I believe that's what David mentioned very initially here:
> 
> https://lore.kernel.org/r/f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com
> 
> I'd rather go with the two fields, but if we're trying to introduce another
> feature sets almost only for vm_uffd_ops, I'd prefer keeping it simple, and
> deduce the modes from ioctls.
> 
> Is that ok for you?  So it'll have (1) get_folio(), (2) supported_ioctls.
> That's all.

I cannot speak for Liam, but for me that looks like the best way forward 
for now.

I'd hope that we could get this all cleaned up at some point -- 
including hugetlb, because it's a pain to have the hugetlb special 
casing all over the place even if it's at some point a legacy thing (we 
all know it will stick around for years to come).

-- 
Cheers

David / dhildenb


