Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C19BCD98C3
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 07:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DDBC8E0007; Fri, 14 Nov 2025 02:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4BD8E0002; Fri, 14 Nov 2025 02:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2308E0007; Fri, 14 Nov 2025 02:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD378E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:59:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1746712DB01
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:59:03 +0000 (UTC)
X-FDA: 84108461766.10.2B4D412
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77822C000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:59:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=QNoFj+y5;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763107141;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BX9pgqKetmYXWegrY1jxWDAubueY2L9llfmksDJZ7o=;
	b=hjVAYBsqDgUTqiJV6czMQKm2fBSIc14dRbngbxlYlQtKvj0P7xwbxYG3e4UKuXB2r+DiEH
	5dR3tudySpXJrd3UqHXcErFujBPomH4aPd+Qmoh2n4l725Ud6Jhfy9mIxUHlGcqAMImb3+
	yJTvMySnUwhiUJAZbGyWd0Ltlr+OH1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763107141; a=rsa-sha256;
	cv=none;
	b=fLQSyyR4fFMaSZ9Z1oqLSbN/MWT3ptgIofLazz7UcES5jEFVzvl83RlISJwHr67NTxRCnL
	4WNFReZO4jxX/3eL/ZZvapM0nPagYNmEByXNR8AVjMvlPsiCyoRwjBqzyX3+ZD7ryhqBTP
	tEw1D4vMUXrynXtbyjjJok8x7Fqs7y4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=QNoFj+y5;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+BX9pgqKetmYXWegrY1jxWDAubueY2L9llfmksDJZ7o=; b=QNoFj+y5vkEvXZb61fdoJLx6e2
	Tc2JO92a+37E6aeKDBwJwdoYW8Dhep24cN+upN60xBcxtlg9v4K+oKBYswCsLpj+mzmQs+a30I8kL
	O9aCdsaJXsC0AhvA/uTMGAqQd6nHWcpFUDoKuVF4LQtUaU/qyHG5eNRvy86Eyy0PCuGnCZHaGszRl
	mW65m2RQX8KZ7O7g/GxFppVowqrruAkJ7W0Q5HI3ToyLPOYtngIf7chV5mMITZupTtlj5q156Q84B
	+O7EZ38GpdVxTMxzVjbchFWBMU2VFhoO4M9gkNYse+lZg1Z80PIoUePe1y5NUxAC56AoOgacVQ+yU
	yRE9z4tA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJohq-00000009fzo-2VEk;
	Fri, 14 Nov 2025 07:58:54 +0000
Date: Fri, 14 Nov 2025 07:58:54 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Chris Mason <clm@meta.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bot+bpf-ci@kernel.org,
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, ast@kernel.org,
	andrii@kernel.org, daniel@iogearbox.net, martin.lau@kernel.org,
	eddyz87@gmail.com, yonghong.song@linux.dev, ihor.solodrai@linux.dev
Subject: Re: [functionfs] mainline UAF (was Re: [PATCH v3 36/50] functionfs:
 switch to simple_remove_by_name())
Message-ID: <20251114075854.GZ2441659@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <3984c9bd-2ac8-424e-9390-7170fdab3c03@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3984c9bd-2ac8-424e-9390-7170fdab3c03@meta.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77822C000C
X-Stat-Signature: fjf7hkqgt1buph7ab8iy64du69t56rch
X-Rspam-User: 
X-HE-Tag: 1763107141-973857
X-HE-Meta: U2FsdGVkX189RR8/C+QdfEZHPbwEwh1J41aUwZa8QOMR43NV7nsv5ozBbMnhSUoKgEvBG8uUmhHyk9Z2A0dZtKIr3/lDmiMnFranITac0PaCmcrC/8KPnNlygfCN9m9tzEnDQS6o8DKr0XVL5CkiyRK8SvyNe1+COwOmj8QI6rABRcgtOtK7A2k+xDlnfPS65Idg7Oe+RgRrY7fDmK+hAn1JGp1vXO6T10nc5zPRpHcX6tqZMaw8+Lbb4i7HKdu++8ZtlRHup6Radttwh2Hq/548CBeCKSCSaS6gIGIWtorJijaxz+yPlUe166zW5U2c97X/Yxr+K6KiG22pMp6CcGDIkiTfkmzd+l2sp/AM+iolM8yBxqApxLkjcczLfN9gocHZOIDB6jx8UcBlGdjqZAYZw59SvdZsrAqjtBjOqXonAuttSkSlTIecozcyMc6oGTS9GrTZRYSYrFMQ8afUqmc4s/a+nf48tznVVlByzRU/NDuMnZDx9idL3Y23yX4tfOBDQOExyj3FZYSIfTc46DjX+6OKVdnQBpgaz1aLIX2xjQWPZ7je80RW63wj7zt7fC7YWc8nz3FA92bL+VoVYQXvDs7Cbb5MOPtU1OgeoFBSqbVdONimf+NjRIpjGnbYrJoyictT7Osf2IY3NOxKYQi5hdTtijlIE2fIgsW2T4KQ3MRhCXkacrGgZkrCI+faVo3A52F+WiKFgfpntTaTHRX64fn+cH/YphykjhyOVkaPoOvYKUc9Kpbm5xbRL12Kx9joIesU4Bqgi5vw6q5d2qmbR1Su6/knhoHX/SorAbaJl5SGG6VRd0GVHtRwaqFCAE+dbPxVWyomZfovcS6lxerwag3FqHuU09qA7ewMOzRaoglITtLWv5KnTHQqTZERs39mKZbMA1LyMFBENgELRQOCSoh3ey14JogelagqWcoQ3FGN1NSSf+O9V1la+L3BAGJt9s9wVcm6WKOUP54
 ExExedRA
 uqJOoHEcvY0FAPFQd/lZEG5yv4SL947mAcz/PjFWa4oLzklhfLiFJaBfzFwTWddwtuzQir2ph42rcgzk6FppLhYGg4PljNqoVPT8Pkt9NbONOzJroHiXbgSmHv1dQ5UyfNAtHE4h4NHzvXKhjT5d6UXWnozheaVSaDgXbp3IbG7gmuR9k6BsC3JY0Y/coNe2wUX0h71OSg0Dmt0rXqXr7Vx0W9MoxLVnErZHR6GrpdumD6zAEkwmADaXx24u+LYWYQHW+OGYw4K+e1j93MGAd4gDWyHLLTRMIzq6x3qnkgyJgaRVtI15CjYFGOXZgzamOuZBsm2eyY2AlEnURcirc87mnrhsDFbRI9lV2mjMDjerOWQPpwVot4rvFNyAFyd/cf2HP0TYp6Ya09EkxvYVPhZe60VdL7ehc7wddohQidtEAhd7Fq03XWpBQxQ5HAknRwmWnJ+N/ECsB1p+6mo4nfWVeirj7p0RSORgvubVsWMD4EWm4INumASbDwnf8lOb/L32/5+YXVaMrUItBK+PpnapzoRVB1bplbPf3MTCfD1dyIfb2ULaQJQAaeXD4BLblP1qB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 09:16:52PM -0500, Chris Mason wrote:

> ================================================================================
> BUG #2: Race condition in ffs_data_closed()
> ================================================================================
> 
> In ffs_data_closed(), there's an unsynchronized state modification:
> 
> static void ffs_data_closed(struct ffs_data *ffs)
> {
>         ...
>         if (atomic_dec_and_test(&ffs->opened)) {
>                 if (ffs->no_disconnect) {
>                         ffs->state = FFS_DEACTIVATED;
>                         ...
>                 } else {
>                         ffs->state = FFS_CLOSING;
>                         ffs_data_reset(ffs);
>                 }
>         }
>         if (atomic_read(&ffs->opened) < 0) {
>                 ffs->state = FFS_CLOSING;
>                 ffs_data_reset(ffs);
>         }
>         ...
> }
> 
> Can this race with concurrent state changes? The atomic_read() check is not
> synchronized with the subsequent state assignment. Between the read and the
> assignment, another thread could modify the state, potentially causing state
> machine corruption or double cleanup via ffs_data_reset().

The atomic_read() check is utter bollocks.  ->opened starts with 0, is bumped
on opens on that fs and decremented when files are closed.  How could it end
up negative?  Well might you ask - there's a call of ffs_data_closed() in
ffs_kill_sb().  _There_ we are guaranteed that there's no opened files (we'd
better, or there would be much worse problems), so ffs->opened is known to
be 0 and ffs_data_closed() decrements it to -1.

In other words, that couple of lines is executed on call from ffs_kill_sb()
and only on that call.  Which is to say, that thing is just an obfuscated
	if (s->s_fs_info) {
		struct ffs_data *ffs = s->s_fs_info;
		ffs->state = FFS_CLOSING;
		ffs_data_reset(ffs);
		ffs_data_put(ffs);
	}

Not a race, just a highly unidiomatic code.  While we are at it, after taking
that mess out of ffs_data_closed() we no longer need to bump/drop ffs->ref
in ffs_data_opened()/ffs_data_closed() - superblock owns a reference all along
and it's *not* going away under an opened file.

