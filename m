Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30110C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 23:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A396B0093; Mon, 20 Jul 2026 19:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4126F6B0095; Mon, 20 Jul 2026 19:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303636B0096; Mon, 20 Jul 2026 19:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0308E6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:27:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C0C9A0369
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:27:25 +0000 (UTC)
X-FDA: 85010743650.23.DAC238D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B3B1140007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:27:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qrCaLyuh;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784590043;
	b=K6H8FUO4jH1ZiNV/3tVZvvjYmEL0GrxyB/yrNxe9hX5mKmqEyCTjiWFveNl3GmqmN8ruTl
	RcWcN2FTnVBFZrJsLrY9sWf4kqiEpUz8V+4PrRtZDwlvb4V0aAQf30vvzDcWd+/peePk+g
	2F4NH/zeDaNmpQyWqGkIKDjmiN+9/RE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qrCaLyuh;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784590043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0tMGbUKVmQ24ICOTjdeUvzTZMPaNn3f8k1KcJxmgMY=;
	b=szEe36UTWYJLO2Hbs56iQwpoFnpfglBeUDdSNu4CfmmM1LvoBhMASYf6VBsOqu/fH2Z3oI
	R62DUXjyE10m/qwcowqXaMXXWZFYv0j5CL985lXEEGmTnSeNB6J5sMVes8YiFdS2HGTyTH
	/Sd8swftKEoMwrCTEMNB39RsKerWOyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D98F434BE;
	Mon, 20 Jul 2026 23:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0AD1F000E9;
	Mon, 20 Jul 2026 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784590042;
	bh=q0tMGbUKVmQ24ICOTjdeUvzTZMPaNn3f8k1KcJxmgMY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qrCaLyuhWboXRKi0PgpTk6wTfiYmLQFUJV+K9TXPH09nAOEC2xvNOLFHQNjRHx+fO
	 X2/Sac+5rH4Ig2J9UI4EbvxFk2mM3jLekz4VEbcOy25cKFwzx7tKO+gEpGGMmFnJhH
	 b447HY0SqRPbDbX23HF8BP1woOZt8DEL+dAAuLFw=
Date: Mon, 20 Jul 2026 16:27:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Yichong Chen <chenyichong@uniontech.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Andrew Barry <abarry@cray.com>, David
 Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: fix subpool release race
Message-Id: <20260720162721.fd07cbcb5625c7ad38725a36@linux-foundation.org>
In-Reply-To: <20260720143130.516711-1-joshua.hahnjy@gmail.com>
References: <20260720085024.1392261-1-chenyichong@uniontech.com>
	<20260720143130.516711-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B3B1140007
X-Stat-Signature: a8oiju7fkfkjix37a3tbrdhd3ophjibo
X-Rspam-User: 
X-HE-Tag: 1784590043-910079
X-HE-Meta: U2FsdGVkX1/aR18U6TijbnZnmK5szSQoNWvYI6ljnWEhoSmRZf3ELMXzY/VFVdCsrdt7YuJ4l3xkTzK5JDlHyBrvVE4Wr1MCFsfCrF1ugS5wCOPfKLolgHTPVec8R1KuSDS/2kGOF+Hq0ehYZyoly9a2vPoDr8US7MSexdtvO1NHMuhOQHGf9Twf8tn9wHI3XefmGuRyN78mZTR77/sbrr67A9tP6pybH4E/Fm7Xoxk/ivTnkBLfKMKEok7igK8miJ76JnOK2qToka6sNeEI3dk9R9KlEnSpJFVZ+c66ygBVNLNpYnTN+sUH0DSLOcgKAnczY+pvG5DR5wP0vzLgQ9ppo+rKp6Tg34jmRkpxYm1SOuG3Wlg/Gl4Ev4WDVOXN6s3b8isqf3ZsWcc6gq3r9cd7PbtrvxKwGEV+hanAp0xIKT5ZqEx0gpUNHxv6qQGY2XJCTsHsvBLDfFKxZoG7kG4Ud3hgm8SDpI4ODWcX3bD4T1ZMADc+vk7AuUfyhek9ket7k5Twi9qbbZkFo0Jrr5RDQ8lwaED8XPkNYdVRAB/vQ0HSmUj5RCJfu08nA4BXXi/6bDx44SCQYec3z3p3wUlqp4sh0SyTaJxbp5fDDoe0suOTgdkOwggQwIT4We43fPjpskD5OiSZLsd2pdHe0gNXky8wtJmk3GfUg15MnyrZ9CNKplIG/2z3ccU5qDKLubxInGNNk2Xh8z2QeOOk0XgZd43pAdTGYCZNg5mEnathDCi06Bl0NiwaqBxGbOP6k8a80+OXNsLCaa7QxrgLDpFJazMPurzzcQpdkO/oHPK9zkWS8J+Lha3g46HcNFYHvJau/aQBmjfR2QsPyCwAL44fWKkZXU/82aL7wujyP1LMcynuRGPgbQgc37m8NH7VXRSH6YOoAhhBUAKmL0/Swi7MMXFumSGutLNqw2lAWoTixCo1GrPyIwqDXB5fn0zQW/uTQ16LxuFl+ZN30jQ
 DkSyroNU
 X0fhoHsal4NC/rti/Zvz1Xl5vdHpU5QBa/i1yBAu6JuNy5VP2sJ24W/MN9+9ny6q2fQR2lYeGYuvDSAXdo9koCKYJBuhnurvcw2VN7McxxvvBxVNpoefnwKhVnBhKLRuTo0/p1dBufdeEKfwhUDyXST2+wk8fFT7RNRwv6hAsaVofL3dB7ACLOvmUPXRyRFGami5EbGv1hoXX6Z7IuPoOd0h/hrRJ7bACAqEY+ufpsPT/tAvragWJG0Vdc+5aCBvkqaiptKqR6LUn91NmyUBd5Bsv+9+wYHLWrN+xkgI59ynU7Z0pUcM8Zy/ANfg2FAPfImWvzKSeNuCXS5cEEQMkpeaJhsNOBuXcBFlO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 07:31:29 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Hello Yichong, thank you for the patch!
> 
> > unlock_or_release_subpool() drops spool->lock before checking whether the
> > subpool can be freed.  However, subpool_is_free() reads fields that are
> > updated under spool->lock, including count, used_hpages and rsv_hpages.
> > 
> > Another thread can update those fields before the first thread evaluates
> > subpool_is_free(), allowing both threads to observe the final freeable
> > state and release the subpool.
> 
> I don't think that the race you are mentioning can be hit in practice (i.e.
> there is no user-visible change for this) since two threads cannot actually
> observe the freeable state at the same time.
> 
> subpool_is_free() does an early exit on spool->count so it will never reach
> the inside if block and have two threads try to decrement the
> spool->hstate and free the spool twice. I'm wondering if we need the Fixes
> tag in this case.
> 
> I do think that this is not obvious though, so having the subpool_is_free
> check inside the locked section makes sense to me too.
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks.  Yichong, can you please consider Joshua's observations and
perhaps resend with a more accurate changelog?

