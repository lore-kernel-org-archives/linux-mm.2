Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A9AC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751AE6B0095; Sat, 19 Sep 2026 03:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702406B009D; Sat, 19 Sep 2026 03:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC4F6B00A0; Sat, 19 Sep 2026 03:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3293C6B0095
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:13:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A48C4A45F3
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:13:33 +0000 (UTC)
X-FDA: 85229646306.19.3167FDE
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00549A000A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:13:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=guQXvhMO;
	spf=pass (imf25.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789802012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AwQsFaaF5KGdcLtlg+j+YQG7OiHlq2IqvQxHexSosrw=;
	b=q/w3NLm41T/hEHqqtOHjm2lbYCe0q2o4EmhEpNx7ElSqHfTlMw3Wc9WsJVzKwCQiZTHBY0
	s+ZP0VkGHRhbpVblZ2pVSlDfwms0EhsCrpuibtWM2cxa75IErqBrR9Dgfy1IrRwNfkkpV7
	LGMY2nvlwtB/FJWUe4UhpqHxz15XpMs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=guQXvhMO;
	spf=pass (imf25.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789802012;
	b=22rnfuyTunpvEZ3dbsi7IlmOti+XdWxZYwxZZI/KrDnMnszWhvfnkZxruTp6259c8eZhsv
	SewXmIoI336PyPoW+oLbvmirJdgvVH84jI/EM5HtD/A7ILGPUCAsjivcIAeQntBtVGYVUj
	yagK2P2kGbPuSP1DXOkzR3/RudCbl5E=
Received: by mail-pz2-f41.google.com with SMTP id 41be03b00d2f7-cc50d1b048eso1272863a12.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789802011; x=1790406811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AwQsFaaF5KGdcLtlg+j+YQG7OiHlq2IqvQxHexSosrw=;
        b=guQXvhMOU05L/ZcggHnuVRF96cQd1f+qClJoNhK4EJEJaKnQZ7MV+3mbMCnz4LROuN
         7Jqs+yTg+rDH/h/xQjElfP4Vp75C/ZEkbr+UMWj7CchykE39IByZvTDuo4RoS7gSTzjV
         lT8MCZiqOMgGfYSL6ECAOcjEYrkuXGKLLZz9L/oMJsWzNt+zTn+WgCell6kzJGDnLjRH
         o9R0aAnb7mPtu03Wq+NB06UIR0EmA8myCta9R2whLUOEyl1CZ4s7G7upIpd0yNsnOAqw
         c5/fTiAgsXjakLySnnr4D+3cU/z6y/Z91raZYLLZtsefCSzlZoxdxXhejMHOiDgtih61
         VRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789802011; x=1790406811;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AwQsFaaF5KGdcLtlg+j+YQG7OiHlq2IqvQxHexSosrw=;
        b=OdzdRjP+dequBKqi+3MFQHucO/BzrpSE/Y0BYgajgW3SiGTdv07gbmKjOZkHKZK3fl
         GCiaHr71nwvm4C3j3Fy1Myx/lmt57Uwzw9eH+yMOkxDiOUHqc/RdUNJ1lI4hSuDtIImP
         z25qJCTJYLGurfB9/+9jfxIxObwZ0lSmnjlhB+A7mtyvCjrWr67As41ZZe+9OOPCb6/y
         5gcF2Bvk6Ac5j3KDn2FedEZTJZdf4+gxJq37ANDwGdU3NfRDcIBvMdVJBbZyvkN4VTQK
         tno3fp7KqvgdMkvTIO8OY2XTAsLki00YiIrjUg91FZ+8hPPq6MH/rTU9PGK7AmEizVEz
         ckkg==
X-Forwarded-Encrypted: i=1; AKwUvBziURP8oyb5v0MwVyTXyMS9Q0Lv4NI+qyssXUsLfPtxEQuhiSJGZO+hV38f13T9y11OdS1cIDJvjw==@kvack.org
X-Gm-Message-State: AFuF++kT9bS+TtbXzXobLn4dyqo5xmtsH+Bi4WTP2ol6zuWq3Yu76gwh
	TeyLfntvLE9Yv4upqqVfZJbPOhPVeY0Bham3qccUzbwO+Z+EFlRAs+w=
X-Gm-Gg: AYBFou2l7qfek1G6aKF5ZFxsji8qynmeIk2lozxvVLwBY4XRs2ruN1s+9ds5BpXHh/M
	2XNIlhH4AwyTZs5P9QQfXRd6CVqTPEh15fI/M5/YIOWb78K8B30gD6KBi7hN1JgcN5h9+qA8D93
	FhakBDhOHtckIeITZjX5Sp11rDmID8s/lRB2UuSrBbEKHTeAipqIonfzaqXTJvtwNKJlEg01FCN
	bzcuPirmf9jGbb2rNUZlCOkq6ei8lQoquldln/m+xD9A6/Cfoc6xfvIkL7kBfKr+BJIiQ+UGCYy
	ut+dGFnmHBsGPPFY382fYqQnIAbM3scTP77NciEjmghkhZDdoRIoBU++sw1K2A9t2qyjxV8VOsL
	k5qMPOJDl/7Kg2yY8xh68H2qtsK69V4Kte7IZaePZ4aFuulkXXRUiTXvHnCRAfdVZ9/3Zq5uwvA
	ZOF2cdolFBNLUDlPA9xmrsXEWPaQ+byfYy668KOfsMPajmM2qlcBIW30MtKd/OvuEhjswleSsk9
	EWv4TS/6JpsaNy7x5ypUOiWVYU=
X-Received: by 2002:a17:90b:2b45:b0:39e:6a80:b795 with SMTP id 98e67ed59e1d1-39e6a80b8b1mr3373413a91.37.1789802010653;
        Sat, 19 Sep 2026 00:13:30 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:45e5:9e39:6356:6164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a02738654csm1050170a91.3.2026.09.19.00.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:13:29 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH 0/2] mm/damon: fix the temporal goal tuner's size quota conversion
Date: Sat, 19 Sep 2026 16:13:22 +0900
Message-ID: <20260919071324.1583280-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xu3du7pdha6576gnekebmxn9r875ipgb
X-Rspamd-Queue-Id: 00549A000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789802011-631606
X-HE-Meta: U2FsdGVkX1/J2UtHAIZ5FTtnKjMPuhC+JEhymMTSVNHFvsngcHjTXytqohM9j6cwp3Yw1TTw5BS5p4ctOabnWBg5cuGZZGIMJgBlc359AFgNjq3GKNiVd6owxxY86JuuBxgJNF9WWaHaz5zWV7dPz4mKEAsmZgo/WHHCtRPAyu01yzbhPmaUWwh9FokMDQkFbEvC6eWDUE49uBvMCPnzeRB5eSlX+LPc1fwu0U2ui2/ivu/KKda68J2zWGmeUHSv2T7dlnJLk6VtRouYE42OmICaaD0Uy8j4RUHZJbRXyXYrvY36fGZKhCLfQFT1tGwEvWDn8dlNRegTID1J6gAno8O8thgE95oSaFFTUlGRf4tKHirFCobglQPEl+ddzY7YeQQ8IpXK0vx/cpmknv/0uiuNJGbb/MnFqIv2Yb/CW4qwZlArMwkQI3liQCZnRmxfoQW8k+NuiMgZm14E8gekKfBKYcLr2dVzrGqtP43+PKYm1NgSVbxViq1bQylFVccWs/G4fJKnvUL6idWyQW1JSkPT9S7MDORf1huAkA8qWeGPO1AbshI7BAEAY7Bm3IfuQH5dbpq0M6Cs752I7iMb7YyiCGPaIUy53Tm+W2x63180a3fD6S8Hn2p04ztDV/Fwkq+tClH4ARRAf73lS/hsV1X3GCPJFqqzzDjQDVnLlfm9goBpSrinVrVVZFAWrtnH3CCi2eXAIF4sWqr3460Cg9M3vw6I/5kYfdFuqGcfIfz7lzbEtCs/Wq4CZ2CoW8782n2qYErWeC9AoY9ODF/ZBRGyQVevRD6PRRqBFYeG5eh735FlyMZBkVMu793wa1UKl7ly2kLjUnw4t9+KGrqXJK4+SJgos6OcPEkQprRR7/oOd8Y2hjGzIeltypun1ueGj3OTj1GqnTui+pWni/InNRrzMO8KH45vaW3QRO//PbDFRifWN++n/fcm/NPTvDnwT0zgao0hrLeTd7x3Hws
 dilxupw9
 MnaFkYq+Lt2C6rl/TXNyceQ8qr8I+6ULT9su9OOJDxeURZqq+yMiQDIjAWPksK9vuGYrbxcqH67YWsvu9eUwuedddNYAqXIA1ntAH5tLdW+uoec/AIGoquZWX+c6TX4LW5fIOmh6sOBjJU6uSoRVraFPYHvhvfG6StVFNIUlubrO00spGCh7CgXEtC34aWinyQ52NdULtlJtUzQoEelDwNBi6ZQDZ9FXWw2dLeiXyYcVrhzDRLxVZ2x9LeFeAzW15EOh0zbTcoSKbRVVekKwDRFamQEKTetP/05mBmVsNm8bw9/L27uCJMunBC4Vh6MXB421FqsDwBNTdfynRyPj8S8Y1yjsdfmpDXomoDoFNDLSYh+pQdGfeklGeSUAPsmgsOK9X6TS1dQnb/dYxzb1E9KRpjYeQ8IEp7wz6twHxbuTlvNmm+A90IFjaTrjaG7q0hzRS5YFnJWrk4B2vRK+Ny0T3uThikRrbitFIwruryPiRUedajTuZRaGQ2dFlneCsHdvo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() hands the size quota to
damos_set_effective_quota() through quota->esz_bp in basis points, and the
multiply that gets it there is unchecked.  On 32-bit it wraps from 429497
bytes on, and wraps to exactly zero at the 1 GiB that
Documentation/admin-guide/mm/damon/usage.rst uses as its example, since
1 GiB * 10000 is 2500 * 2^32.  A zero effective quota makes
damos_quota_is_full() true on the first test of every charge window, so the
scheme applies nothing for as long as the goal is unachieved.

Patch 1 saturates the conversion.  Patch 2 pins the boundary in the core
kunit suite, where it fails without patch 1 on any word size.

DAMON kunit: 36 tests, all passing with both patches; 35 passing and
damos_test_esz_goal_temporal failing with patch 2 alone.  The DAMON
selftests do not reach the changed function: a build with a print at its
entry stayed silent through all fifteen of them and fired as soon as a
scheme was configured with the temporal tuner.

Donggeun Yoo (2):
  mm/damon/core: prevent size quota overflow in the temporal goal tuner
  mm/damon/tests/core-kunit: test the temporal tuner's size quota
    conversion

 mm/damon/core.c             |  6 +++---
 mm/damon/tests/core-kunit.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)


base-commit: 498ee28e5ec4727f829507c4a1bde3ab1b7704cd
-- 
2.53.0


