Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D81CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5698E000B; Wed, 22 Oct 2025 11:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD438E0003; Wed, 22 Oct 2025 11:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3518E000B; Wed, 22 Oct 2025 11:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6928E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:52:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EEBC88BFD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:52:58 +0000 (UTC)
X-FDA: 84026193636.03.B510113
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3769E40014
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:52:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tMDA5rzf;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761148376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDHL76OkYT1/0d+aGsHSUPmnkAR1wiVZ3o8d2Ik7EL0=;
	b=VjJyvSFF8afNk4v1CD+La6+E262uDa67n9TwV1fbR2sUrdD5OcjKN3bAvfmFP6620nZgMN
	HV1BiCvAWcCm0gZnmB4LM1sx3eaBNnoN3RAoToy5Bk8pXsePfq3sRHA96AI4YAZs3dzx8o
	ceHLdusF/JE7T1hsbrvpfo3xusammB0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tMDA5rzf;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761148376; a=rsa-sha256;
	cv=none;
	b=mZgoDY8wmp0GsLzTrGy1cRA5caPQ7JOLMUbG6YZkeawRKAQD0FQ43EN7Jc5CEHo2663Gj3
	Pxm1avkUtyw+r8ssalvMhtEG/J2aGbom8ZuwxQQrfdbe0iFio/f7KdiymFYclnGAmDVR9n
	QQe6HTDWT2yWaRegUkQtbqO9sZb0dm4=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MDas6h003010;
	Wed, 22 Oct 2025 14:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DDHL76OkYT1/0d+aG
	sHSUPmnkAR1wiVZ3o8d2Ik7EL0=; b=tMDA5rzfIyYw61aavANqY5dtPQ6/O/Wzm
	fkmwKcHgfCOQvrDRTZPfrhTIx8qGv3yrJ/qc4KMDTQog725tSK0JdeD1n5XxmHyq
	mRk5bn+zP5gwB4Z77mGCvSkpNOwQ9H370qRgDGpnB1Gbj3K8XHHO0vvjQZRLJW1L
	9QBBMOaqwTdodq4LVLJaTiFXoKf7DwJkjlVxs/I/n1gafb3O12MZzTwbttEqm/k7
	q8dyWyveHzNiZ1xDZyxwyLv1NGaADRh6UgnFqCiMryfZ0tHlEzVn79yZvQzHUMDL
	9LYCQdQFb9IAJlY0j97H5CQpzkrw/NfW8EfaMexIwg/eDiioMyRtA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vuuxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEdCHb004523;
	Wed, 22 Oct 2025 14:43:34 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vuuxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MEGC56024303;
	Wed, 22 Oct 2025 14:43:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vpqk0smq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhSuX49873200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C09D42004D;
	Wed, 22 Oct 2025 14:43:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 552282004B;
	Wed, 22 Oct 2025 14:43:28 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:28 +0000 (GMT)
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v11 01/15] fixup! unwind: Implement compat fp unwind
Date: Wed, 22 Oct 2025 16:43:12 +0200
Message-ID: <20251022144326.4082059-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7R42UHwINrLNnxXhS1YO1T4b33MfRlsl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXy4bqe94vf7xv
 H8A1u+70jZoJVpd6CC1YGdhTOyEqeo7x/MKLlgo27jTFX/Sh5MWw3b86yw21sP4lUXgNUOtX60V
 jMsWnW1S5VDMEWy+tBXBkUKu+KTsGyxWG8CVX3+0fBFNLVH4oCyXJlkkM0P7huaLPujquFpBSmy
 Q0Rj4kmes304GqjZab3CXrjbL+gV0ZNsgLc2j0w+x6fIsi34bHQRdTC+Gg/q+HaYT4fyOrqNusH
 7hpT+ZTqWNjwzRcVpeb9CZ/DMJfusTIYKxlC3NqPjhf8qr88z4YcftnHcWBzJB23oJ8ZNuVEkqB
 6jHOTE3G0YlhyMjJuZHXDStTDmfietm2KhYUbtfpGVE+BOfyxmRaS4xyeuFf1D4NNa94vPElAFB
 ApvtgKTNaq75CeGzHfLeF75+dSslVw==
X-Authority-Analysis: v=2.4 cv=MIJtWcZl c=1 sm=1 tr=0 ts=68f8ed96 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=VnNF1IyMAAAA:8 a=Dulmdrgfa1N6jiOmfnUA:9 a=1CNFftbPRP8L7MoqJWF3:22
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-ORIG-GUID: w9233WmVEFQ_ZMBLXM2HZ9AkeZQJa3UH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Stat-Signature: dc1m76gih35eoyqatxiriagrbqx1jpow
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3769E40014
X-HE-Tag: 1761148376-273304
X-HE-Meta: U2FsdGVkX1/f7jXkwv1yRYdb1bXNHDG2zpbSdnox9VbCom1onEh9vEZOC22Ld316HgOgsqrhFHcwkt1LlqSZQJaKHzrszSxc07bLb0e3RItlrTgGCGw3OD5c2m+TnnaxA6h9DhzJvl+yeFqVnCw677MnqtKMeEatKlA0bxZeZ78t7qMEUPJXAPc9J6ZTCcKVHLuYVxww03k4GRVtnL3MWgAL6lEkozfrkX/mn99jDQ4leba5oY0y7FWka/AvP2CAkxxd9LQyAcRCnNITkXuKX/7l4ks5unDa6scuUgV7PUC9v4aORc3gdFqvao5I1yXCgrxPwa8bCkN+PRmv/AQVPROnDrD86VI6F8U6U7xpGggHMSgUb99FxaHN4SYRaSwCceq5KLty1TcPJ4aBtSqTKBf8ZE59lgeE2WEtb+NZYzMBlys76euiMhP8etFYdJPuGPnyDJTfh7nyOXKQ6aB5+xSzfIhkaNKWLGwP3FjgzimRnsbP5iBMyL1Bt+L3HqwjaM/dlzHHeW1PnQX9XlMoVER5FCorwbuvAPmm21r5af+eeXOOWl9oeiz9UptzYps9wNzScnqDRs+e/UYjddJtbl1uVbOOolUM7ur89NkALsLUA/H461bzkvSwr4fWdzKevDVB7xAFNWA8dw7Ke446Bn4lEdJupaPwJTTsh0YygFDF5xUThfVVEPVr7NV+/OtYQKqN0nCQwoOdur/U4me0DOEhdoinD+Hv5wPkAgDiScYgR3aH9qw02NkuIdhVUASNKJBToKts5ifGN7dF0b8DdtDwDyf43NcyskQYJJ6p3DzKWWGU+nKElEMgeHESzCFDvtRjjzRqPKdX3gMFR9pbmXR+mMynrGfgsTZl+OPpvbwCypwF0baIdjENP3W+47mZf9PdrJYilXM+SYMG1nKkMHeQrLnd5GYM5xUafDTLDhmIQep0uKgaZ22+SPipalwPlfTCLI1eaaLMs5r/q5K
 uSOAA+OQ
 CzZsl7sxCGiC6MmffbAGMUC0yfxQDryQCmSK8OZHODvodRo701TWyCn7GLuj6oXntuujTxEayltXlIIsa91eZrOPvDzLifLtnxS1yK8mLeoPUcE6g/z99sLiRqcMakPUBRvoaIJ0HeU8gLGJFd7pCtvIwQOWxQtdRfS99hlxrpHjqRw7yL6LqEewW7sGVPXqMy3SXRpHIuT9hNUCwGnhqFzLN4rvW50b7XB57Xk5hdWNOHUJEGSs47IkFI4ZFXJtwE2nkIlcBT6AcrrClnvXPAVQwVWtffLN3qbtK2UHtirkIUjvuduzjCdm6Ke72/viJF9dARBY2MOEcWzo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    This fixup resolves the following issue for unwind user sframe, that
    got introduced by Peter Zijlstra's patch "[PATCH 11/12] unwind:
    Implement compat fp unwind" [1]:
    
    Peter factored out the word size (i.e. 4 for 32-bit compat or
    8 for 64-bit) from the frame CFA, FP, and RA offsets.  This is an
    issue for unwind user sframe for two reasons:
    1. SFrame provides absolute offsets, which would require to be
       unnecessarily scaled down only to get scaled up again prior to use.
    2. Factoring out the word size from those offsets requires that all
       architectures/ABIs guarantee, that these offsets are always aligned
       to the word size.
    
    Limit the down-/upscaling by word size to unwind user (compat) fp.
    
    [1]: https://lore.kernel.org/lkml/20250924080119.613695709@infradead.org/

 kernel/unwind/user.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index bc1bf1e83d65..696004ee956a 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -8,19 +8,15 @@
 #include <linux/unwind_user.h>
 #include <linux/uaccess.h>
 
-static const struct unwind_user_frame fp_frame = {
-	ARCH_INIT_USER_FP_FRAME
-};
-
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
 
 static inline int
-get_user_word(unsigned long *word, unsigned long base, int off, int size)
+get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
 {
-	unsigned long __user *addr = (void __user *)base + (off * size);
+	unsigned long __user *addr = (void __user *)base + off;
 #ifdef CONFIG_COMPAT
-	if (size == sizeof(int)) {
+	if (ws == sizeof(int)) {
 		unsigned int data;
 		int ret = get_user(data, (unsigned int __user *)addr);
 		*word = data;
@@ -32,6 +28,9 @@ get_user_word(unsigned long *word, unsigned long base, int off, int size)
 
 static int unwind_user_next_fp(struct unwind_user_state *state)
 {
+	const struct unwind_user_frame fp_frame = {
+		ARCH_INIT_USER_FP_FRAME(state->ws)
+	};
 	const struct unwind_user_frame *frame = &fp_frame;
 	unsigned long cfa, fp, ra;
 
@@ -44,7 +43,7 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 	}
 
 	/* Get the Canonical Frame Address (CFA) */
-	cfa += state->ws * frame->cfa_off;
+	cfa += frame->cfa_off;
 
 	/* stack going in wrong direction? */
 	if (cfa <= state->sp)
-- 
2.48.1


