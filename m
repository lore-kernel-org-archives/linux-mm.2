Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EE8CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B258E0039; Wed, 15 Oct 2025 13:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315368E0005; Wed, 15 Oct 2025 13:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC558E0039; Wed, 15 Oct 2025 13:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0666B8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:45:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB91157993
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:45:35 +0000 (UTC)
X-FDA: 84001075830.23.E81E470
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 43A6F40004
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:45:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/RcjmU6";
	spf=pass (imf11.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760550334; a=rsa-sha256;
	cv=none;
	b=uNWHc97QjcTosCfbZO13agYJiUaK4zMh3F590aa/CJDKe2IYFJFK5m6hw2/w4hLPRmQxHt
	Bx0n1p4++8Yv0kQh1ZiENgs7/A6G0nFpkz/31VB2VrLBR1qD02Cm5weHdStgw33orZ1lSP
	RYSl4ID6/tl9OF0JmfOiAx41esPeEeQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/RcjmU6";
	spf=pass (imf11.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760550334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftsgM9krkWX3hc8pdKD/oN/06fggfRTGrbdbktcHwi0=;
	b=0cs9AusNDoqV2A6Y91KiVegyt8f6Hfwkiye5Wrt6b2pVhSA3zxk0J4c5hs2C7nFgUTdQDD
	lMgPFtOxZESmtBJkNbEV59TELhK2M6ag/Ysc9UGRO+EIDU9RlCG0A8R/KvJNTmt5rTUJr1
	cEK1IqZhYUdfOLIYR378KCyWGGiJeLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 519B7626F4;
	Wed, 15 Oct 2025 17:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4E7C4CEF9;
	Wed, 15 Oct 2025 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760550333;
	bh=5VHnaFTpOmXDgy5oJBc19Z3MpdZcEDhISNLaPukOCR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N/RcjmU6U3xHv5IG9fAqgE5OPWOpFIbVfHky25FpJ8LpZf0sj/n8MBAWJjmY2IA7B
	 H8qTdkyrCxoB5YIWqYSRJVYZ/yNMkLKjYX3B3sjDkmJQJSTxe/j6aYMZWImzVV5yPF
	 A1OjnK88AxE20+Ydhq8DRdmxsSqfVQZ8aSGyhtH3btSKu7vdjbrucVQzn6smzG5NG0
	 0PsUVhvDy/qIyUZj/ECYPzKHJ4Rg4OGT8I7ocb+WaebWlkw5GEK0c6eVJD1ZvJdkVo
	 5Op+W7Udwe4joTth8Hm8AjfUk37XsOMON87ZCHNDCL7dkzBfbzrLXsVoXoif9+XJUA
	 Rj8QJij0Ugn0A==
Date: Wed, 15 Oct 2025 10:45:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <20251015174532.GB6188@frogsfrogsfrogs>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <d2b367ae-b339-429b-a5e7-1d179cfa0695@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2b367ae-b339-429b-a5e7-1d179cfa0695@app.fastmail.com>
X-Rspam-User: 
X-Stat-Signature: bogg9jfq8oc5dynk6kpcib1exsxd66t1
X-Rspamd-Queue-Id: 43A6F40004
X-Rspamd-Server: rspam09
X-HE-Tag: 1760550334-489386
X-HE-Meta: U2FsdGVkX1+fcWm/RFhLHcMyEFc4POBUTLsXX1lBem9zAjf2aar9Mi+5sQSP89UX+wWGXsb1XUmMbzCuC/F/j+/WtZ7JqGsiID4NQ/4vxWEnu56VBdgEkZmOwNfv5zm80lfKUOzhCKSLI1z74L8vilCi9ZuMcAJrpWPn2/Pbo3bubBIBNr9IUj79lUdu9+IuW/UTC1DdYebMyMgN5Ikc98e43I+dXeWtm0FOb+aWU4k+Zxe8hYRBfOE1f8LoXyT9BFw7d1m8SJEvm2suBWI2ko5SdtrHOnNiAq5bHZyznx8x+ioR3pRGbG14JcJcsPHtWeXPYHfwpvin4qPQVf0wv7RVZp7ULw0oqpZIVFmqCy7ZSC4lsDIhXl+kbIbZHF9YJbCTxlhKajv1WnEkDPriiQh/XEF+EfIMc/j17Me41Q9zUCg3C9cURAHDgkyIL9koBRuYpuzcXTZOqs0UCk0Cor9d2YTaEP9QPEuO7YlNT0TZ/Oo990RdO7GcyxfnxPB3ZaQqEsFlNg7PvbMUYAghoe4VHD56tO4KubldNVoFuevE/Fy4uv0lzc6l1fcrqvJukynCVwppg2itUbLQbUj2h/5a+BGtqS4IOen3SAq6J8vfFEAYnQnkn35ZJcdfqrlYUV4Y0filVINF8yfq3gvchPgNKL4wp+j4KP87GKo2bTHQ/K3EX3oMlbRraQO8t6GhE2iLhT/GqBpF0XMB+Voysr9xenWqOzLIgoQB53nrE/jtnkGWiQUMoaXO2EnOMrCtCP+pKGssIWtUQNpyzOGBxKHoLO/vkmCPmmq4yLuwN5vOvag4/VjPfeq1Jh9buC2NAoRd8VdvhQszK9fPOc5m43Xly0wXL9CfQC78bxv2LxHIVAK1qXr+5ehNnQ3P7fVh+WszkVSYSyastkl0cQxzjqpW3A7V9c8fGEy6buzE6Dk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 08:39:53AM +0100, Kirill A. Shutemov wrote:
> On Tue, Oct 14, 2025, at 18:52, Darrick J. Wong wrote:
> > Did your testing also demonstrate this regression?
> 
> I have not reproduced the issue yet.
> 
> Could you check if this patch makes a difference:
> 
> https://gist.github.com/kiryl/a2c71057bec332240216cc425aca791a

Yes, it does make the test failure go away:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 alder-mtr00 6.18.0-rc1-xfsx #rc1 SMP PREEMPT_DYNAMIC Wed Oct 15 10:34:11 PDT 2025
MKFS_OPTIONS  -- -f -b size=8192, /dev/sdf
MOUNT_OPTIONS -- -o uquota,gquota,pquota, /dev/sdf /opt

generic/749        9s
Ran: generic/749
Passed all 1 tests

Is it valid to i_size_read() in the two places you add them?  I /think/
the folio is locked in the filemap.c hunk.  I'm not as sure about the
finish_fault changes.  If the EOF folio's locked then I think it's the
case that anything trying to change the file size will block until the
folio lock drops.

<shrug> Thanks for your help, in any case :)

--D

> -- 
> Kiryl Shutsemau / Kirill A. Shutemov
> 

