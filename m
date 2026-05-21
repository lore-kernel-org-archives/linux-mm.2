Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1EAACD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DFA36B008A; Thu, 21 May 2026 10:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390396B008C; Thu, 21 May 2026 10:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E7B6B0092; Thu, 21 May 2026 10:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1695D6B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8D9AC22BD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:13 +0000 (UTC)
X-FDA: 84791651826.14.83EA390
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6E9C640007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="e1zg6m/i";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odsVNex6R2VPSghnYDx1oLCB8plgZo4cXgSkUOTP2c4=;
	b=Mf5gUDe5r7Zj5YT0nMdm8nqyx/usr+u3zI1bVqHzieA6yaB+FPFTeT/JhU5TnqY4DmPtbB
	KyeSvo6syvBerDsaDwhboyWEtzu2BpGSK0p4tY7a3Zss6FSvQ6EL4RI+wh/ODft2aLelU2
	hh+4fwbG8vVljXH/hgldsOtBkS0Yzeo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373571; a=rsa-sha256;
	cv=none;
	b=8K1q8wHi1Qa3p2RbxYTg9x1/XPzDQrijLv+em4ISxNYMT7RzwyRX0o+Dd2EK3DPEZ0oCy6
	MqVmu7CVBg6RPWl+hd7Nrn2KPCxd1XSd5QXVvfplkQiJVaHdkLFI84+XCbM7JzVs/MiIg4
	yqpzgMEWlKQpXkrce8Z62ePla+zJfhM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="e1zg6m/i";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L6fYnI3442044;
	Thu, 21 May 2026 14:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=odsVNex6R2VPSghnY
	Dx1oLCB8plgZo4cXgSkUOTP2c4=; b=e1zg6m/iYlHhgLyx+hMuwAkAWk3ZzVC1B
	hLKRgi6y0zliDHyYukEbJqLRNpPszE9O/rfoK8J3C7hMt1oga5Fm9FVt+X7cao9L
	us8eq7TOGDSj32NBzHQKXhc1WzF6AeqvUF6v8JWaEjQdaFa56wbnLFbYRl3toqUe
	Wl13zVt8ztKByTSVIww/k3jD/1Jj3q64FYbZmQ6rstbre1B46cCmveWkWenD+2Pe
	XiyJ4WiE1ygNtxMutpqhNJYW3CF3IW9X88XTKDbrlx+DBRI4Taxn6zJ0lsoZ7JPE
	G6O6oIUzg7Ff/qdRvtnNsO9qBSLjkIWIPt6q8+ZgAbARWnnhDtmug==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawe81w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO56O027486;
	Thu, 21 May 2026 14:25:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w4pek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPn8I55575022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B9DA20040;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 218CC2004B;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Cc: Jens Remus <jremus@linux.ibm.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v16 01/20] unwind_user: Add generic and arch-specific headers to MAINTAINERS
Date: Thu, 21 May 2026 16:25:27 +0200
Message-ID: <20260521142546.3908498-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX92eZC6wen46x
 kxu8UG75ZEncSDV0735GvcPY4I9+w6aQWteAEM1zFldIBHPS/H1A/3mQy2tXIb3CqRS/sZrSXu+
 p7Jn0pLoFFuz9VcjINWcX4wSq+vUpbqFY6sHmwcHfC4+IpJAZ648LqiyDsA095TX3DEW8OAR3CO
 nQlPqPBE/0KI/ZcbvOvVglCSuokU6mVPIG/xi4FzOF6yGvNl8FtdC20wlYd7KJPWF73RyTGVJmt
 3XEP9iiTe3HuPvIHZmkEJCQ6dqbOx7FcjiYqZkPdkhuRfq8hryu9GkpFn1CaT6MTwi3QC/YafZA
 Q0R7/Gr3fIKpUWEUFED1xx7V8WD34A4rEFGnp64nZEA4qpmztglb3KFYZx96RVidb3QFQEGxxiA
 c5ADZ3Ek2IlvJBPVlc/g9EpNxjJSg1Y96QOtQ2BjlPtJi4NwRNGm2pIiHN9rwngS7f6BmHA3J3t
 Znr01a7wks369aWhEFA==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0f15f2 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=HxY8WkbW6gBkmJkjgtEA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: E0A2RAdLlwCHEwSkTaCKzShIPO3jyXhx
X-Proofpoint-GUID: WjzRShqmm6nzPcB1FGiCH2jEoUe8nwSr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E9C640007
X-Rspamd-Server: rspam04
X-Stat-Signature: j1h46fmb3q5ac6y9sqswf9z5r5acx8sc
X-HE-Tag: 1779373571-20156
X-HE-Meta: U2FsdGVkX1+OXg8QyHbrXNHmzRYDz5u3ShZEGhRp/pkt2C8It9WMrIygXCQbcqE5hDfjCNVhBtgqC84i6VybZDtdyqpRwUQ9rr9Xa+T7Fc0/3u5tFcxmLaOAfvj9BqQVyrKSlD8Jl/fceqqs7UGeshDlDqKTd4fmvfNvlVw2yTuHMFnG0UgkAc9I37GCmXgZkbwtDcLzrfr4Ahn6rGDbRVCWzhDOPpQAFCiYSxGiWAJuAhbQ26sfJSscGyhEDS/DVJ5/7OrUzMveyDuGy82HOxuV50Ms38b5syWr43yAEUUI4guXMkAsIgd6u02mQA8AtNzvARCQS0qkktSiCUzohBO5oIWfp+RNl2FX/X2WyNCw9uEPUeQF10mQZ5rz8QmHGlwF25m5TAwi3tdXGYoMntDlmG+c70uDEFkiQWSt/dJcZujnhobbVTTCL7l6XTo7GG2gAFhevW4kJnfRmRLSby/fhsQiuyW3qYafpHuRGO5HZsWtjGOXpcKWXpOMub7l2TtAl3Rqe1pjpBKx9nT3iofCi7oA/tkle6cTuYw4iz2+QOlrTKiPnZ3n+fepQnsr2xxGkgJbYMxMPxeaCXsnJHL+41C011pPx71MfnjW53zRbPmKszJuLaiucMi+MhrE4zUrtKr7fSc1BZMGUTea1JmTorGbWO7MaWZ43efR7zEw7Vt/o1KuqMQ5aLZ7NVaa2YkGoPmibgidoO9GpVpDS6LfWa8AqlveONTHgT4ITvmGvjijW40H8dN468GQB0WNpLgV69BQaAhBB6zafzfzRB7Co7fZ8tjojXn61q963Uvh6uuuN9rCBQQq7CMG/pFdCbxruljJxxZQVlZsI/ak6/cf3pM6SskiFepnOeqMSOy35ZRuw4TXxMozRpyu8wVzx9giSO6QYBXc5scimTh1Qd/JKbkPfCVC3ZDBintY+KU04PN3ml4o0frgw7q5Qi8st4MxaXoH31GZy1RtzmA
 owIkd+6v
 MZVlUjFXLf2qK1zI9haAyaVtTDrHI/xXEr8FdneRHULTTx4E1FwvKfD+vD+07qkx7Usbij4WMUFhtRURXtCz1ldYmrewVB1fZjG2FZkeyxiaxzxw3Wuy6pyOQ3fkxCsqK0hUOFe8IV1IhyGCdCJnD93DxCME73cXB+LTmHIt6B9KONVvJPtcuSbjSCyHMqxOh2UkgwerLfRhwJoEJaI9VeDim5llgN7vau2w5B44NX/IoYP4k0cWNx7VWRMYH6RYVlz937YcFTDvUuJmDnML5IPPG13vbHPSxkpXt0owW+0PUHyT+5wj8DsylH51/GxSH3LEwwXd2rkn64uFmi2lLeLdHQ5CAr5A2oqsz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 71753c6ed2bf ("unwind_user: Add user space unwinding API with
frame pointer support") introduced include/asm-generic/unwind_user.h
without adding it to MAINTAINERS, as well as any future arch-specific
versions such as the one added by commit 49cf34c0815f
("unwind_user/x86: Enable frame pointer unwinding on x86") which
introduced arch/x86/include/asm/unwind_user.h.

Suggested-by: Dylan Hatch <dylanbhatch@google.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v14:
    - New patch.

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2c6d79275c6..7434e9d7b33f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27874,6 +27874,8 @@ USERSPACE STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
+F:	arch/*/include/asm/unwind_user.h
+F:	include/asm-generic/unwind_user.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
 
-- 
2.51.0


