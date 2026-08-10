Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97516C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71116B0099; Mon, 10 Aug 2026 11:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48EE6B009D; Mon, 10 Aug 2026 11:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987156B00A0; Mon, 10 Aug 2026 11:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74B316B0099
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:31:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEA99C01B7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:31:12 +0000 (UTC)
X-FDA: 85085748384.19.66CD85D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5DFDF140010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:31:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCwFFAEe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786375871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZgoC3EVHJl6ia8wuwHBh/UBVnOr2ch9hVINB/bxGV/U=;
	b=UdFz0cN0+ZE2ep5fsXoqgnc1dvaIvs5X4TpSkNvtDEGoylpJflO2T2M5ItZIlDmh47H6CD
	H+CkwW+7p+Mqf1smeCBYZVJsDlORRzXbvPKcfqGx5hSQXsC9uFwPyy8qX//GphW/g020av
	75JR9GRTliaGZryGZJZ49CiwNlIILKU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCwFFAEe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786375871;
	b=yvYnUuNzVyhQ1PiyJgEFBWTzQRSoIXn8Vib2cyLJDiWkGIUJBWr5llRHCt192sTXSSlGKA
	u72YR8mZZWjYNGjlep3WLERYfnXDuPt1plYqJau63rjmKTaGX+bQZct1cYr6YmvLd3BPo2
	LMrO89lD9bnGcsQSILmyLKvD3B4FITI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 73996600E2;
	Mon, 10 Aug 2026 15:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 94C821F000E9;
	Mon, 10 Aug 2026 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786375870;
	bh=ZgoC3EVHJl6ia8wuwHBh/UBVnOr2ch9hVINB/bxGV/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XCwFFAEe1Sf0qajqt32ItNxUt9zLYHwaT1IcEnbSahBhN3nnERgPwaXvMP2QJCFMe
	 KQthG99ng2h3wLISdbzBBnE63ZRoecRSzYDITyeqXKdas3hAgjfs7+8wOXl1MyBxZE
	 R2f2d1JyTmu+tfyEhWytkipRiRCSGxyXqW+k883Ng9huX9i+mJqHUktkIM4iFxuiH0
	 Pq1/M2PcpIzjCy4ieeIhlG82xjElda7RKVQeD5gfgBAAbW1EcEHTvVWZZPvf7b82FD
	 lqvSzMWwI//qHCB13jg6xeEVStnFNEKvpYbhLTx6iiPtmb6g/W3WPQZaddeXKbK2wN
	 TlUP6SR1Ydacg==
Date: Mon, 10 Aug 2026 18:31:06 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, keyrings@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: Re: [PATCH 4/4] security/keys: zeroize key payloads before kdump
Message-ID: <annuus46w5SXmlsA@kernel.org>
References: <20260731154608.153258-5-linux@jaseg.de>
 <20260731154608.153258-1-linux@jaseg.de>
 <2259835.1785538211@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2259835.1785538211@warthog.procyon.org.uk>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DFDF140010
X-Stat-Signature: hzbgck5xsf8amryyiqh5hc3ow45ckzah
X-Rspam-User: 
X-HE-Tag: 1786375871-752684
X-HE-Meta: U2FsdGVkX1+ebzn5fphLnJPfODmf63KhYUUHUua1xqOA4nu1xi11rz+t0yU8kAg0GhROGRAsU8QleCy3nKqKHVOC46W/meXeSjIW/qFA6A8qt1N5NiGO5C3K02lHrmdKoGFj0osJaFKHFt1WHKkBdCsZpTBlmBntAIfP0p/w90gkNKNX264/grV5hppW+J9V0GReX6seEimGiBBtujfvvMpN0ltb8azzroBdoN4wdT265Ajgs1BIQXgztZ/xc1v+5ZWlg8MfwfxuEQjV1OvdoFbl467Bd4cTGEvZFO8F2FMzmbihdIucZQj0eSEYrLJblM883eya6A+cLU5o6HpBy9GTMXjw1D7tRdzHlBqf/OZ2pfT1+dR94t2f3uxUEQcA5y1LR4dQe+t4xYugNHCSq/QEp5ISJ0dwrzWLbVvfAXxt07+a7bx6gpdZb8ngJhEmvtq8vTscXFQNyJ4tbQX83etgtTEc/6nic6tn4CHewsSkgLCCzOqK5WXi6FJO7zwFPS5v2j8RHAfj76GUwgOEz58tdfNcZsGRIfi3BZ2G8LpO/rFDstAh2pPeorgVEys5M1PUl2nn+9liUkP+Ns6JbFO9ZEzwgTn0afYon5eWtXyvUviSSVmSfq1A1j0fOiYI7gULwS30c9jvipXz/zHsS3UGu9WRhSMvbcvGDilwtnImO/vN+eO+XwCJoxZnj7hS6xppSdQiGjnAwufXOwKsH0RFFePYiuDvmPW0Z4JL2d3a3XBZPK544gcXGRmQKBZS14suiIaMZ19IE35ZaPdpjfkHC9JEIGPwJ4fp8gU1KcAPGf/6QzkKW8zPhGJ8qWBNk5u3q/kjxphCWY/CAcsU0zJ1l0zniC17yRu1iI+0uxBzVQMo32QUnlOVC0PG40I8m2t7kschwhZ3jYIbWguUDpnKF5OPYJJ5au1yVByFuEe88VGkoGXftGm7o7pjvEOrOLyyT/tHBGjjQ7KHriS
 i+qfAbEz
 N9Neqa1qaGMPuYUDwf3IhmUGHpF7CDumETvgT/lfkAypLzhKLiMe0raS6TE1aoyTKWOUy4cxQmD0UDr6wfoiRZqP3Yoi2W66kKWEzePaB80HQJIYaiLr5xJXmnOFVLkctkY4k2adK3gcIZ2NxWYP0kFo2flfpmsFMuptYGTq40IYidLkeXIKZyS3F2tf9mtNjOpDx1ymcP77u055X/+B7G1wwOedJmw11knaBKhwwhN/B2T1YoxUNsQIt+d0vE4G3IjhrZg1/I8kDGlAUBZURoGywOT73CmE0mEG+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 11:50:11PM +0100, David Howells wrote:
> I've no particular objection to this, though I'd prefer the name 'wipe' to
> 'zeroize'.

LOL, I responded exactly same before reading your response :-)

So yeah, +1 to this.

> 
> You should also wipe fscrypt, tls, rxrpc*, ceph and cifs spnego type keys and
> maybe asymmetric type keys.
> 
> David
> 


BR< Jarkko

