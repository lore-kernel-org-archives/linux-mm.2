Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D506606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l3kwdHRL
Received: by kanga.kvack.org (Postfix)
	id 6B7EA6B05B2; Tue,  3 Nov 2026 20:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6693E6B05B3; Tue,  3 Nov 2026 20:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F266B05B4; Tue,  3 Nov 2026 20:03:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3788E6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:03:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE2E6C0605
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:03:25 +0000 (UTC)
X-FDA: 85395638370.10.BC51FDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0F9D21A000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:03:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l3kwdHRL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793754204;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05kUs/NRp2VSsMxOprgec11bQQFPGMRlOicKgyHo5Kc=;
	b=69LeK3YGccWmMZxkOp/PhPAcPUGrBBtnDrwRQtbksV3Dxcv7PreYLaFOfHqXQ+Jyo7uxSf
	Q5HcI0FVn7QEHtYgycLi7blvQ+JoQsm4k6qKc3yVc/ohpi928LXQAUL1xnaoOv0TBVPpq2
	isHOn19tEsqUo7idTPVKUOPeGiRJz3M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l3kwdHRL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793754204;
	b=6OTCYPTtevZuHiGhYqi9oOOP/RGXnbaf2WSzNRR8Kjt4V2fUtt6uCAYwXot+sH+S79V7co
	l7mN62Z8ppWJOIDZxsHbcbQ1OsEvRKIFWUMK/5FxVVxrf11Hg1+cb9Gc0tCsG1wUWpuYJp
	gBtUrOTb0XKXbCAamJn5HOmuul24rDg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71C9D60AAB;
	Wed,  4 Nov 2026 01:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B431F00919;
	Wed,  4 Nov 2026 01:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793754203;
	bh=05kUs/NRp2VSsMxOprgec11bQQFPGMRlOicKgyHo5Kc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l3kwdHRLpV+iEc/E03asMe5aCNmofN4Hr5/IYx4FDhf1UsEPNPbihEcO1SsSF+CmW
	 1Bllf95+Wqlvx2UYRDu78CHv5ueV23ZudAww68y8u1udfRv/kaly8l5WGbFselmUNw
	 E8CKZbkmETEiLwlkMQJg5khkt7gepvBzJptVIetGhoil7dTEv6FeB4GwurKZI0yXEx
	 uAUDKSm4mfw2KK8p/4gqjRZZsLOkNQchg4K23fbS03J5Xx7QrZ1hnlyPG28gxaZkQx
	 /CZiMxPlzlItgyeBHzLVslGfEyZeFewgvbpIoHPSZzZPCCRUyNoPLgKSGBED1Kp8Yk
	 4VfmeRLRxio1w==
Message-ID: <sashiko-outbox-196332@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/10] liveupdate: Pass user argument to file
 preserve and retrieve
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261103010216.3447716-2-dmatlack@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-2-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:03:21 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F9D21A000D
X-Stat-Signature: bd3zbebobz55ki68nemkcubj8xp73tne
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793754203-711621
X-HE-Meta: U2FsdGVkX19/xmqGCz/n2mpV2TT8SEljHcbKK178KrgerpVXbbYqdLNCbxgpV/GNfaH9QaX80ShgqkIq76F28MJB00j52TEcd1Ogeq6+yitDtMARb2bzjNqTwZRPfB2XmQNbFUBKalLDBmu7gXWeJYAw8DMFFUT5OHiaoLQ+0zGjdGJ4lbzpwP1IBAkSur25ddGpvhp7dHz1YmkDCDYORwyfb6XUvZC85TyqbTn2gdW+qC0/IQfTLk8KpH/C+nhGE650lDG6ByY4RnG/E0TiuprgDlmY3FHmqtmylOzhsu5ZWA4wWlN9AMf/6KhExEx96G9qV0Esx+S1I8mN1NQCP45kRYOMPJN6EW4AiTLVjypRIQWgkxzmiuzw5/IeTtDCq6mQWXe+X48r2YXCtbU1hCO0vVKC+mWNcGwPbW3mNFSyweFUXRlRHmptdFzMq4wh0kYt0ZKnjcOKfTGxp//95BJ4K2PLHh0+zTNMtvyvYSPOnR5t3nA6xDswjpKpsht5pEC8DTBbDosLo5/quuByK8sdKWm22JMwfKfR+vL3JaqXVJtM1GlNpkp937p2Iucn1jIvDrXKS32Id9fIXLQr4p32pMZMw8Z57bFA2Gf8ho3jWrxw20355jFAQUYdNAcskb5g6UdX4ehCSvcB3MlMfR9HdlczN68UMFnK3b0ZcEAF2TK+eQ/+NNrIl+twYHthvCmKfRtwo6JsxA3jHfCNElmayMY3r4ShPKGkb/I/Y9n1gzFJ+lFTCgPSAM7Q/o2ad1EcnQuXpBrecQD+d52uEbkeHEEB/o8f/dFzX80jJPVj8FyLnnNAnoJGVIHyqwQ9p08ntB1RIWfTUUUMS1exlg5OwwIdkN8gCc9yzks7VZDW9gs6fXtnGe1Ndye00BaodhsnZXS1ALkyKeRQHDou6RGdxEIKqJKiqr2Px9zQR3sQlY1150QVcGB9m2+um4FhovSbUrAb2ynxp1/W4gv
 Ilixvrx4
 lJm1Em9RQCURupi1HfnsYr4TDoPsYt7JElVpemBlfIhrM9tZ1ZlCXPBfc6/CpSs7t9spmSu3CTv1Rdg0HPQLSKxA7zwJQmTUZDryLS8TFfAdUlZSQ5yaivArYEh0wG2Swm6LuxcLScZ1PfiVRX9Sp/4AzKHPBkR+sTILX7b5cfrXF98/jpLaLlUDMnC3kt/YcRvCw4VY29jvBDj/WXAsbEAzfUNNQ3i0hRL8D6fdBuB1vyw1qdbFIDVgYEme9YbIWhVz49eOrJnbaN4hT57C++15UpE6XrApOJmJNN4nIiF+FPM5GEhlI6OKNm6vygWP+1rLlxMd7mceXedfQgOWvkyE948nyA01DOyiFrdtFjXYy0vROuUt9pJz60Qnl+JjJUT5ZAfS2je6zYCEz2uOVjFYZsf+7gGRbDJKV2gIvy+Sk1dauatjWtgc7UQ6c7uNcWqqWcTRdzS0mivb1kchQDn6MEAjyhnkonMcHv8sLrVragSVpSHvJKe3eXUj8ZOeaCOw/biymbmkwr1C/PfdYh1zjDAuQfDvGG851V/lxczf/b/iWAwomNw5RpjmFjQjyH2gQSGc1nBPYTrqKEQDOAqZ/iznNABD8KCCbBtYjRF2B0bMHVwsCeQ+Q84oKfswGVNds5QOPHrk6Qvg=
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
- [Low] liveupdate: karg __free(kfree) declared as NULL at top of luo_copy_=
user_arg()
--

commit c4f18d427b088994ba26ccc665552744e8d63e5a
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

liveupdate: Pass user argument to file preserve and retrieve

This commit extends LIVEUPDATE_SESSION_PRESERVE_FD and
LIVEUPDATE_SESSION_RETRIEVE_FD with an optional user-space argument pointer,
allowing file handlers to specify and receive handler-specific argument
structures during file preservation and retrieval.

> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a39992da504fb..eeeb3b5ff2faa 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
[ ... ]
> @@ -202,11 +203,45 @@ static bool luo_token_is_used(struct luo_file_set *=
file_set, u64 token)
>  	return false;
>  }
> =20
> +static int luo_copy_user_arg(u64 user_arg, const void **argp,
> +			     const struct liveupdate_arg_spec *spec)
> +{
> +	void *karg __free(kfree) =3D NULL;
> +	void __user *uptr;
> +	u32 user_size;
> +	int err;
> +
> +	if (!user_arg)
> +		return 0;
> +	if (!spec->size)
> +		return -EOPNOTSUPP;
> +
> +	uptr =3D u64_to_user_ptr(user_arg);
> +	if (get_user(user_size, (u32 __user *)uptr))
> +		return -EFAULT;
> +	if (user_size < spec->min_size)
> +		return -EINVAL;
> +	if (user_size > PAGE_SIZE)
> +		return -E2BIG;
> +
> +	karg =3D kmalloc(spec->size, GFP_KERNEL);
> +	if (!karg)
> +		return -ENOMEM;

[Severity: Low]
This isn't a bug, but in luo_copy_user_arg(), karg is declared with
__free(kfree) =3D NULL at the top of the function and assigned later after =
the
early validation checks.

Per the Cleanup API conventions in include/linux/cleanup.h, could karg be
defined and initialized in a single statement at the allocation site instea=
d:

	void *karg __free(kfree) =3D kmalloc(spec->size, GFP_KERNEL);
	if (!karg)
		return -ENOMEM;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103010216.3447=
716-1-dmatlack@google.com?part=3D1

