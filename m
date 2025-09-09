Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81488CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16DD8E0009; Tue,  9 Sep 2025 03:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED538E0001; Tue,  9 Sep 2025 03:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02E98E0009; Tue,  9 Sep 2025 03:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B05338E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:53:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AA211DBC30
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:53:45 +0000 (UTC)
X-FDA: 83868947610.30.9077FF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id E8772C0004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:53:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0cqtYfn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757404423; a=rsa-sha256;
	cv=none;
	b=kT+JNHlrdh+xoAzBRblE9euVR07B99ZFbi7slJvyCCRieUISTdcz1tsneNST7qDH81C/rz
	V5qo8lMy3cN+dD5JBJLs1Ig1OBdHlzp0VgACFYhg5wjrX1uviK/cSzONjVOeOONFro32DC
	imSVR71xE5GnA4N8ifdTrZK4S3KqK+Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V0cqtYfn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757404423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEmBeYvm+QHo4HcVfrljhh+DxHJQ+lr1tf/W4Tmx/TQ=;
	b=hH+0Ofecr+/jQ56TEzzPtiEoot4CIgoxFIdq/mdf6X1090mFhYtrUBc1DXDMB+WT1eO8OF
	TcOJMb6GPUQ6X8f8gROR5Bupn2WPtJsXkAQcGUsOXyIDbPjLZ0Oix6u+SSz18JUhAnJaHB
	KcoIGoiZBcmAXlIfi0iG08WqO/NDHAo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757404422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZEmBeYvm+QHo4HcVfrljhh+DxHJQ+lr1tf/W4Tmx/TQ=;
	b=V0cqtYfn0E2HKQHd4chJZnbS5IKuwz+m2sgslRJTN4qqHg6V49NQCS/gfkM24Z93eP7wZ+
	n9FN6L4DBIXbRNjnlHVoypuUKEAYzeEfFZ2D6lZQaLGXfn/Yz+CC07hauFtOHzsOfMVcG/
	3Dve64aS3lWdAbIwVmeLZNld+n9wwIA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-b9WtAwdUP2-duHjehm6pCw-1; Tue, 09 Sep 2025 03:53:41 -0400
X-MC-Unique: b9WtAwdUP2-duHjehm6pCw-1
X-Mimecast-MFC-AGG-ID: b9WtAwdUP2-duHjehm6pCw_1757404420
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so29787685e9.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 00:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757404420; x=1758009220;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZEmBeYvm+QHo4HcVfrljhh+DxHJQ+lr1tf/W4Tmx/TQ=;
        b=mq9gNVEKnZE9peT9ZoRLb1tNE6b8YEUgeDvtc3Y3OOnyo7h9kCVlLEyS/tjIYfy3Xr
         a3GYy97mSxHj50LDTl2cqxlz0Yz2fLcVq7IpmzahZCitZKJPVpxSMoupkLDLtDe4Ik1y
         3k7dOkvx1rGTMpeYL30wxSWAAE1yQ/Ib8UuvVp8kujqaKFbmGL+AqNnIAIScbmxWBinh
         QPoYej6BYEhqBlgXLGbW7OjsaFMSQa9iSZ1bmTiEZ6oOGwxJUyp1mahTYCKOpDX/TOqF
         wZrBbTL12+lpHkttVTX8AY1Ll+OanFvQYxsWBrh5TRnNru2UkZ+sINFTs2P3vdWvzUYe
         JDsQ==
X-Gm-Message-State: AOJu0YxQ9T/4aRg5bZFDDvGkJuTBwPTbqExgksjKGPI5/z3ebjeUXAMD
	1b/fC5FypZLWsTJyp1oWwoTLvmnjz7yjr4nq+98In/qM31PI3QDeZModTUcgL1mO0RIrHifpRri
	rlHyuu1TLdceXy0Hn9clK75UjHY/x4m3JSKsxSNnoNvOvvPuFDMc0
X-Gm-Gg: ASbGnctPVuXZzjpvvkkNF5lN2TfTRtNtHLd8TN4jStKZMni1s/EFgl2fMvDU+Rymy4T
	p7BgheoU8cnLUHMs5RzvREkGKGxGbbDscZ4AR4au4EUoEceDyddu03uVoVmr+SwiYU38meVnmql
	QYKjRfZ3qL3aB/HtcFSvviK4Et/LAUjVSyRBt9z3IGF6DHfjm8wddN0YKKIlfO0vaoJ8N8pKDFI
	QyqVpbaRWNLHLumRPmS/SXrd337ERXzQQBh0uGoopDI5NLQ38qIMcLcRcrAMqKWsjjXgYYrpeCV
	GPt/czdFqJI+GkEoxAwRbM0uNSK6Fe1rAr+HFNoWEA0jIkyWRwFGD8PHGnxCn03phsV0tzULptW
	M6DsJL4ryx4ACPbOrYipfMdcenBU4MI3QEUUknMVWJsmKpbf/0hizi3wpHm6BTdA04Yo=
X-Received: by 2002:a05:600c:1912:b0:45d:e326:96e7 with SMTP id 5b1f17b1804b1-45de326996dmr71555875e9.29.1757404419856;
        Tue, 09 Sep 2025 00:53:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFS4AFMGxOq5LNuJns+zgBlN8rwn2xGsseYDqK0Yl4p7XSEF2HDrrN0L0SRylb3Q3uPkkO5zg==
X-Received: by 2002:a05:600c:1912:b0:45d:e326:96e7 with SMTP id 5b1f17b1804b1-45de326996dmr71555455e9.29.1757404419328;
        Tue, 09 Sep 2025 00:53:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238910sm1462804f8f.41.2025.09.09.00.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 00:53:38 -0700 (PDT)
Message-ID: <3fb2b394-fa75-4576-ad8d-6480741f0c1b@redhat.com>
Date: Tue, 9 Sep 2025 09:53:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: Anthony Yznaga <anthony.yznaga@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, andreyknvl@gmail.com,
 arnd@arndb.de, bp@alien8.de, brauner@kernel.org, bsegall@google.com,
 corbet@lwn.net, dave.hansen@linux.intel.com, dietmar.eggemann@arm.com,
 ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org,
 jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org,
 liam.howlett@oracle.com, linyongting@bytedance.com,
 lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
 maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de,
 pcc@google.com, peterz@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz,
 vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com,
 x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <5b7e71e8-4e31-4699-b656-c35dce678a80@redhat.com>
 <aL9DsGR8KimEQ44H@casper.infradead.org>
 <bff57a63-4383-4890-8c68-8778b3a75571@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <bff57a63-4383-4890-8c68-8778b3a75571@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N4U-GDPyfjhlmH38acMahjmZoxFMEKNGFYOrKEw9kMw_1757404420
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8772C0004
X-Stat-Signature: yuc8yepm48s87p7fqbfwu97d64n3sihq
X-Rspam-User: 
X-HE-Tag: 1757404422-626564
X-HE-Meta: U2FsdGVkX19gt9Nrtqe5qaSOojNC6upeevuEFC4xmOkeJHU/B5UHwFeD4bqNTRCIQIrZxnvG2W9eBbdr3YOvdA1TQxWWE7nvHWewAuA6ZFilYtYKtZd7NlmSHhEox3ZkkcmdhjqFBxLdTxb03IFvtaAjnR8aumqX1gnyStkaScxwHcdtSi7bLaXnamqlwOqMnjKnoh9lmWmk60Aijs+Xv8wB3fcO8yzPxqYBkMAYu9OBQYXVfvTB9ZrUhe6MFPEHINRRX/Nd8/Q5uyZF9RUvU1XSGPnyPxUAwmZ4NfDbTJx+KOAshhh4kI6UpV5DXbSp5tOu0ykT+g9zu90JdnkoSPJE7YY5FzQ1djAMUXWXUZ+Emw9eqYbGiwbCw6LPh5OntduDP29FqudGphZsACx0XC2Gxxf3lYhtglaC1tI2XfCjWWaIaHYQ1zDQVtwVklqea77BHbqkXtOMjq7bxT+OJVSOa/7bsI9jGoWsT1SNTkhaDGXId0i7o1BjQc6TDXqU4XQZyZFDVzchEtjCg4oAIQZGZAQOpdIw54DsX/c+u2hkPhc/M6yAFxcni1n/MoQqSK7Jawal5EvehChcnZm2kmE8naDc83TYbAlLub1olDpyBlSvG+RzjM2u/tq2uCk2Ls6xNv8HrzJUeh1+H3iCPbD8D8ZwDHl/123qMJRQIBwQym1Kx/x4tw5d8lHRcb5oYNO8idEwGlXlJlwbKY+Lot0UO6M9tCwsWlQAyrogcuHQwKN1ik4fBa+bXYrKPpJqBAL+NqPLCyienfSUiXsM5absIaFL1bG2nPPX/WXPdHStDrUvb4bD29go+KgDz6t+0p6n1BOFc7kJlxQujdcxe9AmuwTe9R5yGjIB0ieyl6PxbEci6b7JRSbNMh4C14PxI8ckqtLDZyJ24B4ZduJ5XvbxpUpb5KKpD76f/v4sqemHGGt4YdUvOftXZya0FHnPgFtjjann6LYFrrmt1uZ
 a/j0VXlS
 LLq4SKq0ZHh+E72uqzmkXqX1fcALwLeTuzNaY4AomM+Q7Y+KYsHj1jLCWdMgArI/FmNm5iqSsxZM5IBc4OAJ6kcfUTm+t/3NOKniq0Ne+5Z563hE3obSv2KrGH+e+P7iLVwv9jAm/m/37T9bwDPzgOxnMoYy9EOYbUYD1BjtipId7JZrabJN64GGPnS0+y7zcX9P7in422nkYfLYT9pIHxnturbn8MUbljP6u1xasMwEqlfoiwsG0kQo3bRcGVJw58MHkx7VTN4g+0O4S1cbxPa4HBSzPZ4Ivv2xGrtooZaOJF4RiuPWgCHCigQjSzIOqFwDfeWAPVSAYor7bkDSzTVyANB2cRi5jfZJhREnNm6J4JfQ8DEeUp8LMguWtuHi66SHLWVMCHUb5uNB3o8uLZnugl5e8grEoFrgIbU8o/lnFR0wFWYrSTTb4Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 23:14, Anthony Yznaga wrote:
> 
> 
> On 9/8/25 1:59 PM, Matthew Wilcox wrote:
>> On Mon, Sep 08, 2025 at 10:32:22PM +0200, David Hildenbrand wrote:
>>> In the context of this series, how do we handle VMA-modifying functions like
>>> mprotect/some madvise/mlock/mempolicy/...? Are they currently blocked when
>>> applied to a mshare VMA?
>>
>> I haven't been following this series recently, so I'm not sure what
>> Anthony will say.  My expectation is that the shared VMA is somewhat
>> transparent to these operations; that is they are faulty if they span
>> the boundary of the mshare VMA, but otherwise they pass through and
>> affect the shared VMAs.
>>
>> That does raise the interesting question of how mlockall() affects
>> an mshare VMA.  I'm tempted to say that it should affect the shared
>> VMA, but reasonable people might well disagree with me and have
>> excellent arguments.

Right, I think there are (at least) two possible models.

(A) It's just a special file mapping.

How that special file is orchestrated is not controlled through VMA 
change operations (mprotect etc) from one process but through dedicated 
ioctl.

(B) It's something different.

VMA change operations will affect how that file is orchestrated but not 
modify how the VMA in each process looks like.


I still believe that (A) is clean and (B) is asking for trouble. But in 
any case, this is one of the most vital parts of mshare integration and 
should be documented clearly.

>>
>>> And how are we handling other page table walkers that don't modify VMAs like
>>> MADV_DONTNEED, smaps, migrate_pages, ... etc?
>>
>> I'd expect those to walk into the shared region too.
> 
> I've received conflicting feedback in previous discussions that things
> like protection changes should be done via ioctl. I do thing somethings
> are appropriate for ioctl like map and unmap, but I also like the idea
> of the existing APIs being transparent to mshare so long as they are
> operating entirely with an mshare range and not crossing boundaries.

We have to be very careful here to not create a mess (this is all going 
to be unchangeable API later), and getting the opinion from other VMA 
handling folks (i.e., Lorenzo, Liam, Vlastimil, Pedro) will be crucial.

So if can you answer the questions I raised in more detail? In 
particular how it works with the current series or what the current 
long-term plans are?

Thanks!

-- 
Cheers

David / dhildenb


