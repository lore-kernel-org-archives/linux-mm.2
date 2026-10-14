Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8CBCC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 21:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993EC6B008C; Wed, 14 Oct 2026 17:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9448F6B0096; Wed, 14 Oct 2026 17:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832FF6B0098; Wed, 14 Oct 2026 17:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5206B6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:55:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C39611A01CF
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:55:00 +0000 (UTC)
X-FDA: 85322587560.28.13C26E2
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id F0D6D1C0003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:54:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WLrZ3ZT/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792014899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tl/r+D/W2AcJoY8jPgxUQJOscK/kJH6tWblshAIN4Q=;
	b=dI2tknIC2Px4x/iMAF+q6XFZDcimk+LN9vxNBcJLMjvZyV9yIp1ukXlhLGCKNYETO/NQ5m
	uFwZHkf0dqAFulqF7XQZqlKh4W5dee9Cv4OjlIY47Wr1ca4H6YqR6aexDg/cfVi+TpxRQ2
	aSR2z+FCHfA7dIS4G5zxXxhbQbK0pa8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WLrZ3ZT/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792014899;
	b=va0z4SsM+89WQVFOuvCOlWWrA0lj+90Qnyg8PJD+Rz0W4X2t+/Yr1hjU0LVUmHy2GulUiO
	F3uaslpGt5NHvNJVXs9wO+hrkOHmR4SjDtLaYE0nyw61Qg1SyKiK1JujeqgdyY+zhNELKD
	YT6d4UYbttWatrLeq1qCAENIkQDUCo0=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-872024e2b4eso1916581b3a.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792014898; x=1792619698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+tl/r+D/W2AcJoY8jPgxUQJOscK/kJH6tWblshAIN4Q=;
        b=WLrZ3ZT/W1Kc3R4aV8vz9s5m6LmtA/Ymh9myhU4wWeuQxl9RZoaXtaGGqfg6BP7tie
         9Q/drTPWnKneV/Ezgw1MqYyGF5egfYQ23kFggY4MYYrjGL0rvuGVX3s2Q5Bd4/1F5C9M
         smOZi4Xf/1vdtEqnx3fkL6tb1V3BQ49BBCx6rUr8kMJhsfMPF7KsJ3W5rWcL0NWD0M2H
         hM2k9TIxWRa9pPk24Dtw7jbfFzkq0U8sesJDhnc5HocTftjaS7hGzGayK6A8WbS22L0i
         IL2ByPh2q44CZPCIWkfCi/01LXY8CGLb54IhAwwkW5DA8Lky7dMTETqFHc9LUUsUIFUj
         2raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792014898; x=1792619698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+tl/r+D/W2AcJoY8jPgxUQJOscK/kJH6tWblshAIN4Q=;
        b=x7sp/itZSwOMZ7dj9GPxFG32p8clbeEI9DaCVOKXW3Kg9V3YVRiSLDEPJP0U9KuQFb
         ymsREszRebqfHDmj4LMd4PW98qa5BE5Wo9ZAjcTBfTk3V8hFO1dGYBlPQYfpdlxxY/lI
         eCFVLlfL4J87cvp/VvN7XgJYGCiIhCb9dXHyxax2XQwmqU1Ym0HLS5ZkAgfY4oEw6Urt
         cQj5dUmef+v8pqAO0KH7br/yaOCsUNPTmcJfDkdj0OrrK1FmtxqScNK8PhH+tXsgFqkw
         gKCE1snNd/me4+Zrad5YhbdwQwzzbDgi3U5vjBFeX6ikU+TkB9F9RFPbdKHy2qSDWA7F
         nClg==
X-Forwarded-Encrypted: i=1; AKwUvBylF6PB0dMqudCG0HyS1s0ttQ2pRBDs7mrA2JrsW96NcGQJRaZhvjvnPu23J/GfgRlXRRk6yTe/pg==@kvack.org
X-Gm-Message-State: AFq9FYKTd1WsXoNxvH3psCsxHr9sJvRb8jfG1KxWsBDK6EUbJ0gn8wkw
	wjQjeRoDhuVRD2bztXnU3LMmFCF/Do2jY4VOYNaI2z9hih6NKkkYRobPkNqVmL/DWXk=
X-Gm-Gg: AYBFou0d84nRfEN78tBhDGy/kDcO7CHd9LYL0eXCzGgpeBPq2/IzU22WH1B8ZOtR4Oz
	6naHTH6tPhALX0/LQz8kU71tSsFJx2KbzkS+4dBdTjEnvmUVtw6ylhGBwIXM57h08XwCnv0zIDs
	WbxMH3SaNOWgZXUjD4X6nA+NWEreMSf3LQ4xPN4lYnTSTdLDOt2UtEI/uDQ/sOpUOEz45e/Xk56
	+bMOJ1kgFU0nBqVCFg3Xp7dWNFJAq3mcEHD7pHVAm6pASGimMd0OOzsQh/aTlxkBPp8q5MwiPz9
	83uk7PCvoZot4I+fCUrEwnCf7rdfPDY9k8NzWwKrc83iVULSw2UHUwOEl72qxWvriG3KOwMF+Ci
	xeeN02f0WtbtSEkQjBMJoEs5u66xtl9d0kZIMkJpYCk9fSF9EZvn1w2Vdpnu37JuxxuIovuMdHl
	P5oyzCbS587oilia7w17+S2ULIFRMn0YuskO8sCtBWAzPA4qtj9TJcYajOYpB3ZRDGQ6x5Gc8zm
	S3TPjrTOoJWz1Y6UHedjCDjyTzZZIZRjsmCJ7N5WMCi+SDKTMosHvPE9AkJvIrOw8kAf8h4+ZqX
	9WB+VwUsnuzZ++9ZbumyM6c=
X-Received: by 2002:a05:6a21:2e02:b0:3e0:bbb8:bbd1 with SMTP id adf61e73a8af0-3e16be52fe5mr13068365637.45.1792014897554;
        Wed, 14 Oct 2026 14:54:57 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-253-46.dynamic-ip.hinet.net. [36.232.253.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd635c552a0sm280624a12.12.2026.10.14.14.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 14:54:56 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 7/8] mm/gup: walk multiple PTEs per follow_page_pte() call
Date: Thu, 15 Oct 2026 05:54:51 +0800
Message-ID: <20261014215451.515-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811025157.1632867-8-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-8-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0D6D1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 8wnwbuuoncbwe37898rn54fz9cwo7xp1
X-HE-Tag: 1792014898-588353
X-HE-Meta: U2FsdGVkX1+Vw9iSC4Dcro5DQe0v8f7PhxyrWmHDTkLJRUHy6H5jkyNZpne7b8GeoTc4fTAIKYxnweApOFWuIIdQvS9cJVDLd1JC4ocNVw7/SF9ZY69Wld9qqHBAO9Mj5rHzDY6okE14LGJxFTdQVd2WUqi9kMuy9Hj+35D98dFVODKvPa43A25v2LpwIIhhzwmp+EEEaO8NOsKh5W1dmpuoD3sbejofMFkFnexxjC5CaHcE9LTp4FJaE8w2wTKSufP8SG7H44jLWj3tzAxXisCsa3ilU42MhZT6bgmyDsERNq4d4lMp1W6Zp/bqg77ljhjalLx7QaVPPVdr4CUCL9H30+YdjZLzzcG7h3w5bfRvLghYkXKSsBdwXXO3b75rZERaRy7d9z6X6LBJKEOc9MBdqnoRh7Xl2oOIvwuz4UORd9UWJcPvPLwJBFmOAU9QPoiHprGHibKxjrjb7FZquK8xi1P/SrRc8BWTDMUhRfI2HGfTwGA+m2U0eZWKMRqpdVkzV/++q4dRL++a53S6SB1L0uKgZ4jvaL3L2Yl1mafrlz3nOWCBpKqkuZf09FRfnUdeZ/Xz7TB2kIFJMjf4pO8jvgGc42s/lqqkwRjqZDO09OT3w7Zdwe3dV6RJSip+pUVik4K1Ac7HyBWI1/rQr+4ZM+tDgu3cOpXixsm4UPzmVm1D/VTPdSEoBCIS95FZYNUHjByT6H5GH+oqzGwrjKwAD/a0jSywL3xWVLxGqMHBy56myhmphR3gX9FNusilVuhvWAYMkv8ED0yyNrUVNwENuHmn2KJMx9xnhRTLjQ5XEIbhFNHblO26XnWzlQXMPVSvcg3ZRx6scBQsZSdCS4A+8EXNk6JlS1BapsbO4dWvAkyZqUOoDSxTI5owLUCPji2vHau4rxv9+p2AkBevoydBTQGM36AYR+2r8/JicsYpYEqynu5FNaAGZppGLbz5nDfMrfgtzzWcmIrC6p5
 n3yNcZTW
 qe/bSX0qHTsWa0dmwp3CcnZ5TlF+XZuEEq//Zem7/fwg2CmbjMwc2qJiuZmUAQ+tN1vc+B5BrM0b91Q8OXQUdv6NmcTnL1h0S0SsVqDXqkbOt8qIB+jdQO20vwt3LN0GBKGLGiQro5DOv1NOQtkAYzLNkXAICQODCd7eWwWCdINr1xyF/RHapXd2fzu6waR7N5TpMS5HILOjmNTdtXbw6vCgfoY/pz+u0G+vbNLSkznfIiXjgiblIYqfecTJEbZeuFhh+nYJVwZo2qAivv4tpenBFW2yMYeQRdcRwOwnVXPf9I16KavFnF06xuAmomVywbRFjllZFC737zOYLHzUt3KjgrlX+UcowZkx1PwbXcHienveOmFcX5r3hwLI1ISgPK04EiN7L+62szQG/o8/yk99SFWfz6WzjznPB1KDwAJQ6wuHk84My3ozmpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 22:51:56 -0400, Rik van Riel wrote:
> +	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
> +		pte_t pte = ptep_get(ptep);
> +		struct page *page;
> +
> +		ret = follow_one_pte(vma, address, ptep, pte, flags, &page);
> +		if (!ret && page) {
> +			ret = follow_page_pte_commit(vma, address,
> +						     page_folio(page), page,
> +						     pte, flags,
> +						     pages ? pages + nr : NULL);
> +			if (!ret) {
> +				nr++;
> +				continue;
> +			}
> +		}
[...]
> +	pte_unmap_unlock(orig_ptep, ptl);

follow_page_pte_commit() ends in gup_fill_pages(), so the pages[] fill
and the flush_anon_page()/flush_dcache_page() pair for every page of
the walk now run under the PTE lock: up to PTRS_PER_PTE pages per
hold, 512 on x86-64 and 8192 on arm64 with 64K pages.  Before the
series that loop sat in __get_user_pages() after follow_page_mask()
had returned, with only the mmap lock held; 2/8 moved it under the
PTE lock for one page, and this patch extends it to the whole table.
5/8 moves the same work out of the pmd/pud lock, with the reasoning
in its changelog, so after the series the PTE path is the only one
flushing under a spinlock, and on arm, mips, parisc and sh both
flushes do real work.

You already mentioned on 3/8 moving the gup_fill_pages() call out of
the lock so the PUD path can share the helper; this makes it more
than a cleanup.  Storing pages[] under the lock is cheap; could the
flushes move after pte_unmap_unlock() and run over pages[0..nr), the
way follow_pmd_mask() and follow_pud_mask() do it after 5/8 and the
way __get_user_pages() did it before the series?  With pages == NULL
there is nothing to flush either way.

Yuan-Hao Hsu

