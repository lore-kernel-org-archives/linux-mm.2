Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6769FCA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 09:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772D18E0005; Sun,  7 Sep 2025 05:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A5C8E0001; Sun,  7 Sep 2025 05:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660028E0005; Sun,  7 Sep 2025 05:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46EC08E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 05:32:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9F2C1DF36F
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 09:32:07 +0000 (UTC)
X-FDA: 83861937894.21.E37FAD1
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id 13E91100009
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 09:32:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3FVG9aAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3FVG9aAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757237526; a=rsa-sha256;
	cv=none;
	b=FR6alVGM52/2lIa747PFOa1IlGnQltsTmWmdElbyLcZHEQmcM+yf7l4L1UmAz2g4Jzfpxh
	dZ0W9hBWSclbIN9tQN8xCFfyThYRMH8Ew1cbF5izLJPnEQk+JNp/jD0FzSbFY5wbHmqeTY
	ac0AXwoUp3kAUDU27CPBCZiCSrUsNCk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3FVG9aAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3FVG9aAkbAPgx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757237526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=q9t+ysctxTtbyq1Ab2N7qrEwllkJTwP3UQdHwHjnH+I=;
	b=SbRwNqjpyiZ9DaJFRTsWbSqZh3ifC+rb0B3Qc6fto1M9e4A7g2ptslMsEUg8o1cLuB/huC
	lUEeXKYsYNr444GvCPIlf4cB9ZWitpFh2VmpaS/9t7ZOhqyqzOV5pGCKvLWRE3Xnod/4xl
	qKU7KvPS9EHTLO8SFmzMwCixtG7uQB4=
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88765dc1f92so927404039f.3
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 02:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757237525; x=1757842325;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q9t+ysctxTtbyq1Ab2N7qrEwllkJTwP3UQdHwHjnH+I=;
        b=CPYlickTbRiiXPUbRmTFNd0rFOKONil9tXcqPNqDpAuiuPk8BUzbjjZ9hO4FLcepES
         /8z2icVYd3xvrjOMQMPWDsniqWJ9dNz7kLJ5dQPd1TA4na6znz6RxzXp9XjkTcQSz2+L
         AgCSigbp6Ibng1fc8LjA4KmW/USEmA1Ogu2LOkpfCI++FqT9cA/36K1Djk3aZDa/OD50
         T2U1IPRumPrMlysAf/leWj3K/ZYua1hjCQZoBpguzmLEO3i6nRdpYdzA5sV7ZH9lj30M
         iDMduGxu10vBAULIvyVJwa/avywshIccP8f03cfZZny5RSmZMiW14hTizw2VPX+fuWld
         P9pA==
X-Forwarded-Encrypted: i=1; AJvYcCWvs+q4epLYRxzVR6CzjXQfQih4zcD6jkFfReM7sPwANOVk5lkmR9od2jTbEFdV5P2rORdwXUstOA==@kvack.org
X-Gm-Message-State: AOJu0Yx7JFmKB9zOR4RzZNqoie+u7b1d4jBTlnHriS0HcYcW18A4LMBo
	p/F7rFzCbkgTLWaliVVMPFZpxJ5sAnzh5ckBlnUUSPz6yRDd6qiOQN5p5y1DPiXZ9pVF6R1lchV
	nYTprSs3Sedtey2s0/Mio8rMK0F5pPPVaRKv6ZGMcug7j1WJ7ur3ydZ52qlU=
X-Google-Smtp-Source: AGHT+IFIs6ItTPNB5mZLuQUCyBEpYrNRI8mq6k95OXxsS++Gfd+/8n1TTVY1i/bwyQTCkKaSJWq1Wc9jkM+og9WZU90mvb4DVVRN
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6189:b0:887:65d8:2bb1 with SMTP id
 ca18e2360f4ac-887776d35d6mr638344739f.19.1757237525205; Sun, 07 Sep 2025
 02:32:05 -0700 (PDT)
Date: Sun, 07 Sep 2025 02:32:05 -0700
In-Reply-To: <20250907081937.6583-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bd5115.050a0220.192772.01d2.GAE@google.com>
Subject: Re: [syzbot] [block?] general protection fault in bio_iov_iter_get_pages
From: syzbot <syzbot+b253ade8e1751d90a7a9@syzkaller.appspotmail.com>
To: hdanton@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 13E91100009
X-Stat-Signature: ogrpo69wzm6xd3ps48nh1i58edb1n63r
X-Rspam-User: 
X-HE-Tag: 1757237525-818753
X-HE-Meta: U2FsdGVkX1+Nu4J0gJet1X8807+hss5FvL3gOUY43Vl29VtXDNAG+j85YrWaMbXttSbsG5Ind8NuoBNnqAP2gd8niI2U/yOS4QJOVCFGtt84Im5i9rRPEZmvux0L8NkTAFd/eSH1TkRyy8WnZTwan+aVJIMHDuklmytnjanRCRcdkGHlVHT/Pex4Ic00TguoTo4Kc3XGNwYLbUzXF3npgeJp6Ct6dRTpJF1QVg7pTd3zxuk9O9wfyRe5lC5VjRoM5kfE6FhL5+1vyyyfs/HKKBB+tMwKOiSDCt83AAwHPQG/Ei47NwA2XsH6p7xpcCqdaS26GrHYUhOuX316kuPlcgotWT5L21svp+C0Eel9xAoOpxp8h92SiGufl2rp6YB22wLJ/q1he2z5Yq3HYXs5QWnz95C3rJZaZnz5KTou76QBG/gz34BroAUUX8GgXfbbrBSC3ikVzqwVDTHD5JYOrv79ofRfUm4T2Ss4X2WJX+iK4gjhpj5ZstH27RN8CP8Ns3CjgWgvzO8ZAu7NvTOZ6bqBf7DdSMd2CNAPFHAUMYTw61VSN8ynno40uWCUnokLKUxZtXfoXnm9Wrw464fZQvRDOgwSvIhVIkbMyTau186Q7FXMU9LSLNTaVXoNU9HJ9GGpgolikWIANaiv1yN5ZXRmenMeo4lRkPTS5/vjrzs3/jcy0KACuWLO55aBl3upR8q9fvBXdwg1c7GT+iJb5Lw928K+j/8EOn4XHwNXkq9JIMMA3bTz4+jxHKYlUIuJtGNjvUu9V9S+oMzr9I5v5I/H5VWK3dXB1bV+yt/+qo/uYQcS5aSfT6Awze7k0MQ1xVSjDOju8eU2rT0ScRmx5QXO/O+NfzgmpH/v4Yv03ob/048FDCXxrCb8QA5RG35EXLPTLkza+lVx3shQMVWpLKG7Wq653HdO3p9bt3x7fhMMXMDeTT1v+dcSiKSc0M9qq5lmwNVch9HIe/dZX7T
 WJzuyJtN
 Kt07aOpWq5OM8QTZ8gNN9UTmdj5hmvgrYmq4IMwEEPp7lrJ+xZFtvpcEqXuOyDeql9iKagRywOIAiKFnkzRYAzYP7QV5NW0/SfpVs0o+g2QFXbyGDia4I83bFkd1WK4PmWiVCVtkjopov1UJn0yVpf9FvBFZF7bxqGjsrSqiILmPIdaFi+8es8yOwvSFvmtapxL7Uru4YpEjYNqvTH7Jpu/fILqu93a3cmBIlPe/vNFMqQqNruOnppcV+koJQoT8fgQg14Rn7aCPGC2crEVWiHmzDFE+8vyuVwE7rLX38gGFRw7yewxdNBNe3PqmW/T3nhq1yHhQeKOLsME1kv9X04mk7TN8PyLVxwCiZGNUhk+cVUglG8Wu//BJ3xCU+c4tLgMihxtGCqLSvte7tf9FVrHmiHi+In2N2HqeB3t3bKZeDdmwr7f5QacE8JWFgmUhaQtAiQ5FXGMj1imr86CY0ZEJUZF6+hiKilBxsw5YgfdiN3XPiNZJZka9uajxgy2D8QnzBroojmnRsZhIQuvSTtiwlGEvM31+rv5zTirhZ4C5FdJBPCw/goU7Egbpa9uqokksym3gWUJ/qpUmrO00eUvUJtvKZnnsgd9I+WNxBCAzoQzmtpjyw8fOd4/0t8sSrOunUOyECbJdbv8O/czilfcUXjbT28I/Axf2nKXxrTnsr0zmVbHYQ/h6WuqMzgAttNsx0I8rt0BUzXwUB6kN1Oi/W94NHBQ8eXqnk82mAlR013lfabhuZz/kZGARLbWkPmVlpZirrPgAFGx8De/hO1f6d95lh2f8ZIevlnhZ2sxn3z9h1CNyAhQkCQZ1MAOytNVungB+r6eOCUBpfpn68nTjFuleJMpJnqMzqIfm9Vw+nO96o/fSt8fsJrTWuulnkqMFBeJMgXgTiLD9xU0s1RxN1/nVO36OVJwmZ5aKCzaUmm0u8Ke7uO9bnpZqgyhQYKGCVn3o1b2WCcgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+b253ade8e1751d90a7a9@syzkaller.appspotmail.com
Tested-by: syzbot+b253ade8e1751d90a7a9@syzkaller.appspotmail.com

Tested on:

commit:         be5d4872 Add linux-next specific files for 20250905
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17e2b312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a726684450a7d788
dashboard link: https://syzkaller.appspot.com/bug?extid=b253ade8e1751d90a7a9
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14be8562580000

Note: testing is done by a robot and is best-effort only.

