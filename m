Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 029BEFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A78A6B0088; Thu, 30 Apr 2026 04:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1581C6B008A; Thu, 30 Apr 2026 04:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06CE06B008C; Thu, 30 Apr 2026 04:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA0236B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:11:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E7D314046E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:11:35 +0000 (UTC)
X-FDA: 84714502950.18.2DDA1F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D146D40010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:11:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mg5u6V7N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777536694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0L3c/BrHkyG8S8bJPfwKFRtTR14oi65Yoyy8+0gP8ws=;
	b=GzHdVHpPPdbAB6EbcpUzyMPM/odADZnT3JDczeVzPI8sXmZrTvtpLo9O0ZOYSoAL2ppfYd
	PbXQEDCJfcrcxzxhTwB1puSqyY7zvVSzx3iU1k+CeuZ2WzBmzbbjaZgryRjQCc+7myho7Q
	gaZzMlLYFrJadPJiFE053SSlpbikZzo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777536694; a=rsa-sha256;
	cv=none;
	b=FFi7UXt0briTGSOxlgYNYjhNkfNgy4hKgEO5qY742q5xf2rBs5h57BBiiPOKY3VeuyHAc0
	zo34pvZNRHuVURx/bpDCbGtUCfciQCJtcBMj0hyMAzRaGwsp6kfc/scJvGnyw1ykkhpLx+
	OQ4t9In6rb9b7w1vakJvVeESnZlYk9M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mg5u6V7N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D8A041971;
	Thu, 30 Apr 2026 08:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5B6C2BCB3;
	Thu, 30 Apr 2026 08:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777536692;
	bh=0L3c/BrHkyG8S8bJPfwKFRtTR14oi65Yoyy8+0gP8ws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mg5u6V7Nibs86GZD4LTWI7jzT8npGZ55hmEykl5zKDL+kfAzROx+pMo0r8fRdTbqR
	 Yn4o/dBQb7SzREy8MW0fgQoQ4d89XUDEq7febU20fNxsfsRbPAZKlWNhQX0w4xP2vZ
	 y5Z5CMy0ZWTjKfcGbOTyM9tVjTe8hGAaCRK2xPppBOFGQzpf/3MUPtR7Bakc4KvDJL
	 Iu8tsBTNn/2T1tLtzjVXzTU+NT8WHRii8oV+2b3ZPJJ0/V5z3g8z8UWRdcxpqZEJvf
	 2p1QsMawzwWSLlToDc+fXm6LPEbTKyZNud59Lo7InHC3Re5JNJ7fYB0jftch+Preby
	 hmL6AjmleqzhA==
Date: Thu, 30 Apr 2026 09:11:26 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
Message-ID: <afMOmZ2FjAPQ_0ug@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <3ce3f304-12bf-4e1f-b85c-11fa5832a0e5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ce3f304-12bf-4e1f-b85c-11fa5832a0e5@intel.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D146D40010
X-Stat-Signature: 4c5htartjndpmrspi6tkkqh8fxf159g9
X-Rspam-User: 
X-HE-Tag: 1777536693-807859
X-HE-Meta: U2FsdGVkX1/6RLfowoBhaN86aqZbT97PAO6fpyg21nkR/7BKlvqBJpaaPf1zoZeTL1rds9Vm/nGDZJCoWgXXsyUv7ypC5W8hDKmtX6fyldsQd6D14afrUJYFrvx8ccE22JQZKoDL/hZ1IC4dUPSNCoPgj2IOvsUdGgIJr35cMxF3+jOqpCqMSQiKoP24w9MqLLuA32AKhqNznn4xlaU09LlQXdsDuRAGEAARoZraMyzIhtQaXh2K/OWS3GYgQ9eTRr0VBwe8PJFzc5I8zUrkVRNKWBKuLwrDAPIS2b71jRWg3wwo0q1B56vmOsZimITJrbD/JioqnjR9pDJzuEhnuK8ubOdO8q0XPh8lo9hwI+lastzwiYEnBWf5CxV7VnW8UNFGF8D6Zte15jcWbSAG4ZhPyUqlWRXpO8m0bimkny6JVJQhPBBue1/+s5l2nMH660rCSFpZSUfia8lf3Gsw0JbVO3DW6zXDMb7cd4oAEY4ymep8b0renZoRAJeoV47FfaHoBc/qQFABKMln/gJJ47wu+k3XcmsoIFKYHUJdxpeIlm4HGwiFFNV6tV9BaJ8Q1N+hnkuBHwOByETx//WHdDD8foTwebXlHoeZRYKBkwzQFkhWXn+5wH9kFWwYCBs2GVvvVC6APwQFnJhDnIbJ/rwN9VfKNKjQ02DRcB4Ir60wDYZrkCD7XNiE6+xVnkJNKL3XqTjmsmuLh90oZE2CO9SNePYZVQJSvbZCbWW3W3DGMz7ZN2y7u0kmNykxUVDokPxfPdw/KpUKV2OibqQfU17LJbagdH4veIcrJ96qhnWcgV0KkTb9vjul8DnPapRMUEY0UN6m66H7RgiEsGi1BIL+3fMl5laTddmC+Sd/OP/1iC9YqU3Z7R5yFoGpRca55O4D14QyznUAp9XJrhU6XDkKD1m9TO7HtqzeoDWu9J+eC6zlSvEt2j7cwCSb4rFchFwXv8yPyQOZKmgMrTk
 yLcGjcsn
 GT2atao/O1mkiFEOfLuUNBxx3cj/zyb1aq/teY2HX+6xVTAu36JJl2YarL5Lsms+jRkNZFEopxZVRGg4Z0qTtJtcjsmr+YV8qsdi4TswsHcf3Ir7X7kOa/03UzEA//RDi1Rzh+KUr0YSCWSKKwGgTYIYznSmVvstUU8RcJGYUoHNl3IKbkOIQupPU88zMUO9xT0bTo320GdcS5GgCYIzLhvOxjDpZ5krWbWfnxmnae4RKwEd5g4FMMW+PO67DwA2+rZlJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:22:28AM -0700, Dave Hansen wrote:
> BTW, this is *ENTIRELY* an [RFC]. It's just not tagged properly.

Was going to say :)

Not going to be able to get to this until after LSF... :) Likely the same for
Suren also.

Cheers, Lorenzo

