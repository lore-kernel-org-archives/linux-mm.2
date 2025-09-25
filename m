Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA5ACAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 23:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6208E0002; Thu, 25 Sep 2025 19:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E268E0001; Thu, 25 Sep 2025 19:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB188E0002; Thu, 25 Sep 2025 19:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2458E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:12:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3994D140535
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:12:41 +0000 (UTC)
X-FDA: 83929324122.15.A7D965E
Received: from techbitestudio.com (techbitestudio.com [75.119.147.106])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3EB1E80006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:12:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b="jLwc/RBl";
	spf=pass (imf02.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in;
	dmarc=pass (policy=none) header.from=kenip.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758841959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEBQ6/ELXJAZ5se7bttErxxgSS3XE9f2oCgj3uJWK9Q=;
	b=d3g8+NXtHdhpOpv3HOE7wIsH5GwCFlzrVoNKnHSMU+T19DQXfCspMeafpjm2+fIwS/yheT
	6bb9foAcKUTKOtRtzxxPTNS5EI+3na3teMVCsw6VTsKa0kd6xHKcFQ0WhXMBUCehpL5UC8
	EcZjrUb7zxpzK/KTEZU5qvAumjPHiGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758841959; a=rsa-sha256;
	cv=none;
	b=D1W73NIsaXgpDU1L3Bshs4sTydvjFKJI/nbABzS5WHRhrvHTsjYZAMzfQA2Yw0S28Rj1gB
	ZZGIKcTkNgMjzVXtuX+N7HHydtJJuGekqgain99Ny9AuR1+opCzUECAGQFQD0KxE60Syir
	4JS0owBGcvZi3UEBe8nmKe73uyUO62c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b="jLwc/RBl";
	spf=pass (imf02.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in;
	dmarc=pass (policy=none) header.from=kenip.in
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kenip.in;
	 s=mail; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QEBQ6/ELXJAZ5se7bttErxxgSS3XE9f2oCgj3uJWK9Q=; b=jLwc/RBlIGMjCUKXSYtij8XtIY
	e5JM18p5x2L82WCaziPMBKygTR99VQPapsnQel4sAd/awFCKbzdOyAso2WqgN6FxrRS/cEbeKmdh3
	kciNn2Wlxpe4yT1auoWbKQV8Amo2jiopbCR/ekBsHV3TCAp/U2ChwgkSnYCoY3NHi3+I=;
Received: from localhost ([127.0.0.1] helo=kenip.in)
	by techbitestudio.com with esmtpa (Exim 4.93)
	(envelope-from <siddhartha@kenip.in>)
	id 1v1v8b-0003rl-2B; Fri, 26 Sep 2025 04:42:33 +0530
MIME-Version: 1.0
Date: Fri, 26 Sep 2025 04:42:32 +0530
From: siddhartha@kenip.in
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, linux-mm@kvack.org, krill.shutemov@linux.intel.com
Subject: Re: [PATCH follow-up] mm/thp: Requesting status update on alignment
 performance configuration
In-Reply-To: <3bab750b-0aa5-4df5-9be1-9132c7980f2b@suse.cz>
References: <e3d003e7d0b7a5b0840f08cd7d630fe4@kenip.in>
 <595a57cd68463194fb2d6f34e9366e38@vger.kernel.org>
 <0197c80c5bc7989b858b79317a4fbc45@kenip.in>
 <4ffd8306e524480d6dccca2bd9981091@linux.intel.com>
 <3bab750b-0aa5-4df5-9be1-9132c7980f2b@suse.cz>
Message-ID: <3570b4b8e8df18f33d622552f11f346d@kenip.in>
X-Sender: siddhartha@kenip.in
X-Priority: 1 (Highest)
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EB1E80006
X-Stat-Signature: jk5bo3fwd48t6hh8rz3y7x1rd8tkpkgr
X-Rspam-User: 
X-HE-Tag: 1758841959-386021
X-HE-Meta: U2FsdGVkX1+m5Z60KC78pbI8YeSycCB5Y78UXhEZ3ZlYP7/vXI3FgTpUHYgqbzKLni438wGDnP/o/Bp0gS5QJc8967czm8xhjr8G/FoEmfOVaMRJ/XxF2cb+Izzx9h+nmjYPa8u2udvka1lIu/yJ9SecRVWdxQGv3DeF7dUKbdQCgnfy33SUedtwGeEg0dr4BygcjdsZaB1imogzs6MuHyGetvYQiRtxVoIQH+272FfaTAlxhrUkw+fF/9J9+z/3b5j6sG+IFrS/KgXtz1umkS4zmNnZXS9WQLt+Pu3UbC0KaolJGpZEK5S1XNcWlW+4RG/FdZZefpy/lGKM3nnNIdD5LKOUJoVCFEU1SL3wm+O7kgVjZDgClO8aXwkZBO0Q/3ZCm0w9WQGuF91SCb83R+iAQv+TSIkTqAjx9L+xYFeKyLZpaAjMKTSIE4IZ6/OVbKF5mbwFdR3GKv/Zznll9TANk6hL6Mxo4srQFg7qLciQtclCbNRcjWZ8rEVmu61GRvTktpObUZq0hKzIxVPt21PrxjLHL2jf60ViRJVXWZSYgRFO6oGLwkY395zmc283va4ktjir0UdGLulQS+lL3Urz5KJv8BGt2MO+aJMRrM8UCn0+8XOH7F7rEkg3PJjsqeR/80yr7CDZ3StjsGJr6zzd+DTxTg7d15U21/pIA5X7KP0hPERnplhwn7zX1miKnfDXxdzwFyugH/2ue1EY4q4cZ29/5j9MfRUBGClAH9ZwKflK+FmlWp+w7omLPgYzh8sqLrQtNCIoP+z3o4WnKckJa79u3HCr+YdD6V6SCBD/sw42eJVjYOKtVP6K/vEaMzVA9D5ZLInn1HTVypb9W/BJq1AVWk1VKfhdqsRd6xnsobCOToQZpPCCC1S8bdf0/YkyIxZLn5AY1MQ+JJZp7Qq5S0626iY4GB04huK3u7c4ZbFM/ePZ7xYx4l0bCpem7hfdDC7G+5+jmq/qJqF
 qgXEpPA8
 EpIIIMCaTtfRv3r3GgbacO0vDilGIQklejCZbOoGGDJx/zzx1YR+XKS0VK+WtistUYZUfa9LSeh4NVK9kCnLZafg5yYS1Pmvtylf+FrKrCBhBdDhnMZgGHg0ddeJu3N/JHAX9At0zmW8kH4qeWxSPunsquTWZi3efXklFugYH0JEAWDCyAukdFw/0z67swqPqoKbhwShJHMg/xk1zd09bbGdjBHgeQWqX+v5rt5AHVByC84anxSp9Od2W5CSSsZ4RAgltI3irxwmFaGCV3JJ1yseMnw1476GQapTKtdAcqMW0jgrz0CU0AUiAvxZ9A6YktvSlxHNElgvltRJUdFXnaXDYTZk4qqb9rzXfmSodt1G1u27zTyhNWgZR/zv7GOLxBYP1CRzk0M7Cr6x7Dw8NbMrQN2fShcRLeIvNHJKZcCy9zTm2CEK47IPaEwWx94DrviSoJ4QQDdwJ7HY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-26 00:16, Vlastimil Babka wrote:
> It's rude to send emails with "request read receipt". Lorenzo explained 
> that
> already in a response to your off-list e-mail week ago.
> 
> On 9/25/25 15:54, siddhartha@kenip.in wrote:
>> On 2025-09-02 18:38, siddhartha@kenip.in wrote:
>>> On 2025-08-12 05:20, siddhartha@kenip.in wrote:
>>>> On 2025-08-12 03:44, siddhartha@kenip.in wrote:
>>>>> On 2025-07-28 16:30, Vlastimil Babka wrote:
>>>> **Pseudo-diff of relevant changes:**
>>>> ```diff
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index abcd1234efgh..ijkl5678mnop 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -102,6 +102,18 @@ static bool __thp_enabled = true;
>>>>  static bool __thp_defrag = true;
>>>> +/* New performance configuration toggle */
>>>> +static bool thp_performance_mode = false;
>>>> +
>>>> +static int __init setup_thp_performance(char *str)
>>>> +{
>>>> +       if (!str)
>>>> +               return 0;
>>>> +       if (!strcmp(str, "on"))
>>>> +               thp_performance_mode = true;
>>>> +       return 1;
>>>> +}
>>>> +__setup("thp_performance=", setup_thp_performance);
>>>> 
>>>>  static inline bool transparent_hugepage_enabled(struct 
>>>> vm_area_struct
>>>> *vma)
>>>>  {
>>>> @@ -245,7 +257,12 @@ static bool hugepage_vma_check(struct
>>>> vm_area_struct *vma,
>>>>         /* Existing allocation checks */
>>>> -       if (khugepaged_always())
>>>> -               return true;
>>>> +       if (thp_performance_mode)
>>>> +               return true; /* Aggressively prefer THP in 
>>>> performance
>>>> mode */
>>>> +       if (khugepaged_always())
>>>> +               return true;
>>>> 
>>>>         /* Rest of allocation logic */
>>>>  }
>>>> 
>>>> Please Note:
>>>> 
>>>> This is a pseudo-diff since my initial work was developed on Intel
>>>> Developer Cloud workloads without a locally cloned copy of the exact
>>>> committed files.
>>>> 
>>>> If there’s interest, I can provide additional benchmark data and
>>>> extend the implementation to expose runtime toggling via
>>>> /sys/kernel/mm/transparent_hugepage/performance.
> 
> Sorry, it's necessary to send a real patch, not a pseudo-patch, 
> including
> the test results in its commit log.
>> I fully understand the complexities around VMA merging, Rik’s earlier
>> patch,
>> and possible regressions noted with cactusBSSN and ebizzy workloads.
>> However,
>> given the continued performance relevance to AI/ML inference 
>> pipelines,
>> I
>> believe further testing and validation would help determine whether 
>> this
>> knob
>> can be safely integrated (or adapted) for wider use.
>> 
>> Could you please share the **current status of testing or review** on
>> this patch?
> 
> We can't test or review a pseudo-patch. It's not even clear to me what 
> it's
> trying to achieve.
> 
>> If there are specific benchmarks, traces, or refinements needed from 
>> my
>> side, I
>> would be happy to assist in generating or providing them.
> 
> You said you saw improvements in some benchmarks, so re-evaluating them 
> on
> current mainline with a real patch would be the way.
> 
>> I greatly appreciate your time and guidance on moving this forward.
>> 
>> Thank you again for your support.
>> 
>> Best regards,
>> Siddhartha Sharma
>> siddhartha@kenip.in

Hello Vlastimil, Lorenzo, and all,

Thank you for your feedback — and apologies for the “read receipt” flag, 
I understand that was inappropriate for the list. My intention was only 
to ensure
my earlier follow-up wasn’t missed, not to be intrusive.

To clarify: my original emails tried to outline observed performance 
behavior when working with OpenVINO-based inference runs. The 
pseudo-diff I shared was
intended to explain the concept, but I now understand that without a 
proper patch against current mainline it’s not actionable for you to 
test or review.

I will rebase my changes onto current mainline and submit a real patch 
so it’s clear exactly what is being modified. That way, any evaluation 
can be based on
real code, not on assumptions or pseudo-code.

Thank you again for pointing this out — I appreciate your patience, and 
I’ll make sure the next iteration is a proper patch submission suitable 
for review.

I have opened a pull request in the openvino GitHub repository which I 
also shared earlier but the guy who is supposed to review it is on a 
sick leave, but I have seen some commits being merged recently so that's 
a good sign. As soon as that's done with the review and I get the 
developer cloud directory where it was originally worked upon, I will 
share all the necessary details and the actual code.

Thanks for your time and support, I really appreciate it!

Best regards,
Siddhartha Sharma



