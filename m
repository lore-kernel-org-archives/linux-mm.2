Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0BACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD018E000B; Wed, 22 Oct 2025 05:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD568E0002; Wed, 22 Oct 2025 05:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074A08E000B; Wed, 22 Oct 2025 05:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5E8D8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:30:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7240A14076F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:30:32 +0000 (UTC)
X-FDA: 84025229904.09.4534614
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6C45E40009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:30:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jqM07O1Q;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761125430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZHxml0O18Vg7HUA3QwmCPVMku0Lb676UdH10r5wy0U=;
	b=QFjlXuMwN3sTK48hGXAMuYe7I1PxHArFRS0I4om1Ceq94Xkg4Ga8JMaFjvBHxbTRtfCNiZ
	Br/7JI+Bsm7ImRIQV5AT/A4GYk6kn/yaFzHJKl20BoWImkN9ipXziYyZzo1lMfbXS0qL0q
	e0e4KwMsSeEyecUgGKpLCaKS5KP7hlo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jqM07O1Q;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761125430; a=rsa-sha256;
	cv=none;
	b=jmpnpOykRYycr0aW7f/AAXggpCblzMxLFEPWM5s01dWd401P/+ylOxnHyvQuTuuW5J7fGV
	H7aXjwbDRYOhIBx7WgXkyJA0e/IybLpAC51mN6DlOVx2dCdlUT4WG6SrkBgpl+lIJOr9b+
	D7VacT3YnT9Ypn40Kx4bytg6coYcOxg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761125426; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=mZHxml0O18Vg7HUA3QwmCPVMku0Lb676UdH10r5wy0U=;
	b=jqM07O1QdNz01NceVGafF+1NiP7V8ca7e/Ei/LZOwfQ1HSeH/C/yTiAchlmeHqH4CL8lfy5iCK1vB1FeyYJzO1oXjh9oxL6SNiP6Y5jMI3JkzXuk12AIkjNO4fMq6qykDSwqKBaWulVrulxLC+tEXogB7aBBTGubGmJs561mJso=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqmQxuR_1761125423 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 17:30:24 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,  Zi Yan
 <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Ryan
 Roberts <ryan.roberts@arm.com>,  Yang Shi <yang@os.amperecomputing.com>,
  "Christoph Lameter (Ampere)" <cl@gentwo.org>,  Dev Jain
 <dev.jain@arm.com>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Yicong Yang <yangyicong@hisilicon.com>,  Kefeng Wang
 <wangkefeng.wang@huawei.com>,  Kevin Brodsky <kevin.brodsky@arm.com>,  Yin
 Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
	(Barry Song's message of "Wed, 22 Oct 2025 22:17:56 +1300")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-3-ying.huang@linux.alibaba.com>
	<CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
	<87a51jfl44.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
	<871pmv9unr.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
Date: Wed, 22 Oct 2025 17:30:23 +0800
Message-ID: <875xc78es0.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6C45E40009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kpn3fhufy49o3j3dmwpr7iik3kh75i9t
X-HE-Tag: 1761125429-312482
X-HE-Meta: U2FsdGVkX19RdhwkzPz3PgIUMfOkC6SEVMRkJLePv9KUl2opsDKKHJixTSZ7bGP2dKfIMoGtVJWkXKUUvv9n1mR1MgFd3xp19Qv6aNg370XZNbNIROKh++ozHet5EVtrSRKUGKD4arjZy3POT7b1/gWGWD+Y8FjI0XWsAL5+vFXlTeLE0Lq42SM+8WmNNTeRNokGrcwtFpMYkEnkyG4HdxRQyX7cnJHLytjqQ49UFWdrU6uuylOh8EudsG+12xLaZfsygHDkIPmlA65QXA8xsi4XQwCDdd/FecjYdtvia3fBWlt7szO+eyO0TQJ8bdEO2nEkIM+Nx0doQ776dzHHU9NOtPckjE99AOR/JbzCqtB5mCB3SSY0xlnkGDu4o5cRJNn51c+xwpVfnSJ0T3tdqnmyLh7gIKLi7Wn5Y0zfrAZWgVIdfVfjgfhGo5/Ia9U3u4wli+hpM5iwwIessaAg3a0+XIlmbTWvRCgW2JQBLD/fsWhHNsky73yjmDZwl7HwmHGghzLLy+OaQ0XtGESQbBmWWXxxEEXSURsooF5yXXirmmLoD6m6UZu+V/7jtMywr96L6d37M0qYYDdaZquRihKy2mmQrCU0T+I+GQp3QAnPqH6ZxayTm9NqR3wI/vr8pXRU/m31Bu6q2ONh+jiayxXsgUmSryd7lpypAmS3pLzPUDGjIwxkZ84+xlY6HcsXLM/B+snF8Hg9QdFRQUWJdBu520DcLfPCHz+k7/A0ognNsohiqgoQdAQLqtLrk2b1vBfCktaEIS83U9KuALBUEvFkcj3ja6cnpBsYgJRgbhASwOeh3rewD4W4rHEjCQvdh1V5X0B0b+LWs5yN45CnBsWrxs1M/kgZ20LDxAxboHVWZQthTmzoLKggEE9gMjgNUA8iQ/ngQRE7DIT+UnIFxrk0UG9pFtOjNZFIC6tqs/O3WLS1BBt4q3QuKv62myJRATEFm3kWpFQo/hHIHpS
 abIwrxMu
 uK5hBcV1HgX7w8jCvmZPB0m22vZHOsQV/EMqJtoWWfVHyNPvXrm4UcwF/Nbp2LeKShkN6Qeq3x8lBP/FzuachbIJ6ShUAvnK9jYgE+PZfifFS4RlSJsCGeQ+c0gjt920vAZ0UuH/tAOXYQfpCu72oDScfAjlJzC5rFueokeWy2WxnSI/CwFu+axqbbGoN0SQeDn3MzpHny4wI5gWN9lQrF1Cd309R3JbKrXfbZMCOJSlHnRp6tQn4sp205cbOvtjAqeUEoZWuPIwMDKyUnTZ5A5XwFgZpno+oFp0u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> writes:

> On Wed, Oct 22, 2025 at 10:02=E2=80=AFPM Huang, Ying
> <ying.huang@linux.alibaba.com> wrote:
>>
>> Barry Song <21cnbao@gmail.com> writes:
>>
>> >> >
>> >> > static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>> >> >                                            unsigned long uaddr)
>> >> > {
>> >> >         unsigned long addr;
>> >> >
>> >> >         dsb(ishst);
>> >> >         addr =3D __TLBI_VADDR(uaddr, ASID(mm));
>> >> >         __tlbi(vale1is, addr);
>> >> >         __tlbi_user(vale1is, addr);
>> >> >         mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAG=
E_MASK,
>> >> >                                                 (uaddr & PAGE_MASK)=
 +
>> >> > PAGE_SIZE);
>> >> > }
>> >>
>> >> IIUC, _nosync() here means doesn't synchronize with the following cod=
e.
>> >> It still synchronizes with the previous code, mainly the page table
>> >> changing.  And, Yes.  There may be room to improve this.
>> >>
>> >> > On the other hand, __ptep_set_access_flags() doesn=E2=80=99t seem t=
o use
>> >> > set_ptes(), so there=E2=80=99s no guarantee the updated PTEs are vi=
sible to all
>> >> > cores. If a remote CPU later encounters a page fault and performs a=
 TLB
>> >> > invalidation, will it still see a stable PTE?
>> >>
>> >> I don't think so.  We just flush local TLB in local_flush_tlb_page()
>> >> family functions.  So, we only needs to guarantee the page table chan=
ges
>> >> are available for the local page table walking.  If a page fault occu=
rs
>> >> on a remote CPU, we will call local_flush_tlb_page() on the remote CP=
U.
>> >>
>> >
>> > My concern is that:
>> >
>> > We don=E2=80=99t have a dsb(ish) to ensure the PTE page table is visib=
le to remote
>> > CPUs, since you=E2=80=99re using dsb(nsh). So even if a remote CPU per=
forms
>> > local_flush_tlb_page(), the memory may not be synchronized yet, and it=
 could
>> > still see the old PTE.
>>
>> So, do you think that after the load/store unit of the remote CPU have
>> seen the new PTE, the page table walker could still see the old PTE?  I
>
> Without a barrier in the ish domain, remote CPUs=E2=80=99 load/store unit=
s may not
> see the new PTE written by the first CPU performing the reuse.
>
> That=E2=80=99s why we need a barrier in the ish domain to ensure the PTE =
is
> actually visible across the SMP domain. A store instruction doesn=E2=80=
=99t guarantee
> that the data is immediately visible to other CPUs =E2=80=94 at least not=
 for load
> instructions.
>
> Though, I=E2=80=99m not entirely sure about the page table walker case.
>
>> doubt it.  Even if so, the worse case is one extra spurious page fault?
>> If the possibility of the worst case is low enough, that should be OK.
>
> CPU0:                    CPU1:
>
> write pte;
>
> do local tlbi;
>
>                                        page fault;
>                                        do local tlbi; -> still old PTE
>
> pte visible to CPU1

With PTL, this becomes

CPU0:                           CPU1:

page fault                      page fault
lock PTL
write PTE
do local tlbi
unlock PTL
                                lock PTL        <- pte visible to CPU 1
                                read PTE        <- new PTE
                                do local tlbi   <- new PTE
                                unlock PTL

>> Additionally, the page table lock is held when writing PTE on this CPU
>> and re-reading PTE on the remote CPU.  That provides some memory order
>> guarantee too.
>
> Right, the PTL might take care of it automatically.

---
Best Regards,
Huang, Ying

