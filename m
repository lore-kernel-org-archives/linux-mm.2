Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3DEF30296
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 02:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665516B00F2; Sun, 15 Mar 2026 22:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613886B00F3; Sun, 15 Mar 2026 22:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1106B00F4; Sun, 15 Mar 2026 22:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 358916B00F2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:18:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B539B13C28B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:18:52 +0000 (UTC)
X-FDA: 84550318104.27.633DD08
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id DBF5640009
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:18:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oV3WVZ74;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773627530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnWGu44tSbdw9jKt/jasKkcuK6YSxM7E/Q2BjBYPLWs=;
	b=HvlRd5U3SbInWziho+5SHLJ7dZLJfuc+BBzW1RLHR47H4320OmSl69zzLz0XOas88d0QWh
	0CP+XMpzQu6AS9moT+6szx455m83tpWSsDfXDOvPc0QHNXZ5rLSGHJZvL2u0yBPpchDciE
	omSWAnEmOlgT1b9TmLV88y4v0yhj8sI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oV3WVZ74;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773627530; a=rsa-sha256;
	cv=pass;
	b=K+07eBvkRQoFEtO34cjJQTpqbPziNDBZP/ThB1Ae47VEHSAgFBEVxeKH6cAZN76T/S5bV0
	JLVH9Z5x4B9V/+ot2jwhE7MO9inpDY66H4KvL4XUS2EJfs3LZFs5Pcp6C7fCjvTFb7tpVg
	iAEPp9O1+8bn6lfoxGFcZ5oXwQ9Sed0=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-509069a7a7fso801771cf.0
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:18:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773627530; cv=none;
        d=google.com; s=arc-20240605;
        b=gLZncxkBuNtPcFiU/2e2QzamLRYE+XjrtxICDrte4hFqfi71dSBrHSpzHM3P1jLPmA
         YmqV9E1L8JNaUR3PIlP2cQIvQFNfQsKpTto5NmvJNKnjfvbvwyOy91y0wRubDbqsqPmn
         H+3IJpkL4Js2+Uxd0463Wz4vRCdPeOpEZt/0dlpFyXoM6r1wlQEK1duus/rYigvbSBNo
         RJIjKd6314gu42i168Ggoogfr8+n5UasWpzTjf+lK+eR++bztAfAvBZJO0p0FjI8hqWF
         WszGCoiKNt5pYLDS40IAo+udYgVFfI3tZaFFsm2UwqFhumdW+oQcb55OWehtQTYN8nEs
         ALvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dnWGu44tSbdw9jKt/jasKkcuK6YSxM7E/Q2BjBYPLWs=;
        fh=B3EB1lHxgIC2ODVgNkMnzPmQqZTiVlRPLIIEgj+s+4A=;
        b=Qo3ZS1LTz2ak654qfsbUeuF2WbKqL5Sh/Lt006Az+UdI21PK0tCZswxjTZ6kX4eghF
         Q+tk+MbUMQs1jCVIq+QbqWMJJNTyYNlhFNEljdkakOVfy4CRkJA7PtF4OxiUQAzsrwbJ
         N2wgbo5My5hUWmQZxsURBT4v6fJK/na4H756H9HALGmgOw43SzXzmPf3kfQBSTnoS4A8
         MmvCZwoQmpvcrJs/uiMrV2MQPm/qS/qYjNJmIC7C+cjCOTq78NqyRXXhAjVqZDDsZ0rl
         mWxPtCIE9CaPSpTSBLW4x0Z0nTY1SFMDOs8WUPznb/3ACDjBxewpxecuhmFrG0BOSsBy
         i5bA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773627530; x=1774232330; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dnWGu44tSbdw9jKt/jasKkcuK6YSxM7E/Q2BjBYPLWs=;
        b=oV3WVZ7436owSUlRgTPaC5m4KIsb8lugXzm2ZOXKH8035WiSxxyDKbFSO9J3LZKAFf
         CcqfdyvZoNiLNTxyrG6Yg5v4iUlWJzknYkP9U5HBG8nxLCwA/74vl+TWxwYjyXYEvGU9
         naoutJSUWSi4fHoBkYGhaa/KXQRFFWVkWCGtD49Ht8x7AL1D4XGUQmAefyyTUqUioJtv
         0h8hEXuNT9O25mPeDCW2yzK2m1RB4OLB6zOL49mU+vqC+rT94jHeSaRQznSzx0C1Fq/T
         Z4g0Zngt8Fnx6XbR36T3/tI0G4/5+mSmCwDzEGFdHD9StV0Vk06Miiin+uKrgbDqHQZW
         qZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773627530; x=1774232330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dnWGu44tSbdw9jKt/jasKkcuK6YSxM7E/Q2BjBYPLWs=;
        b=i5xpiVVT31NQmVqXnceJnjF4J8dvfov6V7DpNvHRaUtGRUtBx/jpGkUrn1jrY/qVkU
         IlAGq/pyz4WhjhTgXpYZ3/XHYjjiga8yrqFbHjiIclhpcyn3FI+eTZohQOcWRkd8mvrK
         QVwC+ZSrnDfwhyfjzvQEpfYOmyRMao7hofwLcLuxR7lSk8WHgrQT/J5DDE2P7RrW0KhQ
         tRYjrcDJ6yK9WU0fOTe2RkrTmECe/tJSGTtGDfQcuCLMPEcLdDIp4jJLuGFRgaL4THPk
         g4vr4aBamOC7B2IaPTYLuMO30Z9VgSgiB/hRTcPE1JUJV7fzL2gh1nr5cNBw3TS5r6db
         ewPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw936kjqdd63trR3as5M27hIwjInqILobThP1EkiT8MtsGnHml1G69vKysW6r1/psgD5/WQJ4iDw==@kvack.org
X-Gm-Message-State: AOJu0YzMXsITTK+1Zo1Bwhf0vCBbjhUgZCj4rRU1HDOcZNEoa/eApqbG
	5Lfa9K/7EoZ+2snETOnRfabT5/DBXPHOMGHddgy9Wh4MgdIulivk+2LPqQHAc178Pz/84xtbstb
	iv1pduIht0G2wjZwSKcJ07SFSdWYpOuC06yCETq4i
X-Gm-Gg: ATEYQzwZ2DnVatqwPdZAGLCOPQSFA/mV6VVThaWE3uIrfyRFrK6vW1cjFuf0MpzLgki
	zDPof92kc3NYDE0KWOzvADiCuUS+O+DjLR33JvR+2GxRYhCWUyU3+SlwAtKyo8LSXMbVE7WJdoy
	h9WgXaUqid4/Rp8dAQTunEpmAmJfIZvF/iXYcqiOVs0QasTskdMcdAvZGUwK4KVYJaJrwu1CZkF
	fhbCgVu4ylAqbx1b+hajGeLsQION4aEnvzIarJql8v5GAuuT3nww0EbHLEGEB01TTPWD0V+9xrB
	zuR4Wg==
X-Received: by 2002:a05:622a:34d:b0:506:9852:75ec with SMTP id
 d75a77b69052e-5096a9f1e28mr18574031cf.9.1773627529027; Sun, 15 Mar 2026
 19:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <0e0fe47852e6009f662b1fa42f836447b8d1283a.1773346620.git.ljs@kernel.org>
 <20260313110238.2500603-1-usama.arif@linux.dev> <24cbbaf6-19f2-4403-8cb7-415007597345@lucifer.local>
In-Reply-To: <24cbbaf6-19f2-4403-8cb7-415007597345@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 19:18:38 -0700
X-Gm-Features: AaiRm510xG9rdMA-1YX4TcP6jNn-n0Y2wP6jWBejCDuFUbPHH2dWyPV1sklVvuE
Message-ID: <CAJuCfpH1gzi50aWni7rh9=2gM8WwCzm=fY14DCFbjweAq82i6Q@mail.gmail.com>
Subject: Re: [PATCH 04/15] mm: add vm_ops->mapped hook
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
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
X-Rspamd-Queue-Id: DBF5640009
X-Stat-Signature: xwwyd3omuwyf7bb3rwo4fosx9jonhm9g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773627530-799570
X-HE-Meta: U2FsdGVkX19KbXpXvGChTT0ELQc/HsSlRnVBzPo/yyCCuPxFphAVlzc2ZKwwKbM2WBOWmU1WRYJ1E5b0j4R0ZNDA83/To0Lpn/A7BQ9DyaHNdpzKnoaCsi6BkaOswQFX9bcTh+EoCP3msM2v7wLkra+dZ62clu+tKqNaHzZRG48XeEbWlmVgz6Lf7652AgFP40GS1pPFqATBLTMnCU0GQEoDDnzBPCPjPTYJxK25cT5YTzA2OpEqvFuAOw04ZqGkG9CrjsHtElGi4Tg23S2UoeS50/9jeGxtSBs7+hcA4fxfrSunxUbBMWCvw/BovwsAfSiAawV9evyoTXaHhJDgNLwIbqVhMJuabexq0MVcXzEHfruWYXH1YM4XE5irxSpnk4kzFnzOG9A8CRi5dwFH0ou37Z4X6IhNs0nzggaWZdKCuwh/2eC8GAfhlQS7hPzB2kG2ORNLycwAxJwSJqUde4u6Uw1/qp14RUq4okZclopkWxwkUsz91ZQ3fVZ+TGahSZAuqvdaggx4FnNQyt+I94iGpgvFUMxyDvAk85crvhXtUkBnte/txsdcNV4u+FR5Z6AVkgnBR8xH0NpfhIdgTdO5SW8nB9kPNFthLrtBhpwRnoGKDIyme7peGJX8jqC0n2lkTNJdtwlQww9/jyMySoDm8lUVetDfrjewiQUYQnLbI2980QrNRcUlF8PkWN3BRrEE0WLXVAIcUvxpB/sDALZGeeUiLbShrr4CmKRmZt0rreTi4+pqH9C09Yt4AecLBGlVW4taueXpYW1lD9xtyxOF9Ta7frJ2Q5+gjtey+5te5L3679LTPZC1QDFPACHghCFkCO3NlRjfjFJU8GJXY/XyPtrDr1LW9T5QKvAp6lysRkNZUnU2ShNWMmnRx3I/uLQWW4GbrefjYnaIaGsjVcKXg8vVrjb29W8r3D/aTcECW3j8Isds6P4xXZ07jOhAMf3gPuzcyuC7q+fB1MS
 F6S5V8pc
 1fqZIIxFn3YIgSDm8Y/yLR9CrbeYBJiKvhNHeuHFcD9LICuxHU/9Izsxn4WjC/StdLX/e0buswya8n13qJMj7vApey9q5+BVV/R3z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 4:58=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 13, 2026 at 04:02:36AM -0700, Usama Arif wrote:
> > On Thu, 12 Mar 2026 20:27:19 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kern=
el.org> wrote:
> >
> > > Previously, when a driver needed to do something like establish a ref=
erence
> > > count, it could do so in the mmap hook in the knowledge that the mapp=
ing
> > > would succeed.
> > >
> > > With the introduction of f_op->mmap_prepare this is no longer the cas=
e, as
> > > it is invoked prior to actually establishing the mapping.
> > >
> > > To take this into account, introduce a new vm_ops->mapped callback wh=
ich is
> > > invoked when the VMA is first mapped (though notably - not when it is
> > > merged - which is correct and mirrors existing mmap/open/close behavi=
our).
> > >
> > > We do better that vm_ops->open() here, as this callback can return an
> > > error, at which point the VMA will be unmapped.
> > >
> > > Note that vm_ops->mapped() is invoked after any mmap action is
> > > complete (such as I/O remapping).
> > >
> > > We intentionally do not expose the VMA at this point, exposing only t=
he
> > > fields that could be used, and an output parameter in case the operat=
ion
> > > needs to update the vma->vm_private_data field.
> > >
> > > In order to deal with stacked filesystems which invoke inner filesyst=
em's
> > > mmap() invocations, add __compat_vma_mapped() and invoke it on
> > > vfs_mmap() (via compat_vma_mmap()) to ensure that the mapped callback=
 is
> > > handled when an mmap() caller invokes a nested filesystem's mmap_prep=
are()
> > > callback.
> > >
> > > We can now also remove call_action_complete() and invoke
> > > mmap_action_complete() directly, as we separate out the rmap lock log=
ic to
> > > be called in __mmap_region() instead via maybe_drop_file_rmap_lock().
> > >
> > > We also abstract unmapping of a VMA on mmap action completion into it=
s own
> > > helper function, unmap_vma_locked().
> > >
> > > Additionally, update VMA userland test headers to reflect the change.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  include/linux/fs.h              |  9 +++-
> > >  include/linux/mm.h              | 17 +++++++
> > >  mm/internal.h                   | 10 ++++
> > >  mm/util.c                       | 86 ++++++++++++++++++++++++-------=
--
> > >  mm/vma.c                        | 41 +++++++++++-----
> > >  tools/testing/vma/include/dup.h | 34 ++++++++++++-
> > >  6 files changed, 158 insertions(+), 39 deletions(-)
> > >
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index a2628a12bd2b..c390f5c667e3 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -2059,13 +2059,20 @@ static inline bool can_mmap_file(struct file =
*file)
> > >  }
> > >
> > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
> > > +int __vma_check_mmap_hook(struct vm_area_struct *vma);
> > >
> > >  static inline int vfs_mmap(struct file *file, struct vm_area_struct =
*vma)
> > >  {
> > > +   int err;
> > > +
> > >     if (file->f_op->mmap_prepare)
> > >             return compat_vma_mmap(file, vma);
> > >
> > > -   return file->f_op->mmap(file, vma);
> > > +   err =3D file->f_op->mmap(file, vma);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   return __vma_check_mmap_hook(vma);
> > >  }
> > >
> > >  static inline int vfs_mmap_prepare(struct file *file, struct vm_area=
_desc *desc)
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 12a0b4c63736..7333d5db1221 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -759,6 +759,23 @@ struct vm_operations_struct {
> > >      * Context: User context.  May sleep.  Caller holds mmap_lock.
> > >      */
> > >     void (*close)(struct vm_area_struct *vma);
> > > +   /**
> > > +    * @mapped: Called when the VMA is first mapped in the MM. Not ca=
lled if
> > > +    * the new VMA is merged with an adjacent VMA.
> > > +    *
> > > +    * The @vm_private_data field is an output field allowing the use=
r to
> > > +    * modify vma->vm_private_data as necessary.
> > > +    *
> > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in an e=
rror if
> > > +    * set from f_op->mmap.
> > > +    *
> > > +    * Returns %0 on success, or an error otherwise. On error, the VM=
A will
> > > +    * be unmapped.
> > > +    *
> > > +    * Context: User context.  May sleep.  Caller holds mmap_lock.
> > > +    */
> > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgo=
ff,
> > > +                 const struct file *file, void **vm_private_data);
> > >     /* Called any time before splitting to check if it's allowed */
> > >     int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
> > >     int (*mremap)(struct vm_area_struct *vma);
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 7bfa85b5e78b..f0f2cf1caa36 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -158,6 +158,8 @@ static inline void *folio_raw_mapping(const struc=
t folio *folio)
> > >   * mmap hook and safely handle error conditions. On error, VMA hooks=
 will be
> > >   * mutated.
> > >   *
> > > + * IMPORTANT: f_op->mmap() is deprecated, prefer f_op->mmap_prepare(=
).
> > > + *

What exactly would one do to "prefer f_op->mmap_prepare()"?
Since you are adding this comment for mmap_file(), I think you need to
describe more specifically what one should call instead.

> > >   * @file: File which backs the mapping.
> > >   * @vma:  VMA which we are mapping.
> > >   *
> > > @@ -201,6 +203,14 @@ static inline void vma_close(struct vm_area_stru=
ct *vma)
> > >  /* unmap_vmas is in mm/memory.c */
> > >  void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
> > >
> > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > +{
> > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > +
> > > +   mmap_assert_locked(vma->vm_mm);

You must hold the mmap write lock when unmapping. Would be better to
assert mmap_assert_write_locked() or even vma_assert_write_locked(),
which implies mmap_assert_write_locked().

> > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > +}
> > > +
> > >  #ifdef CONFIG_MMU
> > >
> > >  static inline void get_anon_vma(struct anon_vma *anon_vma)
> > > diff --git a/mm/util.c b/mm/util.c
> > > index dba1191725b6..2b0ed54008d6 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -1163,6 +1163,55 @@ void flush_dcache_folio(struct folio *folio)
> > >  EXPORT_SYMBOL(flush_dcache_folio);
> > >  #endif
> > >
> > > +static int __compat_vma_mmap(struct file *file, struct vm_area_struc=
t *vma)
> > > +{
> > > +   struct vm_area_desc desc =3D {
> > > +           .mm =3D vma->vm_mm,
> > > +           .file =3D file,
> > > +           .start =3D vma->vm_start,
> > > +           .end =3D vma->vm_end,
> > > +
> > > +           .pgoff =3D vma->vm_pgoff,
> > > +           .vm_file =3D vma->vm_file,
> > > +           .vma_flags =3D vma->flags,
> > > +           .page_prot =3D vma->vm_page_prot,
> > > +
> > > +           .action.type =3D MMAP_NOTHING, /* Default */
> > > +   };
> > > +   int err;
> > > +
> > > +   err =3D vfs_mmap_prepare(file, &desc);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   err =3D mmap_action_prepare(&desc, &desc.action);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   set_vma_from_desc(vma, &desc);
> > > +   return mmap_action_complete(vma, &desc.action);
> > > +}
> > > +
> > > +static int __compat_vma_mapped(struct file *file, struct vm_area_str=
uct *vma)
> > > +{
> > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > +   void *vm_private_data =3D vma->vm_private_data;
> > > +   int err;
> > > +
> > > +   if (!vm_ops->mapped)
> > > +           return 0;
> > > +
> >
> > Hello!
> >
> > Can vm_ops be NULL here?  __compat_vma_mapped() is called from
> > compat_vma_mmap(), which is reached when a filesystem provides
> > mmap_prepare.  If the mmap_prepare hook does not set desc->vm_ops,
> > vma->vm_ops will be NULL and this dereferences a NULL pointer.
>
> I _think_ for this to ever be invoked, you would need to be dealing with =
a
> file-backed VMA so vm_ops->fault would HAVE to be defined.
>
> But you're right anyway as a matter of principle we should check it! Will=
 fix.
>
> >
> > For e.g. drivers/char/mem.c, mmap_zero_prepare() would trigger
> > a NULL pointer dereference here.
> >
> > Would need to do
> >       if (!vm_ops || !vm_ops->mapped)
> >               return 0;
> >
> > here
>
> Yes.
>
> >
> >
> > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,=
 file,
> > > +                        &vm_private_data);
> > > +   if (err)
> > > +           unmap_vma_locked(vma);
> >
> > when mapped() returns an error, unmap_vma_locked(vma) is called
> > but execution continues into the vm_private_data update below.  After
> > unmap_vma_locked() the VMA may be freed (do_munmap can remove the VMA
> > entirely), so accessing vma->vm_private_data after that is a
> > use-after-free.
>
> Very good point :) will fix thanks!
>
> Probably:
>
>         if (err)
>                 unmap_vma_locked(vma);
>         else if (vm_private_data !=3D vma->vm_private_data)
>                 vma->vm_private_data =3D vm_private_data;
>
>         return err;
>
> Would be fine.
>
> >
> > Probably need to do:
> >       if (err) {
> >               unmap_vma_locked(vma);
> >               return err;
> >       }
> >
> > > +   /* Update private data if changed. */
> > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > +           vma->vm_private_data =3D vm_private_data;
> > > +
> > > +   return err;
> > > +}
> > > +
> > >  /**
> > >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
> > >   * existing VMA and execute any requested actions.
> > > @@ -1191,34 +1240,26 @@ EXPORT_SYMBOL(flush_dcache_folio);
> > >   */
> > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> > >  {
> > > -   struct vm_area_desc desc =3D {
> > > -           .mm =3D vma->vm_mm,
> > > -           .file =3D file,
> > > -           .start =3D vma->vm_start,
> > > -           .end =3D vma->vm_end,
> > > -
> > > -           .pgoff =3D vma->vm_pgoff,
> > > -           .vm_file =3D vma->vm_file,
> > > -           .vma_flags =3D vma->flags,
> > > -           .page_prot =3D vma->vm_page_prot,
> > > -
> > > -           .action.type =3D MMAP_NOTHING, /* Default */
> > > -   };
> > >     int err;
> > >
> > > -   err =3D vfs_mmap_prepare(file, &desc);
> > > -   if (err)
> > > -           return err;
> > > -
> > > -   err =3D mmap_action_prepare(&desc, &desc.action);
> > > +   err =3D __compat_vma_mmap(file, vma);
> > >     if (err)
> > >             return err;
> > >
> > > -   set_vma_from_desc(vma, &desc);
> > > -   return mmap_action_complete(vma, &desc.action);
> > > +   return __compat_vma_mapped(file, vma);
> > >  }
> > >  EXPORT_SYMBOL(compat_vma_mmap);
> > >
> > > +int __vma_check_mmap_hook(struct vm_area_struct *vma)
> > > +{
> > > +   /* vm_ops->mapped is not valid if mmap() is specified. */
> > > +   if (WARN_ON_ONCE(vma->vm_ops->mapped))
> > > +           return -EINVAL;
> >
> > I think vma->vm_ops can be NULL here. Should be:
> >
> >       if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
> >               return -EINVAL;
>
> I think again you'd probably only invoke this on file-backed so be ok, bu=
t again
> as a matter of principle we should check it so will fix, thanks!
>
> >
> > > +
> > > +   return 0;
> > > +}
> > > +EXPORT_SYMBOL(__vma_check_mmap_hook);

nit: Any reason __vma_check_mmap_hook() is not inlined next to its
user vfs_mmap()?

> > > +
> > >  static void set_ps_flags(struct page_snapshot *ps, const struct foli=
o *folio,
> > >                      const struct page *page)
> > >  {
> > > @@ -1316,10 +1357,7 @@ static int mmap_action_finish(struct vm_area_s=
truct *vma,
> > >      * invoked if we do NOT merge, so we only clean up the VMA we cre=
ated.
> > >      */
> > >     if (err) {
> > > -           const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > -
> > > -           do_munmap(current->mm, vma->vm_start, len, NULL);
> > > -
> > > +           unmap_vma_locked(vma);
> > >             if (action->error_hook) {
> > >                     /* We may want to filter the error. */
> > >                     err =3D action->error_hook(err);
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index 054cf1d262fb..ef9f5a5365d1 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -2705,21 +2705,35 @@ static bool can_set_ksm_flags_early(struct mm=
ap_state *map)
> > >     return false;
> > >  }
> > >
> > > -static int call_action_complete(struct mmap_state *map,
> > > -                           struct mmap_action *action,
> > > -                           struct vm_area_struct *vma)
> > > +static int call_mapped_hook(struct vm_area_struct *vma)
> > >  {
> > > -   int ret;
> > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > +   void *vm_private_data =3D vma->vm_private_data;
> > > +   int err;
> > >
> > > -   ret =3D mmap_action_complete(vma, action);
> > > +   if (!vm_ops || !vm_ops->mapped)
> > > +           return 0;
> > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,
> > > +                        vma->vm_file, &vm_private_data);
> > > +   if (err) {
> > > +           unmap_vma_locked(vma);
> > > +           return err;
> > > +   }
> > > +   /* Update private data if changed. */
> > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > +           vma->vm_private_data =3D vm_private_data;
> > > +   return 0;
> > > +}
> > >
> > > -   /* If we held the file rmap we need to release it. */
> > > -   if (map->hold_file_rmap_lock) {
> > > -           struct file *file =3D vma->vm_file;
> > > +static void maybe_drop_file_rmap_lock(struct mmap_state *map,
> > > +                                 struct vm_area_struct *vma)
> > > +{
> > > +   struct file *file;
> > >
> > > -           i_mmap_unlock_write(file->f_mapping);
> > > -   }
> > > -   return ret;
> > > +   if (!map->hold_file_rmap_lock)
> > > +           return;
> > > +   file =3D vma->vm_file;
> > > +   i_mmap_unlock_write(file->f_mapping);
> > >  }
> > >
> > >  static unsigned long __mmap_region(struct file *file, unsigned long =
addr,
> > > @@ -2773,8 +2787,11 @@ static unsigned long __mmap_region(struct file=
 *file, unsigned long addr,
> > >     __mmap_complete(&map, vma);
> > >
> > >     if (have_mmap_prepare && allocated_new) {
> > > -           error =3D call_action_complete(&map, &desc.action, vma);
> > > +           error =3D mmap_action_complete(vma, &desc.action);
> > > +           if (!error)
> > > +                   error =3D call_mapped_hook(vma);
> > >
> > > +           maybe_drop_file_rmap_lock(&map, vma);
> > >             if (error)
> > >                     return error;
> > >     }
> > > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/incl=
ude/dup.h
> > > index 908beb263307..47d8db809f31 100644
> > > --- a/tools/testing/vma/include/dup.h
> > > +++ b/tools/testing/vma/include/dup.h
> > > @@ -606,12 +606,34 @@ struct vm_area_struct {
> > >  } __randomize_layout;
> > >
> > >  struct vm_operations_struct {
> > > -   void (*open)(struct vm_area_struct * area);
> > > +   /**
> > > +    * @open: Called when a VMA is remapped or split. Not called upon=
 first
> > > +    * mapping a VMA.
> > > +    * Context: User context.  May sleep.  Caller holds mmap_lock.
> > > +    */

This comment should have been introduced in the previous patch.

> > > +   void (*open)(struct vm_area_struct *vma);
> > >     /**
> > >      * @close: Called when the VMA is being removed from the MM.
> > >      * Context: User context.  May sleep.  Caller holds mmap_lock.
> > >      */
> > > -   void (*close)(struct vm_area_struct * area);
> > > +   void (*close)(struct vm_area_struct *vma);
> > > +   /**
> > > +    * @mapped: Called when the VMA is first mapped in the MM. Not ca=
lled if
> > > +    * the new VMA is merged with an adjacent VMA.
> > > +    *
> > > +    * The @vm_private_data field is an output field allowing the use=
r to
> > > +    * modify vma->vm_private_data as necessary.
> > > +    *
> > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in an e=
rror if
> > > +    * set from f_op->mmap.
> > > +    *
> > > +    * Returns %0 on success, or an error otherwise. On error, the VM=
A will
> > > +    * be unmapped.
> > > +    *
> > > +    * Context: User context.  May sleep.  Caller holds mmap_lock.
> > > +    */
> > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgo=
ff,
> > > +                 const struct file *file, void **vm_private_data);
> > >     /* Called any time before splitting to check if it's allowed */
> > >     int (*may_split)(struct vm_area_struct *area, unsigned long addr)=
;
> > >     int (*mremap)(struct vm_area_struct *area);
> > > @@ -1345,3 +1367,11 @@ static inline void vma_set_file(struct vm_area=
_struct *vma, struct file *file)
> > >     swap(vma->vm_file, file);
> > >     fput(file);
> > >  }
> > > +
> > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > +{
> > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > +
> > > +   mmap_assert_locked(vma->vm_mm);
> > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > +}
> > > --
> > > 2.53.0
> > >
> > >
>
> Cheers, Lorenzo

