Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBB6606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c3OxYNh0
Received: by kanga.kvack.org (Postfix)
	id 3EDA06B05B3; Thu, 12 Nov 2026 13:16:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5396B05B4; Thu, 12 Nov 2026 13:16:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D576B05B5; Thu, 12 Nov 2026 13:16:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E951F6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:16:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 463F5120792
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:31 +0000 (UTC)
X-FDA: 85427272182.02.4F90154
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B0A1540005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3OxYNh0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507389;
	b=62bYht0lR9/xEs/7QjFKPiktUcY6usKiPrA8/09Sn8VHTJL0uIDjmFF6E/uo64AYS6wScA
	EdBGQbH4mnYqAaRgUPlXou/fVI6PLsrY4AxmaQDooDiHo8lj7gApf71jRqnfBRs+C7zVgF
	epG18TNGR1pqE/k0cE2DCtxxH9bAD/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbRxi8QGamY22vSf4BGkDofW5oMAimg8Fe0M8P7hZVI=;
	b=77T7EVVF1wSYggTIgUPEKsPEMxuD1SI6THI6n2QfyDNE6uERVxI/tKDHRPgwDb1WzK9HiV
	fjJZyCrWasvYTzTgcXG7sXne0YTHwVAd6o52iOHU0F3nUzZNwZhV16SWq0xqgwKdgVxhdF
	rVLRJhsjfq+thFo1zvs8Z0nliw266NU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3OxYNh0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B5B1623A4;
	Thu, 12 Nov 2026 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82AC1F000C4;
	Thu, 12 Nov 2026 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794507388;
	bh=vbRxi8QGamY22vSf4BGkDofW5oMAimg8Fe0M8P7hZVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c3OxYNh0DtzST3/trEn8LK0N0nz6PSLFJ73XurnboKJlgP5gVtLZpZ3kaHlGvBYE9
	 VV+MHvggrVsLUhgSxlL1fB2KSnYsMfqWR4hrUEz1CuAIGUWANpYdlTzzXK/XxR7IH/
	 hvKL8ZsKgNFVq8vIsNDO87h8q9Azqztksw7XAndW+CVlPYIdqLnkqa01sEKITwClXz
	 Ud3fgqpP2lj8Az19ZJ3UjmYR3lkDWX8Ere24KC/lrFYrgNIO+YEQ/iTxvgtn+prspC
	 i1s2fKCNRAeWvUQ2McFTXTiUj/huxPJsiytdeSBXWo8jN1bRmebuRj79blYeqBDEN6
	 7SIu4ZE4q7gBA==
Message-ID: <sashiko-outbox-211676@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/13] mm/migrate_device: don't collect a range twice
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "David
 Rientjes" <rientjes@google.com>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Nhat Pham" <nphamcs@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Usama Arif" <usama.arif@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, "Balbir Singh" <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Yu-cheng
 Yu" <yu-cheng.yu@intel.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dennis
 Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Peng
 Fan" <peng.fan@nxp.com>, "Josef Bacik" <jbacik@fb.com>, "Chris Mason" <mason@kernel.org>
Cc: linux-mm@kvack.org, =?utf-8?b?Qm9yaXNsYXYgUGV0a292IChBTUQp?= <bp@alien8.de>, "Mark
 Brown" <broonie@kernel.org>, =?utf-8?b?RGVubmlzIFpob3UgKEZhY2Vib29rKQ==?= <dennisszhou@gmail.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Josef Bacik" <josef@toxicpanda.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-5-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-5-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 18:16:26 +0000
X-Rspamd-Queue-Id: B0A1540005
X-Rspamd-Server: rspam12
X-Stat-Signature: 795hpz6mcj8m6qrrbish6znekk9q7mf7
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794507389-987819
X-HE-Meta: U2FsdGVkX19YE7yMLLbR7N6lkseDaLfkOfYPKtKBXXTW8O15n7ccuiEvQX2+lHUuGjaV172E+RJWyKgoyWhNpm1qQoWsAYidBbekl7Ci00SxQ52Abt9TojL28wyCbsQyaCYflKd7COpEEP2GL+8cmUCv2HTlESnXflQ0abcF05wIDb6hxBCYFRNfSxmADvOk913EsX/qp5BcgOGecaj3+sXp8zf+e41rvfE925M7Zh7wGLuVEd23a+MndxyenHe2H2y3fYBN415mjKXi/WeHFWBgDBT3QmvgfgO45+NbiloAzP1WiLXd5EFRVJC9Sb85ItlUEtpw+1BeIShhzTXahha91VFbT4nS7mHVTYDU/TJdvCPXilMi6wrCC7GuQ8/B0acVhK4d1XFVc5kk+mUSgk9jdOAe4bsTEoqybIwm0g8D42fPsMwfLmkYgrV8YWczyU0SHU5UYs6EKsTzN5wHsitPUmNpxerZWSA9UlBnbdnOABVu4yvSuF5runhHUi5e2UN0/jjQwnprkq+vQ9MSXCdc66c1vfmNN3irHFUKtifgL+Xh/VkVY7Crfh9/pDCgH/PiVHRyEpNNo78nTDljU+9KD/Eja0ff8Rj1FCc5gBZG/HOyUynlKYZknOsarppeylcrY9lskKeqjObQkc8AcxIj2iWnJrfZPEwyoeISXSE+gPNTmwDNEs8IonCQJULnJsoTEBS6SYhI21aSnkNHlOqPUVsnAPNl89il/KzlbzT05+kf4mMDa8fGjQu16+fobsRm7+vBiKREO7+Aiyxc6yYW0NDq6rI1Q0bqa77sPgbjVQ2fibCSIejdAY6wpqprw8BnzqbcNtU7DtrPnLw1kaqs308Xjndr/R3OHz5DzssBRR6pAZ/wnsZpMqV7840Vhz1bKs95Ijz3Od2Fmter3HlVaBBtYTqxRj3yPE/1CqIat3ZJlZ5nCULpvzyEmfteFbdvlw+ojrBFykKqLPF
 rwxTqHQs
 XeZyKe4V72o4BKKpLmk20C7E88djaC7aTOvnKGxh8Y5ayzTZ9OrIKSsAsraJ3L6tEAYxxLojiLkhvKq3hpUs4iMg3IMqQFRYyfEVO/OKjvaJqAVu1xOUV+nmqwBQdO4KuKttpkiOAieiqD/Ot5w5pCJH5jT6yOT0l9MuItuvwHqIlRICX9/hPc8xkTaBZg3HoNbS4LJZR/zjkHW+cYS2LJo8qifpXwdsZFUG+xx5n8YhifZFCKTxe/ZhvjDLHFZwXvwUsRbjYLgSlTgQjjo/0r72vkP6yoHzHpcMZZdleRjuUi36QGE/kchNTq23/JtFDdzP2/FalIyVNTqOzBcoW7QWm19Y6Qy019lWDg5SdkOrjktGmPjCx7uVj9zex1e1OZRNWQF61T6Hl/wePRtp64k3CFUZOUBRkei4O5rSRDWYYLNRgJf/uZthEYl/BncnKQ32YSygn0OXAl/nKCutbDMc1cuWnWt92wHBfjztURNW+Gnku9s5Q1fd0yR7Pm0LaocyVJcGnLybwwpgh2KNJtAaLMb/Eb15GngiFb/XkY2o3Q77A2/NiZq+jo/Aih49q4nzWhweUEUlKd2RZWiuU2CJyElPXEylvY1TxIWq8xKppRy5gFfRjrw4bRT6HKLkyDG4eraFO03PkESq+MiYywI5YabTQtuTUW5gLSpBKA+wnNah4uKRgWvvkAoZt4y3psZ5hs4mvJSYT9Vlt0glqFECNQhHnV+4Ypwd80R6sJylbI7a7LIvAQ4MMNVtySn1wlW+PLT+h+yCNhdWKE8bQHjZlc+mK8sC+kB6U3ToUL5c1kQLx6H+iaX0A8MBcmANKP4d9iFRvrVEWMBaF3zeAWRKQIFJPo1Xy+ti6MUR2Jjt3chv1LsrzSe4eYFz//Dqv6T9wHO8SbuJMBFzC0HrPGdSl72M/3mJ6F0ouizCdEjj4+TvMp/Upf1r4sBHOuwHW+J4Dfqac8zSLcwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] mm/migrate: livelock in migrate_vma_split_folio() [1]
--

commit d718421e16d638aec3608447abd867a1a5760540
Author: Josef Bacik <josef@toxicpanda.com>

mm/migrate_device: don't collect a range twice

This commit passes addr instead of start to migrate_vma_collect_huge_pmd()
and flushes the TLB when migrate_vma_collect_pmd() restarts at the "again"
label after splitting a large folio, avoiding collecting [start, addr) a
second time.

> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index edcc13edbf6af..4d4054fd020ea 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	pte_t *ptep;
> =20
>  again:
> +	/* [start, addr) is collected if we get here after splitting a folio */
>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> -		int ret =3D migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault=
_folio);
> +		int ret =3D migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_=
folio);
> =20
>  		if (ret =3D=3D -EAGAIN)
>  			goto again;
> -		if (ret =3D=3D 0)
> +		if (ret =3D=3D 0) {
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, end);
>  			return 0;
> +		}
>  	}
> =20
>  	ptep =3D pte_offset_map_lock(mm, pmdp, start, &ptl);

[Severity: High]
This problem wasn't introduced by this patch, but can concurrent threads
splitting the same large folio livelock in migrate_vma_split_folio()
[1]?

When migrate_vma_collect_pmd() encounters a large folio, it takes a folio
reference while holding the page table lock, drops the page table lock, and
then locks the folio in migrate_vma_split_folio():

mm/migrate_device.c:migrate_vma_collect_pmd() {
    ...
			if (folio_test_large(folio)) {
				int ret;

				/* migrate_vma_split_folio() consumes this reference */
				if (folio !=3D fault_folio)
					folio_get(folio);
				lazy_mmu_mode_disable();
				pte_unmap_unlock(ptep, ptl);
				ret =3D migrate_vma_split_folio(folio,
							  migrate->fault_page);
    ...
}

If two threads concurrently collect or fault on the same large folio, both
increment the folio reference count before waiting on folio_lock():

CPU0                                CPU1
migrate_vma_collect_pmd()
  folio_get(folio)
  pte_unmap_unlock(ptep, ptl)
                                    migrate_vma_collect_pmd()
                                      folio_get(folio)
                                      pte_unmap_unlock(ptep, ptl)
  migrate_vma_split_folio()
    folio_lock(folio)
    split_folio(folio)  <-- fails (-EAGAIN) due to CPU1's extra ref
    folio_unlock(folio)
    folio_put(folio)
                                      migrate_vma_split_folio()
                                        folio_lock(folio)
                                        split_folio(folio)  <-- fails

Because each waiting thread holds an extra reference on the folio,
split_folio() sees unexpected references and fails with -EAGAIN, causing
faulting threads to repeatedly retry and livelock.

[1] https://sashiko.dev/#/bug/linux-466ab9fe-179c-44b5-9682-18591b13f65d

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-mason-migr=
ate-et-al-fixes-v1-0-3d2454362e8d@kernel.org?part=3D5

