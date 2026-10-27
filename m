Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B57606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Waf3AfN4
Received: by kanga.kvack.org (Postfix)
	id 2E5A76B05B3; Mon, 26 Oct 2026 23:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296A46B05B4; Mon, 26 Oct 2026 23:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FCB6B05B5; Mon, 26 Oct 2026 23:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC6016B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:42:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D3CCA0969
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:42:55 +0000 (UTC)
X-FDA: 85367009910.27.5AD8CD0
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 86D6640003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:42:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Waf3AfN4;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793072573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AmNHif0hEkmbwEeTcZrwdr+/HB8qgSmoybIARXFX10=;
	b=xLr28gtkz4JvjPdSwqzqhpir7MomA9swJEIiLmJS4Nsue+UUTR85FnQDbrAmIhfgZOs9ge
	gc3Feg3zfI93zGHAeDvuQyAc3OKFckLH4ExFECxur+fyLlvG/uhbGEPLeVxaGXrZ4T/Ev4
	kIk1VvLKF6dh76HbATVpWb8DpKmywy4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Waf3AfN4;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793072573;
	b=LAal6AKXZMHnh6R/WO0w7SqkMMc8K6umzBnLxvvR32VKW9QZltKZI/KQmZcM04p9GZRPfM
	gzv1EL3PernNpZSWzh/Syxn7pdJm/fAuRDHgBi+vZ+mnEY39tnv5nHcjk8T4kSFKuGpFvX
	UOb3OsHVeVpUluEs74S2+tIcPUEuU1c=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c247f6687dcso556630066b.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793072572; x=1793677372; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3AmNHif0hEkmbwEeTcZrwdr+/HB8qgSmoybIARXFX10=;
        b=Waf3AfN4k4PwJjlA6AjBmuusokrAfwum8ILwrPDe0Z+JxE/3cRdk1r9u7PvNIb3TLk
         nTt756t5XZ8vqywBzY7qC4GL45P66ZFhul/O1ZsYbcDut9fKmobK9TgaPpv3/mm23lxQ
         QjyB2+ZMubxMQQPihuF0pqk47+AYkw7wvMwdBXpBJDbGihR9t8/pKM7DQokuQrKdlx/R
         9UcfXpMvstdyjpsM14vEoO74a0djYDITrN70ypBLPzWf6GDwwe16ofsgjv0+J/6VT209
         htRCoDkmb4kk/Q5fyo665gPQJ1nJzfSTZEqKuFvQXhwq/y6bT+vCirbuChfpgTGuD6LN
         muEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793072572; x=1793677372;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3AmNHif0hEkmbwEeTcZrwdr+/HB8qgSmoybIARXFX10=;
        b=RtcRj4RHeo0AEJ9/E1cgnl3Pd3lz/tbrtOMmmh4J6VeZoYaVJgxIUzzZTxSNjIKQe5
         U/RIKaQ13YCYM9EkWRNkUitBcDulu2sIwco8kZOnkd0Gn7Wv3oaVcJ89sTl6QMljRy5l
         3APBLcgSZA6aCCTjh+UkAdTZ9iehuKBkkl94H0eB0NPhLA36yBe+bYKq/RZ2jPhUhB2s
         F1EThpM+75twOXmKUXz9vaN0cPRTQ+UZk0ixCopE7tSHw68HRT1zxSl8FvJ1DdrezgYh
         eajCWvhrYMKkJRoMsLXzitmdI7iyNhlhbZqlVD2q1w4RIVIIQjYUD1L5edh/EvSZW+Wo
         wy8Q==
X-Forwarded-Encrypted: i=1; AKwUvBxzZN7dxtjhfoLdFNvh3ErxaFR0KMogmVASrBWFDFhPSWDHt1iujltdzZdA5T4hDmIYkDi+1X6Wnw==@kvack.org
X-Gm-Message-State: AFq9FYJZ0lmsDyEBqMb0AlYa+okjCzSVFqxmoGvBqKCtV6Nj3NHtiNZh
	stOt42dAyzXMaxZgkvs54JtqqDgPFq42eY5T4AoVJvuFwzP1WD5NqI/akVUEojEywRk=
X-Gm-Gg: AYBFou0jFhA0mvY5sTyWT2sMwnkH6ZJMUrnYeo+NYfqK2M/M2LWJx6vuzxH22WneKuO
	KPeIWFhyxYvYzcwRTJpWAsJVHfaP+euj5FEYKkCPAVpMp64lfqvLNDPyTwRBv0ejUrO40m/Nb1d
	BaQ+T9Tr2iiDxvAM9VChSk+fwogB+KfAVpJN10x/ggwru5ejNFl1+2tBfFSRsEXamzGrTZBr2M7
	guA/V2xv0AAd0JKyIAZhU4p5lIMiyySOJSxjue8v/uI3Recfi33qF2NsK5JJEkykD+rO3k8zrXy
	hpRDuEMi8HD2YeppNhFFyFRR+dJp+yFOkijSR7pHDmnh5MvM4D4JXqZy5zmN4AADyP2F3CFlogf
	TTDg4czk+5lpE7OGlFSQcNyCOIhjQeMJ2RXFvhvBSvE7j0BMh0lTVLUYqF3bsYKQE6cBHpMewiO
	CMZmTbNvIrZwt+KnPaB6/mOen4ED+gfSL8QM2abdQARO4Cp3B/vfTo0NM5m1dOwLKI0jN9GysKi
	iO694ZhDj0mexsWtcEElE8b94ZlcP/BeBPJCiifLwkKRgejqEBDuUNTCOwhfk/34nNs
X-Received: by 2002:a17:907:96a4:b0:c42:102f:15d7 with SMTP id a640c23a62f3a-c46bdbf000fmr901757066b.10.1793072572116;
        Mon, 26 Oct 2026 20:42:52 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:4a::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd649997sm382056866b.42.2026.10.26.20.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:42:50 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 28/46] mm/mmu_notifier: set ->mm only after mmgrab()
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-28-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-28-6f74bec9a5bb@kernel.org>
Date: Mon, 26 Oct 2026 20:42:49 -0700
Message-Id: <179307256988.1171062.17835586018092384558.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86D6640003
X-Stat-Signature: 6b7tdk1ibpr9w3imypeho943knssmoig
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793072573-287356
X-HE-Meta: U2FsdGVkX1+PFeMZEI1p67ImhQhrJv66QtEaETlDs2bwSLnHnd3o34FA32HLBd+WRI+mNMEd6qs1CBaywNqlmsrshdoM/Xf0+ahQC1kqfpfiHm7SmeqkfmXLAIIu9xwxZs/P4py2JwopUJybuX0BppXuQ2F8ehcP8kk9NtOJdlfXGwn+R87Sba1zRvDlDPoHGhbftwuL8daPFEuPDc1ddeCZ/FljoI1cv+TYYM5rI4aIF1hsTalKimt0CqamPhLHwYtyvAwIA3zwpMEe/PCuXUx30O4LQFBMMSd/oShBVvxM6MMxQ2+mFBgqkTUGhQrtOfX9uW+8hrRPjDXrlZzU/UXMc4ZqBL/u7fb1hrlmvJMCSaYfsr9NSLLs590qwtSZtqYNl0MlXEOwIv2hXISEFgG3a4QhoApMQmR/4CQOcY+T7Q4+zySFUH2aMNNQmGyPHg305U14ez1wNbo3wBw3S2z6/OtXIiaKzpEHsJltwMTQQf5b+HcWN/OFp5mjDcWmVkfyrpAyKS8w8HG19ygfcfwUOqkkWUmzLegwVUC6p21FdDl62fiypvJqkUJOaye3UUo/VQy2bf0brxMnCkjda0Ri0APPj/PwzMCCmu2ctdNh/nLCOVd+Je0pDd1FwMozetVxYe0Cu16lstEns0SKYR8KjQydBvm48QxPkNyA4jMlJbE2TcG8tLrhpONcc404lUitYbV1OgX2v3pWPDm72V0ob918LpEVwDpBjNNnrPmtu8jKk/S+5D2Jpc4nA6ahDiJnBpo0uCa0qB5evVeg53ATxIEGQN750A+rAf9vnaGokF2q/s+kFBkLdmQJXkvmBjkek3wIAqjPo9Xx9Q/138GRqip3BJeVErxRdNh0SGdcDa7J7/9bdywME66l4kQILovn/NrVAsJBu40/IWsqEukKwb513KX27Hnq+bU+43cNvDID7aYF9XEc5OMtf5UfCTQjPsPmQwwGZUOsxcL
 fTafZjO4
 UFLoPwhSs/uEOuZ6OvEH/xKZt5Q9+wmaXAnAf35rrxHzXtoPqqjMdL1Tuq/jxKS5CYLcIKJwMm2RM85rmoftnTe1wUlTznS4I/gZ0ZVBXbVsjAfAIRmEXY+SVvunVjuVrDCjEMwJdQNR+jmY4QGCXMCT1hF/gAj3aWRxvJngKirrG6tgfFobOpGJ4ArfRdNhebwD/iP3nLdlh37fzdtEJTeQrgQkqx9WJYtl2INHgn+mkeeu+qXm8SuqtF8WX4SIqRzuqFbwsrHjnrv8Ro3obTneGzeS1Pufnjeaa0nEVVbewzfoFBUdnkr5xa6gapzo4j/ZxztZRYg2RL73ramMstzDXeILubxfOe2IaZgCFt+dRckuXU25Ow6+feXJcWbD+y+GcFNsytGkSBvPJ/YBQH1/yjGQNXvFPFm4KlHd84SUbazV3PzvM8KCu8eJgZEkXOVyLL4/uAGuf3vLYk3AZ94rO6n2oh5bwD59q+p3+uFyroDVK9zSyjs2NNMedjIhfUK3esc7Fsww93k0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Radeon uses a non-NULL notifier->mm to decide whether to call
> mmu_interval_notifier_remove() when freeing a buffer object.
> __mmu_interval_notifier_insert() sets ->mm before validating the range,
> so a wrapping userptr range can leave ->mm set after insertion fails.
> Cleanup then tries to remove an unregistered notifier for which no mm
> reference was acquired.
> 
> Set ->mm only after mmgrab(), once insertion can no longer fail. While
> we could fix radeon's code instead, setting ->mm on success only makes
> the code more robust.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 3506ff69c3ec ("drm/radeon: use mmu_interval_notifier_insert")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price <gourry@gourry.net>

