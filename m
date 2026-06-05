Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BDD2CD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BCD26B009E; Fri,  5 Jun 2026 09:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E1A6B00A0; Fri,  5 Jun 2026 09:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D4C6B00A1; Fri,  5 Jun 2026 09:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 223196B009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:38:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DADCD1602C5
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:38:37 +0000 (UTC)
X-FDA: 84845963874.19.9D061C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECA6FA0012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:38:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oO9GB7o9;
	spf=pass (imf25.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780666715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfGnNvqCUgib40545imCPSY/SiAip+ywc+XcFOxOI1I=;
	b=ZBbdvcHgUEe64tXdae2FGoTtMI8VPKP+Ps0tc34nbavJnZKsGtb3fln0J3M1u9YSg4MNOO
	Z7ybjGPX1gIING7SWdEmr4XAEETiT015vwb8selVLZi7Nyd2hI5Bp63oTfr4eQdlp1DSdW
	TolKHS0A6dohcmAXxoIGF2loYVV/aM8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oO9GB7o9;
	spf=pass (imf25.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780666716;
	b=jdBMc6nZHfcs0aQ5yd77ToQWbycZ3/raJWNolQyIRbiCp3NPxbiekoAHSixc7FMDsJVlRl
	/u2hcDYHpVmrJpS9oclaitI2y65WTz97ll+9i7hrReudKRKXOJzm+xIQ/2/ddqVxwF34fF
	ZzTWqQyhF2sYCfpkloq0XCdDZ8NgWG4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75280601FE;
	Fri,  5 Jun 2026 13:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2D61F0089A;
	Fri,  5 Jun 2026 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780666715;
	bh=rfGnNvqCUgib40545imCPSY/SiAip+ywc+XcFOxOI1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oO9GB7o9uAXwo+00LhbxLaarHr8hIlPEBbsu8oc3/S5hjrlJe8PXacG046kdH9GVb
	 AvAr42tzR2kFzRfQcLOnBeX3k4XMmAXBvmOcj5r4ptTIeV876elVauaRVjeKtZMOOt
	 69vWy7AlAolhLTyv83ToNnJCvJn/bMH1Tt43j5bQUE3a0BVLr7p8Jn5/7fhaq1dQJY
	 8Mq/IkAEcXGHdB+b0+2rlH/rv75fUTQm20pNFgCmxTWKVQL2pY/EmVnEO4GKmEhrKX
	 o02n+dFDYmZVwaJiKgesUTlzFW0q7RIegcRRMAu7NxnMclJImBDymzDrrS992WtsKG
	 uZfXVrS2Apa5A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 45FD5F4007C;
	Fri,  5 Jun 2026 09:38:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 05 Jun 2026 09:38:33 -0400
X-ME-Sender: <xms:WdEiap8kdWuE3YysUwdswOaPA4fijezl3rwvq8QlOJbI407Y7iXhRg>
    <xme:WdEiaqLy6oduWR1UbZXHhGEFv3SKo3dScTwQeFa3ivlNvYZva65JW4ryqNdWLdBB2
    u2xIuKLthdMGopom9GNHrzR2-GGe7qjH2s6hh3q5G2X909ZNk2b6g>
X-ME-Received: <xmr:WdEiauQlPSkr0f6mcCt8ZVO0VRvDXOWOWSL4iQVH4gpW39A2l2XGDL0Fg-w>
X-ME-Proxy-Cause: dmFkZTGM2UkizV+reMWXsdwOJhYIOL/j/0ZD8k5LsRt//sPW6kjaf/1MAAJ0mS4qvAWJgr
    15+ZE9Ned2LtlVaSIU/hTIK31lh/ZiF7B+6Dl48DgBzoVccKuJMd4aizR50L5yXembF5zd
    WRdevGEw5pSn1Aeg5KzCaeplPe5IioSwoezYandUOrmoD1L54WQwDc3vi5fY5g9Iz4hip2
    IA22r8289UO0Sed2c+lFj+GJ/uNQW+50/kDj0dlPgjjbwaStax/Dtg4Ihfe4AAFyy9lyV3
    ytF+09oOPt2XLy/4hGi7Rjmwe+luN8JXrhtMX41ZDdPdr5SUzyVc0wPipMuMMsFN/qP7l7
    1N1Asq6LYd4b2NYnEKOHrpCdd71edu6ZAcfpGU0H1c5F7kO0skdTw2HFVNQC5V5Wtsv7/A
    mjGkPdZn8zsr50HiI8y3gbLIByugJtC0+CMw1KPawpOrDQuIgPQP0pKn36hcgeSxWt0ipq
    We2x35EiJr+P3P6piUmIsF2X7uUWBDNUXdWacFNLBuO0yu7utV+And7dGk9pPqDzifAUN0
    RiAmGQ2yrbn+AiyZgtRwzPKQMKPTPRbN6wl9mC+kWELB4371sMo1QwziOH6wgU4UD8HCFG
    PIo0tJ78ajIuqt+xgU4MGlfE8jKMnAgGhIyxidGTRE8iECgahFadvJAwqEYQ
X-ME-Proxy: <xmx:WdEiaj8WmeIFPgDGITdJlJjt7rAzDJyOUtp-B08Z_iU3iUQXHiUIbA>
    <xmx:WdEiaud3In2TqqlhplDhtdilwE7LwfMwkrICvmEzG4iuj93y6rVxiw>
    <xmx:WdEialmO2nAv5kvLJs6v7Au4-SPQwiT0K1ugtd6k8bM4AlAm7yye4w>
    <xmx:WdEiariG4KWGWFJSC8B6SJFY-vm998RciyHDyrr6-VP8QN1brhiVlg>
    <xmx:WdEiavouDb2amznrBxATu6XcjzM16enOshIRh5SCy4H9n_dMCxHHJroI>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 09:38:31 -0400 (EDT)
Date: Fri, 5 Jun 2026 06:38:31 -0700
From: Boqun Feng <boqun@kernel.org>
To: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,	Zqiang <qiang.zhang@linux.dev>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 2/3] rust: maple_tree: add load_rcu()
Message-ID: <aiLRV1UbaSYokAO_@tardis-2.local>
References: <20260605133541.22569-1-boqun@kernel.org>
 <20260605133541.22569-4-boqun@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605133541.22569-4-boqun@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECA6FA0012
X-Stat-Signature: 3cfr9o5ybssi4tujnj3buhdm4dy6x1oc
X-Rspam-User: 
X-HE-Tag: 1780666715-749382
X-HE-Meta: U2FsdGVkX1+c9KUD/KLLRz38J+/UOvse1WU4vq77xNsB+Xuo9JVwZSLARSUYc61Sv1NVf5UqC/id35BNWPGz1QRB7RcCh7jGzudUBOufy0XbqcWo7Fc/yyVC6DCvVZhYK3A/bEz2hxQi+sUPkOzRX/I0zELeLBEL4wSOuuYcNQfU1Hpa8ZGP3CH9G3My/uGwciEFs6CuvveCZ4IKJQL6g53G1TBqtTNpV4fPdYvHTvGxBFwrfjhfN/Df/+u15DqgEyDImxDxySTMERvOL0VUSw9Y5AsfnNCGxH3G4x5SPog7IhRE2VJfY3AX2LV+mc5u80fCKlqTwhmmqrr8B+UlA4RBMDdQX2tH5g/3InUnsDh+V4+zChkeM5PgEarwlued+wIExS7bzQWNJWvGls8jnbhZLPsh+Ia6WoAHlB3oBAbX6UP1/G45/K8BXkwxZbCdKc78+sG5rIfT3IZin8u2DT/MS4SnsInZ2gjZaOzrfJsrAuA3iY5a25gBK6PhQAIQAN5oCuwKxeuYHMlIEKJy3gfL35U6TQGxCFft+KDLFlLg4H3IDITdPd7vs3RR0AcZwVxuWtKF+WDEoA9A8EXu8W5oA4H6/vZgHGw5Xie7RVYY+1kjV0LvdDKF6dQiUX5nOHCZNwLfl5CXxD7AffKkjJwo4yMvaJRRrVZoq7+hRnD6lz6wGAw9/pzqi1FW7g6IV5WH1oBBV+ynVi2A6cqClMXvGX7tGA2NSv3cUJ1BLiCJUIsA5sVIqCNmcxeY/92kf7MXOXXTLdRX2gX2CI/LXAwvzKsw082/Z39N7FZGqxJsTBGPAjOmjK4vf1SNIG9w1Dl8KJxUaj1PianE/7Lsq0at91+AhW1hqKSwHYk3D6j0MV4karta/pdotpKrUzsO9bu1PewQg0hGWw8H5SortxmaT8lUn5lZauhunBtqNMPbd/vvbofKFEM3l6gM7+SEs9SSid+fNIFeyKnO8m9
 IEd0yl4y
 z6saIKIexxX7Ww6NxEYa01rWxECNWgYT7BAggLwIC4Mgj0QxqbNwrUoVoPdRXHt9cLsOndUVl3JrsnPsw2xPT8SR6DpwO/66qv4EbpkRbW8CvLELrY1CyXhol375Be7d/sl+CHOMrUpp7BIZf1w718qG2OlYV/DZJJZWyyMKO63MWGIbNHoeyedJCOuCPFAYG2hAe1ZB6Ys47TWpy5bRYGaVJBamIuMTpIMCAqYR8ITeZfHZbxkte5LYNITC0cenMeLoCd/dCHNL8OFhi9JbbP15cY0fMPSQopi9gCh7Z10IQJzZMV8wMxbvpRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 06:35:39AM -0700, Boqun Feng wrote:
> From: Alice Ryhl <aliceryhl@google.com>
> 
> Now that we have a concept of rcu-safe containers, we may add a
> load_rcu() method to MapleTree that does not take the spinlock.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---

Please ignore this duplication...

Regards,
Boqun

