Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE54DFED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF346B009E; Fri, 24 Apr 2026 09:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080866B009F; Fri, 24 Apr 2026 09:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFB16B00A6; Fri, 24 Apr 2026 09:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DEE026B009E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:59:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB48D1A0199
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:59:25 +0000 (UTC)
X-FDA: 84693606690.05.8B39273
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3499180006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:59:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WlvPv58A;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Da22khNQ60IhsChAIk5TOFcYlVQDKqW/4Q7AROo104s=;
	b=SJAXN5ZwtrpAwcw4Xd4QSNiI/saZFFUoOtN1Wtz6wSD9ZZAh5Xk0snkhqIgd4//UkGJIa4
	dzcyfrXntyWfCLIDg1+hU/L8zqhhF9bn5HBTAMvl2nUh4VjdZPfsuA/m3Hpr8cdWUIcxCL
	9NwFlU4vPEgxiTzVHHX+9gjL/MeAIZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039164; a=rsa-sha256;
	cv=none;
	b=S/+pwwhlY9mDHZ4BXZFzSGuP1BEnsdy3wIB/aVOWT5+VZED5BO+nohtNiC+UN7p5/mliJf
	+MoJIgalSrcJydVh20D77UG5I0QWvMJYd6c1avgfOqEc8HtAGkIKoraYiVF+JVMTJvPLc3
	kGuxXApa3Gd0N4fgGQDrhSTnZH2kMes=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WlvPv58A;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 673B5600AE;
	Fri, 24 Apr 2026 13:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6023C19425;
	Fri, 24 Apr 2026 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777039163;
	bh=dsyws7C3QhcBRmW2Z2/iUvwv4W4KTJIf9m+Mb2UFwwc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WlvPv58AweyqBPSxt4rxt4S8hfGBb01CgFVUCOVtb4MtNjpjVZu2bQLlYQjlfYiuj
	 GSfLtI4OgXKvGSt6nDqHhwNfEhFx7s3U++F40O1+uAce+xi+2RbKpWQe7pdD4ZORcV
	 fhs+1Vw/P7oEsJALhdJqDp95v2E0CJ4j198ToQvc=
Date: Fri, 24 Apr 2026 06:59:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and
 warnings
Message-Id: <20260424065922.5f15ca8c88eaf8a02847af17@linux-foundation.org>
In-Reply-To: <20260419174747.10701-1-nueralspacetech@gmail.com>
References: <20260419174747.10701-1-nueralspacetech@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hcadg9i7hr3hnaqb4iohh7gju7ysatuu
X-Rspam-User: 
X-Rspamd-Queue-Id: F3499180006
X-Rspamd-Server: rspam05
X-HE-Tag: 1777039163-54372
X-HE-Meta: U2FsdGVkX18qOydkvDLYv9sEqPFAYoDFf3KhbPM3q7ZeLc6t7eeJBPGMzLguXrXfiNzB4OVQmzWGYrr00VPLHqbPrK7Tdhg908HA4+PbI25VLbrUZfGjEn7Ln+Lq5pC2BfuYUf+s3ah8Cf10Un6rrYy++Umj3Na/cufcqSfKawcf9Viv/bmq/Gb+4U2J0C+XqmUVxNWSOcrAMk4uyWVd8Nha5U1/QjGyPEQhSV5EuuS/oiWG6KUhtBuwXixF6TSq1NN0gLlbS0+hWWD66/m+9RIaBAp00n6EWdYjaFGCW0aB2HIRImBNPMyVDTvwTPTNtscCpCxYswrLMqEYdtzhlbuMYlsy9wVNyzoT3km/MZsicFt21tFmlizs5xmsXTQbH5nz1tS+IuWhPIizcZao7ZGghEFkP6UX7wQ2/f0Vk6iA/FuGfQShR9MXoR7HWyPHDoqiWujIW+PYC5MZz+yqWtAOdh5fCbQlz81VrFmSSLif7vP4gmi2sFn9LK9i/y/u47z5Ojp5Z4dmJeEvYVEeZc3LUPC7QhAPYjZDMrcwb5qMorRojr2QPhs+DldObC1GD8sHhsSTQTsES3DiFggAa2FIYIlHoRg8xF+IoMS8nls3V9JUwO4Q9Y9heNKDWwCIiHGlSkHQ+bhf6C9t/q4pEl+l2fJsZTSDO2X+QSGnCe9pYRaAbHBNlUROlOIy5pPhq4SXyTFMgv2m2yr+Of1YyI5NBgGtLDIcrX+HtWND4WTTkWsQZ8LfKLXl2P9+1I5+uIa8vEeJBzZjbnYt0pHmwe+wIw1ZiSd//vjIPCP7N8j5dDdAABupqOS10YcNrcP2r9RMT2UgfFwCGfCjGqAY7SiWvCGlIyI7nTSUuBGTnBAP/qqlpO98H5LdKXcdpRa44DA6odSBHdLfxVM0gTJd7/Gqt/2g0KK2DNwW5jN1yr1cajINAjMjaQrGMLY+XYkCjLq+PsqFk31FiUipR4q
 Q3gjSIQz
 W8oyYi5qIUrB1mqLDwaRERnE+a2/gTnGTrM+m2voNIHCvNyeWcsYeWVC/TtvbifGYgmtOe6IxPs/APhPblmgozk/lXQ5V/JfuWlhhCGuhWhoIyLlOS9tuL7Y61C0+6ohZMMgKx5rXrLced81JqU7mPbg+AONtZDmlzYEOb2X18bXk5aH3nYfuBJmbhK0wRrdUIcoUnJZFRXpe4MxFk9Tj8P3K3tDWlzU5roIDmHgDd6HOcEP9uOZSfXNdPIJZtlfZA6RUMyup41TeK/l5oan3e6l/ks+RQ2r/uFEAiAcg9bZKmBkylYPan+emFsL6kHk3NOzrTY5d6DlwBxL4kNB0ECInaK11+YjiEPti6Q6NDJ+JXK5dNxPf575befRZb2CVH1bZr35YHogZtGz+pfAmXWg+k6svGiyExt30sOBpVW0zkBCvXYL50Bt22jqmoSYgD2sX+84Bykm3nsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 23:17:43 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:

> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
> 
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
> 
> Refactor the PMD checks, making the control flow
> clearer and avoiding duplicate condition checks.

AI review might have found a bug in the surrounding code:
	https://sashiko.dev/#/patchset/20260419174747.10701-1-nueralspacetech@gmail.com

