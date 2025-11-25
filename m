Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 155EBCFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599AC6B0027; Tue, 25 Nov 2025 03:09:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5711D6B0028; Tue, 25 Nov 2025 03:09:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE626B002A; Tue, 25 Nov 2025 03:09:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 399666B0027
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:09:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41AED13B99A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:09:12 +0000 (UTC)
X-FDA: 84148404144.07.67F41F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A3E8C000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:09:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLshyslP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764058150; a=rsa-sha256;
	cv=none;
	b=PVzvtpBaUDP78J6YCmRQafFAz5ZZGxjpMv7MwyPppsOIGBPKure0n+Pahb8sp4IWvCkcUV
	GNmz48aNINiXX1g058/riCPAWq/u1dg1awXFZ1AqYmzZHDqXPR9G+ZMWyXABc1afXhbvW0
	ECqOkDqPqUd8HO4Vqze9pfdDNeIxvpM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLshyslP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764058150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plBbncABTDSfRimys2SDN43XzwViZDJwj5FPdTvuvm8=;
	b=HtOhW5auPhx1qarKxlVs0HZQp2fnOKQFhqcWP8GPWG3X/50nYD9OT3O/uBliBpXdZob8Mf
	kkA3rd4rUMc1wm9ziUpfzcfw+htZUjcOgBnpfX42W3xu5BLM305FuNX8hS4PEFD/ZcfRUz
	j6BPhOhCfdd4JaPb2rLbyP2Bz+Eo/Fo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 474C34391B;
	Tue, 25 Nov 2025 08:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675FFC4CEF1;
	Tue, 25 Nov 2025 08:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764058149;
	bh=XqRq7kplVxhYGNzr105/v144FYOHWjKj2LupjtZhQuk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mLshyslPa3UjOa8eCf4PBZlVgAJ4YIqYI/eMgpfd4Ohv8/Y83HKae4OmSnPeYp6wo
	 cR0lDouYxSW08C1z262NdTq01IkB+c+IEsJ+4YM4gVDy1SNmUxu4VkVHG6G67a97pn
	 2xc0nCP13CcSIWSCMd1u6r/CpbTIJ124t307FuwcaAg5D2VACYWiguJWtbEKgnry2m
	 VCDUq/QVII7t/BkjlK8UNxZ7MWX/Dgqi/7mXvN6VSiL5ch64RtOu5CbQkkIdxR7lTJ
	 dpCVyGthO8GJMt1n10pKg0PCbgQtRbLDrQCbRTyqU91egIXnBC+F3MfwSOQ873PT4W
	 EgMtD7hWasMWg==
Message-ID: <9fdc1d1f-ce00-47ff-bdf5-66e8a511be25@kernel.org>
Date: Tue, 25 Nov 2025 09:09:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
To: Ilias Stamatis <ilstam@amazon.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, nadav.amit@gmail.com, huang.ying.caritas@gmail.com,
 andriy.shevchenko@linux.intel.com, bhe@redhat.com, nh-open-source@amazon.com
References: <20251124165349.3377826-1-ilstam@amazon.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251124165349.3377826-1-ilstam@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A3E8C000D
X-Stat-Signature: 3z8sesssbxkniyxh9et3u5yafdoffhop
X-HE-Tag: 1764058150-222898
X-HE-Meta: U2FsdGVkX1+Ttb3tOFNbJxddFYGSRB0Y+B3GyG/5ZPj2s6dTf8YdeQRRnsOl7NHGEwso24riigbYI9q7rbyA1DwUqRQ807J1sWppLk1dslJ8wetEFDMRUzO6BoUiUspTTR/A9zE8+wtMgq/xwpgoKtOeqKpyTVGqlKPFaQ1YrXARFtHDIrUWCWQngnqMnLMMZlWzN7j3tohhAS3x77AUKAtEjPfQbVcm2K0ABvNQ+XkZPRCb5Kuo282s8kem6tRoTSaFB8+XROWuczTYf/gmqOzc6oGuTE1eJiLzocyiw7ZBua/2AILpEMropo+Fm9f1/+mwKR0BJ7Qkr2glg78vVFilDutnj0Njc7Lt1KqtFUDsPYVFdHMy1swQGjtwcGMtXzZZjfvZjo9HXfLiepFqPg8WaekMERN4e5MaBTWcZRveiCpDnqX9TESGFWIUtF8JoW2Syr2OtMEP15LCGDkAuxDJpNeZ/5slmw9pl1ldSyyLNyLI6DAxZCw8PTXQDNmc5brpbPwoJSAxVfWiX0yQGe2jy06SUL4ScErXk/Huz9EeLQqKBh+fxnIit6pt84yKGHgbOexhOArWgoCmz23sNWTzl1QJDrLQhgQZw1u0hxo0my4aVtMxEXw81Cx2TFsehMF5F3qyI5798ba34D6Up2DfDAgPr4BprJ4CzO6UevOmNnRYXcaHdz19ZFGpz2+q7f/iMjLVi1EPotZxihdlYas+jEjGQUNbORhvcnMUmkVMRopsHUB+gW6JHU2QxzaHxbBFoLiJpdpeLzHC2m2JDeZrqtKPTngLD9tIx6ljZf+YK063CJM0bqZ+CrKHzUZAqQjaF+6+OyNIdh2lbgUXXIdS2GWqrsFOu3C9owO6giuNj9Rw2f5TT/Nycd1w56wYOzpVp6s6FvXFBxyFcFiH/khj3qZOBqs9Bj306yP1VCsvIVbuIS59iQC8CAXWkuKxPNkPCur7nUL6383bV3n
 CPEiePt6
 yJyTLcjgI6XMTKrWPqJcIlk4qn7SHOo2Ydil1om/oyeVG72rTXHBfWcKGCjvPdlaX18DnpdCrsZXDKGuO7rV+odotMJFX4etaFKP7gPmKdscKRdP3cy4vcG3R0FXjCs3ZnkMwd/ExeERQMvtONz8wFIVFl7zEfRLbi3eUlwWKaCtj68E7YPCzN0A7GGht3UPgtA/nZkWdbFEjZ0UeW/nhAzh0CUo26yqXQUneQQNKm15FhIRGEF4KTyjRl0oa4VD/1DdWXnh/9MnrluLrP3/uccmMeFFYLobjD62wX+jhDSiciSB3osJOsvYAWjZkZdft7fVYXuHR+bb0i8SU3STXEjiS1nzcLPiFWnZPdP7trw4oYlwWJGJD89S62qdsQ+7LZ4WWYjrOkwBaYQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 17:53, Ilias Stamatis wrote:
> Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> logic") removed an optimization introduced by commit 756398750e11
> ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> was not called out in the message of the first commit explicitly so it's
> not entirely clear whether removing the optimization happened
> inadvertently or not.

Remembering the history, we have some things where the top might not
fully describe what the lower levels do.

An example is for example found here:

Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Feb 16 00:36:02 2023 -0800

     dax/kmem: Fix leak of memory-hotplug resources
     
     While experimenting with CXL region removal the following corruption of
     /proc/iomem appeared.
     
     Before:
     f010000000-f04fffffff : CXL Window 0
       f010000000-f02fffffff : region4
         f010000000-f02fffffff : dax4.0
           f010000000-f02fffffff : System RAM (kmem)

The CXL Windows will certainly not match System RAM, as one example.

How would your change affect such cases?


-- 
Cheers

David

