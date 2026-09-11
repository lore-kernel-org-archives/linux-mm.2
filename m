Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9273FC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14ACF6B0092; Fri, 11 Sep 2026 07:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE1C6B0095; Fri, 11 Sep 2026 07:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013816B0096; Fri, 11 Sep 2026 07:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFD526B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:32:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BE9A16015D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:32:19 +0000 (UTC)
X-FDA: 85201267998.15.45179E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9FD36C0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:32:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngM6IP5I;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789126337;
	b=PCOS9hMCGPtAUVbsh+Wkm8p6FNme2pBIDnOCJz+cElviXhmPYBUkB82ieZSUXViYYd+Azh
	1p+g+SIV5AVpuuI/1d8C3/s4XgJG4jvWcT2sf9J3Z7HDwx/0mRLi5SMRs/9/FxTRm7kBdw
	o/ezfHCUvWVEaZvLrfoEJWWvoM5q4Zc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngM6IP5I;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789126337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcwyVbWOJ/TfKmQoQX0l+SJ37BAG5DpRv7tbIYppDXI=;
	b=Wa8gCojpLJOlQn+KxXK+F1hIeHfWtaN2zu6hM3WD8ucq2vAU+QhfDRXtVO0d7VFqJYnUCp
	PYQZ8G1zhyq7UGa5ExuMEE1iRpVhzeFyORrbE5Ci9yxZoBJS8l9rov0b21kcr846Xk4adr
	yWkMVkpg034m9k8E85bjsQffo+KaFS0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFA87602C2;
	Fri, 11 Sep 2026 11:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC751F000FF;
	Fri, 11 Sep 2026 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789126336;
	bh=mcwyVbWOJ/TfKmQoQX0l+SJ37BAG5DpRv7tbIYppDXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ngM6IP5Ips1PcyuAaKQbkTNILTCi2yDow4kz88XMamK6hQFrzuA/ESPzyS15dRNbw
	 FdmWJsmFkS9jr6N08h2gs/F3PaZPuZy17cbKN9gZCCvBPtGmHPOR5WqHGMbM1iAcUZ
	 NQ4r3k53OB3+Q+fPnQK9UrYKubf3EN+9cILPUQ7k9qlBmQ/s64uSpA/sp/ohSiVFPZ
	 wdrRH6e0np+Db0X33f+GJ39tvmT/ogqM8iLLHiV4P509K2Qdx6kxH1uMTifIVjkvs5
	 p1e3ZDZ+YAuHokDI60IrEgub3Letiv6f3QEpSVAuPRbmp6ESv9FuSTlyEydhvTspWD
	 jhxYV0ocEITcw==
Date: Fri, 11 Sep 2026 12:32:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "zhen.ni" <zhen.ni@easystack.cn>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
Message-ID: <aqPmlw8WYW9HSzIV@gremlin>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
 <79548641-25f3-4ec3-a549-782fad168962@kernel.org>
 <6e8bfb0d-d595-4e6b-9536-0323ada57e25@easystack.cn>
 <b8e23456-00af-4097-a769-210a087d2b90@kernel.org>
 <22D1EC4B-FBCB-421E-B8DA-345B5F3505FB@nvidia.com>
 <d8d34e16-57fa-48b7-93a9-afbf4b950ce6@easystack.cn>
 <98ca914b-4722-448d-b5a4-7f095d0ca433@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98ca914b-4722-448d-b5a4-7f095d0ca433@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9FD36C0005
X-Rspam-User: 
X-Stat-Signature: xcgwiyjs9ncegg5oi5gjyumxuxh1z11j
X-HE-Tag: 1789126337-267986
X-HE-Meta: U2FsdGVkX180/89DLts53fneVdlcL4++306uf6EpHLcpuZnQ23Gz3CfJfOkccNbDkVZBNK3sm9fwI+iVA4DMA33NB1Bz0yRcSn6UQLpF8glMF2bIp82pvs4gkR3o3zpaNPcWVB+Cw4Vu0WmdMqCPL4YB+bb3giqmH036eamaiy29XZzL29XJfarA/+V4Y3kw2qfj9+PPEMkNvss9GhNkIEUh1Pi1NzlJP2a43hbMeKJ3m7GAw1PAsVvlcr4IyPus0EV+8Mr9a4y43IR499Dmad1VJzTHaVdz/cm+OnkzXtJe/lzLEYrfvHP+n7N8KDQLoyYaWDhWUGbBZLrvwd/yR6cpjLdIcaOiX4ztmOy8pI5G3g4gEqm72n2yfrvlN8kAKP390+/cPH4F/9A4WjLivjs/Df//dlhH/zJVqMinWiX8fBZ/sU49cakOZpXjp9quYny4Ef34R2KrArSuyTNKQiHay/bwj2mpGOmbYiMsxHD7RtAubBJrJrmriyU+DQ2lFEhk5fpj83ACg4MoO+eYGPqZI8SZItRaTH3cM+rcHD6g8ar/44ImUmmU9aCEBKkw7wNMCeTBwD0HnFh++kUpaC6GX846IO+IziJrXpcUDIzP9A9B3fXAsAWDc9R4ZIXpTSaUib+7qD8r9I+rpGrIPayLhaTOti0/gdKI+CkJdDeqodqJh28A9rEYoKQm8y7MgaqdN57kvILikZuthJV5LZ4ue5iJYErlXJCDuMHOCU85ncrICeLJHELcuUcf6Nm9rrT7Lz1wbij1AdQQ0SQ7/WIXQ6sE4N69iJcGkl4Pq2b6oTW0AFZLr8sJ0w8tKK/PaRSrLMj2jTzsD1zoyOjq2t6UWvgpwcFWL3nLbEmMN7C196O0/o2xUelS0GALQVTSJK/4bVOYzJKK8+ImVnxMXvoSr9cx+KC3wL7AWOVmOyo+n3kVMzaZObUa3q/uEpQuG8HFGWC+GRhtrFv6cwJ
 g7Cjbtqu
 EhHwQDf9Stl57L9B3Z+IeZOgP4qT/oAIV5E44hMdV/GEGq9wiorez/mKSfYfWdOMRUppSiKg6nzkFhhf8wY3WTBkhTVqzj+9XE25cQx2Qd/7g9/VYuLGzZV5QP2RB1+ujLtojKa6pvM4V66Fs45W2xO9LBFmbapQHegek6Ul4lo90Y+6EqAXQ4SYozRZr/ssSFBi+Z9wWIJgzTSchWrYBA7YvorElgnvmwhmWkjQvY6yPJTY19vBpwnorkzOnpcIUAcAm3eKa8K4xabYiasc77+BynB0+JsoU3ciQcFa08HOhwu99uwK+VnSqflN83YVMT47/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 01:06:46PM +0200, David Hildenbrand (Arm) wrote:
> On 9/11/26 09:58, zhen.ni wrote:
> >
> >
> > 在 2026/9/9 23:54, Zi Yan 写道:
> >> On 9 Sep 2026, at 6:28, David Hildenbrand (Arm) wrote:
> >>
> >>>
> >>> Because it results in less kernel code  :)
> >>>
> >>> And less kernel code is good. Unless unavoidable.
> >>
> >> An alternative is to add BPF hooks like bpf_iter to do the filtering
> >> and by default, when no BPF program is attached, everything is printed.
> >>
> >>
> >
> > I’ve also thought about a similar approach—perhaps a new bpf_iter type
> > that could iterate over all pages by PFN. The advantage would be that
> > you can fully customize what you want to print and what you want to
> > filter. However, doing so would require refactoring the entire
> > page_owner, and I’m not sure whether it’s worth pursuing in this
> > direction.I’d also like to hear everyone’s thoughts on this.
>
> Certainly better than having more and more manual filters added to the code base.

Agreed.

bpf seems the ideal fit here I think?

Means that those who want this information can get it and those who don't are
unaffected.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

