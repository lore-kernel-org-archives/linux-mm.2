Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1D5D6AB1F
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 00:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4596B0005; Thu,  2 Apr 2026 20:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5516B0089; Thu,  2 Apr 2026 20:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAE76B008A; Thu,  2 Apr 2026 20:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDD56B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 20:36:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26215E03EA
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:36:54 +0000 (UTC)
X-FDA: 84615379548.29.24AB322
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66577C0004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:36:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sn1Z+rWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775176612; a=rsa-sha256;
	cv=none;
	b=YmlkeFsQTMudp+gl4UQa2DoTLfUAOWvLvY/7SUACez8p9hxMjufBIk7uLb5CdrXBb7T2uo
	clIECIlE5q/fjjsT294NdlCy7ASQeN+02FLX63j8TsmA72bWHHfr9R5lpJffBqQh0iQJjS
	KsaTEoNBWUpLvkdsGTIb+nSYiiEAR7c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sn1Z+rWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775176612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=236MyKvSuvWFfHcejS7MEaexKFV6V1RY7jly7iq9wq4=;
	b=Oke5/WfmhCHNPrAZvVnvzS6JODj5wwzuTHPO4CZMCNwm5tWbfZf40tNZW8gG79pf8vgpVS
	DjP11iY71f8X1bHNqWPxf7svxLbgt574OLqOwGpp4ZS4pb9c/MRvwwPf9WVI7SVonYVO3d
	CaFyQgAcqRCL2K7/ROW7H7zdzXx9vJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38A5F4170C;
	Fri,  3 Apr 2026 00:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58E2C116C6;
	Fri,  3 Apr 2026 00:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775176611;
	bh=Ba97r8vhLCnvHgzO40NHwuhEGNikej2QWiP9n0DFsu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sn1Z+rWDcZiUAPsy4N57cnw49pobdLxts3vrK3WEc3jG5onUS5RzcsZvUB2WsVRwE
	 c3HXF55GYeu2okrQRYYvGrMsGmOvDw+PPPzNi7gQVUIL/4mCIuXkbx/iiT+5aV2//Q
	 pQ8N+p9eW30W+aYC8VRpwk1ZNdapSCJl/SNc9FySvlkNrxZnd3p9JFsYa/OehqHZCT
	 IR1N1FPPMUo1b2AGZIphHN3dmSVDZgeSuldnoLijVt536bw6YSk5Fy9sMyAYXsoEGo
	 LUZsC2y3t2lvJ8kCkWGuf2XplcFdyzvEziyKlarDI/pDogHqUmC5sqdeOF55GKLeMn
	 2orWEJRVsSCow==
From: SeongJae Park <sj@kernel.org>
To: wangxuewen <18810879172@163.com>
Cc: SeongJae Park <sj@kernel.org>,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v1] mm/memory-failure: replace magic number 3 with GET_PAGE_MAX_RETRY_NUM
Date: Thu,  2 Apr 2026 17:36:48 -0700
Message-ID: <20260403003649.46743-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402064946.1124250-1-18810879172@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n8ae3f7psreidcg9zg4ebx3y6663zdg7
X-Rspamd-Queue-Id: 66577C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775176612-968460
X-HE-Meta: U2FsdGVkX1+FK93tp/6FwWcW8ANjXJn1rjJ5sROxcsgx89Gi+KT0fpRzzeGBVS0fqyjhOOPySUWh02xSAJtumGfB1ArLTLyRdeDB/CYi9bAbq79RhXILyZqrWeLwzPvn0OHvQYahsQPNJvzxjJeYn6x+eP7k4ewnw3G/fNlMgLDrXrOL7r/l48ZRLUqpfH/d4+IfOUPDkMGxDlb2yEaNvBhUgv4UFxwvX45JUXA++Hcj63EQ7noTANGj29covbkHDiPNw/JBNfyMjwGgOjDZi1k1AqybEgdks7bEhCABaqnfg3S4ociMnNzVZ8+eXKJDVV1og11TXkyQ2feDGNnoqVWYyhVsd9Iw9c8bOfIpVxoyJ8Q2UKBxLY9qNW3U2b0UyTX0RY+NDbB5f3Nsz04vTUGLJfvTcQzbOagt5z9LE3Z8FlHg0ym1k5QiHFG3DWRBrFgiqxZJBTU31IydUfpHldT1o4nx5oWADifD+AlxnHLltKV+TdgSg/t6xBUeSt5dHwxnrhMvYzErhTt/XFQnRAZqnQJbAQt50FGw1+6YWNEV/ZyX40LdPcWO6b59mQ/iuxTzLLeExGQISRO8HlNwU7Py0ZZFtd6zt1Rd+fz7VaPHGMJRkOi/y1HRPaG/SasdcU+xDYV7lubOYypfjLCFS8BTdPBagb0mnPed9yizercaiBZieYsJSW4804voSxpD4PW5fmeNiRjcxfYVot4DLrbekqTNIryddmOA5g7JZrQTDkXipiaVXwztwAtvbfSH+hH3pZew7yi4mQqSd7/jnvqsCcaHN/Fm4kBno7xpWOtm2tITSTNDZpxxkU0kjqIQoN/1LCdCOc68+RUGqfwoOk9Zp3h1n5DM+Tnk+Bw6FXHAL2SLZ6EV5P8OeDjF7HtpvnBvX0UcGujXhoGaMr/n9mqBMvZThImHzikBQT1OkgfHC1bTWTE8h7kFavWiWdceO/AZzQdXRJDpwT3KtAk
 9RKocXmp
 Xe89KWiU5s1HqsJxGqdhI8AX7gNP7/8HUn7Bjhr+x8rjB89Z9XruYhbS2EUzMwsst9ihG/wYPwHekUUUvSjJR20fpv7VJI6vCOA5pNoFcOsGhXHs8QMbVEijnM0JMmeM6MbXvu7Mkf2xTyni8xhwAck2pHCJBVYEWRQ0ywiT9SI78xu6WKy0xanfLQ6jZoBLmhy3Z56a7CemmtwMZOnW4KmR0ag4OnYwrb0Moepno8H4C1tU7DZTH+4j7bQmG6yjbuZTbAYt7Ki9Y+6XoCRgSbPi89BN9GNH54R2eYTBMULohfqiv7wBSzUr0EvcyNzueuw4iJRvbH1N8nBPs0Xf7r3a106Ubh8d+xCBawKymmf+fkma3uoWXV7rxiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 14:49:46 +0800 wangxuewen <18810879172@163.com> wrote:

> From: wangxuewen <wangxuewen@kylinos.cn>
> 
> Replace the hardcoded magic number 3 in get_any_page() with the
> existing GET_PAGE_MAX_RETRY_NUM macro for code consistency and
> maintainability.
> 
> This change has no functional impact, only improves code readability
> and unifies the retry limit configuration.
> 
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

