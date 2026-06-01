Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBE6CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF24B6B0255; Mon,  1 Jun 2026 01:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9326B0257; Mon,  1 Jun 2026 01:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06886B0258; Mon,  1 Jun 2026 01:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1A346B0255
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:12:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DF3FC1E7B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:12:07 +0000 (UTC)
X-FDA: 84830172294.12.7AA773F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88A1FC0004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:12:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OGlv3KFX;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780290725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xT2Cpt9BXheyCn9ilqNOQhip0PoCPkzMc4D1JxtTXfE=;
	b=79dNXIQ/jNiCuLJo00ZMUm5BUquHiRd4l1qMRSCQBqOLC3A+yjaj/rZYV5EL9mXGVo0kCj
	6dkL3W62gHHI3jaZZjuQ0OCrigNXSkz6h0fg5QvvyJoRcqU0prx5YMOXFrJTYd1/COTHwf
	he7szN9xs1Tj+Iqomax2ips8Wth0ZSQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OGlv3KFX;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780290725; a=rsa-sha256;
	cv=none;
	b=nyuE+/NgYQLKzCXLsQvjTT4v4YEykLxWzQJX4EOhc2ganbb3uHYRL7aFMCjz3mwxpUEXFE
	atqxLLL1UWczDv1TJ4ltdTqperGNBoljwM/XSDIdQGUzKAj3jQgqMTIbAMbyXKFsaBfQjr
	4wt9dhBPVU8nyYSFbw94keNE9btbLac=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F1091E8D;
	Sun, 31 May 2026 22:11:59 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 557133F905;
	Sun, 31 May 2026 22:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780290724; bh=RQUGvqTmw4Ad5VHPwPPgvxBlVO6BZKGHwrCg158WAoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OGlv3KFXuql87mAXxRK2wLY/ouQd96qIGs/u3Yob0U0mjEJjADk5z0ldj5rl00HEb
	 1+Gq//BPFSShXsS5qUpW+C6rWTB6+6PPjaVHFqjK3o0vnc+nuaog+TGW8f13/QcZDT
	 rDVLdCmNdPq6SkCJMI1J0nxYMYXSpq0F2j6cPKTI=
Message-ID: <3e1c2b9e-83f2-4740-9a8e-e05f564f37e9@arm.com>
Date: Mon, 1 Jun 2026 10:41:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/hmm: A fix and a selftest
To: Andrew Morton <akpm@linux-foundation.org>
Cc: liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 david@kernel.org, shuah@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kselftest@vger.kernel.org, usama.arif@linux.dev, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260530085413.1270139-1-dev.jain@arm.com>
 <20260531122458.864e9deac7425e1b71c14f3a@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260531122458.864e9deac7425e1b71c14f3a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88A1FC0004
X-Stat-Signature: p8pgxasb78utbki8efccmxnz8ej4k5n8
X-HE-Tag: 1780290725-825239
X-HE-Meta: U2FsdGVkX18P4emk9Yc5Td9BDqXb9vx6LfPRRJBAoECZ7g6DEIaKhXnea7OPVyaT5fC3ZR/ECipthGJpARfvc8Ij+CAr8CHv80TlV2GI9zpPO5x/JptfrAbLJ8XCi45lUVxs2vj72Et78Bj7d0zbjUe9UTp4D75ZsoDNqhKQKrTVN93DSnUXMPj/QFuaMemJTOXj8ndR32D3WtoktHnLILGm7k6wFTote8HK/tJKZcqxkMjAykYTF/q89FKB+TIA2tlx1cMW56hWsnDq1BjKGm02Ub+dGd93KNwpFtLq98nMoGbXyFUK3klbQkeiI5RBs4FUgEVoSCULGATy9a+VlcSrYbWhNpzbzxShmXj0vEIXZL0UW86PRQNRN2f8QvNIO6BayME8vUbAXGXWg67m+I4YQ6WjqUuLZ456Ly/wZ9/ENVyeZ/BvaIUZPsGeJWDG11fRXI6qDOfa6gah1iQbqL+zV0qyQ+fAKFFaq/PN+QgGFTFuX0O/ZdlUaD65WRemy/EDjE6N3LDJr1VHJHpJTRALQPSxxiO2hGZEOZgcAJAgimP4y67OMmM5iS7tZMAks7QtG6JGrRbb3vQ/Xw2c2rpRFzkXgnCrvHogs93MGrOCwsnjiDCZ4a8rDGbhVXDF8Sw+Mz5ndlukXH4xrj4PsPIeWaHPu2nrVXEEB/+NlBekuozIbj6xqiMLE6Bhsyek7cJbG6oTtXIzWBcHDnsPEdjlMvoP0W0YegPW+nM5V69ACRSMrTDDAkUzU+0b7y6YWtkVf1TYCUen3ygh7a0Vuu1XepdVr1YS9PPZbDXCPHGLaRCtMxj3vT7d8151adpatLV+4JXoxxeCiDYvTP6VC3fcRHzbFHgOtpuviOjM1D8NSSOV+hE/TwpJpeLS8D18JZf61l/huDfA4tgC5iFs4FixO81o6XHhJU7X3HNvG0oGrcrUMvC0N+/YYZs+2ep8aH5Tf/g/KGkX0OqruIJ
 XLCsjf49
 llvKh3EY12OYTROJzoDttseIGkXZObNrGJ75cKutRn2VOt/mv0i+n7rS8Zh7PjT5ssusHcknT5amTuNJQrQ8rXezD4gtbKyGFc/NRs/8JCyYAuTg30ANS8fUiU0V5CuYYksKX87qWWTyvnl83jtaloeUk3GoAvjRqt+BCVN/Cw5uer93bJswW9gmf+LBvOYmsIJxcdare6wTRODpaTXf90ZMKSaNXeU0m2U3Jm1R5Bz9lR77tI3vlLnmU3B4ebUiHjTnz2A2R108ynnIReTyt6OEFN8CPhDT3J9QyN9x5KZvKfQPPm9AlzndXlj/zCLt1fpvwc/9HSY/lXEr70kirjmGbJFCOLJUOS8se
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/06/26 12:54 am, Andrew Morton wrote:
> On Sat, 30 May 2026 08:54:10 +0000 Dev Jain <dev.jain@arm.com> wrote:
> 
>> Patch 1 fixes a stale warning present from the time when only migration
>> softleaf entries were supported at the PMD level.
>>
>> Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
>> for PMD device-private entries.
> 
> David, I'll retain your ack on patch 1.
> 
> Sashiko has a concern about the selftest:
> 	https://sashiko.dev/#/patchset/20260530085413.1270139-1-dev.jain@arm.com

Same concern as raised by Balbir.

