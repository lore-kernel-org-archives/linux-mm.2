Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCC0CC6B3E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8266B0088; Thu,  2 Apr 2026 11:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0426B0089; Thu,  2 Apr 2026 11:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D74D6B008A; Thu,  2 Apr 2026 11:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0116B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:12:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDBA35AC55
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:11:59 +0000 (UTC)
X-FDA: 84613955958.11.69EB0DD
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5A6A1C0004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:11:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L6+uloqF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775142717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9DxMkkgytWR9am+1WQeQWH9Iy5mfAjxrdhUB29Lo7Q=;
	b=XPOfsBQjmmWJobDn9dgDBa++/aJRtLZ8z6Z230TTcX7HqYfDAVLOP7YYRscOw0bsbwr+gH
	vOvywHlqKOra5uHoUcv9CHQaDT5XxKBzo2m32FquidG25jV5g4dyP9wTU45UJiZ5UTP3gs
	7r91Y2mST7GMRjPyKtrRGv1T1lxyIF8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775142717; a=rsa-sha256;
	cv=pass;
	b=EbHyuB9AdofOApwC7zIw6M4Evu1tHAUz0Fuv8JGpPlPwcMMlquO4tGtM+1oVg3YiujKj5L
	WG/2xdVj5BKi/9cueg4a97YsCx0OjEyV/qtkKweKrMv3Fu43gC2Vto3te6RSwSQi9haTDN
	uHU7vxFSGrtYg/7Gufi0xx0PL8ei/8s=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L6+uloqF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50b6c45781aso752351cf.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 08:11:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775142717; cv=none;
        d=google.com; s=arc-20240605;
        b=KKJbBVUHKGVWoFP/RqdAOwkxBK47zZu0EqmYE5GoTCiEgdk+0XTR+8qCcd77orzg5N
         zmLtQrNnP7zCaP6trgH3qA7MQnPplYhTFOZckuhkdaVFMo27saHH5zf6Cyfaw5IAqIQq
         9B1oRZkUFUv44AbdWP8nQ5TPZPFYaoZ9qk/RzuVBMDdDhcQrvdz8NGuYbTFVxCz9A1nR
         xMItdoiR7DDl+ojjQOMOzKaf5rh/f9VPFjy5G/r8EWIxwJP/pTNAR2TPmG8KjbbUsh81
         a3e7i9SMxH/NMP+neTFA2ayZAKdBIHsuzuGznETOJERbBLpdG6Uh1qslOEb9zu568K90
         zEhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q9DxMkkgytWR9am+1WQeQWH9Iy5mfAjxrdhUB29Lo7Q=;
        fh=I5espc0u+9bQi4kNDug/cl8VMeHbd3qV0/IGT/9+l/o=;
        b=Ee4OQ+jlEn5ev6tNh7L3vs5QIP0YO/3eo4mfOlj/vC2/9oAjSVi2r6oBR1xtVhacOb
         S93L8Ptvozi/RdYqXpRbYLAA6V9i4CfVOZlCz8x3wL8VdU47E52sp8TiqB3jXH6qrsQ/
         3Sf735c+g7Jw7vVGBF+IEI+FknxxSAq30n5aMc6Cq8mZM52M01bmwprE0vYM6VKfM0OZ
         24oRPmx2BvPA6/KK5bN5uvVLieSzPiEKlX3wbHt6gVpDnNPPC5yCTHUWEtHd4Trr9SGW
         /Wxxq39M+eDyRiZkTf166Tmv5dE/YAGovyZKxFr3AzWX2T3m6ngYybuu3gOEeVW7j++y
         2rLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775142717; x=1775747517; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9DxMkkgytWR9am+1WQeQWH9Iy5mfAjxrdhUB29Lo7Q=;
        b=L6+uloqFbRR72TUQKL7nOXKRo3vxYuOlFvGY+mhXGtIah9bv8fx+24+7i0CHVwRVSW
         MtH64BqZ4Q1Vfz05zUWbDMOxctkn5/UBmyX5Jz8DKbJ7XDZWf7cPbUc7FReyQ2b+YYYB
         og9WwDKnnIYLZgC6HcsPcgjuiI2vZ0e76fU2DaRWzN9dfwBsE5Z0rsDRsdT4MXtNF0U7
         hUmDoLaMCQk+5wsuEYwl2nJcZOfEBSVkcKiYrW3bXOCkAEkMSpraxXAlcE+7KiIhMk4R
         kufpNTV1J+YPtLoqwXYN2AJjbidoBoJUzE0gcX9qj+LJ6kpktVvDFyRz/qjNSh9q1NfV
         +ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775142717; x=1775747517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q9DxMkkgytWR9am+1WQeQWH9Iy5mfAjxrdhUB29Lo7Q=;
        b=rszoq+W26gKYlJxQcLwIT+DVEKuuLUJuIdPHpYKZEccXZKLmCBAZudVHXKCG+GBTBF
         ZU7mkUvCYQ3rONsLhBjjwjjs+C2Seb7h/F23lMSaL50UT6iIuiGS1QSwSFFxzvXWGc3f
         5vBxlUXv+E2vgA7BScSvbWrUIXA9fUsjirFz/naXEkQKVQ73h1S8Dpnb2giJ+lDWHYU1
         lCYeE1iQL/Bs50cR7vpGzpjFAR41aeINe2X9hLGeildVqvbHIjQKMolEi5DOBQR+ii15
         1hM5AfordhYMS6NiID6tKN8vmmgCnEvPK2bhlBYp9OdtCbBXzLzBg2woxVRr8qu+T09p
         77NA==
X-Forwarded-Encrypted: i=1; AJvYcCV9UcrnLnDe02GBWgqrlpCWvXbBrNYlNaYkH4yfYHg0drt17WTYS6OOdv6uMiYNOVgdduxyAFxxmg==@kvack.org
X-Gm-Message-State: AOJu0YxcDwf0vbqfUtnv93n6F3SYJLMP2wpFkKcF0vNzkUx9sc2TB8IX
	wxuGH6FPSQYWOzAlKGzJeBaKlJP5yW+nKdc1Ma93qM3RAni1cEGAPKmoUbWfiRBiz4Tb4gjjwjB
	Edpn4HRh5wCJiJke+oBi3or5/ls24vKgBzD+ahOXy
X-Gm-Gg: ATEYQzwhzvitKTDwHJxLs8dbYIHyw7CbiwLvKcSDXePUuVSP2WtsLNEw5JMbpsnxsTN
	SGN15tMZCotcBUeKGD191hYs2fMmxZHHQWiTHw1R3Uy/j1lIVLw0tWn7VCix5GalqtEtJc++C/+
	ZlIDMZwxzmpsa0kbcSPfkViZlyL1P3qxSgS/IaEzai6M7+ldLaAyXN/23uPGa7fGKXZkNgl01qJ
	dpQx63k58Pkc5zs6gqHmLmzu7qUhpC7iBL2o80QtSNYnES4/vaqKIG4/v2vTLFQUR76Bzna6tym
	OEPvfs1/Ux1aYxCKgXh74BG8UdP40ajE5/tOtg==
X-Received: by 2002:ac8:6907:0:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-50d504ad8ddmr11393801cf.3.1775142716382; Thu, 02 Apr 2026
 08:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com> <20260327205457.604224-3-surenb@google.com>
 <5d90d998-9b8d-435c-b684-260600311797@lucifer.local> <CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
 <20260331112921.854d4f6cc793dba0972ee9f1@linux-foundation.org>
 <cf6975a6-336a-401b-b122-b9597b5710b7@lucifer.local> <CAJuCfpH2eomYbZ0DzKpkae5DKVF69aRsfXx3HzMfPc6cTT5fTg@mail.gmail.com>
 <495a4331-6575-4eb5-91a5-245ab0ad3637@lucifer.local>
In-Reply-To: <495a4331-6575-4eb5-91a5-245ab0ad3637@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 2 Apr 2026 08:11:44 -0700
X-Gm-Features: AQROBzDDBiQJXBj1ghnJLgm5n9vUtQ0-AtJqWv_KWozRinmr8YW0M_6ikqdSFOA
Message-ID: <CAJuCfpEn53AgKkjLBN2AeaHxxV8vHVj697Cb=Hb-U8LisNztxw@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm syscalls
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D5A6A1C0004
X-Stat-Signature: bs44xhwu5uqt531okbx9pabj4sxcnw6c
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775142717-972479
X-HE-Meta: U2FsdGVkX1+mqYvygQmjjt6FEtmsigz6FR8AtMg2EMhIMKFZ1fcPBErpjMuoHNIN2/IyCgaW+q9vyJc8DhNE59CkeppjgfGCVNMLNrZiny7OQySvYPOXNnXOTQ1NpxTXW7NyfVqevjTlWX4/fpuvPnSHgRFqOLeSeTtw14j+xgb4PmfmFHkAdPVldYG8uf1pYlAxxB7+AT8r1Xy+Jibi3BHqpF2Kwe32JuIwrIBhSCidXULepRERZbmdkfHdZkFBjgsWB4CshpiVQC8CNm6/KUD+clOKxIj4mS+Be8ZaUicrVuqkDxYHisN3A/dXYL3JdApUdcLo/V6RpREqgFOOUxACUrrWVOMgR4qK9K/U1qARx6LvN7/LjRpaAwkcrjFtFXZHEZGduh91OEl6NoD4+qAGE6IdUOjuErnYiKuD7owyS3iAvRmVYrM/Rpun0uM+1j2GnX9NyuZwV5AlQ+QnTxJ+l6ap58VMQKsu9N0HC3VEwbpQmeaqNKiNlr7eJdR+aLooSmATcHOfR/Flt62wBFpmTDJ4fya25NlmlUFQXngzq5WJOxjj/WniQsADyWY4nq7/H6L7ARgR80pHDa8CsHtUt820Wml9mxByupWWLwmBEPJioSVZXCodnUJ/IDjrWnKrvThruKj6Da7xPMsAjYOaFriV/JrHKnCUKMtfzLTRIjupHupW1a2rH+Y3NrfxqS5CHWcxtkUFHZA2pPbgHvu94ra+MBJfRTjtDlJs84aLMGgKmDHyB5Hr+v4S98YK3hY1iGykggR/H7zsoClvE8ey+985n1Dm+VuBKA5QEcELsECS/g7Sbdtem9ctOL66dyBJphxCcdW3HLit7Rv07qw/eo9Jkz59jSLk+h4JD/eWGoY6n1FK3YZbDp7+rNu9z8v027POytWVK/h/D8f1HV3J5k/v0nQJKD9b2sRD9FZkdqIkOUMLVl0Pdrm4ySAQFjqTPk65IS3/SJFVQlq
 Jlagr3V4
 dDVBkIBzCUD8us8ihLnu8R+XGUXYXoZhQCnGRWPf6z8gPhVIO+oEBnPPYN+8jReHnHVhRM6Wc9ODfPHV42DrfBorUVppROpnemps4Aqh/YJlOrs42uaEovtjmOuHoPuUIkFZ0vLAmSvxEi4GwUsHRC0GcOiBJgPRpAWEVhMw9LCdrHEYROBncMLV7HA2DgSxeMQUHrAPufJ6fKhmknkLjWsFzXKkwIc3CqecuHC3hRAnUQnn2Y47l0LAAgzSohTpV+VVsaieF643kUAbTL9cPDDQ+EVjOdMYF0iw2KJjDCIK6/eL0SbkbO4apAisSxo0YQF/qq87j/UVmHKHDwl73iznF+UOj4yAa5/N86tiHNEf1JCyD4eM7oZdoG43zigrUkHYmAIj1iNFMyaNPy7FreguLmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 6:19=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kernel=
.org> wrote:
>
> On Tue, Mar 31, 2026 at 01:14:51PM -0700, Suren Baghdasaryan wrote:
> > On Tue, Mar 31, 2026 at 11:47=E2=80=AFAM Lorenzo Stoakes (Oracle)
> > <ljs@kernel.org> wrote:
> > >
> > > On Tue, Mar 31, 2026 at 11:29:21AM -0700, Andrew Morton wrote:
> > > > On Tue, 31 Mar 2026 08:01:11 -0700 Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> > > >
> > > > > > Instead? That is, assuming we really need to care about this at=
 all.
> > > > > >
> > > > > > But I think I don't like this change at all?
> > > > >
> > > > > Yeah, this was the part I wasn't sure if it's worth adding. With =
your
> > > > > vote confirming my scepticism I'll go ahead and remove the parts =
I
> > > > > added to avoid extra vma_start_write_killable() call (3 instances=
 in
> > > > > all) and will post v7.
> > > >
> > > > Thanks.  I'll remove v6 from mm.git and shall await Lorenzo's advic=
e on
> > > > v7.
> > > >
> > >
> > > Ack, if we just drop the problematic bits we might still be fine for =
7.1 :)
> >
> > Let's get your cleanup first and then see where we are. I also hate
> > the way I have to report a fake error code, so with that cleanup the
> > patchset should be much nicer.
>
> Ack, yeah it's horrid, + _my fault_ :)

No worries, I can wait.

>
> I can put something together now perhaps that can potentially be queued u=
p for
> 7.2 at 7.1-rc1.

Thanks! That would be appreciated.

>
> Cheers, Lorenzo

