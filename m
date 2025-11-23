Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1031CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 15:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B746B0010; Sun, 23 Nov 2025 10:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC766B009D; Sun, 23 Nov 2025 10:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1CF46B00B0; Sun, 23 Nov 2025 10:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC0E76B0010
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:48:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D5F41A0910
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:48:19 +0000 (UTC)
X-FDA: 84142303518.01.9E45BA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E639F40012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:48:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwmBbpCf;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763912897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xprb9sN9U15WUIFyZC5rcnGUo+YD9mERduN2wuSaO24=;
	b=HQ/WDwcrMGWgBzfAawjmnoaekhIZWnVBv3A1eG/7kcIM8KPxUwN8BBvMMCK52ODVQZi7on
	IQElHCSn6aY/kAUjurlXhTIta5SV97LZMujZO4Gm6I3ipvEj9QqlZfbvVEg6UFb3WDpX/2
	iCSnq72HT/YWTw2NNmOnI0QoFhrCBfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763912897; a=rsa-sha256;
	cv=none;
	b=u1LJhOJdDSudPCKxDm96LpFVknmPP+S45pFgsiBX1WY8a3zLvxPmiel4T7H6W3DtzqHp+w
	m7ve6aTsdDTcJKuzbO1lRYgZearhJeh5XY6xG5+tA7XirMGOyryxvFPugaeIpuVwGhOZdG
	jpLjOh8nILcsRcnD95LDdsWFombVVo4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwmBbpCf;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 034C560197;
	Sun, 23 Nov 2025 15:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8D3C113D0;
	Sun, 23 Nov 2025 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763912896;
	bh=o5jgDCNTQXVfP4NRsI3yDEVhzmocDH9FvcpdxoKKU7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FwmBbpCfluPNbVa8nNxo6qv3CPg0ynY53dii+jFo759U2j2PAl5zeYmMh6E0JMmPE
	 WwQpU6awV4qjEG5YxIwCRw4y/63MIxWorq1LmMs1/LKoONkHSSD3bEHobrUldnrFet
	 asluAC12CMOLpH/awxcqBQtCuel236oFDPMgCPkjjCkWS4yuB+7o8J80uY8GPTGfnO
	 plEEB3X7ErYve841jf0cyBHV+SsmHnhw2xsC5ZhkJfQ4u2+/tXjuGdsXZDi3B/6Pa9
	 dfKYcuPNcyq4pk7JqWEnQT+r2TfKtLTkX0MGEj2KVmiJpZ1loep4NwxtG/3KgfeoSr
	 9eG3ny7UxekUg==
Date: Sun, 23 Nov 2025 17:47:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 14/22] mm: memfd_luo: allow preserving memfd
Message-ID: <aSMsqD5mB2mHHH9v@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-15-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-15-pasha.tatashin@soleen.com>
X-Stat-Signature: hryfriox6ic6fk9zwz7qfwxqbabuimyu
X-Rspam-User: 
X-Rspamd-Queue-Id: E639F40012
X-Rspamd-Server: rspam01
X-HE-Tag: 1763912897-156074
X-HE-Meta: U2FsdGVkX18U1OHtvxBRPRNI7s4xY1W67N3bL75LmrDTTuOcky99KcVbf+3M0jLvAHYykcTVROTbKfiMPj9qXU4tf+p57XmN05Vik2XQIE6Y+cDA+xjizXUFn4rlk1kqrHgDnuM1veG8TGAxinI2P05XL0kvvjLIHADtGFoulDPJBJBja4/0e5vtRoE6hTPfTStCJDRO+rGB2xNz0HsMhRbAC3OsFQ+xn8f99cjvnyYbmp7J0qd04vtgrR3vnP8QP9DXzmQ29sRxKvhYPtD6T2gmDIXe0j+AB46OsA20eaaesxSxtk/ZjQB+hE1lGHXpROOAKRCTZUM44w404+4sdZ/5TxsMwUzligORvrDBx8MDEii9iMRCzMPj+4bj1bqG5gTXGGvPJnwplLtJna6NIQjemKJbVRlXcWgiZwWY/uBOXoxS4wI/Aj3Zfr2+atSDdsJZzbC00nQteIOM44XEqaTpZ9tSezYBZUlRmsKllRkPNyYjW0UYiZ7Ly3FPO5giP6zCFJa38kXa+A6pO5maXldpNWomh6LVZNMGZYk0WSg35XWTXG0RxqS1bjw2h8vyU8WHG1vDy5de3X9/4LERgPiK5w4iR1gqgxoG7lS3C7VpR1DRbmKlK5p8kvopjcrahtMjU4DfxtX79vzU1qCxJqr1LNBwQS4jNQ19COjqBu3jZF6Lx3bEe805eU8hVPygOY0MDF5/zWrQIjJTQ9eFwpjJfrdluDbxcDc+EUVhYDWV961eNHXK0Sai++pDYvzmx+VY83Qlbhv4zf5L+ptNRkql6zDVA5+2Wd+k2WbieJeTC4UCAIcAwU6QGyhhD9LeD8b4/bhG7hmHjtqQZwmIW8lYEO3N9nsFabi6Ry2v4XRrEco1w3Jvvthb9+JIBPyrwp6qnsGik2toqYNcWqgDrLl+zLYPV/t9/Em1wUbP3smZ/Kc5h3am+IsD1NQhv/KthVrrb9cQJCn3im3bCcR
 1VubhflM
 o+exl4mW2EC7HWvWND9NLp4kh4cAry/GX5U6ul+iS8sX7HOqcSBtcoHoqDqfaACbtPpV0hGE0iF5IHQ++TD3ONSXJYtltKfmB1W1UwZKdUiGgHnM9FHuDZn34e1/v7ogaToatGSqp9/JNQLqOVbPbzzR13WMl/OcGRtiCtzedfIcnrOigt5lGoR58Utv2Oaaej1K9b40wmFrFSNfA35jMu7eIUEvOiozyxSUhljgKTD2ZwS36IXO+ic4Fz7HaKYZBQwhyMFbDnQl8ek2cMtnsjqUqdYON3pHg9HwH2vwHEmfVMtY7h2p2Mt31vXuBY9f2j/MwD/gpJ7V77DzSSUYnoto48g4xFOy7EHTFJVOR3sTB1MZxgwJhSk9sjNEn70X1GaAWMfwzn7knj0qyMgyH7X3AmM1uHJJ1oug32d8xxG5V/RZmPWzzyv8gKZEt3B7BdELw+3gqVZlBYEo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:41PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> The ability to preserve a memfd allows userspace to use KHO and LUO to
> transfer its memory contents to the next kernel. This is useful in many
> ways. For one, it can be used with IOMMUFD as the backing store for
> IOMMU page tables. Preserving IOMMUFD is essential for performing a
> hypervisor live update with passthrough devices. memfd support provides
> the first building block for making that possible.
> 
> For another, applications with a large amount of memory that takes time
> to reconstruct, reboots to consume kernel upgrades can be very
> expensive. memfd with LUO gives those applications reboot-persistent
> memory that they can use to quickly save and reconstruct that state.
> 
> While memfd is backed by either hugetlbfs or shmem, currently only
> support on shmem is added. To be more precise, support for anonymous
> shmem files is added.
> 
> The handover to the next kernel is not transparent. All the properties
> of the file are not preserved; only its memory contents, position, and
> size. The recreated file gets the UID and GID of the task doing the
> restore, and the task's cgroup gets charged with the memory.
> 
> Once preserved, the file cannot grow or shrink, and all its pages are
> pinned to avoid migrations and swapping. The file can still be read from
> or written to.
> 
> Use vmalloc to get the buffer to hold the folios, and preserve
> it using kho_preserve_vmalloc(). This doesn't have the size limit.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---

...

> +static int memfd_luo_retrieve_folios(struct file *file,
> +				     struct memfd_luo_folio_ser *folios_ser,
> +				     u64 nr_folios)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct address_space *mapping = inode->i_mapping;
> +	struct folio *folio;
> +	long i = 0;
> +	int err;
> +
> +	for (; i < nr_folios; i++) {
> +		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +		phys_addr_t phys;
> +		u64 index;
> +		int flags;
> +
> +		if (!pfolio->pfn)
> +			continue;
> +
> +		phys = PFN_PHYS(pfolio->pfn);
> +		folio = kho_restore_folio(phys);
> +		if (!folio) {
> +			pr_err("Unable to restore folio at physical address: %llx\n",
> +			       phys);
> +			goto put_folios;
> +		}
> +		index = pfolio->index;
> +		flags = pfolio->flags;
> +
> +		/* Set up the folio for insertion. */
> +		__folio_set_locked(folio);
> +		__folio_set_swapbacked(folio);
> +
> +		err = mem_cgroup_charge(folio, NULL, mapping_gfp_mask(mapping));
> +		if (err) {
> +			pr_err("shmem: failed to charge folio index %ld: %d\n",
> +			       i, err);
> +			goto unlock_folio;
> +		}
> +
> +		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
> +					      mapping_gfp_mask(mapping));
> +		if (err) {
> +			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
> +			       i, err);
> +			goto unlock_folio;
> +		}
> +
> +		if (flags & MEMFD_LUO_FOLIO_UPTODATE)
> +			folio_mark_uptodate(folio);
> +		if (flags & MEMFD_LUO_FOLIO_DIRTY)
> +			folio_mark_dirty(folio);
> +
> +		err = shmem_inode_acct_blocks(inode, 1);
> +		if (err) {
> +			pr_err("shmem: failed to account folio index %ld: %d\n",
> +			       i, err);
> +			goto unlock_folio;
> +		}
> +
> +		shmem_recalc_inode(inode, 1, 0);
> +		folio_add_lru(folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return 0;
> +
> +unlock_folio:
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	i++;
 
I'd add a counter and use it int the below for loop.

> +put_folios:
> +	/*
> +	 * Note: don't free the folios already added to the file. They will be
> +	 * freed when the file is freed. Free the ones not added yet here.
> +	 */
> +	for (; i < nr_folios; i++) {
> +		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +
> +		folio = kho_restore_folio(pfolio->pfn);
> +		if (folio)
> +			folio_put(folio);
> +	}
> +
> +	return err;
> +}

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

