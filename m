Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC15D2ECEC
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 22:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D006B0303; Mon, 19 Jan 2026 17:31:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510B36B0305; Mon, 19 Jan 2026 17:31:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418F26B0306; Mon, 19 Jan 2026 17:31:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30A426B0304
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:31:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7E39C173A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:31:49 +0000 (UTC)
X-FDA: 84350161938.15.BEA62DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9B76F40003;
	Mon, 19 Jan 2026 22:31:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OxLgiN48;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768861908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sfcSb4aAL+vVPEjrp0LaN1Fyzey20qP7nfJzGXrgRU=;
	b=VqgXP8cuznMl4Y3icS12pd1MvSVHZibyDjnkQbM7aOzHjV9XTt4Gk2AtpNFAajQJA0FmWA
	xro8khLZOeJDBpZghZrKtLZE9fMROpvlHDePfZKQXdk2hj+JjNFwtVMUv/4hbrZ/DKm+Mk
	ebhdQT6HE2RgsoSX/glKiSGQ4LFdUGs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OxLgiN48;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768861908; a=rsa-sha256;
	cv=none;
	b=oZGPHWZ598Womp3N3nu/C2utr8bZXQHQY4RwUQCEIa3+RPLNJ3P6UWDSA24N5lo+ufR41r
	LVZzE2Hk+e8iN3qXdx9/SidttP+wwVXnNDj5jOSCOatIEi+ok3BCEe4O9kYXJhPrlMeAnU
	uaZm0wOAuNxPCMwGhrG7EeQki+yTfxw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B8095600CB;
	Mon, 19 Jan 2026 22:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F3CC116C6;
	Mon, 19 Jan 2026 22:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768861906;
	bh=oqpIfT+mzQAk3T54PAXHp0Pm+DiScyEeJPjtbgx0I5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OxLgiN48khFO0GWIVMoWXCGqPJd1B0QeRfpnolsVbzO9Ah+tj9WEQjdNWBCwaAxyP
	 sKfd47WNfJg3xDX+c5IoTe7hliHsBtLSPxt2wGvkBF6ii0NOHc74kGfgXtdvMJwOBO
	 ipLOS0CjlE2AYTphl5NDpqC9ARu5y0Jo6gTUGpmg=
Date: Mon, 19 Jan 2026 14:31:43 -0800
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
Subject: Re: [PATCH RESEND 00/12] mm: add bitmap VMA flag helpers and
 convert all mmap_prepare to use them
Message-Id: <20260119143143.c7ad8551748eea4ec2b83340@linux-foundation.org>
In-Reply-To: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
References: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x3djnbhgsimmckgw1akj169esbwk44t1
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B76F40003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768861907-882736
X-HE-Meta: U2FsdGVkX1/1z200J/7iVl1LZ+omRKyb/JkdteHj7JSTN1xv0NzZuqyVzUr60tkxrFFSjKtY2/jZT6sufi1om0ODfwt4Ggtk2zUwUTLl+QG/lXJG/7zacyuAgoTX/gB0OUXMXiHrMX1EOtRZsBYdmxhE1+DnjgERDoi3OBxnL5w74gwuCtVZxK65CfcRZiUWRJyJba/xpgTBRlAdk4OBfewBi2hqDlCvBg9O7+oSMi/K6n356ogE6jWgJ0Z+98PIPWKCRt9dLvQ4xiCWTMHqcTEFJMt4dOpmz/HH3tSAf5Pbar40dNRidxl3TwQPUWTnuos7GaLizc5sTOEgi3GKRsqp4it1S61GX9HEEqFOEaw7E47ptF5NPTlC89qgzU8SLdt6BYfCVj/2OYF/xt+xEs6eyq0JLBSKOHyN/tvR4Ono6f/gh7o9fCdQSQ/ZMwg2YN4JNilOdQo9dE7evCSXNW//hiU7nozebNCMSYhCTgQsapZ+MlRrvh4QpIJMjlLj0nvLdoLtblalvRqgV/tT4if3i68iVygwiOSP9cyx+7ubNxdA4NEpoIc5y5Y4udym6e3lo1wq0k66CBVddBssRYMeT12cWMTp0yGw1U5uxnfx22NaSX5XktpbkUL7dRLaT77zk4So5puCI/4PKxCPFTbUjVXmW8GSPmFv8nT9b0H97Sy7jlvLolUT7mQDLFhdwQLVRKH5QUxdWzYLS4JmPdUzBMDIOLpjzVyZlDy8XqhyprpcZoRsfbO6OX+Ih+geOxQp09qWo5Q6aHTfVWIw+zxfFq19lAi9wbB/wdoHkZRYuaE8LAcRc6gCk/ddMsAu/Pv2g77hXJ8EHOPO2uBgtD5+64/SxY+uoGt7hogyy5LZyyqMg8nD178YjAUHA1/I0FxrKi/Q91arQ2BgvRNd93wbAK37I1WGRW/yEKOHITQ13eH8wp4z6a6ARwCqfYvMik1+eC5Il8wUp28/z36
 ye32pPo8
 5wCn33D7vmz3Dwl158PthzNnOQt+kbFS9xLUB7nOrnDv57DQZ5Khd0iw253qyNrdRirmq/dvVfdf3VQscsQah79VKggL/TVy9yrs2+ZO3VYrwrpa884Di3E6+MGX0uFwTvrwMFS+sTklQy00H8k1nEO6C0JurM+z47T8HjWH+WcvGYayV54ex4qic16hYYkvhTaCPcuxQM83/7PoK/wLK+eVQKumpgeRirfuVkfXCSJyMf9AUZR70KQyrmlW2Xuam/FyjmivB0s47Zwt9YP3q2bTQ0sloyOB2bH80NjS587RBTNjzJMm69JPXHsy9/lupOH3oP3lQgA/FHoX462/kCiR5ZTn3XsF0DTvfOWUMgMS6VFkSCwxm7RsHEWpwv3VHpOkQK+/Hedqf0A0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Jan 2026 21:19:02 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We introduced the bitmap VMA type vma_flags_t in the aptly named commit
> 9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
> future growth in VMA flags and to prevent the asinine requirement that VMA
> flags be available to 64-bit kernels only if they happened to use a bit
> number about 32-bits.
> 
> This is a long-term project as there are very many users of VMA flags
> within the kernel that need to be updated in order to utilise this new
> type.

Thanks, I added this to mm.git's mm-new branch for some public exposure.

I suppressed the usual email storm.



