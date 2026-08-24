Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471D4C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1830C6B008C; Mon, 24 Aug 2026 16:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133E36B009B; Mon, 24 Aug 2026 16:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0225F6B009D; Mon, 24 Aug 2026 16:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5B846B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:08:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E2444026C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:08:05 +0000 (UTC)
X-FDA: 85137249330.06.6230229
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 54A0414000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:08:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OJMrY9hL;
	spf=pass (imf26.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787602083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkXJaaW+TN+H71o3YvS6+97ZT70d7rkvuIJkAMJWpDs=;
	b=0fMSafjppJHZ7HbBTw4eCC1R9TIu1XNYC5P2hvB1fsm62Tw75zL86k1riBE0EIkO7EzPg9
	+kHZ2sYRE+inu0W8q38L4xVKLufhKLYZUT6Dr+N446v/GCnkxlb8mu1vG4NduPgprOTdAS
	OtFRG920Qw1mz5OI+TSYP8JOBRQHqXA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OJMrY9hL;
	spf=pass (imf26.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787602083;
	b=M3JTBbxqjsXFraERgLf70wzmfDuwJyWYlX1oRBnJNRSA2qit9JDqP4fH9QQFNu8k1AlpjU
	hjjq9RCaxN85YIGb2o1ZPC5aSTKAWNjBZbWfer0F95zDqQsK3J4mOTCwh68PQnW/q/L7EG
	anz+/XAEen9ZDjlx4+kDyRWAMJXp/xs=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d3b440b97aso4125ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787602082; x=1788206882; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BkXJaaW+TN+H71o3YvS6+97ZT70d7rkvuIJkAMJWpDs=;
        b=OJMrY9hLJLJfYyWC2LfzpV4q5lx1KQLrTqxANpV10F7UUz6LIH7mMfcfR/kYc30qTO
         FQQ5OxVAXrCq7/6wnOSpWRt/Z0qLzWtvrJMOt94Wx+3975E7fvfwl1v9xvGywfrlreG9
         3eVX/R4eep9yvKMmG8YvyGbcRTDJAcfdDmY9H/keNTt45lzdHjB3+gkp+i2wkzFv9oxS
         fHV+zx5WOO+Zv80Dff8PjIRGOZPAhJ69s2l/DApLFixjnX79+L06MRItZIjVXEJkT+ty
         22VXwIixx1mcAITI/dS70Wouyofiu7Y71G70ItuidMqZ3I7sIoa+EGxFbeL4iX+ZBxMd
         5DpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787602082; x=1788206882;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BkXJaaW+TN+H71o3YvS6+97ZT70d7rkvuIJkAMJWpDs=;
        b=mb+TlN0PvpQMH3N5AjHBKNR+dFj1FJg1PxM5NopYq4x48WpBHhtQdgQkXypmM3g4Kw
         1Td0UBgsXWOGc6XXJ671syc0nx0n9FuYlcuuaRSsEhEkO0bZAtQX7dF61NbEVTOo5lGz
         KVzeEY6xxaqPeq51gaDCbRcMzME5prens3d9LwaeVaVn0Wn7mSvBkNwT1YqYakNo/Sht
         H7DF5Nxf0k6mCmvm9DhjiX5z1RH3l3vdZT3Ns35lQ8ZOwaM+QUK/H26vjL6voSpr/Ixw
         TTyY9tN5zsXeFgK5+uimYQtlp1fEhnkMtcZ4t4mj5f5vrz9eNwL8hNCEKpv8i8z2JYB+
         djQQ==
X-Forwarded-Encrypted: i=1; AHgh+RpYUOrCGKthRqNnjm90BZDk7KBYGk6AEbrKGKvfjqX9WkN8W//papCLmaP9frLNbX2Q/p/r9x2R+g==@kvack.org
X-Gm-Message-State: AFuF++mudiNxlpVTbmRkh+7ep+o8XUSExAdV1xvIxbiwO+t4Myd+tDte
	Ns//oY6JgUWkGYuEri7ZQTJuDs0vK+e52ymdMnCyIE/SF1S9bzqTIFbLQlRwgt18sg==
X-Gm-Gg: AR+sD13YPdwjSVhIlkBYRsgXrFTbLyotfmvecvNtSI+XgXNH2JyTYmGVLx15GNLV5mS
	U/6wkIZdud6aBUKd5ATdUi0YkpcNIJjSAQ29FBHt7XwJimM/+uWSgaa1klu1tgOei67y8O6pm1J
	S3RVp1qms3iRwBtYpJRH43YZm96Oy5g7wC82X2kqFieFYwivqVj85SgsBkdMqlpKlwREEqKaCdT
	6qhAN2sPTUNCgJMxnzhAQCmFU8oXq0CRcbwfW0KpCxvbwzYzxRLr26OZJWR6jAetc2VpC9NYlN0
	DOIZ+VUVmusz2Qn2neGjh2VffXGHNT/HcUN6MuffdPDtOtgKUv3eD62PvSeqvunITUaRQvctY18
	BKthgAIk5N0J1oSvm82g9nNqMeujeZEDpAXSzMkN86rfnx3V/RRTz91rcp0TSMbPNWZ/IotI/Sj
	oG9BGp47jHkl3NhTscLG2MmWSD+zjXstZNABjCnhRlSoApOg1YA5DoWYQbVpfWJNYQ84VbG/k1X
	5AJkKETbai3SpClNp6xcIijO1TS2aEFJSCLHF2PsXwFqwZY1C4JC+jfo7U=
X-Received: by 2002:a17:903:1a08:b0:2d1:1d3d:97c3 with SMTP id d9443c01a7336-2d6e088aba2mr1093055ad.13.1787602081412;
        Mon, 24 Aug 2026 13:08:01 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39642524ffesm371897a91.2.2026.08.24.13.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 13:08:00 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:07:57 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 10/12] PCI: liveupdate: Freeze preservation status
 during shutdown
Message-ID: <aoykkgPM9UQue2qx@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-11-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-11-dmatlack@google.com>
X-Stat-Signature: seky7yh1y414oc8k6ee3y83d795djwdp
X-Rspamd-Queue-Id: 54A0414000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787602083-886678
X-HE-Meta: U2FsdGVkX1/LwDqbdAaJL3YoNejqq0yQh+jAqnnam3vH/hRyMJzVMX+tiTm60l7/Rg1bu4OIO8aYD56AHwMKC9L5VBeh/NNfsMb+kM35i1AseqgRmcOpg2bf2Ltw/9ze38YO5xGvTQADE/RDicD75w2xku3Zm1R6ra4Sg+gIqfDONcTwvQSICH7EXaru+sEMRF0mI2fnVyigVHdB7wnJZMW9SGzjLBA2+g0c1pso4WZPhKayAVHKbpDC7EdCe6SbGu02bbeRYVxLfSPLmy+koKNr/ARurgc8fdcdStRxbUfEqtz33yJwmHffujPoGc94/8ltyAUSPEx68SkE7OSfkNH6x+WbjkzvIBAoD/P5lDTWwTgLXF85FwhtoJuhp8kRdp+bEOhLDUVa89VT0JAfm9lDQYlP6nNZINqMADkj3LKenrwdiRiDV7plM3BOc78OOLgEsu4VMkX9rgIgWGNIho2XKByz/icf4wRU4OF43QdGwqlXvX0AHv+U9vd95xB0c0pMhSRwVEoP+a8sdpc+bRZaQ3rKHhHd58YfC7i5Yg//m1JzwrASebFY7AHfO5fP7A32/LLRdDaOBlizYOIneKUAhPXBWGwsZDnlxiQqVGmwAbiUlZWx2fWYJcdHp7kfElOxzb0Kt5gPiGBzGt87h7fn3/jzdFP43oFsEaL/IvcXOeBbfOcpI1s4PAlDcjM4smZk10jH8FS/a+tOs9ajVjUR/kzB8qJDSTFqcKqdpW8zjKFgRSTvJiXpxuXZ2G2g9oGGA0z1q5OnDHiY3PQXy1zHLSEH3+nUSsKKd4mopOWEjGxNSbRh3cfUJYVUlv2XaqEK18s3WQbP2Ydd4QUnvdYyyiKM0UsU2UYh8xVM9qIzBW01Q/ElNeeA6pFpeATLLPNpn0h2Pl6enmNjMNqWmsLYLbv0hP1PQ41BMnJ09Pi2QTuEQ57CoHoBtEgGYDZlC091724OV8AtHbxyuEO
 bBaFGEIe
 vVU7ofROaj9xVScAsFfvxQP09+obMuSocOmE42JX0KYkk3HVTnroPAGtMWokZDm9OdxaWErFRubvrtuP+32Iq4/JDHfgwjPJ3jj2tFHWY96tj4i0HIVRHKqe4MZQH/7kjQb8khHRCA2R9GPwg2hosLmx1KS4EO5Jaqmpia5vKdrIZuwx4GKwv/8Pnm0jkJ4VdObWWZfcSBlFlXvaoEbRnza9v5H7DTdZ2OlOtXitPFIIbpwet9JuTG6nNuGLn/oG69e/Nuh9N5+KnhIgXR/j8y2vd0r2ayUYKURuw/aYKgkpZxwUj/Ywdnn/MpVQAai/GcfUmAEiuv/FLQFu0Wky7WAt9GdGND1i4H74yFWUNYjpGelrx7YwyHXHGPeLrq7TzNnfNsls4FUAznvIGNfZx4UM/OfmS3SZn6EvU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:04PM +0000, David Matlack wrote:
>Freeze a device's outgoing preservation status (preserved or not
>preserved) during shutdown. This enables the PCI core and drivers to
>safely make decisions based on the device's preservation status during
>shutdown.
>
>Note that pci_liveupdate_freeze() is triggered by the PCI core rather
>than from drivers participating in Live Update so that all devices can
>have their status frozen (i.e. prevent non-preserved devices from
>getting preserved late).
>
>Reviewed-by: Pranjal Shrivastava <praan@google.com>
>Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/pci/liveupdate.c       | 16 ++++++++++++++++
> drivers/pci/liveupdate.h       |  4 ++++
> drivers/pci/pci-driver.c       |  2 ++
> include/linux/pci_liveupdate.h |  3 +++
> 4 files changed, 25 insertions(+)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

