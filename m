Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B924CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618C46B0093; Mon, 25 May 2026 11:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C95D6B0095; Mon, 25 May 2026 11:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF0C6B0096; Mon, 25 May 2026 11:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D06D6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:52:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D831E120127
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:52:38 +0000 (UTC)
X-FDA: 84806384796.03.623D994
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D4E2910000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:52:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kt3y9pvQ;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779724357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/Z8pdHv+cejKJRoNdNxhQU2h7dJRvk5CmidndA10Ig=;
	b=An3nqqN9WQMZJrfilHW3Ngnj5e7G3q5loOKOrL1LYlld1se17SZ2opKqIy8GDMEKUa0PtL
	R28TpffUahxZ+SkQshRzPDKUOsqYCGkJ586VyENts1p/Lku7nh80mMfU9EAFKsmnrfEStw
	Uh0HndnmKqZylVmumWKQ8acvFz5mo+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779724357; a=rsa-sha256;
	cv=none;
	b=ASqsvxc5u3qqA0ELXx1xE7KkuyNB1rmkR80dJqZLlOtIgAmTEUl4r6SfmDGLXsngsfTNWe
	Ft4ZNJyNnr+/515q7a3MoKouiCGKlbj+yLo5uLmjintdRuvbheTrtbOGPm+etIA710A5a5
	z0kxZbUa28SUhZ2ZKOBAMhaJ2PKCwY4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kt3y9pvQ;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8A8240064;
	Mon, 25 May 2026 15:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDB51F00A3C;
	Mon, 25 May 2026 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779724355;
	bh=k/Z8pdHv+cejKJRoNdNxhQU2h7dJRvk5CmidndA10Ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kt3y9pvQwdSuJvSTN7r4XI5/WHegjzntVLK6Pd1S5QJhj2zIobFJYb/xhTuzCBGuL
	 y6HSVM65kCCxp2g6iltV2ZtcmXLmgjWNXyIhIeSrZZBePRkr4YmFljRJTEFEbDlS9A
	 a8y584fH//yWR59AYHGGrQnzb54Z2e+VZIaSZAiax5tru2UysZVas7oSUfj3vgtXMp
	 LEpkO6WnIGt0K2FEOaHaiwSZqYLaMbnrv0rYf299gs55+VqF/Xi9wKg8P39V4ZATqj
	 oJ2TY32irf0jqG+n64y3WOujqj5K4rEnmANxrZPN9Ag0MGo2cJOz6YvYLkpXevOawy
	 zNIPOEAhm4E4A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id AF47EF40068;
	Mon, 25 May 2026 11:52:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 11:52:34 -0400
X-ME-Sender: <xms:QnAUaibTqZNNkpfvaTg4ESj2J48AtkXqLmiZWdG4auANFJ2EWVOC_Q>
    <xme:QnAUaj5Jke3dVBcxUG17rltglfQusJSRkRDhJuZ-aEsi37JaVK9ZRWCvfvyEP9Ijj
    xjbgduOFx_FwslUjVdSAlFwzVGi2r0aqfO54OmDmA2QmR_m55yFgKg>
X-ME-Received: <xmr:QnAUajz_zW08SVZXxXiZRAVPUUfpLHW41K7kA9pRKt0MYYxlGrSKAzJ2YZJgFQ>
X-ME-Proxy-Cause: dmFkZTFG3QYNTvlQv4dXNCn1oodIpGtSg2/FSbVjxuVpQ1UyDWtTeK1CyeqKqmJVajGwCO
    wIChQ7Vt+BXUskOWr6LlBPn5GN5fGeqIk/NYKTa7qGi7goriiLHEOgMdCN04mw+FZtqYdg
    XErwWFDznvfyjghz9mVLXKWox2GcuQMRU36tAor3BJtQgbKRAsNYDSm4IMOLEaZpCmNrZV
    1Azo9HmUZBLZ/jpte6sWbkMoMVQmjwnZysrX/e7xS+6iJOK1SGB1tZpM2eqpHr33IvrFjz
    GsC6d4gEejnCFMPKdLRWBwAG+EL3MQw/6/7pdlGjdNgxTKKiFHLJw02Nwa/LaqI65l03Tk
    W43i4GsczMkIPAnVOQktTyqvrTxNqlwhagFQqla8GI6lpovjMMG6yECuWIAupScgIhjeC0
    RPhDVRC4U1j/Q+x/9dF+fCmWjXKdI24pKDdslMjuFe5Angg4dk1J53w2TudjkLs1mBIyc3
    tDx4SDYb8Ed29GaGAQcMvjGGE+ZHk3dW6BEPZkEXLOyABIBm32uBzaVDaR02mRitIGSm1S
    cvzCpK7BEJwsMlBGMO+0PNhsvyNG5fBxc2MVprZ1HOo27C3yMO08eLPPgoH/8bAy7ImtTr
    Sluo4QhynIVqoTPRd6qxnBH5FWbYIClaoSGfgY87TMP3ibV2pyiFBkRx9gBg
X-ME-Proxy: <xmx:QnAUakrgu_jvN2NHAJqKMSuAa8xVZUabZMW7dk_-cPNBn67x0PQSqA>
    <xmx:QnAUal05uHNZ3hC2Z-bRyzFqsCwDllOKhkavr-YmWWW8_DvWLoaiNw>
    <xmx:QnAUatB47owQ_CXGPBSTWL9qLyzwkAg-QqroVDTKZpfu4ZdrUZhNNg>
    <xmx:QnAUamNWgeC5p20LW1FXGtJBj4GConISVPQe6r69QYCdFHClPDhqRQ>
    <xmx:QnAUahSEdPXjDDrhoQlbTnGjYSflKyAg2k5i4-uJbhdbRr94Ena6jRnz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:52:32 -0400 (EDT)
Date: Mon, 25 May 2026 16:52:27 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_vmemmap: fix incorrect vmemmap restore in
 rollback
Message-ID: <ahRwIo7Mg71IY_Dy@thinkstation>
References: <20260525025213.2229628-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525025213.2229628-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D4E2910000A
X-Stat-Signature: t3yzb8y4akrcoe9oouxmgjkc64cpngsj
X-Rspamd-Server: rspam06
X-HE-Tag: 1779724356-14888
X-HE-Meta: U2FsdGVkX19NEPvaXmQGJqChAkzmi2vaUx47vGFP2E3A/1gnZEtmZkeazPR69TCK0AaFfbCW6fx0AXBrsid/53sPun4EeNRPHSZlsh05WeCPZGKpUm/QuGrLKankTBejyzwaKwJ/dnVoce/RQ/JtSjzLy/UmaseQNlmt3sRaxtXZr4XEEChXgiiqiyA8XK6+Rn9YRvVD22/mrGyDDeXTufE3XPnBHXSQg2gWjvANhWubtvA5ROqGrbLni1knoY6BfQDK3fSvr80H9gEOg3Cs9HYMbQ3ll0m7ayFvhAqAX7/QTE9U2EiatURQzdd9EcpSeWhiJ8ZsVWxdmyXhetjNqlbdjw5pb+TFX/vdY9GO/mC+O+Bz55hL0ZFzCeBOSK8djuzoZQVQIlpWN6nlTbtzdkYZD5IXGljOOTK5STnKNkpl2p2IwnOn2AyozD4kyDmLzRUfLbp3QzOfYSTnZBTcZOzB5Ll9F9DY6Uch7tZ+KBa5lRTYtMR05QpwvfPyV8Ewgx87oPWnF+H9Ra9TPEsWB6noWY38IWY3JtA3Ny532CHxfSH+8o9TzCnkVo7u10CcGg+uG5u5AP9q7goeaJhuVFImWEWAWAmQ3I2t/S9biat0a2G+0JBS5h4UwIYKzvg6XtAmH0dKoR5uXTUVQZf5qS7j9VQBdmHV40VpkZD0eIy/0JgWzXNFuOU/1wDzijLQyBxkKXDBwRazhqE482HbzMXr3xoS/GVmdYoKWXsrGfjuf12wjbF0P/JCKQ2u8jG1e4oBEdBHTZWubdyEaj2cOX3RaGQ1ETD/dJ9gj0s31ptZOgMY8kCHbFcgQ3imsOJKbnDwHSk1+03EXhMSkqivoLbQlUrP0sMF8QFih5PEzIEhAMJFQpjA7QP0AqC2oFmXuJPo9Bb5bOcB0yhH4LC5rwWN7MMUb72mk7WxO52K38UnZEfNLcFgGSyL8DGKbl3G2u2UmaWloJV/WDiE8Az
 OzVdMfDd
 58nH+FQKuN/kcC1/YMXj8qJ13/B87idYgvNrSa1JLdusoFWLK6NttL2F4+QFaDkXizzUod4Yq+JrqUPf+kCQgS1OT0UJRAt2rPA9ropf0fUBVQ/RhTwzlagKdoeMBsatyxuPSaTU4edUUYaXeoSUIA+ZKoHQRa/U6O2q3rM6uaecyOQMqtvBb/PLDRSbq9IWaiTtOk3i0m/8/MM9Tnj9TzLxkcPPQASAq19KfnyUvqhwiTIf7yQ84eiSzCUplGgpVAXvLSpiZSPgt6aw0RIspZL0rnQaAL3mSnl8z2vDuT92jOXs2snbuYOgWd7oNkyQwA3B/3q2BKswOaqHxO8zN1ev5Jr9EK0wgl6SkltipdD6bNykEgbrvHOKyLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 10:52:13AM +0800, Muchun Song wrote:
> vmemmap_restore_pte() rebuilds restored vmemmap pages from a
> tail-page template derived from compound_head(). This is wrong when the
> current PTE already maps a page whose contents are not tail-page
> metadata.
> 
> In the rollback path of vmemmap_remap_free(), the first restored PTE is
> backed by vmemmap_head and contains head-page metadata. Reconstructing
> that page from a tail-page template overwrites the head-page state and
> corrupts the restored vmemmap page.
> 
> Fix this by copying the full page from the page currently mapped by the
> PTE. Also pass vmemmap_tail to the rollback walk so only PTEs backed by
> the shared tail page are restored, while the head PTE remains mapped to
> vmemmap_head. Add VM_WARN_ON_ONCE() checks for unexpected cases.
> 
> Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Kiryl Shutsemau <kas@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

