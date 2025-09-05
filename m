Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3AC5CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 05:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BD68E0005; Fri,  5 Sep 2025 01:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC178E0001; Fri,  5 Sep 2025 01:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238F08E0005; Fri,  5 Sep 2025 01:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9698E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 01:42:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5F6411AA92
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:42:39 +0000 (UTC)
X-FDA: 83854102038.14.506EF09
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9610BA0002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:42:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="mLgtGvr/";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=JaXDkq5Z
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757050957; a=rsa-sha256;
	cv=none;
	b=mlaFBMqOk7JILG1Wl17O1zgAqGyoe5jwFviVKxdkfiItxZ0d+RuMyUg34qwZJy7haKrBVH
	nmYa3cgRoJiL98+2p0GPKPrqKJf1+OofBEVpnR0+3l0Y9xlQqXNCvo6gdrk0MWQ8Iljmyn
	mBnFHvHSnEJjH2gXJuuJ01+zg7GX81c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="mLgtGvr/";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=JaXDkq5Z;
	dmarc=none;
	spf=none (imf15.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757050957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uIYavXuvVkxql4mic1RNmmJBV9tJQbXNRB/J1rntf0=;
	b=mdeBnNJDkk8m60Y7Lxn115SUuDXj1chf+RF1rVMRuXqXOqyMY/5CZHxcJu3/w0TrbzUtk9
	67Z/wLxOF7cMrZNtX5GDfSkKpfZDqpOEDrBSAJMcoQ2J3WbcciX5WNZ7nNUpp99qp/a+fO
	w91ovJhPMiUOyCUk4qYoi4b7EpHjTCg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757050955; x=1757655755;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=6uIYavXuvVkxql4mic1RNmmJBV9tJQbXNRB/J1rntf0=;
	b=mLgtGvr/BTlnRFn/pTvavaa4974fH12hdES+j8R3lvvB+FxDQbDhvD+4UdTaC5Qa+BeE5nQKwzufk
	 MDkikHh1KVRdK/Cn/d8FB9sjxfFmyEDr6dkVS0JK4b8fwQT09poQbbznFo48JZfM8wfnUFamJUIxS2
	 +p+1JMcx3Ib5MH2tQR3YV7fPEnRSWA3ebm6lw2tT/21xEpnRPe+5g708cZfN1LthhglEW61hLi9Yyz
	 owLpWVLHXmoYE8acBc56ASyeMnjzAEnXqOMawWvItOkIBapfHdB49tjH7cGtJmHm/T/lDBMy3fxych
	 +0xE8d4/pnySdV4t3HvgQIGGMNr2rTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1757050955; x=1757655755;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=6uIYavXuvVkxql4mic1RNmmJBV9tJQbXNRB/J1rntf0=;
	b=JaXDkq5ZOIXjTTFAUqiTpU/5uDNa/k1YWbiF+9kYGW0Pm6bX2LmPpdLOXda1ahGuRVrnTZJaTQ5zS
	 xUcO1u9DQ==
X-HalOne-ID: 1f4ec321-8a1b-11f0-8613-e90f2b8e16ca
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay2.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 1f4ec321-8a1b-11f0-8613-e90f2b8e16ca;
	Fri, 05 Sep 2025 05:42:35 +0000 (UTC)
Message-ID: <f0869789-ee30-4eb9-840a-502d031df1f5@konsulko.se>
Date: Fri, 5 Sep 2025 07:42:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <20250904164710.210731847fe25d9419203886@linux-foundation.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <20250904164710.210731847fe25d9419203886@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9610BA0002
X-Stat-Signature: eidwmm1yijie85j1nffp5wo6dt6fgm1u
X-HE-Tag: 1757050957-18868
X-HE-Meta: U2FsdGVkX1+KZ5X2S7vVamFpp+Efe8v0NJJeS1alD7APhRjGqw4SAvubl9jbH+jwMHJskYQUsfaUZ9UqYbW2i/w2+MHaNsp9KHhV0Bn9WM8tY81oAWNsYONbzMYCXiq1S3L4InmJ60DwxxmXV1FlQeN4zcC0XQdxVSRWlVEZB0dnLdr3W2GLjLUF2jSMCRZumdAcFcGCKNo/EKn/z3M5rhzUvNeUz3VE6cHeHJlEpbf7yVD8U0rWPoVgVcSm029lTML64DGcWW7QWTbXyhg1Htu5MIHaCrO4krqPraiG+mUtTMs9WfFE8+Cd8C3nMTuJFv1hzEv7qJAqzumLjMP0xHDW8ZQuZklevxo/faeAdDZTLyJ647r79fceyCfKX9fD9d5kp7p0KwSRuzT/4QTYETkmv5jbSyqBs1tRzwXrf0yynjy/4OkIqIiCwW8np72qNzyyYi82VQvhlF22KctWB4bRsj4Ym8HOMSvICCSMW4WjIS8R/gx0tyo7/l2Pvik2OJIVavsyR6W/XoUNxWHlhbKta3pL5uWIcdli6Jhf6Rk46QZeNA5N++fXcczJzICcPfGID5iLKP/P8Sh6UyPY11UobpVUTMSB1UioJSIZl0eEU5c4Qm+n23naubPml7xlS8fpW4YSC6jkxRtlO1xLfE02TwZycRjoeG61N+RJEp+/D5jYlCmfyix9JySWd39rBDF/cuRSpFPY+yZlOU4G9jsfoZHeZm1yP54fLq+2F4p9JIAKeh3ruUggwmLm/cfUIVOq7PAKsaIGzJHJwt21dL5x2XW6dCriI5s76KnD5aAhTNOC5FN/yr9Y7Rdgiru+A78/M/gBoXi/Gg8qa3up4PvRf7osdlNG+piDqte3lIawNM+4jCoBBRMhDWPztTJ5NJwjhqIidEeR8zCxr1Vnh8F/6jpUXXnlYJyMzSrhMlkea3Dulfitlo4VXFD29M/qHzusWTLqv2Bwr2EvsmV
 SOUqY23I
 LSDYXwd+mzCIdHRNLz1UGhpfKrOPVOorL293tV9herQPgdXGBrIMo494fJu+/tu6MTeDf3HdliVXnlizDG3VTKgDovZ/x03hwWPa9STrhHD/84qKfZWlRO3LWq7SQP538RjOZSp79AYlk4eHUv6gv7Rm91MzS5o3c/07WyPd+VFYQ8FWlT0ANB/YzqgwLWfltq55kvnKyzwD8VMaXH3IOHsgDf/lD7VRspMyU7j4bKYOV9Mn/V23EBX84xH6913u/xRCl2QKfJY2wZTegzoKqCa/LBKnVNmApABgSjdOBXgu5oWjrnuhP4LY0+Wv3l0K5VREl6CL/5kKhXAo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/5/25 01:47, Andrew Morton wrote:
> On Thu,  4 Sep 2025 11:33:24 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:
> 
>>> With zswap using zsmalloc directly, there are no more in-tree users of
>>> this code. Remove it.
>>>
>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> Per the previous discussions, this gets a *NACK* from my side. There is
>> hardly anything _technical_ preventing new in-tree users of zpool API.
>> zpool API is neutral and well-defined, I don’t see *any* good reason for
>> it to be phased out.
> 
> Well, we have the zpool code and we know it works.  If a later need for
> the zpool layer is demonstrated then we can unremove the code at that
> time.

The whole patchset [1] depends on zpool, with the whole intention to use 
it on the Rust side.

[1] https://lkml.org/lkml/2025/8/23/232



