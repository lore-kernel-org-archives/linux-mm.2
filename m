Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F85D60A5BDA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=xXH6rwaM
Received: by kanga.kvack.org (Postfix)
	id BF3806B05C0; Sat, 14 Nov 2026 14:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB8C6B05C1; Sat, 14 Nov 2026 14:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45646B05C2; Sat, 14 Nov 2026 14:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7103A6B05C0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:57:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F196D40435
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:11 +0000 (UTC)
X-FDA: 85434783462.10.17AF9EF
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 234F840003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=xXH6rwaM;
	spf=pass (imf12.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686230;
	b=bNhcAZKLk3+f/+jVASlfoxHPo8g2OWP4PswOM7/F5GsiqSL3UaUpupB3UvombNoRYxxvOz
	ktcbHXJCUbuMHsSwZyUtruY7k2vsE2AkFsiMyEnaxNIf7rM2zFFf7DIVCA+A5lZGgRtXY5
	5A+fG64W1i2qXQZKQGnIvOwSHcjiiew=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=xXH6rwaM;
	spf=pass (imf12.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.178 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
	b=QDa7Na9YArB/aWDCYf118pWkVd3j9FJp7Ou7neIO4O0JQ7v8KCuxEaOrjO09QQpATaU+nv
	9YJFp20TugSFTiYOFVbvQ+jPuDHyFFpA3peamCkIm8c/HYiCyaq5zqeyIk7kTwxgA1ph2+
	ZnqAWDk8cLP51XZG/nNezALah1TFuGI=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ed39646f04so7473605ad.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686229; x=1795291029; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=xXH6rwaMEOl+yRqXwtbRfuH2nnaJi9211iDk9s1ebbnwdCdsYasOZy6DDh8pDGgINS
         +8k+Iza3bHiW3SmTqz06xJfcsOWgTMWSqG5/QgC2jCchUy0HKzqvydazOGNJIdat02XV
         gDI9ZBw+o+XrRb359Uaz7RLuU3rqim7/mF4Wg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686229; x=1795291029;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=2NCGehcMUWnWHOlyqicO/Qyf9mBn/zjHlvxXLWAEUxxUgv2/DoOzEmKF4iAMHZTyGY
         LbFAEAKjBEqn8EJEEk7/Z/rokGwRzKcVt8uWOSPZ00ywXnlvDB5MwCLYJIOYLUCusIJh
         LnW3yBZVc8Kx0JHoh5CdsKECTwnruYHAYMqr90BYPYeZa66akxbNE7XzvoQ5yO7Ls++c
         hxBm9colsv/Jf3KbmkmiIfnmxesY0rOkET2cqFBaKkR4qfcYXouYaDHjugdKQLKWrG1A
         pyZTtQvRaU+UpEETJCgq+nJY0BLXRG9U+YqYrvuOfJtraZzVVSJCBrzLYQrkiWL8nNut
         u4KQ==
X-Forwarded-Encrypted: i=1; AL+hErFgfWRmr2t5LCox3NWqarp2CDqSoOflACstJrgxi8KJKvAuc3NHVdr0lZNJA5ftnsRrc1/w2NDrpQ==@kvack.org
X-Gm-Message-State: APuU4Z8WukWVqoJFnMhPUSVjisTnsXUCzecFUN178jY5Hcn8QuSRWW7M
	QUDRIt49sWcpwuP2WG9S62e1UX5KXlLKMACO5iw7D6l9v/6wcCFcCi57Ulac75nLImJ2Hi1oaVF
	K6xVKvsEmjroF
X-Gm-Gg: AYBFou0eaHLK/y6rQHFSnWbKh6Hqt55MbwXB1UUd+vkC7QENeEiVu9Cf1uNO4kYVOKq
	zLblcLLrJgvJ4qC/2UvKw2mkZlWNjT3d5YMXec5UPpJvtLwKHtO+vcnGXIGoSVwAs2UxBcn7lSa
	3LeIf4CeLl1bX6Uvmi6Pfa+HtvLt1ULfGPYzzHeA5WFzxtQ8w7XICrQDMM4hU2zsOcT+Wz/sh0G
	P9Qa2m/nnuGdguBNBPW3jm4tM6UYJAWejwA2mmusxrZuOSsDfqtso55oUd8bOWazUBqLJvJGf9h
	Rbbrc2p8ROzlYlj9GgUAi1UFBEux3bM6wHzOgOWgOYK4SuC4NAz5EKQTAvfmYnktDurR+0CBQjW
	vnYVfYROPViHZ7JAmZy5iNzXFmVgRwMFfT5188PBbeFuDDnL0xl2DnJfj5rfoPcF870VTSYBztz
	D0Rl+CdptoA+uODcPpKjGWIyqIA7r5/4kxKwG8EQV49YIvhisjFheBHUsmiTsphGFYNVf8c8MyP
	q2I4l0KrhZUc89BXhuvBtwVzZj+TYbJxFpOpswnlUJTE8iBZIGgcQCf6yjv7NAoYG4LKuqxNoZZ
	oXOeSaaufEPyqs5XRE+ufpZPO+SefAF3sWNPTjrsJR8Uwk/8l8XkISmOUruF3C+hhmlQUBYpZaj
	hgSehCNz2Xlo5HKhiKiZYDpmD/v+Zc8UXfwUAw2KIopP37zMzgCiXWQNUty643kB7JpU/lAqSFN
	EiwojILl9eS4pyBvAWR7y+pXcPr66eDpnLS1bQH2KwXSXTxiKqvLMDGw==
X-Received: by 2002:a17:902:db04:b0:2db:3b35:1ac6 with SMTP id d9443c01a7336-2ee0d9eb41fmr60393715ad.5.1794686228885;
        Sat, 14 Nov 2026 11:57:08 -0800 (PST)
Received: from [172.22.0.2] ([4.16.0.251])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7cf33asm22947505ad.27.2026.11.14.11.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:57:07 -0800 (PST)
Date: Sat, 14 Nov 2026 11:57:04 -0800
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
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 10/13] mm/migrate_device: refuse to migrate shadow
	stacks
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-10-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-10-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115704.9bc8ba24d73b8bce@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: arthxiqbbkzqzj8po64dcjye691j8pw4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 234F840003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686229-658290
X-HE-Meta: U2FsdGVkX18Nlv8UFRIkpyHyCAb2MPB3y4DPTRjmX4ZW8Qn9PF6yxmyXE0zeS72khN4gEyFtVf6nvm4tCJhtHS4PmWPPMqXCpCn2WNWCGsCsogUQL2jlA2t3e0yxc5sRxsF75ymzPLQZvsOAlrejlBwx6h8biI+d2bEEVOkw7YBc9Fbpmvo5fXhUjoeKdQvY8FSqndy1kBKKyOlUzI3IT9xdhznozyjLN1BjGbTel3DjH8UAMZIi6/4vlch8+JMm6XARogSK9XJqwvop6mEWqRuZbOWgaUB29i+fjH+PZ5/P/0AkxQSmoc595volGwnQUmyLvP/bL5pNXHlcg/Zge7wpQreqC8XrJPBON5Ehrocyq/tFJQEij0L7nT42aJoX4N4KJh2QCGMa7eqnQI3KLWE421XC2fwA2qejnL+8vSvK7ivC4Si7QTbTZvrig7a8r6jqTqRifRZPBluHQb8m6zgk7+8qYooebgA4PDOl+CXsP3qbd4jq6M62znN9BeZooU7pk0SnNMKqY+KBdh0BFOk+4qmQe6VXHufNe0kbMg0BDnn9EGMngcWMovPoQ7URbvIVclQm60nrmnUWPQ4C0GkxoUwG6gZDqbBSNgTPJjDc3ZENeXCG/X9uLaF2apX+FYgh9v8oHinLvVyJp2ESZnsXWE1dMPQMar/uU4J/p8PGny5NOa3HO5MZnsvVro5QADtQzT1wqUJAPG6K+p+s1vNGdswCOA6LQ3Q/DQaz9NdIpCXvJLsVUH1bdc7Xt/jG5cCKBKM3v6q2UxakpDPOcyHovi5dFp7x8Z35/75VlSw0BYu1mjvRDhkme/WTLbowiF1831UFORKiqCZh8Svlm6vNSOFQB2zIipAQhRM8Oo8QQlAwXZzmOmkO4xclZ0GbxC14jGn4xLcVpuLiG3+hb9pbgqzBdp2bEBr+6btfN1Y+iZcE8zB/0VWwM4cCbx2HDm74B2XO9//aODetMQE
 GOUVM5AQ
 TpZal4uZconEK3+R+2BBbKg+rv6Ht6HoqAVPnE6QrpQkYAwQ9h1MMiQP5YScrWEIUOuN/Rl3MIqBFL5wEqVjycjfAxN8D+k151dR+46mqapnVgFrKVUO8cjRNXaroaU4xKDMO7YmeXtO1NjySOuBJEg1bDxWppPa7dWrQazGUlLxmIdzm7wG68GetuzbzvlxPYbIL8zJQXFUdPJXUGJfyj/1/znO8k+5rS4Ovh96r6x+UbHZ8s9L/LUNnYq3svTO6XZEwnGJcfJm2zIkoceG9Al2IkXPSd5cR9suYgcSUVzd+A8hJ3XoHHVXWbzlj/EAVZKG7eKwEfqc9lOqEiebjX7lRuGRq/hKFI4wBQdKKHHR6ljiaQ9ZDl5wZ4tli5tcN2RYEhKFzGSGwqNKr3RI4FqY53giXs3NMespwfXX2lqhh1jXevfspH87+JlUY2jVR7zoX7lwbv1mWzJOEPVPU9dgTlMMI5vFdzUy2EXu3tuUOfL2mKV/H0rN/0JOK935uk9AXxK5Ei8zWLkaqfaWCdoX4jz3nvNa98p+qDd+uXQrG0dxdtdPeSMTBG23XszUeVKhWcBXvmpFY5fWHvNDNRwKsRRmgS7rCMhVsAX+tkxql5IwKi676GoqH9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Chris Down <chris@chrisdown.name>

