Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A716606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJWzhgAC
Received: by kanga.kvack.org (Postfix)
	id E781C6B05B6; Thu,  5 Nov 2026 06:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E9B6B05B8; Thu,  5 Nov 2026 06:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D689E6B05B6; Thu,  5 Nov 2026 06:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B12FE6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 434931409B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:03 +0000 (UTC)
X-FDA: 85400800926.12.65995EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8F095C0009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJWzhgAC;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877121;
	b=YiRAvk1auTfmHZucGj33BhhnEBGgcDHZtI8i4qPfdbAeXXUX4LKmnBkks8asRMFTK120vG
	Mc2smV3qAtrZ2re6jTPO2nBQnndYMCZD7eqeyXz+yJin5xC7nHWHYT2ismEeWqbqiiAGDG
	r5E+9Rc9nZ385ZZ1tSLhLyyOy7uR7ds=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJWzhgAC;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877121;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYfDIMn9RzkoOerCRsuzNDWKhLeLvHeL9jAZyhrpQ1o=;
	b=RRMvfdQ94elUbyJr4/i7hdNrN/rm7OR1fTyBVXBUwLM4a4rcOospUNiPqzADfaZc2hOpkX
	Am8viA7yf95V1CwFfJh5XjjdOUcXFee3um/9KqDMdUfqjOy7vUZhMIJp9QLTHetRKih9hm
	uT5rnxFZhv26Jir4l0GQI9C4zkRH8xM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AEC4840431;
	Thu,  5 Nov 2026 11:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12A91F00919;
	Thu,  5 Nov 2026 11:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793877120;
	bh=XYfDIMn9RzkoOerCRsuzNDWKhLeLvHeL9jAZyhrpQ1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iJWzhgACqO8Oh3sg03HVyCjyDRqS/0Kt880riTR9yqMxOzYkEHCrqPSIFOkv9f/hh
	 msR1KBHibiTLGBB9lFfczXDQTQIg7siuiS/H9s7ZO4h1RCevWVb/AkbQLYdz339fZ+
	 5TOS+Z2LCW+KisR0sqsGOL8BDOM3Y3KdTqb2nOSAznmJYsxiGkPcnbh2Bw5HBAWtYy
	 XP5SqcwLl3zSMCE7Y1FY9GWV9QwsTuYBPfhFQhYSuwSQSIgYrdqLB5w5SgLmMyxeK/
	 Mmjt52tv1l3Fg3yrRpcmpOMg9/ijrNbxtM7os5PorcJoiY10Lhz9Md+kpBwrSpxkYH
	 aZg86Vo2dk+nA==
Message-ID: <sashiko-outbox-198919@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/8] security: dma-buf: Add dma_buf_charge_task LSM
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
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, media-ci@linuxtv.org
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-4-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-4-1819a017000b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 11:11:58 +0000
X-Stat-Signature: ybostjk1a7bh7zhet418yowthcz839ku
X-Rspamd-Queue-Id: 8F095C0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793877121-785035
X-HE-Meta: U2FsdGVkX18FNlZJAYevsTMQpMsIMLM1ucaNwFyHjD3G1GZ5oQHATLoSzK0na890fdL5EoZPVai3KqTb41yoPBAH4rJoQ8Ok1jR1FgaQw+i0LqOZWaO8zBz/ZXObVWcTQgZ5UJKsqu61Ks1AqtVq14Ew4A9LHcPw8LRQ8FysdrzOHXVrI28zVGYkFOclMRYuEaHLqlbPqHWExtQp7A2eeDjntfOOkIryvZtU0YnybwsopUHyX/bYoMahW7ElvmKv+8yf9UsFNFY4AGHenMVVdqhoiiQMaAo/2iKPEuezj+5oU4jAK7+SXYd+KTeyrAHT7SjoRnpWjifnWtN5Ckr354IbeP7falymD92NrpbZ15GGkZBdMHJEcxTUCghmwGAcwk7T/JzD4lVsYzOgYvQg8qhvczEh1Ye87wJqwK9Ko3WUiSf/jglLuxbr0u7UfctsaoX6l1d2d4p9n9+swuK1AhdmSvKhPHKrOyfpImy3ZXrCu41xQt7fc87sLoov3gv28SqGpUvC0EIvGMxYGveOPumyr3XXeaZeL0AoA8BSghvScJ/e90mWjEmQv0A/VyPfAq+JqJsODq2+prH5avoLRamtgp6run7ZG/hTw3TCS96dn6liqQ51ZSuh1CoAF27sxlW0KksBDhKSDeqWfWSE41aBZFfSXpSEnU79RLWffQeVKISldSfuYZvMuFWh8sqH6fzKL2zVLckpxiPJlSsOZ4gDjQnfQlWNp8I6qUxyTjcaeebpfRqACDrVMbxzW/x37yJ3/RziMSyOqTIqatT024JzExPsF9pJ5mh90XZC25tcrrf2TaVYvHmiWWegaNwThQtHj6zL0gVLOy89ISMZCtmE/rnZDl/M9p/bPhNINDpV6SMMHuzT8lApSf8O0EPw2nwTFw0tgJrGQe00xuZCZTc6ciAqeYpUJwnaodYiinAXcpeJnCSfmr2BXtSxUPr1Y/qATs7t3yczDr+j3/Y
 lUw4HlTx
 defsZK3C/ynKHckJedw/GRN5FppPe5a4MXdQry7AVYpDrlxFw6Y/tFTJKSFomc3ArZDCn6AFKojz1VYtBG3ZskxGyZBcYLMHJGFb4zZFX374zFz9537fLVzu+47W1sax/obXZNUZcCIviz2Jm1Wtbc0HVj4CTYAvYAj823TTQymTr5sSm+R268ZjKfja4j65QQLaNYTe/ktrTuJTF0zwqOhjv5iPnCPMNflyer0KFEcg5lxwMEMQo8njNPkafn5hDKHiFuR09NYmWPNTJsWQ5gx3Hvv5y1/dmc+GHnEsOvwlnZ0XcwrAF07dQFm4478ZL5MAMud/u5CNHkLdZNKjpSjqgmJtMUuHE1oN2/Azg5zR4MGa6MOuMihgRbeHAL0rO0OizMwiIF7KOUdvO60vNHG7eqdjdU9AeVxrVPgTbXc0dhHF+fplGh1tEmEI2sRDwQ5KUJfRJFcPdKARnyWYcNIm8naPjYdP6K+UDPeaud+2HaofS5uv1c5QKJiieE6d9AW4rAqV0NhkKK+qTY4U4Opal7q7gO2H/dlmg65XREh99hNZI7V8orMhKzffeiZGMvXMO0ohNTn+n67M9kdYuki4nKd1+Y9SvcEFlUC2IDk5f2FXjupJIJ4J4ZwVmDGPr2nb+yEuDW9hFGnkE4ftyQgh4FNQZE4g9WDgllh8cpFDKf0xl+BLg77D/IJBDsqkaC0sx40Q4HdWKhB2FVwvVhsiakW8VkZnnjvMfgTMkw7jd4oo=
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
- [High] mm: memcontrol: task cred and mm->owner mismatch in mem_cgroup_get=
_from_fd()
--

commit 8654d1fa67f56b32794f6b84163f6fcd4bd83d11
Author: Albert Esteve <aesteve@redhat.com>

security: dma-buf: Add dma_buf_charge_task LSM hook

This commit introduces the security_dma_buf_charge_task() LSM hook and calls
it in mem_cgroup_get_from_fd() when resolving a target cgroup from a pidfd.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3e717b5663c82..dd276e1230cc4 100644
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
As reported by Sashiko on v3 [1], in mem_cgroup_get_from_fd(),
security_dma_buf_charge_task(current_cred(), tcred) checks the credentials =
of
task obtained via get_task_cred(task), while the charged mem_cgroup is then
resolved indirectly via get_task_mm(task) and get_mem_cgroup_from_mm(mm):

mm/memcontrol.c:get_mem_cgroup_from_mm() {
	rcu_read_lock();
	do {
		memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));
		if (unlikely(!memcg))
			memcg =3D root_mem_cgroup;
	} while (!css_tryget(&memcg->css));
	rcu_read_unlock();
	return memcg;
}

If task exits between get_task_mm(task) and get_mem_cgroup_from_mm(mm),
exit_mm() clears task->mm and calls mm_update_next_owner(mm), which sees
mm_users > 1 with no live task using mm and sets mm->owner to NULL:

kernel/exit.c:mm_update_next_owner() {
	...
	WRITE_ONCE(mm->owner, NULL);
	...
}

In that case, get_mem_cgroup_from_mm(mm) falls back to returning
root_mem_cgroup, where try_charge() skips accounting because
mem_cgroup_is_root(memcg) is true. Could a confined process fork a
short-lived helper child with matching credentials to pass
security_dma_buf_charge_task() and race its exit to charge or transfer
dma-buf allocations to root_mem_cgroup, escaping its cgroup memory limit?

Similarly, if task shares an mm_struct with another task via clone(CLONE_VM)
that has different credentials or cgroup membership, mm->owner may not be
task. Could security_dma_buf_charge_task() validate task's credentials while
get_mem_cgroup_from_mm(mm) charges the cgroup of a different mm->owner task?

[1] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
3-78d2c4cb8647@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-v2_2023012=
3_tjmercier_google_com-v4-0-1819a017000b@redhat.com?part=3D4

