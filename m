Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18FFCF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C106B00C8; Wed, 19 Nov 2025 08:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECA36B00C9; Wed, 19 Nov 2025 08:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FA26B00CA; Wed, 19 Nov 2025 08:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDDDF6B00C8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:25:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE5D9139E9E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:25:01 +0000 (UTC)
X-FDA: 84127427202.06.FA297FA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B9FA40002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cQBNlJKn;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8Y4NHrIQYi6qPSzB+CeopTmCEBOE1d4Xp99Y23zUhw=;
	b=5C8+RvnQeZKc7boBDjkkhe+EGKZnlGGToKhP87ErnCtgZG5JKjvepM8dQZLK06kKPmYPKz
	oiPYd8dWeo08W6LUpQHHAnTedFqjfI+YKXkDisDMu4r9bXyq58I7p/Ryb7qNVZiZieYRvI
	JhG4yhmVpS8NoDIQ25MWvxtGTgph72Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cQBNlJKn;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558699; a=rsa-sha256;
	cv=none;
	b=N7pJXF5HEiYxE/LiE4fE221bDBWnOf6Q/t/iW15dgXu5mzB5iV1+aqKM2vcmLdXW1Ny2Mb
	VZa60nsxWH5DA+lFcmyDyonv1+kZCIPL8DvHVocoK3LS0jeAKVXu3FSshuycTtL5QrB8x8
	W/xaG0nF/mSKcay5ZQMyuEVuHixppm8=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ8hAdF004165;
	Wed, 19 Nov 2025 13:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+8Y4NHrIQYi6qPSzB
	+CeopTmCEBOE1d4Xp99Y23zUhw=; b=cQBNlJKnVVfmMQe7/vf81YyQhvWCH09tw
	fd/7bJ2b187mZHGjPXPJPdwqvnzG+BJxgtzyfx1s4VbJpn8t7bcqbxkdYK+FXEHv
	hz0sU8fL190iYnDcUELdErJQmL44T5GP32Qrjv1XQ9mtFfY5VLVYc5s2krdA8g4E
	EffiIO6l/3xBOF3bv2nOXJD8IzUqpl4zdhr81rXozTKM+Zlb7FTatFmUas/p/Oa7
	7Wsf/Eve4RUYhcQAYXt2wBwo/dVSnUPiLOkUjc/HStNwBLqOM6ZoPq4JOY+KO46h
	tY3ABiK9RunX6TWNDNNV768Dbx7S7HeXVLwq0GkZCPiy74Fj6lf5A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw8mxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:34 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDNXvJ026408;
	Wed, 19 Nov 2025 13:23:33 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw8mxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJCAQTw006954;
	Wed, 19 Nov 2025 13:23:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af62jgkc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNSfA41681354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7263E20040;
	Wed, 19 Nov 2025 13:23:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D596A20043;
	Wed, 19 Nov 2025 13:23:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:27 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v12 04/13] unwind_user/sframe: Add support for reading .sframe contents
Date: Wed, 19 Nov 2025 14:23:14 +0100
Message-ID: <20251119132323.1281768-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691dc4d6 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8
 a=yMhMjlubAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=-WfIxybQAAAA:8 a=-28QZkuTYErVj2SHl8MA:9
 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=wa9RWnbW_A1YIeRBVszw:22 a=2JgSa4NbpEOStq-L5dxp:22 a=KbVuYVxSu7xg536452LQ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX162RBLxhqDp3
 qdcdA2NwaHOoJaezcUkd13iF/TayUoQk0huiek0m4/ZvsoSoE/JsebTW8xsg/X+DW2Auop0IE3k
 wYze9YFM3uhvrjvq7+cgaOAkoD2pVPrg03PSdwVnGW7xGUvrSijyOVNjqQ2e0knLDrDgU2iVQX9
 G1CzMB0Ioq9lLAXr56L1NwfGkmzp2mbWQqLpaKCD9N8QQh9dVBY6ZzFIO9qzOseGEh92rkwNKfB
 5FnerNxkmzT8+acmDinr509dIj7Ia8QjJ1mOp2tRDlabK4+nea9MBTptjD97c5UkxCguglvVYNZ
 Q2hS0qqlqWUgBd8/2Rji6jlxuZ7K+W//0cm46qr+AJrmG7cJ8UJU9jIumhkObTnjopVDheKkaFE
 PmMw+53+nuxum0ENQRvqiFk8qv9TQg==
X-Proofpoint-GUID: VZhm1qOSD-oxe5zgkS4edmB0kYmv7mEp
X-Proofpoint-ORIG-GUID: FKZyC4gFcnNl1PaM8TWVkzvLbLtx4L7l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B9FA40002
X-Stat-Signature: mcy1kgrfnhr3my3orbfiiceyg1yfm8r4
X-Rspam-User: 
X-HE-Tag: 1763558698-492303
X-HE-Meta: U2FsdGVkX1+m9HwOhStip5FaTPRZUizvO7om906AuimV65wTRUsPFiMtbiX2zos2a8EvaGYufnDlD78yP0qEuq1Oc3beUOwarvaLkbs+PzzDSXxHRG/rUdPb/LqRHgMdBVOZKzBbj31XYnXro3DYzxSTSbVeuTaMTAXXRsjW3u6Ax3m+ypS+BDlyWcnq6ZTlUCRmDSReFfzq1rSBH2eX1UgzBU1Kpk/V4t4ntlXu+5oPYDj7XJlHQTWUFVYmazX2lwnuMzLpBj4fks+4r+xbsXbCXYIZtqIQnfWYUojllLRcNarkoMDEnYvtnaRKUUxCbjKnFOC7AZVl7tAVPHz80dGCkd4cHlUIJVXNQE0kA8dQJSWCSf7dHcaojCSnTWB4I8TG9ctal9mpItexIlHzmMxHr+uGCk+HiPJ4pRe250hZBqhcJQslkY3sjo40ULjVzbPfY0GKQThwIDxCwJRSxx6sAAbDCTg41526VAOmGWmhY5Yf6SbX3ZiZpGt8c9Cu6PFX6JY6WPL/VPqOs8aF8JB1JzfTVolr0sIr1VJblJ9kFp1mUKg1ZaOOW1V3hzbKFBrkDoX4QVVkCTmctYnoOexgj3Ugh+bxNuvUUGQuOtSx77rYMzfb+oWeMetk4nU4JaDl18OCa+oeu0dFhp/c3z8J7t6JpthWTNJHm1tcQTPZNVwkCZssfTKCC/pJNMHNSq1vG9rYKl1sWHXn13L740Ep7+5HTFHMXmrFZFdcTlIpRBdNt7UndIGwhdeHYBNMcdQYXA3t7oB556y+F35hYt7s2Vs/JxIjm3rpJqjtQNw8CRJ3FiOsXa/Ix0ZWLD796j1dGJR6LfxK3d+fuYBMotS3WLh6LwussG3ZY27bQKANU54ItWk5z8h+Ei9ay9aFOdombQAFAUPX5RMjx2zHWdzUHsUCrwAww8WEtiUXDdXj3BSbz4cfvlqXTgl4HaiQf3PwETzwO7Ln6gNmwkh
 IBlnn6JT
 O2IeTwSvQu1+HUYYHQwNApefwnV9TcewcC300/OosodbonxaN7lpFi8/coQ44KCQO57w+xRr1HxGeJE2YlTUCXlbJQ+v21eKBMd8A5aiNi2Q6nx/Wg62M4jeQyyAiIhcIhWhsAjiN/kVFZuhdEmX6eWYTpUsJwp+jU9lo1FyVvHjF85zsH90/U30lytbgHQR59NhtAEjrcqUcp8HMhIdedU08rNF6kK+D/BbUYh+y5GqX+xhHOEBGy1F2D3hk1Li7rla5hyJnx30xtifRD4COxpSa3VYFKwMf5wSWmLOH0AjR1kf6LIyf8pmVHJJ9A8IMkeh72GoACspZsbRSlDv7to0Xs14PlGJxknJSbhDeZyKLYUMTj6Xq9xlTQNFU9fN8y3z4ArpH6NxEAUs8QxjnHzappJGefiDVJx7gnYY7xDeYKxhIlKY4P5WFqxrsuPbwdiho2yOcu8OGomN0fG9yZAr8PZ/qeas5Gtn7pNaMY0wPDZcKbXoGX779haq7eXmr4O38y78mFpCoqK6JLs2YJYQ2p58Va0zncLrSeaJYpvh8qDHEyD6wORnjVXPnpvyrMmxjLff9PvkBZk30u/Ji2OI8e5V9ynGlsiG7Za4HHbntUT36XD0Jw0r90S1fa20Iry/J6EO50jlqLfj2z3e4dVLgdlJTjBGdyAK9FWyyJQY/7BFO8ga8XDir5SniYIF7DvJlByJ6NfjXszx97jOIIdn5zEpExlX5NjELno+lRC9LXYkKAbOmQNPRmWF2KBdiaYuuh/9tDxzskimYtttpuqEEEmhhLlEAGANmLGRWibO2dDcGmDEM7kueNbqdYw0hsQshfdOL0fTX538JUCgCRCvKBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

In preparation for using sframe to unwind user space stacks, add an
sframe_find() interface for finding the sframe information associated
with a given text address.

For performance, use user_read_access_begin() and the corresponding
unsafe_*() accessors.  Note that use of pr_debug() in uaccess-enabled
regions would break noinstr validation, so there aren't any debug
messages yet.  That will be added in a subsequent commit.

Link: https://lore.kernel.org/all/77c0d1ec143bf2a53d66c4ecb190e7e0a576fbfd.1737511963.git.jpoimboe@kernel.org/
Link: https://lore.kernel.org/all/b35ca3a3-8de5-4d32-8d30-d4e562f6b0de@linux.ibm.com/

[ Jens Remus: Add support for PC-relative FDE function start address.
Simplify logic by using an internal SFrame FDE representation, whose
FDE function start address field is an address instead of a PC-relative
offset (from FDE).  Rename struct sframe_fre to sframe_fre_internal to
align with struct sframe_fde_internal.  Cleanup includes.  Fix
checkpatch errors "spaces required around that ':'". ]

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>
Cc: "Jose E. Marchesi" <jemarch@gnu.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Jens Remus <jremus@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Sam James <sam@gentoo.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Carlos O'Donell" <codonell@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v12:
    - Simplify logic by using an internal SFrame FDE representation,
      whose FDE function start address field is an address instead of
      a PC-relative offset (from FDE).
    - Rename struct sframe_fre to sframe_fre_internal to align with
      struct sframe_fde_internal.
    - Add include of linux/unwind_user_types.h from "unwind_user/sframe:
      Add support for reading .sframe headers".
    - Fix checkpatch errors "spaces required around that ':'".
    
    Changes in v11:
    - Support for SFrame V2 PC-relative FDE function start address.

 include/linux/sframe.h       |   6 +
 kernel/unwind/sframe.c       | 330 ++++++++++++++++++++++++++++++++++-
 kernel/unwind/sframe_debug.h |  35 ++++
 3 files changed, 367 insertions(+), 4 deletions(-)
 create mode 100644 kernel/unwind/sframe_debug.h

diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 7ea6a97ed8af..9a72209696f9 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -3,10 +3,14 @@
 #define _LINUX_SFRAME_H
 
 #include <linux/mm_types.h>
+#include <linux/srcu.h>
+#include <linux/unwind_user_types.h>
 
 #ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
 
 struct sframe_section {
+	struct rcu_head	rcu;
+
 	unsigned long	sframe_start;
 	unsigned long	sframe_end;
 	unsigned long	text_start;
@@ -27,6 +31,7 @@ extern void sframe_free_mm(struct mm_struct *mm);
 extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 			      unsigned long text_start, unsigned long text_end);
 extern int sframe_remove_section(unsigned long sframe_addr);
+extern int sframe_find(unsigned long ip, struct unwind_user_frame *frame);
 
 static inline bool current_has_sframe(void)
 {
@@ -45,6 +50,7 @@ static inline int sframe_add_section(unsigned long sframe_start, unsigned long s
 	return -ENOSYS;
 }
 static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+static inline int sframe_find(unsigned long ip, struct unwind_user_frame *frame) { return -ENOSYS; }
 static inline bool current_has_sframe(void) { return false; }
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 149ce70e4229..d4ef825b1cbc 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -15,9 +15,322 @@
 #include <linux/unwind_user_types.h>
 
 #include "sframe.h"
+#include "sframe_debug.h"
+
+struct sframe_fde_internal {
+	unsigned long	func_start_addr;
+	u32		func_size;
+	u32		fres_off;
+	u32		fres_num;
+	u8		info;
+	u8		rep_size;
+};
+
+struct sframe_fre_internal {
+	unsigned int	size;
+	u32		ip_off;
+	s32		cfa_off;
+	s32		ra_off;
+	s32		fp_off;
+	u8		info;
+};
+
+DEFINE_STATIC_SRCU(sframe_srcu);
+
+static __always_inline unsigned char fre_type_to_size(unsigned char fre_type)
+{
+	if (fre_type > 2)
+		return 0;
+	return 1 << fre_type;
+}
+
+static __always_inline unsigned char offset_size_enum_to_size(unsigned char off_size)
+{
+	if (off_size > 2)
+		return 0;
+	return 1 << off_size;
+}
+
+static __always_inline int __read_fde(struct sframe_section *sec,
+				      unsigned int fde_num,
+				      struct sframe_fde_internal *fde)
+{
+	unsigned long fde_addr, func_addr;
+	struct sframe_fde _fde;
+
+	fde_addr = sec->fdes_start + (fde_num * sizeof(struct sframe_fde));
+	unsafe_copy_from_user(&_fde, (void __user *)fde_addr,
+			      sizeof(struct sframe_fde), Efault);
+
+	func_addr = fde_addr + _fde.start_addr;
+	if (func_addr < sec->text_start || func_addr > sec->text_end)
+		return -EINVAL;
+
+	fde->func_start_addr	= func_addr;
+	fde->func_size		= _fde.func_size;
+	fde->fres_off		= _fde.fres_off;
+	fde->fres_num		= _fde.fres_num;
+	fde->info		= _fde.info;
+	fde->rep_size		= _fde.rep_size;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int __find_fde(struct sframe_section *sec,
+				      unsigned long ip,
+				      struct sframe_fde_internal *fde)
+{
+	unsigned long func_addr_low = 0, func_addr_high = ULONG_MAX;
+	struct sframe_fde __user *first, *low, *high, *found = NULL;
+	int ret;
+
+	first = (void __user *)sec->fdes_start;
+	low = first;
+	high = first + sec->num_fdes - 1;
+
+	while (low <= high) {
+		struct sframe_fde __user *mid;
+		s32 func_off;
+		unsigned long func_addr;
+
+		mid = low + ((high - low) / 2);
+
+		unsafe_get_user(func_off, (s32 __user *)mid, Efault);
+		func_addr = (unsigned long)mid + func_off;
+
+		if (ip >= func_addr) {
+			if (func_addr < func_addr_low)
+				return -EFAULT;
+
+			func_addr_low = func_addr;
+
+			found = mid;
+			low = mid + 1;
+		} else {
+			if (func_addr > func_addr_high)
+				return -EFAULT;
+
+			func_addr_high = func_addr;
+
+			high = mid - 1;
+		}
+	}
+
+	if (!found)
+		return -EINVAL;
+
+	ret = __read_fde(sec, found - first, fde);
+	if (ret)
+		return ret;
+
+	/* make sure it's not in a gap */
+	if (ip < fde->func_start_addr ||
+	    ip >= fde->func_start_addr + fde->func_size)
+		return -EINVAL;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+#define ____UNSAFE_GET_USER_INC(to, from, type, label)			\
+({									\
+	type __to;							\
+	unsafe_get_user(__to, (type __user *)from, label);		\
+	from += sizeof(__to);						\
+	to = __to;							\
+})
+
+#define __UNSAFE_GET_USER_INC(to, from, size, label, u_or_s)		\
+({									\
+	switch (size) {							\
+	case 1:								\
+		____UNSAFE_GET_USER_INC(to, from, u_or_s##8, label);	\
+		break;							\
+	case 2:								\
+		____UNSAFE_GET_USER_INC(to, from, u_or_s##16, label);	\
+		break;							\
+	case 4:								\
+		____UNSAFE_GET_USER_INC(to, from, u_or_s##32, label);	\
+		break;							\
+	default:							\
+		return -EFAULT;						\
+	}								\
+})
+
+#define UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label)		\
+	__UNSAFE_GET_USER_INC(to, from, size, label, u)
+
+#define UNSAFE_GET_USER_SIGNED_INC(to, from, size, label)		\
+	__UNSAFE_GET_USER_INC(to, from, size, label, s)
+
+#define UNSAFE_GET_USER_INC(to, from, size, label)				\
+	_Generic(to,								\
+		 u8 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
+		 u16 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
+		 u32 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
+		 s8 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
+		 s16 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
+		 s32 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label))
+
+static __always_inline int __read_fre(struct sframe_section *sec,
+				      struct sframe_fde_internal *fde,
+				      unsigned long fre_addr,
+				      struct sframe_fre_internal *fre)
+{
+	unsigned char fde_type = SFRAME_FUNC_FDE_TYPE(fde->info);
+	unsigned char fre_type = SFRAME_FUNC_FRE_TYPE(fde->info);
+	unsigned char offset_count, offset_size;
+	s32 cfa_off, ra_off, fp_off;
+	unsigned long cur = fre_addr;
+	unsigned char addr_size;
+	u32 ip_off;
+	u8 info;
+
+	addr_size = fre_type_to_size(fre_type);
+	if (!addr_size)
+		return -EFAULT;
+
+	if (fre_addr + addr_size + 1 > sec->fres_end)
+		return -EFAULT;
+
+	UNSAFE_GET_USER_INC(ip_off, cur, addr_size, Efault);
+	if (fde_type == SFRAME_FDE_TYPE_PCINC && ip_off > fde->func_size)
+		return -EFAULT;
+
+	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
+	offset_count = SFRAME_FRE_OFFSET_COUNT(info);
+	offset_size  = offset_size_enum_to_size(SFRAME_FRE_OFFSET_SIZE(info));
+	if (!offset_count || !offset_size)
+		return -EFAULT;
+
+	if (cur + (offset_count * offset_size) > sec->fres_end)
+		return -EFAULT;
+
+	fre->size = addr_size + 1 + (offset_count * offset_size);
+
+	UNSAFE_GET_USER_INC(cfa_off, cur, offset_size, Efault);
+	offset_count--;
+
+	ra_off = sec->ra_off;
+	if (!ra_off) {
+		if (!offset_count--)
+			return -EFAULT;
+
+		UNSAFE_GET_USER_INC(ra_off, cur, offset_size, Efault);
+	}
 
-#define dbg(fmt, ...)							\
-	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+	fp_off = sec->fp_off;
+	if (!fp_off && offset_count) {
+		offset_count--;
+		UNSAFE_GET_USER_INC(fp_off, cur, offset_size, Efault);
+	}
+
+	if (offset_count)
+		return -EFAULT;
+
+	fre->ip_off		= ip_off;
+	fre->cfa_off		= cfa_off;
+	fre->ra_off		= ra_off;
+	fre->fp_off		= fp_off;
+	fre->info		= info;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int __find_fre(struct sframe_section *sec,
+				      struct sframe_fde_internal *fde,
+				      unsigned long ip,
+				      struct unwind_user_frame *frame)
+{
+	unsigned char fde_type = SFRAME_FUNC_FDE_TYPE(fde->info);
+	struct sframe_fre_internal *fre, *prev_fre = NULL;
+	struct sframe_fre_internal fres[2];
+	unsigned long fre_addr;
+	bool which = false;
+	unsigned int i;
+	u32 ip_off;
+
+	ip_off = ip - fde->func_start_addr;
+
+	if (fde_type == SFRAME_FDE_TYPE_PCMASK)
+		ip_off %= fde->rep_size;
+
+	fre_addr = sec->fres_start + fde->fres_off;
+
+	for (i = 0; i < fde->fres_num; i++) {
+		int ret;
+
+		/*
+		 * Alternate between the two fre_addr[] entries for 'fre' and
+		 * 'prev_fre'.
+		 */
+		fre = which ? fres : fres + 1;
+		which = !which;
+
+		ret = __read_fre(sec, fde, fre_addr, fre);
+		if (ret)
+			return ret;
+
+		fre_addr += fre->size;
+
+		if (prev_fre && fre->ip_off <= prev_fre->ip_off)
+			return -EFAULT;
+
+		if (fre->ip_off > ip_off)
+			break;
+
+		prev_fre = fre;
+	}
+
+	if (!prev_fre)
+		return -EINVAL;
+	fre = prev_fre;
+
+	frame->cfa_off = fre->cfa_off;
+	frame->ra_off  = fre->ra_off;
+	frame->fp_off  = fre->fp_off;
+	frame->use_fp  = SFRAME_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
+
+	return 0;
+}
+
+int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
+{
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	struct sframe_fde_internal fde;
+	int ret;
+
+	if (!mm)
+		return -EINVAL;
+
+	guard(srcu)(&sframe_srcu);
+
+	sec = mtree_load(&mm->sframe_mt, ip);
+	if (!sec)
+		return -EINVAL;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+
+	ret = __find_fde(sec, ip, &fde);
+	if (ret)
+		goto end;
+
+	ret = __find_fre(sec, &fde, ip, frame);
+end:
+	user_read_access_end();
+	return ret;
+}
 
 static void free_section(struct sframe_section *sec)
 {
@@ -120,8 +433,10 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	sec->text_end		= text_end;
 
 	ret = sframe_read_header(sec);
-	if (ret)
+	if (ret) {
+		dbg_print_header(sec);
 		goto err_free;
+	}
 
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
 	if (ret) {
@@ -137,6 +452,13 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	return ret;
 }
 
+static void sframe_free_srcu(struct rcu_head *rcu)
+{
+	struct sframe_section *sec = container_of(rcu, struct sframe_section, rcu);
+
+	free_section(sec);
+}
+
 static int __sframe_remove_section(struct mm_struct *mm,
 				   struct sframe_section *sec)
 {
@@ -145,7 +467,7 @@ static int __sframe_remove_section(struct mm_struct *mm,
 		return -EINVAL;
 	}
 
-	free_section(sec);
+	call_srcu(&sframe_srcu, &sec->rcu, sframe_free_srcu);
 
 	return 0;
 }
diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
new file mode 100644
index 000000000000..055c8c8fae24
--- /dev/null
+++ b/kernel/unwind/sframe_debug.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SFRAME_DEBUG_H
+#define _SFRAME_DEBUG_H
+
+#include <linux/sframe.h>
+#include "sframe.h"
+
+#ifdef CONFIG_DYNAMIC_DEBUG
+
+#define dbg(fmt, ...)							\
+	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+
+static __always_inline void dbg_print_header(struct sframe_section *sec)
+{
+	unsigned long fdes_end;
+
+	fdes_end = sec->fdes_start + (sec->num_fdes * sizeof(struct sframe_fde));
+
+	dbg("SEC: sframe:0x%lx-0x%lx text:0x%lx-0x%lx "
+	    "fdes:0x%lx-0x%lx fres:0x%lx-0x%lx "
+	    "ra_off:%d fp_off:%d\n",
+	    sec->sframe_start, sec->sframe_end, sec->text_start, sec->text_end,
+	    sec->fdes_start, fdes_end, sec->fres_start, sec->fres_end,
+	    sec->ra_off, sec->fp_off);
+}
+
+#else /* !CONFIG_DYNAMIC_DEBUG */
+
+#define dbg(args...)			no_printk(args)
+
+static inline void dbg_print_header(struct sframe_section *sec) {}
+
+#endif /* !CONFIG_DYNAMIC_DEBUG */
+
+#endif /* _SFRAME_DEBUG_H */
-- 
2.48.1


