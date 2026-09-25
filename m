Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC815C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B9E6B008A; Fri, 25 Sep 2026 00:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E176B0093; Fri, 25 Sep 2026 00:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BBE6B0095; Fri, 25 Sep 2026 00:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB71B6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:48:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43C0212052F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:48:15 +0000 (UTC)
X-FDA: 85251052950.06.8481764
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 793341C0007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:48:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mBbJ0AG8;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790311693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAbfPfUo1z2sF6AlMVME2ig0vFfsexu9oO7eGK/q4T0=;
	b=USvsnCBCjc66DLbJPBZwY3CDeAFIdfUZWt4nLLkk+KPO0Wo5tCgp7SMdGJkPdl3Fv7YnCE
	NwHvR1oXFXnP7QmNrMItTfwdORLVVqyUwc1SGa5TZHE7dGgqe5E350UujWKMIpgSyMY73r
	/C0LKE5MtPuDBDaN5lpWeq6vVjDEAFI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mBbJ0AG8;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790311693;
	b=SFoskmwPJzlSdNC+JVaeJk7QX0dUH4DQ2bgF2e9KRb00maH358cezvF7PgQtDi++hZuli7
	RmnrNKk4fCq3dy03BCnsg3FoHt/AjwiCbDBOhaKtSBGEAioMuUBXW5oBp5JiRqS6prhHyq
	NbXhG31mEWfK5wE8TerzJTkWSpY5qtQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9D216022E;
	Fri, 25 Sep 2026 04:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139BB1F000FF;
	Fri, 25 Sep 2026 04:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790311692;
	bh=EAbfPfUo1z2sF6AlMVME2ig0vFfsexu9oO7eGK/q4T0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mBbJ0AG85Go83iWFJVKJrU87L9CaAbCtMGm6NjiNKpqM7xtTKxKZvef54DAST8hdY
	 +qge4H+e+pCaCp35Z1lQNebvY2P1qqK32vopKcRR0ex2koXo/Ox5iw650cODpaRjLs
	 Dx4kTv+n0Xgy11j7vQIgkcBlXm0McLH6kDK8NYwc=
Date: Thu, 24 Sep 2026 21:48:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: rppt@kernel.org, peterx@redhat.com, surenb@google.com,
 aarcange@redhat.com, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, mhocko@suse.com, shuah@kernel.org, kirill@shutemov.name,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-Id: <20260924214811.19ef8af417d37071ed8338c4@linux-foundation.org>
In-Reply-To: <20260925042907.2330519-2-donggeunyoo.kernel@gmail.com>
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
	<20260925042907.2330519-2-donggeunyoo.kernel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nygu87yqbiy9rcko9bda399q3xntxi3d
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 793341C0007
X-HE-Tag: 1790311693-472215
X-HE-Meta: U2FsdGVkX18IXijJKwaXNAdPWbo1McTbc9OFOmUnUmXFf44Hb3CjpCpmfwd2wToFE9K1tYaRI4mv/WxZ1j4GTY7fVEjolLl8S3dPmTwyYzbHaAdg0pj90GAQCp3kEDoP43HYx6lNqubfcLtKWQrRkXFGlzlMIPWY059gaonrCoRAD8+r6AekJhnNKxA/B6HOxvc+qTIQlWw/UpbSXHrIVpKDUV16gOUHQRqXZT/9IkHXpwS0LSmgFFFyFo2eMgbzkypcc7ygkbHBrJ8Yi+ZZF5Tv6uQR13TV3VTMQOfTQ69Cbyrk3NdmoGg+AwysgKZY8gIKW9apyiV5GQ2vYWZTERmXr+7lpUB9gTPsfk87JVHl2N9gU5h+xvSvDEtzRKj+sbP8t4FHctRGORuHAlsmpk6sitUENV7dNwSld/2T0mnOgv+m4jjf76rFAUHOoxuLOjrmcw5jrHxujTF7meRiCE2dwRJGzP//qCbJoi+LjG04VN/V22w5MehuMAJMl6rIojpCEfYd2n5/Qvo6qs6dunanmGo+eV6vUqufdPI5fjFZ8SAikDWRVSHGQfCY43DQFXUkXOIPNgE62Il7eqjt1EZr1JaTYewhbaAwfp0rpbOpfWsfkFb+q/82lc2DlpQO8KKTbn3xD9xBAlToYACg5YxMLtJ3fuDa0fKCDDBne7TyfA16WWu2vkgJv5Bzl/M9Kti1jDk3rd0vhTRPY/g0QfKIE8XTOZ/QhgkYOjE/SjIQpODZqg98b5uFbQ87nNydaOri3BmdlxT7+AgUk2GXKJ3t5k+ASGWSEoAYzZYvYtuqVHpLHg+zqfENElvcvY24rEZTLXjCKddJqnThRFgRbaMV2u3fxm92JZbPs9Q7eJpcSZNsoUr/TT3k87YL6VlfjNf4WtzXcv6X8ThxYzJDIAgbwwmIjFxVJ3j4zIz1amgWwV13py1Tj5sQjqgn84nhJHdx3mU7qKGQ6y5pFRb
 TJkyXSlR
 w0JXC/WgX1xUErFnXp3Pu4FscuQAz16RcWU+sjEIYuiMR/DWdC4XfHuITVcnM1Cf+d577ckaLjroLBgVKARaGPD7K4oLKCn7K2S7UIaFXKDqkOHtuK5MZDbh4PYWl3aJHQulWbX7WO2MPFW9piTZ9eJjXsUWk4DeAO6HLswN4nEXyCMTOkZm6oVsRHAZJHPQ0FbnTaGwJOFAr0IqKjJVKl+jKtjm5fi4K8H1S/D4240EDEMtmrUArrGNAMmocN8J8lcGHfyBB5YSrjG9Zp5cY8sinWUGbMPB3mBNPHZyR9AnS3FJlnXop9AWLJuHzndSSHz7Zk458Vqlo8iPeMTKZdBilNW/h+0DfXLxObbQDkA5w86NmkYM7cZNFbkMMxL9AMgNW+tnJQRsZ9WJp9cpWAuCm/dAfSD0KBT16
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 13:29:06 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> destination unchanged, so a uffd bit set on the source lands in a
> destination VMA that was never registered for write protection.  It
> can't be unset there, and THP collapse can't happen either, because a
> swap entry with the uffd bit set makes the scan bail.
> 
> I don't think it's intentional because for an unswapped page the bit
> doesn't come along, and I don't see why being swapped out should change
> that.
> 
> Clear the uffd bit on the moved swap entry unless the destination is
> RWP-registered.

Thanks, but...

When fixing a bug, please always fully describe the userspace-visible
effects of that bug.

> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Cc: <stable@vger.kernel.org>

Especially when proposing a backport.

Please review the first half-page of
Documentation/process/stable-kernel-rules.rst

I don't mean "be reluctant to backport".  I mean "when proposing a
backport, explain *why*".

> Assisted-by: LLM

Great!  Please add a prompt to LLM's .md ensuring that future
changelogs always provide this information.  Please also share that
update with the rest of your organization.


