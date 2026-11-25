Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D602606A331
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Yhzc8OhL
Received: by kanga.kvack.org (Postfix)
	id 9B77B6B0A97; Wed, 25 Nov 2026 13:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F5C6B0A99; Wed, 25 Nov 2026 13:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E206B0A9A; Wed, 25 Nov 2026 13:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 670EF6B0A97
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:03:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC7E5C1056
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:03:26 +0000 (UTC)
X-FDA: 85474413612.25.33217BB
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0482B40002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:03:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Yhzc8OhL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795629805;
	b=W8lvXRa7unKXn0CMOKzjzCaRiduP/4uGOKeHnAhGCtgcSmCD9BBxtWNyEMLYKPfQ9nc4eB
	uYaJLddA9PoMPyB6vpqk1wAv3flTOME2afrLuJZ0AfRdy8Hc6F+NXQUijrekK/NTOJzMf+
	qJQzA5zou44NNmvgYd265k/rsS+EW+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795629805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+1AYy7Mp2a7SBL4ePYq/G5iDJIRCdCJCue8L7l5f3k=;
	b=7qooyPfbi0cszIPbySHTB8aXijp6MZ5Zr5y8ZMI0eG6I48JRShjfKDIGohLLnhT5HiEPWI
	J78M3DYQ1wuEu51jIWdwwYFoZ/sUarjjqNPzv45Gq5YpebC47bjrOQaVQXuswV/AKpKY4O
	ykR1m8liC35hEwS/PXfHzLJT3cUMYEs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Yhzc8OhL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2efe591a1f6so21044345ad.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795629804; x=1796234604; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=X+1AYy7Mp2a7SBL4ePYq/G5iDJIRCdCJCue8L7l5f3k=;
        b=Yhzc8OhLBevFNHWzOWZZcIxzJOmm6R8OzP+/SlZa+JPzEltjEI2YKLlwH6XH5XAjeL
         55nb+meyA60dzyCE4RvNOjV3HOCm7Sg7QErVi2E7j8n9v6zy8RLKL6+pR+/yC6G8QyVy
         csOatQQKmcf4sJ6HPNyOVGOiYLgPnyZRSbwTcnClGAZdPioI2zNYzdlJn8okwWO/SZsi
         EJ1zqEf84s3tuSBRXiCiDtzWMaeM1Zr0dwP5/KBvfZG/ian8/nuX0fz9KnWBRMlyStf7
         8Okg/02cMT4lA5pH02ymJsTr302FNzsSbF3tOnn7xvsyLuSp3kXGxTI122IJ+TpjP0ta
         mokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629804; x=1796234604;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X+1AYy7Mp2a7SBL4ePYq/G5iDJIRCdCJCue8L7l5f3k=;
        b=0OfVTpjpdwEoqeb+UG6+MuPaE1Z9gV/fop3f1wmT4HLRIKqNGG+BgDD9PXAa7ggIHe
         777JMnntX15XeIPL7BZl74oD3+quh1ICNB5E2jrECM3iZXtRqLh+mM8wZo1H+zMm1RZa
         8MM4KLhCAL3ucu7XNTMffs9QLA30A9tWTUMOIGhoZOMFtY9JLbZdxJ8m7f/B+NA5Gnou
         ep7mked3DrAaJtqqGgL1yTu17bry3IWQLytgzQL0TkvykRPdnW5yVLmAcxggPP4GoV/q
         ObxpLkKxE0/i02abnaNPycz1/b0ZwPTkuK7VHOv9bFVpK1bhjfRCDAxuqbSUkd13cgyM
         9GAQ==
X-Forwarded-Encrypted: i=1; AL+hErEPZEzc78B2r0lHS9FUBhKKQffwXZoQePTVnDLIRnTK8ZzAWb1gq+udzEqlTkXrIrjyjRLp/214/Q==@kvack.org
X-Gm-Message-State: APuU4Z97eIOiPEF2LW+VfGhfS5uUPl0WNmOq19qAOpguS/8ZmcSy0I3l
	Bg3dV+Rt0pf3mLhT5UWbdEGPErgLYsLh8l9TrWfVv/T9VZZOQ9AdJjhP2rlTbu0d7g==
X-Gm-Gg: AZFdTZdlkDh/EgJaIIXpfBglrv5shtkaiuauHlwVQFE8TG2dSQ2cpWJQaB2nztRlfgb
	Wk0zhKLHXhLKAD5XexndbrU2Yl93Taj41XU1fCdQeMDjGH1cQs5j0TeEfzJH4LBCbqZUXMnfkUc
	iV4YyekHFnjLHdjK7URAiEZneTlbuS1swXyaDUTJ584hy9hPH5by8odbk+8KuKx+MRX5wf8gU+0
	mZmOB7bIGV+FAnsccJkqfzwzGfBQZHQ6PfXvkehrcCLESzOUFUhNBCNtgV94dJ7AuqhRyvUMmv3
	GyENLHYkdPKHz1p+5tSO+5sCpzCsfPg4dhPUmOh/9CTyB9hwsqdO2aLfyaPSBmOcq0JOlrAuxk7
	OeVxK0ft3070mAcvijS1KwI/ssN+ZGJ9eekMrdSERI5rJ1FYJw23tUISKdaYsunlW/l72XZ378B
	t4okXWTIegVC3tI/Gi0OFkgbbsK7r6tNRuF9fKjrMdy409txM+vfecPpXrY6UW/m2IXhwZ3Rf70
	8VdUhOiqxUSp9i3YufndlHSUTonYM5wGX4+f2+6rM+spEGlxc3Wf5/kO06t7i4xqtguXF+DiWU7
	DRGEjJwMsib6G86WwKRH5EfRh+05/rFBBpX4Phy6vH7B4iqyy7eLZ7PajFrJv+Az5w==
X-Received: by 2002:a17:902:f54c:b0:2e8:9820:80cf with SMTP id d9443c01a7336-2f03f1cfbe5mr188390265ad.58.1795629802894;
        Wed, 25 Nov 2026 10:03:22 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f14a432sm91361725ad.75.2026.11.25.10.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 10:03:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Nov 2026 10:03:21 -0800
Message-Id: <DN4HN2W6ZVES.289H6BZD9U7KB@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, "David Matlack"
 <dmatlack@google.com>
Cc: <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <ajayachandra@nvidia.com>, <alex@shazbot.org>, <amastro@fb.com>,
 <ankita@nvidia.com>, <apopple@nvidia.com>, <bhelgaas@google.com>,
 <chrisl@kernel.org>, <christian.koenig@amd.com>, <corbet@lwn.net>,
 <graf@amazon.com>, <jacob.pan@linux.microsoft.com>, <jgg@nvidia.com>,
 <jgg@ziepe.ca>, <jrhilke@google.com>, <julianr@linux.ibm.com>,
 <kees@kernel.org>, <kevin.tian@intel.com>, <leon@kernel.org>,
 <leonro@nvidia.com>, <lukas@wunner.de>, <mattev@meta.com>,
 <michal.winiarski@intel.com>, <parav@nvidia.com>,
 <pasha.tatashin@soleen.com>, <praan@google.com>, <pratyush@kernel.org>,
 <rananta@google.com>, <rdunlap@infradead.org>, <rientjes@google.com>,
 <rodrigo.vivi@intel.com>, <rppt@kernel.org>, <saeedm@nvidia.com>,
 <schnelle@linux.ibm.com>, <skhan@linuxfoundation.org>,
 <skhawaja@google.com>, <vivek.kasireddy@intel.com>, <witu@nvidia.com>,
 <yanjun.zhu@linux.dev>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files
 across Live Update
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com> <auzftbPFO_6XBYVw@google.com>
 <20261117220059.GA2250529.vipinsh@google.com>
 <DMZLLYOVIGOU.1RXWYJN6UQTM@google.com>
 <20261124234830.GB3545683.vipinsh@google.com>
In-Reply-To: <20261124234830.GB3545683.vipinsh@google.com>
X-Stat-Signature: cxbdqee16w5a3iyschc1eqyjadt13ox7
X-Rspamd-Queue-Id: 0482B40002
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795629804-527932
X-HE-Meta: U2FsdGVkX19vGzORhmvFGXKBZJsehK30WpLQxX2ffhaciAsiG+VS4R6OfsDdIjH1wkLCye3qnvlY2Ax0BqMBIehiuIgZq8lyGqcg4jHsi24IfjWVLhEMzcX6BdXxKrWGnpj+p9Kbco/tFme7oWL81ID7GkiCfi5uIeEQt7CcrmU/AJZ3VBQ5wk1XdPsu11mRxoqS9uDMpSPHPaf3T54sJFtndyd7eBzGO+V4t9bSUgL8d52HpavSCIRViLUmdJseNvC4S3gtVYEeSqlP37aZd3swGW+DmcBxFP0VYnn9e5+2YjHgUQr7gNLQ0pesxdWHbtvNag2fVsTIRfapdVavcM00cvot6aUxcQ9YwkPAcsbXLkQBUojG3OPXFpWw31ffg2hu37ZWoB0YF8Jzh1yQrC+5vj21ayg9FNYW98IjW4krSnuCCEg61W7YYw9HhRzKtfG2HhWlZ3mE0AtOmK17Z0QqrZMURDCPhdHphPz1vHpUbw4C1VJVip+EmtMJd/bXNGzsUHy/hsbK6sNy0hIEKat00GeeIPQVSXfm/bFGZG1C1b8urZDwld+5ImIXWffWo3/vxGoQVraZr+UVxBMech482tRDZVQMjUNkvd1XIwCMoEyzxTqiG/3nyqbhDJh/a8QNKy31R3iOTawgmEgp8PuYNmS0gighkRNcKH9u5lhb1c3TNEVqrNiwPA1LHriG0uUO6coXcfSG8FEcIbWK2yXryGI1khjav7PXIdM2JiW7/YWNG0lvC8yk3peIn5bEhz3ZWQotddjGzr+GCsQxy+5A0l4FCe1Crt9MzkTsKi5kJdTwiJIyTsGJ1SwsVnf4FgYxEOX4lso7lLwaK/jhg28wVh0kjCXKQHApbWTyNvp93wtTNjY1UZQHqEJcyFdmkFTFfku9B46J+B632VFI7iverY96WrDHFZ014uWS2Ipwi65rmVn17GVyKyl5SbRnr6cVbH9kHmygZR4M77k
 ZQ/GHGqz
 o12TfOnxW9Icml33fg+MA9CLqfrJ75YkyjGcy0GVdUBsZy7ZP+1VrPfHpMDhMRqlhOYt7R4hJs1179BAWQMcgK08xASuND/jKe3lZEoCjxcprZzPFr+OQ0UHaSnaqQQeLlJjVh7iF0lmraxPL8y+z1TEOhkMDUhEGWzaaGjqJUmxmSO0bPeDuR+rQxsq5MM0sI5vXFCjMIFn1czRj8TmLFYTmduiaZMHLXFazHmpB+eZi9qfqRhx5Dqvc0wM4ahKxYvXqfUj940PUiGPTf9kmtxnWMyPethxuLt0FqRvesqFcgylwq6fkzcw6nTcnZ2N7FrAxkraROePNVuiCRrqRkULie61eNHkG7q3LkANoQ18402qRwmQRdKezHH1n89aozxklt6dNZQn08lzOxB2iGWEeTsOZIOefHVYOadgiX6XGMAq2IC7Sg0JCLt5wEp5jq0+fRBf1A65IxPY4sUytEWiIA2J59QcfuRKxO2bdCxVAJ4nwD0hZd4TSOOJW7/495Bgmgr7bJ+0tz2R4PiwjFzUIW0kfdGy29ZjSIauZ9RwrGyHLB3sHL+Tsp3bIKNPRla3CO7A0+uVOPy6B55R5erRr12BgKSOwU88/Z/Bgux+x05zTBBjCs2VT7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 24, 2026 at 4:22 PM PST, Vipin Sharma wrote:
> On Thu, Nov 19, 2026 at 04:06:38PM -0800, David Matlack wrote:
>> The incoming kernel computes its own virt[] and write[] masks and
>> requires both to match exactly with what's in vfio_pci_core_device_ser,
>> otherwise it fails the retrieve. On take-over it uses the preserved
>> value for bits in virt and its own freshly initialized value for the
>> rest, like your option 1.
>
> For now, we will be rejecting any changes and in future when we add
> userspace opt-in mechanism then we can loosen this check, am I right?

Yes, any difference fails the retrieve.

I don't think the opt-in would loosen the check. What changes is the
masks the incoming kernel expects: it builds its emulation for the
device with the opt-in bits recorded in struct vfio_pci_core_device_ser,
so a device that opted in to new emulation still matches. Devices that
didn't opt in get the baseline emulation and keep matching older
kernels.

Separately, if we later find specific differences that are safe to
accept (e.g. a newer kernel allowing writes to a bit that used to be
read-only), we could relax the comparison for those. But that's
independent of the opt-in.

