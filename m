Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 290D5CAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 04:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F288E0002; Thu, 25 Sep 2025 00:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1062B8E0001; Thu, 25 Sep 2025 00:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043298E0002; Thu, 25 Sep 2025 00:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6F008E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:10:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7600D13A720
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:10:51 +0000 (UTC)
X-FDA: 83926446702.13.FB50D8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 77C832000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:10:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I//p5kPq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758773449; a=rsa-sha256;
	cv=none;
	b=TMvIOacFMZwez+LkmQuQ8+UM1Vyzub9Liow2EXpO7GpFJDUWRI/iEYDb5OD1GnkNxCN7hp
	j2lWQ8t9yEN5PA7yw3Yyh4np6WT/K/z7GZwQKkW+dgCSzHcU3FgE+jcwbEipLo+L8ikDJT
	h2E9swaxwt58DSEBVDra8AuF6AI9M7o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I//p5kPq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758773449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvoFTvZlcmAemIkYd04D5dHzwPYeJtJCVmi1qum8rrc=;
	b=V0gtiSUJjDbFFgMSqzcq/8PLoY2NZlidN0s2fDCQiATPp3J6DvKKOvlnRYpkuk4BEt6hjB
	oIcVsfRDptunBgwp2ngdV9vyVv2O9QcIakEDUfuygA6F8qUjT4ZSfSXx7ZsT3c9G5FG4M/
	8dAPOMm3zuwycXTKXewlv9bjjEV93J0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758773448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvoFTvZlcmAemIkYd04D5dHzwPYeJtJCVmi1qum8rrc=;
	b=I//p5kPqXSXXrQV753hpLvXddSAZgkMo0ZzLzI4XRaZbnyHQ+BmBhiUdumVA/vvujvDTX3
	BlXA4O1MWa2Y6gC5yxsnqedniK6cvCk9xveX13WAesB/+Wv514C4/0y1lm5lFJ5BM112bp
	t911oASDu/pTq0v7r3w4kpgUPAzhEY0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-rkhpv2bGPt-2pDxrB1-_ZQ-1; Thu,
 25 Sep 2025 00:10:44 -0400
X-MC-Unique: rkhpv2bGPt-2pDxrB1-_ZQ-1
X-Mimecast-MFC-AGG-ID: rkhpv2bGPt-2pDxrB1-_ZQ_1758773443
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 711A1180057A;
	Thu, 25 Sep 2025 04:10:42 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C58E219560B1;
	Thu, 25 Sep 2025 04:10:39 +0000 (UTC)
Date: Thu, 25 Sep 2025 12:10:34 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNTAutSpmStbvLip@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
 <aNQTw2JRYfYDcafv@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
In-Reply-To: <aNQTw2JRYfYDcafv@yjaykim-PowerEdge-T330>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oZABZ1hD2pZ_lSdzopBN_-dweJUl5tlxtkvwHegntHI_1758773443
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77C832000B
X-Stat-Signature: 8rjnkufgdcqu1yruym48w3spghri96pk
X-Rspam-User: 
X-HE-Tag: 1758773449-844452
X-HE-Meta: U2FsdGVkX18vOl/BzpBXigyc4NX9fZ3Zo4kktyVAfeLT7jEvu2bxxlY83RlJZnmhn6trXz4Xfq8VoRgT3kxqoRWB0pZ9yVE9kHkhdSr7uv9ap8NSs7CB7z4BwEzK2b/6zkNcO3EfgeCaumQ8a5p6KujtOGfSMOiHEEeuV72wkTkdi88jKpnfNDML/LJAWGW51CYIeCHe1ro8JY040knZkmzn/3Iyvbhfp77g2WK13RM1VuwvBwZ8DfMYJtwId2XngNdxRN9lNwde2kQeMMlTDlLByApWcpZOZMG6eVEyzx7/QMjHCXsfia6bGOpwdzAFhbhocgoTuBCE9ERfO4cABQODnWsjhmq8tngBCJQbH1Di8p85zUT+2vNN42Tc713wyuzPh8QSQPP3wka4pN47elEkVU27slEcGV75D2PYaIMZWIJlCX/GQHXHOqpNzXRMyavTax9GbB3vIP1GOpMYn4TTov3s7nqMqcAvptW68sCe5ejB4BK6XYeAik2yciEre67qjqlQ+a8vDC53f/qTpRf6gXL09iuJANGtjADxelADAi9Z6GFp0iek2G/sUR7JoEMxB8S6D6jw8wlOVCPkQTznEhGC75hcPI34xXZ/SOVv+yVnJFUpuyPnPuF01xyhnltz2ZNfNXuP/Vyb3iRToFf09BgbQImt897kh1vQbHLXsHwOWOJ4lP7Kzo1sHporS4N4tSBuUUbYjbUsOtDf15eGI3im+nwB7Hyz3wHVA/PEJ81DV0YM1ppyC6AdRys97lYqCWvvpxDM1y21FD/Kq1i7JMgp8z3S9Wag3Ip5tbzxI3P25kJy3WMXjUN764ab7QgH4BoDP6oAggskEdmfq7p7mw3IwVFeudcNf9K1dcTEqR2VLhis6BxUptom9UAgcP5V8cn7CuohXlf70lXHIB7Ixghly+YG4mgSeqdqUIuaqYvoOrdlICSns4OGELA2VcAaZaFOZWzSrRZiLdr
 E8nrtXYF
 LVNg2arzGYJ80uB9ua7BJZnpRgIiXvqEJtUcoXA0+zLJ4YDJfsmalx8lRMlHyRQQ8vOZB/I+z8jegsYNaVnn2YkKEhlaRAnReLzsvNsC1pSoP4UsB75hWFxTMFhlS/lkkq8ekQ0TLAX+aM73KSrM6fQNGoR5Ld8OaU1Em5xoqRV9Fx9WiGXNFiwtLrpQPq1eWQaSfyFHh3xoQLqZz5cmY8vfcWmjD6tNhVbwFFU9cGMfiVPwDYn6ZPb7YmgW72FWPG5HVQ2dN6FULBmdgQ2u0LJ4D0u1o/A5AGnSkUQiUvzJX99kXw7HGeNIzlF74UZQV4Jat3mRM+kcs9mhLlW5Ihj4HG32DEk6EZc1FXEerBBETFNTS5s4jFTC4KPyuPW922cF26795eDMvekT/Ru+ah+Dzf3XpR60H73o+hkHVPwKi6h/B8qIAyqj0zlimNJ0ILEeS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/25/25 at 12:52am, YoungJun Park wrote:
> On Wed, Sep 24, 2025 at 05:17:46PM +0800, Baoquan He wrote:
> > -		lockdep_assert_held(&si->lock);
> > +		//lockdep_assert_held(&si->lock);
> >  		si->flags &= ~SWP_WRITEOK;
> 
> It seems that the commented line `//lockdep_assert_held(&si->lock);` 
> should be removed.

Yes, it should be removed. During swapoff, si->lock is taken, while
during swap_range_alloc(), only ci-> is taken. Thanks.


