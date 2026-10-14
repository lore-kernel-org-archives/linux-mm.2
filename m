Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096BDCC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B800D6B0098; Wed, 14 Oct 2026 04:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58CB6B0099; Wed, 14 Oct 2026 04:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94E66B009B; Wed, 14 Oct 2026 04:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 829696B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:23:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF0D512046E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:23:58 +0000 (UTC)
X-FDA: 85320543756.14.9EF9F65
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE7038000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:23:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pEHQ7O/b";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791966237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLXC7qw5IjejpZgUTQx1wM51wAjGcyUwJPApHpQcNVQ=;
	b=nnVYmsh4Doxddh/S6ciP2YmXiA3kNJvOkDUVUekqVNUdf1wmAF+tApk/xuQJjXfL20ehwt
	jMfBAIE7TPBS1TPkmtyKCp4ekNRfjRaVKpRhzDx/Bu5faPxQW722g+d3mr1qKlg51Bom9x
	VrScgSTWCesJRG0KaPcq4cs5Rr+dNL4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pEHQ7O/b";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791966237;
	b=yC1D2/xRoiK3Sz32pnK0EcS4HRFgccUGc8PwYmU1dt2tabNiA2QHTBOtmIiqZPzvvaPKBM
	JPCTdvFgszljCPwLuWkV1z8w0QkmnMGrrl1kbEDtIA1r3hnHSe/WDCRYCXaQd9szb7dsjp
	FeXKKJiOhLd+6B2FJf2Ueztu8DTYI0s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OLXC7qw5IjejpZgUTQx1wM51wAjGcyUwJPApHpQcNVQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791966235; v=1; x=1792571035;
 b=pEHQ7O/bjvhjp+IrhX+KbDztmvxS1SAMcfaFZiKHYOIdq5lDlBmxX6hbYGAR95EirfqsY7ln
 Gcyepyo8d2/FL6+usTFgOYPiM1qW4R4HeTjTR5x812TyC0BnOrBqCCvIRewbHY9iP0lR4VfXH2W
 W62ZB0xbHwMpIB25vbQeSf3M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1780a9b33c14a0b1;
	Wed, 14 Oct 2026 08:23:55 +0000
X-Mizu-Trace-ID: 1780a9b33c14a0b1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2] ipc/shm: fix RSS accounting for hugetlb shared memory
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261014082218.2236088-1-tongweilin@linux.alibaba.com>
Date: Wed, 14 Oct 2026 16:23:38 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Dan Carpenter <error27@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <05518093-AA04-4525-96F2-FC7AC327DCDF@linux.dev>
References: <20261014082218.2236088-1-tongweilin@linux.alibaba.com>
To: Weilin Tong <tongweilin@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: AE7038000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: eqnjwr1bxsjrba6g891h57isaojyjgyc
X-HE-Tag: 1791966236-759036
X-HE-Meta: U2FsdGVkX19euvhMCaqfnPzIFSWE3qrRKyGgIDZcyPbboo9/7OnFtUFY88sFYxMponD7Dciv0Mg2n4gboqWXH8yw6RGZOWMGnWciIJ4huYGtgXrwwg4eqZfMsZzGvou+TAHEUGJLsC6yj7NGaMt7zLL0MmANuN6wNjKLO5OaMqecydK2iLrKHT4rT+iQnMVDzQ7jXBwHancEgbc2tzZsN20VZHqjI1S7IfROmx2QzrXB557zn96tbFlt6XpJbadXDmish+LdpQfCPfRcCyg83QW2Ll3WykLG+WbVPQvIkPHMuyoBUJ95lCZxax66XQx54RtZN2Kwk4QyFkVVXHr5F1Mb+OgGzEAgbSeemPcpG/ZIbOB28jbdZZqbdiuKdcVcR29I5eXL6QrH+/1gleAemXeXeG0J4mjJetfLJ6FaqVbPpqV/azkhKglSgZmbzsLNLii2UU4qA2eFl3ay211CdsCeQm15StzxmjnaqFWSS0DL5j86YWRnoP+uNbgrKHxhaJNucPgjIe1U9FfN7j2mXYkPs1S1JptYc/VV/0fmRujiRLAu6es04f10QNdS2BzawLWgMVi90FXTxZn2Grkc1QBOL6MGTUkXFnxd0azlM8tTG8/gFSYZw3o+OLsrU68i3a11EvXqmTgFQtAWc1ke2WcQSmV6yPsotkovsVVuhkLQ7Hm6gpdmqoOjqRKxr3IVs9/8BZPUw6+XsjiJ5+iFyrdMyFYHXHrrodd3mPFO4sUoN0w/IYw+tmhhHFJGeS09U3SPe6kWtpaIbVg0a1CveUexIUx6IGkW+s5ddSX1GVjJg4H+5JR9D2tLbojE3ybGgPlfAHu/Hhia/Ig32SPwmG4SAY/V9wB/KQ/lgSFetjflB7xqXQ0kZehJ8VT8BuYlRgEjSGsgYwA7E3cEGh5BYKo3F9UzeXNs/BSp+Ifqo6yldF85FsNqcrcr5vZfCIKGnC9+zTQxlZ73+MgREq7
 Yeuw1j12
 bFC2PSHTowIG5nBbRpd4oS7ohqn5Wx4x/1ze2xsEAWD6FAdwLOVCG4PC3qEMX/fP72jFBU8IL6zyAfkyF0bAPjCwLMIZdi2HB2RgYH16V4My50eMIvCCAjXzOhuBxRoDSXDmreIr6o3EilRWHVORFQoO1+elqQzyLYE8cuH/BEHEMOiRHha/R2o6NArhL/Otz3odNTUXbtEMVE+FyqVCLN7nxlwAfyIe+MsNeFZU3akDv6G7aq7QfP856LvpRzNQZMnJwFpjxy4hPFTFt+HmdNw0cBtrpF/jDt4rSWQrUPtAIaJkEu6aV+rK535f0C8hLQEXju+/60ygIANcNkG0hEsVMFkkUF8MzbLyF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 14, 2026, at 16:22, Weilin Tong <tongweilin@linux.alibaba.com> =
wrote:
>=20
> Commit a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in
> filemap.c") changed mapping->nrpages to count base pages for hugetlb
> folios. However, shm_add_rss_swap() still multiplies it by
> pages_per_huge_page(), overcounting RSS in both SHM_INFO and
> /proc/sysvipc/shm.
>=20
> Use mapping->nrpages for RSS accounting across all backing types, and
> account swap only for non-hugetlb shmem. Use READ_ONCE() for both =
counters
> instead of info->lock, which does not protect nrpages and cannot =
provide
> a consistent snapshot.
>=20
> Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in =
filemap.c")
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


