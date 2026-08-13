Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6286C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 01:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921506B018F; Wed, 12 Aug 2026 21:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2266B0190; Wed, 12 Aug 2026 21:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1946B0191; Wed, 12 Aug 2026 21:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA6E6B018F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:32:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BCCB1C051E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:32:10 +0000 (UTC)
X-FDA: 85094520420.06.B1E3101
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC8A5180005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:32:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kpvRz/Af";
	spf=pass (imf06.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786584728;
	b=t6oiLE4ptAyIAegG98dqxN9Rx/iP9fK7b/885F/sC9/WgRKynHO/fOyjFLttcHnrsp/vvY
	WL/EpnGDTFM3vQLf2o66GLHw0ITsHEsfJG9jpJFP/XvBfwWmoD/COe5a48qd+ySDvHkcAV
	wFtX/g7IS/WtriLvFA9EgRQWdaN54Lk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kpvRz/Af";
	spf=pass (imf06.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786584728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXGPeS+K5n9ANRKQROyif7rhZFKqbL7oazhgonaCR4k=;
	b=eK56Rsvw4+LLyVq17jbHDgQTWxvbN2X7kQslU1s5LYN4YygO4xWaGsSzfsZPA3qftT1wIa
	Sa5SUgkSQqnG+9s+/SXaltnzWfjQR/AnXmrK5tSf8BL61zlB00XE78Pi6L++JGLSlmackC
	NJOqnxuvGzOTWBgCIShvnHiTRKMng4A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D83760120;
	Thu, 13 Aug 2026 01:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42881F00A3A;
	Thu, 13 Aug 2026 01:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786584727;
	bh=KXGPeS+K5n9ANRKQROyif7rhZFKqbL7oazhgonaCR4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kpvRz/AfHtGn2iPU3AyVIFfiB/M69pQXYn42vtoqDoxLWckZ2QFDhBuwlgx2VBHI4
	 hEgLjvgcvMfjfLQyMG0PbKB/zXIU67HeYRgBZlN9lNLLTMt0ZmmVb8rGcrXwdI5zZW
	 wKsuwoVP1vCHBIWAfPKApU0PDMjYgajvAMsj7XHkGhVdBcSt8eupjFOoC6L2trLXce
	 Sv9YC71ocxOzRol9mdMknZXV+sN7J5/gyYTUk5YW5sK9OiWdmGHEMrpmt7zXYr3Mb1
	 zNa4lLUvUBidNOsjLLd9RnJmQ0yQjJL3aKuXVdiBLV8zKW/FLSOjvp9J8TTD+8fnyg
	 an9dq1rOzhDWg==
Date: Wed, 12 Aug 2026 18:32:03 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	stable@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] arch_numa: Avoid false positive fortify warning in
 setup_node_to_cpumask_map()
Message-ID: <20260813013203.GA3920328@ax162>
References: <20260811-arch_numa-avoid-fortify-warning-v1-1-59ce3e689f3a@kernel.org>
 <20260811224746.fdb85bcf47533e12d365b182@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811224746.fdb85bcf47533e12d365b182@linux-foundation.org>
X-Rspamd-Queue-Id: AC8A5180005
X-Rspam-User: 
X-Stat-Signature: y1wiib6xuxsqhqh91dst3oz9gw4h719n
X-Rspamd-Server: rspam06
X-HE-Tag: 1786584728-95970
X-HE-Meta: U2FsdGVkX1/JzI7/40uJm56z8ZTJOghqI1X7o7AxPy7e744uxtbmNsT7k3XTm45d4fXnbF7Xcrbk3ADOUAu205GkBLCRXzd18ttXd4ZRjDmbyW+7sIDcC2vDVNJGJ6XnRAZ6JMyJm+5rJGxjh17cc1Cp2NaoakYg+B3praw9rXysBSNokrzIqzo253oov89wQWgu3nQWPnBDYwR7nvnuVgfrWWtSpUmA+M9bdi0TgwiMo8rw3w8/aO6rmXY8G8Fs4PoCYM3DupwTFGC+INzVwGocmJYmvoQwFJ4L87iuFsenRRxYRvYoXGMctJI8QqeUVmHp+3SRTgcMj8BU0nrIDvNgdir6dSEbvsAcQu6nT5o0nxamMj8NDfHScOrrHH5utTvJP13OTf44zoc62aoKqwDx+dhhD+Mzdk40Owi+CNBEJ/ZlTzuw0VqImY5AIRx9jDup7CVUxQWiYOiZPOEJqFB73KyEPuSTZd24TzfOD+rurwSB5nMAPuKa9Pno/8LvNlXPEvidBUzaEX8Hdyc2bhPd7GB5aJokwWwXSTTnhoZEu6cZJUW5Plz38Rpru1BsU0bz++zBAdQQOPBtHgCV5fVGTdKO31cXsOvqtFJMMAL5k8GRnjRAzJclcV6QB52vVUyE3imetqSzIuYRAkSjRAJUAFDfnJHBHalMgyUiyL7fTkuZyUIRLyBbMVtideN7ishXV16fjmbJTKsTnZZdWRJ9mNWpEVd9MY6W0SSlJtGozrTkqavNvQzM0t5riHLs3+GFrSxscQiKYw4K313wRtzAvAiR2d2huC3QieDMHVaiScLBDSKpXR0o1zDgotvRU0R/H3J22ruUlvZIeZFAoz2HhOrYwYVRlljrL+TmFjyTDKkA9ccv3VfuZ1L4l8ClweGg1JumxUPkXVlQw94OfzkQ8BbQN1NnTw3ypaYrFvuBKlKdi6yxUMSRAkeONqItGswcor9vwW0qA3pTCUB
 TYgeIc9W
 vp/OKNyme/G1NMJj4fYgb34s312gkhKRtparLJWXo8IKT5Oc6iS5VBFskb8f6Oasa6Itt6OQ5rzpU8yFkS4K3lkkVCiQm0EkSwWL7GHGXEy44GQzPsvw9hDfzRuJlyd6kVeh6aNSLXStzY/RFUnzG2OodMXph33KIp8IkRMVzprec80I479j6nb4uekbMqgaE0XJgAQS/AhFvq6W8A6WDYe9DF6hNP9DIf5fRoCVcGG9/ZSp72ijjgRbxffhiGXyxbXBbQpF6+fSutUecbho3PDMw7r9h0tmB7lGOJgKF4xJprcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:47:46PM -0700, Andrew Morton wrote:
> (cc Kees)

Thanks, should have done that originally, I cc'd him on the original
issue.

> Sashiko wants a \n there.

Thanks, will send v2 with this tomorrow.

> Lord only knows why nr_node_ids is unsigned but MAX_NUMNODES is signed.

I can change the specifier for MAX_NUMNODES to unsigned as well (even if
it is technically signed due to the signed '1' literal in its
definition) since it should never be negative, up to you.

-- 
Cheers,
Nathan

