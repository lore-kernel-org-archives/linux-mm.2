Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CFBC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F016B07FF; Tue, 18 Aug 2026 09:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7161B6B0800; Tue, 18 Aug 2026 09:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6040A6B0801; Tue, 18 Aug 2026 09:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5226B07FF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:15:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCF82160110
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:15:13 +0000 (UTC)
X-FDA: 85114436106.30.C74EB03
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8DDA1180010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:15:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=qA2e3qLG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.171 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxh5XpAHdieXwLPBDP0ROoYTT/Q1CVkQ5V4OzfSiXHI=;
	b=xlBhli4joZXP6JlAR7TJ1ozuVCYNW7nf7o6VbWSn5TBkBxi+2uzefo8kZlfSHisE/9Wp/L
	c+nf0968NkS2BMRvvFfzwqrLwVh3BuRDZJtcR03vj7tj7DKhVtyuUsEZECR+WGiiKvejsW
	z0v5GqPZfY8YCl2S2Chic1TnHFJU7Jw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=qA2e3qLG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.171 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787058911;
	b=6EwW/EH+DataQ3phs5AWCxxOJfL6FzQYHt82kS61c0iYpVdWhAeAL/HT3qXUnbcD91xVSR
	/e+or4SXWmUZ2NudW3pxol0ub8CZO/p+sm0nlN8AF1VAcc7ib/fHM1BIdGzlgD+s8CefMC
	ILKQSK/n31UzombKf5ZzD654E97e2PE=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-936c02e58dfso295720185a.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787058910; cv=none;
        d=google.com; s=arc-20260327;
        b=AiPRZJEroOW66R3P40AUHDapf04rDo+sTKiXfZNgGTEt8ThH7I2hIYQzm77+JQONXi
         PkHPsOtZtM11KEAka57mtScQKV/SGQGXqVU0YsZw1uux7GI9Wh9TTlLm5lTdGmcuaf6u
         t3a52T5780eZp2MjaayvK7BX8y9l565qpK4KkhUUgaBB4QjQ3xCMuQRxYbXn2+EOjc/M
         pz2wOLtx/id6pS9kAGz8f0PG94oBeJhsIlPbXGvRiUXusEqqMcG6tMu5ljUQudsAdu/u
         Ueg0C8Eo9aRAC8JI95V3VPRlXdtFL/8A/+5kVR/RP9V/O2ONRhmy8HOA/a4ESiFU7aVt
         lx6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jxh5XpAHdieXwLPBDP0ROoYTT/Q1CVkQ5V4OzfSiXHI=;
        fh=k9OAek4RhfMJBw/IaCIezEalbI+vpyslRMAWTSZytAk=;
        b=OGmR/UOQ7c54F8+oIGh3f6j+VfMDUNmBz/jQHrL5Zw31L78yxzt/mOc23ByJZ4Yejp
         +RZPtrhs/Ewe6ulLAWNGf9nTQ6BqUfp/UgQEPWCOfsDRW6TTIFS0O5d/cmsxVpTxvn8u
         vwcOZSTAXuzNTaxpJ9Rla4R6Tr9YIu9IRKPP5aRHc2Trx8L9a1RWJ9HN0oNQv3bVYi0X
         4ioT18YByW27kVQI/bqDSaNR7OtIjR4CWUP2mkfBSTHaVleLBsZxP9q6SjIoXZIm3Nop
         rjbByJeJZKQ/47ijwsyrSV+slp04MerTDozt6c30UShpIRpu3OSt4nQBqKjjOMXTw48F
         3Kyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787058910; x=1787663710; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jxh5XpAHdieXwLPBDP0ROoYTT/Q1CVkQ5V4OzfSiXHI=;
        b=qA2e3qLGs/0TE1fFTJf1sDdbbRfGO899pQ8QbPsZV1NFV0gcxepazY+HClfDE22yyP
         HTx2TACMeIQID2pua/4RhHNdJwJE+U34904qb3N0Xq7HmwMSxR6JV7rQrpWMQOhnPU+r
         EiMHiNPS4ZWbHCs9U5NDI8NG0D0wyEwQtcTYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787058910; x=1787663710;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jxh5XpAHdieXwLPBDP0ROoYTT/Q1CVkQ5V4OzfSiXHI=;
        b=jZ44NiKx99SA/WyQCZWkTcUOIQSYfULzxnSTcSPwjS4LDsB9/gv9DMsSJbGQlsJQ1i
         hFbzRjX+yl6DnoOX5ueu5t1gyAKVoP0R6cvDLnKc2cq87wqvj9q7e1s84kBt2ekDEpgu
         74paC0qt/DQAgWtIiBrlqEmG2mB7JEsxQV/f14z6WJLBX4BEcPWdQORb8Ps13aish2IJ
         AnxFuz3wyK5PCLU1rRXEDCCjG9qX9Fl52pWWFBs2P2dF6ZnzcVFvLwPfm6ZH9iZJcWQF
         OrXIs+FJ6hFn7G5U61gUXphxpzx3ZmsK1fhpdQpUiosy7zOWZfmQUo8PyBaa5/uw9nE+
         yM2Q==
X-Forwarded-Encrypted: i=1; AHgh+Rodc3jEHZZKu/o9hTwlnNrt1duyWy3HCGlKn50QY9t2nHS4HxF1sYXpsMFf2txdxn93qBRnJ0zbzA==@kvack.org
X-Gm-Message-State: AOJu0Ywig4X2lq4ogvrM3/Z3sGQdJLu0y7s3txg7mD7zuycBsndA8J25
	1EBZVep5PygXyMiw8f7m0r+r2zEUyTd+6mIlc5Kdihm47CsapwPONHOv7kAXceFgIiW3eDveQNQ
	LxfSz3d7Y4lBIxkgk/lddWXfm6NRCwyxcoEKK+G8p6A==
X-Gm-Gg: AR+sD11pH/fl1VUOVUGnGnei+q+tloiS7sMkqzoP+AmLAu5Ubv8but1kWpSSSHjvM90
	7BDFaMvHswxuoMCLnHSH1skcOvQtkeXnC6jOh4K4uvHZueOWFVcir+boMCpLRoAmQ1lWbHr7tgZ
	8tObt2dDNJFXpqweMPnLRaLgTvEath2CQUm6Hn1jcawv8O95aQncFXVg+1OykaBaha0z2pVWMbF
	eUgeTx3gvpsS6pkjMDBjGCTITemcwCXWUfc0+FlBwlqHGoaKp9SwsIywZLGLDQFRK1Zs2Gu43XM
	gmpmFG7s5M3ADJVb5Q0aHT5YKs26kOLL9Zlzb4ObdAD/UGhfNnX1XkbyLpd4jHmZfO933bepvsh
	9
X-Received: by 2002:a05:620a:404c:b0:936:e3c3:8cb8 with SMTP id
 af79cd13be357-936e3c38cc9mr2458814485a.45.1787058910323; Tue, 18 Aug 2026
 06:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org> <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
In-Reply-To: <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Aug 2026 15:14:59 +0200
X-Gm-Features: AcwNN1UBQAWcx1tOEiU47Frr3JyAbsHxepEKWSi_zYBw_ITdoj7CtNDGWqz3aiE
Message-ID: <CAJfpegtXbdpFZmV2dYSbp6eL0DBGmZin98TFr42nxJCfuryfrw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DDA1180010
X-Stat-Signature: wshnj9ojdntkdtr3zy9iaoxwp8zhff7u
X-Rspam-User: 
X-HE-Tag: 1787058911-551821
X-HE-Meta: U2FsdGVkX19+76uXIWsGdP7nct34bCACqQapuZACBpK2TmoHpTSX0CEMBiKfgug0i/cGani+2os4oDOzjo7rbfSA7wtNRWbIJJj34Qvke3NHDi4b0Vh5UlHx8YQMI9SAjQVdtE76l2eewPUI+7b3NfNv9023ji678Acdx/jZb1qGwiicn1xfGW3uc/e/FpWVQQ86h+6vjVy1tfjMlQZjzH8JLa91NkGox620oekQth31Wh0YrFf8kwHSFeQQgoucMfNxMIZ2iBJABbRtNWbmedlUCyEje0McY73jQQd0RF20Tw1Q1tpwK17TQf+IJoTpxRSrnVx6kOaKWDIKVrb/kYnUAtJwcIeNkewo+6KzIEUVjPqczv7OfRETovsN3a6deXWKMkkhC+zxLodUNAuEKzojidagqMJOWG50i4FWLAE59cB0R84lIUJ297Md0dyy4L3ERjdgZP46fYu77ZGjhgTe9fcMaHZezeVGA/+UInN6y+VllTrYuSSs5lq9xiGhqUzXKdXr+DykTscGntBMDJ/xCDmEh5CohnuHdiHjQfoOvabq4VCrBrUnW99UBbOuJV7nXfiTpyMjBy0BDbwroufcLyQlorRG5Oup1MpWPeRWFl7lf/S6NijKkkTNtYBMDuDCsUwDZk9lK/8zbmFPRXDRIJbNLS21d2wqTlUzvMU+0Y9gbExigrQSOK+MnHeOAGm4opwal1v13W09SzN2lRg80+GpfJq93xakNWBu/NDh1i5hVz0xYlX+yjCiDdrn5e/3Q3WRx75Fjw29XCksa8CXuVgKjhfyFh575gR7y8BW84wnu0MTVRuUazT5NToC+6PrX4XpigYl3UfmSz/Si67TvXwtkTxVSoi4BOF2yvfYhSUnDhz5ejufXELg9YyA8cCKn85T72GwJ4rOonO/+1NJOh1coULrJQsKvJGcHpdbTq34an41HFQM4EyK37C8enBqYbezY0RvHrKM87M
 ZhspJH8D
 qU/lSmothvYOYEYDK0fr+cUSGG+qCkwEFHwdRdEM2ZXBGXBxt1HNmwAenoDOABh3NEjq0kuDQDZBDUFm5ghWsaNxil8aJWwebnTj1XZj3Pg1sU85fqG5+WQkA8rMvjoco+PSI9eoXENSAITTO0vDa+WLZTpGWcctKZAEh9evzsFz8gLWkKdom01itHkJ+jVdvQTkKVwfbis3ZUbEU7QFcoNk7gWlQIJyFkoU6WcOg6hpLYsUe/t/mfEmuFBRO/vt/XmWS/RtRa5plzwqHUnI74jCv2zm/a33w+1QJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Aug 2026 at 20:00, Christian Brauner <brauner@kernel.org> wrote:
>
> fsopen() records the caller's user namespace in fc->user_ns and hands
> back an ordinary file descriptor. Nothing ties the task that calls
> fsconfig(FSCONFIG_CMD_CREATE) to the task that created the context. The
> fd is inherited across fork() and exec() and it can be passed over a
> unix socket.
>
> Completing a context from another user namespace is allowed on purpose.
> vfs_cmd_create() authorizes the create with mount_capable(), which for
> FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN), and that
> succeeds for a task holding CAP_SYS_ADMIN in an ancestor of fc->user_ns.
> So an unprivileged task can reach the WARN_ON() in ovl_fill_super():
> create a user and a mount namespace in a child, call fsopen("overlay")
> there, send the fscontext fd to the parent and let the parent issue
> FSCONFIG_CMD_CREATE. Both namespaces come from a plain unshare(1) and no
> capability is needed anywhere:
>
>   WARNING: fs/overlayfs/super.c:1551 at ovl_fill_super+0x7b9/0x1e20 [overlay]
>   CPU: 3 UID: 1000 PID: 3243376 Comm: fswarn
>   Call Trace:
>    get_tree_nodev+0x71/0xa0
>    ovl_get_tree+0x15/0x20 [overlay]
>    vfs_get_tree+0x2a/0x100
>    vfs_cmd_create+0x60/0xf0
>    __do_sys_fsconfig+0x4b2/0x500
>
> The child needs the mount namespace because fsopen() itself gates on
> may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
> the caller's mount namespace. fsconfig() doesn't repeat that check.
>
> It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
> raised in a loop to taint the kernel and flood the log, and it panics a
> kernel booted with panic_on_warn.
>
> Keep refusing the mount and stop warning about it. ovl_parse_param()
> already spells a user namespace check this way for Opt_override_creds.
>
> Fixes: 1784fbc2ed9c ("ovl: port to new mount api")
> Cc: stable@vger.kernel.org # v6.5+
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/overlayfs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 60f0b7ceef0a..60b808b85fc4 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1544,7 +1544,8 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
>         int err;
>
>         err = -EIO;
> -       if (WARN_ON(fc->user_ns != current_user_ns()))
> +       /* The fscontext fd may have been passed to another user namespace. */
> +       if (fc->user_ns != current_user_ns())
>                 goto out_err;

Just one comment on this (I know it's been merged, will do a fixup
patch):  EIO should be turned into EINVAL.

The EIO was used to signal an internal error (commit 9efb069de4ba
("ovl: add warning on user_ns mismatch")) , which is no longer the
case.

Thanks,
Miklos

