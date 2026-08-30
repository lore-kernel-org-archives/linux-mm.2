Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431B2C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 16:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C52F6B0088; Sun, 30 Aug 2026 12:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176216B008A; Sun, 30 Aug 2026 12:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F296B008C; Sun, 30 Aug 2026 12:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6E726B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:34:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26A271C1C30
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:34:13 +0000 (UTC)
X-FDA: 85158483186.08.89C8603
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9288A100003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:34:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxFUMVqQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788107651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItGHUO2m/wmnNvVoRrFldiDP+k6ZywGIW41EylHx9I0=;
	b=WQvqcjLJ+WL9zrNyymHNUU2nuhNkE47/6WYZpUadW77B2whTkK8nM+NzTEizsRGkJk9ENS
	+nc2JvDahB6CYABys8Eej286IzppOV6gz6cHGdTYZT2zTDyZLWT1OuLOd4sSmN1JpVtT4u
	SNVk4uQYkqPtgYY4UqkxY4vzDNv2dPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788107651;
	b=hk81n94dd1Tb9yq7GO9+HJle2LWMCY0OQPb6C/ji2xJib2Cuv9qigQ/CjlA3RR9pkLcAIQ
	mVopYphMJLriQK2teVkaZv13I2hBqk5XUIp/KjonwFmqpXHwLpn7ne4EGSrbVv6ByHZNbO
	VRmst++j4vOzPcwsDV8ijeZbE5MHQiU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxFUMVqQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5050D600AE;
	Sun, 30 Aug 2026 16:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15CD1F000E9;
	Sun, 30 Aug 2026 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788107650;
	bh=ItGHUO2m/wmnNvVoRrFldiDP+k6ZywGIW41EylHx9I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxFUMVqQme8ZR/LjwyLecA1wNS25gKULYLUoMH/171OfiURmUbbJkJY3lgKhufDtF
	 oCBT4khp0yKRX7dwHqg7xW3DdsbLLGtP444F4FBQc+6BcME7Y7suEPA1sJmkhwIOJL
	 eyzSJs4YuWLAWl4xgQdZSpYb575/sfm/+L6iqDhgQPvfK2g4/FHTum0EBMfxeFdkYj
	 FeikZy/UHCt/OTzpTYUWK1uxk8DEidehJ2XuGlzVPBA+eOzOvSncdPQ0bpOW1D9qfb
	 +G06DBTBkTFkoBVF77xZr1663/9ZK33kDX5eOGGdT0Gl8KFmSBI3Aih+DNBzWO5+ob
	 k5hBInrZzqorg==
From: SJ Park <sj@kernel.org>
To: Krishna Iyer <kiyer@crusoe.ai>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
Date: Sun, 30 Aug 2026 09:33:57 -0700
Message-ID: <20260830163358.102281-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830051407.50008-2-kiyer@crusoe.ai>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9288A100003
X-Stat-Signature: swjibruckhs7hzr31oy5s7dtspcmgjkj
X-Rspam-User: 
X-HE-Tag: 1788107651-301448
X-HE-Meta: U2FsdGVkX1++DI0/Kon4hSapTGw95+LeIoA6SWYSgrUUpML+Fr1Fyrt7g9Fz3B/ktjeNFQN7fB3JNWOWYATxLGUn9hBUMO14VZHhTXNkMAsEOffDlnQTbrqpxiS2Hp7xhujxDLm+DvjlW8ahIHsTmtcTxVvT9azHLcRMMxf0Yaxa3pJi1mgpzs9NxO2VtdbCRG8uYe8ORYOGZjq1Vfw+0BXgnozvq1TnKVJ2Q1sg8oJ788/749wNtX4Qzxws2yuHi/gxxlXeL5UfuFPRtBBmsGDMbVfqJW7aP5d1a1TYkYISy4AbkPn1g5xMSfPQcdw+nhjQNs5aFA4/XHGpIO7M8wxDOGWBgQtEC5Qds2CSryYUo1EWH4LCZGUwxBH0pDyYYdwc7YdNguGYXqqy+/RDlDL78WNLhXQVtKWi2Xm3fZJvVBVwaRb5oYqkbH8SMUWIdBO5mUYNgS9eAzT1CWuLjHkJS5K3srSiMvUzGskxQ6N4FG130Trj4kemJjHdL27fzoWH4/QP5jOPv69rwXBQYWToWzs6rkEGyvCCDORQA1lbhiTwYeDmwBz7BaDTwXwAw1SxXwT+NZ/Yg/vr3wbE4uf6iFE4PoB6CwYDQmlQYhXEwEWk4dD2k529uc0PuIWixr5AbEBuvAo7tQxlH9/UQZiYZgjvEJrAsVnEXosLojDzxUaIKGetMs98nEbOIKFLodts1GB6JiZUjvzBzAMy7Lo9DmyzU1wRSaZGtN0l+coJJMURb6WsT5F7r0mnNTYZWJYhmmC3qmMLzbhGK2HbZGL5F3k/WMQpHZn9mXr7nXHaF3b9QeZvjrNrXtWnmitQLur+g8N4m9APJSijPQgL2kAw4z07iMhplRarz/i6Sny7+2jlJs/prXP3ibDP8vlu6WnYdlgM8U0NAbL3EPz9GQnvCLy3q1vjqx5lBcvmgw8N1p/rwT7h6DRTFslNJOYZCTopXYHl0kTDqbMccQM
 BjEC4E47
 +TMP5mUoS9wPjbNL/C7slBdSI2BVRjUWaJjpxwOt3pY4bEJa0fXanttywTJqRh2u+2/TeizPGmzIYozEz351rtAvKQSbb90OzkOktmBgDRwrTbY5LIjNpcO9Y67K4oIr2WcIwmSxOLK8J4dtiOMemOB/yfwtGFV8b3vlTIxW6Fln5bY3UIrYXNMz+NS5NKnebHWwxZBYrgOb+NB+jEnbkK1lO9oa/mTw03jcU71UeG33Joixm1r69oEeAfO3iWz8Wo/wOgKVR7GOhb0fjX4iWTWj4l7+qkVmss4fLqicPlR1z598=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 22:14:02 -0700 Krishna Iyer <kiyer@crusoe.ai> wrote:

> damon_hugetlb_mkold() clears the accessed bit of a hugetlb-mapping huge
> PTE and propagates the aging to secondary MMUs via
> mmu_notifier_clear_young(), spanning the whole huge page size.  It
> currently lives in vaddr.c, and is thus usable only by the virtual
> address space monitoring operations set.
> 
> The physical address space monitoring operations set will need the same
> logic, to support access monitoring of hugetlb-backed memory.  Move the
> function to ops-common as-is, with no behavioral change.  A follow-up
> change will use it from the folio-granular rmap walkers.

Looks good to me, thank you for this patch!

> 
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

