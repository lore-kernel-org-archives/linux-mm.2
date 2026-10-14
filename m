Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6700CC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9016B008C; Wed, 14 Oct 2026 15:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A126B0092; Wed, 14 Oct 2026 15:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0A16B0095; Wed, 14 Oct 2026 15:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 987B26B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:56:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EC21C0724
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:56:21 +0000 (UTC)
X-FDA: 85322288562.18.E2333A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F72A14000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:56:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+TzbS7T;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792007779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JW6T2NVrNiSYii9ZuXsvqcqsrQBmXx3CI/QXZh1Cb9c=;
	b=o8G5d49Nbshsl5ZejVXjVxN8+REpwkNs/sztSgGK9m1PExwkGz0qfuFrMhIAHmrsPpWFc3
	DpE2VEJk+ZDwrYFML3aEzvPzn5OyNimcRdG1ZO90HwxQoftvG5yE3qCqrJsJM++rvqgQf/
	s4dOpkC+ukniCTReiIODG0irRMBlqfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792007779;
	b=CkmCelHYfjMV4ZIBxeCAM/+vwoqlWGOASg4p1nWQtyJPFw/LVLwKhL8/BOikN2VvmYC79L
	RnONU70NSrrPWjjoGiv0aJcF1sDcBK9ra5827crqn5NdaGNK7eW9i2WgyoyqHARefdmeVo
	x9abHcC5u+2pP8VprsyPNyp8vTqD9PU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+TzbS7T;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6916643D6F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5421F000C5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792007778;
	bh=JW6T2NVrNiSYii9ZuXsvqcqsrQBmXx3CI/QXZh1Cb9c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j+TzbS7TpAFLQtfLh1lkHLvzP2ycFzBbTshh8XeQkiC0R1GGqa0kq70T3nMbVFMzz
	 oILQB6aIFUxczmdVLzPpj7turEsh1dfJMI0A3PgBTWCItPfWpYyQ9FeOv4H8Tj1nKF
	 qpPWqBmC3rG0WssOv0ncVsP8lIjSc8dSqQQ+45h9wEI2P+kCcrre0MsxEMbeD/CkmM
	 OnAFweOqTkmPylhDqjEE/AcaGeFGo/G3kzj20d9egHMLjDshpq5Wj27Yma4O1eaxWl
	 rr8EQuCuH747XSEGyO58H09Uz1Vut1iKzrVvi+DUKb0Zh6XzKavCGBD0HY/3HUBWpu
	 AAjADlI9hKP6g==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93ef1a2948dso308514985a.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:56:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz1NArOYSqdYAWcCoNXpTPCowrFthu/YnsVrvDwKC9gi7aK35G18iLC7skedPSuZCERtZXRR8GdXQ==@kvack.org
X-Gm-Message-State: AFq9FYKEV54dQGiJpXCQg4S2ekbGRdUq+L3A6nr96VGeX1o34sWB2431
	KSVorMqPl3e2g54OLoVEo8ByyMugxSDbfroO3uYY4PcTzSpab7V/ja5F1To5C+Nc+QhBNvewOjM
	FBi89wnRKihwWpm4eekcRpQCydvjU2f8=
X-Received: by 2002:a05:620a:6405:b0:93d:e031:5ad with SMTP id
 af79cd13be357-93ebd224911mr2634160785a.17.1792007777727; Wed, 14 Oct 2026
 12:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <20261014-folio_pte_scan_range-v2-1-00cf9bbaa364@kernel.org>
In-Reply-To: <20261014-folio_pte_scan_range-v2-1-00cf9bbaa364@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 15 Oct 2026 03:56:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xMhtUWwZ1qCRkY=WjxwKGBTD-CSdQcp5jxcLW0WcMvFQ@mail.gmail.com>
X-Gm-Features: AclHuK95frzik0jnDRCFT7tNgkatocH5THJ5EMTKIH-IiD6HCFI8xOfwA0yawbE
Message-ID: <CAGsJ_4xMhtUWwZ1qCRkY=WjxwKGBTD-CSdQcp5jxcLW0WcMvFQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: fix address wraparound when scanning large folio PTEs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ying Huang <huang.ying.caritas@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F72A14000A
X-Rspam-User: 
X-Stat-Signature: pnoqmh6jeh8thf1yjoqguaxq7ukox5j8
X-HE-Tag: 1792007779-172990
X-HE-Meta: U2FsdGVkX1/C5PauNabeqMhKFb9Lx9MU8TxHK05mhykSBgmO3Qz1+4Z0H9zIIZ+sFuVPPZ5698XJMMILJOF0ZLcu+Rzxy1PJTOU8rCbL3qpSLzZ5AVf/3K63oq1Gypsy7Q5Gs1mlZL/16e7mBLFAFIGpC5GmQxSDmRwaraXjgm0op3qX5j8xfrfIEdmNq6NlqHKOm3WcWucdOPUN6QG1WOx8EptL5r8rO270xVrYNUbt2fWHg2cPMXfEuTdX+zE06ZRB8jqYxBOoGdGx2JVXWAfi0wtgI/LYyC3ad39Ka+8SxDcW7LMTZCmrCN/Sz71a1BYx07RZ/swPzNanecnUZASiFylbhyF4ZhHkktRhdO0AGCW9bt4oh3gIXmQQmz+oSHntz73pRjYagw566WfAiCV6+3jkuX5/DqIvmV561hcIKG3srBU3mCOGqHcS1JS7TlFZv4ZNusfeChGMBXMgPSmt6ZkqnUrAnO2SlBuOHR4Fa2llD7jg+u17RwWRD6oQ1EDii42ZRrZ/5pkQVPs/W+1IUSlMR12S8E4C+EJyZDOTpDPibCnTwQKtv+BXFBkp4bkAfysxAKRf2UvUF0Jh13dPLx/Dd0EwipkkIft7phn/V96BMfCIAXamrGHoRGs3y4ovxErV4j6xZe0xmweJPLhMej1+OR/uu8vLWlpVRmt0vzuVxjgrtbpGk8sqHPT61MbGKhaOhuNjOcskzSW/CzBdpPZ3a67oeobHCy7LRNqRuXbHnVkH6b3v4FIBahzX1K9O5CFiomKtfG7FYGS7msTFgzo4UE+Nu8+ttENkLAaYjxUTUU6BN8OZkzrpuMTuAlIbX8xy/dVz1p6sniLZgtysrMQEk6LQuGHkKHMCpI9BtBUCCQQzuFI6gNWOXqRQYwRIgVEIw/9WrsJM6HnU6qfJQtZoq24+3oAGQpZ4CPGVQvXajDboEZkrXhAEbYnV+NsD7fyXTdfE5df91Z0
 Q4xtKEaB
 wlR0dUAqv+TtiOqy78+xZOon7kxKBeOB9mmnJ3rFLsykoAP0BQGhvh3M461MHwMjIJ8pG1kIvByJPGnJuPbbmWl2teAI6e2i2G3/mRtLBL6g8R94c23wlrBNSt7oaigOMsi2xcWmzz5vhrBX8Q9h4GenODD6O7+2sFZOFc8s97EpDUSVHZ0P3JYtMr0Mcz61ZgZri5MJIMK/7JFD8c9c3RN86Y7vEN2Rla7MdFqPIfMgiwgetFYUmk2o0Lpz/Lk1Fb49B2sRnWsvz8gAeHGfSLtqcgTOc1humTD0L9R3M/bjPLjHziioIhsu9MCWBpGIWKroI1wuOe3FIIJkXS9LXUvC5J7n03HOHdZ0r3WX2wK4x4YuIkRjgvDCX/NmqYFJRFp04blhBDEHZtFY5ipWAgDoDeP0Oo7F6zrcZI6FuyDC04JTbEwHGGjF5pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 2:34=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> numa_rebuild_large_mapping() and do_swap_page() can be tricked into
> generating an address wraparound, crashing the kernel. All that's require=
d
> is to map a tail page of a large folio close enough to the start/end of
> the address space to e.g., make
>
>         unsigned long addr_start =3D addr - (nr << PAGE_SHIFT);
>
> to wrap around.
>
> Let's fix it by providing a better helper, folio_scan_range(), that
> takes care of staying within VMA and page table boundaries while
> handling possible wraparounds.
>
> There are some nasty details, like not being able to use pmd_addr_end()
> in this context. Add some helpful comments for these cases.
>
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapca=
che")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Barry Song <baohua@kernel.org>

