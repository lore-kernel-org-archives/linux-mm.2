Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD0DFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 03:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C436B0088; Sat, 25 Apr 2026 23:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123476B008A; Sat, 25 Apr 2026 23:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038EB6B008C; Sat, 25 Apr 2026 23:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E30196B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:48:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 341751C0698
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 03:48:23 +0000 (UTC)
X-FDA: 84699324486.07.7307E68
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E16680004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 03:48:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tQZK4OVc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777175301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqS6gZujVhVH7dyMmrmi96pcqvl7A5E/GN8Ruxz9Z4Y=;
	b=ulc8O6cwbRZ8NEzXuphX1juYV+/hQ6BZ1E/dpjfI/b/Akt7KDR6dmdCEQT9QqQ8nJkDgu2
	JWxDHKcAQanojwn3Rj6q2cYS4dU0HI/603RkhuxLljnCb3JFDwi7mXgrguHy87+hxysDhw
	26TC8+TlChUEFVEIqWpbAvqwP3NBVvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777175301; a=rsa-sha256;
	cv=none;
	b=6/mgT5SDRhlHRaya7jpJdzlShgJSp/LwCy0A9b8rUrhi8pr8xC4QZpXsmzVbkdAFxV08ak
	QNUDj3E6PBIgdHvEU857SanZ6jVmOMeXryv2VG1FimQW+GteAijm2IP4rACe2in3rk5agm
	ADS6CMWgOQYsaFvrMtezKDjUZDOmb+c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tQZK4OVc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777175299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RqS6gZujVhVH7dyMmrmi96pcqvl7A5E/GN8Ruxz9Z4Y=;
	b=tQZK4OVc0LJMZu8x0fXqZUXzuDih6jYV0aDLlga0krfuXkeaH5E0N3p8ykaeYP3hogzGlX
	omT3dOQdXc6SU7heQJTrwhBMIqGzrRDh11OO6wjQXz89Gi+ljHs1xvcVxjFvgvuSpXRP2H
	jCHWi41JS4f2GHzWLh7MRjt91vyC9XM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge
 mismatch
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260328065534.346053-1-kartikey406@gmail.com>
Date: Sun, 26 Apr 2026 11:47:26 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 mike.kravetz@oracle.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9CC5F017-AE6A-4EB0-9099-B4DA5E93EA85@linux.dev>
References: <20260328065534.346053-1-kartikey406@gmail.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E16680004
X-Rspamd-Server: rspam04
X-Stat-Signature: irhoyi1z5ofgj3eibaf8auktxfn1o9me
X-HE-Tag: 1777175301-47474
X-HE-Meta: U2FsdGVkX18rzGaDo9gPgvBONcH40WFPQza3kMkbCNkgjnj9gz/3U4NKe7lzhVrmj7yoPcOJq6rxnOlOIKorB2Ar3ZPvtceomeN3vcrxkxcUGbknjJT0vUtV3YgJyGgBGOdxITPXxoJOr7qC90boVsglW0QsI06Kusy5NRs7OHKx5POvfAbNzyzYGcqh3uUYAlBaBUUSJL8mWKrbQUn1iRFEuvbg7T0Pqg7M0GPaVC4ZkmX7JJXt4MqSu1TtuZ65aWfGBBdGnnrQBMBdfp5vmNRqBq3j6v6V27c49VC5osx0zNK+OrikxKoiTl9uuLTPYkViLIl6oII9exhR9ubXVPfdYI/fmP/G5X2FTkc421IyvAYHmthWNY8joyWeNbMusnvjAXWj8elVJFxOl4t4WPYZIPKEoywZzbJazCatjA811r9ocE6FGOzZx1QgjYv2I6zgauOLsTwNhd+2/809a/3r4BckwD1Lg/d77nnBpLd6ewnlAHMm4n5o+Y7SMb4ZqyofJhd9FbVxCKaHGlW1yPvqFpGRnOn14GBwe+yWCFLzVVqw+sHcL3id4FnDftj7SvtT0s+N88gUfldU6HDQNF/Rw85y4WNpJB0xe5IdFO5noz4Aa/qQOdRjtl0ujMR9VJVU6ZGNl8dSBHUyW4OkkY8JXzHMeTog1ZiPonZsc5w3kBQMX9WWN3Hilc3zKTMMcApDtzD2aO6v64zKv0wU9FzlW72SM/HYH0nug2J/b43cuKasgJ0HvDQKnMzU87gE9inbuegf/1AXi02VXcoMORWpWeOi7KoJHYz2YrlfVwt8jAS/phUlD/dPSYbWMyT1fJHfMpYZBNyqHT+C+RtiMWwXZOs8BotTsiEaK0ijygWXFSGt5Hvj9d1v/vPRUvHq/dhdl6v9BvQFOBNU0DtoZRlbJ9/kWmDFFrdaCMwH1wqe/k9L1vM/QGZtBi33KKMuX6N0DZCAZbc8Qp4fPFp
 8v9ydWw4
 W/4WqKs0yGtHxFgAczrgy7gcT9z3WlpOSmeZrO+iXeV+Uf4yN4h7ub3Ouvf9ChJ+2gJ1jZmRQCk3Q1UufhS2VBQHeV+5oJRZ1vPG5kWT+8tBMnxnCjRM85tmBrXs08SerPkQbjpCaymS9wne1eHkhlwgYcclO2u9xSKbxoJvEYm084J04+t1GWNU9bWTDdWACmdox4psE2GAJ1J83HyR3NtJTYpKB3ok5eDHbWTHrI7Xn6EemZTBNQhM7W3RgHtMdNg3AddqNYZOJgSuSzn0lsrg7rXyADhrHZX3BtcA9KnVUAYdJLS7JmPo102s9C2BhF/UMpX5dX5ttwkjQldhzBn6GIOCDw0H5kbJvQu2BnwSBRPvhk/IvJUob/6QQcbaiXQ4LPeH06+eV+1SPlO8cxCHCryHKOBzi0dQNUsv9ZwwEzlFLDSmHIS8QFsMnNNb9z4xVH7fsALNpEGewHUYRrcnujXEKkAO7yfKy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Mar 28, 2026, at 14:55, Deepanshu Kartikey <kartikey406@gmail.com> =
wrote:
>=20
> In alloc_hugetlb_folio(), a single h_cg pointer is used for both
> the rsvd and non-rsvd hugetlb cgroup charges. When map_chg is set,
> hugetlb_cgroup_charge_cgroup_rsvd() stores the charged cgroup in
> h_cg, but the immediately following hugetlb_cgroup_charge_cgroup()
> overwrites h_cg with the non-rsvd cgroup pointer.
>=20
> As a result, hugetlb_cgroup_commit_charge_rsvd() stores the wrong
> (non-rsvd) cgroup pointer into the folio's rsvd slot.
>=20
> When the folio is later freed, free_huge_folio() unconditionally
> calls both hugetlb_cgroup_uncharge_folio() and
> hugetlb_cgroup_uncharge_folio_rsvd(). The rsvd uncharge reads back
> the wrong cgroup from the folio and decrements a counter that was
> never charged for that cgroup, causing a page_counter underflow:
>=20
>  page_counter underflow: -512 nr_pages=3D512
>  WARNING: mm/page_counter.c:61 at page_counter_cancel
>=20
> Fix this by introducing a separate h_cg_rsvd pointer exclusively
> for the rsvd charge path, keeping the rsvd and non-rsvd charges
> fully independent through their charge, commit, and error uncharge
> paths.
>=20
> Fixes: 08cf9faf7558 ("hugetlb_cgroup: support noreserve mappings")
> Reported-by: syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D226c1f947186f8fef796
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


