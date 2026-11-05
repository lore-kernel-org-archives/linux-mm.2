Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683CB606D81A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fYo5p/HM
Received: by kanga.kvack.org (Postfix)
	id 636EC6B05B0; Thu,  5 Nov 2026 11:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E77D6B05B1; Thu,  5 Nov 2026 11:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE9D6B05B2; Thu,  5 Nov 2026 11:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 286466B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:07:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DFC1160AAF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:07:20 +0000 (UTC)
X-FDA: 85401545040.15.6656EEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC487180007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:07:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fYo5p/HM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793894838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYG2b96fyayScxVvqtx3OSAsQSRRGOB6T40PDUmTI+8=;
	b=TKPw9mJUtSzbWFxobZGYvj5QdWbdtdL97VHE7jTgCTOiHk5M9ziXANzVam69XxTRxKB624
	GdrQqyXeq0yD5TfbgjlkhveXiiv16vRcrQR04/mJjY5A9FsdsE8t04k48xFkWlpX01YlZc
	U7xuMgRFhjXrauPTr2hcPY7NREMTu6g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fYo5p/HM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793894838;
	b=aedWD7MduSOI+hI/PThkMV3as/pmuIN2uOe17Ghsm680Exgf4+cg6OZsl4CJenOUm5shRn
	ehVeq/JyPpPRcPHqguvoG4Eh1z+IWNbcQ3YD0DlVeAiko6zBnKKLNuJtO+HNa5ZvVZteKH
	8F00SmzJusjfzzHZZ2Le5J2sKCFQOMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44758602C3;
	Thu,  5 Nov 2026 16:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9871F00919;
	Thu,  5 Nov 2026 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894838;
	bh=fYG2b96fyayScxVvqtx3OSAsQSRRGOB6T40PDUmTI+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fYo5p/HMbU1gpXil/HFCks0XvJiGMwmcZT5vbnMwHLk29sKgRmtxnOzZk1wDd/aea
	 3QO93SZshqmi5XcbWCDImlOImNePvoMJSzaG2b7YVRdjnMMdkX2pMzX3zjGqqi9z/R
	 1giA01W0A74nBvUCV4Evs/Jpwh20TV7FcDEvOARPx86KpxOfYsGMq3+4ict6Zw0DmO
	 s71kK6K/sdKfuvuYgcVNrK3Izbx/cjngYc8wS2qLay+oUhVI6HRfeV9UV4zP/v7cDI
	 sRVdM/r2aEzpO9PIo3TiPHvl/20iU0QuIOji7FmhpavsI/vN/TSq8Nm8/IpxBsuWOM
	 +wCOYw3XpsVoA==
Date: Thu, 5 Nov 2026 18:07:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com,
	pratyush@kernel.org, ardb@kernel.org, shuah@kernel.org,
	ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
	baoquan.he@linux.dev, ruirui.yang@linux.dev, guodongtai@kylinos.cn,
	kernel@xen0n.name, graf@amazon.com, liukexin@kylinos.cn,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
Message-ID: <auypq8_7T-vml5_B@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org>
 <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC487180007
X-Stat-Signature: sxh73an3c6pjxn3oyinojqn7dokxicd8
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793894838-971002
X-HE-Meta: U2FsdGVkX18yg9+EZxMsltY19xzCDT88Ncg0Ylv35UcGLzk4+M58d2r8LKvGn/fSX2i2oFUirFrwXzF++dRcDt7iqjkvBLzogFDNKPzvS8S7FPYmbKUr9g5zYvXVozOoqeYqlx6DvD1A48seTWxwQPY5fDT7Brs7yUwc4iDwNjajNMahq/mORZ3OWUQAYZdl8MyC/fXsH0M0TUVPlnZU4Kxh0lrHu21ZihLRbRDyj/CNa3xfVbKkkmE5b2ZvZ6T2oEbwsu+k7A4tCejEOtaIYkwrAQITkVn8mYDuWSvasiDvx8O9shGwVP2jRf+dPVjrqSDAPQAUXHWakQ8YqS7GFivuACK1s3Svan+ua9W6j/Wu6Ri3KOyXMfOp+aqqnjfYxiaatsFEYZLDzCx4uUe997IZg0MI9rLBhN75Nvq9fLzahEatD9XpIbn8VozlT0t5yeFewYTf071JMYQEudxcnwthTLy7BrkIC/R0uH+ng/0zG2grDSchw9KsciGGh7itYKhh6bq/ivSdOT/HIUgRPFickHPpvXCuSHrvTWn9Yi5CO52RAboMSKQGc4tpJuQEYc9OdPB1eQDs0JOv/zRtHxVEDuCI4WEvL3zKETIwqyBMDtpsYrO6vLk7hJIJIricscyfXO2JtG0u8FcYQ/olZFZ7w9iY/kmXYPMlinJ7GlWI/4bSyrld+5ACpjEXH5mYKHezUvdvZiNZ7XACYd5UpUvzChmF19pPFAcTKwzcr2DOT71ViayFUleqjJNCGoMfwtvbkxBwP7G6NuS8wbO+jQQNuwgkXRzpEdIHwSnaG5vx9PHk6x7cat+S8a94wUtaU7tudeG5WLO7vmJQ9ceNYqxB1BL81mUpgWWjrJbSMl9s5qhm8gCXrrMRT4q7w8ziXAkPIt6UferewM1SSyP6EqTWY/MCfOyQ23DTmnz4oEbzCScibz+XB2eEJhqbK+v+JiNSRA6pt33OUIDSmaK
 GH22q1lD
 Jp+fyLyV/W1NYqwF1lITlefaVoEwZnn7I2bYh2hCNIj2zTk1HZBG/Zc3oYvUFC7rjo5jbUJpyjd+rteinX38fvrEHFs0GYoaRgIVhQV0TlC/38d6KM6cFBsxtBUjYM+cYV4sENm10U3lf3kCyJc8jtl0BrKKLv3Gps9zPv9ab5QNuAWsfi5SKRppuucBnkNmlTC0coxMHUjdHdMzam7FABvqPWpbsf7gz/jkWrwvJY17xoap2t9Ka7Sp4DDZoIT3EjgxV0ggYJzucmkP4J3a4gZPhF2d8kdwCe/bC5oZzaLIiOs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 11:07:01PM +0800, Huacai Chen wrote:
> Hi, Mike,
> 
> On Thu, Nov 5, 2026 at 8:57 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > > From: George Guo <guodongtai@kylinos.cn>
> > >
> > > LoongArch never calls memblock_allow_resize(), so the reserved region
> > > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
> >
> > This might be something to fix independent of KHO.
> >
> > Huacai,
> >
> > What's the reason LoongArch never enables memblock resizing and why it
> > defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
> At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
> boot failures on a 128-cores machine, so define it, and the value is
> similar to arm64.

AFAIR, arm64 had to reserve some per cpu data before they could enable
memblock resizing, so they had to make it static.
 
> The reason LoongArch never enables memblock resizing is because the mm
> code is derived from MIPS, and MIPS never enables it.

If that's the only reason, you might want to revisit that :)
 
> Huacai
> 
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.

