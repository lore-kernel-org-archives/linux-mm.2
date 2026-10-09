Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89A1ACA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5DB6B008C; Fri,  9 Oct 2026 13:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE326B0092; Fri,  9 Oct 2026 13:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B2E6B0095; Fri,  9 Oct 2026 13:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF506B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:41:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2D0F1A03BC
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:41:00 +0000 (UTC)
X-FDA: 85303803480.04.26CF98F
Received: from mta0.migadu.com (out-79.mta0.migadu.com [91.218.175.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id 533C0100003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:40:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xaMle+yZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791567658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3pP1wZ/0wIS+q0055mFPR0sVyvn0jvMzquAuF454us=;
	b=15Z5Qqj3neGrNIwFsZ6pdGw7YhiceFsknF80wgtEEK137MJvNghSJAKG48SE1UsSwENqcP
	e8dQqOtBNFS7xARd3hZ+gGa5GR49wu7MfCHDBcl88zlTxqD2Jrzkv2nbO8XGSQRt6vK2/u
	iLP3b80AR+kEzFuwr6wKh3tQkMUZOuk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xaMle+yZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791567658;
	b=j5MywXm0eMrH8p+cIrEA23IfN4IgGTx2iqCSmuFzE/r18/Hsk+cVViiCH0skXXmrjkvyNI
	62Yb/OBZxR2LyAoSSsdRLfRP6YYIqs0F1jQdzOUCDibqAXhQoaE2JDF1kUlaRBej+FC82P
	tmGmCAoB2AjGoYNpo2muMnC+g/kKKLw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NCJUfRqteXNa9rV0Ul+4wMwjj6UjxOxMpqC4BSP0B7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791567656; v=1; x=1792172456;
 b=xaMle+yZrk3JCIMZFC+5PNJ+fLbORE4xEONXDNweZB6hqTcZ4IpWDRHgVd1XgK2YiU5Js6mN
 HwHBPL/MEdTlpCl6YQ4zvkK5gI6H6Se7GuEIMmuIfjRINhsloxOLN0kJwz5BIWjpCWxM8B6qwz3
 qWjXrDITG2MLB0SBjAUySLIo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 63215eb558c466a3;
	Fri, 09 Oct 2026 17:40:54 +0000
X-Mizu-Trace-ID: 63215eb558c466a3
X-Migadu-Flow: FLOW_OUT
Date: Fri, 9 Oct 2026 10:40:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <askmzoB_Bcn1BfCN@linux.dev>
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
X-Rspamd-Queue-Id: 533C0100003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: gqyk91kqa9opfyr1xfq8qei59ieci6xs
X-HE-Tag: 1791567658-170869
X-HE-Meta: U2FsdGVkX1+2d2nGj95d042n9FM+ekt9Bz5HSBCjge+Hp3ROvDgWzzGVWIj8hE474m2Y9HkW+n/MyKntHTiSxV89U05h8/WJ1Xx3GQc4/7WcWXf1DhYHI1Ia0chGprUpa6JwgRXsV2dVK1TBilh3ihN/VYso42u6P99lLr/kQwFutocWqpNLzY6/g6mr5r1a7yoNDNiCOknRWhsGUON4fdsJcsha7ESR7GVkFr9NrWAgyCwJtLaCAewRonNQCg93WAGqfmJcosn9jP6r30ijLUI2fwCi9mfOBl+2+WNtqZCPIMvAVVWW6Vr30tyj9bbeTtqNAJJxrRbrCGLZ3cRN9nnZbPVTZJKzJqhozvxWJaj6iy/dXiDkbwgaQgASdv8SVup4/sVyxvNPFCD5ZQCm/0BFN+H4xKN3s42FnxQviAAhB+Sp+UMKmtHQ+oNgqU7SPpWXxAMmiMsyaGAon3+1g1VMbEMWXlzEpEM/H1b1irTejSQ48TTNBimz0Q6IsT3EDwld8nMvOYu2YIwC+Xi7yvcQYOLHEllZNJ3kTXP4idJNG8dX/vL1X3mEf//iPiccWtfYCr8GJO6Ash7lASV0tDtNxuUlC+ANMLaauHSiFUmDrAUFbPFU2gwRFV7FNqWjQk+iCvTtQs+K86g3KzyYQdU54qCJk5Jib0RFcOxv3qnFz85yiCYNVG5Nbi4fiU8wnmZWvMIhFLHktEVijCRSXPoyCvWy6dzm8Gw/wKcsNaTHOJkygb1C+b12MEe1hcOohFdJs71fOzaCnQy4WcR9+7SQmWJ4i0WVLKbITIDOQjxXEUhi55EaKYGipihCAUQx0ES1i1WRcq5zU87N4hpUX38mppn5mupMvHQtIbKQty8zx/6djAv+gcKKzZiuVOheuyMjlWSVAEtmlQ7msOLleJNIg+QLGRbNpAgE8TynW+2yrW4+MoZ/S9FkgurEWlIpBzJzC/E46SrEN/H/SUo
 qZvpsOr6
 q1GGcOZVnNQcVNCxCqf9BUuRJDWcaj/P6TXEMch0HJxWxm/8qECszVSQMLyJEoSNtjCMREnHpHcF7t7oAL1eP4BazZmRNsQtWi6MZJrRtSrol8l9xLMMydPTxa0zmPyFmHdLZLNot9Y8EVyPeMBP1/Lp80K9i5cSA2pQFZOhAR7A7QZO4hEgL6QAwGJuCN8+0rsVpig89p+OFJRGIl7qduu6vWD/MBjMBzPwfO764EXu+RLue9WhEDq5hof0+IuIdHKjZWWaIMFHyBtiIT8jDXKDtI4nMbJDN4xA/rMbUJGWUj3GhASa4kSZ9TIkv1ycdJ5pQEwv8gl+ePqIY69yGscczj017oh1VBMoPsII8DmPe6VOJ4MfFi5KTOQ/EaxZ8xy/L9VYUwqSILZOv2my+30GFhl6lpOiE+B+wC7hSu2jbjLVOYgzM1Fw0HiRMBa2mQU9TJvzr8r3RRKiXWN6rNntPDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 01:06:28PM +0200, David Hildenbrand (Arm) wrote:
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
> 

Thanks David for pushing this.

Kairui, Chris & Baoquan, please respond which time slot is better for you?

