Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F271FE63FFB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 21:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E046B008A; Sat,  4 Apr 2026 17:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416E66B008C; Sat,  4 Apr 2026 17:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352B76B0092; Sat,  4 Apr 2026 17:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 280CF6B008A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:06:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5216C2A14
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 21:06:40 +0000 (UTC)
X-FDA: 84622107360.24.5AE9EC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2895280008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 21:06:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t1syRjMY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775336799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLOphtOSxFF18BPRgBiFugNL6vsoAPYB1SwgAdj5+TA=;
	b=mx1gaTtKpjAXwk/7FhW/u/Srtiapw2f2W1BVzvQShqpOFCnhaKIs79H1f3tmFCBsjj/s2X
	26Iheg9ZDEm9KbRwQryChE7pRf4kGqclfm6JPoaemfeWuuDzCYpo34Do/TVLgazfTlouvr
	/yipFZTYb5EScKmUnFePQzMgghbNLD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775336799; a=rsa-sha256;
	cv=none;
	b=l7KzPnikhea+4YfLU3gIHxTKl7ZlKJ4lW1v7KKgtFIcU0qFOhi7bznhzWuFuggRHwilmvD
	xn1CkePBXao6aIxFq6am+WdDCcxDFCNzR9iHSrXifYDLpCl1yH4iRzTZHXpeTjwX2vFpSl
	C11PGm31KWHEAnrpBAdt2p0A+gA0zZE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t1syRjMY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8979660054;
	Sat,  4 Apr 2026 21:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F194DC19421;
	Sat,  4 Apr 2026 21:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775336798;
	bh=4SryKwM7vsegLO0c1BFP+xu0X8RY5OoE3Nf4Yl1SFh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1syRjMYle4xMK+gSEsZrcuYSNG1IxBD6oDNJNvj60aCCos1ZGIJCcinPiEHdzH2F
	 0/8Qk7SwJrsUZDScopGiUSi9sNUdqJVHOaI465T5900BmJtO81RujxH/aHQYOhGwB2
	 6zenI80UAnJlu0lBDGmBYbxJ/u+GRuHu1BQLZbAv2x9fJgGreuGGNMyNkKvXu4sDbk
	 sgk8+bdXzlEZLqjItXYRUrBnAhCnjqv9i9JEnj2kHCCxxBcjaaXgwJWMZAeIlggg4D
	 dFHJV20oRnsIPTl6W7j3LbvBrrbRqYaLjMdmZbnaa7yYBOcWJ+TW0al2b5IwfgjToM
	 AIz82ny77TGpg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH 0/9] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Sat,  4 Apr 2026 14:06:35 -0700
Message-ID: <20260404210636.87762-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2895280008
X-Stat-Signature: n7zfxo5g49mqskeonp17wqy56w7sp3d5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775336798-555317
X-HE-Meta: U2FsdGVkX1982swd44+WGi2Ohj0U4+wdW9F7TI3JekiA1SSl3oI/U/2pqVCbaXRTGNEFCfZ/5FXSLaKVBpmNgUZ/5KTfOsOVmuFXnnTTVCoRFBsHSvTZ+tJ4j7+QadUjSNiVZAzfh41ynp9fqvsLm+tha3bO/WTn6v9QLsavUTsXCVTNSc3Udbq6G2eHoPKLlvPIyjNJjjwFjKJIkkA3E3IlnV3Pi0Wlhj7SNI2gwIC+cetwhOUtPG5JmlB9GkwUeFNTr8WTlB8XScwUjGeKOqt77PIp3xL2tZZTBxQAY80J7vXcd0zFaveGcVXTyIssamKFPQ0iI/sjsykuNJtmeQ2+ZHB7OGCTDSTjMJ9G1VtsrjISPazQGz/atNV/kU7piHv0vmMjBtWARmI05gsXgcvoe9GdxWCsIM8ojys5NEONbIJe4lF6WI0j84RQ2QlK5jEjwpuwXPGFXAz8KPsR0E//0RqRx3AghXph6YVumKTsnLZysroaQc2sXuCBiIlSAOrPs/bV61FXUbo+0ZFeiU7OlSOBxQ6mF/JAjrDaFc85H7lf9n9w7Q6fn9NYRz6hBub+i98A15OW4hzBC8UDnNwdgzsBxkkWLYNnE6r0mViCMOoIU7g8wW+1n6EShxId76vNkaZ1HGxIZ24OqVAuRay7qjyl4yKeNKW2oMU3qlyUW43vzFNNVcZgocGC/y3fgcKurc3UV84x+DyceQdXyS11iD12r98VjBsD+kKn4aBKKY86JK05qlG5lsBcYmgN6pzpgy5PVQX6kSIb41TZOFjtUswGjiUMPTlAtXTlrDjp/dU0HvJFHd53KwNdxTIf8BwiRBuwsfQcrii3roVeoLokKYusBXiELGlEoP/YFkAY+FV9j4w319ke6IC8CN5h9VkEf9xoqqHCuJlceCHS/s+4jPcFnK2wI6xHpjBHq1CbPmSMwAV0xoYv+8i7edcR/toZJsq31eQSBke42AQ
 1js2/5L9
 ioE+VOpn4DIJLvOaWMDdV+VrapwPiUuFTOuVoc1vQqBH9hyq2qIf8/9kt1zO2woMS27vU3hB8MEEuZ+fKDXyQ4wqSGRk4+GsSdZfOh0jb0s3qOBkDazsWW0ivXZSjdPHmDuOLjCjX5Q4wWrIzAYl/kvWZoKlXb9G6NClvQgnayycedeQ8nIo5BmiWGjqmbbL1frRgcvWIIZyiZk7/XQi4aZv2jO5ZQD57kRG29398aokJW1Hfau/ly69oeuSV8uZTACmisOvr2L90RiV6Hn0kWO9EUEZbt1zdttb4jl4Dtr64e9wAZPL/CsrD1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dropped individuals from Cc list to reduce the traffic.

TL; DR: sashiko made a few useful findings.  I will address those in the next
revision.

Forwarding sashiko.dev review status for the overall picture.  Read my replies
to 'ISSUES MAY FOUND' patches for more details.

# review url: https://sashiko.dev/#/patchset/20260404163943.89278-1-sj@kernel.org

- [RFC PATCH 1/9] mm/damon/core: introduce failed region quota charge ratio
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH 2/9] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH 3/9] Docs/mm/damon/design: document fail_charge_{num,denom}
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH 4/9] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH 5/9] Docs/ABI/damon: document fail_charge_{num,denom}
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH 6/9] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH 7/9] selftets/damon/_damon_sysfs: support failed region quota charge ratio
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH 8/9] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH 9/9] selftets/damon/sysfs.py: test failed region quota charge ratio
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260404163943.89278-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail


Thanks,
SJ

