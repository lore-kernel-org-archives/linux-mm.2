Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE1CCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 22:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9556B00A6; Tue, 12 May 2026 18:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA176B00A7; Tue, 12 May 2026 18:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFEA6B00A8; Tue, 12 May 2026 18:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA826B00A6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:01:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5DB9A05EC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:01:12 +0000 (UTC)
X-FDA: 84760139184.30.1B38AE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 29D8B16000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:01:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=COD4TObn;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778623271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJbpS0PXhKhtLAOaLP7YP+MMpYAB+XEVkc3ua+a18vA=;
	b=mplo1czAknhD2dX5CaON3Gls6nSaD935TUjyWrCxFA5iAkUa8FHDzXrobXLJuvTmvebwCF
	wFqM7f7cn1t7czG61tKFnTJrzAdENpJeAGxvKlPOswnuUp9xk9bGCZgAyuCqIcavims1ye
	AdoIbPno1shQxHRC1BiBlxAe6KfoT34=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=COD4TObn;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778623271; a=rsa-sha256;
	cv=none;
	b=fiItpfn+hNyaPl8ZD6RaDVMDrN1lyM7hF8Vv3MbwYa3f9qeWcTRN5eQYnzr1AfDwfilGHb
	qMEX+wf2yMlKxUQdWi5NPW+z26mMhw/1si6lqsLbem3SMRRvk1ktZq/OR4pm4oRZDVA9HS
	3gFykiujC73nwYmY8gmnuYh4PhEJVB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 778B5600CB;
	Tue, 12 May 2026 22:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD47C2BCB0;
	Tue, 12 May 2026 22:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778623270;
	bh=stHzpDKumJy7YpnPJ34lgA/OWNM0rxa3UutKqy/RsPg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=COD4TObng6uxqiTGbOE6souHjBjeBYtdueHWQml7fq406stOXnBgL1hox9Eb80R7U
	 dOO9+d12ppt3k9iERL652gM2266FDBLOdYofg7suiXPDy+828vx8VwVF8JXQkyHuaU
	 bJ6PFUVW52Csae9XnUOYBJLMd9VkABLaqgpNYtFc=
Date: Tue, 12 May 2026 15:01:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shivamkalra98@zohomail.in
Cc: Shivam Kalra via B4 Relay
 <devnull+shivamkalra98.zohomail.in@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alice
 Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v13 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-Id: <20260512150109.1a7939bb15f3d48ad866c540@linux-foundation.org>
In-Reply-To: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pdtthxnhwhaq6f8herj14w4trzqg5kwi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 29D8B16000C
X-Rspam-User: 
X-HE-Tag: 1778623270-538361
X-HE-Meta: U2FsdGVkX1+QYTlNW6QTyokx9Xc2adBOhskNgJ1gyIlRWBRzOtgEwd83hkYqdGtcJ3zvWaGfft+TNnvKGWmlDRYQ0mMcGEv4K42McjYernn7Dae5C3QdzexFAfl4cqK689t/w8Y3sVdxzrHK4wEFmxI1WNrj3505VCBT+ADLT01Cn4VeyPnC9u3goZP1XIaDR4H6vk87gxDyh+QR/M7EDLBWl8fKwzI2/YAy0UTNy/COMQlw59xNAScKjrr8R2bdrXICH8CHArNJ3AqatcmXgpGH0eCQHY29SdmmN8fzxTt0XnZOy5Z84aSdelbbNdrTXocmh0O9AptSOzNcJdYkrzWgTus9iefILZA/pJyI8wJPvJ6sssUG/wyGzQHqwo6XyC6W4TiDhLUWNd9G1jnLQs1oXvYR4gt6UJzNzNxd4ll5xhUNtfSRpZI2eyGysTW3ogLUZC8X2ZV3jKf+J9puNE2Mcx5ariCb9KrjcuJpBU78JSmX9Vx9s6sGEgonG3lS2I4NqnECWaSu6Q6fh+fpKgKtAb/uR2Vyp3XoxtvMQ5UMefkRq5gwhcX0gfZZRoNis7zps9Lc0CwHtdEhi6TMsyAi1zI2XcYIbFSJ8ggksRlWHctgkxIX/LoAC0lghAGcU6/ag3hwdwOxj6nXfttdtLitCkJT3KTJI/JAsXzvs+c1FoCukfK0yr5QHJGlmw5k1DubWZgUrzJozQdHOxYa4+h0GfGEJpiZXNSu57EQZ7oE1NVdhgsXM1aufUvh+izVJ6JeestmAND3OWhCOcRsuX6klrnvdQIioQPWRDORAjJO+Q3XsAPhYrmDMs5kYi7lEZqQqbKIwehMcR90WrMG96mBSzTr5DbtAuJqnoNXZfICg9hpeWKHtTeEOEtBA9d6Pz2IqfXgDhDJHEkjOS/gKkDCmW10CCfzJiq3kmwO6iGCcXfKmnc0QZud5zmFdKVRoJzmxi+fGZLl5q/dlc+
 cNLjWr3s
 BCfE3LIPynl4iu3p73ucRz7XhGCkNSmIpB71tnZw1bkAnO2PfGvoWRfevY1860FkVF3Com+xaQ6KG+LK8+POSMQUSFCDFiSPQ7AUcp+AHmfM3nXStelPudZLeW/BqcfHuUKMybxU1+h+Hy7MDz9XsOsoxMnMPT5mCEFX0DkRs0f4zyjYkyZq9F5dfGXft9KntNqnemx74KC22RFVVo50etR+PrXv9fJZUDrmGB7H2ixyGBgmlRMXy7ABTfbN3Tlf7AA0ktF3+uIzMpZDLiGfRL+c0+Ecjd22EygFaMC8EKsx6HL7T4aYYDClxcJTz7mnPbqzQNQVUUpS7+d3a9TcIs/lzavgjnGk49eZi8SL/hY6ihPyXIt2lCijQQFVB2sGYjZVFI0o9YMZ2pttUB4c/bYW9i69TkJzlnM3y/6/YLTBh7mebkeqssfEEbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 13:47:28 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:

> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.

Thanks.  AI review asked a few questions.  Does anything here look
legitimate?

	https://sashiko.dev/#/patchset/20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in

