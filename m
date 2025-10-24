Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE21CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DEF28E00D8; Fri, 24 Oct 2025 12:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B69A8E00C9; Fri, 24 Oct 2025 12:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3EC8E00D8; Fri, 24 Oct 2025 12:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F173E8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:44:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87572C0F44
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:02 +0000 (UTC)
X-FDA: 84033579924.21.DC2839C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8C17180003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sxh+zobt;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761324241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xgx3m3BUKEgvrqfTgwMq4kCUbClDlN+3bMLf2jmW9aA=;
	b=L5jEluUz/kPncZmAISkbtuY9Tq7YIfwlMRrww/fTJHKyFysrf7FaJyA1rzqYq+mgVCbNXl
	8MtdKG3bLL982MddmoF47AnVd/SvtLyheXrYzlQzSZEqgks0J52LYeltVjGLBgkyidJeLB
	IUuIYFI5XdQMA1K8JCLI6vuR1rAWwcA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sxh+zobt;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761324241; a=rsa-sha256;
	cv=none;
	b=h7UH1/0+NpHxbmyV32RGRV31H2pSCqKlYg0WAo4mq1TY9xvi3NSTWk/XUKPjY6b0dSOgei
	feF0zpdJDPrpmdMnyBrWAjbS4FD6/YrUvaoi5WI0y7fNgzYawauIc5qGwKc8M68E/lwKrB
	eBTw9nMxCj0W86CZlATmHpjgGauzi24=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB15B440A3;
	Fri, 24 Oct 2025 16:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90494C4CEF1;
	Fri, 24 Oct 2025 16:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761324239;
	bh=6wsAeq8NmsFB5M1le8QxIbGbQvgkIjtIBo3EHQtqiNM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=sxh+zobt1sZ6r7fdusWMcQ9a34ICY3fKF0DU9+8P3wIb8rWNDxg/X28leHLnzBOQn
	 +D/SWhQvI+utyR86YTZ+cA6xhdwTatlc87cp24QQHM8eN7NaJWnT7PmISbSgxQVQM2
	 EXShaWM5XGz6dCGUPk11QQcn99MbL5Lyefk+mxQk/5z+urV431jqq4WIrAuh+8VOTE
	 lP3voBB1K13z8XVR5AhWJiTBwkRH8VhaB1/8ykSxsZSPPjnvt04B+E0wyZQ8MhvzlR
	 BaTXE/B2imangiup6YxQsqtHq4gG0nv+500OwiyM692wrmfRf4Kxvay5WE9SJA2T3l
	 kgJxTifEsBh1g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCH v8 8/8] memblock: Unpreserve memory in case of error
In-Reply-To: <20251024161002.747372-9-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 24 Oct 2025 12:10:02 -0400")
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
	<20251024161002.747372-9-pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 18:43:56 +0200
Message-ID: <mafs03478dzcj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D8C17180003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mfbubs88f8fmdhm1nxbue514ikxy5fhq
X-HE-Tag: 1761324240-36713
X-HE-Meta: U2FsdGVkX1+8AiYNPq6G9nqOZXUDwh2ZxMALNkHYX6hF51lqNz3pu1I9OiSm5PA9q3EevQ++tAp/IfU7Imn9zvR/k3CkZmFXvwOB42dZoMmPiJQfVmOfBI2ilpHU0+PNNEqW80cQBMkjBEOLh4nEi3bOaYdlJIMnwzKbUD8A9axHbtlNZDiEsk2jke7y70p4NMi5TmXKY/DWp9xGOnbrK/wDUinWZ4kttrnP2/nSDFoon7sWm1ALB/O1sC5JO2Q0VSBpQJ33cQCdXMYWAaPtAxLxJ2Tov7o3Ezhp+ixWSZLrMtJi3gsW0RSPdVa3mnOqjX+pz1Rcx094SyfCUk0uCV4eRpG8Q08mk4Y2FbeQVKw/14seHkis/SB0pqp1foFk2HsqKsnhrxf0faCJoF/3GPJrFGYX2hl+rJLQerum3hnXTmeEK08Ey3Z5LaU1uPfSG4TBTb6t0XvV0HAElsQYLU+vTTbOWnxW53+VJxUxpXYwfrdaV0825V0hqBvlyZ5Q9l0gdU55cy1f2M9vXBX1nxfcWhziCvJtvA9Lbnu8KLUwltgO/IO5VgYTKvAJ31qK+bGAN71ZzREojwdiIIOhK/+LUhbsWh4tIGRKyDI1T0auehhHYyY8wsB2rLYPBL2wn3R9lM8vwCDNX7fuD+gZwYJ5YXBjKSa+SFIF/NIfs7rJm/HGPlMZjRTwWiOjj+PTNv1WY/jhkqRny8YX0u4MKFNem99cCbLt4LrNNRhq4oewosYf4tfFT/ug8hBFD4Eih51pvCdSmk22kDN6Kmaej7AYe33BwiStmlKXUoC9rUgdqvA0XZE/3RuMoZ0Qce8vwkVyTnusXQpsTgU54tmsYZVsoZa/zQYcNKbrDJJi2nDXkAJSPHRop+zYGFO9YQThKWM/mQrUYV8kYZtARYVSCRwD8PkuZ0UHbQJfWaLg/DgK6VyEugnv9JrzZ9//svdojc/oRybz0EWGyqjUeFm
 TR7iApef
 SeGZQ7ip1Xhb5D49CG9E9MRAZBJ9xFUi7fwNfLA+70dpAAh57zSbPZ9srsq3OjT0FzpYwM6IzrioBK3+yNkFIH0dvk8QKkOETfTOtiH1EW4VXu4+La5C9zJIYBcWKd5PfMpO+vC8AjcvSopqemTud2tksJKEmsn2CcXJ1uFFNFxXIxI9bsQQp0Vw10H0twMC5du+k2YVthWu5+oeUd8Bmx9Y0+F3He533VkR1z+yTAA07tb/ZvzMyxlXykVGgPMx9m8Tm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pasha Tatashin wrote:

> If there is an error half way through KHO memory preservation, we should
> rollback and unpreserve everything that is partially preserved.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

