Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F197D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 09:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B706B00A0; Sun, 11 Jan 2026 04:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EF26B00A2; Sun, 11 Jan 2026 04:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791586B00A4; Sun, 11 Jan 2026 04:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A16D6B00A0
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:05:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17F81C1938
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:05:21 +0000 (UTC)
X-FDA: 84319099242.19.BF748D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8947C1C0007
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:05:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYaCN2uE;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768122319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hVzsSw5rtuB8mlw0/gr9rWqsfv+egoksyY+UgEuOTs=;
	b=XSSFs+u0xCP36wQxZnQNDk7cuV66CI6ZzGdWgU+D0blqQ5xkX8hqA18uLMNxtTmGbEbWvp
	PFN4O4oOyiNS7j0cK6DYCTBAHO/w6dRNu8SvOInSewrSt1mOyERcoXxKxDABi+p4/KP63A
	D2Bs0Wg90d7HGmcdiIJYWxHzhgQcpLQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WYaCN2uE;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768122319; a=rsa-sha256;
	cv=none;
	b=UaJYPnzjtxdcbCxWKVEqSJShBpXNDO3DAEQHEGhxZdITjOGPLKqfQa1TtbjQwp+fsKjzmu
	4l9IcmIYQY2p2ehBU3f78h+rSo0/Wn4lklm5s04CO9wF4QN1OdTDJFwZw+dr9cNTde246A
	hVRBmi0jqta0tEyOcgkTo+jKEZ+VyjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B69A560121;
	Sun, 11 Jan 2026 09:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7BAC4CEF7;
	Sun, 11 Jan 2026 09:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768122318;
	bh=IQxO9W6KgnyGalGRD1IcAY2X+P5dwK2MG9etkaSxDZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WYaCN2uERkCFnLYgHGJ9Cw4Z+BN+FDDlnr33vy8ynS4Z2fHirln8TYmAjw75nrKac
	 zSbpAtPxhJofyaFa9H0k5CIFv3eUV2lBP7oWRljoRJ8MfsitBTI38hi+3fxmwWqjAN
	 zqpbzCUGDva+CkzpXcc2l/41vXTSELPJZMxHT+q1pLdlvVeEDYRtgkeExLKF4uU2v2
	 bieoTMYFZB/9v19l/mU1zmkVRxtpNFHd8kTwPfcXgi2xt0QbU9ezY8Vk9LQ1kGSue/
	 eAfkfDNClBrep80IiBgi6ySvetBOjFgmZMiWqxDON1lAtYWF4jlVn5CYy2f9oDlfl/
	 Yb9kzQ3GRDM3Q==
Date: Sun, 11 Jan 2026 11:05:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-kernel@vger.kernel.or,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: numa,memblock: include <asm/numa.h> for
 'numa_nodes_parsed'
Message-ID: <aWNnyDTTRoO2HKnD@kernel.org>
References: <20260108101539.229192-1-ben.dooks@codethink.co.uk>
 <20260108105220.f1577b1c1709319e83760699@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108105220.f1577b1c1709319e83760699@linux-foundation.org>
X-Rspamd-Queue-Id: 8947C1C0007
X-Stat-Signature: ig1oejasaedt69848juduj7xopaguz9r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768122319-972654
X-HE-Meta: U2FsdGVkX1+1RvBpFFRje3QPdJYIhnf59hgI/E/n+6vH0C+FCNRstAVubZTzVhv08P5BYWOphBhrbyRviEA7RBwbySKsqhs88eZgd2Pu17VdIGKCYgMoOzKq7JJdfLpgaEjBofnAbIBIWKY3JeevbRcSQf4/VUWPieyjqN8viMpRMjKtxdVLgL6RM6n4FHyzr/HAa+dNcA/ghs5ABXG4XXF9uqoA9hE3HyNuDJ8VBfcIj0V2b/j88gmUqRekLiwfP0ERxR1Tkkk367EQoUjutGEcTWFEjnE/3sTLrQQzEfDjBm4yZpTJGXGvpD010RzCcTW8hK57RwD39QZv8Kqz8Pz9j4BOkiS1YEZq15G3I8OFNtEczXH56Jqv/zqL8RCWxP5wzVdZXhcX7VBzdfNZ4BbmJROA7GNSS0A9+c9ElDe0Sgj/08RQ3+MENfTbqMe+vnb6CEibAwNKy4eyraXU9DLIZ9Nu66mT5ah+u5gPVMcqkRSXSX+2ixJzfgJyI0ONdIWoD+ldNOv9ugR8DqH25eTymObQCGjJtpCUO1pIKy30X2kKjrqxVA8O3M+tkST3rwyuuNVf9GSqW66fJ6FnZ8GTTYAZkAMS4Z4DVZWhoppAFRlJ5sKXufqDZnOereP0p+29E1BII9T9G2mMYRNUkQh9LUQNVawCjX3dnGw2hPWCkYQjy65zoZcgwoiKkL+wCsTUjrlEIes3LUxl+ZX2wkDnszp8kMt3xY3LI5PKQWyDok2sdW89A85bhewF3m+gXZKBaDTO0Q8v3TBjB3s5df8ILvFbhnxolFKjQpNfUNJbvNBcQVce6xLXONscL7cLD7UerjRIxZAxuebjTO4edSiMtIbpIjsnURczLyTvJxKn+1BetW7469CeQWX2kVEYKE7gicF7D1F7wPIf3lAigEsUIAWSNS/SPEDHdfol2rp9D5vtur6ZYTuilkuRLPDJvTDl1BPXglK3nSYgv9/
 YqcqSgLN
 3Oq/sQryIHexv4Jp8I43gtNDn4FJ/NiwhP3EVViBAotvbza3lI6CY8LbvBwhiAC9RUWvqE+3itsP0lAakEPpuqogDytXuD1XXxX602MFEa/6qjRXhs2gJG0c7I8IugluUhCVPn9NJS0Z22gUqCH5jdVKle1PWkRc103MbdrUUjuwnaghsVHoGOf8vJChNKFV7++/HLbmr0wJrm4SdxHgnP/nQj+2dLNPlNth17xyFleasOpyAdra8Jw/1n8FLrN+NzdRCa4gz+Pl301JLTQbvNikjyPp60U6ZN7kH6OVxZoo2iS6ZEvehixtICl9dfDYnilcdmtEmf901cqkT5JwGYTbqlEv52kO1JIlh5kIK2RlSuDRVO1HZcHxLxmy2PQVSAYth
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 10:52:20AM -0800, Andrew Morton wrote:
> On Thu,  8 Jan 2026 10:15:39 +0000 Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> 
> > The 'numa_nodes_parsed' is defined in <asm/numa.h> but this file
> > is not included in mm/numa_memblks.c (build x86_64) so add this
> > to the incldues to fix the following sparse warning:
> > 
> > mm/numa_memblks.c:13:12: warning: symbol 'numa_nodes_parsed' was not declared. Should it be static?
> > 
> 
> huh, I wonder how that snuck through and survived more than a
> year.  

Probably most configs include <asm/numa.h> as other header dependencies and
Ben's config does not for some reason.
 
> Thanks, I'll add
> 
> Fixes: 87482708210f ("mm: introduce numa_memblks")
> Cc: <stable@vger.kernel.org>

and please add 

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

