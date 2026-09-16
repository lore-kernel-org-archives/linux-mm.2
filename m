Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67740C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784276B0092; Wed, 16 Sep 2026 15:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7351C6B0093; Wed, 16 Sep 2026 15:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6246B6B0095; Wed, 16 Sep 2026 15:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 414A56B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:24:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B83F71C00B9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:24:08 +0000 (UTC)
X-FDA: 85220600976.16.500DA26
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1022040008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:24:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 31uyqagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=31uyqagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789586647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=gGav+E6NmhUVSh9XUjVdcV/Auw85chnTv3eOmsCDzNk=;
	b=S4Bp5pgCzwDeAuVGaWX7D3sPk0m93IIKi01s6CBH8Y8Uafnwl2lA85sgWASqz95fxnf6Ep
	pY/GIGBE/8GUCxT+2z8LiyHW3qoH8Cx/Ad38Rh1z5tZ8SODzod/fmoNeNFl9zt1GFIeIiU
	xqC6c5iyJVGdt7aKUDmK8gIvjqoHBW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789586647;
	b=J0veSC3cSHq17iUbSHiuNRQDctUlPU9Uwbo04RaXRTPtFRUsQix4WLxkuc4QE/OXI+jyQw
	6L7yBA5k7IiYENMO/K1AIGqvChLmMkvaOBAxtAjxmERhgN2mvrRPnZU3cz8lkhsOzr71Ta
	XNcsDxfqvV9ygHf7w5jMWUkqup0Ils0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 31uyqagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=31uyqagkbALcpvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a41f46d629so152668b6e.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789586646; x=1790191446;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gGav+E6NmhUVSh9XUjVdcV/Auw85chnTv3eOmsCDzNk=;
        b=X8mRsEX+9rw9H5BCPEgEUfOgtFn3MZdK9v75t8MBBYq0diRptuNDbWowccIvVRJ9SG
         aDw0i8ave+UKUI4AHblPoJpaSX1ATAwSjSFAUaI/TZRiyLrqUhkxAkMuGhwV6CSFLn2R
         jnWuwcyh1fDxEysu2SvJMR0o4ylxlTMkbV1n4/0wEG/2n5/A8DOgfGTG1B5sErFBB0pN
         Sb1I8ojJ26sBwZZ4aEizctH+KsqSlXptNq7wYDJg3onX2oJVQI1xj/hkWx410R66lz0N
         uLoqAeFph2anmWjvUFlaJuBvAdlSsuBpoffq3COsnYV/fssTKIDQkMhutL2ddQxLQXRj
         nB+w==
X-Forwarded-Encrypted: i=1; AKwUvBzxGB4OL1fLEfrdJg7vPaL+AG3fjjGF6PqR9RfptR76e+ZY6hIflx1MBF7my2vb2ShlvszStCLEBw==@kvack.org
X-Gm-Message-State: AFuF++knboO6ug2y+jAz1HurQbx9fzuOFRlC2yIExGE0PT/9r96d1VNJ
	btfJHVzooGpDhlGgRD1DD/qQYIvfTiBud1UczTBzpZ5EQ3udxqFXpJwPnixPl7uCiei6pfw+Gl9
	4HojSNga6q1XAuxyDGxdlW0YMQSrEdV5QeHtcpMgxmHypbKb5z/2hhj2cmgU=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a24:b0:4c3:7695:d30 with SMTP id
 5614622812f47-4ca4a1dc406mr4599160b6e.14.1789586646123; Wed, 16 Sep 2026
 12:24:06 -0700 (PDT)
Date: Wed, 16 Sep 2026 12:24:06 -0700
In-Reply-To: <aqrZMReaQPG0M9oV@gremlin>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaaecd6.4e05fbd6.392abc.0003.GAE@google.com>
Subject: Re: [syzbot] [kvm?] BUG: sleeping function called from invalid
 context in kvm_mmu_notifier_invalidate_range_start
From: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bigeasy@linutronix.de, dwmw2@infradead.org, 
	dwmw@amazon.co.uk, kvm@vger.kernel.org, liam.howlett@oracle.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, ljs@kernel.org, lkp@intel.com, 
	llvm@lists.linux.dev, lorenzo.stoakes@oracle.com, me@brighamcampbell.com, 
	mhocko@suse.com, nogikh@google.com, oe-kbuild-all@lists.linux.dev, 
	pbonzini@redhat.com, rientjes@google.com, rppt@kernel.org, seanjc@google.com, 
	shaikhkamal2012@gmail.com, shakeel.butt@linux.dev, skhan@linuxfoundation.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: en3omuei7rdqnpih87koq9s1rfb7p3ii
X-Rspamd-Queue-Id: 1022040008
X-HE-Tag: 1789586646-129370
X-HE-Meta: U2FsdGVkX1/4TimiNVQdoHwfiCX78R2eWK7ijiFNF9/XBewTeYktQO4AiNQ9NSo7H1QWqMKWK6T4pS1V4E+UAeyt2CxKIrss08PSz8AkZxAoxCGWgmZPVS4gX16Vuq5l1/uNjkUR0aLoPHLNS4qa/EznKz17aGagm0xAlPe/qMbOPX/o0NSIk8Hw6SX6GEc1RCZZeuAXnbEzgqT78Xy6ugyATynNNMdJZ1PNUpHo6nQih8QDXNhUQYStXWndkSEvLctI9Le2bc4WcmOR4Uo/LRmXB/WmecwDP6Nq6mrVKKrjuIZSfBPicR34G8PWSRfeDdQkV07kiML59ITtKPaaeYanXYi/48KVXHz2JX0tr9phtffsrmofMK4bQzzu2EsgqezWc+cQwNw8HFqN7Oyv+o0rQyLHtj9c45XchzG6rvg+6MnwPQXk0ajfL1krHjMoDDUqynMYcooiMkTgwY/pifsZrxRCJ8lLw8MH8HH5HDhwIOSjcrF/ZHakcv92H37wbGLfET6AFMn0Q9Ykb/UuP/yB/0NsglyPwjgxGrmISZEIgKmMNVa6gtLKHiigFTeEB8yZSQ2JrlyULM54l4IHjwkBHe48PHoKJtBgl3RJXH42pDfec1eL01f9W4Hnxo2ZV1en+xd0/5lRTCS/o6ThSuYZtlTi1YAxU+AEXqh5ceXO8854xgYzZKOualq2Dmmf8QL0vKcm1DFQxO9sKLIP0Lzulh7rQ+pimfGQVuD2RqHYy0pEDdh4m6Jm/UIkEs6r+8O/xkaOwePDXi4StTaFQl2e/zLEOWTtmYpwokcSXaRgG/odya4PxjQJ58jt274SDJ6G7DwYQtjqIwmS63nneQgpnGlQPgrhk5r7io56mghwcrkAb/PsclKSEVcoYl2OpbQ606M6Pi44xtiWFc6UGW8/A4SQCBX/fyMYm1HKHEvmibRQP/e11uJA6siq+duSs8s0HHAYVFXlRnwRvfz
 SXZ/+sB8
 wyn5atSkiV6e5viNHkV9LXLGFYts6S1OxlEqg3fQrJ2jixY8d+PKNSjiS3PouZpxjbna0lRt6EeWQU2EiJ1KWodaPHqQ8RedxqW9QSpWNySW0cyXictiUO69vIvSwFgaoFTs6++sVpT660+IvjV1WAzZVLFJI2Sw44opzTZweRu4n4HiPdGd2Z9FWJ147N8hubFm5nClPFucjcvn48/1YepRgYAsm2wGPJty6myjHcTUWykeJZey2aTettfcZ/EFlYMpGPc2r2OS9ONYmIm5MjqmEjDwVQhaf4K4ptwnKT49nRI0BtTyKewK/qHC4hAiZPLY2Y0JU+yz96dIsDnBaZtMUmSkr/Gzs1Dpkp58EbG3C++TWkfKM/DBoRT0CtRdWsLxhoZTfHdMhe7fCqJN88ZUceRo6X5eB2U7rOz/kayx/mNlYS7Qvg4udWsO6C7TQ6w7xlYRFErQg//IjSOkaDAVetkv/F+6JqTl3QrDXMZj+IOPzfASaDdSRzW/yjKAYla2GOCdZm2cn727mVVmWCK7mOHONv9kvfT/RUlMhjE6Y5Od0bVbO9BBfqDBCFBsdL3Ez5o7lsrR5wxzIVGkMP3RTT8fQUromnh15aimaskuEGncMrt59L7mTWuMyBUeNdZNQgwyGe4g3M7fOQLcHZEVSP1/LNF6bRUGSm4Wdw4tblZnOB/IJzHzTlZ40GdLAA8y9pBlFgm4vNBVk+RXFcSFM+3ukaL/f97x+48CSstktvPaZLWRFMN1PcKCqWRtj6lQbt5Gu0ZrGVT1rgYZjNDUBSQUh3MandY6zAycHtivLjvH0x+PB/iaKyAnct7YGyg6zS+9vd3BUT9+S1jnMWQ96aF4DG3CxFRGTCi46JPi/u4EXNpcrP11MIpLGQQ4sJLDx894w5Rsto0wA3afzu4dqr3RjNGb7j1+0GyL3ox7oPuc4ig51pTOWT8lHQGz2YuKMpHLxUSdAMv/I2MaSLsy/Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
error: corrupt patch at line 7



Tested on:

commit:         9b87fdc9 Merge tag 'sched_ext-for-7.3-rc3-fixes' of gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15a16bf9580000


