Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 920F8C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3306B009D; Thu, 20 Aug 2026 21:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374026B009F; Thu, 20 Aug 2026 21:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263EB6B00A0; Thu, 20 Aug 2026 21:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F26766B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:45:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7ADDB1C1569
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:45:20 +0000 (UTC)
X-FDA: 85123584000.20.75361F6
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7AB4920008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:45:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VgbusWlB;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787276718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2FMWT5A2o6x55cH0jMPh7uwdsrz3NBheTdCLGTG3UI=;
	b=ZKxZx6BEoPpuwUJoUf6ZH5obPjkHPgYZ5ZrcrtJdzbEZlJj4smaSouR96YlHNi3YJHyHMl
	GUUttIZZV+YPZQa5e255zrcXsAHddGzNv+NPQlQZvdUiC3qWB5G3ENh4htKJ2bdjLVhm9J
	W8mxF9fVksl02ibLTyq8mNXfL7c7iLg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787276718;
	b=ODT20avAdTXb7xcY2Utt/JGVV7TDl/EBaodUXpZLSAOQv0oNvON4VvjC5q8589zm8wjsO/
	yLkk3DG9khdwGGEj/OLPVug5BiZMu6vowU4CbKI9wa3k67hHgIxzdC8lqVvFhhOzbIDM6O
	tbdkNvH3l+KpUWJTrLs4BQE4MqGGSPs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VgbusWlB;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Gb3gKqWWZhzHZch1lV86VPNeY80SBN6K83Ep6tDE+RI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787276717; v=1; x=1787881517;
 b=VgbusWlB0oQShrZFLLvnKOXvI8GbomwedlgegqoQI96mA3dWPqFpmScapGVoSSwZn33O7BLo
 cZKbZN7YU4wGrkSw5eo+tQX7owDuhg830c1mwdbI07KG/W4+yWWkT2X2z1ncLBG6czW0nCrkdlx
 I0LBG97FMRIq5Z1wouJNywTQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 608958cb15c913ce;
	Fri, 21 Aug 2026 01:45:17 +0000
X-Mizu-Trace-ID: 608958cb15c913ce
X-Migadu-Flow: FLOW_OUT
Message-ID: <4838e4ff-e982-4347-9972-741e08dd1bd0@linux.dev>
Date: Fri, 21 Aug 2026 09:45:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/mglru: retry the same type once if isolation fails
 due to races
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com,
 linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com,
 mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com,
 yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
 <20260820045603.68809-4-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260820045603.68809-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hamhex8bix1b9mxf35yykmjcgdw5hfr1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AB4920008
X-HE-Tag: 1787276718-234768
X-HE-Meta: U2FsdGVkX1/u6Ai9ym0cwAoZNUfnBZCIZtziQfV0usLRUK05z0K7ktSgg1mOqD9sMJEx66tPZdFotNkjn73/crCqh8CHcL1O1fpDxKsJputSXyMID7RBoL+FAfjjwtGsD5YLI8sfjt/wuNCcbtse0RVWWZdEbLX/kA4BTy+jc6ny5DekfvY9MTqdppq7R2sAs0QaB4UPsEwg2JQyYQ/XX0KIctBXkW/xCeRftmW7hIrGAN2b5I1W6XSWqe2+QNPDQAIKfThL4I+Z1S1MyJ/TInjM8Pw1Y66qJ/NXZWNUqxz5SBQAnIiGl+kSwWjfPy3ajF3M9Qvr6ACBzVCZHLwe0h/CFHwb4uZvqzPBdCfmiJcJWqd3sF6UFQ/hmpZ5oYjkQQ8L9sUNR5t/KN//oQcKdjw8uTbhEbRsBG9P6gkGIPfVI0rdmFKXI85JqkW6L8JuySCAfcU21vq7QudGlmAdnNdhEVBirS5ZIV5LawizeC6IInkgrSGTdlpDyQRE2bHK87T8Kd5hIFoeee9XPW8i+oTYrHMJjM6FnW3RW8ehw94ZSG6q9QmXUVBSQRmlshl4FJmOsFcBoOff7hiilvtawGVzJUPRnBubXJeAqw1ZaAgos54c4ASzzUCgB2/F8Fd6jJRQYG9oUwoTd61hr/uMp3PdCc9axE6sg7UU4eTHgS38wfhIKDfQcl9PAWBEasR3+gNL2r+svgf7Bf767cWElaXgbtk7Fd0jy2HozM34wW8wB0vnD+0rFBVQBeRcUlAVqnuM8S1juzx521XjS0BEER8HwsjiLUkEmCZs8BzG5a1ai89VZpXk4W9ua9OEE0ccKce9ZKyB16b3V/aupk6MNcl3KK37ceO/alUc+ix+ruV+hJhUBCnRx7O+5ciO4JtIiaXsoZaYfekFFCidizR+TDrRCDjsPrjFotohCwdFzvcLivrKL0K4pVRs7wkPkBK0lt4dZViZZAKvmQyCyNG
 9hX0BoaU
 oQF4yu6pqrkeG0D4gmFcC+Jvx+5piux6XgiqDRs69MJGGDd/q2p86GpDtSAIApRL7LAyAiqqLws6eUFP3QbZQ9yms/v4XXxPKVDgGad2ysA/6M8JxuWuLyRJPPu2o2ylB0nxYL1Tlxm6KJwc0w3/d5cHVKwomSfhsBd7gI6Y3l2azObCEp8ypCG9tHgWx6FPqT6Wdey4JRpBcOWUjpfVcTaQeLEButx24jRLW6PuXTt5Gx3i1SuqjWAZgkto/T72tXFYbXaQ2jHy3ugM1NC46DMxTMopG9h8CvUbSIBg2iRo2mayFZ6+OCLW11aYulYgYQEHdBpAx2AgDA4aWfmQMaB/Y/V4PASwFmzQD5nJc/jSPQZWQkPydrVbexQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/2026 12:56 PM, Barry Song (Xiaomi) wrote:
> If we are not exhausted (i.e., there are still folios in the
> reclaimable generations) but fail to isolate any folios due to
> promotions, protections, or races, retry once more to avoid going
> through the outer loop again.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1f2e574b0061..1f302386d8ab 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4862,7 +4862,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
>   	int type = get_type_to_scan(lruvec, swappiness);
>   	int total_scanned = 0, scanned, tier;
> -	bool exhausted;
> +	bool exhausted, tried = false;
>   
>   retry:
>   	tier = get_tier_idx(lruvec, type);
> @@ -4885,6 +4885,14 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		type_fallback_allowed = false;
>   		goto retry;
>   	}
> +	/*
> +	 * We are not exhausted, but failed to isolate any folios due to
> +	 * promotions, protections, or races. Retry once to avoid a larger loop.
> +	 */
> +	if (!exhausted && !tried) {
> +		tried = true;
> +		goto retry;
> +	}
>   
>   	return total_scanned;
>   }

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong


