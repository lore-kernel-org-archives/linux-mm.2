Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B5ECA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCD86B0136; Fri, 15 Aug 2025 13:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACB66B0138; Fri, 15 Aug 2025 13:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574716B0139; Fri, 15 Aug 2025 13:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 422026B0136
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:30:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E05B4140180
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:30:32 +0000 (UTC)
X-FDA: 83779681104.05.C35DDCC
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 15A664000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:30:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PaR9LgCR;
	spf=pass (imf11.hostedemail.com: domain of matttbe@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=matttbe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755279031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0L7suqohMW8pwpRPqtkulDJ7dUB/vKpBk/wdvObnXE=;
	b=f/wXnDSGdM89bYluVoSO9Guouoc7ZzMq/SQmvrMSeUnHUZcpxdDz2u39sw0Pg206gVN4g8
	J/cOJbd/SSrGlURYqQq4nNT52H1BN8j/ri/ywXOYYmst+veQC+3Kk1VhXHX6kpsiOy5w+L
	PPKp+E1IFdtuCtkd/cXO46h7gQanMEQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755279031; a=rsa-sha256;
	cv=none;
	b=up8/Z1qRScxYiRrxE6hJU1wD88RClKFLw26Cru0OLFta0oDkAgf/J7hZrj1vIYZwHtDMLp
	+MTf6ynKysbN3WysxAwYhD3XxIU+jRvLv0s+sAQtQ1m87FiigKT0PRMKnkqIyK5RMH/ylc
	qaADt+dbbwnwzv3LJBeWxd8iVZ6kVeA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PaR9LgCR;
	spf=pass (imf11.hostedemail.com: domain of matttbe@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=matttbe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 71A0CA58335;
	Fri, 15 Aug 2025 17:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86670C4CEEB;
	Fri, 15 Aug 2025 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755279030;
	bh=46Vhq5B5B8BhfkVAaBvZm6I80x160rOMz23izYCe7nQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PaR9LgCR3Nq8DqCnN0257ae3AWJtEgbd7LbBNcjk3Q5e5xLZtpEhNunt91yFsPi2G
	 vb8RbYLnohJYlXjTYDH6y6v1o7aeT/olP4FuMbkW4MvO6Rtdv7Su0ZJYbh8U/OUX+o
	 njNaGgjJwUwy2owusEOHa6cZwZKKq6hpYwjherCnfLuTRvDQ7JlCnhsuQaNDu8HSde
	 GUtp3tO7tHaTF7Wi61w7Vkv1oCTPa6z6DxN3ZgFjw8tdJGaJr/klp5hvsU+tHzY3Lp
	 xqxNeKLmZv6sbwoHK8ZO5H2kkgJ2pTN2oKWf/37Uuh7l7mihTAouGri8fM9nLoOB5p
	 /HwlEiT3pwi0w==
Message-ID: <41ed390c-884e-4158-9fe8-ce3af53cf77b@kernel.org>
Date: Fri, 15 Aug 2025 19:30:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 net-next 01/10] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
Content-Language: en-GB, fr-BE
To: Kuniyuki Iwashima <kuniyu@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, Mat Martineau <martineau@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>,
 Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>,
 Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
 mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
 <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
 <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
 <CAAVpQUAx9SyA96b_UYofbhM2TPgAGSqq_=-g6ERqmbCZP04-PA@mail.gmail.com>
 <kr6cv3njfdjzc2wcrixudszd2szzcso7ikpm6d5xsxe7rfppjs@5bvfwpelgj6f>
 <CAAVpQUCMcm8sKbNqW9o6Ov1MtC67Z--NTv9me1xcYgCkbJxK5g@mail.gmail.com>
 <CAAVpQUBO8TXjjtt++kF0R-qs-Utn-eY5o321NyAALEYTfq0xGw@mail.gmail.com>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 xsFNBFXj+ekBEADxVr99p2guPcqHFeI/JcFxls6KibzyZD5TQTyfuYlzEp7C7A9swoK5iCvf
 YBNdx5Xl74NLSgx6y/1NiMQGuKeu+2BmtnkiGxBNanfXcnl4L4Lzz+iXBvvbtCbynnnqDDqU
 c7SPFMpMesgpcu1xFt0F6bcxE+0ojRtSCZ5HDElKlHJNYtD1uwY4UYVGWUGCF/+cY1YLmtfb
 WdNb/SFo+Mp0HItfBC12qtDIXYvbfNUGVnA5jXeWMEyYhSNktLnpDL2gBUCsdbkov5VjiOX7
 CRTkX0UgNWRjyFZwThaZADEvAOo12M5uSBk7h07yJ97gqvBtcx45IsJwfUJE4hy8qZqsA62A
 nTRflBvp647IXAiCcwWsEgE5AXKwA3aL6dcpVR17JXJ6nwHHnslVi8WesiqzUI9sbO/hXeXw
 TDSB+YhErbNOxvHqCzZEnGAAFf6ges26fRVyuU119AzO40sjdLV0l6LE7GshddyazWZf0iac
 nEhX9NKxGnuhMu5SXmo2poIQttJuYAvTVUNwQVEx/0yY5xmiuyqvXa+XT7NKJkOZSiAPlNt6
 VffjgOP62S7M9wDShUghN3F7CPOrrRsOHWO/l6I/qJdUMW+MHSFYPfYiFXoLUZyPvNVCYSgs
 3oQaFhHapq1f345XBtfG3fOYp1K2wTXd4ThFraTLl8PHxCn4ywARAQABzSRNYXR0aGlldSBC
 YWVydHMgPG1hdHR0YmVAa2VybmVsLm9yZz7CwZEEEwEIADsCGwMFCwkIBwIGFQoJCAsCBBYC
 AwECHgECF4AWIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZUDpDAIZAQAKCRD2t4JPQmmgcz33
 EACjROM3nj9FGclR5AlyPUbAq/txEX7E0EFQCDtdLPrjBcLAoaYJIQUV8IDCcPjZMJy2ADp7
 /zSwYba2rE2C9vRgjXZJNt21mySvKnnkPbNQGkNRl3TZAinO1Ddq3fp2c/GmYaW1NWFSfOmw
 MvB5CJaN0UK5l0/drnaA6Hxsu62V5UnpvxWgexqDuo0wfpEeP1PEqMNzyiVPvJ8bJxgM8qoC
 cpXLp1Rq/jq7pbUycY8GeYw2j+FVZJHlhL0w0Zm9CFHThHxRAm1tsIPc+oTorx7haXP+nN0J
 iqBXVAxLK2KxrHtMygim50xk2QpUotWYfZpRRv8dMygEPIB3f1Vi5JMwP4M47NZNdpqVkHrm
 jvcNuLfDgf/vqUvuXs2eA2/BkIHcOuAAbsvreX1WX1rTHmx5ud3OhsWQQRVL2rt+0p1DpROI
 3Ob8F78W5rKr4HYvjX2Inpy3WahAm7FzUY184OyfPO/2zadKCqg8n01mWA9PXxs84bFEV2mP
 VzC5j6K8U3RNA6cb9bpE5bzXut6T2gxj6j+7TsgMQFhbyH/tZgpDjWvAiPZHb3sV29t8XaOF
 BwzqiI2AEkiWMySiHwCCMsIH9WUH7r7vpwROko89Tk+InpEbiphPjd7qAkyJ+tNIEWd1+MlX
 ZPtOaFLVHhLQ3PLFLkrU3+Yi3tXqpvLE3gO3LM7BTQRV4/npARAA5+u/Sx1n9anIqcgHpA7l
 5SUCP1e/qF7n5DK8LiM10gYglgY0XHOBi0S7vHppH8hrtpizx+7t5DBdPJgVtR6SilyK0/mp
 9nWHDhc9rwU3KmHYgFFsnX58eEmZxz2qsIY8juFor5r7kpcM5dRR9aB+HjlOOJJgyDxcJTwM
 1ey4L/79P72wuXRhMibN14SX6TZzf+/XIOrM6TsULVJEIv1+NdczQbs6pBTpEK/G2apME7vf
 mjTsZU26Ezn+LDMX16lHTmIJi7Hlh7eifCGGM+g/AlDV6aWKFS+sBbwy+YoS0Zc3Yz8zrdbi
 Kzn3kbKd+99//mysSVsHaekQYyVvO0KD2KPKBs1S/ImrBb6XecqxGy/y/3HWHdngGEY2v2IP
 Qox7mAPznyKyXEfG+0rrVseZSEssKmY01IsgwwbmN9ZcqUKYNhjv67WMX7tNwiVbSrGLZoqf
 Xlgw4aAdnIMQyTW8nE6hH/Iwqay4S2str4HZtWwyWLitk7N+e+vxuK5qto4AxtB7VdimvKUs
 x6kQO5F3YWcC3vCXCgPwyV8133+fIR2L81R1L1q3swaEuh95vWj6iskxeNWSTyFAVKYYVskG
 V+OTtB71P1XCnb6AJCW9cKpC25+zxQqD2Zy0dK3u2RuKErajKBa/YWzuSaKAOkneFxG3LJIv
 Hl7iqPF+JDCjB5sAEQEAAcLBXwQYAQIACQUCVeP56QIbDAAKCRD2t4JPQmmgc5VnD/9YgbCr
 HR1FbMbm7td54UrYvZV/i7m3dIQNXK2e+Cbv5PXf19ce3XluaE+wA8D+vnIW5mbAAiojt3Mb
 6p0WJS3QzbObzHNgAp3zy/L4lXwc6WW5vnpWAzqXFHP8D9PTpqvBALbXqL06smP47JqbyQxj
 Xf7D2rrPeIqbYmVY9da1KzMOVf3gReazYa89zZSdVkMojfWsbq05zwYU+SCWS3NiyF6QghbW
 voxbFwX1i/0xRwJiX9NNbRj1huVKQuS4W7rbWA87TrVQPXUAdkyd7FRYICNW+0gddysIwPoa
 KrLfx3Ba6Rpx0JznbrVOtXlihjl4KV8mtOPjYDY9u+8x412xXnlGl6AC4HLu2F3ECkamY4G6
 UxejX+E6vW6Xe4n7H+rEX5UFgPRdYkS1TA/X3nMen9bouxNsvIJv7C6adZmMHqu/2azX7S7I
 vrxxySzOw9GxjoVTuzWMKWpDGP8n71IFeOot8JuPZtJ8omz+DZel+WCNZMVdVNLPOd5frqOv
 mpz0VhFAlNTjU1Vy0CnuxX3AM51J8dpdNyG0S8rADh6C8AKCDOfUstpq28/6oTaQv7QZdge0
 JY6dglzGKnCi/zsmp2+1w559frz4+IC7j/igvJGX4KDDKUs0mlld8J2u2sBXv7CGxdzQoHaz
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <CAAVpQUBO8TXjjtt++kF0R-qs-Utn-eY5o321NyAALEYTfq0xGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15A664000F
X-Stat-Signature: 9szjjsuuy6x4misn54qegabyx73pyei8
X-HE-Tag: 1755279030-366834
X-HE-Meta: U2FsdGVkX18uAoc1YZfiK64m3nD6UQ37Do7cFuHXzEGd+CIkY9y0vJXCQJ6izzgy77xLa7aWywOjI62RIf8XrxtQYw0Sb1WfQKnGwNnm3VQgxaXweUHfUyvUm/wK4rkbrZguz6j7JAXQPL1teapCXiFwoly4N05ZeY33dnycbZd3F/uXdcRVBPxERR+zjdfqDR8sC7vRyljrbHQjMoZQKhVprEnNV65rCUHZjOzuW5gjydqnQvcvpdOLcWp7iMx89SV8XgTXkkLZ4CCGMCe+6kqeDjeWJ67EikuFHyblAY5O1jlgyyFm3wJtrspRpc+5TM0MNq2k+PQ/x2PTaNpSkrIlqt7upzuOIEA2f641zYz3EefAbpPRfPC51EP0V8ploNrRb9t8Pmt3YdPHPe5YTUD+tRzyYWhriPsFgvJ6Fm1Qf2IrGW/7DXNNFz3VMDps/ha1nWoFag4QoSaajVI8zdno7MPPUZrn3PTEdT+HkYp08TuDinjs9P1rEdGYHV4cGoRRgrOTczbBJEKTQbyaSJLTZ6kZmM9pG0vCYEYq0I8dXYyAbow4U6Co1U6lScbK1/0U22gLDqmu0cJ+TYKrwIfOZP5NURBWC6tiyGReZQgVDrUdirOBDcpgRBcIfrdb661Nu+xWnrKLfqROlSGgd3MoFApEzqAD7/wNNF7htVtRbrFgNOjSXKdsyBxFGkdkkdB6GCuuwCaZ4SBASRtmU/EKUK/Yrn9/aVMEAVwF6r9H5l9ylFYaf5dSyYWROIDiM94FslQ3H3dbZrJ2RXYau1tP/BF7nWcZqrMSxPqkENUXf83wNe076l54wosjMQ8THuFLKHJV8TQ0KGyFdIsfUVRMFFv5Km9+2agDOVxVMyn/ofHuQ0fW2nbIvpWAYVJigHk7/ROpPtr1Vle7e1bCWk/qwXd8E9/87Vqk5bVl1p51rDvzXbZSEJctmX13uz/uM7jySe5ohqWFlb/JyXz
 937ZHp5u
 rhx+8YSDfAO8AJTVg6Kn8Vr9V96UE+DAjioIPzuxuO6H7LdM3t+0BLFQfG1qVzldmu3UxAXiP7wZLE3XYZ4iHvyYUAmdW8ypWm6I3P1bh2XbSBng/+weyopV6bOXTPrUHJ3iZ7HAayioqvD+mbl8jl+DTByTGco51YyiYeWdZctPUFp8whhkpqRuSpnxV3V2+wVFVyK9TCaG6seWogN5GjQzaiVXWgAlYCtPPoFyktjSqY0vMeMnjr/+/CE5GzMrBpw9JHAQYpUnJhLV170xneKSKePR+I7tHo399gE/ZgRLTHn9DfsgR8/8D067zVzgRpKUCg2/q/ca6hfLEXqRmZZ1ujOnsTjg4IFMHKIg7Zv4ap8Y5QHddiTWE2xq2fhld/dKqVP/qOj5RkyB0dCIy/bAt58u5GBIsGrgOZ7ZiAuC84gLYxVmHr38GpBgel84Uja+i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kuniyuki,

On 15/08/2025 19:24, Kuniyuki Iwashima wrote:
> On Thu, Aug 14, 2025 at 7:31 PM Kuniyuki Iwashima <kuniyu@google.com> wrote:
>>
>> On Thu, Aug 14, 2025 at 6:06 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>
>>> On Thu, Aug 14, 2025 at 05:05:56PM -0700, Kuniyuki Iwashima wrote:
>>>> On Thu, Aug 14, 2025 at 4:46 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>>>
>>>>> On Thu, Aug 14, 2025 at 04:27:31PM -0700, Kuniyuki Iwashima wrote:
>>>>>> On Thu, Aug 14, 2025 at 2:44 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>>>>>
>>>>>>> On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wrote:
>>>>>>>> When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
>>>>>>>> sk->sk_memcg based on the current task.
>>>>>>>>
>>>>>>>> MPTCP subflow socket creation is triggered from userspace or
>>>>>>>> an in-kernel worker.
>>>>>>>>
>>>>>>>> In the latter case, sk->sk_memcg is not what we want.  So, we fix
>>>>>>>> it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().
>>>>>>>>
>>>>>>>> Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
>>>>>>>> under #ifdef CONFIG_SOCK_CGROUP_DATA.
>>>>>>>>
>>>>>>>> The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
>>>>>>>> CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
>>>>>>>> correctly.
>>>>>>>>
>>>>>>>> Let's wrap sock_create_kern() for subflow with set_active_memcg()
>>>>>>>> using the parent sk->sk_memcg.
>>>>>>>>
>>>>>>>> Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
>>>>>>>> Suggested-by: Michal Koutný <mkoutny@suse.com>
>>>>>>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
>>>>>>>> ---
>>>>>>>>  mm/memcontrol.c     |  5 ++++-
>>>>>>>>  net/mptcp/subflow.c | 11 +++--------
>>>>>>>>  2 files changed, 7 insertions(+), 9 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>>>>> index 8dd7fbed5a94..450862e7fd7a 100644
>>>>>>>> --- a/mm/memcontrol.c
>>>>>>>> +++ b/mm/memcontrol.c
>>>>>>>> @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
>>>>>>>>       if (!in_task())
>>>>>>>>               return;
>>>>>>>>
>>>>>>>> +     memcg = current->active_memcg;
>>>>>>>> +
>>>>>>>
>>>>>>> Use active_memcg() instead of current->active_memcg and do before the
>>>>>>> !in_task() check.
>>>>>>
>>>>>> Why not reuse the !in_task() check here ?
>>>>>> We never use int_active_memcg for socket and also
>>>>>> know int_active_memcg is always NULL here.
>>>>>>
>>>>>
>>>>> If we are making mem_cgroup_sk_alloc() work with set_active_memcg()
>>>>> infra then make it work for both in_task() and !in_task() contexts.
>>>>
>>>> Considering e876ecc67db80, then I think we should add
>>>> set_active_memcg_in_task() and active_memcg_in_task().
>>>>
>>>> or at least we need WARN_ON() if we want to place active_memcg()
>>>> before the in_task() check, but this looks ugly.
>>>>
>>>>         memcg = active_memcg();
>>>>         if (!in_task() && !memcg)
>>>>                 return;
>>>>         DEBUG_NET_WARN_ON_ONCE(!in_task() && memcg))
>>>
>>> You don't have to use the code as is. It is just an example. Basically I
>>> am asking if in future someone does the following:
>>>
>>>         // in !in_task() context
>>>         old_memcg = set_active_memcg(new_memcg);
>>>         sk = sk_alloc();
>>>         set_active_memcg(old_memcg);
>>>
>>> mem_cgroup_sk_alloc() should work and associate the sk with the
>>> new_memcg.
>>>
>>> You can manually inline active_memcg() function to avoid multiple
>>> in_task() checks like below:
>>
>> Will do so, thanks!
> 
> I noticed this won't work with the bpf approach as the
> hook is only called for !sk_kern socket (MPTCP subflow
> is sk_kern == 1) and we need to manually copy the
> memcg anyway.. so I'll use the original patch 1 in the
> next version.

Thank you for having checked that!

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.


