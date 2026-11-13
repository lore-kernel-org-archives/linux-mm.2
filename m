Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C7C606A89A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NjjHi0Lz
Received: by kanga.kvack.org (Postfix)
	id B49C06B05CC; Fri, 13 Nov 2026 16:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21366B05CD; Fri, 13 Nov 2026 16:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37FA6B05CE; Fri, 13 Nov 2026 16:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3896B05CC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6089FC0253
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:09 +0000 (UTC)
X-FDA: 85431431778.27.95358CF
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7BAC31C000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NjjHi0Lz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBuZUW5YrwkUb17SSDsBVeP5Pci0JiCkYJrKClP/tTg=;
	b=75CbKMhybxdW84kyMZ5TuiDQfRrmQc/tomwt2ASbcqPp61N9HLlX9ypj1EB8kvwCyU9uZ4
	yrqWBUP8kwRZEIPxMO25VWLH0quK2vZ8e4MA1EAMHRZ2DkDGtUZgDqUnmatwO55Db4xXNJ
	jubqTLil/DrZhQZvOJ2KrUcTKA5RbSo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NjjHi0Lz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794606427;
	b=OZpUWJBJwG9xzZXk+anjirklshFwuyipHPLNyzmbFPbhzzUsIa69jOAv3AlVX5hdK4Zkn6
	fLFH6zt4OgtkDXBuULEOLOx4r39CH3lDloZIj2C7vSnBwBgHnHFI/rWCioG17WmA+AugvT
	o9Ca+NbkpctvkBywnVl7Q50Qvuioemk=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so287987966b.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:47:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794606426; cv=none;
        d=google.com; s=arc-20260327;
        b=Ozd8o0hT0pAYDOk3c2udqA3q2H8UoW/GofS/w4MPMTbBhPwsuKazXnGEihfnP4Z+tu
         27atMIiHXd2LE1V5VynR4iuInH52kGaaMEMp0oo6Y9n9p0cgYGhQgvh9ZyuSF+GEqcr8
         n1kViz8OKB3XJBBz1tXBQ3Gik+iBCo4rJkrbnVvQ7sBidqd0Kom9xquxOWLhM8Faptii
         QQC/CVWYDOWrVa2qUQt5Qq/dO4nn5Kv5yB/xsCqtqE9pd2CX3lfyHvFExPEVciZmj0Kc
         v8olM6M4IAJZeGddG/9sjzug12MdxC5xPLwzV5fvPJ0yJHJCQF1FNO+agggdC4Hu353d
         YJsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DBuZUW5YrwkUb17SSDsBVeP5Pci0JiCkYJrKClP/tTg=;
        fh=Gs0kZTEsgeJsIu0+tnueOD7g9VnIX5WImFhRNOmE+DU=;
        b=VVNts3o+pcQkPr8WFQ5f8BIcwUAPiWw0D+f9F9tl6cjA4Vw5uXSmAN4SURftgjbkCy
         Mnz2lEkdhvsQEACxzQQRScXhY8uBlK8TJguv9cbpfkj9etJUWPYJ8TnC1TjAm9ODd2XT
         gs0sEs2jG/7jch9ZT2S1mGUCNrXbYnctbbgcgCcw4zqMm0hWbezhO94ZeHm9kpbIMM0i
         P0QnDuB4FqCWO+v387YP07HXf3b53o7rJ45vpBNlgs0XqAsAY5dDXg17qAvk9OOZEbX5
         3XzaP1oy7IJhd1+9QaxlpvBtJEyuoxkKqKL7mXKOSTVyv1kYP5V3i8KuvmB/Hd/CgCLt
         hrVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794606426; x=1795211226; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DBuZUW5YrwkUb17SSDsBVeP5Pci0JiCkYJrKClP/tTg=;
        b=NjjHi0LzqrKgxq+Pf0NS7HVrUb4mYHAekjIooE49pkG2SX9zbQ/pqBcqTmHpDHwP5r
         QQof7gtzR1zuHraAQ28lLfDxKmse/g/httaVdRR4FZt5NA5kGvaH2/MFugMXR34JPwAF
         xyLJ9yd/hdieRxyzcJNSYiPzYsLAregz6WRHkwTkCDmkd5sgyezbHphYU+6IoeuxIqEQ
         /A3JMJYajnOSsQFkNNV2WTC+mMJGC2kRF/43n3rlNPghxOZV7SFZPxdU2f+0NNSJBauW
         xhlUabuJ70D1q8UQyBc8P6BVtEltnD6nHps+6MZYkhU+UZjGiKgXmUSx5Acj0ADxB94X
         4ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794606426; x=1795211226;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DBuZUW5YrwkUb17SSDsBVeP5Pci0JiCkYJrKClP/tTg=;
        b=0NWN3YQlXXSLBxtzMbfJw2MqDVtaRsQ9+3lb1ECtQGK4d830gCfr72cvVc0PhLLQE2
         SEXil0zR3Y0/nDwZOsYfqcihAwIQAKbrEp7tWL7tA9uZLzqkoncJSpkroS6Pl+ZWoS6f
         G6ba0hX5fu0tuj+0RzqmsMLazBBnwEioT80zqDQInLBGHCPV1Twyl4zB/Lw8tcmYkHjf
         cdBvTfiIatAQpDQ2Z1A26oclYaigAE6sPSSKhy/XMUBzmSCXIX7CG+ejNNs3k6SEk0DG
         Ehm5iaEyJoUkM6dBeAywyNvrWWMznuTKZ4DSdzXH1sB7xLTOUs30lxIhr0oDm0HDcs8z
         mlPQ==
X-Gm-Message-State: APuU4Z/+9Gq+FfnIVy4ijo5du+L1z88XT769bRf8mM7RoSWYtneEfksy
	7h2YLDHIA4TmxmYkP8tYlf9ZWaF2ht9LDauGiWnsX3BL8HmhulqQNXYYd2xZtCMxFEsYibUCGTr
	XNuTERv69+hxQk34iv7afiz3NLYI3S/U=
X-Gm-Gg: AYBFou2+Ht9bFIMQ18yH7/RXamPX3JvOTaEmo2iqFTzFJpwypPUl11vF1fa0chFqkB3
	OiGqFYBxZz9uo6NGXw5D/yqIBf7NwbIXz5ZjCyi7KfTtDGjfL70s0teHFxL4AHtI8DlUdMIjrV1
	GHtPuQzuZwXJCNh2kQ2IPLkGSGnsKtEK5ifpdfh18ikqVLXWacSJvsoDGSxFYzxSb9NjhoQ9uk1
	BIMgVGUbHy/WHbDoWt0gF8tZYzrHWAu5C+GVYYUGiK6TbFsLajtcDhAsm7f5mTUTOO1DJ5AmcV9
	s3KJtEPs9sZ5sn/Kq406vnG57Tiehsd89CvO7kENnNMDp4AZqZTkNUDdo/W3w07SXHJ6X5C/3DM
	KdcpfGWOqwgEoBKP47cqnQHAmrG6cUpV7HYTPrRT1lD5/WVojt4Lu8sSDuje1tZCLEA7bHg==
X-Received: by 2002:a17:906:9c93:b0:c50:5186:a428 with SMTP id
 a640c23a62f3a-c50963b3380mr372754466b.27.1794606425739; Fri, 13 Nov 2026
 13:47:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com> <0cff8050-24ef-47ff-b107-70a5acdea631@kernel.org>
In-Reply-To: <0cff8050-24ef-47ff-b107-70a5acdea631@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 14 Nov 2026 05:46:29 +0800
X-Gm-Features: AclHuK_GcWwYOTlOcpKzfkqKUnw8cGanu3KfVChnEYhbBRBs1s-nvvOrFv0vtzA
Message-ID: <CAMgjq7BcmSN=0cLAzrpPatjWP_iyD+FgAMcvVcCpebStWYprGw@mail.gmail.com>
Subject: Re: [PATCH RFC 0/8] mm/huge_memory: clean up and speed up large folio splitting
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7BAC31C000C
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 5dz3r8dtq5d6rpfjf3ofbp9ndt1xsrme
X-HE-Tag: 1794606427-586135
X-HE-Meta: U2FsdGVkX1/mvU4gcz/TaNYnhpT/fRDPSwHSfQd0gS8q3MIP6KmOSQ36tvc6QUamwjTj7Y7RZDkSRb78zmmB9oEggTvpcgL5EsiJGJgQmJZoQXEPmlV+gV/91X6KYsiGNAn+b4zmpu1pxsS1H+UxuyJA/YqdShQGJdgt2IREVQwQZgYhLUs5S67fTFSG7iEC6BzfK3RPr88knQEWFDFOTYs/zhJnulpHG6cE6F4oPNv28emp+9yiZS2rCPyEEDvWWTd3HMyqp+fLNFL2OJURWa3HUT0qesl0NKeXl4QHsYN2JUpa2Y9RbPu2pd+NY50jR9n2udsNLsyZLBcxvVBTXk6rsq0VLIPIgJOCHCOUz8PN7UP/d4Xnp7kYr2Y8DK5YgmDsPOCzVjXizGx/j6ivCuZdMNUw8pECiJH9TDzAg0ILOsARsgsGJMIFvkCRyjRlhPtCOTVFyrbT5TG265cWj/XJS90od/d2Xa5SSSyM+XzwaTj4wI0FEHFkZlu28TQwiD9RObEUNJRdsDtLPhrn/sY8YB+9a/6WernyPFTZC5IVeUkuT8zZ+GhwCV0XZ0qYDQoygzP8iDfh42I+cykcMoV2JGFLD1FZ4ZnrxXBfruOWkKP+wnYv1HRPbYiPE0oh54mwnkNzdpOhpZhVMZMxLLDPcwLfN1kgmaI8JT1qTDjSR+Ag7Zcqqa9FaKeUC8mAydzJ9y2L3GujVMUsb/FihyEp7pvVrwN+AmmpXIVdiqusuUqlRP4A/57W+rurX4enicaQWkQNqqpRBjSR3AJ0Wh0ETsEIsj1CXE3tWcLq1r7D/0l8ggOWIxSqAQKQEAn05W9nD5vGGe9Kpol0+lbDPRTGW80C9EayH1Pz1LnekvlPKKQ0h5xGa82QoEbwBImckc+ML1lxlW7L2yNcgsFYp0913T3ry4wgRnhZzRrRKoiwP6rCROnOdcW6anqQugr3MAdFwIVvkOsYMGr/nBb
 3ekv2ZTg
 LxF1mXA3Hc/Yvs8xIe9ZqAa2QgS25WIjszw1+ePyeNROG3XL4bp8HiYvlvMLEw/TvogpS2F46lQuUD8fl+qbPTtA0iaXtmTvTLhG/fR6FZ4kM6FFKgJAU4iIuWOVfAr1Xzs0ikUTq8/OHMj+Ir0nPx02rHi3n7sVtnwZWgZS3XkNg4VoBH8JM9y4qCjwjjDNbTaUKu3pE4AqNafpxewlkjwpO81Ny2wOJFlnQLrxGnFEehtCnu8PJledMaOFjVQdafGrASWK5yBjgNiu/JI9okJ796NID9BdcosRFdDLdS0kBjZRk0SnaQg8aZGTwLLQj/rrj3axpcFFLh3mw0bwjSLPyGzGxTnkbMiBAMn7Jvkj8Z6bpxFaRdjSqLpJ7A2SPX4u9KJxDEbqaKaecyFdSkpSEvwSCqxNfhkUVj8iemfvwoolZVbC2ZcYddUAqN1H7J9DSgdVNTmfFj8dGw6+hYG9ppWIM/lNvCjZRZh513ijFcyqtXHl6RPWTAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 5:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/13/26 22:26, Kairui Song via B4 Relay wrote:
> > Hi all,
> >
> > This series slghtly cleans up the large folio split path and reduces
> > its overhead: uniformly splitting PMD sized file folios to order 0
> > is over 20% faster.
>
> I expect (well, and I have) some fixes in that area, so we better hold th=
is off
> for the next week.

Yeah, that is totally understandable. I mainly wanted to gather
feedback on the two xarray / folio helpers at the moment, in case
anyone has concerns about that approach. I can also help review or
test the upcoming fixes.

