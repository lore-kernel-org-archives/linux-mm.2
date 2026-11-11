Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9280C606A889
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oF1Ag0f1
Received: by kanga.kvack.org (Postfix)
	id 8441A6B05B0; Wed, 11 Nov 2026 05:03:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4CE6B05B2; Wed, 11 Nov 2026 05:03:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7110E6B05B3; Wed, 11 Nov 2026 05:03:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF566B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:03:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7CDA14024D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:03:37 +0000 (UTC)
X-FDA: 85422401274.22.67773D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA4DB14000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:03:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oF1Ag0f1;
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794391416;
	b=pl1dlouMVc1EVIdCZNk96d/uwUz0C7QYhWcFhgz9OMa0QDgc2zpD5ZvM5TJFB3ahrOdUpA
	ihK+3Wev+rJRRU8ABWcYmZ03IK+EEmxZBrkYHcSeeJqlIjSV0yf3yTdSrN4QNLeShuZLN6
	LAj9hX7ICXPi02ItYo7qnPgROuMNJko=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oF1Ag0f1;
	spf=pass (imf26.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794391416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6lo86pYSzb5BtbzIVnUnrxk2gJltsJqttZeB9Ctflw=;
	b=lTUHWypbnoL8opKAVUfYigXpU+JNZO7fMnjnYJLYioCIsF6g2oufQEJnipW3Pyb1kGgNV1
	vKUlVJjbeQC1EYq6ofDI9sZMyYos0UhoUKg+QWpWNDMiyzzH5XfIy2I+3YmMCd4tamNUcw
	hYL0eg4rtAxh24KVHBYfGfCezS5DIa8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA7DA1576;
	Wed, 11 Nov 2026 02:03:31 -0800 (PST)
Received: from [192.168.29.156] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2FE23F632;
	Wed, 11 Nov 2026 02:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794391414; bh=xgPXw4TVtk3gJ4JE9MRR7ILT/67E3z8uzFF5ws5fn6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oF1Ag0f1eqWEfzCTa3ADEyKK5E3X4fQXc1vK2pHdix/9u4EZnmavw91tV/vq6MCdV
	 S7BLvwU5oheaA7MMQ4Pn69aS/i9hjyv8t+1CRqeptQXy5dRP0hHZOugqGH7FNGpyqT
	 fVQc0uAM6voKqTC0gPPs2ZIaAa/q/TOHU7+zG6l4=
Message-ID: <ec002297-730b-4223-b4e6-9c133eb643a5@arm.com>
Date: Wed, 11 Nov 2026 15:33:27 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: add page_owner_filter to .gitignore
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zhen Ni
 <zhen.ni@easystack.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20261110013651.107001-1-sj@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261110013651.107001-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yieqz1xzubseukmjsmybp3rjgmajtnu9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA4DB14000A
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794391415-414673
X-HE-Meta: U2FsdGVkX1/bb4Xd5C98E5y6f3+9dSYbFWgirpKXtTMlBJD36ByJOE/jrruQs8BPRaq4Ujr/frYwPvwiGwD59+jS1oQDpQXQBradoCQiugPEzX3aNOlw6R++z9o6EH7qYW6tv0GL8/bQzWmXVKi/xQQRn9WrWync63Mk71tSH6GkNQ2EFyrPTYVgVvaO8VvalhHPhjGfBrk3Cw7h7+LeuCwjonDTK0iOMQKePRlFUUlJC2Hsk0yO7uSE+O9++YUPZZJN+i0pG6pKijVuabaH5iobuTg97Jy5tZBXAGB25xMqx6O/ZJ1RjquBURCKFUUhdZxVKs69mCGIMFbJQjKIRIdDuhf531ADDOdO0ZWcX+PQkMyfQA+9jpLsrVNSOGSJHIqnFGtlN65H+WVa//x+vB3buRRiV+c+n5s93u1SW0TtOTWZxFr2fCkH7MlUGvcNk/Akr1kUwbakR1yInKGTILfl1ZYESxBLQBRnP+gljjU9+cxt3VnxhJARKWzUObMlvMi0r/W6DlOsL+zeKXzhNQ5sgDFu5RwERFg8tStHMjfkinAlLShCkoPDeB7WQff0N6W6Wsk9JZjO1S8aynKgbwjq94suwrbWRWJbMRfkNgtbFZ0UbJCk3MvBicuMIlF6RCUz5+INSKcmy9pJ2Py/pWmN2xc/+JKL9VSHepbCPImy0vWdncHSwcj3UET/beMnzw3PCoqvU9tI0YEfaXyVh6Wvzby7mUPA9tisKKu2PMGCwUiPv8fi8HU2ND9lDL2+Wqbj93uG6Ybg9B3Qsz3wMSPXrSCzouY1P2Rd4mb0PuWQmr2GSgz1Z6k2G6wKsourBSK6av+nIrsKPY4a8WQ08Rs50kZU7j0xYTUQftJyv8KknN0XVJszJBM3Bcm8IGmG2cWzlJe6RUGxnqAHMroMvg+tTYnx96eZpg/Zx2ofzKZhjaNbbs5p40zc46HPl37YD70MvI8PjVzAiPnIPxY
 Y0t5Iioq
 p42gVb76CnlXqOj01s8oZSJM3lt1+JU/whDtItb3heCwzyCdHORP6OKFxAJEn2es5AVva2MNj4WXIXicpbLa1BTzSjj5AyM+8cOZvJB1oJ/jBCO3mRb58J6QYd1uiJ9Jr/q3CgjNEAWcSVnDDpgRNwiVhjqZbSQqR12cbHEufy5KUSBT5gh46cWq/DwYUg5VEHaUJ/FfV3EFeS/fP3iyoSHHFLHqpRv7ZrTQLz8nCIFyjmiy7PgIGjY7ZkFWl5JGj/XqMhoKTH9bgkz4HY/kU3wtlfCr4cap6vzOycMdSfAFxAk/xJC96z8VTlZ2UMzT5Wsg8fgAWUpFUgj2RdVSjszdncfFxjFrFbzjErMmzvcCwnYmjLfm7iuEgrNT+AZre5tj4HfhphUWmKG3hvV6RmNhd+2K0mJE5SeXW6G4AmdIuzqZa2nADcoHCD3gObyNKypwoP4VkUy0r38A9HH8/+WK5KCY7fruJAmkmihhuXOiW9/BR7IYQslXq/VJ9ZP5CZD8A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ!

On 11/10/26 7:06 AM, SJ Park wrote:
> Hello Sarthak,
> 
> 
> I found you forgot Cc-ing below people who are recommended by
> get_maintainer.pl.  I Cc-ed them.
> 
> - David Hildenbrand <david@kernel.org>
> - Lorenzo Stoakes <ljs@kernel.org>
> - "Liam R. Howlett" <liam@infradead.org>
> - Vlastimil Babka <vbabka@kernel.org>
> - Mike Rapoport <rppt@kernel.org>
> - Suren Baghdasaryan <surenb@google.com>
> - Michal Hocko <mhocko@suse.com>

Thank you! Looks like I was on an older checkout where tools/mm wasn't 
listed under MEMORY MANAGEMENT - MISC, so get_maintainer.pl gave me only 
Andrew's name and the lists :)

> 
> On Mon,  9 Nov 2026 16:31:39 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> 
>> Add the missing page_owner_filter to .gitignore in
>> tools/mm.
> 
> Makes sense to me.
> 
>>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> 
> Reviewed-by: SJ Park <sj@kernel.org>

Thanks!

> 
> 
> Thanks,
> SJ
> 
> [...]


