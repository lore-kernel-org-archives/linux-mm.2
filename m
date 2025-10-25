Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1C6CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 13:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727408E0148; Sat, 25 Oct 2025 09:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8118E0135; Sat, 25 Oct 2025 09:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDA18E0148; Sat, 25 Oct 2025 09:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6CC8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:15:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C162449D29
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:15:04 +0000 (UTC)
X-FDA: 84036682128.06.39D8C7D
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B9A980017
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:15:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3Vs38aAkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3Vs38aAkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761398103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=lq56I845xq/Y12jBGmUt878nhCQiCseEayYM9Ay70+o=;
	b=RajL+CMWNGahiKHWqnUy8Z7GF5fca1+ti8ZeFdja3sZNTodrSrxLO/M4wTQNWQZEvUJ0IE
	j6FXplDMjFePoFlnvVk9e3jX9+vh9wkto7QhmcAPDj2HIs9YOs54RacqBZDMxZQ110MIUt
	3Vwzg4QdSOsmCS8s3g5axriK1ChpbI8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of 3Vs38aAkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3Vs38aAkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761398103; a=rsa-sha256;
	cv=none;
	b=bigRAilFNLP2SZfcfRhHOEOhxpIgw4/EF5KrvPGSh7Kw/mIEhCzUvfk1j6S3duwYruAGim
	1bm8mBW/Zl8WeyOdffa/dyflr0RcBf3BRC9GJK5OwWkB8NjjokEok9518cqYIXze+pTiaf
	9kJSGFUNbjY01YaTeWShsoW9znyvWIY=
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-430afaea1beso40082475ab.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761398102; x=1762002902;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lq56I845xq/Y12jBGmUt878nhCQiCseEayYM9Ay70+o=;
        b=JKNUPbziDB+o6LGdQooaFoxM8Trr0uykY72KpL0k3pT6l4j3eBrXIPkKkKzT4LQXp0
         b/rijc08pMtIiiU+XXeUqg2qsxIOzb3RgDz7pxBup0toofhb0jLpucexvvS7PkkTDoEu
         UsvYWxG3Yfyp/xJQzplzdossbOdAxRr/h8luk56xEpKWrlQ7jJxzG48gwecDqJCy+zf/
         moyhV8MD0o+NqadbDh+TopBZASzM3zp/Ml0Pt+FpzDX4zu+j5p8zriZIcbJje4Z6540R
         Nrp+AAfvnwQb/93csZAEPzcljanMBrBRihm/EXVFjgWnDWrKQtnk6qlHRwxopzrzSEJw
         xjoA==
X-Forwarded-Encrypted: i=1; AJvYcCVOdtFEcttIwbu4cjblVy1TPPXccArpEbv21smzPuxqjMaljefq8XoUq3Vm4KdN49WgiR5XESgKvg==@kvack.org
X-Gm-Message-State: AOJu0YzwcRw3UQ/NiKs2D6T8uIoHY+jS6Du+hhtdBnsHYSda/C5O890M
	mC4e8z8RIH9dxYGKKi3+hPLdKfgMgvvIvliwPpho8nmvSdkFQNcTkbMomoTp25YQbuAimISHfCg
	MnCQpU4nax6BYSab8orN+WCdpgKLHdg0fUER06bEPaY6GcyFTTi2G+YoXacs=
X-Google-Smtp-Source: AGHT+IGPmmlMHkkmVs0EnCnUS2h54DmorGwjGt/fcuBxxpTEk8HqQLrdrnwlTT6ISykfT2bn6sDe/n8A1CohiVo2Zdg4cjuIqWUd
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4405:20b0:430:c553:752a with SMTP id
 e9e14a558f8ab-430c55375b2mr361777925ab.30.1761398102193; Sat, 25 Oct 2025
 06:15:02 -0700 (PDT)
Date: Sat, 25 Oct 2025 06:15:02 -0700
In-Reply-To: <y6cshcj5anakdq2l3yq43febnftvttwjvoeounl6pincoayhfc@fjiiuk6ah4tt>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fccd56.a00a0220.1c5a1.0002.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
From: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	krishnagopi487@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B9A980017
X-Stat-Signature: xjnhoxxccycnoebmnhpg7ipszj89y77o
X-Rspam-User: 
X-HE-Tag: 1761398102-761175
X-HE-Meta: U2FsdGVkX18FaQF6Mh6QWZvgB9FMa/pQBS/xeQAvsd9XcZZVU1igxrTnk3vEtxul/KTB6KdSbpI7ukDZeY1linJcIC43wCNR/1v9+MFJKkFEwt06FmNoYcb9FuqEBRyi7OUP3wS9pVAr1nVsiKJ3uO42Ud/Fa/svPaWsy4dkbJKsgWh8wW1O0cANWvPdO4VEfHOLQGbjCuqZONrA6Bh8SpEo1S3AvONBYUecFr9IwY/LOGrND/kmMUEb9NGJxXBn5BWRXKFiJcxKVtsba8wflgSfpGrorYeRCGqJmRr+/mS2uszsu5COYu3TxSJQdtLSohaB5n/YLTOEHBbEtpbZ8xC1PzyoqhHvjczeaUf3F4ThaE/Aa1aZWxhCWSWj/G9kbQVN1EmgWlPbI4h6i49jZ1C2sqTlhcJWhRJiNKwCHf23ZBpehX1UhGXwP6t4PrvtjTrPbbo59WXL3pQkR7SVkhuWeTNKSjRtNtkMzF0gXvMQgOTkuGiR3hOxrfFttZ4+fQYWmgHZKrx61OKrfKF94UPMT7cZ+8h9B5yTR6j9nzoQJVPUwOM8MnkwWcyn02cGYdoJz/4lFe7Cirk1g5Nv1F2/I7l+WKg3Q7Q5bapU5avg1agDf785RHeLgsl0jBP7ZzQ3TD1h8sFSMTiwAiHvPiaZGEnkBeKKmy6hTRQoDgJdkvZPBNlE/ds0xM525zrw9s1WpBp8xbfi4MlsxQuUGQX26npzb1KcPXVZiFprGj4Z7CH+ijeC3LtO38KUGhFgvkYUIk3PQTt8iAHvnPo1dV9+nac5COecl+uSANkeClSrtkvJ1i7hoEw6jZpmX8uCfnyOD46JERaUEql9AfB2/8TxMlFo7ktQyLlgLvaixi7G5+q43jxtn/6htQGzgu/nqtLQQApI5l9rvK+XsBPRpv9YfmzaPnuT6ki4OSWq+HO8VLXS3MMGftLBuPrrKsFZj+A2/M8W5PS7OQDXg0E
 0Fn4wJcu
 nZ8mUKkM24byHx3Gb9SZk6NOglqXrah3eTkB3/9VWQTY1bPRGpObKTMEtnWS7kbqFXTb0mwKfl5oGouYxS0JcFYIy3rk2JyCMBE3IVsPQw7X/UKv/BZDrnJPWgl8mvZJRRr8Cd/7tIje2IIugCzmfvGYp/O4p09EluqLFPGT4umjRuZ1xVnNwJqmZ+Zcf0GDEexlQWDLASr5CDYZpaw8T9u0fk9mp6KrpJBhRcXGRMUIoSl4uc1pX2VIQpCjZGF5v4icET5pS/E4dEYfuOWtlEtEG4lqj3x8ObiDm0eQScnaCjRrLoFBfSJ0BGHWJmwz/LRz5wb5tx2VMMvi66RH3/E2pzdXapvWbYWWPkp8KujVpjFVWGnN8Pi2uGJPK2nEOy9Wr0I69prl9+Su7xGsNtTtOaZkFxjZikNqk8/nCqUMwcg8uHJhJabTZHoQ6516b1qPG/Y3tSlvNywuKMTDHrJOLqiXs6jjWRPuYb7CntE98lu4LBFJtaZ6PstwSIsscdM3eZPoMgTwI+Wou9dcSJOKppX6lyHFV/anDATIiTnC5g3hdhsi3FPWSsq1P9KNyhewaEPCO6jMaKN4Z3YJUTHbAgSfiyttSVhDnz0zCNuO+rcq/x8laP9eBviGTLBvKz0n1Pr+uqqUr/0Z8aBXmU678FHyLkYTYCEtaGyE/f6+Tj2QPNnGyoI79ypZdD/xX94kwxnSX4foCQBbebBiYLo8F+Su3GAXJv9cq2lp2U2s3s68k1oPb6uVv1tvgWlamTK4Mp3DVhpvj9gpFwqq/I3m88Ao1mazvlzqa/7MVPjl0Af0k5c5Ta6fYEbSuGo1eLfORFS/PfsnKFWJ2jMzL2vpUgbKT/GocWeHlTobti0gcIM89lGksKExRSURmDAsPQ2OUAn3SEe1qkJbjDOc8EpUnYQVB10DaY6Nrj35ewhvLRUTo+d+/pVCUFtJkLHODH255XPPncq0MJWWbfkc68W0FKJuq
 7vz01ZQi
 wnkDyMG4BfpAU2VsiGR84rQI0V9vBZdetb1W7sZBUSw60OSeaOf2rQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file drivers/usb/gadget/legacy/raw_gadget.c
checking file include/uapi/linux/usb/raw_gadget.h
patch: **** unexpected end of file in patch



Tested on:

commit:         72fb0170 Add linux-next specific files for 20251024
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16ea4be2580000


