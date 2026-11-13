Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A65606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lvj4yY1l
Received: by kanga.kvack.org (Postfix)
	id D461A6B0715; Fri, 13 Nov 2026 07:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEEC36B0716; Fri, 13 Nov 2026 07:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF336B0717; Fri, 13 Nov 2026 07:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93A3D6B0715
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:56:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04E1B160293
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:56:07 +0000 (UTC)
X-FDA: 85430093616.14.ACF9429
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EB1F740003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:56:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lvj4yY1l;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794574566;
	b=VLGbwAyF7ScKgcOfBEXD7b6AaKYR7VKQfkeUd4wdWG/zwUkSWa9qKTQm3j7AEhdK4HONNm
	wHt9HVlP70ruNfzLudDfBMO/3gNtKYeE8ZDy3Z5tz+V8SQafIvzurFc/DxVf7BnMk1mHy/
	VPqtPi0P4vuMGeGgxQGL3yOdc4SADlg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lvj4yY1l;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794574566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tSzNT5XSWSixiegslDJk3QLG0Zr8jciuO7mZR0zc5I=;
	b=34yn2ElsX7H7xqwgwnjyeabx3SSNJpiuXYwW49UeKWeWC7QR9mDVgqSezUCYxvCKorxSkb
	2Mh5rdo0L+scvoh5glRYv9gMR6v065VNOYT7EbiVLDLGqORm/WQdDrRjL79/AQjBdH1/XS
	vlovP+Rki2uwkYsCSwoJI+sOuREsiPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5594457F2;
	Fri, 13 Nov 2026 12:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F9B1F000C5;
	Fri, 13 Nov 2026 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574564;
	bh=4tSzNT5XSWSixiegslDJk3QLG0Zr8jciuO7mZR0zc5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lvj4yY1lMbAfCFEKpUy46MLT7MIRUMSw/9DvQi0lCqCyfEEWLXHLjrYGbcbvlyUgd
	 Ee42FemA5b21zkdvvm2EAcIpaf0CjIEWN/7EUqsJjyBITnPtmVDcsG4MPROXfIcQFH
	 YctRCRfK3yh8tnV6DyDCnIiemj6ANeOP5P89LsEZ75NDg646Bnpu6/VKcK8z8UH3Wj
	 UHidyE1JlCdHLM1Gxtue3BpiaLFJ5AEJKZF3ACXzZxQreCex3EyZXGaYou4/uM0qna
	 q9HmZIM31Sgl9Ew8S87KOh/SHp2hHnSzP38MwKYuY4xgcOd1he+AXwpFMLvfpsL3my
	 TU28frsWTH7IQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id BD18B198003A;
	Fri, 13 Nov 2026 07:55:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 13 Nov 2026 07:56:02 -0500
X-ME-Sender: <xms:3wj3apbkmeonf4y5wE7ksEA3GtTBf57EWzkWE5neafKKC3LIBFU7qQ>
    <xme:3wj3at7H_CSaBiiK8MxPCWEXxuf8_32SjEpBm7p6t46otfyshxxW0DySGHZC2nRx6
    o3CnKqCMg3AcqUsOLjzzWxJ3gE-E_jODyZZW59-0WOiS1ywFfQoHSLq>
X-ME-Received: <xmr:3wj3aoCjT6qOBmsBWaEBbadIi4IKYX-_viGElTeJ1FBxXk8-jPLWXELZq88>
X-ME-Proxy-Cause: dmFkZTEALCY8BjEB9962J19+FFzaFn7/mDszJU/f0IQoJYE08F9eNi9AROuRlq7pU2+FXD
    zoNVXqKBs3ph2NtrQiIbObaLyrIngOHx7B+sdK6iQ+jfItZBvkvsFLopEHbvs6okBQgb5T
    T3FhlyqhoGdVKxR9UvwevmGemWC2pw9RXWPJmT/hEImGxMrfJhZLPtavP/c6QdWQg/A6b8
    X5O11D6kkCylwxWMIUDUmx1JRIy29fX8Rzvm50e/adyzuWb9S0hJRhcuwm+lPAtw8FuGn4
    rju8p9vVIWIvL96aJgoJcn0XKhXQzZ1uUAuAH7wCb597h85mktgUj4cIXuqKo5YXHCqSYw
    ObzBzC+xeGRFdSq8OK9Iw179SQq7JXdMgizRPjcfc7bMNY4T6epVxNLGOJxv3xUQSLR/64
    Zxw6vhBrfWdMRycJp9of5fwiEuNbYcgfNCpCp0cn3gxt62aAog+aWCJXFmQAiNZCZkWG9B
    lWC/3udG+aiOLf/DbuEx2ykJWJHQaSgwcHKmqXrBVIxChV1yPNGmyFR+DbWWQVtVmpRQwj
    NtZPNHIr8/CvIjr/tdwg11qigVVQJPIqaWNhPn6ysx/4QZa61YdCJv4sA2APKR+gfMKL8v
    obEc1lTb9YEpWYZIrpyfGF/TB6GjA8e8r0Isgz4pTIYFCflmX0V2H1dmabRA
X-ME-Proxy: <xmx:3wj3ak6FPmng3aMbspqR6Igf0D2sIbQk1-6WorKrbKKADDHG0AAPMQ>
    <xmx:3wj3anJXJB8Zybw1x9dD0vuFCyrMwqOETaiw83FKYEJZqKOlm8gtEA>
    <xmx:3wj3aoxiwa_YTR87D7tSQQJSTL7TiZczR50Ez5E-b68EkZsa0J6kjA>
    <xmx:3wj3anFPKaQGh8qkS1LHsQZRjpVPAb0cT7GRfwH9jf9WeNj9M__Iug>
    <xmx:3wj3aoklSg9r9EGOP_SJS-KycWDomPYN6vpd9TXmeUML4jPK2OXNFZsy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Nov 2026 07:55:58 -0500 (EST)
Date: Fri, 13 Nov 2026 12:55:57 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/unaccepted_memory: Do not accept ranges that are
 no longer E820 RAM
Message-ID: <avcIhKCXFo8Pn01U@thinkstation>
References: <20261113105554.199912-1-pankaj.gupta@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113105554.199912-1-pankaj.gupta@amd.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB1F740003
X-Stat-Signature: 6qfjjabcrnnaoojkxqdb63t3cbgf7zmd
X-Rspam-User: 
X-HE-Tag: 1794574565-324282
X-HE-Meta: U2FsdGVkX1/P4CgVYvgNSg9O3IPZcPsjlDGcAkUFOq4Z19TeBVpmvlPU6A+L7oH2GZVIf0UL5M4+lyRNn1aURg9RIM4O6ZOIL3XQpQUDqY5xANN3TDVP8NfhfQb/swAyVVRhe96m4drZbp8vdkSViYIJTBg5xHr+4QYMrOpFr3IuNlznL9b72b73QA9+QHhNOcKoKAFt8l9fXI8O4BgquabFf5ZBer9lEK8iSwK+XHP7QQamMp8BP1UN37c3Gnlak4h7Yy5EUS0HmF3x6aUuEkalf1GxKKNOjcfloPzUekBx87PKFjSsyDqxh6itUR5EZz4mIfqNvrE66sb7YlOH2kWiFfc+Y/3RxWiCrt/PMyDNFD/dl6tLGhAXQzIecseoyOa67EXAcmYp9hBmjvgGf+GRlm/A2ys93Qpx4noDnh+T7IUuI6R0CKKooD1rx6grt53seOo4ClSqObZKKC+nB89HmlVeebiUwIHV64hg/JeFpECdqFB1VaWlwrKs5QwyP9bVuHzoQ5s2gQMOSb/ksQ5W4A/0IgGYgK4Hz21TGhlp2gKcUXVIxfz3sVCCMLGuIrUXtjRi59m4DGSOeoPOuSJOt/xz5VNLCrc20JQQR6cU+bN6XubJo2i7tPyLEOvm2ClOfIgrh/LKtZBWnzqfm5AyMS9B6pfNJHbj2subbnd2LKHtF2zd7BtvFZA6jF20+p2OC5lfQa0nRvNN1StamjMi/2xn6mfX97m1zIb+fANJMLRo8/dOQRClpZVKMW7q+S4IQMG9AHI6rd/qo0Qmq5Kj2w632plESoc6ePSC3y+M4UD/hxyyMMmGP+xTuXUhuVY4V/M356b0D164yXOAZNu1LWjYJfaHS10BGJz2/CYUYAB+y4JEKukdQxuHrF3F4Op8hfrzKpJk8nb7D/frycIjgy8xp5gB7jpwQXROmpoEJM6l17HOuLMS1Z8gcbthqdtdj3YeFGxsWVm7cwB
 wzLQxvgH
 zwb1hacenGeZD8fGG/+inKeydjjuCDxO1wfcZTtPVvh3pl/pgLkizZ1CPDfOSC3HkCJL087/RR7akGR4IJCh8/8LCy+uiTOvBVdDvTEULf6snQhbhDv0ORN59zq+6Y8+Rv3nX1W4xYLzG29YeLCEs8YSpLweB76UsdnBIK1Ob8zor05jQRV7kePkorLKOcPjoysAtSdDus5mSPYC7SZQR3gX0aMaq9IPF9TiLVCbcM8Q1Sj9nJsj+YWJqHbdSwREgHMOpnNlEaP8EArCBKiQb8NnObCt5x4/oggsU0a4jeXeCyhtkDpDHISVxAQMrynZ3JowAYLFCoHfZWm9Xv699erXtEakDBSO3gM+fug8tfq5MzgPlWBU85cIzWq8h5I3zR9VJYWyEsccMxowe/eoBFZZQ3M83pMtc7fBDt38kHnb5V2Ea2OjH5Ek+0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 04:55:54AM -0600, Pankaj Gupta wrote:
> Accept only whole pages of E820 RAM, and clear the bitmap bits only for the
> units in which memory was accepted.

A bit in the bitmap covers the whole unit. If the hole doesn't start and
end on a unit boundary, the unit at its edge is only partly accepted, but
its bit gets cleared. The rest of the unit stays unaccepted and nothing
records it.

This kernel never touches the hole, but the next one can. memmap= and mem=
only edit e820_table. kexec_file_load() hands the next kernel
e820_table_kexec, which is copied before the command line is parsed and
still has the hole as RAM. The next kernel finds RAM with a clear bit and
uses it. memmap=1M$0x1fff00000, then kexec into a kernel without it.

On TDX this is new. tdx_accept_memory() works on physical addresses, so
today the hole is accepted together with the rest of the unit and the
bitmap stays correct. Only SNP needs the direct mapping.

A unit cannot be half accepted. Given that, should we go with what Ard
suggested and refuse memmap= holes in unaccepted memory instead?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

