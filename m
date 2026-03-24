Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8208DF532E7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 23:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9D26B0088; Tue, 24 Mar 2026 19:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8995B6B0089; Tue, 24 Mar 2026 19:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788216B008A; Tue, 24 Mar 2026 19:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6201C6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:12:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7638914048A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:12:17 +0000 (UTC)
X-FDA: 84582507114.25.CFAAF84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA6D0160003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:12:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QLTwz3SH;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774393935; a=rsa-sha256;
	cv=none;
	b=VmvwCm5zR2eSJ8XQPo837KBZS/JV5lQnv56/Ota9+gVLJGfCmPefzpldC2qkYdeGC4hbpk
	QgLOxYZZ0mDlBMksNlyPCS5unQSROEkPjzxCTqMJ1LvPXeJsq778ii7mWwlgkXi52AXIpo
	isoaZ6zwiwhDafQKYH3/LgOMaysf/HE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QLTwz3SH;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774393935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eD92WmlD057XTMfLH1Z3GAggqz7pk4b/GXmngytedTo=;
	b=FGO0GgqE/8ellvqIOjrAl3yXxcwopKaUpRtkaevvn8VANrWOokCnLNtwpt0FhQsLusKwoR
	4IDziGGg7bPceruL7xnd4Vy3T1M0VfB51rY7n/Qo5UynuuPx8ewCDq79hHjbhxNN0Ss4Zs
	02EbkePkMBRWdpE85kkdL6bd0CMtk1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D603660103;
	Tue, 24 Mar 2026 23:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B43C2BCB1;
	Tue, 24 Mar 2026 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774393934;
	bh=ptwwHbLCf3qQFNvLf2dqckDDyShAhKmxD+qHZ2Ems8w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QLTwz3SHw1yDMUT8EK0RImQOiTezzgyIr6GaoUCK96d78VHIYEHGoiZrsBICY0RY4
	 prdPg7dDS7EU+/v8oFdgaCjXtOnqW1Knnhb837S/tRUqZeShz4gGiX5ErTjUgItBsG
	 VAlZfcP28RfcIDXSiBthAZwtM/tBDNz0XMg79lmI=
Date: Tue, 24 Mar 2026 16:12:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-Id: <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
In-Reply-To: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
	<568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tcec7u9jerf7k5jgeusaw86bj63wihq7
X-Rspamd-Queue-Id: AA6D0160003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774393935-7655
X-HE-Meta: U2FsdGVkX186+qwFrMcc/QyqP32Y0zJI/k7d2tNHoi38iPhRBJ15LbTWB8h3PDxj78RrUa3yilmMdu3ASX5RUSDKwGE8q/X6+aaOD1rL24UqsXr2ED15ptx3Ew3p1dOpyACea6OT4xCVztrmGJIJX1sjLVuqBs3pzisFxz7jEoDKkW51ORg2OKVuUzHvH2zEtygvYp/A7D3fYA2KK8kaygyOh1hjv3tpmu94AdiHnY9YO5r8DncO95QOpFT30OVo2XLRs8guI8csbedb827CvkXM5uB4OnGOSmztMWa3AR7ZoUq3ZIPq28tzIh85ARCdY90Tj3e21VN11UaNCNPsF6BvIFqO+Ky67LSS4AoF0cVgdHGVn+6Xfb7VPIC4rYXz9I662AZjI3jfP1+f6MEh/8O40jr2Ul811mWUt9kjJd0b4/3+bDijnS+t7OSQfDMeiHi+cWuxAmru2c7oOsLu/gwCDeX+Ms2fbZlaB2GRRQuHjcFyGJUObV5J0XlFzMwgveyR2QgCA7ZTdJnAR+ZGiT0ypIdk/DRYGaOsIMbuOZg79hHkMyo67nseJtGs61sEElZv9NynsRyB/bw3b23vn0/8rRtrAKZ1ouqUQXGWqmUwdhCShuy5WIh6lmvh53+66M8yKp0moB51V+ZfeyregGXnLyNi6D8MYcNT7PMFFnLZInWy53gsz85BFs+8zyRx/1oeHyJEVQCqtqiXw2VnOfrk6A2smuxxx2S7SmhemgTWLLrS4qnaT6UvYEK1bC8ljp2OtjFC24uPyA52uJ7AHSYTGIpvagxdd7BRYkvDOcikR16cJcX48Latqg4sFVjCjeWdZpVv9jWuQ+YT603Pub2Xnh1IxFmQljPsU/h3XzKFmixKAqgYC8+PkjZiOZLEkzLSUAZy1vwbumaspMb7pi7xS18nbg82QZXxZ3AQC6D2Z/1VovDbH0mpYBM4aKj0Lv2Ha1a3/Xn3j3YRR3b
 zOUX0VLM
 r65Zxroj7AUzUuBLkg7r/+1ku25tWlk9hg5x80aVXWXfPH2vENKfLLWq9lBPXpcKYfJiHA4sJ/fxZovgCoDXpLo2gfBLgGNjsv6QAItI1eGJcQB45xRDL721lIGdaGYlrLdvCUC+rAZvj4Oqyub3K/8AaW25/EBj1rMcwSYNHVbQNjPjBIxAb6HtFB9+/um0VUItkhi4OoRv6CaYL4GxnD7EzrawbOHEOtSNe03HYlhu6mRogaPz4hebmyc1vAbFasyNdRiMehcaZvCA+NPi1N7jatbc5qHt5lG/gtydurg2idYre0rPceQA+ulxO9C4/xwgZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> it.
> 
> While we're here, update the helper function comments to be more
> consistent.
> 
> Also add the same to the VMA test headers.

fwiw, we have no review tags on this one.

