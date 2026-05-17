Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E068CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E936B008C; Sun, 17 May 2026 13:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF4A6B0092; Sun, 17 May 2026 13:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB736B0093; Sun, 17 May 2026 13:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7FD6B008C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:26:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC0E212062E
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:26:35 +0000 (UTC)
X-FDA: 84777591150.21.D14E56B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48E2D180007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:26:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V14Teuym;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779038794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6iS5tqwOBllSkfooBf+2B/3ZUTiZ4Auk6sQyCW23RY=;
	b=1LvdsPxubPDQmlVJDW+jbk627p/3CfDIRy45VhMu3II6Ml0Ddtg4tDpv/cZQ71LOr270Rk
	PDwlgfWF5KlSrFZP49rDXK2vOEgl6RtwzVtJ7jAn50DfhF77qwNmpIcDjXwRpPHrfrfsMK
	As8qZrTzzh9d853yWu1SWnAR4ffvWek=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V14Teuym;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779038794; a=rsa-sha256;
	cv=none;
	b=n6/LakiC3suaRXBqpwPNCchfnTi2e1aLz9v3YIBf1AGWCBx08R2UaG+7S2NdUqLI1eaqm+
	rFVxy4hTqbTW1rcMX9ZXg6TH68jk2qyt6pEqhbATQakdimXsgdqUUaEJgrS995XNhlcwd/
	gIIw6nSm5TeJlNv9FGba+6Gm60+FYHE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BFF7B6020F;
	Sun, 17 May 2026 17:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C912EC2BCB8;
	Sun, 17 May 2026 17:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779038793;
	bh=lGKadVHrKNT6CmfLVM9JxMsWPtA5cHWet/JGmKOuSG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V14Teuym/BTICjj06GX/CguKshYW0qhHPZ8mASyUXBhZ+kn/vrv8I9k7og2EsFjsU
	 oE56s0i4z9OjB0cy8uThGQwgfkpB8ck5evKRR1NwuP6oCDKmGxm9MM/DzljbJ5zi9o
	 4UJS9phIW/XSrkxAuFw9j9UnM+VcfDmcZOoQRdjxkc78eqflUyH5ygIUEWcCbq1O7x
	 LcG+eiRefLnbIaAVe4zZbPwxZ11CeNCojW2ILF5inBqaGqRutMrwzY30q2kyIIefI0
	 QCM6/NHPVCxf09NczrpQ9fFai4sB6zOPdIjTI8eed5oo38NauriLcUSfhV7rdKv3fI
	 NQhO6ltep+iLA==
Date: Sun, 17 May 2026 20:26:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 04/10] liveupdate: add support for linked-block
 serialization
Message-ID: <agn6QeIamoeMkesv@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-5-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 48E2D180007
X-Rspam-User: 
X-Stat-Signature: r5z3komcoi4kijnd984qgxmw4ia9t337
X-HE-Tag: 1779038794-992344
X-HE-Meta: U2FsdGVkX18eROwcoLyQUMerHHRzRT77jyny3aHCjxscP+dxUijOtVpjXkB+ZboVv6zvAMIF3Zfx/FKfMrw6j1xXIdg7A3UQ2K0MQuEnUxg+MZu/MGSidDHvX4utp0L8n5wX33EkQXxgWudKlIEHLhy5sl0eNUHJGEec3gfw3ranD/CsY2iRyo9Rjep9SXfUpymIMrKXuLQxgu2WI7Dg9mznAVRz6t4RVZ6eWLrA1jehUErqW9JffTq1un7YU3MwsHHh/QA0ztYAJBm30HIKAOeeVYcLMQsiFU+fhkZG9HLh8uwbmVSi+VSvN/uHRxL84r2EPmFIICcqcn0125Vst4lzFT4Cle/vXqRoL+0CdvdKnz80fL6R5cdQPCzpLtmKe9OEgfglG7KN5zriD6fzY3jmaP8gpsE691yDD/7ro3yrngSNDfWQbi45pn4J4DXADrxoTYRxjRJK1qEcFOoA1cVwTsFClt2w0hxvTMC3vyq1HEwmNhW0gymTu+1LMHI4nNaLPpngiWXj+HlCSJa3K8ayfZ/XZt/VREk1SeGl6WP8W8NLs/3JJqLFLpjrkZH3qKPFcFDumZ68P/OqBEaLJgFH92VVcosAvIeNwS+tGViFQlM5vThd5R+0youidbfEncdG2hwxNYCP8TNTEU2WlmqejrZVsoZ+AsNlV4Jqry9N3Ch4M1d7WEgv2W0kziAmbfaRVo2BfThXCvGCNDQmF5M8823rYYrubs83UXLt/gP34VXKPR0Tk3F98SBA+9tEHwUUuibQt6O0kYvTZFxTDM1f0obzK1GotFa6ctQcv2PYXZk0UGoWRm/PNAuS/qbQmdw4z3omTWXckhCHJA7rxWFLcCDtgNCwMBduFE4N4ronD3/kyczZy8R3KahyEJNvYNiS+ezH/yPHhDTwMZ5xPrzJX4qYJXGWJwc87BMLga/xecUIxMKhgDOveW+pkXexA/Xa18UPnk6c4mshimb
 KOlkMP0e
 1x49pnRFO8N2sZyZy4jCOkaUSs/cyqjjoT4nqfRn3MH6pz+JmejgVLDVEclOgG3LFrv38gIgR4hJRjn/Lu+h/0Q0cQcunXY25XHfVmPOA7wA1xrUEgBP/cmpOjJk/Cg5t7vTiRKKacX+yoaC1RVeSuIsokgJu7VJoiTRUFtZkY2h0udt5GWmQmR17R2sKgv+yBFqBByQOCdlqGNqPfSoh7YCOmw7+LBJVvoTXVSAYa1070eV/0VL03r5VRLZpnrP0fKNi+Id2+liKFhnreSsMfQCHUzMqe5ySjXiwAJPa2W1bd/bf0cZhzMVfmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:22PM +0000, Pasha Tatashin wrote:
> Introduce a linked-block serialization mechanism for LUO state.
> 
> Previously, LUO used contiguous memory blocks for serializing sessions
> and files, which imposed limits on the total number of items that could
> be preserved across a live update.
> 
> This commit adds the infrastructure for a more flexible, block-based
> approach where serialized data is stored in a chain of linked blocks.
> This is a preparatory step to allow an unlimited number of
> luo_sessions and luo_files to be preserved.

Shouldn't it be a part of KHO?
 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  Documentation/core-api/liveupdate.rst |   8 +
>  include/linux/kho/abi/luo.h           |  22 ++
>  kernel/liveupdate/Makefile            |   1 +
>  kernel/liveupdate/luo_block.c         | 388 ++++++++++++++++++++++++++
>  kernel/liveupdate/luo_internal.h      |  57 ++++
>  5 files changed, 476 insertions(+)
>  create mode 100644 kernel/liveupdate/luo_block.c

-- 
Sincerely yours,
Mike.

