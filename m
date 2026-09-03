Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FFEC624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904806B00E9; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866A26B00E7; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707A16B00E8; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC886B00E4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:35:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5DC68019E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:35:04 +0000 (UTC)
X-FDA: 85171639728.28.4667515
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2DC3FA0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:35:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3JiOZagkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3JiOZagkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420903;
	b=rHkMbpJ4QyEp0ZHFmQ1PuI8+5CCNGTw6D7cJtYlxXtclN+1zydtH6FPlvCBxkjPoaD0MeY
	ogFlsQh/5yd9pERX3i+g73FGuwX5AtngPUBBVaH1XTIQbHRNzRNo9AH0Ck9EbeunCTROIN
	JvM8Hvo/xosLIb8p6faXoNhsy8Zdrj4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3JiOZagkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3JiOZagkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=NLoKDNgFkZljVKf80yy0HoTFlUo9qExOXyKkyCU30a4=;
	b=5X44x9dqs4kwAYW9Ti/qSI5aeGIIe5ulFs3PGbNBUxoKgPpS54TWmhApYMkqoZHwjUNdsn
	6j8Z6N/BIXjzJdyz2vo2qTaghKjK+zKXpgLctyPSz23X0Y+J54OsKYqtTJIoSh+9Dk+owE
	Iu3Edvu0BAHe6NKs9oH+Tn11pE+ufaY=
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9ee20bde0so2421048a34.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 00:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788420902; x=1789025702;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NLoKDNgFkZljVKf80yy0HoTFlUo9qExOXyKkyCU30a4=;
        b=Vyoph5AS6OqxRQ3/37lcTivKF7lc0K7mt1+MmJJyxFKcgSPPeEIFET9tARYAhSKKvK
         uSSFe0kX6F8UIgN3kI97DL7+ABmap1k3/tVUrUKzsAJSSq+asOETJlW8FBBBSKjLoZh0
         KMmktBai3mSN3wrzV/uI6hJRFVgNDcPho3GKzusBKgp5CCNXNJDpYuoBJ1rQsEB74RlX
         oyu9C4Gb6NZaGXv8FmYpQ+rypMPnn1BLLaLdA4NV/W0xEwYlyawK4OCrYbfCwYzfm6Zr
         R3zvCJfaAbRI8y9rqf3+U/fcULd3fg1fsAmJ2NDyW9XvOpnBqvv5Dv6qYO/KughdTBAZ
         Hs6w==
X-Forwarded-Encrypted: i=1; AKwUvByYkpQgSXiYe1M/40P19D4KUQSQ6ePzVk9j2f3+RPad0gcaniEjRH8fh1tSN00shufTfcjy19atIQ==@kvack.org
X-Gm-Message-State: AFuF++ngboiXA1aMtQ5ay8FfyckILo7BKJkU4MgCsKzic7iVfOOsWUm3
	3xNnMVJrr+G/Q9eELbij2J7FItySAwEvL3X2o0t/SylMR8uKDQisFRIlH5man7/+QGrK8unhE7G
	r5qeInYlAClv01I4WILFgNddx+e6kiuVEEiMgAeFUVz19E1mhT8WsDADn78k=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:212:b0:6b1:7798:a80e with SMTP id
 006d021491bc7-6b47ecca7f2mr8356531eaf.6.1788420902197; Thu, 03 Sep 2026
 00:35:02 -0700 (PDT)
Date: Thu, 03 Sep 2026 00:35:02 -0700
In-Reply-To: <20260902185451.5ba1a829a15bb2799d121bd1@linux-foundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a992326.e7659fcc.146146.0005.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in vma_set_pgoff
From: syzbot <syzbot+f12658786a4153df5113@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, kunwu.chan@gmail.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lixinhai.lxh@gmail.com, ljs@kernel.org, pfalcato@suse.de, 
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DC3FA0007
X-Stat-Signature: o7tk6agqq9xeyuuntdebbzht5oawxrz8
X-HE-Tag: 1788420903-108222
X-HE-Meta: U2FsdGVkX18VkgD0vRfqA4N0jPRichzIgxHqnPSAvaYawjDLg+zk3Dk+IxIqHBq7gH7e16ZQ5Cwr+7ZWyEFjfgLMWPPiVVD/fBsEGsbs65TVrNwvj7CQMBN2BcFyu8/+9RASO3aR4VM120bOkv5A/SrAHJsGmtp7buM1v0QBrVE7meBEQe9IPRbYCQMN5a09qD0kc9uUbk6qUnYh1Qan+PQTng01nU7F/Gln9UV7qV1TOScJnG9ZLfNYOjqSAKG8cgTnFbTWzc5f4E1VwvlTPepmjux8addzmSr0wvmuNkVjGAOWGwDUwtGBLOYAx6Mk9J/A5E2LID6WXkqniL0O+InsRILQXRRBLH6lwG8s7ShPCl3q5Ng3hk9psPrWok+nZEgVOCfrhHCXDlcv8/CmcT0AY8GXTiXdSnrh6EqSJze2OjgeW9+62uuk9z9ZWtvoH3pcSrxMWVFpFtx52VmpPifzFmz4mVJtPij+lPEFuZPDsoAu0azZJUBUGQRaxWjen2rsZA1EzvGuEBVOp5JJRJ+DNB7fmNNJDnn3dFAz0/tTs6q0pUSnRqKicq4DoWEgzM52D3DWPB5ClaXR0LpCk6q1WApvFRPgIWPqv03VWUScWVCSvWBvEk1qmvLbMcTtnPqXgudI1HPe8VonTbCQObD43xw8a7XtTidpjGYK8otA6n/iG14BbjfIjmHZdAAD+Sf4vw50HpUcWX+qe5N20KdnYlOs8D1Z1C/rNRMBCxOJDi5IABLqFdN/AFbrMc7tqtlUDSVherA8A2tbdQSGdYCg06AkGE1h1B03pPytLiP3MVBWLgKdhsdNg4fcucihD5pstFvqBn9mJvInGKqfYCu7EK1RNBeNIkPD6oh/KWtTDEb2NYq2yPy9JBAqh1xFMdzlZdfFS+JCKb8gPnFRNbCJLBrgjEWZYoMAjwPMRK2kMgxkkA/GPrcxwOeoxL6KjHEGjrkkfOjYgtcSv9Z
 uCIMsHKF
 xYt0aqbrhqjvhNLfILPNb3FJcsF6RK4T7jBdoG/j5ltSsqAhJyOw7kc0rP1RPArzfKjOEj8j784GYCKyb4DcWOvBni3HniCQIoW4pBcS+uykrj1HtQUip34Qm8qfMzOFY+l5bGlEKRoD4Tcqv2LuRFlxzawHO8qGjQcM1MkgL+AJapScrzeB++9kUumEELOc6LzJx+ILvmNyCaSoYJAqtyvaWeJcK17qDboLo8KOS+twCNpslFsTgXBlHe5S+hDn+7FEiMabO1tXAcwvU8ZSwYAjiB+Ve0kv6vmRq2Ev449XruZPM3gnQo88N+A+LgJWSUlIGK0wbduwIw94fHahjwRgDYROvRgSndBH5n7pKyUWPhJn9O8y830Q6cudZ559Stqx5m+nz0xthaOJVy+fmx4pKXQquWItZTLSb+omv2yPVWdsvBc4tjO2hLO+NuXE/0bJWEzRbRNXMblvSeG5SICaTphyW98ZtWMQOSZpOg+jQcMonAcTabTUypAlwaAamr83zW/EVFtxyd2DM/ehvZxXr7nmVGjwHV8HUpDEhKJ5CVD/fF1B+7L5l7E2XeJXe8UTiQq/GcNJKdJp5Di7SXsD3TX/5a2Nz4SxWOmLoaffwt4LxgUSO4FkQCHQk47+R/Qx126LOMH+fWhjMzVA9rPcHzK0PKmxFDcYM0s7Wor78IG1RjeATvKU1uhRUoFka888QDuCbuaXAbt6ItkRvOwswbAIT+XHdHgqPE/1rx30rE9yJyCEnM8s7V9BCPC1+n9STWwYzB9NXic0gcHHV2fQTy5r8inJn/tdUUsuA06MOFeWAka5YvZzysuRvQxm+gQsGpFl9mGnlwUFAbSo7wbJL4JfS9N67bwubhfk+fZqaMeACR2wD/UgVub+hYe0g3hIoZ4bP1r4Ogh6JJhkaN8IWd/6f8j7Xf3d5Q1476nOHt4yqRqN2mXbGYkVJjj0VJdA9KRAVaAG2zyjXJ2+41zn4FYzX
 o67+CojJ
 kuh5Hk1G97MpGkV3UlHqQUi/9mh9TZNKitrkeZEv9MfLANOs6VAOsd/R8ykV/AbWA1QDXwfaEH+w51b2e7bdh570Uub56aIB5BmiUZybPBee9nArZM+ryiMIhfn06R9F6G6+GsmY9KYqlwL+6FGc7ljOfiZmRnpOL9SOp9m9WaeZYLZvs18wk8AFWvy5BPmFipF/0/A8D+1GdGm1OsTNSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Tested-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com

Tested on:

commit:         940de590 Merge tag 'hardening-v7.3-rc2' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=147d1f79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=f12658786a4153df5113
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: i386
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16b190f9580000

Note: testing is done by a robot and is best-effort only.

