Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0CA0CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 07:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7508E0005; Fri, 26 Sep 2025 03:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27EDF8E0001; Fri, 26 Sep 2025 03:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D588E0005; Fri, 26 Sep 2025 03:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 03FBB8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:32:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B24BC11A744
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:32:43 +0000 (UTC)
X-FDA: 83930584206.29.62D091B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 644FE120007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:32:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iqVzYAeh;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758871961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7lJCWxVdcfCha/v9DrcwqFYgZ0VcwRUn4ecEZCiSv8=;
	b=BH01Hsd3pTyuuLCcUZ5CJFGftzObRFtZ2Rnlkb/TP0DMB35CcoH7NANLmP6WxhJRUXodci
	dLq+/smsVCKWTnUPeH21K9Cs+MPqxhaUlM5s2ksKWlVFNocvNO6z6PRxFXMxH9+qJ+/ylQ
	vN6sWGvcmHy8iFCy5YXSWrIOYZwusOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758871961; a=rsa-sha256;
	cv=none;
	b=zAEN9Z0mpP7zw4JImVJO/H7oYphAucz4ttil4wEYw+eZe5I1Btu95RkJWyx34Rm9xh2qlI
	cCqFHcSOqKmiRM477J0SBsLIMx2UTZxg5wbSdfSD/MNhLlXeexhv7cPrNLnWDoasK/7Qi0
	DsRlDzWexkAstECGgumc9vzcRjhoM4w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iqVzYAeh;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758871960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K7lJCWxVdcfCha/v9DrcwqFYgZ0VcwRUn4ecEZCiSv8=;
	b=iqVzYAehNJszn6+illvte8jcIxUk54jvUytI+5+g9gih7J7lEg20lljzSQWfH30ZpjQpGi
	ZemAl7/lH9YLlzDXNwIW8Qp7HqsgsufR6/S92Mmhfo4KVvbNu1brQb/BFDI/NEx8hkWIpS
	rdV6MMH5IZ27tW6InnDha6FlrWoAVVU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-1zJ_YN3UMa29YQ4upi8arw-1; Fri, 26 Sep 2025 03:32:38 -0400
X-MC-Unique: 1zJ_YN3UMa29YQ4upi8arw-1
X-Mimecast-MFC-AGG-ID: 1zJ_YN3UMa29YQ4upi8arw_1758871958
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46cde0b2226so4752465e9.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 00:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758871957; x=1759476757;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K7lJCWxVdcfCha/v9DrcwqFYgZ0VcwRUn4ecEZCiSv8=;
        b=vFnZciw/qrjPRE//kIxniuUNMqx7P37yPxeF04B0jpwCT2hhnfPWXnOU1+NoIJThma
         iwhBLtHsJhynZlVTB7ldinm9+i/8xh0TflW1ORnmwcq48EPUFCU2smE8621LDp4BIObV
         qUHWzroQfI4CMknJhY8uolN3F/o1Nne1iMXUDtyOWeTUoUW5bDhwk3SujYiogFbjgRf+
         p1yPbyBeS6VstEI5gTQmdY0GZtIozxOX4qsPSHRvDvNKz8vYGDnGWv9q795ZE/0bYjEn
         FhZz/dq3dZHn9dHHlKqyM8zcOIcuqzNMJbPKowkkfZTpO01p9So3dc3PHlFd+rqjlefK
         0zQg==
X-Forwarded-Encrypted: i=1; AJvYcCWF/FZINntnOWyw5uMg8HYTDCcqMUeM4FyKsKRA+JidAovvssAtDDBO3eM/ry1BR2wgheMgTf8JGg==@kvack.org
X-Gm-Message-State: AOJu0Yw5W7nTsC9/QfQ5M4qqglzlyP1Rt5HLyXKFH+oSsLXqWOyv4GB5
	Syu/bjPfmZB/xg3Z5lcqIBInTUI73O9gXVtt57IiAIHoy3Bf4BGZP1iPpWrGoNjL2yJtXTKxH7X
	UP66PSqplqffg4OR3HbJNkgQ/sWziku9QZlswfzFyuge/c+dxkBwS
X-Gm-Gg: ASbGncs/plVfAY3hrVMEMkK5u/Vf7G+puUQjLjAm/6UcOeFV1kRbD3aC2YfO8ZwMmZ9
	AlDMGXp3crZHo9EcvDtq8kNIhTD5hELH8w+LAKRmOfS3TYcgPbYM0Oyu4HvxmicHgm6VnWMgdNV
	KVpjwS/cDiniou/VO1MHSelFBU6IVJ6ZmtSH+Hx0+puSExXLGuCAoAmucjdWF5Lgt4oaXG+V0Ri
	0RQwysA/uxkIXELAKCz251scw0MSLZFiUN/IlpQR0nG9w8zytYRIANdlhBDIk4MqE9hUzRVETkc
	jpa3rwSLcKqoRSPyl3aitJc7P+rw2nEN2rtk5wgM7DtzHHmxRQzUlFIm/zhSNlKreG1euF72k0h
	Gjm4HlFf3LvF4SH2j4z4aNcfNxiA2b34HVvVC+PEkaz4ie5d+K6phvANfEGicTHhiU/qh
X-Received: by 2002:a05:600c:a43:b0:46d:d949:daba with SMTP id 5b1f17b1804b1-46e329a7fe3mr62998385e9.4.1758871957396;
        Fri, 26 Sep 2025 00:32:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtL4vBtb4UkKxYY+8AUu50LpG2eTQL/mEdtyu+TBsZgjy08g9xtyeO4upwKha/FYi9Pburtw==
X-Received: by 2002:a05:600c:a43:b0:46d:d949:daba with SMTP id 5b1f17b1804b1-46e329a7fe3mr62997645e9.4.1758871956911;
        Fri, 26 Sep 2025 00:32:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:c100:5d3c:50c0:398a:3ac9? (p200300d82f34c1005d3c50c0398a3ac9.dip0.t-ipconnect.de. [2003:d8:2f34:c100:5d3c:50c0:398a:3ac9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc72b0aeesm6112695f8f.49.2025.09.26.00.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 00:32:36 -0700 (PDT)
Message-ID: <a127971f-d1e7-4fea-a16a-c2bae34b4ad3@redhat.com>
Date: Fri, 26 Sep 2025 09:32:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 7/7] KVM: guest_memfd: selftests: Add tests
 for mmap and NUMA policy support
To: Jason Gunthorpe <jgg@nvidia.com>, Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, willy@infradead.org,
 akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org,
 vbabka@suse.cz, brauner@kernel.org, viro@zeniv.linux.org.uk,
 dsterba@suse.com, xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org,
 clm@fb.com, josef@toxicpanda.com, kent.overstreet@linux.dev,
 zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com,
 lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, tabba@google.com, ackerleytng@google.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz,
 bfoster@redhat.com, vannapurve@google.com, chao.gao@intel.com,
 bharata@amd.com, nikunj@amd.com, michael.day@amd.com, shdhiman@amd.com,
 yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com,
 michael.roth@amd.com, aik@amd.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-10-shivankg@amd.com> <aNW1l-Wdk6wrigM8@google.com>
 <20250925230420.GC2617119@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250925230420.GC2617119@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o8nuiUeWKPSNpntxUwaD3nc3YCYZIoZZHUSIL5XhLC4_1758871958
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 644FE120007
X-Stat-Signature: iousqmee97kj4jwf8hdn3x5b9oma6rg6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758871961-952053
X-HE-Meta: U2FsdGVkX18ALYjVfbtWZkCqNTW0bAkP8AG/tcV86yLofV6SqtSMHbhBqm+gkBeEKgPxSdZWSGghH7nfWp7EkCNpuT91AvdcYboOnlS25FW7SN7yEHRDnjzuwYjKP5a0MlnLvPFlyudGeZjZBswtFw9+aEuIpgfcTxT2GvJoKagofDCkbZpLzrN3LuConEREoCzCaohxslbimu3k0vx5/eNL+CaP5Nw49KQHTjkfvpO3FNfCysArLXZNVnARoqOo1JBHQLQsCkvcSfV9UC10sSwpvjF1cMwuZOiuVvf6On/OA1GASg2lt+kPx/Bl2lA7X6OUXUvRMOCytNm2ctlR0qxRlPRPun9LIMeLwVOFODxw91tiFX2WIRryfshYQHthRSFcIUq2azM84SpVHSIzkqTHk8XNiXNZd998/K3FWK5YblRF03F/BZ3iFGZv+bKqYLaOntTOgSuOaif7ldOtfNFBDH2W+eqcs7awc6w6DUIFmleTrZrblIRuzkdpqqT1LPF9jRj3cuaCJlmAFAUH+RqYeqlCJ6zZxaVLvZKbzlph8/BchCR5l8/p7Sj4H7KXTwRTHj7zl8IkA7P4J+uDzctPBQDlnmNYhT6lpTcNLC85A2CFLWDPuHdHmyf1iMjTK0YxrAcA3TxbQV8cRqdrS7C0bbwhhk/be8QzQ+FKZj0NVAxdQ10jjd7ZGb5m1xwrb+jHg6N2+UpauOgUufHav482QgFqh5dReYdFnwoTRhi5LeQ+C91KANKy6jRVZAdV8e3IsKerUz7ufg9Zyq15y0hbmKnqj7XVYpXHUH0ulPWr/UdeTI+HHySAd+PAumAo7RU0FUCUZd4c8hPwdTxcK0L9YwFexa4+XSr8Kb3CP+eYUmiWvuulrbRHRn3HXo2l7HvyCRMfl/nF3r8EZvutVzG1fV1xExfySOVm+X3bj7e3w2o4YKXy7hWH3wpO+olhQ0XH/GKIFJNGPNCTBuh
 VjvpDsap
 gTwAbBEZEonvv2/5Id7khXLmzp5ek215QtongkPTpQLgSqy2fXuuZFXqmnzNsbta46RDUQB7c9IS0+2TD5hFvgek0wXx+7tPWxH6p0R5t8yu0lmVYzj2ePSJnz3ALMD+73VET9whZ+AcgbFIptlVzUlPYGBsOTb3vjXhc4mWkojlDb8XU3RqkoX7t2AqML1n9M0XsciEHZX+dU3iW5GF6btaB6Y4S2015cCRbUbubj40TbN56CyoFagJDSitKDojSks1xG0Xkr/wv6VlwNSDaElcWOnq/819FRQIWyKwtZbfqUVRAdm5O6kFMhzFzbGQBA6fNkQOWflQI/cgTUbYypsGNNtFdCs9ZqRsJ9h+MYCOvOrvd66cQMG7ICVsgvVyBtw0gg4FMR60JJ0Ie7j8BK1hLw3RAxe8HGHWsPKUOwvbVt7S04Q74CRRdFRnMR6OgNJvc54ugRiBZ2ObrZ5GrwuLz+1Mvu6NP5c5GitQllYFlmLUxQ5F6S51sF2fOt1/V+auoQRCrX2fRgq9z2ZLACrnQVba0CLSD8CdFY2aFhvxTt1Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.09.25 01:04, Jason Gunthorpe wrote:
> On Thu, Sep 25, 2025 at 02:35:19PM -0700, Sean Christopherson wrote:
>>>   LDLIBS += -ldl
>>> +LDLIBS += -lnuma
>>
>> Hrm, this is going to be very annoying.  I don't have libnuma-dev installed on
>> any of my <too many> systems, and I doubt I'm alone.  Installing the package is
>> trivial, but I'm a little wary of foisting that requirement on all KVM developers
>> and build bots.
> 
> Wouldn't it be great if the kselftest build system used something like
> meson and could work around these little issues without breaking the
> whole build ? :(
> 
> Does anyone else think this?
> 
> Every time I try to build kselftsts I just ignore all the errors the
> fly by because the one bit I wanted did build properly anyhow.

When I'm in a hurry I even do the same within mm selftests.

-- 
Cheers

David / dhildenb


