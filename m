Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E5C3C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 15:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C9F6B009D; Fri, 17 Jul 2026 11:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5569C6B00A0; Fri, 17 Jul 2026 11:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E5D6B00A1; Fri, 17 Jul 2026 11:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C93316B009D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 11:57:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E564012012C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:34 +0000 (UTC)
X-FDA: 84998358228.03.EAB4CD0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8ADFF180002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aRvzRszi;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784295152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AjgO036NSYRFdc9GSF3w6G/zIrXi9byrH2w6e5EiGiQ=;
	b=MyzG2H5h1W7Opyp+OwDwwhKQpIaaWmws9ZIbUh6rRNYcnWi8hohVtVS/ZfS1ypXza0caHX
	HbDADjpCUtqw7RnNkXKGZ9I2iZOYS5U39Co+7HuYMURSvzMFczXkEhZJyz6SfTaI37q7wI
	naUCOxnazOagIplM/1Z4AGlSMmB+J78=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aRvzRszi;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784295152;
	b=Tpqnxg7honK7+22zhA79j09mGJT/k+xP7NmfvLMAVKR9j6f2Do/jnyx7xbO3PF7RwtYyR1
	uSowd07o2eEOA2ZNJ0pC9Ha7VWxioLghyziMApj/Ek1O3SW1xcEWO4VWa2yCesWbhsypyZ
	lOenPoAy6dIcUYz9Vx5zAajt+fm04oM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HCftFD2056700;
	Fri, 17 Jul 2026 13:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=AjgO036NSYRFdc9GSF3w6G/zIrXi9byrH2w6e5EiG
	iQ=; b=aRvzRsziP2pHcxRIwqiaZPO15tLOIO5cE8Nv/1mSnWWs2BMP6VT2c/vgw
	ZMkKtgvOl2J8aNYT3Im5einsZ0k4MjeJuDtVDbxYTyVwqTEqELpdYROjWXEIKVDM
	LKdP6XPioVVbcfiTXizN8tCegx+8foMbUMxuhgxxFxJ2LUfyezrXSaMiwKx5vWDv
	O3N/z2HIrpuxtPWx+Oz55A1jM+1RICALxTPA1CFMDoo2QqCmVV48x3/r0pIeVCiV
	gBxIm4mZBexLvpzFs0zp6lGLhNfTPY63+Qn4KRn/p4yR0Pr9KK4ugWNfq20t05q6
	wJI1Di5hcr0RzecHkepT+WAHbmBtA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegtpqkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66HDJaHE016652;
	Fri, 17 Jul 2026 13:32:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc05qj21c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66HDWMpo61014368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 13:32:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF9C02004E;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC8252004D;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 96F1D16270C; Fri, 17 Jul 2026 15:32:22 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>, Chris Li <sparse@chrisli.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC PATCH 0/4] mm: introduce __ptent sparse attribute
Date: Fri, 17 Jul 2026 15:32:18 +0200
Message-ID: <cover.1784292223.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xQxrc2ng7MDvMCEn5CCIWnrTg92w4CSB
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfX/wq01HfBJuGU
 fGvF46ooGP/35DjPrvdUO0DpXDTNkDCKrivz+zqCdrbbMQvHKrWBtwb2KyFhoQ8Y4qfnEDBaoWv
 LlR+9PFRfLkiR0/JO71/TrsPRh48wzI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfX4FB1V68v/3Fe
 UOvvIV0EQ0aBnYpPsEO7uCeQ+jTgEWiB+zXiiE06expGJYsh8c6z+9IptXHh6EEJWxlABuE5Hr2
 sdehvoe5hg2LHcaujGiUbi8hiYjUBSAvZgqPd4EQvQnh8IbVmni35GRa7LNrtDb6fY//E26A6tf
 eEuHMCQIQlZIVWbS2exVU1ArOweMGP8Vv6g5lXx3dVhXJUNlNHOd8YUW/k9TsoBQHgwzcTYvPLu
 bODa1nefvNLcZNrIOQKGqMsick3Fl6CFRBt433fEB/0erYgWHjuxpThoTYHtecnUYYbBfU2smM+
 ThDVbuT9S6vSxABlCRHDnah4HV02P104zdkGljjwNIw5eTAa5RKM49qPEyPnzSxywpiobpZWamR
 k3j39k6khoLMuqbd3ulWUJIJ6/h17rmYKJdoP9JVkjzY/aTdyYWTuq1rKW1qJyeaGGlHqvz6vgE
 AvYfUbnCPh/6/80h5zw==
X-Authority-Analysis: v=2.4 cv=IqMutr/g c=1 sm=1 tr=0 ts=6a5a2eeb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=GqpsjJ4LBzbGpllbTOcA:9
X-Proofpoint-GUID: xQxrc2ng7MDvMCEn5CCIWnrTg92w4CSB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170134
X-Rspamd-Queue-Id: 8ADFF180002
X-Stat-Signature: 53j3zp1sr4hchpt5og6n51kcoygiwpia
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784295152-176707
X-HE-Meta: U2FsdGVkX1/Yv0+uZFsiCfqbH7i5jjrACMW8Zw3wG3MKuSsO55+VDk9Yp6qs20Za4Bq9UoOFSCawKkhmS/sLrb/X4alnzYiSskN4FJ2t+ZtqHZ3Ter3qJfyymot38TtKAS3iG4HzwdfEnKj/wW4U/K37AOqYECiMIjHH+TVJVaynw7sqM0SsAsjYVX5KmtZU/vSEmBpiwaXX3QPsKawA7n0Ch/iiL2Qj0C7HWcOPYx0CNhxINdm2wWD+RDfNtCh5nVaYQZSyK7uAtqOI71i49lBmCXPzwTlSawh1ii5GZF+aNjmOIOKQ0x7PJPCxKfPBtNDUInXb0wEJ8RJeZ1ft6pCDJBWc0im6aaPuHMqBaTbkzjpmcISXuN0fwXPdrpRI0iGMvj+CYsbwfdeJqHIHrjYwtX10QgLohQltfDXJdLCJfvV1n2PugZRa7gJWfsaENw0KiY/CSYh/FPtz5sg2Skt7RAGfiuJoBluSamqKIGvmrfSpFpxDnd91VeZPW0lewM2CIIspf9pHiEcI6s372G2CjaGVuRRYwnp45FUNZGCW41VQcR+v/2+0fRzhDsWEs6jdp0c4eE6LCjX4pcAuNHq41eImukK6RIjw8RzANXgawMUb+cmr5vVpthMMUIe9aCjkFdnlzf6GuXmCq98Fy6zDT3GTMzqL29pZfO3HXr5jNLGD8GtcTOPqjw2RMUkYMEYzbHZewI3zL+Gno/BQgK2U/v+uU46W4Sz7zTSxXFxFm1rHsbjLD9QWC5fv/Y1i4ReZociRouhvclemsG4md4wnoEFI10Xlp8xoN9r/RvWsSamnwdeQjKrMONX8dbPaLtcllcOEnih9TgLrCYlxa8IvGLZHonega1KghP7QmG29v6uAc8qhePo238KMEWSvWpqEBfCA08nB7WF2VKjIVVWKfceoQ9hyWcmOKxtnbu5gRMHqwwjpkU3zmMTsARH/bIpk85CUnIUvlDplo29
 lQdn8sK6
 YhkJ0JhySez7PqyzsuVRjcKVS7EXyIbZGM5Mp0KcC45G0C0VtiHhDbC8BE9oFf78PCOaeHoIFKeju2Q4tZCf7MLhTP/+fRuNKfRB1mmRbYq5IOXqxoKxznd3zi7KaLQ/lAyAM7AOkIOwctr5visgeLDMsMa6ttLwJQscYKatnB0AvaCrvJe4A44J+t6O0sYdPV/0723Erh/CpXtJeVJZfeR+/I4g2hhY9PJESilkvlhUl9STD2ewHK7ZLViU99/TVEjl+CHNNgVBA7QFwMW7CQs8oa5ZbYNl44DjIIS3WxIzV9jBM7AdJc6FIeti+RIyOeUE5yxAEwLAILgmYghKZMsLqHRxLTAv8AYvD9pZeb67OGzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All!

This RFC is a result the implementation of lazy MMU mode on s390 [1].

Heiko Carstens requested some mechanism that would rule out direct
dereferencing of PTE pointers, which otherwise would bypass the per-
cpu cache on s390 and lead to catastrophic results.

This is an attempt to introduce __ptent sparse attribute similar to
__private, but to be applied only to pte_t type by architectures.
When used with C=3D1 the modified sparse "dereference of PTE pointer"
warning is emitted.

With using that new mechanism I was able to identify direct PTE
pointer dereferences, which should not have existed after commit
c33c794828f2 ("mm: ptep_get() conversion") (and its follow-ups).

In addition to ptep_get() and set_pte() accessors I suggest to
introduce ptep_get_nopgtable() and set_pte_nopgtable() variants
to use when a PTE pointer does not point to the page table, but
rather to a copy of the PTE. These would allow dropping unnecessary
checks on s390, but is already the case for folio_pte_batch_flags().

Patches 1,2 are independent from the sparse rework and are good to go AFA=
ICT.
Patch 3 is the required change to be coupled with the sparse rework below=
.
Patch 4 is an example of how __ptent was implemented on s390.

I hesitate to post the sparse patch itself before the rework is is agreed=
,
but I am CC-ing the sparse mailing list.

1. https://lore.kernel.org/linux-s390/cover.1784121418.git.agordeev@linux=
.ibm.com/
2. https://lore.kernel.org/linux-s390/20260423122824.10371E07-hca@linux.i=
bm.com/

Thanks!

diff --git a/expand.c b/expand.c
index f14e7181..a06b005c 100644
--- a/expand.c
+++ b/expand.c
@@ -718,6 +718,8 @@ static int expand_dereference(struct expression *expr=
)
 	 */
 	if (expr->ctype->ctype.modifiers & MOD_NODEREF)
 		warning(unop->pos, "dereference of noderef expression");
+	if ((expr->ctype->ctype.modifiers & MOD_PTENT) && unop->ctype !=3D &laz=
y_ptr_ctype)
+		warning(unop->pos, "dereference of PTE pointer");
=20
 	/*
 	 * Is it "symbol" or "symbol + offset"?
diff --git a/parse.c b/parse.c
index 9389079e..213faeaf 100644
--- a/parse.c
+++ b/parse.c
@@ -553,6 +553,7 @@ static struct init_keyword {
 	D("cleanup",		&cleanup_op),
 	D("nocast",		&attr_mod_op,		.mods =3D MOD_NOCAST),
 	D("noderef",		&attr_mod_op,		.mods =3D MOD_NODEREF),
+	D("ptent",		&attr_mod_op,		.mods =3D MOD_PTENT),
 	D("safe",		&attr_mod_op,		.mods =3D MOD_SAFE),
 	D("unused",		&attr_mod_op,		.mods =3D MOD_UNUSED),
 	D("externally_visible",	&attr_mod_op,		.mods =3D MOD_EXT_VISIBLE),
diff --git a/show-parse.c b/show-parse.c
index ceb6b3cb..0784d51d 100644
--- a/show-parse.c
+++ b/show-parse.c
@@ -135,6 +135,7 @@ static const char *show_modifiers(unsigned long mod, =
int term)
 		{MOD_GNU_INLINE,	"[gnu_inline]"},
 		{MOD_NOCAST,		"[nocast]"},
 		{MOD_NODEREF,		"[noderef]"},
+		{MOD_PTENT,		"[ptent]"},
 		{MOD_NORETURN,		"[noreturn]"},
 		{MOD_PURE,		"[pure]"},
 		{MOD_SAFE,		"[safe]"},
diff --git a/symbol.h b/symbol.h
index 3552d439..5fb1a811 100644
--- a/symbol.h
+++ b/symbol.h
@@ -247,7 +247,7 @@ struct symbol {
=20
 #define MOD_GNU_INLINE		0x00010000
 #define MOD_USERTYPE		0x00020000
-     // MOD UNUSED		0x00040000
+#define MOD_PTENT		0x00040000
      // MOD UNUSED		0x00080000
      // MOD UNUSED		0x00100000
      // MOD UNUSED		0x00200000
@@ -270,9 +270,9 @@ struct symbol {
 #define MOD_SPECIFIER	MOD_SIGNEDNESS
 #define MOD_IGNORE	(MOD_STORAGE | MOD_ACCESS | MOD_USERTYPE | MOD_EXPLIC=
ITLY_SIGNED | MOD_EXT_VISIBLE | MOD_UNUSED | MOD_GNU_INLINE)
 #define MOD_QUALIFIER	(MOD_CONST | MOD_VOLATILE | MOD_RESTRICT)
-#define MOD_PTRINHERIT	(MOD_QUALIFIER | MOD_ATOMIC | MOD_NODEREF | MOD_N=
ORETURN | MOD_NOCAST)
+#define MOD_PTRINHERIT	(MOD_QUALIFIER | MOD_ATOMIC | MOD_NODEREF | MOD_P=
TENT | MOD_NORETURN | MOD_NOCAST)
 /* modifiers preserved by typeof() operator */
-#define MOD_TYPEOF	(MOD_QUALIFIER | MOD_ATOMIC | MOD_NOCAST | MOD_SPECIF=
IER)
+#define MOD_TYPEOF	(MOD_QUALIFIER | MOD_ATOMIC | MOD_NOCAST | MOD_SPECIF=
IER | MOD_PTENT)
 /* modifiers for function attributes */
 #define MOD_FUN_ATTR	(MOD_PURE|MOD_NORETURN)
 /* like cvr-qualifiers but 'reversed' (OK: source <=3D target) */



Alexander Gordeev (4):
  mm: use proper PTE accessors in madvise() and mremap()
  mm: introduce ptep_get_nopgtable() and set_pte_nopgtable() accessors
  mm: introduce __ptent sparse attribute
  s390/mm: implement __ptent-aware pte_t type

 arch/s390/include/asm/page.h    | 16 ++++++++++--
 arch/s390/include/asm/pgtable.h | 44 +++++++++++++++++++++++++++++++++
 include/linux/compiler_types.h  |  2 ++
 include/linux/pgtable.h         | 25 +++++++++++++++++++
 mm/internal.h                   | 16 +++++-------
 mm/ksm.c                        |  2 +-
 mm/madvise.c                    |  2 +-
 mm/mremap.c                     |  2 +-
 8 files changed, 94 insertions(+), 15 deletions(-)

--=20
2.53.0


