Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4247AC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F686B0095; Tue, 22 Sep 2026 11:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4673D6B009E; Tue, 22 Sep 2026 11:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355BE6B00A0; Tue, 22 Sep 2026 11:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 153F26B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A80E71A0509
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:28:59 +0000 (UTC)
X-FDA: 85241781198.16.636E823
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6B9A4000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:28:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S1vE3SWo;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790090937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYgOVFKFeoXu95gZThsTIlBrSd/v03U5JPUwbWE60eY=;
	b=39nUsakGAYXGbnesmwAZE7yvzltGDysjNbmkulUMY8sCdcaYzP1IAjr5mYlItm13jq4U/Z
	o4rgR8KprBhTjgNfDz+H0MCSA5I2hPRq8DgjI5WWx4ljNI7gZ6+jMfrvVgVJa1+1R+1qVa
	jpkVcRJq7qh534+YUpihF5qfxDdmWVw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S1vE3SWo;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790090937;
	b=VnIUWQwSEZRlMuIhCk905k1GQNezdgTZb2oPtPDMAhOIm20U8ITl4l1cCmxG7dHGz4uMIF
	BPhYUPrTv4s4GepX74MOw8MM1HlRcwUVrL9Hvt5iiGBPsVU+l7NI68szTq0xf9huSE/o7v
	26ZsCtpUjQOH4PAcbM/Eh+bpZwQ/1CE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yy9tOrtBWQOwfMGkz7znpOTF7ArUWzbkvnV86SHmbek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790090932; v=1; x=1790695732;
 b=S1vE3SWoaAoNMoHV1A2b0ZMVEpHw5mJcZXDPUnpFkWYTbXOWkw5ajVXr3cbf0Tf/6TaAQ6OC
 s2GV7HIvXlLEYN87kDTlncbe1lm5swthJDBaMe12ayGCLEqS8IOD3AjGHAA2bOty63VUW+QdY0j
 tCDH1VmhghHLUD8Nri7YS9A0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6d3d1a28fd5fcdf1;
	Tue, 22 Sep 2026 15:28:52 +0000
X-Mizu-Trace-ID: 6d3d1a28fd5fcdf1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 22 Sep 2026 23:28:45 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <ryncsn@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
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
Message-ID: <arKerXANxjILrKNs@MiWiFi-R3L-srv>
References: <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
X-Stat-Signature: uq8hhd4g5g5t6wzikmpzzgjdcogxrnkz
X-Rspamd-Queue-Id: D6B9A4000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790090935-932256
X-HE-Meta: U2FsdGVkX19zKyraoWbzMUQ8CRf+LEfTfyxvT6/otRTWA3edr4qZyJG0c2R9esU+HSrYwo7E08ED7hmpNSNjdpWF7DhwahIGq9XAsTVq+ZvBpXh1z7HTRebhQcjZWiLZNezvRH5EUKBnuIsWoR+glrTHBc+KQnpVqZQyVnoja7rXkWHz+YcaT+YL4e8XL9Ilk49bdyTmgjYEQsmWWJfP36jXJ4DHDGJN7/rfXsJnt+iVouCcZXPJ5zTMzWchlL5tJzcldyIz/x4bcvbYt/K2xlSGRytCyWbqfm7Ig560D8EY/ovwDuFJRvlb7DN8nSNt7ep7d5jrVbeLjTU3RH2vn31poUdP0iCamfQ/zehn0Fr7vZDNoPIEzjC8Vv4V5xNvTqAnvP0Fg4iLIKI8lLnQ9nWjCDLuii9pvfA01jlkKkD4zbv4dwuHMwYN7RYmwKz5DBnZavC+PLnNhxYh4kqjg9jB3XML+8aOOrl2psVUect+NHCtUc1MZ7Dv3PEkvZToOTFtLIz+OziKDr3Or9FsdNiRUlGu6UZ9SGVaVAzy6MP3eCIR/CTO/uNgkd5ZoMSGZmFmcB86Mo7AXLVMJF603KuA2bLJ620CkqvF0i807MYsXb1qrg09/jj7dFv429U5WYt+kP6P2ckHU0CPsj/kFPWkVFsDihaBVJ1zEw1K7WQxJoQwDTxqcpEMsmROZbJP9h7J8B9gFJOX0O01eF9UHV03xyTaaB46AAFroldzudtESPJVuKJV7bJ/a9NDqQbCuX+L68lt9m2YXltfe5m7XiglHoEyU7YhOddGk9o18nRxXbBofY/8HH+ORcmjl0acXFaLfKFzsulQorep81o/8/G2Z4wn/v9ZnfyVXiaI2aBH2GXiWj686+cpZC+1gN8yPaWeJmsLHgcDzvolGG8mwE5ttR0kzuEQMQhMVsUIpIlcs7/vwRJqgnbvIQRcmWZZnB/k98QrS5AcLg7nuvU
 cPqASloV
 QLv6gvD2To/7E+3A5mYxwyekIvAZUjKTiYaVdN/AzSwNGVcfPs39CiXLBA5lf1IxBcTYiwZbfXPHPY9azkCfFGT6EvkMoKLTB2Lj4euClgoh6wCwqiAksVNjMRgd1kN2AT9INBnCNpCYOQVZArPHDZzH7exwm69m+8/qr5S4RAF2kIcajj1nBgCDHlRpfsMa/YA2fbBnq3JqBwHt4p/QX1aBNOsibiugRDl4ZLnZjrBO3c1Cq3FGUx0Mo0V+5k5TqbhHI7uxRLYqRX48KcO/5gtX40ylfdrHZaQEvvOhbXxOd5sH8MFzeG0pupA3M7Ty0QVLlpCRPBGWEC7d9h9fzjoH3hKFTwhQEy5FgLVPr1qfrsh+XaU8WAimDphAvMWdtTmj/3EJdMos4iLqrTTWnIS0EBkyJBYng54Pg0hRHfSjUxutTFYgD8XRrf1QdsLXCp4nrPD3wxjoJoPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/22/26 at 04:56am, Chris Li wrote:
> On Tue, Sep 22, 2026 at 4:43 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > People can speak for themselves and suggest other time slots. You do not speak
> > for anyone but yourself here. At this point this is derailing the conversation.
> >
> 
> I am expressing my opinion, freedom of speech. As you can see in the
> previous discussion, Baoquan wasn't able to join that time slot. He is
> a major shareholder in XSwap. I worry that alignment vswap vs xswap
> without Baoquan is ineffective. That is my opinion.

Thanks Chris. I know you are trying to involve more people to join and
talk, and I appreciate it.

About the meeting time. I am in UTC+8. If the meeting is before 23:00
my time, I can join. If it is later than that, it is too late for me,                                 
and I can only discuss in the mailing list.                                                           
                                                                                                      
But I am fine if other people meet without me. Please do not block the                                
meeting because of me.                                                                                
                                                                                                      
For the discussion itself, I know it is a little hot these days. But I                                
still think it is useful. The disagreements are becoming more and more                                
clear, not vague like before. I can feel the consensus is getting                                     
closer. So I hope we can continue in the meeting or in the mailing list. 

Thanks
Baoquan

