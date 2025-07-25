Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66ADC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 06:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626146B007B; Fri, 25 Jul 2025 02:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D63C6B0089; Fri, 25 Jul 2025 02:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC186B008C; Fri, 25 Jul 2025 02:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3929C6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:39:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2BE980617
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:39:11 +0000 (UTC)
X-FDA: 83701834902.25.5276FE7
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf09.hostedemail.com (Postfix) with ESMTP id E160B140007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:39:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=azZIm4M5;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753425550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNk6OPC1lu+j4/4Da2MNU71TbjdMfdCtRWdTsm81wLI=;
	b=GUBEqFtpq1HuqrL/AISxEmpXq4dEv/SIYgLrctqj9h6gMqr5UMP5uyYsWD4BhZR4pZL1en
	05bZZtdMu8UVp1I09Mv/KDerfSAho+u+g+X0g891xhicho5odm5jqMhNllFpbZYq5hja4b
	/WKnpWLWURpKyS+1V2uzmfmIpN++/ls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753425550; a=rsa-sha256;
	cv=none;
	b=RIbulcke7rDTfioQiSg79yFAwgIzAnZZObECuMsix0i43bOkM9MalPy2rwdo58NYujF+3f
	SruYZei3eZ7tbJGncdyIcozAuAbeYlivbXDDlsUszDa2b/23I+ZzIsHBkDcKQkgvWAcxXc
	6ic89W64rEAC6qEfDk92CPvaGQBFye0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=azZIm4M5;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753425544; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=wNk6OPC1lu+j4/4Da2MNU71TbjdMfdCtRWdTsm81wLI=;
	b=azZIm4M5d9SY/RSxRzqBgwR8gT5QZAbvwVUw07yjPdUOsXpuu+MIgBKoiMRpjtEANVBfvpJoNeykV11d/uDOMShlZHMCxMV54tWPBLabYjTcL7eFpV/mLRI68RNEfl/vkV5xWB6cM3MEI4VuQlrZ6X+Ff3otkEaEb4dHEgg219o=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WjwBKdi_1753425542 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 25 Jul 2025 14:39:03 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  lkp@intel.com,
  akpm@linux-foundation.org,  y-goto@fujitsu.com,  mingo@redhat.com,
  peterz@infradead.org,  juri.lelli@redhat.com,
  vincent.guittot@linaro.org,  dietmar.eggemann@arm.com,
  rostedt@goodmis.org,  mgorman@suse.de,  vschneid@redhat.com,  Li Zhijian
 <lizhijian@fujitsu.com>,  Ben Segall <bsegall@google.com>
Subject: Re: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE
 counting
In-Reply-To: <982da1b2-0024-4c01-b586-02c0b8a41e95@fujitsu.com> (Shiyang
	Ruan's message of "Fri, 25 Jul 2025 10:20:44 +0800")
References: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
	<87cy9r38ny.fsf@DESKTOP-5N7EMDA>
	<85d83be2-02f8-4ef6-91c7-ff920e47d834@fujitsu.com>
	<87wm7y3ur3.fsf@DESKTOP-5N7EMDA>
	<982da1b2-0024-4c01-b586-02c0b8a41e95@fujitsu.com>
Date: Fri, 25 Jul 2025 14:39:00 +0800
Message-ID: <87v7ng3hbv.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E160B140007
X-Stat-Signature: zyosef9injm7unxtj8rhyb83764fdqsd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753425547-837752
X-HE-Meta: U2FsdGVkX19tEAZ4HiQFQGcBA4RArlw0mb7wlOq+P+IpVugJXKIEckPaqVsFdyyl7CI8u7MsRFRyXiYAt1LqK8by2+cFbdNfNix6JK7AaaqxpWjfb5qpA8B8CA6JyWP3lv7E5gwnUszE7Gt14yywe05AP9o9/UgqGY0oa4iWsdY2itzrgVKhAS7+tpeu/H6MSGNDzXxsTn6te73MIgf4zYzPfPPFgL7pn9FcB6M/Qds5qytTOeZvcz0e6wIDpSmK8NruoKAtyUHYVmDeE7GHVoIgeZmpKx0SRADyDfk81jSlGMdSCribLLympsZLbgEVtQXYzwlCkr7314sAEO2nmJDnFsn9TZVNwIzfFoPwG5rEq+N73xVIip1vTspJpWWthDxFzajvf/4S+s7RdvpuyhbFhPXX9AoGeyWlp1oG9yFvqmFvBVdPcHXGpSOTU4nd8WKAoMK4xpUR/JPLyiXXTxQHcUYzwWkXd6Yptx2ThFs6Ibj9WV7xYi9U6h26jU7zX5/knqIEnvb25Djq+n/FoQ4wJ8LAZtQuxe0eitNWmq4K/dT7U+2KWKl8nc9Lbi/Z/R8b59pIHOZfm2WHUVajrAJ5V6zAw4xCOFm0aLbGvSXUF1H9MtJ41YvrUZPW2ZPq8DMB59+R0WX48OmhnaERU5jS9P3KX2qldTzalXyG4o9GVol8lBADCnheJLLoVhapgrl6HRnDYUIJzd09LCzlhh8ZwbkhcSKHJBqQtsgXF3jqkFhEbCzUk8xCnMWma/dWf1Rat6l3EzE2r6fI/FS4CYWSCm6LYmd+mFlrwTBa32Ha8jXlWdjNPzccwl7qwfryCr6sWHKNgzCYyCATxl/TIQVHgg8rsWBq4l7ydKyll67kQDoJWCXGCotUUB6xtmtsX42ehzO9KVOoweZaSuicmY2IuQf+sNSg/EhYvqR/EcF9QO5dW8SOu1ve6hs5mA/JzfRmaFCJBzRI6OY7hth
 fdArGall
 /hJX9L9OVC+xgZhgjqIbr8mTKWb/h49vp9V0wPleneno9AwHx4XUjLaYVvP5n93Qf+X3spm/vhgrS9DdkmUKDHx15k2Fs6O6vbXQZX/xQ/wyzAlh6DfkEoB3V9QsDtsEK0K9Hi3sAjm1fLGW9g8S8uabtSRv3ZeZ2TWse1Y8mmFSzQGAJmLpoFBWVYKheDf0W/2TTHjSSdvxuE6z/3/iH6e+E+hSrICOcspe5onv2UB81qhaDQz8ShNBNm1sEl/uf4v4RydIBcXsnglJFe7wV5gMCb4RqeUWfAw4YnugNcAxY7QipnPvDX1xurXPlOnQCmShM/TbovjCf5syP1WS5ze+xzc8UXgGHMicuk2wDiEU/uAHcEFOtBC7tNtQZrMbjqAOyb9ZlM5xg57k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shiyang Ruan <ruansy.fnst@fujitsu.com> writes:

> =E5=9C=A8 2025/7/24 15:36, Huang, Ying =E5=86=99=E9=81=93:
>> Shiyang Ruan <ruansy.fnst@fujitsu.com> writes:
>>=20
>>> =E5=9C=A8 2025/7/23 11:09, Huang, Ying =E5=86=99=E9=81=93:
>>>> Ruan Shiyang <ruansy.fnst@fujitsu.com> writes:
>>>>
>>>>> From: Li Zhijian <lizhijian@fujitsu.com>
>>>>>
>>>>> =3D=3D=3D
>>>>> Changes since v2:
>>>>>     1. According to Huang's suggestion, add a new stat to not count t=
hese
>>>>>     pages into PGPROMOTE_CANDIDATE, to avoid changing the rate limit
>>>>>     mechanism.
>>>>> =3D=3D=3D
>>>> This isn't the popular place for changelog, please refer to other
>>>> patch
>>>> email.
>>>
>>> OK. I'll move this part down below.>
>>>>> Goto-san reported confusing pgpromote statistics where the
>>>>> pgpromote_success count significantly exceeded pgpromote_candidate.
>>>>>
>>>>> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB=
):
>>>>>    # Enable demotion only
>>>>>    echo 1 > /sys/kernel/mm/numa/demotion_enabled
>>>>>    numactl -m 0-1 memhog -r200 3500M >/dev/null &
>>>>>    pid=3D$!
>>>>>    sleep 2
>>>>>    numactl memhog -r100 2500M >/dev/null &
>>>>>    sleep 10
>>>>>    kill -9 $pid # terminate the 1st memhog
>>>>>    # Enable promotion
>>>>>    echo 2 > /proc/sys/kernel/numa_balancing
>>>>>
>>>>> After a few seconds, we observeed `pgpromote_candidate < pgpromote_su=
ccess`
>>>>> $ grep -e pgpromote /proc/vmstat
>>>>> pgpromote_success 2579
>>>>> pgpromote_candidate 0
>>>>>
>>>>> In this scenario, after terminating the first memhog, the conditions =
for
>>>>> pgdat_free_space_enough() are quickly met, and triggers promotion.
>>>>> However, these migrated pages are only counted for in PGPROMOTE_SUCCE=
SS,
>>>>> not in PGPROMOTE_CANDIDATE.
>>>>>
>>>>> To solve this confusing statistics, introduce this
>>>>> PGPROMOTE_CANDIDATE_NOLIMIT to count the missed promotion pages.  And
>>>>> also, not counting these pages into PGPROMOTE_CANDIDATE is to avoid
>>>>> changing the existing algorithm or performance of the promotion rate
>>>>> limit.
>>>>>
>>>>> Perhaps PGPROMOTE_CANDIDATE_NOLIMIT is not well named, please comment=
 if
>>>>> you have a better idea.
>>>> Yes.  Naming is hard.  I guess that the name comes from the
>>>> promotion
>>>> that isn't rate limited.  I have asked Deepseek that what is the good
>>>> abbreviation for "not rate limited".  Its answer is "NRL".  I don't kn=
ow
>>>> whether it's good.  However, "NOT_RATE_LIMITED" appears too long.
>>>
>>> "NRL" Sounds good to me.
>>>
>>> I'm thinking another one: since it's not rate limited, it could be
>>> migrated quickly/fast.  How about PGPROMOTE_CANDIDATE_FAST?
>> This sounds good to me, Thanks!
>
> Gemini 2.5 gave me a more radical name for it:
>
> /*
>  * Candidate pages for promotion based on hint fault latency. This counter
>  * is used by the feedback mechanism to control the promotion rate and
>  * adjust the hot threshold.
>  */
> PGPROMOTE_CANDIDATE,
> /*
>  * Pages promoted aggressively to a fast-tier node when it has sufficient
>  * free space. These promotions bypass the regular hotness checks and do
>  * NOT influence the promotion rate-limiter or threshold-adjustment logic.
>  * This is for statistics/monitoring purposes.
>  */
> PGPROMOTED_AGGRESSIVE,
>
> I think this one is concise and easy to understand with the
> comments. What do you think?  If this one is not appropriate, then I
> will go with "_NRL" as you suggested.

In fact, we still count candidate pages here.  Although there's enough
free space in the target node, the promotion may still fail for say
increased refcount.

---
Best Regards,
Huang, Ying

[snip]

