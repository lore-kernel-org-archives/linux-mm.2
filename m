Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5902B606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=npuiu8Zb
Received: by kanga.kvack.org (Postfix)
	id 642DF6B06A4; Wed, 21 Oct 2026 06:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6197B6B06A6; Wed, 21 Oct 2026 06:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D0F6B06A7; Wed, 21 Oct 2026 06:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2F76B06A4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:30:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AA2640516
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:30:13 +0000 (UTC)
X-FDA: 85346263506.23.7D65E39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3CA0120003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:30:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npuiu8Zb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792578611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8edK1Xi3fKqCs4MYZhDfH0qfLfRnuuhcmFNKoFIYOo=;
	b=nVTT+czAOLsXWiJAetL0udmfAtYZ7XXp2NLPm5kF2xJJ4nXwup+T2vAz3BRSHzDI0+jl2J
	Yfr6wWN7vzlv31MUHBF9j0zwL2/TrWLxAES3Hj8x/JOi0MxgtbXsj07dNNGgLDR0jkRzAP
	ER5UtuAk9U3/Z2GPnmel2MtBs8J4XB0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npuiu8Zb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792578611;
	b=nZF33+JTPHuCCXe/lI8vwyK+4BsN7qHQLdbRtsu+l5qCdUJJvxUYVX+5AIDgEGKwi2gz3d
	r1wVq6YvWxTKUssQnfqUzVUhg+nxXYowKwcaVAqya5TVbwbo9iPPivMcR38WBpwP1Y4w6O
	FLlGa+aLqwXBoZpcwWBOoT65Px0dUJI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11F40409BF;
	Wed, 21 Oct 2026 10:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4551F000C9;
	Wed, 21 Oct 2026 10:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792578611;
	bh=W8edK1Xi3fKqCs4MYZhDfH0qfLfRnuuhcmFNKoFIYOo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=npuiu8ZbeBCUB/eaT8kTlOj1JSGVuD1Q5Ur9utmedIlIQT3szI/SXajQtD3/uHyT3
	 DJd+HVY81WggR4V3GJFqpqyOuY4XR1jRNpoeWBzl0HyWGHrSvvXjYPyzuGZRAqXkAJ
	 uyHKANHt9lEYXkUvWnaCzLsl9VKnFSf0Y2VRfaQR7vodyWcURKZal7WsfZVZypDndN
	 X8aHo+JfJLy8wibOUWQDtrCERvZSYWQeWvFcu72V7ZBK3SJbDOlDiRk9YLCHiWo7Oe
	 2OFSLIAJ03m82FVRDQReWcb/QCYt5JLQ0SIUUp/bImQKUx1s6Dr0t7YPZCh/fg0uSp
	 A4xGFCSnCmRcg==
From: Christian Brauner <brauner@kernel.org>
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
 Liz Fong-Jones <lizf@honeycomb.io>
Cc: "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 ian@honeycomb.io
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
References: <20261017040710.1174009-1-lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out
 of syncs
Message-Id: <20261021-vagabunden-nullrunde-torpedieren-3b864a09e824@brauner>
Date: Wed, 21 Oct 2026 12:30:04 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=894; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xGvdJTJPwUrQmbSvbQg+cAG6DSz9S/AsFgM5IJB+gjs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdmKJXxrVq1n6OYnX2mKsvpjDdFwwLLlq35NWC6AOJT
 fveMypqdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk+VuG/6Gb37zOnN0mWL/0
 XJGR0PKmnT9nKlsv8klYFPGfSbkl1omRYVlMl4rpxYMB/NtDU3k+87kY7hf0Et33J03/t+25Q4u
 dmAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 3CA0120003
X-Stat-Signature: djiqm9cdmw47tqb6khbbk48g5bnp8hmq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792578612-140434
X-HE-Meta: U2FsdGVkX1/xHW6S1Tl52b97d2VwFaxJ0Qs2UhwCQk/dChdqS+S86ciRtC5QTM2ruYH+OlOG34qGczc+s5Ww4H/ZRspDAlxuARFktkM7KHBByBeAAQnywesQGSkLveor17sAcW/63jS7YB5OR9wbsaToU3MYD8A+TcaNLCYUDxNiaYQ1Rc0cTSBOOV3ylT10zac+dx+K9KqFyIO5Ksc+/vd7vMFlR6Ldsi/HWn95HTstaDtrLypIgmorybVhpz6/A/yfL38h8bAX8g3ygIurInnd6kjbm48ucS1AZjcFSFFY7vuuT0yoP/lAmn0ON70lnwJRABuxCPhooCe/4q3Ck8o1bCNH7RItWWxFgIcxP530uo5KYqp+nlOepwyrADSEokgV2Mf1WuLSp5LrH8X18+HGHmwC8KfC53bfRsN/e7VuuLKsqFgQAuiLBF6livJgdBwqBFxWHsmujSS8xWF3h1kwjwDPp3geZJHKVYvnQSD/I4ZqzkmNw+lSEBJ9pj10+12H15XKOrSUgVlztgKNiYPj9UfwSym3rCNMDVhSsZOMUvuN4w0T9mrso/CP9U2HSlL2WtIGDVS5Oa1x6KM5VdqBv4H6rUQaUr22xWq5JJVzuvflehEnHi4ocbA5DjS1H/bJ95pNjpBz4Jg4lnCbVYyZt1+Q0liROI9mpUSkUIPffNok2zhcrhpxnhtB3d/aV+bLzycMBysrvoqVKwImLp308uf4R363BD0EyDOzAFEa0CXs20BGyi17l7a0AB+bSRZn/nzc2ckJAsPowThY+lq8pAppqrNgcCn/bA0mqBqMPbIO26MtsVXSzfVZGzGbrpZJfVts6GdBpLg4eCOZFl2KBb0z6wuuNTYghV6z8xfqBV9l6s2SPn692+PNZoFoomrVcXVkJtRcdnNJMaK1AkxGdLbVGDlKZ+FTAijgl2ke8LNvcmJhaFssu02s2mlo1zJSszksIFR/mZomSZ6
 C5puCX8r
 a66qJNk25XrxQqckNMbYmp9oS0bd2pMISAbaAka55OV0my/tKOsMgGLDj6X1gxL8nPZ8faufsIphZp4x1yJi9/zY+snYoewnbcTuOwaa+IIQwbe1188+dISBEQgFnLKn0TJMotwkDIAlPJ6PpC9UJEu+zMi4O6AyRgbQIX0HjZjTK8AcO5gB7JdR+MdZTwb1B9/toq19nyGaxQzKDc96Fvw6Ub7BG9c+UKALnSCaYQX6eQrGaWq78WcJrpAk/gFkePaq1aX8/S49Gi3dPU5c1kMnMXuJfVouWV5b4Bi015mEvR+DciXvZ2TRuFtlY4ECCD22DzmrxJVkVay9TG7jRBAtEycMf8C7kr1kC9nz5XreZo+z9T1dv3MWctdhHGfpUg5R3I46gbVwh0AxBub2nuYDoZoRyVYVhrpyj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 17 Oct 2026 04:07:11 +0000, Liz Fong-Jones wrote:
> writeback: keep cleanup_offline_cgwb()'s scan out of syncs

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
      https://git.kernel.org/vfs/vfs/c/056b35228fad


