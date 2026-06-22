Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CACCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 20:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E55B6B008A; Mon, 22 Jun 2026 16:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2953C6B008C; Mon, 22 Jun 2026 16:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABCF6B0092; Mon, 22 Jun 2026 16:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFFE16B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:25:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65D001A02D4
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:25:02 +0000 (UTC)
X-FDA: 84908677644.01.EF85831
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F3B440004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:25:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3G5o5agkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3G5o5agkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782159900;
	b=gPq+PgpLb4gIBsYRcaoP+7Ep/5qhMyYccnNYAUhij3S8Dp+pxigKCxjfS9w4oF9BcSCkMF
	s8BaOtfZK13d0A+7gF1wh5HDrT0Q9CpQtnjOfsKsMoRjE9S2Jkl2Aqpt07Q+2iXdAlFEP6
	2RK+VgIsMWWkwruvbQyIvco9jaTrV64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782159900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=G96X2qL2qjjy6tCavIwKInPWUO3/eFR1t4NdfcLJhng=;
	b=NLnMKj4I7yp6j92+LW0WOpuMIOZ2xFcX8On8/7BN9hiFKVSPscC/hNDssFXE8GOfR1teb1
	cRgFVNBBuhZsRcnk0wBy4eJ28cInKtPidF6RQS4UagfRg6i999/gQ01NU+aeauo9ZRx3eB
	VwHDiMgaFINauJGPKm11PBVxJE+fd+E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3G5o5agkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3G5o5agkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e74781faaaso9048896a34.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782159899; x=1782764699;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G96X2qL2qjjy6tCavIwKInPWUO3/eFR1t4NdfcLJhng=;
        b=XnBVatuMQJrpKkW+GtFAoW2CV0yi8gmqubA/vvWefQ/LE7gR3d1cFGLSpHVbdpCJ1K
         JCH6u2f4WoEfsHGsNIFkpa0sgfRVpwM25n8SFECf9AcdC481j8wlCpS72rpERn8U8a1C
         yOnNhigbtJUS/TCFvsnOE6dMmOPToYTq4XnorfkQXFHCx3uR3IS1QM1u3B1xFvTVx92P
         49RHtzpIRzFPnY1ltlhpmhfHSPOP4QZuG6GRjaXlfnXhnm7puMutCc/pv8zwoj4Zx/n/
         e0s68Pfrk14/ey+7FLCc0e13zNAqcgqS+xnSCMVmUxHkc7UsNATXEv/M/k+RtIYAYQCL
         g0tA==
X-Forwarded-Encrypted: i=1; AFNElJ+f4EisJXeXHcTVX1DnKANyU7djB97fLdPqVL1SfSWqRN+DRWgURMkAJu+JJdns1MWnzngI0zTE6g==@kvack.org
X-Gm-Message-State: AOJu0YyeJAKTbt6Mxg5lE9M7m2NlG7wAabnG6eCEbSvGTh3khPUJ0nsM
	rnKuAojeNP2WSnCXRjnvJOV0/hUVxU6YTAOWQ5UZCBEd2P62YpbrNU+Zy54H3P613Ic3nED7MYW
	qRQ7Xbi3/G7LYfITE7MvGqIPFdv+z0T0NQdiNL7kWMMLETi5OHgTuJ+0ImLA=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b0a:b0:489:93ff:9ea0 with SMTP id
 5614622812f47-489940ef971mr12301066b6e.2.1782159899616; Mon, 22 Jun 2026
 13:24:59 -0700 (PDT)
Date: Mon, 22 Jun 2026 13:24:59 -0700
In-Reply-To: <88AEEEF8-B9D9-48C8-9069-00E8528BB619@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a399a1b.b71f6517.a55ba.0002.GAE@google.com>
Subject: [syzbot ci] Re: mm: page_ext: add count limit to page_ext_iter_next
 to prevent invalid PFN access
From: syzbot ci <syzbot+ci6c9b06d29f32fca1@syzkaller.appspotmail.com>
To: ziy@nvidia.com, akpm@linux-foundation.org, david@kernel.org, 
	hannes@cmpxchg.org, jackmanb@google.com, kernel@oss.qualcomm.com, 
	ketan.kishore@oss.qualcomm.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	luizcap@redhat.com, mhocko@suse.com, rppt@kernel.org, stable@vger.kernel.org, 
	surenb@google.com, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F3B440004
X-Stat-Signature: o9t185k4tijjihdjex4pi34ngs3665ge
X-HE-Tag: 1782159900-476737
X-HE-Meta: U2FsdGVkX19MUZ7jbly9ZgdY+onPOd4DRDlsEFwsZVKNwqHglwV/pWzW/iz+H6zQakmLxVlEoqdj730jSIp36uWrDB/n4OBsX5lqjDCq09nu+g1r7BKa7i6mNFLbBl+raQN9rYmd5ZiHCiodnhrzsqFHMW9N4v591YCWpFYQp/Yjxejm3gPMfHLO2HD4eTZGNE7BmUZ6M3TYwUuNExjPYNByBf8Owuiar9fXUoitSwK9s7CxViWv3ILXZOUjxqSWZ4cm2SOTT0ViOOdSK7tDYB7hiqVtH0Dzg+6HQJLDF5WG+POAj0ihZWHQiAZ2o8UMCFloQHG9y7S+Hq1b2GWhqCIsUl6gTJVIWlIC8hHSSDmMlkiIryy9sGE8ZutrWxT30aod0PEJJ2ZVV7vZp4svZK2tn+kFvDuoK8hfeBho3FB6D2tO8FQnf2COqbDGk9ihtZCDtZqYJxOkyoftqsSUQ06cuy27AkOc2TBlXfp7Q0axJ0KgEhzbUzPjQ3DSxSW+A4H7dDhayk3FP7yyNZfEQQCG2zyZwNnZTE5ZglD5ZyUd0F3eD2HXdt+5wbI/J9KDy4GLWl5zIlaN5bhE0FsMd9WNex40ygJ0ZWo2VcC7cSoeAa9Eh4wfRNq3EBkbTW9nhCWfEDW3R6wA3EwlYoKcza4Wx9M0+bX7GAp78F+IjhMfVuZkRjq7sIku7c2IB6n5oJ9/cthEs3NwikpdXI0WQRIK7lLmFjRkOs6qxmGLn9z4dez5v4xMH8qjy9sbLytCjkdeV5J9hwjEZk0vfynHCvrF9ejKb0KSv9fDQnNuYajAHw/tKPCbE2b6Nn9RKZwFECAvhT5/qU68BIXPVaaLBWu3JyZi5295ule8/VY/yiZzYKU0rTq6Ycp4bujIqLiz+W+bMtbezg9Si0lFnQ7CauZRolxXBVCmjDh6o6NYyNbXGegonEd23V+EmDQjV/kTIFee5yYCQU4nr1pog5W
 6fBqH/Is
 4WqjYTfwEfjewYW/2RSNCtd+NmEnimvKJDIw0WQNoKWDmpjS6deY76QFcRAHRG8fEed2tiIY6ceKKsrPFbbo4Q03VQypgiTWf9xZvuNfnH/tYJBBftKqBs1q3i2NVGOucc/xScJkjlvR5GZ9VhRxtoTX9TIdglInxoILt7/pFS1zWlGCEKu5UDWvhibrL0PTZBaCqNkuKVGIamA1YM99NK7JeKF3roTMxCVHLWQ6N9TPS/98EGk/NfsewD0x1Mx9X40/SprAQU2wPpd2/44qqibbQARAlH1QedF/UI79ZnyUydGlG5AMYMkTCNOuTNOd0y90YEG4Mrynf6gz3Zklyf0b1Iy5alb2WzJQUQWFbQdSBwI5Tmgqe3+Yzc3EsmXmpWQm6cIhaWalPckU0e4N/lCLFECFCfvjY/TP9TZJLvD+gt5v2z8bb0kgECqlIvQ3UyFLz4r4teFLDqL7F06yO2QIPgYRPHzJ+eHyszMCKq473dbDaP/PnDTCqNxRo6SDdm5ig8X9UvXYyev1EdYeYa6PZ1955v8blgUL5TrJHNh6G11jjHmJvnswUFJwktvFrFf9luAGvpk5az7zu/Gg69rJGZ1HiCJTUVkFg59VIYM8gacKu83BZUOLWf6qEJ32WY3LqfCIjpnsRf5DZo5epgbKLYoOJ9mdeoFSMWdKNFI4fMc5tQYVuek7LVqVhn57+CUJtH/idsys/PsRf1sWRhYHzQZIX49v31uG4tmNdpQLvXGZJAgNjdVJYdp0QpnOLNlo4remRq5qmI8lrSVar3nLCEpneuqlBVqFVE5anKUPJqcuCTkbvQ2rjpgIeEDtERuZqfXrTmEpfip0A+r7f7sKoL8xkglW1qFlCdyU5mTHxlGiVmh/y+2QwWpfSGJeBFeTDCErwDGHCunVBsYJONOQtIk79m4JKQVulu75lKDzn2NBomxqsgiHzoSfB+qoxi+id4vYE5OTx9t45VSZ8ll9xGTpD
 c+byI0MX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the suggested fix patch on top of the following series:

[v2] mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access
https://lore.kernel.org/all/20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcomm.com

Patch: https://ci.syzbot.org/jobs/c1b2fffb-acae-4bd1-b00c-622d37f59120/patch
Testing results:
* [build 0] Build Patched: passed
* [build 0] Boot test: Patched: passed

Full report is available here:
https://ci.syzbot.org/session/e38844bc-7d59-4cf9-ac06-b987a2745fb3

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

