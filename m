Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5552AC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 21:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91036B0088; Wed, 29 Jul 2026 17:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41F26B008A; Wed, 29 Jul 2026 17:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C7B6B008C; Wed, 29 Jul 2026 17:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE6C6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:58:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 013021C0E1A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:58:22 +0000 (UTC)
X-FDA: 85043178486.14.E86D3FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F177E80004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:58:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SCqlr3f1;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785362301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udGod0mFQ+zEVrBybqMffBztaEdiXoDsF3QX+rBfc5k=;
	b=c6NccBD1dkLslullGsCYnbAICbo+oD4IC0TzE7RZVW9EqiOp3nNdoqbk9nZrLNWoNQO8+1
	alQYK16h9gZJor8zOuk7bQkXhi2K6J/WbqHi4axfaz1f3A/MhdM+AAUMiJ4eRTlPBOtA4m
	aCvpbHHS/54IRk3pR2CCXRj6FpwqChA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785362301;
	b=MCBWaq6vbB5IrDBymUGJsaAJEvyfBBYnIGEPTVFR+/9V6KddElyhqYvm20qdGTo7th5gUz
	xSBSY0U6r5D+cb7VWZB0U9OQ6LMmSBLN5N6wOU73Tebu5p8gfaopBpRMl5tMh01aySjbnN
	ciynsITA0CjB0oiOEbMMRvuTbNxH0RA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SCqlr3f1;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 013BB600AA;
	Wed, 29 Jul 2026 21:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A391F000E9;
	Wed, 29 Jul 2026 21:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785362299;
	bh=udGod0mFQ+zEVrBybqMffBztaEdiXoDsF3QX+rBfc5k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SCqlr3f1wNRHkLOuv1HecQ44XtVEO+6X15YRRebwA+dQvJ18Sfkfj7nP5OdXOGaVm
	 GXRrN7Nctei5FVzt3ch5aI12VVOU7E10SLw6T2CTYFSL/eScySAxP79fiarmqFXYbf
	 hKAh524nOYtHndkZ2r8Qen6oeVEfXJ7p0UZ/l+6M=
Date: Wed, 29 Jul 2026 14:58:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhiling Zou <zhilinz@nebusec.ai>
Cc: linux-mm@kvack.org, baolin.wang@linux.alibaba.com, hughd@google.com,
 vega@nebusec.ai
Subject: Re: [PATCH v2 1/1] mm: shmem: reject page-aligned fallocate end
 overflow
Message-Id: <20260729145819.dfa35a91cd3d04b8f401d43a@linux-foundation.org>
In-Reply-To: <87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai>
References: <87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tc9kg8o5b63xdps7h1gqta91799suuwa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F177E80004
X-HE-Tag: 1785362300-210213
X-HE-Meta: U2FsdGVkX18ZODSFdbGRxUleo15LvlNd2hffv8Ft48vI08+nMNfGyPtJSuk4pMPkhqb4Ea3f496Zlb8/sYzdQHm9Nau2Pw2D8xR535wQRMJOwHqZAcF41oGJxMPHevwnrL2AqOUf5gHjANqn1ewFSkc/JmltCAQceOpFL/buQN271w7asYXPALBfFfV4HQTKSZNVepFQbVM1WENPorFBFSlKxgaNQPPiQu6bRIJCogIiBR/taGE0GdXhBn49M4UU8TwazA/rNlwwx5maqUfG0PWB+kqygNYH7Bh81Z+orRwTbL4bxL7UgZShTlxEEphNp3jvOondvutl0VIsUJKH1/EwNAACXK4mROvduIClxeSLOhAsTmRq368rgN5FHyInUKvXUbjujyMfoZgccxDncVLRSJYs9lsFYy7UYIvKD0mF5Oe5OWdxn3nAQMVdyYTobEoCCleiV/UM6lVff4O1Uo3/RBAmU6ykJNSoqDk7L8pCE18iUFsK7JpF7zL4erx0Wgk12dajpaTqWM/6cxxRFoNlL9kG4Xe6KOXy9xFJP62iBsgiVWB7TraXGaIQwowoGBYzINpAgeO2WpmiwSJRKmCRP2gxwLDbUP8shPIF/CsJDUGg2O4IPj8DaiaNluYycQWO8JRGh90khLPIBxEGiaz399AQCai9nOjQ+DbdNtEqOBhyJ3TTxv2f0AQ7JehtipeuTRGk4SBso8mWJGyFxYAxTbsMnU3gMaPhSMiE5EEh6xnKp0NisL4F5okFvFhcbzznjz41ab/Puh4KZBzQQTLqXcf4g0qgESMCvX78PEmu+GWpkp9aR40o2ItW87uiC3YfQi15E5jIU1eHAvUUlZYTZpZBLFm45noHu3xYPjeW4uOIXTF6QaS3MfxN0uo9aC2ITjhWJsbHk69WsgkAl8p4aN6n5T8DrjS5X8p91ylMnJFamhffbyH8IjYe7UVSLesEop4+lPp8ugz32X6
 NQmamYpW
 ypMIsUn3aabLty8hVQ3NIad9pGeWFr/k0w0fh7Ox1u1JzoNZXTGcvQYmXCjHTiPMZ5DjwBjSky0JB/opiIaQH6Po8ufPXiowZkjDWj78EEHSijgRW7C1n3/W1FV6mMAaNZQ39ysxSj1EluTpMuFzH4OpOmfMqBIOOywKBZnaK7mUaU7jUpHHHkhusYVExY6bzrOqL6uE/D3hs7+7WiQhswHF16v/yT1K4ze1Anq45bVLUo6nW8KM2pDlqzDCtndezjSJoj2paNcGhM3FtlCPWBZ9LBKz7lHuvuTG1VZU83yBN7pdKi40euuQx1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 22:07:30 +0800 Zhiling Zou <zhilinz@nebusec.ai> wrote:

> shmem_fallocate() validates offset + len with inode_newsize_ok(), but
> then rounds that end offset up to a page boundary before entering the
> preallocation loop.
> 
> For a valid request ending at MAX_LFS_FILESIZE, such as offset = 0 and
> len = LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overflow
> the signed loff_t used for the rounded end calculation. If that wrapped
> value is then converted into a page index, shmem_fallocate() can enter
> the folio allocation loop with an invalid range.
> 
> Cache the already validated end position, use check_add_overflow() when
> rounding it up to a page-aligned byte offset, and reuse the cached end
> for the later seal, shmem_get_folio(), and i_size checks.

Thanks.

AI review:
	https://sashiko.dev/#/patchset/87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai

Suggests there's a flaw in your change.  And it does appear to have
found a significant pre-existing bug in there.  Can you please take a
look?


