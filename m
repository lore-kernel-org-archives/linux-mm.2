Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452C6606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZtZuC0NY
Received: by kanga.kvack.org (Postfix)
	id 3906D6B06FA; Thu, 19 Nov 2026 23:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367E56B0745; Thu, 19 Nov 2026 23:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A52D6B0747; Thu, 19 Nov 2026 23:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 012FC6B06FA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:00:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0B0E120D1F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:00:26 +0000 (UTC)
X-FDA: 85454145252.03.411E9D2
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf24.hostedemail.com (Postfix) with ESMTP id E99FB180007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:00:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZtZuC0NY;
	spf=pass (imf24.hostedemail.com: domain of 31sX_agkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=31sX_agkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795147225;
	b=FHahaMuJhD0lAcIID3TESz5ZC6UYcCjnXMfKbQcqsoOFw3vhE0oxqnAsGtKvefawSZpG8G
	XpAIzqMe0UxUVfebToAHy5ewDHtTVUua16DkpPCnoeZp+eBZD5IMx3IhLXpEUW6aBLKGGV
	cgvtX0eay0wAkbu+MHlwfnzJj9x+yE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795147225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K98FROqv30LP4AMm6nG2V0NGt/4i9m8U/QmIKGR/nHA=;
	b=V5/suOdJkUudi5kbM43Khrc0AAYIKvqhlhRCA88dUra1tgoLfHe7LVulUxNfDBzFbnZuMl
	6J3e4idQgPYbvJbA0udXpswXPmXwxzWhWzRSdOhlveDVxBFSRmRZ4TrFaornXk63FlgClK
	iVaZUju3hBwlXKhZ1vC5TGHoRRNtwWs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZtZuC0NY;
	spf=pass (imf24.hostedemail.com: domain of 31sX_agkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=31sX_agkKCL8yfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c505ee610feso35811566b.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795147223; x=1795752023; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K98FROqv30LP4AMm6nG2V0NGt/4i9m8U/QmIKGR/nHA=;
        b=ZtZuC0NYJkENPtRwAGImzB6TJQKCEdkLV7PRxAI64U8XR5hwgWpGZnhX0NmQhOjatE
         QouvBAUzsunp0z67bqOWtqD/Lgy5jaZjxKf6/LjV4cz4Ov5WUOeDLe8DKF00Yv8+6ZWv
         hYSIVdKu+8qjYO6TwJ0SpnP3X1KmOkyXLzV2cGT3RT8HtjjOD9fV4zKxu7cEHDcDQOOc
         kux5DGy8HBCUu0UzXenz1pTesSTzRz4No3I2oTcHjDcuG2CfnGghg2UkwNPdbiWTB1es
         3gM90AsX9I1Lk2wnqR3cFbVRYe701bYwVzeEW87w1C0xd6uJDF3tusT+e7v2vUMnAPnE
         KipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795147223; x=1795752023;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K98FROqv30LP4AMm6nG2V0NGt/4i9m8U/QmIKGR/nHA=;
        b=EJsrLWraLzFQf9k+tzN0yf6is9yFoG3QPlZD0J7A7JXS9DIbiQHFaGNqPxRcniBy5x
         Bgb29NyD5giLwRcJfgC9Z6l7ltL/N9V09A5PFiz7xfVVR60l2XvXWCw04d8HeATWsWIb
         CJOnujDfu6eWEBLHcOKmWkZFif27tFK+bRqQBM/zIuRXuH9uTl0gAiKqIra+o1NeUqqM
         N/jTSgZX/J8t9W8+u9MOZQBvCVYNBnWqnc3lJkISQ1ZiZztCrIkFgZrc+3rAsS3Jb+Sg
         05ZPpLrKw2OrRJ7ma9GGzjQbzBe6K5YUhNGK/CN0KCkx+IOley3/hBJG4THEFO8gwWzd
         IkhA==
X-Forwarded-Encrypted: i=1; AL+hErF/7UW9GBNcPDewuSpFTEMpJoqaKWMh799hnhzmdi56GyRD3HSAUv9xGZnnbqg+9ueZECIl96bUOQ==@kvack.org
X-Gm-Message-State: APuU4Z/nfWpeDPJ7sTA3/yS3wZLswimyEaPEW4PO7iRp9J7ThcFMjNY6
	qySBVeK/+UgA5NfW+KHNv8/d3HLStNAZc+RSxQ5+0QZUsAH/0fFHNRUxN8E7PQU3vIiEZvLP51h
	rt3AyL/8/hp89EdN7SQ==
X-Received: from edeg3.prod.google.com ([2002:a05:6402:5643:b0:6b8:a08a:8bad])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:501c:b0:6b8:afbd:64e6 with SMTP id 4fb4d7f45d1cf-6ba37edaf1cmr1021371a12.42.1795147222675;
 Thu, 19 Nov 2026 20:00:22 -0800 (PST)
Date: Fri, 20 Nov 2026 04:00:21 +0000
In-Reply-To: <20261115203421.38c206b35f5b12e6@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-6-tarunsahu@google.com>
 <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com> <9huz5wy4tufo.fsf@tarunix.c.googlers.com>
 <20261115203421.38c206b35f5b12e6@chrisdown.name>
Message-ID: <9huzmrr4f8yy.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: tarunsahu@google.com
To: Chris Down <chris@chrisdown.name>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E99FB180007
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: k7169hdd8rd7tb1oscte8z1i133xk44w
X-HE-Tag: 1795147224-112749
X-HE-Meta: U2FsdGVkX18imjIlP0rEoRZ3RRU2sPJWdelTQao7xpp/WDcoF6xYdAo1gx1Nlzq3JFMGg+z1QKuQ6Ob3ASFn/9g7Phmri/41AstLYtVJvrJewAWzULKGXhoZXfBrzQthOTHzXLJgzhq5cOa2+WyzJFO4ZTvrWXBbsEP1Vy1X8VEUcg0+xLFRR9gqb6ieLFjsvy3r9xK7CFRy9qfqTWGwaV8HwsMYeELyLRqEEn69uU4/D2atRz64F4sQM/qIK0yrbbDasETSAzICADAsus48kCcXbaGCVAfvhUU6Cs0j4D5DAtEeHjpASa8zUgN7mP8OJKlXPsk+51vPq3kAn40ygLz/SPyonlEfv1UbXo7rA2ILMYJXfQZGMDfP2FlT055in2ISUuF/gHJEMaMvBVELWaShyclaMCJDjjL1y0jmXLNi8UFaJ7o1m322fge+etyO0P74x+smZgZtQyNcuNMOFfJbspsZ7jwNdtG++MkPv22AT16FhGUTgGhxUaCyIydPdR4pYwyfMjBafD8o8QV+ea30eB6Cj9Mf36C5X9yyzDMTA1zHUuN9g+txTisvNmZpON6H7O3nbtYs4xcBdyMfnNmCS0jxDcGcD0U+GImJ7jDYnpUTvb7bQZVYAGeETbu65hDlNtWWh537va9YZNzdQThvz2uE+9awEvdSNnC4HGjWJLpo7J7xTsB4fwg0A25EM4LbFGlwSkNVl4ot5F66wT556fCEqrjXO04cUg6DVGtSkuOwP/6q5w6m7W3Xpl7Uw2C6thliJvlXTnq5lIJSAmNO+vV6etFB/Cq44lrW0WRiemSxPsAT/DS4G2BmAni/pl1k9J2YeOrvD/tJPsPi4KRRfxtAgu6qaZim+3QmAoXVyq7sIYHYTjUHTkQKJcMVn94mM6l3xBX//At9VZezpkTAlGiXNMXjBnEwWfMX+g7uMuiikZe3ysPBM9rgtM/a9Zo3WtpZgHuG6Z0sXWK
 l+3a54iB
 yaj24D8rkwVxkNuPPcEpuViU4iUbVv66GplPTOnoAGLcG9hSreAe+umbpZYuqrtzQXmCGUiuIZS0n0VsG8y6ZhZsDbK9axQObxnV0Dv3iwKanWcQFP+h4E+gb7RIRnUSr1zvVZEBGCwG3e6Gz40Rg8N9hofd4/g4fB+GOJ9tyB8V9M7H/w1IpGzJhoBMtmycv8HzzxLcUP5SASoznhMo9QKcvhU3LcWIwFala4G8fhJODnBOnt6Hwn0e/bTM2HAVGpJm8PhFvdfK2hg3aFwSA3hl0+4aek7YZ2J7keGZ5x3b1XWlIzzzj292WxsB9Pcqcg4/ol7tD3uTKWkrCldVX5sxG7x+QyEhTrh+OpqfrKuo1jHjTjZMWYJAmNadhfD7SlM0seYFqwNBcVLGTclcHa7SxSaFT0LHmnVFADJ/WKqpxxQ2A95d+fXMPHOA+vWuf8Yr4qAaXv3HPOKpyCfgGJMpV+xQUR0/J4+KiFqr3ulJ9mIJCczr3YmI+DYUFK5lflpuysrIeqFGT+H85kh8wilWO/xqleTCsPSjVmxVBDyeLXDMZuyJXcZhlawf6rQE5l3BuidvB9XVIn8/XCKnlxWHhHl1GQmC3XYpu2eHBgjj7fjCeMkdp290C1VwHue8QGDbSiZL/jwbxBGWyCRY9WhSnxp9qeyl+pfFDGxT324ZNcch4JxaXb3i9p/iWRi14A/tyAqN8IMXB61s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Chris Down <chris@chrisdown.name> writes:

> Hi Tarun,
>
> tarunsahu@google.com writes:
>>Techinically this is just for readability.
>>
>>WDYT?
>
> It doesn't help readability in the generated docs, though. kernel-doc
> splits the parameter list on the comma inside the macro, so
> kho_preserve_vmalloc() comes out as
>
>      int kho_preserve_vmalloc (void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc# *fhdr))
>
> and the struct memfd_luo_ser and struct luo_session_ser definitions in the
> ABI docs end up with a member like
>
>      DECLARE_KHO_SER_HDR(kho_vmalloc folios_fhdr;
>
> I'd go with Pasha's suggestion and use struct kho_ser_hdr directly. The
> pointer can then say which payload follows it with a comment.

Okay that works. Thanks Chris, I will update it.

~Tarun

>
> Chris

