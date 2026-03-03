Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23ADDEC0463
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E0B6B00C5; Tue,  3 Mar 2026 04:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805326B00C6; Tue,  3 Mar 2026 04:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731EB6B00C7; Tue,  3 Mar 2026 04:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB3A6B00C5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:37:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CB8150449
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:37:39 +0000 (UTC)
X-FDA: 84504249438.25.9A931E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48628C000F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:37:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QfwWX0/a";
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cedbXozPWUY7s8Df24mEVtGVT18inJhg4t5Shp1b5nY=;
	b=ldGjVwroZ4j0UaQRJgqvyxeCCeMbio2fqULSgPNO07czoUG11euzs+RV7gSVL/cFkJJmZX
	U6HQctuWzfSijoHGbfYvty9hfCY2+ROnszBGHzapyrRZq8FvgUsuHKvk9/BSvM50Vgifoi
	uvG7NW4ty5rVSaccKb4Mn6XqIDHRvdI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QfwWX0/a";
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530657; a=rsa-sha256;
	cv=none;
	b=xjoRBWZb0xt4UQwdLqYRmWCRGCVtxyqh82W8M7XLfP2EN7q+cxZlwEcJYwnsTk/EBapWzm
	bK+uuqqaJYPf8p26QSbno3b8BYqweAyf7+pJAIEyHMery+w2bRtiK8dMEGFwE0KHWzyD5L
	KGzYlS2lBaYdmJErFv56NI5M+KNTEOs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F32F4056F;
	Tue,  3 Mar 2026 09:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDDFC19425;
	Tue,  3 Mar 2026 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772530656;
	bh=HWIX1VXWGP5HassDQ1MCakNYhPt303yxu0dwTHvL5BI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QfwWX0/abWuzpZ4Aya1NffXUEnkK9KWGoLslHJu+eBpOgpTbau/lAw3+VKWop/2UA
	 iZTS34s56/mZqD1RrvBlfhj6ZWejOKi5TNXlIsulfiiESX3mLZ45oaC3MipTgyOhDQ
	 3OsDZI/KJmGEY2iNi1GSksPHUHwUXdVMeQbTuxerajttSvcgOVu6WyM5qbg2KqbTnM
	 eOhxzTAIZG/ieJiGyqKtut308v5thEBAbWZJXY6YhN2j8VKsgFZWfniXlBbO1+q5wY
	 lUUobbSZvR6IFZbWHROwfvATggC2tL3mqV7R5rAhQMfwNXtGB3UrpTzufIqpAQWNe+
	 cYtKKePQu4XSQ==
Message-ID: <8d78db89-2f84-48c5-870a-6bb1fc1ddc88@kernel.org>
Date: Tue, 3 Mar 2026 10:37:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: memcontrol: split out __obj_cgroup_charge()
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-4-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302195305.620713-4-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 48628C000F
X-Stat-Signature: pq6745k31dwox9z5e5jkdhskocsiwkcz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772530657-593423
X-HE-Meta: U2FsdGVkX18M1GPnd3tSdqRqDupMI2bmmrotNBWS0FhfMNAeibxDujqRagYZ2/Q6nJBEYBO4gvtFRhxbHM6oCwMAp+2fl9/zLx5GxR4OSAgq7qnvf49EAIT894oOzHvBWBG4fAnnoqJsKaQUH3hQNAkuegCRJ+y598lNR+cxxH6lJKr/XJO+CL6Kl+AX3J6ebhaxcMtgan1RxtF9uNIxwdITPdQOk6+1lbD2I9pHXSuqNNBYFCh2QboSL4vVMMqaJb73D9ciyf4Gs1RNW4k3mCp7XlWLcbjRAcxAUyR9RHQ002TYcD8xh15yaHc1/awytMzhqL8qRibdjSgSwMWOfyGO4u9w2aphKcfrJKcOb7XXvQpqIPBPGJCblLTUss6x+kHxYiCXrMVWTjiUJ1ppauK4esUkFSTxpYZ06QsZ8VwoOahd2Pn2msmFflEvEb0ShjT1JV3SokcOIlSOe+z8RJ0vukRwndpRnAUIhsdWsc4P1NZOhbZNw4j3uU7VGPBPiGIC6j5LGqXASoP1drBxGJ5/3u9QfzhDA3wSRpQM9mCnQRMS9cNa+zXNkQisqViswE9JR+HZGVj4nE154e7jHRgWvvLjsv+fL+565ik9sYySQymrp4zuKP9QdEKLfV0p2qKPffnwTWCZX8Esq1KLQ21nHypG07AVG0O6shhxIiyzTzfcUm591kB3ANNjuQAuuX3agebyJCOADylVSP2uS37MSYGJcuUrtKQviKC/YRgPuvlLNEXIfpKEWBokGq+7UPzqr2v4k/wk3BAXZN8spDlLLfe9MwP721BwUsz5n8ujEURqQADOAHQkRJoqQGM5q4LBrOcvHESVdm5q7PCQxdN2LvJ+bY//MS52LVDfL4GFQFjK+ZtkFX+yu4GlzCQCCdupui46WWEuBsRHMgu84lFca3U4lCbiUqfNNlDiFGqCCzK6AvdlgAuv47Y5gXVMiDJpLHzq6SJJkgAbqZL
 gyf59kb3
 mmz9FSxU0tPqRHmV4/Odg3D9SZEbbGW0EBSE+n3FPDZ4GR4wamtjZhwbZZ3kB5I2AeTeE4AKHsd+46FByyMlqugofbTWWVWT0AApNDvh1P0/FuVTE607rXL6YKL3rlmj0Gq3sAa8Vsd1zuHWllnZW2n+oNNRV2AejkksW0iLRVrKoXSH0B47HiLuNnSwJe6ez7jirGOtpw+byXaPIh1O6PKXeoV61fPz3KuNR5gM27JCksoGhj3pljD6sSTqd4CaYOvZEAcZJKcxDHvck0Zh922y4Ot0eelgd5D2c7Vp1eG3RBYioU6e3ROybuiQlmqno3QsebwZl+8eTtabxd1ZrJQICuHOLyuZeXaNUHjK6Bn5BV3sBPkUaX9Ss3OKSqWXGkW+s5aG5+kWaxIMaay1fOwX05kcP012F5ex/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 20:50, Johannes Weiner wrote:
> Move the page charge and remainder calculation into its own
> function. It will make the slab stat refactor easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


