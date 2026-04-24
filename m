Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A43BFED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CC86B00A2; Fri, 24 Apr 2026 11:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64986B00A4; Fri, 24 Apr 2026 11:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA17D6B00A6; Fri, 24 Apr 2026 11:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA9586B00A2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:43:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EEB688E11
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:43:01 +0000 (UTC)
X-FDA: 84693867762.17.5CEEC8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD3E380003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:42:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6ryWYr7;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777045379; a=rsa-sha256;
	cv=none;
	b=XecJ45/MRSbF48RPqhMHMxDrXrEYENCgvbeq6OWe7FwfD3F2X0MNTSI5sAuO0QLeDA6YnD
	opGO9GORj55ZulXQO6vCP8vecgqNYIUrJAmkvBsSqsxY8qWS2m32D2oF86g7yu7p/zMync
	nDoX/CWAJAc8n7PY6bPfO5C4wCI0SoM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6ryWYr7;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777045379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmyuuW4BreNkPPOMqrGtbTE5hoLsOBMQFeVplDAHz24=;
	b=0lDdwUtMBiQzjQoO6BVHwUzJPmxrqbafusBbZSLaPgRm2SIgIqLXdKAqJLPzZgya0ZEWQ9
	CaNcPc4KL57PDbhoScozbDDS6K6+uicNXtNrJWxqe9Bb9ehbcDWf2sZ1jVr204VxhOM3QW
	VYe8LX+ztr/fWDPauBD/ppwjWDpURQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ACFB60123;
	Fri, 24 Apr 2026 15:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA232C2BCB2;
	Fri, 24 Apr 2026 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777045378;
	bh=VmyuuW4BreNkPPOMqrGtbTE5hoLsOBMQFeVplDAHz24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s6ryWYr7VoiHmsU/LPEaQ8sOkbImRYH85BnfbLA/D//UNSCaO1+d1Z11op+4YpRTc
	 DjYiOy9e7HxQLvmyF1CEtEu8QTzBqrr+Z9uWzluXiEk0VUw0Rj+kYHhxGE1qS/44vQ
	 A/WthNXRAOeTJwN6eqWE+ZnAb9HW8giJB2DBYn5NmrLCPU1nR0Rmysrq9cTekCwTMx
	 WjWZv6QkQ+9OJOvZayC34Boy6gEsTxdVa+P6vRS/+us0IWy+XoQ/Jg2JXZskdaFZlB
	 sznsHHpLQkVlL/K1Xf6e2zDUkp1hLBdzHl2uf474/EYictMBHJFoAn5RDQIXC0Kuk/
	 epU9q2XEJSzPA==
Message-ID: <b001932c-e376-462e-895a-5e4a9c7c0dc5@kernel.org>
Date: Fri, 24 Apr 2026 17:42:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/7] mm: dual-bitmap page allocator consistency checker
Content-Language: en-US
To: Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, corbet@lwn.net
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, skhan@linuxfoundation.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260424140056.2094777-1-sashal@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CD3E380003
X-Stat-Signature: rcxf5xo8cxypusx9idgsimck8c1dd8so
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777045379-490153
X-HE-Meta: U2FsdGVkX186Xm+zvldoKRI0P15fWMCXEvzWKTHWJzTbXT3MeLRBYRBCIxMH2DHSkIirv94pXJrKSTPoPUiPXkavx8tLU0m5S/JP30+johpM7P/OjKSSGm70IeHiEADyVrkqHqTyMgHNoTb4CSivedHGuFINUOsAlbDQ+ODge0Kz5xeF3WRdK87wJxDCzZKKggLI9U7/ekejwcWI1N3Kb6oNmtGSx309XU1BoyDHRzbcbgDxSrOE92bXF8IdzeoplJEj52Vwa6KWL7eWU98McebRGtVkxz+6ytJhRGd5XAZco+qrUUZtRe6EkBPpq09LKG+mMkFmhVutm37eHnZVoJm9nrCd3WVp1oFixdjbBSc4rGjUnjJ/pr8WVWBUjWabvZKdO6JaC/TCbB+g3N0nvzrWhUFVqAMeXt3hYOKVXhksD7HN/PgNnWQbxP7NY7Jf7MnhMU/sl5pbidLtL/QjTdrJ64QgnNHHJcDUC+FORrCYsW43POsMby4IHSYkna/K9QKbYxT2ybP7DzGaWkTDAgO9OCN9maMTYFB/qaEvM0n3BOit1KP2eS7Jzj8J/A4EATs90b4eeqE3X+deSU/wQusUEnkKdu5ZK4WaGLETKr8lUJwo+Hc+F+sCMlqyfejQB/iJVldn0a0dUswFaUX8EnTio5OIZ+9lr48JQWpEqBq3a8cou414M3qXx6wcYhy0VQMOI1GPgoUv7pmyDyTvrLv2hJ2qWCDiwACVPLeUCjBu/rb6EAUdAlkNderaA9aC/YoyHkUN8f9YW1lLKOJdadxKahFWB+W7YWEqe38CuQ8t0Js8nEkBw120LMs1p+e6yRJLPV4B7Jtzk8DWUhhdooBPrTi0pJuEh0XdD1stp6lvoRt+I1p1rjECBpu6JSkHZDE5v6hkhGk4hltGV2XCLCOqFi4FEQskwqbJGzm3+JBtJE25M8Kh5h1KU6dtZBtkJQeHuQmBECJEMhJ2NDC
 l2TuThEC
 QeWW18pBtA+c+NTLFvMLmyLZ6xgM2RJQwwEVqUozUWeQLzFnxZS3YJeaxnJpCxSN1byT/u3c/8hW0NqAnwLo6tmgKDaX9rO1e5C4WrwN5y+vAfFAsdfVCgWYOQN4V8pKMbyYlICNsT6zosxkKqV70RYUpG/OIZZi81LYxmNAPhFprM6CPZ7R7mJOajb3onUJJ25+Fs7fSVxHRPOlAJdvw5cGuRK4hekcLq397it0vQpRdVHkZ39qqNgZ+sHhiwMkoRjyh3xA2EZoV5oKMvZXQFQbZwrcRUoiLdB7l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 16:00, Sasha Levin wrote:
> Existing memory debugging tools - KASAN, KFENCE, page_poisoning - detect
> access violations and content corruption, but none of them can detect
> silent corruption in the page allocator's own metadata. If a hardware
> bit flip corrupts an allocation bitmap, the allocator hands out a page

An allocation what? The page allocator is a buddy allocator, it has no
bitmap to track free/allocated state of pages?



