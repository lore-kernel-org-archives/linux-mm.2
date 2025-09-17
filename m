Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985C1CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00AC78E0068; Wed, 17 Sep 2025 16:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE67C8E0012; Wed, 17 Sep 2025 16:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD4E8E0068; Wed, 17 Sep 2025 16:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0CCE8E0012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:23:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F592160692
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:23:16 +0000 (UTC)
X-FDA: 83899866792.26.60C4EA1
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7FF5B1C000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:23:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DuKuUZ8e;
	spf=pass (imf20.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758140594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQYyUFKyIMwcbN0Oi1nix7mefhyosUBnMaKUMp/0Uhw=;
	b=OTFcoAjP/CMtbfaFISDbWPYkgGv/7MGpp9cmpfXEI9Fk06P6bpc2iCFzBubj+hezRY0XN8
	ziZNyFmfmSeM8oc4DObN286dN0J5iHaRY2vEjQgIAOIH5COk6UdVPIXQlqTUkNIH1WUEDH
	BPOzTnWIclgk5a1P/JXMNmVBCryXFR0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DuKuUZ8e;
	spf=pass (imf20.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758140594; a=rsa-sha256;
	cv=none;
	b=GWEkzazkL13lDEFc+dR57Cg5kn718xvjcJek1qUvpAgKfXdq/TF3OacME1xZ/AZYd6kvUF
	3ekr2I/MKNCvtGVQEMZwiBs1pMAz6cF6/r4G2vMp8kfg9egX0H22RPvgMcgjBcmC+vEilG
	f7PDAk+GWw0nwnd/5r26MAtnob6TjXU=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-62ee43b5e5bso252247a12.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758140593; x=1758745393; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQYyUFKyIMwcbN0Oi1nix7mefhyosUBnMaKUMp/0Uhw=;
        b=DuKuUZ8ey40KyRA3obxZYYrvI5wOH1gb50mmwIU0rczs9mOONguityGVowgLopJGMx
         lWIsNx9nSy53+bXwfA2UhQfCmall61+oVdaTnWyxcLmjhyzXfPsojsIZsGJaJPa9uc2s
         Wc1LLWU4AAFPe5KWGQykhdQ9P5fZqi4bmVoIJ350HSAHJSFJJApwErKdIg9vAweRWBy/
         wFkHaVPZQFoHKlqGTzvTURb/8rPZ5heL7KwynrgRmd0I5rCZp2JZzkB5Mxrl4tpgmUX/
         98zkTU8Y1rZAHi881mvUObwASmTze9MRYaWXovJEIN6tv9da8cEKJj4kMbiCyhSGPa0x
         laPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758140593; x=1758745393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQYyUFKyIMwcbN0Oi1nix7mefhyosUBnMaKUMp/0Uhw=;
        b=qVsALwNXDctsd9b17wSP0Yr3D2aeDaFRAhvj3Ac7Wg10EK8U+c65CQMAs89yWCVtYA
         lcJlWWms5ywae831z5mzcRHbO1mXA7muNMZ+0eaQFZJSN0V815UyOQmQ1gTcEpl/yA3w
         urXN3Rs/2GsAfKB8TYn6hHscVZFhypp+n191m07mB0qJinL8zcwtZ2Wuuk5EiaG7DPK4
         f4hkCMliAIUvQTMvxUa0MFRgIZBcP2ETttmaHj++WVelSswWvD8LGiq2QYCX3asYqSmw
         kFjPGn77KlmNILg8B7bJGZ2LIiHm2gskg8nh9V6qup2jb39oIesq2x+AV/DUoPmJjIcg
         xAWw==
X-Forwarded-Encrypted: i=1; AJvYcCW+/KPK6fVPD4mGvDP2yhxVKk2owHnm7hd81szMxtEu8GYm1DbQHq+mHhQiqniN+6Ko0XS5WvkO+A==@kvack.org
X-Gm-Message-State: AOJu0YyvxlGbJ3sDLU3+cAjUXJNV9jqC7uFEHsy9igLJTN4VPHmUmYbg
	/7qgFt6VWBV/YEki0YF8lx4vnL6BBxndWgzIlI3TXc7bPmCeUSKs/2cLKKsX9zmGbsuvpEFSRD1
	W2uMu6WRqM7bKyYcM1WCPHgOYslkBqFw=
X-Gm-Gg: ASbGncupTdc1QwC2OeONKx+Ke8KMK3NJPrdxZa+ktnLUC+XeM+fd9jmn1kgMhA++8E9
	5Sp5jUdOSh8PZ1Dgi/yZz/GCWzetSBeAAolzCNtf1E9rfUcquogcB09rmAgHma8F6TQlFcvpaYl
	bRH5PVLuRBC83qG0cs0Hx1nz4nLMLaAuUkZyo7PsU29KJ3Giseu+ssj78n6474uYuRMvXANWFSQ
	uOjoJX7Nr4VnBdQ6l1G9gKjYIs8ahweRyMq99k/l3Mil05yvtKjqa2LUOCWcAog/IRv
X-Google-Smtp-Source: AGHT+IGbnxJUuKMIoax9837vUOwFa3uC5z5C8iuy02lVnujR8xNtpFbaO7bRafNJUiDUa0Pb4Cm8O1H0fKv6jLIS6Z0=
X-Received: by 2002:a05:6402:23cc:b0:61d:2096:1e92 with SMTP id
 4fb4d7f45d1cf-62f842255b5mr3411840a12.15.1758140592771; Wed, 17 Sep 2025
 13:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <20250917201408.GX39973@ZenIV>
In-Reply-To: <20250917201408.GX39973@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 22:23:00 +0200
X-Gm-Features: AS18NWAwEK0xFf7I_pMfTz6YWIzdztaknH-Q6eCKdbOqKCEVDU2t6psEcsI1304
Message-ID: <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7FF5B1C000B
X-Stat-Signature: hdzbqjowgfz8uu65of1za7hfoefckakk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758140594-789747
X-HE-Meta: U2FsdGVkX1/bleXB7TG0hameek78OYuENZlHe21b87hyXdLdWvx/eWeWMpEur8mU7VoZTUoq4erS94Zo9X/O+7/Da7w02j3bV8cd6/WUJ/Bs1cMJLvVof44YNsecKur7OBjOOl8n5blipqpN6pMV2SHpHH6fS8aZS61sXqr0JkUcbZWr+OAfqpn4sRiMEEQD+bUiLie94h9+cFgJTsrvpJ4NCcXNcXNDh4dhsZZJ3RhkbQyTOcvfuSEjLC3dnPkO5br6+aW9Z4oO7S0w4CTL+cQb+Trn3tDyDyIK6REcHI4yZmS10NxnraFn2DkiQFUYTjX3GURPfGSqtxV83RjliXyhV8GONna1bKkiqOAyT9F4sez+4skXKkqRtchbfq7W77iQnnnVmwLQG8YzIVKI6kZhgdXI2NrKhPAz9F4f1IaCCC6+DNtHr33eZaI43QEAjCtcLCqy1A+wvwPBIhv8szn598nyRne9n6tEjkRAumjYWUZqyUsvGHh6X3BUzgP2/+3ri+80x0EfbDfnXp0HS9Pn2mCupvJgyycCc/uTKxziMPYRJK6TiIOcvy6/0JkKjme7p0p6QE5pWJTCq3s75I/LMHLpWh3vmyoZwBdlvSesVg+aU/RfA5l8740VMIfRL8E2scXAUZ+CPl5KmQ/SQt+tBWx7R5LsLxG4qWRgLOmRybPrVf2JkKfI7jTGtrzldPGC5S7nxabFQxtXfi0Pacw7nsdCrG07vuktFSmGo4Syo+qtJdVxEBlRbhAcZsg6OIHUI72ksU0rzlcv1w62Abh312bSguKDH/eoEE4bW7y9jyvrKkZdJtmjcb/JFptmaJEo3aBfK+4CbeT2lGcnqoecKBWx/dAKWHkKlG+umPFaw8RZM6ZerqrrgHq6aqwDdXUyf+mSH6EZ8qyTCjN4CcT9QoDCs+IjC+CMPqnujltTK1NyKPbj7LigX5JjRAlFVRFVmJcdfdKAEEZGqlE
 YhCo/o2X
 rlUr/hksw4OQcz99oQDR94BF//x4e11BHhZJOJADBebksB+TKKmKfWRmAwz+u/hiL0c76s45j2syHfpXYmEH88hvj0PgU7dzl7hQfsP9tVj4yjZ71gtvLWvDFy/QpJf+i61HgDX5Mvk7Xy3UI8YH5Ylz5162XxckstNYImWhkryBSsAGvt+NpcF0w4sQ3EX60NDm73L399MFILnV0+kQQkagXql0KyiQ060p/p7xH1BIirB/g1kcIZ3LXvvyxh2Dj5Q6+dwWbMoBQoh5VCCWTpT539gwrMZuDm5edFNVbH9vbNAXQDnf1wiuf7a4mtBmltUQiVTatrjJzksbFWJf4NYUjA7m32J0ryO3RRZL/SbHDQZ2qFfO0+rRaMQ+Aq2t0mfX6LmfBQIZWexFlw8JurA5gSHWQkJCWojJc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:14=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:59:23AM +0200, Mateusz Guzik wrote:
>
> > A sketch, incomplete:
> > static DECLARE_DELAYED_WORK(delayed_ceph_iput_work, delayed_ceph_iput);
> >
> > static void __ceph_iput_async(struct callback_head *work)
> > {
> >         struct ceph_inode_info *ci =3D container_of(work, struct
> > ceph_inode_info, async_task_work);
> >         iput(&ci->netfs.inode);
> > }
> >
> > void ceph_iput_async(struct ceph_inode_info *ci)
> > {
> >         struct inode *inode =3D &ci->netfs.inode;
> >
> >         if (atomic_add_unless(&inode->i_count, -1, 1))
> >                 return;
> >
> >         if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> >                 init_task_work(&ci->async_task_work, __ceph_iput_async)=
;
> >                 if (!task_work_add(task, &ci->async_task_work, TWA_RESU=
ME))
> >                         return;
> >         }
> >
> >         if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
> >                 schedule_delayed_work(&delayed_ceph_iput_work, 1);
> > }
>
> Looks rather dangerous - what do you do on fs shutdown?

Can you elaborate?

This should be equivalent to some random piece of code holding onto a
reference for a time.

I would expect whatever unmount/other teardown would proceed after it
gets rid of it.

Although for the queue at hand something can force flush it.

