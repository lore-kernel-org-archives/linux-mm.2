Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1293BE83848
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C7C6B0088; Mon, 16 Feb 2026 19:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA986B0089; Mon, 16 Feb 2026 19:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5D96B008A; Mon, 16 Feb 2026 19:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 15D976B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:54:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADEFB8D6C3
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:54:41 +0000 (UTC)
X-FDA: 84452128362.30.60821DD
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id E936720002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:54:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771289679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gt7mGOsmVAUXAUfvQ6eM3oIjCKbVocfi1DznNmhoXI=;
	b=198I0E4hv+dcA/eJFITxO6W6YpHLdAcXHS3q+Uk0/UrxEAT4fLkuOKeRIjMW0dA5GrcezR
	wsuoFdLBLTP4P04q28CIzKHvJgxlEhewNcLKSvwq1rS50H7RgwXLQe72lYaJQsRLfgWZH2
	dTr2u6JJXkVN9ykrRvdUctq25Zr+7sk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771289679; a=rsa-sha256;
	cv=none;
	b=HXmTenRTnSdWi57PVx9SNYxQErO4gY61vsRMmhzRxknnwEsibZxYHDzXBw9k7LFuc19+Lx
	QndepRH2O2Hg1KwEmIYMgD93EMmOrA8FHMfQPv1WnUHQCLDuhVg3d2qZGcveE0eutvqeY4
	mrsi4D3H456sO7qBKxeI8gln+qaYkgQ=
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 523EA1B5894;
	Tue, 17 Feb 2026 00:54:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 268B818;
	Tue, 17 Feb 2026 00:54:35 +0000 (UTC)
Date: Mon, 16 Feb 2026 19:54:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Thomas Ballasi <tballasi@linux.microsoft.com>,
 akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org,
 hannes@cmpxchg.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, mhiramat@kernel.org, mhocko@kernel.org,
 shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com,
 zhengqi.arch@bytedance.com
Subject: Re: [PATCH v6 1/3] tracing: Add __event_in_*irq() helpers
Message-ID: <20260216195434.7a8ae4b5@fedora>
In-Reply-To: <20260216161323.4098568-1-usama.arif@linux.dev>
References: <20260213181537.54350-2-tballasi@linux.microsoft.com>
	<20260216161323.4098568-1-usama.arif@linux.dev>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/BundDqrqHqq8/xV/gBGT0C+oZI00kiHQ=
X-HE-Meta: U2FsdGVkX1+/rLmJ3XWTiP/Yk6N42IvEIOK+SpVQcyahCo44khKDjZnOUm+bmy6xN7U1xuYaoCMHdcFaiqIUmeDl5jf4mz5Kh0jh9q9BXOk19YUF/Up1AumPf9WJcNQSvy8I2darMzrhhA2UMLvnIfbMepCKO48a2wQNjCLx8OOqWclEunmrDspukGYqAsIxvoFLAbH7Ppz8EI1UjvfghEu7HCyv5YDOIT5Ibvd5E5J/vga+8q++otBXCQ0c/rQ2A8eOO0OtLHbaUfXXgoX1mXR5qtr21Cwt3+Myu7iA10COf17Z2Zp65DhLQ93OV3rS
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E936720002
X-Stat-Signature: 1spxtzgcibu7me6hqu3u4krygznkqqc6
X-HE-Tag-Orig: 1771289675-796754
X-Rspam-User: 
X-HE-Tag: 1771289679-661413
X-HE-Meta: U2FsdGVkX18aSYkVRZlcMr/0PZrQSwYUyjpxTlwYcFuupj64V1xt/zv2x6lznijrtocbzAUDSOfXRLlyEwjxG399Cq0KKAgvbjxiVZU/BxvA2hEgx8uCU3kMiA5MyW4v4o2UjJRoMZrqtljq8SoEwzuIpslS6x0JF6QJEsxoy9xJqF6bjZuxfxqLeKKCeVtgDwn1BWGuP3TkkTw7+2XnN0JBS6pa282qbWtImH02dcrwYsMuQqdmkyMRMo0vSF2ox7c9jSW8W/gLp08pxHV6JncoKn9r2kyfM4+0GMyHJyy5vda8Ag1lplkFGQ/uC8Z6+GW5c4JlkY1kr+r3yE1w4DsYAjS6Kq2JPUUTUu7f1s5P3+aCSYV46dQekKBvvkPNgX43dnKPNP+MzQ8I3t3DZkL5oCjFK1wuvsie8bw9ThMYMgPamWgd45fVPz/bSSvOMWUMRXqBdtwhdmLW1frlmpntRDuuCNJS6x22waoVDvowNqYoZ5fM0UVRrDtIc3MkDkhnVqQ3Amov15yFmccmYCEC/5mylniLpSjrz8AUaz3UE11HVgEd1XxDXMrpAw3CuBxDS6riCt5YyaputSqwJqwSMMTEeVeDIk5DQHRFoCM8+vPDBBWRx3GirLINHiPIY6pdczvc0LJLFkMR2nLC+Pnw0WR0axxUQGhxNxfsle1HrgDn8EaP2HVpla1l2BuDvyQo/DyL9X7ubNcdOkJaWNPVC0OMi7cJwLCJb0grgwJhRbeCqiH7hLQh0BhjbvWKkC+BFs1UmIpztd+Amlf6hhdNa87luLnq/CUx5jVnYc3dOhbD6gzV6L1zEfOfasuviOQC7ZMdTjMS77eVUfYkaO6ld0RD605WpEEbRF10u0uYloUVvkSVExKkRlR4mXqyVuxvD7R9F+/kYG0OJRTkvsSkx9WtFg/JC2b5SW+6NVEuHENxeDzScLX1PYF8cF9+BXICjblo82QUIOukd45
 RqdSLX2Q
 nGjtJ9k7t4WhQxTHZ57129JX3gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Feb 2026 08:13:21 -0800
Usama Arif <usama.arif@linux.dev> wrote:

> >   TP_printk("val=%d %s", __entry->val, __entry_in_irq() ? "(in-irq)" : "")  
> 
> Should this read __event_in_irq() and not __entry_in_irq()?

Yeah. That's when you should have done "cut-and-paste" but instead just
typed it in by memory :-p

-- Steve

