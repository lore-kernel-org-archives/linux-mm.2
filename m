Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF4D606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feIg5nbJ
Received: by kanga.kvack.org (Postfix)
	id A0C3C6B00EF; Wed, 18 Nov 2026 03:41:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3B16B05B0; Wed, 18 Nov 2026 03:41:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9EB6B05B2; Wed, 18 Nov 2026 03:41:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 744056B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:41:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC55040308
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:41:03 +0000 (UTC)
X-FDA: 85447594806.18.DA03AA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 582A71C0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:41:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=feIg5nbJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794991262;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdaKqlzukNksjVfifP64arAvMVrVLyE39e40pX+LyqY=;
	b=EOrTwiqn1AQ7MgYV6sYlzmygVGDc3FiiytrhsNAVFHdiVHJWojL1rLnBNlW0k/Xs8vO6GM
	XAhXlG8M0JiJgiveAhVSqMAv4Dp7I2DP7xDz6UaX3wC+aAk/SCIZgfKM29zw+Cyr+2PhJD
	WT23EPXgWL1uaFfn0LZHCEsBmTFAKsA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=feIg5nbJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794991262;
	b=rXrwh7WlWDbIcHTHxATbbq5GL5kr61kEmTkYxmyHMc+pGZwZDxqQ+rRJLduYx/SlQ3B7UB
	gPq4wljX6rLhvKfsZcThxTdjHn8FXvBJs1IKd0MO6/WrGerHI1vU82KN+T66bDmkxmaxGb
	fBSYYBa+VUHyojPmPgaG2EGC5B6qiI4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4BD561B42;
	Wed, 18 Nov 2026 08:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E482C1F000C4;
	Wed, 18 Nov 2026 08:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794991261;
	bh=IdaKqlzukNksjVfifP64arAvMVrVLyE39e40pX+LyqY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=feIg5nbJbO2b2EYanKLYw5Jz9X/ZlURQvCTbD7uE9fauni3bxe2rCTl2/yUzQyBVb
	 7N/dtTDt+OZdv/ucKM67qfnajtCQk5rXqLj3S/dzbkmVTnae8KwIxEKTtVE4iyHYNX
	 oiWr2uBh2obHcaWCHy8n2xa4Wr0CpRuRdjx6JuI1EUnt7TT016ncPAYdiSc8IxXSz1
	 LZjDLyZ8ZZqjpvZ/ZjHcGGfRDpm3FetVsbRM9EFQITvGcr3GU8DaCYPa8IWeisXr5r
	 YnpjKB2wbQ/D6KezcCLNv/azt+46FcmWceScj3Ed5hPZALEtiDZEQQCMPFbab60o76
	 5z/Ha5rErJTKA==
Message-ID: <sashiko-outbox-220468@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/8] dma-heap: charge dma-buf memory via explicit
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
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-2-1ce975f2a9ad@redhat.com>
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
 <20261117-v2_20230123_tjmercier_google_com-v5-2-1ce975f2a9ad@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 08:40:59 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 582A71C0002
X-Stat-Signature: xjy9stc469e1pd6r5ckuhpz58dcag6zf
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794991262-727657
X-HE-Meta: U2FsdGVkX19ynyVlkByRNQ/F+MxZbpXQ5fyh5mHN/Km3d7tKznD9/r08O11peylw7LNbZVFaGsW/U8WcfWdUgX/1FrS7GvjoS8I+io9aPe32+84wSc7g+chdl3XoQNmM7eBYgh33zyQeJyD60UalQ9an1ffBiGyQqEi4cheqVaY5lbgqLoqZPKSfPbmFcyvQyq3dKPMRrgazQ2eNc7uIXZgF3+RLBqM19Dmq6J+W3tRr43fMWMJkMwXaigYNmzPHztCYz+KqgWDeMGGAK7i6DsRDqqs5Wu01rwvFnEPfVjHBk9Q+rXhSj0ZzF2iNYd63gTD3rSLQQUgNdLQmvDsKOj/LNpl3cGPYQHD+OlHaJRJLkRQGdXu6zwMNhrZIBDFmfUjS7nsV4uFpz81TS+ALU9JdKsmTt0NqYh3x6Ex51QK8c0ZUjxp3KICWgjcwIA2AOIBShOnHDtJ2KLWT0NiPHMjiSt9P++08kpAtg53qXEb7PvXIFbcCoKeRZNWRloqNHxVo+lRXos+gSImhaC+BEjjuTcHu9Ss1HcmPO3iauGsX57XKDfCgBzUiJjBy2q2iwhE8aVKKijDBNOoya5PIA6dovWru2F7wX8UDvfvvySTwk1U8OBFisumeZ27NgVFoinYf+Yq5mYH0guVWoMLnhVSDloVKxjLSpdaWroiRsfZuL5xdGkUVpomirOpKbSHLa7Uf4OgXHxlicPeVHSIz+OzgpkcbFYW3Hn1oyGIxlaGwe7QNT7s4/9N2FNm2hcutoS0DEmgY33QbF4WccGH9FQXY6JHy0f75joSz1wvNpy7+yiPkBzmK8FDhqbJ3JGWbbmvG3UKu1z4DHPMPprh8jkvMdwiYXo/4uHgmCBItNo6Zm/g6Eph1FvaliCcOkzOlIlG6uNaHn0bvVW+9quGNPOIICOBJ84Eif3hNHyON84OO+fqxdZRnf34cU0kDiEKwpLFfO5F0mlPwxuH67WA
 S+oybL+C
 QEod89j61bWC5PCWgVIv0N2CtD+brkjB5M98hPan6VkwQfNseWXXQwiqQpzOkAJja6AnbsuPd/1fzZsa6+LgZEJm5cp1UVBTudFr3swGlJABhEXQAfihRsWjZ7io99KwqeYrpbXCecO1O8Ipi5SAKLl1UFEPXrc6VycA/Nk6iTJ688Ew08vl3V9I5GcMaGMp1w/ZAg/KEhRsTiZaYTP9jxzxBWiinRYxhcg0Gz7HLHrDspL5EdJz8Zn7LusmSUvXLj1Tn96GMgapxusvpHx1YCFtpesY7ydyPhr3TjFyoJh/ZyThmCWkwONoOX4CGxNo0eNh6kxYl8MrYWBWYT/xl/N2uwXHLyLRHeZX1E5uzg+xBgibfQT/lv78mvAZfcvfJQcUbUHrNXl8y30M5Nd0a8RQxpo0XT2foNfGhYz7XfAzvO8xTxP0TBrAMZhH8mwSrT49K8tVqHJiZ4e4PAuQ3NKxR8hL5ptUK/IbCBLB/EWairOmjPVhIvRImY+jBStweXe3cIxCNby2UArTUwA22Cat1iNW131Lzc9iQYxX/Pl7lRy7UyQqRIMJT6ywyMfrhnHlHq3O2w9S31hZy8a6kZ/kEi9iOoLY60KnTUOkT4TJP+H3ph6OE0TcAmPPasbvBCmj4EnBdRK1rqpYjtKwbqsY0TwxLadBQFLLa
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

commit 7e6b5f51c2c9a154a8386e2fbe69f7c3fe1c4a27
Author: Albert Esteve <aesteve@redhat.com>

dma-heap: charge dma-buf memory via explicit memcg

This commit adds a charge_fd field to struct dma_heap_allocation_data so
DMA_HEAP_IOCTL_ALLOC can resolve a target cgroup from a pidfd or cgroupfd
and charge system-heap dma-buf allocations to that cgroup's obj_cgroup.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 45e82cda7c441..adc0abcf80fae 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[ ... ]
> @@ -3168,6 +3169,88 @@ struct obj_cgroup *get_obj_cgroup_from_folio(const=
 struct folio *folio)
[ ... ]
> +struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
> +{
[ ... ]
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
> +			rcu_read_unlock();\n> +			return ERR_PTR(-ENOENT);
> +		}
> +		rcu_read_unlock();
> +	}

[Severity: Low]
Can this one-shot task_css() and css_tryget_online() lookup spuriously fail
with -ENOENT?

CPU0                                  CPU1
get_obj_cgroup_from_fd()
  rcu_read_lock()
  css =3D task_css(task, ...)
                                      cgroup_migrate_execute()
                                        css_set_move_task(task, ...)
                                      cgroup_destroy_locked()
                                        kill_css_finish()
  css_tryget_online(css)  <-- false
  return ERR_PTR(-ENOENT)

Also, pidfd_get_task() on a process pidfd returns the thread-group leader;
if that leader has exited (PF_EXITING) in a multi-threaded process whose
remaining threads migrated and whose old cgroup was offlined, the leader
stays associated with the offline css even though get_obj_cgroup_from_memcg=
()
can walk up to its online ancestor.  Using task_get_css(task, memory_cgrp_i=
d)
before put_task_struct(task) avoids both issues:

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

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-v2_2023012=
3_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com?part=3D2

