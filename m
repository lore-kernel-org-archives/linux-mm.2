Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3578B606A331
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bvif/XBB
Received: by kanga.kvack.org (Postfix)
	id 2BD556B05B0; Sat,  7 Nov 2026 14:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2947D6B05B1; Sat,  7 Nov 2026 14:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184A46B05B5; Sat,  7 Nov 2026 14:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB5406B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:51:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CA0F80223
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:51:25 +0000 (UTC)
X-FDA: 85409367330.21.582D0D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B33AAA0002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:51:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bvif/XBB";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794081083;
	b=IgPJWR+BB8lBTfpvFrJpmC/FhEhFN8MxSgCoX0Ikz5UZYP2KPk4li/luJq33BprXNGwA1m
	3Zf7XlGiQB5DR/NJ9wAzJNtv0lHVPuS49k41HxsSp6rlEJ426yh9Zu8Bf+fHThbXfj+DI1
	VJCWTd6cw1WavYJMqYiokT9S0vbPKlY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bvif/XBB";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794081083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NEcCG6Aq43ZRSmDhnrvufn3WG29LNvsLw98ja7BDX4=;
	b=5wjO6SKohCLa+kTfx22CYwVSnhRuTHPrsRu5GY9JtF707P5/rMrN8dCAhks6ThFOnhztGY
	sBcSIoZG3au3r2UQBIvTVC9MR/oe1S2NY7eQnhjlqzxkgSpnINRW05iswB6Stbb6bQpv4f
	+ArIyKB7IpSvBdbLC5hdksoclfqVikk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4908F61157;
	Sat,  7 Nov 2026 19:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0097F1F0089F;
	Sat,  7 Nov 2026 19:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794081083;
	bh=8NEcCG6Aq43ZRSmDhnrvufn3WG29LNvsLw98ja7BDX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Bvif/XBBoRKuYGbZ5ITkJSA5/rWfw2LbmlRX3olbvq6SZcfgljnv/7KDgflI2wi3m
	 cuzA4GAU6SwVrcpUVv2P/vlyi6VovbWWLCXxKix+7fT7BP2+VgSdWEdGDRpstxEyE+
	 Nerm2JJ7W46xycA3Rrw60HAi2meM9nxTmPj2FsgofK7ZHkPLcnM6rGUaSgBupNjn6p
	 mVKYgWNT1RycwSVFbjcWczDXnVHM/wLtsSpZQ7dBOPnJbXbtgzxbiFcuddxHpL/stD
	 tzK/gy7i3TJ/gQEPlZsiTtBZHqyaWS3yLWVgj590zCvAnv1kC4IqB4jYAHgBVpoZXQ
	 sGjwFX5D8lxww==
Message-ID: <7df793d7-55dd-40db-8455-1f22bb44193c@kernel.org>
Date: Sat, 7 Nov 2026 20:51:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/ksm: align smart scan skips with the scan
 number
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
 <20261107-bug-mm-ksm-smart-scan-align-skips-v3-1-16d5ce8b5fd6@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-1-16d5ce8b5fd6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y1fdg73xxygo7z893pynk1ataifkeqo9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B33AAA0002
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794081083-285176
X-HE-Meta: U2FsdGVkX19HL6KDczYwR601WZ2Tk2QoPkitrZn6rt3k//azm32BO/0LQfaTwFOrJG01vLtcImMyYsKXPvTmcO3i8Q757PzgPGxtpVkGR28DTPqfLojedCOKrMAfpk5Xd81FxQ0czagqks+SIB301Vg50o6wzWx5vgidwbsZtO3g9WwKdhktFzPouK37+hGCzSAgJqRzfg641joPyxAWDcxS2KTlssIY3H2AQDrCKDoG0MqaI77Ll98Hnh9qSm2EWIlAoKW7A7fmZJ36zBSk6nVb+j1UjowCesPEsaLQNjoIES0LhWv25TCxGMcaJXiFSBG9yMYsOGfeaFUp/hF2A6+dZjhWzE76nfjNMmiwkLLTOr0mpQeXlCrZKMrI4HzZCGCcZetbwXU9pdqcL5mbrQTKtifoWO3tgkGcFP4cJhIh+3GRI+qqReUi1kQb2waCd1NHqnAD/zvFd1XKGZYJ6ch591VHp8bgV5oyR1P8R2E4b6fyV9iRBWyR7pCdxKZTKV41eok0dWMisNWoSxpjLFduu4Jcl8nWO2sIL1k6Ry/saDUIP754yIiA6BUOj7stZ54GhN/hxmgk+UDD/HIVHRbttWfBFacf6Xta5en+UV5Bu2nSsAOpElNYkcJ6k1yqi+vDv5bLXX0ubvU/QWs/w7KRtYvZcscdY3asifHgIRMSgEYmfq/SxEQD+adpp+8ByRYqBPas4zUJBo39cn6bNf2TNAnxfsnepkag2koF0vOQwxUk4leYdpGKqgEXTV0CiR+/ClLNn21Zb0dwtAz/SrwLx6XgPWzdkdHj1oNMOGNslRbpGkjDNxvoZU3WA+uE9Ayl7FMuVSzr2+EItDAe1nmJsahuOhEpsCZersgKZFa5JIbF8MU2eQHqY86rYOjSecHmXlQP7BpulAEBCbbXXG9bj/zlk1AO5asV7cneNylHeWU589RjZ3iLg0v5Sfy1bywqlVczUHsEkeKGXFa
 TMKF+EGL
 Hdk9kB+lmRd5wdOHlALoWocCS9dHqccTqgacWIRoqX0QuA8tev6yrruHI3tVeVqy1jUhuiuBX2Xa2gQcFLdbuysqoHYyy9EIlnRwj916MqRZCw7M8uin80YgUqDFW959qJ02nUq5Lm4JRWxOhy1VpmMrxtTYii+NDEU7JnIPpvc6Z3LC8YUefqUQWTD8OS6pDG9WENEm0EvpeJQZS8V4B+mToG8VdlsbC+r8i+e3ZpjlLqpFny9Zt5q7VS6hNRNU/xjfaLhMOpLAWpVzEsk/cou8FCtCI3tPUNzMgxvt11B3vMIEGt/17lyIu68bkYsJUCV6kt14kZMpmxPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 17:57, Qiliang Yuan wrote:
> Smart scan skips pages that KSM has failed to de-duplicate for a while.
> Once a page is three scans old, its rmap_item counts down its own number
> of scans to skip, 1, 2, 4 and then 8 as it ages, so an old page is looked
> at every ninth scan.
> 
> The unstable tree is rebuilt on every scan, so two identical pages that
> are not in the stable tree yet can only be merged in a scan that looks
> at both. Each countdown runs from when its own page became mergeable, so
> two pages that became mergeable at different times end up on different
> phases and, once both are old, may never be looked at in the same scan
> again. They then stay unmerged for as long as they live. The pairs below
> are counted by making a page mergeable, waiting for 0 to 20 full scans
> before doing the same with an identical page, 20 times for each wait,
> and checking the pair after another 64 full scans, on two boots per
> kernel.
> 
> Pick the skipped scans by the global scan number instead, with periods
> of 2, 4 and 8 scans. The periods being powers of two, every old page is
> looked at on each scan that is a multiple of 8, whatever its age, so any
> two pages meet at least every eighth scan. The longest period goes from
> nine scans to eight, so ksmd looks at more of the pages that never
> merge. The rest of the table is measured on 64M of such pages, median of
> five runs of 256 scans on each of three boots per kernel, CPU time from
> schedstat:
> 
>                               before     after      after/before
>   pairs merged (of 420)       361        420        116%
>                               334        420        126%
>   pages looked at per scan    1792       2048       114%
>

Oh, I was wondering whether this should actually go to stable? Do you think the
above is rather an extreme case, and most users won't really run into it that
severely?

-- 
Cheers,

David

