Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 719BBCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 17:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FFC46B0088; Fri,  2 Oct 2026 13:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B10D6B008A; Fri,  2 Oct 2026 13:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6696B008C; Fri,  2 Oct 2026 13:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 264EC6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:00:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A4E814066D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:00:45 +0000 (UTC)
X-FDA: 85278300450.08.DDC4F42
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id C3F128000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:00:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Bx7Jh2Ui;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790960444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJy1Qq9QXYhDTSQZfMIIfxPYnTxZfhbwrd6oubBqbQU=;
	b=g7d9OxWl3sqvjGwlDyRpZBzZ/BJfZnr06xAvDPZHLkxLE+3+8x+zNTK9VptPTixjkg9HUM
	1CYqy3LrKHf/838RKGQXo10pBcSfJtVwQXZXmbbXBfTjjBz67xSTumhJkSnNC/DecAvFDu
	oq2SAu5kGuUj2pBhXqrLrzqbdBasiPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790960444;
	b=lv+jE/7orF+fSq/x3v3qTYTGehDJBn5ze18yenebmY8iFm4jXNvCXR47tEPiwZy1Uk63wY
	GkJ5q+/5a0QfA0pnD/ehwyNM1iYRAn4xjhG9zMpfogSP/yBRXRvLFJ/NsUWQMmayCCbyTu
	m+seomdl9nSyO3OOHBN6jFxPbST+piM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Bx7Jh2Ui;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yJy1Qq9QXYhDTSQZfMIIfxPYnTxZfhbwrd6oubBqbQU=; b=Bx7Jh2UiCpzk3D2s8Y1YbPxdAC
	hI+0WBUKGE8EicUVoB/3D9bvWBdvCAhv0mHdr7tp7bA4ujyiYrIDoFMogmv6caxWTWkJHHpKPFfU0
	K9bkZUNxSiJoWqH3aB1T0+HtVzUM5cMlBIezJ1q66RGDmEt7JEaO3tcayp02sK1pUlrYV4vinOmq4
	m2iraajzLsueZXXYXZxY0WW3aGNW2hewOvoKmyneAbDorOQuI66/ojtgqUUaSZVOv2mXpTJxEWL+Y
	dpvqosIMP+PWigL80lN9ZsT5BQxQR2j8TEvOMESVtOsTtGCQStLHBEiSHMVq+XO1rjEbPpiYzZC5O
	IQPjpUlQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCgcT-0000000C6BW-0a6i;
	Fri, 02 Oct 2026 17:00:25 +0000
Date: Fri, 2 Oct 2026 13:00:19 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: ljs@kernel.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	brendan.jackman@linux.dev, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	rostedt@goodmis.org, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	vbabka@kernel.org, weixugc@google.com, yuanchu@google.com, ziy@nvidia.com, 
	bpf@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/compaction: stop repeating failed async
 compaction on every THP fault
Message-ID: <n7lq44yl6imw454jrwcz52se7dt3qesdcnpzzlb3wf36ixa7js@oatar73m4g2s>
References: <ar-8Vkchzn4QobA6@gremlin>
 <20261002161744.859093-1-odys.yuan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002161744.859093-1-odys.yuan@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3F128000B
X-Stat-Signature: zemwncdxzbht5wp5psji74cju8e5dwgg
X-Rspam-User: 
X-HE-Tag: 1790960442-549687
X-HE-Meta: U2FsdGVkX188B6t7QTjB4/DAY1odfrKbSi9kWG48mDBgMcjcozI8kPNhlygZYYuY4wxD3jUMOWXeyynvoMN07z0HDbru/JryKnYppjJM7q4Ln8eIa45pmYpeX79qhjaSzZNO8nRligogGarjMgHUC4AO/i6IK2OVDN+e+tPnTuOy8/d3JZcWxO1m/6Nz3aEUJ2CZIq15wJCY+Kjzr8aKkp2H8HLHU9YqFhvRApmJXDqVlbyoaSASXqDD8FAfIaGZE8eFNbT0uKGgdoJRDXa8o1piuoOs4VTWwKoXEnS7a811j/BM32tY7ja3WhYQrLZU871oIenTyYb4RSk3CuVmxhU397cvPImdLF/GzcWwLXkQUTkYLDWHouH8m+FdAALeHd2WvPqC4N37d+/R9I7VVqBKzE8kSZnkM6eQIGC7URVYcfsJjDsj2TqHoJp2kGhPT+JYncxZ3fNAGXiu+VH9SIdlnqYb0sbc42wktA7BIGJmMK93/0OKAxw4LwqbrDJSCuJ51o4eToVOzBnijfjbs7iEUn5PMcVlnXzZFCWJPiBxBo9geMmGBcHeJ0l4gu61t1SyoSJPilS7pSCWwcQ+U88FcHH4xoQknmiCKIxQ7YM34+BpTYsL4GmYugSmTgn2CA5uxRo8/mfFmVo8aNtTdhXm35UqEyvEmdIK0g7L1ZfxXuK0s1VH9OJQGw4yWEPK/J7NmPsmzZh9ykfDpbMGyU61jFInNNf1WmTwPFsvA+79R4oX0JNrjeyGaIOk7IrnETsrJ/GrzFk7w7ICa5bMS1tzCLH//0F69lPyLA04lztzvodpCC2ZiJgq9w2HMmGoLyaf+8L4M3V5n+UtiKZ4QgnYD2Gl2I2ZQv97WTd6RsyOQFhtLK1ibktydm2VB6m7TTBqmh4+eQGBdUjeMQVVF0ej7EOWc4EKS1RgNnJOLKOnDSd+nzBixImyeZAEYR9H++3AemO+w/E1LnGmvAi
 0iCkSKZQ
 1uz3CNzBS+URqR2c0+M0L7wc/NLYV3nMcy2X2SogdbLg+ORasMEFzcnwSTKouqiHGVAxx66MvIy2pwmNEJsSoGl5fqFRjTA6B5NpoHyrdpsiHc3WEuPw4MShSblfxig68oC9fNkLELSPW4YXf78Mrh++L2rj8c8LWaTJo/JjwiY6xKLXiG+t2qqtqSN0eUS7qklNugraALyZqjYJj3Xxzg6p+J3RE4qtZT3AlMDBUIXkiuBYt7biKpcSmZEogkrdQMld1/VuSXki9KXyIo7SmARbp9M/ZVA6sPRmNKXr0RUxM82V3HyCfJuiIrdXw22oqt2rWgj7Bcu2tJvNlMyx1RCL34rb2ZXBZSqMk2o72X8K0FC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/10/03 12:17AM, Qiliang Yuan wrote:
> Hi Lorenzo,
> 
> Thanks for your review. I would like to respond to your points,
> quoting your mail below.
> 
> > NAK.
> 
> I understand your right to NAK as a maintainer. I am not asking
> you to withdraw it automatically. I am clarifying the facts.
> 

Nak

