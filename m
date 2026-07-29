Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22A6C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CB26B0093; Wed, 29 Jul 2026 02:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5D06B0095; Wed, 29 Jul 2026 02:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D726B0096; Wed, 29 Jul 2026 02:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF4A6B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:18:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BBE7A05F3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:18:50 +0000 (UTC)
X-FDA: 85040810820.28.8B55FB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6B4F380008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:18:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpxI1fde;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785305928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aYJY9eFGdOEIgL8Dqi8cQU7ifkugqTWviGLduSbw30=;
	b=3mUZEJiFpWQ+gJKvoUp12q8OXu4GcaDn0meKWGD6RxD7O81K0ngKDCxG/rMXVbYISa0dha
	o+R6b0p/63IAOQ5FVpSyRE8Tlsow5WzV+VKnPA4h7mHJ1GdDtV/bdiAwy/ek69ER6MqyyB
	WxbUXjghzB4oWkRWkOOhEAJCO4WUB/U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpxI1fde;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785305928;
	b=cgHupJvRRrxZ6FKzVZIJQJ6z+0gJLjmm6NVcRG8F+G1rxXTaTouL8vib2XXlJ1zaFxzw6l
	N6jZwJ74MUkry0XBHOSMPprPztrN1FvdmMu9+5JXE99lcZa4DWFcfG2+zgOaY0wCRpB+oW
	NXk/k6k+THxRPXLtG3Jcb3tAd3m25e4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B662E4069D;
	Wed, 29 Jul 2026 06:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CF31F00A3A;
	Wed, 29 Jul 2026 06:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785305926;
	bh=8aYJY9eFGdOEIgL8Dqi8cQU7ifkugqTWviGLduSbw30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IpxI1fdeSQBhQ7ZGkZTOQuEPFZ1TJ0B2VthQ6AR1k2WBwOxcLW6xhTzugez/mIXl+
	 3slTyE1QclugptWka4V4JXZEIYAtgRXs2McJ0TkrqXBa03tzwCZRqBM2RWxMytuoZ3
	 a+vyKk1lYyz7GpETh0gE6dWYdAukTd+DAPurvHH6AKAx6O4QkmkfljI+mmeBhMmYC1
	 c/Jb4yxlVAZnwkikwLRjPPogjtp9qq/YkV7WvCGRb+8D1sLiZPrxFiCbq0fYtGyeEg
	 mjYzeHIBngZ1ARgMlNMrK6xl0Kqn+uqqY+e7yxC7hFkGh2Nb6agsDTpPg5rT4LyiAf
	 lzwZL12gZ/sWg==
Date: Wed, 29 Jul 2026 06:18:44 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Message-ID: <ammZpX_77SMsxvPz@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
 <amivCT7AaPux-GSK@thinkpad>
 <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B4F380008
X-Rspam-User: 
X-Stat-Signature: 31hp81nx8ufputgqhxuab8qqmkby17ja
X-HE-Tag: 1785305928-598481
X-HE-Meta: U2FsdGVkX1/zzDFVSR8TqLPnLiSNkuxsTM9P1DuVe9qoD5Nti6q3TpIj5ZcSTx2W6Lz3iTK1QuT8SMTip4FcPnY4gSYiQV07qIRCE8QryRXWEyU/3NtmoVVL69W0gqy4xXbTyp6R5Z5qhAu45zI5MM8SLpVti9XiOckDNA1QTt+1uNTdGtBGkT4/hc0c3ZyDfroS/3Shma8cfAAeWVKjjY4w6MqsrGrPfnTBpmaHwQzs12oJMqFKOxEyow7js2m/H9ObOWCPSBsGCKnLSYXwy5qpVk1YhmHCoc1bmyHGh/nTFLwI5q1IEa0bJmhJa4e+iQFtNZbHkUM+bZ/cWOe7tnr0VkbRkgvJkprEpmpcTLC7FoMh7wXM22UJU6igfwb5UYmKcROKRhMkuiPg5cRLCfMSAvFNxZDD75UxK/wzZA+m85H1y9ihvce5bj9L9RbuIJLLvVaFKsZO+sT6TGu4QUWD0drsZ/IQ6Ymajc+KIWSUw7zEnffAia5z4jPp9gJ3RUezTDTHtG0kE18rHATI4GSFBY4izROkiBrnZjB+22NWZzIYd38DAGCD53+n4j7+HsTRfQ5kWI3R7cxeZUjdMy0Fd4zkDtTIAuI2B14qNCArgXepN/nKWE4nTmv00Ng9UODiaLX6s787OM+NcCOUOPIjgaijJaq0iTk7c7zMhV41HdjqQAWar+EffXfEnPoi4UMMFCQZn+6rHYVMs0phqTrKEllrGBDQxbiWIpUSNh1E43Wxr+znzryyTXECXd8sH5Didgg4dWGMAeyBoSiwMX+Sm55fW4ZMKo/elNGAhEFH1WRxRfstKmMrwcN/OdTuL6+zAvxOpmy+Tv4EzHwIBSX9WVmveahVIu1TmPd9HZw7k/HJ8Kh0Ko9Yzn3RiXELWTKQ3wPE0TS1BxAvEL8XTfJEUkb9TBpolBAMPXvatx1qgkDHhOVi4A3LEYVHCKCNglgFa4GMjMfGHb9O0PX
 IIPBdYQx
 5Wxcc/PSmgYRD7NfFp+gMZe4B6vIxOeRaWa6gDetNvRsWEqpz7RCr7AJK5m2wqoJHbGilm1/YbcZKHTt+wrh+uSPYea/QNWEi6RvhBAaV/AT2z6u3CgcIFQ7koVn65A2xnVaEuYEJVigOJ0NsE6cLVoK6wRBlAccloMzzzLm9J9ipF3pCw52YBDGCwVElvRxFoqog4/NGgOrfTVr22qJEXit2iDM9v66npTWoRLkvOL/C4SMx7VZZ9hQZBfmdC1if6VkstHQhnTG2wACxFEcW2Y0d30eJniUZa/3XUwX4I5LGcbH5J69eDI9sBX/WNf5ZGsr55QES3tpZDH88Qbq29SsNIqvnhdoRxoYS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 07:41:15PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/28/26 15:41, Harry Yoo wrote:
> > On Mon, Jul 27, 2026 at 02:54:00PM +0200, Vlastimil Babka (SUSE) wrote:
> >> In preparation for changes to the structure, abstract access to the ref
> >> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> >> _ctref to make an unexpected direct access a compile error.
> >> 
> >> No functional change intended.
> >> 
> >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> Reviewed-by: Hao Li <hao.li@linux.dev>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> > 
> > Looks good to me,
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > 
> > With a suggestion: it would be nice to have debug warnings
> > that trigger when slab_obj_ext_codetag_ref() is compiled but
> > not supposed to be called.
> > 
> > e.g.) for kfence objects, or later in the series when we
> > reduce slabobj_ext memory (!slab_obj_ext_has_codetag()) 
> > 
> > Similarly, it would be nice (later in the series) to have a warning
> > in slab_obj_ext_objcg() when slab_needs_objcg() returns false.
> 
> OK good idea but we can't do it right now as the helpers are introduced
> later.
> 
> So for 9/13 mm/slab: introduce slab_obj_ext_has_codetag():
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 8f352d9f4d91..fbad99da093c 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -726,6 +726,8 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
>  static inline union codetag_ref *
>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>  {
> +       VM_WARN_ON_ONCE(!slab_obj_ext_has_codetag());
> +
>         if (IS_ENABLED(CONFIG_MEMCG))
>                 obj_ext += 1;
>  
> ... and for objcg we would need to start passing slab pointer to
> slab_obj_ext_objcg() and slab_obj_ext_set_objcg(). Hmm...

But slab_obj_ext_codetag_ref() already takes the parameter to
calculate offset. I think it's worth as it'll be optimized away on
non-debug kerenels and there is no way to detect type confusion
due to subtle errors in the objext layout.

