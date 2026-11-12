Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0C16072A11
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cgDsWG0h
Received: by kanga.kvack.org (Postfix)
	id F0BF16B00EF; Thu, 12 Nov 2026 09:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC116B05B1; Thu, 12 Nov 2026 09:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D867D6B05B2; Thu, 12 Nov 2026 09:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0C956B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:19:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A6971402FC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:19:49 +0000 (UTC)
X-FDA: 85426675698.13.C63F5B3
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6576618000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:19:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cgDsWG0h;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uM02Fg1gjU3NBZSPcxHW5Rd4yGFYmOd1Ea0CS7gM/Ms=;
	b=JJmFf0eL8WKfiqW0Oi3JblUK2I35BerPYizVjnoVhwo+GTAFQ/uM8xc75ce7deDyirLz1M
	Io2LDcJ4ZIgUNrmTSauHJF+sRaiJSy1ZdXSDXgpT0mtk4scm50XwkQ0ofxRHbqo+Mg8bsC
	Nfp1N+I6/sVJlM+RT1dSuEvXXRk1oZQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493187;
	b=CuyeRwRRfaXwf+uM/f8xPtQJngKpPC7ReL6GXGkIK9UH4sV6PZN9sN4WP9Pbcmbj4fDqFT
	NGOkF9yE53MAQ0qyOKVFxewEFhieI8t73vtrxuuVELJeLhgV7ZCIGtrBrBJu0nAfyBokY3
	8ylsRQLZrahK3Lo1e9WLQQc2O0hMQHo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cgDsWG0h;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5c148d4dbfbso4113571e87.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794493186; x=1795097986; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uM02Fg1gjU3NBZSPcxHW5Rd4yGFYmOd1Ea0CS7gM/Ms=;
        b=cgDsWG0h+q1709up1c2PKQF6GeKYCGXiMMadK5IHhFGnhTciK6ZzQ+AaIDTe7sVFtJ
         U6IuryYc89Hp55AYyKN9YnVmWQCkUZdh7AcSmtUteox9sbPThX47sv5+BoeLvqR1cwcu
         FBNaVCNs0IuXWaGXgtAcazojujv1Kw0Z4vb3SbbR5CayrY3U0Kywa4HSpIESpPp++q3Y
         arYTCc5npDcV3uWqm9TDErG9X8fIIc5fi6vlMEe8q0dVKEQSKh9XEAiFblaxmxGUPjOH
         ZZIDN14wfPQDS7ThpBgu3jelAaveQA38YwxDrljpbpXO+p7zzA21c5SjYuuFjwUp9Nr+
         zQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794493186; x=1795097986;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uM02Fg1gjU3NBZSPcxHW5Rd4yGFYmOd1Ea0CS7gM/Ms=;
        b=BM1DHTnQ8oD9glBiT5Vz4CNvze7luKfkX9i32KFCR/3+YnoLhObCOgx90GwzrtCw10
         0tpZ9mJYHM+VG0rH03oqjE741HNrzeMgWgprYoMITJyxTPT2bX6HTMACKp9MfdXnCUR7
         N+cYRKP8+jlsL84qiYv7zgo7ZZTvPVBN7dobIlANDJCHAi3cxMRBSOE7pOf75rEaP7T2
         FALF/JMCzuBF9Y6baAAlFt7VIf0WTjNAtd/v4mz0Q72vfHXyDbB9h4OqrXPlGzc7dNmM
         FBbnE8PE7kdURjzVjl8cAkwuNryr/i7cACinT3ExjL/Owf5gleSR0f0hfFKqIFM1r+Yg
         l7kg==
X-Forwarded-Encrypted: i=1; AL+hErEqlr+zMjfnDV4QzHaBMqqH74gEq4Epbdivz7hqyUdPPAdWVP62xKa8llU+xDC6l/ddCH50+jc2Xg==@kvack.org
X-Gm-Message-State: APuU4Z90KJenRWVAM1O+1wWFZu3wlHy0oZZ7bYHQKCCmiEIr3FbNn/BW
	kqhi62vHeq0eCBAzMKvdF6PKZY/vKNjRvE9Od3xZloNiEVOgxQH8DqE2FfeB8gg6quayhgzbP0+
	hPtG7gRc=
X-Gm-Gg: AYBFou2IsA4BFnvCZMNs+UKUTb8qQT7stF8wkpO7XPsHkYSM8NAHH9sNVQyYvjDJbAV
	2Ujmc2PPbQQ1UNZpdymyJESSjGCS6PopwQauWyycDEFQOHTFBNgMQCCJ34ewOaS9Qb1Vmf2X7WD
	sFzAiOi5+pwQDV9r2oAwXX/btGzpv5M3OLKG8UPothFwgk/0LkHpF3Z083ULUbtIZbf0g/7pcMw
	mhmoBm9sMPTazSg4ariwvI4IxvDSpuBk14EjbshTc10p4vMoFNeoTl2q5l+Dmc3fdYzD0Mpy6uG
	Ms1KNZu99OPrhLkDjgfByYIP/2gS32QllwqS0o1gCKrAIn+zJQgq6z9nydke9ZMfdI0IpVbqyWk
	HXnDDTr0N1Xd5Xh+SLmUAPSQGwS5Jpq2w7IiuBQRcNFRyb5zMyEEIb0AyRGFtZ6GbZDzsf+uheF
	AYG/cJem9TBdY+N5cI/tJav1Oe5hFsDx6A+LcL4/7Ivytj347WmqqCkCmJwA8FBQ/f73AgI9xqW
	Hi94l0aX5WsPJ7YZtPO2zssrBzWfixpygVaD74tH6zw1OJ3wev4hu5wy4A40KbKyLguI+VIjEuy
	bfxmce4mGUz+Dgt65+7aUyLwge+R8uA2rQ5Bh/S0ofE=
X-Received: by 2002:a05:600c:8b31:b0:4a1:dadf:9876 with SMTP id 5b1f17b1804b1-4ba0938e3aamr97570525e9.23.1794492736131;
        Thu, 12 Nov 2026 06:12:16 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2776casm105702275e9.14.2026.11.12.06.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:12:15 -0800 (PST)
Date: Thu, 12 Nov 2026 15:12:15 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
	Balbir Singh <balbirs@nvidia.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>,
	Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avXJPw17fWvLtCO8@tiehlicka>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWmfXu39vtp0DM9@tiehlicka>
 <avWsG-zmuniUFio7@gremlin>
 <avW1s2wvz1PB0-Ln@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avW1s2wvz1PB0-Ln@tiehlicka>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6576618000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6uts7stsjnmrxtohxogbgdsikr4euk5f
X-Rspam-User: 
X-HE-Tag: 1794493187-967967
X-HE-Meta: U2FsdGVkX18lME4ZFP2z9uxEsWKwfLt/3OL73xaLWm0VSTsONyreAHD2iAHcrddJJC99jvbCWd+WUkoM8lksyt6s3/L+7qw4iK9mJRJGJTUO/jop3YvpjDOaZ7OivOyCXQd/rElyz89avUMOvdpuPtoH/+GuxPFRaIkJcFQletiRLkKjRBXdG06TaNUwI3bUuZyoH3Mm7QP9lfnhBpVa9PEuqwOUVqCeNuvHHwrHPIAgTD8H0yynhx4oJCriGVBPAifbp8JA0yuNbI/UzEFabyiHNyH0ni4PQr76KMjhb6GEWwz0QrQWLAkugqUuEJH7BH6pahfDxvIvXmaIaYCfmDiCJNA7PqrcrOJHCUOufJ1TMph4AyKscse1TnPYHVIRe3hHYeaTWRw2Tn9ofPbob4blVhSgmAw6iXfT6C5086oi15N4I+bWKda1lDtCoUU/e004rxG+GM3emWCyWtoFDsklTNMbS2n+gTsRpCNtgtI4iRHA7EsmBUtzKzIrOGU7/Brc6wxdSlgvFNQduqTqTzxL+qcBzIZDhGs1XBZdA44hctRhE2uQP+4bvdcGhRstFxnJz1rvYFL4A8uvORtMPRbfPfS1k6vLqI7QvlxE4BKL3rXy8Lec08wj4O2lh0I7yFxYMUPDOr86NQsr0B1ltsSsj+4N68coAzD1fpi1YcVWQcHEocf65wBiY8Wq6zDBiFvMG1ccpAX9yrwtCN4DoHqrGEk9pQKqI4t7MVaTpyGHyK2pE0rXeVv3J5vRjibrUXTI+igB02OPFJp1Jb5z5KN6Tdeb1m9jmZgdCVU5ZR4sXomHT6Ls905CjCPSK75gxJ1lq9AWnvkd44zi0iEHY2pc2q6tGpxwuJAB3gffgNoGBJ5xjoaNgVMRHA8M6WxtVU82DNqieIyAWMcdPrKJW7PZblidmNKnfhpKIE4oXVUTdy7cvWB7tXooDbOIIaBgXaLIumje27+P0UWZMSA
 OPqOa6VO
 T7ZQDO5nZF1gSRpNzH3EsGnvOajs3VBZW8hzE3aNd2YzHDCV2hH6MEWZI1oauNEv9EMnVYiapUYLTK0++gMcDJVbi90zKesEc3Mxg82v0Y0EKFrBMxUqXcJJqRi+haF5Oi9HYzstCAK+JFENeL8nBopGFUtg2ZIFGZll6nFQdPTwKl17Aoo/eYCdWhltGXu7K1koMRQTwR7eCHLQCCjny/RUFMZPEqswXQ7f19Dz2/a0Aw+OD/357QaZQ3b9WMFkAsQ6FZbDpIV6C8L9MvlhOCYzNyS/fLALGDJ0izQbniSEEUbBCnYloJnOgdGVeLb2LhRIfm9sw6BvR1TqlHX1i6QYdlVxknqiNj+hazLmmUplg1Hp1tmbkXKL6VkxQIaj6xTWWfdbZfxOVWtTR1j1UYQIxUqMYRHFy55uvfuocJpaACEak/TnL6pWlPGawpFGgXBfdYn6ydu6OhrW7OCFuQvSdCxFHMMreOY8hDQ6PFchjppTZ9ed8si/zfIc4GJYG606q0OPsqJSVHeZYwDzxuE50JrL1eYEniNQQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 12-11-26 13:48:53, Michal Hocko wrote:
> > This only matters for the OOM victim, hence reinstating MMF_OOM_VICTIM, which
> > made the patch _way_ smaller than the one proposed :)
> 
> Should we simply do that flushing unconditionally before setting MMF_OOM_VICTIM
> then?

Sorry, I was caught in calls and didn't get much time to think about
this.  I have only now found some time to look into that and to do the
above we would need to make tlb_batch_list_free visible and conditional.
Which is a bit of undertaking, not anything major but still kind of
ugly. So your solution seems better in the end.

Please clarify the changelog wording to be really about this and with
that
Acked-by: Michal Hocko <mnhocko@suse.com

Thanks!
-- 
Michal Hocko
SUSE Labs

