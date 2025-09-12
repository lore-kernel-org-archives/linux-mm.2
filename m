Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8362ACA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 14:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02BE8E0011; Fri, 12 Sep 2025 10:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDABF8E0002; Fri, 12 Sep 2025 10:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF07C8E0011; Fri, 12 Sep 2025 10:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC8C8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50B171A0862
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:12:48 +0000 (UTC)
X-FDA: 83880789216.12.B62B30C
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id D071DC0012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:12:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=W250Hofs;
	spf=pass (imf22.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757686366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tkZAXzfE56Ye+65KcJu3D+78RmJwSGKf5LKjnICPk0A=;
	b=M3ZXfRMlvBg0lMxphPGgWlgFzAZssF6TTxYUCz7qA1iImeEuKQlju6gmOGLDUkJtEEBa5e
	TL9MqeUP6b3jG9wvd6H45CgN9RtCC4octFLteEfq/LI+lH5FHx4pwDkxL04I1P28nR3H7u
	yAM5siV+d8pGyGlLGqtsxSnR+CikYKs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=W250Hofs;
	spf=pass (imf22.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757686366; a=rsa-sha256;
	cv=none;
	b=b2yW6TPqSO8cSvZ9lhpmC0MltVNQwHdJmEXT2YBzkRpZOcwJR1nS65DYLnj+hQ+EjLjfgZ
	W/a7k8uu+PkqpkusX7JjTuQkzwYWVpOr6RaTgvRu67UneTU0PntcwZXmP6PIl/guvKj9VB
	6HL8VZfcyo1MCJ8vD/WutI+sn4pcGkI=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D0F8B40E015C;
	Fri, 12 Sep 2025 14:12:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ctliiuI1qv13; Fri, 12 Sep 2025 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757686358; bh=tkZAXzfE56Ye+65KcJu3D+78RmJwSGKf5LKjnICPk0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W250Hofs3CAu2xKR7YwCa+iuLV0a0Hass4IjlijRdWxTDhiQQrX5MMxcjFX/Muc19
	 L1D9c9Lb04ZjcZf2KbXFQiyCtAZkXdrAvGqG3NsN38YXvViWfFhq3P0qTKJhMAoDtQ
	 6UGaVchmykQilTK2/QSbuXaV+EiXymkTV0TZvEiQmPcJ9I0YHSQejDJXCwfIbEj6Vm
	 G82J1yDYKg8aVzqOuciVXFDjtRzsZBjG214DEdiy5w4HRkaQgpbr9bqur9Dn4iIy+G
	 kUEKLKzCNYgwDfBobGKajNUoiHCg1W0aYCKRpRyJgrKkrptRO3UAkR+8VAi2i/X4dd
	 OJiTh87FPlwX5ZYud/PEw6fK/bMAFObYM9H8+6ZA0bJgAWhCCE7E2K5ZeCBch71PJ7
	 ec3fzVkjxAt1hg8ejNy+olL5CCuC7iTcNROQynBJNScdIV1SUCJWANA9rP0ZqSoeV0
	 fQ4ChX9Ohn7lYM7tj7Csy7+36rXAEKPCnTft1D/juHMPjpnN3GuSelzM6eN2ldRDPQ
	 10q3tNaz2HGvwBOzQHWUWiiR7DrqZPQL7a9bJUMlBSqtM/i2yS/ATc4iyOplB8BAiX
	 cGCC0JD2nAMdgH2VtFBFe971EdKWqTPbJYopr/QR5spgvae29gJxJ+ZXY3XQCRzdvH
	 Hd5DDtPIhAX+N27TiOyX93NY=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C653340E0140;
	Fri, 12 Sep 2025 14:12:01 +0000 (UTC)
Date: Fri, 12 Sep 2025 16:11:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shiju.jose@huawei.com>
Cc: "rafael@kernel.org" <rafael@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>,
	"erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Message-ID: <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local>
 <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
X-Stat-Signature: br3ase7saec68wo8dtop98ru7mdmw1zg
X-Rspam-User: 
X-Rspamd-Queue-Id: D071DC0012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757686365-60823
X-HE-Meta: U2FsdGVkX1/pHrUFLAT0eLv0ZSTpyQSM6Gi/06v1QZjjH6BSaEu8VgiHINZSqckm2c45AoPyNss0/CLaoQf8YV3ii4b4cUWyZo5v058HeQvl+ZaWIxBNmTeWxHv5lrjITMkRSQm0diQMIU8nhFVjMsWS6fu1xVdzab6s62ki/AtnEqR9sVjfDKtfBPR5L8hxviB8bhwT6+3z1UecJZ7mK2UjDFQxkUQMOpnCa9WGrdvggCTM3JPNlHf6LHUFvAXuLyXnCfvsUu9uDlx/o7bWkNtbbzAB7KfdVAsaSoBy4TmmMC1lbSowrPCaq27EHoPJBY2uKd4UEeaMs17l9fpNzpxF8M3lL5jO3YGmsA6oj1u66C/Jw2N+IHzIZlM4w7OqPbNDLM8uziYoBgnGJIPObMxYtPLFXyxhKaLNzWQ17/oQZ65aLgWzsgL454zpBbjk57cMqcLCl0QoaTUDmFmAJhBdevVFtvHeeR74CPKPHAhhPiMC4z7vwyyw98Dra66ep4IynAf7fc2Kvw3K3jF+Cv09Ri90LCbRR77W1zG3/oUPh2ajGumH7alBFUBR8uXD69ASszHx2cAwHgNPVOxYO/c99tVcZuAWQiGQ42xg/yXbywkDS6VqcO1cSwJb7lvv2mTdQgINMnexXjc8L+RWZhNUdcqpFXlMJ46LdJLQfl/mRgy5ZtVuEOjYzHtwIYgYttmFaNigCm1Zjv6YINNgAGRGnGpjgPlrCHa+Z1Vv9o0ahB8pxrz5JfdhNiTTxWGnxuWflQEOhzI0Gc/FkQuBWZ3geXg+CxBNvh7RgLSZRXsVUTTtdqAShzjXwHYuOfVvKaVPzkR9IoDSTEIzOF+ZwyqBzVx/ZcAYUl8/+oLcDiXZXsz2P5SMig9cwrCy+ZcwdiV58NEsJ3TeA2me8MkkhywUHbP47m+WQqrrL3MmMNw/njho5Xq+4JMD8Km2OzmM913PoAsgWdcfj07Xg2H
 74qTSYEe
 Egae6AEvjspoGS6uOI4E9l+2Ex21sfzl9tPIvE7gY73sSgndM9NOJ0/ww+fvoOpQlKNEKVcsFWivt5W2dscJbb1/pBIS1vSKshHD88/ohpP83xd/72v23rdP4InpL33lL4dK4wg7sUeceWehQAQDdNJu+oEMvGRncoJCsjrGtlLybvMsKby1c9dogVVs4nyPTJKLkqYGaLOrLp/7FCHVY6jdk/pN4+VK+MmmikIUhnk89hhc49wgTqC9kq7R7KXCpbmCAqPenZMP1pLco5ScYWpdf4DjwuCD0lUhegI58RLDmrRwgI6XRx0KvIkTbjaRlnWd+z987YDE8ZlY6njo25/1EFr0ISdMIgzAXLoKOURSRrg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 12:04:57PM +0000, Shiju Jose wrote:
> >Why is this requirement here?
> The physical memory address range retrieved here for the NUMA domain is used in the subsequent
> patch  [PATCH v12 2/2] ras: mem: Add memory ACPI RAS2 driver,
> 1. to set Requested Address Range(INPUT) field of Table 5.87: Parameter Block Structure for PATROL_SCRUB
> when send GET_PATROL_PARAMETERS command to the firmware, to get scrub parameters, running status,
> current scrub rate etc.
> 2. for the validity check of the user requested memory address range to scrub. 

Again, why does it have to be *lowest* and *contiguous*?

Your answer doesn't explain that.

> Also intended to expose this supported memory address range to the
> userspace via EDAC scrub control interface, though it is not present now.

Why? To tie ourselves with even more user ABI?!

There better be a good reason and not a better design for what this is trying
to do.

> >What happens with the aux devices you created successfully here? Unwind?
> Please see the previous discussions on this were about allowing the successfully created
> auxiliary devices to exist.
> https://lore.kernel.org/all/20250415210504.GA854098@yaz-khff2.amd.com/

There's no discussion here. And nothing answers the question "why" this is ok
to do this way.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

