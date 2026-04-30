Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C8ECCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3523E6B00A3; Thu, 30 Apr 2026 16:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329816B00B1; Thu, 30 Apr 2026 16:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F136B00D4; Thu, 30 Apr 2026 16:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 140ED6B00A3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:45:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9557401AD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:45:06 +0000 (UTC)
X-FDA: 84716401812.20.2E2972A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id DEF084000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:45:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RFk8g72o;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777581904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvD+uC7yGlafUSeu2Mn7DdblXz0CDLD8RU3/xZfrtps=;
	b=mJulevZn10rv4khwjWyJMYnXt1QVY5rcsdIfm/UPyNtJa1PrF8yXMvI7nwQ1VFnmVm9xeD
	DpzQj6SdH4938gcUIcQbDf9O/DjyofoxOiYYbvCEcDmoorKV5UgJvRaLJYgicA4ZCp4jZ2
	hSrbvROgX9FK8+GfGXxXHMZ4nreRQzY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RFk8g72o;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777581905; a=rsa-sha256;
	cv=none;
	b=eeGxN/3QBELujD7x5FrGa4LQ9nnM5brybt/vWywZULhpiE8b+frzEmyxQKpIt9472C/t9Y
	y0u3/Q0IBcDTbUAcaKueAtwlUl+eCHk8ohw0TFUMzbX6zUTD3xeTd/HGzNZ/kVw/jbRIx/
	JDOij464408nIbv9EAVIeBzu7dv37Wc=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b2d3a9e149so11190665ad.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777581904; x=1778186704; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JvD+uC7yGlafUSeu2Mn7DdblXz0CDLD8RU3/xZfrtps=;
        b=RFk8g72ocykS0KdNTXBwzONUxQ1QOhClxpk3G2XIQO888zyQndySI9lNDb4t2G3nAY
         8gFWCsIyaMWta809FlGDFqU0Zds+5PMnfa1LESybgZViSUWaEqtIZ/Fpuzx0lIsK3NHR
         1MXZHXzmRChmvX/UU9e2QVRdsNO6VH1E+yR0Ofl726eM0zxVUJnh3L79yuUDwyCn0aFA
         FwZZFDsRRo4R0oQ6PwLVOUsDs7hO3J/wiMCbSJmq4a2abXoSW/C6aBAFr8s3Y+Y0eAxe
         7hqlVVgPPOBGiPDNTLpAGwk72vtPXr9l/qrXixCFKjOveuPwgOoPtnvkknvD4bGg7v25
         UdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777581904; x=1778186704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JvD+uC7yGlafUSeu2Mn7DdblXz0CDLD8RU3/xZfrtps=;
        b=ctzUrfyTtWtWBouNrDCDnTm7oeTAAAJ68f7fqrz8xTgkOlzrUP5tYv2UGMdHapaED3
         /HLmu1RfgbFznUuDEtAwYjjwQDYtEoDGbFGQLuH2m7WSGI9g7VhgxMdtf0mA6qRRrFcy
         GGDMLp6SJf/8xqtEt/kFbP4mUyQKLpjdTpeOv8OI7lMLV07ev6nFC0h/uIY59OSBrizB
         ikiSQsAhxEmj+fbBXEbxR613lPIOMFzx6wy+lahE5NysSVUsGAGOitKndGN06kcOwV1q
         21GmJhAFUbghwFYcGjWY/t7FBMkfoSEGGHlmKK8HXGk5EkVvWLCjrUR2TfDYtsYOt1Ri
         zqRw==
X-Forwarded-Encrypted: i=1; AFNElJ8rENuIRPzlj+VMvG62PTR/ta+jyNc1H0gXXgOI6pGXURuD5nanBc8Gjg9xPO5O9xxSxXD0YXFCWw==@kvack.org
X-Gm-Message-State: AOJu0Yw75hluMPzkN4MktKMLDj04O12hgM4e+R12tbpvqW1XgmKs0kZL
	eWmW9WpLvoXoMC/p3UERfk/+GzdV3Tb3Narsd8BX11tB8lmLRMjyklmDWbng71xDnQ==
X-Gm-Gg: AeBDietriDPh2+B/yNfDqz+4WtnGauAOQtyTLu3neFrPLvDcWE2x0W+V80h7MYrGfa4
	+NNxpvdzkUN5j04MG4cJtjhCdl3jP1720o2/tsubTSDHzXMOtqTxvhP+cwQcbDQZcNtHMMAHgVO
	asdEYEDrKqkcN7QfINJq4ItSpKiBspuwYEMUCBb7kJdsDY8y1JMSwX0C1ry6JcSLIKUU2AA0ks+
	fUk02ug9yG9mXT8MjDa6xXXMiThtaH7PsB14z83jtjE5Ce+ToaTXa7kFri5TamaJpjZftijbn79
	wtDAdh8UrlBgPm7rOjAV7uYoMU0Etfx/OfiEGczDbIAdMeDXpSIhhBC6BZWhrwLHHMYwDKWVm8T
	xCb0Xvx5a3CW3cZS3kcav4wiszF+aa4H6M5mi+shN0u6q0uTAnkEltMIZ3ilW2rtOyNngwasbbC
	BwWSgm9VVgtlxtJ58x8TinPDrNEBKoijEreBJdWnPRJnJ0NpaweZwb4+2TxFMeFOw6wh35/wnf1
	H881Q==
X-Received: by 2002:a17:903:200a:b0:2b2:6cab:3127 with SMTP id d9443c01a7336-2b9a44c5da2mr25533465ad.20.1777581903207;
        Thu, 30 Apr 2026 13:45:03 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae5cc52sm4845105ad.78.2026.04.30.13.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 13:45:02 -0700 (PDT)
Date: Thu, 30 Apr 2026 20:44:58 +0000
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <afO_StuvUj1Rj-5I@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
 <20260428185242.GB3825533.vipinsh@google.com>
 <afFICT9mSL1XG0v_@google.com>
 <20260430182532.GB13902.vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430182532.GB13902.vipinsh@google.com>
X-Stat-Signature: xjgrqpamzun56ehjpadpaei6dfmakoie
X-Rspamd-Queue-Id: DEF084000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777581904-14094
X-HE-Meta: U2FsdGVkX1/HChAqwiArhhi5dMuQrUxW1sR5iJvg/nxilV6KFDpzFRA39wDqyyOKMA4+tZb9JZZLyO4c2LB2RqYH78x+VmUrHXLLjuwT5KRQcOPCX66OhCwFVV06HbdCDi9nPub+v2gd/lLaRihGXl9EKJ1lKQQuECf1fSPDUb1yTE43dQThWVyS5leyzLMHbdEsnG2XVkkh7O+8IF4z7QdVa8zdFnwY2+lxt2ipKTuz19gV9Djhqr4ss2S5mZ2VN3ZF5qN2TCepCYf3Gv8c22udC7m6oPJMiMrh8uUxzYUohIC961w5ntg3fwM2Tb7F0b6J8Os90Uki5BeCL3893+jQsI0FRglcR4J87xMh0/Yp+E3ek54Fn9zEQFF4AXt3zpXnkhN2Utrpfu7dFSYlgs9a6pGEp8xlRzjAosGpBs1GkD6aQIwDVKhRLDC7CXOLEyTp1wZVfdO68HtdpoTqszwRyn8ZXbE974efZ8Kuodl1jr2qCR8Ys/bTdEPsvJW4Ii/URv+d/3PrD63YkIHyCrQUtUbN6QxUmYhQZsNNduAkw732Gz4qZEhk3zwL+4VKUalm9N3BMm1gRBz8Xi4ZNW4qdZLCffepCsFgvrDMsRpK2WeydV7v6bAHpAOjgGrveZTpTMac2vKeW6v93jRTBCsC4LgVRKjSnArSX5Zm45vFdYlr5TZDbadzQGGDkS/4e22Mbd2evv81pOrxek5vsRdbpqV7DqA/Z2D8JLfC9S0w1D+4AWl2dxUDFDU+HL5Z8662v5HEmlNI7npy4vuRTTXa5Fudnfw7BzGYvH6DOYO4l4y0aioxUwtW2+XhcL3nRi+WY/buOvcvO5DRwS1q/NDHlhOEpHRaWTOADZiYrWkPmbC/mdxKoz1u0/6H7tuspPB95bFNEnFZGUetF73/ulxbCjIBkipPgjIua+uizoGVAjfz56aDxMtwRnmkbos9gUV9YwIEtObvNV+FE1w
 uPBYiRhl
 LFH8Bva0at7gTPpi2JWYy1L+hpTz0BO1gwowO0DMsMJrfl6fcLx9rAgVMv96kWTzDPgF6kmjaXYRLDJN+vCk0TLS8P42MTgK6yjc/RB04UBfcgj9gsLImbFST9KTDQXZ1MPG+/aD+Nq4NYHPSDGeMlaR8oD9TtPcKgqIKLta3+0ipSqbd3aG5gINHvLAWCMa2QVfuQiO/tBUHZGla0NHWA8M87votY6LfN6M0KjgeCo1+OGQg0WLVzQZLbHmX0cOMcoQ8dNh+vnS0ZQgLwHR/VV6+FtIE4rssfV4ZfToe6+yI5v5iUCpB3gGmmreQ7x5PcrbVDMEWvt0E0OeCrvLm2xIE6Eej8SHU0mALGLyhx9BZsIh2FqLBLMT9fzsccuRY+iR+OIypHk4FaSFm7Yj9IAbtp3WTazVpHh58zVlNxhXRe+NQydle/rQJco/QXSpR6HAw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-30 11:48 AM, Vipin Sharma wrote:
> On Tue, Apr 28, 2026 at 11:51:37PM +0000, David Matlack wrote:
> > On 2026-04-28 12:45 PM, Vipin Sharma wrote:
> > > On Thu, Apr 23, 2026 at 09:23:05PM +0000, David Matlack wrote:
> > > > +	pr_debug("Preserving struct pci_ser with room for %u devices\n",
> > > > +		 max_nr_devices);
> > > > +
> > > > +	ser = kho_alloc_preserve(size);
> > > > +	if (IS_ERR(ser))
> > > > +		return PTR_ERR(ser);
> > > 
> > > Should there be a similar pr_debug() in case of failure to denote that above
> > > "Preserving ..." message didn't finish, or, maybe just print one
> > > pr_debug() after the error check above?
> > 
> > Hm... I guess there could always be more pr_debug()s but I don't want to
> > instrument every error path. I could move it to the success path but I
> > don't see how that makes it any better.
> > 
> 
> In current way, it is printing that it is preserving pci_ser, but there
> is no indication did it succeed or not in logs. If we are printing the
> logs then may be complete picture will be to know what is the action and its
> result.
> 
> I think moving to success path or printing again based on the failure
> provides assurance of what happened. If this gets printed in happy
> path, then we will know it succeeded in preserving that struct on
> kho.  Absence means it didn't. 
> 
> We can also remove pr_debug(), if this is of no value.

I think I'll just drop these. BPF can be used to trace this function and
what it returns when debugging issues.

> 
> > > 
> > > > +/**
> > > > + * struct pci_dev_ser - Serialized state about a single PCI device.
> > > > + *
> > > > + * @domain: The device's PCI domain number (segment).
> > > > + * @bdf: The device's PCI bus, device, and function number.
> > > > + * @reserved: Reserved (to naturally align struct pci_dev_ser).
> > > > + */
> > > > +struct pci_dev_ser {
> > > > +	u32 domain;
> > > > +	u16 bdf;
> > > > +	u16 reserved;
> > > 
> > > Should this be renamed to 'u8 __padding[2];' instead? This will allow to
> > > just change the array length based on the need (0, 1, 2, 3).
> > 
> > Sorry I'm not following what you mean here. What is the reason to rename
> > this field and change it to an array?
> > 
> 
> Having a padding explicitly tells there is a requirement of being
> aligned. Reserved sounds more like don't use this u16.

It's documented above, but agree padding is a better name.

> If someone add more field down the line say u8, then to make struct size
> aligned they will need to add another u8, u16, u32, and name those
> fields padding or reserved. IMO, having a u8 array named padding makes
> it easier to just change array length as per the need.

This field does get replaced in the next patch. But I see your point
that if we need to pad by an amount other than u8, u16, or u32, then we
would need an array.

