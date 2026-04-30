Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14804FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 10:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F916B0088; Thu, 30 Apr 2026 06:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0C66B008A; Thu, 30 Apr 2026 06:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEFD6B008C; Thu, 30 Apr 2026 06:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB8E76B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:47:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30D5140141
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:47:50 +0000 (UTC)
X-FDA: 84714896700.13.776165C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BA6EA000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:47:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGaP6dSA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777546068; a=rsa-sha256;
	cv=none;
	b=hlKhmzriKn6O3u+hqQlSXezBV2IuV+KuCYK5TmmqJPOPAE1aDXX8D9liGnJl11t5brbJeU
	y/O9eB+4MjcxE0NbhKtWFqnR3bZqvxFWKzAnZLQcUDuH8crihugjoYchhjAngGCdRWeGaA
	vK8G8WcBzV4ZHkJ9Fp5tFNqlkRvznZc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGaP6dSA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777546068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kFzqEF9SZEU7JcWZ+PWdc0eQYUSWNkhrao0vQr8y8Eo=;
	b=PFfaxQ7UzH6QUjTfkztT5Cx07x3UUmxG+TIOYVawzrxXKFYBNIoP2zf+ttwSfCNbK5GMAv
	3/GGL7eQaNMiRAhxTN22t9Y883L2J7m8d4HUxZKiH8XaNuGQssh+kDGHQwFfPPnWcio2WP
	reR20xgHyDZRbPwRfodEwHang0cRwbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0C1260180;
	Thu, 30 Apr 2026 10:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EE6C2BCB3;
	Thu, 30 Apr 2026 10:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777546067;
	bh=nAR48QPMaW3D2KAOMmyQEOb81lOwfSZlfPuY3LhL6nU=;
	h=Date:From:To:Subject:From;
	b=SGaP6dSA2Fs55W2qjTp2vtr74QYSgnOjD89uryal9DYfenhk9E+PR2PTH2j+g6NpZ
	 Gmm3Uya3TC3o6wdGRPhpgIXgGzVEWEdnupIiThrTw5MFJsLdICxy62SRhsjXDCSvxD
	 MHfK3CLvz1WTVQIOjjdkYvJASbPMZvXhQFahGhnU1BnymwjIT53nQfOOD1RI349k9R
	 98yNGXZa4MQRn3mErf8pT4o3b6E79Eeka3ATtmKBDBvHYFXb3x/SjTXV0FpErriWak
	 002Jct6Iscj77u2/qte49aChrDRRF4WDKgK8mGrmlZP+tKLJ8tugACPjFPgGGZONgs
	 wvYliwesMhV2w==
Message-ID: <aa4f747c-840e-432b-bd6e-2cb207f2ff0c@kernel.org>
Date: Thu, 30 Apr 2026 12:47:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-04-30
 (today!)
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uxq1pnwnq17ss8rt9bysihourynrckfx
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BA6EA000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777546068-731265
X-HE-Meta: U2FsdGVkX1/kire9nrDC7oBta0qJCgPJJXXddVJjQjelseXdda77ozKl5hPx0bHCpt+v5+ELNMiiDp5F0wwFYW7f0uXpyplqwzME+BE8evAoz3vBVP+1QWRTmpBO1qI+6brxzYMzM7knaG6ZpdDhKesHZwmg8NrLgO2zAZucnOu2O40XXMUBDpxC1MnJWAxSUrtE19n5ixGjRnum+e1Obyh6gKdSG2pos4FtW1cwcvcP/JCFMrkR7HdbANuauYJKLRxbcMbYVbO4gIiDmFBfVzMhFpVTBLAaXsPoGxZpvvpxFgn9sy1n5DMeMUWGAdNb45F0L/KTaJQwFbPqzY/qlfnl0H+V8Tfp9w9koi7JtiCdi0C6+7JtueqsqZbaWZxeS17e3DTMHgs0iN/ZQa3EL1bkCGBg8WiVV6tkqSGr7NBXb7/2c22duyX5yoPnFohnAtfUIFj7SdX/7vWHQZ7hBQPaf4srpE336iqim1BwVlkJWgk0Kt4lXR/7w9Mjy08aTz5HFO4sb+Y+qToyuM3883o6NvXxjLm+pkma79jv9V3gWOxsT+Rt0ZwFcbiJ0pohEqs4qXliNIvGXABiFo8/GSg7lA7uLZpkJBzXSs49Czg3syABx7xirwSXzLLNelutwi9wyZ1/ElpHlIU5pFXeKZVW1JasNpSUNkLKOz5xlQlO1m2NrV9gcWIBU9GbvTKcopuUCjIYWoG5IMrrl0HLsF/u8zrhwchGCVOGmLCXcFZDvCXwEFp6pS566hYqaWfurILmiUzJHbGGzivZQxU02vqYav9YPdG7TwO85PtIqS2RTTZWLA63ALLQZYGBhrPlzNNTSSrDMdO/P61NNkqH3tDcwAA6Mj0UQGhvPb2Xu5cqq0bY2ydZLRR1ixcCAgwJy8AO5ATJT3mx4uOJrJ23ulTLtNLNDw2ysfJnG5aVWZo9lgX6JDt3Gt+QgC8ekX87h4e6llZRCydFrbz2uE2
 G2pU1uPA
 j+MhHrdY85Vmxs6SI8SLfmmydgKxIbrdLp+SIhB10h6FNe7glIXtnAbWJl/R2J+28tI918P4rSZK9ROuwqRarHjyes3DEziLE66nNJNfAXk/AcVvLtqiLbrWFnYTUdPjx43KieG1JjGqQ6kXFDhkl9B0oG2noSviuVxAfShqyyWOxXmDkqnc4OjBvx5FzpYjDZd4u1nu9tg3V2fSl2989+WvkZ9z71Aldg+870B3djNVeTSm4ZpP4k4IBvdBiUNz58Ak3THspPUp4bAZzbecIooOszFuC0glxFi31PJ9DBEBY6hbLPznh6xSHSYgeACvc2jgnUa4to/ddX//XFGr1tfhSawQ0nPs7WdmuW84QcNzmuq3qzt3OKMDrLd2tRg2OGYEvQ5EUwqtSpdoY2GjM1u1+B+X8T6MTokNAQ6yp0rdZDVHWJDC7QFl35w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Late reminder :(

Our next guest_memfd upstream call is scheduled for today, Thursday,
2026-04-30 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

In this meeting, we'll talk about progress on the in-place conversion front.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


