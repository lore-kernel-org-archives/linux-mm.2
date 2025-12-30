Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67769E92722
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 03:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE066B0088; Mon, 29 Dec 2025 22:45:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B5E6B0089; Mon, 29 Dec 2025 22:45:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797406B008A; Mon, 29 Dec 2025 22:45:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68ABB6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 22:45:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D61355EAEF
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:45:27 +0000 (UTC)
X-FDA: 84274747494.20.F870384
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F8AD1C0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:45:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pkyu2x1y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767066326; a=rsa-sha256;
	cv=none;
	b=la8YLAd7RktU7EPbFpu8cQoVzrmeWROjXnM0vVCYZkTyyUVPT1uhOGxNmoY+0zga3P5TDG
	63Kzx4Gtg7ACDKs8TgfHP0R9qB3bLJRbxhtBIa7oIteY66e4tNb/vNqRLzOSCIvYy0NY/+
	27EZwf1Eb6kDQOuthqnGJmyAVjvUzoo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pkyu2x1y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767066326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGp3Bm+rKhLvcibGU2NW97+oqzSfeITpi3OLxq27JNo=;
	b=LdrEh7MtHyCV94HKq3YxS7bNpMZuyszeI2L+1PU5Smc3EmIMLBliVy73KIley3TBK5jGD/
	Fk/dORHSYQJZtmFCtOX2CvhxvRZclGn43GkYSkD70GXZQ6cQpOIySOW4biKV6+G0RhLT8C
	SdQ7NiYNRBU0tIIz9XJc/98luYFYGHU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E0246000A;
	Tue, 30 Dec 2025 03:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F02DC4CEFB;
	Tue, 30 Dec 2025 03:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767066325;
	bh=7hTn6XLuotVM0ay7KF0gp/Y77dKrAK/9QRLqPA4o/Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pkyu2x1yY9ChEhz+A4uqDHEzEsGSRK9WjQecxK+ot1Vv8kvrDikE1/PzUq8kPtOMj
	 MAE5AA4UPEtxFHCevYUprh32lc/34a6Ss1S6ZU2daY/gIHSVq7SgtAoe5kA6QoCb2M
	 SJfGy51DO4zPdPl5twfcpPcI06Q9OsUeOnZER5yvv6d/lvmo4s/eGjZ4ce8p16fluq
	 a2R4tiBycE3ekeAJoum69QIx67GLz82TuSH6TuzveCQQ5JsqNyWPhnHDBDw6+QGtKl
	 EW4VOzBGHZnzm1OARpZ8yZsVcpciM8ofoBI7g5zLPSOSspMRMZDfe+sppChQrBk9eJ
	 v5pVAM9vCXOdw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	JaeJoon Jung <rgbi3307@gmail.com>
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
Date: Mon, 29 Dec 2025 19:45:14 -0800
Message-ID: <20251230034516.48129-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251230024129.47591-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F8AD1C0005
X-Rspamd-Server: rspam03
X-Stat-Signature: r7co4jigux8hpbhmauq5srcza4yoj6y6
X-Rspam-User: 
X-HE-Tag: 1767066326-741355
X-HE-Meta: U2FsdGVkX184VlGrqpkJKNeSKBS5wC53UKGkuL9HXih19QEZ3FAsnsoQE7aRq9/FgnOwyU/QOzbWG2af+2O8ISYWFu/5GYczUczIllkw6UJdkvT/VHlUerxuF6WfIXBSeVL6sb1BlEf3VlNG2JSV3f2Eyy8PZL/oAMgDP9YUAFr/ashyxlVEXfHeev3JkFSN3ypDZjqcf3nrZL4LA4a4LQuEmuWccfY0c3P62Q2Nm1AVBmkKlokwf6RVdmKSzGEk/T7fWrBvEhnJ0cA+VIjGTE0mHdv/h9HlxH+eYJ+CgJmaHRpJInt9eTAOclzqJFS+Ouii24p/ga186UAkIHG2NDxH1m2KAjJb494ogQUlNAIGBRBe8wbWJGiOSWyyrki4pui0K7LVp/sDg9JfI8TTpWkEvFqn8eTGazQhZz1Umn4LHSwSZs/LEZgjC8MyKeWYcLJv+6V2ab+wLPdt1GlvyUzrnDb7Ybi6trPWBCrAs2XvNd+pmXik99LLPcNqETJhC2RtqzGL6FbfIbua/vtmvO3DPasg/154SHcbCl9rL8/udfx2BPSCHmNO+0oJt0RfO39hbgB1k1N+Wrrnwe+zeb086Rn9u/DiVskfYEvhpqRWU7o2Il0XgBJh/hDaG0fr4EeqzfNhUpn9/XhrbNig5KSUKvFXwA+EVdc+fJ95YzGXwTArZrqKe1WW06GSfY7ek8NnAGO8f6+lMxwsvHLdVjXk7GZXgaMOcU9sNwjrf9x05FCSKOS0TG6odoJ+8GO5xqyUsj2LtJx7/SkqOgENnk8VxTWsgX+xDPzzag4sjkw0ZMWnFkGudMEnUOzQFiN0PguAi/hVx7TsSaFgRHl5ZovXoI1pPGRrsD30hc4L3f0vXIvnAJ10p0pHnM81vktcs6ZS5MAcfUrWJQ0Z4+eXeFgPrYSsyG11VRzN7pYSoJgSs2XevxHie80DySWL1QcV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 18:41:28 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> > 
[...]
> > I will send a new version of this fix soon.
> 
> So far, I got two fixup ideas.
> 
> The first one is keeping the current code as is, and additionally modifying
> kdamond_call() to protect all call_control object accesses under
> ctx->call_controls_lock protection.
> 
> The second one is reverting this patch, and doing the DAMON running status
> check before adding the damon_call_control object, but releasing the
> kdamond_lock after the object insertion is done.
> 
> I'm in favor of the second one at the moment, as it seems more simple.

I don't really like both approaches because those implicitly add locking rules.
If the first approach is taken, damon_call() callers should aware they should
not register callback functions that can hold call_controls_lock.  If the
second approach is taken, we should avoid holding kdamond_lock while holding
damon_call_control lock.  The second implicit rule seems easier to keep to me,
but I want to avoid that if possible.

The third idea I just got is, keeping this patch as is, and moving the final
kdamond_call() invocation to be made _before_ the ctx->kdamond reset.  That
removes the race condition between the final kdamond_call() and
damon_call_handle_inactive_ctx(), without introducing new locking rules.


Thanks,
SJ

[...]

