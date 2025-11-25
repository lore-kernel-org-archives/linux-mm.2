Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7598CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 04:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F86E6B002E; Mon, 24 Nov 2025 23:55:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0386B002F; Mon, 24 Nov 2025 23:55:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D0C6B0030; Mon, 24 Nov 2025 23:55:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF5116B002E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:55:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98DDFBA938
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:55:06 +0000 (UTC)
X-FDA: 84147915012.11.A89E8C2
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf14.hostedemail.com (Postfix) with ESMTP id E91AF100002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:55:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3qDYlaQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3qDYlaQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764046505; a=rsa-sha256;
	cv=none;
	b=FTVvGsy+sCpmADFzUto274ZmJdJ7Am0+PMeA0bZuiEALBApsTHk/VuoeGSBlbFF15/+ktH
	dwgknPVv3BFC3n/96pvdL+5aL1RncHRAXX1/+AB72YHnVLY7dneXKXCf4ErSsK5ptcGj8I
	oCieiaOgq8mZiaoa/qsgLJ73VZDl6eY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3qDYlaQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3qDYlaQkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764046505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=EuTvYsJjYZ52nC6UPIanqCWf4KWdWE09SuUtk9ibjLk=;
	b=t40u+wBm8LODx8XcBMx0PY0mbZGKI0v46eEW75b5GL7FUZUqO5h1U8DdXk6PDOics3ee+q
	kBXqfgcOZN4bLgEvG1yGEG/ZH81i8zUw+pU3mpTKRWP5fY0qZQVay5YjoYn0gfgC3pcES+
	qlcTvEnrNVw3g/eo9fF1bkQprZmv2ag=
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-433312ee468so47049685ab.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764046504; x=1764651304;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuTvYsJjYZ52nC6UPIanqCWf4KWdWE09SuUtk9ibjLk=;
        b=Y08Tit69/ecFQSpxIN+G+h/57VRoHVQNlwXrbUz2wDtjtHJlYUcpN7TL4146YVSa9C
         nFosly5Df0RtGtpHQh2ALmLguKHHUmNVAkb4cOSIGRcWmAiv5dZs9/ldkO45+kpuaVPT
         D47qLGQSSYBTdkEOIYJ8ThPV42GqxJu2FM/XcDrZI9iqo4t1fAg+bHbjJkVIGoEJ1CHw
         dgWN1PM136+iknvZyr28q7+3QHlkQt/H7Qjcr14NCUYXCQkV1M15Gp6aZ7ZN3a89E7SB
         vdmO0lC3iTES24Nj+oKiG/UVeqzHzw0t8iYMKt8w6+ZeO1g/zc+YSqSq/apxCEhdDGgq
         FWUw==
X-Forwarded-Encrypted: i=1; AJvYcCU9NNgU8NGr4qC0CCBubRrquwBgSdswIgY9QMLM3JhmrbGVBYNB2PcQL/QVz1qsGj0w1kJVMxaRRg==@kvack.org
X-Gm-Message-State: AOJu0Yygop6ejm9fz8qqwwv8IhFupucXqJoBORirGH394LlM6iq+5WFQ
	ZzZPCHtHH9nmryihNjSHIl9FvugbcZysuMNbCErKy2UomS/mjRas4GJWaySpyfpHlf8nb9uI/zi
	XFtHmnQivbZgf7iMDI0J+fQ2iv6m0Oa516fT63bGD2rzyTymrcUsS8B6lB+g=
X-Google-Smtp-Source: AGHT+IGTOBHT3nfAE4d+sXQy2xMLl2p7IUqX3XhPiVpIYj/dIWqcZ4Ye9gCaaeHZBmdn5S22fOlyhhvxPzu3Vy0/NiIzBcZy/XuY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e89:b0:433:8109:3eec with SMTP id
 e9e14a558f8ab-435b90608c1mr141138165ab.8.1764046504111; Mon, 24 Nov 2025
 20:55:04 -0800 (PST)
Date: Mon, 24 Nov 2025 20:55:04 -0800
In-Reply-To: <aSUwKBP97nd4kpjP@casper.infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692536a8.a70a0220.d98e3.009d.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING: refcount bug in __vma_enter_locked
From: syzbot <syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E91AF100002
X-Stat-Signature: hpxbsmos4xigzui198zkbcq978zpao9h
X-Rspam-User: 
X-HE-Tag: 1764046504-753161
X-HE-Meta: U2FsdGVkX18qHxOrvLc27+JznkcJesbFVt3nZmFgfi+ii3MGA4aFJmQUMIKFtES+C8XDbTSeA/G4jdqNjKXurkXyGkHWCxfoxyMoy2S73Q3U4VAwC+gfggEDf8Ge/DrvfDTXEQOJyKQ5i8mGDQAnoTSto5mcgS+DnsnQYWinSrET/ZG+NxMKmpmIGolUNtYDEta1QWt6fH6GTS4ywe/ZG4co+935RCvpGvBWoGJktHxxOZQiWjn/oVDG+G2uhmTQU8kIA9BEvGLbTAAiY2nd7gb/Qtbwx9qs7o5UDy0cB1gwSjJMGeIG3j9AaNIcpVEI0cFbhHE4ecieDvmV4QgWO0hhnShq6apS/rtg+ckQQmYBJC0yf9+BKp2tuA1gkkZBinGOUWiFo8o8HXKDh4lpEPiUvgwnldQzEGexjkzjuRNZzi37FvBRwayZp6heLWCE806CJnct1oobPi5PKsMJ7D1szrEDbMRQb2z1qH7LIh0H292wcuqrtJQ8V3S+oN0FT2J2MbOYlBxEp6OsAb+9GhwwSBsObw/8y2SC3L/kmaNQl1TIGPPIooXMO/pTHpVqMktb1iCaF2Lz08eO43/irV2EX/5vk7UJCNTOQvSuDFhwHXN8LdLfN5wYwFWYTUm4wOgePLtJACtvmseWd3LhmnlD/99E/9erHSSvsJsDnrr186jXcOjBnSbrW9jrRRTuHz/M2x5IqbE3h7XCot4KhKP70SzP1wMP0f+QWiG2tutdmaBe3YMzGyKfZL/FIynnxalq4GCW+o1jmisQs1rHkgGfUU/9yk5V6YUL0cXK1W/lijZzY5Pzv7DmimW29l9Z6VVac9gygLu7lrXgDuaLaymScytnCE3H78rJfPt+dMvDSH1baTb8ckV4YTgTbBJnWKMWoUZxtx+4f3eroj2M90Uvg2Ewv7HE3Ds3jU/BJ+J7+7S2EorvAkJVP4Iot8EsjKhc5UC51xhnSFk7wBD
 1oXqbNgE
 xA4Tw0GAZZfOIYLFhBreDFhrXLjwLiirMwhlroeJoOWU+cQl0J1kSTS6T/TP8TweyRNVU6PYe3FoPSLR+hUwz/3ypY0SpwhTlx6QvWKpxME932N5vTqhjcLa5jfgEpuXuBTCTPAmehizpO7yLPjsvZLXfEXp9sZ/OuMtb4fdueQIYB1wYKa4mWhQi2dzUe9icyZAyt4e/Y7w4s2eL2UFgiQw2xrbS0FnON43MHIMYZJDahWY+QKSct6KV3hnSdB8SkSTRBOaO1Ruqz1Mlx4xONnYuMdayeGUtUz/h7xZJl5u58VMrDpRtbOoEIX41aFFiKr3MyZmQLqd75ReIPxYrCGXbHEl0cPuNV0lSK+VPdHv5xyImP5nrLMagi+TFu/s1Y4zYJtUsRNlOugQwiFNwqFID5WqbQmlE8CuYkHRbUkzSRWNMwimg4AEX4cNsLXZP+LluyvsQ31DRr1tIvABZDsA4eGOdzamrCTebYzo+tXOEG6IpXTta656gDi8VXlzan5sIhrwDr/QENMS+fiHjG33nltsCwTh2rGFxuz7lL0cYEtUM1JrfChLQWqPlRPIApSLYvJtfXwM/yY/4ji1WeWnZnw2DKMWcLeuS/CeWCeH0HR41grCvRb1bMG/25VgH4tTZr5Dz9bo9RmohndtzmnVoF23CrEhfGNYvKPeh+aX/XNxs/tUA7U9/jMDEOGR0fHKnsRALMrU3xznHv98XcmqbaMpRKpklJv1aWsVZw3oCY/OYgWDmPv3pjMdM6LDc02jqEadX2c00d2EclTpgIBFPy+i1s6JCCqPZ6/mUKepGavEo8fx+3J4X7B6GEvgcET5sUo+BwmMrB0lgcNan05cqYe5Zh7kic/NEa2PKz6GNuWEZIetmzn8L2NatDjEiYekouRIeUaxvjL0nFcptgS3wCLf+wQaXjhx3i/UY3ZfLQnZb1/Z5qvxojtGN2CSxT2fHgMzeqK415Fs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
Tested-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com

Tested on:

commit:         422f3140 Add linux-next specific files for 20251124
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=167eae92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d488adfa0c950abc
dashboard link: https://syzkaller.appspot.com/bug?extid=5b19bad23ac7f44bf8b8
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=126d457c580000

Note: testing is done by a robot and is best-effort only.

