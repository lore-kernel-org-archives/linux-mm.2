Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501A7606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=SJh5Z0og
Received: by kanga.kvack.org (Postfix)
	id 52CC06B05B5; Wed, 28 Oct 2026 22:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503F16B05B6; Wed, 28 Oct 2026 22:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD016B05B7; Wed, 28 Oct 2026 22:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 141CE6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:53:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93071C02B0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:53:07 +0000 (UTC)
X-FDA: 85374142014.01.AE97177
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68402180002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:53:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SJh5Z0og;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CbHfJZd9Ouin6+NJRHxk52K7pGc80VMx8HJ0a2GrKE=;
	b=095DWiRCwVtHSjlJURXQbeqJ0KfhpfTpOiDvB2hMCAEHYl1h/DmNAqsOUn71IJ9wod1KAx
	Zdh6NpQnqbaDiZ+43DKTR9VHvZR2yGu+zWWV2ngbLY9ilCU4r1cmiBaA3zNIt8oz7oSqGL
	fRi3Q0hFyDMPZ06iHGJFWYxXwlxe3Eg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242386;
	b=PngGd/3uM7JZuROybnC1kxptdGEBH+l8y/heroVNfi+UUYyQCwSCY3x93KIL+JCz+WQ4nu
	SLoK0sfCJBOZpfPf1KO+yonO5l2Chdk5z1EdpBoERwHbgRln9u5nB6/wi2l5NZzChMTQaL
	0sh2tmwxsPY8pv9Y6qyRr5woYuQRBjA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SJh5Z0og;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793242380; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0CbHfJZd9Ouin6+NJRHxk52K7pGc80VMx8HJ0a2GrKE=;
 b=SJh5Z0ogxzVgWC5Iq6gppdzxJz4Cx56PFP0+s6qEX0jb6ve0HdH2SrMhm2PMidCVMHB1H/
 Is4M+d6dO7JtVaEfHuOHcdEm6fTkGXvm0S113pETH4hyeWobCbwe8SeEAw82iCrHrTiA4v
 rQMUnTZH6f5CExCiKpKR+RJj2JpWPCaJ7IoAwvC15POKIbGHL3gXF/WZKFN8W3+zJHQiAe
 4yEXNbIQOcWi+UVV83y/1FnQhlv0dO6G9lixig834P+IeAcY/gC1wleoyj7gWsg+ojrNRV
 vKtJJOyjP9POXxDNacS6J6VEpEXodbgh/1S6HxMvJJCe9iTLJBQmMNTfgRpyZQ==
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-3-lizhe.67@bytedance.com> <CAN+CAwPM=-sRDypP0+ZxX8_CziBRjXbxKEE3UZGLzkmOWrajNg@mail.gmail.com>
In-Reply-To: <CAN+CAwPM=-sRDypP0+ZxX8_CziBRjXbxKEE3UZGLzkmOWrajNg@mail.gmail.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ae2b509+d51529+kvack.org+lizhe.67@bytedance.com>
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>
Date: Thu, 29 Oct 2026 10:52:35 +0800
Message-Id: <4c94b526-cacb-4b52-9c28-7344f8ab582f@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Cc: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>, 
	<dietmar.eggemann@arm.com>, <gourry@gourry.net>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 2/3] sched/numa: do not feed tiering promotions into task placement stats
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68402180002
X-Stat-Signature: 3t4ck7aojqtiqbn1ecytna6ze64zu75h
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793242385-404487
X-HE-Meta: U2FsdGVkX19Y6PKLVWgiNMvNi5wqtZZRyp2ggT3Lu9CnIbQjlC+N7Oz7BcgznXcVGPn8ASLRZyw8/DGTA1eGu6ry07F912fDRaTCPTRe8qlFZRdKGTW4lf1XIDKIu3TZpK+Hdd3kPg6QMVL9SiOvAVqt3sSwSt7AdYiBnwri/H1gTiZocFMRhhGFCOKBg+i6LTutn6mTMm1WtUPWIrRuzJVdTmg8AqbjLo1PsEG+LujW3evsAvG8GMyp+OMtVR346+x6ln65Mtiyt+biIxLxGjhaZ6c0LLQ2+A2cDmTQkYNKW8inG4HhGM81Q3l2d4Tk6U1GhHZs218C4sImi4mZ0rxqPazWl8VB6jl63LFNf4DjaXz+ZK0uvpYgHDamt4IUeEgfRYoKGCAGh9YX9AyIrvSPBf1bI7/de4blfGsVK/96Djrx7tAXtjO4riPC5frwXPk4H9wOHlG48QoSxKRfo2HAs4zMJFa/xt8ZRhduFekr+JE8ZTVMNeUNni5qwAo4xUzYj6f4xMTAEOvpxG6rNr/JKOl9UvkpklJURccn2ebv4ysOgqjp3U/3y3mSPbtzwqixHKcM0tYUvkJgX1r/H7NJ9wTmorAzMooXuZrcMDzXTZVeaRCb66i2UJB/L057ERJ5OqUWurIM2SHLQNIerBD2qkHgzloQm1E7Osbq4QqQbJLbL1EtnNBwmr024xyK9V4CYAoETBwiyfwHCGbg2DmfUta+2hmySkLJ4b4aZS1GTvu6lHN/3rrJ66Xtx4axgECvY2EWCnajkcUCV8fLkgODQj27IkwY58pAxuUdlzHStyl4z+TxImnsIH3DAMUoktJAswVHt84gxC8+AcFeC9TfAUhC2GRBEwBe6xzxFHe11l+ZG6pzpN99cV7d5ZeEwhV5WV6wOOYoNlriKBgeWhYLRPf4ebqlYQv/2qBuc17sckEgSqDgfoL9uycypGQDL6ILGKCeprcwHk+2kAU
 nWH2kZZ3
 ipOwriGpwmNdk2ZG1bjI9xpUryhZ96G64jO5QZOeRxQR0BmwWj57l7nP+iOwXZCZckBocP0OfIXCxm1kfbg53tGBquHaJbBTR37y8iV2J0dJf6hTIot01ay9qNzrJMCnLNH+Amsg6zKQtsv/j1xOfTpK3/eUgmnBzRtl/Fw8S8q69MgDFg0CWqJX1rvHp+Eeg6s0c36Jg3TtLfH8eSlP+9H+Jpv5e70pc+RDfpupPAlhWGLts5/bWxTmC/U2YaszlbdhNKVfxze8Zl8KSmLg5GP0B3grn1bIbAGt6oV+HrQBTFOD6ILsHC38Ru+Ay2V2M+5O8doIXCbC8uu0SDdpGxS85UebvLy8HKxrbbzTeJAO6dR+Xa9oXog1XeKFfUKdmiT/3KAJ942w7iB2uAoXFu47BkTiFiIefUEQz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 11:03 PM, Joshua Hahn wrote:
> On Wed, Oct 28, 2026 at 12:14=E2=80=AFAM Li Zhe <lizhe.67@bytedance.com> =
wrote:
>> NUMA balancing has separate mode bits for normal task placement and
>> memory tiering. In memory-tiering-only mode, NUMA hinting faults on
>> slow-tier pages are used to detect hot pages and promote them to a top
>> tier. They are not normal task-placement faults.
>>
>> For slow-tier folios, memory tiering reuses the folio last-cpupid field
>> to store access-time metadata. numa_migrate_check() therefore cannot
>> return a real cpupid for those faults. Before this change, it returned t=
he
>> same all-ones last_cpupid value that normal AutoNUMA uses for a first or
>> unknown access.
>>
>> That can make a memory-tiering-only promotion look like an ordinary firs=
t
>> private AutoNUMA fault. After a successful promotion, do_numa_page()
>> reports the target top-tier node to task_numa_fault(), so the existing
>> slow-node skip no longer applies. task_numa_fault() then accounts the
>> fault in p->numa_faults and p->numa_faults_locality, and
>> task_numa_placement() can consume that sample to update normal task
>> placement state even though normal NUMA balancing is disabled. In other
>> words, hot-page promotion feedback can leak into the CPU placement
>> heuristic.
> Hi Zhe,
>
> Thanks for the revision. To me, this looks more like a fix than an
> optimization, since there really is incorrect NUMA balancing behavior
> happening that could be visible in userspace (unintended
> task-placement and related accounting). On the other hand patch 3/3
> doesn't seem like a fix to me despite the name, since this one would
> mitigate the incorrect behavior.
>
> How about we pull this one out of the series and submit it
> independently with an appropriate Fixes: tag and cc:stable, and
> discuss 1 and 3 later on? Unfortunately this is also not a great time
> to submit new features or behaviors as we are in the middle of a large
> merge window, and there are a bunch of fixes that maintainers might be
> busy looking into : -(
>
> Regardless, thank you for the fix, Zhe! I don't have a strong
> preference on the ordering of this against pghot, but if other folks
> are concerned that this could create more churn, I think it would be
> reasonable to wait for patches 1 and 3 after we discuss with Bharata.
Thanks for the review.

Agreed, patch 2 is better framed as a fix.=C2=A0 I will check the exact
commit that introduced this path and can resend it separately with a
proper Fixes tag and Cc stable after rc1 is released.

For patches 1 and 3, I agree they are more about the tiering heuristic
and policy behavior.=C2=A0 I will keep them separate from the fix discussio=
n
and continue that part together with the pghot-related discussion.

Thanks,
Zhe
>
> I hope you have a great day : -)
> Joshua

