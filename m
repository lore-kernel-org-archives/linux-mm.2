Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68FACA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AC66B008A; Mon, 12 Oct 2026 13:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C486B0095; Mon, 12 Oct 2026 13:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61F06B0096; Mon, 12 Oct 2026 13:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 850E36B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:54:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12E151612E4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:54:36 +0000 (UTC)
X-FDA: 85314724152.24.AC8B119
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 978C480008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:54:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSoU5XdG;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791827674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=rMujrI8lLZx0jPDkA1pBj0BokSSZ+ugGW7v9I8KU66w=;
	b=J+2AiVGW8F6TpH1Vq7MJ2qASkqH6s1LAWZO1VVVBYl+UgQtFENr0aUzjsITCYdEyHLW9un
	6Hy6II6/HWUeyuao3V03sE0oLk3rvakYIPfLjZLt9xbgKy6F6ZqV9xs1OpwTBYCtftKPGu
	/e7weCpl+1eRP4I1YeG8ZaNuMOYmZ+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSoU5XdG;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791827674;
	b=8GnMcAXPKw482m+JEysyICjL9iPdYMPzBFNmiXamE6ebdiIoA5G9hRkNTbbnIcB76iFVag
	RZMAlD0KvMAFf6Drg5R/RIIZSYKULCdY+hBueX4o4U2m4a09wfjxnCwUGy/PpBOej4Rju0
	fIRQpfEsegj/Cp6N0P99TJy4zuSHaHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE0E443DC9;
	Mon, 12 Oct 2026 17:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AAB1F0089B;
	Mon, 12 Oct 2026 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827673;
	bh=rMujrI8lLZx0jPDkA1pBj0BokSSZ+ugGW7v9I8KU66w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dSoU5XdGQY98S3RM2/HXphQ1TvIguDoI97weXubRnk/Zf59ejp9oLaY0RnM8O9mQL
	 psORs/zvOzsOGvllgOAIrd4TXwsGatD0hrmT+8a0F3C2QlGQUcZmAo30uyl2MATc4E
	 TPiUbmQ+og0ZyBM8x5dcuK6U8bJ85HwzSD6C+z0QNj1EbIY4wQjftTkFS6k/j2+nxl
	 L2Y9tEk2KJmIN14GGeXQ7pBba1WgSRRrljFL8PPRWrTQ4nlM42PoujR2VY8Gq1BjPi
	 HMp3b3LybrHRc31bbySJz+TJBWv/BugCTQnQflevpq9SN8b0SBfkwer8dHpykWaVqr
	 HhECV75CDaxAw==
Date: Mon, 12 Oct 2026 07:54:32 -1000
Message-ID: <43b2f07f0d8f0fccb3f44fd89f25e0a7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"T.J. Mercier" <tjmercier@google.com>, Amir Goldstein <amir73il@gmail.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>
References: <20261011223358.2327625-9-sashal@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 978C480008
X-Rspam-User: 
X-Stat-Signature: 6u6qp3cqj3388up5hcpwuwp7fhyfixhz
X-HE-Tag: 1791827674-654112
X-HE-Meta: U2FsdGVkX19cQdkv5dZgvAh1o/cIeW7K6TVyivLgJ0qApdzX5lH5vPl2LCNhsGniEKAGZhtsY28mAEHLrWy/YCQEVyrIMS+xkSXpw0Pc+TFWe3YDyOiaWQBzlTq1RRJXuJOPCvyvHpPy+lUy5azqX+cb/Js2lK9HZJioRQUDhTkIPJiwooCIzji8PslGJ+0Jm6vP8283dOm491hSksxMJ1UxbTVnLWTbJAYleVkMK9/Kkfnvr5vwF1HdriGjig3k/dCubXQEhcPGHz8qpxFBP5xIV1fiq5rEXcPtlIGs2uiviKkEJawqPUQEBv4jypop/BEHcNTQZMqn1rPTI9zDYezxdyZqBwX0970V6Q8P0cMG1RkEMlEGeInLVOTOQ2cKTFyUJ3l7GBM+A9C12ptyjba+loM3HuUYrUKiPDmzR5PqoIs1vZUpOfkRFP/OETylI2dbBc/NcsmeLAmfNhqENJL9cv471gLtpXVjx0/Vdp6yUw0EiOL1IEHeNrUsGkrlUagGDusuntO+fdY8TD6d+oGHK/Bhgznf0AEeRkZ0q4kOWbpaJT/M5RKnI/PyZ6d0k7cxIuX2YW7sGDR9Fwf+gaVmXNRW/kGzocP4Hi22UZjkdMPNJscxA5LD0/Mp4Bm9Rb+v/vd51elSYUb4ssWSxy+wgmU647u5YSG23DYyMnIUptra/s68gzIAmUmOGd59PuSfzaJ9bXkgdnCQ8ZBXw1yzjkBONdrZhTrUJU4bs/0pVvnj9UwIhpoHt9o9mAUEbN1djYnlHXBoS1CjE6yYqQ4enBhxv1ckqkx+7NZq2erGNZ9f3ijX+iFO+CoO8dM7qjojdK3CqeEmQT8aesz5uQYKYnS9CmSDURzPa1kAiC90QAh0R3NXbuwYZGSNDA45rZm09+1BT/tmilh23bLauYhOxdAnejUkkLuVVEPsKjxS9j4nma13heGDaatOa6ONidX7nZc990BgvmAkBh7
 qXxKH4aK
 /LcGtWyO6j8czVRJ08CYUEgBUyoF1/GqFsJwhw3BI0FK13pqX/ISBtoePIwgRfUij8TxpG7yd+b9wGGl6ZiH/oYwZja6swGKyjPfkbKl3byNYU7do4zqFZJAWsSXUWbFgv1BcMwv/ncWFhmZJ8R1tJ8T8KqtZFlrwwu7Qf5tL4+mOiWZEQajOXnBjiaKszWsdl382jdNnLoAi/u/KxO2RRvGVdGT5/nKZhPkSjCEEsuCl8Fg3xX4abTUc9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied to cgroup/for-7.4 with the subject capitalized and the Fixes tag
dropped.

Thanks.

-- 
tejun

