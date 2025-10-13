Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703EECCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F60C8E001D; Mon, 13 Oct 2025 08:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F468E000F; Mon, 13 Oct 2025 08:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846568E001D; Mon, 13 Oct 2025 08:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB3C8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:31:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 041CB1DFF65
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:31:43 +0000 (UTC)
X-FDA: 83993027328.21.D38F539
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7546C1C000B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:31:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PmUtwIGL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760358701; a=rsa-sha256;
	cv=none;
	b=KmDwplRqa7L5QULGzqAqzixapXwS/B7Gi38f3OL0pGWPrv5yklnghK3t/Cbt0ImoVS6GsV
	07ZrnvE5ju9bSq19uNUScbVhgQLfj/BaFPOSDDh1GVg8TBpTI4KJCoo7WEt+ra+/Gu7DM9
	BkOVPVEvjNwK3Gz/tQcm5JYrBf4NQmw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PmUtwIGL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760358701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dwWTFnY01JMgC2QZA9VOzV/hbuJXScWrhj4pWb1ZI0=;
	b=LZRHDhS/gnBiJEiCWxRA7O4hOnn0wKt5lyFrMs59k3RUVLhNKm+NPVEXmAl0YNnXzABf00
	v5I4Ij/cxfwsKnGHu3IVgn6atMdllfo2OdAplSKDPTTVchqwX8NeHr6pjsjXZ99llRqqaa
	Zu2PUjOagHUHmgLyeFQEb/8mSdeAvSI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760358700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8dwWTFnY01JMgC2QZA9VOzV/hbuJXScWrhj4pWb1ZI0=;
	b=PmUtwIGLpsjt9z3MBu1HAdX8IR4UPN5deiemhTwfNw0z7NJxo/+PwmyNea/1JeohpccF8B
	b4nV09ruDBvy3Q6372g4rGiZ+bK4RU3qHfAao3+3nkn5XvQDq5zufygBEwSsa+/5+o5ZLQ
	lgIDNlFCiUk0U6GQ1bEAnEDmFzZXa4w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-otMJhu1mMkSrQybzsX6gHA-1; Mon, 13 Oct 2025 08:31:39 -0400
X-MC-Unique: otMJhu1mMkSrQybzsX6gHA-1
X-Mimecast-MFC-AGG-ID: otMJhu1mMkSrQybzsX6gHA_1760358698
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee10a24246so3688987f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760358698; x=1760963498;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dwWTFnY01JMgC2QZA9VOzV/hbuJXScWrhj4pWb1ZI0=;
        b=f+Pvuo2tx8LqCeY69aNmi076cfDd1SQE2gfsUHx0sRv66twY2O3zBJ6XxOKH70IBha
         JFMGFVM5TJHNGD5l/uepHeQ37d7wv7NKnO9SwTlBYA8d/MUepsqyN1ivV+GKVDajuNJ4
         g5USECMM65nIY8EBGCYn+I4Ng4mUq7PpIaweQqNFI0IH8ST3RaUzU9xOLIDiAh8bd1Tf
         e9rmSx6LRc6wP8RRQTh4aoZvhvnkYfxxUIQg7JeqQKSGt4FAobR+rOTuDi+U88D0FWzO
         fDxh9HXLBfY5JlHTife2NobNdR+/CBySPe26udB9X3py1CqKsg5s+7+wxl0HwJUQHzOF
         unDg==
X-Forwarded-Encrypted: i=1; AJvYcCWfsEDQ2LA2NEYOdj100JP6At2nN4wJ1KnrZzMqZe/IndpTa7uypQuIN9v+gRK6dUe4Df++jEO0oA==@kvack.org
X-Gm-Message-State: AOJu0Yy2Y9Wn4I8NbK4cyk0YLzRM8clkguhFolfFde+et10bgOhpSI9Z
	OBaa/RbyYedGVbkv2OIDjHE4/E0DDngyAmgi73zYZCi9PqOroanU/OcGkSNOn7YqqMLMosItxka
	PdMQS/93C5KsdamAm1xdVjEc7dNTZ38QW2iA4PXQojoTwWVRYBPfI
X-Gm-Gg: ASbGnct5XeIH0VtkEdCkRRw2GEB38u72+y67VRdXUB3obDgxsI1a4HCPQyLqpF2aj2i
	0DdoZrp+F+xn9yC9LtqFLyozi/JW+BqzN4/FnHj5u2PJuJ6x7OZeZyue7J7XRkkmB8g8CfoA2nQ
	f5rF7dEB5yfXxRGE7LtcjEYNROZC5qufB3FkkwCK4W7hKwGBP5vnxO54NS7n/wC6a3ufoq4QIvE
	Ht+Om+sZ1DmNOFBR244DEjy2GQIuEi01MMTz99CXRHHQ93mqYmqKVcNJMNb80nJnK9SWHGYE3xG
	02/4z3MU+bgXpyxgPu4cw8baNNwrvfv7FKZdsjK5FAUF3qlYX/GDb2zspABlld1bZBV13smxREB
	b6fE=
X-Received: by 2002:a05:6000:25c6:b0:3fa:5925:4b11 with SMTP id ffacd0b85a97d-4266e8dd4a0mr13112714f8f.42.1760358698310;
        Mon, 13 Oct 2025 05:31:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+rKhnncBM0Pv8kGyJiO+9pTdjKjpw6DAdSdAl+kaHZP46I4ToxAgGKi/qAMrrlAgZkXO50w==
X-Received: by 2002:a05:6000:25c6:b0:3fa:5925:4b11 with SMTP id ffacd0b85a97d-4266e8dd4a0mr13112679f8f.42.1760358697872;
        Mon, 13 Oct 2025 05:31:37 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e1284sm18037134f8f.45.2025.10.13.05.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:31:37 -0700 (PDT)
Message-ID: <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
Date: Mon, 13 Oct 2025 14:31:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Ye Liu <liuye@kylinos.cn>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
 <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hOpCD_w-AHlJTaKlZeqbvpn6Gt8BhovuAQ2LqIDaD8o_1760358698
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7546C1C000B
X-Stat-Signature: y1yqsc13xfdkwtqqgew3it7zxcn3t89p
X-HE-Tag: 1760358701-15269
X-HE-Meta: U2FsdGVkX18fuEgAApv0BxBDczjwgmTvls+ydbxL9fm79hPi8wFqaXg0zTKMnifQuKHrdjurJyK8s7hKTE/oq47Z+EQtk/5QESpeXVX1Lr3IVqh7G0jgsoaWDWufsGOeuKTPxBClPr+bfn2KKpxPq10/c8zhIDplMbgz41t6NSSRQ58FF8lxhn+Yo6BcaD5kAuCxH60bvcZoZ2sH+Uhf2cM8AZ4qOWOjVm++q+cEFzCVO2gw5GHsI3uAuu8v9Kzj3KAMMhyhHFKaUlv4ECxlVbCCMnCUEcX3qUigNTNjI0i5F6bN9yBs4upbKGr7xGPJn2hO4JtuQTHfcK8jNCXdFIyfqnZY06YVIoU4URu8Tsnj8IGTY3X5fUFbxpn53BaW9s1BDyD83kVAsyW7TLGeO4PG8Wz9sGKmhsxu+e5agxZwAxX58pNAm0ulcyA+VQa0AE2Cj0Pb3uQ6z/A4A1eHkUpBWFf9GknqDvXyxHz8zmztS+M/t8goIe0wc+aOmZBMAeDyW6Z/Cmr5SjC6uDbo/qvGLNiHC4JRgXOFhKYcYCbpEsHYNpQswDlCyDcZgTFaV3gXLKjeGfl1grohtRLSMphKNBYasWCCk8H7MVr7IQBbSQjT//6czaHclHMmQ3A/0OfSev4M+fYUUNqXfLevtuO34tjrCkps5G9+uhqhyP5Tro4gfzhkvhPozMWK8LesqO2OGea5cJxCrFaGGrstEgP+sJc8Unpi4hhCm3Ggd1M5Guq88eGTbwO+NTjDC0Tq7/SkiB+Slj9dkSK8+IdIcFfeslAI0RKmZHgPZMYG1O2dBf9KGM4ZW+tSub3DQbsP0yslk4vgJ9Uu3mDzMlYNGUC0Z/2G0+Iz2kNft8X5k651eoxvoAh3N6DOVlJsjR14JbmzOVIp00XTFeILvyHZSit7q/TBThkA7fl335avppUfndtwDBsiznWFfSvUTlEKaLYWkYZ3UxZHSk5s5+B
 gSd8W0ld
 ZJl/a40GGUzunSaRmffLkcWGSopUtY6K3W0+zh6GKhrp/B+Zl905wm5GqEF1VRxS2BTicstrAmuc1XlrUvCJbpi7zU6mBZmkQuI5ZxhITquaR6JdU0CaB2dLd66NFMqGos62myBe9vbj2KGzWpO5hF9L7eHLCkBLCs/TqcuTCzmOIoJGVo65VczW+z8toZFCsRa9UlL8JO7QWFqEB8RuMUMezYBUvshPKvNd0oWfAPzoT0eQeGeqSpLuu2R2L7oWT6XQElvbajXPcUln8dtpkzC8ccS5gqR92ZSIeOQGDne/IITU0KnV5SutcJYSwKD5vvO8OW0veS2eoAimif2m9kjJ6TOB4N+D6iUCcas7IrHQGU4Lu4xHxL3MZAmiOqTvOe0UP9REO94flACJN4Pbd2dDNp4ApzXjGLe57nHoVF+TernbRBl9zt5IMlxYSEIlGC4agu8AfmZ3mDNIhkRr6Wva9pXXIWOxZBzXH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 13:33, Lorenzo Stoakes wrote:
> On Mon, Oct 13, 2025 at 01:12:20PM +0200, David Hildenbrand wrote:
>> On 13.10.25 13:04, Lorenzo Stoakes wrote:
>>> On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> Hello MM maintainers and drgn community,
>>>>
>>>> This RFC proposes to convert VM_* flags from #define macros to enum
>>>> vm_flags. The motivation comes from recent drgn development where we
>>>> encountered difficulties in implementing VM flag parsing due to the
>>>> current macro-based approach.
>>>
>>> This isn't going to work sorry, it's not valid to have flag values as an enum
>>
>> I don't follow, can you elaborate? IIRC, the compiler will use an integer
>> type to back the enum that will fit all values.
> 
> switch (flags) {
> 	case VAL1:
> 	case VAL2:
> 	etc.
> }
> 
> Is broken (compiler will say you cover all cases when you don't...)

I assume you mean theoretically, because there is no such code, right?

> 
> An enum implies independent values that exhaustively describe all state, however
> these flag values are not that - they're intended to be bit fields.
> 

Observe how we use an enum for FOLL_* flags, vm_fault_reason, fault_flag 
and probably other things.

But more importantly,

enum pageflags { ... :)

-- 
Cheers

David / dhildenb


