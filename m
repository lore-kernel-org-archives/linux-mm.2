Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A283DC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC94E6B0093; Thu,  9 Jul 2026 06:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79656B0095; Thu,  9 Jul 2026 06:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941A56B0096; Thu,  9 Jul 2026 06:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B59C6B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:20:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1270D169225
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:20:25 +0000 (UTC)
X-FDA: 84968843610.30.09E8A3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7101B180010
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:20:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkQYk0bI;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783592423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPfLC5orl3FOJPqKVHrYgEfUBkfZk4Q5lRT44NLSQO0=;
	b=5ZS96FZn6vI457DQF59zFVJjVUkiOD1dROCqV+/Kp7v/WQPW7v1ogr+fkLE//IEybM4E+D
	vO/crJH7H3clhSmA1/1izY3nk3WGOZBqcgkENMnnmmH46FxQaD+Ctt0j3vyEVeNJX4egR/
	iuPT6C/Oh5DzMLaunf7KRQNpBj1d/pA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkQYk0bI;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783592423;
	b=2yRgdIvOTJMPNADgTqRgC3eTkjaH5p82LS4ucSTf+aKW8pKJujDD3tvN5MEhZumPwNERWB
	ruzXC1Ky53Dn+dzsmT6vVl2pNkMtqOAwwjKu8YGR+djZcx5R3U9bzju85I2whBU3RwJy7g
	YAvzx9Dp+zvbmXKnS7BPyi/xHGSbMms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9D30404D5;
	Thu,  9 Jul 2026 10:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6601F000E9;
	Thu,  9 Jul 2026 10:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783592422;
	bh=MPfLC5orl3FOJPqKVHrYgEfUBkfZk4Q5lRT44NLSQO0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TkQYk0bInxmgbiOA9FOncoBSAGMtj+4O2aDKrMF3sQkk3lVKYVEYVWLhlNCjtHH/h
	 0ac62rG5qNjPNGJwnjcTdsKTGqi4OpqLkl6A/iDY9RizgvLAYJPynjqSi5WCRYWTbi
	 k70BVKmx6p/gDfx6KuujGDUVuXmBzvn7EIxkI0HLhz3I2PXQXBg+r8M54lv6YCtIoD
	 FPdOhbaji0PqzQ4epn0oXwWIQ54ZVK4X56kVXJo91FnPlUMapy5N25Dv4joagEqqT6
	 0WcjEKp65OaXqodIL9MCOihLA32LdiYInZWcs2wFVBM9VlerpcHJfpcNNAFWQWE3In
	 krq8LtfPyD96w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-mm@kvack.org,  Mike Rapoport <rppt@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  skhawaja@google.com,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] luo: Update serialized data to use KHOSER_PTR
In-Reply-To: <178271651966.13502.2620034351625890943.b4-review@b4> (Pasha
	Tatashin's message of "Mon, 29 Jun 2026 07:01:59 +0000")
References: <20260628001114.1869564-1-tarunsahu@google.com>
	<20260628001114.1869564-4-tarunsahu@google.com>
	<178271651966.13502.2620034351625890943.b4-review@b4>
Date: Thu, 09 Jul 2026 12:20:19 +0200
Message-ID: <2vxzldbklb18.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7101B180010
X-Stat-Signature: qb8i8hc53higsxq811dyunomqbntunzy
X-HE-Tag: 1783592423-199741
X-HE-Meta: U2FsdGVkX19uvJYYYCAi2VrwoZDrRtdTU5S7hli9x5ts389CiD6a0D/szIJJ4bg3raPlS1zmS+9/Nyyy9ZHjcQ5fP7eps0Hbcdnv81SUGzw1cdA8iG+2HLQ9jb/UZLWTqvzVLO9V+qIpzZTi2LTBeoUfSDj5HVZyxGzKG9JlB0ZfYlpSn1l4zLL5Zmhpqq7L+3/za5uK1yKjt5pH6QEsl6G2SH3eYa6VdAOiI8//crOfEwApp5Wckvq4K5x3nYIlR2qR/b3HJ2CCMV7d/NWC2RNNV79Dsy1ggR1WsDxez+lOhUZ1aU42w5GQM0MkhYgsTEc2DCPfNgHOYen/Cy7UVZszdqeFXi9VhlG2muOFn4q+JKHMbK6brDLhE2Iu0KC+OsGSgEghsmVzQxbabSkqvsNDvkrgguEoATJNS8eCXL/GyrshIv1myGcApfnWAlOnAhOLr6Zq+Cs/1fm4m08Vguho4s75Iwvg5nFtvANA1vGvPuEH7n3BFTcTTXc5B8IJw9d4OAabZXkzRJ4Qo5G9TUctrWayjeqoaz/xPvhVqlMGUJbE3/Xpeh7c1jcU28jsvzwlXCO+AN4sKgX1yIyeyd9K1dglEori19xtXFw0sHHOl82FapiEglVOrcX37WbqzQ3F+8XJDCGM5VdkazUB8V/tztgxKGBBhB9TRzi8OzHyXv3oOvQJUCk8uo2i1S7v79MjDyO49WCKUu1NdaM6XKig7mIWouNWMnxSVSfmS+G+rgt4lXg70/gAkIfoUvkcaiHlhi3bkjn3CKhzaswfrd4JhfCbbWo0yZxW2magWPl7hx1E+GniaDjFX3LMZCYxrgFA4TzxznGQhI5dA+/Rezwe64ljyXYHFGxcJ/ieP5xLrLS/tWH35EBIkO+Yz+oG/MWheLagb7816q60HK14gXJKvNT0UFJhS+ATQgbOCNE9Qk/vrS7owTVuhAra21todKwNnBnjjguvFn1ykw+
 CVqcH5Ss
 agvrbxXGRwXBjVk78zyKKUqG81bEDTK8ozY6BaSZpiKoOFU0xywGH86BGUk/P8ovXFO7k6yU29dFuhIzUjEQVTxhjr4Uuh5iPsIlKa6sYHrhunorqH8HgXdIwXlrHq5C989MIyQucv/A8S15sH//bcp03cNqGQT8vQ4ZE7v/RaUgeRHCF6RIF5qD4gOfvlnR7ALpAofDCJGl9OT6zpsZaTtM2fJrC7yoCD/d+CI8CUyiGf+fXxaF14ioEfSZ2opdu7ipN7FdcUn+4g1qSorDr4uXAt4Qwe72qH8O/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Mon, Jun 29 2026, Pasha Tatashin wrote:

> On Sun, 28 Jun 2026 00:11:14 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> index 288076de6d4a..9e78625cfdc1 100644
>> --- a/include/linux/kho/abi/luo.h
>> +++ b/include/linux/kho/abi/luo.h
>> @@ -89,14 +90,14 @@ struct luo_ser {
>>  /**
>>   * struct luo_file_ser - Represents the serialized preserves files.
>>   * @compatible:  File handler compatible string.
>> - * @data:        Private data
>> + * @serialized_data:  The serialized KHO pointer for this file
>
> I am concerned about layring violation here.
>
> LUO is designed as  a generic, opaque transport layer that promises to 
> preserve 64 bits of raw data. How those 64 bits are interpreted is 
> entirely up to individual clients.
>
> While some clients like memfd_luo will use those 64 bits as a physical 
> address pointing to KHO-preserved structures, other clients may store a 
> generic token, cookie, index, or non-pointer status. By
> changing u64 data to DECLARE_KHOSER_PTR(serialized_data, void *) in 
> struct luo_file_ser, we force KHO pointer semantics and layout 
> constraints on all generic LUO files.

That makes sense theory, but in practice, no file handler is going to
need only 8 bytes for its metadata. It is always going to need more, and
to store more information, it needs to store a pointer to that
information with the 64 bits it gets.

Do you have any examples of something else one might store here?

At least looking at the current file handlers merged and in flight,
memfd, iommufd, vfio, pci, hugetlb, guest_memfd, all of them store a
pointer here.

And if everyone is only storing pointers in this field, might as well
give them a bit of type safety.

>
> Clients that need KHO pointer serialization must cast that opaque 64-bit 
> value to/from a  KHOSER_PTR  within their own callbacks.
>
> Also, the field descriptions in  struct luo_file_ser  are no longer 
> aligned due to the length of the new variable name, I believe it will 
> cause warning when making docs.

-- 
Regards,
Pratyush Yadav

