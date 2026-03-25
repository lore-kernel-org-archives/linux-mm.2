Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BD5109C05B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888A36B008C; Wed, 25 Mar 2026 14:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8607F6B0092; Wed, 25 Mar 2026 14:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D7D6B0093; Wed, 25 Mar 2026 14:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB246B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:59:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42BD6E02F6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:59:36 +0000 (UTC)
X-FDA: 84585499152.18.70E65A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9BC854000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:59:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yLuJWyw8;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPGyIvWOhHoXYi3NZl/gatuyekwEEky9/KP79NUt1HM=;
	b=wbYoldp2hNWqfldqBoR3vJFNuyHGEXJ7Y564+mDOpypgRE48DwuFVcjyB2FO+px/StLUJD
	MIpVarjS18n/7nfa0bWwgYl9tGUR/43m/gBfyYq+FVbAQ/sXIOclFgTnzH0iyeofn9Y/Vs
	WFK16bwYxM8TtAj23Nm96sXr3gnnxaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465174; a=rsa-sha256;
	cv=none;
	b=1Adyo2shrJiSs8rYVAOjXslcPMCwYmOXR3/sO5sfSUYK9GvHdZfo8FxUS37pK379N4G0yn
	9SHpg4nGvmBzqibo/jtldSoWr+9zBfli7ZyrhT4UVAKVA7pXgnE5+1G5BB8YN+DLdUw04v
	sJcklKNBuvLsM6XJrlTHIE7q4TmA64E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yLuJWyw8;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7514600AC;
	Wed, 25 Mar 2026 18:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46627C4CEF7;
	Wed, 25 Mar 2026 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774465173;
	bh=yU8n7i686vmEbMl4LvG5Kc7Jit1Pd4MHO3KrX4OKmYk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yLuJWyw8VJjfd2r8DoF/0eMer0lCzXXkWlWRL+EX0F56xSlCQlbPTjPgce7R94nXX
	 xSOLmofJT5+bbBQ3150CjnvU/8Jum03M6fCSLnrVZVrKQdvMVuPpYj6oPUVUW0HpYU
	 W16yNDrl/bc9CH5MA/PDC4GkleeCbd6mfvENIMIU=
Date: Wed, 25 Mar 2026 11:59:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress
 number
Message-Id: <20260325115932.d2841f29f318454709fd4f21@linux-foundation.org>
In-Reply-To: <CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
References: <20260221093918.1456187-3-vernon2gm@gmail.com>
	<20260224035247.r6mxsfcpiev4wnce@master>
	<zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
	<1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
	<hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
	<8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
	<CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
	<22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
	<20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
	<3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
	<8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
	<0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
	<CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9BC854000C
X-Stat-Signature: jkcmb3ioyajsnxtp7q4p9545xtmj41cg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774465174-39319
X-HE-Meta: U2FsdGVkX1/FEqZnLUAMAwPouMQNPME2krpxG5H6OtNNt730gQHnzpsU1I4tw4Z6HGUj7q515G5JeNKJuL+N3w0uChgR+SubRNVVQ8VHYnAT/GfsGWORq35vLAYwuOnIyLkkqhR+XQgCEpMYGthftqou92AStFMsRqGcqetBOHPh8toYpdp0eFeeiB6dBOgGHMDyka7B6d30IYW2iRjIhkKaCBTvzANdb9AjB/g8YqiJZxnITbwa4lStU5QQwQGoocDISsU2DrY5EUPqw2MllvzTQnx2yOgNrH9nTAad6ibMLN7KO4fhf465H9B+HbfxuKVOfqFzs1+0S5Ua4SlS8xpnnWQ5dOK0K5wFq5FUCR1LFU9IoDiFPR6JZru8x/OMUDq10KhAwPwnsftcl4Z303+Q2q2HUTAxVxNn2bX1cgzy0l+CisM6+3Wj0DPAZ62iYNU8UunJ5QLr2Stsv68OHB2/xpuTDLX8tzsrlgu0sIXPXBLj7st9C8s5dhM/OqmWhI1moARW/FqFLTpOpy92LTi41cURqQUj63lZNe6aQSWkfT1dw5pXlJaEzEX5MiSExQZaU9RHxbNyaST9cYMuO+HWq6kQ6XkJkxNuw4X3/URiXeITFVLKil3+1JBPg3BK8XmmBhoA8c1K3vRybraw+HpxUrNutq9Qjbnmy5Rrz3Jxxi0YntjwU3+FA0VNd5+t7/gP/zAHd/Y4MnPZckzBciMGbn8hlvUKHNpUB52BUOWSP/VhCmv4pmxG/wY+eR0YLsmzNBJR+nbGHrVorSEd/tEQXMWQJ9BgaVt/Cjoc9pyGPP1qkwpGIurJC3NzkVvV54EZVpSZvwMhq1okFwqzyuNLZG8pfmdmyCXQhUxHid24RpbpTvfEHJDpQ9cD0bAfrCmoiWyuaJNbGDFbPnbBIgT6llMUCb/PiLLwcfjSf1wn1/2oCowga9u5m/BUYk62coQIZdH8MGEOyjZ/CYx
 iT1u2W5X
 RjbkiUjxqG/Cek1Mzl2/QsuoXF0aSKvJbA2SnLCOiskMCX7SfiZ5Qa833hwaAaHfK+NVaJunPHZocuKd7vv6WbM/EC9DGRMEcz4IgM61LoB59E8W3wuFIO5zBGjLmSdV9040191UM0A09fG8WGOblWh89OeJCNdhYMRU6/noOPeoUofuHcEtWhYpk7GObhZsI4ouxs5aGWA4PG9WLNIVY0Lz4yK+cVopU4G2xjg7WGn9YBPSGAGrNVBv/7SMvaz/IPVnxPU87YCPACm1BZSlZInxE/ulKFn4od+nZExh8OP3j/F28re9ZBDs1p2I8PvziSXwWztMolHssrED21xdCL9R6fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 01:00:23 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

> Although this patchset is already in the mm-stable branch, if we want to
> resend V9 version, I'd be happy to do so. Please let me know. Thanks!

Depends on what changed in v9.  If it's a major change then I expect
I'd drop this series from mm-stable and we restart the clock on the
integration and review of this work.

If it's a minor touchup then a standalone patch against mm-stable would
be fine, or just leave things as-is and prepare that change after
7.1-rc1.

