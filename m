Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347A5606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JSUy/MnX
Received: by kanga.kvack.org (Postfix)
	id B76636B0985; Thu, 22 Oct 2026 11:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E366B0987; Thu, 22 Oct 2026 11:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C206B0988; Thu, 22 Oct 2026 11:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3C56B0985
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:44:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF82EA0132
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:29 +0000 (UTC)
X-FDA: 85350684258.01.BBEB36B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F23F40003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JSUy/MnX";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683868;
	b=ZFV7knEDzBWL9p8GeR8NceFlvKqq2pVge4gl/30owWCAZdkCExRmdYKDIaWiWJD8jgz6AN
	+cMk1bOtQbGS/z9S7nRIe1TjYYWrTjJcGGZkDIeEH4o39UTZTB4bo0iv2ZFQuXxwXPRQOl
	fnuucT8sM00pt1HIBwShShmEEEFXORU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JSUy/MnX";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683868;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cY1hvaWh6Vk6/nIEt5/9rTdze650y5g5R3I1CecXjyo=;
	b=o2VEzF/P+7nbMdwM9OvNAWBXVka1+ZtEHMY4xm+d67kbnJlH66HB2Dxr3ryCNTYPXAWdP0
	61mG8hc0QyrNkKoXOJgYqmocuwObAfKb14PyYKA6j2pflwv9YJJquLgxHhwWtGz9WGS3L3
	3IhsFebybct89bE0Z+Vhd7XfRi48wgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C293E63E44;
	Thu, 22 Oct 2026 15:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71EC1F031E0;
	Thu, 22 Oct 2026 15:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683867;
	bh=cY1hvaWh6Vk6/nIEt5/9rTdze650y5g5R3I1CecXjyo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JSUy/MnXegcnSG+fWAukS384bsK/wMQrMy5lkpbYQrgfGOExC0iCbDW599V2t85vN
	 vlzi8IJtSWee8I3GcVM0qy3olrYcraklK8mP7Sanqsn3XZEjm+axsN9qDtq2fh6+/K
	 lJmjlhjwSdYpMrRg2hpHK5khWNoZID5t9A1/y33+eGFLYna6wHU5alGgecC5p0k2x+
	 WWO10DiH3C4BP+0kvN1jWvKiP4HYj5MrHGdFfkS4YYoHADaTxvyDgUdHdomvvVMoYh
	 +j/x+peLVgtFX44NhkG+2mhxRsKxGSYKYAOEmt4m7qrDAyHTdQwnfsYaKbkK5YNFWU
	 YWux0CxHmkuJw==
Message-ID: <sashiko-outbox-181724@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 8/8] selftests/dmabuf-heaps: Add dma-buf memcg
 accounting tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Albert Esteve" <aesteve@redhat.com>, "Tejun Heo" <tj@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Gaignard" <benjamin.gaignard@collabora.com>, "Brian
 Starkey" <Brian.Starkey@arm.com>, "John Stultz" <jstultz@google.com>, "T.J.
 Mercier" <tjmercier@google.com>, "Christian Brauner" <brauner@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Stephen Smalley" <stephen.smalley.work@gmail.com>, "Shuah
 Khan" <shuah@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, mripard@kernel.org, echanude@redhat.com, media-ci@linuxtv.org
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-8-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-8-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:44:25 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F23F40003
X-Stat-Signature: y6isrfics49ducoxrc9trxaa5hjdmgby
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792683868-836797
X-HE-Meta: U2FsdGVkX1/gPFahtM3qNTQpHXoJ464k3hljLSLVG78+Xr592AoBQXEmpUFQWQPGR+TT7K+cwUoLsChfM/pDlULV1HAgnnJ4okjP86bAa/iyQcEvR1i+VY3b+ohaPplO7w7J6u85BLXzKEtvKlXa2/qxxF35Qmyh/AKzhvpBmOhb+BC4ntWZEFz1tdPRP6D65n+cNa8JlaRAuB4Kl0HtRh0aB49uNfOQ6748NWNUB2jIxCVUUaRmO8JJmsYr3E9PfwHWTwTr4g7B1l57jjtAzmf/PMZPGuq7rshint2VYjVBIyn+t+OkXPEwvXDFiLhEi5OXY1rFZ2Rir4ibDGaZlMQJECF3aPs0nrZgcMW1xdUGqjgulHLy+qi15HGtB5kwdE1cNBwEIodJAab2wD4vmxiynygGayiedwaQDKATewLaE9E9ziS83+avDQrliWMPRTJ42sriNufLl8nYBsr0xi+VGt8rv2rhyRkftd7IMfQi0F/1nD9U5gV+5zDbOWn0DiS58w5XP9y4Gr3ZnPeuq++zU53Vixt360TQCMNqxeiluzZdNK+bZhg2JF8QGuEsrDbrA6rxf+txbDG/PWzGgLf28sQrvz5VDiHMkUL/dTt1BPoaSIezq87DF7a2pEDTbMho4awBTRBhXInkMhI8ZIkfFv0nTn4/+5V8hdynVprvSWPw0zzUwEyxB04uulNxOd3TP2fiD8A6JQGS+UaaFqo1QTI1nFODHkQKY5SF2GPPNAxf+JqdK6WJMzMihHOwXAvHX0VRvJgMm7MeNF8oeTrKnEmHg0YkGBvOogl30OTwaF7eTyhMR8Aac20pg9qlAtmHJLQo8nOi8JWbM20/6q7ZOuXyV3JwafpIXMi0Uo+9cCrmpXkTSCq/dNQszHjgjoERciQW8PQc3DDEEiFnxf85Sphh+rAb4LYMex0dTGFwP00GbVi4j/bZ7yuVTJ4sFIO6D0vcBZjMpcXfTVW
 d+R1FglV
 ymKtNFVuP7Jl9YaSto3qr2yhu6WKfT8+5a5ShTkNUOOP4aBMmFnpeLrBDgvC3oZP0mddu5uPjjpK6Vcrf+o9mIm0tLVWWB5fBBjjZ5kijodW33PEGqKY/eepb8ZND9B2N7O1Lp2RUKgUZ7yrKKR5XjrwYme1A8dOMCrdkskNnTwg15l5iVVuLcZDkC7AUrd7zo6lXzvdmKTRoAwnTfLZpbCXaAnxKS/PkdFA3TwCmkBqZJMIp6pT1hVR6YUWemxCgTHK3HbgUFyNK6onBknfo6xVbjaqRtQuB3DO+AAID4FpXsxQJngdPwjhG5dIXJt/fwR1OmfAOaNuYguoUtBJfVP7pgA7+mWsTHM3lb0aUjosNWP2SVM1BoUh35xBVSfglfEatemXMlIQZNK5I1qyeTMrCfeT0ch+aRxIRcmATPDmVcENMM9+5coPavPZ/YvS9flzkHVY/EPMTtVrxRirYbDM4hoProsO+HUKrCSydyW8V8ojd3OoN4ASlqJCvvPnEqFcaZaM030fL0bAHtvIS9o1D3vtN2wrHBhXbDwQ1Dwm/OPnOcVH5K1c9ABRVfBtGxEArv3Eq5WGWUaVdIy1cR1pqjI1zgq4iQs/BOJJSslmDB6Zfo0iGGqIAveCHBpDXBzppCfiUrRI8pxsU1mq/C3aEG8hfAG4NLltH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] selftests/dmabuf-heaps: missing skip check in test_xfer_charge_c=
groupfd_self()
- [Medium] selftests/dmabuf-heaps: missing cgroup2 and memcg checks in open=
_self_cgroupfd()
- [Medium] selftests/dmabuf-heaps: vmtest.sh executes runner from unshared =
/tmp in guest
- [Medium] selftests/dmabuf-heaps: vmtest.sh runs vng/make before check_dep=
s()
--

commit 0809a03b2fbc81e6f2b637ef5c0744b2c8ae99f1
Author: Albert Esteve <aesteve@redhat.com>

selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

This commit adds selftests for dma-buf memcg accounting via charge_fd in
tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c and
tools/testing/selftests/cgroup/test_memcontrol.c, along with a virtme-ng
runner script in tools/testing/selftests/dmabuf-heaps/vmtest.sh.

> diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/t=
esting/selftests/dmabuf-heaps/dmabuf-heap.c
> index 1d49df6719198..b1c58e5883f64 100644
> --- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
> +++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c

[ ... ]

> @@ -496,6 +505,213 @@ static void test_alloc_no_fd_leak_on_efault(char *h=
eap_name)

[ ... ]

> +static int open_self_cgroupfd(void)
> +{
> +	char cgroup_path[PATH_MAX];
> +	char buf[PATH_MAX];
> +	FILE *f;
> +
> +	f =3D fopen("/proc/self/cgroup", "r");
> +	if (!f)
> +		return -1;
> +
> +	cgroup_path[0] =3D '\0';
> +	while (fgets(buf, sizeof(buf), f)) {
> +		char *p =3D buf;
> +
> +		if (strncmp(p, "0::", 3) =3D=3D 0) {
> +			p +=3D 3;
> +			p[strcspn(p, "\n")] =3D '\0';
> +			snprintf(cgroup_path, sizeof(cgroup_path),
> +				 "/sys/fs/cgroup%s", p);
> +			break;
> +		}
> +	}
> +	fclose(f);
> +
> +	if (!cgroup_path[0])
> +		return -1;
> +
> +	return open(cgroup_path, O_RDONLY | O_DIRECTORY);
> +}
> +
> +/*
> + * Test: allocate charging the calling process's own cgroup via a cgroup=
fd.
> + */
> +static void test_alloc_cgroupfd_self(char *heap_name)
> +{
> +	int heap_fd =3D -1, cgroup_fd =3D -1, dmabuf_fd =3D -1, ret;
> +
> +	heap_fd =3D dmabuf_heap_open(heap_name);
> +
> +	if (!pidfd_alloc_supported(heap_fd)) {
> +		ksft_test_result_skip("charge_fd not supported by this kernel\n");
> +		goto out;
> +	}
> +
> +	cgroup_fd =3D open_self_cgroupfd();
> +	if (cgroup_fd < 0) {
> +		ksft_test_result_skip("cannot open self cgroupfd\n");
> +		goto out;
> +	}
> +
> +	ret =3D dmabuf_heap_alloc_pidfd(heap_fd, ONE_MEG, 0, cgroup_fd, &dmabuf=
_fd);
> +	ksft_test_result(!ret, "Allocation with cgroupfd %d\n", ret);
> +	if (dmabuf_fd >=3D 0)
> +		close(dmabuf_fd);
> +	close(cgroup_fd);
> +out:
> +	close(heap_fd);
> +}

[Severity: Medium]
Can open_self_cgroupfd() return a directory fd that causes
test_alloc_cgroupfd_self() and test_xfer_charge_cgroupfd_self() to report a
hard failure instead of skipping when cgroup v2 or the memory controller is
not active on that path?

In open_self_cgroupfd(), the 0:: entry from /proc/self/cgroup is appended t=
o a
hardcoded /sys/fs/cgroup prefix without checking that /sys/fs/cgroup is a
cgroup2 mount. On systems using a hybrid hierarchy where /sys/fs/cgroup is a
tmpfs and unified cgroup v2 is mounted at /sys/fs/cgroup/unified, opening
/sys/fs/cgroup/ succeeds on tmpfs, and the kernel's cgroup_get_from_fd() th=
en
rejects charge_fd with EBADF.

Furthermore, unlike the pidfd path in dma_heap_ioctl_allocate() and
dma_buf_xfer_charge() which resolves the effective memcg via
get_mem_cgroup_from_mm(task->mm), the cgroupfd path calls
cgroup_css(cgrp, &memory_cgrp_subsys) directly on the target cgroup and
returns ENOENT if the memory controller is not enabled for that specific
cgroup (for example, when the test runs in a non-root cgroup whose parent h=
as
not enabled +memory in cgroup.subtree_control).

Should open_self_cgroupfd() verify that the resolved directory is on a
cgroup2 filesystem with the memory controller enabled, or should the callers
skip when the ioctl fails with ENOENT or EBADF?

> +
> +/*
> + * Test: transfer a dma-buf's charge to self cgroup via DMA_BUF_IOCTL_XF=
ER_CHARGE.
> + */
> +static void test_xfer_charge_cgroupfd_self(char *heap_name)
> +{
> +	int heap_fd =3D -1, cgroup_fd =3D -1, dmabuf_fd =3D -1, ret;
> +	struct dma_buf_transfer_charge xfer =3D { 0 };
> +
> +	heap_fd =3D dmabuf_heap_open(heap_name);
> +
> +	ret =3D dmabuf_heap_alloc(heap_fd, ONE_MEG, 0, &dmabuf_fd);
> +	if (ret) {
> +		ksft_test_result_fail("Allocation failed %d\n", ret);
> +		goto out;
> +	}
> +
> +	cgroup_fd =3D open_self_cgroupfd();
> +	if (cgroup_fd < 0) {
> +		ksft_test_result_skip("cannot open self cgroupfd\n");
> +		close(dmabuf_fd);
> +		goto out;
> +	}
> +
> +	xfer.charge_fd =3D cgroup_fd;
> +	ret =3D ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> +	ksft_test_result(!ret, "XFER_CHARGE to self cgroupfd %d\n", ret);
> +
> +	close(cgroup_fd);
> +	close(dmabuf_fd);
>  out:
>  	close(heap_fd);
>  }

[Severity: Medium]
Unlike test_alloc_pidfd_self(), test_alloc_pidfd_child(), and
test_alloc_cgroupfd_self(), test_xfer_charge_cgroupfd_self() does not call
pidfd_alloc_supported(heap_fd) or check for errno =3D=3D ENOTTY when
ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer) fails.

On an unpatched kernel where dmabuf_heap_alloc() and open_self_cgroupfd()
both succeed, won't ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer) retu=
rn
-1 with errno =3D=3D ENOTTY and cause ksft_test_result(!ret, ...) to report=
 a
failure instead of skipping?

[ ... ]

> diff --git a/tools/testing/selftests/dmabuf-heaps/vmtest.sh b/tools/testi=
ng/selftests/dmabuf-heaps/vmtest.sh
> new file mode 100755
> index 0000000000000..434857b765b84
> --- /dev/null
> +++ b/tools/testing/selftests/dmabuf-heaps/vmtest.sh
> @@ -0,0 +1,205 @@

[ ... ]

> +readonly DMABUF_HEAP_TEST=3D"${SCRIPT_DIR}"/dmabuf-heap
> +readonly MEMCONTROL_TEST=3D"${CGROUP_DIR}"/test_memcontrol
> +readonly TMP_DIR=3D$(mktemp -d /tmp/dmabuf-vmtest.XXXXXXXX)

[ ... ]

> +build_selftests() {
> +	make -C "${KERNEL_CHECKOUT}" headers_install \
> +		INSTALL_HDR_PATH=3D"${TMP_DIR}/usr" -j"$(nproc)"
> +
> +	local khdr=3D"-isystem ${TMP_DIR}/usr/include"
> +
> +	if ! make -C "${SCRIPT_DIR}" KHDR_INCLUDES=3D"${khdr}" -j"$(nproc)"; th=
en
> +		die "failed to build dmabuf-heaps selftests"
> +	fi
> +
> +	if ! make -C "${CGROUP_DIR}" KHDR_INCLUDES=3D"${khdr}" \
> +		"${MEMCONTROL_TEST}" -j"$(nproc)"; then
> +		die "failed to build cgroup/test_memcontrol selftest"
> +	fi
> +}

[ ... ]

> +make_runner() {
> +	# virtme-ng shares the host filesystem, so TMP_DIR is accessible
> +	# inside the VM at the same absolute path.
> +	cat > "${TMP_DIR}/run_tests.sh" <<-EOF

[ ... ]

> +	EOF
> +	chmod +x "${TMP_DIR}/run_tests.sh"
> +}
> +
> +run_vm() {
> +	local verbose_opt=3D""
> +	local kernel_opt=3D""
> +
> +	${VERBOSE} && verbose_opt=3D"--verbose"
> +
> +	# If we are running from within the kernel source tree, use the kernel
> +	# source tree as the kernel to boot, otherwise use the running kernel.
> +	if [[ "$(realpath "$(pwd)")" =3D=3D "${KERNEL_CHECKOUT}"* ]]; then
> +		kernel_opt=3D"${KERNEL_CHECKOUT}"
> +	fi
> +
> +	vng --run ${kernel_opt} ${verbose_opt} --user root --memory 512M \
> +		--exec "${TMP_DIR}/run_tests.sh"
> +}

[Severity: Medium]
Will "${TMP_DIR}/run_tests.sh" be visible inside the guest VM when TMP_DIR =
is
created under /tmp?

When virtme-ng boots the guest, virtme-init mounts a fresh tmpfs over /tmp
inside the VM, which masks the host's /tmp directory unless TMP_DIR is
explicitly shared via --rodir / --rwdir or created under a shared directory
such as SCRIPT_DIR. Won't vng --run --exec "${TMP_DIR}/run_tests.sh" fail in
the guest because /tmp/dmabuf-vmtest.XXXXXXXX/run_tests.sh does not exist
there?

> +
> +while getopts :hvbH:p: o
> +do
> +	case $o in
> +	v) VERBOSE=3Dtrue;;
> +	b) BUILD=3Dtrue;;
> +	H) BUILD_HOST=3D$OPTARG;;
> +	p) BUILD_HOST_PODMAN_CONTAINER_NAME=3D$OPTARG;;
> +	h|*) usage;;
> +	esac
> +done
> +shift $((OPTIND-1))
> +
> +trap cleanup EXIT
> +
> +check_vng
> +handle_build
> +check_deps
> +make_runner
> +
> +echo "Booting VM and running tests..."
> +run_vm

[Severity: Medium]
Should check_deps() verify vng and make before check_vng() and handle_build=
()
are called?

Right now, if vng or make is not installed, check_vng() runs vng --version
first and prints a command-not-found error plus an untested-version warning,
and if -b is passed, handle_build() fails via die() with KSFT_FAIL instead =
of
exiting with KSFT_SKIP in check_deps().

Also, in handle_build(), the script uses pushd "${KERNEL_CHECKOUT}" and popd
to build the kernel, whereas run_vm() only sets kernel_opt=3D"${KERNEL_CHEC=
KOUT}"
when $(pwd) is inside KERNEL_CHECKOUT. If vmtest.sh -b is invoked from
outside KERNEL_CHECKOUT, won't run_vm() ignore the freshly built kernel and
boot the running host kernel instead? And in build_selftests(), should the
make headers_install command also be checked for failure before building the
tests?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-v2_2023012=
3_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com?part=3D8

