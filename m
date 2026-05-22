Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFBCCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489076B00BC; Fri, 22 May 2026 12:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460376B00C1; Fri, 22 May 2026 12:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378A26B00C4; Fri, 22 May 2026 12:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2599E6B00BC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:07:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C35CB9037C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:07:51 +0000 (UTC)
X-FDA: 84795536742.19.A2FD8CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3A56620009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:07:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMuzFprd;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779466070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRhHNFawhCo6pM9tnWmE786F1aMZ0uk8jmoxkaNKhSQ=;
	b=rsCnD+Llq7pk28JhL+d9xzZerHUR+WMGzxtDBo3X53muIE8TxhObcbGcEMB2OUGL759Hip
	luBpiS2T0OEEzrgztlkBBWVBoLvCYWUnADkvgGOhTMlWKFpajmy/gmKaXoGegKaoMWxuSn
	SUo7qs5FhnPKkyFGGh7c8tK5UtRkrbI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMuzFprd;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779466070; a=rsa-sha256;
	cv=none;
	b=6Y6Jmda4yYpil5xLRotFnLjbDo2+0UsNVnICwCT56MM2CcImNzM6TUfw71LsDH6TR4yklb
	pb5ieZ/Q3wBvDDdvYhNcg4szhhgy2I215SNx5FcCMLRjGEC8NPZNQm0BGvmii76OyKVue2
	3Qrzlf4lNfLwTFfgDk3s8II4hO0XFb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9720460138;
	Fri, 22 May 2026 16:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07841F000E9;
	Fri, 22 May 2026 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779466069;
	bh=tRhHNFawhCo6pM9tnWmE786F1aMZ0uk8jmoxkaNKhSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SMuzFprdx8wE7h7zVMHdOlf60XOV2WA8HHteNjsS+pbu/f7B71Qr4Ac6gXzZCfjhp
	 6aCEsMdA1VvbEZPNn1V/Rh58tkCoaKqaxeE2HC5y9BYfGeyssvf9CIEVudEawj+NzO
	 fYNDnV1DvtNHk8FhprbLd2iJndT0xp0IgdJC70K9SciXGYnOwWNn13kTGMqCsy64Z5
	 Kc6JI/u43bGaGAPOwg/9GbBWd1nhjGEK5knx4Pnoe+ZhC/A3h6txJgVaf7K7m7A/7h
	 Fac8ZVbQjNm2w3lR1+Wt0bvfcYcoCS1Xs58rtfeytqLtl4n0fPeunSLGeTzXm+Mxa7
	 E2rtCct1u6ivg==
Date: Fri, 22 May 2026 17:07:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] remove mmap_action success, error hooks
Message-ID: <ahB-b2npY2_jICZU@lucifer>
References: <cover.1779462249.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1779462249.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 3A56620009
X-Stat-Signature: tkdng8ha557bpsrxwz6paw91dxrxkww5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779466070-783713
X-HE-Meta: U2FsdGVkX18gZVaKOT3LrHNCWLBhrdEWf45/Dw7EmsH/8fBp4G0FcCJZR2fAEdHMzC16JEz3r5XXYrwlVgi0jBD42G85YpY+l8LXp6j73O4p7rUm96xP5kMTLBREw9PSlwMuGcwIsyxCA4eKLywVm+CRGW95fw9r+S6quR9z9VQb7STBq2S4E5RHGhZOyk7yZP15FwN5rMqwcM/IC67uqAgENAE/TsGWAmKBTqt0os7zqImvQasfOFIkFrQRQnnd/bCqNBJcs8ULxM6IcRKM2e+xRSyU3ZYVcFjV+WHk4LMnsHhOBWc/G9QV8wMlxVwiMdK8hnon7C022UMJFZLKwx3WaAPLc8lkL2pm8MpDl/uACID/opoMSukHCHHZgNz1dAdbbLq6bYgWFxZOTaIpXIZvLsR2iNob4h71NiZJhiBqRPLzXzpWSrSx1c0W0pxEy1otOUrfJD++ZbK8CSg4LZod2hZcOFb6TrQpIklRp2EzfY5raKV3+B9s+ZYI0ey+ZC6WOJSQn/8qF1Z3mJb0PK0TqjAVARiBvqxS+ITcdKpw5q9T2sJo2OXbge6YmhoQDIJ5CZK3B0yvT4FARMdw1wTETviSBiQVD8iD228DnKWPHIvbfAp7INnaTIMoLKGDqJrVWw19euaRKQ6Ba3l6pk/EB16bHMle8nUTTJ8OXCxEzJf6KWqAeQ+RCBx2mImDauv1AJWLJDssa+1HaTpA0QiMPdxR8qqueEDDw6Jjros0qWWxk6A1a2Jwc3JYt1BmUQqjBRGdrPI9j71sU5q6CPuvTrS3SrqHMy4+hqlBEi8ZY/vFqTeN5P9lDweqvPCjPSSraJ+jdJFUaCliOs4QEQLjg5tcYFJnfbWcT3rnq+xD6t5TDZooNt6QavPvq416A9p9frKCqJfggVUymQM1fxufRXeMNY/BdNfTmKIKs+5o9k8CznQzS7tQOMv61TKX1LA5vaO/xQl1xggoWxC
 iolpNJcs
 NPh/QMyXfI6q8TXB3vG8VP2eWCtlJ7u2MzIaobnK6ftVpqj1U07T5Y108PtUkkrmuH65tp9BGz4I+h7rRyVtaqaEv9phTRpjZkM+NolpXumgTzvxo+GqPqdUiagDkD0D1PZdBx2IbFAkkX7kkuwE50e9iQoZluYtFvF+/+ezru64vzp10Sgg2+A8gZG4basa055x6EX9HiYAfNkHuivICHQe3RQjZqvUpAmcl7Pi6rDQCEFUcVS6dGLITdsiFNjhpV3nxrpBeDJEi2+j+rxkeVab2hAZ/Fslu4ihnQiHy8d4kQBnTAE/CxoKHqX6TWMyYyvsWylfhzEe+ZQap4KqJnoW9GtyRV+JTwbbvxEICOo7VDDaBQb/Ia/sWcAsq0lRQO/5SUcD3ZMrejKjj/0ArpcdYsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI re: the sashiko reports on the v1:

https://sashiko.dev/#/patchset/cover.1779379804.git.ljs%40kernel.org

1. This was the bug the fix-patch fixed, it seems sashiko doesn't update when
   these are sent (which I cannot blame it for :).

   Anyway, I did say I felt fix-patches should just not be accepted any more to
   avoid various forms of confusion, so in future will just reply to ACK a
   thing like that, then send out a respin the next day :>)

2. The 'the series didn't introduce this' thread can just end right there ;)
   It's an existing behaviour that's been there from... very early on. It can
   wait. I will put it (probably quite far down) on my TODO to examine that.

Thanks, Lorenzo

