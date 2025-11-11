Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39852CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 00:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2797A8E0008; Mon, 10 Nov 2025 19:17:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251468E0003; Mon, 10 Nov 2025 19:17:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167488E0008; Mon, 10 Nov 2025 19:17:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06B838E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:17:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3B02160315
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:17:51 +0000 (UTC)
X-FDA: 84096413142.28.155E639
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E674218000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:17:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vjkeLHDm;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762820270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRa6a9PTVAKzZIPhPoFYhNCRojY7+kwf6ee46naNTlw=;
	b=hBvrnc7sg6lSf5xlVD5YflWQjmZdxZq1lnvy2Wgt4FwN8A2mfDUwjysqpGdRcyf0tjIk7q
	UKbqqfzgDBWS+6vrc9IG7gDR4Svr5HSlW6nJeRd/kfJlWtl5hEN90b9BAN/X7AF/BoojC2
	CLzX2edFUV0hlkw/JntSrJ+ykPEcFNo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vjkeLHDm;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762820270; a=rsa-sha256;
	cv=none;
	b=OyWqOxuRzAHxskfJtDqUQ+D8JvS+kLdXY4shPxgce2m5DuH+rSgV3wrIdoOSO23jwASm9g
	iGHswvUayyvDNfeGw6CzlwyPgUwgGdDbqgTUhyElbcTbA9Qtmg2rXDarXaGxyQf/3kxtRd
	KBJVmA3y2CsoqlDDYf4C69c6wIUcPbU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1776560195;
	Tue, 11 Nov 2025 00:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CB5C4CEFB;
	Tue, 11 Nov 2025 00:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762820268;
	bh=h4IOFDJ10o8gxsjF+0swXOnDNA//+lvIGav3YD5mbm4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vjkeLHDmhlbRmdh2J8YEkuADTnOje8197r13F9Y+9M4PNEGyrIjTsJrXa9FcWBd30
	 3dmWPQqBvqXKMpha7c0qNKjQ5ewY10+fA5vTYMX7SAz0x9GQP2DAUfOdVKd+b+ILms
	 w4QnZBmAPYCsSnhcOO+V0J4HJESA9uFYopLe6MVY=
Date: Mon, 10 Nov 2025 16:17:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, David
 Hildenbrand <david@redhat.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li
 <chrisl@kernel.org>, SeongJae Park <sj@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, Miaohe Lin
 <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro
 Falcato <pfalcato@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, Rik
 van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins
 <hughd@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-Id: <20251110161745.2075f263e3c693bf65f98ccc@linux-foundation.org>
In-Reply-To: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E674218000F
X-Stat-Signature: fr3ny8qr8t6djgyutift56drnb5qkxma
X-Rspam-User: 
X-HE-Tag: 1762820269-557263
X-HE-Meta: U2FsdGVkX1+o/e4G+9NCTd/6B89FG01Vkog7/CYRQx0zbd7FrfiA6DpRoEVDr1wMAasFRIhIGwzzjZT5WvRhkPr+GYzg64m8YyXvI/cPD3/OgmqnIqAm6VACL2jgXfUeDSt20Xgtj90wC6ihcAL7qOJO/GeYyvSO1+frvHdNaJttm3B7TOm5zTz3X7bW8wMcdMtapcSzEGaPizijduWOWn1FzBg5cXE3dQdqLQC0QSG/HUbSeMyvMaV+WRK9gN9SMDJ0cDwbn/iUC8amT69ulnMgocxCNm9cXK1RZlxwiwUH47LaqgUgPVnu5YJxVYBjwd62cXp2QQvRPXekRrWyXjcOgFeP7YdS4fr5XYYrovcvMtthFk/7fOUeDjQpKmKbZkHgYK91PI986lyIECaAI2sOsAMrHyzcNNQnsNb4IL9bnxJ7RO4S2Wbva9SbpNumIeMh7j/DTgoH1yF2eHD2iHQzFEBNI3nBXMoh0VVWBsv5inNypFSTPiHDG0On8yMnTYf1qqPATfM/5KwKJuOaw5owfsNdN0B18zs12hOGSIYEkMIlo4ndCh2HwPtGIReGXSLpHWkPFTEaIIuhWXsoD1P21lik+ssfTrYhD0YUHkm8ztTqE/5vWZsiT7gliqiInC4SPB5elRaNPXiHznVJMWS6AonmraC6R5XIlF2TUj6azNxkJEEe8OCf1FGaMANGiSNx3zK+yct41ihESc+XbAZnBP88WdwxpVw1blhesVE73OC8x94luYawP4H+g3U67UBzE43zIkVkPUhvomHvjsIhIKxNk2oo7frOIWOOaogRe9B7FC8z/rgZbTMFvcpW+Bkq6V5IYLvaD6miYEgij7kmJdQEgb7LhrOImEGFPR8+Lah+b6rXangmhYLwXF2O0Mc0myriejrTp9fFi7v7k1kjIw8OGq5gBPQJT/CnA8DuPjrVbW3MQgCUTdkHuJADlquBcqMat/ThK90drVi
 n2KCOgHE
 UABHZQw6X6ki/4xBElbi+iW2+2boJu0+TJjJZOIxrty0GlqFZE/EuMsXZ8TuVJ5sGa/a8UUadVdgzUE9fxDRygBQq/EZEJ1iWeKcd4m4qtEKGn5D0sVAkoZ35DBxuP3riCf3+MIsFxNlMkQFvHGqQbKgmJIoVF5E196uuqijVD3cS6JC8C9uC8eBvO8m8pqNGzJY229GNIfLeIVTCnTOGp/lddIKhLdKkT6dgZuUUOjhUnIOK7CmMNiTfxMSCyF/PMyfZBRXfT6x5vUI9HO/R9pM2OcGGu8uibIBXPoQ2ok+1ijyU3ivldl20J7ux4/5pCjrRameQCT+eU3KKDGJAsvOCW4cFVMYlMqejc0whTjnYmM9JsFpi/Gh264ahjjedFed+lC8+Iy8YcEI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025 22:21:18 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).
> 
> However, at the same time we also have helper predicates - is_swap_pte(),
> is_swap_pmd() - which are inconsistently used.
> 
> This is problematic, as it is logical to assume that should somebody wish
> to operate upon a page table swap entry they should first check to see if
> it is in fact one.
> 
> It also implies that perhaps, in future, we might introduce a non-present,
> none page table entry that is not a swap entry.
> 
> This series resolves this issue by systematically eliminating all use of
> the is_swap_pte() and is swap_pmd() predicates so we retain only the
> convention that should a leaf page table entry be neither none nor present
> it is a swap entry.

Thanks, I updated mm.git's mm-unstable branch to this version the patchset.

