Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD97C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 20:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A32A6B0005; Wed, 21 Jan 2026 15:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885446B0089; Wed, 21 Jan 2026 15:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7832B6B008A; Wed, 21 Jan 2026 15:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65CAB6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:52:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DE44140E1E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:52:16 +0000 (UTC)
X-FDA: 84357168672.25.859E410
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 521BEC0002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:52:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIiaPRzN;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769028734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UMMSOvqv58f1Cs0DKGW7qONVwTfCuNPfHlhSPn39i9g=;
	b=Qyc67FMNMh6AB1Fv12SzibiiFHTQlzvKVKX9UhhqlWnsVRYdM1PV/x2TV5prsqMN/kSEcr
	85CWNsrapYNxfgaeuzRQArlB7hfKkJIm+wKTlH9nWu3AkF02xz9e2YnYLyk68WHyvYGuMd
	tBZIHf7cTglCE6yJghBpQcqyeX7AlgA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIiaPRzN;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769028734; a=rsa-sha256;
	cv=none;
	b=Q09agVEBPqg8m/hHqNnTdH/bk/tXgCLnjuPuH2VzUVt4STlkieu3COEVs9PF+oS6Hcw9Z3
	cYvplzz5ObapVmR9iKnSoOBEpJVPXL8t4IYeJSsHDj7j1gjEcB5miysZy65WSm9aibMbHU
	cZHkPK7QbIt6T3uC866Z4mwYHIQXaYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 822DB600AD;
	Wed, 21 Jan 2026 20:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17DCC16AAE;
	Wed, 21 Jan 2026 20:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769028733;
	bh=d2/tKtQx55UX8z2+BjLacfm1KeTOulTJbuRiPCHSaZ8=;
	h=Date:From:To:Subject:From;
	b=VIiaPRzNKJGAVo5YF3Ba2qUPkY5M47na9R5789st4b8baSxnunvXFNRkb8hREL3kX
	 +PpdBkfr9/4iRitvDWbsp9xOMu6zluRq4bJxaGkj75uCl6DhOy0/JzAkl7kkhrc+cC
	 inyHn+VqsmZDx1Jm5mW4yv//PLSaKxUKqB58BkYQAYRdemz9QhJurRkz3Nd+m/4laO
	 mIZDha93pA6VYgzwz/I1ReW0GbInSWmGTCFCDLFPswDLAVTqL9wTjm05P0ZhMxpuvu
	 fUYn/dJ8p1A9xNeR4Li5O88PyjfVVZjby09lqkAKepotWLGhh4oEKtiTc5OLOPFH8r
	 gNAuo/PknXqmA==
Message-ID: <5aaaec3b-f1a8-49b8-b639-4edc10700172@kernel.org>
Date: Wed, 21 Jan 2026 21:52:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-01-22
Autocrypt: addr=david@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 521BEC0002
X-Stat-Signature: 8u5usue3tuozqndbh7fbg4tdwr1qbfgh
X-Rspam-User: 
X-HE-Tag: 1769028734-967858
X-HE-Meta: U2FsdGVkX18NGdcqf+Koz26NjqRAYuonWQnrbMHyy3sacCsVraRmClGGInpFBPIMP4QN9HWTZOG+CQWg17gVhOfXGtSoxHspcCNnaxQzpBjN3Eu/XA4G4c1632A/9m3Z0pjhTaBvCHmG6EZ4Rvr2orBDv3T1d3oGgfZkmWzZk32u4qzPwOo55ZlbCLDaw1hDZKuKw5OS5bsn3o+lJyZ+qGIy6bzg5STOxX5Ff5sbNSW6z/ZCdorAvYsXs42doH5dQLoqV6t/X/h31yJfpc6iw0jUnjJywGEWuHPjaCwM6TwribL3F16+CyN/XCui/OrPdd19n3RfzbgvJ8aIfgX+S1FZJvYZGYd1jmll4o8o2PWxr6PTRWg4X9InnF9vsmEIlUH1moLnM8oq/d4rRmDV+kUM8Ox86B4mLG8qAVUXZZMg5xcD+FUbUNK47PSOL7enggQlB+KFR1e1OS3sZV7uCb8dYUrWdy9u2HhQnCoPMzLNSwBio1M1cPiMneRdnUaBR9GF2F//BPWL2W1gE2C/4LMX1kowAuL0Vdkl4ZHfSO984NVJKmRoo1DR4gQEmcfyuyoJyKWK2l11lLldVZ0OGFNyUQAhXEkra/7ul8bFfjr1AVWWv/AkcyB2KI5kkimqXStUO1aX6pwt0e65wfcgB/qkLmy5qP75XHJSxQ6LUTXf/3hAMTfqJ8hf5tYIHQwU1nug/WcOVWCpH7CyjyNLyP7MxIdfm90FSfjhNNj7tP021zilH6WNMsUeoJ7mJuI9rqnFB2gKqOmUPvS059mR8YGn+7q8P3KPbuwFFZKCiJd2MoYGS8mOrEYcLxXAaiJzy6603X7aIZAUVHYlZm5kWLpi9M0dRaB4ZhNrXgLYzvsP0oohW+hY9YmFgXpwkiswj8hq9HnDDECRXqI6ODmXojfHegk7pCty+6YZDbfz8xeAwf3gYqvVk6OyFZOxVEf1yHb/I/JJve+PTopwYZv
 Hs9lJ9Yc
 bsXcpgrwVUZ6tZHLIeSKn2DOGyQIDXKmW8AsindqZvhyDjPc9L8Ed7uu8MIByRvxHOYTQqI4m5jQuXObs7GEs2w12f4YU94GNTAptwDuTJF/8ndJuLAomG0/gDqjsDiA032kVsohSpW+Pbz8qih+iX6wgQcb5YKZCmsMs5i6LugKInXkNyzrYK3K4OmyZXqcw/fBjVfM/TiMFWBVxJdPjjbbt4/cQ/xGtWjsqhjjEcH6BKxXBM3oP62N/mR9gowmQnimCx9hj1So2Q2UMqvX9GUg1xD4nrBqnRuFGnnKGso4vyHRMRumdL52sLeZOdhyeMpYgbmFSnB/6SADQ+TG2HMrHvP1xb1KeVKqZaRf/91m2R6M61kq7y8jjsGihww4R7eRWEN1MYrm7OUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday,
2026-01-22 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

Ackerley will lead this meeting as I am still on PTO. I might still 
join, though.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

In this meeting, we'll discuss:

(1) Next steps for direct-map removal support
(2) guest_memfd THP timeline.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David





