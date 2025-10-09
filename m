Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FC9BCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDC98E001A; Thu,  9 Oct 2025 11:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8574F8E0008; Thu,  9 Oct 2025 11:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746758E001A; Thu,  9 Oct 2025 11:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2068E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:30:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B10F11B0DB
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:30:03 +0000 (UTC)
X-FDA: 83978961486.11.6746324
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 159F61C0014
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:30:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="K9/gKAhv";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760023801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KXAYePP4BLP0oPw4Oo2yec/zLTGELhv7tKRSHRmraM=;
	b=dBiw6d1ejbVtDOUaAFKcUJ7b2cUVi4SyxwoW9t7KMzqeoIqX+lOVIYrIyTU6w54Xg+9/vO
	WPdrw4kRj/wsS6i8JGk61ceMWlkYxVkQo9BC6Ifcq591YbWGze8EECuaduu2OqS5BOL4dA
	b80zvrWWQihT2sPukfp0i0DUQ246BDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760023801; a=rsa-sha256;
	cv=none;
	b=6u1dM9Ez/9lq/hWEFq+lMeE/0VhedGTJR0MLJnCmsK83XHXa00IIN6X3D5cRXDIR2t91TZ
	8M4T/XboNy6I2UdYcyD0Pr7SuvW57m6yiBDgQIYwxZEZIAt0XzVM7V6OuCQxd0uubVLLBX
	sDk0DoCfDBY8TrI/y2HUBPtn2CwjLPQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="K9/gKAhv";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7946137e7a2so12826946d6.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760023800; x=1760628600; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5KXAYePP4BLP0oPw4Oo2yec/zLTGELhv7tKRSHRmraM=;
        b=K9/gKAhv/HxSzZVHuIA32lyXyYD6pZfp6DeppFd47Q08XRWDpyk1j85z2ln5DsU4A0
         4s39ZX/n44HYicZ9WAKzKmTAXZ76yplbG+4OLkFW9D7GaNsaPkGawHZV+n02DMoBJbVF
         E44J9qFRc9S2mxMPvfbl7ngvj09DLiZzPpLydF0i1y7K7tVwiAzlEfhUgAZsdxhgoQmg
         NPruMJnMoB84BBr9Xl8FFUAqaI5lyGm9W5sdU+bVrAXmZ5MzUyLBDSA+H8E2QNCZ9j+z
         87BasWM3f/F8I7W2j3oDV3WhmkGOh0bo694WtXLMo0eQJ0QK8h141L9Q6O4BbJRrjPLS
         q5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760023800; x=1760628600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5KXAYePP4BLP0oPw4Oo2yec/zLTGELhv7tKRSHRmraM=;
        b=s3KsXIbDLCBc2h4HqBWz8fRrQVRxizfn+sUoTijF+bwAoMexrhL4gnrzdue6w8cEqk
         MbWPNhnis0ohVvY4+rlq0JjdtXTxrcCz/V2/0DjBE5jXMvi6y6L9BSZ2lC/bKtcD+LTb
         nEjlx+UJoty48BxlpxAIxD7EwN73sM2MvIDwQO4hBtrcgJJi2lGvXfkxz7ncmouKOc1s
         FnxOfg93twJ6CifuJ4F3YxJEUw21EONO/QJeRtlmycIyyEcMC1fiB8KK7fMazaSRB4fk
         Nb23TkusQEKJVTX4tmtQEPFny7gW6elQd1trGPlGO0vLeSvBd1uQxAihKgYz5o0mWfYT
         ERNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpj5lNd4lGQxg0SC3UxKOFV5gDG3a/smUe8BI8xTWH9fZ1/wf/s0TIKHvZALpgjKgSrJAhMDuSxA==@kvack.org
X-Gm-Message-State: AOJu0YzaA2tKmVZnmDeyhAI1GKSGU10oscqsKroJZ8GDDqABk1dHXy1l
	lk9lk5LD/apvAoeR2ddnN1jGydFUJ6cpgrer2Oyv/3lkgmDkF4W7H00qZBIE0CR2O0A=
X-Gm-Gg: ASbGncshZzfCMAWij3gooydKUeynkid70GHoSR8hB86m/lT7gPxdAVNAPkyZ63y6TKu
	Fhkejk6pgRahlznT4b12GHCd9gAaNQnf/pkDmJBxApJU3EpM/0Wp6xE7iDdQhSbfIug/6gd8oZL
	B7YvHUtMuuWfgPp3U87j1EEX7/1gSjToOGe/g+RCCm1roRUilHUx6DWAKFs2xYghP06njKcKzM1
	mekmJbim16bnZqgWVH2qfGyPGNJ5c0tkw7ueQLIAuVIkZRA28XtN8MVa8gKhqSdPwHO8WBH4jid
	/E5PGa3uax3dehmOeZ+6F9WEFclBhKLtHl/lAFmkrOFB5JUAdVaGu8Wu2vgIYvFcbMzrVet6EqS
	5ROeo3GxGQobYPXHkIPttOdYsIcm4o/AYoFtD5uRuMALMAbL2eHtWnrkqb+B3ly2Hrtu0q9twSf
	dMbIlLZmObgaF3vj9uAmOVk9vDXraDGg==
X-Google-Smtp-Source: AGHT+IFdgTVH9uyu/5o64basHMKsbAG88LBs1aBY1NSyzfZE3IVT45kHm7IlO9M72p9+htOIi0Mntg==
X-Received: by 2002:a05:6214:29cd:b0:772:4853:48 with SMTP id 6a1803df08f44-87b21002ac1mr103016176d6.8.1760023799963;
        Thu, 09 Oct 2025 08:29:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bae60c89sm179458576d6.12.2025.10.09.08.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 08:29:59 -0700 (PDT)
Date: Thu, 9 Oct 2025 11:29:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	corbet@lwn.net, muchun.song@linux.dev, osalvador@suse.de,
	akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com,
	brauner@kernel.org, mclapinski@google.com, joel.granados@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
 <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F>
 <aOdSvriKRoCR5IUs@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOdSvriKRoCR5IUs@tiehlicka>
X-Rspam-User: 
X-Rspamd-Queue-Id: 159F61C0014
X-Rspamd-Server: rspam02
X-Stat-Signature: p531b49ht8ewonrrc5sugpdoqtr9gxfg
X-HE-Tag: 1760023800-573689
X-HE-Meta: U2FsdGVkX19jIpTecmEMG+g9mGhNIOB4rou+8PRP6zoEgy0XoKb2TczJAVZ0ZkBRV7V3Z0VA+wtHzuYPM8p2tz53pJsFl8iISGz12xxZC6jYy5zzJ/s1udm79SBMSq/D24CZc471SehZ/LPAq7nhrTx3/R8GWyA3/jWdfk7OVNeiiZWl+VvKYxJE/UPcdMjfXuLTK8sAhFzCXoDydH+JIOieE4QWzo8ziMqsbACsy92PJk7Ahd0adCSVP7zQmoJELPqDi26DRWpF39OS7dob+u1V4B079NQOHSe0ITWgmprSbnonT0hXGgO/24fJlDFK3wOomRcZvPUZ/tzj8jKcC2W9EJxFMRlh8rN0e+/xKanyFr3BxxRH0+/5l4dumng1R5PCAorSttNKLdbAtvcK64Pdne60kd1ircBzJF7aSDA9/+Uu3RIq4MnJ2Eudu+BmICvIs85sry08d90X5Ars7eI/Bq82aFm8ZF7+iSAcJY4JiSmeOUF04JybN1JcuUaj/fEd7Lq8S/fIz7Qt3/K2N0WxdXBPmlIlb4RuAPqjg6NfKIwqkjZFN775t/x/RjPEbFEsivTQ+ViRt2wqz38CfP+5KrXvFDxsdrV1TlGc5i/CA21PqozkAg5XOv/X4r4xN5Bh+t0KOY6U4k9Tu3eTGXm1I6OC/ZCoPuSZBAbDrEFbEuCGFkdCqpyLLCVeYF8462r8pq1iCD/aMa/3nPFcEaNwGD8DMF3aZ4jJgDvDQCkWGr1LHnfXyZG8eAcunkvJOMzR0U4Y3qQ4S9GSpj7rjznhd2mNmJIGuA6j8VNPZwyeiYObB8fpMlLv9xcDtXyQS3oBnJzugtX4hOH5nOmOfUbK1xAYA+Nr+uzXzoVfLFKdL0dxJ8wwRsGX5d0pawJkKROw1XPJos1eWkbITJbYDy9Oup9Vm3ECZ5+OO7t7A46Ed5WzH6gGeMZYvwZqIqhrKBC4clGl0LJA88kFXHR
 noNWVIp8
 Y3SAJjJ4dSooqOHBh62haGbX9QqLEq1T3XR1pjIRSR2fBG+Y0S0yEm0+GuasgxQB5wh+heSM/wc0BtK0G5Ph9GFvD+FRTHmE5ZSyPO2/8t1CmfN/+xg/Ta8Bz10u+Pcs+NvvuU60bHSD0HcfUoQzkCMjI7RIKJgmzVWwYCITTjmWoyHtpabYvx6WF50G9aVZ6vuEHvd4AU2fFdvb3NXEQcbqzOd2Or0gybjm7n9FrzFpD/0i2oZzWh6CHIXPHob3QwHqGWaR2Q0QWNByM/MI5jJ6qYcsG6zL1wfRc4iyvYyPyN3WjZZzjeqpxAHemDO44O46vQ+j2fIsECMw++TXu6w5FFeVjACbU3HOYOQeBcvQrnaPkNBQepxXXqfH3xp/42TrUtbVjbrUMb7/fPtzfM0l/rZ+kO1ZZ6Gf/q7tdu6mWiXUlJ+9HqoX6GoCLYx8V+/ghxmKkc7KoI3dYC0xOFtCalZR0P97DKdQaNpkWYm40PDw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 08:14:22AM +0200, Michal Hocko wrote:
> On Wed 08-10-25 12:31:22, Gregory Price wrote:
> > > I'm not quite clear yet on the use case, though. If all the user allocations
> > > end up fragmenting the memory, there is also not a lot of benefit to be had
> > > from that zone long term.
> > >
> > 
> > The only real use case i've seen is exactly: 
> >  - Don't want random GFP_KERNEL to land there
> >  - Might want it to be pinnable
> > 
> > I think that covers what you've described above.
> > 
> > But adding an entire zone felt a bit heavy handed.  Allowing gigantic in
> > movable seemed less - immediately - offensive.
> 
> The question is whether we need a full zone for that or we can control
> those allocation constrains on per memory block bases to override
> otherwise default. So it wouldn't be MOVABLE but rather something like
> USER zone.


Mild ignorance here - but I don't think the buddy allocator currently
differentiates chunks of memory based on block membership, it just eats
folios from certain zones/nodes.

I'm scratching my head trying to think of the discrete mechanism to do
this that doesn't inject significantly more complexity into the buddy
allocator.

Looking at the recent[1] THP support for ZONE_DEVICE, I wonder if we end
up with something more along these lines?  But this aschews the other
requirement of wanting the memory to be otherwise general purpose.

https://lore.kernel.org/linux-mm/20251001065707.920170-1-balbirs@nvidia.com/

ZONE_USER does feel like the most natural solution.  Literally just
(ZONE_NORMAL - GFP_KERNEL).  This might need a new GFP flag for certain
use cases like KVM (GFP_USER) to denote certain "This isn't technically
kernel memory, but it needs to be pinnable".  That would slot right
between ZONE_NORMAL and ZONE_MOVABLE.

Alternatively we could go the opposite way and introduce ZONE_KERNEL
below ZONE_NORMAL and disallow GFP_KERNEL from ZONE_NORMAL - then have
strict watermarks on ZONE_KERNEL to ensure the kernel is always able
to get memory. 

~Gregory

