Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30DC606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UZ9riCY+
Received: by kanga.kvack.org (Postfix)
	id 09CBF6B05CA; Wed, 18 Nov 2026 10:34:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CA46B05CB; Wed, 18 Nov 2026 10:34:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56A66B05CD; Wed, 18 Nov 2026 10:34:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE8596B05CA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:34:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1EF21A07E1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:34:16 +0000 (UTC)
X-FDA: 85448636112.08.D9E0187
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F5BCC000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:34:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZ9riCY+;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPfd9sT7cIQpS4/P+eH82RaGEnWHTOY6rgpHOsgz4FU=;
	b=fLKVPnaVYyDdigYhnTxC0vnD9cZeTbH/2b41QOeAPzvGGb+4tmMOZ3K0Tm4CRwcoYs2lbD
	tEMZDszx/99ehIY7WxjBokvrmvHxWKa66jygkbtJ6pC0vnbvLoRnRwUzI+zzTkA//+DrRx
	b1e6fSU2T4vSH5MaYmSn9Ct3ddARAnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016055;
	b=ZZcSbV0I857HjYPf18StSJM8FolVFDOd7qpjouek1oIRH8+Jmq/+DVv9A59xW+7GGNbuku
	OzSbsYkG8y/omu4wbWdT9Xfrnchg1K16Xc27l79EwmLdexYyIEp1xRKCUzTuFMl5MWKqPR
	dFcRw003xOIomODBRbT2ZWgh+r/E0vY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZ9riCY+;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7A4A623E4;
	Wed, 18 Nov 2026 15:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5201F000C4;
	Wed, 18 Nov 2026 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016054;
	bh=lPfd9sT7cIQpS4/P+eH82RaGEnWHTOY6rgpHOsgz4FU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UZ9riCY+VBFYR4EXiZYNFAl+LfxR32qZOEHjoH4BZJ6CttCUQXjevO7SgebXuzVmp
	 BvOhcSKoIooBkBJkgZeutZZ5rbyNO+VqnNE8XgWVInAlUC1yiO1YnDWvTUn+t3d5t2
	 Vqp7zWEVtm6mUGel7ZotbctxTEl7AzmbjJX18y3RuH5YGluaA8U3znwldO05aPRqO5
	 Z++/Tw5Dcy5X724corwUDOQrgNpxvUF3QI/cygw8kBE5HrpclBXG05BHlsfc8OytFy
	 Ov75P+aYJFR5/JkYSIHIfPDU/ayMOaHonq8L6BB28TOXDmG/FC45Z4732oYgO3LqkH
	 U22kSdqvcsEYw==
Message-ID: <6e3de74a-ee6c-4e53-a4f9-e42e1d721cc6@kernel.org>
Date: Wed, 18 Nov 2026 16:33:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/13] mm/migrate_device: refuse to migrate shadow
 stacks
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
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
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-10-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-10-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1gcpx1jjka3daoj9ik3pie4p7jipx13q
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F5BCC000A
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795016055-665139
X-HE-Meta: U2FsdGVkX1+NesfVwidC3W09Jv6bF8AhBi5lmNdrSJcFNSAwGOBzQT45LNpCn+Xt60tGuzxhV3akqOI8lt8QkTbit6T93w8McWFMz5WhGl1SipHsYxlpUNYROezBW6WrjEya9XlSF31saTuqTcmRdq/bbVKJGxRi+2D7KOjdo1+FSy1MT22NA2oVZryaZ33MxHts+Uy++1xikV2gGjeU0JAmDSuAfA1FfaS3ubHZIOip2urd/iCqaIyTAyzMhdezvk0PpcfE80xvflfKyxE17aKoNjx5E8y+P/0fSVpS1WwzbJ9ZGC2PzxzuPibZfDE6lcQNW4DBkVABF+CR42tpWqQp36yhsGINxGQSgsF++Exh80yovLgf+db9aaPfr2aHs5NN4GTari498yTYrpfepfeflbyL1ijm5s5cZmQgkllFr9IQzl4k5PsC8s5xEt9k9epEVAUmvExdjnwOqLuG3qpFUi05w8IvxRqh6X8vZ/Z2z7vrLZisVsHtDXde2DI5d2LPwBms0YUbKUrxhFZmYuWwePpy1TMXnvKg1/XeKn0FXsQkPPatTliFuscF16nHtok1LY2vDKLpfimOEEaSSbiaADBQ2XPp5SMxRlV+9h2bOdJ83I/p/RbHiS7bWpSvW78jFSMmQwOyqEOSMZxAD9QoanhNXTcBD63fvC7I2G1lKJQLmoY86gCjMHkA247sWsxL1Dk2NXbCsyGJJBgO0m1NK+/Ba3stHiwVPPZcxbg3/Y3PTX/G34ZDHbjAE/taZ7qxbuqUpYfGkfkK68y6leUNTXOnTdRTN6Xj5Z7FAQKJwNnZlixB6iMt64kLCuCRPYMoiVA2z4ZuHkPXUlGYM8SRSq/4yrdQc9gO15HqV4gM/Uv9vNXQU3UhI2F49n/9Sz7QP57Lvz7gUEzklnLctXP/Cix77Fa3K+MhyqMUraNMr7VIHIY7Ni8eGEsPwIXbK1s461I0TJAazOZtZTe
 udyVN8G0
 uMKCMxUTtjwjAt2BRli/SXhthSodFiHUozeq7zVg/4+DfMNibg8qNqYgsx+rjFffCSBL7Ucy1n+XV3Kqm8Z/DhTWMaBsEugrvkD05fqQiZ4rMMuat8qd/sjrKwSGU0f0vIfU2wDyi/jIC3oXUCRLkTOAer2lDObqYOM/QZ69KqhWzpiXR4xt0KHMNtgwO00PW1hDe57IK1SxGj7O0doOnbMs/ADd9iPAz+b+mQFQdU8+wnFClGyi4nADtBICbDm9pB6L+X9tAWUz59ZrMzL/hQaghPXnJN9MV4b5SV/XNH56G2Gf/KCuaqLYPlH4iZvG7Kxjz9kht7mgN/jcl41UR6TiO2s3NEMlZUcIkZBjwgZCPGSugbuzKOTMYUpQMyyu9ObsFRVt12lVZRQGZIN7VMWCZ718liyBCE0mTG7WFtx0KiXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> The kernel blocks ordinary writes to a shadow stack. But pte_write() is
> true for a shadow stack entry, and migrate_vma_setup() sets
> MIGRATE_PFN_WRITE for each page where pte_write() is true.
> 
> Notably, the nouveau GPU driver takes that flag as permission to map its
> copy of the page writable for the GPU, meaning that the next CPU access
> migrates the page back into the shadow stack, and the page then holds what
> the GPU wrote.
> 
> Be consistent and disallow this for migration.
> 
> Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: removed unnecessary comment, refined commit msg ]
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

