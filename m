Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA69F8924C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA306B0088; Tue, 21 Apr 2026 06:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2826B0089; Tue, 21 Apr 2026 06:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F396B008A; Tue, 21 Apr 2026 06:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABAD76B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:23:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BFCA13C1FB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:23:49 +0000 (UTC)
X-FDA: 84682176978.04.3164973
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C4614C000D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:23:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="STA/J88O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776767027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kD4iJBtq0zkNkglOhQRSSNMuudI429m7fTX9ARAPN4c=;
	b=X4wLfd4ERiVyUsOe8H9M/DbuDJ9AX7EKv04hgyICpWvpqwrfhdhLqDSAtX8ykqJxJtyz40
	AIXCV1hqdEuvmEbZj9zDWw4w0f2Yq4/Jn7kuavvW3XQODIg16rZsgwR7kl/v3d56rrt3XK
	awu19kjXAdKJ+2kUNIcr/318okDklso=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="STA/J88O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776767027; a=rsa-sha256;
	cv=none;
	b=OpVNzJpqbz6kD8+tawegmR0G8rQ06bj7h2R4n8THLEBluyxBh6q8R7mGBISoNrL8oer1rZ
	LntiAagDBrVba6xotRmp5M0eQ399k1EC20b5NMJgORF3s5TqTACv5O3zJrOdrVB+SvZ4gI
	gdOCZb7xpVMZ/WZc6v7g7eZX06OfdLs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23B1D60125;
	Tue, 21 Apr 2026 10:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5DBC2BCB5;
	Tue, 21 Apr 2026 10:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776767026;
	bh=kD4iJBtq0zkNkglOhQRSSNMuudI429m7fTX9ARAPN4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STA/J88OsBF96eVpnWHNdv8rc0iVhiHoxqkr71ByjYKFAPyKVemICTUPyXXM5U3y9
	 HMkgxf6b1IaAbkCc6gg9XYzYmPK8pLk4HJidiuYQXW0cdkNjaBQB9IjX6dEZDWd9oN
	 BYGoUAIjUvEMspDsJALcTCcVQxWfDHXXgvuIPIwdpL/vtPBH89QORVnWf/GOdMW1E3
	 MGlBgnKWJDM3Si1izUZmcY34kWPVBTf9B2gzwUTsa8iVhllmtZdUy25GEmHUsfyc1E
	 1n73fNS/UK2JF+VVlAHa2Kgzp4/cnJjK5BnNTn6ZXt+nXCiJXd422SIIanXXTlxtF1
	 4z+A37JqatT7A==
Date: Tue, 21 Apr 2026 11:23:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: syzbot <syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in vma_mark_detached
Message-ID: <aedP3D8zF-vvomwR@lucifer>
References: <69e69734.050a0220.24bfd3.0027.GAE@google.com>
 <aedB4BJtOtZ3Aqrj@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aedB4BJtOtZ3Aqrj@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4614C000D
X-Stat-Signature: btw7bqog33hn5muusa47fcw7xqmi3ye7
X-HE-Tag: 1776767027-351109
X-HE-Meta: U2FsdGVkX19/Y83BJdGq16900hbpbTbNMt7lxEosF15RDpyo1wNPSknAEXw1tB+2/gyhSmA8svgQNmNvg5N+0Xe1ivdUwSd8MVSBhlvQZYx/vv3jwEojIBEXLRXDzZMiTE4l2lbf7sNB3YmN+ytrekzj4UO2gI10roYP8SuUyagluGEsHW/Mbt9aj90aHr9fX4IAi84tCLgFAiUPhf25f3KPQsxEDlaYBW6PImtr+7vNAg1kp+sPauiN+E0yxbqs2Z+0WCsJLPiNM9JsIrU/7wOaTsdQN5f7W7e+av/tch/zbpOM5xPm2J6w5hIkfL0ocTLh0giKyMKdwaz6C6ZkKFZ+4qTL2Rvf7Fkks9E3fG3/SQp1C35ecVS/BAc0/wdAec6fGRPA0nYTMG7n40Phkzb7310GwcrixIwMkpYonlkXIo34siUYP5zJkJ8EET5DA9XHKLW/IZtaBu+yt/0jzSSdoUIkWTCQGod0JavuuD8CYXYFt05N6ad2MDvs6YjfEuZtBJey1YopGN39ozABlgjD+gjb/dstPWmMVe051ntRgAGs1hMlxUdnaObIH4qcGYPXZTAxNXvLbapX23VWs/LozwJyni4BnqYFRLjzNKvX4MvmB7CBc1D0IicQ696r8shEUf+QovCJEaPztwwStalqCWbUZkkooqP5kQ+zh6JKvmLFWG2LBGHbh0+fECmEvh3UMhioVN4IxSCQSZNEotBXgfk9yFyhthnW0C39B15s9bPwTEuo/DibMB7PmVQdS0mZ2AHt3Hi2+7bpSGyVQaygTI/e32BzpRhYONmdLWXfRc+eQ0jrHKqxRwwBtBwO3ZAS82obiQ+BLR6BG9DcfTK8lcBIJlNyHDagLAfxzeQxyTmVE+rr3z0M7Ie0FD0EtWHF8gzNptIDsEB4j8mLidYfECayCuv4XriRQ80Kxbd11SC2YWZUIffZuZkj+e9DjbuFYcnQuVgGrtw+Qhf
 vp2AanKG
 xz92IsxLwYrLZ09sHUgG/uPMGvIvh407mFqjqW2x7aHfy6vxqLc3hLdh2OhrItSIip0MIt+MkWj305nvKCif6pP0ZLCIA2zZNcnJo2juid8YM51OljLs2a8GrHMS21DOf+/4hiJl6DzFslK6HLEyppOTPjiR+HsTfmpo50q0I3eY+1NGCAR1cb60C/4WKX0SEHXyEoEahdci7LUGYMV9gbCgY4+2zVmzfxsSJbSVZLkGC/9GFfAl2OhMzlYro58x1ZjXjhpVG6FtKF8Q611lR8fAl1QWraBIRnX9QUYZAQhb/XFvT1GYqlwAPcLfQSUDRl3iMG3t/DRzHJDE3pAQvRQ9eMK2v5UfieF2rKM6h5iATiWJw42KPyb7vTqSgqAKLa6SRnvYsn2QxT7a2gg85acSeRIKY64m2S7Aapv60ZmGzVNNxD2fYwNLQ4sZijOlbE5bYiMPyTmdy+ENhkyp/zBGq+0r9OeCr3O6L128BDcuX1SU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:32:15AM +0100, Lorenzo Stoakes wrote:
> I'll come up with a patch!

Sent, see https://lore.kernel.org/all/20260421102150.189982-1-ljs@kernel.org/

Cheers, Lorenzo

