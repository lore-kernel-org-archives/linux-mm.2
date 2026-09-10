Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79619C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AB26B009F; Thu, 10 Sep 2026 07:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC246B00A0; Thu, 10 Sep 2026 07:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAB36B00A1; Thu, 10 Sep 2026 07:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 404E06B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:30:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 944631404B5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:30:35 +0000 (UTC)
X-FDA: 85197634830.16.6BE4918
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD4BF40008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:30:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S3yeQE4F;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBCNw1Kg8vRuAt9owP4WH1fqcx+vljBI1htGsoB5fxg=;
	b=i18RTVfFUBdLGq/NgtixEAdoWBAyusS+8CBE3/x/ttixepUz4Gv/HUEFqhFLwxPcxM4DyB
	uGvbH+wzCiHhQ6O3bvXw9kjySQ2z2Zk7MD10bD0Z3VkLzDHj2k39Im6mO8QT57b3MAYZpp
	hGRjj4GthNc6ueTxaWj0DXvE5nEtQl4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S3yeQE4F;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039834;
	b=mQokJ0VqrKSSzPLp0Ejw8n6mXVHu7+94lKCyPuChCE50r74ofKDUWes2ik9Xm3ngSeAwiH
	90/ry4SBDC1Wgl3cABgfMZRuGCdW2H0wW1nYbLDgDfkkjt4zh/SciFfzKeE1WxlkXlpCnO
	M6l/SjhJnwodKpu2uCvz2uO1U8MO650=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10E89153B;
	Thu, 10 Sep 2026 04:30:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B80D53F528;
	Thu, 10 Sep 2026 04:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789039832; bh=L5i7mVveayCy4P36Os2p3EeZ4N7n15du1C0VbezxZKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S3yeQE4FGIKitHwxhtAWJo1+SEzcq29goaN6s8K/smUGgoj4iffJqZxc3GUYDMO6u
	 /B13CWJcxxeZN3brYIv0ZbVP0+FUlYLHBtUDwfD8fELky+hFAiC475N39A2mOmgIcW
	 WrzseTqc7sPSzeewfQGfJlVRMVpxA2xbY5w+/h0g=
Date: Thu, 10 Sep 2026 12:30:27 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
Message-ID: <aqKU0-Gm4yh78F3V@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
 <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD4BF40008
X-Stat-Signature: 3ns9wcmstfxykg6gtwsa8bbgpejgzdgn
X-Rspam-User: 
X-HE-Tag: 1789039833-490979
X-HE-Meta: U2FsdGVkX1+eGreQ/N6n9Oo9LIQSEi+RcYC0q+THdMtPp+HosJB50/btmEFtqxC1mlmJ0x2Al8RDhAvP4XiirhkTQTXWvXhq/boziCU1mFq1oxsuSphZ28IG4IEhOlBrwknVkt5SKr+E5okDMMMvaNC+p61VR+/63A6g5JYAwpUIzjERUaSTFMnhDSNm3JqxZNnbdbPN64RHhCv/XIuyAg4BoKvpMzH9fIqPX7ZudpcNH4BOZuArFgswHr6eYlD5JTq4VNVvYDZjeSdOtNYpmYqT6dFGDPLZpiY55BAKPyQCsedoQybHTfCFJtzB4mtvDyMHs9UM7EMnrHA0CDVpva+ZpZyLtBm72vAsgboUE6g8hf6by1T1OwEPj1fGTSG4ODS6m/nKUJ06tytNvnCkNT8RFlAYPFZR3DwbH+GxIqbguWJF/zKZFxraznowCc9uF5DuJT+I5m3w2K5O6nRXENbcfaQVySvHXTzwsIPpqEhHcxwZx8X6ZCSp4MC9RPH4+GPUfT/P8UkPC9e6WDqVaSnW4X0U5TcMWaEziNEVdSbJ+AWOBsVDlhZQidrWCXiVq1vpH6mqzGHsQ4mS4ZBG4ehVQvR6dW+rB9FeabYTIclBzKuAPX4FgKfJ6qJacU9hGS0TJ5vimJ0ThIm8u/m+og5RLQKekNhA22CCWK/fqod+OAx/jJ9e3WJHPPacpbak+RoJN7rUFWdlKjH4tI/k8zOIX3gv9AjqvvOOloVJDC6OmYvIW6+kIQwnWk9PbPasrC8xuE2VdjYjwbQhIY8R0qaHR6t9AYKyCB6X7qqf/hXAQEWQ11wtJtAJVicDHAgXDIHPqGZebDql4rpjWp+HQ/BAjIuci59e1ErjXi26G9o8iGAJ348tYXFIjWaDVV60HkFbOYT/hlQzZN3T+W43irPBPtzhXV2wqe2MrD46Z9HRlLCWjRUOIOBU43hmQ74kvpwTjnMDIC8VIw0ajVb
 vHx0yPTG
 dLmShKlp6SZLxqP2gq2UkWrcCiNRrxFMOk3l2he7BQK4q/hQoHCDeoFc2GJZhAZj9YELnlA2Ftc/OXOHI5ALvxzmLVBFqGAXJAJa2HKgDNh7LoDDhd0IHELWjCSOhogjnRgTQvZgJSTuB6q2yHru5pr0yVEK+VFYBX+pCRt5cd3jSR8pvmH6ZGNoggcRZA8I+ceeFiolhrj+jtCui/k14jJ9OoJ5hEkE8PDwogyfSZSMsReYaYOPhlsmJukFhnwleQW6fqEEdOj1Jf9chHLIeJIiLSbMYjq+ePzpIUJwlddjYju/p7zhaqj8L6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/10/26 13:22, Yeoreum Yun wrote:
> > On Thu, Sep 10, 2026 at 01:14:42PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/10/26 13:02, Yeoreum Yun wrote:
> >>>
> >>> Since there is no interface to get vm_flags not via /proc/self/smaps,
> >>> It might be good to have it for preventing unwanted VMA merge.
> >>>
> >>> And might be useful for future to prevent unwated VMA merge.
> >>
> >> See my reply on why vm flags are generally not a problem. Just like other
> >> properties that are not changed during VMA merging.
> >>
> >> Let's not perform random code changes without a clear picture.
> >>
> >> And just to emphasize again: VMA merging could already be a problem before
> >> memalign() internal changes.
> >>
> >> (also observe here how we do a MADV_HUGEPAGE, so this is all rather arbitrary,
> >> which is not good)
> > 
> > As I mentioned in my previous reply, what I’m trying to prevent here is
> > a failure when checking, immediately after memory allocation,
> > that a specific vm_flag is not set.
> > 
> > Yes, I agree that this could have been a problem even before
> > the internal changes to memalign(). An unwanted VMA merge could already
> > occur at the time of memory allocation.
> > 
> > So what I’m trying to avoid is a test failure where, due to such an
> > unexpected VMA merge during allocation, the subsequent check that
> > a specific vm_flag is not present fails.
> Which is only a guard-region marker problem?

Yes. so if we remove ASSERT_FALSE(check_vmflag_guard(ptr)), TBH
we don't need this patch unless other usage comes up to prevent unwanted
VMA merge.

Would it be better to drop ASSERT_FALSE(check_vmflag_guard(ptr)) in
guard test?

-- 
Sincerely,
Yeoreum Yun

