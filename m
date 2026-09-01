Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD04C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD906B00C4; Tue,  1 Sep 2026 04:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584F96B00C6; Tue,  1 Sep 2026 04:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A6E6B00C7; Tue,  1 Sep 2026 04:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2969A6B00C4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:22:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FB30C0376
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:22:04 +0000 (UTC)
X-FDA: 85164500568.21.C483FFC
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id E89791C0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:22:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3KouWagkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3KouWagkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Fxsg3tyZFfDboYC1KLQNAGrb0RmxM442yXMbJyS8HSI=;
	b=Mq7Dl2wnuxtXRnF/1/9+T6O6Ud7YF+nJbq1Ucogb5SW6f7TDZWQeZfwwtvjqqipHVpj+um
	yOYmSaZpNn9L+Wdu4eL2LkTSdClsrIVoFZemgFBeREyk/tpEXSkq7R8PaPiLL7vzZwOqTt
	BAwTot7RfDeBwD0zTOsh9o5olS9bEfs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3KouWagkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3KouWagkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250922;
	b=39VBAVzjg7HO13+9omObW6uS4caVEF+vaRviIz6oRjf3IzIPyO0Rs1ZVJRR2TYungtjANB
	q15WazzZs0g95Dul0hGo16KJmjvnQoHewjDzSBQ2AUaHNml30DY1ypHjoWpdFCJL4XzynH
	E6bKs2qzYtRNRKmD2O/25HCvul1joaM=
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6b1478e3546so516859eaf.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250922; x=1788855722;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Fxsg3tyZFfDboYC1KLQNAGrb0RmxM442yXMbJyS8HSI=;
        b=lfLFtJU/e7G5/BsG3x5YuOhNrFEFhE4DptX59Vy+QREJnDzD1680VXq4knzYX0uAY0
         RHFtqog8JqurRv6akx8FoMfbXK4N724eZ9JtbYiLRj7cE+HDB2/1i4AUg2NaHHhHPf33
         /OLtUTZ/RjtarSmJ++uQQBmhQ+eICd6KLALtBgcI8NvD43S0J0DMZ2BYJ5NoOoQ6giZh
         6HlWkn11XoeiFQyAFIAbVbaEEmB53l/t/S4CxWnssttO6Uk3R9LBhl4ZUbcJxMux8Anq
         610PSJoJs21DUYLyp9GGugfwdm0EpfmWnKL7H7DL8G9yjGSxYG4amN3xtDIkcrAAbXL7
         Zpxg==
X-Forwarded-Encrypted: i=1; AHgh+RrTXUwnBR/sGRjHASJXXg6eTX/iEH0lqHGOgQS5VZKT+XmQcGECpS8aSjfw4sb3Ruhl2nPVXyZ/UQ==@kvack.org
X-Gm-Message-State: AFuF++k1FI7Us1ufYA22uaa/zW6H9NSxBBqz7qWuBQQ+5Xccav5Zbb10
	kNYm/W56EpgJ2nOkfoG8pMvD5BTewZfeqmnwl9qL28xTc18Wtfw82NwSkE/0flMJhkO/I4cOdlO
	h4O5pZ98FE6wY5Ko6STFD1l6rrGqawjEe/zDv2GVqNUBOTbh8IZxIJkuLpkU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7049:b0:6b1:a812:9871 with SMTP id
 006d021491bc7-6b1c66855d6mr31267352eaf.18.1788250922028; Tue, 01 Sep 2026
 01:22:02 -0700 (PDT)
Date: Tue, 01 Sep 2026 01:22:02 -0700
In-Reply-To: <20260901014303.417027-1-junjie.cao@intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a968b2a.08473e0e.15b4ac.0000.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in exit_to_user_mode_loop
From: syzbot <syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, hannes@cmpxchg.org, hdanton@sina.com, horms@kernel.org, 
	jackmanb@google.com, jhs@mojatatu.com, jiri@resnulli.us, junjie.cao@intel.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev, 
	netdev@vger.kernel.org, pabeni@redhat.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, vinicius.gomes@intel.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: co8tk7477z8w8xyxy1u4drdafk44d5w1
X-Rspamd-Queue-Id: E89791C0003
X-HE-Tag: 1788250922-318759
X-HE-Meta: U2FsdGVkX18K4VMDZBaJ4PoLhnZO2N0DQVU/mmLIj07iiZcrJ4aDqwb6MwSvqqoELb+gAhwJo5WUnjoNQ50Blrs9guRpDzXLbZUYzckp7FGMXMf38bCSKUVDloTcAadvM8MKbPDWwFB3ninTHay2WgTvOsKWf0xQPhWUlp67LpZJrJ6IxMlVYf4AJ634NG2eADH8zo8I+4kfovKAxvEATbS/10JOgAJEdCtlibTN3nylz0pvBup8JxO+l+lvYUyEKn7EdTOOtX0y8wcakR3tRe+eP83WZ9VGyBE9kEk3bRRSfXVA45NBGQPpMKyC8Y/7h/Fhk9cCAZY9C/MGZ/thanT6ka69lhoi/d/QRaER6pMbklZfyBnvRsv1GRL3m5AE17H0nqgqrLNETE/5Jnm/EyVAUpOg3s8Wyhjo/bY4wZJnfYnBCVwe2aKQ92qF8qNQ8zka4Uu0/jJocIsrnwOwendPBsvElkHBHaEQeLAXH+slTfyGpLQyBEGuswuET8zSFdfqHoJVJc96a+5JGRvoYYrAZg7gRBSiA3o1/TWzEphSpwXhlX2NIk1x3QCTbaqXrpn5mYxncpkdLP5IabtSsNUBpb0cup1rgrze1a451qZY2dyFwa6Q9y3Z2NGqiDVlZ5J9Fm7d/V33x+BmnD051MKpSL2dwjxz9sXz6L50V1OXMn4XdUP8g1OBgCVeQuvNnG+fGDn4ooGTvVpcHz6U6Ven6SdwRoIgxmWfkNXeliQP4mNeTbnWGq5vsDbj+T5KAY7NaDGsovwe1Zo3ZtxdozMOPVsFobRKG5jH2/0ntY+RfBoDTa0RALQfrZYZqtNqbEbrwEqlR130wbWJ7wZUgnfwE45TjXqMSpd4PFFIwnftVSQRHypEKrUsBlM2obfT0Hti9Pg1qx6y6yYPJPSN0m/FhhMOYTcHWMHve0mwZvEzYHUnIc0VvZxS5dLgZU7tNb19TVxg0Q4xsI7/M2b
 hUywW10c
 XXtOfYArLqT4qgflerwXfKYVbtNy7GqDEPhKnRDCPUtbdScA+6niAmgfJvOtQToXh2sidrB2mfzO7NsBFRRwYnCWstrGE2gP0obLrcQ8Jc4ku2YXtKCVxMwF0TO8LW3fn12+9kiG1W3i0iBNLmxYTkP1Bp9q1c0ggvOPsXxLsRT3NtYaVv46TQnDTtTzoNQswpzvan5SmNDliqrx4L9S6kcKeKBzLj9cp+YE0uShRLaQgzywbwJHaCQXsfjuZzSTZEX0rg2J4ElOdnPb0otTopgReP9+MLBXLABYcRiTAe+H0lSbsMlS+f0cvnrCdvDgnoitVNhGbb31N8IShw0rXF1QmCB8M1Dy9e835od5iAqRzKahnwAuM0n2tWyl3+apxw4Zw6h9g7KWNFd4gI6bIedfwqLSDFnYjxpYvbTw42QZtga/S3JcX21tJuC+nQ1CFWWRH6qhObix0YMerhXe50//Tk0mGwHDXh7gtCA0EHy7Z9/V5A+6lPmXUayyBHnKooN+pgFU1YV/GKL17sXcpYsPNxMZSvkFfTM/LFBGzfPC2mu6l25w5KG0fjHqUaGhOq1ISq5ppe5tKvmWC4Wr+TDJ1tyeZSmikiE3KAqISQ18q52ILtVsz1cFtH9c0AN4CTxjnnGsPyNsxEb9zH6WXLjh926sexf2vUQFZ8CS4GZmb4fLNSAHRi1+f26qBGT/E2R8Lyrheq0kogyqVQP8VF2Rsqp7KISX8/A11GRyF9ZVWELX0qu3rReLBbCRUAgGw8RppEXIOyGye78SNhJ/dtnNANLhxmYZKXDy6urPMaspkzBsNLbjjnWtJ4xnUDfyOsjqjPRgr1c9jVseQ/y98jrTivZxQtjBIHto0BwLEdYLHbMaU5YC7K6FlGpul+CfeWXK7QQ4yD5okAEBAjKq4DqpW74RCtV4HFHL2wE3fWJ+YH4pIZeLDad0TMNGYkEySGJ4Absh5WyhpJtQJfr3f/Iw90Fyc
 Om3kvwhc
 hMBZykkI0lB7/KzvfWf1ILlCNR/H6MSl69SYO0vp/cn/jKTgDIoZL6U9jx9yZ6VHlgwVuaKDCkHauY2/Mya05S+70y8j2R5g6Q3+6knt/bsgvJhfPBHJfYwDEJ06HXH9mM4dnCuS2VjTxw1nKttjuqHdLyvu+criW5b68pqwGQZUDorSTAA1RbS4mRR8RLUS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com
Tested-by: syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com

Tested on:

commit:         abdf623d Merge tag 'wq-for-7.3-rc1-fixes' of git://git..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=123d1379580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9cc692b98d9b4fdb
dashboard link: https://syzkaller.appspot.com/bug?extid=2642f347f7309b4880dc
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16f7eb79580000

Note: testing is done by a robot and is best-effort only.

