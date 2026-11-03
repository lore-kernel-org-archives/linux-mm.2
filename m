Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B3C606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y2iwApll
Received: by kanga.kvack.org (Postfix)
	id E88F26B05B2; Mon,  2 Nov 2026 22:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15316B05B9; Mon,  2 Nov 2026 22:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EDB6B05BC; Mon,  2 Nov 2026 22:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 932F26B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:08:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AF1E1C27B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:08:36 +0000 (UTC)
X-FDA: 85392325032.19.3461A49
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CB0540008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:08:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y2iwApll;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793675314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcMB+7TMi2bLazC/QSSJVb+dN6unmraBocObaaHDrh4=;
	b=JXBbK1zQmXDFOd0bkpl7MICwvkh1EfVugDg5TTDe4aS0A3L/wVHa57YlQKp9jsxAd36UKf
	Ds2z1GKpnPwdpPImFZ7mItyKMgJvVeEDUlObElOwcVWCejEwbUMQgezWUCWEmNl+cbgYgc
	7DqOySgr26p7RGYsIvf3mniwArZ9uzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793675314;
	b=HxMo+rnIb6jjM8BWltJQlzNiatZUSD/T8awESSprEfnGbVFAZ8KwHodUyEjohDjZncy6XG
	UNXm/CVxp0BrTshV7TcJCst5uqCy/qwpf4XWfeLFCnBS1SGSxzNz2IbVM8xlftfTVPbERo
	BZZiOv1/R1F/Gza1pywEDheo0kB08Qw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y2iwApll;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9TIi4e+jhWvSVLJqdtmuDmhXX3FHNuF+HLGG6Up3ljY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793675312; v=1; x=1794280112;
 b=Y2iwAplloUzu5bm58twpXtkXG9/CIrmyyFjmR4r0iZ7mcki0wVTD3/AcJHdq+jFn4PndzStX
 io6vtdlQDs6nSNxk8e+ryodh7MtiPa/Xh/QOKBFWs0SWrKpNhZ4OClnOc5QavHY8x0cvltw7H2d
 27+v3+F5MDZwhvhc2vc48Ozo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 59608abf10f0d8e0;
	Tue, 03 Nov 2026 03:08:32 +0000
X-Mizu-Trace-ID: 59608abf10f0d8e0
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	josef@toxicpanda.com,
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 32/47] mm/mremap: fix moving PUD leaves
Date: Tue,  3 Nov 2026 11:08:26 +0800
Message-ID: <20261103030826.79600-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-32-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-32-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a3ppc5m96bkt17fu8pib5kjok1q9pbyx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CB0540008
X-HE-Tag: 1793675314-992967
X-HE-Meta: U2FsdGVkX1/n5GIvlg1Vfnuiw89w9OBieZk0ywbGUnqnkdhUnI0x7wcRP80jv/t13Z2h+X98oi9hWuDL9xiKEiwtA80IiwgRuKFOh+5PPOuKizihrCx3QWh+h9x9EPfMaN+h0u+E+i5LOemrXUYKexNkfLgpn7e2dGkIl8a/OtABNVIaaz3snwr6tqeTqSh5r0BHalvYMWSGR2XJQPcOq15gqvGBSwqnnkVZvLZSH+tuH/1EgGGgutXpps0z6Jgy8jk2TcXbzv/Fcoa3HKIDFhN5Bq3UmshBlm1YfHNektw+cpEbVNe1XJSlkhUOAn8hBhbFHntldAa4Ld5X3cKyY4VUVjFR56BG970Y6K8xvWdFhYNPoSZk8dNFMihU335C86QaspYq5PUeVTt9apZqtNMgKHUdCLbrkRFSvxtn4RxxeP1Sat7sXInPbJSEpBlwbls21shjHkWgyZsg0156EA7LdZECYh4WVRBdmpCf8/k0gIqQLRRNnQ26HbUEtSlyQqB9AIoalSNsw9w1CI9QfUWAEeniIasctJSVfmKzaNVKEoHULIZxNqG4QF95Yk/SnZeMSFsi4BsieAsVAppTfIMqoIMQQDhFuqD8vWGngi1t09dc7o9lH6zBngfgYB7tpddm0jhnfAEsc0Xf2Tp04q9U8EUiwN+3AFlGQFh3MVE6y0EHZ0qe4jN+Fz1ZUBn+QxQi+Wwgm9cEuRFX6E6HayJqS7aggLfVVGnlJiJxwnY3eTunTB8oNhiHRlVG+B8xw7EnpA6+EjjhnVDU6UanWMfmhuH8XnYeqd3pmiFNVu/EzNkWkmPGyvVbZ6h+c3mVCpihJfoSw6U108nGEbwKO2w4a2hdsHxpjZ9LVOSpizm38AwcE10rAGKp8W+i5FkO6e0Rdr6Mje6g2I+R+wd+NF+5VAq3zs+B4WwmJIL0zHI4arteKm26/rhlRB6aWXFgccrQBIew5Ua/INmPfK5
 2Lnu7MVZ
 lNXxtMwVKTOFoR2TrGUnQjEF9eDGezF+1ZiOE7CtpgUwGdfpzPCWMv6QMkzz0Fd2gow+5onG1v8fD7qSeMhI0S+bJNeGBNCqs5c0TfO0aTqI6LIcyWlwMHqMn7swaKwj2xReLP4r3OFQ6INVl1MY5EtxV91YVCA/MmXv1LgH9wIgIb+JJJAzFT8Jg5tIJ3iVXLlui+nXvs4d84Lab+tG5MIn7/jRA6WZ3lnEe6JPUrws9GyGP2BIli60GtfeMijEsyUQ36z7HR91OupLBsm1va0Bnuo3VmZ1tpVutlHs1Ud1dC4FOQuEJuExzaWz2bkE4057OsEuCcEhr/Grw6FcEKqOVN+hvir8dGU/rlVR5E9KtXIKDRDDKRIQ8CCv7diUQJ+ubiSRwZ9CAsAFK9rwOjIU/T8a0BzW9yuYI6PL+xwPuvXzW+Qdt1Zgu2gic0Nr51qmc+jjhrlQeMw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:40:01AM +0100, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>pud_none_or_clear_bad() only really works on page tables. PUD leaves
>confuse the check and make us clear the page table entry and print a
>warning.
>
>Since commit aed877c2b4257 ("device/dax: properly refcount device dax pages
>when mapping"), this also leaks device-DAX folio references, mapcounts
>and RSS accounting, resulting in "Bad rss-counter state" warnings on exit.
>
>Allow PUD leaves in get_old_pud(). If a PUD leaf cannot be moved as a
>whole or the move fails, split it. This unmaps it with proper accounting
>instead of treating the leaf entry as a PMD table.
>
>Keep using pud_trans_huge() for now, in the future this code should be
>cleaned up to just check for PUD leaves.
>
>Fix generated by an LLM and sent by Josef Bacik in private.
>
>Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>[ david: fallthrough after splitting ]
>Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/mremap.c | 9 ++++-----
> 1 file changed, 4 insertions(+), 5 deletions(-)
>
>diff --git a/mm/mremap.c b/mm/mremap.c
>index 91f0865f6aeea..1237718848f5c 100644
>--- a/mm/mremap.c
>+++ b/mm/mremap.c
>@@ -87,7 +87,7 @@ static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
> 		return NULL;
> 
> 	pud = pud_offset(p4d, addr);
>-	if (pud_none_or_clear_bad(pud))
>+	if (!pud_trans_huge(*pud) && pud_none_or_clear_bad(pud))
> 		return NULL;
> 
> 	return pud;
>@@ -847,11 +847,10 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
> 		if (!new_pud)
> 			break;
> 		if (pud_trans_huge(*old_pud)) {
>-			if (extent == HPAGE_PUD_SIZE) {
>-				move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud);
>-				/* We ignore and continue on error? */
>+			if (extent == HPAGE_PUD_SIZE &&
>+			    move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud))
> 				continue;
>-			}
>+			split_huge_pud(pmc->old, old_pud, pmc->old_addr);

Right, copy_vma() already sets up the file and offset at the new address,
so we can let subsequent faults rebuild the mapping.

No need to build a PMD table just for the move ;)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
> 			if (move_pgt_entry(pmc, NORMAL_PUD, old_pud, new_pud))
> 				continue;
>
>-- 
>2.43.0
>
>

