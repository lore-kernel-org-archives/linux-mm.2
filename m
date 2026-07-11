Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18EB6C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 06:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42D96B0088; Sat, 11 Jul 2026 02:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBCE6B008A; Sat, 11 Jul 2026 02:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A932C6B008C; Sat, 11 Jul 2026 02:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E30C6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:26:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 094331C3D0B
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:26:54 +0000 (UTC)
X-FDA: 84975512748.24.25BDAF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C5FDA0003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:26:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnxr8ph+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783751212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEOFuhzeieMbnwaju2e0IyYLOOljLY7Vu3oSd3kdBHA=;
	b=JEQ6/BaPnPDmuXDTrA1CLuQMFgNho+pOvoOfYHxhF2MRYKphyv8cYWOZOJgf+HtV61sszO
	yER/5pxWUXBLAfkv5cuzxUdAvuXFjEy9qMnsIi1SrP/DA51cBC594Ynnrbf2rE+P5uRdKy
	Ux/FGLQVAt7Y+VHX1cOBkgHTWlZpWmM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnxr8ph+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783751212;
	b=ai85D0HLdeKuejH5w/sbr2A+37SqFYkoWZKGZlbPTgtWexbq4kGVa6FG7+pSymeiZCM3CW
	K3giyrn3ohlaNX1m3n45eflOFUsPtw6WAWzvABhB5L/MCMBt1DjD+80CD7gUPqXTE2gwFu
	GhBXnj1xFl4Q7o+WOjimFB/GrIOJSPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADF21600C3;
	Sat, 11 Jul 2026 06:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C64C1F000E9;
	Sat, 11 Jul 2026 06:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783751211;
	bh=oEOFuhzeieMbnwaju2e0IyYLOOljLY7Vu3oSd3kdBHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cnxr8ph+JvOklROMnVucJQrwHjsALSCj4Ss+aIH/0LX604Xs1T9DH/LiBtq8DJ7CB
	 bbFTc6S7EMzv13aXVNHz37o3w0H8cJVDkv4EEInq5aeJXRMvt824n4tG1k47YNFa8G
	 EEA2Db90wtgvblrtq8KsiTYxReeJpSlF3eZjjkyY3N1viC0WHBwCxq3l1oRlpcYqS7
	 QgRD0/favy08A6S+5sgaUW5i6AYO6b9zdbFwe0prWZorlAfVWtQE7i8a/bTndcjz/R
	 KrW6QiZSCXk9Ev7/ALIwvBmzcfBLHJNn0n1YTZf1YI9xC0rUFXaw8voXqV1/nPb13z
	 PG0yxvDGEfIrA==
Date: Sat, 11 Jul 2026 07:26:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 30/30] tools/testing/vma: output compared expression on
 ASSERT_[EQ, NE]()
Message-ID: <alHh1cPs9tNLMLJf@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
 <alFausURKttxHUAI@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFausURKttxHUAI@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 7C5FDA0003
X-Stat-Signature: qh33494akpqo8hgi5ojkk6udjh5stati
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783751212-555188
X-HE-Meta: U2FsdGVkX1+bWYlaRBnrNpYWIBbsrhvf/xWxJ5heewS+F8rMAlWai6Y4zEzXUNBixfs69RH6m/fKjQvdv18Jhi+RKvlnjJV7hrW+zNiLwGih3qfZj6fAFw5YxGpCOLfZKE+oWMjEw4FZ6VFpA5nGZHEYR6M3KovPtEbOTM1aFIZt4gLz69dTVBX34W6iUgoA7rtMtcsXp+OfGNttspp2EV5SQ+U9FX1B/rxghHI3YWICuINWb4o5oMK6etNMCbyM2hc9b9R94SfvE+Bk1yA4VfPFGS2NxHZ/VE/28BWGXrjUFYMzrzdS553xQG7ptsfpJB+OPS6ifDOCgiaTN8fVm/plR+b0wzcDzunKsntFZXGFSXuPoPjYePsL9SCX2bVRATMbKsjjUD+YpUNQu20hGVddEGUxl8jDd7X9hzdJaF8LzkcVv29UD+m2UQO8Bc04BINFkq0kBpf7TxAUsoGVCF6UK1BjFhDP5wOMGb4b5RzKx9kswiDc5M5N5ax1jVCiPBFnvQLTfYDvRD6ws+AJiyL9Ej3q9pcDznn3RFJ9BF4E0pTd3svJ0FaSvPLUG4ViEyeCSF/Se1CzbpzQmbhKVsUvw3KGGyfMgnqU9OlEB+ifg1jy7Ql2OuMc+hmxvmrS2lhnIYodqTsK1c56DRWfqemhmP7ys3zJd3HlqxH1bAC0z6sD0tUOJ7qLTlg1uwZ8NeByQahXax/6mKmaWKWyJwUe6M0XXqmiDVGrsINUljM6RuSQ2No5YImQDOD5MECMNSdJwZlagnZC398ryf5QhIY9OA4V5ZLRnLDTxXHHPKXa8EYMxErtdWppDInXZRq6zBQBiyUeZ3zhc3ev6swT9Fxt0BrsGwePkF3j/Gg5C7jUlbJ6wSgifDj+8sZXM0agUKGG3bAyrbYQUM++hOwNEs4KKVyePEOKpIzTuT2CTi7e3MJ/0/gIIXg3ISQ2bV9Q334pEU+eqNC663RSPYX
 sCNV5P0X
 MFHP/Ye8tRnGTYiW7IJshTA4k0jtN0mio5dhUyME1jBMC5Y70kKg4szRizVFsHyvv4UfAGRXkxJ+Dz5X68/Ts59udI1wWFbksJEJt5/i8Nw1oC/CiPKJuom91j7uD5c2KOmi2mm2eYY+xK4deAPyQt9Mxf3sxE0EpAVNyerINBunQwqnQR9TqGGFAFMsitE0lpLJ0NlS/sz+1XGLO3yDoK6W1Z2ITNuQFPaIZ6p0+mHtlyOu7R9pRWPjeFX89A3lJpVRESNSNfXMvUo0RGWnB/VlaY3n38s3QnrmlNBIo+SnbLux51iGJciQcFkQN0z0glp9NAWE6N2Ub7XZ6QydjefMlXyulBkSBpyHTQK4C9u+ZE7bTqo7PCt3KuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 04:48:58PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:41PM +0100, Lorenzo Stoakes wrote:
> > -#define ASSERT_TRUE(_expr)						\
> > -	do {								\
> > -		if (!(_expr)) {						\
> > -			fprintf(stderr,					\
> > -				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
> > -				__FILE__, __LINE__, __FUNCTION__, #_expr); \
> > -			return false;					\
> > -		}							\
> > +#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
> > +	do {								   \
> > +		if (!(_expr)) {						   \
> > +			fprintf(stderr,					   \
> > +				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
> > +				_fmt ".\n",				   \
> > +				__FILE__, __LINE__, __FUNCTION__, #_expr   \
> > +				__VA_OPT__(,) __VA_ARGS__);		   \
> > +			return false;					   \
> > +		}							   \
> >  	} while (0)
> >
> > +#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))
> > +
> > +#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")
>
> Mmmmm... macro madness.... I don't think this is what you want.
>
> I think you end up double-running the expression in the failure branch.
>
>   ASSERT_EQ(cleanup_mm(&mm, &vmi), 2)
>
> run through the preprocessor expands to:
>
>   do {
>       if (!( (cleanup_mm(&mm, &vmi)) == (2) )) {
>               **** first run ****
>
>           fprintf(stderr,
>               "Assert FAILED at %s:%d:%s(): %s is FALSE" " (0x%llx != 0x%llx)" ".\n",
>               "merge.c", 645, __FUNCTION__,
>               "(cleanup_mm(&mm, &vmi)) == (2)",
>               ((unsigned long long)(uintptr_t)(cleanup_mm(&mm, &vmi))),
>                                                **** second run ****
>
>               ((unsigned long long)(uintptr_t)(2)));
>           return false;
>       }
>   } while (0);
>
>
> A bunch of existing ASSERT callers mutate state, so there's no guarantee
> the printed value matches teh actual test value.
>
> I think you want something like:
>
> #define ASSERT_EQ(_val1, _val2) do {	\
> 	__auto_type _v1 = (_val1);	\
> 	__auto_type _v2 = (_val2);	\
> 	__ASSERT_TRUE(_v1 == _v2, " (0x%llx != 0x%llx)",	\
> 		__TO_SCALAR(_v1), __TO_SCALAR(_v2));	\
> } while (0)
>
> which expands to:
>
>   do {
>       __auto_type _v1 = (cleanup_mm(&mm, &vmi));
>       __auto_type _v2 = (2);
>       do {
>           if (!(_v1 == _v2)) {
>               fprintf(stderr, "...FALSE (0x%llx != 0x%llx).\n",
>                       "merge.c", 645, __FUNCTION__, "_v1 == _v2",
>                       ((unsigned long long)(uintptr_t)(_v1)),
>                       ((unsigned long long)(uintptr_t)(_v2)));
>               return false;
>           }
>       } while (0);
>   } while (0);
>
> ~Gregory

It's funny you should mention that... fixed in v2.

But ugh sorry that you reviewed this while I was also fixing this up (Claude
reported it also), your review's very appreciated :>)

Cheers, Lorenzo

