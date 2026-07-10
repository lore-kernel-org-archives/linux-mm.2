Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8E8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B9F6B0092; Fri, 10 Jul 2026 04:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC4E6B0093; Fri, 10 Jul 2026 04:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2A76B0095; Fri, 10 Jul 2026 04:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB5CA6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:51:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50E3B8DBE4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:51:48 +0000 (UTC)
X-FDA: 84972249096.29.2BE48BF
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id A47BEC0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:51:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gfurfvAY;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783673506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FuP1eMVNk9mkgmdOifxmzFZMlk1+U1DrobeqWEeEQU=;
	b=XGv2G1wx/gcZ0li728lWx3SOctJy7G084yr7rrKbxnJ/U75GSh10DSFsz72PUGJm3RLwBR
	E6wZC7bjc5bBh4b9uQ0kZJXWZr0x5K6L0eBizKSw0TBIAHeoRqaIqymFT+Pdy+GnlH2RpU
	b6ZEc4Zb5PcpZi1PAn+h4zvTDP3nx94=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gfurfvAY;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783673506;
	b=IiVQvhwCCwZEsQZcF+z/Etm4VuoDQwzcOJzN6Xdl2pnAoYq0COT+nJB3/blgYgonoAbKK4
	i3rjIDc6shGAeBxzgzq33nnZq41JRMnNs1JFS/bYQ17DBRL4A1WEsMuzJAYpeq9WCQ+vPy
	v1zjAY6+uo7RcSp+3fHWdPtC5bHOm9A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3FuP1eMVNk9mkgmdOifxmzFZMlk1+U1DrobeqWEeEQU=; b=gfurfvAYcWbyKsomW4JufEF/rJ
	ahzc8mqteKkRBc1IM1pOlveeF0PkaEf9I6dLtUfche17t3WNsIrTbaQ+4+QHWlBCysr35OkckOy6B
	0qL7jHhdESb4RcsNBFV9IDVOVTaFfZow1x+dUxRXVNspqEBCasOGCrgeUM/5/iGEPjA027tV/qm/R
	jwStVcf2DhYiI/aRgwJJxQdzWesLkYmvn/Yc2zpEfhjVuFWFwmqZX5PQbYGE82i23VyhcDp7fMB4P
	AjxYrhOE+U4bROGfMYkiO91dBdlUXaAuRxZCl7lJlR0tiZAiiRuG3qCIK+uVoCN2pbI0ifKszhwFg
	JNgCwpLw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wi6xT-004MUP-2X;
	Fri, 10 Jul 2026 08:51:44 +0000
Date: Fri, 10 Jul 2026 01:51:40 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: kmemleak: confirm suspected leaks with a second scan
Message-ID: <alCxkNBvoDGRG2ee@gmail.com>
References: <20260709173347.689607-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709173347.689607-1-catalin.marinas@arm.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A47BEC0002
X-Stat-Signature: f194ifknzctxfr8nwsuuuk1gwghkk8ss
X-HE-Tag: 1783673506-786998
X-HE-Meta: U2FsdGVkX1/oPpScgqvfx27cZQ1fCpOb5CoVn8/qRc6DyJU5qFh9c0dGJD24DpdiL6mGaO3V6H71rQHOYbVdgoomRN0m8SPmWjviNmKdJ1QlfHbwkZt1hieDupPkTng4CZWxDoqEESXcmCisVGz+T8+iakhObIdu7F0eBd49x5DCmXya+/4VeE855gDoYAMamP5krFPZX8G9fPhCBl8Fz9X4XUwjMac3l/Mbpd4lQ15lGvUDCQz1sNriRPdpwI0wg8u212a4AgbFjNWBlt/ANuw37BoapdYgVeSNEtf65uVBggN0PX1A1wGcJQraX1NtXYU/BJ64j15+nuPwxuqRansk9UmBt7gR+UEEeJ0AlUSINMCejzLvt9oxhsBma+gdfbMsE1UZZFZMqFHKNUXDa79eNATi06CxL2yfS98nqkIz9z+uT8XZaWwHWV2YZSrbxXC8sq6jfSFETB10DRWZ4AcNnL5vpS7fSYnLbZsmerVUCvhXzOguFUwapzL6FWHUwZTRFDBvGs8IBcxEBPr9Q+oKUNStqLfJUJByuCOi1/l8jq1OpnEHXDr41eJxJ9lpQQ6SxGhxxN52T4rsPaMspvOX5GC2fTTE9hnzW/w9lTVBKtFSZ5t//Wbxy864RR6FzV8WjVnAWiYYN3qirKSNkNWral3g9LmtmRe9Z3Z2viXAO2p8F9kfGm8n/8rAur2JuC3/ddmO8bfFKw20TXZBkfky0YqGF1RqIswZ84f/mMbAj/oI0V45Cs1Navzq9ZzWVkFbJPGJIzJOPTI1w0LUE0PxF4w53PaV6NUPLB1CcnevwI5kciS5frLwvRPpTWbRNbYN6F0cR8SyphhJxksU7q5ioTklUNyKAMnHkhmTahRw3rKf8pb6JugPVdp8Hs6UoSSQNan3zbqM1sXqYW+ZPVTwZAsYX2kMxeiuHFcmjShH2JJuOtF1lqv4GNL3jfjZd2rYr1oBbYed2BF+Sw5
 GxdKnDZy
 mj2RmWeIXwnFH4NGF7xVLGV/P/H/KlIJSMpXYILSquBv9ClsnJAU/qAKlSXOkOq8NBhy4YfOReEhRGkiMi2OirNlfdkHO4G+4KL74BNCbJVqk/fdGzqUyuhuCmtsrA625CLvn2UjrMatc1kawXQf7biiBp10L/NWsSqcMvbizRe99TzIyaAG7qVlGxO5BsH12Sk0bj/GXP4vU3FQZVn/pA1SKyBb6DLTbf4CZLhkL0Lp5e7iO8UioStp4NoGlRZ+CdYNEylBCk0ZmEearx8q9QPrfB+ki/x55RZ6skzKdqwAv5n0ABOksxI85wJbdPk65qvTAAdzNbg3tlXIHktTGeD7GhaXrU4WcvF2npIzkOobZ5TdF8Ovvh76QFOzU7NLepRhYBcz6lcKop4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 06:24:47PM +0100, Catalin Marinas wrote:
> The kmemleak marking phase is not atomic. While the object graph is
> traversed, the kernel can modify pointers, free objects or allocate new
> ones. If a reference to an object is moved from one location to another,
> kmemleak scanning may miss it. We have explicit annotations like
> kmemleak_transient_leak() but identifying and maintaining them is not
> trivial.
> 
> Given that such transient leaks are short-lived, rather than just
> reporting such objects as leaks, do another scan to confirm the
> suspected objects. If no new leaks are found during the first scan, skip
> the confirmation one.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Assisted-by: Claude:claude-opus-4-8
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Tested-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Breno Leitao <leitao@debian.org>

PS: This is now conflicting with commit 946935b07cc94 ("mm/kmemleak:
skip the remaining scan phases when interrupted"), which has just showed
up in linux-next. So, a respin might be required.

> BTW, I'll be away from Saturday for three weeks. I may reply
> occasionally but won't be able to test anything.

Let me know if you want me to respin it based on linux-next.

BTW: Really thanks for doing it. I will backport it to Meta's kernel to
pressure-test it and keep an eye on false positives.
--breno

