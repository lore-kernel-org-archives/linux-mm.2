Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB1BD711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 04:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1C36B0088; Sun, 21 Dec 2025 23:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F796B0089; Sun, 21 Dec 2025 23:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BAF6B008A; Sun, 21 Dec 2025 23:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12BB86B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:32:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9E6E137F3F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:32:36 +0000 (UTC)
X-FDA: 84245835912.09.047F08A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB89CA0007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:32:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NtV/wIyl";
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766377955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOXaiRxr3cPmAHLihU3EDtTfZSpwuqBxKeRVKpiPhxM=;
	b=W47plQTz/VlEZXTjeNugmbRUax8JxlJGXvYAGwFTB4ixsIWx+WpRIl9LJ/2spS24N54noK
	l3LzifTWnSJkBCWnkCoWrGqtvytkXhqbMqmFNTCk32PBvWSbSIs7cUzv+g724ABHd0WnN7
	FtoGszwJhqGOta8//ita1Bd5Z+M/scU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NtV/wIyl";
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766377955; a=rsa-sha256;
	cv=none;
	b=fBYpu/cikC4L0cL0iNkpO5Q3FWXwU/VVre5gLLfcD6WZY5jP5s5azGuNe+tm+LghsTs8t6
	yI8cskUILi+AatSg2Zx+c4R4HUa7ytn6gOh1VlsSu8H+DIcS+xPhL5yLY/WEugl70l6Wge
	ivjoE+U+ix28jMRkt1YYJLXwC3Itvug=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766377954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XOXaiRxr3cPmAHLihU3EDtTfZSpwuqBxKeRVKpiPhxM=;
	b=NtV/wIyl0yNRuuTGZx7tBH3CdL+h5ro3o0kLCeiM9ughXSsj1sWED1g6XppsrniqzZX7tT
	NfOwl5MA/pifF0Cofz09kULRVsEmpam5MspAfOEDXTy/t9aMV8QrTyQSyYqvNPGX3aPPaW
	CvOL2YWzoCo79bQk/0HuhxSyrDdQQJQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-lYN5b-iWMHKdX4Gz4te0mA-1; Sun,
 21 Dec 2025 23:32:32 -0500
X-MC-Unique: lYN5b-iWMHKdX4Gz4te0mA-1
X-Mimecast-MFC-AGG-ID: lYN5b-iWMHKdX4Gz4te0mA_1766377950
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9105C19560B2;
	Mon, 22 Dec 2025 04:32:29 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.121])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8336019560B2;
	Mon, 22 Dec 2025 04:32:21 +0000 (UTC)
Date: Mon, 22 Dec 2025 12:32:16 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v2 1/5] selftests/mm: fix va_high_addr_switch.sh return
 value
Message-ID: <aUjJ0OKZajNNoQok@gmail.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221105709.d2e44cf1bb05bd9669e76d0c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251221105709.d2e44cf1bb05bd9669e76d0c@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: uaor4dzngaic8o58rk11zfxa97b3zk1u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DB89CA0007
X-HE-Tag: 1766377954-381611
X-HE-Meta: U2FsdGVkX1+a6jvUGrymXT5j2va8gB6OvH0H5p8+nUQZNUsiYQ44jbduEJpWczGiGSWPs5HG2Hzvbvuolp9/HSqBpXTe43p9sNJvIeiz5R1MgxGfr4aCuPhDcaPD+Jw4QtoDxmd1yg5pFwALsGf6XxnM7c22vHd3z8IXxw2j/8RQA/LDuy3wSOaokCRZsg8TF1BJKOPThipxfse5rTx/NfWwU3K4j/KBrFUND537v2YucEfNpoD5WBm8RA3uxpQBCrMYsk574bNrpDHoENLJzd67B4Gu9oTrWk525amK8OLoxpQSamb5bokCw00MZf69WM4n6ATKy3QXzJ1nN4GcMTXmf3MJTHuea1Wx+nVZy5gkezSvu9mkhQKYrHBif5Vdb9kedGYjizjIUoWkE2ySsFkm2ONd1C0AevTW5bZTsT+8s1nxpI0O7ESsREEBZpYTlrZ/NR2mjnGEXr/R7bs3TMyeK1I1NHEc87wGOado836V1PNTVfzBltnx0L/sYys0d0a5c9sEi5C8SPXx/e4pBKhE0N0WI4UE5dQDpaWElnOKFPme+Jqt93YLRY+EhAD0aGIUdw6YNT7bdnt604Pb0XmvAdyyosEPk1d5xfY7H3ZH6kQWHXQizKWRbU/Q0G1eOcFLKXNPm6XYZ2ny2G6ZNwIieMi2RYDQJo0tYf0p1QXVGQ3pFFgmbRJ8jZECGLz3bZXj3vxjrWnJ7zpIDTfUCni/JsH8O4xh0nJGbdDNstLJY8mChP9j2cGrS5wZm88YYkEIuWL+8yb06CiLiz95tJpTumc3TDMKQDpq4WBeJTlhBsnc/WKEbMUnDELA6A+zzTYniDhg/oJ7hX91QysNnl1f3vGBl1Xnp6ISP3iHq8iuJXiEJQ+8vRFccAcQuPTrnHhMxQx65s2rpfnPGDFN0/DZ4yERPkiQZKt9HaWzOgx5/JEPO0hrLBbC+6AjruyvpZU2aVtYnQgwOeMOZFK
 YOBoKx7c
 u+UXEDJ9iO/RYHtagwvDuRr4D76LNIIilVa2KFtsC2RI7cBnEBJzSwcfzKhz40xqBUhbafoD/ZEZhB1C2EAje90YfQu11amStXfRxaj4iKNKBXAevqdg0WqdZMfZmY3gk7psSwIq7GjE+E/Ie6zUvFQ/cR8+GwvgskVAt4F7ClbKIp4Wc/GHpjsurnKs46lEqJeKIprPRYYu80d2PUFP8dQxAsWI0f1z7PFAurC0huuiy3RE+/XY8libmizzkW66/rwwmfzM6R9m2W0pcW+ncKSU/CcCW129k+RgCiYSHPNigHxECG7yf5mOBcaIHN1oQbT1zoIJPYEiPegapoqmFrWAAYEihUyOFT8RlhbxbYKN+u3gJTSiUryHQAYerRZJmCcw7KJhyOUrouRRLJ5xMHxZvMu16H/rue/fB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 10:57:09AM -0800, Andrew Morton wrote:
> On Sun, 21 Dec 2025 12:00:21 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > Patch series "Fix va_high_addr_switch.sh test failure - again", v2.
> > 
> > The series address several issues exist for the va_high_addr_switch test:
> > 1) the test return value is ignored in va_high_addr_switch.sh.
> > 2) the va_high_addr_switch test requires 6 hugepages not 5.
> > 3) the reurn value of the first test in va_high_addr_switch.c can be
> >    overridden by the second test.
> > 4) the nr_hugepages setup in run_vmtests.sh for arm64 can be done in
> >    va_high_addr_switch.sh too.
> > 5) update a comment for check_test_requirements.
> > 
> > Changes in v2:
> >  - shorten the comment in for hugepages setup in v1
> >  - add a new patch to fix the return value overridden issue in
> >    va_high_addr_switch.c
> >  - fix a code comment for check_test_requirements.
> >  - update the series summary in patch 1
> >  - add reviewed-by from Luiz Capitulino on patch 1 and patch 3
> 
> The "Changes in v2" material is best placed below the "---" separator -
> I prefer not to capture such short-term development-time info within
> the permanent kernel record.

That makes sense.

> 
> > This patch: (of 5)
> > 
> > The return value should be return value of va_high_addr_switch, otherwise
> > a test failure would be silently ignored.
> > 
> > Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
> > Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
> > CC: Luiz Capitulino <luizcap@redhat.com>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > 
> > ...
> >
> > According to the doc below, I don't add the cover letter, not sure if cover
> > letter is preferred, and if that's the case, the doc need an update.
> 
> Funnily enough, your series was in the exact format which I use when
> committing patch series.  Usually people put the cover letter in a
> separate [0/N] email and I move that into the [1/N] patch's changelog,
> as you've done here.

yes, I see cover-letter is the actualy way people is using and looks
like I did some of your work putting that cover letter into the first
patch. I think I'll add cover-letter in the future.


> 
> > https://www.ozlabs.org/~akpm/stuff/tpp.txt
> 
> God does that still exist?  Pretty soon it will be able to legally
> drink in bars.
> 
> I think its content got absorbed into a Documentation/ file a long time
> ago!

I happened to open it before I submitting my patch, and wanted to know 
what would happen if I follow that. And it looks like cover letter has
become the actual convention.

> 
> 


