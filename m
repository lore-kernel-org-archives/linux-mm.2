Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4DEECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A7F8E0009; Mon,  8 Sep 2025 13:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01BC08E0001; Mon,  8 Sep 2025 13:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72A78E0009; Mon,  8 Sep 2025 13:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D65568E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:34:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5017139D01
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:34:26 +0000 (UTC)
X-FDA: 83866782132.16.308C87B
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf18.hostedemail.com (Postfix) with ESMTP id B663B1C000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:34:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvQISnKl;
	spf=pass (imf18.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757352865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI+4qBnk3MrykJHWhGMohkHW+kG9BF8eSFcQInaYa7k=;
	b=XgvC1hHKc8l/ersne+tJBqc4jyaa/wiLXqUrFjVSVKfObeNBaGltNQ2C9mxQP5G7RRfGnw
	EVh8R0ARZ+xsHDzyfTEtyord32njC8Ertx9QbQRKNc4kwvBQBljuFZ1xYjczNEfcCSR9L3
	OUhfPGmPH4Ek8uWuyUFc7/OI2EMINTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757352865; a=rsa-sha256;
	cv=none;
	b=j83FtZR8UWdYfbe6E5tRpj6QHP1lV3zx80Db/TVLRq0QnqGIMQdP4XIfdLM/wYTghvOKPY
	8Elq0WY2w31IXWXGyVWMURkR03f4Pv3I3sYV8mtxflsaYEypcUgPJ59s8IEz9xbGmEy5q2
	JIvBS6VHvPtAQZBHEf3r7zSLURvTcRA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvQISnKl;
	spf=pass (imf18.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 8 Sep 2025 13:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757352862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RI+4qBnk3MrykJHWhGMohkHW+kG9BF8eSFcQInaYa7k=;
	b=SvQISnKlR1oILzgDvsjbRDxXubVynYLhCelBHtp/U9kB5wfTLXx0dUZiQAFKUapZTYrZsJ
	Ql5pbx7rrCtJ9O3NrYBT+FA/ZqbuZnWwHdVSHpiLIp83MUCTzhNwG3aKFcuU9018widx8q
	plU7OUU7PAG+fSXTz3ObRRiv7K5hyg4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Yueyang Pan <pyyjason@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sourav Panda <souravpanda@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
 <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
 <aLFKHGe2loD657fu@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLFKHGe2loD657fu@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B663B1C000B
X-Stat-Signature: wa6tofefsmcp3fs1yedoq9osp1yz97q8
X-Rspam-User: 
X-HE-Tag: 1757352864-9978
X-HE-Meta: U2FsdGVkX1+YHdFbJpFbsK3wngDEkAK4Jn+miiYExU+UmaAoNLfk0SRfXCqWtU7UHTdLl9G7fms7ZEq3grs7H/gdyDp/tMpw1n+qhu2QtLCH688bsy8GS2BZTPfPlc9qF3EvreJ0TsaaMLvcD+wnIeitIfaA55i5QL9HRQgV86bkzgCp84pXkAbaPT6fSM9u7MviL4ap1jaT2ak9SdHYSG6ZfV66eb7/AfmkGfsJLov9ipLp20D3yNxICe8l5NfAw2wh+Nvz0WtNOE1sQDHLpgmHZB1IabiBmtIfQhwHzMIIreYC3y1v3wwaiV7ARoX7euOH8FVYdXxzYiRl7N3a78QC2fNXChvkB0F/9asnefSbTyWBVNtbc8YOmV864vbb9wsfXUz+sLWm6Nben3j3kFty9pdMTxbyAfTBRx48TlDXuKqt6Vu8zP9DuoKW3wJ3EfSqMomTFNjjc59Icrbjx6S4iw/iDUfYyeoYH+c6w/8+jbVIgB/lZKJOzzJocv5CDAanHYEeWbEX9qvyhepLEttZxdRh6/iyKjr/NLZrugehbk0yfzwW7xMXSDeTLoVARY0nx66ZHSxqyr7zD67lGb1j2UBpyUOHZde4rJBlDIqt9Zge/epGvJnSVciNeUwxhli0/mWUP7TQCCKkFDLmDqYinlvPAefRtNmRRhuTgdmTG0PmoOAkvuT+I7EF7lAkm2/dHt99EM9ShRRMltZBMz8HhuVbpLLLop/uwRDb3PjbUpjhNlZXjeEvLWkWG5jda8JAnHEtOITBH+hVfHXjyEXWUNvWzW1NiBAZ1lClT9q5lCAwicHby/njDz0vGbYd3g+iHFMFHJAU2vghy+7DUeZUoyPtI3rNgMHItlBt0/bQ+l+z1MzfYKd+W7P3WJzlz2n+Ut0nWW+1dFLDsQeoyB1hlAvpaLuhdrfsKXccJ6m4lfKA1zZjvK+lzeUia1j17ZY/Fd6seL8ocXuPfmM
 uSu4I4kr
 031m9cSaLb77FyJbeDK8RX0DlfAGwhqK1XMPtJvsZ+PzNX0G/uC6NRyTfrGMC0weE/GDi+bS99Q5ywBW+xhXyKeC8j/o9R5iBqcFLMeX6El1GfiWZ9FKcvhAXBJNDVEo2BTvfgsnJltVHd89QGTqOWv2wTopSeMcwQXZL9UXJOqNRVXmA3Ref0Oxh6yW7OYH4c5pENVFodL402q6WazdKfM7W2R2Uu/UsrYwWQxdoL/2DBriGymzgiFJXcNl/QXBUnMzMs6/8sUmb2W80mXS83OImgPd0qtf77o8w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:35:08AM +0200, Michal Hocko wrote:
> On Tue 26-08-25 19:38:03, Suren Baghdasaryan wrote:
> > On Tue, Aug 26, 2025 at 7:06 AM Yueyang Pan <pyyjason@gmail.com> wrote:
> > >
> > > On Thu, Aug 21, 2025 at 12:53:03PM -0700, Shakeel Butt wrote:
> > > > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > > > Right now in the oom_kill_process if the oom is because of the cgroup
> > > > > > > limit, we won't get memory allocation infomation. In some cases, we
> > > > > > > can have a large cgroup workload running which dominates the machine.
> > > > > > > The reason using cgroup is to leave some resource for system. When this
> > > > > > > cgroup is killed, we would also like to have some memory allocation
> > > > > > > information for the whole server as well. This is reason behind this
> > > > > > > mini change. Is it an acceptable thing to do? Will it be too much
> > > > > > > information for people? I am happy with any suggestions!
> > > > > >
> > > > > > For a single patch, it is better to have all the context in the patch
> > > > > > and there is no need for cover letter.
> > > > >
> > > > > Thanks for your suggestion Shakeel! I will change this in the next version.
> > > > >
> > > > > >
> > > > > > What exact information you want on the memcg oom that will be helpful
> > > > > > for the users in general? You mentioned memory allocation information,
> > > > > > can you please elaborate a bit more.
> > > > > >
> > > > >
> > > > > As in my reply to Suren, I was thinking the system-wide memory usage info
> > > > > provided by show_free_pages and memory allocation profiling info can help
> > > > > us debug cgoom by comparing them with historical data. What is your take on
> > > > > this?
> > > > >
> > > >
> > > > I am not really sure about show_free_areas(). More specifically how the
> > > > historical data diff will be useful for a memcg oom. If you have a
> > > > concrete example, please give one. For memory allocation profiling, is
> > >
> > > Sorry for my late reply. I have been trying hard to think about a use case.
> > > One specific case I can think about is when there is no workload stacking,
> > > when one job is running solely on the machine. For example, memory allocation
> > > profiling can tell the memory usage of the network driver, which can make
> > > cg allocates memory harder and eventually leads to cgoom. Without this
> > > information, it would be hard to reason about what is happening in the kernel
> > > given increased oom number.
> > >
> > > show_free_areas() will give a summary of different types of memory which
> > > can possibably lead to increased cgoom in my previous case. Then one looks
> > > deeper via the memory allocation profiling as an entrypoint to debug.
> > >
> > > Does this make sense to you?
> > 
> > I think if we had per-memcg memory profiling that would make sense.
> > Counters would reflect only allocations made by the processes from
> > that memcg and you could easily identify the allocation that caused
> > memcg to oom. But dumping system-wide profiling information at
> > memcg-oom time I think would not help you with this task. It will be
> > polluted with allocations from other memcgs, so likely won't help much
> > (unless there is some obvious leak or you know that a specific
> > allocation is done only by a process from your memcg and no other
> > process).
> 
> I agree with Suren. It makes very little sense and in many cases it
> could be actively misleading to print global memory state on memcg OOMs.
> Not to mention that those events, unlike global OOMs, could happen much
> more often.
> If you are interested in a more information on memcg oom occurance you
> can detext OOM events and print whatever information you need.

"Misleading" is a concern; the show_mem report would want to print very
explicitly which information is specifically for the memcg and which is
global, and we don't do that now.

I don't think that means we shouldn't print it at all though, because it
can happen that we're in an OOM because one specific codepath is
allocating way more memory than we should be; even if the memory
allocation profiling info isn't correct for the memcg it'll be useful
information in a situation like that, it just needs to very clearly
state what it's reporting on.

I'm not sure we do that very well at all now, I'm looking at
__show_mem() ad it's not even passed a memcg. !?

Also, if anyone's thinking about "what if memory allocation profiling
was memcg aware" - the thing we saw when doing performance testing is
that memcg accounting was much higher overhead than memory allocation
profiling - hence, most kernel memory allocations don't even get memcg
accounting.

I think that got the memcg people looking at ways to make the accounting
cheaper, but I'm not sure if anything landed from that.

