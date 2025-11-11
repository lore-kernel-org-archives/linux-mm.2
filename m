Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75672CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823098E0007; Tue, 11 Nov 2025 11:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D35D8E0002; Tue, 11 Nov 2025 11:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2348E0007; Tue, 11 Nov 2025 11:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53BD58E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:14:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBBD259F6B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:14:06 +0000 (UTC)
X-FDA: 84098822892.11.773AC1A
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E7CF80010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:14:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3zGATaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=3zGATaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762877645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=rsIzj5zeRN34MODne/Dex4pJnbVaec6z/SJRkF/VqmY=;
	b=2o/s6YzBld+9oviAq4OFB1NlmNYqVDiZ3pHVd+BCfZb95O5aAURpyy0LQ32rZF4w8Ncd3B
	LUTlykTwWWqvSQSpgTwv3cFnAz6fL8WCAddkJqlpB7/cW6tB+qdhATxEzeXrot46rCS6h1
	aLGbykV1iMQVzQCRQBQPSnekGcOD4w0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762877645; a=rsa-sha256;
	cv=none;
	b=w1GDDaRKf5r0bOz12rRpdaIGEE0JXMpoichn7bxnpRYvY/fiysPIwPZ13dKr8oNmEq4JmA
	PWO/2buS3oJYaECJ3aon0gYQuB7/e2G5MwIjlJe52Nx9yTD69x6bGfj/2z2fRU12zvlrIC
	yzysnKY49Emta8snSKCruNEGito/Png=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3zGATaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=3zGATaQkbACsZfgRHSSLYHWWPK.NVVNSLbZLYJVUaLUa.JVT@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-948610ae935so384184139f.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762877644; x=1763482444;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rsIzj5zeRN34MODne/Dex4pJnbVaec6z/SJRkF/VqmY=;
        b=gkgp4rRIe27lVwnSKQAZDsCmzxfsJt9I6bhiwirKtcoSllX7H0xl52YUScxJjN93Hz
         +BKtyXn9tEiQHFExlrsA2Si7wdrRghhG1DqUeKDOkQsl1oUomNtvn8m+JxWNY1Lcs2B3
         OEr0jifrTWaLYZequ+D/GMn0+wg/YxY8OHfOV9n/kqx9+Cd6BTsmLiBa6bfAXRUd3KVU
         b/fuQDVtCtxRAOqkSrurEtDrfWCEKoqsL5tg1/mV650nnhrTkU+Gp4SAAfjUT6mC5Uqp
         QCbZKypBPWWjP0ivSsuZLQuLEqTX/U6twfIvdVLVuYEaNuSguiAMkn1YepXXlpkb3VlA
         jkmA==
X-Forwarded-Encrypted: i=1; AJvYcCW+beThP1VGy+kdFfqxrxeJCveyYhSFWji3ChhuWOE13Zw8HTRj8mXDaMGYiDsZGRt/X8/8RDci7Q==@kvack.org
X-Gm-Message-State: AOJu0YxVYWQhkCNO1R/vMKyRKWVTLTTPl3s7OJ6wS/TshYK08rw4jUtk
	vLAa54bg3O9efPDHCX6PpyRxrNGfONxVGqc366LNc8q41n+NhkxC9Qhqw9UVSqBIt6oxNTYkloa
	BWV3ztDkDEZMcsLXsbT7Mmd6osA5Wxk2dmYY0RXciBjUhAElQ7vCp6UIOUFo=
X-Google-Smtp-Source: AGHT+IGhd1YIu4TmAb300ER5ywQ/phsKtardGYlr/w81752isCeFiUXjr5Li77UIL+5T2x/Jd6onzK9n8xsWrbfW3lALSN73fnOL
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4914:b0:433:767e:8f47 with SMTP id
 e9e14a558f8ab-433767ec96fmr150345295ab.29.1762877644204; Tue, 11 Nov 2025
 08:14:04 -0800 (PST)
Date: Tue, 11 Nov 2025 08:14:04 -0800
In-Reply-To: <20251111-gaspipeline-getippt-9b19b62f89d2@brauner>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691360cc.a70a0220.22f260.013e.GAE@google.com>
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
From: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bpf@vger.kernel.org, brauner@kernel.org, 
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, 
	jsavitz@redhat.com, juri.lelli@redhat.com, kartikey406@gmail.com, 
	kees@kernel.org, liam.howlett@oracle.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, mjguzik@gmail.com, 
	oleg@redhat.com, paul@paul-moore.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vincent.guittot@linaro.org, 
	viro@zeniv.linux.org.uk, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E7CF80010
X-Stat-Signature: 9d6h3oka3zmpqps5zax7ezzdbhcupmou
X-Rspam-User: 
X-HE-Tag: 1762877645-263598
X-HE-Meta: U2FsdGVkX19yKs5Dr8Z23YN6lM8yY5BTxG3Uy8AgC9db2JGwJd3TMm81AMI0I61hs2kmqfPjMFQCNKqFxK4EifWHfUjXn974wXu+Hu1F0A3+7WN1nGrbsz8z+gJKHUBfwKnUg815tVmfr3xMtFqgSCZ/DR1xelYYndfrnxohEEvFwTFmAd+E5OpfDRqSExYw+4OB2Qn3Rd489g1dZqNJm1Rlzck7rmgwkBLyAqvin32X7D3x4RUdLbYm0b3Ao8mmh7uRPXw7WmAGcmDwKjlQCZx7zJWjLLDe+crorILHK8RlPhJ0IeLonKwvSvtNy0QXo4vtKkoYBsprgCXOLEr7S1Nk/bAFvnMH4Dr8VVUvok+sVcDUswRwD4jB4tzvrj0z3EiVM0a5pNPG5OdxIkOJJSNxkTnF3As+It/DGxyepVa4n2+6lO8UWEB6ZvRNIzSP92m0YUfsZqVzVlGyUIOPll3aayPoxHDtlx4XgDGoloDNO1QOcav3fX+soIkyex4NSXvTMxRSW6Y7MIGI00Pm/7It24a9oylHNq3rDDpXKffjwLyeQHubvc32iPbRa+d4OvsWSy/gBUDavwCQQ+7ZpOpsSuWsUD6iG7eJD4L7Wfw7s5TpLWKN0aSNXDuCP/7uE3zCmhqXh58S8ENUz/sxVsEGFz3cJXqWP+VPbu0DMCZSXZvE67xd+pQtXHEdVwlIgNZICE7Ri9MNmSSh1x7deFhaWAhXDaySnXWsjnJC+PdITghvq78nk/2DYSbWvM2yGuap8TQDXKTp11oJvSbfeJWIfizGoVBrUFoFvTAfOwnJLXjEgBE2IGEpWYnxu5J38fYHkm5twFFTgL5EV9KvZWjvE8/PgMb7DBxbq79THswd+l9LkdUCTcTlt8y4d7kL+uxe74HwI/AIsTmNU78LtXR3blHScOj2NuvzVrhrTa7QxceC5E9SdCwR66QuVOUUmmIGV9gE67VNVVkWJTq
 DbPF8Ikw
 9gnadU5Wv5kPT65TYcNiFJAkCRRP7tsaOV2I/v9UOZEAYyaA+Bf3pa4HA8J6WHxg0LEa3efgrce6krEfrcuBMw9OSWs2X58W8oFemS1GymsmNJxrO/mriJwuOL4lVnqvTVNVqH2VMZRMSbsnhu7Hd1jH5anLmcVBZ8lov/mJ0JqW4hca/aAa9sOidC8jkolFLP+pG7M7QdOloY8zGuckvanB45vgnlj8EdFqETxmjkjR4Du+00m2TMTMLrI0wWSAEZFnlUX7htpC8TmraGx/veYXskCCndJrZXsbJFnUyveHBXZWO6ytiq1ECcD10B1YhxOQ0hVezCkIzaDGsLv2gbzvee4qlNJbrYtvEuzaBpBaG5uw+NuRNf5HFnH4koo69gYNcbvoo/vUHdppMGhyQ67Um68BKoyGEzpOEHSB0k1LEQVDQPl/QIgxHJZkxhOuu1OMIApix6kjw35cwLyJaFfqfAXHFzMrByrbjZf7pCFeQhes7RsYT2l5t1l8yCW/j16nXXJno1RCtjj0qU7Xy1LjfR+QSvrJ5P3Aru8rQVhjRcEZDqFRaE7+lDTXNxnolEj2Raw5MxWUgbp6JMc8TKH8+kQJehTWKiIWQK82g9Xl2qUV8mlm4E6KXriGRPG7xqqWRuWr4pRFHif2YGqcH66pyqmH5qOYO6JnUlAvWPsl0MQGPs7W4R3Xim8/rcuD1b0a7p9L8iRas3szdYAgxg90GEXRrXBCRaH+DQh5fTq2Zo1AutISVSNig8srVNZMp8q66QnnyGMhGDdQS/pm4FmALOEQN7wofbV3T1SxgVJeRwBwrGRxVQUXxhxhgxyVlCjvC7mtaC7LTKMw5mu8M8wMeC2dTM3kkBvFHXQXf4ThQrdsMwXDn3kM5zKgh2emMxAEFg6OdsBKH9q1aQ3fjteS1tVy1fjFs+8YGCLpbIzlOVrW9xNpwCM/t6KpuB0OSxtj8bWPZ9pDa7cxRECSqU9bALYU5
 himEfiPc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com
Tested-by: syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com

Tested on:

commit:         d2bab7f2 nsproxy: fix free_nsproxy() and simplify crea..
git tree:       https://github.com/brauner/linux.git namespace-6.19
console output: https://syzkaller.appspot.com/x/log.txt?x=123a8658580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59952e73920025e4
dashboard link: https://syzkaller.appspot.com/bug?extid=0b2e79f91ff6579bfa5b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

