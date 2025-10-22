Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F03ECCD1BC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968058E000A; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1AF8E000D; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761258E000B; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50A768E0009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D1EA5B989
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:13 +0000 (UTC)
X-FDA: 84026020386.18.47E8A83
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA6B32000E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R3rdimgk;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCbcjA3PTVr+H/4DmoNYDCKvYaiixLcuYcyFCF+x3d4=;
	b=ok7stjLmQc+O1/zwpbweK7xHifPzmyeZ2bHU0IUEp7Fuuhw1NRMdGlfvFs/sjwsitkg0I/
	GkpLYBCo377z9WrcEw7owMMgpHlnX0bbMi5Yot3oA6LiJOPl8lqgmuZxtPnPaL2ht3Ig9G
	AjUXggHxmuf+IXZU7sgL87sVN5S0I40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144250; a=rsa-sha256;
	cv=none;
	b=0u2eFdl/wAL3JybHS8x3IFvlXAjchUELEHdRw7JNikWaUDzX+hC9KjLRQ8evSqtZ4bVOWS
	6HKQlEUsmg6fd7GE//8tFT33+9I1dfNXdQRkt9kwANKJekl2r0EfN5A1lAfM5xDw/V0/OT
	kp8/dT9K4FyoEDTidh8YTHYZTBB2AoI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R3rdimgk;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8ploD031838;
	Wed, 22 Oct 2025 14:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HCbcjA3PTVr+H/4Dm
	oNYDCKvYaiixLcuYcyFCF+x3d4=; b=R3rdimgkMWInnfYYg6sbqSzbyvBJ3m0wx
	7yAXPdajEzRChTORnBfkoqqfMRma15OwD6D8cEpc4iGyRsdne4yzTc16i/95JS9H
	ucwuf6jXNRzX7CSuAaxZ0y0tggUfjKqkDpl5TsHAMw4FLpIhPmvFLi0swHgpAna7
	dlyLVECFu9xFK+fqmvVgwF+v0cWADg2ArXxYk8nBKi4eeG7Pz/KL2St46D1t99bA
	flIJ6IATmGPw7A/wZFjhSxppDrn714PD7l3o/a2phuL9lP/cI9UVO73+RNfGUATL
	0RhrP+Rdi9p3zhVKgyyiDnXViJACqE/yG2oiV8FSIXdypu/4mUCuQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v33fdapn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:40 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEVf9g023060;
	Wed, 22 Oct 2025 14:43:39 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v33fdap9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MEIpBY032142;
	Wed, 22 Oct 2025 14:43:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vp7n0tut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhXCg37028332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3A6220040;
	Wed, 22 Oct 2025 14:43:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BB8B2004B;
	Wed, 22 Oct 2025 14:43:33 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:33 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v11 12/15] unwind_user/sframe: Remove .sframe section on detected corruption
Date: Wed, 22 Oct 2025 16:43:23 +0200
Message-ID: <20251022144326.4082059-13-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FMYWBuos c=1 sm=1 tr=0 ts=68f8ed9c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=UW-gzNxWWvgdzlWFvSoA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-GUID: oIfbTVUHrtJTM2sJS9G0pLw8GqDZEzBu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXwegpPzeg2E+p
 7+nycJkGH2Hh5HOJ4QsLTQwzT4xDfXrK9qzadu87TG6iOmlx629vMVI2xDWyaOQnfmaUazqGstr
 EBRkEwTah98rMV29uFn/JiqMJuDY/KZbM5YxAZp65OEba2naOUMXcd2AgmxRhxSucJvkhfeDfAz
 QGx/nCihqHf7gMhT1uIm8R3yEoVyS0D4/0ViYKIOjDEPo2AitYEoRv2M/cl0a7PNNmHWHT42f8X
 RCkorJjylj+XAZklmQiVuXRAS938hNhDyrE4jMr4pxO7MXZbHSMuIESYIbfss69TxyKUyXBDqca
 vVhFr7fHKLRcQOZhHrzGKjdOr4RQB+7GyOoOzaZJ9Uaz3pZcp+ubQpRJJWsV/E0+3nCNFHs6yBX
 HW69YsHOYW1ub8GBR4EKWDVwuF80HA==
X-Proofpoint-ORIG-GUID: ogu6EK98f3Zp9jHjZugcAbyQjHZxAOjy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspamd-Server: rspam05
X-Stat-Signature: bxqqkkyiu7gyxrygkxm8opz5o5bprhs5
X-Rspam-User: 
X-Rspamd-Queue-Id: AA6B32000E
X-HE-Tag: 1761144250-20626
X-HE-Meta: U2FsdGVkX1/Ry6tJPKfid/fZ9za5TO+U2TmJK3BaghT8S2ZchYjiKQU5rBOFMRB/KYCMnaYBfdL4ar1agw/dr3A4doUqb4To96C96LMYpukJQRIIEikPwkSiM/2lO2oL1w+82ZoGu5u4LFx621qPO73h4QBc8aU415LjZ/5uREFOgbAdtt8pyd6WQquQF8nvJ6ARPeBC6eh+9hUAhBf2i4NBPEvX+XWXNFv7VfoEJWwT0r6gJtK5zLsFiyEwvK2Cwc8pYQFyWN6mmOp58XwaB7uJE4f7d2s0kZc4/26A+1vGL37+WjmGqlf9da31o6GSDCsBk4cblX8sLw8Kmm7OMYLk+mRrDpgxdUsNEd1v4RTAED+VomtWkcEsqrC2RkPscwLZgxFnno//xwWGVnhWz8kspA9+ITE8MckuX+r8fpiCDPKlvYdA5hhL8OYfupW7EsV7vrKVBKBvBW4/ajViKDdV8ppMWbgoK/yfIMkQZeyzVMoRW/RNil4fdxVKOsKjRIaAVr5CvbQa2h3KXKwBaKXyWwF//GZs9RHN1UnK7oj2oAbuJrtZ3p/hybz1A296jyh2bpSxuniGYguhFSDP6DC+BHfherGdmeLwyT0jBS6VYIAywT3h6yLUTmGL55mZBjzIUbTNxEdUb0ZJKdUjwcAMX9Y3U+5mfL7L0AuSG4Bdjfbss6yMthU95sZUZlaZfH0vqDuux6zmPg48dxBWdZbd9eS7i8OzhbKriF07taDz4B5AbhhLifSTmf37BHwZIwwwwJqU7xEAs71D60ZGq5OzLD8VROgB42/yjQ0JWQuEZYXGAlY8Eez333maOxF9D2w6dkLPfyV8xKCnyPn3MbBSijKKoQuvtOyZIkfrGf+DenfTnOayqYR+jby4uR9zjZUV0HUQ+8OZ09StvdR4zp53ryqPcD5JuCPmq50LL71D8T+E8tJ1qBNtzB0YS3whp+CqjlsduYXioNdhLy6
 cTVSotgP
 xDjB/ocf7twDqBY8ITSTSVgfR4roCgy3Q4HYNqbvxRqT4rZotdFVEcgmDPv+s9wtKtP4/jgZbepsk2Q69QXtUDkmoL1Gz1suBcToQp0tLOY1aKB0Qq6/zs8Cw+vY5X2n809VApQo8OcVhJOWwiZ4Z9SnAHi0GPJZZQUJYMvXnCrHyHuO77tiMD+82zdIUpGAcQWrckXq9phqm1x1wWaYrq48kDIDHPwgzmrTuXOc1IrH/U3Ar07zelVz7gVISRWU8/nmduyVQ2tKy7PKldpK/CEPWbkHPGZxooMaT9UlLGdHeiDM3kNQiLUWpWFaBaAiu0GDrqO8UbW00DFLX0NGbXSDhZl1iEd04JM1t+/Y5nTiJGXIwmYfDBVvZjw45XqMoEHxAGaspG7Q6vwoPbODi9VQ1+gqSo3DPIaR3DolpY54CgpSbKY06TfJqMCnaseZIkTGg2mLZfJ4DOVsE4kGT3OukWTg/cRWlkPf7ye2v45jVV1dvn34xaMG/YxNEpas67zQ+Fh/TuPjTEWO/+Etwq+T90Xs9RYunNaW83h0lXpexGs+e+Xe/J7BCN1gjRzAaKSyGu262dqNXGb7xnvcgnIxyO2faxu20YEufnnd92JXQreg5c0QQRTROrsjw4ZBKEmYldeDgm6jxqeUYKuL6fGTteDg/fE7sk5Ow
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

To avoid continued attempted use of a bad .sframe section, remove it
on demand when the first sign of corruption is detected.

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
 kernel/unwind/sframe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index bc3e2eb00325..77ef1f0bb9c5 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -330,6 +330,10 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	ret = __find_fre(sec, &fde, fde_start_base, ip, frame);
 end:
 	user_read_access_end();
+
+	if (ret == -EFAULT)
+		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+
 	return ret;
 }
 
-- 
2.48.1


