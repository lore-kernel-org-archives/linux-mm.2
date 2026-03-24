Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF51E9A761
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132036B0005; Tue, 24 Mar 2026 06:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1098F6B0088; Tue, 24 Mar 2026 06:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F206B0089; Tue, 24 Mar 2026 06:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E40996B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:46:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94CB61BA09E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:46:35 +0000 (UTC)
X-FDA: 84580627950.08.CE81F7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DEBD6180006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:46:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sRYV/SsW";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sRYV/SsW";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774349194; a=rsa-sha256;
	cv=none;
	b=C8kRs2wI3RZgQBtMfRE3hewqLmr1gbYWY1XMXKvhIpXTZLm+yPNyEA0f+zhnSZqGpfXXf9
	4z/7ULPGGqC0NvuUVmwcVZyh5DYqr9zgr7c9mGO6n7JWl5fB4m8nJQUg8bOTF9lD/I7TQc
	khfiaqo1K55hbp687+b3uL9V3M4hf9Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqVdPJFMLtTUeWcwojaH2PMwSrmnFcwO5JT8E/DMJNs=;
	b=brpZVFu1uUtVzRc6PPAXLic1zvoIFiijMWSLokkcYb8cnswa0ujY+QDP1tdyQPFiYQ5B7r
	8iM5n47GVMPa9Prt08G2KRxfpw/JgYZkLBwK1VAvNFZWHanNVEjLRgB8ltVArzK9PkElul
	QYN8JqljGwlEzL6KTL9gfadrNsoxEGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31A02600C4;
	Tue, 24 Mar 2026 10:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E725AC19424;
	Tue, 24 Mar 2026 10:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774349192;
	bh=WMEerWakA31QDIRRh1QiXx8aw7EYn+862Ive463FIxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sRYV/SsWeoCU4rAac48A/OHspAXPDQk8BSViRS/suRAnoU18SJsr6hr0c+5iuVxG9
	 eXHcAhdTBXsvusq4VOTea51g9RrRMxvmD/TWcRcqz4BrYpF0gGRYZANGEgFkzTzMEE
	 eB2MIMTCAoTBk/UKXYpTur9vulG+EP40W619rAh3viXt3Y1UnqorcKkeyeACDr8zZR
	 IzXjhAKe95RbXpf6iBaCEmpIYeqVFXbcBgKvmEoaxlN+h3r+B4gL0YMNRWgZLYJ3yu
	 6KTAOXFNdOqESMXeyxke3FeW9AoW1DTJYifGbrjLStiXcREPMM8ZoQvCqx+u5OeJEK
	 WIgEyQ51/Ee/w==
Message-ID: <899470f6-8b22-42a3-9dca-1a11e246147d@kernel.org>
Date: Tue, 24 Mar 2026 11:46:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/21] mm: various small mmap_prepare cleanups
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <99f408e4694f44ab12bdc55fe0bd9685d3bd1117.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <99f408e4694f44ab12bdc55fe0bd9685d3bd1117.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEBD6180006
X-Stat-Signature: dsxif5t47ta9fpc3ig4673jiat48b8nk
X-Rspam-User: 
X-HE-Tag: 1774349193-949582
X-HE-Meta: U2FsdGVkX184PJ7yr7oNz0TA4bJxoJKFGpSsYJK5kUGsXlPWJ5HdJx60p92kOqMyQmWH5jtzicLP+T/mEAzyh3XoVpqcIMtWDIEiAjsqNhvl//dCg2nWO2aW5aMKhB7kdOU+OOIFSE3c9wvm2dQ6c4Z+FP/apUuxK4itnwOKTkY3RS9Oh9ZonKP4QOzX4LWMHyNStFa32juYjRDLOFA8O2SISoyzf2C+2N5Lb20OwGZcMnqrHsXfAB+EpqkZItR8CUcbr9m6ZTzjXbq83yJJS8Z6a4u8+bxnIt4oMw9KbaU+qoKXs4IX0XdFDrgOs55HR+MoqrbQxtmLYe+uOHP8C6Kjjjm0BE987rLS8M/D+ZgMzoZkRYwitw1fOFnzctt5fNnw7L3PYkBjAfsNZoNxsAAancN6Cs/wsQCkykzh0JpNkU0g3GDggDywF3GLB+/hhOROEoAMuf086yY/JDauFY0zMvhaCUMTecvt+xnk/7nks8nHcFRVbr+/iV13oNGf3ILDiXmck2XIfn+qElr49GwLqbC9n8O4AZmzJyHirlr252J6pQ4TEinQyOAzq8yfSFcrwo4/6w4aUFyrce9AZCE687zqtjoYIExgDQTPMvJCqrvOYOrtLq4Xk9N5uDGGF9z3Qx4f5hc02th0G4KP68lbn9Utt6ZeeF85Oq0g39kwUPCXZU3rBgWTbx4DkHZAhewDfMZU7bE3gyf1lCsnChvoRMcPekbeZEZwXS4kKoYT+qfQXxh6yOwWHUFaQoayK329q9s1/edbABRHTw6RfFcz7MYvW/RX2CkrYNwV2XOlaVzLwPOrC56+lL+yOAEgqQlDD55EpCLi6+g2UGrtd7z1XCfNhb/FaU0a89ZOnWB4F0gj3+wlmUsBjHfC1NDIY1fvi9ImISdWVPVM5N66B5GiDPVqytVX0WQBnwAL4xkHavqdFFzxPXP8vWzDfZagMZghN61f0tGtk9SKurZ
 ImmYMh7O
 92GwUxqTtyIOhcBDy9HfgV0LYKu49MzF79RIZYsPk/cWUibi0f8f1lr50VjhB4cIlzVyJEPxnQZaYPwIjsjVMhlSH27wx7AafmS/EEk8rVDspPShpthczExQcbUSPKJd3fdLzcsTONDA7A8poPHLc+LXjX4+aehbPUD/c5wWW+ofMjM702QFm4OdbTdryUZ8Gslbx4WZilRfRtDjbUzfozXevGhbeSPHJKFPJYgIBBFy86oYWk1mwRL/RIVdGl3mIKnV2FjzApEEcI+KkKGmdmGGCD8JK3TUT4VwUwGPTNuBsXBSWykADtuyYidka5pNILb6qt2VntMA0AXk80YDlChrfSKJnc7yi/ouWMoZPVmA7VDUIHjq5lZt15s6GapyFdS9wHrDZ08RVAl8jf182ULRV8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Rather than passing arbitrary fields, pass a vm_area_desc pointer to mmap
> prepare functions to mmap prepare, and an action and vma pointer to mmap
> complete in order to put all the action-specific logic in the function
> actually doing the work.
> 
> Additionally, allow mmap prepare functions to return an error so we can
> error out as soon as possible if there is something logically incorrect in
> the input.
> 
> Update remap_pfn_range_prepare() to properly check the input range for the
> CoW case.
> 
> Also remove io_remap_pfn_range_complete(), as we can simply set up the
> fields correctly in io_remap_pfn_range_prepare() and use
> remap_pfn_range_complete() for this.
> 
> While we're here, make remap_pfn_range_prepare_vma() a little neater, and
> pass mmap_action directly to call_action_complete().
> 
> Then, update compat_vma_mmap() to perform its logic directly, as
> __compat_vma_map() is not used by anything so we don't need to export it.
> 
> Also update compat_vma_mmap() to use vfs_mmap_prepare() rather than
> calling the mmap_prepare op directly.
> 
> Finally, update the VMA userland tests to reflect the changes.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



