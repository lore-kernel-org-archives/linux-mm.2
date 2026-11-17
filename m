Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89980606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=iqUH4Ca+
Received: by kanga.kvack.org (Postfix)
	id 6B3F86B05C1; Tue, 17 Nov 2026 03:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BAD6B05C2; Tue, 17 Nov 2026 03:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1EE6B05C3; Tue, 17 Nov 2026 03:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEC46B05C1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:42:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6E74C0378
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:42:25 +0000 (UTC)
X-FDA: 85443969450.30.BA47F71
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id C8FB220006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:42:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iqUH4Ca+;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904943;
	b=4xwugfizUxE0vps+PWGB5K/MWCqFUxC7EoKjuzaT3f38RzDEu8BPcfg+XcoBodOwLVctIL
	QXx5S2Ob8prolT6PPBaJFx6tn2ji/ABfblcbOpYLPR52g/ALUzxCV0vIaJQsMRwYW/XUv5
	V0oJqDT+Zb0j0LqwsK7Ud3D5hX5eCpY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iqUH4Ca+;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beHv4RWKzAGXqCj9AQIheRdqq9/SqD5ToQS6bWhTNyw=;
	b=1lmwn5zSy/icKDrCGvD5xRq9pV74bNTqt96e/rcEM3xs6Amv7h4v3839UdLOoUOhyuXIJ1
	ktzp2KtdO8GpdPDoF1457Hyx/t3JuUM41jgtaTort3gsKCBb/eSd3Y2zgCGg1nsjwg6FDZ
	UGCb87ETQW5ZFXW1IAUUZa814/btlVw=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5365f9a04c5so71790691cf.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794904943; x=1795509743; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=beHv4RWKzAGXqCj9AQIheRdqq9/SqD5ToQS6bWhTNyw=;
        b=iqUH4Ca+mybvRakoGLRSnsQLB7mPZ2Xv95uE09aTlf5rzZwogD15ZevjMRnriykt72
         MBNFqVF/kGtCbZR1VB7/KMoAKWrGlIVF0oI7qwuk3CPpn2axP7OWovVcj/EYL5V9mgHJ
         j8ikFRkWBghNmCoYjx0ZqHkdBiUcdBG2l6kYUMJwni0WQOswT+1eR+hk/GCfw9cMovNL
         nsFATwtZd5YkKGMxBxR+rQXbHTjt6u5ZLw1gXzaHUjwWOaX3bFB+4WET43SHsl0O7mmU
         gyAJ+myv7OTm9ZdIR7GgmSIDImqwdIoR7fqk0SyzfbJyEg0J/GnyyE6L4zP+EdEALKqy
         UJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904943; x=1795509743;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=beHv4RWKzAGXqCj9AQIheRdqq9/SqD5ToQS6bWhTNyw=;
        b=p3Wso82T7bjOgh/TsO9hiII/DGhB+iI1nxjM38p294ObWl1lpUjRlXaoH2F3cX9gMM
         zXEi2mDWsIW0L16Djsud0n88BGhgwPAC4nLMfUnwr4XOUInS//qngtXBsQhNrM/OEtFR
         MD6yDs/HRwiJp8535xFXep/gx3dSMD/2DHBfreRao5jdg0hueCZQeFjT6DOJ5EezK3mH
         V9dviFFj7879xrqs9wcdo1/MLKwSWnJrsYaPjSdDlzDSncobTQlnznfWj8qf0LxuC3Yl
         bPzAXxzLl5DCy2n2vfJNIIc+6yZ8H5n7s56o1LKCEk6HE//ujZ8SQn90l4DA5XE62I7T
         STXA==
X-Forwarded-Encrypted: i=1; AL+hErHekXcYUhd1d6AkXySi8FQi1vqGg4Z4m4INXolFbQFl23ALEUPxdKAXNJa/5FQIpotMltf6OdMoXg==@kvack.org
X-Gm-Message-State: APuU4Z8ey2Yjoafj5PPza4Df/c1n/fN5WnkA1b7IXFhVzMMXDC2g2Zfw
	hND7LcVL4r1bIfSqbKx93uFXJIlI3N/VmVaZXPEFVf1xprrxT/pfUjcg1yIS4p1yfPM=
X-Gm-Gg: AYBFou0z6hFP+falIQgEx89g2/gW6Ujg1tomMkQEjWdTgtc29JmDEHdl3Pd8hGgTrNu
	pKpGjlW64Kl82cD18DmjeiV13CcPKyTdiLVZk2pcWKhX7vjw1f8oWPJYQrpjg+SJ5mSS5WBwCsU
	hLvn7gAhVnxVhtVzTAScMVRWRvRTxqosHHp5dGFad3tdo0AH+L0LwW1BWhe7NpjRTL+zCdeepYs
	F+cQgdKds08INEHxy4oTmVLt7+nFsp0bRXzw95MhxyVf+2sICHQjZlTNzNxfSeyLEsGLpmVN5og
	muVQgXgfW/PPw/rv5vUlzP2Xrms5mP2R8KvK9PiaH3CFmxi+tkxS4GoTIoBFSSCTY6vsQFMbPrH
	3jPBwQX6WWzfcbHrWb6Rbl/o9lkfcbOQGtFGzSjckou8dSOlvT/vwzQzCqXrKPZnsLbkQ00CHX9
	8S5bgE2/XI7kTYqYTouJBFUOadHJJMG/BX7gRD3TH27tXZ+DNEVRU3aBQFKC7lYKSB2z9sXkapE
	klobpqjEqHwNw94NDzCDq8mz9h/qL+mBw9N499k4yjZhVGVtcXfSzdlzDENynryjcFV6INq5ua+
	uslEKqMd5M60fCSeDwBWihhL2e6kxZNrs9Rl30dXNivboDkEUoDwp9Oz0D7051rhQN70uRX3aSf
	asafUiCQ23HkaX8iiwsqynBHyXDXY
X-Received: by 2002:a05:622a:758e:b0:55c:5ebd:8823 with SMTP id d75a77b69052e-55c5ebd936dmr138487931cf.66.1794904942797;
        Tue, 17 Nov 2026 00:42:22 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d37daf422sm44268211cf.15.2026.11.17.00.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:42:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 06/15] mm/hugetlb: fix mremap() racing with page
 migration
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
 Chris Mason <mason@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org>
Date: Tue, 17 Nov 2026 03:42:20 -0500
Message-Id: <179490494079.482102.4618915344813254218.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: C8FB220006
X-Stat-Signature: zzuphu3ssxpcauhqxop4rmtmmduotw8y
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794904943-54995
X-HE-Meta: U2FsdGVkX1+i+E0ANHaG2M+VFJjzy5mfZKjY+GK8+i6s+SmNXn2727UwyWEsF4FBVBwGcP4r0ElZk32nps6YkqGxC8O9KtzjluFnQfDsth7rh8yhkZFRXXF+XSFeVDWzT3782/CpVcBFAibIStPf1qJdPpSoS1qSeN1Nqnut1u/X/pC2Hkzkv2SmM8MupE+0pyyK6OoGnf+g6+rZ6vhm5/iu4H4/KknwEqttG/5YOGxLOLhqZhu476/DUKUqDp14CSWAYOhuXeJU3K68DHWbmRK4DFOmPzz8552Qx04aDA020MrtNmXJDdelACM8h9xo+xZGqT4GeEk01F99XsKe9hgJlNi3UJXzCTJvqDvRrmvY9ynpTKx/+Oa7t0xU4SH8XfpHBAn5FHOhfzmV7f5CX23LxnSlUU6VOTL4fpYd5NkeJnUBcRtMYNb0yrMvzp35hb5n7U5jz4EdByw6wkoFkQhuwSlhoudKjEO1y77rTgeMCLM6Vc59bNhvEhX0J0v/xMWNgCot9Ktwdw+Td0ZreNW978lW5qsr+mLXXxNEGrYy2RqdCXON+ntCjGxfXAueEKqR8PA4VJKnM5jBiY5/EPGIvTNxUQF6CFJi/EWpfGn520iL6axSn0kvcGeeCjm3/qSF7T7BeyUQsFoVgtBBEEjIfT25MAwwyHLySnktBSp6pmch2YXzOmMwrUBOMtgajMzRnL01V+2ru9isLZd0R6vVtBVD2+wKWs7wdvgso/VAp6dIlMgMwwEDkGZ+5Euqnx64JEVsUsjdBOD+fIXMwDq2MQCZG+mgdw3Qvzs+9q5Uyvrg/7/m7LTVkXdG0C7KQw14VOFGGh6shDtn5RcltEuO67pmocCf6SNdkcZ7qhBsVnZPdISOq78chXCjc0c3lpdT1RuncC0Z3jH/wsOiDFJRVO7ua7lyZXLXfkGIB/e1tWYQyAH4UYCbP5lsGvj1cJcAX+TTQi2mZMtU2tN
 1OUbJYaM
 Wf5JIlkSg9mFV8hEbm4XRmh1usggKndat+EZt1KtcHlVBSqpGq2fLq87oc6sZahqFcGbbGfh0xEkTej4lDEtKo8dLEqigdCbu51FBiUhb2Pkv6mJHj6JnF+A6860SrpCbmxZnV3Akdtk9Yrd7o/HV1PXxYRIA1IT2Kg+qkaQ0vg8NpvlOu8a/Pb6EKdO5EhSbVnG5hW+yIhldPLqPvg7IDabB5NHvr0SUMyIN9iLCI7k83gMq2y0mPbTT2FdV0GGfPDqKxIIMoYOAdH4aT+UTaNahrAqusJYdth8V6BQMLh5i0SHTsz7hgvy2RMrpqgjj0LMMAI1p/uXGclw3fys28+xPd63gk/NFZtBgJAXFoTQ5bsDkSzy+LfZGfjInLF8w6Lsct+DXGfKOPQ3KSpxEy0why38pkORL6VE4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 19:29 +0100, David Hildenbrand (Arm) wrote:
> Migration of anon hugetlb folios walks the anon_vma, so the file's
> i_mmap_rwsem does not serialize it against move_hugetlb_page_tables().
> 
> There are various issues with that. Most importantly, move_huge_pte()
> releases both page table locks before the TLB is flushed. Migration can
> then find the destination entry and finish migration, reusing the old
> folio while the TLB still has entries cached.
> 
> Hold the anon_vma write lock across the move and the final TLB flush.
> This also prevents concurrent rmap walks from missing entries moved
> during rollback.
> 
> When we must allocate a destination page table, flush the TLB before
> dropping the anon_vma lock, then reacquire it after allocation.
> 
> Dropping the lock only works around lockdep: hugetlb folios are not
> reclaimed or migrated by allocation compaction, but their anon_vmas
> share the lock class used by ordinary anonymous memory. Having a
> separate lock class for hugetlb's anon_vma (like already done for
> i_mmap_rwsem via hugetlbfs_i_mmap_rwsem_key) requires more thought.
> 
> There is a concern that this can block page migration of anonymous
> folios quite a while ... which is not really different to what happens
> to page-cache folios today. If ever a problem, we can temporarily
> release the lock.
> 
> So let's keep it simple for now.
> 
> It is a shame that hugetlb has to implement everything core-mm implements
> in a different way that just screams for problems.
> 
> Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
> Cc: stable@kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


