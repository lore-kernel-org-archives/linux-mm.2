Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F46BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFFD76B00E8; Fri, 26 Jun 2026 12:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED84B6B00EA; Fri, 26 Jun 2026 12:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED7F6B00EB; Fri, 26 Jun 2026 12:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B71666B00E8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:02:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4086AA04FB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:02:13 +0000 (UTC)
X-FDA: 84922530546.02.65896F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55E79180018
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:02:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OmLzHpUK;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782489731;
	b=fG9U5HDM6YChx0ENwXfkaMn0Vkx4Ngi4nJEnT3/KVRTzdXde8Xq2SRngKrcA8AGYc0yELg
	hc6EPxH5yxa3ugp3hquV/hw1b/XjX0SjaM/6uSr+UT/DbvVuF4/+Xy/V8XDcTmB8CJvCN9
	+r8GGFbaUNtzDEPJ5dqXztNOTYDXz+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782489731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGny4MDbdiGnqMNUM4Qhs7X7axB+H5dnSFgwt0189jg=;
	b=50mruM2wkpF9gTbAYefpk7hNsB4iG37CuQ3yF6QT4TXr31U2bSZfkzPEJPGBU7PF3JLCJj
	tQ8Q7z65lAX1K7+8tsqJilKfwVYmBUEz6ZGeu+kDMaXNVBLs2cb2iuhOEc7vyAO/iaV+E6
	n2+Pcn+6+6ds+iAMMf5fAeTm6uErVKU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OmLzHpUK;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E417403E4;
	Fri, 26 Jun 2026 16:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7865C1F000E9;
	Fri, 26 Jun 2026 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782489730;
	bh=yGny4MDbdiGnqMNUM4Qhs7X7axB+H5dnSFgwt0189jg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OmLzHpUKKK3hBU/M2uh5XdhP2bUOYO7XA6cfj9DJ+nyrKKE7QgpD1xMIm49TZDDTj
	 zKIu7MS5AW7YL4I4LQr8CxLfRYo3qjWtRNym8W6DXEslLs2/pzXGeuTKx65tBJXx0J
	 2QCVxfBcKpSBdeYlFkJ05GXZXZ+k6BZ6AW89vVtdSHp3AJW+5TfARK6PwEAM0MCGtR
	 zq01mbPJxCIG2hz0MEX/2qaNgnxnKt8s2QeDPfWIeexH1rVfD12Vpr4IdD/8kvNDNa
	 a5J1nX6aFKkkFQk8LaU8eaxehQY+25DNM9RhgqaaxlpSyLgUMqFhksF7HvCjH1z9gA
	 TRteUxD8T1TBw==
Message-ID: <08b8c447-c991-4c20-8274-3e65787d20de@kernel.org>
Date: Fri, 26 Jun 2026 18:02:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount idmap
To: Pedro Falcato <pfalcato@suse.de>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260625153853.913949-1-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625153853.913949-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ztnupetr1b8dnt7embsybmgfz8spxpnm
X-Rspam-User: 
X-Rspamd-Queue-Id: 55E79180018
X-Rspamd-Server: rspam02
X-HE-Tag: 1782489731-355097
X-HE-Meta: U2FsdGVkX1+PyVr/pwZ4Kqoqa9lyjdpWBZHdflyBZ+HHFpgZTikkBhHQQIF7UXn8w7XWVwa1svzkQy9t4O50G5gsDEAt9lga+2rDAle8mpmCrpOu/0E5jTfSv18X/3BcLVWbInKlaa01NlZk3HfncWBjIQt9JmOkIGwZ7aV7MscCmPHymX9Z4hPS+CrYprVB4iljcNfTnhwvA571zI1Tt9cHrfrp5YV7eIFflLwsuPpkPHIUbVBxvUKdTSDZjMnm0yC+qkSC0OU6hN/sn9tNFRP5wkW6B8Mdw297tE4aqBEvQAIlL4tQ/wsY95OF4d5ICRvEMpWwHxy8caTX+XSEVizbdXLOy7UgtOj2rPQVzsZPn2tqZPCbKUk/zi887PYKVO00kwe+UwZpzjLIhPixiJGHo3bO20uBybpelGwojidq4wsBcUTcltvZkQl5TAKFJQL6PHzxa6Nc0UVmdOYs1Yt6aQ2M/AWqmr9TfgfEoMF76CmiAnn2utIengh1Bf+hu8CixvOG5LvrU0IqTyQVFaZQsDwULnjYuqV9Db+UUunGI7sN1FU6DQsb5DaC9gf7gSr19xfPgsSu5OunEdXBC9tiVKDbQHnF9JP64k5r+6lGajvPFYLGTa39rqUSqvY2eKoBTKjZy6AtGLPDwFPvJSljl15qFjnJTXE/4nzeCSau8JFDMCZ57U+tm4i1Ma6vjUPtNPKtepEzlpafDVkpHOOIV6oDSm5P8eBD/462MD2quZ/ZL02BsS9eojETV1OI1z5hgn0PYKLTxNzrvbSzEXoKubyyL+00h3PnQcI3vW5QH3Ox5qH6b1pDJ9yc/3FeB0Shs/IV+ZQ37TMKALS9duXCfcJ+g6+7qIRfElN9gShXB//vdzP35uqbkFBp6UahdD376EmN7PoixxiOI+fagLGyd7ARWlKagnvf+OPSXKHNZTlw3ERo7T9Qr1ZAWZjKwXs9zQakVA43x+I5flU
 e8Trvd74
 VwaMMpHVctjTBap7+DtNtkngw98TVioueqt/XZJ/D7O/Sr7eIl8GQcfLPPNb8mjle0kVgr4UXQTUS1OTfUNr7ivHtrSe/Amx3QqXK8GnR4hKgLaTU/KYoRsOPdjhooVtK6FgzMjBz1DLS2JZ82eqb/3EuWdfOexxmGc9ncOoWjz9j5xxofiW1ChAWl+S15M4F9u52vvkfk+99D5Stg4T9RY3SNLf248OZ63QR9OKtxX60woDzDA3/LO1fn6hnas9IJu8HnZ9Aka+F9uaaIowybVTHRw1Ib1pVPssg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 17:38, Pedro Falcato wrote:
> Ever since idmapped mounts were introduced, inode ownership checks
> (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> done against the nop_mnt_idmap, which completely ignores the file's mount's
> idmap. This results in odd edgecases like:
> 
> 1) mount/bind-mount with an idmap userA:userB:1
> 2) userB runs an owner_or_capable() check on file that is owned by userA
> on-disk/in-memory, but owned by userB after idmap translation
> 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> 
> In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> idmap internally, but it does not need to be the case on e.g a 0444 file
> where even the owner itself doesn't have permissions to write to it.
> 
> Since this is clearly not trivial to get right, introduce a
> file_owner_or_capable() that can carry the correct semantics, and switch
> the various users in mm to it.
> 
> The issue was found by manual code inspection & an off-list discussion with
> Jan Kara.
> 
> Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

MM side LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

