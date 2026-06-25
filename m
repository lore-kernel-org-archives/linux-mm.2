Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77477CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E026B00E3; Thu, 25 Jun 2026 06:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E826B00E4; Thu, 25 Jun 2026 06:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F066B00E5; Thu, 25 Jun 2026 06:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEACA6B00E3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:57:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25521C2AB4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:57:13 +0000 (UTC)
X-FDA: 84918133146.25.6B7AC32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54FBBA0006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:57:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ND0O6TyC;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782385031;
	b=w2SzROIC9KC8op1joEsi7g0u8tJFtX7fYnIh9HZL0b/whLIvckoJSR50p1FhrRMAZeBzTP
	dd8Q9pnr3Z+5V2D5RSnPODRTfdYbjFSWTMWIFP7Dr9yzSP6mzJdHuI0STSmfANPPhgguz/
	f4XSierztOGmpXVrqyPmi4z4nWYEDAw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782385031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JCXB0zNTf/AELeBd7FV26+x3FLfZvl38bsfAk9MOdk=;
	b=Pnyx4yoyHFvscKA6ludCENjO4CjROXLI4EsllMtuCgDDQ9yq+YT/5p8XqsWt7/m1eQVdnr
	jQmtwPa3RgS8DWEjKCPPLVI8l5hXQAUTRtwKSyMK0ZYYiRcqINJnUAaEsPHIvxpRh0vRHs
	oKg7Lzid3JYxCrXYDo7qzjRaSu/cM10=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ND0O6TyC;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6327600FC;
	Thu, 25 Jun 2026 10:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F4B1F000E9;
	Thu, 25 Jun 2026 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782385030;
	bh=1JCXB0zNTf/AELeBd7FV26+x3FLfZvl38bsfAk9MOdk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ND0O6TyC0KNxiweXNCoigX32kil+sQ32QIEurWStEiE7oO1t0Xi/VjBNYxe9ww7Jg
	 I/tO1nBlkG2C7jGl1yBZACb6GxwZu/FgqqFbS0C0lsJnPqoGTR5ofb3NZJgyiybKNe
	 Sc+XPw0a9RAbu46u7D+uGg3HOAFbr0NF0sKXEcOvT4QZjIv2cPgZrdeQVpahwUlPc1
	 A2o4UbJB+tP4+pGF5PLi7FNmyAQJCo3Ny5ca3m0M9gS8rXqSSh+kw3yHrgoDuWcuZA
	 gZaABt2L+RfzCa+HYo+FsJkjOCcSP9weB5BwzfDQ0gGkXR4rjh6YXEATccAiGajWQq
	 mmVGY/hwLl3tA==
Message-ID: <9105c433-44a7-4e8f-bacb-def93d11a7f2@kernel.org>
Date: Thu, 25 Jun 2026 12:57:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for
 pre-exit before dumping
To: Christian Brauner <brauner@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, mjguzik@gmail.com, pfalcato@suse.de,
 ebiederm@xmission.com, viro@zeniv.linux.org.uk, jack@suse.cz,
 jlayton@kernel.org, chuck.lever@oracle.com, alex.aring@gmail.com,
 arnd@arndb.de, keescook@chromium.org, mcgrof@kernel.org,
 j.granados@samsung.com, allen.lkml@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, Xin Zhao <jackzxcui1989@163.com>,
 linux-mm@kvack.org
References: <20260624145552.70143-1-jackzxcui1989@163.com>
 <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bq3scqp4yxo17sa5eobxd51xqowpggri
X-Rspam-User: 
X-Rspamd-Queue-Id: 54FBBA0006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782385031-107968
X-HE-Meta: U2FsdGVkX1+H5eKU/gKn+18Y94z58H7FZ787bXTieh9sYbvtdiZCnPAsyv7pjUpsOcOkvE3pec7CUnSOFF1lRISLrNREJpoXWBEoCu2a7Q2w+lvEfF9RlUq9ZH3610g4S4NK2jCohc+6OpZGNAyDvW6fVzWGspDmnOAlIcrHnEuBouxBnc/mQ4B7vMlhK6RfkYpR2rpqQX3UkYIST8dFNn0+xvWxiS6t7JXMrnUQcNKgsQX8AuKo5BQj/0224TIXx9FTnvJjms6dkpO+6rEDl3uH1F1qfONlYz824+DbsZLA9EYqZZwAHT0Z8DsoxFMRCdPqcwWAxnKB+EM52mRJR6qEIrxW2PJwiNANLb6LQ+ZYOUpFvlXwlJLRrMBYeYbaHZlTZBixPPNe/TTaBsevBzRDxr4Pd1fB9kHs99q5ofsEZjpy/lDL0p/JUHCZnz2isooaHid+ICR/8i8tvbL+EIPIUaCBnNqvyaTjoVkWJUkQZOzCnd64jq56zjNh5DF4Vs6mMZhKAj5LMEY5f0MJw/t5TQi2/b+JH4ui+sobCTcLzBcTYl4Vy82JFI9VuwmxuPQxC8EaWJFUVXigJwdU1fzWi76OuRayy5lu6d1GoX+ShP1gEos7v/x31w0JPtcTdkOIIMVpdMUSyZFXbgiywrJZJgNkKON5x+GxH1yzEQz6oFhdLD8ak07a+5OsehH8811AvHR3y4HutflP9kxm56qzN7lWpo1/54bx0r6n/q3Osy61pCE/h3H4Ks97UDyOxy4H0u1cZpnuiVfBMJjNJNxgUiOmD9ApJG/tde7nuocc4loYXB8402gIfs4vfGMQ0TAfk/xlyNzqLZJuPYNtijJqmseX1heZ1+azBHaoT9uqaSVDiWx/o52hboxxtH0663xRRkWfkw1uUaB7BybOJk5ufj621ci+iAne8IappKc618kzYIdJO3vLtFe0/qDwcyiy8HLfsjqdOqniD5o
 MmRoNmtK
 ITV0woxNwj2zGbmwB+jV+Pxe7f8tEM2/ZwJIcTcLzu3LwwdJ/DUtYQjBqZZQt4F7aUUgbJV3r89Y5IgDkxBfzdZAQ39QfFkIS2PDsiChlNpogRUgq3PpBIZ0q+dr5dY7VEAnGgWjPY0vKwfGu1bFZO8CQ1Y328ZwOlT0DgwV3AyeE+tezvnMk+9RIC39YoDBNIlgjGGfIOwobkkdgMMCzYb8No7FoQsSqjIYWbB/RgFFKYsxrIg9jXaSUTrJCEKH4o1OQfQPjdjd35+XUPRN2JEy5SGM5x5eBuaB0Ac9oBs+D7f/EFQe+slCH1LU3MAFR4XEULCVThp85O0K9va8KuLWrNFlrE1nX0XRdNpj1LYyiazpvI+ub6lmAixhzQpszNcnz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +
>>  #define F_DUPFD		0	/* dup */
>>  #define F_GETFD		1	/* get close_on_exec */
>>  #define F_SETFD		2	/* set/clear close_on_exec */
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index a679b2448234..84f1ee7f32cf 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1030,6 +1030,18 @@ static int __init coredump_filter_setup(char *s)
>>  
>>  __setup("coredump_filter=", coredump_filter_setup);
>>  
>> +static unsigned long default_dump_pre_exit;
>> +
>> +static int __init coredump_pre_exit_setup(char *s)
>> +{
>> +	default_dump_pre_exit =
>> +		(simple_strtoul(s, NULL, 0) << MMF_DUMP_PRE_EXIT_SHIFT) &
>> +		MMF_DUMP_PRE_EXIT_MASK;
>> +	return 1;
>> +}
>> +
>> +__setup("coredump_pre_exit=", coredump_pre_exit_setup);
> 
> This makes no sense. I think you really need to sit down and think about
> a design for this that doesn't introduce state machinery for boot, mm,
> and the VFS in one shot to solve a fringe problem...

Staring at exit_mmap_mapped_shared(), ... this looks rather hacky ("let's fake
munmap and set some magical flags").

We're essentially saying "we don't want (pretty much) anything that's MAP_SHARED
in the coredump". And for some reason someone should configure that, that's a
rather weird toggle tbh.

And the granularity ("file-backed shared memory") is completely odd.


Aren't there other ways we could optimize this internally?

Like, if we know that a process is dead and cannot run anymore, downgrade writes
to reads (and make sure we block GUP write attempts accordingly), or would that
also not be sufficient?


Another thought:

fs/coredump.c calls get_dump_page().

get_dump_page() will not fault in any memory. So if a page is not in the page
tables at the time of the dump, it will not get included in the coredump. Which
means, that whether most non-anonymous memory will be included in a coredump is
already like playing the lottery.

This is true for MAP_SHARED file mappings and MAP_PRIVATE file mappings without
private modifications.

Which makes me wonder: How much is tooling relying on file-backed pages to end
up in a coredump?

-- 
Cheers,

David

