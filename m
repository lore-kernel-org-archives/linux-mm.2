Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04129606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=UoOJok6X;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=eURMU/YK
Received: by kanga.kvack.org (Postfix)
	id 15FE06B05B3; Mon, 26 Oct 2026 13:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116426B05B4; Mon, 26 Oct 2026 13:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19566B05B4; Mon, 26 Oct 2026 13:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C47BC6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:59:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5017D12085A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:59:45 +0000 (UTC)
X-FDA: 85365540330.22.46A5DC9
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf09.hostedemail.com (Postfix) with ESMTP id 31595140005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:59:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U oOJok6";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="eURMU/YK";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793037583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOYzlYgPliGkanrzYocQaBwBSFhy+a09Z2xViy9Z+c0=;
	b=6xylKTfjzksySTMWAkrKiUkEFF3TXg1h88cJvPAfMc6x1ZijYZMLEbXdRykcKQLVeU7O8U
	8tUIYTq7nZtgL+wXmnaxRGTQY/Ef/Qc56iKGmsffrmuN9WPoSDCn6RhPGlalaKOntsGei3
	gYAHxQ8Qywu2x4gMp8HuxTkFmv1FjKQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793037583;
	b=mM1rml1wxoRkqym3P00bNFJw2iFsMv9j8eqrr7nKPw6QaM+UwneVYbdw7pRRIUp1RHfzVB
	m97xSnthgGCPudN/WGmv/9OD0i0fsRCdWZvKVqKdpMmh/8/PBI12opTodxBYUT48IBY1gz
	pU8nPVVEV30pWlqdczURi7s+iIW89dQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U oOJok6";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="eURMU/YK";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 994CC13802FE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:59:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 26 Oct 2026 13:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793037582; x=
	1793044782; bh=oOYzlYgPliGkanrzYocQaBwBSFhy+a09Z2xViy9Z+c0=; b=U
	oOJok6X+OIinjewBKwhYYwOxH+PZDJZGMSPwjaGJ6X06l3eFrU9YF4zpKT0ZAWky
	nA8ZV1skgzjGHlHl1L1BmOeH8T42X/fFTZK4K2esGTRHvenXkmEd0Jwusx14tQOs
	TJ9cxTf5XOaT8SFhyTZvzVEgxB+fBHL2WR4LNGxirAiwgCSjeVHa4vdiBxNskZMq
	TSAeVMg1/0zZXZyyWFBzcAJtBP6WbUs9+ytZy5rakO2VqM+rhMegC3edWOphRs5l
	2dUTepFRzOEc2m8Lf1HyEuowFN8oHJXMl6Hn3VlgnWlNRMUyFYO+QrZWlW4ubCrb
	yyREpw220eOLNVJ1htcyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793037582; x=1793044782; bh=oOYzlYgPliGkanrzYocQaBwBSFhy+a09Z2x
	Viy9Z+c0=; b=eURMU/YKDjSZQVR4C6vNt3B8v1oil6L+SXYpKcDU0e4FaCW+fqq
	gmiDaaps0zI1U6S6vwAcO312JVPYb7hdrYZfXQsR/GCzTdH9D+g6eXCg/ELt7NDD
	gJ9qDIDm30mM1jQV5dK+75V9gYayp/Bd6zUdbzSDYLxw6iSSh60j+Vx3952ABm6T
	Z7EENyIA3iX51pozn+UeOLyXTRorQKKUmbIqPQZdJz+jNCWIakOk5BcxJqFvj28k
	sLCIGoLne581maJUaf/yJXPWSKm/Z9gRxso33HxSfpWiqHS7XUkYBwDL+vMuA02F
	Ql73aX5JhHXpdRNdStonBzYH9UeCBVeGPvQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793037582; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:qz1WAu7TAynkSmFdX4RovcMlg+6072VAJbK0m10qLrgyyiF
	Ok5T+F79e7Wrb1KkjwuTdWuQGnq0ajAOzXRImV6Vxb/V0x+S5TtC0rL67vnWzgK1
	8HeyMJSaOQCm8NLnMDokk0co7eZ3h2LiwpaNztHu70gFnPTOQ92qXxiETOfB5o5q
	9qg74wulPRBXlB+E1ShpoW1jh7E7BlQ/aKKf4vGu3HdOPOPQQr0CbiCRlWdngMkL
	vwIUkZo7I1rGC0wkPgJlqB8OoMShs5hCTGVKed4Ou0Yeh84fD55ZPFKYFpwDW2CB
	1WvE5dmJZNQXE2EvVE4aliJN0ZCHRNMl2KoYWwQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:gdz0OR2pSb070YT1VXXewMkWi4OHqKYlSy7mq3nTxw0=:xvg2+PKiolvt97hjUN1pagpPFL75bqeploLKqu3QsnU=;
X-ME-Sender: <xms:DJXfaj6fwcX0ZPAdTR3_f3oEj_vAewN7PlEoD3NZMD6NmLQwbfYlfQ>
    <xme:DJXfavnRKmmObRDl9VqgO_F1z-2AEhqIYkLWM_KfYMG8m1StqqDFzFSY3XPuE4uMP
    oYsz6xjJGmUEUWtE5hRPVpQp_DP9Rg_Kdea5WdbUcQGexvgNO9fKQeY>
X-ME-Received: <xmr:DJXfakrrOEFUYHz0RyjOjRGT_jZDZp7cLBZj5usNadk7-RXTxUiHpjC5q_k>
X-ME-Proxy-Cause: dmFkZTFCJC346uT6BkgpqQYR4FNPAi1RA63Z+5L1PPhx5EiCpW4UTmnFOpzGWG2lAFxYWG
    ow1NfL/UTp/Pd4DBanvkvVjQX4/GJ9QHoxX2Gnm+9O7gKo81tMOLCB6mgJceKwlnlE/6R0
    V2YJ39AyV14l8ouat82SghyoTr/S0qOn4UjCWDfZBVfbZ8H6KBl+RFmwuyJgsMdh+ieuFV
    d3YZBJi/v/7a8u8UDV+6GBpxXisMoQE/lBwP/kVhG7Ecprx03wwiSqHTSA8W8XkMGFowSD
    sBsXoX6pbh6kmOG7yuRNSEET/XSSH+CeKPAuXjog7+s9n69YFxLZ6RvMAi2C1P2qu/rzC5
    xbTppKgEW5DqVCnkns29EM82AVgv+vAVO/P7HKFZ6UL0osfJ6AJYjRnMwpW1TPX9BeetfB
    dc6qhmwH8Xi1dQs6oE1LR62OT4AJmKrTlyqpxF4iiktYda3iqD+0MCE3TCNGOxXSs3wsZD
    foWjYya+jJPndrlUXX80JGJ2I6lCY9AK6SG4fFw7uvOXYsG5bLswkhY6a5bczIJM3s7PLJ
    SYKLyw9v7y+OrzOXgf5/c42Iyg3svUHoiwPaMKLxZ9V+4nKMubFDZ4CLzkH4L1G8r5+Lv7
    rDqIcyTKMcz4ul/5bLWLl7YgOTtWK4GhApbUsuBHbBrj4tO30MPLAugN1lXQ
X-ME-Proxy: <xmx:DJXfakzI3ROPAIRF3b0nfYO13OEVCw4FsxyzKavvaXvJGmZ4PwfM-A>
    <xmx:DJXfaq4ZTBk2GA67S3wXuU3nEDe0dCjvge2ERUkxS9U58ABq-IGRog>
    <xmx:DJXfaqkUHTdbu04yL1Wlt1QzbiAF-t0P2gNd1oe43PGpk9SfM7zLhw>
    <xmx:DJXfat72axNJc-yU0k8fSlJLmSeAYGZr27y7o2Zc7U_7leWrrlZPhQ>
    <xmx:DpXfahmllRgZZFxfHQq0fVy_vAh8-l8eogDyjPm3ajYF7TcOsEE_ublE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 13:59:39 -0400 (EDT)
Date: Mon, 26 Oct 2026 17:59:38 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 08/16] mm/shmem: stop retrying folios that cannot be split
Message-ID: <at-U8JkqnTC9GZyK@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-8-703206d5fa0c@kernel.org>
 <at-AmbZyqUnGAJkI@thinkstation>
 <f7d36a47-6879-40bf-8c24-dfc89d937647@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7d36a47-6879-40bf-8c24-dfc89d937647@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31595140005
X-Stat-Signature: 76gnet4pmcro7h44kmd8tceg1zkgqk19
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793037583-88559
X-HE-Meta: U2FsdGVkX198KE55eiZQ7kgHB+lVYKQCeGIzcBiHkdyT4S0FZUxOoSrPYfvPywNSThZhWV62L7PBAjF3E9E+Eo7dJ5BUWhyW0SLNcaXGPoGB8J5fCs1W6eKozTt8ZBlHi9S17x1UEzZBls2CzjsnyPLYhsTlrtiHfyPayuGkkPIiQgkQSKQZuO3Ntw2Vw4YPwJxbb3t5+/HH9D7/w5xIykPbyzG6o8twGXmgd0Z+1Z789Ht7Muc0RlaJ4nGC3V8b3VexSwcdUUsqHMMIpGVZBEUtNMO+XmhP+kunK3CBm0F+EDZQp583unUtpgHp+BXlJvj//m9vPTdQR/OZcm95I5TLgc4WMzp7gLVlRbwKsPu7M+EP/TuQdQ4O2UXbOKmVFq2qHEq36MCLo+guyW0ywBZr1LBSF3ko6VLNnBtNx6i/hLEvkipccIzs/PyrY5H7GYplTfG9YL7KqIxd9XKAxnhvm48qneA/poJlc77wLUi3kqO1YXOXIJoqpZX0gA2zXj8EX4ZKSv1pDnAWOLUmS3BFJasFfmjQ/Niy6SE0io0RDxpvm15uCZUhcBZ/lvH668GZ3hI09zJGPykwsZNqU/cEpxAjJlVhAawNPuah+r1+Y9tbr2rmcDw8gtkNSDs7/yVefZDegcQI1zr0cbzrzLrNKJqM/cdIvcEvDMGwmoeSZK1P5GWORf5HQrnDe11y+4jJ3Du7u7VcazQvbr/R91rASfUqgAJcpW4UCYWjx3qOf69rL1/kfuChpFH8L3qJd/CMKpAq3KyMamrCe8OX8/bShl9NdxQNN35Q3m7dHAT76ht8OHntNbtde0Rjk9H3m03qu1aCwRwkevkPw5nseMs00+1tYvInv0RK4E9zttH7q8dfM94SF1Fun1p0BJxNUWzGD0c+6INzoim9n2tTVr0IPDcBs0TBeWdYnzDhjlBpiD5qARmQJKmFfp4mSWv5Q/Q4TbyP9ZS0hNsGgnY
 wCkisC35
 Afvjet0hlmJf1FSx0aTcYRLTadkAvJMZo4rtGC4GIr7u1dX1gt4z0Wau9dpFaGBBK1+kda1l5ENLa/n95HoK2EG4XpZ28ju4LvddBNUyGT3tkdG0M07llbidbAIHZCdfTQGmZ86ubcFK0D+mZ2n9ki9EdbIL6DhKvb79XZYaKJiNNTS0najRRFVjYhZM98wqiAgGePYxfmQ9rhsaFmBfOPatE+CAgdJ0XWHhcPHYmTiXa06Kp5ocfCO6uZBupV2X9kFIg68XX0TfyUTa82PtXrKMuckCo0nerNTbS7uQqsVlbTP9Spn1gBcZ1X4C5CLLEzqSdTbUiS5+3MlwFeNtHmTqhziwQcrYhg2tBHt1BQeQaeRQ0W4Q0FUfYInj9x4bPf2qTrMKixygmHBJ1/j9oXsXF+cQcdaixgbVhW/rx/Z+xL0bZcmADHCI1Gcg8QFNAO1B8wY11qkPTaiIpQdKFRvbY2gSOo2uy7pDbGnWuWJi4+UEC57g4d3kfkG31XbhHo+HcLl0au23shn+rmW4MsbRTgwDYRcpmkK5PjY1xgwsiSvEOdE4BKmiLOiHYBZKyWDQgyFQpoaNQQTzZFf8QnvmMBmQtx22jStEb2s6NExjGGLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 06:08:15PM +0100, David Hildenbrand (Arm) wrote:
> On 10/26/26 17:36, Kiryl Shutsemau wrote:
> > On Mon, Oct 26, 2026 at 10:40:41AM +0100, David Hildenbrand (Arm) wrote:
> >> From: Chris Mason <mason@kernel.org>
> >>
> >> A fault or collapse can insert a large folio crossing EOF after
> >> shmem_undo_range() has handled the boundary folios. If splitting that
> >> folio fails, truncate_inode_partial_folio() retains it when it is dirty.
> >> The final scan then repeatedly finds it because it restarts from an
> >> unchanged start.
> >>
> >> Truncation keeps the inode lock and ignores fatal signals while looping.
> >> A concurrent unlink() can then block other directory operations while
> >> holding the directory lock and waiting for the file's lock.
> >>
> >> Advance start past the retained folio, whose truncated part has already
> >> been zeroed. Do not move start backwards if the failed split has shrunk
> >> the folio.
> >>
> >> Fix generated by an LLM and sent by Chris Mason in private.
> >>
> >> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Chris Mason <mason@kernel.org>
> >> [ david: split fixes, simplify descriptions, adjust comments ]
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > 
> > Any reason, this should not be in the same patch as 07/16?
> > It is the same failure mode in the same function.
> 
> I decided to split because it's a slightly different error mode (failing to
> discard vs. endless loop) and tackles two different commits.

Fair enough.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

