Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266F2FB5E8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 23:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF9F6B03BC; Mon, 16 Mar 2026 19:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA266B03BE; Mon, 16 Mar 2026 19:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA7B6B03BF; Mon, 16 Mar 2026 19:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 690056B03BC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:26:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1445A1A0314
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:26:22 +0000 (UTC)
X-FDA: 84553512204.18.EE3CBE3
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0F8541A0010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:26:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=3fbO3MKz;
	spf=pass (imf19.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773703580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFQ61RTtycUh5p2nWyByuEdkQhIoYRlH2gukTJs5mis=;
	b=V5g57nhEYcRXh+mYth9QneK3sXCTtITK4uhS7IOwZtLh+HJoFHG9rcASKFOInMv7NWFsZd
	NDWdRuFiPTDVpYunyM9F1OBbOCjCIOnOqqgYj53Xkfc+UObO3JlM2qRh+dwAKF20+OYWEF
	i7I+wMKZ8NjnTfEZWJ9q1CUS2Ddbg/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773703580; a=rsa-sha256;
	cv=none;
	b=dCqF59H3PSKwDZaEAP07WdSOg8QfTYLmZHrYBIoQvrpExVxiZMNAHEXI/jigPP4ZPS+IeU
	KREitfUeUVU4w7kWniImmfYHal8kjBqyDYxRPyUphb4g0Kh9c0OJYiQ6BU8fmc1U7opA12
	eva8N5ukbmlBeL7YXTkuO6DVONIDxdM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=3fbO3MKz;
	spf=pass (imf19.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fZWSB6T9Jzlh1Rb;
	Mon, 16 Mar 2026 23:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773703575; x=1776295576; bh=YFQ61RTtycUh5p2nWyByuEdk
	QhIoYRlH2gukTJs5mis=; b=3fbO3MKzJyhSowx5+dbqwzHKCmJZaHbAEnel4Q9P
	3QxKpWRHJdD55yjZ/xAurR4IDQ5joX0nlqCPlHfy1Cv13NTiGjOTGCr+3tiIqj+P
	7p50r6VnMmOXPqCJE+5L2Xvekb5sf+vAKTqXtEiAyQvr1uC0M6PtgCUuZJIBkP5P
	nDB8ELeXzurajKIVnmy4dwplGfiq3q5RVv5H9KNYirOjB8/dDhB/D7crrOjTPmwU
	sqMecn75EMBDz94EhMdz8AUP8ZtHy60fpvO3sQUj7FX4dUW3xo4EkQ2DH3J6P71U
	7Cuu4+cSQ5gqKtdKu0GGb+UZSCcb4gvi8x+RVoorDl663A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Is6MgBSkwYAp; Mon, 16 Mar 2026 23:26:15 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e19:8:245b:9369:f866:f27] (unknown [104.135.180.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fZWS56y1yzlh1Nt;
	Mon, 16 Mar 2026 23:26:13 +0000 (UTC)
Message-ID: <8d6fc6da-4406-4609-92a2-c5e7e9475c1f@acm.org>
Date: Mon, 16 Mar 2026 16:26:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
From: Bart Van Assche <bvanassche@acm.org>
To: Hannes Reinecke <hare@suse.de>, lsf-pc
 <lsf-pc@lists.linux-foundation.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
 <e2733d9f-823d-433b-9bfd-24df20b98b7d@acm.org>
Content-Language: en-US
In-Reply-To: <e2733d9f-823d-433b-9bfd-24df20b98b7d@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ta6hm9reag6t51sthixuz1tsgy7tbdgm
X-Rspamd-Queue-Id: 0F8541A0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773703579-997357
X-HE-Meta: U2FsdGVkX1/05GhH0msICSXm4CB4ry32jpZfuvniD8niIg6BAitiqUh+2mODdKPvHHz5QxOw1QVEdSKLSciZ8vyzJOF+Xhu5uGrZ4wF0TSE1R2aXi8M9zcfWn2dYSvZ7FviQL69NDhg5VFYoAf5ZBM+QsaFtq+UCc5R8L6kGs9vfjT74FXxDQlq+LJ1MOORvjf/xmJpmznSYG6Uqr+TkPE4KH+wZ10Rew9C587xN/kVZkySUx9s8xAGE7Q7vbrU3Q4IxoI31GWoIv3Yax0LywyhpqhAnXb31c28aiaM/Z6hvp7iTmKHzYOkE2CfKIL3YE31+aBe52Aq92VaZfgAuDXD/gepR1Uyiu64Pr4H9W8b5++72YbGzMwcVnS3LWDJzK10XFqvJLkj9+3GtObid7OQ4U68+A2DFw58EMcFHx2vad+nyWJOH44+u0D+xjM7Z8+i5QoPurKnPAVW2KpyfLFQlX1pDQfPLF4cUazuq8yv5zYQ8hg4IJG5xanx7llxcWiYW4iUUzTpPlg6YCD4FiwNnJ+4WUFaTYgcJwRiW20SJf41ziq1CHQg6PansI135ZhMi8bqTs63X1kWA5RzuFHEr2z/fi/xFokaKlOYtZAZLz3oUX36HLxfyEp3D845HWfs7LbQgczVjG21oQowu+fSQGdhZ9h/EhU6Fx+hcawoJVYDSYiuU1k14u6t6zlwl07liNxoJ5jbVqo6A40bkT56VPDZNbBsiOEgb/F2KaUtvZ/U1nUwyKVrjFmOhYIAclwW3+nnGcbCqlsk6KNGLc94hdj6WQ5b2/3Pftde1oZlSIJ8nxBc0LKazQFyYHHhKexEKTsFVd9ztzekwjwo1R4b/XtUmQtzoZnJvhjuruLuLHS4uzzGtdMyCj97K5NkMpnJ8tusJAx5FpgvvvzKDzehZAFffofzvUIt+fUWsDrz1DG2HVu1CPbBlunlwIfg2U8Q05F5oBKLxp3PIt1B
 6iW82r15
 A2HzRHUKkuuqWJQIWN0GfQ1lOjqYa8HDyESMXXzwj4ZiEQns3cmkROynHzez2LWsMGmV7GHUZluU3BoxMHJk4Whq8pEqNzTJ/A3V2O5HY2M7UE/vlQSP87sRzy4tiZXMrP96ivgDJBvdPoS529MSn9bLTpIJgTT3h8n/NkWZFBlEVF990wd1W6wAnAlCcSt97s5iybbdhg/UlbxnBIMT7KVW/TYTwO3sEqONk8hvLU1MrrkaYetMF3Onw7ekzZsFOtUlIhXy9lV8CJSpNeArNGcTfnQ/Lj30UbxIgziNroWJXDxoFu8mFwZaNTHCqJbc7G5++H/jcZzEbpngUihTM4xmg75efGEjgUZfj0i7+0/Esw5fMItC4CnT1mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 6:53 AM, Bart Van Assche wrote:
> On 2/19/26 1:54 AM, Hannes Reinecke wrote:
>> I (together with the Czech Technical University) did some experiments=20
>> trying to measure memory fragmentation with large block sizes.
>> Testbed used was an nvme setup talking to a nvmet storage over
>> the network.
>>
>> Doing so raised some challenges:
>>
>> - How do you _generate_ memory fragmentation? The MM subsystem is
>> =C2=A0=C2=A0 precisely geared up to avoid it, so you would need to com=
e up
>> =C2=A0=C2=A0 with some idea how to defeat it. With the help from Willy=
 I managed
>> =C2=A0=C2=A0 to come up with something, but I really would like to dis=
cuss
>> =C2=A0=C2=A0 what would be the best option here.
>> - What is acceptable memory fragmentation? Are we good enough if the
>> =C2=A0=C2=A0 measured fragmentation does not grow during the test runs=
?
>> - Do we have better visibility into memory fragmentation other than
>> =C2=A0=C2=A0 just reading /proc/buddyinfo?
>=20
> The larger the block size, the higher the write amplification (WAF),
> isn't it? Why to increase the block size since there is a solution
> available that doesn't increase WAF, namely zoned storage?

(replying to my own email)

The following paper shows that it is possible to achieve great
performance with filesystems like ext4 and ZNS SSDs by implementing
an FTL in software (ZTL). This could be a more interesting approach
than optimizing host software for large indirection units. See also
Sass, Jan, Andr=C3=A9 Brinkmann, Matias Bj=C3=B8rling, Xubin He, and Reza
Salkhordeh. "ZTL: A block layer ZNS driver." Journal of Systems
Architecture (2026): 103757.
(https://www.sciencedirect.com/science/article/pii/S1383762126000755).

Bart.

