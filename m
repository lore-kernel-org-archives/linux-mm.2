Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3483BD3CCAD
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8615B6B0088; Wed, 14 Jan 2026 22:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E8E6B0089; Wed, 14 Jan 2026 22:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B9C6B008A; Wed, 14 Jan 2026 22:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 630F16B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:52:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24AFD1ABCF5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:52:21 +0000 (UTC)
X-FDA: 84332825682.28.984489E
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B2FF100003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:52:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhDYDSir;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768449139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJanBQGwiNlIzIYjsIPkM4qYw0PVa/FwcDXKz//5f1Y=;
	b=2ICPjPsSCFATq9QIgrucZJclJM+M6pC0eH6dr+Gz29AjN/XRQwQR7/IQ2Zxjzr8ZrUEDOJ
	pJMe4OMokcJGOXdIX5wOZHEoSo3KdqNP5xnbFKE6FE6o0nuodgMxJcV4DzrHUHniGD4Voj
	7Mvpqf+Wv1MPbLYM4+diTyrvLs9eMeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768449139; a=rsa-sha256;
	cv=none;
	b=sMeUwW07O3sg1TBsiWfUBVqZ1QCU7VaHzGc3rUiXZlL1UmpAROWnkDV8BprbN0QUXfVg3L
	U7MseFBejOXvqfebp4SHEgY5d0HFyAECWNhVMhRxQY3x/zjGs1IZt+ICmMtHMkmnL4i+j1
	PgXX1oaJRgwg1us1+nDtZhmsWadNY4A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhDYDSir;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <98819615-5001-45f6-8e63-c4220a242257@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768449137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oJanBQGwiNlIzIYjsIPkM4qYw0PVa/FwcDXKz//5f1Y=;
	b=BhDYDSirnJw+eHoRUHKJU//R0gZHAKbWUCDbxWoxDqkkOz+Ueo/bmbgXmC0y3o2lAfiBb+
	CtbQT78LdfZ76/j46TNgR+CZ7k3Hz/1/xflPkMJQrAx4+ZVoKssCf742EhN2/jOTFciGrh
	zUJEdJ7aqmqlcxX9p605iX8XQo/KpCQ=
Date: Thu, 15 Jan 2026 11:52:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 00/30] Eliminate Dying Memory Cgroup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <20260114095839.eabf8106e97bf3bcf0917341@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260114095839.eabf8106e97bf3bcf0917341@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B2FF100003
X-Rspam-User: 
X-Stat-Signature: zkuujrbwnsgqchgdjwyswg3f9m7kj44p
X-HE-Tag: 1768449139-762748
X-HE-Meta: U2FsdGVkX1/WhhC9wScMi7++Mt4Gcpb4FCuQVTv24dsFaDif8ZkrFBQHdQB0tS/SK7SsipdfYNpczkqlKu+fd/DT2IAnvBGCza9lyMjAvtFyM4igljxnM2ojKOzOJOVq4Ny3QSK1QWpLfCad5cxli4lqZ6mbPZplZ3Y3IL3IQr5b61Ob2hbDOk58HfNyVjz3pwir54Pg6TsQ8+DBohYWQjKQoy8+a9jSrlefMUfVem2B4fTCd6MUttMHojy+ct64k+o3IbSwSV7SuCZne0dK3WpWGvdZKievmA3B0Y05QBlHlTA0eltOIIWYsSMxr1aMKUS9rTsoIFe3/mMVqN0nN/2bAM/hvva4nggv9FjJg8duCPsDTn3jR3ZxFR0jP+DeFIddcFbqpRhluyguzMJqVLNH1ExJcxJEaSQ9AGAQM3RlPgOe8UOrUyuR1cN/sGGcbg73B4s8zxz9ctUGYmTsFeAAJi93FndL6mKwckwx1QM5o9ItBAlFjZ4VgNW0+zbC+JzfQj5l4tQjtz2W1zDlCZyFGuIN13kL0kcjliAOLjAtoTLy1qSGeIvnYG3jafdHsc8SGNGQRoGH5ftGZfh5bACYSQnHcjWgQU4Gr4CPmPM2qVNn7+jyn9nr/2ZgdYcJdppkvv3u+Clg2/yQ0kO3MKETKYRfySB62+t0jOt9Kv8WJII1Loy82l2S3r9fTNJEoF1PyhnrvnxHf/cNDM/6SupiPYyOF0WHuroGA90VUriFyzo/PCQi7qhm61KVtKt4/VV8RWrJgnm3hcVA2JZjmWv0Gzo4qFeKu0ozMvCtf5P9XQFjQpOYMZCx36ZsLwAp8HuagaXJ6hWDPqo3ldzP60N9wsi+k0TsfUvW3+2RoGcCCSi4f1OFIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/15/26 1:58 AM, Andrew Morton wrote:
> On Wed, 14 Jan 2026 19:26:43 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> This patchset is intended to transfer the LRU pages to the object cgroup
>> without holding a reference to the original memory cgroup in order to
>> address the issue of the dying memory cgroup.
> 
> Thanks.  I'll add this to mm.git for testing.  A patchset of this
> magnitude at -rc5 is a little ambitious, but Linus is giving us an rc8
> so let's see.
> 
> I'll suppress the usual added-to-mm email spray.

Hi Andrew,

The issue reported by syzbot needs to be addressed. If you want to test
this patchset, would you like me to provide a fix patch, or would you
prefer me to update to v4?

Thanks,
Qi



