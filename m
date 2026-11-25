Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C0C606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ktH/Sfpu
Received: by kanga.kvack.org (Postfix)
	id 8869E6B0A05; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828686B0A08; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C95E6B0A06; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37EEF6B0A05
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91B6DC0EE5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:05:31 +0000 (UTC)
X-FDA: 85473662862.20.49207B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D654C10000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:05:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ktH/Sfpu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611930;
	b=BKv0nSHu7AgcFO3ZOdMjSHnE6bo6GNSiugg9GOQGT39HHf/4cgx+L0chCpJ8AVMH6WkNBw
	pcqkkqMa1qYtfZPoO2YiFwDPmkX/wakr7FqnyDBAOtOB7d5OVxvlmhRk+LWItJlnwBdZZA
	TGDgoTcgAvdwR1THF7zIGOuQ19qnhQY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611930;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVX4Z3Av7ryf3LrYZitag57whdLEpy0ywu2taML45gM=;
	b=qLAu65h7T9JTWxzjiHYHs0QAnZKIt587y6beDRsYKmHUHE08AdvLoDUoIS3VjbVvKA+5gx
	8bIpOtY42+4ZdJvPCFnmXWvL1W2Yx77vPMOncdkq7zpUF3DohR1CJ7GD4FNfPf9dP5XP95
	BONUa8Zv4OGqK1eeXcprKlYbx0BhnYs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ktH/Sfpu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AEF043BCB;
	Wed, 25 Nov 2026 13:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C071F000C0;
	Wed, 25 Nov 2026 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611928;
	bh=yVX4Z3Av7ryf3LrYZitag57whdLEpy0ywu2taML45gM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ktH/SfpunRXeT5zhR2dhHk+SUijyNgYhqdbNDA+/vCr1uelXzxHG/fKzVW7++5xli
	 fWf6Rhvy9ACSMIP779/1E8qr4WQ8w4gP+yrpgkFlySmBtoX0zZtbRjpBf+l+AHsZfp
	 okwt56Uy+bQaMXe5mhRcR355F+5I2VD/cjGyWTlB5ACAfJx/LEIx2qBxWsThIlI9P5
	 Hk1U+jfVMg3rtLglt7jY56D43XFWBdlUW/ORxoA6GY/wFSzTuuqdNNKApUTGkW+ijQ
	 7eRaPy/29Q3q3qbWQnQ1cqDPJr6mjeSR8FIrFbJ/XdVB4f6WZyvhYfNqbmm4u4++mq
	 SgSVN16/1gUPA==
Message-ID: <sashiko-outbox-233449@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 7/7] selftests/dmabuf-heaps: Add dma-buf memcg
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
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, "Jens Wiklander" <jenswi@kernel.org>, "Sumit
 Garg" <sumit.garg@kernel.org>, "Philipp Stanner" <phasta@kernel.org>
Cc: airlied@gmail.com, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, echanude@redhat.com, mripard@kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-7-dce12fa03ad6@redhat.com>
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
 <20261124-v2_20230123_tjmercier_google_com-v6-7-dce12fa03ad6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:05:26 +0000
X-Rspamd-Queue-Id: D654C10000F
X-Stat-Signature: 14njastjfozjrao9jnbp91hjhex6s414
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795611929-456708
X-HE-Meta: U2FsdGVkX19yVT6XlDeWksPFSuo3HJ2OYsGUfip737jMy03szVOG6HvJFgM6KGPxNrwwSOdXpIFDBB6EtahmaCbVC4zCxlWWaX3IgGw+j1NR9kzy4hShby3K6OCxOxrLUwjrqSZ9CWueE/0RwfgZxyLbfhB2kgZDEmqJK3bx6QOfal+rvkE2BV7KKGNnxwOhgsFIJzFTW7yIL0qIuZB+9qIHr2Wm5lW5eeEBCxoffJFI9gm+CwjnS4reOhqu3eCh1L52y6B5pWfQljFVVVqNhp8V3Yj6GKa3dwZfg/ik/F+ngAXiKanJ3Kk+I7/o3AMG0ZiBmXpa4jPBQKS6+gFrY4PZV0TVDjUVkvaJKEpHd4yyXDq7C1Amf5Pc2N4EwUljwNGpb2nr7iANihh2vO8itlEd+dlH/1Tu2664SXIzTqNwBArC5F2bi1dx2EOVXo1OXvSosGchVAhVWe2H1EESZYjLqXGxnJsTB/1VFCP1H6sBYDm309ZvPgHIOZeyc1iHuP5SAElUvqRJ3IXCHy0Hix5M0EerpPReGVhOxxs/sV+abxnvmDfUd0OI2Rt5gM8gn0VTldS09P7a4OgE6c6Jh1jXZ996CIS4NR4DANOTn+QEi7/puob+3zuhSD25+GhH03t3JkJfHNPvmkBeaue1jSATM/5F4Z74jws0Kr4cv2p+NSU1FWYwwmE7I6yCfoOzMQURiNGS5dJ0xQI5Vv16qWIVCvLIAXjb3xqTZpwJjYx79Z4Mu3kYXWkOSz7YD35blPk4gzwqOT9vTN2/MdkTdcvhFIetoxWCKOM/e9O2zUEjrdoWmwJm4AxAgzdU5tcnD3jayiopN+EINjRLj1oTShLrTrg+ElkR4ApNwtdb5/a97JYxqbz2jw6MWFDABgPFLH3E8dZtCj12sEaya/21R2av9FNDWKBlpGjSKDQKFEeeiAGXDAH5Npy4d5SaKLlBX9IUmYFw4ahzLDNuTfF
 WSJGo8WY
 /sPVyKLcE9GcgmTjaUI3kxF1hj+zZnlFnCoucwDM6ekwiIzSG8Q9ZD5CjUNikB7SVg9Arz5kdTjB4xpUuD3Jcx8ETbGM/zuWjQm+SI93OcNDTk00O6JY/iKnSpxdsx4iyElJB2Rm/qhiE2dIj/iwTJw0FTvXwBAKUmR8o7c0SennngbH/V0X4aasIqUKEwfUdAaMidG0xxM9YM0tMiX6Rp1+aila4ORk+qrz34j1RUbsfeL/mYo2Wdk+JoV2Vb2lk6HSmWzSlZtd45/J3ELp9fRxovTXfK5sOKp3p1yU2EKiOqwps7RVv+q3XU+rkbMbGEWBSPL20e+EpvNFyWG28Kta6WQRaSCHWkQ/Y5NnYPm6YAJdawGUC3jZjEJDgA8WGN9wF6yqZxhmC54TDKChcOA+KRq0RR6kaEwJKV32tguL7M/urrt5DNuYN0037AMOIY/X2cWkmZ09diFWM9uPBBK/0KFVTfzVvrioHRRb1iu+V8XYOgkw0a1m6Dim/c9gDsN3yTaFqPpb9hPen3oJ9btYH7w6lrsY2TJg+YFBrmZ7+Hroz5WcfJQkIx34O/pxXCwn66qnMpi8nyl4toVr1EOHRLd1S5u7dlzx7KhioIJYW5YS0yhBsuVAsBnxdqEGRCEDbrApp9Q8SzpyuL/2P42TPoosooiukkWs2QK7Yb0bKFJ7i8d3qWa2BLgG8UU6aw313Ca0e1Iobr6kiYE/VLemt6qsx+xsEahCurBrotG0MJyGK/cnzUY48DhPWjXrJLeMa98kYhBsqnmwISwlTLpXTAoCoRA6+jqsj7KN4tdMi/67ZS6JrYDL+yJM4Gg5/B62iXBxNte6Iuf7qq852tKkA9Stiw78bJ4RGv79TnlIqBMIPnJeFHjFfMgMoZb7rsMr0P2/bpqoWu9k=
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
- [Medium] selftests/cgroup: test_memcg_dmabuf_xfer_at_limit() misses
  skip checks
- [Medium] selftests/cgroup: dmabuf tests read memory.stat below rstat
  flush threshold
- [Medium] selftests/dmabuf-heaps: pidfd_alloc_supported() mishandles
  disabled memcg
- [Medium] selftests/dmabuf-heaps: open_self_cgroupfd() misses memory
  controller check
- [Medium] selftests/dmabuf-heaps: check_deps() runs before
  handle_build() in vmtest.sh
- [Low] selftests/cgroup: child_cg leak on cg_create() error in
  test_memcg_dmabuf()
- [Low] selftests/cgroup: unused MEMCG_SOCKSTAT_WAIT_RETRIES macro in
  test_memcontrol
- [Low] selftests/dmabuf-heaps: make_runner() omits
  test_memcg_dmabuf_dead_cgroup
- [Low] selftests/dmabuf-heaps: vmtest.sh creates TMP_DIR before setting
  EXIT trap
--

commit 65b17f139f560196804a32a9dffe9eb0a344be15
Author: Albert Esteve <aesteve@redhat.com>

selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

This commit adds selftests for dma-buf memcg accounting via charge_fd and
DMA_BUF_IOCTL_XFER_CHARGE in dmabuf-heaps and cgroup/test_memcontrol, along
with a virtme-ng test runner script and config fragment.

> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index bb673012dcf08..f612726bd9af7 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -27,6 +34,13 @@
>  #define MEMCG_FLUSH_BYTES	\
>  	(2 * sysconf(_SC_PAGESIZE) * MEMCG_CHARGE_BATCH * get_nprocs())
> =20
> +#define DMA_HEAP_SYSTEM		"/dev/dma_heap/system"
> +#define ONE_MEG			(1024 * 1024)
> +
> +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30

[Severity: Low]
MEMCG_SOCKSTAT_WAIT_RETRIES was removed by eb69e955de7b ("selftests:
cgroup: make test_memcg_sock check flushed sock stats") and has no users.
Was it re-added here by mistake during a rebase?

> +#define MEMCG_DMABUF_WAIT_RETRIES          30
> +#define MEMCG_DMABUF_DEAD_WAIT_RETRIES     80
> +
>  static bool has_localevents;
>  static bool has_recursiveprot;
>  static int page_size;
> @@ -1797,6 +1811,417 @@ static int test_memcg_inotify_delete_dir(const ch=
ar *root)
>  	return ret;
>  }
> =20
[ ... ]
> +static int test_memcg_dmabuf(const char *root)
> +{
> +	char *parent =3D NULL, *child_cg =3D NULL;
> +	int ret =3D KSFT_FAIL;
[ ... ]
> +	child_cg =3D cg_name(parent, "child");
> +	if (!child_cg)
> +		goto cleanup_parent;
> +
> +	if (cg_create(child_cg))
> +		goto cleanup_parent;

[Severity: Low]
Does this leak child_cg when cg_create(child_cg) fails?  Jumping to
cleanup_parent skips free(child_cg) in cleanup_child.

[ ... ]
> +	dmabuf_stat =3D cg_read_key_long(child_cg, "memory.stat", "dmabuf ");
> +	if (dmabuf_stat =3D=3D -1) {
> +		ret =3D KSFT_SKIP;
> +		goto cleanup_dmabuf;
> +	}
> +	if (dmabuf_stat !=3D ONE_MEG)
> +		dmabuf_stat =3D cg_read_key_long_poll(child_cg, "memory.stat",
> +						    "dmabuf ", ONE_MEG,
> +						    MEMCG_DMABUF_WAIT_RETRIES,
> +						    DEFAULT_WAIT_INTERVAL_US);

[Severity: Medium]
Can polling memory.stat for ONE_MEG miss the rstat flush threshold in
test_memcg_dmabuf(), test_memcg_dmabuf_xfer_at_limit(), and
test_memcg_dmabuf_dead_cgroup()?

Reading memory.stat only flushes rstat synchronously when pending updates
exceed MEMCG_CHARGE_BATCH * num_online_cpus() pages.  On systems with 4 or
more CPUs (or 64 KB pages), a 1 MB charge or uncharge is below that
threshold, so cg_read_key_long_poll() relies on the periodic 2s deferrable
stats_flush_dwork running within the 3s poll window (the same issue fixed
for test_memcg_sock by eb69e955de7b ("selftests: cgroup: make
test_memcg_sock check flushed sock stats") using MEMCG_FLUSH_BYTES).

In addition, when test_memcg_dmabuf_xfer_at_limit() polls cg_a for ONE_MEG
after DMA_BUF_IOCTL_XFER_CHARGE fails with ENOMEM, cg_read_key_long_poll()
immediately matches the pre-existing cached ONE_MEG value on its first read
without flushing rstat after the ioctl.

[ ... ]
> +static int test_memcg_dmabuf_xfer_at_limit(const char *root)
> +{
[ ... ]
> +	if (ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc) < 0) {
> +		close(alloc.charge_fd);
> +		goto cleanup_heap;
> +	}
> +	close(alloc.charge_fd);
> +	dmabuf_fd =3D (int)alloc.fd;
[ ... ]
> +	xfer.charge_fd =3D (__u32)cg_b_fd;
> +	if (ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer) =3D=3D 0) {
> +		fprintf(stderr, "xfer_charge should have failed at limit\n");
> +		goto cleanup_cgfd;
> +	}
> +	if (errno !=3D ENOMEM) {
> +		fprintf(stderr, "Expected ENOMEM, got %s\n", strerror(errno));
> +		goto cleanup_cgfd;
> +	}

[Severity: Medium]
Should test_memcg_dmabuf_xfer_at_limit() set ret =3D KSFT_SKIP when
DMA_HEAP_IOCTL_ALLOC or DMA_BUF_IOCTL_XFER_CHARGE fails with EINVAL,
ENOTTY, or EOPNOTSUPP?

Unlike test_memcg_dmabuf() and test_memcg_dmabuf_dead_cgroup(), neither
ioctl failure path sets ret =3D KSFT_SKIP, so this test fails instead of
skipping on unpatched kernels or when dma_heap.mem_accounting=3D0.

> diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/t=
esting/selftests/dmabuf-heaps/dmabuf-heap.c
> index 1d49df6719198..44e3f33acf877 100644
> --- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
> +++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
[ ... ]
> +static bool pidfd_alloc_supported(int heap_fd)
> +{
> +	int devnull_fd, dmabuf_fd =3D -1, ret;
> +
> +	devnull_fd =3D open("/dev/null", O_RDONLY);
> +	if (devnull_fd < 0)
> +		return false;
> +
> +	ret =3D dmabuf_heap_alloc_pidfd(heap_fd, ONE_MEG, 0, devnull_fd, &dmabu=
f_fd);
> +	if (dmabuf_fd >=3D 0) {
> +		close(dmabuf_fd);
> +		dmabuf_fd =3D -1;
> +	}
> +	close(devnull_fd);
> +	return ret < 0;
> +}

[Severity: Medium]
Does pidfd_alloc_supported() return true when memory cgroups are disabled?

When CONFIG_MEMCG=3Dn or cgroup_disable=3Dmemory is passed at boot,
get_obj_cgroup_from_fd() returns ERR_PTR(-EOPNOTSUPP) before inspecting the
fd.  Because ret < 0 is true, pidfd_alloc_supported() reports charge_fd as
supported (whereas active memcg rejects /dev/null with EBADF), and
test_alloc_pidfd_self(), test_alloc_pidfd_child(), and
test_alloc_cgroupfd_self() then fail with EOPNOTSUPP instead of skipping.

[ ... ]
> +static int open_self_cgroupfd(void)
> +{
> +	char cgroup_path[PATH_MAX];
> +	char line[PATH_MAX];
> +	int ret =3D -1;
> +	FILE *f;
> +
> +	f =3D fopen("/proc/self/cgroup", "r");
> +	if (!f)
> +		return -1;
> +	while (fgets(line, sizeof(line), f)) {
> +		if (strncmp(line, "0::", 3))
> +			continue;
> +		line[strcspn(line, "\n")] =3D '\0';
> +		if (snprintf(cgroup_path, sizeof(cgroup_path),
> +			     "/sys/fs/cgroup%s", line + 3) < PATH_MAX)
> +			ret =3D 0;
> +		break;
> +	}
> +	fclose(f);
> +
> +	if (ret)
> +		return -1;
> +
> +	return open(cgroup_path, O_RDONLY | O_DIRECTORY);
> +}

[Severity: Medium]
What happens in test_alloc_cgroupfd_self() and
test_xfer_charge_cgroupfd_self() if the calling process runs in a cgroup
where the memory controller is not enabled?

Unlike the pidfd path in get_obj_cgroup_from_fd(), which resolves the
effective ancestor CSS via task_css(), the cgroup directory fd path calls
css_tryget_online_from_dir() directly on that directory and fails with
ENOENT when +memory is not enabled in its parent's cgroup.subtree_control,
causing both tests to fail instead of skipping.

> diff --git a/tools/testing/selftests/dmabuf-heaps/vmtest.sh b/tools/testi=
ng/selftests/dmabuf-heaps/vmtest.sh
> new file mode 100755
> index 0000000000000..3574b71ca83e8
> --- /dev/null
> +++ b/tools/testing/selftests/dmabuf-heaps/vmtest.sh
> @@ -0,0 +1,226 @@
[ ... ]
> +readonly DMABUF_HEAP_TEST=3D"${SCRIPT_DIR}"/dmabuf-heap
> +readonly MEMCONTROL_TEST=3D"${CGROUP_DIR}"/test_memcontrol
> +readonly TMP_DIR=3D$(mktemp -d /tmp/dmabuf-vmtest.XXXXXXXX)

[Severity: Low]
Does creating TMP_DIR before getopts leak /tmp/dmabuf-vmtest.XXXXXXXX when
usage() exits on -h or an invalid option before trap cleanup EXIT is
installed?

[ ... ]
> +check_deps() {
> +	for dep in vng make; do
> +		if [[ ! -x $(command -v "${dep}") ]]; then
> +			echo -e "skip:    dependency ${dep} not found!\n"
> +			exit "${KSFT_SKIP}"
> +		fi
> +	done
> +
> +	if ${SHELL_MODE}; then
> +		return
> +	fi
> +
> +	if [[ ! -x "${DMABUF_HEAP_TEST}" ]]; then
> +		printf "skip:    %s not found!" "${DMABUF_HEAP_TEST}"
> +		printf " Please build the kselftest dmabuf-heaps target (or use -b).\n"
> +		exit "${KSFT_SKIP}"
> +	fi
> +
> +	if [[ ! -x "${MEMCONTROL_TEST}" ]]; then
> +		printf "skip:    %s not found!" "${MEMCONTROL_TEST}"
> +		printf " Please build the kselftest cgroup target (or use -b).\n"
> +		exit "${KSFT_SKIP}"
> +	fi
> +}

[Severity: Medium]
Does check_deps() exit with KSFT_SKIP when vmtest.sh -b is run on an
unbuilt tree?

check_deps() runs before handle_build() compiles DMABUF_HEAP_TEST and
MEMCONTROL_TEST, and it only returns early for SHELL_MODE, not BUILD.

[ ... ]
> +	run "dmabuf-heap charge_fd ioctl"	${DMABUF_HEAP_TEST}
> +	run "memcontrol dma-buf memcg"	${MEMCONTROL_TEST} test_memcg_dmabuf
> +	run "memcontrol dma-buf xfer limit" \
> +		${MEMCONTROL_TEST} test_memcg_dmabuf_xfer_at_limit

[Severity: Low]
Should make_runner() also run test_memcg_dmabuf_dead_cgroup here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-v2_2023012=
3_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com?part=3D7

