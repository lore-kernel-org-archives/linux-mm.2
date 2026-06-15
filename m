Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5BFCD98D6
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 07:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25A36B0005; Mon, 15 Jun 2026 03:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD1B6B008A; Mon, 15 Jun 2026 03:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13AB6B008C; Mon, 15 Jun 2026 03:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A504D6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 03:28:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E4794094D
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:28:48 +0000 (UTC)
X-FDA: 84881319936.26.67AA22F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4AF2C40006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:28:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/CaMD2J";
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781508526;
	b=6dHCZxkvHWcQmc30XguJUcEX1zbEzzhqRjkR0GQNbgNRpWQZKWJpRFzKuFn5IQmDcX5oM1
	o71KP6dxZ+Wo7dNuOoZTI9WgTE89eWQyNt5C5yqlG5CXhzHxUc0N0kQGJp0UMrZ5TTVJsl
	IDclrhICM6sdbnq6ab2sVlWe021Q4aI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q/CaMD2J";
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781508526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QrT0Nqym8cVujN+BGqEvEZa2wIO7f7wGj5xv4a3vBhs=;
	b=3EIO/BR0G6zRf2zyTEch9sXlVRtE15dkFYvDzaAOC1bCho0WbI8ah/D+cVaKCjwkahtQUD
	lh+v382Col0kda9ep23ZGeM6bYaw6RnMDHTboNQObDgVus0rEowc07axGXSWTOC9Dn2A3a
	vlY2mo5jmwfdTfNuFtkOoEAgtelgVnk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F48E40381;
	Mon, 15 Jun 2026 07:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8597A1F000E9;
	Mon, 15 Jun 2026 07:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781508525;
	bh=QrT0Nqym8cVujN+BGqEvEZa2wIO7f7wGj5xv4a3vBhs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q/CaMD2JrF2pTjlhK/TRJoijtc+T7MLW4K5Bt8771ovSAOUISBy/0s7kTXLCCA4Eo
	 F6JkuSbEQ47tuGCCBd2HymgHzY8A3cN3Zk42QxwPydN3oH5A+UFvahvKfg2fprDnnA
	 uU7fNr6HqCgAkxDszcqadC4xknFOmVn3L9+jW/B3kE4pkHzORKQUA2h3eUTSgco8ig
	 dOh/ja3GJCsTIytBEx5BWqZKvr0zWMuImpO6QeQS+fvQBbS2YIo6Cg2mCvnXVzZTde
	 APlmOivm9rPynOmP72ep7EiNiEvo/28TE1iBiKNN6gsx8VjdmWDx05H87/Tx3X0jc1
	 wXbGZ3/rFl+0A==
Message-ID: <ad862f5c-34e4-48d6-8d8b-f02bdc02d7d6@kernel.org>
Date: Mon, 15 Jun 2026 09:28:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 0/2] net: isolate SKB data area allocations
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, linux-hardening@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Kees Cook <kees@kernel.org>
References: <20260611124642.345400-1-pfalcato@suse.de>
 <20260613113303.7562bc59@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260613113303.7562bc59@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4AF2C40006
X-Stat-Signature: zirmibyo19oxhfad9mjjde3ak969cndr
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781508526-85840
X-HE-Meta: U2FsdGVkX1+1w8AvhtwUpElHPN3JRHAcJ4Xvp0533SnaYLRuLucOE0YWeUHqOeT+euBVxrCzvg+mRJnxAFztzU0dqR/Dy3HiBZQCmzzEuoTDTZ3dzzsrDnT5SKY2rKBK+tdXIz0XAAJ1sUUiI3e1O4ZuGAjHenCltY+64ywB+WOqr+5OYeakSBdkwAh+ZG/UXJULR0DRp2bZiFMNAeRtRJnjTs4VbXGT9qt7wI49QNUS+qHmLoNINnp8P0C6UDij9cHKS7l4b7a/mvj12ePuHKtt4dYxD59Qr5ocE+sx7/di8HlVZ8LiRKfb+J9SUiIqKMDdDjIGF+taN7arvUpUS4cdc8A3U6Sw/AxUFKTuOShp/ROD3k+/M7qhuyPMA4ADWaAWdyDPCqIn9T2DX/dTV/Fh/CUOaJdadp+dqxLwIqlkXTu03hwaNCaRC4hJExy4aAYFSJ3ksOnRsD6UPGaPYggnh1zyoMuJDXXSdur8WBwtVmeFQhTcPQfZm0WmkthGnqCtx/xFVQrwqUubKlhV+2x59o15PQ9kWmnrzI4Sq+S0ulY5OPhtdCKiwmnGrQT9BeqR0jQ/3DWvhSsxmKleoQ8drlWGSL6nnBmKP2yVR5qk7zPDGq22OySBQmXxIafsPTYxLRxlvi8M9DCGiULPxxqANFZcK+eCYyRL/1eU0Dhcbex/4Tv4SF7B6vnaTO6jZ1LpCG0jooezTE8C7RSoH9sR+nG8ICqUuSZMS12e1GC39h277iDqGbl9KO5w1CbszzRw9wW4IFXYViKRNwXrWCAIbfO4LmmOigVGTAkkBvGnc+rFfNznya+YqI/eAJ+Q4/e3lfmSOd9xB6JkoxReChgNVGVb3Li39SNuV7HKqpaOf/lMulT9F+9XkIwelmSt+9QaYx+uYxuwtrecSgN6ke8qQLYkfp9vB4ibk2T4prhcaUughEoLQ9Lks2vAJOXfXgsKDHNv2PRbXsypSTR
 X/FCwlOt
 ABaHCVBUzXWj8izqcqwcLfwGoS4V5n0njod0qX4ehgNW0mwlUJwkIlrIuKVDB/MKfo0B6bx+zmEsiEcgWij9ekjuJRczbn18C07jerB6yFLQBrDxAruF+v1dvNYJyzAoF/fltuQR38fZTFfJD8aIcYwlCllY/R8qjEtH1ULY+l1nz2677MJbxnxap7yB1yYaHxEj9QbtYbkz7DVPFWWDn51Qrh1j4z6pADJAr5HfXSg1kUglTWIHVqde1YEf7wfUvI3pA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/13/26 20:33, Jakub Kicinski wrote:
> On Thu, 11 Jun 2026 13:46:40 +0100 Pedro Falcato wrote:
>> Subject: [PATCH net-next v2 0/2] net: isolate SKB data area allocations
> 
> This doesn't apply to net-next, does patch 2 not apply to mm?
> If neither tree can take both - maybe MM can take the first patch by

OK I'll take the first patch through the slab tree in the planned second
next week's PR.

> itself and we will queue patch 2 after the changes propagate during 
> the merge window?


