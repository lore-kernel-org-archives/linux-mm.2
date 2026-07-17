Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D503C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB1B6B0092; Fri, 17 Jul 2026 14:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C7C6B00B0; Fri, 17 Jul 2026 14:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1BC6B00B3; Fri, 17 Jul 2026 14:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4A56B0092
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:53:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCD22C0218
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:53:52 +0000 (UTC)
X-FDA: 84999167904.11.1025123
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0BF02140011
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:53:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="sEIVnUy/";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784314431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EA5rWpqXq3j+AjVoHduxTotL9GnFGdK6qs7h9uZHdxY=;
	b=4j3A6MOT9DU0oymj79gIWonXLYHbe6YaVID9nnFTdr2yZgcID0j3RLVVrck13qyQM3LSHf
	rXUz7xBOK2lZ8MRUW2WvGSzPnWkwSfV+kREBhjpk1yGnxYN9Q2tFMyUsIcJkiUMqtu2WnH
	HQoXkWJqOuZWH6VmkDKlV9xclRpIdzs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="sEIVnUy/";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784314431;
	b=1iZqhPFCzxsS3qIe+bC/CnVbodMlScgXg8LrIyZmuMXN+53ZlnCd8PZfC66b4rXXsiOdh5
	tHOE6NMvvi23Jy9kpTANH0LW+l1/dxAWZ37MMiDMU09d4IlRTbFRznHqeR9opaS1hRQFS7
	ysBEomSnZ/kAjascVKAvg7KdoQyHj2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FBF54400C;
	Fri, 17 Jul 2026 18:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794E71F00A3D;
	Fri, 17 Jul 2026 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784314430;
	bh=EA5rWpqXq3j+AjVoHduxTotL9GnFGdK6qs7h9uZHdxY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sEIVnUy/f4Ud1WPRQdcgob1uu67veaxZHP9/36k8ek7nc9E/da7QRRXfS2zvT4wJ5
	 BF4AFZRLjmWpUuQEqlm3k5aqeW9sxYY1jUiLaIQ1r6qnzPG/fp1wOO7hzKUTnsJwzj
	 3PT3PtkNrE3yBDCuYXjTQASpmKMUrX4T0z1DFsZs=
Date: Fri, 17 Jul 2026 11:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
 Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
Message-Id: <20260717115348.9ff2498eafb8ea256a0cb504@linux-foundation.org>
In-Reply-To: <alplxFeazzK_Ziie@slm.duckdns.org>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
	<20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
	<7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
	<alplxFeazzK_Ziie@slm.duckdns.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0BF02140011
X-Stat-Signature: wjkcnij58m767e3hieoxxnp7tqys149z
X-HE-Tag: 1784314430-523460
X-HE-Meta: U2FsdGVkX187mhX6cuzoBMtK1SmIFNIpusXq17KVfLf9d/JWM183EDefkCb9yH5rr+uz+r2Goln4cWqtGwRZxBIxuWyeJBgh6ieTsc50MPKE8sDN7p1mFRpRYOtITLs9v33qIfIfKdEFwEYocOdvA8VXtcqN8AJNcBT9CyWHmUDHKYvcD3ZqzJMEuYziUwueDpQ2N2khuGNdQjYVljqzUX9HGiazexyF+AdtIfpxNsUB+bxakuylK0iZNOR+oQksmu4mor6QWJNjn4m99nDhyugVKcqY/isD2XggpBOoBNvM44osMVRHGFHP5KjKB5kMOn9CT+Ak2WK1ikSMP0cnP1V6yV77EvhLUxdWeGc+nQthS8CUzB57Hd35WmsuAKp/zOiw+frBXTVf30CM6kcvPxV9YTCAYqxtrRRhVQsBWEaNgG02eqdsl4jbAIapGS7GBXMZnm/MpXgZbjgG8UKzGsH2JTIu05F2FwD+5cbR/0roL1EhN7JLZiLeaDZHZY0UJOzuHjYHk3Z1GLLysyjQNmexF/+DurX1z6CoZn4Af8wHYGmPvatW5YUUm6vEkfrI49fq0B/j3wRsuQzEEq2E7H6yuZUsnyOOoRJE253VMjUfy6K6O2xdlD1PDCe1VDPtcmvqrIKwRoe5N4HruCWrYUHsLaUh3Y1WFU7+jFGhur86QVEebIezot3mG8Ed2fOeeqTu+nYXaOZo2YHOZoHjBae8IBGRmO2rrN+7iXYanfQv9cWnUCSQfgm+IN+q1OZWyr/B325bN8VWF2ZWjAbIT9jNxT4QHDNQAH7DjWHSWjZsGiLaN5Y9C5SXJWjiXquAGvjsRHi1cuJ4wMuCOfPtoHBcWih1rrU42dDPWLsQo9j95GQ/vuaMYKd99jniWNrybLs1X3WGCx+rXouaVbLVy0EomYPiJ/RmG0JlLMO1I3hthDbRNgXZMSLCYICg1/2ge7OtQBMNmg9S9wVwEBc
 cgVnDTBH
 6kcPJCiRQ/qrZ4s9lxNW/gYUWkW4s55LLypsWOngFrMFEgleCTZbGMXxyzzeAwJvEa1gqQPWqZuqVKR5KZrDaEPiCUww2N/FgWGwzdxfgRz68u5Yv0j6bDHKnhlXVPMlFKfN9yGAWrwXqJGRBRD1revIl9TdggRlV7kJtYj28gCs5H1C+He6WK5tQEJB4hM9PRbAO4edmLH85IIEL4JuqAN4PcoYbhLUv/XMfkgQFxYkI6A/EeMjugfuTW7Nyirrw2ETlqtoOGZR/mmzVcpTWzpNFATM8r8h4knpA9tQlr/lwrF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 07:26:28 -1000 Tejun Heo <tj@kernel.org> wrote:

> On Fri, Jul 17, 2026 at 07:23:58AM -1000, Tejun Heo wrote:
> > Hello,
> > 
> > Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
> > Waiman's ack added. Please drop it from the mm series.
> 
> Never mind. I'll drop it from mine. Sorry about the noise.

Thanks.  Plucking one patch from a 4-patch series is awkward.  Better to
retain this in mm.git with your ack(?).

