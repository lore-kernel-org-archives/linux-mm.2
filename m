Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D1FCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0AF6B0096; Mon, 28 Sep 2026 13:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961596B0098; Mon, 28 Sep 2026 13:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FAC6B0099; Mon, 28 Sep 2026 13:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 650846B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:19:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00EA91602AB
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:11 +0000 (UTC)
X-FDA: 85263831744.13.10EADD0
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 35AAF10000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vjlecmoE;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790615950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGfj2Y/eKe1ZG7o5pFOTvuJbhKG8WlfCFzo9fqTzU3o=;
	b=uoJWsz2EMqSAdO/zI640Ajqh6G4RAFujBsY7ad1TTfod1dVJdlvW6RUDA7sDw5kv1FUy6p
	XaDGbxsu1qRaYbBTaBeBTBU+5WeGiHJAwaqBgjnwneCU+LAaUtoNTN3vl/aPy5wJ7D1q3t
	BPUAqVeZh1PwbHv8HaAmFbm/JEGAbEc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vjlecmoE;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790615950;
	b=mZpMXcdigOOpyVEqgRSAqsMwlJBfS6qQhZpUjZFN9n//kg6qdBWW6J/OiVAz7PNCqJvtlv
	I2JtHtfDOLa/FZw+c1OPLjuw2SPMXXTLuKHTACdx2IBIAnnjBB1O+XA8QsKGYmCC/W6NRt
	G8mcJsrNe/dLZ2+e+0IIT2VQ4HPeo/Q=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so3215ad.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790615949; x=1791220749; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qGfj2Y/eKe1ZG7o5pFOTvuJbhKG8WlfCFzo9fqTzU3o=;
        b=vjlecmoEy2iUi1nknmZwN5haskXQRBeSH3uxcfYVdvMzb5uDwBM/WGCdKHmHHAr8ge
         1rZP+0uYgLjCEh6PcatI4xoIQI44dFV8ue5xSW4UDmR8JdFfqkzdYQIi4Tz89urtYgS9
         XgLp15BmQFdPreQDcRsYTPXtf9BiKTT0B4kYOkuz2cUlQrkuxk7EZxrHh8BSTXp3Jv+d
         EwdheYksSYvajNoLmtCe523v+u3krnOdjsXT4z3m2E0/UvPcEmarDrzKtlUOwUtu6e8I
         i0NFkkfsY0yzbc9XqBwu1tTJV6YCCMLvQLuWCXP0tEucKPInFXLT4S6Vk35/pyyZlD16
         F4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615949; x=1791220749;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qGfj2Y/eKe1ZG7o5pFOTvuJbhKG8WlfCFzo9fqTzU3o=;
        b=jG0r5iik2GvL2t6Hocsih4pH8VSjXCoB8gic2lT9aHsugyS8WoDjPmb3EGBTKyWi8p
         yZoGXrzQWZc04oIsZ//k1y3p+5wdJ6Ahmc6xrxCVlU317bIvHYTliFJJONoJfIBODrER
         EZuYEUuymuwBjD+DVocAlxiJ4gG8vYCt3ll9mAPrCjobqmfhRylsVpgv+T045uGfj5W/
         V+D0lpelHW89DI8HEbW1pj9hgs4KNcRyRxq70YHnL4XOocmb6M+XsDMtO8C83spsJzY8
         NboVAJYXAjh3OwRk3XqAp7gkihptlMJpr93WXddVY/Zw+tiAV/SVWM3o8zVV/bqr3xtO
         1AQA==
X-Forwarded-Encrypted: i=1; AKwUvBxmZSo1zr4qoJcS4/aUEk1tbIX8G06NUkCE8N5F7IkF3yQ8pS91iCCmCC/xI9VqdAkxpGQcyO01Bg==@kvack.org
X-Gm-Message-State: AFq9FYI9wKwKXbgnXmbGhViuT54QWqeAd163fdZmeuYM4n9zg1XDH032
	aBsMrqzTtjRfmCptyI/aeyxkgrvcDdYMJsUgL4PrmwzPBU4P8ty44m+Zg3vaFUWtkg==
X-Gm-Gg: AYBFou1/IbqjrWFBVbl2fclej0gp5SMfhbrFV2rkhzSa/WB3znSjW2hvdv9KkT9YwYP
	JR9nEov6DIdgd4AkEYqj8vAdQsUEiALu8vZJBHNNghF1fybLb9pp5vwQgpVSENuj21SRJassUoG
	zJt+vobYVzhyw8Hb5pu6OlaoxwOefuKT4jqKSMmJXq//tsBOMdqHVaMeVRkg+sIgTkGx7laApsZ
	V0ncZ6cWhQVT3SC+1jOD571hzNxdqbSap0JPeILfdZ1p07VivjfkTrYp6B7mnVqSlMcnSxXn0HV
	Nq5pIXothbJ0Mbl0I0hqoQpmEe3coW5pDaWQMEFqZTtzDPOWCrwxSGWfKdGRAyKC8Unk0gPOcZr
	r8fBbaQK0S9jG4Cx0eVE0B3+Guuq41ahYSU87ueZbavGPFqQu8V/EINCxH/2hYC2MwPZFyQoxWi
	VCu+DZdAkH8VWDp6m5V+fiPa9lHX32Wv+a676qlvrxZXCxDvqfcpixRqwNmMEr8RrSxGb/yWzHM
	noF6CGPWBWBCmVVHnon6QvdyhjHUD4v4aK+
X-Received: by 2002:a17:902:f70b:b0:2df:8e89:3bff with SMTP id d9443c01a7336-2dfa9795c44mr8307715ad.17.1790615948122;
        Mon, 28 Sep 2026 10:19:08 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7a4b03082sm2784007a12.11.2026.09.28.10.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:19:07 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:18:58 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 08/13] PCI: Save and restore the ACS Control register
Message-ID: <arqhghssNc4fIu_9@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200640.887030-9-dmatlack@google.com>
X-Stat-Signature: eeamah595pemnuapy3a7ifnm3xiycnxs
X-Rspamd-Queue-Id: 35AAF10000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790615950-32224
X-HE-Meta: U2FsdGVkX1+9rVRFQa5iQO+GmR6B8WCFin9tvIxuxGqPcwhDsD3EOIDF5pdwzdj2dUQIpJTnBRqcJsEs0g7r951dtxIC4Y7oQV/ohGRELI3QTLwdRwpzyyUltrF8M7WIcCIk8sGqZXTHAmsS4i1KEI2riaIN/zimpM84+ssYRO3NuqUOIlEvfWg6d1xozy3ycd0y4bM1fxpnFWx+XkmwH1xyEpUbrxcro0DpefsdkTHSRnvQPeAMSaZp490IQsnXEBpyCcbWTz5lduV0gP0wgOEh9vAoXR9XOKIwbHIyWTWB62eDmLfhv5XD8qAM5U/RN/lkFZ6mMY1Kt+uGeOtcNuB3jXWlQ5Q4IL1c2aMj2SEWpIllGfuotPEppFfoFkCTjyHsOTjd6j8EZAOPCYAdskMRWo0+LODBaGLJ3YNKFOnhgrRRtbfZwJjb7NHbhAFLEFvp79+bSIOQLmO/2Jxgha9PgZBBjxoa7GTNl8otAKPI08ZtL3dHVYmopSQG+T58XDuWBATTZjWKbpIN0BI6Rd8v69TsY5Ctxuf8cLtUfJKJAQp81G7/5sz2vr2uCj1Sgr07LvKQek2bCWhn/BqtxmXSYyfFgmhR/asbixckK5edRVBWWDKUmaESuB08eCFpf1OO/BMtWLLMQ6gjpguVqYk9YA1sgjvkc5z7O5qJhAgiBIAkXnUGmecZXz0/TtaQKR4zFDGvObtKmYfaJMNg0W3/pbzzuZ7UtF7O2iirKBn4dj/6t9+WsO76qXyZKWw6V6aLJHklS++9TFqf4U9dsItattmA8IKUH5etDQA+KGD0ta2vslE9lYelbvpUqzFsfE3JRA1hPTEhdgNE8InOaGaIsTwmXSGPDWaFZAcYqL9+2reekflU4MMy/P8gpS1h/rd56PD+zax51SC8cZjbg7bi1v+SzDCTFU/ZXgzMNk6wCD3NTtQ1eSyhDAiRnM4GBJNGJe2GHknGBygboWN
 mkjZHH4y
 eB0UuoLObgldrP2Bno9gnz04Zp804LiwIN0pzwJZ3SiuvpERSdIpDdjrDp+2JmjmARMcQ6WvHleGnLhTefQ6d14G+Tzt29NP7k4cv/iPeHNflPtaxjNSHKPo6Gc6YXh8dRCfmeKh080z64jYIXO+RrAjAlsiZfl866Vd//WZaA44oCjVQj4CZRv/kOKjrR2dCTghYYFZTbroMSFwKb6UrLXCjJoWSY4GzssVd6ulsK64OFqmDQ00T80M0/yOudl73s3FGuNRpSFyJkXJbiZSEax1yRqhvTB85FiO7p0lprQ5XwduHd4EgCSMNe9nidEIBXMuzbV56iPnv7TweYQUsw0MS8+XTl9vaoUNc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 08:06:34PM +0000, David Matlack wrote:
> Save the ACS Control register in pci_save_state() and write it back
> in pci_restore_state(), instead of recomputing the ACS controls from
> scratch with pci_enable_acs().
> 
> This makes ACS symmetric with the rest of a device's saved state. Today
> pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> the ACS controls from the kernel's current ACS policy. As a result, a
> device can come out of a reset with different ACS controls than it went
> in with, e.g. any controls programmed outside of pci_enable_acs() are
> silently dropped.
> 
> pci_enable_acs() runs when a driver binds to a device
> (pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
> the device's state. Refresh the saved ACS Control register there as
> well, otherwise a subsequent reset would revert ACS back to the
> configuration left behind by firmware.
> 
> Devices that rely on device-specific quirks to enable an ACS equivalent
> keep that configuration outside of the ACS Control register, so keep
> configuring ACS from scratch for them. Do the same for devices that have
> no saved ACS state at all.
> 
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan


