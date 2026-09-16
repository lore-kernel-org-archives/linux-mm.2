Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33011C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C5C6B0098; Wed, 16 Sep 2026 10:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4340D6B009B; Wed, 16 Sep 2026 10:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323066B009D; Wed, 16 Sep 2026 10:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0ECE66B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:58:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EDCB1C2D97
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:58:52 +0000 (UTC)
X-FDA: 85219932504.17.8C9F366
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3BD9C100006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:58:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/65TVji";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789570730;
	b=nYQAgT7SSWaRm7T5gI1YxBB0S5neKOFE7Pvo2JmOTm6rWgz2ijAZf2kYQt72oDUX5HLyGQ
	dTWizo3P0uS3Dz0T9TnzLqSJcnpUv8SwezEi7aAm8mC7I/e1fy2tATgFaHRZ1NV8r2q1zh
	aB82XSzwigtZs3iSJkWUr5uriuCYxI4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/65TVji";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789570730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxAsq6mlrlRgY8e/8njCByVAcxEtv6lXs6ng+qgkRns=;
	b=ocvixDVTQ0WyFlWc0cARiWNbHHhMwX1QdJOKWlIdW+QiBYT31Q9/1/uieFYq2BmfRuU1/I
	O5dWX1wpljCjIM9DDBwTx7d6sFj3vpbzAgJxtXr97eb8yJoIimL6CRdmKiuPhGj6wQMzPF
	b92UtEw5rrQ17SQgshNN3XFFtADKs4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 441E26053C;
	Wed, 16 Sep 2026 14:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487561F00893;
	Wed, 16 Sep 2026 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789570729;
	bh=KxAsq6mlrlRgY8e/8njCByVAcxEtv6lXs6ng+qgkRns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E/65TVjibw0F1o/3no6+Uev4R6Dq4VnCVqEcHL36mowbuDt3lXNpzCUkdLFQM5S7/
	 M/yCsV0V+li0ym7yjwiyeGTCgaPUmnOfN7GBMou446maD9eWFzKMdrIiS0FJbcM5Bi
	 rWcRycEtn/3uR0VyDtYmQMt9gnuZ4Vplq7/qnao6KgqXeZfs9X8WFe6OwTlDhy7ysP
	 FbhzvGYOgyHbrCAlm3nzsx9GVX+228SIi9DzwAE2ziyBNZ+l8KdgRcFzYctzBMvv5F
	 B04wuli31nyeyKNhjfqzqFNmR2JapqM3Gxvz1qio/ykVdNLeESoPCxn/VUyrMp3UOD
	 RWEnJ1O7PASmg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 163591980047;
	Wed, 16 Sep 2026 10:58:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 16 Sep 2026 10:58:45 -0400
X-ME-Sender: <xms:oK6qamBZ5gTzffPWX-HGjDTTZoZEF0APcqLdlUXOhc05nocB0Q8gjw>
    <xme:oK6qai3kQlu4jPL2Qvu0Kxz_s6Rrr56CBkLyU4V0Lp9D11hxc8oVCOHRtMhRmgCg_
    oAHc-7sI2TBrvZ36eE3GEjTjzdYA-8NEcdsGO5Mfu3tXkqlDCLTimIJ>
X-ME-Received: <xmr:oK6qaoW8ooCkOQQjBi-OjYcnpCAMQOLkps_EmJmWzbkY1V5GAJhKaF-YH4A>
X-ME-Proxy-Cause: dmFkZTFnpmf2cGNwLkZB02TtYoQfXJ9CYV4Z6v6aWvRoWtlSDu/ryXy+f1A0x8yggrT6pc
    74E1O46vF2Ghy3wWTQKsuryfYPAHQWdgKyHFYusv5Hp2PFKCX2b0YoW5TpB/FMOmgTRU3e
    0rPdq8Nm4X3aaX52mXDmdfUjVnpqLxyZJtxgWB2J9Y7N+Ads7wL6SM8cD9T0bR/yRxkVbz
    ul4lGtKVXF83IjqQm8oQwLPVRtgSwlpzF2Lgwx9bu1MIQiWR5J6oqV8z0Lss21/BiVArkl
    ED0Xe7vVfYMHRQTNozB95yux7Vilk9hKmoonRC15QkVqCZD1prbWRZ9xp98mhGjkL0omSH
    9zcAaLfvETIEYKPBR7mU6pFQRrH/oI1296OKFPe8lRZSWQeNYaYMzer3lX2CIIG4Uirr58
    L94BB4SRia4Wgd/xgt+8eh9jrIZLVk44Vz4A0Ue2mQt45eOajNHF6gJWehH9Z8Unh5LhAq
    bmCFWB/qawZyUpKHtb2COIYxDMHab0zRXYubycnp5rAJeSZZyVePCub848zUQwrsBOj5pJ
    q6VF71UDjWEBW61gEqHQoJaIswvc9PmggCzLNwPfbSPanJmNkVcfb4aOA/lGxaiii+FkYk
    6Cict8JHxm/PpzzSVgnAoliVBS9hCF2Ugk10XA2DBHDQc0sb5Z2Iix4xOj+Q
X-ME-Proxy: <xmx:oK6qau8u1SRu7HNgsWn6eLaKFBBh11y_uWDR2g01gJGHPWkLtU16lw>
    <xmx:oK6qat3wzoXuXuiyX23xlTOpwO06F1O2dgmCnSE0PTZ04l7qjuVHQw>
    <xmx:oK6qapAuvZErVqBXnqXnPNZHFUjnf9oA5wxzvpamX6g8H-Hdyi_eYQ>
    <xmx:oK6qamBGJmy0pkBE4mVZpoartKTlLYUNJHn8Vixhd8ImrMoAdiC3Vg>
    <xmx:oK6qarSsv9kFkHQYS1fcmNx0s-vloq93B7HFvnC1nMSIKoMG5lKZ1PwS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 10:58:39 -0400 (EDT)
Date: Wed, 16 Sep 2026 15:58:22 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, 
	kernel-team@meta.com
Subject: Re: [RESEND v7 10/29] mm: make PMD migration-entry splitting explicit
Message-ID: <aqquaDH9gFrdCqHK@thinkstation>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-11-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914122950.3283997-11-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3BD9C100006
X-Stat-Signature: 485qoqauspn9d1zji9ankpfarnsuejic
X-HE-Tag: 1789570730-516204
X-HE-Meta: U2FsdGVkX19enAf79uIL2Yi01pUDx28TCeGzWiKoAQSK7MXbRTGSRQMFAQLFhT/vvh6q7iEOd16/cl106358+ZMmObZ4Q3IBIc5avEyEs6Kd8InhBnJZWNiP9YK8fp+tNbAmZnSqEuzFCE9Peb3gJR0HjLSv43lvEQ1bV4u3goa6GmKdWpvJq3sty6pj1//HzrKaY53Z8ytI+0Ym1hfXW7T7JEMv7c0corUsc/3S7AJT9sDDShbIQkwkwIa16RnvKL6L28VEqqxc9vY7X+h+PqdMEYaV2jrtiBg3ktKi7b1H/G4uHgIDuD80vT1Ih8kTyFuveCoAZHxtV4p1VuIPyN6bddLwYVdXs7KwetNgzffJuSvvnLxrO0ov5vBwygTCrLL+Vi6D4uvLp5RJMR9D7vTrKLIR8GBOtGavk/BOGTx7SH+dpgOr/jI7gh8lYlT5BShu6FmrxAFDLDm+y0GupK7ryO/KeZsoZRPqMBaUr8+SQf2Sa2ZLpu3VWAHgWQuxKzY4LZIlzMh6k5cOFGiJL5X8IXTbBz1Ab4KNja8Idk/FSHiVCRxzKRJFvNowntknbripQywyDklMY0JzyxdVgvdrPRWWlPEElhClqjblRYykT7R2ovIxboqbU4Clsxk6jR6W5ulbT7n+1BZderJ4hpzb++CD29i3E0l1JIlDNiAUvz56fHP3fojZJAjetKwTGPMgY2p5NikhKH+kCilJIVZ4Ln5Y8Qv1UJXJW3XILlqFQlUZP/sYYAeyj12Rl93f8DHonynIQsMOELB7ZvUrf2DHnOkARDfQXRSqHt2JaxmmX56CxUStp2Kz9RnJhqnOTEcALS6uVJk4WfgIhoubSR/FPhFdKyjazPFH3r4E+VvEs2I9fg+ZpkncceOTEdvx2FbJ60lfAC003U3uSoEVTOoHHgEknl04bu2irVmQXt7YJ7eUo6I9Q5HTHirknSByKtf9kitc2HHAEcAczhC
 hjrjdsFA
 quJAoydf+XGi+tARA/kvbJpx8uWTMXnC2EZNJQR6/qOxXHXtM9OHbXwcHGYd0UNMDTfMJksRYWDca+GigJPT7wQEDMmtj+Hc8cRkB2DTrFk/ox7XshRf9EBiN2AsZABHd/RrYTfc1rthPbnwQb5+AtO4LjbNvcAr1hEiTPZ3/QGNFj7wFAP9EihhtIjy72H7JZB6XL6Y+s788Fl8rCFXiMvFZWMIR+wK2CIY5UaSKrorHTu0DizZCEcoCQHnHzGCT58KK0dEz5JRYIunSFVyZH0jbiWWU+AUCtexcvlu/kI5uii8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:28:00AM -0700, Usama Arif wrote:
> __split_huge_pmd() and friends take a "freeze" boolean that every caller
> has to pass and almost every caller passes as false. The name says nothing
> about what it selects, and the one thing it does select - PTE migration
> entries instead of PTE mappings - is only ever wanted by the rmap migration
> path.
> 
> Rename it to use_migration_entries, keep it private to mm/huge_memory.c,
> and add split_pmd_to_migration_entries() for try_to_migrate_one(), the only
> caller that wants it.
> 
> migrate_vma_split_unmapped_folio() also passed freeze=true, but only ever
> runs on a PMD that is already a migration entry, which the generic helper
> expands into PTE migration entries either way. Its folio_get() only existed
> to balance the put_page() that freeze=true performs, so both go.
> 
> No functional change intended.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Nice cleanup!

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

