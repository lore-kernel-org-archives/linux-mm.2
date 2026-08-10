Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D98C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B76E6B008C; Mon, 10 Aug 2026 14:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167606B0092; Mon, 10 Aug 2026 14:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D236B0093; Mon, 10 Aug 2026 14:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDF506B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:16:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63702160241
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:16:42 +0000 (UTC)
X-FDA: 85086165444.22.2C0DC5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB3C7A001A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:16:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aWJd7o70;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786385800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9v3XCGMAYCML1J+iBIiEolvMLJwBNI7ascubHjizwg=;
	b=KPnsrw2QHRtkdItj+THxnuQFh3IIpUL6ypiVklIyv2tRexTdTiMawX1ESojY+WphB7Jdmk
	a9rEbbVhQzv9fpf5DKzKghtaIwhzZUX3f5WxDRiccREBvNVgSpf6xGchinQaaobQc5cV0b
	5ZLatVkeMiUtIMWXq0gzTEdPaTZm7Tk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786385800;
	b=YtPEWF+4/bE4C4JXxlndILsEXrKHfF6qtXS41HHe3FdioSrTFAJPrpyjTl8NkyVtZNIW6g
	AaDriKx0fsSyeIP7HROt4gx4RDUqKkpn7PlDes2KTjfVHb7M8ZhtflzxNd1c0gq+/WsG1i
	kXHyweGkvNeEfg933rouiV0xNXQ1jTM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aWJd7o70;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 196B2600AD;
	Mon, 10 Aug 2026 18:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFAB1F000E9;
	Mon, 10 Aug 2026 18:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786385799;
	bh=l9v3XCGMAYCML1J+iBIiEolvMLJwBNI7ascubHjizwg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aWJd7o7043rJu1KiN6o4YCzJmTqPhi9QwvUI4mXf1iewvADqQILiNN7cnAqQaytIP
	 qz0UK+mbd55Y82TfU3W7VqJ4qtB6+y7RqNnCGjTG53vN2sOJtjBCUEIKebqhI+X9Uo
	 dWeIievZoi+OyI2ocPZ0btGhlzeWVipXPGcavxkc=
Date: Mon, 10 Aug 2026 11:16:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, david@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-Id: <20260810111638.a74d094a8a198e84bb6fa5cb@linux-foundation.org>
In-Reply-To: <annzcER_eGeBq_pY@lucifer>
References: <anmdrYGVqM-U4vlo@v4bel>
	<anmrTaWp2etxX7Fd@lucifer>
	<annzORC0NgSIsX39@v4bel>
	<annzcER_eGeBq_pY@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB3C7A001A
X-Stat-Signature: 55n7uohjh4si7kzyo7kko4mj1xdzqf8z
X-HE-Tag: 1786385800-899164
X-HE-Meta: U2FsdGVkX18/UzX6ofQNhFMgXbam9jAiyNSqbWQV4bdg9po4Qu3no4em2KvOhgu4GHkcc2Ag5Z/z5rjUXvSZSyZc9/0LVA4Ge3rtCSuB3j1IB4Y4TBz74x/h21Nydq+OZwJKDTrMl1874p4N/rhvnFotqNDuJq3VS74HzvzJRYa5kJoIoUfjMnAZR9wm8yW5Qyt2OQ3P1rVZO8aUaujvOhhD4MGmnSWTu0pIz2SIRhcyuVA1flT/4Ya5g+OcF9Kc3o7DZ5c+u07Wd3DHUgrQ2M8xJWKTOmiu3KL8owi5in3YD2hOPPtc+W+xh4SKNot4iIiLtAbhraYrSrv9g8pbz6NM3pCXEVoyI9t4nTtiBo+dNUKnnmCnHd1G9G6ERqSP85uIxZwV+pyqLmJp2m7BDBVCKLB17A8JRL69ulW7XNeMM3FumjcZmIbFUM5nxRqIsLw+zTZK7Cf749xWefCGU35jajyLv5NfQqbpdDyWcPBblDeVkQOAo+zfYnyLGgIvhw4ak+ZOco8FawBblUKomQPAR0MKzeYuzcLBt2Ni5hF+3lw5iotsLJa9PlVaXNfjUbvA2s62fD4Ry0Zkjk3xZ+Gm03SGEOA9kaOGoH7r9p267/LfJPzHkyXuAP1pWh38dVixnLj/btaaEoz2OosQeJe4Dm4ISxSrw6VEBuvUBotusnpZ7LMzmx+BIybdrDPOmkK9DlMFA+R9fMuDH0fmoeEC6sOzx7SVt7d9HWUEkzBT/VE2h+HZWaJwIuQr8zbNmxXjnshNM3QyNWNnYaFHBuVC40EK6OVvcFs+/vw2YWCAHhY6m2r2n/ZEk5Bc1tJxuDq8l5lTyaKAhvCkzN4TGiLj48OhyjQpm/Pd24mL9B9B1Pw2F02GnEXxgdtCN9jdZq+6Z8AUyFTpBOxJ5EuVsyIc7A+qzkkJvJl0JNLIq20bDlH23+cHd0ezeKSYt0WOAZmOJV6R7Tkvspp1dkk
 exD8tcwE
 YotbhN8Ejnc861tTCpY8E2UlnQ/AfF+8dIch029otgbYL30DM8RYQCXqb6MLmQlUHyx6fnATgDmoJk3e5CaWzHf2/wW1/blr/BLRsWTxeG4SXFCSP4IAAZvHysuHrbatH9K/7E9m1MBm0UddY48yQSMr9fzCUgiNQpL4qoqLnNhhmbj4BU0QliPn5AEgPneSNV3mJjNjAwh44cL8szxIoI7HuITHH4KApp4JkufgFaBb0Wy/z+02bTohiByHVEELbSIqqaicDF37pI5yTO2VzzTinYWDvsn1+kH2TGqa+3Ok2TRyLmgWsGvWx5cjf33AAYuvY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 16:55:25 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> > The commit message was written with help from the lovely Claude. Not the
> > most readable, admittedly :)
> 
> Yeah I did wonder :)
> 
> I'm totally fine with using an LLM to help with language, especially if English
> is not your primary language, but obviously it can go... wrong :)

yup.  Changelogs from Asian developers have become a lot easier to read
in recent times.  But please always carefully review the resulting
output.

> So will always feedback if the commit message is unclear.
> 
> LLMs seem to have a habit of constructing word salads that end up effectively
> like 'the code in English' which ends up confusing more than helping.

I wonder if it would help to put the initial changelog text through the
LLM, but don't show it any code.

> Key thing is keeping things as short and clear as possible.

I pasted the original changelog into Gemini asking "make this shorter"
and got

Issue

  walk_pmd_range() only resets walk->action after the pmd_none()
  check.  For a walker without ->install_pte, a pmd_none() branch jumps
  to the next entry before resetting walk->action.  If ACTION_AGAIN is
  set and the entry becomes none, the loop can return 0 while leaving
  ACTION_AGAIN active.

  Since commit 3b89863c3fa4, walk_pud_range() reads this leaked
  ACTION_AGAIN status and rewalks the PMD range.  Because callbacks
  like ->pmd_entry() and ->pte_hole() have already processed the range
  once, re-executing them advances walk->private beyond the allocated
  buffer, causing an unprivileged out-of-bounds write (e.g., via
  mincore(2)).

Fix

  Move the walk->action = ACTION_SUBTREE reset to the top of the loop
  body in walk_pmd_range().  Apply the same update to walk_pud_range()
  and walk_p4d_range() to maintain code consistency.

Which is at least shorter ;)


We have a description of the userspace-visible runtime effects of the
bug, which is good, especially with cc:stable fixes.  If there's a bug
report or a backtrace to Link: to then please do that.


