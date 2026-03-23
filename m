Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F99D58CDC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC30E6B0088; Mon, 23 Mar 2026 03:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73B56B0089; Mon, 23 Mar 2026 03:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89606B008A; Mon, 23 Mar 2026 03:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B79886B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:34:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24F511A0A64
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:34:29 +0000 (UTC)
X-FDA: 84576515058.24.206442F
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09FED100007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:34:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=aueLpHc3;
	spf=pass (imf14.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774251267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N03MwYZKfJyz/jISI55XQbpuxlLeDNyC93LJJN41uQE=;
	b=WaiHfV658Isbee1eh3XUmclSCtR8UrtANvT8xjAkm1xR9x1CLaPATUy35W7mzCdInzI3Jb
	RxdHu4W0s1YAKv3hAaYOlRxSiBPtCnAYs7ZQRPgO9/aLRqAaedG0E/luTYyXqrCySAgGLw
	dvawL3upGQnj6bGhvIDERSk78QVDd5g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774251267; a=rsa-sha256;
	cv=pass;
	b=JdR/FeOOomn0IdG651WMZ7W2uj2xEglgg/R8lGRQUGTNFWGZDmsUqiou0NScPhP7IBzzOA
	CAUh6RYKA9AKebLHGor6FQ76WiNwwo3RtN9JBYo/Bw+LInIEx7oeRgJWCi8SZMT6Waf/Ze
	1bliyZgX2/oKmDupRlULz+Z7zYPiDyg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=aueLpHc3;
	spf=pass (imf14.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774251241; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=aLUnjvWbgEl7I0JC+aTZBN+fnPPMFfI8i2jdvaFHgh5TwmGuoWcUJl9PraU6SDZucBuH+quJLOxU4R220FB67UjVk5EKVdZ//jJ7oWwI25ucQdZBlKPBGjKsNzqympd2iJWQg5kT1xu6HFVCLSlvhmfy+6xt/lGt9p4ECl6ANdM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774251241; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=N03MwYZKfJyz/jISI55XQbpuxlLeDNyC93LJJN41uQE=; 
	b=UsIXLyFsu3TmM6YipQqXh4PLYMyOlC3w2LFD/AAP12265oYV9Z+/RVYn97TJcSx7wXjaBDwcP2kau/952bfAwxqCebMzM/AVtS/h2R5VuVYvieJYk3HEwvv8rG1mWVXgn11A4AHaBtsB379jY+rOv/AMjy2FWfPPOE0R7x9l/fg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774251241;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=N03MwYZKfJyz/jISI55XQbpuxlLeDNyC93LJJN41uQE=;
	b=aueLpHc313GbcC2+GHpnpX7AB8MaxMKRGWEyBqVAqnnPpOPl3doxlTyG9LAMYlAl
	J48cJ90xKKPp0YBNUkAxvhIw5825eueORi81Hxh0sBxkVCxZYt1elHLjhnyW1NaKPgA
	/veyPTzho3WrAo4OferEZ8feGHBtzHo/vdrTJSnc=
Received: by mx.zoho.eu with SMTPS id 1774251240068390.417387203978;
	Mon, 23 Mar 2026 08:34:00 +0100 (CET)
Date: Mon, 23 Mar 2026 07:33:59 +0000
From: Josh Law <objecting@objecting.org>
To: Markus Elfring <Markus.Elfring@web.de>, SeongJae Park <sj@kernel.org>,
 damon@lists.linux.dev, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_1/3=5D_mm/damon/sysfs=3A_fix_param=5F?=
 =?US-ASCII?Q?ctx_leak_on_damon=5Fsysfs=5Fnew=5Ftest=5Fctx=28=29_failure?=
User-Agent: Thunderbird for Android
In-Reply-To: <89ab7e7b-ad61-4881-bceb-781481857d3d@web.de>
References: <20260321175427.86000-2-sj@kernel.org> <89ab7e7b-ad61-4881-bceb-781481857d3d@web.de>
Message-ID: <BDDAE837-48DD-4FF8-B7E3-AC0030AF5C9F@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 09FED100007
X-Stat-Signature: rni6fi7bpsxpauqfpcecc5pjg5oqo477
X-Rspam-User: 
X-HE-Tag: 1774251266-700887
X-HE-Meta: U2FsdGVkX1/2/ZrWXpvO3b+kxkWNXc4exOqWaGVafakeTE1Y9zOeain6CjBOW+MiEWsE0SDtEGt7pqEgiaMydbpqNCTYlAqCQKajyK31eYgz7u2fwutaXTA6PALaMZaPIpG/+3GX8UDtnJ9lfW1wP860utMcYHT0nsKkymOtgkWswURPbwbGoQpXaOcHHRyeYduS+GlfFNskbu5SqytdZ7tUYDH2i6Qo4RlMxgxYVy4ROptQa8OQqjN+eOM9K+EevVjoCMmjSxw+Eoc/b/UJB86MaONZ6REpsC8SqkLfylHo+uYWggkpkYmyYXtI0xWw3AaIg9gGc9KNmF90OPN5s5ZbvRx6PE+icYD7FryAMN3WnwHc0bOgqN3XAZW6t6Qj+fMnR9DBBGAXWN1R6emxf4A37Qiwx7NFnWm26vgWq7oMMF9x2r5HOxJkUzHLDin2L2IKRZQO9B0kZfakbuUSLMdSsLw8h2eJczT4TezU+XKwfZZw/w+9RfpAiD/uaTL3z2lB108FdNBVAa4u0aOjtpGRxh098Pgr8jWxIWgvDdbOBB/Jjmm68ZmEbOu0ybctgjfWvAu1HTR+a8dCBK/MbRUIeNXQzgh771jDIt2xFhy+AQbB/RS2m8vz8IMPLCf5NbT4nbSxMtcXEi1CGgK3yZqWmbP8G7XQPZSxn1nxCPwfRc3Hfglz1FMGs2CIRiFXAwB5sgZk3eNBE4Xad7g2oxmSN7aXWS0bpvVW8Vhm3crrRvw3CHyzDwpPlBSZERqL9ZML+sxLBm1FBk2/yy18oszMWzwW5+4bSzz3U92P/LWs6BbgngjeJflGepzaowxtOVJeDvxd2WyrMbmuZv1pPSpz9S7ptERiUGy2EMm0cpK7wen3L85vYPayZjifivZIGas15hHV/TMf3Ro16o+/5vay3JP6OWQitlrWOvBCFOw9NMkJzoGWZMLp3jshC+8yTwSOGOvIey3LyYAMQkt
 4SnM5VsN
 tTQgsKZp4oG7T24CyWQDG4IaNH0Q5V1lN3ZgAgG4tPKmZIp9+eHYLPVV7LH0bGK9fKy/d1KfA3nTYM+bbMjV05iCXQ53QiT+l4Io6KUixrT/N85sKlZfGJFAdrEKGao+NQeN37y1Xyx/mXowqmDvhXon6EpM49pRP91ZP64FJlY0dsDaxomyqTTqg/6VjPHMFIaR5KMSGGCTDa5YnTBFs/TmcgBAn5MT+dNsx0emWNpQtCOJGSVfNgxgccRuCpWxgy73F63MAk5zrSm/kxLVUvx+HKJqRtf+LXc+rf5tSR9OWT96CBbAWu95YrLLEwDv5NtF/D132VSlovgfpc3np6aOZMf8FOYXMpdQAc8z/G0L9uQSRj+XRRppk+8g0qkh/UoKJMi5BTlbaPqEUmgg6Rmtz02MDZVEYc0G55ee1zYWPtlfAttaZ7XJMLdIyUSaCDMZ4a7EqY+gQf15jfYMvx6pnU5wM+pQ60CR3b+P1HPdnRPhfQkqMDcfP1KPQdn+zpQwjBXEdCP1wpg5dU0klqX3eN1EP5hi1P4WvDqy6r/wFEN6ApMFde8NXrqOEtna8Xx2MY5FXZcjzERMyPs1CqHVtuwO5KXuFpT0VTZ/gu4uGhQ0YQIlKLJsoEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23 March 2026 07:28:59 GMT, Markus Elfring <Markus=2EElfring@web=2Ede> =
wrote:
>> When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
>> param_ctx is leaked because the early return skips the cleanup at the
>> out label=2E Destroy param_ctx before returning=2E
>
>Will it become helpful to use another label accordingly?
>https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/torvalds/linux=2Egit/=
tree/Documentation/process/coding-style=2Erst?h=3Dv7=2E0-rc5#n526
>https://elixir=2Ebootlin=2Ecom/linux/v7=2E0-rc4/source/mm/damon/sysfs=2Ec=
#L1506-L1537
>
>Regards,
>Markus



Markus these patches are already merged=20


V/R


Josh Law

