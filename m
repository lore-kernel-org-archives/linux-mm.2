Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D64D606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ii2Cv1I1
Received: by kanga.kvack.org (Postfix)
	id C3A726B05BC; Wed, 28 Oct 2026 11:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11F06B05BE; Wed, 28 Oct 2026 11:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE406B05BC; Wed, 28 Oct 2026 11:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF886B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:04:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E91818012E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:43 +0000 (UTC)
X-FDA: 85372356846.23.7AEDAFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B87E40005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ii2Cv1I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199882;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSdqxz6Q37ONxr+q5PLgX5Mx5sgsbL1ZlDMhRwJ4tls=;
	b=xQi3AwNApXdwGp0/zHbXR3Xr/v0QnmIAX7Ttbq8zeiSXSS4gTBbkFZrDqROMoMWG/Lw0+F
	w8MOIhwp9knJvFqzRnxFXUnnvDqwfW7PU8dGhgGWRhBDfOVuHRia7s3IqEE9lBeO4YjyiF
	NjiWpxEyOfs4B4IveQadBqdRVMpYDB8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ii2Cv1I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199882;
	b=izpp8eaMtA6TcusClnDxlmAcMB9QJsVCDUzu8K+Y9zLmWJMkpn2dFtsTbeShrSS9H4dRHq
	QUDR+UMmhhY8pSY5tLTbZ8Vnnrlbam9ZlpPpU3z5vX9ugaJrFheeW+rh0TTqvoPZoeIwcT
	BaAZ6kVEpVYD/YyLAhaZ6o5S5J6PgHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 833BF60252;
	Wed, 28 Oct 2026 15:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7631F01829;
	Wed, 28 Oct 2026 15:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199881;
	bh=mSdqxz6Q37ONxr+q5PLgX5Mx5sgsbL1ZlDMhRwJ4tls=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ii2Cv1I1mFw6z0jUk6ND3vI1KQsc+cPLiCIZMvKnAo54Gp0s/gplwdGsTCOINjF3m
	 Vyp8TPUP1c89LMrtNfl1SSCyLKR8iCzMdClXf8Ag22Q466Srn6wp0pPBEPe1niet9S
	 ltmp6epcmx5o/iHtRObx0gat20oSI3vbNsnbdjdF1arYD08Zmh3aUxS6DVRKuWcEhE
	 +D3p7ka5Cqbc2R7/WvOlKFR5jK2qoxxu/WaG77pXfVBFw+gw6l11JjB/aHP5om3QIg
	 XPjWzyvY1HOBKSJdOvSWDFjmd3ugT+ApaWExa7poGt1jjmuxkJPlMjdXVPIc7LG6HW
	 WCOxu4Wy9nCCA==
Message-ID: <sashiko-outbox-188032@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
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
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, echanude@redhat.com, mripard@kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:04:39 +0000
X-Rspamd-Queue-Id: 4B87E40005
X-Stat-Signature: j885cp83zohhcwe9thmrdsodkjukphkn
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793199882-629686
X-HE-Meta: U2FsdGVkX1/q2KVHmFwskrv5tIa6GSrtxqRE/euFfHpI6EN1d3tt8YSFvG3/y+bDPe0WOB+uc/ThbZrnWFJN3ykT/Wg4STHM1374GJ55j3QiDIFbueeEYOoeCl06yxw3jBxaST8Jeg+F7LBmxrHy8hh05RzvpUAWrv/y5qrPnRO+6FTj8SPmIeSwsOgJQYW9RBldSF+wxL0HGJtL9pUWa36Zi7tiE7bSBXEdMF8m4lWk3gNYzruRRj3vpK/KF+lw/B1pEoKm3ZU+BP4mbajFRkhxFNofS8G+XK3FyyCidLOx9KQqc8MG28wHRK4/qWK2mjgkn61hv0pRGLzJvDH/PnFecuxBdPYnFukwZBfJk95zwlR2DuKRYDwl8xbFWPLODxLO3bS05FwdxLxVKWZ99WLI/2PvlsE+BYg9mz/Z1ugM/+uxUbWt6akWphfCGL2FX3lhbi0F07wjRDRwO2E40jQqCwB6DrjC/pO+xyjQDK9l+IuaSEgqoiK1SQTBOYNufAJ259OM6lyqSe2YSFguZ+sFXJe7yO25G+GJ+JBBxBb2rPwfOvCnbKu48fWCX8fZHnEQp3EoA3Knz6FMNaouvTkpZ5XFodfyIyRsu0lq7Zi5JW1+ILbVcjzZQw3tiuxgaUuWbL58zqlZzuxb3Fy6m9TCDW4FoJ11A0fy1+EnxcSvPd0vZZg1QtOKRjX+x2UAQuq/egGY7dTl6LCV3ddRwMQvvQjgl1QHRyJIWVZFv76rwMuJOje//muAeOfF330bks+OPbgqjCILMclmTv2mOkWHH+nfJpe/6vnoHDyF30tABEMxygPH06XuJt9UY+cWb94GAEPdjk1P2GbgkSdMQxJjlUhFE78eF+OeETIdxK8d2pvMjwxgRl/ju4xe9z4D/Acn2qj+ymMaFXs37M4AcqSu7Em738Q9bW7qZz73D19VQblhwelLHQLJ7olBRSr/qLufuDqDZVi8uksmLmu
 /o7ac1hf
 fUC7ww55rnttppswbtaUfHYfJ6qQfSG9+1T3FYZCAv6PjbXumKbp2CS6ZDoqZHaBoMPaFC3+z3Kg2T59lJDH74zGiNyLy3g+VcDgW+puMyVt2AqRLbodrchJqPpkjREyKmZhuEJKYdKzDdvuGJi40lTTyG7i87LpbR0sFFrnl19NN/1A8nFGlASSyOj4IjrVe05slFNgaOm8F/sG6Nnu7byshcmEIg84yTacYOhHizBrIAUx/PKqp9qKDSJu1tlXZlwaNBbOUhcEPJasGWGvRJRnmsjyj06x+bAEi83ThlimZvzm/ITKiJvhrbFrlHHIng04awjaorVfb34i00buhxjWPaZJh27N4uB8AfJGpGkBzcXHqzFzxGIFn9Lozb03GFv7+tulUYb6U5dzeSpUiBOe0r9aa+RaK81fNTOUd2HIWnuz7qJEOCAtAdzutb5vHYMqoTQC0kXaEoYoJTvyjTMFVmMFGSDadvkJCWSLtyZY0/TWAZMX+6GsZopOrUsZ1K5mY2oLDJ+qZdCpA5IdZfsmKUpJdSW1hkyjfP9Jb6XphEy9FLdgt1de/6Vz1fYeGfropc2n3Bj9/SRDC0aZsot1Bde6FrZ/J4YhtThrN6llGBhMXEXcpP+9tlPupm/i84DVj+hsDOsYlfnef4iByLkD4bhDLqBBbH3Ha/JlgGGJDogW2tDWeYt8qs9AeuWYsOLfNz/4I9GYLXZ2IwpcaD/qqYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] dma-buf: unprivileged cgroup escape and OOM via dma_buf_xfer_charg=
e()
- [High] dma-buf: race in mem_cgroup_transfer_dmabuf_charge() double-charge=
s memcg
- [Medium] dma-buf: broken disabled-memcg handling in dma_buf_xfer_charge()
--

commit 1660729e62b15fd915c69f26225530bd5ae30ce0
Author: Albert Esteve <aesteve@redhat.com>

dma-buf: transfer memcg charges via DMA_BUF_IOCTL_XFER_CHARGE

This commit adds DMA_BUF_IOCTL_XFER_CHARGE to allow transferring a dma-buf's
memory cgroup charge to a cgroup identified by a cgroupfd or pidfd after
allocation. It also introduces a memcg_account flag in dma_buf_export_info =
for
exporters to opt in to memcg accounting, enabling it for the system heap.

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index f31f49ebd0af3..07513ecedc105 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf =
*dmabuf,
>  }
>  #endif
> =20
> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge=
 */
> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> +				const void __user *user_data)
> +{
> +	struct dma_buf_transfer_charge arg;
> +	struct mem_cgroup *memcg;
> +	int ret =3D 0;
> +
> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> +		return -EFAULT;
> +
> +	if (!IS_ENABLED(CONFIG_MEMCG))
> +		return 0;
> +
> +	if (arg.flags !=3D 0)
> +		return -EINVAL;
> +
> +	if (!dmabuf->memcg_account)
> +		return -EOPNOTSUPP;

[Severity: Medium]
When CONFIG_MEMCG is disabled, should dma_buf_xfer_charge() still validate
arg.flags and dmabuf->memcg_account, or return -EOPNOTSUPP?

Returning 0 before checking arg.flags !=3D 0 and !dmabuf->memcg_account cau=
ses
calls with invalid flags, non-accounting exporters, or invalid file
descriptors to silently succeed under CONFIG_MEMCG=3Dn, while also leaving =
the
!CONFIG_MEMCG stubs for mem_cgroup_get_from_fd() (which returns
ERR_PTR(-EOPNOTSUPP)) and mem_cgroup_transfer_dmabuf_charge() in
include/linux/memcontrol.h unreachable.

Also, when CONFIG_MEMCG=3Dy and cgroup_disable=3Dmemory is passed on the ke=
rnel
command line (so mem_cgroup_disabled() is true at runtime),
mem_cgroup_get_from_fd() behaves inconsistently across its two branches:

mm/memcontrol.c:mem_cgroup_get_from_fd() {
	cgrp =3D cgroup_get_from_fd(fd);
	if (!IS_ERR(cgrp)) {
		rcu_read_lock();
		css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
		if (!css || !css_tryget_online(css)) {
			rcu_read_unlock();
			cgroup_put(cgrp);
			return ERR_PTR(-ENOENT);
		}
...
	memcg =3D get_mem_cgroup_from_mm(mm);
	mmput(mm);
	return memcg;
}

For a cgroupfd, cgroup_css() is NULL and it returns ERR_PTR(-ENOENT), where=
as
for a pidfd, get_mem_cgroup_from_mm() returns NULL rather than an ERR_PTR, =
so
dma_buf_xfer_charge() returns 0 for pidfds and -ENOENT for cgroupfds.

> +
> +	memcg =3D mem_cgroup_get_from_fd(arg.charge_fd);
> +	if (IS_ERR(memcg))
> +		return PTR_ERR(memcg);
> +
> +	if (dmabuf->memcg =3D=3D memcg)
> +		goto skip_transfer;
> +
> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> +		ret =3D -ENOMEM;
> +		goto skip_transfer;
> +	}

[Severity: High]
Can an unprivileged holder of a dma-buf file descriptor use
dma_buf_xfer_charge() to escape its own memory cgroup limit or trigger OOM
kills in another cgroup?

In the call chain:

  dma_buf_ioctl()
    -> dma_buf_xfer_charge()
      -> mem_cgroup_get_from_fd()
      -> mem_cgroup_transfer_dmabuf_charge()
        -> mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages)
          -> try_charge()

neither dma_buf_xfer_charge() nor mem_cgroup_get_from_fd() checks DAC or
cgroup delegation/write permissions (such as inode_permission() with MAY_WR=
ITE
or cgroup_procs_write_permission()), capabilities, or ptrace_may_access() on
either the source cgroup (dmabuf->memcg) being uncharged or the target
cgroup/task (new_memcg) being charged.

Because /sys/fs/cgroup directories are normally world-readable (mode 0755, =
so
any user can open them with O_RDONLY | O_DIRECTORY) and pidfd_open() can op=
en
a pidfd for PID 1 or any visible process without privilege, an unprivileged
process can resolve a handle to the root cgroup or to another cgroup on the
system.

When SELinux is not active, security_dma_buf_charge_cgroup() and
security_dma_buf_charge_task() return 0. Even with SELinux enabled,
selinux_dma_buf_charge_cgroup() returns 0 when the cgroup kernfs node has no
explicit security.selinux xattr set:

security/selinux/hooks.c:selinux_dma_buf_charge_cgroup() {
	rc =3D kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, NULL, 0);
	if (rc =3D=3D -ENODATA)
		return 0;
}

and neither hook checks permission to uncharge the existing dmabuf->memcg. =
As
a result, a confined client receiving a pre-charged dma-buf fd can move the
charge to the root cgroup to bypass its own memory.max limit, or move the
charge into a victim cgroup where mem_cgroup_reserve_dmabuf() with GFP_KERN=
EL
triggers direct reclaim and the memcg OOM killer.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7b841b9057594..3adc84fe6668d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *m=
emcg, unsigned int nr_pages)
>  		refill_stock(memcg, nr_pages);
>  }
> =20
> +/**
> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
> + * @dmabuf: buffer to transfer charge
> + * @new_memcg: target memcg; caller must hold a reference
> + *
> + * Transfers the charge for @dmabuf to @new_memcg and, on
> + * success, stores @new_memcg in @dmabuf->memcg.
> + * Returns %true on success, %false if the charge against @new_memcg
> + * failed or a concurrent transfer raced on @dmabuf->memcg.
> + * On failure the caller retains its reference to @new_memcg.
> + */
> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> +				       struct mem_cgroup *new_memcg)
> +{
> +	struct mem_cgroup *old_memcg =3D READ_ONCE(dmabuf->memcg);
> +	unsigned int nr_pages =3D PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> +
> +	if (mem_cgroup_disabled())
> +		return true;
> +
> +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
> +		return false;
> +
> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> +
> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) !=3D old_memcg) {
> +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
> +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
> +		return false;
> +	}

[Severity: High]
What happens if two threads concurrently call DMA_BUF_IOCTL_XFER_CHARGE on =
the
same dma-buf?

In dma_buf_xfer_charge(), dmabuf->memcg =3D=3D memcg is checked without
synchronization before calling mem_cgroup_transfer_dmabuf_charge(), which t=
hen
re-reads old_memcg =3D READ_ONCE(dmabuf->memcg) without checking whether
old_memcg =3D=3D new_memcg.

If thread 1 transfers the buffer to new_memcg after thread 2 passes the
dmabuf->memcg =3D=3D memcg check in dma_buf_xfer_charge() (or if both threa=
ds
concurrently transfer the buffer to the same new_memcg), thread 2 sees
old_memcg =3D=3D new_memcg and still calls mem_cgroup_reserve_dmabuf(new_me=
mcg,
GFP_KERNEL, nr_pages) before uncharging old_memcg. That transiently charges
2 * nr_pages against new_memcg for the same buffer, which can trigger recla=
im,
memcg OOM kills, or -ENOMEM in new_memcg even though the buffer is already
charged to it.

In addition, old_memcg is read before mem_cgroup_reserve_dmabuf(new_memcg,
GFP_KERNEL, nr_pages), which can sleep in direct reclaim. If another thread
updates dmabuf->memcg while mem_cgroup_reserve_dmabuf() is sleeping, the
cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) fails without retrying against
the updated old_memcg and returns false, which dma_buf_xfer_charge() reports
to userspace as -ENOMEM even though charging new_memcg succeeded.

Finally, if mem_cgroup_transfer_dmabuf_charge() is called when
mem_cgroup_disabled() is true, returning true at the top without storing
new_memcg in dmabuf->memcg or dropping new_memcg's reference would leak the
 caller's reference to new_memcg, since callers only call mem_cgroup_put() =
when
this function returns false.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-v2_2023012=
3_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com?part=3D7

