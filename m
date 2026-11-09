Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D305606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bhqNNQOV
Received: by kanga.kvack.org (Postfix)
	id 655D06B05B7; Mon,  9 Nov 2026 04:51:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D576B05C0; Mon,  9 Nov 2026 04:51:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51EAE6B05C1; Mon,  9 Nov 2026 04:51:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 298326B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:51:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C66D1C05FC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:51:39 +0000 (UTC)
X-FDA: 85415113518.09.7BC208F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 06738140003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:51:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bhqNNQOV;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794217898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Evsm93Jf7an7afCmpYNcizJpvuoFJEVrWxhvJjq1VG0=;
	b=02gGT03C/3L4ko9g4FMxQRzUzebQxjwW9Jovl2aGtiXkNFBrKSZgF+YXWS3GGvcZI5tnlX
	vGPM8t5QYIGRjOvdlpNdhDdPecKSGidGq79hSSmEkZQ2ry5bTtSohhAxyExy76V6eaCQlI
	shJAhZBjK4iST+Tv5xtE7c6lwzWK4EA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794217898;
	b=oYDS37KNzUGX9t3GIv0czSBHKBamDxeqX32XJTDSwxlmNN+5tI3xq15Du9x/sC837UmycT
	39AMYKZI/FkySc2THsThpiBmrqSY90QqXcVgqf+a05UEcZLArcMFDUXA0dqoJiZ0J7EFIP
	KB9ngpLqJ5V0uJh7uPwGZkE2eXO8JFg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bhqNNQOV;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20B1340790;
	Mon,  9 Nov 2026 09:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398411F0089F;
	Mon,  9 Nov 2026 09:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217897;
	bh=Evsm93Jf7an7afCmpYNcizJpvuoFJEVrWxhvJjq1VG0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bhqNNQOV9B10W1Kf+7AkY4klAiBwSyMS64uCIN5C2ry9FaHossio85/T+jcSxZFth
	 zbBBi0sFWCFeSqS8KvSvajPokW1ehMJQfPzYOOyGXxzRPbsXl8EjF2/8ONP7xUM+XW
	 sYwl2qRVwZseaif7xlBE9tCwEt6iL279YjBiJREbwO8R/mPiUOak4T7h/DbViQTQZg
	 hXPJaTP8JI+Wj4hIFzuQ6JmkvfH1TEn65uzoxqrA6mEtLh5yvVX/D/he1p2v1Ocgin
	 1AMXAeTnbw0i2zeG1M5YIXiTSUZdO4ESqh5MnIOOwJVmtGYcCZA38e8rLX9i1b48Ub
	 rOqb9dsZR9vMw==
Message-ID: <db93735f-2452-453f-bfe2-f1cef00f143a@kernel.org>
Date: Mon, 9 Nov 2026 10:51:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/47] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
To: "Garg, Shivank" <shivankg@amd.com>,
 "pratyush@kernel.org" <pratyush@kernel.org>,
 "osalvador@suse.de" <osalvador@suse.de>, "xu.xin@linux.dev"
 <xu.xin@linux.dev>, "peterx@redhat.com" <peterx@redhat.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "mhocko@suse.com" <mhocko@suse.com>,
 "usama.arif@linux.dev" <usama.arif@linux.dev>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "jack@suse.cz" <jack@suse.cz>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "weixugc@google.com" <weixugc@google.com>, "kees@kernel.org"
 <kees@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
 "jannh@google.com" <jannh@google.com>, "chrisl@kernel.org"
 <chrisl@kernel.org>, "liam@infradead.org" <liam@infradead.org>,
 "yuanchu@google.com" <yuanchu@google.com>,
 "youngjun.park@lge.com" <youngjun.park@lge.com>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rppt@kernel.org" <rppt@kernel.org>,
 "axelrasmussen@google.com" <axelrasmussen@google.com>,
 "nphamcs@gmail.com" <nphamcs@gmail.com>,
 "gourry@gourry.net" <gourry@gourry.net>,
 "willy@infradead.org" <willy@infradead.org>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "surenb@google.com" <surenb@google.com>,
 "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "will@kernel.org" <will@kernel.org>,
 "hughd@google.com" <hughd@google.com>,
 "nico.pache@linux.dev" <nico.pache@linux.dev>,
 "npiggin@gmail.com" <npiggin@gmail.com>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "harry@kernel.org" <harry@kernel.org>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "apopple@nvidia.com" <apopple@nvidia.com>, "ziy@nvidia.com"
 <ziy@nvidia.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>, "ljs@kernel.org"
 <ljs@kernel.org>, "shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>,
 "mhocko@kernel.org" <mhocko@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
 "kas@kernel.org" <kas@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "usama.anjum@arm.com" <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-9-d6437171ecc3@kernel.org>
 <50c50262c50da19f6a2b27f848324772b0e3c707.camel@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <50c50262c50da19f6a2b27f848324772b0e3c707.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1uxqz5bddny6e7mw7jok1ex1fiusd1z7
X-Rspamd-Queue-Id: 06738140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794217897-134413
X-HE-Meta: U2FsdGVkX18/2mMoVSsQbpxwTXw4OzJY0duGvta0Ln2iWhssYiglHRLWrjYrpXAQ8/uQ9WGiGjPmfpoQZjGldsdOXbsPJCYtklus0xQTJaxT4axur9CG3mRuxWotwGswL6QQoPVSpZ2alMQcjDc/LYo3CRvw5vQcLK/ea+H4ueegqT3jvpQN7OvsjOc3yj6hor9MQoySG67DUI5rUXmdn9WMj25pznKXR/pRL1sv5QKbhV1rA+CVZk6V8snf08cBXteiy8BVSo0ZsHN57iElbZ6W+HdicyL70DZCvHwvHQSk1Lx/4wxF1NUgtU9KdXUSTLOZRdxReOxShQaYW5lliT6aqsNbTg4Ou51LAJHYsgXqSipay19daaIcFKAAc9wwgnOA0ZmCf0tAcDS/PMEjYLwWcQu5oBe1WtxXRX6Tobccoctvc7nP1lxs4XFzTo83Pwu0Mi1zCzyD0a8OkiDVK9h8kmITVRay0KYHIUfqrYRtK0QeKnY0Qr4ONIbtu8vvYKzbGdTjVKuX9HjyPYf3M++4ZMEUhMGj0QhK40NTgbdB/VaS3PaQQtguJme4O/thMjeeH9q1UDr4wdTtXlYAZu52GTHEtBZ34nsNz+WHVpHS+F4qa84atxDJ75W6f0VB1Dog8/7m74hinyzMiAVIvB1KMBf5rUCKYpl5CKAF7GUaLr2wp5bBBXJsLc5Ytnq1FYB6CkJQ/1RpRqxU0sUUwZ3viXgGaQO5TUDUj7thgFzQ/RckSf1jkuFya/8u3u8FF0E4lvM5QfqQFyoOL3uI7KNCX3LYwgrElYD9ksLhwAFn0KYQqKRFA3TTIy5MqeZ8OBzDH7J/NFl4aMbKLRS2cuQT5jjyXVNvWXFNjgMFN/x8S4ZepmVu3tV96h+mGMWaml62ceY8yUxcMZjkEKumzBe3l2798WX+gW2c1SE4oFYyiaxZWFrUmFMX4AUDuRe2VosZ+rWHjp+4hVBoH88
 Mjw0G6Kj
 49T5iE21jWVHN4vFjF3oeNZiNGiVi5Iz440eH/UbMu+UAfQsLnmkF4L4H0YR2yb06+2hdeGoIAXefqPNWY/iRyvVEvBdRikcEr9wlJuSASy3mXgcjfXa03IjwbjZ/88BJnuv7RWSfZXWwRlr/rTyuLBLbr1C8eT6mcAK+V0MVtndPiWfSm9atnLn364uRETNpA6OrGiXm6ukcCSpBOGWkFhEWXdj6axYtE4WOk7uox1baIh+F7UJD61RFsNtVFX1CvURoSV7B9WpLQ+FHfNTvvj4XnTnZKFL+RuqQkDkX61fZIZRycIi66blDnWzMmWl8z9t+KdqfcgggMhj/ZPof5olUANS21iloAou/+lDgQ9M41Rpjcij1DlXF5QteLmQKUV68mOE/HPP8bwfFw+Luj3HkmYBOKbPG2ciRTmNUeWw6Dfu2KPY4SwF5zTEnfCVsaNAO1PS9c9OzpwP8CxprWYQ8IFJKCMJvXXzCpSnLzfDI5wXmG1kElBSHCL2ncRBUFh2r9rK8mFxC75WvaoyMPR97YYUiG6EG4dzvPcuXIRw10PD8Th9iORACgqc99316FzpXp1mLHKy3AOkH6qi19eTYzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 06:22, Garg, Shivank wrote:
> On Sat, 2026-10-31 at 10:39 +0100, David Hildenbrand (Arm) wrote:
>> page_vma_mapped_walk() can return non-present device-exclusive entries,
>> but folio_referenced_one() passes them to PTE young-bit accessors that
>> require present PTEs.
>>
>> We must neither call clear_flush_young_ptes_notify() nor
>> folio_pte_batch() with non-present entries. For example, clearing the
>> young bit on non-present PTEs can corrupt the entry: on arm64
>> PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
>> entry into an ordinary swap entry.
>>
>> folio_pte_batch() will VM_WARN_ON_FOLIO.
>>
>> Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
>> treat these entries as old from the CPU's perspective and obtain their
>> young state through the MMU notifier.
>>
>> Skip PTE batching and MGLRU look-around for non-present entries, and
>> don't modify non-present PTEs.
>>
>> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Cc: stable@vger.kernel.org
>> Reported-by: Josef Bacik <josef@toxicpanda.com>
>> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/rmap.c | 23 +++++++++++++++++++----
>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 1131b76bbbc28..0faef46806e5c 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -924,6 +924,7 @@ static bool folio_referenced_one(struct folio *folio,
>>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>>  	int ptes = 0, referenced = 0;
>>  	unsigned int nr;
>> +	pte_t pteval;
>>  
>>  	while (page_vma_mapped_walk(&pvmw)) {
>>  		address = pvmw.address;
>> @@ -968,10 +969,12 @@ static bool folio_referenced_one(struct folio *folio,
>>  			return false;
>>  		}
>>  
>> -		if (pvmw.pte && folio_test_large(folio)) {
>> +		if (pvmw.pte)
>> +			pteval = ptep_get(pvmw.pte);
>> +
>> +		if (pvmw.pte && pte_present(pteval) && folio_test_large(folio)) {
>>  			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>>  			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
>> -			pte_t pteval = ptep_get(pvmw.pte);
>>  
>>  			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
>>  		}
>> @@ -981,11 +984,23 @@ static bool folio_referenced_one(struct folio *folio,
>>  		 * are. —they could be on active/inactive lists or on MGLRU. So the
>>  		 * simplest approach is to disable this look-around optimization.
>>  		 */
>> -		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
>> +		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
>> +		    pte_present(pteval)) {
>>  			if (lru_gen_look_around(&pvmw, nr))
>>  				referenced++;
>>  		} else if (pvmw.pte) {
>> -			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
> 
> This was the only caller of clear_flush_young_ptes_notify(), so this
> leaves both definitions in mm/internal.h unused.
> 
> Would you prefer to remove them, or keep them for company with their
> still used test_and_clear_young_ptes_notify friend?

Can you send a cleanup? Thanks!

-- 
Cheers,

David

