Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02045CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58EDC8E000A; Tue, 16 Sep 2025 18:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F5C8E0001; Tue, 16 Sep 2025 18:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DF18E000A; Tue, 16 Sep 2025 18:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3658E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:02:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D86DCC032C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:02:35 +0000 (UTC)
X-FDA: 83896488270.01.A1D646B
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id DD3568000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:02:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y2KbupYl;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758060154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQ8K4gFLQK8N3VAF0ow1iMWGtXpNTgEuNC+GqpxwwNg=;
	b=33AroLxbNDyP1w9htNJ+4JaZ1nDWDmV16e7CHLn8Kz5aAY8JWLiRgtQHE+C+Y8aynPFoxN
	GwZlXIXYEHXuWN7hlEgfT7C5kN2q4++fzcoGreX381tS4ZhZgowPqEUwafe+x96qO7mojS
	eZKkm0NXIfoqKE4vx1UuepaiYJ1Y4fM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y2KbupYl;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758060154; a=rsa-sha256;
	cv=none;
	b=ueuAoxpuOr4mWembTwAVsh5JCrYuFoeLPUL4JdEiDRvnZc1YrlLMTjgDCvL1ozbTe9CUIB
	XJMLD9+OI9jIuUX0ZEzk0bpbid5gnjp/dUe/paO1695H2MF2B1OrrClGEaYrztvUy78b27
	qc4bEHmxIwN3XBiSrDFMSMTr2+ISHP0=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-81076e81aabso497240185a.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1758060153; x=1758664953; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQ8K4gFLQK8N3VAF0ow1iMWGtXpNTgEuNC+GqpxwwNg=;
        b=Y2KbupYlrIRXESfHDFMZ4DrBYKReor3XnEwFJ2Iu9flCDbIASNKrXr7krPSzJaq/5P
         hHdfvZoWE36e9rrUSSOhnf+C3lfmFMDKQrJ6ajFLAXMXk7+/USlVTQWb2cp3hAcefzNa
         i4T5oEeC1YKgvE3IDby6J3M/T1mMf23Xq3I7nA12CnXD2/JrPVAufBt2M6Nt/zO0ZLAh
         o0OTrsQ+88VywcUuwIa9jAg5ooUay6zbCEeYuTRS6w2zttkVABMensdu36tUlvpvaWZF
         84c/RTbqNtEZAywJV3IsMDb2Xjt1P50cA7nQIzj3E+WdqYpUidNUq5L5p0mCH/UpEirT
         ycTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758060153; x=1758664953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQ8K4gFLQK8N3VAF0ow1iMWGtXpNTgEuNC+GqpxwwNg=;
        b=GfslwV5oKMEoi8bdVUhpxdeoIb+RS9Y1gw7QhIrOAIqLx9YRz2oSUqdFYENtAIFpp3
         hve9kPV58s5ogxazBXOQi//eKKUrcyOqXq4HXHo1NsrfOEtlnNTzplPT9VBwlSIsBt1u
         WkEEgA1hDxOtzG/iAhZ2ViWbQEfbVGO81AsLShblXfW2zcfwq7qfHsd3j3YwADKIVwuu
         KxQQ/PdPbFkhAeWHiFg2xgXxKqfBwr04WP75zp2B5KZ0GlnN7hzNkWgEkqBzpNuYZz1O
         Vtg77jlc2elhqe4wV0fkd0Uj4toBDTbfjDJwUI0mnmDN/sRWVWiDSdq7O/dqRV6SmlYM
         M36w==
X-Forwarded-Encrypted: i=1; AJvYcCVryuVkw34ZrzdPNAighjTsYgaoMk38niituVqtfJlng38MohRUd9OI3934UIrO2OQfJRZx++BeLQ==@kvack.org
X-Gm-Message-State: AOJu0YxDEfQKI8bI3GRWCkYAIGzVCS/Au5S+3ufg1UsB6gNvj+fZZQof
	Tp1LKRde+9VQTw4+qWiV/8QYMtK3XBtt22JCCj6bhwe0vUFydeJEZHavFeoCB9pwxIo=
X-Gm-Gg: ASbGncvlN9UnTB3gCny/GXWh8J5gTyLCIsp8PKkvxKizCMYDtLQmh8m3zYS839ZAuzM
	MRMa0yyY8aDktyRNiR2yfjwvtK4Hqph0uDJExpvVtwYDIjckF/FRTyX3XR2TV5EQy+CuvQrle8g
	vwpWg6qx94djEBRPSXdnejDzPZuTPLK70ZCYWj8ToSgBiLsF98df7Q9f0N11nE0tlue4ISIpV6l
	qayvP+V0qcXMXL+efBm5a2dqN00+T4OL6Ou0YRj4nD7nmiA+Xj59Ovaw+ts25sdSNqbvgFGKnJ9
	I9a+xjw2gOXI6Lqof1qMC2ibbZw97MK60TjJdqAk867nd0ZHQsm2IkqkGmjEgXM/OuJzkQCka4O
	GO7BGoiDxzlRG5j36ujo/Oc1IIndmRv3cnWi7UZkNR5Sw1xEXUhB1RdHhqvgumpMBCd7bGTS7GZ
	IHhTw=
X-Google-Smtp-Source: AGHT+IHE7xHsOsLEaNHRsG77KnmSH05/ThEIDM5eGgWVC4AoyZnlllTOGd/v1EC79Ig1+Af+801yew==
X-Received: by 2002:a05:620a:7013:b0:827:fa83:ec0b with SMTP id af79cd13be357-827fa83eddbmr1358277085a.52.1758060152617;
        Tue, 16 Sep 2025 15:02:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-42.washdc.ftas.verizon.net. [96.255.20.42])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820c8ac45a3sm1040371885a.5.2025.09.16.15.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 15:02:32 -0700 (PDT)
Date: Tue, 16 Sep 2025 18:02:29 -0400
From: Gregory Price <gourry@gourry.net>
To: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Bharata B Rao <bharata@amd.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	sj@kernel.org, weixugc@google.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aMnedTTmmpuvDxzt@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
X-Rspamd-Queue-Id: DD3568000D
X-Stat-Signature: iw9c6ryefh53uagz1xcnb1k3orxk8myi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758060153-943387
X-HE-Meta: U2FsdGVkX1/9Dp9tE9xGU4tQsbhBmY84Foqm/YBJio516yJXosgboad3e9rFL362vSEtH42JuCkfQOXmhiNB4YZWpRLi0MSb4rcHGl6yPUgPUCoN9Ed/WgTRfCNAUbViIV1d3kCQBjlU9mYs0MSUwkRer9Y5379JHMO86ii2/dEDT3mtVjII+4JJfudJDNIFk7LxcAnIOYDqlqhb7oigsieOsUoCC3TS3AOn4NTrVOdhnrTDb4PNxFp+W00I+pHDap86Zk9T2Dqrp54ks1ISCS6EwppdHgr6P39ul52MCoHurgRr4S8n8ZdjDYRhF1D1uSnUsmmK3AqK8SMVKM8xgaqfq1ZNpRdFEpNT53OgyAFJONygUXWBMKvH3IYqQy4V+9brv5rcYkHnFFEe19YqYZ4T+lnrnDkXSrfmSoSE7wzZWE/d0ePkNSxfiZKfLsQ38SMHZm5nB3O1p7YxgbCh8zeRB7Z4HteqXDwp2M3m+xtsaMNT7wHfE40Kcki3vyybH1YIu2chjfw3R3oRd1EklRtPKc/wfsSaherFoW3vOGS1rnPqvO7FnJCv3JZljJiL5zGMU78MvFlpPVVdpgv1Kf8quuFDy9p3XIxkUndEOLfuum8lX+RvPyCqcNz/LBa/3MHI8qRT1BirZm1MIK8G5eTtgymwqUFyrckWyg1GT/EmuRUhtsbLG0CmUI7jLIQWyqHp7COmwskSy6hbZ7R0XuuhubD7WKlcY2pfgv7Py1rumMpkcWYn6kXiy/wqUxq3W6U5sYqUdPnVdHLfDDruRlsuA15X3x8OV4gOruNKtGgFPOzuUhzDvFLONoc7uJIC/vnorikpTI6RqJUnPPBLgl8m1l05kI2LIpGudHUTAD8IFzZ95WTuVjVMcJw2zqDauamwtThag3jV5wfLhjvidRzna9Ifb3HcYWZjIoSgGxcuyzKF/TEYgf47Mpj79lPOi8OAoLN8dVQhKRMA++x
 1RCSEr4o
 jA7kvPD4H9VVql6sJPg4dQlq4vHJVsg+UgDVKx9ol3KAflw6OFM9O/cr38oYttfAdbq2L4eo+bJUG8L7DIdWdlz34q3ZygtRQ8hjMx1rh7a18H6lQrvMYpBZcEiXltJPApY4OBuCqyncNLZRDfAmMMM/vyqZyTKPoJq/vZNfkg+FQ53B/7817Yh9Fqk8M1z/9roJ31mymmtGGBcdr7YDTp3TFLetWOeq2ycGYMCUcXHt+2Z9/Xwv04803gbCEAi+rcobiNZdQHk3E8zDk9n5kOp3M4x+tbW5Vtuid0W8Xi/+TaZo3MQ+8ceuvnpZPKeRtXTC2bbbtLFzcySKVFipv30ljfWsvR6COtkvUrwz6iDyGC7vMA5EFNLAxs0mNdz3iTTmtRCoHCrUpU1QonbDWkslLkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 12:45:52PM -0700, David Rientjes wrote:
> > I'm hoping to share some of this data in the coming months.
> > 
> > I've yet to see any strong indication that a complex hotness/movement
> > system is warranted (yet) - but that may simply be because we have
> > local cards with no switching involved. So far LRU-based promotion and
> > demotion has been sufficient.
> > 
...
> 
> I've been pretty focused on the promotion story here rather than demotion 
> because of how responsive it needs to be.  Harvesting the page table 
> accessed bits or waiting on a sliding window through NUMA Balancing (even 
> NUMAB=2) is not as responsive as needed for very fast promotion to top 
> tier memory, hence things like the CHMU (or PEBS or IBS etc).
> 

I feel the need to throw out there that we need to set some kind of
baseline for comparison that isn't simply comparing new hotness tracking
stuff against "Doing Nothing".

For example, if we assume MGLRU is the default, we probably want to
compare against some kind of simplistic system that is essentially:

if tier0 has bandwidth room, and
	if tier1 is bandwidth pressured, then
		promote a chunk from tier1 youngest generation LRU
		("hottest") and demote a chunk from tier0 older LRU
		("coldest") [if there's no space available].

Active bandwidth utilization numbers are still a little hard to come
by, but a system like above could be implemented largely in userland
with a few tweaks to reclaim.

~Gregory

