Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0F3CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC0A6B0088; Mon, 28 Sep 2026 13:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035116B008A; Mon, 28 Sep 2026 13:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E409A6B008C; Mon, 28 Sep 2026 13:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD5EB6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:16:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 386DD1A02A1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:16:50 +0000 (UTC)
X-FDA: 85263825780.29.74D36A6
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 644FF140004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:16:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QLYHetPy;
	spf=pass (imf09.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790615808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVlRP8UBi3QSgtgc/PjPsjRl9sO+VgQnXuH3S8lXm6s=;
	b=BGdK+oBCr8KrSFN4sI8MrV342D9oZrfS2E6CN0202Ea7QEP9R6ohjYxFl5n/T4Q0yB6ZOg
	cYR9wbT04pDLAovsFtol48y/sPFiKpB1dzrKsDWE4J76EGjApfIIxw420AL9HebeFQewEk
	MCkdhJqKyPXmxaOWEInFxFl+tfn/vvE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790615808;
	b=b7Wef6nOK9dV9LBLVEkTLQlEUsy0znGw3k/nvefXgJRZET/qjO9LQzIBbhu7nCof9lTHyV
	OFTQsyNz2vOJeHrx1lHxWAL1hFZizgR3xHc0Sh5HUVZ5A6jcJh6aWIKRSp7Ccxci9vq1QW
	avn1UIYjuluFmIvyvTlOtfsXDH8SLoA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QLYHetPy;
	spf=pass (imf09.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d3b445a84fso2805ad.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790615807; x=1791220607; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nVlRP8UBi3QSgtgc/PjPsjRl9sO+VgQnXuH3S8lXm6s=;
        b=QLYHetPyPGu1XhsW7uOKO1jhSdzqoe2erx/20UTr+MG3vXAxMAmBoY7Y+Vf2l4w2jm
         hY55vEDx7O7bG47LXBBbGDZJeDomRN7K04rjhdvaj7c9P24h5WOOT3RPlahF9NM39LSe
         VJ8hlVaIglcvAtJ4pi5Dh71YxUwuz80DZ2jt7sAIcMLnXKiBCCiQ27+uFB+dAYnXpB2H
         XYHlmEJrnkMoQO8GOjv3iUBoF1wIrurUgRUdm94hMsB+IeBjvIutPPt4RYrHFkI8VMKW
         QZz8PftVsSo76szYk9edBsMSL/30GH3HJ9mjCXpbxg5eFH7TdcFslb00oMchWY0O6OHn
         dtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615807; x=1791220607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nVlRP8UBi3QSgtgc/PjPsjRl9sO+VgQnXuH3S8lXm6s=;
        b=jtx0wMwPhjH7RcMvBqXKN6IFHhxJBS3sqq3QsWK/3ja3ELZ22STQVq12Pi3NqAG1IW
         Gvx8mLEqzmTQQEoESqN4FkSP8z8oGnBBcryWuWVmIF2oZs159/By0DcGjsEzpfjgPowv
         ZVab4/0W1KPmUN27ExC7HDT/ZbndCTqn5uze7mSRkze4FIsK3NLUvz+NJJB3X4WvMIWp
         Ec1O/sYUGOpFjlsBbetmUW3w3mKrgD9PQeFX895yQMZ1LpXFnwH6tQxIsspc9TIYMGzr
         5zso8+yM1ZSyLNC8rAvKnPYXwnhI9feasTpNJWx6gjDR8HV17yXHNoaYdA1PX2JM0Vou
         onng==
X-Forwarded-Encrypted: i=1; AKwUvBxsfUT/HitBLUpM143FXOEyqqFzHFDTYz+GSuXBZVAIWWbc6LI60j1iKEv+jYIuoN7q25m32XieSg==@kvack.org
X-Gm-Message-State: AFq9FYL0Xa/sbzjng9EIGckHCCO5REbM53xA1QIYtiSn97oo23mBBs9k
	ty2CMQaJSmGXfrkuQCTXjE1CSX6oZnq9a8YvE329ZOrsU2PU+Xoe03fzP4J7Z+xbqQ==
X-Gm-Gg: AYBFou0nQxR0uX9tpXUQljJqvo1pj2tXWBEcvaL+LK7+lr7tvx5C+dyXb7MJdO6M6DB
	Pxs+e5H5Xf3GaT3aOV1vW9P9yJWWyhO8ix7WJF1Fl+c/AaxdHCDByUKzQlWdrrSOaQdlIC6ibXo
	rmek5Vl9/fbHyHN+xYzr8ywyFDEb4CajhX17AWLnENlG7LPYmKUSuMoIQ+W9aHOUhXo6f84vYmN
	LeTeAQtMY+E4ZgdMchs7ShhfZ86aUqQXeI5NcBoCZ7ALA3d+9aT/SKN1Yq3vdIUKGnNSwGCZ+G5
	JfGaZ8ZrhsMfxmLRJHhKBKAkqtZpsNMXisMn4oUGpnCv5rfOiFg3ZTcS9TxegBM4O4JVGox4qOb
	Rt6z4INLF+LBDohuVb9jLXeDTR9T0GWLo6CqOKb+IPg8ES9Hd5K02LplxqrMFa9NkSnzVL5fKuS
	DpsMrLnZupB2n8omIOOGTwMumXwA48YgvrKPA0LvPWfGUcn7jbKY0ajHYqBHqEYFhv+6J5e/sD4
	SxGtrpvlsIJqtXhzEtw054mqs7tKSKjc8W5
X-Received: by 2002:a17:903:b48:b0:2bd:3bfd:74f1 with SMTP id d9443c01a7336-2dfa6194d00mr7813665ad.2.1790615806244;
        Mon, 28 Sep 2026 10:16:46 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a497edd76dsm520284a91.7.2026.09.28.10.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:16:45 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:16:36 +0000
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
Subject: Re: [PATCH v9 06/13] PCI: liveupdate: Preserve bus numbers during
 Live Update
Message-ID: <arqg9G8pXKPX8WCe@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200640.887030-7-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 644FF140004
X-Stat-Signature: gs1gr3roi9f6qopi5hscqbexwbwtj15b
X-HE-Tag: 1790615808-110424
X-HE-Meta: U2FsdGVkX1/8NSBjugU4MAvdto78RaVCXlC0IgKTTNoc8t5fsaen0Op8AKMJHGW+JMykGzkBIljBk0T8pj3pvCyLltjt4/tM8IizeZWxThxiMGvTPi8S+O8rNr8BMpql/REdBF5empWdx61DEx531w+pnyD0d5uM9hBPCUZhbnYYeQL6gW0UTBRQ5D3LfrtVf9Jai6KNsgbp7wNRbA36jSw2RhZTRAMwek9Hyx1jrjiTVJYtbO5dg82e7q9Mucycath/RNb6mXn9YDSDmiCVGRIIgSrVEnDi6Xj4IoyrGA0OephlpkL/Ck6WgsZaNEnkVkxoEANWPX51xRSjYutUmVXjS96z+FyrQxoPEErUWnrRXM31qq9AM7siFiD2Hz0fciOcfzenpW04aRXYf7RqBBqRmIL1nx1RrLBixx98FKuR15Gc7awTfxCIjjV+CSiTBHKANLoLZvNdrQf6wt3pzvaSG/DxmUzIKbASnZVbgkc2lUB+b7u0eJl85EKT/9Xy3SyImmSZz9mMP4exTN/lJSphvRFyy1JP4kkmPAWMrNns9l5JZL1x1C0R77QbcjFhW31lPG4XVRc3WeP4Q/xiWS8pgN5uq+n68LTjA39xroV88huKvOh1clrhzmW6TQBIHPbkLsCaKUMAFtOwGL/jBWbeKKcQJOffeizwqjRpFX8+oFpBbyHBLN3rRmiyymfGV/L69Kwo6LinPm4AdOL+4zA7CCvNg5T7/1icwgyIsyyJIlfBoLV+g4I4Dnq9llCogbrjQvADOTQaAgX5yNKWggbhUgT9wVPGNiloQxStYIpyP6wLxcBc4m0kMAgYF+bYH0lDdmDOG5EpgeqnuyTNgGxq+qMiUHVJWnR90JUeIQnQPwFdgHWGh4LvF4hX7dxEsRMhSYQW38uf+Z5RgnIMyrHSnfiddrarkZeKx9KzPkWCn+HcYLCMD7S5e7sbI5rM2DnCs5l7cv/HalNwOoH
 WZeTZYXs
 PJlua74N001d39is+qNeHf6LxU2Fd9yxHLF42831LPCgLE0jLx+cHfof1xc7rI87AT9T0h7Rgja+mtkweOq6O0C2VWzVQEfqSoZ02d9ITWtGFoTLcFFH9+h89S/QaAGz1m8Wq46QiX3rGyOe218x0JUaXruAP/hSh5hGQUxxgiS+rnvynymj//ajBFU9A8OlGzQiZspGQd+Fy/xsLtVSHv8tiNhICMaltPU5RUuyU0+QxqZWKEjApDBoFIUhknyhoGRQ9g8z77IHlmt0MRgS+HT3ZlK+On45HQnfZe64O22xOBMYqgCV3a0jGK7JVxCFueYGQeoFm02m7AmjG5+S1/LgCp1mx1+8yLAhS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 08:06:32PM +0000, David Matlack wrote:
> Keep the secondary and subordinate bus numbers that the previous kernel
> programmed into bridges, rather than assigning new ones, if the previous
> kernel preserved any device across a Live Update. Do this even on
> architectures that would otherwise always assign bus numbers themselves,
> e.g. when pci=assign-busses is passed.
> 
> Preserved devices must be allowed to continue performing memory
> transactions across a Live Update, so the kernel cannot change the
> fabric topology. Changing the bus numbers of a bridge changes the
> RequesterIDs of the devices below it, which would require disabling and
> flushing any in-flight memory transactions first.
> 
> Apply the policy globally rather than only to the paths that contain
> preserved devices. Bus numbers have to be preserved above a preserved
> device anyway, since an upstream bridge cannot expand its window. A
> global policy matches the scope of pcibios_assign_all_busses(), and
> gives an answer that cannot change part way through the two passes of a
> bridge scan.
> 
> Bridges that do not have bus numbers are still assigned new ones, so
> hot-adding a bridge keeps working, both during and after a Live Update.
> The two-pass bridge scan guarantees such bridges are only assigned bus
> numbers above those already claimed by preserved bridges.
> 
> The exception is a bridge that was preserved but comes up without a
> valid bus number configuration, e.g. because it was reset during kexec.
> Refuse to assign it new bus numbers, since that would silently change
> the BDF of every preserved device in its hierarchy. Also refuse to
> assign bus numbers to the other bridges on the same bus, since the bus
> numbers of the failed bridge can no longer be read from hardware and
> handing them out would let an unrelated device inherit the BDF of a
> preserved device.
> 
> Require that CONFIG_CARDBUS is not enabled to enable
> CONFIG_PCI_LIVEUPDATE since preserving bus numbers on PCI-to-CardBus
> bridges requires additional work but is not a priority at the moment.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

