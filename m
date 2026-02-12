Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82998EB491D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34866B0005; Thu, 12 Feb 2026 07:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2996B0089; Thu, 12 Feb 2026 07:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE146B0098; Thu, 12 Feb 2026 07:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC7526B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:53:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A50D31A0106
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:53:53 +0000 (UTC)
X-FDA: 84435796746.05.5A09946
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F22208000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:53:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UviKnrW8;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11wX3D903yLn47njPol1qmVGf/101hc+9tFOGaSEwoA=;
	b=kwIMRzNWWT2ZqYFpbQbSUtV5PeDVmzUpZQlRqfjUFXxw0oQrjtoEfATP26DxKUJS7qK5iC
	L3lDciTZXj70cschCjNN2V/3jasTBmp7HnVokJPCWlsqIOXnWY0XA3cnHJ8B9EY2QJU+vz
	CqUykmCIk/pPqWn7yufPOhCdt2zXb6o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UviKnrW8;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900832; a=rsa-sha256;
	cv=none;
	b=Ol0FT4xHcM1Z+mLxAYjyyu4bIxcE2DwhUErHW3iPvBioSWn+87RD816son4eZ/RVWq3qeQ
	MCChSrxV0N04GjjmfDzdbz3Fnjg8gAsrnJXFyjKZm7zgEuSQzX6fkxZnC5f41dOfb2i0lc
	zhnXS1hkYHwenQpx4mDNQ4lYbU7PNBE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70CCD60018;
	Thu, 12 Feb 2026 12:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BFBC4CEF7;
	Thu, 12 Feb 2026 12:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770900831;
	bh=01LvpQtH+qOINc93aGJRhsa3F6+JnfqL70CjSs12cjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UviKnrW8b38w66Xjwgy6NpjMrmWLlJnxvHlthoaf3uuOj38yJJRER5MT/dLsZEFjn
	 a7BLRtHLcLwPp/zUwUexwwXoiiMcUOo+8MjRC2+GLmkHEynR267BAYdBRk6/O4ZSIo
	 /6sRZaOmVCvpHkRnUnL5qt4eOqR6x0qdJo9Ia/8r9VD8RxYzJFH6vo7zldTc2nehep
	 4MeJG+4+TTCtQuCU5AZe1Xhk+pSODY8QoXbSvYKMo6CfCFzT69fCxycc3hiCNmYmGr
	 7DGEo/wPz/019+DDBqLZGeBj6epiY9yDFNJ7yD2ogDfkPHZpahMfqYDjSNdVHzcFpE
	 MZ0shfUX2E8qQ==
Message-ID: <237fa136-ff52-4e7c-830b-1ed8e985f2f1@kernel.org>
Date: Thu, 12 Feb 2026 13:53:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] kernel BUG at mm/hugetlb.c:5868! triggered by
 blktests nvme/tcp nvme/029
To: Yi Zhang <yi.zhang@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>,
 "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Daniel Wagner <dwagner@suse.de>, Ming Lei <ming.lei@redhat.com>,
 linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
References: <CAHj4cs9Ez5f+SsHMcbYVeKGScuL9vq71i57kRgu2KneRtXRwmw@mail.gmail.com>
 <05281713-80b3-4199-8e76-672e84fcc33e@kernel.dk>
 <CAHj4cs8+Xgz1qgf3H0sDMFhVAmzb9EsVmuJoRLBOgP7bQymodw@mail.gmail.com>
 <CAHj4cs_4-5g5oW-Wx7KwceALy8F-Ku4cxQGMZ88ARpvZN4HRjg@mail.gmail.com>
 <CAHj4cs9AUA94ntY0uhDDAmoWTMA3kxpSCArKG9MHcgkVASJfAg@mail.gmail.com>
 <e281da57-caa0-4e36-8ff2-80175bc43090@suse.de>
 <CAHj4cs-mxgZ+tWXgOfjYx+X_bC35zBHyMbNYcCUuHe0JPLsHWw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHj4cs-mxgZ+tWXgOfjYx+X_bC35zBHyMbNYcCUuHe0JPLsHWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F22208000E
X-Stat-Signature: 8y5zomm48xrfu6mq7bmthfou6dmaisnt
X-Rspam-User: 
X-HE-Tag: 1770900831-577178
X-HE-Meta: U2FsdGVkX18nMsSYZfg7LmaB13FWymFD+b48ZSPLQQmUhjVI3P+ouqK6I+1Yz5QazSzYmw65kFJq9BtbDGpqA9xhwi1DXhXWkVKCnEwdKvTbW1uEe8WAgGtvd5oyMV1jgsukt2mZL7p4bO0dBInnMregj0MUqLEQ+YUF1G8JDVdRUrezpZ9JITIRB+PF5ww4bf1ud2FKF+bXLsxGyqBNLDUHS+19dS2PNXzCkfUoRVotERl9e2aiMkFtSE8pSane6TwjIZFRRZVUDQfr2aELzkAPyZRWqIkBJkOyXwfs1qTk5toqd5x5rMeDWP7OUsNyHJb1mHmcKAoeIYzFABj+OTPjK8ovqLV0GzwZCy0XXCb/NYXEOF4m6CDyejdBGeCTSp7N9oRES9xUuPEEx+yA27H4wAoFNUyIUIBFTfVTEuJKqG+8dcor8lxxu/U04UCPq19i7Qjx0B++96J85d9NiIbWNq4OnCG1qm9eNe7sJidjTgaTAWgVFIkEmJ5oJoE61y2zdEkZy58zV6snjdUZBa0zjtl6AaKKYxbdewbCRNQ5T6fnJw3Kt2sOGTzJK/OSBMo5OQDXpG59bhI6wfxmX9xlAxMORqv1oR2rlY6d2PinbK9u+ib/heVnn1scI+fCAMjS6aip/Y2ibTOgRA9ENBxD3l7IqU0W3kQBQABIuHoP2AJ7wZij6fzayI9j3S8AsXx9Skc8Yo2w/A1xGDNiKnMsG+zbsRXCYCoiJW5HzUwUHauyS1IyVjfIkPqL2XP+SeSYvs2fqtTUZNvMNBrpJFPhVAyKAcW56wgQKGZdQ0Q5YpdqtnrLuXS/zjLHbONq05SogTtW+kr6EQHdeOb27wCSUQAH4WSrk2geDD4FXcYxU37gC0bnqthHVb6gOSqyVSPujwSHMbutk6YFrdJrOdxe5w77GrvcW5Ycagj5ZYfzqNjRS48ZGwNZ98ibH0uL0N56TqRwbIufzD+90dG
 j6kyTXCb
 Xq7xZycCEDVHRo73mlI1aIEXITDqBWEY52uUCn5N+Uz9pqUwYrfkXyZ+bbcFzm0jGADjYN2N58Cl4xzoZ+FIr1GFkKSW2d3OMLrxJjngKm31skus+JGRCB6mdTbW8PeKAZc1gtMUiwIOyZWfXPlWL0/Kv9yKfNhS/3yIuDlR+Sp70/TUwIhsaFi45l177osMUIzT0u85LG9ba6rY0dJP74wY2vdeeAhJcWGjmnvCpYwlMZhNxZYxP7ONQ0MhRP3Mvf0wxgMnbQWiBnFqHvnezrXO9gWTDJ8kMJMmqDcckD93XUrb/6dXEKYjTaWuRP/jMHgxfBQC5FqwWVVp4Kn8hE511+piVvFJbf0U77IV+7GGDXAiOPYzrarVD9M8119RYLdVH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 11:32, Yi Zhang wrote:
> 
> 
> On Fri, Nov 21, 2025 at 3:44 PM Hannes Reinecke <hare@suse.de 
> <mailto:hare@suse.de>> wrote:
> 
>     On 11/20/25 16:18, Yi Zhang wrote:
>      > I did more testing today, and found that this issue cannot be
>      > reproduced if I don't set the nr_hugepages
>      >
>      > https://github.com/linux-blktests/blktests/blob/master/tests/
>     nvme/029#L71 <https://github.com/linux-blktests/blktests/blob/
>     master/tests/nvme/029#L71>
>      >
> 
>     But is the inverse also true, namely _can_ you reproduce it when
>     nr_hugepages is set?
> 
> Yes, it's now 100% reproduced in my environment.
> CCed linux-mm@

Stumbling over this mail in linux-mm, do we have some more information 
about the problem we are running into?

-- 
Cheers,

David

