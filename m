Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC0D10ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6398A6B0095; Fri, 27 Mar 2026 10:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610D86B0096; Fri, 27 Mar 2026 10:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E366B0098; Fri, 27 Mar 2026 10:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 471B86B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:16:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E93C1161177
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:16:10 +0000 (UTC)
X-FDA: 84592042500.12.75E27AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 86D3E2000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:16:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWG5gky0;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774620968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/c1KthjkOxHwKaeueld+RT/gif/5yMl0yCaJX9OL3c=;
	b=4RqKH/3VohHZZvLkyEmYCXG/Ng6fxbMftdUHLPrZLa5vwjHR1bqyTsliZ2uj/9WW+pqhz6
	dRr1NLx5116RpULT6KkTe0qBnu5z1NO9VmQS7BpnV/vxT8CWPtz3WGUqySlBywGbQSmQKJ
	aQ6aTwsxWFuy7EPgyx5Km9ZpGWWjtgo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWG5gky0;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774620968; a=rsa-sha256;
	cv=none;
	b=1KE0lSf4y6rCHB4Tk1uMEHKfyBns1fvzqXr/H2NtRL6zPlxBlr3/+vATlztxx7Wd3FSIla
	YwZMuzDCsIa1lLJJN9DA4zfROK1ubxdCx/VpKMW0XwY5qSW87W5z1011S8AHsGRDnujSlo
	YX3ejTXRsEsUM9BWT604aWUc4K3Tx+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 787D843DE7;
	Fri, 27 Mar 2026 14:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82D6C19423;
	Fri, 27 Mar 2026 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620967;
	bh=cth6dxxe3aanFcyw5202phYvX47q1y5QBdQQTr+zt60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NWG5gky0F9g85HFcO+1A//0rEzZc653ybEusycz7wMImYbsVsFcPdrmOIErCla/rf
	 ghRjG9HM6qdzEvTR1fr/I2HfTHlP56UmFPjs81tCGP7HTKwzNINWgql4XeP4vxLMRX
	 ndOsWYJzmmkF33kXKMMOgdIczrsZT1dbP+/z7lzIUVoOTL1Hl28nW+99olIEf3/iU7
	 TuFq5hbtduFU5wLCr7qTUwB3kyDoXGMpL8MKkKT/1Dg4xoXz6EsC1lT0WmolXapBWu
	 diqC+zh9otnP5sw8OS1/QTgNFmOaQi084gPmjeel071Tu6D2jmZUBPaIHtIrcf/GSB
	 kSkbgZDcSjB4Q==
Date: Fri, 27 Mar 2026 14:15:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Message-ID: <83506fe3-3b38-4053-9173-bccd46b4a297@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>
X-Rspamd-Queue-Id: 86D3E2000C
X-Stat-Signature: kcz1ht66zwgqz1aruxsw3ysuqc8c61yc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774620968-49808
X-HE-Meta: U2FsdGVkX19jiP6dpjzykRXMDIysPsDR1nsrCXwyt3WTDD9kHj3WQJCN7gEaNIhEG+JHcHk6cV4ufXXLO0bOKzgYVWSVHuFW4jjI5rpJt21nAY1q3/zOAglNofTKhTi3LRNybbz/J8JYbZFjxdIS54Y6F8ymcw5Rt978psCDSypXAfofhGx3Eb8xY55pwvRIbdxWlZBCByQ49KAkA1SuMrUL1AumFQQR6+rjmbQ5pKGc0iF6bjzM/nd4/eAxXKPVr1dsIdWA+NO1nZ8zvwOTRsxwth8QW8DnRanxtHafgOZ5CvgHsMmTcU6KxcCZeRjERkEQG2oKxFREfl/ANU9vfIM1xEyVTBsXYyGqXfPbyvyCYc9ZJMEDBJB9eDJHPl3pgIqb88yyySTuyjOVIiXGQDCCaFu7AYR8r91t3r7u4uEDbIrkSJUd8u8CZC1wAgmvYB8IroYKqU1P0fF7PC3e/VGyayNWEww9Fy8NPR6TrVdlWh2NWtjxUIkrAt29+Or+sZSrQb8bWdN3n5Mowl10xFFqM9JMexSeFV0WPcjOBjOT9D+U5n8aN87oAvfLErOw/EKXqw/NAkeJFfCQ0GxH8xo2oMQVp8SUL7/UUpZfIP4mD570BewjmG4WC0G9+rCey/QXnKvuNVessFIE3krFDjE9C0GEDpqtjA1nVJUJazBupHGD0nrMFtjjlK/6xIy3dooHdgthSTLuIQvGU/3JU9jL0KksW7hbjjO+UheFR8Tn41RaDhC3CK6ch5TQcOOKHnSoRXQJoNsS/a6z8yPP+UT4sr7/RvnQylZHPJOtOIb4bkZpsjKC4ze1361wJnbxCKar/nNHWnieMRiz20RogAsdYPTzwHQj0mMAIiP9t9YYPcXaHwf4ivHCVkPGdGwG9Oba/do8nvv8YkIDf2fPOiv6Vtp8JFM8ykrtJ/9ps9tg0cNT6MmYtDZZfJmLuL+EhEmLRrt36oHDRCIuWAI
 /xilC5vt
 Mjs6YUnaMJJkqAwkvWDoUpIPHWyimSuZ48e/bcD7pZ/lyYW4mI5VDk+Vo6EYkMNxe1HlAvYzAlOA9ifTCDc3nrLufZaWVh4a/qWsn/7B8dCkW50eBWKLQk2BhdfEJdGSt42YwZhWEXAQgoiYOoH4D9HhcLu9HtW6JwOPXMsaQqN2YS5q9Py1/xhqx8AkkrujlkyEDTexhqdGnpWn7GjIdLwVKZ1v7vzEJC/wk3rWfNwkbbbWJWUp6mUoM4hpAUen5ckq5z8b6B5alDbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 12:07:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > +		return SCAN_FAIL;
>
> As per rest of thread, this looks correct.

Actually, no :)

