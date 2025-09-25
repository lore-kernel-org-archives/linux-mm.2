Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4E9CAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 22:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7018E0007; Thu, 25 Sep 2025 18:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE778E0001; Thu, 25 Sep 2025 18:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4928E0007; Thu, 25 Sep 2025 18:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 991B98E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:42:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23AF41604E0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:42:53 +0000 (UTC)
X-FDA: 83929249026.08.3C86BBB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CFEE1A0007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:42:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ObUaTjnV;
	spf=pass (imf19.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758840170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nitDcQyKm4NkSdrvGfnoFJK+u+59qy52l/in9/PENFA=;
	b=VGgnJBDgbf2A1rimcZIFfjUGZYu6iyNCzEKOOaSPWDDtGYTIaQhexxakvuf1yxY3QkWPKa
	JXyTRw/uKA7Q0FiJjYXe6cPvX6oEzlERL/UJ5AqY7xaHh5WpDu2nuC8whXy4/DXX22O+0W
	9WtP63iTElIcr2DRpvq7khfuwkQ+UiE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ObUaTjnV;
	spf=pass (imf19.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758840170; a=rsa-sha256;
	cv=none;
	b=MXeuKROcRg9B21v5UcthR0mwNSkrFWpsSNgCJ0USc7WhTTxS7suak61ersF1UNX3Lbcg1+
	NkVkSRkAnVFaXrmxNeIkuHwgMdqq2gzD3gkTBWHxvCgy7cgtqkPfRjesV2vl5Wi7gTmTmi
	Socd8ze4fcgoeQKy7TIAhzS5Jt7A2HY=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PIlku0029476;
	Thu, 25 Sep 2025 22:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nitDcQ
	yKm4NkSdrvGfnoFJK+u+59qy52l/in9/PENFA=; b=ObUaTjnVdITMiJdUsAaBva
	XLZ1KtMdmBp5Zgj5HF5l736Dw8UHyUhD3TisJilpRw75rsai+utMNLZI/A40Gk0J
	AIsS/G7spYLQbIO0kZU4MaW2iV/aPWyZoCKgkQVlo8X5W+I2HjCSV311JDj74M+7
	AE+XvFGRJ786VL4MUt+qd0wuYjp+Dm18KSH3XLhU+kGNoHZtITJdR1Vb2tgbx8f/
	XDfyMpdu8TFYY/5/2k68gzz9upb0rFrkfJbB08Avlo1kuaLpzUrF3wP4zuZtecc7
	wmN72T9Dnd4s9T4WOJSMaXD6jTl/524rYuOHseRoTIls1+pmarwlMs/vXc4BxfzA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb3s2av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 22:42:44 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58PLea2s006442;
	Thu, 25 Sep 2025 22:42:43 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49dawph4a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 22:42:43 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58PMggep33227348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 22:42:42 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB06958059;
	Thu, 25 Sep 2025 22:42:42 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5E7158043;
	Thu, 25 Sep 2025 22:42:37 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.14.161])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Sep 2025 22:42:37 +0000 (GMT)
Message-ID: <336c0402c59363956d0c4eefc1b8a059e1fcc8e4.camel@linux.ibm.com>
Subject: Re: [PATCH v17 00/12] Support page table check on PowerPC
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com
Date: Fri, 26 Sep 2025 08:42:35 +1000
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX5ysG32sTPFXd
 uf1R0BRsI0BKicwSpsBxEsSI2a3nnZJqMzF1o90w6Fz3y2zUhPJ2779DnKRJOVaK9VhKCmsSlHP
 /2MXq9DBNTVGPSPGGD9cbqJyAOkD0q7UeemycTSAdzGpVHSooWMOLLYPjP3KyU20YaYxH+bkEin
 MGJn3OOl4+vJti0slRv6mCHzTZ0n7nQaw9gF4Vg4N0KsY1Vd6Dwr0iLkqNCzKSRcTrk+q8Dol9Q
 qU4YSwx4Ahh4WWCTr1UhV4TK9Af+6BnwFIHzvgf7l8TqmRVWGOLGhqpqa+uiQSq8ueI4HKd5JZh
 VqBopl4TR4l8azCp1YGG5ilHhX/5mUQSAG+mGp/8c7m70OyuL/TydKQdeAYOkVykSxlq+rjcDlP
 DcEqcvCGhSw8iFb5/oSEczTL3v5p3Q==
X-Proofpoint-GUID: dpRrG9bUj2ZLNf81WWW-h6dqNNtNb9Wo
X-Authority-Analysis: v=2.4 cv=T/qBjvKQ c=1 sm=1 tr=0 ts=68d5c564 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=owR7qqmZskU0YpnQVroA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: dpRrG9bUj2ZLNf81WWW-h6dqNNtNb9Wo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_02,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174
X-Stat-Signature: 77hb8qpzfyexdt575od5se467qkt1mw5
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CFEE1A0007
X-Rspamd-Server: rspam04
X-HE-Tag: 1758840170-862882
X-HE-Meta: U2FsdGVkX18TsQxxCLcMtfmQaOtrbViFKAmiP3ThSrW6tjIugVsOXtkQ+BMIDLanAiZlrpqzZU5dcmBSNlze1kPPWnP0trMlTp7A/yiPWR5DFEhwx4QeTrvTkQI5zfhfzYXJ+E4N1jZ9Q6TJRjSGejGo1W5hqfkELGu/Q7aSEKDmxSVv+RihwhSocNv92GO39BrLV5SbfewT8OA091w6si8nx5Gw+COdm9PA86UQMpYzgwgSpIi2YhGJToiHBSZzA11ADo7ncST3TALqaWki9hZcc4CwE04jKcQcg4yybK11+HzWzx405B7BbLub1NTj+k2e0bsukL8mvph4filFUqf5u4hgM+VfvxfnkXQUMB8uCej623/yrPJCVinJ2uKiACHECWBWeV0+ZUr4vONHfpd02XJe5pDMJRbSgWJD4IaQhNeZVg0s+LPXnacuUKZ99tjlrdn+myCVcPqvUhtCzBcw8IIZXi9HrT/gXdJ8uOkBHhoEPIjPhsUa09FsKMMyRQEfjUjkabrx1WobxwhRz+ZXx4U/5CsUiAtJj4WZ9y786TEkSlqZopNmMe0Vub09aWqPObJoGeTC1s+YXsgT4Nv35Oj9gujRHk5HErg1d0Z2ld5Li4uXPFzOKHfUREeRiGXR+tinvCaXKH50jZ2tMoA+Z4ud8xyVnU7zVkonHEiKbrFw7gfYt61RZAWF9WLLrg8WbRG7KK0M4j9Epk3xlL3+3lpObG8UVEEOmHUe0pKQToq07cMQ/FDUmEmiQyJfWO+gQPLv21DH5oOIaxadn8QZ8vCaR4/p0S7lAQ/0cHjSHCMXVhrdXmKOZDpDqWrEJxlaWYDp+Z9dhydlJsQNoVEgba8mld41/Z9VMnfz41axAyKYOc/3+oWMpPkqjOguBw0z5P3K0JqgaK1113Za91wvCy7QcouyCg1WLIvCFcoc/gjUtPojuYgwFREuZbdYLvjMStlMvJDhtdoNvcr
 lVqwR247
 qLR6huE16FIBNec1k7w7kBQ2FZ+PnXPw490yWGUC+sMgkT+aecbImor13ZVPA8qHJfWHHmvhQLk7BmUzZxJbfDqla1o49ruM35A9JCQxvXiE4FYC09HUUOLAz7LWmL37ZaUQHtrN371sbP3eqB0HYpkSKcLThb/e96SJd27T2AD4BfRkeydt8pSYw84GlICYsP6A0/gYbGi+6koFbbdDWzZnfHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Tue, 2025-09-09 at 19:13 +1000, Andrew Donnellan wrote:
> Support page table check on all PowerPC platforms. This works by serialis=
ing
> assignments, reassignments and clears of page table entries at each level=
 in
> order to ensure that anonymous mappings have at most one writable consume=
r,
> and likewise that file-backed mappings are not simultaneously also anonym=
ous
> mappings.
>=20
> In order to support this infrastructure, a number of helpers or stubs mus=
t be
> defined or updated for all powerpc platforms. Additionally, we separate
> set_pte_at() and set_pte_at_unchecked(), to allow for internal, uninstrum=
ented
> mappings.
>=20
> On some PowerPC platforms, implementing {pte,pmd,pud}_user_accessible_pag=
e()
> requires the address. We revert previous changes that removed the address
> parameter from various interfaces, and add it to some other interfaces,
> in order to allow this.
>=20
> Note that on 32 bit systems with CONFIG_KFENCE=3Dy, you need [0] to avoid
> possible failures in init code (this is a code patching/static keys issue=
,
> which was discovered by a user testing this series but isn't a bug in pag=
e
> table check).
>=20
> (This series was initially written by Rohan McLure, who has left IBM and
> is no longer working on powerpc.)

Is this likely to make it in in time for 6.18, or should I respin it post m=
erge
window?

Thanks,
Andrew

--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited

