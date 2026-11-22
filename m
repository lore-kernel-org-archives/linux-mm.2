Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37D2606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PdPRWHMt
Received: by kanga.kvack.org (Postfix)
	id 9AA606B00EF; Sun, 22 Nov 2026 14:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981E76B05B0; Sun, 22 Nov 2026 14:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF836B05B1; Sun, 22 Nov 2026 14:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59F806B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:58:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB86B806FB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:58:04 +0000 (UTC)
X-FDA: 85463816088.08.DAE604B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 17AD2C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:58:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PdPRWHMt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795377483;
	b=8Q5kUpHGph0zJ9CxQ0S/ZjMrSwyKOzN8L9/jYOZGCLrXx0NGPkZcqBvl/uMroRRC+M2rZM
	ga7HN0d7nAJFvXkoaVVdLwK8je5QHV/t5NnXycddnzv02F/719hp8FoZ1eD2Nzlqg7GTp9
	mNjN5tQ9NtBrrDvDVOyTNtMiTOC+ClU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795377483;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMjuXZHrlWPPpEnOYgTwySt1wuMEHljtGxmgjNiSpZ0=;
	b=vWIy7ybCHkkpZy8CvGTHxCUPdxPXAyiiQLa8z03GE+QTIBt9LbZe6qBEir2ToxSVRCq9TN
	dq+MOg6glu+KeTj6cLgR/nBtBlTr7/hd1skyQeBJB3fcnTwCmt30YcPifJ/fcoLsnm1sAO
	cKn608Q7TS066tPBbBCBIxtf5WzIN8g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PdPRWHMt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89A2F6021D;
	Sun, 22 Nov 2026 19:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01691F000CA;
	Sun, 22 Nov 2026 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795377482;
	bh=oMjuXZHrlWPPpEnOYgTwySt1wuMEHljtGxmgjNiSpZ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PdPRWHMtve4aQLIFlHZ+0HHOep+xUOPCs6yEabDNzjy8BU1fG4VCn+DChnNH6AxZc
	 0oo1Aq6TCbPOStHYJd8+y8No/Aaj5J0JE/4NnBvUuINuiQtJVDkSURWIVh10XMLdxj
	 EfLqTi/IBZYhCVzMMFGL2BpuWEsQWnooOgWXA7bgHowKYad2uIaCCYaWMk6Rkd+e+z
	 013aPwBMbsXVFI0FtMpbg/jlR2Cwnm9mQjvej9HqdZsK8fQ83+Jlnp3qLz5nV2Jg9y
	 ZnuCk/7RZejxCUctlErrz/SVQDMXEwykvC9ZwXpuK947q46PmGz13I7b0NTMDHjfdn
	 snb/j8v+qCB7Q==
Message-ID: <sashiko-outbox-228300@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 18/26] fs: Support FSCONFIG_SET_USERLAND in
 fsconfig()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Aleksa
 Sarai" <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski" <luto@amacapital.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Eric Biggers" <ebiggers@kernel.org>, "Giuseppe
 Scrivano" <giuseppe@scrivano.org>, "Hugh Dickins" <hughd@google.com>, "Jan
 Kara" <jack@suse.cz>, "Jeff Layton" <jlayton@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP Singh" <kpsingh@kernel.org>, "Lennart
 Poettering" <lennart@poettering.net>, "Neal Gompa" <neal@gompa.dev>, "Oleg
 Nesterov" <oleg@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Zygmunt Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261122193539.3334213-19-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <20261122193539.3334213-19-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 19:58:00 +0000
X-Stat-Signature: iyhr6cjmc5iyw35apdzx9mt7gi3niw5p
X-Rspam-User:
X-Rspamd-Queue-Id: 17AD2C0005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795377482-366420
X-HE-Meta: U2FsdGVkX18Y8kUmxRn0i3zAJps0k2CHvyMPeXMtbc9CdVK22NwzhjV7exyry9rlPF6TU4D5ft2+JXDz8Wv63zrhykNltvgM9dvCHshRy1H2X/d6kp3KbEpZ+IiF1hxypf7iv1l5g5xVGZIu0t5TP08l5L48C8BQroq7zGHe/j3K45ezwuzWD6MSIwNZoR/nTwk0tlarb70nD5cEklGqgawFQL/U/Tp2D+vtMTgwlSguEVneGAI8GhomiYej8fu7TKrhBFRNw4BmdtLfpnvlhsWuvuOWP/KRNrJEPocX+ASL8KFWG7toblGvvK3RmBBa9tegmVXcuwjhWrvXFfFnHrIPnZ1cAgoiOdzyOBUlMbxloD7s88+6JdlLbhh3ygjW/yy5H60xOPs0+mlwTFPxLYHviW921fX+td2vD+BELA+8jCJeXKkVi5QwpHsXfFLhuVOPfw/FIz1WnT50iGoyt4N+9mB/jtrY9ITak26oiZHyMCKPVJcOiA4Av4GCdkmEN/QueGyptITN4SlCendeT6OPZcogcMF8/rGpeq1GAPpYrfktu4YTG8rIBl0mAcFWTADypHqLn6O9f8jJ6Tm4Q4AU1sjz5pmT4HQDYG5IkTmjSMmAsO690GzVuUUPnoW/JugsXfOqgcQX5j5J2tEClL335s5poDacC7kCPOBT/jagCcpPEC7TQgutXpl2E0FwUg4gdLnKqP0J4H403uBKLu5tn50pPreE8gjB7tHO15GV5veWuyKyU6w/z/y/C1RxsvBDBl3atWKiVtsLI51isbCEGb0ITv8wXTjtXQxzsRWjTDvwrBCagBo3vYSwty4eXDMj4XgPdnQ9T9s/ibyQJzMM2NpP62dOdEWLVgs4qR+MwNbEHGfMkXOZuMDUgmgYkGXbXXrzWtySGKXwNJofRg/SSl8rFW7in8MU8x05lmpWBWCrUpjhiYrxdJ0t4PK+HAjAG2P0B7e8Q+co9+p
 LwVJ4qFG
 OIv32NgFwx1vZOf7UL1LNscLw3YBmJ3/jBzBNz70EUBP5/K8qNryEic4338UbdPqaMI5xuFbyeetBOX/1jW3Z2CxTCGR/I3YWL40wtEqb0cHsOEPBSzMX414ZdwaDsqbi+GLsHOadxBgcEhvK3W0rEJrk/2yFbFfpEsHwBBqGYp6cXIhUDQIgDVd7nbOmkd/nMzMMThuFqhGArBDAckiwMHjRzfGNeuRLIv3MuFhVY8f1h1RAR4ARlFgt63I6F0m1ObX5HGc26zKLLiQEqTDELDb3rpNm8xLBv/74/qkHIpc9Hs7AavoMOc+/+n98t1FbGHLuE9CCIG7XTbKyim/vdHkFUJ+aNaO3aO8h5f1v67/dleXGAVF7ZJuyfHUnhVNj3rU0vRy1hBTZYjxnzwNE2jE7Ig2D/KzjzYDa9YPzSbvZHUBvMDG/n+byFOb/jMSrcjRRI5Ps6zANnM9q5bxGBLYnBKhgYokJtdjNE6UxkrAY5lyxW0hvRheGEpFc0Ois4X/WNOwaDDTkI75VpqHW7AqDK/+/7+nl7AwHrlUTDveGtnYTVzTDJ/e458RFvn6aE7rFIl9SRB46mqvqguxwoU59Y3EOcxbZgT0UNki1rtPnaRehjJgVpZmUwgeXR9YIkqV3l++fIbVQI+ODZNxeXrSt35HIZqNSr2yQbupgoVtxGFjbXgGZd53nTkTurzRW4H6LNWdz9eSFe/hB2XAJpac5JCR4fmdREmeOPsVLgSfkGXhvN25vpiwE8DguoiJCYSDlwAG8ZDvcB39jqUva7BqN3jH7ZSCLGzbB6u2Ny8ZksfQkSVzxKlEZY9poWZzn7CtTwqMPrJ1i36ErhG3o+I+vUNESLYUWCgawzTj6FSKF48s=
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
- [High] devpts: missing fc->user_ns uid and gid mapping check in
  devpts_parse_param()
--

commit 5f6b9ba4a78b24bfe4f6ba168eb1ea41dd809f38
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support FSCONFIG_SET_USERLAND in fsconfig()

This commit adds FSCONFIG_SET_USERLAND and the ->set_userland() fs_context
operation so callers with CAP_SYS_ADMIN in a target userland's user
namespace can bind a newly opened fs_context to that userland, and marks
tmpfs, ramfs, and devpts with FS_USERLAND_MOUNT.

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
Can opting devpts into FS_USERLAND_MOUNT allow an unprivileged user in an
outer user namespace to configure opts->uid and opts->gid to host UIDs and
GIDs that have no mapping in fc->user_ns?

When a caller binds a devpts context to a target userland via
FSCONFIG_SET_USERLAND and passes uid or gid options, fs_parse() resolves
fsparam_uid and fsparam_gid against current_user_ns() rather than
fc->user_ns.  Unlike shmem_parse_one(), devpts_parse_param() does not
verify that the resulting IDs are mapped in fc->user_ns:

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

devpts_pty_new() then assigns opts->uid and opts->gid directly to newly
allocated slave PTY device inodes on a superblock where SB_I_NODEV is
cleared, creating character device nodes owned by arbitrary unmapped host
UIDs and GIDs inside the userns-mounted devpts instance.

Should devpts_parse_param() check kuid_has_mapping(fc->user_ns, result.uid)
and kgid_has_mapping(fc->user_ns, result.gid) before accepting Opt_uid and
Opt_gid?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122193539.3334=
213-1-jarkko@kernel.org?part=3D18

