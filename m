Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34484F483CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3286B0005; Mon, 23 Mar 2026 12:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA276B0088; Mon, 23 Mar 2026 12:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E72D6B008A; Mon, 23 Mar 2026 12:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9776B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:52:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2538C1B9301
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:52:02 +0000 (UTC)
X-FDA: 84577920084.10.9F1689D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2D3018000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:51:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=o4TsikL4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774284720; a=rsa-sha256;
	cv=none;
	b=cWHRv2+kjP1AJeDgJyNg1cdYgTAw9q8EL4A/4lO/W/WzJVVGktaVCTFjOiaSmHhh+/grKW
	oV6CNd/LmIZTZ6aDm2brawpadn34xtFkFeazo2fYitLFBfi3C5jdSvumdzyxxO2fHNmLLx
	7mb/D5ue8As114ChegYQol+lTfQbmu4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=o4TsikL4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774284720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+AOu/lG5FJLGR8YlmX7KFaeM98ayrUFnh1YxZgcIYfA=;
	b=FAOgl5/KbYQj12BX+O2t0KDR+/9hv7utkLPh+cx7gpOAMTpkXi+Gf1O/sKv4KKB4UKxHIV
	rkJ5ks2FrNTeu0ZaStmN/BTT2MsfDGMU3ELUI0nQK1ipFyJPumvZ3w1+T31SouYUN5fPDp
	59MunR3hLglTym6EdyFQm+I/CQOlPmk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=+AOu/lG5FJLGR8YlmX7KFaeM98ayrUFnh1YxZgcIYfA=; b=o4TsikL4Tk4to7UNeChQjhrIk4
	UaAWPkpAcNQaRA5LiNanDkI5k9+64CyVaXuTN91PX/4vEqwLfxBg3MB6kKBu6W0/5ssfLEeoytrF0
	cxmSERhOkvXetbBF45GC8g8iQRD7Uw4Eo/gFVAAuIM72M0Va+zWvC3AeRN42r/55GZiZ/ExKtgKZ9
	QXIHDCP+x1779VxDx4nckOO1Y/yFyt7bXtkZQ8wtPHl3QHt2WE4hvFDpWHVkbJvSBK3+Bp5sUBxyi
	VRPpkyVHMnSacF7Ln5Pxvu/QU982cH095ufLI7ax0mI709Wi6DCBH63X3b/CBYHY2V0XHsYAjxjKD
	dNaYLiWQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4iVR-0000000HAh8-0DHU;
	Mon, 23 Mar 2026 16:51:57 +0000
Message-ID: <e046d0a8-b10b-405f-b3dd-94b7f4450313@infradead.org>
Date: Mon, 23 Mar 2026 09:51:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
 <20260323-ecc_panic-v1-2-72a1921726c5@debian.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260323-ecc_panic-v1-2-72a1921726c5@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D2D3018000D
X-Stat-Signature: jxpzxabyrhbddkha4mwnnhy5zt5d8w1z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774284719-796936
X-HE-Meta: U2FsdGVkX1+lRiaIJenqrZVNfCKD14/b7Ayjx6SEl4qAjf4d9S4cZhtXOQpDTiGz0NQZmTWnA2e0XuJbSAsfEh2/N9UQt+bexCxr47LEQKocqYh2l0Yirnhx91DZ0vuBTytQMHeB616q6EvaZGRMoL03zhEo/BgvO76Vbg4Q1FpZ+lE+0Wc9/P5+3qgrqxIncKzcuvXWQYWrBb06teb9AMNa8/zk6GGScbGxxiYZ/QJWMwcRE3xNU6Nj66HVepKK0jZ1DaZ9IIA/ddtc1uohHx69wDt7kNVXIhW/8RZZeY9SE6ktClCiRKPYJsVW9QJmtnaptGPbGsF9dCHypl50dm+E8cC3WZhArIF5d0wlmBHBkhZwMjv6ccjdyXBoS7zED2z3w9V0RjQPGGK6bTCLGb1iQkzaziP6xR2BXLy4/6NuikzNiaeNNVQi2FF3lccZWB7K/EFzZTDwej1VuURHkMRR4IHt0XR147cqJaua/RdopqjbfHQ692OEU1uElqgv+To6byN3OXK9gv9E98QOiXGSbyY3LhlXjx8VHK5vOXMkfBcMKCw9PVQnobUEjkP4DEwQbROu6UIkPR/niZgiGDGUB6D8fAqwd2QcTUhV8fVUxXBGNd2dBPolCi8p3vSrkP/9P5eWwPEF0NcUzvJR9tCFqRrDCKuZNQUUokn34zKYei3PL+c/ItZgAhsx0fj+MEYaadwQ8eamH+bnIlQcUw3kVJUysifu/EAn/M9LAhzotKo3jPifDrd/0hpT/pavXLrSp9mb2DqhgfzrJEmrTcS5azO9/NbfY9Kz5Pz85loF3VPNw2R5itxZfo8hkiqgH77E1nU7yBJ/NxDjRZunAOKfRQuGiKWCpc8AC8EzZfjZdoQMal8vbHLhJAB4uIOe2WuelsTd3h5pCT0IHf6pXxY2hcse+TeYd13pRG/CJ7i0axOU6skBMy3SRF0sZToCU2knfNg+U9ckEmSpYYn
 B0jiK3cc
 dSUpkxA59/RdYsq/Np5hiX7b2zMdeH4rb99JGUj2pJYYYqpb0tWeqPFcy4oViEbpJ3zvYkMWz+RUeCLL6uvmqhSnX8bd26fHw1rG3H4srbOeoXfnOKF8E2nKasa/8LMnlO3rmrz6pEqWzhLPblW77mQozHIJu+yGOy048KRrcn71i5QS3chDXNxQO3qFUT/Y16Hl9zqnNy2xFeRc43HRbcTnJ27GgghOOcDtKlb8n9mz00r/KC0EP+SH9JkoalndxLmRrigpZNtK767rpFdKuuKc3EeU7FiD4Ob0Gp7GsuND8MV3CfBMM788Wpo9DvbfP0ZE7z+otF0QLA/KTouv3PX508sm8Til3De7mHCE+Il3QTvr3pBeGaUeQRO/1RT+3cXl+x+j259WyRwgSQ7xZtuwoYEcbXaIDTwg13pWC51i5wHM+Ao8QXj+Vgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/23/26 8:29 AM, Breno Leitao wrote:
> Document the new vm.panic_on_unrecoverable_memory_failure sysctl in the
> admin guide, following the same format as panic_on_unrecovered_nmi.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 97e12359775c9..3310fb8272fb9 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst


> +
> += ===================================================================
> +0 Try to continue operation (default).
> +1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
> +  machine will be rebooted.
> += ===================================================================

The table begin and end lines must be at least as long as the text (may be
longer). Please extend the =========== lines by a few characters.

-- 
~Randy


