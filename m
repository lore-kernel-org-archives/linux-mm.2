Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFCBCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027ED8E0013; Mon,  8 Sep 2025 08:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AFC8E000F; Mon,  8 Sep 2025 08:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E305A8E0013; Mon,  8 Sep 2025 08:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2FFC8E000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:47:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96C5816014F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:47:58 +0000 (UTC)
X-FDA: 83866060236.09.3386FEC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA6B7120006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:47:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OblUx51x;
	spf=pass (imf29.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757335676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aevj+k7+HSbyx1kuE19JILsk9KtpoCEGQ/zs/FNoek4=;
	b=A8KF01yYwv1y95QyJuE7c7v9MKthZfwMUcbsLNe8XV6/UlF3Ie7TEMBLR0cETy5ekqeuQm
	0VsVdv5DxAgTmlhAFoVsOqprp8OAg38CoULukYhF2HUCfZNbRYjJ3mdZitbZonbJSsF+OH
	U/XI+JnOLEM4GqNsJt4+dY2fZu1R0sE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OblUx51x;
	spf=pass (imf29.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757335676; a=rsa-sha256;
	cv=none;
	b=JP/HIi9f17hoXIhIW//QPdklMcpWGIzOHQNsaNPyU6EHCZUXiU6gcPU8TRY+/Tiv3mdNVJ
	GbxauyO2Q8CkCk7pQPeo12UCZ90IGW7FQSR+49FlHM3ny8G6NjZiiKUQZXWhBuJqJjK17J
	Xe5tnSwMH9xwgd98f+WKHQH3LCKx+h4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757335675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aevj+k7+HSbyx1kuE19JILsk9KtpoCEGQ/zs/FNoek4=;
	b=OblUx51xXIA2fDP40lLHFeUIrTlBGzEorHfPYeIYEXA3hor/Cx5hzE02D2O4hU3049aMPn
	b0oQCo7OtDiJb9vpJon8KTUAy/yIkFy9Xl2AoIWd9GFVLPd4af5fk8SzhczJ4uMJFOz2xv
	CbnhNZeyEIpzWQMgN5n+pvEHHfWeHEE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-i4kBMdJ5PL-PQnfrQkaxNg-1; Mon,
 08 Sep 2025 08:47:52 -0400
X-MC-Unique: i4kBMdJ5PL-PQnfrQkaxNg-1
X-Mimecast-MFC-AGG-ID: i4kBMdJ5PL-PQnfrQkaxNg_1757335671
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBA2B1800451;
	Mon,  8 Sep 2025 12:47:50 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 271C6300018D;
	Mon,  8 Sep 2025 12:47:44 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com
Subject: [PATCH v2 0/3] Fix va_high_addr_switch.sh test failure
Date: Mon,  8 Sep 2025 20:47:36 +0800
Message-ID: <20250908124740.2946005-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: DA6B7120006
X-Rspam-User: 
X-Stat-Signature: 4qwu6aeutzj17jy3dqm5pcjmty9q3esh
X-Rspamd-Server: rspam09
X-HE-Tag: 1757335676-237578
X-HE-Meta: U2FsdGVkX1+RH2PIOrLQP06udUwm9KPjpG49dckpetmfDdntNm8Htc/ixf+ISYIlss8S3a7eIgQgE73SXdcI7aDNYYNPB8i5jK10L0VB0MEovr9xconteEc9mfayr5krQM0XPdMU7nwX1/DUA+GTrshlY4NhOrlaLFklZ7JU3UI1j6KmNYeTem+H4OiNSAHh12DCiIxdhprbswwMvmLLVaAaC0QT0G0V930kqGYfGECg/xUf3mefg5YZiJKd1Vi6/bgu4+J2yEouOq7IupBTqrp3Ydda3wHL++lecGUGQ4aJUDGTi5RVQIBQBXI6MrlHbpTemENPHXICVIJobsU/RtWp4d7xHsWIxKUwwTXPHihRB4RD+Q2SRzeVOlnI9CCZ/ahacAfJmmJlPRFNOFwa9n7lgDAIIdyIo8o78KDzUR9UlhYc6qcY5ZxmaQQP2gIxgF6YX13YT7rWRKUTEZHB00+lwwWkIoQpHfLi/I4D/OzjB/hQFRQAANl+lzByNMNsG86sBsThhjRa9DsbyJsK5yx/o0iTT/beE4i/hOZSv6LllMRJfsHtV/RsKKyawbOUDlO2ZmQj9TDahTHhNNNusjLljhVzk5Ho9Ft3rNAGhmvnaCSHnXTZve5qIc0zMjp8z7a2Yhl/ruzz9x5SacQKEJGGgqyjawmXZeRum4OmQnWJsID4hl42zqEwQV6qdKO6GmvQhQM3NvUU1SASwuikHc0/Mq/N4R49B5RSAm3O918fnXkoyqgF30+C9K+KtHNKDOBSZ2HtRiYuiyo5ROECOfov2ZFaizOcTXRdTXk6iRigGHO6N4D7EPE4RqgzqBbk3pNPJ5Nsdckrhb4XrRElmfgeJN/M/WgzFhfg2cVaEypaFSAw2KaMJ3UXd4xnICMCJ8unZxy+6FlU5ahVCuhhf54D87hYi7QuGwPvSre8ket8XsQM9METdLXj9YIfGFXCnBfnq8vHuv1mv6Ws0XC
 UuEwirFD
 +mtlKM5C1hVQEGiYCwJrseCtKNtSWpbSsj1bKUlG7IBIxkL+bj70oa1ANrEyeodowN5/7XrD3S4uTBzbNk2lK9BYQYXAskU2ubcvxDV6LrPrTVWH1zf55qWH5u1WV2qWwOrOungbbOUB7rDArlu1m/lJ1GTxxqLArGc2os7BU4RZvkmU3Eblu3Te/zymqYrkjJb0lcUC7mfmaUUWSX7z9LdOy8boN17YU+O1T8M0omTRmRDmj9Ejq/AJP+DADhP3dHfntoEcaXj3FfUOABluoToKJaBoajk15ImHs4Nw8K3baFsVPehwd3WZquNZQJ30dFCFOqfUFxMHExxC6PDFhg1nMk2ufxuYCpqhC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The three patches fix the va_high_addr_switch.sh test failure on x86_64.

Patch 1 fixes the hugepage setup issue that nr_hugepages is reset too
early in run_vmtests.sh and break the later va_high_addr_switch testing.

Patch 2 adds hugepage setup in va_high_addr_switch test, so that it can
still work if vm_runtests.sh changes the hugepage setup someday.

Patch 3 fixes the test failure caused by the hint addr align method change
in hugetlb_get_unmapped_area().

Changes in v2:
 - patch 1 renames nr_hugepgs_origin to orig_nr_hugepgs
 - add a patch 2 to setup hugeapges in va_high_addr_switch test

Chunyu Hu (3):
  selftests/mm: fix hugepages cleanup too early
  selftests/mm: alloc hugepages in va_high_addr_switch test
  selftests/mm: fix va_high_addr_switch.sh failure on x86_64

 tools/testing/selftests/mm/run_vmtests.sh     |  9 ++++-
 .../selftests/mm/va_high_addr_switch.c        |  4 +-
 .../selftests/mm/va_high_addr_switch.sh       | 37 +++++++++++++++++++
 3 files changed, 46 insertions(+), 4 deletions(-)

-- 
2.49.0


