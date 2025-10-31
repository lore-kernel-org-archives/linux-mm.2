Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DF5CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B30D8E0111; Fri, 31 Oct 2025 07:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763238E0042; Fri, 31 Oct 2025 07:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651A38E0111; Fri, 31 Oct 2025 07:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 554798E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:12:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E77EA58CA9
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:12:48 +0000 (UTC)
X-FDA: 84058146816.03.D6B2FFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 66B0640009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:12:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NWOd+cVH;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJMjuxukAWEbjLCeYadmdpTDIoQW4n3g3hPUHczSukU=;
	b=HAcJ0ajLOWsTXk+jS5JV8zVZahNJ1O9Hrm45vq7wedURL6OKVcmccXqv8DhRTedyAPAYAH
	TVSpTHbknqtwUfCVqjaX3A+RmLujFUJxeEROdIiSOttosY2k+og81jJ/kABiD4B3bLiHhg
	rQ/mbTflfF3cPGv3NGGcSXpqulspipk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NWOd+cVH;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909166; a=rsa-sha256;
	cv=none;
	b=1fH6A61aBy6DiZq3zKTI4KOTSGe06fq1hehfchKv6nAi+MjJSaJRfvmLEKJ5hc9VS3oEOF
	7RaM6LVBV9aHDtOEv/WFGkV39HsmbVqBFjqNHv/c5NnAX2YSGcahOwspZGU2Gl8m6PznR9
	KJ4fxtofqD69ffp/uI+PTj9cySUFlB4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761909165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hJMjuxukAWEbjLCeYadmdpTDIoQW4n3g3hPUHczSukU=;
	b=NWOd+cVHr9xvjB+c4+an4e+G2sMtG+Iy5OPKA+bETiLEwZSy8yp/bvxlcIL6QoBuv5Vpue
	jktiq4c8kBEm3Aifn/B4I6Q1AboVpC48JGFb/CftoUaDLY5bydsPrgsIqT5VIjPGpeFE0R
	EeIqpd4B/yBw+uKGgJYvQJnBJcdK2wY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-UqyLRdAfPTGXDL7egS9qLQ-1; Fri, 31 Oct 2025 07:12:42 -0400
X-MC-Unique: UqyLRdAfPTGXDL7egS9qLQ-1
X-Mimecast-MFC-AGG-ID: UqyLRdAfPTGXDL7egS9qLQ_1761909161
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475dc22db7eso17771545e9.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:12:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761909161; x=1762513961;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hJMjuxukAWEbjLCeYadmdpTDIoQW4n3g3hPUHczSukU=;
        b=MogEpIPiLfcOwtRTUkBppHCmT5F6KdLs2hBs2sra3W9ZucyAdm5OwzJrj0YpipycbG
         Tak8t26npxvYViUQgBpG6U78+Bm6CTXZLbAds1XacAppsXp26fwIN172chip54YaPYzf
         Tvx23nAi8CdoUTcugHufOPjw0y/8ymtiVAfVWqYbiePW4GRAoLr7WXEGuMH2EU9aHY8/
         S1G7Q6i8KSe2ocfRnXZvCR8Et/XJMh0cJWkHKcbBEvVt7oDRp8bJmKqGkMf6IBiEBVql
         26uMjjvfJHN1ce9oPO8FSy0lruagC+2nqg5b0294CtdQO6T8rNqjrxQaDRhvl4+BoAFq
         I6TA==
X-Forwarded-Encrypted: i=1; AJvYcCWZQKtyXUZwOlfvoBwEDy1Zpd7e5dl8XXbbG7B8Eh0pSanzOEVHM+Gm7q16/BccRBrsfDzoty71zQ==@kvack.org
X-Gm-Message-State: AOJu0YxNtS6X1f8RcieIF0xTfAVuIXSil5amq1H+qZANt8F0j44IdBBX
	8+vOrAhynXIqyYwymPMIbTWE6RUC12AKcz/YG0QArx6h3I1KhRzhEFdXaezTuJda44yqz72CoTk
	ngeAVVVrBhVfuBbCkgpqYHTe8DU29V2gQc7EZ+huKNhInwgVw9umz
X-Gm-Gg: ASbGncsqZSp4sB7vgaSmHDwXfxeGXU4gevoiGmv+HcaNRHFpg3ND/8i/MdlfknPkzHm
	5R8pVUxq7wlFkj13GyKbdkU1FFMCGtvqIlJTlhpsIoYg0GqL1SZahh7INjgP3Bovczxlz9/DUrJ
	WqNNf3JlCoW5Jva0CSC8AhcWKZGK1eXvJW1hZTJisGJETio/p9DracI9YHSBjC7m0GzLiqjj0bU
	oT3s4SDTgi/2b2viwck44S2eiRXqLacqv7m67ri+XGISQJCXFTZOYw2GFKQf0mKoHzvi2aSDQf1
	lvFTPo5A8RgF3RNvcvX3yrKoKyU55yRnyJU4GPSSGWy7VMYxlzOWTIvb8DM0jrn5XGD74PWWXmh
	w2ZOXOXgbzuS+0ct2Q46P+nLeHI2X65mX+zIREpcMPh1Bdy72IP82dov4EqtYCxlMjCzEsffwBY
	nTXjFxMIFSVv5jVB23m8OZMIDNVVI=
X-Received: by 2002:a05:600c:4e43:b0:477:e66:406e with SMTP id 5b1f17b1804b1-4773088be60mr33550575e9.29.1761909161092;
        Fri, 31 Oct 2025 04:12:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA2tXUGCsDUMR6vFGWGQZdO96drmXylly2cBlXXBXlMiJWZFIq3SyIZffRE2pcpjTww5hO5A==
X-Received: by 2002:a05:600c:4e43:b0:477:e66:406e with SMTP id 5b1f17b1804b1-4773088be60mr33549935e9.29.1761909160613;
        Fri, 31 Oct 2025 04:12:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772899fdf0sm87665605e9.3.2025.10.31.04.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 04:12:40 -0700 (PDT)
Message-ID: <1c0c89d3-0f72-4631-b1fc-41e1426c8bed@redhat.com>
Date: Fri, 31 Oct 2025 12:12:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
 <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fHu7R0gKZhrF1uK7D6FjmCRWce0BaO1QltK6lIv2MaU_1761909161
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66B0640009
X-Stat-Signature: wsfof944te6ypsfqoahgfft4xadqcq8q
X-Rspam-User: 
X-HE-Tag: 1761909166-962228
X-HE-Meta: U2FsdGVkX184D77CkkjEraWS2y04eS9PhpI38FTUNqfyDLyU7mjKnIrvwNyExg0GPcHe1zsHaExjpH00Qd5OnLFiQNiezSqWDOeFO0srS19+pVW/vBLgD9sQdIC7u+ZGrQVE0w73aJiyrooA8y1CRylW4yYNsuCYpJLhYa1dNtBtc5ReXEM631fQoit7fjI/5JlKTgSaMNNEAvqHfSdVbl0VKW2JVxaleW1+/MZSExRrdyd0+eV725nsgca+YXtS5zjxB9jJqjDtM14kuvG3SQwv/G0SbuwZrLxtaZZqS6WE3IDkT7HyIlJUsr4tHR+iHXzoYoWRlql8nY5KNnV1ovDnmIKKoDfPmnoJY3XqrQDYSEpXGso4mF8492drfmcuJY8mbdlKPMSyNfTJ89NBGsms/Do7QGPDxdz2spHNIsPhiRoxzzuC9GJ0FEKEbdGAl31V4ZydeCr2gn0TarXDoEmyZN6naNwgnLfJs9xddeJf4K2YKQxLU1EATCNrvDfKGQKhrTXnMb3COTZG7FfhydvhBOTz9pTy3jlcfGoANbtPb0ueNtRIEhE4xncRdiwbnhChVXjys+WqmodWUT89BJ2SHGrk9VSG9kClaenQFSRuh0UOZ4sAV1FD2XHM1/XCZJHTo2PQdy5LihBR3EoO2YmWjRDAT2zJtcqfUsnHv3Lzm2Np/zow0/2mzOfXB75EQ1tEyLsTz85FenP6wbWbbw/3yhHApUGSqK9VWwtaKEJB8uzUMz3QhYyBUm3GEyrnGwLAbNH2hH7nhBbMy2VnTVeckFjeJ3CXFVGj0/fXWfNHs5spBuz/GGY03xY0MsMm0wx/OMu0xd0FI9iQBxFVfdY5kDuWegw/km7QBzLPrv54rLrX9dYPwzdffKyuWUK8kx1EwAzUU6nyJBEDn9fvBkPqQl2kvI2uAW5WY2rK7RSUkBeH3ecRKoUJhzoSMWG0kPpp7fy9VKNZwRvNS4l
 Y3VDANUn
 hUdEyiOwW9HcoVKnYzKkmd4VIm5IV++TqSRHb8OoIYX0KB5v0FN+g5iWR4T3pAj+e3q1m/PaoxmjiTbBXFIFdv+iq5k1a2Tpg17S/7a0lldW51fVBRBNSe1XBdMNOK+ZNskAjmh2kKMUGuTceM1Fc65Bj7x2SrFEDhiLb2QTADilpWH6Jvx5BBNrOGW2jBtfVj/qmfvQHRIOo7tw/+E0wVxal5JYhUW4ht/WtbIiyW+YikylR8/H6aX4aw4HFx0EjW9+gAZ+9gsfouHAdcjbAV1UcN3dbUlCUeBft6t6oPRvlXZuGqCKW4ZmJVT41i4R1rYIhRuYZgOvIcHR/kEQNNczgh0aJefKm+QefAA+EOnlCpkoSbiMXVr+OSpn8P/nfaE/f3qkrhDJ4u2R+ADLR8DNLUDAfgMCknegIN+xI03S6gt6OuNhOeoc+oFgxATr7D9KpDJduaeEQaUvwXSeYkaoI5BrItTEmpF7Z/I+6PfG9y9IWb8E2aPDRFpl88vMvcKW/Pyn5AzAYleOaqevR0FWtcEUOrE9r7pattzssIcoCKNtDTWrsctqb+g9cT/hC5955nwt8Ugjb/Wo5G6r+xeK/tc+k9HdhZ6V90gkJPp3ERiIvZCEC23XL2nXxriBkIGp0NhKYmNUeEf0+qI5IFaJWvWvpRr4NPADZLmmFAD1BCga2qTCvYEtXw806sm0gbD1azeYUuKwxF0hdkgNMSy+PimKmIXGCodMkVDGRzJphMg9Xn2CjLsykRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



>>>> "eagerness" would not be like swappiness, and we will really have to be
>>>> careful here. I don't know yet when I will have time to look into that.
>>>
>>> I guess I missed this part of the converastion, what do you mean?
>>
>> Johannes raised issues with that on the list and afterwards we had an
>> offline discussion about some of the details and why something unpredictable
>> is not good.
> 
> Could we get these details on-list so we can discuss them? This doesn't have to
> be urgent, but I would like to have a say in this or at least be part of the
> converastion please.

Sorry, I only found now time to reply on this point. Johannes raised the 
point in [1], and afterwards we went a bit into detail in a off-list 
discussion.

In essence, I think he is right that is something we have to be very 
careful about. So it turned out as something that will take a lot more 
time+effort on my side than I originally thought, turning it not 
feasible in the short term given how I already lack behind on so many 
other things.

So I concluded that it's probably best to have such and effort be 
independent of this series. And in some way it is either way, because 
max_ptes_none is just a horrible interface given the values are 
architecture dependent.

I'll be happy if we can focus in this series on the bare minimum initial 
support, and avoid any magic (scaling / capping) as it all turned out to 
be much more tricky (interaction with the deferred shrinker ...) than 
most of us initially thought.

But I think we're already on the same page here, just wanted to share a 
bit more details on the max_ptes_none vs. eagerness idea.

[1] https://lkml.kernel.org/r/20250915134359.GA827803@cmpxchg.org

-- 
Cheers

David / dhildenb


