Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC8FC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 19:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E5E6B009B; Sat,  5 Sep 2026 15:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676DF6B009D; Sat,  5 Sep 2026 15:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568886B009E; Sat,  5 Sep 2026 15:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F58C6B009B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:45:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82DF4403D0
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:45:32 +0000 (UTC)
X-FDA: 85180738104.06.20F778C
Received: from outbound.qs.icloud.com (qs-2002h-snip4-11.eps.apple.com [57.103.87.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9BB41180007
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:45:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=LVeAVtSx;
	spf=pass (imf06.hostedemail.com: domain of bfguo@icloud.com designates 57.103.87.211 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788637530;
	b=F2YIf5GsBBTG8J0r/PCahKAHKBfG/sVTGzAZLE9Z6xnA786bDDjwveDFvPpDqkzQJQ0Ybq
	ttFCxHEGbOGb+WIk/UMuy17g0Ie8JXix3/7Peb3jJsk4yuNTpspP/BhFo1I/J1DCH1Jc2m
	bc02srl3eCUzGjXUdv9Y4i238aVTnx4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=LVeAVtSx;
	spf=pass (imf06.hostedemail.com: domain of bfguo@icloud.com designates 57.103.87.211 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788637530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ij/H9+RBYCrUvtV8IoLnxtztar7yjDWo8m1G+THjprc=;
	b=xcMEzqSaLqgXEdoVfUAqXw8A7ruhJ0Mfq/XSpHsx/Ajv7XtO+9f2rc1C+kkB/mwXz1guz/
	q17UfLEkfVYvbWH7lD1X7KkpRP7vnXv4SLl3NRtQDwWsxxxyr/2e/vIQ9rEdrEXES46SPH
	3WIZyAwnmHoZO9CTylMLu6kTeWRokf8=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPS id 59424180014F;
	Sat, 05 Sep 2026 19:45:26 +0000 (UTC)
X-ICL-RepId: 01a0731a-b916-706c-866a-caa7764bf380
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0cREVbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKCGpVYUBwDGoAXFVjGXcpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788637529; x=1791229529; bh=Ij/H9+RBYCrUvtV8IoLnxtztar7yjDWo8m1G+THjprc=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=LVeAVtSxWH68i77itB0aCkIdGp1AYxueIQoJ7yD1Te4NcKuQYecoYP1k3yoClD99uN+WLDNYYm8+roED7cTG95Fg0L9u0B3iTP4keGaWlZAsiPW6YACcilaV9AJ+9Ga7cG3QKyMtDx3yt3JMYhAiz5A1XSKNo0BVM7HhhVYoc0cYJ32wZQm3KSkupQPFJG+q5h2K7pXMtDTpk8OHxYsRcsiEzpCDROsLq/1MwymhsHABXlSVlMjRM2rBBnuQw8l1i57QHlYcD4XscczDSaVZWpkbU6r3miQ0bIb0lQGNlSCfxsPoU6wcfSsbrd3YNWIeWlGZfRUT1Tvv5CGyT4r6CQ==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPSA id 6AECF1800136;
	Sat, 05 Sep 2026 19:45:20 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:45:15 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 6/6] mm/memcg: filter out reparented memcgs got
 from memcgid
Message-ID: <apxxS-R-GgXpe-Pt@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
 <3F681C23-8462-4BA3-B3C6-B7A45A9341DE@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3F681C23-8462-4BA3-B3C6-B7A45A9341DE@linux.dev>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIyMCBTYWx0ZWRfX2PDczRc5LH1h
 D4z6/Oc2ZOgPy2Yg6O5ebmL+K6RFGGxaWwV9I7m208B/3hnr8/lQIRTsKkasKOAy7GU1w+zbP3o
 JHQyMs3g5aJw9Rfq/8o5T2uG6PaLE95unk7Wkdn1eCDELIlSAJONDrsEGwrwYsEgKU1aQMFURvD
 BXXRh33KL7ZFfxKiQjDPvDVs2SD7ql9RTiJx7Z0hgLmKgTVKJ6Tzh29jtqM0xma2PeT7de1iDKe
 dAqBKnmPEb0EPjx9IGSTx1BZOHyLnI5c0d+rzGuCEjxMp/mQp2SYcRNeUbDOencPxA8bbHsQIwK
 KQK3KJfbiDU7N98pi12kp2kp9PFLwIJkNQGx3UGCt8qw4vhuDSm40WT6tn418c=
X-Authority-Info-Out: v=2.4 cv=YaWwJgRf c=1 sm=1 tr=0 ts=6a9c7157
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=GvQkQWPkAAAA:8 a=6M0O934HbYkpANdxMewA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: m84ibJRqfqn4m4oan2iZ5z6B25R83_2u
X-Proofpoint-ORIG-GUID: m84ibJRqfqn4m4oan2iZ5z6B25R83_2u
X-JNJ: AAAAAAABnlKTAD41Z2yG/m3BLmu03FzCv6P+TssBS4Z3iT0XZRv7suIlbp/8UGzEzz8R5cZp85bnVIKpRA66ix7pp+BPvgsO71JbgM/t9HkF+nk+x2zMCKsG6rVVCI3u8V80BZRFT4UFFOnwa2yaSa2+FXnQzohdUQEccEfKNLo3MqTxglUhiyeam+SgPZCQXISKl0o/tG3V3fAqidxwPqUuH9zAjMla9BUzRNwtqZ/BLWaebuTNAEsy+sGMGJcmEbki9gttDN7/vMSCQfyUY3lxuMTivtSKkOvO2FVAfba3agl5DPH5IvFpbA/FAQaxcUD6OVPxbKylA4PAns6i5NcdTxCM80bsVpbNxWrECNtzOKNEca99i20sm/zbmwdMJITx+wDFMYB/+oNd7jf7EE/wRaGQKrbqfhty9SMurB1MbR6fay7uA4T8o3HxvdIJV4RPqJXkxVfM2dZ001AeXh8rzGEVyxQLRvkLhDD7vfZHDFqQEW00IOw8qzieKYoqgnJr2cKjE16pCpk2qeQO9eZmD41oDqNExxQHbOmMoA49VRwOQub/LZ6cD7ngr7S/uGbw95I0gDz/hlDzgOfYFhk1aXrvxTNTjakByChluS1c5z5DwhqmguJvK03cxGa+HE959+Nw8yWpo/FoYkv2ghfu3j3sJb7H+R85QA0x9vnF7lezFuwyAocXxfY2o4eIHf9DUVlOeiG/eJO3NinHpnB+0R8KRzSH5p3M9tqXnnTYloQ+Jjf3mJ5rYk4P0wk4gbmi4llXOQqjWi4AS1wRf47CNoJgC/AcZPpk1W0rkwrYWvsi/E6Wk3OJFk8BRnugmTMQjahX+vC18mfEMPNSrwJ7yaK35SQ4eSWSzoKxE6TXZzCvJvGK2jK92lXmHxta+dyp/XJoQAK/2twZcJd2xS3++F/DtRAcP7P6uGzd1tGDhn5636zplXHpr/6dNLzOzNCkVq8e6PXulzmFNK4eMNB
 7fGz7OFk
 L9R80FqXVAbuZRkpgbklRyfrwniUhWcmr9loArYWiKt7MBBzRlxT8JKJR7/gFFG4tIzUmn4ysZpscMA+noWLFAsGZ2hPZp5Q8A59tDsZovFo+VMnxcA3lWNpqUOJtzPKdhTyFM439LVLky8CKgJxS66nLjkGmd9F16sTBFjzIwrywE5R71BhcQDziKfek4p9RWKIrj7H8fGi/lhzbq6EiYxcxhlTjdJW5ngSQgjdG0XSlCy3XAWX1TXXK8vEcybloEQxsFamkPoN0yCsppwlJxGa1/pfJACpJbm+7GOUIjXUcT24nCs/1YVNHkYEZTrjYPV3rlZ0vShd3nw8HXegg5BeS4idGuDve+Mdliajgb5Ld2/0hiF5TaWQlNx38dkWNb8SpOaYL7jaHXOyfcNr14hRcfnGH/mDHDjfvQgWMRrWzvt3L9N9rzzKnYIC2nSZK6RC1sEot+cw/dFuJOqU7m2sDH6BsaiX9bP3S
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9BB41180007
X-Stat-Signature: pi6g61w6jw3pmfz8yx3qiq9379ayt1wh
X-HE-Tag: 1788637530-466855
X-HE-Meta: U2FsdGVkX1+pK6KrXuHAnfu8HdHpfT9B4lVv+tJAXObQUW0NfocgPrQD1GZOQKtFC8ZmEWNe9dM8xiCU4/5Akj3ksouMjwMef+3T8hAV3pU6VsewbXWrzY6ZMh4GPgocb7gEWz8fCUGKJLO9RPGZHcSt1KwzlDvQy0dvA/G1q0SuPT2kbEuAh0m7VB+evTCJSEP0e0VwAv+kehrSBgGzdtBIzSp1JAx83CEDNrClZW/JP49uTaEejvbDAn37RhhkKtOrM8M6mIs4ShNDAKnkQEQf+cqaQU4HpxcD3nv5QO8Z83hhfIYyzI/sp7bNVZuzoInYKT/l+M7/Y1Wr8WHiCLz793289uYyisAA4GyCLmAmbq0kDb5W+Rf1TLW0iZ2Wdd24HxNcSjN5kJqJqOdxHfmNnfx58qmL2yCY42EENl8KCcfnd5glVI9u6algKPzXtCnDD+9NFcOi05ckTjmZxLUH17F0npOc6qHaYrt+Z0v3HRAYXsHOUjmz4xeaYCcgzbTz9hjmLt6c7YKY8L9YGeUFvDSY+64MNSaySgSwm+q74bsE7JHv/7LRjbJKNNZKjDiPybJTOhVyWl6Oi4W9VI2DYKpwSyD1+OLI1POucCXiSydbJ0gU9L8gyGOhFn0qu1Uu8ZyTL/XLauODsdW/jIo5Ds6g1VAX/8D0IQCTZiXOobp0f7S0Ounx2CsfEHNvL/MTpq3Z/b3+e1Jl03jtljWW0j+idd8ViYkhI+jz+I5O5+aDvA7JXMimrOi1WjS4z4kHQxFpIYJ0Duq4I5jsx03+IZCojWvtuVJe6olvgFms4Qbt+mBhizI+76atDSLP3iT5akwZcCBIvv6vDobGgc1461gv5tpVwpbRokjClT9keqLaoDnWCgJsyfn2aX6w8CHNpQDdXcEaMrdHTFy3mOTlcKVqqXdtAaS6nbyZz0tN4rptxvxrGBtpZZrAJHXEwu4wROXNBnjnsGiDX6K
 Ep2cixJ1
 Hj/9/mmtmNEyrKHYjGGDkqKRaJdtKKa0kZ0bvy19cxP/oov908IFZxuluDs2TCoyN53txL8OvEDJzAqjQqSbxOOwo4tXo6kMz3Yhy93UHAa6HA1m+BwRLF5oGn6Ud2gLW7U+bd53s5WU5HRH7icbNLr6SMMQqz15sTCWo0ExvtYqi5+tLVAGYcR2JQuYxFCJmsl8lfFqgQoufLh26DuzB3w8c805Tv2q67VD8AjOkEETxyPVjyEn0BKbOThR/u1lmfImP1BFkd6iCyx87bfZy4uvsrKLctpD0YZVuFNyM7L7irsLdGaQDazPg+SO/chs/extoFOoXa38mZ6jNEyZxZigE+hg+rNiQvG5g4Dh9z3Ut+2X9Xh3Bm8kiNK45MEvUI3Nr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 08:18:03PM +0800, Muchun Song wrote:
> 
> 
> > On Sep 1, 2026, at 16:58, Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org> wrote:
> > 
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > mem_cgroup_from_private_id() looks up the objcg that owns the id and
> > returns the objcg's current memcg.  After reparenting, that memcg can
> > differ from the one the id originally belonged to.
> > 
> > Callers such as the list lru and workingset refault code expect to get
> > back exactly the memcg referred to by the memcgid, so check that the
> > returned memcg still owns the id and return NULL otherwise. In this
> > case, make list_lru just skip and workingset tests use the root (as the
> > comments said in workingset.c:460).
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> 
> We should move this patch earlier to avoid introducing the problem first
> and then fixing it later.

OK. I will keep that in mind.

Regards,
Bingfang

> 
> Muchun,
> Thanks.
> 


