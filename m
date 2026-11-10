Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6607606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFOl7Xi+
Received: by kanga.kvack.org (Postfix)
	id 024946B05B1; Tue, 10 Nov 2026 15:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DD26B05B2; Tue, 10 Nov 2026 15:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7ABA6B05B3; Tue, 10 Nov 2026 15:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8D9D6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:47:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CDA9A840F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:47:05 +0000 (UTC)
X-FDA: 85420394010.15.2D3931E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9202A100010
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:47:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFOl7Xi+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343623;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOiIvE/b3K+W5UkET6f58ZM9G8kcK+BDjloEye1k/Jw=;
	b=cDDQnDx03OaVkTfetSPmPBvuLCjQsug3bNm6YSdyYoDZw2HTCmVJ/adLkBlu4iRH297Xfz
	3HWEt3j4uFvwKMapVy50N8iHzsE/2ZnvSPJjKh5pQ3R0q3SuzKhb1YgJ1F94Fyo2++gMf+
	9tM201qYsBhZpJoMw2eLrAGoqKM65RE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFOl7Xi+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343623;
	b=BYKR8teYInkENIfSHIdp5Bh5rCc13NTBitIqRFiZxk2fDvNePpE+ItJqHPhcxsn21lxe7u
	1QIhYO45nP0kx+s1U76FK8dAlgB+cRdWJs0bk1tukiDhtTOqOWMU0nyXm8R8EmK13rxJPw
	MC99aNkaKCLFYUwKE2M6vbO1pv01SE4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20D1F6020B;
	Tue, 10 Nov 2026 20:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E93D1F0089F;
	Tue, 10 Nov 2026 20:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343622;
	bh=TOiIvE/b3K+W5UkET6f58ZM9G8kcK+BDjloEye1k/Jw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HFOl7Xi+dP1TM1MabYAJUbsJq0nmJ3kaPFUN0bQhBH4oohsgfs4PJSotFgtfFmBal
	 gDI+Ev6yrMXAPejKPkWRt1g4582RthbQ8nieWVPYAwMTrTjzP10WsXV7XP+0e2tY+e
	 /OX1e89YtF8s6GB2X9+sXYrMPdn92uIbAdnh759fPC8YUF/U6SxdtFE5BHbwslZdct
	 oxzRu/Oyah4IKKrdeD8VT7fygXbDR8GytI3gSfds8NRvQLmKgsSSdvsEdFG7e2iPDa
	 lI5edljuY1IQ7WXU7TF3Q9GihtOtsdskuvuPeXhqvewwWXel09xZVkfdBTSAKXl/m3
	 TbTP7kYz9W1bQ==
Message-ID: <sashiko-outbox-207728@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 4/6] security: kap: add the securityfs control
 plane
Reply-To: sashiko-reviews@lists.linux.dev
To: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>, linux-security-module@vger.kernel.org, "Paul
 Moore" <paul@paul-moore.com>, "Kees Cook" <kees@kernel.org>, "James Morris" <jmorris@namei.org>, "Serge
 E . Hallyn" <serge@hallyn.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Liam R
 . Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mel Gorman" <mgorman@suse.de>, "Suren
 Baghdasaryan" <surenb@google.com>, "Ben Segall" <bsegall@google.com>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Juri Lelli" <juri.lelli@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Ketan
 Bhardwaj" <ketan@armoriq.io>, bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261110202246.274-5-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
 <20261110202246.274-5-harisudhan@armoriq.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:47:00 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9202A100010
X-Stat-Signature: qcwprsyqn7hhaq66crh4wje6kj4yx93b
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794343623-337674
X-HE-Meta: U2FsdGVkX1/Znm3R1T/dieq8u+Hih/dUjLWloZycwDyjP3adZwvJSMU1AM7OeWl2DI6B1Z28mFriLy3XaRx9xgpBoD+EqGvOiPcE4Tyr+fA0sJlHg0jx+B4WcyzyfnmvWkSEBEep1gIUm35kiKmXlsOWQmBpMkkAUmyrnbL+N8Pxeun8Lj+QqIueSr9JOcsRPAfv6CUtPQkeP1HlAb8sT+nG/Fd5PXXvsCFo/4+BNzkssNPsyQTNsMPdlxfhL7cflBjpNI77LH8qm5KT+NCCZQMSRle15hFcDEAmV+MfWJZ4YBaQJXOFk0PvVpiR+fpFPOipJxaiNcYcSXsgDwXrCntwRyfT6A8u/+55aB38oP418/RobM5U1gUOPEehytMM3jlDUu/SWkKyECmzxsV2WDCZYuHtKPA5mUVpG+h2RE6gaYiCTYuMUYrH/kaMEDtFOBS6z4cqseO34JSlUCcsms2PsM4oTHWUXq4qc5pjjvIb2tSiZfsPXjW31zBXYJzwH5kpdVD30DE/fTfm8Q8cA4j4Hr5TYRrEKTovbhi2xC2jFsjJczoUIsNt7tHXtxSmKMLNNluC8iKzPucs6njJqguf02V8ppQOGrtN1Q2myZymQ/6ke8AuljWNt1dnapWHwmVoj6LAc4X05rQC6uH3B9W38OznTvhtVEymT53LhuEXMJ/tnqmv8+X9o9Exx7mpvhW8pwOBd5RT3P4elMUlkfC7oAyUgQVC8PUmRGGkIJjBDIy28GUeYJUkcxrsAsUyXZzOQNHqbzTV7y3wlBTopnEhnVYv+zFW2MUGyZ5kMr2OE253qCmd/CjKNzXE2p2r9Dm2OYbMgkhWyJSh4SYlNvi4XoVm40iH2Qtu0T6GFzLF+XF5Vx0U3dr62bktC5YDLecnBQnp1aFWxQFzt4wKI7f2XGf0TVf055AfjmJkfGLw43oSgf0VQsZMbQrkLXxTwVEy1/jIU7C46IIjZFP
 or5Ii1fu
 e8MEZ37sZMPxbq/s523UhPxx9VWIFHeYsU1jGep7O+Rvz3DOdeAawjRmnjxVvp6lbUgjWFz0pQxEWM7pBzfkD7dn8EzOWJbGtwXkYE7IQ4F8LCqTQZMCOr84H6YENc1PZ9/4RjQIFWVQbzA5IhWw8NX0pnhwd+bd0L2LHnYu0ioE0LnGtq9vUkxNFXZShh9a9YNJLwyDVRuyeajsoRHMgyxhDaxzQFaIOavDTE5S3/Jt0v65MdBpnrzCQzrZ3YqFxxxsm12d3eOAKQInUS9wyYP9M9FXDwbl4G5th1sFwGW+DxyXnpX5JSFFeOcBsre6ApOMx12Hmh21Ep+uG1JoFQP+dWhEGFhIsai+rBhqY1VXG4GXa3yAZ/p7H1QSgriad9coxVADwX6HK8SW1Cf+JjUbMBZ7BGX749E5/tt3ue+pUojrqcjqH6geu80oIsjJQ/Kr7zzNWQDgNoRC/zvOYJfxXh/sd7bQ8XJa8GCol50FEZu9/2Z/J7pat2EA62isbWzTn2LiEa85G/kMGd+aVq8XCUNrOBQ97i9Obg3GsVK1FWz4iNZMVucmds10uzM6S8L7/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential
issues to consider:
- [Medium] security: kap: dentry reference leak on child files in
  kapfs_mkdir()
- [Medium] security: kap: unattached kapfs_mnt resolves as root-relative
  in d_path()
- [Medium] security: kap: missing superblock ops and blocksize in
  kapfs_fill_super()
- [Medium] security: kap: data race on kap_task_state in
  kap_bind_pid_locked()
- [Medium] security: kap: race between kap_bind_pid_locked() and
  copy_process()
- [Medium] security: kap: kap_authority_prepare() bounds predicates by
  next kind not '}'
- [Low] security: kap: unsanitized lineage_root in kapfs_write()
  corrupts output
- [Low] security: kap: kapfs_write() silently succeeds on newline-only
  writes
- [Low] security: kap: unchecked u64 overflow in
  kap_parse_transition_sequence()
--

commit 9864f112a0785ec3a3604d782064cf536e36889c
Author: HARIHARA SUDHAN. R <harisudhan@armoriq.io>

security: kap: add the securityfs control plane

This commit adds the KAP securityfs control plane at /sys/kernel/security/k=
ap
and mounts an internal kapfs filesystem for managing igroups and their cont=
rol
files.

> diff --git a/security/kap/kapfs.c b/security/kap/kapfs.c
> new file mode 100644
> index 0000000000000..b182ff24bb8c4
> --- /dev/null
> +++ b/security/kap/kapfs.c
[ ... ]
> +static ssize_t kapfs_write(struct file *file, const char __user *buf, si=
ze_t len, loff_t *ppos)
> +{
[ ... ]
> +	tmp =3D memdup_user_nul(buf, len);
> +	if (IS_ERR(tmp))
> +		return PTR_ERR(tmp);
> +	kap_trim_newline(tmp);
> +	if (!tmp[0]) {
> +		kfree(tmp);
> +		return len;
> +	}

[Severity: Low]
Should writing a newline-only string to a control file really succeed witho=
ut
doing anything?

If a script writes an empty line (for example, echo "$PID" > kap.procs when
PID is unset), kapfs_write() returns len without validating the input or
updating any state, and this early return also prevents clearing
kap.lineage_root via a single-file write even though kap.install accepts an
empty lineage_root=3D.

> +
> +	/* Parse, allocate and compile first: kap_lock is a spinlock. */
> +	switch (ctx->kind) {
> +	case KAP_FILE_PROCS:
> +		rc =3D kstrtoint(tmp, 10, &pid);
> +		if (!rc) {
> +			entry =3D kzalloc_obj(*entry, GFP_KERNEL);
> +			if (!entry)
> +				rc =3D -ENOMEM;
> +		}
> +		break;
> +	case KAP_FILE_LINEAGE_ROOT:
> +		if (strlen(tmp) > KAP_MAX_ROOT_LEN)
> +			rc =3D -EINVAL;
> +		break;

[Severity: Low]
Can an unsanitized lineage_root corrupt kap.igfd and kap.events output?

KAP_FILE_LINEAGE_ROOT and kap_install_parse() only check the length of the
string, so embedded newlines break the single-line format of kap.igfd in
kapfs_show(), and quotes or backslashes are interpolated unescaped into the
"root" JSON field by kap_append_event_locked():

security/kap/igroup.c:kap_append_event_locked() {
    ...
	len =3D scnprintf(line, sizeof(line),
			"{\"ts_ns\":%llu,\"igroup\":\"%s\",\"decision\":\"%s\",\"operation\":\"%=
s\",\"target\":\"%s\",\"reason\":\"%s\",\"epoch\":%llu,\"root\":\"%s\",\"pi=
d\":%d}\n",
			now, igroup->name, allowed ? "allow" : "deny",
			kap_hook_name(kind), escaped_target, reason, igroup->epoch,
			igroup->lineage_root, task_pid_nr(current));
    ...
}

> +	case KAP_FILE_INSTALL:
> +		rc =3D kap_install_parse(tmp, &req);
> +		if (!rc)
> +			rc =3D kap_authority_prepare(req.authority, &compiled);
> +		break;
> +	case KAP_FILE_AUTHORITY:
> +		rc =3D kap_authority_prepare(tmp, &compiled);
> +		break;

[Severity: Medium]
Can kap_authority_prepare() bleed one predicate's allow or deny array into
the preceding predicate?

Both kap_validate_authority_payload() and kap_compile_kind_array() scan
backward from "kind": to '{' to find predicate_start, so keys appearing bef=
ore
"kind" inside a predicate object are supported, but they set predicate_end =
to
the next "kind": rather than the closing '}' of the current predicate:

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

If one predicate omits "allow" or "deny" and the next predicate places its
"allow":[...] or "deny":[...] before its "kind": key, the slice
[predicate_start, predicate_end) spans across the boundary between the two
objects, causing validation to accept the malformed document and compiling =
the
second predicate's patterns into the first predicate's hook kind.

> +	case KAP_FILE_AUTHORITY_EPOCH:
> +	case KAP_FILE_EXPIRES_AT:
> +		rc =3D kstrtou64(tmp, 10, &value);
> +		break;
> +	case KAP_FILE_TRANSITION:
> +		rc =3D kap_parse_transition_sequence(tmp, &value);
> +		break;

[Severity: Low]
Can kap_parse_transition_sequence() silently wrap on u64 overflow?

Unlike authority_epoch and expires_at, which use kstrtou64(),
kap_parse_transition_sequence() accumulates decimal digits without checking
for overflow:

security/kap/igroup.c:kap_parse_transition_sequence() {
    ...
	while (*cursor >=3D '0' && *cursor <=3D '9') {
		seen_digit =3D true;
		value =3D value * 10 + (*cursor - '0');
		cursor++;
	}
    ...
}

Writing a sequence number of 20 or more digits to kap.transition or
kap.install wraps modulo 2^64, which can corrupt igroup->last_sequence if t=
he
wrapped value exceeds the previous sequence number.

[ ... ]

> +	spin_lock(&kap_lock);
> +	switch (ctx->kind) {
> +	case KAP_FILE_PROCS:
> +		rc =3D kap_bind_pid_locked(igroup, pid, &entry);
> +		break;

[Severity: Medium]
Is there a data race on struct kap_task_state between kap_bind_pid_locked()
and kap_ptrace_target()?

kap_bind_pid_locked() sets state->active =3D true before populating state->=
epoch
and state->igroup_name, while kap_ptrace_target() reads those fields without
holding kap_lock:

CPU0                              CPU1
kapfs_write()
  spin_lock(&kap_lock)
  kap_bind_pid_locked()
    state->active =3D true
                                  kap_ptrace_access_check()
                                    kap_ptrace_target()
                                      if (child_state->active)
                                        strcmp(..., child_state->igroup_nam=
e)
                                          <-- reads empty or torn igroup_na=
me
    state->epoch =3D igroup->epoch
    strscpy(state->igroup_name, ...)

A concurrent ptrace check can therefore misclassify same-igroup vs
cross-igroup ptrace operations and log a corrupted target in kap.events.

[Severity: Medium]
Can a thread or child being created in copy_process() escape binding when
kap_bind_pid_locked() runs concurrently?

kap_task_alloc() copies the parent's kap_task_state early in copy_process(),
long before the new task is linked onto signal->thread_head under siglock:

CPU0                              CPU1
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
    <-- p runs with state->active =3D=3D false

The new thread or child process is missed by both kap_task_alloc() and
for_each_thread(), leaving it running unbound even though writing the proce=
ss
PID to kap.procs succeeded.

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
[ ... ]
> +	}
[ ... ]
> +	inode_lock(inode);
> +	kapfs_instantiate(dentry, inode);
> +	igroup->dentry =3D dentry;
> +	for (i =3D 0; i < KAP_FILE_COUNT; i++)
> +		kapfs_instantiate(files[i], inodes[i]);
> +	inode_unlock(inode);
> +	return NULL;

[Severity: Medium]
Does kapfs_mkdir() leak a dentry reference on each entry in files[]?

d_alloc_name() returns each child dentry with a refcount of 1, and
kapfs_instantiate() -> d_make_persistent() takes an additional reference via
dget_dlock().  Unlike the directory dentry argument whose lookup reference =
is
dropped by the VFS caller, files[i] is local to kapfs_mkdir() and needs
dput(files[i]) after kapfs_instantiate().

[ ... ]

> +static int kapfs_fill_super(struct super_block *sb, struct fs_context *f=
c)
> +{
> +	struct inode *inode;
> +
> +	sb->s_magic =3D KAPFS_MAGIC;
> +	inode =3D kapfs_make_inode(sb, S_IFDIR | 0700);
> +	if (!inode)
> +		return -ENOMEM;
> +	inode->i_op =3D &kapfs_root_inode_ops;
> +	inode->i_fop =3D &simple_dir_operations;
> +	inc_nlink(inode);
> +	sb->s_root =3D d_make_root(inode);
> +	if (!sb->s_root)
> +		return -ENOMEM;
> +	return 0;
> +}

[Severity: Medium]
Should kapfs_fill_super() initialize sb->s_op, sb->s_blocksize, and
sb->s_blocksize_bits?

Without sb->s_op =3D &simple_super_operations, statfs() and fstatfs() on
/sys/kernel/security/kap/igroups and its entries fail with -ENOSYS, and
leaving sb->s_blocksize and sb->s_blocksize_bits at zero causes stat() to
report st_blksize =3D 1.

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

[Severity: Medium]
Doesn't jumping onto the unattached kapfs_mnt cause d_path() in KAP's LSM
hooks to resolve paths under /sys/kernel/security/kap/igroups as
/<igroup>/<file>?

kapfs_mnt is created with kern_mount() and is not attached to any mountpoin=
t,
so when kap_file_target(), kap_lsm_file_path_alloc(), or
kap_lsm_check_dir_entry() calls d_path(), walk-back stops at
kapfs_mnt->mnt_root and omits the /sys/kernel/security/kap/igroups prefix:

security/kap/kap_lsm.c:kap_lsm_file_path_alloc() {
    ...
	path =3D d_path(&file->f_path, buf, PATH_MAX);
	if (IS_ERR(path)) {
		kfree(buf);
		return NULL;
	}
    ...
}

File rules targeting /sys or /sys/kernel/security/kap will therefore not ma=
tch
accesses under igroups/, and kap.events will log root-relative target paths.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202246.274-=
1-harisudhan@armoriq.io?part=3D4

