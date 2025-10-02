Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8BFCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 15:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CDDC8E0003; Thu,  2 Oct 2025 11:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6068E0002; Thu,  2 Oct 2025 11:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294388E0003; Thu,  2 Oct 2025 11:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 145BD8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:59:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5FB913B401
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 15:59:18 +0000 (UTC)
X-FDA: 83953633596.24.7BEC5A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C081D14000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 15:59:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7AAMHLU;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759420756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kh2fdAvE69Z/1d4X+1gCB36Cbyo4/Px6GUFvMw7tVOQ=;
	b=ZpXCm4TZHovsMlugIgGqY6tIYWcjis3N290ug56llfTSyaktVBu6d5SvgrDWbPDNAcTRDs
	GXavbE6KBADlaf0XvOn0aA2j8q+Q48fXQrqRVMfwH76WUXw9fKBVdvCGyLHR7JWnLw2BMi
	boB6xnq8E/Um6k+c7bQRIC2eqzWrbxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759420756; a=rsa-sha256;
	cv=none;
	b=qy3c3PXfbqDkwmFWQk45ZvK7xAHwVvuLNPvIH8ikOvMuoDGYtreXMNuPEPOF4df4rD+WgA
	elbfvcK4g0VKEiVYawg0ppFoteevMszLK94fcmyv+hLZeRArF/1gQG3KYg2ye8r8ajVq8W
	6PTKg/xJtTezBzKou8/+AFCelhIRvQY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K7AAMHLU;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8B5F63E74
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 15:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF07C113D0
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759420755;
	bh=KaeZNapUD3dfCILOnMMmQHXPV54lOgaSRR93Ry2Febg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K7AAMHLUf2/b+oL+wLPiQMgVBaBQJbhG5b6DQ6S/siLjNUs5QiEzoQ26jbpu4s704
	 lYZIQmrqJbtVoiy6j+w43aMIYd0nyT2hoJhgUJEAy2L8FkvkPTM6QuqFo7Kms3pK0z
	 RGamvHVakqCIYXlF0LYkU00XgslcN7BqSuGgjInKhzSvIAOWmhdebQoKT+shyvixOb
	 Hb+F4bgeXi7SG0XVBF942JgP7A5P4JHRjUUYSDhdkMrKVWWyY3R286pP1FgeJ90ulp
	 YYEJGBjQHIQLTmZBU28aV+pxMivGC72YVbsADflSe07mj81CiJhC4RMML6aOp7Qpv1
	 GwmR2gEwnPljg==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-72ce9790ab3so14255717b3.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 08:59:15 -0700 (PDT)
X-Gm-Message-State: AOJu0YzclBBu1s1jaNzYCROaV0MidW4uiqe2QHVvxluC3vea1eXH7TOr
	WSITDvbpgJ5711ZagYVWJ/SW+3D9cL3Ju/wIzZCZiRx2Xo0eME20oe9G949NJUO44aao4xoKYMD
	s+l5ypjdu5xo+2g3W4qQ32T1ChD6vj8p3x1LV2ko38g==
X-Google-Smtp-Source: AGHT+IGLsgc+2MrHeF8PiB6dqx8H4gmK46MCToPUzdW//wTHjQo/zoWdKB4z3bOSXuG+Lz8SxWUgckOmVR54kDBetYg=
X-Received: by 2002:a05:690e:d46:b0:635:4ecd:5fd6 with SMTP id
 956f58d0204a3-63b6ff74398mr8175633d50.51.1759420754579; Thu, 02 Oct 2025
 08:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <20251001043436.41338-3-bhe@redhat.com>
In-Reply-To: <20251001043436.41338-3-bhe@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 2 Oct 2025 08:59:03 -0700
X-Gmail-Original-Message-ID: <CACePvbXeFxbtH3c0Wvn56m+wsK0wqxP86ge5Ud73OvqnfDOwMw@mail.gmail.com>
X-Gm-Features: AS18NWCavH0Xput0H2iEPEjY3i62G94Xo-Cb9XuVctO47XryH6vr4dyC6fbQ_84
Message-ID: <CACePvbXeFxbtH3c0Wvn56m+wsK0wqxP86ge5Ud73OvqnfDOwMw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swapfile.c: use swap_info[] to find the swap device
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C081D14000B
X-Stat-Signature: 64rt1f53mfshuodshorsqhfj5rt3pjwt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759420756-317511
X-HE-Meta: U2FsdGVkX19xIFbK5o9T6Jl524bn8Ge0V+NI1Eewu86lDo/42e4oHEa/mjcC4VopIKS/L9tHNyeXSZXCrTMUpzkExQ4d1k+EoqVLsutOFRhfEtvgt6NHqwNx6hdwihUrHdc1LkLrhf3aunOrKW86r/t6DUrI+4cvmgR2KPwBSGxPgQBElQArBP3aERzIHnkYxx1vy59x0jRxliwYdMihOeacKSPc+zpidhzeYb70RpmFITpNaCpNByNRCtNZKl+hyrhed+878UiC0SDcJENMaxtCVrjEoPUDCgRw5F2xYZUQ1ANrLOUq/ZqSx3xT+ohQ3tldovvnq6v6e3xPowq1gadKsrp2f6lrpc3LhdyhngI5V4hHcJ1yHbGAmBEqorjJqXSkMXWv4Ng2wecNv1JY723VSBBEMow1XVj6gEC49YP3rODoSMweXpGRjdvSUBPGMj04YUmffzbGiL4fiO9UyKae2MOhebZ9iLStnpC8JTWzdl73As8uzGcLoFZCr95BpUuNrUOc/esSH/xlDk8E2r8qXGNUONZFZl7n1l/aELYWdFHDneRYejG3WhyFsz4+oBUDRfeGFizSpgAzJm73zTLJloR3WGPCfJllEeTZ8Zr6DWrpMuJPjloIda0x+MTTzWAyLs6m7/hV1nSBp5B0kNtKxTVOdpwdl0DfKa6vKAUj9rfFrE80zPTMpzck0EDD4KvIuaiIdXYwIB+MFJi34pAq7rWrz1///rIKrdXsABnH5KQorajHQ3Jdz/yUOxlBZ02ygWbhgFUmNZtnSYePExUJ2q63kDguWgjQ0HR6RvxhVlbQMBo+SDnaRQXPb3XaX4IJHSjeaDAlCpTcwYe3fQdTyq+jWduXKC0VNFoku57E17VLb5FFbIEk6NjWi9Y2oRKFIwnqB4v1uC6PVllsSjE0S29HmYfql9PCMW1x10o5gNjhSU2oJJlt2+qo3Fu3pUKqyqaqOsT5WH2gJ9l
 zeQXhPa5
 FKQuVIzJxuZfxv6QCSL1tYNuuZC2GtAsh1WnZ+h5Fgte+B0pQCTJlWIzEfgEupVQ+vPLnp13ryhhRU7kkMMXL2ZBeQ3ETIUUqw7JsJV3VYKnQdSPbqHtVyCeJh7yNGdYeJYDWWTdn32Fq/sRk4JkQJUfhqHxTRBq0PfADME4cNzq7Uzh1VkxZTAape4emoM8fkAoCnxBnWc0/Cms0dcW/rKoG+8yR68j7+g4GIu2Wwgq1oceaFPPK5FK/o8VWtUx0lvyXSginRtBoX/xloAyFNcmQ6VAwTR018pHhtvUzNUNGKknHTkdtTmDa/EcCvWCZWIyeMAOUOAKWo1pyGgbaIiRRJw30pK19fhtmBXqcEhcqr8QlHHIOGEasdaZpyF+CI0Le
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 9:35=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> Now, swap_active_head is only used to find a present swap device when
> trying to swapoff it. In fact, swap_info[] is a short array which is
> 32 at maximum, and usually the unused one can be reused, so the
> searching for target mostly only iterates the foremost several used
> slots. And swapoff is a rarely used operation, efficiency is not so
> important. Then it's unnecessary to get a plist to make it.
>
> Here go by iterating swap_info[] to find the swap device instead of
> iterating swap_active_head.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  mm/swapfile.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5d71c748a2fe..18b52cc20749 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2641,6 +2641,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         struct inode *inode;
>         struct filename *pathname;
>         int err, found =3D 0;
> +       unsigned int type;
>
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
> @@ -2658,7 +2659,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>
>         mapping =3D victim->f_mapping;
>         spin_lock(&swap_lock);
> -       plist_for_each_entry(p, &swap_active_head, list) {
> +       for (type =3D 0; type < nr_swapfiles; type++) {
> +               p =3D swap_info[type];

After some careful thinking of the swapoff behavior, I now consider
this patch buggy.

On behavior change is that, previously the swapoff is dependent on the
swap_active_list and only swapon device is on that list.

Now you change to enumerate every device at swap off and depend on the
p->flags & SWP_WRITEOK to filter out the device. Which will go through
all 32 swap devices regardless.

>                 if (p->flags & SWP_WRITEOK) {
>                         if (p->swap_file->f_mapping =3D=3D mapping) {

Considering the following race:

CPU1:
swapoff( "/dev/sda1")
spin_lock(&swap_lock);

for (type =3D 0; type < nr_swapfiles; type++) {
     if (p->flags & SWP_WRITEOK) {
         // found the device.
}
....
spin_lock(&p->lock);
del_from_avail_list(p, true);
plist_del(&p->list, &swap_active_head);
atomic_long_sub(p->pages, &nr_swap_pages);
total_swap_pages -=3D p->pages;
spin_unlock(&p->lock);
spin_unlock(&swap_lock);

// at this point the p->flags still have SWP_WRITEOK.
// swap_lock and p->lock are both unlocked.

Now the second CPU swapoff race begins

                                                       CPU2:
                                                       swapoff( "/dev/sda1"=
)

spin_lock(&swap_lock); // can take this lock

                                                       for (type =3D 0;
type < nr_swapfiles; type++) {
                                                       if (p->flags &
SWP_WRITEOK) {
                                                              // also
found the device. because p->flags are not clear to 0 yet.
                                                       }
                                                       ....

spin_lock(&p->lock); // can also take this lock

del_from_avail_list(p, true);

plist_del(&p->list, &swap_active_head); <=3D=3D=3D blow up here
                                                       // remove p not
the in list.

atomic_long_sub(p->pages, &nr_swap_pages);
                                                       // double subtractin=
g ..

total_swap_pages -=3D p->pages;
                                                       // double
subtracting as well.
                                                       spin_unlock(&p->lock=
);
                                                       spin_unlock(&swap_lo=
ck);

Please confirm or deny if that race is possible.
If it is, consider it a NACK to this patch.

Please consider that even trivial patches can have subtle behavior
change and it has non zero cost to reviewers. It can introduce subtle
bugs unintentionally as well. In this case, I feel that the
gain(removing a list, total less than 1K) is too small,  not a very
good return on investment.

Chris

