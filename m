Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AE4C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8226B009E; Mon,  6 Jul 2026 09:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FC36B00A2; Mon,  6 Jul 2026 09:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8720A6B00A3; Mon,  6 Jul 2026 09:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52A496B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:52:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3D12C1AF9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:52:48 +0000 (UTC)
X-FDA: 84958492416.22.EAFE0F4
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf19.hostedemail.com (Postfix) with ESMTP id C3FDB1A0006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:52:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O RGHdGO";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=QUPbPPQq;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xSpkCs0mkVTU4ldegsUj6ukw+q9jYjeMqfDzWKa/Xs=;
	b=IuzPaMnIeKO0xHbXFV2TBWCTUg9JRYJjOaB3u5PNWXsInP9VGaioJu73Uk0nJuDFnMcqG4
	c7IGPQeiEtIr+WB7+5IALti4hwgdFdtnEX8Ix0ucOf5GCffFF1X0OuL8en0hHPernSgPs6
	N4bBkYbxrFg44azvBD1N1/2EVGbhyYg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O RGHdGO";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=QUPbPPQq;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345966;
	b=0YAqa/lA487PvDPczejd4GcLEkOWTR1ZT37Hv2MLAPnkfWgHSxudlrYOlajg3KL0W7lB8G
	hdO/ERQ3bR6loCEUrpZl/Q9/TJT3cf3wd9n0Y9nrQ7QFKfArNPHtug16x258XPOHBZ3QgC
	Nn/nkqpCbcmHugvmu1x0dEzvbNMUD0s=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id E02861300141;
	Mon,  6 Jul 2026 09:52:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 06 Jul 2026 09:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783345964; x=
	1783353164; bh=4xSpkCs0mkVTU4ldegsUj6ukw+q9jYjeMqfDzWKa/Xs=; b=O
	RGHdGODYRzGGOQtsJDjFD/GHjYhFLrnwmhJ4nj8SQmbfwwqdnFLxvAhIIr2qmvYp
	OIgRR91nabhXx/M1Keia/pwrRMj4ezHDF1pPDv/TPJ0iJN1zmbCUTtZ7Fj14cbrr
	GrxddPQyqgMk4Z3UhbceLX5TFPJeZ4LzEzsRc744K14D9Oat0JWhaCdj9l4WPoK6
	LULyYorRKcoIQQZG8btIK8yDfvFkNPMNTmIDk2X+m8rop6JvvxlmudT1OVbcS21S
	p4c0S9TARY7ig36mYp6laIOveg6zBhWMD6wo2fQ5DFMasDBNGxnmU11Srj2S4y47
	WUsKMsLuSpJmHxeixAiKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783345964; x=1783353164; bh=4xSpkCs0mkVTU4ldegsUj6ukw+q9jYjeMqf
	DzWKa/Xs=; b=QUPbPPQqfSQuGc49n1E+EybiKQ0AjhWnTZMkKKrGMICkDTpo0tR
	5WFz4zimhqh01LY5oX8JF3dMQ+gxYjo01lD63mmV0TXQBPiaHD9FUybHVRzQdU6n
	rgmnU0mrORY6N2JknY9kOwW9ZwOTcsJhwDIDUJKfW5pkL4dDFE4vPXtrVKAX+GJ2
	9JPKFwB729Rt11z7ZWVnLfwlA4zicjPcR2hADg0AEvibY8ABCyBE7HGb1SMh24iA
	4mmrJjZ+/7mjWj1miTm5M29347jKnz/xMVzaC4w8TxX6BBkOwblSRkPmF9TLsVbW
	++X0uRlj9lSoe/9SBythXU7NSxnBUjj9zzw==
X-ME-Sender: <xms:LLNLanE6LlyrXVmKP3xTrqQNWWWCtGiC3IWD8qgp5wQoHwI0QCJamQ>
    <xme:LLNLapl7OV15UFWVChlyt3TySoYcuctjzYfJfzPueR5QcET2_Jnl4WVi4d3Ue42LZ
    Vz_tdKNIm7EIPRDLnKLvM4l7dCTr1I83fMy_wDcpnFyNLU9cyCmHUw>
X-ME-Received: <xmr:LLNLarxl3RmMbO80ftN88T98zlBaxjMIehNW5r49XbEXI7SE_Omrq0onUbJnVA>
X-ME-Proxy-Cause: dmFkZTFPCg2xwzQp7+TI1AOZhFkobdSqGL70wE3j5fYy6KqFBfnJe9khnAl2AW8p19ybla
    nOxVA4zszBab8zr8DAan3yxr5qDfbWaQ7hJ0NV7b2cJcr9Ntio7u6fMe/SZ1Ow14Pkh5HQ
    ptUJ0KggNDTKeDH4n/Q8AE5HDb09nHZevYvSsPVBfKaw3cVqEkr2CrDDSCUq1GTSqMO/aG
    6e/ngxiV+iKUWwq5+HTbtOtYYZzjntsgrIYdWQZizB+zForZNk1430IEoIqJTPzK7rMTXz
    j9+5K1gVmvaC34Ge54Wnv2ClsmAUX1jFs0jgre4VbvtAv67OuKOpOjIvce9g2h1Au+a7uE
    buz2uli7Do9QfqtwyDqctNlSu9PPCnpQXstgQalTDZQX97AGfYP7wxZCaGRmbH2gwAVA2X
    p14HERtrYr/w2iXgq6STldHNMj83l/I+f1XqVLD7zSDNK2GZhog1REBHU39JN//wV78I6Z
    12DjItb9i0hZohCsrTwCrTUhdt921TbetY78X4V+jjYkgRDselLlRCtF11IufQgniTyYjl
    RvUSAMyyOdKT1ZxL/5SaRZa94bHBD5DaXWbrmqbgb+T2/EJVJLSoGm+BEapk5py0GMhghP
    UgKUHY+7LrgPaDz+WRbfe6L3bZDgiwRKevb+1m3aDsdTKYdJ2+lTMcMJOS4w
X-ME-Proxy: <xmx:LLNLakxVwn-knlQW7wbVuPMHDMIKU8yy926Qd4EYpTMqG4dbHlXgrQ>
    <xmx:LLNLat8niT3RPiXgA6o2nvGAsuZaeIBLErg4ISpzTl6HCeMn7MGVzg>
    <xmx:LLNLanhmJdZS9kmbpZMRmxOmmPmpaCvJ0dxl1KoWKiJsSZEzoBRR3A>
    <xmx:LLNLagWrHJbS0-XoWcWwwboXd5ZUmXB2neZykJLtexUwM92w1WYwqg>
    <xmx:LLNLas3c-rN8K7N5YGo-PdiyItlVc3GSGJMIQzly137JJ3QVI0UjPaF_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 09:52:43 -0400 (EDT)
Date: Mon, 6 Jul 2026 14:52:42 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v9 11/15] mm/pagemap: add PAGE_IS_ACCESSED for RWP
 tracking
Message-ID: <akuy09U-g0AKSEfy@thinkstation>
References: <20260706084805.8400-12-kirill@shutemov.name>
 <20260706125726.729431-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706125726.729431-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3FDB1A0006
X-Stat-Signature: g4f8rsj79gj6s81gqr89eff665uj5dze
X-HE-Tag: 1783345966-126658
X-HE-Meta: U2FsdGVkX18/vDy0ZbRFWiKhK/oNmMghG2u6NqnAcSuz7TXwMNyRBdS0faXocPw7nXeqUe7UmO/HsQkRsBneenp2FPzkdUpBqJZngI6X6R+f+ua+76KLtu6yBialMM52mwpqsUtvex4bRPmyw+5PQcnF3CQ4bbQPyvcjVFWfkw1B9tAvmf3EX7zBkmQGpYE6KiJQZj9iiAbRlKC87uwF6J3Syr+op2tZExQsCYZXfmpKduIa3M5FmBHQxuBNcQFEL2A87x4IXS75LNbYc4ccrf0m2eqjMOQ8OsgeupmIRlhPh6bFPwsNgQ2QtD/jVoWosK5tNVulb2vma7AhlIeX97tWP8UbILeTj0BFGz+Ym8fkamuw9TjXnhx0WPQsUtkfs4Btz6B0tmilcl9TjvGGh4o0qxdMQUpOD0L3iRBKKWS4D9Hh7Hbyh68Gd4cr3DYDVTQsnfeisVrZdOzgQ1Xk10+9aZ1gaUyo0T7T7uw53VsRoRUtF4qKGXUegT18dmQHET3OyFVlYJElVixI7VEuPyxs3dcP3A/ZbkJ3J0sp/4VUjqwnIbQ8b2uXnKP37RRT97z2X65rLSzLPFbmqBc+i3lADQFu6UZ2NdlUeI1K7hW1jDr9otVkt5s+MIcpqyxsXeowg/U4ljzw5+3Pk2aHsTA/7QWxaf64G655f6mkyqEivHUPCWCOspRe1iDp24mtniXMcTNLQqv0nLNpyDrS0NYDs3eXANNZXgp78VVVKQ+yLXBm7rkYdrQz1bwpzkb0CNy7sbdnQMYLZBRK9z2HKsX1CovWIgBMLzXDql3MD5Er9E5xSMQg+eWExwXLY65M9LqAnekF82DQoW/LfMujO7lN+r2S+Wja/X7yMwB0wj8+qbtPWgF4Yg4D6FrkRfeDRi3z0Z/43mWGwb7RLklHTjwzRq6Ea8Nc0IURGSDqsSK18jhGL2RLLT01ODJUQmAjeCnsoru3EYcOBSQ/lbg
 S9YkuDoq
 UZdAkjvozZZjpoyT2ZEvpp1E+sIRPYQYhFE6rHa4uoXc6UtV48cB7XjHKEEgGo6uwPXT3hnh+V2fS79EnQwMuTwWDO1YiOFh3uSk+BJkkrQu+c0Tkk++pt+OaEVt0pzcJSWUDREN4+6pVxQy6S4yj6VLQAs2y9+lwgwLObe+f8+5+QrcBcwXa537n8f06YINdIIyAdiGFlolpNSe2J+j0j560ZJN+qoeQyN5FSDZsJLxZmdDHcJpMRYE3TqYfOfL93n42mUCxZr1KS9T/oZCgyqAhotyCYMSU8Xci9hz6D4hyIvPttR4KOmut/UmZofc2GLZrfpngT4mAYpAYG7ILhVa7evDTmXaWXt+s0WBD75FC1XT/4n2OrW7pz1gCyNolI5uJUbM6M2urMujvsT0mCv1Qu7U8YP4Ag+Gi6XKzbpj6iZ5W80B1E//Klzq+qaH+esbDpWUdbTXCH643H9mR22bSWrfEr76cclMW/y4dTHdGMJLJqbFV1VuM0429WvEPSdjRbZorYU6za+Cchg18fHSWltKIJ6RKmeeLtA5tODRk8IF4M1Ujla2oEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 05:57:24AM -0700, Usama Arif wrote:
> > @@ -2443,8 +2443,12 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
> >  
> >  		categories = PAGE_IS_PRESENT;
> >  
> > -		if (!pte_uffd(pte))
> > -			categories |= PAGE_IS_WRITTEN;
> > +		if (!pte_uffd(pte)) {
> > +			if (userfaultfd_wp(vma))
> > +				categories |= PAGE_IS_WRITTEN;
> > +			if (userfaultfd_rwp(vma))
> > +				categories |= PAGE_IS_ACCESSED;
> > +		}
> 
> The above is an ABI change for existing PAGEMAP_SCAN users although not
> sure if there is someone that cares. Would below be a better alternative
> to limit the ABI change?
> 
> if (!pte_uffd(pte)) {
> 	if (userfaultfd_rwp(vma))
> 		categories |= PAGE_IS_ACCESSED;
> 	else
> 		categories |= PAGE_IS_WRITTEN;
> }

You're right that it changes what PAGEMAP_SCAN returns outside a
VM_UFFD_WP VMA. I think that is the intent rather than a side effect --
the commit message calls it out explicitly as a UAPI narrowing.

PAGE_IS_WRITTEN is documented as "Page has been written to from the time
it was write protected". Outside a write-protected VMA there is no such
point in time, so the flag has no defined meaning there -- and the
current code sets it unconditionally on every present, non-uffd PTE,
which makes it a constant duplicate of PAGE_IS_PRESENT. A caller cannot
use it to tell written pages from merely-present ones.

Scoping it to VM_UFFD_WP makes the bit mean what it is documented to
mean. A consumer that read PAGE_IS_WRITTEN on a non-WP range was reading
a value that never carried write information, so I don't think there is a
meaningful user to regress.

And in the unlikely event an actual user turns up that depends on the
current behaviour, we can always switch to your else-form -- it is a
small change and keeps the old value.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

