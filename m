Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F7960A2609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QXfsJqiv
Received: by kanga.kvack.org (Postfix)
	id 562B26B05B8; Wed, 18 Nov 2026 08:55:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512226B05B9; Wed, 18 Nov 2026 08:55:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DAE56B05BA; Wed, 18 Nov 2026 08:55:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 157B76B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:55:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96D1214071C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:55:40 +0000 (UTC)
X-FDA: 85448387640.05.FE8EDB5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49DA4180003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:55:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QXfsJqiv;
	spf=pass (imf16.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795010138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
	b=5smvX2F67Ee1AGNShFiDGZXedQm0A+6E2zJX8ACj+VzvXZpU8QY6lTWKkAfp3j0V7tBqA5
	snolLXeR+ajlzPqfDmYdmAHhGxHYTwUOzLZ3PCbhAlCR/QLgBEBnzx0S44qzeRExzM0TH8
	DQzNYdHdhkayOl5/rxPYzonJYzzX3Rc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795010138;
	b=lnsB2qr0Xcjg5TJADTi9uYn/DoNuvvXi2izmGrVJ3yXb0s2Abo5Q0ueWV//hCzwVoJ5I52
	i0VhOydQfo8TJg4kOQCByG6nTfBglDMsTAa7uTnf+buURgxb/zso/ACCU/EPXqwj+kD+DL
	zjwmLN137fiOpWBJWcYHsP/lYMbuqYI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QXfsJqiv;
	spf=pass (imf16.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795010137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
	b=QXfsJqivqBNqfL8AggaLxuMEBU7EfXUwQ79yX9mkY0DsyoJKv14Jj/OiqP17IwmtwHUvtm
	hDttkoYGz0xiCc9jOMzkOF5g6m+QAdI/wa8hDJ5BtVIpXff4tFeOjBu8nPrel8lbwUuT3W
	PR8WTtsSxNEPBpbDUz0KfAdFrL/sUoM=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-0m4JkTk0Ngy2qqQw0qNC6Q-1; Wed, 18 Nov 2026 08:55:36 -0500
X-MC-Unique: 0m4JkTk0Ngy2qqQw0qNC6Q-1
X-Mimecast-MFC-AGG-ID: 0m4JkTk0Ngy2qqQw0qNC6Q_1795010136
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-67bec5d62ebso1419883d50.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:55:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795010136; x=1795614936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
        b=sXpMfB+cynEkqxmAz4Rsi7h9l3gdwMMDLb9YO33TREuY/ePGwZE4OYWC7wuOZ7+Jjz
         uCnVV2Ffi84q3ufbV3oEhdgM5GFSopBLEdBlWPPgsBn3Dw+jJR4RB7TvZP3ikqI+Oske
         Bq/WR41Gu+tfGV3WxRM1+zbuxBnDPDMcUSJFkTVDCsr66RSFuGa0M8+50849bX0DcMvS
         sJBrHCjLNOx6ksWLqggfDm9DJpCRhK97tvTOTgllPYEqMSlIJOmo/fIYVg3Fvvhb0UAd
         obahmze59Zep+Her/wiQxV/Ym/BIyuKqO+IJDriY9d4AjztJcCzvSEDwo4kstvuolqL+
         A/gg==
X-Forwarded-Encrypted: i=1; AL+hErHDpdV11JpN5KIuOLIPW9udThNE5+mFrIL9scbyCiLEo2SQBQ/NYGrGvc97FbS4/x6c/XgEmQ45jg==@kvack.org
X-Gm-Message-State: APuU4Z/uqqwz5eXrIQL+FRR4BnFHL7XUbPHe24XesOd+YcY+oKPSyucS
	ib5TGczR0v9ZJLZFp134pC8Ewyni9LUXR/kyMLiljCOF8Yf5CeIJJC6Rg4U9sfcJxNSZCsuszDg
	bHJkWrDvNrmvlQzT9JSw4aSWT331Hcc5wd7lh+rgDDNg2r+M7ZZzHgFuR4IxrUxTofuSe4f7Ijh
	+BqJg6O6Et9dBCHLwNWPHWVX2PDrM=
X-Gm-Gg: AZFdTZfseco+2i8KVrF2xvSCwMGHKR8OH48cRAT39c4TlAcoiW0IGH2FnQoM4NU+hwc
	OkOk1sWFfYGCoQe4KL720Mc9mGHmaqm6Xuvmd5vbx+edBbiJ1Hhop/1pN3p6ywTZjcYCFYt8CDo
	ujNQpWjOtUgqucJZWZYC1MJSkcQxuYslGk16+SMs+uwHKdhPvE5C1S5rkz
X-Received: by 2002:a05:690e:1387:b0:67b:f249:5b16 with SMTP id 956f58d0204a3-67dd3fdee8amr1338606d50.55.1795010135885;
        Wed, 18 Nov 2026 05:55:35 -0800 (PST)
X-Received: by 2002:a05:690e:1387:b0:67b:f249:5b16 with SMTP id
 956f58d0204a3-67dd3fdee8amr1338592d50.55.1795010135440; Wed, 18 Nov 2026
 05:55:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-v2_20230123_tjmercier_google_com-v5-4-1ce975f2a9ad@redhat.com>
 <44c0c45c0e2f47ed77bc45be47ebb3fb@paul-moore.com>
In-Reply-To: <44c0c45c0e2f47ed77bc45be47ebb3fb@paul-moore.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 18 Nov 2026 14:55:24 +0100
X-Gm-Features: Aa3M54okPSWfJ_g3ixS3iw1yy5owTDFGTKhnOXZ64bND8Gaqu8R-9XYtSNGyOOw
Message-ID: <CADSE00LVsFVOmezzLgPrPWDd+L+SSGzGvqKTiX25waxRnVPh9Q@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] lsm: Add memcg_charge_task LSM hook
To: Paul Moore <paul@paul-moore.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4zvfgczZhu9C1tSBcLdzocCk4bTXRUBwZKkn_HVjvwk_1795010136
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7fxrkeykgom3pksn97itb9fwy656owbf
X-Rspam-User: 
X-Rspamd-Queue-Id: 49DA4180003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795010138-662342
X-HE-Meta: U2FsdGVkX19OgMuh147yrSrNp4i4raqU9KPId/xnHHeYyB91DZ/L/bcXu1EyisEzpFKphbPNRiMaJS0lADOebAdaZsVNvqhaU1mJg5aCBEfWlDyPaVUz7RBY0E8es+hl4e+F+Ch36kkZcQMQag5YiGiBphfbV7Fg4udlagRT2V6r6hJg29DzCzkoMXx2ekdFH/9zgehOzN6I7GrQxcVbURycCqIbp5MYJSaiFMTzP4YnirqFKjnrToUITK3Tz8hvWSIXbsIYaaFqh/nODLc3B6HQ7bDBrcpEpnwNEutuhv8vMLHRQBlbblMJwFBskUraOaXl7co1XP7A7Fh2GPNkNj1ef5zNq1XXIiCIn1noKlB4K6HaHiDLOn/anN9i3JbUUigaFbW9oRwBq/p/UTXzcRfKmFe2u3Co/s+GjY74HU+LGvpjU19YAvb3blgVVAvlg8pWv3FMSsAdYr/yePX/tYJLETJ/kVnYKqjONrZxuLrg27NxLlhW88qlbij6ayZkoa1ZmZqd0iXiTrCtbJsUoVBIsqAKp35wS6k+aDQc2JjD9qMApFmoBU63yBk0uqDrY957gKWkcEeIG6q+DjkRbTLHyqVCnZ71c8HcTBhBB2Yk6KwrM1VBVPNiduMWGOGWLtazFtygF+MSa67i5eCtgKDc01ChFMMBKeJdftW79w6C+T2oe/2knDanJjf6UM0fvs/wuZ0woE+MfjTP85b/Bss6UM8vNtkGltqQAjCadEzlWAfLXC15wZL11XPBbXHjfcF+FHWuca/Fs62ASOa6QBLHYJ9DHWQY7rQGH8Hmzs65hi8Amf2Iz/65teLX6wK6xquXgHbO/LdP1NPHYM77cKRaliQGkOgD4YbXjWnRT3zW/FcvBEzLV/KlqonDp5XRxlw3SsOSetmMpNcMNaq1U9zZErRg+tH5twNjXt2igLiXt7Yv91xuQ2mgTyDbf4ZACJlJnPMB//vrKMH/iSx
 mCtk6jqr
 ghAViyqoR0+1t4Yg5jhVZOdTad3PhpYHnnRv7DDpsa+Ou+bqkJ8a67FGldq4Z7mGy+iDFjPbqB3GdtZ5zuq6T9tnpARzB4lhyr3Yx0IF5+Zw6+RB14wdWNwmDCRJCIfhxMSNuAhpr+MzGWzNUfzSU225EwIimXE7Exj5WgzNvS3SrY9fSLjxs2hnDZr7a/agsEVN6U+T82bXseAkJcrMvQ0DyrS26E5ovy0XP6J3jq7LMOLkXdQDFYHhfeGSbT94rJpfn8pqFadNCY8rMXl+Q1zBIDMuKGsF1CV0QSkidk7yLt4JPlxG46xmNM9eLiq3BfqBdnP8BLpTFDhXg6e1iCZfAholpHYN/mLRKlVzcXlfB9ZRJAqm0yEXLkZ5aaxUUwBS7kybtwA3DjSPVhOU8qu9RG3d0KSPsRXmP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:54=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
>
> On Nov 17, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> >
> > Both DMA_HEAP_IOCTL_ALLOC and the new DMA_BUF_IOCTL_XFER_CHARGE ioctl
> > accept a charge_fd field that, when set, causes the allocation to be
> > charged to an arbitrary process's cgroup rather than the caller's.
> >
> > Charging is currently limited to the caller's own memcg subtree unless
> > the caller holds CAP_SYS_RESOURCE. But the capability is all-or-nothing=
.
> > A process holding it, along with a dma-heap device node or a dma-buf
> > fd can charge unlimited memory to any other process's cgroup, potential=
ly
> > exhausting that cgroup's limit and triggering OOM kills independent of
> > the victim's own activity or privileges.
> >
> > Add security_memcg_charge_task(), called in get_obj_cgroup_from_fd()
> > when charge_fd refers to another process. The hook receives
> > the credentials of the allocating process (from) and the credentials
> > of the process whose cgroup will be charged (to), giving security
> > modules a controlled enforcement point for cross-cgroup objcg
> > attribution policy.
> >
> > When CONFIG_SECURITY is not set the hook compiles to an inline
> > returning 0, adding no overhead to the fast path.
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  include/linux/lsm_hook_defs.h |  1 +
> >  include/linux/security.h      |  7 +++++++
> >  mm/memcontrol.c               | 11 +++++++++++
> >  security/security.c           | 15 +++++++++++++++
> >  4 files changed, 34 insertions(+)
>
> ...
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 03cd90d5e623..2e6fcbe14d43 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -60,6 +60,7 @@
> >  #include <linux/lockdep.h>
> >  #include <linux/resume_user_mode.h>
> >  #include <linux/psi.h>
> > +#include <linux/security.h>
> >  #include <linux/seq_buf.h>
> >  #include <linux/sched/isolation.h>
> >  #include <linux/kmemleak.h>
> > @@ -3198,10 +3199,12 @@ static bool mem_cgroup_may_charge(struct mem_cg=
roup *memcg)
> >  struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
> >  {
> >       struct cgroup_subsys_state *css;
> > +     const struct cred *tcred;
> >       struct obj_cgroup *objcg;
> >       struct mem_cgroup *memcg;
> >       struct task_struct *task;
> >       unsigned int pidfd_flags;
> > +     int ret;
> >
> >       if (mem_cgroup_disabled())
> >               return ERR_PTR(-EOPNOTSUPP);
> > @@ -3226,6 +3229,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd=
)
> >               if (IS_ERR(task))
> >                       return ERR_CAST(task);
> >
> > +             tcred =3D get_task_cred(task);
> > +             ret =3D security_memcg_charge_task(current_cred(), tcred)=
;
>
> Do you ever envision this "from" cred being something other than
> current_cred()?

Good point. No, I do not.

> If the answer is "no", we might want to consider changing
> the LSM hook slightly to help prevent misuse in the future:
>
>   int security_current_memcg_charge_task(const struct cred *tcred);

Agreed. I'll apply the same to the cgroupfd variant for symmetry (its
"from" is also always current_cred()).

BR,
Albert.


>
> > +             put_cred(tcred);
> > +             if (ret) {
> > +                     put_task_struct(task);
> > +                     return ERR_PTR(ret);
> > +             }
> > +
> >               rcu_read_lock();
> >               css =3D task_css(task, memory_cgrp_id);
> >               put_task_struct(task);
>
> --
> paul-moore.com
>


