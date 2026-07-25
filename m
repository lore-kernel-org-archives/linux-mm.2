Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979B4C531F9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 06:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3B66B007B; Sat, 25 Jul 2026 02:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E6B6B0088; Sat, 25 Jul 2026 02:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF386B008A; Sat, 25 Jul 2026 02:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFE66B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:00:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8BDB160224
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:00:34 +0000 (UTC)
X-FDA: 85026249588.25.A2C7E54
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C9354000E
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:00:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SAD9I/Er";
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784959232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3R7h5JyaA1uugKbFEP5vKOJzew2Snk1DHEX+ZA2OVLg=;
	b=Vn/cBb3+8/JqP6IvNRrcn6KZ2ks5zpv2AgdPoY2B1VphD3dnjh3M8OHuzijkbVLBclRlJI
	E+jq4Znur1M2lZvbLXwA4HkvLm/epSYMeAXhJyrpLvyC7p0FkPHP4MmKZezbkLHQaUBUvg
	SiN03IVD9e2pRwoEw8npSjR4NnudpWA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784959232;
	b=ETrOXxEsdWuqYd04D/oBTwf7POQLjRDRGUUxTO+ek5p85YLci7YQLVjfL81jF1D2teiVEx
	H+zK9yi8N5J6DY6txSQ0kKOjr/Rd6+VS2aix4D5y3MeG+Btq4Ma9QRohaZ9cNpN7wnNgAA
	KPPaNvS8TU90slThRKfsEKavVZSNoeA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SAD9I/Er";
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c15a5b265so138351cf.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:00:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784959232; cv=none;
        d=google.com; s=arc-20260327;
        b=RP85oZZL2AQzzzYD2IbbuqicT80VJzIyuAoOy5NnzQ0E6moR6/FlZqoPuz0bmnTHIi
         1Xe3ulU6BoxaD+ASw17eNLBBnSpQCPB7wFp/LsdxIj47kjOrhAsjnEV0g7bH1hlx1bfY
         K5jopa6DIFiRMd/wzp2oI3a7V55t/Z7Pu9h47Kq8EG0dhD0981QEbh8wWj/jcd9P6Wbx
         KrmHxiq/1wsdBnKY+24l11owieLRAdVzRq0jvoZy+0cxQc/DZO84ThVPlbrSvMG10BLu
         511tzPllsVWoB9nAUU22B4UWOxMKeIV6PwC0bsAU1d2WNDugwphz1u8ZJhpM7mi7kfcK
         EwZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3R7h5JyaA1uugKbFEP5vKOJzew2Snk1DHEX+ZA2OVLg=;
        fh=xDf7CMKJhsAfiMVuVzgGgvrHsgOBTCVP2CjHn/eq8YU=;
        b=mjnSpKwk7pKQgei7AIw8njmmpTtaC3BcZqxtgleNX4n7Bvtp10Vo2G38qiY6go+roo
         inVftj6I/S0KQ/N4zk4lFX8Zg8SAvRj6fM62mR9dMyu2QkvWztMqI+RlqJj4R69z4jCJ
         qwF3akGkB5sayD82kFQ3hNSa0t/2+sMQhw1mPAQBfXVJSBYDhAtTeiokeaXY0fnpoMAD
         hxbo3B7bYiIUXZ2UMqt3hWNi6S/PVpKwvvvYqJqZx2m1wxzSXN0CWVzqapRyLoTUWzmQ
         JzF92TIImKjBU1fb5qCjyy1DkwMPOEPn+XZIvdqogGdZTwmSkyiOd9rcFWQI6CBeCAKf
         ZjBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784959232; x=1785564032; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3R7h5JyaA1uugKbFEP5vKOJzew2Snk1DHEX+ZA2OVLg=;
        b=SAD9I/ErMgZLNzCYmh+NMXrs1Sr2pyuOcfjWoXe28GP2I97nZBH1DL46jBv41H7Q5f
         f2AAc7s59gahOkCROqiEVrMji8yuU+t09UX34JQkOQRgw7bOMIzyOx7G6wnqURaOPoLl
         xzRicgn/OmvPBwhHTsNsr2Oht453xz0q6J8BvLpRM+WbWSONkDg5tt5hl7mv3WLY3+Su
         zFJiq7yvbrXTd7Xmr9zdru8G7n5TfcU3TnuC/TMclzeD8utecTllo75EnXzAUXN2Djts
         3zggDtLEpyUGNYV4EMV4K0IjPGHwiWDzUbnB8avuNYv52/a2b2BdBGtM7KPXp0eamzNG
         iTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784959232; x=1785564032;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3R7h5JyaA1uugKbFEP5vKOJzew2Snk1DHEX+ZA2OVLg=;
        b=HzA+F4+lBJ5yNVlmxqokg8A7tD7SeuCSdJv1XXAY9AsjOFQOwEsTCe1LyS+1AmRoVc
         bZTl4NXEw7BtegWgjsFZRunAf9Sfh8qOikks+V46IRZe+kURIc0x9TNr7fqqN2USaGuZ
         VJaU9D7zLF8pkYRMmj/1H1c1RRUAnfJrtG+bgKURNbg2ZJ7xjICkFdSYWv9ktMx2Tra8
         hII3eYdzh9/rH3XxmmSruTv/vbR89vHMTJAoEmHsH6mK1OYJ3Ua7jxSmpgAmHhhJSKeU
         buOkMfp+dUdhHbO/CZWrhsHKQlqXOk1CGuP0T2h10O8K0OgWmS/Vtaz41XTKParX9QLh
         J/vQ==
X-Forwarded-Encrypted: i=1; AHgh+RomrAB4SKDsx8a3W0MEhDop6DcB9OJ/QK0O2lp6iX4NmtfMnhX83VzNxG5s4OrZqRRKgxiFyMw9wg==@kvack.org
X-Gm-Message-State: AOJu0YzXEaqxcip19+XpyO5NZ97ELVXEO+eooOo1xsdmaXqjsxALZEOu
	seC6F66EJUZZc/eA5M0wPxh9b71NOAYfxPyEwYKd1Mh6+XHdVnDc8g5yryRL5vGyO1t1hp4ozK1
	V8a1OC6PZetVEBtbbcx6oORg6mTM+ftkIJGcHhwkg
X-Gm-Gg: AR+sD13HR9sBisfsvWr7h0DPFK4zbUBFG+EpCRYo/ZVyeg5Gvk6KHUe/mYrJBdqYBNc
	OCnY5wQ8eSwNHqItf1N7euGrJmgBy2CN4Z0fzacwCAghisNvkN0HdIhu36uWpk1kOgi0OqGbLbE
	dCwEtc3W7XNM41UFDquQUhp/mCA3QyeB4iEIDbVnhPV9i+QS9SZx3EqBpVWSnRDm7tVNcmYcDti
	AmpjeWaYXhMgK+AQtpT1Eg8MrrbGHOFPzj9ruoha62e4iw1eFEGdd93V9a6OmRPqJNc+E9rXsAu
	qn3M6OFl3GmZOEP4Bcs=
X-Received: by 2002:a05:622a:5883:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-529a76e85ccmr7638951cf.13.1784959231123; Fri, 24 Jul 2026
 23:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com> <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
 <b28c7d2f-2e4e-4760-9789-7b44f4f1c936@kernel.org>
In-Reply-To: <b28c7d2f-2e4e-4760-9789-7b44f4f1c936@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 24 Jul 2026 23:00:17 -0700
X-Gm-Features: AUfX_mzew7QEd8aV1kkXtZwt8qALtul4QNTzrsozJR6zQsLvS9lY3yHZWYhmt74
Message-ID: <CACw3F50nVECJ+k4g=QVZ80yzi_awCOcUiCuB0CYcUfxND9-7Tw@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: William Roche <william.roche@oracle.com>, "David Hildenbrand (Arm)" <david@kernel.org>, linmiaohe@huawei.com, 
	ljs@kernel.org, ziy@nvidia.com, osalvador@kernel.org, harry.yoo@oracle.com, 
	willy@infradead.org, osalvador@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C9354000E
X-Stat-Signature: go7othani64pi9asimq8gscpnrrfkmzj
X-Rspam-User: 
X-HE-Tag: 1784959232-596426
X-HE-Meta: U2FsdGVkX19IfDRrJRf2NwEf16fZE/jCBZKmDn9jKbrjEJ0VqWdCwl0+zq119RMWAhIA81lX6Ssz/iXIw34cMWpc9+RAjH6aJ13d7p5OhhSCkzogZKfHEjA96cmzB1ZKTLi9+K7yeift4nOuNPOxS/blsknySocNYLfz6kGqk0DjImjhYM+8j3BzNjr8s+3s3cpgGqsGJUB8UuLT1Q0H1nRo/m3p4yUDb+mNSFRcKYo+JH8/lvD15KjYhoCooj/HguXV48YYCERnKPcHOs9YmO7T20p0csW5h2ENKJ7aGjAWT/oq/XsrjK6gfBRKasuKV7aR01md/7EDvdDtAsK3y6gP/OrykVTXZXTqN98UJ31p/m3nXSRPwb+ZZwv85YNphWk2E29978GORyR5wT6AyVvcD8uzsrQtyuYlsv6vCyY8Ce57w/OBgnsjDGKXYuzhyCkzWwFiRQMu/Q8JyX7yFj7Gznp4WaI/rEnaGalyg9TGMFTm95g7/VC9lyxHa5sUQgH9NWlfS5+9evNI0ofxS1fErCM5KWE7yJLaHkB49BAeGJxAummqxBwCFFYLQuYP9HdZMVtPn1BwmwEE7102D7L3vxPfWPqYKTUfy0XiTRdatzfQGTunPTL876wPOTF8KA6ov0Y2XHtPymT+3fv1fox28qzxPMTnsBug+NKkDdspKD4cwtwMR1E031HtXcFHJFJZ+ixFSPcvIu5awRaynFTWUh3trSyGB5mdT8XBM3THvdOnsiiz78vflEWNXa+LXEesEUvnSmCUDABtF/jVn95iFecuWaKWhPF16RC2uQRWezT6ByvREa2/czS2DgIM+143ApoVVDtde/Z50OWojW+QIRjpD9LSAnuRj6TwS71G8ExLKuFtgmLiRBvjxjemT2NDPkoIHhsEGx5F5j+WyZPAvbkGFZRDZvYyJh8bk4YbWCf49LLwk2lAMxF+ahh/JVsW3CU8E50EKP/RxDq
 9sY7LvH6
 eiCMVqROKH3duJAT57g2BHe4Mwn7g3ojcmTeSJVDUEG3mi+SmkI1SSPEqDuufmfUMCIbRJR/oGJZ6swJxpZt4bKOzjtaOUmROv/p0loj84wIk1P4b0aMwE3EJhkeG8yS5p/CQ6VNXnyzZOK8S+N2CR8MByEp5QAchwT/HZbfIBy9r9/+lsNTRdHKYwKuCjfD/NMYrK0qom/T7Rh/3acpOr28ROcbwyF+Avj3yMlMIei3PDRsg8zeaRVfYKiUp8ouMydsm+2oniCzzoAB+2eguhxIpCyarKsaNjH9MzGF7qMaDHpQ6r7K9JD8lrtNzcfRimQFscNJx30w1QgTjtG08HLeQxxRLZ7Dy1UJWo4ttGg2KP+HdYL6ZpQHSjieSyGX49Jyp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 2:03=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/22/26 10:27, Vlastimil Babka (SUSE) wrote:
> > On 7/17/26 15:06, William Roche wrote:
> >> On 7/17/26 12:18, David Hildenbrand (Arm) wrote:
> >>> On 7/5/26 20:07, Jiaqi Yan wrote:
> >>>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
> >>>> folio becomes non-HugeTLB and is released to buddy allocator
> >>>> as a high-order folio, e.g. a folio that contains 262144 pages
> >>>> if the folio was a 1G HugeTLB hugepage.
> >>>>
> >>>> This is problematic if the HugeTLB hugepage contained HWPoison
> >>>> subpages. In that case, since buddy allocator does not check
> >>>> HWPoison for non-zero-order folio, the raw HWPoison page can
> >>>> be given out with its buddy page and be re-used by either
> >>>> kernel or userspace.
> >>>
> >>> I still don't like the complexity of this, in particular, as we have =
different
> >>> mechanisms in the page allocator already to try handling this,
> >>>
> >>> We also do have cases where we set the hwpoison bit, while a page is =
just about
> >>> to get allocated from the buddy. So before we take it off the buddy, =
we might
> >>> just hand out the page.
> >>>
> >>> check_new_pages() seems to check for PageHWPoison() and make us not h=
and out
> >>> such pages. It's guarded by "check_pages" but it seems to do exactly =
what we are
> >>> looking for, now?
> >>
> >>
> >> Just adding a comment about this aspect:
> >> The check_new_pages() mechanism used by the __rmqueue functions should
> >> filter these pages out, but this has been disabled by default in 2023
> >> with:
> >> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> >> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >>
> >> So it would need to be enabled back, taking some of the performance hi=
t.
> >> (and I personally think that it has to be done)
> >
> > Would it truly fix the issue, or rather there would still be a race win=
dow
> > left where we check that there's no hwpoison flag in the re-enabled che=
ck,
> > and only then someone sets it?
> >
> > Also, can the hardware actually detect a problem with a page that nobod=
y
> > accesses? I guess if yes, it's only in some corner cases.
> >
> > So I'm wary about penalizing the allocator paths again. If the page is =
in
> > the buddy allocator, shouldn't it be isolated away as part of setting t=
he
> > hwpoison? I thought we already did that?
>
> Looking at the code, seems soft_offline_page() tries to take a refcount
> first and then sets the hwpoison flag, so it should be completely race-fr=
ee
> wrt the page allocator.
>
> memory_failure() seems to start with TestSetPageHWPoison() and only then
> tries to get the refcount. Wonder if it should be that way.

Miaohe may correct me, but I think this diff between
soft_offline_page() and memory_failure() is intended.

soft_offline_page() is handling a still valid but soon may become
corrupted page. Its main goal is to gracefully migrate the still
perfectly valid data to a new page. We can only set the HWPoison bit
after (taking a refcount and) finishing migration.

memory_failure() is handling already hw corrupted data in the page, so
the top priority is to stop anyone from accessing the page, hence
TestSetPageHWPoison() should take precedence. Both get_hwpoison_page()
and get_huge_page_for_hwpoison() could be heavy and slow; generally we
can't tolerant the window between getting the refcount and marking
page toxic. In the worst case if someone re-accessed the corrupted
page, the 2nd Machine Check Exception would be fatal (if nested) and
bring down the system.

>
> > So assuming we don't just leave
> > hwpoison pages in the buddy and this is only about some small race wind=
ow
> > where it's being taken away from the buddy? Then the extra check would =
only
> > make a small window smaller, but is it worth it?
> >
> >>    A note about the related project:
> >> This patch is an addition to the "mm: memfd/hugetlb: introduce
> >> memfd-based userspace MFR policy"
> >> project -- recycling the impacted hugetlb pages.
> >>
> >> I do think that "memfd-based userspace MFR policy" is a valuable
> >> enhancement, and if the impacted large page can be more easily recycle=
d
> >> enabling check_new_pages() it's even better !
> >>
> >> HTH.
> >
>

