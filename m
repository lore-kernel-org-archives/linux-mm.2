Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DF760A381F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=k6IAAoqX
Received: by kanga.kvack.org (Postfix)
	id 16BAF6B05B8; Sat, 14 Nov 2026 14:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5F06B05BA; Sat, 14 Nov 2026 14:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D616B05BB; Sat, 14 Nov 2026 14:56:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAB6B6B05B8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3913D140441
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:55 +0000 (UTC)
X-FDA: 85434782790.02.0C875FD
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 661EE80002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=k6IAAoqX;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686213;
	b=kNsw75baE5nFINqbppDSACg5HWJa+KYZbXA6IYlOL+cUPO5HLevE8RpBLVkrQCdACxcM/C
	3NCBSGJ+qxCz60qwJckT7y++3TeCz7fRKpMjdpTltDRX9d5ZLLD2HEpk7yU5HryXzhxcak
	nbUFYDGu9+8MUTn/kIbEnN6wqM2gKDo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=k6IAAoqX;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUPvgjj1PBRfdwLGObCdW0ZVMBq40+Tj39RcKsF/1KM=;
	b=C95fv5FD2B/SgMBiqBXyV/xxJV0Lu0h3Saz5ukZYQgcyL/yfR/BzzA9P/pddxQnyDIVXWM
	lpY/qas24Ro2ntpHihOWc6SCfFfZBOySQQdrCO1U6JVhIA0Hqan3DKi2xap0KmklFvYFte
	OkmxMoFsIFHkUD0mMiOj/69y5KDcEwk=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso2009815a12.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686212; x=1795291012; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jUPvgjj1PBRfdwLGObCdW0ZVMBq40+Tj39RcKsF/1KM=;
        b=k6IAAoqXulUcHsvd1s/lud855i8TEPaWT7cOOGeMdHDy+ME1RcLPF2pIbV2QFtuiTM
         ZChn7PpmZeCFyzb1sN8a14TcX4AvqOcuw3Frhl0zvRgzLvC9PdcfUsPOo6MF+89QJ2Le
         /Z5+pPWkG2Py7BgESr9VQvOA2hYbPBsJShyfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686212; x=1795291012;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jUPvgjj1PBRfdwLGObCdW0ZVMBq40+Tj39RcKsF/1KM=;
        b=G1Nq4vQm4a0waklyLZNvROfFetNzqUMamT4oDlCiY7nS05ZRKDRlQgF2iqZxpqR99n
         KirfqAy/jEX26J/xgnc4SxhmjjRF653zrLnQTbyZODtaRGq9dKzlzJ5zrUtbXiFAJtAu
         WlVd5LAtDYvkDYFZdAz9j5JXorZGVOC6O7HCZ58PrBOItvdz12WgQsQeWALktYjC0Zbi
         hTolZSlr6qSSNpbsSs1SFAQ4GJtmE+zkc/2BAg300FjvFcwwi0y2Fg+JpMRwXZtHN/ix
         Bhg79TZQ6pqY6lIve4WM81eoHxBzsAj8v/mU6WhX0MZ5sl/Q/UENshzywtvt4uW57ACR
         9hXw==
X-Forwarded-Encrypted: i=1; AL+hErEnzoH11GaQb9nukrNMHT8S2oCHZBElwyoL+eujiQmhX2gRlti3GFUKU9BVwyqspNUyOPL9O3jSDg==@kvack.org
X-Gm-Message-State: APuU4Z/oW0ojnpbzq2IGoH0nfwKHq3S/p/wAMEF6icl9Cwgw9i+4wzm3
	4PYV6YF1yN58TJT1ulxmkapkXXu6qZ45LgNVEt2P4Fn2nAi8rAx+ycjuiLzxo68XloQ=
X-Gm-Gg: AYBFou0qgsPQcmjf15/LYrwoik+shIP9H432Ek8EZnJCX1odHxsDLx2k6pz13SVkd4U
	Agit7wkXFbPfhoNCTpYTjNFHCX2GAD5K+0GR2JUiqjSgVpimLm0brisGy84sgtngM9Zb3t8YkCo
	fNMv124fbY0pQVs7aeOiZF5JDlkdQ+NBy8+vlAFLG8jNUKBcN3xxHJaXB2vpRHeuhkfAEL1Ur7q
	9dCQW9OQQTn/bP0kfVlzAoRoOLXK9K3TRbEAmhhLdArUq3OK/HBHQ5eBASCNXLjARDMD/XYFkcv
	Cr5i5Mu9R8czrcwDy8gxVn+tFa+mjwCXLmjA+vTPpe4roJdafPQ8t3lHy12Swlz6v2fAxPHMstk
	LxKAGgzfqzsvNhl0WkOTqhGCLgejhgW95aF2CAbS7jdek8u3oj2ZTExgOzkhJOmI9Ra6I/Ar/zC
	F62AIkparVo1FohnSau9Z18ydCji/K76aCCaNqgV+a5cGh3mgJtglAB2lCc10tFrWrltasxiA1V
	oHXEh0S6cjt9oi/yUfbdubmtKzwSO46ZujudV9YWTDPw8NtV20rWyT+mIMZ3vd7QVF8IqLinmC3
	vjd2knl3fa7B+DlNelHikTcLWoqwdU4okznXO7vK7radiFzEweyqo+yaqvuvnQIDEeKYq6uRVjI
	gMyKFmH7DW2EDwCJRYQu4/bKwOBiaGbayf61ZzLBXISt0gLgiiggvhlo8U7suErnlBb4DX/1P7h
	tDbpMAcroBqzkuZReR4whdxESEyMQnw4ot4InM2/OceDN6HFMqxbFcR7+4
X-Received: by 2002:a17:90b:3551:b0:3b3:8194:9e4c with SMTP id 98e67ed59e1d1-3b381949f14mr141149a91.34.1794686212209;
        Sat, 14 Nov 2026 11:56:52 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec63b9bsm10009272a91.12.2026.11.14.11.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:56:51 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:49 -0800
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
Subject: Re: [PATCH v2 06/13] mm/migrate_device: don't let go of the fault
	page
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115649.cafa06b8b8401e8a@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: 8f3qnbsoczytdhth7nquka55ekbsd4ei
X-Rspamd-Queue-Id: 661EE80002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686213-281871
X-HE-Meta: U2FsdGVkX19zeGPf5nztJQoYYB63l4MaVySoMYwafLoI8bN3kST/OrZYj0WqzhPWGLKYFuUJ+gKls4un7MO3LV/juLByi9u7ZnuQirwrN1VjR/Ge5+fCDTHDDuXTiYPxIoBSwWcxRU54/ZEimQWIZcyjO4RtmfLHIhaBxvz6Sta3j8UdU14Ys0LYacVNs3S/40xqaDkrUXfMD+wnHkx5FbzL0HoMNg2w1BCrGzFA6Hf5fODYVjEYYZUAqS1W4zWDTazdtqdNmigiW+ALOVCpe3C/bGCnc+R6vOYM/OWcXuYku6MtQkeoGECUukET2EGJOZ770W7E2ZACwGCgWZzU0HYTfBR/jBxvdkT4qr6O9myqhN1RiQMJTcwvnM6Njl3ei0+87zFVnqZGI5f8P9eL6E0k0X1WyXdQuxH1kmho76uRFntLzY2YLLavY+V+rOeEI2CMBVK7x4h9f9DAKakDNVueJQaCTnU+a2KtThRI6bJz9msCEWGb3hMAU489ReHVHBwkpp7rce1sJSs7UIvw/zyarmnHEPA+FzAf8Xsbh0gTHR1YZcyVZ6Ahm1fRjePKLWZKUYsWkNQ6ATLTeDKgWkG53U/PfMeReSNXZqNuPYd1dcjdJqT4sEbWYDWAJZC5VbIfRO0SAZ3EsNMXTT6dX9v7774ZyrGwAeFQcIp5vMRyDzdk+NnuYXYv9EAvSnitvascA9truBiBzIeqA0s0ldEyjtgiqvuUyvNak87v9g3JASmhMkm+ptMx+aReWr9fOPcAEtdnvNQp7eYt5Bzzzz9R/3cVjhTm3Tv86dck0LjbL9hqUd6Fl8m99/jwy3w0kDVcHrDw5D0e8Fu9xeGCahFrtE9djTz3QMHjbXB8jw/Uwf9x5Ihbn2mrElCW4iQc7wSh8AdPBNe40h6peacLZsEPOeN1EkHzCTjmnO6BeOqEUv9bW5oxjrlpdKdswbXXSIQLLCjcjwbkdYnyn4A
 Dg/6BqGk
 L/rurySeAEL2LVqM0/HJAR+4nMiTdbvZ8wmYwn5uO9WW56Lsi/uwFGEMTYDLPi4+dTWZbgKUexJeYY/cDp+em0qw1QIaCVmI7DaCE9DbgowOBcYRmTvgtlcfUta0NKqnyDZR7bHMhPjAXFJyKxF7fzgCJ23qRATo9dwirIQ6H1ci/1fDcYRREWSYfDWWGgpSAbHidC0+8hvXpCGmqLDs8hTez+1aYsJkJBsAjLBOtCwdaPhO19ZI5oHGhZq5nHJmxfEIq3AqUca+o/S1tp4lK1HQqLFZchLoKPGFMzF1/ejfFDdi2U73qIVrZD4xYiKt1w8KhUCviBfpoilVPQryV0wKeVzTwLBWnOt9qwrOSsfqX0XPfBROJCnaAeD3S+buI+ReWKzLk9FCaEc12gIX5XAx5D7akvqsXMsZklkBvDJudhVn3e6PJYCbW7cmv0ae8H6DW7A4ktfuMhTHiGwxQ4xwlouCI79jokjqrmhUK/OcGT+uCelZRTUA84xiHi99tj/V/A5+LRtQGwnP2N8n6haA6mLI3fVpRXDzJ35xulZU6fJFFQkOrH5zsYjr87RaKaqtu/E4htDWREBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks! I've tested this with the HMM selftests that split the fault
folio, and it works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

