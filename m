Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3D9CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690C08E0029; Tue, 18 Nov 2025 02:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641608E0005; Tue, 18 Nov 2025 02:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530548E0029; Tue, 18 Nov 2025 02:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4052B8E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:34:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAE5C1A03DD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:34:26 +0000 (UTC)
X-FDA: 84122914932.10.3810AD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3F66240003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:34:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eb+3yBdM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451265; a=rsa-sha256;
	cv=none;
	b=d0P54vAd3tj6kF5bgyF3jfJI0XBB/JXj3VctY9Dx/z1SfSdDN6c42ODDLr87badrklVs6Q
	8W8vLn3K50j7LHyEULCT9nghwZkXfM9bYO0NgrqnwBnQOpQGeGiP2uWL5/aKve/qpImFFe
	w+rxUlUFne5GkBxlsVJW4daFxC4Pl4Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eb+3yBdM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0qNEVIv84gOz6OVigRc2c1bT1O0R5SsgZH6ULP0kYc=;
	b=eTxr659yWuPm9H1ZrMpDK5D/dh+aURzc+NFAxCUvmvbnq8cYvYqLyLO1ZxcHUR1v+57rMr
	mxLgglrlrj7EjFSRqR9dEhXEdPnP6FKqKwh/DkOZ3+r+RcZKfoIeX5CYKAIuh1nhi4AJsF
	yb/s/iLiVJAmNcegi9NIkyBRDJYojD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AA17601A7;
	Tue, 18 Nov 2025 07:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C51C19422;
	Tue, 18 Nov 2025 07:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763451264;
	bh=MhejxPCCrkr8+9cFAa3Ny6Qty78LEmY3PR2g/m9qfdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eb+3yBdMlQwNC/MZixhOspKVXfMXpyBUAxpvA5t8yjK2aIGslTnRdGF1LZ4C11+7x
	 oTm7vfLzLZgXE5aW0H430VtEkeZdcKG/9iGg9isGeAaV4QfKOwtqig0ZmW5PhLh5aA
	 4ZtQhXqlWvowrmYwiFO2eKgwADFMwXvEC2vVluYBLTe5IPGpmI7l/jXIADlMwe3RtF
	 NxSIrj4hFekZCHkiwtovyJsBLjMIkL4Yr52KhDq3cinNYQMPhmTJLtwW6zAn3VFPTx
	 T9lDpiXXgpbrcb/ySyPKjSj6lD4pJ906UFJSjcOkY0+WwIjhY3gPzMDfGL25oSQOuK
	 1fqMzUKkF5hCQ==
Message-ID: <11e86b31-fd8f-44ab-906e-019fde89215c@kernel.org>
Date: Tue, 18 Nov 2025 08:34:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/7] mm: introduce clear_pages() and clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-3-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251027202109.678022-3-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F66240003
X-Stat-Signature: emjgziqm9xsar6cxc4aw4iduak6rmimo
X-HE-Tag: 1763451265-214913
X-HE-Meta: U2FsdGVkX18n6kzQEPZa3bKkz0u/yCoQzElxEL3RRkE/FDDmJysWfEFHZqMpVYme0ZALZeKPlVx1XUXqAWlnIgk6HF6zSU8ANocOtu9zk6WEhFh4KlvUirSAdAC5BZPo9SvK/ufmWwJmmvaSp180Ufx8Kp9+BL04GT37wQLPtvnbw/OEQ0XJFa2qkPznto2SD1c3zd0hawi/r3b7qJPb3dDGLoAbAMAmWxWvg4D558FKy+biFpeo4P0XRylLv7EEwwvqVq12wp5clDvJ0ARN8fa+5YJzL46Jgu+YaC7zrcSNqdy4TNqGRNCMRyB+I0M6PLsSukOEMydUaxrMcTTK0j4g+6Vlmd2V9kjgRaVi4tA+KjJEhv4uDBjK28yBsA180xOmx1fnpTjiQpfmg+dPnCibVzEDYkvdQJ/9fMAtKeAThBjFiksaUb4LrGk9OZqSihmQB7amzJSRrUdg8o5urYTOD9p0PpmPuCWkQo9/+y0I4oT08GKPe6nNiBC+4OVkmpL+y58Srm4VDewJwSWfj1tGK9vkpok5p59nEsBwNby8yk4mpPZmlts3/G+m7hZWe+7fdDhtoQvDZTlXZxqUBk+CcqTANUf2UYMYiFAx2LB3Ai8mRWgO/0FFX8mndeEpCkBbJ6LEK4KScbiWMXvxyklXQUZQFaKeJUlGFGCJI1OKOvm+JCiGOT5T2I1M3rM4/wZ0BTGGSl+Iw9iFNXrRtwGco47XjuTs3gbQVCCmZojkXTVCbhZd5+t/DvZRoYIE2VwEeyVJPkIY17h80uEDzh/e0E5HxSmm0NaDHZzOU+LiiDeCRM7sMxZ9t5rfm62VgYkZrRAFYalNXDs/+WLwbLYX0fIPjGElIggCYB2CPGg61H8kl7Dpc1I3lZylGazKXFdyJ/gah8ybUjHE/ElvOIAr98HilI55PoCiCHZcl1jMa5htuskqtUdcB7OAj1QjM0evIWuzKNuA8nwEtZK
 /11s+0R7
 vN/07zwbvduZ1LuwtQpSzyaUL6XXfUDtKe57FZMuijofaxLkWnRZ0GWuTwsZ8neq6leeskW/L0/QE95H8LRWGgpKgb6z33ViUGEUbrXsRoH1TiIdtKYI75ljnsc+MtedJItNFGheZk/kMPwdaeZ+YZ4sDoYT4k/VPhzSwBrCSiea9qxlKmRg1URC42KN0lj9pJ5HGafjN10TjyZLD6q12gwf1UYKmyAJITnNJ9mTHYgiqaaf3RU/Xyth8VTxnd55MVwjG9XPhb2cbsFrxEZznwkmuLSEaeK8QF/edO5QHqf+/VM1Fgxp0kARVELKSDTa//RUld9qvciIbcHDQ9qG/qjdU/PW/ErdBJoitAVgnpnffRZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 21:21, Ankur Arora wrote:
> Introduce clear_pages(), to be overridden by architectures that
> support more efficient clearing of consecutive pages.
> 
> Also introduce clear_user_pages(), however, we will not expect
> this function to be overridden anytime soon.
> 
> We have to place the clear_user_pages() variant that uses
> clear_user_page() into mm/util.c for now to work around
> macro magic on sparc and m68k.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   include/linux/mm.h | 41 +++++++++++++++++++++++++++++++++++++++++
>   mm/util.c          | 13 +++++++++++++
>   2 files changed, 54 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 683168b522b3..ecbcb76df9de 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3872,6 +3872,26 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   				unsigned int order) {}
>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>   
> +#ifndef __HAVE_ARCH_CLEAR_PAGES

Also here, let's base it on

#ifndef clear_pages

and similarly below for clear_user_pages.

(sorry for the back-and-forth, it's rather unclear what the best 
practice is)

-- 
Cheers

David

