Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F97FFEDA0D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1706B00AB; Tue, 17 Mar 2026 15:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B2D6B00AC; Tue, 17 Mar 2026 15:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5BF86B00AE; Tue, 17 Mar 2026 15:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0DA66B00AB
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:16:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77BB21B70F4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:16:32 +0000 (UTC)
X-FDA: 84556511424.30.DA28B0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A72844000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:16:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAv7URM4;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6f2w4zOAvPwZ4mufE2dybGISwjVaRJpeeOqL0APjjE=;
	b=epuQ2Ns54c+y3M5byMLokZ/exGMfaaRevy/RcQ0r8gaQrsasZqXsMtWrJVwiG774ceC90J
	K+UHIC0J2XT4+9f8ITv9HiQ46y/G16XS3ms/G9fpevDRR2jStJFK/5iLSQXJPJH/JEyAO0
	0PdnkGzRPJP+VDJ7Ph2MN6Iu9CqJWsg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OAv7URM4;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774990; a=rsa-sha256;
	cv=none;
	b=6eoWPo18nXPJBbZll7LPy+P0hPMpVHmVmWNFR3S4C+xPC2Js6wUAwRB45KCD5xu/CkIeGO
	mQ73OOSjsu42YcFi8g/UpZ5+G7S0T8fmTfrI1aA1/eKCIRQ1sUz2HXTvpxlW6PIDWPzodf
	4lGe64eYP9HZumfARB46v0dPYa9fPBk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACB5F43BAB;
	Tue, 17 Mar 2026 19:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF31C2BC9E;
	Tue, 17 Mar 2026 19:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773774989;
	bh=58R4nmzFqZXvVO7rPj6//HNd4IBpuV+RDoFdKrOt564=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OAv7URM4gS6KWb27UemNJmbekO9vk4EqLova3KvwicJypcAJgHj2snI3j/m3cFZ+1
	 5+deLzSDXgFrTErYM0HYxsPmmwZh7cpb7Fke0vFV0kVgKPj9T0wxobDw235Bqmine4
	 7fC5IrFq/OXVpOLFrAYq6Nsz25WDXQfD3sPAsAsM=
Date: Tue, 17 Mar 2026 12:16:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-Id: <20260317121628.abc7f555ec78963b1d705fd9@linux-foundation.org>
In-Reply-To: <20260317181318.2517015-1-youngjun.park@lge.com>
References: <20260317181318.2517015-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A72844000E
X-Stat-Signature: j5omf99a8h534xafcjibo7uwgrpt718k
X-Rspam-User: 
X-HE-Tag: 1773774990-77008
X-HE-Meta: U2FsdGVkX18TXDbj85NDrV+/oRvQ38PP8hpK9KXTbdlJoa7lyjq9eZwJR8HvBrg7LR2Va5DE8HhAVLf1golsJ788VJ5POUc/ZQ4yFqSLz2Rds38cGk3AvojVjeM4E6u7GymFK6FC9RVOvbO+lz0XIKQ84hFzv4yOksTuLQ54zlJqeVrK3lWfm0BLhWB62DcGvzPZwx+iu6tWsv3j92AFXZg8HP3ON7+WSgRiPDS7HUsJCJr5MwxSNHkHPXunGO6UcoRecAmFVagp44H1NILa9orwRWNzbmxhNvt+bPdD7T5isPaoE+8Y4/9JchWa2rFhqFxUaJVUXtnobQn1fUm7eGkgkQoX89ZGw3syud7UDUlAmxHQlojpc1CkPnHdNwnAeX3OALSHceN8zlGa6A3mW7bGLnf1kwqlvbXZFsSfrredTLVrnsZo0soa/qfogafDXFy+dOXJOtJu42BD6XnhFLVClWCzGiWvN1sXizAM/rbOx9XLFB8U7HEYBaI1shwrNsi7dmXd9VvvnbXCQPu+og8Q5U9gB1p3+ls6n2llSPmXatGV3FoSMBtecj5IroB2UfeWEz4Mko0Bd6Sa2DwzvPY1M5bQtZxHQ/48ssslUjq94Dcy79GIxxFQQLtO/DzimJi+o9ucZmOL4A9skUo93oxgbF2DkpAj/eRCqG7RQaH7xUXrkI/ADpZS8paWCz1TlzlShR8dRu8+eSS1HwteJSxMDokU++dTNy9GD7QTmMNsL4aUpOMbu69nGbXhPNPQLpmEVStLbYnC2jR/FcyfqKvztrvwe6r5Pz7aZutd+L6blXXXF4hGQxkmunWUVzi61jLt1WDX6+eRj/947pVLpq1h1cifVCJPjDZpUYmbSp6nR7ampQeDAXAYum/mvOucicUEIwTiDW1WjQc6bAScHCrt+Dgt+cxm+kfQ5cwTDv4qwTYS349Tk5WWGQD7QAZPzaATqxlnzdU5Uw1DAaJ
 f5qUHZw2
 tUnQf1QMQWv40HwRwy7mexS5qAii88isZD0rmOgow1BUwPkRCzEVeXNFMJH9VjWby+VDe4YlDcFbXQJFnWewWm+ydYGx/3SVLADjODKagXWcyJ2hl0cZAELJc20+ekGJZAMdfbXxxqIZQa8gOzUalbYGVtHj+Q5FXSjnvl4w9omD2OfRstM09sVy4lNdHZ/XXlr9x+pfOZGx9wHhhOc6AJBqOL4AjW9HEeayqI75q2k7XYFKsC+AyszDCMGhvCwZ113Jv7juHS8Y5IdOew/MYnzOiow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 03:13:15 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Currently, in the uswsusp path, only the swap type value is retrieved at
> lookup time without holding a reference. If swapoff races after the type
> is acquired, subsequent slot allocations operate on a stale swap device.

Has this race been experienced or at least demonstrated?  Or is this
patchset derived from reading the code?


