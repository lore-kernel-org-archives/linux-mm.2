Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC871C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABF86B0162; Wed, 12 Aug 2026 10:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783D26B0168; Wed, 12 Aug 2026 10:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2E76B016A; Wed, 12 Aug 2026 10:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47E036B0162
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:46:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEA71A1B77
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:46:43 +0000 (UTC)
X-FDA: 85092893886.13.887D407
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4218F8000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:46:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gaSj1BT7;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786546002;
	b=lplOdfT7N4fpCyv76O/BASkGRM7FCIztuAB840z1+bAntLP7gM8+5cGAd6DoNBjlmDUVbj
	Aw9khZXDfIwOTsC+YosrlM+Er8sYtUXwSfMOG29mCJ8vMwVm8yZphmKRyq7GUHU3sOq9XH
	GOjlgsC7s8L2JYx4owV95FGD0E8rCbg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gaSj1BT7;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786546002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmSRdXbDxC5n1fJ3eK/gMJjVKqziFhOwGBO5vuQoRgk=;
	b=B7MeJ7hkUEqNDjSK+4JHdkWWRgzTKf7F8MqPReEpamfbys8KSX1fjyNuOOtD+uJ80CuaCA
	821Xsou9WpnW9lxqx61Ymb69U96VqRGOGg7i8pBVLvLVr21yNx+nYlVrSjNpmYljc5UVKP
	SFlKW/Dt1ImRNaGT5MPnMfCzeBWiG+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6334660A92;
	Wed, 12 Aug 2026 14:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E081F000E9;
	Wed, 12 Aug 2026 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786546001;
	bh=kmSRdXbDxC5n1fJ3eK/gMJjVKqziFhOwGBO5vuQoRgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaSj1BT7QxKuMtbp1QTQ29Z2m70mOEdqmCvsBkiMou7WyYKucciI8E4D0HzMQq6Uj
	 p8s2uInxnHPfr+wLZFoDeuOkbY1rs7+dy1+KmYFVsRpVZYAbY25SLz1mz5ZPonyFCv
	 lX/S8U1mTU9e6cc4NJCdoE3gwtiXduOMuOMDOb7yXUSarlWrWcw68OKYd8QI67q53z
	 Zm+1LTQopJPSjltBg0jG1UWJ51gwAVpx/HyEvtN+3OeaqL/zlm7kNhedgQerrRX4m9
	 aLIHK0LJzRbosqtGIyYDtlf3pO8fjOuo71f+OE1MQiIrhGLVfsm2hm2574BHbqFdrz
	 OSRVzqTJipJIA==
From: SJ Park <sj@kernel.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?=20Michal=20Koutn=C3=BD=20?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if debugfs is unavailable
Date: Wed, 12 Aug 2026 07:46:32 -0700
Message-ID: <20260812144633.125604-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812050848.848882-1-wfelipe@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4218F8000A
X-Stat-Signature: i9ux36y33nbtkt1y6gg35tgs7oabtxyt
X-HE-Tag: 1786546002-139575
X-HE-Meta: U2FsdGVkX19X0+iZsv49e4X38vQz9poPa08wVFJZ+K5VBGGRHyfiR6QmloeBJOrfwCgwQgv8Pc96SMPele9cd92fXmoNRyt7HMXc6MA2m8a34jKBzHnJQBgQt4V22QfBX3uaNdxmiqVW4gzEJqDNaPRaIF+fVUsG2TgCB8kYhaR49UaQOKQr3GuwqN4JrCo0/cw4kWDiZsmtNdcE+Shi7be/41/C7gi33oSv4titU2RCXHeH5v4hC2KlS/OozqYr6CrnmHfoXzrw6VfmA/vNeXLO6UgzUEBtVFFPnNKGsj74Nq/I3+jW0MnltfTXQg3CBa353407S7dqjlXZg0d2eEZnBfx8mH7/KwoE7++7+fgmQ4gQi74GpcxrJpRatyyZOL6ZMriDzeRzZbqBHNj7dU+RRrD1WubJA9bSiPtBhVbt1gu7MBtxNUq+yfHMgo7Kyibdfu3M7QMz0gQkDyBgLxfkW0+AwDUqzNbtig7SMHbQAS7gpdmojLB5JVDa4f5rWctCPLmO4jPmFhPcCjsOHVvxLGVC9qsp4jLKvSMhNLwXE0HdWv7BDx43/dFHG8rQYIcdrd8pOxrC655uitYqqbjMUqtzIFM3L+IVLERI4hXa40woN+RnsfDbeqxBdQOhsFch79PblkzzBSUCh0qS0HcccQgy1CtgaYy/Zw9I0Iws7U2bLx8YRroZlicdYf9iiwmwsQQt/Wenvy2/DNRQWt7L8YF5+k1irxnKaYx18Ke/BIAjco69RNPItOxcK133uKViC1UChzp3XlfX233n6emPpjqWTeJ/h9Actt/a8L7vfU4OZiNHAquoqVNChAUOdmZ5Xh2sW6hTKh7F5bF5axIK9A+J/X0eGHx7NTajUAcv1gBDTEn7ekcNrisATjpNRVxMvFPXzE/Q7mhChfw7r7a9PaeSDXu27u3m9fz5/ZESAYO8SCAA8mV3NhJvUieg1FEgxo80S46flrFetOe
 +rt1s6P+
 LTgsjxXegM0xQFAV34zby+3euUj68MtGfaPyHht8J2saFBMce0LY2eYRqF2ZAao6N3GQMJgLBkeD3Zp3TGJwptDQqxGwkOtz+QUx4dukolaHiimg8eaRdz4J00d0fZ1yQl2soDWqkxVnfHKIgWTxE4AmsX2TypE0ObWxF+EHyAU2kblvAwDmdfPWrsQ23ZMmsYt/t0JaDzwSvC55++2wpAvNc0nUTYtL/d/iIWrEUkF2A3NaxNn2vktNzQUPqxbYy4ZiTnCp3XsjkbcL3LWmJqeQFxMfhT/3JUzJCYEbWfqBykYJemmaXVS3AKZ9RLN7QM+XCNS5GXETXCx51y3RfvH+Z4iuV958OGrE9T5uZntDnQNNvc6SLX2ZNa1CwuIXAvwyT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 05:07:55 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
> 
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
> 
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
> 
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.

Looks good to me!

> 
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

