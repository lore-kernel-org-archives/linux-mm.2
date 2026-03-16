Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 954A4F46455
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD17B6B0249; Mon, 16 Mar 2026 07:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3A66B024A; Mon, 16 Mar 2026 07:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA836B024B; Mon, 16 Mar 2026 07:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEA676B0249
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:58:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9906413947F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:58:47 +0000 (UTC)
X-FDA: 84551779494.01.451AFDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA63320003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:58:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KxKI0hh+;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/5naQfJD/dgTGkYANr5USE1OHbs1wbVp2alJevzuG8=;
	b=oFAgqzF4drm0tSRkUV1yjnAefMi6n9T6VzR71L/cNya5tKc3u0eifWVXJns3xdpoYnKx+b
	DG8NEFxXI2lzP316pYD49q7n1jyv1+dZQFURtun0ta6zszdNexdEFbnhIlPWImAgn5Ytaf
	9D9dUV/AYgTJDYv1ly0HUEXqmD9VW0A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KxKI0hh+;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662326; a=rsa-sha256;
	cv=none;
	b=3JYTChTO4/DPGdZIUPlS13MpSkupfkkVkRSZVVjjuRkJnSXeBnemmQ6ZbuTGSTYh8O1t0h
	lBDzkaylpHI+kBaRpq8TJJdDfgcb8Kyr189WTd9RVrYH/vJhmkx8eYi2gjNLRJ+/+DOBf/
	UUTshVXfbmjjoV3Ayfs9v3iQ6kqIGEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AECE74185E;
	Mon, 16 Mar 2026 11:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8449DC19421;
	Mon, 16 Mar 2026 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773662324;
	bh=rrE5Vj5KyQR10HsPKqLkyfq8QlELFpCqN8N/EG1BaUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KxKI0hh+RhGlKGzvM8uZBH5xd/1sd/cB0NMneDnMiqp942oziGbcXOZpRVHZ2mCS9
	 ubUNuMMKzCbca7S84UCPgMheEWE4mAH8pqqorePctu614AU3buhsFFWGzO+2eFlm/0
	 OfIBQ5QOM3fGfkXVc2JnOuljahN0LPuUmy4mqOPXSK/iXg4kv/iXTzDdiqvuCmj9iI
	 NwrytAo3k6eWpqlX9uIGO/KG06lZdrCHANw4emXjBIt84+oIh8L7WYzajQI+JBJLWj
	 hTCLk3JeJ4hJrGVvR6/7p8sUk2F7fJEm94s7n5DW8C5tFYMUu7WY36mMv6gMOIu6vQ
	 CxCR0QZz/Ehzg==
Date: Mon, 16 Mar 2026 12:58:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, 
	rppt@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in copy_from_kernel_nofault
Message-ID: <20260316-fachtagung-gelitten-17389c00b6c2@brauner>
References: <69b7d9f6.050a0220.248e02.0112.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69b7d9f6.050a0220.248e02.0112.GAE@google.com>
X-Rspamd-Queue-Id: DA63320003
X-Stat-Signature: d7pymqosjxc7h14ybzks6e1taxc4ecx1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773662325-558571
X-HE-Meta: U2FsdGVkX19UrLQVY+jdmYo2dlPtMZE5CG83kR50GDTDxEzUYGRqkMJxWtVdk3jGxuyte/nPAV13uGvqVMKcWAug9J5lAl9JCdKtl4DD5vQH8OlRcpb/VBiBDRC+SlUQny1FK9qDwgq908XUMmbmEgh31I5mJeX+9oS1qqlWbTv0zVId+lQZXnSpGqNdsrMTi4x1+c7jCD+dukSpsm95wc6MRs5iMk78EpqpF817KGN7WNLIy4jFtVIgpuf4PSlHXpQTwU9DAqnH96AbfYZZzgwoOpIzlh7IW9gK7cv1+9N5r1w+qxz0QKD9MT02Uw7nO8Kw/CsnoswAE5ipxrx5pSTrhpR9MdVY7Nl4iQ3NmmV1+louxWABbep7dz9ltfO/aPZh54AddRJdoAk/X0USyFHt2ee/OJ75mzedO7ymeBgyaok0k5h9Lym2+4K/EqONUXteiOmqdsl3CcAG/FyDgyeKmsinknBF8stAbH9jdGhhsFtbcNKtvSawp9DXJxxE1zvQadGxjhUvKK0yHfcM2ZjyZHU36/M2mnns0r2veUqWdLJQnJatSOutepfnTlzp1VRTlKDqICvNZhZo+CRwDv/6FX+/DGPFGado5AwTFoTxwmGzZCGAJJ549a09aKL9IRB5D4Tm3TaDgPliDqdfMdJzj1+wAxzl4kErkja9xbrLfqdb+btwgfTOjbv6IbpDutTbjqSnKY4z635uurdbJsKbbH204SDPLkxur6k/PeBELMOpE42+TB5hEgWs7Ah9qPPBUGtqYD15A8GhDETuuE+HX6i/jrGXVhcctipA8Y81dpn9UX/KSvtIcVBCcwAe2j8CbEDEWEg8NiuKXf6OIokgfWPeLAGJZBvNO+iHzxxW7AeHUbN0nNpZMJh506LL4tVm5LHBXSMk0u7f432kb/vKry3o5qiuisKZh8kRiTkq0XV6n/T1pPNoufwIttnsU5lrgCxxrvWc+XwI0ST
 zIUDxa+d
 KzBPLeNxQ2ANib3gq3ewD3xEolqqPSYXd5Xtx0RMa4mlQe1eQJkZbnuqF2EwfUI1zlft5J9eRQbzk8/6Sq7wIQGZ328qvkuQuv77nl8TX7AGd8pZtHaEBuqaRe8MUu1Mxygx0jDHwO8PfjyBZx4xcbTu26ikDI00l3D44K3p4mA4FrB4Mts5g1f/86u5dEFgG8pKj8bSnh3D1g7y3zDBIfeZU90otdGszvNClLim3jaIdBlMj8d+pW9tFPMxAAO07Pf4gkO/2EKknfOU22htyHqTBL7L5l3KG6QQ336ffPQ7t3CcSBm4J5Glod2qhqVZ1WJJETaNZ4mkQ1K+FPHCgWrTHRxLtVdumzcAMBcrQdcdOvo7kfUPiVwy5RkVRG4zaYbdvwNwrbqzTVvXS8e+88DssjsibMF0eJvZUJLMy1wdDoI2nXqhiAY06OM2ckVh7X8FBzyCADULPpCKxmnBiJ11LgAhKE/S+10X1A/B8kVBuKMkVnE57rodp3Rmfyx1uIlYB5E/n/IUIdWxJL+//mAzTtBAl3lcoKD8UAfJF6z8qyyM5pM2rQz9vc6kkUVhL4LcLt6sJ3kxEQiFtu+/j2tA0mtjCnc7pZKqi8imA7B5/L0Tn5xG4RWcQ1P+RPwfg1mwQCkoqtbb5bikP1IRATb+FBahZ0hcSjRo59ekd6uShuQjYpGA3LTWQQQvsZ8mVxlUKLPmZ3xrQTcm9SbxRc+43RmiAmvCaIq/DKslextRqeyB7CczSappsC/AwdahDzidIRyd2bPOQuhuyb1W93DxYA0UK4G+sTZjTR5VzJnZlbMkp+AmcIpclN4/cnrXQ3nJAwPG0AdXrEvDoHhKDLjUqX1A05batk/tu9YhhmFY3LYYhwO/inHLGAkknWdS2kITyjjgMXoPmyA5GrGS3ttr0UYRrDgQZOeTwX/cMTuVstKCwXGUTr91liVwNGrwRzM2OpNg8B5g/bIGHmeAEtAfxNuB+
 64YtEqDz
 CxdnNJRjQTWbuKY8D6AHXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 03:22:46AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    80234b5ab240 Merge tag 'rproc-v7.0-fixes' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1474cd52580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=242f02fcd3fbc8f3
> dashboard link: https://syzkaller.appspot.com/bug?extid=c18de0ad13d62f18469d
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a0d037332dff/disk-80234b5a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0a1f7f8b54f8/vmlinux-80234b5a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/83eb68ee6421/bzImage-80234b5a.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in copy_from_kernel_nofault+0x15f/0x570 mm/maccess.c:41
>  copy_from_kernel_nofault+0x15f/0x570 mm/maccess.c:41
>  prepend_copy fs/d_path.c:50 [inline]
>  prepend fs/d_path.c:76 [inline]
>  prepend_name fs/d_path.c:101 [inline]
>  __prepend_path fs/d_path.c:133 [inline]
>  prepend_path+0x64e/0x1090 fs/d_path.c:172

I think this might just be KMSAN not being able to deal with seqlocks
appropriately? 

dentry->d_shortname.string[DNAME_INLINE_LEN-1] = 0;

is initialized with a zero byte at the end instead of:

memset(&dentry->d_shortname, 0, sizeof(dentry->d_shortname));

which would prevent that warning. But that's zeroing 40 bytes vs one and
the dache is fast-fast-fast.

prepend_path() detects the initialization race via rename_lock seqlock
and retries d_absolute_path(). So this is entirely harmless and works
correct.

