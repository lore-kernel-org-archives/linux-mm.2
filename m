Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1E6CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 13:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF248E014B; Sat, 25 Oct 2025 09:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF938E0135; Sat, 25 Oct 2025 09:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC738E014B; Sat, 25 Oct 2025 09:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9775F8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:58:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEE9389415
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:58:05 +0000 (UTC)
X-FDA: 84036790530.18.BACDD3A
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf23.hostedemail.com (Postfix) with ESMTP id 39FEA140008
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:58:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3a9f8aAkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3a9f8aAkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761400684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=0hX7Xmy0Kxtzd20tdCrVN3WPsq+s3O89wFoVx+waOf4=;
	b=3+1y42HaiWn7fL0JhypCv/1Glhlg8HoNvd5KgyR6mVsIgYvbVWOxtyQEdkM9wVKoaweQcX
	j86eLY7zuLd1/6MIDoXIuPl6aoU7qr8vb4GzcLoRQw9L2um3CL75o940CWO+etgXXpRyVb
	DpdUpzsevT/FIjbIgKk3wOLHTU7GGC0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3a9f8aAkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3a9f8aAkbAFwMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761400684; a=rsa-sha256;
	cv=none;
	b=lZjngYWjH7zkifGQPTr75W8iGAuXGJ8B0lhmcYJ/8F39ooZBaUE2RkTyp+R+yWlUa0xEOl
	wIiMmDCOGCHpWMsadqTxTs6059VcCwUlSkCBvdNxxy2bzsjDXvS9C17DFsNPkiZnF60sQV
	wHCojdDDhhgLd/z5M0XeMTE4yh8sMa0=
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-940dc0d7a38so464003639f.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761400683; x=1762005483;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0hX7Xmy0Kxtzd20tdCrVN3WPsq+s3O89wFoVx+waOf4=;
        b=Ul+TsaGEKla/2JCYk9Q1TYdMozCVJP8d1TpVFA9wj3iyUXc4lui0R1mhnZATrXIXKh
         4+IoKS1X44v/3M4HlKLNcABAeGWUQgYwlxWOGK4OZ8dJF//QcQOfyC13wCT0zm+KFWZt
         QxKD5UTwH6MW1aUHV1GMyIpQwsTYYWGPhZVaohESDavrF6TkAGa7+5avy4hx5bOyDzus
         W6HgRt1sjaLS4UYsmKqyIYGVteKHiPP2+FVIavH/gV/o9d6CWmfhhyBvOeUsEz/lzvdi
         MonW5waAoDsqh+xcYDVfSPaNT+JKmDsSAhH/se/TdHWYFi8FMpDyHDHC3ac2BqmYBH3y
         WRNg==
X-Forwarded-Encrypted: i=1; AJvYcCWqwTMiyp2r9ELFSCsyVCPzi3IofSMdKl077mMSI4gDKRwiwM3FDzSisZO90i1Fqk+Kas/iiCmL3A==@kvack.org
X-Gm-Message-State: AOJu0YzbyhAA2Te7XLbyctejJMskwd7IIsWdhl1ZCP8obz/aLDCS0BxU
	gfbsf1V85zyB2jLb2+vg1BwI7iJxD8/V2xZ/r1/gE9smcT1xvA548BdwURDC09QtsQ5qU7DyTUj
	IRvN3oEwR77Ow3C53hd95B6iQMMvKjhYRt4ZZVyHU7MJp3n5s9W1acybv/ts=
X-Google-Smtp-Source: AGHT+IHLuGup7FvrtWEhAdxQW6pc+HkJp5VkQy3kaEW+3FCzq6/u86oSYHu5ceNO3JAKYd3Jh6ecMUpxSMld3GyW6SPg7BvYdW9I
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c85:b0:424:805a:be98 with SMTP id
 e9e14a558f8ab-431eb63e7bbmr73145145ab.9.1761400683341; Sat, 25 Oct 2025
 06:58:03 -0700 (PDT)
Date: Sat, 25 Oct 2025 06:58:03 -0700
In-Reply-To: <kwl4tk52z4cl5d5wahcmfh6skff5mypsa2jylyd6ag5nhrad3j@yawn25geajlz>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fcd76b.a00a0220.9662e.001a.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
From: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	krishnagopi487@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 39FEA140008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: aejctxzbc9az6myz7dnms1pt6xkzqi4d
X-HE-Tag: 1761400684-937389
X-HE-Meta: U2FsdGVkX1+YIpgOQycWCA0IdWAj6HTRaqKTxx71SB69MLTOmf7bU9Q/Ir2E53BKbjCo9y0oTU9hvZm+1qB9BX8T9SG5mfH62jbayvqbYu5/cQpB3zZpZcnY59C4CSUGi9Ph7nUBPWqVPEoIE4hyDqkH2OMbKP3bwO8Aj5SuJ8wwfI0TxUiV3s8ZTxZgHu0D0D4at6RQL+O2xeYPBL9nXZQVI+hbd7zNXkKfh0vBJTzxIqVfNe6yE6fHKja2rCeAz3obYTUMyWWILtJon/qxtaJkrBcyG+B/RvwPzTZGmJMAL2OVz8iJ28zkoRnwoEL2z1s1n5ajvzIUkpMEABAkJ9F1P9cmJAGa/C2jhngvohlsR7WnCc9AOnl55Uv0krBLBpy47S/sGP9hLLct1lw+trKCju6Yf6r73pePdhrpXWJZD/rw2XZnO1Uln7By+tQuWbe1gogz67qt39+x4O/Vx06HtWO5hLKqfeFE4iZBgyCgk3Sw8UsHQYQKPxUoFzpIh0bRl9DFHwsb6m6J9tSAzI8yDninZR2leSSMaeHanEK/Oktje7H09Xxd4CloRkmRhrd1mq/XcX8+5F81+MN6kNUlUC4Zo9AedVbzr6kvSOBOzy6IomK3gbIb+uEh8qxg6n1KcSvn7eb4I0QMNc6CpbkEKeMumIhVUFqteLJCMQkDoMQC3gxU1500uj9j/0cRyF9FspCDzCplrhvXZUarvRYmB2x2Hy/Bs5nREKqnF4kPve7vQzCG2lUIFm3T+Ix3GF/5TUy9f5GeEOiMic2+dJMGZzC/OThOOCgKGFyNoqMebYpxz/+k/Sz9cC1KdSJ78H8kZamIx7ac7xqO36wtFzwgcjHFlyN3IIx3fGAsAXsu6a440de0CZnUlT3LamAWhGQJR6mjemE99dsxMzXgFdzrxixW1hJoJ12Nqmm00yuA2Y+RIiD6iwQF6o8yHVGXtNloSdskJYTPK0CC2YG
 ssA7bmYU
 2WAJVSijSs6l5uQUnGnwSMVIeBEUiz2TD8GwNBv+yHxXwnJhFTABP8mz4zzMONT1JLu8Il29TZOqRw7Ila0120dV1qDhDTw9ELgeQ3rWBPPdJAswUZlAdDorJqCLNGVlBfJpsG85lHma0X3OzE6VwTm/STtk2MZI+yirZ9JVWSj4lnPtxrUHQTMImrJnp6tbSgDn2fPSylZ1KxG92O3Wn6XHgWBLwbx85Za6nIHzUixGCqMiX0xIkkLu9Z7WCVEowf1tFFlW+0Zha1wWftin+KM9d7Ta+XxI258DeLIFVfKcmqv31eHYn5dAdSRF9QcjI0lELrbKtRRO3eLh2UsG+W5YCdypDZfW9UNxfikZ8xfAW1OAqxRyZhm8QuGGiCSRrZ/+htd4UaSBJ6EmCox2tV58fIASWTBQndNP9J7gSYDb2JIdx8b0hXZXkFkJTqkx8e+y82+MlQPtZKmzJM3V1IGPgiodXW/5RggovGEpeqbgraA3VqBj55lCgvRo5qrcX8cM/g4Aut4T7MbiVEq9WcdUwK0fv9IQayDnTNE1CxKQGWAQxyG822r+o3KZSESKY8sRHSw+Uu19QKA+spIm5grWGPdY1ayrQbRPqd4YL5AGu7YOwPAjX9IKWRo6n16wOLNBhOLy093oI/tDqrJjUj5iTAXP46hFzsskv3DOpc2+Yzx/KDtlomZkvIiTF5dgHt5u8xcL4KyYpCWV7H7KHMP9bZ8EEEBcxFr4tke43adk6HoRK1ssWole7xGLzbRMR9OrcMJvY978Yo8/ReL1mEsqLdCojMm1z1pIfT9IRq3Pt50RbdJmu8cLCbVNjFI3tYJmRffAaQiouMTqspyHZWPKbb9hHtz4/w43c8NgXL+i8FWLgCrJFKHsOknOq8vKwAtxEx8sFPGum9J1vU//+uh3lim398mqDvNQnG+PgjmgC/vzhI3TM3OXQXYe7Dka67u5q6jK/nO09/kRb5/6jEntRXfg9
 Lt5RHzDl
 mZL8c3Lp6qfGI04j4KMBAgoxMaDEiL46LHpzOTHmjbCGaDDX2FAHpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Tested-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com

Tested on:

commit:         72fb0170 Add linux-next specific files for 20251024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=133e1d42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10c72614580000

Note: testing is done by a robot and is best-effort only.

