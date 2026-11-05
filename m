Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0CA8606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ha46cxYz
Received: by kanga.kvack.org (Postfix)
	id 721D26B05BB; Thu,  5 Nov 2026 06:12:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC1E6B05BC; Thu,  5 Nov 2026 06:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573446B05BD; Thu,  5 Nov 2026 06:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2876F6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8D801408B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:09 +0000 (UTC)
X-FDA: 85400801178.29.2E7E2C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 039AE180006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha46cxYz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877128;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcZ6WPxWQqwmRStYl6C8MSMaB4AuiG3AzHw/8ODrNB0=;
	b=ZU5oGftS3G2IuGxb4g+XQmK/7i1CVbgu8fES3tz1bva6Esreusn3GOny9v2wWyqvZR3U2G
	vWrSR3rV6QNjpb/PEZC0g20NFN/p0uLQOMqfbMaPLcF0RvTxm4EVapiZDIzQtHOwBq7IFv
	oVPpn8ADG4PgHFxF7NojpPFqFFzTjrs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha46cxYz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877128;
	b=POsNKecokxAJ7QVHE8miVlvqHr20Pdx5wcKl36k1LP97QGFPJYDWmOwDdlsfyunJFXJRQf
	d9vqeGi4/K/UYy1ikz1/oRFOhi+59ZTKR3VOq5ClWB8b00J7r9scoKiVlSRKx57fYPXLEu
	R8mRI04njJie9xVj+bgpi0OxY+KCYC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2989140431;
	Thu,  5 Nov 2026 11:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66FC1F00A02;
	Thu,  5 Nov 2026 11:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793877127;
	bh=hcZ6WPxWQqwmRStYl6C8MSMaB4AuiG3AzHw/8ODrNB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ha46cxYz+f5O3PZ62l1EzAf2DcXdcDWFFCYFdsNiJ/EfMHBI9iN8WJBpEa2t/fhbp
	 YiDJyRyaTJOCXDn5V7ZQEodwI+80StGeRoeKjIa5fpnYD3nvFBIn4/eEas/jUSlsOe
	 TGo3JnveEd3aciHp+qSkSR+9noMtG6nKmUKsXo41W20ukXVNrlusIeeY/te8Q75sxc
	 FUjFnZc/8QSWNaBl1g9bnUKYJQTSIIw4Vob18CUplfhJ8L9qaCXRrSjsNLqz+gZkuy
	 yzsRj22YTXapgoeB58Kugn/8IjRan4j3psVvV6t7Q+Fop0YLlligZr6+nDT9FD1O4E
	 Q1YdgnuE01paA==
Message-ID: <sashiko-outbox-198923@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/8] selftests/dmabuf-heaps: Add dma-buf memcg
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
 Garg" <sumit.garg@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, media-ci@linuxtv.org
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-8-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-8-1819a017000b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 11:12:05 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 039AE180006
X-Stat-Signature: r1ocss89tm5kytho956kj5twgfsbfoz1
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793877127-556103
X-HE-Meta: U2FsdGVkX19IjrrCOTC3hu+U4/r5FaFGV9FN78ngFzrPUT+6jDzEI1uLpGbVHc5kzT/3G7OsLGUpLcXMfA2aRhQHVzI+heOXiNp6hUVwiNYMTfUXSDPO+17/8zlieqcYW7vYxiegYq9UZetlxmpVBAU6nzofJ+/K1mss7WYZ2rn5ihUWmnvq5PaOlVNUQKa4KCBRcIv8RyZ8T5K+nPOaH82ZKvuimJ1VOJiqs1JeqZLqOrDJN6+9EYPStkFMc4L1fr8D2VJfOnpZUmsjIYba7QpQLDh0QkAPHzOXlvrZlmcjbPpUNmtQHH3tmuy4S+1jh8qiUhHvE0kgxGcvtdPJxD88tOSFNO4dRF2JtuR4I4Ypc8Kka5BqTKobZlswWr0Qh8ar7f+H1elsZJ/IytrFLqT02YAAWtHIHQwCzE9GWfc0HlH+6pSZ+RxJg7juSq5Tkn05cD7GkVM+08Ej74OwqzhlCsU81MvW96WlFKbg2fWjCASvY/khCX3GE9CHjOHEDnPftuUyBEvlIxdfRRbmTEKuMxYL0goaoU3htmAz+ztj2W+F1Hwcn/aqGkhDqyoHfgmSiChqYCTVlVojJ1G8nIgsFFmqo075arDkZkNjnFdLpODiRNbzfTdwYwJqzAxhlunSKrjEvsxN0Za6YvhmiIDPqxMExo40ZksSSgE3LFu1NbOD0HVVcvgnB5TjuIYsEHCXNuLryagcmyKxQzOW1wilqggEwGy1eN8X+CWkf1fgZOKLDm2c6fzP9EpKfttSlxpdt6ChGevg6LxC1BmWBzxNWwVIGnIWYGTGptzQmL/JecLsmvHsMjJjYlDOFJwzF9d/86deQwNx5zAIUJSkbWcXebyKoX8hCNL9JGPXjevkTORKdnLF8x9+gORyOI6Yn9kFU8aoJryGymz3lLFW5cUMhW1jqQmz3GV1GNdsUlsEN5B2Ce6zVwXyBKOWhalyEJ3ONvapTBS6QKeb0BV
 PHyg/1Pm
 8+NJr2TBqpKrJCQMw32AThEkbEEzOIWvqqpk17xO/lqLtTNT7WVIt/NcYwjUzgBPVCKNwfZ9O1KS2zOvK06jZwmSGnbEDYF2fNNND8KVX5y63HnUI3GVOcMxKVJ5Qe5EzFZFqJaQQ3O6ctutluxRvFa0rDoSR6XeIMMUwacI+Li3oFikgG1PWbM1M/bJLqR2ODo55uRpVcC9s+kQWGvY8rJTtWoYg5SIUONrMVJXnltyOhZomtOwozzakn85MaxVdUbiM0pcJmxuQLhRUx+hiWJ7j77Z66ZqQzJVoawYSdrCWpVMf1msRa5KOA5ud9rOC6VU7ZAxAgw1TXx0fc5qxGYoBSE5cJa4nCoIgvf2SA3WqIwABwuxNV6tsxT5zef7CIBqK18fd/JwOet4T6fAtIIOHP8FtJuuDS2Udv/uw18AcNQ/SbZU+pPWVq5MVbUeQEo3J/Ehica4SQjKsu7l2RHXDblglMwFNfT5lZIfQl3zoYOoLQ4BxMqt1e2eeP/zAh0YasHUc4EpkgkAVhKVqU1bwF8q9gicevHhNbn5XBp4ElccCC7f1HsEnz/q23CcAUmFq93ZdC2sEtY9U6qRsQRv3nehWtrAERqGQwRB1vyY9pP8L84yjZ1WutTUj2w0JWXHJzWJvis8AlfpQVpqQ1EULsTaHZ0IG9g3H8jwicWvtAQ0GapklXzsIIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Medium] selftests/dmabuf-heaps: charge_fd=3D0 and unskipped EOPNOTSUPP i=
n XFER_CHARGE test
- [Medium] selftests/dmabuf-heaps: pidfd_alloc_supported() treats EOPNOTSUP=
P as supported
- [Medium] selftests/dmabuf-heaps: missing memory controller check in open_=
self_cgroupfd()
- [Medium] selftests/dmabuf-heaps: check_deps() runs before handle_build() =
in vmtest.sh
- [Low] selftests: cgroup: leak of child_cg on cg_create() failure in test_=
memcg_dmabuf()
--

commit b3c8a8b74499074e19a368c4979733bfe47e9d56
Author: Albert Esteve <aesteve@redhat.com>

selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

This commit adds selftests for dma-buf memcg accounting via charge_fd and
DMA_BUF_IOCTL_XFER_CHARGE in dmabuf-heaps and cgroup/test_memcontrol, along
with a virtme-ng runner script and Kconfig fragment.

> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index 0ed82347044ed..3c95bcabee2bd 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
[ ... ]
> +static int test_memcg_dmabuf(const char *root)
> +{
[ ... ]
> +	parent =3D cg_name(root, "dmabuf_memcg_test");
> +	if (!parent)
> +		goto cleanup;
> +
> +	if (cg_create(parent))
> +		goto cleanup_parent;
> +
> +	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
> +		goto cleanup_parent;
> +
> +	child_cg =3D cg_name(parent, "child");
> +	if (!child_cg)
> +		goto cleanup_parent;
> +
> +	if (cg_create(child_cg))
> +		goto cleanup_parent;
[ ... ]
> +cleanup_child:
> +	cg_destroy(child_cg);
> +	free(child_cg);
> +cleanup_parent:
> +	cg_destroy(parent);
> +	free(parent);
> +cleanup:
> +	return ret;
> +}

[Severity: Low]
Does test_memcg_dmabuf() leak the child_cg string buffer if
cg_create(child_cg) fails?

Jumping to cleanup_parent bypasses free(child_cg) under cleanup_child. Shou=
ld
that error path free child_cg (or jump to cleanup_child) before cleaning up
parent?

> diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/t=
esting/selftests/dmabuf-heaps/dmabuf-heap.c
> index 1d49df6719198..90ef14d2ecba0 100644
> --- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
> +++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
[ ... ]
> +/*
> + * Probe whether the kernel honours charge_fd in DMA_HEAP_IOCTL_ALLOC.
> + */
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
As reported by Sashiko on v3 [1], won't pidfd_alloc_supported() return true
when CONFIG_MEMCG is disabled?

When CONFIG_MEMCG=3Dn, the inline stub in include/linux/memcontrol.h returns
-EOPNOTSUPP for any file descriptor:

static inline struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
{
	return ERR_PTR(-EOPNOTSUPP);
}

In dma_heap_ioctl_allocate(), that causes DMA_HEAP_IOCTL_ALLOC to fail with
ret < 0 and errno =3D=3D EOPNOTSUPP when passed devnull_fd, so
pidfd_alloc_supported() treats the feature as supported and the subsequent
tests fail with EOPNOTSUPP instead of skipping.

Should pidfd_alloc_supported() check ret < 0 && errno !=3D EOPNOTSUPP?

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

[Severity: Medium]
As reported by Sashiko on v3 [2], what happens in test_alloc_cgroupfd_self()
and test_xfer_charge_cgroupfd_self() when the test process runs in a cgroup
where the memory controller is not enabled in its parent's
cgroup.subtree_control?

In mm/memcontrol.c:mem_cgroup_get_from_fd(), resolving a cgroup directory fd
requires an active memory controller CSS on that cgroup and returns -ENOENT
otherwise:

	cgrp =3D cgroup_get_from_fd(fd);
	if (!IS_ERR(cgrp)) {
		rcu_read_lock();
		css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
		if (!css || !css_tryget_online(css)) {
			rcu_read_unlock();
			cgroup_put(cgrp);
			return ERR_PTR(-ENOENT);
		}

Should open_self_cgroupfd() verify that the memory controller is enabled on
cgroup_path (or should the callers skip on ENOENT) so the tests skip rather
than fail when run outside vmtest.sh in a non-root cgroup without +memory?

[ ... ]
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
> +	if (!pidfd_alloc_supported(heap_fd)) {
> +		ksft_test_result_skip("charge_fd not supported by this kernel\n");
> +		goto out;
> +	}
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

[Severity: Medium]
As reported by Sashiko on v3 [3], won't test_xfer_charge_cgroupfd_self() fa=
il
with EOPNOTSUPP under default kernel parameters (dma_heap.mem_accounting=3D=
0) or
on heaps that do not set exp_info.memcg (such as CMA heaps)?

Here the buffer is allocated with dmabuf_heap_alloc(), which passes
charge_fd =3D 0. In drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate():

	if (heap_allocation->charge_fd) {
		memcg =3D mem_cgroup_get_from_fd(heap_allocation->charge_fd);
		if (IS_ERR(memcg))
			return ERR_CAST(memcg);
	}

	if (!memcg && mem_accounting)
		memcg =3D get_mem_cgroup_from_mm(current->mm);

When charge_fd is 0 and mem_accounting is false (the default), memcg is NUL=
L,
and drivers/dma-buf/dma-buf.c:dma_buf_xfer_charge() returns -EOPNOTSUPP when
dmabuf->memcg is NULL:

	if (!dmabuf->memcg) {
		ret =3D -EOPNOTSUPP;
		goto out;
	}

Similarly, pidfd_alloc_supported() passes for all heaps because charge_fd is
validated in dma_heap_ioctl_allocate() before heap->ops->allocate(), so
non-system heaps reach DMA_BUF_IOCTL_XFER_CHARGE with dmabuf->memcg =3D=3D =
NULL
and also return -EOPNOTSUPP.

Should test_xfer_charge_cgroupfd_self() allocate the buffer with a charge_fd
(e.g. via dmabuf_heap_alloc_pidfd()) and skip when DMA_BUF_IOCTL_XFER_CHARGE
fails with errno =3D=3D EOPNOTSUPP?

> diff --git a/tools/testing/selftests/dmabuf-heaps/vmtest.sh b/tools/testi=
ng/selftests/dmabuf-heaps/vmtest.sh
> new file mode 100755
> index 0000000000000..3574b71ca83e8
> --- /dev/null
> +++ b/tools/testing/selftests/dmabuf-heaps/vmtest.sh
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
[ ... ]
> +trap cleanup EXIT
> +
> +check_deps
> +check_vng
> +handle_build
> +make_runner

[Severity: Medium]
As reported by Sashiko on v3 [4], if vmtest.sh is invoked with -b on a clean
tree where the selftest binaries have not been built yet, won't check_deps()
exit with KSFT_SKIP before handle_build() has a chance to compile them?

Should handle_build() run before check_deps() (or should check_deps() skip
the binary existence checks when BUILD is true)?

[1] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
8-78d2c4cb8647@redhat.com
[2] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
8-78d2c4cb8647@redhat.com
[3] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
8-78d2c4cb8647@redhat.com
[4] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
8-78d2c4cb8647@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-v2_2023012=
3_tjmercier_google_com-v4-0-1819a017000b@redhat.com?part=3D8

