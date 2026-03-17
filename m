Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5C4F33805
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 06:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BEC6B0005; Tue, 17 Mar 2026 02:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECD16B0088; Tue, 17 Mar 2026 02:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02A76B0089; Tue, 17 Mar 2026 02:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A97E56B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:51:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E86E8BA81
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:51:54 +0000 (UTC)
X-FDA: 84554634948.15.A8C3C72
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D75A160004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:51:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z64OCw/i";
	spf=pass (imf08.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773730312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TL/fWTjraSCjuZfGO3tSrGYlWQVfbLF6OpcjEIyvfWw=;
	b=IrIvvxbYMaGI3FAQsS0KNEDAKuRbEzeaWd+AJUp1MNQo5Ec7xzce127rSEngblNQ2fxeI3
	vuc3TaGjQXB2Z+G0wgqM+dCYnujqp0zdFyK8Ds93KQRn/kiWoPlxwE0aNu5plTNdQRTCQl
	+GDRzb7MieYhnZuNgVknlKyKuB91ZVs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z64OCw/i";
	spf=pass (imf08.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773730312; a=rsa-sha256;
	cv=none;
	b=uUDwzYARRcTtrCOnuRWQ0D7HNC3yoTP/jkwuV33gQy8AvvvwuSw+MD/icSk2vO6ksPIEhy
	owO0+177BYqrlP3uNVeQhAFukO6R8PgYnpOv38YnesD5spL6NwX8ZblBBr2PkaEM3wKMnI
	mEZ7U/tCe0cGDF2I/R66NjlsyDkp6bg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773730311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TL/fWTjraSCjuZfGO3tSrGYlWQVfbLF6OpcjEIyvfWw=;
	b=Z64OCw/izRGuy6iMGmbpm3+nlfv0UXs7rgpzQvJXfJ42hByTKw1ybMPMZZUnzNQOe6q4KD
	uBGEH+xTrlUqmaeR0QW7kL1+80/lOw2fHbaBOLIyo1JLUGbtGipux+ScNZhCczsMCaPGW5
	02CVCVdVvDR6hQOIyIsa4A8kppc4uBo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-ZAKWPj5aPtqNY99GEXHHvA-1; Tue,
 17 Mar 2026 02:51:47 -0400
X-MC-Unique: ZAKWPj5aPtqNY99GEXHHvA-1
X-Mimecast-MFC-AGG-ID: ZAKWPj5aPtqNY99GEXHHvA_1773730304
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84CF01956062;
	Tue, 17 Mar 2026 06:51:43 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.28])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79B383000223;
	Tue, 17 Mar 2026 06:51:33 +0000 (UTC)
Date: Tue, 17 Mar 2026 14:51:28 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v2 1/5] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
Message-ID: <abj58FQF31aaIMM-@gmail.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-2-chuhu@redhat.com>
 <abegwBHT_2nlmWKM@kernel.org>
MIME-Version: 1.0
In-Reply-To: <abegwBHT_2nlmWKM@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Y7fwgM78IVqGC-po41usCSSdnQb0IiPEdMSymfg38fI_1773730304
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D75A160004
X-Stat-Signature: 9dwgx35jo36d9rnjsgoprqx3dcxy9ymj
X-Rspam-User: 
X-HE-Tag: 1773730312-981138
X-HE-Meta: U2FsdGVkX1/dSOt4+/w1iSJXxO1+bKYRJtd9EYccdJcSAixxPONlbCD4TdCEI1mMlOF/DdS0GUl31kEvfgFJtmUfvz9rF8762bsVInjjqDmp9Bb6tDZq+1AHVDvftr5+fNRDO+Wmy/LPPK41Sm8Y8HvJgYLwwns7LxRnrwD7ajbN7vVc32O+I1mTxfWr24o02r8I73PvWWUAliWll+Ry6A0rvuueQOiDyLa67yb+HYJL6Df0cHfcHNSaCexh5/E6i1t+rkgR4+ezwYNY3KgdKQ8iZJ/gIHWQ2GYmroTti4+sFxBKCxHuWIJO9qAKXs1br+YiYRq94pnSLpkOofVkVaEdwgIV/RJCFcfwn3VGq2gqVVapSwrhJIp+cWw0GdAU8FHNw2Ii9IMzpfht9nK12Bj9byt1jqmEP6UqFo1We0cypXfdO+qaSxibmfvtEJJQY1qdNKIuBoFc8DpBsiWIYM1cQ3NvzSRQwrN/rb5r++0mwaJXFoDUysTVSaP6T/Q/ETeGmpRYzFAPvMs3V9mZCHdFXCV3vFvhYOfRBrCt8uVI0pGWe/1XdaFNSUSk5hV05opbhlXd2keSUWEuqx9fMGul5FaRq6zM+Kqj5px1CIHcV7LrFXA60Rq15j+A4Gy5Zp7f20gGTcFUO0ek6QU4hDZmd0QgeGh2Z+ZhaEi0Iq5laL/UGVkqgkOVoU3H71dd+1uhIcTmPdjoqofgm62VEob7tmoGMtoy25Kd1uBDaT+J+hc3pJNDAPiOo4AON86b7Jjtn/qoxdgti0VkQgZGOLy6Th6WPvZZ/a8PCDMKX0YsK/klYKAVyCJvXjpAlps8iscKXRa8gGD+QUO74ju5Ul6WMctSmr+nT44Jikn2+HUiod8vHG3B4hFd4bxRyiVpS49j8q0eU8xznpq3CiR/EB5TfOl1eq+/uAHo2JdG+sRI/Hnuxk+F2cnSVnxB+upVNpqtM6MHBf8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 08:18:40AM +0200, Mike Rapoport wrote:
> On Mon, Mar 16, 2026 at 12:43:31PM +0800, Chunyu Hu wrote:
> > When thp is not available, just skip the collape tests to avoid the false
> > positive.
> 
> ... to avoid the false negative

Oops, I missed this one. Will update.

> 
> > Without the change, run with a thp disabled kernel:
> >   ./run_vmtests.sh -t madv_guard
> >   <snip/>
> >   # #  RUN           guard_regions.file.multi_vma ...
> >   # #            OK  guard_regions.file.multi_vma
> >   # ok 89 guard_regions.file.multi_vma
> >   # #  RUN           guard_regions.file.basic ...
> >   # #            OK  guard_regions.file.basic
> >   # ok 90 guard_regions.file.basic
> 
> It would be useful to include output of two failing THP tests rather
> then just the output of the last two test.

Will update in next version. 

> You can also add '-n' option to run_vmtest.sh to reduce amount of leading
> #, but for that I don't feel strongly.

Good to know. Thanks.

> 
> With that updated
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> -- 
> Sincerely yours,
> Mike.
> 


