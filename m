Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D225F606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VY1seCPu
Received: by kanga.kvack.org (Postfix)
	id F42296B092E; Thu, 22 Oct 2026 08:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC0B6B0930; Thu, 22 Oct 2026 08:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09CC6B0931; Thu, 22 Oct 2026 08:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C22636B092E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:54:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5308AC083C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:54:51 +0000 (UTC)
X-FDA: 85350256782.19.EB27A54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BCE1D1A0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:54:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VY1seCPu;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792673689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vbaGJGRpVXxD5uBZ+OOkQH5p8m6/MUVG3i7Ss0JkXU=;
	b=uRl9q0BANOL1Hy62Z4CwvbKMKSxvH64NPfRUSXpPF5L8kAaxvdiyw9vjmrJjTWMsb9+12X
	tLxBrvCU8lBWku26poLNnsb/sueipbrdDsOUrRSnaqwNZqAeQnC++HIgLAcfb5IPSEwhfZ
	ihZFRZQKjzht0Uz9lp8aGGTapGgA6o8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VY1seCPu;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792673689;
	b=UbUxF2AHTd3I6X7Zs2YVd/JhLn+E4haqJ20eYfBZ6NV07oaNx6AUx832Th5GVj++m6jcMW
	aOAUH+OtOkpr3MiqVuA6y5qFKAUKDuY+d70pZzBJKjwO5tL8FaiRUCFnDUT5nod7czj7y1
	btgXddhdXAfxR1X+V3AxUJDGw2BGMUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42DA260A6F;
	Thu, 22 Oct 2026 12:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894B41F000C2;
	Thu, 22 Oct 2026 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792673688;
	bh=7vbaGJGRpVXxD5uBZ+OOkQH5p8m6/MUVG3i7Ss0JkXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VY1seCPuEQ5XkAi0umxFdkOvmEt7Kx2hGbI2IZVN3ThnDpyRwnUvwdYymNd+9E9tU
	 Y6uCs+/eEMfFMtzLPtzR3t5w07oRipYVh3q3zHYjva7jKxxY2rtUmmMFb6lyjrhBZ4
	 aBl+7QF3AUzaASmQYEsJWwrNqpc1mgOxEXmvkl5Ahlfk4qHjYl3XswMaGyC4XRtpjn
	 HV845py1NW7lLKQ67BrDentVIXq9kkXgukewOIE1c7415RZNVE/mV54mMVAQjal4u9
	 onEZ5Uk0xiv5XtOMdJUhZMaVvYdc1zTJ2tCgCC5pRU3r6A/j4VozkL7EwWmAzs+Sxp
	 +sL1axvciYHAQ==
Date: Thu, 22 Oct 2026 13:54:46 +0100
From: Harry Yoo <harry@kernel.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH slab/for-next 11/14] smack: specify SLAB_MAY_ACCOUNT for
 smack_rule cache
Message-ID: <atoHebWJxfsra6t7@thinkstation>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-11-096800aa3330@kernel.org>
 <0aeea80c-e3ac-4b6f-b1c9-ef18ea2964b3@schaufler-ca.com>
 <atkEXgQNK05PGTMG@thinkstation>
 <fccc9441-1909-4988-802d-5c9d7829eacc@schaufler-ca.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fccc9441-1909-4988-802d-5c9d7829eacc@schaufler-ca.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCE1D1A0007
X-Stat-Signature: ta895stbwg4kwktexidu3x7qu44ogxjd
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792673689-193091
X-HE-Meta: U2FsdGVkX19WUgpBoLdEgTshGOyGAx33SOk7BYe/0P4y3Lixf+nSrQ29Q10ss82e/pwg5ngqpk8cK9YGrE3aejhiyUILYZ6+v6PuWjWprj0Eu7N5VUzDnVMKaAO42EmkEfWoPuj9tmuDqjyCRuVMb4cwHPtJBCaRwgJF0ljpR9HxhY4mGYpoPy67J5dnrgw2oQbS/IhjfuLHWLCfzvw+n8KDWW6aMrESi5K3ENUoA3ibq9Pn4JaczXjZldSHLbLle/+0TzwnSbtqZFC21frDKKw4KFja6nExIM02hFpzSJIeSRqiyTypbLMpJex3BYdFqhwbz5C0JPA+Gweq2ATAFySl45WFTTbAmNXk9E4PsMDhTt113Rfp4k05uRKsVNGU/Yb6d28FbVjGyM9UJDeccoWRNsQMUq5Fcc+9in+4p1MP1EZGDIQAx74qcnaPa+LnHVvyTHFy3wHz8JGS+L2aGKMCi7KDIrOpjtC3iqSAOvFYkikL0DzeXiV9SrYLoOD8prIp5obNAv366GEgZQy3Po0AdOQfX2IDOQYeND954ATvfN9xLh4f/x5q8dKpaRlKqbgss5zlgYufSX9A+hLkB7BTmKwovzMtckp0R1LEc423Hx3bs8ud3OU7c102qJMqZfKWxgrccvFGbcUuyjFGx59F/QCNGyTOvO4ciGOzWRvPjvSjG5f8/vCLS72RRkAc7YIPWM3yN1M1kggsIggTXVdHd0gMiC4R07UJ6yF2rQX+9oJQtpJWP1/fH9C8YPYuHrANLwi2q9Vf2MZSuyxJwDuGbWnbPiWtOEuobw1Qk2O4Fv2uPVWOCWQpl5DZ4mzltqErMESF6WLqgsrHmZ0Z5Pbw5UJQ5iz7leo37BBK6VMSrb2gtnjIEfbdzco+0iOjr044ITLgBhwyWUtsT3ySyAsrRMNYarqq7Smk+UmDEcRtBQ69hSlh4n2lqcaA68rNBUVRdvo+09CsDLlPrsJ
 FmxdqR/1
 l4XZMx1GXHDHbIvrdKMQbfVcSguDIHebgCv2PM9IC1xpJ23skPlP/mCGd/bWDkTZsWGzOEPzq5gi6Si2IViTVxcFYe43iM9+fOuI16id832oUSHMkW1YplJvAR0i1pypkgtQwSI4yPefDeTT+EFx8vFUwIS5Hr1geD09tu+J6D9+ulYmvjUKbaP0GfLZF4hNv810Ah/qaDkeK7mMnDIvQIl/8WV2p74qafS3tNLHTyo9704p71Os2lB6MRKozIuT8v4xaO/nQHIg3UNyFCnI1xcQqOvqfolxK8QPR3aHXnTnWNycpKhnfdNy0h7+/YsB2du+gsGttNAD8xah9RSR/hWis9TFhYpuVWXh0QKTFB+PvXq5Bp4CqMHbKyxBzNnOlh3RiJMM131/rvbB9dpnvyAvI7GBE8wdrlhd6r5B7sS7SdXvtYZWHAkZY7OAGhKb3/8sGPjd/qQQqVja8W2ChAHdgdoAIvqlbqzWYnHedgbb4k++1/Ff0e1XtyCC6+EHUCD4nQlVRqxoNbE03csg6IBkKuu1i7DIkVTNtyikmg+OGxYh+HRsddlvhTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 12:14:39PM -0700, Casey Schaufler wrote:
> On 10/21/2026 11:48 AM, Harry Yoo wrote:
> > On Wed, Oct 21, 2026 at 09:59:15AM -0700, Casey Schaufler wrote:
> >> On 10/21/2026 4:46 AM, Harry Yoo (Meta) wrote:
> >>> smk_copy_rules() allocates rules with the gfp passed from
> >>> security_prepare_creds(), which is GFP_KERNEL_ACCOUNT. Specify
> >>> SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
> >>> __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.
> >>>
> >>> Path: fork() -> copy_creds() -> prepare_creds()
> >>>   -> security_prepare_creds(GFP_KERNEL_ACCOUNT) -> smack_cred_prepare()
> >>>   -> smk_copy_rules() -> kmem_cache_zalloc(smack_rule_cache)
> >>>
> >>> Assisted-by: LLM
> >>> Cc: Casey Schaufler <casey@schaufler-ca.com>
> >>> Cc: Paul Moore <paul@paul-moore.com>
> >>> Cc: James Morris <jmorris@namei.org>
> >>> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> >>> Cc: linux-security-module@vger.kernel.org
> >>> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> >> How was this change tested?
> 
> Brilliant response. Thank you. Add my
> 
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

No problem :)
Thank you, have a nice day!

-- 
Cheers,
Harry / Hyeonggon

