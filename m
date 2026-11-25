Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5C5606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7CgCBaT
Received: by kanga.kvack.org (Postfix)
	id 767B66B0A03; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E6E6B0A05; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654236B0A07; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 375DC6B0A03
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:05:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A9FD1C4A21
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:05:30 +0000 (UTC)
X-FDA: 85473662820.27.8A90BAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7206E1C000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:05:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O7CgCBaT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611928;
	b=2m6w7LSwwXEzB3yRm/mUWzaoFWVaILPDv6PCv/hDOWqaKriDVY3egzPYYsJ5uxpL0tU6xG
	d962/RLceleViMJzQIFJ6cqjJunsXSEbMsWcGywsOKyCy4myJvERbaBYiFishJQ94jH5Yk
	3itE08ca4/0rft5gaVr0iSfJAPaAH4o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611928;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mk8/GrdShzBimqotJLwmFPdZ5k/yU8pDK1zQzPphDwE=;
	b=OnYKPfydtH3YlNx337NdfAD0zAflTz6LwsggL+/6CetNZI0HQw06bODvTyfd8r2O3Q69BC
	7ub6/zjfNmSljJcHMi3wFNhzjXIr546Ol2Y9IRQoN9v0on1u5eK4mo4ZipCbQf385HC664
	IJfCn3Rk293zSUm9Z+xlWPWdOixJuDc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O7CgCBaT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0094460DA7;
	Wed, 25 Nov 2026 13:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E65F1F000C0;
	Wed, 25 Nov 2026 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611926;
	bh=mk8/GrdShzBimqotJLwmFPdZ5k/yU8pDK1zQzPphDwE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O7CgCBaTStMB4v1DHVH43pVcRsQYovYl0Zz21echw/YbsR9o2vyApTc95kjPxcrwy
	 S2FzqBpCClDMF9wNZ/Ew8c5qFKJrr+QzSjRt0v5GRpuEefLzYP+9pSMSiofX3su4uj
	 XPlTKPfIcFa97GGBlZhso19bbpFvn6mTriSpKdORjSj2n+3jPhBolSUjsHSC1IcPU8
	 +OL3Mb7QkfBN1vyPAo6fyqfoLVQ+zclgNL6OQSqOk8+l5qdm0dlHjGUW3Qqg5WYpdR
	 b8GgxvNGAt8LNwKw/G8td8mkfZ/iHRMuG/h/QZnQV3x+ZAxvRsBq0nXwPVY4YySt7e
	 SMZOtPVstK1xA==
Message-ID: <sashiko-outbox-233444@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/7] dma-heap: charge dma-buf memory via explicit
 memcg
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
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-2-dce12fa03ad6@redhat.com>
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
 <20261124-v2_20230123_tjmercier_google_com-v6-2-dce12fa03ad6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:05:24 +0000
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: ta6ckx5ooigt4b4c9p3kkxp8nb5xmi81
X-Rspamd-Queue-Id: 7206E1C000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795611928-141780
X-HE-Meta: U2FsdGVkX1+hGNr2gk2K+jWnJ1iA/CxysH8braX470Fv3PVoKCAriup8uM+HGRN08qeoHr/Rs6D64CPjSRkYpWeCEVzdLcX2w+LA2EdYKtHjruL8qDp9Kd5gwx4/OePXxM1zKZtsEo+1wnwQsCnNzFUiVR+TMhIADnHyLnTkW1oaR+yQQCUiBPlKATrW/YMAJj0eto0rOC9oNif5+OwAonAfhLAJ9VTU3f+K1P6XC0/oqFWOi6usEA8QpT5xApdA6h7bL5fP6dEURLU3Gq8u6js9Kj4cdU4EiI28n4X2zBpH9l8hN/V4tvWdw8RSEYQQF3ruS4eLoTXkaY2nFom/jNz3XEXxPmaiXQmjbNo4QS77akh7s6X/k3qQlft3KJv9MPlbHs9HJMiRmvJ5trfzV6HFNNpyhqC5+uLkJKGUSfHWFV8ESmYw5MhHrRcUZ48hAOuG49iBjAOXDkI52JpExywucVJvDrSR8+cYBsgG+1fTwfov+QgALwM9iPhFZht6Rg1yVP8UvSxmhc3O0rhsxD25/CygXdugS8E+cCZC1oXn/76pJLMokNkAFDqjSMyFb4lo2MyYwd8sB+K5QHDga3ih1P6lgGEsZAZe3ycty6vAIr3RRMVjz5M/Qba47wSkNgpYwXXBc7+vUYqQB0NNe+yfOI9t+RD/8sJcDnuiA2vgR2hwfyDfFrTBDu31I6ETW0VE0+7Pkaq6Vm+fGDgv0//SQivHAdd9mgGG7XR2ou/Tv1PA3ekule3y74vlqVap//ynDcWNOnvXAYy3Jh0cvIZC6VvaISzRfTTG2myY5zSza6EtjBA5JB6IQhqZNn0Geo3wJOH+IE0h37rdCJ91Fosewo2xvXbC/lkXw6ujQOVG01gfQMFpVXGZTIf2ZJn0QIEM3swpJQq8oZHFX42oQqE7zh2DTJRzo/viEpf+GdOhZ2LBPVi3hdslGwAvwTz+ehkrXWtsFNrviKU4K2d
 6pxZ5Rrl
 bc2EWQTqAlY46FHBT09PH8e5lad524OMoysYKIwFKrK0nojs2Vwm5xQlgQ0yz0tBlqV4V6NF5wV3ougYVpULs6Qi6V2Jj4zT5VEwXA+SBE8NFRj6DNr82GTEOl9mRfnMgQSWW1KVeZwEy+MCmITlpAyRhIb8nxpt6bxz5rbTH04pREVklSVcagTcz7+Yz4og4EnyVG5peSVKdTIpPwJqJsiUQHZ3/DKO63SRF+rxS1zVE560gKdbnWXm5dKxkXq5FbasP094FdXXmvR0VyeFh/lGEXHKGrPaDmP/M3WKmJG3/alcrbLcnmJcCNox2WsXG2XsuXv0Z3zrBgoz/tv7+OtyBova4D/sW/0fQ5OWmTA/vGMl+8uRSeJsFrwHOFqECDwJR1ab7WdgbJ4HcmHKlAQj8ylsNHCBzfdZDo7Q/2dXSBPEFtSnOpEAj4yW4KwvKRIRlDsAJ3iF3y/orE4UpLzW+Rehow97jFHIENCs5tLmgjfEqFzMK3F484UEtz/03wEDpUBDU9WbbsBJWNal47Srp05fHyQMSXe6UywMSZDIiZ+q7zl1tUb+lggHHDfD+209qJ1a4CX0U+qTJ2bWdHk0cRIGtr4weCEg+5Jn+djqeNZpupuJB/xtLDVvGy3INjAWny/UJFSPbu+SAjdDXuIUHKeYEknFccYJxWUEGfNrjZLRUf3+LUPIX2DQCW+Xhgj+WBYxucJOHLjaOcgscXPoMKClgmcrCDRUFqdMakZEuu8sxBf0WtThGJ3HT/bs87RznrZ4dIASbAXZF6vGdEacgAi7Kcc2TrV6uLWRXQxhjR9ZTzp7uro4VxXMqhPyD/cESNrWfh5whtRomt1vwDgAWQU8+/4CFgl53RB2l8pTy+TlfiS1kdshB5bfT4ZLq6MaTBK4anm9/tBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm: memcontrol: task_css() race with migration in
  get_obj_cgroup_from_fd()
--

commit 62e5304eba9bb9d84f6229eddf1a9273649483b8
Author: Albert Esteve <aesteve@redhat.com>

dma-heap: charge dma-buf memory via explicit memcg

This commit adds a charge_fd field to struct dma_heap_allocation_data so
DMA_HEAP_IOCTL_ALLOC can resolve a target cgroupfd or pidfd via
get_obj_cgroup_from_fd() and charge system heap allocations to that
cgroup.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e4a9af2fdaa3b..7826bc21bea9e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[ ... ]
> @@ -3171,6 +3172,88 @@ struct obj_cgroup *get_obj_cgroup_from_folio(const=
 struct folio *folio)
>  	return objcg;
>  }
> =20
[ ... ]
> +struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct obj_cgroup *objcg;
> +	struct mem_cgroup *memcg;
> +	struct task_struct *task;
> +	unsigned int pidfd_flags;
> +
> +	if (mem_cgroup_disabled())
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	CLASS(fd_raw, f)(fd);
> +	if (fd_empty(f))
> +		return ERR_PTR(-EBADF);
> +
> +	css =3D css_tryget_online_from_dir(fd_file(f)->f_path.dentry,
> +					 &memory_cgrp_subsys);
> +	if (!IS_ERR(css) && !cgroup_on_dfl(css->cgroup)) {
> +		css_put(css);
> +		css =3D ERR_PTR(-EBADF);
> +	}
> +
> +	if (IS_ERR(css)) {
> +		if (PTR_ERR(css) !=3D -EBADF)
> +			return ERR_CAST(css);
> +
> +		/* fd is a pidfd */
> +		task =3D pidfd_get_task(fd, &pidfd_flags);
> +		if (IS_ERR(task))
> +			return ERR_CAST(task);
> +
> +		rcu_read_lock();
> +		css =3D task_css(task, memory_cgrp_id);
> +		put_task_struct(task);
> +		if (!css || !css_tryget_online(css)) {
> +			rcu_read_unlock();
> +			return ERR_PTR(-ENOENT);
> +		}
> +		rcu_read_unlock();
> +	}

[Severity: Low]
Can the pidfd lookup in get_obj_cgroup_from_fd() spuriously fail with
-ENOENT when the target task is concurrently migrated or has an exited
thread-group leader?

Between task_css() and css_tryget_online(), the task can be migrated to
another cgroup and its previous cgroup offlined, causing the one-shot
css_tryget_online() on the stale css to fail.  Also, pidfd_get_task() on
a process pidfd returns the thread-group leader, which in a
multi-threaded process may already have PF_EXITING set and remain
attached to an offline css even while its obj_cgroup has been reparented
to an online ancestor that get_obj_cgroup_from_memcg() walks up to:

include/linux/cgroup.h:task_get_css() {
	rcu_read_lock();
	while (true) {
		css =3D task_css(task, subsys_id);
		/*
		 * Can't use css_tryget_online() here.  A task which has
		 * PF_EXITING set may stay associated with an offline css.
		 * If such task calls this function, css_tryget_online()
		 * will keep failing.
		 */
		if (likely(css_tryget(css)))
			break;
		cpu_relax();
	}
	rcu_read_unlock();
	return css;
}

Using task_get_css(task, memory_cgrp_id) before put_task_struct(task)
would avoid both failure modes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-v2_2023012=
3_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com?part=3D2

