Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47122109E543
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294326B009B; Wed, 25 Mar 2026 23:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B676B009D; Wed, 25 Mar 2026 23:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8456B009E; Wed, 25 Mar 2026 23:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0547F6B009B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:36:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DCC9140B1C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:36:58 +0000 (UTC)
X-FDA: 84586802916.18.D0DE2E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8160E100004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:36:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bMgcC3g1;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774496216; a=rsa-sha256;
	cv=none;
	b=m2h9m1tc6YVhoZ2jnrSDIWmOrpQADVOsZqJNW8y6TVGuSOHCYXpm2kcrJqSTFtIFEwq7F7
	XW4Egmu1tJEmmy0hIOvsk9gf1c9LIR4URzYwB6Afb4lnnHmfXXdOnBS01M07jRpvFKUnbY
	yp/GCdNHhVJ3V/LyQGDzd7UKRoy0PTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774496216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1qEbgbIH4A/QHtufRtuw1NB8qq4VD/DpDwv3FOjnA0=;
	b=rQEPE3ypNhKSSs7nnVFJIOly0P+n0pLpquG3R6zVExVuYoTozbSWBWif04c03sS7g7DalS
	oNgsSmxJt8up7sAq9bbQACPkgUDR6qMPOq+xwfv8mpC2jDYUmybjbr4pxArnP7CxzVB4jz
	iMLVmkWQe3IUhOMk5ttuU8HNOw1n0FE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bMgcC3g1;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 739DE441FF;
	Thu, 26 Mar 2026 03:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419D3C4CEF7;
	Thu, 26 Mar 2026 03:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774496215;
	bh=CqQntqxnCRIB6D4N7KvDeKcg74YX7cXVaqW8OLCN0lo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bMgcC3g15oxLe2s+2mgU5KIVNpzgBLbCCrlKLe7f61tbsM/5kGTaLmcJqSVMimfFd
	 hmbt1dsDCBq6u1CEaoBWZUontraFkC40SqxpxoShK66/95UQBU5N2tMPAYdzJBbQmn
	 zmJtlpz0SJY3T8jkmOeGFmYYAGyKjl44NNZxfZK4=
Date: Wed, 25 Mar 2026 20:36:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type
 of mem_cgroup_update_lru_size()
Message-Id: <20260325203653.5abdac45e7d22ca648fe23b4@linux-foundation.org>
In-Reply-To: <202603260338.GfCrsaVO-lkp@intel.com>
References: <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
	<202603260338.GfCrsaVO-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8160E100004
X-Stat-Signature: haxih49h553espgc68drmf45dj568153
X-HE-Tag: 1774496216-909967
X-HE-Meta: U2FsdGVkX18bqF4V7RJykT+Bz4EX+57b3ckKKsb4W8OnVBaAy6bJsdYXzlKHxSmOi4IavhUQ4CBcSaBgLK2dMsQSn63uvXVbK8s7aWkTydOmwk1HT/Z6yUNMSJgdEcpCOYR2rZFNAPCDL7WG3pxEMl1XCbuvyFUmv/wsiV/Gn1qsT4kP7ZN+eeFD5QL59n3Ax3AXyAcNk0sUURi6uysSqEbyWrkUkqOEtT13dmKiLf2cqBgUSR0ImlMltJ4HSkYUqzjydzCbD4V8DgkdPiFjBNABHLrojrjF5+Q4W9BXVE2uAP4nr4sfC8U/rDZ4jjOYh77/CQuFBmnRP/Kn2U0yV40K64RlMFbfftqF2fkbJGLIZmvXv8WD9ZCjrcyl4m5qTJwOit9usgSBU8DcPGw8wSMz+26d4i6Bs128lOCUd6SukhruwG+MJOD8BTf7yN6nR9QK+JPvOhW2YGI+yQj8iZQtI9aPowNOP+ZPcva5ly7VH4BSTtaWkREyTFLt7hodqq9onBl5R2bPsiJD0x4UeinGOFXF2rAQMLS83DhoBCLoFoxa+4I2rmBQN04K33VKYlWHCiqbf3kVxMRL6wVv6SWanM/X3e9wX0P5rq0XAl04TkeMQZjGLI7L8a1qM0hTtMISSDWUhf4ZuyfWQz9HoI8fHSpMxhyGAzckJvTpXbFXZkib6ApQmFzf14tihCuavTn9TYmUowzvMSDnVnNS+QDd7DvnEvkoqA4sDGKqgBBcsLT4ParenBcQbE540fMAQovx2YPb6Hn/BQadtzfWtx+YarMQkb9eNAqc8g0jDTLbRycNHEJ42fxd5o5/tWz4jLXj+E/qJplepHkHjLB0L5N2YEMdKZYpDGdc6qyIJTum4Gd5PYhpYWN0FinqfTo3qWM259Ii2DUUXKL3juNU280FXHLnuCxEUOwrIueg15icUO5dGoZZgoRMStc6YuaX6CDObCN3fky2rk1GKbD
 +4P6RaT7
 fpzhu3xUXZ0Y4z3NqRVroPm4Snob5HcMINv59rC/nvjC0X+GPEAb6pImvQNHMGq3izJe+v1Vy1VwUA88VAzRzO29yv5JO81R+aiZJr9oeg5k7q0tARZK+vUNDKYmvOnh8HdNMW+mWN2CaPetXOWcvKsPKvDZ2voR87d1h+L9upsIRu/6/VKGwnPv2smRm8lN9oDaCE42SAnuVmEkFAiq54/s0G+r3k3jthLCN93+9Mvkyk0knEszqZSRwGB6oeLs1bzouUZ69F14AYXv533PreMcwoGmVtYgh+G8n5C2k3eQJKn7Y7FMOLGLEH88mWqDONyU22ETCbntJyKfkM0b26WGC2FmN8/GLleNiaejP7o3xgAZ6ZxuH87kSoivHAJ3ZlogFbGVn4GPM5H7xgXJjwQ0plssMgzBXx2SP8zFnLkKzhZRqA6jYq7qAYwb+8jyZvJToV4M2f1vf81HimVMsqUEmS99SD/10AIWk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 03:35:39 +0100 kernel test robot <lkp@intel.com> wrote:

> Hi Qi,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on next-20260325]
> [cannot apply to trace/for-next linus/master v7.0-rc5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long/20260325-230337
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch%40bytedance.com
> patch subject: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
> config: riscv-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260326/202603260338.GfCrsaVO-lkp@intel.com/config)
> compiler: riscv64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260326/202603260338.GfCrsaVO-lkp@intel.com/reproduce)

Thanks.  Can't reproduce. (there are meds for this!)

> b4536f0c829c858 Michal Hocko       2017-01-10 @1486  		"%s(%p, %d, %d): lru_size %ld\n",

We presently have

		"%s(%p, %d, %ld): lru_size %ld\n",

so it appears we fixed this recently.

