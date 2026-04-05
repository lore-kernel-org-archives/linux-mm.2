Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2D8E63FE8
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423C26B0088; Sun,  5 Apr 2026 08:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4C06B0089; Sun,  5 Apr 2026 08:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311C46B008A; Sun,  5 Apr 2026 08:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22E8B6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:02:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DAAFE22D6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:02:53 +0000 (UTC)
X-FDA: 84624365826.01.6E239E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87A65A0008
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:02:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qQwwCeNj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775390571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwXIPBbp0EIzPNtpB2Kh8OUpJCymQVJw7CRWHLQnyH0=;
	b=2IUzgKZRcvxtSBHums3FpPt7WQOONAkg9vKdxxAK4qerF9G1QhOJvkdQhBiDai1F8FzcqH
	owvHk1mTsIMSmUfcfucd7IEobdYU5XVE16Vcm5T8jSE3b0zer+xyBT3Wu7TKl9KJ5LsXUm
	Y//XZjdV0JoHcrRdjmuRwCcPSAQN5k8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775390571; a=rsa-sha256;
	cv=none;
	b=G/pzC1UyGnjDYXC2iuuHssMaOrZNvgcJcqp+4yNBHqKaJT3oOXfg6VDO8HtB/se3wz8S71
	TZutwT8tVc3ejIQTJpnvn7vJg8yiiG8Gfk9Qx3FuF+Q1G2lE+sc99OfQ9CX76j4GxpMMP6
	FFjHRhwPya7KMSdlWuwBpKk6nFXKWkE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qQwwCeNj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0569436C8;
	Sun,  5 Apr 2026 12:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E64C19424;
	Sun,  5 Apr 2026 12:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775390569;
	bh=VwXIPBbp0EIzPNtpB2Kh8OUpJCymQVJw7CRWHLQnyH0=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=qQwwCeNj+saJT57yAG47jboL8X78w4/j6WpBJ1RZ4sp8PWbMz7XsL9EDbWtj55Eiv
	 28aGEHxX84zqCSRKzt5WxDYhK2mKne18FSkXEYY++OZ6+IBYaBKFZkA86MS9bLh9Oc
	 BYyORiDakrz6RnLk4LVZHvUx8P1LQpa7pCp8fHnA1nA9F6ZvrAlepEALLMXhhTHNG5
	 7JaVWay0RJB3NcEhdmqtS8VF3DnUGPXm4QkCgawXIaUT/QfRxlFCiXeEIfDZt6r6xg
	 I3uj6fM0ROLbqxk5+qZJNhPISl9Q1iNQvp6vF94UFTOtVMPHy01bKsqbxAmGzThrrM
	 mtqWeRGNpMg3w==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 05 Apr 2026 14:02:33 +0200
Message-Id: <DHL7FCNQ20PA.2K03T8MNSO9TT@kernel.org>
Subject: Re: [PATCH v4 0/9] driver core: Fix some race conditions
Cc: "Douglas Anderson" <dianders@chromium.org>, "Rafael J . Wysocki"
 <rafael@kernel.org>, "Alan Stern" <stern@rowland.harvard.edu>, "Saravana
 Kannan" <saravanak@kernel.org>, "Christoph Hellwig" <hch@lst.de>, "Eric
 Dumazet" <edumazet@google.com>, "Johan Hovold" <johan@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, "Alexander Lobakin"
 <aleksander.lobakin@intel.com>, "Alexey Kardashevskiy" <aik@ozlabs.ru>,
 "Robin Murphy" <robin.murphy@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <Frank.Li@kernel.org>, "Jason Gunthorpe"
 <jgg@ziepe.ca>, <alex@ghiti.fr>, <alexander.stein@ew.tq-group.com>,
 <andre.przywara@arm.com>, <andrew@codeconstruct.com.au>, <andrew@lunn.ch>,
 <andriy.shevchenko@linux.intel.com>, <aou@eecs.berkeley.edu>,
 <ardb@kernel.org>, <bhelgaas@google.com>, <brgl@kernel.org>,
 <broonie@kernel.org>, <catalin.marinas@arm.com>, <chleroy@kernel.org>,
 <davem@davemloft.net>, <david@kernel.org>, <devicetree@vger.kernel.org>,
 <dmaengine@vger.kernel.org>, <driver-core@lists.linux.dev>,
 <gbatra@linux.ibm.com>, <gregory.clement@bootlin.com>,
 <hkallweit1@gmail.com>, <iommu@lists.linux.dev>, <jirislaby@kernel.org>,
 <joel@jms.id.au>, <joro@8bytes.org>, <kees@kernel.org>,
 <kevin.brodsky@arm.com>, <kuba@kernel.org>, <lenb@kernel.org>,
 <lgirdwood@gmail.com>, <linux-acpi@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-aspeed@lists.ozlabs.org>,
 <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mips@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-serial@vger.kernel.org>, <linux-snps-arc@lists.infradead.org>,
 <linux-usb@vger.kernel.org>, <linux@armlinux.org.uk>,
 <linuxppc-dev@lists.ozlabs.org>, <m.szyprowski@samsung.com>,
 <maddy@linux.ibm.com>, <mani@kernel.org>, <maz@kernel.org>,
 <miko.lenczewski@arm.com>, <mpe@ellerman.id.au>, <netdev@vger.kernel.org>,
 <npiggin@gmail.com>, <osalvador@suse.de>, <oupton@kernel.org>,
 <pabeni@redhat.com>, <palmer@dabbelt.com>, <peter.ujfalusi@gmail.com>,
 <peterz@infradead.org>, <pjw@kernel.org>, <robh@kernel.org>,
 <sebastian.hesselbarth@gmail.com>, <tglx@kernel.org>,
 <tsbogend@alpha.franken.de>, <vgupta@kernel.org>, <vkoul@kernel.org>,
 <will@kernel.org>, <willy@infradead.org>, <yangyicong@hisilicon.com>,
 <yeoreum.yun@arm.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260404000644.522677-1-dianders@chromium.org>
 <2026040539-sponge-publisher-2b42@gregkh>
In-Reply-To: <2026040539-sponge-publisher-2b42@gregkh>
X-Rspamd-Queue-Id: 87A65A0008
X-Stat-Signature: tpojg9zpp77h3ps4no93kcjuyahnf4ab
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775390571-82864
X-HE-Meta: U2FsdGVkX18ipKvrwoUbb9ZXyt7nHMfo7HeOT4+IeXeBZiRiX4bgG665V9+hgXbfwYJP1jHHWW69Hcl3C0uqXJ6UZ3RmFDxjRsoZ1t7lu9MsH4xAJiTrUbBsojoIKYLQdTWlXUYpJT2lT49e2MpBtKO3cduUog3ck7AztZCWK/bH2O4pi1LkA4oOnb5xLOmPvkGL/9706jF3CBor+k49axfDtGSaNzZcC7/o7cs1QyGneL3FVFkiPJvb1e1rCGPAjN9xZBk6YJlGyj9/NLfitDZuHMicJVy7/R/OfqmzX06cynst2rBhYmTf403lnz66nUx/Kw92G9uQvkrlok6omhdLguwIroSXj+vgjZfkz++aHV69kyMFMusinO1wLWpKJ6P91ZD0eBZldmjAC1O8n9aOfolmP4zu0t1FBNAB0IwfO4AlxDkTyCqKoq0qWTVaw9ynwTwjxClMWx7TyHsTOVE4Ljz2EZ7mHE5jgUMxecqPNkwxNTk89QpJeJPyEH+VEUTA7jtrSPIeJWGxzFiCTql7ZYUEMOSbZX2iw3+o8q2bXtuCPOtkwkoOc5pBD2exb+uBS22xtAIgRql2F+LY9j1hLFZCvs+fqdt8BgHfMe23+YQV0ZFo7e6q3HbqSDUQ9DhKSbHU7OBZ5YmgQw4708CfU1w4eirNkiImRathuFG9SINRHu7gk1ETZIhriFYVzE+8+JEFKZFETlJdzLo8VEAJmkDM7u7uS5dFjoxB3QhjeO0sOBsaDvxqW/s/Pc9o7U2kGVSRm9LS2BwuKt454SMhgMv44urO+lCsiJBWSoXfD2ZmDMgs+2DIIHmf0X9xgN1usWhbrFy7gpQz/RhV5mPqNbc9UGHrrF1DDnFGo6Hs0aaM9tTlJePFmgcKDNdUrO309w+TqUvfrRTFIewmBKegRNdhabzxN1vi10cKLei9Rvt3+5ncC3iRFXxg4I/E+lHR64T45zPQCZdwMtL
 bIvrIyD9
 HCQzHvih/rcxwomoyvwFcjzrJfhi8kFhYXoAPDG1ce8yxGJRejcwDCJJs/SVYTQdtETAcexHnZS8jdM3UoAgWbmlaUPoKX2YJFjEYd3I721zszq8vsvpqLA812Oru4MdmlmqL874prqkjdYl+uE/DYghinVX7Hntpmo239fk55qaTQUNM17ciDBg+NjX4YXoFIONrI5s2sj90sHDR7HDbcFtmhQJyigFYjXaD6aF9DmSNLcWIlxMH/JO/uguG7DQR/q0aHP/EzP8XBDbwflTVRN059e73aBIHEeS98P/0yjzNEDq3JRAv+90ZKwAXojxSjQvMtFA5L5/WNZWd/VFfsnp6R+p+0xcxLmWWTv4MtkNTjUkn0SvmIyULnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Apr 5, 2026 at 7:27 AM CEST, Greg Kroah-Hartman wrote:
> Anyway, this looks great, unless there are any objections, other than
> the "needs to be undefined", which a follow-on patch can handle, I'll
> queue them up next week for 7.1-rc1.

Sounds good, for the series:

Reviewed-by: Danilo Krummrich <dakr@kernel.org>

