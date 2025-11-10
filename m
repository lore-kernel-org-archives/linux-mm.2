Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C2ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 23:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6242C8E000C; Mon, 10 Nov 2025 18:39:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D48B8E0003; Mon, 10 Nov 2025 18:39:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C8B8E000C; Mon, 10 Nov 2025 18:39:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35A598E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:39:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98B941DF325
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:39:13 +0000 (UTC)
X-FDA: 84096315786.02.11120BF
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA2D94000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:39:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="mT/klMDg";
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762817951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auOCGMGZsgkQSYvZ+oudFtHe19C6Wc96WcK7gMZx0zg=;
	b=ZUTCWGX39xUgM3p3YyJjHWAryKbbVypZQ9LgB2xoK5I14FxAnnL+1+ZL8rQnRdlQNGZnrC
	3Q8u9Qwe9m7eKo8HTg7FfXj/lT7BwM2mQ+AJx6dJKtHmqf6sqWfQ8QGb3T0h8loSGVs0tB
	10gZrX10XqEvC2GnVwFL5Ut/e+vwnyo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="mT/klMDg";
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762817951; a=rsa-sha256;
	cv=none;
	b=zfpiGaG0oOAvqONuuVHrlC17N7VkYG4fVRgx7jwLpUZkuWOUcjyr0Fe7QQnW6LkA7pH5FT
	dWcpWSATWIUmP2TQAE0+SirX2WdzSLeE3zcvFv2uPIncYtC2VTZfeNn8FPykUwTJjrnRBX
	PTl5mSZ2k+VeZKpmdnd1f6iTTLlee2A=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78682bab930so4341857b3.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762817951; x=1763422751; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=auOCGMGZsgkQSYvZ+oudFtHe19C6Wc96WcK7gMZx0zg=;
        b=mT/klMDg207pA5UyaU0gz3+Drx28u1G2zlmxCOs2EoHDS0Vz5XeXahS5AbgGyxi6W9
         Qx7Y0+cQtWp32ifWZEIIfUWuxebkgcS56e0yoe/TbA3//cTSu/D8MhF/0e4QVwsz7vrR
         awjm90YIudeJoqtkMR33Snrn7gFgPnjqnmcTaIwlM2GZio1PmwZpbcUcizrljA8Gohko
         VnE3cHw3TC35EpysALYWcPJQ2C7Bnzbc7z+UYuEthmbnfW/rOVKAwnazd5QOTWVCor42
         Wq5/UrZJVLBvV9wdfQCFDCC8CsCCgNtFgbbhtL3vpbitQArnVWovmKAcyCymnwyjfJTZ
         Lj3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762817951; x=1763422751;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=auOCGMGZsgkQSYvZ+oudFtHe19C6Wc96WcK7gMZx0zg=;
        b=Rcnn7OHS1p+ErVvvLWSUcCNKcqvRSYlcmYTe3WTlZ+GesqcOSaUMBeGG1hkMxP+2iu
         chTRrC/CmtxZgKLsXnQAUqtxkEQUVyb4sjkWrbe2Eu2WZ+MZWyY76xJoiNlqSY4m0imM
         hYknct//ovH+4Oaq+hGG16aNA4ZPHsAj9KJsjoltMVcJx7hFb7XsmB5n8oT1Pyk9WAiJ
         2kIhXQ3PT6r6rgFioHy/LzYtedFIOB2edushOcw6zZmykx/UQg0rJmralkNwaP0QNZ2Y
         C/FK9H8aFw7UX4M6nzht01WCyQJikQWcT4zvkIGyHYJrmf18hqyimDVcjh5qRkY8ZuE4
         IzkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVC2lzgCPJqVUhKVyuT0Xn4YdOsh2aMZ8QogJH+M97KqynyiA7JmG0TaDsmLGE5cUJZZCX6coJgwg==@kvack.org
X-Gm-Message-State: AOJu0YxRoiHLX7PNkMWCedrKpmFNXqhYMq9dI5Gdh+QYjU6DzQbhHo6C
	rjqSVLg7wzew1j1yXyS3sJntQQS/Toa7fh1Iu1kR1QkC+CGOCjHc2f1SLjkrzTXlgQ==
X-Gm-Gg: ASbGncvSOHNe3B4gOcss4iDa8LN4HggoB3BIj48P5PVL0wDkzZvKilSDZxUZ1pOkR8A
	XeAhM2ieJV/xUI973IZAk0XZb/F1PADjsD6keSkQ78gkMc4jffMJMojbPU+XFpIW1tqfz7LRbmf
	+GZtMi3UsNzAUWw0TUWksD9VUelUU/JyfUI8TBcffX7PR+5nwNQEDiYpnlaflNpcVRFjrfsyjlu
	vUgz3IFjPySAj8y76ZdLumLRVTC365lKnhzAsUX7NBPWFzpWVn6GGdmEzULmzHtDWE5nJfwZwGv
	oXvnBaqUbw28J4b7IASz34kZlrZpr1KvpuUAYdP1H80cInW20WMDEPf5poohdmB9IlBH8+J2Y0K
	Li9IRD05chJBsue/D09bh2GnRYfuwE6fCi50i0VGHM8tKaWdGuBVItFDvt7kkQ9Wqdkzj4EGXA5
	mQV6wQ0lZlt+NA8cMaZgA8xgbG8LyudqNWREYH3CCUYY9zX6H29NXRp5LT/OHMkHUm33ZKESh3a
	kSAXmp+gA==
X-Google-Smtp-Source: AGHT+IGhKzpHrBaCl8nie6rdibzD1wCPS/Sl7zTN9XwZ4g855DlbGN22SspoKQKrIKKHgp9q/nU6ag==
X-Received: by 2002:a81:8a07:0:b0:787:d107:ca88 with SMTP id 00721157ae682-7880355f82bmr9116177b3.10.1762817950151;
        Mon, 10 Nov 2025 15:39:10 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d6a2947asm27792067b3.55.2025.11.10.15.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 15:39:09 -0800 (PST)
Date: Mon, 10 Nov 2025 15:38:55 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Janosch Frank <frankja@linux.ibm.com>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@redhat.com>, 
    Alexander Gordeev <agordeev@linux.ibm.com>, 
    Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
    Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
    Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
    Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
    Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
    Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
    Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>, 
    Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
    Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
    Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
    Ying Huang <ying.huang@linux.alibaba.com>, 
    Alistair Popple <apopple@nvidia.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
    Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
    SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
    Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
    Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
    Naoya Horiguchi <nao.horiguchi@gmail.com>, 
    Pedro Falcato <pfalcato@suse.de>, 
    Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
    Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, 
    kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
In-Reply-To: <3c0e9dd0-70ac-4588-813b-ffb24d40f067@lucifer.local>
Message-ID: <c9e3ad0e-02ef-077c-c12c-f72057eb7817@google.com>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com> <CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com> <5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local> <CACePvbUvQu+So7OoUbJTMLODz8YDAOgWaM8A-RXFj2U_Qc-dng@mail.gmail.com>
 <3c0e9dd0-70ac-4588-813b-ffb24d40f067@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CA2D94000D
X-Stat-Signature: o9cg4tw791qhqhmbeyn737xghyephiky
X-Rspam-User: 
X-HE-Tag: 1762817951-454212
X-HE-Meta: U2FsdGVkX1+LpmyY0V6pJ02FqThrqSS8AFCSYo0P+eaJPbu0PmxEjPw3XQfeXAP3Iq6B+rX7+u5a0zdK2d80lqhIilFJ+3eZTDvgerF9UWJjvxE32I93LL9zOZNelqAETzDCu2d0z9MmapD3gZvQ2IB34xAp1/EcKqJ5j4dEOrS0LyEU4FppbA+Y1x+vqjTlgYGbEfcS+dXCJq5O7NtC+nQ9jfCyR5msFTbq0crp+VEGQGBecX2UFO3TLnTpNqiR27X5iFDBustqfwvXJXc21h0CIwSc51vs41vFfAIgUbw4xgbPFSKa8J2gVQMDPP7SEx7a2y5hj1k0mt0D3WK7Oj2cxZj4jIQzP9KnU+4EDoTOWP7ZOTetq1zxOQhlvZgT93+2Su9G+WYGxf2tIOE8dJBm9v5CBcEh5rdO8+8wMFBmzgexywvgc5srWPDUJmvnyJGSLlW/t6RAVjcIHY3Pif2mnhsE2UdC0o/6kwWuo/zZ9t2SYrW7MadGLDz+fOId0XkYMVrmwRCgnOy33a/oJ8GuCHwSZBqsaDH1G23ddV0pAG1WrbIwbAvahoTZ/zhFUMwmc7gLubFELYxt8i4OlHaSEUCcJJ7wBbSprsZS8iqju9D5CgUEcYXRGCtDCEcsbIbTtKLinmloBA+Zi0kdb1hO9kuFpVc1lDVdRnewovMPh36mDSghKgJFECwJIMflwQVmz03tx0jTUtsx6jrwQztdFJGPwHzGQb7mW3DiAh5CZzjZHhfS3/Ive/sABHh5HTw59NpqXdBuuyUI2cp6ZMVQ1Pya6mmHzfO3ZfpDDpXRi/phl5MsgMAV92TCzILCFT9tVgQCjnI5xfz2ustDlFbz15NEnmtR0hoBQIJXRG3rMzSk87zGlutGdjQk4Ewx+bftZQjh4TR72u8rnS0Fo5wU/wzQEu9CKMGeKAS5XkewR6iW9EIv8CLh212imAJzkOwQ7jhVx0orhIgAGz4
 BO6KmLI5
 QoTqKgea3pQv+tzVhGNTJzr6SJb0Guw9CyZ5b159w8cdIbFyK1nIIsdaa+KITJSTnfyh+BsV4V/11/iSS/x7APSBkFr9MExH9JYkK6TzrjyzH/go3HrlWNMnBiXcCLdM0+6bV1dOeQsttkThZdVsDCaExZgpIVOY2DRHjIzsiPDpMMMSDqP2hNyUTlc6YI3jOzxNeUnL5UlXMKlK7MUn8dJ8sQ9124/IaT6q8dCMWow+j2P29k6JHNqLYaWgVSiWF4Jv8VCdNJ2siH32WoViCoo+ZfjIZ5iPY0/EDPKZVKIZho9L3JPAHI/FVXz0UdebSs5jHs94lv83xpLZ2Nf1gG7mxc0/ZqCYAjyWKByJSOKWOr9umYfoWmz6n01i3gU4qRblt6csQiGNsTp245UiDgp3H5VgqqJKeVcmecvV0X5m2DJ6bgDMhb6nji8q9fhpNYgGmulTNd8lDDtdaonJj1DReuY2FOs/VUKd0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 03:04:48AM -0800, Chris Li wrote:
> >
> > That is actually the reason to give the swap table change more
> > priority. Just saying.
> 
> I'm sorry but this is not a reasonable request. I am being as empathetic and
> kind as I can be here, but this series is proceeding without arbitrary delay.
> 
> I will do everything I can to accommodate any concerns or issues you may have
> here _within reason_ :)

But Lorenzo, have you even tested your series properly yet, with
swapping and folio migration and huge pages and tmpfs under load?
Please do.

I haven't had time to bisect yet, maybe there's nothing more needed
than a one-liner fix somewhere; but from my experience it is not yet
ready for inclusion in mm and next - it stops testing other folks' work.

I haven't tried today's v3, but from the cover letter of differences,
it didn't look like much of importance is fixed since v2: which
(after a profusion of "Bad swap offet entry 3ffffffffffff" messages,
not seen with v1, and probably not really serious) soon hits an Oops
or a BUG or something (as v1 did) - I don't have any logs or notes
to give yet, just forewarning before pursuing later in the day.

If you think v3 has fixed real crashes under load, please say so:
otherwise, I doubt it's worth Andrew hurrying to replace v2 by v3.

(Or have I got something bad in my build, and will have to apologize?
Or am I blaming your series - seems most likely - when it's actually
something else which came into mm in the last week?)

Hugh

