Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9721BC5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 19:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EAE76B008C; Thu, 30 Jul 2026 15:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C046B0092; Thu, 30 Jul 2026 15:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B40B6B0093; Thu, 30 Jul 2026 15:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 375686B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:53:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3649140281
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:53:31 +0000 (UTC)
X-FDA: 85046492622.12.7EE26F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id DBFC8180008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:53:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iJnEVe1v;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785441210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYHnuwd5oBPShQry/A1IMV78wT87yQ12pmYbnlaWCNI=;
	b=W0PSio0V9DR8+mtIBNaoX+0kTuseox2KqdnKoECq58z696zA3WQ4YR+GN10sYtbxX4sCf3
	R/olF5mvJAQjtHA8XxTMNBibWL3EYgEtUKlXyq89d6SxgqgMaiw55j1e/UGiSAA3ZR3V+J
	7foiYBQpkIa8+59CL7Zqi0VOBgvhjow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785441210;
	b=Nh8tC9fiOColNLLW7D8jMUTL2O8rVIfEXc39gJyfA7MdtEd6UjTw0te7Yry4tsXzW2h57T
	U5EEkh2fLSGlwwVCcNHRMJk3QVA0a+9QUNk1RGlqA1qlm/9zPo0a5DJg+5Pgj2JMPJnt20
	YIGVdmphZFMPs3NaaAFX1B4u3ZDrnhc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iJnEVe1v;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D05D41734;
	Thu, 30 Jul 2026 19:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE6C1F000E9;
	Thu, 30 Jul 2026 19:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785441208;
	bh=SYHnuwd5oBPShQry/A1IMV78wT87yQ12pmYbnlaWCNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iJnEVe1voUvv8oU3L/LXlxlWg/TMzmxWX/p+WsY0i3YPuE5mFSEJ4cF0TMcimIXHY
	 ghjBzhczgWPekjA8dP0c5k00yvs2tMguPZfnVAQ1KarieF9XzeUMVueazl7OX9zaeG
	 yRbcWd3iB0SupGRkN7oe2OwtgLEhQG1wvVdm67wE=
Date: Thu, 30 Jul 2026 12:53:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat
 Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: reject swapon() on filesystem-level encrypted
 files
Message-Id: <20260730125327.11fc9227d04f659a59136cdd@linux-foundation.org>
In-Reply-To: <20260730184853.48347-1-ebiggers@kernel.org>
References: <20260730184853.48347-1-ebiggers@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBFC8180008
X-Stat-Signature: rqhdua598967d4rf3cem1ib9o3q4feq6
X-HE-Tag: 1785441209-888767
X-HE-Meta: U2FsdGVkX1+SBSCfclwYNBmj82lm3Q6vX2lzxEWsA9BGweTpiMeMkoRHZeiy37JhILzAU6/hEKa0IERdD+A7VmQs4CVjHJwvnHuuh33sSL96NkEayh4p0/fMMuIGj5J6bBaYDITbCra+q/xZqsXYQdHut8dThuPVYGV130IA0eezwCxH/dtuIRI7jQVDnHVsVlR+J/Rkzn3mOf44XbOm1kJdLybxb9rwCmI7ohAMjcvFPnpzXPlFjcMOPw2edqsKoH+zOu/Ff2DetszTq1LpbsZbshIpp5QEZCQLrwg93UuWBzcIVl14i1f0pWcY1bMSbL0WPRLj7mII7W/6Lc9jWMLEbIWeVcZ/95C2viBNDNSLiRWdObuqSe/ee8m/GrtfCDawOq9vPNAPxLWbVB0LQWoMpGIRrpprtq/NpkHNDYrnpOBb5UydwEW1f/6l7VU9i8mA1lrk80uHPiHRjC8sr0HNcM/s6JCK8e8jPgrYqR7qIRe2lI/PDW/KWL8lr64XVQxw70FMUdIdYT6q2xvoGlKrG2k91OX9pUOlQ45oCxG9/P3sNoEcdL6VWOOp5qfDlmAk0W3CWtwuhvE1Ni7BQGxlwT6fMlMzaK3IriauWXZOLWnmMSp6vvEeSwAJzOZksQbaX2wLd6lAywXYXQJApm3pQfkjMwHOHe1ngTmOWQb758eBVItjktWX3KpbwywpmpEevDVP7SWppXqHTvSJsTqBesfsconFj3N9SVVaTvd0dILroaJEb6/rrdX5sSbqNnPA5nD9GqKnjDqphY9ibpTw9gvxKK2JeJic6VCyMMENsgPfJTHMqDDyw402UkXTZrZPV6fcfazU/1haGJuHSMKtja57BwJLvq83aLHs3FA3hOyg6GQfCLEBbNZEn86kB26g2YkdD0uaQM03Uv19t0H4nGfzPpwKhrJt779uPWDo8Z/1jMMDib42vmll6yVuoTwk9owyIV99YGjRK3E
 H5Tbu7Iz
 DtNijQw/+xPn8ZscX6OdiQ8dD21vRNotxbL7spAGGPruxYAvJKDPdxpTnTA1hvbJHbO018Kr2RneyY7LYj3pADr/RkFN0ZNMyh7g3LGx90GtGo0pk4WSwMYoLQ6QC8XQAVVJlKjZx30mq8dgs25RjLRJ4I3/Id2G8vrZBdWKwAOyOv2bsj9sYvdDM5EPv9gbsSVt4LYxkLzUjY2mu9nlsMm6F7jg0J+r7WBtwCdPNNVgZuXTuHIeAmCgB4b9yiWcG5ZEgGTFLEtMr0UbkYYebmvlUTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 11:48:53 -0700 Eric Biggers <ebiggers@kernel.org> wrote:

> ext4 and f2fs don't prevent filesystem-level encrypted files from being
> set up directly as swap files.  In this case, encryption is bypassed.
> 
> No one should be doing this, vs. the methods of encrypted swap that
> actually do work (such as swapping to a dm-crypt device, or swapping to
> a loopback device on top of a filesystem-level encrypted file).
> 
> Nevertheless, to prevent user error, make swapon() explicitly reject
> this case.  Document this behavior in fscrypt.rst as well.
> 
> Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")

Ouch.  We are going to break ten year old setups?  I don't think we can
do this!

I think the best we can do is to emit loud warnings which point the
operator to some Documentation/ which tells operator that this
deprecated configuration will be disallowed in, umm, 2029.

> +  Alternatively, encrypted swap can use a dm-crypt device instead.

That's tautological.  s/ intead// ;)

