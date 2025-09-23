Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39927CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C8D8E000F; Tue, 23 Sep 2025 12:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924B38E0001; Tue, 23 Sep 2025 12:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8618C8E000F; Tue, 23 Sep 2025 12:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 739CE8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:30:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D95DBA2C0
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:30:21 +0000 (UTC)
X-FDA: 83921052642.23.80E1602
Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1A96412000B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:30:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=yOTZEw1I;
	spf=pass (imf29.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758645019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y99uiFJpTg3J4KVIyd3kcbAn72jmKkYosX7Y/88AOVc=;
	b=5bIkVFWUppuhuDB+EN+X/SQvmL6FaeVGxEz1bodanNTzfVCklMuwJSbzqwRrStl6OVZ+BT
	/NPnjJfKqWNKOVnEsM9xVICpo71Go6s+ReYCDeZGcNpndA6DdciRI59cQfJxLKHF7VVFt1
	G2BnE5XCLVEkLIDdfvtdjX1QnTUBkek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758645019; a=rsa-sha256;
	cv=none;
	b=P1o6V36GouUyp3GV7R2u8JBzN9brEMPHc+sVO7GTjMpvkpWYaLcvbaU6W19aP4McKR1lmN
	Y0ykcMWEkR441SsNfJA+uGJX2sqa10pNyYzdcLPt/rG9GVXLBG7Ilof/lfsfFGoTPJuT1+
	c4yOs2K8CyTVGz7LEICF2NUvKOHf6L0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=yOTZEw1I;
	spf=pass (imf29.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cWQSV1HyBzlgqVZ;
	Tue, 23 Sep 2025 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758645016; x=1761237017; bh=y99uiFJpTg3J4KVIyd3kcbAn
	72jmKkYosX7Y/88AOVc=; b=yOTZEw1IonbK6S4YQu8OWISBLAJhhYSP/5b1yztt
	FENOZVRUHQYT3DFTrdQIFpH0G4xhr6eV90/OGPXWQk3Lm6nUcLhrwnvNgnb4H8zx
	LrFNE31WMK/0aRLQVMgcYZWhjhH/PBoMUMW/StiIQ5FxnObg0GLyRu4wLVmoDPgk
	iblmp101VvAayHANSSGUBWU9+ycDBnnM0tP7ifpBUlD8M24UNbp1TbsQA8qTJOS/
	oSgRSYO6d4KyumKliD+qVt8L8H6X620qP043WBF44DZRNQndVYAsEk93+CmZ2vYk
	h//10Nm4QGas9Q/F5equAPpNER4B6a+26Wz8eDMlMPqd1Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PM0XBfolZEbQ; Tue, 23 Sep 2025 16:30:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cWQSC4mDZzlgqV6;
	Tue, 23 Sep 2025 16:30:01 +0000 (UTC)
Message-ID: <31091c95-1d0c-4e5a-a53b-929529bf0996@acm.org>
Date: Tue, 23 Sep 2025 09:30:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] driver: loop: introduce synchronized read for loop
 driver
To: Zhaoyang Huang <huangzhaoyang@gmail.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Jens Axboe
 <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 steve.kang@unisoc.com, Minchan Kim <minchan@kernel.org>
References: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com>
 <aNGQ66CD9F82BFP-@infradead.org>
 <CAGWkznGf1eN-iszG21jGNq13C9yz8S0PW03hLc40Gjhn6LRp0Q@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAGWkznGf1eN-iszG21jGNq13C9yz8S0PW03hLc40Gjhn6LRp0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gxzfgcjwcs7gcop6kf3fmcmpwz5rorzb
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A96412000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758645018-767376
X-HE-Meta: U2FsdGVkX18IdTrx+9d+ST85vrnxTWoYeV5sqaxfcWrKPtWYJqPXKxAq2tJpnl8h+Jvthyii+r3x4uYU8FfDLQ/wymaHqR2fQN7WynPDQIfx/DciP3j3QQrIlw7n4EJhfM00/cdVtdHpbfeg2D7ECfUEMeQhOMcT3aIVGd6Ccsz3XyepRhCTo3xbMooOF70VFowevxzlet2486FrEhOPBuPwAYhWeIDyQr4QeZF9mdIAzz7l7k3eBlpnKB5VwyIhohNDh+CyneLaoi4Xc+rLiQI6+h5qAGH4J5yRYeCiidBZQLlFg2pU8eAxNsH3oPEw2V+Tc6OVRlI27ctadeTU6eeG/1+Ip/uOYGLfJpFhYaACAw2zk8UUk/XfmDOwY8kspEZMltnXBhiaXH1chninp7C08rPMrwDcDmhnH1kLc/UZdbgAwg/90cbxEk4JC4jeFPz0fH/zFwL8q8NabGYyeOEE3Z08SQzoL0r/+WKxJfEfo1fA30y8tY4dlVKKohY6oiSwrqrLQbbPvOBr6V5rNGuXEJMNk5w4bx4yQ50k5p+breiEL83dOQewkKFWgOuWIl0cG6Fr43/jv5DNmcDsBHNN8YJEPROPQS47kHND6xO77MZEIVZgDvSikpouV6zIrqQgcx0qdUKewifszs+fEIiGvy/gJkBsRK07e0znPrv2bPKQ6K1IEhE9M/Arja0vYwq4je+OyD09LzZ45SfptOzMlSOkikCNH9zKUyfNz+i5q5b8OOmb10dWU6kJSn42FPgLajF7XvGwpHukp/QD3H4SeGa90vNe7jIhyv00LXtWd97S3S/farav1o+ClyIjV5i5RtbyxjwtvjOZvxr2CrE6bB0cJO1Ms+WfOM485rml0dmJhmRm2KkXagLezwLhUkLJ8OYWhec2XXeMwkDPyBkI340tFeUgyeukTxyEDu/eMJXHOEeGlnGLN0D3js/DTUCEn7JcNNDM4DYnU5n
 oFCnlU8c
 pR91BHq9NUnbKY92xZP+zulumYFsnzp3PTRlv9HdaV/avEVJ3cciicpv539r9KURQr/dDSKABZO1YCAQ43S9RyWjgfmCF7KABj3v7FYrVmRvsw/mMsJBgsbvECbFCuXMfv1p2cPGa/sruu/OSe09I+gIHF5KIZkaBbw7VLOZM7WNtKuwyIsDq+SmXhnCDLkudRrI78pS4txC6Nkvw6ouTSGGI6p924sZHxQuT6OI3G7HLtcRvONYKmdWazUvZ+aFiSp4Vo1Jofh0ntcGayqwh0vRDCeXl9R0tSJy6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/25 8:50 PM, Zhaoyang Huang wrote:
> Yes, we have tried to solve this case from the above perspective. As
> to the scheduler, packing small tasks to one core(Big core in ARM)
> instead of spreading them is desired for power-saving reasons. To the
> number of kworker threads, it is upon current design which will create
> new work for each blkcg. According to ANDROID's current approach, each
> PID takes one cgroup and correspondingly a kworker thread which
> actually induces this scenario.

More cgroups means more overhead from cgroup-internal tasks, e.g.
accumulating statistics. How about requesting to the Android core team
to review the approach of associating one cgroup with each PID? I'm 
wondering whether the approach of one cgroup per aggregate profile
(SCHED_SP_BACKGROUND, SCHED_SP_FOREGROUND, ...) would work.

Thanks,

Bart.

