Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF80CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 00:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0038E0072; Thu,  9 Oct 2025 20:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7EA8E0002; Thu,  9 Oct 2025 20:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE1E8E0072; Thu,  9 Oct 2025 20:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEAE48E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 20:41:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 757161A010F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:41:12 +0000 (UTC)
X-FDA: 83980350384.30.513869E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C538540004
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:41:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WylIKI7F;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760056870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIoQl1un1NUvTTXws2eMaf2rzdoD2s3GGFpfJmtNWYs=;
	b=F9NrIRTnS1em+56t5jf6ACO35cqGAyVB99fl6svKH0htxEhcrMhrh8tJFbFrIDGknEZQ5X
	Dbkygc4KoF+R1om6KVANjSDCK1D2fJppyZFpmEN6o/gQ4RyYQzxLxLvm89Ilq1er6bbjNx
	X8ZmKRnPPY32uZKevdDT8j3KvYT09Vs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760056870; a=rsa-sha256;
	cv=none;
	b=GTzIftqWbQ8K+ffZDwxZ7pUDSb6BZk5zXEwlgzo/Y3dyYwjlchXVNU1kaAndYrKMm8nsBs
	gve4nl4/RqK4/chQ+L0PDbBonJvpIXfGjPVupOxH2YOo+CJdowKkWktglDN3z06p/A4HHl
	+V5O49jOMPjrkt72piTm4nfibduQElM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WylIKI7F;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B827F60237;
	Fri, 10 Oct 2025 00:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB77BC4CEE7;
	Fri, 10 Oct 2025 00:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760056869;
	bh=BnSjONbuKcjeBcFTrNUoOvLEJVoEpv6o7xyNm2HalOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WylIKI7Fy3n3Xh5X9qtDDGCGqoynWEeiLmK+Wz2jHSCH9AHpnuFmGh2Qy231Ih+q4
	 VtjkQjobmYiowvOQ4zXxVAPVjCu63wYiZRr5aES7Mhf+DkXZN8DlXUmSu5MReC43wl
	 9OTvy2AqR3jNXvegQt0EloY78lvZmcBIzrQ2BJw4=
Date: Thu, 9 Oct 2025 17:41:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: syzbot <syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Brendan Jackman <jackmanb@google.com>, LKML
 <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Michal Hocko
 <mhocko@suse.com>, Network Development <netdev@vger.kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, syzkaller-bugs
 <syzkaller-bugs@googlegroups.com>, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com, bpf <bpf@vger.kernel.org>
Subject: Re: [syzbot] [mm?] WARNING: locking bug in __set_page_owner (2)
Message-Id: <20251009174108.ad6fea5b1e4bb84b8e2e223b@linux-foundation.org>
In-Reply-To: <CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com>
References: <68e7e6ad.a70a0220.126b66.0043.GAE@google.com>
	<20251009165241.4d78dc5d9fa5525d988806b5@linux-foundation.org>
	<CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 7tdpswsx3nz6iz18wxi8w9sux1onidzh
X-Rspam-User: 
X-Rspamd-Queue-Id: C538540004
X-HE-Tag: 1760056870-385078
X-HE-Meta: U2FsdGVkX18RxGBhq4jdtiEokB5ivEewlC1fi/hep3j1CQHgHTdZEMZ3VylewKMbSMTgDK0qU+d7h7HXNvybxJOabtJOHjm4xuAGgHENuQe57LQvee72Mn5u4Hcold9NtzDiRC5JwsXxtI+MfWG7LoKYdf22V9HMQYJqJF8sFGvXaEl4JIBN9SOy9S7dYAY6Uts1AHAE63L7I5faPNAES7DekhY4uAOUVbwYDRxLp8+QWC/NcQfkA7GfvPNhZcgqWrrIw45qLGIR/7qy+HK8eyJXT/H2IPibfv+3uGM/9fp7V8kMqmbMF1ighS0cZz+ffr689XCoamQ7etNS1NthpX7CChic8x9YBVJm5QEprpSThfNua0HDJY8x5wIdgZpSVdN0dNzV2zhDVawvAj8CIlRvnRlLPPSGkDx8Vzn3qLaTaeP6rivXL0D6oP2TAzNfabcYpmwMa96Zr8WqUjL4keaPlAqCcq2M5bET+9fBUNYv763yBT0VIvDhSSgZNCpbT1sKmXIebHEf2haknu1xlsscS9ssksKLgyD34AJNRVBgikTXC3daHnEOWfy8g92DepfN6/ursePemPdA4ul6gXzGC9EXMaVGMdpiF8sOQsM+DZk8RvcFMAOID5SQIX5uGMEFAk3upl1VBP0h74cc1gVhC8ngRQdewWbdYXmedD8czD8YfFGomFlXKzmDwh/Hj5xi71Kjw7giymz22d0CsmDOK2/m339rn3K5+Akb86zyT1b4DZgEPKk+ZQL8cMYT/usRPHWaOhAwTa4wd4cWe5/Qoo9+jOeoXP2irl1imnRh+sT8lElcRqItw6ws+/87lqA0bDdkg1twBI4mPXdwnnP96h3GQY1/yje+rOFFF+KF471iDrhBeGjf10HI8JVOD5MM84u6m/NOxFUEe5h5J+dXNhpgffy0mB52bqi1778Zm70xw8rTwWHDvROJhuZJM/GmBzQ0ntpUc0PXqc0
 wsZ4MHEF
 adkwIP2qIu7EEL+cUbDrbQfbEjITF98cSe44kLtiraKEuIaGuUbdiOmKr4Q3p/pVtH90EyM+CPUoaZdnroy+wz0D/Grbz/zzuxGOtIqcmaVpbHo1x0m+szuroNMy5fh1aFKaPFMI1auhvZmsSh38pOhg/y1+sAFU/Ao+FNXq6Q6sTv1xqGThrta6Mz2aLoxU9dGmWhUUEbziJFBGME3l+c2zOdt8d3gDixhPC/+EwoabY705TWfPqoXJcyEOPfKHx/w7tKuccsex+HjPm3SYzUL/0/zawzkOuNmayxs6k1uZv5QuCWvWKhFpwfajT4x65fTkrL0niz67pMKe2spMq13rb0WAKMmw04CjTXg81E03eYASduJVC7YxB+Y+oDvzH5SrHbo60d8xpUnEqVzNNvbcELkhkncW4KRAPWRQ1daoOWyP55Sq4SfgJ4c4e5hzPLnVZ1SRiIlRbK9axMpxtYDe5PWEa6y55KW5StkxZya6JUV4BfnWZL2ez5oHRZPehLxs/n1+PV9J+W4clS548KZ/ldTXTfqARk5k+a8dhAXta8XIi3EwfYGPOp2ede/LZLx5eYPJxucMu+GfyEDaRK7woAvVpsAj54e9RIYmCoN4pfK4eAq34YkFaESPk+bJiyzqQbvYUejN2Hirs02uVFWHSMqeeOA7iKPgLyOKhqu8vji14Vg6Hcp3PdvQdvUPE+64MJN7msetG78+R8ASFNz0TQuW7kfQyPUeqCAaqQC2Ce8Vr4hon56fCWzMiXuXWJYjs63lckt7iBqK/C6mWNmwXd3+DR4ZKnDO/G4chKMUJIHVQVmwTw/dSS+P9jY8ngmalzmYdY4LLC7SFOGUFf3WfJIPFoevs8KfGwbKEfROOrW5Ixyq0HMhm+ZUYm93M+6NzZUoGYYQ1X2k062pxcOcwHe6xCew5eCvC4rBsFUdOUnj3L2Tpqw9HzUwvgoWb0zxxJTsQN+ktfDiJ1gb1IM2ACPPo
 AHXK+tbg
 gAqJrE4wAvPCuohgQV0Ihxt9uh3Udl7drU03W8En2hW2+syZo7NI2FwmawOwq9yDhhlX1KhmCA9XJtTOu6RSiTnNjbVqKDWu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Oct 2025 17:26:21 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Oct 9, 2025 at 4:52 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 09 Oct 2025 09:45:33 -0700 syzbot <syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com> wrote:
> >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    2c95a756e0cf net: pse-pd: tps23881: Fix current measuremen..
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16e1852f980000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5bcbbf19237350b5
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=8259e1d0e3ae8ed0c490
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/8272657e4298/disk-2c95a756.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/4e53ba690f28/vmlinux-2c95a756.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/6112d620d6fc/bzImage-2c95a756.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com
> >
> > At 2c95a756e0cf, page_owner.c hasn't been modified in a couple of years.
> >
> > How can add_stack_record_to_list()'s spin_lock_irqsave() be "invalid
> > wait context"?  In NMI, yes, but the trace doesn't indicate that we're
> > in an NMI.
> >
> > Confused.  I'm suspecting BPF involvement.  Cc'ed for help, please.
> 
> The attached patch should fix it.
> There are different options, but this one is the simplest.

Cool, thanks.

> From: Alexei Starovoitov <ast@kernel.org>
> Subject: mm: don't spin in add_stack_record when gfp flags don't allow
> Date: Thu, 9 Oct 2025 17:15:13 -0700
> 
> syzbot was able to find the following path:
>   add_stack_record_to_list mm/page_owner.c:182 [inline]
>   inc_stack_record_count mm/page_owner.c:214 [inline]
>   __set_page_owner+0x2c3/0x4a0 mm/page_owner.c:333
>   set_page_owner include/linux/page_owner.h:32 [inline]
>   post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>   prep_new_page mm/page_alloc.c:1859 [inline]
>   get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>   alloc_pages_nolock_noprof+0x94/0x120 mm/page_alloc.c:7554
> 
> Don't spin in add_stack_record_to_list() when it is called
> from *_nolock() context.

Seems 6.18 will need this.  Do you think it is needed in earlier kernel
versions?


