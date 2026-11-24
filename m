Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E61606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9S5gsaK
Received: by kanga.kvack.org (Postfix)
	id 53D6E6B07A9; Tue, 24 Nov 2026 11:14:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED9F6B07AB; Tue, 24 Nov 2026 11:14:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B116B07AC; Tue, 24 Nov 2026 11:14:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25E6E6B07A9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:14:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD254A89CC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:14:24 +0000 (UTC)
X-FDA: 85470510048.29.DD85D15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B2EE80009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:14:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9S5gsaK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795536863;
	b=AOqGyP6h8tXps0EVyHQp/7cALGS3t11K6CcSCvngbSiXcWYCcGG4rYNYwtBeQ77cbzfFkO
	Mxht3OrxGGSpzU1orS1MD6HMkeWc7bH2lg96HWPyN8X/YP+98XnHyZhu5opjaKPMmt9ebC
	9wGFrkbxJM07w6X2J6cyN4hpyS7quPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrZPcXpujul/0lHKoTpqeKk2rEN77o0/xsCu0c+kPzk=;
	b=ey3GWOXxBa9FGlS3xlS++huIjnI5kB5ZZFJhX9A/d0xhH2j0438NlnhooA1AibujWzCt8y
	PRwKMjGxA7oQQP4UzTyiUMKQ1Fu7L6Lr2I7V/ecdjMquPs7fjUSIcENkMvlA7blSaR3BwF
	iXtrHdHeRdgmQz2mAMfofCp72qHIDXo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9S5gsaK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD37E41F46;
	Tue, 24 Nov 2026 16:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAAB1F000C0;
	Tue, 24 Nov 2026 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536861;
	bh=WrZPcXpujul/0lHKoTpqeKk2rEN77o0/xsCu0c+kPzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b9S5gsaKM1pEhc09ZRSKqeE5LzsmM0Rch2EIYoXBLn5hFQCbGTZXqgnLIgSaDPnEl
	 IBxlX6mGcjSAZFKw3M6SOnF5FfngeYDJXOVqHmZ7aJofIs5BCqipkg2MsGRPiTSVeO
	 fOVKyc07oysD6nmQwarUXsAa0y1b1GnJ+OSa6MkE8DMz5fMbzHbWBLxuQA8UICjsww
	 oWnFVSuSd2RDBPhlfT26bwiGLnTXw7hqn2wqaJ0zqP3VsXeiRgM75pGp7tcRdF2+Fb
	 KcadwoDHLT/mzbfbkZOigg6GrPHPGBAtVVMTG8X0JFTMG+Ce+oRGj/NbqZWFqpjH7z
	 u5LArjSylbEDA==
Date: Tue, 24 Nov 2026 18:14:14 +0200
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
Message-ID: <awW31hUpXuujSAXA@kernel.org>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: xtamgay1zikc3h15kigdzfbm7gsk3a53
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B2EE80009
X-Rspam-User:
X-HE-Tag: 1795536862-873981
X-HE-Meta: U2FsdGVkX1+oYWEVfFWg03lYk1GMlkjn3AzxXF7VmDvTfyekYyLfxD8hHmt/4GI4gFyl9hCObaSvib5Z6FroMd+5mzSDAVA4gv2mN5C9Y20PycR5HwTzKRUu5wXJHRB7tCZjvcW7Nn4VGPIOWi8Xt7QOstdhUbaJWDhQR2STbFEUNMzqBb6k2DM07OBMe88VpXWsAHef46Gt6GLzknX3D28B95JvxEhtjjx6/CjnPXsKFoMYf6Vb5xZycnXRHT7fAFzrebuTgNQWp40KrWMRi7NwiaevPorB035y48jg4kU0AZihxr1azuti6k7G6GHJipK3WjVk7BI3DsF3wQmEuu9zrfaYBfkQwDvUoyHWW1ZM9m8aVkD9LuxixT2beWHcym3CyjU0AlYUiP0zHwdZL7IYVLjSwWZu2qTqpJ0+uy2gouPVnPZhIHvY4blSHwnFxEsj+J1/K6SOhMRozzBwBc/Mf893XkCyw3OfGB6V3ELB5i0dfBbyTuDeiwgWh9NsQhrzi5cog6QgA7YDFFe3ZSQKanfi5b3vPX1z98V+aen3boYdJkVvhqQL5oa/57Q19cgivQOCXEGanD3YfchzfMd4VLAQaniDa8W8api8m+Pnk4KneVCFbduJ0ZJCLdH/cX2fif111A+chCKS3XoGE/qrs71BFka+a0LNmyFAr955rhiN98Hane+Pg8o3aCH46WQvWieo7QfwoKuWcLSljtutSKRvseElasE8UxDNFKwM1CogfyW6imOocptz+8vscZkxIQlp7axpxqKuwx5kNlkcX0l9GG9xxYYwCzG3HpyUeGi5RvJiM3k+CRZNPPtFjE1SoBSguteUx2SmPdvPLQp5aH4wlyWtwufwk+cftXIUTheSPjY87+UMsoXZ9BX1tI9VH1IKRkDMOWRqDJpushFRdibPfqm79DoX8I5s9afIfumDeRN+D7KF1/+wQIXx46qx7ehdoEigSawHuWU
 VJnzofL/
 W7eP3B8+M3SIAAScCUuzRRFuoA1hpwWcM359a0LeObOn9kwF6jNHioWpqhrfKr/7B7EhxTOxj2jbNEsGIYmG1iLrH7ghRSnNtKGH/ZdHxyWGNvIDZFFoWLXOTEBpAANdXUGgO2295tF1g0/Edx8QoXK1zlZuVclcylUXWUQcNU28Zx98EOhcxBRFgpPoqtCc61njrK3hiFMyyQgi/DCdn4z5/HnPr9YyioLkX34LoFKzIE+RVcVhzzTdacc4WVcMwGnxSBVqhZjb8gn37Cofy3joOuORZCubvplTSgMSTVQNAz0YRQoFsyLbM4LRrSnh71DvRmWpxMBycqEIa6rONXxnOtTJaHECQsR7/P/s57PH2QTdSPUW9p1R/IOHl5l2SWWHrqpipXSNn/fBWrCOoU7bOzIAAip+AX3kVoxPOEfCW/waB3JuurOv1/u3tZz3p81zoSVVIY5NaqFoRx8X2OHROFcRBDs4doEpDgFTQgKOUY+3ryKgqVnaBlDwZJNg1HFBkcpDxFHCl/9XSNJeOzhb5Z+O70LapV2J2ZB0eFgHV4tzkMkCKAmuYTtLSkXBj+OfSRkxS1aFnbN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:58:31AM -0800, Dave Hansen wrote:
> On 11/24/26 07:56, Mike Rapoport wrote:
> > On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
> >> On 11/24/26 05:32, Pankaj Gupta wrote:
> >>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
> >>> memory bitmap before the command line is parsed. memmap= and mem= edit
> >>> e820_table only afterwards.
> >> memmap= and mem= are debugging tools, right? 
> > I wish they were 🙂
> > But AFAIU they are used to carve out "pmem" or PFN-mapped memory.
> 
> I've used them that way for development, but production pmem systems
> always had persistent memory in their BIOS-provided memory maps.
> 
> How are folks depending on these in production in confidential guests?

They shouldn't but you can't guarantee that.

But I don't mind letting them crash if they do :)

-- 
Sincerely yours,
Mike.

