Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D27CAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953F68E0007; Thu, 25 Sep 2025 13:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904E38E0001; Thu, 25 Sep 2025 13:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841A98E0007; Thu, 25 Sep 2025 13:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 747D68E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:36:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E3151DF901
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:36:07 +0000 (UTC)
X-FDA: 83928475974.10.DEFF107
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E8E7880006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:36:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r/TftEX8";
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758821765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=at1PwGx0vPYImvsgpKTo5NgOyLGGTYB3k5Gr1wyD+V0=;
	b=8RL5vzFnd92w+q99vH2ceUqVPDpMdDNHHvS2OJ6G6mVliKR9w+ljHvQecysCyJEREslFch
	EbN7vCTxFJoxD6CjF2cWb3e4IQhjibHoakH6rJ3QBN8oGe0CzaSzV2EtR5va8u5QyMgBrS
	TogirGsoNO8eIJK8rjPlPFwzkFJ/x6s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r/TftEX8";
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758821765; a=rsa-sha256;
	cv=none;
	b=5ZktkzuFPPZBK+2/Q7AuYLxCmMgF6KQVrHcdj8L8a0was9yVC4pJ6Toujg575FeGp2OVp2
	Rkl3zamg+WodCP7CMO0Wb7foG9BSk8KsVbVA+Ky2XWfNxu/BYU7ufIv15TT1XZG50apo4+
	GXdq6TNCPcGz/NFqEr64Lt7cTq1MtHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7528D40BEA
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536A6C4CEF0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758821763;
	bh=6X+Kwq99hJ6RldFuwAIqGeWDneu3vOuSsUP6CqzbVfk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r/TftEX8EQYkqXGinosO6v7+qLQSZOXcE9dnQBYpDp2u9Wh4HkKGsITtSdPYO6eH0
	 XENj/ROS4rFfbRHo3by8it045lyMpNB5eVEvfBOAJztTy3pTLYdzgUK4UmLEp6k89j
	 C3T8EXVe7RGe9Q8qH8kKLA85q170G+QKA40ZXkEoiqXTePUb92B4fPar7ecv4T+qbY
	 UT9gIAlXrJBZ6CIF1++J2xHOq2Isg6iDiVkI3s19DFv1lYsHdEgNQJAydZ6wZ+Ztx3
	 ElMyJRKcloqBy7Dy3B5HGqgnkWzl8FTT4ibZh1JXkuQT4sGNMJBIMxpNq3WeN5mop5
	 Cm6+743FC0nFA==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-63607a57bf2so120700d50.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:36:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWz8iyr1wtF9No1wFIvA1PdyrGrO4xxKt9BfatKRo0Lmc1IRFGie20RPg1y2RXvXbsk34aPvujw6g==@kvack.org
X-Gm-Message-State: AOJu0YxbVJWeJc39hLCQzYh2te2bOYi5SAp9yjpglrCD3wFnUO5WajLD
	zEkxsDSAtBSB52MCKvjndj+BMHvJfvDsW41J4ec1iiD4Qd2+pmDZjcfEE8tZfFFLky4dG6hquY2
	ASF9iKPqjPdL6iRNJe1gm3zgN4HN+nwpge+T3jQY8sQ==
X-Google-Smtp-Source: AGHT+IHiAaqrhjdBeWzemxxoy5Q/R4D0Bg1Krf9r3MkkhdAeLx/hi/f4ggBJoQJ1TWCnJxEIcknHVa4xwmbnHdx/DUg=
X-Received: by 2002:a53:7212:0:b0:624:1660:ba01 with SMTP id
 956f58d0204a3-6361a82db92mr2632679d50.37.1758821762606; Thu, 25 Sep 2025
 10:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250924181138.1762750-1-charan.kalla@oss.qualcomm.com>
In-Reply-To: <20250924181138.1762750-1-charan.kalla@oss.qualcomm.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 25 Sep 2025 10:35:51 -0700
X-Gmail-Original-Message-ID: <CACePvbW=-KZhU_qi4UUw7Pjbz4o=SQwHmQyEOkxhpMvdetbPCg@mail.gmail.com>
X-Gm-Features: AS18NWCdaLC1Wp3RSMP0da3-Fs18-J7lkLeP98ZrcoaPfKuh1jdrt-Zu6iPTusQ
Message-ID: <CACePvbW=-KZhU_qi4UUw7Pjbz4o=SQwHmQyEOkxhpMvdetbPCg@mail.gmail.com>
Subject: Re: [PATCH V2] mm: swap: check for stable address space before
 operating on the VMA
To: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
Cc: david@redhat.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	akpm@linux-foundation.org, shikemeng@huaweicloud.com, kasong@tencent.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	zhangpeng.00@bytedance.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E8E7880006
X-Stat-Signature: eueb6t4xjmsj43o79go3gdxm5pexihog
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758821764-639966
X-HE-Meta: U2FsdGVkX19gyR/V7BNFZBOJLWtIhDzEWqQ6Tfj+k63/hf5sGnfHgHhZaHjhW+XtJBKhTHt54HMgdcQYA8LyFdb406j6Moi4WH0eGywMmzvlK9iEKrRRVThx2ZHY/BeHuDnTdjj0BWsUF5PIUapOlypckn3KXWMkhl2m9UVFf0dgO4r1bIEPZUiimilZeOyKg38RBJUXSYcZrN7yyq65CHyMVeK71c9ITjRp0ShmuOSBKodUqGhW82xnrBhMSBQTJuPUjIX9G65sz9YAEJF7QQuArjgNCPYYY/dJHKSn4zEY0hnmyvYCmGW84wnfQ9Wp/6I4Djdr1MGeOMWQK12i2bXUit51A4s5uzPPtFHkKbVn7ZWlxGe2N3UX5EyHsW0VscYciJK9xEGc1ltUy7hgdeswNO74PzGgSFL5FC38DQGr7O1Zm2wcvj2Apumye1l4EDeVaLt/pqAIR4ZITJo2HV5TxDM77gRUSGLLTDFDqauJ6R76Tg9oO5sJog9xyrg9lIFe9vEJRzhvj0iyZy8ux0nTH20EM8PYPCtC/AFDgU8xnOJmWJodwk2mV0FkTRHHD5k7HpnJ3yp311nTcOUitL5mg1MkInWNKNVvZG5sipCfHTh3m63JYee83R8Ph8MyDxEBess0l71IvWNCvrUyhtLtVulf782ijcveImKbgYU/G4GurUEUVK8/4Msm7Gf1rKVtWSogQlRq/fDuy44p8o7yA9b2w7+nZmImbO06WsEdk3EscVF3BU9SvphTFhTVp7E8TCZGHjiZF74UisSN6TUBrP09Nn+LXiDtqk3taedc1fLxucDaHlLYP/WGPn48oQJCDdklCOKuSomZ/Cs5z1FCnC4mU+v6Y8ZMEHVSpGl/1Y1+/XqYwagGBF2YPiSG7k4fFSKHAfJAS/k1PYz1M/Wx9TlNkNhVWBHkKFn5kb+1CVAGzDsm5HE2oVqrYBvobqbJzNyTYBmJ3jfx9qG
 34zWhUff
 pow8RdhFgldUkJ/PeFzdWEGEocZf20WmxMlb/QdDW5pXLEfFKl2rWrVlb3g7BXuGYc8jLbwPS5m0q8jZnSC+9AQuKaisdjz7qwjvt0sTSYTkHVLFTZlldonckPGd9/pdHKagbHHvWBauQo8Tdhw0YUQsM0RgFEJbLpuiI//1uWVBjcN0Ihq0/HDz/Rf64t8ptRyvWtD0P853OeMhw7rorksQomkZL47PdHqTbhyCAvZhO+cIZJIq/f0hGbY+nv5wy44XgDJ2xOxHWtGnI1HTYCWqhqLtGipUZKovKI0T2eAnuAk/r6rA9nt1rhIax5R8+6OLE1CsfRMSSeyDfdbKBSHLQQP+9eRxVInGjYhd1ep4ofVMzI27yRrRq2qIVXxeoPsdtAkXxzcoqL3nz6lGD7c+s9TY/WUtjfDCG8S8EWyZORbScp+l4pXG3mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

?

On Wed, Sep 24, 2025 at 11:12=E2=80=AFAM Charan Teja Kalla
<charan.kalla@oss.qualcomm.com> wrote:
>
> It is possible to hit a zero entry while traversing the vmas in
> unuse_mm() called from swapoff path and accessing it causes the
> OOPS:
>
> Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000446--> Loading the memory from offset 0x40 on the
> XA_ZERO_ENTRY as address.
> Mem abort info:
>   ESR =3D 0x0000000096000005
>   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>   SET =3D 0, FnV =3D 0
>   EA =3D 0, S1PTW =3D 0
>   FSC =3D 0x05: level 1 translation fault
>
> The issue is manifested from the below race between the fork() on a
> process and swapoff:
> fork(dup_mmap())                        swapoff(unuse_mm)
> ---------------                         -----------------
> 1) Identical mtree is built using
>    __mt_dup().
>
> 2) copy_pte_range()-->
>         copy_nonpresent_pte():
>        The dst mm is added into the
>     mmlist to be visible to the
>     swapoff operation.
>
> 3) Fatal signal is sent to the parent
> process(which is the current during the
> fork) thus skip the duplication of the
> vmas and mark the vma range with
> XA_ZERO_ENTRY as a marker for this process
> that helps during exit_mmap().
>
>                                      4) swapoff is tried on the
>                                         'mm' added to the 'mmlist' as
>                                         part of the 2.
>
>                                      5) unuse_mm(), that iterates
>                                         through the vma's of this 'mm'
>                                         will hit the non-NULL zero entry
>                                         and operating on this zero entry
>                                         as a vma is resulting into the
>                                         oops.
>
> The proper fix would be around not exposing this partially-valid tree to
> others when droping the mmap lock, which is being solved with [1]. A
> simpler solution would be checking for MMF_UNSTABLE, as it is set if
> mm_struct is not fully initialized in dup_mmap().
>
> Thanks to Liam/Lorenzo/David for all the suggestions in fixing this
> issue.
>
> [1] https://lore.kernel.org/all/20250815191031.3769540-1-Liam.Howlett@ora=
cle.com/
>
> Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup=
_mmap()")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
> ---
>
> V1:
>    -- Checking for xa_zero_entry() instead of most cleaner way of
> checking for MMF_UNSTABLE
>    -- https://lore.kernel.org/linux-mm/20250808092156.1918973-1-quic_char=
ante@quicinc.com/
>
>  mm/swapfile.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 890b410d77b6..10760240a3a2 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2389,6 +2389,8 @@ static int unuse_mm(struct mm_struct *mm, unsigned =
int type)
>         VMA_ITERATOR(vmi, mm, 0);
>
>         mmap_read_lock(mm);
> +       if (check_stable_address_space(mm))
> +               goto unlock;

This is checking the MMF_UNSTABLE bit in the mm flags.
What is the locking requirement for accessing the mm flags MMF_UNSTABLE bit=
?
Here we hold the mm mmap read lock.

As far as I can tell, there are two paths that can set that bit.

1) dup_mm()
It holds the mm mmap write lock. This path is fine due to the write lock.
So far the above race against dup_mm(), adding this  check is fine.

2)  __oom_reap_task_mm()
It holds the mmap read lock when setting the MMF_UNSTABLE as far as I can t=
ell.
So checking the MMF_UNSTABLE with another __oom_reap_task_mm() does
not exclude each other.
This is more of a question for oom reaping.
Does MMF_UNSTABLE have the test vs set racing here? It seems this
check does not protect against  __oom_reap_task_mm(). I have no idea
if this race is triggerable. Just want someone else to double check if
my understanding is correct or not.

I can see this patch does protect the intended race in dup_mm() vs
unuse_mm(), it adds value.

Chris



>         for_each_vma(vmi, vma) {
>                 if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
>                         ret =3D unuse_vma(vma, type);
> @@ -2398,6 +2400,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned =
int type)
>
>                 cond_resched();
>         }
> +unlock:
>         mmap_read_unlock(mm);
>         return ret;
>  }
> --
> 2.34.1
>

