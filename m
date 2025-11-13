Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 318E8CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 12:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CD88E000C; Thu, 13 Nov 2025 07:34:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDA28E0002; Thu, 13 Nov 2025 07:34:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B148E000C; Thu, 13 Nov 2025 07:34:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 718A38E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:34:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C80213BF34
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:34:32 +0000 (UTC)
X-FDA: 84105527184.20.57905BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5BFA2A000D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:34:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EOp/uNGL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763037270; a=rsa-sha256;
	cv=none;
	b=HCn4jODNBYMKyNKpvq1DkEUHgQOJId7t3s21MEba5kX1Iy+MHXMoSGSKeFdlaczFnqGM4v
	d+B1D+QYGQMkReE2kV3F4j0PpbMips426MphVY2KiK+7k5vvr1VGy4MS02XfNPZ3CbGiIj
	trstyaxKS9buDFegnqAA0y+0myETDoQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EOp/uNGL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763037270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jElGmlZRV2yyTTPr/ChwcsP8yrPyErfoNyNa5e9euGY=;
	b=MLxOdKJLgNF+QUm7jdfTn7kCFAFXxuNFDt2rb/l5CHTvA673uOH4UD30u6CUDvn0AHGOLt
	4HtYMsR2sOym2xQwfE3uo3hn6ZSAZyF53sRoRTF34QxOHs24HE5fogIoGlwIMXLOyyyzUm
	UnrtgRAAy8X2STXbx+KqAAAunRYsA3E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52DB043F9F;
	Thu, 13 Nov 2025 12:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A64C4CEF8;
	Thu, 13 Nov 2025 12:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763037269;
	bh=y1FfFIuMb0svp4ymlKmSDs7EFvaJvR5A3gJ3lpcq8Uk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EOp/uNGLEJX2/o1A0Oqqre+Il30QU6+REZ6YFDPWH0Meu5sP92HduOMkUe8kYKDAB
	 VdMLglbLi+06rRrPRmZtPa85qJJEDgpngLeHOzUgN1sNS8CURZ8cVUCHj7//ChyqxF
	 VuOuLY62yswpDC7bqM25vTrSPw6RUWv/LeQgStQLbLM2OrQuNcrt/3iInfvUmER6AV
	 Nc+T6QelxZUkCLsxA1HPvQevv9ZkT7AKrzBRgRHmpmiBzB/hsqvjQmmfHqp2ZR80oO
	 H3l+CR6hjebnQdqloBIy7TOa2FcbeyT4jGxT7OutE15lQOo+L85dtISsLNkHoQJUIp
	 agdcL9uWkwFxQ==
Message-ID: <13db54a4-5f02-4b57-8ff9-6298c2c4b8d3@kernel.org>
Date: Thu, 13 Nov 2025 13:34:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/8] mm: Add PG_atomic
To: Matthew Wilcox <willy@infradead.org>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
 ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
 dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
 nilay@linux.ibm.com, martin.petersen@oracle.com, rostedt@goodmis.org,
 axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com>
 <aRSuH82gM-8BzPCU@casper.infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aRSuH82gM-8BzPCU@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5BFA2A000D
X-Stat-Signature: rxeebikc6qzsbugxre9fgc3xu3ngwbn9
X-HE-Tag: 1763037270-539106
X-HE-Meta: U2FsdGVkX18sfVCfVEh636xnNBrnQj8KzQjECLVdoJx40BvKwFGeG3PujUymqw/KEkML5sm8jQvm37ynkvkqjeMniwj7AldnPK3OEzBC5meXlPxTnLbavGIhMbyPsu0pIbEyHUyn0LPKCwuGwwe+iPaKZaCC6JCJLPHN0UzlcAG/3n24F7y1ey4tWcdlR6Ea30MeTNxHCyPBintoCEAN++WIBU5Iaqxtnc29H18WrKZGI+y+GZNaeaPA7lDe1FZPrTw5kk5boQfdY3HfpFOpxp+/2qbb9muI6+6ypsPnuCSZRIiei8vRsQWaHby5l6jZXManvNuIX9Ym+5aZGW5DX/2fqGCsN7SUqfPcKH4E3A4L3rZ3sgWo0kR5c7OC377LW+S9nmebXrlk3C34r1w0rR7sZmiZ57aW7IsdjTtIi3Un5LlQtNzNua0z8kEq80Tstwn8HcKwzrX28km6EnjjLdMzIqhQAvZGs+5WyqolkYcD2e7hQUBdPAdxVpaYRiaj3oedld6XG3gX+roIR6kGuWWQ+RMy28+QUidXujMC1VZLE22XQjEkEpwGz5v9UWpD6QgCeVFfobVS/K6udXBF7m+mh9o5Ecow0COMhAvdSpST5HK47kYJok0Zir2vBkp/vxOOnr/noyyjDB9s/ZokIrWxer7lFfZGtmjInM6f3h9+ZIvdwQ2jZgmuVhCYwVfeFD+wAC7LvSCAU57hwoR01j27JOtIYn+5YPWt16OD18jh1funYowhTALDT6ogJkDawvDsFAD1osYWCZaRmJ/ZJyEzCl+W4NFPXK3bZPBCY8ULSYOILAas0gPnqsmN8XBtExqRXeaewt7TfBNeTabX7IUsHgGguieCXl8E+v+FLkEi+Pje897J+pPnb9SGQUdIr68b9B10M3Tk34JiH8ihlzV8P9WUqRiJrgrYbQUUSbBU5iwCTddv3n2n710kwBhwsA6ZR/YZbKn1pvpu+Gl
 pccT5G6U
 XqqZex5b24LVNgXqdArJDI+Px0Qfw7W9q5J1Dl/0x9AbiqgnO+vMvwf2FetPzhGvpL851eR6yZr35MnmC8W6dieSjKgMwNwVQD4g1T74bhkacLe+WPYvyBMlUqE+K06NYao4jJCP4LgG3DrbNR3XPzhl3kEAuYcK8A+EzVIdHL0oq0qq1yIi0xM9iZ4TEYvvGGQ5DTn1W/jPWLQasTAtSBHGO3WRjvIsMXkttdyFWqCgpkZs9hFGMEAQnE+4uHHgYVqCIcohjDoUVZfmWZ0c9W22lL+YIxL3Ipse+yIKz8q7Yacq1mRrHw+X+BTf1FIs3M1MSgRgNjsG0hFVS14Fu1Bl9cRPA5YvMCH/cEeOalHUtRyqTs+fkxt4fn9xDYoWKE/R7oWJwLvTiBpy8bqz8BDkiSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 16:56, Matthew Wilcox wrote:
> On Wed, Nov 12, 2025 at 04:36:05PM +0530, Ojaswin Mujoo wrote:
>> From: John Garry <john.g.garry@oracle.com>
>>
>> Add page flag PG_atomic, meaning that a folio needs to be written back
>> atomically. This will be used by for handling RWF_ATOMIC buffered IO
>> in upcoming patches.
> 
> Page flags are a precious resource.  I'm not thrilled about allocating one
> to this rather niche usecase.

Fully agreed.

-- 
Cheers

David

