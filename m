Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B18CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 11:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5236B0088; Tue, 29 Sep 2026 07:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66546B008A; Tue, 29 Sep 2026 07:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C5C6B008C; Tue, 29 Sep 2026 07:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 878776B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:44:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F5F51A0493
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:44:09 +0000 (UTC)
X-FDA: 85266616218.20.05323A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86684100005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:44:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fj4X+yZ5;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790682247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JupBWX5Dgm/XapolKaVNX89w3aaQEMjgcwgvyhJcaKU=;
	b=OmAjDnyuHXBsAdeXghJQQcV1Z+mxnnpd3KyVGwASx6sxoqmyvEpgBxQgf7idT2zgbwLQaG
	dcTT8JxOjYWQKgdwHTYV0McnoxZNn1eROHghGXOVXgxtF7Pa2xN8dfHpQ3RRXHWogstMoj
	waeEugEnXb8KEq+IXi7bdMDDm0CLhfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790682247;
	b=Y1JZpp6lriUF/NCQOALoM6YUrNsk1n+grI0aHh0ocLVhYV/wHYn0zEzpe+k7yoiyd+p9aW
	c43kFS7aqGnGntWnhGNeWCk8leuWSDSw53sILGy4Wmiymf12n9aORZ41UkVmZqZqghPLwK
	2+kooDQdC4EbqqMsVDy6QUt6++SaM90=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fj4X+yZ5;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46D7F60216;
	Tue, 29 Sep 2026 11:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400A61F00899;
	Tue, 29 Sep 2026 11:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790682246;
	bh=JupBWX5Dgm/XapolKaVNX89w3aaQEMjgcwgvyhJcaKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fj4X+yZ5nn4k+cLEiL2kKRq/ZLId3xzZ1TtrXnvnz6oyTRR9SiGtndisyhUv7Gahn
	 oSt2r4vbBBpQ1RgLMsnp8Z2Zgu8L0XHxhZv/rJXenox8fk2ey39U+H37ranOlf2oZo
	 aJmzPDhKOG5FYTh6+v+hhrFJTl7Y8MTT1FlNrCNFjh6KsMu9GgjKxrDSpuZwTG2MCJ
	 94QxjRJ7A5JMXzBAzZ8U9sjI/nyYST6jM9t7OWW6vF4tlITQnWQSxEZTKpuCyG9yV5
	 ItVM8X3RCemKdMqwHRGmDhoAs3fj/+OTrqUN+pyJdgT1RZL0TdAXXkbHUxoQfQ0O9l
	 /kPEIRUoMZxOA==
Date: Tue, 29 Sep 2026 12:43:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v4 2/2] kselftest: mm: fix intermittent failure
 khugepaged test
Message-ID: <arukdavnogCNfrzm@gremlin>
References: <20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com>
 <20260929-fix_khugepagd_fail-v4-2-2169c18f2576@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929-fix_khugepagd_fail-v4-2-2169c18f2576@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86684100005
X-Stat-Signature: 4pcq1ob4nyw67tcbhrdywi77fu8k9ru8
X-HE-Tag: 1790682247-375713
X-HE-Meta: U2FsdGVkX1/kPS9HAfW693DO49NlGhe3FIQJ5ijzRRKNu3sXIXsMKyEMf78m5F5A0DOr11W0tntzGFAnQvWk0sA3or9veM9CT8g4fawk/jzbrMJsj94RxKS7Bs2HZzmkEkhXjPoV/NkUpdUmL+zJX401D4L39Gh9Vgl6RXhVLr0H3fUpifC0WFoVH1bTYXWOS2g13YLAT/6zgf6WMEmfrLBiq7CUnnVzjxu06OyVuu14UwKtrl8V4YsJ4GeUcNftVuD1TKAyQQjFJaiE5NnTj1jNzdrv2mX+zt4zM9qBg6GD4qhxw9Whz1XhlpdMc1M5o5ATDWMZ5a7vw0RFfXu4FZYsfAvAwlbaFjH5qOmXU69uLWzyh1rUenYqmNsWg2qlSCsPTNFdayQjQKQOARyOcIKpShu1XhDR3jOs3FJmdQHbYrVB48HVglH0s3QRvPdelswR/Df+mNrOBmXV+ASIkru/TcwR7OIXU2REH3Ei7qcUSM6LgdSn/4jBERliyag19cEPNcYyND0AGWB1Fx3nXalXeJWrQMenif+mqSHqVoX6GAC3GKmqg/9yHTdsHdUfrRuMCl43YcSbwghPb5AxyvWma1vPcYVooily38QhB6YbCyl1xTdW/R960DzO52+UcGuTpuzOSBJBE+5JjMmSYZBJw4fkbfFD6uZSuxD+/xGA7sSnxe0ME+//+x8QD7KY6VfKTF0C5dmVu2ywNHYKZeN1Q2GcZXO4b3GnCaZ8pt2xBLlvXQCmF7hLzIFf92C861Z+Q+cbub8WuvQuhrJzE3rBs7Z+0kohZsl7SjO2AEjLD0xqkCOapvq31A9UWHIpLEhQBso4ay7Hd216rXfs9AD8KKEe9Q1mMKcpaOWUysC6QV5eC9xrJjqyWiknsYiHTf8DUUlpzdiuxPnEwafEzSmoGzEv7EPrElIvNGbkELeZNLDzMsD4B+Ja0HhYF3yVH9jUXr2GyZVaqBENq9k
 oguiLf/V
 4p41Uhs2tIyDkL5m2Qd28fup1W1PFoSS2ASVyOlOiq7of7LYe6ybefUGqIJGO83VarD0HU3ffnHDhcCM1eu0mhNwrpSDXUgI3+CxM1ZIdI8UXTEi4//dE7G3KH2zVAhOVNFPzx7TfFHNOjvEWCpA7QMPMJiDtSs4yZjEDRVav0pBbrTEEWKejcYHfuZHHhH3VcaKy+dQw+5Gfysjj04bYTlljUdvgvl/nwqC31YrYGZJocgS/daPllwSfidtt9uQpUCGifgSjdHPBeIBfrEkG5ER93OKiAVuyLgaAdf3t8OeGOWubzTZuoiMW1e2vPS0u2bN1WeKf3WeTiD0R8xfwMhfjYJbBFKdF4XFuvd7h8CElY4Rh2iesQ+RNVI4v7JS1XL0EmmAWgyonT8LjVwoeJaIsR89Xl90DLJyZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 11:33:19AM +0100, Yeoreum Yun wrote:
> There are intermittent failures in collapse_max_ptes_swap() and
> collapse_max_ptes_shared() when using the khugepaged_context:
>
>   // while running ./khugepaged -s 2
>
>   # Run test: collapse_max_ptes_shared (khugepaged:anon)
>   # Allocate huge page... OK
>   # Share huge page over fork()... OK
>   # Trigger CoW on page 1023 of 2048... OK
>   # Maybe collapse with max_ptes_shared exceeded.... OK
>   # Trigger CoW on page 1024 of 2048... Fail
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 23)
>   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
>
>   # Run test: collapse_max_ptes_swap (khugepaged:anon)
>   # Swapout 257 of 2048 pages... OK
>   # Maybe collapse with max_ptes_swap exceeded.... OK
>   # Swapout 256 of 2048 pages... OK
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 17)
>   # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> This happens because khugepaged may collapse the pages before wait_for_scan()
> is called, causing a sanity check that expects uncollapsed pages to fail.
>
> For example, in collapse_max_ptes_swap(), after faulting the pages back in
> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> before c->collapse() is called.
>
> To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
> collapsed by wait_for_scan() for anon. This prevents khugepaged from
> collapsing it again before c->collapse() is called.
>
> This failure was observed on NVIDIA Spark with 16KB page.
>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Looks sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 2aa7c9197158..4e888b7bf310 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -618,6 +618,16 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>  		usleep(TICK);
>  	}
>
> +	/*
> +	 * The file and shmem tests rely on refaults to install PMD mappings
> +	 * after collapse. MADV_NOHUGEPAGE would prevent those mappings.
> +	 *
> +	 * Apply MADV_NOHUGEPAGE only to anonymous VMAs to prevent khugepaged
> +	 * from unexpectedly collapsing pages during the test.
> +	 */
> +	if (is_anon(ops))
> +		madvise(p, len, MADV_NOHUGEPAGE);
> +
>  	return timeout == -1;
>  }
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

