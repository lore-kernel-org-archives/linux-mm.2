Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D68606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGEJjeoH
Received: by kanga.kvack.org (Postfix)
	id 619486B05B0; Wed, 18 Nov 2026 07:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA126B05B1; Wed, 18 Nov 2026 07:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BBA66B05B3; Wed, 18 Nov 2026 07:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB096B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:26:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C26A160731
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:26:04 +0000 (UTC)
X-FDA: 85448161848.20.10363FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EF39E40006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:26:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGEJjeoH;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795004763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AqeN0M33Tu74PsxiXUzK3ZXWPpnVIcOQcPutPsP0EE=;
	b=mTLHdwdJP6VhXo7E8imIZjf1rWrPQpkUT0tshRlOoYMlTmd9rUWZGtuxgUkijyRR9g4znh
	+NEkK0hRHQmqgkqUnfPwOUlR2+do0xc7oHsG8GyweUr/Q1ENec9TZuf8rzVN2wU1gAucjo
	c72RkXmyV+PhBucAPpcATnDsh/kUEtA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795004763;
	b=EIwwW2RgMWeRvFYNvy99hpqKEfTRlRrrezZwYlYmtTP2HQsrIydA9ZXWULIJJAnAMOobQe
	zIunHGaKx04ugDViV4LQISxMqIp0+YqMjV26L6dcu3xWPE6tzPIVrPvXSXV3s8M2FZUT72
	8muS15oQFVhHyU76DU2UznhtrxK35Tg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGEJjeoH;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76764620A5;
	Wed, 18 Nov 2026 12:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4801F000C4;
	Wed, 18 Nov 2026 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795004762;
	bh=1AqeN0M33Tu74PsxiXUzK3ZXWPpnVIcOQcPutPsP0EE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fGEJjeoH7ThK5cRxOIXKZPJJmrnFKqGHTZyuP5od2uJ32grmkYyfwDJ8tI7YhVHEQ
	 savzOKmvPii9oiAiSFb5doU6fXs651q+NEfkgALqX6Gu+fcxDCllrJjTaSKI+FLRmf
	 4XFXitmIycldLs67nQcaC8VlC3TlKva/TUnSE76uDqeZ0ncCCLNcoXmP19BQGULBVT
	 nebQIfTy5Ey0CV8WG4vj+YANaZ+Ot3HuP116ixcZOnYNF4ciA/qqu37pPBED8KfGyc
	 TM8zRkHTnBMIz+KZr/17L0BPjGAGdKATajcAsmlKFJDmLA1MQBhbiY/PL8347blUs0
	 fYIj44xqtCW/A==
Date: Wed, 18 Nov 2026 12:25:55 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: use memory barriers for non PMD-sized folios to
 sync
Message-ID: <av2Y7v-PQ0vVZLSP@gremlin>
References: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
 <c254a38b-d5e5-40d0-8d70-c6baa850cf2a@kernel.org>
 <430c6b67-76a2-4f67-abb6-e28d07a84bd4@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <430c6b67-76a2-4f67-abb6-e28d07a84bd4@linux.alibaba.com>
X-Stat-Signature: jy86hrodeyn5dw1kaihd9pzbi1we9izm
X-Rspam-User: 
X-Rspamd-Queue-Id: EF39E40006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795004762-527814
X-HE-Meta: U2FsdGVkX1+Uecgp/8DrCcffDdLS0LNNxNOTqzoY3FvNvjaI1NlRPVwcD/85+bn765pDozX/Bl79NG6DzUNkQMTgrtuKHh1tXeUivIJeccUoIljrGjplLKPfwrN7XD6/zoO47nhtI3+stS/UcFGmp1Yr/UGYvwvLvT1aEi3XKQsgheo2tGiVDxKx7OC/zMV+eJYgrnEUvMseyVzIp+73DBYBp13OjBMzzwK5cr1b+fYdr+jvOfJlnh3iGYjwgptFKwh79WYPyoDgrenx6cpxWxV4Ycd7pHONVFv+OwR9SYWidgbNf/1O6j7hECZYC0drPw6k1F9zZZykb9i8Vcf3wVlv2FDPjqItRIg/WLngakLrgIKiUcMN64D7P3cEyRdvlQtxSVve9+ELXWhb+ii0oGne4V89jShhQm+ir+LND482NX1A3CcoYJ8UjDPgqdd6nV5X8Y9lfjXbX5NScTxhaC0VadsP2+B1FexPByTMF9GsU+jOwGe4Dvj2f0TG6PAKwvgjHbUHxPgYTc5BaObBU3pWnEKOFbrwlU/B7BOyqq+HoLr/hCPQYbJv1MtrQUe60WPfXdyYSVNfJvBjG+nSid8Cv3aweoUs31g00rjVMDxKMAg9aMYsjd8fmHCcn7+r/BNdes0KBnWP+2pccIeRW39gqwNMGCtP/WSp/2fgAGcperFmUwf7Zu99aRN3oKgZNK4nKEem0LFgraPO8sY5rhRNqCJorg0SEa7EzmSviubVF0a14XvQoGQKR+DW2blH52NKa07o88G5iu4lKB2f1zQyBmHWWh5/CsR9p/gmXpq6cJ6Fp7vuo6Ci22U3moLA/HdbCZ+Ryzk6WWHttXnN9RdYkLLsqqTBeKKEX2iOF1QSyqxJ2z80Q6luWZTchreWuduGLmYaA35WIRvrD+Ii65lvPSmGeQh2EYGxoSVgKrjrj1nEsHapryofytha2xDleFIsRN5QaWTfbPSJqlR
 6NVvBEG5
 dIxcvQ3heSE41eFQcSj0bYEZGuBFAmPiHuhn0PUkjOPac6r9EXpw/RNQ3DMWbgfrQTOG7xqz0n52AvI1BS4qwUxHVvg2AvKGSp7CeazVqRI5DJskgWiRkuOQd5PWcc8dH3D6SYWR1Fy+mEQEnaF4hWj0CUAtwx9r0UHUCszcsiCtXcPnCEn8zY/UiZ6hN+5iKS/hzWBt+Wr7/qStGO0fqWWA37Ad9U7o1j8HyEtVqRMxoFI9S+vZSfbp8FurghlmvGY/D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 02:19:56PM +0800, Baolin Wang wrote:
> > Do we have any way to measure the benefit of this? I think we'll need that to
> > convince reviewers (like Lorenzo :) )
>
> As I replied to Lorenzo, I will try, though it is hard to measure the
> performance for this uncommon race case.

I mean it's not a race unless you stop taking the PMD lock (I think the commit
message has to be a lot clearer about that), and I'm not really happy to move
from easy-to-reason-about PMD lock to hard-to-reason-about and fragile memory
barriers unless we have a _really_ good reason.

I'd say given what you've said that we don't have a really good reason :)

--
Cheers, Lorenzo

