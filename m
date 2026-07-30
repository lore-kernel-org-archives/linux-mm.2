Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE5DC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D720E6B008A; Thu, 30 Jul 2026 03:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4AA16B008C; Thu, 30 Jul 2026 03:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87196B0095; Thu, 30 Jul 2026 03:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD79F6B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:54:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3332416087A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:54:02 +0000 (UTC)
X-FDA: 85044679524.08.57BD49C
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf25.hostedemail.com (Postfix) with ESMTP id 718A2A0011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:53:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GCtbApEQ;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785398039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8v0CBrzuIg3GbnT2uYqPiocpv9EQhDpNnWNDIDzVjY=;
	b=Dbv+v1YdaO0NAhzeTlNvOi7nR4ZC8Z8B2oMxLmTXGcY9DaYbydEg7b7FI3npdpOyDdgPlv
	YLpnUa20q+J+S9DKKOBCQPz5RIxE5CMV6G6J/CWy/mrpeiYxJogc/9/lTrGpAQFRCl74g6
	M1tPnSDh+U6RoT98+Le6j4QvFWMF5UA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785398039;
	b=zBagPTTwqKM7rSL5Nz3SLNqBRktki9qpoTFUWxtMhKwr792QC3KECMkQwWWA/Jn1Qr1Lhn
	JXilWyw/QTKvN0Rgo4uzB7yigXbwnqZYonfvHUIsghNopbxktn0G2sDRveVmXYLGpBbyls
	Tx0iWGm0H6FPJuqVdQtI8gD9HU44Bns=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GCtbApEQ;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785398035; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=i8v0CBrzuIg3GbnT2uYqPiocpv9EQhDpNnWNDIDzVjY=;
 b=GCtbApEQtBTGYbAgBgzoKQTm7pt4C94MpHglYJgc5VBdi/BAuXU6MkZRWAmIoO+XE1hTsW
 +3NqA34XlN0IJjM/qDX07PRwD3I9f+cfzn6LGZNm4fi/04urEwWoosh0JgUBAf7Db4y6TB
 fkJRy5EAVk1B23acCjCdhtTRipLJEc1DuAQTd0V41sYWMlvovwvK/QiIp22+v3RXA5Cd/l
 7sKQwJNZxY/+qoUBrL+ilxA+LmBiruHVMIxQrgOug8Kn4oRmhFw4h/5kUdt477jcEMZ6W0
 QKYynbVpHS0FfoCpu3UQqZnlgWVx9RTEunDaodI80mJX4W1zwGzQpCFZvrY5sw==
To: "Mike Rapoport" <rppt@kernel.org>
Subject: Re: [PATCH v7 0/9] mm: optimize zone-device memmap initialization
Message-Id: <d68f7091-60ae-4887-88f0-42f4288b8e52@bytedance.com>
Date: Thu, 30 Jul 2026 15:53:22 +0800
X-Lms-Return-Path: <lba+26a6b0308+26efac+kvack.org+lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
References: <20260720120259.1545-1-lizhe.67@bytedance.com> <20260720120259.1545-2-lizhe.67@bytedance.com> <178525732062.1556190.314794914123127147.b4-review@b4>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <muchun.song@linux.dev>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <178525732062.1556190.314794914123127147.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 718A2A0011
X-Stat-Signature: 3nitnbiigzed4qrross99k8bon3cw8um
X-HE-Tag: 1785398038-459221
X-HE-Meta: U2FsdGVkX19fNpxv0cRJntpuzGMK8jWF/BeVJ0W/fjvqlD7KWJxhIc9N6stczCV8CtsTF6AEDbYN5Qx+psBOfdtxSvUwTYNOrzn4oygDj22UW4FqEvSWx2k3h3u/+HpSuVTWLfQ1TRsicY31SJC90/VUwYT8MLB1DEP1+oI3YW0yf7bJKfz7a3oaJVOfbZ0RhxRhQTmGkwVcfyX5dXayjl/b+ArDJUGU21sNQHDxd80YRNCp01+4bj0/8EMo8xOSt7PnN8gkGhxBR+GHeRZUk8iDFLfddbfM9ll+Re9BhO0LUP+jeulmHKRScaU++dPY/w5z2PXKCgH5Be024CYHL2xdvsDdEM78aAB7NTSUyvfYwi8fA5fmsPIB3Wflp0X6e+EelhKDX+QpCP55j9ec/lsZZTi0sUrVSL4xXLgSQcyVT8DA47nCOnLSTHw2/Ag1eohhK2c7Zrfta4NI0/O8zc4OthN3/geq+ddSvQ/zgNQE1rJKuI3mFDYs1XghI+x0/lRwfivE1FbDyV9qwVzf8kogJyMjdnv1qWRO0mBsj69XDHuy8db9kq1Qyrd67TGkrbxgN7F0umJvnW4Up1H4BDPIkTwmEVv/pQzDnj09pd+NW7gtGGaJbXsaIE0TtuKNi1rbtLd57/sm0vWUEC9vqYPDt8zEoN7pMrhO/3Yhhf6kWVgIKFEzOnKmu6NN5wtao4523iN86jHCPCWCdymbAcloXKZr6M9LHkQ+1t0xHDowx2WcoDhDL2rNK+w9uHySxJxQmHQU1DzzMvNtPqOQh3OkLwNjKFW16ZgImXq8a62jkBf+WQEhWASoaxigxuHfUJ+WXnXmelWC7scfVUDqEhg6yA0RWwQLnkcvoivc0sjhIoQy+EWNQMrDonjZSfMjOQVXVylJHvOX/KI9NStnKei5ti/wtrOdL3ATiPqX5MWVrWyCAUU7c1lB13wp8hr+f+sGL1NoUR70bhq5xx9
 Ib8l2yXi
 Rt0EtIvPrMJLS4eAxjuqJoscJVvpE7Oy5B9tvb4e+IDivsVwge/vqm8yFdzJb0okTnn0fKR0zPE0FDAVxs1cgg7rPTs1fAHmAQBAaK+1UP+Z1ZFhVNR+nMouFgzIjdSlzVnv2KsmCd2yzWFVv4CjA9heytLVelqiR7qFwlrztww5DhES40ps0yIjrKgW0psDyTbukzrdIFDPcEKsFwcJzqB8DRNtCnJNP+U18Aju6Znr2UGub21JUcw17fC6OBPe+i1k/dtbLPi+cRDyu7AagPJI2T68k4t85euCPWcGxZtSZCaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 12:48 AM, Mike Rapoport wrote:
>> The numbers below measure the time spent in memmap_init_zone_device()
>> during driver bind/rebind. They are not measurements of the full
>> nd_pmem or dax_pmem bind/rebind operation.
>>
>> Tested in a VM with a 100 GB fsdax namespace device configured with
>> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
>> server.
> Since the first pathes touch the generic part of the memory map
> initialization, it would be nice to make sure they don't regress other
> architectures.


Thanks for pointing this out.

I was able to get temporary access to an arm64 environment and have
tested the generic template changes there as well. I will add the arm64
test result to the v9 cover letter.

Thanks,
Zhe

