Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306E5606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=endQ4UGt
Received: by kanga.kvack.org (Postfix)
	id 9B1886B05BC; Wed, 18 Nov 2026 00:10:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DC76B05BD; Wed, 18 Nov 2026 00:10:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806486B05BE; Wed, 18 Nov 2026 00:10:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46B346B05BC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:10:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4A401C3F69
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:56 +0000 (UTC)
X-FDA: 85447062792.01.87C13B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 185931C0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=endQ4UGt;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794978595;
	b=k3Zj8gJxD9jPShLq/rg6rQD1Ip2KNw0vHtXKtaYJtFUoDZunJc7dUVS2DkVzPL06HhU4v0
	I7QBZ8gcFtghIiXspSZazvTLbKixjthiLNzQeJTh0xk4CVkSTOOfqgXZQsIE4G9JsqP9qK
	uv5ZBDbozn2Cr0iNAJrCQkZMvjlFmE4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794978595;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLhzTdeZGhnfCAfzgIrk7wQ2R2Ys8FGkLbHkuriAdYs=;
	b=LHdi9Nvk5cORblzw+dyVrjfclrg9wMGK/djZ4wtzE8Vpf2tSvmVoHkWGU42m41lkKQf1Cq
	l5PED4wL0yTGHVWR7ES5q4A+Kq7cHrifwxLx4G1zzRofzuCr+zXHVXGWdiys61N/oJFLxK
	F7zsh2CD7tNm3QfRLytnR2X5YFgK8pA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=endQ4UGt;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0973A43073;
	Wed, 18 Nov 2026 05:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431C31F000C4;
	Wed, 18 Nov 2026 05:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978593;
	bh=NLhzTdeZGhnfCAfzgIrk7wQ2R2Ys8FGkLbHkuriAdYs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=endQ4UGtZtDAJoqM4m6bDLUETXQicTvLMqmxKcOwvlLNa/7h8csAJJxMAPTdN8UjT
	 kdzjbfbafgAVkF74E4iv/ta5gXxB30rgeYTDhUxWO46n+L9xGaSEsfvdQhg3Xk0n/q
	 2shNn/thCr8z89X9NwKHSBrGSioI2O5m1NIaS4VHqxCOzbKVlD4UbaTlb8POjhQc9w
	 RD2dKE3GPk3stD/6qZ1GXonVeMsmOSFRtMSXo4JtAO3yI8jpOwEnwWp+9K7xCXVf90
	 QQV0luKAE2OYk8s5PqxD7R2nBNcrDNhEUTrNJLJN79fNca+d/T1kREb0MTbA4ye4aR
	 T/Nq/FduHPElw==
Message-ID: <sashiko-outbox-220143@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 08/13] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Ben
 Segall" <bsegall@google.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Howells" <dhowells@redhat.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K Prateek
 Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Vlastimil Babka" <vbabka@kernel.org>
In-Reply-To: <20261117050841.3289652-9-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-9-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:09:51 +0000
X-Rspamd-Queue-Id: 185931C0002
X-Rspam-User:
X-Stat-Signature: iwmz553jg5h4xsashkaf88rzqit3t93w
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794978594-269966
X-HE-Meta: U2FsdGVkX1+D59oYNflZ9xOlMmX4xSFYwJnvSs4fjI5gigjBG6MCUf6jkOeVpye4EuJVv1C7SpyLG25vcUPf/KFJL+QypSz11oql+BBrP8YWU8RS9hCsKWkhI7Z5Y6If3F2N47jIqy6yy6t/+mHDv63UPspQDQgWY9aZrfOHMIEvsddcKKsghbcVd/DSmE/0gwtfAyOn53qFXKSHAM5VElxsx6rXT5LqTnmP+tQpqF72nXFNHkF0z3jZWkzPm1Amw+RVC3aaRW5uKbenwMSMAfNBPSYcLDNYRhIn9OjNUiQgEo93k7UbGsADmJ1l/wu3qar/AoACDBQixdXnOlOW6zOsmPfXtRDMtBrvBymmK7wvFk5wtCRIX/unZlzvUfVDKo3wM/dP7GuOxBds02DVxBsWD/6YfbPLH0wGy8CVTKhvRGh3VALBzbZ2y9EnNhNazS6lYK3aRCAUqe4MYsPcUhpy90NCcgQGaVPwP70AKrt3tYC1W8TbJf17WL6DOcijpvXS1HU5qLkpcjzsSbr6CGilKVO5yBU+mvKkZc1QheK8LflcUuG+CtJJbZyCXmKVIx+xII4ux5CnKrmdl1Z27cfHkSuw0ujEhCp+WckvJuajDT6cvTlG7uBfW6c2JeiJjIKLZsu/TUKTZNXh/x590JMjYGdMlBKqaSglqwiK5N27aP28dBYBUsWwYdM/obivjgu44C6TsBk5Ci17D7PiqfGMs2wNylw93beqdM0CRFVsoFhialvRSueyfqJI+lu6UtQBl8AnMwWG4aTBLZS36FDIAQUITtS6YASUrf3SLU3VqDs6LD4niHiD4Yt0vOUoXH1jUfHaNmZrRs66qGETrrQxCE1T8NYRMnH2gwlFecwy4hRl09Lc6P5x7s4hPFVv8O37UXXfkMNpCIBaPXHRhpL8epbDB8LDf6zxuL3s5DZkpGPzlZv49BXjDXw0q6QAb7Va53F+hrOPN94NLqP
 RI8yLC0x
 z4rgegL+tOV1M2Y0tAnazJsqjiH3JrMvsE8XD7DkmvWK7KHwsF0MT3EOAvEcpdOhJjuwFvgpWk6Aa9zKE8u3nVDoaRTiO0rzzbgl6rrFG9Pa9OtpqBRKEp9/iv4dP9RA0A5RF5SdEZiMQA5m+V/FYfKbFwXpGv2EopWGDlu1+7dICEDvOwB8ElNTYnCx2Y7ZMqQcHoBmTGBZatLhUdsjiYwI8YpTZqop90Cy3wM8LwWl/LnTV8qRCM8VLeb2qc4ByYI+3hY26Iq1YCY00YAW8V300b5l6WpO3PmV+E5C4OraWUch0IfCjB7+D8OZQAR8AguxDhYZnuQQ2uhVicuBOuTb3iICle2GoQopRFrDzQclY2Ri/M1x3St1joEHk21BI8FtokY1tYjV2Nk/F54GC77t3Mjiz8hiYzpM24SIo8ohxJyV37oaIA0n/PdWNPVukhqmaCdrigy5amSfZ3gAafZnRxj53GBdpuByKTzFb1qT+shhFKEj6886XbVW2dS1B4hegVPDWEPWGf9pyYIfUR3M0Ymhfv0BUNQMVsR8187aNCDPEbnOK4jAn6XxOTT/xckHOZGwbV31e6Pa3TX0NFywZKm2gxAUyDbYvStF7pdWesmqyfQRxjNahf7qmIMaOVIVYHOyTojQa3qPa3lm8L/IG81tKm6Z/nQU2jGVM0eXD6rONa6V1uB+eh8KdJ+XtYSEnsF9cQMMvhx3BxsI3pv0NbiRaCx90sb2EXsTkKyIINO3jucrwjB420A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Critical] fs: fsconfig_set_rootns() replaces fc->net_ns after
  init_fs_context() runs
- [High] fs: proc: missing pidns_is_ancestor() check in
  proc_set_rootns()
- [High] fs: broken fc->user_ns delegation in fsconfig_set_rootns()
--

commit c40a472d45a1ca48a5976af47a79bdbf753d63b0
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support FSCONFIG_SET_ROOTNS in fsconfig()

This commit adds the FSCONFIG_SET_ROOTNS command to fsconfig() so a newly
opened filesystem context can be bound to a target rootns file descriptor
before parameters are parsed.

> diff --git a/fs/fsopen.c b/fs/fsopen.c
> index 70024870fefa2..98d407fd249bc 100644
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c
[ ... ]
> +static int fsconfig_set_rootns(struct fs_context *fc, struct fs_paramete=
r *param)
> +{
> +	struct user_namespace *user_ns;
> +	struct rootns *c;
> +
> +	if (!is_rootns_file(param->file))
> +		return -EINVAL;
> +
> +	c =3D param->file->private_data;
> +	user_ns =3D c->cred->user_ns;
> +	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	put_net(fc->net_ns);
> +	fc->net_ns =3D get_net(c->ns->net_ns);

[Severity: Critical]
Can replacing and dropping fc->net_ns here after fc->fs_type->init_fs_conte=
xt()
has already run during fsopen() cause a use-after-free on ctx->net in kAFS?

alloc_fs_context() invokes init_fs_context() during fsopen(), where
afs_init_fs_context() caches an unreferenced net_generic pointer from the
initial fc->net_ns:

fs/afs/super.c:afs_init_fs_context() {
	...
	ctx->net =3D afs_net(fc->net_ns);

	/* Default to the workstation cell. */
	cell =3D afs_find_cell(ctx->net, NULL, 0, afs_cell_trace_use_fc);
	if (IS_ERR(cell))
		cell =3D NULL;
	ctx->cell =3D cell;
	...
}

When fsconfig_set_rootns() calls put_net(fc->net_ns), an unprivileged caller
in a user and network namespace can let that initial network namespace exit=
 so
cleanup_net() frees struct net and its pernet struct afs_net, and then call
fsconfig(fsfd, FSCONFIG_SET_STRING, "source", "#cell:vol", 0) to trigger a
use-after-free in afs_parse_source() -> afs_lookup_cell(ctx->net, ...).

In addition, nfsd_init_fs_context() and rpc_init_fs_context() set fc->user_=
ns
from fc->net_ns->user_ns during fsopen(), so switching fc->net_ns afterwards
leaves fc->user_ns bound to the fsopen() caller's user namespace and bypass=
es
the sget_fc() non-initial user_ns check.  nfs_init_fs_context() also evalua=
tes
fc->net_ns !=3D &init_net during fsopen() when setting NFS_MOUNT_NETUNREACH=
_FATAL,
which becomes stale once fc->net_ns changes.

> +	if (!fc->global &&
> +	    (fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE))=
 &&
> +	    kuid_has_mapping(user_ns, fc->cred->fsuid) &&
> +	    kgid_has_mapping(user_ns, fc->cred->fsgid)) {
> +		put_user_ns(fc->user_ns);
> +		fc->user_ns =3D get_user_ns(user_ns);
> +	}
> +	if (fc->ops->set_rootns)
> +		fc->ops->set_rootns(fc, c);
> +	fc->phase =3D FS_CONTEXT_CREATE_PARAMS;
> +	return 0;
> +}

[Severity: High]
Does gating the fc->user_ns update on kuid_has_mapping() and
kgid_has_mapping() silently skip user namespace delegation for an unentered
ROOTNS_USER rootns?

When rootns_create() creates a rootns with ROOTNS_USER, create_user_ns()
initializes user_ns->uid_map and user_ns->gid_map with zero extents, and
sys_rootns_enter() rejects entering the rootns with -ENOENT while its state=
 is
ROOTNS_EMPTY before "/" is mounted.  Because no ID mappings can exist yet in
that unentered user namespace (or when a host manager's fsuid/fsgid lies
outside the container's subordinate ID range), kuid_has_mapping() and
kgid_has_mapping() return false and fsconfig_set_rootns() returns 0 without
updating fc->user_ns, causing privileged managers to create init_user_ns-ow=
ned
superblocks and unprivileged callers to fail mount_capable(fc) with -EPERM.

Meanwhile, mqueue_set_rootns() unconditionally sets fc->user_ns to
ctx->ipc_ns->user_ns even when current_fsuid() and current_fsgid() are
unmapped there, leaving the root inode created by mqueue_fill_super() ->
mqueue_get_inode() with unmapped i_uid and i_gid.  Conversely, when ID
mappings do exist and fc->user_ns is switched to a target user_ns that diff=
ers
from current_user_ns(), FS_USERNS_MOUNT filesystems such as overlayfs
(ovl_fill_super() and ovl_parse_param()) and binfmt_misc (bm_fill_super())
explicitly check fc->user_ns !=3D current_user_ns() and fail with -EINVAL.

[ ... ]
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a7..5976029ad3f80 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
[ ... ]
> +static void proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
> +{
> +	struct proc_fs_context *ctx =3D fc->fs_private;
> +
> +	put_pid_ns(ctx->pid_ns);
> +	ctx->pid_ns =3D get_pid_ns(rootns->ns->pid_ns_for_children);
> +	put_user_ns(fc->user_ns);
> +	fc->user_ns =3D get_user_ns(ctx->pid_ns->user_ns);
> +}

[Severity: High]
Does proc_set_rootns() allow a task in a child or sibling PID namespace to
mount procfs for a non-descendant PID namespace by omitting a
pidns_is_ancestor() check?

proc_parse_pidns_param(), pidns_install(), and sys_rootns_enter() all requi=
re
pidns_is_ancestor(target, task_active_pid_ns(current)) so a process confined
to a sub-PID namespace cannot access or mount procfs for an ancestor or
sibling PID namespace.  Because fsconfig_set_rootns() only checks
ns_capable(user_ns, CAP_SYS_ADMIN) and proc_set_rootns() unconditionally bi=
nds
ctx->pid_ns to rootns->ns->pid_ns_for_children, a process in a child PID
namespace within the same user namespace that receives a rootnsfd can mount
procfs for that outer or sibling PID namespace.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117050841.3289=
652-1-jarkko@kernel.org?part=3D8

