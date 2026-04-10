Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4137AF36B9B
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 01:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9016B0005; Thu,  9 Apr 2026 21:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A116B0089; Thu,  9 Apr 2026 21:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5487B6B008A; Thu,  9 Apr 2026 21:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4111C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:14:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3750160331
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:14:53 +0000 (UTC)
X-FDA: 84640876866.01.6EACD18
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C71C40003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:14:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jeMhll+L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775783692; a=rsa-sha256;
	cv=none;
	b=mYE2aQppkA0ZlCc7r69u+MNxpM+6vD6OnpbQu2oqxPlxmyMkFO6wGARvb9QkDKADyAJ7Nh
	jL8Xwx05xG/T+8lm7B/Hp+ypEP2H9qCZcbTaPPCFCpVPrkPTb117ZxpI5Mv2tNQtz5nR5z
	Gh+wSpjwePAjF7uUhGLlblPjuzT47to=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jeMhll+L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775783692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=iPuNz30W1kc7kVkvLSskv85UK2fp6q3cCfYgHn1vLws=;
	b=pNTK2KhGSrTJAB4coeFxdeCqX90dQkzGQINQTXJL1V97qw0yInOQb2JwOl6vE8ShtG59f3
	oeydzLqO+f3lHZQ7y7hEaFf6bKPHTEeF13zMyIpdO/dcwXorQ9Y7iSIOkVRDFwVNF7S+Mu
	IhF507C5nHzYDOcwHjPzY9+exFP6MAM=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-356337f058aso1126243a91.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 18:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775783691; x=1776388491; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iPuNz30W1kc7kVkvLSskv85UK2fp6q3cCfYgHn1vLws=;
        b=jeMhll+Lb4Vfror1QUKloIh9MtODSqAa39MBrwOeYmkKVLPNPZcreSaJ11NfvYv5Rp
         pjXvhkNHj9bXCxPxtWLDSgoUVw9wmp68swNPFiqpTRlvqt7+av+Prp7HOKLJPJWa0nQV
         sv5hpubxNRqCLBxtNye23XfQGDe7/lDRmquEtK3yFyPrkoeekZrgUsq+7x1YkEcD3mj4
         VUFUqtenegVjvTifzQiNz+jWRnSqb2r8BJMgD9jhlZCSaYk2exDoSDpLtKsi/3qWndxT
         sh1Lx/Ra5cyEl5WkLBhltaY3V2IuMr8LsK3lK2VLIk/8afEmmoRHtaDzh2G+aYX2LJan
         PTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775783691; x=1776388491;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iPuNz30W1kc7kVkvLSskv85UK2fp6q3cCfYgHn1vLws=;
        b=Qg4C3g/4tWHrZ4prTZ47wLVujQYVAEfetm4iUoK1t8P9QMQ1ZQLRk6OepxsvTrkfE3
         5+KJvkZLly9ooPQPPdsMmRHb+sJ+2CCgkIsoH8RggUVupWtsjFBKkMK+hKfV17b3amhh
         zLjdkG/WeiYY2pFilHo/lcgf0vlbYCiKmTieClZRFUXcreIhkwrVOD1TDdSsrz0yxjL3
         ZBCTVN4EmT3SA4DA8djSvIwTePVlv2+WyByF8MQMnh3iJ7nmBrky2eKA71fyiqZ7k5R/
         QBbiFfmVO+qVEKTOFggVbcoQTMnRI/YGB9l2hyv5palMwRggP+cKAjFi1wuZdHnOJE3X
         D/TQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1MclgXgKjMlJtUXogjSmJP7AlJmkd5gCFl7uTLwX+uLFbh5i4q5EOQDZLj3dDbLj4BhKHlIblxg==@kvack.org
X-Gm-Message-State: AOJu0Yy8KQRds9y6SDzIDk5Su6RDM+ASzCQUYVWoVsbycEdB0o4f5xBq
	2/espoefb88neci37XuLAHMLY1P3mY7oxCcI0FqYmgrQzKRUrX2pBElj
X-Gm-Gg: AeBDieuGGwP2qXtRboC/cQBfnOOOZpvtqtgHiiRDSPfEe9v1oJbGkhiFCcWDJRXJB1j
	zFTXnkF42iw9/N15wjXAZeoRGsZqvJcMWg+UrLeM7aOdh5h4T4ODlc8vYa+IVg5RK0eooJFjlIq
	q3TCuElgDHOXtcTlPz/yZwyoGN/5Ag4euFTJrhw8b+0jU1X3NtzW20PJSBtIewrgmKHfgk8XdSI
	iW31qTpqvnFc3/3RuL9BCwIBdB6Eu7gE4vdar6FQF+8+nDnkF0oP82aeVhHN5vD2WciTrfPVMlW
	jfHu+M7UKlnvA7OxJeVXFdl3x3E3fpM/k6xrNXQNH3AAUFfgIPCjzGp584W1OuJg4L4kb+V4TgG
	2wupBgZFj83LIB9Zq/e+efWGY0btGy5+5onICVbVz9eF+Ct36UllOqVDHuseKRbZZy56NZN2hH3
	XLOeb8xc5cp+LWKI+XJ/88Iw==
X-Received: by 2002:a17:90b:17d2:b0:35b:928e:ae67 with SMTP id 98e67ed59e1d1-35e42857f46mr1220745a91.26.1775783690658;
        Thu, 09 Apr 2026 18:14:50 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e3515b404sm4611574a91.15.2026.04.09.18.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 18:14:49 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>, Donet Tom <donettom@linux.ibm.com>, David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <huang.ying.caritas@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
In-Reply-To: <adezbGO3qQMbMEP8@gourry-fedora-PF4VCD3F>
Date: Fri, 10 Apr 2026 06:37:08 +0530
Message-ID: <qzonlj2b.ritesh.list@gmail.com>
References: <20260323094849.3903-1-donettom@linux.ibm.com> <87wlyqt52m.fsf@DESKTOP-5N7EMDA> <c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com> <87o6k1ubg4.fsf@DESKTOP-5N7EMDA> <bd78aaa2-888e-4c27-964b-09f085161224@linux.ibm.com> <877bqgvs4k.fsf@DESKTOP-5N7EMDA> <se94lry7.ritesh.list@gmail.com> <adezbGO3qQMbMEP8@gourry-fedora-PF4VCD3F>
X-Stat-Signature: zd18kqso41toa3fhrqjesi4gkhzu3ity
X-Rspamd-Queue-Id: 1C71C40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775783691-312421
X-HE-Meta: U2FsdGVkX1/VOGUDsi6puze4SuoepO1XMvL2obJHwMzMKRSQUORlSfmwEmUaAw9N4WLTDe5pCcGZupwdN2tNTruJtW3etlzwfBaBdwMXTxrCGMzVi/quj+V9eOUqdvrC5SKPkoHkHVY5vd2CjLZQ729s8MIXMN6Xox6X7qlPYz3RoTYCTLu7N+Zv1yzwQ+NqOdL3W8dhXsWZClA5bf83trnkN+6RbQIOOVDq4mb2Z4AMEpBMhvEWNGKhrse9dRWVfMsftXIjkwLAd+DM2H3nqAxxnZWQkUsvIH9841bURdjN7mmcZcgWNcwfbdnyKrLDnV6zGlD6KEG/qLDBoKwtNlM0hL/J+3ELgAEAhShiYWsXstYIl/tlq9pJrUOqYbjBmgmhl6JE2DhYwpVgKNNpy1/7CxCFBJfkfKOrKAWDWayxg7iUIrDPHs5N2JUJypYNkZcyLFKQBaN380n9tmh0rsUue+sf/hud/eedwfJiYSBHnSyWtlwrMrR41HhLAVkq4/DoM/ClNBgqVOr5LRDdGT1iKIG2M6AtgHeOk0DKNIDvtQiWy8I9fZ1Uzy7bvoHl2xJy7cYKQali/wtyEI83Y3xDWL2SHsPBiZps5YXUGNX6tHa6FpAcl9f3FDsdA5ObR8+YxoO6YJsDbuyEWoNyLLjLgY5S4YqFiZ1+lYJMDRlvRqkRIECq1zp25Bh1x3sak61Z4Z+VhTYNxzlck6O2K5xv/wassfqUeV/Ubq+M9Se+X7Ue7QO+6BnBoq1bQAU5MXQLmtTDu89wfJ2+Q5RWWJQpNNQgBn4zT0A3lGny3E/pEIUi8IRwnLtQQc2AJdA5+RZlrPLwwg2B+IBuscnLJLD5PqAyD7n+cDypAcMUTwviAfy1yJm1TAJ5NZKVdA1FyRiJ3ZvvCVHIPpzqKRDgxq0glFnfCmVs+zTyPAegiBDlpOS9CatKC6zhJ6KKMyYzQPm7+0Oge3lIWwoYE44
 3VkU8k1C
 Xt9o3NbxsMGFczaKAXMghSLVBfP85ISfSC8PdEmsCAr/devGjmjVtMQ324HhlWqo1sYFs3S2e6gkTNSA/lnrS9CfnL5s2JNmerm/jxfA1ISZkMzi0oWoydGmdo7h/5rVi3GRiEThoyqo4/ivSLSYlUuu/p31jDBr/+GBQl5DQzoQlP/uo9gcdz3U8DsG27yjYKLSJZ29Q/K7M4SRHjzLhO5/cPk82iq1O3Z/7mHjFweEYn0oaWxU/XkpMmeTxMEn4w5W82F/C8EjgzqR2tEYNsNHXfCaqxlciY1m2Ve8YvMXQ9C7gAhVV0SP86zYCkl8+nNfgITDzV1AhoizQkNc8fzkAw7IVuSnz8fw8p06yiUpEZP9R9b/DXt/fsEe4ETULAnjwzxXy662R087aDQqJ9VkuwSZb/W5MzbqAB6mcAUH+k5BQufr1ZJ2McIAqf8ZPPJ6lPLJCOnO7DfFrXEVws207NLPNQja357NH0gBeX+/xE+66f+6PfCGN43xCaUC95mSOANh1mHdv4BHha4+LYQa30BV1a4dIW/1+LCP/4LXKf0LneXaeOuzVJfQ/0iUTsZj36P+haO5mRXw2SEvct4qQO7VNVKuSB8yz9vmXQuGjf83sczZiq4qx4jdf8n4IVj4D92M2+nG8FNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> On Thu, Apr 09, 2026 at 09:12:56AM +0530, Ritesh Harjani wrote:
>> "Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>> 
>> >>>>> Donet Tom <donettom@linux.ibm.com> writes:
>> >>
>> >>
>> >> Thanks for the clarification. I was running some experiments where I
>> >> only required migration, not promotion. However, I observed that
>> >> promotion was still occurring even when NUMA_BALANCING_MEMORY_TIERING
>> >> was disabled, which led me to believe it might be a bug, so I reported
>> >> it.
>> >>
>> >> As I understand it, enabling both NUMA_BALANCING_MEMORY_TIERING and
>> >> NUMA_BALANCING_NORMAL results in both promotion and migration. Given
>> >> this, do you see any concerns with modifying the behavior of
>> >> NUMA_BALANCING_NORMAL?
>> >>
>> >> With this patch, we would have better control over enabling and
>> >> disabling promotion independently. I would appreciate your thoughts on
>> >> this.
>> >
>> > IIUC, we change the existing user visible behavior only with strong
>> > enough practical reason.
>> 
>> So what I understood from this discussion so far is, we don't have any
>> mechanism to do auto-numa base page migration between DRAM -to- DRAM w/o
>> triggering promotions too from a lower tiers to higher tiers.
>> 
>> ... This to me sounds more like a broken interface.
>> 
>
> It only seems that way because the naming suggests tiering did not exist
> prior to _TIERING - instead _NORMAL just operates in a suboptimal manner
> when multiple tiers exist.
>
> _NORMAL migrates a page when it detects the node it's on is not the
> local node of the task doing the work.
>
> _TIERING takes into account the liveliness of the pages with a
> timestamp.
>

Sure Gregory and Ying, got the point.
Thanks for your comments and feedback. Appreciate it!

For now let's live with that, in case if we come across a real world
usecase where we would want, only-migration w/o tiering behavior, then
will share it.

-ritesh

