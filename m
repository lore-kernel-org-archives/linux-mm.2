Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB46D172BC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 03:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF46A6B0088; Sun,  1 Feb 2026 22:26:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77FF6B0089; Sun,  1 Feb 2026 22:26:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59886B008A; Sun,  1 Feb 2026 22:26:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C35066B0088
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 22:26:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B4EEBC524
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:26:15 +0000 (UTC)
X-FDA: 84398078310.06.5F4B1A0
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7F6E9C0007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:26:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AgREkh37;
	spf=pass (imf22.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770002773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8y1tSjszHwNi7K6C6xGA7ozYqT29UdTx9KR8G4VZTuc=;
	b=Jtkdg00nEgf0i5jkuA9o7EwuOXsBdgcUoyLRKlp5I6Cc4aYXxPAtI4b3pJAHiFrEtKc16N
	FEZ6QcoKVuCpbhxgyiRYUaHRwGEMH6XztNZgZFQqegWMKOu+Yb5j8UvXqFh6DKG6jMWnUT
	htjaxtUt3+y26an1TLwSdXYjm0xrMco=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AgREkh37;
	spf=pass (imf22.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770002773; a=rsa-sha256;
	cv=none;
	b=M2JPCdYu2m3y6EYGdW/cb32zVPyzwbn+/Az85mMe2o2HvIiM+KmZBlAdAVdH3HTTmhA9l3
	xk4Md8ucCEAXIC5MLgzw9Wc5HjqpKaP8LLsJSr//ZW7KD7BO9aOfHC7a5CMQXPGdjW9jRk
	Gq1eNa0B+F+NjCjxH/oeFB36oY413ZQ=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8838339fc6so734026766b.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 19:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770002772; x=1770607572; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8y1tSjszHwNi7K6C6xGA7ozYqT29UdTx9KR8G4VZTuc=;
        b=AgREkh37bkXhcz8uqosAHZumyDuBJh9nMtGSOvBHsDUhkHjTlZMKUJOco/LpcDyCtC
         7VZeW4KDc469eMKDCG0yAv5vB5EGskb2tX68I03EOAnyfUAvZAA0xx9xZZMbDCnAnOjA
         NLP7XFe1vh31T9JXEIr8Cq5TX7PYn5+63VrTFvSK2wI2bTN2hFZUzc+fdpvsmHnim8ac
         kfg7BvB+hoMU3NgDCY8EG8n5Z4OfakEVxOLo8hiDcz4K4+wKjAGZyAAE1mQ80bAyLeK3
         S5SWf2FEoHCYWu5djHHncjLSZVuUrrecvCCA/XiClogtqZdOZXnUFV/v5IRKEg0AVIbp
         RrRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770002772; x=1770607572;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8y1tSjszHwNi7K6C6xGA7ozYqT29UdTx9KR8G4VZTuc=;
        b=YKYYUx9LcQuPxDjJOX8vjn8+xWvfO4KfzfjRPJa7r8fHHeazaAIls4v25fRUBvWdFm
         8oKdnx5/0R8jBjB9q2OphJXTRtelvnQSnucvWw6MrZAW28Je/JjPqAQU0Hq8CovHdEn5
         R+bviP5xBD+bp4wKTWrY2k7TGqn2ziuQLcxmxvlQL+9JAsE1y8Eey8LNoDjJ7PN7MI6X
         rXV/zqedM0XNy78Zx9C31C3WDHFnyYjxpBCtAB6wTXoUrNu1EM6U7eSEldWYA3w6h2+U
         Pmjuka/R65oOB4KThkWghSqStdwBmgHyOAaFyNp4NqMMpf5dZCzmzZU87deQ5EnrpR7Q
         MVAg==
X-Forwarded-Encrypted: i=1; AJvYcCUytBxFRLA4tYmJRxwHTtO709x2KNRi92HfM+MtQUUcFpVnPr1JeXXQ0QqoitY6FFfxQWDH7tGqMQ==@kvack.org
X-Gm-Message-State: AOJu0Yyi93F7TyH2U9sA1PmPQbPm8QB7lKgRuO7RdV1jU1QKsgAhVIg0
	vZYRV9m7/aI5uzYQ9XhksUHWydzHkrY8WllFyu0N9dmr0815OC10aUpq3BDWgc+G4Q==
X-Gm-Gg: AZuq6aIjKTyQTnixWG6hi91iawEDUkUBg6jGpShJduQr+XP1daKLHhpVZ2fOkwYg0Di
	FBZe2JiEAb+uqCLoZ9UTk5vxeejIVODXVGNMa14bRrfPkOVVMqCl7S8SY0mkaS3y+WyBGhmnVYK
	Prp4+qql4ubTNCCFEiUpsbzKspl9oHrmuZHjE4F0e8HVz3lYc1ETsYlyqcLESsNGZsIZBpIGGVb
	xAtan1Gt6NsOy5Ilr3JXZwoZyuUwR8DGCxCXvI21/vtb+WL4lajJEyli6N+Ish1noGl1ZHd/b86
	HrQuDj/4UCrPSyMt9IfkBRKw4BpcDwZUdDNn13YsXjylUWF3oyEk5D5Sxv3DDo6y1nwqyNHz6aS
	ciq5WFGeiOdAkc3mOvu9gcyEaguYYFI8CQlsR+ZoqcizYx3Imho+cBiSSI76Ackd8LRYXpYEkHi
	ZieUMytvReVVVGferreBBAOfUWRMj+2Btb3/5timgfF3ILduVnmnw=
X-Received: by 2002:a17:906:f049:b0:b87:6839:6175 with SMTP id a640c23a62f3a-b8ddf84586fmr869883966b.10.1770002771786;
        Sun, 01 Feb 2026 19:26:11 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b46abb3esm7161539a12.32.2026.02.01.19.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 19:26:10 -0800 (PST)
Date: Mon, 2 Feb 2026 03:26:07 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>, joshdon@google.com
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
Message-ID: <aYAZT-ZZSKdiChfd@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <aXh_LpTzDhvv20uB@tiehlicka>
 <7ia44io6kbwj.fsf@castle.c.googlers.com>
 <aXnDdkYmtipGwSjK@tiehlicka>
 <CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
X-Stat-Signature: r7zmiyxbyi9cpjgnbfgq4s3khfbhje99
X-Rspamd-Queue-Id: 7F6E9C0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770002773-214630
X-HE-Meta: U2FsdGVkX1/CKIeIg4Fdfs2ivwmqD+AL446TKfbFuQbLjLsHHn/3Dv8OWsBjUxLO28YzlYz/TvzIAz9a8UPns2zYVtxtSGp2Sb41OGWPJJPuxlp6Exq+asAZxMnCCput4fgeDHt8z7bsPccnlk6jRAnRFgfegvU4QWHkZVuvbH4g+W6grjH6TznW66X7eGNS6xEF1kialeFBAWipv8VuFJsp1XFTyTnrdFvrTSUBkyOZUeKCxQ1w42hVbtfv243g2vevpFrUKYYzDgaIm931o5YUv3BPNhDElOlh4f7uDBGSEQfD/nAwxTk0RxOCxVsBln5d69S00r+bFy/ike9CdtD4vSpYdjD1UPuq5eHb6ZMwRDg96FOjXV6Jf2wbR7tO2XYYrfW3fCqpJvazbKR7TQubBNkAfeZJD2NBsweJavKNNESMoVB6t8v1nzUFq6SAB7cSyt7Gd0FksHuXRe7jqjbyLH6TrYLdSFsAnQxlSXqqqC6xFRAGCdyaffIb1NejrCpRwxINTMlwGqRyZmDqusl8UJumrNheVlx5ZfdZTlNqE3R0D8yhgvQ3Lz4V0CXZKgGwGYNfTLvsWvqN+7E9l+YiYrcoDwAKaZqNuegdhurv8zbb1WZ8iBY/j0kS7vgQcVWzQdrPMkeeYux5xGOammtf5nurqJYAm/tT2zlOK52NQkt8a2W1VVMZmEjAxL++ifFtJpiQTPMJSb9bn4Ry0frG5+TxjMvJZEEVlFV15CnDws05NWXsmJ2ZBua9G4af+hZXptBPPAu8nLhSP30kkw6nGhpzx4mqFsvGf+t+SnzG9QYJp4KhYc+/qVdlZTf0XofB6lBXnnla0uwmvIR0hRwAclIJDK1hfh5v6zkyTLDzR2rG75xitmk61TD4gAqEqfPoC/JWK/3mfDoOYGiF/hmjZ5iirBGH4oNRJN5BOxJ3BPP28bxDajd7RoaLCktQzor1jangvtl9ipwA+uZ
 qwH6DIjn
 lJVX0b72JwVQY0Qf1wqNNueXIEaHJw1C/AZ06p74HKGTmC/Eo9wPGX4KgX9/KGvN8ORL+6Q0+fBCSxWOXjnDnlv2XBYS2QejDvUp3papwafEo7t/fjTmdK3X87rlbKfEeiwcv+2D/eYbbOn4+6QxT1GRRjN3U4jt27W3DKOG5gYdj5Us4dTVgPdijKXr7V0utMWfUK2mEZrYrFD+da7u7kpGuDsxZi+u9xXtDPJweu5toU7c9TPorrh13Zw80GOd4Vl9BZWjPjP0tKVXC+TfguMtSsC3Jt5oPZvb21hAv6vGs3zA2enATOtA1NKuLc2F2vcPBDJv5QZbGZcBls6obdNDRGL0iN8mJ41X8S0De+nCAD4pc2HNqGFDXCvFjC5jYzkhDxa0LZYN6qJHRKJrCN2J81nQ7qrAoC98Y/PsLto9p52ZeI1K8hAx28fAN/4CQ4BBoz0fBNksv6BbSZog7Nnbz2RwnlQbXdO4yZ3SU6K9XPGt18zpd3DOSaHNf504IATWyg/0Re0Zfcs7g/VuJU6a3qdIHg0BCrmiM2AX/FvGLGNcm2PmyfjaSMkcZ1nAjR91XfQP2C4cWCVFfTJtFjItlH+mGqyqENbyT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 08:59:34AM -0800, Alexei Starovoitov wrote:
> On Wed, Jan 28, 2026 at 12:06 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> >
> > > Another viable idea (also suggested by Andrew Morton) is to develop
> > > a production ready memcg-aware OOM killer in BPF, put the source code
> > > into the kernel tree and make it loadable by default (obviously under a
> > > config option). Myself or one of my colleagues will try to explore it a
> > > bit later: the tricky part is this by-default loading because there are
> > > no existing precedents.
> >
> > It certainly makes sense to have trusted implementation of a commonly
> > requested oom policy that we couldn't implement due to specific nature
> > that doesn't really apply to many users. And have that in the tree. I am
> > not thrilled about auto-loading because this could be easily done by a
> > simple tooling.
> 
> Production ready bpf-oom program(s) must be part of this set.
> We've seen enough attempts to add bpf st_ops in various parts of
> the kernel without providing realistic bpf progs that will drive
> those hooks. It's great to have flexibility and people need
> to have a freedom to develop their own bpf-oom policy, but
> the author of the patch set who's advocating for the new
> bpf hooks must provide their real production progs and
> share their real use case with the community.
> It's not cool to hide it.
> In that sense enabling auto-loading without requiring an end user
> to install the toolchain and build bpf programs/rust/whatnot
> is necessary too.
> bpf-oom can be a self contained part of vmlinux binary.
> We already have a mechanism to do that.
> This way the end user doesn't need to be a bpf expert, doesn't need
> to install clang, build the tools, etc.
> They can just enable fancy new bpf-oom policy and see whether
> it's helping their apps or not while knowing nothing about bpf.

For the auto-loading capability you speak of here, I'm currently
interpreting it as being some form of conceptually similar extension
to the BPF preload functionality. Have I understood this correctly? If
so, I feel as though something like this would be a completely
independent stream of work, orthogonal to this BPF OOM feature, right?
Or, is that you'd like this new auto-loading capability completed as a
hard prerequisite before pulling in the BPF OOM feature?

