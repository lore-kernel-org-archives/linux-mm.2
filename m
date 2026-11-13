Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD47606A89F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Kr6g7ztj
Received: by kanga.kvack.org (Postfix)
	id C34CB6B00EF; Fri, 13 Nov 2026 09:46:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C8B6B05B2; Fri, 13 Nov 2026 09:46:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49126B05B3; Fri, 13 Nov 2026 09:46:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9461F6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:46:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2584F1401D4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:46:42 +0000 (UTC)
X-FDA: 85430372244.07.88A9050
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 292E3180008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:46:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kr6g7ztj;
	spf=pass (imf06.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794581200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORnc2vjUi42S6adRltdclowGph/QU1FbRMOu/4qe8uo=;
	b=Vx2fg3i85zE/FCNwRsi0oWw5BFiRjdswfPOAe/awojq/5p6jCIgIhOlaMJIUBCJjQF3Y4i
	O3yhO/YYif5wZ7LU4lisgbCF+eQ/5r3SmrUMyQmYjzF/H21B5yxYhg9+PLa3qpUgJcmCbC
	MKU1S/GB1hHsD3FIo14YfEGV0vT19Qo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kr6g7ztj;
	spf=pass (imf06.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794581200;
	b=RMAQ+xGG4RP8F5tbdMLzhMhVNRK+dr4GoDPC5oM2FzsCigXS+fQZgd1Q/lnTNVSKlzEeVe
	uv4Hm/7T/4W7ZTe3rfsTyoOWvRvugx31LvlgpMoFZBA0bbO12xI7EetwpcoBDINvwl4+lc
	yzIs6wAUzIgxr8qCroFhUicNcjj8qsY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794581199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORnc2vjUi42S6adRltdclowGph/QU1FbRMOu/4qe8uo=;
	b=Kr6g7ztj6LPIa+tVvsKj7noEQo7th0tKou4WXKT5iS0cQZR5K1v5PetuXrStMAncySU9Wy
	xVwf8s0QHFpP3qsVtq1KOj0B49rghUoP5qfGDFkcgxpHwJxMmG/SSyuvj0742NOVeuHJBH
	5lSxxYaR56fxkwSG1cyZx/wzxZ1WPQU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-0kZciE90P9Sb8qOm83I1XQ-1; Fri,
 13 Nov 2026 09:46:36 -0500
X-MC-Unique: 0kZciE90P9Sb8qOm83I1XQ-1
X-Mimecast-MFC-AGG-ID: 0kZciE90P9Sb8qOm83I1XQ_1794581194
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98275180047B;
	Fri, 13 Nov 2026 14:46:33 +0000 (UTC)
Received: from jocolema-thinkpadp1gen4i.rmtusco.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 085071955DB9;
	Fri, 13 Nov 2026 14:46:29 +0000 (UTC)
From: "John J. Coleman" <jocolema@redhat.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	zenghui.yu@linux.dev,
	audra@redhat.com
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base page systems
Date: Fri, 13 Nov 2026 07:46:21 -0700
Message-ID: <20261113144621.1447739-1-jocolema@redhat.com>
In-Reply-To: <bf163c58-a884-4164-bede-974b78f032b3@kernel.org>
References: <bf163c58-a884-4164-bede-974b78f032b3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: vtR3SdfBHzBPUuKnFIbOPqukh6yp-7MnSnnFR5ilLDQ_1794581194
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ygb7znq46qxsjeaisnig3gu57rjzpgqe
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 292E3180008
X-HE-Tag: 1794581199-995203
X-HE-Meta: U2FsdGVkX18OHNXbIJANF0KfxL+dH01wGd+FhV6x3QGuIzls1LjMFoBFUqPHPCDh/BIqqzA6X/FE0pJNV3AI7WSkcJ++3b6GCLsAhbW/WOJybCJEi8g7A14c5HUVZIavekcfRdvZtCW9siWLAL8s/9G9IxbVatpCL8nXnN/UaIrGbHcHJO+fK/xLceSDRRMLq5xesAs4kupyznuxvAQbTqTlwZzLlchZ2goryJuRi9SPhX2MXEXLO79MlwFIIo4KOGrUvE3IEBwWp4GB03Hu+p0Sx+ytliPeKECsiU09WE6+drEgs0Q+xfYPYIhdifHgrXtWJ2PW22CXeNeQ/hNGw49e3Zz5AZIDivNVR3Wuhzj9Z7uf/kyW9dH7S9OkuWBhyzXBbCUfSF7e+Ky4SR1Snh5cA0Jt6l1ukD5GnjBJJ/1s4v5Qa9UkdGPnL0FEjLCChLhuSvEK2QYiuX6M2LfW5HGzBM3y9AlAH8Gb58j5Ve2xtedUBNiHea0TDC279C0CHIagx/yodcOvJde1Wv4y9fX0ujMiCFruL++sAesmocDes85qSmJ1AvBfIsX03BMx8OD2hJdTAmZO6Gvv7etEX+exSDCxMutyueAAIvWmkjv2Wt21p0cxr++VLhRn7STkREP+mKICmENXF4ExSvYttiV48K1gy2cPWjaT9L0sePS0B23W6nrRlBDJ+mLGnjB95DHSC88cB4MdxJ4kpHgxOSFsOrlJgy4ZzhJ59QbswAw9yufjJ0ki74g9uGXL9D0XbuzjmiKvvHVr3BZTmaypTx1gcjc+m8PhyqWUwOsUUbteZK3T7LalMUwteWegtU3U1TaZB4SQ1X0vNFexvRc386Yqt0rlwxZNtdvQBTv2HJCgmsAMAIUAy3kTPePIn/4AXV3Yundq4uLBqWmqMBYxU/DTCX8dt3d1sQuuQxWFakC1PlsfwriaIRwTNXKFj22bi0nfVAY/64yjcVkfd6m
 mKoJzOxD
 XE4e4+7TAIr9xEVhVgznGffTXgSpvoseI8wo2McsAQ4Zw2H2noqtMO3NZ/Am8DFnCp4MZbnYNriyE0fYV4gPfD7EI3MV37z+E06n1GuEBqkaT8eyEqPDu2WQ8lx5Jky9Y83mcyCFtOCOi4/7foO+UlQo4lrTdkFR2ISt/2nQ8PtFaibD93S5FqZbgs7RarWe/g74kdNM8kiriutlzoxPTH7S+8zZC8zp1kJqlBFlm7ZiS2nYs/cGrwGrs++5MxMlzri0fpyvF45OJUV8P4kLn4WAbAruibIAAZ4XlKoL4BNYSwEGGGey5k2udRv5ojyj4UhxyG/4MiiElYlWxqsYjyVUYxafLwNq+GiSfILE2+xaRQCHiNdaaitzAVI2pxMyWK1ht+D/uln70wHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I wanted to follow up on this thread.  Subsequent sashiko review I have 
made a significant change in the patch, hence I sent in a new patch
rather than continuing on this version path:

https://lore.kernel.org/all/20261113040045.1439391-1-jocolema@redhat.com/

No rush, and thank you!


