Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5ACCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 21:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877F58E002D; Wed, 20 Aug 2025 17:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829FC8E0009; Wed, 20 Aug 2025 17:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7656D8E002D; Wed, 20 Aug 2025 17:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65CAE8E0009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:37:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0758881C5A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:37:11 +0000 (UTC)
X-FDA: 83798446662.08.8848DA4
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC92D14000F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:37:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dHWF/04D";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755725829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6q9ilDeVFJS9UaiGkkkobEHmTsjH1m25NBi5lI7CKQ=;
	b=aspnTusONEn+/yHhmcL6gBouSh4b8t0YiYmPpFGTFTYEeneJnFH7GxGy/H9YZGVZi7a9kO
	U5OZmFkGi7lo/Cd18L1V1/WjMFhbNRDowETsMjCzsHhkOE6YUIEP7eMAkh/YZ1jUkqctZZ
	0VxcTHzE8TGBXubl5xwIpGRYftD0Xus=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dHWF/04D";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755725829; a=rsa-sha256;
	cv=none;
	b=FhGvXgfSiUKUAumYIk7zKv4MPxj8etJmCziJSjp8oXxgEsge6M5dIkaJ69gUrjCyEZHnHZ
	BQ3mNikCC2YL231HHYqZ0DYinoxYhPsxg4At46wJzqcirJk8e/hGeP9rfD6ebI5BDgrXwG
	GEGSQWc8ggv3/yLLdgGlrdqSIW1sIfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CAB985C6B7D;
	Wed, 20 Aug 2025 21:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E5AC4CEE7;
	Wed, 20 Aug 2025 21:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755725827;
	bh=G1jauyIK0PJiSZSgp++rufvWeHOToe2iJQ3gQ4t5BWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHWF/04DWRL3ZlfG0omdacyWLaFYIBj1NcBtMWJhQ05HqjA24Lka6fwTsJiSgH1PY
	 GSt/JEYHuJ1BhubzteAHYbc+M58e2Tiy2YaraFzznRLsTi0Um38NZcjjrE6yrFMCI5
	 QyO9EJbptaImVQKe1CJuhlDNhkYDldwJj7aQh1kI6fpQe81rF8r4inuoZ6bUVRKWG8
	 vp/VYBfgGwVqs66hrsKenAGZ3nsMJwDant45O9PkntvTrwPGRxkMms7dIkgqBcGQYd
	 V8q12GK431i2YLIjEvHC4Sdbh5B+8pSBgYTVyXF1rYtJsBkJqfWaG6mD3c6Sq/YPPw
	 0JsvzThfE+mYA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH mm-next v2 10/12] Docs/ABI/damon: document addr_unit file
Date: Wed, 20 Aug 2025 14:37:04 -0700
Message-Id: <20250820213704.86407-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250820080623.3799131-11-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ktiw7fuxcsx4yb79cwza38wzoznyjzhu
X-Rspam-User: 
X-Rspamd-Queue-Id: EC92D14000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755725828-614219
X-HE-Meta: U2FsdGVkX1/qvJbvv+2kQj9kVbZ+K4ocxIJP5yEX+T01fpYzv8QKN2X30NL285l1Q2t9NUI/Zbmpsm+e8rszrfSO2Sby/Y0++HVfkjUBfAPSwr/HbE92ITBMXSc8brH+MSX5v/sbIW1UK4q6HloWb5hcIUMeqYiEjeVWaG0ke6KmsBWi8XI7xfZsJQJ4zno25G2h1WJxcpDLG1GqerBWC1m7dBS1Lb0QaSAaykYOqe7dXF1HSvMDhpEXXGBWtwRvurwWanb5GQhbJsxyOZuDwWqEZGAhRcldN+HDHyrZE0xyABjpD7CtSr5PrQTrJwnJKPvZiVhagKlWClaGpU81pNZ9mQKTOMIzIhheMAA9eIezCqaOmwp/b5mHdfGuVtr8sTo/FoD/L5b6RXz7HGFrgB4/7Pj7bFFd2jrB/3WFV8GFz3ShcWFfhoiio9SaTCB0QdCVGHBdHcxyvOvoa+oW6/9N1WvhiXiQmMFDehsjF0LxI8sxLRwhRFKTG+8YlXgeRX1sV2C8cCSBL3Kxc6IWKHd2ozs5agtCIoGIjBOImyWvauXaz42oCONuGhKJ5QOgnIPu58njpQlNAcWCq+kDg45nYIk3SXuMOVoFbJaWJdnyiIzFmVI7OH5g/cXnS8vC2Dt1BGDo0g48E5d9v2GMZIMN7nLZUdcJmZ340BCCpJDdZVTPrGv4KL4wiX0iD3aw83trS5WDZzaDl2t56Ifojj8O2ddYdmsilA98d2NXOq8vta78fGL6OHb5wH9N8/kNiobGZ4uUlfiwBVJAHRdIi8HvoXX5HiyFqBuSsMzm/valU8+WHUvkZDxSf+6Isbn2ZHC3HEhmMfRJhOhZVTwWMWl+1q2FTOP9RUXq9Vw+0MfSVfOnk+smVGY17JyoA3bspv9k+6JCdqd2CmATwRXvW7h24GGrDOv2xf33b00ene0YDvTyOeBIBs6zYFhVZK4od0Ydc0EVGY7plU/HIiI
 SDcKJWjx
 Xus9LpN5stDimMb+ihcQMT0jc3hx3gMW7bU+bCrdSq6tw3FvmFYjFD00PMzvNFKHwVM/wTkuZ3QYPV1HY19PD3KgcXniui0Enn04CbltdWtXGWcUJlD7a90mP87g7e1f4fl6zJQzsjSqfgGXt7Fh8qrWajIP+03VVcWh3G5SstnpqHz1ayAODy2yhbzTj/6gw8d99VCPOqNU9wmzGh/vycME+LCejt73frvfNP+ln+7deSm79M6gLf5+fjmoioIM4apaG+bz9iw/Zfg6Xng9FwGV4yuVHuZ2zCE6jFvi2wnrui0c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 16:06:20 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Document addr_unit DAMON sysfs file on DAMON ABI document.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> index 6791d879759e..cf4d66bd119d 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
> +++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> @@ -77,6 +77,13 @@ Description:	Writing a keyword for a monitoring operations set ('vaddr' for
>  		Note that only the operations sets that listed in
>  		'avail_operations' file are valid inputs.
>  
> +What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
> +Date:		Apr 2025

Please update above date.

> +Contact:	SeongJae Park <sj@kernel.org>
> +Description:	Writing an integer to this file sets the 'address unit'
> +		parameter of the given operations set of the context.  Reading
> +		the file returns the last-written 'address unit' value.
> +
>  What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
>  Date:		Mar 2022
>  Contact:	SeongJae Park <sj@kernel.org>
> -- 
> 2.43.0


Thanks,
SJ

