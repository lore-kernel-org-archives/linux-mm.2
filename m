Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7678F606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XSsUQVe8
Received: by kanga.kvack.org (Postfix)
	id 8AB2C6B05B2; Fri,  6 Nov 2026 10:19:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BE86B05B3; Fri,  6 Nov 2026 10:19:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A976B05B4; Fri,  6 Nov 2026 10:19:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7EC6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:19:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE694C01EA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:19:32 +0000 (UTC)
X-FDA: 85405053384.28.CE7DFEE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C24D140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:19:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XSsUQVe8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793978370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6QE5LUaMLGNUcgDxlWZZglb/NRd2D5dLMiLzKGOWzQ=;
	b=iS7G8IqFvWDrqng9GjxFvi/NwJIOqusVb2dMs6dFBVu23Dnj++VsjmwA1UIhCCaYiDNdxB
	NKll3HYo4WaviR8yjYhCRGn/evxotRB/vnPfqddHRNFROYmm6c7SECwy2/4u469a0Q7eZr
	a1lwpd9QTs1PL6gcsDZU1ZgYAiVjppE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793978370;
	b=IMxGxl4wcwEtJE5WjZdY3GruB+mJgTdgCcY7FCjfsHHzVZcDZrvONTsjONVuNl+a2opCG0
	xdGYiNYLaMaK1zGUHN74GOa8/WdnY+hX08VPeCw77YZtIEUdsSbcfhzfc0IRdBeMZPuOVb
	Lyt6+ETANgYcBiYHv7WeGDC+kU1ptYM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XSsUQVe8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793978369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L6QE5LUaMLGNUcgDxlWZZglb/NRd2D5dLMiLzKGOWzQ=;
	b=XSsUQVe8VT7EWIhJ0znkr+xVFSQ0ZNC6KUuIAgUj02mQE2VXf0shz87nDpdZwtijdmuaEP
	qQd0IWWsbhYT/SngKZNjctEEp+csgLqzjgd4UuQuZTFw3cJCPQ9+D8ducCbN5NqcjvbiQe
	NEPx0bN4s4sL02kXTLDaZFE1t4OJhlk=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-aQ67O7lBOdmK2vSD0tii-A-1; Fri, 06 Nov 2026 10:19:28 -0500
X-MC-Unique: aQ67O7lBOdmK2vSD0tii-A-1
X-Mimecast-MFC-AGG-ID: aQ67O7lBOdmK2vSD0tii-A_1793978368
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cc89e86e9eso842518b6e.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 07:19:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793978368; x=1794583168;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L6QE5LUaMLGNUcgDxlWZZglb/NRd2D5dLMiLzKGOWzQ=;
        b=wZ8zvhFRettoXEGqQ68hQgV2aMvL0nJyS1HlWIFL8to8e2Z8xhZ7xsT9Ln05bq6Thz
         QChXuqT4LOYzHg1uF62r71YsPyHLWLXtLC+HPH2593IC3Xtt4zwJNSRDcylymkPHReC/
         yvtFuiVDEQ4THNBSiru3TxdjtNA4eQ6KLdP3cL6kXtqU8IvJnxSLkA6HAc0LfqnhhkJI
         xeAAl81b53DtpZvpsEykRlKzj/oc55fp2rskVfn+xupEopUj7vJVqL8n9R0snWU6v/0L
         f29AdL/mC35g7nkdd7OQcqbQAGQTNoPMcaiGdrgGjzB8dpxcJNWqa40LlXH4hpxiUSpp
         Bc6w==
X-Forwarded-Encrypted: i=1; AKwUvBwamvqpG6pBZqyBXx0rzI0NDidTb/vYaSq/loziirhyfd8ZYisERk061MYGNSdbNPixrjr6QcdKGQ==@kvack.org
X-Gm-Message-State: APuU4Z/uR1rSF5fRCzmCHyH5ahc/0GV3NeOKJsm7HYudelbKB+sPD3uh
	Rr86oJ9QLIVQ3QEyjxMz+YAv9lWAtJsn6YAp2M3ITlhL/1Gkv4GQTksioE/eetkWJoG05QVJZpg
	wUTZwmHH/8KS0oV08hnd/XAzNDW3m4KulqJGA5SkJa7/G5qh0h4S9dWCsZRGn+m/OsI7AEQpgzf
	em9dTlr1B/DLcvvHQB+SCb30BtZno=
X-Gm-Gg: AYBFou3TzCqmED/0JVUBaaliJ0bgxdntzpCrRNUErPFO+HZgkdRisLnyQXj2Z6USZzN
	sfBLfcVPud16I1f6lZjKBLqIWw16BjJ6A9Wv7RtzX/TR7yYygNtzE2Aujwgv1ut7EOnL2Qu4opt
	4UZq6MMkZeeu5aBJakHJrNFKy3kYw1GMFfXimW+5H2UKMH8NbLFIxzoii6
X-Received: by 2002:a05:6808:6413:b0:4e9:3412:14ac with SMTP id 5614622812f47-567e10ac541mr2034263b6e.33.1793978367840;
        Fri, 06 Nov 2026 07:19:27 -0800 (PST)
X-Received: by 2002:a05:6808:6413:b0:4e9:3412:14ac with SMTP id
 5614622812f47-567e10ac541mr2034200b6e.33.1793978367246; Fri, 06 Nov 2026
 07:19:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-6-1819a017000b@redhat.com> <sashiko-outbox-198921@kernel.org>
In-Reply-To: <sashiko-outbox-198921@kernel.org>
From: Albert Esteve <aesteve@redhat.com>
Date: Fri, 6 Nov 2026 16:19:15 +0100
X-Gm-Features: AclHuK_9kd4-vi33h14qEUizW5VOTBDWrh0Qg0FV14Te6uxs8q7OXuaFrYepPH8
Message-ID: <CADSE00LW0+EwEg8OBXUzZSkAu1-X=ofX5Dirq0+gbTTBUho6_w@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] selinux: Restrict cross-cgroup dma-buf charging
To: sashiko-reviews@lists.linux.dev
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
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org, media-ci@linuxtv.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j89chBgh9C1Parjx2cwBiUzvRXosOSzKnBygju7zelg_1793978368
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bhta8j53ngy5nfn97cmypxwyeoj8ci5c
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C24D140007
X-HE-Tag: 1793978370-896702
X-HE-Meta: U2FsdGVkX18+RZoKWKTP7wZUdArZG/Mihm8PiFX5LcNschckidmUstQr0AWpmnlW6j6D+hRGDMV4CBMF6Ke7mRWatksjFAslfInU1Rlr3G0TdUFxM9aOwjZ3FcsZ/0S2+L0f8figahZBve9esdq4hkvACtZjjOfuJU95rqo1KM9WIedkcAJn33B9D13s8Z1OIaobzGQOD2zta5hEMvYsNIamloQ8/g3VhGH8c3uGVesGxw0C5G3MieEdX7UmClDmS6YZfFEEKjl3yZCHdNQca7VV/h6IWAWP9wXKol/G6gGy4BJA7b0tJWgV3qpPec1OBM5tnDKm/LOHJmimrmx22F6vNmhiPUuastReOzP7odE/OzSlAQyblHNp8sEfnDjg+fVSXp3iT+UufUHx6gX7rXvx53RBiweOzUtgXoF/R3qZsUmgV5j7VBVlvrM7ETcP5BpobJ5SHPIgTiyF3MZEYRQleaAVAKen1W9LDaG7/2GCidoz/sNoNS+0c95Jt1e1rPGeSMIQtHPT8RN/kd7UEj5Jnvnk4508xqd09QdGJGr9xXgpvD9iXRvdrcNB1ZbvWAJ62qa0DSsGA2UCRQ9wIVI+ryk/8joVWtBNdTwvTP+lHrhTMjJXRx1GvRR+sfE7loU6a67FOcJqX/sG+XRB+/+G6NRiZ52tXfITLiKTdoNgr6vx1g/qrVze2VOc3pYWGz2O7LGYmhJCu7XMCPnrpK/79BFopGGJG7BkVQZKQVAyROhRPLtcVLwOQDb3bri025r+69b8AFtD3rGP+qUC7xMr70upn8J2NAh/iIjqCwfuVIt3GAutEHd1j4Q73aeWZM0Nqp98+NeXeDAQDrsgQklJJKjLzR32hQyt2FsRcs7+mibxH+iQWcONI/SbsaQlHJM7Q+LmvclKXDHdc3pY6YsF5n/bCHVbNyT2YW4iERLzA8+G32de6rTg2U2fFpQhokFvxtrpmXFlwRNjKVk
 gi90tStb
 PTSYUHDdiJUBjC3SC8+/q9b45vlxFHmyXtmaqkuWm3eqtdjXCKYu11PuGWAqjV4WCqRrX0VI5BlmJRxdm+nwxdRKPL8CDeRQZk1B/jXROebxPdAFtpv/TGKMVG75lvqtR8/xI/4INole1BDJL8YBZamnLJSJk8oraEJJcm9+b7QuNUJ+QE5/neqfhjLQQOMVaXSxnN+4gEOWEL4MsO2ElezF2kEWPZYCimjpfOtODl0H4oojWd/8WB1h+P5r+Kuw8824SzyCkeK/cThF2NcfCynDHXcw5oiWfD8ZPkIsdwBLAaxkKloV62/yGxy2X+5H7hPXB5eF7A723LqOlkh8+8ekLJAIfsTOORE8GWbu7b874e7O4wZUdUnUcCe75owyvNb/DqD+VJVaSr2r9qXDV5Jf/tU9Tog5LIp2qXhb0ItULU04RBf/19UIuvTyy+Tch/RCLlXWT8MuLZZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 12:12=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] selinux: one-off dma_buf class instead of general cgroup acces=
s control model
> --
>
> commit 675e985fff50ea6716b8c00023a75c07ff345a6f
> Author: Albert Esteve <aesteve@redhat.com>
>
> selinux: Restrict cross-cgroup dma-buf charging
>
> This commit implements the selinux_dma_buf_charge_task() hook and adds a
> new dma_buf object class with a charge_task permission in SELinux to
> restrict cross-cgroup dma-buf memory charging.
>
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 30776b0107f29..8f39d91eabc97 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2204,6 +2204,12 @@ static int selinux_capable(const struct cred *cr=
ed, struct user_namespace *ns,
> >       return cred_has_capability(cred, cap, opts, ns =3D=3D &init_user_=
ns);
> >  }
> >
> > +static int selinux_dma_buf_charge_task(const struct cred *from, const =
struct cred *to)
> > +{
> > +     return avc_has_perm(cred_sid(from), cred_sid(to),
> > +                         SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL)=
;
> > +}
> > +
> >  static int selinux_quotactl(int cmds, int type, int id, const struct s=
uper_block *sb)
> >  {
> >       const struct cred *cred =3D current_cred();
>
> [ ... ]
>
> > diff --git a/security/selinux/include/classmap.h b/security/selinux/inc=
lude/classmap.h
> > index 90cb61b164256..b4ebedc6e4240 100644
> > --- a/security/selinux/include/classmap.h
> > +++ b/security/selinux/include/classmap.h
> > @@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] =
=3D {
> >       { "user_namespace", { "create", NULL } },
> >       { "memfd_file",
> >         { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } }=
,
> > +     { "dma_buf", { "charge_task", NULL } },
>
> [Severity: Medium]
> As reported by Paul Moore on RFC [1], adding a one-off SELinux object cla=
ss
> and permission for a specific subsystem's cgroup charging (previously
> dma_heap with charge_to, now dma_buf with charge_task in secclass_map[]
> and selinux_dma_buf_charge_task(), along with charge_cgroup in a later
> patch in this series) introduces a narrow, subsystem-specific policy clas=
s
> rather than a general cgroup and resource access control model for SELinu=
x.
>
> Although resolving the target memcg from charge_fd moved into generic
> memcontrol code in mem_cgroup_get_from_fd(), the SELinux hook in
> selinux_dma_buf_charge_task() and class definition in secclass_map[] stil=
l
> define a dma-buf-specific class instead of a broader cgroup access contro=
l
> abstraction.
>
> Should this permission check be designed around a general cgroup or resou=
rce
> SELinux object class rather than a one-off dma_buf class?
>
> [1] https://lore.kernel.org/r/16093a0278a6d7d1a0a8bc055c228bed@paul-moore=
.com

I held off on this so the core charging proposal could settle first,
and then refine the LSM side later / in a separate series depending on
the feedback.

For v5 I'm adding a capability baseline in mem_cgroup_get_from_fd()
following a Sashiko report, so that charging a memcg outside the
caller's own subtree requires CAP_SYS_RESOURCE. With that in place the
LSM hooks no longer act as the only check, they add finer-grained
policy on top of it. Also, unlike the RFC, they are now called from
generic memcg code rather than dma-buf code, so I should have renamed
them (and plan to) to security_memcg_charge_{task,cgroup}().

Regarding the broader cgroup model, as far as I can tell, existing
cgroup control points are kernfs file operations, which SELinux
already covers. The only non-file operations taking a cgroup fd (i.e.,
BPF attach and perf cgroup events) use their own subsystem classes.
Since remote charging in this series consumes the target cgroup's
resources, checking against the cgroup's label (as patch 7 already
does) sounds like a good fit.

So to Sashiko remark and Paul's comment, rather than a dma-buf
specific class, would something like a "cgroup" class with a
"charge_to" permission for the cgroupfd path, and a process (process2
really) permission for the pidfd path, be an acceptable first step,
with the class growing as other non-file control points come up? I'm
happy to adjust the naming or structure to what works best.

BR,
Albert




>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-v2_20230=
123_tjmercier_google_com-v4-0-1819a017000b@redhat.com?part=3D6
>


