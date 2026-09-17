Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9FCC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C7D6B008A; Thu, 17 Sep 2026 11:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634466B008C; Thu, 17 Sep 2026 11:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571FB6B00A0; Thu, 17 Sep 2026 11:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318F06B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:37:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5554B803FB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:37:13 +0000 (UTC)
X-FDA: 85223657946.18.5D8D5DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94F3C1C000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:37:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KeDCnO0P;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FS0Zh39EvFJNF8MC1pNriXws4rcUuxV51H6jv1cDVE=;
	b=tDWL7aDoQVyU71CAId2Jh3MSDEwlA9D7e7iqPib7goHrb+3XRHZ7j4f3HiQZ6+gJ9gjkUE
	Pn4lEI6yP6e4xvMIUXbujRzMsvesHwH1XVsLCJZwakaQMceRCCxmA4c0ntvT92Z+HAsQr8
	MkgeHoDYB3Dm2FqPjg3wrFcmQflQ1Xg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KeDCnO0P;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789659431;
	b=ebe0c8REFW9TLHQkkv7ZmuxNHOGiYkNpnPuWrZS8Nf8DYi79KJLsJimXGyqQLxtJVRRExL
	qnQ3undLiMMcSpX+I9OU6G4QLh5EdRaJj/iyMEwmCSgYj8p79+sleinovrEm6ciuudTlFf
	giig3KhgpxMizNuvP7DqWAO31E5DXRk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8834B412C7;
	Thu, 17 Sep 2026 15:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6800D1F00899;
	Thu, 17 Sep 2026 15:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789659430;
	bh=9FS0Zh39EvFJNF8MC1pNriXws4rcUuxV51H6jv1cDVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KeDCnO0PnrntQhIgYqpH3onKDiM1X2/wp76FssvsPjXqggYWTwfwqLH1pkqB2Ajcy
	 vmjypuw8M3Kk1aYxSksj9IqyB1znizEtJ1bWXg7e9Ajy4/mv1xhMs+Hmoxkw2pEz3Z
	 yuVxBA6FSKrp5VYngimnYCcggyrz9uhKHT8qqalB5XhOVVLJpBRCoXVXHnJp627ltv
	 GI1OPdMl72ZN9NS9QW1mTWJ4PwqUq26hYTR6rWDP5cgenceUCO7pdadWNJ5Oc+KHs/
	 jz3qBVJLQEivTZVTX/G6974n7dPINny/Pr6N9OsCUfMj3rxXy3u/Zr+2042ss4DlqQ
	 wFwrUHKRheJXw==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH slab/for-next-fixes] MAINTAINERS: update slab.git URL
Date: Thu, 17 Sep 2026 16:37:01 +0100
Message-ID: <178965921180.1114058.11649457371183198247.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260917-maint-slab-git-v1-1-d21a5210aec9@kernel.org>
References: <20260917-maint-slab-git-v1-1-d21a5210aec9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94F3C1C000A
X-Stat-Signature: k56en7frrzukmcapynqym4nu7zmo4cqw
X-Rspam-User: 
X-HE-Tag: 1789659431-368432
X-HE-Meta: U2FsdGVkX19L+dNGyQ1gC1LzAHcZr+fAs4GQ2WVqAXORhqg5qZ/CZZU3oWcSe/Hp5v+1FLY+gBw6PRv+QVQ2VeSDeY/OWBlT+Kua3GC0nvOBg1ka7DpwiBqDnSveURd00830MO0wqlbnX/EQAHxWxM7FaYI8uZw0m28OxbpsCIdl7JDQBq9HwXC2H26dlYBue7Nevc1fZK3c5ymg/mcZUf6Rj+tctdi4Wsq2ZXedzel6cn0iUUkc8lJ2QvBb7ChnYdzU14b0dN+pmSR9KCkg0LMfzLObjgkjPePCyu3HGyZi2tDkkidiYtSUnSh7jJXQm69QablMpz0eMHwdAwLaifF7kfmMsWvMl/9uHU6qkf2Blj2j6CIkgK4F61vKdJJhRFtigoSjbxcTHfEBP6CahEnwj/cNYjcmz8sv6h5M1MsgdTbx1CRya3Cb84NxJrox2O2faougaqFQWDgoWnBGpp1aThkDv8My+V/ZPV+bFpu6WRH8YCMMIXaDWB7FRdB55l4ruuTff9UWuSxwWhs51h1W+OqVtp3fM/9DcWLRbYdClLgZKM08eDMsd6zwWcrLxNxHa+oiTQ2bVkruIOtappn2l/RsZVEAaTyfSzElHDhU0t1RLffsnjyTi/oCHph3CF2AZBcbQUML/dAu/S2Bk5Wp6heqmAuZJSQH43QYRJG/4XIdGC3XEAd2rCoXWxSc5T+wvUD+5cyA5sN2Lqp/+ZAkrP4SGJXJYZdd7N60KqljnshYKJcTRWluLA6cpt54hIFfZ35fQ98HuwvJ4HDx6TB03fGMTvPo9Um7DiD/QWod3OViWeaE/x/RV0nunsnUlt7Vof2Gv6hPjWxnG65rP3UB5M/zoiPTpEL2TDu5Ui79hy0V73yEZUVqHGZ6JIkKq442fRglW05oNRINWFohech6/jeKLYCtW0EQBs7DsD6wFyfn3qXZwzolqe+0Edc8fwrCYUrHJVUfjxf+CbD
 eXVPt1e/
 x3EKZQb4g7U1Z21nhqgdqaGonfFcRgFcOdvWDS+Hli4pScMxv+86sVoS7B6JDPdXKB1OGtc3u8pD2nYK2l2jA0rL6YBd97Kz/Sh26h0RRapLTClhbWqAaFdIe1hy30utza28vr1gRfmquqFcJbUBR0uuszBaWTdhiPspvhkTytcVg0kcLfhB5XjlLNVnUoWZrIR7XfSoYl2xZsy9ebWpcHs4nKNap5lk/2uSDSl1fn7LA8XShU1uB6QgX8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 17 Sep 2026 16:38:37 +0200, Vlastimil Babka (SUSE) wrote:
> The slab.git tree has been moved to a new URL as part of the mm-next
> integration. Reflect this in MAINTAINERS as well. The old URL will stay
> around with historical branches and tags.

Applied to mm/slab.git slab/for-next-fixes, thanks!

[1/1] MAINTAINERS: update slab.git URL
      commit: 4c51f0b648cbf190d15d4ff60826c769f7e81df6

https://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git/commit/?id=4c51f0b648cbf190d15d4ff60826c769f7e81df6

-- 
Cheers,
Harry / Hyeonggon


