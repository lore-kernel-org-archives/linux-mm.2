Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF62A606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ivta/5Sm
Received: by kanga.kvack.org (Postfix)
	id F17E76B0647; Thu, 19 Nov 2026 17:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC83C6B06AF; Thu, 19 Nov 2026 17:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6906B06D5; Thu, 19 Nov 2026 17:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2E766B0647
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:35:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B25C712028F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:35:02 +0000 (UTC)
X-FDA: 85453325244.24.E16513B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E2E3B4000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:35:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ivta/5Sm";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795127701;
	b=vbsHkaiczK7ZjQDqUdSAXxWhQ4KjQZPMvr992JhIN4PEDDa4n/GmZ+rxvK5oZ4kGRCzVe3
	XFFdfjMN3RB3rlcovUjZ0X1xAu1v8EmUr45MoidSrZzGxah9ypKKxneygzGJFkPqE2N0jh
	JXlaTqTQEiui7z3KMHrcpF8NWxyPN4I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795127701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/Tsba+US2saXc4scokbri4jqCK5jWopUIlt1PbYkns=;
	b=7tf+ONrTY6RYII6fIV/YYjsecdQmCq9rZU7+QqjFGjlSzumCNAlNM2gIU87YelYgKArjqq
	23YKA6ThRtArdJ/UCnYJcTVYYhO8IxRxYzguQvi5p2y3fsyIykyHqn+rKqXGzEaWY+0wvm
	PckuUjs3hGtqVs0+n7xeFLZN6UGXo88=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ivta/5Sm";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C0EB60D41;
	Thu, 19 Nov 2026 22:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769551F000C4;
	Thu, 19 Nov 2026 22:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795127700;
	bh=w/Tsba+US2saXc4scokbri4jqCK5jWopUIlt1PbYkns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ivta/5SmkrWfILNrJ/e/Hd1LY8+RGtUvkSVgRez1s9Xa67n2M68Uq/X0hnOKwFdhM
	 YMmzMQPz+Pul+BDlNf9vPT888cl/Rt7AUjrMYtzPdJX4B7jDkAtszOhACpExgO2q85
	 LY59k6X/109VhGfTVoGHA4sXhebdiLP+A/d6M2sQ9oOTejLs/VcOJXOXHd7l7048CJ
	 c3RWIQ8Y3XVgO3Q6HTjs+p7lBESwNbjYU+gd4ECARhRab+vrQdo9qXzxakRMvYVUF8
	 m491+/KXgECT9N4/4HkbILQYiOLo4kZ7UKMIurKqjYUvRbL+NvBcnCbpkJD25i7JMC
	 HljpYmIR6H61A==
Message-ID: <8e56f690-7031-4a57-abdd-a02c1c94782a@kernel.org>
Date: Thu, 19 Nov 2026 23:34:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: skip temporary folio allocation for anonymous UFFD
 missing faults
To: Avi <thnkslprpt@gmail.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, liam@infradead.org,
 mhocko@suse.com, surenb@google.com, vbabka@kernel.org
References: <20261119180015.933433-1-thnkslprpt@gmail.com>
 <av88TW3GQRvXJDwA@gremlin>
 <CA+jvY9E3XD5mJZ7V-+6HFxEkY1FHNGom42F-nxMZNGtOy9POqA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+jvY9E3XD5mJZ7V-+6HFxEkY1FHNGom42F-nxMZNGtOy9POqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E2E3B4000C
X-Stat-Signature: esnz9fsi6ckaaj5qau3xmwyb4j41zfy5
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-HE-Tag: 1795127700-975059
X-HE-Meta: U2FsdGVkX19pFbbuMu7I8Yl2HacmmuOkp8FWC+yEaSS8GsncgF2SsYpW3a6WGJrfUzsGu9O1j1MKup5/2I0NKz1v1Sq/A9BdjnMkcnXVs4X0CzBrk8BrWnj2FQauF8+HP7z3w6ai4jsjEFpocAmZzaI8hV2IPQ9oTHnbKjb7hIP5Zk0Wh3YENqab5kSxT5eO1u9zTHpnjeKcAezKbYJsJpiBqOlrNVSTUzj+T8daPg0+si8Z0YFc4M/RXBoN0o5H8Q2kqOcbm9BNYKaoVgTw6xj4hmt5nfpaNpHCcw6LAfF2kQXUU3uthzpTZ3E5LJdd3xjG2F0SPpUyFyStlGdGsb15EIk+L5VsZa9LNRPNcvKkqj9r2Cfw9FDbIvbnhMxt0yNyWcmazNrAbipwtVWPKfHPXX3Vd+Jm8MNbtUTN7jnftvdfwmz13icQE+mciddYQagzEXcniL88hHAXQK+V53lRMV/SQtDPC7PU7nGzhJ+qoKfqpn/F5/ChfmXjUYvN3GJG0RPjU12rIJVDs1urDO60cePxOXcBAcuwjKkIvaLkx26ttXdKjjFAzMPMElvzVMSfUyd5yYjuE4DhbKL+8rADpmIL2+xhFakTvhRvPKtDfIijQtho4Ff5PCTTwkmtW+FiEctcFh1i1D8IEjhn7yd66j5Nan6drPtTs25OZEbmIsTdvSYsV9/1IpPz4Rw1Qw9oIgZgcyA2YIVv8Xu1AYQzirdnKykGo78h0tF/NJdm6v8NRGzFp566vwGpoTH0G7XkdYELcSPmXPMKshE/5mfBhqaVXQlyZaWfX2xjyOlS6V2X3Vhp0FZq12Lm6LHIyaJfVPQIRJt5N79s/ctM19qajB/IBPvSBnyqsh96qGEdEVBlwlbPgObtkkkRNH1WtXPo6w80KJWVB350qKQxOnovMMhbtAgIltJo3a1CEjfke1UTYmC7xYrOP0RfLzsnbO7WLmxyxQ6BV351mNe
 mq3nkn3f
 o26ss1W30sJPySJl/UhwL/9BKimyCbFvH7Owzsq3JHTvN8E2Pzbaw5zgMNNXM0IzcM2dmwrpKYWOdtONGGeQw7JiYo8H0iyOC5yUCQKu0C3wP3RYAtiqckK3DbayJDvx8b8vQrjpiPZN8pe2zSNjnujzWORAx+P5di8I+QYd+YjDzWDY8NW2ZF9vTjnOKetZu8stXmnbXQjKNDcDlPc+y2xRFeUi5RjeAiWAYx5bnB4TcBlQ5XqedYOicCyyod0Kc5J0M29XOjCpXSJcDg6URommTHZUmEXTV95LWwwWnuCTgkXcxXJRtsE8x0UWZbDK7MFAUpTNgHXqEo6YWOIY3vkZ2ceEMw7qeGgr2++20Fg+e48XOY6pU+H6EryX3KJr3n0/9/V05n0AnsUumLocPmHQdQrtacAtHr+N4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 20:31, Avi wrote:
> Hi Lorenzo - I don't think you are in charge of all of Linux and can
> decide who can and cannot submit contributions.
> This is a legitimate improvement in my opinion - if you disagree that's fine.

May I ask which workloads you are running (for customers? etc) where you would
care about this improvements? IOW, the real motivation.

-- 
Cheers,

David

