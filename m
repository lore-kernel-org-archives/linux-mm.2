Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091AB606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLR/wxyX
Received: by kanga.kvack.org (Postfix)
	id 1D1CD6B05BA; Sat, 21 Nov 2026 21:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A97C6B05BB; Sat, 21 Nov 2026 21:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6476B05BC; Sat, 21 Nov 2026 21:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D864A6B05BA
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:14:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E9A440639
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:00 +0000 (UTC)
X-FDA: 85461134640.22.65B5F66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EA6AC100005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lLR/wxyX";
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313639;
	b=llLjTLRmG8o72vbKYwDsIx/wpzSqHZ3SY2xX9FUaNzw0AfxSC3lIJ9rnsejy+SAmwGtiiB
	NgUusFZP9kjr3FAzxyEyg7o17ET78MILr9LB7rM8bcyhltKkwAxQhkMmcRwx1V0I/Ypvud
	VPfnbFStUO4phJ1mnsr6+KIyPjQqxhs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQ82POZlS7r2+ERP/+zIeUXyz4CXRnCCzvZCXGyfWyE=;
	b=79H1BwaF8fhLqhcm8ZyZLzDIi6RpD/IJGVozWyC9dxSAlSAmZiGQADqO+kL8xhq3VBRE66
	TDteEUrH0ALNF1kLrQq/wNg5tHIVsNa/Wywjdm6h5f/evRMiYY2/MDX/BFIF7dBWJN+bnL
	E4mQUM1k4HZ4rPk6/Bl8mrHeifkvswE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lLR/wxyX";
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73A4F6137D;
	Sun, 22 Nov 2026 02:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD871F000C6;
	Sun, 22 Nov 2026 02:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313638;
	bh=wQ82POZlS7r2+ERP/+zIeUXyz4CXRnCCzvZCXGyfWyE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=lLR/wxyXLGgBm1hR7Rrr5zEpQdI+izxUfnDTQ9baVoWt9TYCTtTbFiXv1MaR8EQRu
	 XBilrRTHsGZrtSXWdnNCEIwLa1KjPuOkPzzrcwmCwAthqjw4ANEYkmS1STf/vbnEAX
	 tBEAguEBMKLv5hUFQ671CrPULalwAiMoh1EWC+r05Ya03pcXY4s9MyAfAtG5YVgpyG
	 6Mjro/EF5MKbBx5Mmea5cPavRnl7GffrOrX/tLB9g2Kkq4Br4FUfSiv/3GZxFcOyKa
	 xc5+OxbErdGOXYf+vxfkFbmsdAB9X3Xv9+lVV6GwPoooqUmueRI9C2J/7IfnLjIfSr
	 9ldrkm365H49Q==
Content-Type: multipart/mixed; boundary="===============6528941915844312338=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <49ce5ae40b28e104e8fcafaddf26c5825c243908ad6a27003e7eeb82b85a0009@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-6-jarkko@kernel.org>
References: <20261122011809.2667684-6-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 05/26] mount: Enforce mount_too_revealing() for foreign mntns
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:54 +0000 (UTC)
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EA6AC100005
X-Stat-Signature: adrnaeffxoiwnnc9g57ezuzmabjq576f
X-Rspam-User:
X-HE-Tag: 1795313638-194739
X-HE-Meta: U2FsdGVkX18vIuSx70BHVbAlyI9vi4laEaqCErNdLbe/wQ1MgJGbUONG1bM0XSOF0OAl85FNCLwt7fT0MlToK5Rrsd6BgfjdjBP5XoZulo+L07u0R+V0L1sAfVugxZbStp08h1sGI0Dpxsdl5aa9QRiw8ATYIaxUnMdSKxd14dEzRIBe/uO5nqUTzbX6l5wiiIkCILbGTswFD1WQEV7KWH2VSYqAqFx2tSg4xSmjHyGnAY0qnzGSK+NrrLXRcidMxRAZ+VV96+Io1A3kyXfCJAjyM+k/RHPu+miJzSMwSPWY8OJTPxVdpwciMmCFsuM2UXN3naw/C6fDecGwsh59Ou7O6Y5qM/r3CwpIEZpcOTWXP5lZyfZOatCxIsgTuwqx8ik2PGy8xcWqfE39WDD9DzqfhNxCgSkFNWOYmm5hWTg+6PvsFiLBqR/iyBdBIL/o/V04iqIa1qdHbTWV7vbuRt5b5LjGUH9MNJoiLXLVREP6YWtPiZJyEVr6cWPLNKi6ud16oWb0Vm2XYZRZ6L6zBgut4P0vf3czDrHLOCz3j+pN2LQq7sTukD79udkJS4Hpmac5pZCsHUXJqKdmukZURyTH9DaTZXsrkPpLrRjOQVhSzKVuz7kS6mCYtth48Rt0xK5n5fzuGsg/IA5LsfEWl8YzhpF48nVWn7v2jnBszGdrm51idZAqR+O6Hydn1iw9SKszLMlKX8DNUgtBuHHLdC4RpROfWJsaevObTosyfOWc3clTNHtxBmTllnXvTjoBtmDLMejsOWer6R/Tvom0wElXImHJ2vQ9pMdyveqm8gR/N7pz8R5+3N36pI8j1DJvFkbMLFjhHhY/NjaQ/edkbC4slUNQrx7n09dBvtLvVZeB3FlY/7nQSI9osBX9ds3P4o6l6pTl/3atfe621dY0prabyOI56bZTuZ5VUI82FZtHAPuvhp6Pw8GemwUWCKWWEjZ5vw2SIqGCjdCQ+Qe
 chaX0IyA
 Fgt4bXGl6U8AacBySra61hcDPHWFnInm46MRMbxYvxWLrantqLc5bC7Zp3+4G30OKJx8pp2CdAb3MT0fxfVLrp/zS5JEIXdHGEGjkvgB86oxfqaYfxMcEBPSzTb+ecXTa0/1JSvUg1nscKEgnwImVcjdgmGMykWWFaLKe/UEtHu1PAkt0QZT/4lyePJ/budKwAyt5poBrn+/vSqVi3p3yJ09t9qcfPOB+wYPOIV9WD8DFiZzT22+pgaKOS5lkiVidNuoo1PW2fYjmNCY70Bzc87olgQIbARrhMf3U4sflxsn7Sf/o89HaZ64JJSrn+Od66mgIZyDk8zIgaBRCrKQjFtKEKvqTCSAeXVFdh3kSf5VQCbDnl+QdqX8scpjC1Ojo2KFcVmJIL6rCvB7gVfmKNC5DSUX8ItrCAcTV8QLKaWdWab20JH6jR9ecQtTAQOiV3Az0sRBwoxPDB7Fq37E6PmevdouUMG8V6iGeGwDxNVLGR9mB73v4gnxpsFw4lg1VZPcS2RrGDlzoHfFLcovQt384CwhF+bmRwcaywgWM/KQvzYvu9lgAbALSzIIfjJA32u8lUcgUQ2eqiDXV4ecABAPaGA1Aco9cxH+Pifb/2YWP1h3POv+mHuXjB63cKe/K+9l3g7CzTDBB03RVeYKmTUradhIwpnD//NZ9m8sheCLUI1eQPpQ5v8F8T1eDXevxNB+D78qlRdp0MQfNB/zsc+dSOhp1x9QDegxe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============6528941915844312338==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mount: Enforce mount_too_revealing() for foreign mntns

TL;DR: Nit only, not a bug: the CAP_SYS_ADMIN check on ns->user_ns in
mount_too_revealing() is repeated, up to three times, and could be computed
once and passed to mnt_already_visible().

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -6582,6 +6582,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
>  				const struct super_block *sb,
>  				int *new_mnt_flags)
>  {
> +	bool foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
>  	int new_flags = *new_mnt_flags;
>  	struct mount *mnt;

[ ... ]

> @@ -6650,13 +6656,18 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
>  	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
>  	unsigned long s_iflags;
>  
> -	if (ns->user_ns == &init_user_ns)
> -		return false;
> -
>  	/* Can this filesystem be too revealing? */
>  	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
>  		return false;
>  
> +	if (ns->user_ns == &init_user_ns &&
> +	    ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
> +		return false;
> +
> +	if (!ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) &&
> +	    current_chrooted())
> +		return true;
> +

This isn't a bug, but could the CAP_SYS_ADMIN-over-ns->user_ns result be
computed once in mount_too_revealing() and passed to mnt_already_visible(),
rather than calling ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) again for
foreign_ns?

When ns->user_ns is &init_user_ns, the first check here is the same test as
the second, and mnt_already_visible() evaluates it a third time.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6528941915844312338==--

