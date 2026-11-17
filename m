Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D704606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DYKppUMZ
Received: by kanga.kvack.org (Postfix)
	id 5D2566B05B7; Tue, 17 Nov 2026 04:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9F66B05B8; Tue, 17 Nov 2026 04:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498BC6B05B9; Tue, 17 Nov 2026 04:29:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 287AF6B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:29:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 957C9A7E37
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:29:08 +0000 (UTC)
X-FDA: 85444087176.09.6185EC2
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id A9A6C40003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:29:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DYKppUMZ;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwh1ZuUgyzVobDFnDosRkpIc8VIXPPyqqOxv+keTtXU=;
	b=qVP/wr+xGcPamX0c56TON1Ft/oiwV0Ajd1kb2CgP0hJN7VF3qQEWJNrKJ8/9J4RmXqFj7l
	ho0ld+4zr51GMEChvgkj0fl7WYFWr1fR4IHiTJP5hQZ7yT+OkqqiAmZshN4rGhZIOUBIah
	XPPho0QlswHbHj1LzHib26B0Qwxqkuo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907746;
	b=X0E4uYQ3ninCwa41sk9P36u2GJ7tEp0ihdLbULKCZquJZR2CuylsHLoG4/M2WEDWDuoZvl
	/GHXhGR3Mp3TgtgQt1a4dzhYeq1lLIG2i6kgr4Pn7Qo1SoqjV9LOBX+nRHVhwrxPXURrMr
	AkScjv9gWRNZ/Aiuz7DcK+3oBv77Z+E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DYKppUMZ;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-55d2dcbb905so24800911cf.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794907746; x=1795512546; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pwh1ZuUgyzVobDFnDosRkpIc8VIXPPyqqOxv+keTtXU=;
        b=DYKppUMZFiNIgggxYC0DzmkJJkBF8HQVHQ9oVWYbLX9wIq56wqWoMO9HISeqT/hQo9
         Q/DLW1wdNT5mQfwRLpyzrFV1mj2gMeQwgNOA460UbszrjKaL6CCXQYXqz9uJM0VNpSEJ
         omWP7DdbqpXufWmMMvObZxEYYEmEJ75sY1xxsu7LsQ/JU6ZfWWMyqwvib7P5lGgJsgmd
         ZNZNLu3DSwWdrLF0xOxJzEX6P5SfyifhaPDVZ/DeWxNOq4Jcz31Rfod7p6DEzLjE8tfv
         63GWACj/nw8GWvVNg+S/raTKqkJ8wLFQshZXqoGdStNlFOID9zUfDuiOS6noSe1Q/IGA
         2dIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794907746; x=1795512546;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pwh1ZuUgyzVobDFnDosRkpIc8VIXPPyqqOxv+keTtXU=;
        b=bP1jlr651YaRiC8GcWRGQoSaDgYjrOZX35hNYi6tMCRhKOrYz70GMqGFEsDBB5ALll
         IDQmw2dZnJ08SGql76UPAm9Y5s2WqyO1H9qZ/4atjwPedu7QV5EIRdB9O0DRvqBgYl2L
         lNwLAjRTrmPLQD18KBFltLXcBjQCHVrBhKSue6pyo2RdOxTHmqGL4kJUIkD0R4WdaodA
         mhO5Pq+NBrcKu+mmfi3nod10mTMnGPIX6e5n6UAk9Z8Yra6p/bYuvbJN2cpPsh7adH0v
         65YkyG19yBspgU719/E9IUjKX6QDZTZIMcK5I2wN+4WoHxBMuvOZ3BHrLKDX+5F90cbN
         xjTg==
X-Forwarded-Encrypted: i=1; AL+hErGzp3h9fWDV8YGNv4SbAi3Ok7jwu0/YInoDkPVmTaCUGrmV8ZERUB9F5Giz1O+m2aiZfmdpzaa6NA==@kvack.org
X-Gm-Message-State: APuU4Z9jWn6hOTZo5m2HCuwQNLdS4acfikpudrfnUPF16z4B9lkYPOUU
	BONA4hsImWtlNf1dFnsVWASOm2IwCkRPuzx8hxO2tJis4IaG5b+U9U+T1ZXXra2xQ6Q=
X-Gm-Gg: AYBFou1ayZoUfXxM8QX/IIt3MchzvN6NDVDM/k8OCHJ2Ew0K1dM1U+7quCyT7Y+6EIT
	UzMny7/tkO727vYThthkEdvS5T14Y56/+mDsN0PYB3Uon33UOg7v4uVNs5m0EB3yk/Vh/lkbUm1
	SfJ+Mf9G6iJiM+/CO/Q+T9tOgAKXc1aLwrcKmDbOuwskMjEJSx36ts1xHuDsE8nDM0OspUFdYin
	oynxJ6ziSZCkAEecvpAf4YYg1cfbujdWVkxlKWnBG2FIrHWfziV/JMZnbgZRXqXYaFBOB711pwT
	/2u8vGANlp+T9bsXZhItaZOoSvl7+sRCcX6jPbBNIWWkX8nUApmIn+PJlzZFSskGj61Q/zDQgNT
	sWZTJRp8fz3YzZ+yx71IksBEjTOJmsksn1M5WMtQS4zoKVGskQGmHQFGRiftOCE0eZGbnJkrB1N
	8FuBEMt1MTnuvHXYPXdUw3t8ZAMZJagqTBUX6FpWyOieyTyQhOtuRtPSksUYyM6WArHmuc6tQsF
	3ZNYdXmw9oF9ZhdQDQROyYug8YYmwIAX4O3L2PaMdGANrkoYvsLOdfbq2J8UWS8VobUPDdp3Y/a
	10pureTS83l6MwAjesJ8NRZ22CfaXxMvLKQAwq+3YsIlPL24J9sT2P7WfsWzuA6D3UxG+R5mN7H
	9ppl7iSqMYAYxiU2SYn7w3OyaufhD
X-Received: by 2002:a05:622a:1b91:b0:55c:b331:a9fd with SMTP id d75a77b69052e-55cb331acabmr148011521cf.56.1794907745752;
        Tue, 17 Nov 2026 01:29:05 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d38b2cf5fsm43935171cf.25.2026.11.17.01.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:29:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/3] mm/page_alloc: move the kswapd node skip check
 into a helper
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261116232346.788145-3-joshua.hahnjy@gmail.com>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-3-joshua.hahnjy@gmail.com>
Date: Tue, 17 Nov 2026 04:29:04 -0500
Message-Id: <179490774466.482102.3857219640524403633.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: gqc8m5sroupu9t6fhnt1xsrsmoeysrgg
X-Rspam-User: 
X-Rspamd-Queue-Id: A9A6C40003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794907746-638632
X-HE-Meta: U2FsdGVkX19rBLsLwYfbkdnELBdOVkJN1sEQwkUiGOMkKnpOGfbK2KjK89KTUeVeyHdHK5rOHIRlk7m1uzVQ0ZIaHTtEYbZIn/HeAnB0zg9qaKN4n3JIH0PEKjoZoeDKkR1QeTpJw5jC3k4DMLa/4pQuzzzqsbO5GqTA0v6YBY+QchjlpQcqCxsikrpfKN0ZJYc0L8KZSak1jErg8Ea22eN1l4SLqrOkW6JfwJTMdfdENIo7+2e0UIKVC0ECIQxDSCmH1TeCjoJgR84XSDX7RFhqb4EcZw/iBs+1XP7SgwEhDsECVti31oOOgsvKF9q3x0MDjBH90zfzqD5GjP1YfHHbJQm0VWpO1wEci3Ka7Emca/QaUEKRUgxoENqUmekhDcw/bZ3ghA+PaD0758DU5Mnmn2yWmJ4ej+n0SNDmmLk9hsmJ48c1pHaGFqBWx6mpm46ai0p/QgQlvNJlm/CSHAtOF4yHKIWNdueX2Ob8n3dU+VBT+5RBWIGlhD5z7D8d2loWYd51xxA3pD1z3JUvevn58gkCTx9AoCiOLP6Q4cjaa/Bk1GbfMsbZvtRQBCcULxGXKoEXlp2JUrm/uwKbmRS8s1R449dxJW190feB/Ixym+2ieJyiGwaadBX3yNIjkc1Y7wRZ6zCKU+9GzvVqyDxMZUrtAU8FptaimbFUrZ3GqRgYjj/kcbIA/oN3MAyqy9VT4oMYvLFoan05Jqjq73rDKMk8wFpn6bkR+pM8mIi1wx6b+MaQKyvTkEdYcN+AWyATzPxRMH8olq250DCGORMpipF3CTfQrPDEm5Ucndev0pCUU0Z4HbJZc7kd92aj8W6M+B36ejSb9ib9n2VPNQ79lo2k/xFN/dTeRPn+7Sq/Nl9Y/kDGwh3OFPzdu8dxZe6hE4kVBdS95fPGEZ73lkCj+M9nhY/eTANqi/MK298Yt8AN1tf49e5TtfJLl/SImxDVt3Lk/ztZHMI6JmW
 ciTBfLy2
 gEXh0K/I7Qe6cwEhimQsh9A4Zjn/rtKKvfrmNTbUFpjUNTU4al8XeVfara87TJCpbmi0r0WEkL9ESDsheX3gjjvP4O3xE/1ssUGP7X43NqPfowFq6pwkFSh9Ju4THEO++865CrtphX/01dmMOoqZpKhvURnvyh8/HsqvQ/0kr+FpLNomiW0elzSdJ6FvP1UIiOndz0QVXWYV6Yv30P3bKneT0VTaBd3SXwLLvhLo1+GBQQHNiX0DdCMHYsWKhKUCAKTWK0z3AGftqQ24JLt4AJh3jE71pGCgd+eZ3Zy5sMiy/qvpbmBLfWJkhbGF1khzGVHdQnntpbrRY33PHJkacgoQetF2luFkg+sfnV9RB6Qa4YrhQF381EAMOL9FHgfxrwt01DTiK6SV8ixWwLG16yce2sHX38rmJMjqVyoqCKle+6loo2hpsGVugz2LpLS6U4g3t1KQ3UtnxsyD+n0rMq5bOxm6sEk9aeeMHHKGD5cmidHWebxgcbn8aCdkWBizrA5Bo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 15:23 -0800, Joshua Hahn wrote:
> get_page_from_freelist() checks many conditions for each zone, often
> with a big comment block explaining the conditions.
> 
> Move the kswapd check and its comment into should_skip_kswapd_zone() to
> make the zone iteration cleaner to read.
> 
> While moving this, also resolve a checkpatch warning which complains of
> a waitqueue_active() call with no corresponding comment explaining why
> the lockless use is OK in this case.
> 
> No functional change intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


