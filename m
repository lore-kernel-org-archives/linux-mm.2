Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD82C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FC66B0092; Wed, 16 Sep 2026 09:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C0B6B0093; Wed, 16 Sep 2026 09:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBED46B0095; Wed, 16 Sep 2026 09:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A88086B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:46:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17B7DA5E91
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:46:03 +0000 (UTC)
X-FDA: 85219749006.02.C9EE8F1
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1DD204000E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:46:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fkfyTRsb;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789566361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gS5Urd2oK4cUSLkPyZ8kKu9K7ELV+4PGRJOBXjNcmpA=;
	b=1csnFKWUKsLrikS6TSKEqj5ZJ32QdibEo+LKm652RHpY3sUb4fN5jTrTofTCdoJw9ZaPLZ
	UtmhuqAaPJDAbEau6GKsGVc0pjw/MoH4u5IehXZHhT8yNnGf399h2G6qmuJk7lOo0xvx99
	bTn/My8l0OjtjMOkjyZYX91gBcbncco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789566361;
	b=RHBW2Ve2xvdJNJS4/ovYvgGypmsl5aYRg3nvZl0nOblssD5CurMcWl5FTR8A0+SbqLtABg
	OXDOBafpXgDTQpEhJd8oGwi7dXSPcL/1ZQXqrCISEnsYUy4fo1FOJTy4ch52RSnzAgVprN
	uDx8s7fsOs1+LZsGsssdQVowBCaJ+ZM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fkfyTRsb;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6056be4d2so795537a12.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789566360; x=1790171160; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gS5Urd2oK4cUSLkPyZ8kKu9K7ELV+4PGRJOBXjNcmpA=;
        b=fkfyTRsb8/xzYi5kf0J9jsAD9jJ0LH9vKzZive9FWF9KcyvbXlm62etoluBWgJL0r6
         JcHUKz+u1prg1SVEOUzleHxjCiq7o3LgfxGT1xhgB6OvxiJLfKwaZvV/u+/9FczWM5xt
         vhZEy7lW05qbXFNcJxiRxMGVcovt3LTHkpckKi8SInn0xGgHB31gmcS+KgvXMSYL1ybp
         ybex3cklyfnbcqpOEEiDeycausRqyStYxf4ZCCzeuEihIxE3nVUqIAR44G8EIdXJgN39
         LZLUd34wVfKmMm/yy4FT0v9srIqA+Z3fAgZzg6imkSkIphaWMkPA7+WvFpcTHqY5NmZ5
         pilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789566360; x=1790171160;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gS5Urd2oK4cUSLkPyZ8kKu9K7ELV+4PGRJOBXjNcmpA=;
        b=ckv4V/p8dMGI3N3gsZj7AAfQxM4JUFO44izCQMPDd8vS/rKTUQsDA2AXrqYIxMkvPq
         Ee9uFKExrZMxU855EpuQM0FyoA/8aLwQrgZrIB5PKBX4fmhvXs//U2AF5b4O3SMu4szm
         z8A2mgG5bRN3aS/VVwUZgm8/urv2PjNZnc9mcoFr+JQwO+YIE8721OnCyqSasn+1Y0W4
         t4u2/PwskNhtqbou2+miA0tMm3/zCPgZIJpkWRmGagw9BwfO/hbU4kLoPbYyRwKyV5Mm
         K/b8W1xNrM2RkPaTks8v/fBUfWQ7RvlQXPRAtf6ZQMHqIwdbfo3D6YfAnLxx+xuXyROy
         FTjg==
X-Forwarded-Encrypted: i=1; AKwUvBwxXn7SFPwQlCUB3R7Kcmsk6FjaL8wCov6iWtI7OHevkvfTOgY6njJ4wkHMQQHzovv7+HJG/Zr+PA==@kvack.org
X-Gm-Message-State: AFuF++nAUxG2adXPM/ptFOdtJWZlDh5MdX6pxOltJBhScmkMtgGJkGgt
	b/zG58NNdUE04B1/kCmsJsmZB3tXg989GgknBc5VPw3mh/3Lmh8hvyumOElN9RQRzU0=
X-Gm-Gg: AYBFou0aU0d4YlIypJUKkQZ46wF3hvtKMUeQrfOdEQ1FZMIXVLCUlDocP/eBfbXhNoB
	TfF1komWyVM9y6o8vXe+DVbvLjA4spRC9MZDSBRZ8YYNT4lBsDKJ85G1Zgkr+j98Z1SLZKBhXDY
	M48Y5In7dD6XdYONhgj21i3ok3eKsWMkmX9W8Qev2aXVl7pODsbcnwwRgUvAZygXgeCLJtplgDR
	2eBnZXt1OpT7I3FVTLM+ZSFX+dAZuonh7YM1/KQ8osfgUijqRC4wHfrXlhRqlFIxOELqp0SguL+
	37pmnYvCgIuTPO5/+70BX+slf9gmZKjYidnk+vB/QjZvIrkb+LUfrHMNkHbgWzSe7PUzaWMa1Li
	2U5rxXa/3oOoAT9OTAtO8bOJicoHuYMEca0wiEqco/QQ0/757vuPoNOJQv4dCGeBNa8hyFnP4Lz
	f28RRDbU9OT1WSj5CVthYZOGLnYNjwlMV6ZVJ82yib9m+XGdveiojjl4duCu3D
X-Received: by 2002:a05:6402:52d9:b0:6a9:9840:f3d with SMTP id 4fb4d7f45d1cf-6aa2288f30amr2016738a12.4.1789566359636;
        Wed, 16 Sep 2026 06:45:59 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa1cfe07e4sm1792644a12.2.2026.09.16.06.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 06:45:59 -0700 (PDT)
Date: Wed, 16 Sep 2026 15:45:58 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
	corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org,
	tony.luck@intel.com, jane.chu@oracle.com, jiaqiyan@google.com,
	Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
	jack@suse.cz, joel.granados@kernel.org, laoar.shao@gmail.com,
	lorenzo.stoakes@oracle.com, mclapinski@google.com,
	nao.horiguchi@gmail.com, osalvador@suse.de,
	rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
	shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aqqdlndHq9vHeX8s@tiehlicka>
References: <aqiIEkrc6aDBOqRg@hpe.com>
 <aqkCbgHmMGxI_GLG@tiehlicka>
 <aqmGd0GGUCkbZpkZ@hpe.com>
 <aqpYxAktjexhaMGc@tiehlicka>
 <ad36cd54-7319-4bb4-bf8f-9fcc7b009158@kernel.org>
 <aqqXbwglwYTyTuUG@tiehlicka>
 <36480c86-fc59-4387-91a4-cad839f502f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36480c86-fc59-4387-91a4-cad839f502f2@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1DD204000E
X-Stat-Signature: oiiwp7jq1emgngafs5ghk8qsztdtfpf4
X-Rspam-User: 
X-HE-Tag: 1789566360-313180
X-HE-Meta: U2FsdGVkX19z//Poa81/H44LPIxpn0aNdR/gPUcaJEDAy+I9QKMhFz1vhloXD98+MDBou+idGH909GCudkCjebdO80uvEOb5pMMeQ/4wX6ESfaF12/KMPnB/UOh+GqhksgiB2WTSHyc4vjfJGi/qRozGQ44bP3HSr1JxvD6xbzkTiwTTMowHJxwR0olOan7YhDSYW4nhMB0sxVLoknRE37ZRdmjCssHyXC0SuKwRn/+vhoZE0CWR/O5jT4ujCSqR+fqXpg1ORy4cvc+vJXuwBikeaVUcrbCdgYVAxxq2iSaC+/gIpOmQkbyNf3llGvs687rTWbxmlaPKSm2g4ryVO9BWBAQ9N3vi8FLvNX/02Piu80kD4oHE1s6ab0qocqjUaxyde98l4+v66i4AdfcLuaYcZouOXwo6FVlYTk9r1lzowmxw+knxGOpGJ1ktzpNLEQ5+rrWRZBa+nJtu5QIlBGJrdMOSrT4GigbZrZiUbgYXzuaXmesoX8S/Ix2AN5zchicNytT2BkzRjY+gXY7W3+i8kAIorv48b49SWS3Rhc1wQt6ggNIivDNlwVTtSdMum5buPU/g/BSazOg+q2l844YYhgEZ0UqP2qzM4LxNLZhYH5R1H2nDP/UTZjbOTa4h3uiAGHbUAgElkVA6n069MVco4q/ZIzFZy29d03uj5L+SADLWW4jnCc+4OJWi+rAbaG/UigKifUg06RD5rVcDjxyay56UThf4uLIYicnfAt2wG+7PlagwjTK6vAZjC8KtlXX1mvMcvz0BXLtUmSSRtb0qriyYFGxj3wW1PF2EYsYg23HQ6SAaahx7LTSEicCaESzYUscmsmOAdLRfh3WQntigO9em+GfMuP5xp/sGcxS8AnacD/uToLMgCEB3+PsPxWIitp8/7MVFIX+koIHDAuEZM5oq9g2BMS447pykiLmHRA6hBlOitJYgxzpqQ8scmL7p/nAI/p/XiDXzpyi
 Yat9iACS
 hfh5Rm1JJ9gq0gWoDFliuETlef2EJOkD3AGvUwygD3EOaFhvv4hUaPNb2V1iP9B3EFJZzzMV6E5ZNMGeeHtFTEtLPqshbYVMb+iZuL09eTjI7TXURtg92a0u9njT7lliVkvZ42Dm95iBnvAIkJEcIsdu5laC9dpFzOCjZoinRR1G90mn8eltXoXWXPN1sNLBZo7VNJFakphLl68cpyQVM1CxU9eXbtQclxpVOTqlaUG/xt3nVUjxj0Q5TOvFQzGep+btxPX5Orqi0KSLBVb6nkxoSARWd2nh0zb09xUQ+wQbZjiit8LFOmm2Uu1IcfWglNd7TrQF9UCElaBnA+gp3WFOeQ2DQAzpJOHbTyqLbHefDdy83Tn+YcnwTWW+T+oJrs3h92+ZNTXkp1G652/CEUa41lbFRbULc1cpxh42wg59ngjN3C0Xgld9eAPoqgFrTnki4LK4A0H0dWQ0Hx0s8yEHDMZ8t9Ajsj/N7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 16-09-26 15:28:01, David Hildenbrand wrote:
> On 9/16/26 15:19, Michal Hocko wrote:
> > On Wed 16-09-26 15:08:45, David Hildenbrand wrote:
> >>
> >>>
> >>> OK, so apparently there are some BIOSes which abuse this feature to
> >>> mimic a real HW poisoning. This doesn't change the overall picture
> >>> though
> >>
> >> Is this really abusing? We know that a page is shaky and will likely go bad in
> >> the future, For now it is still accessible. Trying to migrate off that page stop
> >> using it right away sounds pretty logical to me.
> > 
> > Yes, no dispute on that. But we have HW poisoning for exactly that
> > purpose, no?
> 
> Well, that tells you that the page content is effectively gone and should be
> tried to be recovered / migrated away. Unless I am messing up terminology here.

Maybe it is me messing up the terminology...
But I guess we have established that whether soft offlining is being
abused or not, excluding hugetlb through a configuration is just a wrong
thing to do.
-- 
Michal Hocko
SUSE Labs

