Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1160CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 18:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154A36B025A; Fri,  8 May 2026 14:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C486B025B; Fri,  8 May 2026 14:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0427E6B025C; Fri,  8 May 2026 14:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9C806B025A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:54:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C5121C0A0B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:54:07 +0000 (UTC)
X-FDA: 84745152534.03.C2A8D2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CADAE180006
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:54:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IMuolbXz;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778266445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZq5Bf4VibazWsRf7IAteM34mEQmtoDSrMgCkmkcCQg=;
	b=2B+Wq0Gm13Ii54Hg+wA7UCkXfLwFa2615AToJ25YjzfLvjH+kBDh6p+Ltflp6Zy5G204XB
	G4dYbdhOBTU2U9iZIUWvz9AdcnYEjLXBookOh0cdoUJKJ0NfEaH5AFkZqbhb1zryYcQBM9
	KQzrGKVyq7X6o0ilryfUl5uwMsFT2zo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IMuolbXz;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778266445; a=rsa-sha256;
	cv=none;
	b=ffpa0yrrCZPSEaAnMjV57bgHUOB+zfsCuqy4HV8HcS+YO1reI+cJEn5xVKKvL2AzPYYumZ
	CBEQVp+NvDYGEQ+7rK2Xt4Cp8ZpCq9mb4J1SGWjN8IZA9j4QsMKVzJN5D9TmH9G4u0nb40
	9L5wGTlGTHMh9Yx8K3b+8spsKeDLhTE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13A5B6057A;
	Fri,  8 May 2026 18:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C4DC2BCB0;
	Fri,  8 May 2026 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778266444;
	bh=u+07b7aUwarNJTFfKewd4gBl4RTENQ6to3G5ZCB7kMU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IMuolbXz4+dg7D5Mak8WRFZ0ksIuPYXXu0O5916t3mbFVA5Hp+lLIu9FjOc5dU5XF
	 F1atK9xvJUlRloUcCy2fNA29eOT85Iu993IzAvVX46tYs40idz1IIs9v4oMHEDcTqt
	 V1AW9vaxpyr5mogAo4cLX472i9TE8UvC1/euYolI=
Date: Fri, 8 May 2026 11:54:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: ziy@nvidia.com, david@kernel.org, willy@infradead.org,
 songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_enabled()
Message-Id: <20260508115403.055ea15a6852bacf864b7ad8@linux-foundation.org>
In-Reply-To: <20260507044938.12529-1-lance.yang@linux.dev>
References: <20260429152924.727124-5-ziy@nvidia.com>
	<20260507044938.12529-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fhngqk36xsojj58tw8zt4hxs13waf846
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CADAE180006
X-Rspam-User: 
X-HE-Tag: 1778266445-18284
X-HE-Meta: U2FsdGVkX1+UiMqpckIoOwhrZpjq4wNesYq6zz7xmMxSETQUENt5shoXxfK7rD5TN0BGv3cLVjyYjgrZ8s2TLryssdIuAc23nZA5Awr2raNHme1CihIxT4O8A/EIHd3sJu7kMaunK+0aUs8UX+nv3ewumIPoRhGhB/XSV1q32GeU6B85imABi1q8pcRUF081+q348dMrZnJKI53qfWjAfamyCtUcnkGms2Zq9xvbrS4sVnpaoRnp5IC0ITUHwB4qKtlMukKpotwyBFfhfPXdXO+OJmtK0ENc86HhTI9wwke8qdxZPE7oxcacVoCtSbRzSi93DELxNUot3pvBPm0OKLnjC/9xqdi/d/qukERMo5nlVYw8jYOWsMAHV/ZdkZFE2VyjQ8AaLd3Yhl7DYWKXIJ3iwx2vj3PTJKFqPAXP7Dh4C57bWVr8gMsl+1duP3fRkStJc/DLIDkiKGZJq2z6VD0p7iNn2lsNP8kZIyrrlCGSAHfdYKPDE5p7jVpWbTLhTGYzdR1s4KLtaoJol9b2XW2ZNZINgxe/QlCpvKSokTS5TXQEgGQXaWpekm7gQI2GIk86NQoXzrgded+TciKg2Mx86Sd3m7GPAvCkv4mis8HLhg4Z504Fvu1H6ZaaiEEH0A0626nBOV9InmrJ+cwWRtcV7ac46Hvm6oTOLsTwicSGedzLa8Fi89bPSrY9UtpBiryjj7/FedcM0mwEWoY01PAzg98JpDo3GeZlIMpdZKFIY2vlVxmDkdLdM+rH+kZ7BfpTlvjhGBSRDvFXsQeFxsibG7mxPpLYaoKPpN7disctIUSuVk/gbeHAkZs4hGlrmxlLp14hxsOb2YoitaCZhVW50qcbXXy36ebBg/+Ty65Hf6VTh7AotCPvaM9FtUinMZbks3CHBhmBO4stDGLukcCmT3NQyrGlOeWi7YR2pz+WVyV8Xj2C9i5NsyyTv1Ilb2FsoZ/xcyz3BqjS17F
 dFqpMKmL
 8mYwbi87N7vLt8BIdMe04rqHGUUVvcdXImmkOKkMMVupIWWhtTac5gMPaZZMhc9TTfvau2RoWV9WvQ7rk0iM5Rd68D1hR5oroW/ubTgHhkRBBzenphT9GAojt0m/vU8KFtUYCl3/RcmICCKG8ROon1IIoNhAQEitWvK7Qu2k8dquPoCuja1tZsJThjVqEdDwPIqG5NiUHwS2qGOH0r1wQWIU/r60KEctra7SuWYz6DzVkSDKWLqmTmQrss+bKfH9Ck09SXhUJ6/8mQCLZjjYLUuYqRVjHXBNAdndGw2N+gcoCDmT0IgwIHTq7AuUgcxdaISdYBxdlnJdEZQV4m1+7uDWoKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  7 May 2026 12:49:38 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> I just noticed that mm-new commit 83f151d1f7e3[1] links to this patch:
> 
> Link: https://lore.kernel.org/20260429152924.727124-5-ziy@nvidia.com
> 
> but the applied commit only has the include/linux/shmem_fs.h hunk ...
> The mm/khugepaged.c hunk seems missing.

Thanks, fixed.

> Was this dropped unintentionally?

Nope.  Collateral damage when I was trying to figure out how to drop
"khugepaged: mTHP support, v16".


