Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B337CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C73C8E00C7; Fri, 22 Aug 2025 13:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550998E009D; Fri, 22 Aug 2025 13:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0BE8E00C7; Fri, 22 Aug 2025 13:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 267938E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:56:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E23601A02B2
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:56:36 +0000 (UTC)
X-FDA: 83805148392.01.2F4F5B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 79D6540005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:56:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gb2Gkqf8;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755885395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rngj+FprWP8Hj3dQH+a/77m6oJ8PBHcM1pZadyXEQAA=;
	b=NrtAjV+RRNTbbO0CMJW8Xsj+/CO4iqPN5lutPmq38mNucObHy0IJNo486d0Y+WPzlE3tF0
	Yzfp1ePKbzQ4g1W/Hv/PnvvTulGyB6A1OdyAca67G326arF9BgxSFWtoAmt3tqnBNyzOGs
	dDAPwwLZ+mJM9/m33CmqN9MDLtJlE64=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gb2Gkqf8;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755885395; a=rsa-sha256;
	cv=none;
	b=xAUi6yY5GmfHICTBuGlE1EaBYunyvk/oHPexbMPpkoZQBj+ME8EV2i2G3TUMJBR7X5IeHu
	FW/0JI7k+gvG5zExDprKYhcPiG8HgwCRQr10IMDuDJMIHOw2sDUTi5COxkT95ru8cC8QV7
	JFhnF6U6dlG5knT9vovNZ5879LDY86E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B1E0601E7;
	Fri, 22 Aug 2025 17:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217D0C4CEED;
	Fri, 22 Aug 2025 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755885394;
	bh=k7VWYIjPAzuV20kP58e4+MtV8ncD9UUDxLstpSgppv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gb2Gkqf8MJh6iq3LqbZbGGKfdPS1/dsElaHM+WfLst/9cryyCUKwi51sMVKVPNZN3
	 Ld71rg/p+2fOt6jubauyd4geJrKs3Div7S2hsc/EZmhOTvDCsm3mEZyroTIh+j0SIr
	 YV0+hC5Vrd+oqtByeHSMSA7Un49FwS802vxCQe/4WhxjxYMCpUOMtHrYiZR5PGia53
	 XCL4md4T0KZAYHfU5IBIg8ov85Og28DHAN4fK31gPfpIvGZUhMf1FEVRhbbTo+1VFs
	 ZmQ9r6pK0TY5M+H4522JgdhxmgPD07GAmz+7MuHU9D0WBCEClO5oErqv0XvzGA9uxV
	 XLQWpp1m4s08A==
Date: Fri, 22 Aug 2025 07:56:33 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, axboe@kernel.dk
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Message-ID: <aKivUT2fSetErPMJ@slm.duckdns.org>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org>
 <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
 <aKds9ZMUTC8VztEt@slm.duckdns.org>
 <f1ff9656-6633-4a32-ab32-9ee60400b9b0@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1ff9656-6633-4a32-ab32-9ee60400b9b0@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79D6540005
X-Stat-Signature: rrr5h7ar37puz5opwx1r4b6ftnr93tth
X-Rspam-User: 
X-HE-Tag: 1755885395-393270
X-HE-Meta: U2FsdGVkX1+UFkJPXVK/VciDvNZNP0Sfq7mscHIjBtC7k2UlfUsjqn93cCwHbMbHevOx+HG4aPHoJL23Tc0Swb53YFiysbPBd0TsRiYTQ0g9LUsQ7Lc4vNtCi3mFsNSbuE9wuEbgaEv5HfI11sPacG02EoS8+8HZrVJmeFV2fk4mGGKLE97syRPpebpz6mNfLnBazGRwV7DlDgoPQVwqhYLAwAdkaPJwCjybnyaB6is8Y29T6n5f0gH7cEQEDhWsUEBF3nyu0V2Y77DfLepGHlD7yC66k8QYH8ILQJLrHgprOzde568rd7x1UICjk0uRvtYw8MGYsQ80q7IgQLmLFRPLMInJ5ufc41IZrQU/e1vXnHknZI5IQmOptgm/RVVWLS2m9BOfhvvH8xMPFX6b+XbspMyEXdXiK1D1IE/aXT3g0XZy0U15vCUUwRR6dbKYp654l5vn7MKcLYQyKTXPEpNIz4br+bHcom0lnmetgbyOOqfSEph99PSXs1voiXVL2Boi2OWKaaKpm7R5ns5ALHY1hcBSQ6+mWY62d/E8iTh4v8tbR1Ab74q8Ng+YQRAWSz+UX/FeBU4tptqo4Fea5+qw9ktssVyirBNo6jJPP971v3TITsACkuo5HWtj5fpSEKaUPnkizTlrWlAH4NF5JD4KY3AbuVqFE7JsyKFaB1Y7KKJbribujGVI6Xpd5urM9Wdm9bpcPWgU4LWjeFjt8lw921NpoJ84If8eLBWuq7KJDGelvydYv2+eHO0BE0reV/4VGHal36hb1uLNvDp9cLx3xoub9MGrCHcjcZkchBu3J2P4xFpcg4mOCHSTGM5XG0JJIkSvtxt2xdGmsUYjxAMp2w4VSasxOuLXIsAgoidBxai+LSI2FXCATcXIUot7xZE/oN2yXHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun wrote:
> +struct wb_wait_queue_head {
> +	wait_queue_head_t waitq;
> +	wb_wait_wakeup_func_t wb_wakeup_func;
> +};

wait_queue_head_t itself already allows overriding the wakeup function.
Please look for init_wait_func() usages in the tree. Hopefully, that should
contain the changes within memcg.

Thanks.

-- 
tejun

