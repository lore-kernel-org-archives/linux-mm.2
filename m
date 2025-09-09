Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FF6CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32048E000F; Tue,  9 Sep 2025 03:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2498E0001; Tue,  9 Sep 2025 03:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA508E000F; Tue,  9 Sep 2025 03:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4BC68E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:57:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 258A08624D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:57:45 +0000 (UTC)
X-FDA: 83868957690.19.F5B26EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id C51AFA0009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:57:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hT7TmcJF;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757404662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nz/Nnga3bgBDy+B5bmnzvxd8xQwqo970wjUWVvIv2CI=;
	b=WzA/6O6wpS9EiwEKjAI9VI3CONmiqn3Ww64N79+DTb5NXDsoGPMt6aXsBlDRZDYm8zCss2
	7E+mlakarj/BX9doLr6wtJmgbm6X7oqniPyZvdYQLCFBymFOSAc8es9bz80Hl1Wyp3PsVT
	CsK+HjGHv0iLLcpbvrtz4ahD4+VdYiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757404662; a=rsa-sha256;
	cv=none;
	b=QJGiNcDD6FNVSVVdZf07MAfKKm8rAsqFpVdc4DLgnPrA6sWMBrBDVEgU5pn7uhgtrDiC8T
	wXXLzkv2P+eZ5t0uWTTpqnCPNw+TwIm1wMCzFskUBhpYIBEsmde0vRlTXg66Aqm+h4J7xr
	bWLJifPC93X8nmvT+rh6XSv4uovQR+4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hT7TmcJF;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757404662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nz/Nnga3bgBDy+B5bmnzvxd8xQwqo970wjUWVvIv2CI=;
	b=hT7TmcJFMXp+XgJ6mFensUr5rn7Hcls+ihDE6W+zJfJBmPBPhjwRsKOlllbetKiP5n6jeK
	JfPXYlV+9QNnjPonW3SWvJguTymtiVPsZs6P4RGLOaAUc+DxqGY8OXVc69E9I85lSkFNWn
	X+eB8DFZfMPmKuKV2omH39KYKJ5SB3Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-AGSEToLoPVOHF0JdeFH2mw-1; Tue, 09 Sep 2025 03:57:38 -0400
X-MC-Unique: AGSEToLoPVOHF0JdeFH2mw-1
X-Mimecast-MFC-AGG-ID: AGSEToLoPVOHF0JdeFH2mw_1757404658
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45decfa5b26so3288545e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 00:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757404657; x=1758009457;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nz/Nnga3bgBDy+B5bmnzvxd8xQwqo970wjUWVvIv2CI=;
        b=ckmsjSWhHRWw/no3xU5JPxBGe2RDrNrRYr6oF50O8K4l/1D7yiEsqPxxutFTjYOPBx
         /nDFNwEGvsVH/p7WaQU2YTLXdnqP96Fu3mREMBRI4UwTjfbNSFkDcDJSDqMrqIvS5OIC
         zABZttdsDfjXR3PaupjJ722ER77+5NKofr8bCocBJqP4Fofy0vH9NsVS/RSzJY+xzk46
         bFVjNe0BXA8rGvvLUZXtMuj+7EEujcFTMG2IwDzEtSCe0UWHYrtS5zHKEEC5lzWOZGkl
         NPGX8lYcrmnfIADY/RZ93SnFt9l+h2CfcCt20E90jyhl02Yga86BQ8HaZUsV//yCxcQq
         /2kA==
X-Forwarded-Encrypted: i=1; AJvYcCWSuCMWi5g1osYxepbFF5guaXoUP8mw1Xg6VOFUVYRflLvzTHLV04hS9FdbgRUwjMrLMTJFZJttGA==@kvack.org
X-Gm-Message-State: AOJu0Yz0xzYvGxJ5o789CX1E2q2xuQZc+TPuYW3CVVl1dpKhuwmBDyKi
	R4MLdGNza1pXLl6JYNKvhiFzxVmXIfS3pvE84vsSIEvb/xOj+LPU9jQWi+biNEyI7bS3CK2psPn
	Cx60sq6MSuJvAQVLsD1Zn/q10i4+IYH0ZaO4gQp+K+XpNY8iARJhJ
X-Gm-Gg: ASbGncuiiJOHi1ug7YmX+lHlPuyJv6QSmZVfpl+p0MOuBih7jwbMuSEmRimJJwu4/lI
	D6M0QfqjVXhXOZxzrfDJjZAwpuV1wW0gQe2q/sBEv5Ju1NQZHgSR2qdl93bJIR4RvMahvukh7pJ
	aLbfBJNHzq9vk68ZWGrOrBYpsBzF6GHpAGS8I0EHcVx4SV5cNbYd/1AU45JrgG+cM0ctkEqZR1s
	gjCMbPOye3bnP3nzfT6xvT1TEWqEybDzl/+fWQARs7Wv4bDReaz1QFhhupzqcFsfHECdZp7/pch
	DbO67iC234Ktzuy220+8/mUbvF3XpQvV62pS5lF/cZMb3YMLk5H/weNkl9GoanG+1ThGaRTH7oJ
	iFnEKsnZ/SlArrtbHbKC5wJpjDgfYE9BdIGAMK6Xks5xEQ9ysXtSDqFky/4jrch2a70g=
X-Received: by 2002:a05:600c:3505:b0:45d:d88d:9ed9 with SMTP id 5b1f17b1804b1-45dddee3abemr86694965e9.34.1757404657636;
        Tue, 09 Sep 2025 00:57:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEy8IpTKompJEw5Cp+BpGsqDaOuHZDLRhJVkeyf3lzVmd5Slf6SPOjM0LhmYZFhOowVPnP1/Q==
X-Received: by 2002:a05:600c:3505:b0:45d:d88d:9ed9 with SMTP id 5b1f17b1804b1-45dddee3abemr86694645e9.34.1757404657170;
        Tue, 09 Sep 2025 00:57:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238760sm1503339f8f.34.2025.09.09.00.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 00:57:36 -0700 (PDT)
Message-ID: <789863b8-dff2-4fe7-b708-7b0c65c7b843@redhat.com>
Date: Tue, 9 Sep 2025 09:57:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm: folio_may_be_lru_cached() unless
 folio_test_large()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Krabler <Alexander.Krabler@kuka.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Frederick Mayle <fmayle@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>,
 Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>,
 Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>,
 Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
 <57d2eaf8-3607-f318-e0c5-be02dce61ad0@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <57d2eaf8-3607-f318-e0c5-be02dce61ad0@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JfKYB8dIw1xAE85JzI-m70-bKaH_gT6fB5td57zHd5c_1757404658
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8tzxgfqecq7xkptpzg7zp167fnei7hpu
X-Rspamd-Queue-Id: C51AFA0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757404662-931769
X-HE-Meta: U2FsdGVkX19Vi26vTPqZaw7Kdqt8nIOzG01wkiC9MqtsEV3Sz5wC7G96PunSUpSXsmHBYDsso2B+MXjVEXC+I67Jyc9mfGyWeio7FAmAyeud/LJ1GRxqtpD9OQwDeX7t1+AzYuA8gDOuEqyl0Zp7gD1rNsddgqvuPDY/y6zbehXdvtLeY9Woz4FDD7K0YCaG1R21KLDjhlfSXTYv/CYJXjTgbLCLTzVeF2tCRBn9ukpYwCcCC1dfkP4KN1yt3hS9TjDu+ugRBxyW4IJqxstLumJEoLUadcD3AbtH+VUqtWms4tEGTsyL3VE9D+ynvDARpKptpw6/Kdlvi5XmObYr5IzgnNIQS8J6+w80YFXRly7mMINCkPnSJlPzEHwjDoLILQ7nQTTMjFmjfORBiNe+Fed6Q/Ulg4HVs2cwmYu8lhpHSpNsFRhuKw6CbRX54EnJQmQI8v2O6NmWkAc8Y5WSvQ4SrVAYlu0q/VN8r1uxrinMzLLnvaZCoS2jEBJdvzFyJvQLtDD/7QwDb6AlaYySmcmC7cJwCLuBOOLshNPU7wbVSJRaam1GmCTeww9nEYneOiemIBIigtfEU+jNN4wt0SGzsLa07jzsj1IBy2uKtykf0dKgxARixVT724WDW+JWgYijtwwk0aSaQRhDrBWfnHy3AMr2kNrXvtPYTMdTcplU0ypmOwvHuA6OguwkEhImqzc5Iv2KGF5gKVZbgCZXnXviLnCuYJH+zWPcUbELqH8E8qE1BgwYM3yqxc39O8KkUNEeBAFaHYRv4QJr6l1xhbDz+cqrPL+pe69rjOQEmurg+hjPfCw+zjAZEBqglOsTDNoxXCOrcWUdgvbcr11akMydgTovQXmbko/WYH5RjU+1seHpWCqNbhN7bAcAu7t2wEzaHgLsY6XGv+ukDTr0PG+H3RNssoOPLNipE00msva5aPSZYZczm3WT03JmUZfEnNbMgu9f0ck3Iikta5U
 OWYzOn7P
 NsM6YevMCeyaFxZIhKBI8o6HVFkpq/Ioirvt8O78IMjIscWmM5AvCY79K/lZ3VuPEqUpyH7CmrHl6SuHp+3nvL7co6Bw36K9ksXZCC41aLJhlsoYXU0fRYe2FrO4Dl8nQ80SwYR20xOEgacZXt1OEoy+tA7A1SCR+HUw88cM7xesa3i9Ss5ahURu/OqaxbbVVFbgIACWODg6tU4PKVsMZMqAJkgnsL3oPMYS1S96lKdmyM58tmr6QYTII/ncREsZuLCQgJMI4BWauUEtT6dJN4D47yPAWj1n6MB5ZEAlBDTvPDtzyVFn+Fllw2ujTkxoQdapekYoM4KBaIHzUXsrnAGV5WnOZW9LijSahUiJCry500zOISmAiM+F7kTPJoS0sHFptDRSTUaHsWY6QryAcgmFMAJoR+gQBjmaXstr7ZiqLmaiWt5hj5wARl9/XyO/R1zg4n87Ghev22OUObfWqqWg4/4hh1IlUXg7Yg633DxDhZs1vjNiu/lNxJk2E6W6rBZ/7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 00:23, Hugh Dickins wrote:
> mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as
> a large folio is added: so collect_longterm_unpinnable_folios() just
> wastes effort when calling lru_add_drain[_all]() on a large folio.
> 
> But although there is good reason not to batch up PMD-sized folios,
> we might well benefit from batching a small number of low-order mTHPs
> (though unclear how that "small number" limitation will be implemented).
> 
> So ask if folio_may_be_lru_cached() rather than !folio_test_large(), to
> insulate those particular checks from future change.  Name preferred
> to "folio_is_batchable" because large folios can well be put on a batch:
> it's just the per-CPU LRU caches, drained much later, which need care.
> 
> Marked for stable, to counter the increase in lru_add_drain_all()s
> from "mm/gup: check ref_count instead of lru before migration".
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


