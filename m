Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA148CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8127C6B0095; Wed, 10 Jun 2026 11:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3886B0096; Wed, 10 Jun 2026 11:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2346B0098; Wed, 10 Jun 2026 11:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7316B0095
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:59:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE97F140193
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:59:32 +0000 (UTC)
X-FDA: 84864462984.30.F4AD270
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3098F40004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:59:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B596G8wn;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781107171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wwl5EFOwcAOEDq8p0RlqImogvq+z7shANIcC+8tlztc=;
	b=CxtMjfjevZ5POcbj7+i/9l5S/bGgg+y8e3MliFBy4WODsgIOGS8goyUItLogaz3ugFcfdL
	XWjq8x5XW7rFC5c4cmSSYacSLXOmZ8z0XdzcRe+EC4ZAg/FvNAFesB8q9PWWPccDKJrG3K
	4BtQaUEZuTS5Cl/kAoqOtKv5AS9E4AQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781107171;
	b=QdWTmZOi7Xk+jlpjQNY2DuEVHONopwAltE3hdTXasHhtT3tToQ1kRMHF55uHwpdAFT9ttS
	WRpFZ+HmAaeZcf797ZkE8hWhc9hqVLd3WWg8z28qpcCp0HLSf/ha8vWBq+PfMloz0Fgv4m
	0t2ibDfuhu8HXKQ2OJ93fhL2pko/QE8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B596G8wn;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BC0640560;
	Wed, 10 Jun 2026 15:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC621F00893;
	Wed, 10 Jun 2026 15:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781107170;
	bh=Wwl5EFOwcAOEDq8p0RlqImogvq+z7shANIcC+8tlztc=;
	h=Date:From:To:Subject;
	b=B596G8wnDvRmb7UeeKOXoUJnVEaxNNezk/kt+6eRUKSVAn8HYJU26RIJuJq0jCFVy
	 ARrLxecy2/jdFDvEf1TBuUaOu85pCBE5/uvzNuTMHdBql46cnUCwfYWYDwys3Igyiu
	 EJwqvkFm+ZZCegIAZnBqvinTVbtYTlxPsqv2imToSnY4OyzF6Q0x3F46rDHskGrZYl
	 06+fENzyrC/W0Rg5iKikVRRkZyfrOAluHpNXD2yzwxZqPt9TAoAmdhie6eWM88RfKB
	 dVo7T2ZOf0NyWCFsXA3a2IfQ/mpEYe+ykhicN8KeDwtVrSsSHNh+bsEp+MacaLql+J
	 mqAsGCPhmzU/Q==
Message-ID: <8ca7bdec-847d-405a-adb9-ada87e7222aa@kernel.org>
Date: Wed, 10 Jun 2026 17:59:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-06-11
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3098F40004
X-Rspam-User: 
X-Stat-Signature: q3pu7c35j11t4fq5bdz6okh53qah8gjz
X-Rspamd-Server: rspam08
X-HE-Tag: 1781107171-940401
X-HE-Meta: U2FsdGVkX19DP/dOYMQ662CEyPqx9+uzcUcmA7WHTj3ujqCD0uu+7u9KdpH9Mqcy7d0BDgIeVlBahZfaDbxrFZOrcwqtjWiIvoBnvxurlxGHAFJJhNSTWoiOdSCv205hXIe5lk31PNd3lrzw/f0dWbHwm24UsCM8U9l3ahHCrmO2xzWhw3woTAQ2as+iDTpZpbD1UI7H9pCQUTZIEPwZxLpA73Sr0o+3w/UKTUAi3xDrsAWSFGclSaLjP0+2ProhcuE1D2llNt3kLPQN+zQWgj6z0YaUfp6SS64C/Rt35d5+FvDQRM4TuZoZb0YOV/IKWPrnghBlqDIjh/AYrv7QUx+fIuLXahkHFc49Ik2MeW/KTHywacaX+ILLpm1ak8imSiexNkbewfLzI+O/Sz4auBflVMzdUxPN2ilwgaQj7W2JAVM+czDAe0feJNNkgtCV/+9I/2gU3SkQdtSIhwCrp5ncVaJviZjMsjTXGv6VJelgiqOeZg4uFHulhKEWTEJ+CPXHVWgHJNiFUQkCvdk1qFU4jrxVDeu9QBjnm0D1lXUHQgOktOtsIaqsSD89I04afGlj0+d2JNWixdZUK8z+NPr3iafS7aUnHrN1eM2aVtK7B+obLKwQRl2PDxxf0jzfNlgHInvbu3MI/LZuh1ZkSvD0Jd0gMG7V2wMWDZtAtGPFLaZS02SblHG8T9basY6A7aYQibyxbLG7J09VrN+xTeAeO3n6lI0ImYOEj13VWINeX3QgtEDtpkikKUKzdNGTgT/6H1+SxTmecXX06FLqjpLPxEfFHuSl0xECBmRPybW5xpOXawRCa2YFqWEzcvjvc7KnI9+HX9/Lt965EiZSaayNR1P99xd6WLDuMNzMGxAB0OkBc2Fo2CmL/L7bIfUuD+gUrM5qqIt2JgnV+PMAIFofQsZoQb3npEPkPMBsqmCrkR2hqfAwgc7fnmbK/kvZ+C14qgFS4WEbNtbNhfm
 m3JOHIUv
 81S5yQgDogKIs8/LEJpO1ANBa5BWfRvmpTPchIDhs3nYgkaBeFhiVNhpQqboAqnDnA10lSteqckbatScTfUrWZfugjUriCwW+A/OvAZGNBpB1W8dnzt1aVd02Ggfu2vkuFh2XF9IA49B+vpykfvnS33yxaQ3IxzX6HatLq9+cXhhkTCJfuTm85y+FH/X0z1LoeO06B3VUuL/cclIFibXxBEcFi3pEPYP9aGeK+iuL0SILmVxDv6prTlTqKuuaFKDa04+QuocVOfE423jMGba0zOW9z2YEPqeB8EZZnzjbIeBcBmk5us3yShWi9Y/NoepAz34rqU6TCRXGBoFkTyxzKw+EspdsndWtHfgiziDxBUya5150bvGRBVNdRxTRSFTdZXVruLGg8tzmfck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-06-11 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

So far we don't have a lot of topics: I'll have some clarifying questions around
virtio-mem for CoCo, and likely it would be a good idea to talk about memory
hot(un)plug+memory ballooning for CoCo in general (what already works, what
doesn't, which requirements/limitations do different platforms have, etc). Apart
from that, I'm sure interesting stuff will come up.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


