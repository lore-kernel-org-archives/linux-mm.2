Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B76CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 00:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DF96B019C; Sun, 31 May 2026 20:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE8F6B019D; Sun, 31 May 2026 20:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD056B019E; Sun, 31 May 2026 20:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5FD6B019C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:54:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA8CB1A044A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:54:46 +0000 (UTC)
X-FDA: 84829523772.19.A7C248A
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id C643F120009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:54:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZdLvSXr6;
	spf=pass (imf29.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780275284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wplUvBwwSZUkE/1pF8JoDJVBT5NIk5fxpFOgyy27ARw=;
	b=Adl9JubXNfaRDkOlEMz97ULzWwAvgugA3fXXPyHwk3bKNbolvJ+Lo2o+SuPMKCbvs6Q3MV
	RXh6CoYogsFOw5ccZa1yv0CthZWf+0rlD1MqaWoQMzMoYgm21x7uUiITqGIfhTg2IsI21e
	eq3jhqIjGNNM/4YFaEYh3K1s2gh4gMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780275284; a=rsa-sha256;
	cv=none;
	b=b+H7JP00X8+HgiHOGZ++6NqeCq1NXhIim/Ap+3wxYkwKpGobqW+AzWoyuBYN31RcDaPX6n
	a4xXvtgtKQo/Xclw0eXTvb3gxQVCnV+qyvebe5Hf8je0B2RIH0xJs+HzilVgc6ept6TfO0
	eVXSE/W51GdZBIc3aJAT3mL9hDk8SLY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZdLvSXr6;
	spf=pass (imf29.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780275256;
	bh=wplUvBwwSZUkE/1pF8JoDJVBT5NIk5fxpFOgyy27ARw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ZdLvSXr6IN0sOxjm16/fc4DJSCHCiT69okgiqQhMfJUTxQbrF3i3et/IO36XyF6TH
	 0ra8LkjUZnqDJSsCzy0ySqO9F7g5jKbCXIFRcBNXnwLi4gvDUDsZ1BeyjLfbkobD4y
	 cLJnr0azS3cO1UT6o77oR2P2BTgTPR3qDgre34As=
X-QQ-mid: zesmtpip2t1780275245t0423d3d2
X-QQ-Originating-IP: UErp3taaIoj7K2ov1DmKucmDovlP8o3qkbRO6SlocXQ=
Received: from PEN1097 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 08:54:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14429530627096407333
EX-QQ-RecipientCnt: 8
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	kernel@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	niecheng1@uniontech.com,
	shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Mon,  1 Jun 2026 08:53:59 +0800
Message-ID: <4378862A53A443AF+20260601005359.26544-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260529150057.84753-1-sj@kernel.org>
References: <20260529150057.84753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MwJMCv7IGsyW0OMjaOMs13To4Fl6JKOmG69lSHdjIrVjZBU1BVNdCRZG
	sv1ixIIM65x/dClUwvTMWttdwXpoollDXnXDNtePtQ+n5jBkKW5Vv/z9wPmJeiwRO78nKW1
	MH/QPBut+g9cueTOns4G6b2S8hNXYaDlWs6HkqFBRLuOpFl7AXf93qpFe5dgsMBUb8WjWCz
	2XjYUIk0uQow3r0a8EilOKyvMVRRT7qAFwj9ne5I5BZcuttflgifDeHcM5quBuLLFgXWQSy
	0AecNgp4etO9fcmSujBc4K3lL8AWylvIGeM6kl30IXvL49Tu7tdmI1OU+/EFfPUzzcl4bYZ
	hqEMjrbdJyCOnrKY4KTXgtIK+ha4acTl6CDAi0RdPImrBflCiAJaNoUDSncKJKKcW1OcH38
	1kYWzE6L5ca3Tz74cw2cOxPSJcOKaWnw+SDC9kW192kmxKBTQQMHxQIn8OVUCIOwC66gmSm
	Sa58QUHMXPu6weva50gf3xTAyg6k8EGBpJwx7UwgnbyGKeMgyFAY6mHZx5iM+7AG+PWLN7w
	MQFgTjvS0R3002E285i9bvPG5t9qFfpclsrs6GtD2LbMssZrWQtL2cdKxwMn9S9jKPVOXw4
	o/+Cop0daXds69HneOta4BDAafLpHV1lKiAE95Y0czCzWG+smyUD6+RG8jxFX5o1c4I/ZmT
	M55JSi6t3ggZxYwHoszkZO5kom7zqOrBqHMwq6Nc3yFobJbon/FPVz4YHIVSSH3sumFVl++
	fJppNDnZ5oL5iispPGPDmhQq/MuPdgPdl6PclEkC2BIXmRZcjwa/5ZWFUcmuxCfdBFr4CYu
	DdpSrUdCUayxnnsBTcVQ3Cz5C5IaezzEIXciJSFzOxL7p4s0jMDXpqHvlCzccj9KkYMxgnK
	i/94buMvUrdugPkTMU1DmEmt6yUwxW6+9nDGkbH6MtVVi6BAl/wjO0bUWCuVsB04wylcpof
	syvVkWDgme93LUS7j4Q3XSTyfvCto2uTsH89Ul1xxgLbO1jvm+o6xijFx3FTVCbfdIUhCwI
	t+XPKmld3FjgfF4GHl0mT6Lepg+YaFcdzLsdEZIuZfyju3+Le6MvIlYAsu9L8=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam11
X-Stat-Signature: inz8jk5sexa86boytz7c35i4xyu1ecry
X-Rspamd-Queue-Id: C643F120009
X-Rspam-User: 
X-HE-Tag: 1780275282-577738
X-HE-Meta: U2FsdGVkX1/Rjhrrs32DC6QDxuIRkr9SR3sKONhZZQ7AUkOu2rgurlDvJ67An+MA5QpeQQhTOX7ugU0rdy3r3gK23gNry7PeJYGgvwJKbKCgwvjkvMBR/3oBuZzm3OkdU9tfEQN76piQJT3PBkyF8IGZuvegl/2IKeEOkknfTsGnY8QUPHvFyiIor3s25UHicD/ITmttyWe/Axtbchcy0jymQzIGvJGBWN/sQaqGqhsR7yIQyVYycdBm9BRF/SMaSoIma2ICrQJFSZ4eqCdkpadF9pZgODiAtbQliyUkQjt3j5H69pvExmScKCPOm4Vv2lf2hmgnTTbemchGwgGI03jdShkMpAa6GF5b5WtIIXB/FXbh8lLMnJoMeZ6lrsh8cg/za0FgUcJtalzupvAana04rjp6Fo0SXoB7y7vuWBrTlxudPdxJz/cP3HiSQqjLXu1lMVK8qwLjV4+aSkjc5/UsFbWW8fBOA0ODRMCxxFuc+7eDVxL8IUZjjVk9GLHiglyKU0ErruiwaGwIQnIS58b7tD1TE0ZEv5JiXBrdF1aIaS+b/td0lA1ZsQvsqDc2KZGBBPAPHqhzMzhkMzXgrRk9EhxQRJnZcqP0l455hTECTswFtzHHAdB1WMFQ722Td4eSAeOmQVhqroxpgzA/+KOgGdaF/w7zTscKWdBCr4eeDmmFIPWrN9Al8i8SuvtS/9yCy2pJbR9xGC6vWMQSiR5oyVlYH4mxuNsa+UL7LY6cjAOpJYnvyyslCMybIx79R7qtGHP0v5N6DCfqengFuh6nik2RUKYw3ZWp8kxb6jVTJUW6fU20mTWgmqNfq3n7oWsOEXIsG7KEXDtGavLHhtk1ZUHtl6bdLazxoQ6XiTlmm+YEbTXNPPLSeH2/ymOJxbEMcfO+j69QEgrI1jfkRetaNoGDiGtQDX5BYjBcVaqIl7mPD51fMbSqpWsEZbPj/3d5GIQDIiTissQQtnv
 eTs8Mvxv
 M191KopdMO67smmdaasIgrryVNYrKvoaIdZC0xZxOPPi/X260VmFSsMJPIK0UTFm6DvFS4pgkQEhWRL073ro4IHClDwh8tlocG2jcG3/alyPl90cAsceIuFvWzz/V/EKtE1OKp7J60NqMxXpZzDtMJt3eaxvQli5T6fK0/sWMl8IFcawX76G6TjCJcRgrFlOc3gIQj6sKF0LZhaO9gWiRbck868BKvMRIS3t0nRGvfGL143yMiaewHWUfQAUDNEyoPRen5KbZa2StpGCbZMg58oJ56ICRT+2+efS+HTy3l/v1bb3I6o7KvrK4maGFGBXDD9er
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 08:00:56 -0700 SeongJae Park wrote:

> I'd prefer the error message to be in form of something like "'memcg_path
> staging: kdamond start (%s)' % err" for consistency.

Will do.

> It seems we don't really need to do commit().  As Sashiko mentioned [1], it
> also depends on CONFIG_MEMCG and active cgroup configuration.   It would be
> suffice to simply 'stage'.  We don't have stage() method on Kdamonds, though.
> What about setting all parameters including the memcg filter at the beginning,
> do 'kdamonds.start()', but ignore the failure, and check the content of the
> memcg_path file?

Agreed, thanks for the suggestion.  I will drop commit() and configure the
memcg filter up front, then verify memcg_path readback after staging via
start() as you suggested.

I will send a follow-up patch with these changes.

Thanks,
Cheng Nie

