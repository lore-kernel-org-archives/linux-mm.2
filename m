Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643A8606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAiB2BDW
Received: by kanga.kvack.org (Postfix)
	id 66E566B05B0; Sat, 21 Nov 2026 20:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645D56B05B1; Sat, 21 Nov 2026 20:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B4E6B05B2; Sat, 21 Nov 2026 20:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31AB26B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:57:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C257140634
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:57:07 +0000 (UTC)
X-FDA: 85461092094.22.82D1EF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id ECAEE100005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:57:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAiB2BDW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795312626;
	b=zA3E5/xBet4UikExRI5Nn6zgSWVwnRxCjWZdEirhNjNz/BEurzA3aDTDPdyXcv+nHrOctE
	LN5vUMP5uZHLAX2JFheXsxA9GFVYQ7QBbDmWup2dScfH+D5f4LqqOZUFs0g1WqgfApbVcc
	QbEGW3aYCPm8aZ6zDZUhflBF3h/092I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795312626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/FyTmAO6EftrsMjGyxjzlp9mWuafpHrb9mW48T2Oss=;
	b=G0gA80o/6SdlqblbtK1vljrqGDbPxuoEeBU5/JfC/JgWtHNFbO8pwlygEzhiWIRrsblF3b
	G/mGGyZSzG9J9F1imVIbwGpnK6bHCpbuOHcLsHrmwfAolClWoyayrM5vrKL5+iwyzhguc3
	VMybrwHqhc946moWNCpe2uVInxELSyk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAiB2BDW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 821D160EF8;
	Sun, 22 Nov 2026 01:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20C01F000C6;
	Sun, 22 Nov 2026 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795312625;
	bh=6/FyTmAO6EftrsMjGyxjzlp9mWuafpHrb9mW48T2Oss=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LAiB2BDWU3KDfnCXLYfa7ih/CTFK11tTVZY3+hcQ/8vJmjiSoq/EV3Fgt7hrC/RwN
	 +EqFbeoqKBYoGn9x471Yg5WTU7aY5g9GaaSEAB3NB2KflPUI5KhBRuyCsEhd5qNQLP
	 FoUZPTG9ZHGlbSGQoFSZSRGIgo9FUgvcF+qWFzrw5lnwZs86zK0kAG6+8hOTAaEf06
	 sAS9sL/Qw2Nmb4LR5oTfDBR5Sf9b+shshushM71J23frttECA+gOdPvLONAVYmyXhO
	 satqdnxwF+LliRSVYYpzkQ8NJpepILIsfD5r6Nliu9SfNY85l+4YcgAEAEOSkN367Y
	 VPkKumdQpdPrQ==
Content-Type: multipart/mixed; boundary="===============6512166407887190360=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <3aca9b48a99eea17865184e5107f26499594cb8e7cb05923abc9cad098e24c5b@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-2-jarkko@kernel.org>
References: <20261122011809.2667684-2-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 01/26] userns: Factor out idmap validation and commit helpers
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 01:57:01 +0000 (UTC)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECAEE100005
X-Rspam-User:
X-Stat-Signature: f7uex5pjrsnrjsrjnobp8nrkkma7fbgb
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795312625-363842
X-HE-Meta: U2FsdGVkX1/ZxGFYOi4R84qnWpnDOJ8NH3FzbRncA4yRNfh+ijx9KXpwMgHujkoujKJnp7nX3jYNXuOMSK/AHjjviTLUQnBxADOv0tF4A3rJojbDyJefADefTdRhAbWRgOtEyB4F+7V1YabLJZSjsjyrUEr/D09KGVQcO0nK76M6UN6iSf3KcDmwzbiBB2/1kDWFOzkcJvrUCpo0z654Srwy28UhW4rBYamjsF9lRjxNe23k8+YhNkE0Z8uePp0lQejyQDZf8NrnzPp+BoSbGq5v7FLShBHuGAMay56LtBk+L9BN8bZTYu0PgAOtJDbFoqtqEyICCgIihVtRl/sNL9Ur5y1mBgQaHP3qxNnXf/ENi32Tpqst90HdN+qXrvK1uhn3KElSlucdUJgaBVvhRt2Qn/nvKaRpm+MyCOl2WwMnoDFUY93sLzB/7Xrgk0u5BwUWQMn0ixnc3rCtNgh0IVB9M7Lpbe2/qjkXdR6XQ+tDKkvdfe7Het5pT53Z3LeptwgVLDizGHVX/4AfnI2Vb+nFhxqrV8ep4EKvV7fcCMKyX7PzUVFHGxITbPkeVmQmNeRcR3sH8MLq56ukNxfeP09/SPIL5Uqgc5Qke05bZuE7ZNZI9Hldf/pHGcv5BXMmFsqSJk3hYJcS7ycMCtCUp3KGmoYDwpmPSUO6V4NU+oybMhS72qpRP+oyEGJ0sL5175Zi0us+2Jhq+2g1PaxwwJWAxu8L5O7VQ9Kp9TA26UpHHwtJeMW9GeGEV4YENge5QtMx1CK7NY8ZWImqD1eD/twSlUEQV+a2NPoSe2fi63sIKuS9DdJCeUGNucRDnj9QwvfOE+UxI5PYgw0HR8UReDH+dOtaEzxkTGeaGl2zxaONOmwn1QaXeb3ThoqLYCkosez+fJj58hT4MpNBJN5XuI7BiFfeAyGcqR7euyDlg+ztVI2qrK37pVFvOSkFulThKrD6tcWhIijdhySU1dd
 54hKT87/
 gxdqcVGUEWCkZvzazVjWn1sfQs72XUk/usmveIdMB+E+e/b2WHoGgX8Z3s7gybHTRlwjTK+5xd3O0/ryQ0wvIIjvMgle3lABkuqC8FWxcWRNvzUKXCQk7mn2V7A+PRHtP7XMWAElsUMQwnqUY/B6BUphVacdf31+7KrsDECjAr3692DUBfIqWi5aoH/v3CaSb+ftLlhnJh8H1I3dyHe5WXUabFxREeL76EwyNWL4GCQrkBTVnFJeTyh2EuAt+pISNMNnUhG1RJ5ta1I52hOiKfO+bXs27VacqhpWnywtY4iPKDcBkdtDE3lZXdgumcss3XQ6s7Ecurs0L/Fm43JTWcP2cL9j8b89rYfRiJ/LcA/EN2X3Z50cWcVmwB2GQZ2p03sXCV3VIw1zQwBrfbdK+Am4YkSeNxhvy2jVFKePCsIZODFVjtjwjGj6j/tf+x6jwtQHlA2nixNrOYxEj5bPklkPXh9mwTnM2g4c1YCLkvaGN5CfyJNIZgTpFSD8VMfihXLtfWQewv+Dr7ww5GFO1655o1ls+KORN9oVXqkvBTBM0HHYEfZiZkUHwK63QrG8L9b3ZEiz0k0696Hv2yc9TqmgMAPX5cb0OydBEZBk0SGkGB0bY1Qe4xhLkTJkAhBBDIhFf358eMxRqaMkUjUmwUIoDBV77azOMl3XBgusMmOqOTMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============6512166407887190360==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userns: Factor out idmap validation and commit helpers

TL;DR: Nit only: the smp_rmb() pairing comment in commit_new_idmap() names
map_id_up(), which has no barrier; it should name map_id_range_up(),
map_id_range_down() and m_start().

> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c

[ ... ]

> +static void commit_new_idmap(struct uid_gid_map *map,
> +			     struct uid_gid_map *new_map)
> +{
> +	if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS) {
> +		memcpy(map->extent, new_map->extent,
> +		       new_map->nr_extents * sizeof(new_map->extent[0]));
> +	} else {
> +		map->forward = new_map->forward;
> +		map->reverse = new_map->reverse;
> +	}
> +	/* Pairs with smp_rmb() in map_id_range_down() / map_id_up(). */
                                                         ^^^^^^^^^

This isn't a bug, but the comment doesn't match the readers that contain
the paired smp_rmb().  map_id_up() has no barrier of its own:

    u32 map_id_up(const struct uid_gid_map *map, u32 id)
    {
            return map_id_range_up(map, id, 1);
    }

The barrier is in map_id_range_up(), which is also called directly (for
example from statmount_mnt_idmap()).  The procfs reader m_start() also
pairs with this barrier:

    unsigned extents = map->nr_extents;
    smp_rmb();

Could the comment name map_id_range_down(), map_id_range_up() and
m_start() instead?

> +	smp_wmb();
> +	map->nr_extents = new_map->nr_extents;
> +	memset(new_map, 0, sizeof(*new_map));
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6512166407887190360==--

