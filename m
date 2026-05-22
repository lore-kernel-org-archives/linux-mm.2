Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BE9CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05C76B0095; Thu, 21 May 2026 21:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD346B0096; Thu, 21 May 2026 21:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A7E6B0098; Thu, 21 May 2026 21:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3B086B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:53:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 656814081F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:53:32 +0000 (UTC)
X-FDA: 84793383864.25.5852A94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CCC0DC0002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:53:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlDcV8Xb;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779414810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTPFl6TPAkk+ECSMpS4uYTfEhV6l49Ocas0GPmgCNN4=;
	b=WTAlTrtx7sK2HFp0sgUuK7gLkK+8YD12SM6o4hgWnKVpKCJnRXNRXnnwGIFG8aV32wkmd7
	FUGHSKcMP5u8kCeIaHU8pcHLu7ptnkGU43G49k6Em8sTB1B98GJVkjKfHSeT1cs3EdEbe9
	UMghhNZn3aW0J1KmfE/FkfqTWk+xcSc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlDcV8Xb;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779414810; a=rsa-sha256;
	cv=none;
	b=2G8HYYGPyXBg+AONF1WX6C0bCGcZaD318AAhTE3yn85U8sctzHuXHOxTGGM/CwaTDhZyGh
	rD5lYGszV3xqFM4A+72MP+1ooHcAmk6TSI9Ss91ZtgImkd7gPW8+v4cZwZw/qZCBcIS+0x
	xU4G1r6Bg7VGUwAZSIe4Q2TaTeWIErk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 539A460136;
	Fri, 22 May 2026 01:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459B21F000E9;
	Fri, 22 May 2026 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779414810;
	bh=OTPFl6TPAkk+ECSMpS4uYTfEhV6l49Ocas0GPmgCNN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlDcV8Xb2WVEDHQxZX90yxf5k5vjYi+ACkSmyc4kZvYjhZ4aFQakenflseXWyUpAD
	 Jm2oXFzLPDkxqV8nFylSypHGP9ses+JRh3WqlFOIV/bII7sTjufPQC4SujEmK7rRmr
	 WJdWhQryLX2NyfZVyC/33XAAyLpGUOItb+NKojKaalJHd9EpUNrBrGjTvv6netwWjp
	 DVByyJkAXh7hh9CVj1bXxDKhPv9TjBB4zoAdx116sqLv+Vr2DlT9m8VaDgWJCL5xoZ
	 ahnhqezOmGq5ddr9SqGrsolTEsFW8yYTepCYYge0OeIkFNZNxpXMqLIYIEi/W30q4o
	 BZx+16Ht8rxcQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RESEND 0/3] mm/damon: reposting three reviewed patches
Date: Thu, 21 May 2026 18:53:21 -0700
Message-ID: <20260522015321.86261-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521175753.3c6369dd3fdb52ea3816ff2b@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hxzkei9qef47mt4zu136q17nr61arq1o
X-Rspamd-Queue-Id: CCC0DC0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779414810-744908
X-HE-Meta: U2FsdGVkX18PXM+fgiAC8B78coK+MksmCdm8RbpVQajQwFJVHAgDooaDwDRE3YUBNGD5uVQUO3xOM1VkIp43IV38H+wwCBMoMRo2rXwkrmNQDnwJCrP1bfukp+WnIeJ9n2+T8BrT+fvheP73II5KNN0cTs2raYr3D5X1Uv0BD2m+/BY8WrYcELqAHwe3qyJepnFs6clcbYd9AYgNhBw2Cs4+33dfscHamyalHSlHGcZmdywBC3Doum8mrIQA6lEsrlpzRtpuDyd6GnRYA//4LhUrzTONljQiZpPYSV7GSC3Ikd9v2WESApDor0uTXgLgXh6+60CQzbinsACuXwiyUa8XKrXMSyHl+D9hMrHcwWZT14iKsDT/sy3jkWBJNy14ytR+9n8wesYYDPBpUmTh/epREFDvA2ZAMsmpKwq6oOSUyIHmOpZONmTcreJuA4aX41A3bUJkJeIJD3Xqk1TX0lejaExbRF3aGPBRewJZosb5D5gX5HaVjIWea7W7T3EpFxzqGAA0cNOsGcciAk4b/T3QFkqlFgzUyvoE5DAzQ6yzZ6z1X4GlTpiko7eFoFYEKPv/mprdnVDLTUFC9HKQ23ZEhdLEK9A1dFDF2phWZU8DTR0sDQmNU4FQ4JCDKwnHu0QCuJ4NyKpEb1i8T4TE+sXBsi+vU/djoGT56UB2m9envDL6/rBM8L8ALKa3WXTHVyJzT8mxFk3p72kTCZzxA5BWirwaafbdvXnJ8tBUpcpOH+RPZR3J6SFC2kNtquN7SN0UdvWeyJrBUZjwhLgaiONMPbcmH3GEdAPsLq1kOhbDg5BbkFv7Fr80OIOWl67CjG6zb7oqI7ReOJCUKLYWnRlnzPEimCxlzBJdJnH3ggpRg79Fl/Z1u2/1tO5yEQB62FNNAL4f0AksTyyNIb094WPpAd14iw5QAv4Swnf9OMnEMcnB7peS6tqGO+TOnSP8jMwlmD03DxCOqUkPszv
 xzkPu/pB
 RYyqxjFBQiGL9LEU7NpVvl8Dq0BDByDGYeh4YHr3vqMR2Cgpt+f16QdGNgq/s4DdLWsvRcGlMkxRsU83MFhrsVQGiLDzi7B8pP0L30NL2+Z3Q6KEcifaOlUNyeVfT6fDHwxyK2AdDb1l4evD84FClCogqnTwQzt6ENr36p4ys1XFgBwaKIZh5dds8x4C/yib3T0JsnpPYaJ+XxOAr9wpleycxfy9pWQS3zdZEU2zKzTH0+PSeNNVAr4nRQssErH+9HU7tkbx1Dcp4qiZwxRh9ORzsyLN7QNEQ0tuV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 17:57:53 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 19 May 2026 18:20:58 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Subject: [PATCH RESEND 0/3] mm/damon: reposting three reviewed patches
> > 
> > ...
> >
> > This series reposts patches that were reviewed by the DAMON maintainer
> > but not yet added to mm-new, for more visibility.  From their last
> > posted versions, only minor changes including commit subject update,
> > Reviewed-by: and Acked-by: tags collection, and rebasing to latest
> > mm-new were made by the DAMON maintainer.
> 
> fwiw, I don't think the Subject or the text are appropriate/useful for
> the long-term upstream kernel record.  It's all short-term
> development-time info which is best kept below the "---" separator and
> discarded for the permanent record.

I agree.  I was also wondering what subject and commit message should be given
here, because the original authors didn't meant to send these as one series.
So I was assuming you may simply drop the cover letter and made this ridiculous
one.

> 
> I rewrote the Subject: to "mm/damon: documentation and comment fixes"
> and left the [0/N] cover-leter empty.

This makes sense and seems better to me.  I will do similar in future.


Thanks,
SJ

