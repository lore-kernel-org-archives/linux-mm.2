Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED54C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B509F6B00C2; Wed,  6 Aug 2025 04:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01FC6B00C3; Wed,  6 Aug 2025 04:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EA36B00CC; Wed,  6 Aug 2025 04:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9300A6B00C2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:50:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11C6D8154B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:50:05 +0000 (UTC)
X-FDA: 83745710370.21.FC8EB38
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf04.hostedemail.com (Postfix) with ESMTP id 53D6840003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:50:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3OheTaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3OheTaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754470203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=VBmwiUt+nuPRAaMZFcsCuQ9KJ321I7uGUFl4dkIzOH8=;
	b=R60pGjIpnVeX+DwGPgmpMPVxIW/yh59QuwQxhqaSxi8dzaORGgq0qVVmZ7rENZ87WX3x+z
	EjPauatVu//kI+OWdShTOLj1ivC07qgIc51kpTOIRMBrRcfSN3Sc5XA+fVsM43TW2q7d3v
	EjwG3jpSQ1Nsoe80BSYDXlZ8MKee4UE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3OheTaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3OheTaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754470203; a=rsa-sha256;
	cv=none;
	b=vLe9RQzQVQF0PPvlO6pRF6QQV2F8Vm6u6QiIdu0CB6JT6yUh2uAXOX7ttyp3p87iygZz/f
	exei6qS231J8EnWI/rJk4QTlrwrp8gI5ILdZM8HTpj7q5QhLOSPAjWWey1XdEx8oLhYLuN
	dhgv9yNedRJWgz7vZpLFkd3SmYtZqTU=
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8817d15cad2so294004939f.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 01:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754470202; x=1755075002;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VBmwiUt+nuPRAaMZFcsCuQ9KJ321I7uGUFl4dkIzOH8=;
        b=N9TWg0qODj0KnHVeLY9lBhdOUfctYe1sHAllRUFD2ycDHmoZDJGj/oClhrZ5xHxSvA
         PX27kQ9lHUPl5ykXJHGcW4I/NaQM9tGNmGMFu/MKzLnPAn09MU/13hg5z+Djj4Dg7jgG
         xDUNlqPl9TQz6hX8KCJNcyqNViIy5fEVIE7up1TEFw0XHRjer1Le0z9/2EVJX/gkETvb
         hEr+fb9ALqPVCCz6VO2aUIVsYRjwEl1xta16uu4CjqfAI7qEo9pmWSLxdoRcsbxhGQNZ
         BlZPFYfUz5+Dqi5pBdph+GGkUnjT3RlTY6oaNvPYHf/0alrOFrBCskjTiSx5WPTBBYzE
         kFXg==
X-Forwarded-Encrypted: i=1; AJvYcCUJAA+r38usek3zF3DgYLLBelna7TyyZ0t/z1SafwPGjR6UmOb6wPnDOYgWBySgRMO2buoUdDu6XQ==@kvack.org
X-Gm-Message-State: AOJu0Yyye9f7USuLCqJ9w5UOheQA8LmW1cG/7Wb+89HTO/t5el7vhGMP
	hci1b2Wb8glLycUVH7oOWShTBBXWBl/3L7zNFACs8yMns+XfibiSnTM4SbqqwjxuxXCK9Gb1YhV
	5hcAQpmoZdNCXOPbDO4wsBeizH0TiPrXeTnFUGmtrjspq95UxZ0tkLV+8Q/I=
X-Google-Smtp-Source: AGHT+IHaYA4xki8tgHJ3350HmR2xD1uzniV2gnqhQaec7hvthAaMDhr+upWNXvyeyzWrWtf+0GqE8fq25jR959POJE3Lz/prH4Dt
MIME-Version: 1.0
X-Received: by 2002:a6b:fc0f:0:b0:876:a8dc:96cc with SMTP id
 ca18e2360f4ac-8819f087f95mr336624039f.6.1754470202487; Wed, 06 Aug 2025
 01:50:02 -0700 (PDT)
Date: Wed, 06 Aug 2025 01:50:02 -0700
In-Reply-To: <18e151e1-6963-49eb-9e45-60c7cb8af15a@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6893173a.a70a0220.7865.0002.GAE@google.com>
Subject: Re: [syzbot] [mm?] general protection fault in __pte_offset_map_lock (2)
From: syzbot <syzbot+45ad2baf16fce6bc81f3@syzkaller.appspotmail.com>
To: 21cnbao@gmail.com, akpm@linux-foundation.org, david@redhat.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tqueir7kyao4mk7k61fnwqip7t4ib5fc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53D6840003
X-Rspam-User: 
X-HE-Tag: 1754470203-429594
X-HE-Meta: U2FsdGVkX19n3KvrMEfhtshcM2GYF2xFkGat+NwDyiGDYQlSv0gMzerm17spv9GhbLfOQGu1Aw3OBRwLNaQPsQOv5S2y8w+Vn/hZ9HXIzZuF92fQ8XGEtss3+6NhvCTi17yhn79m9TOWNtfdl4g7vLGWDG2rxoOO0sI0k0lmTX9Nog9Ra/FZcR1XjHqHlrQxQc4VpuGCVy70x1P8t0MVpj159ABh75gnvOJtT3UnroY0+sccmd7jldg/p3KGtZLLwFGXDnXUCp2T4AfMEJrx5jS/wh1qEjbjxrWVCl63aiVs48ifBgdKysLsoD926mfoebuIspJt8gHzSTaSOaew9jBywN+h9+Vrqhr5zvrY87qGyWdRbXxqXVbpD0rSFhJFvZycEFEjKUsUMFUkZtPVgCplVt+ArGTBWKibvAoxayFadXaiPrOpiobGxnQHrzp730ktPXLz+yTP3HcyIumt28BDwVI/UnVY3q5uzWKLkJKuQN1CDRx7rM+IG1nsmZrG1tcrESjj66NOxO1ZAoL+DHvDwybxhLxghecADNcAf7ZWQQiNC9zBUSY1+2E7WFULYjCXWoQUv9SOHupDHjhxFS0nGT0hU8NGEWLV9B2UGoaAEdNSLgLP0aJAow32WL9ih0UgMkwy6fh2fgIfzc4ctVT11fJgmx1WZVOQlk31qr8vEU4Dp3H3hE26/ggVQwuY8jUKxjy/QJQSnSTALivc22JyMD2hTyu+LdRPUvqIT2Wu8YPnosvNNH67J/Pl17thGJ7f8bi6EjD+xFg93ANXL78K8xGwBEaTnErG1wTWUxVpO0C9q8LTmR3rhfip6xJQsCjZC2b8XRuIEYD/kHuM35/VOX6fGkpGJiQVhsWtKaQspOHsDiytP+cnqck+roykAvrMilRykFGLDqhCV+4qNX/Ln64RyyVhoUHNFL1fUCN933bOHcFW9I/WM1QvjcP6H+oo5TyzS+kdr0p1yoT
 FujoVDpl
 TPBeqWde4+YwYoMyxxFKLfF89qSe6wA8svFHfOzchEjg+/6Xhjb7xi1KaPKQus6A1HKYyd4zsiyOdbfMzPXXFnBnwcRvbkKP763SQguZaVJ/583L4wKLjU6DAzMq512mdgqSzCJEEooTMD2lyvIbX54B2QgFmU7Cxt9NjBEgAZWslfAJQ4nwJEaVTLcLbgzftAvAQrruZLAd1+mNHFxCen3gUUFVfbibn4xUpxIa0OhIpRMz06PvRYyqBsBwby2k/R4yXJYU/lgd6d+8LVun4+ry1lr/fPlslHavlvzhjW28vdbz81Ad9h/dynkTdzt7bYxNK7lmEbg5pqmsPED1nmh8k88Xm5ZPyiExOl3h3ccEo5MfxL3meuqoMu7JezLsoeVJYBpG1i8e7q7Mnb2it0RQe8yek/fEOzzzGiK23fE8vUDwWAmd5EY1Kvext5TdUYWicaEGVV9HW1R1KkU33+RBdtx/NDufBnbXoYE8YY+ckUFIm08UE+d+iozXeWbMRcYYYdI81lAcgPjvZgwrcCH4QVfwBYtGOBKRbbxBqD/pF8Cd+1PoYdwdiF/W25Rl4ETHZMhLZu8wO1bf7ck/YzBYNrp1VCkF69ZzCRqToABAQ2yjqmIovvQxp+RxsBPJw+gWmrEM4cV4f92DcpdzTkDDktN8xEBwIFQ9Utfnv3TruSn1rSldymCx6r2j7+5tZX758RWgUNy3QW62XU+yw39nQ1gDst+F0Qrg1lV9M+wS755ngjjNtT5cKX+WbyEwJAaA1hMYyP6lPXIcg+qjNKckjp2CJIYUS4/kzh1IOzjPNuvjXZVcsw5xRNGlG4d8wJHJLBJSeE+JAr0OJhsDRLH/Y4WvlKRRxzcUnSIjjryfIRHFIj9FF4SWMnCm7jR7JmkmOLALS4bW7tTtSuufUqXlWAdzjF8/lST1/Rlp7kQYDkKIibMQMUGecUFfBpGUM2M7uBJUeInMKOXCkBsNCYWgWbv/J
 /gypQ7mF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+45ad2baf16fce6bc81f3@syzkaller.appspotmail.com
Tested-by: syzbot+45ad2baf16fce6bc81f3@syzkaller.appspotmail.com

Tested on:

commit:         366a4532 mm: fix the race between collapse and PT_RECL..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git
console output: https://syzkaller.appspot.com/x/log.txt?x=11622434580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb90b5976661bfd8
dashboard link: https://syzkaller.appspot.com/bug?extid=45ad2baf16fce6bc81f3
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

