Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 681E9F31E5E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24036B0093; Thu,  9 Apr 2026 12:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC246B0095; Thu,  9 Apr 2026 12:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11B96B0098; Thu,  9 Apr 2026 12:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B03BF6B0093
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:17:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 354DDBB955
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:17:48 +0000 (UTC)
X-FDA: 84639523416.20.BBB16AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id A977040018
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:17:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VMYVwiks;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775751465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5xb2RET3ZHjMSQSsb7HWH90tD/uXVXf03fHQr8W4g0=;
	b=pA722Ich94JDCpjT5gsQhuzBKYDfL2W1u5L2SmK7mzXmB0X7SOCn96mc/KG/V3rnGhH9Bg
	Bi0gx/+CE8JgpigijR7kB1QuQgUdF/fyh5l80U7VeLHKjojZvYKBjKrwW5rDYNQ0aWT6w1
	k/kwSk6gLw2HH5I5rXsaYILJRR04wKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775751465; a=rsa-sha256;
	cv=none;
	b=O4XWlc9Jt8qMRnc39Q+/cd2ZDDSyiuvjVnYVwEzshWxugsAdV9CjTXlRucR5dsqpo4PDVV
	el/Uru/Aw3LM6it3/Qmg81kxKtvO32WRL5JIFtQXV7MF3ghtbiFwZz4z2lV2NjbIboK3XA
	rmGgjhKVXtu663sEWdVfT96Z8ljn9Os=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VMYVwiks;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775751465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5xb2RET3ZHjMSQSsb7HWH90tD/uXVXf03fHQr8W4g0=;
	b=VMYVwiksx2LCQVf5Iqm61EKiKMop//f4de0PVro0vMg67hqnFriMNASKZncJjBW01icA+u
	tTQ893h0Rgt+ATnyFvb7u6vFBAyAq6hTt5mq3g/NrCaz9HFpVOPXCr/177RDBbDAgcdc03
	bntzJW8XjKucuFKTDBcFX1/qVtKsPcA=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-W-EGreCIPQ2wTMp-gGs_Dg-1; Thu, 09 Apr 2026 12:17:43 -0400
X-MC-Unique: W-EGreCIPQ2wTMp-gGs_Dg-1
X-Mimecast-MFC-AGG-ID: W-EGreCIPQ2wTMp-gGs_Dg_1775751463
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-649deef077eso1443299d50.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 09:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775751463; x=1776356263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u5xb2RET3ZHjMSQSsb7HWH90tD/uXVXf03fHQr8W4g0=;
        b=I6LiqmgveKksuZFDDZlIB6tDputKP/sA06cg5QWHpZwZLfjP5YBSSB0so2xMILKQsD
         AyPF9LT8ICO8Q3Rf0rzD/8IKwXUBMXVwHBWWjtEnGi99/wLzr5QLWN4vDb21Qsj/cu7+
         cyLsZY2su8S0JpN1WGOU41zWFcyYGq1v76NEjHq+Ss55HtFiSYKlfAMB2SZ+eQquSQU8
         9pGS2HNB7ueeMNeJaxKAzcHZX8TRpwM15/2F2kee0VeBzBfwORjSrkcvDOXXxzfZ3LmE
         a23NFT9b5/wZl6e2ArBFSH5Xj/btgypRMT2y2dAGXKq8r3wPm+WCEJcBxBhX2Fe5u8E7
         m05w==
X-Forwarded-Encrypted: i=1; AJvYcCUMhrIFdn2sLi4/m63+sf7vVUuZ7v9lKhLL3r+pZJ173uDIn8OHikv1Ft0ZXpamuan/CkorsMObUw==@kvack.org
X-Gm-Message-State: AOJu0YyQP7s8p+GS22SwRcXJ94BUkBXnGrKd8FWVdsXI41SneqZVK7h2
	d0SxwEq0lvA+o57atRw2KVlwk6g1UdXphZvlSLB5r7Cwz4HVVyAufY8CWoo5eaxYdEqIbot6nFr
	ibzMTWzlKkx5/estL/yStGwHRA3xz1NMm2TRy2WY4lTnVJoxsqOA4ILSVQqK1nv0E+erEuMEgzz
	qZvlqS+8LyifgT6Z5KOp1JmoxAl14=
X-Gm-Gg: AeBDievSrSZkTpGnnjsOdkEsVAb81kHStilVS8Yxv6UKOpSH6TIaNYhML84AXv7wGkL
	srMfd8Wz7QypEM+2DWxWn1x7lSMLqjA/LOllEoX8WAshLktlBg6VbhJ8NaEK8kGsOpF0VTHi6S9
	jKJaUTxkDM7V3vcT/+rXdNrgsMCGI9rv0vW6jKPZNU0dhexmhEdVJ4UqhNAvCdrV7j0T3B7wUUZ
	A7+OV+8
X-Received: by 2002:a05:690e:11cd:b0:64e:e0fc:a311 with SMTP id 956f58d0204a3-650488b2a89mr24106306d50.66.1775751462408;
        Thu, 09 Apr 2026 09:17:42 -0700 (PDT)
X-Received: by 2002:a05:690e:11cd:b0:64e:e0fc:a311 with SMTP id
 956f58d0204a3-650488b2a89mr24106105d50.66.1775751459745; Thu, 09 Apr 2026
 09:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260226031741.230674-1-npache@redhat.com> <20260226032347.232939-1-npache@redhat.com>
 <8a4568de-e0f9-471b-bc94-1062d4af3938@kernel.org> <ee39e605-0d9f-433b-9dfa-f70fd92edfac@kernel.org>
 <c4e80668-9018-48fc-883c-5d52a5950065@kernel.org> <CAA1CXcA8nE2PZrB4J1gV5v16PeQ7X2AiwjJ3gO1Q8hW7tyTtPQ@mail.gmail.com>
 <2e3f7c8c-c443-4e71-ad60-36c5203de09b@kernel.org>
In-Reply-To: <2e3f7c8c-c443-4e71-ad60-36c5203de09b@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Thu, 9 Apr 2026 10:17:27 -0600
X-Gm-Features: AQROBzDa3ZlDSyBeTiJ6U3kFPCzeIQ0iT24eqWDzIWH0VQcWacDEzklP5yv7TuM
Message-ID: <CAA1CXcCNLkdjMt=WXgJ1QYSn9WTgN8FVZDQk8E9P=S54sFDSDA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v15 03/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mjc1Sb8lJNUBjyDB2WEAbeP-5KRRXrZIe5PJKR22rrU_1775751463
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A977040018
X-Stat-Signature: ea8iobqh7dcxg6t4o1ty9mqogc84uazk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775751465-507466
X-HE-Meta: U2FsdGVkX18zGF9NV6PZ9Y6DXKvoolML27rnXpn3GSz4Jp7UNv0v3gtWhWnwIdUqrXIAxqNgRyrvWIPW597uo8q/HHp60MrD5CrwnDToCNL0HDA+Szpkaqq0BzkrvIyJY2xZjDyI95wYYMQ8WtMx51XB2AWYs6x3QP6le7+g7ANBMI1052X+W0C1wYwQ8M5mOD/dk9YsTwEjZ7LgjX3WTVdh7/OgRo/JGAE321FACRcrkuvpDDsBnH7RyjwzUa+KYHr0sTCsiOVs+dlCUWmEG7WPtROt6nAcNU1IopCmSA6m75LGjoRuRuq7/X2+M1Hn9y6rfEOjeWlnUJIiARNAgHzhcIDmviTHwLWoliSJCPLB/dXT9LHXHTJRHAE/UJud4spppsLxQPAonsV+YvGolB2FWbVUUTJu2nv/TIh2GS5VTwg1Wyds2EgIKiFaErZFAbOA4tiz14WrnHPB3CeoRruenX1u0FZvWIycIVX+kjbumFM+FJq+LQn8mEzMs4ditsnt0qMwyz0HXS9ptNyHZlhVf1tYiVT4MQ/6vADwumg9AEaiA83lIds/gCxj++thDCYpMSrEgeN2Oz1UZQTUVN2MDY579OUNJtq5Ua8sS0JHj1pKX9J5vsw5YkFs9C6miqcJgC5jcsjfOE3IMyQyM+j6JIVFj1UGI1tV/duuL9KpLpvgNFMTJGHoGeKLAN3tpYllC6dwiZyqYP2JmajQq8EvzJYmELZBRypMWQu/MUYH1ZXLG8mIIlCT7Jkog9+Omjv6/YZNCI0YmWjXvQhb55cWkEkxg5Wlq2fj0qDV57ZBEYls6sjj0iUmXySAjydYYli1jvLcWxpegEzOCsnAAK0r8AbhZX1fnVZvjEKkpjEFLZRewpSvNaBBlJNj08SO9Ljd/anmKu3O52oZx6RWuecNaz+RfjFHOUbb8hpmTkh4t3wEUnCDxmA7ZpkVU0I5zPLPTLvkdvThWRfFFn2
 UWRJE+S/
 g870ciM1LTmq2Ey/Cuho5Sa4luJsCVlV2rgxa6eR8JSCqAOmcd7rN6MemU+Wl6TLvi3LDJcUbbwqQkneA+km7lIejT/RiVq4cH3fXJWR6/4WtOWa6JOT6D2SxiCUfDF6q4iZU8NxQ5d1eD0Gok8EzFwchRCT/gdYtJzTOUwL/Ksh2ZEpR3LeeLFycIuhIVSyp/gONFjppGV/fJszDOWwOFCo2OMn408AsHLmVAXJBhcpGNl261C05MbkFuVFpZALs3aKbCetlGMwMIdl5fcaLkULv3fhW7RRj9bW+WRupIbUkUQcVmDLCiN2O72vmNK8MFGtfUHVENSyeFUfkpRfJVksLzrNL5AZFQgjTPQ7BjiquFMuE2uQplA/NJeUbZpoSzGLeOV+xysTHSFwgKDCZFEh9xkBcJjV9zKZaLe96/46eOK+uhTj0+/5fp4ZAyrYN4eJe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 9, 2026 at 2:14=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 4/8/26 21:48, Nico Pache wrote:
> > On Thu, Mar 12, 2026 at 2:56=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 3/12/26 21:36, David Hildenbrand (Arm) wrote:
> >>>
> >>> Okay, now I am confused. Why are you not taking care of
> >>> collapse_scan_pmd() in the same context?
> >>>
> >>> Because if you make sure that we properly check against a max_ptes_sw=
ap
> >>> similar as in the style above, we'd rule out swapin right from the st=
art?
> >>>
> >>> Also, I would expect that all other parameters in there are similarly
> >>> handled?
> >>>
> >>
> >> Okay, I think you should add the following:
> >
> > Hey! Thanks for all your reviews here.
> >
> > For multiple reasons, here is the solution I developed:
> >
> > Add a patch before the generalize __collapse.. patch that reworks the
> > max_ptes* handling and introduces the helpers (no functional changes).
>
> I assume that's roughly the patch I shared below? If so, sounds good to m=
e.

Ok cool! Yeah very similar. I was just making sure you weren't dead
set on it being squashed into the other patch.

>
> --
> Cheers,
>
> David
>


