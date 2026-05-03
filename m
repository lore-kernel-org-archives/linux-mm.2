Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FBFCD3427
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B376C6B008A; Sun,  3 May 2026 12:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1C06B008C; Sun,  3 May 2026 12:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961316B0092; Sun,  3 May 2026 12:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85AC16B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:50:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31451140731
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:50:57 +0000 (UTC)
X-FDA: 84726698154.29.7E0009E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52650C0002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:50:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="md/ZoUqo";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3dr/aluIhzrZfKQZgqV4jwVqPfflMD76C17a6ZDnWw=;
	b=qHWGqLXNKbxsjxIhVU5wD8y8WpiY5RkxOECU5Ho+tsQsRdz2NtNqiYWH6itAyWTpwoCSMI
	DV50EmhbZUZZos3Tn/8YsxuxVScfVOhDD4jXgqTNb+65D1NtGaypn7MVizaSZuWL9cd3FD
	pyZnky9r/aAPsh+L/HfplBi3WF0FCfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827055; a=rsa-sha256;
	cv=none;
	b=FoWZ0MBwopa9SNmlmc4OCknoI4hzlvbCktNeFRBX1EKjvrzQje+12+9JmzbWyXGEEXcCcC
	GJWCRCM18w4/+q90pglLi64IENvbF3qvHbLn/AScPJGRrnPcV5tLhkC9pHbmbEGPPc34tW
	KoF4pjwoHJnBn30QMVnrZfmkAoKxFZE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="md/ZoUqo";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F4A560126;
	Sun,  3 May 2026 16:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88791C4AF09;
	Sun,  3 May 2026 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777827054;
	bh=EPRQ0sFL/SE3E0eBlsxQttfyPlmnVNf1y/IfVs8UtKY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=md/ZoUqoMuej1otNTGLYmdLdumoERQF8bZmktgIKPr0kNELfPrntIvfJ5CFXXO+Ql
	 6OX3z3vBLZfFcxLfo3UUroNo9ByGRnUfst5ej1suJPhH9IDOAyZMEb4ap3wpzmtfM0
	 1wAL2wKk6oCKVGCjgl+KVviSnIWQSNIfVGy2rlQI=
Date: Sun, 3 May 2026 09:50:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fujunjie <fujunjie1@qq.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 sj@kernel.org
Subject: Re: [PATCH v2] mm/madvise: reject invalid process_madvise() advice
 for zero-length vectors
Message-Id: <20260503095050.93736c201548e71d7d0f4210@linux-foundation.org>
In-Reply-To: <tencent_C18B14AEB4E720C5E2F9500FB9118E1B5607@qq.com>
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
	<tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
	<afBNyNJiWEAUSf1i@lucifer>
	<tencent_C18B14AEB4E720C5E2F9500FB9118E1B5607@qq.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52650C0002
X-Stat-Signature: kujaq5thpm794igmz9h9jbodqfjauk7w
X-Rspam-User: 
X-HE-Tag: 1777827055-20213
X-HE-Meta: U2FsdGVkX1/j4ZauVJ9kVRVUiBOrESixPdFeh1a2snXAgpaFcylJEuxUIWdIHLFUnUKVBLT4PgJp72ffRO8wTll3kdiew7wBuiGryBUO3IF9nLHIY+dIqJZdES8H2PCs6clI4YInb40dVxa5yThmzIZ9YCR53NQ8cMMlrRB09Yef8MWCwdVkXvtEU90MNAbDO8Nqcs/q9+7PTs4td9SuupaBNW59ksBockePFiGeWOxG17bDBAwgCvF6Z6RPswHLWlLvLu7FYX7DbBf6dHzoHYEIrjIABzf/MqrhfXjzFLwdNWyu0H2+2z2GrLDUtoE+R3JB9uTj0tF7YSS1oJCV0lIbCPZCoNgwgyaS8qPCpq56rruforKXdaxKtgMpg7xoD62Db1zTOWE6NzEfam5V1q7L/2Y1JgLVk2KBv//CT8FByF7OSnA/mNXDkx5+e/dUyc/gaa3nS1eTFp2OTjXT3Ui1ijCIZLlL+vDCU7t1oLKVrgp7k85avFTsziAQJiip2qUbYEZCcsGzwNzs2GxmJQak9Lz4ozm5uAYg+q+mLitIoX9wx5xnk/DySUURMiNL6DEN4PevauQ+eITyA+sN1v1VgWdLJ67QdxE8qiOwAU1FHVNTVxFqujRs7Q+VYhKlTV8o0oPuXrEic0EdzLw/yjvHSk4tNSbSHM/QcmvCinn0GYLtmossASWBNEmgkxvuVsCp3tBFr5sUvkfZANx1tSQEz8DE57Aa7006X86siQevNj5hG9v+nmotF88u8FlF6HiW8qf+P/iFyeT1jFGZ+CmQqa/EX9UrpWmNVvD16BQn4isOp/8P14rYipg63KH/bLAs5eVIvTyTCEB24kdlduA3xoxRCM5k62I1s9GKXhiFQDtArh3trvOUH0PezxESoLSqjFILCTf1MvF9WwDtvkcYa0Ivk770kJSqInEqSPrCvgjqxDXRRUkUSrfH+FFDgkpnJehiPmwWqTEiWnp
 DlYntcgc
 6IJTy2WFPh7vDa4KS8zAlnHPARWRIn289Qq/eS4q1ji/jg43P/6W3zXJheGQULOjcqE8R7sMfLeONpcPvYBjK+pWiNg7SbgOpEdjFzgkEhTAJ1X87ixoEdjA6TXR4Um3RGjj9DmvadPyG7BfIJgPtq+7PABjKk7TTbBRiNlLNkhxi0qDhgMbBnbc01pueiR5aHgCMv/xuTiOr4vBG51u2bePJcL5fZoTA0maRhySNyETy8AXvUYuEH0f7WxPAp9peMzRBrwV1eKGWWg0KCJgo/YI7sxN3n3CaireoZaNdvTijtGiYoGyLxGVdEJgdji8hSp3/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 4 May 2026 00:45:16 +0800 Fujunjie <fujunjie1@qq.com> wrote:

> >  		/*
> >  		 * An madvise operation is attempting to restart the syscall,
> >  		 * but we cannot proceed as it would not be correct to repeat
> > --
> > 2.54.0
> 
> Thanks, Lorenzo. That looks clearer to me too.
> 
> Since this is already in mm-unstable,

That's OK - it's called "unstable" for a reason!  Things come in,
things get removed, things get changed.  All the time.

> I'll wait for Andrew's preference.
> If a respin is needed, I'll fold this in together with SJ's comments.

Please prepare a v3 in the usual fashion.

