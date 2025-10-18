Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2009CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 00:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A918E0008; Fri, 17 Oct 2025 20:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D7F8E0006; Fri, 17 Oct 2025 20:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BF18E0008; Fri, 17 Oct 2025 20:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C94738E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:05:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72675873D3
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 00:05:30 +0000 (UTC)
X-FDA: 84009290820.19.24F9032
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99E3FC0007
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 00:05:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tvRVTBeM;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760745927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oY6N/lBN5FlOfSHzcA1jBCtadbUB8Hg0qATOMCPeIW4=;
	b=4PNTEZDJIg85Y4UOUYRJuf0t+ru4mZDJ5Sn/VPHkR6PbEpoVOiBViQC/7XOHjI2xvD30LP
	5RSw8Pg2912xKb67PuaaeIs0EBHpVzKQ2ftJWtv4I2Nyfy13XyCrkgSOWg+xYLh+w2IG+g
	jv7ckTS2JhziOVMNhz8Pqfr0E21OsU0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tvRVTBeM;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760745927; a=rsa-sha256;
	cv=none;
	b=F/tJBjXxS8qhxAMUp8trqyjh+PynmmYubpvd1xAkiAQRLZJ4hk+GsBOJyJpgCbaDuOC+5/
	54UWFNk19elfm2/aqcqnxzoldZDfPmRR3ZSUJC6MRUCMC/tOUpzXQjXGBzTeixLCtz8Hmn
	iA5okuEQlBrJYuZ12TVFiamjCSYPft4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1726A456B5;
	Sat, 18 Oct 2025 00:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0EBC4CEE7;
	Sat, 18 Oct 2025 00:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760745925;
	bh=WOIXD2aj1erNpVG0tSFDsLzoqQwtXekv2ZjXklHIzZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tvRVTBeMogOKBZQEioCVJqqQwNHuhkgvhmb+ufpuFWlzMbv59merChNVUQK3M73fV
	 JAuZ65tYuEfU1ZZ4M33bDFyg9kZzEyry/10c10cCVADBBfjlpT7zRvCW9due+1xxL8
	 uFVHVnzws9L9aFv1gkuCgeBSBWhQ4DtC0oPMX10A=
Date: Fri, 17 Oct 2025 17:05:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-Id: <20251017170524.34cccc084f58d3996ff70c8a@linux-foundation.org>
In-Reply-To: <557fd56d-1a4c-4c65-8db6-34546c9ce8be@lucifer.local>
References: <20251016033452.125479-1-ziy@nvidia.com>
	<20251016033452.125479-2-ziy@nvidia.com>
	<20251016073154.6vfydmo6lnvgyuzz@master>
	<49BBF89F-C185-4991-B0BB-7CE7AC8130EA@nvidia.com>
	<20251016135924.6390f12b04ead41d977102ec@linux-foundation.org>
	<E88B5579-DE01-4F33-B666-CC29F32EEF70@nvidia.com>
	<16b10383-1d3a-428c-918a-3bbf1f9f495d@lucifer.local>
	<9567b456-5656-4a48-a826-332417d76585@lucifer.local>
	<FEFDFFAF-63BD-463A-B8B2-D2B2744DEE2F@nvidia.com>
	<557fd56d-1a4c-4c65-8db6-34546c9ce8be@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ixui1yjmgnogh4hgfzcjxf7fjuhne6up
X-Rspamd-Queue-Id: 99E3FC0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760745927-699612
X-HE-Meta: U2FsdGVkX18Kc7ovekULzKruW92p2M4clZkQZD8s0ZY38sehSS5miggTYpPAoNW0b9ijRKWXyCUBbATF+E75+3/NC6XC0HHlDJFT/063SyWyhA2iinyX7/TuadHuRXwctDKhv9JABpcSUXIVdZ2/RX0+tSHFqLuowVcL1rWkLpUTV8LNZIpg6TI8v5TzyJ4QTH+gu/OQI2Lsxv/Xq43SxJrjhCvt4YkKRG8UV74FdzuPRP2icL5ZMs3M9tOU8OpbX3pczFv+GJ8qN7d2lPA2j9y+PtiXctmZQ77Nu1XuhyjZIVxL0IWkgLbSVHLwLbWnAMu+eBEO6EfqM8bhaSNgMfqcXULws+uAhUT97WfLciksea1K/LAc3ns5pi7xmF3h1n0VSAwMtL7PWVyZKmqGDMgjqMq2szSB7sN9Cxe7L5PGE7GvRC3+tne9obNygPweEc7S4oznj6nmL9AnKhz2VjObRvABe6kKpusn7ymHdOk1F9eALm0nfpEove8/bcRNkw1DoIq59wTEyzWm0qMv6kdl6foxffJUNVe2EUqwU7cSkVhV9bs4RNMt/DqA6Dh4O63z2fqMUvWwNgsm7GfZCG6YnqzAMvmB9AVx295lrTA3+JMsgTOy0u5se8r3hjwejJAxktVQRY5PfdeJrl9ATc4koaHu7QFVZT054dQSksmdTqvkiCEu0dZul/ZttZmYlR9hVToiWL15FuAS79uO9XvbaNsFPQqYpPpxOQvKOnmnviE0sz8sJ4rAvhz0ktXT3PDRsLBkPbBv/VV1nVbfY/JphO8AC19kku2p4f2LGmTZxPmTYuOSnj8r9osXCq+dpjTig++4Dt0EYRv/rfe858vvLhU/HXo6niGvi1ij7gd4SoBB4ULnprS6j93A1TqX+q8BkUcfIXGY1272x13ETGerts8UvffbH1NbfGCKVSFnYNepFxAP66sqpo7gCRsfg+1tiUxxt+ZSYuYowWw
 Ywrf9VuG
 Ek98HX1AYdLO4tUeh0EfO7cooOio7f6KI//TJdyyO0VRvOl5oh9oL9Hwf3xSKoClayEiZZV6Bj5kU2b8x2pGtz6mCtf1bpJprakO0G8cxtFKxYkLC/mCVi/3YYgAf4DZ7OD5ex0m+2j4koNwkDTxP53PZXolWBd9xBFvD9InV9bgEay4n1ntMAEFVGymAGX/sF2q1ktKWWmDUqlffwQXLsqJCBLkqbxkiZutdrqU+e6kivuZaDFxH6MmOaHb7XeKwPT4J33fpyzBgfez1hK8uH9auvEFXhrZK2wjIcR6wWYVYHHoaeOJw8ZIXjW+LpyXHLhqL/AIDpnu4vzjUEiSsOipY2XXP3/+o/b98fnA7butdKPUjqOi0h5iXQbpCR7rcLZlXPKCSgIV0nbX/N5PI9TEIwX3yhobYa5YR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 15:32:13 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > it. I will hold on sending new version of this patchset until either you or
> > Andrew give me a clear guidance on how to send this patchset.
> 
> I mean if you want to delay resending this until the hotfix is sorted out then
> just reply to 0/3 saying 'please drop this until that patch is merged'.
> 
> Otherwise it looks live.

Yeah, hotfixes come first and separately please.  A hotfix will hit
mainline in a week or so.  Whether or not they are cc:stable.  The
not-hotfix material won't hit mainline for as long as two months!

So mixing hotfixes with next-merge-window patches is to be avoided.

Note that a "hotfix" may or may not be cc:stable - it depends on
whether the Fixes: commit was present in earlier kernel releases.


Actually, if a developer has a hotfix as well as a bunch of
next-merge-window material then it's really best to send the hotfix
only.  Hold off on the next-merge-window material so the hotfix gets
standalone testing.  Because it's possible that the next-merge-window
material accidentally fixes an issue in the hotfix.

(otoh the hotfixes *will* get that standalone testing from people who
test Linus-latest, but it's bad of us to depend on that!)

I regularly get patchsets which mix hotfixes (sometimes cc:stable) with
next-merge-window material.  Pretty often the hotfix isn't very urgent
so I'll say screwit and merge it all as-is, after adding a cc:stable. 
The hotfix will get merged and backported eventually.

I hope that nobody really needs to worry much about all this stuff.
Juggling patch priority and timing is what akpms are for.


