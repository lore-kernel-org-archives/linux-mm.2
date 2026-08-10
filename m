Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A107CC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 06:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6A86B007B; Mon, 10 Aug 2026 02:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887106B008A; Mon, 10 Aug 2026 02:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E766B008C; Mon, 10 Aug 2026 02:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 400C16B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:45:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C32BCA06BC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:45:06 +0000 (UTC)
X-FDA: 85084422612.27.1188B5B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 78634C0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:45:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cP2dX1rq;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786344304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVPGPVZ23NsreeExE7+jGCM0ud2bcAJA4ypv1DILR34=;
	b=LvzT+iqkHZqlOwmXvP7pJvQjIohTlOSappxIIZ/MObo6wOvtlrzCQEQ0g2OxzOScyATOWp
	0uM2xjzmTFFKWWrJjEWpe+CIYPNfJtB2mBppATqWAVWyhVOyB2WrgtJRlePLXza5uM2s7+
	WOvcH7IqfusPHw2vIkfXBmYsETCAYsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786344304;
	b=Xu+xQwE96skZdR6IuAVW0K39MNb4omeGNSok2PgSHGfqNh7ZpPJY1YLGzdLXiuHBKlzqkC
	ybf7o6I5uB+napKHxXmjEyupxUtm8wtWoGyWLY+u2J7g5tyFZyo+p9Le06y5vNO14zv+Ar
	hUMXZT109oCY+WuayyPJFPPaKB39wLc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cP2dX1rq;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A5VYZX3085069;
	Mon, 10 Aug 2026 06:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=vVPGPVZ23NsreeExE7+jGCM0ud2bcA
	JA4ypv1DILR34=; b=cP2dX1rqRgJGyJQPsc4KFbE1PC99K1ErC8LoPBcJX/kDVk
	D9Jo4Iz1SXdFchU8Ko5W4WB9COXrRcti5DpxhwdI5dfEePzz5UmgRzT8EYYyBi07
	KU36zRJaFsP0Akw7apyJ4SCl4IAb1VRGvP8L0mKhwBZnn0XUkDZ2PW7t9oviZUQq
	bN2tmVBhSWNgiSiSi7ymdtf6iKh4gNTCCXIweHK0Tg6HF6KYslOZj/J1AEcJVHnf
	kWNlsq5fwLgQr2DlUZF0whZYM5XqlyiEV4xJgAR6wPkWOH+OEMcVL/bVHH8IYS6D
	MxDe73qz6EXJrcPmB5P+oxGbZoA1keo68zERDcAg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvjypkqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Aug 2026 06:44:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67A6ffw0026503;
	Mon, 10 Aug 2026 06:44:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxhfxueyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Aug 2026 06:44:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67A6iYQG34930976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Aug 2026 06:44:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17B532004B;
	Mon, 10 Aug 2026 06:44:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2335D20043;
	Mon, 10 Aug 2026 06:44:31 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.135.220])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 10 Aug 2026 06:44:31 +0000 (GMT)
Date: Mon, 10 Aug 2026 08:44:29 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
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
        David Hildenbrand <david@kernel.org>,
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
Subject: Re: [PATCH 6/9] mm: convert PTE table entry to pte
Message-ID: <2599c5b3-e8ac-4865-993b-d41e6f060d52-agordeev@linux.ibm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-7-usama.anjum@arm.com>
 <fab9fc78-1e1d-4d5b-a9ca-92f3ebd04108-agordeev@linux.ibm.com>
 <5c329236-7761-4e42-a549-b822e43b4358@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c329236-7761-4e42-a549-b822e43b4358@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA1NCBTYWx0ZWRfXxI/cthX2D0Wc
 iHPLS8hc2Kj/zk+XaKiAAFgipdFaX6yt5ULiZYFw9cMykKZhsGzYdz8Ozez/WjJFTxNxMxdlY+Z
 xRKD8hb46fc3eq4T3zk/Ay2gFewaqBQyLERBaqjOrmguPqyfrY4V/sj3PMJQSwHxbC9gQ3JPdGp
 nwoFQng/LWfi/b2CNXX0ejbyTRbXCpU6ISkPy5ReFIqwletsdYxZQh3JZdOlQrUjBCsND1GblNt
 G/4DaSrhSqHIA4lB3PliH1JLOCq/gqtakESjF4VI9bapYhuQXt1SuBKOBQMvOtnuq4THGnpYdaA
 9DlU8ZKdg0fttjy6cWWMXxwJNMzsJQnfWACC9mQPG3O4x/cS3d0NgAmCjmdVYfXi8XGUV9/5PxJ
 HdlkuRfRyvN/kE+SQ4EeTy+wa+g6t6URPTCSrkC11WsiBzyO9FuJFEs1QK/7K/rvQyfHrqCYbs4
 iMEVrVdUzEx5zR0r21A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDA1NCBTYWx0ZWRfX9Ko1NY31ilHb
 y/krrlO5A2ANnAiXusNks5NMrWI4UvS7c1Y7yzgoGS6CxTGjDGRyAu8EHxJ1ITitPdxPjbMc8pe
 lyb7xPyJDB1SIBriSbnTKYVPxMcf33w=
X-Authority-Analysis: v=2.4 cv=RqD16imK c=1 sm=1 tr=0 ts=6a797355 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=VnNF1IyMAAAA:8 a=2hzp2EkNZNX3k9pX5ccA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: YbHEwP5JTLZr3QYF8zr2RkJeozrhuIz7
X-Proofpoint-ORIG-GUID: YbHEwP5JTLZr3QYF8zr2RkJeozrhuIz7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_01,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100054
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78634C0002
X-Stat-Signature: kczjm9jdpgbp8i4z6uorgxqojewk58b8
X-HE-Tag: 1786344304-461560
X-HE-Meta: U2FsdGVkX1+NmkMX/MF7Ht5ojW7/0dMUkkVfsGmrcBvKHheovySAn0b1RzzgPyqiOoqd0PMoD0h1fnNSFHqftCijsMUNZLH/8g2GwOdQz+VQMMhxQx1QGdB8Fr4uSluxPXtA8E9iralff0NA8NRGfgrNACvxEefxKwoXEQv4/auNuJEKgOejWjACv1yqhsoQ7ffw6ux5L/z6/Ym/ChPSVzpqBd5Z8UG1zEumfvCJtQ42EwRKIcL1tNuq0DJBX1YQo1Nj1+oWu0ZKJ66WSeI1PgDkY6j59Xkhg/AHBzZyyxzjfLk7AvfGx0dzVPT/kqEI/p5HNkIEi8/+F5OWI73hSCaj0ABmjQ/s53DnvwVs/X7biK9c5iP3hZFwKPkXHJQW2B6Hws5grT/pfAKPt2aQnmJ8I0vhBhoaxdTLUfWyH5/JOi4bZxpnNC8RDnvkO2m1xVdI9+f1ww4+1NIvXv6ymU7CG8rEj/E6Mc0TQASLoRuPQTo3Wpoq0EwvfOKv652qfyn1B3MNcDGlUi6DLxfoSXrm6qELbeHLDctKtd7Wtr122ME0Lp/mgCr/qs0IRpAc8K5NGJh+JxH0sP7ec3ZZlgbMSJfMwnN1kLGoOfeceQyeEEyyrIKK6AYBkPxEPL3rTapq5GnZf/vGUg8QLPtuaUBbidErTQIsJm+AJBoPWqQq6hD3JFzw3w2mVf92w26RUkRRFbpgxaPdkkjrnVJX1z/qTEuEIDJ5Nz3AWzsvorzWviiocyiA2Tt59KkKL0rBGjrvJdro+7Y4hzUffWtA4YOWyAbjoXscIKjgv+ymWZ330yJ8diwp9lR45WN4scGl87lZDCmk+qtRK4MA+/Rr5w50XF5nTGMvPk4VmjsWouHnx8a/vHeevjXIZBfwojOPo+E1hcytFbZLzUXM0wFo059pnK4JDaz1/dCgL4OL3FrkIRcgwAlvQ+t5SxfDZLG7FQDZvPQimdLULxNnraI
 s7uM1uoN
 LlJ0wwyyaOedgpmBJwC9MxyAbKZs271s8Xg07fO8svRkJl7d37TpzVQr+gEN6pKEwOtffE1cdYiEcu0NAgv5AJFBXO18EwHLF/IBa9VVqSNgCzkHz2R67Ur1ZLEvuCEPRoYOQLWZfFqjlFCOahr3xOOvX6Mje1Z9i5OUE/+YAhfaYR3xmlZVRkZnbJSHHc1Q4CgdUsin864SAxuLThIWkNoccU9uu0yiOVTNrrrzRsk6vou5L/0NWCzwNCmARij03tv5dmZDuJ6Eg030MJEM8WJLLAPeI48cTq7ASLYhqXnvos+dgJBKjw5fphobIo7gAAceLNDjGLR7zN70zw+WGtxQEek6b9kxWMYTaWAafPay4dK6/DK+rJ6Dxz9eFpUK2DOlr5Ks2MHqNZNwNIru9Mb0hMu2XOvPhV/Qvt0u8zsWTUoSNShMT3Z32vrV01ZtkDwRr15tbUddIEHdDGEp+6BVD82H9O7EHzKCsYksL6MwGyCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 05:26:04PM +0100, Muhammad Usama Anjum wrote:
> On 07/08/2026 7:58 am, Alexander Gordeev wrote:
> > On Thu, Aug 06, 2026 at 09:38:44AM +0100, Muhammad Usama Anjum wrote:
> >> The non-MMU stub receives hw_pte_t but returns a logical pte_t
> >> value. Convert the stored entry through __pte_from_hw() before
> >> returning.
> >>
> >> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> >> ---
> >>  include/linux/hugetlb.h | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> >> index bc0b9c65aa1d0..9e8b391aa4bc9 100644
> >> --- a/include/linux/hugetlb.h
> >> +++ b/include/linux/hugetlb.h
> >> @@ -1283,7 +1283,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
> >>  #ifdef CONFIG_MMU
> >>  	return ptep_get(ptep);
> >>  #else
> >> -	return *ptep;
> >> +	return __pte_from_hw(*ptep);
> > 
> > But this is a direct dereferencing, which breaks the whole point, isn't it?
> Yes, this is particular line is for non MMU. In this case, CONIFG_ARCH_HAS_HW_PTE
> would never be defined. Hence hw_pte_t is just pte_t and direct dereference is
> allowed. I'd thought a lot about it; is better to leave direct dereference here
> or use some helper. Then used __pte_from_hw() was already being used in generic
> ptep_get().

But in case CONIFG_ARCH_HAS_HW_PTE=n __pte_from_hw() is still gets called.
That looks inconsistent to me. Why not just call ptep_deref() (see below)?

> There are only two users of __pte_from_hw() at this time. 
> 
> > 
> > What about introducing something like pte_t ptep_get_sw(hw_pte_t *ptep)
> > to be used in exactly situations like this? With that the semantics of
> > hw_pte_t pointers becomes straightforward and closes the still ongoing
> > "storage vs lifetime" discussion:
> > 
> > hw_pte_t*     points to HW-formatted page table entries
> > 
> > ptep_get()    is used to obtain HW-linked/attached entries, and may wire
> >               extra code like [1] or [2]
> > 
> > ptep_get_sw() is used to obtain HW-unlinked/unattached entries and in
> >               most cases is just a direct dereference
> ptep_get_sw() or ptep_get_deref() is better name here?

ptep_deref() would be it.

Do you agree to the suggested API requirements?

> I thought __pte_from_hw() is ugly enough that if someone tries to use it
> wrongly, it'll be noticed pretty easily. I'm fine with any other name.

The name may be not perfect, but it is the way it is used above looks
wrong to me.

> > The caller should always know whether the entry is attached or not, so
> > confusions like [3] are avoided.
> > 
> > 1. https://lore.kernel.org/linux-mm/20260526-kpkeys-v8-21-eaaacdacc67c@arm.com/
> > 2. https://lore.kernel.org/linux-s390/650903a4-0dd9-4e6b-9d4b-3c32c5657236-agordeev@linux.ibm.com/
> > 3. https://lore.kernel.org/linux-s390/b44e071d-7c9d-4e7e-a84d-4af3499a5a05@arm.com/
> > 
> >>  #endif
> >>  }

Thanks!

> -- 
> Thanks,
> Usama
> 

