Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34F6CCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 15:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B068E00F1; Fri, 31 Oct 2025 11:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502BF8E006C; Fri, 31 Oct 2025 11:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FA58E00F1; Fri, 31 Oct 2025 11:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 315768E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:55:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDED01A045D
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:55:04 +0000 (UTC)
X-FDA: 84058858128.29.21E32E2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 64DB54000D
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:55:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tk1MbJSi;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761926103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YuW+29GHdEUsg+9FOJ8KTvrdSMVL/8PjyFQElxGqX0=;
	b=vGJWgpKBxj99ozYwXuiFus6usm2sXJxP6HeI5GjLKCTTT6vhtwVNDgkOZprcMO4Ecn5dJs
	UGSSzSFq7v5WVj6K5yeyo3tCyvSz1ACUNTrPk0+GMCNzirtLio0Tl71NClCQna4YUuiE1E
	P37/0YengemXiUh+iwPkI+a8eUjVF+o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tk1MbJSi;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761926103; a=rsa-sha256;
	cv=none;
	b=rAFzgNcaqdoOmrYyR0Mj6E1th3Rtg0OwYjEmr12ltlkSASoJ2PP/Dd32RHj1Gp2hbNnzcJ
	p51I1cDF3qCdLKxEmpjjQrMQbaJyZG/Kp2yBYytmKYVOgEvLs3M1vd/Pf/+DFrz3wR5AI7
	X7jRp/GHOjMSnJhAoyMcokLPhAUyz74=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1YuW+29GHdEUsg+9FOJ8KTvrdSMVL/8PjyFQElxGqX0=; b=Tk1MbJSiv/x79StZCcxscZu6sa
	yMTfayD0eZuSs8FxvQRZ07YpD25p01tqzeHaCsjFtxzwK2zoT5Gxgg2udG5vEcdShmaQkUeVafjRr
	cuJtybx6bzlBmG+PZ04nbPh40Gl1yeoQXd9kKLbmHJSQU4ub125JX4hFnoVB8ekjDL2cngO280gSo
	N/X9iDFjzMcfwbq47n1ilw7gGzuHUlQSJI/hCfvnyOjMjXNB0QB/lHft7/WfqtkGfd7XLz7/SGXti
	IvBU+HnQ0JpIAfauJquWPpxSXDSVMnROEenull6iVndRGFrjZDXddy3sEVJjWDzgVPNLe1QVqD453
	j8YxITrw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vErSq-00000001lIg-1zjo;
	Fri, 31 Oct 2025 15:54:56 +0000
Date: Fri, 31 Oct 2025 15:54:56 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	libaokun@huaweicloud.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, surenb@google.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz,
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQTb0NdyN3tU50ss@casper.infradead.org>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64DB54000D
X-Stat-Signature: zrwc1af4zyhcdixpcucpkf7sdxuwajfj
X-Rspam-User: 
X-HE-Tag: 1761926102-190381
X-HE-Meta: U2FsdGVkX19IQxSFwuIZH2sBCykER7THmXY0hs4cmr0fI3bnm6TtTWQpVRPOpUSb25zX2brK0/9/0ISscTa3RA/flir54oGNxGd8nz5CBLTyJx7TVgbtIS0HBSY5nDq/3g2Dr8g9BODzchwBFwNKTHAcgM/kYfaR/qcda8BLUM/KHF/nMCYJKLosvRhr+xVUGxsuoOPqVk983H59F+6IJK5q3G4pHNAaRoGcE/RESqAfJx2uhGXSYrCbOj+DLqhG0I6CXyUxkTi8h/WFOaNGBV+KKGqwXtmNJ2qM2YkM+A3FHHFqtelGDCixUidH0V6OMoePopRaoxaUeUdlsICTR3mOxIq+qsiHnrpha5sm0OXIIUX3oNOeKXxYWcXtIt4CY89TWrCIxYjZdMP+QSTlU7sV71c5l2On3U0OOnNpBte/MlLGO+vFU26vaUpU+tckB3RV2u5h1eeteZz39X5LzxwegNlkLEc8Ufh2YuDEhnpDhQ9TVyY7wKrnKKXJap1WzPvm+tIghPRzLWc1aRqDbszqJw9nevX5jYPw+zAM5xo/mO2js83UPXg6nl/Tzd5VToh25Cc8mcwm3VIqdcLLq9C0OP4NxBMoUXDVE6/YmopJi94Bb88ipGwlJ3PXn4SpCPmmorWG7LgUookBsXOzes0oSeYyDAyrRQy71EwHBVoT8qvEMwl/Ss9odWeK2ez9WbKfmeUma5A2fS8PDZ0WxwKkMI8BIAH7s4xjmAeM31LqdSaykhk8yAMhj8qmtAtIA9gzb5JeTsaTPLt+KNrZfOC5aV6jaie5agfHBVuTusoGPdljm1dMSDQbwWTvhogP5ycXxQ8KHGYVrho5qYwejCMqEsrhRznwvSDH1frthRL9IOo4hv3DuOUz35KE5zMzVy2rd/DsDK7EFF+jNTsBiwH2CBPraE/Q1JJ8LQ8liKCQi+iVji3dY7liVaoxrkm8L9smsXjpbN5pSP2X7p/
 X8zKyiSR
 mtNzLPLJVQsk2YPc9koJBmbuIb0Oj+pJUTwPsS9yBVNdpFyrz09EwKTUIuvIGAL6jzwAH0m4TIcbu9d0vWd3Ihv/OA5rTyWZaA+JVEelNWfN21RGTrX30dtMOXEceaEq7WUluSMtTuSoRnWP5wmHGV8eNKej4l/0I3xzyIh/1+NO7VoEq4Xvh3Q6NfKxtBEKoQOZ94ChlS6UopfBa7JEpOLU6iNrc/4SNEl7Zifqib6KSlqdrTD9BpnDiOb2IbQpDoVJ3GRRtRB4JuzW5kXz/1PpLnoAXkA9L/uBBa2NTSlww1JA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 08:52:49AM -0700, Shakeel Butt wrote:
> After reading the background link, it seems like the actual allocation
> will be NOFS + NOFAIL + higher_order. With NOFS, current reclaim can not
> really reclaim any file memory (page cache). However I wonder with the
> writeback gone from reclaim path, should we allow reclaiming clean file
> pages even for NOFS context (need some digging).

I thought that was true yesterday morning, but I read the code and it isn't.

Look at where may_enter_fs() is called from.  It's only for folios which
are either marked dirty or writeback.

