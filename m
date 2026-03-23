Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E96FF46101
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE26D6B0092; Mon, 23 Mar 2026 09:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92966B0093; Mon, 23 Mar 2026 09:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959EA6B0095; Mon, 23 Mar 2026 09:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8116B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:18:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB849140B09
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:18:43 +0000 (UTC)
X-FDA: 84577382526.06.E28A6C5
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCE5B120010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:18:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HXcBeYjX;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774271922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HAMwL3qwoKn2S7VcNBMq+3HfyX9a7ga1yd+4iK0YxU=;
	b=3Au5gQhzWDDMRg0b2rpSO0rIInkYa/137FQXwtoOo7TK1OD8z8qW5f+RBlDGILEs7gkiE2
	UtaMizjt6U8xUyrOiJ0iPgLpP4GuMgVciz1SgmgxtnemoWkejzl935ZLUoupir8IUU4Vag
	PZDYnhHtZxvrwiIyyQ/voPS/YgTTdQY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HXcBeYjX;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774271922; a=rsa-sha256;
	cv=pass;
	b=fv/9gmXFWg7hZ486N77zTyPNuMOeU67cnM2WhGFEjpgj15J/dXLNaFEiCCjyjFjp5/9hvk
	lszy4M8dYjNhKO/wP5WEplXd5bjahYcL50YKDlQsg3s5gtWcM1cI+duyxdj1smtUM8KQvK
	/BEqy8w+Vgu9lrRsKdD13z8Q2vnPhS0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so194214a12.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:18:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774271920; cv=none;
        d=google.com; s=arc-20240605;
        b=GEKrNK1ys0pdOm/BnW4HL8thIQvbQ1U/TONG1OMq+ocPhr8v1WrlxDfh/ssLN2vNOc
         3a32CLr/FUWo40Oad0+1AjqRjAmNL1DZG3zj2siTGsyFI5TKoAKampfmiffqgvkCx3ia
         Nw8RkNoZDD+pJDXkjgyTeY4nk+2Tk3iDMCsl8miiqLvU+WPe7SS6/FZtU5D0k8gU1d8w
         VmrGev3YcC6+TpC1O1yndfbieADCg3yJslQxELEWiDeWgGyhHq1cmhGc0FxWTydbhK9Q
         cp6QYwyJxXKMLeckcbb3LCCzhI6fsp4dkbUjpJq1dF27N6cD5NiiGquJ0w/lX2HIaXfH
         xQtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9HAMwL3qwoKn2S7VcNBMq+3HfyX9a7ga1yd+4iK0YxU=;
        fh=G3bkeTG6pIfDgJjsRWEjNNsi2vpfWESsbto4HSCYqic=;
        b=J65NL4HVn8Ix4nlBUC+1/WbuHtZiEJulqf1cF4UIccdXIMEKCj69ksIITqWbZpejpI
         YA+3+vVU2pEV8XV4pwC3sZJn1zW0mVuXBsaTVHENyYDlKmfWIVEw4t+WQXja+i+60Ajo
         kgjTKQbALV9sz5XA3wkhXGDYVH4f4/NLJARZPSIXfzLuwP4zeUQAN13/BzvR3lK4A2A7
         +QVu6f7QBwbtogHfQaWvJjpqUPEPm5VlFRhuokIvlFuRAZK38rjv07Dg+F6xMsLsmNGK
         MDkq6HntU8bBfQZTwn6afWCZLELlmaqgxRyeHz/BNfmxVsa4X0CfcFifKWANhg9CgcmH
         syww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774271920; x=1774876720; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HAMwL3qwoKn2S7VcNBMq+3HfyX9a7ga1yd+4iK0YxU=;
        b=HXcBeYjXhT7cH71NN4R1ZEegOnP2JveTDPKx+t/lMMvTfCRXxtAz3b5MnZSdo6vfSl
         KoenpcW0Ei5Tn8j+nb5ktQZxyUeTrZZsXhV23+XuYYC2l5A7WDXaSHUvy+BBKoib/Vln
         cONgUjBlIPQl2u9u5j9Yb6iq/3q5zAP7wVqN6UGr1nMDMC4dFeTZwZB2maLIo6qTiJse
         dPwP0N64dohJzuMqfo3b7y1A5NHHYnCIaJtIuSX1HCVzqtXHl73rj4QQZR2IEPemw3iI
         4XePF8OvUtOXCR6tlCX/UG+3kNMQTcUM1plv1K8Zk0chHtrSSX6JOrUdpGnS/obKVZU0
         PBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774271920; x=1774876720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9HAMwL3qwoKn2S7VcNBMq+3HfyX9a7ga1yd+4iK0YxU=;
        b=Nvp3f6/DKiIzFybjZYOYnn9qpJsOFQK31cJSVzrqeEp7cqrorRJYeSrnd782bM6wh+
         TbHy1ZGLj8M2BZEOy2L/seMMDTlR5Pxj/pt30uNtfn1KMc7F6wm6mIMr9QHgTQgVzML8
         Y5V2HudGzh5m/tfPURMnQTQqcrlE7dWPR5tVoPR2X76+z/uTeWQ9XOkxHFOsvHrjtjbZ
         LmtQSM73lFw2feXFiTR4EUlijjoFeQFMc5mpFdQFeZ/QI5UmvaC8+0VGLslwDTNsEpZa
         t/sfpOVnSxZpDK1/yQVMYd4JSvXXW8FkUxV0DDIzVO1NzTGehOUwOY8n1DHE+MY2WcXG
         po/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQNwY11K0cWVXEO0VtGdji96QnQvg2p6JYHu+Eeo1m2s4jc5QWN4x/7F+QUtEO9V5PrjZJCaemnA==@kvack.org
X-Gm-Message-State: AOJu0YwFei7Sq622yURUMcoHKAguZNrITPPUol/eSVXr7gX0z9luYu1O
	OW+O0M/KXgIIHkwnui6Qv7lCZCCAQEmpOZYoUVwcX+Wbj17RkWC8fKSQ+vjCplRbFuPjDwcHc3z
	TAvhBX0JXA41+jaBAGZJ6vKTMlwjmIWt0Uk9SUaxRyQ==
X-Gm-Gg: ATEYQzzR4cIeBHA0JkF2kMBFXP7T//pYWU10qrRg9zgGCcCdRfETR5/SdzfKOE0FDoO
	jvaFE02pdlqGU077DICeYQC/qEAzfQanjC8RmxftZ8eLy2/UaVlHirVRvgjymh1H7DMLLCLDKP2
	wlmC7z+Jhj646s6AgJ9dO51EHan9VQxV3Y5POUMndB7AHivm+z2pxBDSzB9aGdmvGmQKeZyXvZN
	5OVkBDycgmnIqfKKCJcr+PjGRC/SH0Htiny56umgdTVl0IhEQhNXRFA2ZXyU+rJ+akoEECMjnyl
	wzlfDkgsFRNhrrQpmn6OmrY8sXGXCEx/Ea9Hyw==
X-Received: by 2002:a05:6402:5287:b0:668:58b6:505c with SMTP id
 4fb4d7f45d1cf-668c9b3b2famr8334029a12.30.1774271919886; Mon, 23 Mar 2026
 06:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260321175808.57942-1-pasha.tatashin@soleen.com>
 <20260321175808.57942-2-pasha.tatashin@soleen.com> <CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfjaRZQ@mail.gmail.com>
 <20260323-leibhaftig-blasinstrument-58ec408b3c40@brauner>
In-Reply-To: <20260323-leibhaftig-blasinstrument-58ec408b3c40@brauner>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 23 Mar 2026 09:18:03 -0400
X-Gm-Features: AQROBzAqhjlsVN_c2OBjl5062LhFhC93S4akUrZBBBRdg0y4aoik88cM1Nzn6lE
Message-ID: <CA+CK2bC6S7pFCYR0XS1ZPxw9HKjWgxy=0DkszYNjMUi735o_1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] liveupdate: prevent double management of files
To: Christian Brauner <brauner@kernel.org>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, jack@suse.cz, 
	shuah@kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, pratyush@kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCE5B120010
X-Stat-Signature: tg9yekzoex8nu4ga8fjf3mkwsdn8d1y3
X-Rspam-User: 
X-HE-Tag: 1774271921-313455
X-HE-Meta: U2FsdGVkX18uBHZOpMP7pFPEJjUGe9E1Gz0fEUKuBXqF8ZmJk7r/BRa1ZP7lS+u8bbk45ub5KVJNoxesx/E7g1i7RV74vnDStHg+6aDXCxMTwWRDUZIWGOeGjSFQV5pQiUZRlOKJ6ECv4O6gNBwqmjBiCm5wtLEB7pamwlvrdOAazrmxRCvzTfPPE6bbAVD0Q1xUIh9XMk/6N06p6B0bfcnbZarrwbQoiIfgpo+3SD4fAL5jQxRqBOMFnZJrVy+o4GfhwxTw5ZSW4T3pWYHtSybdGdS3rX6Kc0jvFxmexO47e//bkCPfkBW8n+oMGZXwJrAuGWgRH5kAqGe0C9tafvTgjYM6QNta7Z6hGMoreHgq61x6Vy5ma0S+b3MPgS9cG5naHs/2eIA2VtuR8H4U3dhdVuNxt2SbHJY9d0btmrqZwX1eAVk/q/isacnt1bmmEWaDtaORZKvu2WLDbFpemze8bdJd7iUQFlUEx0SRfxQa7aGT9Ezh5aSSXFN2r80/EZ8aIqUHmR+/q7ym7A32ktE6wYQWrrUasTKa+Pu7/bajUq2xV1mWRwsbHNZnQ40+BPCguHvaeM2x/3zWk7bKkrhANFtcnVSDjsQV3uNNJhLGleobgauJhm9dA3JiboSzrNeYrr5mAvJR1FQbhFm+ra9UN22DfmOiB1FAhh+aY1THF4QOR/ib/Z136yJ4rFEciS0vDpkbOqYASxUqAj8Q3NJHaOomao5vcEAXpBYwyAc70ToHrKNuOHjwTMClTOFX0m0QTptkJG+sXBe1BAOeFv6Bn2mMRiGfqPovcXNywUYlU2+ZkFc5vOa5AKHFM03ZVGgujezS1/RUxop6kRhaoWbEMzvpI4FRwTgey9ywTyCerlHxJ5RUv1FMLxeqD+ixsB2pFdopMZNXDIq3p+tTutlswMJmToQuIjeI5R/vQlHMkvoWr8OJ9P0oIK7ikU8r95dX6Bfr2i4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 7:55=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Sat, Mar 21, 2026 at 09:04:53PM -0400, Pasha Tatashin wrote:
> > On Sat, Mar 21, 2026 at 1:58=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > >
> > > Currently, LUO does not prevent the same file from being managed twic=
e
> > > across different active sessions.
> > >
> > > Add a new i_state flag I_LUO_MANAGED and update luo_preserve_file()
> > > to check and set this flag when a file is preserved, and clear it in
> > > luo_file_unpreserve_files() when it is released.
> > >
> > > Additionally, set this flag in luo_retrieve_file() after a file is
> > > successfully restored in the new kernel, and clear it in
> > > luo_file_finish() when the LUO session is finalized.
> > >
> > > This ensures that the same file (inode) cannot be managed by multiple
> > > sessions. If another session attempts to preserve an already managed
> > > file, it will now fail with -EBUSY.
> > >
> > > Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> > > Acked-by: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > ---
> > >  include/linux/fs.h           |  5 ++++-
> > >  kernel/liveupdate/luo_file.c | 27 ++++++++++++++++++++++++---
> > >  2 files changed, 28 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index 23f36a2613a3..692a8be56f3c 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -712,6 +712,8 @@ is_uncached_acl(struct posix_acl *acl)
> > >   * I_LRU_ISOLATING     Inode is pinned being isolated from LRU witho=
ut holding
> > >   *                     i_count.
> > >   *
> > > + * I_LUO_MANAGED       Inode is being managed by a live update sessi=
on.
> > > + *
> > >   * Q: What is the difference between I_WILL_FREE and I_FREEING?
> > >   *
> > >   * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses =
to wait
> > > @@ -744,7 +746,8 @@ enum inode_state_flags_enum {
> > >         I_CREATING              =3D (1U << 15),
> > >         I_DONTCACHE             =3D (1U << 16),
> > >         I_SYNC_QUEUED           =3D (1U << 17),
> > > -       I_PINNING_NETFS_WB      =3D (1U << 18)
> > > +       I_PINNING_NETFS_WB      =3D (1U << 18),
> > > +       I_LUO_MANAGED           =3D (1U << 19),
> > >  };
> > >
> > >  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
> > > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_fil=
e.c
> > > index 5acee4174bf0..86911beeff71 100644
> > > --- a/kernel/liveupdate/luo_file.c
> > > +++ b/kernel/liveupdate/luo_file.c
> > > @@ -248,6 +248,7 @@ static bool luo_token_is_used(struct luo_file_set=
 *file_set, u64 token)
> > >   * Context: Can be called from an ioctl handler during normal system=
 operation.
> > >   * Return: 0 on success. Returns a negative errno on failure:
> > >   *         -EEXIST if the token is already used.
> > > + *         -EBUSY if the file descriptor is already preserved by ano=
ther session.
> > >   *         -EBADF if the file descriptor is invalid.
> > >   *         -ENOSPC if the file_set is full.
> > >   *         -ENOENT if no compatible handler is found.
> > > @@ -276,6 +277,14 @@ int luo_preserve_file(struct luo_file_set *file_=
set, u64 token, int fd)
> > >         if (err)
> > >                 goto  err_fput;
> > >
> > > +       scoped_guard(spinlock, &file_inode(file)->i_lock) {
> > > +               if (inode_state_read(file_inode(file)) & I_LUO_MANAGE=
D) {
> > > +                       err =3D -EBUSY;
> > > +                       goto err_free_files_mem;
> > > +               }
> > > +               inode_state_set(file_inode(file), I_LUO_MANAGED);
> > > +       }
> > > +
> > >         err =3D -ENOENT;
> > >         list_private_for_each_entry(fh, &luo_file_handler_list, list)=
 {
> > >                 if (fh->ops->can_preserve(fh, file)) {
> > > @@ -286,11 +295,11 @@ int luo_preserve_file(struct luo_file_set *file=
_set, u64 token, int fd)
> > >
> > >         /* err is still -ENOENT if no handler was found */
> > >         if (err)
> > > -               goto err_free_files_mem;
> > > +               goto err_unpreserve_inode;
> > >
> > >         err =3D luo_flb_file_preserve(fh);
> > >         if (err)
> > > -               goto err_free_files_mem;
> > > +               goto err_unpreserve_inode;
> > >
> > >         luo_file =3D kzalloc_obj(*luo_file);
> > >         if (!luo_file) {
> > > @@ -320,6 +329,9 @@ int luo_preserve_file(struct luo_file_set *file_s=
et, u64 token, int fd)
> > >         kfree(luo_file);
> > >  err_flb_unpreserve:
> > >         luo_flb_file_unpreserve(fh);
> > > +err_unpreserve_inode:
> > > +       scoped_guard(spinlock, &file_inode(file)->i_lock)
> > > +               inode_state_clear(file_inode(file), I_LUO_MANAGED);
> > >  err_free_files_mem:
> > >         luo_free_files_mem(file_set);
> > >  err_fput:
> > > @@ -363,6 +375,9 @@ void luo_file_unpreserve_files(struct luo_file_se=
t *file_set)
> > >                 luo_file->fh->ops->unpreserve(&args);
> > >                 luo_flb_file_unpreserve(luo_file->fh);
> > >
> > > +               scoped_guard(spinlock, &file_inode(luo_file->file)->i=
_lock)
> > > +                       inode_state_clear(file_inode(luo_file->file),=
 I_LUO_MANAGED);
> > > +
> > >                 list_del(&luo_file->list);
> > >                 file_set->count--;
> > >
> > > @@ -609,6 +624,9 @@ int luo_retrieve_file(struct luo_file_set *file_s=
et, u64 token,
> > >         *filep =3D luo_file->file;
> > >         luo_file->retrieve_status =3D 1;
> > >
> > > +       scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> > > +               inode_state_set(file_inode(luo_file->file), I_LUO_MAN=
AGED);
> > > +
> > >         return 0;
> > >  }
> > >
> > > @@ -701,8 +719,11 @@ int luo_file_finish(struct luo_file_set *file_se=
t)
> > >
> > >                 luo_file_finish_one(file_set, luo_file);
> > >
> > > -               if (luo_file->file)
> > > +               if (luo_file->file) {
> > > +                       scoped_guard(spinlock, &file_inode(luo_file->=
file)->i_lock)
> > > +                               inode_state_clear(file_inode(luo_file=
->file), I_LUO_MANAGED);
> > >                         fput(luo_file->file);
> > > +               }
> > >                 list_del(&luo_file->list);
> > >                 file_set->count--;
> > >                 mutex_destroy(&luo_file->mutex);
> > > --
> > > 2.43.0
> > >
> >
> > > Sashiko: https://sashiko.dev/#/patchset/20260321175808.57942-1-pasha.=
tatashin@soleen.com
> >
> > Sashiko reported two problems:
> >
> > 1. Are there any issues with mixing goto-based error handling and scope=
-based
> > cleanups like scoped_guard() in the same function?
> >
> > Initially, I thought that there should not be any problems, however,
> > after looking this up  I found in include/linux/cleanup.h the
> > following comment:
> >
> >  * Lastly, given that the benefit of cleanup helpers is removal of
> >  * "goto", and that the "goto" statement can jump between scopes, the
> >  * expectation is that usage of "goto" and cleanup helpers is never
> >  * mixed in the same function.
>
> There's a compile-time switch you might want to turn on when
> test-compiling code like this. I forget exactly what it is. Something
> like jump-over-uninit or something.
>
> >
> > Well, good to know, will not use goto inside scoped_guards.
> >
> > 2. Additionally, does setting I_LUO_MANAGED on the inode break the pres=
ervation
> > of anonymous inodes? Many file types (like eventfd, epoll, timerfd,
> > signalfd)
> >
> > This is actually a very good point. It looks like everyone who uses
> > anon_inode_getfd() has one shared inode. This is not a problem for the
> > existing LUO user memfd, or for the upcoming vfiofd and memfd, but
> > kvm-vmfd and kvm-cpufd also use it, and that might be a problem in the
> > future once we add support for Orphaned VMs.
> >
> > Therefore, we have two choices: either use a hash table, which adds
> > performance and memory overhead, or delegate this double-check to the
> > LUO file handlers, as they can use a private context to know if the FD
> > is already preserved.
>
> So, I'm not happy about I_LUO_MANAGED. I don't think we need driver
> specific stuff in struct inode and not in i_state. Track this in the
> driver please. I don't want this precedent and I'd rather have you get

I am planning to use an xarray in the next version.

> used to implementing such things in the driver right away rather than
> offloading this on general infrastructure. If we let this slide struct
> inode will be 2MB 1 in year.

Claiming that a single flag bit precedent would cause the overall
struct to grow by 2MB in a year is a slight exaggeration. :-)

Pasha

