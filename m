Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9BECCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6EB8E007B; Mon,  3 Nov 2025 07:59:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF128E005E; Mon,  3 Nov 2025 07:59:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBE08E007B; Mon,  3 Nov 2025 07:59:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD5658E005E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:59:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D52C1A0136
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:59:27 +0000 (UTC)
X-FDA: 84069301974.05.882ABFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E1E7040009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:59:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oY42H521;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762174765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdJJzIMhSpHhPvC0upL1LjKHD/WTMKMRTGZPs9lUbaU=;
	b=Io7n2HsgGKksR72ipj5y4cSe876ix6lf40kmHtw+SIC0XQaXzpc3N3l3yK6nZfWcdGcZ7r
	ReRSBy26ugumnXlbPmgoi4nlflg9EJhijFBA5ljKxO/MLOTg26zq5QdVKkos/EMrEX0dc4
	r+t15j1+b19x+BpnpkrZBkJ5iLNzahM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oY42H521;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762174765; a=rsa-sha256;
	cv=none;
	b=GuSFCDuz/CAyAjx8Sa9XYvTEZNpU6+RbF2oVYNgU8pZ56J7oALfxvRsLcDHf7224+RPdsi
	MOXXHa6+fuj1jTIrfz+IMbYRJWkp87f4TLJT1d6sFNpAZa7IGAL9tZxdZfKqVyQV8Q7qzb
	lulWNED8gKpeliROZw0jmy+r0jS6rAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 176BC600AC;
	Mon,  3 Nov 2025 12:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49628C4CEE7;
	Mon,  3 Nov 2025 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762174764;
	bh=MDaNcpqSBRCQYr6Wbo2CVleFilV3wzUK5ugsLst5xT4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=oY42H521Yn+pOawY02ln/CrSRSLuk/RGTyh60MiSOfW31GE4RkrNH24O4273FClhs
	 j3cOa7/batoDl+c+utfBg2bFbpgaBZEjPa2C+3Exd8sdn7T46GE6AfDGn4oZInxCVl
	 AEje3gcExkCYqI0uSIDPLXCiF1UoaDqxn73PFGmUVz+P7huu7XAyGb8j1b8I2tzUKK
	 z64NU+i0nElDX92pUmKbbxvn1qgxCsoNU2/Rk/pttp2qLu5NL/VKLspCUZTtAhM+hd
	 jzqukYeEEZmzp3U/EERtC5HFPtnuoYzNty1QSPuU3cADVRJnK0Fh1DrpwtloDaIyZV
	 dgq+cUVfCWNtQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 9/9] liveupdate: kho: Use %pe format specifier for
 error pointer printing
In-Reply-To: <20251101142325.1326536-10-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 1 Nov 2025 10:23:25 -0400")
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
	<20251101142325.1326536-10-pasha.tatashin@soleen.com>
Date: Mon, 03 Nov 2025 13:59:21 +0100
Message-ID: <mafs0h5vbclw6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1E7040009
X-Stat-Signature: mta3emduyp7biwx5iacar9qcxqw59ebu
X-Rspam-User: 
X-HE-Tag: 1762174765-789977
X-HE-Meta: U2FsdGVkX1/ysGtJVUcn0uOp7bo1PyjaEYnRgH9m68qmbK73FY2rFy3I2w3Fyv15u29xvEPh5sctLBl4oBTYKhs5Ibpgy6xfnAFMWwgbAn5EokIYJx8S/9WYmWY1y1lxptMqhZSQSnnoXvlLz6xowqt1ApRB2ZH3cFwBSRPXjv0n1vdRdZgfkU61T7bZYlKdmunxujdpdGV0wy/Rbh86PuTJJpxbJu8q6SYK7GHyZdnKvyz4gPA1qA9frB0axasEX3yKLqywnICne5nRr93eCAds22kBkBdB64S5bRNM48ba28+LurTeAD82mOv7yx6idFmtBvpRiAQuEED9otF7EZekMny+JFdXDuJq6y/7c2etctMuUIuVH/6km4gUurG5NcO4WVu9fIWLjbaFNkHtLV0MpUC5cqcQddODy7nhhs4RsLkc39x0pKubML//yDpL9zmuRxplNCaUWk/r9hOUFhprpfEmFyCEHwQKdMJERGnXk/E/1rW0uQcJkavY7rstgE/nEI9389B1PtWuKjFHHmAYRh7vS6PkTy5U0yu2pFjAqYEcyRy9CeIPpD1oNsAnxIvQhjjkM/AfyeFGAeHc0e7ImiTDjJlJl8uxc5EMY3NlJ94dbHm8XD1iJ9Ft6shFrxNa39TfucT0Mn0aeNApPZrHoQBrH6fWBQrW1UN3LJVaGH3iGhgFu3/gjCeWe+8hRYvc8pHXyQG+lQ0O7OD7MXD1diW+6l9oL9SEgoshMmERUUWRP5ve/jtj/v5ICLISIMdId7dWiDtgV+exGdQge2w3gyosAr4Vrah344RmqLCGXAzlE6CDwwlJj5OLNh3RKSVX+FZH5seUki9ySPe37K57aNhqPJpi3g0Uk301z7Za7IQICZq7SbR+fbffb/5JXV3VVZExTTk7kQK0glOCvw065Meec7vRtYo83da9QTIrgbFDHDyzsamggRf5vp/3rKh79dxw5b/vCNIMKA4
 WKosgUGZ
 cx6BQlDjVoEiNRpWPlfNM73dpTjB6RXwwhuYbUOYS3c63QpXdz6cQSTRPKdmg3A3Lk7xN2rrErqy1yjyDbSAo3SVaSCPgT5DvHFctwmHN+crn21BHA9ChLLLkO33rtHxvMUqxwLqQt+CAzF9zo/+JoB1qdTU0oLk8t60LOMOk0xFLzZdt1Flpb3m3RSHoVlv8D36uSgM757fi+ejjPn3z+335lT9UaoT0mDj78UYxpFogbJQ1GGWoa8/2NNlaRPUYm7Fs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01 2025, Pasha Tatashin wrote:

> From: Zhu Yanjun <yanjun.zhu@linux.dev>
>
> Make pr_xxx() call to use the %pe format specifier instead of %d.
> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
> -EINVAL) when given an error pointer created with ERR_PTR(err).
>
> This change enhances the clarity and diagnostic value of the error
> message by showing a descriptive error name rather than a numeric
> error code.
>
> Note, that some err are still printed by value, as those errors
> might come from libfdt and not regular errnos.

There is fdt_strerror() that does this for libfdt errnos. Something to
do in a follow up patch I suppose.

>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Simon Horman <horms@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

