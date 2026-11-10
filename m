Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB4B606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acw6ROyl
Received: by kanga.kvack.org (Postfix)
	id CACB06B05B4; Tue, 10 Nov 2026 16:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36766B05B5; Tue, 10 Nov 2026 16:52:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26F46B05B6; Tue, 10 Nov 2026 16:52:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9186F6B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:52:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22E6DA014C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:52:27 +0000 (UTC)
X-FDA: 85420558734.07.3112C27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 829EC1C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:52:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acw6ROyl;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NG5N/qv9kqIWaHQubYWcMp3ybQzZkmkmYbSR6qxrMo0=;
	b=sc1+nosq70JoUPrkeeEIGDDISavbhTguQgB3ZvvYQaVCTWE0O9hVN+kZ3glWUaamM6jWXx
	TSe0b/TjAo1rjwebvUFlyQ+zJS5F9dKRtpceOLP3Z+BQiNNRAoSQwcPXkFzLSk1zHIpBzm
	8sInBlhHW+CpDb4B6BgymEcntekCTt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347545;
	b=JpJMecH+RvTX7aEO3EnClmZzuk4XcULNQZW745FvvUA13+rPEkYyn8XwnuSEUpZh8waguo
	QaMJKOb0aGkXHYU1qpQAW7Ju5jqKydrT2mPHYzjJwkJQ/HMNGcRfxFC3ZWUxhskOZew4Bo
	78KDnO/TdWeSS8UUsDslRHjKnFoU62s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acw6ROyl;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA1BB44F19;
	Tue, 10 Nov 2026 21:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF171F0089F;
	Tue, 10 Nov 2026 21:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347544;
	bh=NG5N/qv9kqIWaHQubYWcMp3ybQzZkmkmYbSR6qxrMo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=acw6ROylAoj6eTCgQIZH1HF5HgE5P5i985FgFa/sQiOMubXxw/4hpDuAimeoYHbKS
	 0SA7cNzKIUClpR0boV9m6svRkVNWvTapQsEiZPpLQHWIu8PhcvqBqPX9y4UUlZ2KY/
	 5fwYfFdUXyOFfzFfZY38g+/FK3zGeFYWShaCqv09SrX3g48zWo0/Idrv0VFBg41AxO
	 WoebTuoM7ofgzaxUvwBHUAS3R/uMOhy/D8K88+u2/Ll+1y/YvTKQAeAJSY4m5TCMYt
	 ONPv2sRQBHG3ZpoZpNmdTMDQx4GhCZL9ou3GR4YFh4AcRI3UVK+GX6nRvFAQH/csHa
	 xf2OIXvo4ErlQ==
Date: Tue, 10 Nov 2026 22:52:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
Message-ID: <20261110-zerfallen-meiden-wacholderbeere-a90ac157e063@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
 <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 829EC1C0004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: xkphpxwfjyit1om5eecm9g4o1zfoa49k
X-Rspam-User: 
X-HE-Tag: 1794347545-986600
X-HE-Meta: U2FsdGVkX19XLuDQFmRvKTG9cLoQ8x+ZndI++sNSrtbQGPKoGdLs93YWXQ/plrCVuIXUSG+IDYrNbyYMuDjUbmiBl514+asyqTOrQhAxH+IoEftbgTLErFUYZhKvCDuQHa+YmoutbrLyd8z8348A8+/AJOCO5D1BU9/9uTKkXa8TzKywAsdynWDw19RAGK90ZHnMU54FjWn1oAE/DBHhvDFWVAE79i7cjsEUMTlhBxvtuyAt4eZ08aEur2FdiLyXEf6sTMjfn0UzUSj0bmFx6HazDIh4aWYAecFaOsJnAlyPY0WfmmAy93rdSAgf/5KUw5xBXXyfLIKrz+bzYF9SUPLtwji9ey8JHYPh7drpeWTaPTwlvfbHfB7+k1mq2sybqIPMpClmSLtQuHxvdn8yugtB7FMyQuSPcUTvzO8TnI1uf+aeLIA9R2X9qNSyUSgzGaiq4QlA/OZ13uj3NJ4bZoKGWiMpnXkVHI2jv+NjOMaHSmNeigstrnEWQU3i9YqK5WLjkmR5XI6ca1UTZQhDrzIXgG4BdVYF+pdbbcl0rpydWsOiXnad5gONzvsEj0K29pMIIEjrAzQqkWvgGXF+T8VIZdNFVKrxKRaZdQZ5JOrMqwM04fkx92gppTnqcdCPxtE0cOBYz7AAlPM3JxNRRdKpgadmDDyfTv5fXROlDRdxs1W6HGUx7av8xViuLGVc0p9glMhpXeM8O0JMNHf2NJtS3FaYO2G4APC1rtwjbHWqrEV2JEGco7SESMumHcrXL3tm+qSY3aESrUyStGbkMx4+ihHm0xxv66vKYfseA4pinzWOyQjtwvCoZ/qpmPRN/mTPLX7BeBhUz0u/1wF/SSv2PepYMe/Q0dJGYgMkBJ8xkwGStSo5f1KXEEJWBTYgAiu7+puYqi61HIYF1CQHLI/osvj16fHiM4bvvkSX+dTKmliNckCAhk3tMz8I0/3l27fLq6YnNYBpTUSNV6j
 oW+uGBOe
 gts6XcvyRaz8rVxIvglpCOdMnvRJs1J0YYKI6FzzkXtw9s+iw8XCAL3wx/C4nfvTyRSyTKkjprMRUdL7QBJvSdNtdrUbqoQ+Sb0c3Y9lkIOzCnU0bZcnf7wBjn3pQBTcpE45+4S0BN/vA7YXGV8uBvGrlzHd+tYO+RizMlC2DcxpiZsv5DPpYFBAZ8EfI3wRbROtJLk4P4y3Q3Umi9f9cEtKBTrF6HAy9f1jw+TXxxlrAZQMu5vrB6RcpM7vRwyS4drrzuQ9WVAMHYsJfVxfXe5cy1rO8htt4FtfF2oI4ehrmk1mGZ7BHsvXsHzgg3pwGnfe7677XNPPVBzo+S/ywphHhySXYMTwQZKtT4sGZXrnrnck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:58:52AM +0800, Joseph Qi wrote:
> ocfs2_reconfigure() decides the transition from fc->sb_flags alone without
> sb_flags_mask test, unlike reconfigure_super(). And fspick() passes
> fs_context_for_reconfigure(target.dentry, 0, 0). So on a read-only mount:

> So it seems we should test sb_flags_mask as well?

No, that's a generic bug. I fixed that in reconfigure_super() with
"super: keep the read-only state if a reconfiguration doesn't change it".
That is in vfs-7.5.super (cf. [1]). This series depends on that work.

If SB_RDONLY isn't in sb_flags_mask it fills in the current read-only
state. So ocfs2_reconfigure() sees SB_RDONLY and stays read-only. ocfs2
is one of the 23 filesystems listed there that only look at
fc->sb_flags.

> The same falls out of a legacy remount whose flags omit MS_RDONLY.

No, do_remount() always passes MS_RMT_MASK which includes MS_RDONLY. A
remount without MS_RDONLY asks for read-write.

Thanks for the review!

[1]: https://lore.kernel.org/r/20261011-work-super-fixes-core-v1-11-c727176c5b53@kernel.org

