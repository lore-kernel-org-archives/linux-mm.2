Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D7DC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175436B0095; Wed, 19 Aug 2026 12:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1266A6B0098; Wed, 19 Aug 2026 12:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0145E6B009B; Wed, 19 Aug 2026 12:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C305A6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:23:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4805F80414
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:23:25 +0000 (UTC)
X-FDA: 85118539170.27.9079C8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1BE6140012
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:23:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBP0ue9a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787156603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ldb5dOInQjpEK8qwvxT9Fxl21ZWTetKva/zFZH6RD8s=;
	b=7XhCWV533cxznSqbQmq3Hgqv8Dn9jn4WPCrJaiON/ViJQnqGpzgsurec1QkoEk1gGtXfeR
	/LJ/wxvQv5DxDrLy9NJaegc0EJZ/FxtQtS6oV8CutNKRzO4iCgMGfaaQ2bER0gO5DL+m9A
	dRqcMTykT6qGD4G6El55E61USs/xlk0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBP0ue9a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787156603;
	b=fzYO7hxSY6nAd+tPmSCsvRHy+H/qKTygHwj/D2DCAbaXg0mC5yrk37e9Sw7rODKt1IybyE
	FVBU2PSJomgkehrBKEswrmdWsgo5ZO6NutPG90pewIIJgtEVy3oVWqRJLDQmFhjakGCnJC
	IsGEl3oBrVNfJepeAu3f6fvpit16D9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34F4D60A92;
	Wed, 19 Aug 2026 16:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E5C1F000E9;
	Wed, 19 Aug 2026 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787156602;
	bh=Ldb5dOInQjpEK8qwvxT9Fxl21ZWTetKva/zFZH6RD8s=;
	h=Date:From:To:Subject;
	b=lBP0ue9ah1+okMOcT36Fha7BZdKb2IlP+/SzvGEBaCA0QksCErIjOZj/cy0EMqKPU
	 FrKt6tsFzlGjsSwMrayIUZxjiIra7KCfqzVpTL/iSX9MC5murtY5Ul7qr8MuS05UPN
	 18szLcbk6ml9B+yfJAh29inPNBA+X1MMyW8kT38T8Dncb+hM6ps3RHGd3tjSqzGzcX
	 FLzzEVL6xnZuu662fwfUXe1HglWjI+GtIgliN9l5D/Lxnml1e6G4iHhMv6bbXwGC4H
	 yS5NnQ0L5IK66XxrVjasds2fArlqvLiQKPxGFwk6RHW5bAiBUAdejr17flNmArXJeJ
	 agC9bNzFcz3Iw==
Message-ID: <54d375aa-8362-4e1c-8f76-bae1eb9f4f76@kernel.org>
Date: Wed, 19 Aug 2026 18:23:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-08-19
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A1BE6140012
X-Rspamd-Server: rspam07
X-Stat-Signature: hmd1z1suuzkmg1osan87nqxwfnijy5d9
X-HE-Tag: 1787156603-795097
X-HE-Meta: U2FsdGVkX19tA/p9UbLcZyRuf9fv40ECYnldObZMhTTDA3d/peFQVmAicpRgFGsV/XHCYO3x2XdCqxBmW8lQh8gqffYM6C9iDebWrNmBkc4uPeicMpEPdxyQzI934db8IUjpBvEgarMjKyDj799cHJnE5m+tnzS2bYros6AZYFkW2Kw2j++sbwKFs2ImDY9BSa7tf6mrv8qODDnVlCKhWx3ao1KuAG/Qii6S1zq0FHupuTuIrKkbIOiiv4ezo3Zq1tebk72BKtjc33W4z6EVtV1OKvbqdBDyYHH0dpM/z6+D8w83Suh3ye07K4OZB4j770pL8B0KEoh7vkLdy8PY/XMy0Vlqf/VsSx263ZU31A+f/dg6C+x6EamCyY0GrN9PQpjYo2YqI5KiI2//mB0+i/lDA0APR6EcEPy0nc2ftj8rEv/s4hffzEBRkf6+iXG/RS/24QYo3ydTtSGb4E9VJDYwX+tMvrh0K0l9BqzRy8RZs+X2I/5O8AB5I118C0kV0BtBtUI5FEFsMudU4l37uxvYWvuk24hfLr72v7AfpH6nYFI7Jd0uj9Dj8lZJx8dGzIwK0Go2kj/qNkYB+lyNVgmzE5L9KO0e6e4wzDLbUWYCtq37M6wTrRla/47ocblvVUmmiLBoQ3N4LSV5R6GPB05YXZOhyzyi+Jt/FqZaadOt7eAG7mlWXRaVJzktx8Ie0Oeyey//MoHjwHUet1YBYwdphHfikrmJbrDn70/UaD/kth4vUGK0zAp2rJ5+kakJ/2A6R1RmnG28q6Te29nXreowlbW2E9FEmiif61smfZNGYe94Z3+b6LANTJ8FVrOrXjPCE3PFxP21awVRV4yivUPFhxXoVKJewieV1XKYOLLL/7AmQw6DcN4rC16WBeo/JtgEKrJLlUeqP4egpA8eh4iMKs5YcawcQGrGnNd7LK8TAbRyemlQKzn3zAsuXv8oQn5fsk0wDDYw1Nx5ZqJ
 VDBPmB7F
 STmLT9N0ILynJu1M3zSbganS15oiZfxhEoIHWFYYNay8CPE8zP//xvA1LxLi7VPZwZdmPARoJeui1VrK72CMl118b3Ng3Ew/4I40+dOv3TQQmULOfVza/ZdePt3XuWWesEgWcy8WJHoQzN7mjmpSRTgwo+xlnhhFCDl4aCNrEEHk2t2pOqdmRwWAweAWSulfH78gLxRuyTBh7fECHYrh4+TJZCQkPgLvgz0Yl89pnkV46jF00XeEh5q+5Xem8g8K4IWR2Ke47iYCs+kcdZxkxnbiifD63VcXts3OkylFWnPoePrlkg+swAjYJcKaEGDbqQLJqxRjEw8r/DZD3hmDB+qe2J36789reAUoOh+9kTDUGzQlcFouqW1rfqXw2FYPJrsW0/IBSJ8u0ctg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-08-19 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Note that we will be skipping the meeting in two weeks (2026-09-03) as both
Ackerley and me will be traveling. So if you have something urgent to discuss,
please speak up :)

In this meeting, I think we should sync on the recent developemnts regarding
in-place conversion. I don't know whether David Woodhouse will make this
meeting, but if so, we will also talk about guest_memfd+VFIO.

So this meeting could either be extremely short or very long :)


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


