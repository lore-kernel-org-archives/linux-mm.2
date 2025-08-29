Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E30DCA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 14:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812B38E0010; Fri, 29 Aug 2025 10:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3318E0001; Fri, 29 Aug 2025 10:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AB78E0010; Fri, 29 Aug 2025 10:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 557028E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:37:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F02F613A7F4
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:37:35 +0000 (UTC)
X-FDA: 83830048470.03.D962D6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49ED7160018
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:37:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=efSQPemr;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756478253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FneLljPHDM9XgGJyT12mwKiq6vPBg0z8/AklpfNT7Sc=;
	b=NLfn3qLoX02oAe5fkZ0oCFldBgUtpdvM7L4JSOHULfyGBnBR4gGwxxYjk7sko893Laey82
	xICtTAIOb7d+SOHzr/YM39q/SxEXbAb8BLOwaxte4ez2Fap2ZheflCoekfrfT2MLYNEUQg
	5NV0SlAmhSXu7Oe3slgQiqPn+0tzY28=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=efSQPemr;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756478253; a=rsa-sha256;
	cv=none;
	b=TjIThrwGPRQKsjW38jsa8dBYWpe+G6knLqRgharVZ9rzQFBF3/On22rT1NnguPjJ3XRzL8
	LYtLUGg3s1LaqiUJsk41RVZAtJ1OoV1ZxDMSjnkK07XQdhUagkTtbd6w6i0ZRJPZsb8mjk
	TTJWpGm3cBlz1ZnIkoruRLOg1tK9bpw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756478252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FneLljPHDM9XgGJyT12mwKiq6vPBg0z8/AklpfNT7Sc=;
	b=efSQPemrp/EfZsndqVcPvEjCqu8w0hRfa6pwnWs+KmWye8oDIlg1vgksqlv1hcx6ushcFR
	8wQinQ0937WyV+JmIW0uqR5oK7NZVg2wBaGtw5ryzqvE5BCdo6gP5+YHIjVxsCJI2gRLoJ
	/sCD4nd9T27uCze00pYeV4gq9JU8nGM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-OR_xSWPQMkKaCF8Vt-88tA-1; Fri, 29 Aug 2025 10:37:31 -0400
X-MC-Unique: OR_xSWPQMkKaCF8Vt-88tA-1
X-Mimecast-MFC-AGG-ID: OR_xSWPQMkKaCF8Vt-88tA_1756478250
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3d160b611fdso81785f8f.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478250; x=1757083050;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FneLljPHDM9XgGJyT12mwKiq6vPBg0z8/AklpfNT7Sc=;
        b=U+Sv2H018534OBkHQ13NRN9O9GuVuwBBtgcsbeBAtnrMGKM+bQoTSYNoVFediL5IW/
         mV87XvNVMTEtRxqCAxAStChln86vDFx7GRiSG2VVwAQ7eei8cuhgX7fNKbM8tuPFbt3i
         DMD9+fV3+MOz9+9OkQdAbwajg1arTLNIHCW2+Hvdd+7DNYuTWGmoT9BUtGxjjtiM1/gg
         L//1fdyOiCxgjIbKIaBiFDc/N/qU54Cp5iKzSVODPvxCzrLZKZU2AevWnqP2DRNgYG7d
         XwEn3D70hpEECY16d4byQSS/tdiPHCBBv7hj4HKzmFkssbQ1LIbBYiiHHxpPzuleSa4I
         /4rg==
X-Forwarded-Encrypted: i=1; AJvYcCWsC2e+2RVrl16sttSgiDlkyy3SfhLxDJzedFI3uyeR+YPB4mjrqGbeTV4nml8zsEiBwEjH7lYWJg==@kvack.org
X-Gm-Message-State: AOJu0YwU+ZHhoGFOqYSrf20kOVIBVO+Bq8F8Xvz06FLbAgE46d2nF3Qr
	bN+OVht7do4T7RTaCLwlarhVnf2KHgC//FrtrGoxUUtTY3hltGXBUt/eiQdtx3z/MRLED/uCJnR
	JkWKQNgZgliaX/quZLVJ8cUWAqicfdoIS5AmecUG1cp+Eq4J21Uf2
X-Gm-Gg: ASbGncuALjyvUOU+uBadreL/0k/L9hd+rJQZnT7zeWw9LCrFa359BPbzVp0W0Gs1yj1
	1JG9PfEZOlzl1WdWPl2IZaZ3rUQ5cn2SnY+FDilVNDfuTBty2UQajij/efLytRltDB4DXFr5CbJ
	JoZ/AR4Bnvo7yFOvJ9sZ838jFwxecRI12RD9SUlaC+KZqsVPSANEVtEJqUKWrU136kBgg9F7o5a
	OQ4sOGP9uWbncQpjMeye058pmeuLam5A7ASPsOafARsoccwkaxYb4ba10wVWLTEsSU3mxXqyPtY
	bP07lck7ytWgfgoXSwDo2sWvB75LEigq75Buw7MseEiXlobbiZsoE9uzF/t23oQDEtjjPsn6tvM
	IOrDBF7gGhUfP/vDlFWNxe76pi02SZyKvML9roaKMksCV6wr4Q4rvf85b8pD50swx
X-Received: by 2002:a05:6000:4181:b0:3c6:cb4:e07a with SMTP id ffacd0b85a97d-3c60cb4e5f4mr14776410f8f.30.1756478249747;
        Fri, 29 Aug 2025 07:37:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHovUImNhvkO1lXs5k4xADHmBMPjxYhr00MTNQwak1+GGWTtZ4Tk7PPjO6gfl53i+oo7PyhA==
X-Received: by 2002:a05:6000:4181:b0:3c6:cb4:e07a with SMTP id ffacd0b85a97d-3c60cb4e5f4mr14776347f8f.30.1756478249246;
        Fri, 29 Aug 2025 07:37:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf276cc915sm3557153f8f.21.2025.08.29.07.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 07:37:28 -0700 (PDT)
Message-ID: <07b11bc1-ea31-4d9d-b0be-0dd94a7b1c9c@redhat.com>
Date: Fri, 29 Aug 2025 16:37:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 24/36] ata: libata-eh: drop nth_page() usage within SG
 entry
To: Damien Le Moal <dlemoal@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-25-david@redhat.com>
 <7612fdc2-97ff-4b89-a532-90c5de56acdc@lucifer.local>
 <423566a0-5967-488d-a62a-4f825ae6f227@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <423566a0-5967-488d-a62a-4f825ae6f227@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BTcWzp-2FUi3ER3FuOjecng0rMjiGqdgTy_LTJb_S_Q_1756478250
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49ED7160018
X-Rspam-User: 
X-Stat-Signature: k875119o3xmp99ok44sbgstdgniwcb9b
X-Rspamd-Server: rspam09
X-HE-Tag: 1756478253-115448
X-HE-Meta: U2FsdGVkX1/qAPsCTPwuMLrr/mqSh8B1fklZLoplposFmP0TVvo8loZ6QRrnZKdVIdCdhse/60zDlxj6SNMphrCNxUdTFqVmUMPaoSURui602T4Qbyj9WK2rjodjfEaxNu7Skt2OV+k3Ot6HGW7WkQy1YYQ3he41w9L2loFN4zqUESP3fc/vnAfZEApVkS5V+EzicT6PY806RF9vu9pDgd+IQd7W3qnR03WspEIbqEW/mnHNUH8aOomz+7dcMA099UF8XJpG5xDhkSpYiuMluy75wZCdlafxWy4/5n/QJ+HXFsKnE1q4LNO79CsthAgpgve81j5570Y1emmgD/M0VC8yFXDAUrxhY69vshZF6LDTp3j1VAsRAL+7wVlciRVbAZdU0lhYvg/4fny/KSA44rUYLL1Bi1JqNqQ1sPxquLmhBhodbPp7IcZFY2t3zdg3SrrKL7d1cRtPeoUsvHgWqAg7F0J/tvKDUnKvf+rePQC8Zj9rKbKxRMlCH5ipCT/xDZTkVKxFViXQeJLD2x1w3oSCv803LrdzB4tlzr555Wssj7nKXIFOe07YtdoTEK93wYUe1b26E7uL0Qni/7bMDpiMYcPZbbL3cInAyo+bksRuukzCJYQovUDeJ8ImIWqTUO7f4dV17On4rDtY44tDLMurplreWmfV4x+sUIt/EdIq8LAK2OPcQuZwT9O+qGfhxqx/oWRNS1tFgER7sZ3U11/Zo64YXqXyx64T7AzSnbStPo9PKpZuJn2KFKd0Lg5fEnTUj/6hDUFlJDOK2jd/FXiEz/Tevd1cJ7/ZTpvfTRdf+QnhKlHl80HBjPX0xK67zXFSPGqZaWIyrQj1srRkZHnW2DWyjJL1dWch018lU4Ge5JbDVw2MSHRbCPxNtDS3w+pRKjlXQVu9H4Z/2WaHEgGVcKBMa7AGolcsIvlODgrmY3H1egcdPeYHceWprOblI0H87orsWGcEQk86lM+
 I6GriMdt
 dqnaP4/xObEs3IU7l981FetAw/QMPOgdtcKEtPbF9SseX2oD4w6DX0AL4NnISwzcf6aLETvqUNjhHAgjZ+V+rXX7oCg9SMQPi3lpkIezPYhYTWq+HPTHnEVrMnlcBBCqGxEFv0ua2FBkBgoJ3kqJht6Ui8/UvZBNu2ek5196sGLGD5/OvCrJ2bWduHsJYTbjT8u4lzN7UvMvEBwPq/1gJsZ0wePz/deCzPv2CpmryYUHFDrUZYNUvqbUGOUNJNfcZiwP2aHmiW7BxsVPCMeuHP3w7XHTVlD14L9/TjbLMuZ8sEMF7mS+VhbJbKL3zsGjnCRNsFXUZgUzrOspIe0ujqvV+pmhFVhHh7U0TccQ3nIbUkYZ/Yn9Mx/KJWXf3MAsAHe/gY+P4GqPvqknl+Fnum5bDexIl9G3mDO9bEdbQsoy/uig8WuxCOEumOCEaJh48HM/fR62J4weIJK41uHT0QONN9G5B3cA1CwT9gquGYwWqIG6eKJ++Njs27sykG/3i/9QT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 02:22, Damien Le Moal wrote:
> On 8/29/25 2:53 AM, Lorenzo Stoakes wrote:
>> On Thu, Aug 28, 2025 at 12:01:28AM +0200, David Hildenbrand wrote:
>>> It's no longer required to use nth_page() when iterating pages within a
>>> single SG entry, so let's drop the nth_page() usage.
>>>
>>> Cc: Damien Le Moal <dlemoal@kernel.org>
>>> Cc: Niklas Cassel <cassel@kernel.org>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> LGTM, so:
>>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Just noticed this:
> 
> s/libata-eh/libata-sff
> 
> in the commit title please.
> 

Sure, I think some quick git-log search mislead me.

Thanks!

-- 
Cheers

David / dhildenb


