Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1E9C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6436B00A7; Wed,  6 Aug 2025 12:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957C96B00A8; Wed,  6 Aug 2025 12:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CE76B00A9; Wed,  6 Aug 2025 12:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1016B00A7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:56:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 302B5160557
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:56:12 +0000 (UTC)
X-FDA: 83746935384.11.5FBA7D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02DC716000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:56:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDJHqOQC;
	spf=pass (imf08.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754499370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caRxOupOwvLDE4AxnGKjW2rkeHCX/7D6A5vP6Lpr8sU=;
	b=PcR8+JAEKJc8d9qt5PyuqI4LPgiSeCuN/LE+Q2WHCLdGrnQyOgOCKj6qE/tlRvrx51g6ef
	GxL/2v/vxN2g9dxa5/3m9uG2uSuOGJTg/+qq1vtBV8O6nPgHECjBzVfchdmxTBV/dIvoce
	Sb+8ECXagvPFATzFuhCkyy1zSdbuwJc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDJHqOQC;
	spf=pass (imf08.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754499370; a=rsa-sha256;
	cv=none;
	b=n309El6qqWrUG6csrctHbYMSKBVWtD8gNSi59T1oyLjacA8V8utASoEMhHWEKfgLxmd6a+
	GxkG5atqGvAL55oy/IiTZGDZTgdbyHKhrYSB6QHk0Ex1IMYsqOE4tyf9xD1UcENBaTYY1/
	4wVPjsdQ1QcHfOdijCzSDaFR+aPCK+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754499369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=caRxOupOwvLDE4AxnGKjW2rkeHCX/7D6A5vP6Lpr8sU=;
	b=jDJHqOQCmg/7dsVikCkHwB8nlPG5jR+4pTIH0uYVTSgmcsR/mdZ7vOUNE9xJj0ZwbiiGYe
	cKlAP/cnTEgcXOfYwYFU6LoGyRj2NETEGU2qKOfX5o40VVWVv0A1wkT9F/ACgbCftTwQoU
	1RqU5z8S7mBthNcAwJT4679OaTSQHyc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-70JQ_dYhNYq6yyJg0rezcA-1; Wed, 06 Aug 2025 12:56:07 -0400
X-MC-Unique: 70JQ_dYhNYq6yyJg0rezcA-1
X-Mimecast-MFC-AGG-ID: 70JQ_dYhNYq6yyJg0rezcA_1754499367
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-71b6c56ca46so645267b3.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754499367; x=1755104167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=caRxOupOwvLDE4AxnGKjW2rkeHCX/7D6A5vP6Lpr8sU=;
        b=GaOY/50axnfxYK6k9a0On23hH5aPT/Nm/dH77RU1yOutRCv+/Ep7wmiiukvivs3lWP
         343Kal1oG1igRHSuomnRt4E1KBlLXvS4qHsGafxLB6tbXU2xfVQhuhJPP4kRAKxWtxNa
         TcxDifkbPNXrBfmfwO+16L5AId4SJFROWuiqT3ghyYP3a1CF/B7dlK5OD+q2iOrYWbpL
         i0Rj0s/XWgysI3TzUIQrk5sF9fCf2X/WrXhQy5DHX6xYejJSC2IoVcFuqQT6pUeJbkkM
         FGgensPteAwKjbCHEgPta1NGtDo/SLE5TIpKM7Gd4R70MTiz4R2HE77FSTawvAqMjyPv
         oa0A==
X-Forwarded-Encrypted: i=1; AJvYcCUPNttVlwVJ4tdftKU3al8GU4yvytlrT+hJFrltjhjkJan2oIihoaDeWT0L1hKjJqV+gHdS1ks8pQ==@kvack.org
X-Gm-Message-State: AOJu0YyL3TQ872wwyMWEFBWjWibYI4BNl3Cc9evMtlnnPsQt2sr28IVw
	gPJPHoLoZiZsOsc+WaNHN72qCoMowKLOFfvu3EYBzcgDjzSVfsgdjmzuz36XseStxgyyWpMPCF6
	LeVDevMegFGjhcQnp33b+CkFEl3kSAteqAv6B1X5rhd1E3Iz9IxSMyhMsykIk
X-Gm-Gg: ASbGncu54BsM3aEo+FWrGHna1GC54p3Hg8+HpSzd9NiWycAZwdK8moqqSB2llklbroS
	xSR/GW3j56HSR7vvHg3OZOQ2V3LdMOJBa3qxVEaN+c5ILz+ZXhZ5Ph3+tlzgXisKC8upQxyI2Sw
	YfZLbnv8xjWyh9YoF+XH2an+sdsDSS71+dR45VF8YsGZb8v8w992jy5WLEukMfyJaS3RDM206Nx
	yK5kIwmuNDzXZqTUKq8yH7mV9G6WmYfKaJ3puYOZC6tTZ2p1HFHy9uuHkXlN5DA4VCYg7lrapDF
	fbgKrulyttao3izDlbt7nsTJnxS8loa8/rXpp1OiiRsvj4CBZXXNLD/b5Q5Nlp4dII5/orW0T3G
	1gNbjIrHrbuHclvYnSgdUoQ==
X-Received: by 2002:a05:690c:3588:b0:71b:6ad2:d10d with SMTP id 00721157ae682-71bc9710de2mr45651877b3.11.1754499366757;
        Wed, 06 Aug 2025 09:56:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQh+vw6wvMh/Vx0bRJhyUZIPHP4wgxRJuDS2ljLQE7fUIxuqSyVdyg6fKn8o5oDzXI3s/eew==
X-Received: by 2002:a05:690c:3588:b0:71b:6ad2:d10d with SMTP id 00721157ae682-71bc9710de2mr45651537b3.11.1754499366296;
        Wed, 06 Aug 2025 09:56:06 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ba7634498sm18397677b3.58.2025.08.06.09.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 09:56:05 -0700 (PDT)
Date: Wed, 6 Aug 2025 12:56:03 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, aarcange@redhat.com,
	lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] userfaultfd: fix a crash in UFFDIO_MOVE with some
 non-present PMDs
Message-ID: <aJOJI-YZ0TTxEzV9@x1.local>
References: <20250806154015.769024-1-surenb@google.com>
MIME-Version: 1.0
In-Reply-To: <20250806154015.769024-1-surenb@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jm_7oiwoyNeNdmi_NAj8_OK4EUDag9ghEPUkPP6s1Dg_1754499367
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: 18bm7gzeifssfqerccpsuh3jh13wmcpf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02DC716000C
X-Rspam-User: 
X-HE-Tag: 1754499369-943783
X-HE-Meta: U2FsdGVkX182/7YvyQ7wx2gCQ1GrQG33303HoHKpkuDctoCDvLojnvGhUIvBSk/99jqpgo2YmhDXjaTNXwZu9i/e4eEhymqZf1qFzj3PWRPXW5fdIKHEnf8CRWryPijYcJ/gcoWfTaigEk/DgpKcHIuXiQnTdDjAN070PGq3Z6mK2KJOR2U2ePORxDlPBbom3CxepB6MyzgsPtflhvCRh5lBUSW8x0PzaQ3GLNVH/EUfzc60bZFHZj3qxx6IgafuHyEg06EDej/nBLPASoL3SsqD/HgFJU1WRmIDhUogUcQmO32XZPnoHUGqK1DDHuT0kIUpBuhM19weaDWcrEM3/WvK3XCAtJP6BM/Oxzqx5bF9/dCRxicqunLrSUUFKvCPYqEqPgR1ZeUU7z3AMyrL8u3CSK3TSkYCuSuwipfBvW0fWtYQuCwBs+zy89OT0TqgqWvpepw0Bsjwq3uvfHrcHTd1Wl48XT4Vf0SYTcwitOxXqLJXfRcLQ1hsGXcARDQLqIKWcBK3QTHVvO5ZPz7JCMn0Fnw2WExXFhYKqiFjiyvnhmF5pjPxLJa4C+ebMh3nOMSNNlwooIutjQBfKe2bp9pqOKfuXXMGnYfU4IA93fFWjGa7MVAydR+53vVNY0Swagm0oxsN7EHFoesHePTiTch5mKzLidIey3hNUoBiLwuMXpRoZ8Uoh45ji0I/HphV2CQsr0plAtNbMAxKHxtC6tHeZ/xaB+mEFi+h5zaoqJjq/n0wGeq7ob8dCji4PG5sWQUdjkT2GJBY4yZTdG0XUS+kEyMFzxHsoq73mohP3xLMhwgtN0+jQ2Ue0o/nlHyhwMX2Pkmbnm5WZom2wbZkyBEmfc2Ny4IFKIO/SCQDu1QY1sX9UybReq9UozOU9cTezUZQED6cmlUsKGHKdcLHLL24rLOMmyXXknvhJiDE1C0tJveaoinQnzro9BrCBi4tTgMTpEfFwVIVPrarjt2
 UouJoxBe
 rx9lyeVEEuKFf6Xf14qajqs/pnUV68A+GDMFI+mfWF8MxcpoPREymiIx1kRguRQhoZVF5clqu2/5tqkcEAZxphYcndh1i2k5WY+pQ1gjz+5xvSjMPOAsvKIH+yQyu0a0BGh/m4RkO1+UpxkNtMRe7XZ7KPQfroOsJ1I90FeskpZSppi2SAYx/64xMlTd0jSNp4KMA0rtJEzI78ABl1yH6kCPpTNNLSfQC5F/1ipY5QQnrJkPcsfm4LIpTfIJExbR15BCOneSNBvO8yrKr6nDLzABp1ZEAwf7AaGAWHHkQ8UxGFvanrTt2Eojz4AvpBC7PpWexVoK33NxUvNnn9NeVAtUhUXLAoug49ShYu7MKgDJBDD/CC5stpkSfkmbecbFodG6g/hp3PkLjibLlB0NmhuYn8OtTz3kX5xnJZLDFiDMeiNx0+pcfzUwazrLTMeB+Yr8KH6sI6O+7cywnvbY6lG2Vvz0t43GyeWgJKlW5bThyy0KH3JI/EQAnwP9OL97nC1dhdsh310fqVjrS/sAmckaf6Ma5rVStIANIZbrTEjxM1jQ0qz+f4mexG6WBCb6T4NdwWscn0nqTrlAPzzF1hnxhHthKsFkusOWsSY27lkiLT/zgG928Q1gAWFQXTgalVuYk08hGtorm7l//C3L4VzGtH99WO7CjnTQRbrOjdnwQs9Vus3pJqmBXRDKFyE24xm1X/1FvcziYIAZOqKoe3INGxYqhedTz+eBUDlp+gLo2SL/46TbMVncPVf9WbFEq2trEs4E/6XeVVfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 08:40:15AM -0700, Suren Baghdasaryan wrote:
> When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it

The migration entry can appear with/without ALLOW_SRC_HOLES, right?  Maybe
drop this line?

If we need another repost, the subject can further be tailored to mention
migration entry too rather than non-present.  IMHO that's clearer on
explaining the issue this patch is fixing (e.g. a valid transhuge THP can
also have present bit cleared).

> encounters a non-present PMD (migration entry), it proceeds with folio
> access even though the folio is not present. Add the missing check and

IMHO "... even though folio is not present" is pretty vague.  Maybe
"... even though it's a swap entry"?  Fundamentally it's because of the
different layouts of normal THP v.s. a swap entry, hence pmd_folio() should
not be used on top of swap entries.

> let split_huge_pmd() handle migration entries.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org
> ---
> Changes since v2 [1]
> - Updated the title and changelog, per David Hildenbrand
> - Removed extra checks for non-present not-migration PMD entries,
> per Peter Xu
> 
> [1] https://lore.kernel.org/all/20250731154442.319568-1-surenb@google.com/
> 
>  mm/userfaultfd.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 5431c9dd7fd7..116481606be8 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  			/* Check if we can move the pmd without splitting it. */
>  			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
>  			    !pmd_none(dst_pmdval)) {
> -				struct folio *folio = pmd_folio(*src_pmd);
> -
> -				if (!folio || (!is_huge_zero_folio(folio) &&
> -					       !PageAnonExclusive(&folio->page))) {
> -					spin_unlock(ptl);
> -					err = -EBUSY;
> -					break;
> +				/* Can be a migration entry */
> +				if (pmd_present(*src_pmd)) {
> +					struct folio *folio = pmd_folio(*src_pmd);
> +
> +					if (!folio || (!is_huge_zero_folio(folio) &&
> +						       !PageAnonExclusive(&folio->page))) {
> +						spin_unlock(ptl);
> +						err = -EBUSY;
> +						break;
> +					}
>  				}

The change itself looks all correct, thanks.  If you agree with above
commit message / subject updates, feel free to take this after some
amendment of the commit message:

Reviewed-by: Peter Xu <peterx@redhat.com>

>  
>  				spin_unlock(ptl);
> 
> base-commit: 8e7e0c6d09502e44aa7a8fce0821e042a6ec03d1
> -- 
> 2.50.1.565.gc32cd1483b-goog
> 

-- 
Peter Xu


