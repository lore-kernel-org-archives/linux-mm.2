Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A07CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 21:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF69C6B0007; Tue, 19 Aug 2025 17:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE7E6B0008; Tue, 19 Aug 2025 17:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B806B000A; Tue, 19 Aug 2025 17:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9296F6B0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:55:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F3C6B7BB5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:55:35 +0000 (UTC)
X-FDA: 83794864230.06.F5D3314
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9DA104000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:55:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N8x+9Y/7";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755640533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FI6zEPZ/Vnwy4I9IpKo57a5c1Z2QkR+AewuIAbUs0ww=;
	b=HcJnPvM0KM0phHOYiWFlCb7DRq9XSLJUkZ/rcgQDCgNUzXvPFitkDuQyeP9/2DPtFc/s0M
	bRonvSvFzQKRdpYys5QLUYUqNhT0w1i4DacVBGHea1D/ktwCUhJgz+hYa0DoOfuc6Mtn26
	FXA0rK7+KbIxSBFoCKqc3Yhz4XaEjOQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N8x+9Y/7";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755640533; a=rsa-sha256;
	cv=none;
	b=7/lUxeohLnUcgTDaedvL9Qnf9Y7+I50+LPEzZQDaFk8a2Kv0Pe0YB2Ixi1knKz/StoRQZs
	rBLipafA4Ok+R2/q50oU+YowEmGOm1nyuusUewxBGLF+nDmAMOdkYx9zD2h1rd1s3scANn
	I3Synq0B8qTwWX5lsz3J5BrMZmsmpH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE71D60209;
	Tue, 19 Aug 2025 21:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B02C4CEF1;
	Tue, 19 Aug 2025 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755640532;
	bh=3vhU/lMCE6qPR2EWUaInpiU26gw7Ul+uR3Zkii7rocM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N8x+9Y/7FBWoZhOXJBckURArIzGN8dv0F2x9lMKlxqAuLh7RQOs6+rrwT0K2w8C7F
	 1xduqjaCf/IQHqRP2YjyiSKtK7UwuskcUM6PiwEY01gMzLPRQzJKGjoX/fjFZ5Su3W
	 SQPaDFbGrpK6MNkpB9lvWgfNKdwxVlAtqAjAJOoA=
Date: Tue, 19 Aug 2025 14:55:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Message-Id: <20250819145530.243e02184b743eb9ec506856@linux-foundation.org>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tjsarwsmmxkbb7pz93up3ygj4a5h3wjy
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DA104000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1755640533-79547
X-HE-Meta: U2FsdGVkX19cIABPFfbnRL6x5XU1QG4K/fyY8foqp8Sfp8TsfceoPKDCKJK7qlXNdKyrBhLeoPgit+jZmEj6837J75ykVMSIwYJ11F74EmdPRjcB1Dl9ASWFG+9bkcCvespAzhCjdZWay8TzH3p7FoBvkjul3DsE/f7SUQRDtSAXrsgXfsw8XhssQN2LPLU9dNfa8Z21mtd8B4fsXflpYgaWLGvruEqY2gr1KDg1W1zS1frFHcNlaEu+VtFeFDnrIVNrleWlPLTKr49ULkYYgN0Nxe0Il4sJDS5hUzOUqVwh+j1Szf55uHiHsi+6nzbSgLlVFP4VrYQhy4piGxO9Banp0ip4ErFjKEETswTsCSgTdk4MN0T55nbvHKcuAKnpXVj5xYlre3vTygsyW5DccXTW61d35qQQe5T+85EdDwPoRCFkKJlLSeYIqBwyCxDadSy2TbJKBDgPb6sjKKHgb8J1DUC9un0cN1OZIkQlhvWJX21kc0EZY+fKyejYc0DZqtIAzPC6ZVET1AK0fXJC1hZR/SBlU+YK9d4zIweKeZrc4AEydz+YCr2pYpNvynxho7KEWHzBqjLUjqpwO/rOUo0Fim8NZw1jN06U5iKP+/J/PYx1hiyIvsyPaCmlbnoRnmdOOr7a6dSpxfOq610ccF9jvc5eP5Nv1hUbLA6mmBZcmvZ6rBW2yCmgPr3oFS12zef3enpBw8dMtZuciKvytjh0dX1F/YcL8WA9RvWJWBDbNyy9czm3EM32NKInTZwfvaNDgx1AxEHwe3ifqeXeuTmGBq/FzyKoqFahQilBuAFoyMSN+Xx4RuEd8hmStZOo2lGggfA6ZZl0Ctm+2Fu1AD4CpMVBxbjozNzrCrAvtMOBDAJstbpdJ2ZogDrOCKlmXGa1laT11VduyYFn7sTc7lLGDjzWF8MVKmnHUPRIR8xr0W+/PkRYzzjwbYqrGVtV6t1ZqcZMAzOoFk7CEob
 C5Ac/3Dy
 HDl4SFHIAEwT0XjVAE3KGgQZmt+vz8uDck2hRcA4xNM2E3q+sd2C/GYWEld6BoF8kVVu0oa+N4AmoX/wqCotSKlYmLzXLhDkjxwkMMnwfGOi2QeYcq80AxLuaUAG++xe9C2mQ90BUVZwnNLrWUzSbjZnMtDgoTXQPDVse5hD+pc0JK1vi29Z8kWz+m8on8KLoII4nXh5c/o1FxWNIYY29RoFXQj2rvAznJ5RtWQYZUTADq6ACAxcM2fGQ7O04QD5PZMymanur4GVGDlBsvUaIoMi99jwJzCfYh2zZEHnbsNl+24SSKLJtvOFiIiiz2VJ/w/0DFesNXVUB5iKmwAstzz5LTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 07:41:52 -0600 Nico Pache <npache@redhat.com> wrote:

> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
> 
> ...
>
> - I created a test script that I used to push khugepaged to its limits
>    while monitoring a number of stats and tracepoints. The code is
>    available here[1] (Run in legacy mode for these changes and set mthp
>    sizes to inherit)

Could this be turned into something in tools/testing/selftests/mm/?

> V10 Changes:

I'll add this to mm-new, thanks.  I'll suppress the usual emails.

