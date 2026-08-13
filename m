Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4975BC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3446B027F; Thu, 13 Aug 2026 10:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4FB6B0285; Thu, 13 Aug 2026 10:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAFF6B0287; Thu, 13 Aug 2026 10:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC3E26B027F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66831401A5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:03:56 +0000 (UTC)
X-FDA: 85096414872.14.6DB4742
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 21E0740012
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:03:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=hzWZX15B;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629834;
	b=2aFHmQmFptOYv5bEj98aZfCB7RSb5QnKubhOieCSfb3FqDSjClZg7cocnCO+RZ6G2+Y9fK
	axn+5G8IgaTU+rO5EEgNtnDAPqU4UQXCzVVWNf0kp8TS791TaBn4G4eV9oqs0Q/AH8q2TU
	LqTba94o7L111bEUYlnjY6+322T4v/U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=hzWZX15B;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRXjly27287JPwSqMXmTIq8mszAlDFNhT/jjwcIFZaU=;
	b=Y/b//Ngtjzvnv+LRJ5jepzCfp8aDrkYog55ojFNOKvyc/92rUx808zxjuT2KbTaj9VqBb4
	CD9wG4tHNCRsEYOE5N1WgtS5hJvcFOd+JSEtrHkL7CkpdM1ynIxxO8nHCh3D7m/2hnnT+1
	ZaqwFcDQxyTH8jWAjLxe2gcPlS6r0Ns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A5E46187F;
	Thu, 13 Aug 2026 14:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE361F000E9;
	Thu, 13 Aug 2026 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786629833;
	bh=GRXjly27287JPwSqMXmTIq8mszAlDFNhT/jjwcIFZaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hzWZX15BHKu15HreRJydCFoxS659Jk4h2R+GVJCKF+kt5n8RXqN2CLf2+gl2NhsRX
	 RO+2G0Qg6ee9mjb8GlIlYFNwHRmSkw2cykHp4cSHANPBxYGnN1fRNg45zJUSEfk8L5
	 EJVvD6xlIH4JIpc+VqinT0pZtar8kx0FhIUwajtA=
Date: Thu, 13 Aug 2026 23:02:18 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Palmer <daniel@thingy.jp>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
	geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <2026081308-amigo-paragraph-3afd@gregkh>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21E0740012
X-Stat-Signature: idhzrpkqbcy8n89zcrj1eb53o4ptj9st
X-HE-Tag: 1786629833-159358
X-HE-Meta: U2FsdGVkX19t8CGkiPG9Vz5MUjW/jq9unNSgXVwor3tS7YNDE8NacSWODFF5CpzCN3T/J/DtO+fM4WPuMzIAkBcCK1NifgnPq9NhDM+zzSzQ5sVD/GXxhioB1ld/hq1TYBnSi8fs2TxikafpTCtpnqcexZOYQKILGzEiKWHEvgecen36ypQ5bGkt4fzsYvj2mJqgMna6PGFkX5YupdjHvKrfc8YNrMpf7212H6NYI8wbmRyr27SkbhkZVUuJz1Oi9W+qgASeqxZ8vYIK3NXDf31eHvfYtoMZ+di4X8dvvOb/ycrIE81EYvW1KbD5jpQOr9lasNPgukYMdI4oDcIP1X4Mkat3kuHGkTgCTdkUHLh024+hxyWfinFhXgXF2ACBzD7V1F41F9E1UC2lbvYS34D7W+hBAqEch5cQ9EkFgkRDB3u3TFBzbZeli27D8wdVWvM4GQsEAJe72t7htmhggauE2jjszuSu06vJwwfRok685F5ZyM5z9yMOLeiLZwDtPnhAtmXmYqdKvEjsA32tgtlc3snGpNDEfPlEjtfU5Id5YrTzKNkLZXPLS8/xFDv2Mc01vixJYtVmZ5REY+vDqCApQAeBjO4M7I5Klh7QHAhyKiv01pLoQR5N/L+cxdJSe7qoFqhGNg4Nv0WUeOrpkrlGwEdyQdEZ+hJixwMUZVgrKFw2dYwsq6mUXlPsTIOmBhye976Scwjf7yS5LxAHy8wNdsmxToSkmHX/xNPa75oikisl19Y17s4aZ2vPlNmjoka7LyMmqoQg3QoLqR2FklJebosrWdg65gC+lDQHfv3IR1nRlpWTRZw3ADKrX4hUtxs4ZqgLTMqSJDE8FTEOf/0hSxB31RyTsMj6u9ATytSU4jDdRT6W1LSLtUsRmMd8G9xr+yJ+nU2IhqsysPh9foiocr6VnWSO1K1rzCnsjYRfkGHwgtshf1pvK5uvLZpwXj62kF5GB9EWqxhHVA1
 siBABf+w
 CrFh/NcIv7mYrVDjzvBcY/SACeZGcvdvZdUt+NviaTORBU7ox95rq3noQiGj/ODe3TR6TBJUiTFvgznuzrQ+WnMKwinsPwFPM2rnAh4fHgLBs3aGSplO1rRcZaX8wEr7YO0McFw54Xu3qxCIuWn6yruAJvgz63AQEhZ7K9jfaE9c8gvrLSw4qfHUv4R4ESIZ3MtvkwPwayvXYGEVjfMu1gLGSfJPOIjzKK44BjaWYmFYDmPQ11I64x/6noEqsgjJekxkdcuKO9hGQ88jExlFnmOFYwV5a7DAgTdQ1QyoKVDlToWS6txlw5OHcuH+qD1w5gvuHfj6E6rGZUOVlHhuACIKH9GLEEt9tbe00aeuC78zdMmcSPs+zK/ksa5ubZRZmAJdf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:43:37PM +0900, Daniel Palmer wrote:
> Hi Greg,
> 
> On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > Given the age of this issue, I don't think anyone uses no-mmu systems
> > anymore :(
> 
> There are a few of us using it for hobby stuff[0][1] and there are
> apparently people using it for actual commercial stuff.
> There was a session about this at LPC 2025...

This patch is fixing a very obvious issue that showed up in the 5.10
kernel, which was released in December 2020.

So I think the fact that no one has reported it before now means that no
one is actually using it :)

thanks,

greg k-h

