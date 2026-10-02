Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E2ECA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAB56B0088; Fri,  2 Oct 2026 14:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B5A6B008A; Fri,  2 Oct 2026 14:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA646B008C; Fri,  2 Oct 2026 14:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9B66B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:27:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8144D80814
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:27:10 +0000 (UTC)
X-FDA: 85278518220.16.A7E5512
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E27881C0004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:27:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZK3P4kR;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790965629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hda13G5Ybj8yN9SXCRDlGBYWThd/Le9MyrEXHdOVh44=;
	b=XJMSkLsBjrUgfr1LQQ3CJGv7w6ZnrgcKCdUJLLz/0nab3ORO4YJMIo3cd4l7rOiuiHqCzX
	YcoeLzVy/ezi43F5Uwf/2mscmLAGk9eWt046uiDCzlNlUmLlrxGkyzDuK4AXX+GCdQS/ci
	uFx3mC4rsma9jbN+qmsWOpdrDbnk4n0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790965629;
	b=VpuWFu2Mni1uGFg1pLm8f3X1xInxYh9Mg2qhEWv3AY5NrqJ30ex9LPo2etSoHZR8xizijp
	3q95169V/cUFq80bOR/Qb8TUl+/7C8fTOxFE2AIHChNM8e5xksCY2pEN0XaoZ47BPWXVxF
	cAxvkVU3q1U8bJk53a8ub9zRjqZblqU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZK3P4kR;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1520244800;
	Fri,  2 Oct 2026 18:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA911F00899;
	Fri,  2 Oct 2026 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790965628;
	bh=Hda13G5Ybj8yN9SXCRDlGBYWThd/Le9MyrEXHdOVh44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZK3P4kRbM5feSDOYlhd54nv6YrAjROV/v2bXeT3QhGsOIaaJGaQ3bdYoLtTYID3h
	 HYOowB2CkCPO9Ed/XR9+4J8eogfrIYV1ekxmGmno216pKINNrxarEKmnhGkuA4NnUw
	 deURUZuHhuiuYoJpa4Th2n8W9SHvHJAW1lha34DawsFN9dY6VLrCKhPpYoBjYj8xkU
	 aqFUVPDHBmFHzp0FE3OvejaWNOA/GFRI0R6KpKl5vFq3pEorV9QmU7Ij0dO2mbQ405
	 yObpkY/wymhkXVF/vyii0DrM8fhgw8uupmdQbzhddolyvoRVgDG0eCopg5+tuqqU2a
	 ZOywZ6tTvmrDg==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/hugetlb_cgroup: add trailing #endif comment for include guard
Date: Fri,  2 Oct 2026 11:27:03 -0700
Message-ID: <20261002182703.40171-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261001123747.634845-2-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E27881C0004
X-Stat-Signature: 9axuo8rnic7spxqpws7wbk5pbj1aa9m5
X-Rspam-User: 
X-HE-Tag: 1790965628-218806
X-HE-Meta: U2FsdGVkX1/RelbzR5OqlEHXBkA2BqdLAh2ZIUXY1pQ2IrzL9dagiyi0XxYMUOBhB1AVTgxODnwstaxp3xjVNNLgaOimA8Pl5ZiFOXilhLnr3eVmBC8AxFKB/XJji0+o3jMhyOo0wM7ADygmynguGdEvEogIAiAI5yilzdWMG+L7Hg0l+6+gQFmwbmaNDVqwkC8C8EK9i99RfPF3Pm3AmXWUFEgopPHIA54CfS1oquFyqOwvTf4LtRE/DliIqa72soZGj2K8I+F6BVqz3WIEC71vjlLvejP2neROR0gIMPy45NrXOMVTRB1g9TE5F1r6eN7AH3wBV/5HWQYDh15UBGUux7XM9lK0zMS+vQlmDAgdhqKzu7Tj72TrPocJe29xOVN/fIJGtMSiFQlzDpcaG5cZjtuBqrbZyF6NvfzTiJ5mjt0ZxAIzWBYkJrh9debPpf/VbKWy51rcD32cUXzv8K2mCktQR63VysPgNp7Fs/9FsZbsFjEXJlnqTf7WIOEofcXjbQwPLWKGn3R0dF839Wa/gI+DNdz6O23cCIPX0dRVI82esG5bxK3v4MO/PGMwTenFHmer4MyJQZx/nCIdDCOlELyx+UkJSBXOJUxxD+Gt8HAH/IU5iPBIXMYrm1qcQxrFkP0/JKHALyLFTx8B9/Y/aGfm7rt459gErWZypN4JPRje1YILogE2It61PZXfZk/3Y30qlmO/2muzHzUuogRyazXFYVjS+ljwI49JKcpr2PLvkbG8uVza0AHn/C//i380Cra4rhoSb+Go0tNlgs5ftCU9YK5UiY7naXL6jWYDO4kwIwU6Vj5nkslDixnHNgJcOR/hkFIsG8dOoPvNBchG+B4GWgfUPz4DewDbUMM3orrFsRDik6r/yM3sd9bHSungBepPCuatOTNZF13rlDNVEQJb+utzcULl1zjCninasRF3vr3f+oHw8M9Yk/kB/wqtYu7O9iM4hl9AYa2
 Cj7DwE0V
 ebxJRUW6v9si8YY5ae7SEcyMY5eJ1vWI773W5Vd0BlCMSLvwiHs6aXbWmO8NEV698GDKsrU5M1LrQrp3lF5d2uMznlZRuYSsQwGql4TAGuRtzav99pru0HZZyFKpIhqrkwjnewgdxK/StucCiLnsIWLTijiz9RHj8bHc2NjKWWxUSJ3KfHVqOxdj5WsjRKo8cuGwa4qEUGtkkFgwN69OrXjy3zcGjpl+H5zHhBp258VKdcW+IvDea5mkX9DGVGtnzexGrTwoHWIqFUyicGXOzTO7TrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  1 Oct 2026 20:37:47 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The final #endif that closes the _LINUX_HUGETLB_CGROUP_H include guard
> is left without a comment.  Add the macro name to the comment for
> consistency and easier navigation.

Makes sense to me.

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

