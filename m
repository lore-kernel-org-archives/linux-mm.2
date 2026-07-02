Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04BDC43327
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A601A6B0106; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11206B0100; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7ED6B0115; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8D46B0100
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55EBF40131
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:15:20 +0000 (UTC)
X-FDA: 84944185200.01.D6A7DA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 687DC14000C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:15:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Trlxkt4X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783005318;
	b=o7z6skltb038QlhpP/GWv1goFkkeU9Zas72L2ipXkqHwean41d0PPSxjggSnZDEw/P0J25
	aaet2sp85l+jZ1Fp9rTZKEFmzidTNwIusXHqyD5dxqJ+KuJFV8JGItuExBhttMvLh9hs2m
	PPGdVVRXaHPFNvycE6awkbE0yRHVTKU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783005318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cN4KFFzWUhFcSUKpTOuV4pjxWZfQWb0Z/Yvt6Cje6Y8=;
	b=Y1nt5UvqHLRdET+h4qnZ3TXjYhVdOjcd416NdXDxk7c3NA2jphWq1lH+Hnu6jzEaN0qa5i
	40fmLgTccQkhf0x9RODUsn1Ro72crKxkEb5oklNCHI2/mcNOS9H+6NjW0CgnxdDwOmtsrO
	B1chjKZIBoRPoFm61k5Jw5NB27LyiCc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Trlxkt4X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEA5D41A88;
	Thu,  2 Jul 2026 15:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED221F000E9;
	Thu,  2 Jul 2026 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783005316;
	bh=cN4KFFzWUhFcSUKpTOuV4pjxWZfQWb0Z/Yvt6Cje6Y8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Trlxkt4XVQlHBp1gV8S2B1jNKK+1uQylpgBnOyOkZQGqzV1WTGkq1NKmMLPcNCpxQ
	 j61+wgtl2k68aQkDJkD94iRcb4w62QvuwRqYgDsftVTr/7pSfOUNCFyA4+iX2RrE56
	 Urofgxnw12YN14HlanQDcNRWHS9L/WYFrLyEYXPXdMPNg4C5rg9IdePBq05oCM8MdW
	 SURFqrVsGbACZuY3mCLIZpi/Hrw+zfyZDFBuWn5G+IEbfn013tykRr4/5jQlWx33ZC
	 AmpNpS30OgIy02pg+vdYVISSKPHD0CqbpEIgpRPG8/MjGwXCaFbEuIsBpYk+w5gkBS
	 5dV4dFtXOQZmw==
Message-ID: <61c4c728-b150-41ce-b1b2-96ef2ad766ee@kernel.org>
Date: Thu, 2 Jul 2026 17:15:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] MAINTAINERS: add Usama as a THP reviewer
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260702140257.44780-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260702140257.44780-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: argsae7ggp3cracsomnu6hozwqbk8bwr
X-Rspamd-Queue-Id: 687DC14000C
X-HE-Tag: 1783005318-640060
X-HE-Meta: U2FsdGVkX19MdSSqLEDDp6YfGng3CiIUYAD7wJcV0m0t6Zif5OG5/XD61Ja2ip/iXF3u6TXtwabSoqU9gSxUIvhLcGoB+HJ6GtTVp5dww1wOJ2e+5UhT0oJlzg4NgGuSHI2pWFlOdSUgZFBe+whAfZhkdumqusOd9XFa5rdhpy5TA7MPyzV97AgyDzxlhpQ6WnrA10LFB6OC7/JPQwBtbc2T1B9DkMC3PniN+5ws9yHheN/7oMHrjd+tHTRpAAOhXc1Z/L18bRYn1lzFFsNzTYYJCf66T/KguEgm2yhnyi4c50gPmWTdR3p2U5udZnRU96scvqUoz+pV2PfM71Tvh2Zlaa1dGTsUR9c1XywULa9+8doXHIzCMrXPcnc98iR2dbdUKm3ul6HM9O69rxvwo9TjImsNUEzSafp5dE5LUbJpnqWIC9BYID0q/lv2N0HgQkKsWuOPhnRJHh+iV9w4C+Ryj7Uy9sUDOxQqX9FtDT1Vbllun17bdiYD9xhJ5XEbb+BBAwUa5raBXJa6yEglvLZEHLX4e+NgB+S/1Uhiv6E3lr8s2ub6oq1jq6dGkXD50HxfE4CkfQ88kPGWhmPSBXc2WwZmRCyFysS3Iwi/s2Geyg7aNPq0c899qzZM0NQbDvLVjD7fSgtpsdjkfnkdu9WaXN/npNGUfzeyUsK4J6a0jT2SWNrdfcfPOXKyXzBo2glcQkQASkUi27NKNVLhRjeF9AGt7LXPAy1ipCyD+pqESzWtPObQfZuq7EK69nY39NDLCukkGEv+m09Hrb0sa+NldW+fwdozXl0BgvyL7/Ah7mUf65FQ2gz+U7O2FhaxWL2YkrzMyCcIZ3xE0I2sroXEZO4M2EZGqVMaPcQASs9glRKKi0DpFfORI+7sKxhP0BYRvv+vwYbADQ777lYFIL/R1lQrPz23K2nRHde9HXN9JWXd9ZXgyo9MYSpxN7J4diGtD4GdXTYs3i4GYre
 goT6nZgc
 CmzrzYYL49wf/ec3QHJARzpgCKesuABO9RJxAbUoQDvJ5AXZTFc1lL60KVEds/S1tU7wyW7unSLOAKslGre4BkiMazpsMEoiEUTl8X45PFgbEv0ynQaVB6LaDwUKvpGrgazY2Szbyq0PpeTDIbsBmJD5YaLvP84gH5LKBL2vnnX70C3Z1RMuD8/luJYrFI//vkCGHgoAbXO8NA+nrlIvkD0rHGApwu9pdHGtHAeiJLFodsFNJSyLH3O6T9xPSS2Ak7Rxc6moxlVHYzilRjj7Rs/2lvJZG3nrc26esOqO5OY9Ooc4lm3fGt6GRein865UvnnDlm8af85P+8niKjIUlSkQcZH/TXTXraiz1gwZMAMlWxyAWpCoOlqcBVkApap9MpS+AOm0Ks69LxybfeAGiIWK1k4mrcyTEO9+gosNSrBvC2Kz84gvBCtBWTjdLUHmQnfi+Vlsp+S9LPRWSZBn0GfpPew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 16:02, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Usama has been active around THP, really enjoys working on THPs, and tries
> to review all the patches that come in.
> 
> Let's invite him to the THP party as a reviewer to help with the ongoing
> THP review load.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2acb019516eb..29c302e9c17b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17255,6 +17255,7 @@ R:	Ryan Roberts <ryan.roberts@arm.com>
>  R:	Dev Jain <dev.jain@arm.com>
>  R:	Barry Song <baohua@kernel.org>
>  R:	Lance Yang <lance.yang@linux.dev>
> +R:	Usama Arif <usama.arif@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

