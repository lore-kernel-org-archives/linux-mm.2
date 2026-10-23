Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77313606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 21:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ArBbS8sR
Received: by kanga.kvack.org (Postfix)
	id 3B4F96B0BF9; Fri, 23 Oct 2026 17:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C886B0BFA; Fri, 23 Oct 2026 17:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3716B0BFB; Fri, 23 Oct 2026 17:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 086346B0BF9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:57:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81156A0282
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:57:22 +0000 (UTC)
X-FDA: 85355252724.11.27BE1BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9D8A8180006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:57:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArBbS8sR;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792792640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tu8cvyWH/oOOkyCYeseFYJUgW609McRuCvju08fCeYQ=;
	b=a1FoMo6okzqF43uBCawJmfNjIX2V8nwt6GtYxdDsgqgFm03jMu7OllaPnaB54KRqhZLrE3
	7VSIqrr11EMq4oIDAVH/tHX0w6w9t+fPKuOdGVb/1QzxUZh+a8kxulVvbukL7ryLWHEWSD
	xBoJvbzuKkkJLIK8F5KRd9HoLjNurV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792792640;
	b=oDlqNHIylQ8vl5FX/T4PZf3xtfzBcIH09/U7tvmp8Oc2txZYRoYy7C6GGXPzb2bT9ZZWmy
	MVLlCXFaxeolddHsR7aUl8jdv3+Qqt+k+ufoawvs7JbVwy68wga6cZ9CgrHq9Nh1insN1s
	ReaD0SF4sYdL0MjiiFWpAEZBLp+EVzY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArBbS8sR;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A57BB4404B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1EC1F01825
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792792639;
	bh=Tu8cvyWH/oOOkyCYeseFYJUgW609McRuCvju08fCeYQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ArBbS8sRe2vZvBPusOGjqBO4rL5/iJmOJ9CkoNhu2e7k0FBxGNrH52nYh00i7StEL
	 q0XDBQh44yKY+SeL2AfUQqAt2TSOdFPMVwBZ6gA2lZ6rcXJM85LPT6kalfXQ9baMYs
	 fsvl13QpfrVCSsMIr5vAzn6XoLzf4egFifAFEloe3/vgA4RvocSeoRiurCA/yUx+lk
	 z08L3Qb3Um5BospfauxuAe9lP38hTSyZf82Ac5LCA2mxiN62w/7eCCeA0lw3/dEq7u
	 8UkpKXie61nurXw0oYGj7IONt1Jy2RDtoAyWvqslWyxUniA2I8K6BvppggqcvFFwM6
	 tbsZfYxGbHfEw==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93f3c895a0eso102186085a.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:57:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxW7C+HkXXQGiw3Y4KsczUXEFk7tZcmjZgpExXKIFNzVvWeOK4WQIsuJoM+r4NENUrH+TUBmG7vLw==@kvack.org
X-Gm-Message-State: AFq9FYKFKl6751EFUIYd4YtmJY0XOdKc+JWFOTRAQV1UA9AH6z5qtCkN
	5WOjXpqCX2q0bPa+zQfauUI0w9b4i6i3aRfMgb7o32SHDBqjFWwmrJ5oyfkP9YFg7lYevewf9H0
	dQ2znGlSKIL9j7IF7uo5mP3xe3cux1/Y=
X-Received: by 2002:a05:620a:8389:b0:93f:5ab9:fda7 with SMTP id
 af79cd13be357-940ef95664emr52518085a.42.1792792638589; Fri, 23 Oct 2026
 14:57:18 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019034426.2354049-1-ridong.chen@linux.dev> <20261019035252.2357900-1-ridong.chen@linux.dev>
In-Reply-To: <20261019035252.2357900-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 24 Oct 2026 05:57:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-sbP+qtSk8b2tWGBPTNfKiF3=z69qc9f+FjWGUEgyow@mail.gmail.com>
X-Gm-Features: AclHuK_VJ_jirLI57h8oBojXk8WvqdC7Lhm8-1ezp_qE6OG-iPQQ44-4rsmpu_4
Message-ID: <CAGsJ_4z-sbP+qtSk8b2tWGBPTNfKiF3=z69qc9f+FjWGUEgyow@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] mm/memcontrol: drop unused vmscan tracepoint include
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D8A8180006
X-Stat-Signature: 5ty9516nym9i1u7m7imrnydkujm5hrw6
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792792640-232369
X-HE-Meta: U2FsdGVkX1+CjqDEf+DOq82ElX86zSLFcP3f9IRD1dQKZCnxYyNEXsbcBYRRC5qEUMYF75m5i5jGy69WUK4rmCf3djBU/mCqppEl4G5uTxM/itafHTt9DiQKvGa4fNLzhmyEZC+Vk1nnkf/7nZL9kLwmJjbQ4BlQsaX8tVI9thQLDOgI7tMPPWYNITenMn12tXKfDOXzfmORsOfGpc7RSu2veKRKvgPduDXoUlX+sgAohUNxbqA6rZ/Jqux3EmpqVmsXbRhOf2L3DQG50FUuforIs4JZAf6LSzzL4FnamyCaqUnHFHeYeO+7+KKwqKfNvPmAzboI1lYJsWmmPiutIH6z8JGD8v9G3JwF3xr36gjQorGKI9ntWcQV8d2WfNRUE1W6MMcxA5lXvQSQ1eGPStXCv12J2f7VKLXMrFggENmdT5miAbIQh7Csj14V2+nKQLybIgggagotAoAZcBai58tOb0wkp7l8sVJ4GC9PXGP69Ux0v5J5fr2vhuwCrfv0XMQiamgxBlMxYDrWrHmE+2K+KFjQnc8eDhcGeOqKfZH/0eynFVoaE8Ilp5UkUwoTuYH6WrNdr+ZGvzJbRB+aqzjlvD82osGXc0jmPWdBsq84AXt4miNhAbEJjybGTeQwpd2GknQawqwTVDsoMkdQ+bKOadbFIx/L4PPADQmsFCFiVWihFnF+uffaWWVhPHBxqOT+7l2mSLbtbG3Xl0CstE4Tt/isTd3O4ihgx611XL1IPL1NDBbV+uqmvOtM9Og7HQEVeVrrWU3CfxJr7onz0SfutH/45kuO7ktJPE+EHmdhMh5V8d+eBaPJVnJZW1z+BbPDuHc7oPNTJ7+NmqF/s8i3hIZDJp/GU6bcUqMtaiBk1MpHaLWc1tXVs+S6WfGGdJxZPfqu0T3Z5iQghHvUO0cEJz54lxCt1iDUNav6Bwapy4eQcXGfOICMunchadayVGcE/FL8RA3JAe0sges
 ghymq19U
 8SmYYy+wmhFomq9dVZbTPY6STjfofcPd6R3PR/m930nJC3EF5q+gakISel30obS2w6+jXLsZsPKYK0MeaIKRfhPhCJ3EJnrzOsboOQbtPOjESCAQpGC1ATzoJsb17KnXKP5Qyu6rir2OSebB2yKBOvQJOQyW6CWG3DWEtmQf8ueg4TN+BkzN6h/TUw5PHO9HOjnWI4wHmQS3LlJx4Cd68THDH6Mnb4275aKp27yLxBOIST648Ew5vQumNE8hep1/w0GtjTvRkTZR3l7qMKqvyD6YDwk+IFzIONOZ/O9XjZU8odFvRv4UxV55DafD8rfhKiKnu/AEAE5P0g8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:53=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> memcontrol.c includes <trace/events/vmscan.h> but does not use any of
> the tracepoints or macros it defines: all tracepoints invoked here come
> from memcg.h and writeback.h.
>
> Drop it ahead of moving the vmscan trace header under mm/, after which
> <trace/events/vmscan.h> will no longer exist.
>
> No functional change.
>
> Assisted-by: LLM
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

