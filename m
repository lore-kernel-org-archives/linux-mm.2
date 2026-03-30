Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD911061B29
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 23:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F0D6B0092; Mon, 30 Mar 2026 19:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926EA6B0095; Mon, 30 Mar 2026 19:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863DF6B0096; Mon, 30 Mar 2026 19:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7441E6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:34:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13A35140A19
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:34:38 +0000 (UTC)
X-FDA: 84604336236.30.26DF075
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 78D0310000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:34:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q0YAvTKn;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774913676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEp1n94DM3BbO5unw18ZDVEFgTIZJBvgH/vhzQ8HuvA=;
	b=bW0cedPRQpKyofPy2okX5OTiw0Fo35+IbwzwaGHPxkJWR/E7/PCrzi0Igj7sjWvXcamTZ5
	gTXqz0F4nSDghwvG1VMGe2NX/aN/uvt7yoMUzl7OhqVhtHFvXo/hKR/ISaXSIaLv0/VmX7
	bblCZD3QenVMXfnwzRFEMUuMXKjiIjc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q0YAvTKn;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774913676; a=rsa-sha256;
	cv=none;
	b=K3M7hhe+2RCX10XRYOgM+V4W8Tc9Sas+t8ykax/Nifz+0LWPLD4DyQPjle6W0LGm9YHDsv
	gNSrkD9DUCDPJeT1q20t9iC/Ukrm5Rsbx5lXIKBMiq/2LYj8NIJ6JuEtfHZjopQEZDNXVC
	cdL6lJqjVcDrUxV55aU6NJjJxZ4/fT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B0FE96013A;
	Mon, 30 Mar 2026 23:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369FEC4CEF7;
	Mon, 30 Mar 2026 23:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774913675;
	bh=rOYFqfKdOMzs6VYlE42XKH2BfXEceu73iEUs4F1Vap0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0YAvTKn5WBKHz+KwKESwmbAcutQnWmbccH7rgz8A7WonyeJY8YyPbzAxOillO9MM
	 GtSxTB0Hhz7wBI4JlJeRRtfZC2+s7iYAOVHDjEnQ4/uGBgsSStN/j8bWOp21nuVbcB
	 kI9s8v2SACens+zjjLcpbmyceHmN4P7x7mhYUTFEew7Q3lKZiufCX+DB4cD0gz4Qxq
	 3I4WTnasME00xo6bp1jckmsp1JdqwdrjU2292mVvkan5V/rdHAGfqF0QLr/dj3Atfy
	 bh7+MUyAZufkS068bcOXTmbe2PzBIP55XIPWttUDUAkmOYTgYB1iE3DXVZNxpqcOy9
	 9m32l7Ru/oEPA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Mon, 30 Mar 2026 16:34:33 -0700
Message-ID: <20260330233433.4208-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330071736.17143-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78D0310000F
X-Stat-Signature: sjcht46m5iz1wg8my9trgoqgeip4h4on
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774913676-758646
X-HE-Meta: U2FsdGVkX18NAH0UGWYCrRL+VzWNI9tG+A173eNKqG2CF+kHKio5lQa/UchjRYcEGkCuJrX85rboxXLyyDO5AJO+Y8hVWSjroJ+yjc8OnqvNai4uoxE9WtTROt0OXQ5aIQ15+FVBw0Nhe8MLcXINz06cw1k7MlivKjHwN/q9EdJ81BeI7c4wT3TfO+cOirew2Gh6zSWJsul5Y+uGSw4Bns5eMr4+QVuiUJSYWu06wSie47ScR/BtWmzz8XAEiRol6DpmPKtDa3RdaPaGKqxRejetyjqPyh4iUemHbC8Jn8m4zI3odYlsmCWELW9aclQ6v26IL0ktG8pXyIBnufvTDXIkivHLHOWCZQo5/nr6s46ZAVXZPfP3PsVNyv5jW/gvbqAjmyHAJZB493oIFTkiMTY6XEvURsDv87YU2bplYzEooxKLR3uVU0JxxCN/0T5rhPcPwn12E04zoYzU2uPlR7DNxvLtwLvUYpWbu1ms5CXLFXuCRUADvlVz/vgduSJBfmFHyaR2ylhzBGcR2f6TiU4EZ3d0EG8hCbWA8NHOp9b282MH0OzpVS7to0vQcD+rC37yqi1oZNRW1fWKNKBdmAWKpei2idIhOy9mrFcfIEBXkuZ/yEfZ64jb6xOh560OpRBrNCFNcPGsSTDse5Ur8Ky3TIMdo7tI4ldsaq9vWibvwyDzKMB+w5snt6+fNKzjcm4t8TrJUegiPihqukvN8hmupfXW2PH8Fu6Tb3sAcRoSxpix5DboT1vXROcaq05iT9sKaZQzEa6g3OhHAlnvx7SZe9a3ToUbK7TM5LNm+4qTg9nS//se80anXBmA+Xv3ZoGeGdbDVN5W/ZxdTr/9LRLyiAzgllx8nQnH1Dtlv/1Q+W34riRWKckfwXa3MXNtanjU5wjUEMHTgo6ISJrcJkhWphSqf8aH5G8QTZGAFrgTkmSqAzUWhKUIR6x/ByaFx7//xoqD3h847KsDCne
 BQwS96Jd
 7OwyB/McNL+Cy/4wMeCBqkZLyAMI3ZlVowH0Brf1hVv81cGLL/L6nQON3QyYkG3GT4QmRhPjSU0z6ioj35v2qgKwCyQLkVS/s/4lkdt4WWXii+ziiolybQp1XwfZy2CE8ga0PJSQ0TOzxwVflpiUw0ZiFI+HP2e5zoyUyJCTclLyfS+KD9wa39WhIG0TicDNKJGv/1DupyUOzxKqIPlJi6efTAEF1r41FeSL3CJZztseG2hY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 15:17:36 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Mon, 30 Mar 2026 14:08:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > [...]
> >
> >     min_region_sz = max(PAGE_SIZE / input_addr_unit, 1);
> >     if (!is_power_of_2(min_region_sz))
> >         return -EINVAL;
> 
> Apologies, I just realized I made a silly typo in the code above.

No worry.

> 
> I used PAGE_SIZE where I should have used DAMON_MIN_REGION_SZ. While
> they happen to share the same value in many cases, DAMON_MIN_REGION_SZ
> is the correct semantic constant for this context.
> 
> The code should be:
>     min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);

Yes, I agree.

> 
> Sorry for the confusion.

Again, no worry!


Thanks,
SJ

[...]

