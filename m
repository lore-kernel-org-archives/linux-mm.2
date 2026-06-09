Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D96CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB386B0098; Tue,  9 Jun 2026 05:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B986B00A4; Tue,  9 Jun 2026 05:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991FB6B00A6; Tue,  9 Jun 2026 05:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2676B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:59:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3167B1403B9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:59:35 +0000 (UTC)
X-FDA: 84859927110.22.62C3880
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C9F94000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:59:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhOXKGqU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780999173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWSy9s2Uo+D2yHOeSy2A7Sp60cndUtpnDFI5TAu/XEo=;
	b=s6i3YBAlvCap1L/qUnDiKdChBGdn7F84YZ2QdbAdmCPFDDzfsThyy51LEX/LyLae3T93V/
	7o/K3fD78mIIdXk/ggZ6oZLhHLoE3WDWM0diPhoD0p9oKpttVx5/KbdeufOxYGFJ9yfpCQ
	CEtVPtsHXwdlXT/ROK1SsRaYY+Sn8MA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhOXKGqU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780999173;
	b=5vtuxrXUCF9CvxZmOJceExJqM++GTgNnwhsAUeObQ0VUOYuxhKTUiWgw2jALZVWwlOHNs4
	9I2XjN7IEaNnE5ADM0ZPRvYWTrgdxC2Awu4Wo9RStG16NdBA6n0UC4aCqvOh2MYwnvSZzj
	xg8lAiZ1jVAAVyXXAWNOCwOtjBMAc7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CD5D601FD;
	Tue,  9 Jun 2026 09:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8D91F00893;
	Tue,  9 Jun 2026 09:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780999172;
	bh=oWSy9s2Uo+D2yHOeSy2A7Sp60cndUtpnDFI5TAu/XEo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IhOXKGqUm6L3V+PBCFLx67FYr5PsFMcbN8iSD1NfcEvWmdqO1IP3BZkVDj1sw63/M
	 apLzVHIK4EixUi2aDQGo1i3D6CQjQZQAyTTRWonxcj6OYqXjLA2A6tnS26zawG0v/U
	 4bRg85UPf5OQH8W25ixAjOnIt04JWfQK+nLTlb+Snbb67b8wOnCbTcnj7dArmM2f8n
	 nNQc0Move2S6KHgziXDATYzb18y1O67QArByqe1mug5UI9O21vuFaInqgXDJ8SMdJd
	 bm4ORDubVKyTFExlCDOkwInIP0TdzhHU7KBG3UXzglmS1XWhKXp2Y7wZ9Kfu62EuYp
	 vBYTCJQ3hEfIg==
Message-ID: <f0953b11-7524-40c6-9d8c-9aa8b8fd24ea@kernel.org>
Date: Tue, 9 Jun 2026 11:59:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context
 nodemask
Content-Language: en-US
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 kernel-team@meta.com, longman@redhat.com, chenridong@huaweicloud.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rientjes@google.com, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 jackmanb@google.com, ziy@nvidia.com
References: <20260609002919.3967782-1-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260609002919.3967782-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zzhhy7sske4nuw4sntfprch76tf4z5ia
X-Rspamd-Queue-Id: 7C9F94000B
X-HE-Tag: 1780999173-439883
X-HE-Meta: U2FsdGVkX1+gsx8QVysG7ynGFptusiMiIZ6aHgppOw9PndvHieGkLmw0JO+9G/xiWveAagtqWIZWWHAC22A9BEDq4XV/bPZ3GhlIDZqt8zMgaITdqKT0O7yHrAQlzsXjQOMlmWkiGJOZBVk+1GEH+JfbeYtoPopn1fjkK0nRj3tBdxBvMSBiOOSHGHMc3KeMPG4GgOqUfZbR4rngZH6e+/wg+tYD35pvqqfjUDCeKuL7zNBYocLbdDZk8CcrMFoZ0GQFxTCLdgCLrCPWNiABa4ZkSfqIJJLvQWCCecxO3zqnqS+lU8kADUhES/JJYJuQXDbbmJeRzj++8wjdXZRVvSoOcdRZWw4j0MLihFQQkckTmEBiJGS8B348bvsjhfngjg7IPlNKoSe5dErAc6l2CSj6h66jddYfBH7WGCjG79mV86MHOGTl4xEqXDr2Qxrr8Xcuon4SDkcaf2GKFsE/71byxhmP5lSEbo7Mo2kbjFNexZzTKAHft+dsplKVaCfDETurpwTng/fiWZpHTmitA5mRnXplvLcCQe2jjjHVE31hOjIUMP66A/xMXLePi0OtJFVesytpgoItmMSyXoE1vylRVrZvVU2WzNe8IZMk69VFL1V5/Hlh7Dgea3j2CgPfo2ww5wE3Y7A1ORHfhBkW1cFCkafoilhmdIxRGBPzGxZ4oD0taAE/zsl2jQ7CvJ8wQ5g//LiizFa5Ni+aIN7pKYt0KTUG8vKKUieTGTHGw7sNmojiMmIG+Rh6dQtRVdCDG4/2y74rNoVeVyUJjnZDrQsCyqL3zdqZkwOTmD4E1GxH2rx8kzBt2htRPgT25C1Y5snjQ81lRAWIv+I4vHqrQ7AK6PC8Eb77FxKU8IeJwZfDAYvDqxDtq5P/vfwy70bxmKFFcL3YAh+0yn73IXXvO0tK6DclHTH0rTQb8fdHITOiSTulxXKkFhTe/DTC54ZFcqXoEsZ7a0/ar0RmwEj
 X67Ezubc
 kM2bywVnbl4jPHr2xjjgJbFlo7QIf3LrK/cc5aOR62u4ksmDDjdSZwRnrtFDEdXnSZPbEGIyJ1hX+J15plQxIR4nGvF0SRXHHeS9phK89uCzaij3NPycdheT9bkf6qVWz9galOxQj24P2qHOpqz08jtWU1KECU2V+5IhnWJscSz7b3YpLVoHXhsIdcQ+K4PKfI8TnuCs8OKWNcu9RG9nzl/d4c23dbKfM+WI5gdl/HeyK/qIIpnQ2QZ4mN8u913NUVjmSVOZ0DfXtXpi8ObJ0qSpBL62EOt9a6IumIIfs/aRS3xQ+Y5tZ6bTg5BUCFADk8d2USlIz+bH0Kx6HSXoRlOMCp9g4AukeGpXCJNHgW9QusO/Q4uw+ZM5yTe30D3/ISwhppLli1Tu7pNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 02:29, Gregory Price wrote:
> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Nice!

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


