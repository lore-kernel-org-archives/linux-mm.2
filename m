Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44615CF34B0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC3D6B00B8; Wed, 19 Nov 2025 08:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C9E6B00BC; Wed, 19 Nov 2025 08:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B326B00BE; Wed, 19 Nov 2025 08:54:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 710246B00B8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:54:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15B6389608
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:54:16 +0000 (UTC)
X-FDA: 84127500912.30.FAAFFAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 56E54140008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:54:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lOc+pw0S;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763560454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y45nMI1mbLz9G34uo5lDlXGTr5Y3YBOq2Eva63SbSBk=;
	b=ofNbvVNeiFKko1jpBXAROuC3N8VzlKtcmU7EzL7XWFQx1mZ0OtT8VNXFWjc1Oddt4s2mfM
	J+6HrnjSVt5BnzgzyIzRFef9uJWBOAldBx2wYJCTZiKJcXBZWF0di9BZoovm7CKQ7y8ZJz
	5t1JNdlAQ+QK33GFj9YxpzeaLPi1i3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763560454; a=rsa-sha256;
	cv=none;
	b=Xd7/MLzIMkg/YYRAUkVsDD5yC+/qs8xz9E9X3QfzTDt7I+CnPB1oXU5mO3ZUH2q85vVxjA
	9muyHs4u+IlZQ85ezx/XnfE+ju79drNIPDwgjwkmR1qx69PrOwckOLeyolxijkTdBVyEs8
	4vA4q0dYKcAMEq4dhINBUwsBA/U+lHg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lOc+pw0S;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E82840251;
	Wed, 19 Nov 2025 13:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4089C2BCB6;
	Wed, 19 Nov 2025 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763560452;
	bh=khDyF27Ua+YvAG563h+Mn5TVNwmjUpzwzSeY1s3ZrlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOc+pw0SropUFqAbVYzMoWEHW1jJDTrt97jUDXz56yN0le/B+KOyXK6xnERbWqNdy
	 LBjMT4gf6zJ5xLQ64pQkqww1I8qSD+7y/IDRApuyDvzXjq9BFKkEOeCi8bxA/oo1gH
	 70+OJhKd6XWXCZEn57dkcHhMJy+/OipA/ho8GrlgsWfIHeiMPKdy6djUHim0G3aLYZ
	 Smu4HN5s73AeSqAjTtbTpkSpzB4YO7/XVcv9jfbhTGeKtpPOUqXybhXbJn04qeXgZf
	 DJ8SJ2zHpC/cN0o1khK2H92TSVtXxhG0/mnVCa20BOeZHJlnQ/YkrpnwOm6k6yFofi
	 vqwHi5UdKLC/g==
Date: Wed, 19 Nov 2025 15:54:07 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20251119135407.GG18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
 <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRzUpmUkDy-qN5c1@kbusch-mbp>
 <BN9PR11MB52768D54FF42AB11C49202C98CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768D54FF42AB11C49202C98CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 56E54140008
X-Stat-Signature: 935t99sccuc4uxsrd5mp1oo4aqxn1okm
X-HE-Tag: 1763560454-239561
X-HE-Meta: U2FsdGVkX18tcMKFKTlb41/QfVbpn38mXtWGhlLDiGylK0+l/2rOY4M5QsEXH4XWM6+ieq+MXDMHKZPeBTG2Ld6EZEKJlbinno/okt/wG/c76Je3CgGY2TWUy4CdBZsjVqhHxGeffhUz5FGJN5kHqUMm7g7NpXdx7g1AAUZt1XW/wvqWKmML1F3o8BDkq2aCJkT3vSJykavgq6U+/M1u5LAnvShdAIbvbas90B3NC/qub26qw8181XiseK60tlD99rZVmtKdlQF2Eof/iJYz29iPt4ReJosuWlPNyRhW3MZu+oUuXMQa60fXZ46Pnr0B3wqtN5ccCz0ucwgcuKHVNzqyKbVqIVA8A/HxtrIBXppDOEKxEZYFfQS73P2E3ncVF7gXFtFPtkgthptNfF0MGWcGu/Y6jluXkD/rbHTTcEaj6hHfEBGlFZMvFHXALzJ4qbecPbsAxyN4lRqsBkNH4jBQjxvJRQNZMLh2CrIsvMjE/Ue56PaYh6vDVRigEVFeqyeE1Gr9zNJNJSxgpyZyHDyDPiBsUpIGLwmXFs8sEzWv+4mYY+ZoAZunMP/x6X7E1HcKjs2jZoJr/TBmneCY+nQ1TlBlc6ZtJcclPWIKMqdsJIyNBCcFugLZPV107ZvEHfEzWq6yKc6Q9EpzFU7weOfCg/eQ3szZv/N4YqsRcH7U4lmvp3AftHiezj3klwMQ69vdk04IY0BTYIkahCp/gIAS1lPEHu/o42CBFK+qLOl3C40rb+Dku48+BPpWwl+StjDl3mSeAbTWKraaBUJghGojiHv9v2IhBAQoRu/+hhCHsjBgkyA0zXkSfCy21b87jI0p2m2r+Qby2O8KRuQlXPhJN/+wu5BagizFnfZK/n58cULtcwfVBZbAid/QvNeouNTkiFfZ0xSCpkuLaMohynTLyg1PTDHzSLgOeSshoEzgJ08+7Lf4GLIV8EZpBXfrGuvMmIlALmRBnfBF/aw
 MaEXWwRy
 HCgaiNOuBP7TccIKsvey9HonnvE7EU5NyoYtlvRtp9hO07avR60QSNkXqlo7czop7O36hMsOZHqvrfoaNOdLzJbRHGdd0G4lS2vok7hiIbrmp5h9cva8zmPkwG1bdFp5e93zZbjEq72ZEOcBlt1p5U6joknV+f2rYWkpxp1lTOffzmEHzhNHvrVcmmyJ/t+L/yUv9pIWYNbYCQ9ZRsWLNUrHrxeNh2gsZfPHuwOYzkvpjX3Tcuk0iQJxD0NDckSmKBnYZebGwfzw4OB0dAzyfjJEu06RBQuXXycSnFlJuxPtDDszTrMebMOf0rNcp+xy28+DRdm17+JkLhMzXWHVafqUx62WcL6NkHWpjq2CWv+lbcbY/o7CsvoyeuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 12:02:02AM +0000, Tian, Kevin wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > Sent: Wednesday, November 19, 2025 4:19 AM
> > 
> > On Tue, Nov 18, 2025 at 07:18:36AM +0000, Tian, Kevin wrote:
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Tuesday, November 11, 2025 5:58 PM
> > > >
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > not required with only your own s-o-b
> > 
> > That's automatically appended when the sender and signer don't match.
> > It's not uncommon for developers to send from a kernel.org email but
> > sign off with a corporate account, or the other way around.
> 
> Good to know.

Yes, in addition, I used to separate between code authorship and my
open-source activity. Code belongs to my employer and this is why corporate
address is used as an author, but all emails and communications are coming from
my kernel.org account.

Thanks

