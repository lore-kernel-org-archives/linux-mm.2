Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A151C44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BD66B008C; Wed, 15 Jul 2026 22:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232F26B0092; Wed, 15 Jul 2026 22:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14BBD6B0093; Wed, 15 Jul 2026 22:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE6F66B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:29:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64CE2C0354
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:29:21 +0000 (UTC)
X-FDA: 84993058122.17.21BB1FB
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 55CB8160003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:29:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rdhgnoOF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784168959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahnMBpv0EUvokoPv1D+yV8tvyG49SF0lRDVbaeWeWVs=;
	b=0JQZB98BX3wxDl/6E+3K8FoMvOQ4zeHfymQ2SipyHIwSTgpbcGZTK/6O6xA2KsEtZRNeQG
	3BZ78OgesYzS8RrikZhyPWob1vEQ3bmk3ZSDufx6GtEwPhqfmzN66AYXmHr4h204C8bXna
	D1HPAAu3Lp5umcJ+ERG7zj0yR40mW00=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rdhgnoOF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784168959;
	b=Kv03825M6vb6TcPybHZ3KCmX0PmXl6d8rHptNfGCbq5fiieQJF21vdAnAfXqPBrJ5LbaeB
	0BfeVCqo0i3U/q4XPs7SaKcS+uCWMKHV9VcZIN+yb5yh9/IOnLG7lEekZ3apmDzvRIiE1X
	7Mk5P71IHv7/UI7rbgAp3Q1DK+DK2rQ=
Message-ID: <c01c77ed-9ce2-43e6-8ab8-dc2a8fb43b4b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784168956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ahnMBpv0EUvokoPv1D+yV8tvyG49SF0lRDVbaeWeWVs=;
	b=rdhgnoOFQ2JyOJedrMszmsV7Mi67qyVefKSeNc3lWKTFc7BzvHcnYtOXXripbmfmKojmrs
	GJUtvcy7tx5/ao03jBE38WEBH9y2TKUAOfObVKwOJjxDI1yrdAf1acx6LQ3rkQcGARhDmI
	N6wEFt9JzW3qSVST6xCRXxHEvI+EdsU=
Date: Thu, 16 Jul 2026 10:29:02 +0800
MIME-Version: 1.0
Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
To: "T.J. Mercier" <tjmercier@google.com>,
 Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, yuanchu@google.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, weixugc@google.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 willy@infradead.org, denghaojie@honor.com, baoquan.he@linux.dev,
 kaleshsingh@google.com, tao.wangtao@honor.com, zhangji1@honor.com,
 wangzhen5@honor.com
References: <20260714121529.2237261-1-wangzicheng@honor.com>
 <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 55CB8160003
X-Stat-Signature: wjsihirf57rbc5gnrqy8af7qkkhaeiwj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784168959-682505
X-HE-Meta: U2FsdGVkX1/q5JpIR/CiDzDryE69RMs/3mvaV6770+zHPwHkGV0BzUDkS4Df0rPlPP0CyY/gx0KifUqZH+oU67PGIlgILEVU+krFZRDLM3dgY5n3tmA7B34c0ob+KVuVtND09NwdXovaGWRfGlElN12NqNj4xUqkmpl57T7EkdWdxXSqrusJDsYcbPE8E8iT2yAwab7oX5rPXj2YM9PCRukr74rvXiVp4zsMMaUokpBOtrb4cwlRNvMd0gWjf9WWyETN3z+WXBE0yALawp5hg9fJ2iYECqw0j5DOrGnbiuvOIaASv3tmMM/gXDAEwKlTYaTJVUH/+L1gOF8FsMSrvd40vyRqXru6QZ8+Cey5T+Zx2+t0kmQ0GNJp3fThNhemOGGeBQB6JnseeJRbBh+k6Qlfst0VGFs7w7BZQ+v1Qv9UhR5UIo9/WnQorp1qpGiQM7ke2JNVEcdvYyG0LOvJKkbkiZ9tWsFXbJKipVPYA/8u1mKUD4aQA3QzoTVqQqgdSPb81tzrvifb1VxjOAcVzuhz8u4NUj3w1PaSUj7SAmfD5O1Da/v69aYPtklVc1WClANbMDAvd7mjApjulAbgbWZqWU06BT2+AkI900dJMXfIFCncvYxbdhtDnxfJTb2aNJrzfDFwhXQcdLtNrBg38C65em/rTYEWu2vad8kMQ7/9Sbk+2CTeZmtK73hU0A5KLNk52pt5+aqL0vG3Ng71Pof/XjrwUuk29DOmIK38esmr283tPUADN6TUcicLYc2OwiaklzPTzPVmE7zQyJIxi9l7DUEG//PvUxGurvDBpnh3Yapcxqq2gcbsSB/5KAKGEEtzbpPLIGT2e4G3VhmM08RbqB15pUY+G3+mDshZ+AKUFFzVxd6pnex++dWHJDZAt5S9ZCJqu65bH6dI2LZDtec1gHbwFrzXl+1wTwmUK6ghYqzkMXgM7oXT2R5N0TIo6pm2j5hCIOkOdRk3og/
 m8BMaAHN
 /mpmHk7Mou/tQyPxG0BKWCBodkNeVP7SkaOFfooem7hXIDkpoH7W6NtDYLF+8NqfLXiLyLsLCCFOIcbSwiCxdkj8QNaiux3gSL0qd8TiDbQaZ9Mjw3lwqR5mWsN2yzW7bsyWnOVx7TVkW+qheYz6q/oU0eUC+C/5Bwr+l7xrN1QiSBKMD1abcxNnvQggRb4onaLFHyAb7MIhttR9P1QHXkjEDa0jhbchUuvamUtuFcMFrSAdyTuMtwKiNMaWWjnzbhxqOxgEOrdag/oBZ3aUS25eWFFBTh/b420cRNFLE1L1qIk6wJwsLcVe822yiJJ/jQDEo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/2026 1:55 AM, T.J. Mercier wrote:
> On Tue, Jul 14, 2026 at 5:15 AM Zicheng Wang <wangzicheng@honor.com> wrote:
>> The benefit is workload-dependent: file-cache-bound servers gain from
>> aging, anon-bound servers do not, so no kernel default is correct for
>> all.  The kernel also cannot know when to age: on Android the right
>> moment is the foreground-to-background transition, when the app's pages
>> are cold but their PTE accessed bits are still accurate from foreground
>> execution, a framework concept.
> 
> When an app transitions and becomes cached, we attempt to reclaim its
> entire workingset. We basically cat memory.current > memory.reclaim
> and freeze the cgroup.
> https://cs.android.com/android/platform/superproject/+/android-latest-release:system/core/libprocessgroup/task_profiles.cpp;drc=65bd7ab941a709bf049871406981022b988e1721;l=706
> 
> File / anon balance vs hotness and generational placement doesn't
> matter in that scenario because we want to get rid of all of it. So I
> don't really understand how you'd want to use an aging knob.
> 

When the app becomes the foreground app again, reclaiming all of its 
background memcg memory may increase refault data, which may in turn 
slow down warm-launch performance.

-- 
Best regards
Ridong


