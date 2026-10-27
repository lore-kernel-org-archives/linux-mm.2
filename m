Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E3F960A2619
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkUpZ2aC
Received: by kanga.kvack.org (Postfix)
	id 5678D6B066F; Tue, 27 Oct 2026 05:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518016B0671; Tue, 27 Oct 2026 05:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407BA6B0672; Tue, 27 Oct 2026 05:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE0D6B066F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:46:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D578EA09E0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:46:05 +0000 (UTC)
X-FDA: 85367925090.29.8298587
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C89081C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:46:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkUpZ2aC;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+T9dXJtHkajTuMxj33xJNknQApvv9iNPJoMhnaDiDss=;
	b=hkl6zyMG+cmXlUj6cBSLt4eqOMjBGAGfF3j9vYxboKGHy+8xIvjg5bpeWujE2RXO6PJXMu
	9wxUNkqb3ez0QDbMeQNfXYAU4LD9sWzEwJdnmJWARGebLCVQxFC7bUeVRvpbHbMv1wYNKY
	Z3gVCuv4kzKLakmPlNpSOAcG3Qe7d5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094364;
	b=wts0g9gq5wveCCsc0sZeaShy4oB5erzSvM+HO9RI0lMbUPxcxDrSR+FKLxg5Sqknmj01re
	3BmOHqqjl1MAC7NhkbAGhw1/Vbacj+ILfRzlXLB87RPjYDfRuD4/IUw2mzmTxqCTmSzyLw
	o72tY8w7PBtsVmiYWfIEY0osclaxmIw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkUpZ2aC;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1151A444E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCB61F031F1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793094363;
	bh=+T9dXJtHkajTuMxj33xJNknQApvv9iNPJoMhnaDiDss=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jkUpZ2aCKBAeL1KLPaxmtw83wNwTccBRSeBIhfZc6M4YBj74AnSCzGu/Vj7kKPZMJ
	 xB2+0PDyXJXQVB1EOn1ayaYzAx2mrJaWD8WmhUUZNmpwRSsDxZjX9mgfrYsVSBHWd0
	 VseBgRTYSAXzURjIAt+wjLxG3BCNO4grdGuYE16SirgMNVffR5YFZcQVUOPmL2cUlx
	 JGQcAvHByekurCovG0OYBu6ebbnIlf5DPz9bP5GyDI5tAMKRdsvP6VsqDAdMHElQkR
	 7Ie+U1N8faxW6AVJ4aydtmjH1gM3ZCXqRxH7V6Fb/x36iXpasqD76VEf0+2FHLR0Yr
	 244BIDm1VbR8Q==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93ead211f14so79154685a.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:46:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwVpbcWZi5GsewFM2I9UbxBtm6dmFQmb7ThBLAVQqya4De1oF/Q5b7ZFKfWg0jHrAsCK0pPD0vlCg==@kvack.org
X-Gm-Message-State: AFq9FYLaOR4oemoLJu1zbvBgLrPesiw8pCxZWw7rIVYSd5/DmpV+9kCf
	kuiiTkFHC0X1ldK1wDCgPYUbboN7NttucNPf059MLnt3nXqM9MJNB4lIPMY9I9NaRO4JOEYtndl
	0ZgAsDVXZHpkiPLkQO5NhTp1bAD3PK60=
X-Received: by 2002:a05:620a:1793:b0:93f:1fa0:9f27 with SMTP id
 af79cd13be357-943f4ad5cb9mr379876485a.29.1793094361679; Tue, 27 Oct 2026
 02:46:01 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org> <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 27 Oct 2026 17:45:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xh2BXe_e+8oJS3ZbzoLi=7r7-+90SHPy1+OwcPNdGUxQ@mail.gmail.com>
X-Gm-Features: AclHuK_Q0tGAJYZBBe8Ofc91w4jrj3Ei9mVOmmElYzvOyxGV38djS-jM8bZnzBM
Message-ID: <CAGsJ_4xh2BXe_e+8oJS3ZbzoLi=7r7-+90SHPy1+OwcPNdGUxQ@mail.gmail.com>
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C89081C0004
X-Stat-Signature: asoht1kkap45tfmb8mu6iq6td5fdhinm
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793094363-761128
X-HE-Meta: U2FsdGVkX18gtbS3ynHIg8m5jAODjzmhre3cRDqnD56AE7o4oAfA7jbYszeMobgPQ2rcFqMA3xmHnsNrjhfr9w++/xivQRzu3IV2Q4v+qB6HLd+7eHfSFDgczRBfr2faD6D4GfzysbN46TT7GHXuNVrPX0TOKNVUY0pz5g0kVUw8YpEz9Xfi5D53josxQvZXDwUWvzTfGmxjFvhPSLq+acjYIeDFiJgq14f6RUGln8qi8DjEVuTJMm60HoXeXd9bYbOyph686IEiOBO/1fw/dAl6xgatGZPxQWAb0QuNaREWqNcQ5vWuDBmoybc6US9AQIJuK2cPB31tPSHtWDEmp1uG8nueNweDcdEh/EE2gNzAoaBR5WW9jtdw9eTr1zzZovf3LjPi8nQLR8hzrXZkT530O8buBzrRScgALSLA09I4PXpBIaSKuJ1GjIXH7rt23cs3rdylQwb7o+o3dJVg2u1LvHv8xhtxsULoFbIGUChqQFoqMHEeNiD/camnmWnttsmdOZtpLOx79n3VK/80AsD9SJNKaM8tvAC7BVF8OvK3DlBzdxTOzrf0fSceqHX5ItNcM01CRYpn1WvJjtQS6DLCVRO76UY/zK9c4wlk+cl+Kjb/xrNGrDm8B1SQs0MP1Ui5ysnXFEHI1pSCfwzpbZnoVR0RizsOn9bbLdeQ5A0jwwEr29ZItiwOjktWkOUBeitTnljoqKG/u9Cxkz0mrw5drFey36xsLuuFw4cq7VixxafbM43u33MkfZgffuV3bg2P/AU8cZs7UXCo2eypnq0jTnGBBtbxhq86r3wF8pDD1Dsjj7d3f/OfaCrM6YoYatwnNvNr1/gRXTNAleabKE8GsAb7bpS/5IAiAjdvqMuZZqA5+vH+y7RJvbOnLIJyHYHds75wccnlNZpGLgksgCIFSQcqleqhXti/IqkLhC2A8TCFhVvLWbqk4J8igCf1ioViI3rPd3i8rVwEl4F
 3OnX2tFa
 H5LIyxAQ2IQ05AAIViqd23ZbqyvVprlIaO1S936RWmfgtLlYCUWyUeUiDIZKWsHKtHn9zjjePtIc6VufD8aqcZiU53d+p5O/7Gv3PrJTHlD0QvO62QqD5x4J0ucUtSInxPQJWwWS98dsh+cyP9zY4RkOyb2dbKN7QR9/qvpYkDBS+0KkLyltCWlBNbdba4bC4N4oE1M23p+vZ50Vr9nIbemzmaQWBIvnnORhVQ9pXAcWaHpPrLzoKuvtYlMDT1SR3X2d/U8n/aGygEbQ5mSoy2ZHtBZRLvo4WvHgmNGRHD1RJGQjXQs/xwlfbIhisFpq5n+LqYkIN/z6uLSAlAV6LdyolIxEvetnlFnfQSWpaWV5wV60YUsf1zoieXGtCAv1QpTbLW0NVr1/rt39znlqoJoT7nb6cUCNHC8ZJTtEdDgAEVTGVc6gV6Kd3y5wtZGCF1RzsPtGrrM8WdEpPRyHXaKv7UoUeYsz9WmTbnSKOXLCNocg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:18=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> and newer heap mappings, causing later brk() requests to fail.
>
> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarl=
y
> cause inconsistencies.
>
> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> way we don't need to update individual mm fields in dup_mmap() and
> keep missing ones. Stop updating the 4 existing members (total_vm, data_v=
m,
> exec_vm, stack_vm), as that is now no longer required.
>
> Keep releasing the parent's mmap_lock in dup_mmap(), before
> userfaultfd completion, to avoid moving the userfaultfd handling into the
> caller. This should get cleaned up later.
>
> Move uprobe_start_dup_mmap() to preserve the lock ordering.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

