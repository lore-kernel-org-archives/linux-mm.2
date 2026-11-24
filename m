Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B016C606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=HfV3u0oY
Received: by kanga.kvack.org (Postfix)
	id AF16F6B0845; Tue, 24 Nov 2026 13:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8866B0847; Tue, 24 Nov 2026 13:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B79D6B0848; Tue, 24 Nov 2026 13:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73B616B0845
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:58:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED9A5160C1E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:58:03 +0000 (UTC)
X-FDA: 85470922446.17.F1FAFB9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9ABF740014
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:58:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HfV3u0oY;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of zohar@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=zohar@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546681;
	b=483JXBxgSMCK5X8oBg6nzHE78PnDNvFWUy0X9OnzyZL2MaV9lMoAkLGZe2K5vz2n9EsDIL
	9Zcdyfpaq6aht195xoEpfZWzuxiPEvq5HRHLoikyK0rGNoKO5UjVXd5Xrc74aUmqcqX/U0
	Faww+DBWGJ8r3hgDQuPaBzUlqyC9esY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqq04Dy6isK/nibhKSp5arYzUNNXHVOftTNvu6kl/OA=;
	b=3wTkfzO8vvIHR9sdrRkuFsJ1HtpL6yQ3jsWEzgkJelEZreBZ5/yxGVvyqFXxHKav9e4EzQ
	f5+2CjTr6cO6eYexrFiiyt1yXd8+aw7yebkrrIUP3Ybl0U/PY1iXBv9WuV9fF2sQcM6NHf
	G890MjKl/PbOYUIYWrPA6PorGQgwaNQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HfV3u0oY;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of zohar@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=zohar@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOIYld43227618;
	Tue, 24 Nov 2026 18:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=uqq04D
	y6isK/nibhKSp5arYzUNNXHVOftTNvu6kl/OA=; b=HfV3u0oYsHK/2oysOj7z7w
	d/1edf/+i3BrSGx8kohgNwUJx3hS97CxKYZaqldB7DXk17NXBgKCtupb6asdpLnN
	W0BsbYY11JMsYv652cyBGcYMiF7aEsPYRQD+d82CbP1F3A/0FXkKSF0ri1aagOnA
	A6xBx9jHsZ3K2XH6prPoF/46EGIXu2JrhJd0iOVHc+tYh9HstEQDMfgFch0P+de4
	wGHTEcPdW4l5t4OhWn8iHXkIK9K19nBzIK/tM1vzVKhPXL/ISXCDSXRrFwJ1WNu9
	dLATIKrkr8gfkFcFePD/gsW/08nd+XuGFGz+kN2589qmZgiREA/zZdXYKd2ojFtw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g18taa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:57:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOIZW7J3101401;
	Tue, 24 Nov 2026 18:57:45 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3p0vkvhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:57:45 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AOIurgx31195846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 18:56:54 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA14D58056;
	Tue, 24 Nov 2026 18:57:44 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C1A558052;
	Tue, 24 Nov 2026 18:57:44 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.4.47])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Nov 2026 18:57:44 +0000 (GMT)
Message-ID: <d22a4eafc73dcb6d2c80862f422fe69d54e79f4b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 06/13] ima: handle errors from resolving the real
 inode
From: Mimi Zohar <zohar@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>,
        Amir Goldstein
 <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi
 <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20261116-work-ovl-d_real-v2-6-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-6-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:57:43 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: yZjGn-DEeq1kE4tVMh88FNtfLffg03sv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA3MyBTYWx0ZWRfX61M3IaFKEsaH
 7mS6MNfRj/IINRdNIeW6tGSQh3Ue5NbtgMDCNRXnLJ5OBU41aPp0+wD1i+vutgxz/3h/j9mJs5G
 Kea5URj1fxQhihtFOZid/BAAI03/vXQ=
X-Proofpoint-GUID: NedgcETWwMWTjELFHod-RGSG4ukHSub7
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b05de2a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=lMkFumaAjUwUa6GXabIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA3MyBTYWx0ZWRfXyr1nQkXtkjai
 DyvG50RFNvMZx7HXm6G4R2VhVPWuhpDl0ODZObKFI/5i9UjVKCRWDNEtYSBwO5tR18KcDHXxbjS
 WeC8RQlng8HO9axVheyKPB/GnxVt127Z7IbLPYelZK9I9G09/Q+VnYJPoDLQyl80iQTsQJHRbGF
 JYrcAG4FYcRLeWBrTy81y2EXqZ+jT9zu5ZQoHnG7iLDSE9L980eeEWLawlLzTDPqHXA1Mhbw1Qm
 1QQqDxnUDyJNXMssDkwH/MD6ocinO5NE4vU258iOrRj0CCJnu4XKi8oB0UnO5s/y7Q3J9o5+N/e
 nE/aH7AaB4PGybrLyST/CIMwLQaOOiFWe9FGTSvm/Mt4NRQNNfD+pATTeprrWDUCjG4UPWnCTov
 sSb3/51afK0h8df7UmmItmgeHTWtIxX4F9NjEBaq9M0GN6z8AU0TqTfCCEdB1UFWgkp2t+BOj0Q
 oCK32Ok7gkRButWmKQw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_05,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240073
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: uf71yq7qfcga1kq1cxfk83zepijij69r
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9ABF740014
X-Rspam-User:
X-HE-Tag: 1795546681-740024
X-HE-Meta: U2FsdGVkX18SXp2m1BVmVI3GoNRwrJmQRRsvHVdKJSWkUL//qCgsEINWiTCN+gVpiQLvrMf8KkhP7ZoKFHpeUV4Cb5cWAIEr+iou6ZDHo2TxF7IQyTv93R0sRv5lk3dGKdgjnyL7tS3sIP8KwnyRi48xK2GSH47Pv6vB+ABQ/srXlHm+vwgpfWhhRAltE23WfWn/S2Dx8soyT88joCnDneZ+dD8VEnJb4aa8iU0yUAJppINMnTNg5rne856Sr7FUKah27BGa5pSPXMOuA0BBqaZysqJN5mKu+y9pi2lycZK9ARr/8zuE4/QU4ztlXL2lp0kSspwCktkUZ0J9tl+FgJUElpGuPxfg3Ic53DPhN1xUHwpd0z55tXAOR151e6zRPbhRA3okswDMnkIi0GlCLFTad0RiFihqgOk6pMJBYP+cY2xNLuU9ATu7f2p26/VqSVB2CFLACuSF+bwH3Jy/ZBAweEdzTCEhP5uV2s9dYxo3v/HIRTCKVNKTXHA938ekdAy2Ts/BFdyYME6xWcDKVHB9UcC7WGmS11QC8zyqzJv8FoMMCcSI90ARgHeMO2s0yZiy9VdPDsZqRMXOwrd0ziDGPvYRcxbBXjYLQyuAdT4xEfDOXDt3FL6oF/7519gQHYNGTzNiFforVet3+niwzM/tDBYbszQPzSIxbr/zVHGtqCLLLg4ghtkGT8rIQpQJBU0n8JmTZP4IRMJ1RFAwl2fsDZjvVoe3OfjQ31f44Pl7iWncQTO+L/FzSohNE/PUzNfT+mSrxj8NrDHFHU2rzs8OUxdBMWkMLk/qjwkmbQzOjAcyweby1QGd0CfGeY4cXySyJi+rYWbDEypfJS+Wm5uQAUoLM9zQ+1PPqjY726tCtPQ8Hluj1tBeIX1cFfZQzmnnMRZlWur0na1f5vF3Ezax7U+P+2brJdYT0D8G6OktCPW+K8S5GstLrM2ENsiDcH2CcKUC9B/a2sM7tC6
 Cisv5OfB
 SXLyVLbOnse4BPcQZJOPP0ldIMzio2wDvIJKh6f5g77iiyzPCSdSygVhP5XKsdM7bEd5RZ8Ifp34Pm2Zzzj0S4Chlev05zXvm0OyIQ0JVzL6EBkLsQL/jf8ybPDJd6jq8PdeNfb/CipcU0o6JW+w8L9FGlBVMZWCHzs1tFIIj71MYi4lI5d8UDejJddm2VcP3MUz3uQBwWZ1yjtEIM2I0jYZnd5F3KsVAMy/TVihWbYTd4YZvdIxNDB6zbuOidcBWWTjKKfVlRUB/TZB+H7ReByH4XEBf1Qh4ZR56ZFmWw+bOspFfXxqdtzdvCFJZwfXIYZoD58QeQhwMh69YEHfFkCe1EXUb2MiOiE5Jzb53AklQ4x9ZI3hno9nk807IDLSUdV4NCXb99v8WPBqIu4sQKkTG+1n3RkD2IA/RKHHszBxRhbijgLbZZQcopEd4ndzJLLdHLR2uh4ZEMuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 10:44 +0100, Christian Brauner wrote:
> d_real() is about to be able to fail for D_REAL_DATA. So switch IMA
> from d_real_inode() to d_real_data_inode() and deal with the error.
>=20
> Currently, if overlayfs fails to resolve the data of a file it hands
> back the overlayfs inode. process_measurement() then sees
> real_inode =3D=3D inode, skips the detection of changes in the backing fi=
le
> and returns the cached verdict. That's the wrong default. With
> metacopy and verity this isn't limited to files nobody opened yet
> either. A metadata-only copy-up of an open file makes overlayfs validate
> the verity digest of the data again on the next D_REAL_DATA lookup and
> that can fail.
>=20
> So if the inode hosting the data can't be resolved in
> process_measurement() we can't tell whether the data changed. Treat it
> like a change and clear IMA_DONE_MASK and measured_pcrs so the file is
> evaluated again. The metadata check for EVM stays independent of that.
>=20
> This is a no-op until d_real() can actually fail.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

The patch, itself, looks fine, but I'm not able to reproduce the error.

The existing IMA overlay tests are working with and without this patch set.=
  The
tests check:
* test 1: checks file signature is copied
* test 2: checks backing file signature is copied up to overlay
* test 3: detects modified backing file

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

Mimi

