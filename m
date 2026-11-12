Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5971606A891
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=lrmo5/LJ
Received: by kanga.kvack.org (Postfix)
	id 7B71A6B00EF; Thu, 12 Nov 2026 13:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741816B05B1; Thu, 12 Nov 2026 13:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609506B05B5; Thu, 12 Nov 2026 13:33:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 279696B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:33:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3BFB14081D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:33:39 +0000 (UTC)
X-FDA: 85427315358.09.E06E00F
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id BF14D80010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:33:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lrmo5/LJ";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794508417;
	b=6vYTfdZmJxYAz8btGbSdMn8U9vtEW5TX+pmnqqMPZMdk5bZdQCXItf1kjaepYqChOgZ3Rl
	uyC6qorKfpsSvzWNI1i2a2Stk9mkmRV6pvx1POuOgfWMlCw3vM4JxLOYZO+7Aabib5ahNO
	OHgph1QcYC+I6JUJ2AQdkCJnh4HNAHo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lrmo5/LJ";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794508417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0X/oBNSd837oq8qemdGMRW3gOZl3XdynAbQm9FPXsA=;
	b=Ei1omv7lku2nKSblPq/AF35UVyyVb/M2UoalHx02LxIZrARm3OWE+1f7ozfZZEaGHnlcdm
	PcBGSLm36YMgDDYqi/bkQzoWJWW/PYBUIuqaJJonQxN+1nBvepyPtIr1J41WCJ/bMdG2fx
	Q9Vbq4aJsOmBpNRg3OsWL+h2VjZDR50=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f30660e69so4749985a.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794508417; x=1795113217; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E0X/oBNSd837oq8qemdGMRW3gOZl3XdynAbQm9FPXsA=;
        b=lrmo5/LJQF3QJzWM8TScpf56F8Z5fouJYNacAXWGG/0QkTx2txRJmlR0NPBruqG69+
         c0D8gn+9Omdmby1lI+1Hrl97O9HYiha1tBP03KiUlEDY76ipnsHsxHI8E2naa7IMR1gW
         DaSnn0CV0dwGIzbDngHUc7Cvo7ECb5PeBQK31lojQJmXJ52nUpOA9rQlNtXjZiTEEmkU
         QSKj2iFRcMmIQUjrAsU0y/Z3bv8WT7pC+1NhTEeKFRxE/zueOKIl5wpLqUHk5ukCLYjd
         qWzuGSoTq7H5B6zz1W/JZnRfPONZPmaTKWjHs46CIMihP0xDFiBx7fbmonP9nlgfdgIK
         RvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794508417; x=1795113217;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E0X/oBNSd837oq8qemdGMRW3gOZl3XdynAbQm9FPXsA=;
        b=lfooaxtJD4PnBzNP2xZN6G1rFqM/bXJCzNP+YEeNusQWp45C6sjvuoqB03UDFPahWz
         /mAU2c/Xou0nxubU5s1CCb+dJkv7mbHEeM5MfpnugtT8ncAIVAdRnJJNMx1xqSMU9Um5
         zk2kY9/Qx6TpprghMeqtijflHi9OI3bkugS9vGc/dZvFb4pTMMwYNFIBMfvV1qhI8agU
         DZUG5kj5qZ2EzbUZoVJGbCvFhP/GAdjqnUfmO4Wx1U+bTCq1FwwA3+Gq6TGJSwflaH3/
         2p+cc6EvN2AUZB9705xV0w5Z7eQRo53dsLscUtAdxjViUaf0/Nn2PsO0s4/PzCZixTVq
         5U/Q==
X-Forwarded-Encrypted: i=1; AL+hErHK8wwPtWwXSuDRG0nQmlxDQC1sCmUdH5aISvvKmFapGKD2LL3DnAShUlCFmI3RcpPneP02qV3zIw==@kvack.org
X-Gm-Message-State: APuU4Z91gTbILl+BRJYcQtcT8fEb1K62hm0bacq6ntu19jfU42+P0X1v
	t6Dnwdo2p+vLLrCf1K7VUKhe6tBBj5h5o3M7pRTSFOG9XkRRphHq0FbDlWw8pEbApBU=
X-Gm-Gg: AYBFou0/y8gBHzxWmkz1SIhsG9uyDWIznnAzLQsjN4/CIeb7bDGroxwYsaaa9lTlovu
	zFBYnZ5xI1uSu8It+looTu08MonVeg2e/tIUz4xdvSAmO+R6FOOwjooFlYm7nC/EeTynIWiA+s6
	uce2sWfN2OyGVPVpVXNMDsVkZ/XW63OZ/+3WNPUL6YltSAa9isdYNk46h5i0as0Yx2Ob6sPFiue
	TzT4vgeF6v4WX/rTpqVxwnukpZViNzEOY2Lg0GwEmGuaxZVHcKNe2ua8DZHwcDTFJQqdlmUt41G
	J52K9Ds5YMuKhpot+Giof9KFnNi/qeCOKWOa0HsqsbUrbbcW0LeGGdMj6M0qpsdtKurYfquNEzJ
	i7OEFAyxa5IlKzP6n+RR6He6Jm4V/8KDcY+rw+Q2C/pR8Ygx1z98fZmZKmDUQdIobs7rZVnz0Bt
	75/vD9gSLrZClI4ugs+c8fnVpYWFIhLVGDl1oxLILWA1fNPyCe9qNBSOyEoNBPlLtBP63CZwg4b
	Bawg6A5u0uTlaj+oFOWGShsfA0w9aDLFok8VW3dvWR2bwueaHC/MVQORJ9yQw1v4V9lPMmP6Ze2
	4ac0o+d+MiKbis1GV4yqS2ykuNZ5rfDSHtgJEio3JuzccZOZtMYGw+2YUFzswkeQowR+Xsef7n/
	j3lG9txE=
X-Received: by 2002:a05:620a:27d0:b0:945:ad43:1d59 with SMTP id af79cd13be357-9494bbef3b9mr40481685a.75.1794508416926;
        Thu, 12 Nov 2026 10:33:36 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d456b2sm2035036d6.12.2026.11.12.10.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 10:33:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 12/13] percpu: search the whole reserved chunk
From: "Gregory Price (Meta)" <gourry@gourry.net>
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
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-12-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-12-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 13:33:35 -0500
Message-Id: <179450841509.482102.2272758511939089806.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF14D80010
X-Stat-Signature: yg6kscr1847myuf4ca4ih33qnot8eizx
X-Rspam-User: 
X-HE-Tag: 1794508417-72708
X-HE-Meta: U2FsdGVkX18GGeqY8TsL+wQ5yJ+TvV5YM12hZuYwywylnAygSV6qkbsI+XMzrZv7GndbcI4QgoELp4svCoEKkwq4NCq/5cpQOWc/3dC4/3V/VgQTKPmMhPMX+axeKe9Ml8C99wVbAFxo7EJVt2OLWu1gitgTpCsI/b/h98CZyw99Zzqrs7BUArrU+/E/T/UciLuebDdK6r7yF1N8NmzPu6GJ5cQKMySypMOPGk9GpdHOqtDC08rqX+/TZ8EL0Ktom7sWAS65ogJT0WeI27rFmquZtjVBjf6nkIdB7Vz2SD7wPtOm8kFmzlXKVGfObirhnTn9/HOzi9WfNU8OZ44U+igbfNjX6z9tiiuMXfUkLnyt50E4wzZcl3c6S868lU3W/fTpJQ8c0zVIBQg7Wgs6ajNJUj0qV0gmII6rEyH/JdQdaDUQpXTjBjfVZIWFTeY4CAiXBTeR6QBTlr/HnQE7oK7h6sZXOKpSM60Wo6e3zLyayChaa6CPFH8CY7N1UIOCMTNWpNNbVwNqWA0jeDRKiewgafwjY9HaaSy89VK7TRiMCYl6bXIwcEcJr3QvufIoO5pUAYj+L4tJtqY7DE/m0/OTE7o4HsJ88Coi7FUBbZvjxmLGapevlz+y7Jxd3n3usr3udRzX1EdYiixdm8e+hxGEsTsrDmB31QpnHUsDsIqydWj72M8TOf0a1h2xyWpzYZ/eOQCSukYNomwOI+p+OFg6azZfJ8VYYhw6WNfbwXubB0AhNeyMBcuJqg/0KLdyYGhgaHGvNMTArnO2LVPTvIKNM4eHGIGDxv/BCJZbBOyzoTCjxarfTKvqxwDqc7tfcVBkIYCo3FItx1gIRilpEcZhdyglQEHlkDZfxw7wYxK2nRx4ezlmgBpf+EY+nyYxk9vzxXIR1PCmnSLM2a2+5RgHn/knvXTwcd5iCYlwCn4gJBAxlDiMYjPYAcJCURGA+hahhHLxDeqnhYbyE1W
 f3s8xWF4
 RxxK6hVqigrwAkKkflZbO/NuolxLF+bu0pEQSNyMIx9GB4LOelappsws5HwEKcFbueTGJ5OUoWJDnavCfSnzrjd79bBpc0jXjS/uaKT7vtVlk2Ks11Rn0R2y55iSD5u08eFNa6lcLhDrJjugzu/4LBidyofJZGq55ofMJIPNa/xpgAZwYdIUDFyESgBZiFkzsx/LZGjkepuUldwEHxI0mka4BoNyH+ruvH0Qgr41Ocotmil69SdYryfb1ZK2gx0MlofbK+SwA9joWNm3Z+eK+p9Lc3afkujoDtmDoDE/F3kpSMlUJGcrUg8s/8cJW/wKvvE5IwYxShrhFT3wFRJHmJ/eHV5hjZ/C9bhKKS8Q8FbJuD0Yq9ur9hZjZwVqpg5eCXDM66fh747R0hT2WO9BM5pFEYqM9oXHCrS1s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> Loading a module with static percpu data can fail with -ENOMEM even
> though the reserved chunk has a free area that fits the data.
> 
> pcpu_find_block_fit() does not scan the allocation bitmap, rather it
> tests the request against hints, starting with the contig_hint of the
> chunk, which describes its largest free area. If that area is too small
> once aligned, the search gives up even if a smaller free area fits.
> 
> Consider:
> 
>     request:      256 bytes, aligned to 256 bytes
>     contig_hint:  260 bytes, starts 4 bytes after a 256-byte boundary,
>                   so 8 bytes remain after alignment
>     also free:    256 bytes, starts on a 256-byte boundary
> 
> Ordinarily this is fine as the allocator moves on to the next chunk or
> creates a new one, but the static percpu data of modules can only come
> from the reserved chunk.
> 
> Fix this by searching the allocation bitmap of the reserved chunk
> directly rather than using hints.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 13f966373f92 ("percpu: skip chunks if the alloc does not fit in the contig hint")
> Fixes: b4c2116cfae6 ("percpu: update pcpu_find_block_fit to use an iterator")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reproduced the exact issue.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


