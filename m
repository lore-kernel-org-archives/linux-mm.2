Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BB010F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD176B008C; Sat, 28 Mar 2026 13:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46FB6B0095; Sat, 28 Mar 2026 13:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935B96B0099; Sat, 28 Mar 2026 13:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFAE6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:51:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32344E0246
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:51:09 +0000 (UTC)
X-FDA: 84596213058.03.234F802
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9CBCFC0005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:51:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=liVl73Dd;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=liVl73Dd;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774720267; a=rsa-sha256;
	cv=none;
	b=k5bryTFSCrVI1jIavtnT0H5H+eSrEgcttReGittxbKiv+qjoKr3b8MT7dZow2NV4TINVJ3
	kKHjW6CKr/0rhwixz3BSghEYIWLQTUsV3spBQpGxnmgSSgHk/O+6CagtBevJ6dLxQWM2KX
	IGuA+ppreIbL90U31VzT5/MTafqDzfo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774720267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkZAdL3Md29W9IDOGJchCgbD8W+GZXFsdwZjzj0hXlM=;
	b=wOJELk9xptVYZoFUGvhr4KB/YCOkZLi4QY07Sak02ksc1+apUBUtjuQubmOmAp1XJ54TOK
	iNFocL0ApZMmZWFH3CQ9mQzHObbQTHDpdrcTnf6yiRw2SQBJM+Q3qOEm2eyDgxEp2AEGIM
	TljFrBe9B6bHZAw0rjPZitutj+J3ZRY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CF8460018;
	Sat, 28 Mar 2026 17:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ABAC4CEF7;
	Sat, 28 Mar 2026 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774720266;
	bh=Lfa/H2VSyV2kIZ9S1jtBoE2PwbJXtQWrEwEFjGo0r/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liVl73DdPiG5av1OZtXrG5iyJdLEvA6mkuMEX/etx+kfr4gT6xI3kmjciOK9AV3AL
	 Qn7bGtOK8dzTVzpimzZyZy/0S+kCI3AInmM585KzSevkam9d63ccrG87l49fi9veQV
	 LKKeB7ss/q90tEt65vRariDAnBx+1M/Oi9J0XYJRmrIuRHiaUKy/bHOu3QWr+DGWGE
	 ZiYVNpqHDxaJvsHRM64frCfIQsgME8mxQyw81EmkKHLTi1ZiiGfBFdZqwdWp7tpRbX
	 6+ypTs9usmT5m4bBJsDj4WpQNDnLuXcSCJfiHcK/CFbnCcEe0yvpwgWF+YmZbDwpJs
	 rBI3lftOq0wGg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sat, 28 Mar 2026 10:51:04 -0700
Message-ID: <20260328175105.53481-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328173504.53129-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CBCFC0005
X-Stat-Signature: mc1fn6edor5mygbb96rjnw4jzdsj4ag8
X-Rspam-User: 
X-HE-Tag: 1774720267-771930
X-HE-Meta: U2FsdGVkX1+WvMI+hnjLU56l+Vj9h83EAij5kWnlAJQCpuvh5YNg/60yIcgXmUJTLfoh5poSlI22DGKO5R4norbQeOtGBBGN77xM51ZykrEB3Rs3MTqqj3aXNy0vNiWKKpLqVboS1w8PDPerzc90vD7W4oqao838VplYZGqhIcvmbtLD5yl9fHicL2A59DG5pu2wrNqcMgZng7A4JJJj5pbDgSiPAsKzSDYKPj+Qx/wbnMRxW8rY1h73tppiky5XG1wgEm4Is2e536lqb4zT24CyihvhKLYnvorKQ8xOY4WJ2xad8JIcjoSqxC5R8zSDDga3NW18Mr/BQbrGq9RA2W65jcCaaCySdqPjsUGWPLQ+LxuSBHWT5N8hzU5FP1kVrsOqX4f52m4rNB6Qon3dozcVrl28ZzAG3DGpui3I+0V8fvvSjDtpUWNM0Sf29FhFLoxC9HRT12J2YjjRbU1UIpMRC2NcMp1iqm7EwVKlv7kiR29hcnGq6h7DCCho3DevnD+V1F5eTV9y73JjXYCjoh7+Pg2kDUU/x4Im8MlJ24TjZ7iCiAMSeP+Y/kCwnxg7ShEL8CYXzYmRT4zm+dCtQG8oxZLM4NU+gIJf3wKTYk+5mXDiYHZnl7GyA0E3cPtqD7BWMiE4vkwfDNhCRgql9+NA4aigxMMDsKPdBaldjrJfIGX5WlO1p9RBKoeIJBFrKKfyBNuHmSykZWxjruPZyuck2439M6xeex0RbchysFO3txNAdh7iZjZR2Jpp40JvFnmv0obzkdvmpghyzXJ8nqr3dOYvdEYTAkGgw1iIgwHkBILihwcczw4e80jZNdmQicrMlKswZlQ7Sn5e6tUAaSBaMu3zhSI5GivHZ0pCJRVTNFuPE0CbBHKYjgHmThHDdlR8bNFmXg6fK3T2FgoTU7K16h8v7kVM8c4HEUDa2G1T/H+wuEflt1Wr9Uhcfkv45JAdSyMmQ0hwhr/BSX0
 0tjl/7zM
 9wMWGN6INLFzLX9qBJd96Hf8tsnaH1wtW7brwkxzz26UZP+aMbtdxF1y1T2w3Ki/OdVZRDOyGeX+Dc5GPRUf2qJfuoqJtdD/LdqUvfhMb/QdBsDZuSdxv1mz++co9GWq+m1aiJrR6958O2IHzGz9VbXEaFXaawAOsvF2IGnf8mCvYNgfU5CaQV/HGmIeEdrqrCterZypnD6Q1oBOKBVMax60rWMr4Rhcplja3XV+u/m+EX3xNNgRPMJ3Jx7Js14UoF47Nh4jDcyrTKQeYb5NclU1jHmsnXec+E9dlaX4b84hbTLNp9I1FsXQhkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 10:35:04 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.

All comments are same to that for DAMON_RECLAIM.  Please refer to
https://lore.kernel.org/20260328174852.53338-1-sj@kernel.org for my response.


Thanks,
SJ

[...]

