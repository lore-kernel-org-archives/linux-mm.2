Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22675103E16F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507716B01AA; Wed, 18 Mar 2026 08:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8936B01AE; Wed, 18 Mar 2026 08:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CDFC6B01B1; Wed, 18 Mar 2026 08:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BBC76B01AA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:28:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC9B01A06C9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:28:52 +0000 (UTC)
X-FDA: 84559112904.26.86326FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 117871C0007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:28:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cIun73gh;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAEpCFGo40Np+/4E1MzPv7gHDUphsYzuiX0aayCsclQ=;
	b=Ob3k+1P99RIzAOMerJ2YOVRjUPYj8maMakEvNVc9eODq7epmES2QxY9gyPKuh8PKh+kUjn
	9P0f+JyFzk++86GHugGOdlpZIy32FQUvHEo0t6tNjVPvhIwNPoGrQUmQpl0pm7R8jQC3z3
	W4xwIraTP3sNY/+rm6kIErhqBEXf92w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cIun73gh;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773836931; a=rsa-sha256;
	cv=none;
	b=sjwhRPIscnJKHZIPSZGGK8ZWUBLDz43CKJGDfDRT3WEbA+bkH+UVnroKkYuA9tV1R5NnWL
	9h+EvCg5AV8VNokmU+6OhuIki/BcJD77TXY8tRZfA0x4+vP2x5R5rAbrrKNpPA6yt0y621
	0s2dMo0h+4B/MT1aMQfmvsOuKYtmg3w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0914E440B6;
	Wed, 18 Mar 2026 12:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF26C19421;
	Wed, 18 Mar 2026 12:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773836929;
	bh=zAEpCFGo40Np+/4E1MzPv7gHDUphsYzuiX0aayCsclQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIun73gh3acajyRAQTK5HIqsgWjlWiu62CXaUg5kFVRi9+EkcD3TXjyE/yOBOTa2h
	 g3nKh4EXL6bWB5V3ctT4zQdxzNoJOreu1USdvSEAYv6f/xcXU8DkJAfWOfLZ4SZm5e
	 RgM+g6E9EUH9RYJwiStgK17u/Xs2LP0pUYWU/9jXykupvgqwlQEMqTc1hK219FmWr9
	 k83c/gIV+6PyHfUpxakfBkyg5UpC0zRycsCJ9NlZwRCDut5lDyAuIFRE2+tw1pnwaH
	 IXMjCAsuJR2lPjw1m5Rqsrn10G6iJyO/F4FXJDvQPebyxodgKObZFWeAXfbxhDzzwb
	 Em4SAyTihBENQ==
Date: Wed, 18 Mar 2026 12:28:44 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, riel@surriel.com, vbabka@kernel.org, 
	Sasha Levin <sashal@kernel.org>
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Message-ID: <390a3cfa-661d-495e-88ad-eeebf4bc39f7@lucifer.local>
References: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
 <12501051-98d4-479a-8f10-547b2c08ad59@lucifer.local>
 <b4e59cb0-c57c-472e-a70c-10ac450f4a6f@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4e59cb0-c57c-472e-a70c-10ac450f4a6f@lucifer.local>
X-Rspamd-Queue-Id: 117871C0007
X-Stat-Signature: ntk8nyzxjzcqsuu1ewordj16wjxjst8h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773836930-251771
X-HE-Meta: U2FsdGVkX1/nvgT/yUr3X+yz6EEoKqfPbzgkeOsX9R8q+JxNPiT9r9QPcK7qiKkd3CWhX9ah3WUaJyymFiSAL0Iv500y+iZLlbZ96b3hEiYG4EcdeRZ2JXMZJWKWIXxtho4iLZHsi8+W9hRN5CCJ0axmzfho9se1XSmLKhqJ/BO4Nka206A8H7B20FzgXyUEeYig/ixYHYf/tz/5ggXW/wjDRCRTh+jZVxy+55KKbYzjOI7+bD1J9JmZXomtOjt0l/gXOVebeocdOR/tANShMU+gVizc5G8zRaw+mGyWfRp9at70tGKmzEzafz9oZNYSEB8KytYgeFWe1zGggnpETS3B5rySUBFY0Ufmw+zx1917XWs63lFTgSwtEYZz8X/eilTHaPO9+sMafPRw1SiaFEtokxeEtEjkLZXWOTbgIjC74Gi2W0XUBI2kWBU58xGnw8NjB3Y0CNZTKpdA7a9Y8+ywfat5Vha8Y8Te884xzHvBfBjCzbPDz963/I9DDOLDrShCXrN3zsdit/INOuhUDTPYfFJMd55I7BVLyScEerl+nDMP+9wpDLi2ieGonNGty50rGThH5DM7txU5BJpfXsaaqDp2KEjpmN9IPMLQG+NXdh/T3RPFtRPQ+3LOIrOFSLHAjVpCF+PE9nhRDfxD8dJrYR/ZUHEqx47M2rB5732o3cRytN2ko/FGEipUnXOz5Cg99t11m+1GRU9AsAZ9E6SM8RHyMlEuDkkEYsA0aAfrBlDNhOfMz6Jb9n5fSzBDo6qx55J+rHvOIrPFEA7hjAF7Ce9Bh9EInWg2+/TxkR9fERpYz/OyFUYnV2qqYPjwiHncOA0EUXFQ5MDXQ7F0C5zu0eZfPN6uf4v2FkHfNEIvq3ZtZluVPIoP/9s0ak2EacgP5fsQHMm1O165sZgpXF68nSN2iIWDFTh6a2VEqTF/aNpdN/D34QR298/vvB+nssZrH/s25/M49gtPTXP
 /GXkwLBp
 XvDEDNowPkmv4+ooHMw7Exc59AhfyqXSwWgHLDAl/y+5s0FFwT85gRjn3eFnzVjm0zqD12KblVFM/sV4vB/5W6/PUFm8ehVlBlMyMd6KUb/yRdKHSVoBKBSRKYKlh1EYVfJQdeM5XwyfKZ1s+8FSigYj+qrslxZ4Ge03/zuPBpPPk6s2p1i43/uypAOfUVHYVQYu9SllQAijW48XiKNAXSy/AdaEqlCVskdzD8VypzdwFulWZFToa4BFB+yLZEAweWuylylUjCDysph9SxphBntap+XfaK6IIKrefRyUocVEdS4jWEq9secHidZ+EfRot389lZo8v/WNXjrw2hnBk3uqrWYgL/g4ERbe7NiYj4psyJ/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix at
https://lore.kernel.org/linux-mm/20260318122632.63404-1-ljs@kernel.org/

We like to turn things around quick in mm ;)

Could you check to make sure that fixes the issue? If so could you reply to
that email with:

Tested-by: Jiakai Xu <jiakaipeanut@gmail.com>

Thanks, Lorenzo

