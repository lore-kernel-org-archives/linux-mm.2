Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AA3C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF4F6B008C; Thu, 24 Sep 2026 03:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978F56B0093; Thu, 24 Sep 2026 03:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840C66B0095; Thu, 24 Sep 2026 03:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6485C6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:49:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F11CE1C18BA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:49:01 +0000 (UTC)
X-FDA: 85247879682.21.8174BB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 621A820006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:49:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqappBXw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNBlSGVmSCSWwIU1WW3NDbT3EzEMRJzohOzgWwxr15w=;
	b=DAESJ18utOAFvusE6Zl2Mo/H+GWC8YELWdTYalS/+vibLdosaVaTTee1jKo3EORzpStKr1
	vUyfb00QkpEyli3v15LzR6vaN4prDVEc5I7pL2T1TGsYz1soiIhK3kh1zZ4MgPix23iNak
	zqJxOpkUfGvYuZAm9LjwFJ778sjl4HA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqappBXw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236140;
	b=vEZ5dzdqVEuUp+aCIFYpYFfWRNkT10BPAJdt/hiXEJQPZs130hHQOmRB0n+OcVd6rj25+Z
	Es/slqCdKB33KiWnaep9dzW+KQHqFtm406y4KYSUhNrbcQhbf2+FgkpOUlYUH50o7eJmxE
	E7ryE+7jEbLIbymz0blQV62/BSUdgcc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E84A7601FF;
	Thu, 24 Sep 2026 07:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE51F1F000FF;
	Thu, 24 Sep 2026 07:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790236139;
	bh=yNBlSGVmSCSWwIU1WW3NDbT3EzEMRJzohOzgWwxr15w=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=mqappBXwD7fCFpxjpMnFJ4+xezpwCQG4pGBeiONihPyf1CZF8NCC4jZG4mUIaI8ut
	 tcK/3Q6N7qG2efqEmCNvLBpnXwoUM6zwex0JQ7Basuucwg8NGvRFLgP9i5VTScCUVo
	 sHD60uYM4iJ2qCrRIJa04U/TvfQrkY6pzaA9dI8b1yRBUXZyQKlp5cako6GPLpEshw
	 wQqNyqg/Bj9RaWpUy/5EFpDlfSXQzulZq4oFmI+FZOqd3buMGk9a1WqIvV/OWs6hD3
	 L7ip6oQxlN0VnIyCjJ6pYxMyEo2cIZ2QpAY6mhQ2FE4WNsW1G0/ljMvkyFOSc27uZC
	 GtSHNr0n3ATvw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/3] memblock: Remove unused exact nid allocation
 API
From: Mike Rapoport <rppt@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
 Priyanshu Kumar <priyanshukumarpu@gmail.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260919135327.74089-1-kaitao.cheng@linux.dev>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
Date: Thu, 24 Sep 2026 10:48:51 +0300
Message-Id: <179023613121.508753.1739135911194499722.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Stat-Signature: wbhr8qtj379aqz6msrsbr3ef4m1egyf1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 621A820006
X-HE-Tag: 1790236140-941148
X-HE-Meta: U2FsdGVkX1/wN/enMy6VMeb64Q7I6JFaQpu5YwEI4EQgJoKjQN7bcz+BS6mpFq92OOFPdXL+ruJzUFFOLDA/wVGAkgcga5EtlHiGXRu3GYJqTjA3PcL54SYvvqwlpxQUVJsAfMrUDMMNefI6Q0lQx0HXeF3GR/jRX0TKTJnkBEfHQLhIKH+8FGdHOqs0XccsK8gZZynZnkOdDRgd4QheBelvG7n5nDi1O0PS2ueTgI64pXZ00dQBqTajYPjJ3pUSTREStu9WvuH4fpvibSHXs6JF+mtxCywEAB1flPmT+ZMhzLFUFK9iYRKWq76Om63n9ym0yGZqvXcSAo4XRrxhULi/6HW3yH1TZ8LfxfPp5fykwJgILHfX2LpafQSgitYM0UlnpjUFLF7BymUHeSQx0Ih7TeaLyBWfcAf2p0gLFLSB0W3GhenJSknM6iioqAUiblE3JFaV0FDckBJM2K8AOrjbPFdeIMo7poTyEbkBo6DMbJbn11jOn5nZNk7gdMhsjESFkl/TftXvGxlY7G4yrN+CGx+cmSm6hgJzrANna2spBnwUlvNsr2rNGbxbAAkRUuPvrV1oQQuqngIZXITr826MSefEYXsSGIRptK3FU4ABkpA1+sXgv/ihWN/MTGDUg6FdtN8Qad7Wh3yUHd+PkytcZFebqgeuAKUQSZe1miDk2FdvWp0EmvDrFsskQueNLleW+g/R7fi2FrLthp5kN00W9egWkQIaaWNqXqM1csSMMTVWWiMrRn48au96E6XVSwrqdlhaVpNXSprr3cg0WYadkXvb42xKQ8KPG2LpeNOTziyLTDwjbGYLY1TaiUaq7e9V5+/rkVn0dX33RU9rCazNBBqf/KHFXntynJ7XHR+X34f88v/DWrLjSiCqXgPzIGd0VtPTtAOJv31qQMej7wXwT3XqXjlQ9rr+VdP3A0HFzZ6hQjm6oV7/thfmkd2RKioT8OpMvl/69whw8cx
 CJus1E+7
 rDPqa3M1oJu12rZkDwkNqja2XDPBnuZkW22K0y6WIFdxP1QIAkFSsS2GlFQbncA7tJTaLe6RUbCKGzXm6B/+Tmfha1uV9vV1m2NwaSaqriJzxGs6Alt/D2k1YUKAw47NC2XqY8ZNlG8zcSUhLTxUGHqvSjqyS7G7+BiUIdug23wxJ98CTCzFKVfbGdMdQTlP1MhkHzTsD+CRO2gV5b+jdBPmgwS3Opg3VG6Os2yBlLCcMVh0GBx+CSGIpVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
> mechanism") removed the only memmap_alloc() caller that requested an
> allocation from an exact NUMA node. All remaining callers allow fallback
> to other nodes, leaving the exact_nid argument unused.

Overall this looks good to me. There's is an issue though that mentioning 
commit in mm-unstable in the changelog does not really work because the
commit sha may change.

Andrew, how do you suggest to deal with it?

-- 
Sincerely yours,
Mike.


