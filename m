Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF876C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 18:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D1E6B0088; Fri, 25 Sep 2026 14:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DF76B008A; Fri, 25 Sep 2026 14:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC456B008C; Fri, 25 Sep 2026 14:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE456B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:47:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4B4CC070B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:47:15 +0000 (UTC)
X-FDA: 85253167230.30.BD6E1E4
Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	by imf31.hostedemail.com (Postfix) with ESMTP id CDF6D20002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:47:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0qMOSRQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790362033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnfpE06kXv51zjddsTNXCyJ/X0PJFwjumW83TVFRLVY=;
	b=2ZymttEW/mZmCUWKL68wcyeDpd8G4MrRO+c490BkjnGb+W5aWI1e7e/e0b57jQIenG0jjD
	B6hp7HK/hlqnRCE2S7lFLvkzook8PVUuZmxvyHoowc3UFhjFQEDFDzByj1ncTqq2Z4qwpT
	CdRbHN4uuo+0ZN4Z7XeNcMa6bM+SzZw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F0qMOSRQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790362033;
	b=twYrWRjD5HrONc1IvxlDHuY/vvABo2wUafl9ll7WrcTvx4Uqv4imUMx09B8l3hPKe/avUW
	87LMr3b/oioDIgF8JiEXD889QTix85Lg8mhlGlX3Fzba5H92rcUy/doy6ceCpFgv1q8MCy
	yQQkvRpLDnQorav1NePTgdTNIK/5T5o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZDB7Cv/GoRAaoC2nMm2ohyzn0qw/lGYfH7aEvgoflCA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790362028; v=1; x=1790966828;
 b=F0qMOSRQ6JdStYwkIiLROThp5fhWQvDBe4b4+Ss5aOXnkYoUS+EptNCziAOUr88AjVPfSCn+
 XXt64a96e436lPhdtAfUhahXy0Pc33Gw4EH9BGe9dnb42OkDIfBBDHHKRXNY5soNMjgcA29M5ov
 OmtVCYoUKRoUjPceKbIEYC94=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 58196d26f865613b;
	Fri, 25 Sep 2026 18:47:07 +0000
X-Mizu-Trace-ID: 58196d26f865613b
X-Migadu-Flow: FLOW_OUT
Date: Fri, 25 Sep 2026 11:47:02 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
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
Message-ID: <arbA6J7n999U7v0L@linux.dev>
References: <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKerXANxjILrKNs@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arKerXANxjILrKNs@MiWiFi-R3L-srv>
X-Stat-Signature: aqozdoedkjny3m688eis563dccgtmhac
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CDF6D20002
X-HE-Tag: 1790362031-947804
X-HE-Meta: U2FsdGVkX1//Oiv9zIF2SO2svp8z2CsItpKcafm5czVClkGkXNNge1NLuETZjO7AhDtWIGk6afT8UJifnI8jRc1cIT7qTeaKhcxJgSKzvGjAzcwTaUJtSCPHQTRvO/eDp4hgnm135hr74UfsiOimudNooFijUShyQnRwzuHxtQP7uAXEdQy3N4yC6siPK3ohI/jQtxj5vgpV0N18MNnbfUv3ME/Of4NEiumq2pOQ9cmnD7qPEIWdl+kFn8qw0OUclL8MoT/eSCX0MojqyBvqqGVzYQ4NBRsChe2S49iJla8d5CK+/1Ns7TMVQmB1nnZVEp9mPNd5VaTS7/TO3UR1utGc34CICKj1iqA6ypJ2vTFBRBElyHJ5pECoYNmWAGozJ2oxGsa7opHRR8dvgwRkgUewTMuabHW+h5vBvIOIEHXltSujrWADxI7wuO2GUsW5n1ScZzNAeNtpf40X1fC2ii81eo/BCgqXE6GmOkEgVpKwjWLi/2drHQGoZvYluxguZzWqSyY98KHmguamCKZ1WYKkPVQ1kWPMSL9fya/nq077Km+Jv+1q1H+yloLuUq2nZdIVoTq15U0zL2jH6Odp8ttPaNKdV75PKwRiggBw5PUa3hhGY7A7qF9DXiSOQ3kdjwXI9jaeiki+bK4GeuuAH/wkkxOlM/hvnRFK412pKF4iGRld//EB/yCKOWR+8+f7iqKNXq9u5trFOe9RnuJrJJwEe/5mmawd1uxVXeOKv6lersqgPeA25a25wflHQXj7WYVkgftXvJXhZr9ZOJkVBehETY/iNVICrhk3b3SuvZq5wEvaai+/2z9boswt+cIUKFefYk7bRZ+WH2qwuJ54xTprgLt1wWYa8xBpIUoXHKoAqn3QajYvxzZg8WVWib1S+wxbkx6H5y2RPTCYRVDJOJ6ve5g00mTLESTwVRRB5zymye6FD2+L1EJlea0uAANJU2B2d6baEdqqEdPgFzV
 U8RFaLsl
 bpa1mOrQNWoqtOQKEMqKGN5YptO/lrV/ydwI1W5j0+WoREx0TUg+CYfEVSTwuFGVpcwftka98oMN2BZGqTYhkDM+XCGOyRlTUlPuxdmQLG46IpGl/ERtzQ1dtwOpcKwp883qXmP8tvmqLC0ojXZGsCTORtJZEJiCPZIXoFXQpEsY68oUx42rlQeZJFJC54Ra2CE9B4oOwA/oWiUmsLgqAuQHm8AomZ/SoH9gJJF4Ib3nwF2EmHyMleFs8OPueYC47Kzz4hdxhBzoX3P5sLr7v44gT/V6nPzKqa8a8Wcb3hHNVbm1KfzvN7y4q3OtQklH11TMVrT3PECwwmRdrShqnapOZWfh+DA3VzD+DO63+6ksBaUc0A3AbrLE7QH+dVESiICrtZsXSgtoThEi+8kUywKW/JDMKVAAxsVa8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:28:45PM +0800, Baoquan He wrote:
> On 09/22/26 at 04:56am, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 4:43 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > >
> > > People can speak for themselves and suggest other time slots. You do not speak
> > > for anyone but yourself here. At this point this is derailing the conversation.
> > >
> > 
> > I am expressing my opinion, freedom of speech. As you can see in the
> > previous discussion, Baoquan wasn't able to join that time slot. He is
> > a major shareholder in XSwap. I worry that alignment vswap vs xswap
> > without Baoquan is ineffective. That is my opinion.
> 
> Thanks Chris. I know you are trying to involve more people to join and
> talk, and I appreciate it.
> 
> About the meeting time. I am in UTC+8. If the meeting is before 23:00
> my time, I can join. If it is later than that, it is too late for me,                                 
> and I can only discuss in the mailing list.                                                           
>                                                                                                       
> But I am fine if other people meet without me. Please do not block the                                
> meeting because of me.                                                                                

Hi Baoquan, don't worry, I will make sure that you are present in the
conversation. There isn't much time left before LPC and many people are
travelling next week, so we may have to schedule one after the LPC. 


