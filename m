Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE5CCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 09:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DB08E0047; Wed, 29 Oct 2025 05:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05868E0045; Wed, 29 Oct 2025 05:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CA38E0047; Wed, 29 Oct 2025 05:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 805EE8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 05:12:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FC3988F08
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:12:55 +0000 (UTC)
X-FDA: 84050587110.24.FD27199
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 59A708000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:12:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0pswya5+;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761729173; a=rsa-sha256;
	cv=none;
	b=XoPkpbNrB2Yn78Rio1zTaSOAy+QgKYsn+rCYTfEOjnqOqcWAOr+6BdZECZ4ZBANQB5rB9x
	19+DCL/8q35XCJN2Rmbh5aKl85yBUKBepUMSTQ660/Hi1NX/GUY54DAdjKEcfqORZ/jBFl
	lPoI8a6/V+kddwdLxwj6h/p+ht5/F8Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0pswya5+;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761729173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBqHz8cFPV9OUQwbjare8Pel7U5XHqHAeYtuall28CQ=;
	b=nOp+bHtJ7nEt5LxWZrTD4Nqp2Q2U3o+fjSlgqHmrdzffl1Uqaalq7qj2CF4jEycdvwGFG4
	4FvVGC/GdndpZoQbbWqr9dG1I8qW16LhOrioyImGYzvE+Z94gDvQ7Sw02Dnx0SrUJSehOU
	VndiQTik6yRRFoJxQoCfDQsoNnrne/0=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63f533fbfd0so3346698d50.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761729172; x=1762333972; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BBqHz8cFPV9OUQwbjare8Pel7U5XHqHAeYtuall28CQ=;
        b=0pswya5+mMNkqnrednw1eCFiMcUwz0IZdD6MrZXU9qpWZWbnaNMK7phSRRpAKuYOkM
         wgM6Z3HFrM/+IZhmifp6WIJYPZ/tWFOeDsKEtcKqzQfTKLPLP/md4d5+PPw962zqGmyi
         AMJXV6VpyevJUQJtOwUroqlu0gl236bWUnNCiACTmbI3zvd4f11pXY3pQKqX6YaNgeKW
         yKqhocKMF+umnXYRpv2JUTzZYci9XboYJ3OOYIE8joqaXNGsFZP6ysWRDpcUsYqw+t9w
         R6bFASn2/yzZ08GzM+NhfzrDDmJeE0/S53cnsXPi2Ect6UrFH0Mf7M10A5I3lwHjA1VW
         KFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761729172; x=1762333972;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BBqHz8cFPV9OUQwbjare8Pel7U5XHqHAeYtuall28CQ=;
        b=fwkUF+uHqvyddvFWV1sI11/FZF+CXdo+052GI8hnkn3ZrXAfM+FJw9CP1QF5G7dIqY
         M8BD4i4zyCm3C4xjXVXrRdio2rvxd0wGjYa99r9jf/4hF6ZOa8NNJ5ffCWmWZe9r76Gi
         Hhw3bxWc56EXaGwMy0UW6fs6gromNtHFyDryI57d3IaAWq5Wgs1g8yJl1DVAm4X3Hy9N
         RGEBrZ0MCUoh68pEpZIKVPs3LSH1Y3mOnQUNydkPfToBJn+7SKrdIE+pln+xneMZQz1x
         XMuugl21v8+oGwugdkFBgwJtKTYI243vfcjpP0tv2GTSBPBGHqg2H3H0elYW7f07IT6O
         Q5zg==
X-Forwarded-Encrypted: i=1; AJvYcCWCFTOASQ2w/bIXcLp6wUhrI79UXsxRKLraCqNTWUErR1sgAsaHKLmNWYNlhbgJ1Vn9biX3/XZwpw==@kvack.org
X-Gm-Message-State: AOJu0YyM/glhyP75TVCJi+RocpAj30p/4CF0BtFGv6sji3yx7l/7Qi6T
	2sTqG5WPkNKZ5vLuy6wn8GCvS7ETCE7jCgwWlqTba0j46dB0Kubxb2a2A0Mq/9hnFQ==
X-Gm-Gg: ASbGncsnVLQVjBxTalKNmkZwaWNRA2TUloFnjIYQ8x+O/TqJynW4Ob6y2SS6VY61ERT
	YR0PAOUA6H2Vu8PApdTIRP+vMX1dGuKQOigLSuxL7LowZxPZZS+/lwuFdjbsEdcPgtMkF8kn2Z0
	ZSmw7ZMbK3Scn0NZkUVlhVtU5o2ejr1WWbeXLU6lnf3GMc6Xy65Ha4QNS+Bxm/1+iqDGnKrrhLf
	m9ujsZXQuCm2HgIDTLbpPuJdQ6pGJpHKmqG1g9RgbJBgGM0tLdXEu8jnrkOWNssA969z90oq+a8
	eFa5Gj7UBozqgY1rIvY+hvto9is7POESCjG6qp3GfeApxOm18ETNv7OEC4PgKSEyRm7BUp9SEFo
	oKHkOURCrEJcRGjByCcw817E43lISs5DJhxyRtRNBZpn/ZKZCIR6vt6oWnuT6vnBr1OhoIMvxja
	zHolJWOfUgtrOePzhFbWkL0ZqfDyxMYwuQKx86p30j+T7qqcwqMAGyG+vvVUGX
X-Google-Smtp-Source: AGHT+IEUyMs7bw/KHzPZ51AbmO3wPAApjy9icdxMigxwWyr9bCi7kzw4YLn0xUhUa4b2Nc69MgGvKQ==
X-Received: by 2002:a53:cdcc:0:b0:63e:187b:f383 with SMTP id 956f58d0204a3-63f76dced0dmr1569801d50.52.1761729172087;
        Wed, 29 Oct 2025 02:12:52 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785ed198ef9sm34560117b3.24.2025.10.29.02.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 02:12:51 -0700 (PDT)
Date: Wed, 29 Oct 2025 02:12:48 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
    linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
In-Reply-To: <qte6322kbhn3xydiukyitgn73lbepaqlhqq43mdwhyycgdeuho@5b6wty5mcclt>
Message-ID: <eaa8023f-f3e1-239d-a020-52f50df873e7@google.com>
References: <20251023093251.54146-1-kirill@shutemov.name> <20251023093251.54146-3-kirill@shutemov.name> <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com> <qte6322kbhn3xydiukyitgn73lbepaqlhqq43mdwhyycgdeuho@5b6wty5mcclt>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: nq1ccg3z9tt1a6ffxfua87hpm6b6x4bf
X-Rspamd-Queue-Id: 59A708000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761729173-894959
X-HE-Meta: U2FsdGVkX19xI//V+Izc61UBDTYVNkJmpcEp5vlFXjEdEactIBw7S4F6Zit9+mGbmRolYSe8sthiePC5eVhvNQHrpaMIfKu98fi3xh65e+82S8SjPe2TWCBTeCOJe/yxqQ2/Z3tPDGHjBSEat8lkNwRosM/w5tolO6fN7PGvfuD0Fjj7UqHV06tgiyvMidNIIKaQgrIACcf3SQgWahJN9S8uOOI29I4k1ua0pgrvE6fuAfwU19OSqBNZInDvRj5XJISFGtOYZBiBLOLFtov0khqh0uvpJzuD2B2q2yLaudKLAgARlVb9DL64ZapEMJDpWx/P4WjFp3arI96QvTFwqyRTWJZA/o7218ht7mo9ixvlF5BHp46VkOPc9ikGHkEQEHyFYXkV4rPxGLhSupPElLkklTPPPezo9GZa1j/dHWBgXVSvq6lI7XwLT7FOE/drzJKLD9EEHwODXOErCZJWJ4KLu9mKT2+z1+wBQ8VeL6ALXdrjhgs0xUbJKySs43dNncLDkNTciKaDhfUhmPsSxfP3a/8Vy8wAmF+tFIzMd9usHkwWIfhfCynjuxcYEfqregku5FieaZxNIA6RFtwrTRIs5lBnC4Ljj7O3DuPcvKY2EAwEMIt7sqZm4MCesyADMpoJpN6DWR4LZDvfq1M1QKFXeDx4rdivmfrbVOsGdK5Z0ldkwPgKH+/hZBtSDeqh1N+haWjDF7J3jnXp5EakULFuOsAoxHBN54XGahmOsDhSQq1NjUeBLXjkS96z8HHgTVU3Y+aWqtcqkQgVrklzqU90Q4+pcdhfDUsUelJFhQvxvy7hjtwH/tOHB1XX+72H4VirklRRhaEEJ0eU7bhMW8Pg5oswkT4NzjzSRd2yAsToiTE+51Hnx82HQ8QSOUxa8DvqGNOO6L38G0ftfggWGWD24cvJnDLyn3qaBWsv2qBiAY3Ms3NEUF4s5e01m1PjNfcRD2I/ERGaY9KzLcT
 yqmDGYcR
 T55PSLleobDMnuWK+xNJDLC4lUO7ar4/fO6YJ8rnUG0JPAS/LdJlEk20Fx8nH2I2tN39ChibweomX91sL9M9dL+/zM3yunVO7d48eKeYJWTLEqWnE+Q51hDlAFvQHUR2gsD4MmupQp/EzP1kq6Skc9ol5TT69MY9eqNu6ArRBAnFV1cy0ZOzivoRPMPpuRSgxbrS30/xrFVG7yDaQzjptGwtfe5cmp57Jzz+Ud39ckeli5RO3HamFzWiYfWgFX/YygHQ7DFLEK09CC2t3ZwRn83bq0N/wUTWbRceyp7oKqdvAv7jaCF8SZ3Nl3RkhocLk/nV2NnKMI1DF5Gpcy+1FxExbP6cIMxiQeisGdkLWGNBStL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025, Kiryl Shutsemau wrote:
> On Mon, Oct 27, 2025 at 03:10:29AM -0700, Hugh Dickins wrote:
...
> 
> > Aside from shmem/tmpfs, it does seem to me that this patch is
> > doing more work than it needs to (but how many lines of source
> > do we want to add to avoid doing work in the failed split case?):
> > 
> > The intent is to enable SIGBUS beyond EOF: but the changes are
> > being applied unnecessarily to hole-punch in addition to truncation.
> 
> I am not sure much it should apply to hole-punch. Filesystem folks talk
> about writing to a folio beyond round_up(i_size, PAGE_SIZE) being
> problematic for correctness. I have no clue if the same applies to
> writing to hole-punched parts of the folio.
> 
> Dave, any comments?
> 
> Hm. But if it is problematic it has be caught on fault. We don't do
> this. It will be silently mapped.

There are strict rules about what happens beyond i_size, hence this
patch.  But hole-punch has no persistent "i_size" to define it, and
silently remapping in a fresh zeroed page is the correct behaviour.

So the patch is making more work than is needed for hole-punch.

But I am thinking there of the view from above, from userspace.
If I think of the view from below, from the filesystem, then I'm
not at all sure how a filesystem is expected to deal with a failed
folio_split - and that goes beyond this patch, and therefore I
don't think it should concern you in this patch.

If a filesystem is asked to punch a hole, but mm cannot split the
folio which covers that hole, then page cache and filesystem are
left out of synch?  And if filesystem thinks one block has been
freed, and it's the last block in that filesystem, and it's then
given out to someone else, then our unsplit folio hides an ENOSPC?

Maybe this has all been well thought out, and each large folio
filesystem deals with it appropriately somehow; but I wouldn't
know, since a tmpfs is simply backed by its page cache.

Hugh

