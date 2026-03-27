Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCAE110F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C9C6B008C; Fri, 27 Mar 2026 14:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F276B0095; Fri, 27 Mar 2026 14:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24F46B0096; Fri, 27 Mar 2026 14:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C949F6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:11:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E3E4BC813
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:11:08 +0000 (UTC)
X-FDA: 84592634616.02.06F0E4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 778D440012
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:11:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cdYOayuP;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774635066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9SFUKozSMR2ZLvGBLpF/dxrxKYuIksgjItSw16BeBo=;
	b=6+BOjwG05okv++2tfnyyJMkgrRBQwh8NvqqLQmhaZhVaa5MXI4sAdHdihlHcpvCig64sp/
	T+akKrfU3BZi9DVPeeE1J3QFkkd67gkOV2c4IG1eYGSdSGTDO+BI66OnoTmq2uEs6UJWrw
	gIaj8O4fBn7Z0XI5ahWAVXB8bXA8crI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774635066; a=rsa-sha256;
	cv=none;
	b=RXUPcMY6voE09l61ZdVyGyaN1JBiXwOVwAI6isZhAzdCL0sYHNBO5hEvybPz5ZPcDAJxW/
	ewR8ePYs65MHZUW6pbTUPYepwwhj3rYwYLF0tDErTtigQwBUIWwtJxH1skMr8ZBy/RZCHc
	MYdvEC+9JTSdgQEP5UqJ8IHcnNjSBU8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cdYOayuP;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E9F643E7E;
	Fri, 27 Mar 2026 18:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94449C2BC9E;
	Fri, 27 Mar 2026 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774635065;
	bh=D3tgGfmxSUuIKrF23B6dFn44AdNk1562eNoc2kIzF0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cdYOayuPJYi2aaxhAmAFgppjg5NFHZRBdYAYmVT0UcRjcTZjflLB/FGXTUb9V3lJx
	 OgYT97I6nd+lwOsBPiBlUFP0OCrdat5FF+6ghCrli/AY5UhTyMpR/3xUnK2jyN4H6W
	 38fwnTH1RNgXYVSZcfyBJ0jwwTiW+dxnu/XqmhNw=
Date: Fri, 27 Mar 2026 11:11:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Ritesh
 Harjani <ritesh.list@gmail.com>, David Hildenbrand <david@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 00/13] selftests/mm: fix failures and robustness
 improvements
Message-Id: <20260327111104.b8bc18be45172639f5b9226f@linux-foundation.org>
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 778D440012
X-Stat-Signature: aot4du6h7kd848ttq6xi3im1sowma4an
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774635066-263089
X-HE-Meta: U2FsdGVkX18vHc0KYM1rtXHOy54N+fbCpnvAmCoZ/rTCxC4DmeAtBrynsmuZhaZ/0eAgZWqqcoDTvBk+7F4q+QZw2rUOtuAQVPPAUVLQ/ZkzM8KbtNkQOndMUXrGXv0S+v5Ebel/lwuxPhUeNA0WYkfIWNGQSESz2C7SAjjlLkb7x2xuz+zxXt8zBIZEbq1juJvz9kDwL95+RxU5bZR7pRAtRv7RCL5icwcMVmScwwWb0/6iHM5JDA3jnp1pRK9HPU/inpWKMBk70KrJflC4WifwyTr0FpvGHg8wX87a5i3t+isz8q1gGFaRvPo7+64XolhyvT5pmDPMITnAezd7DuWUWnI2NVRdVzD8OWDh3jz+WELCmPGJxxoRXpMG/ou0ZS7g+yybQvL1uxxO95L6q3AWAuuNYkqmy+o6P3qIoAJIPZQ//12dfaLKvzteK7NG8yB0VXCPBVEQHEKy7qDcSegxcwPfpZpgCH1P4wTL2NeiV9qChus/s2vKBNUWAyQ/5dgLqaNaPYp31BXtrolAfAiBpUNr+seezVDGDZHvSnTYy04UXxEyygndkfSCv6knYgDBF7i1LePhkRNDicaUY3aA+xV6yXbHbSfCzMuMqyXEwduJrvSb5O7WiZmTYUJBex0IQV/HeR2IHVJ0jD1rihnLAsnFgnPKkoo2B1pLQZPZe3L10ReT6AqYh7okDOWo1vWcZoq6LAZNI2VKMsuW+znON1nfQEsnkfAmCDSGW7zeOMXjoafCmpoZbItC6wnKhPZBZJPCy0IUlUxlWYKDJ7qv+EMn6pq0DW+rxOf7AzqTNjFzZn6RlrK1hX7W8/abLtBZoJU2smJNMBDN1VctwAIgWQt4zkLa5HtsWoFPrRX4DoL3N6Rme6zwi4vCoNefQzK0VPX8jVmZfxuLvVE6I8ZqsV0iJk6QYT5P1d6qV8mi2M9SYqSUR4Du7W3TK2aVZuQXZE/85Yp9sE8FjqH
 5OhRKnWx
 0vK/ljzoCHlLQo+hlJgN2enHWSX9JiuvbuYjLEcmmZSAt6zkTHHRHzrAI4hjCsA74SPVooGhPYZT9+VjIEi0ddd4D73us6kVMbNUlB9ndgoHt1EYTMG5ZwUvW27T67uxHHPOqMQKR6Qk/iIbkTdNMmUurqIyxXSkC/sxyw44OQjwf/th84BdOYdSqNMcJoaZ57/hfEe8ZDW0vNyUfxANrJ8S2ktbh8vN9KwZoOf3lcYSCBfhks6lEIC+8+9DOEYCGBFvP7kdRqRQ5Z8SqtrLIUn6fNmXhOdgmzOZE+S+9hxNiw1Jt1Y1dTfSqBPpHSOZ72PCIvaHve5LJF7X2DWdg00r/2fr69THObXwgxLm9mZPQ86/Xu+XYVYmWdgx8pTq2EMi78ngc+ugSb3ZXJiCc7Q71og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 12:45:54 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> Powerpc systems with a 64K base page size exposed several issues while
> running mm selftests. Some tests assume specific hugetlb configurations,
> use incorrect interfaces, or fail instead of skipping when the required
> kernel features are not available.
> 
> This series fixes these issues and improves test robustness.
> 
> Please review the patches and provide any feedback or suggestions for
> improvement.

AI review asks many questions:
https://sashiko.dev/#/patchset/cover.1774591179.git.sayalip@linux.ibm.com


I never knew about that bash line continuation thing.

hp2:/home/akpm> cat t.sh

foo=\
	bar
	
echo $foo
hp2:/home/akpm> bash t.sh
t.sh: line 3: bar: command not found

Huh.  But it presumably passed your testing so confused.


I don't want to risk breaking selftests so I'll set v3 aside until
you're confident we should proceed.

Thanks.

