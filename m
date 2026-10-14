Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B84CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 01:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8C46B0088; Tue, 13 Oct 2026 21:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9F26B008A; Tue, 13 Oct 2026 21:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA886B008C; Tue, 13 Oct 2026 21:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC0D56B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:31:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B469803CE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:31:03 +0000 (UTC)
X-FDA: 85319503206.16.67ECEE8
Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C7901C000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:30:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScbTqj69;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791941461;
	b=mgDj/K/NXkVgBjoPDgWmDmpvbe2L4pkx6v/7oVpUwhvGHkm4TW6U1MGyRvHja81HT193h9
	1eJ7Px9aNJ9dWXh/ZYI4zxgKXqHnfDVIeQstB+jYXFq/WoOj38nJyKShHqq9Jc10K0gmah
	xNnECO544qfNmFH33ETsEn/29w6dVIM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScbTqj69;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791941461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QsEFO3ZNoRKan0epWEPHkx/bPCcs3qLEdk+N+7MmMI=;
	b=YNEzl4h8sdEJq4CSPl6/oJzxWoizYsEFVj31i8vXqbW3KS3X56FUzr3prgWHGirpgzSVow
	MK7h5VGiXnkIDWrzLeSc8IYlerP4h4waSgB1nvi31ZZlk5wYn5VPHwVDQ1MyRNRUxGseEl
	BEeM01lfSQOxyfQevZM3Z7BF9Y1UR7o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5ROt2655uPgI977PSMUmpSlu+2sAipPFwrJ1t+HxYEo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791941457; v=1; x=1792546257;
 b=ScbTqj6977N0M+TFrc7aOMq0QtOCFzCqsar6DizDZ8OLRua3ipU5zr4QYPNQwrovmdxmpJq+
 iAk08MPk3gG5UICLkRQcnLoX/ynb0qO+/Z5xNy1s26CratQRQL1dr4L4/CKmwkEc8BhfmrKFJYz
 jSFVRmvRQJlvp9v1XEnsEWjA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7d27739f63868d36;
	Wed, 14 Oct 2026 01:30:34 +0000
X-Mizu-Trace-ID: 7d27739f63868d36
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 09:30:29 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <ryncsn@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <as7bNVNRkLx0JYqO@MiWiFi-R3L-srv>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C7901C000A
X-Stat-Signature: x61guu7khnxesux531ff1unujndr9f7m
X-HE-Tag: 1791941459-99539
X-HE-Meta: U2FsdGVkX1+W3JP0r6HrOyynekxgteGJkbyxqMqULVmrYEGhPko9haKAWr8g7N3eyElInVh4BD3sb56QQvw0gU+pGckGbLmrjb4VKbsVpFyXgFdEdfP9E2q4o6cYi8ZimtDqpaOSQSfeJTgEzms+lfQUUvVEyuGqKpGuOPPXXuJqWwPM2YAWu/CrbLtyz8KvcoBjRQBcbNqB59lj6QYUStRNqhuHAFWdBIEbKTPd/u+1rol/34hB2N0oR/E/TGWA/MZ95IHPse1DIZCMkmIkReKZagDyS7hC7D+NwnUt12tLkKhZuZFGFBtvZXrLMae8Dj+RiocnbdXy6GRUgPWv83id8QYqxl6zrOUkpSHL6G+YP8cOjsbwqvDoD32cwdBHSIqyjeT09LTs90LyY5GntaZ11Mryn0c16BhfLPapk/lWgsoDPmIZmFe01RiuEFLEKVK6Iykw5maZMi8PchbBwPiSXQIX69/0VmBz9ilHX1ZFSSbLtY9D+Y3qGgb7D+SxG3MB5Q+WeBDRKp3aoofXPMu786r2YUzMZjcOJ6kd+4ssLIPL3nlvUPXUiXY2vMXpqKQ9pwuTkVrgYrVJg+pUyCrZBya5X3DR2gs+7MvulssoFLDZpJI9qWl37/9hbkgxIoHEHJdfvSMZ2EF8/y/r/QB1DL+V/cC89pudf/5Z61OqDbUavR7LbwwV1G7uqWPPV/AWXCYcfttDhXKl7GnjUhipPVp1M8v73U4yNrOCuzYOduoqMjOrO7AUwo0uNSRo+2cT6IL63ELqJ9piVjxdlpUf/vijket8bA6eyFn/+A9zJsx7LlPZrf0+Rr9fvFG59WAFkas1FFj83fOy1f4LH5A4zfyACVCPGYty5HBEcsCUTRuX5if02bfqhhFaSj+Kgcj8BpCvUVNNWrhCaW3MDljqMxZpS9/2da3lGpPonlYfI1or+oNTyxZ/QEce6DEoMEpNo2pZBZRUtdvK34f
 wO5ZMwND
 641hHrpUkg5NIe1WEJc7NuJLZQOueFxZ1iXah4oLKw1/CveQWZ9Xm4MWO5Fq9kkfOsVhNgE42DwOEMHpl/FdohOcV+ODgaG7FyqBJf+Ni7FCrt3o/fTTmPsHR3YxDHyqCTN99/sN0ffkz4kXkxpXiewLdKhlh+8H2q1yuet9CKGTtWdW8crtu2oO7tSaseNhBiUDfhqJi2Aeqg0fgVwyM5OYKrhhRmZvyzfNebF+NK9Dnj3yLkfRyXAlvaFUhhPuS8trXI83iT1iOwjoKMw4XePTJzpP/494s/N33p+DuPYiqjNXatGKrH9nw3S1iKRdGSdCj1MUnwmdX4T4oNh+D6Zr1f+3k3RL6avK09MND7N2eEtoTWvkKKnLd4rdF5lZ24ZzuSeUfHctJS52saYfi8jhw1/NRRLtFiZVQ0MO8HYSZ6epRMpsGSBob3el1fllyepxHhGrBuMB7w3H9d2jPmrRbbHNOzwrAtEXL1qDsJdbefjAhhmHkJzXTjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/05/26 at 01:06pm, David Hildenbrand (Arm) wrote:
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50 PM Chris Li <chrisl@kernel.org> wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessions.
> > 
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> > 
> > Sigh, we can't even align on a time slot.
> > 
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
> 
> Looking at the mailing list, that approach doesn't seem to work.
> 
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> 
> 1 AM is certainly unpleasant.
> 
> US vs. Asia is also tricky, but doable.
> 
> China 8AM vs. US West Coast 5PM?
> 
> China 9AM vs. US West Coast 6PM?
> 
> (Europe is 2AM vs. 3AM, who besides me from Europe would join?)

Hi David,

Thanks for the suggestion and for organizing this meeting. Both time
slot is fine to me.

I also support collecting the concerns or issues people care about in
advance and discussing them during the meeting.

Thanks
Baoquan

