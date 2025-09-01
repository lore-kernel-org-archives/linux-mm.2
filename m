Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC535CA0FF2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 00:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D8A8E0002; Sun, 31 Aug 2025 20:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C76C8E0001; Sun, 31 Aug 2025 20:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5C18E0002; Sun, 31 Aug 2025 20:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43D268E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 20:38:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA3491402B4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 00:38:34 +0000 (UTC)
X-FDA: 83838820548.25.A9838FC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id C3AEA80006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 00:38:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="qaZJL/hL"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756687113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54NWpDdgI0k7Pd6QCJD9fzpk2rKp8UKAoch5Z/bQ3A0=;
	b=d59MOO3FiAM1yoTOA65YFh6Ks1idmHEtFH9390oOKCb7TI5q7rvPviQc+hWXwHNXKVm7c/
	yOj1FsKn5f99stUMNLrK+qpFz6DZRTvOiymeZzM7EX8r5X4KkgdGbVFyUoB3/OyU+IVIb/
	4eauDDT5aNNTnZoYlOPTAZEEzuaZfJo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="qaZJL/hL";
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756687113; a=rsa-sha256;
	cv=none;
	b=QJIFiZROnvj17XGBIcnoFT65dDm/QGydikUI+PLroFFK0CA3+AoL9YHNd3OmJupX6Ed0FN
	hGaf9Tp4Ccv0gy99JicS4vLPB+fkpKialU2ivwyaSA0zZra/9l4UOskJ3Yw57C+tuTnCnx
	wYiZ0dhAuyg5OXtjC3x9MRq088A4omM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=54NWpDdgI0k7Pd6QCJD9fzpk2rKp8UKAoch5Z/bQ3A0=; b=qaZJL/hLYzhNP4XSwFN0LdlU8E
	5EPSboinnDKVo6dCDpb0Eh5pDSln8a8ghBb4AX30Z6HxGvpXY/drYwUe0zbg835P4RtmjS8axMRaK
	NZhoamFpSyNkrMVPLtejI6ttQ6jIZW7QElhZi5HBBLkgDrGw3PkryXSEg44xYzvAjlT81MMR7IFsF
	Tn7sdYhbgVLJwYKOtM/Mv2ZooX+KwF3BUEmmRzZS+e/F/jmi6+4gsV74z+C6rn73Y6ifAYBUARVjr
	hk8FmPBA8zWeG/t1c6XS9a9C2FlIwyVplDyJxuA81+mb/sAS95KKKrrPzgk3wqYGo2HAHJ3W+nxl5
	l/84cX1A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ussZ1-000000004KI-1TrI;
	Mon, 01 Sep 2025 00:38:27 +0000
Date: Mon, 1 Sep 2025 01:38:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, hughd@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Subject: Re: [PATCH v2 07/12] parisc/sys_parisc.c: add `const` to
 mmap_upper_limit() parameter
Message-ID: <aLTrAwhfHne_iuVS@casper.infradead.org>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-8-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250831093918.2815332-8-max.kellermann@ionos.com>
X-Stat-Signature: oiar4n4ya7i6h56zmhbq7ngohacygnzb
X-Rspam-User: 
X-Rspamd-Queue-Id: C3AEA80006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756687112-814173
X-HE-Meta: U2FsdGVkX190PodQLPkTZd0GUAnXiu4ZNsT08xxcNUzD/+rMLza/Y9Lr0zCrtW/84BLZoA8g9yc1LWgTBafRdu8hloRL6WQ2fT2iYlzX6dIHkatiRKYgTsIy6XeNz6uI4EDxED0thj0yb2PH4swpGU/9umIUS59H/88wsuSSZLHlBANdBC/GGIOzEug08w5DQZfOgLW0Jbi4G+iEuOQ09RlyTSYrd2usWwo0qFYhXU//mvmvct9WD8Wg8EI/1KB3abOOqQfYf4/6Mok7XwUFi+BWBTKqt5tWq2rC4PYWc4An23hfa1Y4y55ddpwrCsjaSxEcqgihkeDKQk0rRArdPWdpN5yAUKZvm3bd50PqAVBgaDBRJ5JFRl7EUfhrVVoueaoWifyozaC0lN9x0B9h2kv4uxVvGwC1gx6/JQaRDtkn9K15c9GIxzSmlxQY7DD+iIOm6QNX+hZU/Fg/54E6ZypCJ0TkXLjHJpXlo6ttTUM/Ogzgcq+V9K7oIZ7tb0VWxK5mbEZFhNsz/M5WvuaJyiFugcWuS8DNX6ZVJZdETsRQ8PVZ7rRBS51ErCXrgEMc+vrMW8tuv/F1ngnFzcqy4e5Sq3sWW8DI2FLWcWUMlgqnvvp8TW8dthd5GMziGa2ENZfD1LSlv69I8RC/LH5PJ5rnsKJlNSdkdzWXhm6HDFqMjP2Ila2FtWevPvo7n7GnIQXw0O+uk1ItC2EpcBi+HRwOqvLCpDJG1JaaL2DcoDS4jGqnJqjNqXl7vNcDgmrb+e5vNTv6nlYaiYCcdQrODz8Uf9pwmooq7Kk172q+UKXX8sogkqphIA54/5AlNpuBrwpSWt6cjEY3R8Db325g3xcwUgpjHWbfM9KtwbN8rIwytm/XDkutZrufGTciZRb+x8FRWhLVvsmjCRsls8jU2dM+aKzCrVkr5cO/EEqef6/DgI1ddVftfExKCmDWh2DMkBKyG8PQUdN22N8KBbI
 EjzKdD3A
 8GPth5C3tuVrKCg+K/dnzsR1Et0foMVt7tPsgrBK/FFqBae99q6L+OMm1LS+MNlXzYHLpQi9NkBCCZSZcatjhmObFtBJ2o5z35Sp1llSGCwfpvp72Gsm89KK3hISxAuE+811e69TNnls4RygUuF4p00jEGs2Sv0d/a5NycPJt0fjaVThJRCAAF7PN1QVvQhVaITgHwXOzVDG4MZpr8i6ufBRXLq+KkG+qUbRz/Pou/X+CmmCrWl+VWYqd6bQoTqOvyYIK2RDoaOxaQS2GbaeUPaJHckHcJ3QfRwVnvOf1L+dHjlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 11:39:13AM +0200, Max Kellermann wrote:
> For improved const-correctness.  This piece is necessary to make the
> `rlim_stack` parameter to mmap_base() const.

Since you're going to respin this series anyway, your tags are a
disaster.  Tags are not filenames.  They're just to indicate to people
that they should pay attention because it touches their area of
interest.  So this one should just be labelled "parisc:", not
"parisc/sys_parisc.c:"

