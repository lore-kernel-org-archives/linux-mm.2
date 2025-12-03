Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0A9D12694
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CAA6B0096; Wed,  3 Dec 2025 04:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903B76B0098; Wed,  3 Dec 2025 04:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8194B6B009D; Wed,  3 Dec 2025 04:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70D856B0096
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:36:13 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16CD7B9D49
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:36:09 +0000 (UTC)
X-FDA: 84177653658.26.279F24E
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4693A1C0010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:36:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OgIYtqSF;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764754567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4Eawf8pIECibSIF57xM1mIfch1nwnHWtQEv9hXhp9Y=;
	b=s1B9gZehePPyls5yXOQjp8Aqmr2c3+IHXde8czfEyXL3sHjZxFETZbbzIHhtJiRwyzE7Cp
	zoTR7nFg5y/hh1Vp5uYAHwG38oh0XFsNeYGBx49+kH3BJ7oaadKZsdOZQt5yYsYHvNPO0K
	j8wSslTaZDOMpt/4YhWwojxGK88SNzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764754567; a=rsa-sha256;
	cv=none;
	b=LlliKB0eqQTJL4iXyy+u2xOmCCPIfiuimqhK3pfP+rjlP4b1RAqAa98l1kY0NqRaRZm+Zt
	fCmzCV0eHOdznnjaMZ/FHcNYe3+fH8bpAyYhDHn52tZ/2Uno+40yYxtyG6Ti2sE2uSTg2F
	orl0nhIMIDZhVZqWipPVyhAiz6Jr0fc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OgIYtqSF;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ed9c19248bso54753171cf.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764754566; x=1765359366; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4Eawf8pIECibSIF57xM1mIfch1nwnHWtQEv9hXhp9Y=;
        b=OgIYtqSFHigt0KSNYWTx1Xm918evdmLt7EMQ+GUF4BYChFrElHIrjZ8RHiZ+I+KGbd
         UlNO5z2ATtFI9AMjLbyzYnDDmaGiRCGOk9NyYSJ/cWPUQz6ELvkD68qj7romz7REgjN7
         h9aXqV3kHbnqvcEfXv1UZfrah05va7lHzUJ7o5ndgO6O3WttX1WPDq2a5mgF079aP1gv
         tKjpdHVvhxe5vrnSHBE0ldbIjr2ZfyOK1LgruSIlZa+1Nw4Oyod9hUh7BhrZ1BooCY1G
         +dUabk4WYIQveYsB96x+gJbCWZ8jJsPESzf18QBQZdO0tIkg7xDlxs0T+g3RtNVd433/
         CF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764754566; x=1765359366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4Eawf8pIECibSIF57xM1mIfch1nwnHWtQEv9hXhp9Y=;
        b=OAuZZoGjw9J7kVq1ifiVK2Kj7jlQkn6m8aeUc6af1fGRrDSz3AICsCtfAWyhReI/OE
         A6kF1sAy0+aAAf4iSguJmYHuA755K00f4kZf9Q3xHoNj2JposyFAwni2FuwFXZQbONfW
         Eq5o4e++/ThAKGPhZ4D4lnNK6vdhbOcZ00mg0dltr2eGpNLNaGtz93YHTYJelasT9YRu
         c75sJphjYYCN2Rgld58eOyJ2HzRC0ShfISMr0adE3NlOJwxGNXCD5MtczgJ0YJN2VgX1
         OM29dXBpkF0XTuxcqz6sUUsrU2cKmjs/X1PZ4Acgmyp+UQOi7R0xtQrn68P7+LjOvxz6
         bktQ==
X-Gm-Message-State: AOJu0YxH5NN0BPWDTYzTDQuYja1bu7BPu97rvC0zhYiT+D6xw/AKKarO
	HHmUaMN2CZ0xEi76rBwBRZBE8kfSMAgt+BOI2mE5diJ3N+emlu01JJSBAHOBx69md81nNFn/i8v
	JeKwT
X-Gm-Gg: ASbGncsCc4oMeysALAR5bvZn84pFfhkr75WBgvAUVFJGh1mx2ZUwNxMpoO2tdyscCkA
	PYduME1eN/VfDK2l/wLsE+AucczD5k9ARZXGv00QNX7S5EeOHa9SsMQlXEnlupAUB3Lw/KBQNbX
	599i+njfGPyAfeN0fSg+YLQYoK2NRslllETYtfWq97nVIRC9NAWxNSZnhQ70YrMP3bWnuCQAWYA
	nDvmgbet4KEgaP/8tLMQmTUfl5JkpePrn3TeNXdLyBlyIUXQKuDt+Pv+CqxWB+zI0fApERIjRwb
	ynMG8yxWDiiZIUYPLWYHt5pVSJniSvdksM/SVKCZAi74rQ6/gJ7/AXqCv++QDqu6juVW5hK+GOA
	n+idcfzVnxWe/SQN/a7Y48iZvEMJD20T0LvwIlNKGhjts9B7Mm8T2sdd3ei3V1qIn5L2yRXjK+z
	UooUpyuMvOBg5ZtU4OR2AfutxnMyL0QeS8f68ZP+sqNp1R/UAw5x637oIcOSUC9NbAlL1nVw==
X-Google-Smtp-Source: AGHT+IEUZ8tfTAa61Ui7bWHEU4nXj+eZu9SvD/PqHUYpG9idGkOBGBL4BIPt6dGLGrl7dJzsYkPBgA==
X-Received: by 2002:ac8:5d8a:0:b0:4ee:228d:d6b8 with SMTP id d75a77b69052e-4f017696d28mr24807741cf.70.1764754566364;
        Wed, 03 Dec 2025 01:36:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd3437a5fsm110792271cf.27.2025.12.03.01.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:36:04 -0800 (PST)
Date: Wed, 3 Dec 2025 04:36:02 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, osalvador@suse.de,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	muchun.song@linux.dev, Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-ID: <aTAEguKBAXN1p7o7@gourry-fedora-PF4VCD3F>
References: <20251203063836.187016-1-gourry@gourry.net>
 <305328e0-3011-409c-a040-76fc478d541a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305328e0-3011-409c-a040-76fc478d541a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4693A1C0010
X-Stat-Signature: pugk81kcdwamgd6r4wz7xfocofgzggiq
X-HE-Tag: 1764754567-315860
X-HE-Meta: U2FsdGVkX18hffvZ4CQd6HhQX1YzDk6kn0qOMGLoo3l4iiKXF5RMtazWE3ZaiihWEKZUwf5+lKgiEaSo44PNyUETvrgTdr+8snio0mBWiNOhVJ+MmgpmkwXPt+QAplteKJU1pZYEbGPRtrjabVr4lJendZjw8RJVqQEOnewA1Y02j03j2WZ0cwpMM8p0NlRYOLOFodUz2i4rvGKGvZQGHc94FTDNleOHRC5WWNcAso5P9+RqVUSra4zze5JgQVOjlvRLhAY/TNdW1oZT4zD5BElxySP2cGiBGf5pBDxFwRSL8UMQI0otWhK1pmOfpijmo+9P4WI/GBHDFULFrOMgzRoYNCy7AZHGaka7KEa7zM216/Yw4saYc/TsuSVFJGwuznZK+CCWaL8LEybQsFOJNnWT4zPPXuJxyjuB6b9FCXtdCBQAqY3xP9bcLalL91hN73vU/5oDj/HggORe1oUiWK2MpsrlNsrTRWVEYSkQEYM7n6R/2FhQR7LhrZ7s4IQwHzFBwlK3WoRzYWDNq1S9XE1DzFyZTEnXl8S3kqAZKLLu7nNsnjf7X/H/eKV4/FbE+V5KhvdcKN4MZJsnUaSL3SADjeFc6ZGs6YWtIDQfqZmjRoVTile6a1VnYeD1n9zBNRgnn58goj2R0s2jxppbGperrTzTwnEaK8gQRcBbCgGiP9pi2i/H0h/ovLI0lMwlRKeYe39ukkc4WTBhO7yHltsJGZ8AtUgSfv79BAmGBGZstsplFlu0ZauWVng18fM9K8D2wSQh34b33LSplZoL1NoZjmhcjId8hiT3KKqvZriIF8b/+loKIvpixm9stnJgI4KXIO+L4vSqUFdST7gUL+ldkVwYNgoNruR8gn91rqGmC+XQo1sxOuo/hnj+4H2pYPPKbuc5MDizctO578oC5AARB3xIcEGmQ0FJdWClouqd65DshnFTrv1PkEzJQCJaDJXf1PLKWQ0B1WU714E
 5EOjIzhm
 bwKkb1etLQMKR58RWBNsi3i4g3ZvNgM4L5WabimYfRWakVvaVwC5Ihes1SpW9X29N11w8VpO6FS2IL8rNbCKNmNQ+lyi7BNmuTcLENiebwVaH6IfW5ntwM5ksp8m+wBNA9mcX+QMC6AHtAUTSO/a67ZwZq662zMZJgw99W8Ex31HjY5SKtXo6dwMfxRNmeKxJ3iGHu0i3JWShLj1p7ffXSM2DKZZq9VF866wwYtVO8tHqS2VIElKa/G4lZTcXMwZn1KEO02WKt4Izlbnj1at+S5k2mzvQm6wGNFLgARqsAQL0fCdwxzq5Ou3I2PxsrGYMOFx2urgnVRt/99UVXfdyUa3ZZWS5/YYMJpulFAv7uwWtRYU+C8ZGClbbUP527dQgVqHK8pEuUwrPHtEiv9Xou13Abc67vJjGEPblST9/QcNqeLuW9EJH05NKDPDpEDpYCLiVM9MteSxsRpCg8Olchsgapg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 10:26:20AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 07:38, Gregory Price wrote:
> > This reintroduces a concept removed by:
> > commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> > 
> > This sysctl provides flexibility between ZONE_MOVABLE use cases:
> > 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> > 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
> > 
> > When ZONE_MOVABLE is used to make huge page allocation more reliable,
> > disallowing gigantic pages memory in this region is pointless.  If
> > hotplug is not a requirement, we can loosen the restrictions to allow
> > 1GB gigantic pages in ZONE_MOVABLE.
> > 
> > Since 1GB can be difficult to migrate / has impacts on compaction /
> > defragmentation, we don't enable this by default. Notably, 1GB pages
> > can only be migrated if another 1GB page is available - so hot-unplug
> > will fail if such a page cannot be found.
> 
> In light of the other discussion: will it fail or will it simplt retry
> forever, until there is a free 1g page?
>
...
> > +- When an admin sets the ``movable_gigantic_pages`` sysctl to true, gigantic
> > +  pages are allowed in ZONE_MOVABLE.  This only allows migratable gigantic
> > +  pages to be allocated; however, if there are no eligible destination gigantic
> > +  pages at offline, the offlining operation will fail.
> 
> Same question here.
> 

Hah, great question. I will make a note to try this in the morning.

> Nothing else jumped at me, in general as discussed, as long as it is opt-in
> behavior
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 
> -- 
> Cheers
> 
> David

