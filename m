Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE97CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870E38E0006; Fri,  7 Nov 2025 04:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8214C8E0002; Fri,  7 Nov 2025 04:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710658E0006; Fri,  7 Nov 2025 04:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 590478E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:12:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BBAAB91AF
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:12:09 +0000 (UTC)
X-FDA: 84083244378.20.1EA28AB
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1220D4000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:12:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eyuGv3tO;
	spf=pass (imf11.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762506727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfu6hWVOdhakKToS/FAXRGWAJMpHX+j6Qi6pqG2zebo=;
	b=EaQhqTI83an8yTzHlqexl4VUMeBvLBnacPv9LuxQqjbr+wu3Bf9ea7HTR+/mRpDduDhFZd
	6mDxNow5CwdkRAWhsGeBUr9afXV7oLcH0J/6NlVhKHgwuDeC0mbbH3+IMIE0nTgpAntEAB
	AQnETqvVD7zHS9tYuU+LsH5k/E9rb1g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eyuGv3tO;
	spf=pass (imf11.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762506727; a=rsa-sha256;
	cv=none;
	b=04woG4inyAP9BglhcEDLVOHfxgFh1nSuHUMTDOd5zwDnTX0a4X5hwiKorvWdKovToCQUuQ
	LyrRQgTCFXN221jqZk13vR9LQrjBIcTULRQmVrRT0srWrYom/r/32SDBnC8U71Cb8lB/4f
	SUnltZVYXF5uU+gFMeGrnSCh73mOXQc=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee130237a8so301017f8f.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 01:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762506725; x=1763111525; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vfu6hWVOdhakKToS/FAXRGWAJMpHX+j6Qi6pqG2zebo=;
        b=eyuGv3tOx32qRdGYoFmTCeKqUcIHSp71F3UE6PKSnxll4e6J6F7C+9kUd18wLRvp7d
         iT4n9u7alZ7GDOWzmIjEdrzyJmCVjxZ65dWpbiEIxE68xOQaIgD+fcAAHqbROhiZKHIv
         eKdD40ehnqYnLjwhRH/c2UfDQslZWWTUjyvQc4qWvE6HcUW3b89R0TPYaGz1P6d0/laO
         PVZtQnJEbMJ2HwwYyeEQd5cEp/GKwfHMtlS7jp9Mc/0Yl6rCmPQGWikSLlSyJUVgjCsg
         dz5Mio3r4y/wf77v1HQOR9wzWndWLRD5axWZsq9xR+S/OiPXyCYASuf8RdgkNhGqaiji
         DRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762506725; x=1763111525;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vfu6hWVOdhakKToS/FAXRGWAJMpHX+j6Qi6pqG2zebo=;
        b=UOoMdd+zCGAjMLBNrqe0Rdd92ujijFM9bl46gu+3zaeHmC+8swYydAF3ynJYuJ4Sey
         G8RQ7OxP5KDzHOrN5VKJTaPE0Ei/lc1cfAeQ/49+FuqnTQo3IZlWBFNYU9hvRM4jj6Iu
         kokr9EAT1+xHAXBES+VPk7WmryBdsF91rikIirGhLspRGA1J+l4tNmV/9qAUH65N47ZU
         Nld1QvPeWa2qZcCRF/vh6BPmQuSPW/8dAwpvMp6Y0UHFG/QCDwObJTazk2XBLbPicPBk
         uMhBESh5OsMHhFsKzpLhWVaYfAHExfVQc1WPU1zHhBj8Ynif6a+E+NZlKRf4RFgdOvrn
         Sw3w==
X-Forwarded-Encrypted: i=1; AJvYcCWZQyPHOzl8jfymRpsa6uyh6deKYqs2UeirHB3C/E1M9VA0bvf40gHRH68LFpQIoIN8M/xcAuPncw==@kvack.org
X-Gm-Message-State: AOJu0YyOfLa5PbuVNIefvVME22+5X/D7/MM9BUUZ8jrfQ5XPQL4601W6
	lH2nXfW/zqKDrCnQ7iPaiTmKzEj6rdTr+/cG8lon6l2evsWJOoMc0U8/
X-Gm-Gg: ASbGncv04ekdGelCJ0s1JwMVq+ZPZwAvf/7ikGtR34k5PrC3ytHgV7dWnpnsqsbSDbF
	s2glqZ0+thgWEXLXfYk0tWMnmM+vRU2jFIyRBmj7Zx8zbEa4Y1iboqLFEqCixIE1teeASyxCnso
	l9ldigZzUD/V4PzLJposeuHdGeP5BoiHM9o2ySC4v9nLeM+afG9FNKxqma7BG4HOX3P1J/htZJp
	KsFxQ88me/XvEBoxNTyFDOjEDPJVFoPULWg8Tgoueb5dV5BLg23FIeopwuRDPGcMuFKYnNThW7O
	evibRLBCk70tpByPf2VzKzfHbTZdgkaXjNlGxAKCTlDrP+kBncT1SspESQFmVABc3xhydnzWHut
	Txpt1s7JMr1d/EQ4xnb1wSJ7kB+N9D2de6DUrSCCsuqKStazUgLqiJFrPEYoITAKqLydqXmU3/k
	OJs0ADE/vNLEYRYCfy3liHzIu44TOmFYM3rqwyUlafMGaL2xgr6g==
X-Google-Smtp-Source: AGHT+IEEP0U5dTddGyGuUJGvkU9GrhTnDh8Aic0GqAcQP/ISEpYqab5xsiyolY/2271V8nj7hJgVHQ==
X-Received: by 2002:a05:6000:26d0:b0:3e7:6418:247b with SMTP id ffacd0b85a97d-42ae58b2cc0mr1921056f8f.10.1762506724699;
        Fri, 07 Nov 2025 01:12:04 -0800 (PST)
Received: from [192.168.3.141] (p4ff1feb5.dip0.t-ipconnect.de. [79.241.254.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675c9fdsm4089150f8f.28.2025.11.07.01.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Nov 2025 01:12:04 -0800 (PST)
Message-ID: <0e616478-96d4-41e9-b6c1-fa641c36fba3@gmail.com>
Date: Fri, 7 Nov 2025 10:12:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
To: "Garg, Shivank" <shivankg@amd.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, zokeefe@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
 <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
 <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
 <43a8c8a6-388b-4c73-9a62-ee57dfb9ba5a@lucifer.local>
 <77a54f63-f5da-42a2-b24d-5c8a0f41d1e6@gmail.com>
 <0b84865c-5b23-4be6-9902-af9d5e63c182@amd.com>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <0b84865c-5b23-4be6-9902-af9d5e63c182@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1220D4000E
X-Stat-Signature: kkqsr8z8aa8z9ceb1gqk434tezssrj4b
X-Rspam-User: 
X-HE-Tag: 1762506726-17629
X-HE-Meta: U2FsdGVkX185x7qRw27nJzGBjFhICavPTacVNnR06oVMq6YlGtvGvToI8r6KQzhbquYj3YgLBuW8hUw1ab7qZejUx8Mo4LCq+PN142yx8i/KdMpxStKcRwt5dMvW/iYfaLcMXQ32GgeHfzjY0x/iYdQV6NzkAznSyUP/0588a+S0ddxbT7jjm2wXzosPRjwGpdAIwzINn+QcuNetavhHlgYZ3UZs7wXiMRrI16qSOnDjXe33Lv9tzPvEOqT/CocVRDcDFqHwGBgcdUUU5otLrpMfpaSI542EKrnOjR4NhAshD4wrdO1GgCA6jFdxUclUPER3/a9A8i9mUk0+Is1qHNv8+XQB/Om+lxjroEAOfzAnH6wcvXlJwLlPUm2DaccJfwnVc7ij9K+qnf15JrcZoHWXZ4cGwO9bOBdRbNsWTyNuQZpcDUG0nqZlSs4/g3iN12fvL3gCaYoUHA14heNGNKmRs85zDn8H6vRq7rPwylrIS2GtadiGg9tI3aw8A6z4gfRPCIqYwbEdKWDznxHBl0St9kHZMqZs0xrSUQHB6duW8W5jL9tQFC4DAUo+YRH7kutneGCJVasLeoGDOUyfg9RadsIjI5HtWtji2GQgrdZMBj36Yh1ThEK5GmbuSKF9FL9TD9YKvg+J57RhhpEGY6fYPQ4bOP9xe5aTHZ6F6Tc6zin3P+y2zAuZ7D79tp+7gYiWKFEaTPG5qO8aW5olPb16WZEONfT3mNJkAy03NTYvVh8FWDKVbEWSM3H5qTytXdQDAj/wsVYzNj/X5tW51igyThXAPjfV4TS6a/dTetrzrWBEPxBCoPIX3gylUk711/1KVPDU1tbZhGDU7VtiSB3glESS+woMWWCBfVXszyYjc45W+3S+tId+sk44TUuBxVRRPSHEN34L3hWHWSII7BFy7T3XkkfzB5/5R1/YG/u6fz4L3Utva0yluLE2uExs8v62a1A70tyAM+YqbvK
 jRTzUCgi
 IosPHc1NUqttK6lNOJu/g/v1U/9DNuXJR927EY67Wrm4e59L82QYuy4/+6ROGczqeUtS9M3EOOrWqnf87X4spejZ0hMgguLWNr6BDOmhuoj0EmhFQXhktxoy+PBbsGBnljjqQPgDolGKB+sqcDN1v38OsQTq92KqY7PHshxfCTdZFjP0hqWYk6msOuB18AHf0OgemBofn8MhiBer9Ce4ONbwht105wQQoEIS5CK+X92XGE3SEiGfcaWpvz4sjbGF8u4XCZcQw1kPAQd3mESOW2zpq8Im8CSTh+eI3JMzQl6N+JfJfccRylUI9OuvubL7lgIM4fnjyqqHZIwaOd2S77x9N+O+Y1QpsQWdHMvrqIs+CQMdykqFfwJCIELWWu8oVSjjfVmInno0PA6VHiQZAt1vJVMLKxOT65itjkK9qNIaj8kH8IO7luLqoDQ/9R1eF5XYYxbEcFmz4twVOQF8p3hVKhwjceawWLEAluMgE8iimTlFbC0qomzlOQBU1UBQ5CyQI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> 5. Yes, I'm calling madvise(MADV_COLLAPSE) on the text portion of the executable, using the address
>     range obtained from /proc/self/maps. IIUC, this should benefit applications by reducing ITLB pressure.
> 
> I agree with the suggestions to either Return EAGAIN instead of EINVAL or At minimum, document the
> EINVAL return for dirty pages. I'm happy to work on a patch.

Of course, we could detect that we are in MADV_COLLAPSE and simply writeback ourselves. After all,
user space asked for a collapse, and it's not khugepaged that will simple revisit it later.

I did something similar in

commit ab73b29efd36f8916c6cc9954e912c4723c9a1b0
Author: David Hildenbrand <david@redhat.com>
Date:   Fri May 16 14:39:46 2025 +0200

     s390/uv: Improve splitting of large folios that cannot be split while dirty
     
     Currently, starting a PV VM on an iomap-based filesystem with large
     folio support, such as XFS, will not work. We'll be stuck in
     unpack_one()->gmap_make_secure(), because we can't seem to make progress
     splitting the large folio.

Where I effectively use filemap_write_and_wait_range().

It could be used early to writeback the whole range to collapse once, possibly.

