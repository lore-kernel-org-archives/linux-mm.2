Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31D3606A332
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i/sjixNX
Received: by kanga.kvack.org (Postfix)
	id 6EF626B0A6F; Wed, 25 Nov 2026 11:15:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0086B0A71; Wed, 25 Nov 2026 11:15:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5675F6B0A72; Wed, 25 Nov 2026 11:15:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25F526B0A6F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:15:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFA7080F8A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:15:18 +0000 (UTC)
X-FDA: 85474141116.07.3B37649
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A7DE4000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:15:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i/sjixNX";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795623316;
	b=zSebqflZbgbWM83KaK9EFDxvnQMSISzlEVuAqgDdoweBc3JJP2vO7lUOe0I6iur/t8M86j
	8ishtfa+WQvjKco0SuCiAp+r9lgTeFvmB4/k35IwPzpv0nD/0Z0rwtK54zNcMqKSjB6iTe
	pxCFHY3mqykFnN7IamJ7RyZWvNakvoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795623316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
	b=Ek5vs5sV/cFY4xnQwLJjTXxym8s0izqN6xdnRDKaqsToxD0H+2QYyjx0umfFJ0LIZiemir
	V9bJOsqC10cPXwo7oU14PKWZqLWEMzCaVSmjwsrtWd4k2lIWmCFJa4zHqjarF16Az8z1Nf
	9ebZw5Q85msrABv5zYQnekqTiOGIlRU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i/sjixNX";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795623315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
	b=i/sjixNXl3r5GPHHEFkXv16gfjzbESzfNVL+ELEJP8IXgC4d6JItv2XIW99mQrRl1Ae7EN
	JpqjHWOAZU4a5Fjkiq1+rNwD7BhIuQYI6HNj5I8e93fBjbpdisUya3eIamMnAxo9zgMC4z
	OdS6ezqPxtWPhICnw+5EVyI9KbcLxNk=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668--itD0hx9MkO4zYQYDVScjg-1; Wed, 25 Nov 2026 16:15:08 +0000
X-MC-Unique: -itD0hx9MkO4zYQYDVScjg-1
X-Mimecast-MFC-AGG-ID: -itD0hx9MkO4zYQYDVScjg_1795623308
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4e937c5bd4fso5072251b6e.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795623308; x=1796228108;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ikIAQDWUd4oIdUiwPTrXqLa3Yct6IL/NQnfK5N4xiCQ=;
        b=gS6UiHCA/Yoy84xt1TW7S4wt7SilUT5jSLJmUAkblURaNArEKjKmT+FiRqEy4PpiAS
         HhuhGUCkTZbCtJQAlZrYLG/rtn7TpSHWGSzNIySZeuj8O7Xx7SDUIQXCU3SdIe50dSaR
         50oMcCPlHDq2LVeEwtmFo3wggYRCdPzjWwKiickO9cVG60UcO7SvAQe8RdloTinMT8+j
         mWWAjWJ02ukcBgbSw84cnL2r7zkRbdGuNljvxP6wB92SvRG004G4bEwE4f5ybz+2JU0Y
         PwHkc6Kykq8KZGnGUSpOEDrPH/jThpldaW18X8RdiEDuSWGP6G5Ct8eVQxLj8Wz/HMRg
         65Wg==
X-Forwarded-Encrypted: i=1; AL+hErEakM64tJd7kwiTCPlSqMaiJfwz+bnRKD9DObqJJg5JTU29O06eJXBwTRgiOCdyfV7LkpxDm20LBg==@kvack.org
X-Gm-Message-State: APuU4Z+YZaz/rkL3BnzeeOKHotQGp/fr/ebibKM4wd5MQZWAGX2iMkrt
	Wcw8lueWoN+HkxE91DsD6WL2R/OipQGxNXSVSBmT5PfNP953Ko707RzdQCS3//Vt18+96dh/AZJ
	o6XoaqzgnpjAXu5D3oWd+j/r6YSr/uZT4aK1ee3Gs/R7Z1PcgQiLILtWBsh8YPSBkwZdBBp41Lb
	fi5KjedG1qorGkPCZnqO7PmMkybgw=
X-Gm-Gg: AZFdTZc/bzIMaPl/OqhL+oSaKq4sGQOnrYf4wah7wgg9NoVjjSjjTTwJjunr7+r/99w
	ZZGfZ+8zhSm29ECxmB+zDt/4FKZnJofi9DpFniiHdRqWzr8RrYBRcKODC976xkf8BeXt5D32wy4
	2bx3RuIslK4tY7/OGhLRXRlUKU12WP7KbRHtnMUTXx/L/AKDg1di7A7o1Q
X-Received: by 2002:a05:6808:1a10:b0:564:48f3:dfa8 with SMTP id 5614622812f47-57a0a111c93mr20349873b6e.11.1795623307672;
        Wed, 25 Nov 2026 08:15:07 -0800 (PST)
X-Received: by 2002:a05:6808:1a10:b0:564:48f3:dfa8 with SMTP id
 5614622812f47-57a0a111c93mr20349798b6e.11.1795623307221; Wed, 25 Nov 2026
 08:15:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
 <20261124-v2_20230123_tjmercier_google_com-v6-6-dce12fa03ad6@redhat.com> <CAJ2a_DeDF+9pbLKS9pcX4Tot4xZZ-K7HydKnDjW6TWC5bvREzQ@mail.gmail.com>
In-Reply-To: <CAJ2a_DeDF+9pbLKS9pcX4Tot4xZZ-K7HydKnDjW6TWC5bvREzQ@mail.gmail.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 25 Nov 2026 17:14:55 +0100
X-Gm-Features: Aa3M54qg8B1tVY9MI_hj21-3fP47U-BOsj1Lrj8qIxJDIaifgpgCHqLTs9bOP0k
Message-ID: <CADSE00JMSXm4Vi5aH=k3VgLL__EsdEZgg_PqkSkK0LQumj1SUQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/7] selinux: Restrict cross-cgroup memcg charging
To: =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _vIiQunWgDsNfihPzI4Cf9hamsfbHWSOCW0caNBzlpc_1795623308
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5A7DE4000E
X-Stat-Signature: csncoiwh7wxt5aiu74zcmhmf4u9kyeiw
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795623316-831253
X-HE-Meta: U2FsdGVkX1/q8Ql4sLe6ytpVl7bFqxKVdFi5GmXBUNd4KSSOCbxW001eXsBiBDNpXdtGrNEnKRW868e95WGfRsG/rSneXH9lXpn4L2u6JHGTcY8VyQ2oGSV0C42PRgN0M9B1bD71jzyIU1dcJIvkB4fomd6jsFA0t460ob/tciUXRHqMu0MRlzJfaPFDHZdnwOksRcKLu6PfFeJfvZOkvyP9KvH0Ddffk4crjwekyDqGGJ8j/7KRIhjVcu56Hrp2P6OiFTop6lL1ereTNZOKu2rKp+WK+xrhXRxWYdMHgiw1k20V9yLUrfF/SG/NFpvb6Fmu/640VfXE8l9tJk3AkoMV3GmiaWiTLoxKnZ6n6pqwtjObshN71teNyX5waQ7AGOGnYc8F3f5MVpaI2tJIZqFyWdIE6t+5V/y90AQkejb7oZhc4XvWeym0Ltjrc/taFY0MFeyFwTNm0hdQ/9Enkvdd3T5Ctn2wMgz0ATm4bu467FgJVQ/enrvY5o8Kar4u6xOwtbxR7fI9SCTFAxZzBhfy0P8Yobs/gBkaDg49lIW1IJyXIGQdwAEBl0oiyK91amlrJsNJEYQjExt8hvQWYM3E7OZXNipSOCTWwRFhgxTCDgilOyiyjW1ER48k/zL33uINm/EIBHXhHBXEEJgXUUg87C7rfNej7tNLniIce++8kQPGfMncgA609kLiiE0INpKoyFQeoB8rPUo34FghAvEDHRNssCKJWVVIyAIxBzni3e8yVtJFJSEqbV0CXqXolGAmVDYQreyXgGZSxdgCgIQxEZ/Ecd8SYTprRePYOyEsn64AT2MAYlpRnzJCtj8IT24BR1Jc6OXBnFhjQdqURa34aS1EHRaXMn2cP0R54CPjIX/MYfzViZwqYInSNqyoJ/WV+xN0BpetbcDHXh4Mde+42861nHb0RyEAnmA3HjOPlbAXfUQ1hzOV47kSezrh/62w4UKPJKA/bCBX/M4
 hhu7XSjW
 c+bqRGBFdnB2r31IVyIqs/wSfZun61RiVrbx6ij8ykd8BhYiD6NIfWTjc/LXUUyCQQWs1Woi26MaIr+2FkHyeum1RCvzZ/n3J3oYlE13OKDm5xDNFpRRtkz+2eh+NOHhhGlpcRIv6m2y/qB1Q9S9HevITeDB1JQKZCFQ1ZnHio93PNrDtz88M/H4UHxmIGS9+atxJTUswlhjpvx5m75Oxhyzg6Ky5XzPE8G1Hqa04L76AMMZ4sF2N3XIyGkCbgJ4CjQofm2CZUmThlk1cWkoX3hLG7NHdfEKWJsTJMWynQvwUPk7yMR3ZFZiKisgb8567C+Xaz4w2xKpYPxljYAz7X7nbgIWRNfvimTM9OT3fNn6ktDSHnQgI5P8PR/q55iJHJ3umSuiFyPfbRnOTSHKRrU1EFjX+vLDf8DMmjxy/5GZs0HSwwnPOHu7ge40BeO9CzlOM7bhbh955xPGLV6Qa9MbTVzfbin8EohrojJ2iBiAH/0GBdz8wUHMHjNzMdJjMv4s81wuBZRnSCZkj7IH1Y4Bte6vuPMip24x//MFf9nLN8M0wd2X+1wDsrp7btFOySgvJLrl7ZBSEOsfxOmpKaufkpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 2:50=E2=80=AFPM Christian G=C3=B6ttsche
<cgzones@googlemail.com> wrote:
>
> On Tue, 24 Nov 2026 at 14:05, Albert Esteve <aesteve@redhat.com> wrote:
> >
> > The security_current_memcg_charge_task() and
> > security_current_memcg_charge_cgroup() hooks allow security modules to
> > control which processes may charge or transfer memcg memory to another
> > process's cgroup, named by a pidfd, or to an arbitrary cgroup named by
> > a cgroupfd, both passed in charge_fd. Without a policy implementation,
> > either hook is a no-op and the restriction is not enforced.
> >
> > On SELinux-managed systems the only limit is CAP_SYS_RESOURCE. A
> > domain that holds both dma-heap access (today's only exporter that
> > opts-in) and that capability, can charge memory to any cgroup outside
> > its own subtree. Since the capability is all-or-nothing, SELinux
> > policy cannot express which targets such a domain may charge to.
> >
> > Implement both selinux_memcg_charge_task() and
> > selinux_memcg_charge_cgroup() using avc_has_perm() with a new cgroup
> > object class and a new charge_to permission. Both charge_fd flavours
> > ultimately charge a cgroup, so one permission covers them and the
> > target type keeps the distinction: for the pidfd path the target is
> > the referred task's SID, as there is no cgroup object to take a label
> > from; for the cgroupfd path it is the cgroup directory's inode SID,
> > which comes from the genfscon entry for cgroupfs unless the directory
> > is relabeled.
> >
> > The checks run when the charge target is resolved, before the
> > CAP_SYS_RESOURCE baseline is evaluated, and apply to every explicit
> > charge_fd target, including the caller's own subtree, so policy needs
> > a rule even for self-charging. Policy authors can then grant
> > cross-cgroup charging selectively, for example:
> >
> >   allow allocator_app_t client_app_t:cgroup charge_to;
> >   allow allocator_app_t cgroup_t:cgroup charge_to;
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  security/selinux/hooks.c            | 19 +++++++++++++++++++
> >  security/selinux/include/classmap.h |  1 +
> >  2 files changed, 20 insertions(+)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 6c4c64d6e904..76a714107ae4 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2204,6 +2204,23 @@ static int selinux_capable(const struct cred *cr=
ed, struct user_namespace *ns,
> >         return cred_has_capability(cred, cap, opts, ns =3D=3D &init_use=
r_ns);
> >  }
> >
> > +static int selinux_memcg_charge_task(const struct cred *to)
> > +{
> > +       const struct cred *cred =3D current_cred();
> > +
> > +       return avc_has_perm(cred_sid(cred), cred_sid(to),
>
> Small nit:
> `cred_sid(current_cred())` could be simplified using `current_sid()`

Nice, thanks! I will apply that for the next version.

>
> > +                           SECCLASS_CGROUP, CGROUP__CHARGE_TO, NULL);
> > +}
> > +
> > +static int selinux_memcg_charge_cgroup(const struct file *file)
> > +{
> > +       const struct cred *cred =3D current_cred();
> > +       struct inode_security_struct *isec =3D inode_security(file_inod=
e(file));
> > +
> > +       return avc_has_perm(cred_sid(cred), isec->sid, SECCLASS_CGROUP,
> > +                           CGROUP__CHARGE_TO, NULL);
> > +}
> > +
> >  static int selinux_quotactl(int cmds, int type, int id, const struct s=
uper_block *sb)
> >  {
> >         const struct cred *cred =3D current_cred();
> > @@ -7683,6 +7700,8 @@ static struct security_hook_list selinux_hooks[] =
__ro_after_init =3D {
> >         LSM_HOOK_INIT(capget, selinux_capget),
> >         LSM_HOOK_INIT(capset, selinux_capset),
> >         LSM_HOOK_INIT(capable, selinux_capable),
> > +       LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
> > +       LSM_HOOK_INIT(memcg_charge_cgroup, selinux_memcg_charge_cgroup)=
,
> >         LSM_HOOK_INIT(quotactl, selinux_quotactl),
> >         LSM_HOOK_INIT(quota_on, selinux_quota_on),
> >         LSM_HOOK_INIT(syslog, selinux_syslog),
> > diff --git a/security/selinux/include/classmap.h b/security/selinux/inc=
lude/classmap.h
> > index 90cb61b16425..1f1f2fc4d35d 100644
> > --- a/security/selinux/include/classmap.h
> > +++ b/security/selinux/include/classmap.h
> > @@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] =
=3D {
> >         { "user_namespace", { "create", NULL } },
> >         { "memfd_file",
> >           { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL }=
 },
> > +       { "cgroup", { "charge_to", NULL } },
> >         /* last one */ { NULL, {} }
> >  };
> >
> >
> > --
> > 2.55.0
> >
> >
>


