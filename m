Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E02EFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 04:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA136B0088; Mon, 23 Feb 2026 23:32:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E296B0089; Mon, 23 Feb 2026 23:32:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359DF6B008A; Mon, 23 Feb 2026 23:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2072D6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:32:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D321F1C2FE
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:32:38 +0000 (UTC)
X-FDA: 84478079196.13.C56C81B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id AFA7FA0009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:32:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771907557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBfxSWDoYDKpj5OHs8p3tr8Knq8WyhFiqvowRNbNglc=;
	b=YjUC5jpcBthQ5kOrqoILqG6zULIsH5KBUPRj0Smq+RWqN0uCQlea8eqfM0wKFqdyHlVXF5
	0uZGBHHmX/PF0XkHj+DGclQEazO8c9siS5nyG/OhlggRBbd2sMYF0lfLXjJo6j6SYlc87I
	RF5QAZby1KfbGnv+J6f16y6ow9jKkTQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771907557; a=rsa-sha256;
	cv=none;
	b=hvBAhdDhjX9DoxY8K0w4W3QTzWbsJfJi91B2QMk6C+50SYeUvAtcoptCebhIwIgrb4umVn
	/Fn5haYAmJafnymtsLnYNBJvr8GN4PSuicDPt7prIZwTHAmFn1F/WB2GASzdKsRIiTtood
	qZ0s0jtQiorzbuLZkQmFgV4wzlpWXWw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 384F5339;
	Mon, 23 Feb 2026 20:32:29 -0800 (PST)
Received: from [10.164.148.47] (unknown [10.164.148.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 152023F62B;
	Mon, 23 Feb 2026 20:32:28 -0800 (PST)
Message-ID: <a9cc7306-f80c-4fe8-bd6f-95bdeea3c9c8@arm.com>
Date: Tue, 24 Feb 2026 10:02:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, lsf-pc@lists.linux-foundation.org,
 ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org,
 ardb@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
 <a778d249-afea-4488-b045-beff3492a48a@arm.com>
 <aZxv0mEd2BA3Mq-N@casper.infradead.org>
 <e7af1815-3028-4530-8d62-6004e421e35b@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <e7af1815-3028-4530-8d62-6004e421e35b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFA7FA0009
X-Stat-Signature: xahsydxip44h45i43g4mszb6pa4ixy6i
X-Rspam-User: 
X-HE-Tag: 1771907556-499279
X-HE-Meta: U2FsdGVkX1/aQzwRKyTMy/OsRhWvZumyjEWRJCbvezl3aAVDxnZWhXyWJO7QQfXNmKlm0aWxi/lyHdao15Hrz0GU1wW3uDh5xL8Ky80viek3CUXHgPMk2xiqeIp1uPkFxAAtxXmDTIRY3sFDTgs4s44R9o0BDqIkUQR4pQWCNsAWzcHlJYvgdos66JG6qo0AwQfNEoM8P+F/6ewPivMDDCeMU8QPB9lwWAqKlbz4PULFHbvDT+WK384+EdGZGuv5cyyHof0T36uWobwyayJp3hLE+h0JnqXubV1/F5+OoU328Jtmkv0G9LPpzmc24ITeS470uJuHDDCHV58X/lBo6zAo/ynTQyM6LER2Cs974NZT4lP8h+ULJblMBOdnjZVKBNPlHOhGnk0EabBMUGuOKQc/j90jiGZN0FniT3DYfUCCvPwi4Hpo2njWMrmxUZvR7UIMkbfXs+NI9tiVyfYI0KlQhr5qAUhgL9f/4lIepCR57iWrQgb0nY9A8oc5QmZof6uy+NNd3bAi+T8vhV2kKE93DcQZ6J3PL2DlGE1LRwEMYv0XxfjNCR0SRQWmeUnHcVwNrYy2p5TR0rW6rswgM2LXd+NsPg3Tlg7z8GYzY4VOfcMqoVR0/xEGawz/fbem3duhyikIDEP/BQTqQDnWQLRJFlngo6q4WotPoXCiCo+PHBVc6R2hhR0hBhIac+n4ZMPyXY7VBlzxvTgija02xUOnZ6OaeZ6dErhYWm1qagCiEADmvza/v74IluM9rEgGrNgD3v0XoGSyQCT5PgyYv86BXKl0MxrJKSVw1fpnwWt+QKZPOcR7JXUSRykKsBKFSxLz8FfArsiDY2J9Ptx60eqsAdBwWlxlk3LM7SYLpKdYly9osKf7IALKNmQnYGQQV2ebpy073p4Ep3FSUVDnkG4yfqLn4ga3c3bb2+rX8inN4LfTtiTxuQyw9YQqQJ5jyZRaxWt1gtQiYhNB4/l
 AaxQSIhl
 uBFIioJFiQajKWwCO+ZL4Tn0RT99Sb2wGXk28thHzAuffpnaFji/C/qOhT3x8egUwS2H3vW8hXjCDpAmGTanHjr+qBARwIT18mSL9vYGh8JKwa2LwHqbrzZ4LnBTzjVeVb0Z8O8h0rIq3ano=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/02/26 9:58 pm, David Hildenbrand (Arm) wrote:
> On 2/23/26 16:18, Matthew Wilcox wrote:
>> On Mon, Feb 23, 2026 at 10:37:55AM +0530, Dev Jain wrote:
>>> I didn't understand the reclaimable reference, but yes we need to make this efficient.
>>
>> this goes over 80 columns so much and so often, it's painful to read.
>> so i didn't.
> 
> I just found out that Thunderbird was lying to me the whole time.
> 
> If you're using "Toggle Line Wrap" plugin you might think that mails are
> properly wrapped, you know, like *they are displayed*. And even lore
> displays them properly.
> 
> But in the back, Thunderbird set "format=flowed" and screws you.
> 
> So, if anyone else believes that they are sending properly wrapped mails
> with Thunderbird, read
> 
> 	Documentation/process/email-clients.rst
> 
> and make sure that "mailnews.send_plaintext_flowed" is set to false.
> 
> 
> Thanks Jens for the pointer!
> 

Thanks for letting me know about Toggle Line Wrap. This works, along with
mailnews.wraplength. If I set this to 0, which is what email-clients.rst
sugggests, it doesn't work. Thunderbird is confusing.


