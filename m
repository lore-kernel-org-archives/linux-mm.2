Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11369D6AAEC
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A066B0088; Thu,  2 Apr 2026 14:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B286B0089; Thu,  2 Apr 2026 14:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250AD6B008A; Thu,  2 Apr 2026 14:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16F0C6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:30:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9AB514087B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:30:03 +0000 (UTC)
X-FDA: 84614455086.04.FBF3F8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 11E9640005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:30:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kX3tAo2C;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775154602; a=rsa-sha256;
	cv=none;
	b=SSGhRLP7IuydaF7IHGq6CUSpzfDG0ygsbPjdFlDvzUXkj9d2D2dIGiHu8N85ucF+EUUEuW
	pfTxSYkjnMM7PJF/U2BQ+B4kxxKVSXLabGjzEq3r0O0Acj/Z9IR3I2LJ0pcdV8wCmLZ0aW
	9MRSeVFunGU4l/VerUfHNkMinqFxozo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kX3tAo2C;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775154602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20syi/HzHvmZIO/2yBU4bTQgGKFvRmW9AMPVK67hLbg=;
	b=sbxBGOKZhHy9s3Lefx7gUuvdkaeb5EoKEWVrBvjpjci3/zwiTNefXECKuW+MBXDK/DEdZ9
	kjO2os2zZvaiypx3gaIRGzeeamMdsaUr8rVrfvSeQJyQUbMJzeAOB2GyhN60QxB0aDz1vJ
	Nf5gUXgR4uF0wW38BtXHb3tA0CuoQ7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BD06600C4;
	Thu,  2 Apr 2026 18:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93838C116C6;
	Thu,  2 Apr 2026 18:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775154601;
	bh=vF883QY1i6xQFxIscdIh+q/em6KdwTdeclnXWtTzXkk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kX3tAo2Cur4GGUNI4u0sjdqYu7ePw4sUiH2ghrEyKTgb7J4fGr7QNYekE8fGkXOcu
	 Jvfa9UFO//Y/wmeCo/ZVtZuW/6NnK3s6XeS7qHYtbF/sUamQr5XUX8USCb9+FBXFre
	 13Ac0ntJWOb3OmA8qLGc51vnfAlX4mFnYm7MSLQI=
Date: Thu, 2 Apr 2026 11:29:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, David Hildenbrand <david@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-Id: <20260402112959.e8f079444a8c15086f5f578c@linux-foundation.org>
In-Reply-To: <3rmcbafb3pwq6endpfpgh3kzygolhvpal2xwg5sgq4pw3toikf@t3jx5uorfzxs>
References: <20260402141628.3367596-1-pfalcato@suse.de>
	<20260402141628.3367596-3-pfalcato@suse.de>
	<3rmcbafb3pwq6endpfpgh3kzygolhvpal2xwg5sgq4pw3toikf@t3jx5uorfzxs>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dq6oi79foqimk36m7oegec9qkk6ssa93
X-Rspamd-Queue-Id: 11E9640005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775154601-295256
X-HE-Meta: U2FsdGVkX1/hXpFrSSRrBDIWmrDDcaTtKMMNas3jFT4qbVRCR81IyvQyb320NIzosbZy/Sl3RiZ3IUvBWIY+rSLaXfqUZQL+cebcm+ywPr8rgjwuDJf702RLPoI/LXXP7YC1kFPJRkdEzvDnl5mNvimme2VI3p0O+w/twopSHaAaEbvlX9qWiyXw5OS1ZNIaOSYXDghk6xdY+81oovWS8BlQV8qTtVmnAWDA2rAcmNegNB3DjIiOzhHAif58K0ou3QljjwpWF/YkNRLCFfgDwsqf0HreZ2qJ1FBuwXa5T7TkaKFbNgiS2GjKAWYEdjbSxWgxlUkGsQfOAoYmlHiuMoie1YuG9cYUGKGeVjiq9EwkWk44MQGk6AecVJyC6ZZEto13qqdwHuA0/ggxrjIH50Zh7TGpB+tWPJpdvfCAVaJQkd/pc/8VnEZgHOjg8Mi3XZGg+qK+b4dmhdSMcPy+MPZBtmLbL///qoyIYrwDsx7yN8hANri4HxfcrMj2kIrhqVLS10mh2BwBH8jPNXeV97O6PRz0MKH2Z3geupCBwtGoCcU6TcFjjxUGq4xa3exy4btvBXn5iQsLo9q/tro+UhAHMPDmX1cThye8JBIVd3/0WU4AayvTtSzP4AGnqLGfsG1Mm5g8s6RqHy+s0SszbC10wG8PLwOHt5rCxx/IxDCIHvpLWs2jF5af1YzVF51LKLZ/0g0Aj5eTkCZpRIi+SBfNlKAc/z/fDRHWLcm62x3C4TWv7judM8iGMZvemkPfnfQLbrJ3aNUust366a+azAnEkxB5UTAYqsWSGXmTmjU+2Z55YDd5wymNzdgNpe9O/28LaHwZW0SGgTzH5qlEFLv1tI+uCw7UfADxUF5DkZy0GRiSPPP8NGrJqHvT6DBQFHnkzEvfnGHrQGNxR8oCkJBoKMwDUW5dvpUaAfGAlwMKNChPw9m3pe5+h5nPyjmmWe5d3aaXC4EFiVFThFc
 Xk9J5slS
 PdT6B2zhy79mm/NJ9JT3MNRuVHYHpLe41yyCc9l5V48QaewJmn5+G8wY+XDwwApdYUEX2leixTe3dNH3A1k9MujolT044d/D4PlElD1KI7DUTp1oK/uuaI+Hlw8HPsx+J3A5dMLee5FZTAKWBNDuJWGOvNKGJT+YGBx0DK2CELRd8RWQguD1Pua9IvBAeqyM7I46luZ1fT8sH7x+LtjpEneN18yWzW9ohM5IwCVe3dQbh+x+bHuFsPPMqWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Apr 2026 15:21:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> Ugh, of course right after sending I notice a small problem.
> Andrew, can you patch up the commit title to something like:
> "mm/mprotect: special-case small folios when applying permissions"
> (or protections, whatever sounds best)

np.  After scratching my head over the difference and not being able to
discern any, I went with "mm/mprotect: special-case small folios when
applying permissions"



