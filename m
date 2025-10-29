Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5D5CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 00:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E71A8E019E; Tue, 28 Oct 2025 20:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEB68E0015; Tue, 28 Oct 2025 20:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D46F8E019E; Tue, 28 Oct 2025 20:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5548E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:25:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA8101A063D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:25:11 +0000 (UTC)
X-FDA: 84049257222.03.358BA76
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6B19A0012
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:25:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 35F4BaQkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=35F4BaQkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761697510; a=rsa-sha256;
	cv=none;
	b=Sl3+Cil6654xQuDOIfVwiVU2sMlJj8iPmUObM9yrjzWJw3b2NTWfjAC5pQh64U5RKEp7y0
	CJNSZFl9IQGwgspdq7x0swF4jDBPk74QkWomjKsz3DYWamRLnwlsKmhNFwjnTA47R+btrw
	g4qxWafeTeS9GRYgtk3MuiJG737U/xg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 35F4BaQkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=35F4BaQkbAPUpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761697510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	b=DY4YGGK2YxRwgHB1FSIcCMAe9F2dW0+U4wvQ9lWgD++H5A0XC6p1KkUwP+cNqgAVKEtJEo
	pSGL6iOTHwOwiJdQmlSncCS4CItV5iHX5L7Q0BZy2poLtxg8AUVDJNir+X9BWqyRPst2Xy
	0KoUaauVGIZXaYTgUKQMOw7SO2/c2X4=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43210ca8e1dso18032225ab.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761697509; x=1762302309;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=GS3Jwx4u23Tl9cryrQ2b46BKNysgFNyyYUzL/YvTRkTjYPmKQldg9agC6feenJ3GPr
         cI4A9ohNn0HojuEBfxq5IpsYMrD+UeeQS6Pr4pO3sKMZ0NCPzOxetxSUtn+jyY9JsYSP
         uOfDrWHiUr2RuvoH9nezflp1848XNte1pCH7O5CqBu4QbK1oi5ZhdiiWGvVbXoEA9WRr
         ruHsHNzPyF8+PKAUHBnII6cBVbMQ3QwreeEy4i413AzomcVWUjGifYoF1+IotmsWVXgs
         mwuR0QfDo3KBuoNBHxpjajIRWXZ1CYrnEYd6T0gGtQtG9HTuR/VLn+TnO2nhbE+9K9Bl
         q/NQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1t6NLDKcVe17TFrmcRhZuE/ai/amPVtJjQR3LPpnSLQyVFI0xhxQP0waFSP165NNokPhmOnp3cg==@kvack.org
X-Gm-Message-State: AOJu0Yx01Np6LR/M6vT7HOPMpqiDX8uVbMBoC4r5t1fAW9akONkWUdVe
	7RguHTOWwx/LqsQvijGoAldJ3q+D991UTve4ePa83f8D31FLKUbio2j48SOU/8ZrKbJnLCI2a0V
	qCQTpMnOJNVdqFvyz+mKanFK0Xqb6iTMoUqATIVoL1uyrqpWC/y7u1inUaBs=
X-Google-Smtp-Source: AGHT+IHRPJ5vQoHGCAChMRTb+GIwk2dkZrqG6byeJVWlhSwoPis1XmTYkNmxVcxDmVOk4U7RHrNmmt0Y0/QA/uPrHF/tucDVAqRX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:9:b0:42e:d74:7252 with SMTP id
 e9e14a558f8ab-432f906642amr16004065ab.31.1761697508978; Tue, 28 Oct 2025
 17:25:08 -0700 (PDT)
Date: Tue, 28 Oct 2025 17:25:08 -0700
In-Reply-To: <aQFeMG8WEvrWaNf0@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69015ee4.050a0220.3344a1.03f9.GAE@google.com>
Subject: Re: Re: [syzbot ci] Re: Eliminate Dying Memory Cgroup
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: harry.yoo@oracle.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, david@redhat.com, 
	hannes@cmpxchg.org, harry.yoo@oracle.com, hughd@google.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, songmuchun@bytedance.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, weixugc@google.com, 
	yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E6B19A0012
X-Stat-Signature: fen53uoouj7zk6gdmkmb1csmk3m6t3zk
X-HE-Tag: 1761697509-941195
X-HE-Meta: U2FsdGVkX1+q/z4++zscSYxjg3H/DmjNHYgxKbP3m/OMiIphWZhEJBypbiCRpbK/C3d8b+lg9hcFQWqxxoypyJmo1Q4/rKgqhFx3n9r0iSpdbVRxqdbmWW04zg6+hCXRnCpogaTKlWBANxLmAw8tMcXWPCmjuHHOmmwP25y9+uSZLYJbpQnXUiDZRcvSS3Z3GmLKje23umKsHNJAnD9R+rd96dagrBnMMhRxs+2kUOI8Ccj5Xor9VzUi/xtSFJimDCLW7LBNLd9X+ftIHUNBULalxNY80pS3Cnn24VScJbrCHAHHt3lQ31xel16rdl429oRKVuPnK6W/wryZia1tqaF2d8ac0i51Fka6lwk8Gk9NGTOqu5Go3P9b9BymYEhKwdizmJUk2qxmKaGzKz3jZAWrfrvFUDyzh8f4hLc/UfhxgzILlbHB0FL4VpBipMh0MmhQdJoHhMJpNzS8gbhi+FR5tBKzncuhprEBK7YKisa5bC734WAwr8lY/p+Gir/oAkBhCMTHxyOP5tbNlVfbeW3mPbWaWe3qv0pabbeQkOHKcFB6zhclwbdDiJli6KrMf8nhU5eX+LceQT0msUwcUyun9M1TUxCwDX3L0QnWR2uVXkXPJ3t1xhmbPcS1e9Tk7s5rjVV7mp5GvD3SCNOXkkFH0iN78RgSruIhYdezl6s+Yr/agBOvTHpEC28HhyRfaeYkhAlaKP6/enYN3qms166SJQhDx6NUcGXRXpg3KZEO2LYHo79lLBUNm/PgJK0FawFBVIqjP5oVemacyCiaqtj9dT6cZWbKwewLbxLhpQqC4eZVJGUufBt2IsKotOt+8/zpTci7SIholegUnGmMmF155aM9DsN+rRh1/L+jvNdZTw4rxgkGwPJGHV18Zu52dXPKWBlLQ+zeqTp0cjwIsqiQTCZMHhCgJWQLW6HeUKWMS25RnnbZL9CAWvtmISrrCOZyAMPjUe7QG7ffbIE
 U62GcB+c
 zrJJdhaa2xvt6pzfxfluiM6Z5dQZuVoDVPLi398ErP9va6BPv/LRngECud2zNhzKhBKteupmYsHWtTn9w0pGCoW7hfrZZktZC0eZ3s0KobIXJ64iSjxQK2yXsx6JUv4nHeg7IGrLWw01JTMitOo3+IwvFGw5003cwWo7+aoDrWHCpDWAqDv5zr6FLhb+Jg3Zj5fHZyxuTdHRfczWw2beM+eeYNs+lFJsvJSBRyGduK5tqJpn9gvq20BsZZh+eZQSPG4gtHfTB+8afLRo4kkubb08hkGQ4XVjHYHQSXFj49T/lru/9peU/kgYmwku9u6uhr8L4yES5Nx/zk0cIOQCXP9Y+wL1Lg8srMt4zPtbdQfTLKiFmFeqAAu9WATIdyjdAI7btSXMyqBBckIPsWJ+GuwJ8fcue/+S3GQKIbj1U+Nzx6WqDTBjnxtVsuNlXNx9FUVUdQYR4Md4Kjx5pL4NPC/ITZzjyZLg2CrBCnhsrRmRYefM6OgpFbDbsVghq6vmA6d3BeBFhw9IankigDyP6C7YIezEA+sUupf04q2FmPntb9L/3l2N9n2bKErhBZnizQQCx9HQDzEA/gbJbBbLIpznlVQYHio32ZD9Rn3bbTRj9swS3lqZ6GFKG8K0NN8r95eqyLhnykfBaYxtYH3IxWVjPGi4kfJZEOf2plzKUx260CvhZryz15F5NScNq8JX4vq7DqE4hjk8Pf+Dn8rdoNd8UZzQQ5pNxnJPSeDFAtJMMcUquLL8rFg/zlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Unknown command


