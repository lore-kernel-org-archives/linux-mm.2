Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B347DFD45F3
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05FAD6B0088; Wed, 25 Feb 2026 15:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0031A6B0089; Wed, 25 Feb 2026 15:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30EE6B008A; Wed, 25 Feb 2026 15:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD3AC6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:52:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54A16C2725
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:52:32 +0000 (UTC)
X-FDA: 84484177344.26.295F4FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E277180010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:52:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dke4Gxta;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772052750; a=rsa-sha256;
	cv=none;
	b=hPmA1NfNZsU/8odY3dbLLmTwAXhLnOSkvVTNMFjn+7KmUlGNRFHvF44gfffJOyg1PSKeFl
	oCR6gImy0paxBtFL2kv5KPlYvc2misawEl/uDNbAawVccUZhxQDhWabNfswOC5CoRM5x+J
	jeJ8I9pt/DuzEyVaD0exyOyaK4FHbCQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dke4Gxta;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772052750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRBonqx5lsO8ZennjZP4dw6tfwRFpthh6FYI84ZEGI0=;
	b=kmSVss+TZQ5NRJhwSpPWJakuzbdoh4isdgMFVuLWUdnGIXZ9i5mnUbQKLxG12xz1uU3srG
	a3FEBZAMyQfDuXQ62HCKf+p5vZRt92WPDDtZ56SHyiGb3ZWYjh1ZCtp/toJ+jkbaiKUk80
	qRdLMGz4jGhn4Aa8s3FVtXlKf+GreiE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5732C43580;
	Wed, 25 Feb 2026 20:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35718C116D0;
	Wed, 25 Feb 2026 20:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772052749;
	bh=/24UvxKiEl5m8mDyEW+KFU9sQ9H+kJJfZml1bzr5jzc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dke4GxtaZMSEsusjMjIKHZvhvHlf0sE8pegU8MOhA0D3wchytHMbexHJ5AP1rY24V
	 15xunVrhQqFbQD+RMzGcMW3WBXvkaYrPA5rA3oFObMrGQ+wFTaSPX2VYXQ1YYu8pbl
	 0kJB9hrEzzo8GE3KKGF9B4sXnllQzGP9QYhEZlrKw7D1rEojtJOFKR2OMlXrNN8/Hx
	 0q7LeCTNaZspmDwJJAgeHSMfLsb6IuLW+GkjLIw8gY3JtKUOsqjUSZM7vnZwbVP9xg
	 S2E8sXOBBOJ+O1QCv9/VWI1DbI+wyi3hw6A3JKlUiwhANppwaqwq005LPVf8ATyUkQ
	 l5SjEcq/x4h+A==
Message-ID: <af93cff7-3169-4b97-9fda-660c9ef5ae77@kernel.org>
Date: Wed, 25 Feb 2026 21:52:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove stray references to struct pagevec
To: Tal Zussman <tz2294@columbia.edu>, David Howells <dhowells@redhat.com>,
 Marc Dionne <marc.dionne@auristor.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org
References: <20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E277180010
X-Stat-Signature: etmdzmnf93j43xkz16y1oz99zu6yabt1
X-HE-Tag: 1772052750-360539
X-HE-Meta: U2FsdGVkX19MgtpdEsx3SYG5fKroe75btNc+bcUah1PX3gRuuoiVd7OIawX3aUhtxyqssg1IfYHcymw6WQFNimdM6QKI2DVjM1e/5iktRS0XIFFmIlJaiPKnCDDd4viBF7iepW+OGgxuFfLEd8pwmuDMz7p9cHDwHnXlvSVdUMuc2eBiL+NuQkXnUwvVauZ841Kg7LuW3NCj3xg4BdAhAy4x+2E3qENN4hwWg9bgTMuO6a28twYDJI5z1fhGQUsNWzjpp0S77MNeVbPuAIFnGdR+iTMFRKrzBBTQwNZXgerSaoO67k9atOvhUFGWWH/kIgVQF3eeqpz5lnlsK07WSlX8y5exiwroZBLURA9WOyMM0PMUAerUTsQXa+04PZ25Gy5HymZVc3LsXB+gS5D44zzkuZk7SxsOdbLhKbzXJilSE8IkeQ8QTCp38vbLtSMBKkT7a27rxQWzgKMpUGZ1A2mVzfoLpfBp8yI+uD7pR0BqMnDHnE7sgOQJywUivk2zxc/zn0g9LUvULulGoglloCjeLknTFQDLs+dXywN2MzBS6joHuI3UIVQuO3TsXBO9W8y8vUSKIurRml7YkidC+wu+trAK23GGwRSuPddxYlkjOKi5ralBrxhp0Jlz9GEPQ31raz0xK+X19jL+0rIchCtV/HtkIX4QwINGoJgyDsBaDddpGli97/oSFZlQrHB1o1i2ul0Lz8x+x8WJBPlueS7Y+7M/xj2iol/PWKAckmHPAEdmrSpgbdRq2+ITyvRsNU6Cv8K9X2q/ZTw5Ula0x3xNeBbmBZmICd6D1WCyPJ5IbDXdClegwvtjThfigAafYi83ZUJnaj7NIlb58oVufa7wLQOMvzoerRUeo4w3M6Kok/zQovehp+UeswSHn47Bg0enfu2Yfl3rOB2Tm6WkSM+VQRTRktE4KaDe/AMhqVdYNaXOfPaRs8Bf7vDid+8pt104SO6e9caVEpFMsAw
 7kNpX3eb
 1aGbWQ/2kdIueYPb0Qx+bdp5GK8gOpwQyh2rM7ZcxCADSSQnA8xSHpTep95C1Yw2JRn5e5MsNPgcEpW2vNDQzdxU0CmjqR19xCOAazV5FIWOyw8cyF1OcnF3YFcxPfRXOjjbNLb5Hfcr9t71t0HMqfEulpfIxYmW0y5DVgWjY6ShmYimCf5DL9S9EWCQtde9PwC+H7YR4Bh8Uj1aKHvfOo/uZbueiloFB4P7CwUHo+mtJtt2fsKbbcVcn7j1z3Ngh1yti/MDv43X7e+5F9gW/sqGd5RnMiOk1UpYZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 18:57, Tal Zussman wrote:
> struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> pagevec"). Remove remaining forward declarations and change
> __folio_batch_release()'s declaration to match its definition.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

