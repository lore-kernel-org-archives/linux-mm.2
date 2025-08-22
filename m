Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BD7CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 06:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64117280011; Fri, 22 Aug 2025 02:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618D48E0056; Fri, 22 Aug 2025 02:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50825280011; Fri, 22 Aug 2025 02:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40CD18E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:24:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6725118311
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:24:40 +0000 (UTC)
X-FDA: 83803404720.01.2AE5277
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6287B4000A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:24:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JUuDx/mI";
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755843878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiI+ZnCzEnb/n6DQfRPkU+9oejYIM/R2hKOTH1yevco=;
	b=b9RZeFt0zn8iByPd+6/Fziwi6DAAx2yAv/yxY4ZxUq0Uv2avIgLs07+ZaxEm1VdfmdthQz
	35F71FGkfiaiiTFKsFwhwuN05CRbed9FYRHMT6nH6ih95ctHBg+jwkuSlFtgsLkxiPvAMK
	Q6gnKbuLSiGq2bVnnQP19pg6V6dy2ok=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JUuDx/mI";
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755843878; a=rsa-sha256;
	cv=none;
	b=70ZlF8wbHVsVOm3zMDfhyUlE8IqFkK6AGWVljCOHt5V41e/hUT/FahbjU66bsAz9SY7/SR
	7yr0OZ8GX0f2+Q8GW7O/EK9PjQ3iXW/G+JNeQSOIlT6AsOMMQoBzNgIlQUOKdj7nwCrl0s
	mQyyxbqakpjn9XjlvZfMd+l2B0lvkTs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755843877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WiI+ZnCzEnb/n6DQfRPkU+9oejYIM/R2hKOTH1yevco=;
	b=JUuDx/mIh1HjyqVIb1gxTmOSbawlExlJEHy+T/G78xkeOa1aDOsr81JuC1jaDFHmmCJQYE
	ZT6pMSU4frP+G2bMSgz+u3vbvrUtZCmY8LQT56a58zFfXe/EV8l+Q21T1dBhzkqoHkxm5m
	mZ5pHjgZVeGVNjfwncuqOwW4u7yjRKI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-mufNZvoeNPGA8gREE3fuEQ-1; Fri, 22 Aug 2025 02:24:36 -0400
X-MC-Unique: mufNZvoeNPGA8gREE3fuEQ-1
X-Mimecast-MFC-AGG-ID: mufNZvoeNPGA8gREE3fuEQ_1755843875
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0b46bbso8119925e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 23:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755843875; x=1756448675;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WiI+ZnCzEnb/n6DQfRPkU+9oejYIM/R2hKOTH1yevco=;
        b=SStn0qpLcjDrJncAT+nH8G9NAGeFbViI2UINGQWiJYVUvGLwTgI7ReDxdzcmmPBkdM
         bMuEVPaZS3LTfLihHQ78QiCApu5kdF5G1WzOQOG++ImeVgfRXftuIS7DobhPXW5zoI1Q
         wpqh3E2J9CETahwz7PhfCx0pRYuSFmULqCyO3n4JkPxyeraSbRB07+x92hFzP2QDnZGC
         JbrdMOnHVSq6COQD7JKN/v9Uq53Q9pstACndcHR2T0BP/tco4IgKcGH7FZqW5KOCRkWZ
         VOhu14fKV2e+8QZ3Pkl1vKfkCibbrgOzEhx33dTnLnPJDojzgUINT++2vSHvD0osz473
         jftg==
X-Forwarded-Encrypted: i=1; AJvYcCVL0vUVHKMzs4ssSEYY///kxQYFB6NWbZ9OgQOfq9972ZfaoTWH9jZNXKt36yC9FGYEQH5dtpyMyQ==@kvack.org
X-Gm-Message-State: AOJu0Yzr00QVGbzCN274FJbuwnZ1Wj4HDjko6Y7Y9ecNsdi9zCehEwXn
	AK8GFcYOuIaKe9uCLQXzpovekn4ATx7sLxqByp5cMai9dkw7+3LLavJAmq7c5a6cZtxsoWgb1+G
	QFvSkPVM286N9/HmxZDY/Gcbig0Yx1i0a9WwtdM4xW9KcmIBvfhdm
X-Gm-Gg: ASbGncsC37SrbFH5+fqglHBdyhi41JnPmksEsDUpL0dPR7s0zHYjJSk9/htrqSJRLjH
	5KC9OhM1ZZX4O54F4UshQehTnKVwNY83jfb7Owjr/AtjRO2MB+VtK68STAv32mBxjNMcLr/Xd66
	IEUxmDW1zSkxplKT4UjzDJiju1vlvyPo600x2aiRzKb9SaOo6zBCjrvK11MsA8HqomB6dawxVIm
	5HTiAYFcQA6Gg9UkbaR621QLNUMzHfiYWl9t/UQ55TCxOvX92M4mR3eK/dmzwMqVE58uFjZhYR+
	xlDYHuM5CvGTeFTDj2Cxg0EelWTpZ7eA5Bbt02M1WoeF7EIcbcB4yCdLFHt/ez3vnR05og==
X-Received: by 2002:a05:6000:26c1:b0:3a3:7ba5:93a5 with SMTP id ffacd0b85a97d-3c5daefc4a3mr930342f8f.26.1755843874918;
        Thu, 21 Aug 2025 23:24:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkMOIqwJnbz0zMoKzv9XjVteH9mRf82hflWECX8mqHGwhCkTy10DA8QnyI2PcknGc6Szk7/A==
X-Received: by 2002:a05:6000:26c1:b0:3a3:7ba5:93a5 with SMTP id ffacd0b85a97d-3c5daefc4a3mr930326f8f.26.1755843874452;
        Thu, 21 Aug 2025 23:24:34 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f25c.dip0.t-ipconnect.de. [79.241.242.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c6070264fbsm1198544f8f.67.2025.08.21.23.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 23:24:33 -0700 (PDT)
Message-ID: <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
Date: Fri, 22 Aug 2025 08:24:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
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
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PVZZvR1hiZvwJ1qPkuJ_wayUUpa_oyA4Q_zb-0sDXSM_1755843875
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6287B4000A
X-Stat-Signature: qi6opxd39wn69njrbce349p8wqg5s1kp
X-Rspam-User: 
X-HE-Tag: 1755843878-468759
X-HE-Meta: U2FsdGVkX1+TgnTNz4t1vg6geSVK2c+s74LP3GsJSLAoxSn+9Y8lZrrckqVKqkC9JKQRNOvbSzvxFpmFUdyRW7R01PfRJYvOG7nfJgHRUgPWo8XRazYxxf2C9EB8iwDGfBY/2MNf8NHbZflLq+T0ouF9ru2z345yXkA+BmdkTU0W8YrcouFEnfaIo5AMAs/70vpp/u7Rc3ZyNW2XuKkfBrAJUaV4cVTeJYrsj/LHr79Jaezle42Z4j+j7yZChnvdqW0jwAwG2C/OmVZ6ZZsPqeO9HBwUO2O001+W8wrEhjLG96iBuAjXVJ7WpipS6j6OcIoUjcf24l84hcu89RbcJR10hHsEYGvF8JunFs+eGYX6UIyJ8Go6WADIDQuA1o96QiWFXAZy0qOdBT44eBTdG9yINXf0sXOxlKNtDimoJADRK9zqDFzEboIjf8oinA3wUTLgp36WlCdVUdp3Xa9sBgyVBmq7MkmtOVenCnEZ9kPiX/XaCG0+MbyUfuYVDt2ZvoML9Up2cEEDWJQOojhqn5dj1p733U6UnbP1h5LgCOji3uf1EIxlca/jjT3YsvAInZyVM7/g/VK5aKTgAZMVVSpMU1wJzWHviMw3iRPBpUAP9Q7IG7BN3T+9LxhoKZalm0FiCNvhu13FWV50OQNsGvRkXyI3wSoXIThOo6GtTtPKR3T41XVyBmYULR3rjzh3w8DcCxMsxpHhMvjjIgSWEfVEgUPdviT2IfcmM78pYC3stzgn/NJeq8rTzCMAgkJj2nIdQwAtT+gFTzxf25PPv0jmkxWi1Ab3bQvb5ZgB7e5J7wzPX8x9QSWcvzlxWp7TnlHBxk7qQrUF3+Af2fhzTWBprlRqICgMAGIp/+QYAL/8N1jsoWZi5PA968pUoe9uJsuDZ1MzY7yUoaxncymk1dp2TO8pIGxdyeoyRrEvl/3Pvyh+AR2NxJpE90/fAhSBHyk/rbt0Qmhlh0FhsVT
 S3+FAnDj
 ynE2PjGRwePNDVydHFcAwfTzH7dUjjF0OiVqgAFwF8gfjQGCILE7oiaeiY90FlQGC4/0DBC+eJYmZ9E3H6Sq16VX17ClHuU7yDGTSxgSRpIrXq+bQH4rPD5nQSXfIrHQV+1/Da8Q4EP0tsq2+pIVIWB7cL2XfSX7f7cnGp3jia8XdFvqt24p+UaFWkBSb1XG7JAHVow38+QTULgzNESKGvrygZx9uERfywRp0fXBqTJS9cra8cjl+CkOfQFdC3VbCGZ80+UD9Wnd7JZZwSUIzis9SF6PoFFzSBHD8i/eDdjmWG6LB7HJw5VLfr5mvrkvdwyf2LVJT0TTj5hqMl6DStsx2BDpcRcEZ3GDxrZg3jYksgUeHI7sQh8ctjoMj+Qa6h19kPNbwhbRSg6bgPd8EZxBLONkWzssva4SyGfUchk9/vo2RbFnKpM3ZS7Gz0MF+i7oHChuKV+slS0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 06:09, Mika Penttilä wrote:
> 
> On 8/21/25 23:06, David Hildenbrand wrote:
> 
>> All pages were already initialized and set to PageReserved() with a
>> refcount of 1 by MM init code.
> 
> Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
> initialize struct pages?

Excellent point, I did not know about that one.

Spotting that we don't do the same for the head page made me assume that 
it's just a misuse of __init_single_page().

But the nasty thing is that we use memblock_reserved_mark_noinit() to 
only mark the tail pages ...

Let me revert back to __init_single_page() and add a big fat comment why 
this is required.

Thanks!

-- 
Cheers

David / dhildenb


