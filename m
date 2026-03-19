Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82871088E7F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242B26B03F7; Thu, 19 Mar 2026 01:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC5D6B03F8; Thu, 19 Mar 2026 01:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094606B03F9; Thu, 19 Mar 2026 01:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7EE06B03F7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:46:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 850AA160219
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:46:05 +0000 (UTC)
X-FDA: 84561726690.03.96A0A11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E9FCD1C0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:46:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qpH2E1M0;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773899163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSec30mGZjA4WCRvlP4twDai5T6Y5USmyTkYip0iVNM=;
	b=8W4H3OdbF7a29h2TXoYIMcrd1aWszRRgOHxUrP/g9MbMCC0taVA+1o9kFhh4SBup/qxdLb
	5Zl8L/lJTeE3BpejaoVvsa++1v7bdgjcSgZGvqn8Vwv85n1/S7VJWOtlctKqwy4IpeY1rO
	9aBqYMUGHba57ts5QsA5f/n3uYeaQGU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773899163; a=rsa-sha256;
	cv=none;
	b=6/2AET1sBxQ4G9jDX5Zo6CDU1DfgsjHJrmu/8dNkOOLw1eEDjFEYXfshxfBKGrkDB5Lut2
	5Af78Hxvf6krDxM+jnjKM+kjgu92MOu3DPwdKc+JjuOIGOrR3lK6d7U1UHJLIF2usr7X4w
	56QnfswZAJS3szpW3nqftPUu0P261YQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qpH2E1M0;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EE72600AD;
	Thu, 19 Mar 2026 05:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB33C19425;
	Thu, 19 Mar 2026 05:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773899163;
	bh=3rlYRiZSQIwbTV2YgyEI1AsPMPI9LpI0pqEVU9EUyhk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpH2E1M0hDRVkWkc6HN5OsZ9LRQwvROi0pn480R2jtbJxRw81caSggF/cYn5KvR3a
	 5M6NSMttg14QwG2/q7q7ffOAwTpfzKGDR5GHFWSfMV1aBBCNQSga9vp8VjBz3D6O+w
	 RZLocMg+8pQi0GmbM2RveVjonvaBypwSUzeKBbF6tljvr1XljrBKe4vAjnDugsW1zK
	 ss1I/JDGG+AB/gfWBcwX+6f3GOgQSUmGrhA+M2jvYuLBVF96NAWGXye9ZoMmXe3L15
	 eo/NV70c8CU60gh13KVCR9YtEbSIzigsKRJEIGnCfj21L2qaJ7dzBR5sz2/XjcR1bn
	 HNn8L3TqPu6Mg==
Date: Thu, 19 Mar 2026 07:45:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org,
	dev.jain@arm.com, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com,
	ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com,
	ziy@nvidia.com, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
Message-ID: <abuNkfv8c1IrGk0E@kernel.org>
References: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
 <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
X-Stat-Signature: znga99hd1jzfxj7psrk8x1b5e4o9fydn
X-Rspam-User: 
X-Rspamd-Queue-Id: E9FCD1C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773899163-231056
X-HE-Meta: U2FsdGVkX1+ZZZDNygr9021VQSRT1WgiphSVH+vWtH2q6rz31/AF9vs2vKZQaJ4ppTySFj0ZqrwyxV+OcFjl5CsHpU7gTZphLgnVG1Sa/v8w7YRgeunqIE5tH/aUpFDFBGBqbCR/dJo/ZHrpOb3YRL4Dz1kjmfYIbpgDu9fAXBGpdeCcuIyn+WZS6+U6Dom22qWmlh7kPcw0x/0u87kbIfmFSXR3ZUKM1k0iB4YbSpG1nCQGO87ryDcljLaUdqtkMhpkWISvwgDwN+qwvtPYZX3Nk0G4TyJrDcy79YBe7VSKt4yt2lrj2EUPEYzgOuqrxBR51tpF8zEziEJ4Ipss6MkM4ESXNaVJo6HUjJ8tX+FyzhLEqm5DRLNZJ5yTW9NTsqroZctChF81UnL5vC+Skr7Ni4SGat/E1sVsRvP1JoFjcoZGv6CNKj+Aka/syhRZggtdg8wATETEGHe7HJC/3Fe0nHnWc+4V+UjtHqbbJsNzwdw8xilP+WEOdXpaNG/0OXpVninytkciWNo/iZ3CpxerK3nRlY92mL2cFnOE2DEOwYcXWwDE3s7hWZPIgkIUCzfHEKH4wIZajcOdMApcDPL3ZB2UuAesuqJWl7Tx6Vmo1kI1eFMH9YhgxjU+mua5FhnOzwnBB+QSZTJDVON8xh4KvHMbxmuttr1fqUM/XhJ/6RvVEz/VvX0ar4RhimA+w2i9ItDpHQI/VxzzEU7a3yYvJzNyGQ4sFkbuJCkMnihKHTwVpx1vGI9/XSHUdJeNHzAu3kyPCLbwkWfhj1jFkdUbV12bPKUmTCVvYCQUGQsOOPOPA1aiz8cafWaTjehSTIzDz8bjQCcxcQIio67em96f9tf9l3sJ2ON6GFcpVbUFUa48LLS+3Gr0UgHpltoY9vi6xuyoNOA+Qx2/OhUo7QgyMA94HlXWSoowtGJTzrbtURB678Q4QYFd0Y8c6KqwJGe00eJPfp6b9JdA7Nc
 +YS9n17L
 ZdOEF5jkftEtQkfGE9A/aBFfwv2jofzD9AjofAhizgt6TLD+Io+/LwlPhZgMCIYQ77xECWdCkvkRYXZNtC49QBJF49esP4OAe9SOaoR6AWaLKu8KJQhVGC4zqjxYwpEeZILZCvk2LH1UGf28pSflvdUwclICQVqonkwW86fMwlZTGtGXlxrEh4/f/mTYDZh2LUmzznQnUAheNVZ52hmYO21qirviHJuHVRMdymK2/XRMv2dL2CE5Yp7L30jxnnpYMu0Oki984IJ0OoolL/2Vpp8BlKprtarYZK2j+tdSV+2YtzWD6LSKB+bTe9Ry2M5Z8TkSO0jBOCDq7jEsMNn4nbU97xpdboKzkmUot+sPtKs8XeE5XZTwqElK09XrAH7AEcOBuut1oYHE3+2Y7BmLTl3BS/G2W/Iw8/2gEmpOFIHni0Wi/2mrCI3KnftqKs7vpCOAc2t3Ii52ADiUx98AECp/XM0D087+wg7oAa9xG5B2Tvvd6/bHBAGQjaKwYEpub6S8OZ/WvmxtyMHeqbH9Tcy3QdeOXEB9JIzX/7PiRbAWze85mPeK3wiRcI8vXf2we1VLGYI6YQcs8qLeqZI2KnLY/ITlenhdrFtzq09j47MbIa+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 05:26:32PM +0000, Lorenzo Stoakes (Oracle) wrote:
> +cc Mike for uffd, Harry for fix that also resolves this, see below
> 
> On Wed, Mar 18, 2026 at 08:03:22AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
> 
> For some reason I have to git pull --tags to get this... commit hash locally?
> Strange.
> 
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=119ddd52580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
> > dashboard link: https://syzkaller.appspot.com/bug?extid=de14f7701c22477db718
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173b44da580000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1537b8da580000
> 
> @SYZKALLER guys:
> 
> Note: the repro is incorrectly labelling;
> 
>   //  ioctl$UFFDIO_CONTINUE arguments: [
>   //    fd: fd_uffd (resource)
>   //    cmd: const = 0xc020aa08 (4 bytes)
> 
> as UFFDIO_CONTINUE (0x7), it's actually UFFDIO_POISION (0x8) as you can see
> from least-significant byte.
> 
> It's also stating things like mmap flags wrong e.g.:
> 
>       /*flags=MAP_UNINITIALIZED|MAP_POPULATE|MAP_NORESERVE|MAP_NONBLOCK|MAP_HUGETLB|0x8c4b815a506002b2*/
>       0x8c4b815a5465c2b2ul,

As Andrey Vagin pointed off-list, you can run strace repro and see the
syscall arguments quite nicely :-)
 
> So Harry's fix resolves this,

and that's the important bit ;-P

> but we should handle this case better in zap_huge_pmd(), I will send a
> patch for that.
 
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

