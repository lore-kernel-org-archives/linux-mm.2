Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FAB0105F783
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C086B6B0005; Fri, 13 Mar 2026 05:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6756B0088; Fri, 13 Mar 2026 05:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2926B0089; Fri, 13 Mar 2026 05:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8716B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:23:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47BD11B8C3B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:23:44 +0000 (UTC)
X-FDA: 84540502368.12.E86E1F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8DB4D100007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:23:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iz5bb8xW;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773393822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BS5wCxsbt14XQH1hV1QT8cvWS9b+H4jerH3ozJzdek=;
	b=3MbplwQ08SG4dnYlKfvR8LWX9pnOLBcgLULIPshSaFgkZyHF/IbFGi5sAXn9GI+hxx1UcA
	eJy8G/dpfPskPBNucOKE+dUVQMrv3+pGv6f4R+nBbIK7juH14SDreV/FqTOKCskK7j5iFm
	vp64rro4q2HOTrTHePsIAuE1RFIE32E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iz5bb8xW;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773393822; a=rsa-sha256;
	cv=none;
	b=s6fw9urdGD2OBHW5vFiBnejXi6n03e8fDBsrtuEgpOAQvJu/QE98iwrKPhBWfmbnB+QiT6
	XbdseP3pTw9Dx+N2bsiCMTwu7k3EqEd2KOWj4zF5185vJI8kRUSOaPf18afMCTvcQl3xsU
	gjcwjto+BtpQSlJuSFHfZ1dMQaKfb74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8690C40C3E;
	Fri, 13 Mar 2026 09:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5B0C19424;
	Fri, 13 Mar 2026 09:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773393821;
	bh=sfucnBU6UEvHzvnIKr1NLtTw7aZJn+fBBWMo+TGZ9P4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=iz5bb8xWvwi6aTIWIz/SOjOamX+g9mekNAGNj4x4HLLpeXleW/rcEC79ibN5lA3YK
	 VrD7yL2G7Xaa2p5qq8UFWEkqfswR1hrJEtVkB0FCcK9Dp3cBvBcSZSj4CfP+PxXkdf
	 Djdba4YoLsE4E9oTkOgxpjGgbnKptOZ8xtrTFnH5q4C3TAzyl6Jhdzx+vmFiWtyvkt
	 qqwd6rDZZjBq9kbrXPUOjSuILAekuryPOPukYdt6KBn2EAnmms/0Syzs+UMEK6QYDH
	 1tW1b2zfRJqED1pfZQ0m4VEHBEzkMb6qczPY3s/JYCGWgp6o/8q+tMykutUIFFZ7Bl
	 K57qsVt8Igoxw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
In-Reply-To: <20260309-kho-v8-4-c3abcf4ac750@debian.org> (Breno Leitao's
	message of "Mon, 09 Mar 2026 06:41:47 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
	<20260309-kho-v8-4-c3abcf4ac750@debian.org>
Date: Fri, 13 Mar 2026 09:23:37 +0000
Message-ID: <2vxz7brggk12.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 3yi83dp383be3nfughtfiozwz95ensyy
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DB4D100007
X-HE-Tag: 1773393822-691965
X-HE-Meta: U2FsdGVkX19W59WkXD+jTOsPqDiYVpZB1QDgaiB52piRCP+Qxa8jf7nyOeyk+fzUvvWIpKuoDqg3seeYXgUk4MOym6E7WFr0HTwAAgHKhMPej5IXyqo+GjCoJNmKG8sS6o0STvL/V7nVGVCXr5/qKbTVf05YG121uLdRS9aUi3QK1TxWjtrexVqnFyhDKjE4Q8pCfqZfZpemZacdr69AGjlYQGdcwe3Av11kPYhJ2TrKpRLBsQ2HvL+E8H/xgLBxRrsZx7rWGP3qsmtkvZ3FEsEqwu58GPKUXHrJ/1kprQ0S40B4MOfZLowmw4gRV3lYZpFOrEDGfH3OLs/NBVNlGqfAUqv4Y7d2M2AMRpxWjCY3QrO/lhnJC2+Nn8CI4Qlv2t+a9g+ODKywuq81ggoILxV6kBKoSlEYeCnJ5AM+L+JAJCQOUjoM8jsxPzVTDfMoMAdNZfBhYyEk7ARTDvCqugbu1QuqL+DcbgDQa81Gnnk3xt+0RwlJ7fckciaeep6mbhKsvhv29NpDB+Sl2V0TqMpK8G1q7i1N/Plc5pF8psMCS1MHK5LOgBFAbsza3VGPNet98E4lmWBR206tj9Y8BWNHOYI8vprVwTXTBC5KOuuUJ5Es1vA8sspH8QpbGX6yMpag9SIbEgH4P0544snWBXw9yaqfSqMADrgPHFLCxeUdSgYMIEaj+Kpc61AE9Zdiy4UTP0woBlWlglcN6JbOEu7/70V++Gr8OEV+5swMbdZmNv6sCamd+w3owt04nQWovfpfIIoh7BZK8TqeeGcP6L7Jz0I7vmMyYnHKXiu4UhAiRrLsO++ngs8LkwCFttDw0ScIoX6WPVleiVK3T0OtcPykrfJ7QEK84gySV80exmlUwvILB8/5l++fbnGi1qG3A12Z6m+1TFGEgId60h3lJ2srOo+AfqV1TMAexO7li5QUE0H2+0CrR49pWPsKQN79VxbqjzV0xyc6d2WROSW
 0TBI/ueY
 HzBTX8fVFmddeKq+7rIYIPn1YgpiZH/PLiyd0eNUpPvzc+wj+kTQSLohvR6RuQYlfE20lFJqkXXsFngGgGyFVcDC5EeS0oixv77u+kUt8jelEYR22YmjZkC87MvCHOyklULqUuRm81htIj2Ebu26TXIBRHIx1Ghk6vJAQT3aTinJyi0a0FrEpNH/23BTexemuX7xu35c1z1cOkkSX+glJ/l5cmEuKfYvLPBqOEv66Dcmlv9+iwgf3S/F6C/t7Qwr1Dh/q9gTBlUUBl7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09 2026, Breno Leitao wrote:

> kho_in_debugfs_init() has two problems when displaying incoming
> sub-blobs in debugfs:
>
> 1. It uses the hardcoded property name "fdt" instead of
>    KHO_SUB_TREE_PROP_NAME ("preserved-data"), so it never finds
>    subtrees stored by the current kho_add_subtree().
>
> 2. It calls fdt_totalsize() to determine blob sizes, which assumes
>    all blobs are FDTs. This breaks for non-FDT blobs like struct
>    kho_kexec_metadata.
>
> Fix both issues by using KHO_SUB_TREE_PROP_NAME to find subtrees
> and reading the "blob-size" property from the FDT (persisted by
> kho_add_subtree()) instead of calling fdt_totalsize().
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

