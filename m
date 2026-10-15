Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5987CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B376B0088; Thu, 15 Oct 2026 04:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC066B00A1; Thu, 15 Oct 2026 04:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39866B00A2; Thu, 15 Oct 2026 04:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A37DB6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:39:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18E99A0736
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:39:43 +0000 (UTC)
X-FDA: 85324212246.12.B40336F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69608A0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:39:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jafa1uvA;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792053581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlhcTFporOc45iUrAemRtzHNltY+ILuEWa7USZu1uRM=;
	b=C/Yp/HPtUv3VMQ0nHushLVW9JxXnRKdtua2qemVSNqoQSD4nPFc7e2PBY0Qg/KZ9t3iYg9
	vRQgzq57OP9PsXGe2bQR5+DRq2jln3pIKFR/W0n8DfaCDxkEYnjEZc7V/5JSQ+hWbVWL89
	/vDMe6DQkkPUGYjiWBmTy0q1dgFYJiU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jafa1uvA;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792053581;
	b=HvR3Hj6hnqDtshcMZini8NkHUz1xnS5iG5S+ba8BImz2Mr2lMqUi7p9zcdlUl97jYTykB0
	WUJW8TcCGG1dOp0C7eL2u8queedfe7Qk6ggqKFh72/nlTmVS84odGI6lzgkHpUPSRq714X
	ZsVoStJ7LX92ghcQlt3TYG6kgp54Y0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A267543F1D;
	Thu, 15 Oct 2026 08:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FD61F000C4;
	Thu, 15 Oct 2026 08:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053580;
	bh=XlhcTFporOc45iUrAemRtzHNltY+ILuEWa7USZu1uRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jafa1uvAXgtotQ6UZxgmVOGkG+VUznT6x8G8rUCDCMeXx+KdgOuxhOmICwpqoO5El
	 mTVIiwBgu8+0iIDrG5wjhm97OypiLtmvEus1cAWOnciBhe4KFVzPVQ9ofC1CLbmRRW
	 Jn5RqUXekw2ZkmZcT1iiIdUSxzYWT5u//7fRYRCglAEQOjlPaWn+JoBKdtSUoekEWV
	 mTPFikrKavr1ojc4cvJT31b/buQAXZDzri4IivxyfOcQ5turT89PCTD1BFUPZJXZkp
	 esWvg6jXBjQ4Xd0rnuveFCtBC+/h0pv2MCIB9faffBxkVG93ZjwFLZZSG62ivudTej
	 i0g3/bstxPxGQ==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bing Jiao <bingjiao@google.com>
Subject: Re: [PATCH] kho: do not reserve empty per-node bootmem areas
Date: Thu, 15 Oct 2026 11:39:34 +0300
Message-ID: <179205357104.207844.7161126108043305989.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014131547.259138-1-pratyush@kernel.org>
References: <20261014131547.259138-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 69608A0003
X-Rspam-User: 
X-Stat-Signature: uh43eb3rnkanaj5sa1s4994fi3zsjtsu
X-HE-Tag: 1792053581-180996
X-HE-Meta: U2FsdGVkX19ej3pKWpPLk4EBZXjoZciMM5NQsm9Khn0zszT+5Np9YNrbn+09hbnI4d9rMdugQhtWhS4QE1D8VdmpyXbYpXrYrPel4CcqnN9jbBr1bIDj+G+Y3aWmTSZAZCoBdFzEuQeDztLVE9VtUluaRVPGA29+fsYJEN01W9iYkZ5DRVyktTdwioPxB+1JaHbqOdOvP8Znc9Sz+WRmt2vTAvWtOsa/6Xs/AQSFWOsvpcjReFer25iPt6Kz/0widDOWKZpJS46wAlBB/74RkGK+oquLWJljsP4bYJUPWsAUoUlqwpmPlkkOqjAC3RbCOyCBlOYDZkqNyrNVd1AC1AHTdptrpgjEdObmZfbs/NEEZ05zvsKoOVz4t5YgHcIW9hg5O6l1WZoW36sOy0vMG5hDy7mFUNNi53PakSwocAEZzV7zGGXGDwZQNsDLEIHqnfRWkOykXaJhT6Hzl71JjAciV7bo1SG9+7xjKhHRYP83Fm2NnQ3K+niCYwKIr38n+U6rcbCPyreT8/1eahf8OMxOXgAk99m3GNt51lcU+pc6a7DqMokpYnJQWM/+w1Ul0yl3yp2w/1wuM2uhQL+VtDgATSHc9xzUjgjFRNgHwNR827CZRH/YDZrMTnoOAEco/pHHc5LrpmC7/RVeDCxf839BquPfevN7spfP3zAqh/29/5q8nw3TJ5pprSZPdANH6BoluTGX0zMtcWxsjYQEMCiivD9/6SkKhkfJg6ao68WlIvexyVDDWC1jIdO03em2oDcbjFTvOlVzCoKbw2fivGsHKxQPCi8GafYCeKIZSucAAM0eRdenEXvTA3dOn+kFUoGb8Grfirzgso3hAQSOCfmHbW2WzPLf9zq/NpSrD+oqbFfOCk7JVucCGeCbteWX1JxAXDGzmn+IuK2IXdjj1OUgeeFU5MfMC1kURdH2IhM3JqOjrcE/SHFMuQi85zL7QPj0lXHjNnurVJB08ks
 GAbD1v49
 HMdMy7XrcF976HmMMo2eiU4NYRrgjzixhRa5rSNKjhSE/0VkkTB/f9nbc8AbvgpAdeIsmKtRwqbp0onpIyp7rWzVGXhRIRotpJyfiprQRIPQ0pNjecWSGCBcSjFB7kxUM1/7cP0djz99FAaE3IlJ7m0kwbg+t9uUPQeYbbtsudRjMOPl+c6cHqMKHIODlroXXpdhrtsrgyRis9Y+QitAET+J5Dv1AISb0/RQIYtKhgNJ4FeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Wed, 14 Oct 2026 15:15:44 +0200, Pratyush Yadav wrote:
> Some nodes do not allocate any early boot memory. An example is
> hotpluggable nodes with movable_node enabled. So the scratch size for
> them ends up being zero. Zero size allocations normally don't play well
> with memblock. Memblock returns an address, but then doesn't actually
> reserve anything. This address ends up being recorded in kho_bootmem
> with a size of 0. In case of hotpluggable nodes with movable_nodes, the
> allocation on the node actually fails because memblock refuses to
> allocate there, and so KHO fails to initialize.
> 
> [...]

Applied to next branch of liveupdate/linux.git tree, thanks!

[1/1] kho: do not reserve empty per-node bootmem areas
      commit: 9a6a70aefe77f6fb9ff2b3037dcf87f6dff65c8c

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: next

--
Sincerely yours,
Mike.


