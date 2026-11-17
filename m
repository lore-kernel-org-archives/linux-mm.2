Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7059D606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=mA67EHGD
Received: by kanga.kvack.org (Postfix)
	id 8C84F6B05B3; Tue, 17 Nov 2026 03:14:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8787A6B05B8; Tue, 17 Nov 2026 03:14:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740F26B05B9; Tue, 17 Nov 2026 03:14:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46DA56B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:14:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C522140359
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:14:13 +0000 (UTC)
X-FDA: 85443898386.01.9A88896
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id D0F2E180004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:14:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mA67EHGD;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794903252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpQH2XklQvxbA0SCPjoqZpnVJxorf9+kCLsX6Cm+jf4=;
	b=2tecJ5pMlyLSBfUoL/mCxXF3I5Ith7mbfoUzG/Tl/4Cnbi4TuThoKwyDbMtmr4YAqVErFe
	OM0YANKa2wnZQ2EYRoHyiNgLQVt+NscfiQNV8TxkiU+oGb4GFmfIVOgAQYYsCahjn73/Cr
	/ik++jRs6hHrKCom3BwWtOUFpo+vJ0Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794903252;
	b=8gyqNjYRIJCEVd6puQwbkXNPBg7MaOun+Yr0avXO7OiFt41s3edvfunNu9F99G+oN65MdL
	pgJBOYRQZRI5mySOhvt7tpAOiCcIC+qAmedqnFQpWGGIiO2rSJaS3sruN1HpMdXW8bnMK2
	uBUr3lj7ag2R6y8Is9nwHg40BedGaKs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mA67EHGD;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-94960131b30so293299585a.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794903251; x=1795508051; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fpQH2XklQvxbA0SCPjoqZpnVJxorf9+kCLsX6Cm+jf4=;
        b=mA67EHGDCZwUZzitwuK6jpbJM1srTfoRsucW6Xll7xI4BObF9rbyD3tZn0Ua2kxvvz
         DMYMipMRJaZVFBZI1cc/B0izul8i6KQTxbgzJ4VRuPo7n405QefN6Uvn9Pj/LsrpnqD1
         G+KoSUeRjm4BlBUHJ1yH3FM1NvZRzUGq9PfFdaX5twFg4urD9ocnG/Ix4KP4eq5rNvDZ
         fgvikYzsseumtWCpXGCzEGLKijmDijxOflPt96QR2GljOMEB4T5tmZWwI8WmEf4fF3l0
         jFgvTeEkiKhwxOOJpoWgB9ndJavgkhhzDCpLDBbgGhJKeKj8V5SIzb5XyzA2bdthR8b3
         IErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903251; x=1795508051;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fpQH2XklQvxbA0SCPjoqZpnVJxorf9+kCLsX6Cm+jf4=;
        b=iYSsMqro4mqznhDID2sX2IufkBOORJPIoxuIpNeZVcjcGtybhZSSSPiMQVgQtPBXYT
         i82DwYtzEPvMERO9NyHUobJQM03OV3+edjIgOETfR/ULgXbA+3X4jVSViUVsT3Q8cJq3
         pxBDVpEYH/Qjix5VBrot6l8LTM/BwBdZouKk2A8T+Trx3nwS+Dzm8H6aX+0KhBs2c1oz
         C/XuLmJDKq9scFIK6c8HbHJZ20Fhrf6ec+ScoyzYNyD0JW8Y7hyLg3qeBxauiWZB8S8c
         l1n5bbGL93VNK/ES6qHtsF4lg/bmYsgYYbxETHBrSK8GCJDCWKxzX3cfe8Kyv26h0smp
         Cq0g==
X-Forwarded-Encrypted: i=1; AL+hErFiQa7ftlyzEjB+sEvBLxwMS5NZniQ5RGcdMHgM0dvj3GniHPO4loilcPWIsM411WAsezvHcgo7kg==@kvack.org
X-Gm-Message-State: APuU4Z9krYb41w24zd38Gcd7gFOqZSPubmzLkmIOVHXCHLNq+E70yC2W
	Vav8473g8VllLcaNbr4zIzu7kuc1+TI0NSSj49e7aA5LHfflfvRwM/E1cprPZ2VgTQY=
X-Gm-Gg: AYBFou0ZofmXbQpEns7kC9yAjJqMLdea30bOf2jT5BVQDwD/iQ+s8ifYpJ50fnpmfyq
	KalF9DEQ0ijatDxEz3c7c04FN1r/zTpNVMXk5xGxo2vfR1Xhg4hGFOlljE7SDnetdr3exo032TQ
	N6X9VPNwMjo3HtxRsy/+UlA88GDIpVkngwptIrba+tDiOB3S1ImRyoQt+DwcvTDzuXNnDNbikSc
	IJdJLETXzZXCxYKwNwHOzCQ/WQFLyOgEeNTbd7mlvXw9o7tmMEEy8U5GFsHRj0HLCVRzT3Y/5dp
	lAdG8Ges00iH2rodQRfiaf+YA8l8u9/drmEUrfOnTDD0S9YJBkz8DFpFgnFs0KAS28+UrRVc0ei
	MfyJGjQJPo5s/+lrtzKp4uvQ1r+RUK7+3doqp+drif628ryXDsCWYO3BpJtbtNhGEdyyYysKJmj
	hdflYOn7M8soTkMk7HN+buoJe2dZr5o7/sy1Y8Z04qIsH185AVFkTAgqwPVpkTF7SZxW1Wl0glF
	KpF3OM8OhPbCiTJEV0ehukNXlUrrAJiwYEuiiNPR25YzcfAfjgmdRad4W5ZEUcl9Io3egbloXKP
	QUviKB31lehPXoXDWf225IpDROb5//a+cfh0SDskl0Sb2WMx4ldL30Zaf7w40FKy96c00uoN8oo
	qH5ERmvc=
X-Received: by 2002:a05:620a:2a06:b0:93e:b0c3:388d with SMTP id af79cd13be357-9494b9432demr2192163085a.11.1794903250936;
        Tue, 17 Nov 2026 00:14:10 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c5fd154sm1021436485a.2.2026.11.17.00.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:14:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/15] mm/hugetlb: account temporary folios
 separately
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, stable@kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
Date: Tue, 17 Nov 2026 03:14:09 -0500
Message-Id: <179490324902.482102.8381563244741940633.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: q1pn7hfp85dim5kmwuyxsm8acq7s35gp
X-Rspam-User: 
X-Rspamd-Queue-Id: D0F2E180004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794903251-60625
X-HE-Meta: U2FsdGVkX181nlICccX8M+qQxBETFqcxF6lFAtNbGN5Gm9wioAYwyoE6h8bhaBJVG6zYR3RlfcJjhru6n5CWwLEc4em30L3//b4YDI94t71eGSh1gtKnRFDB5tHWmDq2Y2OLIbrAPp9C5b+/HP73jurgyxtyg090IGfg7OxzpNZttOiapptH1/qGQQoPh6FyDmXFAhwIL3JwZBrFFTxHhwiX1OCnAXGdWWw4Gh1eppTIYEZr6WDk0T+hIUiQhh5A/vlJzXPD0WXA25/Y1xc0So2WPLPgMaqcASN59P68s/16xoo/8zpSZcpoHbXH5wP8h095YfMFN7FVLBQOYzFArvxlLrobj7TOP20JfBBnNddXssn3sOxR5XH5knwSVXR4EqN3GW38pC7Kl8IkMGxaUosrG8GeEIH2FBzvzYawyH4beCEUy1HYVH9MbS51Rh11tL4mptYnpBbzzXnunLgdCm+tGYhNEBuJ8hQOkOlQC0Y3f2cnqxmDdeb8GQP7a3q6zj+/6BvvU/tWFpOHdMb9UCDX43q1YX98LSJOMVXer+vGNpuaUIh5u0hZvq0veJWD/+AuVtiLvx0DBns0giYy5fnuRqkHt/cbIwsFqqVfpFF7e4+PrHFiiji+Kymsrva8VQXQzXfyJ/tSvPt6ZQ+7wY/YHpTI1arH6vIiJ5eIHLzEAvHQeu3tkiiD4ub7QkJZx5bZ3pZErpLPgMrEQTCw2ntNl9SrRW7HtPVs+HDVYIIY8F7rmhLnWN93Sdl1lwyEaot8nRPk3udfcfpNLHJhK/4jH3lwigsYv0F/cGRemeI8ItIMxCa8uRmGEFbOeu6ePEFsEpAcGJIotEjcUrtWFOgrPNLOr1tN+ReMty229KfybK11L60CdMt2s/0XQSWmTCE7032sEYA7Bw+DLh4UMrpyjjFhuNzEvt8jnQi28OA6x8vsFPi8Gx1ntNDtjEKfspjqxYagEpqjgczAS4F
 k9/U91cG
 fm3HpYjBMWHuqj6qLYZqAZrNI6V+2yLr1FpvD9RxifpMVFXkBADeUbt8oqKclIlPhBMpvzoVDgpdtoLZF8ak+WmAlAFqRgRtBtKxHITWydB8Te68DvUPkmstR5b5MMrfW/EgdZxoQFm0y0DCuPKb3PXXHZmtjF76djeRWPHFxuqCsqV+lkxS8/hw4SxMF4PHOqHmo+HzKevXVksLXggF38AMupCwoezDn0wqRFEjq/bPz27DdQWNu1FWxdLocRou5DkSJZ5E8cWB9lMFpeT1kIrjyREv0lYbwXsOrHY9U5JukUWg91k/nCZzmTukI/te2N+DCumX538EWbCn9rgusEN38KPmKJ0+N4V+Z2dhiPtSOVsl+i9VF27F35hCumX5HKB4CmMOcxqypWkdECHjDf5aQfVOHQqqD2xWOiAGJ1NrDyOxLtMYCGSdM9WJwTzAYbvoP1yiD/+zrl/gqvvXtXE5zPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 19:29 +0100, David Hildenbrand (Arm) wrote:
> Hugetlb migration might have to allocate a temporary folio through
> alloc_migrate_hugetlb_folio(). Such folios are currently accounted in
> "nr_huge_pages" but not in "surplus_huge_pages". persistent_huge_pages()
> can mistake them as persistent huge pages, as it merely calculates the
> difference.
> 
> If set_max_huge_pages() shrinks the pool at the wrong time, it will turn
> hugetlb folios into surplus folios until persistent_huge_pages() returns
> the desired number.
> 
> After the migration (successful or unsuccessful) either the new (temporary)
> folio or the old folio gets freed: this will reduce "nr_huge_pages" but
> not "surplus_huge_pages", to undo what was done when allocating a
> temporary folio.
> 
> This can result in having more surplus folios than actually allocated
> folios:
> 
>   HugePages_Total:       0
>   HugePages_Surp:        1
> 
> From then on persistent_huge_pages() returns garbage.
> 
> To fix it, add internal temporary counters and subtract them when
> calculating persistent pool sizes. Update persistent_huge_pages() and add
> persistent_huge_pages_node() to make the code easier to read.
> 
> Count migration targets and rejected surplus allocations as temporary.
> Transfer the per-node temporary count along with the temporary flag on
> migration, such that folio freeing will always do the right thing.
> 
> Take care of calling account_new_hugetlb_folio() only after setting the
> folios to be temporary.
> 
> For now, keep temporary folios in nr_huge_pages, so HugePages_Total and
> Hugetlb continue to include them and overcommit accounting remains
> unchanged. The new temporary counters are internal for now and are not
> exported to userspace.
> 
> Fixes: ab5ac90aecf5 ("mm, hugetlb: do not rely on overcommit limit during migration")
> Cc: stable@kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

My only commentary on this set is that "Surplus" is a horribly confusing
name :|

I was able to replicate Patch 4 and 5 bugs together pretty trivially
with migrations, leaving the surplus counters out of sync.

Nice to see these accounting bugs finally fixed, we've seen them in
production for far too long without an obvious resolution.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


