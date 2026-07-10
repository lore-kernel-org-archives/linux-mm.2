Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A593C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027716B0096; Fri, 10 Jul 2026 12:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A246B0098; Fri, 10 Jul 2026 12:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2A46B0099; Fri, 10 Jul 2026 12:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B53EA6B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:48:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32EF6120490
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:48:50 +0000 (UTC)
X-FDA: 84973451220.08.E7375B5
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6BD6C20005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:48:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xrjnp7yw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783702128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/T7cJaVh+vpdnCnVWowF/GJXIiYthZ82xWXxPXNVVI=;
	b=RU0v2AW0cXIc0CoHeMl/DvGKcejlFC3zIcW3d5gYzgQ+pEW5SRa5O1kFKOerXaHZ5ChJFg
	k70trMUn9xU5wEsooQngioBKBkSisgTLToSUsks+que5sxvIkIDchIMVS2QDlqNmeaZiG6
	EwHEKs2qp7fnsddwxju0Grb82FD2LVc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xrjnp7yw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783702128;
	b=lZfd77sY0bfhbpwsSyWkxOz7uRmjzCAP0pTCwFsInuttgyI6bt68SMN7CKgwWGaHWu/wrb
	sh/R8Say4Y2dc1IoNQzz/V+iKKFS13ED2VBNdGki2m9xxlLhKn4WsAmCxkd2Fy61wb4Jor
	40Yn6cQrCT20rZsb7dplj74C1EU2ros=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84867f07d63so1297013b3a.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783702127; x=1784306927; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h/T7cJaVh+vpdnCnVWowF/GJXIiYthZ82xWXxPXNVVI=;
        b=Xrjnp7ywXk4UQT4u+Y+rmvLhD0FvGyM+2DrCJ7RPA7psqnSFdAxpdjguefxYAKRIL2
         KUzEHMVNulJWve7kttWnG4lv9XrAxLIJyDjKugaIk6E9JSPcZeTQWCu+5hs3lzq6X235
         sNboEuI6WSMlKwGfVNioHOl5PdO4PnMiu+Mfiphn3bDSIcUDbPlMucvu4rnNfXV8nlil
         9pFtPUyoBTV2Lqtijom/obIIoC/LUpVSP7ujcnF1G7DCX2ySd3MZ8LlB+1DRozQmFT6M
         e/eTP3O0XuGGmT2OodSxy2LmXMzcFZ8kbT3AIdILkhxqSxDL3NCHNJfjRa1AkGn82cK7
         NsdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783702127; x=1784306927;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/T7cJaVh+vpdnCnVWowF/GJXIiYthZ82xWXxPXNVVI=;
        b=cs9L6x9/VIk9cr8niWGZIDS6eANdpTaSQZxaY/guhkNYQsos4/I9m8Crc9k7vKKB8f
         v3O/0q4huOnPhrH9rF7cKnj6uQALVF1iJq5QnbFK/2mxloDjIj7UzXai1cP7MsFThJUE
         JS2l6sWnbdYLJd4o9pQ5oyLoPFotblLxku8jG5CJwQ3Zl+h4V4z/2AT+wmpyw6r7jHxh
         c24doR3b5RJJLh1bid3jpkeF7e0Kbg/JqZDnB1b644qvZhha3qFnthxljdQurIXURqE9
         ZSQzALNIfthBvF8ZqqHklrpUZMqOiNqM91jmbDs2n0wg6cQSzwKraMrVRCMXNa1gf0WR
         R9bQ==
X-Forwarded-Encrypted: i=1; AHgh+RrB1BMn8cevADDSF0zM9DoL3pfx41D4EosC9e/mDj5lOoKHlOyuCuXiQY9dlvULT0aZx4VtQaxCbw==@kvack.org
X-Gm-Message-State: AOJu0Yyyy73MfLBSfAUfwmAzOR737oO5mkTsJ1Ieb6fS6jWVqnNFQMaq
	Pik5Do5kKYIktc2q9QKdyHtFQJBqjKlD7LOGkBxVCgH8v73vKb2x0yYq
X-Gm-Gg: AfdE7ck1xXBrsUM+jUjfE99zOpO2xatDOYpo9KzZHZ435rFE8en5laox7YVc4wk0BG6
	9/5lQEaKArjl28rX3aM3xKrUuUsP1FC3fkMxv2M8s2yGTwzkqcXFOFTmacApvL98EN5pdE77zHA
	zWT+DKM9jANk3w2DKx4hTGfvU1FEd/bAVTZ03vXlE3Y//nqctCN18m+30VgGeEGmG2UZcLsoOjt
	or289J96JX2gAorL7U18RFYKw2/lNxA4mTHMfycC9aUd4ts5kiFgOhfAWwsSA+H/018xwy0/gOp
	35rZH8XyJ+FBwtbVtC3Xvm/JRn6jYLIpC2mQHRSm/sJUezvcQyNjTrLNkrFB+l6W5SNaHFLFlpS
	TPVEJt/MnzxPiI853xHX5RDlhvo+nQgVFBo/minRNZahgnFUblVN+jbvZTCl32Bhz9Wf0o2Ehmu
	LCkBE9K03O4Xk+tH7HGR1Nhhfm2ItnN0NnPVLdc6/hNLWwaY4slWksz+0=
X-Received: by 2002:a05:6a00:6c9a:b0:848:2f7a:2e57 with SMTP id d2e1a72fcca58-848438a63damr12313317b3a.70.1783702127271;
        Fri, 10 Jul 2026 09:48:47 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b609acsm10408336b3a.1.2026.07.10.09.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:48:46 -0700 (PDT)
Date: Fri, 10 Jul 2026 09:48:44 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <alEibBRYmWQvf1z1@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
 <20260710162749.GP118978@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710162749.GP118978@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6BD6C20005
X-Stat-Signature: ifwuuza7oak6a6gown74h1edsondqygr
X-HE-Tag: 1783702128-503557
X-HE-Meta: U2FsdGVkX1/NytO/gLkB2TwkQwGO9Kjk2Ov1SzJ1wxNwihMttw0WDBVOros8BUw1NPohZTJWhCkyIQ31W/GGUoNANFQC33A1DSqzKE7oa2zz+/+dzPx46uV8DkSFj+hVmm1IdWnXRV/XWL7KyaPzYdYWta+gcUsXn5BHf3mz7MybyWw1Ul9cHs0Eyr9Zwz00UB6hdPv7x3m1V0EtClOEcN+BqjCGGOd7vTOvDGWY9o8eBvnjJSe1zFHdgnXK1E21kYRP4C/qT4fM9yP4k9rWaHCwW6cZTplfoUWD3NDpa5g9RG+7ROpDdwJD9+4KURO6CsOM/oE4E8xxR4qyi5HtOK8apF35JXqr/j7VnvlKcYT53YAlOWJAcJHrZBzI7TsiLpP7dOMpFAAe+pzgLW4bkTQMKfDgJvc8ePQ9zjNKPcmlUz1ZeIHy7I9gp4HlRQD5UzwQdMMm0Ek8/G+BxF1fhCXCHqtYEN8mXkT9musySuZargYrWC79GounjeHrJwiwz3vZXYTP2qfLrLj+N1IcBTkTvptbr4uc+3TbABF9WBepEXbYdJCMmFgb57x40OCGQPV0o4DML2koayWS0GbWkyzjiIPsj6L8SrLgndNG7h2UQHk1GThnsoi0hCwCklkLF5ZNbDfMlF546ZObnxBIK+gkCAeSD4a55EQapoRDZtFuz24SZnJ0qFuUFXMSIYZB+X/0xkB5vuVMXp4f/11SYoFHt3nG/QQorVzHZeQEPAvqmIAdh+RbWQ1JnWe+yz0W7og+j7Eway6YR+mj5yYX+SjPdRKtHpT0EJyXad7tIoroFNaMfRl6ufJurSXpm5kbfH7BVZuUrdbN9E6+53rcRq/DAT4h+VyNWiDiGwqkp4KU1pg4O2/StouzQ4J59XH34mWLsqqHK8XFWarRYInNxPOtq7kHg+qm24VZkDWNuKeQZQ+VHKavLG9A/5Rl+CgVfKOEkXfJGp5zSC4qOoV
 AQmT92Ai
 j4WMVT0Y4qk+Mpxjata9+9sFbnN9OFdRln+UDOS3LrvHgJIqVooCvLK5bBsN8I/V5Os33ScWXKpJ2oj8anMQth5Ww8qt5ZRR7tfKzc5CsqR3ZehwkuBA1v9BGncACaz/f7RwOVO3Rh8pb8FgQumaXhHBp7/vcNhLX8dY/XGignHnieoT2N3s2D7rixNv0deaag/weajcZCN8i1MIXAVSH4fpzNpOwfv6UvdhdWZfavvNvacoRC66+gcHKw07mo59x0fPM9G160l3vvmL4zIpvDMybMPSwq3uM9gFOR+lASrw4e5PsVi45IWRxWLI9dYjh8HFrLx5NDzItzmaKR1H2MbaxoZ4ILyCllxLkIDclNr9YJITgM2UWwoqbNBrNl4i5GN5GQ1Vk+46tcZQMrFjLdvopth7JxpdFmSRsZHCMe3kpniFX3CNY9iwbrBSBrTOCCvLH9iyk857JN2brR8onf0lDcMEE9WAwxMIBA6g039uh8nCs6B4Q3M8RB9qDlfhNLl0q9W0m4XEDs6eZQPOPokwzlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:27:49PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 07, 2026 at 12:47:01PM -0700, Stanislav Kinsburskii wrote:
> 
> > +int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
> > +				     unsigned long timeout)
> > +{
> > +	struct mm_struct *mm = range->notifier->mm;
> > +	unsigned long deadline = 0;
> > +	int locked, ret;
> > +
> > +	if (timeout)
> > +		deadline = jiffies + timeout;
> > +
> > +	do {
> > +		if (fatal_signal_pending(current))
> > +			return -EINTR;
> > +
> > +		if (timeout && time_after(jiffies, deadline))
> > +			return -EBUSY;
> 
> I really dislike there is a timeout here, HMM is supposed to be more
> deterministic. GUP doesn't have a timeout, what is this about?
> 

The timeout was added because this version makes the unlocked helper own
the internal retry loop, including -EBUSY retries.

Several existing HMM users already bound those retries with
HMM_RANGE_DEFAULT_TIMEOUT, so the timeout argument was meant to avoid
silently turning those call sites into unbounded waits.

That said, I agree this mixes driver retry policy into HMM. A cleaner
split may be to make the new helper timeout-free and have it retry
internally only when mmap_lock was dropped by the fault path, since that
is the part HMM must hide for userfaultfd-style faults.

If the walk fails with the normal HMM invalidation -EBUSY, the helper
would return -EBUSY to the caller, preserving the existing driver
timeout loops and keeping HMM deterministic, closer to GUP.

Is it better from your POV?

THanks,
Stanislav

> Jason

