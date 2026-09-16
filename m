Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4192C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60B96B0093; Wed, 16 Sep 2026 11:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12D16B0095; Wed, 16 Sep 2026 11:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B746B009B; Wed, 16 Sep 2026 11:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F50D6B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:19:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FFB5160725
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:19:40 +0000 (UTC)
X-FDA: 85219984920.08.33F0A91
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC4B5A000F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:19:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AkQkiY3r;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789571978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpNPb1TxYXca1d4OZUk8cPR+2lzT1yr8aN9KjQ5b67k=;
	b=3JrYg+BtAMe4XoPPn69cCDFeqTHXU1Z7uyr2iUpA8HpdvRfBVxo9VjzTtGM3Ti8zQ6tw6U
	APmmfU326aqWmYcx3eMyFmLspqoQ7cxz0MZQS0da2zCRh7d2UOd0nxGN0zxL9FdSQZZsAH
	6r6Xc3imeDgsCK+OiYZEFhaTznx2QZ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789571978;
	b=ulYyeHaxBQVk0BoOCW7Pr/Fd4vuiUgQTeCkqi6gcXXWoZtqirya/E2LeHq4Ba8PnpSdTG+
	qBEnze0kf8PjnPSBHmCblrP6uRbFIpf7CHvczyWrSXSWs2mtgm3tyJCyHQjXa0MFUiT1AC
	mnx3b3BP4cgs15+8BFnpYRGd9HPHuQ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AkQkiY3r;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530e28a62abso13094431cf.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789571978; x=1790176778; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VpNPb1TxYXca1d4OZUk8cPR+2lzT1yr8aN9KjQ5b67k=;
        b=AkQkiY3rpTeCZOfHELppmdgne9veALwT7V/r/UMitdEZADERC4M/Wyw6F5BeS1YH3A
         Tmy5Jpb1BgSdKvwEiiVPsZQkLOjyMIPLM9TlDCUL2emxQucppbKyHvVBZb7TGH5BtmJ9
         emd6+/kfZVC94ZLWaH3vxEHceXcSGPx2QmYyEjQENAzX+NMM+6sCiwfVJnKGbsHX60EJ
         RlqbofC6IRQiVfBrK02XYk+So5DglG5xHY7bOEpUUtKooGnVoiiQ8N3Zj+QL0GtUDGPL
         kthPm48A1DkVp7hrr8LZZ/IWiPq4rqYLSdPUhZdnNbWyGCpOZkQZgLKltedEeDIAVlFL
         C4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789571978; x=1790176778;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VpNPb1TxYXca1d4OZUk8cPR+2lzT1yr8aN9KjQ5b67k=;
        b=QC5sVfZ+JVmQ/8glJP0FmvQHqPaj1CkAqjNpZ7wvgQpn5rPEhnZb9fg1ZguQJJ+RFi
         IfmREUr0E1MsaoOypsB4iApOi8obUelMSb1BprXl9yXGxMOP2OrnLBWWqbgy8oRgPZ8Q
         FtaN7lOU5PTr9gKl0i5wRt4Pv7npY2rkKCNKeOLHXJplXu14kIxawthjaz8Z6nPGuPpG
         dQtaiXWgj629nA/b5DQX0N1LJ2Yr0UFhWTmz6QkfBa4c6ODOMyCIeObl+PgRtDhAN0Lk
         Poa2cJ/jyfbry7wwXdl3DunzPWTk9bTU/fcT40yJJ0vM3bQveNVqfXgQd6VF1xWGDVPL
         Oq/A==
X-Forwarded-Encrypted: i=1; AKwUvBz/FwuS/+cthAClYOsOXq0fQXefdKSkbxdK+V4EUtwnnccJId3hEtT3w2izH2mQ4Ug9uZ6VWj3dcg==@kvack.org
X-Gm-Message-State: AFuF++lzSyrgkzSOK0gVjlho337KCgZOSw1dobtABe3ylHSh5lLILdHT
	fPEWXH9Ler+YL4KoDGS9DJo2YTQS+hnCoPygj+LX+6HBXbLZatf81UqUGNp4AE0ow6g=
X-Gm-Gg: AYBFou3fp0Eg3jMIL1jz2ozqXqJUYItUTBSqvqNUSZwACeygvr8zODmkKHqc1AvUvDK
	N9RcDpwyQVNAvShhs4oSUva3TlbgIc59Tg/HmBO+SpxLnsdxMpel/YYeJq5KftlwUl6/beMaLqe
	vyLYHVIt5dVRzUpi9RowqQVGqdCRlBGlCU+AaqmzWMKt0Vs3YZGIb1DwaUBBgjRrqpxKjYFslWz
	wT3su4mqbW8dbs2u31C4aekxZqkCfBr7ibaUyXa5V/W8hrRtjwO+z5pb9P2R4pdChcvVLYHl8if
	QIONjfJVnbduF9GfntDTp+ohQzK3knAbpagEGuLaUdB8nXCic/AtAMzAsgR1A77s+14FEEZU6cN
	wV5GW9xPJ0hdvX6E8MWKm7Q+CeY9KW1NSMNfCiJ+8cJ/jY9h44NPqVO6U/Cs5TXngmO0K0GZh8w
	M5sbq2ZdzDPMHGPxxq+pKV6WhKx3ce9VGVjgnLinBU616UcdtIoW8gmZ9TOnCFF0XkTUBlNOvyl
	FEyBbattQhN7QeHIs++TaCfwZlx7DaPR3lwHaYqjVIMszfdwyyyRTo=
X-Received: by 2002:ac8:5f0e:0:b0:531:2154:becc with SMTP id d75a77b69052e-5327eead6e2mr49713181cf.22.1789571977900;
        Wed, 16 Sep 2026 08:19:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53262024a94sm24051881cf.15.2026.09.16.08.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:19:37 -0700 (PDT)
Date: Wed, 16 Sep 2026 11:19:35 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, wangjiexun@tinylab.org, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin>
 <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin>
 <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
 <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
 <aqquDtEZL1ndymGN@gourry-fedora-PF4VCD3F>
 <46d923e6-5724-4df6-b0d5-8dda7c547f6e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46d923e6-5724-4df6-b0d5-8dda7c547f6e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC4B5A000F
X-Stat-Signature: o5chx1frq3ab7bhcjfywqf5ta67ekgj7
X-HE-Tag: 1789571978-245862
X-HE-Meta: U2FsdGVkX1+mSlWax+CskNoogJuBo0JfA+4M3vJhjhnlvIH/dzJDRBRfBmlG6O4k2hZmbaZ0kaeKbN+stPLxvBsUnyoeRyfmTaCvCxdx1T5j+0ScacQ6aYi8UY7FwzMuzBP9tBz9phiciCiDlJ+X1fEwAnb4Ju/NJVfDffefyjL/LBSDXJ3O2snF8NEYLsEE3dVHVg6fgT/LgkHI2Cit3sIS+0bMkHo3Wh7v/EC9Geg9H5LS+tyCFhp2VXzh3tvGRSb04+SdbgbZQlgmYr+7VbKm41hGapvY1aviIFvT72H1pyB0GyKTROPOtF/byZVeBknKmojmRViHcgklFf9mwZX63qAwLR8Fyu8O/7rxXF+Swcjp4/uABSDNFjup7x1mJhkmfK3f+Fb73r9OOYmgZoTWogiJpKXC1cGAWFHEPKIoJikTcXf6VdlGvwV0juKXuK4IA2LzfgkB25EIuA0/UQrjqnCaCKx6gm3nLkfh//OejlVwqX6auFCFhmNw0UTTrsv0qXyJjad3dzTaOYs/qzpmeR459PBfWNdZJcWLqUGp+6G5yoXVtfo0R77Ao0YJbFHl2k/d0FQE8Js9/DmlEW9uY7Hd2KBndcUP5hXAXnSEvpaidtEMBOljHSaHeuCirctPcm87XI0LonlMHDdZfLpgmR9tOJcgSKNuKRFMUN0yNgxQH0kVnw90Ehq77AK+4Gj2TGTdS7Lgln16L8rXLv6CgQjdeC4Gz56nawi9RsAiWEBLzajsy7gQ3syXZZGnVqqa0UWCcRaLlMv6mdysGUDE7ECoyLLAmIAfvpUbZ/pkA1hdmxEhCZGwwSZENUio+91hJgubZPaOwOZBsxONJy1eoyMEP3uoQqIvk8CfsetPbPY1nhpubFUOKwyh2TDUbpWq75tXujoO0c/Rb42VJUSGjtSme80zudC9bpTdQOdmbDbyaVkUrkBahF0WU1stf1e2VpRcFswO6krQ1ah
 T8cPXpPJ
 MZGDHSmVnxfVzCrIdixU7l7BSCmFOcsNiJ/br+Q0y9mBPO1hN9Ws0xCM42GXhDIyw3fKUbC5YDz/cbrdMH/ProIJF0+6KTJd/bb/KqLI8L2WonontGvo+0l1srDMTkMVCbHoBDL16FCMnRfsMjeX/5GsgEqgnyympRniGIhXXsLeO0ZT19ywMGNO8N/rK3TEE90p/r74BB6I8ltlNSsFeXEP19bcRtxrER/PsT/unxbnfJ2BeYz4LHdHLVcFkukGcjDjSivF8/uKUhs7UrpbQQn8JXS2VYO4C8ITxXyri+wEGPYnvmaA74rTwxtZ4ZCmKsn5PtVBDYy9SlHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 04:59:32PM +0200, David Hildenbrand (Arm) wrote:
> >>
> >> I told Brendan exactly that (try stubbing it) and he tried ... and had to give
> >> up at some point because it just wasn't feasible. ;)
> >>
> > 
> > LLM go brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
> 
> No schlop like that please, I don't want to hate my life
> 

You missed this part:

"I'm trying to be careful about not causing a bigger maintenance burden"

I wouldn't do that to you :]

~Gregory

