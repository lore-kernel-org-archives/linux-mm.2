Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60CB606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 23:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=p1KF2bMq
Received: by kanga.kvack.org (Postfix)
	id 6C5516B0B2E; Wed, 25 Nov 2026 18:13:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676756B0B2F; Wed, 25 Nov 2026 18:13:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564A56B0B30; Wed, 25 Nov 2026 18:13:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDBC6B0B2E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:13:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADFE21A0129
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:13:49 +0000 (UTC)
X-FDA: 85475195778.20.C08D5C0
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id B504F180005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:13:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=p1KF2bMq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795648427;
	b=DrnlwatOCmFxAcGvkKWStV7Zx+4+od11CPn3LujZjAibIo8zPCx+WUIX+t9uNEgPmd5arR
	hTriM1353V1ilnuuJ/5GynK9363HP5KpvdN1KqZrIMBMYXAyGgyFLTBQvwJMOn+tec81gE
	QgkyXkup77/J6Xxwi569gXQF9ijQJuY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795648427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmbARk3XHehA8pJF1qNbcXvK1JM9BX8FvFU7vWFVqag=;
	b=fYHk7youpXxBv1TwBgzENdn78inxx5n/K1+lQz9yVOgtNnIhOxSdanwt9vGA5O7TRO9jRA
	4mU3MQf2YPsEJRjSr+hS5SY4nF3SBFj/aTHVeSacH47yhVrE9br+CWugtuLe/C6wJDVDWi
	CXd9QAmbSZC54E9xNpdtqZg2satBuvY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=p1KF2bMq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a018493d57so303445e9.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:13:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795648426; cv=none;
        d=google.com; s=arc-20260327;
        b=nxWWm7Shn6/lRhcwd+NlB5d573UBNj+PTWGt1qgy5aJ8SWISuy4VuWfdCAuiZTFD7h
         0Q9MnfbU/J5NDKygDBZxnLz9DRTqERM+vIY93i6y6W5HlyXRvy+38Y86r9W2jJjyF3r3
         beh49acOQKOKZLSEAJnSdccdDn2EJr5gCBoWgCAy210Rp+zrcElFZ5i3zVd3GiAk1jCf
         2btI2EKpMqP313hO4ANnroxiurgwXk28/wADt6YuXpD+t2sVCMdP8eu0xuUQagtU0pNL
         0tGoGTgAj0xAuOxocY3/9FYAVSUTVPhfyPnkzGKaL0XIW/WCbnYlRPPy0rq6btGb87pv
         dH3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bmbARk3XHehA8pJF1qNbcXvK1JM9BX8FvFU7vWFVqag=;
        fh=/ratrb9v9yCC5LvANxxwGwyu/TGmrx10hfym4/ldK08=;
        b=beBgUqH2r5ViCo8a6c7EXEySnaw45+qBBUTlbSI5EKI8bjKQ9XTfTLBoRKyGNbFide
         yNI3l0R9ktAE3GQzFc4uNuXwts+jlOn3titnzIVrA4GsiEeZ6cuiZuX9bvrnylLYGaWd
         mBY2Mw1QCn0Cw8zXNpdGaHRNv/o14m/FIg9ZJkJsoYSljRDXvx6TXRlCV43JksdOp8cT
         Mb9PYfe4nFYYQ924etsjn07BbziwdMmcguRRzSB6cqSvPow8zfpoeniaomGNf6Uk3o2S
         3mWZCYLn9V3qRs/lopZy8SpNzPKvI6ilZFoV9qASpIBZrAYBYSATF/59FpMAYNBIrKZk
         Ty1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795648426; x=1796253226; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bmbARk3XHehA8pJF1qNbcXvK1JM9BX8FvFU7vWFVqag=;
        b=p1KF2bMqZKHT1qZW8bhtSSGvkaXUwhuY2ts937MJkiROlt8PJsGamNBAhGmkie0mEh
         Vc7TILYJ+8InkKO+4leAQdheni5o5O75A6cK8FAdmkRNCpKHmjIBZaK/smdmx0zr9RVG
         WcX9ah8ceSQaILKWJprniiHUfag0S64ESBD14esSsMskOC6JkRvZmGSvB36daY0CRZm8
         3eJGE8LvRd5IvdZZauT6YocQRxVAY6HpCSCJwOJFBHhUgRxsNxe1GbalTnRZQ6Qqdd8W
         WFr30/FWjVi6MK5gSLiU4RDkSsNaTiSpDhies3zGSm9gqMxG8CIH6hbvwI9vSNoPd4YQ
         WEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795648426; x=1796253226;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bmbARk3XHehA8pJF1qNbcXvK1JM9BX8FvFU7vWFVqag=;
        b=sIaMdqJ1h3/sKVEMkNf1kSBdsQMryQz+R+sdeyeRfc4JJZWJjJqsQ4NWz73mnpCTCF
         R1IAO/7nWgvdb8V1ckYsXoMfrJ05Ajb3RIbugdfrBL3ad6gUFADF6Xymnx7RXq8zdhbE
         ojbYXOPFhs5uZhWAl3xONrqmmV6HMOaaa+Rc50B9NAWn/6YOQ4rEMjg5ovJCdsT4cGxN
         /LReAwDnELmpVZ5hnYvR8Zp1ap79HzpHQGiQrLtY0EcxXfzxQGFI6feeiKDxVk1Ou3u+
         quPBaZO2/QrSZAFJzF3tcNAlcRJCIOQJq9Q5sBqZq3CUBL7quCpK4XCt8ZLDDBNalVyF
         0faQ==
X-Forwarded-Encrypted: i=1; AL+hErH/ZIiglCN//abEE7OPAKJWgDyHo4tgl6HBNwTkmhzbvZ0HKY4a2LqqB6SYDseNippQShrdLYYleQ==@kvack.org
X-Gm-Message-State: APuU4Z+9m7lFV2fyENJ16ZLKFVMW8H3CnbaKV6rgxrcHzKq+6kgzZisz
	InxySJDuU0s9dfrhDwaC1woK92zazr4wDMua0m6LaVJC6QuhiyzGPndndPOizlEIKIf5XB8cruD
	brR3Mr5ecu1v+GwuyI50bhWsKHj0Nz2Ue6XqHhCZH
X-Gm-Gg: AZFdTZdumrm/MmgizoNo8xnnMbWu5snqPu0F5ORbeZFBlkJ2kst1XW6Zyvknea68Evx
	ssPMu/rY+6w0NzeIqMsy1RqkprEJOSG0+WtD2DWbfu26nnCnRHVhTv5rxohvvFBLO/KVCnlzn6v
	q11XDVixBdUKWdKZdXimVkDsjJjt5/b49VFEKXOQhS/erdFNF0qov3+hArbZplLBUkExQnth/fR
	b+Hf6LECxZ+HFAHlLSer0byE+AiCc2uxC6+nmIKjEsXvqnDDSBl54Sq3ZnRzJgTg92uwBNvmXa2
	WB7Sz67bjRBBIbmu7/RNV5aWqhuTmqu4UmHVxz9xkZ/AKYgtiX77F9vLUA2OcYiwh/888Oi800l
	GM5rQ/vHnddkb6YhNHow0JOi7RIb7+Qk9K63vOO6bISXUJFxGdKkc4PMLLysYTJRzn65Bnw==
X-Received: by 2002:a05:600c:26cb:b0:4a1:fb0b:1c9c with SMTP id
 5b1f17b1804b1-4bb9169f045mr2044145e9.10.1795648425836; Wed, 25 Nov 2026
 15:13:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org> <20261125-hugetlb_fixes_2-v1-7-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-7-db27fd2f71a8@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 25 Nov 2026 15:13:32 -0800
X-Gm-Features: Aa3M54o0VivDc1V8RDqLgeYd6VEevBgWlfFAdGAu_CvY1Dn7_qwvILYBeMeboYQ
Message-ID: <CACw3F51O9kQut0+uOCgP4BEB6VmsmhFVLFxvLXGJPeD-dk0n5Q@mail.gmail.com>
Subject: Re: [PATCH 07/21] hugetlbfs: don't zero poisoned pages in a hole punch
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Jinmeng Zhou <jinmengzhou22@gmail.com>, 
	Hongfu Li <lihongfu@kylinos.cn>, Andrea Arcangeli <aarcange@redhat.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dave Airlie <airlied@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, Mel Gorman <mel@csn.ul.ie>, 
	Dave McCracken <dave.mccracken@oracle.com>, Andy Whitcroft <apw@shadowen.org>, 
	Adam Litke <agl@us.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	James Houghton <jthoughton@google.com>, Yang Shi <shy828301@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Matthew Brost <matthew.brost@intel.com>, 
	Byungchul Park <byungchul@sk.com>, Alistair Popple <apopple@nvidia.com>, 
	Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
	Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, Joern Engel <joern@logfs.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
	"Kirill A. Shutemov" <kirill@shutemov.name>, Sasha Levin <sasha.levin@oracle.com>, 
	Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, stable@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B504F180005
X-Stat-Signature: apco5prifnxdkq9833fkih9jpdk96kyb
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795648427-987803
X-HE-Meta: U2FsdGVkX1+SEX1op3nMcK8a6uQJbZxDMOxoJznihsPKEJ1/82mNotkVb6o1r93+9KIGLXDrm9iaiKpKI1YMg+mH9UHJgAd0U3DDbI0mjszD32AXyQDX/0USq1zXMJLM46Bb3pds4T0+IS3gPcLfhDtGkPYAyjzI12Ru6S+Ur7tjlWq76OBE0y/y2rcgjOrjgV9QaLdwYQOi84YGnJTu4tDWEso+lJcXLS1dJj64GXz27bQZ2UX5pzHaMg7a9EottiMF7bc05508qLOKalFDMozLgBBnU+wLearxxAdT3j9n82XaOQQgdA+U05TTdFhfk1n4z5dMXMv0Ggk36iH6ghrdC5ednkqjWWqOhGw055NyaJTyKMEM1RoT451WPcOEKleqyN11jdEeSN//8zl0cDPgUSB4v/ou4Ua0N8y2r88CtlluD7ftr66BxqtehNMW1YYRdtSwZec9GAzgdS4IO/zIAeXIhpBYzem+v9pqUpy7LJ63tyNm7DX1dYhMWRfKqzkvKVwlV+e0OcqAOrWv5SFk8H3MmC30TldozYQElq9QSVYuwbRi/8uXXRFPx9yw213c02+g1EyjxQbyRLCx7zjNsDUhQyyNQ3VxWZL59ySrYkv1v1cwSU0HLMjoB+37bkpHhYjMuB6h+UruZcK6UpdYn5azVZMfMbSbDQEDSgajQA8ZuuCrT7T1BVZqVMYv6i5sZlNujMbUVXu0+v3wPEu2hemG+CTMfvYUAMQWrwN1FnVONk1eG3q1fy1RTGyldAa2LzrrPUIHa1G83DmB65gZn3vWdaGg5uSta7hqVspL2+fjoZzoJtuSBGaagzZe20G5MvQ50BdPrCusYMbZtaO4+Z7mEMi+2b4yFqzxkb9d5fa+0hp/9AS3sGojNudZlG4/f6zCAWdz9SaSkBxpr0wLgU6DGffncLhfYs39dQbIPWuZ7VMs+o5APo/oXUPwmA17x/4NnNPa+qeKYs/
 7aaJJYUU
 qiTX3G/95U6b1tAqrrWdBiwEY4+OtFM371uZ7YoIG/iXJNDLLbpQ9Rr3gwwl7JHDtTTGCS9YdvETLHxa9PO5kM9xgNIGGltBQMejs9xgqkyhLfjvdf0WPt9M4KUGJW5ibxbv1CNe4Xosxu4JSRrZ6HHg6fGJbCkgaONaClGv9O6c6r7ZF3Ot+s7Wc0qWLtmWetw+SjDVhPjSzTRw7rJJzS/rX5GfjSjmLhcsqWaUB1A2VZJtnvCk9XS1IIUBQyngu1VzhgeAGyhl2O7iGlEwV+FI0GOl7HyiuTfXejDhMmYgJWC+YQPGfiKEJ8LNxcnbkkz/5GPtEAm1s0OfUsuNC9Gq1cY7rBsvH4otWhCzHm6tjo9hbmg9GPfUGx66SgoVV1KGX15rFeFt7yDPJp6Xd7aILMatj/O0Xj0KrkmnTC63ANeQijx4TG71TYZH968Qhp4H4CIJrm+Vu/O/8AUgvIBBqz2cey3oKjBD3hQ07Sm79m3o11VlARVz6Wnu41TJMJb1VXsiHwAFxMu3KUbvFoeoOBHFHmFMIsNR1AwjdZjYglzxSjdfMA9nzhc+yKvzJ3KmslAW5EhrU4Uo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 2:35=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> Since commit 8625147cafaa ("hugetlbfs: don't delete error page from
> pagecache"), a poisoned hugetlb folio stays in the page cache, and we
> must not access its poisoned pages.
>
> However, hugetlbfs_zero_partial_page() zeroes the partial folio of an
> unaligned hole punch without checking for poison, which can cause
> issues like machine-checks.
>
> Let's fix it by simply not zeroing poisoned folios. We don't really care
> about their content: the folio can no longer be mapped, and read() only
> returns data up to the first poisoned page.
>
> Only zeroing the pages that are not poisoned would need more thought, as
> we cannot reliably identify the poisoned pages; that is future work.
>
> Note that a folio that gets poisoned concurrently, after we checked it,
> can still be zeroed, and sync'ing with memory failure handling is also
> left as future work.
>
> This has low urgency, as it requires a hole punch on a poisoned folio.
>
> Fixes: 8625147cafaa ("hugetlbfs: don't delete error page from pagecache")
> Cc: <stable@vger.kernel.org>
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/hugetlbfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 2e8672ae2fd52..5437a55d14f1c 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -656,7 +656,8 @@ static void hugetlbfs_zero_partial_page(struct hstate=
 *h,
>         if (!end)
>                 end =3D huge_page_size(h);
>
> -       folio_zero_segment(folio, (size_t)start, (size_t)end);
> +       if (!folio_test_hwpoison(folio))
> +               folio_zero_segment(folio, (size_t)start, (size_t)end);

Clean fix, LGTM.

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

>
>         folio_unlock(folio);
>         folio_put(folio);
>
> --
> 2.56.1
>
>

