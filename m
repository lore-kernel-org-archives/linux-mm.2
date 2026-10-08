Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5EB7CA6009
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 00:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883696B008A; Wed,  7 Oct 2026 20:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D0A6B008C; Wed,  7 Oct 2026 20:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ADDB6B0092; Wed,  7 Oct 2026 20:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33F1C6B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 20:56:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8232160415
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 00:56:16 +0000 (UTC)
X-FDA: 85297642752.06.9732491
Received: from mout.web.de (mout.web.de [212.227.17.11])
	by imf11.hostedemail.com (Postfix) with ESMTP id 66A7740005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 00:56:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=Mjhn7lmV;
	spf=pass (imf11.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791420974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDXWSDVs/cv4S3vPDg3z0lB70O6UqXQmhZsGeabZsw4=;
	b=QDR1ubKPo7+x7xJU8Rh0ywuVuTEgveOKG9gNxos0f2zAgxB0Rf9Xpb9+AxIDLAnyIfZlSk
	/giomSITiU5ZNhDLXlqeWWCDYTFQpO+2p0ygshz8tsIXvSfEelomyNXrL6rapDuvE2D5sh
	s7Zx/5fSOVnX5U137ab++XHQuEvlKy8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=Mjhn7lmV;
	spf=pass (imf11.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791420974;
	b=q+DqR/vILtZJ0IgK9fIXdzR/noC9YL+kKsmvAnO7bqzNS9J8bDfBkX/DUCByj+bB0535KL
	lCZIBuNtADTSl/poh2W5jfDcdo6s86eOGkXPEdyOdAbSsB+5u35pt6m8PtsAW4xhoZe++h
	orzb/Dnff25c8yhoHjHxMqdWfwZTUMY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1791420930; x=1792025730; i=spasswolf@web.de;
	bh=SDXWSDVs/cv4S3vPDg3z0lB70O6UqXQmhZsGeabZsw4=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Mjhn7lmVD+yZGfZyZIhIC3HkWvt6KYxjOVvNkfXT34oXRKPKqX4uRfMBZRsk7JZV
	 eyst6fB7mcQdXfdLaYIEU6WG0pNnxhi61ExhDScQwM1s7eNnG5ZUZUM7bnLnCU+LC
	 Lx9H4x3Nf/oTg/BoDbRKkwEdkz8mosPZ+w+wy54BczenfDwjcBQ3eXXAasB/2UOEb
	 vre6RC/kVMmK/k5Wpe7iaD6RjJZC1yPkO+64hiZU6kBcfHnZ5gzxOMh+eEMpalWlM
	 k60OBbk3tvR4AARxtNX0kKZM6B4BrhHZL9sqnH8NYTC+bU3BZWeNfjsz18So7wYJb
	 Rn/sg3BAnbOpDwAtXw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mhnw2-1wjhWE1Kka-00eC6N; Thu, 08
 Oct 2026 02:55:30 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: akpm@linux-foundation.org
Cc: Bert Karwatzki <spasswolf@web.de>,
	jannh@google.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	okerixx@gmail.com,
	pfalcato@suse.de,
	vbabka@kernel.org
Subject: Re: [PATCH v2] mm/vma: keep the unlinked VMA off the file across unmap on mmap hook failure
Date: Thu,  8 Oct 2026 02:55:23 +0200
Message-ID: <20261008005526.6927-1-spasswolf@web.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007145329.dd944233d7986bc0f5b2d63c@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/rBa9frzNAE2fAdo3AEhTRGa+im7/Sc210Q/AGjm6e2OnxrOFqU
 jOCu7tLt7S16rhkaV2tcIHEEgmsmJiuD4vnPVfcIvaYSfw1Fc7tvFahSXtcMbjouBw5vDAk
 fWShtcBl2PpcFXe9IJ5SOAzqATJnjTCjUBFjAO9hEK4PoEEeu+7ehnKLUGfN0+lANfb1BvW
 H+YA3ebbgfYy9bMQOm2Mg==
UI-OutboundReport: notjunk:1;M01:P0:N7ipb4OLF5M=;01l4Et6qbLA++qgz41usQM7iIfV
 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
 bxzyIu7O0Jz6+C0ormOCUvnhTj/EW0N7Cetypg=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66A7740005
X-Stat-Signature: p5hpnunfeopab5zqnja7qjbfq74c3yat
X-HE-Tag: 1791420974-398788
X-HE-Meta: U2FsdGVkX18eFEWeKoym++6PNRZDDGt5/VNq5buCpyiky/MzujA5WzED+UaNvpIG/GlcShLEdb1u3GvPV2NEGtcGREu34LMQqVw+oIQG75atRn6qzOLPXvaAnDGgErv3iDto4yzv5z5Zku1gXt1LRFLtgkpClw1wt5MrEaDklwTXJnrH+nt3m7cXUDucc8h17MhjOi4mmIyDIME+HY1o+mg7Tu0LSkhfG+zcxSx7pfgRVChoeM1DMT2GQTWBX5XgOzzLcKL0MeenXqpB8z52D+w2ctsSTMSkghFe0BBxZzJ4GzBS8WjEMOfVok7qbBSgHUrVwA+hf9fyWtNJdJU8YFdfq/tT6wE8Sv0sBHKI9rk4xS1tnfPvRJnmEZOeDQGcc1Eiw4AZPHg6IMAvyIspUyZAqrtZfGKwA/U5gP9P45XtXAFAmKmcxzQ0Pj6OMtwY6tp512pNAzGzXi7gW53TzQNiuCMuQjy6klFTNUcX6InjlDG8Vnh9h0EOuMMOLDCsZFPtJpCRk323IwngmiOKNtLSamYfGSUEM5+OpBvlsVsIbjeMRR7sdsYUvcpWy99UYL7EIkXl2bd6OHNMWjS3VvbLJ6u73VK1AuBz+GHlnLLGZ0Q/aHFumtgtC2Xio9vUeBmedl2IHc2MH2D7CbWAkgL7yBGCgkQTfJDTnbsuaRfNJCS9dvCuTTM5p2548okVhy1ZiigT00H5ttdLYcDoLJ7bF4HZ23YpV7F2FDzcb5MWraqPWXrO2i36C3SxtGwZSaCMfZ2apgMxsVWNlv8ngDA39+Xiw3zDiUdbWo78ybyP3MiJX5MFUeEb/Pxn376Zik3uSHtf5n0FIaGFUDqSoJER5prra/2CU+9o+Ozy+3j22XyrPmMKAFN+uktl8Gkl/2dG2GErZytz7joEzg3NAO+cMhsRI4Z0tp94BemkVal7CNIa1JsL9jiUUvTPr1NAyJ2hc4U/9zcj9Pbl10b
 eP+KoAmC
 tjcnp98bQf/7CZDiFLHivwSwIn2QaxmVhOO4cyaFuHunGSnF7z6ryGRtABVvPCbD/L/8BrXtEFva4GiGHhUEuWhkyh4QGkDGO6OiIFKpNLZDEe+h5kiwucKYsLBGNi0P0G8+OgTvjCfNn7ERtth1h1FEh4Ep56fR9SbMShefZFg+JZtYpHFwo3JNv4KI4+1tBLD/DqUM235zRgCWPprXpzb+GpxJldG0lY517OZSxlmccdlXeD9HL3D4LBhl6S82IFyCacv+N6cK9r8FB2uE2PaEHBT/meIb8Y4ZfTD1oR3Wl+vsshVIAwkdAPSCtkj1FkqhEcvZvncFsp4pa7eyLB8OgyHlPdoOED5rO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I can confirm that this patch fixes the sound problems I had
in next-2026100{6,7} which bisected to commit

40deada069fb ("mm: consistently validate VMA state after mmap[_prepare] ho=
oks")

Tested-By: Bert Karwatzki <spasswolf@web.de>

Bert Karwatzki
   =20

