Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B29CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 18:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8006B008C; Thu,  1 Oct 2026 14:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0793D6B0092; Thu,  1 Oct 2026 14:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0C36B0093; Thu,  1 Oct 2026 14:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBD6C6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:43:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E03EC01BA
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:43:44 +0000 (UTC)
X-FDA: 85274931168.15.7DF0A3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 891C5C0002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:43:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXHKEJiH;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790880222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nf7k3kUZJ8lq1fxACTFvD6heNgFRBaaOnt6+P+Ou9hM=;
	b=VTPJCbWyPbQSmAmNLx/nac9SfLGuol7D5l6F8S4NuHsSKSGCXnS0HDaUIHqKpfo3apUIzW
	XoS1zAbuWgDXx9CUeGLcEnB+pRul9IHXCSkwwccwfEtnzkyd3npDSLD9LxsMDNfPMvzD2C
	mCAZqQWv5fURPMqdt7xsv08+myGOthM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXHKEJiH;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790880222;
	b=PhP/IKMLizCTdo0BRhWR02uXjiCG0jJvTpvMOZcGVJkDWosoDAUp8YFFukPKQGAIMTBsI9
	1xWAe35xsg0OQsWL5oFSwsdgYsinnJGV5lCnkNBHg8Ax4TpXKTiBmwpEJBM7L5mdVrvZYf
	W51CJ95StOZV84NsoKFgYJ/T4V4OGiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29897602BA;
	Thu,  1 Oct 2026 18:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06981F000FF;
	Thu,  1 Oct 2026 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790880221;
	bh=Nf7k3kUZJ8lq1fxACTFvD6heNgFRBaaOnt6+P+Ou9hM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZXHKEJiHam3Z2xUpQMDGRKdXcZRxWTOI/dwRFHVYOszxIyjzXh/2KukXPW5tcl6+v
	 5qXOQIL9wrwUJHtf5jzaTWLy2Z83KOGJeqqy6Buv03l9TZqulFqoiLscBARN4GZGzX
	 Fr3btU8qMBKAe5LomhIa2cKvT2m8V8Cka5j4wJgcTBrUwd/lWbXW73ScaIkA1yLcn3
	 a0u65q04EujCObMXKy8nWmY1Jz/aCW7m+k+LDlbgTOkkFX2Cs/H3xlwLiBZ2cAejsf
	 tY3qJke5nvl+aDB0xe9MuWUD5j1YJvx470DP3iuL4299Zxj3vJSTktKdKzQ/pNadu+
	 oq8pn8LPrT5FA==
Date: Thu, 01 Oct 2026 08:43:41 -1000
Message-ID: <f5e9ef4614d5f9ca4b7fe6420dbf8454@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v4 1/2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260930-wb-dying-cgwb-flush-v4-1-bde637803a96@honeycomb.io>
References: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
 <20260930-wb-dying-cgwb-flush-v4-1-bde637803a96@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 891C5C0002
X-Stat-Signature: smapbqbziwkgcnkgk67mhwzfrbodp91q
X-Rspam-User: 
X-HE-Tag: 1790880222-651612
X-HE-Meta: U2FsdGVkX1+dUnZdCLNRqlnE/mFEYfpea0/58nM2ygmdvWUyPnnReQdAljBW7VV0f8yzUA/MC3yyF/5Zi10djK6b1XTDN1EnJ4p1pMzZog+VrImSOPMcEdYUog7OPxQlMIRceCS/hZr0Y3mmCjeivXz/etbDJdzKd4v09w5rZ/T2NazRk2MgQzJJ3RfhvKUPN3FkTGlEj4pFeHLCwaLiHg+/ydeKRxfc+gwv0DIq+2elFii+PP/NYt9OufEB92ToVSK2N8rWmh0oXaZRAFM0LSQsZHPVI/J1l3r2F4+REgp5iZW8xGLtv18elJIEOZXIKTG7r5Xcj8y5Gd6cE5MXLfgrd1BT6aOIJVT1F2s6km1UDePLhcm5/iUe+gja2uCbETCvwG0d3g9JNBvwy6o0JOA2if9IFo7H22ZjbUAvc9hSvTOr9yrfDC4yMvmNRPPrNK9hDG096RMC54Ao8xglnJWVivG+RTYvIBDpWXOzL1LswsOcqb0SWelicJh3ZZWyEBWG3fUi/WmPDHqQQIgfX5sRkYlbBKRYhYPf/zUiHrEycn7JAOEIWTk6ggdCQzRckzL84iZWhIdGcmj24iwE+sQfT424ORea5NAgQ6MUqEvQmZr/vvWp4+QRdPYK7kj4evM0iKYp/g8ZtAUvl2cHNUTnl2vUr8PqkoHHGkbhNOrxkYTQr4/8dooDtxAvWMuv75K7Q+Qni5l1+lt3tZOs6RMxOGB2Mlz2mXbekoi6kaRJGZBrb15SjW1qZSQADGTnSkQ13vLHI8rUemXTxSgNKwMnJbZNNlpa01yMUxI8GvCe7W6Ci/X4qpu9+Kg9SbRkdxc38vqFoJD+GCdJobBEraaDf7agEokfo7Skcwyi62iSvZvy+uV3X3ZHeIbykGkfYcucrAA/1dy6kREhB78oC5t0UNoqDRKjThu6EkbOYeKnGAatdxRds84VG8d+Ic6p9klIMBTOrtxlHxyCI1Z
 iJPp8f3L
 eP09FsjfyOxEKYErvjlExpkqqV5Go/yoWifX7Gv0SgPnnXPAnbSO8KlHavHf6RbicgSNBlrquFn4ajzeMzW9wr2SI5PmtD5uR/v8OqblmBdNpHEkvJqmQLOdBIzNy07vOPva9yU895i3hLG6SQiGIyAsicqW/pcHqDBbJ5gMh89VGE8U2ef+nf3UJGONB8tgJ0n9zuxCEQ1ZiGR0qD78fM6jsk5eFYa5ucRd22KkejjU/NleEhkgr8RS4zcyPDPUWQ5Kp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Wed, Sep 30, 2026 at 07:35:37PM +0000, Liz Fong-Jones wrote:
>  	if (test_bit(WB_registered, &bdi->wb.state) &&
> -	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
> +	    blkcg_cgwb_list->next && memcg_cgwb_list->next &&
> +	    !css_is_dying(memcg_css)) {

With patch 2 switching a replaced wb's inodes to its successor instead of
flushing them in place, this doesn't matter anymore. If a removed memcg's
wb gets replaced, the successor takes over the inodes and stays in the
tree until released, so foreign flushes still reach them. I asked for it
against v3, where patch 2 only kicked writeback on the old wb. Can you
drop it and the description sentence about it?

Thanks.

--
tejun

