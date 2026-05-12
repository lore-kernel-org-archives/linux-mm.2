Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9668CCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28B86B0095; Tue, 12 May 2026 09:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E009D6B0096; Tue, 12 May 2026 09:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D164B6B0098; Tue, 12 May 2026 09:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0F5E6B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:59:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B8C81C03AF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:59:56 +0000 (UTC)
X-FDA: 84758926392.23.E33DD34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B68E640007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:59:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jm06ZhB+;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qpwblOJkqvhB5GpK44ihhMjDtdrS/9NYMe6yIPinL0=;
	b=CaT7yZ9AVNpDhbHt8sEVB8IS1SHtLkjQqOv1Z8uYqh3a050j2y+TWd/0KQW4dbsCAdLUUJ
	coVjvyEWq65W3VJ3PV5E6CikmEo+mPHF+Hf10Y6ZG2kVkgcW8Ko8QBBM8Y1xJpp8uuEWd9
	cU94zWR/HTj4YljLw5LaO2/HrU1C7E0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jm06ZhB+;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594394; a=rsa-sha256;
	cv=none;
	b=Jul4JRSJMA2w8JBq0ueTOgBHRc1ENyB7olqXYXqzZl/U3LFOvRo4PD5y4dQYr/sEc2YLZO
	2jWCr4MQKsfvSz7NAe8IDdu0VZD5KTvXT8L1jDWnNTdZzoPVSz49n6c9ncyVxgNwzqUErb
	H/wKWdAQp36GCmBx4WAg/3jA2bGKoGA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F69C62C0A;
	Tue, 12 May 2026 13:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF96C2BCF5;
	Tue, 12 May 2026 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778594393;
	bh=Jvc6GOYinJ6BRNhNH7dRq2Uwx7+Ab05BLqjYU9Eq4Mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jm06ZhB+kVXPOpssK05SbhVCcr/bHIQasVtzKXdp4tJmVXJFgluXT3k0rQPKeu0lK
	 V6LnW74Mb0hVE1hw59XXNTw9F8Ki3JKhmT5jKsLcEh5cMhLsKuOVcS3/auEjTbbtNC
	 iEoWLvGZ5mo9Vfst3394Crz/rC/nTGS82QnQq7xKb8v2Q8sOg6CVIyVLgsYEWDiMi2
	 tFsyWbgfuoLvYyicnCpoRHD/67AMj3BvBwGQj08j/cNQ25rPrKggvAp4vKsgIy8MKV
	 abLqxEq9kFT9KplEXsIpLILm2BVJIADNk1v1zk2NP/suW9hBTU3D379wIs0kHjhaNR
	 Yi5pQt9jN38Kg==
Date: Tue, 12 May 2026 14:59:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Fujunjie <fujunjie1@qq.com>
Cc: Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
Message-ID: <agMyDHx5MxR0igFY@lucifer>
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer>
 <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
 <agH1ZSdX_7QF8P_I@lucifer>
 <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
 <agH7ONBSX7XLzS6q@lucifer>
 <CAG48ez0y3N9uEOzvr4N85Js4XN1fh4JiUFjW=PQB2UZ_5t1R4A@mail.gmail.com>
 <agICeiIEshWf-1xa@lucifer>
 <tencent_B49EC91555E7B93CE646566E0A2DBEB9BE09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B49EC91555E7B93CE646566E0A2DBEB9BE09@qq.com>
X-Stat-Signature: x4x3hzbsfyqwdhfrga5tgtc8ncfxy38a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B68E640007
X-Rspam-User: 
X-HE-Tag: 1778594394-820245
X-HE-Meta: U2FsdGVkX1+mVfbdRKChkuzX7X3583JcBA+NvNl8OiB03tGoi5dbJbliOe28eCRzU0hbxflz7m2Y3C4HYwoxz4OMCoNbbF6+FaS0WGA2XifS5GsUVXXCERgCzkMTmEwPe/kfb2aQAUqIZdqoAVf7alXVRLxLuo/2lfzmcTTRkckzxgoBF7VbFl6ne853QFp1d+0BhET0wP2WCuImTMjEpko2s2UDBjBR28nSPPD1yTV/IbpoP+wKInpzg+KRyGyIULub2+HT9NIoFUcE3CmoKFeSQxsrclSXUMyvVgA29tM78ilqRhYicMX8OH8Logby77KzI9UL8Gu6gk6+fA7zqKQpcISYcTWqaTk7a1bSiakZWwbUkAa8vR9Z0mbGxTqovWHkUt+ed0Ptq5nahLGphaH82HerfiFchVLCHty7BQ+8zRB14ue4zr+R8qbIe3CUfGSqiWx4FgELMnnXf9QJPbT3gvrs/wLO3lU28gr9kldmOBlVkmxLmlCfJBZURY9+sY1FDWmA7ocMIILdlE+TkJZZ9nqFeAOYxHHS29WU7Y9/4aZ2DSLMP7nFYakZiLPZzH7cN7tihiflJ6zBx0WaLUDhuAge1cT38aEepu4hPIbcrC2/93bDROIFHaAJ2vRjv6l4Sbb/1TbKLXqW6R1p5OAYXYlZ6prV7VJeL+hOjyvZBaAPSBGaJmX78mO2SLq931T2bjW2m/GuYn2zUwW4+v+AE/YI0yp4M9b7Xw+L2b72SP1a07vljGAHrDgVbShCHboYQTZoyKngp0pNyz5xzXHILhv6C7UAG8ybGY/APiaxd+mSSrbmN0bgrwXEfEdMnmnRG5Ws1DQRVUQ/Q2RKLalPmVxdHUiPJCwxfBEd68YAbPFlyvuDcwLPV43U1K4GeLG6zUpg20EYCMjtxkQ3fEDTt8oXx/UYiHWJLnvef/loVty9WN3z8KbWaCs84QcKGW4hmOOCzAsUr7e0Xln
 syHkf2Di
 brU4PAC/o3NvePmAKXnB4FdMxCAws1lznckN+qKqA4wjYmmaVtzlwd+jYD56t5eDzm7ywZOY+wyO8Ml06Nlum7ibBt2YveaZtkraFuStC+M5qjk31UBfgnZOJEggfgb/xbzlTCZLbsj/6jDzt79feL0HZlUBctBN6A4nVmoQbU7q0MkKf+cvmQ23DP+mcYh6fVJd4kZscm+0RaOoGTCoko0cQsJMlNqP26bvYOdzixn5kYL1A7p416GAtZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 03:24:24PM +0800, Fujunjie wrote:
>
>
> On 5/12/2026 12:30 AM, Lorenzo Stoakes wrote:
> > Yeah let's go with that then I think :)
>
>
> Thanks Lorenzo and Jann.
>
> I agree that the patch as posted goes in the wrong direction by treating
> source gaps as ranges that should be propagated to the destination.  Please
> drop this patch.
>
> If disallowing source gaps in this multi-VMA move path still sounds right,
> I can look into a v2/new patch that rejects sparse source ranges up front
> instead.

Sorry I really want to think about this a little more + make sure the
semantics are sane, so I'd rather take a look at this myself.

I do really hate to take something away from newer contributors but in this
case things are quite fiddly so I want to make sure everything's correct :)

>
> Thanks,
> fujunjie
>

Thanks, Lorenzo

