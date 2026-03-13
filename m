Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB9B105A586
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE436B008C; Thu, 12 Mar 2026 20:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082976B0093; Thu, 12 Mar 2026 20:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED06E6B0095; Thu, 12 Mar 2026 20:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBC3C6B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:26:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 729245911E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:26:28 +0000 (UTC)
X-FDA: 84539148456.13.4E6C9D5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 59A351C0004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:26:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZHJhO/Ck";
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773361586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nE/5qQ6YtvkKGa4AVChhKiXkIX3R8WJepoP9vC2ImQA=;
	b=FfEoYOOvNCJKm8pHRckn4X/4VxvRFIWFLJ7ACa4h7UbwVWqySkjJHXj4i3bQHlKq+bUFmL
	vzM4OJCbHVcxHdppaGmUAxNMwUQSLtoEnvtTaMaqFDEzgflwzvcLjezTr0YjBlzETwOOZT
	1w5PXH0nx/Gk0R3hXhoWtQYgHYUwNkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773361586; a=rsa-sha256;
	cv=none;
	b=JiXdmDCMHHkfdGDMsa76EYJ9hFNq51mSecELD0P9MZgn+1t20YrXuUMA+oA4DugZdtffvZ
	R0I/7bqvq/t3NuY0lOLzy3dYrR/68FhJK67iqDosHVmO83I6S6EanLKE0aHIhSp8C0wtBf
	dc3+vUN/295bKrOQuW8xAeym9Ti5Z04=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZHJhO/Ck";
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773361585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nE/5qQ6YtvkKGa4AVChhKiXkIX3R8WJepoP9vC2ImQA=;
	b=ZHJhO/CkZrcJdhO7jNdfFFJukWtNUxSxmCLic+lvOVbXS5hCURZO2WVEmQqcmcK5JCeGmL
	vbESoxePbgptaT1hzl5Si6G12CEvYuCxKmccO1UvLlWnEDGi8Dq8a03J2QvddR18QA0AXm
	86WnuL/mU9aHFHhPVVO2MBwncYk/cjM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-gzx9QGhPMpeQBlVAMoUedQ-1; Thu,
 12 Mar 2026 20:26:22 -0400
X-MC-Unique: gzx9QGhPMpeQBlVAMoUedQ-1
X-Mimecast-MFC-AGG-ID: gzx9QGhPMpeQBlVAMoUedQ_1773361579
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 367B81953991;
	Fri, 13 Mar 2026 00:26:19 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.110])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE07219540C5;
	Fri, 13 Mar 2026 00:26:07 +0000 (UTC)
Date: Fri, 13 Mar 2026 08:26:02 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abNZmiL2C7KMQM1t@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <abLHz2qjdeNqdFaZ@kernel.org>
MIME-Version: 1.0
In-Reply-To: <abLHz2qjdeNqdFaZ@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: jaGqu_rpt73yTeuJGEIj7isCE0JqKvb8ZaXy3WPEuG0_1773361579
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59A351C0004
X-Stat-Signature: 1s5x55to4dxe9poyisd6pqar8zt6a9td
X-HE-Tag: 1773361586-48610
X-HE-Meta: U2FsdGVkX19hvE+/PqSSlaIn/X1LPZa6Vfy84fUSkgNOAOIVXdAG073lpppqZYiD/PVSvTW7E7+HGmkKT/WRMzdlhZELTpMegKuM50eiK2eEP4QCjKzU+6RKZCG9CtQmWL/Ga0YpM3aTr6vnkhm2y53igdHiwKXfxqXImmBEusSC20TYiiQ2lxKzx3GoSwM0yiquw8s4YAspJXzPVWmZJaGA9ocLeEISzfJjZHyTRf1vc7sCU6EXuZqIkXbSC+uF9yQj9dsSy+reSfS3qdCjzh8PJZMcPGvodai/ppbeU3ZNrstdtvqX73+v0QXrt55kVpNjyV1j6q8Nw9mzprT8i2VSnsfr5Vobw24IseXCkfn4GcX0CmGDE5ftKbeNjC61snkK7e4mvqJYoefQ4cbbsQQo7m5zip0orsv+DiC8UdMY0IeHIVUdWeHpwYX7M8g6sB+vuCOBVK+cUl86FdE9NNvoAo0lmsZ4tMr/WjC2kxdb23agrCYSc1HSae8A0qAQuUYjR+DHFwDNKabAlCQKcY5XCEuSTUyRf2YB+nl1KzjpdaawzCFojgws1qCPDfiO70MR7QX1DHNGr9DQe6e9COtaeU76zVV3vl+6CNHw0w+G+4OUFsSSvfUZrSaJ6M/EKOs5+LkedpRqKTg28Udpg16aCZ8Z3MuiQunVvfprInAttXkjkKyDebTj3cjxYBIBlm6jSJr00quoxNXJZ5RSd25ob1nFaqdZtDEa0BQ8UThZxUI15FIDHxKmh/oTZ13QLb1Y97BGbfV5PcFTb6bcSsPUPlKSJmSKqAxhFscvbfIiipgnmMmBFs1KGVzmnV8g/cELcWtQHbRNrUX23KveRP8MuiJ3DOYGtyB5doaellrJDgzrhJeJ+IOPuT/89f0rQL2yz/sxX5rCPklwHBxrsWVd7ma5+klgxM47LkV4zTCbabYtdLDgKyDVlZGv9zHQeTy8TKMv8G+dZnH/gZr
 AIatSV5w
 uK4eJ8IM6PXr0mRRpILa+rrqXXjGe7IvnIFsO1SS5+clTfdKKFHi0ML9R6uPeFaQGKr7WF+zGsIuGD26namA7OfGs3G5gP7RnumZYDSgTKmUAoZzVkI1CtqWgD8FEb7vYB5gm6a8hZHe2YXt+sDaoEY8oy/DkyjcCUyFDMJbsprZR2dvq55iAoQGokWU6A5O61KbiZDJattPULtodQR/3HEIxU3SdXs3qqYM5JCWqnN/5z/qn+zfuVBuXo0zhiu9tOPMFFpBcv87+8nxT1IOtkUO1lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 04:03:59PM +0200, Mike Rapoport wrote:
> On Thu, Mar 12, 2026 at 07:40:23PM +0800, Chunyu Hu wrote:
> > There are several tests requires transprarent hugepages, when run on thp
> > disabled kernel such as realtime kernel, there will be false positve.
> 
> I presume that when THP tests run on kernels with THP disabled they fail
> and it would be a false negative rather than false positive.


This is an interesting point. I'm not naitive speaker. I just learned
from AI. It really matters what we define as 'postive'. I presume 'postive'
is we run selftest and got a failure report, that's postive, not thinking
as it's thp disabled kernel and a 'pass' is postive.

I'll add statement about 'postive' in v2 like "a test failure is
defiend as postive"

> 
> > Mark those tests as skip when thp is not available.
> > 
> > Chunye Hu (4):
> >   selftests/mm/guard-regions: skip collapse test when thp not enabled
> >   selftests/mm: soft-dirty: skip two tests when thp not available
> >   selftests/mm: split_huge_page_test: skip the test when thp not
> >     available
> >   selftests/mm: transhuge_stress: skip the test when thp not available
> > 
> >  tools/testing/selftests/mm/guard-regions.c        | 4 ++++
> >  tools/testing/selftests/mm/soft-dirty.c           | 4 +++-
> >  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
> >  tools/testing/selftests/mm/transhuge-stress.c     | 4 ++++
> >  4 files changed, 18 insertions(+), 3 deletions(-)
> > 
> > 
> > base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91
> > -- 
> > 2.53.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.
> 


