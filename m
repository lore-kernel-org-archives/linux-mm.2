Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 221B8D711C4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 22:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679F86B0088; Thu, 18 Dec 2025 17:34:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDC96B0089; Thu, 18 Dec 2025 17:34:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC6D6B008A; Thu, 18 Dec 2025 17:34:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6FC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:34:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E07CF1A0384
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:34:54 +0000 (UTC)
X-FDA: 84234048108.14.8C49A81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2F004C0008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:34:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RhYTkQ6S;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766097293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/L0AGyJlTxbgSHcvrMPKIQGTnkqGkBwhtCRsqdmB3E=;
	b=6b+toGoZW6rtARZ/EFghMfpgM1HziwFVfi2BD0024sA9NukFofzoQr2o0AmNzRVWlGEPIl
	zrkzTdcv5JGx6+dH/+K3Nauc6a3Rd68O9xir0je6tXiTaDyn8mu49NF5fUkyHBZqu93t3t
	PfexYUhvHTexWklmCBGeBLDCisdwweg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RhYTkQ6S;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766097293; a=rsa-sha256;
	cv=none;
	b=ASfSuQ5HuEI4tOGoa7S1Ym1LJNBDlS8EPJW5D8QNLsZbBvBT4lrurnZs3STCUa8NzQnkx0
	Wx57olxpiN4LVNv4d8xB95V2Mal+uJ27wt9mRTP+QD9Euf+dYWkH1nSCHTXrl9RzPve/uH
	mBheXoAFCOw0OMyhBWNdIdOm0nD9K7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A3E660008;
	Thu, 18 Dec 2025 22:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FE2C4CEFB;
	Thu, 18 Dec 2025 22:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766097291;
	bh=F1clP+TgIrx8yAQGZ95QpOKCNm6xz8D8rlXjso+rmNc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RhYTkQ6SVHny+UgmgRckd08McSyXNsVnJKIEGcJ7CB1zFezQd4xvO5V+++uKQLg6v
	 iq7WCcDUFsRgGunBs1y+8Xt7DjNLCOd/UNRhx3Gp6uiDCIvbPJT6ifowq7+1EtioLz
	 Wms+UJTOY11wx2Zrt+8FaEGlGH/khWaE6Zs/vPM4=
Date: Thu, 18 Dec 2025 14:34:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, rppt@kernel.org, dmatlack@google.com,
 skhawaja@google.com, rientjes@google.com, corbet@lwn.net, kees@kernel.org,
 davidgow@google.com, pmladek@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nicolas.frattaroli@collabora.com,
 linux-doc@vger.kernel.org, tamird@gmail.com, raemoar63@gmail.com,
 graf@amazon.com
Subject: Re: [PATCH v2 0/5] list private v2 & luo flb v9
Message-Id: <20251218143450.6570952779c195923830c02b@linux-foundation.org>
In-Reply-To: <CA+CK2bD41sMDbN670G5RrNQ-3Qq36dO3LmD18zFu6uc9KxhRzQ@mail.gmail.com>
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
	<20251218130725.1b93a521c039ce121de62472@linux-foundation.org>
	<CA+CK2bD41sMDbN670G5RrNQ-3Qq36dO3LmD18zFu6uc9KxhRzQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2F004C0008
X-Stat-Signature: iboiw3ut8baa4atr9ag5ijk6ctpme7p1
X-Rspam-User: 
X-HE-Tag: 1766097293-476314
X-HE-Meta: U2FsdGVkX1+7oMZwUzYuXJIzdB1YiKu/TdGFZ9Sb7V7QuNJPkSW27gkPxhNZ4XOOOAeLGRQyfuw0PzSa51Pp278zi04WA1Cy9l7IjO+iZVFR4ZPjP3cHqqSGc9A08pUAmzqkAsJ4pCiMMMml+6ncowF0nS+7CkdXsKjYueZCsKt5ZK5ut1YM5gH9sof9u98lfm3v/CGofBAnflrv4xvIrU0GvZvj0tFo0aWrFLySEzvlhQdBUBNgbTJs5gp76WskLM80+NSTqAxjKTqLRsQWmFORZjy6NLVHg7ZcrRPlO8GG3AzGkuH2LDMZSzobZUr+ELEKk+zfZw70PltdFGlVeeyVoHztXF07yWKkJVLZyWElWye5uoYxiMF924RQSpJ4+g0XZ1Qx9RaoAsfvNwju9lYYefTFh2DORL3tr9/Wddpenjui4PE7KZv/+QUumYDrQe70LqzfNLF90DkAr/+cPYHdQTwPg80NiY9GkE1fOjHJh8upCM7LQblUiFSHt3T6xSqxdRprS3nIu08rZshdw25mSWhczLR3ptoAe5bJ30ph2t3JImOIaEhW/ujJJ4Yk0TqE9C1pu7ZSCk/XWClCq40QuZbJli0X8tlxZc2TO6uWTpAIcxzzxuLJwRPr8TAzWQMVudo8V5yp3D9Dg4q9MVIGmMfqh6htStuSMRU6aAsXBmSynC/Bp4dFyhXQwCB853CvAkAtgsvaVjQsKMcFdbO9dm81htPcwEOraYj7qcFNBRvlLJMhC8LTsdzuaVK34pGtDlLVsPkemfoaD+PBEWOBabTN3DWMQ9cfUYuhtiqix+ffvF2jQbFuWXM7kI7irFl2ymnLtLzAm6QhFsSLOwueyLn/W1lCg2NE4ntGa/wJH1gkkXVf0Y2+9LIeFjSLOFViptwLbUQZJoaNY9ExZS+jFM2M1f3Bx8ejAtrohD5ea1svquVzRrfkTT6g4PJTfRnnL1qmviR1fIkRMxu
 zRNh0ueI
 F+KB0JkmjC4vAPtXqfmUZqdWCEknTOvHGHITnWgOVQ+uyiXRNBewNS5r2r23qSOvpF+tOpi/tcunJxCsEfIxzhBNlZeLnJ6FWei7BXYxCFFZEw/+mgHYB9cZgYcHS6cu4KLVRiP3hgsz5d9WYI0/uyqIPOtw3RuQ+b/wbMkBFjRqOAtCS/T2ztmsW4yOjAm2g3pgT2504nyqHKamMLVJYrsCh2ivnyfvJ/6d2E2oblsmtypnAq1nnxa9iGghwqHVG+aZzWkI4e9aGN+l2rhHnpXaK3FbrGSURlY4HZU49s7nbWHVKgsueE0j+dBYfbV9Fac9r3pcnAWJHkA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 17:30:45 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Point taken. You are right; the cover letter should be self-contained
> and stand on its own for future readers. Here is the standalone
> description of this patch series:
> 
> ...
>

Cool, thanks, pasted.

