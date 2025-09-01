Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD94CCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D758E0048; Mon,  1 Sep 2025 10:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E068E0062; Mon,  1 Sep 2025 10:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2295D8E0048; Mon,  1 Sep 2025 10:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 101088E0048
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:56:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B06E8118BAA
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:56:46 +0000 (UTC)
X-FDA: 83840983212.16.B97D490
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf25.hostedemail.com (Postfix) with ESMTP id 33C8EA0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:56:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="Zz/3rOz0";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf25.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756738604; a=rsa-sha256;
	cv=none;
	b=f9fy9yPn1l2BaXYfJF5/OBqDYnkuHk+Tmhs80WyUxk6piVPrBVITcayNPVXrH6KPwhoPKj
	ptWLnte/HF3KQmbItRRmonKVyMKlFGuTq7xGK0ixx7ZCxHre73Drv3jFfK8DWQ1tmE05Ay
	I9/roD/JelL3A8VbeTZdveK0E9NKJi0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="Zz/3rOz0";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf25.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756738604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzdixQuy30cIOdtGPtZhymwxAjNsuo6l8KhPTQzil28=;
	b=IjxLdxmsl+L/jQ01keSy8hUR9ZWHiTYzl31upDdxXtORNxx2XYVaKEE4j4v9IxhZ+CcLK8
	V5lsVRu/71J/VrBJFWhD+O4uDH+2Ehi1hNW+OKeWvWg2+fb1rVu8IbrgdchKIxTaQv+PBK
	qqbh9l7tTciS38j+laHxO214wtzdO20=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756738604; x=1788274604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DzdixQuy30cIOdtGPtZhymwxAjNsuo6l8KhPTQzil28=;
  b=Zz/3rOz02k0CZijphqp9ZkI2uI+MNzRHVUtqSaZj0zco6n+GKXQecmxT
   v0winJS3clIBs3DoevV7i21tnrZHvkBYMIzZc488ErWNdDvdPuLXFlic3
   NuB7uWF4peU+w6IYuB5aimAFu4wNfAFqvXa/fFYQIGJnFRMcutOZpWs9f
   oqYoFpzHYBbU3aJ4Z+RCn5ucKCSQzhGWMN10ISnPXJMlsJ+uYjPy45Lsu
   ghCjiS03i/pxxXd1WGydNCWFW2Jf3/yYQg5NHwJNGCbTfwbYRonT8wMzR
   T34wslWVo3fHlrDg31uws6b6a2gxBCVEp6Bz6wBNIukxyJOYNZmEjo2B4
   A==;
X-CSE-ConnectionGUID: TP9bWQ1xROib+ix+/ngIXQ==
X-CSE-MsgGUID: YwAZ6XeoRvujHV/6Dg0jJQ==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1364214"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:56:34 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:28303]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.37:2525] with esmtp (Farcaster)
 id 90fd1a2a-3fc2-46c8-b14d-04ef65bb514a; Mon, 1 Sep 2025 14:56:34 +0000 (UTC)
X-Farcaster-Flow-ID: 90fd1a2a-3fc2-46c8-b14d-04ef65bb514a
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:56:33 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:56:33 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:56:33 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "Roy, Patrick" <roypat@amazon.co.uk>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0fkqK4jccjXtUKv/NLtaS3P1rR+aqUA
Date: Mon, 1 Sep 2025 14:56:33 +0000
Message-ID: <20250901145632.28172-1-roypat@amazon.co.uk>
References: <20250901135408.5965-1-roypat@amazon.co.uk>
In-Reply-To: <20250901135408.5965-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 33C8EA0008
X-Stat-Signature: f8jfajujcdq1gudjp9fp6a8u4amn1zu5
X-HE-Tag: 1756738603-902745
X-HE-Meta: U2FsdGVkX18aJd8UJk1couVDIk2HYy/upH5JylbbYy3Tu96eq705Plpa08yLFjh2M3/vXgUQH3HYvdXdZbAKEbNmnMJv+InvBLaY2/z+8v2nPIqqboIXF4bVFwd41xTBsod28SN7eYFZZCxLrAd5zV/G4ASczCbwzJQoet0aPdZCuQ4ExIVdJo9UN2O03LENM6Llzy0d1kf1EAZwBZco16q+Ft2SlHmBLkDmoHvzn5ygNgukDz5tTHmGTd7BJUSvcZFLDUDoYEkBNkCtOy16WwWeUOxJygpzgGMx9gE4DfKNquIjHI5nfSbzKRxes08g/O0hQ3pJXhBXxUEEWSI3YR+n9nJ0hSYFOVyZ5aeVkOP/UZ6JjK+w6fVj70WlYRXJ3OKonvlkzDGeKtFEVIaBNYEMADQ8G4GGDgOcRPcDlIWwxyXy8fhEJk2rg7nBFts9IIAhW5VnzoYlU8/IDqawYvuohYAmnV0IMzEEbOTe1jO+YBzI+0zqHqjNgJFYt8aoL+6dYptCFu79KuMmIg6uB5iHO8MHDv0Js933bQm1mSSrc9YwX+VCYXCuMmclCPW/Ecf0pbzCRG5EUzXQu081QwUGoMGL7qgjg8qdF1gIkQC8jc6wCW/xYRtLOmdoEGc66TnoP+AtfmRRRDGEoFrRmF3bw+uatIcS5LD1oZT2kDjmLti/BEZ7GKzp0I0SHyYI2R/oUOiY2aUiXHO6G6/B3QswGN0ZT3K/epOpN0FLinMy0BxVPJhFoExKox5Pz+Yd23iKWGSfHq68rc3BNclZ3F+5dD9STldkJImJ4jQ8uhWt6Quybax1QpXoEws/hr51FzyCImiwjWYXfp2NShBF9UaZqQjC/vEbprtKJmIgkxxNswhjY5qSKyEbIfzUZWbEcff14PGymmzmndv3wPEw8yj3ePbhvjTDcWUFfLIFUgvm5xVcQt5xctH+/9osZZLPxMrVK4g09lmJJ4P6yDz
 HnUBjj5e
 vwSGjSbyJ+8uvJU7rylVk2hPBcS8IZvhGe/1ZGsAlNJlqlAbiaJCdAvhGr1hSdXDWelafTggllS5aZUA061UBhQ9Vq7LsFdJFaMR2fo/TOX18wd6GzWg7j5lbtH5OO24ViGo/NJoarGdH1JYi0MpogWph2WcBgtxNULMC0muPjUnmmKoWB55aWA12EdRR9VTOMqia6/wMA/lbGT1wliGILpG/Q76XXDYuATRjgxfnlFtE8bmbguHMjq7wAL/XaSSIBmSr+lMltAlpfDpKJugm8oJQGNTDMWGYolAYsh/wcldXxpEsr1vEGhbVREIahVMHfFA1osjfptnzaET+NsOOQeDQcVr/MkEg8eHw25DntvKlluQpeHPDBH6g9WTtIwg+301wtoZd2/sAYgxG6/8aoCBJWmLH8alHF30mZnPrPdNHLeOZszsPcBpxPB96+BZumCXRKdLGPFSizr1AE83Bzv5E7OsEX9Yh/o0khCuJQ7GKhni9YNCFng8l4F2E6XoDaimPfyxb3NmjYyxx7ZpSyL78qUl0tj4X9F+NZDv0Hw22ju4zQNBs3apNPsAW+g96Lc1gIMxW8RhUll0ZYa6CsGysMfEzLgbxLtVG4Ad97EwAXV17yZEhY0aFiCk8iP+hhSJofRfN5w9MMRpNe6u9OIM+XnpAAKNPa4wVYPSoU2YozvTUURKiXTIGb9aU1n9iGPxWUCYhiNdzcY6uO3urOjYbEZSQMYBVHVCpjwEzaDOtYz6kmDIg7weeOGqVWDmY2sUXPggRtAWLLSGwnvkWcbmSdCfG+LYzTMHr/a4pb9Vt5NjvSO2xN/2bwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:=0A=
> =0A=
> Hi Fuad!=0A=
> =0A=
> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:=0A=
>> Hi Patrick,=0A=
>>=0A=
>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:=
=0A=
>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
>>> index 12a12dae727d..b52b28ae4636 100644=0A=
>>> --- a/include/linux/pagemap.h=0A=
>>> +++ b/include/linux/pagemap.h=0A=
>>> @@ -211,6 +211,7 @@ enum mapping_flags {=0A=
>>>                                    folio contents */=0A=
>>>         AS_INACCESSIBLE =3D 8,    /* Do not attempt direct R/W access t=
o the mapping */=0A=
>>>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,=0A=
>>> +       AS_NO_DIRECT_MAP =3D 10,  /* Folios in the mapping are not in t=
he direct map */=0A=
>>>         /* Bits 16-25 are used for FOLIO_ORDER */=0A=
>>>         AS_FOLIO_ORDER_BITS =3D 5,=0A=
>>>         AS_FOLIO_ORDER_MIN =3D 16,=0A=
>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_=
on_reclaim(struct address_spac=0A=
>>>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping-=
>flags);=0A=
>>>  }=0A=
>>>=0A=
>>> +static inline void mapping_set_no_direct_map(struct address_space *map=
ping)=0A=
>>> +{=0A=
>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>>> +}=0A=
>>> +=0A=
>>> +static inline bool mapping_no_direct_map(struct address_space *mapping=
)=0A=
>>> +{=0A=
>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
>>> +}=0A=
>>> +=0A=
>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *v=
ma)=0A=
>>> +{=0A=
>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_ma=
pping);=0A=
>>> +}=0A=
>>> +=0A=
>> Any reason vma is const whereas mapping in the function that it calls=0A=
>> (defined above it) isn't?=0A=
> =0A=
> Ah, I cannot say that that was a conscious decision, but rather an artifa=
ct of=0A=
> the code that I looked at for reference when writing these two simply did=
 it=0A=
> this way.  Are you saying both should be const, or neither (in my mind, b=
oth=0A=
> could be const, but the mapping_*() family of functions further up in thi=
s file=0A=
> dont take const arguments, so I'm a bit unsure now)?=0A=
=0A=
Hah, just saw=0A=
https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@io=
nos.com/.=0A=
Guess that means "both should be const" then :D=0A=
=0A=
>> Cheers,=0A=
>> /fuad=0A=
> =0A=
> Best,=0A=
> Patrick=0A=
=0A=

