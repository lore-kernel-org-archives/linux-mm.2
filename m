Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F334C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571C56B00A6; Mon, 17 Aug 2026 05:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522386B00B7; Mon, 17 Aug 2026 05:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438106B00E4; Mon, 17 Aug 2026 05:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8866B00A6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:33:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAB6F1604F5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:33:00 +0000 (UTC)
X-FDA: 85110247320.18.9CC450F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 041BE100005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:32:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFtXQT6O;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786959179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8sjeabZApw31Jd64/q4TJm0c+BNaFrr+W9S+q/8y7E=;
	b=8YzDnhgnpAgNRHODxlKXox0Y8tbvW8V2OpbWStwsO58xndbCd7OPlnkTKMHzvlrWhpc017
	As3hRlAqU+XXHXvKjQCstxPcWREJTRj5JgDO4UxeX5b8kLD6kX7B9ZUf5OLJpMy75uSXEE
	6EjUWRaN8k5o6O7qxa0NolQaqw8WIPM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFtXQT6O;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786959179;
	b=texsE5LjGF9p73tPKpfBf+3raBGdK9jOt9PlEMYL39sthdsG+C7BARoT0PAuk6Ca8XBgMQ
	RqTcPG1f7Qf8IBw1NRZIZRec2J1zlesSSG+DjW40kt0vOA0dGqQkivHnT6XkEIqFK3o9Z6
	vzneojSJBFIpsjX3V6yHMK/nxFT8TxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 770C9600AE;
	Mon, 17 Aug 2026 09:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802ED1F000E9;
	Mon, 17 Aug 2026 09:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786959178;
	bh=r8sjeabZApw31Jd64/q4TJm0c+BNaFrr+W9S+q/8y7E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hFtXQT6OCdEFnmK2sYb+inI52Hbl4yQkCPCXSDM28En3Xq3xAyswSY1HOYa0WAPu1
	 ODu3XklnvXtECZOFO9v28VTDhHi5LhT9qvb+fdIgdw3JJNHBlrZLnNeFI9GmncwXW0
	 Z0Ub52Ns27ueBTfV++ntEA1goclIqtQmy0a0M4WDK7f3rcgyeLBid+ENRqO9cFh+y1
	 FU5s6+sjInf6YRkEiSAuMWP7WeyZZeh3zvk5CaHlux36dw9a+58g8ZgOo7bfnAsOo5
	 jNKULZXzP8+w3aBDf7lFZ1Qh0tJaNXqpe3UVyctvW0jGXBeyIwYwu1WWkl1LfCtwkR
	 AQUV6kX+bq7fA==
Message-ID: <8ca92e46-07ec-4144-8583-5251cbb92da0@kernel.org>
Date: Mon, 17 Aug 2026 11:32:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: gup: cleanup the gup_fast_*() call chain
To: Aristeu Rozanski <aris@ruivo.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <20260805035847.936054733@ruivo.org>
 <20260805035848.161794043@ruivo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805035848.161794043@ruivo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 041BE100005
X-Stat-Signature: cppimrbdq5uibtybgwrg5ppugfbzdffo
X-Rspam-User: 
X-HE-Tag: 1786959178-788262
X-HE-Meta: U2FsdGVkX195raiCzj1E7xnkEtceBuYmSgO6lT4G814RVCI0eHBhnYtS9vX4H8gWWNqoymDznc46BXg7BmVHZGV7McAtvKaG6yVy78Y9aorY/ImEfzI0j1qolu7njrd/FcSojJFeYCYhNk90QcXxsWWu6khj4EWTUn6ZE7txKXbfTFJjxLjBzsCwp5jTllDwujRKkkQrcQ3opQjEICGqwZpPX9iWPQ7BEDfDiXHtdghWJyfIKqrf3lB1wTX+hQDuk3tHrKzqFH4YVIe5A6OsfcVFeY4VeUntSTP8WKkgc5vrIBQbRcq8Tqz8yn9h1LcEhFy+ZNc55vYknrkriGmVo0gd6OrGo3rHe9AzCf9Fvdh1ihOKPwUnSLsS9A4h0aZvaLHP9NwgXlZyt3f+E3Ogannywfrn1ttr7TUQ2o4VPoevLL6wncd+iRbs+BHLUt+o7ACqWB174gMD9lKEW71NOA1KokwNB2v7xnuGFD2QLBP4ND1Xdo6Kv9ugBs9vgqoVZPm98NO+r9qogOkHz/AFgTjY7UFQ6g19tPsjBAC+fdZi4jUoC9ikPgO7Jn+d7alzoId3LuXfZDBbcbCtOh5KrYjQG9NBDyW4wW+magOL9OFR4CFS+VeO5pA25E5rMSWIn589WdytyT/kdnl/zXcqcqROFF8tM/sXO54401aSDRgae04anOr3yH4mkdA4Vz/qNaMQq81YDXtWubzsUaeoXw8XHJDFAU4Q/v+aL5niBJXKRB9DlVi5NFax52bPxmmVlZX5LWZ7JjIewHqQ7aw6wF+gn+t1u4AnO/GLt1+X1r878U77B9jul32o1me/mFoULJ0rThaURUdGUn0QVHCTq4CB+4nGnCX9d/rp1P7f2b+2i9lvzGK47bTR5/+s9ZmZiRSS3fHwuyvDMpXMpyLmW0WxEEMA2VN7EZbJ5pXwQlhP0lMJWd4/ZgkPM1xcD/Mwn+oXLUV++gy3mu8uM0F
 laBN62u4
 YwuFsulFtEK+CMhLTPOhixr/eQbHX3rljpp8rDNzDbp70LpeS9tFRlDUOAglYykDqoazaujpw3SGpHelUensQSf0XUBivG8objgtHb/aeu6QV0EpZ4TI/Lnj37Rp9VlNf2ARxrVr7wUBjSmt3IhdRtC+tKyJkn4PTgFMCeV9rjn7G5/FSHQ/si8IGMW21m9fz4JryznNg2Ub9Ar8CBErn6DJ4KLq2HAdzc+5lpkG5tBmWi5XyTMREh69z4ILWbTjl59IkgzU54Qq8sQ9h+apJPIbjUS/PmWpKD1mSO+ksl/cGupfQY1cr/wGWJYDD8YFu4UYYXLY6FNA48SP2F2Mc4uvcklUGi8XuyIw65UKb6CSsQszMqQyN47VzWsTIbzo7ci+7kFvpCy9UVeyXB+WMaa9jvme2kXZhZvOVHhRmWAvTCtd2CF8Lo7YJK9f8bA49bshQqaYxnr7BgB0ySxsqawUqJxR0oCV8mUmecPnvM8OkDyiNug4bEQRI92zAeemdR/tkYmsf9PF8kKm3foZf0BU3LQflOOUAkYx59al4iMTuxJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 05:58, Aristeu Rozanski wrote:
> Refactor gup_fast functions so each step of the way returns the number of
> pages pinned. Because the previous step of the chain knows what the number
> it should be, less indicates an error. This way there's no need to pass *nr
> along.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

