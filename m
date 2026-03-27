Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F1210BA45C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314BB6B0092; Fri, 27 Mar 2026 05:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBEC6B0095; Fri, 27 Mar 2026 05:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2020C6B0096; Fri, 27 Mar 2026 05:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DAC86B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:40:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 963F81B9620
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:40:06 +0000 (UTC)
X-FDA: 84591346812.11.212F373
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 38CE040009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:40:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtXBeTL1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604404; a=rsa-sha256;
	cv=none;
	b=rt/xvH8ulRxo1xHu/9yyCUayNm2iCgUtwGa7z6Z+/CaLPM6ux3agNcOkNI/atHeOG24zHh
	EJEceK15rdX9qk+XlgWz4a0QiuHeS2X562ZgNcvnolsRgDL/tVSMd/f8Yjlp5J2lo5BsyX
	LQv3a1XM3oh1a0T2pv4hUS6GuFsHt5Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtXBeTL1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YOdbKfae4JbEA0UPM7uma0S92BFh9dlLyUY4bnqBIVE=;
	b=1d72np3zoZLqcoWw/fYAgMLtyzIU9tDsPUIi+jR6xN1qs3TRDaXPESEGHXK8KNtNpvpODS
	i3QUR/YxPBExqTYVwf8P7I+SMo8zDi5TVrYWMUU4Xe/WVYp9CPX3uh3nDSgPaNxoLFRaJu
	ML67XYCs/JcqLjn0ZotyOPGfMU131H0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774604403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YOdbKfae4JbEA0UPM7uma0S92BFh9dlLyUY4bnqBIVE=;
	b=dtXBeTL1jqjzWmjn6ZZ8VXcW0Yqx8SPCzBR2LHwzQeMF25PzeiC43I2rurZvGCd7hJITVa
	SFdvFDCmjZj/2psMDk2X8Kenvxsw7f4SPui0HN/GLnnIeFAmxUVLFRJSJQBbc/AZgsy1rM
	QrLBXaXH0XdpIGI79SL+9llXDrcjjdM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-cK1bKgHoNHGogcR_d5IJNw-1; Fri, 27 Mar 2026 05:40:02 -0400
X-MC-Unique: cK1bKgHoNHGogcR_d5IJNw-1
X-Mimecast-MFC-AGG-ID: cK1bKgHoNHGogcR_d5IJNw_1774604401
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b0601ff3d9so27655135ad.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774604400; x=1775209200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOdbKfae4JbEA0UPM7uma0S92BFh9dlLyUY4bnqBIVE=;
        b=GvIUWbQvL+RRW0Z/XZcBD65v78IbdynBv7CwCNSQ+He876E4Iukh2I6L4DdwaniQIU
         184kQgWe3Tf/1E+D8X9QuD4DgecIjuH2O/QLri+fZW8WNYCnnRR7X1RHl7WDD5w1ONbB
         nzBgWJ9FzYjig6usxKHVEm4tAOCQaNTgkERYMbMKm3kWB2qqMTcxONvhTUSdpIeU9nlL
         ZrgbL6q4P+tPUrtJEMAPpelV8hqXNj679ZTN/elUSjf7tMZWtE1qe7hCSUh34KXZRMMV
         BIDPhsQ5qAvr/sXOgNH8KQ3+2qXaj49UM/MGEl+6loiROVeyJ1D+htnDcs8e5FD+bVo9
         G2FA==
X-Forwarded-Encrypted: i=1; AJvYcCW+zDXpuUWGe8hDmG2nF/OcM4xWOY5aA8TuCPPu9IZgXpsW1E1jSC9NgxwW1XjWaMdnZstBzjBM+w==@kvack.org
X-Gm-Message-State: AOJu0YzHRgd8EBHYWFR1KULRG2JBDmg7la0Ta/t3NapPs6uqH/IZoNjK
	I229iamNYRDlOfBmLal8iyfaZVHu2ClQHFxJjTwuhUJGYhaEzO1ect6ciPqDikdXsSBLQEYMQ+U
	D/lIJCKezSiqCzowwRV3d8F2dMG7pOiFdOvyOCkULzXUg7BFJTPHOfw6go9ILlTU=
X-Gm-Gg: ATEYQzwFqvgWTmdd2yubW5Y3ovY2IiBILMj3WV+aY6lP6MtF7RBOLVdeVCEaYn87u0m
	Puo9LGCOl0U60jlEv2YXGcJhVSfEeWY0fDbdiGM07BqzCPd7O8onPMUxCDRWyQe3dKPnqyQTpdx
	TEti6azZgKE5qCCgpkwlqnIh3UhYrJKgtUCKXiMqBoPYkmdvXgGOWep2wAU9ctr3aJX/MmTtYcu
	LnPP+BD2JqhC3PDoCoYogpy6MpSI4/mFd4VShiPytaaUdh7TBOh+KVZJt8EdqUm67xUEsvxfAsE
	YQClaFeuMhy29mI5JMDAH2ZWlGqTjRHttpNe0M6RwO2ZV+0YyJJYc2uHT6FGrlzy3kzuryQrrGJ
	CmLyqjIuW/bvmXcYoeg==
X-Received: by 2002:a17:903:1b65:b0:2b0:afad:7aad with SMTP id d9443c01a7336-2b0cdd3e3abmr20490265ad.45.1774604400554;
        Fri, 27 Mar 2026 02:40:00 -0700 (PDT)
X-Received: by 2002:a17:903:1b65:b0:2b0:afad:7aad with SMTP id d9443c01a7336-2b0cdd3e3abmr20489965ad.45.1774604400082;
        Fri, 27 Mar 2026 02:40:00 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc76b92asm53890105ad.15.2026.03.27.02.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 02:39:59 -0700 (PDT)
Date: Fri, 27 Mar 2026 17:39:57 +0800
From: Li Wang <liwang@redhat.com>
To: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, aubaker@redhat.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip hugetlb_dio tests when DIO alignment
 is incompatible
Message-ID: <acZQbTMiXctRPXII@redhat.com>
References: <20260327031243.15903-1-liwang@redhat.com>
 <acYs_-UOv72cmO-P@kernel.org>
MIME-Version: 1.0
In-Reply-To: <acYs_-UOv72cmO-P@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E5T-TklFlWdrjvPT1VyZKYTvdqWQO_6JPrXd3A2xgNA_1774604401
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 38CE040009
X-Stat-Signature: ka1godku53yryd4qcaefjzazooedk6jd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774604404-317792
X-HE-Meta: U2FsdGVkX19BWYdNYc4prZpBNI4fm5AL/uBu5Tn4863UTmwgnpr/uAmdELCATzGUBTcfDaeNLIi3Es/+C02qpZ/AtoabuQ4U0JjoaTflfyhfFZ9ZhVDpkcHKpUkXTkRR8QurUAcbUX5rcKsmea8sK7NvXzW9coQL28sNNvhf1Pe6V6rXThJGLw0OiYMVvU5wqkPvXqXzsFd1SoOPXi5MtAc8Adja+6z7Knn1eRkxsiHgROn8PjKrCceGQ8hoxrl1AvGnLw3nOSQ38e98PKYEeoH4H2hD2Hxu9D+k4l2afecR3qF1jGuUBWot/j5OmMAS48VDLOU95TD6YMC+vxY6+6MCOUyiZJc2CSjInkj6ZcAEqo0Wae1yWeE+xYh4EGbpYdvK99mbguWNjvubgo1ycXDbBHcDMJpoqcjkzr8u7D+iH7g0/ZcP38nnqSQdkXO2/i/148PVLtT+BQSEhq+p//srPyQCLBrzAM5WA3Dm2aA32/x4NHROVyaFynCYCPVR1qh6+e/JbrZ25OMR7YLBFZjgyOlf2cuyEtwEeRegLGXKrnzYw36O38igzzWvt6onIBWQjEZabAvAFTQEqKA4bXKAUz+V8WtDoZouRfoC60DQAC9avrUPXxyfru3ZIXGRCPEWLMb20JjyIZJVAZ389PhlScE5WtZ0bBbzLfg/fX4VEo9IKr4SaVtso39rqnV4EhxoFF3dFEbDQSH/6urk2KulaY9w6/X+gzbo2Wct+9nYQO/o0GmiU25uuMXonECx6Ah5opWCgL7o9XstK30QaZPehTqf9jcj3zs06s6Lf5DgxCYp2dmCmC+BMZRNJi8VhZvyVY87Lm1UU2aMIkiO/TUwOxgvebtBtm/aZIgGCdEqUR9f2ET6/pWuIv7JMU5I1wGzWt6B8qirpfClCWUQPXy1i4/ZCePes83Lf0P9a55O0ckLfaJF4dSMXbSxdtjPfSpmu69I45A7UaoqrZA
 H+NqiAby
 KTMeTxy3xJFpvs1ZP8/xFvZp+ot7BN/QHjjcfFUEBSHARkzXrBjBMctT9wRhgJyvblhG7AYqdZ0wXmMhfrFCaRt9gveeIDaZRhZZ1YhcqX8hDSsaPmx+o8gCU5CNnJhM8tAP+48S5yVJVuEBsdOQAYYDuUNNDZkXS2LKZ08TPRlPnp3e+I0+tpjuF7lFn3KgV7s66ffy/RMkqOt1GX+hEcRa2IgbzYkJCDzgRfVfU8u4yJGV29qgtDFkCMAiWh0H4hoNJPVKtoxGxckq1DrocsN3ZTUOSJ3wrg7yH0586yHO0vyBPXhtMP162AsPBXzwCSorr7yov9a/PYBV8PCHAE3XMh2Pk1DKdWPjjsg+ts8UxDEtR8o6ngUjTNcRJJwNZfrQgXukTM2bA/kMqAKPnU0LeN/7lAy0P69sAYWoHBn3BFeOX9ZrpVG6b3rxrpGcCTNQjMqD4gV2N2Qth+cuFcRLYsG13i6qv6em5O5OWWiLTV4PkS/zP1O3lfvuRMo2qm1yiX8PY0xehJAXzajat9q2paHaRRswGSzjssxJabRw3cub/FOWi4Mdn9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > --- a/tools/testing/selftests/mm/hugetlb_dio.c
> > +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> > @@ -20,6 +20,31 @@
> >  #include "vm_util.h"
> >  #include "kselftest.h"
> >  
> > +#ifndef STATX_DIOALIGN
> > +#define STATX_DIOALIGN		0x00002000U
> > +#endif
> > +
> > +void check_dio_alignment(size_t pagesize)
> > +{
> > +	int fd;
> > +	struct statx stx;
> > +	unsigned int dio_align = 1;
> > +
> > +	fd = open("/tmp", O_TMPFILE | O_RDWR, 0664);
> > +	if (fd < 0)
> > +		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
> > +
> > +	if (statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx) == 0 &&
> > +				(stx.stx_mask & STATX_DIOALIGN))
> > +		dio_align = stx.stx_dio_offset_align;
> > +
> > +	close(fd);
> > +
> > +	if ((pagesize / 2) % dio_align != 0)
> > +		ksft_exit_skip("DIO alignment (%u) incompatible with sub-page offset %lu\n",
> > +				dio_align, pagesize / 2);
> 
> This also needlessly skips the test with aligned offsets.
> 
> I'd suggest detecting dio_align here, passing it to run_dio_using_hugetlb()
> and moving the check that skips a test there.

Good point, as the first test case use 'pagesize * 3' is fully aligned
and would work fine. But apparently I overlooked that.

Also, Sashiko reminder few minor issues, which I would fix them in next
version as well.
  https://sashiko.dev/#/patchset/20260327031243.15903-1-liwang%40redhat.com

-- 
Regards,
Li Wang


