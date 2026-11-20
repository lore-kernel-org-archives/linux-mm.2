Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786EE606A6CE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gMoUSUY2
Received: by kanga.kvack.org (Postfix)
	id 70AA06B05B7; Fri, 20 Nov 2026 14:25:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1BE6B05B8; Fri, 20 Nov 2026 14:25:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0926B05B9; Fri, 20 Nov 2026 14:25:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33DA66B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:25:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB302A6BC4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:25:07 +0000 (UTC)
X-FDA: 85456475454.26.F642973
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id C497DC000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:25:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gMoUSUY2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795202705;
	b=2BaWm31GqHOUt6780VyqqIr1X74qwvb9tPeNgMrvqGPeenri/+RsEbw/GIfL3wDcUxxu5n
	0Ur89zoGKwmKoeXez0WXwfUg/dQx2L+cdHvTXY+j7PA2WUXlI3s5TZulCoCdk1g+v1YuvL
	jQPq1Z3srZ7fcHnpTOWco8sJgsGM7j4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RuK77T8Pc2yA26RkCicA7q1V6UBHbE6inBIYLOkP8Y=;
	b=af865VRwSF1xuBEXdBqH/ppcRI41l2kI34ievFfdyiGUazuT5BoNefkTBqyToZWYSi7vzJ
	P2t8JHkZN6ht0i0rVUtqI85khf5JI4yVcJ6upEq/Y2FKbvXgzd3sqfMJV02XNElgoSHdH+
	N9JWfpu6JCxKa7LfrTsIg4Kt7nXUsZA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gMoUSUY2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so552711b3a.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795202704; x=1795807504; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/RuK77T8Pc2yA26RkCicA7q1V6UBHbE6inBIYLOkP8Y=;
        b=gMoUSUY2pUhyAKBCUrWHLjNAMJGRTrjWG3C12Mw9u0cCNrSwToo+MxPrqhIffr3ss3
         4eXHECWYxXsxrIIe/7pde+g/OCmYR4hD+HiV0pK+u8/ljEfKoTKEEds9Frmq5H8LcV+x
         cJoKC4gVM0fcFLbJqelnazLqyZn69aGOSDU3uFaaNHIF53tdSPX2XxCVV9kRKtSQRcpV
         7zBmhPAzy3KVLW600OqBcc71PUyq+b/SHvoXkOT9rwlRIvoE8HYtQFkUncC6Q1XNuIMO
         m6vZYyTfOi2V1lJmoCDJ06zcUmSpdLkhviSP0DF+Eyc3M9NFPKCHpj65nLLrdGqU14hI
         H60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202704; x=1795807504;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/RuK77T8Pc2yA26RkCicA7q1V6UBHbE6inBIYLOkP8Y=;
        b=exOQjzOAcGmuZutTBfCtw4Vdy5HEJl4bZ8MiqwQs9b8hApyTat2FpXszPkmmqbNVyP
         MYa8N0LOw9JlDy5O3Inx9FiNRPXsYmf7f0w2C9p5PNNsfolTnICcGLycuCCeS+f98nkI
         2hTKv3mpw6g+NKRqs1mP+R405jF1JhYuQcz1BQ9yZg+IFAs6oow5Y/k7PcqGA4FXKtvj
         MI2q4YxnPdpCKF6iODIsbnVEsjqM+0sO8XT/4mmvLmgqR65OhvoOnFW/8BHlxQAViN/X
         dX02Ij5yQJarFRYa/2r43eruXPXMbKVX/avCX30Bu9PA8KRU2Rz2UPDUo6ZyW5zm7Pan
         ZpBA==
X-Forwarded-Encrypted: i=1; AL+hErFQSaRtt2vj2bAzxDpQs3sZO2qv8TsI0yEtO85A5Z8CakLDcYR/Nr6MAT0NF2lVjezZPuAaY7xTew==@kvack.org
X-Gm-Message-State: APuU4Z+9y0vhnopci0RADsuWQqQLE3cihon3N6cefT3+2pIE/SwjLAHN
	OeX5MtZkJ7NnzXBtJ6b0/iRVdGHrRnuuygtRAse/5LSS1AcoLxfJ2sUVJUnzARgIrQ==
X-Gm-Gg: AZFdTZdLIBYEacrR7VQOIx65nQWCznguz6oxXoaB61QVveBGsD6j0uGei2up/hEufVL
	O9kzzbHxrXsBAC53oiIbRgv9WmWG8B4MQyKKV363V/H3iFXJao0DP6Ba1dDXU2Y/FSe1PLe3a2y
	Wiz8TVLL+1wG5fLmRi7oKwCJzRiLevDNkeFZw02yn21D0FqQE3W4IC07FlWGsFVEAcgh+J0zte2
	wqsM3CdT7c6sEA2XSuL6uOWFBsVVIn9VRMEKgbRlXksED9FqT3STCCG85IRSOhHIxQGUaMM9Jk2
	8rImwD/p3ei4TONcY3bH71OfjC8bMTlXziW4q52jvPkn8YM+sasDBJwAZLZTo6faXUGWdFfAHM+
	wg3toWeWj9ZFe1l+RFCBzem7JENByRuRXejuuta2qThqy1nABuMKnO1bOWjUPBvGruvZs2t8UzF
	h2mucagwA3tqobV+xFZ9YFztrDggoWflI/IMkCJKAXETmZ/I06nCO9BRqSsdr/BJOS+JB4Ns5mG
	i+NLCtP12Sg1PibdcHu7KGlyHnBd5WG7v4lrjCcbg6YLQwPBKpcTNT2ujbcC7IBDf45xtRehErk
	Bc51N9t7kVPxnTwtFtXufu/FyQqyZ5B2lkOIj/bRlYQQLMsaN0jBRP8n6XJ8mhrLvA==
X-Received: by 2002:a05:6a00:f8e:b0:89f:d620:232 with SMTP id d2e1a72fcca58-8c87c864543mr3577508b3a.35.1795202703993;
        Fri, 20 Nov 2026 11:25:03 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f83dsm1923249b3a.39.2026.11.20.11.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 11:25:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Nov 2026 11:25:01 -0800
Message-Id: <DN0A8VWPLTYF.3Q0MIEDWLJYN4@google.com>
Subject: Re: [PATCH v11 10/13] PCI: liveupdate: Adopt ARI Forwarding Enable
 on preserved bridges
From: "David Matlack" <dmatlack@google.com>
To: <sashiko-reviews@lists.linux.dev>, "David Matlack"
 <dmatlack@google.com>, <kexec@lists.infradead.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>
Cc: "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Alexander Graf"
 <graf@amazon.com>, "Alex Williamson" <alex@shazbot.org>, "Alex Williamson"
 <alex.williamson@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava"
 <praan@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>
X-Mailer: aerc 0.21.0
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-11-dmatlack@google.com>
 <sashiko-outbox-224145@kernel.org>
In-Reply-To: <sashiko-outbox-224145@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C497DC000A
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: megt6mqa9pdeomncbiybtfjpsyuyimmt
X-HE-Tag: 1795202705-565842
X-HE-Meta: U2FsdGVkX1+sNLZjTPEWKRsJ5ZhZLsKRCe+r2gddnb/hVNS3ctgxd9DY1Cd9vMNPLYPzLLQvYhew5LLAHQaQZwB9AzjFFkkymTJwLXZ9B8WwrZWakQ6x/OjjL3DMGglPHHMMdiOVyHJyIbkrawpivtEX94Kwj2W7TtejE7AI3qjStVfoLhILIT3b+3VdxITwPyBaCB7wYlbSdUZmWBWcNBy73XdvY1e0nd5fzoinetvfjlV3/J8LxqXH4Yr2SDHxhMrkx9069otzGIJ/TfGZY0JguUUU3frO+qspNkYvbnE14stYhS5fvVJV0hf4E36O7ZFVctoqG3Z4A+2I7fwWlI3I/54rvXxOK7oB+6XtpLcibv1w/gq03FSqa4iG9kFJNtvJgr7v3mVE0KK0v0sLLsJ9O6C7vvnxkNwm2sud8BxkKK3k52RevTSvK24R/imxh6EmXQzSv7zmHpP2Hfx1hg5/TRod+w8o1KCgF7wRPGQOfYIJm02Xqz6d7D5DAg7LAgKZcTDzYTfexY/i57VcRqc1VUnq3MJci2cxfuNtXQVe7/2yPC/JnfB1VAdeYeQpaeIWPFKZhzk46KXItgOegPVeKdLxjyCRge60ypDxtUnEtbSGwPyCnXNbz6lLg8bk1nETQxHZZNNi3IZdSdJsjJlqks4rW1Ynvq2nz1/B2uH+VUOVjACaG0MAHoEE2Grlvlegdz39tZPzk+X6v47AqGmpqpeo3+8FjrwVFlc0AyCL6aPAqVYtp/5eRIV0IrBIupqvcF11rjcEbjnq0Uqz7LIwO6XM/g8WMnIvdjtZQAPkrQs9nuwZ7GFFsO6Fvx8WnDmd4Ljrz1cAxvFbbYgdP0ryCOMEviuKVRZ+Txgj/96L2FP2sgJkQ365I7mH5RgxGwWE6N15cCrUBUc/Bb4kSx7IDlZ2ch1dAlYPqPLj7M5PmmDz/KJP87wxrVUGnLSahimMZ+dqySVuzSO42TI
 Lbi6Oq/e
 knmzZuGCO3Qfx10nM2+9VKFynzsyADlnwmmVjWkTKxYE393MOTxL1IWgq+CrJXCB/w2dY9GQVz3p8SbcE0YCzDheVBFW865C/xE6J0JWhZfYeup2pWzDY5QkplSq0gtAK3I6AxtsrWNVxEdH4yK8IyGAreoB0qd5hnXrtueSa3iIrXyB0AXjHHKoEgBdBx3JIcwFGAb+Om+FjeJOzK3EcUr/YukRNu3SFUQ1S+CmqLlAEaSnu8FZOmj30ahNV+8R+llba0xgNZuqmyJvdj8vGCttdtKaav/vIZLyzZXqFELjdQAXfCUTsIDr7JuG/rcsKSDxBQuJKD7pE0aiBSviUGJtGt1VizAqcmoq2cUC7l1blIajBZGNTBcB7Ue4HwJ7YLqidgGvABn57B8Z/KLe+D+as2pZfLULdndDekbUqnjVFho6N1F00UeTFZG6pfpLOlJDFqhZ/qvwMT1ZyOGwT8IcoGlrLC7QC6rwTswOVvRwYkZxkkFVrJySPQxpTS2c8wlckrG436G27UvL3DTzkGi/V7djDLR7E1MqTQByQDpmnNZTF7jbqNhvJ613IonCtQ8ILJ55rbQNv3Wq4muG8kMsFdosYrADBaF5hw5L/MEXRkvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Nov 19, 2026 at 2:38 PM PST, sashiko-bot wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] PCI: liveupdate: stale ARI state in pci_configure_ari() with
>   pci=3Dnoari
> --
>
> commit ee2b5e1cebde3231a1c9acaaf68c272dbf3c6e8e
> Author: David Matlack <dmatlack@google.com>
>
> PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
>
> This commit adopts the ARI Forwarding Enable bit from hardware on
> incoming-preserved bridges during a Live Update, even when pci=3Dnoari is
> passed on the kernel command line.
>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index ebc565b4780a1..b5b578355a1b6 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3748,7 +3748,7 @@ void pci_configure_ari(struct pci_dev *dev)
>>  	u32 cap;
>>  	struct pci_dev *bridge;
>> =20
>> -	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
>> +	if (!pci_is_pcie(dev) || dev->devfn)
>>  		return;
>> =20
>>  	bridge =3D dev->bus->self;
>> @@ -3759,6 +3759,12 @@ void pci_configure_ari(struct pci_dev *dev)
>>  	if (!(cap & PCI_EXP_DEVCAP2_ARI))
>>  		return;
>> =20
>> +	if (!pci_liveupdate_adopt_ari(bridge))
>> +		return;
>> +
>> +	if (pcie_ari_disabled)
>> +		return;
>> +
>>  	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
>>  		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
>>  					 PCI_EXP_DEVCTL2_ARI);
>
> [Severity: Medium]
> Does returning early on pcie_ari_disabled leave PCI_EXP_DEVCTL2_ARI and
> bridge->ari_enabled set to 1 if a new device is hot-plugged after the
> preserved devices below the bridge have finished Live Update?
>
> When booting with pci=3Dnoari, pci_liveupdate_adopt_ari() sets
> bridge->ari_enabled =3D 1 while bridge->liveupdate.incoming is set.  Once
> the preserved devices finish Live Update and bridge->liveupdate.incoming
> is cleared, hot-plugging or rescanning a non-ARI multi-function device
> below the bridge causes pci_liveupdate_adopt_ari() to return -EINVAL and
> pci_configure_ari() to return at pcie_ari_disabled without reaching the
> else branch that clears PCI_EXP_DEVCTL2_ARI and bridge->ari_enabled.
> Because bridge->ari_enabled stays 1, next_fn() calls next_ari_fn(), which
> returns -ENODEV and skips enumerating functions 1..7 on the new device.
>
> Checking !pcie_ari_disabled alongside pci_find_ext_capability(dev,
> PCI_EXT_CAP_ID_ARI) instead of returning early would allow the else branc=
h
> to clear PCI_EXP_DEVCTL2_ARI and bridge->ari_enabled.

Yes, but only in a very narrow case: the next kernel is booted with
pci=3Dnoari, the previous kernel enabled ARI Forwarding on a bridge above
a preserved device, the preserved devices below that bridge finish, and
then a _different_ multi-function device without ARI is hot-plugged below
the same bridge. The only impact is that functions 1-7 of the
hot-plugged device are not enumerated. There is no corruption or crash.

I don't think this is worth changing more PCI core code in
pci_configure_ari() for in this series. It can be addressed in a future
patch if someone really wants to do that.

The comment in pci_liveupdate_adopt_ari() can be improved though, since
it claims ARI Forwarding Enable is always recomputed after the preserved
devices finish. I will update it in v12 to document the pci=3Dnoari
behavior:

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 493576119a76..7582b87df3ad 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -937,9 +937,14 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)
=20
 	/*
 	 * Unlike ACS, only adopt ARI while the bridge is incoming-preserved.
-	 * Once all devices below the bridge have finished, recomputing ARI
-	 * Forwarding Enable yields the same result for the same device, and
-	 * must be allowed to change if a different device is hot-plugged.
+	 * Once all devices below the bridge have finished, pci_configure_ari()
+	 * configures ARI Forwarding Enable as usual the next time a device is
+	 * added below the bridge, e.g. if a different device is hot-plugged.
+	 *
+	 * The exception is pci=3Dnoari, where pci_configure_ari() does not touch
+	 * the bridge, so the adopted ARI Forwarding Enable persists after the
+	 * preserved devices finish, even if a device without ARI is later
+	 * hot-plugged below the bridge.
 	 */
 	if (!dev->liveupdate.incoming)
 		return -EINVAL;

