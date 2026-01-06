Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A73FCE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A227C6B0093; Tue,  6 Jan 2026 09:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A60E6B0095; Tue,  6 Jan 2026 09:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887C46B0096; Tue,  6 Jan 2026 09:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74D5F6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:52:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21D5A1401D8
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:52:39 +0000 (UTC)
X-FDA: 84301830438.20.DD8EBA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34B434000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:52:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qN3NVoS7;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6SPO5Dc499A+t7Y1eit7J4iMI7ltNcacj9JPSlYdcXo=;
	b=W04wCnZ5mXL9KXm4MlM1iXrRDzyMN16YoQmotd/YQWSW9UIhfLyRQlFVFQKPBiNjtDeBF8
	1caGX4T3yc44biGmar15uDmu7qkNf7Es16ofJfOPJcvD/gvuqQjHfsIyg38Am/2gym8CQa
	7BeL0QNVvWpZ7c0P+h6/ioCbTIQk9EE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qN3NVoS7;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767711157; a=rsa-sha256;
	cv=none;
	b=cZJMuf8Ix51Q1YhXG9XamnoWz4hFst9Lg3ZCrDh5A6J0VLM2qBoZIPqRwxj0BLhPFF7rKo
	ZqI0VKoRbtWK2kZ2u53Jtd4c4I1owYsiNrv4pkT8I02csSvOwZMItrlUIy08Y95QDiCDYO
	Jc3yFjzzRz6+6AKZnj8GXNc9NXZXXL0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4371543B17;
	Tue,  6 Jan 2026 14:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE22C116C6;
	Tue,  6 Jan 2026 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767711156;
	bh=CJyAnRXxJCk+YGjPEV8Sv7WGSx04lU9lyLseKMpwELE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qN3NVoS7p5mxzT3p2llkIpzWshTHfYGVshwzRutqctwkY4H/3U1L7znk1kZkUsZst
	 FCYha36L/rHxAIqDg/Ng7RDOCv/aMPG/sADBROaG0nYYLLCLG0KKnLBPwZ6DwBZYLI
	 29LZe+gnRH7eBE9C4ZFr0t7YIkeJC2iUHQpKaTSrpNF3Pxtp3GUGmMO/ILvElNRWwc
	 VFEtmJjrOOpygYKB2l7fbptpdyUx6yizAM6iGPzR4UDuiCu8Sj8IRaF2piSmFV+70y
	 SxsLuiId1Q3O2s251lg2KEa3d753GdvysKceSxV1F8HxXS7ZZxZdhw0wNRv647HgtI
	 SUzb2MJZgARuw==
Message-ID: <06f5cd4a-6d76-4759-9c06-c7c3c3211528@kernel.org>
Date: Tue, 6 Jan 2026 15:52:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
To: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?bWluZ3podS53YW5nKOeOi+aYjuePoCk=?= <mingzhu.wang@transsion.com>,
 "kees@kernel.org" <kees@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "mgorman@suse.de" <mgorman@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "surenb@google.com" <surenb@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jiazi Li <jqqlijiazi@gmail.com>
References: <KUZPR04MB89656F6F10537974E46766E08F87A@KUZPR04MB8965.apcprd04.prod.outlook.com>
 <aVzVVTS3gjtz4XNB@tiehlicka>
 <cbcc95f1-5039-4fe3-bc7a-c8edc29f5b11@kernel.org>
 <aVz3vlG2PlQ9JX_Z@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aVz3vlG2PlQ9JX_Z@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g45dchmdpq5ennsxnzyt9qyfp5tjs6r4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 34B434000D
X-HE-Tag: 1767711156-627634
X-HE-Meta: U2FsdGVkX1+6BjodTfU+8AI/S3xUTsF7EQVfUN8hLWU3IyaNh1AmEmuaU2Cm+vMJ5/lBgxaBjOugTfxWlcuSg6xBKV94pNhfa+HPg5VhA4lb786ItsVHgswcszPn378Tnm+GBqX94Yaxb9/5lfI5nosLfG4lQkM5EC0BcwGye7l6wthFCLVNaruzCa3wqZzDmqpvd4SYK/pzO8rszYyjChWkEBo6abeDfSaU6SNkjAlwjlHhC36UGZP5BIFpS0bkDknw7J0EwIAijIbczazbiRRd0HOadsTHYafpRR1xdtbPxL77Fij+sinGx8K+xlX1UMoBScHtC4xFakpkKxhAOppo823FsHIpxOgs+YTLbTNJD7WCiKlQ1mWiOht/JHaPHrDNbujfkaoMBVIIkH/0PO63OlTW0Ks8v1hZb2rPpEIkiuTcn4p7caFLvhKuU/pQAaxsV9ypTc1EQMLaxDVrveoolnmzZaxbBmengrSf0q2E37WvMRM8c0Z/YV6UzjGjXavj0stguxFkZa95kuMXdHkvxesmu6FeydA0+BAxVrUcOs/PQCsZhXm3Z7Rii1pFGGOVzjaw/bvCkcD/Kl9MUsB5Vv7Syi9IXBgH+wY7gi+dGZLUhoGRBwGYYKZyeFdfasXWru+LFpCh0AjoL8j4blW6L/LAmkYswa1uRad6vlFIyuXr4/xTioFmRc5Qu+cOFvcnXSSNO3kBkSb4Xvm5s6oSPiUypB5t41FlaJ77Y/Er3VR+3T//HIG5yilup+Fv87Ept/G4b1kxSncA7z2ky7LxJ3NY9pp6dXs974dkHbxHwVkyL8nb6n+TIwZjCBAq9Q+bcFHRCIBEaydp8dTjp3kgTciErVES20GkCB+3ucwiHZOMCgWg3iFXo01mjMCgfGNLWBMCbx+P5Y42j0zne5OXxIDfDmNBbDkwpdsJX5SIcktP1EOwsB18aH3lW8Sx6gnngaP8hQ7J1hQtMmM
 2yhkirqg
 VzKkvzqFKvjXcQiibAebDnUIPpjMgluBRe6hcObXM8HfJYkmJqXdkokV3xp1T7Ococ2Zq3HQLh5OkxSUGMfvVGEo0YbqUsAKdCB5otgvX54UkWAnQ1J1nXs9Y+8qetGZuKjQCO2uoXCJ49TIIpJUORPrLlHcfZxmaOhtbpHSm/vn3C1TAboLerPrQyl1+junqH+H964qAE0r1sse+1NM/aTjFa0baNjZjoyE4+IYaZ6CRnY0qiL7yQplUQ1cnOhcaI/bqZVwPOkf0vodTHgtF6kBr7sedKYTwzBUaNBPPKgZ+TbjS0PBVJtu9YyP2Xji+ooTmlFxV9R+HDfwkYmGcm2L5ch4CHPLD10WDWY7coVRL7g2nC2CTMBaJxlc+Y06z9bVI9UW+YoWcCmOFA23REA8ozhRyfIXte9WOUIQX+X3fqlpKvyP/dWJOcI4isX+dZ2Y0t8g/E/JA/Eyod5YE5ftSHhV7jWPxnOTIgD2+tCEFGFer6aTJZCgXM9LQFML6q4Lea2nYA6VPAxPEd3z3SSVWdJS0NKNoBTrvaYhS5SEthb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 12:53, Mike Rapoport wrote:
> On Tue, Jan 06, 2026 at 10:29:03AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 10:26, Michal Hocko wrote:
>>> On Tue 06-01-26 07:05:28, mingzhu.wang(王明珠) wrote:
>>>> The comment for get_task_mm() in kernel/fork.c incorrectly references the deprecated function `use_mm()`, which has been renamed to `kthread_use_mm()` in kernel/kthread.c.
>>>> This patch updates the documentation to reflect the current function names, ensuring accuracy when developers refer to the kernel thread memory context API.
>>>> No functional changes were introduced.
>>>>
>>>> Signed-off-by: mingzhu.wang <mingzhu.wang@transsion.com>
>>>> ---
>>>>    kernel/fork.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/fork.c b/kernel/fork.c index c4ada32598bd..64e228c541bc 100644
>>>> --- a/kernel/fork.c
>>>> +++ b/kernel/fork.c
>>>> @@ -1312,7 +1312,7 @@ struct file *get_task_exe_file(struct task_struct *task)
>>>>     * @task: The task.
>>>>     *
>>>>     * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
>>>> - * this kernel workthread has transiently adopted a user mm with use_mm,
>>>> + * this kernel workthread has transiently adopted a user mm with
>>>> + kthread_use_mm,
>>>
>>> Please do not wrap the line here.
>>
>> But please do so in the patch description, where the maximum should usually
>> be 72 characters per line. :)
> 
> 75 ;-P

You are technically correct sir.

I think it dates back to "git show"/"git log" adding 4 spaces in front, 
making the text still fit into 80c terminals. So you want <= 76. Then, 
whether a project allows for going up to 76, 75 or 72 depends on the 
religious believes.

https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

Is an interesting read.

I've been trying to stick to the 50/72 rule for years, especially as 
it's easy to remember across projects. Well, I frequently violate the 
"50" part :)

-- 
Cheers

David

