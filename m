Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A87BC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01256B007B; Mon, 20 Jul 2026 15:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B0A6B008A; Mon, 20 Jul 2026 15:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9545B6B0092; Mon, 20 Jul 2026 15:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68B896B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:48:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60467C0288
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:48:17 +0000 (UTC)
X-FDA: 85010191434.28.91A8B13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 97A1D20005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:48:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Kk4B9AnZ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY1azwx4jsJQ8qPk/eyE9vAbXOIQ9l1CV/aEbqxCteI=;
	b=2fDpdQdeJ/aazpmdJXPHoqbuB1dLRSqYxpsEl/ajchOrFd/lNCvKpjzD3n4+1lzcPa4qH7
	b0tCQb6hJOYWLtUf+2/MmEEb38Lkxn4rtMkn4WfyDgH0O09y+82YO2HB0/PzqL/o+Tbbs6
	E7cQet3KtN7pHxMuNHRCRGo4Z4zcctc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Kk4B9AnZ;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576895;
	b=htZyFVngUtz2oWl+HR7W+uKOJLwRvTabCIa3BWZB/ciIc+++5K3yregx1hOWBJsX3tJytH
	BeXXX2wENCkFh/E7TbxDWiyi8QdzCeldyS2nB+oQb5+JWn+awOfXyhnUefSlk0FWChS6IG
	QgobVNZB+euSl2+Br0pnCmhoCcBDsWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF9F860A7A;
	Mon, 20 Jul 2026 19:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714FF1F000E9;
	Mon, 20 Jul 2026 19:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784576894;
	bh=bY1azwx4jsJQ8qPk/eyE9vAbXOIQ9l1CV/aEbqxCteI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Kk4B9AnZqoB09H/QyCds+vQW8ifZnmBuX+TT7CXqkZYAze8MiNWDEn4/41loU6QuY
	 hFZkQUANo2EVXCBtP+yWrp+JWh6cfKRs/ZllD0E8MSBKM6mgtRgiZaDeEhLncUVbCG
	 A3Y+YWhNRQRMWuxYj/yZg2zIy65cBzbKo0kKabBo=
Date: Mon, 20 Jul 2026 12:48:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Kees Cook
 <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Arnd
 Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 00/15] mm/rmap: index MAP_PRIVATE file-backed folios
 by virt pgoff
Message-Id: <20260720124812.30e04cc81a56dd6f0346cdf6@linux-foundation.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97A1D20005
X-Rspam-User: 
X-Stat-Signature: ym6prumwdd13w4u1sjjx45wt3q3rzomq
X-Rspamd-Server: rspam04
X-HE-Tag: 1784576895-391408
X-HE-Meta: U2FsdGVkX1829r4J3NU8wzr1GYGjGCiOrKnEGt+OHJl+85r4SuAG4zmzs47j1lyRj0pZmD8sbiowzs/4KsBBnDTpwO4pi/7xtEAAy2/ZT2s8ssVBXLYxLwsbGPbIgo1wXsTfDAAAFXpKigYl3EidKE8FW56I8U0OMV/DpSOmL9b9OIEHdJbxpdzk5par+AFfsGG/BMXtDv6Oc/Wl3AaSg8nXGj8ZBMhoaipTo0ZOruYMRiBxE5TJ81AEmOnto/0lCewFfujRxVt6/fgo3vnJb6I9LcZCSNrDewDCcBJfjnYN79wIUIm60wSZaurFwLiywMlRS7VlCQ7dQbEVVyfoz3nRr4r5MH++G8+ibdp4Z1vTllo6QKkmHa5pqn4uENquaMA2nrH0IK69VN+13uttXy0asAHjyOQIKTi+oZhsblb6UQosdoC/OSzgThNbZwZqJVawTf3FW2AD4ybjx1InVMglRim7zPYlBT7d76bUue0atyi6lmvmiwPM33W8d89vZTHA2/ZZzKm8zHB5nYIDvmg/qfBlUuUS7oMAsQQagwKpk1Bt8P/2FSCtEmgxZqevfiGN7hYMex1K0SqiMzvAwPJkxptT32fVCEHBpGYP1nrA8rbZ1MK0NXCp5K4vSqlm0Kr/XWolm9dxEMhOgHUij9ASxvFZa8V3mwrbTigjTEiWf368CWM9/WDM0S/fNSxNyvCeZBLL93Ylvzia6Y0P1QpLytDrOzxzf+L2yiqTMConW1rKXWwUtBm04zKDsN8qgMuLT4pSTFyVRTy+9rTE6PFRLsALrXDSJeLKdRXeHOtJ6cMl33gdZAPt+6xPz28im69Mf1iRHxxg7T8ISQevEjJQYNQQQltoraBMAf4ElnrtuRKfhRw74Q3K8ijdQaskvGPksJKWGLolSFzhCwXZIX3r/+To2BS92SlQNRrrqa8wIa1M4MyZlKcvfCEuGpVB57td0X3NMVj6b38LjeU
 BaOBAYDm
 BxJyeHmhht0Fg+MLRwJPWwZnXY9fQPnuXW94WK7tkVzI0bcRhLXLZt3v+wWXdooNcWjOxSrC7ojLKSfXNdKbHPCAIwCkDvDB0zbtWi11bl5k9eUqOqqz6QF5xCJjTpCy15+mfaVyWa/axzLFqN0lLMXZuJjdn9NYbtplKAxPI4f6vv7NaRCAWHpd54mAnrvfRCsaYfNXHocycyUJ22G5fAVmLQqYpuAzF+QF1CKX3PexjjHn5ChaS2XjXuaFri3hCoZ4GPekrbi64+3p3dv+XRqPcmqvHYWMv1SjujDlYmMXEG4oN/JJ1rI1w4Y/LDkuE6wQB0zUnGIaDLRNwxzw5wG23xK6qq+ZLuByLPApgi4iHwPlPLj7JbJ/aGvtefpwQtbXROBDpxmbW4/0Vi7E0gJjYCE5iwcTLcHdgTLz22axiiyO4bxJgUotgixJibFmraP1rH0ZPKYPnREk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 15:38:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> In memory management we've managed to manufacture a great deal of confusion
> around the concept of anonymous memory. We have:
> 
> 1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
>    swap-backed (thus for reclaim purposes, treated as anonymous). These are
>    simple enough.
> 
> 2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
>    present in the page cache and mapped by an address_space object, but
>    whose folios are also swap-backed (thus treated as anonymous for reclaim
>    purposes).
> 
> 3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
>    vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
>    satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
>    referencing a file, but are in every other sense anonymous, including the
>    folios.
> 
> 4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
>    and have file-backed folios until CoW'd, at which point those CoW'd
>    folios are anonymous.
> 
> This series fixes issues 3 and 4.

Thanks, I'll add this to mm-new for review-n-test.

AI review seems overloaded at present, might have found a few things:
	https://sashiko.dev/#/patchset/20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org


