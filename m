Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BE7606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k7ylMQXH
Received: by kanga.kvack.org (Postfix)
	id 7B9EC6B05B2; Sat, 21 Nov 2026 20:45:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7917C6B05B3; Sat, 21 Nov 2026 20:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6E26B05B4; Sat, 21 Nov 2026 20:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8816B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:45:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE77E1A0493
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:45:36 +0000 (UTC)
X-FDA: 85461063072.22.5CAA4EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4255D80002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:45:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7ylMQXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795311935;
	b=tiCPNSy7/0h8fXhTzkPWuTd8FqnjoySLtkqFNNb16F4LD+Npugfl58qSwqW13J/dlYYx2L
	lcWIsu86VVPgVcnUcXScFoFCj3fRlE2cNz0JbNThjPQXIT8J5EOHZ1zG0CzSDS1Xa0XlFX
	9tSWnIkg9eH2fBLfGEVDIba7mTjitmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795311935;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EM4+43T1scJ6GiZV72AEDDRm99LdMgBsCTmaQ1zQpII=;
	b=hKFWDtEOWGQPxVH8CJgrhw9YGVKNoG/A14/cNw5YT+O9JHEleh1yLyGWLcWU3Ui/Qodoem
	KfqgybaCm7HWbojFu6T29hogdpeEfOYKjSna+LYHK8ke6fXZ9oUWq9hwQwOhvhxEAWVXE4
	mw8y+PZieoRkajd6vwlwg+sC2rL2iZ8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7ylMQXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7611643A0D;
	Sun, 22 Nov 2026 01:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3827C1F000C6;
	Sun, 22 Nov 2026 01:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795311934;
	bh=EM4+43T1scJ6GiZV72AEDDRm99LdMgBsCTmaQ1zQpII=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k7ylMQXHqxOS6ixuIq1rwku3yNvoV4i3bvxJugzgrobnxWDANUB5vTb2Qh3Wcvbr6
	 4Nrcq8Gc2yLW2lzX5pnlaRyDCCXFFus4TRRqV3JalRCqnme8teQjct66FX8MRxbNbY
	 bPaSHEkoGM4oR3YZrRj8z6ZrkSllUsJ6f1jp2XupqeJVuqHxgdd3mENwQiB3NIoRU1
	 B6iL1iv0L9jre2aNbiSYdTCaEKWAK1BOxVQjQh6T1Lf1XuYr5DhJM6FFGsC8vtGiDY
	 1mjb5uOFb/GcMDqwaEXENYoj0/SyWymdtbyzwaGVRzdaxd04BiiG4IY3vEy+cx6oDl
	 J5AVekoLhjPUg==
Message-ID: <sashiko-outbox-227631@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v6 18/26] fs: Support FSCONFIG_SET_USERLAND in
 fsconfig()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Aleksa
 Sarai" <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski" <luto@amacapital.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Giuseppe Scrivano" <giuseppe@scrivano.org>, "Hugh
 Dickins" <hughd@google.com>, "Jan Kara" <jack@suse.cz>, "Jeff Layton" <jlayton@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP
 Singh" <kpsingh@kernel.org>, "Lennart Poettering" <lennart@poettering.net>, "Neal
 Gompa" <neal@gompa.dev>, "Oleg Nesterov" <oleg@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Zygmunt Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261122011809.2667684-19-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
 <20261122011809.2667684-19-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 01:45:32 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4255D80002
X-Rspam-User:
X-Stat-Signature: 46r98p5hbobu3xp6dwkpqndowoor65rw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795311935-198667
X-HE-Meta: U2FsdGVkX18/UwkdgV12vyvXjnQwraOEWJBxCf9uZrPK+RSu0Qj6ffFTdjG3JQKRYM+I7P/z92DGxfxyEw5zd6RxSsemUDMw84IsZ54BRDPuY1LZjSoR6BpzjvUy81dKA0V4OXvd00GkKbeneyy7zZ2ov7j1BKjF5yQQ6qmboEyPavdo0wXrlIQ/3qUnH9v5Z//3aqRs7zlLIDaYgDbXsul93RdAenz+k+Ma0WpAfN9saCifjU+oaXioKgzCwidbMc3IOndl4mMskFMZ42XmJsBZsxudTvlhCw2XSe4CQOM0zx//m/IR5QpPFF4tuyxa0929SwwD2lpinKTND0kQHGUJvGi0jmZr8rRX81M3NTVMvrVYsLFNgiYgUjo5j0AQutnjHzxNbBrowTHiiPGknxAneGdlBSMsr1vgBP772EYm4s+yNs8KSEOPis1XQWWYFW7shdtT8Ek7hx3Jm3EwhhuLolL6qLDQ3luLj85hkAttn923Zk+dqGp5Lw1DsOI/q/qgpwS0Pi+PrA4uNmxUAaGDsFKT6vFMcop8GKkw25xJugnqwfyUacm3Ss7tNEVbDjPmpEFebllfd2vazZ5ijXIhuTApYqepbgq8Mbm1ptAdciDDuuPZJDgco0oEW7XuY9RahmPx+4ayJnRNBrSe9xmpPRrrE4db++LTQKpxRjPeCCB6m5CH1zE2eAZELcU5ZAV4bWB0fTKusC0iW33a2ZLBgX08H8vDvb6iWCcBv8m/sU4jxo+BfEl8e9t2yzQOvsqImugMIXFVTmCinQAfQmiDUeOypCl6qMo4dTFPZ/NEXVg5vlr+BG00eyi56Diewx43rjPJwtmEQx6eqrVwZ2CRbPDNFyI+laLiN3LWJYZkuE05FyVH2NpWm+QOW27bZmQundjGO30F6hUCRiIPLthBCRfKTIcZ6fGZumWR9urxd3UYkQZar9b9enc0+Y/NMt9TePxmjRfXF1hVNAm
 gOTXXt1n
 a7rMo0TbeRznGb9ut3+N3K5iNXaTndgqJZ+Vc7uvjLvYmERTT8+xG0XYebUFKSoS1eUV1FeQtuLqdUIeISoJUfEc3v3aF+mAOU9BvBtPPdBvY/76trj15ueId+5MF8uPMKGAZppqII1KTIzJv52rA0cC3t7CncW892Ka+MfYOXrEKtQK8jEMlta7SpL9Wkhj/lbP+6sGghaCpAb5ewvLCcARy8UkwRlU9aokcmIFgW1vxpKNQDfu3Kyih/OdoSJOIT2Bcd1JeY46n3NGe6C9pzM5KZybDJvjXR5RrqkyEACwV62QcoB6etUryLt9PMlnnsi/LnDoEPGncNsn2NgXH3Zda0qAarQqHWXMewpuFc0vUkn1Vjb3MsiovlBAAeVIHI94YBrUUdxQL1NcrpJWyXBy11i0cH1pCFPF66VhNkV0cHqRFSOIyR0XIO9b5yju8Q3nh0BC91n+3D9NrKOkG2bxjFBLo/6IrHMicex+aKJJ4UO29KddtMLfzDbqyWTEbu387+wqdcfYetKzhiHpeItKRI/FxV89Nw7xiOJRcAUykbHiDd4H2GicZkBPk1iSvpn8LUYdWEYDKs+xgUtQukqWQmvvuMBBBCsYS5ctUAsGmEHRjjSnlgCRGNI8PpD+NALVXjpWuTA2az1IUjVL07LAjh+sj1AbPNoreu0uR9z3awRosSTMemeSNTlVDYh81lbiSl7Ko5imlterKHDCGU2fk49Nov4tN8Jbzy5JOXuhwl93dV+B9nx0HeG9dumHkhR7F7wrJ43Cr6IaXkiOwQh9KlQAK/ghqo3yKj09blxe8qxISApsP0qslAnRP0QVeMUGQf5Ul4go9bQgJMzC9Ne7wSVG9NtlyFXPKF8YUngO/7ks=
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
- [High] devpts: missing fc->user_ns uid/gid mapping check in
  devpts_parse_param()
--

commit 3b686423ce72875c03141d25884aa118403b95e4
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support FSCONFIG_SET_USERLAND in fsconfig()

This commit adds FSCONFIG_SET_USERLAND to bind an fs_context to a target
userland's user and network namespaces before parameter configuration, and
opts tmpfs, ramfs, and devpts into FS_USERLAND_MOUNT.

> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index bd1e8eb26edb7..921b67d18fa2e 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
[ ... ]
> @@ -457,7 +459,7 @@ static struct file_system_type devpts_fs_type =3D {
>  	.init_fs_context =3D devpts_init_fs_context,
>  	.parameters	=3D devpts_param_specs,
>  	.kill_sb	=3D devpts_kill_sb,
> -	.fs_flags	=3D FS_USERNS_MOUNT,
> +	.fs_flags	=3D FS_USERNS_MOUNT | FS_USERLAND_MOUNT,
>  };

[Severity: High]
Can opting devpts into FS_USERLAND_MOUNT allow an unprivileged user to
create slave PTY device nodes owned by arbitrary host UIDs and GIDs that
are not mapped in fc->user_ns?

When a process in init_user_ns binds a devpts context to a child userland
via FSCONFIG_SET_USERLAND and passes uid or gid options, fs_param_is_uid()
and fs_param_is_gid() resolve them against current_user_ns() rather than
fc->user_ns.  Unlike shmem_parse_one(), devpts_parse_param() does not
verify kuid_has_mapping(fc->user_ns, result.uid) or
kgid_has_mapping(fc->user_ns, result.gid):

fs/devpts/inode.c:devpts_parse_param() {
    ...
	case Opt_uid:
		opts->uid =3D result.uid;
		opts->setuid =3D 1;
		break;
	case Opt_gid:
		opts->gid =3D result.gid;
		opts->setgid =3D 1;
		break;
    ...
}

devpts_pty_new() then assigns opts->uid and opts->gid directly to
inode->i_uid and inode->i_gid on the userns-owned superblock, allowing
slave PTY device nodes to be created with unmapped host IDs such as
GLOBAL_ROOT_UID.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122011809.2667=
684-1-jarkko@kernel.org?part=3D18

