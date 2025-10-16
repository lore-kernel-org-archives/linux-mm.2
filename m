Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184A9CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC468E0034; Thu, 16 Oct 2025 16:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4298E0002; Thu, 16 Oct 2025 16:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6011E8E0034; Thu, 16 Oct 2025 16:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3908E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:59:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2944B835C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:59:28 +0000 (UTC)
X-FDA: 84005193216.05.17DADF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51122100005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:59:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2GG/tL4K";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760648367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XohFyr46NXvuM66TmFRtJuFCam0UylASGO2FmbD3b7M=;
	b=PT66HLjAvOo+6HI+Z50JKUO7MsLwYVfe4tHffsEkNmceRcfFxN+jwT6ju86v/4GtZX+c4w
	7nbOABkBF19DBR1h7H7i3Vk37nOrjgJaPNV+UATWCDg05V1YChNHP6L9VAcUhw7O/IYLwA
	2JDrnfQlvt8a+r1mChf8ZKoyZxFirqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760648367; a=rsa-sha256;
	cv=none;
	b=HOZ2CPsjXjw76h1BSj2kXN31lV4Lq0it9pwsONva33PnoGa08vXMwm7NSeHC5FcSR6gtyu
	HRDv6jNq/v3KdpolmeXSWzSLwT7IYNV3EB0xz6mM7GjWWUIHoDGOkci4bPqglG235BAUCX
	TXdBQg7Z3Nmm5o3GyT0qP/b/Sas3h/U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2GG/tL4K";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA0624070C;
	Thu, 16 Oct 2025 20:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEECFC4CEF1;
	Thu, 16 Oct 2025 20:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760648365;
	bh=On0cJn7W8Gh4erOEbo4yZw/MYHtBNjnFLohMdduX5Tk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2GG/tL4K3Ivbf3xyWHn/Vtu/7WWXC55vU//3w11E7n1pREIksTdNSGEroj52SzDBM
	 4P2ldDBbTRfKAJFhz2Rn7lYgMJSYjzRJfAK5cl0MLrO10kUjs7RW35FkdRHU8sGejk
	 zt8FDRRwj38Hp9385EIAHhFvQFjlT5IKTW4Ggu0o=
Date: Thu, 16 Oct 2025 13:59:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linmiaohe@huawei.com,
 david@redhat.com, jane.chu@oracle.com, kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-Id: <20251016135924.6390f12b04ead41d977102ec@linux-foundation.org>
In-Reply-To: <49BBF89F-C185-4991-B0BB-7CE7AC8130EA@nvidia.com>
References: <20251016033452.125479-1-ziy@nvidia.com>
	<20251016033452.125479-2-ziy@nvidia.com>
	<20251016073154.6vfydmo6lnvgyuzz@master>
	<49BBF89F-C185-4991-B0BB-7CE7AC8130EA@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: hdrmrup9pugpbkh4eh8xtg3tqbsnd8rk
X-Rspam-User: 
X-Rspamd-Queue-Id: 51122100005
X-HE-Tag: 1760648367-135706
X-HE-Meta: U2FsdGVkX19fH9iBzLJ3BhvysRXHMldDp1pwPHB6Wx0wgfLYiilCjcuYjO5nt4zZktg9ViruxYObVNuIikcs3uId5niMlWhcxc5OJzZ11BkAGXYgXHBoEY8nH2R1vOzMSMQYMVPfFOgjD1ZpxJvz0zilrbROjeL+EJaWJ3MjlBirStebHR/I9Asj/JRTE9njwwCpkEBSDfmGhuYzQSKF1m5lbofjOOvPVSmxU/TI7f4qSjcJVy+OI5QSVczZLuT4q64qZKSuPkr3u6bbi7qL4tXeGeWmvp/qhVHXzOfVSZVTblj7cfMTewUBgoNeNRnXl3YDB4wMk5+pHarytbTEsSIxOKs0h38fLXUxhNwqF5KZEwczZ829S8/56CpS5hGyLplkCnsTO2OhsF3uLtDPvTv8TG/XPdqnhVjDthKPxmf6oSLRouC1Lild75kKcaVYAwVCD+3ZzHvLRikI0jOSffPFRJ5QTcE7LDEmliMUW72QvPDe/B2/rJ7z1ILm08AhYtMnpA8rrYcSSL37IuTuYR31tMxk4R0jSFi9iTDPOZmVZlFkqjHef1RPCKJS9Ia2cAN7EKnbBYzIwOylOQh7m2TxEZtj5jNj/d9lhNcRiEcJ5BbNXnQxTsN8tou33ZtxgDmjJVfV40K1PJXO6Lojmm5mof9LTVHAsITgMjqfeaB6QdbSCSCks3qgo3Zc8Vv2HEdqXm/h7Itd4tuBiphjDvskvJ2PNqFPHX5kFe474xrdK5X7KWGaaAwUF5WV3QOKtey2Dg6k0fjhIDjadB78cSfZgTc4h9RfMbH5bvwQrVfa2VUVsalxnj9U/xMA4oCXt6wcD4NNrums6WbY0eM44d6G11Av8YzX5Gf9n/+/es2TCVBBUlBGN/Fgv0PHhE+x2Zc0oPHY1CsxsRaoHEXE2ZNMijcdWCSdeHQe6HwMvAnX8NLRwCJSSs18aKHMNnrx2NaYXOL6Aep86pgE9lC
 BQHVIRkZ
 zakANBs6T+EBRf8Z3Ruc4fJNznJczI7Y3e3TFPExHWBNq2DPgmhF/aMulFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 10:32:17 -0400 Zi Yan <ziy@nvidia.com> wrote:

> > Do we want to cc stable?
> 
> This only triggers a warning, so I am inclined not to.
> But some config decides to crash on kernel warnings. If anyone thinks
> it is worth ccing stable, please let me know.

Yes please.  Kernel warnings are pretty serious and I do like to fix
them in -stable when possible.

That means this patch will have a different routing and priority than
the other two so please split the warning fix out from the series.

