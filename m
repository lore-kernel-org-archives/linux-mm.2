Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59873606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A1EuXLLm
Received: by kanga.kvack.org (Postfix)
	id 7B4DE6B05B1; Sun, 15 Nov 2026 12:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765236B05B2; Sun, 15 Nov 2026 12:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6307B6B05B3; Sun, 15 Nov 2026 12:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0F46B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:33:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB37E80801
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:33:52 +0000 (UTC)
X-FDA: 85438051104.01.352A0B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B32D80002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:33:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1EuXLLm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794764031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGZSQK36dQO1d5WmaeXJ05lPFIpl1QQYBwK+/5+t2vQ=;
	b=p/AFUNTRYiZSXKb0jw8CTm+2QLTG31Qo53GkPZMIBMdtaLWUlZVPDa4vdiHF8+hnQBKhCE
	JSRjKaoDb0C6UB3DvTGae6OttK189oOA7o5SpAZov6oGPISe8ry8nmI/fVMGcRv+7GQPLR
	kwI/hXBR7AJRC8e51ZAvBdM3JG3Ym5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794764031;
	b=1T5FwBfSuXVlBp6RnRXbjAtyzSc0nzHiVgWi3PsFrMukXXOQxcuCdugl6AGCA86REF9clq
	d+w/xNPsLQL8YaOw8EvIUThO+GRFZp/H1dzAL1TqHE3Qli0n1aaJB81bESCebo/oToSCeN
	S+vEq/mjxAqp80vxVWKf7kbjCszlN+k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1EuXLLm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CADC60A62;
	Sun, 15 Nov 2026 17:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAB91F000C4;
	Sun, 15 Nov 2026 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794764030;
	bh=oGZSQK36dQO1d5WmaeXJ05lPFIpl1QQYBwK+/5+t2vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1EuXLLmgt9jXZn2tSu3WzLjEbZru4Lcta2QCZYFNqTUj0Zah/bIhU5rNG6q5iby2
	 S5JWxRB6HxLhaBMdF/px4nMxQXtcwZmvommDDJGFYcbroMNZgakb7tWLKL5t6Bcnuq
	 LnezLGbUFkNd2L2hqZ54EjeGEqQ/g057yYHc3kdPemIyCqAmfU/gBnyBmOdYwpnkP7
	 q8J4CJtNZdQMoYaArjtUHNmyOSWwRUIgxFVrHfK6WPGNlk00If5pDJS3nqpnv4yv2P
	 DYKvJ1jQ9DHtk3hArDac4OYuyiQmoddZSjfBoAS0WPNT+aiV8DfAuGpBPBCNVTFrdQ
	 Hy6XkPeBAQLpQ==
From: SJ Park <sj@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Aveline Noir <jm5905938@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Sun, 15 Nov 2026 09:33:42 -0800
Message-ID: <20261115173343.82437-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114181034.2665113-1-devnexen@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nhahd6rbc779xjtefq8g7nupqwfctyw4
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B32D80002
X-HE-Tag: 1794764030-895639
X-HE-Meta: U2FsdGVkX1/wFJMgfTbKgVGjNkyWppSAubP4Q4RfxN1FwEHMcCL1nhi3F+xvikMv8GSFgjuE2hoChs2ziMj1XfE0pxoYiA0GbujpzI3Sv4jBfzYjKja3JJbVqRRSXHqBPIaaXEMF65hCubfRCSpuetNUIueKa2qSwqlic2snB+zvcf0bdnFuEGXA1lwoKp6tsWcac/mXWV04+/jYSuJhN4u14UzWkGHSIMmeVPnmxr1bgVPu3VzrZCGoiFUxbnHRIlMkODUB0UrOhVbrs7Miz/bV82w7XVwiwcXVASo16FhFsJo221GtDawXZdIayBcJVh0Wfb1AhXyF0oOHiZ8gborttuCwEpe1LzQLevF/SNJfxadjaIyktzGBgWoZ34K8QQzEPSKE+Xkg+XyIk6MUKendf+woGOrB6K8+l04U7L/hFsC4NPIw3HrEsmwinGjctRQ0h9EBejf/RfETBrLuZr0U+P6pCdEyhoiw6uk/POFyVklGRQzSYU06Han1dGoS2A2loKdSA0cVFlVy3U62hi2oGFpQ/QtSAAJf7ciRFKGqSrwn2s7YNbEcu8MboalosnD2K6piomFEdAE+FvTJbSAJUZKb+iVOJb/xSXXPkTCk/LsitYhU98x1hBj2//evT9s0NeN0O7kM+F+AqEVrBIxBP+fbkK1tbnuftrdBKdC9EIktgbTaREimYAYxTHbG2mwoC65LOPREsKfgF/seezvRJRljm+9J5jS8GQNLj1+HiUmbhiU28QE5NcxnCcLcyd9+hTN0zQuQtEh59gUTcQ7tupskfKBpWm4vsrrf26MjPutm5cFydYh2LcVQ13PLM90CuTcR8CPn1coMbeT36CP/S/gJhtyltJGF6ci2EFCYIfxTTnbadysebplxncjJq0aDNS26MyPbvIyOuKqngnLUUdKkoVQwldUzQlU/9mykL7VXu1OY3hvjbwJVV1f10uemV/RKQ6phZmPePuZ
 Pjd8kCE9
 gvWqD3fmB4ySbGzedvCkRrewk+xOC+y58Og54I/MgnsM0FBKqCC98sOh+eHVaRfiVN7gfKQ+Gni4cmx3+10G4bH/ZFq05knR9OEc0eez/mLxJeIETdT8YWK8xGEmLZRFvHQLKA2bmaiquStyYE2LL5co9snJN7SqAqVtWko5+VNWaI5eedAoT+lyaZKoUTiLv78aM9sgwjEafw0ljwQ0yrT2ZcC2/rpTLZji98EaupaX+TnFj+nh6E5M06KTMyfec19a5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello David,

On Sat, 14 Nov 2026 18:10:34 +0000 David Carlier <devnexen@gmail.com> wrote:

> Hi SJ, Aveline,
> 
> The value stored a few lines below has the same problem on 32-bit:
> 
> 	damon_stat_idletime(region) *
> 	(long)c->attrs.aggr_interval / USEC_PER_MSEC;
> 
> The product is the region's idle time in microseconds, held in a 32-bit
> long, so it wraps once a region has been idle for more than about 36
> minutes, whatever the intervals are. The cold-end percentiles then come
> out negative or wrong. Doing the multiply in s64 with div_s64() would
> keep the sign and avoid it.
> 
> Hope it helps !

Yes, this is helpful.  Thank you for sharing.  Would you like to send a patch
for this issue?


Thanks,
SJ

[...]

