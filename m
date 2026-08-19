Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CADAC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B686B0092; Wed, 19 Aug 2026 06:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CE66B0093; Wed, 19 Aug 2026 06:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632D66B0095; Wed, 19 Aug 2026 06:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43E1B6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:28:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5CFF804D1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:28:31 +0000 (UTC)
X-FDA: 85117644822.08.49B3C26
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 377B940004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:28:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vrFq7bGg;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787135310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xhsxQv3y79BoPZ1auAVTOrY0Ii21yucenX1lTIQciM=;
	b=gVZkE5NsPg+5ihjS0L/Cs3tbO42pFe7VgeAvEESx9uluf/F7Kz74uVY1ALHWsO/3n/cZsU
	BhKqQorhQlvt+EJ4E0YYwtJy75bvwnpKqqz1Ms30uBjicwj7L//neK/+av1hNp36hKhJjE
	fp9veEOmiDb6orpwXWG1XEZjsR7F4Go=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vrFq7bGg;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787135310;
	b=Is7jiN2WUKCSkyW9qkfP4VerHB0K+3AIr+uGmtMLRESsrZQyC0ilZ5hlCQymtCqHlyPtbx
	FnsY0nj56Wy75JisnV/3B5Y4BrUp26ZiIMl7HVRtWr7VvQ9PiVr3zOlRfHvLQ+qVhvucP4
	KVGEZWZbJSYjjz2wh7TYAGa2qxN2/V8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5xhsxQv3y79BoPZ1auAVTOrY0Ii21yucenX1lTIQciM=; b=vrFq7bGgZ8OVvCCw7E7GGeyQ9o
	8BKhCVCvJVQM37dcZrFzK2Fwta26qOB/tl/4c8EQ/Qejg8tbDm6dFi9LvvdWeHxA9tfC2tXa0iBUC
	bb3NFM6YPczL1dcm1aGnzlyAzT2dO2F246MkH7nXhWUYeOfCN95+PVOfFc+NlobQN5a/QJTK4G6OB
	aKVq4a85UqxfotRiM7ZeNXtBDOZ+DQ2XxDdQY1jW33unn522df++A5CqtwsJlPr8kw29OBUwrdbcF
	u+kaezwZFiW4xmWm6TgFMV1C2jZqNhZmidbxcsuxYluseRKZ33ZnRJeRo4BXTQ76Xu+9Ht6naH3qS
	a0ukrU/w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wwdWi-009j7Y-22;
	Wed, 19 Aug 2026 10:28:08 +0000
Date: Wed, 19 Aug 2026 03:28:02 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, kernel-team@meta.com, 
	Kiryl Shutsemau <kas@kernel.org>, Bradley Morgan <include@grrlz.net>
Subject: Re: [PATCH v6 0/2] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <aoWEmbTWYU7wSQWb@gmail.com>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
 <aoV5EfBtlWcyf51E@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoV5EfBtlWcyf51E@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 377B940004
X-Stat-Signature: depb9znfja47jhmt41ococm7d4p8khfo
X-Rspam-User: 
X-HE-Tag: 1787135310-893268
X-HE-Meta: U2FsdGVkX19r4bIL9rva8Azu7A5+9lYGlP/ne4105lvFuh+IJU5Gd2G5NVepxhO4mlXCmq3Qvp6aOikV1wZxFR7Evdd+neQZj9Ll7Jx1BvlObO7+6KuMEQS5NJxuOrop9IC7FvOAv6eAVQwGl6Fwth7padGzcvVc3tM0kPGvpOSpoj/PVRjaEO2VgcVnavPkrHcwP4MaZCpEAWCBP5/3RPXdl+dxiBY7lU+PLO4bJGqzxGCvrmNanX4dponV3VM8445rHXgPRZxXv1zNuXnPY4Z4DZiovAPnlZSbccqn54SqMSHgZRuRuhBire4wxnAO8Rn9FraSEwurzdd/PRBJmvj5DcPPovXZyHvOajEEHa0FIJnf2661ClRpOrd46GD70dxN9jbERV/hl87VyCcIKbON7fxbo1lYLFQTJSpp1bXDCuiq084kSwC/dlf3KMCJAhQrqDUIFFbZUjbHc50tupDTe7rde5FPYFuTdQVvTgd2TuuEtaDHwtWoyfe5b0MVu3dS+Ykn2pnRdASUJHcVCzT3cZodarVSShNcJhPmta/uUM9sqOaymYng39R6IP7icriteTMnrNh1GA3aOtb12rJKS6Wk0OC+4wEfdiZ+ee46IkyJLF8kS6TxCQqfeksq19xxG3RT2cTx3njWVsi0m7/rCA6fjWYP3dYzyNhOgcGEv3BTSvyRX/pA9KZLb/ayJDO7YhK51fbJCYL8hkhna2kEFfNTsmAdoe27i4iu29O7Ts8DnzX+jtJuu9MGm2eMemC0ksTDEsZeccyV1d+E/uoeFrZvadck+TM3x1pf5wG/E3p1nwmZljX613iCG2g4TxaEpyOupZGWsGTeaeW4IUkZy2TQrjnsN6Rpm9lZMFB1ZJdsWYGduco85ksrMlV4k2Rp80ZdqQTyuOj9cL34s7ssJGyf+iFL7nTjLvm/bRMoK6aiOBmcZOGw0p4ElDHqAFVUhj37HbvHubNSHJN
 SpeqojZD
 ltZhAGo3YEN4hjIIYZdfp5jmVXTg1AUqXBkfL6IAoJR7HP61+jb1HVgbB0paDRfsycaC6WmnIhEMjhQtex346O5NLXtDzJU166e/n8NibBnzy5ajyS7ch0vLB4cDu2DAUCDIGEsE/ZE45F3Yz9sgNhm90oxbxNzwiC6hK1fBfJwt3utj3nnjJJwAI0lb4G/QUwAFL08E9qZT61CV2v+MGZo3ilFHBEw9SsztP+kNWNilU+7aaxKzRDxWIUgedAVk+7C1S1xTxX0DnbY8KVs0nwz1/KPqiG7xICYfw9YqsZZjGmMSWO1UeuFJ8gOiWmbWQWJTEuhqEhOgFusXitYkaimcFnIBWjjcKujehB5j2a01wU/qZnIczIl8HWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 12:36:17PM +0300, Mike Rapoport wrote:
> On Wed, Aug 12, 2026 at 04:31:50AM -0700, Breno Leitao wrote:
> > Memory failures are common enough on large fleets that kexec regularly
> > lands the next kernel on a frame the memory failure subsystem has already
> > marked bad. Patch 2 teaches the segment placement to avoid those frames.
> > 
> > Patch 1 is a prerequisite. locate_mem_hole_top_down() walks candidates
> > downwards without ever checking that the subtraction stays above zero, so
> > the walk can wrap and report success with a destination outside of RAM.
> > Patch 2 adds one more downward step to that loop, so the bug is fixed
> > first and both patches rely on the same bail-out.
> 
> I queued this for v7.4, the patches will appear in the liveupdate tree
> after the merge window.

Thanks Mike.

I'll now get back to the most ambicious patchset that carries poisoned
page information over to the next kernel, so memory failure information
survive across kexec:

https://lore.kernel.org/all/20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org/

