Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3EC8FA1FE1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466A86B0088; Wed, 22 Apr 2026 14:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417386B008A; Wed, 22 Apr 2026 14:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305F06B008C; Wed, 22 Apr 2026 14:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBBD6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:18:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B23FA1A02BD
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:18:31 +0000 (UTC)
X-FDA: 84687002022.06.D7A0EAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 005A1A000E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:18:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BLuYXhst;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776881910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27WplWvkeKWSRnjLRegxjAuHP+5fvroUuyYXvDxXFco=;
	b=VEzXiQpPE92HARSkXMTLNHE0067O6QQ5xfJHjxped0UYsLImNLCYi66rzbbSdI2bHHNxFW
	Qm+IEeu7fClfzIgfWZO6Q93Y6yn/9dEJA51fCmq5G9Fm/HfK9vwujK99AbgLksH4dqmOyY
	A8E5bSOA7P4YjwDDHfvCVJKsrGEr+1A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BLuYXhst;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776881910; a=rsa-sha256;
	cv=none;
	b=LltyQa22opGIfh9RgcL8v94dfk7W4ar9DWnBl7HfqEParg0b8mGOdVumceqa8N7wmbPmL0
	IhVe9Bd5a9iXdxdpB7SjmyU+cBlKu5QmVlVSKN2YPx7EK4oDfRYSA+qln69ujdS7g4ZQcR
	FiD6/WVYl+xG7iKHX8LL2D4SrcdQZWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B93F61340;
	Wed, 22 Apr 2026 18:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81D2C2BCB3;
	Wed, 22 Apr 2026 18:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776881909;
	bh=poVEk0a4RHNRSGxEyMFp5p6K23A25Mki0TpHQIwqj3M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BLuYXhst82Ra6+69kvYJLWBXcojI07MMwO6DecW3vDbDdd3sbwI/9M7bbi7SOQkyF
	 Jn/iYqVD2H6zqCrvvZB6GwCwKQyiKSGjGuuC75RksStFkljQDQx9PUtuRk6t5I/OXc
	 o2hmJaj7NsSaRjmD7dhH6nUvi+gD0z1hA8ToBBGwa2HWQ04QvNoWbbAggZ/gJNtczL
	 jvj3IpINnZrrz3d+Zpx0kBdiOD86bLqTqm7qU4TU3hOmobQBqItvUB+RaFvva5fznU
	 TqMS3EOD4KrADe+SicBsU3SviU4nfdSCLtcagw/Q8zBysWzFo0O3RDh7DB+ZevIrrA
	 Ltk8sBbu9YU6g==
Message-ID: <92c3d650-be80-4a64-a962-3586ba753316@kernel.org>
Date: Wed, 22 Apr 2026 20:18:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
To: Josh Law <joshlaw48@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 58myms5y3jgogh88uk364u4k6yzbjdhb
X-Rspamd-Queue-Id: 005A1A000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776881909-371328
X-HE-Meta: U2FsdGVkX1+qayhNrQpw/3hSZ8Gh1kq3fjSfvrpGhi05Gxi4Hky7LUb3TP6rvZG67/nmioz5Vu5QYUEZsVn/OFZZx7aCGnKdLwqKMFOYf2rGFvXXivhmyeM+WLZ7Jpf3qYbjg9jZ2xIqC0TJD9Hhx23Xy4b8gga+P/EJjtlV/Zs+CrWLX2Y1JLHcy3Un1TlC6dEnfhtKcveTK81ZETA60i+hu3tV0k9rU5MMGTMvrqwkskxF7/4HJMS2ABKJKaNodLv8N7Kf0tKx0HyeXmz9fpUOoaFFQWhxfhwtNnOk748b7XSUHBAC8VRlk6iOXM2TLtqFkc4LHkW5Z4PjlzPO2gJxbsjm1I+Wmq+hpKu6oHyXXeyj7KqUH/fR08crZZpFzjTl+hJQsqchkJRDBhm0V1B+fpBRqmqMoUU2NSSqRDYJSPYgRMUlj3r/8R1I6TNi2BSh6pUA3+PHAROe+ZsQIqt7e6Q3BQoEbQESZGyJTIcOBlOwtS3TiIh1gIVdWzSuiFEpruO4qIFPdH0bJB1C0WlxfFXYkc9qXyut5HTNp7j/4tZtZak+E8WRJpnThkpVOcrSgc9D1OsqLnh4FrhgKB8WO4+/f+Xiz+KjKDYoBWgmfcKVBOevwDJHMQuhRt21/crUGVwSZpKyHxhZ8D1Hjqj/iMtIJHnR2xc4dl54Hjp0I+bFud+SHxRd5dYeGgWHzSJstxwuMOSij/xd5zmbntpOdKom+IajTtQA+iGGI1CgCSYqSYbVah2b3W4bcWM6zvkkxhFdeo0LirQI32Pndq/AUnjPNs4ivykJ3VGw5Hm1pevZZpcTp24urE2o8uuU8I1Y/lXnoNBNezTNmy30WRTg8yaKC+/E+MxYiSmE1RV9ebE0IbbzZrIn7yGl7kZUSIn5bZBCFOeden8ClnD0qp29KuMKokNMkzJHu59acYqiP2nGvYISMb7iPq56s7OU1YhwLKBCP/lw7NE+RsR
 RRyQNORP
 2b4DHOc4yrMoxv83ZrQbtDmoHl7SUo9swdp/f1yacBP5QRSJ/ydR7nPJyuIeQPwvoBKC0jwsXCOnoGfWaug1pJmmFOdFeSLi+u/CcYe+y0NFc3R7ZoYCyJlKjzU/sCiknH7nccKfCDWa1oXr1OFG/2+FISkXWL8WmYClEkcrd5IiZ0COBP+Wj9EidWAqkfnfdJmzZmJddRgCL30D3Ka5LGd6Dq6aR66EgDI7sG78oNsNngYF6Lv/95s6367wfoHLU3b6G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 21:25, Josh Law wrote:
> Hello, since I'm not coming to LSF/BPF because of my age (aw)
> 
> (And I'm more than aware this post is more mm focused, but I'm
> representing lib :))
> 
> I'm "virtually" putting my hand up
> 
> 
> Whats going to happen to lib/?
> 
> I'm aware there are submaintainers for some files
> 
> E.G: Steven (and Petr) for vsprintf
> Masami for bootconfig
> Willy for idr 
> Liam for maple tree
> Etc
> 
> But let's say, lib/glob.c, or lib/bug.c, even lib/inflate.c! (And/or 
> all files which only has you set as primary maintainer)

I'd assume that (excluding MM bits, for example) falls in the foreseeable future
under the "I plan to keep running the mm-nonmm branches.".

What happens when Andrew fully retires is a probably a good question for the
future :)

-- 
Cheers,

David

