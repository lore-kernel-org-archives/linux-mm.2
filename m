Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F6E606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gdcVkuV+
Received: by kanga.kvack.org (Postfix)
	id CAC6F6B05B1; Mon, 23 Nov 2026 00:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45BB6B05B2; Mon, 23 Nov 2026 00:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E046B05B3; Mon, 23 Nov 2026 00:34:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84C736B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:34:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0188EA0821
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:34:20 +0000 (UTC)
X-FDA: 85465268322.11.350EB84
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D35E20008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:34:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gdcVkuV+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf03.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412059;
	b=lmpcvjw9N/vCxwr73pxgcioXjty+oax3Ghek2XRL9dLT/Sk4abq1/8akbk2L2nLWrIA61O
	CKcjNtHKU4h+H9L1yEn68Ok+jv7d3BHxOdP6X9vW9A4xH4COaYyu6NRnbKUfDZW9eK1GmU
	NINW327ejCpfMddvlxhB8RO75l38r8M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7MPjZZo0hHxOyF+FFh2sYC+ZGLhQqvq6JfBXoS+DHU=;
	b=VbLKPwYv3F76NXVKBM5ASAjVRfvcxHiKpSjEbYEtCoY75+Tk1H4CaCiMwglbBZ2lh08fYx
	DArdvTNq5IFertLQVX7R2tz5NBXz4yqKII24fEfvX8IJcgvgInIiA6wNhkEemCvuCLllSI
	lO+7NGT/YNOo2SsFdeAaDO5Rm21CJxU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gdcVkuV+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf03.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795412052; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=u7MPjZZo0hHxOyF+FFh2sYC+ZGLhQqvq6JfBXoS+DHU=;
	b=gdcVkuV+3DHH00++vLPvcfOU9/Er/5PwK3hLEpHrssvO9L22UOb12OJcJ1dWNLUK+Hg6mnI+5QVwPK3+uD+jO25nZONZl/YVNSR1abefEAnWgds12P/z9Qy4fCYqEsoOstrze5DqcyAToSqlM+Iai3cu02DSK0q1opodBMmhrvY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XFDCfRs_1795412049;
Received: from 30.178.67.187(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFDCfRs_1795412049 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 13:34:10 +0800
Message-ID: <b8b13d36-f732-4fca-bfbd-ece900d24ae2@linux.alibaba.com>
Date: Mon, 23 Nov 2026 13:34:08 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
 <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
 <565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
 <20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D35E20008
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: xcydn8y5pauk5kfy1txqtgeop6ra4zw3
X-HE-Tag: 1795412055-916837
X-HE-Meta: U2FsdGVkX1+JvVT6xTG+53lu8RVfQZ+vykxqzHEbZgxKfdvg9bGhyLXNxqbMref8wy+WkpBDldGVDobw5aUi3Nfn+FI1nRE0h9FkzA1QwSYJmbUeYd/B/OUjGPDAXsjrIx2mt+Xhg/E5dPXdHqmuS3ScqUntulGOLWv62FgHtH0HH3Vzh+430t19eMLBa0ltKjZHXZdwV7KxWVJDNa1hDhBDe9cyZVi+z0y2juV1eaIKhA0/c7lOkCLFmzR5z9GAlPrpHvHDrh13NmdG/nSabz9SsN1HFdHtfYYiW3yX9aIkJ6DL/OxNUKrlUbLMYaxmIi6QhDDqvTSHB2Qj+X/nEgYXmRbUagtY7szZ2OrW0pOCfGkIbTKkCZMpAVi3CnusY0ukXPlJ5jw6OJD5TuBpaS5NgY26lE0UiSvajbqBgpgea7maUJ1EfGNIEnf2tJqbshVxyW3j8tw+fgr4SIjJiOo+Jm57myp1zK6HNVA8ht+accZeUSbQqihBi944bfxsFUYpXN3wlM84TJlwxZAHFz5Kr7auNtr6nEgPynN5OEClckVVz0ob5K6Qfg1rzKPpqPsPHbedBjmuNDnFItokguQtXv2/kxq5eCvs57JYgrsupGjXFxX8V00cCxDDLfWroaQrduiQLeOW7iZ6/9Kf1GWr+ctLa4rNItGZigww0yj4GKYNDv7JFTJPya97bQOqt7OzGSHMARTBkhyVhj+Mv4MrAicSBAsFvrZQ5b8QB2pz24UHuj/SHOTz3Q1ifi0ENiyDj/CVT1tutbHkGZ74ssfHrKazS3uiJa65wZQjCUDBdmS9Dh2tHYQDPDEIhFKaSmlz6gEla9TQsy5Ps79JvDpJr+OzdkkUAwKonSCttdvwDayyKVvKnFh4WMiCRzEN3UrO/ZgwOd2vB4OnJ5WmGbUFeUrdBRASwjxIU9Nrdh7xaILPvrNAc4uAo/lEqdd7Kt4yCVKWQOAZB7QanS6
 KxD3pTPP
 iawHQnK2g5akabjoeEUOYFiz9+Hda8pNB3fI3fo0a7Y4IabeHpawj8X8wEWqEa+MT9FpdrrdqW9JHVF7vQA9q+pcJrYhytXSHkP1Ncyc8Uc+EZrS1HBJj2JKd6SKYMIEdOIbiMIvlA28/18ssvYOHJmKbwtMgWtEFJod/psBykLYV813Rs5+sQKw40nr55VeSsDtUof5rke5ouD3aCGyJzu3L1jJ1DHBcUR+sokEpSj8CjVBNfCA5xifz2fuY8zEI/UnjEd/cFED3ETeXwdkGidcLK7/7fi2uql+up/Rhz0WflpKKgJNqF+Jk8+tWuonW1HBotTHTM/I135r4nTTCxrHovoGZ9nD4gGPzDgNnhs/Y6WHVhnX4SEmDe4wYN2LsRZxbiaov7rizjfEm6qu4cSRJr4Qe+bfGTq1HYFkOrZ9Atwe/syImWS6T5GGNjA/gbrBW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

On 11/21/26 11:11 AM, Andrew Morton wrote:
> On Fri, 20 Nov 2026 15:04:37 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
> Yes, it sounds like ->css.id better matches the lifetime needs.  And
> the root memcg list_lru retains index=0?
> 

Yes. With this series, index 0 still selects the root memcg's per-node
list directly. Only non-root memcgs use memcg->css.id as the XArray
index.

>> The second finding is the same race that Shakeel's patch [1] addresses.
>> It predates this series: a folio can move to the root memcg between
>> the two lookups in folio_memcg_list_lru_alloc(). Shakeel's patch
>> rechecks whether allocation is needed after taking the memcg reference.
>> That also prevents the unnecessary allocation at index 0 that Sashiko
>> flagged in v4.
>>
>> Does using the CSS ID for the list_lru index sound reasonable? I'd be
>> happy to incorporate any suggestions and send a v5.
> 
> Shakeel has a couple of related fixes in mm-usable ("mm: list_lru: fix
> NULL deref when a folio moves to the root memcg" and "mm: list_lru:
> don't use a new memcg's lists for an offline memcg") so please base on
> that.

Thanks, I'll rebase the series on top of Shakeel's two fixes and send v5.

Best regards,
Qinyun Tan

