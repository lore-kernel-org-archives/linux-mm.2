Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD19B606A884
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNbrcs4Y
Received: by kanga.kvack.org (Postfix)
	id 286FF6B05B6; Sat, 14 Nov 2026 07:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D846B05B7; Sat, 14 Nov 2026 07:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D776B05B8; Sat, 14 Nov 2026 07:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D83AE6B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63FF2A03B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:34 +0000 (UTC)
X-FDA: 85433589948.15.47CB07F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5355140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNbrcs4Y;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657812;
	b=SNmqLsxh038V/f0w13HMTQ281/Ma+PcZNsKy4jFEV2cq/m+cU62k77YSm6IYi+OqT16lxN
	J8lQEmv5wcx9FgC42ZR/YlCwCM5DjQVPxuJka8T0DvS0EVDgEMOKmZb5XYq202FX7kkmIb
	qkedsJ3DhWqreKJCrQnhvETQ3hvaz+4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNbrcs4Y;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657812;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsiCTf5/ZDJAgI16zRoAOBgO8sIWPIPaiYYrEaqBQl0=;
	b=7cyBz0ZDcreyXagkJ9JpE+gU+OZFB+Toctp8Ns4QHJddla6HetWZhff888KBPRlIZLdRUF
	Ak/4NgJHRXt3rv4yturHfWCzmv6/JsSAXILRl0ZxwdIwc6QAfmGiDxjlb9k3jGgB3S7jKX
	ZOqSW18Wo7BFORN8+f2R5EeNTQzPTBs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61ABA61E39;
	Sat, 14 Nov 2026 12:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA991F000C5;
	Sat, 14 Nov 2026 12:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657812;
	bh=qsiCTf5/ZDJAgI16zRoAOBgO8sIWPIPaiYYrEaqBQl0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LNbrcs4YE9ttSburmbb6iJ9AMZSDEZsciXFVPdhD9V9DlJQLfjlM7FPiVXi7l9Gwe
	 nYeFvAv5JAjF9k8eBJ27Z/pvT/pGhWSE0qlDGGLMnYhWbsNJByvQdKxRGdUgOnOd3T
	 FrNF2fag/r/bvDutXeoOnOVYgZEH/qpnkaplk+hKj0lyEdJyDPzRy+DTwDrHTwcBWd
	 O3oFIPg2Xhd2sNcsEFmNdC8+wgVXv0X58KKsMxRHlQ1NE8HXpLiqzHwqYlwUONMoEJ
	 Eh58T9nMmlbVadQRoGpQvkVYHUInJjGW235heNs7vHgQ3+zEg+xtEqQsCbamIG7jEW
	 4919mVQ2HqZ1Q==
Message-ID: <sashiko-outbox-214463@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/33] exfat: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-12-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-12-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:31 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5355140005
X-Stat-Signature: s184b9makhmb3odkexkyq6nphzs8py8i
X-Rspam-User: 
X-HE-Tag: 1794657812-189030
X-HE-Meta: U2FsdGVkX19KP1Srij+oXXcX7e8fPR4eGvbNtZwmQ+XB/5v/ZzP1eOXUAuwkYl2KPunyzOaCna4i9e3JCnKTQUs1vSB9RIbY0x0IZxSySt5YESpk8V4V/FtZrMKE9jd8dqKoFkCr+qOb+D2Zwmrzz6wI52dbJqdPGhh+Fq3+BEfEng2jVs0PA7EPcMQsovK3AddUEz2tx/cJncgxJjNJcNggtX0ANlL86/oTdt8QKDf+PC4X4oqsosllAE7qV28/8AjyxdfzGnGzww/rin6U9PWySoieZUeBF+TlKfMKIFcF3780v36D0dQEgiveHWA4E3rr5/gQtvCadEykRd2W1hDToMS1GUx/IYt1nouUBNHpqo0aZrys5TMCzT/rLaFs3DggsrdypXpP1PvbcFUCqn8ScIqCApVtgIoW6n8m4gGevflmO/w3lx3COXAb1D3wxLjyLYKPjYBuDctmsL10TH4FKdcaWjZarHnhTuw0YTlmYNXQAyvN7yRe/2XZBKuTgB6CacIuMq7U3g0Zvl3aOsHwU3kjQO+vUaz5uVT8yVJEJwzAzBl3c8MqYotT6MdWS625TXSmfKOqdVFJ6xg+NT5lEzXz9DFZwxEmNgyU4Pg58lxffv5fEEsbOKIgSgvbBbTsv5RjusEEB1/f2uenIDzJNRTlMGQL/Z5BC5K/qsY5CfD+5cjlYeTUC/r3RP5Ep3hwk/OA10ubth0pw4wsnFPXUg6cRz0ssowzHKUNaj1W7e7sK0q5NOnVNZTgbqG6AQmiVxlEF5ncS76zz1doMPKKe3poQt6/VY8iSJiX9/tsX+0Id9xJLMAQ3rKhY7OadAqy4L3jmJNw2WgCStieJTGc4ag0fFjNxOsBKMm6Bbk4yvZvtSUT5BTNSMCvllq442nT17114IlozwfiDaPuj3qjYvNiNpA/UyxyFQq9P3CxJ1wFyAlMQ4yUFBh3sqz6qoCwsWt3bhZtTd/Oyv6
 BNXpTHei
 m+s/GfzxpZ7q8cwylTbD0TDyuk2i2F++7DVyagH9YneadDcUdwN2KwIOY7ptm7Z+SDYMtqvdNpae88wrozQmjCns494vUqufxHIomHzXcQ1PvkoeJsySqTixNbNRXd+UgioFbtGTA7A7yiHpfFMVeANqrXU9n6c1X++BMs1FScCkMUeqZq35KuFLOuVb1yGAFaTTPT1ePqs6uX1sWiuiRKadVSc0qS69p7UggIZffFkL3ewDGM1pWot7oy2wGCgUy4pn/DrZ4r4VRhwkY79vJf7gcUsEzZR+v+1yUjZWgafCk7F8I+8Ja7MACRYA8WwdhtFWLMgjTRvxXLi30TC40Ad9G+2//l8YTtBNjtEHd9hAIjslMVACDPdex/KsfH74Lg8Q8aQ7boRxB79tFkh4F3t8KxiHPTnMAfDqSgaO9lGy/5nIm4vccDdTFtEUUyy2BG9H/2hUQXRT8Sqc2IpFudVUNXigsYvA45e6QvIqVBbbEglwkREvE+W8X9f0tIt7Vv88rXkrSlqQIGkd87CpdqqagdehHFXtXYmIW16Vw7LeYi6ZUsF+vP8E4orewYYnzwrQPm4o+1i/IYFKLnc4QQsKZEg==
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
- [Medium] exfat: race with emergency read-only transition in
  exfat_force_shutdown()
--

commit 55555fc2a6a36c47e1e61fcbe8c22b69f7d5a5f8
Author: Christian Brauner <brauner@kernel.org>

exfat: use the generic emergency read-only state

This commit replaces EXFAT_FLAGS_EMERGENCY_RO with the VFS generic
SB_STATE_EMERGENCY_RO state and skips freezing in exfat_force_shutdown()
when the superblock is already in the emergency read-only state.

> diff --git a/fs/exfat/super.c b/fs/exfat/super.c
> index feeda41a80741..e3587ed270245 100644
> --- a/fs/exfat/super.c
> +++ b/fs/exfat/super.c

[ ... ]

> @@ -176,6 +176,11 @@ int exfat_force_shutdown(struct super_block *sb, u32=
 flags)
>  	if (exfat_forced_shutdown(sb))
>  		return 0;
> =20
> +	/* After an error there is nothing to sync and freezing fails. */
> +	if ((flags =3D=3D EXFAT_GOING_DOWN_DEFAULT ||
> +	     flags =3D=3D EXFAT_GOING_DOWN_FULLSYNC) && sb_emergency_ro(sb))
> +		flags =3D EXFAT_GOING_DOWN_NOSYNC;
> +
>  	switch (flags) {
>  	case EXFAT_GOING_DOWN_DEFAULT:
>  	case EXFAT_GOING_DOWN_FULLSYNC:

[Severity: Medium]
Can exfat_force_shutdown() abort without setting EXFAT_FLAGS_SHUTDOWN if a
filesystem error sets SB_STATE_EMERGENCY_RO while bdev_freeze() is running?

CPU0                                    CPU1
exfat_force_shutdown()
  sb_emergency_ro(sb) -> false
  bdev_freeze(sb->s_bdev)
    ...
    freeze_super(sb, ...)
      sb_wait_write(sb, ...) /
      sync_filesystem(sb)
                                        __exfat_fs_error(sb, ...)
                                          sb_set_emergency_ro(sb)
      if (!ret && sb_emergency_ro(sb))
        ret =3D -EROFS;
  if (ret)
    return ret;  <-- aborts without shutting down

Because freeze_super() checks sb_emergency_ro(sb) both on entry and after
sync_filesystem(sb), an in-flight writer or writeback error during the
freeze makes bdev_freeze() return -EROFS.  exfat_force_shutdown() then
returns -EROFS without setting EXFAT_FLAGS_SHUTDOWN or clearing
opts->discard.  Ignoring -EROFS from bdev_freeze() when sb_emergency_ro(sb)
is set would still complete the shutdown.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D12

