Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF55F428C8
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 19:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4296B0005; Wed, 15 Apr 2026 15:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865916B0089; Wed, 15 Apr 2026 15:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752F56B008A; Wed, 15 Apr 2026 15:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 645996B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:19:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 187131605E5
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:19:09 +0000 (UTC)
X-FDA: 84661753218.25.FDEB7FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6AB231C000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:19:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VLLShjcI;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776280747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jql/qHKdfL5AQyBBEKy05tU355MQ/oUNAU9rOUQ6YO4=;
	b=GdDY2axezi6uV43Qt6WlNulrj03agEJGyXwPaCFR0ZIlGsWWjECeWxCXGUSBe2Yf182eBR
	rCEYpl0+wtCPB2kZK/kNhzXgQ+ooVkBb3aIaycxTL+2nd9Gq0SNnm4LYci6+WhC8CxCHEZ
	eKvm2LY3V9wKlEICcbJREFTQJ2Okl+c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VLLShjcI;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776280747; a=rsa-sha256;
	cv=none;
	b=c2pL706LWEzFlCBCYcv6/yJB54z7JbLxAqG4fY8evklhu1ntFD/fl3egWX8qfgtBmjP7Qi
	X/XWUB6kLNIX991rA294afsS0Q9M3uqdYLb7uTJwzfjwW3ooBPvmV6mu7wVgXQXMg/HOFh
	Ag9CXpemQnlASPGZRFz3g6Urm69ghd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9140660120;
	Wed, 15 Apr 2026 19:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB66C19424;
	Wed, 15 Apr 2026 19:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776280746;
	bh=scCdsYjFYYmIPYeVxOiQhweu4J8pahVfH00BNvONAWE=;
	h=Date:From:To:Subject:From;
	b=VLLShjcITeVLMl0t21iWavTeH/Fjdj0ryl+MX3nw4Oyu+bJH66MioEi+LTLgJiHA7
	 kyBghLnt+ajQ2vd3IIsOB5iFG+9A3Q7BiGieCEl7u05MMmUPxKWWmXlr+XV/4Qt3/r
	 xt4iZjWwzmVbd/WMuTVWdpVJOdWd5zoKWApF6SRdnNMRhcM//9DxjdYNXNiISn0bqM
	 iBz19yQu4py2MpFPHW8Rp3cSiwljC8YsoEKeW6QvhVaWyohPtWy3VJkdlghACiyBJJ
	 rOGP1x/wBIYBYSvC4QwudOWnQxRJS3BikX/jGhBRuUtOM+XNsro90OKqfYexwz5DWa
	 KwCkogwqTjglg==
Message-ID: <dd0902ff-f132-4e07-96cd-2425af99ca55@kernel.org>
Date: Wed, 15 Apr 2026 21:18:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: KVM <kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: bi-weekly guest_memfd upstream call on 2026-04-16
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1mwxkr64z1js1qm8bcgztsfkkogognwz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6AB231C000A
X-HE-Tag: 1776280747-878089
X-HE-Meta: U2FsdGVkX18xCmK0MugFkUVd88XbB9xnLMbVLhFppyAownAWgp9/M5wUewuXFm9ptQswauLm9pn/YHz7jpRUtmIgTpDxAqdXqTL2lbGFUH62pVcpzyM7XxSWx7NX+5E3iw7hQ4tdMRPDUMWuDCsWsYXYSMMJgAv/yRGEkztMAveCiRERJkgyExjrptc3ic8hxF75RwbTxtM7rsanTxb/1HA9dEYrRlVow1mzNPTEeX3WojBZ18o+W01GrWPOMlosZNTzDCTTiTaH2JNJc2mfmj2Riuo3z07U46tK/zMJwbiAbhlgw4yxZEwFwl48M1WmcYQ1dLsCQEANYAgpuw8QFuCeqYWyFpMmJWZIQF1ZQGtLXXkBhQJjvOn9/DeAidsnmzXBWz42hJ8xjoTpni4RC2NGLVw4kZSCnmWcuBIw5pnR/AaywMldE44gQ9gPSjMOD3oOJCznYqvmdXTvagldbXhqtFrmvsXpynPbL8NrWcxc1OV6OXdbiOzG6nYicSSL4DTFW6cNFb9VWDMCKBm6uhVMBKLPQg7kN4KLybolb+6xTd8zfIKNY9+T5emPrhYgpbpOIEr247LRlaWJnAQf29so6jX01pmNLwUy0ev35CSMoOOFzdDQ2y9UVH/Vuq98ZJiHB9dsHhQYIZ0ywv/gEPuo/ArdEHbDLqeFnng2zLT5LsE0tmv2uWA4qSs0WJZmERzBSuYhNfxk7N7VGsl17dEaRlL6EvL/WMoJF1klWV7+kj6W8BGaaEDkSPR6Iu49UbRHb9NWJRDQla0bvPl3ncQfItIxOVYLf6wBbaEE7AHduaisWoj5SUoOtcnf3utO1XrjhvHk9U88KJqsK8hLSb5gPxOzpfoLZbqFHBRrhw5EiPFEZUR8yQv3S0+LDSLYS8meIg92ac0IhDdprjKodceFrlIW0GitK5J82+0xTph9fAVtR6QjTSL27JmvkwB7J2wthPlnLtX9gW3krW6
 XUoWemYu
 pEH0lEaU1rfMy48lLH18MpTCiYWy1mzKSdlTNf8TjirjjPatg6bxhdxXrlAooB9nfUYahgBPDf2BaDbIdGBttTuahYn4qvGkIbeOSkT6Y5I9lYyOdSK6g5ePY6qSZR29BGpifcyOajwOnZnopauoywltLTcDncU9Tc/6ozlLZSa7U4wWRidz3/TQl0w+bTxQRTATsESeFt694Uoz5SjoOOLP6kbeUcoSgd87XH5/sSRg+hIeyZkXfwkuOZxrk90odGH6RIrpuJl6oF7BUWi9F9QaE/g2yCKzAiaA9/6Ggdq6z8MAEmMng4TcLhvzRlk0sJGArda8wVi3AffK06oMw5tk99pwNdDfPpIUMlrSn/NfVxgZT2R4ybs4aO70z9CGk2wEfFDxvCDDZjcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-04-016 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

In this meeting, Mike wants to talk about IOMMU considerations for
in-place conversion/hugetlb with pass-through devices. And I'm sure
other things will pop up :)

To put something to discuss onto the agenda, reply to this mail or add
them to the meeting notes.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


