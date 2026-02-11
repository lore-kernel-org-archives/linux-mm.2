Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F11ECD6CD
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 17:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2766B0005; Wed, 11 Feb 2026 12:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262C86B0089; Wed, 11 Feb 2026 12:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127DD6B008A; Wed, 11 Feb 2026 12:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02E866B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:29:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B54948BB64
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:29:46 +0000 (UTC)
X-FDA: 84432863172.16.18DBABE
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id 619D6C0002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:29:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Jma74DSU;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UOXdsOea;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770830984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbEel4PmuiUrUyHkaWhV7dLVKIPBghtgKZGu2hBZ3ec=;
	b=t0my7r9T5PQzQJjEOMPKka3UU27OMR/VlIRDHMvn9qdRC4V+yUcGFOtQdk0mX0x2fbgAcy
	yAghcFUsbjG7cWYcfYjVCXo4m3p3ABTI2trcZFkf2rpsA4Wv0ImWJId4Tqjth3xjE/8OOT
	FPi7IWB3yTVuEF34hDmS0nI9O8LinCo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Jma74DSU;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UOXdsOea;
	spf=pass (imf10.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770830984; a=rsa-sha256;
	cv=none;
	b=HDJKMTbq2Smck0XpK8gFZAwKtlhaj3ZvZ5aLytHg16ZZ8TmEd4/hWIy3/GnuKARHpP1WZ5
	v5TwDx68enaFFW139mjtRnNAnJMbCBQwTDPCn3gg2V8YEiQo3blDWvx+5fpNgROoTohrCo
	icbxSt3nwu7IxyWbSyRdjsgmhQdzEXE=
Date: Wed, 11 Feb 2026 18:29:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1770830981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cbEel4PmuiUrUyHkaWhV7dLVKIPBghtgKZGu2hBZ3ec=;
	b=Jma74DSUzZPNEfuy6ZOhRYuM2HMTFeS9q478o4j03Y5HEZSnqL/fcQaiH4WR1M1XS6nuiz
	KKvTZ+D44QptJZnk3zzvUotmD6PVDrmgBbfxysH+N1x1ewUcKYF3u+xwGeFxcdeF4WcSTj
	lyD6KucPfiZmYcBF55D+QDVg06GXBkB4WbqipKjoJCXMxPKSopsHa2Yq2kVQ01BEW5SZap
	X3vH5afWqIYoyyk4aqEuYhSfT/E5aJKwAuhsVZzy9n/GCjFTYM+9T64/LtCklXQTZbhjMp
	mzIJTgBASe/Zd5Nhj9S5tovWLWecxhX42MAl3F+8Fr8ldqXAOtmrJ3Gi4eKQmA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1770830981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cbEel4PmuiUrUyHkaWhV7dLVKIPBghtgKZGu2hBZ3ec=;
	b=UOXdsOeaBE3esYDWd+7rhBhF5NaDMRuQD4lXcXFbPMXaxUeNLwZQnByA6nDfa+Wf9sGfAk
	TshOCCioSGateLCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	surenb@google.com, shakeel.butt@linux.dev,
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com,
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] procfs: Prevent double mmput() in do_procmap_query()
Message-ID: <20260211172940.9RQbZViV@linutronix.de>
References: <20260129215340.3742283-1-andrii@kernel.org>
 <87qzqsa1br.ffs@tglx>
 <CAEf4BzZHktcrxO0_PnMer-oEsAm++R4VZKj-gCmft-mVi58P8g@mail.gmail.com>
 <87ikc49unc.ffs@tglx>
 <20260211115825.MLF4L4Jq@linutronix.de>
 <CAEf4BzZ__PYqiYEBxJQhAaV8fyNYSmDB5rKDGsvmpXG-Vu4eMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ__PYqiYEBxJQhAaV8fyNYSmDB5rKDGsvmpXG-Vu4eMQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 619D6C0002
X-Stat-Signature: iyoxgku7qmgwfbigxj8zjsmo5zpsc8i9
X-Rspam-User: 
X-HE-Tag: 1770830984-242328
X-HE-Meta: U2FsdGVkX1+3KBlNVdlGvyXXm++CzttrfuFCmfLY2YFoOomlKoS0wn1xySlMHi67klGMTY8rMIfTMaAt4M9ai/5OpE+/ifrC6JuXsCpP/Yi2cmAz3t4f5UC+kEq2mOIpHdQwd9nuBx5+kV/pDwl1yPb05SQcVlUGbaXRdCOmtC+jND/7m/bgkdiafhnni07jTILgLKZq9AT4awvV8OXwu33U77EphNKXhUP4fp0/XNILqJKn/FsqHWYF7x0OgGLtNcab8RnOmJb3urfH6UsCdurK/UauMpbBaP8+8tzzkY38nqYP8kDnT6nrbCK+fEC/HTPQy0w9NA45G1zZh6fhbwmaeVKjotXKKYdZOpfeIrlv5VHnZ7drlwi0iPLUidNZJcgiCNFso7kOPg30pD9yPeMwnC38M7V/cwkSzvo5kqP53VoSN0G4LLMtcuGq33I82Me7bAmoU/r7iOJAfOw25impwrUgkkwV/3EyYes2R9FeQBECbHO0MJmNWdfjMdkTuAMMi9AiFqg0fi/84kT/wz6Jsd/CIjgGyUTChWt4PyOGa8H7nOintjKEyKZKT5MkhDOzHy2lGbA26aJGQ1NdpyGY8t187eaBVpz6K2MDeRytiatkfH3xR79LK9ur/iKnQmN+iFaEang77VIbjVLfdKQ8x97twwCf+wdDyTX8t/VrAGCmlgqIvFh6eqL4RTDPiX/YK3i+Gdk2MXeP+kNK6u08jCBRn7b1oshryc6VjiRuY2ATjpgvmuQo3RKgq0VHzwz/aBN+3X+uB284tjCJA5ytQUqw9x/8QLuCTQe7Fd2LL9ohoTQiTz/Z3rm77ZFbMS39L2Fotv7ccrsgcjBuk9WKq5WnZpKgwspeUWUxltw6fr5NjBakbPmaHq/8NWpfcZp7t5UZU4JsA/j4fpbpu2wUqhAmaAVEaXBAijuVfGdyAJY2oiaqDQe4bcnSEQEXUA6jTgGSw6KgJQesa9T
 U+1665OS
 mxi/8d9LycXc58vfwdGJ3OL/D2DZCfhyxo1QD3jnC2djRHJDPzqAeGH4dETrqhxT1IgSmbR8v0bDPJ3Ss6x6qn/hbYjdq9ekgxLUV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-11 09:24:15 [-0800], Andrii Nakryiko wrote:
> We raced with Thomas sending the same fix, I see that my patch was
> staged by Andrew already in [0], just FYI
> 
This one has a reviewer :) 

Sebastian

