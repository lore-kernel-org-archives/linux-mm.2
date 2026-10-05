Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99243CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2126B0088; Mon,  5 Oct 2026 06:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2631F6B008C; Mon,  5 Oct 2026 06:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1524E6B0093; Mon,  5 Oct 2026 06:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4EE36B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:43:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D2C7A01DB
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:43:52 +0000 (UTC)
X-FDA: 85288237104.03.9824278
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE45E40005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:43:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=MvfhggSl;
	spf=pass (imf07.hostedemail.com: domain of hsj0512@snu.ac.kr designates 209.85.216.49 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791197030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyhge/uJYGnijVR9ixeqw1SZu6gs64VLCeBEpS6Zzhc=;
	b=cGLxGhHJqpgoEA7VWEEBmDdpix4RZUHlmWi/JFkZCok4RPewy+CJMIwuJ9mBBS7YpsfDH3
	9Xn9GTrl+9YaHSCQwUY68nZVJEB/PH5r1X6OzGhw+0yOJFMpUt7Lalgb63DJeJm+RxaNMH
	xsPl0JahP1sILJxKaFBqUV0YpoRF7Q8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=MvfhggSl;
	spf=pass (imf07.hostedemail.com: domain of hsj0512@snu.ac.kr designates 209.85.216.49 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791197030;
	b=V8/mauy9VJv2QMze5+ycN68iahSaWoSodhvDMiQBsiv0DmsajvWB9vmc577UJVpLrMkPYw
	fQoS+rtgSjDCPeXHVASNxmNTz3iZigyp2l+M6vLoik1nhBOkOJN4ll0F4YbAV/FdyBkaJU
	zJCEPPJWfUaXA+Tq/VEJpg9zbsFaztY=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1080452a91.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 03:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1791197027; x=1791801827; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nyhge/uJYGnijVR9ixeqw1SZu6gs64VLCeBEpS6Zzhc=;
        b=MvfhggSl8R5L10QNF0khntemeciHSH+idFvkcVZQKDS6KSH3Np+jMi+q/iY83bIvGX
         AGXzm4y/5bzH+zvgOnudQXrjRU6RfqihnqIczEZ9NEikSGed6sbeFzEDuvRiqGVXqv4f
         OwEmAW1mY55V57y8K928AnSyHjLeTRjIdpBP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791197027; x=1791801827;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nyhge/uJYGnijVR9ixeqw1SZu6gs64VLCeBEpS6Zzhc=;
        b=h7LmuWvym0PUE/Nu6p7ASUicrpJPAtL+xxVEC84UV1ZWOqcrXhO1N/ZTwiAUO5f58s
         65PGf/QcvO94t1hVQIQC3VjtD9gh61IMYwns9U1hX9+k2sEycTKvYPSed8L0r3eEtwUo
         r+MeZdz3y83TNvQIsxP1OAb02ZIylmjCq1o6jwr9e54CkCbo3JBDg/7meNwaQKKc9syM
         GWqtsxirBaJnSTAI+AFkTe/kSZBgzykCvsUiW1qiPTkk9XGZ5xNFbL/bu/EP7oQcEP4J
         ss2tGVsmcxWJcW3aKYQfvXllaZ6+oJ2XbUk3Wh4M+tKjpPekQ807cFTcSvGfy6lRwtNS
         aQeQ==
X-Forwarded-Encrypted: i=1; AKwUvBz59J3A00FxM9aFs8APExOD+U25SKP0YkwoO0I9CGSq9lm3HeMkk+39tsqANxFJkwOmb5qZFwoZbA==@kvack.org
X-Gm-Message-State: AFq9FYLm9ZGQJKYTIjOBYVGD1VKsHXbHJ4m0HAb2gbLXkNP1ji0i3LtF
	U7TOdrfoNnzHpXCjNn+4EMa/wQSIf0mAXj90BYqdVNU5W5f2L5M3nqcut+OKNmbA1Pk=
X-Gm-Gg: AYBFou1vIjvgIj7Ih2U2vpE//dIC5iU7U9qpqYioKKMRFQSlOAJYKifZO8oRXczHZlb
	aTj6Eye5ukfWSyZbxawrNGSnuw4xNt7zT2KSlHt6ISHlfepsQkV2KoiKaNwkzVrF0vyLNem8vaW
	DOk7jevoxKMVxIr1bhea2F0iTlxPJDDpkRKVboewmhOHAXDT0CQVrBTWmEF0SJ/nUsDIlT6agYs
	Km0KziSU4y0UnOUsxZlKN+FtrOgHcSZ68l5/BsoYHd5w2wWHBXHyBmHK47ebVPBtB1W0F8KrdPV
	f18n2Cnddok/M36zNQbOSfAAWETZd3Jf1goApw+HEzmcrx+Iq9Uwtng4BnMr+9O0jr2AcC0z3pO
	jX1Yl6rTHkgxlXLXoTTbl7JkoRM9dPXrQUYEfe8vs6SgSc+87FSZWu+jLhU6VRlWj1efYCHBikT
	cCPUoEi2jwaeW1EmTMX6jldF5ceE0V+AZGhrG4QjZ4mcFFs2wIDbgP87RXOU64Llti
X-Received: by 2002:a17:90b:388e:b0:398:b1eb:136c with SMTP id 98e67ed59e1d1-3a78673670bmr5645882a91.9.1791197027272;
        Mon, 05 Oct 2026 03:43:47 -0700 (PDT)
Received: from 1c1aead48890 ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7dbf4c81asm3142994a91.1.2026.10.05.03.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 03:43:46 -0700 (PDT)
Date: Mon, 5 Oct 2026 10:43:42 +0000
From: Seongjun Hong <hsj0512@snu.ac.kr>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tools/mm/slabinfo: refactor slab attribute reading
Message-ID: <a6cb4dbli4xaj7dfl2gwklq3suxz2nhrnjvrle4qrj336fxl4f@sf7de4bndqtv>
References: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
 <20260927-tools-mm-update-slabinfo-v1-1-a4ea0d4dc136@snu.ac.kr>
 <arqIzSPQVDky8jqc@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arqIzSPQVDky8jqc@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE45E40005
X-Stat-Signature: xpkbprewqzro6c7fdsb3j9udfmi8bbh5
X-HE-Tag: 1791197028-853256
X-HE-Meta: U2FsdGVkX1+2NtfwHITWSCdmDKbqjM4xpHl0csd2qDgZrM1H3/oEt5fB8Pc9X8HGUg9XqiE+sLkM4eQh+IjyQqkXpo25vsQ6l/M/q99hhweJ5wOTBkdh7puxPRsXp5jN3XxoKCL12Gcyum7RM88UGd1hgOmylmdoGGQiil6Zt7LPrTxHkwoR0tACpnAEN7cmW5cBLoV2hWFss3/muVGU0ylopowLjndkRCKBwgG/eoqRw7P00ooBD7GcX7go24iLbQa79yECurwThUERyLO0fVAdfNq4h9l55mxL3TnMvZwQygU0OYVq0msaPNtWbU1EkC0jBh1CuLf3coZO6eSZGy+JJsX+pnwaTgPsRFtab3oCcCiPS18VdidqfaN3rJmwguF3DEiWBDG7zj6Grzit+R1fLCJpPPtGcIpu+EgBWHloY3cWpyVp7V8jUQ8kGtFOLyhALIHssYYE6viNVXjBvebLitERIl5DdWB+LCax+V/zEMQPWLl2FiRgJnNLd2viKA9AGtWJjMh+wdqgWfZChFA5nqR4w+UkASdsYyJo7cFMuhIs0IBTBep+/FmzqHwaGOjvCWMzOxGW1HFuWLfipOU+vZVM7JGoijkarEcX2zS7IT+Wlb9eZ3JrIkl7jT9esPkLLvm6cfUPq1IxPo9vd72xaYEuw24I9Hg+3dzm3rhGpetPQWsJvnUdm+UFF1t8srejokdEpzRJD6hQIK3GtzdJtHHMT9sTsuW2Fak/fd8DXVm/saPROZgKC9//f0FLvq9RY5FXSy8qAxn01vnLQVQop/4/LI57zFi5MCb/BynS/8uZr1xTxPj7eLlic6UcwIMZ642LDqZQLoFnmUXaZ2A9N/EIS85iki8YDUcwPpmB5uObfVkEn3qxV9Gy+biY+dk9J2dR1AC4IWLXLBjIAiGB/bWWckHWHsHnPcjoYW0gc6PDCByyUFGpgqHZm2GPCApUaa2m7NVMGg7/U2D
 5LO26y67
 CE9n2/mV5ea9t7pds2MCLb/i+fEriX9r2Evhppqy81PLOe42jGU4y4YHQIy9V6vQzN+Opa3z9OfbwWEnn+Dq23SoBDfyBazzxiMfDvZcH3vl3y7N0wZB2n68NVTTzZMAl+lEnzGwuY8UYsUN9M46Rsv1/9SlZd9BBymbsVt20dmvrCJFRQDho+xuWkTdSzciruhhLmEjyz8sTIJOVg+MQft71cFWG1fp7DjL3o1VJ+0+NMq0Ze1NuArep8c2iAmsnjzJOTEQ8MT8574MMdyXw0I/Lz9uduj1co2z+x1i6UlidUFSMlWa7sw15jwAjLldJywiat7hwK7Yin5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry, thanks for the detailed review and some nice ideas!
I'll address the comments and prepare a v2.

On Mon, Sep 28, 2026 at 04:52:08PM +0100, Harry Yoo wrote:
> Would you please separate this patch into multiple patches?
> It's hard to review when multiple refactorings are done in a single
> patch.

Sure.

> > +	 * Deprecated files:
> > +	 * No STAT_ATTR()/SLAB_ATTR() for these exists in mm/slub.c's
> > +	 * slab_attrs[] anymore.
> 
> This part of the comment looks fine, but
> 
> > Although cpu_slabs remains as a file,
> > +	 * it is also outdated and always prints 0. Keep these for backward
> > +	 * compatibility, but they should be removed later.
> 
> This doesn't seem useful information to put in the comment.
> 
> We were able to remove some files when
> Documentation/ABI/testing/sysfs-kernel-slab says
> "Available when CONFIG_SLUB_STATS is enabled", because that implies that
> those files may not exist. 
> 
> But it's not the case for files like cpu_slabs,
> and I don't think we're going to remove them in the future.
> 
> Probably simply say something like
> 
> "Deprecated files: the kernel does not create those files anymore or
>  always prints hardecoded "0" since they are deprecated" ?

I agree. That sounds better.

-- 
Seongjun Hong

