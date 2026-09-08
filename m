Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4990DC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B4A6B008A; Tue,  8 Sep 2026 11:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB9B6B0095; Tue,  8 Sep 2026 11:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA826B0096; Tue,  8 Sep 2026 11:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2997B6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:11:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B51C11C2910
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:11:38 +0000 (UTC)
X-FDA: 85190934276.26.08C3432
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B3C052000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:11:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6yPuRDHRmQU1oVSrLPCSPwbY/GpkIkx878miPCa/jXY=;
	b=3W2V5zK2Obhb6ZqxTtNyFL77V2jlyFNhicZnburKnHOWxerwxWh8zzEfGDnTDPR0PtsMv8
	UWziEInpLAoL/7uIxn1yqwsp1IaA7oeLPCzgVVk0GXMdxRs07B1zyeODmdua+amBgqHFP/
	CMlIVGY+DWj/IZrP8GaHal9QrfFy7RE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880296;
	b=jn0/cIppnNLLcA1MXxBWIf2lcB2XKOnfwMVBnFgffVYEEbzhZCXEhqH/ZawJpBpj8GMMHT
	34HA7PsHxKQYdDj95Fct5Md+t0LUHbaUg3JXcSbQnHyqHsFEZJKjt11Watxqo+t7hCiYE4
	SJdu0cdVPPeWf/TlbMcEs0DCpuX5ZfY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C77A5403B5;
	Tue,  8 Sep 2026 15:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA52D1F00A3D;
	Tue,  8 Sep 2026 15:11:34 +0000 (UTC)
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id DA927198003A;
	Tue,  8 Sep 2026 11:11:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 08 Sep 2026 11:11:33 -0400
X-ME-Sender: <xms:oCWgagh4aHsO6u7t2u3Z_YvEM60CJrgUBmozhiF4kvTFPycJj-5xFA>
    <xme:oCWgasFW9wV-IcUYtjm_rKX26n9JE29DSwGN9G0vCnUlS6865aVSqndnb0fMoQUgi
    1gh3LFLxbk_rdTbx7zHCzg49WHA9WouF8I6f4YYpURcY_BJmBdTJOcb>
X-ME-Received: <xmr:oCWgamJ6SQ01zFU0Of5eOkZjXcbyRrTqOaYPLfixsHa-sO1icr0h9Oq9GYE>
X-ME-Proxy-Cause: dmFkZTFEY+hQ++eX1WT0d18QISpjnqopgTIkTc197fr/D4AEUM/kc9KqJeyRYSclrYcP1c
    XykK6bKruHR9a9Af6TdSDfsRwaG0kuuiFTdbIQxK0fk3sJWTHJ1nfw8FEUmTzotknj71xz
    ml+JfT9VDf5Irx3HsqSaHqWmzJSSZjIFodSXvbmHW47PYVrsUSdZxAvW8G8hgFc6dAjgGg
    hIuIT7YGTr8AEqqpO7ulwGdMeSUijanAbRo6eMC5Bb0mGAR86bsnPNFSQegPUIUlnM/FpD
    e1MjPa5kV1P/j+qJjlVxnW9QC60gKJfVmkd2WdkLUiylOJgEzLMW8q4uD/mz/iHHpkhndB
    jVoCasw6n+i19NcTmffKruiYHFFGxO7BUshWmkaCEauGDcDT/pryOKe1Zpb0k+/Y4IUWkH
    +beQM2VK3jxsTiFNqtNqH2YWM54ba+/2bpMdY49kOnXmSNq0dLrnrEQaBxUHB4cIBWiHME
    BsaZ6nsqj8xCIpJxeb4X9LHkvL26HZ+ByhV9E69oIZI5JfGkfLlnlPeOAnCg04myM8fHxj
    wF3xfm7DMCFtBsYtW8dsY9cFodxGu04Qy+xgVenNqxkXcoWM4O51Vd0PCxdJQHxZKEqiQh
    sRUc3M5+Wk9lX6MOdSyAbf/sTVgkXs5q2uLri8/ywmVmnPvyXBWLBY7BZinw
X-ME-Proxy: <xmx:oCWgakto3SBFar95hYSOzul25V52NIPP-SbuLnmQ7rSIZwgSXXrBhg>
    <xmx:oCWgaj72pYqqq9G35VDgbDP9kAxgZke8Y8zE1HYsRwQ3uy6ikEscuw>
    <xmx:oCWgatdtQvYLHekvBqoTli4ly07oqKY6YUkQ_f77MqIzfkVnYT_uxw>
    <xmx:oCWgamXfErQi-Yh06aq9Za9jNt22yiY9a_7SrrUgwdZKWVdvLCwnTg>
    <xmx:oCWgag0MTv_wptp5_TdlkeQLQ0tLZ8-bc6Xu8tHNpHoOzPizMDSNWjtq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 11:11:27 -0400 (EDT)
Date: Tue, 8 Sep 2026 16:11:26 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 04/17] mm/huge_memory: split the routine for splitting
 anon and file folio
Message-ID: <aqAlfoQyKa1mztCU@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-4-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-4-b532a3f20e71@tencent.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3C052000F
X-Stat-Signature: pux4pztx9shxft6hrg45nerne61x4ekc
X-Rspam-User: 
X-HE-Tag: 1788880296-270296
X-HE-Meta: U2FsdGVkX1/NRfMZRhPs/kyBANZ/Y+zMZ2RtSEAP1dMqgza3vJ/zQWa+7VQHJaaA7kWuT3N97HblEU3LGFLUw+h/gSpdM/5gR69CxDrI3HHYiVDoMpAG3YDrWktN0AAERiZ88BvU5aGdrkG27V034h6HqReoLFhCoxmaNGwlF8KM0p56ossqN5zoWeIqKMbjdI9LHZr5x/1bFmpKN3YxAP05T6pZwomCJrKLN9JMYyyoPmc1UaWQNqmhe6LyDZLUdj6m2tdII508kHQmhzESshtHggkato35EhJ0IlPWHpehpg/LuaefHbzUIqQEj+xuNGjM1qoT6sRjgHaJtbPJgVmJEErJFbT1dWqOJFG036EEca5QsVWpz0ckI9e9oKl9gAfoSwdpvLP+WyhgdH/ZMIe01iMS/V0Y1nZZLC/SiFL3kYExLjGG7AWWRWNnw3B8XffniqGnq773WxWv1QBf4uHddAbBWvBwqDYMtEbcj9C4WUmUpXChjfZgs3tihg1HYLhy7QBcpBUvMEUk29GYaWjsVdMnja+gKZjSujSLuIe0WiU/cMhsjTwvlSu2CEJAvEfzZhG+CpiU+5C3cw/f66okVt0lPLT5D3N/co8Y5m5BfQ8AvjIQLJpnI2Xrwcsm/qmiG7cb0p11gBMwu9MEB9WUGlQVBi56yWI008bn5tMbmvRHf3No/8YN0xCeChgkoZupme2r7l62QbUfNleK+ZUWoFqWpp+V56j7cSPsBVsaT0J6ptVwDrdz+JAg6NZc9jJY5G954dsSH8uQE4IcAZ5X1GbGQ7mg1Djpbcz5jzuNe6qGUJjKB71d8B3Vh3wULhX6wAoYqo7V3TLNjhhdnFjQ76Qwy+u7g1QOi3UzmJNJo40feKGFs9LAzdcu6/zXXSdLQUyvZJGKUf8dgPn06rp6hMnSnVv0EN9BUwGY9hwnCCsgSlSb6XSjNVLSMLyaql0Mkg+WAcNmd8sS5vR
 q3k7Nzgq
 CYPewljVhtBKexS+twmJslwTMJ4ULu7IE6YV5sBQg79PFSODZstc4UtZ1ZDxYUr2H3EHihao2EUp8NfnotHW67ESzXzAXlWvI7KNDpN9oiwZWFdIqqCj8HXtZMIt05BVOoU1C/PEtg7qj8Ls/FQhTnZ5zjbFIaY/yYGbcI/Jg09RtZ7DF8PMp/PVhGnq4xGiqm6nK2ytIVU8I18LdGT4susHpNHScIQZSnHsUtehJP3ZzB39QdKfi0E7gURjpAPzxUedJCC64+ReVe7haYV+9OyHWX9XDRoxVr1wvvRHOBBsqeRbb0p0+2+KoDTm4MqbN5OzdPhjJmS3cSV2I8tyXjzWAzggcvin9Fm94tuB3Sy36h7vPqogI+UO87dGYG2loeuGT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:08AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No functional change intended. Before adding more logic, split
> __folio_freeze_and_split_unmapped() into an anon and a file variant so
> each path can evolve independently. The two paths shared little beyond
> the folio freeze call, the LRU locking, and the unfreeze skeleton, but
> differed in all other per-folio bookkeeping and routines.
> 
> While splitting, some cleanups become easy to apply, and helped drop a
> few now-redundant checks.
> 
> The zone_device_private_split_cb() calls are only kept in the anon
> variant, as device private folios can only back anonymous memory, and
> add a VM_WARN_ON_ONCE_FOLIO() at the entry of the file variant.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

