Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9ECEFD88D4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605B96B0088; Tue, 10 Mar 2026 20:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7C36B0089; Tue, 10 Mar 2026 20:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACB26B008A; Tue, 10 Mar 2026 20:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25E306B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:01:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FF618B61A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:01:07 +0000 (UTC)
X-FDA: 84531826974.03.D27FA8B
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7BB9110000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:01:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lEGFw/ly";
	spf=pass (imf14.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773187265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eEDdOnuoN+4uXFeXQVdnNuy5kSNMswYGhV2JxYSYJ0=;
	b=Kam/NgTbMR9oVnc5AU8egYx6eCMjtkJMirU+CJNSX1hEB6yQsttmXNyVuXdEJJo/4zbrpI
	qU0egbPwrPu9MlTHgdaSirEeiW9opVyg8cM96h56y8xf2dTep/IR+495vwkPNMgrijPcJz
	9O/xq8nsujd1dAG9rLA0RJYr70bW4pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773187265; a=rsa-sha256;
	cv=none;
	b=DXKLw2/8qwq6NltxrdBwMWN8QRZmRq3E1BAyQzYBwtgw70G3FVUIQtkrrK18c3HWHqOQOj
	rzA1R71z1XToFWNh8XiCHiCu+GEkM9ytiL1/r4MrfwSApFEG/JXeFQ9PDVGm+VuZ2JChAE
	W+DqAEEe4DkLR9hHqp8DK0fSdU/+5MQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lEGFw/ly";
	spf=pass (imf14.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48534237460so35216905e9.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773187264; x=1773792064; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/eEDdOnuoN+4uXFeXQVdnNuy5kSNMswYGhV2JxYSYJ0=;
        b=lEGFw/lyA+JKunU+LsWRaOYdUOut8HJV4RIe8CsgbBRNpxtfSOop5oNJQ1+dwQkzhy
         jCzOUY/0CfED1QGulufZSwYMVGbwfz+8v5wWNCZWhFo+sEfDlKEUvD+toD86T8qwRCQs
         EqGzCFm+WVKkwtVf6NOvaEvrcN+JoBj2SC7JARIrEvIpaJYKUJyxigazfTWvZy9yNNus
         djolCH3pn+JMQnYSJB88bR4Wg0GHFh776fQV5ysr6h83nTvj2mFwVdBuY9B1CB/TACpT
         U9UkBDj7NdlRAsQ3vGGJSyxtLjjlKQfqaqJTGDI9QX5i0eklwF/6JruPv47PFB6rHNBS
         co3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773187264; x=1773792064;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/eEDdOnuoN+4uXFeXQVdnNuy5kSNMswYGhV2JxYSYJ0=;
        b=n+bz1DUR7MlAPrkrLBpVBzhX9DmvnXgxdohucXu3I7HcdEgI3iOLCZriQZ5Q6gyL5d
         DGyvkPWp/pH8Ha8AejCeOM/ggfWQNZcdLHLi5oiLrSUkMC6cf4iW7TpfxWRwiVDjU0Eu
         DiCDaZgL1lG8Jgxr+iVcqLBE+NzEr7S+MmqLGX2nkeB8+N5VZsSUtXKsGCw3hNdSl9uR
         08MHdQmMAtKqOq1DKXYDc+jOx9UPov1sz9412d3o8ayQk3Muru1ZM+SOkeyKW0REQGMV
         hgyEbr8/6CymyCp3ZGlE4mJS+YpzKsRMsTcKL1ndaC0i+Q9IvxtJUAdd6u56be5ysfaN
         5NXg==
X-Forwarded-Encrypted: i=1; AJvYcCXxqnf55CcOfZ+oi7K9cYz3uLzy0eOGeSUyybtLvacEP5CeyEOCgymQ//2yldSkR8ap6wmEW0UvMg==@kvack.org
X-Gm-Message-State: AOJu0Yw3eDNaBJedL7Q+26livW9FV/5n7FA4fK/WTxnavOHJrEeN2dO1
	EGnVWAMEgmC4IHxslYEl/djdxEraKuRErhPxhl+ZObczTIx5cYo7aT5t
X-Gm-Gg: ATEYQzwBE/h5NzXx8Xayc67m0cxCNEeZBw538LeD8T960YqxhHO29bM/VGUFsTAx6Sf
	TElzynbuC2UqTgZbmm+yLfIA+Wr5cLuJ68Hbk7M8MaECs3TYbGQ/AjAtuXxf1EC0sHLK+1glkF9
	NpRF91HI4R3dqBugtgQ2JzPpLsdjapYiZ0rnJl71CnioC12cudmeTorvOGwvkzdANIr2cR9Bhc6
	C7uqQ7ZK5MpbfNfNhoUtDW/9C5NJuqu/xtNWedy1GT7PDlBEBvDuqcYtz8yguL7VNquFyPn3vxf
	xr0OijkED07UbsAlul3yGbIIbZjM2mgELjhvJ8DstqbX46LJFvcOpgpJ3JqcrjCJ04j1vo22dEA
	IlNR2rCmoqWn3e7bZtFpdgukzf5nEPfVqLBNBw+4EWZSPhgQ/9bHSfLHKfR2VfEhO1Uv4Jv3j/P
	a2dL6wayr2rQEThNASL0L53HhsZDvTgsHKifA=
X-Received: by 2002:a05:600c:1383:b0:485:2fe9:3375 with SMTP id 5b1f17b1804b1-4854b0bff59mr10920345e9.15.1773187263637;
        Tue, 10 Mar 2026 17:01:03 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b0bff95sm7638015e9.3.2026.03.10.17.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 17:01:02 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Date: Tue, 10 Mar 2026 21:01:00 -0300
Message-ID: <abCwvB36SLGC_7Yg@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cbd42744-31e1-439c-b0f0-0cad052d3d9b@kernel.org>
References: <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka> <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka> <aZjY9h3XXMNY-Ytd@WindFlash> <aZwYmNuucBspCYhk@tiehlicka> <aaJDjmnfuo8AM6J9@WindFlash> <aaYpICV55B70U1I2@tpad> <aa20uDGqnmiqYJ1w@WindFlash> <cbd42744-31e1-439c-b0f0-0cad052d3d9b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dm318x1x9ak79a85d8j1owygjysg4oh7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BB9110000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773187265-949308
X-HE-Meta: U2FsdGVkX1+J0b8J0oDhkig6eAZfr6x0DicipxLcuCjhQn1FTpGhdvZ8ENSV+W0XPVZ17AyPidNX64W43+U/70MmeSQIQ/qrrFBTh8iWJOJBT+3mCFRq18fvRrPPnacB42YdNZlksjw+00L+EWXetgdd4AglKYcJd27fDtu+t/ZIRKG4P+gm9DnAtm6x2ZEmciNRsyKHUr2r0xE2JcKy6Yn7HdKU/LFRBUpIrsak73kFBWqKBgfDTvsVzhrEAIFDV1FwWC1H64PnRBX2T3dGxvx/gpuNfoJc8Pq3XGvo0MxKpLa6l9rz/WRZcyAIbiMG06ce4IWA8uHQgcOoywy4FSzcu+NiG26OVQ1wUbT+FNsDNfzU8umenDqNyC8I7Sl1p3GSDYjxePcOitST6Tt7ptvdIOs9TWlTCDCaHz7kV34EA1OKL5TpFoNOp+866oYW7gxBzlryG/hJ/5mAaV6tyD29cO8DRjEk2gdkvcpFlolBHPSXgOTXM1Z3VqBsWPkcSGdGs3vqqFam4omSOumbhl+PD2XViDND1NuWE5tuJOaLQzIKw9pyAUor2F4CJS7v0U8XtWEd+aEHCP3ZeLH+mqcLDUGEhpBhkBH2VMTbJGFxE+fURB/w1MXr2EGgIzAPmMUBjt0WrScetStZU7wVliR9Jjp8OJ/kM99cWz6kmizcDL1WBp4PUfMG/px/sEYuZAUJBKSsImRrAeL5o2GSvruZtW8ec+uxSaOsx0/2QcmHwbXHR/0EQ+dFCDX/n1KKxGVVFuJ4Dc0ZrWYnS2CC03EVtACH2ZWkhoWiMhYXU2UOA9AQqQeLCd0V1L90ujgIIrDiOE1i29+P43osixE1xWeagmaE1U1thhUF9XC0NJ9UfjhuJBuCD/XZyHZCU8//hYM1k50GL2HeBvdqPpwoltbggXc7JIX2rUN2kgpPfBzqNkL3miU3n30DdRXlmW2Awlwq2nbPcz2siaxPiaD
 c2g0ngVF
 D1mYrR84xoJPIUiFha+sTwFTMS+C4NfOB1jm3xTyA4goa2FQfiq8EF0hvyzNYYJ8COWetx6uHtGw5V807oiPt9grEF4B41Dtobxdo9aYjO6NoLUHUdxajOe1AtvewZ0HZNFpiuqDXkfvf9a8nfJRyrTxk0lPB4frtLUekB64HSN3rGErsFVOU4OTnfiN5tkrUkDqG4uLCoVDgf+kZqp62xr3wYN3xeIXgR/0CrET6pLDPcAemMmt9MKe6wyVGzeMrz0tJaIJwNsNShHw+KQpfz1tWrfAmaPpiAY6m/mlSiNsOAsNhsbM+qyC8KXPqPmfV9oJXjEGxVeFMaWfmLKiJX638avn+QHBiNaXrS2pXYNtWw6/hDXTtgOuucj0JLQDYCTv76dfd6UYLLbPqijhndbYXjkVDD3UjCNkJ+fnLOKC6Cww7SujenZWG0O1QVYa+eocatHdH63P6G4V2WIYfJL0qm3eYd5b7Q7YsOelG1ZtAYjeZtk7U8J86eEbBS6IU5ui64HF8xzhhJFYT+/8pOCdzCwEJq4zwwJnXklWgKV36ylabyxhtebpbzsqnpCRl+4IYA+XaByCFVJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 10:52:55AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/8/26 18:41, Leonardo Bras wrote:
> > Hi Marcelo,
> > 
> > Great, hiding migrate_disable under the static branch is the best scenario.
> > 
> > I wonder why we spend 2 cycles on the static branches, though, should be 
> > close to nothing unless the branch predictor is too busy already. Well, we 
> 
> AFAIK static branches are runtime patched to non-conditional jumps or nops,
> so there's nothing left for the branch predictor to do. Or maybe I
> misunderstand your comment.
> It does however increase code footprint and thus instruction cache usage, so
> maybe that's an effect of that.

Oh, I was not aware of that part. Since we can actually change the the 
branch decision variable in runtime, I guessed that it was just a optimized 
way for the processor to use the branch predictor.

If it makes a non-conditional branch is even better then.

Thanks!
Leo

> 
> > can always try to optimize in a different way.
> > 
> > Thanks for the effort on this!
> > Leo

