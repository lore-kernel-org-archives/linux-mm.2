Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F74C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 19:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB846B031F; Fri, 14 Aug 2026 15:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192F96B0320; Fri, 14 Aug 2026 15:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D84E6B0321; Fri, 14 Aug 2026 15:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB96C6B031F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:36:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A8F5C021B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:36:07 +0000 (UTC)
X-FDA: 85100880774.13.C21DEE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 627042000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:36:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="zsEUWF/0";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786736165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKwAleIaodXfr5GwDtgKufR0JVQd9KcvNehl9elNtAQ=;
	b=oJKImdeqFJ3lubIiIGfWnmD5erGGNaipfsqhu3e7CqdvTneLxY6CqEVP/Wlqgr6c28RR5X
	huUvR3w/KHQbYVtp3NnEBI4KrA87f9m5HPsijlYK0ymnYpFejdHb5CsRDbyXM6eXEH7hX3
	ROPfKTSgfiXAbh+KCddkh4N2gkXn0As=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786736165;
	b=L0rSgWNGjDOvRU67NLG8A0pS+eqOtbGOw1gnFeW+3NBXXOZ699ZNwAxiwdQkMJg8jKnSpI
	i4zf4kkF0ZKLcDdD7IvWM8vzfnB9s9UkSkp/IjRpXOqrtwPwGW66loxBQ2lATFyzm8nSbO
	fSIGX9x21kjaJIAruItLlfovQHTVYZA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="zsEUWF/0";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BEB260204;
	Fri, 14 Aug 2026 19:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E84E1F00A3A;
	Fri, 14 Aug 2026 19:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786736164;
	bh=KKwAleIaodXfr5GwDtgKufR0JVQd9KcvNehl9elNtAQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zsEUWF/0Y9lojY4C9wCl1hw0plqXyVIDHIsse6N/FsDveqQckboWTj+GtXdIYuCZn
	 tBx3oSkVKw4h185rGmgJQV/4H2XM2XOYyp5v7AxiJC45sMERSpx309sdsfokPbxJAd
	 NTxkvJf1zA6kvXeJnSfPetyPWx15B4c5XZRIORmA=
Date: Fri, 14 Aug 2026 12:36:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joel Granados <joel.granados@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, Jianlin Shi
 <shijianlin11@foxmail.com>, vbabka@kernel.org, hannes@cmpxchg.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/4] sysctl: Disallow partial updates of
 miss-formatted sysctl vectors
Message-Id: <20260814123602.ec6889355580da96958b79d6@linux-foundation.org>
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ps7gi9pborzfqz847c8w6dzmqw5sz91o
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 627042000B
X-HE-Tag: 1786736165-53644
X-HE-Meta: U2FsdGVkX1+kl67NdAG5ZAEfI5N0TAGpEJGZUURVq66FnFNc8hIqOh/lvxKbqj70zfVbY9et/40gJBGsUz+gGY05OB2rRFeezmnSyGKroGc+/3Je8Nwb2/sePlpRmQ3FPEapP5OCpGadPH0vN5pB2ky3kyLeyQgK4nWPC48fdsbDbZr0kY7K1L/RiOstVuW3njJj8MCxPvosn8ULlSRmna90tiBBf2TNvEGtznTok3y05HqFg9XOZCqJgEXU+zG4HZ9j89cJ/5YGNLFAqoP5Y5yyNLvnrDcU5RDGilUrCNiMWgXRm/1fHaDafpratReRYYeFI2kkwT/qhDGRVZZlD5iqt6zEU/d0XDJdh7X4rRG2KePi/KiYPVP4hfYykteKHgFf5y9AQC04QaP/CMzbnx63/ZzC11l64Ia57E+PsWGSSw63p+bWUtE3E9k97lFwMaS8e2whE78lqERExMcs1mpM2nlqBeKp1BhLzmXCVHv/3aOkt2PCZ4B1mVN/hnhizfRH4cUoIyOALEfb0dr12nFjGYyHgBDWZW27unavELX6Hi9HEs6h11Jkft0l6N5h7jS0TDfXQrxAc8kWnMUzDuhfvodHf9eTebmnfC97U+w9oQY6H3LigNrA4c8zfo41qfiPDEpTpyQ4d/8SHcj0C5p372ylbK7dl7v206iVBvyA4bx8TXYWKS5lodoMMSrElKn7vIX7Fe0wRRZ2+ghVWPfqPmoueY2VcCzRkpGRqYGplcpHnIv1Qdz8vGCAJT1xk+V5zYKa1cAM6ycGPn8ikB+OQ4FdTnUiceyNYD3MAIi9/ntWOaqw9aRCA5XvXThs6FfV1y/tcZTQ4XoWglmAc9dkoEkvcyii1X0yOw1BLI4x81wDmLvCo3KzRo2ZMk5hn3LORXJzZJCy/mT2PC0H4y4vWDQ6PaANCJnwKNAFUs8gqsB/KuBHVaL2a8idFODgvmdTFyfDbYVXFQ2kHGR
 ok9dQo3D
 ooGq2gjJIBvboEXI44Kj0wW23sMdb/V/z4MRsjuEkQBfHC+o12UtOME+MTQVGRHK4rmSdBrNPdLIKNayQ3tXCpZlKH+cEsGWW+uGHgfSRBA6lFO84DwCM8m7FkS5KEI+Fh0bPJe+7/AI09cIr6T6h9EcCRFoQDgiN8RASP0T1yQAHpiyNRoTswE48pb6vPwk8MwaUz4JKpdo9GN/TzeB+XlyxXiDwYYZ/bOqHbd8p1TQsSxHSsTYBFI4ZvyeNhrjy6kjnGmZ2ICPILBhT6FcY4NvaUs3QrBlu1QsoSOSWq+efbDpiHOJtOtJJlxNpY+tyuZDa/7XGnTGYC3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Aug 2026 12:41:11 +0200 Joel Granados <joel.granados@kernel.org> wrote:

> What?
> =====
> 
> Stage table->data when writing INT & ULONG ctl_tables. Commit staged
> data to kernel variable only when all the conversions have succeeded.
> This is applicable only to variables that represent a vector; paths
> pertaining to scalers are left unchanged. Notice that partial updates

"scalars"

> can still happen if less than the size of the vector are passed and
> correctly formatted.
> 
> This is the behavior we are protecting against:
> 
>   # echo "4 4 1 7" > /proc/sys/kernel/printk
>   # echo "1 x" > /proc/sys/kernel/printk
>   -bash: echo: write error: Invalid argument
>   # cat /proc/sys/kernel/printk
>   1 4 1 7    <- the write failed, the first element changed anyway

I like the change.

> Why?
> ====
> Allowing a partial change to a vector after returning from an erroneous
> proc_handler is just plain wrong. This should be handled within sysctl
> to avoid users having to do it for themselves [1]. 
> 
> Behavioral Changes
> ==================
> 1. A failed write will not update the vector
> 2. Vector writes can now fail with -ENOMEM

Yeah, this improves Linux.

> Testing
> =======
> This went through regular sysctl kunit and self test. Also is posted to
> 0-day.
> 
> I always find it difficult to know who wants to receive this. Please let
> me know if you want to be removed from the Cc/To.

Sashiko said one thing:
	https://sashiko.dev/#/patchset/20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org


