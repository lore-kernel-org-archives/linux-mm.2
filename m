Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697D3606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FGUhQnEI
Received: by kanga.kvack.org (Postfix)
	id 7F4976B05B9; Wed, 28 Oct 2026 11:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBDE6B05BA; Wed, 28 Oct 2026 11:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709C86B05BB; Wed, 28 Oct 2026 11:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 418636B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:04:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC7D11A011C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:38 +0000 (UTC)
X-FDA: 85372356636.13.4B4297F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DABA2A001D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGUhQnEI;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199877;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7gQDIGtka4M6gFdPtyAUJTEmbG7HdtUcr2lveZNTbo=;
	b=1CvXmzA6BHSxtrASwpeCMfnmV96b+EmpMYF3T3rWG7tAyYHQhUhdqnE2JApCdXPkCIIROA
	iz7cNC9nQB53coWqbTTKwH/Mpq//7N+7GLkvNQ4+A9yMnjjlLDJvZoGE8xlX5jAopP/iPv
	Os6pJFnqjybXhVJPjTRYtmBWBpn2WAY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199877;
	b=VGLWXYtml5dj4BqSdfMePSobBvaNhQjMC7JPXDPIjl0IHwdqZfYrjnUJ2ldiS0HDf7cIFx
	HU9F4J4uDY4v1pXZ4tQ31ClLHFFEzjqU8izwwsiXyodMjvocd/HaY6HXc910Q94Wbcz3v9
	3uT3QKoY/tskr+zrLGnytspxD8mNvcA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGUhQnEI;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BD55413AA;
	Wed, 28 Oct 2026 15:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412E71F01828;
	Wed, 28 Oct 2026 15:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199875;
	bh=C7gQDIGtka4M6gFdPtyAUJTEmbG7HdtUcr2lveZNTbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FGUhQnEI+RbAgshoSt9xu8P3vWredhcl377LgGwqtfoX3wn5xpg3pFBp+vxuSigfm
	 ZayPAsFGhzsDUdUEZHH3n/ZhwRISu8XF1pC0ItBWCTnESEGavXhgpgzipXn+EHWzvQ
	 Akuj0EKJEF9R83wVj8+keQjFL+c1V0vGNwZ/SI7OJ3yi5fEcgHKlzbAm/dgigrMGLw
	 1oRjmNabb4Bn0U6x1KMQbbSfx9YiCqrKV3gap5VEtC9UrJDcQnX7IYDzDDpo5VqXDQ
	 /gY6sk0QmG7CG5UwE26nMddVlxPpf3Xr3adyn8dxs46aPGhX8nqIGj7nsC4V+pmzhc
	 3fC+wcXctU+gg==
Message-ID: <sashiko-outbox-188028@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/8] security: dma-buf: Add dma_buf_charge_task LSM
 hook
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
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-3-78d2c4cb8647@redhat.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-3-78d2c4cb8647@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:04:33 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DABA2A001D
X-Stat-Signature: uifyan1yfmq3noj596jqz9jsjznhywhg
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793199876-133390
X-HE-Meta: U2FsdGVkX1+PitDntXxLWCaZ3PCsGp2/U5VYF3Ww3PM8d/T+xaoimltazAlXdPdpuZUfxhvowqm1UKC5lTIUu1E19zdAE2xfmcseSuWtZSuafBOIZ/wZ5A8xqx3J22a2tSsV/+5I7++14UKUUliqf2tWN14HbXJKzCObnf3UUMfD2DlSwH/sHYVG49Gjt3FSt9LMo0pLS5+dmZTvZMeyxamMmxQLfx5YFqC6/r06Brftv/rC0nKxDpCYZQSBIZ88InIIOcBiYYe2v7JKQ25kZJs+Gv54Calez8XQakJ2eBFb2jYq+FxfucQ1PTS20oNhVhXDaaGxDkiwSk0l+ub+W36+LhES7BTqimH79FrT9bWDgIPpsLJ0k1Och9NOAgYQfrv2YpEsh5nhz21PIr2u9iDU//6CyjfZtGRV+ZB376fk/E9g4vfOCOiDcmmQzSSHuhrfxSSknGgTDTJ1rYW6USC8yYsRoTxmuuvdEqs5FSTT00oZDcTZpYSJOS3A89RbwW8gU+aqGEdIWTpqapmVrxDw2CGLf4wn/OExmR2OWTt1DKoFW7UJ/SrdyOMcAfp8I+e3RH18tp1XbXRBLUQIJ5Wgx/3bOW8/paBx/V5qip9juVsriATYVQTzU+1w1DWdPTKQw68m7TPAMGjkXU978dy60DRBu3Revmu+O0+2tCLCqs2hqxAgMLKXOk3Jub2IG2Pkjx74O0LMk76kZZ0tt2azt/BKHTs9sRFx+yLFhDUnTdspAM7is2FRbsUGt+90iEaPMGWYDFxRk1lrGVhoEJPaq8tkPDEI3xl8Z7iM/aX9rS/5brJTgK9z/RhjPlA0y2jDvULxC8zklJlkHgAFra3eIOGwnqqE/oB5sb3T9aZuJW9d9SLsWC+UmK6RFlE4oUTzhhrvGwx7aA6qaqTEpav3y33KR4Ey2q/VziRr/WcHeIaBs7jONB9t80MmtbRtiWw0wof3LtBcMl42tZn
 GNJSv2gU
 4IGD7blzYKhsAHI3STd4bBRTUHhDzjWXnh+4+eVXhxMZ//NiVDZcFWiMPlUPPCbzHNc/UHHytDDEiNi+5xqEncn1oB8qPxC3ziWXh6eDuR6YkPSZ9bGq2DXXX1mG6dxiv+sbphImhnTndXMRt+64cJJTMnr5+kTy6eo9zU8BZpfDPWiXs2Uelv/A9u/2d5GqYVUhltPWg7LPjABpyIQ4p/A3HNropk5SzBO4QKv1B5LMwAwz/1FbuSufeUTSpgyiBIiRSvnrgBHwHunQp1GB+zHIU946L32p9uPbueMmh/vM07SxvC3PamYvjo3E5b9esaGNabBUjQpouqde+MkekeEdQ2H5EkUm6YvckHVY5EIqZ+1sNLp2IOJcaMD7kWux7RrKtn2rHd7zD3UtdYKr7G3fpry8PviRMiDJQVqUNpUWsHBv1HVt3+WiDpiZzo294nccPJOkdhTEhxLDpFXkCWB6G80GZv9tqSitcUpP5uVi1mQy54T5b+9D9Y+4llNOFQ0OToq1qbf+zGNNVTtk96/zosSp48dWbn4BgLTJPGL8EXJzaKilVXqMN/cLDVcJFwbFJ6I+T2SSvOIPKwzQdRPPT24A5vvYYGCx7rtFjASVAKMnU2eH2aBt0DYaH/MTcjs1ghGGcAj6U27Xn5ec0TCj9K1GUG6a8A5SmcWbTHNrgziB8pExkTNGh0Z7hGg+4rtV4gE1JhXJLRYBW+RhNSQHnUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] memcg: task cred and mm->owner mismatch in mem_cgroup_get_from_fd()
--

commit 6c6031732d7f42644e3d99679d750fcc12907447
Author: Albert Esteve <aesteve@redhat.com>

security: dma-buf: Add dma_buf_charge_task LSM hook

This commit adds the security_dma_buf_charge_task() LSM hook and calls it
in mem_cgroup_get_from_fd() when resolving a pidfd, allowing security
modules to mediate cross-process dma-buf cgroup charging.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f66254f52b999..ad195cfd1b5f6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[ ... ]
> @@ -5698,6 +5701,14 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
>  	if (IS_ERR(task))
>  		return ERR_CAST(task);
> =20
> +	tcred =3D get_task_cred(task);
> +	ret =3D security_dma_buf_charge_task(current_cred(), tcred);
> +	put_cred(tcred);
> +	if (ret) {
> +		put_task_struct(task);
> +		return ERR_PTR(ret);
> +	}
> +
>  	mm =3D get_task_mm(task);
>  	put_task_struct(task);
>  	if (!mm)

[Severity: High]
Can the cgroup returned by mem_cgroup_get_from_fd() diverge from the task
credentials checked by security_dma_buf_charge_task()?

Here security_dma_buf_charge_task() validates get_task_cred(task), and then
mem_cgroup_get_from_fd() resolves the target mem_cgroup via get_task_mm(tas=
k)
and get_mem_cgroup_from_mm(mm):

mm/memcontrol.c:mem_cgroup_get_from_fd() {
	...
	mm =3D get_task_mm(task);
	put_task_struct(task);
	if (!mm)
		return ERR_PTR(-ESRCH);

	memcg =3D get_mem_cgroup_from_mm(mm);
	mmput(mm);
	return memcg;
}

However, get_mem_cgroup_from_mm() resolves the mem_cgroup from mm->owner
rather than from task, and falls back to root_mem_cgroup when mm->owner is
NULL:

mm/memcontrol.c:get_mem_cgroup_from_mm() {
	...
	rcu_read_lock();
	do {
		memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));
		if (unlikely(!memcg))
			memcg =3D root_mem_cgroup;
	} while (!css_tryget(&memcg->css));
	rcu_read_unlock();
	return memcg;
}

If task exits after get_task_mm(task) increments mm->mm_users but before
get_mem_cgroup_from_mm(mm) runs, exit_mm() -> mm_update_next_owner() finds
no live owner with mm_users > 1 and clears mm->owner:

kernel/exit.c:mm_update_next_owner() {
	...
	/*
	 * We found no owner yet mm_users > 1: this implies that we are
	 * most likely racing with swapoff (try_to_unuse()) or /proc or
	 * ptrace or page migration (get_task_mm()).  Mark owner as NULL.
	 */
	WRITE_ONCE(mm->owner, NULL);
	...
}

In that case, get_mem_cgroup_from_mm(mm) returns root_mem_cgroup, where
try_charge() skips charging via mem_cgroup_is_root(memcg). A confined
caller in DMA_HEAP_IOCTL_ALLOC or DMA_BUF_IOCTL_XFER_CHARGE could fork a
short-lived helper child with matching credentials to pass
security_dma_buf_charge_task() and race its exit to charge allocations to
root_mem_cgroup, escaping its own cgroup memory limit.

Similarly, if task shares an mm_struct with another task via clone(CLONE_VM)
that has different credentials or cgroup membership, mm->owner can refer to
that other task while security_dma_buf_charge_task() only checks task's
credentials.

Would it make sense to resolve the task and its credentials from mm->owner
(or look up the mem_cgroup directly from task) so that the LSM check and the
mem_cgroup lookup operate on the same task and cannot fall back to
root_mem_cgroup when mm->owner is cleared?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-v2_2023012=
3_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com?part=3D3

