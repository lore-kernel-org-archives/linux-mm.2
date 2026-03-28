Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F49F10F3DCE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 04:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1816B0095; Sat, 28 Mar 2026 00:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C986B6B0096; Sat, 28 Mar 2026 00:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5CF6B0098; Sat, 28 Mar 2026 00:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0B9A6B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:03:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1995BBE61E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:03:32 +0000 (UTC)
X-FDA: 84594127464.30.574513F
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4133780008
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:03:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qm+FF9hD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774670610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFg2BFAkAsXMYffunawiC8ZyRv2iQ9r6mtG0i0jtdNA=;
	b=RHQZQS41g17vyUmI1DtZ9TOAEfkuU5h59B2Yj8jc5b7ALK/8mxLFuEJ9wXlroGJ/YhzGR4
	JJ45f1YlOA9SCkRelwyn2qZz0gDPuHkAZJtWdhYVHj+yNMY8kNPwQNkU6d1sPPFk7yffnc
	DL6UaWErSb9Sb3+0De+eqNJjop8Npg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774670610; a=rsa-sha256;
	cv=none;
	b=KNxhqhvZpgpeby+f+NgS7BvN5ptZUPI7JRCYepVfrTde5LT/yE55nem3o1r+bBPnFSdCBy
	smwj9L7E1x5xuVnzNfOFJvHn+3VvuuV9bC8rtG8vqkUV1zglITXvWVlpAMJFlcXyzX43HD
	jmQes4/G/6b6sGYl0YH7O3WeKI03zx4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qm+FF9hD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Sat, 28 Mar 2026 12:03:11 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774670606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YFg2BFAkAsXMYffunawiC8ZyRv2iQ9r6mtG0i0jtdNA=;
	b=Qm+FF9hDwUkdRudeCgYOR2HuLZdwJDlmWQyVaGLS9o1LewruK7uLo4dg8olFPeijhZ7f2S
	cmbCdI+TLCcV2x+oBwgMdWuLTigpbwBKfhL5AwATcHkSn7EweGctE39dZP17LZxreBQ7Wx
	WlpUFlWIzeKUEmUTqiofVh7hfhmEIWs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org, 
	vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <onaszvpegcqt2y3domgplkne5wrpk7iibgj3mybx4wvckqwe5f@qrnlhiksef4b>
References: <2356614e-d9b8-4639-8e2a-96c5e4eaef61@kernel.org>
 <20260327163554.42487-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327163554.42487-1-joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4133780008
X-Stat-Signature: exw4xwaw6urephortd5hrpbwc8on5w3m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774670610-686609
X-HE-Meta: U2FsdGVkX18NB21AZ7AtZu9Pp/ABw7xWcyWh1DbebJbvaMxxVZ4OXcJXXGZrlB5xpZiJajWhZfTIUJSQsUcBgXH+BwYV2m2JRbBEK+CsyPKOlfpWdZug5BBjrEAfCjjW3qi0fT9cyO8IpmkK8glaahvhkYgoYgLZskEAUjo2JuxiHIarKPxki+EHLmd0CvV93FnT/x6+GyiyfomapKpjX89cuqEYwU6IbJppTAcML/8CufbUKW1/3As4fd/L9mZCCgBIrspdL0WeAHwh1eEISxdm3zE/60LV1l/F+r6bKoQJGS56prDiId211MvQHZwFROTeSuWtgCXX82SjgSnslZgDxrw7D1Yb4BpjKY+43gHbCQ48WaIzAi4d2IzCPJvo0XshSGKaZPZkRa646pIfldJ6T8536JrgqkqY5UsG/QDjif+PBiBYBgXa3mBs6DODJt5ODYDC28tGnPouzNVfOtMPUNBZNGhZpN96YndS6V3074mvXqQRB+Er5LqtF0wSIS2Z/T5gQAOW4mqWjDzomIHcxa8j1CWnAXFqLwWTi77QvTVNkYPmkyVt4uA0BY1w5SOetxRgZpUT/7bDkzxeUGeUAnnNvAN/SMXTilPU2O8VmJr0SxA7tOqRKp4wJZXQQrmfyHl0IcEsCG11cmX0IZaB9Irgxeozr9D09BYtzE5tB25QVT2LEher0VNEwoPWZxtaopHOwPj/ae5LaoIph+8e8ITzQNEqP0dYFeIt8lW0Jg3rYI4wWvu4yEglwlvm6n/qiKVtKs2RsaSp6h6lj5UXPjKnQQxlL0OaVmf/iDIUiyUKbQOiUHed8XaWmxmCiaYjyZtzEVUZjp4/XCpMdmj9GmIxoB6qfzmm+/QP2pHLaj0pIc/Ur5Sx5JoHiNQQHdwBMaxyHbSlbM5CsDOw+1JVW/Bjlo98lMYjCsfv+dxvEoOZTqTQgYFMXVpB3Hwn936hY2EFu9WIvler9qh
 LFl/XDGC
 Xv82hXjwqJNKA2I0zCR6t5bOGXAannGECFab/KItEBsAvc6LTTCBWnQ6qZJ+IVup54EqjufgppNx9kiKnwtBa6lmfMu9g2ktlce+MOC6Cmvbr2JyD33M4l5FOUxDtdaTvWNustEGvoWAABRLhtHV4ZMIV+fVmlVk5DiEPYht8TtZXX2KcwqDt3M2L1maB5j8hbOeShfrkK2zgnO/PHiExjnytZmwCRkW9pphZnW94DARRxVLgnkM7tY4BgKFZ9HMeQBu938rVlGrKKB6xUrPvl/wBWsZ9u2i9CRY8e6mreWVfL8e2l/AkE7CTrBcEK4+rwqODUsmUhyS4aBTBY8Ca+H/pn8DFYMc6fMmA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 09:35:54AM -0700, Joshua Hahn wrote:
> On Fri, 27 Mar 2026 15:44:18 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
> > On 3/27/26 15:38, Joshua Hahn wrote:
> > > On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
> > > 
> > > Hello Hao,
> > > 
> > > I hope you are doing well, thank you for the patch!
> > > 
> > >> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> > >> hotplug currently only updates N_MEMORY. As a result, a node that gains
> > >> normal memory via hotplug can remain invisible to users iterating over
> > >> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> > >> incorrectly marked as such.
> > > 
> > > The second part feels more important than the second part, doing a quick
> > > glance through the code I can see a few N_NORMAL_MEMORY iterators that
> > 
> > Note in practice it's unlikely that a node would hotplug normal memory,
> > start using it, and then manage to successfully hotremove it, due to
> > unmovable allocations. Most likely only ZONE_MOVABLE memory can get hotremoved.
> 
> Hello Vlastimil! I hope you are doing well.
> 
> Yup, makes sense : -)

Yes, indeed.

> 
> > > are in some hot paths like shrink_memcg. Iterating over nodes that don't
> > > contain any NORMAL memory seems like an inefficiency rather than a bug
> > > though. 
> > 
> > Ignoring nodes that have normal memory, just because it was hotplugged, will
> > result also just in some form of inefficiency, or can the consequences be worse?
> 
> Aaaahh yeah, seems like ignoring the hotplugged normal memory would be a bigger
> problem. struct zswap_entries allocated from slab allocator on hotplugged
> nodes would just get ignored by shrink_memcg, seems like a much bigger
> issue than iterating through extra nodes :P thanks for calling this out.

Yes, make sense to me. It could be more serious than just inefficiency. The
shrinkers might even fail to visit reclaimable objects on that node.

> 
> > >> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> > >> offline_pages(). Set the bit when a node that currently lacks normal
> > >> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> > >> offlining removes the last present pages from zones <= ZONE_NORMAL.
> > >> 
> > >> This restores the intended semantics without bringing back the old
> > >> status_change_nid_normal notifier plumbing which was removed in
> > >> 8d2882a8edb8.
> > 
> > But commit 8d2882a8edb8 didn't introduce the current state, or did it?
> 
> I don't mean to speak on Hao's behalf, but as far as I can tell I think this
> would have been the commit to introduce the state, since 
> node_states_check_changes_online would set status_change_nid_normal to nid,
> then nodes_states_set_node would come around and set it to N_NORMAL_MEMORY.
> Maybe I'm missing something? :0

Thanks for this analysis. I was thinking the same. N_NORMAL_MEMORY is no longer
updated after this commit.

> 
> Thanks for the reply, Vlastimil. I hope you have a great day : -)
> Joshua

-- 
Thanks,
Hao

