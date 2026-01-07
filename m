Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037A1D0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6641C6B0088; Wed,  7 Jan 2026 17:02:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610AB6B0092; Wed,  7 Jan 2026 17:02:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510136B0093; Wed,  7 Jan 2026 17:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB0F6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:02:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D025813B0F2
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:02:04 +0000 (UTC)
X-FDA: 84306541368.18.877A48D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4027E14000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:02:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gtBO26mr;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767823323; a=rsa-sha256;
	cv=none;
	b=qQl4wIeejtrJ7LfcXh/8QjtkM6HFMJlrd5DZzpH/HQsuK0i8FAbk0hiqPFtjN7kI1lFS1U
	IlXXM7cOSk9M6VOnzVEmXwhcY7Et19eDO6qDW4qTz2DT3k1syEhCfbLDGrH+N4w5K+6SL5
	LWACEwySdxwEuiQZKv/pp4g6fKiX/6E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gtBO26mr;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767823323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f8t0moxLjtguQ3jyNf7CaQurm87BmPdxX6LhZWc+tyE=;
	b=lEpqEBCJfN9No06DcjbjhrgggfJ+ulO/bG9dLaRQYD1LQp4zxp9cFkmcCInE3CFp0mLtu5
	xLdDxRFe4haiA7PtEwZf0cwgC3b/FW7KOAjtCt3iRQdqq/pwL+/+sgv0q163+54aKBgroF
	xKfbYMD/rDN/zxUnkfdpVl5kDYl5sEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EE8D6000A;
	Wed,  7 Jan 2026 22:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F67C4CEF1;
	Wed,  7 Jan 2026 22:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767823322;
	bh=YlJMHUUuvh8UnbS0yR0hh0WfhM6ELT2k6RHzuxZXmaA=;
	h=Date:From:To:Subject:From;
	b=gtBO26mrtjswfvT2GYCpAD4RfBSxUUL7FocjAW2vEpltg4LbObDt8jaSWq/VBdKU9
	 RoLYBZZTyScmqr0KR3XhQ0+GRq+7xSbmhX552N+wl+yTvrpRyHkDF2eEraKb9tBuUW
	 ZstlrEmAFayxJOSTzlKuLoRmFwZWEhSWLGFPAfUcwZ4u/wqMCij5ckEb3H6vtk/cDX
	 DhI+HKxbCoxELIImHcSCSkifOseRV1K6HndKEvZobhmdPSysGdj+bTluT+EjiaaLOR
	 DrbQJkX9mmbhr8dr3IRNuyIJj7jryPC/PaPVM0lKOvV8x6y0VvfSBYj/KWNJ6Q3lL+
	 K7ILTkn1JFlUA==
Message-ID: <71533bf4-daf7-4c9b-a478-f01dc9b152ed@kernel.org>
Date: Wed, 7 Jan 2026 23:01:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-01-08
Autocrypt: addr=david@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4027E14000F
X-Rspam-User: 
X-Stat-Signature: 54fjn4e5nwdcsy7ffo347bd1sxw3p65x
X-Rspamd-Server: rspam07
X-HE-Tag: 1767823323-497142
X-HE-Meta: U2FsdGVkX19fYRqtYpbrXXT4kS3kI/kipcb0IYuQ/lKa5KeVYF8i2BZSsRv6EuPcXUOKM3h5hfk6tqz+Cct0v7NoVOL5NsCtpR9aETdaW0zTguWpGySp5LIUj7Klfq0lgmoYxmv/QuyvveGMirDrlDk8QF9RGD55+2lRKBngS2YNH/1jQK6Wi3f1TWi4untpYJr9rLsF+2m2Q3RPWcAQVYNdXXjbm4pGsGqMEOThLjxByvQ3bIAzNnMGxANMwAuE40+ACT6srInynuI8UA3Q0CjB9plEJmHNgkVmGeh4gWtEEIC/jEJ5AgdMBZcNEzVVzTACpMAmrzibRElUsOOrzbllZRF1WU7KrF33/67c7xdd9+BUwpSQUSrYDdTII4M/ivS9XcTB0x8I6aMUi3boDkmFPBf9GqeIIfLYaE3MQCrK8xXOJ2Pq77F0/c37JuyXlomqIAEdCcRtdtXT6P/ODU3552351mNpxIlUt+TUXuardqmUYQa0vVlcnOhkNnZr+meZAvHjY8rKWnuZH4XQS0T/JVgy1CUYajZMgmxHjVebNiWiydX22PW0L8O9Zgp9D/0yo1IQGCtKHw68xz9OfhNdy35V7r+XVV6Q+dKJ7Yc77lBvbD7Wcz1QJPcOv5H1AKt19d/eRGbEj3fIw9Iz9Ef7Ps1Y7xLNyieZ50CIwIukTRF+qT2Ngqm6nGP9KENfaaSRwywLG2t24jIYsfwKy19EFABrHbZdkVvGYoazS7N5PaCj6lPbN6dahA7qIF+ug71YS2VD4IJf10dsQ/ZRVG19HysfWsROs2OmGdukipT7vAwBkV7GFEs1QUTxMKHTB4HPGMUpKIJ+YqHRgSWLD7dgUuAjmJ6RVVCswN/m6b6gIwv7kS5sUDw0WgkHCmQNkwxuFohN9d2LBz4y4Mum0bcKhxApTL7ddzgphopnvvRdeXWYHzegRysdTVGCGHZK1IBA4OEtQ1WSYlPkhAs
 cF4K1SNH
 xOxMgikHwPqs53sz+6R1r5M6ymtr9Sq8v+6PgdIkX39RKgfuaie+/ULKn4WHASr90RQO9f0wlDvYzyixNt1SiO0WSgvW4qdALVGPfh1v6Cv7nGFK7rEBcdArLnFvSaGW3UsjK4bNbxGcVyQirqqljw9Y6wANl8n03h09S8F2oRsA/jgepXLBiaa9K6aAkRCvNt9oQRynHFss1OFnpie+5GBQZjwjTznJ4A1PhYHAtoQ/TwYwPcFGCt57r3Csb+Ljy/iwDa5rL7uRwf7HI5Enz37fcG34TzXOvqhmWjcjMM5YhOk4E1u94SEF1QVitrq4ieweOVYxOgIoPmWpSPBoMgYz7sDFK5pbW1qv+JWg+16PDEPCHT0Ehy6nWkbdI8mgaJJnKnVreuKzR5WE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday,
2026-01-08 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

Ackerley will lead this meeting as I am on PTO (and apparently yet 
writing this mail :) ). I might still join, though.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me 
or Ackerley a mail.

In this meeting, we'll cover:

(1) Updates from LPC
(2) Private-only guest_memfd THP for testing purposes (continuation from
     previous discussions)

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David




