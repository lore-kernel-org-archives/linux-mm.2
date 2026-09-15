Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE79C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 18:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B518F6B0088; Tue, 15 Sep 2026 14:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01E26B008C; Tue, 15 Sep 2026 14:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A401D6B0092; Tue, 15 Sep 2026 14:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8392B6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:16:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22C6EA50BA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:16:17 +0000 (UTC)
X-FDA: 85216801194.26.580A14C
Received: from achilles.noc.ntua.gr (achilles.noc.ntua.gr [147.102.222.210])
	by imf28.hostedemail.com (Postfix) with ESMTP id 76C9CC0010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:16:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=ntuawebmail header.b="HeyPr/np";
	spf=pass (imf28.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.222.210 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789496175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIw3TqKdf6r1lTBpjlNLZFk1uLtc0Ed3f1SchXTgv0o=;
	b=K3EfYwZm5fmSgzfTHvmYkjihWU/d9UQs9P7W2Hn3ejpmaDxWboJpKcEFUfGScSRQ94+WZa
	uHKaTBskd4UJuaPxGeLAsuGdsz3MmhDT2oOcMgLCttWJlghNVmAx9YcC7mRXKSTYoj8h3t
	A8S4JwnxhoOMjj+D0Uz6mKZFB5F1V60=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=ntuawebmail header.b="HeyPr/np";
	spf=pass (imf28.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.222.210 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789496175;
	b=ItignBvqnVd72gnmSrjoaOl2nLQowlyv/m4n83pbWkqtEY8gYP2hrmk1KbbSvwlwgu+T6h
	AcmB4GQQo7SW/2ofL/34lNysAkzHM1BIELClhY5quwPhFk/5dR53CjsoETyCCezvIhW0AX
	gPm7GWNi5NgVERf911fSSRBmcSWsy9I=
Received: from webmail.mail.ntua.gr (webmail.mail.ntua.gr [147.102.222.247])
	by achilles.noc.ntua.gr (8.15.2/8.15.2) with ESMTP id 68FIFmiV017180;
	Tue, 15 Sep 2026 21:15:49 +0300 (EEST)
	(envelope-from dchar@cslab.ece.ntua.gr)
Received: from webmail.ntua.gr ([IPv6:2001:648:2000:de:0:0:0:247])
	by webmail.mail.ntua.gr (8.15.2/8.15.2) with ESMTP id 68FIFiE2012309;
	Tue, 15 Sep 2026 21:15:45 +0300 (EEST)
	(envelope-from dchar@cslab.ece.ntua.gr)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cslab.ece.ntua.gr;
	s=ntuawebmail; t=1789496148;
	bh=NIw3TqKdf6r1lTBpjlNLZFk1uLtc0Ed3f1SchXTgv0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HeyPr/npOSvdsVDUib5gkZ9sbZRPRn38Pk84aEkWYXtArv9KQ2bNzholvNvWF6/n7
	 7rWqD5OG4M1AmOrub3JdnpYMPBj+knA/OuJ4wl6S+FQeuLSwLKBwajqjQ2FouEGdk+
	 CYz39R6W3IvirqX0fEnHYflOaHSum6of5anveH2s=
X-Authentication-Warning: webmail.mail.ntua.gr: Host [IPv6:2001:648:2000:de:0:0:0:247] claimed to be webmail.ntua.gr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 15 Sep 2026 21:15:44 +0300
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alice Ryhl
 <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Suren
 Baghdasaryan <surenb@google.com>,
        "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] maple_tree: fix maple_range_64 crashes in RCU mode
In-Reply-To: <npw6xqsjzsdmtezkca4osoncnle62wvde7ycaladk3xzlmzguf@d7smzgbzsmpj>
References: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
 <3aqxp6zcomm3wzfc6jt4nhltutnvoatqqsjxlxpxlo3j72eeva@nkqwz43zxsug>
 <npw6xqsjzsdmtezkca4osoncnle62wvde7ycaladk3xzlmzguf@d7smzgbzsmpj>
Message-ID: <b2bfcd9b99d52bdc9d210250216bf1c0@cslab.ece.ntua.gr>
X-Sender: dchar@cslab.ece.ntua.gr
User-Agent: Roundcube Webmail/1.3.10
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.6.2 (achilles.noc.ntua.gr [147.102.222.210]); Tue, 15 Sep 2026 21:15:50 +0300 (EEST)
X-Rspam-User: 
X-Stat-Signature: uoo6mkhattad8sy8mykgrb4tgibxxx86
X-Rspamd-Queue-Id: 76C9CC0010
X-Rspamd-Server: rspam07
X-HE-Tag: 1789496174-853909
X-HE-Meta: U2FsdGVkX19MOLkkAGdrpTGwWn6Ft32oPy/En14IXc4EuZS17kSWSS1+6dx0+0MftvBIYbj2MmFFhcoriSMG/q/sWBcEqxZNRd4P3JYo34x3DBZAOGajRL9oBARmNyRK1nNkBQ6q91vI+o+lXf3f2xnn1L8oDFYEqOXc00SUXkomngs+QmfTpHJAF24OmBqojeX00UvYVkYqg+JhYOMRV8TIGFvTJuKTRLs9RrznY8oUqe5O9Ohp/k+0OH5/HYvw3g8y+ZQs12d/T3zgPcR3/8rS+e0qkxTNXyaWtvKjgrZ2MnfVAzF1sVrP2jFV78ksh1IfT//ZJnCvk0at7mR6pUcgwtDoHcjfgIX1AcRfc9Tlop96BX4HY7h2MMR2BxpWpYhmSMqaosQ9gyKca44wdqwZLO+d5ZcN3rgnhUoFFA3NW8cyQaHWjnsNFW1vNJy0lmj1x4FrDZUDyjtq9wGoo86OE3ibngsycA/5hgJIBII9PJ1j91GdbtEoHMSbP1xEfw5i0reR1lK34QmHRFUDNIuiyKj5lZbtZZOROd5n9mlAtqYVl0ZDAs3U/GipNaoVnCLlNJ3WsgW7H28WhX/0I/zo3ntLFYR+V+w0GS38GTzzDMrrjW5x0/sHB55vI2UG8rTbtT+rMhLFgmD/Hr3CSpxDVX1AUNKzpYHIqt4Wc30EBuGz3JgoVRHRSmFk//ztSFbgJV4EhmhbytOVmU1GTSts0Iis0YsXHsLGfNtKdNtKlYZkF68Kj2+rVdt2myb69LpbOTq6k/Ml4+Oirr+tN60t4nQgrZCWQrRX8t7i6mYX+NFvqmS+CboRkHTHZj/ercr6tGFPbkz+s/ew6KVpTf1AKR29+sOn0RRBY0XO57PFBYe0BEBu2x7BW20LmYJvtzFMl+M19Lr3Kr9Whdfv6w+2gBe3I+IWTfn+/eD6SH54DMJ1l1sxXtph3WDIRSiSytnBkFyXUdYHRoXNmab
 +Npxtd2u
 dFWQV0UeFLBXOi5etx3Kfwo0Nyg8IRXXOO0OYCku3Yg3tu+Vw71GC8p1yShAq1oCxWadGF6WOmOl9lIK/G5A1Y9G4rC20x7VMeuc/7Jqa4+zXWV1DEX9I05jGK+6lORAYWr6Ttf2/j2YlBqoEZyfd5IUUXFJhZKWRmHQOLN6I0/Iuqlk+jO0ROwdsNbTkNEB7v11dDaJe+o23esZY4KcHpvIs4GL7W+L84xxODAUvDK8W6me3lVg+S4pQjLOF1m5MuDBNWQanMYTMSQ3yDx2g2mFafs+hilBtqaXDoINzmalDCnts1M6jFmgVgWBgFgc+Hcb1RYF90pp4sL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Στις 15/09/2026 20:13, Liam R. Howlett έγραψε:
> 
> Please respin with a few changes:
> 1. The message in this email will be preserved by Andrew including it 
> as
> part of the first patch change log so "I was running a patched 
> kernel.."
> should probably be removed and made more into a change log statement.
> 
> 2. Add the testing to the userspace testing patch to enhance the test
> suite please.
> 
> Thanks,
> Liam

Thanks! I will, as soon as I work out the way to properly add the tests
to the suite.

