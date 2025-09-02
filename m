Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4B3CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DDE8E0005; Tue,  2 Sep 2025 06:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDE58E0001; Tue,  2 Sep 2025 06:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ECD38E0005; Tue,  2 Sep 2025 06:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2838E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:03:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E51D611A966
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:03:01 +0000 (UTC)
X-FDA: 83843871762.06.F953A99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 24F781C0014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:02:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bpTNeKRR;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756807380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7iVx07Fv/yIbeXuVBBSoRpdEoUekZGab8SH2SB6W6A=;
	b=GksUvZUoUz+i+ZI6Im0GKzse+NUaJXWhW/p69Oj45KGcS5bpMd2ZxVw64Of7IQCr+0C4Vk
	lDhTgFIDPMt8bYm6J1El+Jw4SwlFepSHx/bFTncOOgnuXW+KBqEwhw+ZvLuqO+hbgONI6X
	jWnXi+Jx17TaG7tjH+zkPFlYHUqgdVw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bpTNeKRR;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756807380; a=rsa-sha256;
	cv=none;
	b=u6vudPuHkgzzQvNmtOu3UHid38cnkh8jECVt0g2HIrKS93Uq+djZQ30GeBtLI3slQj/YuD
	QKNBLlqSmzMjTI55Vk4bDJYcCgY2RY99OlIF7NTWBOXi5ryuECQbc4kgqnxXSonsOTopJo
	urPsEII7VisLeV9pYtf7XQ/n6y3sGF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22FFE601FC;
	Tue,  2 Sep 2025 10:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC650C4CEED;
	Tue,  2 Sep 2025 10:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756807378;
	bh=//nqL4lLAfIxW165Zpqicim1COFnjYI7FmXj/nwXVQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bpTNeKRRpbEq4VuZA9LmqaueKiOGvizEA67DPfZXhNaue0n/VbK9mwN3yewtEUkhj
	 dwTHEzsYV8K0ilq+2qseVmZk2UnB64cBZkyS1Iadme1heTJtZAlzOCNkgOKbkF9ZvQ
	 CA43Jp0zfvu4rCxXoCKnZY5uNz80FEF5O1VO6f/iCq1h31bqeuvoEWrq+KwgCAY+Sw
	 TpBmawNe922+sDtauzRHPr4bqBQ8W00Q0ISUYAJkJXhdDAZwhB/x+V1+KssIBTIniF
	 0cOlfXlkNDfqZTneuG/Qkoh0h3IvtkKaFNSGcP4sPWy72/mfvsnGFSHWV4F8Jzz/Ss
	 nG5OfZbpoatPA==
Date: Tue, 2 Sep 2025 13:02:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, vishal.moola@gmail.com, linux@armlinux.org.uk,
	James.Bottomley@hansenpartnership.com, deller@gmx.de,
	agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	weixugc@google.com, baolin.wang@linux.alibaba.com,
	rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
	broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
	mpe@ellerman.id.au, nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 00/12] mm: establish const-correctness for pointer
 parameters
Message-ID: <aLbAvirCgCfpXaVK@kernel.org>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
X-Stat-Signature: 73iqqda5ku58sfa3mhwwq8i7g381qszi
X-Rspam-User: 
X-Rspamd-Queue-Id: 24F781C0014
X-Rspamd-Server: rspam01
X-HE-Tag: 1756807379-126511
X-HE-Meta: U2FsdGVkX186UqXXLPH5pYNbi60Y4wFm1L3lAhpqiFNjh4DucqoRBFgno/9Vo7U/4ohX92QQyPjDZnHcMZix6gK94K0HPV1GZsg22/z9io/Wg344Cajni9TeJW5TqFnn8Pla1S6wKjEz2T/0DkvIrnwBQs3aWSt8FWPj2Zhm5XO8D36lSsKqUXXGgyMEU/IpR5vRKtfLdBkCfaEU3lIHnX4aubIXKilQ03y4EhD+fVHMYUA0cZ0gYAbpKQMzOcQcR998id6pplJ+pHo64yE22cNtU9Dq0ySophvFa5vjtMu7sYfUhvQILZkQsdNF+ibTq9oioT3zn4VucRwamYtW1F9gLTgXYf8b8PXtT5YOi1oKyKqo2Hbd3DqALBkf3k6PeyUUBMbNBa1HIX2+TsaGUc61L3qNn6KgOUim0B4ZDQ2bBNjxfOtPE2RhLgjt1v4ocMtiAuaPLCBYbd2sxQvbs6GjErJgzNBLWS6SApXLHbwhK4nr8FFZiFhFD5b63arKwR5I8u1QFPA7bR1Ju31mU/ZExLUdGp3gAHX6Y2S//gOrwJHV+mRnyYg1w11JwGAWULO7eIh9aAdGwr6RXCcZGrFjtMO9DwWvxNCIFElvM2sGC+VERxwiS3hRic3AS7zZgO2fVfSMQMFyzkJTHXuo6pZmBR/KAjsuGEp+imX2UdEt+rrqnO2DzwmHtE607BOTkj9DIK6xrKq2Dw9rc3BMH9hny2EmI+qGYHP9scnPBp0lA8g/Dq++b0ipRFM4plMucCVRcI7TbTIJRbPHPLJAJXkuIcRwhDgCS5UhjeXDunPi9BBOHfoABxTFhi1FAYKhgslmPCSSqIE/mSY77JJzFCbtFZMxqHPbEb6s1EKZnAZi+t+e1RxV5/SlnkhQEqQ4Lvko8lq1k7SAe+USqzsqole+ksraIRNcnuRrwBeKSMMaTP7NRffUtUK5MnhoFoIiozX59JpX4+3lvACvGpL
 BJl0UpCU
 tM6PVUN8PbgbVh1munZddrYS8K/EoCDr91KfL7KGjWeeJngYi3/RoJ/5Hrgvq5G4k+u3ee7VYaGDuVpR7sUsyG5fYNZWMAlmaqoiYI7o0eNZoy07aRGxsdpT1knwtGi6T7+VYSonS46pfo9P8/yFJMwBdyEcMz0iJ4g0P+nxPItECT/NYyeoQSpLLm6XU1JHlC3GjCwN1y28toq3v9AHaZa8z6hV3Ae+UwEGidns25v+VykjcGIOEacUZJX2X783RGaHzeH5J0aRAt2Pdch2DJatAFwJEw5eiQxNsn+BKSXym+5hFZKxvNvOFBUcya87fyq0dlsdelD09wS3N1VjeVEacFHMPJPOZwRbvqmQwJX7zn7RGs8e9nIrnJ4P340VOVSX0coeHn+4PnJfjuKlxD+iJ2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 10:50:09PM +0200, Max Kellermann wrote:
> For improved const-correctness in the low-level memory-management
> subsystem, which provides a basis for further const-ification further
> up the call stack (e.g. filesystems).
> 
> This patch series splitted into smaller patches was initially posted
> as a single large patch:
> 
>  https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/
> 
> I started this work when I tried to constify the Ceph filesystem code,
> but found that to be impossible because many "mm" functions accept
> non-const pointer, even though they modify nothing.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

