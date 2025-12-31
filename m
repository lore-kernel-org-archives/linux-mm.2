Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C0FEE57C8
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 01:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37D36B0088; Tue, 30 Dec 2025 20:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4CB6B0089; Tue, 30 Dec 2025 20:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1216B008A; Tue, 30 Dec 2025 20:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88EC16B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:42:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F4FBC1C9C
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:42:05 +0000 (UTC)
X-FDA: 84278065410.04.5D7DA07
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id 70B0F1C0004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:42:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3an9UaQkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3an9UaQkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767145323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=gTZZjS79VHrfpj0W1pWmRNTRak1AXpPtMEXkehl7HRk=;
	b=UnuNrrEc9ccqzAvAsyUKD7qw06WXDww0qEc//LiuIroLGUKP08rCyMkjShHCTidr76VmT5
	PyXY2uyTCFvEjmTF83cMpfDkWNIB6em1QVJRq9AjvOUcycawMKRpmxji663OW2zKAWbki4
	TKpBfTH3ZlSQCdp8UvFo5Q8hBqA/PWg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3an9UaQkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3an9UaQkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767145323; a=rsa-sha256;
	cv=none;
	b=aukKd3+78RWjhHX9T/tiNty4vJaQJdZ/6QSyyoL0O/wM0D8D3A1vLotOY85kSy4gHZWhA+
	zJ5hxrLDzlJ+AR188D5dsr7Ln2ik5WCquzGwVCCEvWP43IjQpFQUWRkrL86mYW/8A2EHsX
	1SNu+DMntvedhO1wQN97JU9zYx89GVU=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65742f8c565so18804673eaf.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:42:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767145322; x=1767750122;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTZZjS79VHrfpj0W1pWmRNTRak1AXpPtMEXkehl7HRk=;
        b=I7xYh17UUHzTmGE2XxU+6gHdIBqf071R08LNlYriL6vGWD1jybzqs/A9xKXR1//x0V
         n6DCBpmgenfhOJyF+2RU3p/We/fMhoiU9MLU2LhzsTxSevgVIjTCBCQ9B2mkpCipJR0G
         UXdlR5s8j1bUHoJGXKeXFlXAEzSg+Oj79mvDhYYkmoCbiTT8bbk0c/SqIY4Ism15OUsk
         +tET/wiadjASO4CapDwoA3ZuLyvRfbD8cCobB08dN/mSntVWtsWqF5yUBrFC8LlbZIaW
         lYRUWrHddHvELG3cQ+p5/FNIAMcM9wdJqqpwFD6KXDyGDp1PIol8VwwB8SFHNJY1Gb5k
         qfsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkQnVaRjP2l0917soGn2aR2/rD4q13Y2paURu7NpOoDXyQ+Rw2wImfbpi8gmCHPmwMskXkPyEyCw==@kvack.org
X-Gm-Message-State: AOJu0Yx/qlgd1tBXQwslsSWuHcpjkUuILvygxVib4WkPObGdCUoZbI71
	fhUYrFEWKFzsx+NP/fpex46g6SopuLGatniM2ZJwGkR6yRs0/8VfDFD1i1VL+JlS7uy65/r03q2
	dnvUyo9eQ0n0y171+V5ivbXGFDWK3WUOvtH6DHMQAiDhKnCKDg0/H5QLIwj8=
X-Google-Smtp-Source: AGHT+IHxNzByy/IIqB+GfG++jCTnMxPHAU+BIqEALwrSkaIPtHK7tKgpL7oIzY6zR37aqpu0Jo5qfft1DeP4tsACTpcUsq5RaQ94
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2305:b0:65c:fb01:71af with SMTP id
 006d021491bc7-65ea0345582mr11615339eaf.5.1767145322587; Tue, 30 Dec 2025
 17:42:02 -0800 (PST)
Date: Tue, 30 Dec 2025 17:42:02 -0800
In-Reply-To: <67a4eae3.050a0220.65602.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69547f6a.050a0220.a1b6.0308.GAE@google.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in list_lru_del
From: syzbot <syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, gfs2@lists.linux.dev, 
	hughd@google.com, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mmpgouride@gmail.com, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: 1o8ij5bqc9yn4ioie467k9b45r9bdbhw
X-Rspam-User: 
X-Rspamd-Queue-Id: 70B0F1C0004
X-HE-Tag: 1767145323-51691
X-HE-Meta: U2FsdGVkX19o7Z8d1+9wJafeoQIed0lt5pYzvOTWEJL5mTC19L1Y+qjsVJdyaKdIeRrhAM2+hS8XyaY7x+JDhcBT1qxaK6pejBVNR4Tc9weMJvO6u6aW1t54wfrdczuxQLq87/0a/8tETTNBFe5Yfd//yT5ophGxm45+4uXGi57UIaMSr0ax/h0RcaHMvRCALBSCByBX8yKoHHYQCq07tXq2AsfN/dXD4J1bepIt9kovO8ZB6ysp0VH6dfBPqQS2u9iqzzff8akiYpr6U766H7q0BuZ5YGAPneU/EEfsDMIlylHLGfybmNENCnA+w98WEUaccFaiMgkqPp4Z7BA4B6GzaoQawmqLpwchoelaaVZ6WB/W6zRCLLcHW1Btds4wZBFlyrfE5rNfHtFIBSBb2hrWWcyIcIJ8Ve/zjFR91wDUcF3Dibk/McPvr4sbzNF1qgV2/EIBvSZkNTJor3vTxj2LZ04GzgjqXmQchsd3xKPWxLgwo+Hy36oY0dlbQwB+mYFoh0rEQLbFvCR9aCAbhqLeWMR3eXWb8Tn0tkMsGjidVpYriUEOWh3CLIMrImGwAu8ZPQCvbNmywmYcdjI7p3ioY5qowIYASc/Igw2kBtt3mwxu2wVhpG2mEFqiMMoRziuzcZ5o7HJhhh2nsfHLanNolkRebfAPLIMMEx4UvFmRirtJFuVjVVAFlmi6BO3rkmvWNu57nWG498ZR/chfykFKpy/8QwzqbGog3ZO21Cq1We6IC2JcTUPxND3d4wSFR7vtaJNYDaIPsH/G/XL1QtaKG8ZxIVsB29o45uw7KyEe6+yjimNtEjPciRFVdDtmjBLR7ycJMPTtNJVwjsIqcnGNTGXEE4+jni/+VN2Q5mxTTsb9Kp0diznP+w8C1K7mR89XND1EJA54nU6d+o8Zn/bcAKvQ7ux1GaHhfb/GTwnTxEq0fKCFlTeo7uON9cBcOuVmlM/oiE0Ukq+DQ/k
 D9KP0lT1
 rPC3IWnxZUsQ6D73Hplr0x/P+6CKRCay6kLV5ejV50pSqeJ+k7jSYf9FlnGZgoqd1B0OfqCaBUFRFBD3hMpW/Qg/a5STbLcS4yuI9fanqChSFTiZVkw61lVc1CFNQY4nD6A5TAMO7urQ64WQZOsQz7W1Sj43F5GgnyqjistAEKULLBpdO0NFil3kdoI8/YES0G9PCFFVIMKgKtLo9UoxUkVT/CkA1LPW75QT2QFiIp+calpvH8fevhlVb/mgfPjgZzm/47W1tMaTbqV16PDt8KvwdwQFhalpFybNTZSS+2tpM7FqUHMMUX2l4sWqheObQHBPhdlldQzIMbPgNlVX0KyGSj+F8RjSH09SN8de+aaMw4V6bIq2SWoqI6LZVI8evBs6p9VJsR1xw4xVx+sc2xpkH7dajAdQIGuzdOeAsbTejLOQSoGwzKrNtNy3JZPpeE/umiTRqKofAQ1uQdlNIxBeDVzeL9G0MCvVz0ArqDjhTp6azv4rOrAOEaG3uhs9/zWnhErgtUYUVDo5pzzQGw/G6IiDF3kUubuMpS9dvUsqDAxuv0tWx9gQmmTkJrHZZeV7+BQE+jKyRMFydztAJxaJ4s0s28JnqJxP7PRBvPzX1eA0DXFQlRrkp+uRvvosF94UrC2YOLgZs+Mt2TYjfZUdalWiwOhs8OnpRjMwN8SL71AYhc3Eicvfb0IgddYy5JLz9PhojdO2zkpOgrl+ulvIMkU8pMV/qrDjEDAHFwSFq9j+iqf+vU+7eqjbqKxEYcEZlc8unzMwMborUyBXtiUNt9tu9y4LkTaAaw6M4dqoB66XPxE7UO/MNpJ8J1BusYkbPOzdXoG5T48Y9MZEluL+qJNhKHNMuFcnlaTF4o8hxCvTOplngg+jV7e57tVOvLyhyx2NIDOsgNfUF0ZOJu8GFf7oVHA4vF0jxmZFvQLyqfYvRVFmIeYUK+z3ityJgiGaQqKyEkInaGG+gJkshqnXeep5m
 QWwglTZL
 CXKxSFkQzBEU32cypG1PWsu7vKdQeVtnHfh92RDtfDs4UkKApfZprFTlleYGK5TfwHvzZcsBKIkAV0ghU0a/0bTKJwJl+cS+OPvXlcLAIXr5USx8v6PJuF4wSum46d1Dl6IbvbxNmyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot suspects this issue was fixed by commit:

commit 3a04334d6282d08fbdd6201e374db17d31927ba3
Author: Alan Huang <mmpgouride@gmail.com>
Date:   Fri Mar 7 16:58:27 2025 +0000

    bcachefs: Fix b->written overflow

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117f329a580000
start commit:   03d38806a902 Merge tag 'thermal-6.14-rc5' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=8de9cc84d5960254
dashboard link: https://syzkaller.appspot.com/bug?extid=6663075ddb9be85fa6e5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104d2864580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix b->written overflow

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

