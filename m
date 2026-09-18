Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119F1C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4696B008A; Fri, 18 Sep 2026 08:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CBB6B0092; Fri, 18 Sep 2026 08:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20936B0098; Fri, 18 Sep 2026 08:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C69CA6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:57:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 494E98067F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:57:50 +0000 (UTC)
X-FDA: 85226885100.22.0AA9814
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C02720004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:57:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=byvnC9Dg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=byvnC9Dg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789736268;
	b=VXVMS/EW3Fe1Zdaf+c3Y2Kdo1F161kSoc5V6p56SFqlb5nEXRmgnb93XpVmxcRX429Dy2J
	hQ50LlyvwUBYxCKNF7jy3wjHhRP6tDiBS638gjv/Yc8i/sq8DTkbA941MfWloxWJqL2/W4
	UhdYGeDQ2eWEZKp9vxdgI/SXGDACe54=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789736268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvXTEBXtIpBfma8CBebbY+SSqqX1QuWR6+4vIHcllvk=;
	b=exsdw7DDfltHHeEDJRrwE20ZPKLGfBe7dEKfwnZWMX21HmEKblMny16Cij6Bzo5T+thisc
	xeQeyeWm2qm67HPB/S8UQbE9zx1fEVN9Jjc11mIneE2R69KVc8Rn4lN8nF4MLmwhnU1YV6
	qsrsg1qYvTiH9gyhFlQM0R9w0izpQWc=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IA2ka3990915;
	Fri, 18 Sep 2026 12:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=vvXTEBXtIpBfma8CBebbY+SSqqX1Qu
	WR6+4vIHcllvk=; b=byvnC9DgZuLKYo4mY9QFMiFQ6Zc5eAvVokdOQ/jMnu/ROL
	Ihy697HfGNSs027KQksAAkjwX7YaRrLsOO1g/6wd0s+CHm/STBQ5bGQE02PrUNuG
	/jNGEuQyMJ0GgJpPIZLUjqfcXRUhYNBUGxSiAGrMMe/ZN3ie+9Negm0sXqB2qPGg
	G78+ulSPRFoKyeDh2Y4ugEz6Mth2PVTjmT/mNSj1OZo6IEDn3Mmfrt4AuGBiF3It
	82M05ljqdaF9c5/06LrZaWpRH1x7tFsqkPtu0asE5M/h1WbsI4/lZhbLwmk3A6qp
	RqNdQRRqouleichhat5Xw20CbOufAHP17/U7CBSg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcvfgrx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 12:57:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9oGpj507832;
	Fri, 18 Sep 2026 12:57:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gra3yxedq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 12:57:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ICvEb851904874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 12:57:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D53820043;
	Fri, 18 Sep 2026 12:57:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB2DB20040;
	Fri, 18 Sep 2026 12:57:13 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 18 Sep 2026 12:57:13 +0000 (GMT)
Date: Fri, 18 Sep 2026 14:57:12 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>, Mike Rapoport <rppt@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, pfalcato@suse.de,
        ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 0/8] mm: distinguish PTE table storage from PTE values
Message-ID: <d4080bad-1546-4a9a-9325-7ab91161a9b9-agordeev@linux.ibm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <dd6ecac2-9bd2-4184-a034-9e13afa614bb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6ecac2-9bd2-4184-a034-9e13afa614bb@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE3NyBTYWx0ZWRfX0a+YmMinfqLY
 thIpqQ3k+YsaEL1Nu5Xtb4MVEpoHSHo6PXFxsq+F/Wx3xKw0f3hhtQwBUt801YS/UAG/0atek9m
 HF3E84n9wG4sj7upDsGZ+DoHJXM8gUk=
X-Proofpoint-ORIG-GUID: m4DES1QILxZeg9-Jkqr1aSPqQzDTxZM1
X-Proofpoint-GUID: m4DES1QILxZeg9-Jkqr1aSPqQzDTxZM1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE3NyBTYWx0ZWRfX/T2l95nFB1Uq
 xYhD9MK3T3CmjxCnR5kdtXxgndhWw6MxRYXoXqGlboj2UoA37O8EdLIe4YiWjjUCSxbCjYPDLdb
 zLflGPxTioAC9+xJzOGZkBco09vb3ShkcVMCROX8/GZfFwvrgzmx7n0qXL0rX5zPKB/njtDxwgb
 gMHToemhE70TFtiB9Pj1PeVjgH1oGQscKJTsEGRxHL5kVet2L1efcSErMDeLFJpVDhkGjX606/4
 v67gUAI8g2+alWIwtI8/jPJ+6ph22PnYWj6b88V7/Iglrvc/jT0GvjzhQ6L6hTrFOvO8q+nsLfd
 IM1uuwdfshQ6+5Im7f+26qdGKHnOEavHW8zEdphBYVrG/drJ0FH1jWiiDkeaELYlUGloVtsBlh+
 7nM/BRgAPEjc6uhD2wSkdjVssp3wph+7cmdpYUKnvEQX/Ft2fdQFowSRajI1e1u1DVerG791p4M
 bjrU9H6l+Tvys0K+DAw==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aad352d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=36OLCuKFP8Pi5wnj2vYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180177
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C02720004
X-Stat-Signature: et81kddxsfktbihozeq7764nux7bg1bc
X-Rspamd-Server: rspam01
X-HE-Tag: 1789736267-178019
X-HE-Meta: U2FsdGVkX1/XqQHwsva9QCzlsvBjtJjWGYfKpo4ZXRsKzdECIXPU9XXodYuAF4IvPtskfvRhJCheDW4uIlIJ5NFa70yaTkWXJvqgZj08iLXDXmYsZBdPdWNf69C0P3KpPM/5qWlACJcd6CbUMO2yt6ZSagTQ+egjuJVzR/qySydnSB2IEW/lsNQNlwVDDcEvzKrAm8sY3qfZ2QZYZUmj4AIROXe4EfO37HkGZiW41uV4RGmJ1ZVyOBglgJ8WKW++CqldyWCHXXMg8I2QVjvsvxMivPuQP0V/Dff34xpQmWLVAUpvZRVX4/7v/sxPRdiIDQ5m8vc1+7ou3Txv9hnuNRhQLfJiCFsI0GzSS7pB+eTbuOgZdH9qQhRv6QvaCl9JV+DIPGH5zvCtdFtUrauVm96I/TdTvdHfj+fi+dCRSfpx4jF2OXZMF+T4sTybGcNpdDnEiJEfFCAxGRzA0fkvr2nesMDO2oLfIhoLjgQUmi1GaRfKD+VM3TRT4n1E0weq/TlHswJiyCTnL6cUnuuZgyDBZaqPPl60DsaxTcAAFguPdB04kiEA6tNNzGeuMP5t1ZwWCn65CXv0MBDVZve5OwCxBj69FkWW2nUKL3lQhp+8kpgSiRjTVFO8kG8cPm+ETwpHlo5va21Hz78foHcLvitqni61ItPtXix8ekr1bBOLEdhOW8q81vUCKjQg14aIhi6ONNPxqrMJtKUHXkM6VSV+bMpZ95xXE0mrA2/5gGuzP7nbm5JwfykSzATmvjaJPIZn7JCc3yrR4pjEDVtW6C70yU2pg8487z2XgldTGHDSBMfKxCsty2DWOf+UNTuMZ8LAIvH4Y1Z2ZSbueeb2e1juw8KLQbLRWhiabxyi4OkcX63IIHaFDqr5sKztaBKH+sE3eCTuLG0ELN8cwIbEhCusPWOf3cB1lgx9Nr2cyYWiECFuJO9vePwT1wm9DzL54cqF48GATyRILBJ9+yw
 ZT6w3/D1
 ISYZ9fJiWOUKsFqJigdx3iIKni6RTDwLuhdgMo5MnUdnZQ+pONVUaNCHBRkFxm4peZUix59NlD9+6493Z+eXYwNFTDTtCEn5+MzHych39FkgmMz6Gr7fh8gwuC5ZAh43U0OiH1B9XH8Ul8oZRVuIY2cEKVBYj7hJLDzhGvXbB2B2X5xhRs9Fmyn2t7ZhIXzbs2Tm5DPA9LteYi6CfoHbNAw/yuWFaqwQNAnegqNNo8ODHS7Cor6goh4h26iD50gG97MfZbrYVpMdmHeBQQzs4oIrX+Yp80Pu96ohErsT1zZNCjojmTfmkVoJ++rOfTY2is6jRC6FIYPN8Rv6xXIluiKCgK8dMMvPxjTuksqyeolfKjv3JyZP2spaTaXj772AOjdob
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 06:55:18PM +0200, David Hildenbrand (Arm) wrote:

Hi David, Muhammad,

Sorry for the long delay.

> Unless there is more feedback on the overall approach, the next step for this is
> to have at least one architecture support posted.
> 
> We should only merge this if at least one architecture (better two? :) arm64 and
> s390x? ) would merge the architecture bits.

I am going to give it a try, hopefully next week.

> That is, we should get an ACK from the arch maintainer son the common code bits
> and the arch bits.
> 
> -- 
> Cheers,

Thanks!

> David

