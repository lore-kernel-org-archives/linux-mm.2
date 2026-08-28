Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403FEC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 21:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1364E6B0088; Fri, 28 Aug 2026 17:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7F16B008A; Fri, 28 Aug 2026 17:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19F96B008C; Fri, 28 Aug 2026 17:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C49CA6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:04:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4ABEAA3C8D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:04:30 +0000 (UTC)
X-FDA: 85151906700.24.8C0073A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E9DC180009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:04:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=egnvUQik;
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787951068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rKm+GtqXHGkU+e3cRid3cEbHk6M59ahcc5GavJOWZg=;
	b=gjV1gA1WKwcpvbe4A3Y+2bn3K25/rwAAMp8zBFuUIv0Nzk0C05rJasnD2woW6PayZx8gJ+
	U4iuuo7JCS4pO1/BPk3Ml9ECszy4aTf8p+gltdczT+HdSbCkoFCyTBOMytszWTx6t40sfh
	OG+7XaI2yZ+CpD82fj2navsU7rFWtQc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787951068;
	b=rzByPp68jz+dU3M319RTcZ1aeyPGgd6FqO+P5K+yV8BIFSUJ60mwkCxW9IpccP8ritxgxs
	DJlniagK9TKVrqoyy64+W29/4tNXj1kOyPu3TqCh4OWqwKh1brnEJ/5rdp+JjCe4M0Wyfv
	HfYxCYy1NiYHnULtmRFAve2f7SC2KAs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=egnvUQik;
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8557c3f270eso996049b3a.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:04:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787951067; cv=none;
        d=google.com; s=arc-20260327;
        b=CgOjxxFCw5iu0cAANvJxHJlgGvE40uG61St3sEQGeWe5FlrTXXRymKKLPcXQHvA+Pz
         R4HNW3S2Ld5r+PbIMUIKSC/PaYJUzpQfeFqYq11rxrtv5l7wKC4YwpsFU0nPPVfj9IYO
         t3nQ6+i2tockxHk+TXTzRU26VfbpRgt1nfIWB3T2Olh5BjwqpQ75MbFEbFL1OoP9sWuI
         ZQA0oN3Mq+Dr5w2QeZDuxYNvOmwAnIOqPXjmI3zTU59QkBkZWlP5ZDi8BvObis8DokGn
         aivCi+bHddiakVY+jSWbbG/ZQlki28FOpGKqAM+ZXQ6NLMPxzg0MxoSfjrWgNQBHprho
         ifig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6rKm+GtqXHGkU+e3cRid3cEbHk6M59ahcc5GavJOWZg=;
        fh=TBJGOg9tExiLPTM3tLrArFfeORF53e7Q61JnS/oVlAw=;
        b=RJJsRiCm32nj4wUnp9QzkcTZxvcVQ1SIR8e8E2W1kX8gvwbZpK1BKxTN3VvZofFUy9
         rWGPgTpb72XRZRnOeLb1p9BUt2gAKZ2ZT+P+Gz+sgh0Gfm8Gr1fGraH72Hj7ll8wOFli
         HRP2u+VerrZnHB27aRTKnw1gYAaANYgCASxclYTHJhLuWPTLMPBbrV53lHIEHmFGT42v
         asGoEWBsBVshvryF856rpj9DOJyMuB98KRdAM6vBvE4bxi+kbcA1pZ/1lADoOIIkGBqr
         nyn+lt8t7ieHmgWYOGBKnEOQpLNSfWEnDnofCEap6/rXS9Y9zibOphxkuRID1osqJ6NF
         q7jg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1787951067; x=1788555867; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6rKm+GtqXHGkU+e3cRid3cEbHk6M59ahcc5GavJOWZg=;
        b=egnvUQik+aqYoxdfmerRU/Pb9wa3IM7lYvgcA9yrjc9d/+bVXd97vRRX+5MVgOxw/J
         M0Nk4E3Rv8t+NkfG26jmR7Y44lwvd8nXyeeK7TTjbv1a3K5CNhyLDb8a1HrsBy69J4ey
         BVHzntLCC7say2HueCAJmybmimCYKvFEbbYdfAntbckY3+QjvroAESB2VrJo6ZfIDHUO
         24W9ShfLZMal4T6iBWDq3FzoHZYOVJ+0nccqTQvfapB4JmJKtqTZnL1S1SH7xOsCT1jb
         NU31VqrqDx/mqZp4ZDi0xRv4v/QNfUpAxbEVGmfvNsN+EJtpg8eA02FeeTkjoanRB+9D
         d3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787951067; x=1788555867;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6rKm+GtqXHGkU+e3cRid3cEbHk6M59ahcc5GavJOWZg=;
        b=aNFUJPBDDnMC0vUiUJxzcm2QMK4PrkuMHHIf/5MnbCh6ICyfLHE8K2t4dWcdYlp2o2
         8N0S+1FrKehIyq1o9mfEtPWVHFfMWi4+8W3iLqwOvE+1zKV3Y0Gv/KEd/eAveW7jnhhu
         b0cU8LvNc9WK1yjOj+gTT7YzZ9Q0e7K+BGiuQ2HXSZVU5h50t/dl0/2oNGQ2nnTxoWbv
         IgL/7lq8WdpsTgYdJP/wLmAgxf5Fix4m2d9TtIwgSDQGtueHeX8VPe46fk6+opkphokL
         KvxmNrRPm/ngLjigy8EPa2x2NMJ5bMEDvbBYukxzoJlLzBRznBRsCrjiSQYpeu5yOZDh
         x2FA==
X-Forwarded-Encrypted: i=1; AHgh+RrcCGHdhaPEMGMiYs5b4mO7h165dIbA98nOlF+1BOFxP9Hk/7Ak5rt+iITi9ft2IxfE4s0uMEtX7w==@kvack.org
X-Gm-Message-State: AFuF++mgSM12iWVFYglKDY/q4HDj3DRIICoSGF0+XWIcO12QKTZ2NTGG
	B1kUGg/mYCHoKErHDTvqpj7YsBYyFo8ANbdD3xOmjtiQy7cS2MEKGkoKU+jxvtzl7ql29aLwdKj
	ZRKBoxYQh92FZpscM/v8diuIWvs6a32zckMNUaYtb
X-Gm-Gg: AR+sD137596aXjHf4Cll8KstCqbCu83NM/Z2CvoUbimXoOaDFKAsY0gqsQJf2CP7/9O
	HJesFX+7WwGKAZ5apLd2xC1fV+bD782tgbIOyyhgIfgG2JE2Lj/67FXQ1FSThXGcHTst4L5cqL4
	GwhBCLRS3opa9c6dsM/LGsj1VpggiNlp7y4O8r6d37AEli6hx5QR55dGwXrUG4Sh3xCYLtBYmE3
	ksxbBYJgvH8oei7SS5w4tgxlEFR33tfwYPbgR+cQ9yDr9F/ED0w3hisiDAz9lwVmaeHQVAVG+EP
	Rp5mtZf2ZO9n38DukkZX4PkHfksd825LLtrobM9qYj2dgQTE9JXtUgQ=
X-Received: by 2002:a05:6a00:2d82:b0:857:73e2:9106 with SMTP id
 d2e1a72fcca58-85773e29373mr3141018b3a.22.1787951066990; Fri, 28 Aug 2026
 14:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
 <82929c994076d95f99560ecc67f6cfce@paul-moore.com> <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
In-Reply-To: <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 28 Aug 2026 17:04:13 -0400
X-Gm-Features: AcwNN1XqU7CwGOxUd2wqJF7qUgFOnskAPT9XF2uIm2MO9atgOnmbTyVZNzUagTE
Message-ID: <CAHC9VhTmRsi7mLJM0Vak=aTj+NBO6piH-9YwVX5Kwh6yGPNsHg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: aausaz776ihxfobuxyybxuhtjfnc4ucr
X-Rspamd-Queue-Id: 4E9DC180009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787951068-174841
X-HE-Meta: U2FsdGVkX18k3A1gBoyMr/Ib6W2uUG/bbP0G7yYuzp/Vett+3BvadQJc6TjDj/OKC1IxKkuYLtij9r5vITiGHMO7gGCVdn76mvxfm/4DsLOkH0J11W5vmISPyRRyDRz7YojBv9VzNkadAQZq8WQ39eq4dbIWSgcpFtbKahluUB/BF3WXY1OQn6evBah7ZXHKmDyT8T7OmcryIEwP8uH4CfzCMn6b0QG874YR5uw26AmTY8ir7f1lXMLeW5fy3vtPGDMulT6QWniv4HVQ0mcygrBVgS2NZ0YfU5SWWUY5stzuVJdKhaHhhYayvyn6ESBRulWV5nN4UnVr4FYqoFCnDbH0OIUY5W2lKmcFPqX8W8WQkXJxHa21gV+amaQL9djT73PiLSZmMHjVBXQyu2emHXelfAKaFXgKSXNzAR/NLepZG6tHTwdAL/DKRt6ngd3HYuqxiYSL6/k3VmG0vyf+uP5vzjTl0EBdYHwA7iJswk6MAteDuUYMwYXK3p9F1Jtt/Nkdcm+6BDHrcqIA0zPW5KmWpNIUdoUn6716SInpzSz3Nn8qAs7fNYEkNr3GCoZLKkP05yu3AbOhGaj5zBfFs54lQEkulLFQIG8v4eqzuAtIItfEuCbq0hVcKKLiQjoxMskeNCE0z2ZpqpF5kz4ZifyDTATKzhJUfpJBu+w9/x0bXN7FO43zZO3OSGa+ks/0TMzvc+N/t+Vc2EEyc9PBlVO0GI4ldxKFYGz1qMnaX1U5dGXdHqovx63aDQWbUewBYiDvvTWua/RGMrApnvFfMD4G9zkZIIo9oJHAOMy5KGNxYgX/K4fYlbchbKMdSkb/ZEED/odU6ihUxQBh1BaLmO8b8B/u8VlTaVL8y4FeX3tgmyUO7sDtm97mJp4vcPqZx4lVZguizB1DSvx5LwbPWq3NpurYIXsoTOBXBCIbM1PmKvwCXCgdlG3CapujdN3fNMC+Ue6w/T5O5Y1WaxX
 ZaoVYf88
 GpBu2sK+9J5I7iWCj72MFnG0wzh5sHG2ucOg8BDGzhwtpS931IKA1h+1aTNuofOKOxK+0RAjftyzlAqO2A/IpTB2NoslJEwXBgTXP/Ly6Vwz9zuoIUOHoSpWrcONs8fiqi9uItoXFcpA/cJonUXLwwYX9rxaf8KG55sPud0vhwjwtOPlshQTwd57wtovp19UTW9+baJFBXla3gUmQe/ASvERcWwOVB7QR+PWRfVg5cIbC7yLZdOxsAkhJrOsYuSnbW59MnAUoyDg+w9HBcLlgPbVG3YMSGEzRFKJeA2RzHtYZmDvx0uVR0aKgMtQilp7nwuyK/LMot7OD/GS4IKCp7svkbcAHRODSPWBZEGtOVeFmviMRlf0kTnKd6NrlLQpZ9IVey3xzvVfzz358JlonJaOcBvG+NptftLIvBeHy9gkhI7AzyhkVj4YdwY/Q2aP2Hqv1pjW1U1GoeoKEGTVWIfblo5fHYcJKVRxl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 9:04=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
> On Fri, Aug 28, 2026 at 3:10=E2=80=AFAM Paul Moore <paul@paul-moore.com> =
wrote:
> > On Aug 25, 2026 Jann Horn <jannh@google.com> wrote:
> > > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently h=
ave no
> > > good opportunity to block a process from overwriting read-only code i=
n its
> > > own address space through FOLL_FORCE writes via /proc/self/mem.
> > > The security_ptrace_access_check() LSM hook is bypassed when a proces=
s
> > > opens /proc/self/mem because this is considered "introspection".
> > >
> > > This causes a hole in SELinux EXECMEM enforcement, which tries to ens=
ure
> > > that a process cannot create executable anonymous pages.
> > >
> > > PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > > accesses are only possible when the LSM allows ptrace() attachment; b=
ut it
> > > is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > > environments running lots of third-party code, such as Android.
> > >
> > > So, introduce a new LSM hook that can forbid FOLL_FORCE specifically =
for
> > > such "introspective" accesses.
> > >
> > > Signed-off-by: Jann Horn <jannh@google.com>
> > > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  fs/proc/base.c                |  9 +++++++++
> > >  include/linux/lsm_hook_defs.h |  1 +
> > >  include/linux/security.h      |  6 ++++++
> > >  security/security.c           | 20 ++++++++++++++++++++
> > >  4 files changed, 36 insertions(+)
> > >
> > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > index bec6197329dc..dc6fdcb47b79 100644
> > > --- a/fs/proc/base.c
> > > +++ b/fs/proc/base.c
> > > @@ -851,6 +851,11 @@ static int __mem_open(struct inode *inode, struc=
t file *file, unsigned int mode)
> > >  /* private_data for proc_mem_operations */
> > >  struct mem_private {
> > >       struct mm_struct *mm;
> > > +     /*
> > > +      * Was the ptrace access check on open bypassed because the ope=
ner used
> > > +      * the same MM (introspection)?
> > > +      */
> > > +     bool opened_by_owner;
> > >  };
> > >
> > >  static int mem_open(struct inode *inode, struct file *file)
> > > @@ -864,12 +869,14 @@ static int mem_open(struct inode *inode, struct=
 file *file)
> > >       priv->mm =3D proc_mem_open(inode, PTRACE_MODE_ATTACH);
> > >       if (IS_ERR_OR_NULL(priv->mm))
> > >               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > > +     priv->opened_by_owner =3D priv->mm =3D=3D current->mm;
> > >       file->private_data =3D no_free_ptr(priv);
> > >       return 0;
> > >  }
> > >
> > >  static bool proc_mem_foll_force(struct file *file, struct mm_struct =
*mm)
> > >  {
> > > +     struct mem_private *priv =3D file->private_data;
> > >       struct task_struct *task;
> > >       bool ptrace_active =3D false;
> > >
> > > @@ -886,6 +893,8 @@ static bool proc_mem_foll_force(struct file *file=
, struct mm_struct *mm)
> > >               }
> > >               return ptrace_active;
> > >       default:
> > > +             if (priv->opened_by_owner)
> > > +                     return security_mem_foll_force_opened_by_owner(=
file->f_cred) =3D=3D 0;
> > >               return true;
> > >       }
> > >  }
> >
> > First things first, we've got to shorten that hook name :)  What do you
> > think of security_proc_mem_foll_force()?
>
> If we move the "opened_by_owner" part into a flag then I guess that
> works... will do.
>
> > Beyond that, we really try to avoid making LSM hook calls conditional. =
 It
> > can limit what an LSM can enforce, it tends to be a bit more fragile, a=
nd
> > it adds some unnecessary work in the case where CONFIG_SECURITY is
> > disabled.  I would suggest passing 'opened_by_owner' flag as a second
> > parameter to the LSM hook and calling the hook unconditionally in the
> > default switch case as a replacement for the 'return true;' statement. =
 I
> > understand it may seem a bit odd, but we try to make the LSM interface =
as
> > generic as possible with respect to different models and this is one wa=
y
>
> I guess I can do that, but then the question becomes, what other modes
> of using the LSM hook that don't currently exist in the kernel should
> I be supporting with this? I can make this a parameter, but any LSM
> policy that actually uses the parameter in a different way would
> probably be buggy/inconsistent, unless other new LSM hooks are added.

Possibly.  People do all sorts of things with the LSM hooks, not all
of them relate to access control.

> If your intent is to make the hook work for any /proc/$pid/mem access,
> including when the caller is ptrace-attached, then I guess I have to
> move around the security hook call in proc_mem_foll_force() a little
> bit. I guess I'll do that in v3, though I really don't like trying to
> come up with a reasonable in-kernel API contract for a scenario that
> currently has zero users.

As I said, I don't really have a specific model/intent in mind other
than avoiding a conditional LSM hook call.

> > we do that.  It also ensures we don't have to process the 'opened_by_ow=
ner'
> > check in that case where the LSM is disabled.
>
> (I don't think that's an improvement - we have to do the comparison
> either way, but in the current version, we then use it to
> conditionally branch to a security hook, while the v3 patch will
> instead unconditionally call into the security hook.)

If we move the opened_by_owner check into the LSMs, in the
!CONFIG_SECURITY case we avoid the check entirely.  We try to do that
when we can to minimize impact of the LSM when it is disabled at build
time.

> > > +static inline int security_mem_foll_force_opened_by_owner(const stru=
ct cred *subject)
> > > +{
> > > +     return 0;
> > > +}
> >
> > With proc_mem_foll_force() currently returning true/1 in this case,
> > shouldn't the LSM hook return true/1 when disabled?
>
> No, I have proc_mem_foll_force() doing:
> "return security_mem_foll_force_opened_by_owner(file->f_cred) =3D=3D 0;"

Ah, forgive me, my mind stopped reading once it hit the closing
parenthesis!  That's not a common pattern for calling LSM hooks so my
brain wasn't expecting that :)

--=20
paul-moore.com

