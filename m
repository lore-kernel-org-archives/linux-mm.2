Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85921ED7B9A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC7D6B0088; Tue, 14 Apr 2026 06:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4A06B008A; Tue, 14 Apr 2026 06:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCACF6B0092; Tue, 14 Apr 2026 06:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBD376B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:29:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82265B9A8E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:59 +0000 (UTC)
X-FDA: 84656790918.01.96FEE49
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id C7995180003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nFYlpAcO
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EW3Ch5R6PoJ9WqT8OIObJ3ll1Aqj7CDBKj5ebouaGqY=;
	b=OPl/3TNaYiPwEolWcFInniaSEu9hM/ta3z/GEoB0uuwFgiYWeXTevT6T6SvIkLheinK0M3
	aZ/EMPEuQtJ1pYlx7x7vMQkfrbKu7AlZoPpt7MGsCXo1rET0/E31nFbBFvaEjQ4lW7UOYF
	qmR218RUGPY89WNoSD7H931vhFTpySs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776162597; a=rsa-sha256;
	cv=none;
	b=rnz4KUinwCWR89BsG8LjlVtGMiKXwvDz9FAkaSgV8FRKchk1tdJ21bTlKRB/9Q8HmO0P5a
	3Z/ae3C2BNRb7SnnrGLgLfRYsn261IgwS/a6nKqozXtB/VvyJ4JpmoQro6jjhlKP0gqURK
	Iqe27uorf4217G5mrXvzI/bByeQiCRE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nFYlpAcO;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=EW3Ch5R6PoJ9WqT8OIObJ3ll1Aqj7CDBKj5ebouaGqY=; b=nFYlpAcOdKWY/6NjfJ5sKtZn2+
	yjKajGrt+KQDVCoMkfvpp0m66hBqUp6eX1iFWPl/06IEsLZ6MA9+kAsqiUDYrfMc+mWHABw6luu7o
	SXIjoXXcCLV8fFxNTjwcvlIn5E2iVSrOAgOlsircvQRLnAsvWyeq7dBh9lkFuKcgsJ0R/wSkgYzYM
	qHn+4DyoA5hgvYpkvNSX99YkhgQi5VJjKK/yY87vXgkCfgrRbWaAx0a++OTy0BIGG2dotVDqEEXL2
	yj7SFm9+QMpYQyqJh64M3yVXtkcG66FenT8vXCfyr6CeHrCw9X0a+MPfPGZxvlRqyICx4blD4CoDD
	lXKFA1ZA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCb1Y-00D0BU-15;
	Tue, 14 Apr 2026 10:29:40 +0000
Date: Tue, 14 Apr 2026 03:29:35 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, gustavold@gmail.com
Subject: Re: [PATCH v3 2/3] mm/memory-failure: add
 CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC option
Message-ID: <ad4VX61uLf4NA3zA@gmail.com>
References: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
 <20260413-ecc_panic-v3-2-1dcbb2f12bc4@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260413-ecc_panic-v3-2-1dcbb2f12bc4@debian.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Stat-Signature: 7jheuoapgue163bn8yabiwgtqqngqjg9
X-Rspamd-Queue-Id: C7995180003
X-Rspam-User: 
X-HE-Tag: 1776162597-703409
X-HE-Meta: U2FsdGVkX1/CmGEAg3y2yTEahYwzYYQTFiiWp7BuaOFxRNj29c+xKDudTjgdu3CD148xjZZzYLdWoafOeiOYbylLsQTFO/+0mDXWMl9SWy7Gsc9Tb0esx/BwQKanp1nh4c6eie62mIPN6N0nlwJoDFOTUj1Nc/Cim1pFmbN8ifN7nwHVWbKTQdQAPTfrn6kLnkNftvEX/MowVeVeXtnUSpfSLsrrqLIpQj31/jyx/IFCdhDUA+2NXVP35pE9jIMa1KttnbO+VGiMsnaSZTv530JeuZH3KNjaKuhMM8tyHthtTHpswSdPTgpQ6W8ZPkLqsajvcD5tyUT9j2PzSA31i6eCnXITFqgDF5ALatH6NqeqtogOBGy/NFYvITHMLSFHWyxE9vNXEoWg/WwGZConptzqLmCvqvRbApvdOevo2DLA3Xwv/0JYnyR7I6eViaIYI2sN6AHsWqF3F0wbmqbz6dq4C4FqCGMCcysKBkhzoEAwSHtE7LJ1WKDNU8Y+2bkX6iA/cbJoxNlYZuej7JA5K05Fe0U9XnyQPmU+kS+7mJvgQ5HVogow6yiPa/dKTheoIF/0p1acIVQloZNiXP7X84yxiPxuSwQfvQUCqhVCHn0QnPPrM6n6j5vnaFW08YuoSebHHSUvqL61IGum40ETAOkxoXskNWwTe/W2WEkwWwKmKi5brIThdPzsIBCjqCMrXg0g1PHP4QiDW8ncaX7OLevWJbRZWT+bPHDo8M9s0IKY4HXDbU7eeN+YmQifyqgXMrAEtRccGacJREWReZY8K7AjPWBez+4FfjAyPjoOtiyY7ebATLShGkEwwReQs3V5tUSE8wSVKt3sXVpSWjI1zAF01YQGtRFxsmhBYNJWf/TmRayvlmK3zmZiNIbubqzmlhG7GouclEfgB9vcCrg/suTCyOf0wfoIlNutptEJf4dXVCDG/YXc9c71yYa+pmUvERS0cQF11f6zSqSMyqL
 GfSibywN
 Fv+C6pmW5Mxt/iUrNUvVwyWxmMH6IvCeCBY9b62dxHdLLT1UJZ08m6mOIEhbICC4G3yHa7CDyl6gFOo8S/pQIrmJ3nHS0FZTtb62XpKdLWszH0RAqRgfHoPdbOOfaBfckQZoRk/set8yYc+IOJPX5vliMf2KHPCSJmOzg2g8hOXdqkHO2fdAaIK38sGn8cjsszKEIeb8OXmWFfntw6mCUUuAnROuFAu0ztPI0ACzeOLTinwtZqvC/i243gZ1Sx1xvbrM3bRSnpgYtjbjlWDbGsIiuQPwAZF7SEYg+n0aDi+Am2oYcndJ8F3X5aq080L+NJHWG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:26:34AM -0700, Breno Leitao wrote:

> +config BOOTPARAM_MEMORY_FAILURE_PANIC
> +	bool "Panic on unrecoverable memory failure"
> +	depends on MEMORY_FAILURE
> +	help
> +	  Say Y here to panic when an unrecoverable memory failure is
> +	  detected. This covers kernel pages, high-order kernel pages,
> +	  and unknown page types that cannot be recovered. Can be disabled
> +	  at runtime via the panic_on_unrecoverable_memory_failure sysctl.

After considering Linus's recent feedback on kernel configuration
complexity, I'm reconsidering this approach. He recently emphasized:

        "The kernel config phase is probably one of the biggest pain points for
        random new people trying to build their own kernels, and we DO NOT ASK
        PEOPLE STUIPID THINGS." --Linus

https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com/

I will respin a new version, dropping this patch from the series to keep Linus’
blood pressure in check.

--breno

