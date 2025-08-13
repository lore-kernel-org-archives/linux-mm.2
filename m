Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1028CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 21:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C899000D4; Wed, 13 Aug 2025 17:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDAB900088; Wed, 13 Aug 2025 17:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5189000D4; Wed, 13 Aug 2025 17:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECC3E900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:12:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49BC81A04F9
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:12:49 +0000 (UTC)
X-FDA: 83772983658.27.A2B4DF1
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E9AA20004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:12:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=czMTMoGo;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755119567;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6R+FsQ2hbhcp1JFqDm2g0PdnGeoxdv4HV80v5lSsu3w=;
	b=ncWPnRECG0IDpEAjkvrMf791G6dnPxnqPW/rEZQquRmUotDXs5S72MRGyiwIr4u81Pv4xn
	27+0VTQ2Jf5iS2wvvNJlUeh0/VSiqEtJn8OP6fletL3TAZ0/6nUySQc/TSKY4SiEujSO9a
	54h2k3+cyatYvPUfK2av1DPyNMnMWiY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=czMTMoGo;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755119567; a=rsa-sha256;
	cv=none;
	b=8k37tCnpn3JtCTlNBjcRx6pF+eCAjEgnUJnPWn2z2F2Mw0qq3R3NV+rP9lRJkZao8A18jz
	4uGpZz2SRFJOb5dPOowlLZl5tu2bYgcX9a1qg7RpvLyksc8Wnl4+i56A/ZqbsTwG+oOLGY
	EZOmkkfJa5ddklsp2vphHzGRQJQPlbk=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb78d5e74so48608666b.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755119565; x=1755724365; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6R+FsQ2hbhcp1JFqDm2g0PdnGeoxdv4HV80v5lSsu3w=;
        b=czMTMoGoRwFM3iaN3Z3xCcL05xWZZjVZwbvkgOcu24yxLnUZtcTa+AY8mJqTuWLmmF
         IUr4nxwq9pN7qBlIm3CweLbGaHs//lwNIgN54mTwai1Oo8kS4t8W3xCYljPzBmZql8l1
         YuniffxC+q3mfkyMyk33T7I6xmj2n7MuL6lchYLg9TS/c4HeDnYkI5HZVJaaLs2E4BJ3
         N45UhOiIiPfYki/T9DZ8xNCnBnBQc2jhX/7kwIJSPljlq6CaSVMJtcCxwcPDGDmPiikO
         bpjAasDPfhNO3iVQtI7Lq4ICSsWfWEaGkcVBWrE3TpGDpu/y79sZ5pDB0hMhU8qKX00c
         8//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755119565; x=1755724365;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6R+FsQ2hbhcp1JFqDm2g0PdnGeoxdv4HV80v5lSsu3w=;
        b=MVjQSNHgdteZ4q9FjRiVw5EWpz7XJGLvM6kA3RP9uZ+d61mGbkpWGPwvCgvKPENgVu
         VYvITNM71J5ujbqRsuZQl/AdbgqS3VTsH/GZvNXjIqpQ/NM+HI1hXfS88ryQFLVkkL4F
         QvpmjoG5EFRaPqJl7vPC7mRv3jwnpBd7ZZF7z8g3ljQij5SnJjuDOKSxSBRQ3CSmvkNs
         tvmz9Kr9/CUaARUrQPL+NpCPyC+qsICbazHpyg66bdYiYPXLGmeCb6W8X2/l+dbK6/3O
         o5e0ouT5hH0DXQy/hZQL38qOdbbjvdlWadIqsvz/Mdk7c9VxoLq8Gfpl+2lQvrAlj9DC
         Lk5w==
X-Forwarded-Encrypted: i=1; AJvYcCUBenWCHFU05MEwA82WLYMgaO+6+dtAxef7JPyyUB4nvWOLeByDGedl+GJafNn2HjsAj/em5n3X4Q==@kvack.org
X-Gm-Message-State: AOJu0YyjX6VJ+H+ckfCXJU2X5xoEQAOCxgPhypr+7aDGJD5AT1c94TRJ
	tO3GE71VML3K7fr8/gscj04kGbJ501dA5YyT9iyhGivv3aBVRwvn8EEZ
X-Gm-Gg: ASbGncvOwANV9oyNpyJruLCMyrrAbSvGxqUoDjkZ9XptOHbohm9zznqPiR7rtBV9pXk
	oUyIk3v+1heZadF/vQh6Jf2WPqildzcfhHUn2BXjNZ1I8Dv4tWWYXgefy1ZkyOjuLzhtVraB/pv
	PFCz0U8Gc49ZeVX/6k56qZFNAZGwIHdreaIFreTLkimVKY/QFIoOQoTCBa0Sk3GvHeOv+FvyVY3
	lQ0qelBTxSvbOIkYZ1WMWh4wOkDzlL5U1pTPk4GMA+Dmd+YoRE79CxTlU6ATq5iZkwaCeTPp1Tk
	nOIkT8ErG14qNyHtRPZ3evDCXX066EZIVefD3NbSMRKEmNCNGm84QE1brjtxtNRZnhpkWbK+gH7
	8Hpyqsv/JWvj46xNZJiKfAUXjUYmehqhl
X-Google-Smtp-Source: AGHT+IEQx3+dF5FhXYRCJA2jGhnWmcvHp7LT+bA3JCWJ/ZghpN0pfgTNFHkTyAH3O3lXS3R8AV+/GQ==
X-Received: by 2002:a17:907:1c89:b0:af9:d863:5ce4 with SMTP id a640c23a62f3a-afcbe075846mr21721666b.15.1755119565076;
        Wed, 13 Aug 2025 14:12:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a078afbsm2455007166b.4.2025.08.13.14.12.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Aug 2025 14:12:44 -0700 (PDT)
Date: Wed, 13 Aug 2025 21:12:44 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/4] selftests/mm: add check_folio_orders() helper.
Message-ID: <20250813211244.ikequq4kvgs65mpp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250812155512.926011-1-ziy@nvidia.com>
 <20250812155512.926011-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812155512.926011-3-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 2E9AA20004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ia4mq7r8p6wpw177jy1fstyeb9q1xcf6
X-HE-Tag: 1755119566-360035
X-HE-Meta: U2FsdGVkX1/NjxXH5yRRuLKRq+BtTqk+uHTzWwwYJLnhDg6covfJvsMY0Q8/q0IyKbiOX1XDbkMub2yT5HJuPzvsdqnxThDC9vbIO+xCNP9K7rc+cW1/YdTx5C25p9oG7U199WkUNOEk++S4+PayOBYnUnJyQ5VG0BB4UXGtuQRJQy9rySTTxz100gNbutykjBMG3vZz8NCWm1W4b+DyDbCRdN2r3VpKN2PMYRMw6ncDz61VmMsTVujAiO1SM9C6+YTnqaUQuM6apMw+lJoyk47+15TfwWHxqC5XE5owYSmtASs4yxcMBjEVI9VuDc0IAEIo1qsNcPqvvzbqcglwNLdTPtoGV5WM5gtPW7Sw8A6HHBXS3t2RMWVWb68NYRu/qOKlJaIQa+eVXXkVshtdngfixA5JNRIAxF/IelXAqfVa+A+3Z+pDzAKo/+E8QEeM4ZPnabldVtUOgU4VKRX45kIGHJxeEr5ISgzvBVZVJC4/mqngzzlXqgHQsmzm11nXdyxyCvSO7a3WLddI6OXYRlHL68vTf7KBqCLIu7tb50L4yHzdTnNeGZQsdKtWL+dIzRBSX02qUgt5qccpVS44+2AMtqbhJEKmnqIb7dR3eCJopq7Yim5rYGJEDWQuxnScoJVAR/F5oH3Dj/x1+A2idKZLAASEaiRZHOEK+prJHGXP9OwHXFKaZmNdWc6jiZYMOeIH2RVIiANCh4ZqhKPXSaWlf4Yk9FqyiRcLWcAAf90znplenGrqqSkEVZREzzew3PUCPhZ8BrHi2MrbVCKO+goXVufUXCAuh9CZyT3kSCzcMopB2JSutsGX2xbFDIVt9FStpwLVgXdTy9kor5V4lh9a2s7CCGV12l1vcKoELCYn4TQQAw0y1arPbYRnOgrpDIIPDYBWoURdeX/FTBmL2ghWJOvoIZSdcBlThJbqxmjFSHCs95eVxIHTAPEAV/x83qzA663JoDMI+YtsYB7
 k/sWZ2Xd
 WvV8nb0sfOv7qc+M0HppWOpDyQ9ECH+NPRgFOUgk4079MfH4K5AilZyAw6PmkafrMfBi94qdCNNF+YQpEuaclVnYpSRLw3kJgwendzREiR/8QyEyGMtnKqxJnStVjU2qLyGLuHqk6SLrihconJG103FWvWKFWZsExAcD7KMYd9G6vfyhG0vdWszKDA7QhOhZYE7PMnJwzFNL0r0zQSJOcpxnvsRI1W8XEqJPbcSvXs6AbmeSjpMbXXYuwhhO2Gia9mLjKJdbrJovDMgk6Uf9xgcqL6itgp6Z25wIrW9PM1pv/6Bpz/E0eQoFLpju4+WTPq8YPhR76rIvvYOXwXdtSrfVlOiyOMMKd0SEqy4YlvLQTe1jEZs3qMnFCTE/NvX5ig+PMMDeToRoRP/iuz9aIhhoSnNDGHUX3zocgoMH+PWnJYzpsBq+kqmXCcdYDhnGgJhz/NnRTdlTWggMKuFYUHR4oiWtmgyQQvzebiIy9ZOua2JGo/DygQqpYI8tkjgygYujdvwWOH04NtdrCE60VhtSBy5suGxgU5mpHkNFHkGpXST9pWU9auPBAvBAvr6HR8THdoE82Dd/2e+2Ds1jHGYUFTwPqQT+jphrFz/JT3bViXSazeVmB7GXRGTU29X5Pno+7bL5I/VkcTrxS2t07bxusH/f9iUZD5AoPJZcjiLjSe+ud6mFpVKGGdK+fOphBtAXzaargHAp68BTDk3nvU/3br3hlvXC8HMQN3bZXq2B++7Dg8x3NHhUWdtMZUt+2wnZ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 11:55:10AM -0400, Zi Yan wrote:
[...]
>+/*
>+ * gather_folio_orders - scan through [vaddr_start, len) and record folio orders
>+ * @vaddr_start: start vaddr
>+ * @len: range length
>+ * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
>+ * @kpageflags_fd: file descriptor to /proc/kpageflags
>+ * @orders: output folio order array
>+ * @nr_orders: folio order array size
>+ *
>+ * gather_folio_orders() scan through [vaddr_start, len) and check all folios
>+ * within the range and record their orders. All order-0 pages will be recorded.

I feel a little confused about the description here. Especially on the
behavior when the range is not aligned on folio boundary. 

See following code at 1) and 2).

>+ * Non-present vaddr is skipped.
>+ *
>+ *
>+ * Return: 0 - no error, -1 - unhandled cases
>+ */
>+static int gather_folio_orders(char *vaddr_start, size_t len,
>+			       int pagemap_fd, int kpageflags_fd,
>+			       int orders[], int nr_orders)
>+{
>+	uint64_t page_flags = 0;
>+	int cur_order = -1;
>+	char *vaddr;
>+
>+	if (!pagemap_fd || !kpageflags_fd)
>+		return -1;

If my understanding is correct, we use open() to get a file descriptor.

On error it returns -1. And 0 is a possible valid value, but usually used by
stdin. The code may work in most cases, but seems not right.

>+	if (nr_orders <= 0)
>+		return -1;
>+

Maybe we want to check orders[] here too?

>+	for (vaddr = vaddr_start; vaddr < vaddr_start + len;) {
>+		char *next_folio_vaddr;
>+		int status;
>+
>+		status = get_page_flags(vaddr, pagemap_fd, kpageflags_fd,
>+					&page_flags);
>+		if (status < 0)
>+			return -1;
>+
>+		/* skip non present vaddr */
>+		if (status == 1) {
>+			vaddr += psize();
>+			continue;
>+		}
>+
>+		/* all order-0 pages with possible false postive (non folio) */

Do we still false positive case? Non-present page returns 1, which is handled
above.

>+		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
>+			orders[0]++;
>+			vaddr += psize();
>+			continue;
>+		}
>+
>+		/* skip non thp compound pages */
>+		if (!(page_flags & KPF_THP)) {
>+			vaddr += psize();
>+			continue;
>+		}
>+
>+		/* vpn points to part of a THP at this point */
>+		if (page_flags & KPF_COMPOUND_HEAD)
>+			cur_order = 1;
>+		else {
>+			/* not a head nor a tail in a THP? */
>+			if (!(page_flags & KPF_COMPOUND_TAIL))
>+				return -1;

When reaches here, we know (page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL)).
So we have at least one of it set.

Looks not possible to hit it?

>+
>+			vaddr += psize();
>+			continue;

1)

In case vaddr points to the middle of a large folio, this will skip this folio
and count from next one.

>+		}
>+
>+		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
>+
>+		if (next_folio_vaddr >= vaddr_start + len)
>+			break;
>+
>+		while ((status = get_page_flags(next_folio_vaddr, pagemap_fd,
>+						 kpageflags_fd,
>+						 &page_flags)) >= 0) {
>+			/*
>+			 * non present vaddr, next compound head page, or
>+			 * order-0 page
>+			 */
>+			if (status == 1 ||
>+			    (page_flags & KPF_COMPOUND_HEAD) ||
>+			    !(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
>+				if (cur_order < nr_orders) {
>+					orders[cur_order]++;
>+					cur_order = -1;
>+					vaddr = next_folio_vaddr;
>+				}
>+				break;
>+			}
>+
>+			/* not a head nor a tail in a THP? */
>+			if (!(page_flags & KPF_COMPOUND_TAIL))
>+				return -1;
>+
>+			cur_order++;
>+			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));

2)

If (vaddr_start + len) points to the middle of a large folio and folio is more
than order 1 size, we may continue the loop and still count this last folio.
Because we don't check next_folio_vaddr and (vaddr_start + len).

A simple chart of these case.

          vaddr_start                   +     len
               |                               |
               v                               v
     +---------------------+              +-----------------+
     |folio 1              |              |folio 2          |
     +---------------------+              +-----------------+

folio 1 is not counted, but folio 2 is counted.

So at 1) and 2) handles the boundary differently. Not sure this is designed
behavior. If so I think it would be better to record in document, otherwise
the behavior is not obvious to user.

>+		}
>+
>+		if (status < 0)
>+			return status;
>+	}
>+	if (cur_order > 0 && cur_order < nr_orders)
>+		orders[cur_order]++;

Another boundary case here.

If we come here because (next_folio_vaddr >= vaddr_start + len) in the for
loop instead of the while loop. This means we found the folio head at vaddr,
but the left range (vaddr_start + len - vaddr) is less than or equal to order
1 page size.

But we haven't detected the real end of this folio. If this folio is more than
order 1 size, we still count it an order 1 folio.

>+	return 0;
>+}
>+
>+int check_folio_orders(char *vaddr_start, size_t len, int pagemap_fd,
>+			int kpageflags_fd, int orders[], int nr_orders)
>+{
>+	int *vaddr_orders;
>+	int status;
>+	int i;
>+
>+	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
>+
>+	if (!vaddr_orders)
>+		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
>+
>+	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
>+	status = gather_folio_orders(vaddr_start, len, pagemap_fd,
>+				     kpageflags_fd, vaddr_orders, nr_orders);
>+	if (status)
>+		goto out;
>+
>+	status = 0;
>+	for (i = 0; i < nr_orders; i++)
>+		if (vaddr_orders[i] != orders[i]) {
>+			ksft_print_msg("order %d: expected: %d got %d\n", i,
>+				       orders[i], vaddr_orders[i]);
>+			status = -1;
>+		}
>+
>+out:
>+	free(vaddr_orders);
>+	return status;
>+}

-- 
Wei Yang
Help you, Help me

