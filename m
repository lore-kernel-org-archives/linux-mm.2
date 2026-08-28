Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79107C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D69E6B0088; Thu, 27 Aug 2026 23:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887446B008A; Thu, 27 Aug 2026 23:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CD36B008C; Thu, 27 Aug 2026 23:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3716B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:39:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9B2A1C0FBB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:39:37 +0000 (UTC)
X-FDA: 85149273594.26.1E8BA6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4222E40005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:39:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PvQw82+O;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787888376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LokbKn+HPvryjA38Tje4FFTFV5zrorBT2XYFitZE/Jk=;
	b=46QoOcPiT73vhlO2cnEakVDrXUd358Ikb2T25XjCivlBebtU7gTiqWJ33krrx0/+XHqDHh
	k4KO1liV3SoRcD7X3LBfoXWG2/WUWbYe+Nu88cOa7z1Omv6o78JqJwyPSVldaoOnalqSGt
	PP7dX7dfGRRGSy68//V3MDB9d3IRPNc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787888376;
	b=eDylfyenR27dzx/S8JlCfpfRCZsWPwfXo5xz/v/l47LhywzCYWR5CWkRP+eCDA1L86GUUN
	2QTRxHUKPV9aZMzCn0raNwvYhjIeIdIxiK7kwktCxFxky+OKLX2G++LRohk/KHOKG+y+NP
	oGEGqh/GRmuqRIpEzT+UZGm5LCzOiG4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PvQw82+O;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59DE540C46;
	Fri, 28 Aug 2026 03:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD901F000E9;
	Fri, 28 Aug 2026 03:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787888375;
	bh=LokbKn+HPvryjA38Tje4FFTFV5zrorBT2XYFitZE/Jk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PvQw82+OL+CQYCze51/kOr471rHrEYlao1jBGs9P09QYEYYL20rD/AM2KkeJJmfvo
	 ghRSLOWa2ApRvfS+QhQonCbcLhZ9AdNXMt48kmocdjpIrCK7GHR679p8dG/I7kZfFD
	 AjJSOuq+UHQrxi435/F8FogFf6sxK+vSMno3lyHs=
Date: Thu, 27 Aug 2026 20:39:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
Message-Id: <20260827203934.329206587a04c9849e64c649@linux-foundation.org>
In-Reply-To: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
References: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4222E40005
X-Stat-Signature: azirxtuqpgy74s1i6znjyg1e9s6c15kb
X-Rspam-User: 
X-HE-Tag: 1787888376-168359
X-HE-Meta: U2FsdGVkX1+8GAqHsEdXEdhp1ACviasAKEdCzbes9a9YrtjNZaaWOQ9P9szbJF8c1+1lZH0uNvdMVswd+tCdY1CptH96FoR+zIBz8x39MJ8rA25zNXzqU1IttHeuLqkFhGeC2PftmGTeE5BwIu0YIBvV2v9s/7ZV74BxlphpLDseareLIaQK7QZB8P0qIX7pjr/UiT7GDv/11v34RDJY4VASHrGU2ErnSS+Uay0Ai06vHAX0tatxP2RFRE4rwucFa9K0Djxr3Lv6cWp2/QA6jLrdwqMWIuqzGGL6n/UBHaw9j6ybf6eRTTwX2G7a3knnTrQ6ew7DPoNWCYVRkw4xs62AOvdynReoDELwJapCsOkS/6cOIUNPj6/U1OnVX1A2WVbtEV9Vx2p+qrs6RBWGxKNo5Qm0LSjk38tW8gYEiTSW3QXI6BXSedsplyshD/4s5rR9165dlPhWu7ykHE9al5K+x+vGenb9IGE3qNtf1N12aa5c0TpZOSe+4TckmRbIneIliD5nVz+heVPaDelJLsZQJ5rluoWHhp3oV1ZveqyLgIBW9pFxXxVoy5wDpzl+++N1I6IjOh1SDUf9hGHL+O0MIlM1jMD24DTiWDcT36vp5NHAU6/5uyi9Xk/S4MrQ1TjT5Y0gAXvtH/PJE4vyadlWnRj85NvpI+z//2x3NAO2hD+JdbuchiYnSQO5OABnMt2GA3zr82oDovTf6TNdAtgeCWghTb0JIw8WH/ggcdtzq6+DzDJEkJNzMaxp3k8lMDxOgzNT9sO360NXhPuvqp8pj7hhZPuAeCNTboXHy3zGZ9HMl5Ubg58SMnP1f/ukLRZMD1HJXKwSsd0d9rEvGMVkvzSMVQz9Nf+WSvodqy2CFor2Jth2k5tnHHnxjkXXAxYKTK3SyhnPEXQPmq3kqNQbsGKWN3dNjmnO0RhY/ZCTlBZmnKUEVplAghIfvm3VwlulwWQqNkyjE2Jwils
 6KRpFatM
 6vgJSEcqOgz6978Dp/0ABxzWtWyCOtn1asBXVch/iIJPINzG4Smz/iqGf/OBXvsqwifJw9SpPJQA6X9lqY3v7U4HPIXXc4bGoTDAqLOHCbQ+FSgwevTLejFMydxorDk3BmcOOSGL9Rx2NiCOEAGlZvsxp41ZYsOT04Z1RK+oDLnwQ5fZnvC4M8/DcMAOoakMipkfwNJD0/KEz3UDzRi4N0r8I0aDE/DY8WLOHu05j7PV9xVxR7NPP1YdpRh+XwET1TdSDNMBBCdPqb/7QX+Lu1pY0kxxfhGWHi6ZF0GTdFSZPH/aaxUqzXdtWmkOPCsNrQ5IpG7irXXxlsf4cGQw+NG41UsMsuIQl8AmZncC2dl3i4O15MMLIyhUSpGFaoYPWWZ0J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 13:20:59 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
> 
> Nobody after us needs these parts of the argv[0] string anyway.
> 
> This patch is inspired by previous work from Anshuman Tewari [1].

This might be the most-reviewed patch I've every seen.

>  1 file changed, 1 insertion(+), 1 deletion(-)

Oh.

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>


