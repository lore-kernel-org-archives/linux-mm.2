Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB9DFE5215
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829816B008C; Fri, 24 Apr 2026 07:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9DB6B0092; Fri, 24 Apr 2026 07:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF096B0093; Fri, 24 Apr 2026 07:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED3B6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:55:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26C141A004B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:55:20 +0000 (UTC)
X-FDA: 84693294000.13.F79C36A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id CFDEB20005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:55:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e0HeLhpR;
	spf=pass (imf13.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777031718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEN+2szXTqM9oTIsUX5r8HOMqWdfRhmjKH5pfjGEKMA=;
	b=AW6ewd3wAEWqo/FiZCZyxRtmeiNFzzpJhQhTzRKh1yKnZe2uQx+iMFFoIfKGrT8CTGTmOf
	iUoYmvgCFjR/V4mGuERJWeXvF++E8Nxp4y4bFzZqr8GY0SvyJXFQnGjEUHtE7/o8/44Ch2
	UBc6O761+cd9THf8SjrHmBvvm+DdHR8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e0HeLhpR;
	spf=pass (imf13.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777031718; a=rsa-sha256;
	cv=none;
	b=D/vxVnxq9bmKOChqF+DUErQDzNN5zzhjpVkRbhU4WJ36EVtzsFvs235tgUuFTXMCU8ItH3
	1dJAmL9aDn8oGynTZwapmEX0yZYyVjPpfmi2cM2Eg4BXxW2qMvmt5E4UptpQMsQ0dTX7aN
	kkOZvXeJ/2qrEbkddyNWrNxG3cYiZrg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777031717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nEN+2szXTqM9oTIsUX5r8HOMqWdfRhmjKH5pfjGEKMA=;
	b=e0HeLhpRZEGYs2m++mNc43sQdLDXtnGQELjh6D+uOTXxcPjdktF3BsaOCZ6T6EXWqT8QXo
	r5AalDEE+ZedIgN7LqHGTPZ+I9AuIkJ0IH0vjb5ck2h1btqEtAw/SgaD0e0UIkWRvvkuwL
	CFtoHl2jC3KjW1lXVoJffzW6z3QN3N8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-zJ-1nZKfMAypPcNv1CpjpA-1; Fri, 24 Apr 2026 07:55:15 -0400
X-MC-Unique: zJ-1nZKfMAypPcNv1CpjpA-1
X-Mimecast-MFC-AGG-ID: zJ-1nZKfMAypPcNv1CpjpA_1777031715
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8ee1a909037so898024285a.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777031715; x=1777636515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nEN+2szXTqM9oTIsUX5r8HOMqWdfRhmjKH5pfjGEKMA=;
        b=f+R0d0ay+eg/A79YPWlK1xjSF4WlrgneVcVaOCxsSN2x0ONDEmA/CS/cQT7pinJ18b
         C3hRf7AV/H3lKtEU/KddYDwFgI1yYQ0yj5+V+Tp4/WiFUUUw+Tkt2S7plWlfbW7vAX6J
         2K6ngU19w1zaQGjRfVUcCP4Brn7CMlXfxGnKr1NAy+1l3H30Tv13vsJ5ap3LJ7GOL82h
         7VEWXZmpS6SA1ha02BsLAewzMcWugeA6k3sVKEgN9QNOcIg6I26ZQompH0VPZhFy+U71
         Ol+iAxoDhdwacwT94u1dfXb6nOf4ITHJg61lnO37s5tP5ZLsour4HtHj+4q4OYgO5Pfm
         ea5w==
X-Forwarded-Encrypted: i=1; AFNElJ/u1bPAI3HlBXhWSkCWWgCKuwrhTqnKgMf5+tFPTxK+KC1syNpoRzNoruNs/7c2hfAJi0upM/f+6w==@kvack.org
X-Gm-Message-State: AOJu0YxWkuyyLZ9mxm7tDKAYtf/etBGhx0N0ACZtn6UtAEStP0gMc8y2
	76X4sP1gsi3izwJ+iGE1rfxnqjS06VMShBWVRLIYTqceXM4wYhXYL9xQvoL+V5dpuPu5GrfSMoz
	pWZenpMCpavZuYBsPsIBHYu8b7H3kpk7r6xZM1Md2fDnAlKOAPOY8
X-Gm-Gg: AeBDievWOFM1QlajjbOdBSR9vfx70shaP5GUKo5Y10xQugwJs+dQDBtYs0+p5cUjyUW
	CxahiCBum9kWQK37MKiCE88c1UFjV2ig17L7/h3nhdtW7sY5z2FqnjUgrlDhKWLjx1QprgulA7W
	F5wnfs/shkuBrh6lQA9EmhhfvTl4wiax5nifDUFdTubW8rJXQD+Cr73w+88lJb/rjm4+pO1qT0G
	Fo4FkNVurIIV2zw3hK+3rKcHdTxYg3x61jrvysG88kso038aRZsbNhgIyIMQo2P1n+QKPDiGngN
	/KPtdmeEkxVLul7YyfnHwNzWivdBGxcKKwJGH6BsfAngnd0Wh4BaZand704kkF0ToQ5utum9pd+
	Y6+QtCmRhPJjTyETv8Im4a92RV7cvwLFoYB+/U0GkKYZRfL4e1XhdQrgt4Q==
X-Received: by 2002:a05:620a:4513:b0:8da:358a:c482 with SMTP id af79cd13be357-8e78fa1dd02mr4607938685a.12.1777031715110;
        Fri, 24 Apr 2026 04:55:15 -0700 (PDT)
X-Received: by 2002:a05:620a:4513:b0:8da:358a:c482 with SMTP id af79cd13be357-8e78fa1dd02mr4607932485a.12.1777031714498;
        Fri, 24 Apr 2026 04:55:14 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ef12122800sm837694385a.18.2026.04.24.04.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 04:55:14 -0700 (PDT)
Date: Fri, 24 Apr 2026 07:55:11 -0400
From: Peter Xu <peterx@redhat.com>
To: SeongJae Park <sj@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aetaH3W47iR56nQ5@x1.local>
References: <aeprnnccJeyHB2rt@x1.local>
 <20260424002625.89857-1-sj@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260424002625.89857-1-sj@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C7cPOvjSPI4gw1HS-nf0pIR3nlFlV20pw-I5XUE2RnA_1777031715
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CFDEB20005
X-Stat-Signature: 4besuxzdm5upjk78jszajx11oc8nnwkg
X-Rspam-User: 
X-HE-Tag: 1777031717-49558
X-HE-Meta: U2FsdGVkX1+5bmdchJoq4zNIwJAwlCfK42fqXAlDAdRQtgarsBNsYNroIit/orKRkISbctBSYh/dFBFTEHTn1SOP804LMt7CoLwXyf+zVq62BAltnCTna+9/+zCiKDawhTLVZYraA0JnW0WGazvn6rbIqrO2HzjDMnRSvLBKJjKUAdc8MKpDZRhO357rTgDnJX9FaoiAsbMc8zmUZNVaYKAsLrTcTogahLAoNyVtKSF0StOq8Ipw05/JtabZPb+TLDv27SE9XELLUGYvXm5O/x5oLjwDe3siq+/gQtACj6LbHUKauk8FD6cUpip3YhWtZRVJ9Ee7Gz3E5/2aWSVSfcH8aEVBGywITa9UthBMcEg33/IA4mhlreMQSDhUi1Lf2xIlk+BF2VDVf0adyXk3dXNsB4Kve/Ow/xlAjM2HN2kgHTAQjKoaHA/Y7aMvdrxSDftdTSj41/jMSA6qklCsmo0oXTR9wrJFIKa048ymZ6zULgjPeIjl8DP3jV7wTeKAv0xZ2m4ecsT8oZZmrfHmw1uYJaFsD5++hBCB3hhuc06tzR7xZMak9QXl3nSMOwf4e9Q4gTgkjjE2jd/TQBD9CZG8aTxeuBDH9VyE0umKq5+MIrdkcUt+rWj0keRCJi6hY37i69cLvEDaKcTCcfsTS6w+SvKWdbadEOGuSlAQe7wZZGDDYqFRA9x7nFN4r8fkdDW4SaIJasvAXA4iRZF2FawTKxI1S8t7/yqnucYMorKxfMTEWURviiB8dK8N5dODIPVRnCvQvbTQpLULOD+dZGzfGCHhPzGXsW3IvsXiAeRlxwMg8AE4X4SV1zhn/Yx5ENquTx9gcTKcjcjMG+boXuuiomOKXIeuN/fiGvDIG/zrnK+owexny5DFwl30rX97pw1LyAYMS8e95UVZSBiylCRwjb0iAX5mj527CohPqVgT34c2QICLiLRKXQhF20FgTNyiNjjopQjW1aJ0oct
 Zr/f7xQu
 Map2rYPdotcaTT8/+5yK62K7OiyyAmsLfv7nr9kKSynnNdYIYG5LVntvrbpyS8ctsDfdevlN7nXwFw6TN7mZk0pj/J4LqmtULAR9RmdAA9mx9dBhGrhWEvH73xMpzz7/uDZrqDhEQXeDbpwfbYnWW3DjEWES+yqVodDMplLFcZ7KumZTHuJ/FHHEe5tAhSwAflC86KSgzrjeDHOQ7yOesegejy0DkcJ6/Q4AgIpaMgeRX9V0LaZ0cRr/MEiTEe++WgOiOO8bZaCsF2wqtl4URBAgfGjHmTs6EQeu4v1OLMnxjW1Fjq3gujbHEh85YVSJeJXa/6fjOpfh6tnDhHwVifDl/mV9IhAQ0kcqsVvHTQ/QfKcCpu3692IjQ3k+KbVXl+edSAfUTsaqjmpin18yJ63br9RgQQdo5E93couy2MB2fDTyBWwv7RO88PZk1ttPV+TJhH5MudHeyc+etxkgq2m/wt2/EMfNPcL9oZsgMbXNY5OeJfTXnEGTHebWpj67FoYdIQOzuB6jfDyfLteBVDE7BN5VMM27t2FNCB6VwL9wo7UYlS5zP0+mW9ORyjfprKeA4J1eyYUyp8kG7jBY2jpHy1wn1+XVNBgtnXmnqJm+pP6/gMDHDz+RAxvRDr8JfC890O2xb2aaS4gF5YxzKorEj2JO/PFHVutOMR2mQaN15S9LifMMAusrHRLJh4XTDgwxxVVKNaH/hVtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 05:26:24PM -0700, SeongJae Park wrote:
> On Thu, 23 Apr 2026 14:57:34 -0400 Peter Xu <peterx@redhat.com> wrote:
> 
> > On Thu, Apr 23, 2026 at 07:08:00PM +0100, Kiryl Shutsemau wrote:
> > > On Thu, Apr 23, 2026 at 10:50:06AM -0400, Peter Xu wrote:
> [...] 
> > > > - Whether we have explored other approaches on page hotness tracking
> [...]
> > > DAMON is built around sampling. It is good for working set estimation,
> > > but I don't think it is directly useful for eviction decision. It can
> > > miss hot pages. LRU rotation will also loose info.
> > 
> > Exactly.  If we need to collect ACCESS bit (or anything similar) for
> > eviction accuracy pusrpose, IIUC we need per-page info, we can't estimate
> > by sampling.
> 
> That's a fair argument.
> 
> Nonetheless, there are some companies who use DAMON [1] for a similar eviction
> purpose on their products.
> 
> Also, page level accuracy issue was indeed concerns from many people.  DAMON
> therefore provides page level DAMOS filter [2].  The idea is finding a large
> region of cold pages in low overhead first, then do page level access recheck
> on page of the region using the filter, just before doing the eviction.
> 
> DAMON-based memory tiering also uses it [3], to avoid wrongly
> promoting/demoting cold/hot pages in DAMON-claimed hot/cold regions.  The
> evaluation result was not very bad, and a few more users reported positive test
> results.
> 
> Also, DAMON can be used for page level monitoring [5] and open to changes for
> users.  Actually a work [6] for making DAMON-based page level monitoring more
> lightweight is ongoing.

Good to know that, thanks for the info, SJ.  I'll add a note and try to
explore all these at some point.

I recall I read a paper describing damon tracking overheads when
granularity is small and when the memory scope is large (in VM's case, it
can be e.g. 1TB or more).  Would there be quick answer on whether this one
still suffers (or maybe it was never a problem)?

> 
> I understand no one fits all and the decision is up to each user :)
> Nevertheless, I will be happy to help if you have any question or request for
> DAMON.

I'll definitely ask after digging more into that, thanks for the offer!

> 
> [1] https://cdn.amazon.science/ee/a4/41ff11374f2f865e5e24de11bd17/resource-management-in-aurora-serverless.pdf
> [2] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#filters
> [3] https://github.com/damonitor/damo/blob/next/scripts/mem_tier.sh#L40
> [4] https://www.phoronix.com/news/DAMON-Self-Tuned-Memory-Tiering
> [5] https://origin.kernel.org/doc/html/latest/mm/damon/faq.html#can-i-simply-monitor-page-granularity
> [6] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Peter Xu


