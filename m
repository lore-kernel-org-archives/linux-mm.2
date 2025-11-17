Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72D8CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3F48E001F; Mon, 17 Nov 2025 06:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3859E8E0003; Mon, 17 Nov 2025 06:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1978E001F; Mon, 17 Nov 2025 06:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5708E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:22:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE90413C2BD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:22:24 +0000 (UTC)
X-FDA: 84119860608.18.D8249EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 10D03140006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:22:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVsWb028;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763378543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/7gl8ib2wD2KTBzdAJNqT4I4Z1PmgipuwJ9xwTK4n4=;
	b=hsNZXTZlGM8TmBeSCnRptAbBcqhCHAgp7G4OPHbyg8liStr4VT5QSrSNEk04Olpbzk7RBv
	1oNPVz0GwVPMr6yVJFBm4US0mhcuOiYsbAxB3kIkWLeaFuuE9qduy+JQq8jW3vdB5B1Nwq
	wjk+gpd6juRqogoBvhauuoBo2QZB08g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVsWb028;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763378543; a=rsa-sha256;
	cv=none;
	b=jQv1HJs/NKMjzMGsRIJJLb1Jv/5tF5mmHWX3pIVNbw2lQXipaHJ71XIChxQdZaxbxJoNOk
	tl0bssfG60EYAqW6ZmA+wDP/ur7UtwKOrLeJQ/zLUDF0NFqYakc+vY1JESNhnE2Wui8BRQ
	RQ+LLNDtY0nvZMQ9NcrEZd9PmsfQs9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAC7640135;
	Mon, 17 Nov 2025 11:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301A5C4CEFB;
	Mon, 17 Nov 2025 11:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763378541;
	bh=K/K88MbnzvZu6qocZDTpErIcbRmT240tLVOgbvFFEzg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZVsWb028foNrBKvF0MTwI3Is61X71X/0zIkM8Rg0s7r+pHjx54NY8mJfz4WzKHEEr
	 O1DEH8Ow6TRUtwtIM972MpooI6Gc5/fA+n5ZDV40052t5uVBMGHe0uyDr3nS/7/jTm
	 OqbAbSbF2IvFBys2tUO0J/AKOIwzElZO1+RvHNgIKInZV/pGe3/3dyU8IsBl/n+/i4
	 i8Wmgzd3Yw1K5rHhic/7kraTyb+glJSVALjuuDhBkUYPGEGXW9PQJWxhp/s5h4KW+Q
	 cEPLjtcWPb++vh9hB9E0jFLx0GQHwJz4K3S1znlV/BYWqdb8dIaCPeHieHOzL49IOF
	 hogTrqsine+dg==
Message-ID: <f3ec2046-3e8d-46a4-ac37-dc8e09f451ab@kernel.org>
Date: Mon, 17 Nov 2025 12:22:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/cma: Inline cma_sysfs counter hooks
To: Jean Delvare <jdelvare@suse.de>, linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, Oscar Salvador <osalvador@suse.de>,
 SeongJae Park <sj@kernel.org>
References: <20251117115602.7b9c7ccd@endymion>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251117115602.7b9c7ccd@endymion>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10D03140006
X-Stat-Signature: 7r57amsaxmq5qohxbzhjamungxzg43th
X-Rspam-User: 
X-HE-Tag: 1763378542-664970
X-HE-Meta: U2FsdGVkX19MBurDYKSWq5hUHtQCCvIJCD+q00M0vzGx/kfTuZd0tQrnlwzVb+NlbN2KGv+aVAR7jBStcP0S/44rE1fDg5j41ymOAci3nghxMZinSYOMGZxtw5db4uv2sQgKUlTkF0lyj77pxUzZaV9etDLmVmJTdUaq1ltEBjK2OvbI0otxRMSChy0WslgFkR0KSConwR5D7vSCl/mnBy1bh4AqDHlmOpEF8abiwN114usbVLiWY3UZ/IZc16H6+3Bw+uwWLuKfSZxAIKwjXl16AQ2VVqsyCQuqG/+diB5/UhrjdgEbOZlAL0j0msDkV1wVfb351afNS3+ywBAU5Arn726lSkJYIQwZ58rNallHvCXMPUZM2WP9GKLS3nWDLnve7ywCmrXd6qOyLQZJKxeODDE0CtIlfds5M8BhhyyY0V95n+HOaG+qNsnKU8wKO7nuGJAJrnPvwI3KAcj3czavSTTAjz9p1MHoRlQuXGoAqy9xppobW2eatgQC7huT+H6uWqGYiYL3jiPTX7g0cEKyAlZMq3DOTgpOMRzfkAS2xk6QKfc6G/9cXKS/RaqKQ6TuBUImL/mq762DH8Bcxu1+E+47xnEdznRTLXcysc68L2g8UkQE/BOATmRzG7XVDqWlHtAI72OXTV/FHyrv/V11f1zeHYKrNZOU7K7UcpkQzrx3pPm/u43Yy7IA9BA95KXICerGT6X4FbUu3gtP7pzzXrWexNRqSC2A84lJONCxCSP5abRkC7kbmm47Z1FidxDZ4W5ZS+jqVfIQFvioqHTqUiAZieQt+6BBS+BRxntV3GWl1gqhLx5S07cgwZbLKeoeEHDv/jekY7jPUxZLa7bEt1D144bY8+JsXqe2HzcwGfAzZkyBdYZ4ouwWWUemjKbPBM4d38hyrUXyUU7y7jIKKejVhFkZnU/zE6SOp2OlqPTiacDOrOJVAePYbhOp7bBX1MkO4+pGnCrYVmW
 S6o+7W3H
 7K43akPH5VK14E6y18677VbMDDn8BjIVo+DBF4MYA+XYKWNjeA6TzdV6sDN35+cBLgwFGJpWFhNQcvkrdTQ5a0/UcWOEOtidc+7T7zdhyYb7NSQLtID0NF+6Rr9325J69/ha3Hq0yTClL3okTdyW4fmRiVhvOJooEtDyno3hs3sYLTQRDoUsAhK7+kkVYYkPVBcDxtjvJFdYwj4LvmFW3MYNYMYwUQkjayctFS72DUMtOegIOQj4X8alE9xE+u2HGmHEUqrBwPL9hQ6NVvjTBtJ7oxEcb4np0nq/IGf9RiUt5MzcPUSYeQWFrBpe4S15MDTBQ8wuDcOUn85M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.11.25 11:56, Jean Delvare wrote:
> Move cma_sysfs counter hooks from cma_sysfs.c to cma.c. These
> one-liner functions are only used once each, but the compiler
> currently can't inline them because they are defined in one object and
> used in another. Letting the compiler inline these functions lowers
> the footprint and runtime cost of the sysfs interface to CMA stats
> even more.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> ---

I would have moved them to the header, but no strong opinion

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

