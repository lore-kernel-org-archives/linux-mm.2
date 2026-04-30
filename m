Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CB4CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0196B008C; Thu, 30 Apr 2026 11:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A2D6B0095; Thu, 30 Apr 2026 11:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBD36B0096; Thu, 30 Apr 2026 11:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 554D66B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:37:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5501D1074C0
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:56:39 +0000 (UTC)
X-FDA: 84715523760.20.38216AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55E8E40010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:56:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q8bQI+Pb;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777560997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FeT/VozefE/tEEI40qcTSVPkYSmRIp72yGvcRaZ2G4=;
	b=pSt7IZ6KTPx/WX3OyUiHrOj2dERvI+7KJuZDHu392eFY5VLp/eI0YBPxAndcx5wqUmTwqZ
	fm5StmPFp5pkvXCYa2j3ttffzneSiwTVtJTA+d7XbZsyNJN6Xns7hcgm+xzbo38E5WWI9S
	ILx8nRHy9fsJnyfW1ddq98XFOiEToT0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q8bQI+Pb;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777560997; a=rsa-sha256;
	cv=none;
	b=KRTd8dOD7x0OxMewlgagpaBi8HQhSnoamaGPe2ENtCcTQU4e19MCvKHUhpybxG6fT7+zOs
	Yfgfnx48hLm2MiKuFJMtO9JbRmz5SPdHTs/O/UQPb8g32UcH3S9jqrGQeotr4VnxywltRV
	sDMbrsVd3UjZCqdez2nIthGcf3M2MJA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D8D6438D8;
	Thu, 30 Apr 2026 14:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3421BC2BCB9;
	Thu, 30 Apr 2026 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777560996;
	bh=MhaXLcaOIUpIS6zO/5Y+oRQiEEf192SsMRoae4gOcu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q8bQI+Pb/x7MEMNOq0iqHVTBFXiTqnZmjatZgDZl/BiW7FO1WC1SnKIgzHgqueZ3P
	 m959rNSxoCR4pieHDgzCE3mhqyzG3FNP3nAdOqXUx81siefAeVFfhGL6mcQN6ObATM
	 EaCzyQgzBGOvCUuLGw9h6eyYcytP2vI+JU5hSbN5acsDjklmaUgnhtaMdBfqWGK45x
	 R1HPTeeW24REt76cAT4F4MO3hTrZRYJa6ZlGy5iRe0iCq96yB2bt29iiHojpidbfLW
	 wJeUdFEKsebFeIb3vIEL9RWudEVs1ImnQOh0tWxrWIcOA6BqauGUzA+j8uhq3lwVxh
	 N1Z++goSMa/Kw==
Date: Thu, 30 Apr 2026 16:56:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
Message-ID: <afNtnXnU4J6syETa@kernel.org>
References: <20260430113512.115938-1-rppt@kernel.org>
 <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
 <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55E8E40010
X-Stat-Signature: dnumg9748uu1ogka3i8tsi7m3mcpprfu
X-HE-Tag: 1777560996-307066
X-HE-Meta: U2FsdGVkX1/uYhueXAzcdVHmp+SlGCQIfcnCZJbk3+NWCI4aEg/yUHLhH9P64zRvCVfPn01IPfCQaX/nN15SZmkgkZCL7fdlf7J1lr3cNU6KhGczVWw0ycqEPS2/15Sm4OQaYyGyNCS2cSZZ7iiV94KocAgR3gn+BVVOAqDfkXDVR4tc6/5q7qPSPgLgaY4VTrs1apzE6dxRU3nkVlLAamggFVBWwI53CYIqg/BXC36EMp7kan0VRp7Jx0ku+obiOMIcu+6EdBbzJYqFAp3nC46AO/KokEJItkNnEFnOpOAWEwuW5LaDf1Dubf5SXS3dXKNHut/gDQHQzf4z5ayCumzqkIYGXpDhCuxa/39ZkTQtBQXQZ4TAgRCUTuLw3baP212BN2Rh1J+XLk951kxsvuQkBybTFeAE4jRohi86B/5UfVI9BI73hQRZCOJ/FE3MySJzgGYaCmi9V5etyYjwr3UkjMEb8a3yQI2LreSkAnF2RSsEd++Zn7nJukYe4BV2hcH9LrD9c9Wa2NqMW592Ut4+GV6iS3Lg6kDSJQeiSoWoYVFvOEFbJelDFqh7FCBWP7Z6S2FdvCQ6pPF7bTjifIm/EJoOtxBeOMB3biUHosQ+1h0caSmsaX5L9Sy1Oh9QQCvBEzCSNSlhsoEVHvpgsDNXuwOmzHIibAjCQ/NgBfKLjPkgJtnYQYaNjXQ+qzu+6Jyc5AwsQ0F65/YLZqNzGVW7nauuXpWDaaQuNQumLkyZrHjYdxs63OkV8roBAgTGkUiAFkwKGJzAb5poz+XL5OBxHlnKZQf6V5FEQFORbGo8g+WBYNg2mHRueGWxS2PQagoxPwcH+IXhEjVmWL7U3g7O03VFHPxVREbImNV1zrIChxBZGAHLGVI+xOjAr0lZlheQQY+aQGuNZZ047g3vXW86G+am5JOlfHnEqLQ5xm4x/Q5pXaPWDISe/Q8PFa7Reyq4pF4qm0K7+55PlJA
 32wj9rJh
 1YV2qA2Bn8iNLoyzdMOFW3XjaMt6D9bgw4qPmsmEUatzrwzj0ZJCRp/T9iQiwjkLn5BGabIdB5bzL7oDaLXq60GRWjOxv69D73fXonxs2m5XioYm+iYWQcdN0H60ZZWmkHPY0ju7ZiOdPsiwokpMyEfwbKigQqmYqkGF9AWSjXsclwdQpc1QQlRfYylO5FbAy+UaiSRxWkUQSd/YBGNATHjaKSj7wJkrPv2jIoeR4p84F/2yrH2NjB6+pGwO7fayOIDb92SU9IbCys7V6X66ah8nZOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 04:23:08PM +0200, David Hildenbrand (Arm) wrote:
> On 4/30/26 13:38, David Hildenbrand (Arm) wrote:
> > On 4/30/26 13:35, Mike Rapoport wrote:
> >> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >>
> >> Hi,
> >>
> >> These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
> >> functions used only inside mm/userfaultfd.c static.
> > 
> > Yeah, makes sense to me!
> > 
> 
> Thinking about this, is it reasonable that the kconfig stuff stays in fs/ ?

But it's in mm already.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

