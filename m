Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED17C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB356B0099; Tue, 14 Jul 2026 09:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB886B009D; Tue, 14 Jul 2026 09:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775286B009F; Tue, 14 Jul 2026 09:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446F36B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:49:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6F721C0281
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:49:52 +0000 (UTC)
X-FDA: 84987515424.14.31E3D3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 187DCC0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:49:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y4PbeOtQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784036991;
	b=T3IEfAPhrv77NdFpRVYob3H9vSA9P2PUQgVhrcadHZRL0w41dTko+aYJluPB/PmZb57L61
	u5rdBQHVgFPMKwv9tHv3XQHkHhBlmmvxj035Wh6os4gvGedUuL2OX5rsfds3dqxygzepPe
	RbMat78FxnfcXRw6psRW8XNEd67j6SA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y4PbeOtQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784036991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZcTORujompaplDyQL8DLK9FixDtbpWYdR9xZHiIUSs=;
	b=2/d29TvDyCaITb9kQE7q6c94R3XxzMAL/lM59fGRAHBOCLttXFwetHdtB3R+7vKmG0XJSJ
	eeVKiy2bxdOSp/OE6ZB0o3ELrY4xT7DPxqRKD9C5rYO0n8soWnvw/dUGBF0m2TzuFauRJ2
	YL2k/mAwDeuboeVx1hYdNTYXndFb9jE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D93C6111A;
	Tue, 14 Jul 2026 13:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280611F00A3A;
	Tue, 14 Jul 2026 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784036990;
	bh=zZcTORujompaplDyQL8DLK9FixDtbpWYdR9xZHiIUSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y4PbeOtQ6T9kcGn2WNX5NU3bYbWGjubtLAryhI1a97mUtMRvBKrXcP+ufE3gthBw0
	 lWfUpJBuv47ULm+5pWLXbcLFizQ9KTB/5zI7fsCuGkETxxwicrJROsb2bqdigGfznj
	 3O1935P5U13fAv9EvVtOICVgFSHngx1NtSvNVAncjcBCHDKAoa9ysu4SM7Q+61gIgu
	 wlNlAakVTF/LTAdL3/2osSMG86sPuVSRlyi2HI5uR8/JZIrigilsxPHBc6MBN36bnX
	 p3kwmLsaOyayaGCNXyaHol0Da2PDJCbdpDmSPBLDhMEhCyI13uVHWAkcOoKtlFXUJb
	 Y1jTXCFfFtX4w==
Message-ID: <2911979b-193c-4cbc-85ed-f1d04a9977f0@kernel.org>
Date: Tue, 14 Jul 2026 15:49:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] mm/page_owner: add MR_NEVER to enum migrate_reason
 and use it for last_migrate_reason
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, Ye Liu <ye.liu@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
 Kieran Bingham <kbingham@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-3-ye.liu@linux.dev>
 <9e0db1c2-06ca-4dba-8fb1-552fab91cb02@kernel.org>
 <037d58c6-de55-4b69-bb71-905e03985657@kernel.org>
 <9e9345c8-30a4-4f78-ba55-d7fa073b82d5@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <9e9345c8-30a4-4f78-ba55-d7fa073b82d5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 187DCC0004
X-Rspam-User: 
X-Stat-Signature: 3ar7s4hx545n4twih9mtbix8zctrb1hs
X-Rspamd-Server: rspam03
X-HE-Tag: 1784036990-427355
X-HE-Meta: U2FsdGVkX19DhPVqTFmqHhWGCIWxjAtTJ5i7Thlhfc0cEtHH45BhFM5jE2qHMpTaTLq++j0fuffbujjHnV4BeVYNZc+dY18JaqB/+6g38zDwkfTChAJcn6FAKKq9TdAsxU0IPf0ATQa818BuCqjcy8SOYl+6IsKRgjW2XVTsBGVLmr5XEBgsP3EAnnk7vcFxEzPfYEGnnZs8HggvaKJHecbaYemL3QNO4ij0E3MNyW3dpCuXlmT4Fdeo5tSiz6sUrqtjMDctWJDViAGDa60WJyRrNm01BF6L53bUqre5vX7dGTNSAKqMvB21H60JTsDG4mpU1skKMonXAx5mcZUN8vnGoY0eakeTdczJJI3Arbr4A8YwJgq2ivMEQo/NcanwzSXA3m91ei7EhcP6uTyiSJsT/m+sdOhMI/SGsA2zmIdXomlvebrOYCR4v/sdvfcH+pj1eFCemw6S3FPb706iZiNMqDhTmx45HZMrPYrTLKGyLf1BO0Sxh1fw1v67DLZml3CQS28wM29JwKQ30yejdnjL94sIWXeFC98AgCdWzL26/q7IbIpvmC8TZKMs1a9TccltticzSeZK2B1vamZKxj0wcNfEGZqcs57UlxztyJjSfixKiIZcGrij/vbULc8EVOsC8x4D9+vQG0qzC8UJSjQ4EXYNCXVlCweVgD/mB5SCrXm/RHRCimqTNZYJl9m32IFP+UDuJcZVDAPR9Bn84UECsxd9zn3oottY/oyBTwgEK45wleRf9IRmpGixfjtXF/eLwtVLP3iflM9749qI16cfB7TE6hUIhnplD72q0xAUQLoCq4+LPr/WL9kLNx6vRqc6r0ZIvh9hx1FZQ63oJH2gqAqWCB8lY/tRC+JlI/R6ElgKGh1vXM8SXD2AkooyHKgiW/GagNkeEhqiX471YiqCVC/UDQJCGYS4xwKahQdTjuIqV5VGQFqMdPPPb0nteav1AkaBwv3FLfm568H
 A7P9hZ+7
 xpeDwF5VEU1pYBG33oe4k4H5gVLW+Jrb9pLk+q9rEIESmMcURFwjzYRfSDyBc/sbBDadyioQXmBakNaQ+bs8z4Sz4jwYF7C2yQ5EezfVcpOg2v1jGmPKke6bMwhpODf13JmWql9eRO4bB4swa79afxaVvO8AwJZM+wd2d95zLl+fjowbnc0Gx9oTJhYvMSEmtVEERgCrSuFtXozlMH8nOBPEFG4ZFObTocexd5WjIvIR+ugvYg/4BZqEavH9nTbyJepgb5JpaOn7h5zHUFBLlX7H33MNfJ7nMiMmWQ2aVtj2gMgHz1kfNGug2jJ36eeN+HdAcIQAnWfb3l8pF2bgmL0sdedKt4fnRhx0BrwUxy0+6OrhCb0yfjWD0v7COv9ZQ0D5x1gvfbhKHlgXpXtQ3uk4bo/yDXrD2+Sao+732omZoIX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 15:22, David Hildenbrand (Arm) wrote:
> On 7/14/26 15:09, Vlastimil Babka (SUSE) wrote:
>> On 7/14/26 15:05, David Hildenbrand (Arm) wrote:
>>> On 7/14/26 03:51, Ye Liu wrote:
>>>> The last_migrate_reason field uses -1 as a sentinel value to mean "no
>>>> migration has happened".  Replace the four bare -1 occurrences by
>>>> adding a proper MR_NEVER member to enum migrate_reason, defining a
>>>> corresponding "never_migrated" string in the MIGRATE_REASON trace
>>>> macro, and updating the GDB page_owner script to use MR_NEVER instead
>>>> of the hardcoded -1 so that lx-dump-page-owner does not incorrectly
>>>> report unmigrated pages as migrated.
>>>>
>>>> No functional change.
>>>>
>>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>> ---
>>>>  include/linux/migrate_mode.h    | 1 +
>>>>  include/trace/events/migrate.h  | 3 ++-
>>>>  mm/page_owner.c                 | 8 ++++----
>>>>  scripts/gdb/linux/page_owner.py | 4 +++-
>>>>  4 files changed, 10 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
>>>> index 265c4328b36a..05102d4d2490 100644
>>>> --- a/include/linux/migrate_mode.h
>>>> +++ b/include/linux/migrate_mode.h
>>>> @@ -25,6 +25,7 @@ enum migrate_reason {
>>>>  	MR_LONGTERM_PIN,
>>>>  	MR_DEMOTION,
>>>>  	MR_DAMON,
>>>> +	MR_NEVER,		/* page has never been migrated */
>>>
>>> Shouldn't this be more like
>>>
>>> "MR_NONE" ?
>>>
>>> As "never" is not really a "reason" ?
>> 
>> It's not used ever as a reason that would be actually passed to migration.
> 
> Right, it's a placeholder for "there is no migrate reason because it is unset"
> 
>> So I think the name is more descriptive this way.
> 
> Not sure I agree. The usual translation of -1 -> unset is NONE or UNSET.

(note it's no longer -1 after the patch.)

> At least I was confused by "NEVER".

I won't bikeshed this, so whatever.

Just to avoid another extra respin, please also say how the following line
should change, as if we only rename MR_NEVER to MR_NONE, it will be:

+	EMe(MR_NONE,		"never_migrated")

Is that ok? Note it should never be actually printed anywhere per the
current code.

