Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A504606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y1sqXpDL
Received: by kanga.kvack.org (Postfix)
	id 332BF6B05B3; Wed, 11 Nov 2026 14:21:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC8C6B05B4; Wed, 11 Nov 2026 14:21:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184026B05B5; Wed, 11 Nov 2026 14:21:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D24486B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:21:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D183C03FC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:21:05 +0000 (UTC)
X-FDA: 85423806090.25.37BBBE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5605A140009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:21:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1sqXpDL;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794424863;
	b=dASxGenUvHTXEKP3quHvjvPKM/eSxhr4qCSZqMrip0tK4l7IWmMo5OZxoeE4EEbVJdZ8k3
	7KJChp2HPkkteFNVcYnNoRwkjhvbQUPdyicuRPDclevFfEZDfAprNmw6flwha11XwsUXYa
	aFzVdIY+qR1Ocdr3MLpBLy0eppTw1w4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1sqXpDL;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794424863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Soj930bwFBTZxNzA1GiyO1XhwtS7FvpbLkFUPLX9r8c=;
	b=pfbdhk/wjWpi+QTjkHThClhm6uE2kc0Ew5e1hN6XDuNJzZMev/CviBVvnvjOig2DJK7hb/
	vEC6gLaLrXm903u9EhXdLGFTNUrP/cOGVc87rc5rQ8yuCyMP643UjpIEglEf2F4lBXM5fo
	8NGiRalWnMRBGd0ACWCcNGvtXQswPTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9EB660F25;
	Wed, 11 Nov 2026 19:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023FC1F00A05;
	Wed, 11 Nov 2026 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424862;
	bh=Soj930bwFBTZxNzA1GiyO1XhwtS7FvpbLkFUPLX9r8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y1sqXpDLdAdEYxJPXUlN5q9+a+D9q0AIw9kjs9hfnxFdwMfaTrn8wGAI2YVSrHbjv
	 YW9JZ/Y/L1yxqXLESu2IKbxbJcsACHsl0zmEWWkZSxcGPxY8kI7I2xtKnUEKGDuQIz
	 XlUxiyPEZIVWJmsllMBNGhrXl2griP4Nx5PCZmITSsl5FxTWBNRwKEVm+SoRhA2X4Y
	 xFuyyPjHlfu9BiAVl91vrEuaz5Wrs7d9dMW2DbfUJ/EhBAlKPa53M/DqML0HGfvyBA
	 rTFKAw/f18EUatNd62vqptumb/RD83YPnexgHtqdt8dZAJ6gAGZ5DRDr4EGIB4FsWe
	 bVCxIfLOeNhTw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0A217198003A;
	Wed, 11 Nov 2026 14:20:51 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 11 Nov 2026 14:20:58 -0500
X-ME-Sender: <xms:E8D0akQmBszOOkf2V4Pas9hPJL_ml4TfiVb_k8Fa2fBqNoFSxLhiJg>
    <xme:E8D0aujZHsoBlI9F-DCvDcYq1_1CIV6D_V6XKypQzWFk1y5byz7v7OfPCBgpAP_L0
    YblrrZQPF_O7NZj-3vttgfEaVQoq6az4XXakadlhl-myb-CDEJz5BYD>
X-ME-Received: <xmr:E8D0atbS4S9D5YkzppwCPjfey67EkNJRNTOoPBe_sgiq301jc7kQfv9btT0>
X-ME-Proxy-Cause: dmFkZTFAt7HRtEDW5rAYKA5wJsU/hkNTWmvDTT2530v9ikh1nEEQoMGwn8WkkMXLFvMbzz
    m+5MBTcByYkkaiHHf5Pvb+d+Yec9HEVjgvT8q8NB4D2n+yGRrYH3c0zsKTDEuZP0KKuEfB
    5G61bTEB8knr93RLOGasXpXd5WRbwVHRx2ZWpa9/38aDo1YNO4lx87ZqWFlaYmXeP/Uf1r
    LR0vRe2XGGjLFxegCM1tjgqZ1nDbP7IoHfh96QQs3jwVg4ZbeseYfJFn6+84ytWcS36xsH
    BmTn6jUcDFZuxOoUoW586qRRfthPizlB2CqswLvyPaV8i2Puc2yV63QorfkwBa4BJNHIE6
    FqTumCqimKhqGLg9qa4DTTglotYUJXNph9HpSyzly3WdQluCAku1TIy7mj+ykUg4PmcJn4
    +fahCwVtu5FZv1r/j0XesuMnMeDRheOMiGFVtKbR40OXoen9Vv281WPZUbiClUPF/fjYtR
    HeuGr5eWQ4f1pGSAQUNwoKGYm021RLG8ffdgZZ5HYvt8wZ0s3hwV8XNb0RoxsmTbdrBU4I
    UunpRgweubVVrPj8NpJgrvgQ4haPMbaUV2K6rpJOjgAmv/PN67p7WNex65orWZqBgVmvzn
    nMxnlQKBMTFArL6XMw8QtieEwtXdw0ZyEhCd+ennXm6qWXWhj+JfXJ8kj4XQ
X-ME-Proxy: <xmx:E8D0auIU64qcshTDYMtTsiJmmHKWWTSxs48tFLF_Vms8J9SG77UG1Q>
    <xmx:E8D0asdwFI96dLN1SzY7lP1yS0NevJfzO9LpwUX_eqxefPBa1KHVCA>
    <xmx:E8D0avfjHO4FGyUTBk97IqYVQvWiB-U03Fm8wuCRLtcg16yvobGMYg>
    <xmx:E8D0asP7tE6e5gmctaszQmX-9Sa2SxEpMJV5B5xSVmDlbW7MS4w-tw>
    <xmx:E8D0akCFZ0Bxbsytf5KO62Iqr0VaDHxsJkNrKbCpZd6BwXOwZmyhwqzt>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:20:50 -0500 (EST)
Date: Wed, 11 Nov 2026 19:20:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/12] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
Message-ID: <avS_43B79K2lUV3Q@thinkstation>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5605A140009
X-Stat-Signature: pwc7yrjmxuziiqqbgznc5b15zc1efz4g
X-Rspam-User: 
X-HE-Tag: 1794424863-505213
X-HE-Meta: U2FsdGVkX18FpdP4Oy9BIdQueZ6nYizMCyosgXv4H2wSWmVEm12TTFBelt3lufdAWzE2cgJqMJjaoD8BvEmmlnNqclEmQ7A+j2dwb5ec391E8J7AQ2eVbKSTJse4WsCJdI9mzMq32+Zi410dKG328YL0QukwaPvPz42u/NJspZ6zBDpkng+cK3uvJCoa4taGCaCbBMlCdnOj6mmkvRbMpdsAz53bnmd8wg2nHlKg3jgYaMyN21fbsP/2qd55hbRCpGFuq0nmd4zolTkDSyJaFP6hhaIzSS8//gQEAa/XPKELpVhL4io0jwitfj7gPpRQqEik21Awq1WjRotil+4pD6Gapujuzl6sbr4iRztqO29/LYByjj9ZdrOXcWLGuUz9EKX5I82X3STfmj7j0Qf/acyZW8jLoOI0dCCIc08hvQmzIEh1qA+H+nSJaFIr29W1NxTxuAD8qgUwui9uTKq87w6/+NNLcfO9T1hm+SElgRMBzXvpSHcAzOEdvRFgcJieGy18iL9SXr6lIWJBgjfBk7mF6K21AZJI3B6CVgX9Yl6kYQeDDDEGJ2RvxcWpM9ECKqZi6/iaemcXo5zmO2vNKqq7YpoE2DQFIWZWjS+XdxAiJ6/FyuNKaZ6CNQ7qHZ4y18l6hkqiy8mN2OC/ocwVTPwaPVZpYmK0n4Z0r7qkVCMBFos55agY5me9uVusc3k1hNbuAB0E533z9kG1TnhtLdl52AoS6ImYHI7nGEjSXVJmXFR1sx4mWosUD+7VV9dJFSBRJ2wkxtDHqBnnAei/otbWu0Urb8UftdlKJwq/fdsW7PZ4So8AoxkkyHUlVfiEjjUKMfwNziiufCFZcQnwyIC1OlwYKPKz9+ccMlkACZuavtreyDhifr0m8aFfitVrGOTeEaguqSEuBmIhRHK6k2FFedyBqUvuWAgYBETuygNwlJxhFGk6FZxdmHbxpQiC87COrz9Ouodf5qWk7tJ
 0fud1fhL
 KPAg5lpmu7rvgOpCT/vxT+GCF/H4BMIbUbvsDjnZ8EV9LhF5er/7qHIKpCQ9piHJgCo4HFcTijwwTT8ovYl0zgt2/TuorK3rwGsYUQJ8iVzIwvaPh1dAiXTGEyaQS1ATp5aJ+TparK7st/nXCoHNcufv6HSWmtxnt4cNjQL5rQ6JbszBv4wgDk7MoAI4RTudleUHG/ozyy1oT42t6mb5j2sOvzInJJp2f94vCR2Zqu2nClu90VVunZHBQ1tHRIZYw3I+b7IAWhgMw1tft75V+D5zuraSjLPrcQ7DM/pfWQV+T268oL01VqQjdr6dOcLCYX1vUWFxiLlUaabRuGmKvuBdnzZ0RvObjpuhF70+k6dIUGUBj3JjJD79Lrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:15PM -0500, Tal Zussman wrote:
> However, this adds spurious minor faults on shmem and hugetlb.

"Minor faults" reads as UFFDIO_REGISTER_MODE_MINOR in a uffd changelog.
Maybe "write faults"?

The RWP side keeps its behaviour: vm_page_prot does not depend on RWP,
so resolving with change_protection() gives the same PTEs as the
per-entry code did.

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

