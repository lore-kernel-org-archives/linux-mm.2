Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D0D0CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22746B034D; Mon,  1 Jun 2026 08:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9B96B034F; Mon,  1 Jun 2026 08:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36856B0350; Mon,  1 Jun 2026 08:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1D486B034D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:04:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A1681A0633
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:04:29 +0000 (UTC)
X-FDA: 84831211458.25.05A99E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 737EF20005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:04:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+xryx3e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LneqXA9Nb2DAyT+pZeNpRlS+JioCTUqhR2a02E8HkbM=;
	b=J33vWhKiDQJGDdU3dsmD/Rxsgw4v9eC96Lid278LP2lm04HmEvdRBcA0xhv0Fbg8cxQgun
	LeVoxwSTw7qi3rY55jvONoFertyz0u+v/6er+FCF/0y1s1he0q991DVLh4YHFVqnxK/0U2
	7QlfJo/HeI2D+4pwK/lmYeFkp2gbDCY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+xryx3e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315467; a=rsa-sha256;
	cv=none;
	b=Qf+QGn+qHXp2IbCtEWWRG5EdwLOTFFB6sURz9zs3ftIl8CeuDwVENPkQNOoKcsLGagGHT3
	d9e/40cA5cm4hgXds1bxcs9mC/tHONODO1Nqaml8k0kIQlbKs2lVjV1F4/yxoG9DT7WN9o
	MkqZG6lzrMh3U3n9lQdHAl9Tb00O03w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AD154382E;
	Mon,  1 Jun 2026 12:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21EC1F00893;
	Mon,  1 Jun 2026 12:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315466;
	bh=LneqXA9Nb2DAyT+pZeNpRlS+JioCTUqhR2a02E8HkbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J+xryx3e7ezIT+RbYrZQ319sDvxwJTXSn8zYdCf81LNo7I2IkMVJ5BOdRd3/UVkBs
	 +waMtdy8DQzEvHvYxXKsM3CD0MGW0zaLmSumR6uMSg9M0zWuxtYconAX8KQXJ1l4FT
	 mxELNd7pskKKuGpIaTdbOEuvwFXWz+vnuNUwctxasPahXANGmkN2WzT+JJCvtFKzT5
	 LLvonQoBFuhJxFkuUMvkBSLP5NmSNHjFD56KfORB5nNdUlVlCUMkK4aoDwVxp4KGCy
	 8HUszY3x20QsZeVpvhGkqd2eAtOioXGRzIhcccsDWCtM5B07sJK4ZaaylksW7oRbNo
	 fqRroUDHGwm0A==
Date: Mon, 1 Jun 2026 15:04:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mm_init: use div64_ul() instead of do_div()
Message-ID: <ah11RCIxMMji_PP-@kernel.org>
References: <20260601121122.94379-2-giorgitchankvetadze1997@gmail.com>
 <ah1puPfob4Ux3BWi@kernel.org>
 <CAE7dp2quHOofO4T9EV9+s2qb5o0jY0yO9L1f1Riu605OOWXbQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE7dp2quHOofO4T9EV9+s2qb5o0jY0yO9L1f1Riu605OOWXbQQ@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 737EF20005
X-Stat-Signature: cwn4bzfibtenx1e5bt6caxt8upw5fuqx
X-Rspam-User: 
X-HE-Tag: 1780315467-264484
X-HE-Meta: U2FsdGVkX1+zvRq8jZiTCYYtqx7jmyrMrBw0kJl+r7NbfCneFS6ZpXqtSQe6MBkKMxfikY8jBomVBCekPEIwswsOUUy1wEuYh+R9viNj/IyVLgd4smaoT4d9gN+wMvAAz6uzb4jl+FLbp0G3GGERbIxIcqn/n8ciT9292VSKC1Bn4CPIthYRVI7BxvF9E4tOr0RTRJVJA6gTtY+IXeP9B+hzP/EgZJPH+RCXNE2E1H0nwwrDlUPqoCZIjySSwLJvjfBxXsSBAQ/b0D3FBTiPbYRvihIL5zc75SnGVV0voJqhKLcw3sCXc/mFRnPyv5wr5aEkaNjsSk2lqAQbxJZUcf6FB0UkPCHkroz0QNt1UFQjr/zgCd4p7l+EwyVY6lPAX9nzy08cb4p2IZJZm5DN/GA1q1Fz1fScvi1Gj86b7wOP946mDewXxCCKIStX5UGzzs6Rfmx1q7THBPhEivjdRnfKhED1bKfabVi4DOu6VharV+XjpEnEwIADhbZ/GRzD0vA1+naOCLVid9J+aCEkY8p1CHro6W7fg+NdX5Sd/IyhXb7KfvMFRXrbHgt0U/HToKBLnEd9GkGTiOLlsW/DSn4uAszS9IgLuS8hV6oB07s0eJxXhjh3+NaEas1vywVZvli5n8Hx/+QL0pU7tDn7jZ8zoIT0sfvVEX/HLNOZCLznAVLuXwKhAMAuktrcl1ZFR+SHhFy8G4+ntv3HyjLEmvxTgzT8qbbqic+txohzce/Rit7JEA+79uICc8w10/n9H+irZHIDyczvTqhWCqee5PRpOfyBrmgJzdZ4Px6r0uk7OnUFHGgGHwk/CSQIqgG3Jh+DnBFRba6BV7Eo3/QZSpjXA5x+ExT+6bNb+XWWs2l9aSyyUBkggGRL2GCqVqiaz4dobkHHM+/QMp0WYEZd7LIi+1eFmSSVTAr08lTXx7TOD8xyhT3eSOwknxvc5FZ4p7vl1L3ky9D9iKPm0oY
 sMqWrVrT
 w9bNI7IVAcC5H4dKVPtaVkf2BmUfQX9DqKlf06W9tyondf2YUjZASBhA8K5Up//GbL6XEkCxk/1oZh8dMAYAuNmezsMmTZY3ZSRqSJe/gjPxt/XQO0zjRUSY4s0dVwNBoMoTXQdJijZyAFNrxdmEdWpM7ZEWNIpemqZlPmy1dbDO6AzwCVWUqyRWMFti/YPQPDMl4TuX6shdyiKVVzQilZQbvmsVSY4qhj9ymSa57A0Xgxdve89s9l/4fva9bW1M9vEwajvDnVeINbFfp9vo+CmtHjWJNIvoWn2oyohP8ZXJgYo0/Kv/L0nFgG0fNqjTRLpYoWDLRJ3+POM6ezzcdYv0cXtQeg/u0UY+3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 07:26:00PM +0400, Giorgi Tchankvetadze wrote:
> On Mon, Jun 1, 2026 at 3:15 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Can you describe what are the actual visible effects?
> >
> 
> Hey Mike.
> The only benefit and effect is a semantic cleanup, it better
> communicates the intent of the division and resolves the Coccinelle
> static analysis warning.

Can you please add something along these lines to the changelog?
 
> --
> Giorgi

-- 
Sincerely yours,
Mike.

