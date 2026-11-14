Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A966606A8B6
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=YkY5Y/iV
Received: by kanga.kvack.org (Postfix)
	id 27CBE6B05BC; Sat, 14 Nov 2026 14:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234A46B05BD; Sat, 14 Nov 2026 14:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143846B05BE; Sat, 14 Nov 2026 14:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7AC36B05BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:57:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27D33A7FC9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:01 +0000 (UTC)
X-FDA: 85434783042.05.499EFF5
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49C55180002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="YkY5Y/iV";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686219;
	b=5wGYeifGB5nzYJlZLdb8kq+Q6mWkRdVk2LMG1bXX9GBsq3rLD0MYYTdEnznRfgJCIlGUSg
	+vGd8Yt9r+BRAnlK71u578gAZLRIKrEOx2XOAsMUJ5V3P3Fx/uENd7sZpBF+Gd/Ge+2KqR
	mfJgHMnURcZLOZqIEmT03CVneXjssHg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJV/kOno9dtsXAkcAOQfE/oQzfJxocwLJi3WPYE6qNI=;
	b=ollN0CFT1MW/G3gczOjb+g22MxeATf82OSi+3LQ744ahc1AO6M1jpjNymoyBl8k4QJGD55
	e3thxO7h2hoTxe1SJowsaRqY/DFQ0t3XVNpsztNcp7lsvdEE6E8i6x6x383XlxjEAuFS1F
	Uwi+QjykAmJ/A3OfOxnFYlXsiiomCmU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="YkY5Y/iV";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso12577885ad.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686218; x=1795291018; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YJV/kOno9dtsXAkcAOQfE/oQzfJxocwLJi3WPYE6qNI=;
        b=YkY5Y/iVF0ZANMN7VICauDT7W5ZgvRIR/mxcelQE0pAlTJTpaPw2XoTXN29/tQY1sf
         ppqs0q+M6h9ZnpWSGLhjHJEY6ge3pvMjr3nBf0WrUWxotS6yGX8oySLfKQuQn4ToJ/9a
         FFlVA6fh+0IBwADaZh7e/8AO2xdBsnuhRszbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686218; x=1795291018;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YJV/kOno9dtsXAkcAOQfE/oQzfJxocwLJi3WPYE6qNI=;
        b=xwxZAR089thIl3MqDTB2ZEULn9sLdeu2VCR6kfRX2HYRLym/xsKHQfOiwik6Zz/We+
         DDWl8Q6QFGmE4iRgdN7bXsm1tq5/1t0vBRNfBuJ00MN2ktqPCuLlVZk6MjyiXSiYx72k
         tiLRU5GyX/qojP0lJJlNl2ekKWu+02MfHTFbcoQVTi4TV/j/baGDr2/gQSWtUf4t3ey1
         oID08TwKLO2ejxu4AMUufJ+8X+FDANL80j5wpMU8J4dKQ0lpZtBFUxgFK/bp/LM4Gsfa
         81wZU+tKyXnpcNcigniXBl56namPvcjT4yCGIzLfTbb3Ev0hWSdbkV2XlnjExj1Su9/T
         F3OQ==
X-Forwarded-Encrypted: i=1; AL+hErE7/0JrPjnL1LzxjLaMni3dTt7myCmBqhOUvPA4OZfp1nTxstJVwsLj8SEOlw+/Od5rc6lyJ9Y72g==@kvack.org
X-Gm-Message-State: APuU4Z+eW/MACqv4t9R656SdHJ8v+29H4uohH60RgIV3Hn8+e9SISks5
	nVdxCUAmyglXrLLshx5GN9vUQ9LE2qspXK7kw6ZFOm8n+m/VqWPrrSB0YArscamb1ms=
X-Gm-Gg: AYBFou2szYggVM4UBoEDgOEF6n+29+h7rO7HSVi3/RysoZdzcvYFEWhCgwp34JaUy44
	85AXdhWTQ+PfOTVvGg1Wk9X/qngQGqgeZdIqHJfMB2Fn0UerK63y748iiVxxA4ZQtsbKOTXE09y
	bErvvOwb9EozYzv1mMI7wALWOX/1eB0QAo1BkT4V4/d5Wl2xTimBURHYHokY6moB5o0TL9gEay1
	eqEJ97+NV+UEIUz5t6vAgTlLrEdSw7VpWDJCIw3DbMaqWZil0BuVYtJe781yh+/GegjFLnzwbL2
	uKMMsSSsxZZKM35yt5Yo2U6w5HF/sUF3DVKCVArRhOSIZlIiSw0i3BzBZp1WypKcwZ2p9BFWn2O
	5H2LngIwDwlTzITxxpt2O/gcE0sUCoKdGjtADeUWb1kgwdYdK2VudvYUPRYNTc5OHCHhCWGUELZ
	6WerX2Jr9zCHhgRxBo1PalwQrKT7bw1k4ct2FH0KY+WXEzC2FpL54ltmk6QMuOtZstc1IRHsqQY
	6MoIDhTwCrP8F/BZpPmVDKVqNmGkaBqDt5qIxcvQtwslUmvR4vwfE7j6Q97IViaeaSUJJ4eUPIH
	EsjQgFLSOboj+frGIQI8GGmYBiBqIAXInEa736J1PvYJAD8lyrZ7ckGcThVY3WVSmofeRdBSBsS
	EXv0lS8PhUDJe9rXmbTh3MWnaOlztRwQ1BMX2tZOUswtwSPQFf1Q0gycCXUELnzgzgJlT0GnzaJ
	N79676IwDhbTqDFNsy+nnYYmav0pr+hPl1bRSAYFtXn7QrkLGmEDHaQg==
X-Received: by 2002:a17:903:2b04:b0:2e9:4d43:d58a with SMTP id d9443c01a7336-2ee0d65fb59mr62764435ad.1.1794686218088;
        Sat, 14 Nov 2026 11:56:58 -0800 (PST)
Received: from [172.22.0.2] ([4.16.0.251])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8dc955sm22202275ad.62.2026.11.14.11.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:56:57 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:51 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 07/13] mm/migrate_device: look up fault folio after a
	split
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-7-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-7-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115651.2b3100f5d9444151@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: 49C55180002
X-Rspamd-Server: rspam12
X-Stat-Signature: qagejrhscd9csu3ssajfn6euuxr6oy4y
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686219-606496
X-HE-Meta: U2FsdGVkX1/RW7vEAphYGDfZBtafd05SKV0zVsHR77h7ADzjTUfbHXynJc060bbepmQ21Zxy7IkZV7xWrC+WcB/fyRC+ac805eZ8werwtbF8mPfiR77ASIMU4d0gmhMFAMlgdqbG2OUDRGSrPYltfykQ1R9kwZXNQf8FUEdBrOZQgOoHbQ5roIsJT2KyuZNluDA5WKV/eYGZCGGhRHVrbzkNzx62fNZJft9Asx2eoK1dFzj/vSgOXbxtgOsnfutihcizSfhnykzpXAnZ0CbV+d6iO6Pt4Sbke+dAlmycLQ29W/AP8Gu6He1Xk82Lfs0gDJH5cJa3h57YRxAozZsyxAK/Y2g8qtFp7K6OF0S2ObsETbw4NbRrSVINUTAirDSxCuo2lAZiWqGt/yycHaAupo4j8PNEWI8hVH/33XMIZa06o6UmyBOMOv/VMa8c8pLuYgIjLYWCcEYPTawaHB5wEaq+RCxii6Z0c/8gCbOkJ4G5cV2U4HpL0Aw9I83Pd1c0Ho4WP0RvRBGUyR1Gw0xgQUCoQFApH5mN6g+CqmgY2Eb75dwcpOd6JMTYu40DlU3gnw8J9kmQDHjkxBNz+Qxfw/4Z60BJQUR5E0tsmLs4Y7KXQeHGXxBfewksp6hpafnwBxaeGLiML02wgmQS1+0JUUNHwSV+Bj7a4ismRXIUWgo8rslY2E9VKwzD/3HoQeCJcaL4ACazRhihiI4YogF+FmuiK7slqRQl0LZU9FUlcd6U7VAtvF0KZ/gyFifl7fjFIEHfgbjXQ7rSX08JNax1T4Z18HJReP12k4g23KU2oYJABT9IzXp+eCIriW0wgOY4k9PgkzjELTgb5D0CiTw2ObKNFgKc3xO2RpJEpzQuIKgzfPxwh5pybnmYOo/7IKb5M3fF5paJNCyULhaE1RWpjyv6P003y0+QuzLOBNP1FhRvV35zipHlMEyVUJ1VPbF+tEpmN2lz1BWpK52/W+S
 MqCYVOHS
 OS1jgMVOgSSPOV7ALuN96UYVS/a3BxWy46pp0pv/Lsr2DgZvUk5BzmUmlITjiUPNPWBSaK43cgjpti9omAk+7F97y4E4JSnulPRm4ZgeXPhA3exwK4fkndjT3EfxJOKjno6USrZztTuIKc5b5GOifdIFL2qkagpDxWENEF6lbQQHV5TNVaLwxlo8XQXomK1dREvN/hMJ6XM4rino5dlUkiz1v0vLz0MSRxuQMskuX29vRD9wfu1tNtlv6vjx1oSaMl88IQJ8bwvc2t8k7K/uM4UVsMCFw4TJ7Sc0LQti7r8df5sYn01JWbrL/h9qfW60lBrw8+Ujh9R+yZo/9qk5YKOZRlLQvtUKvXmWwz9hJrqqDXpPur4/V+rlVisfseYdWPNQengmZSpELNDwLttaDUT3zEkKdaAxbUZM8OqZ/rLYlFKMPIJAU/C7KyJrzoEtYBEinBb5r0VHCtnnZGgTa+qI8pSGxEbWQtM9ky5lqdAoDqLrtI52XIyWQvyLyIIFzlXwICGm021xzlFfRm5BpqHJi8EzNc7fZQhZ5ruwokr8Yl9N5RQf7OZGfPxu8DaHQTE1A8kUg7BZl668fYQX9ae3s8eph0dPELqZYjfkSs6vpWVGKSBvLhes/F/7RBqNedJ6lj0ESLFcbyQWT5DQ7phoYFuRay1Pgt3UH7qZRN1OKiDjikNGPQgWYla22m3C6fH+tLcUT31QRKkfJAE/WIEJlD077Ywa2nelh4UbxzdgTz7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks! I've tested this along with 06/13 with the HMM selftests that
split the fault folio, and it works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

