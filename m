Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8715BD4A616
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30896B0088; Fri, 16 Jan 2026 04:19:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE4F6B0089; Fri, 16 Jan 2026 04:19:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0BE6B008A; Fri, 16 Jan 2026 04:19:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFEB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:19:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 333035979C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:19:17 +0000 (UTC)
X-FDA: 84337278354.28.651C652
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf01.hostedemail.com (Postfix) with ESMTP id 98B094000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:19:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tjdo9qjv;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768555155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXuUSWKmDb91gc+pCaKfgPo7v9igVSa8mgzQJr7mqZ0=;
	b=HoWngWTty9XgGZhG2xIlcvwZX1l/xKhfTzEANNmFt3WRN1byzpVCxXNEkvWWl62Zvl3x5r
	LIMxmBc6kRDM92H0JbsCp1rt1lIPGQ5Naniwaed8KHz9bqPzzowaMYYRn58OczdZfLgdtB
	tNAlNBVsC+z3cleBTFkWdB6KmujDMis=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tjdo9qjv;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768555155; a=rsa-sha256;
	cv=none;
	b=ONKTfM/zvfJJp9XsHVT0HDXELGzC5anuHVsWQ3b2QCPiNOIYThmpnNIf6mnpDALXnW5Mq8
	+N+F8V/d60ghC5ZuqYJ4hlpxHuwM4BLT6GINTq0oUCXI1m6szXOHa+s6Ep5+Z2kzQSPduO
	9P5mf5kV0bu+1uAcJL2Cktsf4w+CdK0=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768555153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bXuUSWKmDb91gc+pCaKfgPo7v9igVSa8mgzQJr7mqZ0=;
	b=Tjdo9qjv4nbnRggvBlfTo4iCjKhhyopfmT6r+E9ka6pIQLEFxcX+5m+rQOgPZ3AW+K7Zyt
	dyBNG2c+9l1V7U2sbthxgjh/qwT5EzyvLD7xzJCoPSGpdWEGN5VVVJqjCa2lM8GOoIGn71
	YyJHqRRHnKsz68I0TKilPJf08I/jcQw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v3 18/30] mm: zswap: prevent memory cgroup release in
 zswap_compress()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <592f65bbe05587c01a2718443a70e639cc611f3d.1768389889.git.zhengqi.arch@bytedance.com>
Date: Fri, 16 Jan 2026 17:18:16 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <0924D73A-5DE4-464D-B606-B0187C72EB96@linux.dev>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <592f65bbe05587c01a2718443a70e639cc611f3d.1768389889.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98B094000D
X-Stat-Signature: zq8hdzfxqjtdbdszzuc1pcqsnbnpff6p
X-HE-Tag: 1768555155-600850
X-HE-Meta: U2FsdGVkX1+LN/4cyBEzxidgRoGlCmQsWSF9hmHSDAe8yiESLTJb1KdyycXhmS8wKXg21Ku7l4ta8OnghvkDVmZD6IVWK59EpgooBdLrf/aBQAWNOewC77UtCikKKbofXp/sDv+pv7I+fENTA00wD43nEUYgMVcy3DMsbcUaJ4V1PpbQExSK1C+TJFlnmoRxAy4mk6ap8GdpXsMOAHGVZQdgOXrYfQ7mQUMLXR8+Mw4b/VzOpTenrMBEbKjKlm1pgwDYAhvFCBxYtLjtzqbbL+CmGLqRHdKKpFutKAEfpkTZUNVBQ/4qmXf1FmrAfvOm2IYWLajcCu3EWigLTG1hPDItSvcN9r6z44zXM3WJ0hYoQlXJRak4UluxGv1STJ9Y7VCN4z/r0X7Om7tZ7kDj0+IFjDlW7cNkhLjHsgp11QA+A8J6sNCkWMnf4lK+NVKWvnT879gcezpBXj5+F6OILZ8wnZ21QfFbM6jnYqnRLGbFRJkwO/1XsRr4Ff7Z2vGnj617wNZjXL1M2eGab+6moA3coeSmEB/H0fGrz6F/p5ykHIem4RLhgIN6iLupV2jL3LcQKWQ3vtkD8xkr0ZZ77ogzZ+ZSrvoqZ9lcKOSmrY0BDg6KedeappIqUF0WYB2ndOW9Bboz9l7EVVZgbI7d0fqIk/3cOJacVXdhH8jMWr0iFwu9qsGYo14f9H3FkGoTUezKNW8uI3BnFcogDi+V6rIcHQRwnWmRKfoVf27X/+l4TIqB4XAZY/NatJnApVix1F4bLaimxXpiOT6U4THO6o+EkWWfmLSQk7fa1xMPEa1PByZs+RPnodcuW7DhFavJB6/7xTn8TW2d+EocRDN3fSL6cCKrT26TUGuiiWuvecfxqiThH6Wy+kBxmMPBnHJtV/sy4JYM+IcF0ib2CDP8Aq7Vth/wIlWJ+SVHuy5+94ahAzbDnfT7FsxUqGuzV8vR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 14, 2026, at 19:32, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding memory
> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> lock or acquire a reference to the memory cgroup returned by
> folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard against
> the release of the memory cgroup in zswap_compress().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>



