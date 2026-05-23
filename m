Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6963BCD5BB1
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 03:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792846B0092; Fri, 22 May 2026 23:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743456B0095; Fri, 22 May 2026 23:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659046B0096; Fri, 22 May 2026 23:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E63A6B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:28:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE51E407B1
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:28:27 +0000 (UTC)
X-FDA: 84797251854.26.6DAEAD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4799E2000A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:28:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iV3z2ZoI;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779506906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dl1lj1zM8zSyLIZue9KlkWQXWcUhs2vOOJ80ew7upKk=;
	b=ORgLD+7jtdMQ+TSjO3YSGwe6IK7mjc7izL5GDnpYKHoYDflxWAYaW1a3mDLZYsloS6b1Gi
	2ejL46iysKQ67OTxvlnoEX+n4RQs31Ng6ND1PK83GeB0DL/d+Jv/WZ4e3gu5rma/bSJiu3
	hay7LTvvil2BmXDBcCoLj7R8NE9Nd6g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iV3z2ZoI;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779506906; a=rsa-sha256;
	cv=none;
	b=OzLkZ+/OmI5NBJwe94IoYK6jk7jfihLJ7pwFd9gMjKbR2uqMcgyGAREfX6jrBJ3F8iJ4mS
	4ANgLh32cp2125F6cOej/yE3+BZGhXDIFZY0lcJYLlz8j7fp1c8kn1Ua1pzggDZu9mzhQV
	yhK6AcJ1mMdEl1WHm1NjcTs9HrL6go0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC53460103;
	Sat, 23 May 2026 03:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3D71F000E9;
	Sat, 23 May 2026 03:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779506905;
	bh=dl1lj1zM8zSyLIZue9KlkWQXWcUhs2vOOJ80ew7upKk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iV3z2ZoIVEq4tNJ4lQNlD/gGiYPEY4tI6b/m4GNUZAW81ExelnWrR+lijgG98b5E7
	 Kr+KQd4tGHMMpbwn0Gruf2IxQybYJyNiqLgKzH7TeTAiSOhmtE0sgjqC3a4uSskkPg
	 frCdVvBDUxMQ1qQeNT6QPmQOwJqtv+WWyKl0WeS8=
Date: Fri, 22 May 2026 20:28:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
 <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: Re: [PATCH v6 0/6] KSM: performance optimizations for rmap_walk_ksm
Message-Id: <20260522202824.fccba46554fb6223e63d685c@linux-foundation.org>
In-Reply-To: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
References: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a5j69bgeqjjfqt9ojg9wbh811sg3mexa
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4799E2000A
X-Rspam-User: 
X-HE-Tag: 1779506906-784127
X-HE-Meta: U2FsdGVkX1+3SqJ42Q8KhKaisgx69ST+3TDfqVIgO+GHqn4n5aSMxvoYT/Tk8j09aMd1yCOnHFJBWYUMbNQAk4RpJq2HCw5pKu1aBltwU2Hl+6S8dYNeIk3Nyxwz0Ljz2ONknbn2dRofmuGzoX4cgtCEw70KWLcUYmse2OxRFCkm9RNT7egZxuZnhGdHp25flJ57O2PhCLlhLQZsa05PiaQgiZ/j5UymQ2K0aAuel+9Ex2UtHjD+2BZrK0yil/my/deQFIkgBTXPXJZoY6WNil3wCRFccg0CFqoYUh4oVZedVlzp3NgO05ErqctixCNw6QBzVccxvlyzMCJtW2rmWnPPv+/K2QS536FkfqMuZj7WFX8tejJgkFVpRHIoZe90QKWLuGpHJ/chT50VGK+oItkSzOAam+nxvTJ+sp5Ohnv8z/Roptf2zcmUxyyuGkptsHlV4f8rfQlUx7U66N+2nN+hkmmt8U6LCj+dmIZNr8sXuIAtCvZ3sTKUOLylMCvB1MO7SysOdD5A18foEOFQ2DQGnXpCsUNR/33BdmUakG99dIoA9ePOu97lHFjKe34c+zY0mBbI6YBiYvFNweko6L8vlBnwJWQKGthusOGFKRCECLjL05nWarxLx8mN6TYYHoQFX+VvhVb2sj6gyOCouiuefDMRHdlh1EQ3Ty5s5+GuKNys+00a6sYb4kNx8fZTy3Rd+/xBBBK+TYu9TN8n1q4+X/W2ZOSD0AqAc0+h8jeLX86gNFgUITkbRwwL4VLNCBOxbwe/1eTUA2uAJGUwBqGPs3v4mjvkjoIqu92pIcSr7jhl+O+nGGRrQjTKo5n6dE6wUPou7EuHmdxfrhXgtYYXwV2CyK371AEmhgoKlBms4ofcMxRfunlYivBAIJ29i/J+f3RSOj6TYRqyAA05ly21w2XH/xcGBxTGdIwXX3rufFA1C4U3JYS9gj55pCDBIOjSWlkNujCJEWtDxyX
 2JWLqVW6
 3RywByiIRq7t3WyBWjJHFqF6l9uN4qwtVj0acD0LIe7mwSOcknWdXonUo6AsPTeQBVDo11wnewPQHqF4pp9plmHBM3o+/hg0UwQXXrDJk3YUh+t5OuBif6jlnSK6YUXTHa92VHAAzVVQZhMou8Ca2WN/hcaW9w1jyfmVK6oC6Zz0skFsFjxgVjXIpEALYs0N4kzFzDRN8SW1OCQrvS2Xw/g4WJS44BflWPi/hQsMhB87zjlBq56mq8lfarM3PNFgZ4osuUVbRPXglL2D3/icAwk/KtuuIs/sP2xaILK/1MsneKjal6c0Ons6mGBzuMAuhOyaa96yObP6de5rzxRqueQAIpdcEcylDasU4JDVdo3QfmKy9+Ksva2gbFClMlEBZ5eAcKVqkOty2QzkHg4tkIEGeV4T3kzeQv/a1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 10:52:34 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> This series fixes a severe KSM reverse-mapping performance problem
> that can freeze applications for hundreds of milliseconds under
> memory pressure especially when a lot of unrelated VMAs sharing a
> single anon_vma.

Thanks.  I agree that this behaviour is quite obnoxious and getting it
addressed is quite desirable.

So I'd normally merge this in its present unreviewed state in order to
push things along a bit, but the AI review gives me pause:

	https://sashiko.dev/#/patchset/20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn

Can you please take a look, decide what (if any) changes are needed?

