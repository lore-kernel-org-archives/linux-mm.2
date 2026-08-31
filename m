Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C77C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF83C6B0096; Mon, 31 Aug 2026 05:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8726B0098; Mon, 31 Aug 2026 05:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDFF6B0099; Mon, 31 Aug 2026 05:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3566B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:00:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A19A803FA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:00:33 +0000 (UTC)
X-FDA: 85160968746.24.E8AF263
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 398DA140008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:00:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBSlpBM3;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166831;
	b=jVd3KgPrZL64ArEcsHcSc1lREN8cOFgcUrVmCYGSW1Zk/DMokP3rwt1IxFR4Z05QLK8ozW
	MJ7hBj/2g6M303wdcgviEmwEVBXK804DUU9xFLNM9T1iVO0TckmNc/+OkGV8iqlqZq2rK6
	oC5LjdPZ2NGoWc7LQI06ds1wwHz1A3o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBSlpBM3;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiaBSXJBi6rfRQ1EXaWCLbqzNjxGYuKOofbpERx7Asc=;
	b=Fzexvq5YkwHUXoix8WZ0qPvhHFJAhEAji3/aw2Acc5H8WmdNPKNWZxcu0TyjACbQaxdA3d
	N6yInb4R3zcvvRQxQFMZScYzO65+lv9s7OWj7E7y+VvYrx3IRraMbhiq8+FyhU7Ysb2w4y
	lsWqsMEgyilQM6teOtgOQx3dxdkfEMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA3DF60120;
	Mon, 31 Aug 2026 09:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2663F1F00A3E;
	Mon, 31 Aug 2026 09:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166830;
	bh=yiaBSXJBi6rfRQ1EXaWCLbqzNjxGYuKOofbpERx7Asc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YBSlpBM3qQxhUTKpgQKzFxHcBOB3+VaCkWi2TkVH59ldtGZ6DaywHXLYSMFvkxW5h
	 s0FaChHAjiDMokRv+gbYrBPSsgUHkdIDHBsXjiGELSSUa+03c/RdGm6SuBOAPxgb/u
	 Gu1VIaxg52dXPVM4e2NMQAT+BVJe/09WFSfhgyRQsCoEYdMjgVCFCLHNfRhrowhpht
	 Ja+RwLpavHGeAt1aK0yP5F9p/alvMpCJKOI4SI60NPaj9dNU6gYcPBL4aO2mE0EXia
	 jP6t9uHVh7VGnHFAgf+aKMHDgyFNAyZbHOesd3u1wTr9hlQ4Y2s278YDg8G9kix9qK
	 XHgxEkW5OPiYw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9AB9C198006A;
	Mon, 31 Aug 2026 05:00:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 31 Aug 2026 05:00:28 -0400
X-ME-Sender: <xms:q0KVarTWUxIZ-YWiiUoa8AByKpiLKZjp7Rw3brnMNmduI3pGyD7wmA>
    <xme:q0KVakotM0EIn90XkxjBctLYg4kU1s0oOv5u_rzNHDx-_h9feQiZSiE6zVBQZBKub
    AUM_1Me4OslDjJzmBVilufJAe9bUDU38-L_2vfGhvrzHx_FJMGoJ6Ya>
X-ME-Received: <xmr:q0KVagMkZl0wZZXm9ow_MQpIqlNkZ_--RvNJs6IqNuyuJaWsZW5fuu7_JHA>
X-ME-Proxy-Cause: dmFkZTE6YXZFw3+0yBIahT0x1LPBTlLLZPuxttiyblyXs72KxZl0B/BdM8FboR3uFZpmnj
    xQjPg3csHt7ujcK8dNJIqYh0ts58hJ27jINv/WvCff/ceCLegfw0ekUkhN0Xag1WcHlrEi
    XjGEUmBOGvkdEr0kVyPiy1UVa82lgKtzW4NP7lsBEe4ogL3vqpHZ3Fv54q6YS5VNUlyrCT
    5pWONisK57Ybw+poo99Z/e5+3wFsmLtp9D/Mv9oJlSUw+9xU1wc2ITnPrahkDyId3JU8cT
    57WcXuuDVCUYqvpV23ZTmp5iaRSmxn+0kh8QOySmsMdwPOTbmphSj6tw2OMFgIdAxEiEIt
    9WaRQYkdn1zu572C4N57kMR8/8AihkhnnYo5NyYV4lZ+JY9FnkDkmBEW13YRymx6pYs5c8
    lbPBE5IntykebJBMsz8z5TODA2suqDR7IAtoaoTr1uLJeNQ6NWKd87ewOMOEN6gynDekCY
    NIxwjNvXubdAqKil5v8RFGa2cVFUS9szwHmbCnBYrKoPgqMNalPP+QX+HphwiIJ5Aamu84
    tS6JdfrAm5by+W8VIWNxJbgsU426PVeuN0N9YlTSjhcYdtypltSRlcH20Cv+8QcS29WUsp
    D74YDxXYqQvzOOOMG9sq4vr2O0XFLaXwqStH7TkyVu6whkaW3SuOb1kp6RWg
X-ME-Proxy: <xmx:q0KVaiyP7WlFpjRyGeY2IVByRrV6xzUN3QtHIi_QX6baM-yknjYQnQ>
    <xmx:q0KVasy73Ywue5nTMPzyNQW8Vb-G6p1k4UKXGuu_IWQyzmjnqN8yww>
    <xmx:q0KVarJZLq_dIaItqI6zd2oWeZnL6ufX8D6WfqYLg5zHhPC91ESxVg>
    <xmx:q0KVaoho0BiCc39jyRLy316DOVxXJP6AspKmjcru7SgwqxcxzRoiGw>
    <xmx:q0KVasPvBexZMqfnKx5GGaziSCPs0nui2LO2V2plksQvuz2_B78inLAQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 05:00:26 -0400 (EDT)
Date: Mon, 31 Aug 2026 10:00:25 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/gup_test: report actual pinned bytes
Message-ID: <apVCWCn8pXrR7Wrv@thinkstation>
References: <20260831064808.77768-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064808.77768-1-sarthak.sharma@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 398DA140008
X-Stat-Signature: gihackofttz7bbzbs44wrrjzd94xsam8
X-Rspam-User: 
X-HE-Tag: 1788166831-60528
X-HE-Meta: U2FsdGVkX18wqMQBKYnowUE3h/3yrh74YO3oY/WtnBicnwTS2RkMymmsi3GMwLE1Pg5+gWs1qp4eNpb2fuQ+jVqS+crwIovDSFY2rOxj9Sn7rePfd3W8SiLw6lgIYFyxTaDf1K6jXyHUmtLlgJzXuNeY3irRZxAKRvHgpWymBcm3sdGV8IUYzbR3krbwDyU3Lzt6McaihFPylcMV+gNr2eomPAjpIvwwpaO9DpiBL/ISE4p+lOg4dV05SvK2cDYk1QYfIPbEX+0yaUEoN4IjBeTqJaayM0lUcjOtQYj694d3BX0ZW6zKE1a1HzBTzHuhxFwElfTaNSyFSbVA8kxDnZX4AaUrULbgvfCkI942z1sNOVsPVU38E26xVmRGNTcMlpMwj0nYqsM2Ok7Ws6BY2T3svFJL5Vm9tRaBQs57WGvQ1nl/0zg5qMsfXqTAYFV9dVnhc3iEmYiScEbGFCBma9OdurWg2D0GfGknI1vX45jizjd1QRrChrBeh8mp4RR7Jp2l/i0enB3KA84GPyIk6PkfnVwpUnv4fWPYmNp60AF+aGo6a+Q/UDdtSMdaiLii8RKo6hRnkzmHkwloUKcFZPbyxxzkiY1bqy7693i55+SO2U9bsDA5cVp0pvZLuvOwStw7JDDUXV9zcBOZL7lGaWSzzA6GD2Oqt+FWHAHiBwZumTWlTM16tcIuqC0TXQmc03hmnIohBbeoSheox05s1/mMW4s0Bs6OuGeKQwwaWalEBDzQh0ePlFq0oPwC0U6jZluktjaQCeJvDa5n34bK3pzRMZb7wdWLN6IyBo8tETRD2VIjH4NXqJsTVUFkOWlHSUr+GZOArNguFCR/lW+UPCUjp0TzZheK8m84G7OtSspxtbWn1048mr4QxPWZetIe0eP9dK7gQ+E1xEIGRWSw9r7dgogGFd2WrnDnTyaY8XTG3b7jt8MyOQQxdePGxRU16Az2tnvecXl3+o7Tqqd
 Dw+xOBtj
 U2NMYG0fZWw8eQqKcy4OpjkN3V0jvBZTDZOljD5fcuUcOIawa6I4w9DtVC37YFHXO/Hh8XkXwlGfykmQ4iuAYomUOGizNlmPqvp0vHvSGMntmyzrCsb8ONNzs6pkaAOohPTO/kVSDtsRa7Wi9iVJhImyo71ya/tA83ndHTtGtqphJbO9X6UVMYovq3+1jSWhnAaTCMwZQpfnQa+1bLCK+E0mRzUjukQ2QMGBLabDw5TSmtdjhAk8eMYeDziM+KWLzrQzEoxvc1Xtm9XTR/Bidx1eCWM8/6O5JigMKHnXLoyoFh1SygFdfxuA/3GB36G8qEOMNjsm6UhKMjVWYiJ6IOkoe9x8bCjTaNrQHHhMQ0pMfo5/evB4qq9CKzqIenfdIHzLKtkH7/EZj+7rSen6e+QmCjuACD9NVV5FuP8pPryn8l5TecVjHMYMoPqo5h6xNub2gFIaWLCbCvNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 12:18:08PM +0530, Sarthak Sharma wrote:
> __gup_test_ioctl() advances addr to the end of the current batch before
> checking if GUP pinned the entire requested batch. If GUP pins more than
> 0 pages but less that the requested batch size, addr still advances by

s/that/than/

> the requested batch size.
> 
> The next iteration detects the partial pinning and breaks out of the loop.
> Again gup->size is calculated using addr - gup->addr, so it also includes
> the unpinned pages of the requested batch.
> 
> Calculate gup->size using the actual number of pages pinned multiplied
> by PAGE_SIZE.
> 
> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

