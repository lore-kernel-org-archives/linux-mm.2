Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B240E909BD
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EF96B0005; Tue, 17 Feb 2026 10:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC996B0089; Tue, 17 Feb 2026 10:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE576B008A; Tue, 17 Feb 2026 10:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7C3B6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:00:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CAF71B3E66
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:00:30 +0000 (UTC)
X-FDA: 84454259820.25.094E8EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6681E100005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:00:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khSwFnha;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771340428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpJaCG6rgR+dtwhMZIdMvWIEcTcpriQt0GeVUMEmuns=;
	b=VvyjTBQEs5lIOsn/3/lJzIp0adh/yL0N38Q9I+UBp5g9lYYXDUppbUqYhbHTRQ4WblrzkH
	bmwsPKBC/B9BTKm99E/dem6rZpcOs5TyCx2RDgRdLhMA4eyK3JSY5WHdzX4PCUMetD12vD
	7Raukui0lKicJzU0X0dUpajYmnYVuIY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khSwFnha;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771340428; a=rsa-sha256;
	cv=none;
	b=1H6o+JMYbcv6+dzEmP+SP3U0ZYtLOx3k7o8pwMrkoKeRjA0JBK6ZlFaoQi2bm5MkmIRZf3
	748Bg44bSNZeKucDLIopuAuZnmP69iyOyEqmXCuXK0s3boJcmsRXA5fnK/qba9DBWmfm1M
	w0NgWy+0NvdzuC7PScdT7FKJg9RbFOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92A1560128;
	Tue, 17 Feb 2026 15:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F859C4CEF7;
	Tue, 17 Feb 2026 15:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771340427;
	bh=mYlEGTrnI5a+ac/YZf3DtKWdXwxsXj53TyqIoLRWIzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=khSwFnhaKqZ5o63eBjO0BzLXJRawh6pmStxVUPeTAIXZZlhUpuP+8YcjmjMN29hPl
	 Yl7K5CpRYSFIKjMqvNFAcQcLM3JtyH3v47JGgKix7BLh+AweL9xdx8A7YfagpEWPcy
	 WPZ8gldWsd1HAUchXt4wKOvRtrVLQWTuES1Friu7VhYqjPclFcwkCSCTF4ferGwzdl
	 y/On8mjRubMqmu5d9CDhKQOYznD33kNE/LYRTBUF9GANF2jwzhhXaqd5DB7fsREcCQ
	 fKFSsLE0u6XfBm+URlTQtKijNecsKbEBg6Ncw3myuhC3nkzklTRSO9p2lfVYcYaFXT
	 rj4ICINQ3lyBw==
Date: Tue, 17 Feb 2026 15:00:22 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, Jisheng Zhang <jszhang@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZSChrCVnoWSe7h0@willie-the-truck>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
 <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
 <aZRyzy0SJ8uF3K2J@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRyzy0SJ8uF3K2J@arm.com>
X-Stat-Signature: 6ztpras3ou6wo1wwzczma1itry4ddta6
X-Rspam-User: 
X-Rspamd-Queue-Id: 6681E100005
X-Rspamd-Server: rspam01
X-HE-Tag: 1771340428-373149
X-HE-Meta: U2FsdGVkX19V6F3uOtcjr/Ifd7RCeaPSsCeB3evYNUPVxcErU3w8Ctgz7Mu+6iMyOKTFTkcU/yXcQaFfehwpop1lz9WQ9wEc6zHnZciu4JifkCKxs7Ykmfyy+dljQ04uDV78FVdF8shVAP5r+jSVUM/B2VAkdqz4sUSRpRx0PqL8K3NgN6f6DFBcJR4LjNNfiQwtchLqTR4G+wviqKBVVo8CBzOBN2Qu2rZF7kQtXx2+ZLsbFsphILIhSgC0W4Hsf5pecLmEqLtzq+EKB5aGO+wiRfaoOYcjk0QCTMrV4vquX24zmzdxbQ4DzrBTDbdCSYo/2y1wvfcrNl4SooY8fzSfffnxxFv65rTxCECEpn7o7r1eaFtQiBeFBg6nUnoDEF0ZgisbtuUEOw33lPjj1UGxIZ+Xxfc2Hd/yhGFw+ZqjANIJSES4zZv6xHiULGdQjvLuw1/H7rdTrQKtykPSyUuME/ItWn8kqwtn9Zw2FgDBxhHAFgVh5130lFInJWJozadN6U+7EWC5N0vm0E4oqOHXEjNGvPvamgQksOVy8wjf1SDEcd9NS6G744vzOtDwV8S/7PsfFCObgSIvlrCYSGjoUJK980EBqU7jJKqXe1NA1qaF08pKR8jS193HrjkwIbhYTJWvwts6ULfX1+gZsqRLUsdJwPT6ieqTvlRqvvTg6LeuDXVANiobyQL8MyftUo3K4KVebgqMvTW4TqgBeg8DJU1sRoe7+oVBIn+Y+HdrURenAzMbsc2Wl7j6gWWCGPmsfMXSzf1hGstYsBfOv8o/eNnUcVI7jU1vQdOdOCs/95YaBfw8oGpPu00rG1U+wsZhcEVvUx8wsIGDNQKe0K0bua7Z+TLL6tIvRRuO1GNgVAjjO2JQefupL2p18LmLEETkVoBt2JDeilwmqlgeRpDCZ1TEu0OBTwGe5xt65b3ALxn2qdN1EYg4xzWdrBDNsai4aPPCptNtlstAx+U
 7I0qUgkS
 pWmz8MkISoXk6OmMdyVFo4mGQicLUbHcoFn23QA34tBJ5d1b/bVPSTrwPg8fs4lK0RD5JkzIIcZAUwmTvEBoj+SGTeiXsbOltk5TPNQnaEiufdLjDuVIEUVpHC4uJw2iesKSnICJ4uzwn4VO0iIWZM/Q3jzNHejVD4PuKo6XBB64y9SctgoWSg0DgPypLLjPxZelSzHsC6/dLUHykfUZQjRjeWLO2gmHtMJ7EeckHurAdIoD9xFPTX52li90X12AXFUKKZhR6NRMfUeuvrMkzy2CfxVv0YMjcsPR3BDvjW+K9hnF41T55do4FKJ7PyKTxlBc1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 01:53:19PM +0000, Catalin Marinas wrote:
> On Mon, Feb 16, 2026 at 08:59:17PM +0530, Dev Jain wrote:
> > On 16/02/26 4:30 pm, Will Deacon wrote:
> > > On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
> > >> It turns out the generic disable/enable irq this_cpu_cmpxchg
> > >> implementation is faster than LL/SC or lse implementation. Remove
> > >> HAVE_CMPXCHG_LOCAL for better performance on arm64.
> > >>
> > >> Tested on Quad 1.9GHZ CA55 platform:
> > >> average mod_node_page_state() cost decreases from 167ns to 103ns
> > >> the spawn (30 duration) benchmark in unixbench is improved
> > >> from 147494 lps to 150561 lps, improved by 2.1%
> > >>
> > >> Tested on Quad 2.1GHZ CA73 platform:
> > >> average mod_node_page_state() cost decreases from 113ns to 85ns
> > >> the spawn (30 duration) benchmark in unixbench is improved
> > >> from 209844 lps to 212581 lps, improved by 1.3%
> > >>
> > >> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > >> ---
> > >>  arch/arm64/Kconfig              |  1 -
> > >>  arch/arm64/include/asm/percpu.h | 24 ------------------------
> > >>  2 files changed, 25 deletions(-)
> > > That is _entirely_ dependent on the system, so this isn't the right
> > > approach. I also don't think it's something we particularly want to
> > > micro-optimise to accomodate systems that suck at atomics.
> > 
> > Hi Will,
> > 
> > As I mention in the other email, the suspect is not the atomics, but
> > preempt_disable(). On Apple M3, the regression reported in [1] resolves
> > by removing preempt_disable/enable in _pcp_protect_return. To prove
> > this another way, I disabled CONFIG_ARM64_HAS_LSE_ATOMICS and the
> > regression worsened, indicating that at least on Apple M3 the
> > atomics are faster.
> 
> Then why don't we replace the preempt disabling with local_irq_save()
> in the arm64 code and still use the LSE atomics?

Even better, work on making preempt_disable() faster as it's used in many
other places. Of course, if people want to hack the .config, they could
also change the preemption mode...

Will

