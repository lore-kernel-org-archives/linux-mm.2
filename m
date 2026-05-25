Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A8BCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521156B0095; Mon, 25 May 2026 11:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1CE6B0096; Mon, 25 May 2026 11:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFE46B0098; Mon, 25 May 2026 11:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 266F06B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:43:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2F39A0176
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:43:28 +0000 (UTC)
X-FDA: 84806361696.19.28A697D
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf02.hostedemail.com (Postfix) with ESMTP id B951780003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:43:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=kxdTxxZK;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b ohjmZY";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779723806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88Nud1y/YibNrOB0gSUwBPRtOkXj2T+J62GpPbYHumI=;
	b=jMOW58S9Imwn1YKZRvnGMru4CYTb7+FL24nsVB5SFaBvTtL0T0uuF0M3JSnym7wyCesF/P
	O1nqSJmmySBKrDfqWiKEW1q2cxvSDzHUxO6qVx3/ZPO7cRHfXijKAg1f+uMgAkB2/KbHzA
	0YE92B/IwN0LFgsdp6lpmZtVmh2nf/s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=kxdTxxZK;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b ohjmZY";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779723806; a=rsa-sha256;
	cv=none;
	b=sa5AsA2sYlFgP+pNC/s/WpvU/d4nxhuyJxmNagQGVH5v3Rw3Ofjjet7dfvLoGslqUWhhvw
	KytKuGh5pK7Z3i2XaWjo5IAHlVkiG0snN+I1kvsQfCs24k6G+QHhTUW52myGie1J6XvbGd
	3KKrbPc4PvMssa353Ldx2e520tkGvpk=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id D1AB5130096F;
	Mon, 25 May 2026 11:43:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 25 May 2026 11:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779723804; x=1779731004; bh=88Nud1y/YibNrOB0gSUwBPRtOkXj2T+J
	62GpPbYHumI=; b=kxdTxxZKNlyYEJaEjhzIlxV333uuHLj9CP4dASUuDqRAqbuJ
	aJKq8l6iZqZcYxYLI/khLFcAP7jxQHszUuoYEIDLJp6RVnYnpukWOl/mACh0njF3
	izlfzrGG1M0snv9Avqx3GCfuneMMOtmDX5tFY+r0wo9UJDWS1k75UUv1pWnxzZ1j
	X3QequtZaImnR/rW6htjHovgC5a/kpvor97SCuducSKyfRtSiI54sigsnKaPYbf0
	J3fSwf+P2Fo+vfV0vn+Am4xjyEqWPkKWin8VyBpJwsDWSB6B0z13ecc0eF4tSL/i
	lCoO+ZnuPE/1T9Kxg2LBba42AAKNKD81CP/Q7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779723804; x=
	1779731004; bh=88Nud1y/YibNrOB0gSUwBPRtOkXj2T+J62GpPbYHumI=; b=b
	ohjmZYOVb8Dbt/nAmgSjrg6JAJpecC91nyLAbriwhpE5fNp+s6uJXIH/e34R07bz
	qABASIsnFTkG5Xwsyuqoz/luOvvKSdnESLmEi7Fb8AcPnx4QJo7AhFISgNixunbV
	DdjYFiimoKH0C8d/cjNxVg06CBKxZPHAPmu35yRI7ZvQvBni09i+EYv+KvtxhgAV
	eLmQ4yi/dGS+4OgGUBSq2PO3CzlL1vAFmjJqTbTUBR8DUSH7vD7r1WbCRBo0PbAm
	Hes37uye5BNiFmJb8AeSrohmjHDpP3w1w7YAnAzwjUtHJxHh1BEpmkxijslqHlB/
	csMTM21XfaF/kxTOXc7ZA==
X-ME-Sender: <xms:HG4UakRvkJgOWbODwyYK3Dd9p9S5pJRxlHQD6tL5ZwqbhcasRDr-XA>
    <xme:HG4Uaru9XeWfkc1jBBcQMW-5J3LdGyHmwo4EGg21kgsmwiwGu0sOi8-Q0PxRsHpnQ
    R6BN1f0k2caSb_q3ypL7LzhzfOK183Nzfylk3E3oGe6n2npk7jDAq8>
X-ME-Received: <xmr:HG4UajvUogtrdRx4c4zHT6RO4dkTRtgRQ8HnJIVPWdhaKuq-T7FLhGKcy-tzYQ>
X-ME-Proxy-Cause: dmFkZTGEPse4hV1yBwsDDEa7O6Lryon99uUXj/XLpI0tprakm/YTBddT7aRX8pCTW2DPLE
    wxqIym+YUtlhKLJDWeGlCptVUlFMjgS9D7yuWlBIwCAwtYKi6zo0j4CAVYn/vgyZJPXLOG
    BYtH9Nh6HPuNoLdp1/VdWgbOADAvtxmistcJnr4qLuoaufELcanxBkRVcKH65VViIUzn34
    Kp2QKpFHEZKdG/bhngq9fPozMAPTXZBBmDnTHHXvVQgDsw5EQro4ZLXcqB86Oyr85j+lYE
    v7bqRum/AgTZ/4ycaOAngfI42jEaiRD9E5AlmyGSKpkOU4sWKlAkCcvM1cGoh+03YQwAY8
    X9aQ1CIpVnLo3jflOe17bGQnRrxaoDobvUAKBnTzfWMmK1Ps8kX5fFimm2/1yY9k153gDe
    0gVknUi+LyLfDIOhAsTGivf8ANnZQ+iv5gVIQSdF81jTeFCwUCwsU8gCs5KEUc8yWpm7nf
    9m2+Z3W/bH9zYhrJzBs4Xc0UrEMn8ULjNTnMtxrXNt3Y5TRdc4jQxK7EBfKOoGmhysKzrV
    N2+QIqxlriwwcjeCt30SI9i8qmYFvFLB9Xf7GwwlKXD/f3rl83QxDO0z8RoyRJYz2Yr1oA
    M6Z4BMDhTarpoc0aPlljBl6npKQx/IAG2YN6iEl/6bJhwg8Usffad3Bc+lgg
X-ME-Proxy: <xmx:HG4UajfebOWqTwI3QYTwwOd16SRNaJkd3Lld7d6QpmbSdW-PRFsSYg>
    <xmx:HG4Uam7nD7XuK2hhgmZfcDob--JLud8cy65K5QCCMu1t7QRiJQpTaQ>
    <xmx:HG4UaklFqY1dRGooxRdCzWkMortxZHcVr8udzWqIOdITllfPaiVm9g>
    <xmx:HG4UatX4Ds76lcLwxTeWTlz9ak0Wjt9Syd28k8IZklMpMJfvVl6NTw>
    <xmx:HG4UatmOHtsROuC8_xCfV0vW8C06WenfPA9EBab_FcJZMQbyxqXHCaoA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:43:23 -0400 (EDT)
Date: Mon, 25 May 2026 16:43:22 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 13/14] selftests/mm: add userfaultfd RWP tests
Message-ID: <ahRtlPsrj31R-rek@thinkstation>
References: <20260525113737.1942478-14-kas@kernel.org>
 <20260525123904.0A31F1F00A3A@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525123904.0A31F1F00A3A@smtp.kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B951780003
X-Stat-Signature: r8nrkcsyshgpewzjsk74ja155inuc6up
X-Rspam-User: 
X-HE-Tag: 1779723806-843214
X-HE-Meta: U2FsdGVkX1/ZM3SBNO814eohP8fCj4Iwdn9AQhOsyZ+Xo5VnXlQcpA+3+M6w/F9KfWZfnlBMOgNPzgJeuYvziEXdqMkYDshPAe3QDrrQg+GVog9dwoSmzGtEx9R6TrGk9Coc7MbAwCC9NHsY+nujoNW1257aZ7LjR1+u+KT1ofHRbi0V4DXUZpNJl071jc9aIgAVfD6aLtG/mbrMcjLnLC/1oQ9BejVntAsOmojtO4gQu1FM9zZ+4oXhxkP33paq+YqgMP+ib4tt8IIEhEigzgpcBvWRK59JbQaG8WjOag/NFBsIP65A2pTU8pMAf8WzpfcUnkLE5P0UvYTfQJHuZkGNjhTRviIUjsJ1EJdw6KI2ZWZ/flp59Fna2uCs0NYvD+mA8aJfaLlG7qd9NAW/PGvhXcVV4dD/93IFOEgtWVjDnEPO5YEVPOTquUBrw3PD3VIcP4MVwh5veqQUUqkvLLmdZE+/InQuewJH3EOO8eViG6ZZnIhYZm9RGT2lgWLuhZSeQ2Dc2SgmTBi72mFVqcotUuAX2z4Qon8Zz2h4ztjN08L0jIBklOA4/G3voGla+NeRm8iVh54kap8AU0C0cavlDmjwkLhM3x02io7ZjFdTas/DcaHRlQdsUqHscBX4/NLlac7qwL55f7tOvF6sDJ4xHBkyqIBvKueu/YbLoOqp78+lg4jvflR/UVzm9tVx5PeNBnVgI8PjmOLOao6PkPTnqV0lIrHpS9Opn8WDrcqDjYeSMmIoxc9wj6T4WfzkBlx9CRYKjZ7diqJihNK+9s8Z8lXmZ9MT3O52IcZwXN0I7p+1sIB3bqFzyzC2xIYggkug+9zPzxZTvH8lqETuSRKgyACeAPfA6jFEIN0ZGjf5rqSJq2xaMe2GsQx53VEqkedwghjxXM7BSD/f1crGcwMq5r7b+Fnru+NywUe5LJtnTuZcou/qeGSM6RZXP01mdLSpc89wp7aqO7gu7BD
 rX1pgHE4
 CeZusgai3UGpSjguJgXZd4HzosppLaGlUg9hpOFuT90PJUTJreVDoowA42VdP4/EMtAirGP6QHcyiubSTNgRIcpEpKfoled795uzOncYTOVqn+osPPL3d29iO75qIIfYtqMqkkjfHyHpFuh2iDteMIePnkEk6Ac5hykbgOFg3/9PfLokhi6qs9UhVPShAn8apcsx0dBod1dHdmB2eeNCwuyHDIpXtp7QdPHYIMDe9ByEz2LhAttIui70bDwcvJ6Z5gtmgIhLOGORPZEtsSjPrkf97RRrzpAQgFb9sBZs2Gu08Zb5ZJEV9jExWZWGkAj+06FoK5eBrGNbPgrvToih/2GqLW5HRCkVqu0IavdwXU6+1gIm0rTzw45Ldu5B9aN2z8CI1qaaGvu7RhRxH1in9rrQ6xnlcrcjSBtAso2muMf/pgmVZ7qxJZhuU3c3zPul+lEsfdq2vGQj+1HSAOjj1Xk2uP0Ge6QMm4lc9Me80yF7Ad2wum7ZWIKBm5o3u2RchbKe589dMz6nqjxzoUoQNdJZBQQkox/ME/m5cbJGdP6861EE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:39:03PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Hardcoding _UFFDIO_SET_MODE in the unconditionally checked
> expected_ioctls breaks the userfaultfd selftests on older kernels.

Will be fixed in v5 -- dropped _UFFDIO_SET_MODE from expected_ioctls in
test_uffd_api(). The dedicated RWP tests already exercise the ioctl
directly and err if it's not supported, so SET_MODE coverage isn't lost.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=13

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

