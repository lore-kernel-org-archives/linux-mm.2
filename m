Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E6ECA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA0C6B0093; Mon,  5 Oct 2026 08:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B1A6B0095; Mon,  5 Oct 2026 08:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89A36B0096; Mon,  5 Oct 2026 08:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A163C6B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:19:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3566B80205
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:19:42 +0000 (UTC)
X-FDA: 85288478604.17.63AE15E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 79CBC1C000A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:19:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdf79agI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIF35PqlBZWF17mD/fW2HAHTBb88xGlR2fifKJo3V0E=;
	b=VFrapofD6FKSB4Vsp0YH87I/swXWdH1mevlPil5nJUtI0vAZytkxGTcbX+QlynM6zLHErb
	FTXJkXolqvmtNgyY/nJkZyT7LZHs44Jsf6a5nzgeeF4bYR1YhFcTRYofZwDdj3/5bSNy+/
	AaxAkzfnIzk9oCC0S2K7OozHhFQRfKc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdf79agI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202780;
	b=3jMeuHfGnuMruR/Bt3iQ+0rTlVBMUC4BNtYL8e2q2tsS47LKnrIyZ9V6C8YMCtYasi3ZQd
	X28fu+vmQbp+GaJbh0UhlOypYqv6PJBL5xPoLr87BiGWOgWJX0nuT7zIL2Ix5/G5qir2Ws
	vVKmWk63YjClzGkdxpE6uyLGlogLDKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 569CB60236;
	Mon,  5 Oct 2026 12:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B341F000FF;
	Mon,  5 Oct 2026 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791202779;
	bh=uIF35PqlBZWF17mD/fW2HAHTBb88xGlR2fifKJo3V0E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fdf79agIm0rXPbXqoAamy52BTxoDUGJuQsJlRExhXZu6PBhlvrsxhAmJWz5RUPLct
	 p7sJFLCzvzDiAFlF1Fz6GmqnateMDVO52obrb9hOgtN/7FP/xmwbGPDt9QGlI5VKL5
	 X5y8koh0BCRzb5nJGEA3eH9EjlJ9uyO/e5ibzPOntiSjkAd73JebyOEb/jGR+eV6s2
	 PouOL9WbJsV+z2Vcaem8M3X8dDiQHjajk6nqdxRIfPwSHSTZZgXm5hDekYW66I9Vcy
	 RNcDUqN3R8GikYbsOKDDwsRmeSxVUGlTdp7fG5/VMask5CE2+gmfJUND7zYbuFSd8U
	 oV+EyzUHgb1YA==
Message-ID: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
Date: Mon, 5 Oct 2026 13:06:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?=
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cszgzo6ekgkwobbpfic9iuw8f3tw1yfz
X-Rspam-User: 
X-Rspamd-Queue-Id: 79CBC1C000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791202780-897861
X-HE-Meta: U2FsdGVkX1+qzbPdbtLYy0MNaxRHtOeRv4pJ+Nf+Oh8MT0PyhEYiMMWLJWn/DjxZp6HUa6KEkRc6YcQfZkk4sYtLlIkGcEu3KfR+/iLde+5Phu5sIun2YSyd0gK/AyAgmTFJxoFJ1FpP3tK6xXCAcyPwhPwi9xIYiNwJ9UQbWAiJEzT2rUP1FdEqX4JguiBbou3gQwFHBZsopm9tYv6N+N5lSNKGW74h3PMauMzRLoopJ9Pbm6ekv4uNT/Qn5FjHfQpIv3pncbVR77OuYyh5cGj+FnA0ilSGQpIsmVPfevqHi7VZX5XnBO+zmEm1VJVQyw7IStdS31F+24PZce844qtvAORO5ewcU5fwjuo9cXK0P7+XW+NFguYcKw7vqTX/3dNgCLyr5dzBS7ziWia0OJ7OviP+AFcw7jN7BrhJjAbx+EnFUftpaM2ElTY3O0rqqNfYfb79w+FOJXfjGiZ986X1F2kYQabGXI8Hb0xX6/RM/l9XSWAxlC2jA2KFXG8jnHDUUIMvfplllIhUDTFYpaLvnreHcoDo8vjb89gtNDsQGQwTbyaSMrZ+mwIGxB4eisU2JRfFqujn/HpT9HplqWGbd3V02PiojjNygbcRPRkcg1i2weNpWVORtSUabWjzHmNDV3Y4B+WFp+A0V3WBzjI4m27CbWWSxcmWAhPgbbxlHDIQ1HsjOyRlIBnyzlc19ZNVCqrqYcrMoXOrHOSs87Ndgp/8w22ofEVn88LpJs4JHaOQRHGptiMt9RRUfFBplv8fYhJtcIIqxjXcpTVsEyhIf8xSM4irv3nnN4o5Lk2zc9t4EsC2iA02GHeA5fiXvATqyO4JK79+3wK6hw1ED3jAFWMtwSuHZSw1Yi6G1QE6DjxN7QbsblxJa7qQKJM4mPDC1/+T7bOvnIMqsiknS7edYdCow8pT4Wkv0W95bFxMeseIHTbfpo30glFIp0cNffjB07LJfS6q/x7cgxv
 tIUVvdpP
 ZwswaD0Ei/aVyx35/ArcT/88a9d6jwP41rqlgUMx7SXfu3KQ0qAqK7U5Dw3V+wqkMBuV0k2psaUehJYKd1con+b4Ra+iGX+Gl6U34RqRr+cqDEIlIRIw46+EtJxH6+9YkmSHbVRyI6bUOLSPbEiDT10nMWRXeOKjZ+ozGHVL98mVO2EY6qGlakQjBbk8k8CnVC1msnb7JL5Zpx8gqqTIXAAtjmp6VOp4b55c7fY11m26MRfmXajNVyqqVS9oZA/5xz/dUYHjMrSxJKTkRV9rPWn2frGmtRC6jNKGFrT5CW1hVn7DZBX++Am5jWRTpDxp1/9Uw3Z7zWjUIBxgjzHylzANa7acts0XYJII2IosU7LFORL4Sr/7xau+lk6zsFE/3qpqIoOEDV9z8hgcvqF5lxivZ6TLS1Mz/Oqshx/2AYqEww81crNmEB3BmQunRv6knu1ZrOvzJTsa0uzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 15:38, Chris Li wrote:
> On Mon, Sep 21, 2026 at 8:56 AM Nhat Pham <nphamcs@gmail.com> wrote:
>>
>> On Fri, Sep 18, 2026 at 11:50 PM Chris Li <chrisl@kernel.org> wrote:
>>> No that time slot is too late for Asia developers. I don't think we
>>> should use that time slot for swap alignment.
>>>
>>> We should find a time slot more friendly to Asia.
>>
>> Any time slot would have that kind of problem. We're spread out across
>> the globe.
>>
>> Let's just use a standardized time slot we have for MM alignment sessions.
> 
> There are more swap maintainers in Asia than in the US + Europe, at
> least based on the maintainer file. Please be more inclusive. If the
> alignment is done without key stakeholders, it miss the point.
> 
> Sigh, we can't even align on a time slot.
> 
> In that case, let's keep discussing on the mailing list. At least it
> is accessible to every one.

Looking at the mailing list, that approach doesn't seem to work.

Finding a time slot that makes US, Europe and Asia happy is ... tricky.

1 AM is certainly unpleasant.

US vs. Asia is also tricky, but doable.

China 8AM vs. US West Coast 5PM?

China 9AM vs. US West Coast 6PM?

(Europe is 2AM vs. 3AM, who besides me from Europe would join?)

-- 
Cheers,

David

