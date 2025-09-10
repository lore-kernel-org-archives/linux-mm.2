Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0214DCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 23:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2448E0005; Wed, 10 Sep 2025 19:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B99C8E0001; Wed, 10 Sep 2025 19:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6C58E0005; Wed, 10 Sep 2025 19:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8518E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:14:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D790A85B36
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:14:52 +0000 (UTC)
X-FDA: 83874897624.26.16F66DB
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3653120004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:14:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="RRkLD/Ym";
	spf=pass (imf03.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757546091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2fld63/s+WDcn/QEX/bDxUyxq6m/Ao391/YGsr2LLA=;
	b=jJ6PrZFXVEgXMjj0lLlHtGXi5zHt6Y4NqHQ71CTiSAAbFAPVbmbb4P3ReMSKDnAExoAsrT
	/pWoQ9FTqFYoXOb/lTUj2LF+072j1lW8huJeNaDQBm5iGeTO/fewPNpVpBnYxY0oPCJDi0
	GFeOziLcYYVRVCxvxrgT2S710xVKDw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757546091; a=rsa-sha256;
	cv=none;
	b=jmXfEr2GWd2QTXtiZ0llRUNlvVfbr/wx31B0x9cQxeHuxwqsds7oTUy2Wo6wO2hDm3jnbx
	GDUkUXSZhvSGFJvt9cy1tpTQydVIDFtSunedseN+Vu6V0HiFdnCYAAiLcrngvpxSHFtTAX
	hSk+ydCso4GnFykAz9MdKBuDlpnzskU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="RRkLD/Ym";
	spf=pass (imf03.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757546090;
	bh=d054YkAXE4oEgOCAfsLAxCijSf5iAwi41O3QBJvn3kE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=RRkLD/Ymce0l2wG5pvgokhyJqBtHS4w4bz/VGcHygVKQ52poOU12QEQ3RGmyuqX5C
	 A7LVEV52Riz2jvJSITa00xjhrxoX7qKyL7Dh7ic15MYGB09G70S8mb+B5iAyfVTD9D
	 bXRQ4dT0aReg2S09zja0f+9aDv0HyMzxpvdtbuOg=
Received: by gentwo.org (Postfix, from userid 1003)
	id 362144033E; Wed, 10 Sep 2025 16:14:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 336B44033A;
	Wed, 10 Sep 2025 16:14:50 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:14:50 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Matthew Wilcox <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/22] slab: Reimplement page_slab()
In-Reply-To: <aMIDS820ovAjZbaA@casper.infradead.org>
Message-ID: <a1b6f9fa-fe6e-8b73-f552-1aa220eb627a@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-7-willy@infradead.org> <8eefb8ca-e310-48d4-0c3a-fa80665cab87@gentwo.org> <aMIDS820ovAjZbaA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3653120004
X-Stat-Signature: o51j9m3dnnrn8hzwamd9c57mcsskrcf8
X-Rspam-User: 
X-HE-Tag: 1757546091-14175
X-HE-Meta: U2FsdGVkX18eh9vFzxO64RI7JcCvmJqOy4ezjt8cUaOA+UenCjKlsDl1nTo0WJDGvF310HU2dOYgiL2Banhxb2tnTzpb6kdvpyBVWKGYW3JqyQa024YZgo0lljlDgYMPzeMnUo2/o47/kE0F0CBYBJViduxEwiVzd1U3/7YgQH+RLX8yW6nm6acg91dszKG14aTsdVOZLzP1ExEnO/fLQVC9eofcj8cPVFEoPxYhBDk9IaKkyPrHz81y+1qPHOVPcecqHqpNp7BsYnXYsMOvLRZC8huy2x3P8NnhtmqMiCMri5/+lINl3s08hmai1O1azd4OYiEkvKdIBLdVoJJ2qyr0xq+h5U4ky1yxeeNy1ZUYheKLUnQBi/oiPrJT0ItofAM7zdVQnqyzuLg/rVkdgEq7Rd/WUyeMJshp8NBt4fNCQ1jnX6z8A20ZaYGWDTf12x53nKPddGiFCYL6WPdIDHq5k2/Jniw2wTXFPgA50WMxxH9Yy6wKKZxCYpwLI1jhUS/CEsCOpeG25o+cf8FzCRF4vxRrgYhbinANOYfyi6YhfXjWf5aGRNQCtq1SODdEFGNXMtTYPC6fE31Jy3mGf1CxVYrA88rjjkti9480FUmLR2qxo+WTkhtxsjThNk/qSh7vt/fkjWHyyY2/E/C4h0UoiJedU+xWh8kiGmUcPl0CMVX/jzzcnx/NHGlgcnMaMepZaXNOVt7ssQeSY/5+4GMdaTlyIH82xXy38UusVAjuDzWjQFR/pDeDbCsucD3JOjAE4OwU+nd7AuxU+V5Awgiy4S/Qx/lydaZuhAOYfuoSh4ad5cL/voWKkzfS2/05SUq2vSp/dFb8LDD6UEGUDdxQpAi28gR1ix7JLZBS0rVfkp/TgHLV7kyZdPTLzSN2vVoppQ7/dgM3kHfsMoSn+YgxxxclXUlVVvQgD5b+oqe8iWghpO5Iof+wAl91fHzXaLwbutQzCRDQIlCsk8T
 apjHFm45
 QJLrLC03N1nm0HjEcY5tGjdKBsFKlM+mUyPy8mr2oXziNuaaQAYVUZ4oQOANODYbwKliYDSG3HmkN5sOdyFwPY6y4YUZqTzQuky/IVObU3XPgKd9F4z6bwAgdDvrsecHOUjrsyvpq91uVHHlsp2vPdNHFolMYfONjq1ND+WDBvbODh6gowaEqnsNq2j8V+i+35nESJDZmy7iktES3DojFjxX1BncALBjexeE99Em4/FDRRVN8SNxQvXkFiq1vt9rR2FjBhJqIKToJ47BjF37BsM3xqMpTTPyU3VlE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Sep 2025, Matthew Wilcox wrote:

> ... so that we can shrink struct page.  We've only been talking about
> this for the last five years.

Yea I never found that too good of an idea. Maybe others think the
same way since it has been that long.

