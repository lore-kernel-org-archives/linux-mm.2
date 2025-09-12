Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A21CAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144076B000D; Thu, 11 Sep 2025 21:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5936B000E; Thu, 11 Sep 2025 21:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25996B0010; Thu, 11 Sep 2025 21:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA4816B000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:37:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5009813B6A2
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:30 +0000 (UTC)
X-FDA: 83878885860.18.CBCB47A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 90AF74000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gnc1dqm9;
	spf=pass (imf27.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757641048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kg4Tx3pIqmU1F8r3Q0oIkJJVosGS8R4dAci1tkAis/w=;
	b=lpDcO+9D6jp0yoHU3G3tFs8i0RCbAdJISlTgDM/xEQsFl+o583oh9NRn7itUhlVcvQVIlQ
	w51i4k7rgXNousg01LJevClNJ+gkwI5YOMhPunnxySlBbTC37C3CT7XSVM9qo7BC618avd
	LxBhYfQAOwIK1dpBvplSTcaLRcd2UaM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gnc1dqm9;
	spf=pass (imf27.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757641048; a=rsa-sha256;
	cv=none;
	b=d0avbxkUHVsRdyXSSBe76TJ7XxDCiknu01gG6Qkdb0Ry3UDTTzGJlVBk/bdJBx1cmVe0DU
	xHO/nZGlpSv9RVpn4FY1wdXZ1SkcoX7t+N4HLrmbRJK4aAToy2qZumYVvuucZEyJzxt7r+
	jWj8snv02m4cgBTqfRPFffRygTDQCis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757641047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Kg4Tx3pIqmU1F8r3Q0oIkJJVosGS8R4dAci1tkAis/w=;
	b=Gnc1dqm9pYrqDKb6KFqczytRkYjK/2LG6rICMLFns3uZop61Qh3o+PYZex70cYzTfnQozI
	dEunqEKn9P9MuWya6NN5vCxv+15/L+NWpnlsSr6BnWgoPF0wdyEWeOfSzEdAdbkGHpefE8
	EXBQalxqvvOkOh01Jvvru3fo1T3gwD4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-XC26rgaoOHCdTMtdQ90mHA-1; Thu,
 11 Sep 2025 21:37:24 -0400
X-MC-Unique: XC26rgaoOHCdTMtdQ90mHA-1
X-Mimecast-MFC-AGG-ID: XC26rgaoOHCdTMtdQ90mHA_1757641042
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E5AB1800378;
	Fri, 12 Sep 2025 01:37:22 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F699180035E;
	Fri, 12 Sep 2025 01:37:15 +0000 (UTC)
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
Subject: [PATCH v3 0/3] Fix va_high_addr_switch.sh test failure
Date: Fri, 12 Sep 2025 09:37:08 +0800
Message-ID: <20250912013711.3002969-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 90AF74000C
X-Stat-Signature: p96wumep7e31urhzp5o8ec9erdc4yzza
X-HE-Tag: 1757641048-739115
X-HE-Meta: U2FsdGVkX19knUFqobWhhlm+xEZCdzt8/gz8BtKhTXzpBUVCKTv+hByeRxqo5Hnp0wcL82Iu64gGBmQVFkE6YvkpGWjOM2PbF95TmikGQpFifXzDFACCR/hyFfza4SubjWOfahVeDhG3iFqb7CBBvqhwJ8n2xJFAJ3q3l0ae0yJXKVverGcpa+PasfV9adR2O407vNvrgb+9QqmRGJ2VVI+P7yP9gsX1sp6ZhyajccMuXXa5Mrm0N6KBvO2PEzurVQjYnMdINuJsykS2Khx1V5JYVaBelgPyI86FvjNZEZn2G2aZTB/hueTtTdpK82Yg0E1V2OsHkfml0epn80Hy+5EIdZQdPOfhxbfJchG5JMd1saKuEUhJBbtfkMWNK7M9wCFEyyIVNNgqmbELO07SaY39T4OW+z0eihtWM7pLJucu8L4DfX3h/3/GrHIjJh3Pld5lVRUsVpaO1sBzmlGYcKNIUmuB1ME2aEh/o6yFR71SK4AlewTvP/svgiDA5PCy4JApcksJwcRdIVBcOobMSS6E6vLBuyKjDla3E/XjkSzASlOFY6Nz7oM2TKb8okFqjjF2J/VPEREYprxoTtP1+eC6VC+Mqqmf8cTwfITuA+sN1bqARZZ1/NQwYCbRycKal+Gl+iaiT4/maZFpOZBRmptyu3wxFcwD1SqF7ViV/ZE9UjVSAVJ8s7xbV5XSFueNdWdKxFuT+wAOL3DG5wTRlqcopme+QR6Xgo0X013+odUjfIR9WXzq5pjJZ3z5EkctfVOH+mOJ2lsqZEQ9FN0w50nM+liaA+Pt3xTTnbW7hAcQaNsOF5lVwss/V3LjCoU18ArhSYJ1EHbehAXF6sRLN0Iu0Pb/znbS2hnRlVbNPX3F5AKlF97wRlEKUVVc/27bzaPBgDIRAsvBDJAbhGQr0LcmQnpmy6kbki+2YCWQCWgd3NtvIxJ3prpOJ6SsaCdnnEU7u1BHyYFDTa5g3vw
 7my8U0XQ
 vsLLYP16e4vsoRFz/g1s7KYtMGvS5hzUq6xpX9pJndR4aV6h1GZ9IIfoaCJ5UFaEa20lWbl1f9/qX3MvCxdU533jTEqD8rEaoCW51trdHUDdPDdIKlhld0XolB8qaBIkFb8Mucsn+9xqcgsvUeDfIy9mUcAFGuG16XbHh5kZUoyyDA2SJLLsxsBh2Aot/gaiYNSEU6g9cTAcGDOe8iR3BP9RolLIgy41kq4Zja3u6iYatYpfLJYy0mFl/bN9w134am0bvzmg+IgjK4fzXZgJnZFerxewMt1CrrLJAUXbuVzoeR6nYM9vVPThU4F3p0KqCiiYfAglfzMw/qvTyus2uR8AJK6zpQgg1jnwN
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

Changes in v3:
 - patch 1 adds the Acked-by from David
 - patch 3 changes the mmap hint addr to hugepage aligned from page aligned

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


