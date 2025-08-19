Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D1CCA0EF7
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA398E0003; Tue, 19 Aug 2025 14:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39AC66B00DE; Tue, 19 Aug 2025 14:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0BC8E0003; Tue, 19 Aug 2025 14:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA806B00DD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:24:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8E8456E6F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:24:48 +0000 (UTC)
X-FDA: 83794333056.19.B70A6C6
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3CC5E1C0004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:24:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EwzZComd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kbusch@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kbusch@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755627887; a=rsa-sha256;
	cv=none;
	b=qXvHnCd5amZ9gC82GVQYH+mO+NvEU9V6SjQp8NLAlXGz9XSboBcM8CBqRXRbnEYvsaW93/
	iKoGPEnsZLUrhqqfl37T9Th2wh6XZHpVEMICFEdMKNz/rjP/RKUtIppdQ095tj7J1N/H6G
	N/oL8IJFtsxxjtIKetPi+pzTHN1w1ME=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EwzZComd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kbusch@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kbusch@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755627887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Jymx+EA6KESZceDiO0ZcOJChcO4ShLkCuHB0UCXkIw=;
	b=JLPicpg2+QEHtSy825Lhc2y12w8XDJw5LKAr/DH3/w4RM4sd/ZPe7MeEVa0xHu0S9sZRNO
	hzdGmHOdk7YfbbcypfvQzB5oqn+HkBtwNVS3mtaDhoypOsBQTbyCOm3JfHX7ZwfIElVMQI
	mcX2OjcDqMAShiPQdshwV0yGdnuaODU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 340915C655A;
	Tue, 19 Aug 2025 18:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53727C4CEF1;
	Tue, 19 Aug 2025 18:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755627885;
	bh=SvC+jn4R/dc0Ind2g0hlwOADBQmeZeKp/GI1XBT+Aws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EwzZComdy/Uu53OXhh/BwwXin3VgP9XbYbPukl1+6UUrrmT0/QUgfHPWbl0yeg2IQ
	 anqpbJ7fssVt9ylAxZXZBFI6XmgBFt76Sf9R+5d1q0uCECHn7z6AVgdwiNFmtPzUpZ
	 oIJpPvDGleeIPwFshu0MK91r/Q4vlnE3hv5K/BQn4hYDk2V66e58pXhNfNYLb9ftUC
	 FsprkYGd3dpPDZ4hTpasdYuKUOBt3HQa7ezc4te6CtdhPT3gjHwY76TvaUfRVubpfk
	 /uH6qQQOd5J1UhIfM2bjnt3K6ADP7bZZTesuRvLRHriJ0TMIrB1SG3izjobM9UNSdA
	 OKRS+aPZzKk+g==
Date: Tue, 19 Aug 2025 12:24:42 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 15/16] block-dma: properly take MMIO path
Message-ID: <aKTBariwz1_XsRv0@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
X-Rspamd-Queue-Id: 3CC5E1C0004
X-Stat-Signature: rfnf7sjx8cfjpramieqwutea5embrcfq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755627887-965863
X-HE-Meta: U2FsdGVkX19TivkNh1qYSrzLHc8rWVSmQqrppAZePZxJ5dEAMI2AXQqoi1o8ztesH4uq4XvRzejHmAfOCH6jEZaWvB6x6I5MvnKPxREbizsvjBCj5SvySQvzhAH7K+47adK9sCJAzXcdlM3nQW2aYJO19srwX48vq9kI2QlzssbWVRDKS17U858+wYviWwVkacFLCCVRdqh/Ic5T2lfx8tyovFBaEIfVgQlsXcLF+3WsM7+1teRDeWJBtTb6+qCdB8ODg1nyPILUHIaHHQ+z98e1sy4vszNcD66PJtZ/5qDC9GRCQDGefUSFYlgb8PmnMV03dv59hwL78jvaVquYzVeBL+7aqXr+2YQPGxA1AOwfglAbT7FGRMRjqi29+UMAVMrRu8zJtf8ppX8Q97u0jqmmRYpmahpIm7iJDUeVh9L3WfgOQ4tIADjvC2H1VtRuvcYJMGaV/YAeCRW/HqeYnQTIYCJFbsUMnBXoQ7yeh1pPYVife9cSaImElAFt43TViz5F2LadYhZkTTd2isLC9ymD5i42JNCJ1vD77kol8wet23oGPY3zKM7O3c8hM2P/fotlofIVGm0saYibEJ5rtwA32+6LXn1cU3MRGbEumdFPAGD1yTmaMJP6sru3H2l1/Bp4yp73oI7LNakTq+FXr17s4bVeWgTl4eNO1scIrJmlGn9v/YdB9nCemVFf9cqDpBSND8Onrhv8EG00ER89c1YtJLjZTsw6iVrMeB0GX5GtjT830RJghKYOz59VUW3+XnFtXY5dRAWt5PYT7kKIhzhW9TMnUMBAlyPVLDCHCBEd/0IrxAMl45bzvLGpOUJ2eFM+LGJafgptmEURE9Uy2vFpD8fU6n/tOLRiF4lb12xnvoZFw90xi8GsbIamNPYo9TMYRnsDRhxc7TQixRy65YcK9q2S0jHVGikvb+j8dg3RnQQH0zohm8NljFz7ahFsekvGiKmqLuninK1uJlT
 oBC+XNvo
 IoxPzJ4RJ4qfqZYVUYeTGB2IeVE1yx0U+wtJ1V8uZTegaaEFpmpJBuUz3PdEnUO6Z6BLPfB2H/6STdBABIcw9zjJyx0Ax1127eQ7ZoIgiYsSA0Wl0peXbuyzI7yPnCsAYxc5CSppLJUNqcX3pRYTZtXA87WHCfDatFmXJUcuMdhfv3aszFFM36LFuH+AFSdpud0dVdzpxUl7yo/53Wp3nVv9LNli0x+dSlthMFVCJ7qlF4HMTPK2+Bome3zXOnLQKMSX4Pck9Ns4Az3IjTZZOLQbxkbOzxCaEFcaNtfSB8vfqtr62BH+ILMPvio36R8kG0BDyoUKSocMt5EcopGxv4Bk2K3kqdrHu5RzW4CmRmv2DgG86nX+hIIah3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:59PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that CPU is not synced and IOMMU is configured to take
> MMIO path by providing newly introduced DMA_ATTR_MMIO attribute.

We may have a minor patch conflict here with my unmerged dma metadata
series, but not a big deal.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

