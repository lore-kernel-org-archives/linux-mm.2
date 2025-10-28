Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A9CCCCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B3E8E0013; Tue, 28 Oct 2025 17:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C9A8E0005; Tue, 28 Oct 2025 17:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B9D8E0013; Tue, 28 Oct 2025 17:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A92A8E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:35:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 526E31605DE
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:35:08 +0000 (UTC)
X-FDA: 84048828696.28.4B5E79F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 46F6910000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:35:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r93s37by;
	spf=pass (imf14.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761687306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDsqZFSQoDFk6Jgv3OgSzqGmp9ygmJ1z30XLWqHxNxA=;
	b=p2P6qZ/jNgpgzjAqIbPZ0pKHPxrkgghwDtjtOPxjy+rIKIezIN/82wVImSwRhnLEJ6G4dz
	OQdTFAAWHQHY35ar4gzkKEFIxhuVdjvjGLVrBEIjA/ArfSl/zLOQEHoxV0dfaR5VXQt1pg
	Psl86FFHMoYkHTWrJ5RthK8qlAg3z0c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r93s37by;
	spf=pass (imf14.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761687306; a=rsa-sha256;
	cv=none;
	b=L0feIIz9dm27rFMTyALgadIOMYDUbdjzHL5q9CjbBmlmCbBTYQ3xpUgs17BeKe8MbxgTiC
	Uvz91bmKbu+NIv+yEB0/ltKhuwEwONzC8v7x6bowGHKszsAgQIeDZtJ+2FF+Gh5BDrwhF+
	AQ/rur2vHjn8ahr7mHNd7t4D3lv5X9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DFBA49161
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4830BC2BC86
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761687305;
	bh=R2i31H9vGUKt8c9pEDO8kNOSs2JZfSsFlvxECOPAMbQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r93s37byBu5Kqu2QNWAApFRsKMEiKn+rnGBu28Yh213bmXlXtpGYHy6Md1GZVj5bM
	 s5vnSo0yrYRMDPmHpEUorqNbrzfUbLmxqipY4eXZSatd2x/wYVLZWkfxLbVUyrJnqB
	 qzzqP0cqOIMCM1+yieYa4Jpw8ExK8yVQ10CoTtDy/YpQpSoWeYoXUNtfhEmCx16Hlx
	 hAutjjpMeCNc9SkrGfI4cOnOn4oU/nFvmIHsnMpTitKiMXtsQmuipZbmLKSEJQNkuU
	 lggI9QCrsvI59YWcEgE4fHKT+JxK/C1s0+GH6Knmt4VFXcIEFUXIvCxgclL3uQke9v
	 P+fvzMKknG1XA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-592f5736693so6849181e87.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:35:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXa9hBfaj9vT+rfzIiAA+LaqKO3k3wu6QBhMSdwsC0dpCAum29iO+gR5LLdI2QlZV5paOdAK3sw9g==@kvack.org
X-Gm-Message-State: AOJu0YxH7pxDNhNKOY3K+pqwchX1+OHVlGBioQIZ4m+JF9ed3ysDwTqv
	4NsF/RAbWodS01kpl9fcYVhvD2MRBwLna+6Un0mMR6GTu+R/pLMAOpQraAeo72Oe3UFMgQVlEZ2
	Vz1JWVH561KOd2kiJKtOuZic7CYGRIOE=
X-Google-Smtp-Source: AGHT+IEUgTLUAIKN7pUG+BuUf5d2rQVkYmo1LrGvDv+SiZ+/7mc0PZPnIKuDcBIJFaSVmyoUk9OgmOBn+4n7FgjOtLw=
X-Received: by 2002:a05:6512:3b0c:b0:592:fce6:9054 with SMTP id
 2adb3069b0e04-594128c4f37mr242551e87.52.1761687303564; Tue, 28 Oct 2025
 14:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk> <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV> <20251028210805.GP2441659@ZenIV>
In-Reply-To: <20251028210805.GP2441659@ZenIV>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 28 Oct 2025 22:34:51 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
X-Gm-Features: AWmQ_bkR_zy3h447gWqfy_yWS54Z8UsgWDqAQbawTspKnXeI6tlX292HDo0fyss
Message-ID: <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
Subject: Re: [PATCH v2 22/50] convert efivarfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, 
	selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 46F6910000F
X-Stat-Signature: 6buhbktxktt6r5ototymosyznbeqynyz
X-Rspam-User: 
X-HE-Tag: 1761687306-32312
X-HE-Meta: U2FsdGVkX18ApIe1oh9n0QSi9Dv82x3FiKFaOFZCh1pvzIdhzSFAPfhRWv748C2xD+PGPcH6Mp3Rh5HzW4ybXpsJpUJKTtRntpzr2qrb7gd9PZWoiEZ3qNDfMvkEWCMw2sI9nCCjFSCjJydnSrY/fwubl+jVr6m+oy1xSQGrmglzrGzhiRZwLGls+7eShXqKYRoJXQeqkfvpbZQOEcn9sX/aZsH5foe9sRdxhQsYPBmzoH7LxMlhW/egQIV4THb4wy99JME+cl2PnaVxm9xjHgCVp8h3cpVOK146eM9d/eh5obbEUQP2Mq+k9Og9bhubK0Una+6srtRNQMCcDRrBonTmVbC2WgyOWFLqTb44AqyqISqMD54Kv8r4bDMeEoOY7WSSnImk0/Vetq4jRtCWnAnLo4B/ZiNGrylfmd3FFX0q4p6LHjkRq8xq6sFK7BKR/cAucK2b5UqqTm9zxGhXUaVe6lB9rMvOWM6VUaaHSU3lzPOsZIUDdxHDqE748l6bl4RJmoLeC4BzHXv8rc5mf5AdczOcdho/7p5/eEJzQcQOKZLq20Uv4x1LuQQN2Ji0yk81o5Nr66S/PfHUP+8UIOKscOljGQ4q+jHSKU/W8mN07G4EOAomw3FXxpYRvHMXCjA1j65P3OkrXq+3dSdHBa1x3qVkofqn9qONz9buUpD1SgFOCF+XbQABjZ2PWipyCpdIvPwIWO3p2+PwTGpaer0Q5qOxJ72mnX786dt/p2DeFun7FH6vWhSuYvCQflfoIl9FBs4/rugtH1pbZmon5HtYSLlORw3H37CBHxvfji05bexxTkRtWuu8aUlzrmmRrYhSd9kzTahVpb5lZ5es5NqA2l9oD0igODwh7w0nZ/Q8Ydy43+19sc6Kj3mYVD08AzHSATTQcd+MbmgLQ1/abVf+jV7/M55/DjL1urosRAivDsP/Epkvzx9cqQymiuLqBOZ7i+KyQwdwHCEvdjF
 HTe0WCm3
 6TSNUFydAnr8q8zHd90TQnfZpQ0dG9zX+1XYZc4aplyYiTaKQ68BPWBXl7pcDZnsp4mtBMeOnmnK6awhdU2nOpnD4O9V+ohmawpswSDfKn3AdEP0EvHk7uu51m1bTNy98WfmVDP8tRG881dV+BeDUsvQ4WuZwImkqjxXeXJMRdDGdr2HbOZoxy+2r9tqpfbbw/9xgxA58y1uNjLKHqKz8J71/6ejG41kyMUNF9mcghfS/5JQDNvxDvIMZvejhLPgFs1Yp7rwCUgJ/zQCljB1V0A4PIh2NruuTpfpJEY3roDL4bWmuGtPvBEWOyZ4rbTWZSDPX2mAf9lqUFHT7tV0uZRANMd1iLqXJfvby8fzMfpOUyoj9xI1EPPlQDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 at 22:08, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Tue, Oct 28, 2025 at 05:45:40PM +0000, Al Viro wrote:
>
> > FWIW, having a special path for "we are in foofs_fill_super(), fuck
> > the locking - nobody's going to access it anyway" is not a great
> > idea, simply because the helpers tend to get reused on codepaths
> > where we can't cut corners that way.
>
>         BTW, looking through efivarfs codebase now... *both* callers
> of efivarfs_create_dentry() end up doing dcache lookups, with variously
> convoluted call chains.  Look: efivarfs_check_missing() has an explicit
> try_lookup_noperm() before the call of efivarfs_create_dentry().
> efivarfs_callback() doesn't, but it's called via
>         efivar_init(efivarfs_callback, sb, true)
> and with the last argument being true efivar_init() will precede the call
> of the callback with efivarfs_variable_is_present().  Guess what does that
> thing (never used anywhere else) do?  Right, the call of try_lookup_noperm().
>
> Why do we bother with that?  What's wrong with having efivarfs_create_dentry()
> returning -EEXIST in case of dentry already being there and turning the
> chunk in efivar_init() into
>                         err = func(variable_name, vendor_guid,
>                                    variable_name_size, data);
>                         if (err == -EEXIST) {
>                                 if (duplicate_check)
>                                         dup_variable_bug(variable_name,
>                                                          &vendor_guid,
>                                                          variable_name_size);
>                                 else
>                                         err = 0;
>                         }
>                         if (err)
>                                 status = EFI_NOT_FOUND;
> Note that both possible callbacks become almost identical and I wouldn't
> be surprised if that "almost" is actually "completely"...  <checks> yep.
>

I'll let James respond to the specifics of your suggestion, but I'll
just note that this code has a rather convoluted history, as we used
to have two separate pseudo-filesystem drivers, up until a few years
ago: the sysfs based 'efivars' and this efivarfs driver. Given that
modifications in one needed to be visible in the other, they shared a
linked list that shadowed the state of the underlying variable store.
'efivars' was removed years ago, but it was only recently that James
replaced the linked list in this driver with the dentry cache as the
shadow mechanism.

Relying on the -EEXIST return value to detect duplicates, and
combining the two callbacks seem like neat optimizations to me, so

Acked-by: Ard Biesheuvel <ardb@kernel.org>

but I have to confess I am slightly out of my depth when it comes to VFS stuff.

