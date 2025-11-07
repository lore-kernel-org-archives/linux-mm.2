Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F3DCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 23:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B828E0010; Fri,  7 Nov 2025 18:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2A88E0006; Fri,  7 Nov 2025 18:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1BC8E0010; Fri,  7 Nov 2025 18:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 385A28E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 18:36:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 033EF12CD6E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 23:36:04 +0000 (UTC)
X-FDA: 84085421490.14.ED0E230
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D4151C000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 23:36:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIiN5q75;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762558563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qQGWs6LpN4unSynWVZhzKi98tWARU4nt/0dAsCAu7Q=;
	b=0Ggf5OtKTnAiKaiy6ib7zeSx3bmddaUCydLwXl9MRO/+8Sbx9jETxnBYXQ+xBpkxvjS0IN
	W7xn3xmtJyT6BrcuJGiuko0lbKmgnpmP5tLloZWzZOjZ/hEQmSd0SoOLv+FOEKvUw3cDOi
	y43/J4HE7TCs4PawBlnQtzdx2+PglrY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIiN5q75;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762558563; a=rsa-sha256;
	cv=none;
	b=GhTs/NoibprcUnn390HdebdAx8sPlJg6ZEutzcW8XrQ+NnqJY+xsiwpnFXoe1UkdQBJVA4
	SyjwSJzcyQXde38ZjunhdNUv9jYOIM69KRfepAEoGjU/M4ShatoZEecW1whkAl6fKeLPUe
	BL7QZPDQ2B2jhhOTbu5Dh0Vg5COGIuY=
Message-ID: <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762558560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0qQGWs6LpN4unSynWVZhzKi98tWARU4nt/0dAsCAu7Q=;
	b=mIiN5q75lCcf4two/6jp3fr1UONOvcNFCZELHORZjTZkHsbOJO9x9ckTDX0TcH1xMG5rhV
	QkiPWcQQN3A01vmtyJlDXfZfzuXQEcmdyLTiQ4ZPqy2Hx8ncAy0QNM8yZvrVetu+BsV5zo
	4n2Gew0vzxo30idUCWKmG8Dbk1su/Sg=
Date: Fri, 7 Nov 2025 15:35:55 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
 graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org,
 ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org,
 rppt@kernel.org, tj@kernel.org
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com>
 <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0D4151C000F
X-Stat-Signature: zeo79mzxw9jhun6zektkh8m1d4tcbc5q
X-Rspam-User: 
X-HE-Tag: 1762558562-89275
X-HE-Meta: U2FsdGVkX18JolgadqJIkSQwhXud/UaMip5mnrCu24HeZ+wbU2+rOFWD8NQY4rBmdjti//U/FwtE4pzIimvEBjy80T4jf7BGp+o+t1rVS8O/LVjWmINmEy+Z23l52UwdVEizd1nR9vympXELoxcJomnOH1UkWxnK4fzV+EJA7OBPrJY3mIQ0Mn4QE56h4Sarc/kpU94tNpG3y4umvb3LTLaNLnq6k9czcpo2Af5Oxqbb0IznviwOLw/BOX7TVevhTxUgJm4/Oy8yJE+EfJz/wueq+1xRRjtAz2Xq1vHEGI5jRXtk+v/wpdkget3b25pxvDclWLl+erXlQaZD00Uvw5sWSv/o5igR5sdNiv5uWnR7vFY3zcLfQZv1ERPyDBTxekuKAFTiDr3t3H3U7o8xiALzZk6fbyU4CxAj/d0EHg4NSYZgmdyrgpt3uUZ4Q+5e87vl39f3IgeRGI4HJR+EWXGMCAxPHzF3jRVLjIyCL/ZeLttFpAwLC0cjuzR7F0cAGtKxeOQA2WgyiFJ034pB9FGu7fFyrSmzjx6HJSGGp8uI8vj9PYLk7Xb/4KU/YquAU2YutAp7qIbCu85mMwbSBj2MyWqOiJWYjW0b9X6wWyV6urXu3g/qXBMJAvojC55RE/Li7ned81WPpjzSvMDi0hMmwq3In5dtlzo9vaix8zQPB7McR2REpwnkvv/D05e/cw4OQpXvufjQzbs+HShZhfunVZSphqst/Y7bM+yUKShdtR0EoBekmXve3h14z3MtbM2xrsg2oYc8L3w0DsDrsC9jvE1z570AlJVoF8U9Nrm6H6FOlrLaXbMdVLagV0vv1wwSyZXXv1yp/eBljM+Q/o6VH3cevXjRnSjPB6FMdrKYyNrqr+VQD+FhOB2FjwUYnGkcalxKnYjcqY8R8gW/IZ0TqAIg8owfQhsZN+CQGOoaJpNryjvbFiD5r8utZLnm8Fhf/07/AOULETbH1yE
 NNEGXilw
 iXCBwNDT0S8UF2NsLLCcJ0EQNIeDD22ojq7kRSMSfWpmKjRyXx3xEMVGNYXavmiE+YgJGmlLh1Jny2eBCYLA5+sHfC/oXGH1F/n4YjLKHNg+qktD+jDBKTSQuqAxOhSfIliHY/ZgBMXJp/FP7nGzRraTzg9CYzDgnKgItWjp+qqcapfPFWtJJxDmuxzD9erAFGmSFK1tLO4J1UcNCQzDujOs3x1GTWyAU/y6bv40iPjr/1aQ6g7zMwSIOqniTQQCQnnfAM+9pp+Xq6lSVi+Vhs1Bibg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/7/25 4:02 AM, Pasha Tatashin wrote:
> On Fri, Nov 7, 2025 at 7:00 AM Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>>> Hi, Pasha
>>>
>>> In our previous discussion, we talked about counting the number of times
>>> the kernel is rebooted via kexec. At that time, you suggested adding a
>>> variable in debugfs to keep track of this count.
>>> However, since debugfs is now optional, where would be an appropriate
>>> place to store this variable?
>> It is an optional config and can still be enabled if the live update
>> reboot number value needs to be accessed through debugfs. However,
>> given that debugfs does not guarantee a stable interface, tooling
>> should not be built to require these interfaces.
>>
>> In the WIP LUO [1] I have, I pr_info() the live update number during
>> boot and also store it in the incoming LUO FDT tree, which can also be
>> accessed through this optional debugfs interface.
>>
>> The pr_info message appears like this during boot:
>> [    0.000000] luo: Retrieved live update data, liveupdate number: 17
>>
>> Pasha
> Forgot to add link to WIP LUOv5:
> [1] https://github.com/soleen/linux/tree/luo/v5rc04


Thanks a lot. I’ve carefully read this commit: 
https://github.com/soleen/linux/commit/60205b9a95c319dc9965f119303a1d83f0ff08fa.

To be honest, I’d like to run some tests with who/luo, including the 
selftest for kho/luo. Could you please share the steps with me?

If the testing steps have already been documented somewhere, could you 
please share the link?

Best Regards,

Yanjun.Zhu


