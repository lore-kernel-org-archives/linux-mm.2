Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6CAFB44C6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3DC6B008A; Fri, 24 Apr 2026 03:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D3D6B008C; Fri, 24 Apr 2026 03:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D266B0092; Fri, 24 Apr 2026 03:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE5D6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:34:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3076C283E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:34:52 +0000 (UTC)
X-FDA: 84692637624.08.7FE7586
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 083B14000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:34:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJIR4PtA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777016091; a=rsa-sha256;
	cv=none;
	b=UWka4+m+oriHj3rygyee0IQX63iFOLaQ/Ihc6gXd4Iy1rF0lxyJqu9tbhejdBScld1K+/H
	tD8MIE7Ilr+nkOBbX+kob3O4x6PCVc2Fy3qgnV9nd5M3uBUBdRPWToicBzOr1UXNRGR1nH
	LcyXUCrwj5xXNdbTrA+24g5IKhBdrhw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJIR4PtA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777016091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJdObXEbkahQYZLDnmZ+m0VPGz1sbGsEE1rZKCn5pOs=;
	b=Brahjf/4kck3JpcJKdrcF/pP1GmyUNJnSrcFCW79XbuFWbVP6NewqRtXsMp/aY/LpNJWlW
	AJuK9cye15rVKx8eLs1P2bHtogDQ8yUGNqJwBGjxWKzKm2UorWDovrrcO8AKFj7gtqgLFR
	NhW18G+61PCz+iAiIxoLofHUK2OSi58=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 122FF4449D;
	Fri, 24 Apr 2026 07:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5D6C19425;
	Fri, 24 Apr 2026 07:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777016089;
	bh=NGQdePNFp6hyo74+R+XMpXlJRT/ZhqyV2fpxjwJ+zcc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oJIR4PtAGwQD47DsXDZcjQwU406yilrd7N07yZZWCTThqtXZ+E8VMJIMyxVQcIUm/
	 nxI1l2rdPNJYsCBYEl5PhsfAL6UI+U1KwzjOmLV0jGP7VvBb7vP9H7DViktrFZXg0/
	 326lMtT/SxGyrzSPICixgGw6fqKsRZXmeIJokaqS4g8uBHiEg6hCyEjbjDrVLVIEEr
	 dk/HqmnYYuJvk1ePSWInp4PFWW5LYcxbAvyjfrmyZ+YZsfnc3JfiPJFm4X9LvX80q8
	 js8PYKWZZsLmL+TQeeoJEfF+/qG/s5BLOteVgmMsxVY16Virerc4SNo7UaousfS8KQ
	 26QG2mT0/xlTQ==
Message-ID: <6dd8e62b-97e3-4261-92c7-ba3a02ae6397@kernel.org>
Date: Fri, 24 Apr 2026 09:34:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] mm/memory_hotplug: Factor out altmap freeing
 checks
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
 <20260424025547.3806072-8-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424025547.3806072-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 083B14000C
X-Rspamd-Server: rspam12
X-Stat-Signature: hn4z76fhkqgxfdtb49aj9szbw7qyxx8u
X-Rspam-User: 
X-HE-Tag: 1777016090-520819
X-HE-Meta: U2FsdGVkX19R0+BmTWIk/lqXjcUPpR6BIDxuHll5R2/P/xVrYqgHcomQU0g0jJ6piVf4C67LLgWhE4jBPDcLmbyk0CYydSCWlKkUu1uw2f/xw+kxObST537slzzOUrKMpSjjArG6JerXjeMGMJr310nyeWGyvyb9bTM/sTAP4ovTWWJ3P5lJOTF7nMHcJbb3xWyhs6Wu4AUW8xSVfaRc8ONPWfwnzDINH+GnZ1RbIgSVk37e+55wRbiv8CbITgjb3aiE9Pku5vclMIjRMjTdSdHIXoBxDWuw2+IJ/4kJAZCvvz9kH0vlvRyctUSy5jLcWGnpS66+Z5PSDusNbe1uyasxQbrmHp/lKwx6s8s81uBB0EYiqMsJoU1SnMjkvnw4ID97IINTjLd1htxI7ZRMYbChFVeCuDXBUA5mvey/8WtAnikwdmVFUZnaBCr/mT4L+y2SBAaM/JMgVHuviUGCdAPq0v3ioceTFHuR+LOaEbgtrHrkcJ4THZC7OZ1cbbb8fBAoi3yxkER81VY+Y0kEa7vD0won+uNjWN7umwfz3CwRNrIevVk1zWRScIQe8Zkkzd/AOjorxQyn9/xXyvSP8TfSeIG16Nmq85bj6fBRkl+NrnKfFgwAxkPYH9EByZIvlWLXJtz6aypPhBGDitndI9xDXBhq9ar3CdLudGPlwboprqrOS6xmcYIR9NdELHj7XPU7Cafijez/Gv+r8kdv4+yeHe8J3V4WlDGBLTz7fPRFKPlcwY4lVO6Uc3SoYMNgUhxEQd1MB1eCzOC/ytFZ0cTKSM2tJEjVMntUh/mZQAjvpIRHecPrhU+qo59wCaa6GCcGh7Tuk28+1ClTACsLXNuU5dcMOmP4V+ylugUGrNdvuAHQtDdL+axXyJVKFpJZkbOI2iLeYam/bV00fT0GqOGaMsh4SV5nub0QW8MMbsjS8wksFfMPZGw/Q9l/U15vhd+YOz2PWz+LTsBKZce
 6+gngd/m
 yh0bntMI8Zt+OY6TLunhbMeMJuXtBYCk5qedWf3Ggh2SVq7JUjxUe5yxLyN7g0DiJ+8mgBLkcBxKWpoRADdSWDVwChooe9hGYqRp1TLROWyuC/+jgLuphgDOh/AknfEWfBB3js/H5jHVwJy7a0CTNWelqYlj247QfIyGoW3acGj+tDrFapFzmW9pd3Jy48bKRS93wLSNtBBL9wE/W/LkliFYjlPoaQUBjsIGXMaudAHeLRFru+7DY3lX4UY2EdA3d2jFg9oxNZZn3EGRSxrwpVsg8xNFhLiykp4ZHyCFEWZgaMVdziHZ9LQRLj5nU5p2O63C59mc0VRDX9vmBb5CBd7JJzH7z9zztHHp9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:55, Muchun Song wrote:
> Use a small helper to centralize altmap freeing after verifying that all
> vmemmap pages were released. This keeps the check consistent between the
> normal teardown path and the memory hotplug error paths.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Andrew usually prefers sending non-fixes separately, but he can tell us how he
prefers it in this case here.

-- 
Cheers,

David

