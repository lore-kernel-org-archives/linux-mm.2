Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AA660A2601
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 05:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jj7imCxL
Received: by kanga.kvack.org (Postfix)
	id 7A0BB6B0B34; Sat, 24 Oct 2026 01:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B776B0B35; Sat, 24 Oct 2026 01:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618606B0B36; Sat, 24 Oct 2026 01:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 396856B0B34
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:33:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A7F3A7AD0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 05:33:56 +0000 (UTC)
X-FDA: 85356403272.01.D20343F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CBD24A0005
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 05:33:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jj7imCxL;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792820034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bD4W43pUpXqutJS8BdTi6cNfD5w9bG7qp9SO761d/FM=;
	b=BMaQ6IBmzz2nzoUyzovTZav9YU18KAakaVaeQeEKFvPiTmi7Q3cpJcBQmu7PsQVKsbczPT
	Yilz/qrNkQkfAUBmBif2aNwL2Y/zSPRT+WuE0yjRgd/pzCSWP4whMiqpBNqv8o68lJ0F6A
	xZZZCa3DN76GBkcH3sDIZJ/LsX1xAJ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792820035;
	b=wqnnRja7QOesXjP2YgDxkl/QyYOyTJDV2G+zr6kLCedKSy4JbS0cjsRRuvtmjhttB2ujLK
	7mKfeNMX/UN9ZPqLB7P8z8hLznqXjJzm16E2gfnG94fKsUzI05bG9LWW6HuhagAHfBmpGe
	1/jyj+cwQRGTx2Y4fZ8nNQhyvzjr6EM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jj7imCxL;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C0FC601DE;
	Sat, 24 Oct 2026 05:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9681F01829;
	Sat, 24 Oct 2026 05:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792820033;
	bh=bD4W43pUpXqutJS8BdTi6cNfD5w9bG7qp9SO761d/FM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jj7imCxL/O2GcEZ6WAJ2fvkEkHX/X98ciZQtykNn3xUJflybmBO/Fmqph0y2S7MRo
	 BwytBJZ2Lyic/envHpJqoguzNSwUyfYaUHhPZpZ1IYp7Tv9Cy/NAaezxTS/P39AiqA
	 PB/OxnWHFrW0BB1qhvb2JNJ7YoBokrnB/4fJI0RM=
Date: Fri, 23 Oct 2026 22:33:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samarth Narang <samarth.colleges@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Peter Xu <peterx@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Lance
 Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/ksm: keep soft-dirty when merging a page
Message-Id: <20261023223352.c6de9f2b58fe999814e5bb17@linux-foundation.org>
In-Reply-To: <20261021182157.1873726-1-samarth.colleges@gmail.com>
References: <20261021182157.1873726-1-samarth.colleges@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBD24A0005
X-Stat-Signature: djn5bhjn9pamwchp63ccqo53kf61jy9p
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792820034-657974
X-HE-Meta: U2FsdGVkX19yU8R/4kDhmoavvB4hP4iqoAJ/+cgSfD42wdMAtx0hU2hh9V0qWN75uD37/T7Z5rBShpjzpxTb1plPFo52XFdG9LW76kd/nm5+TlTMaVIWSs2ySPWhrivh+r5uqGNyQYFD8TJ84KzD2dxLCe203FAMWvJF0LUZ4qbnVNC9W/Yox/QDO1GrsiMfuTmjqVzLf0iMnd4urcmNyyh0vCNA8elxsdpe97remYZFaoW8XMNBN1WEg9G2pAZXC1J+1p/1AevubPybLgH0vRaI2lkXSwohQJDBwI1vKNA5yrel23zacOUPgSugtZvAuia1JBvj9S7WocIACEdMEsSs1Mno2ttgVF/zUndTCHPJn6gHLaWx90uXYFfE5QHEjBvQ/9fysA1SHpC+Ytx4wtR/WePc4FZhz8toK2LcFiq0JkXi07kFsWRSJPKphRMzI2D1Q4ez8cc53wJqo3YpM0PuvCLZwhUxNIDY3KIVx0wZ3aEzn3t0zZoZTKdwxRP8eXIo3l7B3ZM5ArH+dAsG3/5cP9GnWE+Ww611s0SwtZu95CIasrLOxFnSw6oZin3JwJb46/5lXuCrgkLYVtqXObt1AD9qSBEBYLs+3Vah04BwqFAhwTBDgfmS8Fo0xyTndJX4a+pI1+PaSAdCLO11FZAfzz9/ERsGujsUcuwuAKiM1du6umZWEwQKXRji2mxIloDf6XFHTtwgXtk0cm9FHSDlYVd4NOl36+NWLU6znw55V2G5osnxhIrdKvaqVL8R1dwpdy3pvSw2s+RxCkIXyCKnOcFwM5v9O3+KWZWNB0Q9FdH6o9K8Y+RLKLKfeu0gSsZgAOGjcGNYjXLDuna0jfFaloHS7YsqsgQ/46K3GhCNPgggdeBK7dr3HXBf8ZO7NN3YzMwBRIWoRUV5J9lQ0XnDs8Vk3OAva/J5BYPfvDeafQH4UZiy3AREk5n7rR7SXvqh19OCu+t7m9scweu
 BMzS6umZ
 Rf179sq0hAJjE35r1+sGOzSV1AwGl+xdE8jr3pNguwFrhHGDuenW6Hj+iACoXRvk4jf+0GvtyMHjQcwyksxtZh1QLc2D+fepWyA+qibqeuZdUoqkmyKZjQVI7txAqerZKNwKrFCZzt+2dF6yL3RVrVy08uPQqREL6595STGjqKszD2eyseDWcHZcj5IG+Ax1cxQCXWDwhRe4IzjOfotYuLoLJ/C7lD4hhiT7eLWkUnITKuv045X5eOxjgeRWDPQoxRJm6mLIh2p2LG/hi08Jbb/YR7xjDGtWIo3cp6/PYD6xkHH25MyOI2A/3iaUrNCkrMixrnTl9mlpxiJnIngUQ7Owk8EIZpquTTtsv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 11:21:57 -0700 Samarth Narang <samarth.colleges@gmail.com> wrote:

> replace_page() maps the KSM page with a PTE built from scratch, so the
> soft-dirty bit of the PTE it replaces is lost. A page written since
> "clear_refs 4" then no longer shows as soft-dirty once it is merged, and
> a soft-dirty based dumper treats it as unchanged.
> 
> Copy the soft-dirty bit from the original PTE to the new PTE.

Thanks.  My LLM review thing says:

: There's a separate, pre-existing problem with the KSM zero-page
: path which is worth pointing out.
: 
: When use_zero_pages is enabled, replace_page() constructs the
: replacement PTE using:
: 
:     newpte = pte_mkdirty(pte_mkspecial(pfn_pte(...)));
: 
: The dirty bit is deliberately set so that KSM can distinguish its
: own zero-page mappings from ordinary zero-page mappings. However,
: on x86, pte_mkdirty() sets both _PAGE_DIRTY and _PAGE_SOFT_DIRTY.
: 
: Consequently, a process can clear its soft-dirty bits through
: /proc/PID/clear_refs, perform no further writes, and subsequently
: have a page marked soft-dirty simply because KSM merged an all-zero
: page. Userspace then sees bit 55 set in /proc/PID/pagemap even though
: the page hasn't been modified since tracking was reset.
: 
: Your patch doesn't introduce this problem, but it doesn't fix it
: either. The new pte_soft_dirty(orig_pte) check cannot help in the
: zero-page case because pte_mkdirty() has already set the bit in
: newpte.
: 
: I don't think this should hold up v3. Losing soft-dirty when merging
: ordinary pages is a more serious problem, since it can cause
: incremental checkpointing to miss modified pages. The zero-page
: case instead produces false positives, causing unnecessary copying.
: 
: It would be worth addressing separately, preserving KSM's internal
: zero-page marker without manufacturing a soft-dirty indication.


