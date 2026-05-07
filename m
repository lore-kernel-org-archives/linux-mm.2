Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F7BCD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16716B0088; Thu,  7 May 2026 05:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0356B008A; Thu,  7 May 2026 05:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67CB6B008C; Thu,  7 May 2026 05:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 910C26B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:38:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BA16A0447
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:38:56 +0000 (UTC)
X-FDA: 84740124672.07.73C551C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B36E14000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:38:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XyO8gvHl;
	spf=pass (imf23.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778146734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGnQthdyPgFlyTGEgbgSwRm6V9l8GiDfrbUfyvvTqO0=;
	b=DtBjfbn4wOB5slSOvgGpsW+UENuTDkEonO/tF5E3bUiAiKXlBkIP9OqldS+Q7ZC5q3lpG8
	HIazzEBW9UBq/6otYqM4iTdGQBDgBcxThh/dURP2nQOZEW/r8OXQ/ysQHSn5KIY747hKaH
	g+Ok8eQcZGRhT1F2dNb/0JA6qRcorxY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XyO8gvHl;
	spf=pass (imf23.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778146734; a=rsa-sha256;
	cv=none;
	b=Ir70t3H5kTAP6HU7x7ufZZ7pyJIZTEPPwlBo+zDoZeZNZnfql1burb51pNyRwDJz2xcex/
	avcv97jGkG6IEKjx8nu46N//40Ew3Q/RmhPIu3D+Pr+cnAF/Q/aXQWXVqLmMlAmcR0W6+U
	H8CyXwd3yClTGDHuGclYZwDucwNoxoQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C1FF40C56;
	Thu,  7 May 2026 09:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFC9C2BCB2;
	Thu,  7 May 2026 09:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778146733;
	bh=DeehgTNF5Iahk7h3I13ggfT+xXDlph1I0HFCnVNDg0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XyO8gvHlTYz5Ac3kAslP2rYTLBXXjZBXfAg33vMz43SMC73uGVpdjA7lqedr4NbZS
	 r4++aofHVyBihvJdp4Ii6SozxNddx4pbxHH/H5S66/G06kMHKw3BmnBO12S8t41QNT
	 zbOCDErsoabOWxotbveYBwdayaw1VLGyYwMYsXwFRh0pmQVV2TRvS1QKRBgYQqlrTC
	 BK447mA28HbOjWW6piRRG0Q7sfGLGC+m7J+JRqObbZizbiwjc1sH5W3jpNSM/m2o5L
	 IZyp3aaYELVPdN50gxcjZiUr6jEwr8U6T6k5E5+60ZhibIwXnoDZS5mgWDHiSImqCG
	 bEYnJFheuItMg==
Date: Thu, 7 May 2026 17:38:43 +0800
From: Nathan Chancellor <nathan@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <20260507093843.GA1826581@ax162>
References: <20260424132427.2703076-1-elver@google.com>
 <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
 <afkOMIPu1WNFE9MS@elver.google.com>
 <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
X-Stat-Signature: pgxpgoenebfd8867frqi4mpbg5mb3dhi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B36E14000B
X-Rspam-User: 
X-HE-Tag: 1778146734-859292
X-HE-Meta: U2FsdGVkX1+4onfjd4Lto9CzH4knBVK39PHuImbpe4fd0ELyS9qPdYzY4oBgCkoopNK1Xe1dFJIncwwAOyAKi/++AHXs1oAiOppdqm5PYQhzEwMguQKgb0TH5/ijEolkDPrHXJUxQP74XgA1hy/RSvZuADTtxWq3CulIqywdrf2yaQkPGWpGIIh5oPaBwrDzzwb0QKoP6GtXUcyI+yqWyfdG1Z3a2Cf8VBvVzeRSrijPNRPBhENmnWfTactXFZibqPs8DtqeFtYpn6xSsflEPBBIvJUkNIsLtlihDjgHwigLQID1i0mSH7cdux7d0RN8w4Rpr8WqzFtxx7Mu9xfE8acuuOBwNNjm48QDmMV+28C1a7aei1yMikxd7+wddnrzBsReeYMA8C470wJMMuiKBCdBiRrdp6iJVw+GSEePZ4/lMGj0ZmIFAynA9eS46pW1a8hafkcwhpW5HiIitiOz0BvAXDoWkAOu7W7CK3OzWz8jsaGdXrdf8iMT6dW2x16WA6C705GlyHzCnfQTEpiMkbAILiFaAVRgUWjc2EQqNJi312Y3d9mRuY7kf2LgrSFAZDJnnSWkClbjlJuVwlVVt7RQUGbo/7GF4Bh8PKy43othc2FnQolQPu6d8nIi5to0r0AKUJyFQ0bIKIq4eLRTrJQtddO0miXaKbqPCJTIUo2zIvUKXW4oOmDDnYeCJPzXJBoJ8EC/+Vp6GHSqCUiyh4E8fzxPBff60oqVMhApBUdm3FHugc42WeiljJbPgRJceOPo+RiQodeK+8zze4XAECubjEdivX951MyEKjDhRdpc7bIA6lWHPfI4xDyiFqVuK9tJU/oW8Gn9kZfrCTwAXWYtpb3c++o+HQZVjlXr7MFRVYWYQe00gQ8/l9oE7F3ux0iFuyUQfRldLSgMaX0vTGZr61GaosLES2oMbQ1/6SoXGBQtZ3VP2dCVjwJleaen0h8s4heijiwCp5ygUwG
 BmbeuokX
 TL3S80OC5BdkX1JPXSh+gbPBv6xXmwcDFpKlgpZjIfn59XxDBVDOjJd9g5AXMJb6VXjJNQ5lQv+3tdvESY5S4qEud3EZcurJG/zdxzidsswNbJD+hYpLDzpvU548Co3DAey5qtJVJ6KeLrZo0eZbgfRSZC5czCqDb+WsYwBc4NyEsHpOYQXfzwsFchppD+sC5pvxNp7IK/iR0Ko85zwSQvs0mhmCygHW367yfNjHdCUamIC6KprWvdjHox/d28NT0+6U4by3uepSK8esY1Iqea+ViMMxBPLt3+Ot8/QTYKykB8mWMrTXQ5WbHBHwXVj6xxW5yUG40nV3l5MSiizKq8zWPQzxkKSL5IOIgHj1HBRXyDpzr6/tClD9fPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 03:03:27PM +0200, Marco Elver wrote:
> Bah, this is why it doesn't work:
> 
> >> drivers/gpu/drm/msm/msm_gpu.c:272:4: error: cannot jump from this indirect goto statement to one of its possible targets
>      272 |                         drm_exec_retry_on_contention(&exec);
>          |                         ^
>    include/drm/drm_exec.h:123:4: note: expanded from macro
> 'drm_exec_retry_on_contention'
>      123 |                         goto *__drm_exec_retry_ptr;             \
>          |                         ^
>    drivers/gpu/drm/msm/msm_gpu.c:304:16: note: possible target of
> indirect goto statement
>      304 |                 state->bos = kcalloc(submit->nr_bos,
>          |                              ^
>    include/linux/slab.h:1173:34: note: expanded from macro 'kcalloc'
>     1173 | #define kcalloc(n, size, flags)         kmalloc_array(n,
> size, (flags) | __GFP_ZERO)
>          |                                         ^
>    include/linux/slab.h:1133:42: note: expanded from macro 'kmalloc_array'
>     1133 | #define kmalloc_array(...)
> alloc_hooks(kmalloc_array_noprof(__VA_ARGS__))
>          |                                                             ^
>    include/linux/slab.h:1132:71: note: expanded from macro
> 'kmalloc_array_noprof'
>     1132 | #define kmalloc_array_noprof(...)
> _kmalloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
>          |
>                        ^
>    include/linux/slab.h:506:55: note: expanded from macro '__kmalloc_token'
>      506 | #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _THIS_IP_ })
>          |                                                       ^
>    include/linux/instruction_pointer.h:10:41: note: expanded from
> macro '_THIS_IP_'
>       10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
> long)&&__here; })
>          |                                         ^
>    drivers/gpu/drm/msm/msm_gpu.c:304:16: note: jump enters a statement
> expression
> 
> 
> Apparently using _THIS_IP_ creates a possible indirect jump target,
> but because it's in a statement expression, it's invalid, so the
> compiler complains. This is obviously nonsense, because the actual
> indirect jump in this gpu driver code would never jump to the
> _THIS_IP_ __here label, but that's what it is.
> 
> Given this pre-existing issue, we probably need to continue using
> _RET_IP_, as before. I tried to fix _THIS_IP_, but it's incredibly
> brittle (e.g. __always_inline function returning address of label
> doesn't work on Clang, but would on GCC).

For what it's worth, both LLVM and GCC consider the generic version of
_THIS_IP_ to be broken (even if it works currently), as the address of a
label is only expected to be used with a computed goto (hence the clang
error above, it just looks for possible computed goto targets):

  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=44298
  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
  https://github.com/llvm/llvm-project/issues/138272

-- 
Cheers,
Nathan

