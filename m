Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB6DC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB2E6B0096; Fri, 28 Aug 2026 09:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2C96B0098; Fri, 28 Aug 2026 09:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9096B0099; Fri, 28 Aug 2026 09:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9E1F6B0096
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:07:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 380FF1C1CD9
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:07:18 +0000 (UTC)
X-FDA: 85150704156.22.EB23364
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1A364100013
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:07:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRm7LaJJ;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787922436;
	b=nwQplrnh9hfiMyznADoSM18/1dRacooOU6JjlPcnG6OMZbkb0VpMEGfAqTqAaIddURc4sP
	r0w9IBAfnKJzLBx/vF7eTehTVJDvKsME8M5GxLz5aJW462Il3VgOfEDAYt1TVN//DIQd31
	zFYccyNQFBomd0/jemwTZ2BPatnz3o4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787922436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YZkfUvCoyZHLzyn7ea4/HyPggA3fnupl8cIKNYULpk=;
	b=yf8xa+0BxqaSHwTIkITJuTPKNw1ldEJpNfAVNbfTVWEt8lDDFN6Cih0g3GNq4qByPqahW1
	FqmbottNzH2OyWnQlUDy/Jsku+9wuXo0Pi+9PBOITya8jlDuIjj4/Mo107KrTNAjhVD33+
	pijYH6RBouK+tntA2GZl5oZblBex8YY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRm7LaJJ;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55E2A601FE;
	Fri, 28 Aug 2026 13:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D408E1F00A3D;
	Fri, 28 Aug 2026 13:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787922435;
	bh=1YZkfUvCoyZHLzyn7ea4/HyPggA3fnupl8cIKNYULpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HRm7LaJJEXTiDiGTKCZo5l2w5kN1TcYSeJ9E48rQNiz6LBaQNFB2bKP4AHBipiq8h
	 YVxk60l2Cn6/hAurga4ATD+2RfrWaG4ySotIPL7Qda9iFoOVBwRrySKhWI8pVMwDPW
	 lCDMccPUxYtiMTthIsnC6uiu4nk97j9lDetGFeNSCozb1O9uQ4k+wY1cGB85jY0D/9
	 HG/1aEtypMZePyyCdCDCBGjvrTFQevBEIc9mmBs0A7lESv4ehPD3de7jcMP8UmyqWS
	 CpNiIA0gRbnxwzBMFGltYkgXGmzpSvL10YP+gw9pKHpmgRulYhQx1YLoWpnGkiSuur
	 62G+Oi3GG3uow==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8728C1980050;
	Fri, 28 Aug 2026 09:07:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 28 Aug 2026 09:07:12 -0400
X-ME-Sender: <xms:_IeRajK6RgmVJ46FUccIDzQvRWEdjch6S8dmzrIwx7mNvrjRLqG7zg>
    <xme:_IeRaj5d4x5Ci1XWPIS3TCKpiy900dh4rtEnSxl0BmtA2Hvig2tLEFQgvutnIBzvt
    q-3uKArInhGg4BUL7xC7LGPevdSWe3B556Hsl5I7aVUYZBSs3HQWTNv>
X-ME-Received: <xmr:_IeRarQx3u1kQ-ANzyD1p3Zn1y5BMkxZDV4rCBfD6g3cXh-AC77MPiRcsKQ>
X-ME-Proxy-Cause: dmFkZTG28vjlh/jrZIe0v56Xspzegu6WkfWJNqumN3G8EyZWPE+j12ot5ZQ3BXZTGKKstt
    ZACDkBdMBDCfrwUht/IM7FreRRPd/qVf2YDZto2H7EgwYkYS27XFH+pXmy/RPr+F+MDrsf
    L+M6NlBc7fDRfJh75IZbb7iLqdI3hKiB5ge75aGaLPYMy9mJJzFOP7p05J2IydJrP/bG4c
    REgPSHsV2nJfQa6/FnBSFrR3eMVRFHifx+Yr8b64twmyBRJDjYQw6NhC3aieIKvXOMWsy+
    TO3LcTQWOtP630Du3jcNhUsiowPO+C1L8ObqZY8hPhIDBpkKC3Uz1fq/qkSZgG4wHmyNiX
    /YsWahIsRswdahPS/RnCCuJqsB6QI9chbdBNs2y8P7C3T99TFvj81/pjghD3wPX4HK46da
    kIlJ4yxv2DsBYdzz88j+nU4qQ5fSYMcudHkWfwlJI6RaXwB8iYWuMY/GVCXuAA3ew9Hutn
    tRBjvnnwqr0KtyFuc1yF7Hmm+J4qAf+YYGCnYgSB9DQDByGDAiWz7yfrLAatv4oB3zv/vH
    FA+guGwkq2fcEAqa1rqntNvVw3v2Q4sz8ggF0bvtDruPLp2A8/9IEnu+HNxu4Q9dyll+ke
    hRhuzhqFAVi9qeaU79QXUHkzTljt91CieuIiTqkTwGV5JSGXglvecUZ+eKuw
X-ME-Proxy: <xmx:_YeRalA8l6VZYNUAL523U4zKBUeKGTVSBMqVhBRXp4dByHijVRZrQA>
    <xmx:_YeRaurwvuIXQV4TICc9DpTz0uopuoDCICelKcfyiSBlqbYvg0p68g>
    <xmx:_YeRav8TUHC98idjHudjlc7xIlQ1JOP7Od1yroJF3wU565HPgpM_5g>
    <xmx:_YeRavCLtUu7799PTwqr0lEzWreAQyfzE7VLVjdXIhhJFZxK-zf-Ng>
    <xmx:_YeRahHffYdExHOR8YLyQK-sgTeSh9Ne3OqfShBzHiGSV2BlMVVT6m_e>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 09:07:08 -0400 (EDT)
Date: Fri, 28 Aug 2026 14:07:07 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: jthoughton@google.com, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, usama.arif@linux.dev, shy828301@gmail.com, zokeefe@google.com, 
	hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
Message-ID: <apGHG9LJtDpe2kdG@thinkstation>
References: <20260828005004.2870750-1-jthoughton@google.com>
 <20260828094703.11081-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828094703.11081-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1A364100013
X-Stat-Signature: 4mkbs5humoyyn1ifomcc6pw7w18ucgce
X-HE-Tag: 1787922435-534943
X-HE-Meta: U2FsdGVkX1/DWWwnSORsF4dSClFRpeIiCCyfrQOvW7gBt20t6zWeS9A9WeYEb6NkK5SWivyDuo0+qcwEInTA6bcqf3ecOIT0DQWYVPgwgYJu1z9eEL2y53/9uhX8qht3yG5wutfJZJM/nNUpbnx8UzOo8/szrjvXEyUxignQs/OgjVzUiaz8JQ4BHd7vlYccTnAynEdYihHd51ppgcQ5mkCEwb/C6ZdGsdg+pI96rXDUl/ORhhfYqNpfNYPbwUwCKdZ19TS+/qBMmOH6KKfcY59BzaXtGS5LPQm6c7hG47NOhR/UFyHxr/Aw/xz/yMh7BH2dF/jwuCM6iAoylzQA8t2pM5MdK7ChOCX3l3UKtTOQFxQNIakX+1chwdGEp+r79jb/u7txXjFeoBYs6LccRddWnJmW+W8CrWOpSlGMffe8yzAvipex4u6ZgVDY68Qw+sDAwq7N7jvpKUcLPxsr/LliZmJ3dFMlgLz0Ku6LJUGa8+IS59okNc12PytBB7bb5TZpLbwnzPe471qLi5aMLto/m1SOLIMVg2xUlW61ZCamTQqondNwMkGrjy2j74FMAF3S/YQi2Dfcn4qC2afNyPRtzToWQJldk/G6HIBPQYUuD/6nYCPovs7+ZAI+6tZ8RxHYjt9UFkyDudWQAEucRg7DMC3KhEJTk20FyAZI7pJ0R8KX4dk2xbBMLnPk7MuO9n0jLyqYwkZCeyIDs0tzDTPLqWUpU/sILeyuPbeeD1q6U+7Nr/QrCrH6VOx7QbRdeTkRnTK9J8NgMTyuiIPSEv+/IoUsggJafFefWmZbP1tZg9ihbkJKIT041+jEkYqr19WTMKyJggQsrPIo16OBQNEF8UwUP94g2JD425QDsim+p31AAm5naHgVxooLCNpYWBRORrjfVwA7FTjWPgzD+EFJou4RIQzMKztIj5Xh/NuWemBLG0kzFKgHovzR50AFQGtbBV/ZaCdpMzLuRMc
 8xE5LFLA
 nDh8FSeHZNfRGzgqmjPe0lwJWy9Xp0ZY361ihI06BIaiFCfhTiMq/ZVUFHI3Tz8Y27bFg6qYVsQ/OWYEEoK9rX633ZSP9KkP7mB4qEq1KgdtVdJEgM/dLxEYXlddrHtwYYNRrmX2ZiU1zRFI7WSe0pscX24andivfHP5bgz2HKOGwRRWJMEnFV+dkqhGF58XGCyRgB5jq3G/7hVCHEuPjOPAJTcPURg5xCWb9X4/QblJj473zOA4vsPtAZapEUifQCuuqaUGMmTK68g1gjBn+hT7VbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 05:47:03PM +0800, Lance Yang wrote:
> 
> On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
> >Userfaultfd minor faults provides userspace with the ability to manually
> >install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
> >map holes in the VMA when a naturally-aligned THP is present without
> >explicit action from userspace.
> >
> >This is a problem, as it bypasses userfaultfd minor faults that
> >userspace is expecting to handle.
> 
> One basic question first. Should MADV_COLLAPSE refuse to collapse a
> UFFD-minor-registered VMA, regardless of whether all PTEs are present?

I think the line is not between MADV_COLLAPSE vs khugepaged, it is if
vma->vm_mm is current->mm or not.

In other words, we might want to allow collapse if workload itself asks
for it, but not for khugepaged or *external* process_madvise(MADV_COLLAPSE).
is_khugepaged is not the right proxy.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

