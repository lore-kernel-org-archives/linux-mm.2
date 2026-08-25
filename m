Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EC4C61DC2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110CB6B0092; Tue, 25 Aug 2026 10:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA006B0095; Tue, 25 Aug 2026 10:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F418D6B0098; Tue, 25 Aug 2026 10:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D301A6B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:36:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63087803BE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:36:45 +0000 (UTC)
X-FDA: 85140043170.13.741E236
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BCA64100010
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:36:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTRA32Q5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787668603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56YtQtCs4zY1Wo9MhksdOnGNlbwVQ7SwtCBKJSpWzvM=;
	b=D8wglNhTMa6zCT7hDf9tkjMRZWkli1p2qjfEyPugChXrPa8eFqJtj6DgqcrU7RSR8HLIfT
	FC3speAe3ZL2zCnoN2bKRAVNSvqrQYr0tebPRmlYSFkzd25Jz7TLZModKFj3FFhXngUtyK
	AkzRu8GTRQTUjm0C4lXZt6ikOtJwHgA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787668603;
	b=pI716Fu78sxzwq24dav7O8PqjejwPro9sW/g+D5ie9QBFQdx3ps0OrZHeQ4S0fOvvi6TuU
	0yGdkY8S+As5Cy4WKPOWhXb7Gg8vpVeWrEoF14W0L64svihKxwI0RdI/o19fhB4UkzFBer
	jEtJhXx9qkgkCHD1VDJ1dpg8OpaHIWY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTRA32Q5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B2256020E;
	Tue, 25 Aug 2026 14:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D741F000E9;
	Tue, 25 Aug 2026 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787668603;
	bh=56YtQtCs4zY1Wo9MhksdOnGNlbwVQ7SwtCBKJSpWzvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gTRA32Q5GYrO5A8+2tFR3r8n2+xAzntdO0OL4s63HWDSQ1YRvQtq667c0LmTyJ4Ck
	 LJYx4U11I1FaviXL7N0rjsGjd7PfQxvsnFBGBUr3aYXmU+49SyhrlmgLs0DW9WDX1D
	 JreqrK3Z8FxI+OhyYMRu3JhIpaZxZ9rCfhrRKFvSVWIpQmyeREegEj3L4D0M7Tm9+l
	 nmCeLZaSepdTgBNUn9iED5P7vicLnw7KHIJdS3m/nUawW6ck3QD1MVCuFUayPE32SX
	 w6LlvB4vxXlSTE/RTe67RP9YP8ED+nrC9fg/otHaX2KojfLsjiRMyPxhnf0EmP+WEh
	 enxsjMYqCL+sg==
Date: Tue, 25 Aug 2026 15:36:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hemanth Selam <hemanth.selam@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Yury Khrustalev <yury.khrustalev@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: remove the local PKEY_UNRESTRICTED
 fallback
Message-ID: <ao2nFqGevXIa3l4c@gremlin>
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
 <20260819074717.1345749-1-hemanth.selam@gmail.com>
 <fd193070-af97-497d-82dc-1f0fa1172fd7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd193070-af97-497d-82dc-1f0fa1172fd7@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCA64100010
X-Stat-Signature: 5e7fu4ym415uq4cbdimu878ffgbfzuzs
X-Rspam-User: 
X-HE-Tag: 1787668603-215611
X-HE-Meta: U2FsdGVkX18GwyFiRagcwgANCgpO+wwP5rIGUttv7nzfIwJRr7u+z0ZzJZ6ra8NssAaKXXDqYMf7z2O/P1zEgcbigIcUOlkYUCON2ensxioRXDyYFNIWG6nuEinyBgHi2TzjrgTdrZ/v/XlplxLVM/HfgIa2pm332GfACQAtwYARTSc17Q+FmrAJtj2z7XflAmeqBNjkAQcOrHJgw8YL1BDMsDvlvwZCTDexhQTV7LG04gzrH7NathfzuTR+gazZgcL0cdihjOC5UF6Px8+3Q6j8JQRigTivIbUQbkimRhAuKduA9wWF4EnCH2c0xs5eEGUlGVdmgDtPdqI0XTw1wtP1+A5tbW3vBUCNwQU3xeNtZsaIJFh6noQ/hLTtoCZZ+TprYvS0U1pbNevTPpf0E+IK1LdClAjiXEKJtR6xp63SCUgxwxoROI+MYIEvV/qCSIapjp3LAvaIMr9eHFHHoOL6gKFDNlQPvKy9DLCU3tK2+tBa/m+V/jsfMYNGI329nh4X9LRnWWr+8Q3oKl0IRYW1aU9W6oeXeNdG9csW+m/3detODE2D5B6aUT2FU99Cyu40tx4o+HYlWv1AF8fIFWxRPsSqXDEVrqs9SmFEaNgM1FgiQw7aW1Y9pC3EFdjZwavVCFSsLiemJ5tZY/5J+o0RCer1Is5FQfFlkTQNutJWr+k3j2LvSY4BTAaFm19/rlvMsSvX7j0uIVbFrlyig2lV5l/sLnzzVuQW+L+iEJiUStawrB5L4gxfWaMsgTwZACaJMSYj73zgOk/jEJi2BHpsWFNlIpIgsM0N8wXDgpjjUSWCfj59bXmkt2IzPnIN+lrwUnN8Pv4P8W79Ein9SGMBoDttBXyPpOc8pIhS6wBgEJTcv3uyi7BF0RJthfzqGRr7Hj5qLdUI8Pj1UWAaLEvHzTTWz8AZmekyoSsWQyXZhRw3gI0fx4LMv/r1wI61zBwdt4FVGL8luAt+6rR
 0fFeGsuw
 nV5FPTiS1hfZjXg2oIlZ/XeZKhfskYngP9AJBmJH73S7FhtjTcs/KVIMpi3aKX0b+1TugwtNZWOg9TJOTml3kybS1hqz2EsD66Zm4t83hKEtn4tHAhUkVLS4PRvJ5f5nkzosW4kJ20C6UsavlQl2S5LJgX6LIBho9C2lH65mKttnihB3t711nieoyZY3jjyuaXlsbFufeMa/6BGrDMb0rJNrQsZ0+RxxoQHPACWe5grXZJyl7FFffUT725B36W7WkHt1hdvy7YJDQRfaIHehgvvgbQhNvi5NOYgNsJNf9klsSehzQAvsxLpWYpAKJ8yDCa3lEAz1vqoF922yxqxndUqUTjEzb4jDyt9R/ZqjVFTGVMIjT8mZM+H0s2c8vFBocHOPXCNuxFw0r45UFYfiWUu70X/XjDxCeQPBiJfA1UVNjPbHY3FwxX+gIdI+J5faa6QQcl5jBxd6P4K8BfJq7Rkdg5ODbym9XP0Jh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 04:15:04PM +0200, David Hildenbrand (Arm) wrote:
> On 8/19/26 09:47, Hemanth Selam wrote:
> > pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
> > already known, a stopgap from when the generic definition was still
> > under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
> > Add PKEY_UNRESTRICTED macro"), so the guard is never taken and the FIXME
> > can be honoured.
> >
> > The definition comes from tools/include/uapi/asm-generic/mman-common.h
> > via TOOLS_INCLUDES, which commit e076eaca5906 ("selftests: break the
> > dependency upon local header files") added so that the mm selftests
> > build without "make headers".  It is reached through the
> > <asm-generic/mman.h> that the system <asm/mman.h> includes.  Building
> > the pkey tests with KHDR_INCLUDES pointing at an empty directory
> > confirms that; emptying TOOLS_INCLUDES as well is what makes the macro
> > go missing.
> >
> > No functional change intended.
> >
> > Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Since you said load-bearing in the last email - I do have to ask if AI was
involved with this.

If so please adhere to kernel guidelines:

https://docs.kernel.org/process/coding-assistants.html
https://docs.kernel.org/process/generated-content.html

I.e. add an Assisted-by tag.

Anyway given your explanation in the other sub-thread seems ok so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> Hi,
>
> please prefer not sending new revisions in reply to old revisions the next time.

Yup. Please send respins as an entirely separate main not in-reply to
anything, thanks!

Also add a revision history under the --- with links to prior revisions,
and if >1 patch send a cover letter that has the revisions and all patch
emails are in-reply-to.

>
> [...]
>
> >  tools/testing/selftests/mm/pkey-helpers.h | 7 -------
> >  1 file changed, 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> > index 2c377f4e9df1..626c2e1655dc 100644
> > --- a/tools/testing/selftests/mm/pkey-helpers.h
> > +++ b/tools/testing/selftests/mm/pkey-helpers.h
> > @@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
> >  #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
> >  #endif
> >
> > -/*
> > - * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
> > - */
> > -#ifndef PKEY_UNRESTRICTED
> > -#define PKEY_UNRESTRICTED 0x0
> > -#endif
> > -
> >  #ifndef set_pkey_bits
> >  static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
> >  {
>
> Hoping this indeed compiles ;)
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

