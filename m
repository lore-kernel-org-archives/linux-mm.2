Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44164E8FDA8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 16:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067E56B0005; Fri, 26 Dec 2025 11:43:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D776B0089; Fri, 26 Dec 2025 11:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39D46B008A; Fri, 26 Dec 2025 11:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D17826B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 11:43:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D484C33E3
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:43:04 +0000 (UTC)
X-FDA: 84262191888.14.42CDE39
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2F4E1C000E
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:43:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3FbtOaQkbABgGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3FbtOaQkbABgGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766767382; a=rsa-sha256;
	cv=none;
	b=mZMawNxS2xJyGRLZmB97LeSH/1XaiOlLlgTCl5738M7Ot9gIyK0FyJWnszVmcAoFCikGM0
	3M5HS3SzY6sUB4bumL3VS4X5yMyt1z6TVmEV9dIQm9vwfOrUwnNoU8htsSt9CvLN2V5S9g
	cYhtHGh7NOqF1waOEw+oc8hdTB7v6Ts=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3FbtOaQkbABgGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3FbtOaQkbABgGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766767382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=53SAgSKsIJEqDYV+s2VQZXX0ij5NAJJbDSc4ix7LheQ=;
	b=MJJAJqZNWApSmWhfm+Z2poL3yQcCTfIYluSPDGCrRrDnAWfauNo3CL+Pen3Tbcp0K5QJVF
	YaKcXRywfbQe0aym8qLTDwC0beYdab2bf8E1UUfv9Aw/fpBSONkjmosQjT/255JmXl49xN
	SHuqNyIVRJhnC2D2rDAVj4urTlMFyuo=
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-65b26eca9c7so13448014eaf.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766767382; x=1767372182;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53SAgSKsIJEqDYV+s2VQZXX0ij5NAJJbDSc4ix7LheQ=;
        b=fjN9tqOOmi/ViCkdhoAk4rq0jwZ7mftYpBXgxPVATnSuMhJ5zP+BwM0PTYUdaJLh9h
         4kbAr2rQLNqEUxkJUSnayt/SH5YzYqYkU40Ge6FmCOHK/kqXB0Kai/xRyRTxWQw2oah3
         3BbB4W83o3LRPKnZZMzE6HtUiSpHzKoj1Pc8oa02ho7AmwGOURx/EiUw9LkuXLzivfjp
         GEwijelo+EcyDk8dcVNMsq51szvEGow91sOCSDsRxM4c7Ij9y1IudSIAGRpDFqFIIIhw
         wgISTV5OULO35rJR2Q3fxtS7lT8ym81gcb+pc9TPGL+coRwqq0+mQHDERtRoRocECKUW
         WsSg==
X-Forwarded-Encrypted: i=1; AJvYcCX/VQhNWRP/se2ri5Leup0JEaTa89F3yclM1QL/Kv2GFQAUD064W+XC6L7vMD5hbiGhJyC8sh6e3A==@kvack.org
X-Gm-Message-State: AOJu0YyYh1SeRfGOH73J7x4SIHyeW7H85SK43tP483wdVbb3r8SvPW3A
	Sp8ezVcfz1nNeYFYhdk79YI72vm16kBZHjZhXryswSkPTqqqs6CktPrj7iAeiA9nP4kGCaP07Xk
	zh8EAwiYnQIXIBSCOnfN3VnXCa4M8DNbizI8DTpen8QhID93ZvIiHok5bQHg=
X-Google-Smtp-Source: AGHT+IGQPSV7JiVQmAQqG+OQX04xZJqT0KUjhT9g4KHv4Ml5V72eS98RZ9upgzLfwU+miUGHK3gQTCEITzja2y9xosWteVUkes0P
MIME-Version: 1.0
X-Received: by 2002:a4a:e252:0:b0:65c:fe8b:53c6 with SMTP id
 006d021491bc7-65d0ea9932dmr6960121eaf.43.1766767381887; Fri, 26 Dec 2025
 08:43:01 -0800 (PST)
Date: Fri, 26 Dec 2025 08:43:01 -0800
In-Reply-To: <6730d6bd.050a0220.1fb99c.0139.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694ebb15.050a0220.35954c.0076.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_pipe2 (2)
From: syzbot <syzbot+693a483dd6ac06c62b09@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bigeasy@linutronix.de, bsegall@google.com, 
	dietmar.eggemann@arm.com, edumazet@google.com, juri.lelli@redhat.com, 
	kerneljasonxing@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mgorman@suse.de, mingo@redhat.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, peterz@infradead.org, rostedt@goodmis.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C2F4E1C000E
X-Stat-Signature: 9qxsktwquy4gbj7ignsawrm1f13ys45e
X-Rspam-User: 
X-HE-Tag: 1766767382-852176
X-HE-Meta: U2FsdGVkX1/7J2wHuqV+w56L1VMUKJA6LGIN5mrwmE4rkDwbKctLE2wHlv4ogZ9EaMtRRcd1J4V3/OeFLto86ZU2sg872lSEpt+svf4E61Z0pkHZL+FdbAycKMrpMf8f6CLL6UytN6gJMbt9SNMgXl48EJdBasrzSxXWOiWA+eWnR7pvGhuzjltL+aQ9gZZtwYuvXyGW/LHMcQXFn04Mz7HWMyUB2vHbZqMy9I8vI9HbC0wQARFLThTTQ9zOP6COxvznmIbpj64Wa/MZ9+o9CrwKjHhaVfxd2Iktg/nJ5k+DZWZsIhpXBDmVIWx2NGMZIsja05pyeDOvV2PvtEH2NUYtZZ9C9ohTy//3oSGifvY6/L2sW7v/yB6LnaG9/K+Ecxlwy9ElskCpHRAtCXZzA5TyE81FK7mS60Wnky3hJHyomnjnb2eYlrGw3QhoEE3QZ5IK0Z19/5Q0T/Cpk1PXXwOf6KP0nAuK/h+tQVz3puAf3v3jc+buMU1XMzacfM9+ATO6YZW8TtSjh/fiOBOg9bG8JSybLj8TAtM43JPSN5jrd0HzMlRzDFO+rgGBUb7qI1MAFXv3fS0nC3/940T6vPmgDA0cnU8pU6+sw49OZdgpwMcFMTF7TkHuXhphi1EbWAjk78+k1PbyiRfKZRGijl9jslEmJM6NlqZ3Up/Dz/nwEeqNbLSagTMsCdJiQ6cD1nXm5TEzYI6x/r/hLejkSBeGUVa7QhdZMNqf+Kk55QAKM8tBfXsz9RrxaFWt6kAnT1kDLcaM5EzR0VRhXegYkUaPMqAMVflxjQ+D+Gq17D2EPRRr1Pby1kZKZQ16uJnEt6EwUKJsdaZ5xcxI7TgL/jxKe183b49AaXmj6zqiUwB9MXlPJskSmjVlo7jzruRvjBR04Nm52Ly2r0C6S2+PbJNWOcAOyimxcGDWaUVM2VySbQnCKO9d4XOxOT/ToA6W7ImtEOx07VeUzzsK4ms
 WCkNyKUD
 51r2cUmEYMpzF4J6YDCut/REUHZG9y7kqLrbZmKZ6JE1+pngPr+CTt8vo9My0uLu2OE+zFGuguUClBeuOD36xYXf3C+JMfvrKPY11NQJJmwYeTN2by5w+O/3Vco+HGTIxwNxs4S+LgXggHkOcB41M+xCE6eXk7lsPm/9ZXnn6srRps0Vzd5snEED9fnVheSTI7S0QMbZihYYu5KwHuDBODlYhgtRAOCgpXl35X8qG+jir0WmIKCjvuljPrt+JSUAA3+HGYlwUayj7GOhxEn8Az5dmkXWKHTbZFeGCYoeqZ+k5sYZCoU3o2z7no+t1atuGQT16a++DnyUryXRDkpiOb1L5E1/TfASYaBcnTZu6ggiZ9j2PrvAwGyx+hd+INROdThvI6mw+T/cfYIpxDnqM7IzOQzT0fTXl9u+SA4UL5XGuvtsXM2IICvzAZ2un646g4R53XERC4sL+9lg7+YXd8vuiGGi1G4TbHoI/h6+blJf5l8hp8eDQpbmp7AyC7z+J+h+XdkcGxY4Gh5Qmpn1lglWj2p4MoztvFn6JFY+nCZDJGZ/TiZtUXxLEUgCaU3Vs3ZUiPPQSUe0TKn0trDD5Fvw9fZAZ2NXxWVU1OAp/xeetBGZE/Ju7UKOkvMA2yOMLVKfyW6GlzGEGoNKv8g0q6DqNkgz3MABFOa/Yb+j8AWvDagJQlOVetGzqXIVRO6By6a3Yce6ic+HEOA/UbUsB1ysmmWZSYNedfbCVbuFi2ZmpSSKaCeh1GKJc7MWFXLC+Zzpdy+Yd/d/tglpH5nnI6tszzsShtAuwSIMfYckXGvomzziedxaIt3B6S/nAu6Z4JwEE0AJCjdJeAu/2rbIsad8HDXvcNFuCbH1TK9Bi6eAdpFhZI0VR1fJa7CaLJ8t0CKGNPY5sFEkSnL8WADovMNOfUOZK8GSYwZVgVGWpq/h3T0AChMnG5wBD8cqL/WfpVDR1UDpWQ5oW8vv5LVgv1H4zy3Nb
 2LtZOPMS
 Ub4I1RYt+xwPMQ/ZKLjnRLdIo7Om9zIHI/wc7iMWZkSNLa6QxHdcCGt42m5R+PM9/sNu7ct1cTXQOHo5j2P5Ng9rimRMsulr0wzrZEjtN0xrK8tIDVcB2tZ7DWkw6j1MVu8hVZIAuLBkt03kvJC2GXTliIFa9cqFyc0f5KcNkw3/UakT6Y+9Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot suspects this issue was fixed by commit:

commit 66951e4860d3c688bfa550ea4a19635b57e00eca
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Jan 13 12:50:11 2025 +0000

    sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16c6eb92580000
start commit:   9268abe611b0 Merge branch 'net-lan969x-add-rgmii-support'
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=b087c24b921cdc16
dashboard link: https://syzkaller.appspot.com/bug?extid=693a483dd6ac06c62b09
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e7c2f8580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

