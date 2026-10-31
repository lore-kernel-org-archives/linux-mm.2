Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A86F606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 16:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=maf51kOi
Received: by kanga.kvack.org (Postfix)
	id 57B3F6B00EF; Sat, 31 Oct 2026 12:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BA76B05B1; Sat, 31 Oct 2026 12:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4419D6B05B2; Sat, 31 Oct 2026 12:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 219356B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:42:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91B41409D5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:42:57 +0000 (UTC)
X-FDA: 85383490794.01.58618B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C328A40009
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:42:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=maf51kOi;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793464976;
	b=MQbxYFJ0GY7y/QZ2LaiFcvjs1c4q6mt89z+99ConeQeExmm21jSd5Kiy0mE/EyiNoEAcby
	QtGxiJ1/5NwSR8rG0WvBnlWJCu2jPGDR5bAYRSWVjbzQ4tIzncL/iB6RW4pU4pbhCgXAAD
	DHljVt5kQmYjbDg1+2ON52toQLvWhaE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=maf51kOi;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793464976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J41Y1S2rh3yGXRCAhNBommWpMFq+IhDlxy5NAe+nz38=;
	b=uXRQ5oSu2MeZ4I2jiTXwgi4hLXYFeIrgNpkuHMX4xER9k/oFhva+D4/c+nsYafxwKZ//64
	kI+lh6b4tOHSAJXAQUvbbDR6+VVN5jqWgqi7gxktNKPSrFITQhq6jVABCQOwo1JckhISXB
	1CeYsIXqWffTS8TQxBMtRvrfjx8GqyM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E03A742E47;
	Sat, 31 Oct 2026 16:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6831F000C1;
	Sat, 31 Oct 2026 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793464974;
	bh=J41Y1S2rh3yGXRCAhNBommWpMFq+IhDlxy5NAe+nz38=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=maf51kOi2GfeExT2mteFp7wbRm1Pbs4NPJ8LE3EJWN7TJAxJ+lFNA8GrTaJtq2Ssf
	 BOvgg2MqoNiY2Lxsx0H23hLjEqLlDS6PB328E6JD3yfPOJYCuZISy3EUG6x1BN4b11
	 alPh9jtkf+21MD4RjaM/0HgJ4mZ1YCQxzeKaFHCo=
Date: Sat, 31 Oct 2026 09:42:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Qi Xi <xiqi5703@163.com>, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Qiliang Yuan <odys.yuan@gmail.com>,
 linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 sunnanyong@huawei.com, xiqi2@huawei.com
Subject: Re: [PATCH] mm/migrate: fix softlockup in do_pages_stat() with huge
 page arrays
Message-Id: <20261031094253.d28f484e7e27de469cfa76d2@linux-foundation.org>
In-Reply-To: <76579248-64db-47bf-b8d0-4eb3ca556f5a@kernel.org>
References: <20261031033330.3416326-1-xiqi5703@163.com>
	<76579248-64db-47bf-b8d0-4eb3ca556f5a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ssjk8wyodg8k7da9u55iacufd56php7u
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C328A40009
X-Rspam-User: 
X-HE-Tag: 1793464975-418711
X-HE-Meta: U2FsdGVkX1+Pl6LBJ5wnB7d7XlHrAxuQc2wSA/6CapjpX9Ib0HFGaT6eH7bRTiKmgartkkk4mX5086StBB+2D51gatTO7YIKNc6Kf8SbmDJGCCPta/bgD+E5pqiTAGVERx8ENxRYj/KJLn7qd7mUhAH9Ip8/BibTjCDqfdY1+42KTkndnlbL4/nDDL4tQdjedHvday1Xqn51AUNvEKk+jc/diFJ+R09Q0oTd8yJoQQiBTWLWjP2HUV4uynNGVJoci6MgKLl3yE/NMnddXb+aJbOPNF0V0/S4kCmWQo1Lh48l3ESt8c0JX5MZGM+YOe1WtkGDzO9BtVndZkoutt0Jb7EFZKgEa+7h1gDYSVQgTwJp4319W3jCXUGUUQwPIfsGpXVJ2yDUAY9utv2UL9OpRqFKMILwHTk5oV/6MKMjzkkPjxfXU6rbbq816+ORdwpcsot/Q/9rMz01Cjp9AuGGeWUc1MP04MoWHKl9tWdoTWNobJPaK6pRQlTD8HQA7gSqlP5P6pRcwkDYRZJU3zmyc0Kw6wFG9PaiYLYEcFV8qIdIzD8BFOCv9rD7zQts3jiqdv6fUYfVkqrIltvvNPEWLuJb0qP9jRu8R0hC3v2RmMJU0hPRWjmSb6Bn4hXjgJDGF4jVDhVyUXTC4JGzZPhnTUL+g1drKYSNU3TBzkXZQbrmNn8rs5ParDG4DwKNMs57+WvxQZN/T86fME4Ow9+M59tmzTMW7L8SctH+UjVD3UGZJT+vE69HtLGdZCTpItHfc5UhNZGQa/TAjc3pKN/Jk4ptTbYgc5CLB3PSzqjAvZsi3+ofZZfGXuq0dfHMYQEms+hSHebZg5TyzyNM3BYslP3+AAlzFCiGmntC6cUYP+gv5q4CWegpdDiprWID1ydjFbl5EL7C8gQrLRIUDSC8Fuhi0tSvvdgasQB3eE+pgulJgfDxmMqnudWtxLx1frYlOdBzxgDnRhqtGEEWJkd
 pSWod7wW
 45Ql8AfJyQ7Fp/8GhQuHvVCPjo5v9htwRlTX8hNvO1V6J0NwUSUhpeb4/H5rHAOXPYcN1Rx9sYtIJXsex1u4tDoFEf3CntsuIGRKYNdXyE42NMmwPbrGobgymVfB8w27gdieAY4Q2Ohh776HEZ6MFjSiv7hJ57tmvd9i29jF2SJfXzi49wLE+wu51/ZwEvf+ma+9TtHN45ayFWbBYJmnXpkfsnRfYaljGglbJlfGz/2FTwhHlkpp3xPT7BTWUBFJAVZ+vIH1wpmoxcR9XcrJ/RUdQ9yaPkhr1aPJfif7RATfZVyMS6egtDNu7jgpJUQE9/Xe2lKftQUxEkEHJGuP7zQfaIXhLNyOmKoF4y/BafDL9bcj+7GJw57bQR6q13rWzr3uzhnGBx/5DLVwQqUIB4bJOGfyL7p82aD1TGxkPSm/GM+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 11:52:30 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 10/31/26 04:33, Qi Xi wrote:
> > From: Qi Xi <xiqi2@huawei.com>
> > 
> > do_pages_stat() walks the user page array in 16-page chunks but never
> > reschedules, so a huge nr_pages can hold a CPU past the watchdog
> > threshold on non-preemptible kernels. Add cond_resched() to the loop so
> > long move_pages() node-query calls yield periodically.
> > 
> > With KASAN and function tracing enabled, a move_pages() node query
> > (nodes == NULL) over 10 million page entries (~40GB) can trigger the
> > softlockup on a PREEMPT_NONE kernel.
> > 
> > Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
> > Signed-off-by: Qi Xi <xiqi2@huawei.com>
> > ---
> >  mm/migrate.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 7bdcdb57652f..6c2371020cc5 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -2545,6 +2545,7 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
> >  
> >  		chunk_offset += chunk_nr;
> >  		nr_pages -= chunk_nr;
> > +		cond_resched();
> >  	}
> >  	return nr_pages ? -EFAULT : 0;
> >  }
> 
> I though we wanted to stop throwing in cond_resched() at this point?

It's almost unneeded in current mainline kernels.  PREEMPT_NONE can
still be selected by

	All supported Alpha configurations

	All supported Hexagon configurations

	Non-ColdFire configurations (classic m68k)

However 99% of the world are on 5.x and 6.x kernels and many of those
machines use PREEMPT_NONE.


IOW, cond_resched() is not really needed in mainline, needed in
-stable.


I think simply merging the thing with cc:stable is the simplest and
most reliable way of getting those older kernels fixed up.  mm/ already
has >200 cond_resched/need_resched so a few more won't matter.

Presumably the day will come when we remove all those scheduling
points, after which people will have to work directly with the -stable
maintainers to get these things fixed up.

