Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC33606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bk131Rxl
Received: by kanga.kvack.org (Postfix)
	id 1D8626B05C6; Mon, 23 Nov 2026 07:03:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7216B05C7; Mon, 23 Nov 2026 07:03:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077A26B05C8; Mon, 23 Nov 2026 07:03:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D46296B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:03:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 561FE1A07E1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:03:58 +0000 (UTC)
X-FDA: 85466250156.22.861DEC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AAE7010000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:03:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bk131Rxl;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435436;
	b=ZuPv7deOB0T48/7Eh37aZwHULsFjkIbLmt9XkMxNtsigfHxkxDIR5KrbSq5p2hp4jNDMjr
	fHAYH54z1Eu9CyN3ZdNCoWrrHZuWOADfLpxkUz54mIvzvKOC5G5MhUMM9w1Cq96X7bpGnD
	X5NKhpsVv/N6SKFnVKwlMjb8ycbIwUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435436;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os2YYoEwaN9EE55QVw/0ZexEHa3Izs1qGFG8A6wk42w=;
	b=u0Kywv67EZX9BpitYjauWFsCEqlh8JOrhk7dLKXqfMYmfGJj0mdkgPPuJ82CkbdxKN53qL
	ac/gmRPVE4SXPpwxQXD1waqF/a53u4rVJHLQgm4b0VmZRlbm0wIBdgHZl6p98aqGE8+NGH
	VgImnF76aRZ9RTY8LQeL1vmdqU2TeNQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bk131Rxl;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26911620B0;
	Mon, 23 Nov 2026 12:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200111F000C0;
	Mon, 23 Nov 2026 12:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435435;
	bh=os2YYoEwaN9EE55QVw/0ZexEHa3Izs1qGFG8A6wk42w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bk131Rxlpj3POpKOb+DjjJ+q3NcgXQQtTUX0T+UCgf/zH/mbkic7H7lYzoUsnjlF5
	 XL0Cg6Kigoyn13fn02GhFVnNESccz84p5lNrMIAYvmDbgXuF/uGEeDdmLPdjdmx9RU
	 bs88zb7OuwQK6vfpg9GV05i52Toi5s1/tmHFvVRF11lO+AGcSnMu0rgidpBTmPUS9Z
	 zquBrDHHy217zx/8v/qb8vQMvlTnD4gLh9Hqgv52RcajDBC0EfszV0EJirZHrnWhfE
	 fGiWWmfOhO8xgfuoL9KxCkrQVZhPW12Mf9UDJg0ZwMsYxZrHywqZ+z8fixBoiXOdhd
	 4t0QOX/fxVVgQ==
Message-ID: <sashiko-outbox-229180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 4/6] security: kap: add the securityfs control
 plane
Reply-To: sashiko-reviews@lists.linux.dev
To: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>, bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Cc: "Liam R. Howlett" <liam@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Ben Segall" <bsegall@google.com>, "David
 Hildenbrand" <david@kernel.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "James Morris" <jmorris@namei.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Juri Lelli" <juri.lelli@redhat.com>, "K Prateek
 Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, "Ketan
 Bhardwaj" <ketan@armoriq.io>, "Lorenzo Stoakes" <ljs@kernel.org>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Suren Baghdasaryan" <surenb@google.com>, "Valentin
 Schneider" <vschneid@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261123114308.8103-5-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
 <20261123114308.8103-5-harisudhan@armoriq.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 12:03:53 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: AAE7010000F
X-Stat-Signature: in5qdheobxqysdwfsy937nka1wm4jmxx
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795435436-406028
X-HE-Meta: U2FsdGVkX181qjYqVPq2TxHKa3DrIRLpFqPuuf3Iu5QrjnFQjhboDOimTuWSI+tzN2ot6J8AVQg6boUYbRDRevyxFpNAGmOa5c3PoLIutwsA26QWM1PrpjKDv+P6fQoQ72MOn7wkOnt/fhIXf6oxafTrAa4UifwQlUXElZUD0M0eD6IS/FZmLoj83EEa2ylGgdFMvUtnuYVsYtoedgvuQaNmjiCBNIrm4XzCg9Z1EIytuwu5Wwd2OWwQlIftYob901sDTG+6kABfUBGQzkzjJanecnM/G2bkjHT5+zdUFbHt/Em9YMVcWgAxHxrYlzBhamTviPc+ASxpz9RGYp7xHbWBSX1XUk0p/wR5tdhZ9SU15mkUXHCFGaSyHbAMtpVxulStm2gA5eXne0q0LCbetSiA+/WqEofWYM0rPFLBxzGTPHT2ID5PycZiTU7lUSENMFd573e5JVPbaBTzYNzlxDlWiL+ETAp9cR9geGbTwdDEV1BRDI5907AAPd5FEO0x92fgyegBjjccUUPis2acw7z1JmX1s5PC4CXYTO9ElN1M8CwzYwwQdJcrL3ZBZJPpVsutC7hhUb4TNKZftqcr7JDLH/xKTCvcNJjLVxBElUkTH40rTCtE+oqtjEMtg58SP7tGK0UwVRN8oj75DOtOsMhjUKFw2uv0g/fyhg+bMgqRsdoUaU2Hd5135sHLyEBoh2GL0EIJud7Hr1oEgj6Sd6UGFzQIJOIyHeUSnMyoF84f2nwpDbo5SBvmxLOoKMjOnZtAgptuvIEKad0vt3l1YBfply4UdFkZyG71iAivdhQuHD5HL8v/L/CvknjZJQJBnlJsED7dAVHHZMOhXD8XgtvorYelSuW162TLrlzwzYHbUtjIRA6TkRtfv4PZioo1owgbuc5CHMrkGjJICsT95XJD522NqNLZUHsk0/Szhq+9ih726+jk7KhI1mu81Rx3L72vzmcP0U8QPl59SXd
 3bheFF28
 bNXWGIBxGXfOjWNvcxLczdGo7svL9KwCScKSDFmIvqIND52R9bmS0wvjT3ShbjAKnd0nviZQBp9h5AZISlimvVUDvDk+KvaX5yT+TjKrioS2e7hP/BpIyBF9kBZAaH0B2PJuy0DAaAQJciRUs5BeW1Oo4D0HKE25A9DPIJITDc5Xsj/jslRm/wZDRc5YYFZUaFMKkQOuATHNejmdVz8+xVEpxcqPVMifu+ibm2x0PCA7+qE3g9LCLOuyrudGRpMDb6vB2B7M6Na8ngQ0C6mD2JZhnTDd8jpWRvTaUtu7yEPLy69CHiIRDcVMP+g5aOvLIu7xFQcowdnax6DWQtE3FjpjI1H72U4xdV/viWOfgIzoRdpdMYo8fFMyW8ZFB3vp3g3/JmnRlG63YHrkfOxqWaZ01u76/lrxu9OdMaCtg1alnGSD695ENZbSL4jp0R0UROlzKpK1xl/xMI50IgXsFmlnZyz/Ww6FzaIS1gwVoiUpheCaZxxVtsIgos8SdZQ/QjhMbrEDfU396YjBDyK9KYoGL/p2nHgWnJ0MymGHsUv4d44a/dz1kBb3PNZ4r0PX7FniaMh2VVaCPKd+Tkl292bpW/64NcQ8O921N0Cs1/KG5+urKx4TeQ4HmNf8bAbnoIM7gre53RY66lQkbpJ8OHe6ncI+hmTdTBixduc4ylN3Oo7g8plukBHHo1F7blwq5mpeMLOLpgv8fCRtMhjujcavKh++IC4e+v/7CLHad1x0qdB+3XVGXvVPsyie/m4c4nhmqPuEnICsEjqoOetOzYuD6mzlKZYUjCA3y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential
issues to consider:
- [Medium] security: kap: dentry reference leak on child files in
  kapfs_mkdir()
- [Medium] security: kap: unattached kapfs_mnt resolves as root-relative
  in d_path()
- [Medium] security: kap: data race on kap_task_state in
  kap_bind_pid_locked()
- [Medium] security: kap: race between kap_bind_pid_locked() and
  copy_process()
- [Medium] security: kap: kap_authority_prepare() bounds predicates by
  next kind not '}'
- [Medium] security: kap: unbounded igroup->pids growth in kapfs_write()
- [Low] security: kap: kapfs_write() silently succeeds on newline-only
  writes
- [Low] security: kap: order-5 allocation and locked strlen() in
  kapfs_write()
--

commit 9e7e1166b9d68fb071806f2526682914d4f5f018
Author: HARIHARA SUDHAN. R <harisudhan@armoriq.io>

security: kap: add the securityfs control plane

This commit adds the securityfs control plane under /sys/kernel/security/kap
and mounts an internal kapfs filesystem for creating and configuring igroup=
s.

> diff --git a/security/kap/kapfs.c b/security/kap/kapfs.c
> new file mode 100644
> index 0000000000000..c9f03c2d8c0ac
> --- /dev/null
> +++ b/security/kap/kapfs.c

[ ... ]

> @@ -0,0 +1,530 @@
> +static int kapfs_show(struct seq_file *m, void *v)
> +{
> +	struct kap_file_ctx *ctx =3D m->private;
> +	struct kap_igroup *igroup =3D ctx->igroup;
> +	struct kap_bound_pid *entry;
> +
> +	spin_lock(&kap_lock);
> +	switch (ctx->kind) {
> +	case KAP_FILE_PROCS:
> +		list_for_each_entry(entry, &igroup->pids, node)
> +			seq_printf(m, "%d\n", entry->pid);
> +		break;

[Severity: Medium]
Does igroup->pids grow without bound over the lifetime of an igroup?

Every new PID written to kap.procs allocates a struct kap_bound_pid in
kapfs_write() and appends it to igroup->pids in kap_bind_pid_locked(),
but entries are never removed or freed when a task exits in
kap_task_free() or when a task is rebound to another igroup.  As
processes are spawned, bound and exit, igroup->pids leaks memory, reports
dead PIDs on kap.procs reads, and linearly walks an ever-growing list
under the global kap_lock spinlock in both kap_pid_in_igroup_locked() and
kapfs_show().

[ ... ]

> +static ssize_t kapfs_write(struct file *file, const char __user *buf, si=
ze_t len, loff_t *ppos)
> +{

[ ... ]

> +	if (len =3D=3D 0)
> +		return 0;
> +	if (len > (ctx->kind =3D=3D KAP_FILE_INSTALL ? KAP_MAX_INSTALL_BYTES
> +						 : KAP_MAX_PREDICATE_BYTES))
> +		return -EINVAL;
> +	if (ctx->kind =3D=3D KAP_FILE_EVENTS || ctx->kind =3D=3D KAP_FILE_IGFD)
> +		return -EINVAL;
> +
> +	tmp =3D memdup_user_nul(buf, len);
> +	if (IS_ERR(tmp))
> +		return PTR_ERR(tmp);
> +	kap_trim_newline(tmp);
> +	if (!tmp[0]) {
> +		kfree(tmp);
> +		return len;
> +	}

[Severity: Low]
Should kapfs_write() silently succeed when the buffer is empty after
stripping trailing newlines?

Writing a newline-only string (such as echo "" > kap.procs or kap.mode)
returns len without validating the input or updating any state, and also
makes it impossible to clear kap.lineage_root via a single-file write
even though kap.install accepts an empty lineage_root=3D value.

> +
> +	/* Parse, allocate and compile first: kap_lock is a spinlock. */
> +	switch (ctx->kind) {

[ ... ]

> +	case KAP_FILE_INSTALL:
> +		rc =3D kap_install_parse(tmp, &req);
> +		if (!rc)
> +			rc =3D kap_authority_prepare(req.authority, &compiled);
> +		break;
> +	case KAP_FILE_AUTHORITY:
> +		rc =3D kap_authority_prepare(tmp, &compiled);
> +		break;

[Severity: Medium]
Can kap_authority_prepare() compile patterns from the next predicate into
an earlier predicate when JSON keys precede "kind"?

Both kap_validate_authority_payload() and kap_compile_kind_array() walk
backward from "kind" to '{' to find predicate_start, but bound
predicate_end by the next "kind" rather than the current object's closing
'}':

security/kap/igroup.c:kap_compile_kind_array() {
	...
	while ((predicate =3D kap_next_predicate(predicate, end, kind_name))) {
		const char *next =3D strstr(predicate + 1, "\"kind\":");
		const char *predicate_start =3D predicate;
		const char *predicate_end =3D next && next < end ? next : end;
		int rc;

		while (predicate_start > auth && *predicate_start !=3D '{')
			predicate_start--;
		rc =3D kap_compile_array(compiled, set, predicate_start,
				       predicate_end, array_name);
	...
}

If one predicate omits its "allow" or "deny" array and the following
predicate places "allow" or "deny" before "kind", those arrays fall
inside [predicate_start, predicate_end) of the earlier predicate.
kap_validate_authority_payload() then accepts the malformed predicate and
kap_compile_kind_array() compiles the next predicate's patterns under the
wrong hook kind.

[ ... ]

> +	spin_lock(&kap_lock);
> +	switch (ctx->kind) {
> +	case KAP_FILE_PROCS:
> +		rc =3D kap_bind_pid_locked(igroup, pid, &entry);
> +		break;

[Severity: Medium]
Can kap_ptrace_target() observe torn or partially initialized task state
while kap_bind_pid_locked() updates a task?

kap_bind_pid_locked() sets state->active =3D true before writing
state->epoch and state->igroup_name, while kap_ptrace_target() reads
those fields without holding kap_lock:

CPU0                                  CPU1
kapfs_write()
  spin_lock(&kap_lock)
  kap_bind_pid_locked()
    state->active =3D true
                                      kap_ptrace_access_check()
                                        kap_ptrace_target()
                                          if (child_state->active)
                                            strcmp(...,
                                                   child_state->igroup_name)
                                              <-- reads empty or torn name
    state->epoch =3D igroup->epoch
    strscpy(state->igroup_name, ...)

A concurrent ptrace check can therefore misclassify same-igroup versus
cross-igroup ptrace operations and log a corrupted target string in
kap.events.

[Severity: Medium]
Can a thread or child being created in copy_process() miss the binding
when kap_bind_pid_locked() runs concurrently?

kap_task_alloc() copies the parent's kap_task_state during
security_task_alloc(), long before copy_process() links the new task onto
signal->thread_head under siglock:

CPU0                                  CPU1
copy_process()
  security_task_alloc()
    kap_task_alloc()
      spin_lock(&kap_lock)
      /* old->active is false */
      spin_unlock(&kap_lock)
                                      kapfs_write()
                                        spin_lock(&kap_lock)
                                        kap_bind_pid_locked()
                                          for_each_thread(task, t)
                                            state->active =3D true
                                        spin_unlock(&kap_lock)
  write_lock_irq(&tasklist_lock)
  list_add_tail_rcu(&p->thread_node,
                    &p->signal->thread_head)
    <-- new task runs with active =3D=3D false

Because p is not yet on signal->thread_head when for_each_thread() walks
the process, p escapes the igroup binding even though writing to
kap.procs succeeded.

[ ... ]

> +	case KAP_FILE_AUTHORITY: {
> +		struct kap_compiled_authority *old =3D igroup->compiled;
> +
> +		strscpy(igroup->authority, tmp, sizeof(igroup->authority));
> +		igroup->authority_len =3D strlen(igroup->authority);
> +		igroup->compiled =3D compiled;
> +		compiled =3D old;
> +		break;
> +	}

[Severity: Low]
Could kapfs_write() avoid the order-5 physically contiguous allocation in
memdup_user_nul() and the extra strlen() pass under kap_lock?

For KAP_FILE_INSTALL and KAP_FILE_AUTHORITY, len can be up to 66,560
bytes, so memdup_user_nul() requests up to 66,561 physically contiguous
bytes (order 5 on 4 KB page kernels, above PAGE_ALLOC_COSTLY_ORDER),
which can stall in direct compaction or fail under fragmentation; using
vmemdup_user() or kvmalloc() would match kvzalloc_obj() in
kap_authority_prepare().  In addition, using the length returned by
strscpy() here (and in kap_install_locked()) avoids rescanning up to 64
KB with strlen() while holding the global kap_lock spinlock.

[ ... ]

> +static void kapfs_instantiate(struct dentry *dentry, struct inode *inode)
> +{
> +	d_make_persistent(dentry, inode);
> +}

[ ... ]

> +/* Returns NULL on success: the passed dentry is the one instantiated. */
> +static struct dentry *kapfs_mkdir(struct mnt_idmap *idmap, struct inode =
*dir,
> +				  struct dentry *dentry, umode_t mode)
> +{

[ ... ]

> +	for (i =3D 0; i < KAP_FILE_COUNT; i++) {
> +		files[i] =3D d_alloc_name(dentry, kap_file_names[i]);
> +		inodes[i] =3D kapfs_make_inode(dir->i_sb, S_IFREG | kap_file_modes[i]);
> +		if (!files[i] || !inodes[i]) {
> +			rc =3D -ENOMEM;
> +			goto err;
> +		}
> +		igroup->files[i].kind =3D i;
> +		igroup->files[i].igroup =3D igroup;
> +		inodes[i]->i_fop =3D &kapfs_fops;
> +		inodes[i]->i_private =3D &igroup->files[i];
> +	}

[ ... ]

> +	/* Lookups in the new directory wait until its files are all there. */
> +	inode_lock(inode);
> +	kapfs_instantiate(dentry, inode);
> +	igroup->dentry =3D dentry;
> +	for (i =3D 0; i < KAP_FILE_COUNT; i++)
> +		kapfs_instantiate(files[i], inodes[i]);
> +	inode_unlock(inode);
> +	return NULL;

[Severity: Medium]
Does kapfs_mkdir() leak a dentry reference on every child file in
files[]?

d_alloc_name() returns each files[i] with a reference count of 1, and
kapfs_instantiate() -> d_make_persistent() takes an additional reference
via dget_dlock().  Unlike the directory dentry passed into kapfs_mkdir(),
whose creation reference is dropped by the VFS caller, files[i] is never
passed to dput() after kapfs_instantiate(), leaving each child file with
a reference count of 2 instead of 1.

[ ... ]

> +static const char *kap_igroups_get_link(struct dentry *dentry,
> +					struct inode *inode,
> +					struct delayed_call *done)
> +{
> +	struct path path;
> +	int rc;
> +
> +	if (!dentry)
> +		return ERR_PTR(-ECHILD);
> +	path.mnt =3D mntget(kapfs_mnt);
> +	path.dentry =3D dget(kapfs_mnt->mnt_root);
> +	rc =3D nd_jump_link(&path);
> +	return ERR_PTR(rc);
> +}

[ ... ]

> +int __init kap_securityfs_init(void)
> +{
> +	struct dentry *dent;
> +	int rc;
> +
> +	if (!READ_ONCE(kap_lsm_active))
> +		return 0;
> +
> +	kapfs_mnt =3D kern_mount(&kapfs_type);

[Severity: Medium]
When a task crosses the igroups symlink via nd_jump_link() onto the
internal kern_mount() vfsmount, won't d_path() resolve files under
/sys/kernel/security/kap/igroups as /<igroup>/<file>?

Because kapfs_mnt is an unattached internal mount with no parent
mountpoint, d_path() in kap_file_target(), kap_lsm_file_path_alloc() and
kap_lsm_check_dir_entry() stops at kapfs_mnt->mnt_root and formats paths
without the /sys/kernel/security/kap/igroups prefix.  File policies
written for /sys or /sys/kernel/security/kap will therefore fail to match
accesses under igroups/ (and an igroup named "proc" will be misclassified
as procfs by kap_path_is_procfs()), while kap.events logs root-relative
paths.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123114308.8103=
-1-harisudhan@armoriq.io?part=3D4

