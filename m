Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381FEC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808086B0008; Thu, 28 Aug 2025 08:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0086B000C; Thu, 28 Aug 2025 08:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEF28E0006; Thu, 28 Aug 2025 08:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF5F6B0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:45:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B6A083404
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:45:17 +0000 (UTC)
X-FDA: 83826136674.15.8A57403
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8042940013
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:45:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PTEbhPYH;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756385114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3paW1b5Mw7wLy4xkwmsY2oZkGJtTcOn/fJJ5o0Bou7g=;
	b=INYRjau8MvuOatA3lhQy9KDWkW5mpsWWKXDuMAnevYr7nXvyybBdXl1a1ru2F9P4vlMdtT
	Oey1J28Gcd6wjHpC+5TLOBkKTh46cDia9uBwlqu6a3auIDj9wlbAHHQwwbq3oYCS2jbLBC
	Lv9Lf92/8mgVTNFwvCyOfpwQM9vIY8Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PTEbhPYH;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756385114; a=rsa-sha256;
	cv=none;
	b=U5XvCJInuzqaQF4ZFzHMWBKhiWALgbOWSxTJDic10U2cpmHHrBvuXsj+Y8jeymnDew4wV5
	frunhSxpYJ4emKd3EXJQhwWhRxb4+6XRCMjgqABIKWKjrQGanmnS8l1d13RVsLAlKk3Gf0
	mF0tzVphB56OkZrEnj0nmKI/15BrHOE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756385113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3paW1b5Mw7wLy4xkwmsY2oZkGJtTcOn/fJJ5o0Bou7g=;
	b=PTEbhPYH3xdEgiT/9qVRgyABCXAwwADayMb1mpUoorB4dV8oa+5CylYCou9NA2pEQDlulD
	gcTIUHnEc6S3MZu2/CSBsBsF6w6pbnkTKA/l0b9RIBiyrEVQWbmo1P947WvbeRp/p8wQzV
	gLWQDPHEddoJm+Itv/LnCAXYBJ1ULeI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-zxXOAyYuOCyjobGsUc4w4w-1; Thu, 28 Aug 2025 08:45:01 -0400
X-MC-Unique: zxXOAyYuOCyjobGsUc4w4w-1
X-Mimecast-MFC-AGG-ID: zxXOAyYuOCyjobGsUc4w4w_1756385100
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ccd58af2bbso647321f8f.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756385100; x=1756989900;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3paW1b5Mw7wLy4xkwmsY2oZkGJtTcOn/fJJ5o0Bou7g=;
        b=BeN1C8pHkTHCTjfFhKqCMT3Og/5WIsZGwKUG25zfb0EkysdNez2WLDCwhiUCtHieRN
         cYhlbK9OoXsK6zpFkrqQypnLIYftgj/qsGbIdm/LsMDmanKVTHLvDLRUHMMqCRv7KzzA
         38SjIxWVDyJoNQ2w9rkK+STBAoXRDdbQFoYlL3nXl6aLKtiQfbqgIziLDQ75p1M8wbZi
         e4o7hBMpbSWXFNs5y2EjJhRJ4W2nUstvHPO6CmYiFFJ5wwi8bB0/KFVzspCMZcdDzw88
         7UVlPMMEjjmwn/uJVRZQ3CBIVKIpAKVReXOHPw9Vy+Tx/liwG6DZzLxIxDpCDykdoKpv
         rEJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbcHUBist1VOqGRsVeiX2eVaZp/vgC1HvzqmS2XTMY23kIMLLK3JcO6WJNmfDCMQADAHZuFKekRw==@kvack.org
X-Gm-Message-State: AOJu0Yw2NQsrUiAox5601ojcd5vdsGzJJe5eljuA5zX+J0S2f6q0+Sj3
	LX4QqHzyOjMDm3Mer6q1whOlfjyqpHX0/sxFDtN6HkUg51fIWPeLGrg0I/UPN4ZUTCe1Am3ZvT6
	027TE+dPHcQsuLbx5zr9tDlb0JyTWCPaQ/QM71X4sPzxeaIks7l1M
X-Gm-Gg: ASbGnctRLWnU6+Ln3jV8FN/fQap9iJ3oO+mnpoYBUPo1xL1dgPy1g5hhdjo742jI9s8
	u3FR48tgGPGjBfhjDt5cvHikfKKwRC7pcnxbRGWwg9sXmuc892JbM0vtxgzgE0WExJerPAb8n+f
	V6kgLET8702Ay1V3QSL9pk9/mb6eK7a2WzX2+9/Mbps4FVDWFMJPVaI+cH0CcIhyK5Z90maMCqc
	dLFYvQiZF6mCI+JGUKcZQLtwvIv+2AtVWwoRz4fUYF9kcagaIVZaWVtLCoshkJmT1LfDK6JTY3X
	kaCOqY5VMN49R37xd0qhVANElv6z4YcfbNjqpV55PG4sXk/jxla8LQYhMR03ndZjPQnlrh4u+75
	Zkn8E9f0aIKjL68DxKA82t+SMl9fAJrInohD+X41Ii1OinV5mMkQKUlKePh4aU9Houto=
X-Received: by 2002:a05:6000:4022:b0:3c6:c737:d39f with SMTP id ffacd0b85a97d-3cbb15c9d73mr7590141f8f.3.1756385099908;
        Thu, 28 Aug 2025 05:44:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF49i8ItUOOotGgNzJSQJ9D9n1u9eFn4Pn8tTpvivzbTh3PK0f+Gzxqf30EOO4tj4ygGNqhOg==
X-Received: by 2002:a05:6000:4022:b0:3c6:c737:d39f with SMTP id ffacd0b85a97d-3cbb15c9d73mr7590040f8f.3.1756385099209;
        Thu, 28 Aug 2025 05:44:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc98998781sm7195784f8f.49.2025.08.28.05.44.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 05:44:58 -0700 (PDT)
Message-ID: <a6a2a7ef-0019-4975-b9ec-ef19e3fe44f2@redhat.com>
Date: Thu, 28 Aug 2025 14:44:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 0/7] Add NUMA mempolicy support for KVM
 guest-memfd
To: Shivank Garg <shivankg@amd.com>, willy@infradead.org,
 akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org,
 seanjc@google.com, vbabka@suse.cz
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
 xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com,
 josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com,
 jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 tabba@google.com, ackerleytng@google.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250827175247.83322-2-shivankg@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CVkt98m-SZZVJEVpWSQQJaoa7a-HSaPGcPxPursmSRk_1756385100
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9mhs7youhn4n5pchzkdptfa4pirpso3f
X-Rspam-User: 
X-Rspamd-Queue-Id: 8042940013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756385114-947017
X-HE-Meta: U2FsdGVkX1/DD5PyF0hideE5HXYUxAivdhe7jep/3CvE5hezFVMelKiCPDDbS9GlF+qXiN7lPVN4ZXVgEDVIo8gaVnYrpsCTWMCECM7NZBifizdpMyj4dXvAnZHp8DzIWP748Bi215rqHs9aPkt7IHuOXNaNUkG8ErgSKleKYysTRq2y/Lr8qRFdPMwhAoWOfWcQ5dddRpMetQrq38XB/bqv0elpn/Lmorb/l9YlhBRoPQ+d+XLnFzWT1z7EMEIZhRFjYpw5Jn4xWxAbWIoY7uuBWu83GUIF2yl1ObFlTwfEu0QW1x3yiAe4/2KfYkeEOi7irr3aIupfL1YqOjgLpU/gQ9klJXllYTPs93IPr1XYZ+1REcA2c3U3GtGBIenTuF0SiT8G2E0zIRX60Pyih8D5gVEMoNPWl7TgDJtTVZllR3onrpWEBDUoruFjW+um8umlh15Ryhafkpf906sX55PwnOk5p2hLbd1a5CQGq3BLDGVW3MgpqwMCLTvW/pi3oju1Ga0GGsGr2nzVhUvk56N2uQlSaX4XtUWy0kJi+iKUteiryCxNgoiaVc07wXmxovz4D/QaG7uZEOlS+ItikLkqNVnJzX/CfthWtsOPwmd2scgmye9Fyr2UQCaidIdqxDZyN0b2Ni67FrdEUeK+E6Bi4nWLiY7hFllnsvqcUXbHZH7e9QdgenW4aF1k4ZXUc0Jsye2/koStTQMrnfhyOGT5lcS1NIH9E5TrJXDlleorwUxki34VYZXSw/bxq5AATrtir9QRo/7ufB8nqOqOCKQNBWgzHsUVW+Iq7bDDnNDdktF7A3HsIJBBsHiJRY2joYb1tPi1LgYGQIVbjkg1p2T33l7U5whTAhJ3GL7URmyQLRSukyTqhA9xlJu0SxtOJLyRD+EyoZs0O5SF9m/ZNw/NnJqyxHUkGMReYAiOy0p2jX1lO+V4bFJFokwcyR5y+xSr0fn8RDg/Gk7Fnu0
 ZIriSVxW
 GnTrzuqtPPwqHcNm22nWEs/BUsF7th/dfAZys5kSNiiEszS8GjQbejAPpp+UtH6theRyOzoj3N47008r4+oA8tD5AHRKMQmphlFdhU6DlD/SXhvT3XUpO6gr5OlzZChKTcliso5juyOrNTVp9RxIvmMnwIgMyhq1L8sog40ggND9J3fPQ1q36l/LwDZN76Ka7BePq07oWBP2IbNTfUXQg/3I5L0SNrm5f5jO5jzkzhJs3MyyuPXIyYjfqIf365Nsf2ADiK9zcQC5YXHTLT7cW2CpAOQSsivRNtD3SMB8TKxbxmfeToeC8wiTRDJgeL3CfVLWXsi3MQLUxXmKR+cLVOl7PRef/9G13YjKWbaBf6AGwdGqkCPOsT90ZM9p/DN0b6UQMRV9wmHK9DVVm4av5jvvvp5D8Y44/r4Of4dlH0wDNRhjVL6y6U7kEG0dJxayKMjigAOKeq0SJiVVOuJ0cZuatjriCLAdePqCXJoi0B0MV3OYMh6ifwLnBzXrZ6/2kD6s9RqqCe8JDmsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 19:52, Shivank Garg wrote:
> This series introduces NUMA-aware memory placement support for KVM guests
> with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
> that enabled host-mapping for guest_memfd memory [1] and can be applied
> directly applied on KVM tree [2] (branch kvm-next, base commit: a6ad5413,
> Merge branch 'guest-memfd-mmap' into HEAD)

As discussed, I'll be maintaining a guestmemfd-preview branch where I 
just pile patch sets to see how it will all look together. It's 
currently based on kvm/next where "stage 1" resides:

https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/log/?h=guestmemfd-preview


-- 
Cheers

David / dhildenb


