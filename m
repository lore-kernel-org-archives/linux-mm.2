Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CEDC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5D56B0088; Wed, 16 Sep 2026 20:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE866B008C; Wed, 16 Sep 2026 20:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E36A6B0093; Wed, 16 Sep 2026 20:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5886B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:53:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 687811C0F79
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:53:06 +0000 (UTC)
X-FDA: 85221429972.28.B7AD69F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9A38320004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:53:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YB1t4XGL;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789606384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnRI04J838QlW2j+xCXhg0sb63Rekek+/bnqBaKeWU8=;
	b=vFW7RuLbPKLt/idNA82B7XziTWZa4KOsqUBWhFb7tTFiUYP/rLwQp01Sy10o2WvQcfwnuw
	ikUISVTaJoEKFVKopbd29M3SnYEFVI7J5ajdCQNNEQ1QsbtuhgiduyxoLTC/wSeUfGfjn9
	+pn91Idl4gLKwgu1ZNMOlbIVn64U17E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789606384;
	b=I7UYI1ddlgJQwb+T1DEG+06fv8aS0W4v0FPdLiAC3Sr2wZOOZxclXWJBa5EYA4vtqZWWeS
	Q5Elx6BtjjvWH6vxckvwLIFj7zmgwKUk7lqXA+cDReM1IXzMNoJkXYksWX64Lpe7nzNi2n
	QaVKRjyoT6VLZ7AuYWPLH0p8e64XOS8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YB1t4XGL;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2D7D42338;
	Thu, 17 Sep 2026 00:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424431F000FF;
	Thu, 17 Sep 2026 00:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789606383;
	bh=TnRI04J838QlW2j+xCXhg0sb63Rekek+/bnqBaKeWU8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YB1t4XGLoufbU+Z0ue2LWK4XzpzfthDFE7spCTSt0hJ0wcPOszFpvOerzgKStdw/s
	 lCZwU/fLZOt2ZGG+VXrv4aDXIe36Fw1GhmQFDU6dgnR1p3AFaIIyEbcn3fjIL5cnwV
	 QKtIIt5AerXE/Hf2PwPK6T6FhPutQCtf3QlTkYIA=
Date: Wed, 16 Sep 2026 17:53:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Colin
 Ian King <colin.i.king@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Mina Almasry <almasrymina@google.com>, Mike Kravetz
 <mike.kravetz@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/hugetlb_cgroup: move the per-node usage along
 with the folio
Message-Id: <20260916175302.be1e68f24b96b7c639cbd7f5@linux-foundation.org>
In-Reply-To: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
References: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: drhpkhhouh673s4nmbujomndp749nzbx
X-Rspamd-Queue-Id: 9A38320004
X-HE-Tag: 1789606384-415255
X-HE-Meta: U2FsdGVkX1+zVYwdzG+VnuOq0sQn/lI4vuIaTHup4/e1CDMBZ5E8ooptI56mB+WmFmKylGBSapV1EGZGP2bd0M0XllpLIPpVeY7xmvnJ2mw02lvUZtvp4l3K0MhgPDWZ+3Js8iUp6vEYTLvrCBQeS+3p7q5AytNwCR1UFKSL1xtbskAtd4CXgLA/fN7JPgZBO1BmW1+gFxrPRr7DAJpgvtWUZfROsgpX3fjiS+N09Hm4NTWAszhovny0XYZSISiXDE8wUV8lwMLcP9oUrMnYszE95rAFnposf2L7YBQ4U6WSOYInbOQWrUiHdmMdsVOAyFTEYPdphts/vnGqTorjeqYPBJIWC0YTeU8g0J2fTTjIr+YwIhwzMfCs3r1g1ujH3YMQRKdY7Xme0nHb/EiXisA3wLu1qThA1H8jjloFlSdzCMiPpFJs5TxM4Egd+SQkmbrAe8AecpLYzO9MVPPGcLCY4287Np0mM1sNLBFCUQTmUWbXi7RGqpP7mbhr3U6iG3TDsbl8RnLvmMmXvtXt2fKrL6M8tPar5xj6nf9xY0njXHTfPD1fL5csxGlK6H7Y8M1tidD2+pWM5IW9Qu6mCT2gSmFKM/ju0qjfYoXDQ3V1Vk11gVh5D7UDJceHBkx2/JSbcDs+xfwVTjd23fiIfER3KrjL0C8LINLImxU3GJWHR1ZGPfAvjeePdRzeONWTK+I3/2l5ujg4XALTT7+nw5LcruvQQg4bQ7p3KtW65pe/dGbGM3ubgCpG5c6I2T/GMts/bhT/41UhOWo92mysJZe8MvtYORy8dlxyApPEmdWlhIqOgHvffpeR2fHXBmo/ycXgJPdAaB87y9HdrmLRpDRxeYBKNnQyzGE3V6PFCJkgDJkLc6+RGyu+UWDfCpL/PIMbfz3sRg5ouAGuhJieI1C1J9StidxLDaUMBHWonJXg+nceJ52Vx8Lqm2A3pkfaBmul0sxeLHN+ThXneV0
 3p17jmTO
 8c43L/dHwAzXnikfGm/cf7OhHtjPwDxBMZ+X9SFi3QD7YAQdH5wKoRFJa4ZvcEogqU6ZUTr7RtBY34KPiOD4fqKnR/ndcsV62wf1v3G/KAr8bBIspkzWRyhxCfV6QO/xMhRHa9jei7pgab5mPx/VLBI0Z06d5mKoQcMXG4d6PfKNInV/MHzCiyc4+V0Qywl+7tsFeNjfJ6HnohPL5iHzZZoDxcR9BY8HX7CboPuPtiBjRQs0WxtfsmUctzfBb3xgBGLfn2b4kCoGLN1Q8vNpudDdMIktcoQlrqcl1oY5jeQ7S5WgWzWUY9Bc5mfafYf6b38LZ2F7iAv5niDEWHqd+VwcgT2T3qeRvm3UXVr7mvIEOcFq9n+D+b8ibiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 16:30:26 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> The per-node usage reported by hugetlb.<size>.numa_stat is accounted
> against folio_nid() in __hugetlb_cgroup_commit_charge() and
> __hugetlb_cgroup_uncharge_folio(), so it is only correct while a folio
> stays charged on the same node and in the same hugetlb_cgroup.
> 
> Two paths move a folio which stays charged, and neither moves the usage
> with it. hugetlb_cgroup_migrate() only moves the hugetlb_cgroup pointers
> of a folio migrated to another node, and hugetlb_cgroup_move_parent()
> only moves the page_counter charges and the hugetlb_cgroup pointer of
> the folios of a dying cgroup. In both cases the node (or cgroup) which
> was charged keeps a usage which never goes away, while the node
> (or cgroup) which ends up uncharging the folio underflows as soon as
> the folio is freed.
> 
> Patch 1/2 moves the usage along with the folio on cross node migration,
> patch 2/2 does the same for the folios a dying cgroup reparents.

As I understand it, this series affects numa_stat output but has no
actual runtime effects?

Do you (and maintainers) think that we should fix this in earlier
kernels?

(I do - a lot of userspace infrastructure makes expensive decisions
based on this sort of info).

