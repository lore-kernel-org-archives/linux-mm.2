Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB3FEA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8AD6B0005; Thu,  9 Apr 2026 07:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0826B0088; Thu,  9 Apr 2026 07:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD456B008A; Thu,  9 Apr 2026 07:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 119476B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:56:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1F358C2AB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:56:54 +0000 (UTC)
X-FDA: 84638865948.12.213C023
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F156AC0008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:56:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cBaBeupr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775735813; a=rsa-sha256;
	cv=none;
	b=mBwvtGDKOtN7dzXzUg1svPdZF8C1W3a3DOIaWoWbtWcDZL1MTz0vbYLaUpIVMmDACuA1+n
	5IgvCvZG6BrqTaa/Uuzc0t0molM4BdzGldaaeLERAMqpFArf6HRQNJNlNu6i7iQ64hW6I8
	Q1UVNeHv4/rrj+rFqOQkywVcCItPF0o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cBaBeupr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775735813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUpSgu4eziP5n7rDMK7EfbfDDrHLyD8xAoZW/Go33kk=;
	b=go8EGNEcSw9bnpE38zAnxNxDvSCdqwKyyYDZusvf2T9warulcmobSoFekWsTMqhnumZsG1
	b8H+m0a3wL0zUbHoSoFcS6JcC3EB0RjbXpblIjCNhRhzqHdzRQ1+s5gaACs4AWy2TEP1W3
	6FBZ0suC0xhKoBhEgPJqf+1Z5IpkHJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB3E343A91;
	Thu,  9 Apr 2026 11:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C506C4CEF7;
	Thu,  9 Apr 2026 11:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775735811;
	bh=y7BqNP1W2KHlU19MlaW9q/B2IueRNczxl1oFvHsBkhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cBaBeuprHZm72wS3WWjG/PSuQyvKttdSOA1j/vK6PgAhE7Lsj4gmjD878J/MRzNEC
	 5oJoD2FcJ4OXH1yIHVfmZuhzBpQmC2/9TAy/Lp08swOsFcAg0VcfdesDv0k6jl/TuI
	 XT9azHwufArq+ht+v4XCMoV2YhdajSjejTegQ/rMas9hAZomilsEQzEhSdEDu3cC72
	 a7k8WsSeNJZx/MsHsnyYhMFntLXV3S11rIwOaDsd1ND0ekP8dlyImVQHyyRwrw8t/Q
	 jjYDSiaa8Q+1lcs4dlPdBM2amiK1ig8anEMJo0gAS4xKzuA4PbnFq3htCofpI/VPgr
	 U0o2gzxhpHdtA==
Date: Thu, 9 Apr 2026 20:56:49 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
	peterx@redhat.com, pfalcato@suse.de, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	usama.arif@linux.dev
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <adeUASM9tEzo1Tnx@hyeyoo>
References: <20260409103345.15044-1-komlomal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409103345.15044-1-komlomal@gmail.com>
X-Rspamd-Queue-Id: F156AC0008
X-Stat-Signature: 6n9r4mfhfee89cscwt69ip8zaxe1iyp6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775735812-659614
X-HE-Meta: U2FsdGVkX18A17eAiVSLRE45IruOa3CBQ/tTWCNHKMsAREJTbBCDJ33Eo3tS6rFDCYYRUEjmFWgjh5IvYsf05UEyeRUP31X42iArz9Qsk9VALtottkHPUSGaICgBQGHg4wFL+5BA/+k1W3KWiCz0NT1NyGnnNRw0cQenO8C2+1rS8Nw581i1+7N8xkl6wwK1k865B9WMztySOyrzUNlUofpgoMq28Ae0XuBVg3NTWzc2Fa4Y+b29S4JfuH3RUZwbn56wOwKmVbE2pfKgqNA6wrek3wkmtkfh7b2S6y+2pJCzV6mDacoGqFqaPR609IfpqkBG1Rv5I4A6FF7Ap7h+hPp3R4AYJ8eWlA+GHMCRaoTFBh9HgSqB1GFazQJ/fsR/b+Ro+50PijL5QqsHi+QPYH4Ge4l3OKUHBMJoz7vYsXtYnfqvzSjurUGf4Xk7RRIiKYkm8BwWpwBCYsThD6En2a0bod+xGkbW87lR8xaRX1/7HPe8NrDWC4h1qvWomonEYPiZSspBu619BvBxahXQqzqZpQso0F0tEKpbOhIHrsZ8lJvm/ur1JIzqeqObIkAjWFZtMQ2A4hCN5nZjhUVBfKre/eBxxYl5rFT11ZjtzEssMVgQi08ihHASJZDdedp42sTyv+NkqChmIAbCcuInx04OKVe3Q2IQXOgZUya8GGPC7kjfaA7/gm0QFEamzild+s2GllGpqWT65Lxpi7AgZ+l/8XX7mJ+OAiOVFL8BVVDd23mss7r3cTDWiZF246UTF5FxD+br6E7te62vi4xDJNt7PFVTDk1j+vGquV4xr+enUHQI2m8gfzNKzqt7g+1tNDXvDCqL/1fh2ccG12nDHAJP7B86NWAHvIAmis45Wt3FVnu9yLr7utHrpOfrUeXMzCNGgY+ZaKBxie1fmyQHxasW2AonoHhyRX224kkp3VExgoVUC8hiDjNTi9Iu/xC55SB1wZ3cfCKUXTcu9wD
 LO6px2no
 qI1UgfHn6qFzTfmZfEvkAWPBXA0T8rSUhzMdD2EVKHe+583fmuL31oaPvE1KeL1t0ohOWrHVrA3MOZ4HRGtPOXhWR507p9EDpe+wD1mDnpvXI+cTZI9kQ/KWor9R0Yn+APsh9WaAT9M0Ch1NBYr6Q+ehTL4OmVjafLQ2z8JFvZvKcwybh+P0OHp5hGElYdddI6uUh015LjMicSaArKYEkhVBLBGr5jdKPXGqQyobgQ6NL865ZN24JTbt30JMFjdYfd7mDZwoUIaKvQJZK4GxOL7LV6mxW3veBnG2CBZ02bQBBajh0O1eEfACee6D8Va2G/mg2hezCsij9t7Kr5YWuVIdgP1jkYAbAhXiC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:33:45PM +0300, Denis M. Karpov wrote:
> The current implementation of validate_range() in fs/userfaultfd.c
> performs a hard check against mmap_min_addr. This is redundant because
> UFFDIO_REGISTER operates on memory ranges that must already be backed
> by a VMA.
>
> Enforcing mmap_min_addr or capability checks again in userfaultfd is
> unnecessary and prevents applications like binary compilers from
> using UFFD for valid memory regions mapped by application.
> 
> Remove the redundant check for mmap_min_addr.
> 
> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> ---
> v2:
> - Remove the check entirely rather than replacing it, as suggested by
>   Harry Yoo and Lorenzo Stoakes.
> - Added Fixes tag.
> - Link to v1: https://lore.kernel.org/r/20260407081442.6256-1-komlomal@gmail.com
> ---

Looks good to me,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

