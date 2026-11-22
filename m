Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBC8606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e06Le3L6
Received: by kanga.kvack.org (Postfix)
	id 61F6B6B05BF; Sat, 21 Nov 2026 21:14:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9C16B05C0; Sat, 21 Nov 2026 21:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7776B05C1; Sat, 21 Nov 2026 21:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 128E96B05BF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:14:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8378B1A0629
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:16 +0000 (UTC)
X-FDA: 85461135312.28.EC7FC48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 063534000B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e06Le3L6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313655;
	b=F3VmIeodc/Ir17vzX2r8/evfslG8oAHpktgFi4zx9euPNvx5RlvYgq5VWwEqBLROZ6DF1f
	nWvwynWbeV5C7KkqncE8G8UCotUkAbxHLDGZGDHuBSu0lTPZRMPFXhzWpQ2Xsld61zfz2r
	/PHWCptNTm34Wg4gfYWRFTwgiqyO6Ps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iD7PU7NGCfMwNQSYxjLcnZ/03erTTfgXSUkJ21vjtj4=;
	b=WygQ/ruMdh8mbzTXElX1Z9lWY2LHV+gfA3iZwhbtTLEXUdT7nk4DECCFNIkskto73DouN5
	P79UHO9c4wjZT3mogqfn7lY22uCBKlw2z1WCoDWZwQ7y1HiWI1hbOPJ/0ujclasQx3cMtA
	yzeWNollqHPTUZ5rp7gxRS6sZnPI8SI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e06Le3L6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D64F6124F;
	Sun, 22 Nov 2026 02:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0481F000C0;
	Sun, 22 Nov 2026 02:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313654;
	bh=iD7PU7NGCfMwNQSYxjLcnZ/03erTTfgXSUkJ21vjtj4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=e06Le3L69uIarz6TxZbSSwnjOY2OrQN2BJ1eOkIW53/hqfLug71vs1pllVZsSyRym
	 FrcQ6gSGi1UODlKwR424j+c/ZjV6U8FGmIieiUZR0PMiFeLEy2dcgcsodQCDQBwIf8
	 5DNUe+WeTNk2pmeDrZV0oESzQnlz3MN4N1l/UZ6+TMslyckRBYLsU+reaZAte6yTOr
	 92pGoByfmYr8DAi+v2tD+HNfF1T6U0RyqgNK3mF5qFtwkxWhYii+Zm+9E+vnshHqT9
	 rX2EbP1s8XOpxerozC8ObutQLVaea8GcheD9KolKUGCQy7iZY7USb4LCUx6E2ER63c
	 AmRZlRXhpNiEA==
Content-Type: multipart/mixed; boundary="===============0180983141646698394=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <eeaf83fa0a0e98aa72195ee35fd24ea0b0b539a3cbd53cbdb8200e94839eb49f@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-7-jarkko@kernel.org>
References: <20261122011809.2667684-7-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 06/26] mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:14:10 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 063534000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: zni4j786cnsed8y67iqrbc3ban1k1n8y
X-HE-Tag: 1795313654-430688
X-HE-Meta: U2FsdGVkX18tMxS3Uq0RPxT06G2DBwCLjx2Feax7abKzLHyRNeQ9Ou2jZoiwHn9r1FutVYOwc+wHS41AEloYmtz895mxUR3xHz7f6ZuPkdK7yVWJXWceHyUmjHdWv8eiMQIRxTlsFmrf2WwhVWXIbBwuC15xoliwcA7XoLMZk6L1dw2bdsSLU3mRz+Nio76CK2JY1auIBTF1oTD9Rei3Qqo1AtGjBf2dlO7nj9Voeptmy2rA8nqQlUQRvOYuQMAATEY9PdGh7MYM7GeHI853gCdKsucnm2T++KZYhussvmfbPdyzoNVQ2A98D4+F6HUuTrWRpGgUOkTYEuUfEch8jQm8pE+bLexijCyn6Kn++H+Fdfg+ndumiJB3rQTxZrqSv0hkjTPYijc7AOHbcp1nB01t5uWNbUc4rwqYSvwkb4MS0tFRnKOQq8qDQLihQlFtDwkXI+uPX3XlEU4mPBF0WMcA4mBBk5QDpfsIe4t91/gY+V4x8DsucSdreodIsye9uSR6aPB2YPr301MAarbXCFhduwwNM/VnO7XDCDFyWrEr5EGbjROfa1JFJU5+bv2htoGqUmYh2YKEzoOVwnXW6HPaYlZLoagYoaVRdCnY0w8vEXDtGHn80JLlyMOyLDyxZ29EmI6Y9mdXBM1bG/QQYOiNs6dzS+Y5RSK2XR17y7ntfS3IB0I47slbu4JYQivKvBYFmcglNmmZ2KGVbQLHS3mXO2v0m7HTBNjRZsfS+0E3Ewv1nACeGiIWbiMmRW8/b6j3JB1j8PavHaI0+z5DIOCm+7fhga2Enkho4kH5tg8Vf8u7PjI3xzjAPYDNRSyQGF2C1pNWDduOy1lWM/hSONQvhilyHJWQGxr9mcATyrgPf7pOhTKNuyL75qAcifHvAAQk3MrKj/+4H0XQFPaCVlFivxOPHhFXnd/lO/xyFtNKj73rbNzP+VFkVA8RlIv0icWNVV18gcloF55oDNT
 zrSPmgiM
 f6niJdpd790S8pZ3jbjJGuyVMlrnVi+Sjf1iZGgqhL5kAXCYPWjXys1+HlkloZqLaLw93JyUnTIZUWsbBf3afQHDJtEg4W34kovuWNkXZWjrNSMlAYD40xj5TUKumoF6QF7/t3W/lbWzsYw9QRudF7zcdLAowSIUTKMPqZL8Ghqjtgt/bP1xJe8UrXowWKSJhCQJi4Bl95j1/rAAZ/1KNmkXjXmeZThqxjA9LkdVLTZE/pny8hB9g6N+J+CjuYLUpvkxTxvdIoQYa5rs+n8E2Wvlnwm6vu6UoSLr48IkFDt3+TIG4+NVmbCOwjaHU+DicaQrV2ed21H9ULICNdXOdXkRSgmfnhGYq8Z+FURklZ51hVRHqVc3EmmwwxBtP05c9fX21G6LfYGaPPzdIlnbHEpDyK2z3E5QpdgEfWo8GzzwgadS2JfwmSCS6CG/3LX4Eb9uDW7d2HFq0EMOmOSim/k/6e0BV9F/tnZHcU+NasBLAClBYRtOFJT3xZM/+NkE/c5zd3iXCsMVtWzy4yfTAMC+0PQHzXVoEDfgFTTrfRvy5qrBpjDfMzhBf86Fuf/fa9j6tDYRyAz9jI9IJ+EC0ppw5Fl+ybvsmOLkpxKImIMvdD2T7zRHp5+x4Toq50RrAfFAR60pkBU6g1bOvY+QQaY8f5bPKEGRoyY24R1FCSChlpRtVZY9XgR6QYxQ/cr+MZdqoztGl5OM6S5w66R5QGy7l9kLYsCZ6C76S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0180983141646698394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mount: Support MOVE_MOUNT_T_MNTNS in move_mount()

TL;DR: Nits only in attach_recursive_mnt(): the repeated cross-userns
condition could be computed once into a local, and the comment doesn't cover
the new case.

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -2728,8 +2741,17 @@ static int attach_recursive_mnt(struct mount *source_mnt,
>  		struct mount *q;
>  		hlist_del_init(&child->mnt_hash);
>  		/* Notice when we are propagating across user namespaces */
> -		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
> +		if (child->mnt_parent->mnt_ns->user_ns != user_ns ||
> +		    (cross_src &&
> +		     !in_userns(child->mnt_parent->mnt_ns->user_ns,
> +				src_user_ns))) {
>  			lock_mnt_tree(child);
> +			if (cross_src &&
> +			    !in_userns(child->mnt_parent->mnt_ns->user_ns,
> +				       src_user_ns) &&
> +			    list_empty(&child->mnt_expire))
> +				child->mnt.mnt_flags |= MNT_LOCKED;
> +		}

This isn't a bug, but could the repeated test

    cross_src && !in_userns(child->mnt_parent->mnt_ns->user_ns, src_user_ns)

be computed once into a local here?  It is evaluated in both the outer
condition and the inner one, and child->mnt_parent->mnt_ns->user_ns is
spelled out three times.

Also, the comment above ("Notice when we are propagating across user
namespaces") doesn't describe the new arm, which fires for the mount the
caller placed itself (child == source_mnt) when the source tree's owner is
outside the destination's user namespace, with no propagation involved.
Could the comment be updated to cover that case?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============0180983141646698394==--

