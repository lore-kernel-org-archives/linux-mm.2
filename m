Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A26D2C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC5F6B009D; Tue,  8 Sep 2026 06:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A296B009E; Tue,  8 Sep 2026 06:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9026B009F; Tue,  8 Sep 2026 06:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA506B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:24:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E0F6C04E6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:24:45 +0000 (UTC)
X-FDA: 85190211330.30.6E8344C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9171710000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:24:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2GZ3Pvd;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788863083;
	b=CtEgyEUFgXOsuY4WoGHSQTs1cf/3UnJs7NcPj1MghH7gUlttwcm6mTo6UXj8VTDHikLroh
	QCEwD0USaW9vys4IPuW9J7NvgKYobzpKqLEGCg0oK0oQRKjJdIMaOW2kt9TNUcQBQZcEQ6
	/zVOsYnRos/2nhKvt39QfEoRdwTWaso=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2GZ3Pvd;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788863083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIUkCbJ7shfPROFJxtTfla+/4+rlDGuo3hAIW5bFyFM=;
	b=zTCFogHTn1L+JHqpaMsC9ftoGa4Cm1VQw/QN41Y62BDfcllSErUvhfhbeFMah0ghLOhOMr
	Wvnq3HsM6tBRTvwlo+aim7UjWpqLWm7OfInfUVip1nGWYSfhLTEuhCOQHIOPFoWTE2XhIe
	ZSYTVa5Z5Gat34NQ2FHDcNyGDSa6WYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C117743A5E;
	Tue,  8 Sep 2026 10:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2FB1F00A3A;
	Tue,  8 Sep 2026 10:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863082;
	bh=lIUkCbJ7shfPROFJxtTfla+/4+rlDGuo3hAIW5bFyFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M2GZ3PvdvIIc3QHnujmylrLk0OTC1XZmWij350Oprx7fKaDYxIML4dZLSBUQmGXEi
	 l1zk0PNDiYHX53ePOujhKOKM6ffB8QEQ8grv+Lh5FnKCZDboK8BKZQDmQnFLDQkXeM
	 RVpQXS1AQ+3izISLfVaZ7nhOaJVFlKqSc8qi9D4Z6vfzQdoMUnYLqmrhwQkyRfBUop
	 jxZSASGal/6kgi0HY15mZisXXRp2g6FiruA3KjIOac/TwCF39Bu2BfPiwSA6tkZ9aI
	 SOU9epFApm7zgV/JtqvniUyoRmE0Db2JrBLsjAU518E9R9bZS+LvLrfH47moyQ0vVt
	 RM8fTACARSHkw==
Date: Tue, 8 Sep 2026 11:24:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: syzbot <syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in vma_add_pgoff
Message-ID: <ap_iJsK57kLOY-zb@gremlin>
References: <20260907192517.564ea15aa8c9d47669b3a81f@linux-foundation.org>
 <6a9f8bc6.f614420e.2bf292.0005.GAE@google.com>
 <ap_Uke89Q9LWoaoK@gremlin>
 <90cd8ace-b135-45d6-815b-bf7329cbfa4d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90cd8ace-b135-45d6-815b-bf7329cbfa4d@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9171710000C
X-Stat-Signature: b344stuijtnpa69aj3nn6wmny1unfrt5
X-HE-Tag: 1788863083-379255
X-HE-Meta: U2FsdGVkX1/ubQMWXhg6bM98lo5Y2go+JKfHaGhFK1jDXyJOKzPCZ5pL3AjpOwa3Te2h+st45XDU57eSupcJkHlWx6SaaW6LaLfeUai4gr2eRpESGj6JPBYu4wTFPNCGnMiitHV+YfRFr7C9QcxrRrLBvkIVbCZ9+Ih84v0aP+bRrd/gYbsq8q54gb1Ap0F9JTm9QVeCdl/Vx5DvadS6W6ZDm3OXCGxGc0+jNG9lo/jQfEQvriZMZPYFef2xxfzzX0MwMLqNYX5Yg7HZ0bYBJVKHKYfHHLpx+i1vqsbRz4mOCTRIpWKQufRqtCPsYxqGD5Lwg4s/BktEL0W8/AyTtK6xnHauYQsghBle7RDJmG0EehiC0UmeRq2NXsibz9ju5cjWRJuk2RuTwhHBiUAEh9lXcjVBnN9BVRqLhjQHoWgGQI2YCHAxcfslPNDbMJtmnC2GbuGhDIE6QcfdwK/qU2AuCEhl/5xnqUse/zISmL7RKbvjqfhNh5WuGNQvza3pIOptoyYjVK4DzKtIv3aqKMI8LSLNKXRlaaalDqE8DLgbHxPPneUcCSPSHSakJtRD8+7/J+yz0TWQPgEedTB3sGdXmESLVqu/idv9bAFz+xECq7XzYe1Jx2cc1wQnvomGPKSP8VujB2q5x60ICKxW2/h/bPmec5BxevyAe+iuA42WQn/5Me+F9uDEPGfAa2O9kTpiZSvyQbkBowc7yXOUfPUBsclsjJOK5C/UMGoM6ex9lCXzw1Nfyg/zJDP5bmhYqxonb6IwoNGNTIYzqK4rYKVRr0jkeon/nZVyNvwe6UckGpPdYCzqg24tKEFRR58mkn0lIkc3Onn8ux5u8t0f1ZgNBe9S2n/WAhx2iD9ILe1fq7kHri+sny8NILrH45tEQ3SUvgAOVZFBy1jDXT/y6zcogHbclyjfUjnxZ6duMsD+qtFdtSvnbyKT6gzyL2k1RA1PAWIcGKTSfgykKQi
 aMTCM+c5
 Za3bkqqVNqlgPY0q9qDG8PtDQZTNJc+e+O1K+QAyFRko70tp/p8adSrViNWF7+vnHarf98h7GkPNzibXHsPxeBobeCUylE7cqhRm+HB2KI6d/BG7QT1t8xmla+r4m3a82Kk3vfFkCtyIw2Gc9yVeYw7C3FYo2kGe+5b0+ZtQNFyvUC57kOyf68MXgYdG7irJj1WbDm3yoaden5nDmWEBvA4nWiN87bo9M+yxAlY9JBqICP55xI9Fpe6snlnBOlXQPIh5TedjPeGHA1hMWleAmKWbgvycNuZK4FzJOaiZVQ6i+sXinU7gfVIfyJRY6t4dLFTx7XoZjYMBnfIXJJq6aULQkirniBpfPoLf2iQ8jdPdacElaXThgrsjlzYWkBgFAG31Id+Jj6UXa+e7Uv8/pvXscsFXhqM4j9sVwfC5F8GT3iI14ALEhP+P4Bd6XTptXLH++XWKj8vc5jx3TC9Ij9dgYfLEIW2f3z6g0n0fJonT+7W27RfU97ZF1sYNBI/ZbQZqBdqWYBC8aacUt3w4JR4L4o/X59HLFl2uk9jLvapcVbG6uKhJvpgZeK2IxkPt/H7hw4VeFb55fXeAZnvJS6iJSHFlURTXKsrwZ/0Jbw6J8cjh3dFDeVgdwPuqqQRQvlIY2UVb7vkukYjKW7bxqhJ+eiRkm3SjuIPSenzzdM/faUvQSASggSCdhh+eDBfjYDU3GVaT9e1QSGdpeCGKtLdpfG/q5VqChnhRJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 11:32:18AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/8/26 11:25, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Sep 07, 2026 at 09:15:02PM -0700, syzbot wrote:
> >> Hello,
> >>
> >> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> >>
> >> Reported-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com
> >> Tested-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com
> >
> > Yup there we are :)
> >
> > Why is this constantly duplicating I wonder...
>
> Going back to the first mail:
>
> syzbot found the following issue on:
>
> HEAD commit:    5445d6419962 arm64: Don't read GMID_EL1 when MTE is disabled
> git tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
>
> We can see it's based from 7.3-rc1:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-kernelci
>
> And since the problem was introduced there, all kinds of development trees
> for 7.4 (or even pending hotfixes for 7.3) based on 7.3-rc1 will now have it.

Yeah but I marked this #syz dupe? I guess that's cleared maybe for a new job?

>
> I guess syzbot has to learn to recognize it's a known problem and ignore it,
> or have some repo of known important fixes merged after rc1 it applies on
> top of such development trees, as they generaly won't be rebased to later rcs.

Yeah, be nice if 'hey check this upstream commit does it fix it?' *syzbot
confirms yes* could -> mark reports redundant.

But maybe harder to actually do than that?

>
> >
> >>
> >> Tested on:
> >>
> >> commit:         35b0fb39 mm/mremap: reset unfaulted VMA page offset fo..
> >> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=15e13af9580000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=c6879dc677a017f0a21b
> >> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >> userspace arch: arm64
> >>
> >> Note: no patches were applied.
> >> Note: testing is done by a robot and is best-effort only.
> >
> > --
> > Cheers, Lorenzo
>

--
Cheers, Lorenzo

