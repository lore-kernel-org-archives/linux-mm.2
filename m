Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7213FAD40B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 05:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0130E6B0005; Thu, 23 Apr 2026 01:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05A86B008A; Thu, 23 Apr 2026 01:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BB36B008C; Thu, 23 Apr 2026 01:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEFE96B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:05:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7735C8B5EF
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:05:23 +0000 (UTC)
X-FDA: 84688632126.08.280187B
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf10.hostedemail.com (Postfix) with ESMTP id C851EC000E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:05:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3kKjpaQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3kKjpaQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776920721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=fHKEKHdPjoZhYVJRZoCAKKckDq3mCm+7VXF61UEPMbE=;
	b=ocIjN/ZEwf47oqQtepi5NATdeLZT/DscIF8JiUSZwA7bA2kvptf1TDK3fyJsVshaAVmawP
	XUPnZKPfq1ixkp6rndIlhzcJyWJzKnXru8vlL5RXVyMlnPNylBZSimcLWS3DGgwOX6wgYE
	Ngy1UBUMHm1FnQg4V7zG6aUVyJMsIoA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3kKjpaQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3kKjpaQkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776920721; a=rsa-sha256;
	cv=none;
	b=ynmnoOm6D5w830emLleuxfo9OEZnJY0XcDutpKFx1Hj+AIvKwCn3SDq7Wy2S0kFpyNmrh8
	phVqtx7MYuyo+JlhH7cOHizbaJyPYMpAZ6GZHa1Uho1TyJOTaB+wdbyFPHdoOxNzJ/Y1ax
	XddpeQFR7I1j+OFvEBL7symOgPq58MA=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6946e873672so1431013eaf.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776920721; x=1777525521;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHKEKHdPjoZhYVJRZoCAKKckDq3mCm+7VXF61UEPMbE=;
        b=Gqz5Fc+hvjiQLu+EznSio1hKdw1eM//MX9t/TIEYc5MQBFlA8AZqhcAHBh3BwZ3y+I
         RnHQjuEmg0w4Ck61TlfN3Oiy2POLMJx02M9LYBBj2hDdNkT2nuT8Q2OGHaGethB41itU
         jw2Tz8bTSBzzIzYUZ3uffoL11xdmQOnzS8JXnPqY7wZwVILBUogjzalOp8bb22YkJrYe
         L7y7W1Y3LEVt0+cUIGiRbI+C7tQ0CE/aPyAlHpy4EaGwmB38jjV7WKYcTZzXY0SYtzP1
         JIsvB7tpbhWRnS+JfLwyFVa1/Vs6uGJAAWmwHYwlD7TfETTdqjjR659hyrNFqcvuOkQt
         RmkA==
X-Forwarded-Encrypted: i=1; AFNElJ/f3vVt7V8c4qblj7rlANYSrx8O9FUS5LhVNt+h19yrMe7wVqlVSXOBwv59M+TJG50cJqrkU5i8Tw==@kvack.org
X-Gm-Message-State: AOJu0YzCEj9Oyd2nI0HFprLKn/NjGNAhKr1ngEOHUXOIRDkurNFob+WX
	MxgY0jEEwAZldvUbE/77XxhUUj7+vWms6SjdZvnIfc88WeWB47r6PKfqUJcFLdMBVWK3WzoeGEU
	HEmSEWuEpGwqBBHOkWRzok1G6KYl99fMIVMy3tbrlOPI2kr+kyKomw5IUf34=
MIME-Version: 1.0
X-Received: by 2002:a4a:ee09:0:b0:696:1cf0:22 with SMTP id 006d021491bc7-6961cf00103mr161763eaf.38.1776920720911;
 Wed, 22 Apr 2026 22:05:20 -0700 (PDT)
Date: Wed, 22 Apr 2026 22:05:20 -0700
In-Reply-To: <699fd494.050a0220.2fcbed.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e9a890.a00a0220.17a17.0037.GAE@google.com>
Subject: Re: [moderation] KCSAN: data-race in filemap_read /
 filemap_splice_read (3)
From: syzbot <syzbot+6880f676b265dbd42d63@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, akpm@linux-foundation.org, 
	almaz.alexandrovich@paragon-software.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, jack@suse.cz, jiayuan.chen@linux.dev, 
	jiayuan.chen@shopee.com, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, ntfs3@lists.linux.dev, 
	rostedt@goodmis.org, syzkaller-upstream-moderation@googlegroups.com, 
	tytso@mit.edu, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C851EC000E
X-Stat-Signature: 978esdw6u3kxtykz151buhuarkb68shj
X-Rspam-User: 
X-HE-Tag: 1776920721-835739
X-HE-Meta: U2FsdGVkX19Nr/qL2TgkUlh1eZh3SEntGGm6G3CgkAXKnHn0d4HxFwGeycANW76SoOPU2IO05IejA2+2aqjQ5U6BZ99NGckDBbGrnxkTC9TtRJq2bHX63xHB5aNMG6gFYH0I1lV9OeXKkRXgxtXUUPA6uHGbATEFLrwqVOczA4PWzlL1EmmFqo2O67hPdMSsTwm2lpkDLYTO5zD7DKdUt/mB3QsqxMPuQaRIEKBXHpK5bL9GDXcZFU1I4tMrRlUDC9lCITJs1NYRp/H/zj9eZbJzp+MHchWIbOjJqLsUNi+Dt+a2sRuv88UZeUq+/BWRKCkWkmxQUNJ2kQmqDiOmwwS4Fv8Cvl2AceGz+TETvb5ZzFmjzUxrpB2RhHMYCS7VDrscRkTJj+/eHcBBqJhkzo6vhRxLEPCSmIy7cPAK4W2BrysKJQbDoxh1TCNYd8L/Bmto7RV0TVKInyULYYJfzPEFmjqTR9WhWccs/nsm/JiOhoY8vcA8uVIEc7lps5hNPghq7Glt8m0MSn+bpV3TX1irCIhoGKcjOYflH3Cs3hdXWJkzkrxCt2Ajp3VPMrqhfOgzGky14dzvOArkJWjfSqiPBTo3UPE4RaHD+c5s//+CzqIXM22O1xorKi9aJVNa0pCW+H+vxT7OkEJuLskJtDkAeSZMuoFxgFX2xPKAWFhTmZ4SIDlzcMVDnB/kN6qMyimJI00hLVeSP/Ul+soh3lC7G9msxOWm239wQ4p6/IuaFsztqILb7aX7g9t6FjiGkmTEP33r6mAXpDOLNnyrQohgEWuaVGEb7zWMTwMSv1XcVVILS1d3yqSDkN8s/zmeZIPXWea7jiUJEkg37L4ETv25BN5fjZ/yg31L0K7+SUcw7skQzEi7S71lNTfK4jE6H0tcf97EvOBrlExxCVGqV6USoupVSIA11HBda2u9yeVocKGSk4Hd5uQTeUX9Lf+WxB0lOWEr9LJFT0wvUIr
 P7WCs8IZ
 JsSRg6I6IgKoGxYVLUl+cl1BClqcEAFXWMm+NRsOeyIHpj8COAIgI3pM72CDqOYyKWZdd1nMuA/LfAV8zOhPwrCaEwgjskw3yGM3YrXpXfnbLVUuGjrbqxf9Xtpkbi08bdheaS0AzuGHALtKIgYXXQML+Fhr9wTz+sBCgqyKtV5wwonQMQERTwsI91W2kOCxGMF6KCMJg6ztBsz6NGqAyFjc66mQM1oP2QTVyLezAIby7xHmoSOt48KR0PIt9PazmigMVX7kA/bmnnZ9nb5+YpEb/RgtS1pTOCjHimbOcn+z4Do7HWcC50GdTxNfMv4OBw+oqIrmVqhM7+8ZtrUXjSUIBmq59mLezFaoAMPdmW3nxNssS23oX3WZpdE1EAKEb7qBph8vZ8ANelvqARmpDVFtL+TqN3PFR3pRkG82WPGNt2TUD2fW2cXRuQ22EIsCOIrkcan+a9M1rR30+3phO88eSDaCYUoUMIfN5sl3aJJPEPxTei97B72/kv2yLU1BItHZzQmdKu8YvOppT6/4rxvBo1rcN8CrkAuYuE5mY7ZE/p1pzIYWth7Gt7LU4o71AiSRYc+5mU75YOZbqmfyxxQBowY0Tr7GiV879k6NgViACOmeByJC/aI4HMsfGwPdOLobVGKQwphftGcrv6nXMG53MY50OZh8fQ8HT2gOtDASfDAajic3Fox7jGrkvrGupQf95AX5PaVE35StZDpTXK6FP9GZMyxrhs28+WGUL36r/BkVieovsWsE0iblVDF1kNWh4cN/oniDTwPypvcVyFxMp8RQocEEMOBAaJyPm0VEkTb4bCz06r20fIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Auto-closing this bug as obsolete.
Crashes did not happen for a while, no reproducer and no activity.

