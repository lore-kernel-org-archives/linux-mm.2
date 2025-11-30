Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835DFD111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 20:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2C66B0007; Sun, 30 Nov 2025 15:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA286B0008; Sun, 30 Nov 2025 15:32:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7876B000A; Sun, 30 Nov 2025 15:32:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB5746B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:32:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83A2E51805
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:32:51 +0000 (UTC)
X-FDA: 84168422142.21.4310F26
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1C6E080010
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:32:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ODsAOL0p;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764534769; a=rsa-sha256;
	cv=none;
	b=RQNaDK2UYhvnJq3YztHEsWTdoY3V1mFQFDFGsEgajM4bOxsVzgBzaZLX49GlJjFKVeTXhk
	BKTajhp5+m5VKbwEbUHp188qWwAfM6WkobkoULy2xjaIys+44Nhpbak+fucwJEXmiGXO3p
	3G/ri9SzZFAKyQT9KEPzUHzvDaggc1U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ODsAOL0p;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764534769;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SG4laOmIYfaX0AulgAf4e+Z9d1ZTQsjEZOC+Us8Bu7s=;
	b=7N1iwL3t4JzWy1bNpDSXvKX3fJ89jqPTEwLiAvuXoSDLuvVXYGAm3qjPiHayl6ObTce0pL
	fX3s3fB6EZq2y2AH2VbdWgbB7zGFL6n1RlDGsrUvGhVQjBIxwvwyuN1suhGVOObwWaRVdV
	/exUZmzEZ4nmIbU/HqIe4Rk2uRZInDY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SG4laOmIYfaX0AulgAf4e+Z9d1ZTQsjEZOC+Us8Bu7s=; b=ODsAOL0pgxUcMd5xFDQnqVBGul
	1txeQZrUZMLqGYQAxnqez8tYY0tANsGNWfSxQi2AgSBLa9ou9N1swildx7fWjPDZrsYrVz5WxNQfX
	SVza4ZDTyDpyaOos8uQ3e2deSVPjr1TDi+M03qexXYV5LQDo/yQw/exVaMBSADObuuC9ZgFvmQPta
	J7+1kI7Ntc9525z0MSCIXUbiR9ykmLzrpUIExeRGNNLOgAogK1omJWwxN6wkP79+QVG2R6bkLdqzm
	Woo8HOByXNeQxTyuqu5CZNg8y9U9kDlDn4D60JLMx7Uslawp+8Cpyr3nKT4bqdoFr379wq2o27LD/
	ZD+FMdWA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPo6N-0000000F4H1-0jjX;
	Sun, 30 Nov 2025 20:32:59 +0000
Date: Sun, 30 Nov 2025 20:32:59 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: david laight <david.laight@runbox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-alpha@vger.kernel.org
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
Message-ID: <20251130203259.GX3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
 <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV>
 <20251130030146.GN3538@ZenIV>
 <20251130113213.40c8e7a0@pumpkin>
 <20251130164348.GV3538@ZenIV>
 <20251130190331.40385ddc@pumpkin>
 <20251130203118.GW3538@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130203118.GW3538@ZenIV>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C6E080010
X-Stat-Signature: rro7ee8ydhuqx31k4ugt6nsrxu143xpb
X-Rspam-User: 
X-HE-Tag: 1764534768-983237
X-HE-Meta: U2FsdGVkX18uBiv6Io8txu+qHVeq2RdRva/naYAEkLcZ4VN/zQbmS51h4QWv3FgkmCWtnCBTBgeD57sfhAWBCBbsBiPAny6S1Fzoc8TMEyVe9Bud4PryvH23j11Spnrd8OEuSBnsasH6JbhSaP6htSLaq3avc625hINm9J7469h7/ylNhtEQt7GiPXXZott/cqHP1mTewUqp+507Ds3eskmml4U23CqXN3Vo8Eb2DQcBcncvSRuspn0WVsE0wqbC+zCy250RRQKKWRX4JMRnDmaIPtEgzlg/lePmAOjiyvrX1af616m+/PmgpePtdOtJHvt1KJ4h2+c0IkUfTEOltiP5El3a8AZhiAG8v+abDNnZJ0sAYHprSkOTwACwNhAouBC4dZg/pVHjQnleaQhjcZTBOUtuyPdon7lJrSBkhlpONzUuZcvCOGG1mLIm2yGPRup1J74vW5eFs7rTfDtzUhDlWzuNHwbdm+uNu4NqYmed1JIDJABS6N0njHBggR3gy5Up7v9kFHqwPhugjjtFHUHvPiPtJlzaVO8nKX3GBf9fMkaITA2vSViZ7eeAfGJxDO1p2CSQKaev87h1OVla9JqEqE/3p4LV7GoNVYfEB2LHvFeAUf3As0pGbFTZfr9mpCsSgYRoXgPDNYZGvEeShoHbLdDSTv1EK9++0MZvJqv7LOoaOF1o95LcER8b6gn8eTFkrtpLGiIXQqGrZZgnR77xOL6U07PPQRVV+f1LeCbI3Q/3fp54agYbfSvxPHiYlppjC+7kPD3aoaeuToIITlRlgjAi9n9jek4cCZFV1jILcoo8w3d7G2V4vUIbZ3NtsdBiiUP2FUvo6SzAED5FxqLyadr4Zr4y1RYJ2hsxQFW2Chl5+SamhUttciDWOk61TvWtNkob+JW7suaHNYAUGeGPOyzEdmxsHjB7WWTR5FcBrPgfgDQ4xWoKDeJ9rXvvP0xtKc3YJjFbKytT8re
 yMk6WaUg
 YgrcqF+NHF6hbikeNoMhM1toBU4JzQmlpbk7ylnBxk32tRjlRTwro7ygwULl5MoxYn9XQD0cRLUqCUvT4KvYqOk6XDTjwCGO7kU/9AFzr8KPk9b2EE+TF8b85vrEXFsMHzkcW1mTSNphdHtMzIG0Drubbk2cIVx+DJR1t5vCwX8QqK+Rp8kC9ByjmDTE4kEy7PxleNSErauEgS3m49g/Vp0479WvmIojZR4gyS7SBmw5vYkTe7W2O/r714KgBBOLR2Iu8Ohjzcud5/GS6k1UShifuUf9YrZTHra0wgwyk1P0swrd935D9p0LfoCpFM3NiBnyGpOiLekpyj6nyp6hVn/Wwn1q2zwBG4cov2eZV6IrUctiM37xmUebKM6o4UmndHIZRU2VkT5XPMXFChTrDWmePZvM0CdUA94nTx/BbZKcp3Gge5ngxVrAealbxPL3FUZdf+ks9cJki81DYo4x7ABd77ywlanx1C+ga0P25EqXfgS0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 08:31:18PM +0000, Al Viro wrote:
> It certainly can happen on x86 - two vmalloc(SZ_4M) in parallel

32bit x86, that is.

> will do just that, but with NUMA you can get it 64bit boxen
> as well.

