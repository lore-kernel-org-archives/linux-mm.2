Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C290C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D61E6B00A2; Wed, 30 Jul 2025 05:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADA26B00A3; Wed, 30 Jul 2025 05:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA096B00A4; Wed, 30 Jul 2025 05:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D31D6B00A2
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:58:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13CD5113C7D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:58:34 +0000 (UTC)
X-FDA: 83720481348.14.0E4AE74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id A35CD160002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:58:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K1CMF69f;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753869511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVzaspBXmBeFOC5r4SwHbIYNhPqgXvGTcIV+/8vKIhQ=;
	b=lr0KUOzvP79eWwMIl0/QvASygbtpAEADX7kMrlFDp2+600V7Swa9bEVK7xFyM/RkGe3H52
	1yXos1zBfvncgcaGugC9KrciMzTtne6plScXagiulnf/tpOTGcaOiHoDRJ0vzVkuDSvwMl
	g0/olyN0A8+GziFMS2yt8RXIi5FsWck=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K1CMF69f;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753869511; a=rsa-sha256;
	cv=none;
	b=4xkLD+FBZ5lvP6MNORcQLfuRxOavVzkLbrt7PYc4kFQewdM4we2sNrEVqBQ5y99PKdEkPA
	KqnjJRQRVJDBHLvDCAvoJdyjSmtspEJzDnsaFRhf43h00wsbeKGIN7+usTZyur5aWFpGLx
	RWP5xkeU7mdrr03ycoLZTvgM+GN8SEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753869511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qVzaspBXmBeFOC5r4SwHbIYNhPqgXvGTcIV+/8vKIhQ=;
	b=K1CMF69f2pN3Vt0tLL40U9sLCU5qYpXC43LFfiWGoufMbwGYXl+7E954crx242u2kjpQ9g
	6h72wqLuxVa99x4EvgjfV5mZyXpzAhk/d9etRF3xB0M9fj/GSEv+hWR1vtMH0OsGEGZFeW
	PLWcsk38qSNYoS8HTHeW2YgmRrgnCgg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-GE5k1SxHMdWNPftrDGMl7w-1; Wed, 30 Jul 2025 05:58:28 -0400
X-MC-Unique: GE5k1SxHMdWNPftrDGMl7w-1
X-Mimecast-MFC-AGG-ID: GE5k1SxHMdWNPftrDGMl7w_1753869507
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-7074bad04efso14553046d6.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753869507; x=1754474307;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qVzaspBXmBeFOC5r4SwHbIYNhPqgXvGTcIV+/8vKIhQ=;
        b=beBOLkkG6D4Yrg02pB7ffg67Ge15ESaGna+vYIYYQyTcrdY/G4EkyMd3F/B+3dDS1Y
         CLJnOXNymfdv2edhEYMRIABJ0aFee5H5PSsp9ko+7RWT5Qi0GWvLvP7x3wSbFJZfhOf3
         HZMBDSg88oKG1WjmtpQtDXoJzggcmAU94ZqMvlk6rTDzTR6MtyTnXziP/OoCwwfGZ3Ul
         vtmxuPFQCzrCLrQ8YzoB0ABm2y5jVLBdtmHU+FzC2Ew8gK0qOk8emfApFT04Ioq5OQ6n
         QajfB4YBoIOVX66wUv8JmbOr5/ghfAwdx8jGouSMhQa0i2+ZrIclYegoty84yrdhNQ7a
         Ds9w==
X-Forwarded-Encrypted: i=1; AJvYcCUwuKxI61yu8iB0GBfAT3BIWk3lj+1Ji9VPMDIZRAUW20cT41t5b6b3NVC8l/El0KlgMu/6A7tKFA==@kvack.org
X-Gm-Message-State: AOJu0YxFfxW2BGepY6w1JN8VSBdLpeDM+CrbFo9edNlLTq/SXuYPnfLs
	ugBk8LfmV2MxCBaG1jvYTA75300BCCl1m0GQbzVZkihSvzM2lNFWX/exz4ZXJ2BRcuN3wsp5Mek
	ypynSaqd81FyaywDrxE9Cnf8eDH9gd35OLeXz4bc+17xuRVbdlik+
X-Gm-Gg: ASbGncs/tKbcNMsE9Owg7GYxUtO4tnWYisrukfo++4GYyuftIeNHzTm+J84iIk9ZfsH
	MYKQaOfp2gxdjL6vQ7EZUhBjNfFGumn90hDA7j9PsACkxGAGUYs2YQuVAvteEzXtcOlasVeYMCk
	j+9XvwrzsNGwtrldpx5PMDhK644vdXm3SrOQcmlaCzvrggHhEBHPlVL6GbF2tgryUJEZio8XW6s
	JlJnh002Gx5cyFSUpY70QM0ENdMoMT6bccZsh7j4lDI3bHCXqzK1DzXnB86KJZ2fi/ET2cZZabu
	7g1CeamvwwVNIBBIKoT+Co7G/6b7XDk4yHB4wesw+RTa+jx0RdHaKf+F/HQ4HQ==
X-Received: by 2002:a05:6214:5689:b0:707:612d:3adb with SMTP id 6a1803df08f44-707612d4f30mr42041376d6.18.1753869507075;
        Wed, 30 Jul 2025 02:58:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyWF8t+GU9zMFLmNowgI1RoDyKgjAESlOjsdZQY4VaxzWNfocJJTSSNXHGRxG4wRuu7bvYRA==
X-Received: by 2002:a05:6214:5689:b0:707:612d:3adb with SMTP id 6a1803df08f44-707612d4f30mr42041136d6.18.1753869506628;
        Wed, 30 Jul 2025 02:58:26 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70729a9cadasm57161066d6.34.2025.07.30.02.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 02:58:26 -0700 (PDT)
Message-ID: <65e9ee9a-3b64-4efc-ade0-83990de7af91@redhat.com>
Date: Wed, 30 Jul 2025 11:58:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 0/4] mm, bpf: BPF based THP order selection
To: Yafang Shao <laoar.shao@gmail.com>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com,
 willy@infradead.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, ameryhung@gmail.com, bpf@vger.kernel.org,
 linux-mm@kvack.org
References: <20250729091807.84310-1-laoar.shao@gmail.com>
 <08D7155B-84F0-4575-B192-96901CFE690A@nvidia.com>
 <CALOAHbDRBs8bdXB_LJjx-7gALOCLvmMxFD+c7MbHAiQ3htXawA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CALOAHbDRBs8bdXB_LJjx-7gALOCLvmMxFD+c7MbHAiQ3htXawA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QLlJtu6lvgSHDmwFOmkdlZ6SnAzGI_rjJTWW1j0k2uY_1753869507
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A35CD160002
X-Rspamd-Server: rspam06
X-Stat-Signature: ij3cowibb31j4ei9usm9ror5kuahrwgc
X-HE-Tag: 1753869511-88170
X-HE-Meta: U2FsdGVkX1+4UHragEJ79b2p+3vXGC6V3XZPNkCVfhsrwItED/9j8NLwVgmEcwYeUdNyXY8cVQbJ9DI6Gwh3GWtq3MAiynDQhJDExzsud5oSbhBz7qpvQiSix6t3pDsoxqDOsMT/+tQPBCOPp8vwL2aHU7G2cJjDGG0EGMVA7iQ5S0rr6/4YZwNE/RUXK4BWZrPnNhhdsZ/rsxRAeLBslgdG2oXZZPesMSNS5HJ2oH0cXtTqdHcpUTl8k1gvW9j6KWw38zqPJ6KF+TFD1YQaBpvhcqfbIssT8U4ipUH+4sB8fp/cbkenrx9bAZgCYPxQOMegiVjQhRO3oFk9TH7xzxiFlC1x9HI3+alC/W2WmpQPsYMwEJTVv8TnIUWpYrLajviq5CPRY2XBxnTKMr96Q9KnFSy2/2NkmkNdEdysiBe7KYcQP5nPJWlG83ETqvpGkJ7vIQTWIFjftK0aT7WxDvK/ARrgTCkv9Lkjg3vU2zJdDdqSL2Y19bDrz5oIej9H1YG0JMUK3T4f6HN4vp8wojxpPA/oIREssM2y8ZXvyHzM8fD5nvRf6x06/T7IyT+w3ddKUH3a+ufEjmg48WIFJK5OwJ+7anBFIf20IBxv9DKeC7E7c84mT/hy5KDXvVXAynWnVebf5z+y6vil184aE20Eqto2S52HpcvYVCGpOmr8Q8GNNJBcvXkzjRb7twqL3QOxsWA+OxeRpE0B+I+vlYVQIzQB0x8cDSnQcLPZq83FvnTDT+BMIKUYko5HZ328Snvv2sWYfhVEdDVXXLSaYg/wtI9CkcQLtkH3qdrF2CkBOguhXVD/5FLTvxDdrmtZLPurdYcwOxnOtImd1VwppQRqxO6b7sA9AoFFkSIPXtUvYzpEr0h4XqvmzIrhDJo2R2edFTV08z9VF93diPxS3VNIH/4GSNMmCaETm/fXAzcr5LRDuKAUoPdmjA2RGOST/LttEK0+a4cTC+Dl/uS
 N/Ztbgei
 JtJ4ix8OCOZlDlfv1/ok7tDzLPiEtZzpjMvYvTTxHCKcdxPI4Xsk1mzICmN7ZwQYO8iyOoZOPwfxv/RxeXkNwSfnKTM/sh3a05sk1tY23Vjvm8jAC7b94K5LLddZYpIenmepKA6KT5CRUinqE15Wf8FHqG9mrlwoeASoRgzDSo+BFJvwjoZCOBT4RUEsJcKg3D+y3+ZUtvB6UOqF/8JVpK67gwfcY3vKdEUkIsmKWGH2tpnpBLFAXK3G4C3RYGYntjrK4b0Ja7zdz8pKR8KVOCb3FfUrzflQcLj6fbgIm7ThjA8Cj7DG70UMnUZGI4fDB2t5y7aj82z0GQZpw1VWN0FOFAEUC6zHUvpCAvDsB+8dRLmlxnJITEfjVW4gyQA5R/6Eii3VOeGxXUjQNQKKXxVohC9l6MKstkSP4/HLR+qstgti2XvcElXlmHfkA9gZfYb0mHiOIKII9q5fZG6NzG2vHixX47p5MxtBM2MnH3BjddJflIKw9fAvchDTOvV9fDj40Ha4j76+I2Di4bC32I9UshaBc/VWOLAi3n7TNu26MjxRqTGAjrzZDS5eq/XRYzbS1Wt0/vR4DIIPcyo1ieBCpMRqMxwSXx6XPA57h8hbvdGU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Yes, mm is sufficient for our use cases.
> We've already deployed a variant of this patchset in our production
> environment, and it has been performing well under our workloads.
> 
>> Are you planning to extend the
>> BFP interface to VMA in the future? Just curious.
> 
> Our use cases don’t currently require the VMA.
> We can add it later if a clear need arises.

We should start immediately with a VMA-based approach as discussed 
previously.

-- 
Cheers,

David / dhildenb


