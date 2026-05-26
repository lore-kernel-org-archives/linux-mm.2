Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CC6CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55166B00B7; Tue, 26 May 2026 08:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05816B00B9; Tue, 26 May 2026 08:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4296B00BA; Tue, 26 May 2026 08:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDCCC6B00B7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:19:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6802DC19F0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:19:29 +0000 (UTC)
X-FDA: 84809476458.06.6AA8C79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A548D40004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:19:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSaWGJ9K;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779797967; a=rsa-sha256;
	cv=none;
	b=gurle89CfJSfwP+Z4vlUEg/OYcCDFGQb2VF+uF7BAt1tK2KcXe29iwHcWeTQDeDELPifnk
	W6BXkP5iysmxtLiTYik7jvaucz5ApzbnF3qfl2K9irBeWCaBb/3/gaxdS3Oh38d4Ztd+Cu
	e+7SxyCUL55N5GALDQ1tBWjahkkXEBk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSaWGJ9K;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779797967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3KFgS+dBJ7AtckYVi8TqfdsNz+bkVbcNrWm5ZFn5kw=;
	b=TnWnWGr4CgVY7TI2h8SPfbvLElbCbAhSeXIbNMNswEXdIbSg9rvEymGyOjiV+U8q4jn7Z3
	dQY7HDfFcElhQEexZsj7fOKLbreh6rNOgO4lSaWxaAGM3mUCT3zkjyQiv0e/8E5zdmHwfC
	Hco8FotOvjGQCXtGHGhBacUZ8QIccGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DBB260018;
	Tue, 26 May 2026 12:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F191F000E9;
	Tue, 26 May 2026 12:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779797966;
	bh=r3KFgS+dBJ7AtckYVi8TqfdsNz+bkVbcNrWm5ZFn5kw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GSaWGJ9KG2F1HkMmfxJ7wOTOGRL4udLwwqcQ4fC1OMgS4Se3tMy6hRMvtvxL0joiD
	 7WjHHRrHx+RvW5adHDZQNedwBiUgLmB0a+Az4Ps9r+zx6KkyU0raupKfrPzb1d7wqL
	 FMV1Umdvd7jVqnV3vYHcf0oYp9uKzzMpfCYH+V40QT48IkKRvpg9raT1SA8nXqYxul
	 Kt+6Ru+6hIwRULdOFsO0MrKigsttMUlGhT4Yg50D0TIrAE2Zz/6ynceVU+zAG1Ege6
	 H9+TFYtqaMQiRP65ww/oFAa2Diz4FH+RoxwKOgv+enbn4fqjOgcXthRWTXs3b6iubZ
	 4QAGt4VuMYd7A==
Message-ID: <694e11e5-1022-4ebe-a6f7-121ed4450239@kernel.org>
Date: Tue, 26 May 2026 14:19:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftest: Fix UB of getline due to missing var init
To: Chris Gellermann <christian.gellermann@codasip.com>, brauner@kernel.org,
 shuah@kernel.org, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526113848.530105-1-christian.gellermann@codasip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A548D40004
X-Stat-Signature: gixa9fmuqy65yi9r9af8bb1fej1bnbsd
X-HE-Tag: 1779797967-450825
X-HE-Meta: U2FsdGVkX1+KXQsu1eTWw4+eeh/fZZLk8RMVeqmWXgJDbdWk2LE3TQj+VQvJV2eQHRgh6vqan85nhE2Moof96dkDqfTTWdNxQYy8qtPRPXBCWvsIN1vmXbFmzha0KlBtPY0VA+/AiwuoTQJZwqFJFw9mxsqjsz3lg+7uzyEXJcQRBK81JjT+uZD+9BEqNK1JToQ9BmG9/PrcU7WcfrZiuIL8g7oSU8CqIUaEcVYNwXpJXgxdDCzxG+lndxuFbj7Da9yUW7YVFwvFvr42qIU8ldK7dAuiN8lU70AFolJhFmvarr61YSj0D8qJW7yhdlFpdAeKidUEMVHN8ry4fCr98n+czEwEJXWW2viP1Xb9Zj9FhmjlvG5v0bV/cZkUsJmWaX/5G9RVFgR0O6jiO7LqNNS8sr0wkX52MqXS+mdbe6IzgqW6EP01PnukQpy5sl9iZ3OlPD6kp+VndeByhsDPFPF4EctBbG3Tx1CC73ft7+mvnqSunWa14RAS7r9Tpkoh7R//aVyw/3L9STWz46GEQMhdw0KWQ0Iq/yY3JGOiqWiwg80a4M33aQ6XTU2BU13N3oGeYNbmXwYEPu0X01x9u6zpjisMky2mKnMRZm4nvhtpqMy7lgI79YbEx8/ZlZNNVvhmPsAr+ctThCeBDuhm78Z5qHq6nGc22BDbVEx5GoglVLfhR+ZbqvTLIlV3gFnTz70WR1OpeQXeLf73Zo4qUDRrFo5TPvL/QfzJwEigD+wRDjtGEuaPnyg4HXTESYDeaZ1dw8rs/p7y/gd4wCDeqZnjKy3Jmkw7ZHrM1Wku3RUVHmihvimDtREqPRZWE4BRSiI+iaW6nl32DcOr8yf9fBKQtKYJddzEXho2GJh9ZsWYS11539ipAfy5DbE8kTcz9oBK3RnJcsHzzMhSxClfumtGgy4jDhlymG5ruJnieRyWRtuGyNg+1rRCnFYV3N+fjNOxI0AIdicGnK8InRh
 ho+zV/cL
 ibP/EdRR4WC88DoUnjy49ebT0NQQIAwQR/xQV1/NJipz5dDivy80oa9xdnpSWtOga2bEFBc+Jw57ZWXCddSWPn/qduo3K7LgvTf5SWuLtTkXIxUUQbcjlNX9L7IRK217iHQGz+6W+85YJ1xbM/pJEKqD28EiKDgHZOQ+EdTe8N/07reRiVGXfBWTKU9tg9+PUn7rVXN4FWvTJPkxS//gktcnZuKNg7tp7K85ib7/5uNTulz+aJ+tVHp+0f4vgSkEg6R+31QZf8ibM8VNQKP1R7WZ+YyiP/BEgDrqIKfMpI+SuyoVQUQCypHCDDYb2MXZ5HVb58A/O8nxU0P+DgjU0xz+O9ZtY9GfKDsAx28eEmtE12xkej/0TNQq3ibMie6+0ChJ7X+UaARDQJwt5FZdJfCi0tq4QWmLAVzNypp7+RFm5CSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:38, Chris Gellermann wrote:
> Clone3_set_tid uses getline(&line, &len, f) in a loop to read the
> child's process status. The code expects that getline allocates the
> buffer for the line on the first loop iteration. For this, glibc[1]
> requires char *line to be set to NULL:
> 
>> ssize_t getline(char **restrict lineptr, ...)
>> If *lineptr is set to NULL before the call, then getline() will
>> allocate a buffer for storing the line.
> 
> However, char *line is only declared, leading to an undefined
> initialization value. Fix this by properly initializing it to NULL.
> 
> Same issue fixed in mlock-random-test.
> 
> [1] https://man7.org/linux/man-pages/man3/getline.3.html
> 
> Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
> Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
> Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
> ---

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

