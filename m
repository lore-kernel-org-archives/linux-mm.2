Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C757ECCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 20:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDBB8E0007; Wed,  5 Nov 2025 15:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4BC8E0002; Wed,  5 Nov 2025 15:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05E88E0007; Wed,  5 Nov 2025 15:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC10D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:11:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90B08160481
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:11:57 +0000 (UTC)
X-FDA: 84077649474.25.B6A4FCD
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf03.hostedemail.com (Postfix) with ESMTP id 32D5A20011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:11:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762373515; a=rsa-sha256;
	cv=pass;
	b=Y+5BAhKJywY/Qt2KZiBFJz0JLRcVAeGFq/2ZsRtUnqIcrfLnPUy/RjxNajGEGf2vLDKfKj
	MuoBO9OrnE+S8s3XA+Urr3xrKvr7GO6njM6J7RYKoGsZuMZtDYt22bzUGhybws4MRQ+Yem
	WkEL39L0cENedGj5QMJkCUmpXhnyk3Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762373515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TumQxLyft0zt3kRPj4Gvce84mIv/VXDVvsyQGcXgpBE=;
	b=AfDAx19t2TLnuQsyAH3ZBqh1+Mo3zpE5Q4BdkruC4B+3ut5xoVzmh1joXs9xosREnhmAUf
	jNTaEc7iJDv6monMtERB2BtiVc4gg/4/ZuHpsAl2y/sOJiwjpurXd5EPb383keoVTAVLlj
	vUYsvUEgI8ljZ9SOQhE24rH6+52+gfU=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF6D259155
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:11:54 +0000 (UTC)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8241FB9ABE
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:11:54 +0000 (UTC)
X-FDA: 84077649348.02.FC5E9E6
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 798E340014
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:11:52 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762373512; a=rsa-sha256;
	cv=none;
	b=3z6EipH0IUh+ZA9nGZsh52yp0wDJa8kVLcRGB5SU/m0qW+h6kXM9aXMLn6Yy67zGDMvzgO
	oPmuuzicX03o7+MS80HpE2ElCVfTaWAxYKf1kvtTM+UnRnYL55g8YMd+YfRPiUbvKbtC58
	oq9u7QvaQwxwRm4nbhlUJGlTbO7G2wY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I2hJKpW6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762373512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TumQxLyft0zt3kRPj4Gvce84mIv/VXDVvsyQGcXgpBE=;
	b=OQRzZ4HQ4kWnJJkQQ03LIFYCKW+t++1p8Im4lCH+3gnBXwTg2zgMJhXPCUJdhe3nK1w+mx
	8bJdJwbjD7F0WwLctu2TvGqd7QyfoNc/EyOryMZmPvQiJvG7ID5RcNXS2+ubeJqEJC25O0
	qlq8XgiH477opqu76bv9Vzvey3cc34Y=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4710683a644so1628185e9.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 12:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762373511; x=1762978311; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TumQxLyft0zt3kRPj4Gvce84mIv/VXDVvsyQGcXgpBE=;
        b=I2hJKpW6hxBNiw0Z99W3alZg1Zgb/SZEeyHKTghztMeIjZv1b7FYnKkLTZkfPTrjQG
         tPJou+M/m5aqxK0EHuuyXX87j77H0KPq1sCsdnTsTyyhoJ4s94xB/bGsAcIb/e6+f3aK
         PCfFzMR67ojIC5X2G27gMVkQig8eU6hyqb8p5gCM+ZP5TBHtsznT95TDR6/zlWEVsQBV
         MdLFxUjH2gGEAupYMIhvWf61oQhemiWiaa5k3tUVSTSVeZ/Efq7skvICXEn9ycnZ+Vdo
         PD0vwzx8H+5vkrnvLoO2LYMD+KJUVQO5a1uWMC4/HXA+zEMMYFGDeDrAZLCiPrBzJg7N
         CXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762373511; x=1762978311;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TumQxLyft0zt3kRPj4Gvce84mIv/VXDVvsyQGcXgpBE=;
        b=iv29YTNLK9J2uMUKuzUM3q8xBOaSENt/s7FQI/t4vb7ZGUIYnz5YvQblE78nbdpsIQ
         GmjZGEPXsV+C5qz/XVxA2Ri+HXbQ0b20ZZrvwh+q8Y2M2Xsu0tHyIoESRXU5QwhhT/9U
         mCj29pDwEdIcAN1I78foAVBEPQESw2ZSFhXxR/4N8smARdOrTtX6rmvPve11d35e7lWh
         DKK6nrE0UVK8lnIfAvtkRe5p5zZPwiNNCNUu1yBndfD/yCVTrbzoAe0DNIkQU9TTFEow
         lFigq+0QqS2o9hcwSJfoCTuimQNntqeIb+5t7gSMqWV7F3VHgQI+CI48aEVcUDeJ0o07
         rD4g==
X-Forwarded-Encrypted: i=1; AJvYcCVLyw1QqOVg3U5iT8DyxY3++AHTNlrEgfdz9O1oN2Z0y8W/c2p1jxSe7rgFMdw58mPmDhfS1h6Vuw==@kvack.org
X-Gm-Message-State: AOJu0YxgYaSdON9HyKXzBsqOI7XpxXYhsAbTQrA2r62j/zW5iDaVBkNN
	uJtXgLFYbx82MGrKA0KkuWD3DBMW7kXjSQUphAPnHvjeyWc7ijwsrPfI
X-Gm-Gg: ASbGncvafA6oJ/lY8QHv4WA1Y8tAVE2GDaGLy2EmjlUx7onBxrGcaG7IGcQUJce3hVN
	HQfiOumi9Cf9ZxnWwBLRaAc6WYb1R/Xj8pley1sNhZwWg+j3hVR/LHlE1lXXTOfxZTndnoys5RM
	5CEGsd/dghdWmIEjxvCAKNEHuIGXYbubl2x/Cp3cdWUUK2Q1SGvY0KUHLoDFVMCg4q6StV7iMjk
	o50vhi7BhJFOh8q20IEzpsLMQ9h1vT5dTu3Hxdl0+zvNEbl892uX8cFfeL7r1owmGTjpzfltmOk
	fi6wcjsM416pKLKttAMnZZ5i9gBvz2NEsrrkozPDIgSJrbmHHT1fWMAVLGCdIHINgonhUr9VAld
	mX7/dSjpnRunAOn+77iYHOC1Oy9zC/+lanH0ZxBD1Q+67O0VRsZUbcFNGvR0EROQHsscRmdTDhi
	ceQKYLGPgg6qfzro50fvWdDgcc9OtFmuD4N1Ht/O1ZfiL5gXsh+GLT9X3g5twdRl4AH/4BzVSal
	h+N2W/X0yWyQSHG0mgL8ojAo0fvrMI=
X-Google-Smtp-Source: AGHT+IGU2uJHKe1jjk7qRSxlMsv3pia9G9MZgIFjxGc/cMqJ0vMZlW4f3Bo9nX4bKGT6SOm0X+42uA==
X-Received: by 2002:a05:600c:590e:b0:477:632c:47bc with SMTP id 5b1f17b1804b1-477632c4936mr892375e9.6.1762373510748;
        Wed, 05 Nov 2025 12:11:50 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47755938f45sm51392505e9.4.2025.11.05.12.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 12:11:49 -0800 (PST)
Message-ID: <7f507cb7-f6aa-4f52-b0b5-8f0f27905122@gmail.com>
Date: Wed, 5 Nov 2025 21:11:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQugI-F_Jig41FR9@casper.infradead.org>
 <aQukruJP6CyG7UNx@gourry-fedora-PF4VCD3F>
 <373a0e43-c9bf-4b5b-8d39-4f71684ef883@lucifer.local>
 <aQus_MNi2gFyY_pL@gourry-fedora-PF4VCD3F>
 <fb718e69-8827-4226-8ab4-38d80ee07043@lucifer.local>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <fb718e69-8827-4226-8ab4-38d80ee07043@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX1/m5xM6l7cmqFV5ztHcZU1M9Hs/mryPhXy57N4BMdhXomeysu8LrcpvdRtICkVJMrQMk97zrWZv8PficEOqSxmEsonAdp6KifgMGOYRu5SFUgbNxyq2uDwm15c3oohSwlbZnDV4LDrr4CwDYCroVJtUyixS+9RuCgPBnzjOFfkdFJS7aH8ixB+LyzVaJ4gKbupIPZ2n8rAoKG2yJsA+hN/RYuMe/zBHrATrBQLd/Jp/TD2G11kISSX8R3l9K8qV0d35lkAskl9La71JiFK+VdMw8RubHBqHFwDGnjGLWYPI2k7b96porOQ2TkH21K1k7kd4wxYwCqrMsPshYegcv3vjri2njzVX6d6zK1ir7E29t/Ct0xSL/0XS24IEJL9zAgTH1INPuh7LIIe6YKxqtwCRPwMwVFICBLN+LZixMoelqK3LSyJnXjBAVOYov1j2Epx+c+nf9syLzNOTNSRP5Ko5bsOM3s13n7Uxs6PG/oVLpGW+pOo4DaO7pE0utj9ZPEnIkZFDYrt4RAoDEz8AUZcP0whQfAoP7cNyP99utFUW7XwzzsNML9N1YOUP10fd/zxTsMeEtefGI/Wt0wuGZTebCV38QMhW789kSnIYoD9szktmqJwGztjbhXFZu0J6mRuQg+bf0AEJpHmk/VToTxld1lkcqeWJJUFI4G2JE4Z2bIQ0noZXWb9g0gTrw/pbasKq8qKaXOMkYohEqgsHN3NAvOLlNjlkBV7PvsFHXvc94vI5NxqLiHIdzqo5xehZNHbrH9gDWiDGcIDA/gsOtnOovsfJRrTjSisgUwYq07b74gINw15IoAq6O4JGyxE3IEmsoNuQjQo/gQV8xPlB3zGZBVpZ1+EZEuoEHEqtnsUjEGqUnUrWJRZGBUQy+omjufIPTQFZ0HaYJ5eReGALaQQ46FPlRvmMDCy2bf9871eXmdpu7VLQ7s9T4LcPtFHO1y8+D8VVLnp
 P+eBlU3i
 K2dTgpoenRAn7Uhsa79qEwnKOAn/Lkiyp6m8JEj0zP5DodYIV9yLr3ug8VFcr+MeM6yxi/OsszPju0xhd0bKeIspYANuR1CLDvdjPKjj9YMHQIx81rqMf7LvtIhX+lmR0CRAvfLMh9tMXcPd0lHPWVZRl/MgzmnPow/KxrbcEP8jWKz98Z4RGfqcJBa+QaKKqsexRhmZuad9lYm2Z0ArGvwcFB75+az55QHJ1f3EvU4zV5a3blBsTCWaHE2KDCEtM6yY39tb4AHPYhvFydj0Bu8Anb3GupRxjgRwxMWq7YdCKTOKKDWoPiU8nYDex6/qQf3NBbWKmhzjn2JE3hDJq0avD1lIRHbj43c0CwjkX6wBuM+T304bH4reRcVHFiKJocTh42rdm3WwIqUv4QIpHX6+gIptCNDzorUA9gz3DaW38SImaO5VHMiCt/mVytsOSFmqPWdmYkax1XMqqIs6au4v5TLNzZJN6SUEaeQP1T85m855kcyXml9akog3w28Zm2LF+Syz0YoTAO/coUTbkNxRTgd3DBqrdkyhhkTmg4ns33ZQ=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 32D5A20011
X-Stat-Signature: zmh8p8r84ixcbzzbupb81wirdw3464tr
X-HE-Tag-Orig: 1762373512-943294
X-Rspam-User: 
X-HE-Tag: 1762373515-856138
X-HE-Meta: U2FsdGVkX19H9kGksQ5rHKd8gSQ3bFzB8m6es0O994i3xyx88MYmJOVd0uCyfTu4RH8bX/oW2dUWoMhS2D6xRquK3+wBzYxRnULDKc6v3PrJky5PMmLRQAurbt/3OdN5/YfseAoNHB6aaDpYBd5XlNNuiynpAxuCS3RnFd6Lk3VWhLfls3ve4yOp1oJAjyYmzD+5HUmuTghnvPm1cE2Rk42jdMIpYwL7SADNEPSXah3l2LwncxglvgXvydR2hYJKhHZ/Dx5PutRuBBMwbOSj4wVw5p01dxhaNly4bp1BMgND58cbSJ1R9hUXrX7WtJqpxLG3hF7/Pf1o5DwEyUHVLZFTV46OxqLMOsqVQPc3FqHAO7+Sj4AUYWg3uk6a4cALrTmP16IuaPsmGke8nsZKALNviwfNMWEs54IuiqjriNew9GyHlNT4iDyB8hkddMt6nEoqVWVqXpdrYIXEJIpwlETG/VyJQ8awvKJtBQJuBbcKa3JybLySXbAVwGMKWEQinPtVrFXaIGUle7UdyySr5ZL+ThHV0f3+IFGx8pSImcwlnTZD2aM0OOWacBGddnPst2JZKf6ISi2F2tvdgPyfIr3UnYRzDFcSIZgNhm7BcmLZAyLhVHTmeJgJoDiwsZcpfR+jU7eu8HvJNvEsmPwLCgvgfY/NpVfnbIcPoqEm+kDphZOJ+hWK8rFiPcVhDsWftDDTYWj09AMn1jzzYJArj4i858ULlW2814mPsTR7h4G69uefSP6knEaNAwPBpQhgC/MdddO9kg7rtQu2HzoKFA6ylNI0r/UJZUvHJHBQOGE56k3lq8yo4HOXrxDJJv/QfhmXg5rE9ma020gume8zqbxeW3yPMumLkSxEwQ/hLh9+yaBtwyh5iD4vcbcsYgL7gIshZF9yKMeq2Qxn5Bo9da5jEITzeHtl55TU+2ZT4ZNfKgyeAm/EBrWMXrVUGi7KBM25M8weMMlEBTfC/pO
 zWnXhamE
 D2L6hC86JsTWYYbwQ/MqZOykbzuRB8+VijIQd438A+jt5380MW12Bqmu3q9/2a3v0MZXbmni9DvJxdsaD89IHSpX1xlDnoflqJk97gdpxHdVX/uTR5/DzjT3u41xOOO5llyvR47ndyaidKjPZFhBJjIgzg73zeOgiACa0kRBCnESDzaLQwjk09aNF+kZQwemyLcfGyKUHX/t7r2bHgppCECpvFwnt8nJKX+atGUcmhlmSyAYQJ4m1IqLFobjIn62BQV+x44O8ouNbObJHjGEg4hzZgOKpuUy5hZs9pLZJwoOp/n10V9reGAN+NF054SnjZC5J7M0LHPRaFHb2rMzqHjmegUH5r98JHxd7XVIAM1HffPkLnRYupo6Qxa+mQiVFiidHzZPwOJc+fhcNJNbhnCnGBXROH/cEtgI63G/cVNeclsPQrNpsWunu5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 21:05, Lorenzo Stoakes wrote:
> On Wed, Nov 05, 2025 at 03:01:00PM -0500, Gregory Price wrote:
>> On Wed, Nov 05, 2025 at 07:52:36PM +0000, Lorenzo Stoakes wrote:
>>> On Wed, Nov 05, 2025 at 02:25:34PM -0500, Gregory Price wrote:
>>>> On Wed, Nov 05, 2025 at 07:06:11PM +0000, Matthew Wilcox wrote:
>>> I thought about doing this but it doesn't really work as the type is
>>> _abstracted_ from the architecture-specific value, _and_ we use what is
>>> currently the swp_type field to identify what this is.
>>>
>>> So we would lose the architecture-specific information that any 'hardware leaf'
>>> entry would require and not be able to reliably identify it without losing bits.
>>>
>>> Trying to preserve the value _and_ correctly identify it as a present entry
>>> would be difficult.
>>>
>>> And I _really_ didn't want to go on a deep dive through all the architectures to
>>> see if we could encode it differently to allow for this.
>>>
>>> Rather I think it's better to differentiate between s/w + h/w leaf entries.
>>>
>>
>> Reasonable - names are hard, but just about anything will be better than swp_entry.
>>
>> SWE / sw_entry seems perfectly reasonable.
> 
> I'm not a lover of 'sw' in there it's just... eye-stabby. Is that a word?
> 
> I am quite fond of my suggested soft_leaf_t, softleaf_xxx()

We do have soft_dirty.

It will get interesting with pte_swp_soft_dirty() :)

ptw_softlead_soft_dirty() Well, at least I would understand it.


