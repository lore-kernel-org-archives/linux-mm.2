Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D53AFED3C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61016B00A9; Fri, 24 Apr 2026 09:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37D56B00AD; Fri, 24 Apr 2026 09:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E9B6B00AE; Fri, 24 Apr 2026 09:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8168E6B00A9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:00:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38100A016E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:00:05 +0000 (UTC)
X-FDA: 84693457170.13.8BFC9CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id CDF00160016
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:00:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fFTV7/OR";
	spf=pass (imf08.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035603; a=rsa-sha256;
	cv=none;
	b=adE8E9uVSaphNMahYHpXbjZWNcIhkifI0PR5SzBmn34hO8fmYMjA9Oya6zt80FGrpfB2p7
	fWY9NurE0Kz3ySpbilDlFEBWQYJDSD7VDrMkE64hF6cYXk14zIm01/fWGFqzAIpXA1C3Qf
	ajqMmV3Xwh1MHMcZ1M2RmauZgm4a64o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fFTV7/OR";
	spf=pass (imf08.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuxHqotWAXKQn8tfukv8Lxf0MCnzWeGdcx1e3ImXNv4=;
	b=kA/tq/MTdykJnkzGLtpGiav56FhdX2tAEI9JRp+zwA/YyZHl4mHT64W8lWOf20zOG3wad2
	ZDqQjwgfwNXkfV6OrvcasTdQQlGpkQdJtITuIX+5YS813VEfhBWzyLPcgl+WIXWvGYL6EN
	c/qK1s5az1HqBIsuGU9vt3QuUSI3zhs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777035602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CuxHqotWAXKQn8tfukv8Lxf0MCnzWeGdcx1e3ImXNv4=;
	b=fFTV7/OR0y9acSovjvOioYx8UWjqexln4e+IcnaaPu2GDGFVpatcZaqVGWJLuAa00un+Cx
	s/Gp4c4b6QqFYLzrPwK2HfkpKfCejVleXCSJPLcN4HH5G8Te+51ncYV0A3egHdt4+ieoux
	6sh3LcfKAdW0P8g1GBtpS7sZMpAAXhY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-lVXRkto-Nji64SaMX-_eHA-1; Fri, 24 Apr 2026 09:00:00 -0400
X-MC-Unique: lVXRkto-Nji64SaMX-_eHA-1
X-Mimecast-MFC-AGG-ID: lVXRkto-Nji64SaMX-_eHA_1777035600
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8eb82634cbeso1005656485a.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777035600; x=1777640400;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CuxHqotWAXKQn8tfukv8Lxf0MCnzWeGdcx1e3ImXNv4=;
        b=BvTqgio+MZFSSab54HicNXJIqfQ1/e1W9uS71u51UNi23ukr2Ln25eSyHLAfKJRZ3l
         JGfaKpipm+A+40uqBb6llEPQHrKjwJk8IPewIybWW6Kmgj64RaEFjHIgCfLJBSpyEv75
         PUKeOI/+uyQhtQq0/wFbd9tiTb5ggeUgzVN4oQJU8wqYAAR2j+rnMjn2p/kcfCMXEszV
         XCu1N0YhyKAzle0Y0jdDsj1CHJ2Xp5Josn0sWmJTiZZ4dOozAF5Ck0+aPr3A3LXpTzkC
         2FQVGq4bQsV0NZaWOcAxoRZSJ1mCOO91TBCb537+LI2gC2wYQOd46HBLerN2AZ2y+pax
         JAmg==
X-Forwarded-Encrypted: i=1; AFNElJ8YzHgzj0XeTOG72inSR3SQybm25swilttei5P2im0HtIhwXmaCEPhdPvwObczhBf8DawkYpha2YQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9U6zF+05ogYA3xavzLBuktKZFj3XTi2mGW2H88PYEVB+P2580
	Duk+2lUHlQBiTfCG5NA6PnkDnNyAJASrJkGSojk+p2CbkTBkIZDM67yj/1d2K9nJlV3MUUiLqR9
	PFragTA2vnraxnuT1KG1N3sgpLEIhO2NLMSvqIBuOFcr8LXRM7THZ
X-Gm-Gg: AeBDietItqb2W7IDA7MuOlDK/nsFDtmtSSRyFQ37iT9tY1zD7NTfFLNCysaF8IN+pKV
	vM8myrT01nmIGdnzKxNDhpf32ozKIdFD3Ps7aMziKVbhbky2aEsFYohybyiUIGzkKjs2atrz0nq
	1SwSUZXpLvRnKxMipIQ+6+1ZvKiFD9xQoBKO2EbDMDquUMxKkpTdsTMyWEXvXYFo9QX+0HDK/Jq
	NXGmBxpi58embWv9mT3nl9HjkKjRqgVCxRzb5tRJA8Kgl2pqGXHOdpcjwadR1h11GvSp5Ov6QaK
	4+0ulmVcphPcYFvF00fJUm/wU0vNSNNDF70Qt/RImC0aRiwUuQuqW69kcCSoea+uKRxcrUi3aXs
	so4WnZqZhn1BQtaQn+JuZj4JN/ITBt0a3f4TaVwis63CP9uH2YK9WlRzzFw==
X-Received: by 2002:a05:620a:40cb:b0:8ef:47ae:94de with SMTP id af79cd13be357-8ef47ae9518mr2002363885a.39.1777035600000;
        Fri, 24 Apr 2026 06:00:00 -0700 (PDT)
X-Received: by 2002:a05:620a:40cb:b0:8ef:47ae:94de with SMTP id af79cd13be357-8ef47ae9518mr2002358885a.39.1777035599426;
        Fri, 24 Apr 2026 05:59:59 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb3aa60b99sm1676032585a.42.2026.04.24.05.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 05:59:58 -0700 (PDT)
Date: Fri, 24 Apr 2026 08:59:57 -0400
From: Peter Xu <peterx@redhat.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aetpTUc9ojwF6Is7@x1.local>
References: <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <17b0dc02-eee3-46d6-9afb-5f81a3a20216@kernel.org>
 <aep8tsYFfr_Xe54q@x1.local>
 <aetHWMZyEEIEzsJZ@thinkstation>
MIME-Version: 1.0
In-Reply-To: <aetHWMZyEEIEzsJZ@thinkstation>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Fgu_mZmwc87-TUMqsTeVlWvGB-fnYqOU5rHYSLY15dQ_1777035600
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDF00160016
X-Stat-Signature: xuybo9ptsoot1a3gatentrmhpgrizt8w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777035602-837215
X-HE-Meta: U2FsdGVkX19S7o4qXNHB0VJeP/Udr3Ybzaeaa7pju2roUbfU9aQT3mFB7KPt46R50YTtT3PVcp8gOT9VSqlUN3M+p4xCCC/zrcKGBnbDbYB+9f5ucHiACbHEp44gv0HO6qh7Fjn7YAmQRx777AUsEXjudW5Ao1HDC3eDXfL6VblXawnLNDsfIkRtArHENITmU+yr7NpJhU1kKJV6jBqK3FcR/Ds6QKTf6O0IlsOQGQJpamAI7bn+i+nNDRWTYR3RWDX4727OgElZEy737LRGnh7EUltWUcthwfZsb2nOkE9htKc2bd3vdIegXPRm43k8IkcAUh5qe01hmXn/IOvsZgzMepjoOK5z75zqg4GsASe7+ZHyJ/njFvboThMGw4GiVpe0foM3n6V4ZguRyr2Eq8V9tfiqBN4AsT/tj3RcmWzP4pI8AHGkOLersJMb8W84fRrpE6Np+zEonfyfZHzisKWj+QlkNHO9cYN6nhKNrz87AQP5AQy6n27+0/MdJyPNmKpWcVbZI2Y5KQi+KCIe4DRfQSxIhk5m8Svi7z7f2NXgsutalsrLf4aNOpPRgpk/MX1nCAuKbN4FpmbWF5qKPIkzlhx9l9UmFbKKzXlr7qzraLSscCs/CviIGRrDI4htuD2S/nyMUndmwpr2s2Abz1IwYbkjzxWeWW7PkKwTNa8HPoaEWNd8jp8npzb5xA1YegDP6hShEwQgYZ4K2cq4DTykgXuQEqU8G+sD7K4WtP+cqslwaFgNgPq8a7fHkRupVf94jZhVSgCuM6xvorKkQKoc8FVVaSOsXkFOqOq8hJ63H4fGR3j5fvMWIQWe8T8tFJR6yfAnUW0hnN1KCWkKthboSWKWrpfZU95dKjiQmY869Bd0258VCYJ8k9EFcdWSfd3Bs5x1zd0MHD0lOwG170mH9losIB+oDXqRygpX3yFbsn6qh+e9RILDa3YHK+AXdEkLVzVzMNw5S0OynJ1
 K585Khmr
 Zj/3RFDQBouXdkQw1LHwfD9BOG4CnU2vSrGGbKyBcOK3EHEYPlBRULqQI4Gn2MxDFa1e2q8CNSIDpQhTsmso+gf2mpheI52WqZ+uT1HL1zqbEMBwtiyXVDCGIegh0cWFo0aCRENDl2W93ko7IeYJRPqDfz+i1VfYjEKcTmMHb0PlYi8HPGaRwHdJMNFF1Dt/EX7hRaZCDh0wDdr3ezjjqOjZmd6+8leIAiL8Zg3ERofveNKLY4PnXC0QZL56RbJ44o4wQ8GITLU+00tHEeAOPIgFFmyFxxaWFk15BCeHPdxSfoAmSojJyU00FOytDx6cCn4SAoSZO0DDcb9Na1r3+guZUzaPquee/B0L1ZwrwrNUnh6La/OEaXahIleEtrPyvNj7q9zBFEWwkNCP5HsPrU3q5kr7DjAGWLMGheuMfQs6ODEot1X4KMx9jaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:37:35PM +0100, Kiryl Shutsemau wrote:
> On Thu, Apr 23, 2026 at 04:10:30PM -0400, Peter Xu wrote:
> > On Thu, Apr 23, 2026 at 09:25:30PM +0200, David Hildenbrand (Arm) wrote:
> > > > 
> > > > The other thing is, as I mentioned in the other email, I still don't know
> > > > how the current RW protection would work for anonymous.  I don't yet think
> > > > the user swapper can read the anon page with RW-protected pgtables.  So far
> > > > my understanding is maybe you only care about shmem so it's fine, but it'll
> > > > always be great to confirm with you.
> 
> 
> That's true. We use vhost and therefore shmem in our setup.

I see, thanks for confirming.

Side note: I believe host works for anon too since GUP works for anon, but
it doesn't matter as long as we know anon isn't a must.

> 
> One idea I had about how to make atomic eviction for anon is extending
> process_vm_read() and process_madvise():
> 
> - Add a flag to process_vm_read() to bypass the protnone check on
>   accessible (or only RWP?) VMAs.
> 
> - Allow process_madvise(MADV_DONTNEED) when the caller already has
>   ptrace write access to the target.
> 
> The standing objection to remote DONTNEED has been "destructive", but
> process_vm_writev() already lets a ptrace-capable caller overwrite
> arbitrary anon with attacker-chosen content. DONTNEED is strictly
> weaker — it zeroes, it does not inject — so the trust model is already
> established.
> 
> > > I wonder if uffdio_move could be used for a swapper implementation instead?
> 
> I considered it. UFFDIO_MOVE can in principle relocate the cold folio
> into a staging VMA inside the VMM, which then reads it and drops it.
> The downside is the VMM has to maintain a second address range and
> serialise eviction through it. A purpose-built primitive — something
> like UFFDIO_EVICT that zaps the PTE and returns the folio contents
> (optionally to an fd for io_uring) — seems cleaner.

Right, the other thing is unnecessary overhead on the extra pgtable
operations when moving to the staging VMA (e.g. tlb flush).

> 
> 
> > If RW is justified to be useful first, maybe.
> > 
> > I had a gut feeling Kirill's use case doesn't use anon at all, then if
> > nobody needs it we can still decide to not support anon.
> > 
> > > 
> > > If we ever have to read from a protnone page, maybe we could teach ptrace access
> > > to do it, or have something that can read from prot_none areas -- like
> > > uffdio_copy, which can write to prot-none areas.
> > 
> > Somethinig like swap_access() in my proposal can also partly achieve that.
> > 
> > https://lore.kernel.org/all/aYuad2k75iD9bnBE@x1.local/
> 
> A maccess()-style primitive that reads through PROT_NONE is a reasonable
> building block and overlaps with part of what UFFDIO_EVICT would need.
> 
> > There, it was only about reading from swap so far, though.  But that one
> > might be easier to be extended to read PROT_NONE and directly put data into
> > buffer user specified (ps: in my local tree impl I named it maccess() to
> > pair with mincore(), but it doesn't really matter; it doesn't even need to
> > be a syscall..).
> > 
> > To me, the interfacing is not a major issue.  The major question I have is
> > why RW protection can help in swap system impl when we already have uffd-wp.
> > 
> > So I want to make sure the use case can't be implemented by uffd-wp already.
> > Because that's really what we might do for QEMU.
> 
> Race-free eviction can definitely be implemented with uffd-wp already.
> But not proper working set discovery.

Good.  Then we can focus the discussion on hotness tracking with RWP and
its benefits, and compare it with a pure access bit focused tracking system
(as I mentioned in the other reply).

Thanks,

-- 
Peter Xu


