Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC950D116F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 13:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B27D6B0024; Tue,  2 Dec 2025 08:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064506B0026; Tue,  2 Dec 2025 08:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB3C6B0027; Tue,  2 Dec 2025 08:27:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB76F6B0024
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:27:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F05F12FF4F
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:26:57 +0000 (UTC)
X-FDA: 84174606474.28.C21AA42
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4E8EA0019
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:26:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=bn9oyud0;
	spf=pass (imf15.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764682015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsBJ4L0WYEajRt+TV44WQ+0HqqsSol1QaEK5jO/2vzw=;
	b=JpNOUONkzxPdEx/O/Kr0JRnS0moSGH+OttT0CJpG0wxyNHFQpW6FzURVG5bZSQe1lxug6Z
	Nps4UrKPxxsx3o6tzQI9tiHKFvqsiOC0h8kGv4Jp6RiAy7fndgSLgPO/qmhIGoANZMCSJa
	ONBeMoG4U3qLVPu+nNZxGfEbD/MqxQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764682015; a=rsa-sha256;
	cv=none;
	b=miAJ9jMB3ycW0xvofaLvPIvw0GV3/g/2wOzvUZ7Hnut8uOaZ0LAsBtdQ/Tu+29n9SQE3YH
	hKWATVg1hCeCEPrtwm/Md7/Bh30BRYJ8l9WRjNmv/EZJ0y17w9xB3dixd4hCHSHui0NiaU
	EsSmtjwUViMWLcugMQVmlqDr0bgnv00=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=bn9oyud0;
	spf=pass (imf15.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
Received: from macsyma.thunk.org (pool-173-48-102-12.bstnma.fios.verizon.net [173.48.102.12])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 5B2DQjTa020557
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 2 Dec 2025 08:26:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1764682008; bh=qsBJ4L0WYEajRt+TV44WQ+0HqqsSol1QaEK5jO/2vzw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=bn9oyud0h/ujMTcppKRHpfqHt4VdfyNSutTfpy5lxAmZPqbpk9lANPsCSveB+DP7E
	 FPzClPjN+Mtt1waGmhWEQWBFgCXyKnODW8x25UHrmyboXgauqP1ctKPBh8U1LxRfSv
	 BdC4xBEwvlw0ci9QHXIuHHrOsiFmDCF+qkk8XQtyf643vvVnMyMY3Lpf/Ikgf9RoHX
	 ygPmVEiITOH3L7RJMzXC3xdtpf1qD5FwR403WnoxhzpYV/rPjFJoObmZF1XkLu4P/N
	 SMqNNX/qvkUoVD51GVNka8mror5cJjfy/uOL6T42+dY+tDyV0wed2LOzjdav5iKuLj
	 OaHc/1EAAAV5A==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 62A824DD6FCB; Tue,  2 Dec 2025 08:25:45 -0500 (EST)
Date: Tue, 2 Dec 2025 08:25:45 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, syzkaller-bugs@googlegroups.com,
        willy@infradead.org
Subject: Re: [syzbot] [ext4?] WARNING in __folio_mark_dirty (3)
Message-ID: <20251202132545.GA86223@macsyma.lan>
References: <691f44bb.a70a0220.2ea503.0032.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <691f44bb.a70a0220.2ea503.0032.GAE@google.com>
X-Rspamd-Queue-Id: A4E8EA0019
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: pjrg7a931upjjqcpmgy5jq9k6pexk6bu
X-HE-Tag: 1764682015-740779
X-HE-Meta: U2FsdGVkX19/NQK30bWooJ36cV7Y1vclG60COrQujlS1sgp2kUARTlEJRx78gMUSiO4RNEXMaGOYDXqP/0M+m5nY53VrXv8dXlmUXXX2G3GmxShB5sDE9SLnJja37ijiUzD8GQuFqPFVa93mFlT2MLEnWxK3sPLOMRGXd3jLAb+VNaG3r50ErTRBrnsvdRTyMWbb3mgQbGZgw4iBbM6Dnv/ywNb7cXf2jAD6qeX8yDP4d5kLD2Dy/QIep8ZerDPCFzciwysCKT1tQiMOIuLqGimc+g6PraXXfs40bWh5s3PKv6TV7rPVoIzaCY8XZyI8EwAQ+/19csF9DSlL0WcvZTaeS6f0Ihuen3WczXLfRHy7qdlab/+RmrW0oIWqs1/Tw1qoStglQy5JenyU85xX4VbBxeNl1HVmr7voNQ2U3wQzggU1XbOH0WI/GGfDq2PudHUl5mrKfAwZsVFBxNfRoIQQXpKHZfNtIJUPo5wWcY6esxm01Xey5dxM4a2UymR1RDQEiSqHP+57gtUhoLQzJMchUoMeFYIMmoPPm0raMUxoDgfBVU+R1Rkjj602yP1SE1/hwE1pB/czKgrFAuwqzSMjMZynTo46htsQFKLTQGpuQgYyi35ElRCBFgj6ts0JUA1BZVp7p3Ejwgi90jS7LSZBCVw4DzU5jq+0kl1jqvppvXIZPgqY8HXJkimz5w9JyBvnp+7IlP5J8FT9BBlkYpLKJvWiKAXL7T6Y2AcgqOeMB9dLEZ0uYKOiu6dGN2jeurqSNSXdptGS8XrrB2WhrysSR/6QqEIQeECRsczKSWapwxKAf+2G+a6PI7gZ6dgR4J2aArCAwpPWFScB57w9B2mTr00vlhPuionhY5rezcARPb1zO4TT4FXrhMt27zVGXVz9RkszcpyD6up2rxTz5E3hacavbSll3lCSrE+94UeoYMp3pBmsDsCPJhbbkY1H6J3pVXWU2UEvuLD71IA
 sUBTPd5f
 OK4RAfaeFkO/LUMNYDG0oj7S3LIquS+4brJjFmZdgM6gwZqNhuAIgrJX8TAUETIHEgsnIqSZT+0mRArK1j8a+0FQIgg4aR/vRuqn7JvnXXWR/HfzjFaSEGS9DJ6d2Mwx0xr75QFGHOgitDEUNbnSV0V0S8TfDOocCOlyRcBZi7kAPXwD/zO0Tg49HgFQIqcHh64Hxs4Iey8+W/Ie8VXTrsM/tWJrW+U/zVgk+LmhwVV/cy8YcEm9W8A0Wobashbp5TwZUUqfQlzr19x522rMswvRIC9CZ1YNxIUFhjinTjsU3LgtzOOV3GydGfloap87YYEUhEjkavSja7NHTNtUYqYbNMkvLYYZ/HA8NV4CwTL4bPsIf8vZ4cTBmF26kbntLm7xW412qAJgj4Esb/oP52JslPbb+Km3YQtYYWZZgoMNkojtmtXSbfbYflaP/3PSHBsxQtFcQEDg+KfrqxGYt/x0qN4GlFf6cTBA4ZKMzrAllCrD30GrFtIm4Kdk7jYPfO4fsVS2HKvC/Lujd01wqO2U8F9wtqGXUPeYSf4v39bRY8q02+0uQeeEO5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 08:41:31AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    23cb64fb7625 Merge tag 'soc-fixes-6.18-3' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1287997c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
> dashboard link: https://syzkaller.appspot.com/bug?extid=b0a0670332b6b3230a0a
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172cd658580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15378484580000

Not reproducing locally, so let's see if Syzbot can reproduce in its environment....

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

