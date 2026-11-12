Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C670606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jUA8Avn0
Received: by kanga.kvack.org (Postfix)
	id 7069C6B00EF; Thu, 12 Nov 2026 14:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8076B05B0; Thu, 12 Nov 2026 14:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7936B05BC; Thu, 12 Nov 2026 14:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 318056B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:03:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9062A0B42
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:03:28 +0000 (UTC)
X-FDA: 85427390496.25.E49F186
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BB24D18000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:03:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUA8Avn0;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKmPHjD7F+lAu5Y1PmUklxdmbSrVzMFLB6y7wwm9rn4=;
	b=191WedGjB7GhiFSFBWyT2hn8sXpRxx4T5hlDhhcuQGaDU3sYH6wtN811i0TaniOsDLJLS4
	CHsyVwFPTYvuz2j0KTx7t6jamt2BNAsh7o1azmxE5CfXgW/5xg9VIEMQr4yLhn/5AsBLUW
	T+zN4NnvjH62+HSRIfSN7kzgKyd/Oc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510206;
	b=7JipsFpSPRxmDpIXfHkXIEgAwoNXVEfhVjZE1agazN2gPBXujhTPaLPE+GkYYN+ZziQaqJ
	kmIPlXMfLGQb0GXblbM3hsva/qcmuKNUNxnI2XQ3h/LCaxygugY7zWPoNFdkxq/wXYDuLQ
	kVfxfUzD+jNkauWsLnjjNBZIGU5nQEU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUA8Avn0;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F05AD404EC;
	Thu, 12 Nov 2026 19:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3621F000C4;
	Thu, 12 Nov 2026 19:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510205;
	bh=BKmPHjD7F+lAu5Y1PmUklxdmbSrVzMFLB6y7wwm9rn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jUA8Avn0OjggNIl/nRhZLsftG1CcIsE+P07qqfFSyNsEQTVpwK0yFjIsaw9V+7rk4
	 i7S3HPu3az0GPuU9xPZzMQBHQQr1nbT2UsRxik+CnjdlyZxOq+1XDs7tzT78aPPKpG
	 7bJnBFcXUMXzoEBBMDroROB8HmzksqS/gmG9vmOaxHNz91DXBwz06sMNkD2KXVe/Af
	 +r3SD42o6nZLXHKB2Ze/w/ZUePNrC5Gr5fOlM3gqBuvYU7iZ/jLKLGtD5jIYuPZ5hX
	 oFS2PKujVTNdUmnXUYpniuAoB2acN92bEYS+2D0wJXcdaGfISyfJfLHpcsCJ74fxye
	 WYPVlA8ScGQuA==
Date: Thu, 12 Nov 2026 19:03:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Message-ID: <avYJ-CxBEpdO1Wmu@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
 <sashiko-outbox-211681@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-211681@kernel.org>
X-Stat-Signature: hhbnjpbnxzyobtqrn1xpwwm5zmhp8rmy
X-Rspamd-Queue-Id: BB24D18000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794510206-482545
X-HE-Meta: U2FsdGVkX19e+iVQlA4PKWMeNCQ0j0NFtk+1hPe7nfbvg02onoJEZo4JiH3MfB8wenBM17omdLy/sm7BpSFHp5U6n8amMd8od8LeCuKrAWafyzex/KIzAK20q+spo970Nw+T7HLP8oc6ALzeWrwu1WtCO2O/NmWlY+c15iB30w3L6/zfKk0r/ER90oW00mAZx9qQbKB3sT0ZdVnNOeRu11/jfiOpMqwWqqk8k4Vmw805TTMw7YFCaZ/0z7yYAs9/pxyjofnjNSt1IZe0/Eek68F0NfLKWj3h4/vhUsx0zHovsqeaFIXhf7kaVVZw6EIhgDTyRA57lQUlhhAtVzoqoR1mJZ/WaIswsTCxZZ31Y098BmNEg0mA9Jzr9qPOgioD2b2tfNWeyb84ukr+Zb+nsHZdptL9T9sdG/xlOIaVG3S9+unGzALhP1h1CMOOoQZsuTMswt6cg3ZK1RnISmZvFKWiJcJQok7ooGv2JASAyHLfONAFfpoq3lUdw2mqdYCOUilwj9qm+RRq0mymyckISyuFa/pG1xdPw7QiSCjCS9NGa+E7nMcg0tjE6OBvU/Ajs+jjj6K1DO/7EYYo5rd0VAkTdOOkwThBxzMmLtPQZUzUqCbNitH3GykTqs8sT2ZlihSMyLyRxgIM5jauV3udT1fbNjGHTFh5I+QP1avFuKwAtFLtp1gyIpA2VLxigoQbte1c13k395vdhRFFPjfkhEkZfhQTYAT8fobTN2fNl1xuwFseMTZXWdCGQbwQfjC514/n7MJzISs6YoXLsspoQkTF2Lbt63sX4cviLCDvlfjU8jmkKW6SJgCxzj/J3DZtiiLxicSlJg0krkNErLsgIh6SMuKCZpvy00jLIyylb1OTn+EXRhK6P8yCM5QsnClQ0xOzxdDJBhG40jIB3j0sICAhVuZlKjMYY09XHnaaO1IESxw9yZ818Y8NnL+TcaM3HsZUuxMsDeXvARVnOYr
 Ts3/Y1/P
 cqiwOpaA8X3fxmfIMoKmH81F8vIg8BVlndGZ2qQ6BgcVElhQGlda214i0kYeXYUBw/cyP6z4o1aOK8T218drUKqv8qsB/R+pgCwYaZWiIARoXkzYGiiGwOLfpU/hCvVkVbgrGUG7Yz7okOuA6/HVjoF1IVvFWiw07YuugbHskmGPuNt0ruPY2oG3IktrKfgI3Gv06w8YRFZmkaiDWL1bhjNee8IWOI6zHD8S+aV54ozUpnScbnFoMYolCNgQVsIyndmVn1BcjhKhFIUmjlKxwT1hizi2/v/uTIrSLLKzuRgLWwACPKT4q28u5Bwct8WPZJcyGzClaZMo8kgoOFj9IaxL4QnKbYwMOC0NxlZob6+NT6qE7aU1x5H4IYG1gGFb7P8yBDV/PJ+ny8kjwC7L5pjrNQDuBfbQunmWsA9huCpsSXb9Ufu5wSDvPDW84nDM6eqCzxIqB7Dq2eUuEFV/Vxe8sMgSQUADjQa0n1rbE8m3NVE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+cc Roman

Roman - see below - I was under the impression mm was not supposed to receive
'unrelated to this patch but' reports? Did something change?

Thanks!

On Thu, Nov 12, 2026 at 06:16:31PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Critical] mm: out-of-bounds write in migrate_vma_setup() [1]
> --
>
> commit a0bf8430c5e68cd904038ab8081c7bc9a9b0f7de
> Author: Chris Mason <mason@kernel.org>
>
> mm/migrate_device: refuse to migrate shadow stacks
>
> This commit rejects VMA device migration in migrate_vma_setup() when the VMA
> has VMA_SHADOW_STACK set.
>
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index 0f2a2832e0bd1..c27f513ee46e3 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -759,6 +759,8 @@ int migrate_vma_setup(struct migrate_vma *args)
> >  	/* The migrate_vma page walk has no hugetlb support. */
> >  	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
> >  		return -EINVAL;
> > +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> > +		return -EINVAL;
> >  	if (nr_pages <= 0)
> >  		return -EINVAL;
> >  	if (args->start < vma->vm_start || args->start >= vma->vm_end)
>
> [Severity: Critical]
> This problem wasn't introduced by this patch, but can migrate_vma_setup()
> write out of bounds on args->src and args->dst when given unaligned
> addresses [1]?

I don't like big buts and I can deny! As above, I thought we disabled this?
>
> mm/migrate_device.c:migrate_vma_setup() {
> 	const struct vm_area_struct *vma = args->vma;
> 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
>
> 	args->start &= PAGE_MASK;
> 	args->end &= PAGE_MASK;
>     ...
> }
>
> nr_pages is computed before args->start and args->end are masked with
> PAGE_MASK.  For example, if args->start is 0x1fff and args->end is 0x3001,
> nr_pages is 1, but masking rounds the range to [0x1000, 0x3000), which spans
> 2 pages.  When migrate_vma_collect() walks the aligned range, it writes past
> the end of the caller's args->src and args->dst arrays.

This is silly. It's not critical. Nothing in-tree does this.

If internal kernel stuff does incredibly stupid things then incredibly stupid
things happen. We can't nanny everything endlessly.

A monolithic kernel means that the function and its callers are considered
together.

If an out-of-tree module does it then it's your fault for using an out-of-tree
module (ugh EXPORT_SYMBOL()'d).

>
> [1] https://sashiko.dev/#/bug/linux-ca91ac03-4056-4cf8-8afb-0e516e08797f
>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org?part=10

--
Cheers, Lorenzo

