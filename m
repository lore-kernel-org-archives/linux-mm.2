Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468DBC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEA86B00A2; Tue,  1 Sep 2026 03:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA09C6B00A3; Tue,  1 Sep 2026 03:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5AA6B00A4; Tue,  1 Sep 2026 03:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B09B56B00A2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:55:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AF231C08EE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:55:06 +0000 (UTC)
X-FDA: 85164432612.07.FAAB982
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8943218000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:55:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 314SWagkbAJYIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=314SWagkbAJYIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249304;
	b=OLbx5fEkfIfqgvaCHO8SYM3r4CPMYX3apzHOgBV9CosfQpb+JxCdvcLrTFYmwMPFl7+q12
	Me2kcuI0pngV0MH7TTHoxYGPhVkKFka8JJGN6E836+SMGhaUrNq9hi5qJSRwiMTHO4HWde
	2b/30JW7hA4Cv8EXL81RSQT6hpnJ04w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 314SWagkbAJYIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=314SWagkbAJYIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=4CmDFTRfa8f29ltAwrzLVpQX8Q8Svkmjy42jwgV2mHk=;
	b=p1UzWb4f4rP4LeS19SZuIvNz4XZteljQSrqysN7RQwBTl7wyI9ndnAV6S2Fm7vvJgYaFA6
	YYI+Xq/O/187B/YeuwuuQ/oHiohjnaqYkiuPpBA998fGhlV8SC7nvFfFMDgfJjNsrUjaLJ
	KlpgtBaUnyucTzuXp82iqdQxB1VM3E4=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7ec6685adabso917455a34.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 00:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788249303; x=1788854103;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4CmDFTRfa8f29ltAwrzLVpQX8Q8Svkmjy42jwgV2mHk=;
        b=WJSoG7ryKtVxnmhTymfwaI1jjZTq2QQE8G+BhaUh9z+oOZ2voZhmD0mkYJghg+3qbH
         xs0dlA5pLgt0sxSiV5gA565W+x2Fj9y8n8EYKYeO54QBZ6+GTqDewe0p6pBV2U9sqMtA
         3KaDuahSL4kJLPe20S48ypCfA4Q5K+0sLcSryeIGjsxh1MGoehWPOzPKUKf/B22PtnLS
         OKbuxAWsgoUVp5Y7n+axVpfHnuODzf1Sw2KxClz0zqw8foF9QcO0YLxFSYpwW5tKnGpv
         H+7K9dFMaoEWtCZNC5V+1IqW2sH7ODH7QH0tySRXdoA0P33/pfli5tVUXwx7mPa9OuPY
         aZDQ==
X-Forwarded-Encrypted: i=1; AHgh+RraP7LUZNOK+7LWMaQOpduBXpJmTG7Med6WFfTLI5Uq+cCHRSRTz3PGzqfbqKjcVG8GpZ1/2B2ltw==@kvack.org
X-Gm-Message-State: AFuF++ltdSD2hQRM3Zl2hUeT8KDxLThSNP+tHHiDMxcsW9LrTgwH+G4v
	auTXt9lKfnLlnsK6hHxnTLKgm9QSrGLFS3DjxRHl7I3IoNjH1VBCIHhxZT4aPpP4chUamATdeMg
	CGKPiP7/Eo6/cGVepDtZSHdDdAHHWY91xCfG0Jw/STAnphh2hF9xuyM0OgHk=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2204:b0:6b1:5865:a95a with SMTP id
 006d021491bc7-6b1c66e0e4amr28953455eaf.15.1788249303616; Tue, 01 Sep 2026
 00:55:03 -0700 (PDT)
Date: Tue, 01 Sep 2026 00:55:03 -0700
In-Reply-To: <20260901014242.417011-1-junjie.cao@intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9684d7.2d75a5c4.15ddf4.0003.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
From: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bigeasy@linutronix.de, davem@davemloft.net, 
	david@kernel.org, edumazet@google.com, harry.yoo@oracle.com, horms@kernel.org, 
	jannh@google.com, jhs@mojatatu.com, jiri@resnulli.us, jpoimboe@kernel.org, 
	junjie.cao@intel.com, kuba@kernel.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pabeni@redhat.com, peterz@infradead.org, pfalcato@suse.de, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vinicius.gomes@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 8iyrbhcdwhp4dyjiqpapcje7kjej7z1a
X-Rspamd-Queue-Id: 8943218000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788249304-352132
X-HE-Meta: U2FsdGVkX192X7W0b4Sr3N1sadwVPf3Ay4MpZoQzOFSQOu6t5ftrx6Rv9rJ0g1i6l2ZXR1O5LdXMTr1MVVsT3LnAOX49vDzWzq6t1tUQUUoZpTmg1GgCWChEX2Zm6KfxFotONhWFJm+IRARZf/mPck3s+siny1arzxeZv7GE18UgFaOlMU2w7GGGQ0cuCOz1cZ3fzWBnj8/ZEQUO1Uz2X527biPzkb5wFwHb3GFbqCGKQACCrEd9gOKurdlsjqsCQIi6/9/+QGaMUp1O3s/qsJF7rP5V95FwcVwOT+WKjb725nbpF+vJ6jTz3VOsT7SIk01kV8sRdXtDshsPfxgFYOaybXbdohwujlg4B3iM5BsfrE/2f5FMDTA10li5OBMiWIA0NIPJMnhbKamCaUF4KAgsdoOV7NHryxCQ/KwLPxPK4K9FCg//kOMZ4Q5AEl7FfC/vllPvR5/cVek9oWEk6h0rOJaXZEy+nJS6ZPwpUpgroJ+c+KSUApFMa/cQgUVbjseOyt1Foah3iOmcU1R54UMraDok+eYCzpL8DIF0uWVwyhUKKGK4249lsjLuq5ZH57WH2rJPeHcCqZCjvwK+x2/4J4imWAz0qAYDjex+kI9sC6VqYYVj7C3AIV4GuIXae9Ve3j8jl46aoeF/uSZWbVivm86LKrXDczcTznmJlwWkkLik23UShXyseYvw2T/nD0HQkKSQ+TjkkbTnBCDhLobFF1Kp5wcfSAkEpA2h3FUgvQLxS44hlExEh/2dzNbO4g+Ax3p3IzYC1aoo6bABcvRB2OlDgOy5r/AKZQ7z/Gk0CoWQhYapUDjbhCu6Y9KVrcU/rT29b0BOc9PJFsUnC3FHPRVHwCfmcznwTb7ju8cPDf/3dM4CbSA82zKkblAYJ44dm46k6LWHckF1IJGwuJ9+0m7dACNmozUyXqQvSrPcWcnLZ6hByj2J0CfJ8VuPCNDfy4p/jIxb8p4t5kw
 /nzd+Vhd
 aR/vs+DLyt1pnCLqG3Ojkl5HaL9NH4g/wRmW17e2ONsRC6QKjlXQdMzxKzByGTy+V/bWbX0GCdMu8A9XEL13kTx/YZyEtUGC3pCP6450jL0oOlkN6jreJd8fjOoJyUXYg+tUo6kjqYh5sSWFiY74/8sRiUKHz5MwLmkTMm3sSF3JhWL3ZzCBAZ5W3U1HL0z2/nDrsi9/Zl/3gWI3LtvTAQ3EEcp1DDTVMYBws0dHMjLT3LAqU2gfY4rm+zFET9EvJNH6vS/fNAVQI+Zu+VuvmGa9YvJH7fVbmCoIrjgEfsui8mRy9Hz5S0WIGRjkGS1RYDeQ2WJlGq7yo4PQgPYlstmagD3Yls5zlVaCnlQ6S6vUY0lk4jc4isWCDLJnLtBMJEdwHbNjxy1P0X+7ahNCM0YOi2ww7FOfIw8EW4J1blTf44tqy1pRQAozUHkqv5qvHTyuWNDGlfpQ8lvgt+hhnL2MIlS/ObLG7uwd+C2H2OK4tNMC2n5pJUwRpW+tNh5iwi/wv6KIk8/6cz2ta9Le6/fIZeF5Ep2zFVItvpe4iAny87IwyXCQlvjpzB7b+s1nGv6fv0hRKWCba2dMVTnoYHM837YcixSxaJllAAts4+Z87S0r4CPyFf7C/uVDRWCM2ghUuV1x6o/itL+5xi7O71MzEpbKOh1q1XWbO96XIKlo32UuWhwactRKq8TkNzwKkC2mgLN7+3wtMRHkGYwzd8AQsJT7fUu+rLkTGMKX0Ue+nS01YJljzwGNe7G1UDpUGMHLp1AgW3qyppw8euDSwbemj6YDflla9k8g6TeMeqxwxGO/Sic1OtFvXY0Nkvx7HA632WfO5ya9cXM6eiJ+WB5OO3G42vVW23s4WIogAC586bRs6fyiASO5h+ORTh6rS8hHNBBQoycGMjKqpUisXaa2KUog/PtJa40fFmY9Zt4reYSvK0saP3LPdx6Kziz+SjMfEmYdnCOO50+Rk1iUOVH5Zn6h9
 y4CnOZc+
 /jnwHlZqE/Lr0OLbu7ny57ibHIV5RmT9L/XkirEv6gz1JIGkyVi+pfwOpJemxJtsSY8yQicLRoigzaUVPoZuc6gCe+sasZyE8o5ELnKQ9N80Ni5HM2x10xO8LfIDOSlAAGNxShWu1IWq3pjQqD4eXXIP1DtniMphKhfRTXTPFLPBZILIMoBcONLtK7lRls3o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com
Tested-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com

Tested on:

commit:         abdf623d Merge tag 'wq-for-7.3-rc1-fixes' of git://git..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=15b33b79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9cc692b98d9b4fdb
dashboard link: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=100b3379580000

Note: testing is done by a robot and is best-effort only.

