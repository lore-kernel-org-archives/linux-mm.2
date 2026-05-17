Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE75CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374B36B0093; Sun, 17 May 2026 14:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3253A6B0096; Sun, 17 May 2026 14:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262396B0098; Sun, 17 May 2026 14:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 183926B0093
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:59:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B405414059F
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:59:16 +0000 (UTC)
X-FDA: 84777824712.11.9045072
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A25F120008
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:59:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EhLEEUhu;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779044355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Csc2EOUnK8577Uqh7Gr3ZK6EyQ7a8L8fRxqRpOAL5zY=;
	b=fAowbkdwOzBVWiHau+gJjZFsFu6rlPqpOTD6i6XLrky1xiIbGFKFYT4TvuCaLZFy1BN1oF
	FLE9S6Pk/Jkv/CJRhgFcsx8GV/S4hvYzVm9QhT4yzFcB3tThHezDmgzo4tKWpBA/w2Xa35
	N2aiEized+1zY4iR7L+De4mE314fJ0Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EhLEEUhu;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779044355; a=rsa-sha256;
	cv=none;
	b=7EF+Wpc0EehY0HlNCj/HzfjJ9lwWYuSFzF01oOzLNQqS2ofj4HkXfpPu8HO9lRFBSGvIt9
	Gx4VhAYKgzPXG6a32g1DJNqXlJsRJk8R/4Nyp3IfnYzHMGHUMqPqIAQ5xPvoZYcbj8gEC4
	zSQQchoHmIuxuHBLGPa4gpKmwfi+WsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3BD441E5A;
	Sun, 17 May 2026 18:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8EDC2BCB0;
	Sun, 17 May 2026 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779044353;
	bh=TxClM2mdGfWD4Uq8Jpf0PPjMaqVPLXry0mgG8pyL1ZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EhLEEUhu8ngvP04rcdO1wJ6msWZdfCnY5xxRLw/j/qz9RmVQey36HjQpIfxu/Nehk
	 44aoIxHUq3YL9Q1/FjhIR53EscyofY3edMGdLKzx4iSJTdnk2Td94s6P3VMXzkLpGP
	 Wf6MIL7TvRBTcvlRAKzVSp5IqVoD97DGt7vgdx9WCppZa2PGwuLEs0nljOljWPwmsk
	 wuApHQCHaO/eGv2m/snfRZ3E+3MOY9lCQTIXOvRKFrcbgtUUEBLKb5OaCwVbc/ZuXr
	 ElqgLB9hZ0K8Bu1QWeTwQznvaCXcxXExxJONawuQuhelSSy303CUlmVDr4Es6VtZKH
	 RYBOog/QFPn1Q==
Date: Sun, 17 May 2026 21:59:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC V2 02/14] mm: Add read-write accessors for vm_page_prot
Message-ID: <agoP-QlSeVgISjCw@kernel.org>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-3-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513044547.4128549-3-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A25F120008
X-Stat-Signature: zze64mkf6cn8tip5yku3747uszsqtpi5
X-HE-Tag: 1779044354-517240
X-HE-Meta: U2FsdGVkX1/nwT5sfxBCBBB5M24W09nF8NkpvyneSySW2rt9CGw2WBil/9iv9V62ZAobgMPTP9DdDfyeALIqrRdrTxX/dopTUTjR7VGE30MoI5OFIUidJm67dseG0d+Jsza8vjLK5TEWiDFfkDeNvQqI83A0KqPwptQjBsGJBThz8mpvoEMBybiNj7jjDY0Lr9j+eIEa7NE4tN202Y4zATNtFcA+UGwgklzBOWDsL+rCQ5OzmI1TT8EDJ8Tl3NewD7RoD1+ym6Hqy03aqFXp6/WvDQU1EjARi6fVZORhbMaBQRQba49YTdI9BACTT8VUc3z5iwFa0rQAtiCtOXF+2eTX1aI6QGfJCTeBZPGis5eQs1quXIt1oShOL1VLuWdt04NJcMjUEpa7gnPrYMVWn8qDuq7jmLC7+u78R+WqgzIbxjrlqyFQKY8XitMYIh/K1qDbhK7H0oRMcHO+w/ii5IY3Cva00IOEEe6oA8x494XUNTt9cGQ2vWVt22YIJ8l/sTrnZJ0u1QJDscsB8y8t/1yfS1CVFlR/GVPloFdW+cvPgOVp+1gXm6lVYcq4R/QTXAhlLtZXIMXGkQ2nM2/MNE2nMQyVDLlHkN28OFi67X15EzADbmE4SLY+zstE6nnH67qQ2tjKO6ngudRF7J5mj+FkzuCsn6O1o9gZ4kUOD9E+cE/n9rB35DEHUhTHihjJB60jtFkOMO0nmLM6fa0FxkHKDd/bAVdfnhyp6PpjkPcG2Dw09bx37kJc82XgiqU8s1fcYih6SZ6wMzLSc0LehEuc9wMsRlPPljXwc5gw9ZIaf/X+lHFmAq9vNnOqXpbgIF8B766jowIEsM2OmbNB0WDjQ6MlmQnYJ1FchpKbZ5h4F9DsATZC7clXy61lOKLWZrkTbvqyEaufH+Q3rU6QM7bVTH0a2Us6+u/I00ys/HClxl6MpPYh9nndD5vaoOsbhOyt04MyqovntMqz5QK
 NnF71eFg
 Id1b0kgH9bGgDkyMjabppi5vOVgekRhaVRVyyE610TK+IzUCTH7PPunzpLwMpOH2NxTAgJE3DKvjtE4kOWu3Kl7pg9LwbShKcaFW7qF3h73BcMbrddA48rVhbeoHQPt6Q54JEBPnvE4NwbKxeEDz3UHhDjoLCNdOLPRtOpcTIXycC8kS0XJYc2fFerAOK2MS/1t/ENxl3susatWkEEBjQMPHTRZ1UsUUDcA5V7ALLEOagdV5DjESy7Q7XMJsj6EmT3731jEim5TkxxhSkq5Ge9s0mKC/Ul1AKJz9glzhRXShuzBm+hFXXjIcVidSOsXL+YiSPeovrqI2KGNDqMBVMEXIDZDORk2fHb99Z7TzK9OdUxsSX3luLCV8mPUIJ9Rx13O4VvwK6qeuU2HbAf2moF2d1YWyEe6ZbtPeaqPiAV6+dbCqf4EfzyboJY9udCjN1xFGzj1zJzvKaTXz0D9WmiD+oauRddotMkWnIV5DCHg2B/hAFy/QeuT254KArNNgaO8KKvyQRFtc8MRiio9fCj1CE7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:15:35AM +0530, Anshuman Khandual wrote:
> Currently vma->vm_page_prot is safely read from and written to, without any
> locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
> tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
> be handled with READ_ONCE() and WRITE_ONCE().
> 
> Add read and write accessors for vm_page_prot like pgprot_[read|write]()
> which any platform can override when required, although still defaulting as
> READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in RFC V2:
> 
> - Dropped _once from pgprot_[read|write]() callbacks per Mike
> 
>  include/linux/pgtable.h | 14 ++++++++++++++
>  mm/huge_memory.c        |  4 ++--
>  mm/memory.c             |  2 +-
>  mm/migrate.c            |  2 +-
>  mm/mmap.c               |  2 +-
>  5 files changed, 19 insertions(+), 5 deletions(-)

-- 
Sincerely yours,
Mike.

