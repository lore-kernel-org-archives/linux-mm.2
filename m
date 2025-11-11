Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC738CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFDA8E001F; Tue, 11 Nov 2025 04:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B07D8E0002; Tue, 11 Nov 2025 04:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED5C8E001F; Tue, 11 Nov 2025 04:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4968E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:22:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE3C413B128
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:22:54 +0000 (UTC)
X-FDA: 84097786668.28.36F1624
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1709E100006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:22:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Ctp6Ovrm;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852973;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCwfGiKgiQS98umgjWmA+KBFsrU1nv1bSQtZVL8GWA8=;
	b=p0IzqPAXCR1/APPZSR3ncItHH+Zmb83xe+qEiioKSDZL3XYGn8gQxQKe6Q7SblIIyFBPQf
	L+MW3H90LTV6+fbAxkX1JpTtOxb9aFQb06iWFwYDve26RepFH9Gt+aNuNfxt92HoYiheVo
	EX38SY/nHPxRgsJwI5X57tTnFD3nWW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852973; a=rsa-sha256;
	cv=none;
	b=y0rPZysuWpWRMH6kIs7uaPur3BjwOgLH8PPmiFKdiLBkCNW6My0exwVoPZ4sS0xuN+Hlzh
	T379bZWKDygt7dA1fL9PE2t4T4htFfkbAier4iGeQ2rExOBIAxt15yLKHqQEiC7iZrBE7j
	mAOu5fzPouwfK7v08P6OHklaHkJDq3A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Ctp6Ovrm;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bCwfGiKgiQS98umgjWmA+KBFsrU1nv1bSQtZVL8GWA8=; b=Ctp6OvrmDlcVhrBE/X7ZoCQ3Mm
	Xi1Kuu3v9A9ck3YoCXmK1op9I0Yetdw8qK2AI5vba1hMAaukWnfiIROdNGM8k5hNagIn8U6f/DbXc
	7SZCLXg+DPFvAEv7YeV+N51icIvjvJ4BA9fxzcVndktupx8dikc0ru0OeO7NEL1neFlRBRclduioP
	+A1kk/KvWFGGdvC4O13Hn/THru23xl8DN4aVx/jxZMA3LSZjPRX+yCV6jcDqkkisGDgxSNnWutSwz
	Dcn0UUwFkqHJ9NqIOreSg8eqyHMhfZXRsou5CfivhK1+HdjFA+eAI2Bchqrs8kQSodD9NTx+AIU8l
	Ejvj79bw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIkaK-0000000EqIA-1xuT;
	Tue, 11 Nov 2025 09:22:44 +0000
Date: Tue, 11 Nov 2025 09:22:44 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: bot+bpf-ci@kernel.org
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v3 36/50] functionfs: switch to simple_remove_by_name()
Message-ID: <20251111092244.GS2441659@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1709E100006
X-Stat-Signature: r5p6jzej9j7q99dxdqwn1kss9np1k8qc
X-HE-Tag: 1762852972-535544
X-HE-Meta: U2FsdGVkX18cH+jcRH8BtRCOrTLIIOUXiTmSOh/U+61JxJS6l28MEfikkRq3ImNEpvyjlHSSFLQJvaMr0yQPWyTN0+txyyFmMI0VRkIC9hIcNswb/lzLmH/KPbMotkj2M1LnlRZyj1h733UXhka2SlM+ELdbEmu5586H4rwFKQ5D3hIgmtTjvabx0nWundR3wrHzg9AldSf0Mh+Pog6aPRRXmgSGHAmDfL6VlDcSTT2IiAjIhUTqXVf7SHRae2b/S3YHm3ruICp/dNuGdrAYp+mQobXTTJZrBqUhXg3nItJsfFkt0iSW5/VTn7QJiBBVSGjD/MYBcKEZyKHYIucrKiN6mWeUJo/PgD5j5hw2Ispq0chKEEw/ABoWNir4W3rNz0aU3oUVfBgKPsVYMpcLVXMvUuPA2lBsvaDOyBuFzTXEn12ajhom7FwINxJZ2GxYVZ2PslZ7QoyFxwOz0y+BIJbvq2vhKm73sW4ZJkd8j/m61VOuOGiowc3Sz6sfuWGpJ/a3LofuvQNx048kr0z7al0CwSsDu9wfVG1ho3MbOC5VtR5CZ2fMgAUKFE3BNn1zryO3k3fh8/zH4BnhrkEeF4perIc0LQYktXgqAVnRxzfmAr5IYbRjyzXZbUHrxziiBlAjW+fDsknuJYCX9FCaKqFUI7P0Mcn1K1q6g2wfKWfZRvj9/GP1lTrhVbRRvyEzjNNJ+R8QPozmJ3WQeVS0uffoUPc2BBVph1jXyz/Xj3Jij25mGdc/T8514hI9YU82gUcUcZNb3ac0MMFJvEwYOgc4xI2+KpNH6DfJCtXH70DT+EJAYavTYloXlztZ+WynMzubsBZU71JDnQuDCw3/grHG4ie6pT4v2tV1sG8gRzGpbv7iNdr+XzUm/qP+KtbuXGjaaahQVrQWRqa6vbz0etjwaYUE1DSE7w1A3j+cqamNwBatVQzeWtv24ZFbhMVx9gXuR6IB+Gow7T1Z+c9
 ygmUngsP
 ggpbFrFlOVcQKugfVQ4f2xiaV21cMUnkHxjmN3E9wSBbDF6qghFJMq3MiAiYWolSDBau7jVeABILJ9gBm72m8X7MPMsU2thGBU21BbdE7dKeM0qFwFJJ+BZahMKD7hXAOwSDepLvQ6pQeYgEOW1KQPHvNWSCc036f6Mse5Qr3GOBoWMmlgYDxM3uek/nO8aDJ3zRBlHyNez6+zyW8auVjz1ntptbvrOoFNO4PDJLBXXZno0NgZujDMpefYoZcDHSanVNp9uXeaO56QBQFHfp/bklLr7lmls0BrIC3S9qD7tQZXh0r7liTZYSKoJGjgN33ydPX+5HPpcL8galm43UWTXWtE3S8pjZ2gLDbQScWw/vclYwSLPv7MdrgLXmsCdW3RHeaguVpvw6p1U6snPf7S6xG8mWroHeGfXFv+Ist1NqAAZeWk9y0ol40c15RrJ4ZZamQlcyfnkdDygocMIW9NpOx28I2kMHPJY8zYl7cwdUvmFe3QH+sShCGF1bV7GY+UyMwsGbEEOoBaHxorUCRQf5lXbaakOMN/RPbPpMLW2mkX9EU9VnqXstqCHxna65cqD9Vz4l/Dr2vvmjfsMGcs0QNOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 07:53:16AM +0000, bot+bpf-ci@kernel.org wrote:

> When ffs_epfiles_create() calls ffs_epfiles_destroy(epfiles, i - 1) after
> the first ffs_sb_create_file() call fails (when i=1), it passes count=0.
> The initialization loop starts at i=1, so epfiles[0].ffs is never
> initialized.

Incorrect.  The loop in question is

	epfile = epfiles;
	for (i = 1; i <= count; ++i, ++epfile) {
		epfile->ffs = ffs;
		mutex_init(&epfile->mutex);
		mutex_init(&epfile->dmabufs_mutex);
		INIT_LIST_HEAD(&epfile->dmabufs);
		if (ffs->user_flags & FUNCTIONFS_VIRTUAL_ADDR)
			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
		else   
			sprintf(epfile->name, "ep%u", i);
		err = ffs_sb_create_file(ffs->sb, epfile->name,
					 epfile, &ffs_epfile_operations);
		if (err) {
			ffs_epfiles_destroy(epfiles, i - 1);
			return err;
		}
	}

and invariant maintained through the loop is epfile == epfiles + (i - 1).
We start with i == 1 and epfile == epfiles, modify neither variable in
the loop body and increment both i and epfile by the same amount in
the step.

In other words, on the first pass through the loop we access epfiles[0],
not epfiles[1].  Granted, the loop could've been more idiomatic, but
it is actually correct.

