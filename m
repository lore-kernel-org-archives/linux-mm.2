Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB82CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0426B0088; Wed, 30 Sep 2026 07:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91286B008A; Wed, 30 Sep 2026 07:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D803D6B0093; Wed, 30 Sep 2026 07:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFB8B6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:52:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38A841A076D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:52:41 +0000 (UTC)
X-FDA: 85270266522.26.FA58EEB
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F116100005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:52:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Z+55iLEp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790769159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2He0n5DmuqJPogb7cosTA7pj5eK80oWxnlE2Q9AaOE=;
	b=Kx8cS7UsuBsSS5NS7vtmXni6OujxYLujugnOWPOLvEIZsmDkmklUhfWta3w1IBUd0UhNqS
	WAivjBlDr2szLH9hXWsvHZBCM3m/WtJCNkTMX6IDkW2Mzg7DhNUcDiTVfwShDFN9WSnSDk
	rR258rQrTUu6FhYZMNXjCmV3eV8kCYU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Z+55iLEp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790769159;
	b=jy6TBRqRNeohSA5d3p4WSD7dxe7S3LhyQRBIidGCITbAq8EoG7cU/D7MJh3ASgGAIn+Bty
	/PeyIb3z52lddbZQ+TLSiH1xmjDG9U0dVFDbMx8Q8BOuL51XT7wIg7XkTloQ3uUK5kOM0X
	ekAUwzWZ8OtzirQw0J7SKwuCet7N4I0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790769152; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=u2He0n5DmuqJPogb7cosTA7pj5eK80oWxnlE2Q9AaOE=;
 b=Z+55iLEp3mxL2ee/IvLxCxHeLFI8RvH/ysXIPUaGd2Kd9Dcpt9fXa1wRXAyKX68Vq67HfK
 amy5RuT+qeimZTXyMAfrd1G3STZA+U/gU2aIfcp6WZZNmp/obRbU8+7lQoFir0id8J7ada
 8wYh4EQYYFC+ANRGpUMBSQXjlpQdzmU/lqEdCn+RRLIUIBtj8d4jFjjKwIxAQ+LJF7ZeQz
 eEOk17wLG/isei33i7IiXqRRJj6SRnAmkS+/JNOo3G4QcEyNvBagwO2EojZauJqLvebaJ9
 NkInWiNE5cRo3+h4HEKfjAFwIlg0FF+2nems48xs556QjejeL+e99dz9Gtuu3w==
Date: Wed, 30 Sep 2026 19:52:05 +0800
Content-Transfer-Encoding: quoted-printable
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
X-Lms-Return-Path: <lba+26abcf7fe+539f3e+kvack.org+lizhe.67@bytedance.com>
References: <20260930072617.64665-1-lizhe.67@bytedance.com> <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
In-Reply-To: <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>, 
	<skhan@linuxfoundation.org>, <ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, 
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, 
	<apopple@nvidia.com>
Message-Id: <808292b4-841c-45bd-aacd-b487be1858ca@bytedance.com>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: cr4hr8awzr6tdyea5tn5af4ooxwd7ns4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F116100005
X-HE-Tag: 1790769157-187128
X-HE-Meta: U2FsdGVkX19CDcOl8YKGteZ4gsI2N+Z07k+L9f/wZxsmuuZKU0cIzPL0BASmP8ZfUXkdWjU5EPvZHKNk95g3SG4qtiP95fFyJw+c5TY0gVPrn5weB2jS8hKbYPJDEs/NDfO49JEFfk5JcD5eC9nX0r5Dy6BrJLq/qDzM4RmFkmKxP6KyeQKnNIyVOaNMfVE65lLZMmohpk6CPPwHMvALyioOdHO6KuYF/tYLwj7uuG1IEfI6HkSNWFUJwepDXJso417n30h/1+/PPM3G/1LOFJiShZPvQ6eKtXTOkyqa3PpBPluoLfv6O2kp6lHnHFGvE6k/aj7lMRPvHRIGEjZjI9WKPO4vJHnbQo+y1ASd4EOxnjKWtacWPbMdj822d/mDzRhP2SCpYiEVHF03jNghG4ZpwWZDpHV48MCQG3RJA8dyTKsYInrsUvp+XQtD1Q6Fiw8zFyFFRtrkcPYUi1i2+qpoCqBF03fT3Z03at8hRhkCgixxKmdhWkxnpodKahnmseL5PtDlPyzdh0ttP4evYpufZXrvww+5hxTriy8X+QwmOLIlOJNaQAdgu1uFA8WqRiBUhjhhSt4JdSeh+n82Cdyv0PMWUTRb31rGusjTOkIMzw8x6/lhAqZMIdzNbCkCjbeTQabTfxgto92BH7tCzztKmphnCGLLUVdPS8iXYrf2PIdzC5nDHvtEiZejEJcm62+hiZftIqEjFtzGY84m4fQ66i6txFHlVpqnxC0H6HKz/dYdcVJX1NoxyCGQxzVBXt72TB8W+DIMU9QSO/VGERHWcnWZgY3VqO/RM9tztNzrRWKXCtX4cBedSfkFOFNmhRJHCr/pgzcALlJ8Xv93GisXUM7kZ3lZGs94/Re4mzX/99o0oApMIGvGOlrH6imWhQDYV0IB7QzPhgpazWlyHkYDPoqJTYKLEyPKnY7CEKuptcEghR7/LDN/R0pby5G4cMYyrsPmu2VBnJM1l98
 /qsql6LI
 INjui4SueeJxxz1d0VAJvAtH2ZLYPC3nPwWWPv1q2BMb3HTFpHVAuYD5N29eeYHHxeDtwUDcC15xH16PMJC4yfsh5jY4/GZWsqS5o10fDZtBTu7bc3ORJC6DH3f/5RwDVnm3sia6dYFaBil1BNqOE6hQJnfwxA5gGFBny/0OnRXbJhZ/VhC3YbBCargBcHHW+E30ootlmhzj8XCu6hYmrRbDSCDWs874IWt+vOuvy5xuCDWAiQrk2dQ3onnWv6xj1jb1sYp3OFo5J/4A/y5LKb57R5QC9+tmC1CTTTUYTWZhCbQ57bmIE/3PXlKEcqo4qCfV+1CLYrZkV8iA7eDttbJDJ0Tfzm13FrUDe3I+W10okwJzVpNet5kyUlg3epwd6xsJS6B7M0AKv0RDG+igr9uEv9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 7:26 PM, David Hildenbrand (Arm) wrote:
> On 9/30/26 09:26, Li Zhe wrote:
>> MPOL_WEIGHTED_INTERLEAVE is useful on tiered-memory systems because it
>> can seed a workload's new allocations across fast memory and slower
>> capacity memory according to a configured ratio.
>>
>> That initial placement is useful for workload managers and orchestration
>> systems.  They can take the amount of fast memory and slower capacity
>> memory on a machine into account before starting a workload, and choose =
a
>> weighted policy that seeds the workload across the tiers at allocation
>> time.  This avoids starting from an all-fast or all-slow placement and
>> then relying on promotion or demotion to reshape a large working set.
>>
>> After those pages have been placed, however, the policy cannot currently
>> opt in to migrate-on-fault placement.  set_mempolicy() and mbind()
>> reject MPOL_WEIGHTED_INTERLEAVE when MPOL_F_NUMA_BALANCING is specified,
>> so memory tiering cannot promote hot pages that were initially placed on
>> the slower nodes by the weighted policy.
>>
>> Initial placement is only a starting point.  Pages initially allocated o=
n
>> fast memory are not necessarily the long-term hot pages, and pages
>> initially allocated on slower memory may become hot as the workload's ho=
t
>> set changes.  The policy therefore needs to be able to combine weighted
>> initial placement with memory tiering's NUMA fault based hot-page
>> promotion.
> Ok, so memory allocation will respect the weights but balancing will igno=
re
> them? That really sounds rather odd to me.
>
> And I assume that was the reason why we might have disallowed the combina=
tion:
> it turns a weighted mechanism into an unweighted mechanism.
>
> So are we really sure these semantics that you would essentially set in s=
tone
> here are the semantics we want? (ignoring weights)
Yes, that is a fair concern. It does look odd if the weights are
interpreted as a hard resident placement ratio.

My understanding of the existing MPOL_WEIGHTED_INTERLEAVE ABI is that
the weights are allocation weights, not a long-term resident ratio. The
sysfs ABI documentation says that these weights only affect new
allocations, and that changing them at runtime will not migrate already
allocated pages.=C2=A0 The implementation also has normal allocation fallba=
ck
if the selected weighted target cannot satisfy the allocation.

The use case here follows that interpretation.=C2=A0 The weights are used t=
o
seed the initial placement across memory tiers.=C2=A0 After that, with an
explicit MPOL_F_NUMA_BALANCING opt-in, memory tiering would promote hot
pages based on access patterns, not based on the original allocation
ratio.=C2=A0 Users that want weighted allocation without that behavior woul=
d
keep using MPOL_WEIGHTED_INTERLEAVE without MPOL_F_NUMA_BALANCING.

That said, I agree that allowing this flag combination would set the
semantics for it.=C2=A0 If reusing MPOL_F_NUMA_BALANCING for this is too
ambiguous, do you think we should model this as a separate opt-in ABI
for "weighted initial placement plus access-based balancing" instead?
For example, a separate flag or policy mode would make it clearer that
the weights are not intended to constrain migrate-on-fault placement.

If the allocation-only interpretation of the weights is acceptable, I
can make it explicit in the commit message and documentation in v2.
Otherwise I would appreciate your suggestion on the preferred interface.

Thanks,
Zhe

