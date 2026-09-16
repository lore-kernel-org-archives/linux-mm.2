Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E49C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667FF6B0092; Wed, 16 Sep 2026 04:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4076B009D; Wed, 16 Sep 2026 04:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B99D6B009E; Wed, 16 Sep 2026 04:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 293396B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:31:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1FEE12065C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:30:59 +0000 (UTC)
X-FDA: 85218955038.03.C30CB4B
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CACAA000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:30:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dsZmTsf/";
	spf=pass (imf15.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hPh22tvtw64HNBi/aYPOtWH6cX/cq5aJOrEa+ysTJ0I=;
	b=kwFDLbQVG1TDL+s3hixE3vlva7ABAwjGbbn52yyHzpIeLGx9xAt0Fz/4L0x1SlTT08P2uz
	LiKti83bG30K3fh4KM3Bq2beB+03r5adLAut4S3+jBEy2Iwbe5bRt3qNj4be5hxoXvyzJt
	U4/7UUEIOaZo99dv+1H9Ez7GPyQ+bqI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dsZmTsf/";
	spf=pass (imf15.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547457;
	b=M76JIOzGHHnOUsWVtM1zkZDiBJxVodR3UUmjQBmTUiUrYMO9u/HW/3k1aEmlFd2dTkNBqc
	KQf93yjzCcLsrAjZ6Q6mmglwIJ54qrnRE2lGXQYL+d8l1v2hIYRmkmv97qCrA/H1Kd5SK0
	WqA6vkaU0yPa22lrd/T20szhX65FWCs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HVeQNU0VnGAT6KeaYPHUaFiS0r13E4evtRSG/JUmvsE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789547456; v=1; x=1790152256;
 b=dsZmTsf/C0DUaNE2kutjSWXtlWN2XDHzPCJKQgZ1EigqK16RGj/2H6Mn/rNNWVENm5VKOlI5
 7UF1OC1tY66Z61b9pD84eVinn2V7EBNg1kPU3i/tF6+KUTG4vebn/C5omAgWgD9MpZtdJnKPJu5
 fQEQyaRXbOwa2YzPMxvR/uBE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c02ff89e00ec8e44;
	Wed, 16 Sep 2026 08:30:56 +0000
X-Mizu-Trace-ID: c02ff89e00ec8e44
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH 0/2] mm/hugetlb_cgroup: move the per-node usage along with
 the folio
Date: Wed, 16 Sep 2026 16:30:26 +0800
Message-Id: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQqDMBAFf0X23IAGLbW/Ij3E5EW3iMpGRRD/3
 a09DszMQQnCSPTODhJsnHgaFYpHRr53YwfDQZlsbp95XVQmTmL6tcMytEYNUcP66IJ7IZQlSMN
 ZEHm/p83nz2ltv/DL70TneQEmAiU1dgAAAA==
X-Change-ID: 20260915-for-hugetlb-charge-2cfada8ed44e
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Colin Ian King <colin.i.king@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>, 
 hongfu.li@linux.dev, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789547446; l=1403;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=HVeQNU0VnGAT6KeaYPHUaFiS0r13E4evtRSG/JUmvsE=;
 b=rbcRgrAuiTtJsuFFmAg9A4uFfsk82YktFg6/zlGlYIDN6/g4W8mAy0IL0sbKqJBzZhScqrJVm
 CXXJU0TvDpQCfI0GSRejxoItaHDibMUQkdmhhEQ4Im+XTzNM+6LaFdt
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9CACAA000B
X-Stat-Signature: aq1rt35pr5hwmun751ahtgp5r4mhiceg
X-Rspam-User: 
X-HE-Tag: 1789547457-123773
X-HE-Meta: U2FsdGVkX189z2C/eo6XFZgg5+N4NlxdqKzIZFvI6C4Ni5FVCJPtOrPVgP3xYeo/dVvgD2VhpgnuWIUbZMO91g3VdiYleK4/a55B8jqpBAhoDE02M0KPvnqJoAYFW3aajSoKEdcsXxmSabKg0ucL4Cq+S6d40QjymL3zVEv1oKx8HvHGhlrHZDzcNw2+xcd919WT8riIYgyqkEL/H6IqDlf6UQHELJjwgD0+nQ2JLoaTXZtodLHzhBVHjlN6AxCpA8k4wRrL0ef6313RUG4Y8VMRXdVbkskh9Mwb4NWDyLW2z6wXBP2vkEa3SQYeCN8BoK+YdJldmwbDhtEq7hO4NsWxeedoQEc0AXcUWbKUgyrua0D8Thsq4oGiQ0yWTnX1wRtF+KOx3NCXs4qwKR7uRjSvNs78Va03oz8o/dHSi/LzsNjMxR1A65JxD5oEuwsGPvvV63H0IZpS6l44KwduSSh7YSkvN5Y2fbNk5mTL1qlcnbhmaYNBERnUcMJbN9uEn8b2brx6o00HpYIEGTydW7nEZBXk4q8JJ0py7MRvzjDr3g7PqvKeMyWVV8eRgrO8n3z70TxuCb+Cpc28YZsi6ksh7cIVjdc6bXqPPCPHQcbSNg0E2/tgz5ldB+UUVQXAWPsUGK8zyVoIPXZrrcYpYT0e0EdaG2N65IKxwhZKq6OC69kVPRmG9gZvvuC3zltr02JM2olr+B6Gk9CGqGbd9JxPYsjedInCWg6jOhAaWf+4lvA4zdXKyPSaHgv7iJ/gpbShabBig6ftbiotOuIFe5trlMLeTZKKq2sBeD4ijPMHTMSaz208HQoIWhsYLO5PfnGgusbp36SZK9ZtMr1nj98BH6oiAHXQaLJRWxEWM8+6XIrGrbh8qXiMFhsdrHqemUEyeEldlorfWKdIYAQJVWw4GPkGlVednpO61ojLV1C2YG/kb7Jy6VmOwkozYOv23aARda3EXbWOojuOOPW
 lhvAIVBa
 AwYZYCE92SuHtC2Qs011X0VzjluKlaYB4I1HJHwg1ZW/402X3ErAlpyAwv8ITfArAE+T/7Cs1pjZib78qpt2efjDVcFoH+yvcklfJ312CT3KMfs+kge12cgVc9G07f59N1402Q6FqDKRCzYJ0SZY1BgXa39tGk0ZPnqXuE8Pceg9Dpgay/1NcWnv7vlW2/qfZda/LpfnxBpBm9FzUiFiD8LX2TdOhUV0kozDq6i2u0cPRzLEsevjF/ZMJbCoL1NEVpNPYef41l6YrNnKRR6nxA2MRUYHyda++CDIRSoDy0VIBoNIVv+TGqGftLUYB9foQdHGn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The per-node usage reported by hugetlb.<size>.numa_stat is accounted
against folio_nid() in __hugetlb_cgroup_commit_charge() and
__hugetlb_cgroup_uncharge_folio(), so it is only correct while a folio
stays charged on the same node and in the same hugetlb_cgroup.

Two paths move a folio which stays charged, and neither moves the usage
with it. hugetlb_cgroup_migrate() only moves the hugetlb_cgroup pointers
of a folio migrated to another node, and hugetlb_cgroup_move_parent()
only moves the page_counter charges and the hugetlb_cgroup pointer of
the folios of a dying cgroup. In both cases the node (or cgroup) which
was charged keeps a usage which never goes away, while the node
(or cgroup) which ends up uncharging the folio underflows as soon as
the folio is freed.

Patch 1/2 moves the usage along with the folio on cross node migration,
patch 2/2 does the same for the folios a dying cgroup reparents.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
Hongfu Li (2):
      mm/hugetlb_cgroup: move per-node usage on cross node migration
      mm/hugetlb_cgroup: move per-node usage on cgroup reparenting

 mm/hugetlb_cgroup.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
---
base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
change-id: 20260915-for-hugetlb-charge-2cfada8ed44e

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


