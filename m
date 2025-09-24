Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D3CCCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052C58E000B; Wed, 24 Sep 2025 14:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002868E0001; Wed, 24 Sep 2025 14:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C938E000B; Wed, 24 Sep 2025 14:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C9FD78E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:19:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 478D5C012C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:19:12 +0000 (UTC)
X-FDA: 83924955744.28.CD723CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D3B671C0008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:19:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZXfW0sDe;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758737950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GVKNWNi5HMo/lBrmWhAcg83rtAIgDpsQXqdRYrctmM=;
	b=qxLv3yhGtVe/nfEEbfCEHeVzUlSrCCx3nWUPJ5S3bNgwWg2QPgvr/Twjn8K2PRHiNYUmDu
	4F1TP8U9GnRv4kBs5vomcdUe0griO0wTeHdbnzHVNkksS24ZInk7EAtpJknBiPkixzTXbr
	A2gug+GSN5jijKaZkUaVNC73OslxdEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758737950; a=rsa-sha256;
	cv=none;
	b=THZOTaLMzycWQYpPWIXkXNOWNDCsQmL+ItZk9vw+dbWbOUW7RJz3BvrhFsZQTqtcbP8PLZ
	sKK7Kb+SlvlmJy6jtEYi8QrFQm6tPa4S1vFIjs0YIHLtjQ2O7Xqta8CQarBS7H3DJ4XJDI
	diJmfpQiiyo1w8VPy3W9ygSPcMjoU+Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZXfW0sDe;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758737949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+GVKNWNi5HMo/lBrmWhAcg83rtAIgDpsQXqdRYrctmM=;
	b=ZXfW0sDeZ1TMr/+gJtYJjgM/9BXoFDStAVj5k1xn1ciQSMP9AhuGe6C8lQBRb66XTuXY7N
	oVwTLjGG0Fuaj3jh3iKWfgHPR7xp2yQ8dM4DYxeU/9mmYc9CIMk/OLhhWnJJiFIowVL1Py
	Wh1H8qNWObowmkREFLRoADxAaIDBx4s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-Knt6aRhbOPmnTla3SdHlZw-1; Wed, 24 Sep 2025 14:19:07 -0400
X-MC-Unique: Knt6aRhbOPmnTla3SdHlZw-1
X-Mimecast-MFC-AGG-ID: Knt6aRhbOPmnTla3SdHlZw_1758737947
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46c84b3b27bso486995e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758737947; x=1759342747;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+GVKNWNi5HMo/lBrmWhAcg83rtAIgDpsQXqdRYrctmM=;
        b=dTpyImPMMb78j8Sv9sBWa2+hf7MC7IYT8hC+pB1CEdj8yIH9qTsnxfw+Lvd7cL3187
         x+DNZBwK5GSkSwV3LiUrfjf29X0t8bVtjNWz4QeS5ZUDmY0DEx8KRuqQS7uWaiydn0x7
         UkfWYR/5RTD21a7WBisgWvCw/N6b3Y984HLsd4vuntPNrNUU3LnPujs2B/nqU67hlZef
         VQ5rxC4opnhgf7600MZe/BweyNE89WU+GrcTwHCrW6m/ZVt4UZ89jWjte7slV+i0EaaE
         J0auTBbKyWtk4U/ax7+/ymmzITyDhZt5j4F2lLJVWq0S+VDqeOuAvUejLtdGgkPf20No
         TLZA==
X-Forwarded-Encrypted: i=1; AJvYcCVZY+NMW9oeTsBkfD5zJu7TK7LtrFVC+8lSn4dL8yLJARsnR4yc3ei5lhjrImeIC2s7Wu/feJfyEg==@kvack.org
X-Gm-Message-State: AOJu0YxzxaRwqHcsGW+0ejQzUuU3zP4jCfKgG6RA1d4l3/wze/ZeoTIk
	hGWYUrQOWL4rmH3EnEJ53b3+MjOZPgU4/c9PyBTlgdcnkPxcmyEuvYIZrNtSW4JvQqs8N+D6wUE
	gYjOiEvVzaUa3rP9tSrK8msY5tSuJCUOTmtsxQFqTT28HcFaIq0Uu
X-Gm-Gg: ASbGncv/bfXe2u3Lql1xgRoyB7CuY/pc6tEh/sofMggw3u2s44U+sw4oBiF07KrqeC8
	k4N4BNHzfpeSvwyJ51Pt4fgpsXxXqVnKOiFLr38Dd2N92QXJ2mzwclsrz5dsBfIx1uQ2bu9cpIY
	I+aNEl0WfRQlvChJuVzQpqxfXPem32EZURa6yxPyCCmKEYbPokV47U+ANbgNSIlIO4O0xTlo1f3
	0zN4U9L+Bi9VU2r6KInVF1h5QHpEnp8hYZKVomQTHQH4el16+t3FZPvsSAYdOY3GxesVtq2ai1f
	L4e8Olyv2CLbAwXzixjCj1CvnlCql8mO8UvyaEnE7ls4Ku5ZmS17LXycdgDM0+UDk0ZwpC9f
X-Received: by 2002:a05:600c:1f16:b0:45f:2cf9:c229 with SMTP id 5b1f17b1804b1-46e3292ea63mr9348995e9.0.1758737946364;
        Wed, 24 Sep 2025 11:19:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWiZOUG5fae31rurFMM73vXO6jc0v8mG1U6clMBR7MZT6xxje1XWRB74TlFYPhZbJta7VNSw==
X-Received: by 2002:a05:600c:1f16:b0:45f:2cf9:c229 with SMTP id 5b1f17b1804b1-46e3292ea63mr9348115e9.0.1758737945821;
        Wed, 24 Sep 2025 11:19:05 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a5c4.dip0.t-ipconnect.de. [87.161.165.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996da2sm50902695e9.5.2025.09.24.11.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 11:19:05 -0700 (PDT)
Message-ID: <1b01ebab-a43e-4344-ae38-50f0a031332f@redhat.com>
Date: Wed, 24 Sep 2025 20:19:00 +0200
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
X-Mimecast-MFC-PROC-ID: oyP23oDuxqYAXt32Sv09vObxsZYGUxKzaUpmPP2l17Q_1758737947
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3B671C0008
X-Stat-Signature: 9gspzjogy6wwqxqjma5e1jy3td8tkupi
X-Rspam-User: 
X-HE-Tag: 1758737949-975268
X-HE-Meta: U2FsdGVkX18UegkDR80x9CbU+Jt+EJZZlQeTiCAQXCOWB8iOYuHhLncSZNnvEN7794CJMWrCX54CzCGnHwIBsl2VPQsYBsGvCeysF0h4ImQIbsPfkEK+zq0wb0krKNiRYMLMR9vdV45r8uazx+JFooyBpYeuIeKt2Otq5mFyvZNWa9qmlhrpqvbnISA5bMW9SvRtJ3wXhoc8wU2+bA1KoeWhqbwMQSVzMY9XlOQkbjpsUwptNcyjOqma0PvbD1hy2x1oVTQraeebK2AqJbqInF5xXyECi/+NC62C5+MSWf2hBreR2w1NAJ8uizBGEOsd266aDVKZpotA/HjxEWiYLNi4i+rRuZPrPqylObmecXlfORdok8QRcUKR1MHVILnLtqQYarolneELUVaJu2OhrMDcWtm+l9Ip9cDTM1tRoF9L6gFwqgMyywrGrn+k5Vz8Pxt0aC7htvwAYf6kLgeRCxLoMBw/O4eVOVFQH1mC6gVzoVj6m6qNpi/VeLg8058pKw1y/Rm+66fHOrG3YxiHj1bWmTJrf8DGVM6wLZWiBhrbDe3xH9J7ep6xfcEZLc2+PSPusRSS2n5aYqoubyluNhQgzeffRkBt328QJkbgJUU9R89SHdRb0oLSe4jp2vyA92cBx5wPEnENwRziJ7sg+z8vW8ys2tTN6QCFrGX72qHvq1beWroAP206HexX5gjfQ7NV8ctY+3c8p34W2Oz52jp8jRGdOyeieB7s1r+jVjBHWtXE2ToCJ0IgrKRRAXtEhx2n2aakSTbrqVOamktgLc9UYJbPGYz87elv2mU4Uma9WOsg8EaNX5tk/ygPlxBbUicNJFhMfdn1Qef2n8wT/7lcP4hmxn9QwcvZtoogBvpWL+3mkx8Nh5q6PCrGbiZUUmQF41VwLQtATQ3FQQxJSeWYzFNdgT5bSaSK6gelgdXb/c/Elxh0T2WSPpTJFif0Ne6RRFlp5cbKAl/iu6w
 2HStzb1l
 9Fp7aphHrrLzz5jUvPiOVoy77ujHdClbAbF55AIRT+cjHsBGhdDXs8dUVKGa87aNF50V5qOWnLkXsej608Civ0p1Ay4VAW6sWpVB8rx2jd35EfikCbSgcb3DN/cFy+z8NrqOq8lDo38lY8sVxBFGoGErViGwGTd/6cpT18J4BHBQKku01JTPKj2/n3/QFyTVEppxvaDDykvPk0wdCNu+r8UeL9AvDQLYQ8PoI3yqHBBxJQMJFM08B6boIlZ1p1Wl7eaSlV3p4xLbzPVlN4lrlrbij8S7a5TLmEgIzZeIQObTBMop70cjzS5JhisI2cF3kimZ/Weo3QcXH7BGmJUp6Su4QQ9OnFPinh2BgUOdI6p/40D/Gn+XCKMIGDDYQlnhl/4ZnCJNC3UQAK6p/fyZzBQnJ93UIO9H1jZLyOUPdbn9B/2uoGTdiw2j3RE6Tl1AGW/wV8UxJvpcbGHz0rU4sOPmdB8IIu3028aO3fYNtBoZEZvBQ7KkorMPwaGXOsARdu5i9ISnjVKMk4Z6ag23EquClYADQcyDpekRcJWJsTV+DZfY=
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
> 

Heads-up: I'll queue this (incl. the replacement patch for #4 from the 
reply) and send it tomorrow as a PR against kvm/next to Paolo.

-- 
Cheers

David / dhildenb


