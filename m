Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56034606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VeywEVYJ
Received: by kanga.kvack.org (Postfix)
	id 19DAF6B05BE; Sat, 14 Nov 2026 07:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1271E6B05BF; Sat, 14 Nov 2026 07:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2FF6B05C0; Sat, 14 Nov 2026 07:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2F56B05BE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3409D1403C5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:53 +0000 (UTC)
X-FDA: 85433590746.04.F58ABCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 957A0C0003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VeywEVYJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=En1pIhjDCbi5uQnQl7d6tI2Nsu015/E0bz+ywSlsPnE=;
	b=qRoY3M1MnyuBD3tj57pVwFaA5giBLaZkwhxjNBR8BRtue0ynsxOaLpXy8rnIQAhUmeOB2I
	6Gwh4eNG0GVO6X0bf6bTaTr9etV+EheEb0ua+5p6shj6jjO8y5HHbL3iav6uK5rHfHeWBT
	uo9sv5bwJI2VKEIhkm/qH/dvwPF17hE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VeywEVYJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657831;
	b=bxq9bAvBv/VUUvNVv7NFpVo9vipMOjmXcFW0VOtkSEBAZtPCQHIAlkUvCMnutIBPj9EH8V
	rTzMkhrFVIuyHjVMQJWabuy6s2aMsCnPpY870gAHNNxT9OVI+g4Od5ILuCbt0xT5cw4Z+v
	+BCXaasTAYHASqH9B39v760OrOjJY2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23E936234A;
	Sat, 14 Nov 2026 12:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE21F000C9;
	Sat, 14 Nov 2026 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657830;
	bh=En1pIhjDCbi5uQnQl7d6tI2Nsu015/E0bz+ywSlsPnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VeywEVYJqBXdIqQauniLt4BbXJa9NUpolBn3UOhybWzaDzFI4ZaNrtiKQthduaCM3
	 7ScNtsc1tbnNvJ+FYgUaC4iULaL2ypvW+KMhPtsQlS3ePlnsfyOZeBjc97Ssxutkty
	 ssbhTAZfpqXmeeyJWgW2K/JHPxrFbrLydIehy2W6oxpc7Ev7qn0avjRo7la8YpNT8z
	 McyaKX0OiHh5UYGNU93CjDuwt1lUPO7gOwhZYMIT+7fxi40zctK6QLUgIlnpCBCtlY
	 5d8n/iZcLNVBe+FIP02ys6FjECfX0PDlklCu1NziY9uadmTKvuhrQM5iEB2snrlMG5
	 luOHrjHuITL5g==
Message-ID: <sashiko-outbox-214478@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/33] gfs2: wait for a pending withdraw before
 remounting read-only
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-27-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-27-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:49 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 957A0C0003
X-Stat-Signature: zmz9r64zcmn3fcexmzn81xc5h8wi3hmn
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794657831-863523
X-HE-Meta: U2FsdGVkX1/wfNyXMJkfRyMuPlEAyxMRqJg3etfbYvGiZButLHt5TdccBYCmG1nHYoGhgKA03/NnFp7/Fq3LuLob1ESN6LdJVB1dxMPvcR+UMQK3beqRn5MbI5KS7EbSZ9sL31bPM2yFJ8Rao4BgYglOPy6RKqHomizVnETxlGxb0sRdXSEaPhTEPOOAbLaUU2cGAVLLldQih53bH/JE5GMqmq4N976vIWh1xHYSkx2GnbW+4T+sywAQNOe3KY/UnFZ8nGPuC646AEyv10rzI+weZ20V7JKeNblyyClFJRR9NgGn7NRlYqNSrndfgt9hoFaxgo/EnPrrSG3JevTadW74vzHx9/NEbeAUgnUm3r5YQ022aCkubBDJa98j1ZMrgbEEfmgnT059SDKwJCAxl0K/0Y5aqon/gyBhqSDda+kuEVgBdzIj51yibaWImnbk4mxxeOzis/Jr15zIUkzVH1y8twRKMk8VeO1ZNBOuDN6qu/lrDxYnH+F/V3JkvdNKQVKYBAh/pCJnz+WptcPdcjbtFh1RT8rU1SA9gDk7dezMiTWtn3D0k8ojVo872KBnd+cbWVbJT0wEt8Z1Yl9szDhEvKtJKJmp4pDxaMBLp7h2z8SB66gOVIq6FcEKthhUTVFIULO7ENpNgS2SiylazLqrq/ODEouk95xPUOglXOXfA6Ao3/2BPbB71Dn7a6spMgYaOHXKzcj/hcoxWhsMF5zgbvtke5qjyaaBDS/UlBAIjBWmpmUqeaEoyshAgGIpILd9NNrBebN2xR8fco/rmgzFAXSrjao6HCEiOOadXBymKCqNYAeyYnIW3g/mWLw9x95GGqFHA8ql8y9x7kCIiPeTa7BaGEmoVIIiRHP/AlRv5OPcz10YZWiQPp/39qrfXugR1MGrJCwDQTCbq03ObWOSAfh+3ZBQf6VY9fz2yNvxR0fLpN7JZYJm/30l9gsL84JnhdzO1nDyoykGNyu
 z9Ko5vOT
 OqnMBAAc9rlo+4APjpqGmvS9gRYIDrBgCaxL0dXVvhGzcpi8vaEefilvr3/Ut3wtaHqLaWyDl7XPVxqGDh/s5caIjZoNK1kbQ26UDu9h6Ad+bBaeEUA6KWguRZhY0c3HidZGt+kPG/G09G+/U6M0V1SYrqv71xzFKAJfL0jHm1BVlrgYycKCXABnddKc8ybWl+pBBJwMPWNhAoDwrYLbnjIaMAsfjSTngPmXVQ4H1YZAwRA6+VYLry5HwrV6o3WVwQPdyAMgLCOu88EySXhduTNSJ8q/9L2n0DabYryyPqDJ2ANGM9OZChpy+IrFRv2KXrBXBnNc9pSTkL3mrqEiWFMEmusH3ZxIcgtsVlEFOZRg2eW7UkcQvQiKBYLxHyp8jYFLxlGr61K4Mp+g3WenPQ+zYvdU6+NwgZqaDGDcsJrT8WntEvmKnPIfUDezXO7Td2x/Ab52FNfBeMW94+sK6Q/FE1qZRGwgV/1JIbotUVy+L0OJxPt8TD2jcCWf3PRJMoJL1qLaI1zfLKtdxJykafA3Qesjhb3ECFwVxG14Zr0msVEKH8yOlvE0ezoMCPekaP/bMJ4R6MNGOoD/d297YDk5XOA==
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
- [High] gfs2: hang in gfs2_make_fs_ro() if withdraw occurs before
  SB_BORN
--

commit f8b5b1daf48e3f825a415215536a375fb6cd8b9d
Author: Christian Brauner <brauner@kernel.org>

gfs2: wait for a pending withdraw before remounting read-only

This commit serializes setting SDF_JOURNAL_LIVE in gfs2_make_fs_rw() with
do_withdraw() under sd_log_flush_lock, and makes gfs2_make_fs_ro() wait for
SDF_JOURNAL_LIVE to clear before calling gfs2_quota_cleanup().

> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 04bb4cf787d4d..f61c309368ef1 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -146,12 +146,21 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
>  	}
> =20
>  	error =3D gfs2_quota_init(sdp);
> -	if (!error && gfs2_withdrawn(sdp)) {
> -		gfs2_quota_cleanup(sdp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Check for a withdraw under the lock do_withdraw() holds while it
> +	 * takes a live journal down, so one of them sees the other.
> +	 */
> +	down_write(&sdp->sd_log_flush_lock);
> +	if (gfs2_withdrawn(sdp))
>  		error =3D -EIO;
> -	}
> -	if (!error)
> +	else
>  		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> +	up_write(&sdp->sd_log_flush_lock);
> +	if (error)
> +		gfs2_quota_cleanup(sdp);
>  	return error;
>  }
> =20
> @@ -567,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
>  				   HZ * 5);
>  		gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
>  	}
> +	/* A withdraw that do_withdraw() didn't finish yet leaves it live. */
> +	if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
> +		wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTERRUPTIBLE);
>  	gfs2_quota_cleanup(sdp);
>  }

[Severity: High]
Can wait_on_bit() in gfs2_make_fs_ro() hang forever if a withdraw happens
during initial mount after gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE, but
before vfs_get_tree() sets SB_BORN?

During initial read-write mount, gfs2_fill_super() starts the logd and
quotad threads, registers the sysfs interface, and calls gfs2_make_fs_rw()
before SB_BORN is set on sb->s_flags.  If gfs2_withdraw() runs after
gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE and before vfs_get_tree() sets
SB_BORN, it sets SDF_WITHDRAWN and returns early without scheduling
sd_withdraw_work:

fs/gfs2/util.c:gfs2_withdraw() {
    ...
		if (test_and_set_bit(SDF_WITHDRAWN, &sdp->sd_flags))
			return;

		dump_stack();
		/*
		 * There is no need to withdraw when the superblock hasn't been
		 * fully initialized, yet.
		 */
		if (!(sdp->sd_vfs->s_flags & SB_BORN))
			return;
		fs_err(sdp, "about to withdraw this file system\n");
		schedule_work(&sdp->sd_withdraw_work);
    ...
}

CPU0 (mount / remount)            CPU1 (kthread / workqueue / sysfs)
vfs_get_tree()
  ...
  gfs2_fill_super()
    gfs2_make_fs_rw()
      set_bit(SDF_JOURNAL_LIVE)
                                  gfs2_withdraw()
                                    test_and_set_bit(SDF_WITHDRAWN)
                                    if (!(s_flags & SB_BORN))
                                      return;
  sb->s_flags |=3D SB_BORN

gfs2_reconfigure()
  gfs2_make_fs_ro()
    gfs2_log_flush()
      if (gfs2_withdrawn(sdp))
        return;
    wait_on_bit(..., SDF_JOURNAL_LIVE, ...)
      <-- sleeps forever holding sb->s_umount

Because SDF_WITHDRAWN is already set, later calls to gfs2_withdraw() also
return early, so do_withdraw() never runs to clear SDF_JOURNAL_LIVE.  A
subsequent read-only remount bails out of gfs2_log_flush() and blocks
forever in wait_on_bit() with sb->s_umount held in write mode.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D27

