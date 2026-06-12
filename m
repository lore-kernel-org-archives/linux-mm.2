Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25784CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A0F6B0088; Fri, 12 Jun 2026 06:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA3E6B008C; Fri, 12 Jun 2026 06:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9BE6B0092; Fri, 12 Jun 2026 06:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE556B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:47:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDD1F1A037B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:47:15 +0000 (UTC)
X-FDA: 84870933630.24.C471636
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0AB7140006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:47:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rz4AYiGN;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781261234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YX03BK2qmjHf2a7Mv9URt0qeSBupGSFb+1E3T4/eV8=;
	b=aPgTN0Qwz2wlKu4CoyJocGf1K4YrpCqo77HOFJH1fZ3bhXezVkLXj15TNy6yAtfNPtG81C
	2V/sbc5pOpuDRjN/d2d7OPZuth1+4BUQbospuBfcugXxuerXl3v8+0jftVFJKR+rwLzNoB
	rkL1+84vdG9xyS3P3WlsbgeluHP3uFE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rz4AYiGN;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781261234;
	b=GQ9AgdxsEPEM7btMCnzM5bbWGXAcbVTRqkvPIrhNXF0ApiezseR+oCJ/mavgsP1oEGP27q
	hqGeWNFaWLeNjaQB1kMLf36U6K/FwLkHL5vV67TENlyhEJjQ1KPFhcCVPHhQcEg6AL0CWX
	ZVjijFOrVxsO3jg8P2jaDtvf0kZjsxA=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9158629a220so97107385a.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781261233; x=1781866033; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YX03BK2qmjHf2a7Mv9URt0qeSBupGSFb+1E3T4/eV8=;
        b=Rz4AYiGNz57XaWLWbSL+thvceymb4W5jwGTcEPEcf7N4tjDQhlJH9RQJE985MxrfGW
         t2gkq5C6j/Jt8KguEeIHoqX6PBiABEPLTayZfsrxFwySOmkDNRgmRH8NSJNNFOT7Ya6n
         RVJS1UJQ7qiEPPwL6jPzNIpgfeA9kc52VAoSlJ5PqGT7O4+/mayu/QsIl3ZbczTeKKUS
         KpVfAHvusAyRFmPmsDssgw9SgBwX/tZQ19uvB6UgvClBMME+CbCDZ4Vuo4WkCRY9Viy+
         uG4KwolmVPa0pg4kWT34WEe3DONJDxAOlRmmYYMtwHMhjXNYIgxXjZGf+rnav2gGwQZx
         rHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781261233; x=1781866033;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4YX03BK2qmjHf2a7Mv9URt0qeSBupGSFb+1E3T4/eV8=;
        b=f8VT0jzPMhsQwRMqSp84nQKW9QD1zuYyZycVeF7ECZFTBymFYxh0gGtg6ywr727qjJ
         KR4uuSiNuSuBqayOvTiDQ+X79wJyVsperyYL7Tgw1gamMaIekW/iHAcVT+V14G8c8csd
         FeYZiM7zX/xMFhNrPJ8sbZnhBHM7UCj6XI5oTPbXkYHIEPQWy9UEKE88qmh6ptHgZgIZ
         L2dBssESqhRuqjXTvnIFeJMrRXgciYArVOSfl+sohQV17X0fn82RLOrEKT6vCbupRFIm
         315PKdQUJ6YczWMt2TvEFcvK14u2oHXhcg5dW5ayp6jO6qt3IYlsI/93ub+b7/QXzfuC
         Z+VQ==
X-Forwarded-Encrypted: i=1; AFNElJ953to3TgadGg0hJ7GeL+Cv+yiosC1o1LwtDhpONP+WB90CtU7/7jSbWNenKgw8OEZ/fq84PtWkYA==@kvack.org
X-Gm-Message-State: AOJu0Yy7Xb7DQLaPJ65G0VhStwvp/4xFmDkc5YsUVUFYT9d3dbcn7LYa
	L+PSQxZgbE3MzUDpn8dpNIFyukKdRbGyiGr11ZvE7LemJ7arJhw1hSFPPrWOXO0QXlo=
X-Gm-Gg: Acq92OHXeFAEYRHqx86OQQqNqvFfVmdcbSqJucBPWdlU5GxTcQylXHHu48fikw2VEBb
	7G8P9pwnvS/G4l2kVfDIAph2AXn4cH94gOH+eFxnrpUA3U5wloYEIUbluEuDITLL9Re/KS8alPt
	hLAtslxQ7PErZC/XWu4HtoswNAgbxTxtSEPSw7qaLmP7v/1EnY6+Ovt01oVRTdyFf9Hzjth3z6g
	rcWMuAkzYGLZjngHUXxRrIEsBSra68659ulohjHV/pv0ujCzS4SXgbQy5fT87rQMUc3U9Viduct
	Pdvb47stt61yFbTp6X/VGwOTo/XBwNRM89oxYHMrzxejaYVSrJfuCQ6oiTsIQz9FgUhNufx8Yyr
	gShOlQbrveVQD/jw/swHZWCf9pT+fexSl+/rUMRriTLvj0luZlSwNs6i4ubPBTIceuFwjglqMFD
	D+nBfms8OrMdVTrbtImzyKcq5gfdqfTGQZkadzmqToLt3cArl9omgPloY6W9+8
X-Received: by 2002:a05:620a:2894:b0:915:d5cd:8ce5 with SMTP id af79cd13be357-9161bb00960mr256901885a.20.1781261232925;
        Fri, 12 Jun 2026 03:47:12 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d30457764esm19942056d6.26.2026.06.12.03.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 03:47:12 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the
 PCI core
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Parav Pandit <parav@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <aiutNINqxhtlm2Dt@kernel.org>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
 <178124130274.908199.14827357870284807134.b4-review@b4>
 <aiutNINqxhtlm2Dt@kernel.org>
Date: Fri, 12 Jun 2026 10:47:10 +0000
Message-Id: <178126123047.908199.12042730612990730743.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=862;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=klfiiHVrid71PPzvcY6gYtk5jDnKIjwVEJeiVajF+y0=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqK+OvGft7vBLOTTPKIur68ZEWcTau1cnkC3skC
 zr1NiV+qhmJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaivjrwAKCRC7dyhM23N6
 3gyZEACjBtejaa5EWZ+XlEJc8O4GIePljN4Z+SFApZu13G3wo00ycXVVPBN6V5+aetDEBlFZrNY
 xw5OagriLkgPclJeE/mSxyOeT440nRV0zQFEVcf8vhFBQLQKCxAyB4642/MrXNo3B/PkoAoh0Me
 5aOMfam+XcBbudOzksGfJ7ZLSORV98BsXPrQ2Gsb6dTXgHFl//fyMWjL5VR6c1NBooV7xs5ZAO0
 OyLNZhDXi7tnur55gyTJ/0gH3Of9YOHVcrWYvVldEyhPy8lii0HEPojuUI5xhRYj+yZLO4kKpik
 FxHBtPVm01/VoKz953HN8d8gCvKq8fV/OXil9B8twhGfhtiAy9trrIboh49Hu9Y6rxKp8OMT3Dd
 YNjvpceH8opcMcU/iVBCcdU9MQUUtHcImaw1YvucE4iPfFH+ReeBRJfJ7KWFzAQbqwPUctLC4Je
 OSAgwwcEBo0QmBxa+F8FNfgRqKBMV8G9vlEkD5ZmjiCsmA74UHfOgL89LOWmLzxYFnubGLMUU/2
 25SbVIJ/Zdyyjp71SESgIGRiKKuS3NfU7976kXg7Jclio/CVpIz9cwvxf3WMC0ZKYqgUjX84syz
 6JjnY7o6rWtYmf1Cous+o64R7Pxmwz2jyxzHbudSfK2qe8Lcx3aT1oGWKJA/9LSyKcHdQv9dcrd
 zelYBz9lnBEqGvQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F0AB7140006
X-Stat-Signature: jha8yc6ghf4arhx3sxnsn71teei9h8bj
X-Rspam-User: 
X-HE-Tag: 1781261233-247493
X-HE-Meta: U2FsdGVkX1+PYtoVOHAryGT3N7NLSole1jGmBCl7IiP46yz39xgd7P1ePe+JpA+A/Hu/qSgTLPARmrGfhjCeJPfEvzCBHdQ+2vNzvJD0pLa14SBzXTlOBm4crE6wcxjAo9P7CVHM2aZNpGHqSSoJXA8m0U6OsPT6Q68p3+AMlfgEeh6em+CPVO9jx9u7HfeiaFkNab12IwhituvLsNtNOWUM3nwhn0LXVi6mSyIOwh8ZQD3Q01QhZMiNyNwIX1EJysBQ9qg0giPcJ6EB4+Kghew6Rhn0o5LXr5kQmwgdyi/NzMTm36wbKSkI9VWemc4CynPKWvssBQtyGDU8CD2L6qF416mTI2eC9K2T0x9aBppIjbmhkyR0HoTYNKaaHc0DyQhPoHfrhJS6mrqeGKrxker+lwUa+OicSjEYAM79+2Cmh2qeYzhMf7ScYOfAsncc82pkLMZGqqnYlR/Hm2YSn5EFCxkIq7h+bmyYjMz7bg0GxmMqY/FnZRBbcYZbmFjY9ddgMD02mSEkLOf/a7hLV8W9chaUK0l17AVyUKM2UJvLtRYuqGFQC/qmVMnD6ljYcAf7+Z12LaDVzOd0BW/Wi9+rlBYECzf/2l/Qu9ZXunHEbyJOXnHm87+YFvy7AZkWnJC3F5mY3310/2wGWYpo7wc5pV8A5qVQ+jpgbKO5VdFjx7GuK+oFOQ81niMae2RgEJOvycxG66mpx4L52NWiYFYrqfpfsjyDn4wqNxmdnqC/YHPblM5ZLzWlyoU2OSp3dhIEXcQkf7vtqAtjJFp/ubVFNLuAA6vSCREqupBST0mejn6jK8gUoTEOaJgK/iOuGFIMkN7gsSBhAzprMpeNlT94LZgdvWGFigfaFR0PEvypx4HP5cGe3xTJzh3uj9ReNg/HWI+oiKD6kH9vdM3oHAqvKs2csJwt2vuGqEWTgvH3bXPLTOJHMWCNXRG4zuHEtuQKAmsXy4SJTXCxx0X
 FV37esn+
 GEHV7PbBMzo048LyVfUXdX/fXABjYikTw7viLo0F0iV7/3JdCMVFpyYbjok/r/C+VvfXgg+quZz6XT/m52VnyB+f5XgHkRpZN89ta/kmbxdTCgjZFugl4TcfA/fGihTeHfPrca4T1pfjXuuT9FJGr2H4uKM2dhzHlyNO2yYi6GZ39eVWAcKopUSQq0jSRoZn1kEjcsMS8OedxZHm/hk9hTWlPCsjF/JTtXU3l2LW5RYlcudldNd8vW9OUv7t8PBZe4FUYbtEfkxWN1xYEyxh/6uvCmqFBBauqJs8ueHSws7PTero=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-12 09:54:44+03:00, Mike Rapoport wrote:
> On Fri, Jun 12, 2026 at 05:15:02AM +0000, Pasha Tatashin wrote:
> 
> > On Fri, 22 May 2026 20:23:59 +0000, David Matlack <dmatlack@google.com> wrote:
> > 
> > Please add Pratyush, Mike, and myself so we are notified directly of 
> > incoming patches, the same as with other areas where the liveupdate/ 
> > tree is specified.
> 
> Or we can add PCI liveupdate files to LIVEUPDATE entry.

That will not work, as we cannot serve as maintainers for 
PCI/VFIO/IOMMU/KVM, etc. David Matlack will be the maintainer for the 
PCI components, and we will accept patches once they have been approved 
by him.

The simplification we could do is to create an email alias 
for the live-update tree maintainers. This would allow us to use a 
single entry instead of listing all three of us individually.


