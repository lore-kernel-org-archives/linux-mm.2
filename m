Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D832606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=X9UIULDA
Received: by kanga.kvack.org (Postfix)
	id 8EE8F6B05B4; Fri, 13 Nov 2026 15:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885086B05B5; Fri, 13 Nov 2026 15:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7743A6B05B6; Fri, 13 Nov 2026 15:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3F56B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:41:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5CA31C3216
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:41:37 +0000 (UTC)
X-FDA: 85431266634.14.FD22445
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC20B40008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:41:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X9UIULDA;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602496;
	b=P1KohWnm6xXjpxzgjBckVy5aP1KDA8qfZROlNT0vF+p477hzXfYsObFcfY/kCaNvUmRB9b
	02JflQb0flU+1EpFYlaP4Viceb5nNgbT3sRn6RK9rbXef8YQAMQwTvLTAMEO8NRVH3T4KQ
	StHSsxyJ3cLwCazBvBB5ZxJOHQUSSNM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X9UIULDA;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Go1UlgX1P4vYTlu1myflgbT685YTRFHTo3Fw25oz0DU=;
	b=QubGa6XgyQd89pMdX7e7MDgJGMEW+cRrA9N368VeqW1WIu5e+jG0b9DQq+SzpAjm7Zh8dy
	kqJB7lpGV9ZSYOYhu5iw1QNtWl6D7EHowQLbnRvasord5hU2cZ5hgMX8W13dzzyiiuB5z5
	K9sHh9TKRWtJkzF+foeMLelx1izHPZ8=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91f23ddf32fso10009206d6.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794602495; x=1795207295; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Go1UlgX1P4vYTlu1myflgbT685YTRFHTo3Fw25oz0DU=;
        b=X9UIULDAVleUz/ncbne+o5FarLK2TTn3AETdSTnBG5pBWlvuwbVoR2Rd0qggw02WTE
         PorFEyKlbouIYEvZxrevcDCNtW95JvEIwf8YcC1iNaqcSUGDCcuvwb184IDt/3wUo7je
         U0GJLNGBt2OTXD/xAK8j2H62FGLXKJLeMYBUE9fv9u2+vH/H931KkZX2b7mBlWa0eDiW
         6YTD9Kr/uwpG6Ft3cGZVAVDBltP/9Rr4dldgqDJqzv9CTcm3KrAnqObNWfFC+2E6Qy7z
         bTS1M1u2hR17oxnTrt649B3/NCWh9oXm30vkQZwPMz9Jw2mrEXUO4h9N1K/6oiyudObL
         VNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794602495; x=1795207295;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Go1UlgX1P4vYTlu1myflgbT685YTRFHTo3Fw25oz0DU=;
        b=jDYon00sRRN7I7bqxFFuE16wXPcgnTZLdffV7aLohA/QDJmDqOZOz54+NPXSoVq/Pw
         FhTKWVfXa7dwRd+7YHKhpyD7wSYkqpzwYazpXqm/IlprQAeI9IdMk1t+NN6XbsAY+EKs
         iepABRG7k19jJqtgz2r61Loo76TocdKAEzcpWBY/BflmPaqTeO0bIWWPDOr+r38Pfezg
         bG0tJ0cQTnrL9eVpAB5tzDbxZjVsszrEWqhNhWrhJaq4txFLewfGLvFysibPd3a3eDYz
         yNv+21oUVz89JUQCfWv3rcGpv6uXM7ci3AIFPhjYV5kg2Sz77FCZLxZCwEAoKhY6CuuC
         HuYg==
X-Forwarded-Encrypted: i=1; AL+hErG5EKeYKv7LoHm+yHUO+YAuV4MY0LqvBnk8d3MgZKi/qsSaCrMgsOAJQKlAjp4WyIe4tBNXylcNVA==@kvack.org
X-Gm-Message-State: APuU4Z9a8bzGvDFzHAW/IuRK9BPK/vBAbF5Aij0iCoR21QWNpcmxiUtb
	CQge6kq7wKt4T3fwE5Fd0aXpskTqELJwthd6tVKFNHBOlg0VNdL+yRNduZXgWXwCQUc=
X-Gm-Gg: AYBFou3L6zgmWlNo14TPmBwKYLskATHoJ1IF8beSK11EJ+omTSM7BCLQrqXbCEnSbe8
	Rcg6B6+55L04115h1SSEQkiewSlUxnhL0Ks4nMTKpj9a8G944piQksD9coLxc6ZvwiTGK4nQRRV
	2kj8yxz44lZK5S4kS7hCkbgx3bez8vcJICB75uNPZ7qSX5vOHnyUfiYPH2YduBPzyS98dDoBbkb
	1IEV79bBu0/0RDTvyFF/pmx61TG5s1mFlPFkAWYkM5WVEz8lehF6hbzkFqAyLBPRc28uzzMFxRP
	CcAbOzNCbBquPzmwTIrHcwHoamw2/VslsWXGr7mBcg9FvZn7RUZ2A9bKDPGsE2On6EvnB1eRE33
	rJGPZWes0hlPT1C9jOknee1qjiWAwYWaJ5GrEPZki8JYoqbtH14E3bGtrULKfvxCwZVis5lbOz7
	rV+7pRoo8Xko9a0Ya7E8TXtrRtDISB3khUZZAdtG1EOfQldioZxz5SlDDB+jq/d+RpAsCZIVku+
	iiYfmbnrJki0Qop0FmDoeN9wfXXzoc8xgrCX+pLkMH47PTqwxQIqPDor/fmNqHoy9lHuYxFrJSX
	/u+lBuoxH/ztL5NI9C//ndp1T+aLYa+ViHQRR86f1kAWL5eIazsizgmg1ZxFQK5P/Xyxj/Xgmmc
	q4fCE284=
X-Received: by 2002:a05:620a:2792:b0:93e:a71a:5de0 with SMTP id af79cd13be357-9494bb894c4mr610417685a.26.1794602494861;
        Fri, 13 Nov 2026 12:41:34 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c5fd154sm262112585a.2.2026.11.13.12.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:41:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org, 
 akpm@linux-foundation.org, david@kernel.org, kas@kernel.org, 
 dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org, 
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
In-Reply-To: <20261113200303.GA395967@nvidia.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
Date: Fri, 13 Nov 2026 15:41:33 -0500
Message-Id: <179460249376.482102.14669935557901467762.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: ush1mdn5zs6czfsq38yfpwkwyum1nqiw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC20B40008
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794602495-334670
X-HE-Meta: U2FsdGVkX18iOI57XQlrKgcZUcq9otBtjEBuo6osorDuQpRs10Od6LjzL1WbAf5EiXT5baCCKoL888PWrSXEpltR9rvhSPhElifYrrBPyNezWq0SF1WHLvh8mRCeGJimzfa/5a9H6tMHTOfBE1oAD3MqBNCpbdszjF84gndg2KUydZ6XjbTeQcV3s3pczbx/l8hTwPDPZacM5mYgll/I+vTqUjMm1O/auP4Ly8wIPw2ieqhrktbDq285qIbHVHW8AkQ2n7VkO+5u146Gaijttt6PXOzvNzzvdmzDqNqpuYqIHiltSVmKeeHXJPdh4E1pjrTgdO7+C6r1AqZz55N2U6jp7ByMPK/MtcIhDhqxvWD125Y5FWTP9J44rWOj4GdorT3TvNKDRpFBCXJFuSK2+Ohp/QwdoptRWsHs2o5pA5bwrDOg6B1fc3JZPu8DESnc60gHh5PcbXpFFIwtxa3b/GtugpSJOQL1x9c4WqWT9weCm9arsS9cZ+RnPRN0Ko7YUrh5rGeWOeLKUC8gQx1mmF49ftV6cCkoJv9Xbv4XBv6x0tNJk1YdJL16OlfRCZXX4MxoAIpvxhVzEqbS86obTVO3STgDaFVULJqPeTDPj+DZi70osYxQESRtSaQvMSzne6mygIm7LiSCYA+TIjWxU7WTeWgZ0Xb5DvIuzg2Tt57o6iPrsYkM/mhNRjcNZyt92aUpv9tHLbxve6q3huNaS4LhrIyKn1Uobxo1bg2kueTPCAafv6S6WIRPLlimhkOIXgz6hjHDXJrKZVlC80xTUTXjcIHGD/df3wC3Co3IFkJmm4XMTDP5tyE5rZKK8sVisNLtb0Qf3ljXxYJit4H8dZ5Z/JQMjDcPDijA2aP/cae5IE97rGE2yIEC0OW4eev86aLs7dtZ7Mp+QRlwahvYgdX7VHnyXGt1njbNLoR9jwYcHwK2g9xeg45/RMRB6xTFaLnR+XPLsbp6BqYCSI3
 qCvuzXKe
 MmASQksJ7PlshS40TB1e5QeZRWvYkdDFBbal88rMXhZTG7326BCjBxn7VWVONtrm3zGDOlkbgerYFL34+os+VjdJ+W3hh7uzXn8L+hlp6zmUzqGdoE6FkthIcmHDyAbq7V05Ja8LxoUGW9WggH+5w6ovgAFs/OubkmGQ0PgE1ibIQyc+wV1zqa3cMyup2hfeMDV2xNrUUMFwEs9DFBWx1WEWSIbb4k6GIppIufFeIESHqWuuCfJW1XI21tjjtHXmCib5emRMKUhagfZbN6kQ+Kzc0uVVArHGhj85SQeTbhqrqhyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 16:03 -0400, Jason Gunthorpe wrote:
> On Fri, Nov 13, 2026 at 02:55:36PM -0500, Gregory Price (Meta) wrote:
> > HMM can grant ordinary device write access to a userspace shadow stack.
> > On x86, pte_write() is true for a shadow-stack PTE, so a populated page
> > can be returned with HMM_PFN_WRITE without taking a CPU write fault.
> 
> I'm not sure I understand this? The pte is writable but you don't want
> only DMA to write to it?
>
> Is there something special on x86 that makes the shadow stack pte
> non-writable by the CPU?
>

Some of the context is here:
https://lore.kernel.org/all/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/

We had a similar issue with migration, but this should handle the DMA
case as well.

It's "technically writable" but the kernel is supposed to prevent that.

I will say my understanding of the larger HMM picture is limited, so
there might be a better way than special-casing it like this.

-- 
~Gregory


