Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9160E606A339
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrGEsf9R
Received: by kanga.kvack.org (Postfix)
	id A23D56B05B2; Fri, 27 Nov 2026 07:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4DA6B05B3; Fri, 27 Nov 2026 07:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3B66B05B4; Fri, 27 Nov 2026 07:14:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3546B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:14:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01495A0325
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:14:48 +0000 (UTC)
X-FDA: 85480792698.09.DB65956
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 303A640004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:14:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrGEsf9R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795781687;
	b=l7Y/cqI0yyaxnXF/IP0PRvdz9GaLnp1z3IYsLkMe17/+ScJm3R5c+GRr7ZRUOE695mPLTZ
	FiIths5kXc74N5FGxrD0q4e3M50IAr6Fnsuhw4At1IuD6dxE+HSunSJkaNFWt4yD9Yo+Fm
	a/sjET5zZJoTRrZbavBMax7gQPBliVU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795781687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3w20wn8ciMIi314K9ZKRgL922tIUAQ1fVj1q7jFt11I=;
	b=r4G8ByTV7tT0FIWLdCj9H1JRHRJCobTD57kkXE6L4tz0btTd6Cb3FGn8zOr1p/8s9Qgkon
	7NcF+tehQQHosrwpCQV75zud4exWyobaa8XwTxGUF89N0XiKEVgOrELca+YU7FyrY/xdpE
	U2wjPqj4Dq1L+Qv+Bfo4Vs10991S+lc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrGEsf9R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 247854187D;
	Fri, 27 Nov 2026 12:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA841F000C1;
	Fri, 27 Nov 2026 12:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781685;
	bh=3w20wn8ciMIi314K9ZKRgL922tIUAQ1fVj1q7jFt11I=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=JrGEsf9RGSAi95mThpsPZiqwBb8CPAROQvgPolW2qIJ2xXEk5VJKACzsGFeqPtsMk
	 12STunPm5NpI3riSYWarempFNzU3lBP52Nu9ASxRNvvlCt5tbzD/Hw69Mx3qSnEwze
	 Tixfxfhgo095X1TISXxrvq2kWiGqVrUKHT1E9npI8SB7mKrHS/umAuWt+Hx6/XLiPW
	 CxkomSEuUSy3wQR8uAzWuBAWKwnbwVNUjdHwpE1WFY5jnYft8hPuN8KnQgWOuemKqt
	 DFUFi5a6yGXRGOdEjpfbF1YQa23ZPwEuA+i7DRrh/a6UUpOg1fAbG/YbyqIeU2kgn0
	 fWfCj2t0bN5wQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 0/8] arm64: Unmap FF-A lent memory from direct map
From: Sumit Garg <sumit.garg@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
 akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
 mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
 ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
 ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
 danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
References: <20261111110738.872947-1-vdonnefort@google.com>
Date: Fri, 27 Nov 2026 17:44:23 +0530
Message-Id: <179578166371.172025.10770561998032628043.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=764; i=sumit.garg@kernel.org;
 h=from:subject:message-id; bh=H72B6Re7Lfo3dYJpngqffII6YfaUb4iqb0oxwd+0b1c=;
 b=owGbwMvMwCV2RWpxpe9rmzmMp9WSGLI5SzTqKoX2v6poOjM7Tepq5Ht5my8u93hEPXlY96rGb
 llxtjyvo5SFQYyLQVZMkSX167dp24T+1YZaneCBmcPKBDKEgYtTACZyuYeRYavT7sI3m/SebpyX
 onf6hgPXAYGpWw5ElojkKeqEbHUztmH4w+Vd9c3uxqQ7AhKnb8xtPv11xZuQkk5zO+20IpOs84t
 N+AA=
X-Developer-Key: i=sumit.garg@kernel.org; a=openpgp;
 fpr=65F5F696B612FE7D553AC80CD41AA3794DEB3C9C
X-Rspamd-Queue-Id: 303A640004
X-Stat-Signature: cwn9prcm65mujmek9phqyqoiiqcq8uud
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795781687-412806
X-HE-Meta: U2FsdGVkX1/Qj4PRwUgcVl8hq8gbLZ+b5laNln90HSp+70LegggM4ulGb5dOZxGm/M/ePTwMBdW7wU8z68/E6HNMzDms1rCoIQlM++92o/gVYjCCLY25TTew2mHLRFJeWuFjx/d4qbpd20jBK83CY58xnAmfeOX3pMdqLHCMPwW0+j5tVwUOe7obdDBjo5YxxAOop0yLPLdr4Hdf9KVM1LSY0StHbWS4MS3NGV7hIIxX2GglP8bOEEdny9+m7pewb2VsDSHIiNDksuGe7Te4D9DmYs/KClRnclnGgGMOrnYMMoZj74e+ILB9CRbsQgz4z68Bl3gE3XOo9C9IVlSJxAcdbEMrVUdIWypL4Vqq0im+xbpIsQAtI/AVqwywcNYMhiWkwKG6CXHDFNMT8O/woeUbBNlmi5375Do7b8wck34VR+phBB5WT/8zItGaHXvTHo8LB4w0nooGcWEUk0no6JFm5uZZyYLUH/tcyG5JozJD5JISSeU+mw2u7oGzIUlfb3KFO8xMvOoTL69YVJN9V86vkcqAkRXb2YGOnZZzURo4f0rvE7qzR9VtKRgl7wucooKohOMcd1ylECF4QF+FuDn4j9e3E3awkifJEWhQ/jUT5Ro3y+FpHOPBc/2+PIqeWXZSmM+HdCXnslE28wdy9CEo0OenrRErbLiGOk+VPtTyBuD/d4epr9YfyjVYstf+VRDb2CFzV3Yi9R+KFG7GLRUeynzsyICySFCAvjnPb8So0PI3CyI3tQxCEio6TNNi77MlumqWvR3GELGBckAD1JAknQuhGMjE6MXKMcfhb7v0cikycFbSVLwlp4q+jryeBOnkJvWBj/C1KpW8IXSVUyoiekXeCcgKZqm5h8vTNdTBdfMP6gy3ELb3gPMd1XTXzSQyrYflTIpFFf9vE7EdSd3m0nEJOqVhKnCWlThVkBS7SlFkDkpxL3cJ2RFJRk6jQOeiqgDiDeeYOOKRH7f
 N6jCovdF
 AGKsEahwbcaVPsa4C3i3oce9mv7GYCJdd/Dhxw07K+XHDpUp6/Gq3Dlb7lC9Y/b4+6JM9vs83WyOJMewLSnpnoxgGfP+ES1MtITlZFHt53OjH9A5YgtSF7J+Vrakw52bNoN62N1xrehgo0+j0NvvoDFCCTA1br7OIPbDqFxrlxql5F0yGui08Dqyh7p7pOVQQZ8QYqpxNcc5IzD5h+DDinnipPyxTMeE80r4ERCIuYxiYlLWvF/1OIRE5246QjZEVdllnvjH65vrEU2AMhX2fIFl6/6LM8MseM3RrsPhIlm5ByXLa3TzwS3tEm/yW1dBJWb4CZFFw2wEjX0b+k7+DiongL/AlvNYv7iJSzEpfHSf0Tv0G05aRwiT/fiQRJB6z8lRZVnRk6+JrCpmDOPAGQm8q2Vr1DgbD4b7Dn8EbEMHTOMZWao1LqEL7kK4vuz1E+Wko4SPXBG+UFoNe6VE/inyprTE13XYsdeQXJPCtMyPAeKGGddQlnVrZNi1h3AXy5iY3wep6k+C+sXrEj12kGqv08CmVEkmSjlTiLBE6La30kaY2YbNcNmXRWcUG6MFhNV9FTk6nfNv2dc8wERrbSWYg6KDw5DVKroIb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> This series is a follow-up to the discussion that has started here [1].
> 
> When memory is lent to the Secure world via FF-A, CPU speculative
> accesses from NS to the lent pages can still occur as long as it retains
> a cacheable mapping to it.

One thing I forgot to ask during last review, in case of hypervisor
support like pKVM how are going to handle unmap from stage-2? As I can
see from code pKVM doesn't support FF-A lend calls to unmap pages from
stage-2.

I think overall it is important to unmap memory from both stage-1 and
stage-2 to avoid CPU speculative accesses from NS when memory is lent to
the secure world. Is there plan to support stage-2 unmapping like in
case of pKVM?

-Sumit

-- 
Sumit Garg <sumit.garg@kernel.org>

