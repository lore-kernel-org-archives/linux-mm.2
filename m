Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20FC9C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 21:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218A96B009F; Tue, 28 Jul 2026 17:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9356B00A1; Tue, 28 Jul 2026 17:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E03B6B00A2; Tue, 28 Jul 2026 17:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2F5A6B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:01:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A7B81203F9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:01:36 +0000 (UTC)
X-FDA: 85039406592.01.A22B480
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 16E794000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:01:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QTJLddYM;
	spf=pass (imf04.hostedemail.com: domain of sgrubb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=sgrubb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785272494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6ljGpY8syJ4kMz5EMeiC1JLhIm06ethqnnefWbD4tk=;
	b=x/m++vhOf+GzOV4mWqxNm+zlmgXFgPzGp5ef8yBwrSUTi9oJyUWBxGdyVJiZ1xwdr19ICz
	kDXjnpoaYOMQgFv+QIkTTMM+q1/OmHEN5B/ionYrvmEKQ2aRfrZtgkB9zEa/aXMBZEZ4fb
	XfRy8pnVZ9rpIBA96K2uDIYE5xw+gwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785272494;
	b=Iv5ev5a3RNkhHtU1+To2mRiZJtjMm+zhQbhwfo58vkpqXSZ6bfw2RuTahLgbyKjO3DNGT9
	tVlEaffkPpmL5lO4SQzIs2C2wYesx26FbNzcp4KFca4ZBS2Mu5EPVBInDFeqnIdk1/kMbd
	te12+n+JFLs136Y9Piui31U3sVFGzHo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QTJLddYM;
	spf=pass (imf04.hostedemail.com: domain of sgrubb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=sgrubb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785272493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G6ljGpY8syJ4kMz5EMeiC1JLhIm06ethqnnefWbD4tk=;
	b=QTJLddYMErHjd4B8h7UpeC9R2BVndcsokDor0g0TU0XOfcAkrSkbcla2IM4APgcBeL/iTk
	2adCtgPF8hn/VcfB9iLcabwgEESw7cbbbH1iR/snWV63myVB2EQnogKW8ZEWlyNdnA8vYY
	8ANiYPPYq3kX7aMv3A/mUDUMEvVKpeA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-9Nvn47XYOxiAzH--_WQp1g-1; Tue,
 28 Jul 2026 17:01:30 -0400
X-MC-Unique: 9Nvn47XYOxiAzH--_WQp1g-1
X-Mimecast-MFC-AGG-ID: 9Nvn47XYOxiAzH--_WQp1g_1785272488
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 235E0195608F;
	Tue, 28 Jul 2026 21:01:28 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.65.142])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28BAC414;
	Tue, 28 Jul 2026 21:01:24 +0000 (UTC)
From: Steve Grubb <sgrubb@redhat.com>
To: Ricardo Robaina <rrobaina@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
Cc: audit@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 paul@paul-moore.com, eparis@redhat.com, kees@kernel.org, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org
Subject: Re: [PATCH] audit: add CLONE3 auxiliary record to log process cloning
Date: Tue, 28 Jul 2026 17:01:21 -0400
Message-ID: <uK83gGq4RkGQKh1xACKbLw@redhat.com>
Organization: Red Hat
In-Reply-To: <amjZRgbKg7svHU7r@madcap2.tricolour.ca>
References: <20260724150258.560396-2-rrobaina@redhat.com>
 <amjZRgbKg7svHU7r@madcap2.tricolour.ca>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 5aR4uYWQY_I07EaMHfq_YYRqWKKQNE4ziTtWuLzWglo_1785272488
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16E794000C
X-Stat-Signature: sa3g4s55pcyiebwhj39ip9hk43k8p6ay
X-Rspam-User: 
X-HE-Tag: 1785272493-724427
X-HE-Meta: U2FsdGVkX19K/t8z+C+nvmja+YiR2VJ26U2urn3nQO5NKbQeKmX6bw/KL3dghkMrb4qOYcFPT3bn9HFW+n00dBQhdiiXuElI3th3XTrZEi2UZpm0IPH3jHDAadmptWWydkp+mmIgXqu+ED1b0NMBcGK5UIThhEHMQgjVvAsl9LDlUWWk6HGtrdiSTnRFbP9c2agOyvT8SR0vKL5r6PE7B48AM2M9oNxsQJZ45hn/PY2oR1z1oG7GYHq6Txg+rg8bTSCdof+2wZaPr9OWFRujqHViAA+TK9hYO39q+fk6D7DDEhwj4tp2ElzXh3c2o3DAZ4zH6xO4gp37wChbEay/kWJrL+IOLQtJFKLuWefLi9Hr9m27HAiqhsXW0NyIx3PvHqghLHDvzCXCEUulrelKJjAkIVR5qh9i+h3H8JMcEVd1735TJwZCVr2hcLjX05wwb/UFrdz5DZJ5PUMvYm4uTFF9S4dhUuJfidZBAIpu0AY7vZbKK2kiBV/VlYzq3TsU+s3da6elz2Bdc/JRCQ1/GEAIRq5wjNdb1MOrQ5l3WZxJBvw1YwgKwuLclTavydkpXXT7CemKn1dhBOPKLrEato1QsEx3KhjokjLbzt9kAWMB1RePC3RRsT+JmLQH9h2w6EoT/NJywHP/hI0Cir3d6BerrAsG75zqooEjZUG0rp8ZeZlQaQxqB4RnE0Hj3iyeN28raniqoxl17yjMaPFR8C7tVOUqAsAbkLezyfgsWNERYezqANqOza6eS2r2UJEkIPlP78imcers1O6443KnvSFbK6Is65Vct20PBc///EJqTtFpFvT1iq+I6z5wneejvnY4myab4lJFh+I4OHUFjNBWvb2B4Q0zbwN6PgLm5+j/eW5w6D3G3npxm8L7ilceWmfVN05C6CdArUvWpHAsz42j9yLkxQrG8TVhTQbS3M8p+gJnVSjIPk9/4vRzo3xrHeohhK0CQ+r7jfEL9zQ
 0E92mk7W
 ra27FzOZE9Kfe9XNKjJ4UmwoKzRuexvXhmFygi93Ano/0vUSTgGwwWKl0ITT0gsVOb1gPDgkkGtbBp0psC1XSbtfMXbWO1eGT+mVt3Q2/72XG7SyAAZNJ4EURwt9prgLzMZzNCa7uxq/nz2/R2wskhHMP2C5cw4STT2+xLpLbH1H0rvOuK3dsvb3lKRXkLaLXeEA5QRDkXbnsIc4N3UpBKQlQKCdBlIwI4qjq54850FcA31bqPAhTamgz1Hn4N1fiPVaPvvPyo0fM+l68wZ4xEhXk8A0rTKK83tirYsyVSffNBTFJREXVawg7Tf6CxOxqkMSzzR/4oZaC8dJbbHEXkH3gUv3URt9rAUxyTY3wWq8pgFs6TbxghiJri+yuTKS8YdICexBeBV0yu048ztT69chFjVJusL+7Z9Hj7T2L2LlmsgnsLy4UYWiyb9MW6sNHmeym
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tuesday, July 28, 2026 12:31:02=E2=80=AFPM Eastern Daylight Time Richard=
 Guy=20
Briggs wrote:
> On 2026-07-24 12:02, Ricardo Robaina wrote:
> > The clone3(2) syscall moves most parameters to struct clone_args.
> > For this reason, the generic SYSCALL audit record does not capture
> > the structured arguments.
> >=20
> > Add a CLONE3 auxiliary record that logs: flags, exit_signal, cgroup,
> > and pidfd fields from struct clone_args. When CLONE_PIDFD is set and
> > the syscall succeeds, the resolved pidfd is logged; otherwise
> > pidfd=3D(null).
> >=20
> >  ----
> >  type=3DSYSCALL : syscall=3Dclone3 a0=3D0x7ffe7f1ec640 a1=3D0x58 a2=3D0=
x0 ...
> >  type=3DCLONE3 : cl3_flags=3D0x1000 exit_signal=3D17 cgroup=3D0 pidfd=
=3D3
> >=20
> > Link: https://github.com/linux-audit/audit-kernel/issues/151
> > Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
> > ---
> >=20
> >  include/linux/audit.h      | 10 ++++++++++
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/auditsc.c           | 20 ++++++++++++++++++++
> >  kernel/fork.c              |  4 +++-
> >  4 files changed, 34 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 45abb3722d30..833f349bf415 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -449,6 +449,7 @@ extern void __audit_tk_injoffset(struct timespec64
> > offset);>=20
> >  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
> >  extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int
> >  nentries,> =20
> >  =09=09=09      enum audit_nfcfgop op, gfp_t gfp);
> >=20
> > +extern void __audit_log_clone3(struct kernel_clone_args *kargs, int
> > ret);
> >=20
> >  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
> >  {
> >=20
> > @@ -598,6 +599,12 @@ static inline void audit_log_nfcfg(const char *nam=
e,
> > u8 af,>=20
> >  =09=09__audit_log_nfcfg(name, af, nentries, op, gfp);
> > =20
> >  }
> >=20
> > +static inline void audit_log_clone3(struct kernel_clone_args *kargs, i=
nt
> > ret) +{
> > +=09if (!audit_dummy_context())
> > +=09=09__audit_log_clone3(kargs, ret);
> > +}
> > +
> >=20
> >  extern int audit_n_rules;
> >  extern int audit_signals;
> >  #else /* CONFIG_AUDITSYSCALL */
> >=20
> > @@ -730,6 +737,9 @@ static inline void audit_log_nfcfg(const char *name=
,
> > u8 af,>=20
> >  =09=09=09=09   enum audit_nfcfgop op, gfp_t gfp)
> > =20
> >  { }
> >=20
> > +static inline void audit_log_clone3(struct kernel_clone_args *kargs, i=
nt
> > ret) +{ }
> > +
> >=20
> >  #define audit_n_rules 0
> >  #define audit_signals 0
> >  #endif /* CONFIG_AUDITSYSCALL */
> >=20
> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index e8f5ce677df7..37357e17adbf 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -122,6 +122,7 @@
> >=20
> >  #define AUDIT_OPENAT2=09=091337=09/* Record showing openat2 how args=
=20
*/
> >  #define AUDIT_DM_CTRL=09=091338=09/* Device Mapper target control */
> >  #define AUDIT_DM_EVENT=09=091339=09/* Device Mapper events */
> >=20
> > +#define AUDIT_CLONE3=09=091343=09/* Record showing clone3 args */
> >=20
> >  #define AUDIT_AVC=09=091400=09/* SE Linux avc denial or grant */
> >  #define AUDIT_SELINUX_ERR=091401=09/* Internal SE Linux Errors */
> >=20
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 6610e667c728..c0106bb71c19 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2882,6 +2882,26 @@ void __audit_log_nfcfg(const char *name, u8 af,
> > unsigned int nentries,>=20
> >  }
> >  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
> >=20
> > +void __audit_log_clone3(struct kernel_clone_args *kargs, int ret)
> > +{
> > +=09struct audit_buffer *ab;
> > +=09int pidfd;
> > +
> > +=09ab =3D audit_log_start(audit_context(), GFP_KERNEL,
> > +=09=09=09     AUDIT_CLONE3);
> > +=09if (!ab)
> > +=09=09return;
> > +
> > +=09audit_log_format(ab, "cl3_flags=3D0x%llx exit_signal=3D%d cgroup=3D=
%d",
> > +=09=09=09 kargs->flags, kargs->exit_signal, kargs->cgroup);
>=20
> Would there be any confusion if this were simply "flags=3D..." since it i=
s
> already a record type AUDIT_CLONE3?

flags is already used in mmap records and will require workarounds to have=
=20
the same field name here. Separating them by name is better.

> > +=09if ((kargs->flags & CLONE_PIDFD) && ret >=3D 0 &&
> > +=09    !get_user(pidfd, kargs->pidfd))
> > +=09=09audit_log_format(ab, " pidfd=3D%d", pidfd);
> > +=09else
> > +=09=09audit_log_format(ab, " pidfd=3D(null)");
>=20
> Is there any interest in:
> =09child_tid (was captured by generic audit syscall arg 4)
> =09parent_tid (was captured by generic audit syscall arg 3 or 4)
> =09tls (was captured by generic audit syscall arg 4)
> =09set_tid

Nope. Those are more resource related and not security focused. Even if you=
=20
wanted it, these are pointers to the answer and not the answer. The patch h=
as=20
everything needed from a security PoV.

Ack.

> Is there a situation where a valid pid is returned without CLONE_PIDFD se=
t?

No idea. The man page makes it sound like it is only valid when CLONE_PIDFD=
.=20
Besides, its a pointer to an int from what the man page said.

-Steve

> Otherwise, looks reasonable to me.
>=20
> > +=09audit_log_end(ab);
> > +}
> > +
> >=20
> >  static void audit_log_task(struct audit_buffer *ab)
> >  {
> > =20
> >  =09kuid_t auid, uid;
> >=20
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index f0e2e131a9a5..0f52e8c0e900 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -3047,7 +3047,9 @@ SYSCALL_DEFINE2(clone3, struct clone_args __user =
*,
> > uargs, size_t, size)>=20
> >  =09if (!clone3_args_valid(&kargs))
> >  =09
> >  =09=09return -EINVAL;
> >=20
> > -=09return kernel_clone(&kargs);
> > +=09err =3D kernel_clone(&kargs);
> > +=09audit_log_clone3(&kargs, err);
> > +=09return err;
> >=20
> >  }
> > =20
> >  void walk_process_tree(struct task_struct *top, proc_visitor visitor,
> >  void *data)
> - RGB
>=20
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> Upstream IRC: SunRaycer
> Voice: +1.613.860 2354 SMS: +1.613.518.6570





