Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E189606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=jFnvaZgE
Received: by kanga.kvack.org (Postfix)
	id 544126B00EF; Wed, 28 Oct 2026 21:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BB26B05B1; Wed, 28 Oct 2026 21:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430816B05B2; Wed, 28 Oct 2026 21:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC566B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:20:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A50A9A0181
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:20:33 +0000 (UTC)
X-FDA: 85373908746.18.DA75DE1
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD1B680006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:20:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jFnvaZgE;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793236831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWYN3MXkVQTFS4ykvP4ULAqrY98K2LtbRow9MYNtF9g=;
	b=6oN6NxZpwsYD3r63m7gTo3leyj1x9naDDND2IePZZYDM+KmxFCkRqAcg3AHgiagvvcaKLk
	0vw75I2fzbJO62JrKRYyYC+yQLV7s/v+EGRV9HklwcisceSq8Kt40MAL4GQYkxT8+nXRGz
	IN0GPZCXgFwUdeNj0LA2ihP8POvGzLY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jFnvaZgE;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793236831;
	b=x2u0YMVFKC3FMk/nthUwzn5tKbHOjKMNbgZWn/4768ybyATCx9QyuwdnLlBB4ZCJD3wSuu
	vgns5oVugRY6oW3GsiUdyO7fvtsv5tuVQCKox7ymNN71rWakKyLWprK8YiemZ1xQHte6Ga
	XrLVum3zKxBxpeIIltnHn56+PtduJDg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b4a13789b0so328115a12.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793236830; x=1793841630; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TWYN3MXkVQTFS4ykvP4ULAqrY98K2LtbRow9MYNtF9g=;
        b=jFnvaZgES5LgVszIzbAOAQTTLYATRX+ZJPwSYJK2dyAPGbyVLgLup+eI4Bw//yv7DK
         aJY2FypBKdbfWem2vaIcMpLRnTn06/nByeJ8Kz75xpvxyh1oPmzX4lkc6Rv5Zy+f5T44
         YgyC1+ysqmIPHUBONixgPE/Ne2M49quV+ags5pQM0NMPoKpANHnkpD/CKVD7+KF6mFX5
         9i57BK7SaF9M16zuYHuKC1wsttWlxk+W8xmb2vYUId2nW8iOlDuPBdFfbr9aC2UX5uM6
         PUYhw3TgKIj17b4WMTqTtZY6Vw5ggppwVizlCfIxLylCk0Q/+fwd1bHStD1noB+FlqZt
         yXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236830; x=1793841630;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TWYN3MXkVQTFS4ykvP4ULAqrY98K2LtbRow9MYNtF9g=;
        b=YFtxCKtCijRnXhkyZ1Oy05+/+7E+IQvqml1W7ODqZ62fWPrfbYu/KxVNXOhEv66aVt
         yLMeQ+X96kwmGxvL1z9nSiOHpJTtOf9uw3mnSI2jyobeAVwUUUfpWE1CJ62ab5NxDdj5
         BFmFshlYArqYi9VSl/g2IpgF8gEoUYaIZNnVX4iAGb0b0Rh5b5ktbvjZeSzpHUV0dZXv
         +3YnTderjuV9j6OtW0H6g+wnFz9DorQmvNRCLRwgqh6Wjtd2ZdSUfit/SglzUqIVblH5
         h78IgR+DjewzWQhhrY0OcZ1Qfu0Dz20VjPG/314UP3WdbgSAacPJ2dQ7o46mWuIDxFJK
         CXcg==
X-Forwarded-Encrypted: i=1; AKwUvBzu5eCXu1r24S5LBwurYgZUjyOQe82q7eFNj8CGgKAQWRQuJ8v0nmbAXqFjlooApRQaL2NLjqKYKQ==@kvack.org
X-Gm-Message-State: AFq9FYLzptkWs8yd7QwlNAZc9YZ/AVmwaV3Ls8exfC4G+06M1KEdslZJ
	K7CB/L/TIeAigx/cqR5M8DA4weYw96XpxXykzw8rGqusNiVK/l1kMiv8+fm4u+zC6i4=
X-Gm-Gg: AYBFou0OGHBTHRGqYzozZg3PJIr6AYPryMdZCfQgRuUbgHPKLWeuo1zuevrGMbufKoF
	3U7ieQLxufyF4zibphmdLJYS6CLyS7MiWKO8prCrAJ11sg/j8kmi1RT+54erBHQ8BhsFp99XYzI
	ck7iKQPblhBIsRFfIeLVkvFU6+ORNPPJwnYf0Ct+rGO54Md1R4Ywvghqq2rt4p91s6GR4pmD0e2
	vRiw7KOebY+uH0VAnYenOlhf+EcXY0Gy+iINx4pTwzWsggWEicxkybPTWCR2Z2yqrV59n4Ac19A
	SCZ6vtd0leC3j5dmP4BnbRljfJnyiYr2ob8EYSvE2V1a3RPKPIdcimPhxw9cKM28rthasKTv22E
	9fzg8r3FCMzg2s/qJ+5BhY1Mdcat+1A4YL7QdBCit/3ZQAJ977jgZcXdKcvTbvXW4mkrszLmeOt
	t+JObGC1LvsjCGVmfTWnrJ8CTCvZqHeEMUi+qFogfOUwIiJM1s77/oTJuc2MYfmZFCvNY7yYsF5
	/LBNjMvdhW+RQVXernd0VDzpIeWjDrULw8FEwqbHF6UELTkTFwiudqUbKs15UdActBTVyvEgZvi
	Zzdr4lUqE3BiCIo4z3Sk
X-Received: by 2002:a05:6402:c507:10b0:6b4:8d8e:c5c9 with SMTP id 4fb4d7f45d1cf-6b4b0b82678mr569270a12.4.1793236830233;
        Wed, 28 Oct 2026 18:20:30 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:72::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd649f69sm671275666b.43.2026.10.28.18.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:20:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 15/46] mm/khugepaged: always recheck the pmd in
 try_collapse_pte_mapped_thp()
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
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-15-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-15-6f74bec9a5bb@kernel.org>
Date: Wed, 28 Oct 2026 18:20:27 -0700
Message-Id: <179323682749.453251.17316394789253085295.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD1B680006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qhqexyb9frkbyifjj58fmjejsjbr1tkq
X-HE-Tag: 1793236831-838621
X-HE-Meta: U2FsdGVkX1+P4Ir3jqOnOr8EWwJTBUImbOXdoAuS1DleiEpcC79e29t/+o88coaZ3SlGAxrozqWRKzTdDQUjkE8S3X+c8ceL7N/HjWupOUzp+t1ILA1zpLCnyfbznuIspyI1/jbkIIoj0dq6m3Kr/SDePUnNlZ3ZRjgdb0E79R8+AgAEbhXGK6KFTiZ8o7JNNMcx4HPjXCZ0501UIqtjuRrTl3w9uNHnxABO5kg/w3V6nmIi064tCsucCarIssMXrSXCmYvTRt/BThK14iHeS6v1MduTx2aSSrHnxAjvRhi9qtslmZ3VCfy2/3VdsLzHqgsx7Yyk2NsLyu+9frAsIeuPYWBKyuPaQ2mY0Hd241D/d9NfnlH6dmWRhw87m/daBXjQwlQzr49gBcbujwiq+EhqmDC0uYB9vKzcnS74f4SUHjnFXim2EkvncvdxHPhfkwiq7kyJdqNA2/8xLNB3ojRk5jLRhUPJGvDmi3BtgxHWdaZ+ASJCTTLmdevzQrK4Eok2WtcdR8bhs1BrGs/9MmlfNbcb6F0VLhl/opDZUGY8My6pmcsIJnwoLqkWMIm1lKpiqgHh6cJFPKMDlQp+SaipIwjLKQMg3kR62nWqzfW3TVthoTj/njMfiayz79+sACbid2i0o0oD7LyEtVkj2bbdeOuh4+Xfid2DsFgBtNdAPMMaOjYU+AE9GzEuFkzZc3bsE93gfW1W+oSfEnQKiFBKihORdydLqOSXkNxuNm0fBYftyfhXtsN9a1jNVxqnNa7aDHDsGeONipysFKIwxEaV+V2CZeIGrLvMEDlIv0hKbBQJj0/rj1f+ZVaKyD0uTecV3iSSV+rOjNVquSxKAuofSCLFRZkqsHsSwjYdyhJ8rIhauisx8GyL7gXAjOO0440Qf5e5U8DG3FgH/HR8b4CpYlWw+Aw2C0u9JpACMyhdR0X1ulDnK7n49THAWxuQ78XdomFelcwQmexS+sd
 1A5pgLdS
 9z+g2PnZikqFy4IFiFhDt5KoT+UDw7sLKCmAPwEuPWp9OrqlubPhl6Rgi1Q5sFiHvZAsOuJ+p4JWnI+JVizaffUE2s1sct8orfzwVzITn4DHfU2NvpIJ1IMDUDSOX4D7cqSiIFd1vaj85nJorAAQjtDImEZpGuxX/kSjGmBB90mhxC5CrGhcz+b8FOm/tmASDO/x9IGBjK7mR13502vtU8NJmn/EsY2pIypiGcAKlhm00Gf1N+m7pzJxJz5zB8Z55MliDK41vPAf27FQOrxHxECJFgNGQi+c7rIWkNSb4yoDVtpH0uLxdJVqiikeALxpF9vk4UW5p3GKBSrp3i+hLqmWeTrd2q717Br7jOSaSqNhQ3H+GJ7W2Nxpx4s6vvG3G8XTKSh8pMyqccWrdvT75s9NNcakp41lZgd5srUOejMUwzXN6QAdkgqcBEz3xsMRqSpziNGZiDZAduMqmeQslIb3Nlx574DB/TVZ4aDObEe9XgkCYsHdXQ+Tyw/VLSZP7S0zJy3Wr5gtZL4/TiDPVzbFUaT0ka2RqhJpYtNGGu8ar18Bx+6qc9BTxey1SRzMslTY2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> try_collapse_pte_mapped_thp() drops the PTE lock after it has cleared the
> page table, and takes the PMD lock and the PTE lock to remove it.
> 
> In between, MADV_DONTNEED with CONFIG_PT_RECLAIM can reclaim the
> page table. The pmd_same() check is supposed to handle this, but it is
> only done with CONFIG_SPLIT_PTE_PTLOCKS.
> 
> Fix it by performing the check unconditionally.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: adjust description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

