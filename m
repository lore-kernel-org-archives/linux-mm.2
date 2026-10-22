Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64AF606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGWGvYoD
Received: by kanga.kvack.org (Postfix)
	id C390D6B0984; Thu, 22 Oct 2026 11:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9FE6B0985; Thu, 22 Oct 2026 11:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA436B0986; Thu, 22 Oct 2026 11:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0506B0984
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:44:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C79C68018C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:27 +0000 (UTC)
X-FDA: 85350684174.07.DC3D02F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E304A000D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGWGvYoD;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683866;
	b=6qTIo+r/npUlAR7IR1CST6kXG95XFISCylKP1uHbc+LtzqfGgsElGqH3iOsxmwroEwROC9
	un12QaMAD1pDf1V2jNSflcaCx0nyVfBNDuJilAbd2Dth7vrbGjvlA9rpoi2SsTsaIsezBH
	HCpBo0R3O8lq5MDVjhoQDh+M/+OAmbY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGWGvYoD;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683866;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGgflXK4MfDBHbCEq/XKqDgm4zksQtk/vvp4CoseElg=;
	b=jquIh2J/BP17axsqHTC4Sn9fMjZaoeP1Y9fSYlleW53kuY4yAkTgMzlZvxYzG6C+CwzSKo
	8w/eqQu1MpkYBEffaeSC59UJjD74jrtA7MhOsgOgfKvgnnSCkausQacUSVmcoPreVw0AlO
	uzJZf4IaG7P3fEm03GlPaesEhO9mSNQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6044F63E2E;
	Thu, 22 Oct 2026 15:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A581F01825;
	Thu, 22 Oct 2026 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683865;
	bh=aGgflXK4MfDBHbCEq/XKqDgm4zksQtk/vvp4CoseElg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UGWGvYoDcEERrFFNuzIRMe+Hf24mdTj7fiafXrumfnKc8F8NC6HPokMfkpomF5Qfv
	 z4CVR+XRg/VqPObsNV0heciMkJ+O30MiWEflS12sEdFpmq6dRCSWDoOGpCf4LD2L+7
	 RE80Lz5NPJiiWIJpD0SppcJR/28g6cjSyRZ+VeULVk+tFhn7/yLsqBIh90EjrIz8Qo
	 OOQCtnAWLMD+UBd8PXzuz2jRSZmRs4tl4VBOjo48PcF/xkPm1NyxeuG7o+W1cWdFJK
	 JFdAi9hW/RY4hAlvYzRg26lbb+nn9/UBpao0sf4mWR4umF2X3cG0KNz3JLiCnaW3Tf
	 GJCVZ9RmjrUfQ==
Message-ID: <sashiko-outbox-181723@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 7/8] dma-buf: transfer memcg charges via
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
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, mripard@kernel.org, echanude@redhat.com, media-ci@linuxtv.org
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-7-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-7-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:44:22 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E304A000D
X-Stat-Signature: amagbb3x33opao8f1bzfmr3j646zo6mk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792683865-355445
X-HE-Meta: U2FsdGVkX18qscBT82O73c388QRBWFBZ2pugr/G+iBmyGSu2zgJC8+4CrTQm0caXyuwt8NVc1nTcYXKmhBOTrBKVqB8HjOH9OjSWrwBnAhEE8z1I+MxdGm2Ip7Yqpmb1/lto4NsNmLG3CpygHzoq0fe4oO2sh40Ii7Mneqaj4/fgOukK2fIhAD1ok22ThhB37ogCWKHzHK7zRfT2hmHTTeKEfpiFZqfEHjJohS3lAppyJNXsz6G3Y4sfFd35jHXyjaxFIR+/3Rgv9D25U85UGfAHpV/ewo3mdclO6Bt7dyroLOLWiQ7LqBnjGliNvHKL6V6mcmnWTiaKktWHVsChBm9Ra9ntK9L6C8vuAzRixXmCl3bvV8OAdLpSR5FbJxU31/fpr+P0iLjz9XzilgM+saZQX9V50tJm2YLnaeG7yA1eeGKUIocRgGgQ5i72885JMTGkkkxWTeHBmc5+F2E1N3h7KIkJVgFDUJensSGZYlvrysyaigQDCXLV77U+CPFM0BpaApLuGtb9p4C3Koe0Sd0HxQw63hAkayUYytKZ14aYc9xmUAbaID2SnOMIRzu6kW207SW5Zp62O7MXZ4A+stVTeGa2UGdwmlaGu/pAEV2OF9NNl6Lbh22J8MHkdn6awwbDR3TUDELG0cWp2m4O+CFHbiA7IegZF7SQVV0mv5EfReQ7vCtm4C6pNztVZ0wtniYQSdlugL05Vp3xkB3EeFj7jAc+R5XJW8K2RYs+gNd5W4C+RmTF6IgdKvBgZn52s2Ef3GpOInJm1SiGTllkOnne13WbDUm1RyDMlEJe46844vFfAcOAt8DgCzzIquPYpLF0I4AlZ+oZtRDWCSwkRr6nGu8BOJUim7ZaoSDPblXKMi3AI8UW6F2Tt6gyAUgmte0XMq7ED1pT6Vp3IYH5THdDXA6CDH/gG/l+KYw9W8KtIhDeXZqFjAt/OG+0RzVusTlwAVW0kzrMgNOWHbT
 GbhX9IlL
 rWq349cQgBAIMXcUtuEvpBAuEGYRJEnjq1URlcdvMRyrhBqg3l7xL0VlW8XuN6j8PNZqf0uiFBh+fFEAesh7qh7TgA/w3K3woCordy8eIgtiJcdFZBJLVyAm6+6Vwoap2GhB/fZVy45PP8Zl+qKM4ElVt1xK9QmTe4iyXX+WNLhKVUqrPuEMDnNtHgGTu87zt1m+eWO25QzWOO0V9boiKa2p5iFSo7pOMAa4siU2uS6PbkR4n3+UL3d0iQI9RD/TAV+fRZo08qd7y/SlG9QMWnsVCsuJexT7L+FtFSTRSCQoULX1lJhx7PjxXbnrWPNIkcHIBUBtHLj4vF4tKqARCZmwa+kFh95GWged69QenkFUr7LlOwOBpZpy67645h0rx3lFdNxz/6QXVgl13M++5vyCGRfLEnNYqiETM6IgXRxt7Wz0phgMdaUzR6kRCzbRaR3WsxLo0cVAbkVhaPWy+3LAJpTdCecU6wENuHA967xXQ6nd8vb7Wbbbt2Ko34bhH+6YpBXfhpNIJ58MiNcu2Z8avWZZ7HDvWsw+74TcyAT1n+coAmuGnrhwVgN5C3AeuPQFx7awrZwEoWFVOe85/2MC2ZGarxskm6d4nshQhTo0wt9Bv+UD+tqR5hfOO1bBSJEnYsGYYmGn2ATk8EdW4nnGoIeLCRVSPXM3dmfWsBYmZsSlvKdEgD4u+AM4y6QseOxTdgpr4BFMOvdA0selLAz5Udw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] dma-buf: task->mm UAF and wrong cgroup fallback in dma_buf_xfe=
r_charge()
- [Critical] mm: memcontrol: new_memcg UAF race in mem_cgroup_transfer_dmab=
uf_charge()
- [High] dma-buf: missing DAC permission checks in dma_buf_xfer_charge()
- [Medium] dma-buf: double charge and -ENOMEM race in mem_cgroup_transfer_d=
mabuf_charge()
- [Medium] dma-buf: broken runtime mem_cgroup_disabled() handling in dma_bu=
f_xfer_charge()
- [Low] dma-buf: build failure in dma_buf_xfer_charge() when CONFIG_MEMCG=
=3Dn
--

commit c7c3a18bea48fc8f09ccf4a84a6aa11e6f991c4c
Author: Albert Esteve <aesteve@redhat.com>

dma-buf: transfer memcg charges via DMA_BUF_IOCTL_XFER_CHARGE

This commit adds the DMA_BUF_IOCTL_XFER_CHARGE ioctl and
mem_cgroup_transfer_dmabuf_charge() helper to transfer a dma-buf's memory
cgroup charge to a target cgroup identified by a cgroupfd or pidfd.

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index f31f49ebd0af3..7fa607d9bf657 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -540,6 +540,80 @@ static long dma_buf_import_sync_file(struct dma_buf =
*dmabuf,
>  }
>  #endif
> =20
> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> +				const void __user *user_data)
> +{
> +	struct cgroup *cgrp;
> +	struct cgroup_subsys_state *css;
> +	struct dma_buf_transfer_charge arg;
> +	struct mem_cgroup *memcg;
> +	struct task_struct *task;
> +	const struct cred *tcred;
> +	unsigned int pidfd_flags;
> +	int ret =3D 0;
> +
> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> +		return -EFAULT;
> +
> +	if (!IS_ENABLED(CONFIG_MEMCG))
> +		return 0;

[Severity: Low]
Will drivers/dma-buf/dma-buf.c fail to build in dma_buf_xfer_charge() when
CONFIG_DMA_SHARED_BUFFER=3Dy and CONFIG_MEMCG=3Dn (or CONFIG_CGROUPS=3Dn)?

Because if (!IS_ENABLED(CONFIG_MEMCG)) is a runtime C conditional rather
than a preprocessor guard, the compiler still resolves all symbols in the
rest of dma_buf_xfer_charge().

In include/linux/cgroup_subsys.h, memory_cgrp_subsys is only declared when
CONFIG_MEMCG is enabled:

    #if IS_ENABLED(CONFIG_MEMCG)
    SUBSYS(memory)
    #endif

And when CONFIG_CGROUPS=3Dn, cgroup_get_from_fd(), cgroup_css(),
css_tryget_online(), and cgroup_put() in include/linux/cgroup.h have no
stub declarations. Should the body of dma_buf_xfer_charge() be guarded with
#if IS_ENABLED(CONFIG_MEMCG) instead?

> +
> +	if (arg.__padding !=3D 0)
> +		return -EINVAL;
> +
> +	cgrp =3D cgroup_get_from_fd(arg.charge_fd);
> +	if (!IS_ERR(cgrp)) {
> +		/* charge_fd is a cgroupfd */
> +		rcu_read_lock();
> +		css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
> +		if (!css || !css_tryget_online(css)) {
> +			rcu_read_unlock();
> +			cgroup_put(cgrp);
> +			return -ENOENT;
> +		}

[Severity: Medium]
What happens in dma_buf_xfer_charge() when CONFIG_MEMCG=3Dy but memory cgro=
ups
are disabled at boot via cgroup_disable=3Dmemory (so mem_cgroup_disabled() =
is
true)?

In that configuration, passing a valid cgroupfd causes
cgroup_css(cgrp, &memory_cgrp_subsys) to return NULL and fail with -ENOENT,
whereas passing a pidfd calls get_mem_cgroup_from_mm() in mm/memcontrol.c,
which returns NULL when mem_cgroup_disabled() is true, matches
dmabuf->memcg =3D=3D NULL, and returns 0.

Similarly, in mm/memcontrol.c, mem_cgroup_transfer_dmabuf_charge() only
skips try_charge() when mem_cgroup_disabled() is true:

    if (!mem_cgroup_disabled() && try_charge(new_memcg, GFP_KERNEL, nr_page=
s))
            return false;

Unlike mem_cgroup_charge_dmabuf(), which returns true immediately when
mem_cgroup_disabled() is true, mem_cgroup_transfer_dmabuf_charge() still
proceeds to cmpxchg(), mod_memcg_state(), and refill_stock(). Should both
dma_buf_xfer_charge() and mem_cgroup_transfer_dmabuf_charge() return early
when mem_cgroup_disabled() is true?

> +
> +		memcg =3D mem_cgroup_from_css(css);
> +		rcu_read_unlock();
> +
> +		ret =3D security_dma_buf_charge_cgroup(current_cred(), cgrp);
> +		cgroup_put(cgrp);
> +		if (ret) {
> +			mem_cgroup_put(memcg);
> +			return ret;
> +		}
> +	} else {
> +		/* charge_fd is a pidfd  */
> +		task =3D pidfd_get_task(arg.charge_fd, &pidfd_flags);
> +		if (IS_ERR(task))
> +			return PTR_ERR(task);
> +
> +		tcred =3D get_task_cred(task);
> +		ret =3D security_dma_buf_charge_task(current_cred(), tcred);
> +		put_cred(tcred);
> +		if (ret) {
> +			put_task_struct(task);
> +			return ret;
> +		}

[Severity: High]
Is a DAC or cgroup permission check needed in dma_buf_xfer_charge() in
addition to the security_dma_buf_charge_cgroup() and
security_dma_buf_charge_task() LSM hooks?

In drivers/dma-buf/dma-buf.c, dma_buf_xfer_charge() relies solely on those
LSM hooks to authorize the transfer:

- In the cgroupfd path, cgroup_get_from_fd(arg.charge_fd) only checks that
  the file descriptor refers to a cgroup v2 directory, without verifying
  write access (such as inode_permission() with MAY_WRITE or
  cgroup_procs_write_permission()). Because /sys/fs/cgroup directories are
  world-readable (0755) by default, an unprivileged process can open
  /sys/fs/cgroup or another service's cgroup with O_RDONLY | O_DIRECTORY.
- In the pidfd path, pidfd_get_task() resolves any pidfd without checking
  whether current may act on that task (for example via ptrace_may_access()
  or credential/cgroup authorization).

When CONFIG_SECURITY=3Dn, when no LSM implementing these hooks is active, w=
hen
a cgroup directory has no explicit security.selinux xattr, or when two
cgroups share the same SELinux domain, the hooks return 0. Could an
unprivileged holder of a dma-buf fd use DMA_BUF_IOCTL_XFER_CHARGE to shift
its charges to the root cgroup (where try_charge() in
mem_cgroup_transfer_dmabuf_charge() is a no-op, bypassing its own
memory.max), or transfer large charges into another cgroup to exhaust its
memory.max and trigger mem_cgroup_oom()?

> +
> +		memcg =3D get_mem_cgroup_from_mm(task->mm);
> +		put_task_struct(task);
> +	}

[Severity: Critical]
Can passing task->mm directly to get_mem_cgroup_from_mm(task->mm) in
dma_buf_xfer_charge() cause a use-after-free or charge the wrong cgroup?

In drivers/dma-buf/dma-buf.c, pidfd_get_task() pins task->usage, but it
does not pin task->mm or hold task_lock(task). If the target task
concurrently exits or execs:

    do_exit()
      exit_mm()
        task_lock(current);
        current->mm =3D NULL;
        ...
        task_unlock(current);
        ...
        mmput(mm); -> __mmdrop(mm) -> free_mm(mm)

or replaces its mm via execve() -> exec_mmap() -> exec_mm_put_old(), the
old mm_struct can be freed while get_mem_cgroup_from_mm() in mm/memcontrol.c
dereferences mm->owner:

    rcu_read_lock();
    do {
            memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));

In addition, if task->mm is already NULL (such as a zombie task that has
completed exit_mm(), for which pidfd_get_task() still succeeds),
get_mem_cgroup_from_mm(NULL) in mm/memcontrol.c falls back to the caller's
context:

    if (unlikely(!mm)) {
            memcg =3D active_memcg();
            if (unlikely(memcg)) {
                    /* remote memcg must hold a ref */
                    css_get(&memcg->css);
                    return memcg;
            }
            mm =3D current->mm;
            if (unlikely(!mm))
                    return root_mem_cgroup;
    }

Instead of failing when the target task has no mm, this silently attributes
the dma-buf charge to the caller's own cgroup (or root_mem_cgroup). Should
dma_buf_xfer_charge() acquire a reference via get_task_mm(task), return an
error such as -ESRCH when mm is NULL, and call mmput(mm) after
get_mem_cgroup_from_mm(mm)?

> +
> +	if (dmabuf->memcg =3D=3D memcg)
> +		goto skip_transfer;
> +
> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> +		ret =3D -ENOMEM;
> +		goto skip_transfer;
> +	}

[ ... ]

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e94222237d31a..d994a4b2d35e4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5688,6 +5688,46 @@ bool mem_cgroup_charge_dmabuf(struct dma_buf *dmab=
uf, struct mem_cgroup *memcg,
>  	return true;
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
> +	if (!mem_cgroup_disabled() && try_charge(new_memcg, GFP_KERNEL, nr_page=
s))
> +		return false;
> +
> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) !=3D old_memcg) {
> +		if (!mem_cgroup_is_root(new_memcg))
> +			refill_stock(new_memcg, nr_pages);
> +		return false;
> +	}

[Severity: Medium]
How does mem_cgroup_transfer_dmabuf_charge() behave when two threads race
to transfer the same dmabuf?

First, dma_buf_xfer_charge() in drivers/dma-buf/dma-buf.c checks
dmabuf->memcg =3D=3D memcg before calling mem_cgroup_transfer_dmabuf_charge=
(),
which then reloads old_memcg =3D READ_ONCE(dmabuf->memcg) without rechecking
old_memcg =3D=3D new_memcg. If two threads concurrently transfer dmabuf to =
the
same target cgroup, both can pass the check in dma_buf_xfer_charge(); after
the first transfer finishes, the second thread reads
old_memcg =3D=3D new_memcg and calls try_charge(new_memcg, GFP_KERNEL, nr_p=
ages)
before uncharging old_memcg, transiently charging 2 * nr_pages to new_memcg
and potentially triggering unnecessary reclaim, OOM, or -ENOMEM even though
dmabuf is already charged to new_memcg.

Second, old_memcg is read before try_charge(new_memcg, GFP_KERNEL, nr_pages=
),
which can sleep in direct reclaim. If another transfer updates dmabuf->memcg
while try_charge() is sleeping, cmpxchg(&dmabuf->memcg, old_memcg, new_memc=
g)
fails without retrying, and dma_buf_xfer_charge() returns -ENOMEM to
userspace even though charging new_memcg succeeded. Should the cmpxchg loop
retry with the updated old_memcg (and treat old_memcg =3D=3D new_memcg as a
no-op)?

> +
> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> +
> +	if (old_memcg) {
> +		/* Uncharge old cgroup */
> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
> +		if (!mem_cgroup_is_root(old_memcg))
> +			refill_stock(old_memcg, nr_pages);
> +		/* unref from buffer - buffer keeps new ref to new_memcg */
> +		mem_cgroup_put(old_memcg);
> +	}

[Severity: Critical]
Could publishing new_memcg into dmabuf->memcg via cmpxchg() before calling
mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages) lead to a use-after-free
on new_memcg when two DMA_BUF_IOCTL_XFER_CHARGE calls race?

In mm/memcontrol.c, dma_buf_xfer_charge() holds a single reference to
new_memcg that is transferred to dmabuf->memcg as soon as cmpxchg()
succeeds:

Thread A                              Thread B
mem_cgroup_transfer_dmabuf_charge()
  cmpxchg(&dmabuf->memcg,
          old_memcg, new_memcg)
                                      mem_cgroup_transfer_dmabuf_charge()
                                        old_memcg =3D READ_ONCE(dmabuf->mem=
cg);
                                        /* old_memcg is new_memcg */
                                        cmpxchg(&dmabuf->memcg,
                                                new_memcg, memcg_C)
                                        mod_memcg_state(new_memcg,
                                                        MEMCG_DMABUF,
                                                        -nr_pages);
                                        refill_stock(new_memcg, nr_pages);
                                        mem_cgroup_put(new_memcg);
  mod_memcg_state(new_memcg,
                  MEMCG_DMABUF,
                  nr_pages);

If new_memcg was concurrently offlined after cgroup_put(cgrp) in
dma_buf_xfer_charge(), and refill_stock() uncharges directly (for example
when nr_pages > MEMCG_CHARGE_BATCH), Thread B's mem_cgroup_put(new_memcg)
can drop the last reference and free new_memcg before Thread A executes
mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages). Even when new_memcg is
not freed, Thread B decrements MEMCG_DMABUF before Thread A increments it.

Would updating mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages) before the
cmpxchg() (and reverting it if cmpxchg() fails), or serializing transfers,
avoid exposing new_memcg before its state update completes?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-v2_2023012=
3_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com?part=3D7

