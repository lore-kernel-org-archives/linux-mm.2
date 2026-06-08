Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7CDCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0266B008A; Mon,  8 Jun 2026 08:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7A16B008C; Mon,  8 Jun 2026 08:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204BE6B0092; Mon,  8 Jun 2026 08:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD996B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:30:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5214C34C4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:30:54 +0000 (UTC)
X-FDA: 84856679628.15.AAA23EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7E7316000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:30:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MptGS28x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780921853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7K9xf/Abv65PD5WJKWreEjZFt+w5IAtgpsFxo2CIhfg=;
	b=MOrv/aWTPDGUpuAY9vCDR/dVhOpalOcSQ3ehsiOvVBNhXQmRPCWqR5uixQLkSrvAMu8mSK
	gyYXJoCC3j90PsYrgnbseLe4bYJPRXoOJl3VUWTwfZLsqOi8+zpVR8Rns6b/0tyzc+iNrx
	3HcDqJJNaJ+AHGa+e5btCzmHSZtmcRY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MptGS28x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780921853;
	b=TTYzu9n0kUDf4i/eYPUDqCkiHoIoZf0EigZUR7UlwmOqqcwWhdiWPoEsal4hcltawAazlA
	SwgKv3IkipJHa4IswtiWasNQ5Egiadmvj7iZUOcMkv/3RjeBCW0x3I1ZFbHsfnU16uViG6
	OQv7E3KUwvdxrTQ89SGfupJvzzzohoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07E4740305;
	Mon,  8 Jun 2026 12:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DCE1F00893;
	Mon,  8 Jun 2026 12:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780921851;
	bh=7K9xf/Abv65PD5WJKWreEjZFt+w5IAtgpsFxo2CIhfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MptGS28xZRXTQDjUm3m8/WhCwkOlQzTNjeYnfC4uD+6XNOlWaTscB40cuNOohwjGF
	 vPtucP/L1ctoze31pqe0An4IeAVPiBA6AwZMqbWYJeQVPRlRzJkTjEh9Fmf343veDD
	 p9fPTpFXNKwtGcHjpdPy8HPkI08CKKgyXXwR3QYnYnc/s4h+fG5N5jYIUIbIEPwnnn
	 OeQeaOkAxRcS/HOD/t5/zqoOfTsZBKN8rm0aFqNgFnXbZOb9AhW8hjwdTQyGTrVdEL
	 GpsnGHWRwFYt0fKJhplVf0VTVLcoVCxif/Ms6rv05VPSdd5k1Dp6vuOnBd4oBSbvMD
	 F1tLurbUDYapw==
Date: Mon, 8 Jun 2026 13:30:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 26/37] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <aia1xjOPMip_dM7Z@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <94f64aeca62d8419d76f2cf82b36f1da6017a312.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94f64aeca62d8419d76f2cf82b36f1da6017a312.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: D7E7316000C
X-Rspam-User: 
X-Stat-Signature: qc69qbiwhrxy7mc5jmdtgmsiq7q5m9mq
X-Rspamd-Server: rspam09
X-HE-Tag: 1780921852-906765
X-HE-Meta: U2FsdGVkX19npQntY3BoUp4MP6ZBDjNYceK608W684GdWTFOmogNZgsB3z3IGUITHB6JKwr0AKiciljPY52RZO5IujknvaAAiUxYxBJIYKi62usGr4MZDtbfCLUOLS2/hW11tacAB8/wPJ50JuEgIQ2BaNiKMRhexi8C/Vsb47Glzy/mO2lEsutyop7l81g05wyNMQn7fLCZG38iEfyhyQl9MNam+BGZ4iMEL2mir+NJdYH3y6plQQOxOHgO7qACgDNoPiODr+N8F8MCvTXiLgo8dmnjUatY8dbGhS5w4qoEQaJRClRAEKIEOienRwKpODmezledB8hdlIGdlV8rfuTr983IGKZp/M1pHPCylLYYFCPupwtNpgZOiogunZLfQFmikgaUleY7G6ZINkOqL1vcpAgHs6vi6ICTCNO88Em1/o6Z+U6wfc1wILNy3wHwyH/jrgANkucXP9ORZ8wntxV9x0TeuVTY2tqLh1Vw8h8cpTn/HXcxtgaE+Ajfnv8hbiDiIRGofhLTo3y3yFzjmqbYcVWT2s7arZVT222KY/mT8i96io0117VjjDilpNh+Eb47hQrhz8Lp71xUzxprcVgECpYdA2EKBYcq/tvkWVprfKp28MDAqHSooWfifCrj2QfhBfCdP44JKiUa35QXl6RcGX2c8urRYnUBJR0moEvFzgBJlvP+nelIehL7qDlhlvrKTaT2rSbrTMB6sWf6D8lvvmKfi+6dcX9mVLrbKfdyNCwIT8+HIkJ6khCpm3XqnCbaLFU5antKTrrCCDwA/IE7UHxPF7yOixCalQ8PKY6hqEr+FsDDQIbpvmkrRInGiSH/2zbugsPSqDl51UuTBjvCe4HgU6cjmN5nVRjxkVut8MC6y6omWTgWciGgsjVarvb8jLMHeTffk5M7mSb0AirqYIxzAsqhoheBRcuD7EAGoV31GgVZb3noe/EbzgCf0h0CW+zdpW7ngTXEyWL
 OxAcIp7m
 +twiZ/aFop53qflO7lN65Se7kBPnJ/HRXuI6XelQKAqvWgBrdYssXzFclOHYRxfqIvG75HCuc2dtZzU162ZSlFFppbRs8W/TPqiOqOAzfU9VW4J7dn1zmpCW0CqFYGjv+hFY57ogmJe+7vqkV7KWYCsq0+HPXRdiHi813Hu5AvNMV0srveDBQf8ltXrqM84HjMYguwgSmd+UisO8tzi/il0y/R/j/D/9E2lcaSiNnQf5XeavxIqdTWURyI71FB93tBZ+S6rya+XuarFsaW5tc5DAaIspkmvPLYM8spaPT0X/ZI7pDLdtPFFZ/1dDxbfJwql5HG4oiNrorZZsnnraazQSJ5AmJqWo/KGsgA7t8e491yjHva3VLN13tI2G4WvYRRn0775RsD2LCYgnRFbMY7qy5ZfjFPao6c6OTy25wTJ1LwT6VO9NoH6vfPhv00p3jwB50gXS9wDIUsNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:39:10AM -0400, Michael S. Tsirkin wrote:
> Drop the redundant HPAGE_PMD_MASK alignment at the callsite.
> NUMA interleave is not affected by the raw address; the ilx
> calculation shifts addr >> PAGE_SHIFT >> order, dropping
> sub-page bits regardless of alignment. post_alloc_hook will
> use the raw address for cache-friendly zeroing.

But then what's the point in this change?

And why are we changing what we pass in this parameter but not the
vma_alloc_folio() kdoc?

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..d689e6491ddb 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1337,7 +1337,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  	const int order = HPAGE_PMD_ORDER;
>  	struct folio *folio;
>
> -	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
> +	folio = vma_alloc_folio(gfp, order, vma, addr);
>
>  	if (unlikely(!folio)) {
>  		count_vm_event(THP_FAULT_FALLBACK);
> --
> MST
>

Thanks, Lorenzo

