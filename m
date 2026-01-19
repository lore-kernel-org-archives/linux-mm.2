Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E25CCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 19:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D146B02B4; Mon, 19 Jan 2026 14:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC6D6B02B8; Mon, 19 Jan 2026 14:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C74B6B02B4; Mon, 19 Jan 2026 14:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60A496B02B3
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:33:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E59B1B71FE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 19:33:09 +0000 (UTC)
X-FDA: 84349711698.09.4709BEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD9EF4000D;
	Mon, 19 Jan 2026 19:33:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jwiw8ZqX;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768851188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZwi0Zad3bgCaZNerswcpSdop4bARwqwJTbYnPcBpR4=;
	b=TvSZlWVsbgr0gEcODDR1XQ1Cld7Bds9fOHoCPBll573tGwUaYyX88ZwwmP/nNLF+GUxiI5
	2krEoedcpbxMfpcw/FLIgrdJdqmMiug4yTJtQq9kCYZUYEuUcYizXZ/xpeYq3W7C51b29Y
	uU0pg4+IvQiXYMRv6XJShv7O0U8bWyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768851188; a=rsa-sha256;
	cv=none;
	b=TaW8hZQbw1i6JYP2h0tbqQXp6Bfe3Tpm6eJKnUyyczK7JaHNsy2YXMKwYJCDYdS9xcEsq4
	tNkyAj8w3KuRup5hybrww88Ngajdi5JZzIpSCtYtDeCiqM0tVnSzOlUIWextWwiA3UPZJ6
	7PxeK/799ZTgI0Y/vXdRXSmyvK9gw2w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jwiw8ZqX;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDD98600CB;
	Mon, 19 Jan 2026 19:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD0EC116C6;
	Mon, 19 Jan 2026 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851186;
	bh=PRVJ16ccr6KBA8Uf9ujjZQyURMiuVIb1RLBxOuAUaAc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jwiw8ZqXymRq+wiALadlAbpDLsKCve1hI4wsWYVAZMJ9n7yGkAWX7+yzeWf1ds/2Z
	 npx4R/EHTL5QWpEUX5ULuLD87ON54PXj60lr7sfRkY+Nea7RWwEvR00fj1d8bhjzWn
	 nMJ+Jzcn2nBqy0YkA+hgqmk+zw4e9UPb0gVqDV24=
Date: Mon, 19 Jan 2026 11:33:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Christian
 Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew
 Auld <matthew.auld@intel.com>, Matthew Brost <matthew.brost@intel.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise
 <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike
 Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
 <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Carlos Maiolino
 <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Zi
 Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, David Howells
 <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, James Morris
 <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, Yury Norov
 <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, devel@lists.orangefs.org,
 linux-xfs@vger.kernel.org, keyrings@vger.kernel.org,
 linux-security-module@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 00/12] mm: add bitmap VMA flag helpers and convert all
 mmap_prepare to use them
Message-Id: <20260119113302.76b21eb8be2f9d0bb076446d@linux-foundation.org>
In-Reply-To: <cover.1768834061.git.lorenzo.stoakes@oracle.com>
References: <cover.1768834061.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD9EF4000D
X-Rspam-User: 
X-Stat-Signature: buu59bidcutwoimhrmj7pgdq3qt6eeh9
X-HE-Tag: 1768851187-655083
X-HE-Meta: U2FsdGVkX1/GSGNeyzMAVlFTVYDNLJ9FL+fowGRvw3uJPfl3h5xlRrWQehv7up9Q5lhewht02cbDPiehEoWT0NB2p74gK/uiWLgoYQEOvGtEx722mhyyGp2mhHMjZNE5he3o3BjK0aJEJBVeY0D1kZdsQOChl6q0Dp28oEakV+nn01nJOXP10xIKTp2ldu3+FXjbv8JyDcVDX2QjPZmrKLvyjF7HBAoWVUmxutPkN937pIHQW+jflYwZL66E/n+jGMhcviZzM0abjYr9Xvlxs8UWt6cinukV6gyROOmRvXjlEl8rlMwQiLAn7iEzwoj4a3chQNi/37RDQxYmrNM1XSoCl6RFTGLaH2pRlgtfe4xiN+Vm4c4nD2JvemQtxepzfUYIyTwDZnXJztoTPXTV2+yeOyZFboTY3w1+q2px++O61E+oinHNKwWk6sXDuDeJTl6Ywjs5iUAtAKTa1a6DwasvRCSO/0jM7ULpj+FVGS/mu5J6HpQX455Pg8KeN8Uz0T7gWEHitKVbe9brkL4SNDQT1xfNYNqy0nOi4PCl8zf9GnmVs25oC0HJje+lmkP72xc43TsUWhmCeCroVZJb8Yir5YvOmxw5GgyPWWpVibNEDPLQ3WzXO8MuemeHkrgx8xFrfBCN0ukzJyBSyv+zcYoL6muQrrxzDlZ8mRWNQ0lEs3AkMqdEdrNBScs7dDhFv9LHSydqavXzdZqW8yIktRtj2SNbyk25CJ3cmYzrm+Ui9zRauu00UdbLDkQr7wqc+dRw5+F95drBQpzV0IsfK1vYknet1mToayt+JWVJL7jqJrmj6YTTb7zZ2dP9ODjNL93p3k78IZFp6fTdxzllKAFXEeODtt23feYOF5WKpnlP0aN1L1KiJgvlG+WQGe3h+7IybIT1HikFw+JSsKsOp5bUYJo1yk09ycXXZZFb/DlPPY6X47C0uwEKCluNs5fBCS+axPrnOTcS+mZ6RhW
 1hphF0i0
 WtBkuu4Os6xSLYnnoPzVdlhEKGzFj+rF3xjjwHuvTn3is/NoRtD5JcMK3pN9Em1u/M03pmYr0emZDGS/+luvQbxGZAABqWSdQUUkanuhOijbtrexux+pv0It8y5gU8Ik20Fl2arArJmO5MRDR1buqVOs561mXw8JieubQ4hnstQnkROgPKnh0OlJh45aLdc8SHNcMcjfiEdM9HlFf/Ovea83yLElPt2YtwJpY3D+Nd4QvKTtbV6hWDxrIqrdIUHk/6o9K8NvggRAg3GuTOyTHmOF9e/2L4BD0Ni03BVVUfE6cTT9tQ+PwAxio92z63L1tndU0KbaEBa2+yNa7XO5nixBL+Y0xNEIEsvsojDDNi8Kg0mSaLTo0nEBkiSvsv4ewHoPOPEUXwalTsUE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Jan 2026 14:48:51 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We introduced the bitmap VMA type vma_flags_t in the aptly named commit
> 9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
> future growth in VMA flags and to prevent the asinine requirement that VMA
> flags be available to 64-bit kernels only if they happened to use a bit
> number about 32-bits.
> 
> This is a long-term project as there are very many users of VMA flags
> within the kernel that need to be updated in order to utilise this new
> type.

Thanks, let's give this a run in mm-new for a few days, see if that
helps shake anything out.  I didn't add [11/12] due to a significant
merge clash, but it compiles!

