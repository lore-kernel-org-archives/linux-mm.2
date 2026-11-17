Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC601606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEaQdnWp
Received: by kanga.kvack.org (Postfix)
	id 032356B05B3; Tue, 17 Nov 2026 04:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24C16B05B4; Tue, 17 Nov 2026 04:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E626D6B05B5; Tue, 17 Nov 2026 04:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB9B96B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:51:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EACEA7D9B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:51:24 +0000 (UTC)
X-FDA: 85444143288.04.3322662
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9615110000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:51:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEaQdnWp;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909082;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jxa/kAJ15lKxFwPMTclDKch6tj8Yv9VYBIGJ7Uyr94=;
	b=Itikl+0Sv6k/H558LLJhqPd4tejtmUINJD2KLvR8boMAcOs2TAx2RNDQRQMfa9mygx6AIn
	mRhdZWV0LCipycU5/X+gAazIFghF6nf3agCZYzENYxcdF6YeKHeHuQ6/T8KRqAYs0uIGjZ
	iA/NTRL3VqGt3nXazaYF6DjappL/lpw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909082;
	b=b8dJkBAv08S3pkBHTG8VEbM/bjfrGxLm9hbldxo6upwo5id5EX/WdtmddtNH5vH0dMwy7d
	Fk+79hDA7oWBrF/8KuJjgMyd0IBsBW79yGKkLaSrcnuXpgv6XCC8PMLnK7lf0DRmou5liJ
	D5xMZvtH7NNaWq/t3DUBVSW7p9m2Rew=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEaQdnWp;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4D8C40D5A;
	Tue, 17 Nov 2026 09:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4889B1F000C4;
	Tue, 17 Nov 2026 09:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909081;
	bh=3jxa/kAJ15lKxFwPMTclDKch6tj8Yv9VYBIGJ7Uyr94=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YEaQdnWp9hLwkYUqGOFX0ayap+gXO4krb2XydLS1lZQnWRN9mW1DgoAG4nPAJpDOy
	 pfUCmXWNeUL8Br7oRTKmpxSsIdEnpvdaX+xY3A82MHrz+bHj2tY26UM/x+F5IJwujk
	 tCIOyBrC+xbzGTypkKQbaiHAucjtsWPN9r16XNy+2psAaNcF5MSnlOPBQ6/GplVHao
	 8sD4sDgR2oqlCBHL/saxmEDR9ydixLloNRC/oo/BSGWswAyzaRYrGPXVVw4F/f6CBt
	 7UU8ZGjkiAadqywtCMlLpDyA7pp+gEoTO83zWGwc7yjQb7XSeKOCPEcvXIPjCKulnV
	 FMySy8Hm2ydEA==
Message-ID: <sashiko-outbox-218534@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] gfs2: don't BUG when remounting read-only after a
 withdraw during mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.com>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-1-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
 <20261116-work-fs-sb_rdonly-fixes-v1-1-95a25ce917ad@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 09:51:20 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9615110000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 136jf5z3ofzynjc6hwhj4kddpto14ri7
X-HE-Tag: 1794909082-669237
X-HE-Meta: U2FsdGVkX1+2/j9TmseFOCkRXR4LcEM9nds0dMhGeb6+Vk8hFSC8/br83yS4njK0GrF+HlTgbq4neopEHIoAdIXb43zEI5Uz9FaS+y2m1LwTckrIqp5NuVb8pWSyyWoMBxUyUHslOWM9wMfQ8booGQc8l0oI7nEOUaGQc0Hjv8MUfv+TV+orifHys9R4Xncu1qwfKyFinn3BxVWtVlbKShi6EPpPkYBCxh/43iF4J3oZcMB9DtVPKz+Y/sU2d5VSB3wx3MlcEHQI6WDdiUYT+pLSmofDhCdkYv8/8YbuYer2DPZCw74FJF926hziW0mvBgHbZbc5m2G/RG924/ywPbU5OwtdiTO/4+TIzGQ/Z/XH3UJvDds1sKh6shPnaKGuXscJElOcjr4t6oY6L4cZY9SRsdcUyNCGpV4AcmfxZtrvXYuxmJeSNT9ihIB8MGMy4iDLp0Qw5bx1aaVkoavTi1Eml3EZTP3AQfljTJ7qgUOEp0VEi6i/j4ECHVbRJtUOtfi9OcYjukerFGclR/9fuLWLmf3txoA2eQYw5LRRYhDBHlACOtCxsF9DsqQaBSr1OrE+TUDGVfMxzxAhIEeL+5fJNHMU+ut3P65UxwvMwQLYlKI1kKjba3AMEZEk6klB5iOvO279PJT9D6o+dSIfLrKtfRlcIOTqDw0HqQYVTQIGsiEKbHxs009WgxblZkXBmhJ3/GOG3COExkUGI9TZn3nMO28RsMsBrY9ANjJMX6lyTFBKTdmB2WCw0HRCqj0pg+aD9aAirV6sYYzxqMsq/kU0Fbxi5Nx+842CHkPZMOkR5QPcZZXoArCG+yV+Z3vk4X3zZtd+gcKIv2WiaKl1x7IaDagh88b6QFsOyuTef0tkWgtrj0e3mE8/4aO5CzDqY0hsFTRM2AkEo5EXw0Irmj8EfyAE6llTbUg++JSsgmPmB5a4tqAKXA2SbItAecKiZ6ImZAGSQHtqnIsUeG3
 aCF6dPuY
 b5qV+pir+VUSxoD2PSTPt1QyZkP7L8jzMplt4W1Su+ilQ0jWupQ6jH/hdvCA4LVd9d1VhXrNcLfuEHSz3YHBxjQPt3tLrLwfTV2wf5Ee3rw7wkd8niIiYwEFv4cPNuMmZs6lzj4walmZ0cTJ8JH0Ai3nPpo9lAhej3mu4VbawrIDZNwuepmpJwkivNwGEdfbCbrpnNf8Bc47eoDvBfud6tsDggxqrOMbnM3iNNYGZq21DUtog0hggkbEdfRx4F2gtiOBhSH02pRp7A+Qk8eL2hfqcvvA7COYPQw/ndD1YtfsTuvyCM9/NSzxT+5Z3C/r4fvx3fVG5kb9Co9VtUpcmZX7xVcLGHpZCtGUxU2Dsqq5knYlbk48y7uXoyGj+Ar+J/XmAO0AhpCpvz9CYb9HVsmvBq+a4BWIwwFJRPGxJnlxhfDUfH1vciG1oLgGTu7J89WWEupXKV4DU2fnlvmDZltbVEYUsQ1MbD7RIGHmUdI78cJIip93tSdHN2lmJojGRhsSaquwU8k0sRmjVXwQGM2oU/KjOxDN/w/i9HAtr+ZPmN1YbKaQv+4tKTnkYvS9Ifph/ftOm4bLkL4KbmJidzGTv7g==
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
- [Medium] gfs2: race in gfs2_queue_withdraw() lets flush_work() return
  before queue
--

commit 3d2897f8b51331dc6f7b51a37f13ef421ac6739b
Author: Christian Brauner <brauner@kernel.org>

gfs2: don't BUG when remounting read-only after a withdraw during mount

This commit introduces gfs2_queue_withdraw() guarded by SDF_WITHDRAW_QUEUED
and flushes sd_withdraw_work in gfs2_reconfigure() before remounting a
withdrawn filesystem read-only.

> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 6ec47376aecf2..3bd5702535dfe 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -1590,6 +1590,11 @@ static int gfs2_reconfigure(struct fs_context *fc)
> =20
>  	if ((sb->s_flags ^ fc->sb_flags) & SB_RDONLY) {
>  		if (fc->sb_flags & SB_RDONLY) {
> +			/* gfs2_withdraw() doesn't queue the work during mount. */
> +			if (gfs2_withdrawn(sdp)) {
> +				gfs2_queue_withdraw(sdp);
> +				flush_work(&sdp->sd_withdraw_work);
> +			}
>  			gfs2_make_fs_ro(sdp);
>  		} else {
>  			error =3D gfs2_make_fs_rw(sdp);
> diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> index 529c3ec37a18a..5558af374994a 100644
> --- a/fs/gfs2/util.c
> +++ b/fs/gfs2/util.c
> @@ -238,6 +238,13 @@ void gfs2_withdraw_func(struct work_struct *work)
>  	fs_err(sdp, "file system withdrawn\n");
>  }
> =20
> +/* The withdraw work must only run once. */
> +void gfs2_queue_withdraw(struct gfs2_sbd *sdp)
> +{
> +	if (!test_and_set_bit(SDF_WITHDRAW_QUEUED, &sdp->sd_flags))
> +		schedule_work(&sdp->sd_withdraw_work);
> +}
> +
>  void gfs2_withdraw(struct gfs2_sbd *sdp)
>  {
>  	if (sdp->sd_args.ar_errors =3D=3D GFS2_ERRORS_WITHDRAW ||
> @@ -253,7 +260,7 @@ void gfs2_withdraw(struct gfs2_sbd *sdp)
>  		if (!(sdp->sd_vfs->s_flags & SB_BORN))
>  			return;
>  		fs_err(sdp, "about to withdraw this file system\n");
> -		schedule_work(&sdp->sd_withdraw_work);
> +		gfs2_queue_withdraw(sdp);
>  		return;
>  	}

[Severity: Medium]
Can flush_work(&sdp->sd_withdraw_work) in gfs2_reconfigure() return before
a concurrent gfs2_withdraw() has queued sd_withdraw_work?

CPU0                                  CPU1
gfs2_withdraw()
  test_and_set_bit(SDF_WITHDRAWN, ...)
  gfs2_queue_withdraw()
    test_and_set_bit(SDF_WITHDRAW_QUEUED, ...)
                                      gfs2_reconfigure()
                                        if (gfs2_withdrawn(sdp))
                                          gfs2_queue_withdraw()
                                            test_and_set_bit(SDF_WITHDRAW_Q=
UEUED, ...)
                                              --> already set, skips schedu=
le_work()
                                          flush_work(&sdp->sd_withdraw_work)
                                            --> not pending yet, returns fa=
lse
                                        gfs2_make_fs_ro()
                                          ...
                                          gfs2_quota_cleanup()
                                            --> hits BUG_ON()
    schedule_work(&sdp->sd_withdraw_work)

Because test_and_set_bit(SDF_WITHDRAW_QUEUED, &sdp->sd_flags) runs before
schedule_work() marks sd_withdraw_work pending, CPU1's gfs2_queue_withdraw()
can observe SDF_WITHDRAW_QUEUED already set and return without queuing the
work.  flush_work() then sees an idle work item and returns immediately,
allowing gfs2_make_fs_ro() -> gfs2_quota_cleanup() to proceed with
SDF_JOURNAL_LIVE still set and hit its BUG_ON().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-fs-sb=
_rdonly-fixes-v1-0-95a25ce917ad@kernel.org?part=3D1

