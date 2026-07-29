Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B72C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF1F6B0088; Wed, 29 Jul 2026 09:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80636B008A; Wed, 29 Jul 2026 09:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B472D6B008C; Wed, 29 Jul 2026 09:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5336B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:52:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 203701C0F59
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:13:58 +0000 (UTC)
X-FDA: 85041403356.01.9A7B6C3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id B88F81C0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:13:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FE0GRe0O;
	spf=pass (imf18.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785320035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20PLe0W5WCIDnL84N1zaO+HLc/2Flui3NV1Ycbs9FQE=;
	b=2a5UzcA/YTXs5Epy6W6WFZ2XzMvlj+h3XenIA3IUsTQRg8ehMyBnIwcO7WyjAYCRAf+2x6
	9vcxG2JfqusNrMFk+XKltZUddLv9LqrpD9y+pMxrfoG5dwrMpGxcGarnm18jQbx1eqVOQi
	govSrinSfAdqA0njlCVPs6ujoD1IQvo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785320035;
	b=ZT0zuDHi0G3ZdhEBRUY3jXm4tk7CxVq4oHW23Z0Umc2FjjPw50wreR6Jwp4v4v1QinoBiO
	vmzgW9F1hc/t0weEtxzPw9xBa3J1LsR5w3wdCoS4d4JZbHRcPHW5vXnQxOQ0GpJQ+ayWbf
	/trIozBGH9dbVB9tIhUj2H4oI6dklC8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FE0GRe0O;
	spf=pass (imf18.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7mVIS3510234;
	Wed, 29 Jul 2026 10:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=20PLe0W5WCIDnL84N1zaO+HLc/2Flu
	i3NV1Ycbs9FQE=; b=FE0GRe0Ogg0GxdOaqXto7RlECSlIgi6U4FPECF0W06Wbwd
	M7AONk2CWa7g6JpJI2ObBumRdUA1swYmrWpTmd7Yhg8jwPbDZPgtdHdki7lJdXyx
	a5ku0VmqhUWIT7fE2R31EKwMjGZ2WPjK8OmL/dgfnk9UoMkRCYyUVAcgLhPRPvN0
	kLIPDOKCSIvgAGARWTb1EH2yPFCJ8AUOWyTqPNEJnE/lDGlRVk3V4VuWQqKVkVwv
	H1IG3I44nBqMpAKFAi/QqfRPlQYTmOhtD2sUL446yWQE95juDDEVE2tYcHYUFzYi
	2UV21GPh0m5G/vyMvB1cyXeyKTzcyGbuTrgbPIEQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0ns9wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 10:13:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66T9uISf001554;
	Wed, 29 Jul 2026 10:13:23 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn9pge0sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 10:13:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66TADL8529688252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:13:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E576B20063;
	Wed, 29 Jul 2026 10:13:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75E452005A;
	Wed, 29 Jul 2026 10:13:19 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Jul 2026 10:13:19 +0000 (GMT)
Date: Wed, 29 Jul 2026 12:13:18 +0200
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
Subject: Re: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE
 values
Message-ID: <7813b5fe-e767-442c-a356-afc1a5c567ad-agordeev@linux.ibm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4MCBTYWx0ZWRfX5gvztvTGa1TS
 cVvs9sLHjmDvl0pv/qnDx3AnLV3WD1PhcS6rWZcrYanN4eoy1jfYhO0/byBUN7m85v7yOdOHFEd
 jkwp4KNx5XSDCb91frhZzFZIHZypXvU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4MCBTYWx0ZWRfX1UTcCITLhsoM
 WVmB1D9GH0QMtrIKGHgL7p0GW+jxunYYOgpbX+DXyGN5j53LZmEz/XAfzXnJVoe6iYvkeEMQ0zl
 U72YvirOw6n7XecUaLxufeDZ3k7zUoWhwsOzzDr2PnO5B+rHRlQanyNs10kmLyGk0SbO5yjhmsl
 X/wsvmN7W20tzA/W6s+/Go/LRPoLITRcA0wiEE2RX3SL5wjJQy6dbIfOKXB23C7J+7CUDxsv1hH
 2UL0d8RcWDG1m2MOfvzdP1DDLgoJ5qa4fNMDY3Dujfh/q4BEQ3LxkwjYYEZLquYPNzSt8jlE0CR
 W0NplSr/y92efigHBaNWZE689G10/Vfvu4jsCRV1WwdOJDDLrJCdFPCcT3EXgYundIBLpChodfB
 V3DgSeKuQKYmWhytTg7Qp/bafc3JxPNb2dXgROBBI3XlcwL1Fe7vq5FAcDbVZ+iHosYceQA6qsM
 opbeSLXsz6GP+frEBNA==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a69d244 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=17MMwBHFoGJDYN7e9MwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 83X-ft2oRkMXo03OQPgEqsBuw75g_R7Y
X-Proofpoint-ORIG-GUID: 83X-ft2oRkMXo03OQPgEqsBuw75g_R7Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290080
X-Stat-Signature: c6ia9ujhn39e9o9swagfypuhp4yfyc1e
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B88F81C0006
X-HE-Tag: 1785320035-767172
X-HE-Meta: U2FsdGVkX1/OXD8MNrT5hG3Ffn/j+UzvUpQUfFqKewI0wnDhSVsZULSDFx1v5xGs38e7GXlo4f9ivzxNr5gjWVUNCd4OBMKJPqUY3BqOCZ/0ufDAjgZjFP0JA8Wwdg+MrhGH38GZjklNUJV2UlY9jjwwqreOE02jKLmBZit1T9HONM5r424QpgefiNyJEvIoLBeXj9P1t5li+WqkmkLVN3S9OxSyTASj8b7E3lEcWmbD1x+wcrW9Li17bKrz7XSw8wjPflaKyV16m5PWHTlqtG9gSaKVw8deVtg4ZTWuN69eeirE6XjWb/wKXZr9OqSAkNEBzCo1WUq+Sq5XG4HMVX+h2oZv0SVwNi6lLDQWHrhlG99o3sWD6yoNbuRmfmAeZNTnVxHlWL6/bk1u1xKTVHfZya/ITamCJJitSOGhSV3nbbzEhpGeEtUg3LQlVV7gh7ikrI0RcReNMqLRpSEa1k35MpXOrXyXEuCroTBgFQEEf8y0L5OxoCDhOpedlyFp3hPJ/odjWfkwHjs26d5UNRZLeduznG4ivruoYVkhwZYflzNp9+3Jcs8O9ZWdPqExoEom8AKZY2kOorfg1YOntBfhI0jg6/4WTLorZLwwfYOZVSVEJplwhwRFi/tjthWZaAJ47T9WGtwBplLJknI1PaXk23hgTMZHADadtFRgBMd54SrHSMK13gAVN6AglXn+SY1/nFrPZk7n0XQT+ZvX1nmnNKB4K5F9YCx4STSp9oZumNXuWENCsm3KXgVSlb4VIGM/18J427vJp8gzNgfTCRi4wbVAhamVhRqMiZaK8Qckfbmvez94El2TJ0wWBcK/6E/Yph4HtkF5gFpK3ZDC0VYFSUelh5fzVWwb2N/Usw1hNlFyxXEAcl5jbyUEP5WBkFb9dV27acsgFMB0pMOn8QRCGCvi3Lbv9LHvLrim5JvsL8RAOo6qXumyuDHIHMVjpYbLJe6Be3DLSmAngNr
 GOkry3OH
 WN+vnweXfDAYfS9mVzfqjg+MnBBTMY0LPUjiZABDx9bRiRgiH7U0aq/Z8oplwy74bvHH7cWP8e7FIyU9WirHd0XzAAZI39flEm4BSA+VESoAAuMaYMErIQinUE2kT5popiz+nGFY0AD2DVf9Gb2Izb6tlpr1yNadVheI9PWzz2k3StH6xTGTpAwWU7dDJi7pPpcBY7RK64dFEnH/wNw1LqCvPWITpDjlER43s7lfSqZH0O+ypeIaCrgm44sSsJaMzLJIm8iotbjgJERbCru0RVLTPMnkRTDLmKAxW0jQQpRYYWkkvEFxOEtRg5U5nzCkgGWe2c1WOoQENWzItuvDunsgF1KBDGZHrCGFcQIJocMa6Hz6NWxSvOwJp0b8cmAJzkno5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:26:06PM +0200, David Hildenbrand (Arm) wrote:
> > The generic definition aliases hw_pte_t to pte_t, so this series preserves
> > the representation and behaviour of every architecture. ptep_get() keeps
> > its existing READ_ONCE() semantics and converts the stored element through
> > __pte_from_hw(). An architecture can later define a distinct hw_pte_t and
> > convert its PTE interfaces to make the distinction compiler-enforced.
> > Architecture PTE implementations and most architecture code are
> > deliberately left for those later opt-in conversions.
...
> Do you have a pointer at the arm64 part, so people can get a feeling for how an
> actual hw_pte_t implementation can look like.

May be we need the generic hw_pte_t implementation as { pte_t pte; }
right away?

Also, can you envision a case when sizeof(pte_t) != sizeof(hw_pte_t)?
If not, the compile-time check is worth adding.

> -- 
> Cheers,
> 
> David

Thanks!

