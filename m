Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60156CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 16:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED15A6B0088; Sun, 18 Oct 2026 12:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E823D6B008C; Sun, 18 Oct 2026 12:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D979B6B0092; Sun, 18 Oct 2026 12:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B90506B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:07:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FF6F1A055A
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:07:21 +0000 (UTC)
X-FDA: 85336226682.28.69FBF47
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf26.hostedemail.com (Postfix) with ESMTP id 189C0140008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:07:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=X7mUxzzG;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="Zo6n1lH/"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792339639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PF7sploXZKUksNVu2vBA7Q/K83btVNBj4zu783ro08Y=;
	b=HnKw8/CyTBXvXIp5WH1gjx56gr5aK3L9VuTIm+24Zno9kEPVS9oax2jq+RN+Fq07KvFG3P
	/OOQktkLpliS1sdwpdSKDykSDzNPz3GzrkQ22Hl1QTG+DKpJzWCBmyjsO3C3TtETXda/lu
	o+WDO0RlrpFG4VZBqPOKXWiMhdC6ci4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792339639;
	b=spS5AmhZezJt+G1J346dreMqTV44GKIOnRl5XBLxE0wMjwfS3KBaySeZIFb2HMaDf89l73
	coXcJPRRh3Mjx1zWY2dTzqvl2wdGx/DOvlqDaH9/vW+fGfCLTxrAlylJvZQM01DjBkki04
	lQki2Rr4skMhkLl9LYFL55mpp+ySIsQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=X7mUxzzG;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="Zo6n1lH/";
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792339636; x=1792944436;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=PF7sploXZKUksNVu2vBA7Q/K83btVNBj4zu783ro08Y=;
	b=X7mUxzzGpMgIXeXta8T3QM7r5oTn2SVxPFka4nW+gYehm8wYlZiu/5B4wR4TUXCI+fimkasBxauHR
	 loaODBO6aedIAUBWbJsRnvtMoEH7MCZTt3hkvRgXCGaoZcf5uM80dvWT6H/vP5nI6JaAcfUqWmIrtB
	 7gNssFIRuotBLh7dUDkZHIdlu0xdwOG3k4CGvy6BfUD/LO/zzVtbNvedL3sN34QUB1ytJD28jf2R2x
	 zdLwUPeO4vpzVuyObfYVTu1YiW297d3C1WN+M5iEDqAKOPQFcOZfZzTFlB6uQ8hCUJNLipADWf3AFa
	 7Ews5+wHo3ybU6WwlxRyKNyR3DiXtag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792339636; x=1792944436;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=PF7sploXZKUksNVu2vBA7Q/K83btVNBj4zu783ro08Y=;
	b=Zo6n1lH/O7fHr5Di7LPgOH3OQMp3Zc3EhFairyTVgUzHY4cZqORMGVI72yjIweltKuN3m5We8GPWg
	 1j7UYuDAQ==
X-HalOne-ID: fc234faa-cb0d-11f1-97ec-1db1c303b0c0
Received: from localhost.localdomain (c213-102-77-204.bredband.tele2.se [213.102.77.204])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id fc234faa-cb0d-11f1-97ec-1db1c303b0c0;
	Sun, 18 Oct 2026 16:07:15 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	hch@lst.de,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nickolai@csail.mit.edu,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	vbabka@kernel.org,
	vitaly.vul@partner.samsung.com,
	vitaly.wool@konsulko.se
Subject: Re: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after concurrent resizes
Date: Sun, 18 Oct 2026 18:03:15 +0200
Message-Id: <20261018160315.1465504-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <atTh-yyVIPQ-zNWJ@thinkstation>
References: <atTh-yyVIPQ-zNWJ@thinkstation>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 189C0140008
X-Stat-Signature: o3f5b81csj3rdugn1qe4onc7iy7y45fb
X-Rspam-User: 
X-HE-Tag: 1792339638-186690
X-HE-Meta: U2FsdGVkX1/3CDFSQKbwMKEVpHmGalPZDE18fYjD5DPbvQMo7tBsQTtKNviKoQAlDLBQIYwEDiHPGoeFgvza7KuEz8PU7p0S89faIuqG1/NpcUJlcsWUxpX49oNugwiEFWfGxNfRHQrHE3fSzNZ4rJzv7Ezt+2ZHR0c5Wj8pm2hPUzm+L9qNANooT1ZQC0ikKGHu5Okc8CjtAFGkOq76ot7g5X86pTINnKVh+HvZSSm68u2YJfEHelQccpqVSXUL2ch2XibklIXicEAn6jxSiDK6bwMP1x+n81F29Z0PxevG+oguFn6Nfjqe3kugAJ0yeeZvU1nZYzJZevrMUEJ87/xZNgjCSakorabJ1h8LbrFiukoj2Y/5ukVmfLUZu2hvRq4p3N16VqJvq8FmNkh3NitMYSIZZxyUNNABSUgIgoAf7on0lc98CBpgrmHow23tDIy3xJdC6nJoa6XDdbZOj9fSn+sL77Fku/TO+C92UPdr627bM3U9wOXlfRG6Xv/6+zCyp0joGz3xdIhlN7gbbaWQ4LRL0/fPB6x1EGVTK2q8fu3S6U2gI9YRI2d+IeWq/ShsB8IMW8+/+k1iKU7V6MHOhYLhNB5zVXFEWTQ0Z14qo0wllG5/4yl5Wxi/aGd6tDLRC7x6DXkrf3jGXCVaD1HV7YP+hpXtsYE/dzpm03+qtQS+Z9jlrHvmnhh5i6LGeadbZlH/dmFkM4+cny8ahZvfm4Cw40dCdiE2n4pZyfhfwQA7YUIKvI4cEVMbeOGeVcsNF8HV3JXgXy8pHvo8rACsOjF8BdvI2vcpArJTuu0UeUEpH/SoEoa9RitX3tAzlvekWYbABRiIqcG2/TqJdUAd/AbyLXjECfSqaaIY45yIrpOhhjA4j2q5zaNpFIMFmRFLQ9z9tP5tFT+vGSmpJG0u4PgY9hnfght1iXEKddEMXPDU+TwINOjJxkqFkHdqvOhkviKVAMMHriC49oC
 YG3OqTG9
 bd99+YdxciS6OZG/91RxIWRrYplW1vBQ0pYyFtQO1pYnvPPMUyBkJNYM6Y4dojMDNQKN8D2QkP8kWYX+xwv8EXnjAlwlDa8/7l4ru3qSK/9lyiI9V2+17xPvRvobASXAbFJMuwq2HhK22NJmLnvLsvl6ebGLcgI9CRlom7WNuCwXtGHD73QbKgJnLMJBMRI/MKlb5QSgSZ7wodWh87z4qc1wXAFXhe2IiB5jYk916OG+t3jKktbfF06kwgJoO1LQqeVh78ejqPiYe4O+CFAfgMztSFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > How about we take my patch [1] instead since
> > it isn't prone to this bug and is a nice optimization to the existing
> > mempool_resize() at the same time?
>
> It is not a good idea to squeeze a bug fix and an optimization
> into one patch.

Generally speaking, yes. But that patch had been submitted before the fix
popped up, so there was no sqeezing per se. It's just a better way of doing
things.

~Vitaly

