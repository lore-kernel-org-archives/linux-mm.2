Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF9ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C74A6B036F; Mon,  1 Jun 2026 08:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377AE6B0371; Mon,  1 Jun 2026 08:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D196B0372; Mon,  1 Jun 2026 08:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1539B6B036F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:19:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9BBA1C1E1E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:19:27 +0000 (UTC)
X-FDA: 84831249174.02.EEB186A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 420304000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:19:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iCT7BbAD;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8I85J2qCWw8kSCV48bS5iJLpYyx/iyAZY3UbobiVKQ=;
	b=4y30S8OK/CqZqKim8BgEdwIRdrLHheFjrmWlt9r6e0MHIQAXitjK5pgl0k9qW0/y+sXVX9
	OPhHrK1YP1O0XrJ9ScNXnOYH0X4Dbd+kyasdvaoKjGNSSZnuAk5WZIxDqMKzlI6oSgOVDU
	eL+ShQfhr69YuPO5BtQACbmPDMSuc3w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iCT7BbAD;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316366; a=rsa-sha256;
	cv=none;
	b=pGjzpJolRfq7wkpntew0mh3Uq38s+Qi8RJJpITjm2B4AHO8N85PSvtgvw4zXs0zbIjfjD6
	bexyXNVTyUq6MRICm4dBqheRJjx5xxNjklGZeZCtvsqw00Lh3QltT8An0bCs8ANX5ibC4H
	L/SeTaSQTUTygAcFXLOr5jOyC2CCiK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A63896001A;
	Mon,  1 Jun 2026 12:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06C51F00893;
	Mon,  1 Jun 2026 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316365;
	bh=c8I85J2qCWw8kSCV48bS5iJLpYyx/iyAZY3UbobiVKQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=iCT7BbADvyqY/N7ktQa9CCgQuLuxBi4bueukJYyNbHF0PfF8EjQwNrugrMCvzsqX9
	 9q3Bkh/2GSly5eAntX/fzTq/U3DYapYK0Af0v7fUEHdvK69OpMZqTpu3fIXD8Vtpsv
	 3kK64hONFu2Wyfiyk9SPhNn6LZCQ9nVjSQN1bCuf+1u908hDrJF3Cde/BuZPgKlfU2
	 B0wruFmyHvuzw8sv6UNygpdeq5JxWI0RLZusmFxpbMV/X8dKD55Gq+5l/2tZWNdQ09
	 CzI+TVBnBl8eH6W3yE0yHeox9lngm+77wRXMczG9PzhvJ3IGej4bCsIKsNxalLU60s
	 rocow+5OAKF5Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 03/13] liveupdate: centralize state management into
 struct luo_ser
In-Reply-To: <20260530221938.115978-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:28 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-4-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 14:19:21 +0200
Message-ID: <2vxzzf1efo6u.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: gamhh6wtd3n13x3eich1yqtkc43c5u3j
X-Rspam-User: 
X-Rspamd-Queue-Id: 420304000D
X-HE-Tag: 1780316366-103266
X-HE-Meta: U2FsdGVkX1+VxaWv/tXs+TDn+/NFjXmBBdneeaWZTyl16a1269mhY80E18TtswQmqZJH7eLRxA3+DFTp0MDcKZM5sNKP7B+zzgbfpifd3ALlgsxokhzqGjJtB3C+ZWoN5E2Wwm8MSxn40djsXq0zXkt5NIVnDEVqzHbbPAw8XJPCE5F8hApsDhxSDCDFFX0D9kjr3OMFQBgRTao679tz8veGTxaKiz6AbTjfkg0uBTlJwElJovGtQLze0q9F6MZDd9OeErZgzWLiIUPF2Nrux/qfbFatvfJ5ZWglkmMF5eyFzLITFR2vCDnMTG02Uh/in/D3cgXy5M9elf1Xo5+Rns+85GDwV6yL9//wJlsHHmAHioVoPL8biM9MoWxvxFcj/QVCualKp4+s00JncDeK8sEWq9gWQSOcvFi4thyRzoklMycMg4MNAz0zP9UwykNIne4xKb1cKaKrvudERIlec6zESyJ/e8YNSkoU49uTC7MAuuTDj/dNL7SsryWsoYRUEpt9DSoevPlDq55a6PFG9T84EIDJrgNGVi9W4r463SEE99Cz5DOeJS+W49sPNCmO8Bn7jhtdNcOQ2u8yuX5YlG5GiW9ZtuVYJEZskqG07FDqnWGl7mGSj8rrMtHCFpBqNqw7ea3Bl/5OU7kYdcxDp8Bsp/EklKGi0daEfYL/DNscw8o9SwmD0dvJo86uA6vok9AibD577ahuvQ/lHq4AgjL3BjpspZA2hnaYLKiersj5sAkZV/U3710D0fa21EdjwwDxN1DbN62uOiYrxGWuJKpShqk7GtaaJjeyG+QMA/8A/kJE+Eoiejpk9f8Rer6Fkxw99EX1Ed/IFH4nFEu8AwcQPjh8Ry+MzcZAwM6MUyrPiOdIjospk8OZhUXY1rJhv+knE+TVODakUll7EAce/tGoO/izYfti0cA7O8ELiKCC0iOtWTt+IxULhLIhLS8CezFgUn+J64cfmMA/XyT
 KhILfmvr
 IgsBNDOhNSkfjCWBezWzhpaPrK3VxSLvLapvWxQEfYgyM/XXXjeannleQzrEY+n46q2A+N4By5N59A6fqK9K/9U2/awpiG3xqOEc2m5+XFhO5nj3Ba8tIt1Yw+Qv7oIcBTSknD9y5YlQlX79Rv5f0jkhNZWWbneKH84yL2mrGdG6pfuFgcmAZM0meiEp4smkEkJZ7xCKcqE3zLr29MULjhUP7HdEfDhNCEg6tAm4TFPUzWm/fcV9QJ2zq/uaf09umy/w/sR4urd/Y30ATXoIgubOouKK5ka/oqF6EJnfKmhm8+FU8GEOqwA9HoeL7fD1dFlcwR49G9i3pwDRypA2UPyTrWhpPAa+FP9rJ/g6rykGjtVKW5uhzzor1vpfnbbcGsx39t7AbMGToJ6w77weusIrnvToYabDdIDVj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

> Transition the LUO to ABI v2, which centralizes state management into a
> single struct luo_ser header.
>
> Previously, LUO state was spread across multiple FDT properties and
> subnodes. ABI v2 simplifies this by placing all core state, including
> the liveupdate number and physical addresses for sessions and FLB
> headers into a centralized struct luo_ser.
>
> Note that this change introduces a semantic difference: the sessions
> and FLB serialization formats are no longer completely independent of
> the core LUO. Their metadata (such as physical addresses for sessions
> and FLB headers) is now coupled to and managed via the centralized
> struct luo_ser.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

