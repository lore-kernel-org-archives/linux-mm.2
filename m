Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDEDCD98D5
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0456B0088; Fri, 12 Jun 2026 02:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70A76B008C; Fri, 12 Jun 2026 02:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86CA6B0092; Fri, 12 Jun 2026 02:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A64206B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:55:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05867C206A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:55:00 +0000 (UTC)
X-FDA: 84870348360.21.A2F9F3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 56E9A140007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:54:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0zzp1Vb;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781247298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhHuyn9lAJ2TBe6sen6L7PJ/bBv8t8Eeg7AMLr+RBEY=;
	b=0+iu0vbCL/0wKJYANcACPpVE+XD9vSXbfL6mYaBkRZ9ok7Kzu4DTWY+RcdecsDIrvB6Yzg
	6+lgWK37LdI6VF3ftMxb31mrvgcqUqMFF8D0J8FheHdulJI8F8LDEwDYuDFtBGGEyN7dc0
	3S5FC7B+i5elY6Kt3xFr0a3v5IWHiOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781247298;
	b=VNzAPdUJBy4NBHTP6GSoO3gtBaxIysLRGlZBeibQONLdipXj5WhFRXmWleiqaDP8VYp9vH
	C3r+t9NhtI5HVOPGi25OPKtShZJ1XwuUUB5XzQfO+zyOAsut+CHLzyQg29562K+iZ4DGRa
	TzDP9QKFrdjKEwgOsmNJc1hnXsVzaJI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0zzp1Vb;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7876C42E06;
	Fri, 12 Jun 2026 06:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB881F000E9;
	Fri, 12 Jun 2026 06:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781247297;
	bh=rhHuyn9lAJ2TBe6sen6L7PJ/bBv8t8Eeg7AMLr+RBEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c0zzp1VbOhwnHnR764SOHjzuUzLuCf0hRmFHEPQHn1tmhTJaP/SX0y/55bvPDoiUq
	 gHAzxMyVZaibctQ25ccizJUQKTyJATi/4P8mTr3aQ/Y/0adVBv/1q2JqZm6ekcZ9Ih
	 CGF+TxCzYGZuuURbgXg2XnPALpoKh4JJdoEBKPj9BmMmHB8rGL07qaCd9dfbsxGeNL
	 i6hZeQjlmqhXgDiZpvcUl+Wavsxqw/L6/g++NrRJpEcVX9rYWXvtLgMiuxkSMvw/DF
	 Bo3QwomiMYWWwXnnVD8pGpnHdoP752N3NYpX4UVdc35IRZBcPCtdTkCZhUnq8nvWSY
	 D04t4dmjsEA3Q==
Date: Fri, 12 Jun 2026 09:54:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Parav Pandit <parav@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <aiutNINqxhtlm2Dt@kernel.org>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
 <178124130274.908199.14827357870284807134.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178124130274.908199.14827357870284807134.b4-review@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 56E9A140007
X-Stat-Signature: fogsti17jwm78knc1bbfo4kj11fuzx33
X-HE-Tag: 1781247298-537093
X-HE-Meta: U2FsdGVkX19WOGUEIGZTMhCHqT9BlUoQlB+53PM530aIdBk4YjjD+3V0epiC1O/By2T805BUYz2Sa2eiKjsn5lFcKYbj2iWlR9i9PjU6dE69bGTnL6NXLFQJOTlSlON2R/T7gXB14czSB6c4WPKfR1GWzGEJQR37oQK/hBrl5ahUglVYJ1v1pGSJOHKXB1yl6Xu4bekFWTNkCHgoy+cHaaDlACesAgFSgf8yLKHvIa0qevOvf+27gO/ADT8ihVqSFsSQFcOQVklYgalKMcv0ECUWdDwzKFbdN3fj0jEybfBXuXCwSKwvvVX8YnT7Z5OXuVa08RI59ZmUTjaP8ra0Ni/3AB/P/afRDEcp2NBnUL8cPHl5Ll/5FKzLi6+muXnTw2Iq1/yCFm9BfioKbhYphYjSzEy4jNGmaA6dO/xHegh+6IliI6SgwNc6xNWOhgSZ3VKZgqUZHs9BC9hx8fqH6Dx+ONbEYKuKPS0JDXVbFi9qLp5uQER4chfo2YluJmk8IvuuBK/ByvwxSSVBISVQm8W+0mhyFvVZm0h+kS419u+YlMAztC4r6ov4MYZ98BDcr6VQKqwC7RBwWaEXB0njQ3SU/9lBNhQusLWb0fLR5MiEMkTL/cdu2fssx8pTnsrJ5faUXQZfX4f9tk9wSoaie/sBuyYqUxvluOeAs3U6ypHf16AP7fhBVxJ9PkrGs9uByjT4VZqdZULb/1c5m3esEEIMFMMMj5QeS6tmr2yqpBObZovOcuFSwTdz0YrKbsaIjL1EDkj7xPDAvpdScpJ2uxrPoSGyduOY0j867F6HrZBOqX1Dcc+3HywwdfEGERuXUC18Y6uD4RtwzvIFjqiE5S6wCmDY8yI/PLhdPkkelSovg1IlQ3L7hkL3U2e0bl5+yxsHWtmDWnUi39iWBkxbY7JaP1u8INxCNu+mJG9dLXIwAYzIC1A7FS7lOiE7NxME6Pmh5dZka+xLl3REiiS
 OBXdfOyi
 hrhPJrxmufGLysnxtjp8gu4DV4Uyib+wVZG/fNdrGnNChInylLtpkX3GhJsQ4ICI4bbCNTHXvjXsXmrPqZe/7aDRD+GuW368L3QsGtguk/NeDNKc283n+EOqUEHGifTHs+uYUs6uFyTzDpPB1y+WJeB49mzlZkPGXpGjHHxx8sr05bzh2D9leUuqgCFMBxM7YsAifGRd+gJlVjtg8U7xFx5dJ62TMnsMfFpKB43wCikNlnFqjf+VEZvFe1pJeWUxQW1OMh9X8j6r70a+/poBdX/MeLEXIa1J3OtHtHiirY3mRa7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 05:15:02AM +0000, Pasha Tatashin wrote:
> On Fri, 22 May 2026 20:23:59 +0000, David Matlack <dmatlack@google.com> wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 2fb1c75afd16..6c618830cf61 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -20530,6 +20530,16 @@ L:	linux-pci@vger.kernel.org
> >  S:	Supported
> >  F:	Documentation/PCI/pci-error-recovery.rst
> >  
> > +PCI LIVE UPDATE
> > +M:	David Matlack <dmatlack@google.com>
> 
> Please add Pratyush, Mike, and myself so we are notified directly of 
> incoming patches, the same as with other areas where the liveupdate/ 
> tree is specified.

Or we can add PCI liveupdate files to LIVEUPDATE entry.

-- 
Sincerely yours,
Mike.

