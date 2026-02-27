Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF12FD9E2A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 01:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B1A6B0201; Thu, 26 Feb 2026 20:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B83D6B026B; Thu, 26 Feb 2026 20:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD466B026C; Thu, 26 Feb 2026 20:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 541836B0201
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:19:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 018E2B92B9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:19:46 +0000 (UTC)
X-FDA: 84488479614.09.21D4560
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 10771140007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:19:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PwroBQe+;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772155185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUW11Dbq3iA3yiXCGn+Rpmf15VH3xKFqfmeAFrkhss0=;
	b=eS5WoLB2cO4XIrFnqkjQlcW9emwHUzUZrLhY+2JC2RVCID6swK+NzCjVGCbtkjt/nJz8I1
	E2mKHZMbuvLWnxmQs3d1Usx7NA/ErCSYo+JjIFbFw3F0UyOdiyQwSB721tAWy1QUXCz8+9
	ChWQ1+C0CiPkbLwQYEMZfEMt/RpCQ18=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PwroBQe+;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772155185; a=rsa-sha256;
	cv=none;
	b=sSp2Q707SrQSF7hczRC5d/jr1T0QcPdelmYVhS8X4EYYQncWvxm8/10ksjnowPvjQTeM+s
	dq8fJzEsvJKiMpbdfbzj64YeihSUgzE8JmTEFHQMNkSZgK43kk33+nk94wNlyhxAq2Ey98
	kwvuL7sgnVoqr3wvFoandNitbTTctXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772155184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gUW11Dbq3iA3yiXCGn+Rpmf15VH3xKFqfmeAFrkhss0=;
	b=PwroBQe+uqGsWMGwKbvo3dopB1xFBrhkBVrx8vG8WSTz+PoTi+9kPiZmLsRULThUMhXgOh
	Y4ZG1lIkNARbstiDTTTcLPU/kG4Ian/Bq4PU5k5VheVbBtun29jt6bSYNlS1U97d4XZbmH
	n02Ka08Gi1/eshaKpBQEwGu4bcOA66c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-Yz2YZJwaMuSto-SpNxdbEA-1; Thu,
 26 Feb 2026 20:19:38 -0500
X-MC-Unique: Yz2YZJwaMuSto-SpNxdbEA-1
X-Mimecast-MFC-AGG-ID: Yz2YZJwaMuSto-SpNxdbEA_1772155177
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBDDF19560B2;
	Fri, 27 Feb 2026 01:19:36 +0000 (UTC)
Received: from localhost (unknown [10.72.112.89])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F5EA19560B5;
	Fri, 27 Feb 2026 01:19:33 +0000 (UTC)
Date: Fri, 27 Feb 2026 09:19:24 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add myself as reviewer for SWAP
Message-ID: <aaDxHGasv2zGTwIn@MiWiFi-R3L-srv>
References: <20260226010739.3773838-1-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20260226010739.3773838-1-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 9jFtW4U-VdPRfVBdb854JxxMlxa-1kCpywmh4suSzu0_1772155177
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 10771140007
X-Stat-Signature: 8shxtdowgid4ux499498h4ewwhfqn7fx
X-Rspam-User: 
X-HE-Tag: 1772155184-209528
X-HE-Meta: U2FsdGVkX1+xQiowOffnNypp1MU06+HacGy4WYu9Cfq2aGobvrMhEJs2WKC8JeHWqhKoarpD8TEppdFtI833QhOMCm2VW2MRdss66shVajgBP7Nxj23yUNAHf/2rWBBZnXy0tiQIFOdUtoVugoxe0+6k3X0+XHVMQHX64ZET8g7R8gMyKJ20AD6k+Zv0QWSj0kfo3SaWxZIzzTmu6LnjUiDY0XmM//Sn4k+w8P/2lmxVNd6rKPge6qv5tnyNWC1sAhiTz5MMp+0MoTEy7A9Fvp4bADyhORTfO6PX0vFXms8RxCxNXGrCjJ8VKdAx8mCWE3Bw/RHUAf3zYljWyBppSO23m4U683aUInukM//TtV3T5RGigztf51FjiaRZXHw4p4lBQOiLhP4LbEi70DI0x0GDuOOOMCZY3nYCTnU5CLV2pV5Yq+Bu/rR35QWfz/N+kOkhskUg951WL9Kb31TMfjjwLOERoFSVbJysOFIppiwTExX3XHuzYMJgWmBwUkwg/PA5tP6qLqc1xznimxCnt1v9EV1cf2cVj44tNIOOMvO28fb3Rgf4gSgtGwu22U0v1dvcwEIHUXYdzMa3xteDUdg5IgHALo610gbGZzIqozHS1Qb6aE+Png8Wm1r62M74QzAnxIRhLFeqz9kX1Aj/dBAAsPfmcRs6W0EzNb1DioF8KkerPHFbsmQ66YtrqA2eihRdsXMhGVwLFUr4xFF5O0mc6Prr9f+Ig9Y9xBRJIkJkj6ooPmO54z9npmFIGhMvxgRALBauhoHPe485pnoSLouwp71aYWI5zYX0/smhrFBOt3ThTB9dd42gE/0sd0G8KkT/9DgJZgqOykwpJjR0eUgikSMef7Lke1idxYy2+DvOxdu5bwjITnV3qIFIJBS1Ayy5VaqWPwWArQMhlFZfnxIsZQA83odiOym+hE7HnKIzUWy3G20aQMZ9WE1e5uYkbWWq0AkgaLzAZ+F7RBO
 z/h3AFp0
 hY8rnZ3QAQKdH6iaAA+RCO9OSzqxbUKHnjuGTQGX+lFrwreLDcpyXDC24H6mqbA5mmqWrh+t4GVqIMxRB/PPYH8rKfcow/iork7igc9s4qSpAjTJZLz9i5Kbwz/GAIOAL1VsI7lLaKFYaR43tD6cwQ/oAtq1LqYTG5iU4PhrmJoqZirGdAOtfNRsGBZ8KpgypV8yzVhbmU8g3VYgmd8vyMCLJGr8VNiBZhC/UkQY9x9tXOusiyCjiXiZ52k7wpArHvhQ8q5PYdf5jyTTQWLi47IFJ1eQ2GrCl9du58C8JVVhuB7t1/rmIJyg+pm8tgBx8sA/Q1TLtYKecFC0uDEhkRYp0nCzs0OwL8mPwFfoAtG+k4w7FzPAIb+vIBCx0/X5vQ1tMlV4ZM2gj5/QvoyOo26rYgEfkP0D4ALPZ86n6QSwWxVeQsQYw5opqJ+sN+eVltwAssLZk7QRAWWk2vchHWm84/AlLqRBiSlxWZG44p1i/qMYgyTtTLE6INxhbF4q+7wik3wOx0jH3qFlPucsWiPBnlwzC7rTylzpPglp7xFSKTI+Ewq83kd+gZBRgRca9IEJscVPgwBj0kmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/26/26 at 10:07am, Youngjun Park wrote:
> Recently, I have been actively contributing to the swap subsystem through
> works such as swap-tier patches and flash friendly swap proposal. During this
> process, I have consistently reviewed swap table code, some other patches and fixed several
> bugs.
> 
> As I am already CC'd on many patches and maintaining active interest in
> ongoing developments, I would like to officially add myself as a reviewer.
> I am committed to contributing to the kernel community with greater
> responsibility.

Ack these and welcome.

Acked-by: Baoquan He <bhe@redhat.com>

> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4572a36afd2..8fb7b70dfb47 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16913,6 +16913,7 @@ R:	Kemeng Shi <shikemeng@huaweicloud.com>
>  R:	Nhat Pham <nphamcs@gmail.com>
>  R:	Baoquan He <bhe@redhat.com>
>  R:	Barry Song <baohua@kernel.org>
> +R:	Youngjun Park <youngjun.park@lge.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	Documentation/mm/swap-table.rst
> -- 
> 2.34.1
> 


