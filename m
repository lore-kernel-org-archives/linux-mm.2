Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3F960A262B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p02NDSmT
Received: by kanga.kvack.org (Postfix)
	id 2A7F76B062C; Wed, 21 Oct 2026 02:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257F26B062E; Wed, 21 Oct 2026 02:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148B26B062F; Wed, 21 Oct 2026 02:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E02756B062C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:08:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4141D40482
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:08:08 +0000 (UTC)
X-FDA: 85345603056.28.047661A
Received: from mta1.migadu.com (out-116.mta1.migadu.com [95.215.58.116])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED1ED140005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:08:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p02NDSmT;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562886;
	b=lk1n7MYg2gbGI9hIqAFlgdmQhVh1/dbqxL6L1LkTZB+dEIzrOh1qyIKt2o9sYjlpQ706c0
	RnS61Jt6VZIpac3FgExcSsvqiMlhTxjW+QyGj+v5MvtEn5pmH2gx1bH5BgJnOMQWD/fFfH
	y1xMy8sHp8zoEyd1yTIsf5J5yIYelUQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p02NDSmT;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYe3wOkYMWAT9nEkJmHND9GUlXX8tkyrEnTbfn+hGAE=;
	b=gWNgLA1u0LCMKgstTd1lwSAWjKpvWrxock49zvIbI9V+qdWdAhl+p2tVb/+BGUCnum2Nw1
	QwRidkaYGqu2g+6A3Hn6UBecPfoSmvPDELwbbvletPg/1eEipIWSuyTxeQGhk3EMkTowx0
	JOxL7BAOf1SKEoIiLAsy2bPue/PU18Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4KIURn7WEb1ayotO22ZrkJ9wcqdsX7N260OoXXlEYTw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792562884; v=1; x=1793167684;
 b=p02NDSmTaSCB8KSHun2b3TBjbf1NxzTB/b6rDos/XyDiLhiG+2lxVTaZ4aTR24rWJ9/gY/mw
 cOxsxKQ8l4CCJ668HxHAkwzAjhfXpzA02MknKMDcP6EqNdBo6cYSi0IeK3sur8sTHobIbATp94K
 8nj/4oIDDrwoxMYcccNwBXQE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da1eddc643cb8bda;
	Wed, 21 Oct 2026 06:08:03 +0000
X-Mizu-Trace-ID: da1eddc643cb8bda
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de,
	maddy@linux.ibm.com,
	corbet@lwn.net,
	muchun.song@linux.dev,
	lance.yang@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	qi.zheng@linux.dev,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo()
Date: Wed, 21 Oct 2026 14:07:56 +0800
Message-ID: <20261021060756.4599-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261019090830.1917657-4-songmuchun@bytedance.com>
References: <20261019090830.1917657-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ED1ED140005
X-Stat-Signature: 7mwed5g8kddhjrfqopx7jqprzkwxezcy
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792562885-941996
X-HE-Meta: U2FsdGVkX1/jkpYPoJ826KG6cDO66JAQmowbANkQUcm5PQqrQY3wMKU4VpZIcPnYG61EyyxTIfL7SNXUNzC42f7Un6hf0ZRAW/RpopmoxK68gXy1Sjs9nhMAWXzEiPFOCcrAtW94z9hSlwYKEBlDbHOcg6+qVm0ruto7btXl9N8Fwi3oHlCG1FG3rXIRFqUIZ89ERb2zjiiheRPEjIFPHVxcpKIsMJvTXXbUdIe9NDRC9NaSvzUo6ERRdQ6LYkiVTDMPxR8MLkjikmqro3ajp/m/Hz3zeHCrzofkm+SGi+Zvdwyx+L0sXXibN6ndXDl/kpj4cdrpvrpudJ68KMolO8Se6/T5hA5zgxJSDvPhN7GWdfvoM8GTzu98RBibrC3933VxRHT1PQO4fePR6LJHb1V9ZTf0IHs0u71vg4cTvj9JHxIR/aKrL7R7RWT6Vi2MIFxjwx7vrLKwrAU8W1hcTETGBbBLCJ7S4Wr39TMbCrlJoD+wVpBZZzeHw/+jHN8wmc4AuLn9v9DpC1i7exkb1pEk723EiSUHq6g8CLFqeH0BudTaIYCxlmhfcbmYdmsjPqsWhmgU9Bq16MNBgKtXuriTDLVQjcS7gjNDadfXus3KOJrMKh6u09enxo4365nLufb/1Zbnl3A97JY/guQhURoX5C/zdAvmkN1xlaSLUnmquisFnG1NjMwJ2GtdWsw5DJzwp1Suf1GXS7t7LA+zv5WWuvv+VidVlD2LRY5Ndr73VXJAsimSG8t9p9X3F0hotd04SuSGPizz5h9e5OMALqVillB6y3hwTQzVhZElXS/C5Sj5OToPpOMA/n/FCNucXyc6WfM2agEL0prWU0jxNHOMx/gctcULYJ43RAsQZW8bJ2qzkVdfB/Mj6o0m+xAUsNGlCnBF24QM/C4EAxWKsEWg8FiRykcEelrdePkjUufuKwJlQDEGJbgvIkC0CeKq9IyRdJYKxr3/FsvKhbs
 jtsKjvAh
 f+rZ7pGD1zjZOk4MOEBgOLk/Q6jy0FkEvN8D2G+lEnSnTVdqQdG0Z6JOUly6fAumurek6IaM2lPgnGvbzMs3JIPh2QE1UAJgvbfbZXc69qeXgXs7ptIfLNenWj7LQ+REGMCq0JH8Asif3Des3hax/jR0XxliDLdZ3LLFEg1mLFLYSjF4YBHKl4rWDIVDoowmofAKjZPplqvU7WoLfdi7Fm+niisqEl0HLmRlDSdYfARfR8jhACo1Rqu8A4smnxAE+EuQSyoyRNyNltjhbQR1qg46aENPAnKtfBoPPxhzUHrQnwJWSln0BgF5MMjbKET6QuJxqzgKSMqcehQQBVi8bG4vkxAuz3ecvtExlTfXzR26o3xR7MnS4J1az7bjmS3/k3RUm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Oct 19, 2026 at 05:08:29PM +0800, Muchun Song wrote:
>Shared vmemmap tail pages are now mapped read-only during initial
>population, so already optimized HugeTLB bootmem folios no longer need a
>separate write-protection pass.
>
>Remove vmemmap_wrprotect_hvo() and skip these folios during boot-time
>optimization.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Yep, already read-only, so there's no need to write-protect them again.

LGTM, so 

Reviewed-by: Lance Yang <lance.yang@linux.dev>

