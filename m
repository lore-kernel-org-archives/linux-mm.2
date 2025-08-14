Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A84CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7BF90011B; Thu, 14 Aug 2025 05:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481DF900088; Thu, 14 Aug 2025 05:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FBAA90011B; Thu, 14 Aug 2025 05:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACAB900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:01:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C16141383EF
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:01:48 +0000 (UTC)
X-FDA: 83774770296.19.386ADC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6571C8000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:01:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WGJpQ/xU";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755162106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+XqrzAGC+hGwyzCk1t4HsbUPzoPVcR/dXMTuQ/fZ9U=;
	b=BAhag8Qgz5KSwyzlA0jTNE+gp2yaNzL1Y+aeV1Y1vJads+D/s8FydPZBY7Fwp1cmk/1prQ
	mOXxk/fo7Mt+YFx5My3Ad748MavVZDbg27Vd2SRm55CzxEDQFCNOahNkK1RE7tFViPJpx5
	rz3UpAQLCMFaBbKf3PdzBo5cFJ7Mphk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755162106; a=rsa-sha256;
	cv=none;
	b=RDcf3GWmNDVT9vplEu9pUT1gUPamFbH7LHR8eqQ0GtBnHuo1lpKVWhZP1Xal2t1WOnDz7k
	EeN4/M4m5kW5oIMjZhNMBimjAMRgu/3ziYuiQTvoMi4tBlRgWPg7G4xGdmCKJlQ46A4s9w
	nDCHDjqLGIym6AyLDlfSqUNPotar5kA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WGJpQ/xU";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755162105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B+XqrzAGC+hGwyzCk1t4HsbUPzoPVcR/dXMTuQ/fZ9U=;
	b=WGJpQ/xUBkSLyIqiNohNh57oIgj/+c3r4XmCQouWilHNxDS+dyFsIhUDf9phso+MMXRehm
	AIPPL0jGa9/mdF5qb1i5b68x6fOpNUPWWXfjgpv3cg4xf4NWLiLxWhZjYzP6V4YA8yA7El
	21uv46cdskNofV9sz/vj1KKPSRQ/9TA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-UIWPHgRoMDGShUp3jhYTaQ-1; Thu, 14 Aug 2025 05:01:44 -0400
X-MC-Unique: UIWPHgRoMDGShUp3jhYTaQ-1
X-Mimecast-MFC-AGG-ID: UIWPHgRoMDGShUp3jhYTaQ_1755162103
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9dc5c288eso473695f8f.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755162103; x=1755766903;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+XqrzAGC+hGwyzCk1t4HsbUPzoPVcR/dXMTuQ/fZ9U=;
        b=uD0tL0gYH3IhAMLcS8nQ87UWaSypA0HuwlTuOZ4kGLX4fXTLcXFOS8vKBzaApEH6I/
         WD9Uq2nknicMx1SlwoVrGte8A0bhoiGdHKIdOMp9H1AdZ9hJ9mx1uL8y4X+TuS0ZnRu6
         bS+1rGx374KiBnYlUCB+A9M2ukZ40P7fPS7TeV6ZMdWDmkiKP1M+zVrKH3ox7XfekVwa
         5mHGY3szM+L8cCr3yZtaRIy+Ncs3781vW+41Z6iiogMp/pj37V01zMC3CpoAe2hXPmaB
         uZotorKpwjOojmJpkz9EAGTz8UljgyAaVKio3Nu4vi6ObTx80DfVEsGNmO7u6yw3kgHP
         0MHg==
X-Forwarded-Encrypted: i=1; AJvYcCVpHMQ1f6ZtxBO7FsT7XxRsJQVgkE/nQJYlRZM2WAYc3+GzcYRllxBoKeVqYnqEHADZ4VrusWozEw==@kvack.org
X-Gm-Message-State: AOJu0Yy35EQMSKsc6yTYUSyPF+bZ6Y3P+BqjvwmCbDrB9IUHAT3l64kB
	tl15VUEpk046eoUDVATUD6n6eRIMhH/XoqtpU1eCa41XkgPhtX4FdJta6FDwzaHti57tBCyuHXy
	boRbmNY5iS5UTD8mxGwtfl/5sH4Rxl4bZ4s5u8N7c1yJhHxRn7+V4
X-Gm-Gg: ASbGncsQwvCpd7ng/Ee3fjw5FSEFMgt7q/Vm5TWwJaqtLh+i2KUFUdtlzMIg9iuIx94
	nXYOyEGOH/7qRX0uWruuYJM2nkPU6bPunt8XlpKTwC3I1061IaEvul5LSBo9NIZpDYZvLl2oKEk
	R1PUki4KkFhDvWyqJcgjLjf/8nEgEWV20CiLXL7dS4o7ZBJhT80ReuJb9Ff/ZVsGz8wwVDoZ3oT
	i66C1ndJs3hgXwfxqIoPAyKMgZ0GTXeTsvenmsASLbtJa5oknUVNPNbEL5waZZJGCZTkv58uNcR
	+2UdF3LCkLs8Y4J40WHf0pCXmXKejpmhJC6zI2ec6/rejGYbFcJ69rqzbge/ElM12UTyuixnlC+
	z29O/cfQRmyNP22qFHQa0MI717cQaU5yzjoNSzAUPzXYUmM/Wv5NWjVaBsZ2OcDNFuYE=
X-Received: by 2002:a05:6000:2506:b0:3b9:7bea:14da with SMTP id ffacd0b85a97d-3b9edf3982bmr2026568f8f.29.1755162103098;
        Thu, 14 Aug 2025 02:01:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUssd5jKwre7nRGTkTt8TRJ0LrIp6xYOuOGAuIdLcXxjnPX8rB6/o0npU7Zz3xIpwUImjasA==
X-Received: by 2002:a05:6000:2506:b0:3b9:7bea:14da with SMTP id ffacd0b85a97d-3b9edf3982bmr2026532f8f.29.1755162102686;
        Thu, 14 Aug 2025 02:01:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8fc28a7b0sm25886485f8f.63.2025.08.14.02.01.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:01:42 -0700 (PDT)
Message-ID: <7e88d01a-10bb-4edb-9010-f9c0bca31a46@redhat.com>
Date: Thu, 14 Aug 2025 11:01:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: early exit from hugetlb_pages_alloc_boot()
 when max_huge_pages=0
To: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250814082950.2888-1-lirongqing@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250814082950.2888-1-lirongqing@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s0qLKSHqAM31rvPfnPPZsugzT8V1cQTTGkdBnFgA-U8_1755162103
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6571C8000F
X-Stat-Signature: 4tt85x6h8xu6qynpgtfj7z1nmfhzehmb
X-Rspam-User: 
X-HE-Tag: 1755162106-612192
X-HE-Meta: U2FsdGVkX1/tI4hwZi/bWk6E08pG1DX729Yq5pxUTZP1eqbPzsUqUim7W/P/CYBzyKSDj2EbrKyupRsj/acQVRI6yTPg0ajo9sTkJxZHqeKfY5HYsQftpT8WrPxBQcT+HGZXz+5ymF4DkYv8CrflJzBHGzbxWXO/Uj6AEZjhQAzHQkrS+cjoYuYntMTskkDBi18Jgk8DkDDSj8TVBcGp4dGNk45v49CaECS0bE6CsaL/kAfnMMbqk/NAVAgBhQnItAuqF3+G+31lR8Xf0CJrcnzIoEmhbDafSPhKjvKXHBiIb+b0DTHguUV3j7f9WE2WJF6h1mYMWOMhDnQIkjk22yDo/ARXfelUtHZaacncTqNuqgd4wUhp8WBEH6Zwa+Z7Q5UOHHRzfrKugWT8GEDXjT5QLoFDAC2yl/CMk02dM1fzdYJtP+OrxXZNDzdluQZA9Ctchu3v6LsK9nbSmNRtwtvP9jAMsTa+hTsn2zBmPp5VyS2/o5/WW/FvxXq2URnna33nHUNFjpKC750ClBtuIAGL6howLB5wIcnMkkmEOi2UH7JNmalc6kUzTJ/xb62wLrXsGNbLwT4qAp2nYQJN6vXyffAPdDxMtmrbGJWBIvrXBHTiiTDNaoRecJJgfCtdenLTRCMf1i68iR4pp+mlBrH2R515ExLJG+VvlBsDCjWc+YtUPMFRDmIbHucZLZm/2KtFSJWP5tT4njDHBizzWE4ZXwU4LrUWSh9HNngL0YDRTxrxA1Su0EdwVvcJraMTxfXaoPsXB7x9d2s1OCZsWt14Le8VnIC2WzvTA8I21tuKQVP8GoNabNjHV8hFygRMvcEr/B1WtT+BCLF3lhTlCaEIf5FM9NNpfR/07/MaOrhIMJkQcIXSe5Vt573fX+O/PllJFmodTYGqMaHyOHAJqmTpUp8PpS4C8FnYM0/CGg7UFNw0X2jfhZcGZdc5qOStQ1BsgnlfMxSivPWAydw
 R4QbX+LZ
 wpmtsgj6tLZf3TsxUwJanVxJmyAc9fIJkTQNt4DLCx2KQLAa27TbfogcBfpT95C/7Fm3PbMplIHwdEl3p0jahzJ0VDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.08.25 10:29, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Optimize hugetlb_pages_alloc_boot() to return immediately when
> max_huge_pages is 0, saving cycles when hugepages aren't configured
> in the kernel command line.

Do we really care?

-- 
Cheers

David / dhildenb


