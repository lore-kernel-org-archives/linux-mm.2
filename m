Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7FBFB5180
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF946B0088; Mon,  6 Apr 2026 22:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F966B0089; Mon,  6 Apr 2026 22:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E7B6B008A; Mon,  6 Apr 2026 22:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 260706B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:31:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9B9FE1BC4
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:31:14 +0000 (UTC)
X-FDA: 84630182868.29.BFCC24D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5B312140002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:31:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aZYGtkOq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775529072; a=rsa-sha256;
	cv=none;
	b=q2jeHRLqzkv218jGjDTRdJbrhScVQjHoYUE9YqKQQ0lS0mq7Tx7uDnUNe+PIR3YHairV6C
	l+sEG3acYFAC0SGCl/FtsiuzLTLfyBPashcvp+6Q1XkURifoKixwYD+SS4xWF+ZpVpVbuF
	HBIQLRz7O8q1GavS2BqiVFNEmB3ML6o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aZYGtkOq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775529072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+relXseHSDiLD/cBAI0rxB8yeQocHqRAcYJEZB5dGtk=;
	b=YlU6+VUqBGGGbTVdsQgl8etwM42Mv8e81mEdFKviSM0NLPD9pA8vxNF7++AvjZE8814nV/
	jcAND++o/uV2iKdfn3h9LFnCanpvTUELc/LetaEOwoog2ERw6FoETt1jHkbV2U8xv28+4q
	BPzaZU/X8XMFiR4zI46Fyr7zMM36vwI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775529071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+relXseHSDiLD/cBAI0rxB8yeQocHqRAcYJEZB5dGtk=;
	b=aZYGtkOqx6MU2mPyIh8tcbZNM/Cnp2snKAi+6uosFgoFvBl+ccxbKJ/AvqS6RclkU30yMb
	2MlD29dnNE6CSy++gkFqwW7mIii0hyk7p1DtTlgEnhG7ZYo2rn0SviLXxOd9ghZbnAoK2w
	kS2Rhe6TftZus+moGZEE2nsZFETMcg0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-vL4UvNTlMV-EcNyYcno7ng-1; Mon, 06 Apr 2026 22:31:10 -0400
X-MC-Unique: vL4UvNTlMV-EcNyYcno7ng-1
X-Mimecast-MFC-AGG-ID: vL4UvNTlMV-EcNyYcno7ng_1775529069
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82ce50e6e28so3184647b3a.2
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 19:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775529069; x=1776133869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+relXseHSDiLD/cBAI0rxB8yeQocHqRAcYJEZB5dGtk=;
        b=UGchHekSGEJQV+C6OkX6dgB45legIFssUvktZURPDDx0dByT7AsFKOXu3TG9UHRmc+
         P8Nx/OncoFWF67+zkFKJRiFSXEkc4E2jRNc1yvUHW/M+8JtVW3hKHsrtgDrXRktVnoxC
         HRhon3gzM5VFY6rH+arTsQa9qujqi/zKrCL7XVncDgzXw065GZbZVFm8U8wbD5AdJJDY
         EIuXu4MsogwA8pcDa4/Ptceye5n1DI3qokt7sMt8SWHKrj7MG1EeexwA+gNJsVUvSl4c
         ae/hExr1RVSL+PvlIfumhafA06EBE3YZYu93s4c4Buh6480+noYLb2DzfO+AgdC9L2NN
         O3cQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6uocCZmb5bHETXT/IYvScdYCi15KkUn0asZ/qUlOzdonqvisz1lItjgoLP2zs8W62TUScG52k6Q==@kvack.org
X-Gm-Message-State: AOJu0Yy3VvOSypllS+gzr9LKOmwBeGWjow3gVYVzd7wlZlfQHg1Q9pJ9
	wgcpxtFGlRFqVJBCfWFh3DmS9szfp3UtZzl/JhAKM4/WRWvHiRUQaONGg8YNi73FlCHUQA0wqiu
	j3np2zSiYRGGyLnL3i+zZkBrlNb549UIKfDmrxc1AsHZ9a0gZR4gv
X-Gm-Gg: AeBDievptyMa1Dv1NgyJHGe1O/iQf+pHXPdB6l7xUOgEK/2F4kpCHxG/rWvVXoT+++J
	4DAJ63z5/Kax7kJ4uPkQ/eT+xZa2PowcGYmU+aAazu8tcnqOsppvF7a6+JbozQ0CDS+A3SasRI9
	+ua0cMSTNWM//senSkhU5i0HyN82bs2CRxLqsOjqTwaX34Wvyk4PLoic66w9+DkIh7bSUIjjPwt
	Axn5CZkJRpIE/xXArBM7b5xzJmSEGWm4TPzx9bmZBkftzCJqPebycaHh32PXIy5Wz0RIgErDdlI
	vUWCuGzCEhHn/g17HlWAZd/RqRYNPo6JinvA3nAQYw1qq9Wt5pSDWUl8jV7pPxifSlQaaQlO9J7
	Xt36vmjp6TozAw6s3Aw==
X-Received: by 2002:a05:6a00:3e19:b0:82c:d6d3:31a1 with SMTP id d2e1a72fcca58-82d0db4f938mr14513050b3a.29.1775529069363;
        Mon, 06 Apr 2026 19:31:09 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e19:b0:82c:d6d3:31a1 with SMTP id d2e1a72fcca58-82d0db4f938mr14513020b3a.29.1775529068879;
        Mon, 06 Apr 2026 19:31:08 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c72967sm15221583b3a.49.2026.04.06.19.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 19:31:08 -0700 (PDT)
Date: Tue, 7 Apr 2026 10:31:05 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, nsc@kernel.org, david@kernel.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: clean up build output and verbosity
Message-ID: <adRsadO77aF3WcWm@redhat.com>
References: <20260331094402.144131-1-liwang@redhat.com>
 <20260406193216.GA1319599@ax162>
 <20260406125133.eeb8efed993ae1faa2a9ad73@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260406125133.eeb8efed993ae1faa2a9ad73@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G-NKMhLgZLqCn2X3I3T9G401iphR-Zn1GnuihNNjbls_1775529069
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 5B312140002
X-Stat-Signature: u5nefz379puio43oancaru6izkiuyuik
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775529072-287960
X-HE-Meta: U2FsdGVkX19BmLJJNNoZgmy1Z9AtfeVPWmR2moqFYsUXFPj6lpCau3uSV1pjTZfhAVMnvQIiJ9U3hDVKUINgNWaPo8q+cDTWcBvCWXPZwMZ411WfPSz2RDdRp5Tc2g/C1Tb67f5q8CVgNXSmwvW0kQjXPv9lF791sSU7y+HoUxNIOIpz2h5cOCN1UuiS195XKilayzxOVLdnHKqVar9/bXGgO6/qmS0RV9bdbd8g7YEdbCK+8qparhjoxouuBD3GkbNR6UtcfvMyC8p203QsZDnv0jRkaZMeyMus19F90UuYCdKUZitddKSdDm6ewr8ZwWfUn81ZD44sKT3ellZvf8BQNVcp7XdfEud6VUMiYn8kF8RkRV0Fiq711i/z5jrL8buqN3INKRaDe4neBy4wrolYV2CfMSviTLaPjFlLMGBAh13GXsxkLOshqkbNxSbOl7FjaqW3Qih8WP5Ey/JRgPoIRw1G6fWZmcfnmgNKdEiYr9Viec36J9MxGq/LA1C47vxb12O1duVcrQC615JgxXZlCaM/0cOjgR/YNuInsbA6FM1pwHYEJOXw1qI/DNHW7o0kLrAaRikOxFc1t8NU3GuYPbUoxpfhYPFhK/W9o75DInKhbmuZskyvZlorIkSW8zb6gAI1Gn8SoNIXICkYNRBOzi1fSyegqFBBrY5ks9moqSANFRd8hrB82wwEUyrSq2pe9llAGAO3Av7uhd70K70XsmKCIYIJzICRXIC8aboUrE8OrjGcA7FkVycXxEvm47bXx9hzCAFLBnw0Df2NKCIPIFEsKyaDZV0qod6LJzb3wPqiQQTrpu0WmrLJRMAcbTiLUFrMx9dkaMdTRFey9sfJvKTR3wYs9baPV/Wc9UoksPDSmGPFNC+CIxNxmqgwJu8FM+MU7FbN9qqdfry0zULXFhCuZMGGveWF1QfKjxMKsA9qMy1OrJfyS64AKKL4jbyR/HA+yD9Dd+uavpI
 ptYpfhOu
 NihICVE/ebBA12oMhEfsZDYv9SWEumNo1/ad267PwsI5fuf3ogDCd5eFPxxbrmiul4gG3eocSXStVDy5hBWk6oueYkNUNfI1Wu2deCWjJvDZKAACn7kwuYAWK/d/DWO6qs0hOMBCRhdFqlsb/tVIQf/yqF3SQu+fu53aoUAyiA5qvSYjZurznmX66lQnAmL/OKWyEkCCXhlDEomRhx9qB4PdBmpo6VS6dgGaHaGp6sPlOEnVzKcrB9U0mqPQXaiHnSqkPtYWZiOkPdWu28XL+lQ11lYyhICDm+rghzxI3/GkTfCjuw9+XGPBqyYIHN3ibtygPEa8tSI1GeVVTpliRgTzrje0iVJMb832G5QjJOVzD3UW/6iEjg76fM/zlRgif67UAVPpZn5lmwYL5cLvrTSoS3Y3kN93EqfHtBSl+FC7HDOwANE3YfR3HDK2NEGKvHphos8UAOiw3fJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 12:51:33PM -0700, Andrew Morton wrote:
> On Mon, 6 Apr 2026 12:32:16 -0700 Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > > Second, the specific 32-bit and 64-bit compilation targets ignore the
> > > standard kbuild verbosity settings, always printing their full compiler
> > > commands even during a default quiet build.
> > > 
> > > Notes:
> > >   Andrew mentioned he hopes this patch merge into kbuild tree, so I resend
> > >   to linux-kbuild@vger.kernel.org.
> > 
> > Kbuild does not maintain anything in tools/, so this should go through
> > either the mm tree or the kselftests tree.
> 
> No probs.  Li, please send it along after -rc1?

Sure thing!

-- 
Regards,
Li Wang


