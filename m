Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB83C60A2601
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFBpScrJ
Received: by kanga.kvack.org (Postfix)
	id CD7116B05B5; Tue, 10 Nov 2026 15:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C602E6B05B6; Tue, 10 Nov 2026 15:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01C16B05B7; Tue, 10 Nov 2026 15:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAB2B6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:51:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EFAD1A0106
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:51:41 +0000 (UTC)
X-FDA: 85420405602.06.31A97FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B852680005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:51:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFBpScrJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343899;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbmQQa2mAdQ94zjd63i4RwLgNDZCZfbiZeXLmvJbA9Y=;
	b=TKnB4HfELYwcLMRwiucWlzW5eTrVG53tCNcu3uKsNXNygxU8Dmq1uU6jsl4OCGsk1X3AhH
	K5fPMD18CK8dMTInV2wSZ3k8nf5DFUtVa21TZ0igfttCsiqMSBLmHviTnU7BRT/tv1hVhf
	JG/O1y8Y0zPAUPxlhMneB12lrCeaQLw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFBpScrJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343899;
	b=iFz04Kx61AIeWGhYZvPrv/eQHXaZSlYqJi8yBktQXo/FImLd1DHnTZ3DHpr6GoMRTFTc9H
	fbdfbRWGnq0eMaqFT4G6B2Q05Aibu1bzV2Sj/ofXApi2RfTN29XcN8Q/N5hGo/8hvsfDQC
	4CV1wT5P17sMsATrhsgTfZGDAGVWkfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 290E360A00;
	Tue, 10 Nov 2026 20:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728FD1F0089F;
	Tue, 10 Nov 2026 20:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343898;
	bh=VbmQQa2mAdQ94zjd63i4RwLgNDZCZfbiZeXLmvJbA9Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cFBpScrJxA3ScI5z6JGD5g2YzOGQJFBDqeIh3arxDFd0PfI5ydRxhN2vLVPD3JJo+
	 x+cgC6lYSdVMrnXvL/zL1qK0KwL0ovS30EI8vpq4JXohPy+ZvLv4fXcgpoOFD6Fz0z
	 FZLjnvbaVCTfVp6LXpuvoFdB7oQIf8HsH+H0J0sLthZlbi4upcTDNi20+DK8+9DEmo
	 zELDf3wcx04MBFfVrijWoeJ6Vx4By644KmH5a3D/vsGrVYKLVbHz9+n4lEjauMqa1E
	 KZ8S3mV6mNMQMq9dgiUcLRtz8zqZMM+l2bIgNDjnDnJyOboxeUlH7okMQw7aH+6eRg
	 RkDHg1vMC+40Q==
Message-ID: <sashiko-outbox-207733@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 3/6] security: add the Kernel Assurance Plane LSM
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
In-Reply-To: <20261110202246.274-4-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
 <20261110202246.274-4-harisudhan@armoriq.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:51:37 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B852680005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dmodhpdwo3mfeyh96ehw7zy5egihxn48
X-HE-Tag: 1794343899-816891
X-HE-Meta: U2FsdGVkX1/7bC9xrz+Ebj82rjYLPy7k22Ei9Bot+k7GfJQfJS5QPDBWi9Pa9bHmlq++zs3ci9IYCOKLBr9YRGuopVNHbb1DTgoFgFRoxtBXaP/wL3190vCEsDJ+J1VAfPyp+UR8S0jweo0bSh4plpc88cZQhAsGAIQqA42ufv2alDMAYLKKNvpMhHqms+ix2YQWpd73cxnoWc1vq176XH7MB3uZOLAvzLnpIpZtF1h/PdxJQRUz034HYNCRsZGJcUrMdwcWRnEyPMDTjtRhMbhP9Qgy0YJNwUftda+guKzkR6YISvARkTT80/o9OfcaL1IaFVjrLM56Owa10eYrxCNQE+SxWP52siF+6O64iP6ZcqJOQngOqXrZ1UAkW8baeb2K95Nlsk2pSEn7ZE6WaAeP+0+6ALfBFd5upg5BUtuTOFtqASywdPBmGqlpIlyc2j+mf6QqOhMVahOocDkYVR1swiK7iwN2xfLxi8aaYxGsNVb6BOO/bcNcHhDq/klzmWMKyfl2oSa0g2WVUoLXeSxI5NeofGDKi8BSTqZH+URMyqjj6X9xEvRf6uY8xE39pBYQawNKWdDOnYb0iVPQ5mx8zH8Yen2+cYyf6O7XXm2qB0LfViOKrKKRVswaKbVJdk6UrCnIbs99bmf3yDfvg6Lj0s0r/9KaCWXGKv/T9Jhk/8ot/guq+4zFhf2GmM9RyX6/efzKGVYvCI+MDifqzkjWSxqklJII+xY0RfjQiRaoN7/S5jFxNaVhEkbXXEOf6bmMsfSVwKF8haojkN+4+LVUj9jVsL0RNfzX30ZLB0+YOBakhW3S+mHT3GR0E8y9mARnRJtA1hgtAKcECposG2WY0xWlu1WwSB0mnJFdQIxhkWKNtkoL6FJq6kGqTJg29BVNpPwnPdQA03rtXkSauSN8J1XWtldWe9QTvd/IUMlbmA+EzSdTYR8JhHcUrHGAGTAg1RzupA8GxVbZ9ja
 jeTI7bks
 C3aVNXnE/qkNgort44o0b8qG9N0zheQULkaKclW59NOZL5BalCyTF5s7ooPJPyI5FqZYuKI1kKU+Z8iODe5rngs17jAkDQ/FsNlbF4ZQe4Bz6NsSaE99L1hN94miA0KP343rcQNXtoYMSnPOJ/0wN3FFmpgh5TgUb8hcLKFjJPKmCSrZBilVVFmHmEA29y4fMDvO5xfmkVpTkjttTHcksiba4QcY47V+pQCnrRBVTy39b271tcKKegU/28dJi/bgwxrvdHxyewvI6io63d+VqDv3tEWd7XNGoIqeAODo6oI9uPufTqDAlwe8s4qidJAH7L1VD6HPpDCT8DFp+J6WXd4WJpHCid4G0rRd7/vCQsKc1eni2vs/Wr0TTCYjVtT9a42QfKzsgSRpHfwpL7oLdK0CYeSBtEaYj11yK2Z9iwhlXH/CT/S7FLPr22Yte5JOCVdBzM4S3zF4AG7Oi5K83gM8i2iNWOigCJxZS34KNlgF4ibFdeRSkuqJBz0V4hYYWzMBVsWN9xG1Nwmoh9ZEnl/nj+EVR4mh5rWqKh57P50Dtu5YUu7wXU3daatzD6lSXxOZM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 22 potential
issues to consider:
- [Critical] security: kap: unpinned d_parent use-after-free in
  kap_path_link()
- [High] security: kap: missing addrlen check in kap_socket_connect()
- [High] security: kap: KAP_HOOK_EXEC bypass via strstr() in
  kap_path_is_memfd()
- [High] security: kap: fail-open and skipped file checks in
  kap_mmap_file()
- [High] security: kap: deny rule bypass via d_path() in
  kap_file_prefix_match()
- [High] security: kap: kthread crash and clone race in
  kap_bind_pid_locked()
- [High] security: kap: wrong PID and namespace in
  kap_normalize_procfs_self()
- [High] security: kap: kap_ptrace_traceme() checks tracee instead of
  tracer
- [High] security: kap: fork race in kap_task_alloc() and
  kap_bind_pid_locked()
- [Medium] security: kap: missing kap entry in default CONFIG_LSM lists
  in Kconfig
- [Medium] security: kap: predicate boundary misparsing in
  kap_compile_kind_array()
- [Medium] security: kap: unlocked kap_task_state reads in
  kap_ptrace_target()
- [Medium] security: kap: path prefix and wildcard mismatch in
  kap_target_match()
- [Medium] security: kap: path truncation and fail-open fallback in
  kap_lsm_path_target()
- [Medium] security: kap: leak of kap_bound_pid entries on igroup->pids
  on task exit
- [Medium] security: kap: unlocked kap_task_state access in
  kap_ptrace_target()
- [Medium] security: kap: userns target mismatch in kap_userns_create()
- [Medium] kap: missing file_truncate hook and error fallthrough in
  kap_file_open()
- [Low] security: kap: missing static qualifier on kap_blob_sizes in
  kap_lsm.c
- [Low] security: kap: u64 overflow in kap_parse_transition_sequence()
- [Low] security: kap: log injection and event slicing in
  kap_append_event_locked()
- [Low] security: kap: kap_lock drop between check and event in
  kap_file_permission()
--

commit 0e8ce0130aad17cba4372a8036b850cd9a71a976
Author: HARIHARA SUDHAN. R <harisudhan@armoriq.io>

security: add the Kernel Assurance Plane LSM

This commit adds the Kernel Assurance Plane (KAP) LSM, implementing Intent
Lineage Groups (igroups), authority compilation and decision logic, and the
LSM hooks that enforce policy against bound tasks.

> diff --git a/security/Kconfig b/security/Kconfig
> index f7bf6cdc6229e..c2e6249fb8abb 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -228,6 +228,7 @@ source "security/safesetid/Kconfig"
>  source "security/lockdown/Kconfig"
>  source "security/landlock/Kconfig"
>  source "security/ipe/Kconfig"
> +source "security/kap/Kconfig"
> =20
>  source "security/integrity/Kconfig"

[Severity: Medium]
Should config LSM in security/Kconfig also include kap in its default strin=
gs?

DEFINE_LSM(kap) leaves .order at 0 (LSM_ORDER_MUTABLE), which lsm_order_par=
se()
only enables when the LSM name is listed in CONFIG_LSM or passed via the ls=
m=3D
boot parameter.  Without kap in the config LSM defaults, enabling
CONFIG_SECURITY_KAP=3Dy leaves KAP disabled at boot unless CONFIG_LSM or the
kernel command line is manually overridden.

> diff --git a/security/kap/igroup.c b/security/kap/igroup.c
> new file mode 100644
> index 0000000000000..069905a32e8ea
> --- /dev/null
> +++ b/security/kap/igroup.c
[ ... ]
> +	case KAP_HOOK_SOCKET_CONNECT: {
> +		const struct sockaddr *addr =3D object;
> +
> +		if (addr->sa_family =3D=3D AF_INET) {
> +			const struct sockaddr_in *in =3D object;
> +
> +			scnprintf(target, target_len, "%pI4:%u",
> +				  &in->sin_addr, ntohs(in->sin_port));
> +			return 0;
> +		}
> +		if (addr->sa_family =3D=3D AF_INET6) {
> +			const struct sockaddr_in6 *in6 =3D object;
> +
> +			scnprintf(target, target_len, "%pI6c:%u",
> +				  &in6->sin6_addr, ntohs(in6->sin6_port));
> +			return 0;
> +		}

[Severity: High]
Can this read uninitialized kernel stack memory when a bound task calls
connect(2) with a short addrlen?

In __sys_connect(), move_addr_to_kernel() copies only addrlen bytes into an
uninitialized struct sockaddr_storage on the stack before calling
security_socket_connect().  kap_socket_connect() only checks that addrlen
covers sa_family (2 bytes) and does not pass addrlen here.  When sa_family =
is
AF_INET or AF_INET6 and addrlen is smaller than sizeof(struct sockaddr_in) =
or
sizeof(struct sockaddr_in6), formatting sin_addr/sin_port or
sin6_addr/sin6_port reads uninitialized stack bytes, evaluates the net
predicate against garbage, and leaks those bytes through kap.events and dme=
sg.

> +		/* Other families, vsock among them, are named so a grant can allow th=
em. */
> +		scnprintf(target, target_len, "family:%u", addr->sa_family);
> +		return 0;
> +	}
[ ... ]
> +static bool kap_file_prefix_match(const char *target, const char *candid=
ate)
> +{
> +	size_t len =3D strlen(candidate);
> +	size_t target_len =3D strlen(target);
> +
> +	if (!strcmp(target, candidate))
> +		return true;
> +	if (!len || target_len <=3D len)
> +		return false;
> +	if (candidate[len - 1] =3D=3D '/')
> +		return !strncmp(target, candidate, len);
> +	return target[len] =3D=3D '/' && !strncmp(target, candidate, len);
> +}

[Severity: High]
Can a bound task bypass a file or exec deny rule by unlinking the target fi=
le
before accessing or executing its open file descriptor?

kap_file_target() and kap_lsm_file_path_alloc() resolve paths with d_path(),
which appends " (deleted)" when the dentry has been unlinked.  For a policy
that allows "/srv/work" and denies "/srv/work/keys", an unlinked file resol=
ves
to "/srv/work/keys (deleted)": kap_file_prefix_match() rejects the deny
pattern because the character after "/srv/work/keys" is ' ' rather than '/'=
 or
NUL, but still matches the parent directory allow pattern "/srv/work".
Also, because d_path() resolves paths relative to current->fs->root and
path_chroot is not hooked, a bound task that can call chroot(2) shifts all
d_path()-resolved paths relative to the new root.

> +static bool kap_string_match(const char *target, const char *candidate)
> +{
> +	size_t len =3D strlen(candidate);
> +
> +	if (!strcmp(candidate, "*"))
> +		return true;
> +	if (!strcmp(target, candidate))
> +		return true;
> +	if (len && candidate[len - 1] =3D=3D '*')
> +		return !strncmp(target, candidate, len - 1);
> +	return false;
> +}
> +
> +static bool kap_target_match(enum kap_hook_kind kind, const char *target,
> +			     const char *candidate)
> +{
> +	if (!strcmp(candidate, "*"))
> +		return true;
> +	if (kind =3D=3D KAP_HOOK_FILE || kind =3D=3D KAP_HOOK_DESCRIPTOR ||
> +	    kind =3D=3D KAP_HOOK_PROCFS)
> +		return kap_file_prefix_match(target, candidate);
> +	return kap_string_match(target, candidate);
> +}

[Severity: Medium]
Should KAP_HOOK_EXEC also use kap_file_prefix_match(), and should
kap_file_prefix_match() handle trailing '*' wildcards?

Routing KAP_HOOK_EXEC to kap_string_match() means a directory pattern such =
as
"/usr/bin" fails to match "/usr/bin/id", while a wildcard pattern such as
"/usr/bin*" matches sibling paths like "/usr/bin_untrusted/app" without a '=
/'
boundary.  Conversely, in kap_file_prefix_match(), a trailing '*' in a file,
descriptor, or procfs pattern is treated as a literal '*' character rather
than a wildcard.

[ ... ]
> +/* Collect one array across every predicate of a kind, keeping the set c=
ontiguous. */
> +static int kap_compile_kind_array(struct kap_compiled_authority *compile=
d,
> +				  struct kap_pattern_set *set,
> +				  const char *auth, const char *end,
> +				  const char *kind_name, const char *array_name)
> +{
> +	const char *predicate =3D auth;
> +
> +	set->offset =3D compiled->pool_used;
> +	set->count =3D 0;
> +	while ((predicate =3D kap_next_predicate(predicate, end, kind_name))) {
> +		const char *next =3D strstr(predicate + 1, "\"kind\":");
> +		const char *predicate_start =3D predicate;
> +		const char *predicate_end =3D next && next < end ? next : end;
> +		int rc;
> +
> +		while (predicate_start > auth && *predicate_start !=3D '{')
> +			predicate_start--;
> +		rc =3D kap_compile_array(compiled, set, predicate_start,
> +				       predicate_end, array_name);
> +		if (rc)
> +			return rc;
> +		predicate =3D predicate_end;
> +	}
> +	return 0;
> +}

[Severity: Medium]
Can kap_compile_kind_array() and kap_validate_authority_payload() misparse
predicate boundaries when "allow" or "deny" precedes "kind" in a JSON
predicate object?

predicate_end is set to the next "\"kind\":" token rather than the closing =
'}'
of the current predicate object, so [predicate_start, predicate_end) extends
across "},{" into the next predicate up to its "\"kind\":" key.  If a
serializer emits keys in alphabetical order ("allow", "deny", "kind") and a
pattern before "kind" contains '{' (such as "/srv/{secret}"), the backward
scan for '{' stops inside that pattern string, drops the current predicate's
earlier arrays, and compiles the next predicate's pre-"kind" arrays into th=
is
predicate's hook kind.  In addition, kap_compile_array() scans for '"' with=
out
skipping escaped quotes (\" inside pattern strings).

[ ... ]
> +static int kap_refuse_unbound(enum kap_hook_kind kind, const char *targe=
t)
> +{
> +	pr_warn_ratelimited("deny igroup=3D<unbound> op=3D%s target=3D%s reason=
=3Dunbound_task pid=3D%d\n",
> +			    kap_hook_name(kind), target ? target : "",
> +			    task_pid_nr(current));
> +	return -EACCES;
> +}

[Severity: Low]
Does kap_refuse_unbound() log target without escaping newlines or control
characters, and does kap_append_event_locked() slice JSON lines on eviction?

Unlike kap_append_event_locked(), kap_refuse_unbound() passes target direct=
ly
to pr_warn_ratelimited(), so an unbound task in a non-initial PID namespace
executing a path containing '\n' can inject forged lines into dmesg.  In
kap_append_event_locked(), when igroup->events_len + len >=3D
KAP_MAX_EVENTS_BYTES, memmove() retains the last KAP_MAX_EVENTS_BYTES / 2
bytes without advancing to the next '\n', leaving a truncated JSON fragment=
 at
the start of kap.events.

[ ... ]
> +int kap_parse_transition_sequence(const char *payload, u64 *sequence)
> +{
[ ... ]
> +	while (*cursor >=3D '0' && *cursor <=3D '9') {
> +		seen_digit =3D true;
> +		value =3D value * 10 + (*cursor - '0');
> +		cursor++;
> +	}

[Severity: Low]
Can value =3D value * 10 + (*cursor - '0') overflow u64 when parsing sequen=
ce
numbers?

A decimal sequence string >=3D 2^64 wraps around modulo 2^64 without return=
ing
an error, which can bypass or corrupt the sequence monotonicity check again=
st
igroup->last_sequence in kap_install_locked().

[ ... ]
> +int kap_bind_pid_locked(struct kap_igroup *igroup, pid_t pid,
> +			struct kap_bound_pid **entry)
> +{
> +	struct task_struct *task, *t;
> +
> +	if (pid <=3D 0)
> +		return -EINVAL;
> +	rcu_read_lock();
> +	task =3D pid_task(find_vpid(pid), PIDTYPE_PID);
> +	if (!task) {
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +	for_each_thread(task, t) {
> +		struct kap_task_state *state =3D kap_task_state(t);
> +
> +		if (!state)
> +			continue;
> +		state->active =3D true;
> +		state->epoch =3D igroup->epoch;
> +		strscpy(state->igroup_name, igroup->name, sizeof(state->igroup_name));
> +	}
> +	rcu_read_unlock();

[Severity: High]
What happens if kap_bind_pid_locked() is given the PID of a kernel thread?

pid_task() does not reject tasks with PF_KTHREAD set, which have current->fs
=3D=3D NULL.  If a kthread is bound, the next KAP hook that calls d_path()
dereferences current->fs in get_fs_root_rcu() and crashes with a NULL point=
er
dereference.

> +	if (kap_pid_in_igroup_locked(igroup, pid))
> +		return 0;
> +	(*entry)->pid =3D pid;
> +	list_add_tail(&(*entry)->node, &igroup->pids);
> +	*entry =3D NULL;
> +	return 0;
> +}

[Severity: Medium]
Are struct kap_bound_pid entries on igroup->pids leaked when bound processes
exit or are rebound?

kap_bind_pid_locked() appends *entry to igroup->pids, but kap_task_free() o=
nly
zeroes struct kap_task_state without removing the exiting task's entry from
igroup->pids, and rebinding a task to another igroup never removes it from =
the
previous igroup's list.  As a result, igroup->pids accumulates leaked entri=
es
and stale or recycled PIDs for the lifetime of the igroup.

> diff --git a/security/kap/kap_lsm.c b/security/kap/kap_lsm.c
> new file mode 100644
> index 0000000000000..b148b3437d900
> --- /dev/null
> +++ b/security/kap/kap_lsm.c
[ ... ]
> +struct lsm_blob_sizes kap_blob_sizes __ro_after_init =3D {
> +	.lbs_task =3D sizeof(struct kap_task_state),
> +};

[Severity: Low]
Should kap_blob_sizes be declared static?  It is only used in
security/kap/kap_lsm.c and has no declaration in security/kap/kap.h, which
triggers a -Wmissing-declarations warning under W=3D1.

[ ... ]
> +static int kap_task_alloc(struct task_struct *task, u64 clone_flags)
> +{
> +	struct kap_task_state *old =3D kap_task_state(current);
> +	struct kap_task_state *new =3D kap_task_state(task);
> +	int rc;
> +
> +	if (!new)
> +		return 0;
> +
> +	rc =3D kap_check_namespace_flags(clone_flags, "clone");
> +	if (rc)
> +		return rc;
> +
> +	memset(new, 0, sizeof(*new));
> +	/* Under kap_lock, so a bind running now is copied whole or not at all.=
 */
> +	spin_lock(&kap_lock);
> +	if (old && old->active)
> +		*new =3D *old;
> +	spin_unlock(&kap_lock);
> +	return 0;
> +}

[Severity: High]
Can a concurrently cloning thread miss an igroup binding in
kap_bind_pid_locked()?

In copy_process(), security_task_alloc() runs before the new task is linked
onto signal->thread_head under siglock:

CPU0                              CPU1
copy_process()
  security_task_alloc()
    kap_task_alloc()
      spin_lock(&kap_lock)
      /* old->active is false */
      spin_unlock(&kap_lock)
                                  kap_bind_pid_locked()
                                    spin_lock(&kap_lock)
                                    for_each_thread(task, t)
                                      /* new task not on thread_head yet */
                                    spin_unlock(&kap_lock)
  write_lock_irq(&tasklist_lock)
  list_add_tail_rcu(&p->thread_node,
                    &p->signal->thread_head)  <-- runs unbound

The new thread finishes clone() without the binding even after
kap_bind_pid_locked() returns success.  Also, kap_task_alloc() unconditiona=
lly
takes kap_lock on every fork() even when kap_ready is false and current is
unbound.

[ ... ]
> +static int kap_bprm_check_security(struct linux_binprm *bprm)
> +{
> +	char *target;
> +
> +	/*
> +	 * An unbound task is skipped everywhere else, but under
> +	 * kap.default =3D closed an unbound exec is the one thing that must not
> +	 * proceed.
> +	 */
> +	if (!kap_lsm_current_active() && !kap_fail_closed_kind(KAP_HOOK_EXEC))
> +		return 0;
> +	if (bprm->file) {
> +		target =3D kap_lsm_file_path_alloc(bprm->file);
> +		if (!IS_ERR(target)) {
> +			if (kap_path_is_memfd(target)) {
> +				int rc =3D kap_check_current_target_emit(KAP_HOOK_EXECMEM, target,
> +								       "memfd_exec_predicate_denied",
> +								       "memfd_exec_allowed");
> +				kfree(target);
> +				return rc;
> +			}
> +			kfree(target);
> +		}
> +	}
> +	return kap_check_current_emit(KAP_HOOK_EXEC, bprm,
> +				      "exec_predicate_denied", "exec_allowed");
> +}

[Severity: High]
Can a bound task bypass KAP_HOOK_EXEC predicates by executing a file whose
path contains the substring "memfd:"?

kap_path_is_memfd() checks strstr(path, "/memfd:") || strstr(path, "memfd:"=
),
which matches any regular file or directory on disk containing "memfd:" in =
its
path (for example, "/tmp/memfd:payload").  When kap_path_is_memfd() returns
true, kap_bprm_check_security() checks only KAP_HOOK_EXECMEM and returns
without checking KAP_HOOK_EXEC, so any bound task whose igroup allows
KAP_HOOK_EXECMEM (such as "*" for JIT) can execute arbitrary binaries renam=
ed
to include "memfd:".

[ ... ]
> +static int kap_lsm_path_target(const struct path *path, char *target, si=
ze_t target_len)
> +{
> +	char *path_buf;
> +	char *rendered;
> +	int rc =3D 0;
> +
> +	if (!path)
> +		return -EINVAL;
> +	path_buf =3D kmalloc(PATH_MAX, GFP_KERNEL);
> +	if (!path_buf)
> +		return -ENOMEM;
> +	rendered =3D d_path(path, path_buf, PATH_MAX);
> +	if (IS_ERR(rendered))
> +		rc =3D PTR_ERR(rendered);
> +	else
> +		strscpy(target, rendered, target_len);
> +	kfree(path_buf);
> +	return rc;
> +}

[Severity: Medium]
Can long or unresolvable mount paths bypass deny rules in kap_sb_mount(),
kap_sb_umount(), kap_sb_pivotroot(), and kap_move_mount()?

kap_lsm_path_target() ignores the -E2BIG return from strscpy() when rendered
exceeds KAP_LSM_TARGET_LEN (256 bytes), and the mount hooks substitute
"unknown" when kap_lsm_path_target() fails instead of failing closed.  A
bound task in a mount namespace can use a mount point path >=3D 256 bytes s=
o the
truncated target no longer matches a specific deny prefix while still match=
ing
a broader allow rule.

[ ... ]
> +static void kap_normalize_procfs_self(char *target)
> +{
> +	static const char self[] =3D "/proc/self";
> +	const size_t self_len =3D sizeof(self) - 1;
> +	char prefix[32];
> +	size_t prefix_len;
> +	size_t tail_len;
> +
> +	prefix_len =3D scnprintf(prefix, sizeof(prefix), "/proc/%d", task_pid_n=
r(current));
> +	if (strncmp(target, prefix, prefix_len))
> +		return;
> +	if (target[prefix_len] !=3D '\0' && target[prefix_len] !=3D '/')
> +		return;
> +	tail_len =3D strlen(target + prefix_len);
> +	if (self_len + tail_len >=3D PATH_MAX)
> +		return;
> +	memmove(target + self_len, target + prefix_len, tail_len + 1);
> +	memcpy(target, self, self_len);
> +}

[Severity: High]
Does kap_normalize_procfs_self() match the wrong PID when called from a
non-leader thread or inside a child PID namespace?

/proc/self resolves to the thread-group ID in the PID namespace of the proc=
fs
superblock (task_tgid_nr_ns(current, proc_pid_ns(inode->i_sb))), whereas
task_pid_nr(current) returns the calling thread's TID in init_pid_ns.  For =
any
secondary thread (tid !=3D tgid) or any task in a child PID namespace with =
its
own /proc mount, /proc/self accesses are not normalized to "/proc/self",
breaking /proc/self allow rules and bypassing /proc/self deny rules when a
broader /proc allow rule is present.  In a child PID namespace, if another
process has a container PID equal to current's init_pid_ns TID, its /proc/<=
pid>
entries are also falsely rewritten to /proc/self.

[ ... ]
> +static int kap_file_permission(struct file *file, int mask)
> +{
[ ... ]
> +	if (kap_path_is_procfs(target)) {
> +		kap_normalize_procfs_self(target);
> +		rc =3D kap_check_current_target_why(KAP_HOOK_PROCFS, target, &why);
> +		if (rc)
> +			kap_emit_current_event_target(KAP_HOOK_PROCFS, 0,
> +						      why ?: "procfs_use_predicate_denied", target);
> +	} else {
> +		rc =3D kap_check_current_target_why(KAP_HOOK_FILE, target, &why);
> +		if (rc)
> +			kap_emit_current_event_target(KAP_HOOK_FILE, 0,
> +						      why ?: "file_use_predicate_denied", target);
> +	}
> +	kfree(target);
> +	return rc;
> +}

[Severity: Low]
Can dropping kap_lock between kap_check_current_target_why() and
kap_emit_current_event_target() log the wrong epoch or lineage_root?

kap_check_current_target_why() releases kap_lock before returning, and
kap_emit_current_event_target() reacquires it to format the denial event.  =
If
an install or rebind happens in between, the event is recorded with the new
epoch and lineage_root rather than the state that caused the denial.

> +
> +static int kap_mmap_file(struct file *file, unsigned long reqprot,
> +			 unsigned long prot, unsigned long flags)
> +{
> +	char *target;
> +	int rc =3D 0;
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +	if (!(reqprot & PROT_EXEC) && !(prot & PROT_EXEC))
> +		return 0;
> +	if (!file)
> +		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "anonymous",
> +						     "execmem_predicate_denied",
> +						     "execmem_allowed");
> +	target =3D kap_lsm_file_path_alloc(file);
> +	if (IS_ERR(target))
> +		return 0;
> +	if (kap_path_is_memfd(target))
> +		rc =3D kap_check_current_target_emit(KAP_HOOK_EXECMEM, target,
> +						   "execmem_predicate_denied",
> +						   "execmem_allowed");
> +	kfree(target);
> +	return rc;
> +}

[Severity: High]
Why do kap_mmap_file() and kap_file_mprotect() return 0 when
kap_lsm_file_path_alloc() fails or when mapping a non-memfd file with
PROT_EXEC?

If kap_lsm_file_path_alloc() fails (for example with -ENOMEM or
-ENAMETOOLONG), returning 0 fails open and allows the executable mapping ev=
en
when the igroup is revoked or expired.  When target is a regular file rather
than a memfd, both hooks also skip KAP_HOOK_EXECMEM completely and return 0,
leaving the KAP_HOOK_EXECMEM file case in kap_object_target() unused.

[ ... ]
> +int kap_check_namespace_flags(unsigned long flags, const char *operation)
> +{
> +	int rc;
> +	int i;
> +
> +	if (!operation || !*operation)
> +		operation =3D "transition";
> +	for (i =3D 0; i < ARRAY_SIZE(kap_namespaces); i++) {
> +		if (!(flags & kap_namespaces[i].flag))
> +			continue;
> +		/* Creating a user namespace is checked by userns_create. */
> +		if (kap_namespaces[i].flag =3D=3D CLONE_NEWUSER &&
> +		    strcmp(operation, "setns"))
> +			continue;
> +		rc =3D kap_check_namespace_target(kap_namespaces[i].name, operation);
> +		if (rc)
> +			return rc;
> +	}
> +	return 0;
> +}

[Severity: Medium]
Does deferring CLONE_NEWUSER to kap_userns_create() break policies that use
"user:clone", "user:unshare", or "user:*"?

kap_check_namespace_flags() skips CLONE_NEWUSER for clone and unshare so th=
at
kap_userns_create() checks it, but kap_userns_create() passes the bare targ=
et
string "user" instead of the "TYPE:OPERATION" format used by all other
namespace checks.  In kap_string_match(), "user:clone", "user:unshare", and
"user:*" do not match "user", so user namespace creation is denied under th=
ose
predicates.

[ ... ]
> +static int kap_path_link(struct dentry *old_dentry, const struct path *n=
ew_dir,
> +			 struct dentry *new_dentry)
> +{
> +	struct path old_path;
> +	int rc;
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +	/* Checking only the destination would let a denied file be linked into
> +	 * an allowed directory and then read through the alias, since the later
> +	 * open sees the allowed name. A hard link cannot cross a mount, so the
> +	 * source shares new_dir's vfsmount.
> +	 */
> +	old_path.mnt =3D new_dir ? new_dir->mnt : NULL;
> +	old_path.dentry =3D old_dentry ? old_dentry->d_parent : NULL;
> +	rc =3D kap_lsm_check_dir_entry(&old_path, old_dentry);
> +	if (rc)
> +		return rc;
> +	return kap_lsm_check_dir_entry(new_dir, new_dentry);
> +}

[Severity: Critical]
Can reading old_dentry->d_parent without dget_parent() cause a use-after-fr=
ee
in d_path()?

In filename_linkat(), only new_dir's inode is locked; old_dentry's parent is
neither locked nor pinned by a reference.  kap_lsm_check_dir_entry() perfor=
ms
two GFP_KERNEL allocations that can sleep before passing &old_path to
d_path():

CPU0                              CPU1
kap_path_link()
  old_path.dentry =3D old_dentry->d_parent
  kap_lsm_check_dir_entry(&old_path, ...)
    kmalloc(PATH_MAX, GFP_KERNEL)
                                  rename(old_dentry, ...)
                                  rmdir(former_parent)
                                    /* former_parent dentry freed */
    d_path(&old_path, ...)        <-- use-after-free on old_path.dentry

Taking a reference with dget_parent(old_dentry) and dropping it with dput()
after kap_lsm_check_dir_entry() would keep the parent dentry alive across t=
he
allocations.

[ ... ]
> +static void kap_ptrace_target(struct task_struct *child, char *target, s=
ize_t target_len)
> +{
> +	struct kap_task_state *current_state =3D kap_task_state(current);
> +	struct kap_task_state *child_state =3D kap_task_state(child);
> +
> +	if (current_state && current_state->active &&
> +	    child_state && child_state->active &&
> +	    !strcmp(current_state->igroup_name, child_state->igroup_name) &&
> +	    current_state->epoch =3D=3D child_state->epoch) {
> +		strscpy(target, "same-igroup", target_len);
> +		return;
> +	}
> +	if (child_state && child_state->active) {
> +		scnprintf(target, target_len, "igroup=3D%s", child_state->igroup_name);
> +		return;
> +	}
> +	strscpy(target, "unconfined", target_len);
> +}

[Severity: Medium]
Can kap_ptrace_target() observe a partially written kap_task_state when rac=
ing
with kap_bind_pid_locked()?

kap_bind_pid_locked() sets state->active =3D true before writing state->epo=
ch
and state->igroup_name under kap_lock, while kap_ptrace_target() reads
active, igroup_name, and epoch from both tasks without holding kap_lock:

CPU0                              CPU1
kap_bind_pid_locked()
  spin_lock(&kap_lock)
  state->active =3D true
                                  kap_ptrace_access_check()
                                    kap_ptrace_target()
                                      if (child_state->active)
                                        scnprintf(..., "igroup=3D%s",
                                                  child_state->igroup_name)
                                                  <-- empty or torn name
  state->epoch =3D igroup->epoch
  strscpy(state->igroup_name, ...)
  spin_unlock(&kap_lock)

Because kap_ptrace_target() runs without kap_lock, it can format "igroup=3D"
with an empty or torn igroup_name or compare a mismatched (igroup_name, epo=
ch)
pair.

[ ... ]
> +static int kap_ptrace_traceme(struct task_struct *parent)
> +{
> +	char target[128];
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +
> +	kap_ptrace_target(parent, target, sizeof(target));
> +	return kap_check_current_target_emit(KAP_HOOK_PTRACE, target,
> +					     "ptrace_predicate_denied", "ptrace_allowed");
> +}

[Severity: High]
Does kap_ptrace_traceme() check the tracee's authority instead of the trace=
r's?

In ptrace_traceme(), parent is the tracer and current is the tracee.  By
checking kap_lsm_current_active() and kap_check_current_target_emit(),
kap_ptrace_traceme() evaluates current's igroup policy against parent.  A
bound parent whose igroup denies ptrace can therefore trace an unbound child
(or a child in an igroup that allows ptrace) if the child calls
PTRACE_TRACEME, while an unconfined parent is blocked from tracing a bound
child via PTRACE_TRACEME.

[ ... ]
> +static struct security_hook_list kap_hooks[] __ro_after_init =3D {
> +	LSM_HOOK_INIT(task_alloc, kap_task_alloc),
> +	LSM_HOOK_INIT(task_free, kap_task_free),
> +	LSM_HOOK_INIT(bprm_check_security, kap_bprm_check_security),
> +	LSM_HOOK_INIT(sb_mount, kap_sb_mount),
> +	LSM_HOOK_INIT(sb_umount, kap_sb_umount),
> +	LSM_HOOK_INIT(sb_pivotroot, kap_sb_pivotroot),
> +	LSM_HOOK_INIT(move_mount, kap_move_mount),
> +	LSM_HOOK_INIT(file_open, kap_file_open),
> +	LSM_HOOK_INIT(file_permission, kap_file_permission),
> +	LSM_HOOK_INIT(mmap_file, kap_mmap_file),
> +	LSM_HOOK_INIT(file_mprotect, kap_file_mprotect),
> +	LSM_HOOK_INIT(file_receive, kap_file_receive),
> +	LSM_HOOK_INIT(path_rename, kap_path_rename),
> +	LSM_HOOK_INIT(path_link, kap_path_link),
> +	LSM_HOOK_INIT(path_symlink, kap_path_symlink),
> +	LSM_HOOK_INIT(path_mknod, kap_path_mknod),
> +	LSM_HOOK_INIT(path_mkdir, kap_path_mkdir),
> +	LSM_HOOK_INIT(path_unlink, kap_path_unlink),
> +	LSM_HOOK_INIT(path_rmdir, kap_path_rmdir),
> +	LSM_HOOK_INIT(path_truncate, kap_path_truncate),

[Severity: Medium]
Should kap_hooks[] also hook file_truncate, and should kap_file_open() and
kap_bprm_check_security() fail closed when kap_lsm_file_path_alloc() returns
an error?

do_ftruncate() calls security_file_truncate(file) and does not call
security_path_truncate() or security_file_permission(), so a bound task who=
se
authority is later narrowed, expired, or revoked can still empty an
already-open writable file descriptor via ftruncate(2).  In addition, when
kap_lsm_file_path_alloc() returns an ERR_PTR in kap_file_open() or
kap_bprm_check_security(), execution falls through to KAP_HOOK_FILE or
KAP_HOOK_EXEC instead of failing closed, evaluating /proc opens against
KAP_HOOK_FILE (without /proc/self normalization) and memfd execs against
KAP_HOOK_EXEC if the second allocation succeeds.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202246.274-=
1-harisudhan@armoriq.io?part=3D3

