Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34B6606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SgkIFv4n
Received: by kanga.kvack.org (Postfix)
	id BF3486B05C9; Mon, 23 Nov 2026 04:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAB66B05CB; Mon, 23 Nov 2026 04:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C016B05CC; Mon, 23 Nov 2026 04:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAD96B05C9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:40:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0997D1A0806
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:40:30 +0000 (UTC)
X-FDA: 85465888620.11.1B7CA0F
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 47D0E20003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:40:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SgkIFv4n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426828;
	b=PtWUe2m63qc1jF/tlbF8sDRI1HXMYXM92m7h/FOeNNjGHsntKMbCHvuOTeRrdA6wE0tAHl
	dYGnfWyOTpPA2f3gOaFDDpSF43FBZ0SqBrnBB4+i3WWyZ4Iy16GSUrqPnNYn3yQsOLJQ85
	UEKOFq+EYWLalC09k9/2SaQ/l2ikl1A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thx09sK5axuy1Mqno0O+zJDzS2jXR+z5TmxbMTktwk0=;
	b=oYTe10dcKRQXZsq+ESKPZuNiFFfosFpnSKPdu6oSatipr0r9kNvjKRiPEaO4Ca6ZITHoHo
	GMIPlXae0Zj+hRndlo/P80x2kuJUpQqDqdTNj+9cHZpaDUGW77Eic19nGaiv0xB6Sv56Zq
	OPGehSze2FdAnb0TemmrwfpY20YEDY8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SgkIFv4n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-67c58f18765so1980585d50.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795426827; x=1796031627; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=thx09sK5axuy1Mqno0O+zJDzS2jXR+z5TmxbMTktwk0=;
        b=SgkIFv4nOj1V24ZJhITtuUjRMjnQH/krrqQMCX9+g3npXtm3H4r0gUAdk05lwIzKJ8
         2cr+hyJ862jIR+pRYsC1HSX64ovSJKZBpgf25KMqHYY19pJgY7sy4Fc0wiUlfRy1aHdk
         WRY09Dri/cfmX79Ym5infUiAy0lsLF2Y7ViRUNiM5KT1oBuPeKZErlPcTKuG79xqgqdU
         MR/SlUQJ+RuCTcxkhl0mcAqJqOuhYHi3mDrR+ayDXUXXNKAGizQPgPpkz2y3Ttu4UDlh
         kVlvn+STFXq1blioQW5cJsXBWXte2OV/OI5nKWyimZHiWWsPLPPl4CwHgWRuAVC86UWs
         kLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795426827; x=1796031627;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=thx09sK5axuy1Mqno0O+zJDzS2jXR+z5TmxbMTktwk0=;
        b=eJdAOdXzjwThdGyQIhY5Wu3G0LJ79E/w269/X8wpdslsx64K6Qodobl7hEntyDXcfB
         eT0mtNtNk+8lAk4hh6GAMauBtJy392iVV+5Vn0fm9/CPvYufYNAdiVHjoy3OgijVOGAD
         Xwacbh+vTQyV5W29Vtb5CKuvd4pUOUGxUSxx59lqB/Qx9Ad2INR1PYpB53JQKtluyHrW
         29aTZkyn7Dv5+6/wyAkfVKLEf7lOo/r7RXMtdDMI59cJab/IGGO1oBvtFovJ0j1/Hfor
         p3aFOC4+KJWVDBqIysM6/SMgW8q5CGkX+wvEIfR6rd8RjUv3or3tWq+ljeSPrVszIpUJ
         0oOw==
X-Forwarded-Encrypted: i=1; AL+hErHJ9ZqLH20ufqqIIyuk4G+j0Y2c81BD1aZ2WMQcBjpDTiYBqpuji67IN/EiXYn+w1bYBgBhdgrMKw==@kvack.org
X-Gm-Message-State: APuU4Z+QXKpewdtbd+vzI3OiY08BRmwkIbuuo4yBNG1XL3wpDDwxw6C6
	oU05l5ZQZimBGF+V6jsM6muyXkrDiOWt35lSag4R8ofT8iSA37c8VoFohiGeKIeNmg==
X-Gm-Gg: AZFdTZcaRRqzmrkbI/5z0vN5kctT9V1qTjyfIfO4VKKu2NJWGRL8dn05vsdV7GIMu/y
	W7UO/bbEGKZA9z3TW6MjUYOYMh+kmoIvFRR9YU28jXalf4258j5f5BceUFSdagADWH3JES/2KGe
	86BW7GcqSITYhK4xOH38J9Nz80phO6qfeF/vu+LBgV+g7mCqihjp94V7tn0Vcv5R0GhYR6bDH/5
	+B3MFyKoaGDmnrkw4XQbZ76g8tCndvM6AI9NYBuGKCM9Rp3ztX1OPhSvKP6YqRMX6cnO5M2XAGy
	o19ndOcVEREfMfIaXJ3G0S3n9jgWz8JWeTjAnuq5AB3PpJ5UTv7VfLGT8u48p/BiPR7rnkw6hHB
	xBXSZVhsTDVL82SS5Ka8pLIIcqK36XIDvTlCjsH5oBkde1cuVTagLK7qvo1FD2VTwLF9x6tI+l0
	m+p+NbO2SRsm3Nvsy+DqVFXmkcJwDpW1f2i5u17tIYwHFV6HD/a/tJNkTDaqqNl2maHgZmuFadc
	CQcAw8FK/rxgMg+l3dHwCYb6K1MhiW1tDVqQBiN+nTMtA6iNhcsIx5KblIdHuoieEwTHgADBnx6
	DI/z4wfSouuMEImFo8OTnmXGG1nSl3CBPipDaqpnOQPUmRL9hVapTFvoZ6EUevRRUu7QGQ5sdfX
	hDckkv+595bdq5h3w0UPdKOxX
X-Received: by 2002:a05:690e:bc2:b0:67c:70cf:c90e with SMTP id 956f58d0204a3-67df443b020mr3503639d50.39.1795426826585;
        Mon, 23 Nov 2026 01:40:26 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df33105fesm5150875d50.7.2026.11.23.01.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 01:40:25 -0800 (PST)
Date: Mon, 23 Nov 2026 01:40:09 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Alen Karnil <alen.karnil@ideasonboard.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()
In-Reply-To: <179492383658.1554713.9260140415931487684.b4-review@b4>
Message-ID: <db50635f-5f02-73a2-83b3-8ec7dc980b56@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <179492383658.1554713.9260140415931487684.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47D0E20003
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b5g85tscuos9fh4ff666jgu4k5x8qqnd
X-HE-Tag: 1795426828-661446
X-HE-Meta: U2FsdGVkX1+jPqLCJ+PmSSG/damA6dWWpFW84yb6so3IMHgfNhJGbgu/e/qo5CZgWUWLpE7UO5ez0akNCf3dHvXZ/oXsBW9hywTJPO/FgD+h7tQRShJdAbx4OjzzDCopTS/Rt1iDtZlEsST6q/aGnYZpWj7MiKtEflz57OvegktqRej+btUIrNOO+LwmRx6GgDZZ3TDHtC5vL+t6i8mCQcQXN14UbejjndeQMvAhxrxlPO2INiiVIMo24iAiRF/ioQQhYZvADcy51rHfp8AIZVBmJrVxe9tR91ZE0Q24FcegInr6oqmVzEJPlr+ShkkxM7vz8UOZ3UrcJifRfpc+TlHU/Ef9iQ2sGJ2NihoPb6lyO9dkWmmqJe5rYIv7h3ULXR/4X/Vo664UJabIXjCFscnbNwi8sEbiUtCSi9HYK+TDXhWERzC1JEpsBW7pHFHavrjMafcwdXTUogJwd4Ha1rOdhLtl9abc2cb9RUpJbkr0/9vBUqzFmYMNmYlXX+XZk42ty3O2YFbHe2E+5wXOZ9JEotUauJhSF2FtSoMZp2dTiIgnJx9PHUEepvsea3iC319f6SEwQIijKtFZbTZVEcdT0AeVorsbzJXy6D8y0bRDcGIiyO8Zasq9vNbhg/mYRAhjrMqsFJeZQX3D3BMae7hZQVsV8h8cdhnQAARwxybHrF1+z25ARKYgcDC/d9Dq/2XcKPSClV20AmD0Vc1hCYFiRNbQM/1Twj/CeRG/Zsanhhua73shbF2NlZoAQh/hN2PmvPc2wm2Bcjiz11ZwuK7+YXJeN4p2i3TjLu0NWdBxFLl3WuOGepXh2amx4GUf8HPcnqLt2317DK+x+XQE+VbCSMUR7BFyYU9t5wO9wXz+xWiJbKPSir3cdem1d5Iwa18s5wYdH6e+5etiknIun6uoBRTn6GUaiyU1/hahEtyPbk/YiuQWyHyCfvYYiUKdNjW4WU5+Yw8Iqhf1aYQ
 EK+X5vEg
 0TErxzMguEL16vEb+78cV/rCokyETfLZLx5GEx0dITHtsVytPAzqcAzvn+YnMGzx/ne6tpDnj3DvfPGqD7FzTzp7iY4j6C5eRpQQcR3ReqlMu/NQYvKO+SsAg0kRKoKwJsC6XHQ2IXPnACg3sffGy+zDQuwdSIL2nC50+NHtIr8cFoQ+4j1u3xQPhRB7CqRD0jjb7vbMATdPGDf4xibWJqyA/AStoc1JB1N3ZjEaTnDkNdQljO8/mMP8WPDpJ6oplCPUNiCCZUDXlIUzErsDj4XBOVh4Wi4xpiqZByyYoRioTItC1IrVpwtgXqDmV5V60rRqptsuSc2kcWJBI6ejJPonixy33UyEGvKd7jB4PmY7hmfaiu4PZAnrmWlFkXM3u7uXRNTM31HS3rzYXd1Ukm4WZMDB0Z2iqbHFRQSs1zxAqs4QxWeTwCpXEihK8SOQxsAMzVDcW6ZutwgzZmTQUcJiAIsTdkS8i+rZelMPU1ZLGJZe0oascqL0WjNH5IemvUiUMQf0nHlo7yW0geQPnFimeU0hwPbPOGiMzy/E81wrOXSKkmehHyMOhaBSlEf0qg4VUqWFCd86bx2SoHTD8onwfOUcp0DSHQ59HFrFqpBGYYjJdTvh13n1qlO/93IQDgrTdy19jZ2vusf0wJ587DE11BgiJyFqKvq7NundfZ3DtGhVnRNVKc43HYCoHFA0oQybP30DMEjTYw/Mq4HlcCoovaulaJiFGjlNmvfHeotG1SvnUX8W9f3DQxr+eawtBrRgA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026, Alen Karnil wrote:
> On Wed, 09 Sep 2026 02:39:08 -0700, Hugh Dickins <hughd@google.com> wrote:
> > mm/fbatch: drain lru_add_drain() and _all()
> > 
> > [PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()
> > 
> > This series was prompted by lru_add_drain_all() appearing in watchdog
> > backtraces: not to blame, but blocked on an unresponsive CPU to run
> > its workqueue. lru_add_drain_all() is a heavyweight operation, which
> > we often hope to avoid by a much lighter lru_add_drain(); but even
> > those local drains can aggravate the lruvec lock contention which
> > per-cpu fbatches are intended to ease.
> > 
> > [...]
> 
> Tested-by: Alen Karnil <alen.karnil@ideasonboard.com>

Thank you, Alen, that's very encouraging and helpful - though I think
it would be too presumptuous of me to add your Tested-by tag to each
of the 26: I'll just add your Reviewed-bys to 01 and 02, thanks.

You may be wondering what became of the series: it's good, and I did
rebase it to 7.4-rc2, folding in JP Kobryn's fine improvement (thank you)
to __page_cache_release(), and Kiryl's !folio_test_unevictable() safety
in lru_add_del_folio().

But found there was already a conflict in folio_batch_move_lru() in
mm/core.git, which would make several of the rc2-based patches not
directly applicable there; then saw David's "MM: Firefighting mode"
mail, which confirmed what was becoming apparent, that it would be
more helpful not to repost the lru_add_drain() series this cycle,
but rather attempt to review the current fixing activity (I've tried,
but just cannot keep up with all that David, Lorenzo and others have
been achieving).

I intend to post again around 7.5-rc1 or -rc2: I'm probably naive
to hope that the fixing frenzy will be less by then, but I'd better
go ahead with a repost then, whatever the situation.

Hugh

