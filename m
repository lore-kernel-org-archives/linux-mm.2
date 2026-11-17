Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14AC606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=L4X/7pi/
Received: by kanga.kvack.org (Postfix)
	id BCD1B6B05CE; Tue, 17 Nov 2026 02:08:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4F56B05CF; Tue, 17 Nov 2026 02:08:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB7A6B05D1; Tue, 17 Nov 2026 02:08:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 920646B05CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:08:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FAC11C1197
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:08:31 +0000 (UTC)
X-FDA: 85443732822.16.9033A1B
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf13.hostedemail.com (Postfix) with ESMTP id 88EE720006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:08:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="L4X/7pi/";
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOa3RtnmIODQAIOd/ZqlGYqJucQki9cfsWeLmMaO4dU=;
	b=U4btME8nlnlhQJ1DdRVWGw2M66etVIV5oCuQgLLyfO1eSHqMP1qoojEoxscnShqV08hQ3P
	tXl6sys6eEAOc3mXHXnV07C6SntXfcmDC2uPWZXCe0UK1dHHjlaIeiKtajgaPQQZSVd/0r
	1+8Vcknt1ex6pDmDuegcwntNQsKipwY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899309;
	b=ocl7z+Y9DMq/HBoPt73zJkkjyWYyCV534RDFy3ADYQTwBdjcal5h47LE7X/dnlG3y59JJt
	A8yjHY3E30cKaGg30H49qKJ+a0U5Rzwb0Ik+DdhwMk3IDmtggRGlpzLSXcBuIJ/MYFB0DD
	cFz9T5eT041faKd/2lwRD0/A9u265PY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="L4X/7pi/";
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rOa3RtnmIODQAIOd/ZqlGYqJucQki9cfsWeLmMaO4dU=;
	b=L4X/7pi/hKgrcWH+r2Lyz2K5fDr6oemmr9Vqo/mlPjixIKI0SaWd02EkAFwLiATXCcyx1b0Xd
	SD4a44BotoB4mvpr9tipicm36JCDbfzpc2xS5upFF+YfPk1QhGsg2JAQ+C8ME4u4aQkhKCrxCFx
	b96PIsaaZyFGx0HZvwo6Js4=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jTG5y5hW3zKmT8;
	Tue, 17 Nov 2026 15:08:06 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 72C8D4055B;
	Tue, 17 Nov 2026 15:08:20 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 17 Nov
 2026 15:08:18 +0800
Message-ID: <ece02e4c-f87e-48ca-a653-cd02ca74eaba@huawei.com>
Date: Tue, 17 Nov 2026 15:08:18 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
To: "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>
CC: <kees@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <shuah@kernel.org>, <brauner@kernel.org>,
	<alexjlzheng@tencent.com>, <jannh@google.com>, <jaime.saguillo@gmail.com>,
	<elver@google.com>, <blbllhy@gmail.com>, <bvanassche@acm.org>,
	<pjw@kernel.org>, <broonie@kernel.org>, <debug@rivosinc.com>,
	<tglx@kernel.org>, <aleksey.oladko@virtuozzo.com>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <morgan@kernel.org>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com>
 <atjN3JX7sWx9kpQ5@hallyn.com> <avHfm5/mVtuN/oPW@hallyn.com>
 <avIKUzCKAkfC-wuk@redhat.com> <avIVCf1ok6Xyfii0@hallyn.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <avIVCf1ok6Xyfii0@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: 9m91michsjghs6sizh67a3uhigegpqgs
X-Rspam-User: 
X-Rspamd-Queue-Id: 88EE720006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794899308-260435
X-HE-Meta: U2FsdGVkX1/c6jlzt/rgQEEgdHcp/kFjG7IE62Xtjk07Qg7sMEai1VaNlZYb/EqVMrDCV1u40KD4kEJrpM0epoqJBADTJSkGXVa9SjIt9Wxp1oo6FXyAXXikaBAzBFysfbWQqDg/3ct4DrE0INtw4CkYv53IQ0dv7ArktLpocqF+yJ6DM7rZ0qD3yUxZ3X1tfV7Rf805f3ZioO5GCCT3mjsNbo0RTNoxu2TcKAc9tBVY/f/sNWdS1A68fPqSOst537NYz2A909HSVYU158PlDUmJP/0iNJpQm0lgP37ks/CzTpAA8XRPWypyiqW5Wo+8cjrXUoT++iPxFt04MEneCHVsCntdct3KbmPUOquoYRZSnKwY4Bzac4lPRNRYprYrlq/W2rCIu5HNTtpQ/jvWgIwues6CBHZrqJmsqkFJ/ap1+i0Pcum7xRm1Y88DlOO1KcDTqc0P3g89gC7ckk1H2EdS4uZGkDs3Eyldp2dskDsa/owjSkQZpoK0TrzRbnEP4D2Z7kun2Ph193ayNdgNJVnyEAp+pff15l29q08lhqrPd0alN+7Ob9mopIF/T+ATGQee1uN4D+CaVgVKC4IaX3AEnZ8NKohAK5Wz1bVk5vK9l5JftFIFBFKgQTuai1DTR/Vf9ymIVI4MyGKyXJcvniXdpCRXoEmQjaR/rCeEG/4iv+MozTHX3tQO57F7QpkfYb9+2MMUfENfMEqtCVJ9zlOyJIuQZ/0ufoGDoq431Po4X9BP5id0K34bRK7md7tddSZzxf/omELHdHE1Uv9Bf6fQWN7PqUJbOMPxf8+Sc3TMDm7S1GKJlNz6JZY1Tsw9i1Qsxjt+D8U/T4wADaiA9YzD8EFfzoshZV9RdGtrNihTiIlFEnkHFT7BefGiTLtw9h+MLKwVjxP0WfEa5VaCniUj84Q6SJupYEKcCkNo2c/QaiVk6n7LIA94CpgmAwCzgHuzkYDugw3TyZG3aRq
 lV+wQfoL
 54ou8kymbeCca1gc9T0EbRBKIwImNCTd1Pe4DonLL0tqMt75QXgrWPwfCzKgL+Ns5WI9MpiF6HKxQbnUgD7bx9nOvPQ754DAhRKzl0wguqZXy3m7/AZv2Cv/YAjSTREPJx0VNnQDt2AHsh0LikeQAlzG3jdlG+VCZXUryefC4Ye/hQvltbLU2kEDHLmGytuCyk0fTh1TfvUz9fQvA89ma6Tpt5YNmk9pfzexeEsSIAKa3FCVb4XQRIsdNhTRCbctaFZPNqxzHx5GC7l2SmsU4X065WF0OvZiPoheqqblaBgcERv/RJd3cj2SPYfQfudB3Vi+5MFEkESOhD65TTE3YrZQUJA8wFnZVjEcuAHf+VQavMVbwKPK5cfdzkkBEmvSVOWVSutR/tfyEbdgtj1Af3KszsRwds0exixJ7Uozu+pgsMqqfL1bSjazkij+enazzT04rvA6ld/OltZMw/Qd16S5bTd9OFzqQbctzM0lPaNYGk95KrO1GosetIuBDgHTq/DkimWuuWzLLXtkSIbqvExBZ1fSL0cbQ+F6Oa4E7xGgFgX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/10 2:46, Serge E. Hallyn 写道:
> On Mon, Nov 09, 2026 at 07:00:51PM +0100, Oleg Nesterov wrote:
>> On 11/09, Serge E. Hallyn wrote:
>>>
>>> Hi Oleg,
>>>
>>> please see below.  Do you have any issues with this use of sighand?
>>
>> Hi Serge,
>>
>> I already tried to look at this patch, but sorry, can't really comment.
>>
>> I'll try to take another look, but can't promise much, I don't understand
>> the problem space (I could never reallly understand capabilites in details).
> 
> Thanks.  I'm mainly wondering about the storing of this pending capability
> bounding mask in signal_struct, whether that might have any unexpected

Hi Serge,

rlimit is also placed inside the signal struct to implement
process-level restrictions.

I think the different lifetimes of cred and signal struct might be an
issue, but since drop only decreases and never increases, the result
seen by the user will only be stricter.

Link: https://lwn.net/Articles/103658/
Link:
https://github.com/torvalds/linux/commit/31180071ee5e6cc6ff4d036d655c556f582f74e4

Best regards,
Jinjie

> side effects.


