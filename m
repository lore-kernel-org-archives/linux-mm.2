Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA63ECCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 00:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138628E0003; Tue, 11 Nov 2025 19:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2658E0002; Tue, 11 Nov 2025 19:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBEC8E0003; Tue, 11 Nov 2025 19:10:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D65758E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:10:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6607F87C6F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:10:57 +0000 (UTC)
X-FDA: 84100024554.18.FBC4CE4
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 87EBF40009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:10:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r3mcs9bt;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762906255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TofOimS+W4wPqm1YozjJKcKMNkewdNdNRtQ6Og3Qixg=;
	b=r98IsVDWbvoUYkgtSLUcuZOu3yJnJQAMQ5xQLitLC3OfKkvtplYuE2Vl7GZ83Xi+c1lqBS
	hTIzdj7PKYipZUAC1erDizta9YI47ORCkAw8Io/6MG+uDcvrkOfUtJWSGJJk38n5vNm2it
	qHuLk16R/CHmPP84s1H20Teh2+vdBr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762906255; a=rsa-sha256;
	cv=none;
	b=vCRU6ns8XInMUu+ZT8NDbz/eW5umlKniE3SxHVP8i+bMho8mj+/58zX68WotQJFyy4HJp8
	H5odMTyKu0L4rtXAruQzq//AqfjtSg/FVg0xK7LRlykAar6bP5C+qMRMBmyh88UQb8fhlW
	gQ/haBTfjPKMpBQIGLQA3qyhuMPN3sM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r3mcs9bt;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ed67a143c5so123331cf.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762906255; x=1763511055; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TofOimS+W4wPqm1YozjJKcKMNkewdNdNRtQ6Og3Qixg=;
        b=r3mcs9btXUJFLvjnhePwKR+ii/vUlkjdqf2OctjeQhSAVqZiwfz+CeSBnxMb7QGDWO
         brsquUDiH73su2gPCKZy4gvvGKSVCho7MLhjX+jzoa5inaIp1T84JnaS870q+X6Z19kt
         c501VfXBLEFjiRPWQWPi0tdi7Eclva57SuEBL5oJanKR0QACTqlDSc/GFaorFAB4Hl+X
         v+iCmiicAn3x5rbI0kPrv+9vwPGObmBZmIxYEXz0w7o+RlzjRc/6pyGy388rXCQdhYPz
         EUqW7Jm3B5Wak9VP42igZ+zDv9VMvMbrftfwzNOlu/unML0I3m27RmesfdXECoj7Iq2S
         bUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762906255; x=1763511055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TofOimS+W4wPqm1YozjJKcKMNkewdNdNRtQ6Og3Qixg=;
        b=XoYANru29w7iiSkBtzMh9uiDpZeHqfxzcAywmuPmRSLi69XP6w9SxXB3zwcCTDZ5I2
         CUGNnB+LXRdPV+2ylIfcbQPTlShVferjPKIuEyXMc/mV1xFWixOZoBT89i/N5z+iLvBy
         dUgL5os1c1gGB7Yg+Er/JaEqnjK+bR0+EOqbSBj3asxGtzvBVGp+/OvaXF8Mb6nzAafd
         Hoi386SXgABqj3RyZkTEJiIj7xZeW63iD3w4Bs2zIvk1jMK3cAfFYt739WviIZoxjCns
         RmJmABtsQC65sqPSzoIerX0mCLXiqlhpBlYqni/jjl1CRGlH0qmPjV4ch75EW5MwvKk1
         oHeA==
X-Forwarded-Encrypted: i=1; AJvYcCWTx5Sf33dHzHdJ220Qkuk7WMfDFtWnmB4P7CpkB4GMivO3r8ybEEHY+ChoSwZdVI8JDhm8wwGjLg==@kvack.org
X-Gm-Message-State: AOJu0YxIOffYtgJvaGdpCKMCU7VxpsYbR3cDxChwXpdOR7rQS6W/eZVU
	6Q31eCgu4mt57P6e3xWJfoN+SfzCNE1bDRGGiHermRow8cg1Kx0SS3M6jf//S5lnfC1jFeOnM9y
	Zxstz+jJrLFtoEYUE6nmNOAerUPzYAIAJt61GzKvv
X-Gm-Gg: ASbGncvILheTcLueWa7p2k72RVp/EN15mV+jTpnoozIcxzpORoWVVHw34IPMQjH6exf
	y1RMtUh2jSfofS8MteGzrcu9YbmbHYARLCBfBPswIVkDXBeX0i4moq6URHurUr7ZIU3M002z8Dj
	YyG7kYMq/+D33if0otgLxeeueGm+cnOlydqjlZie7HJh1k1aubk0UcD5+lI416t5wTFlhDDcDHh
	e1Ppca/+fhtQNF4cxhoDcKSq0MGE+HqehwEa0aIDz4fgtkZOqxlfe7pzHjIBvEBPkv68bBzhlK2
	CPVWlTm3XFF5Kku7szfnUKfSChlJsD8GOs8=
X-Google-Smtp-Source: AGHT+IG1ecyNEMTs/bPngxeeJjhChHGBg4qLSCj1E5+5//1j9A4bIiyry1IsaHfEA9GI8rjBudj4rW/glVxvWiugGjQ=
X-Received: by 2002:a05:622a:2d5:b0:4ed:7c45:9908 with SMTP id
 d75a77b69052e-4eddc1171d0mr2843151cf.10.1762906254090; Tue, 11 Nov 2025
 16:10:54 -0800 (PST)
MIME-Version: 1.0
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com> <8219599b-941e-4ffd-875f-6548e217c16c@suse.cz>
In-Reply-To: <8219599b-941e-4ffd-875f-6548e217c16c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 11 Nov 2025 16:10:42 -0800
X-Gm-Features: AWmQ_bkHdozyKSgPF1d5Bsi9z5t37_9KCgiztdRPoTJRYXVkpDN0VkjU8MHCXMY
Message-ID: <CAJuCfpESKECudgqvm8CQ_whi761hWRPAhurR5efRVC4Hp2r8Qw@mail.gmail.com>
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu() retry
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, stable@vger.kernel.org, 
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 87EBF40009
X-Stat-Signature: pc6mxax633q69benpukr5e4jnuo7d78k
X-HE-Tag: 1762906255-977670
X-HE-Meta: U2FsdGVkX1/Hr/hTAE6FeuxFlsewZCy5dpyupbkdogRtGZ4sAWU42LmhUm+2OtgDnPrDGK92xSrklVwgJ70TYmWcaNQXrDexK9WAGduarPua3WYH1OPkrbJxob+7IWBqG+69wHyXwCygGxXNrJVQxV6iVfQ5jekycc4STBvwc+3qwDk0Hn2LAc6jmmkqNAZ9VKM219m05NmKD0dvOOlRRoZfdmwkXE3OUD3gReL/NBTfIzrOdxBogLEtv3bCyc5oNQPJkD6QGh2x+bxdmqb9SMiGX8fVEQn/dZlbc3caXYs7UWXrhy4maUw0Rtk0oM75cBh5xB9E3xgCWA89S/SC3BvOe2tapx4U8B7iggoGoqEhYYrBgDzpzPry93pMTtKiSNCKz13whDK9hO0uTO52ZEc7f3gnpXBbvRkdkfQoCKhFkAog6ONTrAZSqSIPz6uoidUlZ/Mxq2D5wuN5WE2a2MJ+XhP+VqxYyxtdnl2d34AOreMO0t/4lSsuNVNiECdmphnZt7KrsCt/1pHLWXVcYNng16PseujosL6S9W/nZJ4lyhGSTdjUG/PwZp3xy06xOiPCEalGdp/cBEXpePyr8AxFv+PgqXf6d8x4DxVyECdnHS1/zkg1SFLt1jgmf4Qj7z6fH0CyDg/B7icOHY7O+xLWu4xgVHlXuo/9hUxXsfJW+htlbg8U4443yLUBBy46v5WCsdUjQwLkQej8rHWcK861Kkr8ifnXs8azwikfF4JGJnRobgDnZPbDtS5HrqMPRCZ0qrZttcZQBRCrV93TBHlSoMS2Q31c6/MQKsT4xQk8MwZXd5T14KLgNjCTbrNz2EB2bXM9LampNvK4Uc9nAan0saRKFxf3mSJbxQn5lBBxEobWGagQU1UJMia313TGKTy8Z9r3raeiME1gmDC1gm9J1gYpQcF7IuZK4R4h2edsdyKAN5HX5eZzAYmNLLlo+vSwIZEEr7ZuxvwIqz1
 ENUk+2uK
 qEXKfnEs08ekfTIPMi7TaESwYB5x5O+utaBwm9uMCQ2Gax0zk2tMFhSGzRcQrax2k9sopxtB+ar1ze0BWkO0HeHQmr4GNe5wGI7KwMt3nM8C1X7YuZ1JKvDpOA1v1hCHOAFwRwrx2DQMzenUgZEL8eJDHGfsmCIVrT+b44RSiIA2Vy6v4e4t1RInnprZIYBRFhm+Xrv/7XqDly0hT1hq4H8TqbTQVUFNtQi0xHwXV+1DVtd5geoLBJs/UyoA6bwUIQx3WmiaKTigMieG5g3oWE6qCamCZc/dyubhXC4VU7I+EFXmnIQVG14FO0+uj6u5CYaZNrBnsh+qNx4MaoFiR714kiD+zV28W7tNvH5jqqNjOhUzuQyJAIo5ol9Irh8JlXfb2NXafZNwO4hBVWtm0OBj7LJLwvZ/Bi+cFND8+NUTOq4Mon7zHIE9JNph+tuAXloZGXpGnnyTL1z8XYp6S6BMfDrtnKEf0NdJsphrYAi8wnrGM1GGdrOYHEPwJC/TyTqtXz+rGoJ2sDS4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 2:18=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 11/11/25 22:56, Liam R. Howlett wrote:
> > The retry in lock_vma_under_rcu() drops the rcu read lock before
> > reacquiring the lock and trying again.  This may cause a use-after-free
> > if the maple node the maple state was using was freed.

Ah, good catch. I didn't realize the state is RCU protected.

> >
> > The maple state is protected by the rcu read lock.  When the lock is
> > dropped, the state cannot be reused as it tracks pointers to objects
> > that may be freed during the time where the lock was not held.
> >
> > Any time the rcu read lock is dropped, the maple state must be
> > invalidated.  Resetting the address and state to MA_START is the safest
> > course of action, which will result in the next operation starting from
> > the top of the tree.
> >
> > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
> > lock on failure"), the rcu read lock was dropped and NULL was returned,
> > so the retry would not have happened.  However, now that the read lock
> > is dropped regardless of the return, we may use a freed maple tree node
> > cached in the maple state on retry.

Hmm. The above paragraph does not sound right to me, unless I
completely misunderstood it. Before 0b16f8bed19c we would keep RCU
lock up until the end of lock_vma_under_rcu(), so retries could still
happen but we were not dropping the RCU lock while doing that. After
0b16f8bed19c we drop RCU lock if vma_start_read() fails, so retrying
after such failure becomes unsafe. So, if you agree with me assessment
then I suggest changing it to:

Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
lock on failure"), the retry after vma_start_read() failure was
happening under the same RCU lock. However, now that the read lock is
dropped on failure, we may use a freed maple tree node cached in the
maple state on retry.

> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on f=
ailure")
>
> The commit is 6.18-rc1 so we don't need Cc: stable, but it's a mm-hotfixe=
s
> material that must go to Linus before 6.18.
>
> > Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D131f9eb2b5807573275c
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

With the changelog text sorted out.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  mm/mmap_lock.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 39f341caf32c0..f2532af6208c0 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm=
_struct *mm,
> >               if (PTR_ERR(vma) =3D=3D -EAGAIN) {
> >                       count_vm_vma_lock_event(VMA_LOCK_MISS);
> >                       /* The area was replaced with another one */
> > +                     mas_set(&mas, address);
> >                       goto retry;
> >               }
> >
>

