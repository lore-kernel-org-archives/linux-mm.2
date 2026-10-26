Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF98606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 01:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=j7DU650b
Received: by kanga.kvack.org (Postfix)
	id 09B306B05B0; Sun, 25 Oct 2026 21:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C596B05B1; Sun, 25 Oct 2026 21:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55E66B05B2; Sun, 25 Oct 2026 21:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACE176B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:10:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 869B0140172
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:10:43 +0000 (UTC)
X-FDA: 85362997566.02.BCDEDFD
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7CBAF1C0005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:10:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j7DU650b;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792977041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=serC0Qr3v1AkQ41cs9qFoAlejUw/dVTynlDISylCuz8=;
	b=Z7yg5mZ1/q0br9n1y7yKq4Tw7WAFi3i7hesJMXHa6nDzYgrGFLyz2R8zDQxcZhmLS/Jbt+
	hjdsDe7NI5keWaCbCC8Z+XtZo+BckFkS7BK7bjOpd1KMJhnjEGIL7nT5n/OSc/laCphRx8
	uUkY736gwluX4TazPre9o4ebzDbaCcY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j7DU650b;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792977041;
	b=OSNDPeJ0V0BB9ZExf3mwKkBSkoPw3w6e1lx4UWTdoSQms6fiLgqT/rA9q7Nr714mqvWPro
	3/p6iG66iJXfPCYQygVK366FjXco9bC/thd1ycdPJxOw1fqFXRjJI7aLHfeW0f74CCqUwg
	nS1Jyh/4aZgMf0RkIPWy7U3KIAphPDQ=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b45f9ec1ceso585215a12.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:10:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792977040; cv=none;
        d=google.com; s=arc-20260327;
        b=MgL7pDO2c6cWnqbEg885B7nXWBW63b1foH9JwHXBgmgyaamoFLmog/sKg1Jwt0snu0
         OKYJzWnSZb4wu9AyoBK/sp17ONPHUPsz0/YfP4NQEUYGZ3tvx2MXhCTpXCglPm9evWLj
         P8HHLQBS6epzR8NL5i5aEasmZOg8elvM7MBn9AAfjEr4Uur297DKBthOT4Z/87yezu01
         0Z2mp+Jv3uzK2qi0jGLCpnkSbzrrLGk9A+ocfMi3aA/PGftuADbfWqjpQaNqsOdoNKJZ
         1Et/0q9CeZwoxct2CpsWzEIMNePW/xX2tOU0anX0qPL4k8RVzg2AtxYcfaXAuFMbPdmn
         A5EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=serC0Qr3v1AkQ41cs9qFoAlejUw/dVTynlDISylCuz8=;
        fh=JkRc4CmBscswfodZbFfY1X9uWNLxtEXfRyfy2vx07Q4=;
        b=WpGMzn2x+03n8Rfkb46xW+ibHWQlN5rLePPYvd5jr/UrKihE4Es31GdA598j+rcOLq
         uN2hATb5jC3A4yiGbaknEr769FjgKuOVQ3E8MG0luKlitwGGsf8QeB9PIaeQwNliLX+z
         Re8YjXtK0hcUGlfMFcizzWVwhADF90u9e2UMvAS4XOOv2DBXVaZ520JDqpYFs3TuiKp+
         ZYD2hrQyYCtQct3ro8sVUeL5P007bYvBb4SxsUbTjmIZou/TAVX5nyKJj21Db7zbjZnt
         socFCbyS03+NkwMbczY8/t6DwZdtT5aCPwesj+OTdkQt7re9H4k2Xf0hCmJUo+7Ka2cm
         bFhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792977040; x=1793581840; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=serC0Qr3v1AkQ41cs9qFoAlejUw/dVTynlDISylCuz8=;
        b=j7DU650b9CBT6VakrS2SIu1g6ym7tEZKpotIt/RfLu2VrjyYQk02cX25/YabrTZOlG
         1Piv9K5m0+A80LVb2zrX1DTU3bILpLGNUJ910D7jfe84Xe4BECm2wSCJ84caL7m3xOFR
         YcjRf9UOTshv75OlWXf/09lcm3dUSs9XP24BUiLkZ236dnhAID1XXYDpzdOi6RVc+Oj9
         m797n69g5HghL1bUslfCDHPvVhfVF+2Iu2TfAbHFxei9Yy/cVcKnzbsXMKsSx9nwuvJg
         6J7F/A5Kdf8uSAe/oYatbQu44XcSyrmbUQJ4wxKhsfaf8CdvV2xACVuHnU3c5LRq2sPL
         xtvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792977040; x=1793581840;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=serC0Qr3v1AkQ41cs9qFoAlejUw/dVTynlDISylCuz8=;
        b=WSgjKjkL8y/Lb9oBAk1H6xjszAeghhxycuv7lN8YmIo1rpRVwYi7KE+C1GHFYaILYV
         CsHcVd+m8kcd8RCJ28gOh9fglcVlUg7a7XkfMd9pdMRUQGVebQb/9khY/JkFSWqKKoiO
         mbKErNQ01bqK1lSdG1fkZFaTrDCzKu05bniNMckgKdY8gc1mmA3JkIvuKpYNBqSGJQw1
         1grdAMbXd+BWOL3PYXyns2b/TxnSz3al7EzLFG42naOlfZHELgq7S7cHbM57VhW1h6kk
         baMwIyrFJlAQabLcSk+G1hCnsl46/gvnef8FHbMhUNvFbBapmRlPSiGpz6KQJ2omAzAf
         VjHA==
X-Forwarded-Encrypted: i=1; AKwUvBxQQqYtG/YGFVUxR1YCmAaDUlBD3zuwscNJiO1/f2Jh3PkvTEpQ0YUQiVi46RVRMMBkonPA5wIaIg==@kvack.org
X-Gm-Message-State: AFq9FYJbVS66IkAtEvCTmCl3OE00ToJZMNV560PI33y+/k+Zqoqe2jpY
	pV8RtWVCifDqOFBDU/ei/0ccer4wC97071u725KiIO4W6a0Xx9S7OkMkLnQDIXcpAkf6AVBg26e
	2M6v0dRxmKhYJWAr9AiMXk+XGrNSpvtKdJU/+xQT1ug==
X-Gm-Gg: AYBFou2lxc7YUZ0IcD+1P9g5pzLovoSpNCzSSdweH9ucdNwIT1F9t7X2xIiw7QUZuys
	MOoAdCyX73IkuGw2CylLp+mcQUp/xlqVfdqRkUrg7FjBk1hDQqP6+8P1cY+75YXZ6G7/GoJvDhg
	MCVQDkkVADlMT6NtucKOA60YjQqUtgoUo0aPBUc6NKj5WAWPiRK1u+kIx+/mb4VSGA1LpK+OLjl
	Ok/IhYNQtvDUGONsofeYMjKbTYPLER/EXX9cpC5emwqIpSMfaAQ5Tg7/1SPgLJvDOqv+wsTBKyY
	VV9uLnHnc7VHghlx7WTuZQrF2+WhXV9+5LDCRIuerx5+VM+Mz1IjGuTEu0281TbjOgNBf1M/CSm
	Wf7dpwW6cW0br197C45s9ithVWJW66w7ft/5Z8I8m7+QMKViXnTdKRL1KcwwwXBoYjJC+rQ==
X-Received: by 2002:a05:6402:440b:b0:6ac:62c2:bd39 with SMTP id
 4fb4d7f45d1cf-6b442fe12famr6368009a12.10.1792977039532; Sun, 25 Oct 2026
 18:10:39 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
 <20261020144710.4154339-2-pasha.tatashin@soleen.com> <atsMZW4ChOWj7Lqv@kernel.org>
In-Reply-To: <atsMZW4ChOWj7Lqv@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 25 Oct 2026 21:10:02 -0400
X-Gm-Features: AclHuK-SGyJEu7JWPJQ5FgiFjB9NPuO2-XlJh__utMnCfsTc4KvmMW8PdPmX4kI
Message-ID: <CA+CK2bD_=gwB-py6U3Y9pdc7RRoACeK9cqyHo65Q2ZKTyKaC2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to
 freeze sessions early
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, graf@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7CBAF1C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: yymz4yyagqac51b1gg56167h6d3zg5yp
X-HE-Tag: 1792977041-607163
X-HE-Meta: U2FsdGVkX1/vGMlRBByjlCdlpNM3OV1tGiojESuHwJtwL/JOzItBMo749/T+UFVhUh/LSNFZndidE97nN7b5WE9GIFr+ZOdybcf3wjf/DVKNlSpGX5OwroF4eT07k7l6pf1REnWeXoAUJ9a3k8sR1unkeLIE2F0+21MP0mIunDoOA5EoXMyDth9jfpLqnq1QVkX2dfPvtWuSwxyHfs497wU9mbD+4pKCpkAIwylguZM+wuvPKUJZXxtQPttuaTjOVFgFK7kxMziceXX2DndCg+dK1F2BivdQv6Qj0+LNiyT6r7x07N061LNlS7wOd/DgGYOuajZJjqxwfswDj+HFFj/ElwH20oP9VlabzteKEV2IxNfxPEXhJnyCB720sUz5mh63uhMEdOwpcH93DtuZ/pB+9Udk7RVQcESsGaPetLtNFk41KnSKTG6K6Wnz2gSmBRtuGk2qr0F+sBK6cwpUMmooGA+Er3xix5u0D479NwyWFHCeIZ2jg7PED8Ixe5/UQ/LeUhysogGg5Jw6DBOuXu5+u2IpOuSa/ws84Lv1LzY019qERKcuWKmazmSz/XfsfH4s1c9RWavEjmiVlXTX2OfjqbcOEZha06q3glt7+eeQZHpCERz6zbEVUbbJPSCpF3gMIDPDMv6a8yAcHermfq/IT5S2NQRYz0mMRRMONGFTmKFxapfjs7BopLFhlUhBHWVeGOuZgA48au8OuLN5QP2e/sDoIufv5Fcr98IBUtZulESROKqsriXop7Z9iBd4nDxedCkkePtBHqLIJXChiC4yOip3dz8AQOvlm/7QlcPzDfZfVO1mqAj0ONAlVJASe9ka7u1/Iq7wxv/j31OsEDhKos4urgiGx7wE0n5ncVSPdd+rCjN5ZNv1Jduhxz36H8bhT45LLC+vF0J6WKEvmkRwwgeDOhjWuPCOJB9EwIWN+iAvvdzH5I7GJBuVUA5NjkPAiY7viCLOnskhOOS
 vOV8mLDZ
 ZibgBmA7MkShRLfvtO7xd9/wYiBLBB4pvVATabo0JrNY7Una9I2KsrQLzRjCTZUwXwUrjqQmbsKEko4MIkgDVFZ1op47hU6HuJdbrGT/FimzGETDPHPQeKzH9pimtpc0f0SlCxK8nrkDwRq68oh0u7aOXAuIlds5Pq/JiZKew6o21vRS4LgGjWdkuyGXTbfcgny2kT1TIm0o6LV1ngAazy62yKGJCo3SdUZfAdd6D4+vIzmY0feRw1szW//L1OlIhm5KPXAyrMjWSSt6cBIIBjrBAudC2Go1JWMSufNfYmRMX4BsVDF1PPACFItczWdZw7TRwF/hpU++QZNj1m6kLZ+MKqI1RDVmnkBNyUuebBzOJUn5IHQdmdx0p46bHitvi1rxGvdhv1T/k6J0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 3:27=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Oct 20, 2026 at 10:47:03AM -0400, Pasha Tatashin wrote:
> > Currently, LUO sessions are frozen automatically only inside the
> > reboot(LINUX_REBOOT_CMD_KEXEC) pathway, where luo_session_serialize()
> > iterates through all outgoing sessions under global write locks and
> > freezes them serially during shutdown. Allowing userspace to decide whe=
n
> > to freeze a session once it is done with it (and to freeze multiple
> > sessions in parallel, since luo_session_freeze() only acquires the
> > per-session mutex) avoids postponing this work to kexec shutdown and
> > reduces blackout time.
> >
> > Introduce LIVEUPDATE_SESSION_FREEZE on session file descriptors to free=
ze
> > a session early. The ioctl runs .freeze() across all preserved files in=
 the
> > session and serializes their metadata. Once frozen, no additional files=
 can
> > be added to the session, and subsequent freeze calls return -EBUSY. Fre=
eze
> > is only valid on outgoing sessions and returns -EINVAL on incoming ones=
.
> >
> > During kexec, sessions that were already frozen early are skipped, whil=
e
> > sessions that did not invoke this ioctl auto-freeze as before. If an
> > early-frozen session is released before kexec, its files are rolled bac=
k
> > via .unfreeze() before being unpreserved.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/liveupdate.h       |  3 +-
> >  include/uapi/linux/liveupdate.h  | 25 ++++++++++
> >  kernel/liveupdate/luo_file.c     | 73 +++++++++++++---------------
> >  kernel/liveupdate/luo_internal.h |  9 ++--
> >  kernel/liveupdate/luo_session.c  | 82 +++++++++++++++++++++++++-------
> >  mm/memfd_luo.c                   |  5 +-
> >  6 files changed, 134 insertions(+), 63 deletions(-)
> >
> > diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> > index 6051abc0612c..851692571e13 100644
> > --- a/include/linux/liveupdate.h
> > +++ b/include/linux/liveupdate.h
> > @@ -59,7 +59,8 @@ struct liveupdate_file_op_args {
> >   *                compatible with the given file.
> >   * @preserve:     Required. Performs state-saving for the file.
> >   * @unpreserve:   Required. Cleans up any resources allocated by @pres=
erve.
> > - * @freeze:       Optional. Final actions just before kernel transitio=
n.
> > + * @freeze:       Optional. Prepares final state before kexec (via
> > + *                LIVEUPDATE_SESSION_FREEZE or during reboot).
> >   * @unfreeze:     Optional. Undo freeze operations.
> >   * @retrieve:     Required. Restores the file in the new kernel.
> >   * @can_finish:   Optional. Check if this FD can finish, i.e. all rest=
oration
> > diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveu=
pdate.h
> > index 4043d4038712..1644c502521e 100644
> > --- a/include/uapi/linux/liveupdate.h
> > +++ b/include/uapi/linux/liveupdate.h
> > @@ -60,6 +60,7 @@ enum {
> >       LIVEUPDATE_CMD_SESSION_RETRIEVE_FD =3D 0x41,
> >       LIVEUPDATE_CMD_SESSION_FINISH =3D 0x42,
> >       LIVEUPDATE_CMD_SESSION_GET_NAME =3D 0x43,
> > +     LIVEUPDATE_CMD_SESSION_FREEZE =3D 0x44,
> >  };
> >
> >  /**
> > @@ -236,4 +237,28 @@ struct liveupdate_session_get_name {
> >  #define LIVEUPDATE_SESSION_GET_NAME                                  \
> >       _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
> >
> > +/**
> > + * struct liveupdate_session_freeze - ioctl(LIVEUPDATE_SESSION_FREEZE)
> > + * @size:     Input; sizeof(struct liveupdate_session_freeze)
> > + * @reserved: Input; Must be zero. Reserved for future use.
> > + *
> > + * Freezes the session early from userspace before the reboot kexec ph=
ase.
> > + *
> > + * When this ioctl is called, the kernel executes the .freeze() callba=
ck on all
> > + * preserved files in the session and serializes their metadata. Once =
frozen,
> > + * no further files can be preserved in the session.
> > + *
> > + * During the subsequent reboot kexec, this session is recognized as a=
lready
>
> Nit: kexec reboot

Ok

>
> > + * frozen and is skipped from the late auto freeze.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +struct liveupdate_session_freeze {
> > +     __u32           size;
> > +     __u32           reserved;
> > +};
> > +
> > +#define LIVEUPDATE_SESSION_FREEZE                                    \
> > +     _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FREEZE)
> > +
> >  #endif /* _UAPI_LIVEUPDATE_H */
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.=
c
> > index a39992da504f..7f79890beb31 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -31,9 +31,9 @@
> >   *   - unpreserve(): Cleans up any resources allocated by .preserve(),=
 called
> >   *     if the preservation process is aborted before the reboot (i.e. =
session is
> >   *     closed).
> > - *   - freeze(): A final pre-reboot opportunity to prepare the state f=
or kexec.
> > - *     We are already in reboot syscall, and therefore userspace canno=
t mutate
> > - *     the file anymore.
> > + *   - freeze(): Prepares the final state for kexec. Invoked either ea=
rly via
>
> Nit: I'd drop "early", it seems relevant only to the current change, but
> will be more confusing than useful later.

Good point, will do.

>
> > + *     the LIVEUPDATE_SESSION_FREEZE ioctl once userspace is done modi=
fying
> > + *     the session's files, or during the reboot() syscall.
> >   *   - unfreeze(): Undoes the actions of .freeze(), called if the live=
 update
> >   *     is aborted after the freeze phase.
> >   *   - retrieve(): Reconstructs the file in the new kernel from the pr=
eserved
> > @@ -48,7 +48,8 @@
> >   *    handler, calls its .preserve() operation, and creates an interna=
l &struct
> >   *    luo_file to track the live state.
> >   *
> > - * 2. Freeze (Pre-Reboot): Just before the kexec, luo_file_freeze() is=
 called.
> > + * 2. Freeze (Pre-Reboot): Either explicitly via LIVEUPDATE_SESSION_FR=
EEZE or
> > + *    just before the kexec during reboot(), luo_file_freeze() is call=
ed.
> >   *    It iterates through all preserved files, calls their respective =
.freeze()
> >   *    operation, and serializes their final metadata (compatible strin=
g, token,
> >   *    and data handle) into a contiguous memory block for KHO.
> > @@ -74,15 +75,16 @@
> >   *
> >   * 1. Abort Before Reboot: If the userspace agent aborts the live upda=
te
> >   *    process before calling reboot (e.g., by closing the session file
> > - *    descriptor), the session's release handler calls
> > - *    luo_file_unpreserve_files(). This invokes the .unpreserve() call=
back on
> > - *    all preserved files, ensuring all allocated resources are cleane=
d up and
> > - *    returning the system to a clean state.
> > + *    descriptor), the session's release handler unfreezes the files i=
f the
> > + *    session was already frozen and calls luo_file_unpreserve_files()=
. This
> > + *    invokes the .unpreserve() callback on all preserved files, ensur=
ing all
> > + *    allocated resources are cleaned up and returning the system to a=
 clean
> > + *    state.
> >   *
> > - * 2. Freeze Failure: During the reboot() syscall, if any handler's .f=
reeze()
> > - *    op fails, the .unfreeze() op is invoked on all previously *succe=
ssful*
> > - *    freezes to roll back their state. The reboot() syscall then retu=
rns an
> > - *    error to userspace, canceling the live update.
> > + * 2. Freeze Failure: During LIVEUPDATE_SESSION_FREEZE or the reboot()=
 syscall,
> > + *    if any handler's .freeze() op fails, the .unfreeze() op is invok=
ed on all
> > + *    previously *successful* freezes to roll back their state, and an=
 error is
> > + *    returned to userspace.
>
> I think we still want to say that freeze failure at reboot cancels live
> update.

OK

>
> >   *
> >   * 3. Finish Failure: In the new kernel, if a handler's .finish() op f=
ails,
> >   *    the luo_file_finish() operation is aborted. LUO retains ownershi=
p of
> > @@ -440,12 +442,11 @@ static void __luo_file_unfreeze(struct luo_file_s=
et *file_set,
> >
> >  /**
> >   * luo_file_freeze - Freezes all preserved files and serializes their =
metadata.
> > - * @file_set:     The file_set whose files are to be frozen.
> > - * @file_set_ser: Where to put the serialized file_set.
> > + * @file_set: The file_set whose files are to be frozen.
> >   *
> > - * This function is called from the reboot() syscall path, just before=
 the
> > - * kernel transitions to the new image via kexec. Its purpose is to pe=
rform the
> > - * final preparation and serialization of all preserved files in the f=
ile_set.
> > + * This function is called from LIVEUPDATE_SESSION_FREEZE or from the =
reboot()
> > + * syscall path. Its purpose is to perform the preparation and seriali=
zation of
>
> Nit:                                          ^ final?

OK

>
> > + * all preserved files in the file_set.
> >   *
> >   * It iterates through each preserved file in FIFO order (the order of
> >   * preservation) and performs two main actions:
> > @@ -457,22 +458,20 @@ static void __luo_file_unfreeze(struct luo_file_s=
et *file_set,
> >   *
> >   * 2. Serializes Metadata: After a successful freeze, it copies the fi=
nal file
> >   *    metadata=E2=80=94the handler's compatible string, the user token=
, and the final
> > - *    private data handle=E2=80=94into the pre-allocated contiguous me=
mory buffer
> > - *    (file_set->files) that will be handed over to the next kernel vi=
a KHO.
> > + *    private data handle=E2=80=94into the pre-allocated serialization=
 blocks
> > + *    (file_set->block_set) that will be handed over to the next kerne=
l via KHO.
> >   *
> >   * Error Handling (Rollback):
> >   * This function is atomic. If any handler's .freeze() operation fails=
, the
> > - * entire live update is aborted. The __luo_file_unfreeze() helper is
> > - * immediately called to invoke the .unfreeze() op on all files that w=
ere
> > - * successfully frozen before the point of failure, rolling them back =
to a
> > - * running state. The function then returns an error, causing the rebo=
ot()
> > - * syscall to fail.
> > + * __luo_file_unfreeze() helper is immediately called to invoke the .u=
nfreeze()
> > + * op on all files that were successfully frozen before the point of f=
ailure,
> > + * rolling them back to an unfrozen state, and an error is returned to=
 the
> > + * caller.
>
> Don't you want to say that reboot is canceled here too?

Sure

>
> >   *
> > - * Context: Called only from the liveupdate_reboot() path.
> > + * Context: Called from LIVEUPDATE_SESSION_FREEZE or the liveupdate_re=
boot() path.
> >   * Return: 0 on success, or a negative errno on failure.
> >   */
> > -int luo_file_freeze(struct luo_file_set *file_set,
> > -                 struct luo_file_set_ser *file_set_ser)
> > +int luo_file_freeze(struct luo_file_set *file_set)
> >  {
> >       struct luo_file *luo_file;
> >       struct kho_block_set_it it;
> > @@ -506,9 +505,6 @@ int luo_file_freeze(struct luo_file_set *file_set,
> >               file_ser->token =3D luo_file->token;
> >       }
> >
> > -     file_set_ser->count =3D file_set->count;
> > -     file_set_ser->files =3D kho_block_set_head_pa(&file_set->block_se=
t);
> > -
> >       return 0;
> >
> >  err_unfreeze:
> > @@ -519,28 +515,25 @@ int luo_file_freeze(struct luo_file_set *file_set=
,
> >
> >  /**
> >   * luo_file_unfreeze - Unfreezes all files in a file_set and clear ser=
ialization
> > - * @file_set:     The file_set whose files are to be unfrozen.
> > - * @file_set_ser: Serialized file_set.
> > + * @file_set: The file_set whose files are to be unfrozen.
> >   *
> >   * This function rolls back the state of all files in a file_set after=
 the
> > - * freeze phase has begun but must be aborted. It is the counterpart t=
o
> > - * luo_file_freeze().
> > + * freeze phase has begun. It is the counterpart to luo_file_freeze().
> >   *
> >   * It invokes the __luo_file_unfreeze() helper with a NULL argument, w=
hich
> > - * signals the helper to iterate through all files in the file_set and=
 call
> > - * their respective .unfreeze() handler callbacks.
> > + * signals the helper to iterate through all files in the file_set, ca=
ll their
> > + * respective .unfreeze() handler callbacks, and clear the serialized =
blocks.
> >   *
> >   * Context: This is called when the live update is aborted during
> > - *          the reboot() syscall, after luo_file_freeze() has been cal=
led.
> > + *          the reboot() syscall, after luo_file_freeze() has been cal=
led,
> > + *          or when an early-frozen session is released before kexec.
> >   */
> > -void luo_file_unfreeze(struct luo_file_set *file_set,
> > -                    struct luo_file_set_ser *file_set_ser)
> > +void luo_file_unfreeze(struct luo_file_set *file_set)
>
> I went several time back and forth trying to understand why we remove
> *file_set_ser here.
>
> Maybe add a preparation patch that does the renames and moves file_set_se=
r
> handling?

Yes, this is a good suggestion. I will add another patch  to rename,
and change the argument.

>
> >  {
> >       if (!file_set->count)
> >               return;
> >
> >       __luo_file_unfreeze(file_set, NULL);
> > -     memset(file_set_ser, 0, sizeof(*file_set_ser));
> >  }
> >
> >  /**
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_i=
nternal.h
> > index dac6644bfb18..b3fc3dcf5f36 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -64,6 +64,8 @@ struct luo_file_set {
> >   *              previous kernel) sessions.
> >   * @retrieved:  A boolean flag indicating whether this session has bee=
n
> >   *              retrieved by a consumer in the new kernel.
> > + * @frozen:     A boolean flag indicating whether this session has bee=
n
> > + *              frozen early from userspace.
>
> s/early/explicitly

OK

>
> >   * @file_set:   A set of files that belong to this session.
> >   * @mutex:      protects fields in the luo_session.
> >   */
> > @@ -71,6 +73,7 @@ struct luo_session {
> >       char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> >       struct list_head list;
> >       bool retrieved;
> > +     bool frozen;
> >       struct luo_file_set file_set;
> >       struct mutex mutex;
> >  };
>
> --
> Sincerely yours,
> Mike.

