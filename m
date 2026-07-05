Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD9CC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 19:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2306C6B00A1; Sun,  5 Jul 2026 15:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1C26B00A2; Sun,  5 Jul 2026 15:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9F66B00A3; Sun,  5 Jul 2026 15:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAAE16B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:16:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 504651C0FBB
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:16:22 +0000 (UTC)
X-FDA: 84955679004.07.0586E32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 30467C0002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:16:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WdMyj3Ei;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783278980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8V21xSOpKNfbOY/h4eAFkAKGMZa36N1HKOxIElNuMA=;
	b=Ct6KKbaHn+9Kd3eYLKrKuDNwb7Fsj2NcWp0OUHRtulRptNQIAcZpvp464FZQyLKgK4MeAk
	QYbA9yEDqe+q0HmMLkISLJdewBCEGl8mhkUAM02HFUnD+Zk5XDkN8ioZHNNDLOOT5CpkmP
	BOM9ouHPMCtv5l1THb2eA2x/D8ebZJs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WdMyj3Ei;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783278980;
	b=h1Bd1S1QFUbncYvgEgPwEyErUOKaSE9jTsRPiITMkw4jNdMqoWWInSgmu+JK9ODe7BoyrN
	HdHf/tYoeH91Pop6K1FBmVV7an5cgzgqIUpggbTNeoL3uMi5FFTEI2Qhp6DfuJQvG2INc6
	FmoQm7UvKioo9s4+AmWYfMcRbub0ac0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E364600C3
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7201F000E9;
	Sun,  5 Jul 2026 19:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783278979;
	bh=O8V21xSOpKNfbOY/h4eAFkAKGMZa36N1HKOxIElNuMA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WdMyj3EinhLL66K8Dk3ayhYYEX6+gLlmTKRbtE7aBxfe1IOeQZYkBj9SCgZIAGzI+
	 rL9Zdh2axQz5YktA26Mm6jYYz6xuwPtJIee4BMDQ3s1FmFAxsokV56kwm4I0D5Ki6b
	 I0w8vJiFyN4t29QAUV5JHz3bLzBLsJ1hjckSahlA=
Date: Sun, 5 Jul 2026 12:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: validate all parameters in the core
Message-Id: <20260705121618.48da52edf6747499ba626dc1@linux-foundation.org>
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 30467C0002
X-Stat-Signature: yqi1g8hh5ghm7w3d3jn6s5htsmcywx67
X-HE-Tag: 1783278980-322685
X-HE-Meta: U2FsdGVkX1+lZLK9vhNrD4fENAyU/xzyb/byqxt2ZtMGga+UKeNWbynuOo1Q2ay5Zx+oUrCqsVYKwGx9OTKgH2F7zW5oY0wDmcJrjxi5OzeArHzNpL2P5tO3odaNkbwpQ6V3jLV9VypDXKr+rgeWpna6WHXGYEYur2kHbZak7BYQLC/ysrs0VWyZwQACvHxwCczvWX89SVforCBbZlbflAlwMXtx1S7GQ4vYuqZhbfjv2M5bNRxG3aFMnVtoczfcrLORxLcrKVbJDP74GyTH7MeesoBeGx8JCfzds9rYQ7T9Xt5EZFiRBibPZgyav049j0QOG27VR41IohSb+k/NITk9SvvCb6O2co/onIRKJOtwko+Q7wHZU1FlBsIpFW6M2JezU5Li1yNg1Re2bdCTTXa4M9uUS/rlnCX+nGXFW2Y/l1uKpm/fUzgNPEfYXH9rSXPmAjPsUbS5YZTS/rPDpScY4EelppwjzG160kyHFD4RxvDZy6MTYdPHr5EF+guuDSq2xWS2AM632pWyQ2H/9EpMeJzam0G6fcybhAIU9yyhk6QozEgrhtBx1ru1zwvJHWhvrCvA3+FoPiMSROykdn79YUZWw4IfwWsprM7qJi4HvgXhnqb3Q34Xnd0p0RdoPzvbusMNk/Yj6NLdIA1ykxcogRLfi2cyXkHwpy83AtMbalDTgfREPz5hD7McCfsS5Hu+vyroNr6xY5glrYUKtK2jzTfcIsOkSAZZ1Tdk1N7mnDJ5xFCFuVaMqtF97gObVDJg50HZAB+8Z+dMUv7GYt8Dnyxk51HwcY+UkmIIBF5MQ0F/NmMcXdKF2uJ2AuoeN8e3Hpl3phegPX2yTrz5XFzp8PuCsKNGcN2YPpA7X908ZWSVtAc0ZKOkkMJFr+0Y9bvWlWtJcutKvQ2uegYDFBshj+LJOxC40EJiLAMsjKYa9uFwvK1u7JHYUWIvnFdXs2HIEgGaaDu23lZuNzB
 KEVUuwB3
 ISBTVvmGrFNIjwjrNjj690f51CKU9kLWxWzc7TytVWQOSAiuu/d9c7V2i7OqGD2P7oVQsaqcQn64RahH81SJRioHaGuuUfURSnRe/Qc9sPVCmIb5yEcZDpC92qA4+evnNz/dJhi51NpYujc8cI7OwGiuwNyZfctDeJ4vWRvvYvgbHqxEEosqnjtPYUBIVg/aDGc/A7Cy1A3GPE8PzycreyhuKT+5j9ZJWafxdewxIKyWho6nf6AG/r1/I/PzmpHbfppHq5smlLaMG4UhLj//bI4Jm+SvIY2SxALMpcM9nrtr1K/g/1h/GV9BVd/SG8ws6AMnOSpcxtEbJb0UAp+dbsdxZWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  5 Jul 2026 08:55:51 -0700 SJ Park <sj@kernel.org> wrote:

> Note that the patch for providing the validation from
> damon_set_regions() is separately posted as a hotfix [1] but not yet
> picked into mm.git as of this writing.
> 
> [1] https://lore.kernel.org/20260630035221.146458-1-sj@kernel.org

Actually this was included in mm-hotfixes-unstable on July 1(?)

