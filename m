Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9CFD43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864086B0005; Thu, 11 Dec 2025 22:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B236B0006; Thu, 11 Dec 2025 22:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A5D6B0007; Thu, 11 Dec 2025 22:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD5F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:37:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00ACE13051
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:37:21 +0000 (UTC)
X-FDA: 84209408682.28.00345F6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F901180002
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:37:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jelNWPiD;
	spf=pass (imf06.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765510638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wp+vTYCjH2BpXWY0mBvRIcmV+ZSaR++Da+3qfBFMKSA=;
	b=FqY+7StYJxTX8rBz6/Z3MuiSazYXJJmu++5hVrWLOT7FWpOGlRtGQKsi8iNK/yRztzW5Qs
	hEpf581wjNP1CPjBTVhratyVUDVyD0xRGwY1Y7UXiPHr29bkqxML62Q5+hrRX0EqU/Dt3k
	NHYGqbl7vbR/UI0OPHTWq55ddbWpsP0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jelNWPiD;
	spf=pass (imf06.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765510638; a=rsa-sha256;
	cv=none;
	b=pUKoyivHhcxYmTMq8oq/z4mbiiP9QWXHLwBh3v02JmfEILHfGHQMsgZ2jd2MmvnbtE4PCX
	4Ryf93Yd/j/gv1Up6wVbiZWiJ4DzQmTGscll1+DOsnuTev7ttx2sXJJSgSEsADaZt9NQmk
	8rp5I0xYLrZ5D5hQtoIFCaM8rM46ZDk=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BC3DAlB022803;
	Fri, 12 Dec 2025 03:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wp+vTY
	CjH2BpXWY0mBvRIcmV+ZSaR++Da+3qfBFMKSA=; b=jelNWPiDEORIsc+oAdJiOb
	o9vpR6YQf8a5zsNb+S7U+1LN6TWDH/x32WyxTBNfAnl1Z9nWm5LVLQJ2+e07vvfk
	1Aud37a770LgBDde6RHtaNGFINSllzeyZD20SnqVTZhxUpVFkzLdBiTeHu/9QCmi
	FupUi/zKeEkzuukr8y5PkmHkcbfwLyNwbAiq6eIrGKhvp+kLyBBl8H+A18JI81xi
	klyHVuD692tCsTiJbORCAGQ+7Re08ju+Q2TGVS1IoCZF0ArSxq7JU32oMQXvKHD0
	w8zYC0BW7vA9d3Dae9MwsAjcAz6liBn0NTgnyZodwATXI00cBu3L/5hge4uUea5w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4avc61u8he-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Dec 2025 03:37:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BC0gIQa028126;
	Fri, 12 Dec 2025 03:37:11 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4avy6ya1bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Dec 2025 03:37:11 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BC3bA1B29295108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Dec 2025 03:37:11 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A50CD5805E;
	Fri, 12 Dec 2025 03:37:10 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D58A5805B;
	Fri, 12 Dec 2025 03:37:06 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Dec 2025 03:37:06 +0000 (GMT)
Message-ID: <13664f203137541ce8aba74cac3777099992e856.camel@linux.ibm.com>
Subject: Re: [PATCH v17 00/12] Support page table check on PowerPC
From: Andrew Donnellan <ajd@linux.ibm.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, x86@kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com
Date: Fri, 12 Dec 2025 14:37:04 +1100
In-Reply-To: <CA+CK2bDDZi0TR9fhAuKpxz+XJU6-rOS_iM-akU=oTb5wVoVxMQ@mail.gmail.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
	 <336c0402c59363956d0c4eefc1b8a059e1fcc8e4.camel@linux.ibm.com>
	 <20250925161726.2b34890070e6d8dcf8ad3ba9@linux-foundation.org>
	 <CA+CK2bDDZi0TR9fhAuKpxz+XJU6-rOS_iM-akU=oTb5wVoVxMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDAyMCBTYWx0ZWRfX+kBUVpmMzDE4
 RGj2CUtYWbrx/Of6PGswWBpTVaxGP3nwMJnxqHn9QiDDCAoiQit8W/rhik3ZjF7VM3ZQy69KSK3
 iCpfEiC49mzCq/hExQeWrtPs+FgePUlvAAkKjC9g88OB7j/3sVeUXgdsld/KQsvBbvCmyMYEn/y
 qeMU07abl6hWX4ojS+Mjks/PWvc5rqfiANkPjnyfMnd63LUykxH9T7HdI09JXvNavJML2w7/KTx
 r7m/URDYkfciRWxHUM7Ew5SBhyBEbLPpFpi81h1QgOWAtswLCHNojjMLOetW+oj+lV9FfT0+9Ro
 5eUn+Dm4AbXk57q9B6bqFXxJtBkWN7Lj/yT993PG/odDHdAchrmCWUsV0dFxiaNdJEfzoZGUaeq
 BocxCI++N4A16CPPI0nxK81kOXp51A==
X-Proofpoint-GUID: 0mx0bl7tMI0Ev7mDlA5PrAzvdwe37wsq
X-Proofpoint-ORIG-GUID: 0mx0bl7tMI0Ev7mDlA5PrAzvdwe37wsq
X-Authority-Analysis: v=2.4 cv=O/U0fR9W c=1 sm=1 tr=0 ts=693b8de8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=vpjFdhQh-OGVaG3VjK4A:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_01,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512060020
X-Stat-Signature: zw7f3ha3jpqafujoe753tqskhpbdb3qp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F901180002
X-HE-Tag: 1765510638-913036
X-HE-Meta: U2FsdGVkX192sKOBOy4rrUkGLDAVxwHXt7qLzDvcB3mPunlxESDT5J4BH+ZVmtODT1Pc53jdiAnUNtlyy+pE7SpWE3YmMHzOdcx01gc6YGEdJKEpATYU43XIv4rxxbK2HvkklMWRcyBqNREitpLs6qo2zzrXenYhAVrN6/lOiQ5ytffDZcnXD3F5WyE+oq1Kn1VmVHJPpQ8iuf6t2c0byTUyWtSTqe42yWBIXbZS3KS+qeB+e7h2NB+mzDGD/3zhkhMAxFc4MIl+u7VBdiSXHq2N9/Yt+FXF+tmtZikk5P9ZIT4ST/N1JMTowf2WoKcQ8Vs5G2rhJgNHtbIeGK3Q+LCcySyRrShq4Nn0Gww2S6NtL3dMAoaqu3B18v8gBGreNJbbeeEpYUWN8DYQR1WlODON9bMAWPw74MKQwU/BwJYRU7foiWu90Ie0s3sSPNQbosnAwvG4YBt4mI5Selx0Q4ZIV+ES2tUbfQPO++Fq97LVbWW0D64qcurkf1pS4oBU04Qnpw7Wq7K9loos0HZcXxztUa/5bqsFn42kduA5OmheVGoA3467ujaaXrR/YKq29BdXS8Bui9CusVxtcOoajxhjQHs2ZOLbqiguBMvxGrcoY6n7LGiBuYmOfKsqLvNkyMjkOzU+gAnKboX3b2juzM5ZbomNPd6jGsCK0yxuHGu3zwbpweb7zYL2sPrDacnWrFQwnNCnGzBU86pf9i8jMjlDwHY3ZxldZfZFo5/TR9s/KIBOXQly1tiJydaLWyy3Pl5X08hS/1UxeT6uTuVYht78dfJLDsim2tsQi5irK1PdaL4+G09pAWBFNAgmm/0yP++GqEizBU1fWU+YrD8VjlrAQyrmerCa2+2Dz8GT3oYZfopX6qQZq+iEqfVkl/Sc9n0HTrTZHkYiYQ9NO29vozSVmre4N6yJnZ6gpcark62OPmhtR2NFigwv5wS1FKPIHdr3Iteljj9GHo3/PNP
 3+m0Jcm1
 sQef1U2tpSAaley8MRIto+lSz3lXaL74O9lgmRS9Y7lVccboRQTo9iWO3zxCHs2zh91xiH/8Nb4Qld66l4ftduF+Tzwy8rD0DUwDXuaIBSQPi4LbGUJFVOX49Np6z0BfCXJ9JbZOkmGIyB9jSK/n+/3zngL9Qf3w4d0BvXYY2AAZfDB5BikjIoKmgt1qeRRZmC44uSYzzX8xnIMPB7mjtULBmzXMaXCBpnXfMhtHn5EeaZ5M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-12-12 at 12:35 +0900, Pasha Tatashin wrote:
>=20
> Andrew Donnelan, looks like the merge window missed again, could you
> please re-send this series so we could get it into 6.20?
>=20

Yes, sorry I have been busy and I am prepping this to send in the next few =
days.


--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited

