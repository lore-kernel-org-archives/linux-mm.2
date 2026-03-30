Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B1410D14A2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B15E6B0099; Mon, 30 Mar 2026 07:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488B06B009B; Mon, 30 Mar 2026 07:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5C66B009D; Mon, 30 Mar 2026 07:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B62D6B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:44:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4EB11A05BB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:44:04 +0000 (UTC)
X-FDA: 84602545608.17.EB97A34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F09940012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:44:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uFu15vSV;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uFu15vSV;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871043; a=rsa-sha256;
	cv=none;
	b=IJMD2MdImZiqtz0kCJXk8UxF4uXgO60ohyiOmY/DvG2PC381NqzrD20DESerJ6i+ZBbXNg
	am5zHdtQAqYQ/es04GZ3XovQe8Bok7IeIgI1eBH+NVD6aRAPM/bDKGsGzaKHOIanDm9i0Q
	XXBm9u5xbbpnlBuIAYuXqPhLs9lUs60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jvhOhgIsvaDl0A7cD3cd1tY+pipOzNjMsIh79RhX9I=;
	b=GDC/GBOX3z4HKeJTt4I5jVqkWIahyyJBQt3dbxkHMgdoqICOKDVUww/8DabHgbnJpo1PQj
	l1KXKncOmBJMxzKy2LWxq/t8lS1bvslGFko44dp6l3QcWj0c5MdUY9sauusgJtxWVawq5Z
	4B1UZ2KEulLnoelTEOsJipA5/MjQFfA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4AE641AAC;
	Mon, 30 Mar 2026 11:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF1CC4CEF7;
	Mon, 30 Mar 2026 11:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774871041;
	bh=RD1KljObGKXSYd8UJgOJGm/wNIY/qYdC7yIDBV4Nl7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uFu15vSVeCbd/xfajB+QwNZhuZioYxLjTI1mGglrm4J0QShB+T3gRGJokeM8hGL+Y
	 bY3Jo6fbu5Iy1BzYcY4Z7m6/qPiSbF/8Zn9Lw3iQ/uiRo57oDs9zp95keg7nZjD69N
	 mOuQGZ2PJp/EUfXNflU1a1imc23H9nphhzIpgkWVuf+YHwr1bLfrYcLWdN/MUqeuWk
	 X/9AKvtbTl4xba8p6NUVYDLWiA/jmTu5OO+0/xJMCuc6Ob9cUi3RBLNZ7QWJtyils7
	 UiBPaTP0wYTxvzxrFAjJ/8pWybyXWBMUsQMAugGYB6L7h3vRNp/bYWv/H93AYBOwYZ
	 ruOTNJDd2kKVg==
Message-ID: <837fe882-0d42-47eb-9234-9d5787148650@kernel.org>
Date: Mon, 30 Mar 2026 13:43:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
 vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <2356614e-d9b8-4639-8e2a-96c5e4eaef61@kernel.org>
 <20260327163554.42487-1-joshua.hahnjy@gmail.com>
 <onaszvpegcqt2y3domgplkne5wrpk7iibgj3mybx4wvckqwe5f@qrnlhiksef4b>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <onaszvpegcqt2y3domgplkne5wrpk7iibgj3mybx4wvckqwe5f@qrnlhiksef4b>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F09940012
X-Stat-Signature: bjxg8ncgrxjxecm54378htqbnx414kcb
X-Rspam-User: 
X-HE-Tag: 1774871042-587695
X-HE-Meta: U2FsdGVkX1+YQ/BgqkZiVCowlNXkI8BJ9VeRe39L5bhH1/UXgEBiRuvS5Epd3ks8txWhuVAD8hn9bqdcsj0eDSz+yLJwHXj9aJByLctXG0lIDYczjxZjqvKklmb+x9wGkFBoa0FSTLajxrtRiOLMNZzszVI78ah220wyIvnhKElu6h+b+k40uJA6mt+Tj/wtYw6YJAF/HpisW2XGcA2vyKLLtAjthzvcmrh27vRybujQBtMZPR+gx3GLB/AzJJXhtjN+9D8XIsjsfSLA7s+A6oWcM7lmr2WVwcwkH3hhDJocBdoSD4OhfTjQQNs3yzJWF3f4/UHsJn9S+V/fxnELY96+rdWoujhbo8Vvd1L8SzQvdVRyCnkUQXH4/Zx1wFGA+NIc3CWh/D+HUVeYO6hfpnchOyImOZoXqDPH0M1kV9iUENXBfHbNq4SbRsOGSP6IXggH6Qq10MNua047WQijc/EwkfLs11vYrK11YFbF+zGeFVxvxq6xJB1QYsrZPwfueKbrW4Vx3IhWMOoCDqP9q7yAhkesb91J1fYfkVL9dhVPRmInibWRXuu3Fki4LISkwPantkVGhZ1ORTXyaSQ+WT4QO0wQfRoJ3Ov5CwnqDehd668yzwvotu6omEc5pX+34D8QPYPJ6/Bz9jjeG7eow4h4fhWz0HqFdR58x+DYX77nms83+TQjy2mahJzGA0P2ONoQzctujQP3/AOi+8BTELqe5+dn78fBKUycIME8VTlWgxUSw+tkkRHW1gJbrJIEUZEFp8geh81ZDX023YcOR2pMEnR+58uAQA95LP8Z5SLZsOfuYPLwIFrJR3UbyErB1+zTK7n0UYlgyDFOyrovr8MmdFN03tyGPmhpCFSffe7wniUZUga2Q7N/NHL5wwfe0oa1kt1P2dHsKAZ3Fmr56aI5nDg06DYkc6+MhOjmMw9DFKP5H/dWIHUGvoCYzranDC1KZXthsGa1vFIe3fD
 9Mlg7WeT
 A+jCZ/SVxYFYFmdIZu1vC1AKKGxp5CTjkmwXNZW9JPqmJEfq3edcuR4JiOdb5XkhhfZfhR+LeTi742u9Y5ziHvSeevsDvm7GP0mHaHz2CCkc9jROeg4kz0rmn8rs0kbDaAxUL9rZ6jkmNurzAzjoCp4EjNaKt+guO7kFPeGewNtdW2ZRm307DFF5RU+DVTCHIyhOi1fRDghO0jdvWP22Bc7mQMRC8J20QwoBNdSlYBQqLepCk2dYzRZ20xdI9ASJFunMzfR427KpnvCIVBwazit1A/QVEfpVRfDfuAtHk7EoNEp1XW9lx1dkuWwChTfzWw2OsYDAve1CCk4ZaY+wihaqX54R4h5awLuDzpxbVolaWfJmFR3+lKlDh3VHghVEz6KRXTnAA39/xL1pK4yJAwAFU+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/28/26 05:03, Hao Li wrote:
> On Fri, Mar 27, 2026 at 09:35:54AM -0700, Joshua Hahn wrote:
>> On Fri, 27 Mar 2026 15:44:18 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>> 
>> > >> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
>> > >> offline_pages(). Set the bit when a node that currently lacks normal
>> > >> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
>> > >> offlining removes the last present pages from zones <= ZONE_NORMAL.
>> > >> 
>> > >> This restores the intended semantics without bringing back the old
>> > >> status_change_nid_normal notifier plumbing which was removed in
>> > >> 8d2882a8edb8.
>> > 
>> > But commit 8d2882a8edb8 didn't introduce the current state, or did it?
>> 
>> I don't mean to speak on Hao's behalf, but as far as I can tell I think this
>> would have been the commit to introduce the state, since 
>> node_states_check_changes_online would set status_change_nid_normal to nid,
>> then nodes_states_set_node would come around and set it to N_NORMAL_MEMORY.
>> Maybe I'm missing something? :0
> 
> Thanks for this analysis. I was thinking the same. N_NORMAL_MEMORY is no longer
> updated after this commit.

You're right. Initially I found a much older commit that seemed to remove
updating N_NORMAL_MEMORY shortly after it was introduced. But seems it was
reintroduced later and indeed 8d2882a8edb8 removed it again. Partially my
fault as I reviewed that commit and was blind to that aspect - that it's not
just removing an unused status_change_nid_normal. Thanks for figuring that out!

>> 
>> Thanks for the reply, Vlastimil. I hope you have a great day : -)
>> Joshua
> 


