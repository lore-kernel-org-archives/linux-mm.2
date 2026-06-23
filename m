Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BC6CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B25E6B008C; Mon, 22 Jun 2026 20:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A666B0092; Mon, 22 Jun 2026 20:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE48E6B0093; Mon, 22 Jun 2026 20:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB46C6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:00:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 187E31C1F59
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:00:27 +0000 (UTC)
X-FDA: 84909220494.27.9B3BD23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 843582000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:00:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPiUww0N;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782172825;
	b=WxW+qZXL8sB6uHNK3vYZOuRhF2o5xsZW5vIhYCksV1X1iu7c1b2C171lQOLilWyTIIqnI5
	uiFG0GVoR74dDCtu4xEJACqrpxmMUohtbPBJtSI0kKiOWkVgEoHNr8RdyVuh3AJR8iWM9j
	ebk4SQ0vnIuPuoq9GZLSOc20wOLHS/A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782172825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AywT9WsKjw8pcnHToND6xIDubSem8qKfZkYRXphdPgk=;
	b=Opn7QpZvuXMfJaU80zTEGNbzc0h2H5MNpIuT2ZhhSHjn7zc7apB+FBmHFV1wkPaRNC88Pi
	QKlM2J5EW7Z2qLGBH6FSAh/IxTnSch+U/JRWCflp708+1pQn31Gm8dXodfIyZ3Csco3aSE
	KIUbAo1NA+uaP3FPS2E/dQ6qJcoiEEw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPiUww0N;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 049946001D;
	Tue, 23 Jun 2026 00:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898791F000E9;
	Tue, 23 Jun 2026 00:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782172824;
	bh=AywT9WsKjw8pcnHToND6xIDubSem8qKfZkYRXphdPgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPiUww0NxUbwHantzDbDeO9oVNj1h+4a454jcrCM1TS9Z2Zd/UWKJmhtvKmae9X3D
	 rKYSkMKYikAV2fTzDV9034ffl/exzFLUaCSnCisv6PlpP389/yyP9RWWpLGl4mserQ
	 UpRWeBCtWN/4bd+YN7Kb8XKms7v2asKvaUmIT7RAXi+QS8CQr//oUwgvEdB5s0VCRM
	 Pzch8gzve027pcZt0Ykc7gta8TKAeAiVI52aj2AbGC6eFArW80b1QEhOcJl3+7/jR7
	 QUWWU+HmgvDY7anOV4DsZqNqZo6zojKpGh0y9CYc7oVhkF4T2U5Qxt3qKUBTx39GwU
	 akZXHHwXNzRNw==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
Date: Mon, 22 Jun 2026 17:00:08 -0700
Message-ID: <20260623000008.35127-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622155913.280355-1-ljs@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8nunwdqc5cm8ytftnh7kbh7hyduyphqr
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 843582000B
X-HE-Tag: 1782172825-702009
X-HE-Meta: U2FsdGVkX1/6E7SDBy2APO/ojjrgrZ2IcOU/B0uTcAlVQEDJmnTiRd1sdCLxd/ROIRvx8NeDxuIq0JT9fVvUFTAAXAAVGZshFjAQC/2aekXY9n6R7lCEOoNND8ZnHVvPjwPr7QPhe2GLwTxQqmTv+mJQGSGTWSFH8JBUHBrrqAlxBQdb2HIHnMm6X0ssLSTBOwxIg1K68V9sqvx7U1tQKFX14E4+t6LXbnvsdMdw1+uXEl5rOXmcnb/5RBEF5MrE0luaL7oHwavEQ9ZmZpQP56G02/PyVytXghQAlo2d/R8WjMXnxORBopMmMWFgeCnwDF6OXJWn3G6Q0YSA/nt8UH3jse54k/AhUY/3HP88mxtdAsxXGz0OZH+jU7Q/KSHEmaJBOrx9dK7dSs0JMzzTCVxrg+7jwuGGYbhq0pG8SXtIRyUd8kuyPcAiti5ZPATgz0gPGWJrbnzj86kzYZIsvC2mpDsEEVvuituH0f27zoTecY/3mz942kqlBgGiyR1TMb9ZMyUCfeS5gbYZ9bzETfm1T7H+DAkZIiInsX+VU+uwQvWomhnJ0EHoRS93dcNSs0F16iJ2vppmiv2wBbl5sE4s2fPTGr9dT8le0WqCL0mH0ZiKdpPAoVLsO446KoCJnKj3symacd6/qfO+e8M7+0MQsftOL1XcLr9H1Bb75PL7pLFO8tAfUFJc7+TQoeIpmwx71GG5au4v8JYzz0tBmvxgcFZidf8qOx/aAvBynxXPj67OFKiAmizYBP2h4hIDkguuX/rnczbc7LjDQVihWgv2BkBp6MihKshps0LYO2MS0jJysjQOF0e8Mf3ony4luI63AqSyZ26klm5p+3on/n9l3SPsQ/Ji8SzaqI+URe/b3mr4bJLLrlB5ggKQ+obhy6v670hIrHihbJHBOu6J/hlXObW/8RLNi2EebuujYOs9roQRg9PqY5dXYJtL//jTpyCDNc3UcpRyQgNBFgG
 wn7prmy0
 OO7eH8EeP3BgTvT/k2RkELZ70e2IIvzO3Mvjwa9KACcUkf7EoDc676ps+FdzLJt8XPaNNROg1g/PHKAbHkrjTcLyYnkzBoltoc8mHgxaG7FNwqpKvWrNcRPdgIAh2T6P0ImdXl7ysivUXy6gZjMZYeB/lR7ZdqqT/ZGNkIjkHxNchR6S+SBfNhYXQLg3d1sZEY3YVTA5frtD+8ZTKQBhkKbL8PYdTO5X3vAdnt2NNd2a/+AM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 16:59:13 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> Lance has been doing excellent work reviewing rmap series and has proven
> himself to be a great member of the community in general, so add him as an
> rmap reviewer.

I fully agree!

> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

