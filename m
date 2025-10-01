Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD59CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 02:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C549D8E0006; Tue, 30 Sep 2025 22:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04FA8E0002; Tue, 30 Sep 2025 22:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B4C8E0006; Tue, 30 Sep 2025 22:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E92F8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 22:06:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D8BD11B04A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:06:05 +0000 (UTC)
X-FDA: 83947905090.27.82E50BF
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9DAB240007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:06:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3iozcaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3iozcaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759284363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=avuY/grDPjcSaG9OY3LwxI6lhVsDwF40vTYHq7elNVI=;
	b=RD0tnGKSv0BryJAcolNMB5ClA9yaThqPt3FdsbCzOAOS/hJfdU4gcQonyHNCzK0bQ5hnQK
	GpZhnGotPPpmBPIqdtCPbTTdI9suXKwRJLt0E/HMtlh1Zl2I1eWK2yu29lMVoSeeixWINy
	Fz2NrkikDEY+jwvhCNMlRsiJzGhXYNU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 3iozcaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.199 as permitted sender) smtp.mailfrom=3iozcaAkbAGMTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759284363; a=rsa-sha256;
	cv=none;
	b=zMK9wXWPZO1TYOmpvpZmcMWbL6PZiCRhxpazqk9enpXRX6M9XDarox2/vouwZKLi8qgVVM
	DTZ+81cdPdfd/ynGqtOib9uxTdO1Ch5RWyb4Ok5CdY87MrtpNHT0lbrAaj2TPldwWrl3/T
	IM78Cgd0OhTf7spehgz/D8vNR0FcpOQ=
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42d7ef0c632so25453555ab.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 19:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759284362; x=1759889162;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avuY/grDPjcSaG9OY3LwxI6lhVsDwF40vTYHq7elNVI=;
        b=UvWoQnHSAtPAFvu8OJXOpvttgsIj7t9vO9Bh0djX2ftVBwpOYvesBBEhkgUJCnXIVz
         9AROEGaY5l7Ar9X2eEGUgMmQgRriizX5NInwefwY8fwvBHkm1jLyVGJzcTS+nmBKhUXY
         wleyhceoc2c5jPHvueZ4HBL8qCm0+dH+LrgNJ/JhnZD5e7O1ef4mtJ5jj5bEqSLgAppZ
         8GS3M/5F9Wfj7r1vUSfLuG+E0RWoXpsIufdXxBDIswrIJqjZTsZl/r3K3gqku2/hN2IV
         T1kfYyIH3ee+moEi07AkiZtMptudzH4ssjBFCb2EMpt8uLPV6/JuEEOCiW8Tzdwj006b
         AhHg==
X-Forwarded-Encrypted: i=1; AJvYcCVyhrbdKx7733FV8dDZTBlkL94oQ7s+gCrOzw1eiTFX31necbFcwP+z1RZp1H5cTVX5Hg58xnInig==@kvack.org
X-Gm-Message-State: AOJu0Yw2Oky6HCr+5MS0ccd/ohUTiWF49/Lx+TMBkjW6T+PKZjxi0BM2
	CwcdN35598/PbDcGc1T/KXTkido7kta69UA+EplebRJkNrfrI2kjmttqQ0pZ9EpSJ4fBSpDbvkc
	19unslXhmxLUwPAu4YD6GJdE7io0+tsi1yVte2SsW65AB8qSTCH9Vur3+98I=
X-Google-Smtp-Source: AGHT+IE5CKKqHJWcmhrOUhOsjhSFX206AedHyCqQ4RFy75BmFKeNe+/UiRWxprils0Bq2ju02JqzlLFPv/dNsI++JwyCd3CwCaJz
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180b:b0:427:d82b:1f36 with SMTP id
 e9e14a558f8ab-42d81661fcemr31220135ab.32.1759284362677; Tue, 30 Sep 2025
 19:06:02 -0700 (PDT)
Date: Tue, 30 Sep 2025 19:06:02 -0700
In-Reply-To: <C7CD4DE5-1C8C-460D-BB9B-1A11C8E038C6@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dc8c8a.a00a0220.102ee.0052.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
From: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, kernel@pankajraghav.com, 
	linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mcgrof@kernel.org, nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9DAB240007
X-Stat-Signature: 8fn3oj6ry56roakpw4zj7tj6m8ggzj8g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759284363-176480
X-HE-Meta: U2FsdGVkX1+OUUu1ecr1PJCZ7IOjc43TuqsvKGA5+eIo6Br0MXeShF98EdWVll9ViuTzarFESXHdIwKv09Qx9Ee79agcP8j9Ubml93USaNLs74ZlKbIupUq8OSPDUECuqnrayzDTRc3NFvkikeT+cVXkfOKfIql12M1EuKcaZl/8by0dtJj5UV6kXa5Ne2HNB13aeLoA2DBHNCIu8x+vlrOAJDhtlfAIHlIaGS0zpvMbSWrKu7uMIc4dxmEod3FxFgEz7Gw5j3nzbE+m5QG8vYTvm5tr3zoJJfxbmYAioJMMzHSYlWeuEgLycc2iwXViZMklb1LGiiCjpThQGSztbmdFrqPMnO/OhkXfPHKtc4lNtoYRCixpR5nOe7zOdQHWE8qiYq0eQi3srg3CCL62kNa5koQN3xQW+b5rMFYqogWf4iw/sAy94dn0W5zKLMTaq2xhvvb6neps3Mc0pVRemqNfyps/tkrY8qjhbhHGYna7jf/F7OUeGZxuodw1Hyu71sO2EFmeARP1YrQ9zOgY7i/zehJHK7AAb4PDQO1+7gqJKPdT6nW7vSG/wfVj1K7HNAN6/Rk2I03XD6T9TE2/ZdXMeiPUcpourVkgyzYZv9keBY9yHAnK0GKXL/CARF8MUPuftYtc5Jb9JJGG04l/AsID2kJSv6FFpBYxlFJIGckfRvWUFMttYTAERmQ1sTAJ2gqZPFJ1th/iMxUWzwJZQcB/sDfABG3wA4x7BHEtpXTeBrfr0icMOk6rWXd+qR8t62FqInoNkCh7Djj8cZhUjaU7t+tfOBHexI0OW2sO549UDfn9Q2uwENlLOC1f6AMTikTBjY+f9sU5gssjrDurG2eZ9TvmOEIEQs4gfrPkkVa8mZzCtotaznbGtykdWe72+ku+Bu+RG+bx6r8+O9S2sNkNVMh0y+Q5aWpltG71VNDtESLUa4TCO7+nz0Z+xpU5pIbTRyDFzzvQvx6WiHj
 kYVANs3H
 1zPOYa5zQhGYDCuagaieh2Hfi7JQPaL6icSUnbjZcVGPkjX63GSAh4Urg8A9bE3Ate8WG9q97sFD6LRadFfi07Czs4UB6M7d79MnmAU31gLw7PRoEQd+zcuYkgJnPEcQNiqMWefGWAouBUlU3EJ5df8q1t0o3kGW327kJ86MPCrl16R++etw/GHYKEkyzDEiVLZMdsNNZ0pCrn6OQF5L6ZDaDLyvqz7U5hVVy05wjiU07IRFQd0eHvsO266DR5NYxmSNKmUyZUp4iYwP9pVcMu8JmJFBFiaA7QZFGG2snew8lmZAIqMxhFvM6zXYy8obnk4nFKqbmviMNcJW1pLe6j1KNyy3dH9AfL0RNa7FdQQpPHmun7uFysNbFHyRss5cRu8+C0oGesFzHW4lxZBe4yzDWzO6U6oWmwnPMtgYaHJxqp3N4a5EGWZhPK7aUYPz0aD9yOnRjpe+YiyVNwnY4MSu8qjMQjnqN0BPAVgd9ePPmnm29cr372T5URrwKUhajXDXYZ7pB58z9PpHZ+inVGTJ50fS7zbP77Ti6k3kCeIympoABoXmDmYCZWXdpgM9YHWf4Ti10fUyFkq42SHvLDEgm2RRt/6NYe1vV9Mq1NYxbHrmCuPQ1jNcNMoqV53By1NhHwjLrLnWTLeWX3iV1PojATdhAJAR5zFYQkWo4HbbzmTka7QqAQrsC9G9yK1wjBWanvFCtUrvuFOOJd5S299rGbJ+AL07+gjPQxRrMCOt2JETDRXbVTOZMjclD2tsPnuRzFJJ6vBxHvABIRyXQ/2L6tcBY3Im44SnRFO66z+RR2Fsm8X3cECFRLNBqfODJVRVWUaAAMD7YwbpP/X9ySj3Bp5QAAUh3nr8MB6t0YJAS9e1hcheiRWjk3wBUqymqShAdt2KfINiY+y6pl55O7m0Q9A0TfrlAQ0CNqSs/PpNkeXr3+KGMIhYQPUCemxFn/3o3F03Op0q7+lCaFb74mEOGyePw
 VdTw4ygR
 S11+TGJTrxyVxPyrzIGc1ar1E54ff2WNWn7KzAI+ZxG5qO1JsEfTS1ga0kQEEt2iRL6uu6oKZV20vm7xWtvxX66EI2vgmJ7JNlHBCZ2L+hdQTh74HEM+c06KRWocXIjGDpjp26iEW5HQeAQOdxztWWyk4smrUgGKjL1LC/JOuL3BjlTVmLouDHV3cG6nFozygAqww9l/2mg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git@github.com:x-y-z/linux-dev.git/fix_split_page_min_order-for-kernelci: failed to run ["git" "fetch" "--force" "c604b0b58bbe3045b4698c8a85066936c1abd842" "fix_split_page_min_order-for-kernelci"]: exit status 128
Host key verification failed.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.



Tested on:

commit:         [unknown 
git tree:       git@github.com:x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2ae34a0711ff2f1
dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
compiler:       
userspace arch: arm64

Note: no patches were applied.

