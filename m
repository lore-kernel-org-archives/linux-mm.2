Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348071093168
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911F86B008C; Wed, 25 Mar 2026 10:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF496B0095; Wed, 25 Mar 2026 10:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827576B009E; Wed, 25 Mar 2026 10:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73AC86B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:22:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1346DC3022
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:22:35 +0000 (UTC)
X-FDA: 84584801070.11.217ABBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 380351C0003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:22:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP32xDKA;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JOtyBWGrMe46NwzlY+51AxpXQ0OKf+BxcBunhyVoeI=;
	b=cnslV4KHXGfpu5lGWuHvKSuZAR/twhCNmL8UvNKXDqheIMrkMjY6RSkLwenTz9sK+Hr2A2
	afi3Ee0HAz96uUOMWXCGQv39g2H708hpyckoKat8DV5rqTty7cKQIX98F6Aoh8hZo8Pb5P
	vvDZ3CVNSPXFeZ6fXhUC4Ewgu1b06GY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP32xDKA;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448553; a=rsa-sha256;
	cv=none;
	b=GQnFSGGNAsa0BcNZxGjVj0Eh7dYtLGslK6ghEfhZJNajQ2CsxgPsp8BN1BD4MRx2Cl3ucW
	NabB5zrACvHdemxkrIKjAg0JVofmeAV4BXXC8C0fVTFOw+vjOAIlCM6Yr2VOcS9g3TTYI2
	1UBHGKyS5/XPrHXR7P996/xWFlyEqQU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 557BE4406A;
	Wed, 25 Mar 2026 14:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73553C4CEF7;
	Wed, 25 Mar 2026 14:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774448552;
	bh=4JOtyBWGrMe46NwzlY+51AxpXQ0OKf+BxcBunhyVoeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KP32xDKA7inv1kqhDpHGLUKYAj3XLKL+CgtLvcKVfK9hs2kc5CsmSsCnAWHnI8IGW
	 F4CGDVLb2hBtN4uBOYCAcEZ4DtblhEsUAp+/SIgHNjFdYJQ9iGKLwQw0b48YqW3c7q
	 6cjhF+1iDGKvPpS5PMk/yVvdep3kcKJI2DdxJDeJAdZRaqvzC1Xpit7Z9J5c/0PqV9
	 QhnGNXfia2PZ41wfmIcXJd5V9Ij5ei1QWiSBoLTLA3jTixYivR10zklC+HskEHcVhf
	 m8g+y0O6rylGcyVU6wPT+RiI+KwbwMmsIgNt3fSjPhegdoPj2GgkUChVbZudfIGVMb
	 GI1SgiP4dEXkQ==
Date: Wed, 25 Mar 2026 14:22:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <36a9a6c5-a45b-4d8b-ab67-f562b5978243@lucifer.local>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
 <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
X-Rspam-User: 
X-Stat-Signature: m4e1463czd7q3dk3czy4zjhodqeajxf1
X-Rspamd-Queue-Id: 380351C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774448553-647602
X-HE-Meta: U2FsdGVkX19q5E5dJVhUc3oNnsmwd/5ti3Ojslch5Kc+1tq5bghdbtdCHC5qatKSv3H60tyuLoVytXzbJd8de5dH36x1dtG1od9CVW4FwlkJreRfIWPZdChsGJSLn65Sm58hcodWKyGavL/7Ohw9X5FICIfu6WAhrbVQNcLXpOJ6zNhslWYyf8kAo4vlthLFi2SDKm5jnx3Etp4aVM7O96XARyAIffazx5qzmdCtvkDgKqhszc6Z+UfU2xEvEewCrXMyiFW3VWCCVvwlpimSskX/avDendjafH92conf8eKnCEZwA+wPHNh6wb8r62trKAynVq1x0wNKDBvTPhEBZ8i+M+fzdCXQsL5X93qrFB/xnp/dGGMjcescAC6chwDijCzSjKZI4UOhLOYYu/c9AYl2c1zTFnokglYppmfHRcOBZDUhwPrp/b+Kra6iPKQBg/x/SH+lPQyJfKNjgrBMjgev2rOy0PKS7Ca4d1dT3uyAQKn3/LVBlPJigRqlpBHZ2DNY96xsBAuNmCQZDZGW9ir+YyGikIfk3+pVEqvHXQawqmMvIBEt2IHs9QNbfTh9gOvRSOYW6DVHZ4qiAV70P1aVfDnQWNEyXOX1ZxS2yQvkfMUbthgivSrLNVGEpExtEwPv3D+LA4/ArHVplh47mV9EA/lyZTYZIxhADIVfAVlrrmXV6aGl9QUGNlYxpdFPkaDqDnM11Q7Td/XE5/R1tqJbj58jiKgBkNcPWJU4Puw5c9zMhFmMIOcjFwyvAv8/LWMv9cL4im0QsyxjuEYdegiknxRCXLxF8MhfzE8F7GV9XeWZCXMjMHUqrcsxfDCpUqC0sq6hHipKuzcvkjcRcfjfEMN1kL9ZQxz0vsLb8OMNIdUg5J0K12sjraskoq+01hwMivqzC7qI+MbeDcqV5kP+RYIcaYxHn/TM8Im45sPgSzjCIXUF8gPkSSSNE3r4GmT+L4ri2CJNV4bs19b
 KhWYQpsM
 lCdxZkNT2HHITV5jaMKzLtP2SFiBZcUbmuioPottzet8VkjTHzegXL3BjiZN4l1tmw6o5YOsf9dCdzVt3PuV1r8SMzfz66Oz5P/15HvmES8qKunWy5oRUIHBHxw/HRyOooTwiQ9vBDStdm5hJGiI6TXzq8fy2L2OZTLGH2QWNjLRcMDtuH3SS5X2dcsDAWXgbGzBG7+jg4f6WZSasGhbYC5/sgV8MytiLvw0hKgi6juJHrkJlt9Yc1r+emczVNU13xnl5/EXBEIv/ojT3dObSatHDOZSWkWeRFU1h4PZ9+Jxw38CNU73otx5d/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:10:23PM +0000, Lorenzo Stoakes (Oracle) wrote:
>
> I will take a look at this (sorry for delay) but general point - while

OK well on second thoughts this is in mm-stable with 2 weeks to go (I still
have no understanding of how any of the process works) and thus is
immutable, and so I won't be reviewing this then I suppose.

Thanks, Lorenzo

