Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7E0C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8CC6B00A4; Mon, 31 Aug 2026 22:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1BE6B00A5; Mon, 31 Aug 2026 22:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29306B00A6; Mon, 31 Aug 2026 22:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D166E6B00A4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:58:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B00D401E3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:58:41 +0000 (UTC)
X-FDA: 85163685642.23.2C14A48
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD188A0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:58:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LWJSCW5s;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788231519;
	b=ExkDOo/N4HSf8EJKXQJh02ioR9omKRUbuAQqLtidyKE8G3NhxlR8YsOSoB0ZNT5O28DDjN
	pRKBYswFsL1WgZJCdsRq5YWH36KdgeHztfGsut/h/a1yru2OFEAE92IPG/mnQFzX72kSnQ
	z0wXHaINrZI9VvlDObDU5dCp9+3z44o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LWJSCW5s;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788231519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWe25f/V5EyAwZsvk6syK52ldRZujBuH0XXRF2BXP3E=;
	b=cBcm/JabcnZAFhSUw1qv2P1nkZl463eIHWPIFjXBJ1msBq+tZRR8AIIXmRvu5MMCEqezce
	QjN+2YANzNkjgTIvO2lupSJQRPngwHSPw6n7/TX+1L73cz/I8iBOBpfXrfzMMg58MvGxtZ
	EmEDh/6g5n+PP1aHRKXW+x7QtHfYnnk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788231512; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=IWe25f/V5EyAwZsvk6syK52ldRZujBuH0XXRF2BXP3E=;
 b=LWJSCW5sQhVXmXof4ttwdazcl7KEK/Eh9LBMuGlIJFpZSg8Rdv5Fr45rvGb6ecFYO9p5z6
 QAsH5YuYASuHVF3ow9f7mjbmsprWEPUq6kvlE4LEvuM1dcQBUeL/xAhAWG7aPnykwLHx0v
 AAPb0si1N5TtrX+RW9UXWoIy/JkwY5cYMtzVbNzd+85bwpTNivZfQ+Fkva+l1yxSWqOv2A
 l8dvueIjJqFUZHkT3BxZl4CHDOWRTP8Kh7xSblM2S63eHv6AkBr3xJTR7Q0g/txQR9g/jV
 16SzbYkZxIzn1JCXW2mL5RSMWjsQhGpqRozTHGYAeciVkgb7pyC364oHoKFc+w==
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
References: <20260831111638.76012-1-lizhe.67@bytedance.com> <20260831164531.be5a8fa210401830e85eb974@linux-foundation.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v11 0/7] mm: optimize zone-device memmap initialization
X-Lms-Return-Path: <lba+26a963f56+dbc356+kvack.org+lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
Message-Id: <f7099580-870f-4cdf-84cc-a82cc47a42b0@bytedance.com>
Date: Tue, 1 Sep 2026 10:58:09 +0800
Mime-Version: 1.0
In-Reply-To: <20260831164531.be5a8fa210401830e85eb974@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: rhqk8pkihrxtd3qnti5esh5htj7k1eot
X-Rspamd-Queue-Id: BD188A0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788231518-16334
X-HE-Meta: U2FsdGVkX19Z3lamioM88IKoAkKRbN9lw7rmtc/F7ujepVuUWpL+ln4aB/xMhjVwHqh1rQRCEFVXcaGWD9FJuyuxH6NjFAY8PdRDQ4w85VkG/GgtJnX5geW4WUe/EoqeXHWzkosEVe2n3ZY6D0x/e9rQ4flconZ1B4Z/r82K2+aJKhFCRz0VNO0hlTR9LRDMBEG3nsy2aDo0T4CzLBxy04pc5B5LOiThrKtZRPjIGULqj/JEy+feo31NCXtvOa/jm/ZiWa0hvyZQ+F+jExdYQPueEY1wLDQRH7Jz42TQuR8YKaaM5Jjf0+DGGNfDla5t2njPiLqABJIyS3vflrMWJZzIvTzffRCHeVpC1isZyyVKdatcxFZj1T4sXDHPKlg6iQ1qXP5Jw5GNeGrTSkmCimZKe5ZWx5w7qeTsgOP7tQXYwSV10ZfQsYiIIYP3kh1Ww7eM5cHM1e+jMkFwEinPMZHXvLDRijcQwj9LMI1npvkLNjZFszvEarjs30bCPYC3XHEucl8fNHlyUPrj3XK/Rhe4qwEbrbREU6KvAz1uYJG4B5fErg7fOOs14+mx5iJon72rkjBoQxe77pzT/SgVYlK34UvxUxiyEMawfldQvJNsKd/WBn1eMbMuS8Wk3zLrsn4N6ycT6j0ILDCPHZM8vN/p4yOOT4LxUFBO+BL3Gexi7pGzs+tSo3W6U9AaJx4pVYDU+NCl3xdSyYpCgaVJ0l/49Slt29qNEivSQZ6+zk2C59S4kLG4GmRUeIsdtyMFPEwnOmZXKmlnvN496NmERszucOrxosB0sJOcNrHogEi8GjZN0onOyZaawRqawAG2jlON+zTCS0ofFF2aQOAk16Wwb084KV70BBnHjIAbpuUsRVS1nJcwv2heuYS/iKoNVlDPrzcNfhaPYZWkLjeQxO/H9eg6KRkl3D/Y+Loh6H+x7H10BGfbklE1jOCuAqK9o5HPhyLx6P+hArqYfo8
 uEUMUTk5
 KdFh7v4uyfjzQs7Jq1BBWKJw5OeqdaWXAs7PVS1cG2X8k6b74R/Y9jQEhwWwv0aCaBeh8xIxsHEhZT99ah86Mn0+KeB+x7zu6pMJLrD/BlW6BNdimKgWiPfVbgPEB4024BSH8uBXQ5KWIdX/vYpWwOKpjkCHtZuZn5pJRbgfbEEWkdYEKyfUvcS98Wodg4JyNWam1WRV9Rs04fZ5kbWViDeKI6kJ2UpSPjoerisD6ppQdoCtlcEIBg+ihoIDZKdzij0d3A1lBQmKL8ihqtMMRKqvdhqB7qJgONL/mBK+RnKej7q7JeiTKQtI0qUjRJSFwfoABKoQbBYgSryLh5gjfXDRh/qA8GY6p+nuanK7tXnXHdpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 7:45 AM, Andrew Morton wrote:
> On Mon, 31 Aug 2026 19:16:31 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
>
>> memmap_init_zone_device() can take a noticeable amount of time when large
>> pmem namespaces are bound or rebound, because it initializes nearly
>> identical struct page descriptors one PFN at a time. This series reduces
>> that ZONE_DEVICE memmap initialization overhead by reusing prepared
>> struct page templates and, on x86, using memcpy_nontemporal() for the
>> template copy path.
>>
>> ...
>>
>> This reduces the average memmap initialization time measured during
>> rebind by about 48.0% for nd_pmem and 41.6% for dax_pmem on that arm64
>> VM setup. Since this arm64 setup does not use the x86 MOVNTI fast paths,
>> the result also suggests that the generic template-copy optimization can
>> benefit architectures without an architecture-specific
>> memcpy_nontemporal() backend.
> Well that's nice.
>
> Sashiko seems to have found some new things to complain about:
> 	https://sashiko.dev/#/patchset/20260831111638.76012-1-lizhe.67@bytedance.com
>
Hi Andrew,

Thanks for taking a look.

For the comment on patch 5 about the cnt == 0 case, I agree that
memcpy_flushcache() should preserve the usual zero-length memcpy
semantics. This is a pre-existing issue in the x86
memcpy_flushcache()/__memcpy_flushcache() implementation, not a bug
introduced by this series. The new ZONE_DEVICE call site added by this
series always copies sizeof(struct page), so it cannot hit the
zero-length case.

Since this is a pre-existing issue and is independent of this patchset,
would you prefer me to send a separate standalone fix for the x86
memcpy_flushcache() zero-length case, rather than folding it into this
series?

For the MOVNTI ordering concern in patch 6, this was discussed in the
previous round. Based on that discussion, I believe the current code is
correct, so I do not plan any additional code changes for these items.

Thanks,
Zhe

