Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9FCCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D22A6B02F7; Mon,  1 Jun 2026 05:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482AB6B02F9; Mon,  1 Jun 2026 05:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3719D6B02FA; Mon,  1 Jun 2026 05:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 230846B02F7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:39:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7AABA0602
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:39:00 +0000 (UTC)
X-FDA: 84830844840.28.D562646
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2EAAB40009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:38:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lx0BZmPM;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBoSL+QUM0yb8Hay76O4WbAqQRjHRHgW5j8JQ2SSVCI=;
	b=rumNqYrhEJGABrBjARSEUwRiB1A2luYRvBSR96XmicvW9dUY8QvmIjr0kqnRsMVfqM9i+Z
	w8cj8tzXf7QvbNKNUPI7iWlXHSVCFNnAqkc8SXVAXCzjVn+X6vf9h1rO+oReV+ZfDHcQdK
	BgLY1CfUlEWBkD+7G2DEVX8n2tiTGh8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306739; a=rsa-sha256;
	cv=none;
	b=hKQXF0S/hHb0bsWGpzpEoj0tUx88ltK8Xh07BUTUaCIpDpo0fyVtn0hWBIQD+57Gnl1xr4
	7IlWS3xNDzLUUdgAb8OBNRrjGdtD4uTWXk3dGz9kmznBXEYdy7o9PNWoygJvZtg/QWiB6o
	F2xj7hgUJgsustym4vNhHhPCUaqeWgQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lx0BZmPM;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CE4560018;
	Mon,  1 Jun 2026 09:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C416E1F00893;
	Mon,  1 Jun 2026 09:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780306738;
	bh=zBoSL+QUM0yb8Hay76O4WbAqQRjHRHgW5j8JQ2SSVCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lx0BZmPMaaJDO54lffyRhqGv+qC80Py2n7iX3siqylQfGg6qXxtsuXNpFZh27o+c6
	 Q0dAgq1Pj16AdjPnBxfBUfR9QhnHxi9G3Tg1vpimU6edULnrLRp3fHgCTDZiPH1bNc
	 W1NO0Lp1iok3LyywCKM/0Ai1BtoiZ+SHXWqgot9z4wd2F3ngWjgNI9fxPlsH+IdR5R
	 pqf/g0MmFV1XrdxKGO5ggoJiIaly2dCRbdzAqZ4LViRRfqteLflVL2jAdTTyxP8vQw
	 1jB/TU81yiWFRXT4fUxg30rpnhIPgj0TbPVpHePGctIh8Lui51hePhk6Mo5LkZ3KAo
	 yI+aO+odjPYdw==
Date: Mon, 1 Jun 2026 10:38:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] MAINTAINERS: add ABI documents for mm
Message-ID: <ah1TEcshd2wTroXb@lucifer>
References: <20260530011852.90663-1-sj@kernel.org>
 <9271c3c0-0b04-47f8-adb2-83f5f89674ad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9271c3c0-0b04-47f8-adb2-83f5f89674ad@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: kmihuedkejzwzqbnsh8zqkg93eepg365
X-Rspamd-Queue-Id: 2EAAB40009
X-Rspam-User: 
X-HE-Tag: 1780306739-304032
X-HE-Meta: U2FsdGVkX1/rM6wu/+5eX22gQdkQWOqhe7EGBAkn57fNiHzQJwpCem3zwxn/GzfHEaS46oHoeEpBluB1Wm54qoD9YaTIeOAvdXyyP8hTf7ibbxyVbqv8XR1g3YG6B/9Pfe4MR+wsGAcWR8pXm3LhSHYggRFmDEoCULpTpb2IpPe1ZWLK4XoD/acSPGK8UOegNSX6Gme2byRq7elMjixH0KzQzMjkZsgduWh1WdpROhDImR4ooQTF643yVXliZ8krTmpKfSnWSr0c+ym9pVjmrVU45tzJkUol6RUsyEn93VZiNA68GsjY9P//FpgstH0DOZbpfU48sMe9+Xu2Qs0mSf83B5FOB4z2Fy9gOCuh56JQdbiJ47Qeq07LPplwqH3sk+hjVCHTSbbob9zq6mhTIaAirzCI9b11259N9+7zXGqNtPVy67fudjjFa0S2HcOtkjOLZzY3hRowZ4cwD33jre6hvL7vcQssXfA64W65lCeQtX4zNZH95NsbnDUNRziUB8qD41wJEI4FawKkcuupkiWH/vdRRotcHnR1ej2XDo8zY1B+AFbgcKmsIfwedMjDzlGPe9wQkjkdhfBpIfSRGfM1Hqk9xK93Q1NAY9oJHFcCc+m22p9wJdL6gSpboP/vXSFmKTOiK1cshDElwHCbBJ+xzua9dupigKzeCFWzAnjOodgT4CIQmX3L8B+zqisG/ECvgbb1wYYoFOJ3aWcjSgBcm0A6gQkL5zSqKWETN2EF/zIkndKdZ/hhKzeL1WLRVT1tLkLJW5YfejLCj8r4lycVfEEiELnOfY5tutbIQ4tjRtDPHCQU/lRRQipOlmzZ/dRdng/HdRc6TQKPeBSHJWxwxJjSa7FrV26K5Y3pH8WbeSTuTigCpgo5Mq7tDbH88R+MJnSO3MusBxbOKtLComGUkZC9/fAhobK56xeIG6SPYw5nnzdMLx+4UHufjaPSYRNVejkMkUKK18xy/Vs
 35Khk+yq
 wJlkMoeI4Cxl9csVD95Lpr4QwJjfyaJBZMBO4JIDP3yE1bV6ZwSgpLmuhqwa2/EH8NFvo+Ok59jcLkVzYrlVLxr6CW85gd3QFkmGn/NnU+iXUMB+yQjbcar1qiPW1Y5H0h5KmTvKCdY/dP/qrT2ktUvazEcRhz+fyZEvAn/mLDMZim+PEcbHEzMkOH7mBj/z5GqhHTiyXUyI8hkOXdQ21I+gLo5PPIL6Vd6MblsIvXU8AvusU4L46lF3RVhsHF82xaNNs4tDzx7YRxaGXfcpz24KW8ckygu5DbJ9gGIzEjb/XMbfRiS94RFUBRwnvsu8crZtq8s3yW4typB3RSJdHcN0jEFDo52ZiBcu0rmWGYccUgWXn9Hro//GDkdeXmnM66k2SlW3CpQezpjmHBzCR/eQuFghUg0ZqjZmR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 09:19:29PM +0200, David Hildenbrand (Arm) wrote:
> On 5/30/26 03:18, SeongJae Park wrote:
> > A few mm subsystem entries in MAINTAINERS are missing their ABI
> > documents.  Add those.
>
> Maybe spell out "testing ABI" in here + subject, because I was concerned there
> for a second :)
>
> >
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> > 1. I found no better place for mm, mm-cma, mm-memory-tiers, and mm-numa,
> >    so put those on the 'MM - MISC' section.  This is an RFC mainly
> >    because I want to know if it concerns someone.
> >
> >  MAINTAINERS | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e119182a8911d..a31f6f207afd8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16854,6 +16854,7 @@ L:	linux-mm@kvack.org
> >  S:	Maintained
> >  W:	http://www.linux-mm.org
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
>
> Makes sense.
>
> >  F:	Documentation/admin-guide/mm/ksm.rst
> >  F:	Documentation/mm/ksm.rst
> >  F:	include/linux/ksm.h
> > @@ -16876,6 +16877,8 @@ L:	linux-mm@kvack.org
> >  S:	Maintained
> >  W:	http://www.linux-mm.org
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
>
> Makes sense.
>
> >  F:	include/linux/mempolicy.h
> >  F:	include/uapi/linux/mempolicy.h
> >  F:	include/linux/migrate.h
> > @@ -16918,6 +16921,10 @@ L:	linux-mm@kvack.org
> >  S:	Maintained
> >  W:	http://www.linux-mm.org
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm
>
> Maybe that one should go to CORE? But MISC works for me as well.
>
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
>
> Given that CMA is here, sounds about right.
>
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>
> Given that memory tiering stuff is in here, makes sense I guess.
>
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
>
> That's all about page demotion for vmscan ... but again, also belongs to memory
> tiering. So makes sense.
>
> >  F:	Documentation/admin-guide/mm/
> >  F:	Documentation/mm/
> >  F:	include/linux/cma.h
> > @@ -17041,6 +17048,7 @@ R:	Barry Song <baohua@kernel.org>
> >  R:	Youngjun Park <youngjun.park@lge.com>
> >  L:	linux-mm@kvack.org
> >  S:	Maintained
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
> >  F:	Documentation/mm/swap-table.rst
> >  F:	include/linux/swap.h
> >  F:	include/linux/swapfile.h
> > @@ -17068,6 +17076,7 @@ L:	linux-mm@kvack.org
> >  S:	Maintained
> >  W:	http://www.linux-mm.org
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
> >  F:	Documentation/admin-guide/mm/transhuge.rst
> >  F:	include/linux/huge_mm.h
> >  F:	include/linux/khugepaged.h
>
> All LGTM.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Also LGTM from my side - thanks for doing this SJ! :) So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

