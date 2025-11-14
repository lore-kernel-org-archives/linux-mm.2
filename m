Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411D5CE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A5A8E003E; Fri, 14 Nov 2025 12:04:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B918E0034; Fri, 14 Nov 2025 12:04:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649238E003E; Fri, 14 Nov 2025 12:04:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43C868E0034
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:04:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E962CC045A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:04:38 +0000 (UTC)
X-FDA: 84109836636.28.49C048F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5DF62140009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:04:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4zz5ZeR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmkGOgnl3lzVVMZao+EOw6oK16wcWquPYMJhUNT9Yfw=;
	b=nUF6H9fSRplF4xr3KbNpm41ZmAEQJbfi02Cor3dTqnPoecpq7t6TyxaYIJjVJr5pnrEhPe
	jOS3kkSyX5f9yWZYGRBo1ZjIAoqGJJLs6U9D7qHn19v2j3mD0xSz5ZBAR/nlQ+ms2WajQB
	jPdF+RMsT6nLDS21bQsJBRkEh64Epdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139877; a=rsa-sha256;
	cv=none;
	b=aQmJmcxoXZZAp7Dm+LAQlt5e/kysJoHo0VkPkUuqHIdcaGyHnRhgQrmY5xoGWtMZQ2b3cQ
	r0iw90cjalEwKhgJdzZAW2/l1xqAA71FjfynFhdXUdjWHKHJWTCKGxgnPUmux4UqNPQg87
	RPl7XHNzEH8QMILS2ox66MDO5gKSqWk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4zz5ZeR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB3CF601A1;
	Fri, 14 Nov 2025 17:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453CCC4CEF1;
	Fri, 14 Nov 2025 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139876;
	bh=wLxrgv3sUOLNiDmnHHWigIAhY0EhWAgzWSDG3kdvF1Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=h4zz5ZeRaWdLKj5ZUywCVx20N6rT/1NPuF19hRA82nQZkaw/xIZpxHcPUImLnXdjb
	 Az92XgTJNNKawV8Wqc1OzMEMlpRbYMg3tVVh1y/PLxq3PpDvGflLojKtICeL/6Yza+
	 UXiHi5bHKk+xvlZuQShfy2JdjDlYCfV+6ONP/iZ4rLxTSb49eTTtIPsZpYWEsghWYe
	 KUXfoLkEr68Jh7+PBn8Dj1DFefacL43z5wNGb0LR6IbsUKhdw9XUN3b2QuhT23y/ly
	 MpdT3sBGOlNXhlcSLOpvcTuRrjLiActa3LlVV+oGJdSV7B2nBP/FFkyqwQwlBBU8N/
	 iCyYosA4CzMcg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 06/13] kho: Simplify serialization and remove
 __kho_abort
In-Reply-To: <20251114155358.2884014-7-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:51 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-7-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:04:33 +0100
Message-ID: <mafs0ldk87dge.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: b5kmtntow93cojg9fbzhgu7aark7y79j
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DF62140009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763139877-582605
X-HE-Meta: U2FsdGVkX19Zlyf4s7HI9Fb/gaaGvttsyUIkGJeL2RV712ntn38vxi//Cl9W1UXbzW6tEi2dp+bnegHqHS/oc1yYa5bq1SYEHcKp1fuBF7HkK3bUo3UUOcNW2+HzTj4/R6mt6on9g9+cavIoAh4XDsLoWtJDF9jpW+4+sp3rcCqhYQnYFG0rAPUa857aGnDvCw/Rv4+iXvjz7i8iuC30x41g59COFMwvCKD7G6TgAt0hPMvnSGC/nTwTj42vHU0SN3UyPNsSFRJq6TDlLAkv13jJELLfjySdWlu0iSf63XqqK0GjcHohQKJzh19+I+sTXxfhcfjCdb3ZFuavV33pm0z93NETlfBDHX3rHM8ghX4Bp5Hj8cVRI1cO5kwB9l4pSDjwnjGJ+fUK6i8LyvQI/jr0739NoAqCS9lCNdOlW0xJX6jFN2XrK1sZ7M04VbGaZJbYUGbioKnRrkgqEBo60UNYQsBTrQrQ2iCd4wppI/KHNDzFFhx8nS0/yxzUxATjtqDx+pGrdJ4pHVezPoGr11YAqspY1RXSxyQ4CsIm0Wmpvdg5/7stqBCescmCBQflcwBJEUQTe/r5X+raOv+pJHJs5HmZLy/6lwcT34zaC7lyLP5ZvRd0gtVJ3SSCj4e4WmFOCw/5b45r99o0SSq7M37MWbLnZg9jcreLIlucP7IDC6/yoJWhBT7sHQFQv0jht/7KNZoCCqu3xSeo2wfZmG8J//7J34b5fbTOWYbsfntrxBCZwplrdESf1l8Nc7ARpxjeo2JQ5gwCa2edc8FTIGEDBdavsZ//BfGO0Mu4i9iDEyvkdbTGc6A8Ta7Hxlpik3++5s+EA2IZeIB7+FfjYpAe4QYu2dEBIedW+zkG7KFUs6IO4H2TIPxkxyjCb9Oa36Pu+nsI8ijdvVYlyWY966VSfuxVckjBjo7Rr9811ztv+IAW/rUiA44Y0kkKqleJD0CN+uuUmhzSGGnlXsM
 xA1q19L3
 3avGTiCVd25wqj5vHuhR5wH2b1Tg53WmyBFjAqSMVV8bDDTBhb3vG+KubDyPPVLfrI/TDsEoqtIdh0cIxL8XOgtrD0dH2A028MHX9ml1ipx/jIfAJMEvkscSAHGkJ5hWUiHgf/KAP2ACgcyMQENGMS/dNzKN6NkTNOumri+xYMOrgIWj0RsMd4Zw0dA8gbOo31J5eBYvv7F/KORLq5pgCAXANPGY2TFPy7kVYWMrNPJvgb+m/4GS0+LqZgB4QqWo+xy72/fxP1hfKpfGmDO+kEED0K/jHVlZrlBKgtdzrz7vo8RA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, __kho_finalize() performs memory serialization in the middle
> of FDT construction. If FDT construction fails later, the function must
> manually clean up the serialized memory via __kho_abort().
>
> Refactor __kho_finalize() to perform kho_mem_serialize() only after the
> FDT has been successfully constructed and finished. This reordering has
> two benefits:
> 1. It avoids expensive serialization work if FDT generation fails.
> 2. It removes the need for cleanup in the FDT error path.
>
> As a result, the internal helper __kho_abort() is no longer needed for
> internal error handling. Inline its remaining logic (cleanup of the
> preserved memory map) directly into kho_abort() and remove the helper.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

