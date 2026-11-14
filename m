Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDE9606A33A
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=E0Ipn/Fx
Received: by kanga.kvack.org (Postfix)
	id C67F46B05B7; Sat, 14 Nov 2026 14:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FA96B05B8; Sat, 14 Nov 2026 14:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55586B05B9; Sat, 14 Nov 2026 14:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBE26B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FB001601EC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:53 +0000 (UTC)
X-FDA: 85434782706.18.A8CF8D9
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32BF3C000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="E0Ipn/Fx";
	spf=pass (imf22.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686211;
	b=MUzPVdLinFIswT6aRRSXWQJxuOMlPMRG5mR7Hn3lfDjArZMMjC/QjNGO9Mt+sdMysAMRTI
	EkDWYWSD7NAghpC1xA8bAcbAKGJ3IFLpa1VUPvmb6Hu44cYUc9GSK8v1s/kwat1y0iIwtz
	82XjUWTPIR1Tb9A7A97GtIICGp8oGzw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="E0Ipn/Fx";
	spf=pass (imf22.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
	b=DKoO8N+CcxwxvBl4r00NQlG8k0lWttVWj9S+0i4WWfPVeAVYEpvSn4PRon+izpZFDAZ9PE
	mrBBrmJu2dvvHvJMXds5wwhvcS4Yag/xcdaVQmisejVuMoopddpkNEL0gantlbKJIglQnf
	FHOXpQrSufmgzxsxwBJXZc/8Li5gk24=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b0e61a4decso2806751a91.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686210; x=1795291010; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=E0Ipn/Fxw4VNBxdHJPgTgXieuCz2YM6JQF2fdbv7EH1h1u3YguVuyeKj46EWbQJ/4W
         d0GPll0zaCtZ7UfuN9n3uzBBW+hvlm5cIH+yXZzNeRkRR1BxCORxjFMvYhVpZfWi8Ib0
         jgv1kzdVRQMUQ9LXaCh4tVMFkrsbsITijTiPE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686210; x=1795291010;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=vD3lZwj3cXqnmIagBJASBBoZW7NCy7AeuoOcRDA0zNCUa7IdpaTqEG23z3JYARwKbC
         tqER4cIZ/4o3li2SU/3CxdUEJtxMirk270Ha3Vsxwsl7pO1l/pfvQZzL6SzBPSCdNXNt
         hFYrnsH4bjTUMnY5hD8n1ysn/GCz+ObO9XPaipUvsypGUrEcCzQxKP+rQuu29/3iq6RD
         7NAa2PDWi2kXlvdcOHCtioaHBcGSl7skTzvgZxj7NrVyFjLUozunjjVZwbb4DIHKmOSo
         l57LMz+de9RpRlWXbgryKaOUFAuwrA3eAvEoGKOfLre15tPsMvwvIRGubFq8lyiyaOxD
         9tig==
X-Forwarded-Encrypted: i=1; AL+hErF9EDfnJirc0HZ0P+hXLUj7PWpYgM5LJVeH5oFapBPs0hUYhxxaW3bMov6jTc/JWh7nlZSoBbd2Kg==@kvack.org
X-Gm-Message-State: APuU4Z+aFTTEG6U8CPzVeZ6SwDoMXy2YB69k4t0PUt7+0JZ4yZYS0uyw
	mbKEUtek5FbCu/ZkLelkG6SHwpPKwhCP/zrI5cZUljieF2nhaoQf8Dz966lPEoiogxU=
X-Gm-Gg: AYBFou1Jz23gg4g4pUXGEZmZlCQsyWBRSn9e9kEU1tQ1FlP0kK2/nUazIzF23E4BMLZ
	P+qM1HhPEHpVNlB2KrRDcMxwwafFmggLFJxhVi479GP5MCtxvpZQJl2D0/Q9F8FpdJuRjb2CfsN
	KLKlIwVC9Jtasu/63XN0Dq3FX98pvkNCPfEABoi2PExcXXXvPBJFq9nLPiqIV02RE/L+5+rVjK3
	wJAJCKcPmdV3I8JYO9Tp+PJzwbvAaEOMsjvOdW5nnKuMBmKMoxeGlpSox89iRH7ITSpWrxsTpSk
	hZGu62BInKmHjlWfa5fAA3YQiP6NhjtW/GikstGmloyFEreLRDkyKcydzoZ00poxS3Ru+MQkc4k
	4Kpmusgp29xXPMmVpDCubLD4gVE7aQdg7X6xV5IPRz3Q+h6SylxdgdZ3LxY96lA0yQPLRr6WAkI
	4pE0bGnHCnh7eW1C/tQloyCCUoR6CwiAWu2xOP3zDRmwDr+sEgI0SNHTDEvxwfhNUODF+T6f4nh
	BBhCZG37SR/fRRh3ox7feaDhaHGBVUuOXRVURZAnVjXtTRoCwNEhpjrREHGsGlqZF1ZFMdyyR7Y
	cF1ET719kEkUGlUo5M9JiRd1UTQ7oKQEYwt9JaFSs8tZA1MlpsnXqj2BO+KBvcOb0IU14cPcmER
	AlEilLVsPVplHmWux6b2/z/q5edr9cAaaCkSsqQ45Wi2kdo1EphVhkWir5nJJ1jImTUuFLsnS5z
	qANouEFh800BZTefo07b7JjyO3EOIf547WlWbFsR6MryMzfSpISavRkRZL
X-Received: by 2002:a17:90b:48c9:b0:3b1:21d9:4c3d with SMTP id 98e67ed59e1d1-3b1b0cc8744mr6495500a91.39.1794686209991;
        Sat, 14 Nov 2026 11:56:49 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3b110c0sm4748452a91.3.2026.11.14.11.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:56:49 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:45 -0800
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
Subject: Re: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115645.be49d8916bb1b419@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 32BF3C000A
X-Stat-Signature: 3mkfdmos8fjrs4gkk8i8gj3i1cdt3rgk
X-Rspam-User: 
X-HE-Tag: 1794686211-839569
X-HE-Meta: U2FsdGVkX1/kAGCM8/PIufqKW11WkkODJ3XRkH3kQLsZj9LGnks6hcGXOXfGKHMM850RPyrRnLVQ0govIwtq5murUExAoCXxsEp79GpgbLDJnYAE4u90OKNPLGqRM33e6iF2+sPoBTJM1GDVnE2VgHtKwx0/cfXAt2KadWCR5MnDjfY9UlrpgxZaqTexk5IRpgClQJ+k32arJsZXfLF2lwuKD4tBB7377f8j8LL9+C009uZaS4rLx3UR2gsyrjRnYjaioC5TmQQuD4AF056Sx5dKBGEk3KILKtyG+Bs/lU2iUfCSogSjyLohB5fjNoPddJO9Wx2Ag/05tRtmVKQQ//MrgJdRog+5DSX1xZ48lMsj1w1DnwSBS2lLV8sY/CHftOHKsYWsVnJHaASYnExrqThG2NXMR/dZeei2Kg/Z26HImntnWDRq5Q1Rgi0DShpXz9DS9oTnW5YRZwz3fksMK9oyQip3DNZ2oGNQhlvFP+T8duvnRorysLzeJBF2rzuJjEUiUWgEaR7sJBEBtDTvMoElzGqxX49OGcwhiQe4ZQVefY1RAJR1k/K/IbLsWvcqeDvP5aOsyk1jr8XzoP0RLByU9pX60DoWd4toRCpe7UZVwCrnA9+M8vx04EWHlgbj2+ZkYQyhflmxBEJUXgeNt+yQClJGBvulzdJ000X86vXvU89wtFxPfHOO/fZag9WzQxCmu21KXDKmkERY8myJUmPxmJM6FzOxeAbigtCuj0gN0BbgNIN8Nfx1vg/u0MO5IQm9or8Afr1eaj4mHOq0Hqjvl0jBGYd6C3aY7sZ8ynOOrz0dKUNH236hXZ4GlLj6EXZjm39NBlBYs4zcRplmBmpp+Vqaap+YTl23hjGKOE+iQt2d9mdBq4E1gwA121F/7IPk1FhkvP97OFlAVWRoCxAXYHlbwAusQbBFdxdSdR7l08lHD/BDmlWKpY5gmDfdeBNhV/zCOUXa2cUYeho
 X9VqzFDg
 UT8kY9tXB2Upl8e3csJySRKRdwdzFSbqHYeTvbhSgxE7OChcTK0AeE8fkbc28rvj4Zhm/vjDCxUzmkRZgFYqM3vaLE0R5YjP1BTO/rhtsIABG7O4oO9v1XcwW3sGFFSLknF220FohB6Rf1cP1YTU8BqtYp6IGuS602ymMikUQqRieAhpmhuUb4A8sUpE0RyZpBZ+XajC9l3RyQmFg8XjfbQlO7xu9ffcEf9dmKxqTF/pjiFQ374qehMnGc4n0v/i4WHY7i7dvCE4O/7byycIp8FNy1sbWB/kJ8er5k5Hu9cpoV+CS28n4vdPb/oImGJVqMVzpXsDGCZ9Q1tLPmEiLQY5VSKqm7K/dRmZWyK0CMG0hirI5e7oBQTiHW4BPB1iQLjNJRFKkdE21FsZTEJZSUW+hMxb/kKm//XUsvJiYZlsWI3q+FsPuJ9AaAF4uX2LssIv4Oe9rdP/VqnTiOLoWdVuFnrQSiicwSxCqpL0w8eMn2CrGClIW62JcPcxkTmuKrAVzlxUHwflzo6CmT19+Bu29GJwvWWdKjujvr+f8CVKidFm+QtGXyzq2HblS2yKuQVeMOTMxaCLfj9K6zFTo2IuyvLJM1T0jcV+RSTLcLS5c3UtxewBZgG8G/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Chris Down <chris@chrisdown.name>

