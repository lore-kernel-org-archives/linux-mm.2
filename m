Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9939606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQzXt9mW
Received: by kanga.kvack.org (Postfix)
	id A6CF46B05B2; Mon, 23 Nov 2026 07:09:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45A76B05B9; Mon, 23 Nov 2026 07:09:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9339C6B05C9; Mon, 23 Nov 2026 07:09:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6900F6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:09:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BED1B120876
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:09:00 +0000 (UTC)
X-FDA: 85466262840.26.556CF55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 19D7F12000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:08:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQzXt9mW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435739;
	b=OJzBxdA164HDv9K/6CK/P1AflF2h0jVoJoYcOYsfBne8YTrn0LGuDvLKeqG+bXQgyBtmPR
	zDHZ5UtRXSDtUNeOhnKBcw9jHtmylm9Mt/x9z/+JyDzrmVpp96eAVUOK/111VStp1KabQT
	AllR/mcKs+Nq74sgtKZ/yDwNSyAdUhE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1M0Ah893FfgPdlXCwvFc3LtN2p/HJcXxFfVItFzOFxw=;
	b=M3l9enOcoVfKnXfMVXU2Ot9zzRl5uFaXFedDbUORUfiDS951telYps5OLg5nD1Ii8aeXsM
	Fqg5Otqbz5D0/00CSDS/EBRpNgNiWjVyzX3Qyx61C98eo/eetvDWwjTyGxlUFBacFFQOXU
	w9FGPTr/6pjXa3zOz4QQW+hPDdedUGc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQzXt9mW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38FC261F4B;
	Mon, 23 Nov 2026 12:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573DE1F000C4;
	Mon, 23 Nov 2026 12:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435737;
	bh=1M0Ah893FfgPdlXCwvFc3LtN2p/HJcXxFfVItFzOFxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XQzXt9mW20oqKL7tsz02i/ZrBurfVxUg4OIav3m06R+Y8cX+95v7a2Tu3xci0s4Ch
	 ctXLERkd/YhYQ8nWaH+dy4Psnj5QQr6qcyDMa6XppRI+9stj3ZJ+gEm/KHbpK88SvA
	 c8fx0oEu3M7+LQ2jlUSLPEI3po94smhMcTSmO7C/NWpNSqdL764PRSssPSk5L0NMCl
	 1W1Wvji6I1652jiYDsGrnvipQaB92/963I5nFVXeuGEmsCONCY6YZyzgc6ToAByg36
	 eH9kkUIdREFx7xnPbkS7dSNzh6Kc/gX+VuXXu4c5DJP/h6QeGxjWZ6TosxgBt+E4TG
	 blM2tRhQpiT+Q==
Message-ID: <sashiko-outbox-229193@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 3/6] security: add the Kernel Assurance Plane LSM
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
In-Reply-To: <20261123114308.8103-4-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
 <20261123114308.8103-4-harisudhan@armoriq.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 12:08:55 +0000
X-Stat-Signature: 4bkq58umbqz1dpixseketdwdcra3hed7
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 19D7F12000A
X-HE-Tag: 1795435738-686680
X-HE-Meta: U2FsdGVkX1/c9+uFgZ33qxyBlX8n5ES8a9Y05iFkpRii6EndxHAh9blYyTdKHVi4UH+OYlRZPza9cL7naZeo6SQiGhlgoKbrN2XQOaTNqvwmeyfLykv8d588bB9hE9zeAL4PjY6OZHBUg48u+7dwHvm2oW+lk3nLZDIyQWYDIO0HAaqAhWE8WEI5j0qKyAhCogvoVH5Obii5CZCmCnNIpYZB+rf/QDfDx9x4S+0SJMyF/VCk0k++Wt2fR/Bhjpmu1UoKkyA3EGBGayYkIBlj8wjcIYPc4ZkoEXe6R0qMYSgVFoGQqK99igZi3BKcKvr01liJncPYE9moLNd02RTrpz9ePV38KOt8Jk0PZtPXtUt7hJDNs5vUApwm6xtFZ+oe9qVY9ch5R6fVVxd3Fa2JZ4E9TcL4fFzQgLq4p4y73QdSyM/MqDEkd9aessq2m090fBMeJvTwOrvRlIUEkIr+3HtoaueV4Qa9etZ0n3q0lMwaom7FYolS/lWkxARFjQBTVj857Vx2X5kn/2S72INA18+WaK4QShlBVEpyaEy4xKMOMiTz4qmqEy5ALVw3iBeP+eXN4gZWytguZLAcGZtdJK06T+IQg5IXyMeksKO+zP7XKssU3sEDgzolII2/UF743DUIX5TGxZgr3ioRj+lmTqjuYHKccRAjLhXBx2FCsQ6y4UE0Ytusk7d1KZ4txmToO3hG+Sn++MCIq2BEWmhI3UJ7mHOgBLSQfA/Aj0FuIE/yFp3gzvMYjP2TApbow3nZeOo+uP53WwCbNPxSJFXRK77xJ1vv4/ly5wLFnb6KESpx13cXNC/pITKSvwbNe9fYZM8RDtS1Tu50ZX6LXIuQ1ewmuw9qUn4blJ3zNiD6RlWamFjEKBnG7aplxLJB8HJ1TobEpXglP0QkPLWi9tU0Ctrj+4Aga3JoHpGSa7ykEb3QGoAuobl98Dr6vsoEHbZVddXTDprbiV0GBjox6lD
 tYsKML3h
 NmNxLjwlVYiMmJi9i7sQizoF9ydjB2Wp684M+rERRwiJZCKjV6LygJGXqyq8svm2eNFLb/COepXR8AzahR8LL1DbYJUW70bYVRuzxnDjUqiSpg/3PCDuJOL3oi7OoHmnVPxAqupUA5nPE9i9snXlINLCfPkfft986EQFNEVEe1wg0k6p7/Q9DmfAhsZPY8iAiGIvY1lxxY1F4mX2WQ0JjSsl8oNKX+CzCXColLLCEt6gNV9awg1LYQw26+cF9po7i/F5kV3julVpPGVg+KYqtpaCA/lhwl28G1hIcpd58iM86HQvuJ3tYnKi2ve+WkTuebcZcURuitMB6GhEJdWnPcTMVxiJKOhAHNIgLS5ieGg0//3nSk3wmG0yIL+9nfMaug/SxVYsfW0vgC0L0usOvzp2W4w9SewGTk+0UBYzMRYk7RyrOp8dD4Y6oTAIeEPXLWlPOgufZjAQzbregpaV9DCja+ZMrzYOo0/lpY0u1T9Cpky1p8WvFJg6knuScMjsA375t80gO/OKxbEb2DOAewzvglMObihYhUg/fpfYUEi/PAVLYeppwDsdrwP9ZRlQHrrPiHwMI+6Lrugcn4CC3QODDFSOmeuMp7kVegzXItjr+n6BvA9M6uxRQT7xWexlPLzthMz38yHPvbc2iP6uytEnAdDJH/2EqlhVURiLO2Q9VCrkYpCxlx2uP/set9nS07vkp8itZLo5yf2zz+ue45GGWT6xMjQaUCxQGSVCxYDPMgpc7a87XO3bqNbVooYeNSxXFYN1VzmJYgvXuF0wVsyYtg/MNi+KUa9mEXJ2oyaBXyyXUOm3yw95Qf1scqDvoGng7eBtZFl3k92tvgwcsSkC/YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 23 potential
issues to consider:
- [High] security: kap: exec and file deny bypasses in
  kap_target_match() and path hooks
- [High] security: kap: kthread NULL dereference and clone/ptrace races
  in kap_bind_pid_locked()
- [High] security: kap: AF_INET6 check bypass for 24-byte addr in
  kap_socket_connect()
- [High] security: kap: fork race between kap_task_alloc() and
  kap_bind_pid_locked()
- [High] security: kap: KAP_HOOK_EXEC bypass via strstr() in
  kap_path_is_memfd()
- [High] security: kap: skipped file checks and fail-open in
  kap_mmap_file()
- [High] security: kap: kap_ptrace_traceme() checks tracee instead of
  tracer
- [High] security: kap: per-read/write PATH_MAX allocation and d_path()
  in kap_file_permission()
- [Medium] security: kap: missing kap in CONFIG_LSM defaults and
  non-static kap_blob_sizes
- [Medium] security: kap: predicate boundary misparsing in
  kap_compile_kind_array()
- [Medium] security: kap: fail-open missing igroup lookup and dropped
  target error events
- [Medium] security: kap: leak of kap_bound_pid entries on igroup->pids
  across task exit
- [Medium] security: kap: unlocked kap_task_state reads in
  kap_ptrace_target()
- [Medium] security: kap: unreleased bound PID entries on exit in
  kap_task_free()
- [Medium] security: kap: unconditional kap_lock acquisition in
  kap_task_alloc()
- [Medium] security: kap: path truncation and fail-open in
  kap_lsm_path_target()
- [Medium] security: kap: global kap_lock contention and 32 KB memmove
  on decisions
- [Medium] security: kap: missing file_truncate hook and path error
  fallthrough
- [Medium] security: kap: incomplete /proc/self normalization in
  kap_normalize_procfs_self()
- [Medium] security: kap: redundant PATH_MAX allocations and duplicate
  d_path() walks
- [Low] security: kap: mid-line event eviction and unsanitized log
  target in igroup.c
- [Low] security: kap: missing static qualifier on kap_blob_sizes in
  kap_lsm.c
- [Low] security: kap: kap_lock dropped between check and event in
  kap_file_permission()
--

commit a3cb8d67606c08d7aa688fd960b271d8e6cc508a
Author: HARIHARA SUDHAN. R <harisudhan@armoriq.io>

security: add the Kernel Assurance Plane LSM

This commit adds the Kernel Assurance Plane (KAP) LSM, implementing
Intent Lineage Groups (igroups), compiled authority decisions, per-igroup
event logging, and the LSM hooks that mediate bound tasks.

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
> =20

[Severity: Medium]
Should kap also be added to the default strings of config LSM in
security/Kconfig?

DEFINE_LSM(kap) uses the default LSM_ORDER_MUTABLE ordering, which
lsm_order_parse() only initializes when the LSM name is listed in
CONFIG_LSM or the lsm=3D boot parameter.  Without kap in the config LSM
defaults, enabling CONFIG_SECURITY_KAP=3Dy leaves KAP inactive at boot
unless CONFIG_LSM or the kernel command line is manually overridden.  In
addition, kap_blob_sizes in security/kap/kap_lsm.c is defined without
static and has no header declaration, triggering a -Wmissing-declarations
warning under W=3D1 builds.

> diff --git a/security/kap/igroup.c b/security/kap/igroup.c
> new file mode 100644
> index 0000000000000..0d6ac989b75d2
> --- /dev/null
> +++ b/security/kap/igroup.c

[ ... ]

> +static bool kap_file_prefix_match(const char *target, const char *candid=
ate)
> +{
> +	size_t len =3D strlen(candidate);
> +	size_t target_len =3D strlen(target);
> +	static const char deleted[] =3D " (deleted)";
> +	const size_t dlen =3D sizeof(deleted) - 1;
> +
> +	/*
> +	 * d_path renders an unlinked file as "<path> (deleted)". Match on the
> +	 * path so an exact-path deny is not slipped by unlinking the file first
> +	 * while a broader allow on its directory still matches.
> +	 */
> +	if (target_len >=3D dlen && !memcmp(target + target_len - dlen, deleted=
, dlen))
> +		target_len -=3D dlen;
> +
> +	if (len =3D=3D target_len && !strncmp(target, candidate, len))
> +		return true;
> +	if (!len || target_len <=3D len)
> +		return false;
> +	if (candidate[len - 1] =3D=3D '/')
> +		return !strncmp(target, candidate, len);
> +	return target[len] =3D=3D '/' && !strncmp(target, candidate, len);
> +}
> +
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

[Severity: High]
Can a bound task bypass KAP_HOOK_EXEC and KAP_HOOK_EXECMEM deny predicates
because kap_target_match() routes them to kap_string_match() instead of
kap_file_prefix_match()?

Only kap_file_prefix_match() strips the trailing " (deleted)" suffix added
by d_path().  Under an allow rule such as "/usr/bin/*" and an exact deny
rule such as "/usr/bin/python3", a bound task can open /usr/bin/python3,
unlink it, and call execveat(fd, "", argv, envp, AT_EMPTY_PATH): d_path()
renders "/usr/bin/python3 (deleted)" and bprm->filename is "/dev/fd/N", so
neither matches the deny rule in kap_string_match() while the allow prefix
still matches.  memfd_create() dentries are also unlinked and always carry
" (deleted)", so exact KAP_HOOK_EXECMEM patterns without a trailing "*"
never match.

Using kap_string_match() for KAP_HOOK_EXEC also breaks directory prefix
matching: a directory rule like "/usr/bin" fails to match "/usr/bin/id",
while "/usr/bin*" matches sibling directories such as
"/usr/bin_untrusted/app".  Conversely, kap_file_prefix_match() treats a
trailing "*" as a literal character, so a file rule like "/srv/work/*"
only matches a file literally named "*".

Three related path-matching bypasses exist in the exec and file paths:
kap_exec_decision_locked() checks the secondary deny predicate against the
raw unresolved bprm->filename, so chdir("/usr/bin") followed by
execve("./denied_symlink", ...) bypasses an absolute-path symlink deny;
kap_path_is_memfd() uses strstr() and diverts regular executables whose
path contains "memfd:" to KAP_HOOK_EXECMEM; and path_chroot is not hooked
even though d_path() resolves paths relative to current->fs->root.

[ ... ]

> +/* Walk one "allow" or "deny" array of a predicate block and intern its =
entries. */
> +static int kap_compile_array(struct kap_compiled_authority *compiled,
> +			     struct kap_pattern_set *set,
> +			     const char *start, const char *end,
> +			     const char *array_name)
> +{
> +	char needle[32];
> +	const char *array;
> +	const char *cursor;
> +
> +	scnprintf(needle, sizeof(needle), "\"%s\":[", array_name);
> +	array =3D strstr(start, needle);
> +	if (!array || array >=3D end)
> +		return 0;
> +	cursor =3D array + strlen(needle);
> +	while (cursor < end && *cursor && *cursor !=3D ']') {
> +		const char *value_start;
> +		const char *value_end;
> +		int rc;
> +
> +		while (cursor < end && *cursor && *cursor !=3D '"' && *cursor !=3D ']')
> +			cursor++;
> +		if (cursor >=3D end || *cursor =3D=3D ']')
> +			break;
> +		value_start =3D ++cursor;
> +		value_end =3D value_start;
> +		while (value_end < end && *value_end && *value_end !=3D '"')
> +			value_end++;
> +		if (value_end >=3D end || !*value_end)
> +			break;
> +		rc =3D kap_intern_pattern(compiled, set, value_start,
> +					value_end - value_start);
> +		if (rc)
> +			return rc;
> +		cursor =3D value_end + 1;
> +	}
> +	return 0;
> +}
> +
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
Can kap_compile_kind_array() and kap_validate_authority_payload() cross
predicate object boundaries or drop patterns when "allow" or "deny"
appears before "kind" in a predicate object?

Both functions locate predicate_start by scanning backward from
"\"kind\":" to the nearest '{' and set predicate_end to the next
occurrence of "\"kind\":" rather than the current object's closing '}'.
If a JSON serializer emits keys in sorted order ("allow", "deny", "kind")
and a pattern before "kind" contains '{' (such as "/srv/{work}"), the
backward scan stops inside the pattern string and misses the preceding
array; and because predicate_end extends into the next predicate object up
to its "kind" key, an omitted or missed array can instead match the next
predicate's array and compile it under the wrong hook kind.  Also, in
kap_compile_array(), an unclosed quote breaks out of the loop and returns
0 instead of -EINVAL, and escaped quotes (\" inside a pattern) truncate
the pattern early.

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

[ ... ]

> +struct kap_igroup *kap_find_igroup_locked(const char *name)
> +{
> +	struct kap_igroup *igroup;
> +
> +	list_for_each_entry(igroup, &kap_igroups, node) {
> +		if (!strcmp(igroup->name, name))
> +			return igroup;
> +	}
> +	return NULL;
> +}

[ ... ]

> +static void kap_append_event_locked(struct kap_igroup *igroup,
> +				    enum kap_hook_kind kind,
> +				    bool allowed,
> +				    const char *reason,
> +				    const char *target)
> +{
> +	char line[512];
> +	char escaped_target[192];
> +	u64 now =3D ktime_get_real_ns();
> +	int len;
> +	size_t out =3D 0;
> +	size_t i;
> +
> +	escaped_target[0] =3D '\0';
> +	if (target) {
> +		for (i =3D 0; target[i] && out + 2 < sizeof(escaped_target); i++) {
> +			if (target[i] =3D=3D '"' || target[i] =3D=3D '\\') {
> +				if (out + 3 >=3D sizeof(escaped_target))
> +					break;
> +				escaped_target[out++] =3D '\\';
> +				escaped_target[out++] =3D target[i];
> +			} else if (target[i] =3D=3D '\n' || target[i] =3D=3D '\r' || target[i=
] =3D=3D '\t') {
> +				escaped_target[out++] =3D ' ';
> +			} else if ((unsigned char)target[i] < 0x20) {
> +				escaped_target[out++] =3D '?';
> +			} else {
> +				escaped_target[out++] =3D target[i];
> +			}
> +		}
> +		escaped_target[out] =3D '\0';
> +	}
> +
> +	/*
> +	 * kap.events halves itself when full, so allowed traffic can evict a
> +	 * denial. Mirror denials to the kernel log, before the ring write so
> +	 * the early returns below cannot drop the record.
> +	 */
> +	if (!allowed)
> +		pr_warn_ratelimited("deny igroup=3D%s op=3D%s target=3D%s reason=3D%s =
epoch=3D%llu pid=3D%d\n",
> +				    igroup->name, kap_hook_name(kind),
> +				    escaped_target, reason, igroup->epoch,
> +				    task_pid_nr(current));
> +
> +	len =3D scnprintf(line, sizeof(line),
> +			"{\"ts_ns\":%llu,\"igroup\":\"%s\",\"decision\":\"%s\",\"operation\":=
\"%s\",\"target\":\"%s\",\"reason\":\"%s\",\"epoch\":%llu,\"root\":\"%s\",\=
"pid\":%d}\n",
> +			now, igroup->name, allowed ? "allow" : "deny",
> +			kap_hook_name(kind), escaped_target, reason, igroup->epoch,
> +			igroup->lineage_root, task_pid_nr(current));
> +	if (len <=3D 0)
> +		return;
> +	if (len >=3D KAP_MAX_EVENTS_BYTES) {
> +		igroup->events_len =3D 0;
> +		return;
> +	}
> +	if (igroup->events_len + len >=3D KAP_MAX_EVENTS_BYTES) {
> +		size_t keep =3D KAP_MAX_EVENTS_BYTES / 2;
> +
> +		memmove(igroup->events, igroup->events + igroup->events_len - keep, ke=
ep);
> +		igroup->events_len =3D keep;
> +	}
> +	memcpy(igroup->events + igroup->events_len, line, len);
> +	igroup->events_len +=3D len;
> +}

[Severity: Medium]
Does running kap_find_igroup_locked() and kap_append_event_locked() under
the global kap_lock spinlock on every decision serialize all bound tasks
across all CPUs?

Every mediated syscall for any bound task acquires kap_lock, walks the
global kap_igroups list comparing names with strcmp(), formats an event
line with scnprintf(), calls pr_warn_ratelimited() on denials, and
executes a 32 KiB memmove() whenever igroup->events fills.  This holds a
single global spinlock across string formatting, printk, and 32 KiB memory
copies even for hooks like kap_ptrace_traceme() that enter KAP under
write_lock_irq(&tasklist_lock).

[Severity: Low]
Does evicting igroup->events at a fixed byte offset (keep =3D
KAP_MAX_EVENTS_BYTES / 2) in kap_append_event_locked() slice the oldest
retained JSON line in half?

Because igroup->events + igroup->events_len - keep is not aligned to a
newline boundary, the start of kap.events is left with a partial JSON line
after each wrap.  Also, line[512] is 2 bytes short of the maximum
formatted event length (513 bytes plus NUL when name, escaped_target,
reason, lineage_root, and u64 fields are at their maximum lengths), which
can truncate the closing "}\n", and kap_refuse_unbound() logs target to
dmesg without escaping newlines or control characters.

[ ... ]

> +int kap_check_current_emit(enum kap_hook_kind kind, const void *object,
> +			   const char *deny_reason, const char *allow_reason)
> +{
> +	char *target;
> +	struct kap_igroup *igroup;
> +	const char *why =3D NULL;
> +	int rc =3D 0;
> +
> +	if (kap_skip_current(kind))
> +		return 0;
> +
> +	target =3D kmalloc(PATH_MAX, GFP_KERNEL);
> +	if (!target)
> +		return -ENOMEM;
> +	if (kap_object_target(kind, object, target, PATH_MAX)) {
> +		kfree(target);
> +		return -EACCES;
> +	}
> +
> +	spin_lock(&kap_lock);
> +	igroup =3D kap_find_current_igroup_locked();
> +	if (!igroup) {
> +		if (kap_unbound_refused(kind))
> +			rc =3D kap_refuse_unbound(kind, target);
> +		goto out;
> +	}
> +	rc =3D kap_decide_locked(igroup, kind, object, target, &why);
> +	kap_append_event_locked(igroup, kind, rc =3D=3D 0,
> +				rc ? (why ? why : deny_reason) : allow_reason, target);
> +out:
> +	spin_unlock(&kap_lock);
> +	kfree(target);
> +	return rc;
> +}
> +
> +int kap_check_current_target_emit(enum kap_hook_kind kind, const char *t=
arget,
> +				  const char *deny_reason, const char *allow_reason)
> +{
> +	struct kap_igroup *igroup;
> +	const char *why =3D NULL;
> +	int rc =3D 0;
> +
> +	if (kap_skip_current(kind))
> +		return 0;
> +
> +	spin_lock(&kap_lock);
> +	igroup =3D kap_find_current_igroup_locked();
> +	if (!igroup) {
> +		if (kap_unbound_refused(kind))
> +			rc =3D kap_refuse_unbound(kind, target);
> +		goto out;
> +	}
> +	rc =3D kap_authority_decision_locked(igroup, kind, target, &why);
> +	kap_append_event_locked(igroup, kind, rc =3D=3D 0,
> +				rc ? (why ? why : deny_reason) : allow_reason, target);
> +out:
> +	spin_unlock(&kap_lock);
> +	return rc;
> +}

[Severity: Medium]
Do kap_check_current_target_why(), kap_check_current_emit(), and
kap_check_current_target_emit() fail open when an active bound task's
igroup is not found in kap_igroups?

In all three functions rc is initialized to 0, so when
kap_find_current_igroup_locked() returns NULL for a task with
state->active =3D=3D true, the !igroup branch only refuses when
kap_unbound_refused(kind) is true and otherwise returns 0.  In addition,
when kap_object_target() fails in kap_check_current_emit() (for example
with -ENOMEM or -ENAMETOOLONG from d_path()), returning -EACCES before
taking kap_lock masks -ENOMEM and drops the denial record from both
igroup->events and the kernel log.

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
> +
> +	if (kap_pid_in_igroup_locked(igroup, pid))
> +		return 0;
> +	(*entry)->pid =3D pid;
> +	list_add_tail(&(*entry)->node, &igroup->pids);
> +	*entry =3D NULL;
> +	return 0;
> +}

[Severity: High]
What happens if kap_bind_pid_locked() is given the PID of a kernel thread?

kap_bind_pid_locked() does not check task->flags & PF_KTHREAD.  Kernel
threads have current->fs =3D=3D NULL, so if a kthread (or kthreadd) is boun=
d,
any subsequent KAP hook that calls d_path() dereferences NULL in
get_fs_root_rcu(current->fs, &root).

Binding live threads here also has two concurrency defects:
for_each_thread() misses any in-flight CLONE_THREAD child that has already
run kap_task_alloc() before copy_process() links it onto
signal->thread_head, and setting state->active =3D true before writing
state->epoch and state->igroup_name lets unlocked readers such as
kap_ptrace_target() observe an active task with an uninitialized or half-
written igroup_name.

[Severity: Medium]
Does igroup->pids leak struct kap_bound_pid entries across the lifetime of
the igroup?

kap_bind_pid_locked() appends *entry to igroup->pids, but neither
kap_task_free() nor any rebind path ever removes or frees entries from
igroup->pids when bound processes exit.

> diff --git a/security/kap/kap_lsm.c b/security/kap/kap_lsm.c
> new file mode 100644
> index 0000000000000..48d048086b74c
> --- /dev/null
> +++ b/security/kap/kap_lsm.c
> @@ -0,0 +1,902 @@

[ ... ]

> +struct lsm_blob_sizes kap_blob_sizes __ro_after_init =3D {
> +	.lbs_task =3D sizeof(struct kap_task_state),
> +};

[Severity: Low]
Should kap_blob_sizes be marked static?  It is only referenced in
security/kap/kap_lsm.c and has no declaration in security/kap/kap.h, which
causes a -Wmissing-declarations warning under W=3D1 or C=3D1 builds.

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

[Severity: Medium]
Does kap_task_alloc() acquire the global kap_lock spinlock on every fork
and clone system-wide, even when kap_ready is false or current is unbound?

Unlike other hooks that return early via kap_skip_current() or
kap_lsm_current_active(), kap_task_alloc() unconditionally takes kap_lock
on every task creation.  Also, passing u64 clone_flags to
kap_check_namespace_flags(unsigned long flags, ...) truncates the upper 32
bits of clone_flags on 32-bit architectures.

[Severity: High]
Can a child task that is mid-fork in copy_process() escape binding when
kap_bind_pid_locked() runs concurrently?

CPU0 (target thread in fork/clone)   CPU1 (kap_bind_pid_locked)
copy_process()
  security_task_alloc()
    kap_task_alloc()
      spin_lock(&kap_lock)
      /* old->active is false */
      spin_unlock(&kap_lock)
                                     spin_lock(&kap_lock)
                                     for_each_thread(task, t)
                                       state->active =3D true
                                     spin_unlock(&kap_lock)
  ...
  write_lock_irq(&tasklist_lock)
  list_add_tail_rcu(&p->thread_node,
                    &p->signal->thread_head)  <-- child runs unbound

security_task_alloc() runs in copy_process() long before tasklist_lock and
sighand->siglock are taken to link the new task onto signal->thread_head
and attach its PID.  Any thread or child process in that window has
already completed kap_task_alloc() with old->active =3D=3D false, is not yet
visible to for_each_thread() in kap_bind_pid_locked(), and starts
execution unbound (or with a stale epoch) after kap_bind_pid_locked()
returns success.

> +static void kap_task_free(struct task_struct *task)
> +{
> +	struct kap_task_state *state =3D kap_task_state(task);
> +
> +	if (state)
> +		memset(state, 0, sizeof(*state));
> +}

[Severity: Medium]
Should kap_task_free() also remove and free the exiting process's struct
kap_bound_pid entry from igroup->pids?

Because kap_task_free() only zeroes the task blob, struct kap_bound_pid
nodes allocated by kap_bind_pid_locked() remain on igroup->pids after
bound tasks exit, leaking memory, leaving dead or recycled PIDs in
kap.procs, and causing kap_pid_in_igroup_locked() to skip recording new
binds when a PID number is reused.

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

[ ... ]

> +static void kap_normalize_procfs_self(char *target)
> +{
> +	static const char self[] =3D "/proc/self";
> +	const size_t self_len =3D sizeof(self) - 1;
> +	char prefix[32];
> +	size_t prefix_len;
> +	size_t tail_len;
> +
> +	/*
> +	 * /proc/self resolves to the thread-group leader as numbered in the
> +	 * procfs instance's PID namespace, so use the tgid in the current PID
> +	 * namespace rather than this thread's global PID.
> +	 */
> +	prefix_len =3D scnprintf(prefix, sizeof(prefix), "/proc/%d", task_tgid_=
vnr(current));
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

[Severity: Medium]
Can a bound task bypass "/proc/self/..." deny rules by accessing
/proc/thread-self/<entry>, /proc/self/task/<tid>/<entry>, or a non-leader
thread's /proc/<tid>/<entry>?

kap_normalize_procfs_self() only rewrites the leading "/proc/<tgid>"
prefix to "/proc/self".  Opening /proc/thread-self/mem resolves via
d_path() to "/proc/<tgid>/task/<tid>/mem", which is rewritten to
"/proc/self/task/<tid>/mem" and misses a deny rule on "/proc/self/mem"
while still matching an allow rule on "/proc/self".  Likewise, a non-
leader thread opening "/proc/<tid>/mem" does not match task_tgid_vnr() at
all and is left unnormalized.

> +static bool kap_path_is_memfd(const char *path)
> +{
> +	return strstr(path, "/memfd:") || strstr(path, "memfd:");
> +}

[Severity: High]
Can a bound task with KAP_HOOK_EXECMEM permission bypass KAP_HOOK_EXEC
rules by executing a regular file whose path contains the substring
"memfd:"?

kap_path_is_memfd() uses strstr(path, "memfd:"), which matches "memfd:"
anywhere in a regular filesystem path (such as "/tmp/memfd:app").  In
kap_bprm_check_security(), any path matching kap_path_is_memfd() is
checked against KAP_HOOK_EXECMEM and returns immediately, skipping
KAP_HOOK_EXEC allow/deny rules and the bprm->filename check in
kap_exec_decision_locked().

> +static bool kap_path_is_anonymous_channel(const char *path)
> +{
> +	return !strncmp(path, "pipe:", strlen("pipe:")) ||
> +	       !strncmp(path, "socket:", strlen("socket:")) ||
> +	       !strncmp(path, "anon_inode:", strlen("anon_inode:"));
> +}
> +
> +static int kap_file_open(struct file *file)
> +{
> +	char *target;
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +	target =3D kap_lsm_file_path_alloc(file);
> +	if (!IS_ERR(target)) {
> +		if (kap_path_is_procfs(target)) {
> +			int rc;
> +
> +			kap_normalize_procfs_self(target);
> +			rc =3D kap_check_current_target_emit(KAP_HOOK_PROCFS, target,
> +							   "procfs_predicate_denied",
> +							   "procfs_allowed");
> +			kfree(target);
> +			return rc;
> +		}
> +		kfree(target);
> +	}
> +	return kap_check_current_emit(KAP_HOOK_FILE, file,
> +				      "file_predicate_denied", "file_allowed");
> +}

[Severity: Medium]
Why do kap_file_open() and kap_bprm_check_security() discard the resolved
target buffer for non-procfs and non-memfd files and then call
kap_check_current_emit() to allocate and resolve the same file path a
second time?

For every normal file open or exec, kap_lsm_file_path_alloc() allocates a
4 KiB PATH_MAX buffer and runs d_path(), frees it, and then
kap_check_current_emit() -> kap_object_target() -> kap_file_target()
allocates two more 4 KiB buffers and runs d_path() again on the same
struct file (contradicting the commit message claim that a decision
allocates nothing).

> +static int kap_file_permission(struct file *file, int mask)
> +{
> +	const char *why =3D NULL;
> +	char *target;
> +	int rc;
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +	if (!(mask & (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)))
> +		return 0;
> +	target =3D kap_lsm_file_path_alloc(file);
> +	if (IS_ERR(target))
> +		return kap_check_current_emit(KAP_HOOK_FILE, file,
> +					      "file_use_predicate_denied",
> +					      "file_use_allowed");
> +	if (kap_path_is_anonymous_channel(target)) {
> +		kfree(target);
> +		return 0;
> +	}
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

[Severity: High]
Does kap_file_permission() allocate a 4 KiB PATH_MAX buffer and run
d_path() on every read() and write() syscall for bound tasks, even on
pipes, sockets, and anon_inodes?

rw_verify_area() invokes security_file_permission() on every read and
write.  kap_file_permission() unconditionally calls
kap_lsm_file_path_alloc(file) (kmalloc(PATH_MAX, GFP_KERNEL), d_path(),
and memmove()) before checking if the file is an anonymous channel, and
for regular or procfs files it also acquires the global kap_lock spinlock
and re-runs igroup lookup and pattern matching on every I/O call.

[Severity: Low]
Can dropping kap_lock between kap_check_current_target_why() and
kap_emit_current_event_target() in kap_file_permission() log a denial
against mismatched igroup state?

kap_check_current_target_why() releases kap_lock before returning, and
kap_emit_current_event_target() reacquires kap_lock and looks up the
igroup again, so a concurrent policy install, epoch bump, or rebind in
between causes the denial event to record the new epoch or lineage_root.

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
> +		/* Cannot tell what it is, so let a revoked or expired igroup
> +		 * still deny rather than allowing the mapping outright.
> +		 */
> +		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "unresolved",
> +						     "execmem_predicate_denied",
> +						     "execmem_allowed");
> +	if (kap_path_is_memfd(target))
> +		rc =3D kap_check_current_target_emit(KAP_HOOK_EXECMEM, target,
> +						   "execmem_predicate_denied",
> +						   "execmem_allowed");
> +	kfree(target);
> +	return rc;
> +}
> +
> +static int kap_file_mprotect(struct vm_area_struct *vma,
> +			     unsigned long reqprot, unsigned long prot)
> +{
> +	char *target;
> +	struct file *file;
> +	int rc =3D 0;
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +	if (!(reqprot & PROT_EXEC) && !(prot & PROT_EXEC))
> +		return 0;
> +	file =3D vma ? vma->vm_file : NULL;
> +	if (!file)
> +		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "anonymous",
> +						     "execmem_predicate_denied",
> +						     "execmem_allowed");
> +	target =3D kap_lsm_file_path_alloc(file);
> +	if (IS_ERR(target))
> +		/* Cannot tell what it is, so let a revoked or expired igroup
> +		 * still deny rather than allowing the mapping outright.
> +		 */
> +		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "unresolved",
> +						     "execmem_predicate_denied",
> +						     "execmem_allowed");
> +	if (kap_path_is_memfd(target))
> +		rc =3D kap_check_current_target_emit(KAP_HOOK_EXECMEM, target,
> +						   "execmem_predicate_denied",
> +						   "execmem_allowed");
> +	kfree(target);
> +	return rc;
> +}

[Severity: High]
Why do kap_mmap_file() and kap_file_mprotect() return 0 without any
authority check for all non-memfd file-backed PROT_EXEC mappings, and pass
"unresolved" when kap_lsm_file_path_alloc() fails?

When file is a regular (non-memfd) file, kap_path_is_memfd(target) is
false and both hooks return rc =3D 0 without calling into KAP.  A bound task
can therefore write machine code to any writable file and map it with
PROT_EXEC without being checked against KAP_HOOK_EXECMEM or KAP_HOOK_EXEC,
and a task whose authority is revoked, expired, or epoch-stale can still
map open files executable.  Furthermore, when kap_lsm_file_path_alloc()
fails, passing the non-empty string "unresolved" bypasses the
!target || !*target check in kap_authority_decision_locked() and matches
any wildcard allow rule such as "*".

> +#ifdef CONFIG_SECURITY_NETWORK
> +static int kap_socket_connect(struct socket *sock, struct sockaddr *addr=
ess, int addrlen)
> +{
> +	/*
> +	 * AF_UNSPEC dissolves an association rather than making one; resolvers
> +	 * use it between candidate addresses. AF_UNIX is checked as ipc by the
> +	 * unix hooks.
> +	 */
> +	if (addrlen < offsetofend(struct sockaddr, sa_family) ||
> +	    address->sa_family =3D=3D AF_UNSPEC || address->sa_family =3D=3D AF=
_UNIX)
> +		return 0;
> +	/*
> +	 * The target render reads the family's address and port. A short
> +	 * addrlen would read uninitialised stack into kap.events, so leave a
> +	 * malformed address for the protocol layer to reject.
> +	 */
> +	if (address->sa_family =3D=3D AF_INET && addrlen < sizeof(struct sockad=
dr_in))
> +		return 0;
> +	if (address->sa_family =3D=3D AF_INET6 && addrlen < sizeof(struct socka=
ddr_in6))
> +		return 0;
> +	return kap_check_current_emit(KAP_HOOK_SOCKET_CONNECT, address,
> +				      "net_predicate_denied", "net_allowed");
> +}
> +#endif

[Severity: High]
Can a bound task bypass kap_socket_connect() on AF_INET6 sockets by
passing addrlen =3D SIN6_LEN_RFC2133 (24 bytes)?

kap_socket_connect() returns 0 when addrlen < sizeof(struct sockaddr_in6)
(28 bytes), assuming the protocol layer will reject the call.  However,
tcp_v6_connect() and ip6_datagram_connect() accept any addrlen >=3D
SIN6_LEN_RFC2133 (24 bytes, omitting only sin6_scope_id), and
kap_object_target() only reads sin6_addr and sin6_port within those first
24 bytes.  Passing addrlen =3D 24..27 lets any bound task establish IPv6
(and IPv4-mapped IPv6) connections without KAP mediation.

[ ... ]

> +static int kap_sb_mount(const char *dev_name, const struct path *path,
> +			const char *type, unsigned long flags, void *data)
> +{
> +	char path_target[KAP_LSM_TARGET_LEN];
> +	char target[KAP_LSM_TARGET_LEN];
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +
> +	if (kap_lsm_path_target(path, path_target, sizeof(path_target)))
> +		strscpy(path_target, "unknown", sizeof(path_target));
> +	scnprintf(target, sizeof(target), "mount:mount:%s:%s",
> +		  type ?: "unknown", path_target);
> +	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
> +				       "mount_predicate_denied", "mount_allowed");
> +}
> +
> +static int kap_sb_umount(struct vfsmount *mnt, int flags)
> +{
> +	struct path path =3D { .mnt =3D mnt, .dentry =3D mnt ? mnt->mnt_root : =
NULL };
> +	char path_target[KAP_LSM_TARGET_LEN];
> +	char target[KAP_LSM_TARGET_LEN];
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +
> +	if (!mnt || kap_lsm_path_target(&path, path_target, sizeof(path_target)=
))
> +		strscpy(path_target, "unknown", sizeof(path_target));
> +	scnprintf(target, sizeof(target), "mount:umount:%s", path_target);
> +	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
> +				       "mount_predicate_denied", "mount_allowed");
> +}
> +
> +static int kap_sb_pivotroot(const struct path *old_path, const struct pa=
th *new_path)
> +{
> +	char old_target[KAP_LSM_TARGET_LEN];
> +	char new_target[KAP_LSM_TARGET_LEN];
> +	char target[KAP_LSM_TARGET_LEN];
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +
> +	if (kap_lsm_path_target(old_path, old_target, sizeof(old_target)))
> +		strscpy(old_target, "unknown", sizeof(old_target));
> +	if (kap_lsm_path_target(new_path, new_target, sizeof(new_target)))
> +		strscpy(new_target, "unknown", sizeof(new_target));
> +	scnprintf(target, sizeof(target), "mount:pivotroot:%s:%s",
> +		  old_target, new_target);
> +	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
> +				       "mount_predicate_denied", "mount_allowed");
> +}
> +
> +static int kap_move_mount(const struct path *from_path, const struct pat=
h *to_path)
> +{
> +	char from_target[KAP_LSM_TARGET_LEN];
> +	char to_target[KAP_LSM_TARGET_LEN];
> +	char target[KAP_LSM_TARGET_LEN];
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +
> +	if (kap_lsm_path_target(from_path, from_target, sizeof(from_target)))
> +		strscpy(from_target, "unknown", sizeof(from_target));
> +	if (kap_lsm_path_target(to_path, to_target, sizeof(to_target)))
> +		strscpy(to_target, "unknown", sizeof(to_target));
> +	scnprintf(target, sizeof(target), "mount:move:%s:%s",
> +		  from_target, to_target);
> +	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
> +				       "mount_predicate_denied", "mount_allowed");
> +}

[Severity: Medium]
Can long or unresolvable mount paths bypass deny rules in kap_sb_mount(),
kap_sb_umount(), kap_sb_pivotroot(), and kap_move_mount()?

kap_lsm_path_target() ignores the -E2BIG truncation return from strscpy()
when copying a PATH_MAX path into a 256-byte (KAP_LSM_TARGET_LEN) buffer,
and all four mount hooks format one or two 256-byte paths plus a
"mount:<op>:" prefix into a single 256-byte target buffer, cutting off
trailing path components before predicate matching.  When
kap_lsm_path_target() fails (for example with -ENAMETOOLONG or -ENOMEM),
substituting "unknown" instead of failing closed allows the operation to
match a prefix allow rule such as "mount:*".

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
> +
> +static int kap_ptrace_access_check(struct task_struct *child, unsigned i=
nt mode)
> +{
> +	char target[128];
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +
> +	kap_ptrace_target(child, target, sizeof(target));
> +	return kap_check_current_target_emit(KAP_HOOK_PTRACE, target,
> +					     "ptrace_predicate_denied", "ptrace_allowed");
> +}
> +
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

[Severity: Medium]
Can kap_ptrace_target() race with kap_bind_pid_locked() and read a torn or
partially written kap_task_state?

kap_bind_pid_locked() mutates state->active, state->epoch, and
state->igroup_name in place on live tasks under kap_lock (setting
state->active =3D true first), whereas kap_ptrace_target() reads those
fields on both current and child without holding kap_lock.  A concurrent
bind or rebind can expose active =3D=3D true while igroup_name is still emp=
ty
or being overwritten by strscpy(), or pair the new epoch with the old
igroup_name.

[Severity: High]
Does kap_ptrace_traceme() check the tracee's authority instead of the
tracer's?

In ptrace_traceme(), parent is the tracer and current is the child
requesting to be traced.  kap_ptrace_traceme() checks
kap_lsm_current_active() and kap_check_current_target_emit() on current,
so a parent bound to an igroup that denies ptrace (or whose authority is
revoked) can trace an unbound child via PTRACE_TRACEME, while an
unconfined parent is denied tracing a bound child whose igroup denies
ptrace.

[ ... ]

> +/* truncate(2) changes the contents of an existing file without opening =
it, so
> + * none of the open or entry hooks see it. Without this a denied file ca=
n still
> + * be emptied.
> + */
> +static int kap_path_truncate(const struct path *path)
> +{
> +	char *target;
> +	int rc;
> +
> +	if (!kap_lsm_current_active())
> +		return 0;
> +	if (!path || !path->mnt || !path->dentry)
> +		return kap_lsm_refuse_unresolved("file_path_unresolved");
> +	target =3D kmalloc(PATH_MAX, GFP_KERNEL);
> +	if (!target)
> +		return -ENOMEM;
> +	rc =3D kap_lsm_path_target(path, target, PATH_MAX);
> +	if (rc) {
> +		kfree(target);
> +		return kap_lsm_refuse_unresolved("file_path_unresolved");
> +	}
> +	rc =3D kap_check_current_target_emit(KAP_HOOK_FILE, target,
> +					   "file_predicate_denied", "file_allowed");
> +	kfree(target);
> +	return rc;
> +}
> +
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
Can a bound task truncate an already-open file via ftruncate(2) after its
authority has been narrowed or revoked because file_truncate is not
hooked?

do_ftruncate() calls security_file_truncate(file) and does not call
security_path_truncate() or security_file_permission(), so omitting a
file_truncate hook leaves ftruncate(2) unmediated on open writable file
descriptors.  Also, kap_path_truncate() always checks KAP_HOOK_FILE
without checking kap_path_is_procfs(target) or normalizing /proc/self, and
when kap_lsm_file_path_alloc() returns an ERR_PTR in kap_file_open() or
kap_bprm_check_security(), both functions fall through to KAP_HOOK_FILE or
KAP_HOOK_EXEC instead of failing closed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123114308.8103=
-1-harisudhan@armoriq.io?part=3D3

