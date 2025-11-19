Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B570CF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1F46B00B7; Wed, 19 Nov 2025 08:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BF56B00B6; Wed, 19 Nov 2025 08:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBFC6B00B7; Wed, 19 Nov 2025 08:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6866B00B4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D834B1604C5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:35 +0000 (UTC)
X-FDA: 84127426110.10.478240A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7482440018
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nX9N3hu3;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6kPIRP2V4xC9bop3HAzrj0RiOp3OhYz1ixTV3cCnWA=;
	b=tsoAMKqpvTHuQlGgEnWU687WL/4zFA4XXG+GxSLggDrpvorNzfLOCtlEaaXg482Sr8Sz+v
	zdS5QiBHUpg1KDPt+tZkK4olz4lhW/5NmLR+1Vt7MBRq/pa2HSQBNJPqJhTeOt4lTQd+hh
	urh3B/YZCwh8J5IBq6H9vNHYdQVGdgg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558673; a=rsa-sha256;
	cv=none;
	b=tUeXoO8LvLLRBSfqJ9d0pYjgQ8gATCDWNeMIyg2JXxmgXXfJcbGCrs/SD9s+cCgRpr7D9L
	KbyEuHSqUlv0rzEQH/OpMxblKu1KD1pJXLbn3FUBXJpgUqmtDU08QtWli2kjzBithLLCPr
	JL0W6dWQ/WHA1wh7AbCpVptXieXzPns=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nX9N3hu3;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ5ZEJT017282;
	Wed, 19 Nov 2025 13:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=V6kPIRP2V4xC9bop3
	HAzrj0RiOp3OhYz1ixTV3cCnWA=; b=nX9N3hu39b7+ImgH6FT68rBFN9ALgM6GK
	LR+iqwWGsdG1qfJ1gVYIE3QyF5SJgqaj4mmUj8kkE2nEHGueP4uoB21Y8yarVGiN
	ptljsxmpcCMFhZewzlhIZmZdRIQyspOIWF1aTpGRh0PwPJFf2T7znSnQY8eVJCdx
	sO9tzJ5wW7Up6fMGNqqkcDx7FcQm+LqxXPBxiW5hneZZxENx+CzSNlmce17c/8qI
	f6DrvBt6NqKwH2AGF9Oek6mAZuCin9BwX5jRlLIS2NQeQT4j/wM7N57rUedHvfW0
	dw9/+0fZtKwNY+q5JfIFwc0seoBVijDH1BQL17rlTPKlzGyaIIg+A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjtyrd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:33 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDNWkk006312;
	Wed, 19 Nov 2025 13:23:32 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjtyrcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJBZloP022354;
	Wed, 19 Nov 2025 13:23:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un0tbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNRcm14811482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4441F20040;
	Wed, 19 Nov 2025 13:23:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACAA020043;
	Wed, 19 Nov 2025 13:23:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:26 +0000 (GMT)
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
Subject: [PATCH v12 02/13] unwind_user/sframe: Store .sframe section data in per-mm maple tree
Date: Wed, 19 Nov 2025 14:23:12 +0100
Message-ID: <20251119132323.1281768-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kRV6Wlw-Ke5MG14iRe9Jmu_bwLXd5ixU
X-Proofpoint-ORIG-GUID: K_rJZM9akI58dsdx2HxJNlHP2Jgh_NXv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX6e+cIMW14mR0
 BZhPqG2H0WdZgzuoD5jeky4gjurbA6hvUqWGsLGtyd5+QTRtFtFannFGeV04c8E2MXfyGDMWspY
 qF5ybN52rzo/xf6WMRC63ZrhahB9JTypkE375CXvGYXSX6ew6oRauyD7MTs4dBiFXaj8oSq5TlC
 GxCuv2assZvxkYCW66dDRhC1zYQ3jm5qMnx5IC7AMlcNksc3e6ld2pGtiEoL4JYOFxbSo3VXfTi
 8DpE1a+OTo0SvjCMrbEa4tRnsaeF+h66jq57ftcBzxYn+IehPRZagts2r6cTGoNFAM1GBhD1x3B
 MePKmWbPrgIkkb4tQW4GxvpsAMMZlw1FQD5IZjf4TymBQRhhDd88/mzLTdCtmfO9SJan4EY0/wD
 HT0lAqOd0HQB9yRWPs1LlFw933ZmAQ==
X-Authority-Analysis: v=2.4 cv=SvOdKfO0 c=1 sm=1 tr=0 ts=691dc4d5 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=QyXUC8HyAAAA:8 a=oGMlB6cnAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8
 a=37rDS-QxAAAA:8 a=meVymXHHAAAA:8 a=RXTHCEqd-LlqM7lfn7YA:9
 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=wa9RWnbW_A1YIeRBVszw:22 a=NdAtdrkLVvyUPsUoGJp4:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=k1Nq6YrhK2t884LQW06G:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032
X-Stat-Signature: xcfjab5p4f37yihrxpsmgddbqcrncj8f
X-Rspam-User: 
X-Rspamd-Queue-Id: 7482440018
X-Rspamd-Server: rspam10
X-HE-Tag: 1763558673-687398
X-HE-Meta: U2FsdGVkX1+0LTSnmMRmqv+iYYKXV/1tB500STPoCxIS2knXLRhKBEOJBqYQ6e2AqprGZ4CKvp167yzE8U4l1yKIzvewG9DRlB3+3X4yZJvVLWbjZVU7l7XRS20YBd6/Q7PH0546Ht9JvGUVFLBmLOF0wG+CVEUu6c/IRDxmdu97AmP7zcgvePcQtneFDDn5GxBsAlZyrW0SgaUNk/o+kRUulE8z3/yyDdpDhLJUpHBDuU+zGrgAojNn6J0hTnqZCtVZDTEuM1W7ZpeFu6RhthUq2HEsRA2f+yR4tvqfkNVTPQIBosqVEtY1vWOIdjbx9CKrIJaQswbqtruQqpTUWjpwyhyccgbtxV7l2yBWflflnpiKgam9nBsqf9syf11LEeg/tRSItzedIyPfSkoygf9ggI/YRBVkeDmDrLyWlCFqzNhH6aIKDNe+4L6iDj6khm4gTjLU1JqqG83CvQSvxUGV7GkdM9RvDv/V/3WKZc7cwKY6krsjFmii4WAQBYG65xX6ajoOnCUxukp+TOTcdnGwTiYZolWsNqsLVe7BSHnY6dplK0nLlgqxa+3+Dfsq3ISMm6uGhOyxd56EMWfUu/mufVK4DvH9eHt2Q6q8ef4+FHh/eVzRj4umWT5B99Kx4nRfHCuLpJRVpuaLRQZpLEiHXJrk/sAcqdo5rhAnyG89M1/upRofsDeekP4/daJTmimjgWOKkQ/qWpQQDNpxVzNO15dNnR76Z0CCxlfWEyZvmzUdnrWHmOMRsXETXo73MpcgjfTQgwCvw/b0OSkeYtumRuDBKyzp21oD0YmTr+s5PHom0E5+axqeQ7dA2+O9s0ND6+SyJMffQxNWQ1zHTGWrCMaE18L/5S5oq6TCsxUF7hoXSmCfstENz+I8eQNqavcKMfC24EZHBY0oBNQKMpw8aRQGpIRV5fmapXqr//WuZYBTJi33TTYlN0bqestbhaSD4kEP+YurjBT4Byi
 s9HDZoNM
 wtlGnW8fHzBivNuWBQXtacxwgu8Mjrzjvp+IV7344MYjVqPu8nePISWQKCjME8cLxYWpCfgUquJudl5ScaLgeyuMXlg6YYEf2lZOp7pkh/o5zswx4Ws7HZEl8cq2KJDRubN8qmf+5Wj4a8g+9KTEP6qkngT/DwvSIJ0qxKpwc67l7+WE6wEzU3WYrEUpfMZM6U545Op0+iFg6JRNOAp0xpFEmW2SfCEnPXHQMV36Evte7BhPa0b75VrimmOirrf0GVmI0u9PkShBZnS5XP+5HZEm8hSADS6fFDEp5cVAvPdCuX7YJhf0wwM/7VoPTcZJIwOEAvQVgDgMhQ69SpLBvyIyF1FKeLlwKA8KfdQK3sDKBoUW6dMzBsO9qHzNCeA9YdbyyajR8M/F5fMramPN8nkWvqFbgbQHuV1wyS7nj+I0eY2HWnCBvWFUDTb6Q+CNJpvko5s9cRftQKJ5fHGSXU5DbzWeM0J8wZon1D+O0IuxgEPC4IRBf+GDLQiYy0QLryF5HCMFzyCcQWIIlKJRpCYMd5lVJQGL5uG7Be4oHIwjNkU7l58083yiG3GKjX9YuYEbdiOWHBTgMwC/UzKzpbsNIIYY+7nQKeSPxPtjKE7hCWWJf90V92xFijLi8XrautyBzEP6sYunqznqXxu8BJKcw/Xnr9+Ep8jjb86zGxmhoI+ePsBF7gCiQhRpsC+jcp9K8LEM6arF4IPD7/u1nT7vEOZ8Pv563E/D+wOyzu0LOyIyP5p99H5ux42Ty8rXTsdvtGxHY/bCjgw/kSwvCoe7wBCNjVwyo5OkGpwM5kUrSbWisCg83Hl7ALgP5DPGzgfXSl9YOU7AkcAN2V9N6KL0U+uB7ovqzfYHTjgmtp01futMJ3P3nga4rc3NF93P9MaCo8+SUwogavuNTVyDDkRUFYkxLoIwWgzFGzT7u+zWwEo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Associate an .sframe section with its mm by adding it to a per-mm maple
tree which is indexed by the corresponding text address range.  A single
.sframe section can be associated with multiple text ranges.

[ Jens Remus: Minor cleanups. Reword commit subject/message. ]

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>
Cc: "Jose E. Marchesi" <jemarch@gnu.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Jens Remus <jremus@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Sam James <sam@gentoo.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Carlos O'Donell" <codonell@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: x86@kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v12:
    - Add include of linux/mm_types.h and variable sframe_mt from
      "unwind_user/sframe: Add support for reading .sframe headers".
    - Reword commit subject/message to consistently use ".sframe" when
      referring to the section.

 arch/x86/include/asm/mmu.h |  2 +-
 include/linux/mm_types.h   |  3 ++
 include/linux/sframe.h     | 15 ++++++++++
 kernel/fork.c              | 10 +++++++
 kernel/unwind/sframe.c     | 56 ++++++++++++++++++++++++++++++++++++--
 mm/init-mm.c               |  2 ++
 6 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 0fe9c569d171..227a32899a59 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -87,7 +87,7 @@ typedef struct {
 	.context = {							\
 		.ctx_id = 1,						\
 		.lock = __MUTEX_INITIALIZER(mm.context.lock),		\
-	}
+	},
 
 void leave_mm(void);
 #define leave_mm leave_mm
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..01e2cffbd84e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1227,6 +1227,9 @@ struct mm_struct {
 #ifdef CONFIG_MM_ID
 		mm_id_t mm_id;
 #endif /* CONFIG_MM_ID */
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+		struct maple_tree sframe_mt;
+#endif
 	} __randomize_layout;
 
 	/*
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 0642595534f9..7ea6a97ed8af 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_SFRAME_H
 #define _LINUX_SFRAME_H
 
+#include <linux/mm_types.h>
+
 #ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
 
 struct sframe_section {
@@ -19,18 +21,31 @@ struct sframe_section {
 	signed char	fp_off;
 };
 
+#define INIT_MM_SFRAME .sframe_mt = MTREE_INIT(sframe_mt, 0),
+extern void sframe_free_mm(struct mm_struct *mm);
+
 extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 			      unsigned long text_start, unsigned long text_end);
 extern int sframe_remove_section(unsigned long sframe_addr);
 
+static inline bool current_has_sframe(void)
+{
+	struct mm_struct *mm = current->mm;
+
+	return mm && !mtree_empty(&mm->sframe_mt);
+}
+
 #else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
 
+#define INIT_MM_SFRAME
+static inline void sframe_free_mm(struct mm_struct *mm) {}
 static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 				     unsigned long text_start, unsigned long text_end)
 {
 	return -ENOSYS;
 }
 static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+static inline bool current_has_sframe(void) { return false; }
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..15c24411dd7d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -106,6 +106,7 @@
 #include <linux/pidfs.h>
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
+#include <linux/sframe.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -689,6 +690,7 @@ void __mmdrop(struct mm_struct *mm)
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
 	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	sframe_free_mm(mm);
 
 	free_mm(mm);
 }
@@ -1027,6 +1029,13 @@ static void mmap_init_lock(struct mm_struct *mm)
 #endif
 }
 
+static void mm_init_sframe(struct mm_struct *mm)
+{
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+	mt_init(&mm->sframe_mt);
+#endif
+}
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	struct user_namespace *user_ns)
 {
@@ -1055,6 +1064,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	mm_init_sframe(mm);
 	hugetlb_count_init(mm);
 
 	mm_flags_clear_all(mm);
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 26bb16f76a8d..149ce70e4229 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -81,6 +81,7 @@ static int sframe_read_header(struct sframe_section *sec)
 int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		       unsigned long text_start, unsigned long text_end)
 {
+	struct maple_tree *sframe_mt = &current->mm->sframe_mt;
 	struct vm_area_struct *sframe_vma, *text_vma;
 	struct mm_struct *mm = current->mm;
 	struct sframe_section *sec;
@@ -122,15 +123,64 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	if (ret)
 		goto err_free;
 
-	/* TODO nowhere to store it yet - just free it and return an error */
-	ret = -ENOSYS;
+	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
+	if (ret) {
+		dbg("mtree_insert_range failed: text=%lx-%lx\n",
+		    sec->text_start, sec->text_end);
+		goto err_free;
+	}
+
+	return 0;
 
 err_free:
 	free_section(sec);
 	return ret;
 }
 
+static int __sframe_remove_section(struct mm_struct *mm,
+				   struct sframe_section *sec)
+{
+	if (!mtree_erase(&mm->sframe_mt, sec->text_start)) {
+		dbg("mtree_erase failed: text=%lx\n", sec->text_start);
+		return -EINVAL;
+	}
+
+	free_section(sec);
+
+	return 0;
+}
+
 int sframe_remove_section(unsigned long sframe_start)
 {
-	return -ENOSYS;
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	unsigned long index = 0;
+	bool found = false;
+	int ret = 0;
+
+	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX) {
+		if (sec->sframe_start == sframe_start) {
+			found = true;
+			ret |= __sframe_remove_section(mm, sec);
+		}
+	}
+
+	if (!found || ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+void sframe_free_mm(struct mm_struct *mm)
+{
+	struct sframe_section *sec;
+	unsigned long index = 0;
+
+	if (!mm)
+		return;
+
+	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX)
+		free_section(sec);
+
+	mtree_destroy(&mm->sframe_mt);
 }
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4600e7605cab..b32fcf167cc2 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -11,6 +11,7 @@
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
 #include <linux/iommu.h>
+#include <linux/sframe.h>
 #include <asm/mmu.h>
 
 #ifndef INIT_MM_CONTEXT
@@ -46,6 +47,7 @@ struct mm_struct init_mm = {
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
+	INIT_MM_SFRAME
 };
 
 void setup_initial_init_mm(void *start_code, void *end_code,
-- 
2.48.1


