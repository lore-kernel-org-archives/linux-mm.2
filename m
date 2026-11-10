Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47665606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HWaQVkY/
Received: by kanga.kvack.org (Postfix)
	id B5BEF6B05BA; Tue, 10 Nov 2026 00:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B328E6B05BC; Tue, 10 Nov 2026 00:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48556B05C4; Tue, 10 Nov 2026 00:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84B606B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A62814087F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:04 +0000 (UTC)
X-FDA: 85418153688.25.522CE29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76C20140002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HWaQVkY/";
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290282;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccFem5fUCNTnnJPcQ9K4zOCY/Mnf1A8NVlL2cj+A0ys=;
	b=CoxTGLoQyVmguQz8csCmCI2qMol+CqCtMX63fQxFWAALQcEe1r3TTLQRDUyXfgKDORd0NH
	kEoxmmMb2bYQty/4bdK/uE2ou1801MtpKVH8VIe+S6Ex6r3aF1pcahEzCyglKFYPyy1OWf
	q5dns1i6/w8sq9Zh7ZO35Cqtc3oxrdM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290282;
	b=uVUipLiSwBHW7UsC8jQD8S1YsdkkqqBin7GJJLOVf41pixMwqkw3TWmm777JjZQ5ge8h7g
	DSroG6+u3eZAhO7Jm1iA7aKkf3hOvAlfMDdLXidBp2M33EsT+3VTdFj7qVx5NsTdScPhjd
	dOlc3EkgtA9kHvejVoX+H39ZlwW39BQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HWaQVkY/";
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C531463595;
	Tue, 10 Nov 2026 05:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BFB1F008A1;
	Tue, 10 Nov 2026 05:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290281;
	bh=ccFem5fUCNTnnJPcQ9K4zOCY/Mnf1A8NVlL2cj+A0ys=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HWaQVkY/FTCaYW5+BmTLeYV1ptXpHTy658fLjfZd3/paTTAqFZXxFU6dkmMdT6QgJ
	 7lFFdVb7JsBqttfiWJS+SWF7dYpOm0BbCn5B4MzKVg1Q10B8S98Ub5/f0Tp3I0v+wT
	 rKI4Y0JMUmIttVpPNR9w1cwdVeEd0jKV4ShezWA+rsAP/HV8oTlIFG+WOFu+jPlt1l
	 6RDycyNnnKUCwewmRUYDVb6MoEeMe17NMiApuCpKjmbfJhSnJM0gM9oMjdHJihTiLf
	 5Gc+DHisj2NcMPxLE6PaSw+g/+mL0FTejsI5rruy+mQmmo0xPu1hxL3sox8RMqitcp
	 +cFOLMHVf+NHA==
Message-ID: <sashiko-outbox-206363@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/19] mm, swap: use a VM_SPARSE cluster array for
 xswap devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-5-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-5-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:58:00 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: wf71iqfihdr41op8gdnq7fjipnfkm91k
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 76C20140002
X-Rspam-User: 
X-HE-Tag: 1794290282-866769
X-HE-Meta: U2FsdGVkX1/2+RyJrSsHSzwT4YDpPfmQlUua7RLiqjsxyo3eY3yfJnoru0aszJvFa6LTrc7E+4RtiJzQXG2TPXzin1JNaBnbnN8iWaBlFJyz0TpyNgPtg89HviHy94thXl7KDco9yopr3rHxO3dZAzSg+W1b/XixlpPQUOKdXxFsGl0hWFrwem/PPi3j+uTaj2Fwg9FiDs8g5ccQufjfYsBDKf+aQAhVLQooBN6P0v/dmmQAIUr1il+WGGLUeyKRMljaC7DfXCV2kroMncYk3E4On3GbJvLPtgJwnwwwwqG99QSMBTEgJNKPN5F5/lh6eycSPMvFRPlqxxk0SY/tX5oZ3jdVzEG6U/I7NUsYIQfW0LsWX1KvMG/uPXhehOsralWbHoY/ROJS+E8kSfNBkTI/bivlGuvab/XzvuPfw2FSmGqAKlmX7N/OJm29mb35yNEx2V636pUN98+N7Ig8aRFiuzDSAzDBYZchrr0dlbf2TrirCUhkK5r4/8IqV8S+JH4Rh4cMIIq0hzoNle00rmYRLsoB+ffNhR2jadNLWa+1oKREwFEIeLwUil1iH7p49jhaxRerh3PMtgtNCBISnOiVAnBTa38+37lcifep1hxfY+ONAQt9DwOLTC38h5hFh/zfPS0G3BnvATPre0OVm+iuN0ugfTqWHsBqZWSQIKBkUAmra4u7vR83TTQnV9T8fZKF88k8cqrFoiqlikl87ufht9rThb40Dr0MnBjg2t1fT+uvfSgTOug6hS3vcEiJjcFPQdxP7xxRuWpBfVY8cPgh/7crPL3zV6X9exMUXt/eMgWjt5/uP8SrmN/Gukui+1V/pK4aop5faJvmPPW0spF8V3Y8B/W1ZJ88SFtJfJEiP9xKDvhUYoFzSCivSlCTAAAJd1byZSRmEXxsDQlaVuqN/P/BUgY1qtP4aN/hLAsDho+HMfLtaXKky/qV5ikmkqszT0pgpj66+UI7DJg
 iFytrmCO
 nGiZfIWNqE97LTsvIxy3PJM3rp+xgsu41q3A/qQ6gMfdMYXi9mP77iMC8YYxOd/XxsOO47qxBeDD/4paY4q8/LzgG7wJbRsnssNMfXk+TPcMjOJ2oF+DdZLOSSUEBlUBsZCquN0DJhOZGRNjBAiOhyu6vt4v/XUGA9TQO2tolZ4TVSUfor3siF/R1gb7BGE0WmAHl5YEwBVVFdjvV1hBYpGQbE91gkE8qCUtBjsrbZ85i+fUub1029Qay3CarDI/nv0DXfYdLihIf+h8ECjNER8AkkXrX7QCK+JdnqlAgTTvD6mP08WQVet94vb98Bg4J78hBR25CPguq16QivOfDdvtgpd++lf21Qo+mfq7HIqRX7CweSsxGL9c7hhwzv/BjHIkUEZxsYlgVVlHBuNq59qA6A3p5h8Z381s+Zd8i7qZrvGuwZ7/IW/Pi74J7/gBGuq+LcGZvpiOdqRjyN2oAavCJMmJT2DKbWK3hJ2Y0XMM3gjNg6moX/4rGYQxMT7xIAmX/FmP3Zw2COwQGNL9k8En7wkFUjkDfiAix5swwBCzPH43ykoJz1rAd6aM0+I+ppWfFqbwFmsAvjIiZk9l/dj3mcmvNiDn2kgpF7YPT4+C7cpNLVPUu89jAg2SUax/dXJdYqWALgMwyV/ZbaiWsuklz80GDx5b9Xed0nbr6kxwkTczT35nqIWyvkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm, swap: missing nr_clusters_mapped check in get_swap_device()
--

commit 59c7799e61f59ce4eb079135f6f31b57258c37bd
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: use a VM_SPARSE cluster array for xswap devices

This commit backs si->cluster_info for xswap devices with a VM_SPARSE
vmalloc area mapped initially to XSWAP_GROW_CLUSTERS clusters, and bounds
the cluster walks in find_next_to_unuse(), wait_for_allocation() and
free_swap_cluster_info() to si->nr_clusters_mapped.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index afd0e87185447..00c7b398bafec 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -3902,6 +3969,69 @@ static int setup_swap_clusters_info(struct swap_in=
fo_struct *si,
>  	int err =3D -ENOMEM;
>  	unsigned long i;
> =20
> +#ifdef CONFIG_XSWAP
> +	if (si->flags & SWP_XSWAP) {
> +		unsigned long size =3D PAGE_ALIGN(nr_clusters * sizeof(*cluster_info));
> +		struct vm_struct *vm;
> +
> +		vm =3D get_vm_area(size, VM_SPARSE);
> +		if (!vm)
> +			goto err;
> +
> +		cluster_info =3D vm->addr;
> +		si->cluster_vm =3D vm;
> +		si->nr_clusters_max =3D nr_clusters;
> +		si->cluster_info =3D cluster_info;
> +
> +		/* Must be initialized before xswap_map_clusters() locks it. */
> +		mutex_init(&si->xswap_lock);
> +
> +		if (xswap_map_clusters(si, 0, min_t(unsigned long,
> +					XSWAP_GROW_CLUSTERS, nr_clusters)))
> +			goto err_free_vm;

[Severity: High]
Can a lockless swap lookup fault on an unmapped page in si->cluster_info
when offset / SWAPFILE_CLUSTER >=3D si->nr_clusters_mapped?

setup_swap_clusters_info() maps only the first XSWAP_GROW_CLUSTERS
clusters while leaving si->max at the full device size, and
get_swap_device() only checks offset against si->max:

mm/swapfile.c:get_swap_device() {
    ...
	offset =3D swp_offset(entry);
	if (offset >=3D si->max)
		goto put_out;

	return si;
    ...
}

Callers such as do_swap_page() read a PTE locklessly before calling
get_swap_device(entry) and re-verify the PTE under the page table lock
only after looking up the swap cache.  If a stale PTE from a prior swapoff
and xswap activation (or after tail clusters are unmapped by commit
"mm, swap: add xswap shrink trigger and defer it to a workqueue") has
offset < si->max but offset / SWAPFILE_CLUSTER >=3D si->nr_clusters_mapped,
get_swap_device() succeeds and swap_cache_get_folio() ->
__swap_offset_to_cluster() dereferences an unmapped VM_SPARSE page in
si->cluster_info.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D4

