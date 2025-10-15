Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E7CCCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DEA8E0045; Wed, 15 Oct 2025 11:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4464A8E0005; Wed, 15 Oct 2025 11:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BCD8E0045; Wed, 15 Oct 2025 11:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 23DD68E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:59:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C068A572B3
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:59:08 +0000 (UTC)
X-FDA: 84000807576.23.78A2295
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf03.hostedemail.com (Postfix) with ESMTP id BBAAF20014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:59:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q 7mdH6H";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z2LZtyfv;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760543946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3YhLDOjSOHSx+F9m6lOAdQ2eMBIiBXjWJc7qhY9J2E=;
	b=LAKaGJ7ZrJcHqlfiJPvx4EBQPjNmTdizdd06PC///RvMfudglmRTd0X1DdwGtBGZ8lyrB+
	7FI1o4YJ7TAPRFkRkV1Dq4u0Wzz69QUReGtnNCuCkYzK6aZtTCoC23Ysukzcr+ajage9gK
	cifaAD07xlftC4w1xb6HrlgxySd/a48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760543946; a=rsa-sha256;
	cv=none;
	b=Ay/gj/rY4tKKB0Vt1WvuWS9RUPpwh+umQ4cUAStSVAbpN+3eOUFfaF85VxsvpiauB6ZAwX
	bNR7S5e2O0AJdRgevdahI9kT6Lfgh5dsKhnodLwYJa73kDiYhbi4o0JQPjdPHvnq3hYuLv
	6BqgiBoqFvFOQPTij2GkzxZ+0Tnl6Gg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q 7mdH6H";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z2LZtyfv;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id DE0B9EC01F5;
	Wed, 15 Oct 2025 11:59:05 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 15 Oct 2025 11:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1760543945; x=
	1760630345; bh=v3YhLDOjSOHSx+F9m6lOAdQ2eMBIiBXjWJc7qhY9J2E=; b=Q
	7mdH6HUNhs14Dp1G4lGpDlcmQ6fcxF1Z+cAR9tC65LjD4qspFH8Xvs7Vc3zChVKt
	IjvdyO6n41JZIWO+BDKg8jlTH6VBOtOS/VxWPc7m3VA5qhkU1OWhiHnVO8v/JbGc
	RzAnYvknk/QRf1H67x99OdNf2iyooE9dhoc0TNsADCwhwcqv+BkWIl0/2V9/rxq3
	GNiXzcRvPyTp4ROlYZYvJ9cmSQEHL4eSPqYLR1fVuecqHsaEzqx3Eho482MG2jAq
	Y8IExQ7SqUlNsvJ8ZSBSzRjJjuwn3Ya6Lfk/G9peSPsCEbDTy9Ds+zNkaAksnQe7
	WnkMLa1H2F4ZXU4r6NcmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760543945; x=1760630345; bh=v3YhLDOjSOHSx+F9m6lOAdQ2eMBIiBXjWJc
	7qhY9J2E=; b=Z2LZtyfvAxOH6178TmtGPgwo2HwZZww0KkTTY/SxLrrj1Gra6Vt
	FG8WiJExaHMfTJh+2eRaUKaGvpALeZVP0xmUbjt/F6TJKeLFnfeSs7d/Bn07V9y6
	rHTuHfODwtBXLheoTLehS6p5Ci0P44UYztAzwkAHBtF9MsNKKlOi/sZ4lKN2jE1M
	nhJn0DLibo9eSJKRMSs8j8qzsquKnBGNTIeI6vjWpHBcC2yor2EWtFDw740L+Jx7
	WS8WwZyPhjzVNI4JYd69yvBiyFjbSOEAe3/poZcSNec8E3vB4R6NNfrY650VZP5X
	h7igwPiFPX+Mp3OlwsEXqQr7GpfM9H168ag==
X-ME-Sender: <xms:ycTvaAd7F_rGgLOsbJOrmFCtKTKz8AZNmV2IIRW8JiV2iEZm9NDy8w>
    <xme:ycTvaIkqZmPsrqJFivkAKstoWNCOp5kZX6AsznJaNGjMBw2uEkZMg4gEZnpUHL8ra
    gQG-ZUhFFuX6wkrEt1CH0hYfhgXTItC8lN2d9CMWulMuWmWMLJRSA>
X-ME-Received: <xmr:ycTvaNxT852gNlaDTLj7P11PCqLVsXesyJ8uHkKcHQyb37OmoC023KUQmGWh9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdefkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdho
    rhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epfihilhhlhiesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:ycTvaDz8L1rYsHHI51SL-LQkF2tPIDfCBHztiSROBZ_7sCXg0MctDQ>
    <xmx:ycTvaFVYRquVd3TiPgcbAnhw8_-s-ip-0vGSqPq1aAqI3tgcvGOAtA>
    <xmx:ycTvaCRGVlJyqA3Qah7imWMfNw44KfaYxEGAx5SNRJHlEUG9o-Xi_g>
    <xmx:ycTvaFQY3uz0A-Ok3okAaODb_MvhMZMvkhzinNWfCcWRNxn-hQ-XSg>
    <xmx:ycTvaMkFnV31N70t3bdfB9HS10dGRE7AjlR0TD1pja_HYICqOEa9rdX0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Oct 2025 11:59:05 -0400 (EDT)
Date: Wed, 15 Oct 2025 16:59:03 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
References: <20251014175214.GW6188@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014175214.GW6188@frogsfrogsfrogs>
X-Rspamd-Server: rspam05
X-Stat-Signature: ki5euor7er6jme8xjmrjt4ie3w535e9d
X-Rspam-User: 
X-Rspamd-Queue-Id: BBAAF20014
X-HE-Tag: 1760543946-82329
X-HE-Meta: U2FsdGVkX19d6lyqrLaPz7W8XemqJ857ZPNSzWyIq5lg0S//WVrBqtYRS9RlZo9SIPTuqA8G8lSbztkXsW16yZjpCN2gEx0gWqxKfhQd9qGNNt1vYmsG5/r5P+HTzsuE9W0ykRhHUJR49XZbF4qV29rwvQxPFdMOMJXGqesz8tP0Ga0w4tzpr8DDOnzuiAipiku54/3fczyFt9v2h+95kVC+DsTx8AHdq62kzkSXRk8l3IgwHBJVvQiGnVVV9evYE5lHa1gZ19nQt0tMX/tnxKpp72om7ufANKT5xjMvve5xe6xmZgjmkGEOwdmHtuZV53bPU1M0ffAW3KPaYYCMnVS3lQRorrfoAXYElA3YGZluoaef0Ire7z4yE6VrQngIYr1In3nIbuK180CZnC1D98XJwB+EgEOjjcZI9U85AkxV3stQyRDAII1sAXO/nf12DWkqQVVaYNOhpQmguK785Vqd+KM3pmWFlSa5OWEiDT7TbmtPTR3gYDUykKMakDJuCysrTGz3GQjpktV7/WfF8veXBJaNo77EJotoxJG3b/gwBmNP4zXBhVIPAEWqHlFnRR5AvsU/6qIEVfV1f4vF6P83zr3sfbXgbImKqt8DhBWFHZoNF6YWNZsdMjKcoaaeGBcwi0Xd0bN8QOXO6yLjGk4A2Q/J7nwgHLuGH9y/LcczhX8HrHggmZMpl+zc5il6WEpzMAZFU+9H7x97Y8YBT42tFMZ0mqNI58p1wsi+ZN+irSQREMdJnme/mni93qc+NTmphZzvMxMCUExdI+/XJV/XQY7apQ5/C5o0ikxrrLDiNIqPLktAT745O3uwXpvif749zQx4bgR5MMOg44gdBpeitQtH1EqynxUAkc0dgr70HMr85+WcqLQmaXYcaCtnhnFZTQAitOELcJ5dYXt0tAcB5XxgWUKAH9Brn5j/oFma6tLgOkG7sb557jSqTpyzRzN/T4leMyCgyPGh01U
 y+/yTn2+
 8tsnltvcp8fA3Z+cqYJo0Si4qRFsUSfcvlKwE8HvZjFqnl5VzR4CLVeSafmkzGgKK9C3A8CsSoKye+hi43geJVZtRibDOERFu54wBdBmeKG91Ux6EIEqZgHbBdpMLotgjoLoEKEcH3OF5ay64n9cdwSsx+BjlE9Vzx8S4qhsMn0vu8B2Vh+dM/p05j8DuRr9cWH5u3W1zN9aZJRggYHVy5vmJvDPqTS3lXUOdhEIY/rx+qZ9f8yOtgZejHU1r2fxzMgwgG6WqmXFn8RFAZpyGWGz+RSsPWEcyoB4WEddTM9TFcEikvkjVPivhGE//jhq6/QYDLS+JdzLJXmuivIPVQr8qgWprjqTKWnIbYzTqgUyMUVonm6OiTguNSUaZHOIS1T7KffIFyJxr+1nrTlUi6uuZgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> Hi there,
> 
> On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> with the following:
> 
> --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> @@ -1,2 +1,10 @@
>  QA output created by 749
> +Expected SIGBUS when mmap() reading beyond page boundary
> +Expected SIGBUS when mmap() writing beyond page boundary
> +Expected SIGBUS when mmap() reading beyond page boundary
> +Expected SIGBUS when mmap() writing beyond page boundary
> +Expected SIGBUS when mmap() reading beyond page boundary
> +Expected SIGBUS when mmap() writing beyond page boundary
> +Expected SIGBUS when mmap() reading beyond page boundary
> +Expected SIGBUS when mmap() writing beyond page boundary
>  Silence is golden
> 
> This test creates small files of various sizes, maps the EOF block, and
> checks that you can read and write to the mmap'd page up to (but not
> beyond) the next page boundary.
> 
> For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> folio to cache the entire fsblock containing EOF.  If EOF is in the
> first 4096 bytes of that 8k fsblock, then it should be possible to do a
> mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> to the second 4096 bytes should produce a SIGBUS.

Does anybody actually relies on this behaviour (beyond xfstests)?

I think this behaviour existed before the recent changes, but it was
less prominent.

Like, tmpfs with huge=always would fault-in PMD if there's order-9 folio
in page cache regardless of i_size.

See filemap_map_pages->filemap_map_pmd() path.

I believe the same happens for large folios in other filesystems.

Some of this behaviour is hidden by truncate path trying to split large
folios, split PMD and unmap a range of PTEs. But split can fail, so we
cannot rely on this for correctness.

I would like to understand more about expectations in real workload
before commit to a fix.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

