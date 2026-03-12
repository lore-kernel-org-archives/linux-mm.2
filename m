Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95202106ACD1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B1F6B008A; Thu, 12 Mar 2026 12:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F756B0092; Thu, 12 Mar 2026 12:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52586B0093; Thu, 12 Mar 2026 12:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C59C56B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:54:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8845413A771
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:54:53 +0000 (UTC)
X-FDA: 84538010466.29.AB9017A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F7404000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:54:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Pfi6Z91L;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773334491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
	b=emcx1sHEjYPKaaxGKR15X7Bw5ksRx9IKr6ZpX+ssTCvnakynpZIfAgrXL+wrL5Pwhi/lPJ
	PJUR5gqtz8MBCcN1uwtn6jSRFHb+yTdF0N6aAzAMrPaFdcneu6HOKsfqdfkdhvHSbSwSHW
	qeIRmBbmSSRGhlaZ3AdcVtIOBg59020=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Pfi6Z91L;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773334491; a=rsa-sha256;
	cv=none;
	b=zCiDeikoXZOceDT9vp5nhzR5ZUnXAIb/85iBTcXzTk5j3vudC98wM4aBi2RXppmGyLi0Pl
	jCtySxCOLKZO5lgLTrtVNRVfgagijhZn+/SPiIjK2c14p6/5WXIXuf/rGxf7ZAaUK8Jbnl
	P+PBgTpXfDdoV39gE1at0pbOgcbhIoY=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509149ab7d7so10174661cf.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773334491; x=1773939291; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
        b=Pfi6Z91LnWFHr8tS1NEdMNteeTP9+usrrtGkzbun95jZ7eBqYRDt5mJqzPQLQbDefw
         h/wAigAP3kJ19OrBCt3JpBIfpMnZfajM3tNlu01kaWblW4sgxtCc5VUdjNdPqCuDd4TZ
         Dakyx2qswmDBcm2bkLQzAapWqoeAxSiZVSbZ4dtd1ngHCz0C0WCYnDqtCguNEop2v1yu
         Q6IX+3RZtL60MUIa5S4XV063WBKU7aKmdQ3a6Pu1H/S1x1g/+ptfDOy9AhZJdYGv3riz
         citFsH72kGo0L9eqRF5Mfl7rCpIrNxVOkFKlhQPMKiWZAE4M3YandufH8kY74xyjZPWr
         Qa4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334491; x=1773939291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
        b=o4POUAjxtFD6dtN+ANJL5RrrhDBl0Zcy6eSvFeCDEmtwU1eF+rjsYTM9ywaAV+3kdE
         RzlX2KBMniZMav9f8P6jxJCpKE4oyOoXvvTIrIkdYCzhKxDVq6ot8TmaiqESMGh11Yc2
         U9CFhE6+AlDiaITrCqKwsI6a2hmoQ+KL0QEWJfbpnNPBhjhBUFNn8PeyqUYAFd4oeoyu
         C235l7VQfCB8nQxtOzbP2cMnbMBa2aGhz6Zrok95nP1wvbj3LSIdn2mFhNLZlMnHKDwx
         nTSs1XH77KgFkOoR+JOwW/+eUJI4md/2Tk7dORGGHZIuotcl2NLDEzzgCuBxF++7rdBg
         lD1g==
X-Forwarded-Encrypted: i=1; AJvYcCWTC2/KP3eSbVjZBerrNfolFQ0IXgCfy35WFcte/nZpNv7wlMtuxAXRITbdPJA7BS74CLdMgKckkQ==@kvack.org
X-Gm-Message-State: AOJu0YzO+cpLoVCNKeuf1QktjzmH2frlkw9e058J8RnMoGc9lGe36IWb
	OUmeexYBogacv0I3ZyP3FJgFa92nmAEJGzwF3B9Dvic75oVJ4dsglWZAAQoTEXxojX8=
X-Gm-Gg: ATEYQzzSFe3s3P0zlEKv3uxE/hXyRtS7VJ9aYZH+JFJ+1yLysM07UlQO9NVXFq2TSDU
	di8p7823Mzs6hjgW9q/nk5IvnD8eD0zf7vKZ9ZqIBCcJiC3REkFEmck+wr1W2FJlAuT6/yM5Axh
	wFHODlSoVsXQ9/Yk/BEEBWii0fWaKypBXA8yO90NDaqqIreizh/mgx6LXkXof2y3hZbZEJcadmP
	WeIadtVfV4vO1PdKifk6baFVGedsS5kmHZtdHPSaXsay7ZWY9QVdBeAczElkXGO2Ivl6+FRt06k
	pK9Px+jq+vmmKmX6neFk86vGRLM/JXDx5YQmmJTOo6GpJt+BMaYq92NxZWrdPVRN6tEgV/mc1X3
	I1ZXqO1r3DRQ6tiRx+oQVN4p98pn0VcpQQ6clIAPPiDPwwnD/Z35ODKQZLuMgUbx/Q+GuvPcqkd
	1AXPso+Yau9daIR/bHFHy/cm1dBUTnen+JHokWLTyu2uNnqu57xej2Ol7/6h2PcLz/yo0RWga3f
	4GQRlqIR2gP09XEzuo=
X-Received: by 2002:a05:622a:289:b0:509:44c3:5ffa with SMTP id d75a77b69052e-50957e10673mr1403911cf.52.1773334490530;
        Thu, 12 Mar 2026 09:54:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a119602sm36658181cf.28.2026.03.12.09.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:54:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0jJA-00000006i8N-40X9;
	Thu, 12 Mar 2026 13:54:48 -0300
Date: Thu, 12 Mar 2026 13:54:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, Philipp Hahn <phahn-oss@avm.de>,
	amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <20260312165448.GN1469476@ziepe.ca>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <abBlpGKO842B3yl9@google.com>
 <20260312125730.GI1469476@ziepe.ca>
 <f5688b895eaebabae6545a0d9baf8f1404e8454e.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5688b895eaebabae6545a0d9baf8f1404e8454e.camel@HansenPartnership.com>
X-Rspamd-Queue-Id: 9F7404000F
X-Stat-Signature: aaaxx96gjiz1w9oz39o87p3p5k5cotuo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773334491-165192
X-HE-Meta: U2FsdGVkX1+j5O1p/WHOLDk2aH47BIQdZezDmNp/QEgHGM4/b1HuUG3mEisUt08ypz2Ti0tY9XzjyY6Fn321ze3geiQ7Dr6HcExnaqqwDYocCr0he0PMf/uzTOdKkUArG3JHELccPfszYaHFaPJgY05DrB0iTNGXY7ChsTlwIaUsTchJW7Ta/BTjHHhBIcO5kXxf6bbVh6Yml3UoShEpg4npH3khC7i0vaqd20C8jS170JW3hlqvF6lDOcoJr38ClBbXpys+s2MN8Z+teahtwF1HY7dO2Nt0EXcq2ZtJtjSkTlDeNdh7cCOtQp9Sykqxg+ol6HX30NF0lpumcgsFLYq663sB6+WDsHa8ZNVmN8mS6vp5wQ91n9e1yRu8ukmi8nP5RZtu+a/C6j/Nm0rpRMej675teADv0PRuoXo/rWYZQxhN0+wZ/7iNBYoMWKoLA7BPHwRc+FJzuNuiz42DOz2KkghJoswwxoFFUiXzdezMI+KC2kEp/OB3sekDd/y/PnIz8AjKKcwaQJJ1BW/uesjk83oFJDozrzHz4MI8FjICgKeGaUFb7sBWG75xnlitbDE4POe6OSWlCXfZXJxdVkuRqTsTuuaMqE8f3BdaJq/XfowVXBS1SG2Hm7U3EWV8vQ0PJXpnmDhSmEqbSImMq2RMtJfImMdFCbaSy0fKby4klLtOb5YVp/rRGHJ6hsewmBWvmQTFxSAIKsBBCiigMAhSDB0NeMd3mSn0A9q+m6YIFK42HAW+3F/kvdMq6IL2dPobDQYGzEgca+nQ5QJFFu1e8ZXZXItP5FDN3X4Av1oyDcFq1zWbH4YI+cBYOFuwwg3CYFYWrHU9/f7OlCcKq8bsW+uNR0E1phrBBaHa5+tLVHwSvU/Xak4gwD3svWkKQMWOu8G2nTZudink7RjfiuAsjxkE4C/bpQ4Cz1RWCXEd3N0+sDaycVwJLPjePiTmTdmCfWdAwg3qfSarQ4v
 d6bcd6ng
 4yrQX5cPx3uz26EKrCMRuxvag6XODIJtF2kOzIh4yLjXdbctdR1esnhlSZXGNmXsGWX6OATEDgjoZmIh7sgCsRIOCFWr5Xat7iKHb5IsQpk4XVVR7LvxZbDmRGC29WLwGAb+L/YdpUl6snRYjOnSB8MhbuNELolEK7XOFoNIKT1w/44CvM5PVt3TNGb9/zEvH6Jfq3j9rJTAzjxLe62XmppRAEA1j+wCQ1cNpYge8/oy0Gzw95vC6T32TKGvjGvUkWGQDf2tIAjOIwUHJrcOYsNKIfn5RcycOinDxeNQ64r8A2+XhQQC7Qse7AF+P1QqEddyKMCeBleWlTJb8y2RPkw349kldOHCRzMElwTZFyq27joJa9xMUQqDRtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 11:32:37AM -0400, James Bottomley wrote:
> On Thu, 2026-03-12 at 09:57 -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 11, 2026 at 02:40:36AM +0800, Kuan-Wei Chiu wrote:
> > 
> > > IMHO, the necessity of IS_ERR_OR_NULL() often highlights a
> > > confusing or flawed API design. It usually implies that the caller
> > > is unsure whether a failure results in an error pointer or a NULL
> > > pointer. 
> > 
> > +1
> > 
> > IS_ERR_OR_NULL() should always be looked on with suspicion. Very
> > little should be returning some tri-state 'ERR' 'NULL' 'SUCCESS'
> > pointer. What does the middle condition even mean? IS_ERR_OR_NULL()
> > implies ERR and NULL are semanticly the same, so fix the things to
> > always use ERR.
> 
> Not in any way supporting the original patch.  However, the pattern
> ERR, NULL, PTR is used extensively in the dentry code of filesystems. 
> See the try_lookup..() set of functions in fs/namei.c
> 
> The meaning is
> 
> PTR - I found it
> NULL - It definitely doesn't exist
> ERR - something went wrong during the lookup.
> 
> So I don't think you can blanket say this pattern is wrong.

Lots of places also would return ENOENT, I'd argue that is easier to
use..

But yes, I did use the word "suspicion" not blanket wrong :)

Jason

