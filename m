Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6C0606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIy92zB+
Received: by kanga.kvack.org (Postfix)
	id 3D0086B00EF; Sat, 14 Nov 2026 16:54:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380B06B05B0; Sat, 14 Nov 2026 16:54:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296926B05B1; Sat, 14 Nov 2026 16:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 040F86B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:54:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 902E81A03F3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:54:53 +0000 (UTC)
X-FDA: 85435080066.12.36BCA57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EE85E20005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:54:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIy92zB+;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794693292;
	b=21jvakyDlMymmHKYxJNQvb+p5COzAaWtV+5a8K5rHIgGGfjCVqzbtomWajwCZyl+nP8Jmo
	fvf9LSPQm/6hqFBsm3LHuRKiqHhBMqHcYV03g8GnzSaOaUs06KRktGgsnxMFlDnI824YeI
	lsz8FiYlC9QNwuvZ/V64QVOCPCR2RH4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIy92zB+;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794693292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MU5XNgGhJm4qGtdrFglh8iv5ciWWvcUh9TpKkyBJYjo=;
	b=obrJgQ6oVWBgsReAczddd3Tf/aC78bXI3co+DQQ54e/u583sq5ra0PKbJVRKOaHtGH2Wx5
	T+cULnMmGuqvv0FfStOtnuNvEgD3PGoNfi7Q12/9bsklLzFvrXlSOCQX1uIpJ5HrfywiCX
	V4hIMHZEHpRQIxss3uPUObuH7NlXRbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E15E0447B9;
	Sat, 14 Nov 2026 21:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCA71F000C4;
	Sat, 14 Nov 2026 21:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794693290;
	bh=MU5XNgGhJm4qGtdrFglh8iv5ciWWvcUh9TpKkyBJYjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FIy92zB+Q6XXV11Bx9r1d6hblgiehsd1O2WYa4ANqHuoaMNzzpTo/kyfrrl5vWJqU
	 ntQlUQLehZaQBgb5PHB5XgsgvcpzvDKacjzaPI1D0mhsgTUlE44bsX7wUuFZlbKEVy
	 2bf9iGRkxrODGLkzXesChHlOpfKM10Ar21sYj0wFzavx9W02CRh/nVciBf1lbn33of
	 RFNAI7U3T2zGoe8QK8NctZ4IPimWP2/h2Wjo3dajkFGo7hKnMdTyDdQrkd/NIOxJeq
	 4KueXIk2XzkN6Oe+3U49dByhB2/gIMk6xuZPod2J7aymfou+3hjeBLx6QqpqyydE14
	 fsnMkL8jCu8lw==
Date: Sat, 14 Nov 2026 22:54:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
Message-ID: <20261114-wohnprojekt-rational-ersetzbar-b338c88cba70@brauner>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
 <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE85E20005
X-Stat-Signature: g3ufo3yo3iq6j9ox1ycuutqsfi3q1875
X-Rspam-User: 
X-HE-Tag: 1794693291-621282
X-HE-Meta: U2FsdGVkX19VSIxOgpmlxq8aigQAh8Lwe1+xUjfYHRLG/MWimpKXLf/3iRIfHuSE1TlPeiG2cgUBfTZW/BPT5/3VEnSmkvmVEMu3bffzv4F0IlG6fotHyWwbvuWpj2tZ3KN56osY01FnsZQ6iw2oRRZ4M3h9CgXelUhG4a7OK/mpSaLmZ78BejM6COvzG8FsWOKcS/4g6rm3fkvzTdcZrMoHiy0QpWMd6GQfmt5K8CdV3kz7E5PAaDnZhXlwObna1fQ5O0qfj9P30NlSGIDpXIVm2pWw44k1jtHgG6zlrCZXD736z1KNfbc8IosEE3Vqk9ApZeYKJVin+qi5IJ9M2bortPTvVIeEpnwQknniJuZ7/5ImpidaOQzpDRqE96zsGrKmp5RVqOse2gdcTC5PH1MkHYTOqG7EMtU6kgQ6kRfOVzHSCuqdQj61fzQX70WkEJ42RftCq0u1HNIX17Rhj0wgEUZda84r4Y29oPXdBGezNFhNa1l+Jm2KmhfIfEIWcV+Bmsm5Q7MMDRvVM2L1V8jMpepEGg7OU/PsgQ7G8cKpDHuCrwX+wQbialjWBKshzZHDy00uM243Py/1N55yaN0FPR4Mk/ljisiIiPheWvHq9Wae5mbzugX05sJZV4ZAdbncICcdUh7C7it0qXOnjFBdWTIfjOUakvW7oZ0n9Fj5lpRgIhqctkkMGc7K09LYI/VniskjuWln3iWRuQ2CyWdgR/gIHwONCHNjcwflBaH+3hwBDbgjNPAXYQ43cmHNWnXCrcs6HZLBjHnXb82uB0rep/0z3fQmh6Kl47peP48W/BFOU9/+Vb+LtnlaAD5tCK/f361OxYFpTRv4TX7irxstv4DgejmKGYPMAL5mHtwvRAypcM/4+JVzihlDhjRxx6r1QZre67DZASowkRHURJG8XYhvGJ0NByXU70Yi5UZ8SXhlpxXyiOyF2f3sb/GucqTJvasCDO7H2Rka0ah
 km+Qy5WP
 ndxn6PhQFSlweYGLZMLpLSmJUQUuoIRVBqMnVkPz9P5O7N4sJMVQibR5nyErkMnLFnAmKNmTPjXad4D3JavyweqAvYVK1jynga/uacyCPWs9i+GwXug9PzZ4FR9XjxIg+F5FPZ5CCoz8qEvKkpMLJL36YrEbPMK/+mirezRFc+ri5VXvaE11uYzseemLE8OnNiLQIncNyQQkZcApCG9SNnP+wtVcG2rqFTonOCpup0xnmNwNT5y5IkT42x7ApN3oECFJ0g3CnhEH5MBKBRrvSmgNeW9PfM9+rcYwf1YAUrFmJT5jgnvRIlsE1Kw0I4HVMsvu+1vx6Xm8TShBgwbaFsA5nytoR0CW5ci6PM0uJipQCg3Sapj3zkS3HZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 12:05:55PM -0800, Chris Down wrote:
> Not a big deal, but userspace can see that node too, as
> /sys/kernel/security/apparmor/.null. Opening it by path works in current
> kernels and fails with EACCES after this patch. Now, I don't know of
> anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
> the next patch for the same kind of node, so I think we should do the
> same thing here. If not, it would be good to have a line in the
> changelog saying that opening it by path is meant to stop working.

Yeah, seems fine. Though, afaict aa refuses every read and write on
.null in aa_file_perm(). So this change only moves the EACCES from
read()/write() to open(). But I guess open() failing might be an issue,
idk.

I really really dislike this device node abuse on for both lsms. It's
sketchy as hell.

