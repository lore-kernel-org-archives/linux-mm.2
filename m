Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FCCF013FA
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4C36B03A3; Mon, 16 Mar 2026 17:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770156B03A4; Mon, 16 Mar 2026 17:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648306B03A5; Mon, 16 Mar 2026 17:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 519156B03A3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:28:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2AC61B8598
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:28:01 +0000 (UTC)
X-FDA: 84553213962.25.678473A
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB47240006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:27:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EauHyjRm;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773696480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Iir2LQfcUjTZ2eJjGsYz/FMhoUJsyFzxnYmcJfs/SY=;
	b=TNLnEFh4nEpxPPxfgwf475W7aWjwSYe2K1D414VOlev/vADG6VoYeNhioqrC4XRIxHCLhE
	cUNpVOxLHa3hEi7Zdr0hTYqz6bI6WCrngoYxBD02EHvtSc6sYWbAisHoCrgeXs2VwUwn94
	aA11IwhYyzFBaPDcr+kqgpTGTUrlF1M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773696480; a=rsa-sha256;
	cv=pass;
	b=zv9ODFD+DVRxejZga++fwcF+rN07joLwNQxzmUKgDFrd/YAoehNIJBYQG71DuhRbSECsLd
	yn14qxAOr2dCMp+mZ/Re3HVV2SHXW+txFPJDd/br6zoIE13QWtKKz/bm7hh6UnhlweS31+
	zSbs2hN1aYL83gDlEKZo3TRM9pgOzFE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EauHyjRm;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50906a98ffeso204611cf.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773696479; cv=none;
        d=google.com; s=arc-20240605;
        b=KFhkd3PcbbMI1LUtj6IQj8GPBW3ZNyeIcP/u9kciNQe6D+S3IntBpwT8rdicbecRxI
         f2RwUCcTGTPYYo/hXAYsUdjxoSW0dWZCqVualReWp7SM1cu1ID6RIokTtyiSGkDYH9D5
         AKSF5VwLjBTAwm/UTAznRws/7X0dtWS/WUsO2tSQbRyFM0a2O9MP86QvxoFoRCfoup77
         T0+ABH3oMn4xDl7fnX55boUuqd3EL7XjfRusF6VnzKPM5JMBqktav4EgLHevzvTuTE64
         o9WNni6xC4GWr2K4BEav7+aG02plB2refMp3oa/M2GObS3B6wUkaj2voO8SVEGyKIKq6
         03Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4Iir2LQfcUjTZ2eJjGsYz/FMhoUJsyFzxnYmcJfs/SY=;
        fh=mZg84UG4cp2MbvU2J4lfNMu77kjX3YCRStIwtsvbqgQ=;
        b=VpSZ7CDIcoNbQHvIlDAiYPT2FozeXtuCLFA593AFMpTVrBl+CKMzVckLcMi3sUOD92
         CztHifDYBH67nfTvF/MIdq18bmqkadyIp28SStboxAhPOXsoe8ZZgGN/K+2QzBn4Vz+R
         JfPMQ/4zCdfqGgoH3c+/2wazBzzM38Jmn68ml9eIjPotBjeJwPTC0jYZPn9Y5ujdWbsx
         U38e4gg2JTwl689RT1JSnWvXp9pHf21w5sDs+p8NA77V35ZBkisIIO/KyyyaWEVVJe28
         IrDTb2JStHt4Sx0PIwypY3rFSyRhhgAwPZBryJYXp/OLStrfknosq89WQyXvLaFOTN1Y
         Ya3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773696479; x=1774301279; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Iir2LQfcUjTZ2eJjGsYz/FMhoUJsyFzxnYmcJfs/SY=;
        b=EauHyjRmWb2GV7P1IA9xik3Ne/8m1oGyp7aNcA1sYbFoeihHUxXfU59sKU7jTq+gGq
         CdcKW84GhLDJmcpPMr42u/KzJsLzFIBm3MfIOBwEMKpoATlhTgl1/FKICUFq0C/An8uV
         wqfUzXyntQHeZEfgkkTxgNwgDSRScb0moMj6T+LloRqklRYP/ZWBClXyHHq7Cuhp5Joo
         1FuYd8dDMPuEfqC3yhuP7sp9xSN/sq0SfWItBz7FKdEOypoJaUo+mAYs7h/v+1Bzbh/P
         Y2A01Zl5dMvXGiFPwf/CvU3WM25AZaD4Z5h2jEeOZAw//QsUk0i1SZyg8OV7deJqp40K
         Zw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773696479; x=1774301279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Iir2LQfcUjTZ2eJjGsYz/FMhoUJsyFzxnYmcJfs/SY=;
        b=XvLZv2sSem3osIPtx8PtGhuyTJqSDD5kLBy8jfH+7rHcTTOz1MjGVVoTRqVNuTIPct
         ACK7smmoSFbMjcc8b7ObR3X0l/q19YZ3WPZiOfQZ7UeMzyEkAOHW9f+h94TFg1tmI0lh
         qx/TNYuMS0RNAHvU+8h2JFYxr0htE0nAPkCJleZVzpiYMuPHPZqrHPDxeQg8AEDYw4EU
         y92KeuKRdNDgN+BRSgLNmwI/ycM3UB8xOl4YKAcW61+BUVoPP9dUHIJ+IaL8n2U/hkoY
         +C+oswOzRa2h8YWjomrNBoJXrD/nP6G8CIH8DAon7VQchOphIb2+hKF4IcDx66HBfWd+
         ZjQA==
X-Forwarded-Encrypted: i=1; AJvYcCUXs3rw2kzL/Pofim25Ekoe0x1lKpellA8iVBq7QBmHsb9DMhkOFIiB9CIa9m0mTVZnptQSmee6uA==@kvack.org
X-Gm-Message-State: AOJu0Yx7CJ75Ov8xgwrqxRt4WPvFnSEp6Rye1IWmG1l0524RvhdZnBRb
	JgSR9qLBBzGC4tusF6cYWhP/AnCVB0bmHIgqHnMPbMtw6SAXEt3CiW4MII11YmQJnXP8gxBK8K8
	B0s2e5y7junQW1tlTxB0KsiujT/tSMTyN8jFu8OCW
X-Gm-Gg: ATEYQzxScS0CZ2ejdwQD6vKp5HVXY7ClsJXK7xNpxAIuVH/iBAFml0+UgmQ6txRzOpf
	JOlq5vG8TYeDhuIUkepIFaMT1DkKPKMkZLRh+46YEIBwYdDmqbYFQDQPT0TIrC+uTQo8gXwCb+Z
	JyHnThlRxe3zxZP8ZdFrFIBLS1nIHMIc71+FuJ4Sk2Z+0gTMt6xCtujnReGOB9VRJTd7OqI7OKD
	8hLZQNWglQypj7r5xkYY9xVNprE75pXqbO5T9SM6YABt8SS29vEwKK3GE11OGYPQS3ewc6jJro3
	Q4Vd7g==
X-Received: by 2002:a05:622a:10:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-5099ac7560bmr1658161cf.3.1773696478201; Mon, 16 Mar 2026
 14:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
 <CAJuCfpEsCrFEYNkkTfRLGojGOYAAx1=WOojOhpBb_=WZBr6bnQ@mail.gmail.com> <74274c04-58f4-46d8-8d14-295bd06541e1@lucifer.local>
In-Reply-To: <74274c04-58f4-46d8-8d14-295bd06541e1@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 14:27:47 -0700
X-Gm-Features: AaiRm50BCJkZ46wjp5F9aYJKHCjSEDRS1F0qSDafBcssTKayI36Z8OmQq53lMLQ
Message-ID: <CAJuCfpGouG5F4-jsfGC4Pt+_oRojqmAHDMVHH3Y=j6cgdbzt+g@mail.gmail.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r69zmue35g4yntfbcyg6rhhs1tw9durd
X-Rspam-User: 
X-Rspamd-Queue-Id: EB47240006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773696479-337702
X-HE-Meta: U2FsdGVkX19BDVfdqbYbhIpHrH/6j02eiRFi3U7ZLMYC9wFKNrfMUrO8RlMBbYy37vNmC3amDyrhzFES9VLG2qB4AfkXKZcu1w5Eidgkul5weL+iEmrdMVu5MPqx6TLrkj5ZPMomrvuFSdwgpvXT6VoWWv9BAfzD/+khbr0JYx7saiDtPHcFmv8MXEZyblgLedjMwdneLqAbpZN61VwkD5ZVPjE4eK/FJnDlS6+FAKpHLZ7sA0QDRrLFEXLSB2lYE8IlgAZwGNf6jJMPhuGkDwPyDQO87AHsT8cz7xLe5QRMk2q5AgqqzgN2K1c2+xxESchPkrBdrhoTCQpyzele/wG77lrJ2TP3SzCoYLJhB18VYr/XeFI1z6fuO7K/aOXbcQwKvwi3T+jAVNFUvm+8mWqpIl7/Kx7v+QY8skGnOZ/lKx+Iogx4XmHTKFDbBR1W/oyJp1QB1hXbL+w/AbijfHjppw/PwvmnElHWnbZjifNHoyFqYjpwkNAMNc+gy1OU90VS39h+m9M9m4fo3mRhvMN0QQoDaV/C+0z8Laafj1ky208QcVPu/RIoFD/YvzhYJyx4G5vVLS43of5VZTK5bbEBCeiWVRtMwb+V+K2MAVK+xH0sLCn/nGG8363yAaPXtAOPPYxXW//BZwu/8Kxv3tMhvs9DEIZi4KgUTxJSjKMk1FtcvDYgwwyU6/+cpaRuafhEiFV3PGMUFH2M3bkp9hJV7aQhKHzlvkp1h/haY1hP3cimmdLvufwkBE3Mvgn9/RiGvyuJgF0jIPFPWmgsNpPZFz2En2mfjboMrSZYJcp0NTTYzqeNlK9x3EPBoVNFaAI/UcnpTToXxhpmmNOGKwajWe4Sa82wJYWP025LdbWrNcc0tTTdmDiQ42rk/zhCdymXNv7Xk55xya5Vdt0m3dT62JDM8EJIR4atTr4A9KH2gsObU9ShA1YPoriVtOXq4QdqAvu5RgxbjUP11j0
 mRp+4pie
 WLSoM6YYhgNVq+EQRfuTvS3nPJp/kZFCxAqt6MqWjmahM1zUcp9MHVl/hLxms6EHOrEULmtaqt4LR7rOKzc95fYiZNxgYRnW4BgXly/83Beqfv+7gT+W5FAUkRXykYCmnuaLZ0+pUTLOHF5+Hpbyz3BWrxR1YPU8GPRL820sWe140OokNrUy3Ui+ZLujRHM1Xq2Q21tCnwjIpahd2HNaCeNt7FUP+V/i3ItcvylUfr0DlSEiJYGU4exAIk0x+yyL3CgyG9pfdHZkithKBdcF0NhogbPLD17ThLEgSlQeoOEq46ygY3XKmHYtKK8nuUKuWXpKwPpdnN3tFmzFicLB+89iM98kKxqxwV4Uz+bVH3h3tQ3fw91cBQ+WAdP3PJ9nWoAzr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 7:44=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Sun, Mar 15, 2026 at 03:56:54PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > Rather than passing arbitrary fields, pass an mmap_action field direc=
tly to
> > > mmap prepare and complete helpers to put all the action-specific logi=
c in
> > > the function actually doing the work.
> > >
> > > Additionally, allow mmap prepare functions to return an error so we c=
an
> > > error out as soon as possible if there is something logically incorre=
ct in
> > > the input.
> > >
> > > Update remap_pfn_range_prepare() to properly check the input range fo=
r the
> > > CoW case.
> >
> > By "properly check" do you mean the replacement of desc->start and
> > desc->end with action->remap.start and action->remap.start +
> > action->remap.size when calling get_remap_pgoff() from
> > remap_pfn_range_prepare()?
> >
> > >
> > > While we're here, make remap_pfn_range_prepare_vma() a little neater,=
 and
> > > pass mmap_action directly to call_action_complete().
> > >
> > > Then, update compat_vma_mmap() to perform its logic directly, as
> > > __compat_vma_map() is not used by anything so we don't need to export=
 it.
> >
> > Not directly related to this patch but while reviewing, I was also
> > checking vma locking rules in this mmap_prepare() + mmap() sequence
> > and I noticed that the new VMA flag modification functions like
> > vma_set_flags_mask() do assert vma_assert_locked(vma). It would be
>
> Do NOT? :)

Right :)

>
> I don't think it'd work, because in some cases you're setting flags for a
> VMA that is not yet inserted in the tree, etc.

Ah, I see. So, there won't be something similar to vm_flags_init()
that sets vm_flags before the VMA is added to the tree...
I'm a bit paranoid about catching the cases when a VMA is changed
without being locked. Maybe we can add such assert if
vma_is_attached() later. But this is really out of scope of this
patchset, so let's discuss it later. Sorry for the noise.

>
> I don't think it's hugely useful to split out these functions in some way
> in the way the vm_flags_*() stuff is split so we assert sometimes, not
> others.
>
> I'd rather keep this as clean an interface as possible.

Ack.

>
> In any case the majority of cases where flags are being set are not on th=
e
> VMA, so really only core code, that would likely otherwise assert when it
> needs to, would already be asserting.
>
> The cases where drivers will do it, all of them will be using
> vma_desc_set_flags() etc.

That was my biggest worry as drivers might do some VMA modifications
without proper locking but you are right, with mmap_prepare() that
stops being a problem.

>
> > useful to add these but as a separate change. I will add it to my todo
> > list.
>
> So I don't think it'd be generally useful at this time.
>
> >
> > >
> > > Also update compat_vma_mmap() to use vfs_mmap_prepare() rather than c=
alling
> > > the mmap_prepare op directly.
> > >
> > > Finally, update the VMA userland tests to reflect the changes.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  include/linux/fs.h                |   2 -
> > >  include/linux/mm.h                |   8 +--
> > >  mm/internal.h                     |  28 +++++---
> > >  mm/memory.c                       |  45 +++++++-----
> > >  mm/util.c                         | 112 +++++++++++++---------------=
--
> > >  mm/vma.c                          |  21 +++---
> > >  tools/testing/vma/include/dup.h   |   9 ++-
> > >  tools/testing/vma/include/stubs.h |   9 +--
> > >  8 files changed, 123 insertions(+), 111 deletions(-)
> > >
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index 8b3dd145b25e..a2628a12bd2b 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -2058,8 +2058,6 @@ static inline bool can_mmap_file(struct file *f=
ile)
> > >         return true;
> > >  }
> > >
> > > -int __compat_vma_mmap(const struct file_operations *f_op,
> > > -               struct file *file, struct vm_area_struct *vma);
> > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
> > >
> > >  static inline int vfs_mmap(struct file *file, struct vm_area_struct =
*vma)
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 4c4fd55fc823..cc5960a84382 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -4116,10 +4116,10 @@ static inline void mmap_action_ioremap_full(s=
truct vm_area_desc *desc,
> > >         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_si=
ze(desc));
> > >  }
> > >
> > > -void mmap_action_prepare(struct mmap_action *action,
> > > -                        struct vm_area_desc *desc);
> > > -int mmap_action_complete(struct mmap_action *action,
> > > -                        struct vm_area_struct *vma);
> > > +int mmap_action_prepare(struct vm_area_desc *desc,
> > > +                       struct mmap_action *action);
> > > +int mmap_action_complete(struct vm_area_struct *vma,
> > > +                        struct mmap_action *action);
> > >
> > >  /* Look up the first VMA which exactly match the interval vm_start .=
.. vm_end */
> > >  static inline struct vm_area_struct *find_exact_vma(struct mm_struct=
 *mm,
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 95b583e7e4f7..7bfa85b5e78b 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -1775,26 +1775,32 @@ int walk_page_range_debug(struct mm_struct *m=
m, unsigned long start,
> > >  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
> > >  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
> > >
> > > -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned lon=
g pfn);
> > > -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned lo=
ng addr,
> > > -               unsigned long pfn, unsigned long size, pgprot_t pgpro=
t);
> > > +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> > > +                           struct mmap_action *action);
> > > +int remap_pfn_range_complete(struct vm_area_struct *vma,
> > > +                            struct mmap_action *action);
> > >
> > > -static inline void io_remap_pfn_range_prepare(struct vm_area_desc *d=
esc,
> > > -               unsigned long orig_pfn, unsigned long size)
> > > +static inline int io_remap_pfn_range_prepare(struct vm_area_desc *de=
sc,
> > > +                                            struct mmap_action *acti=
on)
> > >  {
> > > +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> > > +       const unsigned long size =3D action->remap.size;
> > >         const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, =
size);
> > >
> > > -       return remap_pfn_range_prepare(desc, pfn);
> > > +       action->remap.start_pfn =3D pfn;
> > > +       return remap_pfn_range_prepare(desc, action);
> > >  }
> > >
> > >  static inline int io_remap_pfn_range_complete(struct vm_area_struct =
*vma,
> > > -               unsigned long addr, unsigned long orig_pfn, unsigned =
long size,
> > > -               pgprot_t orig_prot)
> > > +                                             struct mmap_action *act=
ion)
> > >  {
> > > -       const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, =
size);
> > > -       const pgprot_t prot =3D pgprot_decrypted(orig_prot);
> > > +       const unsigned long size =3D action->remap.size;
> > > +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> > > +       const pgprot_t orig_prot =3D vma->vm_page_prot;
> > >
> > > -       return remap_pfn_range_complete(vma, addr, pfn, size, prot);
> > > +       action->remap.pgprot =3D pgprot_decrypted(orig_prot);
> > > +       action->remap.start_pfn  =3D io_remap_pfn_range_pfn(orig_pfn,=
 size);
> > > +       return remap_pfn_range_complete(vma, action);
> > >  }
> > >
> > >  #ifdef CONFIG_MMU_NOTIFIER
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 6aa0ea4af1fc..364fa8a45360 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -3099,26 +3099,34 @@ static int do_remap_pfn_range(struct vm_area_=
struct *vma, unsigned long addr,
> > >  }
> > >  #endif
> > >
> > > -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned lon=
g pfn)
> > > +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> > > +                           struct mmap_action *action)
> > >  {
> > > -       /*
> > > -        * We set addr=3DVMA start, end=3DVMA end here, so this won't=
 fail, but we
> > > -        * check it again on complete and will fail there if specifie=
d addr is
> > > -        * invalid.
> > > -        */
> > > -       get_remap_pgoff(vma_desc_is_cow_mapping(desc), desc->start, d=
esc->end,
> > > -                       desc->start, desc->end, pfn, &desc->pgoff);
> > > +       const unsigned long start =3D action->remap.start;
> > > +       const unsigned long end =3D start + action->remap.size;
> > > +       const unsigned long pfn =3D action->remap.start_pfn;
> > > +       const bool is_cow =3D vma_desc_is_cow_mapping(desc);
> >
> > I was trying to figure out who sets action->remap.start and
> > action->remap.size and if they somehow guaranteed to be always equal
> > to desc->start and (desc->end - desc->start). My understanding is that
> > action->remap.start and action->remap.size are set by
> > f_op->mmap_prepare() but I'm not sure if they are always the same as
> > desc->start and (desc->end - desc->start) and if so, how do we enforce
> > that.
>
> They are set, and they might not always be the same, because the existing
> implementation does not set them the same.
>
> Once I've completed the change, I can check to ensure that nobody is doin=
g
> anything crazy with this.
>
> I also plan to add specific discontiguous range handlers to handle the
> cases where drivers wish to map that way.
>
> In fact, I already implemented it (and DMA coherent stuff) but stripped i=
t
> out the series for now for time (the original series was ~27 patches :) a=
s
> I want to test that more etc.
>
> Users have access to mmap_action_remap_full() to specify that they want t=
o
> remap the full range.

Got it. IOW [action->remap.start,
action->remap.start+action->remap.size] should be equal or contained
within [desc->start, desc->end] range.

>
> >
> > > +       int err;
> > > +
> > > +       err =3D get_remap_pgoff(is_cow, start, end, desc->start, desc=
->end, pfn,
> > > +                             &desc->pgoff);
> > > +       if (err)
> > > +               return err;
> > > +
> > >         vma_desc_set_flags_mask(desc, VMA_REMAP_FLAGS);
> > > +       return 0;
> > >  }
> > >
> > > -static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma, u=
nsigned long addr,
> > > -               unsigned long pfn, unsigned long size)
> > > +static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
> > > +                                      unsigned long addr, unsigned l=
ong pfn,
> > > +                                      unsigned long size)
> > >  {
> > > -       unsigned long end =3D addr + PAGE_ALIGN(size);
> > > +       const unsigned long end =3D addr + PAGE_ALIGN(size);
> > > +       const bool is_cow =3D is_cow_mapping(vma->vm_flags);
> > >         int err;
> > >
> > > -       err =3D get_remap_pgoff(is_cow_mapping(vma->vm_flags), addr, =
end,
> > > -                             vma->vm_start, vma->vm_end, pfn, &vma->=
vm_pgoff);
> > > +       err =3D get_remap_pgoff(is_cow, addr, end, vma->vm_start, vma=
->vm_end,
> > > +                             pfn, &vma->vm_pgoff);
> > >         if (err)
> > >                 return err;
> > >
> > > @@ -3151,10 +3159,15 @@ int remap_pfn_range(struct vm_area_struct *vm=
a, unsigned long addr,
> > >  }
> > >  EXPORT_SYMBOL(remap_pfn_range);
> > >
> > > -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned lo=
ng addr,
> > > -               unsigned long pfn, unsigned long size, pgprot_t prot)
> > > +int remap_pfn_range_complete(struct vm_area_struct *vma,
> > > +                            struct mmap_action *action)
> > >  {
> > > -       return do_remap_pfn_range(vma, addr, pfn, size, prot);
> > > +       const unsigned long start =3D action->remap.start;
> > > +       const unsigned long pfn =3D action->remap.start_pfn;
> > > +       const unsigned long size =3D action->remap.size;
> > > +       const pgprot_t prot =3D action->remap.pgprot;
> > > +
> > > +       return do_remap_pfn_range(vma, start, pfn, size, prot);
> > >  }
> > >
> > >  /**
> > > diff --git a/mm/util.c b/mm/util.c
> > > index ce7ae80047cf..dba1191725b6 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -1163,43 +1163,6 @@ void flush_dcache_folio(struct folio *folio)
> > >  EXPORT_SYMBOL(flush_dcache_folio);
> > >  #endif
> > >
> > > -/**
> > > - * __compat_vma_mmap() - See description for compat_vma_mmap()
> > > - * for details. This is the same operation, only with a specific fil=
e operations
> > > - * struct which may or may not be the same as vma->vm_file->f_op.
> > > - * @f_op: The file operations whose .mmap_prepare() hook is specifie=
d.
> > > - * @file: The file which backs or will back the mapping.
> > > - * @vma: The VMA to apply the .mmap_prepare() hook to.
> > > - * Returns: 0 on success or error.
> > > - */
> > > -int __compat_vma_mmap(const struct file_operations *f_op,
> > > -               struct file *file, struct vm_area_struct *vma)
> > > -{
> > > -       struct vm_area_desc desc =3D {
> > > -               .mm =3D vma->vm_mm,
> > > -               .file =3D file,
> > > -               .start =3D vma->vm_start,
> > > -               .end =3D vma->vm_end,
> > > -
> > > -               .pgoff =3D vma->vm_pgoff,
> > > -               .vm_file =3D vma->vm_file,
> > > -               .vma_flags =3D vma->flags,
> > > -               .page_prot =3D vma->vm_page_prot,
> > > -
> > > -               .action.type =3D MMAP_NOTHING, /* Default */
> > > -       };
> > > -       int err;
> > > -
> > > -       err =3D f_op->mmap_prepare(&desc);
> > > -       if (err)
> > > -               return err;
> > > -
> > > -       mmap_action_prepare(&desc.action, &desc);
> > > -       set_vma_from_desc(vma, &desc);
> > > -       return mmap_action_complete(&desc.action, vma);
> > > -}
> > > -EXPORT_SYMBOL(__compat_vma_mmap);
> > > -
> > >  /**
> > >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
> > >   * existing VMA and execute any requested actions.
> > > @@ -1228,7 +1191,31 @@ EXPORT_SYMBOL(__compat_vma_mmap);
> > >   */
> > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> > >  {
> > > -       return __compat_vma_mmap(file->f_op, file, vma);
> > > +       struct vm_area_desc desc =3D {
> > > +               .mm =3D vma->vm_mm,
> > > +               .file =3D file,
> > > +               .start =3D vma->vm_start,
> > > +               .end =3D vma->vm_end,
> > > +
> > > +               .pgoff =3D vma->vm_pgoff,
> > > +               .vm_file =3D vma->vm_file,
> > > +               .vma_flags =3D vma->flags,
> > > +               .page_prot =3D vma->vm_page_prot,
> > > +
> > > +               .action.type =3D MMAP_NOTHING, /* Default */
> > > +       };
> > > +       int err;
> > > +
> > > +       err =3D vfs_mmap_prepare(file, &desc);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       err =3D mmap_action_prepare(&desc, &desc.action);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       set_vma_from_desc(vma, &desc);
> > > +       return mmap_action_complete(vma, &desc.action);
> > >  }
> > >  EXPORT_SYMBOL(compat_vma_mmap);
> > >
> > > @@ -1320,8 +1307,8 @@ void snapshot_page(struct page_snapshot *ps, co=
nst struct page *page)
> > >         }
> > >  }
> > >
> > > -static int mmap_action_finish(struct mmap_action *action,
> > > -               const struct vm_area_struct *vma, int err)
> > > +static int mmap_action_finish(struct vm_area_struct *vma,
> > > +                             struct mmap_action *action, int err)
> > >  {
> > >         /*
> > >          * If an error occurs, unmap the VMA altogether and return an=
 error. We
> > > @@ -1355,35 +1342,36 @@ static int mmap_action_finish(struct mmap_act=
ion *action,
> > >   * action which need to be performed.
> > >   * @desc: The VMA descriptor to prepare for @action.
> > >   * @action: The action to perform.
> > > + *
> > > + * Returns: 0 on success, otherwise error.
> > >   */
> > > -void mmap_action_prepare(struct mmap_action *action,
> > > -                        struct vm_area_desc *desc)
> > > +int mmap_action_prepare(struct vm_area_desc *desc,
> > > +                       struct mmap_action *action)
> >
> > Any reason you are swapping the arguments?
>
> For consistency with other functions to be added.
>
> > It also looks like we always call mmap_action_prepare() with action =3D=
=3D
> > desc->action, like this: mmap_action_prepare(&desc.action, &desc). Why
> > don't we eliminate the action parameter altogether and use desc.action
> > from inside the function?
>
> I think in previous iterations I thought about overriding one action with
> another and wanted to keep that flexibility, but then have never done tha=
t
> in practice.
>
> So probably I can just drop that yes, will try it on respin.

Thanks.

>
> >
> > > +
> >
> > extra new line.
>
> Ack will fix

Thanks.

>
> >
> > >  {
> > >         switch (action->type) {
> > >         case MMAP_NOTHING:
> > > -               break;
> > > +               return 0;
> > >         case MMAP_REMAP_PFN:
> > > -               remap_pfn_range_prepare(desc, action->remap.start_pfn=
);
> > > -               break;
> > > +               return remap_pfn_range_prepare(desc, action);
> > >         case MMAP_IO_REMAP_PFN:
> > > -               io_remap_pfn_range_prepare(desc, action->remap.start_=
pfn,
> > > -                                          action->remap.size);
> > > -               break;
> > > +               return io_remap_pfn_range_prepare(desc, action);
> > >         }
> > >  }
> > >  EXPORT_SYMBOL(mmap_action_prepare);
> > >
> > >  /**
> > >   * mmap_action_complete - Execute VMA descriptor action.
> > > - * @action: The action to perform.
> > >   * @vma: The VMA to perform the action upon.
> > > + * @action: The action to perform.
> > >   *
>
> > >   * Similar to mmap_action_prepare().
> > >   *
> > >   * Return: 0 on success, or error, at which point the VMA will be un=
mapped.
> > >   */
> > > -int mmap_action_complete(struct mmap_action *action,
> > > -                        struct vm_area_struct *vma)
> > > +int mmap_action_complete(struct vm_area_struct *vma,
> > > +                        struct mmap_action *action)
> > > +
> > >  {
> > >         int err =3D 0;
> > >
> > > @@ -1391,23 +1379,19 @@ int mmap_action_complete(struct mmap_action *=
action,
> > >         case MMAP_NOTHING:
> > >                 break;
> > >         case MMAP_REMAP_PFN:
> > > -               err =3D remap_pfn_range_complete(vma, action->remap.s=
tart,
> > > -                               action->remap.start_pfn, action->rema=
p.size,
> > > -                               action->remap.pgprot);
> > > +               err =3D remap_pfn_range_complete(vma, action);
> > >                 break;
> > >         case MMAP_IO_REMAP_PFN:
> > > -               err =3D io_remap_pfn_range_complete(vma, action->rema=
p.start,
> > > -                               action->remap.start_pfn, action->rema=
p.size,
> > > -                               action->remap.pgprot);
> > > +               err =3D io_remap_pfn_range_complete(vma, action);
> > >                 break;
> > >         }
> > >
> > > -       return mmap_action_finish(action, vma, err);
> > > +       return mmap_action_finish(vma, action, err);
> > >  }
> > >  EXPORT_SYMBOL(mmap_action_complete);
> > >  #else
> > > -void mmap_action_prepare(struct mmap_action *action,
> > > -                       struct vm_area_desc *desc)
> > > +int mmap_action_prepare(struct vm_area_desc *desc,
> > > +                       struct mmap_action *action)
> > >  {
> > >         switch (action->type) {
> > >         case MMAP_NOTHING:
> > > @@ -1417,11 +1401,13 @@ void mmap_action_prepare(struct mmap_action *=
action,
> > >                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
> > >                 break;
> > >         }
> > > +
> > > +       return 0;
> > >  }
> > >  EXPORT_SYMBOL(mmap_action_prepare);
> > >
> > > -int mmap_action_complete(struct mmap_action *action,
> > > -                       struct vm_area_struct *vma)
> > > +int mmap_action_complete(struct vm_area_struct *vma,
> > > +                        struct mmap_action *action)
> > >  {
> > >         int err =3D 0;
> > >
> > > @@ -1436,7 +1422,7 @@ int mmap_action_complete(struct mmap_action *ac=
tion,
> > >                 break;
> > >         }
> > >
> > > -       return mmap_action_finish(action, vma, err);
> > > +       return mmap_action_finish(vma, action, err);
> > >  }
> > >  EXPORT_SYMBOL(mmap_action_complete);
> > >  #endif
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index be64f781a3aa..054cf1d262fb 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -2613,15 +2613,19 @@ static void __mmap_complete(struct mmap_state=
 *map, struct vm_area_struct *vma)
> > >         vma_set_page_prot(vma);
> > >  }
> > >
> > > -static void call_action_prepare(struct mmap_state *map,
> > > -                               struct vm_area_desc *desc)
> > > +static int call_action_prepare(struct mmap_state *map,
> > > +                              struct vm_area_desc *desc)
> > >  {
> > >         struct mmap_action *action =3D &desc->action;
> > > +       int err;
> > >
> > > -       mmap_action_prepare(action, desc);
> > > +       err =3D mmap_action_prepare(desc, action);
> > > +       if (err)
> > > +               return err;
> > >
> > >         if (action->hide_from_rmap_until_complete)
> > >                 map->hold_file_rmap_lock =3D true;
> > > +       return 0;
> > >  }
> > >
> > >  /*
> > > @@ -2645,7 +2649,9 @@ static int call_mmap_prepare(struct mmap_state =
*map,
> > >         if (err)
> > >                 return err;
> > >
> > > -       call_action_prepare(map, desc);
> > > +       err =3D call_action_prepare(map, desc);
> > > +       if (err)
> > > +               return err;
> > >
> > >         /* Update fields permitted to be changed. */
> > >         map->pgoff =3D desc->pgoff;
> > > @@ -2700,13 +2706,12 @@ static bool can_set_ksm_flags_early(struct mm=
ap_state *map)
> > >  }
> > >
> > >  static int call_action_complete(struct mmap_state *map,
> > > -                               struct vm_area_desc *desc,
> > > +                               struct mmap_action *action,
> > >                                 struct vm_area_struct *vma)
> > >  {
> > > -       struct mmap_action *action =3D &desc->action;
> > >         int ret;
> > >
> > > -       ret =3D mmap_action_complete(action, vma);
> > > +       ret =3D mmap_action_complete(vma, action);
> > >
> > >         /* If we held the file rmap we need to release it. */
> > >         if (map->hold_file_rmap_lock) {
> > > @@ -2768,7 +2773,7 @@ static unsigned long __mmap_region(struct file =
*file, unsigned long addr,
> > >         __mmap_complete(&map, vma);
> > >
> > >         if (have_mmap_prepare && allocated_new) {
> > > -               error =3D call_action_complete(&map, &desc, vma);
> > > +               error =3D call_action_complete(&map, &desc.action, vm=
a);
> > >
> > >                 if (error)
> > >                         return error;
> > > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/incl=
ude/dup.h
> > > index 5eb313beb43d..908beb263307 100644
> > > --- a/tools/testing/vma/include/dup.h
> > > +++ b/tools/testing/vma/include/dup.h
> > > @@ -1106,7 +1106,7 @@ static inline int __compat_vma_mmap(const struc=
t file_operations *f_op,
> > >
> > >                 .pgoff =3D vma->vm_pgoff,
> > >                 .vm_file =3D vma->vm_file,
> > > -               .vm_flags =3D vma->vm_flags,
> > > +               .vma_flags =3D vma->flags,
> > >                 .page_prot =3D vma->vm_page_prot,
> > >
> > >                 .action.type =3D MMAP_NOTHING, /* Default */
> > > @@ -1117,9 +1117,12 @@ static inline int __compat_vma_mmap(const stru=
ct file_operations *f_op,
> > >         if (err)
> > >                 return err;
> > >
> > > -       mmap_action_prepare(&desc.action, &desc);
> > > +       err =3D mmap_action_prepare(&desc, &desc.action);
> > > +       if (err)
> > > +               return err;
> > > +
> > >         set_vma_from_desc(vma, &desc);
> > > -       return mmap_action_complete(&desc.action, vma);
> > > +       return mmap_action_complete(vma, &desc.action);
> > >  }
> > >
> > >  static inline int compat_vma_mmap(struct file *file,
> > > diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/in=
clude/stubs.h
> > > index 947a3a0c2566..76c4b668bc62 100644
> > > --- a/tools/testing/vma/include/stubs.h
> > > +++ b/tools/testing/vma/include/stubs.h
> > > @@ -81,13 +81,14 @@ static inline void free_anon_vma_name(struct vm_a=
rea_struct *vma)
> > >  {
> > >  }
> > >
> > > -static inline void mmap_action_prepare(struct mmap_action *action,
> > > -                                          struct vm_area_desc *desc)
> > > +static inline int mmap_action_prepare(struct vm_area_desc *desc,
> > > +                                     struct mmap_action *action)
> > >  {
> > > +       return 0;
> > >  }
> > >
> > > -static inline int mmap_action_complete(struct mmap_action *action,
> > > -                                          struct vm_area_struct *vma=
)
> > > +static inline int mmap_action_complete(struct vm_area_struct *vma,
> > > +                                      struct mmap_action *action)
> > >  {
> > >         return 0;
> > >  }
> > > --
> > > 2.53.0
> > >

