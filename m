Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7377E606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=SWxxW4lJ
Received: by kanga.kvack.org (Postfix)
	id 8E4F36B05B1; Thu, 29 Oct 2026 02:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895E96B05B2; Thu, 29 Oct 2026 02:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABBF6B05B3; Thu, 29 Oct 2026 02:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5453B6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:29:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE7511C0C74
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:29:43 +0000 (UTC)
X-FDA: 85374687846.08.403A2B7
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id CFA2EC0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:29:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SWxxW4lJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793255382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSpsxZ0UOcO2qaOwszBPuySwWt2HOSaZ4drFli6RZ2s=;
	b=PpLXC+Ju11bXHSDnBQt4mRhZ0Ytn2YUHjDz6U5kNmN6dNlUoYDoqxUQ69IV+XjVJQ+FRUj
	mjjleWKjbsJnyLPo4D/IhSrFWQTAmB2lvjKACtj74pXl/CmAD7kKvzc8jFsm8Qrhzy1HGl
	fHzES9lO03eoi3E6daHkq86Due8e/GQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SWxxW4lJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793255382;
	b=0Sr/kfgoQefxBucy9LLeszrV3IKWsFGVFhWKiDy3/9Ksd+JxiNTcRp4DBwBv0xbKZs0DTy
	0LZ5NRSj4btts2ai467NO/PXsk3+kcPafCgTCHkdmr4zQlu8pbgG+XTpcOidBPh/p+Q5V3
	/nGWShsXtwh7MTen4OcXfhol9IBIGiU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793255370; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=LSpsxZ0UOcO2qaOwszBPuySwWt2HOSaZ4drFli6RZ2s=;
 b=SWxxW4lJrbz9WGHaQQdDbYHk6CtxBs6AVHOz/tfi967QnVoYvku5CKRTq54q2NSpdK8rJx
 uvu0Rc7nEysZMOx5g0C+1U1ebXLucQUGHXl1EgAHY8dTj0OalC/HpdiOHdeYCsJWCRi1Gl
 7LZh2HJt/8lQuq+o8pHwEpBh6chveJffti88zP6UrHdDCW9mjVZamxDVDe1ibtXPmpFqPT
 yCftoUXDipbE/JaMD9KdukA0iulVxd7xYP685DHWq/XzPJeb9uLe/njzxJOVFBUPNbwklS
 I4y86nRxP5nB/cpMy8fW9n2hhjFv/OmtDAtAhIFixdlHni0O4TdLRAKmFuZWHg==
Date: Thu, 29 Oct 2026 14:29:02 +0800
In-Reply-To: <8d6f589c-4427-465d-be5a-17eb99f41a91@amd.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ae2e7c8+858c61+kvack.org+lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-3-lizhe.67@bytedance.com> <CAN+CAwPM=-sRDypP0+ZxX8_CziBRjXbxKEE3UZGLzkmOWrajNg@mail.gmail.com> <8d6f589c-4427-465d-be5a-17eb99f41a91@amd.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "Bharata B Rao" <bharata@amd.com>, 
	"Joshua Hahn" <joshua.hahnjy@gmail.com>
Cc: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>, 
	<dietmar.eggemann@arm.com>, <gourry@gourry.net>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <rostedt@goodmis.org>, 
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <ziy@nvidia.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>,  "Huang,  Ying" <ying.huang@linux.alibaba.com>, 
	<riel@surriel.com>
Subject: Re: [PATCH v2 2/3] sched/numa: do not feed tiering promotions into task placement stats
Message-Id: <49e49011-45c1-4eef-84fa-96bd2de701c9@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: CFA2EC0003
X-Rspam-User: 
X-Stat-Signature: 9ezywnx8epj8ka635z7r4sernu1f51d8
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793255380-938924
X-HE-Meta: U2FsdGVkX19afEiHYkVIPGFmW/xhTDww6dN5K4ql1a8mAiLkT0mqj07M9Mi4wlDoNXOF/teprWrpkG9a08ma2l4scmkfMCr5Xy5Mv41NobNoJJFNGA8dE1YBbaDYlrPIHq+FM5nBAw13xsGgBu0dcBayqf78df3wg8MvXdlRXxfeWw0c9j4AnQmBi+I5Dq0qVz3EOhK8nwKW1irjPCpWKVzyuIYY4+6ELXX6fxHc/1e5yZnorq5R2fjuZPa4PruImsYBifWK8EOG7erwIk9u2U02Y9Oy+HOm6CYgyH/+Zs98rryK1SC1++V7maJ+c3NAUHjwyaa9ccXr3qJeRUkhoxRU/SSrEcKJ0FAhXmB20KqV3vrflBVdiY01C8tQce/MuBEBjQfhb04mTWt7lyrtPpSm4RDs20lF1ub1r51XC6kUxGr/Fy9yZ1yQ008Qq2KR5xJeCxtFsNcYOr2SHWwzw/YBNcprWl2CSbfgsHHEz9etPj3x03ku9H1nmK1xccL509+x/LL3IsLN0O/IwnUaypcrDUHXHK8iNFA57AsYKH5ZuCAvFMyjjSZwNzVQfZWf9Crhk4Mvwi+msnuhos/fSy0iztNtm3sTsSblQz93iXVNodwRl4PEjNHTotRW3JS7BF8FgIxfCel1gIqw8eLuTXS02NhCN429JtbJd8+ujNQ2JCmsBp0xT+Og4F+69pIOLbvI7C6524cj7V7+cKTqstdEMJGxPkZIfsph+Ic9C3xubXL+jJBjBssSZ4D26fPn8+NGEMbaQbdRgWlOdwzNKLQZqm9Vz8rlCHHYt13FqecXOkYNjggfaEGTbwUgYrvXuub2NpJ4jq6uan8vNY0LLJDdt9kwm0lks0uJ1xQHgwoQlQzOgVwxgICozEi/MYosBggqQ9Y+If2n0//lSxB8xWL0+Ql4EbhecOsJjp/z6IDSNizvWJCG3TGaemL6FY5gs/TyZdmF1EweEhXvhGR
 Ls6+3q2r
 jtBfl9xQxQZUg2Q7MoVi38UgRgfM4tGJjelnACww8S2/sMuFmYONWe5/9N8GQhqD/ufSOTHJ8HACxiKLlymgnZKnB/z3jDUqkkIXxiH/jLk7UKzkRf/bGBz1OVt2UEQxDNFx+B54pWOax5DUxf4UVWW8/76zaZW9mv655bPMuUq4iz9yNcveXMVh2AMRu1LEoBhUGK8pqdMiMx8iJMeJLzkTut7dfn+33SuQBDb4E2Y28eafVe0YlvI1vcr7KASiL1X58FbIpfC8JOFZhV5Ajlf1A/hYyYLab1HbWwmb6asyO7pUUD35qu5i0GFyWap16+1zw853Z7c5snJE3X4qGhZAZ/RPk6dm1W6NdpgjxZQlNOXOAgmfwNBOdKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 1:51 PM, Bharata B Rao wrote:
> On 28-Oct-26 8:33 PM, Joshua Hahn wrote:
>> On Wed, Oct 28, 2026 at 12:14=E2=80=AFAM Li Zhe <lizhe.67@bytedance.com>=
 wrote:
>>> NUMA balancing has separate mode bits for normal task placement and
>>> memory tiering. In memory-tiering-only mode, NUMA hinting faults on
>>> slow-tier pages are used to detect hot pages and promote them to a top
>>> tier. They are not normal task-placement faults.
>>>
>>> For slow-tier folios, memory tiering reuses the folio last-cpupid field
>>> to store access-time metadata. numa_migrate_check() therefore cannot
>>> return a real cpupid for those faults. Before this change, it returned =
the
>>> same all-ones last_cpupid value that normal AutoNUMA uses for a first o=
r
>>> unknown access.
>>>
>>> That can make a memory-tiering-only promotion look like an ordinary fir=
st
>>> private AutoNUMA fault. After a successful promotion, do_numa_page()
>>> reports the target top-tier node to task_numa_fault(), so the existing
>>> slow-node skip no longer applies. task_numa_fault() then accounts the
>>> fault in p->numa_faults and p->numa_faults_locality, and
>>> task_numa_placement() can consume that sample to update normal task
>>> placement state even though normal NUMA balancing is disabled. In other
>>> words, hot-page promotion feedback can leak into the CPU placement
>>> heuristic.
>> Hi Zhe,
>>
>> Thanks for the revision. To me, this looks more like a fix than an
>> optimization, since there really is incorrect NUMA balancing behavior
>> happening that could be visible in userspace (unintended
>> task-placement and related accounting). On the other hand patch 3/3
>> doesn't seem like a fix to me despite the name, since this one would
>> mitigate the incorrect behavior.
>>
>> How about we pull this one out of the series and submit it
>> independently with an appropriate Fixes: tag and cc:stable, and
>> discuss 1 and 3 later on?
> Currently only successful promotions feed stats to scan period update.
> This change stops that and nothing updates the scan period for tiering
> mode after this change.
>
> Though the direction of the fix is right, I think this can't be an
> independent fix until there is some alternative which patch 3 in this
> series brings in.
Agreed, thanks for pointing this out.=C2=A0 Patch 2 should not be sent as a
standalone fix without the replacement scan-period feedback path.

Thanks,
Zhe

>
> Also it would be good to get a view from Ying Huang as to why only
> successful promotions drove the fault stats while unsuccessful promotions
> didn't in the tiering mode.
>
> Regards,
> Bharata.

