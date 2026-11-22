Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0EB606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ul+eGqK1
Received: by kanga.kvack.org (Postfix)
	id 305626B05B7; Sun, 22 Nov 2026 15:28:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B59A6B05B8; Sun, 22 Nov 2026 15:28:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A57C6B05B9; Sun, 22 Nov 2026 15:28:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E18AA6B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:28:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72FFB1A0706
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:29 +0000 (UTC)
X-FDA: 85463892738.30.252092C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D13431C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ul+eGqK1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795379308;
	b=HyyxWEWZbUKhZ0HbGLavo130XRisabe2AztEcGk9Ll2SdcgyXMjrnXXYwhReYpg9CqcLuA
	5JVIK8HbdT2z7VaNHM6s/cbJaGMS1RmRdBpDb4WfzT+wtnYAv0OLcFqfBI5I+l7geoQ7Mi
	iVoOSMb6X41wFbi5IgSVOnJSqnZyr90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795379308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKGFNqJhoZuyA4EsjC0ZPdlEy226OjjF7ifp8YCJ0pw=;
	b=5E18AsRKrIADeDgHws+dhsozzNtqmUVSyQRKLx0KdShPflifNvV85in+fvCnYxiqVsux1o
	5G35d0x6CGzOV20OCb/tkK75NQBw93Kxyd51mfdbxVT6I1cWn0v1p1qXzg2NSg6eVNZmeT
	/IckkAA4Gv0A3Ho23qn5iuc73daOZ1U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ul+eGqK1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 292B640093;
	Sun, 22 Nov 2026 20:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D2B1F000C6;
	Sun, 22 Nov 2026 20:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379306;
	bh=MKGFNqJhoZuyA4EsjC0ZPdlEy226OjjF7ifp8YCJ0pw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Ul+eGqK1TzFk2GoVQ4qrcBtOfQtz9OLX+r4wppvttMllEuX+UwzW1YrAza7piQ2z0
	 WlQEMFrQCqDRV/6+Bcs/s1B/8RLtRAwEleegTr1/l6KB8BQUa19frILcGbvG9dGYpx
	 4zTJxLgzLxbKXvc462NcWNBSfVVSfo6qe05JfkRdnmVJeP+kOzBbvvyX2PoD39sc8d
	 5rNOYL+fMqgCL2eaxnfu8+WJyrOsBaI6KLArf/WCXb4ZiBLFQGQ2bukxmVh7RqbxMt
	 d/k/9lmqJ+g4mDzA1M3aLWKaOzgnTiXB1wXQn63rKSA00Rfuqj1LWJpFWOw6itOPFv
	 WNf9nQHOsewgA==
Content-Type: multipart/mixed; boundary="===============0979252114820036136=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <516d488e2aa670a706837915ba7a73f107db09ac4eb736a4a86dc3624dd1c69c@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-19-jarkko@kernel.org>
References: <20261122193539.3334213-19-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 18/26] fs: Support FSCONFIG_SET_USERLAND in fsconfig()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:22 +0000 (UTC)
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D13431C0004
X-Stat-Signature: 9f1haspzbs4ykqhcy8etew1t7471yti5
X-HE-Tag: 1795379307-960735
X-HE-Meta: U2FsdGVkX19JMVgrpqnVQwGu3PfhV5t9Wph2AUJiBt7ZRe33tSStbKoqJD8N42L9YyAhapi1TgT2C+3R0XLhWDnZH+obp9g4omwEKDck+3+rxAsP/O2WLTQaamie/Eozr6skEmcIVcxe3TdTAe2zmW/arJh+ORL+fmIFewsltXUL2xwN6kL2V+Q1bLcgg/IpEtsJ/25P16OgnvBjCPa62tZ8WqfLEj6vfDp3r1d3bDpvzQox5JGOAsIaN7UoNrcqnK6HM0vmMtlbxGcMv7Q689wH0D79UHDKRm0oE5ucCTpWsHCYBcB7wNIvXqdQ4unJfutww2vUjf9Skkf3xQND+VnZ9G38a2AgHPqXbm2s29JJ+xml87f56ofpg3rNDDKBH0HgifGXCewH2PGYYXYB6sO2l/1KsZSl20bXp9esal2zEg6eewH+i1s3V8QoPIA6sKqGfTM5TxKhYC5KcNk4lac+kIp5n7b/klMW4RioQjk8uRiKw6KoQHrVb/k1EHWw0VNiRFsIcE7NWNHpBf6D/7Caqsg8+04CTdCT6xvdle3ZKXk5RWIX5Qs/cJwP6R6vkpunXORNx+ihndc52CJcbZolYI+CoDMDy1pn931sgNxO0bDMtPDxMiOjREt7PszXas3UFyhVQ1e1Ssf2JhYjvit1AyPuQ/21yvJqc5/deOVsNiNNTQkarocq2xJSaXRbAwfdY7qProPjLhKrWWT0EXlHcgXn1sF6m9BSeInbAzxs2WcnNTDGUzubhow+O0EfBCuOnroqrhOkdOZ5YA99H7s5ox0xSOomTwiK418edyku3Cs7rw7UQhLHCM5y6ySCFUmoPebDfsJaygR2KIAugddhiOpIjCCLKkLnHQzc1z7rNHNj3TLQe/QayJB5ASbgFdnRXOvA4+H0JQJjx4K3sVp51gODubwpzdO+f6kuDcvn246n69zCzUMPgo00oP+HvsoUF5IQaKaiSsEJ5Nt
 zsDtNUu0
 03gH/8UcXEJUNWwvA9uMhXf+i13sVSutMJMz+IUOk9J4l7UOvA8ihOgeTZSl89IVRiQCinlmDu7Ut3FGql8DK4lVheyprUq58krlJXjCR+kyDAuyvNkHlG6c5IEet/IiFMcaOGUQr1iiPNMaLGXfEpeS4gUQmWV0GU1OQ1VAOyPNpoW9ob3CAnaov7toLHOdRk0V9tELPcfs3PjCYXvSNoTa90c8fZIrGY1FpYccL7PeetJpKGEOnP+FkiNv2SjU1L3rPHJs+KtsjtM5PSudLvun4ZlGDQMNhuAfj+EW7/gIiOVad599QKa8rZcoor+ykkOpwX+zFBkyfeysYXHC6Om+Qt0aQar4R4QWAoiS0KncQLDM82e/arpy6R91RUv37cEkKUfdhGhvoZxHSIe+VkSCdgotW8kRbw+fJ+GKCvU+JUD/PrsIFlj/3Fs2Xdepi3vvnQXi40sDogQWXvM8uK1+ZkEAwgb9VwNxcOg3wvjraNUrNvQlVe//QKhw0feNqQGqqoQmPh5nZppr3XTAlX2TkQOf6p1gRxjUBdrU4iLjAb1awJmjCmLNNapajFd197trN7xkQUEDf4PWR3TlSHeYsywftwMDwcYhrPXCFGWMeYLLd0+cNysHtR9eAL+KCaxBr/DwaLx6i0c64gGpk0PpzQy5uYB5i1lKVknZrsGGj+aD9Sojc7pvsKL7qGlBGGX3ldXTP5SERap5BMcL7bWh8cdCvUxOeYsWP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0979252114820036136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fs: Support FSCONFIG_SET_USERLAND in fsconfig()

TL;DR: Nit only: in fsconfig_set_userland(), the fs_type restore block looks
unreachable, since the only swapping filesystem (cpuset) fails the flag check
first; it could possibly be dropped.

> diff --git a/fs/fsopen.c b/fs/fsopen.c
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c

[ ... ]

> +static int fsconfig_set_userland(struct fs_context *fc, struct fs_parameter *param)
> +{

[ ... ]

> +	if (!(fc->fs_type->fs_flags &
> +	      (FS_USERLAND_MOUNT | FS_USERNS_DELEGATABLE)))
> +		return -EOPNOTSUPP;

[ ... ]

> +	if (fc->log.prefix && strcmp(fc->fs_type->name, fc->log.prefix)) {
> +		struct file_system_type *orig;
> +
> +		orig = get_fs_type_noload(fc->log.prefix);
> +		if (!orig) {
> +			fc->phase = FS_CONTEXT_FAILED;
> +			return -ENODEV;
> +		}
> +		put_filesystem(fc->fs_type);
> +		fc->fs_type = orig;
> +	}

This isn't a bug, but can this restore block be reached?

fc->log.prefix is only set in alloc_fs_context(), to the original
fs_type->name, and no parameters have been parsed yet when
FSCONFIG_SET_USERLAND is accepted, so fc->fs_type can only differ from the
prefix if ->init_fs_context() swapped it.

In this tree cpuset_init_fs_context() is the only init_fs_context that does
that (to cgroup_fs_type), and cgroup_fs_type has neither FS_USERLAND_MOUNT
nor FS_USERNS_DELEGATABLE, so the flag check above returns -EOPNOTSUPP
first.

Is there a filesystem that can reach this restore with a swapped
fc->fs_type?  If not, could the block be dropped to keep
fsconfig_set_userland() shorter?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============0979252114820036136==--

