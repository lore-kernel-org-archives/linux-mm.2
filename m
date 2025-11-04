Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0FC5CCF9F8
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 01:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0908E00D4; Mon,  3 Nov 2025 20:13:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8048E0058; Mon,  3 Nov 2025 20:13:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDDA8E00D4; Mon,  3 Nov 2025 20:13:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAE0C8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:13:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85676160362
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:13:59 +0000 (UTC)
X-FDA: 84071152998.15.4720CBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F279740012
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:13:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MXiijNs0;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762218838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EZqMExrBlq40ZRP6BWxMfVndpsjeirYG7cQXkyRxsI=;
	b=K3EvDqcXVa1gkep6jHNCov9RRajh/JJ6cuf2A/kvv424iUc+7dgPaNTR5g1nB89rubZgyD
	xyxgx84Wa//HfjoSbgRcGZlvAiAyGwsnYude2MKt85nzfYa3Z89oKzaUUD80rZaLAPu0xp
	do+4x4HPMSxQhD8G+yVCUCdhqcCsuzI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MXiijNs0;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762218838; a=rsa-sha256;
	cv=none;
	b=puZdZO4jxYHTN8VqmqEmkPdhgjiabKYpoqperJ88AE/qEWoQrIME2yomnxfWTVqXHx6ftd
	seriK+JwTGUk/JvkxFP7kO46fb9BZdJiliBN1S8Da8yhM5uQO0fsXAUyVwgVWgsnfE1nof
	wti1i9W9VApk1LmOtOj7eruqKvuOy78=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EFC0601D8;
	Tue,  4 Nov 2025 01:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF4FC4CEE7;
	Tue,  4 Nov 2025 01:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762218836;
	bh=g7+1CBZoXgMB9m5sapw5MTlDDr4R1niG6p5OTGYxjW8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MXiijNs0dGLzPm7ExN02p9fLamNAS3PK8usLGn4WUjz1zDuNgKotkoWoll6bFAcCZ
	 c+DX7hIKwm4DgEsPCtD3kUf+z8RMOay39KpBJN6aox4BmnB/K49oGznndZHewdwfAL
	 cQ5C9jPS31+fy+Dxn1r0V+f74Kv5BDm26YQZF0TQ=
Date: Mon, 3 Nov 2025 17:13:54 -0800
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
Subject: Re: [PATCH 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-Id: <20251103171354.bb28c06d9e83bdd72c3bd648@linux-foundation.org>
In-Reply-To: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F279740012
X-Stat-Signature: s7hnjiz57eg9zy4uoiaufjg69mjg15hc
X-Rspam-User: 
X-HE-Tag: 1762218837-385840
X-HE-Meta: U2FsdGVkX1++VbFngbwu37GpMqOYIIbGX3Fin9f4tT1UmoAaU5CIcWyyBoM8+9eC/b1Cpzu2va/Jrb8ytQdD72egAoy6xfVD+E0UUWO3zdXYrpCUx3HeMG2Th33dQ8Q3W2HySg00I5ZZrhIJ3ZaLWVPGXMVIB4FWYl8WSI9SaI9QdR4q/OzyFp6pahw+u/KNGbi/HmlFjwPIj53G72u/4Ny6f9QIo95OWkA60n+gVdZZcj+qyzcaSJ3VFebpph7eeSwz0yBmm6OS7y2PYU1gnA6Jpd8zh7qscY2GiHp9ScH45fm+pvN+0g/zohc7pT5DJ6myVaeAwOn/FNL0WhsXjJEpDuTEeCndbSnziWWVMKrgvCOwCqG4ZnYAtjBx347hD8om8jRONU+hEtAuaUXJmSnV0Smb9TgkMG/EIFtpOLywf7til631AqbEi+tgbYlXTOQY3AH9I3qZ6pXG2DNkKlqC76V0jkSRSVBCHRF7LJ7DS7taoy55Y1WTwlL3+Xun+SJKD67T8y7BRIvYItD4Q8tHKmj1SyAyb6RGdehpToNlDCNAa5U2lgoHF2RW5NNhvXbLxwfx8DnOOPuCCusQoavFt3A7rH0qh2iNL4cbI3SAm01EXCxHLzQtgZpnOicsDdBNNVYXMHKTD6w9Xcvw8zMiIC5YRaPFg88PHCul6bgGDvzhRySYSPD9iQ4+TCbJ5yfcLxt/ZuaHGXUIS5oOm7oXqGhiiKV9SG/YGXfTxyFhuJ8pGmXblIlsaw2M/5sXjCaqXLYGGGwAvfBgmOdgqUJP1GNNhQEgTsAkPKgrrlxAHkFBgsnNPYUI5hhcMDY4YECh0IN5yEoO5qQterNhy5xcKdxkHVyPOwX/ogjatxJhz3pS9BO5/EKpQymvn9fiB0TKQxwsim1Vi74IC8lx41Iq93D81MpZVvPc/MoTIGU0LLnCfFt17dnSylaR6B6yWCI0KjMYFpGFtR8ojKJ
 yGN5lSLQ
 UUcRrwe3/ZycOnQTj1C/722/ute5HBKe7/Bb9GYgIMKxKRaV1PSYRiwxr6rqftWMvD7GAwj7vSKpDUa24/f3CzB7dphRNGEpiN4D4d1b2NAcV1jEkRN7LDiFDMmYUVMfjqEcEUjAuiJ3vghUK6O8G1R8Bj6/5hWa2DLuUlehfbdru3LsnnXX98KP7x8QrtrV3wNUtThbNkLyKEHeQic6yOIaRooVDzOk4F5qoNwOppBTJLg7Eep7lBlXspSi0D0Zls9IXuFY2lrBYK/haNPbM/uqH3lULrX/Wfj32eBPkJqVtfiLAEnrnOM/FnYMdMCZJ/oWFqBEPEU3UYr66waJO0CrTpO6WFJsgJa7qw2uWD2YljuuiTcWWfUsYXt8GwBf1dVoTJjX/fQOkdK8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Nov 2025 12:31:41 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).
> 
> ...
>

All queued up, along with two -fix patches, thanks.

I disabled the customary email spray.

