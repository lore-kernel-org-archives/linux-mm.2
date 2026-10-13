Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF833CC6B1C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 18:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517746B008A; Tue, 13 Oct 2026 14:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1E66B0092; Tue, 13 Oct 2026 14:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38FE76B0095; Tue, 13 Oct 2026 14:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14B556B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:02:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A03918013F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:02:37 +0000 (UTC)
X-FDA: 85318373154.24.16A4474
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EA470160007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:02:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnBzFRZj;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791914556;
	b=GFC6vuNB2IJjW6Jw2wPAZUbWK+lba9BAmZelSOtxIg2tCB170XVLKWQgh5uMIk07rHmfEQ
	LIhEX0DuTWgPGIRugrlJG78h6zuOwEHrnGW/UHrIOrdUUNq3mn8xa6I/YrvxdE1P+XosPL
	8RYhhYsL8VY+s00zsUYjqLYoOX3W2rQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnBzFRZj;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791914556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=MeeFNFJubG8PDj6YUUF1sN/pCxwclu2LdzrnSIGxX0o=;
	b=yqaVhaVC7ItgnWS1EU4qlwaz2n9X+fgNzWMgvQiLQlyiINFUYZRdkrTjiXP0Revu6hssOl
	Iu8Vcd6Hk13xbY9Rk5agJuFVF4Wp8kU7+dBSw+fqB64LUdO85QlMq9gE4FegoZDzysGwwf
	Vr2wpa2Kxk9k38OiI0O1S3KrL5UBuAY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B816143AD9;
	Tue, 13 Oct 2026 18:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713F01F000FF;
	Tue, 13 Oct 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791914554;
	bh=MeeFNFJubG8PDj6YUUF1sN/pCxwclu2LdzrnSIGxX0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WnBzFRZjmsBC607KBUWP8qW7aDvZBspvMh7ObL66WWuQx55u3HcdvyIVhufA0ENcM
	 qXSGowXhE1ZU6UrVCJdVJw1Wf4xLzxlJkbmcXXy3Z2+KxXHWZf//8lbdUeCsW6XQ8P
	 Vin5m3r7v9fD0weSI26xXyQMXV60Nyu/ij0JN29ACHcxfg22Ogno5BzUhiqlUG3Tt1
	 RAZQninW4PdXffL0MDnnB/A930Sz2EKLhJcSzjpI2ol/QPp47pR/IuPBTyEiEiLImr
	 iYt8gMedUW4Te3yTHOtSUWzEt4Zh1neGo4N7ALNhMjjcQExZSIXagxyGILzXEFEZVl
	 MTZYxFAm8ZgRg==
Date: Tue, 13 Oct 2026 08:02:33 -1000
Message-ID: <3eda489898ebf7c848ce61760af745d9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com> <d9a3367a1852158f60cc2e89677fb12f@kernel.org> <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA470160007
X-Rspam-User: 
X-Stat-Signature: wxrjckgbunq4m6ub7rtz1uyygkf9pptf
X-HE-Tag: 1791914555-517573
X-HE-Meta: U2FsdGVkX18apRKzSUpUBsCNgI5eu/YhyuCZvyLYWzaNLaZzdymPiSC5jP4Ga5Ni1AFdWWwAk/7bcnhtn/Tr0SgvLXoWTC25sN/XVwqdIPYth7d27u4MD7WRIMrn+XIH+CsKgLFbr30LTcbNq0Atw9/9QfzCKsX2aVzj1Atk8MABK14cG1A69eMcHgYfV6zVI65DW954MQgjkg+2/PLCBT1KPIu9VQRk0HyFl7jX3Uks0jZ1g6Yvw8+LeL6V23VnHOybdiFqmsy9Ry9RLOIbgr2eLWcDWPK6x2TcP3pUdTYky32XPuPYfxnmomZsM5fEe/3iL6q3LHenF3ukNfKOgsyekhXoBJXhF0O1Kn8i/63w45+eaAnSnqdEEE/BVw1rrwDvAdeWA4enqjIjBoCMSTVpkiSoDa/McRrgUL3q92xdrAFNPJYNIyPdhROJNpilCuXpWDlXhsc2BO0uJ0swi1RXFOPopH2PN3mvLWfFUcqo9nRRnA0G48Tlv2XQ9Dpq0xv/n9E07Lv+uv9s98EczsCzbEYT1L66Ep/VGheSMi1IZ2ziH47MKpUbHRtPE2p6q+/f19YL9qkXTB6NIzyVqrWKpdz13xeN7K8RzL1tIyljAiUjML/bVWWNVPInITt2LoMf9QShREVf8LveNe/G42k8J/2NNv2cYlHrlyl7OfZtAt7DoKTvhPrE+UwbvWXWcrOD2sL6Jg4TW1CMNnJGOm25w0XKc7wD51CABIuXK4hYVEGSxUs4y7K7siTmb1v7qySws1sqOzgaV/aqB+0BRB8sIMix8hm8PObUGZI4QsmBU627HJ+ZW1zPUwongiq7A82ANStY3x+GeTdgrKRZegCZRA+VuE6w37VmWLK4vnzz7r+wxUGCQwYGCEYei8N5+d2dyFOVSIf9WvUBAMQYbRJbcutdXuz4rknSFicaOGxREXHQmu6VnqFMBTR6hmbtPcZjq4cy6AKQYDJsw3R
 K4tP0er+
 eO7Yri6epRnDDynLoc4GDml4/0ONAgT7CrEujyMvkPdpjhZNS0OD9/VSEtikOR9B380VxVi1NVDiXCM3AZxgSFQPsIGUMlj81kyfc6JFCZP3euyJGOZlBABEy149D26V7Z1bwEUTCqhojvJiYpco7+9I6KQxq+Xtu1uwE07YFf19DIMc1HoffzBftS9ZXcATkeOWIOehMNNA6dFRssE9p4Er7e2D0gzWj1XOZ0jWp31QEaId5opArR0nfgCLoAb6UZZOSX19Z5iOD+KYz/CffXlRY95bGTkxSMhh2jFjXb+wvQ8O7CfbTZ2S6QGtR/SeqEIUG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Oct 13, 2026 at 10:16:32AM +0800, Yafang Shao wrote:
> Part of the consults are keyed on struct folio rather than struct
> task_struct: the folio surface answers from the folio's memcg, the
> owner's request, not the touching task's.

Right, and I take the prctl() point too. It's stable uAPI and too rigid
a bar for this.

My suggestion is to start smaller. The op doesn't compute anything
from its inputs. It returns a fixed mode per cgroup, and you don't
need struct_ops for that.

A kfunc that takes a cgid and a value would do: -1 for the system
setting, otherwise the existing NUMA_BALANCING_* bitmask stored per
cgroup. Task callsites read it through the task's cgroup, folio
callsites through folio_memcg(). Same capability for the use case in
the cover letter, a per-cgroup field and minimal plumbing, and the
kfunc can grow later if a real decision-time policy shows up.

Thanks.

-- 
tejun

