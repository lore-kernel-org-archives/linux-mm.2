Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D3BCCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 17:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B558E0005; Wed,  3 Sep 2025 13:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363098E0002; Wed,  3 Sep 2025 13:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7338E0005; Wed,  3 Sep 2025 13:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4908E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:24:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9B34C07FA
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:24:50 +0000 (UTC)
X-FDA: 83848613940.19.BBD76A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19D31180014
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:24:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756920289; a=rsa-sha256;
	cv=none;
	b=CR0NEAPZkRu0mdvMFRmIgYdbC+bUuUfChs57b8npIV60c10li3Agw1S/jHWlQA1SQb/nnb
	9maFXtCgoeu52D0FOtbtOSzq6fuT5en32NNr/SZuSWA3blEOekvJixMvTRWq8Yd6yG3HwD
	CbB7TreBWEjix8z2GNfA/0MAKvEZEzw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756920289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7oxhoZSM+B4HtrA7PSQ9LgwnMRwFbsVe5ETuJKraVDk=;
	b=GwS+F7LY1kKTd73fkiu0iurWTMs90lTPr+5KaOjqPh5afB2QhWatBXmeODAJ+Tk9ej+1pI
	9TDA2KfTWR7RnCljJ74knTZ+TGhrpQWtyKvAdMbaXnkv3mubIwEheTvL2xqtWl9eRfIoVf
	xFgDq6wQ7cMzPOxlWhuO0jxsYsJPNjk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C34C6013F;
	Wed,  3 Sep 2025 17:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F5C4CEF0;
	Wed,  3 Sep 2025 17:24:45 +0000 (UTC)
Date: Wed, 3 Sep 2025 18:24:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 2/6] arm64: cpufeature: add AmpereOne to BBML2 allow
 list
Message-ID: <aLh52smiWpVMCB6v@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-3-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829115250.2395585-3-ryan.roberts@arm.com>
X-Rspamd-Queue-Id: 19D31180014
X-Stat-Signature: mdhea981tkh4j6hrkmn87ioxbufzpw7j
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756920288-675506
X-HE-Meta: U2FsdGVkX1+04GVD26bm+fI+7ovtISxJ1xyfydeMdMDNsUPbQsTAhFEZJw0Yf201GW0aosgTHOJxneMuDrRt+2+Y0gfSjaCWSiCypILaa8/V/FLl3A6nXcwkCIQ+k8g/jjIDrD0EkQj35CKMOIVGtR7jG4GlhJRbJ79RRh9S7621Oz/y+M5JLglaSuMNmluCw/qzG1YQC2V3fLAJEFCd6jV8DZRQW+nyTo3WNCXQjGV7MwYSkpiKSlBsgzilJtwllb8gqiyTWUophT892tahac60W0zRjBTE4Bwk2BQcAb697SlPzlO39/eb/kKuCwJab5nHUtM4fnl74f3Zj6siokPGPxJ56LEPCzMxpz/nNFDLvAtOSy3kYg8F7Jj2TZO15VZdVh81ltbDZ7Tj6b1uRDa8xQ56qNDwQdYqrPnP8yT++2s80jf1rI/ImQV8/qMr8jP7AZGi1XHaO11eda1Qz9zk2zFDkSfpe277daBw7Sh6PKS9uXzSwKAPHQBnVDXY7wQ+1TvJ6fxZ8btN9hrUogccaeKRag3swJf6LBEspTw0t1OOPKorWdAMtR2qnuwokfSha9EnCQajwK4Fhe7S9cefANvCSs6da/7fr4c7CcGmImUosJYRb8euu4EcEr2kLUcjtRhb7L935ZhFrXkhAQLpsxP6Vro6xUwXx35Zh1hgYQzv7248WRc3F8s8m4n/3FD2jU50YolY2tWu0KbPMB3jzv7oUzyHBR6aiNskLMIz8WjMkk8yTF/fDZkskK7Ku+vY0EciIcf9x/7R2SV8BbfP3LdWaUzQHbFhth9wVdQzGNt2TpxmgplPM6wDl/AADDSwNe9GExjhdBVcQqCzC3V4l8hePKhhIiFhA21TP2lUaj2OPr7zkb/0XE9naQ4+GYUXriJgrfY35iqefQEAhMKULMcSSy8i1w6LEe5WZKSrROylu0p9TiaxnYD/UZE+u/MyVgD+fStAIP051BR
 ZFDdiJrl
 dV/mSz0ZGn1vkDprMPktDSWAJCOE9j5GAduG+FHeWF6azho45TlkT9RHTrl6RFcn3F6BoSyGtRxySsKvu+BUvTEdoONBmZBYDRNQpJp4pvzetVrVxq9lt2iUCQOGCErZM4jXvMgBTOeXwUC4BjLgfco42M/9aRF3td+dtYc6uvAB7Xo9d8Pkcrg8ZNBWcDP/koEHxxRKj1DkYxo8X4P7Chl38Xnyuu2T/UKyBFMjWBvEo3CMe7p/iF9hoSWN2TxFs6GYJ32QpFY22B5Gamai97Up9FSSiOWWkSnhRsYtle+X6zAqtvJpmcmElc1sfiUZpd90fS1KqsckmyHk1uwVkxk0SH9Z+LV9hWp22XZhpdQRnfWY4kZJIbBFAXum+OurGjvjQ3kfkkm2V0upwtZzNCbB4DFqCNu/gHs7a8duZ6ylwjhLq2SKzzbdVyRafEmIbDG77f9ItTYtw9vqnV7x/CM/WkuqH6AFyt2fI1Z1zcv74P2a43upsT7h8tmOH+QLmKdJSZ5MXsiHEqZsWq+tLiA1vbYVucTaM91NeMQLpBPJkRMVfSdImia/glw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:52:43PM +0100, Ryan Roberts wrote:
> From: Yang Shi <yang@os.amperecomputing.com>
> 
> AmpereOne supports BBML2 without conflict abort, add to the allow list.
> 
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

Here it is again:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

