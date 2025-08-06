Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF16C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB62A8E0008; Wed,  6 Aug 2025 11:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D908E0003; Wed,  6 Aug 2025 11:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA4E8E0008; Wed,  6 Aug 2025 11:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BED218E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:38:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29D541606C4
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:38:05 +0000 (UTC)
X-FDA: 83746738530.08.DC51C07
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B9BB12000E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:38:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 32naTaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=32naTaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754494683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ZU8SzOXyIUfFyq4Qxk0Wl925G+LRHWU5sBfbKF6330Q=;
	b=wdUYdLANwpEQJsnP6hjcX0IuIMxwyTTsQ4mxRhKPGES3nS1uH1Hxspq/b3VL8iqqqoMsC6
	ZRn51nw12HDY4dHbVIYa/3CHhey81kOADov3Ct/3OHWqy8sU7sft2LPORZmgBSwgAHiMPT
	ITYRQFw4zVBtYipCQ2Iub36hUb+b4Ic=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 32naTaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=32naTaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754494683; a=rsa-sha256;
	cv=none;
	b=vS67uJmvSDkqRXkFuAt25AaUyP3ORb8GhjWt9G2j7T4DrFKslbkB8586gduvoxM71OHvc0
	E/OHcrjmmbqpvyol/aV56Vw5jcVoxaI46wF9bBkd5bE1YG2viUR8Xh2Z68+tVcyvigP0pg
	b/XqnIQC4sWKHnNJuek+zv0Oz+4p7CE=
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-881a214c747so70576739f.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754494682; x=1755099482;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZU8SzOXyIUfFyq4Qxk0Wl925G+LRHWU5sBfbKF6330Q=;
        b=ZgV2mJk2QftNjwdY3Jq4LhNvYd3el4NU0YkWUY0740og836Nb1apZ1OuDcMyntAlNm
         Y1RVJGv03ZGxyK7aR38Cn56ewYWBytcCop4uDMbO6zcr7yaBralKpy5hKgBDKGzxYsc+
         4QNAJ0ozSY2tkKb5aJG5gtHVk/JsRcEPpGDTHaP0cDyw9B1HJvEhwq/+CVqVS8jq36UN
         U9bved5tRSrmBd7LCGpg9vhLeUDHsANbrXgnaHgui37S/EcxNjVaTNg5ZcBlyuGoFQB7
         vADMHbc9ZxMr9kbXTmAKFieI46ceahWLK/FiSrr9nViA3M4W823lUqNKD9URZ0zquALL
         4kMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXFn98CcYAHUUn8GodTDJm1kiBe2eNLcdys60x5vsNmF8pJGF/NDeLh+j7OFiY9yF7U80t0U2o6Q==@kvack.org
X-Gm-Message-State: AOJu0YyZ6EjyacBtLoNHDYfC/IQxqmn2gdC756JVz5em5xZS5MsPu1Di
	OXHYUkyW1We0fSQinMln5E4S7+oUgKXwBnyKEzmyRje/ZOyVjorHFKu6TT/Z+d5sk6SQ8KUaQ/r
	21lP8NRI8FBWvVnEbieOClFEHEQzACYq3m07Qx3CR22IZrAp9AvdhIODsjtg=
X-Google-Smtp-Source: AGHT+IHiiG/0LQTZx2F0nl0xTNKo/GBFT65Yn+8eQJyBD8YfIyE+qvAvb8al/uJdUXR++j2wENWZfhvbyNYfvh+KzO0P0gN1F8W3
MIME-Version: 1.0
X-Received: by 2002:a6b:fc0f:0:b0:876:a8dc:96cc with SMTP id
 ca18e2360f4ac-8819f087f95mr544535539f.6.1754494682510; Wed, 06 Aug 2025
 08:38:02 -0700 (PDT)
Date: Wed, 06 Aug 2025 08:38:02 -0700
In-Reply-To: <20250806111922.669-1-dev.jain@arm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689376da.050a0220.7f033.0040.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in follow_page_pte
From: syzbot <syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, dev.jain@arm.com, 
	jgg@ziepe.ca, jhubbard@nvidia.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, peterx@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B9BB12000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 7ukcr3pk5pwoj1sarfsya3sqi64j1tjw
X-HE-Tag: 1754494683-396958
X-HE-Meta: U2FsdGVkX1/gY3Sq/6VA+TwU0YcqmcSnWpKwgYM0/M1NTMqar+ZNbZwNNkWcz0i6EYLAZVC+hxkhQxgJTwouNQz40AE00lC1yefxTPHaa4AHbP7Da8n5GeNEeQt1KZcuxqGAARe4w9wL+wcjF/gMKCfUYbjGJwji1TTNqo8YmQkSkhaF1IxmOKrJiXI+fSV6SGhign82QkDSyPOpD9hSLeuBlzaO9X7Xz+oOPGd8nB+m0ktbnU7+7PbF5jCLDCNnaHIjCJ2LY9h8TXPlHh8JNQ2mSioQBYBTivdUZsyNcUB9AMMP3YObl0zd0LTNB0CLTcAsHDdnM7IHH7HkSTTQJD8WpGYg6hhozh3g0ZC1rOs3WWfGfXF7UdJ/Ns4NhS8MpWwjybC2RxQIA9PyL1Apx1fC/rTd6dJBpDb95bHB8VLmu+r6dcf0YrtNp09tAIt6PefmsR6czjUVOTvHEsdqzh5lN3thz9cjYBfxMpJ60v9S9fStNUXys54EeizvsoG412QSCna66S8+f1TyKeHiDBK9LkL/39sJqVqfwWrq9tpIJGPfd7/4HBefy630duJiEyPwMC95ahjyixVchzRaOuH/t4B8mszV7GwBy0eke/ARYGvQGjJgLcykkAVaO0+t+HIBXH6Bfekojcy8GAR48WO4B1x8S5TSWGf+w3UYd0eUp7D61cMKDFNkFVG7QLBf2qWXk4BzYOix+c+jdSI9QV7xm02Gy7KVm2mQ0Ut37VsTHNO+bEJGQv7RNl6V9jlBGq+VNvUqBrZ1EYobI94iw01Q6StYuTUMvYlJrw8CofjUWy7Q5CAy9RBMEEs9N85Jg6U3xd1BeEjVg5R6XohGdQIOJfVOpj3uvMJJUl216AV4QC3Q/wItBXrRBS1EDQOtwTGHsWGOerp7pi1BlvyUnFGB+pWzUh39C4xHUnvNVmAxBJsJsGPiqe/Y6WRy2bGex6lku62VuX9XNHLeyH2
 /FeNsErH
 rTT56RQxq3Q63GHNYcguGQDIm8130ZwcR7Vv6f+tav1betTAPNm7XbTDZ7cy+LtYkeE6yI4zJn8tmD3E2GAFpUQr/ptZv6LZJBsKqTNVrY8XbRaziyzVrTbmWJdoo1yzyJ07X49U0oxoabawvLU6XC0Dr3E/+UR7TYSkYleFfaRL6W4PidyxcBvbelry7vD7ndUIQJ64qlKJaisQGQNlXinRKOmYUWfzzsH5Kk3JdnJcflmobcvjVtkV+cWOFPLY9QxLPqRyd98PzhTJumjUmyzSI1GAkgOvEo8XmPfi4OMF8qxMVZ/NJYM7hB1A6uwF7/swVfJAGsAQ1gozlEBDPaS/LrKAgIANcwxUaTFpEpvGVbU17WtvmRF/45T790tAl8Z3YdkrHr06k96mslkjjSQB05kpb9x9Kssuba4GWkzcHHekCnQ85Rjc+on13rGQmJU+K2/orbfcUVqaffG44SRKlKHjQtgAJADs2o/1c/SJk1HJeqFjt7/cDUdg3s6Fyy595YpAi7Aknwbt1KKkBgeIS+2STswCvuZeIB+t3QX+7AE7fC6JKRH/wwxmtcDXKL83ZLLzt3gmSptm4jJdeo/j2WcFEVkZdpOJWpcXau8ImdXS6xQzJ0Jtyx6KNmQ3xNtGX1m2rys7dBQ866/NkI06zBDMNvA4EKKn1WuCBDdlVxv5DL1DA7kz6TMMxJeZVEcRufkzdPcK+tUEE2HtrQZpUOrF93o3oUYoZQY84QNlnkgz8t6D5x0gGMyVVF5bt4z74l0+Rr3Z1mjqgEJA/UJ/rg7JphAbrTvYNlVpd+JL+JI+BSfo+dtTeIxnv5lVYLIGZY22UGZAVAoLJCtZAuBj8g/JGFzA2BZnXMv6uioo8Drag8scRrpLLbxi5VkY3qVKSqrSmFiIm0lZKTtWAIZbabMV3RacmN0W86UECiH2G0q1rCr10LBMIXs3KFWjo8zwCMC4oKYihu9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Tested-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com

Tested on:

commit:         47905800 Merge tag 'ata-6.17-rc1-fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=125da2f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75e522434dc68cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=57bcc752f0df8bb1365c
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17c36042580000

Note: testing is done by a robot and is best-effort only.

