Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60544606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPJBcqX0
Received: by kanga.kvack.org (Postfix)
	id 6FAE26B05B2; Wed,  4 Nov 2026 07:39:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC806B05B3; Wed,  4 Nov 2026 07:39:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB9D6B05B6; Wed,  4 Nov 2026 07:39:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA316B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:39:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7A3A12069E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:39:34 +0000 (UTC)
X-FDA: 85397392668.06.C46B89A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 137E318000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:39:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPJBcqX0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793795973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLdabnqjRGqJbOryxnQw1FnEsduSPSMDms8rKrXUDp4=;
	b=ShujMwsyPkL9UNbiDX2rDEgZ2V/tvYQyh+Wu6a3ghMsRZX+OPmUEzXOlmlYrlEE8r/YU8F
	JcCCkWuqOKxiGlX3k2xmaWZ2Vw5qDNyd4EG2osFcagpBLGL0F5P5vTO0F77+yYArdAgwca
	LJchXudH6pTteO7YkCYThid2TNvyuQo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPJBcqX0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793795973;
	b=zgBIGdd5mb15rIa/lvq5pM0kBxWV0t8sePW6C6QLOQRgt75ByeEIHH0TESoLuix5zflZes
	0bK53DlJUgy5d0GM6UxTymrwUkLB5tsGBgc6jPUjakwBNay71gtjFUZS1yZyz0sP4MwMuP
	FeVKOrpBVG/CGh9+Gkc0nVAOyavej3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42DF5417A1;
	Wed,  4 Nov 2026 12:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFFF1F000C1;
	Wed,  4 Nov 2026 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793795972;
	bh=CLdabnqjRGqJbOryxnQw1FnEsduSPSMDms8rKrXUDp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OPJBcqX0u2MFoxFVrLdBF5bM20IJvoNWvtntKMGm+5yvO9c7V0K1TpDcifno/7GDa
	 ihNTIZFu9qmPvpdCHM/YZmKcgpXNSa+2I9sZftvfo0vdiaDdykmyH1ptvMPDFomWXu
	 I9fB1pedPiycAv+pAlHL1Beut8rHjVN+AOl0Ww0BC7xJN6GrOat3h2U5834DK+jwEK
	 5r7BRw6rlOqfkEJeovbwKN/6d2/d56CxqU6QbX+nDX8g+aZyyVVs7qaDdk4fg86ota
	 GtKgWtkEJAFkzIAYEl02cIkU91jDY2KQE/OClZ6QV+4RfuWlrNRqM5piNbIRBNDUi4
	 E5PVi9sqyW2rg==
Date: Wed, 4 Nov 2026 13:39:25 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/12] mm: hugetlb_vmemmap: make vmemmap optimization
 folio-oriented
Message-ID: <ausnfUK6_CixlDow@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-10-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-10-songmuchun@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 137E318000B
X-Stat-Signature: 3uj9atax8f71cdanpawjeiwsxxtkg5qa
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793795972-957910
X-HE-Meta: U2FsdGVkX1/UanELmm4UWU3tw+0/TlP1U5v7krHIINWjF9NwcXPAMPMMCHHe/P7712rXoHAzX315/rNMTnfSSSxCIGJVq0fRS5o7XsDpisGSpnNnyvOM0sCCdy4Vxh/yQZytFv1RdX44HkrLrGrf3EVDVoTgsmV9v71oJ7xYHh7nYgWiKuCHFQtJGjsL4c4GNmw87rO8Hvz1PAoHYb6R29FXrRfd+wy27FQyz+rj1gmr8PdmUb6Q8+TkaIChbYG8QOUNur+FzKWX/dfKBzYEgjKJAi0B8QjiALmYxjIBeqxDOM9tvopXa9kqg7yKkjRp0r0CIbAj+WAvjp/Rybpwk39WARfjx0bQiXrmTEPNqP0wH7m59PDBc0r0YhckXlWXdJ3Wow3MZI+HBEvCB54BYMtMyZAHw0kEaWZEa0HFgnk5l0h6OYIIryv+qyiJ73ltfEME1fSsEqk0+NxhnAZsBTmKo980+TqwNsFsbM+tZjCaoNuSLlFz5RkBg5myGuGxACaY1GYjKzhgIb6matpyB2WcypPR0BwxsZ59NRiB275CeRupmdqaRioXYnWdET4TU/3pQHBij8N0V7so7LvwiIQ6PuropNopsCPw61391KNbVrsWDvGeby+DVnsXAJnjuLm7ShO1Dwt7qOjIAVITP76xmFnHAJjx7fwCxV2h595LYBZf0Q7GlDbzkYBI5zPdqBuD+nSZrsHrpPvxb1g1KngJEED2b6Q/mCt34bbFBhcsNtJ5BMuj939tljJrqkDaGItMW8mmanz2znxcNf7XzvnOAXgtIRbLkcVfu1wuXEVGdgFm50I6nk3qF041ORCyrdoXgdPggYHMCMLieo6tvH8andYrPoc/up5m6OnR2SlPQpviWon0t6tIPytOEZ2wBHyFTJhRxSTJUkpVmqFs0UOLrSrFh5LBPtnwzjbIrrkZ64qSTsIWoWAvk6s7n4hm0al1/C7PbQaD2rWQsAN
 JV7xxUy6
 BAAE5zA+uBuzDmehAhvDTQ5p2Hx8f9Y8MVCkPydo+StH0VR8hUswTPljRSyPJrd16hE9X5nLHLy5ni+3TjvlDEWkjTSvv6vRbsdTauJqZehy9uAVmyA+EbcXhyaDqnrnjI5CIER6RqfwOFoOWzdRX5NRAq7j2VwyR/OHhgv0WIv9gucTGZ4vn5ISn1tAnv7KQI0JHymQx/t0tDu+c1FkGlPX5rZGd49St1XGS1i6MG037cOCUCJFYnVs1lw2bQojCLpQIYFDPqfUasND9nWvqiLqiG0lZhwP9yMj0srZswMelv8nSnImzy6U4XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:07AM +0800, Muchun Song wrote:
> Vmemmap optimization operates on one folio at a time, but the current
> interface exposes a raw address range and requires the HugeTLB caller to
> prepare part of the operation.  This splits the common mechanism across
> layers and obscures its natural unit of work.
> 
> Make the folio the unit of vmemmap optimization and move the common
> mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
> eligibility and state in the caller while making the remapping code
> applicable to any eligible folio.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

