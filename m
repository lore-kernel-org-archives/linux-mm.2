Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35710CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C896B008A; Thu, 14 May 2026 06:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED8F6B008C; Thu, 14 May 2026 06:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802836B0092; Thu, 14 May 2026 06:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCB46B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:12:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13F534024C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:12:50 +0000 (UTC)
X-FDA: 84765611700.02.E3E918B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5EF364000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:12:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HdeNTHX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778753568; a=rsa-sha256;
	cv=none;
	b=0FT4yI+xXzR1YPePBKUa98HmrHSbXGjOHzUljOj81bjrfD2LglcL8OqO8HTwkHkNT0LABo
	ausfq/nEcQ23bJ2HLqz+Khy9KTZudwmkYtOmPwbuT5EvOUFOKivKMgg+HsZeWePi5d6bbU
	K16aOIYrry7pqwKvvK0vrwCok34Fgj0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HdeNTHX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778753568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+P5GQSduH5gCUxDUzDTSCOfLud+yILBGh+kjWQ8usc=;
	b=yQueNNBgXnH1YS8pHuhGlZybC5scwWr+pP2Ft+YNCpgPhJpLJfSiOOHamEIKWTV/0yrW2Y
	ynXVPSAEax2X7uwWeWEldBDPgx7SQyBtujBeGzV13e4+8R5TqvkLUzbjaczF94XlC6Ax5I
	+D2uk/bhogzPRrc52zKqp9bc4TD72W8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7812B4168E;
	Thu, 14 May 2026 10:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD7CC2BCB8;
	Thu, 14 May 2026 10:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778753567;
	bh=pfbw+RBzRHc2kunDFtITjU+w+fGcve7D5Lz0mX9TkvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HdeNTHX5M9fbJ9SUhbD2/sqXFQ55yI21JqGuVHCv5lZSIBDq+rqnDB2khZ8WIUi7W
	 69AlVMLKN9B4MdZqa+9dlXoLhBsU7GIH6Hj//G66IbQS6I35zHWBtVSImuCoccBTyf
	 PVOVDOeT2F5PS+OS45GI4EVFSLVBTUIGgOI9yuqftfYVm9dahz8TVQP/mEjfXqFxRV
	 4cAXMuUHCEQdPjWNy/MIm6C8v5UCcos9BgfgRqW8OF2narIys3+r0wEoqT95+uAJdg
	 6AI6USubWkFfFlGEBDN+vr4l3vSJZ7HOkKcg128AfUPZXLsdCrKD7gmfFRQmZf71H8
	 7U1Cw78WZDYvQ==
Date: Thu, 14 May 2026 13:12:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: priyanshukumarpu@gmail.com
Cc: akpm@linux-foundation.org, changyuanl@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/memblock: fix stale NUMA reservation
 tests
Message-ID: <agWgGUDWRbXM62nz@kernel.org>
References: <20260413091458.774770-1-priyanshukumarpu@gmail.com>
 <20260415122731.1768912-1-priyanshukumarpu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415122731.1768912-1-priyanshukumarpu@gmail.com>
X-Stat-Signature: pj7nguhyub8y9h4d1cgqpfrcgb4pc43i
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EF364000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778753568-45461
X-HE-Meta: U2FsdGVkX1840pJImkrjmuU0kH/ZMZUxYubZcWg3TTgTcrKbj0MrJBT83BpusRJhEa45Q//DjAhTr/Yd1FccXv8Ax8RlYmJ/fVpsw5igimul7MqmvGBMOjiZSZJH9gofJ9hfITT6UJGalJR6xdBkSThRbCN6mYueoWDPfu3F5mWMbQ1n5lyDOBEDPgZsb2vOSPhgE7nvU+apNCZQ1+fuIKRxKqNMzdNnEwR+SYxauifvwBWH/oaucZ7JGINgUlfXb0AFRjbk1u+cXA3ckc4xKJkJReV4Uo64HI+LnFEeydJhy2XgySz7G2J8hB3eHO7S4nscN/kXaLt+LQY3fu3i1joAjQElI3Ly6u9FE6mBpYK0kvMXj4WaOcjk1KVAr+x44O8colI4HxonAOKv2px9o6d2UcV8ZcA5YVpUsmyTygkk12+nTKnyeVeL54s2qliPZYFxw+1IIHNsBZ1XA1jGeIuzXwJYQNdVSoE8AhLBRQj/UvlkkJMIL/iHncsDZ2VwSxNZR9m2ox5FBpR1/HUqQZWuw3orzN6hlt9dHY2qepNQXgat7mqm4fWcBzY0mATd3cIagNcEuacc3HfGxJbccbCaRmXBlqVxykG3NmlRMFt8p7oGI+Q/ti5h5ujYSFUdAyePoO1eHbkUIfcsQdGgZQAwH9TGVPoOFMcRFwmuo5Ci3tj1JzkEyoETItGmvhwg1/6aIGkqeuzUFAhrY9ye3DXrV+xuZAGZZx8XamdgekvfPrDk8oOtV5WBRTyn5JUiWghxru66Mxs01SSW1/lT32/OWgQpSAArRUEZa5gNzjhuGoCI4lgshVheYfQLiKfUYH4bd4pc15TfUeBaiXkpyav4wIKnTYKrVsj3ra9hMzscM8+CInHW5if7H044A36pujCUtK4wOApjUZ7yk1VSztZY1xOUB/dWjhQ1vPHIXNniTFZqjF9s0SBfYYDpRdJEOJ4ff0xczj+8Xo1Ip6E
 Trka0yTU
 9arqEBnXzJ5/LV5kJaQRMX0aeyimgUFnJMdPq2C9/hwqBEWe6AFt8vmVkUMg/uDrCGr8tejwc18EJ1sYHebqUFSl3fOnTy4+9E/uqUlsp+UmJD5Ni7tte10jJ38TUk2QC31J2PoKk9nl65u7QWKmP1urFUBXgw66MsPi8WyU1WrtN63Srhtk+UzlZaZzaC/QNaAq2YVMU/9waQ0hmwCl9byM59a6xjq51DhGc7IHgxI2rCUR9prvgLoBJkdTQZ2OATnQbxjXkCj2/i6pHod7AtCLBag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 12:27:31PM +0000, priyanshukumarpu@gmail.com wrote:
> From: Priyanshu Kumar <priyanshukumarpu@gmail.com>
> 
> memblock allocations now reserve memory with MEMBLOCK_RSRV_KERN and,
> on NUMA configurations, record the requested node on the reserved
> region. Several memblock simulator NUMA tests still expected merges
> that only worked before those reservation semantics changed, so the
> suite aborted even though the allocator behavior was correct.
> 
> Update the NUMA merge expectations in the memblock_alloc_try_nid()
> and memblock_alloc_exact_nid_raw() tests to match the current reserved
> region metadata rules. For cases that should still merge, create the
> pre-existing reservation with matching nid and MEMBLOCK_RSRV_KERN
> metadata. Also strengthen the memblock_alloc_node() coverage by
> checking the newly created reserved region directly instead of
> re-reading the source memory node descriptor.
> 
> Finally, drop the stale README/TODO notes that still claimed
> memblock_alloc_node() could not be tested.
> 
> The memblock simulator passes again with NUMA enabled after these
> updates.
> 
> Signed-off-by: Priyanshu Kumar <priyanshukumarpu@gmail.com>
> ---
>  tools/testing/memblock/README                 |  5 +----
>  tools/testing/memblock/TODO                   |  4 ++--
>  .../memblock/tests/alloc_exact_nid_api.c      |  6 +++---
>  tools/testing/memblock/tests/alloc_nid_api.c  | 21 +++++++++++++------
>  4 files changed, 21 insertions(+), 15 deletions(-)

I applied this while dropping the changes to alloc_node_on_correct_nid
test.

-- 
Sincerely yours,
Mike.

