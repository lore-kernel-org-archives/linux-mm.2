Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AA6606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KydYkcJZ
Received: by kanga.kvack.org (Postfix)
	id AB9B86B0791; Tue, 24 Nov 2026 10:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43CE6B0793; Tue, 24 Nov 2026 10:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B676B0794; Tue, 24 Nov 2026 10:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CED46B0791
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:56:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C763406CB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:56:42 +0000 (UTC)
X-FDA: 85470465444.27.F62598A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D542118000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:56:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KydYkcJZ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795535801;
	b=s7WrjZUHxWe1PpBP6AxfZ1gmd6v7oeXcA+3k3A0kbgWG9vHgD4FvWmTRhWKAwtY40/ALWS
	/CCiynlgunAuUCZabYMWZnJGoWkDL+keFlXud1RXz9RN3V4Gz9pqVMAJy+Rb+5sYBJyVFR
	ogk8UwJXYATLMgohJW8vXi+9P97fg+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBmlD09t+us4vgRnqALAcW6AgVgBCrAuHVb46ePvY5A=;
	b=X0iStLKn2agMOJlDSZrMiT8w649M6ctic6esBuz4xFi8fIAp4YzsqbDasyRJOoNFzTR1JY
	LY2G3YQK1wMeeuKX7s/1i6Vx2TdTGknljh8e4ntmHFBhD/yz7M0yFsQ6U7FINpaYvAsOba
	3OweZVixDrQznibOUEQ1ThOfUm5riCg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KydYkcJZ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1749A43E3D;
	Tue, 24 Nov 2026 15:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27B61F000D3;
	Tue, 24 Nov 2026 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795535799;
	bh=DBmlD09t+us4vgRnqALAcW6AgVgBCrAuHVb46ePvY5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KydYkcJZ7NV60VrGLHtYGZOrlFrD4nCIdia+Fr9/pP1mLBU55VVlIzRvquAwV4rSu
	 EBRaq55zMQJ3CoTg6DdOXF9OPxB8TmgqfGCXmS+Txpvoh7YIh5AuPub0oN15hgv8W0
	 04s1h4Lkc8nJlZvGzSyTseInrPdvQaQVfuiNKZFIUF32y6qqP8zBqNJ9WjdtgasYPQ
	 0NElvY00Vo4eoG4mTsyyslCse1pFUct/egcqU4Md+Acv6Xc5XKktszMpsFgoiZA4VU
	 aMHIoSbhXZXOvNNMAaTTACBBQKdxxvfjkp5EYxVdCvCzOVSxc4gbFWfHAakprOcBR0
	 r5uVcrehSUTGQ==
Date: Tue, 24 Nov 2026 17:56:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in
 confidential guests
Message-ID: <awWzrkLxfQ2_ODKe@kernel.org>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
X-Stat-Signature: hwmi74xiwq774egowz7h4wr3y3wojdgc
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D542118000F
X-HE-Tag: 1795535800-689410
X-HE-Meta: U2FsdGVkX19E603CO4m5Xk9kb+9iSbu/E6CSR2PHcYbjpSItdKKWHIeaxHIob2ZjKOdUDBpFpV6vVLJ6rRTdZX6u3Fy4MAQSolMLRM1sHDNAtlGIdhKw7x+QXG7OMZQOWAcwFNsqOg8sa2A4l/0S0lcSTeTlhXrBURQBgs4X3PEK3ykQhGMXzZNCZaCLyW9tzowzHLtCe3JRYtIDr1Lg5L9wrrWzrypRJbXCrT9MAxIaObErkY/CHmkyQsgIMYaEHF7iTMfejdQTcgd1j51HM+Rg9kH7rF2YDhx0m+GiWIebG7aMcz1Hh8V+2h+ILuhY/oumAeLFX1b/wYcw/11kb8WQABw0oW4Nqoxm1nr7sFsNlDNM/jh1MyTky43Uc5kQzamxQ6x2eC3xw7Drnx38jyZU3hvk3xuefo+iceRF31kINf6xCuTlLsdz+dLVVNrav7aaaeB8dYScnfEWtPjYGX4EE5NlZZ0J5AO1V0DJbvgvHtKcvf3YjAQnjnmS193Z44lp5Q9hMiXnLlkLzHZsspIYc0zZir8Io/BLmvsT3DUQZZZ8pxqqcp1CvroydqOCac1OgGtKrmOPlPG9CNeL/dolnfLaz0fqRSH3To4KGyARSEjF7/rKbwq/vR85bfBLdDHJfeBxTQMeztEJgje87n/F1ithGqR+Prm+rXJKkAaRBhtmmsi1nq6uGqptfaxdPPZxpurBaoZmFyCTuYQKR94fduOwC8Xz5recTjRcA4sXMbm/m4fE9QgjnSwCt2B/dhcTjcJTaMT2/dQozQhK1R/8b3X0ho1UUHSGpFlqZ3jslR3ynyEgoV6BrG/cyi5BgW75yRBgiJJmCvC9WdbWjOmiYFc+J6QAlC/IET7DxVlgVoFwxtN6CWlV7+cgK6OBOqpiD4+odJgiMx0WEr51qE2XQXOa8sZH8jtus1vxV/VTwEFysl4Sy6aKzhcF7Q4HBmeDMJ1wvAXLmLzgk/3
 s890chqB
 +qxT5S7r82Y9Om7tc0xD/fpS1VY+JVguxDf3L+YcnYF+WFpbhSBnGZb8SQpegXj2ayfjR6uDg4xNdYGSIxHQJZe4m8ptY6SnXfpv0mZfPd8jngi79U0JrNfqx6smh+L5/ee7Ue9B1TQ1Yw0b8nEOjGBkPzepLenfUQ67Jh4wQliNqSIV3M5VxMEY0s7ZPhTR6+XTbVZcDyYYLmwNGA8Qe1LPsAzmND3utYDBjrKFm4lmCUcMv6EuIqBQPvrmMfkdV/LG8cuJYf/d8zcX8R/7EXoAVRoxKTS1GJJ1XAPCMmTrxOvQwMRA9i29eiD107MlUNic8xf6J/N1wFDnT5Me+Alz7g9C5VisobYW2jbvmMn0i5fgpnPwiHHO95zVHUaIMMBPCpzXpnVk5DItjFXc5Sqw+JLpBk/8Mi4FOEgZ9VZ7CVgsGDDlo4xfvFywDy/c5OigWpGu39f3SSUGF7/+O2kgTIYpWC6jlMmPEVP3lfuEOOk6+3HWgF++/4khaZbx549fsO/XU1eTeHhluvEqxBSJ2b/0EPn0TcUkVHVmo+rhnLeApG82qJR7oGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
> On 11/24/26 05:32, Pankaj Gupta wrote:
> > In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
> > memory bitmap before the command line is parsed. memmap= and mem= edit
> > e820_table only afterwards.
> 
> memmap= and mem= are debugging tools, right? 

I wish they were :)
But AFAIU they are used to carve out "pmem" or PFN-mapped memory.

> If you use them, you get to keep the pieces. Why add complexity for this?

-- 
Sincerely yours,
Mike.

