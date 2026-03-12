Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCEA105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A536B0095; Thu, 12 Mar 2026 08:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BF66B009B; Thu, 12 Mar 2026 08:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01EA86B009D; Thu, 12 Mar 2026 08:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E41D16B0095
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:57:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C3F61401D7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:57:34 +0000 (UTC)
X-FDA: 84537412428.26.43EB27B
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD9141C0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:57:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=bFTTNyhm;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.179 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773320252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1SF1XBHkHR0j7NZVucv0LxpGoGXl67PUefLsfwpAbo=;
	b=u+B7pzMc+arKHF+HAzHTJ0zpXX67NYowT2OFLAxNiH0uEKJV/FQ6tQKhQgDIO/DwGOt9M7
	72ac67ytZn6S7OnV3Kjn6ZGInaH0blue+RZKY8cF7eRd5/Z82icWrjDYAycGqCeO5vJ6K1
	LAl9wh6BQ4yY/rLDfoyEyHet2BbZJ5E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=bFTTNyhm;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.179 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773320252; a=rsa-sha256;
	cv=none;
	b=hQBYb0ZAG+M6vor1FVXaQRO/KPvd885ncuLhQ4eNXBV2oyBVyUhHA/SrTdGlLjq6q8wEOb
	S8velr7vGdc+04AzA/2ZZgNeAk13E71VTx1MERvuerbQopmF32YY3nV0LdHNwGX24OcrXE
	xrBmDPTuKY+QEu5AoUuRoJ3NHAEBFCE=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cd80f56b27so89289185a.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773320252; x=1773925052; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1SF1XBHkHR0j7NZVucv0LxpGoGXl67PUefLsfwpAbo=;
        b=bFTTNyhmKSR+OJsrqRO7ZVFJtpMc4s3h7tB/rF49QID5YM6UyNw07jmKGC7e+GllEg
         WrN1kYGSVAarKaj6CHXbcq6bBoWU2suPsP8dJ95bAeynLfxN1tmwncBGyKCgqkvYwzFj
         f4XjuybkobGn+XT3+LkRzJe3OgQHPjPtRusyMHCnUbUtSC3k7lh/9VIuKc5Lto2VnTgZ
         zZmtHjw1gefh5wSVouVwWhr+8IQdp615GWoEnfjMUeSqliZbo3J6KlYzXzTy2CDek9LV
         TmiwQZ6m9yaEcqANifqB7fFCtadB0FHJ8/ENIeq04tlFD9OXhnYj6kY1GsafOnmrarGY
         0R/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773320252; x=1773925052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1SF1XBHkHR0j7NZVucv0LxpGoGXl67PUefLsfwpAbo=;
        b=d5U466fD3nL2hhCU0hsB3Pv6gjp79B4PKQT9Kf20kfVXzP2aUY+csCRrQQbnABeQI+
         TYO5f/m8kJiMKDr83hKft/RRHqcSd1esKr1Q/h29KY0E2+PIJD0Q01/FKH46Lg17GPOH
         ee6x3eZf9o2dM/gBjNrIVKcuD2lbTyqLHfUwVjfclRCNiyNNat1K10RXlkCgF6SAHHEX
         fW+XlYQxFmJY8k0fnL3ZTishH9xuMGuhMdGcNvtd+4g94jJaU1SWd5fpUUYUqdCXC+M7
         /kkMuolnlRqHwWUJHLWRnhb4msbIY2RGuy1usqGb8P2JDFxSMbqV+XCiESChmNQU1BI/
         W38Q==
X-Forwarded-Encrypted: i=1; AJvYcCUizJyK1TQrAligdBq78FNIHh87JzH6W17+8faKw8CDssUlhZlt7GrLCvMTb2y5ppGCOEcTM/5c6w==@kvack.org
X-Gm-Message-State: AOJu0YxWfKzoE9m46wn+wMdq0EO098lCnLRbu7r8TfW6bMd2bYuhgRVI
	2pvVIMc5Virt/OHfRKdDPSwvVdd+4o+u7JAunUX/CIuqAzOtrd44LRGlyOY18oUs4hE=
X-Gm-Gg: ATEYQzweSdYHv12OTaBsF1q12AEQsHVeYRnuGt86BEpPLmEKbfvCIhtbjpPRL6jwNgn
	41jLmd1XQHe6saF9jUIknjAz+ruV6fSNFHZHfgfL86QNHG/vRMZ6xqs3MFcia5x3KX7RHeU5jXk
	J6Fw7N21eNx8DU9LI2lrisu8JTA+MPLatZQ9QrztpCidVdbnozKyJJoiY2liIxO/w75F7QKjEMR
	YB8WlfHrZOzKeTYbRaBE+b5vImOgYza/sjadpJSwBUS5DmSNT2sxhNyjES7DhRSHyvPZ9ZMOacd
	uMgITRSlhf3WS6TBqxH1TlS7WGfxcbPROyCSp01whVYBPOlvzt4/s8kWp1zFJfadWOC/LdXybis
	QVxWzFQLV38Os5LZoIphX4GhDYeFCgokcLchJL3prnJK8uP7J2T6Bek0VjYvDRxCCHZdhNrgnCe
	bbJhabSSiaJfrYwsjqmG+vBJ2W/xPef3A9kC9gDyxEYt4EJBSiJAc/gUdvxsBVKjOO2kNNzN56t
	hyHFbRh
X-Received: by 2002:ac8:5d4d:0:b0:509:cbc:127b with SMTP id d75a77b69052e-5093a1bd58fmr77950521cf.60.1773320251710;
        Thu, 12 Mar 2026 05:57:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65bd318fsm33341196d6.8.2026.03.12.05.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:57:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0fbW-00000006fKD-1POa;
	Thu, 12 Mar 2026 09:57:30 -0300
Date: Thu, 12 Mar 2026 09:57:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org,
	ceph-devel@vger.kernel.org, cocci@inria.fr,
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
Message-ID: <20260312125730.GI1469476@ziepe.ca>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <abBlpGKO842B3yl9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abBlpGKO842B3yl9@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD9141C0005
X-Stat-Signature: zx3e9mof6gtf9iqg8rp8kddub1o9gsf5
X-Rspam-User: 
X-HE-Tag: 1773320252-382931
X-HE-Meta: U2FsdGVkX19F/4rVLXXo91YWRLue441mKSQQ2s2F5mJ6V1lIloRwqkFGtr0xWQUDE43lkUhDPAuRTeknlRw/9hfeJj2x2Pi0ep4UkyUKucqNjMdlv/RwnIKP2FbqhPLnQiKzpE4Y49EIWazdZ/9tsi4WIjF8YldLDquem4l58/dSj7ydlgQvJwnzxticWurLCwcb0Kflq7YGm2QLEnm+4D8d6BkryS8Gbvuw1U2IqeTgUS+3DnkC0O8EDISu/vtWlTP6fXBugB7nBkV2Ol0l/hpqk0QwMhAt83PsiR+4+hMuFQii1yta3GQVPf//xD+xk5eADqXe+Syy58aIT4sb+rH/TSFgui1v+33XNQeCz72bBm0Qvrj0P7WgJgJ0UeCqSIlQjSVKJ7hpY4BWTsyBXlt6t2Tu4aFSyLm2rrv+CsODWjINi/t5GBFtxSzDh9bqSYlDtOg5snlgiycdw3zCr7ynj7eHBjOAljUM63kAENIEl9E7jZbb59c2fiK5pjdH3qOKDVK47vLoPpaiWxEVoqQcPi5oO/w/OU/vdB0reJ0A15oOR+ENu5Vdf6EI2oWvhr0jCU+OyhgYIvyK7eXYNqWEqKhxABF73xBq1eXp62+xdbiB5ph7DjfBrAhyWfp1QsciNtIVzl6T/Hh5rhzKDo8pIl2H4qQ7FwJgN4FE/aInHAv3sqO/L/w2YvsTeq+VJRc7zyhWpW48sxpsN3V4cg/u5DtvVjgAeN3DC8b4UV1wUoIxGgLG8XMEFDJDAnmo+yvqVKj1LmzKEljWQLlMx+/RuBol7KDP3faItF3k4EgYZH9jaBnReE9HBUL3V0xBbVtoFQjzaPktZAPZSO6rv/vSdzYFooV9suixaIzxICEo0lbKUUK1H19x/XgfeqjMlt4d8fZU/2OKTc349CR6dx5lYdK0MWosCOrkWYodU59xFu3Zew25i1cACQClRKJDYX85hHzY5YiZCOvdSy4
 /UlGKbi4
 six8vxL9EtsDxEOjtw7uiFNAGCrlD8CA3HZgs3sg5SCOqpTyLk4m27CdpDEY4B0oi3xDlhznDszygW7oY6TVwscTbCUy/DteaCXbBHvrKpkBaACsz4c1Rqt4dtPgMZjBAOI86doDUS3pm9hmzLSuwvQ4lzusrvNo1tg+adAUHpcqcqYcl/DSoBS1ADLVe2GNkHy2fTvMsRaTbMgXNPcV4kGrB2pfZhrdvNaAk0GxcTE0AjftMVQRplQmyyZcN2nf3H/D4ln2EugQQAH+EiFfT3v/SHlLewWemjI8SDEPtBWUKvAWHUYWT8nf5TNV6cSEh/D382nKY9R7JcdHojHFd98otfGMQuOtkA9l0i4e83hX4GJbLl97clIGixg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 02:40:36AM +0800, Kuan-Wei Chiu wrote:

> IMHO, the necessity of IS_ERR_OR_NULL() often highlights a confusing or
> flawed API design. It usually implies that the caller is unsure whether
> a failure results in an error pointer or a NULL pointer. 

+1

IS_ERR_OR_NULL() should always be looked on with suspicion. Very
little should be returning some tri-state 'ERR' 'NULL' 'SUCCESS'
pointer. What does the middle condition even mean? IS_ERR_OR_NULL()
implies ERR and NULL are semanticly the same, so fix the things to
always use ERR.

If you want to improve things work to get rid of the NULL checks this
script identifies. Remove ERR or NULL because only one can ever
happen, or fix the source to consistently return ERR.

Jason

