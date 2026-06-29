Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E2AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D87C6B010B; Mon, 29 Jun 2026 12:41:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587636B0119; Mon, 29 Jun 2026 12:41:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4774C6B0132; Mon, 29 Jun 2026 12:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17FC66B010B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:41:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95A431669D8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:41:47 +0000 (UTC)
X-FDA: 84933516654.01.D010E68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA8F9A0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:41:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVR95rtH;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751305;
	b=e17hFL2xwGa2c5yFPxqVJBp2/uE3orWBg+o4kv6M7wyRhmvGt4zLqPxHTxEOj7Dlo1dsv0
	H2gXKXi70ndnv0IfLG38Qs797nbU3iWgyPh45RnaYTI0N/hj9Hj/wN2edssDXwMn+jq8iD
	j1CpP5f+63mvxiK2SBfdKAyV6LXhpdk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6I0lCoT9IF60QDyIh+ZhX4HddS6YXtol5+VWTGt3/y4=;
	b=zig6alV6JXJaScVLaEKX5qEzVE0hA3QKh0irJmsxfUH+0+XDimNMYHg+DXMrkBHJvMkd27
	7MER1r3OU3bAwPVeNfeSZstCJbQrr9OAFOd6R6iQ5FeuJPb5dnRA8tkjPeRZUsxshJxGvu
	65j5IxOxPgrGUd8dHPP/Qb+CwFS51vg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVR95rtH;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEF1F40DC3;
	Mon, 29 Jun 2026 16:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962F91F000E9;
	Mon, 29 Jun 2026 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782751304;
	bh=6I0lCoT9IF60QDyIh+ZhX4HddS6YXtol5+VWTGt3/y4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eVR95rtHMhGP8g9buGMjlNiwjuu9WnyHUxI6njcy9vcgWEYxK3zAGhLLqir+AeiHc
	 if5OtenX38+7wQ08KK+fyJMu6njCI2hGyf9r22fMdgUgn2QOEl25Pvs9cTaerXqJcG
	 i+0X05eAxwD5evx9sdce3sx/M0WBmLfWsH/6BOXgFihoq1oQuukyoTt62eNznUuHlN
	 Ckk1yYpcWeuX+390cDM+qPwFzJ5ilqDqivSOm4tiLxKGvnSPF3WrH9WAoPrtfFHE9T
	 ObKFzm3fY7PLVV3gBA9LXDtfKKO9pchED8FVDiqafHd97gCuV1pjHjfMAccIo2JYPG
	 Qa08mIxed9twQ==
Message-ID: <34025f75-a0b6-4a4f-a093-f6f2e7411947@kernel.org>
Date: Mon, 29 Jun 2026 18:41:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] docs/mm: Fix braces
To: Manuel Ebner <manuelebner@mailbox.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260629161156.90213-2-manuelebner@mailbox.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629161156.90213-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7x9qnw5zou18t66t7wwu5eb8rs7enpwr
X-Rspamd-Queue-Id: AA8F9A0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782751305-304535
X-HE-Meta: U2FsdGVkX1+kO47H2m1W0NXx2yL2nTFdvHQNy/mFbK7btPI6drVywQkySsx/gVduqWhL+fXVhycUeKNZAYSSN+loQngB5WhlY5hPgM6ZK+9w8Gs1xJkOfyzbfMRvIiNzwnMN9pThU4R7YvpVBenV+PAMkizv8zrLiMVFLCWCEcPAb/gOqT1UHSE0l63DP60ddNd5IkXvUILttU229U6Xi046ya6O8cWTAZyOr9TB2p/TQcmWn/s4vOB5jhtKBEYaT+a+JbT5zKPhNgYONoP9Lkvuvt+tH7H/Y7hvUIYFayMmbRePtKKD2RvX8HBLknAwGJkchsH2V5KNeSzatjRg2e+lmavwIWibzeHa+u1UyrrNAox8XgntbVeQUjL7EQ4BPlmH0pA0OclS1LuvSmc4TNqhz3Ie407xwYjXR29NYBwSTaUNG0J5OsEktZAeYYdGfGFX4VnYbYvoibawQHbucmbdnmPCAxXG+j5hKQ8GFKNIHoIek6rI8ynHttPPdinY5oSBgicag7sP5NvpPqatjvAi8ure6MoHDlOhU3WmbA/ABIc20epGnIIpwTXumno+CqA36IGinarEL5rYdp9m6SsoFAdvg91Vc32QvCvfy5yPaTvqmj3Cne2BJ+l1f13K5S1Hc7fai+q37XjmslcQM3mo6C/H5XnEvQhtRhn0Yllff/zQl3bIjvE0R0hbvMUYcWENPvPsxkD2YzaezzjZw6U83TzdevSgVZczIt+7TWjxATfBzYMJya0DML+/+/f1ZmxoSb6LsrOK8R6gLMRtIb/Or8H56FO9KIU0W11GOa7PAUvB23zS2pII9ZB8Ow9eCGNWFeS6gVZXQcbLqFrij8Lg5qlzXaPGNLoLdUiPMMxGGbevHRqGIgcyad23LXlWA1K5h/okhkNeiV3gkxvDIel/gdVTqgMFf1tVAbR3112QeZc8LVdGtCulOvHS12KWGp9hZnUT1MKMwIUQFX+
 679u7p0k
 hpS3e/0WYauOSH32FlyuHEXdWcpa1BKUjizP/T2p5T5cXz14kKQiTZKQoVdVtkuhIS1E27tGrUyTEAkEd9mpfV/tyxsfm57MEAQkEv0PQkEA7o47T2Sb0Uurgqgp0S6Wl53VsDDhmQ0TLJCPf2Tt8f1jLpFIC5qpcafSW/nMltUINkUctfYRKhVSsItva5j8gQiegRD/+DS22L/5CVrzfKv9MRzRcFEQ9h136KLoDDBqxkpmrLhIkaS2tIU3hs2eZUHl3Y0L084WASOiAkfc3jNhVC/jMweRSaOu7ZapCISe0Wa0izxHt8ZvB0OqyolNCCHTPpdfCb3fiK0yYNA5ls7DCYWAarr6v688gF2iRPESubthItt2/53pBH8fsoA3TeK0pNxCpRlkle0jTVJWt8YBGIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 18:11, Manuel Ebner wrote:
> Correct typos in mm documentation by balancing parentheses.
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

